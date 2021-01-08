
;~ Function:	_MBCB()
;~ Desctiption	Changes the button text of a MsgBox()
;~ Version:  N/A
;~ Author:	SmOke_N   Optimised by Rick
;~ Parameter(s):		
;~	$iFlag = Icon and or Flags (Type of buttons)
;~	$Title = Title of MsgBox()
;~	$Text = Text for the Body of the MsgBox()
;~	$Button1 = Text to change the first button
;~	$Button2 = Optional Param:  Text to change the second Button if applicable
;~	$Button3 = Optional Param:  Text to change the third Button if applicable
;~	$Wait = Optional Param:  MsgBox() Time out

;~	$Icon = Optional Param: 1 for taskbar icon, Default is 0 for none
;~	$xpos = Optional Param: X coordinate to move to. Default no move is ""
;~	$ypos = Optional Param: y coordinate to move to. Default no move is ""

;~ Example: _MBCB(36,'My Title','My Text','Button 1','Button 2','',3)
;~ Note: Dont have speech marks in Title

$Msg = _MBCB(36,'This is my msgbox at -1 , 100','This Should Work!','ReBoot','Continue','',0,1,"",100)
If $Msg = 6 Then MsgBox(0,'Clicked','You clicked the ReBoot Button')

Func _MBCB($iFlag,$Title,$Text,$Button1,$Button2 = '',$Button3 = '',$Wait = 0,$Icon = 0,$xpos = "", $ypos = "")
	Local $File = @TempDir & '\MiscCB.txt'
	Local $Ctrl='ControlSetText("' & $Title & '","' & $Text & '",'
	FileDelete($File)
	FileWrite($File,'#NoTrayIcon' & @crlf & _
	 'AutoItSetOption("RunErrorsFatal",0)' & @crlf & _
	 'Opt("WinWaitDelay",0)' & @crlf & _
	 'WinWait("' & $Title & '","' & $Text & '")' & @crlf & _
	 $Ctrl & '"Button1","' & $Button1 & '")' & @crlf & _
	 $Ctrl & '"Button2","' & $Button2 & '")' & @crlf & _
	 $Ctrl & '"Button3","' & $Button3 & '")' & @crlf & _
	 '$pos = WingetPos("' & $Title & '","' & $Text & '")' & @crlf & _
	 '$Xpos=$CmdLine[1]' & @crlf & '$Ypos=$CmdLine[2]' & @crlf & _
	 'if $Xpos = "" then $Xpos = $pos[0]' & @crlf & _
	 'if $Ypos = "" then $Ypos = $pos[1]' & @crlf & _
	 'WinMove("' & $Title & '","' & $Text & '",$Xpos,$Ypos)' & @crlf & _
	 'FileDelete(@TempDir & "\MiscCB.txt")')
	Run(@AutoItExe & ' /AutoIt3ExecuteScript ' & $File & ' "' & $xpos & '" "' & $ypos & '"')
	if $Icon = 1 then
		$MBox = MsgBox($iFlag,$Title,$Text,$Wait)
		Return $MBox
	endif
	$dummy = GuiCreate("Dummy")
	Local $MBox = DllCall("user32.dll","int","MessageBox","hwnd",$dummy,"str",$Text,"str",$Title,"int",$iFlag)
	GuiDelete($dummy)
	Return $MBox[0]
EndFunc
