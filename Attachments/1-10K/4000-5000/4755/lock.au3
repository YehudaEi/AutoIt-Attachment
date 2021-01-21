; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 (beta)
; Language:       English
; Platform:       WinXP
; Author:         Cybie / Archrival / MSLx Fanboy / Random667
;
; Script Function:
;    Fake the "computer locked" dialog so that AutoIt may run in the background.
;
; ----------------------------------------------------------------------------
#include <GuiConstants.au3>
#include <string.au3>
#include <misc.au3>
#region Setup password
; Read ini for password
Global $password = IniRead('password.ini', 'password', 'password', '')
; Check if password saved
If Not $password Then
	Do
		; If no Password saved open input box
		$password = InputBox('Login', 'Please enter your Password and click OK', '', '*')
		If @error = 1 Then Exit
		If Not ValidUserPassword($password) Then
			MsgBox(4096, 'Error', 'Incorrect password')
		Else
			ExitLoop
		EndIf
	Until 0
EndIf
#endregion Setup Password
; Minimize all open windows
WinMinimizeAll()
; Get PC info
#region Config OS-dependent images
$ImageDir = @TempDir & '\Lock-Screen\' & @OSVersion
If @OSVersion = 'WIN_XP' Then
	If @DesktopDepth > 8 Then
		$FileName = 'High.bmp'
		FileInstall('WIN_XP\High.bmp', $ImageDir & '\' & $FileName)
		FileInstall('WIN_XP\Liner_High.bmp', $ImageDir & '\Liner_' & $FileName)
	Else
		$FileName = 'Low'
		FileInstall('WIN_XP\Low.bmp', $ImageDir & '\' & $FileName)
		FileInstall('WIN_XP\Liner_Low.bmp', $ImageDir & '\Liner_' & $FileName)
	EndIf
	$StripeStart = 72
ElseIf @OSVersion = 'WIN_2000' Then
	If @DesktopDepth > 8 Then
		$FileName = 'High.bmp'
		FileInstall('WIN_2000\High.bmp', $WinImage, 1)
		FileInstall('WIN_2000\Liner_High.bmp', $WinStripe, 1)
	Else
		$FileName = 'Low.bmp'
		FileInstall('WIN_2000\Low.bmp', $ImageDir & '\' & $FileName)
		FileInstall('WIN_2000\Liner_Low.bmp', $ImageDir & '\Liner_' & $FileName)
	EndIf
	$StripeStart = 76
EndIf
$WinImage = $ImageDir & '\' & $FileName
$WinStripe = $ImageDir & '\Liner_' & $FileName
#endregion Config OS-dependent images
; Create Backgroung GUI.
GUICreate('x', @DesktopWidth, @DesktopHeight + 100, -1, -1, 0x80000000)
$colors = StringSplit(RegRead('HKEY_CURRENT_USER\Control Panel\Colors', 'Background'), ' ')
GUISetBkColor('0x' & Hex($colors[1], 2) & Hex($colors[2], 2) & Hex($colors[3], 2))
GUISetState()
#region Config Login GUI
; Create Login GUI.
$SecurityImage = @TempDir & '\' & 'lock.ico'
FileInstall('lock.ico', $SecurityImage, 1)
GUICreate('Computer Locked', 413, 218, -1, (@DesktopHeight / 2) - (@DesktopHeight / 4.25), 0x00000000)
GUISetBkColor(0xE0E0C0)
GUICtrlCreatePic($WinImage, 0, 0, 0, 0)
GUICtrlCreatePic($WinStripe, 0, $StripeStart, 0, 0)
GUICtrlCreateIcon($SecurityImage, 0, 5, 82)
GUICtrlCreateLabel('User Name:', 50, 80)
GUICtrlCreateLabel('Password:', 50, 105)
$Namebox = GUICtrlCreateInput(@UserName, 120, 80, 250, 20, $GUI_DISABLE)
$loginbox = GUICtrlCreateInput('', 120, 105, 250, 20, $ES_PASSWORD)
$btn = GUICtrlCreateButton('OK', 120, 130, 60, 20)
#endregion Config Login GUI
GUISetState()
; Set vars and hotkey for enter button
;HotKeySet('{ENTER}', 'openbox')
;Set focus to password box
ControlFocus('Computer Locked', '', $loginbox)
While 1
	If _IsPressed ('09') Or _IsPressed ('12') Or _IsPressed ('1B') Then TrapKey ()
	;Keep login box on top
	WinSetOnTop('Computer Locked', '', 1)
	; Kill Explorer & Task Manager
	ProcessClose('Explorer.exe')
	ProcessClose('taskmgr.exe')
	If GUIGetMsg() = $btn Then
		;Let login box go under error message
		WinSetOnTop('Computer Locked', '', 0)
		If (GUICtrlRead($loginbox) = $password) Or (GUICtrlRead($loginbox) = INIPassword()) Then
			Run('Explorer.exe', '')
			ExitLoop
		Else
			MsgBox(16, 'Error', 'Invalid Password', 1)
			;Reset Password Box Focus
			ControlFocus('Computer Locked', '', $loginbox)
		EndIf
	EndIf
WEnd
Func ValidUserPassword($password)
	Local $Run_Opt = opt('RunErrorsFatal', 0)
	RunAsSet(@UserName, '', $password)
	Local $Ret_Val = Not RunWait(@ComSpec & ' /c dir 1 > null')
	opt('RunErrorsFatal', $Run_Opt)
	RunAsSet()
	Return $Ret_Val
EndFunc   ;==>ValidUserPassword
Func INIPassword($Encrypt = 0)
	If $Encrypt Then
		Return IniWrite('password.ini', 'password', 'password', _StringEncrypt($Encrypt, $password, @ComputerName, 1))
	Else
		Return _StringEncrypt(Not $Encrypt, IniRead('password.ini', 'password', 'password', ''), @ComputerName, 1)
	EndIf
EndFunc   ;==>INIPassword