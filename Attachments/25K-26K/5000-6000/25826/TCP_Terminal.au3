
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



; includes
#include "TCP.au3"
#include <GUIConstants.au3>
#Include <GuiEdit.au3>
#include <Process.au3>
#Include <GuiListView.au3>
#include <WindowsConstants.au3>



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Remote Administrator", 354, 220, -1, -1)
$Combo1 = GUICtrlCreateCombo("", 8, 32, 145, 25)
$label1 = GUICtrlCreateLabel("Computer", 8, 8, 145, 17)
$OutputEditBox = GUICtrlCreateEdit("", 8, 88, 329, 49, BitOR($ES_READONLY,$ES_WANTRETURN,$WS_VSCROLL))
GUICtrlSetData(-1, "")
$pcKeybox = GUICtrlCreateInput("", 160, 32, 97, 21)
$ConnectBTN = GUICtrlCreateButton("Connect", 264, 32, 75, 25, 0)
$Label2 = GUICtrlCreateLabel("Output", 8, 64, 324, 17)
$Label3 = GUICtrlCreateLabel("Key", 160, 8, 94, 17)
$UsernameBox = GUICtrlCreateInput("", 112, 152, 137, 21)
$PasswordBox = GUICtrlCreateInput("", 112, 184, 137, 21, BitOR($ES_PASSWORD,$ES_AUTOHSCROLL))
$InstallBTN = GUICtrlCreateButton("Install", 264, 152, 75, 25, 0)
$UninstallBTN = GUICtrlCreateButton("Uninstall", 264, 184, 75, 25, 0)
$Label4 = GUICtrlCreateLabel("(Domain\) User", 16, 152, 76, 17)
$Label5 = GUICtrlCreateLabel("Password", 16, 184, 82, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

$allowstartup = "1"

While $allowstartup = "1"
$nMsg = GUIGetMsg()
Switch $nMsg
Case $GUI_EVENT_CLOSE
Exit

	Case $ConnectBTN
		$tempname = GUICtrlRead($Combo1)
		$tempIP = ""
		ConnectTestFunction($tempname)
		$allowstartup = "0"
		
		
	Case $InstallBTN
	
		
	
	Case $UninstallBTN
	
EndSwitch
WEnd




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;declare the socket to be a global item
dim $hSocket  
; Create the client. Which will connect to the local ip address on port 88
;$hClient = _TCP_Client_Create(@IPAddress1, 88)
$hClient = _TCP_Client_Create($tempIP, 88)
; Function "Received" will get called when something is received
_TCP_RegisterEvent($hClient, $TCP_RECEIVE, "Received")
; And func "Connected" will get called when the client is connected.
_TCP_RegisterEvent($hClient, $TCP_CONNECT, "Connected")
; And "Disconnected" will get called when the server disconnects us, or when the connection is lost.
_TCP_RegisterEvent($hClient, $TCP_DISCONNECT, "Disconnected")

;msgbox(0,"",$hSocket)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



#Region ### START Koda GUI section ### Form= ; form for actual remote admin
$Form1 = GUICreate("Remote Administrator", 500, 600, -1, -1)	

	;$listview = GUICtrlCreateListView(" Name | Handle | Process ", 10, 40, 380, 500);,$LVS_SORTDESCENDING)
	$listview = GUICtrlCreateListView("", 10, 10, 380, 400)
	_GUICtrlListView_AddColumn ($listview, "Process Name", 200)
	_GUICtrlListView_AddColumn ($listview, "Executable Path", 100)
	_GUICtrlListView_AddColumn ($listview, "PID", 40)
	_GUICtrlListView_AddColumn ($listview, "Executable", 100)
	
	$ProcList = GUICtrlCreateListViewItem("",$listview)
	$getlist = GUICtrlCreateButton("Update", 400, 30, 75, 25)
	$killbutton = guictrlcreatebutton("Kill Task", 400, 60, 75, 25)

	$SendCMDBox = GUICtrlCreateInput("", 10, 420, 140, 25)
	$SendCommand = GUICtrlCreateButton("Send", 160, 420, 60, 25)
	$EXIT = GUICtrlCreateButton("Exit", 230, 420, 60, 25)
	$endSession = GUICtrlCreateButton("End", 300, 420, 60, 25)
	$OutputBox = GUICtrlCreateEdit("Not Connected", 10,460, 380, 100, $ES_READONLY)

GUICtrlSetState(-1, $GUI_DROPACCEPTED)
GUICtrlSetData(-1, "")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

postconnection($hSocket)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



While 1 ;switch statement from  remote admin gui that determines which button was clicked to run a function
	$nMsg = GUIGetMsg()
	Switch $nMsg
		
		Case $GUI_EVENT_CLOSE
			Exit
		
		Case $EXIT
			Exit
		
		Case $endSession
			endSession($hSocket)	
		
		Case $SendCommand
			sendcommand($hSocket)
		
		case $getlist
			GetList($hSocket)
			
		case $killbutton	
			killbutton($hSocket)
		
	EndSwitch
WEnd



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



Func Received($hSocket, $sReceived, $iError);any received information gets processed here
$SentRoutine = StringLeft($sReceived,10)
$SentData = StringTrimLeft($sReceived,10)


switch $SentRoutine ; 

	case "initialtes"
		;GUICtrlEdit_AppendText($OutputEditBox, $SentData & @CRLF)
		;GUICtrlEdit_AppendText($OutputBox, $SentData & @CRLF)
		
		;_GUICtrlButton_Click(
		
		
		
	case "getlist---"
		filllistfunc($hSocket, $SentData)
		
	case "killapp---"
	_GUICtrlEdit_AppendText($OutputBox, $SentData & @CRLF)
	GetList($hSocket)

	case "test----"
	_GUICtrlEdit_AppendText($OutputBox, "Success" & @CRLF)
	;GetList($hSocket)

	case Else
	;GUICtrlEdit_AppendText($OutputBox, $SentData & @CRLF)
	
	
EndSwitch

EndFunc



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Func 	ConnectTestFunction($tempname) ; test connection
	
	TCPStartup()
	dim $hSocket 
	$tempIP = TCPNameToIP($tempname)
	_GUICtrlEdit_AppendText($OutputEditBox, "Attempting to Connect to " & $tempIP & @CRLF)
	
	 
	$hClient = _TCP_Client_Create($tempIP, 88)
	; Function "Received" will get called when something is received
	_TCP_RegisterEvent($hClient, $TCP_RECEIVE, "Received")
	; And func "Connected" will get called when the client is connected.
	_TCP_RegisterEvent($hClient, $TCP_CONNECT, "Connected")
	; And "Disconnected" will get called when the server disconnects us, or when the connection is lost.
	_TCP_RegisterEvent($hClient, $TCP_DISCONNECT, "Disconnected")
	;dim $hSocket  
	_TCP_Send($hClient, "initialtes" & "test")
	
	;msgbox(0,"test socket",$hSocket & ":" & $hClient)
		
EndFunc

Func postconnection(ByRef $hSocket) ; post connection test
	_TCP_Send($hSocket, "test----")
EndFunc

Func killbutton($hSocket) ; request remote process kill
	$SentData =""
	$string = _GUICtrlListView_GetItemTextArray($listview, -1)
		For $i = 4 To 4           
			$SentData = $string[$i]
        NExt   
	_TCP_Send($hSocket, "killapp---" & $SentData)

EndFunc

Func filllistfunc(ByRef $hSocket, ByRef $SentData) ; fills in process list box

	
	;$SentData = StringTrimRight($SentData,1)

	$LineArray = StringSplit($SentData,",")
	_ArrayDelete($lineArray,0)
	;_ArrayDisplay($lineArray,"title")

	For $i = 1 to UBound($lineArray)-1
		if $LineArray[$i] <> "" then
			$ProcList = guictrlcreatelistviewitem($LineArray[$i], $listview)
		EndIf

	Next
			
EndFunc

Func Disconnected($hSocket, $iError); on disconnect what should occur?
EndFunc

func sendcommand(ByRef $hSocket) ; request run commands
	$rawdata = GUICtrlRead($SendCMDBox)
	$rawdata = "command---" & $rawdata
	_TCP_Send($hSocket, $rawdata)
EndFunc	

func GetList(ByRef $hSocket) ; request proc list
	_TCP_Send($hSocket, "getlist---")
	_GUICtrlListView_DeleteAllItems($listview)
EndFunc

func endSession(ByRef $hSocket) ; request end session
	_TCP_Send($hSocket, "exit")
EndFunc
  
Func Connected($hSocket, $iError); on connection what should be done, appeared hit and miss
EndFunc


