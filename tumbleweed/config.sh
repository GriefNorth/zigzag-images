#!/usr/bin/env/bash
#======================================
# Functions...
#--------------------------------------
test -f /.kconfig && . /.kconfig
test -f /.profile && . /.profile

#======================================
# Greeting...
#--------------------------------------
echo "Configure image: [$kiwi_iname]..."

#======================================
# Mount system filesystems
#--------------------------------------
baseMount

#======================================
# Setup baseproduct link
#--------------------------------------
suseSetupProduct

#======================================
# Add missing gpg keys to rpm
#--------------------------------------
suseImportBuildKey

#======================================
# SuSEconfig
#--------------------------------------
suseConfig

#======================================
# Configure Zigzag
#--------------------------------------
export ZIGZAG_KIWI=1

# Hack until https://github.com/ansible/ansible/pull/41916 is packaged in Tumbleweed
sed -i -e 's/name = filter(None, name)/name = list(filter(None, name))/' \
    /usr/lib/python3.6/site-packages/ansible/modules/packaging/os/zypper.py

set -e
if [[ $kiwi_profiles == *testing* ]]; then
    export ZIGZAG_TESTING=1
fi

zigzag-write-configuration --force root
set +e

#======================================
# Remove yast if not in use
#--------------------------------------
suseRemoveYaST

#======================================
# Umount kernel filesystems
#--------------------------------------
baseCleanMount

exit 0
