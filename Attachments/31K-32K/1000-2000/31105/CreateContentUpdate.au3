; Script Start - Add your code below here
#RequireAdmin


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
#include <Process.au3>

Opt("TrayAutoPause",0)
Opt("TrayIconHide", 0)

; Shows the filenames of all files in the current directory.
$aFileList = _FileListToArray("ContentUpdates\mphoto\", "*.*", 1)
If @error Then
    MsgBox(0, "Error", "No files/directories matched the search pattern")
        Exit
EndIf

; Put array into a string
$sFileList = "|" & _ArrayToString($aFileList, "|", 1)


_Main ()

Func _Main ()
$gui = GUICreate("Create exe", 460, 250)
		GUICtrlCreatePic("images\gui_header.jpg",0,0,460,33)
		$box = GUICtrlCreateGroup("Create Update",30,45,400,160)
		$text = "Choose a theme to make a setup file for download on the website."
		$textBoxTop = 70
		$textBoxLeft = 50
		$textBoxWidth = 360
		$textBoxHeight = 20
		$textBox = GUICtrlCreateLabel($text, $textBoxLeft, $textBoxTop, $textBoxWidth, $textBoxHeight,  ($SS_LEFT))
		$hCombo = GUICtrlCreateCombo("", $textBoxLeft, 100, 200, "Choose")
		GUICtrlSetState(-1, $GUI_FOCUS)
		GUICtrlSetData($hCombo, $sFileList)
		$butNext = GUICtrlCreateButton("Next", 350, 210,90,30,BitOr($BS_DEFPUSHBUTTON, $BS_NOTIFY))
		$chk = GUICtrlCreateCheckbox("Open folder to view files", 100, 205, 150, 50, BitOR($BS_AUTOCHECKBOX, $BS_NOTIFY))
		_GUICtrlButton_Show($chk,False)
		_GUICtrlButton_SetCheck($chk, $BST_CHECKED)
		$butFinish = GUICtrlCreateButton("Finish", 350, 210,90,30,BitOr($BS_DEFPUSHBUTTON, $BS_NOTIFY))
		_GUICtrlButton_Show($butFinish, False)
		$butCancel = GUICtrlCreateButton("Cancel", 250, 210,90,30,($BS_NOTIFY))
		$butRestart = GUICtrlCreateButton("Make another", 250, 210,90,30,($BS_NOTIFY))
		_GUICtrlButton_Show($butRestart,False)
		$progressbar = GUICtrlCreateProgress($textboxleft,180,200,15, $PBS_MARQUEE)
		_SendMessage(GUICtrlGetHandle(-1), $PBM_SETMARQUEE, True, 50) ; final parameter is update time in ms
	
	
	GUISetState()
	While 1
		Switch GUIGetMsg()
           	 Case $GUI_EVENT_CLOSE, $butCancel
					If MsgBox(8196, "Cancel setup", "Are you sure you want to cancel this operation?") = 6 Then Exit 
								
				Case $butNext	
					_GUICtrlButton_Enable($butNext,False)
					_GUICtrlButton_Enable($butCancel,False)
					$themeEXE = GUICtrlRead($hCombo)
					$theme = StringLeft($themeEXE,StringLen($themeEXE)-16)
					if FileExists("ContentUpdates\mphoto\" & $themeEXE) = False Or GUICtrlRead($hCombo) = "" Then
					if MsgBox(8244,"ERROR", "Invalid Choice: " & """" & $theme & """" & @CRLF  & @CRLF & "Would you like to try again?") = 7 Then Exit
					Run("CreateContentUpdate.exe")
					Exit
					EndIf
					_GUICtrlComboBox_Destroy($hCombo)
					$box = GUICtrlCreateGroup("Compiling EXE - " & $themeEXE, 30, 45, 400, 160)
					$text = "Please be patient while the updateEXE is being compiled."
					$textBox = GUICtrlCreateLabel($text, $textBoxLeft, $textBoxTop, $textBoxWidth, $textBoxHeight,  ($SS_LEFT))
					Sleep(2000)
					$text = "Updating variables in ContentUpdate.au3..."
					$textBox1 = GUICtrlCreateLabel($text, $textBoxLeft, $textBoxTop+20, $textBoxWidth, $textBoxHeight,  ($SS_LEFT))
					Sleep(2000)
						;update variable $theme in ContentUpdate.au3
						$file = "ContentUpdate.au3"
						$find = "replacethistextwiththemevariablefromcreatecontentupdate.au3"
						$replace = $theme
						$retval = _ReplaceStringInFile($file, $find,$replace)
						if $retval = 0 then
							msgbox(8240, "ERROR", "Error updating variable in: " & $file & @CRLF & " Error: " & @error & @CRLF & @CRLF & "This application will now exit. Please try again." & @CRLF & "If the problem persist, please contact the developer:" & @CRLF & @CRLF & "fran@bowens.co.za" & @CRLF & "083 235 2712")
							exit
						EndIf
					
					;copy images and update file
					$text = "Copying images and update file..."
					$textBox2 = GUICtrlCreateLabel($text, $textBoxLeft, $textBoxTop+40, $textBoxWidth, $textBoxHeight,  ($SS_LEFT))
						FileCopy("images\contentupdates\" & $theme & ".gif", "temp\themeimage.gif",9)
;						FileCopy("ContentUpdates\mphoto\" & $themeEXE, "temp\update.exe",9)
						
					;compile script to exe using DOS command.
					$text = "Compiling script to exe... (This might take a while)"
					$textBox2 = GUICtrlCreateLabel($text, $textBoxLeft, $textBoxTop+60, $textBoxWidth, $textBoxHeight,  ($SS_LEFT))
;						_RunDOS("""C:\Program Files\AutoIt3\Aut2Exe\Aut2exe.exe"" /in ContentUpdate.au3 /out "& $themeEXE & " /icon images/app.ico")
						
					;Cleaning up
					$text = "Cleaning up..."
					$textBox2 = GUICtrlCreateLabel($text, $textBoxLeft, $textBoxTop+80, $textBoxWidth, $textBoxHeight,  ($SS_LEFT))	
						FileDelete("temp\update.exe")
						FileDelete("temp\themeimage.gif")
						FileMove($themeEXE, "ContentUpdates\_final\" & $themeEXE,1)
					
					;change variable $theme back to "replacethistextwiththemevariablefromcreatecontentupdate.au3" ContentUpdate.au3
						$file = "ContentUpdate.au3"
						$find = $theme
						$replace = "replacethistextwiththemevariablefromcreatecontentupdate.au3"
						$retval = _ReplaceStringInFile($file, $find,$replace)
				
			ExitLoop
		EndSwitch
	WEnd
		
		
		_GUICtrlButton_Destroy($butNext)
		_GUICtrlButton_Destroy($butCancel)
		_GUICtrlButton_Show($butFinish, True)
		GUICtrlSetState(-1, $GUI_FOCUS)
		_GUICtrlButton_Show($chk,True)
;~ 		_GUICtrlButton_Show($butRestart,True)



While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE 
				Exit
				
			Case $butFinish
				$chkstatus = _GUICtrlButton_GetCheck($chk)
				if $chkstatus = 0 then
				If MsgBox(8196, "Sucess", "Would you like to make another one?") = 6 Then
					Run("CreateContentUpdate.au3")
					Exit
				EndIf
				Else
				If MsgBox(8196, "Sucess", "Would you like to make another one?") = 6 Then
				Run("CreateContentUpdate.au3")
				EndIf
				ShellExecute("ContentUpdates\_final")
				ExitLoop
				Exit
				EndIf
;~ 			Case $butRestart
;~ 				Run("CreateContentUpdate.exe")
;~ 			ExitLoop
		EndSwitch
WEnd
				

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
