#!/usr/bin/env bash
#
#  auto-install.sh
#
#  A single‑shot installer for the CTSS + ELIZA environment.
#  It is intended to be run on macOS or Linux.
#
#  Usage:
#     chmod +x auto-install.sh
#     ./auto-install.sh
#
#  The script will:
#     •  build the s709 emulator binaries
#     •  build the CTSS kit
#     •  create the virtual disks
#     •  compile the ELIZA/SLIP libraries
#     •  upload all source files
#     •  set up the CTSS user accounts
#     •  create the ELIZA executable
#     •  report success and how to start CTSS
#
#  If any step fails the script will abort immediately.
#
set -euo pipefail

# ------------------------------------------------------------------
# Helper functions
# ------------------------------------------------------------------
log() { echo -e "\e[1;34m[auto-install] $1\e[0m"; }
err() { echo -e "\e[1;31m[auto-install] ERROR: $1\e[0m" >&2; exit 1; }

# ------------------------------------------------------------------
# 1. Make sure we are in the repository root
# ------------------------------------------------------------------
if [[ ! -f env.sh ]]; then
    err "env.sh not found – run from repository root"
fi
source env.sh

# ------------------------------------------------------------------
# 2. Install the s709 emulator binaries
# ------------------------------------------------------------------
log "Building s709 binaries..."
make-binaries
log "s709 binaries built."

# ------------------------------------------------------------------
# 3. Build the virtual disks
# ------------------------------------------------------------------
log "Creating virtual disks..."
make-disks
log "Disks created."

# ------------------------------------------------------------------
# 4. Format the disks and install the disk loader
# ------------------------------------------------------------------
log "Formatting disks – press Enter for each prompt and then 'q'..."
format-disks
log "Installing disk loader..."
install-disk-loader
log "Disk loader installed."

# ------------------------------------------------------------------
# 5. Install CTSS
# ------------------------------------------------------------------
log "Installing CTSS – press Enter for each prompt and then 'q'..."
installctss
log "CTSS installed."

# ------------------------------------------------------------------
# 6. Set up ELIZA and SLIP users and upload source
# ------------------------------------------------------------------
log "Adding ELIZA and SLIP users..."
add-eliza-users
log "Uploading all source files..."
upload-all
log "Source files uploaded."

# ------------------------------------------------------------------
# 7. Build the SLIP library and ELIZA executable
# ------------------------------------------------------------------
log "Compiling SLIP library – press Enter for each prompt and then 'q'..."
login slip <<< "slip"$'\n'"slip"$'\n'"RUNCOM MAKE"$'\n'"q"$'\n'
log "Compiling ELIZA – press Enter for each prompt and then 'q'..."
login eliza <<< "eliza"$'\n'"eliza"$'\n'"RUNCOM MAKE"$'\n'"q"$'\n'
log "ELIZA compiled."

# ------------------------------------------------------------------
# 8. Final check
# ------------------------------------------------------------------
log "All steps completed successfully!"
log "To start the CTSS emulator, run: runctss"
log "Then telnet to localhost port 7094 and log in as any of the CTSS users."
log "Example: telnet 0 7094   then   login eliza   and   r eliza"
log "Enjoy!"
