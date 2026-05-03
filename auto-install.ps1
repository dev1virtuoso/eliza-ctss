@'

# The telnet port to connect to when CTSS is running. Change here if
# desired.
$env:PORT = 7094

$env:PATH = "ctss/scripts;ctss/bin;eliza/bin;" + $env:PATH
$env:TAPE = "ctss/tape"
$env:CMD  = "ctss/cmd"
$env:DASD = "dasd"
$env:OUTPUT = "output"
$env:TMP = "tmp"
New-Item -ItemType Directory -Force -Path $env:TMP | Out-Null

Write-Host "CTSS environment set. DASD=$env:DASD PORT=$env:PORT"
'@ | Out-File -Encoding utf8 env.ps1

$dirs = @('dasd', 'output', 'tmp')
foreach ($d in $dirs) {
    New-Item -ItemType Directory -Force -Path $d | Out-Null
}
Write-Host "Directories created (dasd, output, tmp)."

function Extract-IfNeeded {
    param(
        [Parameter(Mandatory)]
        [string]$Url,
        [Parameter(Mandatory)]
        [string]$Dest
    )
    if (-Not (Test-Path $Dest)) {
        Write-Host "Downloading $Url ..."
        $tmp = "$Dest.tar.gz"
        try {
            Invoke-WebRequest -Uri $Url -OutFile $tmp -UseBasicParsing -ErrorAction Stop
        } catch {
            Write-Error "Download failed: $_"
            exit 1
        }
        Write-Host "Extracting to $Dest ..."
        New-Item -ItemType Directory -Force -Path $Dest | Out-Null
        if (Get-Command tar -ErrorAction SilentlyContinue) {
            tar -xzf $tmp -C $Dest --strip-components=1
        } else {
            # Fallback for plain Windows
            Expand-Archive -Path $tmp -DestinationPath $Dest -Force
        }
        Remove-Item $tmp -Force
        Write-Host "Done."
    } else {
        Write-Host "$Dest already exists – skipping."
    }
}

$s709Url = "https://cozx.com/dpitts/tarballs/ibm709x/s709-2.4.3.tar.gz"
$ctssUrl = "https://cozx.com/dpitts/tarballs/ibm709x/ctss-1.0.7.kit.tar.gz"
$utilsUrl = "https://cozx.com/dpitts/tarballs/ibm709x/utils-1.1.14.tar.gz"

Extract-IfNeeded -Url $s709Url -Dest "s709"
Extract-IfNeeded -Url $ctssUrl -Dest "ctss"
Extract-IfNeeded -Url $utilsUrl -Dest "utils"

Write-Host @"
Environment set up!
  1. Source the env.ps1:          .\env.ps1
  2. Build the binaries:         make-binaries
  3. Format & install:           make-disks ; format-disks ; install-disk-loader
  4. Install CTSS:               installctss
  5. Add users:                  add-eliza-users
  6. Upload source:              upload-all

Now you can start CTSS with:
  runctss
"@
