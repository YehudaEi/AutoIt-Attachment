#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=icon.ico
#AutoIt3Wrapper_outfile=D:\Unlimited Projects\Tools\iChecker\iChecker.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseAnsi=y
#AutoIt3Wrapper_Res_Comment=                       
#AutoIt3Wrapper_Res_Description=Yahoo ! Messenger user availability check Tool
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
#AutoIt3Wrapper_Res_LegalCopyright=iuli_kyle
#AutoIt3Wrapper_Res_Field=Made by| iuli_kyle
#AutoIt3Wrapper_Run_AU3Check=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;AutoIt Version: 3.2.8.0
;Author: iuli_kyle

;Script Function: This tool informs you if a user is online, while he/she 
;                 may appear as ofline into you Messenger list.

#include <GUIConstants.au3>
#include <Misc.au3>
FileInstall("ICL.jpg",@ScriptDir & "\ICL.jpg")
$iChecker = GUICreate("iChecker by iuli_kyle", 211, 135, 221, 209)
GUICtrlCreatePic("ICL.jpg",0,0,211,47)
$on_off=GUICtrlCreatePic("",190,73,20,20)
GUISetIcon("icon.ico")
$ID = GUICtrlCreateInput("", 16, 72, 169, 21)
$Check = GUICtrlCreateButton("Check !", 16, 104, 65, 25, 0)
$Exit = GUICtrlCreateButton("Exit", 112, 104, 73, 25, 0)
GUICtrlCreateLabel("Enter the Yahoo ! ID here :", 32, 53, 131, 17)
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Select
		Case $nMsg=$GUI_EVENT_CLOSE or $nMsg=$Exit
			FileDelete("ICL.jpg")
			FileDelete("yahoo.gif")
			FileDelete("on.jpg")
			FileDelete("off.jpg")
			Exit
		Case $nMsg=$Check or _IsPressed("0D")
			If GuiCtrlRead($ID)="" Then
				MsgBox(0,"Error !", "Please enter an ID !")
			Else
				InetGet("                              " & GuiCtrlRead($ID), @scriptdir & "\yahoo.gif", 1)
				If FileGetSize(@scriptdir & "\yahoo.gif") = 140 Then
					GuiCtrlSetImage($on_off,"")
					FileInstall("on.jpg",@ScriptDir & "\on.jpg")
					GuiCtrlSetImage($on_off,"on.jpg")
					Msgbox(64,"Status",GuiCtrlRead($ID) & " is online !")
				ElseIf FileGetSize(@scriptdir & "\yahoo.gif") = 84 Then
					GuiCtrlSetImage($on_off,"")
					FileInstall("off.jpg",@ScriptDir & "\off.jpg")
					GuiCtrlSetImage($on_off,"off.jpg")
					Msgbox(64,"Status",GuiCtrlRead($ID) & " is offline !")
				EndIf
			EndIf	
	EndSelect
WEnd
