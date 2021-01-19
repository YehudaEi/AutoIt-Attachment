#include <GUIConstants.au3>

Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=form2.kxfdocuments\sync files\scripting\autoit\form2.kxf
$Form1_1 = GUICreate("Choose network map...", 661, 441, 204, 157, BitOR($WS_MINIMIZEBOX,$WS_SIZEBOX,$WS_THICKFRAME,$WS_SYSMENU,$WS_CAPTION,$WS_POPUP,$WS_POPUPWINDOW,$WS_GROUP,$WS_BORDER,$WS_CLIPSIBLINGS))
GUISetIcon("D:\003.ico")
GUISetFont(11, 400, 0, "Verdana")
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1_1Close")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "Form1_1Minimize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "Form1_1Maximize")
GUISetOnEvent($GUI_EVENT_RESTORE, "Form1_1Restore")
$grpChoices = GUICtrlCreateGroup("Mapping choices:  ", 5, 5, 650, 360)
GUICtrlSetFont(-1, 16, 400, 0, "Verdana")
$ckbxFlash = GUICtrlCreateCheckbox("Edward\Flash Projects", 395, 155, 225, 30)
GUICtrlSetFont(-1, 12, 800, 0, "Verdana")
GUICtrlSetResizing(-1, $GUI_DOCKHCENTER+$GUI_DOCKVCENTER+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetOnEvent(-1, "ckbxFlashClick")
$ckbxDocs = GUICtrlCreateCheckbox("Edward\Documents", 235, 65, 200, 30)
GUICtrlSetFont(-1, 12, 800, 0, "Verdana")
GUICtrlSetResizing(-1, $GUI_DOCKHCENTER+$GUI_DOCKVCENTER+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetOnEvent(-1, "ckbxDocsClick")
$ckbxSoft = GUICtrlCreateCheckbox("Edward\EdsSoftware", 50, 155, 215, 30)
GUICtrlSetFont(-1, 12, 800, 0, "Verdana")
GUICtrlSetResizing(-1, $GUI_DOCKHCENTER+$GUI_DOCKVCENTER+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetOnEvent(-1, "ckbxSoftClick")
$ckbxPics = GUICtrlCreateCheckbox("Edward\Pictures", 50, 245, 175, 30)
GUICtrlSetFont(-1, 12, 800, 0, "Verdana")
GUICtrlSetResizing(-1, $GUI_DOCKHCENTER+$GUI_DOCKVCENTER+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetOnEvent(-1, "ckbxPicsClick")
$ckbxDownloads = GUICtrlCreateCheckbox("Edward\Downloads", 395, 245, 195, 30)
GUICtrlSetFont(-1, 12, 800, 0, "Verdana")
GUICtrlSetResizing(-1, $GUI_DOCKHCENTER+$GUI_DOCKVCENTER+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetOnEvent(-1, "ckbxDownloadsClick")
$iconDocs = GUICtrlCreateIcon("C:\WINDOWS\system32\shell32.dll", -127, 315, 95, 32, 32, BitOR($SS_NOTIFY,$WS_GROUP))
GUICtrlSetOnEvent(-1, "ckbxDocsClick")
$iconSoft = GUICtrlCreateIcon("C:\WINDOWS\system32\shell32.dll", -5, 137, 185, 32, 32, BitOR($SS_NOTIFY,$WS_GROUP))
GUICtrlSetOnEvent(-1, "ckbxSoftClick")
$iconFlash = GUICtrlCreateIcon("C:\Program Files\Adobe\Adobe Flash CS3\Flash.exe", -6, 495, 185, 32, 32, BitOR($SS_NOTIFY,$WS_GROUP))
GUICtrlSetOnEvent(-1, "ckbxFlashClick")
$iconDownloads = GUICtrlCreateIcon("C:\WINDOWS\system32\shell32.dll", -89, 495, 275, 32, 32, BitOR($SS_NOTIFY,$WS_GROUP))
GUICtrlSetOnEvent(-1, "ckbxDownloadsClick")
$iconPics = GUICtrlCreateIcon("C:\WINDOWS\system32\shell32.dll", -128, 137, 275, 32, 32, BitOR($SS_NOTIFY,$WS_GROUP))
GUICtrlSetOnEvent(-1, "ckbxPicsClick")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$btnOK = GUICtrlCreateButton("&OK", 110, 380, 135, 45, 0)
GUICtrlSetFont(-1, 10, 400, 0, "Verdana")
GUICtrlSetOnEvent(-1, "btnOKClick")
$btnCancel = GUICtrlCreateButton("&Cancel", 415, 380, 135, 45, 0)
GUICtrlSetFont(-1, 10, 400, 0, "Verdana")
GUICtrlSetOnEvent(-1, "btnCancelClick")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
Sleep(100)
WEnd

Func btnCancelClick()
	While 1
		$btnCancel = GUIGetMsg()
		If $btnCancel = $GUI_EVENT_CLOSE Then ExitLoop
	Wend
EndFunc
Func btnOKClick()

EndFunc
Func ckbxDocsClick()
	; Disconnect
	DriveMapDel("Z:")
	; Map Z drive
	DriveMapAdd("Z:", "\\Edward\Users\Edward P. Sager\Documents")
EndFunc
Func ckbxDownloadsClick()
	; Disconnect
	DriveMapDel("S:")
	; Map S drive
	DriveMapAdd("S:", "\\Edward\Downloads")
EndFunc
Func ckbxFlashClick()
; Disconnect
	DriveMapDel("X:")
	; Map X drive
	DriveMapAdd("X:", "\\Edward\Flash Projects")
EndFunc
Func ckbxPicsClick()
; Disconnect
	DriveMapDel("W:")
	; Map W drive
	DriveMapAdd("W:", "\\Edward\Users\Edward P. Sager\Pictures")
EndFunc
Func ckbxSoftClick()
	; Disconnect
	DriveMapDel("Y:")
	; Map Y drive
	DriveMapAdd("Y:", "\\Edward\EdsSoftware")
EndFunc
Func Form1_1Close()

EndFunc
Func Form1_1Maximize()

EndFunc
Func Form1_1Minimize()

EndFunc
Func Form1_1Restore()

EndFunc
