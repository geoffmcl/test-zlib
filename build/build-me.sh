#!/bin/sh
#< build-me.sh for test-zlib project - 20150318
#
BN=`basename $0`
TMPINST="$HOME/projects/install/test-zlib"

TMPLOG="bldlog-1.txt"

echo "$BN: building test-zlib project... output to $TMPLOG"
echo "$BN: building test-zlib project..." > $TMPLOG

echo "$BN:Doing: cmake .. -DCMAKE_INSTALL_PREFIX=$TMPINST"
echo "$BN:Doing: cmake .. -DCMAKE_INSTALL_PREFIX=$TMPINST" >> $TMPLOG
cmake .. -DCMAKE_INSTALL_PREFIX=$TMPINST >> $TMPLOG 2>&1
if [ ! "$?" = "0" ]; then
    echo "$BN: cmake config, generation error! see $TMPLOG"
    exit 1
fi

echo "$BN: Doing: 'make'"
echo "$BN: Doing: 'make'" >> $TMPLOG
make >> $TMPLOG 2>&1
if [ ! "$?" = "0" ]; then
    echo "$BN: make error! see $TMPLOG"
    exit 1
fi

echo ""
echo "$BN: Appears a successful build..."
echo "$BN: Time for 'make install' which will install product into $TMPINST"
echo ""

# eof

