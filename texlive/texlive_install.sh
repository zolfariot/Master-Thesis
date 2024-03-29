#!/usr/bin/env sh

# Originally from https://github.com/PHPirates/travis-ci-latex-pdf

# This script is used for building LaTeX files using Travis
# A minimal current TL is installed adding only the packages that are
# required

TEXLIVE_TAR_URL="http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz"

# See if there is a cached version of TL available
export PATH=/tmp/texlive/bin/x86_64-linux:$PATH
if ! command -v texlua > /dev/null; then
    # Obtain TeX Live
    wget $TEXLIVE_TAR_URL
    tar -xzf $(basename $TEXLIVE_TAR_URL)
    # Install a minimal system
    cd install-tl-20*
    ./install-tl --profile=../texlive/texlive.profile
    cd ..
fi

# Just including texlua so the cache check above works
tlmgr install luatex

# We specify the directory in which it is located texlive_packages
tlmgr install $(sed 's/\s*#.*//;/^\s*$/d' texlive/texlive_packages)

# Keep no backups (not required, simply makes cache bigger)
tlmgr option -- autobackup 0

# Update the TL install but add nothing new
tlmgr update --self --all --no-auto-install