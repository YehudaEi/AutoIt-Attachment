#include "RTF_writer.au3"
$hPlug = PluginOpen ("rtfplugin.dll")
$hGUI = GUICreate("RTF plugin test", 600, 340)
$hEdit = GUICtrlCreateRTFEdit($hGUI, 0, 0, 600, 300, -1, 0x20000)
$btn = GUICtrlCreateButton("Time", 5, 310, 80, 24)
GUISetState()

_PutTitleText("Gathering system information...")

_PutHeaderText("Common info")
_PutPairText("System", @OSVersion & " build " & @OSBuild & " " & @OSServicePack)
_PutPairText("Windows", @WindowsDir)
_PutPairText("System", @SystemDir)
_PutPairText("Temp", @TempDir)
_PutPairText("Program Files", @ProgramFilesDir)
_PutPairText("Common Files", @CommonFilesDir)

_PutHeaderText("Network info")
_PutPairText("Computer name", @ComputerName)
_PutPairText("IP1", @IPAddress1)
_PutPairText("IP2", @IPAddress2)

_PutHeaderText("Memory info")
$mem = MemGetStats()
_PutPairText("Physical", Round($mem[1]/1024) & " Mb")
_PutPairText("Used", Round($mem[1]/102400*$mem[0]) & " Mb" & "(" & $mem[0] & "%)")
_PutPairText("Free", Round($mem[2]/1024) & " Mb")
_PutPairText("Total paged", Round($mem[3]/1024) & " Mb")
_PutPairText("Free paged", Round($mem[4]/1024) & " Mb")
_PutPairText("Total virtual", Round($mem[5]/1024) & " Mb")
_PutPairText("Free virtual", Round($mem[6]/1024) & " Mb")

$hdd = DriveGetDrive ("FIXED")
for $k=1 to Ubound($hdd)-1
    _PutHeaderText("Disk """ &$hdd[$k]& """ info")
    _PutPairText("Label", DriveGetLabel ($hdd[$k]))
    _PutPairText("File system", DriveGetFileSystem ($hdd[$k]))
    _PutPairText("Serial number", DriveGetSerial ($hdd[$k]))
    _PutPairText("Capacity", Round(DriveSpaceTotal ($hdd[$k])) & " Mb")
    _PutPairText("Free", Round(DriveSpaceFree ($hdd[$k])) & " Mb")
next

_PutHeaderText("Click ""Time"" button to get system time...")

While 1
    $msg = GUIGetMsg()
    Select
        Case $msg = -3 
            _PutTitleText("Shutting down...")
            Sleep(2000)
            _PutTitleText("Done! Saving log file...")
            Sleep(2000)
            $str = _GetCtrlText($hEdit,1)
				MsgBox(0,"here's the text in rtf format", $str)
            FileDelete("test2.rtf")
            FileWrite("test2.rtf", $str)
				$str = _GetCtrlText($hEdit)
				MsgBox(0,"here's the text", $str)
            _PutTitleText("Bye!")
            PluginClose($hPlug)
            Exit

        Case $msg = $btn
            $temp = ""
            $temp = _RTFCreateDocument("MS Sans Serif")
            $temp = _RTFAppendString($temp, " Current system time: " & @HOUR & ":"& @MIN &":"& @SEC &@CRLF, 0xFF0000, 10, 1, "MS Sans Serif")
            GUICtrlRTFSet($hEdit, $temp, 1)
    EndSelect
Wend

Func _PutTitleText($sText)
    Local $out = _RTFCreateDocument("MS Sans Serif")
    $out = _RTFAppendString($out, " " & $sText & @CRLF, 0x00FF00, 14, 1, "Times New Roman")
    GUICtrlRTFSet($hEdit, $out, 1)
    Sleep(100)
EndFunc

Func _PutHeaderText($sText)
    Local $out = _RTFCreateDocument("MS Sans Serif")
    $out = _RTFAppendString($out, @CRLF & " " & $sText & ":"  & @CRLF, 0x00FF00, 12, 1, "MS Sans Serif")
    GUICtrlRTFSet($hEdit, $out, 1)
    Sleep(100)
EndFunc

Func _PutPairText($sText1, $sText2)
    Local $out = _RTFCreateDocument("MS Sans Serif")
    $out = _RTFAppendString($out, " " & $sText1 & ": ", 0x0000FF, 10, 1, "MS Sans Serif")
    $out = _RTFAppendString($out, " " & $sText2 & @CRLF, 0xFF0000, 10, 1, "MS Sans Serif")
    GUICtrlRTFSet($hEdit, $out, 1)
    Sleep(100)
EndFunc
 
Func _GetCtrlText($hEdit, $rtf = 0)
	If $rtf Then
		Return GUICtrlRTFGet($hEdit)
	Else
	;~ typedef struct _gettextex {
	;~     DWORD cb;
	;~     DWORD flags;
	;~     UINT codepage;
	;~     LPCSTR lpDefaultChar;
	;~     LPBOOL lpUsedDefChar;
	;~ } GETTEXTEX;
		Local Const $GT_DEFAULT = 0
		Local Const $GT_USECRLF = 1
		Local Const $GT_SELECTION = 2
		Local Const $WM_USER = 0x400
		Local Const $EM_GETTEXTEX = ($WM_USER + 94)
		$struct = DllStructCreate("dword;dword;int;char;int")
		DllStructSetData($struct,1,1024)
		DllStructSetData($struct,2,$GT_USECRLF)
		$lResult = DllCall("user32.dll","int","SendMessage","hwnd",$hEdit,"int",$EM_GETTEXTEX,"ptr",DllStructGetPtr($struct),"str","")
		If Not @error Then
			$lResult = $lResult[4]
			$struct = 0
			Return $lResult
		EndIf
	EndIf
EndFunc	