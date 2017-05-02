#!/bin/bash

# This script is to be run via other scripts that live in each manual test
# If you accidentally run this script directly, be sure to delete manual_test_export/ that was
#    generated in the directory previous to here

ln -s ../../assets
echo "created assets symlink"

echo "running test..."
lime test neko
echo
echo "test terminated"

rm assets
echo "removed assets symlink"
