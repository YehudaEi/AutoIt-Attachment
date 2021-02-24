AutoItSetOption("GUIOnEventMode",1)
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Help", 681, 443, 342, 201)
GUISetOnEvent(-3,"clo")
$Buttonh1 = GUICtrlCreateButton("1-What is Imporved Disk Security?", 2, 52, 216, 29, 0)
GUICtrlSetOnEvent($Buttonh1,"h1")
$Labelh1 = GUICtrlCreateLabel("________________________________________________________________________________________________________________", 2, 21, 676, 17)
$Labelh2 = GUICtrlCreateLabel("Application Help", 294, 5, 81, 17)
$Buttonh2 = GUICtrlCreateButton("Feature 1: Using Unlocker", 2, 117, 216, 29, 0)
GUICtrlSetOnEvent($Buttonh2,"f1")
$Buttonh3 = GUICtrlCreateButton("Feature 2: FFX (FULL FIX)", 2, 190, 216, 29, 0)
GUICtrlSetOnEvent($Buttonh3,"f2")
$Buttonh4 = GUICtrlCreateButton("Feature 3: Remove Autorun Automatically", 2, 259, 216, 29, 0)
GUICtrlSetOnEvent($Buttonh4,"f3")
$Buttonh5 = GUICtrlCreateButton("Feature 4: Enable FFX After Detect Autorun", 2, 330, 216, 29, 0)
GUICtrlSetOnEvent($Buttonh5,"f4")
$Buttonh6 = GUICtrlCreateButton("Feature 5: Create Virtual Autorun.inf", 2, 397, 216, 29, 0)
GUICtrlSetOnEvent($Buttonh6,"f5")
$Grouph1 = GUICtrlCreateGroup("", 224, 44, 443, 383)
$Edith1 = GUICtrlCreateEdit("", 231, 55, 417, 360)

GUICtrlCreateGroup("", -99, -99, 1, 1)
$Labelh3 = GUICtrlCreateLabel("Abdulkarem bouta", 1, 0, 90, 17)
$Labelh4 = GUICtrlCreateLabel("Idon't Speak English very well cause i arabic", 462, 3, 214, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
Func h1()
GUICtrlSetData($Edith1, StringFormat("My Program named (IMPROVED DISK SECURITY) \r\nThat just protect USB and Fixed drive,It has very excellent Features to protect it\r\nby using Unlocker version 1.8.9\r\n\r\nMore Improved Versions coming soon...."))
EndFunc

Func f2()
GUICtrlSetData($Edith1, StringFormat("FULL FIX FEATURE: This feature very important after you detect any autorun you can simply run this feature FFX\r\nBUT! before you will run this feature please save all yor work and close it and then click on it and all the process\r\nwill be closed but system process not terminated after closing you will see a window that contain the closed\r\nprograms this window contain App. name - Location - Attrib - Created Time\r\nIf you  suspicion for any program you have four choices:\r\n1-Block: Delete this program and move it to the quarantine\r\n2-Delete: Delete this program and make a backup in quarantine\r\n3-Run: Run This Program and nothing will happen to it\r\n4-Ignore: Ignore this program and it will not delete it and run it"))
EndFunc


Func f1()
GUICtrlSetData($Edith1, StringFormat("My Program Using Unlocker that help to unlock the (autorun.inf) and delete it because the virus\r\nlock it and it wil be not deletable"))	
EndFunc
Func f3()
GUICtrlSetData($Edith1, StringFormat("In this feature if the program catch any autorun it will be deleted automatic but if you disable this feature\r\nthe autorun will not deleted automatically and you have to press the button remove"))	
EndFunc
Func f4()
GUICtrlSetData($Edith1, StringFormat("If my program catch any autorun it will ask to run (FFX) immediately to run it . (See Feature 2)"))	
EndFunc
Func f5()
GUICtrlSetData($Edith1, StringFormat("This Feature Create a folder that name (Autorun.inf) if any virus try to put the ((FILE)) autorun.inf in any drive\r\nthis File autorun.inf will be stored in the FOLDER AUTORUN.INF"))
EndFunc
Func clo()
	Select
		Case @GUI_CtrlId = -3 
			Exit
	EndSelect
	EndFunc
While 1
Sleep(70000)
WEnd