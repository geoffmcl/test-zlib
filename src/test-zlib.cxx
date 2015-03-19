/*\
 * test-zlib.cxx
 *
 * Copyright (c) 2015 - Geoff R. McLane
 * Licence: GNU GPL version 2
 *
\*/

#include <QCoreApplication>
#include <QString>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h> // for strdup(), ...
#include <errno.h>
#if defined(WIN32) || defined(_WIN32)
#include <Windows.h>
#include <direct.h> // for _chdir, ...
#endif
#include "app_config.h"
#include "fgx_gzlib.h"
#include "loadAptDat.h"
#include "unzip.h"
#include "fgx_unz.h"
#if defined(WIN32) || defined(_WIN32)
#define USEWIN32IOAPI
#include "iowin32.h"
#endif

static const char *module = "test-zlib";

static const char *usr_input = 0;

static const char *def_out_dir = "D:\\temp\\temp_uz";
static const char *def_zip_file = "C:\\Users\\user\\Downloads\\21.zip";

static const char *usr_out_dir = 0;
static const char *usr_zip_file = 0;
static bool do_zip_list = false;
static bool do_zip_extract = false;

void give_help( char *name )
{
    printf("%s: usage: [options] usr_input\n", module);
    printf("Options:\n");
    printf(" --help  (-h or -?) = This help and exit(2)\n");
    printf(" --zip <file>  (-z) = Set input zip library.\n");
    printf(" --out <dir>   (-o) = Set ouput directory. Must exists.\n");
    printf(" --list        (-l) = Only list the zip file contents.\n");
    printf("\n");
    printf("Given an input zip file, either list the contents if -l, or\n");
    printf("extract input output directory, ovewriting any existing files.\n");

}

static loadAptDat *pad = 0;
void clean_up()
{
    if (pad)
        delete pad;
    pad = 0;
}
int test_apt_dat()
{
    int iret = 0;
    if (pad == 0)
        pad = new loadAptDat;
    if (!pad) {
        printf("%s: Memory FAILED~!\n", module );
        return 1;
    }
    QString file("F:\\fgdata\\Airports\\apt.dat.gz");
    if (!pad->isFileLoaded(file)) {
        bool b = pad->loadDirect(file);
        if( !b ) {
            printf("Have loaded %s\n", file.toStdString().c_str());
        } else {
            printf("Failed to load %s\n", file.toStdString().c_str());
            iret = 1;
        }
    }
    if (iret == 0) {
        QString icao("KSFO");
        int ms = pad->getLoadTime();
        int acnt = pad->getAirportCount();
        int rcnt = pad->getRunwayCount();
        double secs = (double)ms / 1000.0;
        int max_show = 10;
        printf("%s: Loaded %d airports, %d runway, in %lf secs\n", module, acnt, rcnt, secs );
        //QString apt = pad->findNameByICAO(icao);
        PAD_AIRPORT papt  = pad->findAirportByICAO(icao);
        if (papt) {
            QString apt = pad->getAiportStg(papt);
            printf("%s: Found\n%s\n", module, apt.toStdString().c_str());
            AIRPORTLIST *pal = pad->getNearestAiportList(papt);
            if (pal) {
                int i, max = pal->count();
                int cnt = 0;
                for (i = 0; i < max; i++) {
                    PAD_AIRPORT pad2 = pal->at(i);
                    if (pad2->icao == papt->icao)
                        continue;
                    apt = pad->getAiportStg(pad2);
                    cnt++;
                    printf("%2d: %s at %0.1lf km\n", cnt, apt.toStdString().c_str(), pad2->distance_km);
                    if (i > max_show)
                        break;
                }
            }
        } else {
            printf("%s: Failed to find airport ICAO %s!\n", module, icao.toStdString().c_str());
        }
    }
    return iret;
}

int parse_args( int argc, char **argv )
{
    int i,i2,c;
    char *arg, *sarg;
    for (i = 1; i < argc; i++) {
        arg = argv[i];
        i2 = i + 1;
        if (*arg == '-') {
            sarg = &arg[1];
            while (*sarg == '-')
                sarg++;
            c = *sarg;
            switch (c) {
            case 'h':
            case '?':
                give_help(argv[0]);
                return 2;
                break;
            case 'z':
                if (i2 < argc) {
                    i++;
                    sarg = argv[i];
                    usr_zip_file = strdup(sarg);
                } else {
                    printf("%s: Expected zip file name to follow '%s'! Aborting...\n", module, arg);
                    return 1;
                }
                break;
            case 'o':
                if (i2 < argc) {
                    i++;
                    sarg = argv[i];
                    usr_out_dir = strdup(sarg);
                    do_zip_extract = true;
                } else {
                    printf("%s: Expected output directory to follow '%s'! Aborting...\n", module, arg);
                    return 1;
                }
                break;
            case 'l':
                do_zip_list = true;
                break;
            default:
                printf("%s: Unknown argument '%s'. Tyr -? for help...\n", module, arg);
                return 1;
            }
        } else {
            // bear argument
            if (usr_zip_file) {
                printf("%s: Already have input '%s'! What is this '%s'?\n", module, usr_zip_file, arg );
                return 1;
            }
            usr_zip_file = strdup(arg);
        }
    }
    if (!usr_zip_file) {
        printf("%s: No user zip file found in command!\n", module);
        return 1;
    }

    return 0;
}

int test_unzip()
{
    int iret = 0;
    // QString out_dir("C:\\GTools\\ConApps\\tests\\build-test-zlib\\temp_uz");
    QString out_dir;    //("D:\\temp\\temp_uz");
    QString zip_file;   //("C:\\Users\\user\\Downloads\\21.zip");
    uint flag = do_zip_list ? uzflg_listonly : 0;
    if (usr_zip_file)
        zip_file = usr_zip_file;
    else {
        printf("%s: No input zip file given! Aborting...\n", module);
        return 1;
    }
    if (usr_out_dir) {
        out_dir = usr_out_dir;
    } else if (!do_zip_list) {
        printf("%s: No output directory given! Aborting...\n", module);
        return 1;
    }
    iret = fileUnzip(zip_file,out_dir,flag);
    //iret = fileUnzip(zip_file,out_dir, uzflg_listonly);
    std::string s = getUzErrorString();
    if (iret) {
        printf("%s: Got error %s\n", module, s.c_str());
    } else if (do_zip_list) {
        printf("List...\n");
        printf("%s", s.c_str());
    }
    return iret;
}

// main() OS entry
int main( int argc, char **argv )
{
    int iret = 0;
    QCoreApplication a(argc, argv);
    iret = parse_args(argc,argv);
    if (iret)
        return iret;

    //iret = test_apt_dat();
    iret = test_unzip();

    clean_up();
    return iret;
}


// eof = test-zlib.cxx
