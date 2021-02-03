#include <GUIConstantsEx.au3>
#include <string.au3>
#include <Array.au3>
#include <WinAPI.au3>
Opt('MustDeclareVars', 1)

;==============================================
;==============================================
;SERVER!! Start Me First !!!!!!!!!!!!!!!
;==============================================
;==============================================
dim $szIPADDRESS = "192.168.0.101"
	;MsgBox("","",$szIPADDRESS)
    dim $nPORT = 8000
	dim $MainSocket, $GOOEY, $edit, $ConnectedSocket, $szIP_Accepted, $data, $string, $array[1],$arrayS, $stringL,$tempS, $string0
    dim $msg, $recv
Example()

Func Example()
    ; Set Some reusable info
    ; Set your Public IP address (@IPAddress1) here.
;   Local $szServerPC = @ComputerName
;   Local $szIPADDRESS = TCPNameToIP($szServerPC)


    ; Start The TCP Services
    ;==============================================
    UDPStartup()

    ; Create a Listening "SOCKET".
    ;   Using your IP Address and Port 33891.
    ;==============================================
    $MainSocket = UDPBind($szIPADDRESS, $nPORT)
    ; If the Socket creation fails, exit.
    If @error <> 0 Then Exit


    ; Create a GUI for messages
    ;==============================================
    $GOOEY = GUICreate("My Server (IP: " & $szIPADDRESS & ")", 400, 200)
    $edit = GUICtrlCreateEdit("", 10, 10, 380, 180)
    GUISetState()

    ; GUI Message Loop
    ;==============================================
    While 1
        $msg = GUIGetMsg()
        ; GUI Closed
        ;--------------------
        If $msg = $GUI_EVENT_CLOSE Then Exit

		$data = UDPRecv($MainSocket, 100)
		;EndIf
		sleep(100)

        ; Update the edit control with what we have received
        ;----------------------------------------------------------------
		If $data <> "" Then
		dim $string0,$string1,$nullStartPos,$stringL,$controlName,$payload, $payloadX, $payloadY
		$data=StringTrimLeft($data,2);removes first two characters that are not HEX values
			;*****will programatically get name of the control***
			;*
			;****************************************************
		$stringL=StringLen($data); get the length of the OSC message (is variable by control)
		$nullStartPos=StringInStr($data,"00"); look for the first null value in the string
		$controlName=StringTrimRight($data,($stringL-$nullStartPos)+1);gets HEX representation of control name
		$controlName=_HexToString($controlName);converts HEX name to string
		;end name of the control
			;*****will programatically get value sent by the control***
			;*
			;********************************************************
			if StringInStr($data,"2C6666")>0 then
			$payloadX=StringTrimLeft($data,$stringL-16)
			;MsgBox("","",$payloadX)
			$payloadX=StringTrimRight($payloadX,8)
			;MsgBox("","this is the raw payloadX",$payloadX)
			$payloadX=DEC($payloadX)
			$payloadX =_WinAPI_IntToFloat($payloadX)
			;---------------------------------------------
			$payloadY=StringTrimLeft($data,$stringL-8)
			;MsgBox("","this is the raw payloadY",$payloadY)
			$payloadY=DEC($payloadY)
			$payLoadY=_WinAPI_IntToFloat($payloadY)
			$payloadX=round($payloadX*1280,0)
			$payloadY=round($payloadY*800,0)
			MouseMove($payloadX,$payloadY,1)
			else
			$payload=StringTrimLeft($data,$stringL-8); the floating point value in HEX
			$payload=DEC($payload); convert the HEX to DEC (int)
			$payload=_WinAPI_IntToFloat($payload) ; convert the INT to a float
				if $controlName = "/1/push1" and $payload="0" Then
					MouseDown ("left")
				EndIf
				if $controlName = "/1/push1" and $payload="1" Then
					MouseUp("left")
				EndIf
				if $controlName = "/1/push2" and $payload="0" Then
					MouseDown ("right")
				EndIf
				if $controlName = "/1/push2" and $payload="1" Then
					MouseUp("right")
				EndIf
			EndIf
			if StringInStr($data,"2C6666")>0 then
			GUICtrlSetData($edit,$controlName &" X/Y>"&$payloadX & "/"&$payloadY & @crlf & GUICtrlRead($edit));render results in edit control
			Else
			GUICtrlSetData($edit,$controlName &" >"&$payload  & @crlf & GUICtrlRead($edit));render results in edit control
			EndIf
		EndIf
	 WEnd
EndFunc   ;==>Example
Func OnAutoItExit()
    UDPCloseSocket($MainSocket)
    UDPShutdown()
EndFunc
