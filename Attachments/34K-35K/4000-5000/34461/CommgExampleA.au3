;Example program showing how to use some of the commMg3.au3 UDF functions
;this example is a very simple terminal
;Version 2.1 21th June 2011
;changes-
;Added $progname variable and utilized in all titles.
;bugfix - version of dll shown as unknown until port setting menu closed.
;changed output window to courier font. Monospaced fonts easier to read if data is lined up in terminal output.
;changed - removed sorting of baud rate in drop down window. Sorting was from left character, not from numeric value.
;changed/added additional "standard baud rates": 300, 230400, 460800, 921600 as well as 1000000 and 2000000 (Tested to 921600)
;bugfix - only display error message box if error exists.
;bugfix - fixed spelling of "quit" from "quite"

#include <GUIConstants.au3>
#include 'CommMG.au3';or if you save the commMg.dll in the @scripdir use #include @SciptDir & '\commmg.dll'
#include <GuiEdit.au3>
#include <GuiComboBox.au3>
#include <windowsconstants.au3>
#include <buttonconstants.au3>


Opt("WINTITLEMATCHMODE",3)
;Opt("OnExitFunc","alldone")
HotKeySet("{ESC}","alldone")

$result = '';used for any returned error message setting port
Global $progname = "COMMG Example v2.1" ;MRC set progname variable
Const $settitle = $progname & " - set Port", $maintitle = $progname ;MRC utilized progname variable instead of direct name
$setflow = 2;default to no flow control
Dim $FlowType[3] = ["XOnXoff","Hardware (RTS, CTS)", "NONE"]
#region main program

#Region ### START Koda GUI section ### Form=d:\my documents\miscdelphi\commg\ExampleComm.kxf
$Form2 = GUICreate( $progname , 473, 349, 339, 333, BitOR($WS_MAXIMIZEBOX,$WS_MINIMIZEBOX,$WS_SIZEBOX,$WS_THICKFRAME,$WS_SYSMENU,$WS_CAPTION,$WS_OVERLAPPEDWINDOW,$WS_TILEDWINDOW,$WS_POPUP,$WS_POPUPWINDOW,$WS_GROUP,$WS_TABSTOP,$WS_BORDER,$WS_CLIPSIBLINGS))
$Edit1 = GUICtrlCreateEdit("", 10, 25, 449, 223, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_READONLY,$ES_WANTRETURN,$WS_HSCROLL,$WS_VSCROLL))
$BtnSend = GUICtrlCreateButton("Send", 380, 273, 53, 30, $BS_FLAT)
$Input1 = GUICtrlCreateInput("", 18, 279, 361, 21)
$Checkbox1 = GUICtrlCreateCheckbox("Add LF to incomming CR", 273, 4, 145, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetResizing(-1, $GUI_DOCKAUTO)
$Label11 = GUICtrlCreateLabel("Text to send", 24, 261, 63, 17)
$BtnSetPort = GUICtrlCreateButton("Set Port", 16, 312, 73, 30, $BS_FLAT)
$Label21 = GUICtrlCreateLabel("Received text", 34, 6, 70, 17)
$Label31 = GUICtrlCreateLabel("commg.dll version unknown", 272, 328, 135, 17)
GUICtrlSetData($Label31,'using ' & _CommGetVersion(1)) ;MRC added to check the status right away not waiting to clear the first menu.
GUICtrlSetColor(-1, 0x008080)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
WinSetTitle($Form2,"",$maintitle & "  UDF = " & _CommGetVersion(1))

While setport(0) = -1
	If MsgBox(4,'Port not set','Do you want to quit the program?') = 6 Then Exit ;MRC Quit was mis-spelled quite
	WEnd

#cs
	_CommSwitch(2)
MsgBox(0,'set com11 res = ',_CommSetport(11,$result,9600,8,'none',1,1))
MsgBox(0,'set port 11 gives',$result)
_CommSendString("It's Monday" & @CR)
_CommSwitch(1)
AdlibEnable("port11",500)
#ce


;GUISwitch($Form2)
ConsoleWrite("stage 1" & @CRLF)
GUICtrlSetData($Label31,'using ' & _CommGetVersion(1))
ConsoleWrite("stage 2" & @CRLF)
Events()
ConsoleWrite("at 64" & @CRLF)
_CommSetXonXoffProperties(11,13,100,100)
consolewrite("return from set timeouts = " & _CommSetTimeouts(5,5,5,5,5) & @CR)
GUICtrlSetState($edit1,$GUI_FOCUS)
ConsoleWrite("at 67" & @CRLF)
_CommSetRTS(1)
_CommSetDTR(1)

_CommSetRTS(0)
_CommSetDTR(0)
While 1

	;gets characters received returning when one of these conditions is met:
	;receive @CR, received 20 characters or 200ms has elapsed
	$instr =  _CommGetString()
	;While StringInStr($instr,@CR) = 0
	;	$instr = $instr &  _CommGetString();_CommGetline(@CR,100,200)
	;WEnd
	;$Instr = StringMid($instr,StringInStr($Instr,@CR) + 2,StringInStr($instr,@CR,0,2) - 1)
	;$instr1 = StringLeft($instr,StringInStr($instr,@CR))
	;$instr1 = StringLeft($instr,StringInStr($instr,@CR) - 1)
	;MsgBox(0,$instr1,$instr)
	;$scroll = StringInStr($instr,@CR)
	If $instr <> '' Then;if we got something
		GUICtrlSetFont($edit1,10,400,0,"Courier") ;MRC change the font to Courier
		GUICtrlSetData($edit1,$instr)
		;If GUICtrlRead($Checkbox1) = $GUI_CHECKED Then $instr = StringReplace($instr,@CR,@CRLF)
		;$lines = GUICtrlRead($edit1)
		;$charcount = StringLen($lines)
		;_GUICtrlEditSetSel($edit1, $charcount, $charcount)
		;If $charcount > 10000 Then GUICtrlSetData($edit1,StringRight($lines & $Instr,8000))
		; _GUICtrlEditReplaceSel($edit1, False, $instr)
		; _GUICtrlEditScroll($edit1,$SB_SCROLLCARET)
		;;;If $scroll Then _GUICtrlEditLineScroll($edit1,0,_GUICtrlEditGetLineCount($edit1) - 14)
	EndIf
Sleep(10);MRC add a small delay to keep processor from having huge load 10ms will reduce cpu on P4 from 80% to less than 15%
WEnd

Alldone()


Func port11()
;MsgBox(0,'now set to channel',_CommSwitch(2))
_commSwitch(2)
	$s2 = "1 2 3 4";_CommGetString()
	ConsoleWrite("comm1 gets " & $s2 & @CRLF)
	_CommSendString($s2)
	_CommSwitch(1)

EndFunc

#endregion main program
Func Events()
	Opt("GUIOnEventMode",1)
	GUISetOnEvent($GUI_EVENT_CLOSE, "justgo")
	GUICtrlSetOnEvent($BtnSend,"SendEvent")
	GUICtrlSetOnEvent($BtnSetPort,"SetPortEvent")
EndFunc

Func SetPortEvent()
	setport();needed because a parameter is optional for setport so we can't use "setport" for the event
	GUICtrlSetState($edit1,$GUI_FOCUS)
EndFunc

Func justgo()
	Exit
EndFunc

Func SendEvent();send the text in the inputand append CR
	_CommSendstring(GUICtrlRead($Input1) & @CR)
	GUICtrlSetData($Input1,'');clear the input
	;GUICtrlSetState($edit1,$GUI_FOCUS);sets the caret back in the terminal screen
EndFunc


Func AllDone()
	;MsgBox(0,'will close ports','')
	_Commcloseport()
	;MsgBox(0,'port closed','')
	Exit
EndFunc


; Function SetPort($mode=1)
; Creates a form for the port settings
;Parameter $mode sets the return value depending on whether the port was set
;Returns  0 if $mode <> 1
;          -1 If` the port not set and $mode is 1
Func SetPort($mode=1);if $mode = 1 then returns -1 if settings not made

    Opt("GUIOnEventMode",0);keep events for $Form2, use GuiGetMsg for $Form3

#Region ### START Koda GUI section ### Form=d:\my documents\miscdelphi\commg\examplecommsetport.kxf
$Form3 = GUICreate( $progname & " - set Port", 422, 279, 329, 268, BitOR($WS_MINIMIZEBOX,$WS_CAPTION,$WS_POPUP,$WS_GROUP,$WS_BORDER,$WS_CLIPSIBLINGS,$DS_MODALFRAME), BitOR($WS_EX_TOPMOST,$WS_EX_WINDOWEDGE))
$Group1 = GUICtrlCreateGroup("Set COM Port", 18, 8, 288, 252)
$CmboPortsAvailable = GUICtrlCreateCombo("", 127, 28, 145, 25)
;$CmBoBaud = GUICtrlCreateCombo("9600", 127, 66, 145, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL,$CBS_SORT,$WS_VSCROLL))
$CmBoBaud = GUICtrlCreateCombo("9600", 127, 66, 145, 25) ; MRC get rid of the sort, 9600 is the default baud rate.
;GUICtrlSetData(-1, "10400|110|115200|1200|128000|14400|150|15625|1800|19200|2000|2400|256000|28800|38400|3600|38400|4800|50|56000|57600|600|7200|75")
;Sorting was strange...Changed to:
GUICtrlSetData(-1, "50|75|110|150|300|600|1200|1800|2000|2400|3600|4800|7200|10400|14400|15625|19200|28800|38400|56000|57600|115200|128000|230400|256000|460800|921600|1000000|2000000") ;MRC changed the ordering. Added a few "common" rates that were missing.
$CmBoStop = GUICtrlCreateCombo("1", 127, 141, 145, 25)
GUICtrlSetData(-1, "1|2|1.5")
$CmBoParity = GUICtrlCreateCombo("none", 127, 178, 145, 25)
GUICtrlSetData(-1, "odd|even|none")
$Label2 = GUICtrlCreateLabel("Port", 94, 32, 23, 17)
$Label3 = GUICtrlCreateLabel("baud", 89, 70, 28, 17)
$Label4 = GUICtrlCreateLabel("No. Stop bits", 52, 145, 65, 17)
$Label5 = GUICtrlCreateLabel("parity", 88, 182, 29, 17)
$CmboDataBits = GUICtrlCreateCombo("8", 127, 103, 145, 25)
GUICtrlSetData(-1, "7|8")
$Label7 = GUICtrlCreateLabel("No. of Data Bits", 38, 107, 79, 17)
$ComboFlow = GUICtrlCreateCombo("NONE", 127, 216, 145, 25)
GUICtrlSetData(-1, "NONE|XOnXOff|Hardware (RTS, CTS)")
$Label1 = GUICtrlCreateLabel("flow control", 59, 220, 58, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$BtnApply = GUICtrlCreateButton("Apply", 315, 95, 75, 35, $BS_FLAT)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$BtnCancel = GUICtrlCreateButton("Cancel", 316, 147, 76, 35, $BS_FLAT)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


    WinSetTitle($Form3,"",$settitle);ensure a change to Koda design doesn't stop script working
	$mainxy = WinGetPos($Form2)
	WinMove($Form3,"",$mainxy[0] + 20,$mainxy[1] + 20)

	$portlist = _CommListPorts(0);find the available COM ports and write them into the ports combo
	If @error = 1 Then
		MsgBox(0,'trouble getting portlist','Program will terminate!')
		Exit
	EndIf


	For $pl = 1 To $portlist[0]
		GUICtrlSetData($CmboPortsAvailable,$portlist[$pl]);_CommListPorts())
	Next
	GUICtrlSetData($CmboPortsAvailable,$portlist[1]);show the first port found
    GUICtrlSetData($ComboFlow,$flowtype[$setflow])
	_GUICtrlComboBox_SetMinVisible($CmBoBaud,20);MRC restrict the length of the drop-down list before scrolling (changed from 10 to 20)

	$retval = 0

	While 1
		$msg = GUIGetMsg()
		If $msg = $btnCancel Then
			If Not  $mode Then $retval = -1
			ExitLoop
		EndIf


		If $msg = $BtnApply Then
			Local $sportSetError
			$comboflowsel = GUICtrlRead($ComboFlow)
			For $n = 0 To 2
				If $comboflowsel = $flowtype[$n] Then
					$setFlow = $n
					ConsoleWrite("flow = " & $setflow & @CRLF)
					ExitLoop
				EndIf

			Next
			$setport = StringReplace(GUICtrlRead($CmboPortsAvailable),'COM','')
			_CommSetPort($setPort,$sportSetError,GUICtrlRead($CmBoBaud),GUICtrlRead($CmboDataBits),GUICtrlRead($CmBoParity),GUICtrlRead($CmBoStop),$setFlow)
			if $sportSetError <> "" Then ;MRC only display error message box if error exist
			MsgBox(262144,'Setport error = ',$sportSetError)
			EndIf
			$mode = 1;
			ExitLoop
		EndIf

		;stop user switching back to $form2
		If WinActive($maintitle) Then
			ConsoleWrite('main is active' & @CRLF)
			If WinActivate($settitle) = 0 Then MsgBox(0,'not found',$settitle)
		EndIf


	WEnd
	GUIDelete($Form3)
	WinActivate($maintitle)
	Events()
	Return $retval


EndFunc
