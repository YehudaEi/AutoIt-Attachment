#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
#AutoIt3Wrapper_Run_After=del /f /q "%scriptdir%\%scriptfile%_Obfuscated.au3"
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

If Not @Compiled Then Exit MsgBox(16, "Information!", "To lazy to write code for running without compiling, so you will need to compile this in order for the script to work correctly.")

#Include <GUIConstantsEx.au3>
#Include <WindowsConstants.au3>

#Include <WinAPI.au3>

AutoItSetOption("GUIOnEventMode", 1)
AutoItSetOption("GUIEventOptions", 1)

Global $Timer = TimerInit()
Global $OldTime = TimerDiff($Timer); Timing stuff for prevent duplicate calls

#region - Script Customized Singleton -
; We first register a windows message (or script message ;) look at _IPC_RegisterEvent('ASciTE')
; this way, when a user dropps files on the exe or activates us again, we either
; open the files in the previous ASciTE or activate our window
Global $AS_ACTIVATE = 100; used to tell ASciTE to activate its window
Global $AS_DROPPEDFILES = 200; used to tell ASciTE to open dropped files
Global $SM_ACTION; We will register a WM (Windows Message) to handle other initializations
Global $LoadCommand ; used for file path transfer
If @Compiled Then _IPC_RegisterEvent('Only One Instance');A uniqe identifying string name, here we intercept any other activity for quick processing, but it's a little random and doesn't work when it feels like it as it seems...
#endregion - Script Customized Singleton -

#Region - Example -

Global $Editor_UI = GUICreate("Drag and drop files on compiled script or reactivate script", 400, 300, -1, -1, BitOR($WS_CAPTION, $WS_SYSMENU, $WS_THICKFRAME, $WS_MINIMIZEBOX, $WS_MAXIMIZEBOX))
Global $hListView = GUICtrlCreateListView("Recieved from secondary instance", 0 , 0, 399, 299)
DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", GUICtrlGetHandle($hListView), "uint", 0x1000 + 30, "wparam", 0, "lparam", 350)
GUISetOnEvent(-3, "_UI_Terminate")
GUISetState()

GUIRegisterMsg($SM_ACTION, "_IPC_RecieveMessage");IPC message, used to handle multiple instances (I.E., activating an existing instance or opening files dropped on our application executable)

Sleep(9999999)

#EndRegion - Example -

#region - Simple IPC -

#CS
	Super simple IPC (Inter process communication)

	_IPC_RegisterEvent($sOccurenceName) - Modified _singleton, it will register a mutex, and do some other neat stuff, like send a command to the existing process!
	_IPC_BroadcastEvent($ID, $sText) - Posts a message to the existing process, ID specifies action to take, like calling a certain function, look at _IPC_RecieveMessage

	_IPC_RecieveMessage([Default WM Params]) - Used only by the primary script to recive commands and variables
#CE

Func _IPC_RegisterEvent($sOccurenceName)
	Local Const $ERROR_ALREADY_EXISTS = 183

	Local $RT = DllCall("User32.dll", "int", "RegisterWindowMessageW", "WSTR", $sOccurenceName); Register our special message
	If @error Or $RT[0] = 0 Then Return SetError(1, 0, 0);Doesn't matter if things don't work here, we'll just loose some misc features that don't even matter to normal operation
	$SM_ACTION = $RT[0]; set global var so we can use it

	DllCall("kernel32.dll", "handle", "CreateMutexW", "struct*", 0, "bool", 1, "wstr", $sOccurenceName); _Singlton() - I took it apart for what I needed only
	If @error Then Return SetError(@error, @extended, 0)
	Local $lastError = DllCall("kernel32.dll", "dword", "GetLastError")
	If @error Then Return SetError(@error, @extended, 0)
	If $lastError[0] = $ERROR_ALREADY_EXISTS Then
		Switch $CmdLine[0]
			Case True;Files dropped on exe, tell the preexisting instance that it should open these files quickly
				Local $FileString
				For $I = 0 To $CmdLine[0]
					$FileString &= "<" & $CmdLine[$I] & ">";Wrap file strings to get the easily when recieving them
				Next
				_IPC_BroadcastEvent($AS_DROPPEDFILES, $FileString)
			Case False; no files dropped, activate the initial instance!
				_IPC_BroadcastEvent($AS_ACTIVATE, 0)
		EndSwitch
		Exit
	Else; return because we are the initial instance
		Return SetError(0, 0, 1)
	EndIf
EndFunc   ;==>_IPC_RegisterEvent

Func _IPC_BroadcastEvent($ID, $sText)
	If Not $SM_ACTION Then Return
	Local $Struct = DllStructCreate("uint;Char[" & StringLen($sText)+1 & "]")
	DllStructSetData($Struct, 1, $ID)
	DllStructSetData($Struct, 2, $sText)
	Local $StructPtr = DllStructGetPtr($Struct)
	DllCall("user32.dll", "lresult", "SendMessage", "hwnd", 0xFFFF, "uint", $SM_ACTION, "wparam", @AutoItPID, "lparam", $StructPtr);0xFFFF = all windows
EndFunc   ;==>_IPC_BroadcastEvent

Func _IPC_RecieveMessage($hWnd, $Msg, $ProcessID, $Pointer)
	#forceref $hwnd, $Msg
	If (TimerDiff($Timer) - $OldTime) < 800 Then
		; I don't know what I did wrong but suddenly the message is being double posted
		; this is to prevent such bullshit from taking place.
		MsgBox(0,"OldTime:"&$OldTime,"Stopped Action time:"&TimerDiff($Timer))
		$OldTime = TimerDiff($Timer)
		Return $GUI_RUNDEFMSG
	EndIf

	Local $hProcess = _WinAPI_OpenProcess(0x0010, False, $ProcessID)
	If @error Then Return $GUI_RUNDEFMSG

	Local $StructTag = "uint;Char[1024]"; structure that will hold the data... IPC = Inter process communication
	Local $Struct = DllStructCreate($StructTag)
	Local $StructSize = DllStructGetSize($Struct)
	Local $StructPtr = DllStructGetPtr($Struct)
	Local $iRead
	_WinAPI_ReadProcessMemory($hProcess, $Pointer, $StructPtr, $StructSize, $iRead)

	Switch DllStructGetData($Struct, 1)
		Case $AS_ACTIVATE;Register the window activation since no files were dropped on the exe
			AdlibRegister("_UI_Activate", 1500); Cannot activate from this function, use adlib to call it instead!
			;Timing seems to be very important here, I have no idea why though

		Case $AS_DROPPEDFILES; extract file strings and reister a function to deal with the $LoadCommand variable when we're done executing in the spectrum
			Local $Files = StringRegExp(DllStructGetData($Struct, 2), "<(.*?)>", 3); get file strings passed
			If IsArray($Files) Then
				$LoadCommand = $Files
				AdlibRegister("_UI_LoadCommand", 800)
				;timing seems to be unimportant here, the process can be interupted safely as it seems...
			EndIf

	EndSwitch
	$OldTime = TimerDiff($Timer)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_IPC_RecieveMessage

#endregion - Simple IPC -

Func _UI_Activate()
	AdlibUnRegister("_UI_Activate")
	GUICtrlCreateListViewItem("Activated by secondary instance!", $hListView)
	GUISetState(@SW_RESTORE, $Editor_UI)
	WinActivate($Editor_UI, "")
EndFunc   ;==>_UI_Activate

; #FUNCTION# ====================================================================================================================
; Name ..........: _UI_LoadCommand
; Description ...: Used by the IPC functions to load files
; Syntax ........: _UI_LoadCommand()
; Parameters ....: None
; Return values .: None
; ===============================================================================================================================
Func _UI_LoadCommand()
	Local $Pos = ControlGetPos($Editor_UI, "", $hListView)
	GUICtrlDelete($hListView)
	$hListView = GUICtrlCreateListView("Recieved from secondary instance",$Pos[0], $Pos[1], $pos[2], $Pos[3])
	DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", GUICtrlGetHandle($hListView), "uint", 0x1000 + 30, "wparam", 0, "lparam", 350)
	AdlibUnRegister("_UI_LoadCommand")
	If IsArray($LoadCommand) Then
		For $I = 0 To UBound($LoadCommand) - 1
			GUICtrlCreateListViewItem($LoadCommand[$I], $hListView)
		Next
;~ 		_ArrayDisplay($LoadCommand)
		$LoadCommand = 0
	EndIf
	Return 0
EndFunc   ;==>_UI_LoadCommand

Func _UI_Terminate()
	Exit
EndFunc
