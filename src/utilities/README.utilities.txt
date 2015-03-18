README.utilities.txt - 20150318

This is a bunch of utilities from the fgx project - https://github.com/fgx/fgx.

Most have a prerequisite of Qt - https://www.qt.io/download/ - free community 
edition. It was specifically written for Qt4, but may work with Qt5 probably 
with some work.

Individual Files and Folder

dirDialog.cpp dirDialog.h fileDialog.cpp fileDialog.h

These were written when there were some trouble using the native dir dialog, 
and file dialog in certain OSES. Normally they should NOT be needed.

fgx_gzlib.cpp fgx_gzlib.h

This was some 'glue' code into the ZLIB API. It should work using either the 
built-in souce of zlib, or an external installed zlib.

fgx_unz.cpp fgx_unz.h

To provide easy 'unzipping' of a zip file to a directory. It depends on the 
minizip library. That is the source in minizip folder.

loadAptDat.cpp loadAptDat.h

Use to decompress flightgear apt.dat.gz file.

workThread.cpp workThread.h

Uses Qt threads to run vearious functions on a thread.

helpers.cpp helpers.h

messagebox.cpp messagebox.h

statusbar.cpp statusbar.h

utilities.cpp utilities.h

simgear directory

A small extract for flightgear's simgear, just to provide two functions
// given, lat1, lon1, az1 and distance (s), calculate lat2, lon2
// and az2.  Lat, lon, and azimuth are in degrees.  distance in meters
extern int sg_geo_direct_wgs_84 ( double lat1, double lon1, double az1,
                        double s, double *lat2, double *lon2,
                        double *az2 );

// given lat1, lon1, lat2, lon2, calculate starting and ending
// az1, az2 and distance (s).  Lat, lon, and azimuth are in degrees.
// distance in meters
extern int sg_geo_inverse_wgs_84( double lat1, double lon1, double lat2,
            double lon2, double *az1, double *az2,
                        double *s );


;eof
