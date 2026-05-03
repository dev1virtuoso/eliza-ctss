#!/usr/bin/env bash

cat > env.sh <<'EOF'
# Source this into your shell to set up PATH and locations of disks,
# tapes etc
#
# Run this from the root directory of the repo, and then execute all
# commands from there.

# The telnet port to connect to when CTSS is running. Change here if
# desired.
export PORT=7094

# You should not generally need to change any of these
export PATH=ctss/scripts:ctss/bin:eliza/bin:${PATH}
export TAPE=ctss/tape
export CMD=ctss/cmd
export DASD=dasd
export OUTPUT=output
export TMP=tmp
mkdir -p ${TMP}

echo "CTSS environment set. DASD=${DASD} PORT=${PORT}"
EOF

mkdir -p dasd output tmp
echo "Directories created (dasd, output, tmp)."
S709_URL="https://cozx.com/dpitts/tarballs/ibm709x/s709-2.4.3.tar.gz"
CTSS_URL="https://cozx.com/dpitts/tarballs/ibm709x/ctss-1.0.7.kit.tar.gz"
UTILS_URL="https://cozx.com/dpitts/tarballs/ibm709x/utils-1.1.14.tar.gz"

extract_if_needed() {
    local url=$1 dest=$2
    if [ ! -d "$dest" ]; then
        echo "Downloading $url ..."
        curl -L -o "$dest.tar.gz" "$url"
        echo "Extracting to $dest ..."
        mkdir -p "$dest"
        tar -xzf "$dest.tar.gz" -C "$dest" --strip-components=1
        rm "$dest.tar.gz"
        echo "Done."
    else
        echo "$dest already exists – skipping."
    fi
}

extract_if_needed "$S709_URL" "s709"
extract_if_needed "$CTSS_URL" "ctss"
extract_if_needed "$UTILS_URL" "utils"
cat <<'EOL'

✔️  Environment set up!
    1️  Source the env.sh:   source env.sh
    2️  Build the binaries:  make-binaries
    3️  Format & install:    make-disks ; format-disks ; install-disk-loader
    4️  Install CTSS:        installctss
    5️  Add users:          add-eliza-users
    6️  Upload source:      upload-all

Now you can start CTSS with:
    runctss
EOL
