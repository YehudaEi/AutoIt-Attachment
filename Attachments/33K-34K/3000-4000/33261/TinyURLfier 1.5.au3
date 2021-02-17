#cs
	TinyURlfier - By Foxhoundz
	http://sourceforge.net/projects/tinyurlfier/
	Version 1.5.1

	This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.


#ce


#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=images\favicon.ico
#AutoIt3Wrapper_outfile=TinyURLFier.exe
#AutoIt3Wrapper_Res_Description=Generate short and long URLs with the TinyURL API
#AutoIt3Wrapper_Res_Fileversion=1.5.0.0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#NoTrayIcon

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <Misc.au3>
#include <String.au3>

OnAutoItExitRegister("_exit")
_Singleton(@ScriptName, 0)


#Region ------------------ GUI --------------------------
$MainGUI = GUICreate("TinyURLfier 1.5", 531, 111, 239, 328)
$urlInput = GUICtrlCreateInput("", 16, 48, 385, 21)
$generateButton = GUICtrlCreateButton("Generate URL", 412, 22, 113, 33, $WS_GROUP)
$copyButton = GUICtrlCreateButton("About",412, 65, 113, 33, $WS_GROUP)
$Label1 = GUICtrlCreateLabel("Enter a long URL to generate a short link." & @CRLF & "If you input a TinyURL link, it will retrieve the long link", 16, 8, 300, 35)
;$hiddenLabel = GUICtrlCreateLabel("",20, 88, 200, 17) Unused
GUISetState(@SW_SHOW)
#EndRegion---------------------------------------------------


Global $apiURL = 'http://tinyurl.com/api-create.php?url='
Global $apiPreviewURL = 'http://preview.tinyurl.com/', $MainGUI, $ini[3]
$data = _readSettings()
_gui()

Func _gui()
	While 1
		$msg = GUIGetMsg()
		If $msg == $GUI_EVENT_CLOSE Then Exit
		If $msg == $generateButton Then _init()
	WEnd
EndFunc   ;==>_gui

Func _init()
	$input = GUICtrlRead($urlInput)
	If StringRegExp($input, "http:\/\/tinyurl.com/") <> 0 Then
		$url = _getLongLink($input)
	ElseIf StringRegExp($input, "http|https:\/\/", 0) <> 0 Then
		$url = _getShortLink($input)
	Else
		MsgBox(16, "TinyURLfier 1.5 - Error", "Malformed link. Unable to retrieve TinyURL short URL.")
		_gui()
	EndIf
	If Not $url Then
		MsgBox(16, "TinyURLfier 1.5 - Parse Error", "Unable to retrieve data")
		_gui()
	EndIf
	GUICtrlSetData($urlInput, $url)
	If MsgBox(64 + 4, "TinyURLfier 1.5  - Copy to clipboard?", "Retrieved URL:"&@CRLF&"(" & $url & ")"&@CRLF&"Copy to clipboard?") == 6 Then
		ClipPut($url)
		MsgBox(64, "TinyURLfier 1.5", $url & " copied to clipboard.")
	EndIf
EndFunc   ;==>_init

Func _getLongLink($url)
	$key = StringTrimLeft($url, 19)
	$data = BinaryToString(InetRead($apiPreviewURL & $key))
	$url = _StringBetween($data, 'id="redirecturl" href="', '">Proceed')
	If $url == 0 Then Return False
	Return $url[0]

EndFunc   ;==>_getLongLink

Func _getShortLink($url)
	$tinyURL = InetRead($apiURL & $url)
	$tinyURL = BinaryToString($tinyURL)
	If StringLen($tinyURL) == 0 Then Return False
	Return $tinyURL
EndFunc   ;==>_getShortLink

Func _readSettings()
	local $path = @ScriptDir & "\tinyurlfier.ini"
	If Not FileExists($path) Then _createSettings()
	$ini[0] = IniRead($path, "General", "autoclip", "0") ;skip prompt and copy to clipboard
	$ini[2] = IniRead($path, "General", "SourceDump", "0") ;dump the TinyURL html source code before parsing
	$ini[1] = IniRead($path, "Debug", "massConvert", "0") ;convert list of links in a text file to TinyURL and vice versa - BEATA
EndFunc   ;==>_readSettings

Func _createSettings()
	local $path = @ScriptDir & "\tinyurlfier.ini"
	IniWrite($path, "General", "autoclip","0")
	IniWrite($path, "General", "massConvert","0")
	IniWrite($path, "Debug", "SourceDump","0")
	if not @error Then
		Return True
	Else
		Return False
	EndIf

EndFunc

Func _exit()
	GUIDelete($MainGUI)
	Exit
EndFunc
