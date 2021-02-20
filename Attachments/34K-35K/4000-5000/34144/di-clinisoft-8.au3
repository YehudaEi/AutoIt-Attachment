#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=di-clinisoft-8.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;Opt("WinWaitDelay", 250)
AutoItSetOption("TrayAutoPause",0)
AutoItSetOption("TrayIconHide",1)
$cosaraDir=$CmdLine[1]
$prevLine=""
Do
	$line=""
	If(WinExists("[TITLE:Gebruikerslogin]")) Then
		;bij gebruikerslogin mag er eenmaal gereset worden
		$line = "1"
	Else
		;als er geen gebruikerslogin is, is ofwel care station uit (0) ofwel is er een patient
		$title = WinGetTitle("[REGEXPTITLE:\d\d/\d\d/\d\d\d\d\h+\d\d:\d\d\h+.+((jaar)|(yrs)|(d)|(mon)|(mdn)).+]")
		$title=StringRegExpReplace($title,"\d\d/\d\d/\d\d\d\d\h+\d\d:\d\d\h+","")
		$line = $title
	EndIf
	if( $line <> "0" AND $line <> "1" And $prevLine <> $line) Then
		$file = FileOpen($cosaraDir&"/di-data.properties",2)
		FileWriteLine($file,"data=" & $line)
		FileClose($file)
	EndIf
	$prevLine = $line
	Sleep(250)
Until False