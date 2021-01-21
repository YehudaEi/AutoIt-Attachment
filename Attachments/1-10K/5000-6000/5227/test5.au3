Global $Paused
Global $title
HotKeySet("{PAUSE}", "TogglePause")

$var = WinList()
$done=0
$handle=0
$MsgActive=0
$pos=0

;Choose Window to be always on top, and always focused
For $i = 1 to $var[0][0]
  ; Only display visble windows that have a title
  If $var[$i][0] <> "" AND IsVisible($var[$i][1]) and $done=0 Then
    $MsgActive=MsgBox(4, "Set this to Always on top, Always focused?", "Title=" & $var[$i][0] & @LF & "Handle=" & $var[$i][1])
	Select
        Case $MsgActive = 6
            $done=1
			$handle=$var[$i][1]
			$title=$var[$i][0]
    EndSelect
  EndIf
Next

WinSetOnTop($title,"",1)
while 1
	WinWaitNotActive($title)
	
	;Allow Click outisde of app, then refocus
	while IsPressed('01') or IsPressed('02')
	Wend
	
	; Check if window is minimized, if so let it until user reopens it
	$state = WinGetState($title)
	If BitAnd($state, 16) Then
		WinWaitActive($title)
	EndIf
	
	WinActivate($title)
WEnd

Func IsVisible($handle)
  If BitAnd( WinGetState($handle), 2 ) Then 
    Return 1
  Else
    Return 0
  EndIf

EndFunc

Func IsPressed($hexKey)	
  Local $aR, $bO
  
  $hexKey = '0x' & $hexKey
  $aR = DllCall("user32", "int", "GetAsyncKeyState", "int", $hexKey)
  If Not @error And BitAND($aR[0], 0x8000) = 0x8000 Then
     $bO = 1
  Else
     $bO = 0
  EndIf
  
  Return $bO
EndFunc

Func TogglePause()
    $Paused = NOT $Paused
	ToolTip('Script is "Paused"',0,0)
    While $Paused
    WEnd
    ToolTip("")
EndFunc