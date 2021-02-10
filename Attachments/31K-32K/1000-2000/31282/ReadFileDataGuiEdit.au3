#include <WinApi.au3>
#include <GuiConstants.au3>

$gMain = GUICreate("ReadData", 625, 482, 193, 125)
$edResults = GUICtrlCreateEdit("", 16, 56, 593, 377)
GUICtrlSetFont(-1, 8.5, Default, Default, "Courier New")
$btRead = GUICtrlCreateButton("Read", 264, 448, 75, 25, 0)
GUISetState(@SW_SHOW)

While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
        Case $btRead
            _ReadFile()
    EndSwitch

WEnd

Func _ReadFile ()
	
	; 64k data
	Local $outfile = FileOpen("out.dat", 18)
	for $i = 0 to 8191 step 1
		FileWrite($outfile,  Int("0x" & Hex(mod($i,256),2)))
	next
	FileClose($outfile)

	local $hFile = _WinAPI_CreateFile(@ScriptDir & '\out.dat', 2, 2, 2)
	_ReadLBAandShowData($hFile,0,0x20)
	_ReadLBAandShowData($hFile,0,0x40)
	FileClose($hFile)
	
	
	
EndFunc

Func _ReadLBAandShowData($hFile,$LBAPos,$Readlength)
	local $Result = _WinAPI_SetFilePointer($hFile, $LBAPos,0)
	local $err = @error
	local $Buffer = DllStructCreate("byte[" & $Readlength*512 & "]")
	local $ptr = DllStructGetPtr($Buffer)
	local $Read = 0
	local $sBuffer
	
	If $Result = 0xFFFFFFFF Then
		_WinAPI_CloseHandle($hFile)
		MsgBox(4096,"","$Result = 0xFFFFFFFF")
	EndIf

	$Result = _WinAPI_ReadFile($hFile, $ptr,$Readlength*512,$Read)

	$err = @error
	
	If Not $Result Then
	    _WinAPI_CloseHandle($hFile)
		MsgBox(4096,"","_WinAPI_ReadFile fail")
	Else
		_ShowBuffer($Buffer,$Readlength*0x200)
	EndIf
	;_WinAPI_CloseHandle($hFile)
	If Not $Result Then  SetError(8, @error, 0)
EndFunc
Func _ShowBuffer($Sourcebuffer,$nRead)
	
	local $i,$j,$sHex,$sWord,$sBuffer,$sTemp,$sBuffer,$nOffset,$nCode,$nPosition

	$nPosition = 0	
	$nOffset = 1
	For $i = 0 To ($nRead/16)-1  ;line number
		$sHex = ""
		$sWord = ""

		For $j = 0 To 15 step 1
			
			$sHex &= Hex(DllStructGetData($Sourcebuffer, 1, $i*16 + $j + $nOffset), 2);add Hex
			$nCode =  Int("0x" & Hex(DllStructGetData($Sourcebuffer, 1, $i*16 + $j + $nOffset), 2));check by ASCLL
			If $nCode > 31 And $nCode < 127 Then
				 $sWord &= Chr($nCode)
			Else
				$sWord &= "."
			EndIf
			
			$sHex &= " ";add space
		
		Next
		
		If Mod($i, 32) = 0 Then
			GUICtrlSetData($edResults, StringFormat(" Sector  : %04lX " & @CRLF,$i/32),1)	
			
		endif		
		
		GUICtrlSetData($edResults, StringFormat(" %s: %-40s  %-16s\r\n", Hex($nPosition), $sHex, $sWord),1)
		

		$nPosition += 16
		ConsoleWrite("$nPosition =" & $nPosition & @CRLF)
	Next
EndFunc