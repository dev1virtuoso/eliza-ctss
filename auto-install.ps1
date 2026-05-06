<# 
    auto-install.ps1
    PowerShell equivalent of auto-install.sh.
    Intended for Windows users.
#>

# Stop on first error
$ErrorActionPreference = "Stop"

function Log {
    param([string]$Msg)
    Write-Host "[auto-install] $Msg" -ForegroundColor Cyan
}

function Err {
    param([string]$Msg)
    Write-Host "[auto-install] ERROR: $Msg" -ForegroundColor Red
    exit 1
}

# 1. Verify we are in the repository root
if (-not (Test-Path "env.sh")) {
    Err "env.sh not found – run from repository root"
}
. .\env.sh

# 2. Build s709 binaries
Log "Building s709 binaries..."
make-binaries
Log "s709 binaries built."

# 3. Build virtual disks
Log "Creating virtual disks..."
make-disks
Log "Disks created."

# 4. Format disks and install loader
Log "Formatting disks – press Enter for each prompt and then 'q'..."
format-disks
Log "Installing disk loader..."
install-disk-loader
Log "Disk loader installed."

# 5. Install CTSS
Log "Installing CTSS – press Enter for each prompt and then 'q'..."
installctss
Log "CTSS installed."

# 6. Setup users and upload source
Log "Adding ELIZA and SLIP users..."
add-eliza-users
Log "Uploading all source files..."
upload-all
Log "Source files uploaded."

# 7. Compile SLIP library
Log "Compiling SLIP library – press Enter for each prompt and then 'q'..."
# We use a telnet session to run the commands
telnet 0 7094 | Out-Null
# The following uses a simple helper: `run-telnet.ps1` (see below)
.\run-telnet.ps1 -User slip -Password slip -Command "RUNCOM MAKE"
Log "SLIP compiled."

# 8. Compile ELIZA
Log "Compiling ELIZA – press Enter for each prompt and then 'q'..."
.\run-telnet.ps1 -User eliza -Password eliza -Command "RUNCOM MAKE"
Log "ELIZA compiled."

# 9. Success message
Log "All steps completed successfully!"
Log "To start the CTSS emulator, run: runctss"
Log "Then telnet to localhost port 7094 and log in as any of the CTSS users."
Log "Example: telnet 0 7094   then   login eliza   and   r eliza"
Log "Enjoy!"
