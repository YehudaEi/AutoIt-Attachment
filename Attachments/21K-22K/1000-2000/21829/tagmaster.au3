#NoTrayIcon
#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Global $cpy, $s
Dim $main_w = 320, $main_h = 40, $colo[2] = [0x8899CC,0x7788BB]
HotKeySet('^`','Copy')
$main = GUICreate('Tag Master - By MadFlame991',$main_w,$main_h,@DesktopWidth-$main_w,@DesktopHeight-30-$main_h,$WS_POPUP)
GUISetBkColor($colo[0])
GUICtrlCreateLabel('',0,0,320,8,-1,$GUI_WS_EX_PARENTDRAG)
GUICtrlSetBkColor(-1,$colo[1])
$cmb_s = GUICtrlCreateCombo('<b>#_sel#</b>',10,14,200)
GUICtrlSetData($cmb_s,'<br>|<p>#_sel#</p>|<strong>#_sel#</strong>|<a href="#@Enter URL#">#_sel#</a>|<tr>#_sel#</tr>|<td>#_sel#</td>|<img src="#@Image adress#" alt="#@Alt#">')
$but_set = GUICtrlCreateButton('Set',220,14,40,21)
$but_help = GUICtrlCreateButton('Help',270,14,40,21)
GUISetState()
While 1
	$msg = GUIGetMsg()
	Switch $msg
		Case $but_set
			$s = GUICtrlRead($cmb_s)
		Case $but_help
			MsgBox(0,'Tag Master - About','Tag Master v0.2 by MadFlame991'&@CRLF&@CRLF& _
					 'Select the tag desired then hit Ctrl+` to paste it'&@CRLF& _
			         '#_sel# will paste the the current selection'&@CRLF& _
					 '#@Question goes here# will prompt for an input'&@CRLF& _
					 'To exit Tag Master hit Esc while it''s active'&@CRLF&@CRLF& _
					 'For further details visit                                ')
		Case $GUI_EVENT_CLOSE
			GUIDelete($main)
			ExitLoop
	EndSwitch
WEnd
;======== Main program end =========================================================================
Func Copy()
	Sleep(100)
	Send('^c')
	$cpy = ClipGet()
	If @error = 0 Then
		$cpy = PharseStr()
		;$cpy = '<strong>' & $cpy & '</strong>' ;old proof of concept
		ClipPut($cpy)
		Send('^v')
	EndIf
EndFunc
;---------------------------------------------------------------------------------------------------
Func PharseStr()
	Local $ret
		$bucati = StringSplit($s,'#')
		For $i = 1 To $bucati[0]
			If $bucati[$i] = '_sel' Then
				$bucati[$i] = $cpy
			ElseIf StringInStr($bucati[$i],'@') = 1 Then
				$bucati[$i] = InputBox('Input',StringTrimLeft($bucati[$i],1),'','',-1,70)
			EndIf
		Next
	$ret = _ArrayToString($bucati,'',1,$bucati[0])
	Return $ret
EndFunc