#comments-start ----------------------------------------------------------------------------

	AutoIt Version: 3.3.8.1
	Author:         Gilles GROS (GGS)

	Script Function:
	CustomLauncher for Portable Apps shortcut

#comments-end ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <File.au3>
#Include <array.au3>
#include "_XMLDomWrapper.au3"

if $CmdLine[0] < 1 Then
	msgbox(0,'','usage : ' & @CRLF & @TAB & @ScriptName & ' KfaXMLFile.xml')
EndIf
if FileExists($CmdLine[1]) Then
	Explode_KFA($CmdLine[1])
Else
	msgbox (0,'','usage : ' & @CRLF & @TAB & @ScriptName & ' KfaXMLFile.xml' & @CRLF & _
			@TAB & ' KfaXMLFile.xml must be a valid KFA XML file')
EndIf
Exit

Func Explode_KFA($KFAFile)

	_XMLFileOpen($KFAFile)
	$strXpathBase = '//KeyFileAssoc/AppsAssoc/FileType[@ext]'

	$aGetValue = _XMLGetValue($strXpathBase & '/Shell/Action/AppName')
	$aUniq=_ArrayUnique($aGetValue, 1,1,1)

	_ArrayDisplay($aUniq, ' Initial ')

	For $i=1 to $aUniq[0]
		; Get list of XMLTAG
		$aXmlTag=_ArrayUnique( _XMLSelectNodes($strXpathBase & '/Shell/Action[AppName[starts-with(text(),"'& $aUniq[$i] & '")]]/*'), 1,1,1)
		_ArrayDisplay($aXmlTag,'Field : ' & $aUniq[$i])

		$aXmlNodes=_XMLSelectNodes($strXpathBase & '/Shell/Action[AppName[starts-with(text(),"'& $aUniq[$i] & '")]]')
		_ArrayDisplay($aXmlNodes,'Nodes')
		For $iCurrentNode = 1 to $aXmlNodes[0]
			For $iNode = 1 to $aXmlTag[0]
				$aValueExe = _XMLGetValue($strXpathBase & '/Shell/Action['&$iCurrentNode&'][AppName[starts-with(text(),"'& $aUniq[$i] & '")]]/' & $aXmlTag[$iNode])
				if isarray($aValueExe) Then
					_ArrayDisplay($aValueExe,$iCurrentNode & ' - ' & $aXmlTag[$iNode] & ' : ' & $aUniq[$i])
				Else
					msgbox(0,'',$iCurrentNode & ' - ' & $aXmlTag[$iNode] & ' : ' & $aUniq[$i] & ' is not an array')
				Endif
			Next
		Next
	Next
EndFunc