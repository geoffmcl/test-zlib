@setlocal
@set TMPEXE=D:\Projects\tests\test-zlib\build\release\test-zlib.exe
@if EXIST %TMPEXE% goto GOTEXE
@echo Error: Can NOT locate %TMPEXE%! *** FIX ME ***
@exit /b 1

:GOTEXE
@set TMP3RD=D:\Projects\3rdParty.x64\bin
@if EXIST %TMP3RD%\nul goto GOT3RD
@echo Error: Can NOT locate %TMP3RD%! *** FIX ME ***
@exit /b 1

:GOT3RD
@set TMPQT5=D:\Qt\5.14.2\msvc2017_64\bin
@if EXIST %TMPQT5%\nul goto GOTQT5
@echo Error: Can NOT locate %TMPQT5%! *** FIX ME ***
@exit /b 1

:GOTQT5
@set PATH=%TMP3RD%;%TMPQT5%;%PATH%

%TMPEXE% %*

@REM eof
