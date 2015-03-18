@setlocal
@set TMPBGN=%TIME%

@set TMPPRJ=test_zlib
@set TMPSRC=..
@set TMPGEN=Visual Studio 10
@set TMPFIL=CMakeLists.txt
@set TMPDFIL=%TMPSRC%\%TMPFIL%

@if NOT EXIST %TMPSRC%\nul goto NODIR
@if NOT EXIST %TMPSRC%\%TMPFIL% goto NOFIL

@call chkmsvc %TMPPRJ%

@set TMPLOG=bldlog-1.txt

@REM Test external zlib
@REM set TMPOPTS=-DCMAKE_PREFIX_PATH=F:\FG\18\3RdParty
@REM set TMPOPTS=%TMPOPTS% -DTRY_EXTERN_ZLIB:BOOL=ON

@echo Bgn %DATE% %TIME% to %TMPLOG%
@REM Restart LOG
@echo. > %TMPLOG%
@echo Bgn %DATE% %TIME% >> %TMPLOG%

cmake %TMPSRC% %TMPOPTS% >> %TMPLOG% 2>&1
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
