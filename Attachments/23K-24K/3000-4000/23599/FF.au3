; :wrap=none:collapseFolds=1:maxLineLen=80:mode=autoitscript:tabSize=8:folding=indent:
#include-once
;#include <Array.au3>
#region Copyright
	#cs
	* FF.au3
	*
	* This program is free software; you can redistribute it and/or
	* modify it under the terms of the GNU General Public License
	* as published by the Free Software Foundation; either version 2
	* of the License, or any later version.
	*
	* This program is distributed in the hope that it will be useful,
	* but WITHOUT ANY WARRANTY; without even the implied warranty of
	* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	* GNU General Public License for more details.
	*
	* You should have received a copy of the GNU General Public License
	* along with this program; if not, write to the Free Software
	* Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
	#ce
#endregion Copyright
#region Current
	#cs
	_FFAction
	_FFClick
	_FFClickImage
	_FFClickImageBySize
	_FFClickLink
	_FFConnect
	_FFDisConnect
	_FFFormCheckBox
	_FFFormRadioButton
	_FFFormReset
	_FFFormSubmit
	_FFFrameEnter
	_FFFrameLeave
	_FFFrameSelected
	_FFGetLength
	_FFGetLinks
	_FFGetValueById
	_FFGetValueByName
	_FFKeyPress
	_FFLoadWait
	_FFOpenURL
	_FFQuit
	_FFReadHTML
	_FFReadText
	_FFSearch
	_FFSetGet
	_FFSetValueById
	_FFSetValueByName
	_FFStart
	_FFTabAdd
	_FFTabClose
	_FFTabCloseAll
	_FFTabExists
	_FFTabLength
	_FFTabSelect
	_FFTabSelected
	#ce
#endregion Current
#region  Discription
; ==============================================================================
; UDF ...........: FF.au3 V0.2.4.0beta
; Description ...: An UDF for FireFox automation.
; Requirement ...: MozLab AddOn:                                       
; Author(s) .....: Thorsten Willert, Johannes Schirmer
; Date ..........: 13. September 2008
; ==============================================================================
#cs
	V0.2.4.0
		* NEU: _FFSearch(ByRef $Socket, $sSearchString[, $bCaseSensitive = false[, $bBackwards = false[, $bWrapAround = true[, $bWholeWord = false[, $bSearchInFrames = true[, $iDelay = 0]]]]]])

	ToDo:
	JavaScript zum suchen von Values
	_FFForm... fuer Auswahllisten
#ce
#endregion Discription

#region Global Constants
	Global Const $_FF_PROC_NAME = "firefox.exe"		; Firefox process name
	Global Const $_FF_COM_DELAY_MAX = 100			; Max. connection delay in ms
	Global Const $_FF_COM_TRACE = True			; Trace communication to console (debugging)

	Global Enum _						; Errors
			$_FF_ERROR_Success = 0, _ 		; No error
			$_FF_ERROR_GeneralError, _ 		; General error
			$_FF_ERROR_SocketError, _ 		; No socket
			$_FF_ERROR_InvalidDataType, _ 		; Invalid data type (IP, URL, Port ...)
			$_FF_ERROR_InvalidValue, _ 		; Invalid value in function-call
			$_FF_ERROR_SendRecv, _			; Send / Recv Error
			$_FF_ERROR_Timeout, _ 			; Connection / Send / Recv timeout
			$_FF_ERROR___UNUSED, _ 			;
			$_FF_ERROR_NoMatch, _ 			; No match for _FFAction-find/search _FFGetElement...
			$_FF_ERROR_RetValue, _			; Error echo from Repl e.g. _FFAction($socket,"fullscreen","true") <> "true"
			$_FF_ERROR_ReplException 		; Exception from MozRepl / FireFox
#endregion Global Constants

#region Global Variables
	Global $_FF_CON_DELAY 	; Connection Delay
	Global $_FF_VERSION ; FF Version
	Global $_aFF_STATUS[2][3] ; Status-Array
	$_aFF_STATUS[0][0] = 0
	$_aFF_STATUS[1][0] = -1
	$_aFF_STATUS[1][1] = -1
	$_aFF_STATUS[1][2] = -1
#endregion Global Variables

; #FUNCTION# ===================================================================
; Name ..........: _FFAction
; Description ...: Some standard actions to work with FireFox
; Syntax ........: _FFAction(ByRef $Socket, $sAction[, $sOption = ""[, $iDelay = 0]])
; Parameter(s): .:
;                  $Socket      - Connection socket to FireFox/MozRepl
;                  $sAction     - Action
;                  $sOption     - Optional: Action-option
;                  $iDelay      - Optional: Delay before sending
; Return Value ..: Success      - Return-value from MozRepl (sometimes an empty string!!!)
;                  Failure      - ""
; Author(s) .....: Thorsten Willert
; Modified ......: Sat Jul 26 15:56:31 CEST 2008
; Link ..........: http://developer.mozilla.org/en/docs/XUL:tabbrowser
; Example .......: Yes
; ==============================================================================
Func _FFAction(ByRef $Socket, $sAction, $sOption = "", $iDelay = 0)
	If Not __FFIsSocket($Socket) Then
		SetError(__FFError("_FFAction", $_FF_ERROR_SocketError))
		Return ""
	EndIf

	Local $sOptionL = StringLower($sOption)
	Local $sCommand
	Local $sActionL = StringLower($sAction)

	Select
		Case $sActionL = "back"
			$sCommand = "gBrowser.goBack()"
		Case $sActionL = "home"
			$sCommand = "gBrowser.goHome()"
		Case $sActionL = "forward"
			$sCommand = "gBrowser.goForward()"
		Case $sActionL = "reload" And $sOption <> ""
			#cs
				http://developer.mozilla.org/en/docs/XUL:Method:reloadWithFlags
				Flags:
				* LOAD_FLAGS_NONE: No special flags. The document is loaded normally.
				* LOAD_FLAGS_BYPASS_CACHE: Reload the page, ignoring if it is already in the cache. This is the flag used when the reload button is pressed while the Shift key is held down.
				* LOAD_FLAGS_BYPASS_PROXY: Reload the page, ignoring the proxy server.
				* LOAD_FLAGS_CHARSET_CHANGE: This flag is used if the document needs to be reloaded because the character set changed.
				You may combine flags using a or symbol ( | ).
			#ce
			$sCommand = "gBrowser.reloadWithFlags('" & $sOption & "')"
		Case $sActionL = "fullscreen" Or $sActionL = "fs" And $sOptionL = "true"
			$sCommand = "fullScreen=true"
		Case $sActionL = "fullscreen" Or $sActionL = "fs" And $sOptionL = "false"
			$sCommand = "fullScreen=false"
		Case $sActionL = "minimize" Or $sActionL = "min"
			$sCommand = "minimize()"
		Case $sActionL = "maximize" Or $sActionL = "max"
			$sCommand = "maximize()"
		Case $sActionL = "restore"
			$sCommand = "restore()"
		Case $sActionL = "stop"
			$sCommand = "gBrowser.stop()"
		Case $sActionL = "print"
			$sCommand = "content.print()"
		Case $sActionL = "search" And $sOption <> ""
			ContinueCase
		Case $sActionL = "find" And $sOption <> ""
			$sCommand = 'content.find("' & $sOption & '",false,false,true,false,true,false)'
		Case $sActionL = "search"
			ContinueCase
		Case $sActionL = "find"
			$sCommand = "content.find()"
		Case $sActionL = "hideall" And $sOptionL = "true"
			$sCommand = "toggleAffectedChrome(true)"
		Case $sActionL = "hideall" And $sOptionL = "false"
			$sCommand = "toggleAffectedChrome(false)"
		Case $sActionL = "presentationmode" Or $sActionL = "pm" And $sOptionL = "true"
			$sCommand = "toggleAffectedChrome(true)" & @CRLF & "fullScreen=true"
		Case $sActionL = "presentationmode" Or $sActionL = "pm" And $sOptionL = "false"
			$sCommand = "toggleAffectedChrome(false)" & @CRLF & "fullScreen=false"
		Case $sActionL = "alert" And $sOptionL <> ""
			$sCommand = 'alert("' & $sOption & '")'
		Case $sActionL = "chrome" And $sOption <> ""
			$sCommand = 'content.document.location.href="' & __FFChromeSelect($sOptionL) & '"'
		Case $sActionL = "about"
			$sCommand = 'content.document.location.href="about:"'
		Case $sActionL = "blank"
			$sCommand = 'content.document.location.href="blank:"'
		Case $sActionL = "resetconsole"
			$sCommand = ";" & @CRLF & "repl.home()"
		Case Else
			SetError(__FFError("_FFAction", $_FF_ERROR_InvalidValue, "$sAction: " & $sAction & " or " & _
					"$sOption :" & $sOption))
			Return ""
	EndSelect

	If __FFSend($Socket, $sCommand, $iDelay) Then
		Return __FFRecv($Socket)
	Else
		Return ""
	EndIf

EndFunc   ;==>_FFAction

; #FUNCTION# ===================================================================
; Name ..........: _FFClick
; Description ...: Simulates a click on an object.
; Syntax ........: _FFClick(ByRef $Socket, $sObject[, $iTabIndex = -1])
; Parameter(s): .:
;                  $Socket      -
;                  $sObject     -
;                  $iTabIndex   - Optional: (Default = -1)
; Return Value ..: Success      - 1
;                  Failure      - 0
; Author(s) .....: Thorsten Willert
; Modified ......: 26. June 2002
; Related .......: _FFClickImage, _FFClickImageBySize, _FFClickLink
; Example .......: Yes
; ==============================================================================
Func _FFClick(ByRef $Socket, $sObject, $iTabIndex = -1)
	If $iTabIndex > -1 Then _FFTabSelect($Socket,"index",$iTabIndex)

	Local $iFrame = __FFGetStatus($Socket)
	If StringLeft($sObject,1) = "." Then $sObject = "content.frames[" & $iFrame & "].document" & $sObject

	__FFSend($Socket, "FF_AutoItScript.SimulateClick(" & $sObject & "," & $iFrame & ")" )
	If Not @error Then Return __FFRecv($Socket)

	Return 0
EndFunc   ;==>_FFClick

; #FUNCTION# ===================================================================
; Function ......: _FFClickImage
; Description ...: Simulates a click on and image-link
; Parameter(s) ..: ByRef $Socket
;                  $vSearch                 : Text to search or Number in index mode
;                  $iMode="src"             : src, alt, name, title, id, index
;                  $iTabIndex = -1
; Requirement ...:
; Return values .: Success      - 1
;                  Failure      - 0
; User CallTip: .: _FFClickImg( )
; Author(s) .....: Thorsten Willert
; Date ..........: 07. June 2008
; Note(s) .......:
; ==============================================================================
Func _FFClickImage(ByRef $Socket, $vSearch, $sMode = "src", $iTabIndex = -1)
	If Not __FFIsSocket($Socket) Then
		SetError(__FFError("_FFClickImage", $_FF_ERROR_SocketError, $Socket))
		Return 0
	EndIf

	Local $sRegEx
	Local $iIndex = -1

	$sMode = StringLower($sMode)

	If $sMode <> "index" Then
		Local $vSearch_org = $vSearch

		If $sMode = "src" Then
			$sRegEx = "src"
			$vSearch = StringRegExpReplace($vSearch,"([\/\.\?\+\=])","\\$1")
		ElseIf $sMode = "alt" Or $sMode = "name" Or $sMode = "title" Or $sMode = "id" Then
			$sRegEx = $sMode
		Else
			SetError(__FFError("_FFClickImage", $_FF_ERROR_InvalidValue, "$sMode: " & $sMode))
			Return 0
		EndIf

		$sRegEx = "/" & $sRegEx & "[ \t]*=[ \t]*(.*)" & $vSearch & "/"
		$iIndex = _FFSetGet($Socket, "FF_AutoItScript.SearchImageLink(" & $sRegEx & "," & __FFGetStatus($Socket) & ")", 10000, $iTabIndex)

		If $iIndex > -1 Then
			If _FFClick($Socket, ".links[" & $iIndex & "]", $iTabIndex) Then Return 1
		EndIf

		SetError(__FFError("_FFClickImage", $_FF_ERROR_NoMatch, $vSearch_org))
		Return 0

	ElseIf IsInt($vSearch) And $vSearch > -1 Then
		If _FFClick($Socket, ".images[" & $vSearch & "]", $iTabIndex) Then Return 1

		SetError(__FFError("_FFClickImage", $_FF_ERROR_NoMatch, $vSearch))
		Return 0
	EndIf

	SetError(__FFError("_FFClickImage", $_FF_ERROR_NoMatch, $vSearch))
	Return 0
EndFunc   ;==>_FFClickImage

; #FUNCTION# ===================================================================
; Name ..........: _FFClickImageBySize
; Description ...: Clicks all images on a page by size.
; Syntax ........: _FFClickImageBySize(ByRef $Socket, $iHeight, $iWidth[, $sMode = "eq"[, $sTarget = "_blank"[, $iTabIndex = -1]]])
; Parameter(s): .:
;                  $Socket      -
;                  $iHeight     -
;                  $iWidth      -
;                  $sMode       - Optional (Default = "eq") :
;                  $sTarget     - Optional (Default = "_blank") :
;                  $iTabIndex   - Optional (Default = -1) :
; Return Value ..: Success      - 1
;                  Failure      - 0
; Author(s) .....: Thorsten Willert
; Modified ......: 08. June 2008
; Related .......: _FFclick, _FFClickImage, _FFClickLink
; Example .......: Yes
; ==============================================================================
Func _FFClickImageBySize(ByRef $Socket, $iHeight, $iWidth, $sMode="eq", $sTarget = "_blank", $iTabIndex = -1)
	If Not __FFIsSocket($Socket) Then
		SetError(__FFError("_FFClickImageBySize", $_FF_ERROR_SocketError, $Socket))
		Return 0
	EndIf

	; Default parameters
	If $iWidth <= 0 Then $iWidth = 1
	If $iHeight <= 0 Then $iHeight = 1
	If $sMode <> Default Then
		$sMode = StringLower( $sMode )
	Else
		$sMode = "eq"
	EndIf
	If $sTarget = Default Then $sTarget = "_blank"

	; Search images by size
	Local $iIndex = _FFSetGet($Socket,"FF_AutoItScript.SearchLinkImageBySize(" & $iHeight & "," & _
						$iWidth & ",'" & _
						$sMode & "'," & __FFGetStatus($Socket) & ")", 10000, $iTabIndex)

	If $iIndex <> "" Then
		Local $sLabel = _FFTabSelected($Socket,"label")
		; new target
		_FFSetGet($Socket,"FF_AutoItScript.SetTarget('" & $sTarget & "', " & __FFGetStatus($Socket) & ")")

		; click in the images
		Local $aIndex = StringSplit(StringStripWS($iIndex,3)," ")
		For $i = 1 to $aIndex[0]
			$aIndex[$i] =  Int($aIndex[$i])
			If $aIndex[$i] > -1 Then
				_FFClick($Socket, ".images[" & $aIndex[$i] & "]", $iTabIndex )
				Sleep($_FF_CON_DELAY+50)
				If _FFTabSelected($Socket,"label") <> $sLabel Then _FFTabSelect($Socket,"label",$sLabel)
			EndIf
		Next

		; changing the target back to the standard, by reloading the page
		_FFTabSelect($Socket,"label",$sLabel)
		_FFAction($Socket,"reload","LOAD_FLAGS_BYPASS_CACHE")
		_FFLoadWait($Socket,500)
	Else
		SetError(__FFError("_FFClickImageBySize", $_FF_ERROR_NoMatch))
		Return 0
	EndIf

	Return 1

EndFunc ;==> _FFClickImageBySize

; #FUNCTION# ===================================================================
; Function ......: _FFClickLink
; Description ...: Simulates a click on a link.
; Parameter(s) ..: ByRef $Socket
;                  $vSearch                 : Text to search or Number in index mode
;                  $iMode="src"             : href, alt, name, title id, index
;                  $iTabIndex = -1
; Requirement ...:
; Return values .: Success      - 1
;                  Failure      - 0
; User CallTip: .: (ByRef $Socket, $vSearch[, $sMode = "href"[, $iTabIndex = -1]])
; Author(s) .....: Thorsten Willert
; Date ..........: 01. September 2007
; Note(s) .......:
; ==============================================================================
Func _FFClickLink(ByRef $Socket, $vSearch, $sMode = "href", $iTabIndex = -1)
	If Not __FFIsSocket($Socket) Then
		SetError(__FFError("_FFClickLink", $_FF_ERROR_SocketError, $Socket))
		Return 0
	EndIf

	Local $iIndex = -1

	$sMode = StringLower($sMode)

	If $sMode <> "index" Then
		If Not ($sMode = "href" Or _
			$sMode = "text" Or _
			$sMode = "name" Or _
			$sMode = "title" Or _
			$sMode = "id") Then
			SetError(__FFError("_FFClickLink", $_FF_ERROR_InvalidValue, "$sMode: " & $sMode))
			Return 0
		EndIf

		$iIndex = _FFSetGet($Socket, 'FF_AutoItScript.SearchLink("' & $sMode & '","' & $vSearch & '",' & __FFGetStatus($Socket) & ')', 5000, $iTabIndex)

	ElseIf IsInt($vSearch) Then
		$iIndex = $vSearch
	EndIf

	If $iIndex > -1 Then
		If _FFClick($Socket, ".links[" & $iIndex & "]", $iTabIndex) Then Return 1
	Else
		SetError(__FFError("_FFClickLink", $_FF_ERROR_NoMatch, $vSearch))
		Return 0
	EndIf

	Return 0
EndFunc   ;==>_FFClickLink

; #FUNCTION# ===================================================================
; Function ......: _FFFrameSelected
; Description ...: Returns index of currently entered frame
; Parameter(s) ..: ByRef $Socket
; Requirement ...:
; Return values .: Success      - Index of currently entered Frame
;                  Failure      - "" or -1 if no Frame selected
; User CallTip: .: (ByRef $Socket)
; Author(s) .....: Thorsten Willert
; Date ..........: 19. June 2008
; Note(s) .......:
; ==============================================================================
Func _FFFrameSelected(ByRef $Socket, $sMode="index")
	Local $iIndex = __FFGetStatus($Socket)
	If $sMode = "index" Then
		Return $iIndex
	ElseIf $sMode = "name" Then
		Return _FFSetGet($Socket,'content.frames[' & $iIndex & '].name')
	Else
		SetError(__FFError("_FFFrameSelected", $_FF_ERROR_InvalidValue, "$sMode: " & $sMode))
		Return -1
	EndIf

	Return -1
EndFunc   ;==>_FFFrameSelected
; #FUNCTION# ===================================================================
; Function ......: _FFFrameLeave
; Description ...: Leaves currently entered frame
; Parameter(s) ..: ByRef $Socket
; Requirement ...:
; Return values .: Success      - 1
; User CallTip: .: _FFFrameLeave(ByRef $Socket)
; Author(s) .....: Thorsten Willert
; Date ..........: 19. June 2008
; Note(s) .......:
; ==============================================================================
Func _FFFrameLeave(ByRef $Socket)
	Return __FFSetStatus($Socket,-1)
EndFunc   ;==>_FFFrameLeave

; #FUNCTION# ===================================================================
; Function ......: _FFFrameEnter
; Description ...: Simulates a click on and image-link
; Parameter(s) ..: ByRef $Socket
;                  $vFrame:          Framename or frameid to enter or number in index mode
;                  $iMode="index":   name, id, index
;                  $iTabIndex:       -1
; Requirement ...:
; Return values .: Success         - Index of the entered frame
;                  Failure         - ""
; User CallTip: .: _FFFrameEnter(ByRef $Socket, $vFrame[, $sMode = "index"[, $iTabIndex = -1]])
; Author(s) .....: Thorsten Willert & Johannes Schirmer
; Date ..........: 19. June 2008
; Note(s) .......:
; ==============================================================================
Func _FFFrameEnter(ByRef $Socket, $vFrame, $sMode = "index", $iTabIndex = -1)
	If Not __FFIsSocket($Socket) Then
		SetError(__FFError("_FFEnterFrame", $_FF_ERROR_SocketError))
		Return ""
	EndIf

	Local $sArg, $ilength, $i

	Switch $sMode
		Case "index" ;And IsInt($vFrame)
			$sArg = "content.frames[" & $vFrame & "]"
		Case "name" Or "id"
			$sArg = 'content.frames["' & $vFrame & '"]'
		Case Else
			SetError(__FFError("_FFFrameEnter", $_FF_ERROR_InvalidValue, "$sMode: " & $sMode))
			Return ""
	EndSwitch

	If _FFFrameSelected($Socket) > -1 Then _FFFrameLeave($Socket)

	If $vFrame < 0 Then
		SetError(__FFError("_FFFrameEnter", $_FF_ERROR_InvalidValue, "$vFrame: " & $vFrame))
		Return ""
	EndIf
	If $sMode = "index"  Then ;And IsInt($vFrame)
		_FFSetGet($Socket, $sArg & ".document")
		If Not @error Then
			__FFSetStatus($Socket,$vFrame)
			Return $vFrame
		EndIf
	Else
		$ilength = _FFSetGet($Socket, "content.frames.length", 3000, $iTabIndex)
		If $ilength <> "" Then
			For $i = 0 To $ilength - 1
				If _FFSetGet($Socket, "content.frames[" & $i & "].name", 3000, $iTabIndex) == $vFrame Then
					__FFSetStatus($Socket, $i)
					Return $i
				EndIf
			Next
		EndIf
	EndIf
	SetError(__FFError("_FFFrameEnter", $_FF_ERROR_NoMatch, "$vFrame: " & $vFrame))
	Return ""
EndFunc   ;==>_FFFrameEnter

; #FUNCTION# ===================================================================
; Function ......: _FFGetLength
; Description ...: Returns the length of the object in $sMode
; Parameter(s) ..: ByRef $Socket
;                  $sMode="links"    : links, images, forms, frames, anchors, styleSheets, tabs
;                  $iTabIndex= -1
; Requirement ...:
; Return values .: Success      - Number of sMode
;                  Failure      - -1  (unknown $sMode) or empty string
; User CallTip: .: (ByRef $Socket[, $sMode = "links"[, $iTabIndex = -1]])
; Author(s) .....: Thorsten Willert
; Date ..........: 26. June 2008
; Note(s) .......:
; ==============================================================================
Func _FFGetLength(ByRef $Socket, $sMode = "links", $iTabIndex = -1)
	If Not __FFIsSocket($Socket) Then
		SetError(__FFError("_FFGetLength", $_FF_ERROR_SocketError, $Socket))
		Return 0
	EndIf

	$sMode = StringLower($sMode)

	If $sMode = "tabs" Then
		Return _FFSetGet($Socket, "gBrowser.tabContainer.childNodes.length", 3000)
	ElseIf $sMode = "stylesheets" Then
		$sMode = "styleSheets"
	ElseIf $sMode = "frames" Then
		Return _FFSetGet($Socket,"content.frames.length")
	ElseIf Not ($sMode = "links" Or _
		$sMode = "images" Or _
		$sMode = "forms" Or _
		$sMode = "anchors") Then
		SetError(__FFError("_FFGetLength", $_FF_ERROR_InvalidValue, "$sMode: " & $sMode))
		Return -1
	EndIf

	Return _FFSetGet($Socket, "." & $sMode & ".length", 3000, $iTabIndex)
EndFunc   ;==>_FFGetLength

; #FUNCTION# ===================================================================
; Function ......: _FFGetLinks
; Description ...:
; Parameter(s) ..: ByRef $Socket
;                  $iMode=""        :length (nr), href, name, text, innerHTML,
;                                    target, id, port, protocol, search, hash
;                  $iTabIndex=-1
; Requirement ...:
; Return values .: Success      - Array with links or number of the links
;                  Failure      - Array[0] = 0
; User CallTip: .: _FFGetLinks(ByRef $Socket[, $sMode = "href"[, $iStart = 0[, $iEnd = 1[, $iTabIndex = -1]]]])
; Author(s) .....: Thorsten Willert
; Date ..........: 01. September 2007
; Note(s) .......:
; ==============================================================================
Func _FFGetLinks(ByRef $Socket, $sMode = "href", $iStart=0 , $iEnd=1, $iTabIndex = -1)
	Local $aLinks[1], $i, $sType

	If Not __FFIsSocket($Socket) Then
		SetError(__FFError("_FFGetLinks", $_FF_ERROR_SocketError, $Socket))
		Return $aLinks[0] = 0
	EndIf

	Local $sRetVal = _FFGetLength($Socket)

	If $sMode = "length" OR $sRetVal = 0 Then Return $sRetVal

	If $iEnd < $sRetVal And $iEnd <> 1 Then $sRetVal = $iEnd
	If $iStart > $iEnd Then $iStart = $iEnd

	If $sRetVal Then
		ReDim $aLinks[$sRetVal]

		Switch StringLower($sMode)
			Case "href"
				$sType = "href"
			Case "name"
				$sType = "name"
			Case "text"
				$sType = "text"
			Case "id"
				$sType = "id"
			Case "innerhtml"
				$sType = "innerHTML"
			Case "target"
				$sType = "target"
			Case "hash"
				$sType = "hash"
			Case "search"
				$sType = "search"
			Case "protocol"
				$sType = "protocol"
			Case "port"
				$sType = "port"
			Case Else
				SetError(__FFError("_FFGetLinks", $_FF_ERROR_InvalidValue, "$sMode: " & $sMode))
				Return $aLinks[0] = 0
		EndSwitch

		For $i = $iStart To $sRetVal-1
			$aLinks[$i] = _FFSetGet($Socket, ".links[" & $i & "]." & $sType, 20000, $iTabIndex)
		Next
	Else
		$aLinks[0] = 0
	EndIf

	Return $aLinks
EndFunc   ;==>_FFGetLinks

; #FUNCTION# ===================================================================
; Function ......: _FFConnect
; Description ...:
; Parameter(s) ..: $IP = 127.0.0.1
;                  $port = 4242
; Requirement ...:
; Return values .: Success      - $Socket
;                  Failure      - -1
; User CallTip: .: ([ByRef $IP[, $iPort = 4242[, iTimeOut = 60000]]])
; Author(s) .....: Thorsten Willert
; Date ..........: 07. June 2008
; Note(s) .......:
; ==============================================================================
Func _FFConnect($IP = "127.0.0.1", $iPort = 4242, $iTimeOut = 60000)
	; Default parameters
	If $IP = 	Default Then $IP = "127.0.0.1"
	If $iPort = 	Default Then $iPort = 4242
	If $iTimeOut =	Default Then $iTimeOut = 60000

	If Not __FFIsIP($IP) Then
		SetError(__FFError("_FFConnect", $_FF_ERROR_InvalidDataType, $IP))
		Return -1
	EndIf
	If Not __FFIsPort($iPort) Then
		SetError(__FFError("_FFConnect", $_FF_ERROR_InvalidDataType, $iPort))
		Return -1
	EndIf

	If $_FF_COM_TRACE Then ConsoleWrite("_FFConnect: IP: " & $IP & @CRLF)
	If $_FF_COM_TRACE Then ConsoleWrite("_FFConnect: Port: " & $iPort & @CRLF)

	TCPStartup()
	If Not @error Then
		$_FF_CON_DELAY = Ping($IP) +5
		If @error Then
			SetError(__FFError("_FFConnect", $_FF_ERROR_GeneralError, "Ping"))
			$_FF_CON_DELAY = $_FF_COM_DELAY_MAX
		EndIf
		If $_FF_COM_TRACE Then ConsoleWrite("_FFConnect: Connection Delay: " & $_FF_CON_DELAY & "ms" & @CRLF)

		Local $iTimeOutTimer = TimerInit()
		Local $Socket

		While 1
			$Socket = TCPConnect($IP, $iPort)
			Sleep(1000)
			If __FFIsSocket($Socket) Then ExitLoop
			If (TimerDiff($iTimeOutTimer) > $iTimeOut) Then ; Profil laden
				SetError(__FFError("_FFConnect", $_FF_ERROR_Timeout, "Can not connect to FireFox/MozRepl on: " & $IP & ":" & $iPort))
				Return -1
			EndIf
		Wend
		If $Socket <> -1 Then
			If $_FF_COM_TRACE Then ConsoleWrite("_FFConnect: Socket: " & $Socket & @CRLF)
			If __FFWaitForRepl($Socket) Then
				__FFSendJavaScripts($Socket)
				__FFGetBrowserVersion($Socket)
				__FFAddStatus($Socket)
				Return $Socket
			EndIf
		Else
			TCPShutdown()
			SetError(__FFError("_FFConnect", $_FF_ERROR_GeneralError, "TCPConnect"))
			Return -1
		EndIf
	Else
		SetError(__FFError("_FFConnect", $_FF_ERROR_GeneralError, "TCPStartup"))
		Return -1
	EndIf


	SetError($_FF_ERROR_GeneralError)
	Return -1
EndFunc   ;==>_FFConnect

; #FUNCTION# ===================================================================
; Function ......: _FFDisConnect
; Description ...:
; Parameter(s) ..: ByRef $Socket
; Requirement ...:
; Return values .: Success      - 1
;                  Failure      - 0
; User CallTip: .: (ByRef $Socket)
; Author(s) .....: Thorsten Willert
; Date ..........: 30. May 2008
; Note(s) .......:
; ==============================================================================
Func _FFDisConnect(ByRef $Socket)
	If __FFIsSocket($Socket) Then
		TCPCloseSocket($Socket)
		TCPShutdown()
		If Not @error Then
			If $_FF_COM_TRACE Then ConsoleWrite("_FFDisConnect: disconnected" & @CRLF)
			__FFRemoveStatus($Socket)
			Return 1
		Else
			SetError(__FFError("_FFDisConnect", $_FF_ERROR_GeneralError, "TCP Error"))
			Return 0
		EndIf
	Else
		SetError(__FFError("_FFDisConnect", $_FF_ERROR_SocketError, $Socket))
		Return 0
	EndIf

EndFunc   ;==>_FFDisConnect

; #FUNCTION# ====================================================================
; Function ......: _FFFormCheckBox
; Description ...:
; Parameter(s) ..: ByRef $Socket	: Socket
;                  $vCheckBox           : name, id or value
;                  $bChecked = true     : Checked = true, Unchecked = false
;                  $iIndex = 0          : CheckBox index (0-n)
;                  $sBMode = "index"	: CheckBox index, name, id or value
;                  $vForm = 0           : Form index or name
;                  $sMode = "index"     : Form index or name
;                  $iTabIndex = -1	: Tab (0-n)
; Requirement ...:
; Return values .: Success      - CheckBox state 1 or 0
;                  Failure      - ""
; User CallTip: .: _FFFormCheckBox(ByRef $Socket, $sName[, $bChecked=true[, $iIndex=0[, $sBMode="index"[, $vForm=0[, $sMode="index"[, $iTabIndex=-1]]]]]])
; Author(s) .....: Thorsten Willert
; Date ..........: 07. June 2008
; Note(s) .......:
; ==============================================================================
Func _FFFormCheckBox(ByRef $Socket, $sName, $bChecked = true, $iIndex = 0, $sBMode = "index", $vForm = 0, $sMode = "index" , $iTabIndex = -1)
	If Not __FFIsSocket($Socket) Then
		SetError(__FFError("_FFFormCheckBox", $_FF_ERROR_SocketError, $Socket))
		Return ""
	EndIf

	; Default parameters
	If $bChecked = 	Default Then $bChecked = true
	If $iIndex = 	Default Then $iIndex = 0
	If $sBMode = 	Default Then $sBMode = "index"
	If $vForm = 	Default Then $vForm = 0
	If $sMode = 	Default Then $sMode = "index"
	If $iTabIndex =	Default Then $iTabIndex = -1

	Local $sCommand, $sChecked
	$sBMode = StringLower($sBMode)
	$sMode = StringLower($sMode)

	; for JavaScript
	If $bChecked Then
		$sChecked = "true"
	ElseIf Not $bChecked Then
		$sChecked = "false"
	Else
		SetError(__FFError("_FFFormCheckBox", $_FF_ERROR_InvalidValue, $bChecked))
		Return ""
	EndIf

	; form index
	If IsInt($vForm) And $sMode = "index" Then
		$sCommand = '.forms[' & $vForm & ']'
	; form name or id
	ElseIf $sMode = "name" Then
		$sCommand = '.' & $vForm
	Else
		SetError(__FFError("_FFFormCheckBox", $_FF_ERROR_InvalidValue, $sMode & " " & $vForm))
		Return ""
	EndIf

	Select
		; box index
		Case $sBMode = "index" And IsInt($iIndex) And $iIndex > -1
			$sCommand &= '.elements[' & $iIndex & ']'
		; box name
		Case $sBMode = "name" And  IsInt($iIndex) And $iIndex > -1
			$sCommand &= '.' & $sName &  '[' & $iIndex & ']'
		; box id
		Case $sBMode = "id"
			$sCommand &= '.' & $sName
		; box value
		Case $sBMode = "value"
		; searching value
			Local $i
			Local $iBoxes = _FFSetGet($Socket, $sCommand &  '.length' )
			For $i = 0 to $iBoxes-1
				If _FFSetGet($Socket, $sCommand & '.elements[' & $i & '].value') =  $sName Then ExitLoop
			Next
			$sCommand &= '.elements[' & $i & ']'
		Case Else
			SetError(__FFError("_FFFormCheckBox", $_FF_ERROR_InvalidValue, "$sBMode: " & $sBMode))
			Return ""
	EndSelect

	; set
	$sCommand &= '.checked=' & $sChecked

	Return _FFSetGet($Socket, $sCommand, 3000, $iTabIndex)

EndFunc ;==> _FFFormCheckBox

; #FUNCTION# ====================================================================
; Function ......: _FFFormRadioButton
; Description ...:
; Parameter(s) ..: ByRef $Socket	: Socket
;                  $vRadioButton        : name, id or value
;                  $iIndex = 0          : RadioButton index (0-n)
;                  $sBMode = "index"	: RadioButton index, name, id or value
;                  $vForm = 0           : Form index or name
;                  $sMode = "index"     : Form index or name
;                  $iTabIndex = -1	: Tab (0-n)
; Requirement ...:
; Return values .: Success      - RadioButton state 1 or 0
;                  Failure      - ""
; User CallTip: .: _FFFormRadioButton(ByRef $Socket, $vRadioButton[, $iIndex=0[, $sBMode="index"[, $vForm=0[, $sMode="index"[, $iTabIndex=-1]]]]])
; Author(s) .....: Thorsten Willert
; Date ..........: 05. June 2008
; Note(s) .......:
; ==============================================================================
Func _FFFormRadioButton(ByRef $Socket, $vRadioButton, $iIndex = 0, $sBMode = "index", $vForm = 0, $sMode = "index" , $iTabIndex = -1)
	Return _FFFormCheckBox($Socket, $vRadioButton, true, $iIndex, $sBMode, $vForm, $sMode, $iTabIndex)
EndFunc ;==>  _FFFormRadioButton

; #FUNCTION# ===================================================================
; Function ......: _FFFormReset
; Description ...:
; Parameter(s) ..: ByRef $Socket
;                  $vForm = 0           : Index-number, name or id
;                  $sMode = "index"     : index, name or id
;                  $iTabIndex = -1
; Requirement ...:
; Return values .: Success      - <> 0
;                  Failure      - 0
; User CallTip: .: (ByRef $Socket[, $vForm = 0[, $sMode = "index"[, $iTabIndex = -1]]])
; Author(s) .....: Thorsten Willert
; Date ..........: 27. July 2008
; Note(s) .......:
; ==============================================================================
Func _FFFormReset(ByRef $Socket, $vForm = 0, $sMode = "index", $iTabIndex = -1)
	If Not __FFIsSocket($Socket) Then
		SetError(__FFError("_FFFormReset", $_FF_ERROR_SocketError, $Socket))
		Return 0
	EndIf

	$sMode = StringUpper($sMode)

	If IsInt($vForm) & $sMode = "index" Then
		_FFSetGet($Socket, '.forms[' & $vForm & '].reset()', 3000, $iTabIndex)
		Return SetError(@error,0,'')
	ElseIf $sMode = "name" Or $sMode = "id" Then
		_FFSetGet($Socket, '.' & $vForm & '.reset()', 3000, $iTabIndex)
		Return SetError(@error,0,'')
	Else
		SetError(__FFError("_FFFormReset", $_FF_ERROR_InvalidValue, "$sMode: " & $sMode))
		Return 0
	EndIf

	Return 0
EndFunc   ;==>_FFFormReset

; #FUNCTION# ===================================================================
; Function ......: _FFFormSubmit
; Description ...:
; Parameter(s) ..: ByRef $Socket
;                  $vForm = 0           : Index-number, name or id
;                  $sMode = "index"     : index, name or id
;                  $iTabIndex = -1
; Requirement ...:
; Return values .: Success      - <> 0
;                  Failure      - 0
; User CallTip: .: (ByRef $Socket[, $vForm = 0[, $sMode = "index"[, $iTabIndex = -1]]])
; Author(s) .....: Thorsten Willert
; Date ..........: 27. July 2008
; Note(s) .......:
; ==============================================================================
Func _FFFormSubmit(ByRef $Socket, $vForm = 0, $sMode = "index", $iTabIndex = -1)
	If Not __FFIsSocket($Socket) Then
		SetError(__FFError("_FFFormSubmit", $_FF_ERROR_SocketError, $Socket))
		Return 0
	EndIf

	$sMode = StringUpper($sMode)

	If IsInt($vForm) And $sMode = "index" Then
		_FFSetGet($Socket, '.forms[' & $vForm & '].submit()', 10000, $iTabIndex)
		Return SetError(@error,0,'')
	ElseIf $sMode = "name" Or $sMode = "id" Then
		_FFSetGet($Socket, '.' & $vForm & '.submit()', 10000, $iTabIndex)
		Return SetError(@error,0,'')
	Else
		SetError(__FFError("_FFFormSubmit", $_FF_ERROR_InvalidValue, "$sMode: " & $sMode))
		Return 0
	EndIf

	Return 0
EndFunc   ;==>_FFFormSubmit

; #FUNCTION# ===================================================================
; Function ......: _FFGetValuetById
; Description ...:
; Parameter(s) ..: ByRef $Socket
;                  $sName
;                  $iTabIndex=-1
; Requirement ...:
; Return values .: Success      - Value
;                  Failure      - ""
; User CallTip: .: (ByRef $Socket, $sName [, $iTabIndex=-1])
; Author(s) .....: Thorsten Willert
; Date ..........: 27. August 2007
; Note(s) .......:
; ==============================================================================
Func _FFGetValueById(ByRef $Socket, $sID, $iTabIndex = -1)
	If Not __FFIsSocket($Socket) Then
		SetError(__FFError("_FFGetValueById", $_FF_ERROR_SocketError, $Socket))
		Return ""
	EndIf

	Local $sRetVal = _FFSetGet($Socket, '.getElementById("' & $sID & '").value', 3000, $iTabIndex)

	If Not StringInStr($sRetVal, "!!!") Then
		Return $sRetVal
	Else
		SetError(__FFError("_FFGetValueById", $_FF_ERROR_NoMatch, $sID))
		Return ""
	EndIf

EndFunc   ;==>_FFGetValueById

; #FUNCTION# ===================================================================
; Function ......: _FFGetValueByName
; Description ...:
; Parameter(s) ..: ByRef $Socket
;                  $sName
;                  $iIndex
;                  $iTabIndex=-1
; Requirement ...:
; Return values .: Success      - Value
;                  Failure      - ""
; User CallTip: .: (ByRef $Socket, $sName[, $iTabIndex=-1])
; Author(s) .....: Thorsten Willert
; Date ..........: 25. August 2007
; Note(s) .......:
; ==============================================================================
Func _FFGetValueByName(ByRef $Socket, $sName, $iIndex = 0, $iTabIndex = -1)
	If Not __FFIsSocket($Socket) Then
		SetError(__FFError("_FFGetValueByName", $_FF_ERROR_SocketError, $Socket))
		Return ""
	EndIf

	Local $sRetVal = _FFSetGet($Socket, '.getElementsByName("' & $sName & '")[' & $iIndex & '].value', 3000, $iTabIndex)

	If Not StringInStr($sRetVal, "!!!") Then
		Return $sRetVal
	Else
		SetError(__FFError("_FFGetValueByName", $_FF_ERROR_NoMatch, $sName))
		Return ""
	EndIf

EndFunc   ;==>_FFGetValueByName

; #FUNCTION# ===================================================================
; Name ..........: _FFKeyPress
; Description ...: KeyPress
; Syntax ........: _FFKeyPress(ByRef $Socket, $iKeyCode[, $iTabIndex = -1])
; Parameter(s): .:
;                  $Socket      -
;                  $iKeyCode     - ASCII-KeyCode
;                  $iTabIndex   - Optional: (Default = -1)
; Return Value ..: Success      - 1
;                  Failure      - 0
; Author(s) .....: Thorsten Willert
; Modified ......: 9. August 2008
; Related .......:
; Example .......: Yes
; ==============================================================================
Func _FFKeyPress(ByRef $Socket, $iKeyCode, $iTabIndex = -1)
	If $iTabIndex > -1 Then _FFTabSelect($Socket,"index",$iTabIndex)

	If $iKeyCode < 0 Or $iKeyCode > 255 Then
		SetError(__FFError("_FFKeyPress",$_FF_ERROR_InvalidValue, $iKeyCode))
		Return 0
	EndIf

	__FFSend($Socket, "FF_AutoItScript.SimulateKey(" & $iKeyCode & ")" )
	If Not @error Then Return __FFRecv($Socket)

	Return 0
EndFunc   ;==>_FFKeyPress

; #FUNCTION# ===================================================================
; Function ......: _FFLoadWait
; Description ...:
; Parameter(s) ..: ByRef $Socket
;                  $iDelay = 0
;                  $iTimeOut = 10000
;                  $iPercent = 100
; Requirement ...:
; Return values .: Success      - 1
;                  Failure      - 0
; User CallTip: .: (ByRef $Socket[, $iDelay = 0[, $iTimeOut = 10000[, $iPercent = 100]])
; Author(s) .....: Thorsten Willert
; Date ..........: 9. August 2008
; Note(s) .......:
; ==============================================================================
Func _FFLoadWait(ByRef $Socket, $iDelay = 0, $iTimeOut = 10000, $iPercent = 100)
	If Not __FFIsSocket($Socket) Then
		SetError(__FFError("_FFOpenURL", $_FF_ERROR_SocketError))
		Return 0
	EndIf

	Local $TimeOutTimer = TimerInit()
	Local $tmp

	Sleep($iDelay)

	_FFSetGet($Socket,"window.content.status='_FFLoadWait ...'")
	While (TimerDiff($TimeOutTimer) < $iTimeOut)
		Sleep(500)

		$tmp = _FFSetGet($Socket, "document.getElementById('statusbar-icon').value")
		If @error Then
			_FFSetGet($Socket,"window.content.status=''")
			Return 0
		EndIf
		If $tmp >= $iPercent Then
			_FFSetGet($Socket,"window.content.status=''")
			Return 1
		EndIf
	Wend

	_FFSetGet($Socket,"window.content.status=''")
	SetError(__FFError("_FFLoadWait", $_FF_ERROR_Timeout, "Can not check site status."))
	Return 0

EndFunc   ;==>_FFLoadWait

; #FUNCTION# ===================================================================
; Function ......: _FFOpenURL
; Description ...:
; Parameter(s) ..: ByRef $Socket
;                  $sURL
;                  $iTabIndex = -1
;                  $bWait = True
; Requirement ...:
; Return values .: Success      - 1
;                  Failure      - 0
; User CallTip: .: (ByRef $Socket, $sURL[, $iTabIndex = 0[, $bWait = True]])
; Author(s) .....: Thorsten Willert
; Date ..........: 03. June 2008
; Note(s) .......:
; ==============================================================================
Func _FFOpenURL(ByRef $Socket, $sURL, $iTabIndex = -1, $bWait = True)
	If Not __FFIsSocket($Socket) Then
		SetError(__FFError("_FFOpenURL", $_FF_ERROR_SocketError))
		Return 0
	EndIf
	If Not __FFIsURL($sURL) Then
		SetError(__FFError("_FFOpenURL", $_FF_ERROR_InvalidDataType, $sURL))
		Return 0
	EndIf

	Local $iRet = 0, $iErr

	If StringLeft($sURL, 7) = "chrome:" Then $sURL = __FFChromeSelect(StringMid($sURL, 8))

	If $iTabIndex > -1 Then _FFTabSelect($Socket, "index", $iTabIndex)

	If StringInStr(_FFSetGet($Socket, '.location.href="' & $sURL & '"'), $sURL) Then $iRet = 1
	$iErr = @error

	If $bWait Then _FFLoadWait($Socket)

	SetError($iErr)
	Return $iRet
EndFunc   ;==>_FFOpenURL

; #FUNCTION# ===================================================================
; Function ......: _FFQuit
; Description ...:
; Parameter(s) ..: ByRef $Socket
; Requirement ...:
; Return values .: Success      - 1
;                  Failure      - 0
; User CallTip: .: (ByRef $Socket)
; Author(s) .....: Thorsten Willert
; Date ..........: 07. June 2008
; Note(s) .......:
; ==============================================================================
Func _FFQuit(ByRef $Socket)
	If Not __FFIsSocket($Socket) Then
		SetError(__FFError("_FFQuit", $_FF_ERROR_SocketError))
		Return 0
	EndIf

	TCPSend($Socket, "close()" & @CRLF)
	If Not @error Then
		__FFRemoveStatus($Socket)
		Return 1
	Else
		Return 0
	EndIf

EndFunc   ;==>_FFQuit

; #FUNCTION# ===================================================================
; Function ......:  _FFReadHTML
; Description ...:
; Parameter(s) ..: ByRef $Socket
; Requirement ...:
; Return values .: Success      - All between <html> and </html>
;                  Failure      - ""
; User CallTip: .: (ByRef $Socket[, $iTabIndex = -1[, $bCompress = False]])
; Author(s) .....: Thorsten Willert
; Date ..........: 01. September 2007
; Note(s) .......:
; ==============================================================================
Func _FFReadHTML(ByRef $Socket, $iTabIndex = -1, $bCompress = False)
	If Not __FFIsSocket($Socket) Then
		SetError(__FFError(" _FFReadHTML", $_FF_ERROR_SocketError, $Socket))
		Return ""
	EndIf

	Local $sRet = _FFSetGet($Socket, ".documentElement.innerHTML", 10000, $iTabIndex)
	Local $iErr = @error
	If $bCompress Then $sRet = StringRegExpReplace($sRet, "[[:space:]]{2,}", "")

	SetError($iErr)
	Return $sRet
EndFunc   ;==>_FFReadHTML

; #FUNCTION# ===================================================================
; Function ......:  _FFReadText
; Description ...:
; Parameter(s) ..: ByRef $Socket
; Requirement ...:
; Return values .: Success      - Text
;                  Failure      - ""
; User CallTip: .: ByRef $Socket[, $iTabIndex = -1[, $bCompress = False]])
; Author(s) .....: Thorsten Willert
; Date ..........: 01. September 2007
; Note(s) .......:
; ==============================================================================
Func _FFReadText(ByRef $Socket, $iTabIndex = -1, $bCompress = False)
	If Not __FFIsSocket($Socket) Then
		SetError(__FFError("_FFReadText", $_FF_ERROR_SocketError, $Socket))
		Return ""
	EndIf

	Local $sRet = _FFSetGet($Socket, ".documentElement.textContent", 10000, $iTabIndex)
	Local $iErr = @error
	If $bCompress Then $sRet = StringRegExpReplace($sRet, "[[:space:]]{3,}", " ")

	SetError($iErr)
	Return $sRet
EndFunc   ;==>_FFReadText

; #FUNCTION# ===================================================================
; Name ..........: _FFSearch
; Description ...:
; Syntax ........: _FFSearch(ByRef $Socket, $sSearchString[, $bCaseSensitive = false[, $bBackwards = false[, $bWrapAround = true[, $bWholeWord = false[, $bSearchInFrames = true[, $iDelay = 0]]]]]])
; Parameter(s): .:
;                  $Socket      -
;                  $sSearchString - Text
;                  $bCaseSensitive - Optional: (Default = false) :
;                  $bBackwards  - Optional: (Default = false) :
;                  $bWrapAround - Optional: (Default = true) :
;                  $bWholeWord  - Optional: (Default = false) :
;                  $bSearchInFrames - Optional: (Default = true) :
;                  $iDelay      - Optional: (Default = 0) :
; Return Value ..: Success      - true / false
;                  Failure      - ""
; Author(s) .....:
; Modified ......: Sat Sep 13 14:37:06 CEST 2008
; Version .......: 1.0
; Example .......: Yes
; ==============================================================================
Func _FFSearch(ByRef $Socket, $sSearchString, $bCaseSensitive = false, $bBackwards = false, $bWrapAround = true, $bWholeWord = false, $bSearchInFrames = true, $iDelay = 0)
    If Not __FFIsSocket($Socket) Then
        SetError(__FFError("_FFSearch", $_FF_ERROR_SocketError))
        Return ""
    EndIf
    If $sSearchString = "" Then
        SetError(__FFError("_FFSearch", $_FF_ERROR_InvalidValue, "$sSearchString: " & $sSearchString))
        Return ""
    EndIf

    If $bCaseSensitive = Default Then $bCaseSensitive = false
    If $bBackwards = Default Then $bBackwards = false
    If $bWrapAround = Default Then $bWrapAround = true
    If $bWholeWord = Default Then $bWholeWord = false
    If $bSearchInFrames = Default Then $bSearchInFrames = true

    Local $sCommand = 'content.find("' & $sSearchString & '", ' & _
            __FFB2S($bCaseSensitive) & ', ' & _
            __FFB2S($bBackwards) & ', ' & _
            __FFB2S($bWrapAround) & ', ' & _
            __FFB2S($bWholeWord) & ', ' & _
            __FFB2S($bSearchInFrames) & ', false)'

    Return _FFSetGet($Socket, $sCommand, 30 + $_FF_CON_DELAY + $iDelay)

EndFunc   ;==> _FFSearch

; #FUNCTION# ===================================================================
; Function ......: _FFSetGet
; Description ...:
; Parameter(s) ..: ByRef $Socket
;                  $sArg
;                  $iTimeOut=10000ms
;                  $iTabIndex=-1
; Requirement ...:
; Return values .: Success      - String
;                  Failure      - ""
; User CallTip: .: (ByRef $Socket, $sArg[, [,$iTimeOut=10000[,$iTabIndex=-1]])
; Author(s) .....: Thorsten Willert
; Date ..........: 21. June 2008
; Note(s) .......:
; ==============================================================================
Func _FFSetGet(ByRef $Socket, $sArg, $iTimeOut = 10000, $iTabIndex = -1)
	If Not __FFIsSocket($Socket) Then
		SetError(__FFError("_FFSetGet", $_FF_ERROR_SocketError))
		Return ""
	EndIf

	Local $sRet, $iFrameSelected

	If StringLeft($sArg, 1) = "." Then $sArg = "content.document" & $sArg
	$iFrameSelected = _FFFrameSelected($Socket)
	If $iFrameSelected > -1 Then $sArg = StringReplace($sArg, "content.document", "content.frames[" & $iFrameSelected & "].document", 1)

	If $_FF_VERSION >= 3 Then $sArg = StringReplace($sArg, "content.", "content.wrappedJSObject." )

	If IsInt($iTabIndex) And $iTabIndex >= -1 Then
		If $iTabIndex >= 0 Then _FFTabSelect($Socket, "index", $iTabIndex)
		If __FFSend($Socket, $sArg) Then
			$sRet = __FFRecv($Socket, $iTimeOut)
			If @error Then
				SetError(__FFError("_FFSetGet", $_FF_ERROR_RetValue, $sRet))
				$sRet = ""
			EndIf
			Return $sRet
		EndIf
	Else
		SetError(__FFError("_FFSetGet", $_FF_ERROR_InvalidDataType, "TabIndex"))
		Return ""
	EndIf

	Return ""
EndFunc   ;==>_FFSetGet

; #FUNCTION# ===================================================================
; Function ......: _FFSetValueById
; Description ...:
; Parameter(s) ..: ByRef $Socket
;                  $sID
;                  $sValue
;                  $iTabIndex=-1
; Requirement ...:
; Return values .: Success      - String
;                  Failure      - ""
; User CallTip: .: (ByRef $Socket, $sName[, $sValue[, $iTabIndex=-1]])
; Author(s) .....: Thorsten Willert
; Date ..........: 26. June 2008
; Note(s) .......:
; ==============================================================================
Func _FFSetValueById(ByRef $Socket, $sID, $sValue = "", $iTabIndex = -1)
	If Not __FFIsSocket($Socket) Then
		SetError(__FFError("_FFSetValueById", $_FF_ERROR_SocketError, $Socket))
		Return ""
	EndIf

	Local $sValue_old = $sValue

	$sValue = StringRegExpReplace($sValue,"([\\""])","\\$1")
	$sValue = StringReplace($sValue,@crlf,"\n")
	$sValue = StringReplace($sValue,@cr,"\r")
	$sValue = StringReplace($sValue,@tab,"\t")

	Local $sRetVal = _FFSetGet($Socket, '.getElementById("' & $sID & '").value="' & $sValue & '"', 3000, $iTabIndex)

	If StringInStr($sRetVal, $sValue_old) Then
		SetError($_FF_ERROR_Success)
		Return $sRetVal
	Else
		SetError(__FFError("_FFSetValueById", $_FF_ERROR_NoMatch))
		Return ""
	EndIf

EndFunc   ;==>_FFSetValueById

; #FUNCTION# ===================================================================
; Function ......: _FFSetValueByName
; Description ...:
; Parameter(s) ..: ByRef $Socket
;                  $sName
;                  $iIndex
;                  $iTabIndex=-1
; Requirement ...:
; Return values .: Success      - Value
;                  Failure      - ""
; User CallTip: .:((ByRef $Socket, $sName[, $iTabIndex=-1])
; Author(s) .....: Thorsten Willert
; Date ..........: 26. June 2008
; Note(s) .......:
; ==============================================================================
Func _FFSetValueByName(ByRef $Socket, $sName, $sValue = "", $iIndex = 0, $iTabIndex = -1)
	If Not __FFIsSocket($Socket) Then
		SetError(__FFError("_FFSetValueByName", $_FF_ERROR_SocketError, $Socket))
		Return ""
	EndIf

	Local $sValue_old = $sValue

	$sValue = StringRegExpReplace($sValue,"([\\""])","\\$1")
	$sValue = StringReplace($sValue,@crlf,"\n")
	$sValue = StringReplace($sValue,@cr,"\r")
	$sValue = StringReplace($sValue,@tab,"\t")

	Local $sRetVal = _FFSetGet($Socket, '.getElementsByName("' & $sName & '")[' & $iIndex & '].value="' & $sValue & '"', 3000, $iTabIndex)

	If StringInStr($sRetVal, $sValue_old) Then
		SetError($_FF_ERROR_Success)
		Return $sRetVal
	Else
		SetError(__FFError("_FFSetValueByName", $_FF_ERROR_NoMatch))
		Return ""
	EndIf

EndFunc   ;==>_FFSetValueByName

; #FUNCTION# ===================================================================
; Function ......: _FFStart
; Description ...:
; Parameter(s) ..: $sURL = "about:blank"     Start URL
;                  $sProfile = "default"     UserProfile
;                  $bHide = false
;                  $iNewProcess = 1          0 = Connect to existing process
;                                            1 = Start new process
;                                            2 = Connect to an existing process, on failure start a new process
;                                           +8 = Starting FF with parameter -no-remote
;                  $IP = 127.0.0.1
;                  $iPort = 4242
;                  $sBrowser = "firefox"
; Requirement ...:
; Return values .: Success      - Socket
;                  Failure      - -1
; User CallTip: .: ([$sURL = "about:blank"[, $sProfile = "default"[, $iMode = 1[, $bHide = False[, $IP = "127.0.0.1"[, $iPort = 4242[, $sBrowser = "firefox"]]]]]])
; Author(s) .....: Thorsten Willert
; Date ..........: 22. July 2008
; Note(s) .......:
; ==============================================================================
Func _FFStart($sURL = "about:blank", $sProfile = "default", $iMode = 1, $bHide = False, $IP = "127.0.0.1", $iPort = 4242)
	; Default parameters
	If $sURL = 	Default Then $sURL = "about:blank"
	If $IP = 	Default Then $IP = "127.0.0.1"
	If $iPort = 	Default Then $iPort = 4242

	If Not __FFIsURL($sURL) Then
		SetError(__FFError("_FFStart", $_FF_ERROR_InvalidDataType, $sURL))
		Return -1
	EndIf
	If Not __FFIsIP($IP) Then
		SetError(__FFError("_FFStart", $_FF_ERROR_InvalidDataType, $IP))
		Return -1
	EndIf
	If Not __FFIsPort($iPort) Then
		SetError(__FFError("_FFStart", $_FF_ERROR_InvalidDataType, $iPort))
		Return -1
	EndIf

	; Default parameters
	If $sProfile = 	Default Then $sProfile = "default"
	If $iMode = 	Default Then $iMode = 1
	If $bHide = 	Default Then $bHide = False

	Local $Socket = -1, $PID = -1, $bNoRemote = False

	If $iMode >=8 Then
		$iMode -= 8
		$bNoRemote = True
	EndIf

	Switch $iMode
		Case 0
			If ProcessExists($_FF_PROC_NAME) Then $Socket = _FFConnect($IP, $iPort)
		Case 1
			__FFStartProcess($sProfile, $bNoRemote, $bHide, $iPort)
			$PID = @extended
			If ProcessExists($_FF_PROC_NAME) Then $Socket = _FFConnect($IP, $iPort)
		Case 2
			$Socket = _FFConnect($IP, $iPort, 3000)
			If $Socket = -1 Then
				__FFStartProcess($sProfile, $bNoRemote, $bHide, $iPort)
				$PID = @extended
				If ProcessExists($_FF_PROC_NAME) Then $Socket = _FFConnect($IP, $iPort)
			EndIf
		Case Else
			SetError(__FFError("_FFStart", $_FF_ERROR_InvalidValue, "$iMode: " & $iMode))
			Return -1
	EndSwitch

	If $Socket <> -1 Then
		Sleep(2000)
		_FFOpenURL($Socket, $sURL)
	EndIf

	SetExtended($PID)
	Return $Socket
EndFunc   ;==>_FFStart

; #FUNCTION# ===================================================================
; Function ......: _FFTabAdd
; Description ...:
; Parameter(s) ..: $Socket
;                  $sURL
;                  $bSelect
; Requirement ...:
; Return values .: Success      -
;                  Failure      -
; User CallTip: .: _FFTabAdd(ByRef $Socket[, $sURL="about:blank"[, $bSelect = true]])
; Author(s) .....: Thorsten Willert
; Date ..........: 16. March 2008
; Note(s) .......:
; ==============================================================================
Func _FFTabAdd(ByRef $Socket, $sURL = "about:blank", $bSelect = true)
	If Not __FFIsSocket($Socket) Then
		SetError(__FFError("_FFTabAdd", $_FF_ERROR_SocketError))
		Return 0
	EndIf

	If Not $bSelect Then
		_FFSetGet($Socket, "gBrowser.addTab()", 3000)
	Else
		_FFSetGet($Socket, "gBrowser.addTab()"  & @CRLF & _
		"gBrowser.tabContainer.selectedIndex = gBrowser.tabContainer.childNodes.length - 1", 3000)
	EndIf

	If $sURL <> "about:blank" Then _FFOpenURL($Socket,$sURL)

	Return

EndFunc ;==> _FFTabAdd

; #FUNCTION# ===================================================================
; Function ......: _FFTabClose
; Description ...:
; Parameter(s) ..: ByRef $Socket: Connection socket to FireFox/MozRepl
;                  $vTab        : Index or label
;                  $sMode = "index" : index or label
; Requirement ...:
; Return values .: Success      -
;                  Failure      -
; User CallTip: .: ($Socket[, $vTab = -1[, $sMode = "index"]])
; Author(s) .....: Thorsten Willert
; Date ..........: 03. June 2008
; Note(s) .......:
; ==============================================================================
Func _FFTabClose(ByRef $Socket, $vTab = -1, $sMode = "index")
	If Not __FFIsSocket($Socket) Then
		SetError(__FFError("_FFTabClose", $_FF_ERROR_SocketError))
		Return 0
	EndIf

	$sMode = StringLower($sMode)

	If $vTab = -1 Then
		Return _FFSetGet( $Socket, "gBrowser.removeCurrentTab()", 3000 )
	ElseIf $vTab > -1 And $sMode = "index" Then
		_FFTabSelect($Socket, $vTab, "index")
		Return _FFSetGet( $Socket, "gBrowser.removeCurrentTab()", 3000 )
	ElseIf $sMode = "label" Then
		_FFTabSelect($Socket, $vTab, "label")
		Return _FFSetGet( $Socket, "gBrowser.removeCurrentTab()", 3000 )
	Else
		SetError(__FFError("_FFTabClose", $_FF_ERROR_InvalidValue, "$sMode: " & $sMode ))
		Return 0
	EndIF

EndFunc ;==> _FFTabClose

; #FUNCTION# ===================================================================
; Function ......: _FFTabCloseAll
; Description ...: Closes all Tabs except the selected
; Parameter(s) ..: ByRef $Socket: Connection socket to FireFox/MozRepl
; Requirement ...:
; Return values .: Success      -
;                  Failure      -
; User CallTip: .: _FFTabCloseAll(ByRef $Socket)
; Author(s) .....: Thorsten Willert
; Date ..........: 26. June 2008
; Note(s) .......:
; ==============================================================================
Func _FFTabCloseAll(ByRef $Socket)
	If Not __FFIsSocket($Socket) Then
		SetError(__FFError("_FFTabCloseAll", $_FF_ERROR_SocketError))
		Return 0
	EndIf

	Return _FFSetGet($Socket, "gBrowser.removeAllTabsBut(gBrowser.selectedTab)")

EndFunc ;==> _FFTabClose

; #FUNCTION# ===================================================================
; Function ......: _FFTabExists
; Description ...:
; Parameter(s) ..: ByRef $Socket
;                  $sLabel
; Requirement ...:
; Return values .: Success      - Tab-index 0-n
;                  Failure      - -1
; User CallTip: .: (ByRef $Socket, $sLabel)
; Author(s) .....: Thorsten Willert
; Date ..........: 03. June 2008
; Note(s) .......:
; ==============================================================================
Func _FFTabExists(ByRef $Socket, $sLabel)
	If Not __FFIsSocket($Socket) Then
		SetError(__FFError("_FFTabExists", $_FF_ERROR_SocketError))
		Return -1
	EndIf

	Return _FFSetGet($Socket,"FF_AutoItScript.SearchTab('" & $sLabel & "')", 3000)

EndFunc ;==> _FFTabExists

; #FUNCTION# ===================================================================
; Function ......: _FFTabLength
; Description ...:
; Parameter(s) ..: ByRef $Socket
; Requirement ...:
; Return values .: Success      - Number of Tabs 0-n
;                  Failure      -
; User CallTip: .: (ByRef $Socket)
; Author(s) .....: Thorsten Willert
; Date ..........: 30. May 2008
; Note(s) .......:
; ==============================================================================
Func _FFTabLength(ByRef $Socket)
	Return _FFGetLength($Socket,"tabs")
EndFunc ;==> _FFTabExists

; #FUNCTION# ===================================================================
; Function ......: _FFTabSelect
; Description ...:
; Parameter(s) ..: ByRef $Socket
;                  $vTab                : Label or index (0-n)
;                  $sMode               : "index", "prev", "next", "first", "last", "label"
; Requirement ...:
; Return values .: Success      -
;                  Failure      - 0
; User CallTip: .: _FFTabSelect(ByRef $Socket [, $sMode = "index" [, $vTab = 0]])
; Author(s) .....: Thorsten Willert
; Date ..........: 03. June 2008
; Note(s) .......:
; ==============================================================================
Func _FFTabSelect(ByRef $Socket, $sMode = "index", $vTab = 0)
	If Not __FFIsSocket($Socket) Then
		SetError(__FFError("_FFTabSelect", $_FF_ERROR_SocketError))
		Return 0
	EndIf

	Local $sCommand = "gBrowser.tabContainer"
	$sMode = StringLower($sMode)

	If IsInt($vTab) And $sMode = "index" Then
		$sCommand &= ".selectedIndex = " & $vTab
	Else
		Switch $sMode
			Case "prev"
				$sCommand = "gBrowser.tabContainer.advanceSelectedTab( 0, true )"
			Case "next"
				$sCommand = "gBrowser.tabContainer.advanceSelectedTab( 1, true )"
			Case "first"
				$sCommand = "gBrowser.tabContainer.selectedIndex = 0"
			Case "last"
				$sCommand = "gBrowser.tabContainer.selectedIndex = gBrowser.tabContainer.childNodes.length -1"
			Case "label"
				Local $iIndex = _FFTabExists($Socket, $vTab)
				If $iIndex > -1 Then
					$sCommand = "gBrowser.tabContainer.selectedIndex = " & $iIndex
				Else
					Return 0
				EndIf
			Case Else
				SetError(__FFError("_FFTabSelect", $_FF_ERROR_InvalidValue, "$sMode: " & $sMode))
				Return 0
		EndSwitch
	EndIf

	Return _FFSetGet($Socket, $sCommand, 3000)

EndFunc ;==> _FFTabSelect

; #FUNCTION# ===================================================================
; Function ......: _FFTabSelected
; Description ...:
; Parameter(s) ..: $Socket
;                  $sMode                : Label or Index
; Requirement ...:
; Return values .: Success      - Index 0-n or Label
;                  Failure      - -1
; User CallTip: .: (ByRef $Socket[, $sMode = "index"])
; Author(s) .....: Thorsten Willert
; Date ..........: 16. March 2008
; Note(s) .......:
; ==============================================================================
Func _FFTabSelected(ByRef $Socket, $sMode = "index")
	If Not __FFIsSocket($Socket) Then
		SetError(__FFError("_FFTabSelected", $_FF_ERROR_SocketError))
		Return -1
	EndIf

	$sMode = StringLower($sMode)

	Switch $sMode
		Case "index"
			Return _FFSetGet($Socket, "gBrowser.tabContainer.selectedIndex", 3000)
		Case "label"
			Return _FFSetGet($Socket, "gBrowser.mTabs[gBrowser.tabContainer.selectedIndex].label", 3000)
		Case Else
			SetError(__FFError("_FFTabSelected", $_FF_ERROR_InvalidValue, "$sMode: " & $sMode))
			Return -1
	EndSwitch

EndFunc ;==> _FFTabSelectedIndex

; #FUNCTION# ===================================================================
; Function ......: _FFTableWriteToArray
; Description ...:
; Parameter(s) ..: ByRef $Socket         : Connection socket to FireFox/MozRepl
;                  $vTable               : Tableindex, name or id
;                  $sMode="index"        : Mode how to match $vTable
;                  $sReturnMode = "text" : ReturnMode (alternative: "html")
;                  $fTransponse = False  : Switch Rows and Columns
;                  iTabIndex = -1        : Index of the Tab, where $vTable is allocated
;
; Requirement ...:
; Return values .: Success      - Array containing Contents of the table
;                  Failure      - 0
; User CallTip: .: _FFTableWriteToArray (ByRef $Socket, $vTable, $sMode = "index", $sReturnMode = "text", $fTransponse = False, $iTabIndex = -1)
; Author(s) .....: Thorsten Willert & Johannes Schirmer
; Date ..........: 23. June 2008
; Note(s) .......:
; ==============================================================================
Func _FFTableWriteToArray(ByRef $Socket, $vTable, $sMode = "index", $sReturnMode = "text", $fTransponse = False, $iTabIndex = -1)
	If Not __FFIsSocket($Socket) Then
		SetError(__FFError("_FFTableWriteToArray", $_FF_ERROR_SocketError, $Socket))
		Return 0
	EndIf

	Local $sArg

	If IsInt($vTable) And $sMode = "index" Then
		$sArg = "content.document.getElementsByTagName('tbody')[" & $vTable & "]"
	ElseIf $sMode = "name" Or $sMode = "id" Then
		$sArg = "content.document." & $vTable
	Else
		SetError(__FFError("_FFTableWriteToArray", $_FF_ERROR_InvalidValue, "$sMode: " & $sMode))
		Return 0
	EndIf
	If $sReturnMode = "text" Then
		$sReturnMode = ".textContent"
	ElseIf $sReturnMode = "html" Then
		$sReturnMode = ".innerHTML"
	Else
		SetError(__FFError("_FFTableWriteToArray", $_FF_ERROR_InvalidValue, "$sReturnMode: " & $sReturnMode))
		Return 0
	EndIf
	If Not IsBool($fTransponse) Then
		SetError(__FFError("_FFTableWriteToArray", $_FF_ERROR_InvalidValue, "$fTransponse: " & $fTransponse))
		Return 0
	EndIf
	_FFSetGet($Socket, $sArg, 3000, $iTabIndex)
	If @error Then
		SetError(__FFError("_FFTableWriteToArray", $_FF_ERROR_NoMatch, "$vTable: " & $vTable & ", $sMode: " & $sMode))
		Return 0
	EndIf
	Local $i_cols = 0, $trs, $tds, $i_col, $col, $row
	$trs = _FFSetGet($Socket, $sArg & ".getElementsByTagName('tr').length", 3000, $iTabIndex)
	For $i = 0 To $trs - 1
		$tds = _FFSetGet($Socket, $sArg & ".getElementsByTagName('tr')[" & $i & "].getElementsByTagName('td').length", 3000, $iTabIndex)
		$i_col = 0
		For $i2 = 0 To $tds - 1
			$i_col = $i_col + _FFSetGet($Socket, $sArg & ".getElementsByTagName('tr')[" & $i & "].getElementsByTagName('td')[" & $i2 & "].colSpan", 3000, $iTabIndex)
		Next
		If $i_col > $i_cols Then $i_cols = $i_col
	Next
	Local $a_TableCells[$i_cols][$trs]
	$row = 0
	For $i = 0 To $trs - 1
		$tds = _FFSetGet($Socket, $sArg & ".getElementsByTagName('tr')[" & $i & "].getElementsByTagName('td').length", 3000, $iTabIndex)
		$col = 0
		For $i2 = 0 To $tds - 1
			$a_TableCells[$col][$row] = _FFSetGet($Socket, $sArg & ".getElementsByTagName('tr')[" & $i & "].getElementsByTagName('td')[" & $i2 & "]" & $sReturnMode, 3000, $iTabIndex)
			$col = $col + _FFSetGet($Socket, $sArg & ".getElementsByTagName('tr')[" & $i & "].getElementsByTagName('td')[" & $i2 & "].colSpan", 3000, $iTabIndex)
		Next
		$row = $row + 1
	Next
	If $fTransponse Then
		Local $i_d1 = UBound($a_TableCells, 1), $i_d2 = UBound($a_TableCells, 2), $aTmp[$i_d2][$i_d1]
		For $i = 0 To $i_d2 - 1
			For $j = 0 To $i_d1 - 1
				$aTmp[$i][$j] = $a_TableCells[$j][$i]
			Next
		Next
		$a_TableCells = $aTmp
	EndIf
	Return $a_TableCells
EndFunc   ;==>_FFTableWriteToArray

;===============================================================================
;
; Internal Functions with names starting with two underscores will not be documented
; as user functions
;
; #INTERNAL_USE_ONLY#===========================================================
; Function ......: __FFRecv
; Description ...: Formats the return value from MozRepl
; Parameter(s) ..: ByRef $Socket
;                  $iTimeOut = 10000
; Requirement ...:
; Return values .: Success      - Return value from MozRepl
;                  Failure      - ""
; User CallTip: .: (ByRef $Socket[, $iTimeOut = 10000]])
; Author(s) .....: Thorsten Willert
; Date ..........: 06. June 2008
; Note(s) .......:
; ==============================================================================
Func __FFRecv(ByRef $Socket, $iTimeOut = 10000)
	If Not __FFIsSocket($Socket) Then
		SetError(__FFError("__FFRecv", $_FF_ERROR_SocketError, $Socket))
		Return ""
	EndIf

	Local $sRet = __FFWaitForRepl($Socket, $iTimeOut)
	Local $iErr = @error
	$sRet = StringStripWS($sRet,3)

	; String to bool
	If $sRet = "true" Then
		$sRet = 1
	ElseIf $sRet = "false" Then
		$sRet = 0
	EndIf

	; Removing leading and trailing "
	If StringLeft($sRet,1) = '"' Then $sRet = StringTrimLeft($sRet,1)
	If StringRight($sRet,1) = '"' Then $sRet = StringTrimRight($sRet,1)

	If $_FF_COM_TRACE Then ConsoleWrite("__FFRecv: " & $sRet & @CRLF)

	SetError($iErr)
	Return $sRet
EndFunc   ;==>__FFRecv

; #INTERNAL_USE_ONLY#===========================================================
; Function ......: __FFSend
; Description ...:
; Parameter(s) ..: ByRef $Socket
;                  ByRef $aCommand[]    Array of commands to send
;                  $iDelay = 0          Delay before sending
; Requirement ...:
; Return values .: Success      - 1
;                  Failure      - 0
; User CallTip: .: (ByRef $Socket, ByRef $sCommand[, $iDelay = 0])
; Author(s) .....: Thorsten Willert
; Date ..........: 27. May 2008
; Note(s) .......:
; ==============================================================================
Func __FFSend(ByRef $Socket, $sCommand, $iDelay = 0)
	If Not __FFIsSocket($Socket) Then
		SetError(__FFError("__FFSend", $_FF_ERROR_SocketError, $Socket))
		Return 0
	EndIf

	Sleep($iDelay)
	TCPSend($Socket, $sCommand & @CRLF)
	If Not @error Then
		If $_FF_COM_TRACE Then ConsoleWrite("__FFSend: " & $sCommand & @CRLF)
	Else
		SetError(__FFError(" __FFSend", $_FF_ERROR_SendRecv, "TCPSend: " & $sCommand))
		Return 0
	EndIf
	Return 1
EndFunc   ;==>__FFSend

; #INTERNAL_USE_ONLY#===========================================================
; Function ......: __FFChromeSelect
; Description ...: Some shortcuts for chrome
; Parameter(s) ..:
; Requirement ...:
; Return values .: Success      - crome: + ....xul
;                  Failure      - crome: + $sOpt
; User CallTip: .: ($sOpt)
; Author(s) .....: Thorsten Willert
; Date ..........: 27. Mai 2008
; Note(s) .......:
; ==============================================================================
Func __FFChromeSelect($sOpt)
	Local $sXUL

	Switch $sOpt
		Case "bookmarks"
			$sXUL = "//browser/content/bookmarks/bookmarksPanel.xul"
		Case "history"
			$sXUL = "//browser/content/history/history-panel.xul"
		Case "extensions"
			$sXUL = "//mozapps/content/extensions/extensions.xul?type=extensions"
		Case "advanced-scripts"
			$sXUL = "//browser/content/preferences/advanced-scripts.xul"
		Case "changeaction"
			$sXUL = "//browser/content/preferences/changeaction.xul"
		Case "prefs"
			$sXUL = "//browser/content/preferences/preferences.xul"
		Case "colors"
			$sXUL = "//browser/content/preferences/colors.xul"
		Case "connection"
			$sXUL = "//browser/content/preferences/connection.xul"
		Case "cookies"
			$sXUL = "//browser/content/preferences/cookies.xul"
		Case "downloadactions"
			$sXUL = "//browser/content/preferences/downloadactions.xul"
		Case "fonts"
			$sXUL = "//browser/content/preferences/fonts.xul"
		Case "languages"
			$sXUL = "//browser/content/preferences/languages.xul"
		Case "permissions"
			$sXUL = "//browser/content/preferences/permissions.xul"
		Case "sanitize"
			$sXUL = "//browser/content/preferences/sanitize.xul"
		Case "fireftp"
			$sXUL = "//fireftp/content/fireftp.xul"
		Case Else
			$sXUL = $sOpt
	EndSwitch

	Return "chrome:" & $sXUL
EndFunc   ;==>__FFChromeSelect

; #INTERNAL_USE_ONLY#===========================================================
; Function ......: __FFError
; Description ...:
; Parameter(s) ..:
; Requirement ...:
; Return values .: Success      -
;                  Failure      -
; User CallTip: .: ($sWhere, Const ByRef $i_FF_ERROR[, $sMessage = ""])
; Author(s) .....: Thorsten Willert
; Date ..........: 06. June 2008
; Note(s) .......:
; ==============================================================================
Func __FFError($sWhere, Const ByRef $i_FF_ERROR, $sMessage = "")
	Local $sOut

	Switch $i_FF_ERROR
		Case $_FF_ERROR_Success
			Return $_FF_ERROR_Success
		Case $_FF_ERROR_GeneralError
			$sOut = "General Error"
		Case $_FF_ERROR_SocketError
			$sOut = "Socket Error"
		Case $_FF_ERROR_InvalidDataType
			$sOut = "Invalid data type"
		Case $_FF_ERROR_InvalidValue
			$sOut = "Invalid value"
		Case $_FF_ERROR_Timeout
			$sOut = "Timeout"
		Case $_FF_ERROR_NoMatch
			$sOut = "No match"
		Case $_FF_ERROR_RetValue
			$sOut = "Error return value"
		Case $_FF_ERROR_SendRecv
			$sOut = "Error TCPSend / TCPRecv"
		Case $_FF_ERROR_ReplException
			$sOut = "MozRepl Exception"
	EndSwitch
	If $sMessage = "" Then
		ConsoleWriteError($sWhere & " ==> " & $sOut & @CRLF)
		If @Compiled And $i_FF_ERROR < 6 Then MsgBox(16, "FF.au3 Error:", $sWhere & " ==> " & $sOut & @CRLF)
	Else
		ConsoleWriteError($sWhere & " ==> " & $sOut & ": " & $sMessage & @CRLF)
		If @Compiled And $i_FF_ERROR < 6 Then MsgBox(16, "FF.au3 Error:", $sWhere & " ==> " & $sOut & ": " & $sMessage & @CRLF)
	EndIf

	Return $i_FF_ERROR
EndFunc   ;==>__FFError

; #INTERNAL_USE_ONLY# ==========================================================
; Name ..........: __FFAddStatus
; Description ...:
; Syntax ........: __FFAddStatus(ByRef $Socket)
; Parameter(s): .:
;                  $Socket      -
; Return Value ..: Success      -
;                  Failure      -
; Author(s) .....: Thorsten Willert
; Modified ......: Sat Jun 21 10:30:52 CEST 2008
; Version .......: 1.0
; Example .......: No
; ==============================================================================
Func __FFAddStatus(ByRef $Socket)

	For $i = 1 To UBound($_aFF_STATUS)-1
		If $_aFF_STATUS[$i][0] = -1 Then
			$_aFF_STATUS[ UBound($_aFF_STATUS)-1][0] = $Socket
			$_aFF_STATUS[ UBound($_aFF_STATUS)-1][1] = -1
			$_aFF_STATUS[ UBound($_aFF_STATUS)-1][2] = -1
			$_aFF_STATUS[0][0] += 1
		Else
			Redim $_aFF_STATUS[Ubound($_aFF_STATUS)+1][3]
			$_aFF_STATUS[ UBound($_aFF_STATUS)-1][0] = $Socket
			$_aFF_STATUS[ UBound($_aFF_STATUS)-1][1] = -1
			$_aFF_STATUS[ UBound($_aFF_STATUS)-1][2] = -1
			$_aFF_STATUS[0][0] += 1
		EndIf

	Next

	Return 1
EndFunc

; #INTERNAL_USE_ONLY# ==========================================================
; Name ..........: __FFRemoveStatus
; Description ...:
; Syntax ........: __FFRemoveStatus(ByRef $Socket)
; Parameter(s): .:
;                  $Socket      -
; Return Value ..: Success      -
;                  Failure      -
; Author(s) .....: Thorsten Willert
; Modified ......: Sat Jun 21 10:30:52 CEST 2008
; Version .......: 1.0
; Example .......: No
; ==============================================================================
Func __FFRemoveStatus(ByRef $Socket)
	Local $i

	For $i = 1 To UBound($_aFF_STATUS)-1
		If $_aFF_STATUS[$i][0] = $Socket Then
			$_aFF_STATUS[ UBound($_aFF_STATUS)-1][0] = -1
			$_aFF_STATUS[ UBound($_aFF_STATUS)-1][1] = -1
			$_aFF_STATUS[ UBound($_aFF_STATUS)-1][2] = -1
		EndIf
	Next

	Return 1
EndFunc

; #INTERNAL_USE_ONLY# ==========================================================
; Name ..........: __FFGetStatus
; Description ...:
; Syntax ........: __FFGetStatus(ByRef $Socket[, $sType = "frame"])
; Parameter(s): .:
;                  $Socket      -
;                  $sType       - Optional:
; Return Value ..: Success      -
;                  Failure      - -1
; Author(s) .....: Thorsten Willert
; Modified ......: Sat Jun 21 10:30:52 CEST 2008
; Version .......: 1.0
; Example .......: No
; ==============================================================================
Func __FFGetStatus(ByRef $Socket, $sType = "frame")
	Local $i, $iIndex

	; Status Array:
	; $_aFF_Status[0][0] = [ [ Anzahl ] ]
	; $_aFF_Status[1][3] = [ [ Socket, TabLabel, FrameIndex ] ]
	$sType = StringLower($sType)

	Switch $sType
		Case "frame"
			$iIndex = 2
		Case "tab"
			$iIndex = 1
		Case Else
			Return ""
	EndSwitch

	For $i = 1 To UBound($_aFF_Status)-1
		If $_aFF_Status[$i][0] = $Socket Then
			; no-frame-sites
			If $_aFF_Status[$i][$iIndex] = -1 And $sType = "frame" Then
				Return '"top"'
			; frame-sites
			Else
				Return $_aFF_Status[$i][$iIndex]
			EndIf
		EndIf
	Next

	Return -1

EndFunc ;==> __FFGetStatus

; #INTERNAL_USE_ONLY# ==========================================================
; Name ..........: __FFSetStatus
; Description ...:
; Syntax ........: __FFSetStatus(ByRef $Socket, $vValue [, $sType = "frame"])
; Parameter(s): .:
;                  $Socket      -
;                  $sType       - Optional:
; Return Value ..: Success      -
;                  Failure      -
;                  @ERROR       -
; Author(s) .....:
; Modified ......: Sat Jun 21 10:30:52 CEST 2008
; Version .......: 1.0
; Example .......: No
; ==============================================================================
Func __FFSetStatus(ByRef $Socket, $vValue, $sType = "frame")
	Local $i, $iIndex

	; Status Array:
	; $_aFF_Status[0][0] = [ [ Anzahl ] ]
	; $_aFF_Status[1][3] = [ [ Socket, TabLabel, FrameIndex ] ]

	Switch StringLower($sType)
		Case "frame"
			$iIndex = 2
		Case "tab"
			$iIndex = 1
		Case Else
			Return ""
	EndSwitch

	For $i = 1 To UBound($_aFF_Status)-1
		If $_aFF_Status[$i][0] = $Socket Then $_aFF_Status[$i][$iIndex] = $vValue
	Next

	Return 1

EndFunc ;==> __FFGetStatus

; #INTERNAL_USE_ONLY# ==========================================================
; Name ..........: __FFGetBrowserVersion
; Description ...: Sets the global var: $_FF_VERSION
; Requirement(s).: #include <FF.au3>
; Syntax ........: __FFGetBrowserVersion(ByRef $Socket)
; Parameter(s): .:
;                  $Socket      -
; Return Value ..: Success      - Version
;                  Failure      - 0
; Author(s) .....: Thorsten Willert
; Modified ......: Sun Jun 22 19:16:32 CEST 2008
; Version .......: 1.0
; ==============================================================================
Func __FFGetBrowserVersion(ByRef $Socket)
	Local $sVersion = _FFSetGet($Socket,"navigator.userAgent")

	Local $aArray = StringRegExp($sVersion,"Firefox[\/\s](\d+\.\d+)",1)
	If @error = 1 Then Return 0

	$_FF_VERSION = $aArray[0]

	If $_FF_COM_TRACE Then ConsoleWrite("__FFGetBrowserVersion: " & $_FF_VERSION & @CRLF)

	Return $_FF_VERSION
EndFunc ;==> __FFGetBrowserVersion

; #INTERNAL_USE_ONLY#===========================================================
; Function ......:  __FFIsIP
; Description ...:
; Parameter(s) ..: ByRef $IP
; Requirement ...:
; Return values .: Success      - 1
;                  Failure      - 0
; User CallTip: .: (ByRef $IP)
; Author(s) .....: Thorsten Willert
; Date ..........: 28. August 2007
; Note(s) .......:
; ==============================================================================
Func __FFIsIP(ByRef $IP)
	Return StringRegExp($IP, "\A(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])\z")
EndFunc   ;==>__FFIsIP

; #INTERNAL_USE_ONLY#===========================================================
; Function ......: __FFIsPort
; Description ...:
; Parameter(s) ..: ByRef $iPort
; Requirement ...:
; Return values .: Success      - 1
;                  Failure      - 0
; User CallTip: .: (ByRef $iPort)
; Author(s) .....: Thorsten Willert
; Date ..........: 28. August 2007
; Note(s) .......:
; ==============================================================================
Func __FFIsPort(ByRef $iPort)
	Return (IsInt($iPort) And $iPort >= 1024 And $iPort <= 65535)
EndFunc   ;==>__FFIsPort

; #INTERNAL_USE_ONLY#===========================================================
; Function ......: __FFIsSocket
; Description ...:
; Parameter(s) ..: ByRef $Socket
; Requirement ...:
; Return values .: Success      - 1
;                  Failure      - 0
; User CallTip: .: (ByRef $Socket)
; Author(s) .....: Thorsten Willert
; Date ..........: 28. August 2007
; Note(s) .......:
; ==============================================================================
Func __FFIsSocket(ByRef $Socket)
	Return ($Socket <> -1 And IsInt($Socket))
EndFunc   ;==>__FFIsSocket

; #INTERNAL_USE_ONLY#===========================================================
; Function ......: __FFIsURL
; Description ...:
; Parameter(s) ..: ByRef $URL
; Requirement ...:
; Return values .: Success      - 1
;                  Failure      - 0
; User CallTip: .: (ByRef $URL)
; Author(s) .....: Thorsten Willert
; Date ..........: 28. August 2007
; Note(s) .......:
; ==============================================================================
Func __FFIsURL(ByRef $URL)
	;RexEx from http://geekswithblogs.net/casualjim/archive/2005/12/01/61722.aspx
	Return (StringRegExp($URL,'^^((ht|f)tp(s?)\:\/\/|~/|/)?([\w]+:\w+@)?([a-zA-Z]{1}([\w\-]+\.)+([\w]{2,5}))(:[\d]{1,5})?((/?\w+/)+|/?)(\w+\.[\w]{3,4})?((\?\w+=\w+)?(&\w+=\w+)*)?') Or _
			StringLeft($URL, 6) = "about:" Or _
			StringLeft($URL, 7) = "chrome:")
EndFunc   ;==>__FFIsURL

; #INTERNAL_USE_ONLY#===========================================================
; Function ......: __FFB2S
; Description ...:
; Parameter(s) ..: ByRef $URL
; Requirement ...:
; Return values .: Success      - "true" / "false"
;                  Failure      - ""
; User CallTip: .: __FFB2S(ByRef $bBool)
; Author(s) .....: Thorsten Willert
; Date ..........: 13. September 2008
; Note(s) .......:
; ==============================================================================
Func __FFB2S($bBool)
    If IsBool($bBool) Then
        If $bBool Then
            Return "true"
        Else
            Return "false"
        EndIf
    Else
        SetError(__FFError("__FFB2S", $_FF_ERROR_InvalidDataType, "Boolean: " & $bBool))
        Return ""
    EndIf
EndFunc   ;==>__FFB2S

; #INTERNAL_USE_ONLY#===========================================================
; Function ......: __FFSendJavaScripts
; Description ...:
; Parameter(s) ..:
; Requirement ...:
; Return values .: Success      - 1
;                  Failure      - 0
; User CallTip: .: (ByRef $Socket)
; Author(s) .....: Thorsten Willert
; Date ..........: 07. June 2008
; Note(s) .......:
; ==============================================================================
Func __FFSendJavaScripts(ByRef $Socket, $bRefresh = false)

	If _FFSetGet($Socket, "FF_AutoItScript.JavaScriptsInstalled",1000) And $bRefresh = false Then Return 1

	Local $sJavaScript = 'FF_AutoItScript = new Object(); FF_AutoItScript.JavaScriptsInstalled=true;'
; FF__SimulateClick(): JavaScript to simulate mouse-clicks on an object
	#cs
		http://developer.mozilla.org/en/docs/DOM:event.initMouseEvent

		event.initMouseEvent(type, canBubble, cancelable, view,
		detail, screenX, screenY, clientX, clientY,
		ctrlKey, altKey, shiftKey, metaKey,
		button, relatedTarget);
	#ce
	$sJavaScript &= 'FF_AutoItScript.SimulateClick = function SimulateClick(oObject)'
	$sJavaScript &= '{'
	$sJavaScript &= 'try {'
	$sJavaScript &= 'var evt = document.createEvent("MouseEvents");'
	$sJavaScript &= 'evt.initMouseEvent("click", true, true, window,'
	$sJavaScript &= '0, 0, 0, 0, 0,'
	$sJavaScript &= 'false, false, false, false,'
	$sJavaScript &= '0, null);'
	$sJavaScript &= 'oObject.dispatchEvent(evt);'
	$sJavaScript &= 'return 1;'
	$sJavaScript &= '} catch(e) {return 0;}'
	$sJavaScript &= '};'

	_FFSetGet($Socket, $sJavaScript,1000)

; FF__SimulateKey(): JavaScript to simulate a keypress
	$sJavaScript = 'FF_AutoItScript.SimulateKey = function SimulateKey(KeyCode)'
	$sJavaScript &= '{'
	$sJavaScript &= 'try {'
	$sJavaScript &= 'var evt = document.createEvent("KeyboardEvent");'
	$sJavaScript &= 'evt.initKeyEvent("keypress", true, true, null,'
	$sJavaScript &= 'false, false, false, false,'
	$sJavaScript &= 'KeyCode, 0);'
	$sJavaScript &= 'document.dispatchEvent(evt);'
	$sJavaScript &= 'return 1;'
	$sJavaScript &= '} catch(e) {return 0;}'
	$sJavaScript &= '};'

	_FFSetGet($Socket, $sJavaScript,1000)

; FF__SearchImageLink(): JavaScript to search an image in the innerHTML of all links
	$sJavaScript = 'FF_AutoItScript.SearchImageLink = function SearchImageLink(RegEx,iFrame)'
	$sJavaScript &= '{'
	$sJavaScript &= 'try {'
	$sJavaScript &= 'var html;var i;'
	$sJavaScript &= 'for (i=0;i<content.frames[iFrame].document.links.length;i++)'
	$sJavaScript &= '{'
	$sJavaScript &= 'html=content.frames[iFrame].document.links[i].innerHTML;'
	$sJavaScript &= 'if (RegEx.test(html) && html.toLowerCase().indexOf("<img") != -1) return i;'
	$sJavaScript &= '} return -1;'
	$sJavaScript &= '} catch(e) {return -1;}'
	$sJavaScript &= '};'

	_FFSetGet($Socket, $sJavaScript,1000)

; FF__GetLinkInfo(): JavaScript to get all informations about a link
	$sJavaScript = 'FF_AutoItScript.GetLinkInfo = function GetLinkInfo(i,iFrame)'
	$sJavaScript &= '{ var info; with(content.frames[iFrame].document) {'
	$sJavaScript &= 'try {'
	$sJavaScript &= 'info = links[i].href + "|";'
	$sJavaScript &= 'info += links[i].hash + "|";'
	$sJavaScript &= 'info += links[i].search + "|";'
	$sJavaScript &= 'info += links[i].name + "|";'
	$sJavaScript &= 'info += links[i].id + "|";'
	$sJavaScript &= 'info += links[i].text + "|";'
	$sJavaScript &= 'info += links[i].innerHTML;'
	$sJavaScript &= 'return info;} catch(e) {return -1;}'
	$sJavaScript &= '}};'

	_FFSetGet($Socket, $sJavaScript,1000)

; FF__SetTarget(): JavaScript to set the target of all links
	$sJavaScript = 'FF_AutoItScript.SetTarget = function SetTarget(sTarget,iFrame)'
	$sJavaScript &= '{ with(content.frames[iFrame].document) {'
	$sJavaScript &= 'try {'
	$sJavaScript &= 'for (i=0;i<links.length;i++)'
	$sJavaScript &= '{'
	$sJavaScript &= 'links[i].target=sTarget;'
	$sJavaScript &= '} return 1; } catch(e) {return 0;}'
	$sJavaScript &= '}};'

	_FFSetGet($Socket, $sJavaScript,1000)

; FF__SearchImageBySize(): JavaScript
	;$sJavaScript &= 'SearchImageBySize : function(iH, iW, sMode)'
	;$sJavaScript &= '{'
	;$sJavaScript &= 'var sRet = "";'
	;$sJavaScript &= 'for (i=0;i<content.document.images.length;i++)'
	;$sJavaScript &= '{'
	;$sJavaScript &= 'var iWidth=content.document.images[i].width;'
	;$sJavaScript &= 'var iHeight=content.document.images[i].height;'
	;$sJavaScript &= 'switch (sMode) {'
	;$sJavaScript &= 'case "eq": if (iWidth == iW && iHeight == iH) sRet += " " + i; break;'
	;$sJavaScript &= 'case "lt": if (iWidth < iW && iHeight < iH) sRet += " " + i; break;'
	;$sJavaScript &= 'case "gt": if (iWidth > iW && iHeight > iH) sRet += " " + i; break;'
	;$sJavaScript &= 'default: return -1}'
	;$sJavaScript &= '} return sRet;'
	;$sJavaScript &= '},'

; FF__SearchLinkImageBySize(): JavaScript
	$sJavaScript = 'FF_AutoItScript.SearchLinkImageBySize = function SearchLinkImageBySize(iH, iW, sMode, iFrame)'
	$sJavaScript &= '{'
	$sJavaScript &= 'var sRet = ""; with( content.frames[iFrame].document ) {'
	$sJavaScript &= 'for (i=0;i<images.length;i++)'
	$sJavaScript &= '{'
	$sJavaScript &= 'var iWidth=images[i].width;'
	$sJavaScript &= 'var iHeight=images[i].height;'
	$sJavaScript &= 'if (images[i].parentNode.href != ""){'
	$sJavaScript &= 'switch (sMode) {'
	$sJavaScript &= 'case "eq": if (iWidth == iW && iHeight == iH) sRet += " " + i; break;'
	$sJavaScript &= 'case "lt": if (iWidth < iW && iHeight < iH) sRet += " " + i; break;'
	$sJavaScript &= 'case "gt": if (iWidth > iW && iHeight > iH) sRet += " " + i; break;'
	$sJavaScript &= 'default: return -1}'
	$sJavaScript &= '}'
	$sJavaScript &= '} return sRet; }'
	$sJavaScript &= '};'

	_FFSetGet($Socket, $sJavaScript,1000)

; FF__SearchLink(): JavaScript to search a link
	$sJavaScript = 'FF_AutoItScript.SearchLink = function SearchLink(sMode,sSearch,iFrame)'
	$sJavaScript &= '{'
	$sJavaScript &= 'with(content.frames[iFrame].document) {'
	$sJavaScript &= 'var value;'
	$sJavaScript &= 'for (i=0;i<links.length;i++)'
	$sJavaScript &= '{'
	$sJavaScript &= 'switch (sMode) {'
	$sJavaScript &= 'case "href": value=links[i].href; break;'
	$sJavaScript &= 'case "text": value=links[i].text; break;'
	$sJavaScript &= 'case "id": value=links[i].id; break;'
	$sJavaScript &= 'case "name": value=links[i].name; break;'
	$sJavaScript &= 'case "title": value=links[i].title; break;'
	$sJavaScript &= 'default: return -1;}'
	$sJavaScript &= 'if (value.indexOf(sSearch) != -1) return i;'
	$sJavaScript &= '}'
	$sJavaScript &= 'return -1;}'
	$sJavaScript &= '};'

	_FFSetGet($Socket, $sJavaScript,1000)

; FF__SearchTab(); JavaScript to search a tab by label
	$sJavaScript = 'FF_AutoItScript.SearchTab = function SearchTab(sLabel)'
	$sJavaScript &= '{'
	$sJavaScript &= 'for (i=0;i<gBrowser.mTabs.length;i++)'
	$sJavaScript &= '{'
	$sJavaScript &= 'if ( gBrowser.mTabs[i].label.indexOf(sLabel) > -1) return i;'
	$sJavaScript &= '}'
	$sJavaScript &= 'return -1;'
	$sJavaScript &= '};'

	_FFSetGet($Socket, $sJavaScript,1000)
;
	Return 1

EndFunc   ;==>__FFSendJavaScripts

; #INTERNAL_USE_ONLY#===========================================================
; Function ......: __FFWaitForRepl
; Description ...:
; Parameter(s) ..: ByRef $Socket
;                  $iTimeOut = 10000
; Requirement ...:
; Return values .: Success      - return value from MozRepl
;                  Failure      - ""
; User CallTip: .: (ByRef $Socket[, $iTimeOut = 3000])
; Author(s) .....: Thorsten Willert
; Date ..........: 06. June 2008
; Note(s) .......:
; ==============================================================================
Func __FFWaitForRepl(ByRef $Socket, $iTimeOut = 10000)
	If Not __FFIsSocket($Socket) Then
		SetError(__FFError("_FFConnect", $_FF_ERROR_SocketError, $Socket))
		Return ""
	EndIf

	Local $recv, $sRet = "", $TimeOutTimer = TimerInit()

	While TimerDiff($TimeOutTimer) < $iTimeOut

		; connection delay
		Sleep($_FF_CON_DELAY+5)

		$recv = TCPRecv($Socket, 4096)
		;ConsoleWrite($recv & @CRLF)
		; TCP error
		If @error Then
			SetError(__FFError("__FFWaitForRepl", $_FF_ERROR_SendRecv, "TCPRecv"))
			Return ""
		EndIf
		$sRet &= $recv

		; error from MozRepl
		If StringRegExp($recv, "!!![ ](TypeError|Exception|ReferenceError):") Then
			SetError(__FFError("__FFWaitForRepl", $_FF_ERROR_ReplException, StringStripWS($recv, 3)))
			Return ""
		EndIf

		; first connection delay
		If StringInStr($recv, "beginning of the line to force evaluation") Then Sleep(500)

		If StringInStr($recv, "....>") Then
			__FFSend($Socket,";") ; MozRepl-Reset
			Sleep(100)
			SetError(__FFError("__FFWaitForRepl", $_FF_ERROR_RetValue, "MozRepl ....>"))
			Return ""
		EndIf

		; multiple connections to MozRepl (e.g repl2?> ...)
		If StringRegExp($recv, "repl[\d]?>") Then Return StringRegExpReplace($sRet, "repl[\d]?>", "")
	Wend

	; Timeout
	SetError(__FFError("__FFWaitForRepl", $_FF_ERROR_Timeout, "Waiting for repl>"))
	Return ""

EndFunc   ;==>__FFWaitForRepl

; #INTERNAL_USE_ONLY#===========================================================
; Function ......: __FFStartProcess
; Description ...:
; Parameter(s) ..: $sProfile = "default"
;                  $bNoRemote = False
;                  $bHide = False
;                  $iPort = 4242
;                  $iTimeOut = 60000
; Requirement ...:
; Return values .: Success      - 1
;                  Failure      - 0
; User CallTip: .: __FFStartProcess($sProfile = "default"[, $bNoRemote = false[, $bHide = False[, $iPort = 4242[, $iTimeOut = 60000]]]]])
; Author(s) .....: Thorsten Willert
; Date ..........: 07. June 2008
; Note(s) .......:
; ==============================================================================
Func __FFStartProcess($sProfile = "default", $bNoRemote = false, $bHide = False, $iPort = 4242, $iTimeOut = 60000)
	Local $PID = -1
	Local $sNoRemote = ""
	Local $sProcName = $_FF_PROC_NAME

	If $sProfile Then
		$sProfile = ' -P "' & $sProfile & '"'
	Else
		$sProfile = ' -P "default"'
	EndIf

	If $bNoRemote Then $sNoRemote = "-no-remote"

	Local $sHKLM = "HKEY_LOCAL_MACHINE\SOFTWARE\Mozilla\Mozilla Firefox"
	Local $sFFExe = RegRead($sHKLM & "\" & RegRead($sHKLM, "CurrentVersion") & "\Main", "PathToExe")

	If Not $bHide Then
		$PID = Run('"' & $sFFExe & '" ' & $sNoRemote & ' -repl ' & $iPort & ' ' & $sProfile)
	Else
		$PID = Run('"' & $sFFExe & '" ' & $sNoRemote & ' -repl ' & $iPort & ' ' & $sProfile, "", @SW_HIDE)
	EndIf
	If @error Then
		SetError(__FFError("__FFStartProcess", $_FF_ERROR_GeneralError, "Browser not found in: " & $sFFExe))
		Return 0
	EndIf

	Local $iTimeOutTimer = TimerInit()
	While 1
		Sleep(1000)
		If ProcessExists($sProcName) Then ExitLoop
		If (TimerDiff($iTimeOutTimer) > $iTimeOut) Then
			SetError(__FFError("__FFStartProcess", $_FF_ERROR_Timeout, "Browser process not exists: " & $sProcName))
			Return 0
		EndIf
	Wend

	If $_FF_COM_TRACE Then ConsoleWrite("__FFStartProcess: " & $sFFExe & '" -repl ' & $sProfile & @CRLF)

	SetExtended($PID)
	Return 1
EndFunc   ;==>__FFStartProcess

;===============================================================================