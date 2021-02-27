#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\bill 2G\icons\bill cds.ico
#AutoIt3Wrapper_Outfile=Programs\CD Drive Open.exe
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Local $Drive = DriveGetDrive("ALL")
If @error Then
    ; An error occurred when retrieving the drives.
    MsgBox(4096, "List Drives", "It appears an error occurred.")
Else
	Beep(500, 1000)
	Local $begin = TimerInit()
    For $i = 1 To $Drive[0]
        ; Show all the drives found and convert the drive letter to uppercase.

		CDTray ( $Drive[$i], "open" )
		sleep(100)
		CDTray ( $Drive[$i], "close" )
	Next
EndIf
Beep(3700,1000)
Local $dif = TimerDiff($begin)
	MsgBox(0, "Time form program to run", $dif)


