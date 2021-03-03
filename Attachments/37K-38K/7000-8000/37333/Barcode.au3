#cs
	Sample bar code reader.  As configured it reads the barcodes as
	found on common retail items sold in the U.S.A.  Other usages
	will requre different configuration settings.  The RoboRealm help page
	on barcodes can be found at http://www.roborealm.com/help/Barcode.php
	Presently one 2D format and several 1D barcode formats are available.

	RoboRealm available for download from http://www.RoboRealm.com
	30-day trial is free, $49 to continue use after that.

	Don't forget to regsvr32 RR_COM_API.dll before first use!
#ce

Opt("MustDeclareVars", 1)

Global $RR_Ver, $oCatchErr, $oRR, $Barcode, $LastBarcode, $ExecStr

; Define an executable string containing the program for RoboRealm to execute.
; This one configures the barcode reader and displays the barcode in the camera
; window. If you open a .robo file with a text editor you'll see a similar format.
$ExecStr = "<head><version>2.44.24</version></head>" & _
"<Barcode>" & _
"<check_ean_8>FALSE</check_ean_8>" & _
"<check_orientation>TRUE</check_orientation>" & _
"<check_ean_13>FALSE</check_ean_13>" & _
"<check_i2of5>FALSE</check_i2of5>" & _
"<check_code_128>FALSE</check_code_128>" & _
"<decoded_color_index>3</decoded_color_index>" & _
"<test_color_index>5</test_color_index>" & _
"<check_codabar>FALSE</check_codabar>" & _
"<require_crc>FALSE</require_crc>" & _
"<check_upc_e>TRUE</check_upc_e>" & _
"<check_upc_a>TRUE</check_upc_a>" & _
"<check_maxicode>FALSE</check_maxicode>" & _
"<check_code_39>FALSE</check_code_39>" & _
"</Barcode>" & _
"<Display_Variables>" & _
"<display_as_annotation>FALSE</display_as_annotation>" & _
"<font_size_index>2</font_size_index>" & _
"<display_value_only>FALSE</display_value_only>" & _
"<dim_background>TRUE</dim_background>" & _
"<border_color_index>5</border_color_index>" & _
"<northwest>BARCODE" & _
"</northwest>" & _
"</Display_Variables>"

$Barcode = ""
$LastBarcode = ""

; Prepare to trap any COM errors
$oCatchErr = ObjEvent("AutoIt.Error", "ErrHandler")

; Get RoboRealm COM object
$oRR = ObjCreate("RoboRealm.API.1")
If (@error <> 0) Then
	MsgBox(16, "Error creating COM object", "Unable to create RoboRealm.API.1")
	Exit
EndIf

; Run RoboRealm if not already running
$oRR.Open("C:\Program Files\RoboRealm\RoboRealm.exe", 6060)

; Wait until RoboRealm is executing
If (ProcessWait("RoboRealm.exe", 5) = 0) Then
	MsgBox(16,"Missing process","RoboRealm.exe failed to load.")
	Exit
EndIf

; Attempt connection to RoboRealm
If ($oRR.connect("localhost") = 0) Then
	MsgBox(16, "Connection Error", "Unable to connect to server")
	Exit
EndIf

HotKeySet("^z", "DoTerminate") ; Control-z to terminate this program and RoboRealm

; Set up RoboRealm to read and display barcodes.  If we'd done this from a .robo
; file I'd have used $oRR.LoadProgram(@DesktopDir & "\Barcode.robo") instead.
$oRR.Execute($ExecStr)

TrayTip("Barcode Reader", "Barcode reader is running.", 30, 1)

; Display barcodes as tooltips until the user hits ctrl-z
While (1)
	$oRR.WaitImage
	$Barcode = $oRR.GetVariable("BARCODE")
	; Skip it if barcode is blank
	If ($Barcode = "") Then
		ContinueLoop
	EndIf
	; Display barcode only if it's different from the last one
	If ($Barcode <> $LastBarcode) Then
		$LastBarcode = $Barcode
		TrayTip("Barcode", $Barcode, 30, 1)
	EndIf
WEnd

Func DoTerminate()
	$oRR.Close
	Exit
EndFunc

Func ErrHandler()
	Local $HexNumber
	$HexNumber = Hex($oCatchErr.number, 8)
	MsgBox(16, "COM Error", "Number is: " & $HexNumber & @CRLF & _
			"Windescription is: " & $oCatchErr.windescription)
EndFunc   ;==>ErrHandler

