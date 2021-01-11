;*************              RETREIVE     P011                      ******************"
;*************                                                     ******************"
;*************************************************************************************
;*************                                                     ******************"
;*************               Prv:ALL   Loc:ALL:
;*************                                                     ******************"
;*************                                                     ******************"
;*************************************************************************************
WinMinimizeAll ( )
Send("{NumLock on}") ;Turns the NumLock key on
Send("{CapsLock on}") ;Turns the CapsLock key on
;Hide My Computer
RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu", "{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "REG_DWORD", 1 )
send("{f5}")
sleep(1800)

;Show My Computer
RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu", "{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "REG_DWORD", 0 )
send("{f5}")

sleep(600)
MouseClick("left", 15, 10, 2)
sleep(3150)

; *********** open prac 11 and get stuff
Send("011")
Send("{enter}")
sleep(3150)

; *********** CHANGE PRINTER TO P11
Send("7")
Send("{enter}")
sleep(3000)

Send("P11")
Send("{enter}")
sleep(1200)
Send("{enter}")
sleep(1200)

; *********** RUN REPORT PROV ALL


Send("1")
Send("{enter}")
sleep(1200)

Send("7")
Send("{enter}")
sleep(600)

Send("10")
Send("{enter}")
sleep(600)

Send("1")
Send("{enter}")
sleep(600)
Send("O")
Send("{enter}")
sleep(600)
Send("TED")
Send("{enter}")
sleep(600)
Send("{enter}")
sleep(600)

Send("P")
Send("{enter}")
sleep(600)

Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 


Send("P")
Send("{enter}")
sleep(600)

Send("11")
Send("{enter}")
sleep(600)
Send("{enter}")
sleep(600)

Send("C")
Send("{enter}")
sleep(600)

Send("{DOWN}")
sleep(600)

Send("E")
Send("{enter}")
sleep(600)
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
























Send("{DOWN}")
sleep(600)
Send("{DOWN}")
sleep(600)
Send("{DOWN}")
sleep(600)

Send("E")
Send("{enter}")
sleep(600)

Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 
Send("{DEL}") 


Send("E")
Send("{enter}")
sleep(600)

;***************   Get PROVIDER number, EMPTY means ALL    *********************

Send("{enter}")
sleep(600)

Send("{enter}")
sleep(600)
Send("{enter}")
sleep(600)
Send("{enter}")
sleep(600)
Send("E")
Send("{enter}")
sleep(600)
Send("{enter}")
sleep(600)

Send("{BACKSPACE}")
sleep(600)
Send("2")
Send("{enter}")
sleep(600)

Send("{BACKSPACE}")
sleep(600)
Send("2")
Send("{enter}")
sleep(600)

Send("{BACKSPACE}")
Send("{BACKSPACE}")
Send("{BACKSPACE}")
Send("{BACKSPACE}")
Send("0")
Send("{enter}")
sleep(600)

Send("{BACKSPACE}")
Send("{BACKSPACE}")
Send("{BACKSPACE}")
Send("{BACKSPACE}")
Send("90")
Send("{enter}")
sleep(600)

Send("{BACKSPACE}")
Send("{BACKSPACE}")
Send("{BACKSPACE}")
Send("{BACKSPACE}")
Send("120")
Send("{enter}")
sleep(600)

Send("{BACKSPACE}")
Send("{BACKSPACE}")
Send("{BACKSPACE}")
Send("{BACKSPACE}")
Send("150")
Send("{enter}")
sleep(600)

Send("{BACKSPACE}")
Send("{BACKSPACE}")
Send("{BACKSPACE}")
Send("{BACKSPACE}")
Send("{BACKSPACE}")
Send("{BACKSPACE}")
Send("{BACKSPACE}")
Send("{BACKSPACE}")
Send("{BACKSPACE}")

Send("{enter}")
sleep(600)

Send("{BACKSPACE}")
Send("1")
Send("{enter}")
sleep(600)

Send("R")
Send("{enter}")
sleep(600)








$PAUSE=InputBox("WAIT WINDOW P011, ALL & prv 3-9", "Hit Enter when Medisense is done...", "Y", "",-1,-1,0,0)

FileMove("J:\CSIMD\PRTFILES\PRAC011.TXT", "C:\MMGAR\DOWNLOADS\AGING\P011\LOC-ALL-PALL.TXT", 1)
Sleep(450)


