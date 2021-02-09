#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.4.0
 Author:         d3mon (FireFox)

 Script Function:
	Changes your WLM PSM to the music song you're listening to with VLC

#ce ----------------------------------------------------------------------------


Opt("WinTitleMatchMode", 2)

Dim $h_VLC, $s_info, $i_init, $s_time1 = "00:00/03:00" , $s_time2 = "00:01/03:00"

Dim $s_title = "Lecteur multimédia VLC" ;french title (of course change it to yours)
Dim $s_label = "VLC : " ;tell to others that you don't use the crapy wmp


While Sleep(100)
	$h_VLC = WinGetHandle("[CLASS:QWidget;TITLE:" & $s_title & "]")

	If ($h_VLC <> "") Then
		$s_time1 = _VLC_GetTime()

		If ($s_time1 <> $s_time2) Then
			$s_ID3 = StringTrimRight(WinGetTitle($h_VLC), StringLen($s_title) +3)

			ChangeMSNMessage(0, True, $s_label & $s_ID3)

			$i_init = TimerInit()
			$s_time2 = $s_time1
		ElseIf (TimerDiff($i_init) > 1300) Then
			ChangeMSNMessage(0, True, "")
		EndIf
	Else
		ChangeMSNMessage(0, True, "")
	EndIf
WEnd


; #FUNCTION# ====================================================================================================================
; Name...........: _VLC_GetTime
; Description ...: Gets the VLC media current time
; Author ........: FireFox
; ===============================================================================================================================
Func _VLC_GetTime()
	For $i = 2 To 4 ;not sure of that, just tested some times
		$s_time1 = ControlGetText($h_VLC, "", "[CLASS:QWidget; INSTANCE:" & $i & "]")
		If (StringLen($s_time1) = 13) Then Return $s_time1
	Next
EndFunc


; #FUNCTION# ====================================================================================================================
; Name...........: ChangeMSNMessage
; Description ...: Changes the MSN Messenger message.
; Syntax.........: ChangeMSNMessage ($iType, $bEnable, $szText)
; Parameters ....: $iType - Determines the type of the message :
;                  |1 - Games
;                  |2 - Office
;                  |Else - Music
;                  $bEnable		- If True enable the message
;                  $szText		- Set message text
; Author ........: CoePSX
; Modified.......: Dhilip89
; Remarks .......: Function infos by FireFox
; Link ..........: http://www.autoitscript.com/forum/index.php?showtopic=43112
; ===============================================================================================================================
Func ChangeMSNMessage ($iType, $bEnable, $szText)
	Local Const $szFormat = "CoePSX\\0%s\\0%d\\0{0}\\0%s\\0\\0\\0\\0\\0"
	Local Const $WM_COPYDATA = 0x4A
	Local $szType
	Local $szMessage
	Local $iSize
	Local $pMem
	Local $stCopyData
	Local $hWindow

	;; Format the message ;;
	Switch ($iType)
		Case 1
			$szType = "Games"
		Case 2
			$szType = "Office"
		Case Else
			$szType = "Music"
	EndSwitch

	$szMessage = StringFormat ($szFormat, $szType, $bEnable, $szText)

	;; Create a unicode string ;;
	$iSize = StringLen ($szMessage) + 1
	$pMem = DllStructCreate ("ushort[" & $iSize & "]")
	For $i = 0 To $iSize
		DllStructSetData ($pMem, 1, AscW (StringMid ($szMessage, $i, 1)), $i)
	Next
	DllStructSetData ($pMem, 1, 0, $iSize)

	;; Create the COPYDATASTRUCT ;;
	$stCopyData = DllStructCreate ("uint;uint;ptr")
	DllStructSetData ($stCopyData, 1, 0x547) ;dwData = MSN magic number
	DllStructSetData ($stCopyData, 2, ($iSize * 2)) ;cbData = Size of the message
	DllStructSetData ($stCopyData, 3, DllStructGetPtr ($pMem)) ;lpData = Pointer to the message

	;; Send the WM_COPYDATA message ;;
	$hWindow = DllCall ("user32", "hwnd", "FindWindowExA", "int", 0, "int", 0, "str", "MsnMsgrUIManager", "int", 0)
	While ($hWindow[0])
		DllCall ("user32", "int", "SendMessageA", "hwnd", $hWindow[0], "int", $WM_COPYDATA, "int", 0, "ptr", DllStructGetPtr ($stCopyData))
		$hWindow = DllCall ("user32", "hwnd", "FindWindowExA", "int", 0, "hwnd", $hWindow[0], "str", "MsnMsgrUIManager", "int", 0)
	WEnd

	;; Cleanup ;;
	$pMem = 0
	$stCopyData = 0
EndFunc
