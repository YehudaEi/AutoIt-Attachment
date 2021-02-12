#NoTrayIcon
#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=..\icons\arrow_down.ico
#AutoIt3Wrapper_outfile=mdbcon.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_Comment=MicroWorld
#AutoIt3Wrapper_Res_Description=MDB to CSV
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © MicroWorld Technologies Inc.
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_Field=CompanyName|MicroWorld Technologies Inc.
#AutoIt3Wrapper_Res_Field=ProductName|MDB to CSV
#AutoIt3Wrapper_Res_Field=InternalName|MDB to CSV
#AutoIt3Wrapper_Res_Field=ProductVersion|1.0.0.0
#AutoIt3Wrapper_Res_Field=LegalTrademarks|
#AutoIt3Wrapper_Res_Field=OriginalFilename|mdbcon.exe
#AutoIt3Wrapper_Run_Tidy=y
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****

Const $ForWriting = 2
Const $adSchemaTables = 20

Global $g_eventerror = 0, $oMyError

Dim $output_file
Dim $file_name
Dim $table_name
Dim $password
Dim $i = 1

$file_name = ""
$table_name = ""

If $Cmdline[0] == 0 Or $Cmdline > 2 Then
	ConsoleWrite('Wrong Number of Parameters' & @CRLF & _
			'mdbcon.exe path_to_db password' & @CRLF & 'OR' & _
			@CRLF & 'mdbcon.exe path_to_db')
	Exit
EndIf

If $Cmdline[0] == 1 Then
	$file_name = $Cmdline[1]
	$password = ''
EndIf

If $Cmdline[0] == 2 Then
	$file_name = $Cmdline[1]
	$password = StringStripWS($Cmdline[2], 8)
EndIf

$table_name = table_name($file_name, $password)
$table_name = StringSplit($table_name, '|', 1)

If @error <> 1 Then
	While $i <= $table_name[0]
		If $table_name[$i] <> '' Then
			$output_file = $file_name & '.' & $table_name[$i] & ".csv"
			doit($file_name, $table_name[$i], $output_file, $password)
		EndIf
		$i += 1
	WEnd
EndIf
Func doit($file_name, $table_name, $output_file, $password)
	Dim $sql
	Dim $cn
	Dim $rs
	Dim $oxl
	Dim $t
	$t = TimerInit()

	$cn = ObjCreate("ADODB.Connection")
	$rs = ObjCreate("ADODB.Recordset")

	Global $g_eventerror = 0 ; to be checked to know if com error occurs. Must be reset after handling.
	Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc") ; Initialize a COM error handler


	; Here we set connection properties, open a connection, and create a recordset with the $sql
	; Note that setting the properties takes the place of creating a connection string.
	With $cn
		; This can work with other databases.  Look at http://connectionstrings.com/
		; You could extend this to accept other database types.
		if (StringRight($file_name, 6) = ".accdb") Then
			; For Access 2007, use this:
			.ConnectionString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & $file_name & ";Persist Security Info=False;Jet OLEDB:Database Password=" & $password & ";"
		elseif (StringRight($file_name, 4) = ".mdb") Then
			; This is for Access 2003 files
			.ConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source='" & $file_name & "';Jet OLEDB:Database Password=" & $password & ";"
		Else
			ConsoleWrite("File type not recognized: " & $file_name)
			Exit
		EndIf
		.Open()
	EndWith

	; Here we specify the $sql we want to select data from
	$sql = "SELECT * FROM [" & $table_name & "]"
	$rs.Open($sql, $cn)
	Dim $fso, $file
	$fso = ObjCreate("Scripting.FileSystemObject")
	$file = $fso.opentextfile($output_file, $ForWriting, 1)

	; Lets $output the header row
	Dim $col
	Dim $line_to_write
	$line_to_write = ""
	For $col = 0 To $rs.fields.count - 1
		$line_to_write = $line_to_write & ", " & $rs($col).name
	Next

	; knock off the leading comma
	$line_to_write = StringMid($line_to_write, 3)
	$file.write($line_to_write & @CRLF)

	; $write out lines of data
	Dim $number_rows
	$number_rows = 0

	While Not $rs.EOF()
		$line_to_write = ""
		For $col = 0 To $rs.Fields.Count - 1
			$line_to_write = $line_to_write & ", """ & $rs($col).value & """"
		Next
		; knock off the leading comma
		$line_to_write = StringMid($line_to_write, 3)
		$file.write($line_to_write & @CRLF)
		$number_rows = $number_rows + 1
		$rs.movenext()
	WEnd
	$rs.Close()

	; Close all of the ADODB objects
	If $rs.State = 1 Then
		$rs.Close()
	EndIf
	If $cn.State = 1 Then
		$cn.Close()
	EndIf
	Return ;Exit
EndFunc   ;==>doit


Func MyErrFunc()
	If StringInStr($oMyError.description, 'password', 0) > 0 Then
		ConsoleWrite('This MDB requires a Password.')
	Else
		ConsoleWrite("Intercepted a COM Error" & @CRLF & @CRLF & _
				"err.description is  :" & @TAB & $oMyError.description & @CRLF & _
				"err.windescription  :" & @TAB & $oMyError.windescription & @CRLF & _
				"err.number is       :" & @TAB & Hex($oMyError.number, 8) & @CRLF & _
				"err.lastdllerror is :" & @TAB & $oMyError.lastdllerror & @CRLF & _
				"err.scriptline is   :" & @TAB & $oMyError.scriptline & @CRLF & _
				"err.source is       :" & @TAB & $oMyError.source & @CRLF & _
				"err.helpfile is     :" & @TAB & $oMyError.helpfile & @CRLF & _
				"err.helpcontext is  :" & @TAB & $oMyError.helpcontext _
				)
	EndIf
	Local $err = $oMyError.number
	If $err = 0 Then $err = -1
	$g_eventerror = $err ; to check for after this function returns
	Exit
EndFunc   ;==>MyErrFunc

Func table_name($file_name, $password)
	Dim $cn1
	Dim $rs1

	$cn1 = ObjCreate("ADODB.Connection")
	$rs1 = ObjCreate("ADODB.Recordset")

	Global $g_eventerror = 0 ; to be checked to know if com error occurs. Must be reset after handling.
	Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc") ; Initialize a COM error handler

	$cn1.Open("Provider = Microsoft.Jet.OLEDB.4.0; Data Source = '" & $file_name & "';Jet OLEDB:Database Password=" & $password & ";")

	$rs1 = $cn1.OpenSchema($adSchemaTables)

	While Not $rs1.EOF
		If $rs1("TABLE_TYPE" ).value = 'Table' Then
			$table_name = $table_name & $rs1("TABLE_NAME" ).value & '|'
		EndIf
		$rs1.MoveNext()
	WEnd

	If $rs1.State = 1 Then
		$rs1.Close()
	EndIf
	If $cn1.State = 1 Then
		$cn1.Close()
	EndIf

	Return $table_name
EndFunc   ;==>table_name