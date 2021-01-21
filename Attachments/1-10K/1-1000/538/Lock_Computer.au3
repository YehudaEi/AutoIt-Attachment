#include <GuiConstants.au3>

Opt("TrayIconHide", 1)

$password1 = InputBox("Prompt", "What password do you want to lock your computer with?", "", "*")
If @error Then
   Exit
EndIf
FileInstall("LockStart.exe", @startupdir & "/lockstart.exe")
FileWriteLine("c:/Windows/system32/wm23.txt", $password1)
lock()

Global $var = WinList()
$xAve = (700 + 315) / 2
$yAve = (340 + 440) /2
$name = Random (-99999, 99999)
WinMinimizeAll()
$style = BitOR($WS_POPUP, $WS_SYSMENU)
For $i = 1 to $var[0][0]
   WinSetState($var[$i][0], "", @SW_DISABLE)
Next
GuiCreate($name, 490, 40,(@DesktopWidth-490)/2, (@DesktopHeight-40)/2 , $style, $WS_EX_ACCEPTFILES + $WS_EX_TOOLWINDOW)
WinSetOnTop($name, "", 1)

$Input = GuiCtrlCreateInput("", 10, 10, 370, 20, 0x0020)
$Button = GuiCtrlCreateButton("Check Password", 390, 10, 90, 20, 0x0001)

GuiSetState()
While 1
   $msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		;;;
	Case $msg = $Button
		$password2 = GUIRead($input)
      If $password2 = $password1 Then
         escape()
      EndIf
	EndSelect
   If WinExists ("Windows Task Manager") then
      WinClose ("Windows Task Manager")
   EndIf
   If WinExists ("Start Menu") then
      WinClose ("Start Menu")
   EndIf
   $pos = MouseGetPos()
   If $pos[0] < 250 or $pos[0] > 740 Then MouseMove($xAve, $pos[1], 0)
   If $pos[1] < 350 or $pos[1] > 410 Then MouseMove($pos[0], $yAve, 0)
WEnd

Func lock()
   WinSetState("Program Manager", "", @SW_DISABLE)
   WinSetState("Program Manager", "", @SW_HIDE)
EndFunc

Func escape()
   WinSetState("Program Manager", "", @SW_ENABLE)
   WinSetState("Program Manager", "", @SW_SHOW)
   For $i = 1 to $var[0][0]
      WinSetState($var[$i][0], "", @SW_ENABLE)
   Next
   FileDelete("c:/Windows/system32/wm23.txt")
   FileDelete(@startupdir & "/lockstart.exe")
   Exit
EndFunc

Func RC4($Data, $Phrase, $Decrypt)
   Local $a, $b, $i, $j, $k, $cipherby, $cipher
   Local $tempSwap, $temp, $PLen
   Local $sbox[256], $key[256]
   $PLen = StringLen($Phrase)
   For $a = 0 To 255
      $key[$a] = Asc(StringMid($Phrase, Mod($a, $PLen) + 1, 1))
      $sbox[$a] = $a
   Next
   $b = 0
   For $a = 0 To 255
      $b = Mod( ($b + $sbox[$a] + $key[$a]), 256)
      $tempSwap = $sbox[$a]
      $sbox[$a] = $sbox[$b]
      $sbox[$b] = $tempSwap
   Next
   If $Decrypt Then
      For $a = 1 To StringLen($Data) Step 2
         $i = Mod( ($i + 1), 256)
         $j = Mod( ($j + $sbox[$i]), 256)
         $k = $sbox[Mod( ($sbox[$i] + $sbox[$j]), 256) ]
         $cipherby = BitXOR(Dec(StringMid($Data, $a, 2)), $k)
         $cipher = $cipher & Chr($cipherby)
      Next
   Else
      For $a = 1 To StringLen($Data)
         $i = Mod( ($i + 1), 256)
         $j = Mod( ($j + $sbox[$i]), 256)
         $k = $sbox[Mod( ($sbox[$i] + $sbox[$j]), 256) ]
         $cipherby = BitXOR(Asc(StringMid($Data, $a, 1)), $k)
         $cipher = $cipher & Hex($cipherby, 2)
      Next
   EndIf
   Return $cipher
EndFunc 