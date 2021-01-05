; Name of Utility : 	_beer.exe					; Nom de l'utilitaire : 	_beer.exe
; Version : 			v1.0.201.alpha				; Version : 				v1.0.201.alpha
; Langage : 			English						; Langue : 					Francais
; Author : 				Xavier Brusselaers			; Auteur : 					Xavier Brusselaers
; License : 			Global Public License (GPL)	; License : 				License Globale Publique (GPL)
; Requirement : 		None						; Dépendance : 				Aucune

Global $Lang = IniRead("beer.ini", "setting", "Lang", "")
Global $History = @ScriptDir & "\" & IniRead("beer.ini", "setting", "SciTe_Recent", "")
Global $Session = @ScriptDir & "\" & IniRead("beer.ini", "setting", "SciTe_Session", "")

#include <GUIConstants.au3>

GUICreate("_beer", 140, 90, -1, -1, $WS_POPUP + $WS_BORDER)
	GUISetState (@SW_SHOW)
Dim $bt_History, $bt_Session
$bt_History = GUICtrlCreateButton("Supprimer historique", 10, 10, 120, 30, $BS_FLAT)
$bt_Session = GUICtrlCreateButton("Supprimer session", 10, 50, 120, 30, $BS_FLAT)
	
While 1
    Dim $Gui = GUIGetMsg()
    If $Gui = $GUI_EVENT_CLOSE Then 
		GUIDelete()
		ExitLoop
	ElseIf $Gui = $bt_History Then
		GUIDelete()
		_CheckFile($History)
	ElseIf $Gui = $bt_Session Then
		GUIDelete()
		_CheckFile($Session)
	EndIf
Wend

Func _CheckFile($v_File)
	If FileExists($v_File) Then
		_DelContent($v_File)
	Else
		MsgBox(0 + 64, IniRead("beer.ini", $Lang, "MsgBox1_Title", ""), IniRead("beer.ini", $Lang, "MsgBox1_Msg", ""), 10)
		Exit
	EndIf
EndFunc

Func _DelContent($v_FileToContent)
	Dim $FileOpen
	Local $FileOpen
	ProgressOn(IniRead("beer.ini", $Lang, "ProgressOn_Title", ""), IniRead("beer.ini", $Lang, "ProgressOn_Main", ""), IniRead("beer.ini", $Lang, "ProgressOn_Sub", ""), -1, -1, 1 + 2 + 16)
		Sleep(250)
		WinActivate(IniRead("beer.ini", $Lang, "ProgressOn_Title", ""))
	ProgressSet(25, IniRead("beer.ini", $Lang, "ProgressSet_25_Sub", ""), IniRead("beer.ini", $Lang, "ProgressSet_25_Main", ""))
		Sleep(250)
	ProgressSet(50, IniRead("beer.ini", $Lang, "ProgressSet_50_Sub", ""), IniRead("beer.ini", $Lang, "ProgressSet_50_Main", ""))
		Sleep(250)
	$FileOpen = FileOpen($v_FileToContent, 2)
	ProgressSet(75, IniRead("beer.ini", $Lang, "ProgressSet_75_Sub", ""), IniRead("beer.ini", $Lang, "ProgressSet_75_Main", ""))
		Sleep(250)
	If $FileOpen = -1 Then
		ProgressSet(100, IniRead("beer.ini", $Lang, "Progress_Error_Sub", ""), "Progress_Error_Main")
			Sleep(100)
		ProgressOff()
		MsgBox(0 + 16, IniRead("beer.ini", $Lang, "MsgBox2_Title", ""), IniRead("beer.ini", $Lang, "MsgBox2_Msg1", "") & _
				@CRLF & IniRead("beer.ini", $Lang, "MsgBox2_Msg2", ""), 10)
		Exit
	EndIf
	ProgressSet(99, IniRead("beer.ini", $Lang, "ProgressSet_99_Sub", ""), IniRead("beer.ini", $Lang, "ProgressSet_99_Main", ""))
		Sleep(250)
	ProgressSet(100, IniRead("beer.ini", $Lang, "ProgressSet_100_Sub", ""), IniRead("beer.ini", $Lang, "ProgressSet_100_Main", ""))
		Sleep(100)
	ProgressOff()
	FileClose($FileOpen)
	Exit
EndFunc