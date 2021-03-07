#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=Wlan Connection.exe
#AutoIt3Wrapper_Res_Comment=WLAN Connection for Domain Users
#AutoIt3Wrapper_Res_Description=WLAN Connection for Domain Users
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Strikers
#AutoIt3Wrapper_Res_Language=1031
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;############################################ au include's
#include "NativeWifi.au3"
;~ #include "Wifi40.au3"
#include <GuiButton.au3>
#include <GuiConstants.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <File.au3>

;############################################ Variablen deklarieren
Local $wlan_name = "Testlan"
Local $msKB

;############################################ Dateien einbinden
FileInstall("certmgr.exe", @TempDir & "\certmgr.exe", 1)
FileInstall("EMT-WLAN-CA.cer", @TempDir & "\EMT-WLAN-CA.cer", 1)
FileInstall("WindowsXP-KB958071-x86-DEU.exe", @TempDir & "\WindowsXP-KB958071-x86-DEU.exe", 1)
FileInstall("WindowsXP-KB958071-x86-ENU.exe", @TempDir & "\WindowsXP-KB958071-x86-ENU.exe", 1)

;############################################ Natve WiFi laden
$fDebugWifi = True

_Wlan_StartSession()
_Wlan_StartNotificationModule()

;############################################ GUI erstellen
GUICreate("WiFi Verbindung", 300, 200)
GUISetState(@SW_SHOW)
GUISetBkColor(0xF0F0F0)
GUISetFont(11)
GUICtrlCreateLabel("Bitte WLAN Passwort eingeben:", 10, 10, 200, 17)
$password = GUICtrlCreateInput("",10,40,200,20, $ES_PASSWORD)
$connect = GUICtrlCreateButton("verbinden",10,70,100,20)
$cert = GUICtrlCreateButton("Cert installieren",120,70,150,20)
$del_prof = GUICtrlCreateButton("Profil löschen",10,100,100,20)
$msKB = GUICtrlCreateButton("Hotfix Win XP",120,100,150,20)
If @OSVersion <> "WIN_XP" Then GUICtrlSetState($msKB, $GUI_DISABLE)

;############################################ Programmablauf
While 1
    Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
            Exit
		Case $connect
			If GUICtrlRead($password) = "" Then
				MsgBox(0,"Hinweis","Kein Passwort eingetragen")
				Exit
			ElseIf @OSVersion = "WIN_7" or @OSVersion = "WIN_XP" Then
				_Wlan_Disconnect() ;disconnects the current WLAN connection
;~ 				MsgBox(0,"","disco")
				DeleteProfile()
				CreateProfile()
;~ 				MsgBox(0,"","create")
				SetCredentials(GUICtrlRead($password))
				_Wlan_Connect($wlan_name) ;connects to the new WLAN Profile
			Else
				;nothing
			EndIf
		Case $Cert
			Run(@TempDir & "\certmgr.exe -add " & @TempDir & "\EMT-WLAN-CA.cer -s -r currentUser Root", '', @SW_HIDE)
		Case $del_prof
			DeleteProfile()
		Case $msKB
			If @OSLang = "0407" Then
				Run(@TempDir & "\WindowsXP-KB958071-x86-DEU.exe")
			ElseIf @OSLang = "0409" Then
				Run(@TempDir & "\WindowsXP-KB958071-x86-ENU.exe")
			Else
				MsgBox(0,"","Keine passende Sprache für Hotfix")
			EndIf
	EndSwitch
WEnd

;############################################ Funktionen
Func DeleteProfile()	;check if Profile already exists, if so delete first
	If _Wlan_DeleteProfile($wlan_name) = True Then ;IF WLAN Profile Exists Then....
		_Wlan_DeleteProfile($wlan_name)
		MsgBox(0,"",$wlan_name & " Profile deleted")
	Else
		MsgBox(0,"","No Profile deleted")
	EndIf
EndFunc

Func CreateProfile()	;create new WLAN Profile with Domain authentication
	Local $oProfile, $sReason

	$oProfile = _Wlan_CreateProfileObject()
	With $oProfile
	.Name = $wlan_name
	.SSID.Add($oProfile.Name)
	.Type = "Infrastructure"
	.Auth = "WPA2"
	.Encr = "AES"
	.Options.NonBroadcast = True
	.Options.ConnMode = "Automatic"
	.OneX.Enabled = True
	.OneX.AuthMode = "User"
	.PMK.PreAuthEnabled = True
	.PMK.CacheEnabled = True
	.EAP.BaseType = "PEAP"
	.EAP.Type = "PEAP-MSCHAP"
	.EAP.PEAP.MSCHAP.UseWinLogonCreds = False
	EndWith
	;~ ConsoleWrite(_Wlan_ConvertProfile($oProfile) & @CRLF)

	If Not _Wlan_SetProfile($oProfile, $sReason) Then
		MsgBox(0, "Wifi", "Failed to create profile " & $oProfile.Name & ". @error=" & @error & @CRLF & "Because: " & $sReason)
		Exit
	EndIf
EndFunc

Func SetCredentials($pw)	;Set user credentials for WLAN Profile
	$oUserData = _Wlan_CreateUserDataObject()
	With $oUserData
	.BaseType = "PEAP"
	.Type = "PEAP-MSCHAP"
	.PEAP.MSCHAP.Username = "wlanuser"
	.PEAP.MSCHAP.Password = "" & $pw & ""
	.PEAP.MSCHAP.Domain = "lcldom"
	EndWith

	_Wlan_SetProfileUserData($wlan_name, $oUserData, 1)
	ConsoleWrite(_Wlan_ConvertUserData($oUserData) & @CRLF)
EndFunc