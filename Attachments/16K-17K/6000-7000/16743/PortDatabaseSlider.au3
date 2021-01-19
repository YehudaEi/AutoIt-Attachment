;===============================================================================
; Description:  Demonstration of range extension for UP/DN Spinner and Slider
; 				using GUICtrlCreateUpdown and GUICtrlCreateSlider controls.
; 				Converts range of controls from -32768 -> 32767 To 0 -> 65535
;				UP/DN Spinner, Slider and Inputbox controls interlink and update each other
;
; Author(s)  :  Rover 2k7, from idea by Particle for Port Info Database GUI
;===============================================================================

; UP/DN control hold down acceleration set for:
; 1 step, after 2 seconds 10 steps, after 5 seconds 200 steps

#include <guiconstants.au3>
#include <GuiSlider.au3>

Opt("GUIoneventmode",1)
Opt("MustDeclareVars", 1)

Global Const $WM_HSCROLL = 0x0114
Global Const $WM_VSCROLL = 0x0115
Global Const $UDM_SETACCEL = $WM_USER+107

Local $gui, $slider, $updown, $input0, $input1
Local $read, $val
Local $sliderhwnd, $input0hwnd, $input1hwnd
Local $label, $font = "Arial"

;Local $font = "DIGITAL READOUT UPRIGHT"
; an LCD font for the inputbox would look good, look into "XSkin" for GUI skinning

;---- GUI & LABELS --------------------------------
$gui = GUICreate("Port Scan",550,350)
GUICtrlCreateLabel("Select Port"&@tab&"0",35,10,200)
GUICtrlSetFont(-1,9,800)
GUICtrlCreateLabel("65535",480,10,80)
GUICtrlSetFont(-1,9,800)
GUICtrlCreateLabel("Port",10,35,50)
GUICtrlSetFont(-1,9,800)
GUICtrlCreateLabel("Enter Number or use Up/Dn < > Arrow Keys" & @LF & _
"(Hold Down For Acceleration)" & @LF &  "< > Arrow Keys Adjust Slider",35,75,260,60)
GUICtrlSetFont(-1,9,800)
GUICtrlCreateLabel("Port",35,140,30)
GUICtrlSetFont(-1,9,800)
$label = GUICtrlCreateLabel("",65,140,500)
GUICtrlSetFont(-1,9,800)
;--------------------------------------------------

;---- SLIDER --------------------------------------
$slider=GUICtrlCreateSlider(120,30,400,40,$TBS_AUTOTICKS)
GUICtrlSetLimit($slider, 32767, -32768)
GUICtrlSetData($slider, -32768)
$sliderhwnd = GUICtrlGetHandle($slider)
_GUICtrlSliderSetLineSize($sliderhwnd, 1)
;_GUICtrlSliderSetPageSize($sliderhwnd, 10)
_GUICtrlSliderSetTicFreq($sliderhwnd, 1000)
;--------------------------------------------------

;---- INPUT0 DUMMY --------------------------------
 ; Dummy Input Control "Buddy" For GUICtrlCreateUpdown
$input0 = GUICtrlCreateInput("-32768", 95, 30, 20, 40, $ES_NUMBER)
GUICtrlSetLimit($input0,5)   ; to limit the entry to 5 chars
GUICtrlSetOnEvent($input0, "_Inputupdate0")
$input0hwnd = GUICtrlGetHandle($input0)
;--------------------------------------------------

;---- INPUT1 --------------------------------------
$input1 = GUICtrlCreateInput("-32768", 35, 30, 62, 40, $ES_NUMBER, $WS_EX_CLIENTEDGE )
GUICtrlSetLimit($input1,5)   ; to limit the entry to 5 chars
GUICtrlSetOnEvent($input1, "_Inputupdate1")
$input1hwnd = GUICtrlGetHandle($input1)

GUICtrlSetFont ($input1,12, 800, 1, $font)
GUICtrlSetColor($input1,0x00EEEE)    ; Cyan 0x00EEEE Yellow0xFFFF00
GUICtrlSetBkColor($input1,0x363636)  ; Gray 0x363636
;--------------------------------------------------

;---- UP/DN ---------------------------------------
$updown = GUICtrlCreateUpdown($input0,$UDS_NOTHOUSANDS+$UDS_ARROWKEYS)
GUICtrlSetPos($input0, 35,140, 80, 40 )
_GUICtrlUpdownSetAccel($updown,"0|2|5","1|10|200")
GUICtrlSetLimit($updown, 32767, -32768)
GUICtrlSetPos($input0, 95,30, 20, 40 )
;--------------------------------------------------

;---- Control Initialization ----------------------
$read = GUICtrlRead($slider) + 32768
GUICtrlSetData($input1, $read)
GUICtrlSetData($input0, - 32768)
$val=IniRead(@ScriptDir&"\db.ini","desc",$read,"None")
GUICtrlSetData($label,$read&" : "&$val)
;--------------------------------------------------

;--------------------------------------------------
GUIRegisterMsg($WM_HSCROLL, "WM_HVSCROLL")
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
GUISetState(@SW_SHOW)
;--------------------------------------------------

While 1
	Sleep(50000)
WEnd

Func _Exit()
    Exit
EndFunc

Func _Inputupdate0() ; UP/DN dummy GUICtrlCreateInput control
		Local $updnread = GUICtrlRead($input0) + 32768							; Read UP/DN
		Switch ControlGetHandle($gui, '', ControlGetFocus($gui)) 				; Control focus method from _CheckInput()
			Case $input0hwnd													; UDF by MsCreatoR
				 ConsoleWrite(' UP/DN '& $updnread &@crlf)		   		 		; $updnread Data
				 GUICtrlSetData($input1, $updnread)				   		 		; Write Input1
				 GUICtrlSetData($slider,$updnread - 32767)			   	 		; Write Slider
				 $val=IniRead(@ScriptDir&"\db.ini","desc", $updnread,"None")
				 GUICtrlSetData($label, $updnread &" : "&$val)					; Write label
		Endswitch
EndFunc

Func _Inputupdate1() ; Input - accepts entry 0 to 65535, no leading zeros (default to 0) 
	Local $iread = GUICtrlRead($input1) 										; Read Input
	Switch ControlGetHandle($gui, '', ControlGetFocus($gui))
		Case $input1hwnd
			 Switch $iread														; Number only input set by 
				Case 0 To 65535													; GUICtrlCreateInput $ES_NUMBER style
					 GUICtrlSetData($input1, $iread)				   		 	; Write Input1
				Case 65536 To 99999
					  $iread = 65535
					 GUICtrlSetData($input1, $iread)
			 EndSwitch
			 Switch  StringLeft($iread, 1)
				Case 0
					 $iread = 0
					 GUICtrlSetData($input1, $iread)
			 EndSwitch
					 ConsoleWrite(' Input1 '& $iread &@crlf)					; $iread Data
					 GUICtrlSetData($slider, $iread - 32767) 					; Write Slider
					 GUICtrlSetData($input0, $iread - 32768)
					 $val=IniRead(@ScriptDir&"\db.ini","desc", $iread ,"None")
					 GUICtrlSetData($label, $iread &" : "&$val)					; Write label
	Endswitch
EndFunc

Func WM_HVSCROLL($hWndGUI, $MsgID, $WParam, $LParam) 							; Slider
	Switch $LParam
		Case GUICtrlGetHandle($slider)
			  Local $slread = GUICtrlRead($slider) + 32768 						; Read Slider
			  ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Slider = ' & $slread & @crlf)
			  GUICtrlSetData($input0, $slread - 32768)
			  GUICtrlSetData($input1, $slread)									; Write Input1			
			  $val=IniRead(@ScriptDir&"\db.ini","desc", $slread ,"None")
			  GUICtrlSetData($label, $slread &" : "&$val)						; Write label
	EndSwitch
EndFunc

;===============================================================================
;
; Description:    _GUICtrlUpdownSetAccel
; Parameter(s):  $h_updown - updown controlID
;               $nSecList - "|" delimited list of nSec times (Default "0|2|5" )
;               $nIncList - "|" delimited list of nInc increment (Default "1|5|20" )
;                        after 0 seconds, updown increments by 1
;                        after 1 second, updown increments by 5
;                        after 5 seconds, updown increments by 20
; Requirement:    <GUIConstants.au3>
; Return Value(s):  Returns nonzero if successful, or zero otherwise.
;                     If an error occurs, the return value is $LV_ERR (-1) and @error is set to -1
; User CallTip:  _GUICtrlUpdownSetAccel ( $h_updown ) resets to default values in example above
;               _GUICtrlUpdownSetAccel ( $h_updown, "0", "10" ) makes the updown increment by 10 with no acceleration
;               _GUICtrlUpdownSetAccel ( $h_updown, "0|2", "1|10" ) makes the updown increment by 1. After 2 seconds, it increments by 10
; Author(s):        Chris Howes (OjO)
; Note(s):      $nSecList and $nIncList must have the same number of delimited values
;               $nSecList must be in increasing order ex: "0|7|8"  - using "0|8|7" would fail and return -1
;               string values in $nSecList and $nIncList must have integer value of 0 or greater
;
;===============================================================================
Func _GUICtrlUpdownSetAccel ( $h_updown = 0, $nSecList = "0|2|5", $nIncList = "1|5|20" ); 0|2|5 and 1|5|20 are default windows settings
    ;Global Const $UDM_SETACCEL = $WM_USER+107
    Local $nSecErr = 0
    Local $nSec = StringSplit ( $nSecList, "|" )
    Local $nInc = StringSplit ( $nIncList, "|" )
    Local $x = 0
   
    If $nSec[0] <> $nInc[0] Then Return SetError($CB_ERR,$CB_ERR,$CB_ERR);check for same # of nSec & nInc sets
    For $x = 1 to $nSec[0];check for non integers, and negative numbers, and zero length entries
        If StringIsInt ($nSec[$x]) = 0 Or Int ( $nSec[$x]) < 0 Or StringLen ( $nSec[$x] ) = 0 Then Return SetError($CB_ERR,$CB_ERR,$CB_ERR)
        If StringIsInt ($nInc[$x]) = 0 Or Int ( $nInc[$x]) < 0 Or StringLen ( $nInc[$x] ) = 0 Then Return SetError($CB_ERR,$CB_ERR,$CB_ERR)
    Next
    If $nsec[0] > 1 Then
        For $x = 2 To $nSec[0]
            If $nSec[$x] <= $nSec[$x-1] Then $nSecErr = 1;check for ascending order of nSec sequence
        Next
        If $nSecErr = 1 Then Return SetError($CB_ERR,$CB_ERR,$CB_ERR)
    EndIf
       
    Local $str = "uint;uint";create initial structure for set of nSec;nInc
    if $nsec[0] > 1 Then ;add more structure for additional entries
        For $x = 2 To $nSec[0]
            $str = $str & ";uint;uint"
        Next
    EndIf
    Local $AccelStruct = DllStructCreate ( $str )
   
    For $x = 1 To $nSec[0];Put Data in the structure
        DllStructSetData ( $AccelStruct, ($x * 2) - 1, Number ($nSec[$x]) )
        DllStructSetData ( $AccelStruct, ($x * 2), Number ($nInc[$x]) )
    Next
   
    If IsHWnd($h_updown) Then
        Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_updown, _
		"int", $UDM_SETACCEL, "int", $nSec[0], "ptr", DllStructGetPtr($AccelStruct))
        Return $a_ret[0]
    Else
        GUICtrlSendMsg($h_updown, $UDM_SETACCEL, $nSec[0], DllStructGetPtr ( $AccelStruct ))
    EndIf
EndFunc
