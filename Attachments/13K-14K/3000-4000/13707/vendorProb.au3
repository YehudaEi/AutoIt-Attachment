
#include <GuiConstants.au3>
#include <file.au3>
#include <array.au3>

Dim $strComputer, $askmachine, $Label_2, $Label_3, $Edit_3, $Button_4, $Button_5, $Button_6, $colItems, $gui, $aRecords, $lala, $lolo

$strComputer = ""
$select = ""

GuiCreate("VendorProb", 395, 295,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))

$Radio_1 = GuiCtrlCreateRadio("Several Hosts", 10, 10, 100, 20)
$Radio_2 = GuiCtrlCreateRadio("One Host", 10, 30, 100, 20)
$askmachine = GUICtrlCreateDummy()
$Label_2 = GUICtrlCreateDummy()
$Edit_3 = GuiCtrlCreateEdit("", 10, 150, 370, 130)
$Button_4 = GuiCtrlCreateButton("Scan", 150, 20, 60, 30)
$Button_5 = GuiCtrlCreateButton("Exit", 310, 20, 60, 30)
$Button_7 = GuiCtrlCreateButton("Help", 310, 60, 60, 30)
$Button_6 = GUICtrlCreateDummy()

GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $Button_5
			Exitn()
		Case $msg = $Button_7
			Help()
		Case $msg = $Button_4
			Select
				case $select = "many"
					$status = $aRecords
					If $status = "" Then
						ContinueLoop
					EndIf
					prescanmany()
				case $select= "one"
					$Status = GUICtrlRead($askmachine)
					If $status = "" Then
						ContinueLoop
					EndIf
					prescanone()
			EndSelect
		Case $msg = $Button_6
			file()	
		Case $msg = $radio_2 And BitAND(GUICtrlRead($radio_2), $GUI_CHECKED) = $GUI_CHECKED
				$select = "One"
				GUICtrlDelete($Button_6)
				GUICtrlDelete($Label_3)
				$askmachine = GuiCtrlCreateInput("", 40, 105, 150, 20)
				$Label_2 = GuiCtrlCreateLabel("Server Name", 10, 80, 80, 20)
				GuiSetState()
			Case $msg = $radio_1 And BitAND(GUICtrlRead($radio_1), $GUI_CHECKED) = $GUI_CHECKED
				$select = "many"
				GUICtrlDelete($askmachine)
				GUICtrlDelete($Label_2)
				$Label_3 = GuiCtrlCreateLabel("Locate Host File", 10, 80, 150, 20)
				$Button_6 = GuiCtrlCreateButton("Host File", 40, 105, 150, 20)
				GuiSetState()
	EndSelect
WEnd

Func prescanmany()
	If $status = "" Then
		MsgBox(0, "error", "Choose host file")
		Return
	EndIf
	Scanmany()
EndFunc

Func prescanone()
	If $status = "" Then
		MsgBox(0, "error", "Type a server name")
		Return
	EndIf
	Scanone()
EndFunc

Func scanmany()

$temp = UBound($status)-1
$lolo = @TempDir & "\temp.txt"
_FileCreate ( $lolo )

for $x = 1 to UBound($status, 1)-1

	$wbemFlagReturnImmediately = 0x10
	$wbemFlagForwardOnly = 0x20
	$colItems = ""

	$strComputer = $status[$x]

	$Output=""
	$Output = $Output & "Server: " & $strComputer  & @CRLF
	$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
		If $objWMIService = 0 Then
			MsgBox(0, "Error", "Server : " & $strComputer & " not found or misspell")
			FileDelete($lolo)
			ExitLoop
		EndIf
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_ComputerSystemProduct", "WQL", _
                                          $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
				
	If IsObj($colItems) then
		For $objItem In $colItems
			$Output = $Output & @CRLF
			$Output = $Output & "Vendor: " & $objItem.Vendor & @CRLF
			$Output = $Output & "Model: " & $objItem.Name & @CRLF
			$Output = $Output & "Serial Number: " & $objItem.IdentifyingNumber & @CRLF
			$Output = $Output & @CRLF
			FileWrite($lolo, $Output)

		Next
	ConsoleWrite($Output)
	Else
	Msgbox(0,"WMI Output","No WMI Objects Found. Check WMI for Server: " & $strComputer )
	Endif
Next
	$lala = FileRead($lolo)
	GUICtrlSetData($Edit_3, $lala)
Return

EndFunc

Func file();Opens Host File and removes empty lines
	$host = FileOpenDialog("Host file location", @DesktopDir, "(*.txt)", 8+2)
		if @error = 1 Then
			$host = 0
			Return
		EndIf
	_FileReadToArray($host,$aRecords)
	while 1
		$newvar = _ArraySearch($aRecords, "", 0, 0, 0, false)
		if @error = 6 Then
			ExitLoop
		Else
			_ArrayDelete($aRecords, $newvar)
		EndIf
	wend
	$totalservers = UBound ( $aRecords )-1
	Return
EndFunc

Func scanone()

	$wbemFlagReturnImmediately = 0x10
	$wbemFlagForwardOnly = 0x20
	$colItems = ""

	$strComputer = $status

	$Output=""
	$Output = $Output & "Server: " & $strComputer  & @CRLF
	$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
		If $objWMIService = 0 Then
			MsgBox(0, "Error", "Server : " & $strComputer & " not found or misspell")
			Return
		EndIf
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_ComputerSystemProduct", "WQL", _
                                          $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
				
	If IsObj($colItems) then
		For $objItem In $colItems
			$Output = $Output & @CRLF
			$Output = $Output & "Vendor: " & $objItem.Vendor & @CRLF
			$Output = $Output & "Model: " & $objItem.Name & @CRLF
			$Output = $Output & "Serial Number: " & $objItem.IdentifyingNumber & @CRLF

		Next
	ConsoleWrite($Output)
	Else
	Msgbox(0,"WMI Output","No WMI Objects Found. Check WMI for Server: " & $strComputer )
	Endif
GUICtrlSetData($Edit_3, $Output)
Return

EndFunc

Func help()
	$help = MsgBox(64, "HELP"," VendorProb 1.1 " & @LF & "" & @LF & "Queries the Vendor, Model and S/N " & @LF & "" & @LF & "November 2007" & @LF & "Designed for Free use")
	GUICtrlSetBkColor($help,0xD3D3D3)
	Return
EndFunc

Func exitn()
	FileDelete($lolo)
	Exit
EndFunc