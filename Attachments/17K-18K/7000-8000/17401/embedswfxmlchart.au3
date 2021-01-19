;---------------------------------------------------
;Embed SWF / XML Chart into AutoIT
;---------------------------------------------------
;Author: WeaponX
;Version 1 completed 11/01/07

;---------------------------------------------------
;Convert chart array into usable XML
;---------------------------------------------------
;theArray: See my example. Due to limitations of AutoIT I had to fake some associative arrays so this has to be be very specific
;Also see: http://www.maani.us/xml_charts/index.php?menu=Reference for a reference
;I personally converted this function from the PHP version found here: http://www.maani.us/charts/index.php?menu=Download
Func _array2xml(ByRef $theArray)
	$xml = "<chart>" & @CRLF
		
		;Loop through all array elements
		For $X = 0 to Ubound($theArray) - 1
			
			;If element has a key and value
			If $theArray[$X][0] <> "" AND $theArray[$X][1] <> "" Then
				If IsArray($theArray[$X][1]) Then
					$tempData = $theArray[$X][1]
					Switch $theArray[$X][0]
						;If the current element contains the chart_data array
						Case "chart_data"
							$xml &= @TAB & "<chart_data>" & @CRLF

							;_ArrayDisplay($tempData)
							
							;Loop through each row
							For $Y = 0 to Ubound($tempData) - 1
								$xml &= @TAB & @TAB & "<row>" & @CRLF 
									;Loop through each column
									For $Z = 0 to Ubound($tempData, 2) - 1
										;If element is empty
										If $tempData[$Y][$Z] = "" Then
											$xml &= @TAB & @TAB & @TAB & "<null/>" & @CRLF
										Else
											;If first row or column, designate as label
											If $Z = 0 OR $Y = 0 Then
												$xml &= @TAB & @TAB & @TAB & "<string>" & $tempData[$Y][$Z] & "</string>" & @CRLF
											Else
												$xml &= @TAB & @TAB & @TAB & "<number>" & $tempData[$Y][$Z] & "</number>" & @CRLF										
											EndIf
										EndIf
									Next
								$xml &= @TAB & @TAB & "</row>" & @CRLF
							Next
							$xml &= @TAB & "</chart_data>" & @CRLF
						
						;If the current element contains the draw array (contains objects)
						Case "draw"
							$xml &= @TAB & "<draw>" & @CRLF
							For $Z = 0 to Ubound($tempData) - 1
								;If the object contains keys
								If Ubound($tempData[$Z].Keys) > 0 Then
								
									;Store key name
									$xml &=  @TAB & @TAB & "<" & $tempData[$Z].Item("type") & " "
									For $value In $tempData[$Z]
										;Skip text and type keys
										If $value <> "text" AND $value <> "type" Then
											;Store attribute and value
											$xml &= $value & "='" & $tempData[$Z].Item($value) & "' "
										EndIf
									Next
									$xml &= ">" & $tempData[$Z].Item("text") & "</" & $tempData[$Z].Item("type") & ">" & @CRLF
								EndIf
							Next
							$xml &= @TAB & "</draw>" & @CRLF
						
						Case Else
							;Assume array is 1D
							Switch $theArray[$X][0]
								Case "series_color"
									$xml &= @TAB & "<" & $theArray[$X][0] & ">" & @CRLF
									For $Y = 0 to Ubound($tempData) - 1
										$xml &= @TAB & @TAB & "<color>" & $tempData[$Y] & "</color>"  & @CRLF
									Next
									$xml &= @TAB & "</" & $theArray[$X][0] & ">" & @CRLF
								Case Else
									$xml &= @TAB & "<" & $theArray[$X][0] & ">" & @CRLF
									For $Y = 0 to Ubound($tempData) - 1
										$xml &= @TAB & @TAB & "<string>" & $tempData[$Y] & "</string>"  & @CRLF
									Next
									$xml &= @TAB & "</" & $theArray[$X][0] & ">" & @CRLF
							EndSwitch
					EndSwitch
				ElseIf IsObj($theArray[$X][1])Then
					
					;If the object contains keys
					If Ubound($theArray[$X][1].Keys) > 0 Then
					
						;Store key name
						$xml &= @TAB & "<" & $theArray[$X][0] & " "
						For $value In $theArray[$X][1]
							If $theArray[$X][1].Item($value) <> "" Then
								;Store attribute and value
								$xml &= $value & "='" & $theArray[$X][1].Item($value) & "' "
							EndIf
						Next
						$xml &= "/>" & @CRLF
					EndIf
				Else
					$xml &= @TAB & "<" & $theArray[$X][0] & ">" & $theArray[$X][1] & "</" & $theArray[$X][0] & ">" & @CRLF
				EndIf
			EndIf
		Next
	$xml &= "</chart>"
	
	;MsgBox(0,"",$xml)
	
	Return $xml
EndFunc


;---------------------------------------------------
;Create SWF Chart
;---------------------------------------------------
;$SWFChartPath: Here you can pass either raw xml or a path to an xml file
;$SWFChartL: Left
;$SWFChartT: Top
;$SWFChartW: Width
;$SWFChartH: Height
;$SWFChartBGColor: Background Hex color (Note: Must be a string i.e. "#505050" or "505050", hex will not work)

Func _CreateSWFChart($SWFChartPath, $SWFChartL, $SWFChartT, $SWFChartW, $SWFChartH, $SWFChartFlag = 0, $SWFChartBGColor = "505050")

	; Create Flash Object
	$SWFChartObj = ObjCreate("ShockwaveFlash.ShockwaveFlash")
	$SWFChartActiveX = GUICtrlCreateObj( $SWFChartObj, $SWFChartL, $SWFChartT, $SWFChartW, $SWFChartH)

	; Configure Flash Object
	With $SWFChartObj
		.Movie = @ScriptDir & '\charts.swf'
		.ScaleMode = 3 ;0 showall, 1 noborder, 2 exactFit, 3 noscale
		.bgcolor = $SWFChartBGColor
		.Loop = 'True'
		.WMode = "transparent"
		.allowScriptAccess = "Always"
		
		;Variable inject Method 1
		;.FlashVars = '&library_path=' & @ScriptDir & '\charts_library&xml_source=' & $SWFChartPath
		
		;Variable inject Method 2
		.SetVariable('library_path', @ScriptDir & '\charts_library')
		
		If $SWFChartFlag Then
			;To accept raw xml, line breaks must be stripped
			.SetVariable('update_xml', StringStripCR(StringStripWS($SWFChartPath, 4)))
		Else
			.SetVariable('xml_source', $SWFChartPath)
		EndIf
	EndWith
	
	Return $SWFChartObj
EndFunc

;---------------------------------------------------
;Refresh chart
;---------------------------------------------------
;SWFChartHandle: Handle returned from _CreateSWFChart()
;SWFChartPath: Path to xml or raw xml data can be used with flag
;SWFChartFlag: 0 if SWFChartPath is a file, 1 If SWFChartPath is raw xml
Func _UpdateSWFChart($SWFChartHandle, $SWFChartPath, $SWFChartFlag = 0)
	With $SWFChartHandle
		;.SetVariable('update_xml', '<chart><chart_type>line</chart_type></chart>')
		
		If $SWFChartFlag Then
			;To accept raw xml, line breaks must be stripped
			.SetVariable('update_xml', StringStripCR(StringStripWS($SWFChartPath, 4)))
		Else
			.SetVariable('xml_source', $SWFChartPath)
		EndIf
	EndWith
EndFunc