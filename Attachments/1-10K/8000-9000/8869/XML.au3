Func XML_Create($columns, $rows)
	$num_elements=3
	dim $XML_Array[$columns+1][$rows+1][$num_elements]
	for $loop1=0 to $columns
		for $loop2=0 to $rows
			for $loop3=0 to $num_elements-1
				$XML_Array[$loop1][$loop2][$loop3]=" "
			Next
		Next
	next
	$XML_Array[0][0][0]=0
	$XML_Array[0][0][1]=0
	$XML_Array[0][0][2]="DEFAULT"
	return $XML_Array
EndFunc
Func XML_Workbook_SetName(byref $XML_Array, $name)
	$XML_Array[0][0][2]=$name
EndFunc
Func XML_Cell_SetType(byref $XML_Array, $column, $row, $data_type)
	if $column > $XML_Array[0][0][0] then $XML_Array[0][0][0]=$column
	if $row > $XML_Array[0][0][1] then $XML_Array[0][0][1]=$row
	$data_type=stringupper($data_type)
	if $data_type="NUMBER" or $data_type="VALUE" Then
		$XML_Array[$column][$row][0]=0
	elseif $data_type="TEXT" or $data_type="STRING" Then
		$XML_Array[$column][$row][0]=1
	EndIf
EndFunc
Func XML_Cell_SetData(byref $XML_Array, $column, $row, $data)
	if $column > $XML_Array[0][0][0] then $XML_Array[0][0][0]=$column
	if $row > $XML_Array[0][0][1] then $XML_Array[0][0][1]=$row
	if $data="0" or int($data)>0 then 
		if $XML_Array[$column][$row][0] = " " then $XML_Array[$column][$row][0]=0
		$XML_Array[$column][$row][1]=$data
	Else
		if $XML_Array[$column][$row][0] = " " then $XML_Array[$column][$row][0]=1
		$XML_Array[$column][$row][1]=$data
	EndIF
EndFunc
Func XML_Cell_GetData(byref $XML_Array, $column, $row)
	return $XML_Array[$column][$row][1]
endFunc
Func XML_Cell_SetColor(byref $XML_Array, $column, $row, $color)
	$XML_Array[$column][$row][2]=$color
EndFunc
Func XML_Cell_GetColor(byref $XML_Array, $column, $row)
	return $XML_Array[$column][$row][2]
EndFunc
Func XML_Row_SetColor(byref $XML_Array, $row, $color)
	$XML_Array[0][$row][0]=$color
EndFunc
Func XML_Column_SetColor(byref $XML_Array, $column, $color)
EndFunc
Func XML_Write(byref $XML_Array, $filename)
	$outputfile=fileopen($filename, 1)
FileWriteLine($outputfile, "<?xml version=""1.0""?>")
FileWriteLine($outputfile, "<?mso-application progid=""Excel.Sheet""?>")
FileWriteLine($outputfile, "<Workbook xmlns=""urn:schemas-microsoft-com:office:spreadsheet""")
FileWriteLine($outputfile, " xmlns:o=""urn:schemas-microsoft-com:office:office""")
FileWriteLine($outputfile, " xmlns:x=""urn:schemas-microsoft-com:office:excel""")
FileWriteLine($outputfile, " xmlns:ss=""urn:schemas-microsoft-com:office:spreadsheet""")
FileWriteLine($outputfile, " xmlns:html=""http://www.w3.org/TR/REC-html40"">")
FileWriteLine($outputfile, " <DocumentProperties xmlns=""urn:schemas-microsoft-com:office:office"">")
FileWriteLine($outputfile, "  <Version>11.6360</Version>")
FileWriteLine($outputfile, " </DocumentProperties>")
FileWriteLine($outputfile, " <ExcelWorkbook xmlns=""urn:schemas-microsoft-com:office:excel"">")
FileWriteLine($outputfile, "  <WindowHeight>10005</WindowHeight>")
FileWriteLine($outputfile, "  <WindowWidth>10005</WindowWidth>")
FileWriteLine($outputfile, "  <WindowTopX>120</WindowTopX>")
FileWriteLine($outputfile, "  <WindowTopY>135</WindowTopY>")
FileWriteLine($outputfile, "  <ProtectStructure>False</ProtectStructure>")
FileWriteLine($outputfile, "  <ProtectWindows>False</ProtectWindows>")
FileWriteLine($outputfile, " </ExcelWorkbook>")
FileWriteLine($outputfile, " <Styles>")
FileWriteLine($outputfile, "  <Style ss:ID=""Default"" ss:Name=""Normal"">")
FileWriteLine($outputfile, "   <Alignment ss:Vertical=""Bottom""/>")
FileWriteLine($outputfile, "   <Borders/>")
FileWriteLine($outputfile, "   <Font/>")
FileWriteLine($outputfile, "   <Interior/>")
FileWriteLine($outputfile, "   <NumberFormat/>")
FileWriteLine($outputfile, "   <Protection/>")
FileWriteLine($outputfile, "  </Style>")
FileWriteLine($outputfile, "  <Style ss:ID=""RED"">")
FileWriteLine($outputfile, "   <Interior ss:Color=""#FF0000"" ss:Pattern=""Solid""/>")
FileWriteLine($outputfile, "  </Style>")
FileWriteLine($outputfile, "  <Style ss:ID=""YELLOW"">")
FileWriteLine($outputfile, "   <Interior ss:Color=""#FFFF00"" ss:Pattern=""Solid""/>")
FileWriteLine($outputfile, "  </Style>")
FileWriteLine($outputfile, "  <Style ss:ID=""GREEN"">")
FileWriteLine($outputfile, "   <Interior ss:Color=""#339966"" ss:Pattern=""Solid""/>")
FileWriteLine($outputfile, "  </Style>")
FileWriteLine($outputfile, "  <Style ss:ID=""BLUE"">")
FileWriteLine($outputfile, "   <Interior ss:Color=""#0000FF"" ss:Pattern=""Solid""/>")
FileWriteLine($outputfile, "  </Style>")
FileWriteLine($outputfile, "  <Style ss:ID=""ORANGE"">")
FileWriteLine($outputfile, "   <Interior ss:Color=""#FF6600"" ss:Pattern=""Solid""/>")
FileWriteLine($outputfile, "  </Style>")
FileWriteLine($outputfile, "  <Style ss:ID=""PURPLE"">")
FileWriteLine($outputfile, "   <Interior ss:Color=""#800080"" ss:Pattern=""Solid""/>")
FileWriteLine($outputfile, "  </Style>")
FileWriteLine($outputfile, "  <Style ss:ID=""GREY"">")
FileWriteLine($outputfile, "   <Interior ss:Color=""#969696"" ss:Pattern=""Solid""/>")
FileWriteLine($outputfile, "  </Style>")
FileWriteLine($outputfile, "  <Style ss:ID=""DARK TEAL"">")
FileWriteLine($outputfile, "   <Interior ss:Color=""#003366"" ss:Pattern=""Solid""/>")
FileWriteLine($outputfile, "  </Style>")
FileWriteLine($outputfile, "  <Style ss:ID=""DARK BLUE"">")
FileWriteLine($outputfile, "   <Interior ss:Color=""#000080"" ss:Pattern=""Solid""/>")
FileWriteLine($outputfile, "  </Style>")
FileWriteLine($outputfile, "  <Style ss:ID=""INDIGO"">")
FileWriteLine($outputfile, "   <Interior ss:Color=""#333399"" ss:Pattern=""Solid""/>")
FileWriteLine($outputfile, "  </Style>")
FileWriteLine($outputfile, "  <Style ss:ID=""DARK RED"">")
FileWriteLine($outputfile, "   <Interior ss:Color=""#800000"" ss:Pattern=""Solid""/>")
FileWriteLine($outputfile, "  </Style>")
FileWriteLine($outputfile, "  <Style ss:ID=""AQUA"">")
FileWriteLine($outputfile, "   <Interior ss:Color=""#33CCCC"" ss:Pattern=""Solid""/>")
FileWriteLine($outputfile, "  </Style>")
FileWriteLine($outputfile, "  <Style ss:ID=""VIOLET"">")
FileWriteLine($outputfile, "   <Interior ss:Color=""#800080"" ss:Pattern=""Solid""/>")
FileWriteLine($outputfile, "  </Style>")
FileWriteLine($outputfile, "  <Style ss:ID=""TURQUOISE"">")
FileWriteLine($outputfile, "   <Interior ss:Color=""#00FFFF"" ss:Pattern=""Solid""/>")
FileWriteLine($outputfile, "  </Style>")
FileWriteLine($outputfile, "  <Style ss:ID=""PINK"">")
FileWriteLine($outputfile, "   <Interior ss:Color=""#FF00FF"" ss:Pattern=""Solid""/>")
FileWriteLine($outputfile, "  </Style>")
FileWriteLine($outputfile, " </Styles>")
FileWriteLine($outputfile, " <Worksheet ss:Name=""" & $XML_Array[0][0][2] & """>")
FileWriteLine($outputfile, "<Table ss:ExpandedColumnCount=""" & $XML_Array[0][0][0] & """ ss:ExpandedRowCount=""" & $XML_Array[0][0][1] & """>")
	for $loop1=1 to $XML_Array[0][0][1]
		filewrite($outputfile, "   <Row ss:Index=""" & $loop1 & """")
		if $XML_Array[0][$loop1][0] <> " " Then
			filewrite($outputfile, " ss:StyleID=""" & $XML_Array[0][$loop1][0] & """")
		EndIf
		filewriteline($outputfile, ">")
		for $loop2=1 to $XML_Array[0][0][0]
		    if $XML_Array[$loop2][$loop1][1] <> " " then 
				filewrite($outputfile, "<Cell ss:Index=""" & $loop2 & """")
				if $XML_Array[$loop2][$loop1][2] <> " " Then
					filewrite($outputfile, " ss:StyleID=""" & ($XML_Array[$loop2][$loop1][2]) & """")
				endif
				filewrite($outputfile, "><Data ss:Type=""")
				if $XML_Array[$loop2][$loop1][0]=0 then 
					filewrite($outputfile, 	"Number")
				elseif $XML_Array[$loop2][$loop1][0]=1 Then
					filewrite($outputfile, "String")
				EndIf
				filewrite($outputfile, """>")
				filewriteline($outputfile, $XML_Array[$loop2][$loop1][1] & "</Data></Cell>")
			endif
		Next
		filewriteline($outputfile, "   </Row>")
	next
	FileWriteLine($outputfile, "  </Table>")
FileWriteLine($outputfile, "  <WorksheetOptions xmlns=""urn:schemas-microsoft-com:office:excel"">")
FileWriteLine($outputfile, "   <Print>")
FileWriteLine($outputfile, "    <ValidPrinterInfo/>")
FileWriteLine($outputfile, "    <HorizontalResolution>600</HorizontalResolution>")
FileWriteLine($outputfile, "    <VerticalResolution>600</VerticalResolution>")
FileWriteLine($outputfile, "   </Print>")
FileWriteLine($outputfile, "   <Selected/>")
FileWriteLine($outputfile, "   <Panes>")
FileWriteLine($outputfile, "    <Pane>")
FileWriteLine($outputfile, "     <Number>3</Number>")
FileWriteLine($outputfile, "     <ActiveRow>1</ActiveRow>")
FileWriteLine($outputfile, "     <ActiveCol>1</ActiveCol>")
FileWriteLine($outputfile, "    </Pane>")
FileWriteLine($outputfile, "   </Panes>")
FileWriteLine($outputfile, "   <ProtectObjects>False</ProtectObjects>")
FileWriteLine($outputfile, "   <ProtectScenarios>False</ProtectScenarios>")
FileWriteLine($outputfile, "  </WorksheetOptions>")
FileWriteLine($outputfile, " </Worksheet>")
FileWriteLine($outputfile, "</Workbook>")
fileclose($outputfile)
EndFunc
Func XML_Colors()
	dim $color_array[16]
	$color_array[0]=15
	$Color_Array[1]="RED"
	$Color_Array[2]="GREEN"
	$Color_Array[3]="BLUE"
	$Color_Array[4]="ORANGE"
	$Color_Array[5]="PURPLE"
	$Color_Array[6]="GREY"
	$Color_Array[7]="DARK TEAL"
	$Color_Array[8]="DARK BLUE"
	$Color_Array[9]="INDIGO"
	$Color_Array[10]="DARK RED"
	$Color_Array[11]="AQUA"
	$Color_Array[12]="VIOLET"
	$Color_Array[13]="TURQUOISE"
	$Color_Array[14]="PINK"
	$Color_Array[15]="YELLOW"
	Return $color_array
endfunc
Func XML_Write_CSV(byref $XML_Array, $filename)
	$outputfile=fileopen($filename, 1)
	for $loop1=1 to $XML_Array[0][0][1]
		for $loop2=1 to $XML_Array[0][0][0]
			filewrite($outputfile, $XML_Array[$loop2][$loop1][1] & ",")
		Next
		filewriteline($outputfile, "")
	Next
	fileclose($outputfile)
endfunc




