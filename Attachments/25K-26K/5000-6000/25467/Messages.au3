#Region Header

#cs

	Title:			Management of Script Communications UDF Library for AutoIt3
	Filename:		Messages.au3
	Description:	Exchange of data between scripts
	Author:			Yashied
	Version:		1.1
	Requirements:	AutoIt v3.3 +, Developed/Tested on WindowsXP Pro Service Pack 2
	Uses:			None
	Notes:			This library based on the MessageHandler.au3
					(http://www.autoitscript.com/forum/index.php?act=attach&type=post&id=22855)

	Available functions:

	_MsgReceiverList
	_MsgRegister
	_MsgRelease
	_MsgSend
	_MsgTimerInterval
	_MsgWindowHandle

	Additional features:

	_IsReceiver

	Example:

		#Include <EditConstants.au3>
		#Include <GUIConstantsEx.au3>
		#Include <GUIEdit.au3>
		#Include <GUISlider.au3>
		#Include <StaticConstants.au3>
		#Include <WindowsConstants.au3>

		#Include <Messages.au3>

		#NoTrayIcon

		if StringLower(StringRight(@ScriptFullPath, 3)) = 'au3' then
			MsgBox(64, 'Messages UDF Library Demonstration', 'To run this script, you must first compile it and then run the (.exe) file.')
			exit
		endif

		Opt('MustDeclareVars', 1)

		if $CmdLine[0] = 0 then
			ShellExecute(@ScriptFullPath, '1')
			ShellExecute(@ScriptFullPath, '2')
			ShellExecute(@ScriptFullPath, '3')
			exit
		endif

		local $Form, $Input1, $Input2, $Radio1, $Radio2, $Radio3, $ButtonSend, $Edit, $Slider, $Check

		switch $CmdLine[1]
			case '1', '2', '3'
				_Main(Int($CmdLine[1]))
			case else

		endswitch

		func _Main($Index)

			local $GUIMsg, $nScript, $Data, $Timer = _MsgTimerInterval(0)

			$Form = GUICreate('Script' & $Index, 324, 384, (@DesktopWidth - 1018) / 2 + ($Index - 1) * 344, (@DesktopHeight - 440) / 2, BitOR($WS_CAPTION, $WS_SYSMENU), $WS_EX_TOPMOST)

			GUISetFont(8.5, 400, 0, 'Tahoma', $Form)

			GUICtrlCreateLabel('Message:', 14, 22, 48, 14)
			$Input1 = GUICtrlCreateInput('', 64, 19, 246, 20)
			GUICtrlCreateLabel('Send to:', 14, 56, 48, 14)

			GUIStartGroup()

			$Radio1 = GUICtrlCreateRadio('Script1', 64, 56, 56, 14)
			GUICtrlSetState(-1, $GUI_CHECKED)
			$Radio2 = GUICtrlCreateRadio('Script2', 130, 56, 56, 14)
			$Radio3 = GUICtrlCreateRadio('Script3', 196, 56, 56, 14)

			$ButtonSend = GUICtrlCreateButton('Send', 236, 88, 75, 23)
			GUICtrlSetState(-1, $GUI_DEFBUTTON)
			GUICtrlCreateLabel('', 14, 128, 299, 2, $SS_ETCHEDHORZ)
			GUICtrlCreateLabel('Received message:', 14, 142, 98, 14)
			$Edit = GUICtrlCreateEdit('', 14, 160, 296, 129, BitOR($ES_READONLY, $WS_VSCROLL, $WS_HSCROLL))
			GUICtrlSetBkColor(-1, 0xFFFFFF)
			GUICtrlCreateLabel('Timer interval (ms):', 14, 316, 98, 14)
			$Slider = GUICtrlCreateSlider(110, 312, 162, 26, BitOR($TBS_AUTOTICKS, $WS_TABSTOP))
			GUICtrlSetLimit(-1, 20, 1)
			GUICtrlSetData(-1, $Timer / 50)
			_GUICtrlSlider_SetTicFreq(-1, 1)
			$Input2 = GUICtrlCreateInput($Timer, 274, 313, 36, 20, $ES_READONLY)
			GUICtrlSetBkColor(-1, 0xFFFFFF)
			$Check = GUICtrlCreateCheckBox('Enable receiver', 14, 354, 96, 19)
			GUICtrlSetState(-1, $GUI_CHECKED)

			Opt('GUICloseOnESC', 0)

			GUISetState()

			_MsgRegister('Script' & $Index, '_Receiver')

			while 1
				$GUIMsg = GUIGetMsg()
				select
					case $GUIMsg = $GUI_EVENT_CLOSE
						exit
					case $GUIMsg = $ButtonSend
						for $i = $Radio1 to $Radio3
							if GUICtrlRead($i) = $GUI_CHECKED then
								$nScript = 1 + $i - $Radio1
								exitloop
							endif
						next
						$Data = GUICtrlRead($Input1)
						if StringStripWS($Data, 3) = '' then
							$Data = '(empty)'
						endif
						if _IsReceiver('Script' & $nScript) then
							_MsgSend('Script' & $nScript, 'From Script' & $Index & ':  ' & $Data)
						endif
					case $GUIMsg = $Slider
						_MsgTimerInterval($Timer)
					case $GUIMsg = $Check
						if GUICtrlRead($Check) = $GUI_CHECKED then
							GUICtrlSetState($Edit, $GUI_ENABLE)
							GUICtrlSetBkColor($Edit, 0xFFFFFF)
							GUICtrlSetState($Slider, $GUI_ENABLE)
							GUICtrlSetState($Input2, $GUI_ENABLE)
							_MsgRegister('Script' & $Index, '_Receiver')
						else
							GUICtrlSetState($Edit, $GUI_DISABLE)
							GUICtrlSetBkColor($Edit, $GUI_BKCOLOR_TRANSPARENT)
							GUICtrlSetState($Slider, $GUI_DISABLE)
							GUICtrlSetState($Input2, $GUI_DISABLE)
							_MsgRegister('Script' & $Index, '')
						endif
				endselect
				$Data = GUICtrlRead($Slider) * 50
				if BitXOR($Data, $Timer) then
					$Timer = $Data
					GUICtrlSetData($Input2, $Timer)
				endif
			wend
		endfunc; _Main

		func _Receiver($sMessage)
			_GUICtrlEdit_AppendText($Edit, $sMessage & @CRLF)
			return 0
		endfunc; _Receiver

#ce

#Include-once

#EndRegion Header

#Region Local Variables and Constants

dim $msgId[1][6] = [[0, 0, 100, DllCallbackRegister('_queue', 'none', ''), 0, 'lib10rsZd']]

#cs

DO NOT USE THIS ARRAY IN THE SCRIPT, INTERNAL USE ONLY!

$msgId[0][0]   - Count item of array
	  [0][1]   - Reserved
	  [0][2]   - Message timer interval, ms (see _MsgTimerInterval())
	  [0][3]   - Handle to callback function
	  [0][4]   - The control identifier as returned by "SetTimer" function (see _MsgRegister())
	  [0][5]   - Suffix of the title registered window (Don`t change it)

$msgId[i][0]   - The control identifier (controlID) as returned by _MsgRegister()
	  [i][1]   - Registered receiver ID name
	  [i][2]   - Registered user function
	  [i][3]   - Handle to registered window
	  [i][4-5] - Reserved

#ce

dim $msgQueue[1][2] = [[0]]

#cs

DO NOT USE THIS ARRAY IN THE SCRIPT, INTERNAL USE ONLY!

$msgQueue[0][0] - Count item of array
	     [0][1] - Don`t used
	 
$msgQueue[i][0] - Registered user function ($msgId[i][2])
	     [i][1] - Message data

#ce

const $MSG_WM_COPYDATA = 0x004A

local $OnMessagesExit = Opt('OnExitFunc', 'OnMessagesExit')

local $wmInt = 0
local $qeInt = 0

#EndRegion Local Variables and Constants

#Region Public Functions

; #FUNCTION# ========================================================================================================================
; Function Name:	_MsgReceiverList
; Description:		Retrieves a list of receivers.
; Syntax:			_MsgReceiverList (  )
; Parameter(s):		None.
; Return Value(s):	Returns an array of matching receiver names that have been registered by a _MsgRegister() function.
;					The zeroth array element contains the number of receivers.
; Author(s):		Yashied
; Note(s):			Returned variable will always be an array and a dimension of not less than 1.
;====================================================================================================================================

func _MsgReceiverList()

	local $wList = WinList(), $Lenght = StringLen($msgId[0][5])
	
	dim $rList[1] = [0]
	for $i = 1 to $wList[0][0]
		if StringRight($wList[$i][0], $Lenght) = $msgId[0][5] then
			redim $rList[$rList[0] + 2]
			$rList[0] += 1
			$rList[$rList[0]] = StringTrimRight($wList[$i][0], $Lenght)
		endif
	next
	return $rList
endfunc; _MsgReceiverList

; #FUNCTION# ========================================================================================================================
; Function Name:	_MsgRegister
; Description:		Creates a registers the specified function as a receiver.
; Syntax:			_MsgRegister ( $sIdentifier, $sFunction )
; Parameter(s):		$sIdentifier - Local identifier (any name) to be registered at the receive of messages. If the receiver with the
;								   specified identifier already exists in the system will be sets @error flag.
;					$sFunction   - The name of the function to call when a message is received. Not specifying this parameter
;								   will be removed the receiver associated with the $sIdentifier. The function cannot be a built-in AutoIt
;								   function or plug-in function and must have the following header:
;
;								   func _MyReceiver($sMessage)
;
;								   IMPORTANT! The function should return 0 for successful completion, otherwise the functions will be called
;								   again later, etc. until it is returned to zero. This is necessary to control access to shared data (if any).
;								   For this purpose you can use specifying additional control flags:
;
;								   local $IntFlag = 0
;
;								   _MsgRegister('my_local_receiver_id_name', '_MyReceiver')
;
;								   ...
;
;								   $IntFlag = 1
;
;								   ; At this point, the _MyReceiver() is locked.
;
;								   $IntFlag = 0
;
;								   ...
;
;								   func _MyReceiver($sMessage)
;									   if $IntFlag = 1 then
;										   return 1
;									   endif
;
;									   ...
;
;									   return 0
;								   endfunc; _MyReceiver
;
; Return Value(s):	Success: Returns the identifier (controlID) of the new registered receiver.
;					Failure: Returns 0 and sets the @error flag to non-zero.
; Author(s):		Yashied
; Note(s):			-
;====================================================================================================================================

func _MsgRegister($sIdentifier, $sFunction)
	
	local $ID, $Title
	local $i, $j = 0, $k, $l, $b, $t
	
	if (not IsString($sIdentifier)) or (not IsString($sFunction)) or ($msgId[0][3] = 0) or (StringStripWS($sIdentifier, 8) = '') then
		return SetError(1, 0, 0)
	endif
	
	$sFunction = StringStripWS($sFunction, 3)
	$t = StringLower($sIdentifier)
	for $i = 1 to $msgId[0][0]
		if StringLower($msgId[$i][1]) = $t then
			$j = $i
			exitloop
		endif
	next
	
	if $j = 0 then
		$Title = $sIdentifier & $msgId[0][5]
		if ($sFunction = '') or (IsHWnd(_winhandle($Title))) then
			return SetError(0, 0, 1)
		endif
		$ID = 1
		do
			$b = 1
			for $i = 1 to $msgId[0][0]
				if $msgId[$i][0] = $ID then
					$ID += 1
					$b = 0
					exitloop
				endif
			next
		until $b
		if $msgId[0][0] = 0 then
			_start()
			if @error then
				return 0
			endif
		endif
		redim $msgId[$msgId[0][0] + 2][6]
		$msgId[$msgId[0][0] + 1][0] = $ID
		$msgId[$msgId[0][0] + 1][1] = $sIdentifier
		$msgId[$msgId[0][0] + 1][2] = $sFunction
		$msgId[$msgId[0][0] + 1][3] = GUICreate($Title)
		$msgId[$msgId[0][0] + 1][4] = 0
		$msgId[$msgId[0][0] + 1][5] = 0
		$msgId[0][0] += 1
		if $msgId[0][0] = 1 then
			GUIRegisterMsg($MSG_WM_COPYDATA, '_WM_COPYDATA')
		endif
		return SetError(0, 0, $ID)
	endif
	
	if $sFunction > '' then
		$msgId[$j][2] = $sFunction
		$ID = $msgId[$j][0]
	else
		$wmInt = 1
		
		$k = 1
		$t = StringLower($msgId[$j][2])
		while $k <= $msgQueue[0][0]
			if StringLower($msgQueue[$k][0]) = $t then
				for $i = $k to $msgQueue[0][0] - 1
					for $l = 0 to 1
						$msgQueue[$i][$l] = $msgQueue[$i + 1][$l]
					next
				next
				redim $msgQueue[$msgQueue[0][0]][2]
				$msgQueue[0][0] -= 1
				continueloop
			endif
			$k += 1
		wend
		if $msgId[0][0] = 1 then
			GUIRegisterMsg($MSG_WM_COPYDATA, '')
			_stop()
		endif
		GUIDelete($msgId[$j][3])
		for $i = $j to $msgId[0][0] - 1
			for $l = 0 to 5
				$msgId[$i][$l] = $msgId[$i + 1][$l]
			next
		next
		redim $msgId[$msgId[0][0]][6]
		$msgId[0][0] -= 1
		$ID = 0
		
		$wmInt = 0
	endif
	
	return SetError(0, 0, $ID)
endfunc; _MsgRegister

; #FUNCTION# ========================================================================================================================
; Function Name:	_MsgRelease
; Description:		Removes all registered local receivers.
; Syntax:			_MsgRelease (  )
; Parameter(s):		None.
; Return Value(s):	Success: Returns 1.
;					Failure: Returns 0 and sets the @error flag to non-zero.
; Author(s):		Yashied
; Note(s):			-
;====================================================================================================================================

func _MsgRelease()
	
	$wmInt = 1
	
	redim $msgQueue[1][2]
	$msgQueue[0][0] = 0
	GUIRegisterMsg($MSG_WM_COPYDATA, '')
	for $i = 1 to $msgId[0][0]
		GUIDelete($msgId[$i][3])
	next
	redim $msgId[1][6]
	$msgId[0][0] = 0
	_stop()
	
	$wmInt = 0
	
	return SetError(@error, 0, (not @error))
endfunc; _MsgRelease

; #FUNCTION# ========================================================================================================================
; Function Name:	_MsgSend
; Description:		Sends a data to the registered receiver.
; Syntax:			_MsgSend ( $sIdentifier, $sMessage )
; Parameter(s):		$sIdentifier - The identifier (name) of the registered receiver.
;					$sMessage    - The string of data to send.
; Return Value(s):	Success: Returns 1.
;					Failure: Returns 0 and sets the @error flag to non-zero. @extended flag can also be set to following values:
;							-1 - if message queue busy
;							 2 - if registered window not found
;
; Author(s):		Yashied
; Note(s):			-
;====================================================================================================================================

func _MsgSend($sIdentifier, $sMessage)
	
	local $hWnd, $SendErr = false, $aRet, $tMessage, $tCOPYDATA
	
	if (not IsString($sIdentifier)) or (not IsString($sMessage)) or (StringStripWS($sIdentifier, 8) = '') then
		return SetError(1, 0, 0)
	endif
	
	$hWnd = _winhandle($sIdentifier & $msgId[0][5])
	if $hWnd = 0 then 
		return SetError(1, 2, 0)
	endif
	
	$tMessage = DllStructCreate('char[' & StringLen($sMessage) + 1 & ']')
	DllStructSetData($tMessage, 1, $sMessage)
	$tCOPYDATA = DllStructCreate('dword;dword;ptr')
	DllStructSetData($tCOPYDATA, 2, StringLen($sMessage) + 1)
	DllStructSetData($tCOPYDATA, 3, DllStructGetPtr($tMessage))
	$aRet = DllCall('user32.dll', 'lparam', 'SendMessage', 'hwnd', $hWnd, 'int', $MSG_WM_COPYDATA, 'wparam', 0, 'lparam', DllStructGetPtr($tCOPYDATA))
	if @error then
		$SendErr = 1
	endif
	$tCOPYDATA = 0
	$tMessage = 0
	if $SendErr then
		return SetError(1, 0, 0)
	endif
	if $aRet[0] = -1 then
		return SetError(1,-1, 0)
	endif
	return SetError(0, 0, 1)
endfunc; _MsgSend

; #FUNCTION# ========================================================================================================================
; Function Name:	_MsgTimerInterval
; Description:		Sets a frequency of the processing queue messages.
; Syntax:			_MsgTimerInterval ( $iTimerInterval )
; Parameter(s):		$iTimerInterval - Timer interval in millisecond.
; Return Value(s):	Success: Returns a new timer interval.
;					Failure: Returns a previous (or new) timer interval is used and sets the @error flag to non-zero.
; Author(s):		Yashied
; Note(s):			The time interval during which messages reach the receiver. The initial (at the start of the script) value of the
;					timer interval is 100.
;====================================================================================================================================

func _MsgTimerInterval($iTimerInterval)
	
	if not IsInt($iTimerInterval) then
		return SetError(1, 0, $msgId[0][2])
	endif
	if $iTimerInterval = 0 then
		return SetError(0, 0, $msgId[0][2])
	endif
	if $iTimerInterval < 50 then
		$iTimerInterval = 50
	endif
	_stop()
	if @error then
		return SetError(1, 0, $msgId[0][2])
	endif
	$msgId[0][2] = $iTimerInterval
	_start()
	if @error then
		GUIRegisterMsg($MSG_WM_COPYDATA, '')
		return SetError(1, 0, $msgId[0][2])
	endif
	return $msgId[0][2]
endfunc; _MsgTimerInterval

; #FUNCTION# ========================================================================================================================
; Function Name:	_MsgWindowHandle
; Description:		Retrieves an internal handle of a window associated with the receiver.
; Syntax:			_MsgWindowHandle ( $controlID )
; Parameter(s):		$controlID - The control identifier (controlID) as returned by a _MsgRegister() function.
; Return Value(s):	Success: Returns handle to registered window.
;					Failure: Returns 0.
; Author(s):		Yashied
; Note(s):			-
;====================================================================================================================================

func _MsgWindowHandle($controlID)
	
	if not IsInt($controlID) then
		return 0
	endif
	
	for $i = 1 to $msgId[0][0]
		if $msgId[$i][0] = $MsgID then
			return $msgId[$i][3]
		endif
	next
	return 0
endfunc; _MsgWindowHandle

; #FUNCTION# ========================================================================================================================
; Function Name:	_IsReceiver
; Description:		Check if the identifier associated with the receiver.
; Syntax:			_IsReceiver ( $sIdentifier )
; Parameter(s):		$sIdentifier - The identifier (name) to check.
; Return Value(s):	Success: Returns 1.
;					Failure: Returns 0 if identifier is not associated with the receiver.
; Author(s):		Yashied
; Note(s):			-
;====================================================================================================================================

func _IsReceiver($sIdentifier)
	if (not IsString($sIdentifier)) or (_winhandle($sIdentifier & $msgId[0][5]) = 0) then 
		return 0
	endif
	return 1
endfunc; _IsReceiver

#EndRegion Public Functions

#Region Internal Functions

func _function($hWnd)
	for $i = 0 to $msgId[0][0]
		if $msgId[$i][3] = $hWnd then
			return $msgId[$i][2]
		endif
	next
	return 0
endfunc; _function

func _message($sFunction, $sMessage)
	redim $msgQueue[$msgQueue[0][0] + 2][2]
	$msgQueue[$msgQueue[0][0] + 1][0] = $sFunction
	$msgQueue[$msgQueue[0][0] + 1][1] = $sMessage
	$msgQueue[0][0] += 1
endfunc; _message

func _queue()
	
	if ($wmInt = 1) or ($qeInt = 1) or ($msgQueue[0][0] = 0) then
		return
	endif
	
	$qeInt = 1
	
	local $Ret = Call($msgQueue[1][0], $msgQueue[1][1])
	
	if (@error = 0xDEAD) and (@extended = 0xBEEF) then
;		$wmInt = 1
;		_WinAPI_ShowError($msgQueue[1][0] & '(): Function does not exist or invalid number of parameters.')
;		exit
	else
		
		local $Lenght = $msgQueue[0][0] - 1
		
		switch $Ret
			case 0
				for $i = 1 to $Lenght
					for $j = 0 to 1
						$msgQueue[$i][$j] = $msgQueue[$i + 1][$j]
					next
				next
;				if $msgQueue[0][0] > $Lenght + 1 then
;					$wmInt = 1
;					_WinAPI_ShowError('The message(s) was lost.')
;					exit
;				endif
				redim $msgQueue[$Lenght + 1][2]
				$msgQueue[0][0] = $Lenght
			case else
				if $Lenght > 1 then
					_swap(1, 2)
				endif
		endswitch
	endif
	
	$qeInt = 0
endfunc; _queue

func _start()
	
	local $aRet
	
	if $msgId[0][4] = 0 then
		$aRet = DllCall('user32.dll', 'int', 'SetTimer', 'hwnd', 0, 'int', 0, 'int', $msgId[0][2], 'ptr', DllCallbackGetPtr($msgId[0][3]))
		if (@error) or ($aRet[0] = 0) then
			return SetError(1, 0, 0)
		endif
		$msgId[0][4] = $aRet[0]
	endif
	return SetError(0, 0, 1)
endfunc; _start

func _stop()
	
	local $aRet
	
	if $msgId[0][4] > 0 then
		$aRet = DllCall('user32.dll', 'int', 'KillTimer', 'hwnd', 0, 'int', $msgId[0][4])
		if (@error) or ($aRet[0] = 0) then
			return SetError(1, 0, 0)
		endif
		$msgId[0][4] = 0
	endif
	return SetError(0, 0, 1)
endfunc; _stop

func _swap($Index1, $Index2)
	
	local $tmp
	
	for $i = 0 to 1
		$tmp = $msgQueue[$Index1][$i]
		$msgQueue[$Index1][$i] = $msgQueue[$Index2][$i]
		$msgQueue[$Index2][$i] = $tmp
	next
endfunc; _swap

func _winhandle($sTitle)
	
	local $wList = WinList()
	
	$sTitle = StringLower($sTitle)
	for $i = 1 to $wList[0][0]
		if Stringlower($wList[$i][0]) = $sTitle then
			return $wList[$i][1]
		endif
	next
	return 0
endfunc; _winhandle

func _WM_COPYDATA($hWnd, $msgID, $wParam, $lParam)
	
	if ($wmInt = 1) then
		return -1
	endif
	
	local $Function = _function($hWnd)
	
	if $Function > '' then

		local $tCOPYDATA = DllStructCreate('dword;dword;ptr', $lParam)
		local $tMsg = DllStructCreate('char[' & DllStructGetData($tCOPYDATA, 2) & ']', DllStructGetData($tCOPYDATA, 3))

		_message($Function, DllStructGetData($tMsg, 1))
		return 0
	endif
	
	return 'GUI_RUNDEFMSG'
endfunc; _WM_COPYDATA

func OnMessagesExit()
	GUIRegisterMsg($MSG_WM_COPYDATA, '')
	_stop()
	DllCallbackFree($msgId[0][3])
	Call($OnMessagesExit)
endfunc; OnMessagesExit

#EndRegion Internal Functions
