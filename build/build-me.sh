#!/bin/sh
#< build-me.sh for test-zlib project - 20150318
#
BN=`basename $0`
TMPINST="$HOME/projects/install/test-zlib"
VERBOSE=0
DBGSYMS=0
TMPOPTS="-DCMAKE_INSTALL_PREFIX=$TMPINST"
TMPLOG="bldlog-1.txt"

for arg in $@; do
      case $arg in
         VERBOSE) VERBOSE=1
            TMPOPTS="$TMPOPTS -DCMAKE_VERBOSE_MAKEFILE=TRUE"
            ;;
         DEBUG) DBGSYMS=1
            TMPOTPS="$TMPOPTS -DCMAKE_BUILD_TYPE=Debug -DENABLE_DEBUG_SYMBOLS:BOOL=TRUE"
            ;;
         *)
            echo "$BN: ERROR: Invalid argument [$arg]"
            echo "$BN: Only VERBOSE and DEBUG allowed"
            exit 1
            ;;
      esac
done


echo "$BN: building test-zlib project... output to $TMPLOG"
echo "$BN: building test-zlib project..." > $TMPLOG

echo "$BN:Doing: cmake .. $TMPOPTS"
echo "$BN:Doing: cmake .. $TMPOPTS" >> $TMPLOG
cmake .. $TMPOPTS >> $TMPLOG 2>&1
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

