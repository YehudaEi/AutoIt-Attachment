; A simple custom messagebox that uses the OnEvent mode

#include <GUIConstantsEx.au3>

Opt('MustDeclareVars', 1)
Opt("GUIOnEventMode", 1)

Global $ExitID

_Main()

Func _Main()
	Local $OnPDF, $OnAbout, $OnInstall

GuiCreate("Welcome To My Installer", 828, 562)
GuiSetIcon(@SystemDir & "\mspaint.exe", 0)

	$OnPDF = GuiCtrlCreatePic("images\learn.gif", 120, 276, 99, 20)
	GUICtrlSetOnEvent($OnPDF, "OnPDF")
	$OnPDF = GuiCtrlCreatePic("images\learn.gif", 324, 276, 99, 20)
	GUICtrlSetOnEvent($OnPDF, "OnPDF")
	$OnPDF = GuiCtrlCreatePic("images\learn.gif", 529, 276, 99, 20)
	GUICtrlSetOnEvent($OnPDF, "OnPDF")

	$OnPDF = GuiCtrlCreatePic("images\unified.gif",112, 300, 200, 69)
	GUICtrlSetOnEvent($OnPDF, "OnPDF")
	$OnPDF = GuiCtrlCreatePic("images\backup.gif", 315, 300, 200, 69)
	GUICtrlSetOnEvent($OnPDF, "OnPDF")
	$OnPDF = GuiCtrlCreatePic("images\content.gif", 519, 300, 200, 69)
	GUICtrlSetOnEvent($OnPDF, "OnPDF")

	$OnPDF = GuiCtrlCreatePic("images\tutorial.gif", 113, 515, 113, 25)
	GUICtrlSetOnEvent($OnPDF, "OnPDF")
	$OnPDF = GuiCtrlCreatePic("images\license.gif", 244, 519, 167, 21)
	GUICtrlSetOnEvent($OnPDF, "OnPDF")
	$OnAbout = GuiCtrlCreatePic("images\about.gif", 439, 510, 201, 39)
	GUICtrlSetOnEvent($OnAbout, "OnAbout")

	$OnInstall = GuiCtrlCreateButton("Install", 650, 515, 100, 30)
	GUICtrlSetOnEvent($OnInstall, "OnInstall")


GUISetOnEvent($GUI_EVENT_CLOSE, "OnExit")

	GUISetState()  ; display the GUI

GuiCtrlCreatePic("images\bg.gif",0,0, 828,562)
GuiCtrlSetColor(-1,0xffffff)

	While 1
		Sleep(1000)
	WEnd
EndFunc   ;==>_Main

;--------------- Functions ---------------
Func OnPDF()
	ShellExecute("PDFReader.exe", "test.pdf")
	Exit
EndFunc   ;==>OnPDF

Func OnAbout()
	MsgBox(0, "About Installer", "Prototype Version 2")
EndFunc   ;==>OnAbout

Func OnInstall()
	ShellExecute("Install.exe")
	Exit
EndFunc   ;==>OnRun

Func OnExit()
	If @GUI_CtrlId = $ExitID Then
		MsgBox(0, "", "Thank you for using Installer")
	Else
		MsgBox(0, "", "Thank you for using Installer")
	EndIf

	Exit
EndFunc   ;==>OnExit
