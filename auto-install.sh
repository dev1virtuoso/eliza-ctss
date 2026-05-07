#!/usr/bin/env bash
set -euo pipefail

log() { echo -e "\e[1;34m[auto-install] $1\e[0m"; }
err() { echo -e "\e[1;31m[auto-install] ERROR: $1\e[0m" >&2; exit 1; }

if [[ ! -f env.sh ]]; then err "env.sh not found – run from repository root"; fi
source env.sh

log "Building s709 binaries..."
make-binaries
log "s709 binaries built."

log "Creating virtual disks..."
make-disks
log "Disks created."

log "Formatting disks – press Enter for each prompt and then 'q'..."
format-disks
log "Installing disk loader..."
install-disk-loader
log "Disk loader installed."

log "Installing CTSS – press Enter for each prompt and then 'q'..."
installctss
log "CTSS installed."

log "Adding ELIZA and SLIP users..."
add-eliza-users
log "Uploading all source files..."
upload-all
log "Source files uploaded."

log "Compiling SLIP library – press Enter for each prompt and then 'q'..."
./run-telnet.sh slip slip "RUNCOM MAKE"
log "Compiling ELIZA – press Enter for each prompt and then 'q'..."
./run-telnet.sh eliza eliza "RUNCOM MAKE"
log "ELIZA compiled."

log "All steps completed successfully!"
log "To start the CTSS emulator, run: runctss"
log "Then telnet to localhost port 7094 and log in as any of the CTSS users."
log "Example: telnet 0 7094   then   login eliza   and   r eliza"
log "Enjoy!"
