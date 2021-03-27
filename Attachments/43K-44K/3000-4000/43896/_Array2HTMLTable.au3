
;#FUNCTION#=============================================================================================================
; Name...........: _Array2HTMLTable()
; Description ...: Returns HTML string with a table created from a Autoit array
; Syntax.........: ($aArray, $BodyBGColor = "#ffffff", $HighlightBGColor = "#F0F9FF", $HeaderBGColor = "#007EE5", $BodyTxtColor = "#000000", $HeaderTxtColor = "#ffffff", $HeadersOn = 1)
; Parameters ....: $aArray - The Array to use
;                  $BodyBGColor - 		[optional] The Hex color for the table body background.
;                  $HighlightBGColor - 	[optional] The Hex color for the highlight background.
;                  $HeaderBGColor - 	[optional] The Hex color for the table header background.
;                  $BodyTxtColor - 		[optional] The Hex color for the table body Text.
;                  $HeaderTxtColor - 	[optional] The Hex color for the table header Text.
;                  $HeadersOn - 		[optional] Turns off the header. Headers are the contents found on the first row of the Autoit array if this feature is turned off then
;                                       the frist row of the autoit array is placed into the table body.
; Return values .: Success - The HTML string
;                  Failure - -1 or -2 depending on the problem
; Author ........: XThrax aka uncommon
; Remarks .......: CSS and JavaScript are use to make the table look nice. If you know a lot more about either you can add to it or manipulate it. I used the code I found on this website.
;                                                                       
; Related .......: _IETableWriteToArray()
; Link ..........;
; Example .......; No
; =====================================================================================================================

Func _Array2HTMLTable($aArray, $BodyBGColor = "#ffffff", $HighlightBGColor = "#F0F9FF", $HeaderBGColor = "#007EE5", $BodyTxtColor = "#000000", $HeaderTxtColor = "#ffffff", $HeadersOn = 1)
	If IsArray($aArray) = 0 Then Return -1
	Local $aTRlines = ''
	Local $aTHlines = ''
	Local $aTDlines = ''
	Local $BodyStart = 1
	Local $TotalRows = UBound($aArray);rows
	Local $TotalColumns = UBound($aArray, 2);columns
	Local $CSS = 'table {margin: 1em; border-collapse: collapse; }' & @CRLF & _
			'td, th {padding: .3em; border: 1px #ccc solid; }' & @CRLF & _
			'thead {background: ' & $HeaderBGColor & '; }' & @CRLF & _
			'thead {color:' & $HeaderTxtColor & ';}' & @CRLF & _
			'tbody {background: ' & $BodyBGColor & '; }' & @CRLF & _
			'tbody {color: ' & $BodyTxtColor & '; }' & @CRLF & _
			'#highlight tr.hilight { background: ' & $HighlightBGColor & '; } '
	Local $JavaScript = "function tableHighlightRow() {" & @CRLF & _
			"  if (document.getElementById && document.createTextNode) {" & @CRLF & _
			"    var tables=document.getElementsByTagName('table');" & @CRLF & _
			"    for (var i=0;i<tables.length;i++)" & @CRLF & _
			"    {" & @CRLF & _
			"      if(tables[i].className=='hilite') {" & @CRLF & _
			"        var trs=tables[i].getElementsByTagName('tr');" & @CRLF & _
			"        for(var j=0;j<trs.length;j++)" & @CRLF & _
			"			{" & @CRLF & _
			"          if(trs[j].parentNode.nodeName=='TBODY') {" & @CRLF & _
			"            trs[j].onmouseover=function(){this.className='hilight';return false}" & @CRLF & _
			"            trs[j].onmouseout=function(){this.className='';return false}" & @CRLF & _
			"          }" & @CRLF & _
			"        }" & @CRLF & _
			"      }" & @CRLF & _
			"    }" & @CRLF & _
			"  }" & @CRLF & _
			"}" & @CRLF & _
			"window.onload=function(){tableHighlightRow();}"
	If $HeadersOn <> 1 Then
		$BodyStart = 0
	Else
		If $TotalRows < 2 Then Return -2;there needs to be at least two rows if headers are on
		For $x = 0 To $TotalColumns - 1
			$aTHlines = $aTHlines & '	<th>' & $aArray[0][$x] & '</th>' & @CRLF
		Next
	EndIf
	For $x = $BodyStart To $TotalRows - 1
		$aTDlines = ''
		For $i = 0 To $TotalColumns - 1
			$aTDlines = $aTDlines & '	<td>' & $aArray[$x][$i] & '</td>' & @CRLF
		Next
		$aTRlines = $aTRlines & '<tr>' & @CRLF & _
				$aTDlines & _
				'</tr>' & @CRLF
	Next
	$HTML = '<!DOCTYPE html><html>' & @CRLF & _
			'<head> ' & @CRLF & _
			'<Style>' & @CRLF & _
			$CSS & @CRLF & _
			'</Style>' & @CRLF & _
			'<script>' & @CRLF & _
			$JavaScript & @CRLF & _
			'</script>' & @CRLF & _
			'</head>' & @CRLF & _
			'<body><p align="center"><table class="hilite" id="highlight" style="width:60%">' & @CRLF & _
			'<thead>' & @CRLF & _
			'<tr>' & @CRLF & _
			$aTHlines & _
			'</tr>' & @CRLF & _
			'</thead>' & @CRLF & _
			'</p><tbody>' & @CRLF & _
			$aTRlines & _
			'</tbody>' & @CRLF & _
			'</table></body></html>'
	Return $HTML
EndFunc   ;==>_Array2HTMLTable