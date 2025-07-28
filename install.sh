#!/bin/bash

if ! command -v brew &> /dev/null; then
    echo "Homebrew not installed, installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew already installed, updating..."
    brew update
fi

echo "Installing dependency tools..."
brew install telnet git make gcc python3 || {
    echo "Dependency installation failed, please check Homebrew configuration"
    exit 1
}

if ! python3 --version &> /dev/null; then
    echo "Python3 not installed correctly"
    exit 1
fi

REPO_URL="https://github.com/rupertl/eliza-ctss.git"
if [ ! -d "eliza-ctss" ]; then
    echo "Cloning eliza-ctss repository..."
    git clone "$REPO_URL" || {
        echo "Failed to clone repository, please check network or GitHub link"
        exit 1
    }
fi

cd eliza-ctss || {
    echo "Unable to enter eliza-ctss directory"
    exit 1
}

echo "Setting up environment..."
source env.sh || {
    echo "Environment setup failed, please check env.sh"
    exit 1
}

echo "Compiling binaries..."
make-binaries || {
    echo "make-binaries failed"
    exit 1
}

echo "Creating disk images..."
make-disks || {
    echo "make-disks failed"
    exit 1
}

echo "Environment setup complete! Please follow these steps to continue:"
echo "1. Run 'format-disks' and press Enter multiple times as prompted, then press q to exit"
echo "2. Run 'install-disk-loader' and press Enter multiple times as prompted, then press q to exit"
echo "3. Run 'installctss'"
echo "4. Run 'add-eliza-users'"
echo "5. Run 'upload-all'"
echo "6. Start CTSS: 'runctss'"
echo "7. Open a new terminal and connect to telnet: 'telnet 0 7094'"
echo "8. Follow steps 6-15 in README.md to log in and run ELIZA"
echo "For details, refer to https://github.com/rupertl/eliza-ctss#quickstart"
