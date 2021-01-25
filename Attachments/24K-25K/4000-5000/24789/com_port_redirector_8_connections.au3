#include <GUIConstants.au3>
#include <CommMG2_5.au3>
#include <GuiEdit.au3>
#include <WindowsConstants.au3>
$btnstate1 = True
$btnstate2 = True
$btnstate3 = True
$btnstate4 = True
$btnstate5 = True
$btnstate6 = True
$btnstate7 = True
$btnstate8 = True

$Main = GUICreate("Com Port Redirector - Com Port Configuration", 680, 340)
GUISetFont(10, 400, "Times New Roman")
$cmboPortsAvailable1 = GUICtrlCreateCombo("", 265, 15, 75, 25)
$lblPort1 = GUICtrlCreateLabel("Connect Port", 175, 20, 80, 25)
$cmboPortsAvailable2 = GUICtrlCreateCombo("", 415, 15, 75, 25)
$lblPort2 = GUICtrlCreateLabel("To Port", 355, 20, 50, 25)
$lblBaud1 = GUICtrlCreateLabel("Baud Rate", 15, 20, 80, 25)
$CmBoBaud1 = GUICtrlCreateCombo("", 90, 15, 70, 25)
GUICtrlSetData(-1, "50|75|110|150|600|1200|1800|2000|2400|3600|4800|7200|9600|10400|14400|15625|19200|28800|38400|56000|57600|115200|", "4800")
$btnConnect1 = GUICtrlCreateButton("Connect Com Ports", 520, 15, 140, 25)
GUICtrlSetBkColor($btnConnect1, "0xFF3333")

$cmboPortsAvailable3 = GUICtrlCreateCombo("", 265, 55, 75, 25)
$lblPort3 = GUICtrlCreateLabel("Connect Port", 175, 60, 80, 25)
$cmboPortsAvailable4 = GUICtrlCreateCombo("", 415, 55, 75, 25)
$lblPort4 = GUICtrlCreateLabel("To Port", 355, 60, 50, 25)
$lblBaud2 = GUICtrlCreateLabel("Baud Rate", 15, 60, 80, 25)
$CmBoBaud2 = GUICtrlCreateCombo("", 90, 55, 70, 25)
GUICtrlSetData(-1, "50|75|110|150|600|1200|1800|2000|2400|3600|4800|7200|9600|10400|14400|15625|19200|28800|38400|56000|57600|115200|", "4800")
$btnConnect2 = GUICtrlCreateButton("Connect Com Ports", 520, 55, 140, 25)
GUICtrlSetBkColor($btnConnect2, "0xFF3333")

$cmboPortsAvailable5 = GUICtrlCreateCombo("", 265, 95, 75, 25)
$lblPort5 = GUICtrlCreateLabel("Connect Port", 175, 100, 80, 25)
$cmboPortsAvailable6 = GUICtrlCreateCombo("", 415, 95, 75, 25)
$lblPort6 = GUICtrlCreateLabel("To Port", 355, 100, 50, 25)
$lblBaud3 = GUICtrlCreateLabel("Baud Rate", 15, 100, 80, 25)
$CmBoBaud3 = GUICtrlCreateCombo("", 90, 95, 70, 25)
GUICtrlSetData(-1, "50|75|110|150|600|1200|1800|2000|2400|3600|4800|7200|9600|10400|14400|15625|19200|28800|38400|56000|57600|115200|", "4800")
$btnConnect3 = GUICtrlCreateButton("Connect Com Ports", 520, 95, 140, 25)
GUICtrlSetBkColor($btnConnect3, "0xFF3333")

$cmboPortsAvailable7 = GUICtrlCreateCombo("", 265, 135, 75, 25)
$lblPort7 = GUICtrlCreateLabel("Connect Port", 175, 140, 80, 25)
$cmboPortsAvailable8 = GUICtrlCreateCombo("", 415, 135, 75, 25)
$lblPort8 = GUICtrlCreateLabel("To Port", 355, 140, 50, 25)
$lblBaud4 = GUICtrlCreateLabel("Baud Rate", 15, 140, 80, 25)
$CmBoBaud4 = GUICtrlCreateCombo("", 90, 135, 70, 25)
GUICtrlSetData(-1, "50|75|110|150|600|1200|1800|2000|2400|3600|4800|7200|9600|10400|14400|15625|19200|28800|38400|56000|57600|115200|", "4800")
$btnConnect4 = GUICtrlCreateButton("Connect Com Ports", 520, 135, 140, 25)
GUICtrlSetBkColor($btnConnect4, "0xFF3333")

$cmboPortsAvailable9 = GUICtrlCreateCombo("", 265, 175, 75, 25)
$lblPort9 = GUICtrlCreateLabel("Connect Port", 175, 180, 80, 25)
$cmboPortsAvailable10 = GUICtrlCreateCombo("", 415, 175, 75, 25)
$lblPort10 = GUICtrlCreateLabel("To Port", 355, 180, 50, 25)
$lblBaud5 = GUICtrlCreateLabel("Baud Rate", 15, 180, 80, 25)
$CmBoBaud5 = GUICtrlCreateCombo("", 90, 175, 70, 25)
GUICtrlSetData(-1, "50|75|110|150|600|1200|1800|2000|2400|3600|4800|7200|9600|10400|14400|15625|19200|28800|38400|56000|57600|115200|", "4800")
$btnConnect5 = GUICtrlCreateButton("Connect Com Ports", 520, 175, 140, 25)
GUICtrlSetBkColor($btnConnect5, "0xFF3333")

$cmboPortsAvailable11 = GUICtrlCreateCombo("", 265, 215, 75, 25)
$lblPort11 = GUICtrlCreateLabel("Connect Port", 175, 220, 80, 25)
$cmboPortsAvailable12 = GUICtrlCreateCombo("", 415, 215, 75, 25)
$lblPort12 = GUICtrlCreateLabel("To Port", 355, 220, 50, 25)
$lblBaud6 = GUICtrlCreateLabel("Baud Rate", 15, 220, 80, 25)
$CmBoBaud6 = GUICtrlCreateCombo("", 90, 215, 70, 25)
GUICtrlSetData(-1, "50|75|110|150|600|1200|1800|2000|2400|3600|4800|7200|9600|10400|14400|15625|19200|28800|38400|56000|57600|115200|", "4800")
$btnConnect6 = GUICtrlCreateButton("Connect Com Ports", 520, 215, 140, 25)
GUICtrlSetBkColor($btnConnect6, "0xFF3333")

$cmboPortsAvailable13 = GUICtrlCreateCombo("", 265, 255, 75, 25)
$lblPort13 = GUICtrlCreateLabel("Connect Port", 175, 260, 80, 25)
$cmboPortsAvailable14 = GUICtrlCreateCombo("", 415, 255, 75, 25)
$lblPort14 = GUICtrlCreateLabel("To Port", 355, 260, 50, 25)
$lblBaud7 = GUICtrlCreateLabel("Baud Rate", 15, 260, 80, 25)
$CmBoBaud7 = GUICtrlCreateCombo("", 90, 255, 70, 25)
GUICtrlSetData(-1, "50|75|110|150|600|1200|1800|2000|2400|3600|4800|7200|9600|10400|14400|15625|19200|28800|38400|56000|57600|115200|", "4800")
$btnConnect7 = GUICtrlCreateButton("Connect Com Ports", 520, 255, 140, 25)
GUICtrlSetBkColor($btnConnect7, "0xFF3333")

$cmboPortsAvailable15 = GUICtrlCreateCombo("", 265, 295, 75, 25)
$lblPort15 = GUICtrlCreateLabel("Connect Port", 175, 300, 80, 25)
$cmboPortsAvailable16 = GUICtrlCreateCombo("", 415, 295, 75, 25)
$lblPort16 = GUICtrlCreateLabel("To Port", 355, 300, 50, 25)
$lblBaud8 = GUICtrlCreateLabel("Baud Rate", 15, 300, 80, 25)
$CmBoBaud8 = GUICtrlCreateCombo("", 90, 295, 70, 25)
GUICtrlSetData(-1, "50|75|110|150|600|1200|1800|2000|2400|3600|4800|7200|9600|10400|14400|15625|19200|28800|38400|56000|57600|115200|", "4800")
$btnConnect8 = GUICtrlCreateButton("Connect Com Ports", 520, 295, 140, 25)
GUICtrlSetBkColor($btnConnect8, "0xFF3333")

GUISetState(@SW_SHOW, $Main)

GUISetOnEvent($GUI_EVENT_CLOSE, "Bye")
$Main1 = GUICreate("Com Port Redirector - Monitor Window", 600, 200)
$lblBaud11 = GUICtrlCreateLabel("", 50, 10, 150, 25)
$lblPort3 = GUICtrlCreateLabel(GUICtrlRead($cmboPortsAvailable1), 10, 10, 35, 25)
$monitor1 = GUICtrlCreateEdit("", 10, 30, 550, 40, BitOR($WS_EX_WINDOWEDGE, $ES_READONLY, $ES_AUTOVSCROLL, $ES_MULTILINE, $WS_VSCROLL))
$lblPort4 = GUICtrlCreateLabel(GUICtrlRead($cmboPortsAvailable2), 10, 90, 35, 25)
$lblBaud12 = GUICtrlCreateLabel("", 50, 90, 150, 25)
$monitor2 = GUICtrlCreateEdit("", 10, 110, 550, 40, BitOR($WS_EX_WINDOWEDGE, $ES_READONLY, $ES_AUTOVSCROLL, $ES_MULTILINE, $WS_VSCROLL))
$btnDisconnect = GUICtrlCreateButton("Disconnect Com Ports", 230, 160, 140, 25)

GetPorts()
SetupComPorts()

;GUISetState(@SW_HIDE, $Main)
;GUISetState(@SW_SHOW, $Main1)

Events()
_CommClearOutputBuffer()
_CommClearInputBuffer()

While 1
	_CommSwitch(1)
	$instr = _CommGetline(@LF, 80, 200)
	GUICtrlSetData($monitor1, $instr)
	_CommSwitch(2)
	_CommSendString($instr)
	$instr = _CommGetline(@LF, 1000, 200)
	GUICtrlSetData($monitor2, $instr)
	_CommSwitch(1)
	_CommSendString($instr)

WEnd


Func Events()
	Opt("GUIOnEventMode", 1)
    GUISetOnEvent($GUI_EVENT_CLOSE, "Bye")
EndFunc;==>Events


Func Bye()
    _Commcloseport()
    Exit
EndFunc;==>Bye

Func GetPorts();Find all com ports
  $portlist = _CommListPorts(0);find the available COM ports and write them into the ports combo
  If @error = 1 Then
	MsgBox(0, 'trouble getting portlist', 'Program will terminate!')
	Exit
  EndIf
  If IsArray($portlist) then
	For $pl = 1 To $portlist[0]
	GUICtrlSetData($cmboPortsAvailable1, $portlist[$pl]);_CommListPorts())
	GUICtrlSetData($cmboPortsAvailable2, $portlist[$pl]);_CommListPorts())
	GUICtrlSetData($cmboPortsAvailable3, $portlist[$pl]);_CommListPorts())
	GUICtrlSetData($cmboPortsAvailable4, $portlist[$pl]);_CommListPorts())
	GUICtrlSetData($cmboPortsAvailable5, $portlist[$pl]);_CommListPorts())
	GUICtrlSetData($cmboPortsAvailable6, $portlist[$pl]);_CommListPorts())
	GUICtrlSetData($cmboPortsAvailable7, $portlist[$pl]);_CommListPorts())
	GUICtrlSetData($cmboPortsAvailable8, $portlist[$pl]);_CommListPorts())
	GUICtrlSetData($cmboPortsAvailable9, $portlist[$pl]);_CommListPorts())
	GUICtrlSetData($cmboPortsAvailable10, $portlist[$pl]);_CommListPorts())
	GUICtrlSetData($cmboPortsAvailable11, $portlist[$pl]);_CommListPorts())
	GUICtrlSetData($cmboPortsAvailable12, $portlist[$pl]);_CommListPorts())
	GUICtrlSetData($cmboPortsAvailable13, $portlist[$pl]);_CommListPorts())
	GUICtrlSetData($cmboPortsAvailable14, $portlist[$pl]);_CommListPorts())
	GUICtrlSetData($cmboPortsAvailable15, $portlist[$pl]);_CommListPorts())
	GUICtrlSetData($cmboPortsAvailable16, $portlist[$pl]);_CommListPorts())
	Next
  Else
	MsgBox(262144,"ERROR", "No COM ports found on this PC.")
  EndIf
  EndFunc;==>GetPorts


Func SetupComPorts();Open com port
    Local $sportSetError
    $baud = GUICtrlRead($CmBoBaud1)
    GUICtrlSetData($lblBaud11, $baud & " bps  -  Monitor 1")
	GUICtrlSetData($lblBaud12, $baud & " bps  -  Monitor 2")
    While 1
		
	    Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				Bye()
            ExitLoop
            
                  
        Case $btnConnect1
            If $btnstate1 Then
				
				$setport1 = StringReplace(GUICtrlRead($cmboPortsAvailable1), 'COM', '')
				_CommSetPort($setport1, $sportSetError, $baud, 8, 0, 1, 0)
				$setport2 = StringReplace(GUICtrlRead($cmboPortsAvailable2), 'COM', '')
				_CommSetPort($setport2, $sportSetError, $baud, 8, 0, 1, 0)
				GUICtrlSetData($btnConnect1, "Disconnect Com ports")
				GUICtrlSetBkColor($btnConnect1, "0x9DF10B")
				Connect1()
			
				Else
					Disconnect()

				GUICtrlSetData($btnConnect1, 'Connect Com Ports')
				GUICtrlSetBkColor($btnConnect1, "0xFF3333")
				
			Endif
            
            $btnstate1 = Not $btnstate1
			
		Case $btnConnect2
            If $btnstate2 Then
				
				$setport3 = StringReplace(GUICtrlRead($cmboPortsAvailable3), 'COM', '')
				_CommSetPort($setport3, $sportSetError, $baud, 8, 0, 1, 0)
				$setport4 = StringReplace(GUICtrlRead($cmboPortsAvailable4), 'COM', '')
				_CommSetPort($setport4, $sportSetError, $baud, 8, 0, 1, 0)
				GUICtrlSetData($btnConnect2, "Disconnect Com ports")
				GUICtrlSetBkColor($btnConnect2, "0x9DF10B")
				
			
				Else
					Disconnect()

				GUICtrlSetData($btnConnect2, 'Connect Com Ports')
				GUICtrlSetBkColor($btnConnect2, "0xFF3333")
				
			Endif
            
            $btnstate2 = Not $btnstate2
			
		Case $btnConnect3
            If $btnstate3 Then
				
				$setport5 = StringReplace(GUICtrlRead($cmboPortsAvailable5), 'COM', '')
				_CommSetPort($setport5, $sportSetError, $baud, 8, 0, 1, 0)
				$setport6 = StringReplace(GUICtrlRead($cmboPortsAvailable6), 'COM', '')
				_CommSetPort($setport6, $sportSetError, $baud, 8, 0, 1, 0)
				GUICtrlSetData($btnConnect3, "Disconnect Com ports")
				GUICtrlSetBkColor($btnConnect3, "0x9DF10B")
				
			
				Else
					Disconnect()

				GUICtrlSetData($btnConnect3, 'Connect Com Ports')
				GUICtrlSetBkColor($btnConnect3, "0xFF3333")
				
			Endif
            
            $btnstate3 = Not $btnstate3	
			
		Case $btnConnect4
            If $btnstate4 Then
				
				$setport7 = StringReplace(GUICtrlRead($cmboPortsAvailable7), 'COM', '')
				_CommSetPort($setport7, $sportSetError, $baud, 8, 0, 1, 0)
				$setport8 = StringReplace(GUICtrlRead($cmboPortsAvailable8), 'COM', '')
				_CommSetPort($setport8, $sportSetError, $baud, 8, 0, 1, 0)
				GUICtrlSetData($btnConnect4, "Disconnect Com ports")
				GUICtrlSetBkColor($btnConnect4, "0x9DF10B")
				
			
				Else
					Disconnect()

				GUICtrlSetData($btnConnect4, 'Connect Com Ports')
				GUICtrlSetBkColor($btnConnect4, "0xFF3333")
				
			Endif
            
            $btnstate4 = Not $btnstate4	


		Case $btnConnect5
            If $btnstate5 Then
				
				$setport9 = StringReplace(GUICtrlRead($cmboPortsAvailable9), 'COM', '')
				_CommSetPort($setport9, $sportSetError, $baud, 8, 0, 1, 0)
				$setport10 = StringReplace(GUICtrlRead($cmboPortsAvailable10), 'COM', '')
				_CommSetPort($setport10, $sportSetError, $baud, 8, 0, 1, 0)
				GUICtrlSetData($btnConnect5, "Disconnect Com ports")
				GUICtrlSetBkColor($btnConnect5, "0x9DF10B")
				
			
				Else
					Disconnect()

				GUICtrlSetData($btnConnect5, 'Connect Com Ports')
				GUICtrlSetBkColor($btnConnect5, "0xFF3333")
				
			Endif
            
            $btnstate5 = Not $btnstate5		
		
		Case $btnConnect6
            If $btnstate6 Then
				
				$setport11 = StringReplace(GUICtrlRead($cmboPortsAvailable11), 'COM', '')
				_CommSetPort($setport11, $sportSetError, $baud, 8, 0, 1, 0)
				$setport12 = StringReplace(GUICtrlRead($cmboPortsAvailable12), 'COM', '')
				_CommSetPort($setport12, $sportSetError, $baud, 8, 0, 1, 0)
				GUICtrlSetData($btnConnect6, "Disconnect Com ports")
				GUICtrlSetBkColor($btnConnect6, "0x9DF10B")
				
			
				Else
					Disconnect()

				GUICtrlSetData($btnConnect6, 'Connect Com Ports')
				GUICtrlSetBkColor($btnConnect6, "0xFF3333")
				
			Endif
            
            $btnstate6 = Not $btnstate6	


		Case $btnConnect7
            If $btnstate7 Then
				
				$setport13 = StringReplace(GUICtrlRead($cmboPortsAvailable13), 'COM', '')
				_CommSetPort($setport13, $sportSetError, $baud, 8, 0, 1, 0)
				$setport14 = StringReplace(GUICtrlRead($cmboPortsAvailable14), 'COM', '')
				_CommSetPort($setport14, $sportSetError, $baud, 8, 0, 1, 0)
				GUICtrlSetData($btnConnect7, "Disconnect Com ports")
				GUICtrlSetBkColor($btnConnect7, "0x9DF10B")
				
			
				Else
					Disconnect()

				GUICtrlSetData($btnConnect7, 'Connect Com Ports')
				GUICtrlSetBkColor($btnConnect7, "0xFF3333")
				
			Endif
            
            $btnstate7 = Not $btnstate7	

        Case $btnConnect8
            If $btnstate8 Then
				
				$setport15 = StringReplace(GUICtrlRead($cmboPortsAvailable15), 'COM', '')
				_CommSetPort($setport15, $sportSetError, $baud, 8, 0, 1, 0)
				$setport16 = StringReplace(GUICtrlRead($cmboPortsAvailable16), 'COM', '')
				_CommSetPort($setport16, $sportSetError, $baud, 8, 0, 1, 0)
				GUICtrlSetData($btnConnect8, "Disconnect Com ports")
				GUICtrlSetBkColor($btnConnect8, "0x9DF10B")
				
			
				Else
					Disconnect()

				GUICtrlSetData($btnConnect8, 'Connect Com Ports')
				GUICtrlSetBkColor($btnConnect8, "0xFF3333")
				
			Endif
            
            $btnstate8 = Not $btnstate8		
        
	EndSwitch
	
			
	
	
    WEnd
EndFunc;==>SetupComPorts

Func Connect1()
	_CommSwitch(1)
	$instr = _CommGetline(@LF, 80, 200)
	_CommSwitch(2)
	_CommSendString($instr)
	$instr = _CommGetline(@LF, 1000, 200)
	_CommSwitch(1)
	_CommSendString($instr)
EndFunc;==>Connect1
	

Func Disconnect()
	_CommSwitch(1)
	_CommClosePort()
	_CommSwitch(2)
	_CommClosePort()
EndFunc;==>Disconnect