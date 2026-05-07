#!/usr/bin/env bash
set -euo pipefail

USER="$1"
PASS="$2"
CMD="$3"

until nc -z -w1 localhost 7094; do sleep 1; done

printf "login %s\r\n%s\r\n%s\r\nlogout\r\n" "$USER" "$PASS" "$CMD" | telnet 0 7094

log "ELIZA compiled."

log "All steps completed successfully!"
log "To start the CTSS emulator, run: runctss"
log "Then telnet to localhost port 7094 and log in as any of the CTSS users."
log "Example: telnet 0 7094   then   login eliza   and   r eliza"
log "Enjoy!"