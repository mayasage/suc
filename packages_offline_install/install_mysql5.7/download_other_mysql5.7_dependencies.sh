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

PACKAGE=mysql-community-server

# user input
if [ -z "$PACKAGE" ]; then
  echo "Invalid Arguments"
  exit 1
fi

# folder
mkdir "other-dependencies"
cd "other-dependencies" || exit 1

# downloadx
# Expecting the following 2 packages:
# libsasl2-modules-db_2.1.27+dfsg-2ubuntu0.1_amd64.deb
# libsasl2-2_2.1.27+dfsg-2ubuntu0.1_amd64.deb
DEPENDENCIES=$(
  apt-rdepends "$PACKAGE" |
    grep -v "^ " |
    grep \
      -e "libsasl2-modules-db.*" \
      -e "libsasl2-2.*"
)
DEPENDENCY_COUNT=$(echo "$DEPENDENCIES" | wc -l)
echo "Count: $DEPENDENCY_COUNT"
echo "$DEPENDENCIES"
echo "Downloading..."
echo "$DEPENDENCIES" | xargs -n 1 apt download
echo "Download complete."
