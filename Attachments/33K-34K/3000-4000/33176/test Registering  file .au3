#NoTrayIcon
#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=..\..\Setup\Icons\ico_cmmon32_exe0001.ico
#AutoIt3Wrapper_outfile=ocx_dll fileRegister.exe
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.6.0
	Author:         Anil Chauhan

	Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <process.au3>
#include <file.au3>


#region ### START Koda GUI section ### Form=G:\AU3 PROJECTS\Register files\Registering files1.kxf

$Form1_1 = GUICreate("Register Files", 283, 217, 590, 277)
GUISetFont(14, 400, 0, "MS Sans Serif")
GUISetBkColor(0x00FFFF)
$Button1 = GUICtrlCreateButton("Register", 8, 114, 131, 41, BitOR($BS_DEFPUSHBUTTON, $WS_GROUP))
GUICtrlSetCursor(-1, 0)
$Label3 = GUICtrlCreateLabel("© Anil Chauhan Ver:1.0.0.1", 62, 182, 162, 23)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlSetCursor(-1, 0)
$Label2 = GUICtrlCreateLabel("Locate your files required for registering", 8, 16, 190, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Arial Narrow")
$workfileDIR = GUICtrlCreateInput("", 8, 40, 233, 31)
GUICtrlSetFont(-1, 14, 800, 0, "Arial Narrow")
GUICtrlSetBkColor(-1, 0xA6CAF0)
GUICtrlSetState(-1, $GUI_DISABLE)
$Input2 = GUICtrlCreateInput("", 8, 74, 265, 31)
GUICtrlSetFont(-1, 14, 800, 0, "Arial Narrow")
GUICtrlSetBkColor(-1, 0xA6CAF0)
GUICtrlSetState(-1, $GUI_DISABLE)
$fileBrowseB = GUICtrlCreateButton("«v»", 238, 38, 35, 31, $WS_GROUP)
GUICtrlSetCursor(-1, 0)
$Button3 = GUICtrlCreateButton("Un-Register", 144, 113, 131, 41, BitOR($BS_DEFPUSHBUTTON, $WS_GROUP))
GUICtrlSetCursor(-1, 0)
GUISetState(@SW_SHOW)


#endregion ### END Koda GUI section ###

Dim $szDrive, $szDir, $szFName, $szExt
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $fileBrowseB
			$workdir = FileOpenDialog("", "", "ocx and dll (*.ocx;*.dll)", 3)
			If @error = 0 And $workdir <> "" Then
				GUICtrlSetData($workfileDIR, $workdir)
			EndIf
			$Path = _PathSplit(GUICtrlRead($workfileDIR, 1), $szDrive, $szDir, $szFName, $szExt)
			GUICtrlSetData($Input2, $szFName & $szExt)

		Case $Button1
			FileCopy($workdir, @SystemDir, 1)
			_RunDOS("regsvr32 " & @SystemDir & "\" & GUICtrlRead($Input2))
		Case $Button3
			_RunDOS("regsvr32 " & @SystemDir & "\" & GUICtrlRead($Input2) & " -u")
		Case $Label3
			SplashTextOn("ABOUT", " Product Name:" & @CRLF & " OCX / DLL FILE REGISTER UTILITY" & @CRLF & @CRLF & "Version 1.0.0.1" ,"350", "300", "600", "277", 2, "", "", "")
			Sleep(1500)
			SplashOff()



	EndSwitch
WEnd
