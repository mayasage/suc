#!/bin/sh

echo "This script used apt, apt download & apt-rdepends."

# apt
if command -v apt >/dev/null; then
  echo "found apt"
else
  echo "apt not found."
  exit 1
fi

# apt download
if command -v apt download >/dev/null; then
  echo "found apt download"
else
  echo "apt download not found."
  exit 1
fi

# apt-rdepends
if command -v apt-rdepends >/dev/null; then
  echo "found apt-rdepends"
else
  echo "installing apt-rdepends..."
  sudo apt install apt-rdepends
fi

PACKAGE=$1

# user input
if [ -z "$PACKAGE" ]; then
  echo "Invalid Arguments"
  exit 1
fi

# folder
mkdir "$PACKAGE"
cd "$PACKAGE" || exit 1

# download
# Some dependencies can't be downloaded, so they are filtered out.
DEPENDENCIES=$(
  apt-rdepends "$PACKAGE" |
    grep -v "^ " |
    grep -v "^libc-dev$" |       # stackoverflow
    grep -v "^perlapi-5.34.0$" | # cowsay
    sed 's/debconf-2.0/debconf/g'
)
DEPENDENCY_COUNT=$(echo "$DEPENDENCIES" | wc -l)
echo "Count: $DEPENDENCY_COUNT"
echo "$DEPENDENCIES"
echo "Downloading..."
echo "$DEPENDENCIES" | xargs -n 1 apt download
echo "Download complete."
echo "Run 'cd $PACKAGE && sudo dpkg -i *.deb' to install."
