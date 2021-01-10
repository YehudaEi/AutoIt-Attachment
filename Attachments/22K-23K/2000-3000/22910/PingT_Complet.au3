#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=..\Ico\glob_v2.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=Creat per TalivanIBM
#AutoIt3Wrapper_Res_Description=PingT Complet, pings i enviament de fitxers.
#AutoIt3Wrapper_Res_Fileversion=0.2.2.5
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=TaliSoft
#AutoIt3Wrapper_Res_Icon_Add=ICO\PARA.ICO
#AutoIt3Wrapper_Res_Icon_Add=ICO\START.ICO
#AutoIt3Wrapper_Res_Icon_Add=ICO\Left.ICO
#AutoIt3Wrapper_Res_Icon_Add=ICO\Add.ICO
#AutoIt3Wrapper_Res_Icon_Add=ICO\Remove.ICO
#AutoIt3Wrapper_Res_Icon_Add=ICO\Search.ICO
#AutoIt3Wrapper_Res_Icon_Add=ICO\List.ICO
#AutoIt3Wrapper_Res_Icon_Add=ICO\Search2.ICO
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;~ #AutoIt3Wrapper_Res_Icon_Add=ICO\Alert.ICO
;~ #AutoIt3Wrapper_Res_Icon_Add=ICO\Fail.ICO
#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.2.12.1
	Author:         TalivanIBM
	
	Script Function:
	Per executar tots els Ping's en una sola finestra.
	
#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#NoTrayIcon
#include "..\..\_Include\Codis.au3"
#include "..\..\_Include\IPBotigues.au3"
#include <GuiIPAddress.au3>
#include <GuiImageList.au3>
#include <GuiButton.au3>
#include <GuiStatusBar.au3>
#include <GuiEdit.au3>
#include <ListViewConstants.au3>
#include <iNet.au3>
#include <File.au3>
#include <Misc.au3>
#include <Timers.au3>
;~ #include <Array.au3>
#include <WindowsConstants.au3>
#include "Include\CompletFunc.au3"
#include "Include\CompletGui.au3"
#include "Include\ExplorerCopy.au3"

Opt("GuiOnEventMode", 1)
Opt("GuiCloseOnEsc", 0)
;~ HotKeySet("{F5}", "_Key")
;~ HotKeySet("{F6}", "_Key")
;~ HotKeySet("{F11}", "_Key")
HotKeySet("^o", "_Key")
HotKeySet("+{ENTER}", "_Key")
HotKeySet("^1", "_Key")
HotKeySet("^2", "_Key")
HotKeySet("^3", "_Key")
HotKeySet("^4", "_Key")
HotKeySet("^5", "_Key")
HotKeySet("^6", "_Key")
HotKeySet("^7", "_Key")
HotKeySet("^8", "_Key")
HotKeySet("^+1", "_Key")
HotKeySet("^+2", "_Key")
HotKeySet("^+3", "_Key")
HotKeySet("^+4", "_Key")
HotKeySet("^+5", "_Key")
HotKeySet("^+6", "_Key")
HotKeySet("^+7", "_Key")
HotKeySet("^+8", "_Key")

$Debug_LV = False

Global $cServidor = "\\puigmal\apps_varies\Ivan Programes\AutoIT\PingT\PingT Complet", $InstallDir = @ProgramFilesDir & "\TaliSoft\PingT", $Servidor = "\\puigmal\apps_varies\Ivan Programes\AutoIT\PingT", _
		$PATH = @ProgramFilesDir & "\TaliSoft\PingT\Bin", $LOG_Dir = $InstallDir & "\LOG PTC"

If RegRead($REG_CONFIG, "PingWait") 	= "" 	Then RegWrite($REG_CONFIG, "PingWait", "REG_DWORD", 4000)
If RegRead($REG_CONFIG, "PingPausa") 	= "" 	Then RegWrite($REG_CONFIG, "PingPausa", "REG_DWORD", 5000)
If RegRead($REG_CONFIG, "PingAvis") 	= "" 	Then RegWrite($REG_CONFIG, "PingAvis", "REG_DWORD", 2000)

If Not FileExists($LOG_Dir) 					Then DirCreate($LOG_Dir)

If @LogonDomain = "FAMILA" Then
	If FileExists($cServidor & "\PingT_Complet.exe") Then
		$cFile1 = $cServidor & "\PingT_Complet.exe"
		$cFile2 = $InstallDir & "\PingT_Complet.exe"
		If _VersionCompare(FileGetVersion($cFile1), FileGetVersion($cFile2)) = 1 Then
			MsgBox(64, "Versió nova", "Hi ha una nova versió del programa 'PingT Complet':" & @LF & "Vella: " & FileGetVersion($cFile2) & @LF & "Nova: " & FileGetVersion($cFile1), 4)
			Run($Servidor & "\Setup.exe /Complet", $Servidor)
			Exit
		EndIf
	EndIf
EndIf

_GuiComplet()