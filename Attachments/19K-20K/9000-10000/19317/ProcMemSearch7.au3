#Include <WinAPI.au3>
#Include <Array.au3>
HotKeySet("{ESC}", "_Exit")
If Not ProcessExists("calc.exe") Then Exit ; exit if calculator is not running
$procHwnd = _WinAPI_OpenProcess($PROCESS_ALL_ACCESS, False, ProcessExists("calc.exe"))
If Not $procHwnd Then _Exit("Error while getting process handle!") ; if we didn't get a valid 'access' handle then exit
$SearchValue = 453	
$dType = 1
_ArrayDisplay(_SearchProcessMemory($procHwnd, $SearchValue, $dType))


Func _SearchProcessMemory($procHwnd, $SearchValue, $dType)
	;GetSystemInfo
	$systemInfo = DllStructCreate ("short;short;dword;int;int;dword;dword;dword;dword;short;short")
	DllCall ("Kernel32.dll", "int", "GetSystemInfo", "ptr", DllStructGetPtr($systemInfo))
	$lpMinimumApplicationAddress = DllStructGetData ($systemInfo, 4)
	$lpMaximumApplicationAddress = DllStructGetData ($systemInfo, 5)
	$systemInfo=""

	$i = $lpMinimumApplicationAddress
	While $i < $lpMaximumApplicationAddress
		
		Local $mbi[7] ; MEMORY_BASIC_INFORMATION Structure
		Local $v_Buffer = DllStructCreate('dword;dword;dword;dword;dword;dword;dword')		
		If @Error Then SetError(@Error + 1)
		
		DllCall('Kernel32.dll', 'int', 'VirtualQueryEx', 'int', $procHwnd, 'int', $i, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer))
		
		If Not @Error Then			
			For $j = 0 to 6				
				$mbi[$j] = StringStripWS(DllStructGetData($v_Buffer, ($j + 1)),3)				
			Next			
		Else
			SetError(6)
		EndIf
		;_ArrayDisplay($mbi)
		
		Local $Output
		
		Select
			Case $dType = 1
				$SearchV = Hex(StringToBinary($SearchValue, 2));;unicode string hex to search for
				;In this particular case we know what we looking for, so we will narrow down the field to speed up the search
				If $mbi[4] = 4096 And $mbi[5] = 4 And $mbi[6] = 16777216 Then ;a.k.a MEM_COMMIT + PAGE_READWRITE + MEM_IMAGE
					Local $pBuffer = DllStructCreate("byte["&$mbi[3]&"]")
					DllCall("Kernel32.dll", 'int', 'ReadProcessMemory', 'int', $procHwnd, 'int', $mbi[0], 'ptr', DllStructGetPtr($pBuffer), 'int', DllStructGetSize($pBuffer), 'int', '')
					$x = StringInStr(DllStructGetData($pBuffer, 1), $SearchV)
					If @Error Then SetError(@Error + 1)
					If Mod($x, 2) Then ;if aligned at byte (and obviously <> 0)
						$Address = ($x - 3) / 2 + $i ;subtract 2 for "0x", 1 to make 0-based; and divide by 2 to get binary offset, then add current page address
						$Output &= Hex($Address)& @CR &$SearchValue
					EndIf				
				EndIf
				$pBuffer = ""
				
			Case $dType = 2
				
			Case $dType = 3
				
		EndSelect 
		
		$i += $mbi[3]
		
	WEnd

	$retArray = StringSplit($Output, @CRLF)
	Return $retArray
EndFunc


Func _Exit($s_Msg="")
   
    MsgBox(0, "Error", $s_Msg)
    Exit
   
EndFunc

