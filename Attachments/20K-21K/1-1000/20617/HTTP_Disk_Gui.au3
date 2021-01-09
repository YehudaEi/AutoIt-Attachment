#include <Color.au3>
#include <GUIConstantsEX.au3>
#include <WindowsConstants.au3>
#include <String.au3>

Global $color1 = 0x99A8AC
Global $color2 = 0xFFFFFF
Dim $Site, $File, $Drive, $Dev

$Gui = GUICreate(" HTTP Disk GUI " & _StringRepeat(" ",115) & " by ptrex", 730, 180, 161, 166)
GUISetIcon (@windowsdir & "\system32\mmcndmgr.dll",-29,$Gui)
GUISetState(@SW_LOCK,$Gui)
$Size = WinGetClientSize($Gui)

$Button_1 = GUICtrlCreateButton("Mount", 80, 105, 60)
$Button_2 = GUICtrlCreateButton("UnMount", 150, 105, 60)
$label1 = GUICtrlCreateLabel("HTTP://", 30, 55, 45, 15)
GUICtrlSetBkColor(-1,0xBAC4C7)
$Input1 = GUICtrlCreateInput("www.company.com", 80, 50, 250, 20)
$label2 = GUICtrlCreateLabel("ISO", 335, 55, 20, 15)
GUICtrlSetBkColor(-1,0xBAC4C7)
$Input2 = GUICtrlCreateInput("FileName", 360, 50, 150, 20)
$label3 = GUICtrlCreateLabel("Drive", 520, 55, 30, 15)
GUICtrlSetBkColor(-1,0xBAC4C7)
$Input3 = GUICtrlCreateInput("Z:", 555, 50, 50, 20)
$label4 = GUICtrlCreateLabel("Device", 610, 55, 40, 15)
GUICtrlSetBkColor(-1,0xBAC4C7)
$Input4 = GUICtrlCreateInput("0", 655, 50, 30, 20)

_GUICtrlCreateGradient($color1, $color2, 0, 0, $size[0]*1.5, $size[1])
GUISetState(@SW_UNLOCK,$Gui)
GUISetState(@SW_SHOW)

$n1 = GUICtrlCreateIcon (@windowsdir & "\system32\mmcndmgr.dll", -29, 250,100,32,32)
;_GuiCtrlMakeTrans($n1,150)
Sleep (900)
$n2=GUICtrlCreateIcon (@windowsdir & "\system32\mmcndmgr.dll", -112, 330,100,32,32)
;_GuiCtrlMakeTrans($n2,150)
Sleep (700)
$n3=GUICtrlCreateIcon (@windowsdir & "\system32\mmcndmgr.dll", -24, 430,100,32,32)
;_GuiCtrlMakeTrans($n3,150)
Sleep (500)
$n4=GUICtrlCreateIcon (@windowsdir & "\system32\mmcndmgr.dll", -112, 520,100,32,32)
;_GuiCtrlMakeTrans($n4,150)
Sleep (300)
$n5=GUICtrlCreateIcon (@windowsdir & "\system32\mycomput.dll", -5, 610,100,32,32)
;_GuiCtrlMakeTrans($n5,150)


If Not FileExists (@windowsdir & "\system32\drivers\httpdisk.sys") then
	MsgBox(16,"Error","Drive 'httpdisk.sys' is not properly installed.")
	Exit
Endif


While 1
    $msg = GUIGetMsg()
    Select
		Case $msg = $GUI_EVENT_CLOSE
            ExitLoop
        Case $msg = $Button_1
			Mount(GUICtrlRead($Input1),GUICtrlRead($Input2),GUICtrlRead($Input3),GUICtrlRead($Input4))
			$DriveTemp = GUICtrlRead($Input3)
		Case $msg = $Button_2
			UnMount($DriveTemp)
    EndSelect
WEnd


Func Mount($Site, $File, $Drive, $Dev)
	Local $Cmd
	If BitOR(FileExists(@WindowsDir & "\" & "HTTPDisk.exe"),FileExists(@ScriptDir & "\" & "HTTPDisk.exe")) then 
	$Cmd = 'HTTPDisk /mount ' & $Dev & ' http://' & $Site & '/'& $File & '.iso' & ' ' & '/cd ' & $drive
		Run(@ComSpec & " /c " & $Cmd, "", @SW_HIDE, 1)
	ConsoleWrite($Cmd & @LF)
		Else
	MsgBox(16,"Errorr", "HTTPDisk.exe is not found")
	EndIf
EndFunc


Func UnMount($Drive)
   $Cmd = 'HTTPDisk /umount ' & $Drive
		Run(@ComSpec & " /c " & $Cmd, "", @SW_HIDE, 1)
EndFunc
	
	
Func _GUICtrlCreateGradient($nStartColor, $nEndColor, $nX, $nY, $nWidth, $nHeight)
    Local $color1R = _ColorGetRed($nStartColor)
    Local $color1G = _ColorGetGreen($nStartColor)
    Local $color1B = _ColorGetBlue($nStartColor)

    Local $nStepR = (_ColorGetRed($nEndColor) - $color1R) / $nHeight
    Local $nStepG = (_ColorGetGreen($nEndColor) - $color1G) / $nHeight
    Local $nStepB = (_ColorGetBlue($nEndColor) - $color1B) / $nHeight

    GuiCtrlCreateGraphic($nX, $nY, $nWidth, $nHeight)
    For $i = 0 To $nHeight - $nY
        $sColor = "0x" & StringFormat("%02X%02X%02X", $color1R+$nStepR*$i, $color1G+$nStepG*$i, $color1B+$nStepB*$i)
        GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $sColor, 0xffffff)
        GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 0, $i)
        GUICtrlSetGraphic(-1, $GUI_GR_LINE, $nWidth, $i)
    Next
EndFunc
