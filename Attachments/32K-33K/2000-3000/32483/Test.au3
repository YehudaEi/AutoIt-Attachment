
; Exact Title force lower case match
Opt("WinTitleMatchMode",-3)

Global $Handle_Explorer_left
Global $Handle_Explorer_right

create_Explorer("left")
update_Explorer("c:\windows",$Handle_Explorer_left)
create_Explorer("right")
update_Explorer("c:\temp",$Handle_Explorer_right)

Sleep(2000)
; doesnt work!!!
WinActivate($Handle_Explorer_left)

Sleep(2000)

; doesnt work!!!
WinClose($Handle_Explorer_left)
Exit


func create_Explorer($left_right)
	ShellExecute("explorer.exe")
	if @OSVersion = "WIN_7" Then
		$title = "Bibliotheken"
	Else
		$title = "Eigene Dateien"
	EndIf
	if $left_right="left" Then
		; left
		$Handle_Explorer_left = WinGetHandle($title,"")
		WinWaitActive($Handle_Explorer_left)
		WinMove($Handle_Explorer_left,"",0,0,@DesktopWidth/2,@DesktopHeight-480-60)
	Else
		; right
		$Handle_Explorer_right = WinGetHandle($title,"")
		WinWaitActive($Handle_Explorer_right)
		WinMove($Handle_Explorer_right,"",@DesktopWidth/2,0,@DesktopWidth/2,@DesktopHeight-480-60)
	EndIf
EndFunc

func update_Explorer($Folder,$handle)
	$ret = WinActivate($handle)
	BlockInput(1)
	if @OSVersion = "WIN_7" Then
		$ret = ControlClick($handle,"",1001,"left",1,580)
	Else
		$ret = ControlClick($handle,"","Edit1","left",1,580)
	EndIf
		
	if $ret = 0 then 
		BlockInput(0)
		MsgBox(0,"Fehler","Click",1)
		update_Explorer($Folder,$handle)
		Return
	EndIf

	send("{HOME}")		
	$text = $Folder
	send("+{END}")
	ClipPut($text)
	;$ret = Sendcorrect($text)
	send("^v")
	send("{Enter}")
	BlockInput(0)
;	MsgBox(0,"Warte",$text)
	WinWait(StringLeft($text,95),"",5)
;	MsgBox(0,"Fertig",$text)
EndFunc
