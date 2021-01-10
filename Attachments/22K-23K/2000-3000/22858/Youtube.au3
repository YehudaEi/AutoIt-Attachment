#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.13.3 (beta)
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#cs

Functions:

	_Youtube_Read($iID)



	_Youtube_GetID($sPlayer)
	_Youtube_GetTitle($sPlayer)
	_Youtube_GetDescription($sPlayer)
	_Youtube_GetKeywords($sPlayer)

	_Youtube_GetEmbedLink($sPlayer)
	_Youtube_GetPlayerLink($sPlayer)
	_Youtube_GetPlayerSwf($sPlayer)


	
	_Youtube_Create($iX, $iY, $iWidth=$YT_DEFAULTWIDTH, $iHeight=$YT_DEFAULTHEIGHT)
	_Youtube_Load($aPlayerControl, $sPlayer, $iAutoPlay=True)
	_Youtube_Stop($aPlayerControl)

#CE

#include-once
#include <INet.au3>
#include <IE.au3>

Global Const $YT_DEFAULTWIDTH = 425
Global Const $YT_DEFAULTHEIGHT = 344

; Downloads the source of the Youtube page
; $iID		= Video ID (example: "sNzEQ8hG1zA")

Func _Youtube_Read($iID)
	
	$sSource = _INetGetSource($iID)
	
	Return $sSource
	
EndFunc

; Creates a embedded IE control for playing Youtube movies
; $iX, $iY, $iWidth, $iHeight 	= Coordinates of the control

Func _Youtube_Create($iX, $iY, $iWidth=$YT_DEFAULTWIDTH, $iHeight=$YT_DEFAULTHEIGHT)
	
	Local $aReturn[2]
	
	$oIE = _IECreateEmbedded()
	$hObj = GUICtrlCreateObj($oIE, $iX, $iY, $iWidth, $iHeight)
	
	_IENavigate ($oIE, "about:blank", 0)
	_IEDocWriteHTML($oIE, '<body bgcolor="Black"></body>')
	
	$aReturn[0] = $oIE
	$aReturn[1] = $hObj
	
	Return $aReturn
	
EndFunc

; Loads a movie into a player control.
; $aPlayerControl	= A player control (return value of _Youtube_Create)
; $sPlayer			= A movie (return value of _Youtube_Read)
; [$iAutoPlay]		= Automaticly starts playing the movie if True.

Func _Youtube_Load($aPlayerControl, $sPlayer, $iAutoPlay=True)
	
	If $iAutoPlay Then
		$sURL = _Youtube_GetPlayerLink($sPlayer)
	Else
		$sURL = _Youtube_GetEmbedLink($sPlayer)
	EndIf
	
	_IENavigate ($aPlayerControl[0], $sURL, 0)
	
	Return 1
	
EndFunc

; Stops playing a movie
; $aPlayerControl	= Player control (return value of _Youtube_Create)

Func _Youtube_Stop($aPlayerControl)
	
	_IENavigate ($aPlayerControl[0], "about:blank", 0)
	_IEDocWriteHTML($aPlayerControl[0], '<body bgcolor="Black"></body>')
	
EndFunc



Func _Youtube_GetKeywords($sPlayer)
	
	$sSource = $sPlayer
	
	$iPlayerLinkStart = StringInStr($sSource,'<meta name="keywords" content=')
	If Not $iPlayerLinkStart Then Return ""
	$sBeforePlayerLink = StringLeft($sSource,$iPlayerLinkStart+StringLen('<meta name="keywords" content=')-1)
	If Not $sBeforePlayerLink Then Return ""
	
	$aSplit = StringSplit($sBeforePlayerLink,@CRLF)
	$iPlayerLinkLine = $aSplit[0]
	If Not $iPlayerLinkLine Then Return ""
	
	$aSourceSplit = StringSplit($sSource,@CRLF)
	If $iPlayerLinkLine > $aSourceSplit[0] Then Return ""
	$sPlayerLinkLine = $aSourceSplit[$iPlayerLinkLine]
	
	$iPlayerLinkStart = StringInStr($sPlayerLinkLine,'<meta name="keywords" content=')
	$sAfterPlayerLink = StringTrimLeft($sPlayerLinkLine,$iPlayerLinkStart+StringLen('<meta name="keywords" content=')-1)
	$sAfterPlayerLink = StringTrimRight($sAfterPlayerLink,2)
	$sAfterPlayerLink = StringTrimLeft($sAfterPlayerLink,1)
	
	Return $sAfterPlayerLink
	
EndFunc

Func _Youtube_GetEmbedLink($sPlayer)
	
	$sSource = $sPlayer
	
	$iPlayerLinkStart = StringInStr($sSource,"var embedUrl = ")
	If Not $iPlayerLinkStart Then Return ""
	$sBeforePlayerLink = StringLeft($sSource,$iPlayerLinkStart+StringLen("var embedUrl = ")-1)
	If Not $sBeforePlayerLink Then Return ""
	
	$aSplit = StringSplit($sBeforePlayerLink,@CRLF)
	$iPlayerLinkLine = $aSplit[0]
	If Not $iPlayerLinkLine Then Return ""
	
	$aSourceSplit = StringSplit($sSource,@CRLF)
	If $iPlayerLinkLine > $aSourceSplit[0] Then Return ""
	$sPlayerLinkLine = $aSourceSplit[$iPlayerLinkLine]
	
	$iPlayerLinkStart = StringInStr($sPlayerLinkLine,"var embedUrl = ")
	$sAfterPlayerLink = StringTrimLeft($sPlayerLinkLine,$iPlayerLinkStart+StringLen("var embedUrl = ")-1)
	$sAfterPlayerLink = StringReplace($sAfterPlayerLink,";","")
	$sAfterPlayerLink = StringReplace($sAfterPlayerLink,"'","")
	
	Return $sAfterPlayerLink
	
EndFunc

Func _Youtube_GetID($sPlayer)
	
	$sSource = $sPlayer
	
	$iPlayerLinkStart = StringInStr($sSource,"var pageVideoId = ")
	If Not $iPlayerLinkStart Then Return ""
	$sBeforePlayerLink = StringLeft($sSource,$iPlayerLinkStart+StringLen("var pageVideoId = ")-1)
	If Not $sBeforePlayerLink Then Return ""
	
	$aSplit = StringSplit($sBeforePlayerLink,@CRLF)
	$iPlayerLinkLine = $aSplit[0]
	If Not $iPlayerLinkLine Then Return ""
	
	$aSourceSplit = StringSplit($sSource,@CRLF)
	If $iPlayerLinkLine > $aSourceSplit[0] Then Return ""
	$sPlayerLinkLine = $aSourceSplit[$iPlayerLinkLine]
	
	$iPlayerLinkStart = StringInStr($sPlayerLinkLine,"var pageVideoId = ")
	$sAfterPlayerLink = StringTrimLeft($sPlayerLinkLine,$iPlayerLinkStart+StringLen("var pageVideoId = ")-1)
	$sAfterPlayerLink = StringReplace($sAfterPlayerLink,";","")
	$sAfterPlayerLink = StringReplace($sAfterPlayerLink,"'","")
	
	Return $sAfterPlayerLink
	
EndFunc

Func _Youtube_GetDescription($sPlayer)
	
	$sSource = $sPlayer
	
	$iPlayerLinkStart = StringInStr($sSource,'<meta name="description" content=')
	If Not $iPlayerLinkStart Then Return ""
	$sBeforePlayerLink = StringLeft($sSource,$iPlayerLinkStart+StringLen('<meta name="description" content=')-1)
	If Not $sBeforePlayerLink Then Return ""
	
	$aSplit = StringSplit($sBeforePlayerLink,@CRLF)
	$iPlayerLinkLine = $aSplit[0]
	If Not $iPlayerLinkLine Then Return ""
	
	$aSourceSplit = StringSplit($sSource,@CRLF)
	If $iPlayerLinkLine > $aSourceSplit[0] Then Return ""
	$sPlayerLinkLine = $aSourceSplit[$iPlayerLinkLine]
	
	$iPlayerLinkStart = StringInStr($sPlayerLinkLine,'<meta name="description" content=')
	$sAfterPlayerLink = StringTrimLeft($sPlayerLinkLine,$iPlayerLinkStart+StringLen('<meta name="description" content=')-1)
	$sAfterPlayerLink = StringTrimRight($sAfterPlayerLink,2)
	$sAfterPlayerLink = StringTrimLeft($sAfterPlayerLink,1)
	
	Return $sAfterPlayerLink
	
EndFunc

Func _Youtube_GetTitle($sPlayer)
	
	$sSource = $sPlayer
	
	$iPlayerLinkStart = StringInStr($sSource,'<meta name="title" content=')
	If Not $iPlayerLinkStart Then Return ""
	$sBeforePlayerLink = StringLeft($sSource,$iPlayerLinkStart+StringLen('<meta name="title" content=')-1)
	If Not $sBeforePlayerLink Then Return ""
	
	$aSplit = StringSplit($sBeforePlayerLink,@CRLF)
	$iPlayerLinkLine = $aSplit[0]
	If Not $iPlayerLinkLine Then Return ""
	
	$aSourceSplit = StringSplit($sSource,@CRLF)
	If $iPlayerLinkLine > $aSourceSplit[0] Then Return ""
	$sPlayerLinkLine = $aSourceSplit[$iPlayerLinkLine]
	
	$iPlayerLinkStart = StringInStr($sPlayerLinkLine,'<meta name="title" content=')
	$sAfterPlayerLink = StringTrimLeft($sPlayerLinkLine,$iPlayerLinkStart+StringLen('<meta name="title" content=')-1)
	$sAfterPlayerLink = StringTrimRight($sAfterPlayerLink,2)
	$sAfterPlayerLink = StringTrimLeft($sAfterPlayerLink,1)
	
	Return $sAfterPlayerLink
	
EndFunc

Func _Youtube_GetPlayerLink($sPlayer)
	
	$sSWF = _Youtube_GetPlayerSwf($sPlayer)
	If Not $sSWF Then Return ""
	
	$sSource = $sPlayer
	
	$iPlayerLinkStart = StringInStr($sSource,"var swfArgs = {")
	If Not $iPlayerLinkStart Then Return ""
	$sBeforePlayerLink = StringLeft($sSource,$iPlayerLinkStart+StringLen("var swfArgs = {")-1)
	If Not $sBeforePlayerLink Then Return ""
	
	$aSplit = StringSplit($sBeforePlayerLink,@CRLF)
	$iPlayerLinkLine = $aSplit[0]
	If Not $iPlayerLinkLine Then Return ""
	
	$aSourceSplit = StringSplit($sSource,@CRLF)
	If $iPlayerLinkLine > $aSourceSplit[0] Then Return ""
	$sPlayerLinkLine = $aSourceSplit[$iPlayerLinkLine]
	
	$iPlayerLinkStart = StringInStr($sPlayerLinkLine,"var swfArgs = {")
	$sAfterPlayerLink = StringTrimLeft($sPlayerLinkLine,$iPlayerLinkStart+StringLen("var swfArgs = {")-1)
	$sAfterPlayerLink = StringReplace($sAfterPlayerLink,"};","")
	$sAfterPlayerLink = StringReplace($sAfterPlayerLink,'"',"")
	$sAfterPlayerLink = StringReplace($sAfterPlayerLink,": ","=")
	$sAfterPlayerLink = StringReplace($sAfterPlayerLink,", ","&")
	;$sAfterPlayerLink = StringReplace($sAfterPlayerLink,"null","0")
	
	Return $sSWF&"?"&$sAfterPlayerLink
	
EndFunc

Func _Youtube_GetPlayerSwf($sPlayer)
	
	$sSource = $sPlayer
	
	$iPlayerLinkStart = StringInStr($sSource,"var swfUrl = ")
	If Not $iPlayerLinkStart Then Return ""
	$sBeforePlayerLink = StringLeft($sSource,$iPlayerLinkStart+StringLen("var swfUrl = canPlayV9Swf() ? ")-1)
	If Not $sBeforePlayerLink Then Return ""
	
	$aSplit = StringSplit($sBeforePlayerLink,@CRLF)
	$iPlayerLinkLine = $aSplit[0]
	If Not $iPlayerLinkLine Then Return ""
	
	$aSourceSplit = StringSplit($sSource,@CRLF)
	If $iPlayerLinkLine > $aSourceSplit[0] Then Return ""
	$sPlayerLinkLine = $aSourceSplit[$iPlayerLinkLine]
	
	$iPlayerLinkStart = StringInStr($sPlayerLinkLine,"var swfUrl = ")
	$sAfterPlayerLink = StringTrimLeft($sPlayerLinkLine,$iPlayerLinkStart+StringLen("var swfUrl = canPlayV9Swf() ? ")-1)
	$sAfterPlayerLink = StringReplace($sAfterPlayerLink,"'","")
	
	$aSplit = StringSplit($sAfterPlayerLink," ")
	
	Return $aSplit[1]
	
EndFunc