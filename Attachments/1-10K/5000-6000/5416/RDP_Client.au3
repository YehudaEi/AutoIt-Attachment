; ---------------------------------------------------------------------------
; AutoIt Version: 3.1.1
; Author:         Rick Weber
;
; Script Function:
;	Displays all current RDP user IP or Name and Writes it to the registry for BGInfo
;	Works with multiple RDP connections and on alternate RDP ports
;
; command line
; -?  Help
; -s  Silent mode - to use in a start up script
; -ip  use IP rather than name
; ---------------------------------------------------------------------------

Opt("MustDeclareVars", 1)

dim $title = "RDP Client Address"

; Don't run multiple copies!
If WinExists($title) Then Exit(1) ; It's already running
AutoItWinSetTitle($title)

dim $TempF, $f, $cmd, $value, $avalue[100], $pos1, $pos2, $i, $silent = 0, $IP = "", $IsClient
dim $ComputerName=@ComputerName, $RDP
dim $Key = "\SOFTWARE\BGInfo", $ValName = "RDPclient"

; Extended command line paramerters
If $CmdLine[0] > 0 then
	For $i = 1 to $CmdLine[0]
		Select ;$CmdLine[$i]
			Case $CmdLine[$i] = "-s" OR $CmdLine[$i] = "/s"
				$silent = 1
			Case $CmdLine[$i] = "-ip" OR $CmdLine[$i] = "/ip"
				$IP = "-n "
				$ComputerName=@IPAddress1
			Case $CmdLine[$i] = "-?" OR $CmdLine[$i] = "/?"
				MsgBox (0, $title,"Writes the RDP client address to the Registry" & @CR & _
				"HKCU" & $Key & "\" & $ValName & @CR  & @CR & _
				"-?	Help" & @CR & _
				"-s	Silent mode - for BAT files" & @CR & _
				"-ip	Use IP Address rather than Computer Name")
				exit(0)
		EndSelect
	Next
EndIf

$RDP = RegRead("HKLM\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp", "PortNumber")

$TempF = EnvGet("TEMP") & "\rdpclient.txt"

; Run netstat
$cmd = @SystemDir & "\netstat.exe -p TCP " & $IP & "|find """ & $ComputerName & ":" & $RDP & """>" & $TempF
RunWait(@ComSpec & " /c " & $cmd, "", @SW_HIDE)

; Parse the results of netstat
$f = FileOpen($TempF, 0)
$i = 1
While 1
    $avalue[$i] = FileReadLine($f)
    if $avalue[$i] == "" then $i = $i - 1
    If @error = -1 Then ExitLoop
    $i = $i + 1
Wend
FileClose($f)
$avalue[0] = $i
ReDim $avalue[$i + 1]

$i = 1
do
	if $avalue[0] >= 1 Then $value = $avalue[$i]

	$pos1 = StringInStr($value, ":") + 1
	$pos2 = StringInStr($value, ":", 0, 2) - $pos1
	$value= StringMid($value, $pos1, $pos2)

	; Generates an explanation of the discovered value
	if StringLeft($value, 4) = $RDP then
		$IsClient = "remote desktop client"
	elseif $value = "" then
		$IsClient = "unknown (probably the local host, RDP not in use)"
	else
		$IsClient = "the local host"
	endif

	; Parse the address out of the value
	$pos1 = StringInStr($value, " ") + 1
	$value= StringStripWS(StringMid($value, $pos1), 1)
	if $value = "" then $value = "NA" ; this happens when run locally
	if $avalue[0] >= 1 Then $avalue[$i] = $value

	; Write results to registry
	; backward compatibility with my BGInfo setup
	if $i == 1 then
		RegWrite("HKLM" & $Key, $ValName, "REG_SZ", $value)
		RegWrite("HKCU" & $Key, $ValName, "REG_SZ", $value)
	else
		RegWrite("HKLM" & $Key, $ValName & $i, "REG_SZ", $value)
		RegWrite("HKCU" & $Key, $ValName & $i, "REG_SZ", $value)
	endif
	$i = $i + 1
Until $i > $avalue[0]

; Display results - or not
if $silent = 1 then exit(0)

; Build a string of multiple values
if $value <> "NA" Then
	$value = ""
	For $i = 1 to $avalue[0]
		$value = $value & $avalue[$i] & ", "
	next
	$value = StringLeft($value, StringLen($value) - 2)
Endif
; Input box for easy copy/paste of value
Inputbox($title, "Remote Desktop client address:" & @CR & @CR & "address = " & $IsClient, $value, "", 400, -1)


