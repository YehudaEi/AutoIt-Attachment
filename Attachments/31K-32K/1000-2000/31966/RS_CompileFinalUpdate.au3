#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=GUI\images\RapidStudio Assist.ico
#AutoIt3Wrapper_Outfile=\RS_CompileFinalUpdate.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=Create Content Downloads for web
#AutoIt3Wrapper_Res_Description=Create Content Updates for RapidStudio Software.
#AutoIt3Wrapper_Res_Fileversion=4.0.0.21
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=Y
#AutoIt3Wrapper_Res_ProductVersion=6.0.1.58
#AutoIt3Wrapper_Res_LegalCopyright=www.rapidstudio.co.za
#AutoIt3Wrapper_Res_Field=Contact Phone|011 225 0522
#AutoIt3Wrapper_Res_Field=Contact Email|info@rapidstudio.co.za
#AutoIt3Wrapper_Res_Field=Contact Website|www.rapidstudio.co.za
#AutoIt3Wrapper_Run_Tidy=Y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#cs -------------------------------------------------------------------------------------------

	AutoIt Version:   3.3.6.1
	Author:           Francisca Carstens
	Date last edited: 01/09/2010

	Script Function:
	Compile content updates (themes) for RapidStudio software for users to download from the website.
	Locate RapidStudio installdir and apply various fixes. (copied from RS_genpatch.au3)

#ce -------------------------------------------------------------------------------------------

; Script Start - Add your code below here

#include <GUIConstantsEx.au3>
#include <GuiButton.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <ProgressConstants.au3>
#include <GDIPlus.au3>
#include <WinAPI.au3>
#include <Array.au3>
#include <file.au3>
#include <GUIComboBox.au3>
#include <GUIComboBoxEx.au3>
#include <Process.au3>
#include <GUI\AutoIt\Include\_LargeFileCopy.au3>


Opt("TrayAutoPause", 0)
Opt("TrayIconHide", 0)



_Main()

Func _Main()

	Local $textBoxTop = 70, $textBoxLeft = 50, $textBoxWidth = 360, $textBoxHeight = 20

	Global $configDir = @ScriptDir & "\config\"
	Global $imageDIR = @ScriptDir & "\images\"

	$gui = GUICreate("Create exe", 460, 270, -1, -1, $WS_EX_APPWINDOW)
	GUICtrlCreatePic(@ScriptDir & "\images\gui_header.jpg", 0, 0, 460, 33)
	$box = GUICtrlCreateGroup("Create Update", 30, 45, 400, 160)
	$text = "Choose a theme to make a setup file for download on the website."
	$textBox = GUICtrlCreateLabel($text, $textBoxLeft, $textBoxTop, $textBoxWidth, $textBoxHeight)
	$butNext = GUICtrlCreateButton("Next", 460 - 90 - 30, 210, 90, 30, $BS_DEFPUSHBUTTON)
	$butCancel = GUICtrlCreateButton("Cancel", 460 - 90 - 30 - 100, 210, 90, 30)


	#Region ComboBox
	; Shows the filenames of all files in the current directory.
	$aFileList = _FileListToArray($configDir & "\themes\", "*.ini", 1)
	If @error Then
		MsgBox(0, "Error", "No files/directories matched the search pattern")
		Exit
	EndIf
	; Put array into a string
	$eFileList = "|" & _ArrayToString($aFileList, "|", 1)

	$iMax = $aFileList[0]
	Dim $iniFile[$iMax]
	Dim $ini[$iMax]
	For $i = 1 To $iMax - 1
		$ini[$i] = $aFileList[$i]
		$iniFile[$i] = $configDir & "themes\" & $aFileList[$i]
		$cc = IniRead($iniFile[$i], "PHOTOBOOKS", "IMAGE_CONTENTUPDATE", "")
		$dd = IniRead($iniFile[$i], "PHOTOBOOKS", "MPHOTO_EXE", "")
		$ee = IniRead($iniFile[$i], "CALENDARS", "IMAGE_CONTENTUPDATE", "")
		$ff = IniRead($iniFile[$i], "CALENDARS", "MPHOTO_EXE", "")
		If (($cc = "" And $dd = "") Or ($ee = "" And $ff = "")) Then
			$eFileList = StringReplace($eFileList, $ini[$i] & "|", "")
		EndIf
	Next

	$sFileList = StringReplace($eFileList, ".ini", "")

	Global $hCombo = GUICtrlCreateCombo("", $textBoxLeft, 100, 200)
	GUICtrlSetState(-1, $GUI_FOCUS)
	GUICtrlSetData(-1, $sFileList)
	_GUICtrlComboBox_SetExtendedUI(-1, True)
	#EndRegion ComboBox

	$radio1 = GUICtrlCreateRadio("Photobooks", $textBoxLeft, 150, 90, 20)
	$radio2 = GUICtrlCreateRadio("Calendars", $textBoxLeft + 90 + 15, 150, 90, 20)
	$radio3 = GUICtrlCreateRadio("Miscellaneous", $textBoxLeft, 150 + 30, 90, 20)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$radio4 = GUICtrlCreateRadio("Ultimate", $textBoxLeft + 90 + 15, 150 + 30, 90, 20)
	GUICtrlSetState(-1, $GUI_DISABLE)

	GUISetState()

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $butCancel
				If MsgBox(8196, "Cancel setup", "Are you sure you want to cancel this operation?") = 6 Then Exit

			Case $butNext
				If BitAND(GUICtrlRead($radio1), $GUI_CHECKED) = $GUI_CHECKED Then
					$CATEGORY = "PHOTOBOOKS"
				ElseIf BitAND(GUICtrlRead($radio2), $GUI_CHECKED) = $GUI_CHECKED Then
					$CATEGORY = "CALENDARS"
				ElseIf BitAND(GUICtrlRead($radio3), $GUI_CHECKED) = $GUI_CHECKED Then
					$CATEGORY = "MISCELLANEOUS"
				ElseIf BitAND(GUICtrlRead($radio4), $GUI_CHECKED) = $GUI_CHECKED Then
					$CATEGORY = "ULTIMATE"
				Else
					$CATEGORY = ""
				EndIf

				GUICtrlSetState($butNext, $GUI_DISABLE)
				GUICtrlSetState($butCancel, $GUI_DISABLE)

				If GUICtrlRead($hCombo) = "" Then
					If MsgBox(8244, "ERROR", "Invalid Choice!" & @CRLF & @CRLF & "Would you like to try again?") = 7 Then Exit
					GUICtrlSetState($butNext, $GUI_ENABLE)
					GUICtrlSetState($butCancel, $GUI_ENABLE)
					GUICtrlSetData($hCombo, $sFileList) ; This clears the invalid selection from the combo
				Else
					If $CATEGORY = "" Then
						MsgBox(4096, "Error", "Please select a category")
						GUICtrlSetState($butNext, $GUI_ENABLE)
						GUICtrlSetState($butCancel, $GUI_ENABLE)
					Else
						$SECTION = $CATEGORY
						$ini = GUICtrlRead($hCombo) & ".ini"
						$iniFile = $configDir & "themes\" & $ini
						$THEME_NAME = IniRead($iniFile, "DETAILS", "THEME_NAME", "")
						$KEYWORDS = IniRead($iniFile, "DETAILS", "KEYWORDS", "")
						$DESCRIPTION = IniRead($iniFile, "DETAILS", "DESCRIPTION", "")
						$SAMPLE_ALBUMS = IniRead($iniFile, $SECTION, "SAMPLE_ALBUMS", "")
						$IMAGE_CONTENTUPDATE = IniRead($iniFile, $SECTION, "IMAGE_CONTENTUPDATE", "")
						$inputIMAGE_CONTENTUPDATE = $imageDIR & $IMAGE_CONTENTUPDATE
						$IMAGE_WEB = IniRead($iniFile, $SECTION, "IMAGE_WEB", "")
						$inputIMAGE_WEB = $imageDIR & "web\" & $IMAGE_WEB
						$MYSQL_ID = IniRead($iniFile, $SECTION, "MYSQL_ID", "")
						$MPHOTO_EXE = IniRead($iniFile, $SECTION, "MPHOTO_EXE", "")
						$FINAL_EXE = $THEME_NAME & "_content_add_" & $CATEGORY & ".exe"

						If FileExists($configDir & "\mphoto_exe\" & $CATEGORY & "\" & $MPHOTO_EXE) = False Or $MPHOTO_EXE = "" Then
							MsgBox(4096, "Error", "There is no " & $CATEGORY & " update for " & $THEME_NAME & " theme. Please create one first.")
							GUICtrlSetState($butNext, $GUI_ENABLE)
							GUICtrlSetState($butCancel, $GUI_ENABLE)
						Else
							GUICtrlSetState($hCombo, $GUI_HIDE)
							GUICtrlSetState($radio1, $GUI_HIDE)
							GUICtrlSetState($radio2, $GUI_HIDE)
							GUICtrlSetState($radio3, $GUI_HIDE)
							GUICtrlSetState($radio4, $GUI_HIDE)
							; Start the progress bar
							$progressbar = GUICtrlCreateProgress($textBoxLeft, 180, 230, 15, $PBS_MARQUEE)
							_SendMessage(GUICtrlGetHandle(-1), $PBM_SETMARQUEE, True, 20) ; final parameter is update time in ms
							GUICtrlSetData($box, "Compiling EXE - " & $THEME_NAME)
							GUICtrlSetData($textBox, "Please be patient while the updateEXE is being compiled.")
							Sleep(2000)
							$textBox1 = GUICtrlCreateLabel("Updating variables in ContentUpdate.au3...", $textBoxLeft, $textBoxTop + 20, $textBoxWidth, $textBoxHeight)
							Sleep(2000)
							;update variable $theme in ContentUpdate.au3
							_ReplaceString(@ScriptDir & "\ContentUpdate.au3", "replacethistextwiththemevariablefromcreatecontentupdate.au3", $THEME_NAME) ;<<<<<<<<<<<<<<<<<<< ($file,$find,$replace)
							;copy images and update file
							$textBox2 = GUICtrlCreateLabel("Copying images and update file...", $textBoxLeft, $textBoxTop + 40, $textBoxWidth, $textBoxHeight)
							Sleep(2000) ; ~~~~~~~~~~~~~~~~~~~~~~

							FileCopy($imageDIR & $CATEGORY & "\" & $IMAGE_CONTENTUPDATE, @ScriptDir & "\temp\themeimage.jpg", 9) ; ~~~~~~~~~~~~~~~

							;Large File Copy
							Local $filecopy_ret
							Local $filecopy_src = $configDir & "mphoto_exe\" & $CATEGORY & "\" & $MPHOTO_EXE
							Local $filecopy_destpath = @ScriptDir & "\temp"
							$filecopy_ret = _LargeFileCopy($filecopy_src, $filecopy_destpath, True)
							FileMove(@ScriptDir & "\temp\" & $MPHOTO_EXE, @ScriptDir & "\temp\" & "update.exe")

							;compile script to exe using DOS command.
							$textBox3 = GUICtrlCreateLabel("Compiling script to exe... (This might take a while)", $textBoxLeft, $textBoxTop + 60, $textBoxWidth, $textBoxHeight)
							Sleep(2000)
							_RunDOS(@ScriptDir & "\GUI\AutoIt\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\ContentUpdate.au3 /out " & @ScriptDir & "\" & "_tmp.exe" & " /icon " & @ScriptDir & "\GUI\images\app.ico")
							ProcessWaitClose("Aut2exe.exe")
							Sleep(5000)

							;Cleaning up
							$textBox4 = GUICtrlCreateLabel("Cleaning up...", $textBoxLeft, $textBoxTop + 80, $textBoxWidth, $textBoxHeight)
;~ 				#cs~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

							DirRemove(@ScriptDir & "\temp", 1)
							FileMove("_tmp.exe", $configDir & "\final_exe\" & $FINAL_EXE, 1)
;~ 				#ce~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


							;change variable $theme back to "replacethistextwiththemevariablefromcreatecontentupdate.au3" ContentUpdate.au3
							_ReplaceString(@ScriptDir & "\ContentUpdate.au3", $THEME_NAME, "replacethistextwiththemevariablefromcreatecontentupdate.au3") ;<<<<<<<<<<<<<<<<<<< ($file,$find,$replace)

							IniWrite($iniFile, $SECTION, "FINAL_EXE", $FINAL_EXE)
							IniWrite($iniFile, $SECTION, "FILE_SIZE", Round(FileGetSize($configDir & "\final_exe\" & $FINAL_EXE) / 1048576, 2) & "MB")
							FileClose($iniFile)

							; Continue tidying up by clearing the group box
							GUICtrlSetData($textBox, "")
							GUICtrlSetData($textBox1, "")
							GUICtrlSetData($textBox2, "")
							GUICtrlSetData($textBox3, "")
							GUICtrlSetData($textBox4, "")
							GUICtrlDelete($progressbar)

							ExitLoop

							; Announce success and determine next move
							If MsgBox(8196, "Success", "Would you like to make another one?") = 7 Then
								; No
;~ 						ShellExecute(@ScriptDir & "\ContentUpdates\_final", "", "", "", @SW_MAXIMIZE)
								Exit
							Else
								; Yes
								GUICtrlSetState($butNext, $GUI_ENABLE)
								GUICtrlSetState($butCancel, $GUI_ENABLE)
								GUICtrlSetData($box, "Create Update")
								GUICtrlSetData($textBox, "Choose a theme to make a setup file for download on the website.")
								GUICtrlSetState($hCombo, $GUI_SHOW)
								GUICtrlSetData($hCombo, $sFileList) ; This clears the previous selection from the combo <<<<<<<<<<<<<<<<<<<
								GUICtrlSetState($radio1, $GUI_SHOW)
								GUICtrlSetState($radio2, $GUI_SHOW)
								GUICtrlSetState($radio3, $GUI_SHOW)
								GUICtrlSetState($radio4, $GUI_SHOW)
							EndIf
						EndIf
					EndIf
				EndIf
		EndSwitch
	WEnd

EndFunc   ;==>_Main

Func _ReplaceString($file, $find, $replace)
	$retval = _ReplaceStringInFile($file, $find, $replace)
	If $retval = 0 Then
		MsgBox(8240, "ERROR", "Error updating variable in: " & $file & @CRLF & " Error: " & @error & @CRLF & @CRLF & "This application will now exit. Please try again." & @CRLF & "If the problem persist, please contact the developer:" & @CRLF & @CRLF & "fran@bowens.co.za" & @CRLF & "083 235 2712")
		Exit
	EndIf
EndFunc   ;==>_ReplaceString