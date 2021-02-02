FileCopy("C:\print\INCOMING\TTY.txt", "C:\print\CACHE\" & @MON & @MDAY & @YEAR & @HOUR & @MIN & @MSEC & ".txt", 0)
FileMove("C:\print\INCOMING\TTY.txt", "C:\print\INCOMING\" & @MON & @MDAY & @YEAR & @HOUR & @MIN & @MSEC & ".txt", 0)
;I had to make this a seperate .exe file because it was just not running when I would try to keep it on the 
;main program. For some reason when I have it as another .exe file it will run just fine. Bad news is I have 
;to put the "run("rename.exe", "", @SW_HIDE)" in a bunch of different places in the program so it will continue to 
;check to see if there is a file called TTY.txt in the folder. There has to be another way because the way I'm 
;doing it slows things down and causes me to miss some documents because they get written over too quickly.

