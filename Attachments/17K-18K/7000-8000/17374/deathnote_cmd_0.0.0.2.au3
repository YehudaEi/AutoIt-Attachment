 HotKeySet("{ENTER}","exe")
#include <GUIConstants.au3>
#include <GUIedit.au3>
FileInstall("E:\desu.bmp", @ScriptDir & "\desu.bmp")
GUICreate("DeathNote",750,450, @DesktopWidth/2-400,@DesktopHeight/2-300, BitOR($WS_CAPTION, $WS_SYSMENU))
GUISetState(@SW_SHOW)
$message = 'This is a command line with a Death Note theme. for more information,  use the about or help command. ' & 'This is only a preview, do not be shocked if it is a little crappy as of now ^^' 
$commandLine = GUICtrlCreateEdit($message, 0, 0, 600, 430, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL, $ES_READONLY, $ES_MULTILINE, $WS_MAXIMIZEBOX, $WS_MINIMIZEBOX, $ES_NOHIDESEL))
GUICtrlSetFont(-1, 10, 300, "", "courier new")
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlSetColor(-1, 0xffffff)
$command = GUICtrlCreateInput("", 2, 430, 600, 20, -1, 0)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlSetColor(-1, 0xffffff)
GUICtrlSetFont(-1, 13, 500, "", "courier new")
GUICtrlCreatePic("E:\desu.bmp",600, 0, 150, 450)
While 1
$eval = GUICtrlRead($command)
$cmd_cahce = GUICtrlRead($commandLine)  
$pre = $cmd_cahce & @CRLF
$seji = "'" & $eval & "'"
$erro = $seji & ': Rejected by Deathnote.' 
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
	EndSwitch
WEnd



func exe()
Switch $eval
		Case 'about' 
			GUICtrlSetData($commandLine,$pre & @CRLF & 'DeathNote Command Line was created be David Nuon. This was originally a way for me to entertain myself and to see if this worked. Apparently it did ;)')
			resetcmd()
		Case 'clear' 
			GUICtrlSetData($commandLine,'')
			resetcmd()
		Case 'kill' 
			GUICtrlSetData($commandLine, $pre & @CRLF & 'This command would be used to delete files but that has yet to be added. ')
			resetcmd()
		case 'burn' 
		FileDelete(@ScriptDir & "\desu.bmp")
		exit
		Case 'help' 
			GUICtrlSetData($commandLine, $pre & @CRLF & 'The total commands included in this preview: ' _ 
			& @CRLF & 'about - lists some about text about this project' _ 
			& @CRLF & 'help - displays help info' _ 
			& @CRLF & 'clear - clears the command log of all text' _ 
			& @CRLF & 'kill - an uncompleted command' _ 
			& @CRLF & 'write - an uncompleted command' _ 
			& @CRLF & 'rule - Displays a random rule of this Death Note' _ 
			& @CRLF & 'burn - Exit DeathNote cmd' _ 
			& @CRLF &'wiki - look up a term of Wikipedia')
			resetcmd()
		Case 'wiki' 
			GUICtrlSetData($commandLine, $pre & @CRLF & 'Enter query term:')
			resetcmd()
			HotKeySet("{ENTER}","wiki")
		Case 'write'
			GUICtrlSetData($commandLine, $pre & @CRLF & 'Follow the following Directions:')
			resetcmd()
		Case 'rule'
			$rule = Random(1,1,1)
			GUICtrlSetData($commandLine, $pre & @CRLF & '[Rule # ' & $rule & '] The user of this Death Note shall neither be able to claim any implied warranty or will hold [me] liable. Instead, you will have to live with it.')
			resetcmd()
		Case Else
			GUICtrlSetData($commandLine, $pre & @CRLF & $erro)
			resetcmd()
EndSwitch
EndFunc		

func resetcmd()
	$d = 0
	For $c = _GUICtrlEditGetLineCount ( $commandLine )/26 to 0 step -1
	GUICtrlSetData($command ,"")
	_GUICtrlEditScroll ($commandLine, $SB_PAGEDOWN)
	Next
EndFunc

Func write($name, $time, $cause)
	GUICtrlSetData($commandLine,$pre & @CRLF & $name & ' will die of ' & $cause & ' at '& $time)
EndFunc

Func wiki();; a little annoying
	$s = 0
	$url = "http://www.wikipedia.org/w/wiki.phtml?search=" & $eval
	if $eval <> "" Then
	while $s <> 10
	GUICtrlSetData($commandLine, $pre & $url & ' -')
	Sleep(100)
	GUICtrlSetData($commandLine, $pre & $url & ' |')
	Sleep(100)
	GUICtrlSetData($commandLine, $pre & $url & ' /')
	Sleep(100)
	GUICtrlSetData($commandLine, $pre & $url & ' -')
	Sleep(100)
	GUICtrlSetData($commandLine, $pre & $url & ' |')
	Sleep(100)
	Sleep(100)
	$s += 1
WEnd
	GUICtrlSetData($commandLine, $pre & $url & '.')
	Sleep(500)
	GUICtrlSetData($commandLine, $pre & $url & '..')
	Sleep(500)
	GUICtrlSetData($commandLine, $pre & $url & '...')
	Sleep(500)
	GUICtrlSetData($commandLine, $pre & $url & ' DONE')
	ShellExecute($url)
	HotKeySet("{ENTER}","exe")
	resetcmd()
Else
	GUICtrlSetData($commandLine, $pre & @CRLF & 'Rejected: Enter a query term!')
	HotKeySet("{ENTER}","exe")
	resetcmd()
	EndIf
EndFunc