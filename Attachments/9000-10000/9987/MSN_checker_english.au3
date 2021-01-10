#NoTrayIcon
#include <GUIConstants.au3>

Global $Contacts = ""
Dim $ListData

$GUI = GUICreate("MSN Check", 300, 420, -1, -1)
$List = GUICtrlCreateListView("               Contact               | Status |", 10, 10, 280, 350)
$Progress = GUICtrlCreateProgress(10, 362, 280, 10)
$Refresh = GUICtrlCreateButton("Refresh", 20, 374, 120, 20)
$Exit = GUICtrlCreateButton("Quit", 155, 374, 120, 20)
$Import = GUICtrlCreateMenuitem("&Import contact list", -1)
$About = GUICtrlCreateMenuitem("&About", -1)
GUISetState()

While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Exit
			Exit
		Case $Import
			_Import()
		Case $Refresh
			_Refresh()
		Case $About
			_About()
	EndSwitch		
WEnd

Func _Exit()
	Exit
EndFunc
Func _Import()
	$Contacts = ImportContacts()
	SetListData($Contacts)
	_Progress(0,0)
EndFunc
Func _Refresh()
	SetListData($Contacts)
	_Progress(0,0)
EndFunc
Func _About()
	MsgBox(0, "MSN Check",  "MSN Check" & @CRLF & _
							"2006 by CoePSX" & @CRLF & _
							@CRLF & _
							"Using Triople online!")
EndFunc
Func ImportContacts()
	$File = FileOpenDialog("Import contact from file", "", "Contacts (*.ctt)", 1)
	If Not @error Then
		$Read = FileRead($File, FileGetSize($File))
		$Exp = StringRegExp($Read, "(?i)(<contact>\S+</contact>)", 3)
		If IsArray($Exp) Then
			For $i = 0 To UBound($Exp)-1
				$Exp[$i] = StringReplace(StringReplace($Exp[$i], "<contact>", ""), "</contact>", "")
			Next
			Return ($Exp)
		EndIf
	EndIf
	Return (0)
EndFunc
Func SetListData($lData)
	GUICtrlSetState($Refresh, $GUI_DISABLE)
	GUICtrlSetState($Import, $GUI_DISABLE)
	GUICtrlSetState($About, $GUI_DISABLE)
	If IsArray($ListData) Then
		For $i = 0 To UBound($ListData)-1
			GUICtrlDelete($ListData[$i])
		Next
	EndIf
	$ListData = 0
	Dim $ListData[1]
	If IsArray($lData) Then
		For $i = 0 To UBound($lData)-1
			_Progress($i, UBound($lData)-1)
			ReDim $ListData[UBound($ListData)+1]
			$ListData[UBound($ListData)-1] = GUICtrlCreateListViewItem($lData[$i] & "|" & CheckStatus($lData[$i]), $List)
			If GUIGetMsg() = $Exit Or GUIGetMsg() = $GUI_EVENT_CLOSE Then Exit
		Next
	EndIf
	GUICtrlSetState($Refresh, $GUI_ENABLE)
	GUICtrlSetState($Import, $GUI_ENABLE)
	GUICtrlSetState($About, $GUI_ENABLE)
EndFunc
Func CheckStatus($sContact)
	$ImgSize = InetGetSize("                                   " & $sContact & "/standard.png")
	If $ImgSize = 898 Then
		Return ("Online")
	ElseIf $ImgSize = 867 Then
		Return ("Offline")
	Else
		Return ("Unknown")
	EndIf
EndFunc
Func _Progress($iNow, $iTotal)
	GUICtrlSetData($Progress, (100/$iTotal)*$iNow)
EndFunc	