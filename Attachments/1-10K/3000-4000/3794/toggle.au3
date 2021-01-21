Dim $i=0,$y=0
$oXml = ObjCreate("Msxml2.DOMDocument.3.0")		; Rules
$oXml.async=0
;$oXml.Load("C:\Documents and Settings\All Users\Application Data\Snapstream\Beyond TV\Settings.xml")
$oXml.Load(@ScriptDir & "\Settings.xml")
If @error Then MsgBox(0,"xmltest","load failed! error-" & @error)
$oXmlroot = $oXml.documentElement	; Define

For $oXmlNode In $oXmlroot.childNodes	;
    Select
    Case $oXmlnode.nodename = "Property"
        For $oXmlnode2  in $oXmlnode.Childnodes	; Go through Property sub entrys
			Select
			Case $oXmlnode2.nodename = "Name"	; A property entry
				If $oXmlnode2.text=="TryCC" Then $i=1
			Case $oXmlnode2.nodename = "Value"	; A property entry
				If $i Then
					If $oXmlnode2.text=="1" Then 
						$oXmlnode2.text.replaceData(0, 1, "0")	; If it is on then toggle it off
					Else
						$oXmlnode2.text.replaceData(0, 1, "1")	; It was off so toggle it on
					EndIf
					MsgBox(0, "tooogle", "New value is " & $oXmlnode2.text & " rc=" & @error)
					$i=0
					$y=1
					ExitLoop
				EndIf
			EndSelect
			if $y Then ExitLoop
		Next
	EndSelect
Next
If $y Then $oXml.Save("C:\Documents and Settings\All Users\Application Data\Snapstream\Beyond TV\Settings.xml")
		
			
				
					