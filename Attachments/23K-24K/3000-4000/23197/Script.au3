#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=Lock.ico
#AutoIt3Wrapper_outfile=CLOCK.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Description=CLock 1.0
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=(c) 2008 - Huynh Minh Thanh
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_Res_Field=Author|Huynh Minh Thanh
#AutoIt3Wrapper_Res_Field=Email|minhthanh.autoit@gmail.com
#AutoIt3Wrapper_Res_Field=Website|                                
#AutoIt3Wrapper_Res_Icon_Add=C:\Documents and Settings\Welcome\Desktop\AutoIT\CLock 1.0\Lock.ico
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Tidy_Stop_OnError=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs----------------------------------------------------------------------
	CLock
	v1.0 -2008
	by Huynh Minh Thanh
	Hotkeys :
	F10 : Start Program
	F11 : End Program
	While you running this program, Task Manager was disabled!
#ce ---------------------------------------------------------------------

Opt("TrayMenuMode",1)
#include <GUIConstants.au3>
#include <WindowsCOnstants.au3>

Global $regpass = "HKLM\Software\CLock\Version"
Dim $lock = 0
Dim $task = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System"
Dim $startup = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
;Global $RegEncrypt = _StringEncrypt (1,RegRead ($regpass,"Password"),"myth",1)
;Global $RegDe = _StringEncrypt (0,Regread ($regpass,"Password"),"myth",1)


HotKeySet("{F10}", "Start")
HotKeySet("{F11}", "End")


check() ; check OS Version




#Region ### START Koda GUI section ###
$SetPassGUI = GUICreate("CLock 1.0", 174, 98, -1, -1, BitOR($WS_SYSMENU, $WS_CAPTION, $WS_POPUP, $WS_POPUPWINDOW, $WS_BORDER, $WS_CLIPSIBLINGS), BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))
GUICtrlCreateLabel("Set your password for first run :", 8, 8, 162, 18)
$PassSetInput = GUICtrlCreateInput("", 8, 32, 153, 22)
$SetPass = GUICtrlCreateButton("&Set", 8, 64, 75, 25, 0,$GUI_DEFBUTTON)
$Cancel = GUICtrlCreateButton("&Cancel", 88, 64, 75, 25, 0)
GUISetState(@SW_HIDE)
#EndRegion ### END Koda GUI section ###
tray ()
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
	Case $GUI_EVENT_CLOSE
			Exit
		Case $Cancel
			Exit
		Case $SetPass
			If GUICtrlRead($PassSetInput) = "" Then
				MsgBox(64, "Error", "Please type your password", "", $SetPassGUI)
			Else
				RegWrite($regpass, "Password", "REG_SZ", GUICtrlRead($PassSetInput))
				lock()
			EndIf
	EndSwitch
WEnd

;-------------------------------------------------------------------------------------------------------------------------------



Func Start()
	$regreadpass = RegRead($regpass, "Password");doc reg
	If @error Or $regreadpass = "" Then ; neu co loi hoac password = ""
		GUISetState(@SW_SHOW, $SetPassGUI) ; hien gui de nhap mat khau
	EndIf
	If $regreadpass <> "" Then
		lock() ; neu khong co loi hoac pass <> "" (da co) : khoa may tinh
	EndIf
EndFunc   ;==>Start


Func lock()
	$lock = 1
	Local $PassRead = RegRead($regpass, "Password")
	GUISetState(@SW_HIDE, $SetPassGUI)
	$LWindow = GUICreate("CLock v 1.0 - by Huynh Minh Thanh", @DesktopWidth, @DesktopHeight, 0, 0, $WS_DISABLED)
	GUISetState(@SW_SHOW, "CLock v 1.0 - by Huynh Minh Thanh")
	;--------------------------------------------------------
	$LockGui = GUICreate("", 174, 98, -1, -1, BitOR($WS_CAPTION, $WS_POPUP, $WS_BORDER, $WS_CLIPSIBLINGS), BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))
	GUICtrlCreateLabel("Enter your password :", 8, 8, 113, 18)
	$PassInput = GUICtrlCreateInput("", 8, 32, 153, 22)
	GUICtrlSetStyle ($PassINput,$WS_Password)
	$Unlock = GUICtrlCreateButton("&Unlock", 48, 64, 75, 25, 0)
	GUICtrlSetState($Unlock, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $Unlock
				If GUICtrlRead($PassInput) = $PassRead Then
					$lock = 0
					GUIDelete($LockGui)
					GUIDelete($LWindow)
				Else
					MsgBox(32, "Error!", "Password does not match!", "", $LockGui)
				EndIf
		EndSwitch
	WEnd
	WinSetTrans("CLock v 1.0 - by Huynh Minh Thanh", "", 0)
	WinSetOnTop("CLock v 1.0 - by Huynh Minh Thanh", "", 1)
	;---------------------------------------------------------
EndFunc   ;==>lock

Func End()
	If $lock = 0 Then
		Exit
	EndIf
EndFunc   ;==>End

Func check()
	RegWrite ($startup,"CLock","REG_SZ",@ScriptFullPath)
	If @OSVersion <> "WIN_XP" Then
		MsgBox(64, "Error!", "This program not supported in :" & @OSVersion, "")

		Exit
	EndIf
EndFunc   ;==>check

func tray ()
	;-------------------------------------------------------------------------------------
	$about = TrayCreateItem ("About")
	$exit = TrayCreateItem ("Exit")
	TraySetIcon ("Lock.ico")
	TraySetToolTip ("CLock 1.0")
	TraySetState ()
	; ==> tray gui
	While 1
		$msg = TrayGetMsg ()
		Select
		Case $msg = $Exit
			Exit
		case $msg = $about
	
		MsgBox (64,"Infomations","CLock v 1.0" & @CRLF & @CRLF & "by Huynh Minh Thanh" & @CRLF & "Email : minhthanh.autoit@gmail.com" & @CRLF & "Website :                                 ")
EndSelect
WEnd
;--------------------------------------------------------------------------------------------
EndFunc