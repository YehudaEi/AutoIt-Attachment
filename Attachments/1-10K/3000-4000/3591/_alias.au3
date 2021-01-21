#include-once
; ----------------------------------------------------------------------------
;
; AutoIt Version :	3.1.0
; Author :	Groumphy <groumphy@gmail.com>
;
; Script Function :
;	Alias of some AutoIt functions.
; 	Version : F.O.2
;
; ----------------------------------------------------------------------------

; Start a file
; Author : SvenP (AutoItScript Team Forum)
; Alias of _RunDos()
Func _Start($iFileStr)
	If @OSType = 'WIN32_NT' Then
		$iStartStr = @ComSpec & ' /c start "" '
	Else
		$iStartStr = @ComSpec & ' /c start '
	EndIf
		Run($iStartStr & $iFileStr, '', @SW_HIDE)
EndFunc ; ==> _Start("myfile.chm")

; For Trial version of program
; Author : Groumphy
; Alias of _DateDiff()
#include "Date.au3"
Func _Trial($iTrialDate, $iMsgDay, $iMsgLock, $iTitle)
	$iDateCalc = _DateDiff("D",_NowCalc(),$iTrialDate)
	If $iDateCalc <= 0 Then
		MsgBox(0 + 64, $iTitle, $iMsgLock, 10)
		Exit
	Else
		MsgBox(0 + 64, $iTitle, $iMsgDay & $iDateCalc, 10)
	EndIf
EndFunc ; ==> _Trial("2005/06/01", "Nombre de jour restant : ", "Locké. Trial expiré", "version d'essais")

; Rename a file
; Author : Groumphy
; Alias of FileMove()
Func _Rename($iPath, $iOldName, $iNewName)
	; success : 1
	; failure : 0
	Return FileMove($iPath & "\" & $iOldName, $iPath & "\" & $iNewName)
EndFunc ; ==> _Rename("C:", "OldFichier.mp3", "NewFichier.mp3")

; Rename a file
; Author : Groumphy
; Alias of FileMove()
Func _Ren($iOldFile, $iNewFile)
	; succes : 1
	; failure : 0
	Return FileMove($iOldFile, $iNewFile)
EndFunc ; ==> _Ren("C:\OldFile.mp3", "C:\NewFile.mp3")

; Delete a file or a directory
; Author : Groumphy
; Alias of FileRecycle()
Func _Del($iPathFile)
	; success : 1
	; failure : 0
	Return FileRecycle($iPathFile)
EndFunc ; ==> _Del("c:\myFile.au3")

; Insert of a Txt File in a Label Control
; Author(s) : Groumphy - JDeb - Mhz
; Alias of GUICtrlCreateLabel()
#include <GUIConstants.au3>
Func _InsertTxtFileToLabel($iFilename, $iLeft, $iTop, $iHeight, $iWidth)
	; success : Control is created
	; failure : 0
	$iHandle = FileOpen($iFilename, 0)
	If @error = -1 Then Return 0
	$iFileText = FileRead($iHandle, FileGetSize($iFilename))
	If @error = -1 Then Return 0
	$iFileText = StringReplace($iFileText, @CRLF, @LF)
	If @error = 1 Then Return 0
	$iVarCtrl = GUICtrlCreateLabel($iFileText, $iLeft, $iTop, $iHeight, $iWidth)
	FileClose($iHandle)
EndFunc ; ==> _InsertTxtFileToLabel("test.txt", "10", "10", "180", "180")
#cs
Sample : 
	#include <GUIConstants.au3>
	GUICreate("My Gui", 200, 200, -1, -1)
		GUISetState(@SW_SHOW)
	Func _InsertTxtFileToLabel($iFilename, $iLeft, $iTop, $iHeight, $iWidth)
		$iHandle = FileOpen($iFilename, 0)
		$iFileText = FileRead($iHandle, FileGetSize($iFilename))
		If @error = -1 Then Exit
		$iFileText = StringReplace($iFileText, @CRLF, @LF)
		$iVarCtrl = GUICtrlCreateLabel($iFileText, $iLeft, $iTop, $iHeight, $iWidth)
		; - or -
		; GUICtrlSetData($ControlHandle, $FileText)
		FileClose($iHandle)
	EndFunc
	_InsertTxtFileToLabel("test.txt", "10", "10", "180", "180")
	While 1
		$msg = GUIGetMsg()
		If $msg = $GUI_EVENT_CLOSE Then ExitLoop
	Wend
#ce

; Make LogOff
; Author(s) : Groumphy
; Alias of Shutdown()
Func _LogOff()
	; success : 1
	; failure : 0
	Return Shutdown(0)
EndFunc

; Make Shutdown
; Author(s) : Groumphy
; Alias of Shutdown()
Func _ShutDwn()
	; success : 1
	; failure : 0
	Return Shutdown(1)
EndFunc

; Make Reboot
; Author(s) : Groumphy
; Alias of Shutdown()
Func _Reboot()
	; success : 1
	; failure : 0
	Return Shutdown(2)
EndFunc

; Make Hibernation
; Author(s) : Groumphy
; Alias of Shutdown
Func _Hibernate()
	; success : 1
	; failure : 0
	Return Shutdown(64)
EndFunc

; Find a string in a text file
; Author(s) : Burrup - Groumphy
; Alias of FileFindFirstFile ==> To string in file :-)
Func _FileFindText($iFile, $iString, $iFunctionIfStringFound, $iFunctionIfStringNotFound)
	; success : ==> Function called
	; failure : 1 (Incorrect function name for sample)
	$Source = FileRead($iFile,FileGetSize($iFile))
	If @error Then Return 1
	If StringInStr($Source, $iString) Then
		Call($iFunctionIfStringFound) ; Function to call if string is found
		If @error Then Return 1
	Else
		Call($iFunctionIfStringNotFound) ; Function to call if string is not found
		If @error Then Return 1
	EndIf
EndFunc ; ==> _FileFindText("test.txt", "my string", "_iFunctionIfStringFound", "_iFunctionIfStringNotFound")

; Give the MS-DOS 8.3 name of a file
; Author(s) : Groumphy
; Alias of FileGetShortName()
Func _MSDosName($iName)
	; success : ==> return the name
	; failure : 1
	Return FileGetShortName($iName)
EndFunc

; Function to empty an existing text file
; Author(s) : Groumphy
; Alias of FileOpen Mode 2
Func _EraseContentOfTxtFile($iFile)
	; failure = -1
	; success = File is empty
	Return FileOpen($iFile, 2)
	FileClose($iFile)
EndFunc ; ==> _EraseContentOfTxtFile("myfile.txt") 

; Turn Off the monitor
; Author(s) : Groumphy
; Alias of _Monitor Mode 0
Func _MonitorOff()
	; success : 0
	; failure : 1
	const $WM_SYSCommand = 274, $SC_MonitorPower = 61808, $Power_Off = 2
	$HWND = WinGetHandle(WinGetTitle("",""))
	DllCall("user32.dll","int","SendMessage","hwnd",$HWND,"int",$WM_SYSCommand,"int",$SC_MonitorPower,"int",$Power_Off)
		If @error Then
			Return 1
		Else
			Return 0
		EndIf
		Exit
EndFunc
	
; Wake up the monitor
; Author(s) : Groumphy
; Alias of _Monitor Mode 1
Func _MonitorOn()
	; success : 0
	; failure : 1
	const $WM_SYSCommand = 274, $SC_MonitorPower = 61808, $Power_On = -1
	$HWND = WinGetHandle(WinGetTitle("",""))
	DllCall("user32.dll","int","SendMessage","hwnd",$HWND,"int",$WM_SYSCommand,"int",$SC_MonitorPower,"int",$Power_On)
	If @error Then
		Return 1
	Else
		Return 0
	EndIf
	Exit	
EndFunc

; Mount a permanent device
; Author(s) : Groumphy
; Alias of DriveMapAdd
Func _Mount($iLetter, $iShare)
	; 1 = Undefined / Other error
	; 2 = Access to the remote share was denied
	; 3 = The device is already assigned
	; 4 = Invalid device name
	; 5 = Invalid remote share
	; 6 = Invalid password
	Return DriveMapAdd($iLetter, $iShare, 1 + 8)
EndFunc ; ==> _Mount("T", "\\SERVER\FOLDER")

; Delete a mounted device
; Author(s) : Groumphy
; Alias of DriveMapDel
Func _MountDel($iLetter)
	; success : 1
	; failed : 0
	Return DriveMapDel($iLetter)
EndFunc ; ==> _MountDel("T")

; Create an Input Box with Limit of caracter
; Author(s) : Groumphy
; Alias of GUICtrlCreateInput and GUICtrlSetLimit on Input (-1)
Func _GUICtrlCreateInputWLimit($iLimit, $iText, $iLeft, $iTop, $iWidth, $iHeight, $iStyle, $iExStyle)
	Dim $iInput
	Local $iInput
	$iInput = GUICtrlCreateInput($iText, $iLeft, $iTop, $iWidth, $iHeight, $iStyle, $iExStyle)
		Return GUICtrlSetLimit(-1, $iLimit)
EndFunc ; _GUICtrlCreateInputWithLimit(3, "The texte", 10, 50, 200, 30, -1, -1)