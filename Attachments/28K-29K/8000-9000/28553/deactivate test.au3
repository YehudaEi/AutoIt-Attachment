#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=..\Program Files\AutoIt3\Icons\au3.ico
#AutoIt3Wrapper_outfile=Deactivate.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
Opt("WinWaitDelay", 100)
Opt("WinTitleMatchMode", 4)
Opt("WinDetectHiddenText", 1)
Opt("MouseCoordMode", 0)
WinWait("CHA - Production Environment - CHRISTOPHER LEBLANC - TEST DEPT", "")
If Not WinActive("CHA - Production Environment - CHRISTOPHER LEBLANC - TEST DEPT", "") Then WinActivate("CHA - Production Environment - CHRISTOPHER LEBLANC - TEST DEPT", "")
WinWaitActive("CHA - Production Environment - CHRISTOPHER LEBLANC - TEST DEPT", "")
Send("{TAB}{SHIFTDOWN}{TAB}{SHIFTUP}{ENTER}")
WinWait("User Selection","")
If Not WinActive("User Selection","") Then WinActivate("User Selection","")
WinWaitActive("User Selection","")
InputBox("Single User Select", "Enter Username.", "", " M")
Send("{ALTDOWN}{DOWN}{ALTUP}{RIGHT}{SPACE}{SHIFTDOWN}9{SHIFTUP}inactive{SHIFTDOWN}0{SHIFTUP}{TAB}inactive{TAB}inactive{SPACE}employee{TAB}{ALTDOWN}{DOWN 9}{ALTUP}{DELETE}{DOWN}{DELETE}{DOWN}{DELETE}{DOWN}{DELETE}{DOWN}{DELETE}{DOWN}{DELETE}{DOWN}{DELETE}{DOWN}{DELETE}{DOWN}{DELETE}{DOWN}{DELETE}{DOWN}{DELETE}{DOWN}{DELETE}{DOWN}{DELETE}{DOWN}{DELETE}{DOWN}{DELETE}{DOWN}{DELETE}{DOWN}{DELETE}{DOWN}{DELETE}{DOWN}{DELETE}{DOWN}{DELETE}{DOWN}{TAB}{TAB}{TAB}{TAB}{DELETE}{ALTDOWN}f{ALTUP}")



