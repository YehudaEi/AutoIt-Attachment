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
#include <GuiButton.au3>
#include <GUIConstantsEx.au3>
#include <File.au3>

;############################################ Variablen deklarieren
Global $wlan_name = "Testlan"
Global $msKB

;############################################ Dateien einbinden
FileInstall("certmgr.exe", @TempDir & "\certmgr.exe", 1)
FileInstall("EMT-WLAN-CA.cer", @TempDir & "\EMT-WLAN-CA.cer", 1)
FileInstall("WindowsXP-KB958071-x86-DEU.exe", @TempDir & "\WindowsXP-KB958071-x86-DEU.exe", 1)
;~ FileInstall("WindowsXP-KB958071-x86-EN.exe", @TempDir & "\WindowsXP-KB958071-x86-EN.exe", 1)

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
$password = GUICtrlCreateInput("",10,40,200,20)
$connect = GUICtrlCreateButton("verbinden",10,70,100,20)
$cert = GUICtrlCreateButton("Cert installieren",120,70,150,20)
$del_prof = GUICtrlCreateButton("Profil löschen",10,100,100,20)
If @OSVersion = "WIN_XP" And @OSLang = "0407" Then $msKB = GUICtrlCreateButton("Hotfix DE",120,100,150,20)
If @OSVersion = "WIN_XP" And @OSLang = "????" Then $msKB = GUICtrlCreateButton("Hotfix EN",120,100,150,20)

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
				Disconnect()
				DeleteProfile()
				CreateProfile()
				SetCredentials(GUICtrlRead($password))
				Connect()
			Else
				;nothing
			EndIf
		Case $Cert
			Run(@TempDir & "\certmgr.exe -add " & @TempDir & "\EMT-WLAN-CA.cer -s -r currentUser Root", '', @SW_HIDE)
		Case $del_prof
			DeleteProfile()
		Case $msKB
			If @OSLang = "0407" Then Run(@TempDir & "\WindowsXP-KB958071-x86-DEU.exe")
			If @OSLang = "????" Then Run(@TempDir & "\EN_VERSION.exe")
	EndSwitch
WEnd

;############################################ Funktionen
Func Disconnect()
	;disconnects the current WLAN connection
	;didn't figure out yet how that works
EndFunc

Func DeleteProfile()
	;check if Profile already exists, if so delete first
	If _Wlan_DeleteProfile($wlan_name) = True Then ; --> IF WLAN EXISTS Then ...
		_Wlan_DeleteProfile($wlan_name)
		MsgBox(0,"",$wlan_name & " Profile deleted")
	Else
		MsgBox(0,"","No Profile deleted")
	EndIf
EndFunc

Func CreateProfile()
	;create new WLAN Profile with Domain authentication
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

Func SetCredentials($pw)
	;Set user credentials for WLAN Profile
	$oUserData = _Wlan_CreateUserDataObject()
	With $oUserData
	.BaseType = "PEAP"
	.Type = "PEAP-MSCHAP"
	.PEAP.MSCHAP.Username = "wlanuser"
	.PEAP.MSCHAP.Password = "" & $pw & ""
	.PEAP.MSCHAP.Domain = "lcldom"
	EndWith
	_Wlan_SetProfileUserData("ACS_WLAN", $oUserData, 1)
	;~ ConsoleWrite(_Wlan_ConvertUserData($oUserData) & @CRLF)
EndFunc

Func Connect()
	;connects to the new WLAN Profile
	;didn't figure out yet how that works
EndFunc