#include <GuiConstants.au3>
#include <GuiConstantsEx.au3>
#include <windowsconstants.au3>
#Include <WinAPI.au3>
#include <Process.au3>


;===== SETTINGS =====
$RunApp = 1 ; 1=Notepad, In this version you can only test it with notepad


;===== VARIABELEN =====
Global Const $WM_LBUTTONDOWN = 0x0201
Global $PID, $FmTitle, $hFm

$GuiTitle = "GUI" 
$ImgTransp = @ScriptDir & "\images\transparant.gif" 


;===== RUN =====
If $RunApp = 1 Then
	_RunNotepad()
Else
	MsgBox(48, "Message", "choose 1 in the script to run Notepad" & @CRLF & "choose 2 in the script to run Filemaker Runtime")
EndIf


;===== GUI (create) =====
$GuiChild = GUICreate($GuiTitle, 900, 500, -1, -1, $ws_popup + $WS_SIZEBOX, $WS_EX_LAYERED + $WS_EX_TOOLWINDOW, $hFm)
;When a GUI window is resized the controls within react - how they react is determined by this function.
;To be able to resize a GUI window it needs to have been created with the $WS_SIZEBOX and $WS_SYSMENU styles
$Pos = WinGetPos($GuiTitle) ; x y w h
$hGui = WinGetHandle($GuiTitle)
GUISetState(@SW_SHOWDEFAULT)
Sleep(1000)
GUISetState()


;===== BUTTONS ======
$Btn_Transparent = GUICtrlCreateButton("Transparent", 0, 100, 100, 50) ; x, y, w, h
GUISetState()
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUISetState()

$Btn_UndoTransparent = GUICtrlCreateButton("Undo Transparent", 0, 150, 100, 50)
GUISetState()
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUISetState()

$Btn_Exit = GUICtrlCreateButton("Exit", 0, 200, 100, 50)
GUISetState()
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUISetState()


;===== LABEL ======
If $RunApp = 1 Then 
	GUICtrlCreateLabel("You are now using My Gui as front layer (child) and NOTEPAD behind the Gui (parent)", 10, 10, 500, 20)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKSIZE + $GUI_DOCKLEFT)
Else
	GUICtrlCreateLabel("You are now using My Gui as front layer (child) and FILEMAKER behind the Gui (parent)", 10, 10, 500, 20)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKSIZE + $GUI_DOCKLEFT)
EndIf

GUICtrlCreateLabel("Test this Gui by resizing it fast (from the right to the left) and see that my application behind follows to slow.", 10, 30, 600, 20)
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKSIZE + $GUI_DOCKLEFT)
GUICtrlCreateLabel("Use the transparent button to see what is behind the Gui", 10, 50, 500, 20)
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKSIZE + $GUI_DOCKLEFT)

GUISetState()


;===== GAP/HOLE in GUI (first time) (Transparant Image) =====
$Gap = GUICtrlCreatePic($ImgTransp, 1, 1, 1, 1, $WS_SYSMENU) 
GUICtrlSetBkColor($Gap, $GUI_BKCOLOR_TRANSPARENT)
GUISetState()

; Sets the application for the first time behind the Gui
WinMove($FmTitle, "", $Pos[0] + 80, $Pos[1] + 80, $Pos[2] - 100, $Pos[3] - 80)
Sleep(1000)
WinSetState($hFm, "", @SW_SHOW)
GUISetState()

; Makes it possible to drag the Gui at any point you click it
GUIRegisterMsg($WM_LBUTTONDOWN, "WM_LBUTTONDOWN")
GUISetState()
$hOldParent = DllCall("user32.dll", "hwnd", "SetParent", "hwnd", $hFm, "hwnd", $GuiChild)

; To get a low CPU result the FOR/NEXT loop and in combination with te CASE seems to give the best and fastest results (low CPU, about 10 instead of 30)
; I use a sleep of 10, so the buttons will react fast for you. (the CPU is then high, about 20 to 30, how can I solve this to get it lower?)
; More info http://www.autoitscript.com/forum/index.php?showtopic=32943&hl=case++faster


Global $1 = 1
For $i = 1 To 999999999999
	;local $HWND_TOPMOST
	$Pos = WinGetPos($GuiTitle) ; Position Gui, x y w h
	WinMove($FmTitle, "", $Pos[0] + 80, $Pos[1] + 60, $Pos[2] - 100, $Pos[3] - 60) ;Moves the application behind the Gui and resizes.
	;I've also tested it with the winapi options below, do I do something wrong? It dos not seem to work faster.
	;  _WinAPI_SetWindowPos($hFm , $HWND_TOPMOST, $Pos[0] + 80, $Pos[1] + 80, $Pos[2] - 100, $Pos[3] - 80,$SWP_FRAMECHANGED )
	;  _WinAPI_FlashWindowEx($hFm, 4, 100, 250)
	;  _WinAPI_UpdateWindow($hFm)
	GUISetState()

	;Resizes the gap (so you can see the application behind the GUI)
	GUICtrlSetResizing($Gap, $GUI_DOCKALL)
	GUICtrlSetPos($Gap, 100, 100, $Pos[2] - 150, $Pos[3] - 150)
	
	$Msg = GUIGetMsg()
	Select
		Case $Msg = $GUI_EVENT_RESIZED ; dialog box has been resized.
			; MsgBox(0, "", $PID & @CRLF & $hFm & @CRLF & $FmTitle)
		Case $Msg = $GUI_EVENT_CLOSE
			Exit
		Case $Msg = $Btn_Exit
			WinActivate($hFm)
			ProcessClose($PID)
			Exit
		Case $Msg = $Btn_Transparent
			WinSetTrans($GuiTitle, "", 200) ;Transparent
		Case $Msg = $Btn_UndoTransparent
			WinSetTrans($GuiTitle, "", 0) 	; Undo Transparent
			$Gap = GUICtrlCreatePic($ImgTransp, 1, 1, 1, 1, $WS_SYSMENU)
			GUICtrlSetBkColor($Gap, $GUI_BKCOLOR_TRANSPARENT)
			GUISetState()
		Case $Msg = -3 ;return NotePad / Filemaker to original owner
			$hOldParent = DllCall("user32.dll", "hwnd", "SetParent", "hwnd", $hFm, "hwnd", $hOldParent)
			Exit
	EndSelect
	
	If Not ProcessExists($PID) Then Exit
	Sleep(10)
Next

; Makes it possible to drag the Gui at any point you click it
Func WM_LBUTTONDOWN($nGui, $iMsg, $wParam, $lParam)
	If BitAND(WinGetState($nGui), 32) Then Return $GUI_RUNDEFMSG
	DllCall("user32.dll", "long", "SendMessage", "hwnd", $nGui, "int", $WM_SYSCOMMAND, "int", 0xF009, "int", 0) ;
EndFunc   ;==>WM_LBUTTONDOWN

;===== RUN NOTEPAD =====
Func _RunNotepad()
	$PID = Run("notepad.exe", "", @SW_HIDE)
	WinWait("[CLASS:Notepad]")
	$FmTitle = WinGetTitle("[CLASS:Notepad]")
	$hFm = WinGetHandle("[CLASS:Notepad]", "")
EndFunc   ;==>_RunNotepad

;===== RUN FM RUNTIME =====
Func _RunFMRuntime()
	ShellExecute(@ScriptDir & "\Runtime\Runtime.exe", "", "", "", @SW_HIDE)
	WinWait("[CLASS:FMPRO7RUNTIME]")
	Sleep(3000)
	WinActivate("[CLASS:FMPRO7RUNTIME]")
	$PID = WinGetProcess("[CLASS:FMPRO7RUNTIME]", "")
	$FmTitle = WinGetTitle("[CLASS:FMPRO7RUNTIME]")
	$hFm = WinGetHandle("[CLASS:FMPRO7RUNTIME]", "")
EndFunc   ;==>_RunFMRuntime

