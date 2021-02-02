#include<GDIPlus.au3>
#include<GuiConstantsex.au3>
#include <File.au3>
Opt("GUIONEVENTMODE" ,1)
_GDIPlus_Startup ()
TCPStartup()
$hGUI=GUICreate("test",1024,768)
GUISetOnEvent($GUI_EVENT_CLOSE,"quit")
GUISetState()
$hGraphic = _GDIPlus_GraphicsCreateFromHWND ($hGUI)
$ScreenshotName = _TempFile(@TempDir, "test", ".jpg")
While 1
	Sleep(50)
	Global $TCPConnect = TCPConnect(@IPAddress1, 3825)
	If $TCPConnect = -1 Then ContinueLoop
	ConsoleWrite("Connected!" & @CRLF)
	$TCPRecv = Binary ("")
	$timer = TimerInit()
	While 1
		Sleep(50)
		Local $k = TCPRecv($TCPConnect,20000000,0)
		If @error Then
			ConsoleWrite("Lost sock!" & @CRLF)
			ExitLoop
		EndIf
		If $k Then
			$TCPRecv = $TCPRecv & $k
			If BinaryLen($TCPRecv)<4 Then ContinueLoop
			;ConsoleWrite(BinaryLen($TCPRecv) & " / " & Bin2Num(BinaryMid($TCPRecv,1,4))+4&@CRLF)
			If BinaryLen($TCPRecv)>=Bin2Num(BinaryMid($TCPRecv,1,4))+4 And Bin2Num(BinaryMid($TCPRecv,1,4))+4>0 Then
			;	ConsoleWrite("Done!" & @CRLF)
				$ScreenshotHandle = FileOpen($ScreenshotName, 18)
				FileWrite($ScreenshotHandle, BinaryMid($TCPRecv,5))
				FileClose($ScreenshotHandle)
				$hBitmap = _GDIPlus_BitmapCreateFromFile($ScreenshotName)
				_GDIPlus_GraphicsDrawImageRect ($hGraphic, $hBitmap,0,0,1024,768)
				_GDIPlus_BitmapDispose ($hBitmap)
				FileDelete($ScreenshotName)
				WinSetTitle($hGUI,"" , BinaryLen($TCPRecv)-4&" at "& Round(1/(TimerDiff($timer)/1000),2)&" fps")
				$TCPRecv=BinaryMid($TCPRecv,5+Bin2Num(BinaryMid($TCPRecv,1,4)))
				$timer = TimerInit()
			EndIf
		EndIf
	WEnd
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

Func quit()
	Exit
EndFunc
