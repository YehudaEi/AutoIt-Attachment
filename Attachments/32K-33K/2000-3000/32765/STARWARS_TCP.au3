#AutoIt3Wrapper_Change2CUI=y

; towel.blinkenlights.nl's STAR WARS (Episode IV) - A NEW HOPE
;.......script written by trancexx (trancexx at yahoo dot com)


#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <SendMessage.au3>

Opt("MustDeclareVars", 1)

HotKeySet("{ESC}", "_Quit")
Global Const $fCompiled = @Compiled

TCPStartup()

Global $sIP = TCPNameToIP("towel.blinkenlights.nl")
Global $iPORT = 23

Global $iSocket = TCPConnect($sIP, $iPORT)

Global $sChunk, $sData, $fDel


While 1
	$sChunk = TCPRecv($iSocket, 1)
	If $sChunk = Chr(27) Then
		TCPRecv($iSocket, 2) ; skip next two bytes
		$fDel = True
		$sChunk = ""
		If $fCompiled Then
			_CommandConsole()
		Else
			Sleep(100)
			_CommandSciTE("menucommand:420")
		EndIf
	EndIf
	$sData &= $sChunk

	If $fDel Then
		ConsoleWrite($sData)
		If $fCompiled Then _CommandConsole(True)
		$sData = ""
		$fDel = False
	EndIf
WEnd

; Bye ...and be good now.


Func _Quit()
	TCPShutdown()
	If Not $fCompiled Then
		_CommandSciTE("menucommand:420")
		Sleep(100)
	EndIf
	Exit
EndFunc   ;==>_Quit

Func _CommandSciTE($sCmd)
	Local Static $hSciTEWindow = WinGetHandle("DirectorExtension")

	Local $tCommand = DllStructCreate('char[' & StringLen($sCmd) + 1 & ']')
	DllStructSetData($tCommand, 1, $sCmd)

	Local Static $tCOPYDATASTRUCT = DllStructCreate("ulong_ptr DataType; dword DataSize; ptr Data")
	DllStructSetData($tCOPYDATASTRUCT, "DataType", 1)
	DllStructSetData($tCOPYDATASTRUCT, "DataSize", DllStructGetSize($tCommand))
	DllStructSetData($tCOPYDATASTRUCT, "Data", DllStructGetPtr($tCommand))

	_SendMessage($hSciTEWindow, $WM_COPYDATA, 0, DllStructGetPtr($tCOPYDATASTRUCT))
EndFunc   ;==>_CommandSciTE

Func _CommandConsole($fJustSetCursor = False)
	Local Static $hConsole = _WinAPI_GetStdHandle(1) ; $STD_OUTPUT_HANDLE

	If $fJustSetCursor Then
		DllCall("kernel32.dll", "int", "SetConsoleCursorPosition", "handle", $hConsole, "dword", 0)
		Return True
	EndIf

	Local $tCONSOLE_SCREEN_BUFFER_INFO = DllStructCreate("short SizeX; short SizeY;" & _
			"short CursorPositionX;short CursorPositionY;" & _
			"word Attributes;" & _
			"short Left; short Top; short Right; short Bottom;" & _
			"short MaximumWindowSizeX; short MaximumWindowSizeY")

	DllCall("kernel32.dll", "int", "GetConsoleScreenBufferInfo", "handle", $hConsole, "ptr", DllStructGetPtr($tCONSOLE_SCREEN_BUFFER_INFO))
	DllCall("kernel32.dll", "int", "FillConsoleOutputCharacter", _
			"handle", $hConsole, _
			"char", "", _
			"dword", DllStructGetData($tCONSOLE_SCREEN_BUFFER_INFO, "dwSizeX") * DllStructGetData($tCONSOLE_SCREEN_BUFFER_INFO, "dwSizeY"), _
			"dword", 0, _
			"dword*", 0)
	DllCall("kernel32.dll", "int", "SetConsoleCursorPosition", "handle", $hConsole, "dword", 0)

	Return True
EndFunc   ;==>_CommandConsole