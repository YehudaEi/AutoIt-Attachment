; Script Start - Add your code below here
#RequireAdmin
Opt("TrayAutoPause",0)
Opt("TrayIconHide", 0)

#include <GUIConstantsEx.au3>
#include <GuiButton.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <ProgressConstants.au3>
#include <GDIPlus.au3>
#Include <WinAPI.au3>
#include <array.au3>
#include <file.au3>
#include <GUIComboBox.au3>
#include <GUIComboBoxEx.au3>



;~ $themeName = InputBox("Create Content Update exe", "Please type the theme name." & @CRLF & @CRLF & "NO SPACES!! Use '_' where spaces are in name", "Theme_name")
;~ MsgBox(4096,"Result", "You typed: " & $themeName)

; Shows the filenames of all files in the current directory.
$search = FileFindFirstFile("ContentUpdates\mphoto\*.*")
$themes = "ContentUpdates\mphoto\themelist.txt"

; Check if the search was successful
If $search = -1 Then
	MsgBox(0, "Error", "No files/directories matched the search pattern")
	Exit
EndIf

While 1
	$file = FileFindNextFile($search) 
	If @error Then ExitLoop
		$strCount = StringLen($file)
		$strLeft = StringLeft($file, $strCount - 16)
		FileOpen($themes)
		FileWrite($themes, $strLeft & "|")

	
;~ 	MsgBox(4096, "File:", $file)
WEnd

; Close the search handle
$themelist = FileReadLine($themes,1)
FileClose($search)
FileDelete($themes)





Global $hCombo

_Main ()

Func _Main ()
$gui = GUICreate("Create exe", 460, 250)
	FileInstall("images\gui_header.jpg", @TempDir & "\" & "gui_header.jpg")
	GUICtrlCreatePic(@TempDir & "\" & "gui_header.jpg",0,0,460,33)
;~ 		$frame = GUICtrlCreateLabel("", 30, 45, 400, 160,  ($SS_SUNKEN))
		$hCombo = _GUICtrlComboBoxEx_Create($gui,$themelist, 40, 100, 380, 296)
		$titleLeft = 40
		$titleTop = 40
		$titleText = "   Update"
		$title = GUICtrlCreateLabel($titleText, $titleLeft, $titleTop)
;~ 		$text = "Choose a theme to make a setup file for download on the website."
		$text = $themelist
		$textBoxTop = 60
		$textBoxLeft = 40
		$textBoxWidth = 380
		$textBoxHeight = 30
		$textBox = GUICtrlCreateLabel($text, $textBoxLeft, $textBoxTop, $textBoxWidth, $textBoxHeight,  ($SS_LEFT))
		$butNext = GUICtrlCreateButton("Next", 350, 210,90,30,BitOr($BS_DEFPUSHBUTTON, $BS_NOTIFY))
		$butCancel = GUICtrlCreateButton("Cancel", 250, 210,90,30,BitOr($BS_DEFPUSHBUTTON, $BS_NOTIFY))
	
	
	GUISetState()
	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
	While 1
		Switch GUIGetMsg()
;~ 			Case $GUI_EVENT_CLOSE
;~ 				ExitLoop
				Case $GUI_EVENT_CLOSE
					$yesno = MsgBox(8196,"Cancel setup", "Are you sure you want to cancel this operation?")
					if $yesno = 6 then Exit						
				Case $butCancel
					$yesno = MsgBox(8196,"Cancel setup", "Are you sure you want to cancel this operation?")
					if $yesno = 6 then Exit
				Case $butNext
					MsgBox(4096,"result", "You have chosen: " & $hCombo)
		EndSwitch
	WEnd




	
$file = FileOpen("compile.bat", 1)

; Check if file opened for writing OK
If $file = -1 Then
    MsgBox(0, "Error", "Unable to open file.")
    Exit
EndIf

FileWrite($file, "@echo off" & @CRLF)
FileWrite($file, "Aut2exe.exe /in ContentUpdate.au3 /out test.exe /icon images/app.ico" & @CRLF)
FileWrite($file, "exit")
FileClose($file)

Run($file)

EndFunc   ;==>_Main


Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR

	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $hCombo
			Switch $iCode
				Case $CBEN_BEGINEDIT ; Sent when the user activates the drop-down list or clicks in the control's edit box.
					_DebugPrint("$CBEN_BEGINEDIT" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					Return 0
				Case $CBEN_DELETEITEM
					_DebugPrint("$CBEN_DELETEITEM" & _GetComboBoxEx($ilParam))
					Return 0
				Case $CBEN_DRAGBEGINA, $CBEN_DRAGBEGINW
					Local $tInfo = DllStructCreate($tagNMCBEDRAGBEGIN, $ilParam)
					If DllStructGetData($tInfo, "ItemID") Then _DebugPrint("$CBEN_DRAGBEGIN" & _GetComboBoxEx($ilParam))
					_DebugPrint("$CBEN_DRAGBEGIN" & @LF & "--> hWndFrom:" & @TAB & DllStructGetData($tInfo, "hWndFrom") & @LF & _
							"-->IDFrom:" & @TAB & DllStructGetData($tInfo, "IDFrom") & @LF & _
							"-->Code:" & @TAB & DllStructGetData($tInfo, "Code") & @LF & _
							"-->ItemID:" & @TAB & DllStructGetData($tInfo, "ItemID") & @LF & _
							"-->Text:" & @TAB & DllStructGetData($tInfo, "Text"))
					; return is ignored
				Case $CBEN_ENDEDITA, $CBEN_ENDEDITW ; Sent when the user has concluded an operation within the edit box or has selected an item from the control's drop-down list.
					Local $tInfo = DllStructCreate($tagNMCBEENDEDIT, $ilParam)
					_DebugPrint("$CBEN_ENDEDIT" & @LF & "--> hWndFrom:" & @TAB & DllStructGetData($tInfo, "hWndFrom") & @LF & _
							"-->IDFrom:" & @TAB & DllStructGetData($tInfo, "IDFrom") & @LF & _
							"-->Code:" & @TAB & DllStructGetData($tInfo, "Code") & @LF & _
							"-->fChanged:" & @TAB & DllStructGetData($tInfo, "fChanged") & @LF & _
							"-->NewSelection:" & @TAB & DllStructGetData($tInfo, "NewSelection") & @LF & _
							"-->Text:" & @TAB & DllStructGetData($tInfo, "Text") & @LF & _
							"-->Why:" & @TAB & DllStructGetData($tInfo, "Why"))
					Return False ; accept the notification and allow the control to display the selected item
;~ 					Return True  ; otherwise
				Case $CBEN_GETDISPINFOA, $CBEN_GETDISPINFOW ; Sent to retrieve display information about a callback item
					_DebugPrint("$CBEN_GETDISPINFO" & _GetComboBoxEx($ilParam))
					Return 0
				Case $CBEN_INSERTITEM
					Local $tInfo = DllStructCreate($tagNMCOMBOBOXEX, $ilParam)
					Local $tBuffer = DllStructCreate("wchar Text[" & DllStructGetData($tInfo, "TextMax") & "]", DllStructGetData($tInfo, "Text"))
					_DebugPrint("$CBEN_INSERTITEM" & @LF & "--> hWndFrom:" & @TAB & DllStructGetData($tInfo, "hWndFrom") & @LF & _
							"-->IDFrom:" & @TAB & DllStructGetData($tInfo, "IDFrom") & @LF & _
							"-->Code:" & @TAB & DllStructGetData($tInfo, "Code") & @LF & _
							"-->Mask:" & @TAB & DllStructGetData($tInfo, "Mask") & @LF & _
							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
							"-->Text:" & @TAB & DllStructGetData($tBuffer, "Text") & @LF & _
							"-->TextMax:" & @TAB & DllStructGetData($tInfo, "TextMax") & @LF & _
							"-->Indent:" & @TAB & DllStructGetData($tInfo, "Indent") & @LF & _
							"-->Image:" & @TAB & DllStructGetData($tInfo, "Image") & @LF & _
							"-->SelectedImage:" & @TAB & DllStructGetData($tInfo, "SelectedImage") & @LF & _
							"-->OverlayImage:" & @TAB & DllStructGetData($tInfo, "OverlayImage") & @LF & _
							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
					Return 0
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func _GetComboBoxEx($ilParam)
	Local $tInfo = DllStructCreate($tagNMCOMBOBOXEX, $ilParam)
	Local $aItem = _GUICtrlComboBoxEx_GetItem ($hCombo, DllStructGetData($tInfo, "Item"))
	Return @LF & "--> hWndFrom:" & @TAB & DllStructGetData($tInfo, "hWndFrom") & @LF & _
			"-->IDFrom:" & @TAB & DllStructGetData($tInfo, "IDFrom") & @LF & _
			"-->Code:" & @TAB & DllStructGetData($tInfo, "Code") & @LF & _
			"-->Mask:" & @TAB & DllStructGetData($tInfo, "Mask") & @LF & _
			"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
			"-->Text:" & @TAB & $aItem[0] & @LF & _
			"-->TextMax:" & @TAB & $aItem[1] & @LF & _
			"-->Indent:" & @TAB & $aItem[2] & @LF & _
			"-->Image:" & @TAB & $aItem[3] & @LF & _
			"-->SelectedImage:" & @TAB & $aItem[4] & @LF & _
			"-->OverlayImage:" & @TAB & $aItem[5] & @LF & _
			"-->Param:" & @TAB & $aItem[5]
EndFunc   ;==>_GetComboBoxEx

Func _DebugPrint($s_text, $line = @ScriptLineNumber)
	ConsoleWrite( _
			"!===========================================================" & @LF & _
			"+======================================================" & @LF & _
			"-->Line(" & StringFormat("%04d", $line) & "):" & @TAB & $s_text & @LF & _
			"+======================================================" & @LF)
EndFunc   ;==>_DebugPrint
