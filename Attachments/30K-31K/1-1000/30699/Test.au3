; ***************************************************************
; Example 1 - Open an existing workbook and returns its object identifier.
; *****************************************************************

#include <Excel.au3>
#include <GUIConstantsEx.au3>
#include <Misc.au3>
#include <Array.au3>

 Opt("GUIOnEventMode", 1)
 ;Opt("GUICoordMode", 2)

$sFilePath1 = @DesktopDir & "\AllStreamDetails.xls" ;This file should already exist
$oExcel = _ExcelBookOpen($sFilePath1)

If @error = 1 Then
	MsgBox(0, "Error!", "Unable to Create the Excel Object")
	Exit
ElseIf @error = 2 Then
	MsgBox(0, "Error!", "File does not exist - Shame on you!")
	Exit
EndIf


    local $readedit,$mylist,$setvaluebuttn,$exitappbuttn
	Global $currentlistselection,$hCombo
	Global $redvalue = String(3)

createGUI()
	Func createGUI()
	$hGUI = GUICreate("Input",350,150)

	GUICtrlCreateLabel("Enter the Row Number of the stream to be loaded :",10,20,250,75)
	$readedit = GUICtrlCreateInput(" ",270,15,75,20)
	GUICtrlCreateLabel("Select the Frequency to be set from the list:",10,50,250,75)
	$hCombo = GUICtrlCreateCombo("473", 270, 50, 75, 20)
	GUICtrlSetData(-1, "479|485|491|497|503|509|515|521|527|533|539|545|551|557|563|569|575|581|587|593|599|605|611|617|623|629|635|641|647|653|659|665|671|677|683|689|695|701|707|713|719|725|731|743|749|755|761|767", "") ; add other item snd set a new default
	$setvaluebuttn = GUICtrlCreateButton("Set Value",90,95,70)
	;GUISetOnEvent(-1,"validate")
	$exitappbuttn = GUICtrlCreateButton("Exit",190,95,70)
	GUISetState()
	GUISetState(@SW_SHOW)
	EndFunc
	;Sleep(9000)

	Func validate()

	$redvalue = GUICtrlRead($readedit)
	If(Int($redvalue)) Then
	    setvalue()
	Else
        MsgBox(16, "Error", "Please enter numeric values only")
		GUICtrlSetData($readedit,"")
    EndIf
    EndFunc


	Func setvalue()

	 If GUICtrlRead($hCombo) <> $currentlistselection Then
        ; Set new selection value
        $currentlistselection = GUICtrlRead($hCombo)
		MsgBox(0, "", "The Cell Value is: " & @CRLF & $currentlistselection, 2)
    EndIf

		 ;Activates the alreay opened Dektec application
		 WinActivate("DekTec StreamXpress - Transport-Stream Player")

		 ;Moves the application to screen co-ordinates to 0,0
		 WinMove("DekTec StreamXpress - Transport-Stream Player", "", 0, 0)
		 Sleep(1000)
		 $sCellValue = _ExcelReadCell($oExcel, $redvalue, 3)
		 MsgBox(0, "", "The Cell Value is: " & @CRLF & $sCellValue, 2)

		 local $getstreamervalue
		 $getstreamervalue = ControlGetText("DekTec StreamXpress - Transport-Stream Player", "", "Edit1")
		 MsgBox(0, "", "The Cell Value is: " & @CRLF & $getstreamervalue, 2)

		 local $setstream
		 $setstream  = 	ControlSetText ( "DekTec StreamXpress - Transport-Stream Player", " ", "Edit1", $sCellValue)
		 WinActivate("DekTec StreamXpress - Transport-Stream Player")
		 ControlClick("DekTec StreamXpress - Transport-Stream Player", "", "Button21","left",2)
		 sleep(3000)
		 ControlClick("DekTec StreamXpress - Transport-Stream Player", "", "Button19","left",2)

	EndFunc




		; Run the GUI until the dialog is closed
	While 1
		$msg = GUIGetMsg()

		If $msg = $GUI_EVENT_CLOSE Then ExitLoop
    WEnd








