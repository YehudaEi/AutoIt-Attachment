#CS
_ToolTipLog by squid808 11/21/2010

Options for _ToolTipLogStart:
Text: The text to show in the first tooltip.
Lines to show: Default 2, this is how many lines you want to have the tooltip eventually show. It will only show as many as it can until it reaches the max, eg. if you define it as 5 and you have only defined 3 tooltips, you'll only see 3.
x: default at mouse, this is the x coordinates
y: default at mouse, this is the y coordinates. If you define x and not y, y will default to 0.
Silence Hotkey: Default "", This defines the hotkey to toggle the silenced mode on and off. The functions will still continue to run and update even if 'silenced' and not shown.
SilenceMode: Default 0. If 1, this will set the tooltips to be hidden by default. If 0, they will be shown.

Options for _ToolTipLog:
Text: The text to show in subsequent tooltips. The lower in the tooltip you see it, the newer it is.
Modify Lines to Show: Default 0, this will change how many lines to show by the number given, including negative numbers. -1 will reduce the lines shown by 1, 1 will increase by 1. As lines that have passed are forgotton, adding lines will rebuild in increments up to the new limit you define.
x: Default is the previous value used, setting this will set a new x default.
y: Default is the previous value used, setting this will set a new y default. If you define a new x but not y, y will default to 0.

####################################
EXAMPLE 1
####################################

#include <_ToolTipLog.au3>

_ToolTipLogStart("Starting Notepad",2,@DesktopWidth/2,0,"+!s",0)
ShellExecute("notepad.exe")

_ToolTipLog("Waiting for Notepad to Open")
winwaitactive("Untitled - Notepad")

_ToolTipLog("Sending Hello")
send("hello")
sleep(1000)

for $i = 1 to 5 step 1
	_ToolTipLog("Sleeping " & $i)
	sleep(1000)
Next

_ToolTipLog("Waiting for Notepad to Close")
ProcessClose("notepad.exe")


####################################
EXAMPLE 2
####################################


_ToolTipLogStart("1",3,"","","+!s") ;sets the first tip to 1, will retain 3 tooltips.
sleep(500)
_ToolTipLog("2")
sleep(500)
_ToolTipLog("3")
sleep(500)
_ToolTipLog("4",2) ;increases the number of tips shown by 2 (to 5) when it hits here.
sleep(500)
_ToolTipLog("5")
sleep(500)
_ToolTipLog("6",0,@DesktopWidth/2,50) ;moves the tooltips to halfway across your screen, 50 pixels down
sleep(500)
_ToolTipLog("7")
sleep(500)
_ToolTipLog("8",-1) ;reduces the number shown by 1 (to 4)
sleep(500)
_ToolTipLog("9")
sleep(500)
_ToolTipLog("10")
sleep(500)

#ce

#include <Array.au3>

Func _ToolTipLogStart($update, $Lines = 2, $x="", $y="",  $Hotkey = "", $SilenceMode = 0)

	Global $_ToolTipLogSilenceMode = $SilenceMode
	Global $_ToolTipLogHotkey = $Hotkey
	HotKeySet($_ToolTipLogHotkey,"_ToolTipLogSilencer")

	if $x == "" AND $y == "" Then
		global $_ToolTipLog_X = MouseGetPos(0)
		global $_ToolTipLog_Y = MouseGetPos(1)
	ElseIf NOT $x == "" AND $y == "" Then
		global $_ToolTipLog_X = $x ;y coords
		global $_ToolTipLog_Y = 0 ;x coords
	Else
		global $_ToolTipLog_X = $x ;y coords
		global $_ToolTipLog_Y = $y ;x coords
	EndIf

	global $_ToolTipLogLinesWanted = $Lines ;this is how many lines the user wants to see
	global $_ToolTipLogArray[$_ToolTipLogLinesWanted] ;this is the array that will hold as much info as lines to be shown
	global $_ToolTipLogLinesShown = 1 ;this is how many lines should be shown in the tooltip at this point
	$_ToolTipLogArray[0] = $update;$_ToolTipLogArray[$_ToolTipLogLinesWanted-1] = $update ;sets the first array entry to the only available tool tip
	global $_ToolTipLogDisplayString = $update ;sets what to show in the tooltip

	If $_ToolTipLogSilenceMode = 0	Then
		tooltip($_ToolTipLogDisplayString,$_ToolTipLog_X,$_ToolTipLog_Y)
	Else
		tooltip("")
	EndIf

EndFunc ;==> _ToolTipLogStart

Func _ToolTipLog($update, $lines = 0, $x="", $y="")
	Global $_ToolTipLogLinesShown, $_ToolTipLogArray, $_ToolTipLogLinesWanted, $_ToolTipLogSilenceMode
	if $x == "" AND $y == "" Then
	ElseIf NOT $x == "" AND $y == "" Then
		global $_ToolTipLog_X = $x ;y coords
		global $_ToolTipLog_Y = 0 ;x coords
	Else
		global $_ToolTipLog_X = $x ;y coords
		global $_ToolTipLog_Y = $y ;x coords
	EndIf

	If $lines < 0 Then ;removes as many lines from the array as specified, thus shrinking output
		if $lines + $_ToolTipLogLinesShown < 1 then $lines = 0-($_ToolTipLogLinesShown-1) ;prevents the array from being shrunk to less than a single entry
		for $a = 1 to (0-$lines) step 1
			_ArrayDelete($_ToolTipLogArray, UBound($_ToolTipLogArray)-1)
		Next
		$_ToolTipLogLinesWanted += $lines
		$_ToolTipLogLinesShown = $_ToolTipLogLinesWanted
	EndIf

	;Checks to see if the number of lines to show equals the array size. If not, adds one to the number shown to compensate for the new value being 'added'.
	if $_ToolTipLogLinesShown < $_ToolTipLogLinesWanted then
		$_ToolTipLogLinesShown += 1
	EndIf

	;If the desired number of lines has increased, add to the array. Otherwise, push to update information.
	If $lines > 0 Then
		$_ToolTipLogLinesWanted += $lines
		$_ToolTipLogLinesShown += 1
		If $lines > 1 Then ;if the number to add is more than 1, add padding
			$a = 1
			while $a < $lines
				_ArrayInsert($_ToolTipLogArray,ubound($_ToolTipLogArray),"")
				$a += 1
			WEnd
		endif
		_ArrayInsert($_ToolTipLogArray,0,$update)
	Else
		_ArrayPush($_ToolTipLogArray,$update,1)
	EndIf

	;Run through the array and create a string with line breaks in between each value. Lines Shown can never be less than the size of the array
	local $i = 1
	$_ToolTipLogDisplayString = $_ToolTipLogArray[0]
	while $i < $_ToolTipLogLinesShown
		$_ToolTipLogDisplayString = $_ToolTipLogArray[$i] & @LF &  $_ToolTipLogDisplayString
		$i += 1
	WEnd

	;shows the combined string with line breaks in the tool tip
	If $_ToolTipLogSilenceMode = 0	Then
		tooltip($_ToolTipLogDisplayString,$_ToolTipLog_X,$_ToolTipLog_Y)
	Else
		tooltip("")
	EndIf
EndFunc ;==> _ToolTipLog

Func _ToolTipLogSilencer()
	Global $_ToolTipLogSilenceMode
Select
    Case $_ToolTipLogSilenceMode = 0
        $_ToolTipLogSilenceMode = 1
    Case $_ToolTipLogSilenceMode = 1
        $_ToolTipLogSilenceMode = 0
EndSelect
EndFunc ;==> _ToolTipLogSilencer