
TCPStartup()
#include <ScreenCapture.au3>
#include <File.au3>

Global $TCPListen = TCPListen(@IPAddress1, 3825)
_ScreenCapture_SetJPGQuality(30)
$ScreenshotName = _TempFile(@TempDir, "test", ".jpg")
While 1
	Do
		$TCPAccept = TCPAccept($TCPListen)
		Sleep(100)
	Until $TCPAccept <> -1
	ConsoleWrite("Accepted" & @CRLF)

		While True
			Sleep(50)
			_ScreenCapture_Capture($ScreenshotName)
			$ScreenshotHandle = FileOpen ($ScreenshotName, 16)
			$data = 			FileRead ($ScreenshotHandle)
								FileClose($ScreenshotHandle)
			$data=num2bin(BinaryLen($data))&$data
			TCPSend($TCPAccept,$data)
			If @error Then
				ConsoleWrite("Lost sock" & @CRLF)
				ExitLoop
			EndIf
		WEnd

	Sleep(50)

WEnd





Func Num2Bin($bin,$diff=0)
	$len=4+$diff
    $binar = DllStructCreate("byte["&$len&"]")
    $intreg = DllStructCreate("int", DllStructGetPtr($binar))
    DllStructSetData($intreg,1,$bin)
    Return DllStructGetData($binar, 1)
EndFunc
Func Bin2Num($bin)
    $integ = DllStructCreate("int")
    $binar = DllStructCreate("byte[4]", DllStructGetPtr($integ))
    DllStructSetData($binar,1,$bin)
    Return DllStructGetData($integ, 1)
EndFunc
