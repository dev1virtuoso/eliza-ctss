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

for cmd in make-binaries make-disks installctss add-eliza-users upload-all; do
    echo "Running $cmd..."
    $cmd
done

echo "Automating format-disks..."
expect -c '
    set timeout 60
    spawn ./format-disks
    expect {
        "Press Enter to continue" { send "\r"; exp_continue }
        "Press q to quit" { send "q\r" }
        eof
    }
'

echo "Automating install-disk-loader..."
expect -c '
    set timeout 60
    spawn ./install-disk-loader
    expect {
        "Press q to quit" { send "q\r" }
        eof
    }
'

echo "Please do not close this window until you want to stop CTSS"
echo "Setup complete! Please follow these steps:"
echo "1. Open a new terminal and connect via telnet: 'telnet 0 7094'"
echo "2. Follow steps 6-15 in README.md to log in and run ELIZA"
echo "To stop CTSS, run './shutdown-ctss.sh' or manually stop the emulator."

echo "Starting CTSS..."
runctss
