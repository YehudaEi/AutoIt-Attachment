#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=Files\AutoClean.ico
#AutoIt3Wrapper_outfile=..\AutoClean.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/striponly
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include-once
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.2.0
 Author:         Matthew McMullan

 Script Function:
	Clean up an Infected Computer.

#ce ----------------------------------------------------------------------------
DirCreate("Logs")
Global $log = "Logs\AutoClean"&@YEAR&@MON&@MDAY&@HOUR&".log"
Global $revlog = "Logs\AutoClean"&@YEAR&@MON&@MDAY&@HOUR&" Revert.acd"

#include "Lang.au3"

Global $ForceFileUpdate = True
FileChangeDir(@ScriptDir)
Global $settings = "settings.ini"
If Not(@Compiled) Then
	$settings = "..\settings.ini"
EndIf
SelectLanguage(IniRead($settings,"Core","Language","English"))
Global $selectGUI

Global $gui = GUICreate(GetLang("ProgName"),300,95,0,0)
Global $step = GUICtrlCreateLabel("...",5,5,290)
Global $state = GUICtrlCreateLabel("...",15,25,280)
Global $progress = GUICtrlCreateProgress(5,45,290,30)
Global $ETR = GUICtrlCreateLabel(GetLang("ET")&": ",5,80,300)

Global $fList[1]

Func RegisterFunction($sCall, $sName)
	$fList[UBound($fList)-1] = $sCall
	ReDim $fList[UBound($fList)+1]
EndFunc

#Include <ScreenCapture.au3>
#include "Util.au3"
#include "GUI.au3"
#include "Wizard.au3"
#include "Scanners.au3"
#include "Performance.au3"
#include "Maint.au3"
#include "WinFixes.au3"
#include "File Association.au3"
#include "ACD Interpreter.au3"
#include "KillProcs.au3"
InitKillProcs()

If $CmdLine[0] == 0 Then
	GetAgreement()
	Main()
Else
	Switch StringLower($CmdLine[1])
		Case "/runall"
			GUISetState(@SW_SHOW,$gui)
			RunAll()
			Shutdown(2)
		Case "/runall-norestart"
			GUISetState(@SW_SHOW,$gui)
			RunAll()
		Case "/runall-silent"
			RunAll()
			Shutdown(2)
		Case "/runall-silent-norestart"
			RunAll()
		Case "/settings"
			If $CmdLine[0]>=2 Then
				$settings = $CmdLine[2]
			EndIf
			Main()
		Case "/run"
			If $CmdLine[0]>=2 Then
				$settings = $CmdLine[2]
			EndIf
			Main(True)
		Case "/run-silent"
			If $CmdLine[0]>=2 Then
				$settings = $CmdLine[2]
			EndIf
			Main(True,True)
		Case "/deltemp"
			CleanTemp()
		Case "/update"
			UpTemp()
		Case "/update-silent"
			UpTemp(True)
		Case "/Capture"
			Main(False,False,True)
		Case "/simple"
			Wizard()
		Case Else
			If StringRight($CmdLine[1],4) == ".acd" Then
				InterpretACD($CmdLine[1])
			Else
				$settings = $CmdLine[1]
				GetAgreement()
				Main()
			EndIf
	EndSwitch
EndIf

Func RunAll()
	For $i=0 To UBound($fList)-1
		Execute($fList[$i])
	Next
EndFunc

Func GetAgreement()
	If IniRead($settings,"Core","Accepted","False")=="True" Then
		Return True
	EndIf
	Local $gui = GUICreate($oLang.Item("ProgName"),400,220)
	FileInstall("files\CC.jpg","CC.jpg")
	Local $cc = GUICtrlCreatePic("CC.jpg",200-44,10,88,31)
	GUICtrlCreateLabel("The Automatic System Cleaner by",10,50)
	Local $name = GUICtrlCreateLabel("Matthew C. McMullan",172,50,125)
	GUICtrlSetFont(-1,8.5,800)
	GUICtrlSetColor(-1,0x0000FF)
	GUICtrlCreateLabel("is licensed under a",298,50)
	Local $lic = GUICtrlCreateLabel("Creative Commons Attribution-No Derivative Works 3.0 United States License.",10,72,380,30)
	GUICtrlSetFont(-1,8.5,800)
	GUICtrlSetColor(-1,0x0000FF)
	GUICtrlCreateLabel("Permissions beyond the scope of this license may be available",10,110)
	Local $additional = GUICtrlCreateLabel("Here.",305,110,50)
	GUICtrlSetFont(-1,8.5,800)
	GUICtrlSetColor(-1,0x0000FF)
	GUICtrlCreateLabel("This program may be used in commercial settings but not sold.  For further licensing permissions or questions please email Matthew@Computersitter.com  For custom versions, please email Matthew@Computersitter.com",10,130,380,40)
	Local $agree = GUICtrlCreateButton("Agree",50,183,100)
	Local $disagree = GUICtrlCreateButton("Disagree",250,183,100)
	GUISetState()
	FileDelete("CC.jpg")
	Local $msg
	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case -3
				Exit
			Case $disagree
				Exit
			Case $agree
				GUIDelete($gui)
				IniWrite($settings,"Core","Accepted","True")
				Return True
			Case $name
				ShellExecute("http://AutoClean.computersitter.com")
			Case $lic
				ShellExecute("http://creativecommons.org/licenses/by-nd/3.0/us/")
			Case $additional
				ShellExecute("http://AutoClean.computersitter.com/use-and-redistribution")
		EndSwitch
		Sleep(10)
	WEnd
EndFunc
