#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Openmmap()
HotKeySet("{F1}","fin")

$gui = GUICreate("simple mmap Read  - {F1} for QUIT", 650, 200, 0,0)
GUICtrlCreateLabel("Recept:",5,10,40,20)
$contenu=GUICtrlCreateEdit("",45,8,600,20)
GUICtrlCreateLabel("Histo:",5,40,40,20)
$histo=GUICtrlCreateEdit("",45,38,600,160)
GUISetState(@SW_SHOW)

While True
	$msg = GUIGetMsg()
	If $msg = $GUI_EVENT_CLOSE Then  ExitLoop

	$data=simplemmapread()
	If $data<>"" Then
		simplemmapwrite("")
		GUICtrlSetData($contenu,$data)
		GUICtrlSetData($histo,$data & @CRLF & GUICtrlRead($histo))
		If StringUpper($data)="END" Then ExitLoop
	EndIf
	Sleep(12)
WEnd
GUIDelete()
fin()
Exit




Func fin()
	HotKeySet("{F1}")

	DllCall($dll, "none", "Close")
	If @error Then
		MsgBox(0, "DLL error", "Close FALSE")
	EndIf
	DllClose($dll)
	If @error Then
		MsgBox(0, "Testing", "Error closing autoitmmap.dll")
	EndIf
	Exit
EndFunc   ;==>fin



Func Openmmap($NomMapObj="ammap")
	Global $dll,$read_string
	$dll = DllOpen("ammap.dll")
	If @error Then
		MsgBox(0, "Testing", "Error opening ammap.dll", 6)
		Exit
	EndIf
	DllCall($dll, "int", "Open", "str", $NomMapObj)
EndFunc   ;==>Openmmap


Func simplemmapwrite($data)
	DllCall($dll, "none", "SetSharedMem", "str", $data)
	If @error Then
		MsgBox(0, "DLL error", "Error calling SetSharedMem")
	EndIf
EndFunc   ;==>simplemmapwrite


Func simplemmapread()
	Local $ret,$vret,$long
	$read_string=" "
	$ret = DllCall($dll, "none", "GetSharedMem", "str", $read_string, "int", 32767)
	If @error Then
		MsgBox(0, "DLL error", "Error calling GetSharedMem")
	EndIf
	Return ($ret[1])
EndFunc   ;==>simplemmapread

