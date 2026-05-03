<#
.SYNOPSIS
    Auto‑install script for the CTSS / ELIZA repo on Windows.
.DESCRIPTION
    Creates the same env.ps1 file used by the repo, sets up
    required directories, and optionally downloads the s709 emulator
    and ctss‑kit if they are not yet present.
.NOTES
    Author: Rupert Lane   <rupert@timereshared.com>
    License: CC0
#>

# ──────────────────────────────────────────────────────
#  1. Create env.ps1 that mirrors the shipped env.sh
# ──────────────────────────────────────────────────────
@'
# Source this into PowerShell to set up PATH and locations of disks,
# tapes etc
#
# Run this from the root directory of the repo, and then execute all
# commands from there.

# The telnet port to connect to when CTSS is running. Change here if
# desired.
$env:PORT = 7094

# You should not generally need to change any of these
$env:PATH = "ctss/scripts;ctss/bin;eliza/bin;" + $env:PATH
$env:TAPE = "ctss/tape"
$env:CMD  = "ctss/cmd"
$env:DASD = "dasd"
$env:OUTPUT = "output"
$env:TMP = "tmp"
New-Item -ItemType Directory -Force -Path $env:TMP | Out-Null

Write-Host "CTSS environment set. DASD=$env:DASD PORT=$env:PORT"
'@ | Out-File -Encoding utf8 env.ps1

# ──────────────────────────────────────────────────────
#  2. Create the required directories
# ──────────────────────────────────────────────────────
$dirs = @('dasd', 'output', 'tmp')
foreach ($d in $dirs) {
    New-Item -ItemType Directory -Force -Path $d | Out-Null
}
Write-Host "Directories created (dasd, output, tmp)."

# ──────────────────────────────────────────────────────
#  3. Optional: Download s709, ctss‑kit and utils if missing
# ──────────────────────────────────────────────────────
function Extract-IfNeeded {
    param([string]$Url, [string]$Dest)
    if (-Not (Test-Path $Dest)) {
        Write-Host "Downloading $Url ..."
        $tmp = "$Dest.tar.gz"
        Invoke-WebRequest -Uri $Url -OutFile $tmp
        Write-Host "Extracting to $Dest ..."
        New-Item -ItemType Directory -Path $Dest | Out-Null
        tar -xzf $tmp -C $Dest --strip-components=1
        Remove-Item $tmp
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

# ──────────────────────────────────────────────────────
#  4. Final message
# ──────────────────────────────────────────────────────
Write-Host @"
✔️  Environment set up!
    1️⃣  Source the env.ps1:   .\env.ps1
    2️⃣  Build the binaries:  make-binaries
    3️⃣  Format & install:    make-disks ; format-disks ; install-disk-loader
    4️⃣  Install CTSS:        installctss
    5️⃣  Add users:          add-eliza-users
    6️⃣  Upload source:      upload-all

Now start CTSS with:
    runctss

Happy ELIZA‑ming!  🎉
"@
