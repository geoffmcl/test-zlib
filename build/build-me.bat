@setlocal
@set TMPBGN=%TIME%

@set TMPPRJ=test_zlib
@set TMPSRC=..
@REM Update to MSVC 16 2019 Arch x64
@set TMPGEN=Visual Studio 16 2019
@REM set TMPGEN=Visual Studio 10
@set TMPFIL=CMakeLists.txt
@set TMPDFIL=%TMPSRC%\%TMPFIL%

@if NOT EXIST %TMPSRC%\nul goto NODIR
@if NOT EXIST %TMPSRC%\%TMPFIL% goto NOFIL

@call chkmsvc %TMPPRJ%
@call setupqt5

@set TMPLOG=bldlog-1.txt

@set TMPOPTS=-G "%TMPGEN%" -A x64
@set TMPOPTS=%TMPOPTS% -DBUILD_WITH_QT4:BOOL=OFF
@REM Test external zlib
@set TMPOPTS=%TMPOPTS% -DCMAKE_PREFIX_PATH=D:\Projects\3RdParty.x64
@set TMPOPTS=%TMPOPTS% -DTRY_EXTERN_ZLIB:BOOL=ON
@REM DEBUG ONLY
@set TMPOPTS=%TMPOPTS% -DLIST_ALL_VARIABLES:BOOL=ON

@echo Bgn %DATE% %TIME% to %TMPLOG%
@REM Restart LOG
@echo. > %TMPLOG%
@echo Bgn %DATE% %TIME% >> %TMPLOG%

cmake -S %TMPSRC% %TMPOPTS% >> %TMPLOG% 2>&1
@if ERRORLEVEL 1 goto CMERR

cmake --build . --config Debug  >> %TMPLOG% 2>&1
@if ERRORLEVEL 1 goto BLDERR

cmake --build . --config Release >> %TMPLOG% 2>&1
@if ERRORLEVEL 1 goto BLDERR

@echo All done...  >> %TMPLOG%
@call elapsed %TMPBGN% >> %TMPLOG%
@echo End %DATE% %TIME% ERRORLEVEL=%ERRORLEVEL% >> %TMPLOG%
@call elapsed %TMPBGN%
@echo End %DATE% %TIME% success ... see %TMPLOG%
@goto END

:BLDERR
@echo ERROR: cmake build returned ERROR=%ERRORLEVEL%
@goto ISERR

:CMERR
@echo ERROR: cmake generation returned ERROR=%ERRORLEVEL%
@goto ISERR

:NODIR
@echo ERROR: Can NOT locate directory [%TMPSRC%]
@goto ISERR

:NOFIL
@echo ERROR: Can NOT locate file [%TMPFIL%]
@goto ISERR

:ISERR
@endlocal
@exit /b 1


:HELP
@echo Must give the SOURCE path to do the build...
@goto END


:END
@endlocal
@exit /b 0

@REM eof
