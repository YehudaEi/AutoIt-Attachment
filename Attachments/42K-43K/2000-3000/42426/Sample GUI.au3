#NoTrayIcon
#RequireAdmin
#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_LegalCopyright=Copyright 2013 All Rights Reserved. AutoIt v3
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
;~ #AutoIt3Wrapper_Run_Tidy=y
;~ #Tidy_Parameters=/pr=1 /bdir /rerc
#endregion

#region #include ;**** #include .au3 files
#include <GuiConstants.au3>
#include <EditConstants.au3 >
#include <GuiButton.au3>
#include <IE.au3>
#include <Array.au3>
#include <Misc.au3>
#include <Process.au3>
#include <GuiToolBar.au3>
#include <RefreshSystemTray.au3>
#endregion



#region Opt ;**** Script Option settings
Opt("GUIOnEventMode", 1) ;0=disabled, 1=OnEvent mode enabled
#endregion

#region Global Variables ;**** Global Environment Variable Callouts and Script Settings
; ---------
; Global Variables called out in all functions
; ---------
Global $Username = @UserName ;****Looks for logged in user on computer

#endregion

#region Runtime
; -------
; Runtime
; -------
_MainMenu()


While 1
	Sleep(50)
WEnd
#endregion

#region Functions ;**** Triggered by #Region Runtime
;~ ---------
;~ Functions
;~ ---------
Func _MainMenu()
;~ GUI Interface Dimensions
	$GUIWidth = 450 ; Width of GUI _MainMenu() Box
	$GUIHeight = 250 ; Height of GUI _MainMenu() Box

;~ GUI Interface Controls
	$GUI = GUICreate("CS Tool - " & $Username & "", $GUIWidth, $GUIHeight, (@DesktopWidth - $GUIWidth) / 2, (@DesktopHeight - $GUIHeight) / 2) ;Create GUI _MainMenu() Box
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit") ;Closes GUI _MainMenu()
	; ===================================================================
;~ **** GUI Button Layout
;~ GUI Button for displaying AllSiteManagement Links
	GUICtrlCreateLabel("Site Management Links", 220, 140, 175, 25)
	$ButtonCurrentEV = GUICtrlCreateButton("All Site Links", 220, 160, 150, 25)
	GUICtrlSetOnEvent(-1, "_AllSiteManagement")
	GUISetState(@SW_SHOW, $GUI)
	; ===================================================================
EndFunc ;==>_MainMenu

Func _Exit() ;Exits Application
	Exit
EndFunc   ;==>_Exit

#region HTML Site Management Page List
;~ ****HTML SITE MANAGEMENT LIST
Func _AllSiteManagement() ;Opens a web page list of all the Site Management Pages to navigate to. Located in File Menu
	Local $s_html = "", $o_object
	$s_html &= "<HTML>" & @CR
	$s_html &= "<HEAD>"
	$s_html &= "<TITLE>Site Management List</TITLE>"
	$s_html &= "<STYLE>body {font-family: Arial}</STYLE>"
	$s_html &= "</HEAD>"
	$s_html &= "<BODY>"
	$s_html &= "<table border=0 id='tableOne' cellspacing=5>"
	$s_html &= "<tr>"
	$s_html &= "	<td align=center><b>Site Management Page & External Link</b></td>"
	$s_html &= "</tr><tr></tr><tr></tr>"
	$s_html &= "<tr>"
	$s_html &= "	<td>Google</td>"
	$s_html &= "</tr>"
	$s_html &= "<tr>"
	$s_html &= "	<td><a href='                          ' target=_blank>ESPN Site 1</a></td>"
	$s_html &= "	<td><a href='                       ' target=_blank>ESPN Site 2</a></td>"
	$s_html &= "</tr><tr></tr><tr></tr>"
	$s_html &= "<tr>"
	$s_html &= "	<td>Yahoo</td>"
	$s_html &= "</tr>"
	$s_html &= "<tr>"
	$s_html &= "	<td><a href='                ' target=_blank>Yahoo Site 1</a></td>"
	$s_html &= "	<td><a href='                        ' target=_blank>Yahoo Site 2</a></td>"
	$s_html &= "</tr><tr></tr><tr></tr>"
	$s_html &= "</table>"
	$s_html &= "</BODY>"
	$s_html &= "</HTML>"
	$o_object = _IECreate()
	_IEDocWriteHTML($o_object, $s_html)
EndFunc   ;==>_AllSiteManagement
;~ ****END HTML SITE MANAGEMENT LIST
#endregion

