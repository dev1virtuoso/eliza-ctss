Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

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