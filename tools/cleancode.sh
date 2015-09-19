#!/bin/bash
echo "Cleaning code in ${PWD} and subdirectories."
# split output of find at newlines.
IFS=$'\n'
# send all relevant files to the code cleaner
find qcgrids *.* tools python-qcgrids | \
    egrep "(\.cpp$)|(\.h$)|(\.in$)|(\.sh$)|(\.py$)|(\.pyx$)|(\.pxd$)|(\.txt$)|(\.conf$)|(.gitignore$)" | \
    xargs ./tools/codecleaner.py
# Remove files that "contaminate" the source tree. The cmake build dir should be included
# here.
rm -vf python-qcgrid/qcgrid.cpp
rm -vfr python-qcgrid/build
