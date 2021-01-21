#include <G:\Programs\autoit-v3_beta\include\GUIConstants.au3>
#include <G:\Programs\autoit-v3_beta\include\GuiEdit.au3>
#include "RTF_writer.au3"
$hPlug = PluginOpen ("rtfplugin.dll")
$hGUI = GUICreate("RTF plugin test modified by Altalus", 600, 340)
;$hEdit = GUICtrlCreateRTFEdit($hGUI, 0, 0, 600, 300, -1, 0x20000)
$hEdit = GUICtrlCreateRTFEdit($hGUI, 0, 0, 600, 300, BitOR($WS_VSCROLL,$ES_READONLY,$ES_AUTOVSCROLL), BitOR($WS_EX_TOOLWINDOW, $WS_EX_STATICEDGE))
$btn = GUICtrlCreateButton("Test", 5, 310, 80, 24)
GUISetState()

;_PutTitleText("Gathering system information...")

;_PutHeaderText("Common info")
;_PutPairText("System", @OSVersion & " build " & @OSBuild & " " & @OSServicePack)
;_PutPairText("Windows", @WindowsDir)
;_PutPairText("System", @SystemDir)
;_PutPairText("Temp", @TempDir)
;_PutPairText("Program Files", @ProgramFilesDir)
;_PutPairText("Common Files", @CommonFilesDir)

;_PutHeaderText("Network info")
;_PutPairText("Computer name", @ComputerName)
;_PutPairText("IP1", @IPAddress1)
;_PutPairText("IP2", @IPAddress2)

;_PutHeaderText("Memory info")
;$mem = MemGetStats()
;_PutPairText("Physical", Round($mem[1]/1024) & " Mb")
;_PutPairText("Used", Round($mem[1]/102400*$mem[0]) & " Mb" & "(" & $mem[0] & "%)")
;_PutPairText("Free", Round($mem[2]/1024) & " Mb")
;_PutPairText("Total paged", Round($mem[3]/1024) & " Mb")
;_PutPairText("Free paged", Round($mem[4]/1024) & " Mb")
;_PutPairText("Total virtual", Round($mem[5]/1024) & " Mb")
;_PutPairText("Free virtual", Round($mem[6]/1024) & " Mb")

;$hdd = DriveGetDrive ("FIXED")
;for $k=1 to Ubound($hdd)-1
;    _PutHeaderText("Disk """ &$hdd[$k]& """ info")
;    _PutPairText("Label", DriveGetLabel ($hdd[$k]))
;    _PutPairText("File system", DriveGetFileSystem ($hdd[$k]))
;    _PutPairText("Serial number", DriveGetSerial ($hdd[$k]))
;    _PutPairText("Capacity", Round(DriveSpaceTotal ($hdd[$k])) & " Mb")
;    _PutPairText("Free", Round(DriveSpaceFree ($hdd[$k])) & " Mb")
;next

_PutWelcomeText("Click ""Test"" button to test the script...")

While 1
    $msg = GUIGetMsg()
    Select
        Case $msg = -3 
            ;_PutTitleText("Shutting down...")
            ;Sleep(2000)
            ;_PutTitleText("Done! Saving log file...")
            ;Sleep(2000)
            ;$str = GUICtrlRTFGet($hEdit)
            ;FileDelete("test2.rtf")
            ;FileWrite("test2.rtf", $str)
            ;_PutTitleText("Bye!")
            PluginClose($hPlug)
            Exit

        Case $msg = $btn
			_PutNormalText($hEdit, "Testing", 0x000000, 1)
			;$try = GUICtrlRTFGet($hEdit)
			;Msgbox (0,"Debug",$try)
            ;$temp = ""
            ;$temp = _RTFCreateDocument("MS Sans Serif")
			;$temp = _RTFAppendString($try, " Current system time: " & @HOUR & ":"& @MIN &":"& @SEC &@CRLF, 0xFF0000, 10, 1, "MS Sans Serif")
			;Msgbox (0,"Debug",$try)
			;Msgbox (0,"Debug",$temp)
			;GUICtrlRTFSet($hEdit, $temp, 0)
    EndSelect
Wend

Func _PutWelcomeText($sText)
    Local $out = _RTFCreateDocument("MS Sans Serif")
    $out = _RTFAppendString($out, $sText, 0x000000, 12, 1, "MS Sans Serif")
    GUICtrlRTFSet($hEdit, $out, 1)
    Sleep(100)
EndFunc

; Func given by gafrost
Func _PutNormalText(ByRef $hEdit, $sText, $hex_color, $b_Append = 1)
    Local $out = _RTFCreateDocument("MS Sans Serif")
    $out = _RTFAppendString($out, $sText & @CRLF, $hex_color, 8, 1, "MS Sans Serif")
    _GUICtrlEditSetSel ($hEdit, StringLen(GUICtrlRead($hEdit)), StringLen(GUICtrlRead($hEdit)))
    GUICtrlRTFSet ($hEdit, $out, $b_Append)
    Sleep(100)
EndFunc;==>_PutNormalText