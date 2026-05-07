function Log { param([string]$Msg) Write-Host "[auto-install] $Msg" -ForegroundColor Cyan }
function Err { param([string]$Msg) Write-Host "[auto-install] ERROR: $Msg" -ForegroundColor Red; exit 1 }

if (-not (Test-Path -Path ".\env.sh")) { Err "env.sh not found – run from repository root" }
& .\env.sh

Log "Building s709 binaries..."
& .\make-binaries.ps1
Log "s709 binaries built."

Log "Creating virtual disks..."
& .\make-disks.ps1
Log "Disks created."

Log "Formatting disks – press Enter for each prompt and then 'q'..."
& .\format-disks.ps1
Log "Installing disk loader..."
& .\install-disk-loader.ps1
Log "Disk loader installed."

Log "Installing CTSS – press Enter for each prompt and then 'q'..."
& .\installctss.ps1
Log "CTSS installed."

Log "Adding ELIZA and SLIP users..."
& .\add-eliza-users.ps1
Log "Uploading all source files..."
& .\upload-all.ps1
Log "Source files uploaded."

Log "Compiling SLIP library – press Enter for each prompt and then 'q'..."
.\run-telnet.ps1 -User slip -Pass slip -Command "RUNCOM MAKE"
Log "Compiling ELIZA – press Enter for each prompt and then 'q'..."
.\run-telnet.ps1 -User eliza -Pass eliza -Command "RUNCOM MAKE"
Log "ELIZA compiled."

Log "All steps completed successfully!"
Log "To start the CTSS emulator, run: runctss"
Log "Then telnet to localhost port 7094 and log in as any of the CTSS users."
Log "Example: telnet 0 7094   then   login eliza   and   r eliza"
Log "Enjoy!"
