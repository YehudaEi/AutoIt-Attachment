#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#Include <Color.au3>

$sBMP_Path1 = @ScriptDir & "\Test.bmp"
$GuiSizeX = 74
$GuiSizeY = 130
Compare()

Func Compare()
    Local $v_Values[$GuiSizeX + 1][$GuiSizeY + 1], $count = 0, $Var = 0
	_GDIPlus_Startup()
	If not FileExists($sBMP_Path1) Then
		_GDIPlus_Shutdown()
		MsgBox(32,"Error","Why you didnt put image?")
		Exit
	EndIf
	$hBMPBuff1 = _GDIPlus_BitmapCreateFromFile($sBMP_Path1)
	$Reslt = _GDIPlus_BitmapLockBits($hBMPBuff1, 0, 0, $GuiSizeX, $GuiSizeY, $GDIP_ILMREAD, $GDIP_PXF32RGB)
    $stride = DllStructGetData($Reslt, "stride")
    $Scan0 = DllStructGetData($Reslt, "Scan0")
    For $i = 0 To $GuiSizeX - 1
        For $j = 0 To $GuiSizeY - 1
			$count = $count + 1
            $v_Buffer = DllStructCreate("dword", $Scan0 + ($j * $stride) + ($i * 4))
            $v_Values[$i][$j] = DllStructGetData($v_Buffer, 1)
	        Next
    Next
    _GDIPlus_BitmapUnlockBits($hBMPBuff1, $Reslt)
	_GDIPlus_BitmapDispose($hBMPBuff1)
	_GDIPlus_Shutdown()
	ConsoleWrite("Pixels number: " & $count & @CRLF)
	FileDelete($hBMPBuff1)
    Return
EndFunc  
