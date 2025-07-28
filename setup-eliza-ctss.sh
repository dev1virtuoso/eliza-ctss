#!/bin/bash

set -e

if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)" || eval "$(/usr/local/bin/brew shellenv)"
else
    echo "Updating Homebrew..."
    brew update
fi

echo "Installing dependency tools..."
brew install telnet git make gcc python3 expect

REPO_URL="https://github.com/dev1virtuoso/eliza-ctss.git"
if [ ! -d "eliza-ctss" ]; then
    echo "Cloning eliza-ctss repository..."
    git clone "$REPO_URL"
fi
cd eliza-ctss

echo "Setting up environment..."
source env.sh

for cmd in make-binaries make-disks; do
    echo "Running $cmd..."
    $cmd
done

echo "Automating format-disks..."
expect -c '
    set timeout 60
    spawn format-disks
    expect {
        "Press Enter to continue" { send "\r"; exp_continue }
        "Press q to quit" { send "q\r" }
        eof
    }
'
echo "Automating install-disk-loader..."
expect -c '
    set timeout 60
    spawn install-disk-loader
    expect {
        ".st" { send "q\r" }
        eof
    }
'



for cmd in installctss add-eliza-users upload-all; do
    echo "Running $cmd..."
    $cmd
done

echo "Start CTSS"
runctss

echo "Please do not close this window until you want to stop CTSS"
echo "Setup complete! Please follow these steps:"
echo "1. Open a new terminal and connect via telnet: 'telnet 0 7094'"
echo "2. Follow steps 6-15 in README.md to log in and run ELIZA"
echo "To stop CTSS, run './shutdown-ctss.sh' or manually stop the emulator."

echo "Starting CTSS..."
runctss

sleep 5

read -p "Do you want to automatically connect to CTSS via telnet and run ELIZA? (y/n): " answer
if [ "$answer" = "y" ]; then
    echo "Connecting to CTSS via telnet and running ELIZA..."
    expect -c '
        set timeout 60
        spawn telnet 0 7094
        expect "login" { send "sysdev\r" }
        expect "Password" { send "system\r" }
        expect "READY" { send "runcom mkhuge\r" }
        expect "MKHUGE HAS BEEN RUN" { send "login slip\r" }
        expect "Password" { send "slip\r" }
        expect "READY" { send "runcom make\r" }
        expect "MAKE HAS BEEN RUN" { send "login eliza\r" }
        expect "Password" { send "eliza\r" }
        expect "READY" { send "runcom make\r" }
        expect "MAKE HAS BEEN RUN" { send "r eliza\r" }
        expect "WHICH SCRIPT DO YOU WISH TO PLAY" { send "100\r" }
        expect "HOW DO YOU DO" { interact } ;# Hand over to user for ELIZA interaction
        expect eof { puts "Telnet session ended"; exit 1 }
    '
else
    echo "Setup complete! Please follow these steps:"
    echo "1. Open a new terminal and connect via telnet: 'telnet 0 7094'"
    echo "2. Follow steps 6-15 in README.md to log in and run ELIZA"
    echo "To stop CTSS, run './shutdown-ctss.sh' or manually stop the emulator."
fi
