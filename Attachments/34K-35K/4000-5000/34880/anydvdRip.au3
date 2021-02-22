;Run ripper DVD
;Check to see if ripper is open
$progress = 0
$window = ""

WinSetTrans("AnyDVD", "",0)
WinActivate("AnyDVD Ripper")


;Set Destination folder to path name from command line parameter
ControlSetText("AnyDVD Ripper","","[CLASSNN:TEdit1]","E:\Deception")
;Start the rip
ControlClick("AnyDVD Ripper","","[CLASSNN:TButton2]")

	$window = "AnyDVD " & $progress 
	WinWaitActive($window,"",10)
	
	Run("C:\Documents and Settings\DFS IDYL\Desktop\AutoIt\ErrorChecker.exe")
	
For $progress = 0 To 99 Step 1
	
	WinWait($window,"",75)
	;Use DllCall instead of MsgBox to update a progress bar in Blink
	MsgBox(1,"DVD Rip", $window, 1)
	$progress = $progress + 1
	$window = "AnyDVD " & $progress

Next


	
	
Exit