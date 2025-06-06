#!/usr/bin/expect

# Usage: ./telnet.sh

# Note: If you're trying to work out the syntax, it's TCL

# Traditionally speaking, expect should wait for a known input.
# Unfortunately, the OS returns text which varies between runs
# and with odd timings so the current solution is:
# 1. Wait, expecting a known response (e.g. "CTSS BEING USED")
# 2. Sleep for a second or two (to let the "W 1334.5", e.g., to appear)
# 3. Continue
# User name and passwords are issued only with a sleep

set timeout 10

spawn telnet 0 7094

proc sendCredentials {username password} {
    send $username
    send "\r"
    sleep 1
    send $password
    send "\r"
}

proc runCommand {command completion} {
    # Prompt is this text, and something arbitrary
    expect "CTSS BEING USED"
    sleep 1

    send $command
    send "\r"

    expect $completion
    sleep 1
}


# Login steps
expect "READY."  # Sometimes it will timeout here, so be patient

sendCredentials "login sysdev" "system"
runCommand "runcom mkhuge" "MKHUGE HAS BEEN RUN"

sendCredentials "login slip" "slip"
runCommand "runcom make" "MAKE HAS BEEN RUN"

# And onto Eliza
sendCredentials "login eliza" "eliza"
runCommand "runcom make" "MAKE HAS BEEN RUN"

send "r eliza\r";

expect "WHICH SCRIPT DO YOU WISH TO PLAY"
sleep 1

send "100\r";

# Drop back so the user can type stuff
# e.g. Men are all alike. (followed by TWO returns)
interact
