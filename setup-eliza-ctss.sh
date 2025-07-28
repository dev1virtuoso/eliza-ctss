#!/bin/bash

if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Updating Homebrew..."
    brew update
fi

echo "Installing dependency tools..."
brew install telnet git make gcc python3 expect || { echo "Dependency installation failed"; exit 1; }

if [ ! -d "eliza-ctss" ]; then
    echo "Cloning eliza-ctss repository..."
    git clone https://github.com/dev1virtuoso/eliza-ctss.git || { echo "Clone failed"; exit 1; }
fi
cd eliza-ctss || { echo "Cannot enter directory"; exit 1; }

echo "Setting up environment..."
source env.sh || { echo "Environment setup failed"; exit 1; }

for cmd in make-binaries make-disks installctss add-eliza-users upload-all; do
    echo "Running $cmd..."
    $cmd || { echo "$cmd failed"; exit 1; }
done

echo "Automating format-disks..."
expect -c '
    spawn ./format-disks
    expect "Press Enter to continue" { send "\r" }
    expect "Press Enter to continue" { send "\r" }
    expect "Press q to quit" { send "q\r" }
    expect eof
' || { echo "format-disks failed"; exit 1; }

echo "Automating install-disk-loader..."
expect -c '
    spawn ./install-disk-loader
    expect "Press Enter to continue" { send "\r" }
    expect "Press Enter to continue" { send "\r" }
    expect "Press q to quit" { send "q\r" }
    expect eof
' || { echo "install-disk-loader failed"; exit 1; }

echo "Setup complete! Please follow these steps:"
echo "1. Start CTSS: 'runctss'"
echo "2. Open a new terminal and connect via telnet: 'telnet 0 7094'"
echo "3. Follow steps 6-15 in README.md to log in and run ELIZA"
