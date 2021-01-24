
#include <GuiConstantsEx.au3>
#include <ServiceControl.au3>
#include <String.au3>

Const $ForReading = 0
Const $ForWriting = 2
Const $ForAppending = 1

Global $type = "Process"
Global $pslist = @ComSpec & ' /c "' & @ScriptDir & '\pslist.exe"'
Global $pskill = @ScriptDir & "\pskill.exe"
Global $psservice = @ComSpec & ' /c "' & @ScriptDir & '\psservice.exe"'
Dim $pscommand, $psfileread, $pskill, $pslist
Dim $ComputerName, $CheckType, $ProcessCtrl, $ServiceCtrl, $GoButton, $ItemCtrl, $ActionInput, $listView
$ComputerName = @ComputerName

; GUI
GUICreate("Remote Process Manager", 400, 400)

; LABEL
GUICtrlCreateLabel("Computer Name :", 5, 8, 48, 40)

; INPUT
$CNameInput = GUICtrlCreateInput($ComputerName, 55, 10, 130, 22)

; LABEL
GUICtrlCreateLabel("Select type :", 200, 8, 48, 40)
; COMBO
$CheckType = GUICtrlCreateCombo(" ", 250, 10, 120, 100)
GUICtrlSetData(-1, "Process")
GUICtrlSetData(-1, "Service")

$Tinput = GUICtrlCreateInput("", 130, 45, 180, 22)
GUICtrlSetState(-1, $GUI_DROPACCEPTED) ; to allow drag and dropping

; BUTTON
$GoButton = GUICtrlCreateButton("Go", 340, 340, 40, 30)
GUISetState(@SW_SHOW)

; GUI MESSAGE LOOP
While GUIGetMsg() <> $GUI_EVENT_CLOSE
	$Msg = GUIGetMsg()
	
	Select
		Case $Msg = $CheckType
			GUICtrlDelete($ActionInput)
			$ActionInput = GUICtrlCreateCombo(" ", 5, 45, 120, 100)
			$type = GUICtrlRead($CheckType)
			Select
				Case $type = "Process"
					GUICtrlSetData($ActionInput, "|Search For|Kill", "Search For")
				Case $type = "Service"
					GUICtrlSetData($ActionInput, "|Search For|Stop|Start|Restart|Disable|Enable", "Search For")
			EndSelect
		Case $Msg = $GoButton
			$type = GUICtrlRead($CheckType)
			Select
				Case $type = "Process"
					ProType()
				Case $type = "Service"
					SerType()
			EndSelect
			
	EndSelect

WEnd

Func ProType()
	$ComputerName = GUICtrlRead($CNameInput)
	$Action = GUICtrlRead($ActionInput)
	$Target = GUICtrlRead($Tinput)
	$Result = "Process Not Found"
	$PID = "NA"
	$i = 3
	GUICtrlDelete($listView)
	; LIST VIEW
	$listView = GUICtrlCreateListView("Target|ID|Result", 5, 75, 305, 300)
	Select
		Case $Action = "Search For"
			$pscommand = $pslist & " \\" & $ComputerName & " " & $Target & " > pslist.txt"
			RunWait($pscommand, "", @SW_HIDE)
			$pslistfile = FileOpen("pslist.txt", $ForReading)
			$psfileread = FileRead($pslistfile)
			$pslistfound = StringInStr($psfileread, "CPU Time")
			If $pslistfound > 0 Then
				$Result = "Process Exists"
				Do
					$i = $i + 1
					$line = FileReadLine($pslistfile, $i)
					If @error = -1 Then ExitLoop
					;MsgBox(0,"File Line",$line)
					Do
						$line = StringReplace($line, "  ", " ")
					Until @extended = 0
					
					$lineitems = StringSplit($line, " ")
					GUICtrlCreateListViewItem($lineitems[1] & "|" & $lineitems[2] & "|" & $Result, $listView)
				Until @error = -1
			Else
				GUICtrlCreateListViewItem($Target & "|" & $PID & "|" & $Result, $listView)
			EndIf
			
		Case $Action = "Kill"
			$prokill = ShellExecuteWait($pskill, "\\" & $ComputerName & " -t " & $Target, "", "", @SW_HIDE)
			If $prokill = 0 Then
				$Result = "Process killed"
			Else
				$Result = $prokill
			EndIf
			GUICtrlCreateListViewItem($Target & "|" & $PID & "|" & $Result, $listView)
	EndSelect
	
EndFunc   ;==>ProType

Func SerType()
	$ComputerName = GUICtrlRead($CNameInput)
	$Action = GUICtrlRead($ActionInput)
	$Target = GUICtrlRead($Tinput)
	$State = "Service Not Found"
	$DisplayName = "NA"
	$i = 0
	GUICtrlDelete($listView)
	; LIST VIEW
	$listView = GUICtrlCreateListView("Service Name|Display Name|State", 5, 75, 305, 300)
	Select
		Case $Action = "Search For"
			$pscommand = $psservice & " \\" & $ComputerName & " query " & $Target & " >psservice.txt"
			$psaction = RunWait($pscommand, "", @SW_HIDE)
		Case $Action = "Stop"
			$pscommand = $psservice & " \\" & $ComputerName & " stop " & $Target & " >psservice.txt"
			$psaction = RunWait($pscommand, "", @SW_HIDE)
		Case $Action = "Start"
			$pscommand = $psservice & " \\" & $ComputerName & " start " & $Target & " >psservice.txt"
			$psaction = RunWait($pscommand, "", @SW_HIDE)
		Case $Action = "Restart"
			$pscommand = $psservice & " \\" & $ComputerName & " restart " & $Target & " >psservice.txt"
			$psaction = RunWait($pscommand, "", @SW_HIDE)
		Case $Action = "Disable"
			$pscommand = $psservice & " \\" & $ComputerName & " setconfig " & $Target & " disabled >psservice.txt"
			$psaction = RunWait($pscommand, "", @SW_HIDE)
		Case $Action = "Enable"
			$pscommand = $psservice & " \\" & $ComputerName & " setconfig " & $Target & " auto >psservice.txt"
			$psaction = RunWait($pscommand, "", @SW_HIDE)
	EndSelect
	
	$pslistfile = FileOpen("psservice.txt", $ForReading)
	$psfileread = FileRead($pslistfile)
	$pslistfound = StringInStr($psfileread, "DISPLAY_NAME")
	If $pslistfound > 0 Then
		$Result = "Service Found"
		$State = ""
		Do
			$i = $i + 1
			$line = FileReadLine($pslistfile, $i)
			If @error = -1 Then ExitLoop
			;MsgBox(0,"File Line",$line)
			$line = StringReplace($line, @TAB, " ")
			Do
				$line = StringReplace($line, "  ", " ")
			Until @extended = 0
			$line = StringReplace($line, " ", ",")
			;MsgBox(0, "Line", $line)
			$lineitems = StringSplit($line, ",")
			If $lineitems[0] > 1 Then
				Select
					Case $lineitems[1] = "Service_Name:"
						$ServiceName = $lineitems[2]
					Case $lineitems[1] = "Display_Name:"
						$DisplayName = ""
						For $items = 2 To $lineitems[0]
							$DisplayName = $DisplayName & " " & $lineitems[$items]
						Next
						If StringLeft($DisplayName, 1) = " " Then
							$DisplayName = StringTrimLeft($DisplayName, 1)
						EndIf
					Case $lineitems[2] = "STATE"
						$State = $lineitems[5]
				EndSelect
			EndIf
			If $State <> "" Then
				GUICtrlCreateListViewItem($ServiceName & "|" & $DisplayName & "|" & $State, $listView)
				$State = ""
			EndIf
		Until @error = -1
	Else
		GUICtrlCreateListViewItem($Target & "|" & $DisplayName & "|" & $State, $listView)
	EndIf
	
EndFunc   ;==>SerType