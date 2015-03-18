
# CMakeLists.txt, generated gencmake.pl, on 2015/03/16 16:47:04
cmake_minimum_required( VERSION 2.8.8 )

# CMakeScripts or use the ones that come by default with CMake.
# set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/CMakeModules ${CMAKE_MODULE_PATH})

project( test_zlib )

# The version number.
set( test_zlib_MAJOR 3 )
set( test_zlib_MINOR 0 )
set( test_zlib_POINT 0 )


# Allow developer to select is Dynamic or static library built
set( LIB_TYPE STATIC )  # set default static
option( BUILD_SHARED_LIB "Set ON to build shared libraries"            OFF )
option( TRY_EXTERN_ZLIB  "Set ON to search and use external ZLIB"      OFF )
option( BUILD_WITH_QT4   "Set OFF to attempt to use Qt5, if installed" ON  )

add_definitions( -DTEST_ZLIB )

if(CMAKE_COMPILER_IS_GNUCXX)
    set( WARNING_FLAGS -Wall )
endif(CMAKE_COMPILER_IS_GNUCXX)

if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang") 
   set( WARNING_FLAGS "-Wall -Wno-overloaded-virtual" )
endif() 

if(WIN32 AND MSVC)
    # turn off various warnings - none needed in this compile
    set(WARNING_FLAGS "${WARNING_FLAGS} /wd4996")
    # foreach(warning 4244 4251 4267 4275 4290 4786 4305)
    #     set(WARNING_FLAGS "${WARNING_FLAGS} /wd${warning}")
    # endforeach(warning)
    set( MSVC_FLAGS "-DNOMINMAX -D_USE_MATH_DEFINES -D_CRT_SECURE_NO_WARNINGS -D_SCL_SECURE_NO_WARNINGS -D__CRT_NONSTDC_NO_WARNINGS" )
    # if (${MSVC_VERSION} EQUAL 1600)
    #    set( MSVC_LD_FLAGS "/FORCE:MULTIPLE" )
    # endif (${MSVC_VERSION} EQUAL 1600)
    #set( NOMINMAX 1 )
    # to distinguish between debug and release libs
    set( CMAKE_DEBUG_POSTFIX "d" )
else()
    # items for unix
endif()

set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${WARNING_FLAGS} ${MSVC_FLAGS} -D_REENTRANT" )
set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${WARNING_FLAGS} ${MSVC_FLAGS} -D_REENTRANT" )
set( CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${MSVC_LD_FLAGS}" )

if( NOT BUILD_WITH_QT4 )
    # try Qt5 first, and prefer that if found
    find_package(Qt5Core QUIET)
endif()

if (Qt5Core_FOUND)
    set(QTCORE_LIBRARIES ${Qt5Core_LIBRARIES})
    # if there is no QT_ROOT, try to deduce it from Qt QtCore include
    if ("${QT_ROOT}" STREQUAL "")
        set(QT_ROOT ${QT_QTCORE_INCLUDE_DIR}/../..)
    endif()    
    include_directories(${Qt5Core_INCLUDE_DIRS})

    macro(qt_wrap_cpp)
        qt5_wrap_cpp(${ARGN})
    endmacro()
else()
    set(qt_min_version "4.5.0")
    #find_package(Qt4 REQUIRED)
    #set(QT_USE_QTGUI false)
    #include(${QT_USE_FILE})
    # qtestlib
    set(components QtCore QtGui QtNetwork QtWebkit QtXml QtXmlPatterns )
    message(STATUS "*** Finding Qt4 components ${components}")
    find_package ( Qt4 COMPONENTS ${components} REQUIRED )
    include ( ${QT_USE_FILE} )
    add_definitions( ${QT_DEFINITIONS} )
    # debug messages
    message(STATUS "*** include ( ${QT_USE_FILE} )")
    message(STATUS "*** defs ${QT_DEFINITIONS}")
    message(STATUS "*** libs ${QT_LIBRARIES}")
    list(APPEND add_LIBS ${QT_LIBRARIES})
    set( QT_USE_QTNETWORK TRUE )
    set( QT_USE_QTXML TRUE )
    set( QT_USE_QTXMLPATTERNS TRUE )
    set( QT_USE_QTWEBKIT TRUE )
    include_directories(${QT_INCLUDES})

    macro(qt_wrap_cpp)
        qt4_wrap_cpp(${ARGN})
    endmacro()
endif()

# Use system zlib on unix and Qt ZLIB on Windows
#  ZLIB_INCLUDE_DIRS   - where to find zlib.h, etc.
#  ZLIB_LIBRARIES      - List of libraries when using zlib.
#  ZLIB_FOUND          - True if zlib found.
if (TRY_EXTERN_ZLIB)
    message(STATUS "*** Trying to find external zlib library")
    find_package(ZLIB)
    if (ZLIB_FOUND)
        message(STATUS "*** Found ZLIB inc ${ZLIB_INCLUDE_DIRS} lib ${ZLIB_LIBRARIES}")
        include_directories( ${ZLIB_INCLUDE_DIRS} )
        list(APPEND add_LIBS ${ZLIB_LIBRARIES} )
    endif ()    
else ()
    message(STATUS "*** Using built-in zlib library")
endif ()

# configuration file, if needed
# configure_file( ${CMAKE_SOURCE_DIR}/config.h.cmake ${CMAKE_BINARY_DIR}/config.h )
# add_definitions( -DHAVE_CONFIG_H )
# include_directories( ${CMAKE_BINARY_DIR} )

if(BUILD_SHARED_LIB)
   set(LIB_TYPE SHARED)
   message(STATUS "*** Building DLL library ${LIB_TYPE}")
else()
   message(STATUS "*** Option BUILD_SHARED_LIB is OFF ${LIB_TYPE}")
endif()
#################################################
##### LIBRARIES #####
#################################################

if (NOT ZLIB_FOUND)
    message(STATUS "*** Building built-in zlib library, defining FGX_ZLIB")
    add_definitions( -DFGX_ZLIB )   # signal using built-in zlib, so use fgx_zlib.h
    include_directories( src/utilities/zlib )   # and so it can be found
    # zlib LIBRARY from [...\src\utilities\zlib],
    # have 15 C/C++ sources, 11 headers
    set(zlib_SRCS
        src/utilities/zlib/adler32.c
        src/utilities/zlib/compress.c
        src/utilities/zlib/crc32.c
        src/utilities/zlib/deflate.c
        src/utilities/zlib/gzclose.c
        src/utilities/zlib/gzlib.c
        src/utilities/zlib/gzread.c
        src/utilities/zlib/gzwrite.c
        src/utilities/zlib/infback.c
        src/utilities/zlib/inffast.c
        src/utilities/zlib/inflate.c
        src/utilities/zlib/inftrees.c
        src/utilities/zlib/trees.c
        src/utilities/zlib/uncompr.c
        src/utilities/zlib/zutil.c
        )
    set(zlib_HDRS
        src/utilities/zlib/crc32.h
        src/utilities/zlib/deflate.h
        src/utilities/zlib/fgx_zconf.h
        src/utilities/zlib/fgx_zlib.h
        src/utilities/zlib/fgx_zutil.h
        src/utilities/zlib/gzguts.h
        src/utilities/zlib/inffast.h
        src/utilities/zlib/inffixed.h
        src/utilities/zlib/inflate.h
        src/utilities/zlib/inftrees.h
        src/utilities/zlib/trees.h
        )
    add_library( zlib ${zlib_SRCS} ${zlib_HDRS} )
    list(APPEND add_LIBS zlib)
endif ()

include_directories( src/utilities )  
set(name simgear)
set(dir src/utilities/simgear)
set(${name}_SOURCES
    ${dir}/SGGeodesy.cpp
    )
set(${name}_HEADERS
    ${dir}/compiler.h
    ${dir}/constants.h
    ${dir}/SGGeodesy.h
    )
add_library( ${name} ${${name}_SOURCES} ${${name}_HEADERS} )
list(APPEND add_LIBS ${name})
  
include_directories( src )  
set(name utilities)
set(dir src/utilities)
set(${name}_SOURCES
    ${dir}/fgx_gzlib.cpp
    ${dir}/helpers.cpp
    ${dir}/loadAptDat.cpp
    ${dir}/utilities.cpp
    ${dir}/workThread.cpp
    ${dir}/dirDialog.cpp
    ${dir}/fileDialog.cpp
    ${dir}/fgx_unz.cpp
    )
set(utilities_HEADERS
    ${dir}/fgx_gzlib.h
    ${dir}/helpers.h
    ${dir}/loadAptDat.h
    ${dir}/utilities.h
    ${dir}/workThread.h
    ${dir}/dirDialog.h
    ${dir}/fileDialog.h
    ${dir}/fgx_unz.h
    )
qt_wrap_cpp(MOC_SRCS ${${name}_HEADERS})
add_library( ${name} ${${name}_SOURCES} ${${name}_HEADERS} ${MOC_SRCS})
list(APPEND add_LIBS ${name})

####################################
### add contrib stuff
####################################
set(name libminizip)
set(dir src/utilities/minizip)
include_directories( ${dir} )   # and so it can be found
set(${name}_SOURCES
    ${dir}/ioapi.c
    ${dir}/mztools.c
    ${dir}/unzip.c
    ${dir}/zip.c
    )
set(${name}_HEADERS
    ${dir}/crypt.h
    ${dir}/ioapi.h
    ${dir}/mztools.h
    ${dir}/unzip.h
    ${dir}/zip.h
    )
if (WIN32)
    list(APPEND ${name}_SOURCES ${dir}/iowin32.c)
    list(APPEND ${name}_HEADERS ${dir}/iowin32.h)
endif ()
add_library( ${name} ${${name}_SOURCES} ${${name}_HEADERS} )
list(APPEND add_LIBS ${name})
    
#################################################
##### EXECUTABLES #####
#################################################

# test-zlib EXECUTABLE from [C:\GTools\ConApps\tests\test-zlib\src],
# have 1 C/C++ sources, 0 headers
set(test-zlib_SRCS
    src/test-zlib.cxx
    )
add_executable( test-zlib ${test-zlib_SRCS} )
if (add_LIBS)
    target_link_libraries( test-zlib ${add_LIBS} )
endif ()
if (MSVC)
    set_target_properties( test-zlib PROPERTIES DEBUG_POSTFIX d )
endif ()
# deal with install, if any...
#install( TARGETS test-zlib DESTINATION bin )

set(name miniunz)
set(dir src/utilities/minizip)
add_executable( ${name} ${dir}/${name}.c )
target_link_libraries( ${name} ${add_LIBS} )
if (MSVC)
    set_target_properties( ${name} PROPERTIES DEBUG_POSTFIX d )
endif ()

set(name minizip)
set(dir src/utilities/minizip)
add_executable( ${name} ${dir}/${name}.c )
target_link_libraries( ${name} ${add_LIBS} )
if (MSVC)
    set_target_properties( ${name} PROPERTIES DEBUG_POSTFIX d )
endif ()

# eof
