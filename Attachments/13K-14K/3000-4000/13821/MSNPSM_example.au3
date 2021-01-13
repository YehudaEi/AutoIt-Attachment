While (1)
	ChangeMSNMessage (0, True, @HOUR & ":" & @MIN & ":" & @SEC)
	Sleep (1000)
WEnd

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
		DllStructSetData ($pMem, 1, Asc (StringMid ($szMessage, $i, 1)), $i)
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
