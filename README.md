# test-zlib project

Extracted from the fgx project - https://github.com/fgx/fgx - to be able to easily 
develop and test some functions, in this case -

(a) Decompress fgdata/Airports/apt.dat.gz, and store the contents in a class.

(b) Unzip a ZIP file into a directory.

## Prerequite:

(a) Needs Qt4 installed.
(b) Needs cmake installed
(c) Optional, zlib, but also has a built-in source

## Build:

Uses cmake to generate native build files.

#### In unix systems:

 1. $ cd build
 2. $ cmake ..
 3. $ make

#### In Windows system:

 1. $ cd build
 2. $ cmake ..
 3. $ cmake --build . --config Release

README.txt - 20150318
; eof
