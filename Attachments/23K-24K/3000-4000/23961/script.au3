#NoTrayIcon
#include <GUIConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include <GDIplus.au3>
;form start
$title = "Image Converter 1.0 - logmein"
$dir1 = IniRead (@systemdir & "\ImageConverter.ini","Settings","Dir1","")
$dir2 = IniRead (@systemdir & "\ImageConverter.ini","Settings","Dir2",@DesktopDir)
#Region ### START Koda GUI section ### Form=C:\Documents and Settings\Welcome\Desktop\Image Converter\form.kxf
$Form = GUICreate($title, 463, 171, -1, -1)
WinSetTrans ($title,"",0)
$Group1 = GUICtrlCreateGroup("Options", 8, 0, 449, 137)
$Label1 = GUICtrlCreateLabel("Source :", 16, 24, 45, 18)
$s = GUICtrlCreateInput("", 80, 24, 257, 22)
GUICtrlSetData (-1,$dir1)
$sb = GUICtrlCreateButton("...", 344, 24, 51, 25, 0)
$pre = GUICtrlCreateButton("Preview", 400, 24, 51, 25, 0)
$Label2 = GUICtrlCreateLabel("Destination :", 16, 64, 63, 18)
$d = GUICtrlCreateInput("", 80, 64, 257, 22)
GUICtrlSetData (-1,$dir2)
$db = GUICtrlCreateButton("...", 344, 64, 51, 25, 0)
$Label3 = GUICtrlCreateLabel("File name :", 16, 104, 55, 18)
$type = GUICtrlCreateList("", 208, 104, 65, 25)
GUICtrlSetData(-1, "JPG|JPEG|GIF|BMP|PNG|ICO|TIF"); mark
$n = GUICtrlCreateInput("", 80, 104, 121, 22)
$logmein = GUICtrlCreateLabel("Image Converter 1.0 - logmein", 296, 104, 145, 17, $SS_CENTER, BitOR($WS_EX_STATICEDGE,$GUI_WS_EX_PARENTDRAG))
GUICtrlSetFont(-1, 8, 400, 0, "ABC Sans Serif")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlSetCursor (-1, 0)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$ok = GUICtrlCreateButton("Convert !", 8, 144, 115, 25, $BS_DEFPUSHBUTTON)
;$h = GUICtrlCreateButton("Help", 224, 144, 75, 25, 0);disabled
$A = GUICtrlCreateButton("About", 304, 144, 75, 25, 0)
$e = GUICtrlCreateButton("Exit", 384, 144, 75, 25, 0)
GUISetState(@SW_SHOW)

;========================================================
for $i = 0 to 255 step 5
	WinSetTrans ($title,"",$i)
	Sleep (10)
Next
;========================================================
#EndRegion ### END Koda GUI section ###


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $sb
			$z1 = FileOpenDialog ("Browse for image file",GUICtrlRead ($s),"Image (*.jpg;*.gif;*.bmp;*.png;*.ico)",1,"",$form)
			if Not @error Then
				GUICtrlSetData ($s,$z1)
			EndIf
		Case $db
			$z2 = FileSelectFolder ("Browse for desination folder","",1+2+4,GUICtrlRead ($d),$form)
			if Not @error Then
				GUICtrlSetData ($d,$z2)
			EndIf
		Case $pre
			if GUICtrlRead ($s) <> "" Then
				FileOpen (guictrlread ($s),1)
			Else
				MsgBox (32,"Message","Please type or select the source file.","",$form)
			EndIf
		Case $e
			IniWrite (@systemdir & "\ImageConverter.ini","Settings","Dir1",guictrlread ($s))
			IniWrite (@systemdir & "\ImageConverter.ini","Settings","Dir2",guictrlread ($d))
			for $i = 255 to 1 step -5
				WinSetTrans ("Image Converter 1.0 - logmein","",$i)
				Sleep (10)
			Next
			Exit
		Case $ok
			convert ()
		Case $a
			MsgBox (64,"About...","Image Converter" & @Crlf & _
								"1.0" & @CRLF & @crlf & _
								"Author : logmein" & @CRLF  &  _ 
								"Email : minhthanh.autoit@gmail.com" & @CRLF & @crlf & _
								 "Support : JPG, JPEG, GIF, BMP, PNG, ICO, TIF","",$form)
		EndSwitch
WEnd
Func convert ()
	if GUICtrlRead ($d) <> "" and GUICtrlRead ($s) <> "" and GUICtrlRead ($n) <> "" and GUICtrlRead ($type) <> "" Then
	_GDIPlus_Startup ()
	$image = _GDIPlus_ImageLoadFromFile (guictrlread ($s))
	$t = _GDIPlus_EncodersGetCLSID (guictrlread ($type))
	_GDIPlus_ImageSaveToFileEx ($image,GUICtrlRead ($d) & "\" & GUICtrlRead ($n) & "." & GUICtrlRead ($type),$t)
	if not @error Then
		_GDIPlus_Shutdown ()
		WinSetTrans ($title,"",150)
		MsgBox (64,"Message","Completed convert from :" & @CRLF & GUICtrlRead ($s) & @CRLF & "To :" & GUICtrlRead ($d) & "\" & GUICtrlRead ($n) & "." & GUICtrlRead ($type),4,$form)
		WinSetTrans ($title,"",255)
	Else
		MsgBox (32,"Error","Could not convert file. Please try again!","",$form)
		_GDIPlus_Shutdown ()
	EndIf
	
	Else
	MsgBox (32,"Error","Please fill carefully file's infomation!","",$form)
	EndIf

EndFunc

