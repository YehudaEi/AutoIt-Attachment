;==================
;msdn constants importer
;by GtaSpider
;==================


;PLEASE CHANGE IF YOU WANT
Global Const $sVarBefore = "$tag" ; will be: $tagTITLE_OF_THE_CONSTANT
Global Const $sConstFileToWrite = @ScriptDir&"\Clip_Constants.au3"; the Constants will be written in the next line of the file
;STOP CHANGE

FileWrite($sConstFileToWrite,";Constants importet from msdn with 'msdn constants importer' by GtaSpider'"&@CRLF&@CRLF)

HotKeySet("^c","_clip")
HotKeySet("^C","_clip")
HotKeySet("^{ins}","_clip")

While 1
	Sleep(500)
WEnd

Func _clip()
	HotKeySet(@HotKeyPressed)
	Send(@HotKeyPressed)
	Local $sURL = ClipGet()
	If StringInStr($sURL,"msdn.microsoft.com") Then
		TrayTip("Clip",$sURL,2)
		Local $sSource = BinaryToString(InetRead($sURL))
		Local $aRegExp = StringRegExp($sSource,'(?s)<div class="title">(.*?)</div>.*?<pre class="libCScode".*?>.*?\{(.*?)}.*?</pre>',3)
		If UBound($aRegExp) < 2 Then
			MsgBox(16,"Clip","Error, RegExp returnd bad values")
		Else
			Local $sTitle = $aRegExp[0]
			Local $sData = $aRegExp[1]

			$sData = StringStripCR(StringReplace(StringReplace($sData,@LF,''),@CRLF,''))
			Local $sNewLine = 'Global Const '&$sVarBefore&$sTitle&' = "',$sRet
			Local $aData = StringSplit($sData,";"),$i
			For $i = 1 To $aData[0]
				If Not StringLen($aData[$i]) Then ContinueLoop
				$sNewLine &= $aData[$i]&"; "
				If StringLen($sNewLine) > 100 Then
					$sRet &= $sNewLine& '" & _'&@CRLF
					$sNewLine = @TAB&@TAB&'"'
				EndIf
			Next
			$sRet &= $sNewLine&'"'
			If StringRight($sRet,10) = ' & _'&@CRLF&@TAB&@TAB&'""' Then $sRet = StringTrimRight($sRet,10)
			FileWrite($sConstFileToWrite,$sRet&@CRLF)
			TrayTip($sTitle,"Successful insertet to"&@CRLF&$sConstFileToWrite,2)
		EndIf
	EndIf
	HotKeySet(@HotKeyPressed,"_clip")
EndFunc