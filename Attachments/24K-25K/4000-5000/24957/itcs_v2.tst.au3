#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\Program Files\asset\bin\dollar_sign3.ico
#AutoIt3Wrapper_Outfile=C:\Program Files\asset\bin\ITCS.exe
#AutoIt3Wrapper_Res_Comment=Need Oracle ODBC along with SQL
#AutoIt3Wrapper_Res_Description=Inventory Tracking Cover Sheet
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Run_Tidy=y
#Tidy_Parameters=/rel /kv 3 /sf
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIComboBox.au3>
#include <WindowsConstants.au3>
#include <GuiTab.au3>
#include <Array.au3>
#include <String.au3>
#include <GUIConstants.au3>
#include <EditConstants.au3>
#include <IE.au3>
#include <GuiButton.au3>
;#include <ExcelCOM_UDF.au3>
#include <WinAPI.au3>
Global $oError
; Initializes COM Error handler
Global $g_eventerror = 0
$oIEErrorHandler = ObjEvent("AutoIt.Error", "ErrHandler") ;$oIEErrorHandler is manatory name of error handling if using IE
; Read Registry for location
#cs
	$bindir = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\ComcastNE\Asset", "")
	$ini_file = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\ComcastNE\Asset", "ini")
	$tempdir = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\ComcastNE\Asset", "temp")
	;$ini_file = "Asset_sql.ini"
	$upfile = "update_ITCS.csv"
	$updatefile = $tempdir & "\" & $upfile
	$ini_file2 = ""
	$progressbar2 = ""
	If Not FileExists($ini_file) Then
	$temp = StringSplit($ini_file, "\")
	If FileExists(@WorkingDir & "\" & $temp[$temp[0]]) Then
	$ini_file2 = @WorkingDir & "\" & $temp[$temp[0]]
	FileMove($ini_file2, $ini_file, 8)
	EndIf
	If $ini_file2 = "" Then
	$ini_file2 = FileOpenDialog("Asset INI file", "C:\", "ALL (" & $temp[$temp[0]] & ")", 3, $temp[$temp[0]])
	FileMove($ini_file2, $ini_file, 8)
	EndIf
	EndIf
	$ini_file2 = $ini_file
	$CR_server = ""
	$var = IniReadSection($ini_file2, "Database")
	For $i = 1 To $var[0][0]
	Switch $var[$i][0]
	Case "HR_server"
	$HR_server = StringReplace($var[$i][1], Chr(34), "", 2)
	Case "HR_dbname"
	$HR_dbname = StringReplace($var[$i][1], Chr(34), "", 2)
	Case "HR_table"
	$HR_table = StringReplace($var[$i][1], Chr(34), "", 2)
	Case "hr_user"
	$hr_user = StringReplace($var[$i][1], Chr(34), "", 2)
	Case "hr_Pass"
	$hr_Pass = $var[$i][1]
	If StringLeft($hr_Pass, 1) = Chr(34) Then
	$hr_Pass = StringReplace($var[$i][1], Chr(34), "", 2)
	IniWrite($ini_file2, "Database", "hr_Pass", _StringEncrypt(1, $hr_Pass, "StringEncrypt", 2))
	Else
	$hr_Pass = _StringEncrypt(0, $hr_Pass, "StringEncrypt", 2)
	EndIf
	Case "AS_server"
	$AS_server = StringReplace($var[$i][1], Chr(34), "", 2)
	Case "AS_dbname"
	$AS_dbname = StringReplace($var[$i][1], Chr(34), "", 2)
	Case "AS_user"
	$AS_user = StringReplace($var[$i][1], Chr(34), "", 2)
	Case "AS_Pass"
	$as_pass = $var[$i][1]
	If StringLeft($as_pass, 1) = Chr(34) Then
	$as_pass = StringReplace($var[$i][1], Chr(34), "", 2)
	IniWrite($ini_file2, "Database", "as_pass", _StringEncrypt(1, $as_pass, "StringEncrypt", 2))
	Else
	$as_pass = _StringEncrypt(0, $as_pass, "StringEncrypt", 2)
	EndIf
	Case "CR_server"
	$CR_server = StringReplace($var[$i][1], Chr(34), "", 2)
	Case "CR_dbname"
	$CR_dbname = StringReplace($var[$i][1], Chr(34), "", 2)
	Case "CR_user"
	$CR_user = StringReplace($var[$i][1], Chr(34), "", 2)
	Case "CR_Pass"
	$cr_pass = $var[$i][1]
	If StringLeft($cr_pass, 1) = Chr(34) Then
	$cr_pass = StringReplace($var[$i][1], Chr(34), "", 2)
	IniWrite($ini_file2, "Database", "cr_pass", _StringEncrypt(1, $cr_pass, "StringEncrypt", 2))
	Else
	$cr_pass = _StringEncrypt(0, $cr_pass, "StringEncrypt", 2)
	EndIf
	EndSwitch
	
	
	Next
	$taglength = IniRead($ini_file2, "Globals", "TAGLENGTH", 7)
	$address = IniRead($ini_file2, "Globals", "ADDRESS", "")
	$address = StringReplace($address, Chr(34), "", 2)
	$default_Area = IniRead($ini_file2, "Globals", "DEFAULT_AREA", "")
	$default_Area = StringReplace($default_Area, Chr(34), "", 2)
	$dell_support = IniRead($ini_file2, "Globals", "DELL_SUPPORT", "")
	$dell_support = StringReplace($dell_support, Chr(34), "", 2)
	$Emplookup = IniRead($ini_file2, "Globals", "EMPLOOKUP", "")
	$Emplookup = StringReplace($Emplookup, Chr(34), "")
	$Emp_ID = IniRead($ini_file2, "Globals", "EMP_ID", "")
	$Emp_ID = StringReplace($Emp_ID, Chr(34), "")
	$PERNR = IniRead($ini_file2, "Globals", "PERNR", "")
	$PERNR = StringReplace($PERNR, Chr(34), "", 2)
	$NTLOGIN = IniRead($ini_file2, "Globals", "NTLOGIN", "")
	$NTLOGIN = StringReplace($NTLOGIN, Chr(34), "", 2)
	If $Emplookup = "" Or $Emp_ID = "" Then
	MsgBox(0, "INI File Error", $ini_file & " is corrupt")
	Exit
	EndIf
	$Cr_page = $Emplookup & $NTLOGIN & "="
#ce
;
Dim $Defaults[20][4], $CRfields[1], $dropbox[2][2], $namelist[1][1]
$CRfields[0] = 0
;If $CR_server <> "" Then getcr($CRfields)
;_ArrayDisplay($CRfields)
$list = getdefaultsx($Defaults)
If $CRfields[0] = 0 Then ReDim $CRfields[75]
$field = False
$bundle = False
$contractor = False
$xx = 10
$prtlabels = 0
$ok = True
Global $tab[1], $inp[2], $inp2[2], $info[2][60], $B1[2], $b2[2]
Global $input[2][60], $radio[2][13], $ntype[2][10], $hr_array[1][1]
;$ado = ObjCreate("ADODB.Connection") ; Create a COM ADODB Object
;With $ado
;	.ConnectionString = ("DRIVER={SQL Server};SERVER=" & $AS_server & ";DATABASE=" & $AS_dbname & ";uid=" & $AS_user & ";pwd=" & $as_pass & ";")
;	.Open
;EndWith
;If @error Then Exit
$Pos2 = 600 + $xx
$pos3 = 720
;#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Inventory", $Pos2, $pos3, -1, -1)
GUISetBkColor(0xFFFFFF)
GUICtrlCreateLabel("Inventory Tracking Cover sheet", 176 + $xx, 0, 252, 20)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
#Region ### START Koda GUI section ### Form=
$tab[0] = GUICtrlCreateTab(5, 20, $Pos2 - 5, $pos3 - 10)
GUICtrlCreateTabItem("Sheet 1")
$types = _ArrayCreate("", "Desktop", "Laptop", "Monitor 1", "Monitor 2", "Port Replicator", "Printer", "")
$labloc = _ArrayCreate("", "", "", "", "", "", "", "")
$labels = _ArrayCreate("", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec")
If $CRfields[9] = "CONTRACTOR" Then $contractor = True
setupscreen(1)
; New Replace Redeploy Expense Special Loaner
GUICtrlSetState($ntype[1][1], $GUI_CHECKED)
If $CRfields[19] = "NEW" Then GUICtrlSetState($ntype[1][1], $GUI_CHECKED)
If $CRfields[19] = "Replacement" Then GUICtrlSetState($ntype[1][2], $GUI_CHECKED)
If $CRfields[19] = "Redeploy" Then GUICtrlSetState($ntype[1][3], $GUI_CHECKED)
If $CRfields[19] = "Expense" Then GUICtrlSetState($ntype[1][4], $GUI_CHECKED)
If $CRfields[19] = "Special" Then GUICtrlSetState($ntype[1][5], $GUI_CHECKED)
If $CRfields[9] = "CONTRACTOR" Then GUICtrlSetState($ntype[1][6], $GUI_CHECKED)
If $CRfields[3] = "accessories" Then GUICtrlSetState($ntype[1][4], $GUI_CHECKED)
If StringInStr($CRfields[22], "Replace ") Then GUICtrlSetState($ntype[1][2], $GUI_CHECKED)
$xb = 0
If StringInStr($CRfields[20], "Desktop") Then
	fillscreen(1, 10, "Desktop")
	fillscreen(1, 25, "Desktop")
	fillscreen(1, 26, "Desktop")
EndIf
If StringInStr($CRfields[20], "Laptop") Then
	fillscreen(1, 12, "Laptop")
	fillscreen(1, 26, "Laptop")
	fillscreen(1, 28, "Laptop")
	fillscreen(1, 32, "Laptop")
	$xb = $xb + 1
EndIf
If StringInStr($CRfields[20], "Monitor") Then
	fillscreen(1, 14, "Monitor")
	$xb = $xb + 1
EndIf
If StringInStr($CRfields[20], "Port Replicator") Then
	$xb = $xb + 1
	If $xb = 3 Then $bundle = True
	fillscreen(1, 18, "Port Replicator")
	If $bundle Then
		fillscreen(1, 12, "Laptop")
		fillscreen(1, 25, "Laptop")
	EndIf
EndIf
If StringInStr($CRfields[60], "YES") Then
	fillscreen(1, 25, "") ; Keyboard
EndIf
If StringInStr($CRfields[61], "YES") Then
	fillscreen(1, 26, "") ; Mouse
EndIf
If StringInStr($CRfields[68], "YES") And StringInStr($CRfields[69], "Printer Cable") Then
	fillscreen(1, 27, "")
EndIf
If StringInStr($CRfields[55], "YES") Then
	fillscreen(1, 28, ""); AC Adaptor
EndIf
If StringInStr($CRfields[20], "JET") Then
	fillscreen(1, 29, "")
EndIf
If StringInStr($CRfields[20], "DIRECT") Then
	fillscreen(1, 29, "")
EndIf
If StringInStr($CRfields[74], "YES") And $CRfields[3] = "accessories" Then
	fillscreen(1, 14, "Monitor")
EndIf
If StringInStr($CRfields[68], "YES") And StringInStr($CRfields[69], "DUAL") Then
	fillscreen(1, 16, "Monitor")
	fillscreen(1, 30, "Monitor")
EndIf
If StringInStr($CRfields[22], "DUAL VIDEO") Or StringInStr($CRfields[22], "DUAL MONITOR") Then
	fillscreen(1, 16, "Monitor")
	fillscreen(1, 30, "Monitor")
EndIf
If StringInStr($CRfields[68], "YES") And StringInStr($CRfields[69], "Battery") Then
	fillscreen(1, 31, "")
	GUICtrlSetData($input[1][34], "")
	$CRfields[68] = ""
EndIf
If StringInStr($CRfields[20], "Bag") Then
	fillscreen(1, 32, "")
EndIf
If StringInStr($CRfields[65], "YES") And $CRfields[3] = "accessories" Then
	$temp = StringSplit($CRfields[28], " ")
	GUICtrlSetData($input[1][33], "1GB " & $temp[$temp[0]])
EndIf
If StringInStr($CRfields[68], "YES") Then
	GUICtrlSetData($input[1][34], $CRfields[69])
EndIf
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
While 1
	$Ntabs = _GUICtrlTab_GetItemCount($tab[0])
	$x = _GUICtrlTab_GetCurSel($tab[0]) + 1
	$nMsg = GUIGetMsg(1)
	;_WinAPI_EnableWindow($Form1, True)
	
	Switch $nMsg[0]
		Case $GUI_EVENT_CLOSE
			Exit
		Case $B1[$x]
			$ok = readtab($x)
			;If $ok Then
			;$uptmp = sendtotemp()
			;$update = sendtoupdate()
			#cs
				RunWait($bindir & "\invlabels.exe " & "M")
				If $update Then RunWait($bindir & "\updateinv.exe " & $upfile)
				$Remedy = WinExists("BMC Remedy User - SC:Support Center Ticket")
				$new = False
				If StringStripWS(GUICtrlRead($input[$x][24]), 8) = "" Then
				Do
				$Prt = MsgBox(4, "Print", "Print Inventory Tracking Sheet Now - No Remedy Ticket")
				Until $Prt = 6 Or $Prt = 7
				If $Prt = 6 Then
				$new = True
				RunWait($bindir & "\invexcelupdate.exe " & "Dummy" & " " & "Temp_ITCS.xls")
				Run($bindir & "\writeword.exe " & "Expensed")
				EndIf
				EndIf
				If $Remedy Then
				If Not $new Then Run($bindir & "\close cr.exe ")
				Else
				If Not $new Then
				ToolTip("Please Login into Remedy" & @LF & " and select" & @LF & "New SC:Support Center Ticket", 0, 0, "REMEDY Not Active", 2)
				Beep(100, 100)
				WinWait("BMC Remedy User - SC:Support Center Ticket")
				Run($bindir & "\close cr.exe ")
				EndIf
				EndIf
			#ce
			Exit
			;EndIf
			;#ce
		Case $b2[$x]
			$ok = readtab($x)
			If $ok Then createtab()
			
		Case $dropbox[$x][1]
			$temp = GUICtrlRead($nMsg[0])
			
			$flag = _GUICtrlComboBox_GetCurSel($nMsg[0]) + 1
			ConsoleWrite($flag & @LF)
			GUICtrlSetState($dropbox[$x][1], $GUI_DISABLE + $gui_hide)
			GUICtrlSetState($input[$x][1], $gui_enable + $gui_show)
			GUICtrlSetData($input[$x][1], $temp)
			;_WinAPI_EnableWindow($Form1, False)
			ControlFocus("Inventory", "", $input[$x][1])
			$cursor = ControlGetFocus("Inventory")
			$out = getname(GUICtrlRead($nMsg[0]), $flag)
			GUICtrlSetData($input[$x][1], $CRfields[12] & " " & $CRfields[11])
			If $out = 1 Then
				GUICtrlSetData($input[$x][4], $CRfields[14])
				getaddress($CRfields[4], $CRfields[14], $CRfields[8])
				If GUICtrlRead($input[$x][52]) = "" Then
					getaddress($CRfields[4], $CRfields[14], $CRfields[8])
					GUICtrlSetData($input[$x][53], $CRfields[52])
					GUICtrlSetData($input[$x][54], $CRfields[4])
				EndIf
				If GUICtrlRead($input[$x][51]) = "000000" Then
					getentity($CRfields[7])
					GUICtrlSetData($input[$x][51], StringRight("000000" & $CRfields[7], 6))
					GUICtrlSetData($input[$x][2], $CRfields[1])
				EndIf
				ControlFocus("Inventory", "", $input[$x][24])
				$cursor = ControlGetFocus("Inventory")
			Else
				If $out = 0 Then
					ControlFocus("Inventory", "", $dropbox[$x][1])
					$cursor = ControlGetFocus("Inventory")
				Else
					ControlFocus("Inventory", "", $input[$x][1])
					$cursor = ControlGetFocus("Inventory")
				EndIf
			EndIf
			;_WinAPI_EnableWindow($Form1, True)
			
			
		Case $input[$x][1]
			;_WinAPI_EnableWindow($Form1, False)
			$tmp = GUICtrlRead($nMsg[0])
			If Number($tmp) <> 0 Then
				gethrpernr($tmp)
				$out = 1
			Else
				$out = getname($tmp, 0)
			EndIf
			GUICtrlSetData($input[$x][1], $CRfields[12] & " " & $CRfields[11])
			If $out = 1 Then
				GUICtrlSetData($input[$x][4], $CRfields[14])
				getaddress($CRfields[4], $CRfields[14], $CRfields[8])
				If GUICtrlRead($input[$x][52]) = "" Then
					getaddress($CRfields[4], $CRfields[14], $CRfields[8])
					GUICtrlSetData($input[$x][53], $CRfields[52])
					GUICtrlSetData($input[$x][54], $CRfields[4])
				EndIf
				If GUICtrlRead($input[$x][51]) = "000000" Then
					getentity($CRfields[7])
					GUICtrlSetData($input[$x][51], StringRight("000000" & $CRfields[7], 6))
					GUICtrlSetData($input[$x][2], $CRfields[1])
				EndIf
				ControlFocus("Inventory", "", $input[$x][24])
				$cursor = ControlGetFocus("Inventory")
			Else
				If $out = 0 Then
					ControlFocus("Inventory", "", $input[$x][1])
					$cursor = ControlGetFocus("Inventory")
				Else
					ControlFocus("Inventory", "", $dropbox[$x][1])
					$cursor = ControlGetFocus("Inventory")
				EndIf
			EndIf
			;_WinAPI_EnableWindow($Form1, True)
			
			
		Case $input[$x][4]
			;_WinAPI_EnableWindow($Form1, False)
			$CRfields[14] = GUICtrlRead($nMsg[0])
			getaddress("", $CRfields[14], "")
			GUICtrlSetData($input[$x][53], $CRfields[52])
			GUICtrlSetData($input[$x][54], $CRfields[4])
			ControlFocus("Inventory", "", $input[$x][10])
			$cursor = ControlGetFocus("Inventory")
			;_WinAPI_EnableWindow($Form1, True)
		Case $input[$x][54]
			;_WinAPI_EnableWindow($Form1, False)
			$CRfields[4] = GUICtrlRead($nMsg[0])
			getaddress($CRfields[4], $CRfields[14], $CRfields[8])
			GUICtrlSetData($input[$x][53], $CRfields[52])
			GUICtrlSetData($input[$x][54], $CRfields[4])
			ControlFocus("Inventory", "", $input[$x][55])
			$cursor = ControlGetFocus("Inventory")
			;_WinAPI_EnableWindow($Form1, True)
			
		Case $input[$x][10], $input[$x][12], $input[$x][14], $input[$x][16], $input[$x][18], $input[$x][20], $input[$x][22]
			$tmp = $nMsg[0]
			If $x <> 1 Then $tmp = $nMsg[0] - (140 * ($x - 1)) - (($x * 3) - 3)
			
			$tmp = (($tmp - 74) + 4) / 4
			
			If GUICtrlRead($ntype[$x][3]) = $GUI_CHECKED Then
				If StringLen(StringStripWS(GUICtrlRead($nMsg[0]), 8)) Then
					GUICtrlSetData($nMsg[0], "R")
				Else
					GUICtrlSetData($nMsg[0], "")
				EndIf
			Else
				If StringLen(StringStripWS(GUICtrlRead($nMsg[0]), 8)) Then
					Switch StringStripWS(GUICtrlRead($nMsg[0]), 8)
						Case "R"
							GUICtrlSetData($nMsg[0], "R")
						Case Else
							GUICtrlSetData($nMsg[0], "X")
							$tmpx = StringSplit($types[$tmp], " ")
							$pos = _ArraySearch($Defaults, $tmpx[1], 0, 0, 0, 1, 1, 2)
							
							ConsoleWrite($pos & "," & $tmpx[1] & @LF)
							If StringStripWS(GUICtrlRead($nMsg[0] + 3), 8) = "" Then
								For $i = 1 To $Defaults[0][0]
									If $bundle And StringInStr($Defaults[$i][1], "Bundle") And StringInStr($Defaults[$i][2], $tmpx[1]) Then
										GUICtrlSetData($nMsg[0] + 3, $Defaults[$i][1])
										ExitLoop
									EndIf
									If StringInStr($Defaults[$i][2], $tmpx[1]) Then
										GUICtrlSetData($nMsg[0] + 3, $Defaults[$i][1])
										ExitLoop
									EndIf
								Next
							EndIf
					EndSwitch
				Else
					GUICtrlSetData($nMsg[0], "")
				EndIf
			EndIf
			If StringStripWS(GUICtrlRead($input[$x][12]), 8) <> "" And StringStripWS(GUICtrlRead($input[$x][14]), 8) <> "" And StringStripWS(GUICtrlRead($input[$x][18]), 8) <> "" Then
				$bundle = True
				fillscreen($x, 25, "") ; Keyboard
				fillscreen($x, 26, "") ; Mouse
				fillscreen($x, 28, ""); AC Adaptor
				fillscreen($x, 32, ""); Bag
				
			Else
				$bundle = False
			EndIf
			If StringStripWS(GUICtrlRead($input[$x][10]), 8) <> "" Then
				fillscreen($x, 25, "") ; Keyboard
				fillscreen($x, 26, "") ; Mouse
			EndIf
			If StringStripWS(GUICtrlRead($input[$x][12]), 8) <> "" Then
				fillscreen($x, 26, "") ; Mouse
				fillscreen($x, 28, ""); AC Adaptor
				fillscreen($x, 32, ""); Bag
			EndIf
			
			ControlFocus("Inventory", "", $nMsg[0] + 1)
			$cursor = ControlGetFocus("Inventory")
			
		Case $input[$x][37], $input[$x][39], $input[$x][41], $input[$x][43], $input[$x][45], $input[$x][47]
			$temp = StringStripWS(GUICtrlRead($nMsg[0]), 8)
			$temp = "Colunm2 WORKED"
			GUICtrlSetData($nMsg[0], $temp)
			ControlFocus("Inventory", "", $nMsg[0] + 1)
			$cursor = ControlGetFocus("Inventory")
			#cs
				$tmp = $nMsg[0]
				If $x <> 1 Then $tmp = $nMsg[0] - (140 * ($x - 1)) - (($x * 3) - 3)
				$tmp = (($tmp - 75) + 4) / 4
				$temp = StringStripWS(GUICtrlRead($nMsg[0]), 8)
				$temp = StringReplace($temp, "*", "", 2)
				GUICtrlSetData($nMsg[0], $temp)
				;_WinAPI_EnableWindow($Form1, False)
				
				If $temp <> "" Then
				$adors = ObjCreate("ADODB.RecordSet") ; Create a Record Set to handles SQL Records
				With $adors
				.ActiveConnection = $ado
				.Source = "select equipment_type,equipment_model,serial_num from SSI.TBL_ASSET_EQUIPMENT WHERE upper(Asset_num) ='" & StringUpper(GUICtrlRead($nMsg[0])) & "'" ; This is where the SQL line goes
				.open
				EndWith
				;_WinAPI_EnableWindow($Form1, True)
				If $adors.EOF Then
				$adors.close
				ControlFocus("Inventory", "", $nMsg[0] + 1)
				$cursor = ControlGetFocus("Inventory")
				ConsoleWrite("NEW" & @LF)
				Else
				ConsoleWrite("OLD" & @LF)
				$tmpx = StringSplit($types[$tmp], " ")
				ConsoleWrite($adors.fields(0).value & @LF)
				;_WinAPI_EnableWindow($Form1, True)
				If StringInStr($adors.fields(0).value, $tmpx[1]) Then
				$ibox = MsgBox(308, "Found Asset TAG", @CRLF & "Asset Tag is Already in the Database." & @CRLF & "Do you want to load info?")
				Select
				Case $ibox = 6 ;yes
				GUICtrlSetData($nMsg[0] + 1, $adors.fields(2).value)
				$tmpx = StringSplit($adors.fields(1).value, " ")
				GUICtrlSetData($nMsg[0] + 2, $tmpx[$tmpx[0]])
				ControlFocus("Inventory", "", $nMsg[0] + 3)
				$cursor = ControlGetFocus("Inventory")
				
				Case $ibox = 7 ;No
				
				EndSelect
				Else
				MsgBox(16, " Asset Tag Duplicate Error", @CRLF & "Asset Tag is Already in the database, but its a " & $adors.fields(0).value & @CRLF)
				GUICtrlSetData($nMsg[0], "")
				ControlFocus("Inventory", "", $nMsg[0])
				$cursor = ControlGetFocus("Inventory")
				EndIf
				$adors.close
				EndIf
				
				EndIf
			#ce
		Case $input[$x][38], $input[$x][40], $input[$x][42], $input[$x][44], $input[$x][46]
			$temp = StringStripWS(GUICtrlRead($nMsg[0]), 8)
			$temp = "Colunm3 WORKED"
			GUICtrlSetData($nMsg[0], $temp)
			ControlFocus("Inventory", "", $nMsg[0] + 1)
			#cs
				;_WinAPI_EnableWindow($Form1, False)
				$tmpc = $nMsg[0]
				If $x <> 1 Then $tmpc = $nMsg[0] - (140 * ($x - 1)) - (($x * 3) - 3)
				$tmpc = (($tmpc - 76) + 4) / 4
				ConsoleWrite($tmpc & @LF)
				$temp = StringStripWS(GUICtrlRead($nMsg[0]), 8)
				If $temp <> "" Then
				$found = False
				$tmp = $temp
				$err = False
				While Not $found
				ConsoleWrite($tmp & @LF)
				$adors = ObjCreate("ADODB.RecordSet") ; Create a Record Set to handles SQL Records
				With $adors
				.ActiveConnection = $ado
				.Source = "select equipment_type,equipment_model,Asset_num,Equipment_Make,serial_num from SSI.TBL_ASSET_EQUIPMENT WHERE upper(serial_num) ='" & $tmp & "'" ; This is where the SQL line goes
				.open
				EndWith
				;_WinAPI_EnableWindow($Form1, True)
				If Not $adors.EOF Then
				GUICtrlSetData($nMsg[0], StringUpper($tmp))
				$found = True
				Else
				If $temp = $tmp And StringLen($tmp) > $taglength Then
				$tmp = StringRight($tmp, StringLen($tmp) - 1)
				ConsoleWrite($tmp & @LF)
				Else
				If StringLen($tmp) > $taglength Then
				$tmp = StringRight($tmp, $taglength)
				ConsoleWrite($tmp & @LF)
				Else
				$tmp = StringRight($tmp, $taglength)
				GUICtrlSetData($nMsg[0], StringUpper($tmp))
				$found = True ; tried everything now just get out.
				$err = True
				EndIf
				EndIf
				
				EndIf
				WEnd
				GUICtrlSetState($Form1, $gui_enable)
				If Not $err Then
				$tmpx = StringSplit($types[$tmpc], " ")
				ConsoleWrite($adors.fields(4).value & @LF)
				$cnt = 0
				If Not StringInStr($adors.fields(0).value, $tmpx[1]) Then
				;_WinAPI_EnableWindow($Form1, True)
				MsgBox(16, " Asset Tag Wrong Line Error", @CRLF & "SN is Assigned to a " & $adors.fields(1).value & ", " & $adors.fields(0).value & " Not a " & $tmpx[1] & @CRLF)
				GUICtrlSetData($nMsg[0], "")
				ControlFocus("Inventory", "", $nMsg[0] + $cnt)
				$cursor = ControlGetFocus("Inventory")
				Else
				If StringStripWS(GUICtrlRead($nMsg[0] - 1), 8) = "" Then
				If Number($adors.fields(2).value) <> 0 Then
				GUICtrlSetData($nMsg[0] - 1, $adors.fields(2).value)
				$cnt = $cnt + 2
				Else
				$cnt = -1
				EndIf
				Else
				$cnt = $cnt + 2
				EndIf
				$tmpx = StringSplit($adors.fields(1).value, " ")
				GUICtrlSetData($nMsg[0] + 1, $tmpx[$tmpx[0]])
				ControlFocus("Inventory", "", $nMsg[0] + $cnt)
				$cursor = ControlGetFocus("Inventory")
				EndIf
				EndIf
				EndIf
				;_WinAPI_EnableWindow($Form1, True)
				ConsoleWrite($cnt & " " & $nMsg[0] & @LF)
			#ce
		Case $input[$x][51]
			$code = getentity(StringStripWS(GUICtrlRead($nMsg[0]), 3))
			If $code <> 0 Then
				GUICtrlSetData($input[$x][2], $CRfields[1])
				GUICtrlSetData($nMsg[0], StringRight("0000000" & StringStripWS(GUICtrlRead($nMsg[0]), 3), 6))
				ControlFocus("Inventory", "", $nMsg[0] + 4)
				$cursor = ControlGetFocus("Inventory")
			Else
				ControlFocus("Inventory", "", $nMsg[0] + 1)
				$cursor = ControlGetFocus("Inventory")
			EndIf
		Case $input[$x][25], $input[$x][26], $input[$x][27], $input[$x][28], $input[$x][29], $input[$x][30], $input[$x][31], $input[$x][32]
			$temp = StringStripWS(GUICtrlRead($nMsg[0]), 8)
			If $temp <> "" Then
				$prtlabels = $prtlabels + 1
				GUICtrlSetData($nMsg[0], "X")
			Else
				$prtlabels = $prtlabels - 1
			EndIf
			ControlFocus("Inventory", "", $nMsg[0] + 1)
			$cursor = ControlGetFocus("Inventory")
			
			
	EndSwitch
	;_WinAPI_EnableWindow($Form1, True)
WEnd
;$ado.close
Exit
Func createtab()
	$x = _GUICtrlTab_GetItemCount($tab[0])
	_ArrayAdd($tab, GUICtrlCreateTabItem("Sheet " & $x + 1))
	ReDim $input[$x + 1 + 1][60], $radio[$x + 1 + 1][13], $ntype[$x + 1 + 1][10], $info[$x + 1 + 1][60], $dropbox[$x + 1 + 1][2]
	_ArrayAdd($B1, "")
	_ArrayAdd($b2, "")
	setupscreen($x + 1)
EndFunc   ;==>createtab
Func ErrHandler()
	$HexNumber = Hex($oIEErrorHandler.number, 8)
	MsgBox(0, StringReplace($oIEErrorHandler.windescription, "error", "COM Error #") & $oIEErrorHandler.Number, _
			$oIEErrorHandler.Description & @CRLF & _
			"Source: " & @TAB & $oIEErrorHandler.source & @CRLF & _
			"at Line #: " & $oIEErrorHandler.ScriptLine & @TAB & _
			"Last DllError: " & @TAB & $oIEErrorHandler.lastdllerror & @CRLF & _
			"Help File: " & @TAB & $oIEErrorHandler.helpfile & @TAB & "Context: " & @TAB & $oIEErrorHandler.helpcontext _
			)
	
	Local $err = $oIEErrorHandler.number
	If $err = 0 Then $err = -1
	$g_eventerror = $err
	SetError($err) ; to check for after this function returns
EndFunc   ;==>ErrHandler
Func fillscreen($x, $tmp, $ans)
	
	Switch StringStripWS($CRfields[19], 8)
		Case "Redeployed"
			GUICtrlSetData($input[$x][$tmp], "R")
		Case Else
			GUICtrlSetData($input[$x][$tmp], "X")
			If $tmp < 25 Then
				$pos = _ArraySearch($Defaults, $ans, 0, 0, 0, 1, 1, 2)
				;ConsoleWrite($pos & "," & $tmpx[1] & @LF)
				For $i = 1 To $Defaults[0][0]
					If $bundle And StringInStr($Defaults[$i][1], "Bundle") And StringInStr($Defaults[$i][2], $ans) Then
						GUICtrlSetData($input[$x][$tmp + 1], $Defaults[$i][1])
						ExitLoop
					EndIf
					If StringInStr($Defaults[$i][2], $ans) Then
						GUICtrlSetData($input[$x][$tmp + 1], $Defaults[$i][1])
						ExitLoop
					EndIf
				Next
			EndIf
	EndSwitch
EndFunc   ;==>fillscreen
Func getaddress($street, $city, $state)
	#cs
		If $city = "River" And StringInStr($street, "Fall") Then
		$city = "Fall River"
		$street = StringReplace($street, "Fall", "")
		EndIf
		ConsoleWrite($street & " | " & $city & " | " & $state & @LF)
		If StringLeft(StringStripWS(StringUpper($city), 3), 2) = "S " Then $city = StringReplace($city, "S ", "South ", 1)
		If StringLeft(StringStripWS(StringUpper($city), 3), 2) = "E " Then $city = StringReplace($city, "E ", "East ", 1)
		If StringLeft(StringStripWS(StringUpper($city), 3), 2) = "W " Then $city = StringReplace($city, "W ", "West ", 1)
		If StringLeft(StringStripWS(StringUpper($city), 3), 2) = "N " Then $city = StringReplace($city, "N ", "North ", 1)
		$adox = ObjCreate("ADODB.Connection") ; Create a COM ADODB Object
		With $adox
		.ConnectionString = ("DRIVER={SQL Server};SERVER=" & $AS_server & ";DATABASE=" & $AS_dbname & ";uid=" & $AS_user & ";pwd=" & $as_pass & ";")
		.Open
		EndWith
		If @error Then Exit
		$found = False
		$temp = ""
		$tmp = $street
		While Not $found
		ConsoleWrite($tmp & @LF)
		$adors = ObjCreate("ADODB.RecordSet") ; Create a Record Set to handles SQL Records
		With $adors
		.ActiveConnection = $adox
		.Source = "select HR_ID,shipto,address,City,state from dbo.TBL_ASSET_LOCATION WHERE upper(ADDRESS) like '" & StringStripWS(StringUpper($tmp), 3) & "%' " ; This is where the SQL line goes
		.source = .source & "and UPPER(City) like'" & StringStripWS(StringUpper($city), 3) & "%' And UPPER(State) like '" & StringStripWS(StringUpper($state), 3) & "%'"
		.Open ;
		EndWith
		If Not $adors.EOF Then
		$CRfields[74] = $adors.Fields(0).Value
		$CRfields[52] = $adors.Fields(1).Value
		$CRfields[4] = $adors.Fields(2).Value
		$CRfields[14] = $adors.Fields(3).Value
		$CRfields[8] = $adors.Fields(4).Value
		$found = True
		Else
		$tmp = StringLeft($tmp, StringLen($tmp) - 1)
		If StringLen(StringStripWS($tmp, 8)) = 0 Then
		$tmp = ""
		ExitLoop
		EndIf
		EndIf
		WEnd
		If Not $found Then
		ConsoleWrite($street & " " & $city & " " & $state & @LF)
		$CRfields[52] = ""
		$CRfields[74] = ""
		EndIf
		
		$adors.close
		$adox.close
	#ce
EndFunc   ;==>getaddress
Func getcr(ByRef $CRfields)
	#cs
		Dim $approve[10]
		#Region ### START Koda GUI section ### Form=
		$CRF = GUICreate("Computer Request Form", 484, 106, 193, 125, BitOR($WS_SYSMENU, $WS_CAPTION, $WS_POPUP, $WS_POPUPWINDOW, $WS_BORDER, $WS_CLIPSIBLINGS))
		$Label1 = GUICtrlCreateLabel("Enter Computer Request Number or Leave Blank for Empty Sheet", 16, 8, 451, 20)
		GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
		GUICtrlSetResizing(-1, $GUI_DOCKHCENTER)
		$crf_progress1 = GUICtrlCreateProgress(24, 80, 385, 17)
		$crf_inp = GUICtrlCreateInput("", 216, 38, 161, 24)
		GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
		$crf_Button1 = GUICtrlCreateButton("Submit", 392, 38, 73, 25, 0)
		$crf_label = GUICtrlCreateLabel("Computer Request Number:", 16, 38, 194, 20)
		GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
		GUISetState(@SW_SHOW)
		#EndRegion ### END Koda GUI section ###
		While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
		Case $GUI_EVENT_CLOSE
		Exit
		Case $crf_Button1
		$cr = GUICtrlRead($crf_inp)
		If StringStripWS($cr, 8) = "" Then
		GUIDelete($CRF)
		Return
		EndIf
		If Not StringInStr($cr, "-") Then $cr = StringLeft($cr, 8) & "-" & StringRight($cr, StringLen($cr) - 8)
		GUICtrlSetData($crf_progress1, 0)
		$ado = ObjCreate("ADODB.Connection") ; Create a COM ADODB Object
		With $ado
		.ConnectionString = ("Provider='MSDAORA';Data Source='" & $CR_server & "." & $CR_dbname & "' ;User Id='" & $CR_user & "';Password='" & $cr_pass & "';")
		.Open
		EndWith
		If @error Then
		$g_eventerror = 0
		GUIDelete($CRF)
		Return
		EndIf
		$adors = ObjCreate("ADODB.RecordSet") ; Create a Record Set to handles SQL Records
		With $adors
		.ActiveConnection = $ado
		.Source = "select * from SSI.TBL_COMPUTER_REQUEST_MASTER WHERE upper(REQUEST_ID) = '" & StringUpper($cr) & "'" ; This is where the SQL line goes
		.open
		EndWith
		GUICtrlSetData($crf_progress1, 50)
		ReDim $CRfields[$adors.Fields.Count + 1]
		If Not $adors.eof Then
		For $i = 0 To $adors.Fields.Count - 1
		$CRfields[$i + 1] = $adors.Fields($i ).Value
		Next
		$CRfields[0] = $i
		Else
		GUIDelete($CRF)
		Return
		EndIf
		GUICtrlSetData($crf_progress1, 80)
		$adors.close
		If $CRfields[74] = "YES" Then $CRfields[20] = StringStripWS($CRfields[20] & " " & "Monitor", 3)
		getempinfo()
		getentity($CRfields[7])
		;_ArrayDisplay($CRfields)
		If StringStripWS($CRfields[4], 8) <> "" Then getaddress($CRfields[4], $CRfields[14], $CRfields[8])
		GUICtrlSetData($crf_progress1, 100)
		ExitLoop
		Case $crf_inp
		
		ControlFocus("Computer Request Form", "", $nMsg + 1)
		$cursor = ControlGetFocus("Computer Request Form")
		_GUICtrlButton_Click($crf_Button1)
		GUICtrlSetData($crf_progress1, 50)
		EndSwitch
		WEnd
		
		$adors = ObjCreate("ADODB.RecordSet") ; Create a Record Set to handles SQL Records
		With $adors
		.ActiveConnection = $ado
		.Source = "select char_update from SSI.TBL_COMPUTER_REQUEST_MASTER_up WHERE upper(REQUEST_ID) = '" & StringUpper($cr) & "' order by Date_update" ; This is where the SQL line goes
		.open
		EndWith
		
		$x = 0
		While Not $adors.eof
		$x = $x + 1
		$approve[$x] = $adors.fields(0).value
		$adors.movenext
		WEnd
		$ado.close
		GUIDelete($CRF)
	#ce
EndFunc   ;==>getcr
Func getdefaultsx(ByRef $Defaults)
	#cs
		$ado = ObjCreate("ADODB.Connection") ; Create a COM ADODB Object
		With $ado
		.ConnectionString = ("DRIVER={SQL Server};SERVER=" & $AS_server & ";DATABASE=" & $AS_dbname & ";uid=" & $AS_user & ";pwd=" & $as_pass & ";")
		.Open
		EndWith
		If @error Then Exit
		$adors = ObjCreate("ADODB.RecordSet") ; Create a Record Set to handles SQL Records
		With $adors
		.ActiveConnection = $ado
		.Source = "select Equipment_TYPE,Default_equipment from SSI.TBL_ASSET_Equipment_type WHERE UPPER(default_equipment) <> ''"
		.open
		EndWith
		$tmp = 1
		While Not $adors.eof
		$Defaults[$tmp][1] = $adors.Fields(1 ).Value
		$Defaults[$tmp][2] = $adors.Fields(0 ).Value
		$Defaults[0][0] = $tmp
		$tmp = $tmp + 1
		$adors.MoveNext
		WEnd
	#ce
EndFunc   ;==>getdefaultsx
Func getempinfo()
	If $CRfields[9] = "Contractor" Then
		$hr_array = gethr($CRfields[71]) ; Managers NTLogin
		$CRfields[53] = $CRfields[12] & " " & $CRfields[11]
		$contractor = True
	Else
		$hr_array = gethr($CRfields[53])
		$CRfields[53] = ""
	EndIf
	If UBound($hr_array, 1) <> 1 Then
		$CRfields[10] = $hr_array[1][1] ; pernr
		$CRfields[12] = $hr_array[1][4] ; Firstname
		$CRfields[11] = $hr_array[1][3] ; Lastname
		$CRfields[7] = StringRight("000000" & $hr_array[1][29], 6) ;Entity
		$origaddress = $CRfields[14]
		$temp = StringSplit($CRfields[14], "-")
		If $temp[0] <> 1 Then
			$CRfields[4] = $temp[2]
			getaddress($temp[2], $temp[1], "")
		Else
			$temp = StringSplit($CRfields[14], ",")
			If $temp[0] = 2 Then $CRfields[8] = $temp[2]
			$CRfields[14] = $temp[1]
			$temp = StringSplit($CRfields[14], " ")
			If $temp[$temp[0] - 1] = "NEW" Or $temp[$temp[0] - 1] = "NORTH" Or $temp[$temp[0] - 1] = "SOUTH" Or $temp[$temp[0] - 1] = "EAST" Or $temp[$temp[0] - 1] = "WEST" Or StringLen($temp[$temp[0] - 1]) = 1 Then
				$CRfields[14] = $temp[$temp[0] - 1] & " " & $temp[$temp[0]]
			Else
				If StringLen($temp[$temp[0]]) = 2 Then
					$CRfields[14] = $temp[$temp[0] - 1]
					$CRfields[8] = $temp[$temp[0]]
				Else
					$CRfields[14] = $temp[$temp[0]]
				EndIf
			EndIf
		EndIf
		$pos = StringInStr($origaddress, $CRfields[14])
		$CRfields[4] = StringLeft($origaddress, $pos - 1)
		If StringStripWS($CRfields[8], 8) = "" Then $CRfields[8] = getstate()
		getaddress($CRfields[4], $CRfields[14], $CRfields[8])
	Else
		Dim $CRfields[75]
	EndIf
EndFunc   ;==>getempinfo
Func getentity($tmp)
	#cs
		$tmp = Number($tmp)
		;ConsoleWrite($tmp & @LF)
		
		$adox = ObjCreate("ADODB.Connection") ; Create a COM ADODB Object
		With $adox
		.ConnectionString = ("DRIVER={SQL Server};SERVER=" & $AS_server & ";DATABASE=" & $AS_dbname & ";uid=" & $AS_user & ";pwd=" & $as_pass & ";")
		.Open
		EndWith
		If @error Then Exit
		$adorsx = ObjCreate("ADODB.RecordSet") ; Create a Record Set to handles SQL Records
		With $adorsx
		.ActiveConnection = $adox
		.Source = "select region from dbo.TBL_ASSET_ENTITYCODES WHERE deptnum = '" & $tmp & "'" ; This is where the SQL line goes
		.Open ;
		EndWith
		If Not $adorsx.eof Then
		$CRfields[1] = $adorsx.Fields(0).Value
		$code = 1
		Else
		$code = 0
		EndIf
		$adorsx.close
		$adox.close
		Return $code
	#ce
EndFunc   ;==>getentity
Func gethr($tmp)
	#cs
		If $tmp = "N/A" Then $tmp = InputBox("NT Login", "NT Login")
		$localhr = localhr($tmp)
		If $localhr = 0 Then
		ConsoleWrite($Cr_page & $tmp & @LF)
		$oie = _IECreate($Cr_page & $tmp, 0, 0)
		$oTable = _IETableGetCollection($oie)
		$oTable = _IETableGetCollection($oie, 0)
		If StringInStr(_IEBodyReadText($oie), "No Data Returned") Then
		Dim $hr_array[1][1]
		Else
		$hr_array = _IETableWriteToArray($oTable)
		EndIf
		_IEQuit($oie)
		EndIf
	#ce
	Return $hr_array
EndFunc   ;==>gethr
Func gethrpernr($tmp)
	#cs
		$oie = _IECreate($Emplookup & $PERNR & "=" & $tmp, 0, 0)
		$oTable = _IETableGetCollection($oie)
		$oTable = _IETableGetCollection($oie, 0)
		$hr_array = _IETableWriteToArray($oTable)
		_IEQuit($oie)
		$CRfields[10] = $hr_array[1][1] ; pernr
		$CRfields[12] = $hr_array[1][4] ; Firstname
		$CRfields[11] = $hr_array[1][3] ; Lastname
		$CRfields[7] = StringRight("000000" & $hr_array[1][29], 6) ;Entity
		$CRfields[4] = $hr_array[1][8] ; Address
		$CRfields[14] = $hr_array[1][10] ;City
		$CRfields[8] = $hr_array[1][11] ;state
		getaddress($CRfields[4], $CRfields[14], $CRfields[8])
	#ce
EndFunc   ;==>gethrpernr
Func getname($name, $flag)
	#cs
		;If $flag Then ConsoleWrite(StringUpper($namelist[$flag][1]) & @TAB & StringUpper($namelist[$flag][2]) & @LF)
		If StringStripWS($name, 8) <> "" Then
		$temp = StringReplace($name, Chr(39), Chr(39) & Chr(39))
		$name = $temp
		If Not StringInStr($name, ",") Then
		$temp = StringSplit($name, " ")
		If $temp[0] <> 1 Then
		$name = $temp[$temp[0]] & ","
		$post = 1
		
		If StringInStr($temp[$temp[0]], "JR") Or StringInStr($temp[$temp[0]], "SR") Or StringInStr($temp[$temp[0]], "II") Then
		$name = $temp[$temp[0] - 1] & " " & $temp[$temp[0]] & ","
		$post = 2
		EndIf
		
		
		For $i = 1 To $temp[0] - $post
		$name = $name & $temp[$i] & " "
		Next
		Else
		$name = $temp[1]
		EndIf
		EndIf
		ConsoleWrite($name)
		Do
		$name = StringReplace($name, ", ", ",")
		Until @extended = 0
		$name = StringReplace($name, ",", ", ")
		$name = StringStripWS($name, 3)
		$adox = ObjCreate("ADODB.Connection") ; Create a COM ADODB Object
		With $adox
		.ConnectionString = ("DRIVER={SQL Server};SERVER=" & $HR_server & ";DATABASE=" & $HR_dbname & ";uid=" & $hr_user & ";pwd=" & $hr_Pass & ";")
		.Open
		EndWith
		If @error Then Exit
		$adors = ObjCreate("ADODB.RecordSet") ; Create a Record Set to handles SQL Records
		If $flag = 0 Then
		With $adors
		.ActiveConnection = $adox
		.Source = "select Col031, Name, empl_status  from " & $HR_table & " WHERE UPPER(name) like '" & StringUpper($name) & "%'"
		.open
		EndWith
		Else
		With $adors
		.ActiveConnection = $adox
		.Source = "select Col031, Name, empl_status  from " & $HR_table & " WHERE UPPER(name) = '" & StringUpper($namelist[$flag][1]) & "' and upper(Col031)='" & StringUpper($namelist[$flag][2]) & "'"
		.open
		EndWith
		EndIf
		If $adors.eof Then
		$CRfields[11] = ""
		$CRfields[12] = ""
		$adors.close
		$adox.close
		_WinAPI_EnableWindow($Form1, True)
		Return
		EndIf
		$i = 0
		Dim $namelist[1][1] ; clear old namelist
		While Not $adors.eof
		If $adors.fields(2).value <> "D" Then ; employee status
		ReDim $namelist[$i + 2][3]
		$namelist[$i + 1][1] = $adors.fields(1).value
		$namelist[$i + 1][2] = $adors.fields(0).value
		$i = $i + 1
		$namelist[0][0] = $i
		EndIf
		$adors.MoveNext
		WEnd
		;_WinAPI_EnableWindow($form1,  false)
		;_ArrayDisplay($namelist)
		If $namelist[0][0] = 1 Then
		gethr($namelist[1][2])
		$CRfields[10] = $hr_array[1][1] ; perner
		$CRfields[12] = $hr_array[1][4] ; Firstname
		$CRfields[11] = $hr_array[1][3] ; Lastname
		$CRfields[7] = StringRight($hr_array[1][29], 6) ;Entity
		$CRfields[4] = $hr_array[1][8] ; Address
		$CRfields[14] = $hr_array[1][10] ; City
		$CRfields[8] = $hr_array[1][11]; State
		getentity($CRfields[7])
		getaddress($CRfields[4], $CRfields[14], $CRfields[8])
		Else
		_WinAPI_EnableWindow($Form1, True)
		$list = "|"
		_ArraySort($namelist, 0, 1, 0, 2); sort by NTlogin First
		_ArraySort($namelist, 0, 1, 0, 1);sort by name  after.  So no Matter duplicate names are always in the same order.
		
		For $i = 1 To $namelist[0][0]
		$list = $list & $namelist[$i][1] & "|"
		Next
		$list = StringLeft($list, StringLen($list) - 1)
		GUICtrlSetState($input[$x][1], $GUI_DISABLE + $gui_hide)
		GUICtrlSetState($dropbox[$x][1], $gui_enable + $gui_show)
		GUICtrlSetData($dropbox[$x][1], $list, $namelist[1][1])
		ControlFocus("Inventory", "", $dropbox[$x][1])
		$cursor = ControlGetFocus("Inventory")
		EndIf
		_WinAPI_EnableWindow($Form1, True)
		$adox.close
		Return $namelist[0][0]
		Else
		_WinAPI_EnableWindow($Form1, True)
		Return 0
		EndIf
	#ce
EndFunc   ;==>getname
Func getstate()
	#cs
		$adox = ObjCreate("ADODB.Connection") ; Create a COM ADODB Object
		With $adox
		.ConnectionString = ("DRIVER={SQL Server};SERVER=" & $AS_server & ";DATABASE=" & $AS_dbname & ";uid=" & $AS_user & ";pwd=" & $as_pass & ";")
		.Open
		EndWith
		If @error Then Exit
		$adors = ObjCreate("ADODB.RecordSet") ; Create a Record Set to handles SQL Records
		
		With $adors
		.ActiveConnection = $adox
		.Source = "select State from dbo.TBL_ASSET_location WHERE UPPER(City) ='" & StringUpper($CRfields[8]) & "'"
		.open
		EndWith
		If Not $adors.eof Then
		$CRfields[15] = $adors.Fields(0).Value
		EndIf
		
		$adors.close
		$adox.close
	#ce
EndFunc   ;==>getstate
Func localhr($tmp)
	#cs
		$adox = ObjCreate("ADODB.Connection") ; Create a COM ADODB Object
		With $adox
		.ConnectionString = ("DRIVER={SQL Server};SERVER=" & $HR_server & ";DATABASE=" & $HR_dbname & ";uid=" & $hr_user & ";pwd=" & $hr_Pass & ";")
		.Open
		EndWith
		If @error Then Exit
		$adors = ObjCreate("ADODB.RecordSet") ; Create a Record Set to handles SQL Records
		With $adors
		.ActiveConnection = $adox
		.Source = "select PERNR,name,DEPTID,LOCATION,Col031"
		.source = .source & " from " & $HR_table & " WHERE upper(Col031)='" & StringUpper($tmp) & "'"
		.open
		EndWith
		
		If $adors.eof Then Return 0
		Global $hr_array[2][30]
		$hr_array[1][1] = $adors.fields(0).value
		$tmp = StringSplit($adors.fields(1).value, ",")
		$hr_array[1][3] = $tmp[1]
		$hr_array[1][4] = $tmp[2]
		$hr_array[1][7] = $adors.fields(3).value
		$hr_array[1][29] = StringLeft($adors.fields(2).value, StringLen($adors.fields(2).value) - 4)
		$adox2 = ObjCreate("ADODB.Connection") ; Create a COM ADODB Object
		With $adox2
		.ConnectionString = ("DRIVER={SQL Server};SERVER=" & $AS_server & ";DATABASE=" & $AS_dbname & ";uid=" & $AS_user & ";pwd=" & $as_pass & ";")
		.Open
		EndWith
		If @error Then Exit
		
		$adors2 = ObjCreate("ADODB.RecordSet") ; Create a Record Set to handles SQL Records
		With $adors2
		.ActiveConnection = $adox2
		.Source = "select address,City,state from dbo.TBL_ASSET_LOCATION WHERE upper(HR_ID) = '" & StringStripWS(StringUpper($adors.fields(3).value), 3) & "' "
		.open
		EndWith
		If Not $adors2.eof Then
		$hr_array[1][8] = $adors2.fields(0).value
		$hr_array[1][10] = $adors2.fields(1).value
		$hr_array[1][11] = $adors2.fields(2).value
		$adors2.close
		$tmp = 1
		Else
		$hr_array[1][8] = ""
		$hr_array[1][10] = ""
		$hr_array[1][11] = ""
		$tmp = 0
		EndIf
		$adors.close
		$adox.close
		Return $tmp
	#ce
EndFunc   ;==>localhr
Func readtab($t)
	$ok = True
	$info[$t][55] = $CRfields[10]
	$info[$t][56] = $CRfields[74]
	For $x = 1 To UBound($info, 1) - 1
		For $i = 1 To 54
			$info[$x][$i] = GUICtrlRead($input[$x][$i])
		Next
		
		For $i = 57 To 58
			$info[$x][$i] = GUICtrlRead($input[$x][$i])
		Next
		$tst = 0
		For $i = 1 To 6
			If GUICtrlRead($ntype[$x][$i]) = $GUI_CHECKED Then
				$tst = 1
				Select
					Case $i = 4
						$info[$x][4 + $i] = "E" ;Share Expense/Special Order Field
					Case $i = 5
						$info[$x][4 + $i - 1] = "S"
					Case $i = 6
						$info[$x][4 + $i - 1] = 1 ; Loaner field is now off by one
					Case Else
						$info[$x][4 + $i] = 1
				EndSelect
				ExitLoop
			EndIf
		Next
		If $tst = 0 Then $ok = False
		
		For $i = 1 To 12
			If GUICtrlRead($radio[$x][$i]) = $GUI_CHECKED Then
				$info[$x][36] = $i
				ExitLoop
			EndIf
		Next
		
		; # of Labels
		
		$prtlabels = 0
		For $i = 10 To 22 Step 2
			If $info[$x][$i] Then $prtlabels = $prtlabels + 1
			If $info[$x][$i] <> "" And $info[$x][$i + 27] = "" Then $ok = False
			If $info[$x][$i] <> "" And $info[$x][$i + 28] = "" Then $ok = False
		Next
		For $i = 25 To 35
			If $info[$x][$i] Then $prtlabels = $prtlabels + 1
		Next
		; Special Cases
		If $info[$x][10] And $info[$x][25] And $info[$x][26] Then $prtlabels = $prtlabels - 2 ; Normal Desktop
		If $info[$x][12] And $info[$x][26] And $info[$x][28] And $info[$x][32] Then $prtlabels = $prtlabels - 3; Normal Laptop
		If $info[$x][12] And $info[$x][18] And $info[$x][25] And $info[$x][26] And $info[$x][28] And $info[$x][32] Then $prtlabels = $prtlabels - 5; Normal Bundle
		$info[$x][59] = $prtlabels
	Next
	;_ArrayDisplay($info)
	Return $ok
EndFunc   ;==>readtab
Func sendtotemp()
	;$oExcel = _ExcelBooknew(0)
	;_ExcelWritesheetfromarray($oExcel, $info, 1, 1, 1, 1)
	;_ExcelBookSaveAs($oExcel, $tempdir & "\Temp_ITCS.xls", "xls", 0, 1)
	;_excelbookclose($oExcel, 0, 0)
	;If @error Then MsgBox(1, "Error", "Not closed")
	
EndFunc   ;==>sendtotemp
Func sendtoupdate()
	#cs
		Dim $writetemp[3][11]
		$cnt = 0
		$update = False
		For $x = 1 To UBound($info) - 1
		For $i = 10 To 22 Step 2
		ReDim $writetemp[$cnt + 2][11]
		If $info[$x][$i] Then
		$update = True
		$cube = ""
		$cnt = $cnt + 1
		If $contractor Then
		$status = "LOANER"
		$cube = $info[$x][58]
		Else
		$status = "ASSIGNED"
		EndIf
		
		$in = $i + 28
		ConsoleWrite($info[$x][$in] & " " & $cnt & @LF)
		If $bundle And $in = 40 Then $tmp_sn = $info[$x][$in] & "_PRS"
		If $bundle And $in = 46 Then
		$tmp = $info[$x][$in]
		$found = False
		While Not $found
		ConsoleWrite($tmp & @LF)
		$adors = ObjCreate("ADODB.RecordSet") ; Create a Record Set to handles SQL Records
		With $adors
		.ActiveConnection = $ado
		.Source = "select equipment_type,equipment_model,Asset_num,Equipment_Make,serial_num from SSI.TBL_ASSET_EQUIPMENT WHERE upper(serial_num) ='" & StringUpper($tmp) & "'" ; This is where the SQL line goes
		.open
		EndWith
		_WinAPI_EnableWindow($Form1, True)
		If Not $adors.EOF Then
		ConsoleWrite($tmp & @LF)
		$found = True
		Else
		$tmp = $tmp_sn
		$info[$x][$in] = $tmp_sn & "|" & $info[$x][$in]
		ConsoleWrite($tmp & @LF)
		$found = True
		EndIf
		WEnd
		EndIf
		$writetemp[$cnt][1] = $info[$x][$in]
		$writetemp[$cnt][2] = $info[$x][$in - 1]
		$writetemp[$cnt][3] = ""
		$writetemp[$cnt][4] = $status
		$writetemp[$cnt][5] = $info[$x][56]
		$writetemp[$cnt][6] = $info[$x][2]
		If StringStripWS($cube, 8) = "" Then $cube = "Null"
		$writetemp[$cnt][7] = $cube
		$writetemp[$cnt][8] = $info[$x][55]
		$writetemp[$cnt][9] = ""
		$writetemp[$cnt][10] = ""
		EndIf
		Next
		
		
		Next
		;_ArrayDisplay($writetemp)
		If $update Then
		
		$firstline = "Serial_num,Asset_num,Symbol_Phone,Status,Address,Area,Cube #, Employid, Firstname,Lastname"
		$ftmp = StringSplit($firstline, ",")
		For $i = 1 To 10
		$writetemp[0][$i] = $ftmp[$i]
		Next
		
		If FileExists($updatefile) Then FileDelete($updatefile)
		$oExcel = _ExcelBooknew(0)
		_ExcelWritesheetfromarray($oExcel, $writetemp, 1, 1, 0, 1)
		_ExcelBookSaveAs($oExcel, $updatefile, "csv", 0, 1)
		_excelbookclose($oExcel, 0, 0)
		EndIf
		Return $update
	#ce
EndFunc   ;==>sendtoupdate
Func setupscreen($t)
	
	GUICtrlCreateLabel("End Username:", 0 + $xx, 48, 90, 17)
	GUICtrlCreateLabel("PERNR Lookup:", 0 + $xx, 60, 90, 17)
	GUICtrlCreateLabel("Date:", 448 + $xx, 56, 35, 17)
	GUICtrlCreateLabel("Equipment Request Number:", 0 + $xx, 80, 165, 17)
	GUICtrlCreateLabel("Work Location:", 376 + $xx, 80, 91, 17)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlCreateLabel("Install Type:", 0 + $xx, 104, 89, 20)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	GUICtrlCreateLabel("New Install", 40 + $xx, 120, 56, 17)
	GUICtrlCreateLabel("Replacement", 224 + $xx, 120, 67, 17)
	GUICtrlCreateLabel("Redeployment", 416 + $xx, 120, 72, 17)
	GUICtrlCreateLabel("Expensed", 40 + $xx, 145, 56, 17)
	GUICtrlCreateLabel("Special Order", 175 + $xx, 145, 72, 17)
	GUICtrlCreateLabel("*Loaner:", 320 + $xx, 145, 45, 17)
	GUICtrlCreateLabel("*Return Date:", 400 + $xx, 145, 72, 17)
	GUICtrlCreateLabel("Shipped to Location", 0 + $xx, 608, 169, 21)
	$labcnt = 0
	$adj = 10
	For $Lloop = 212 To 424 Step 32
		$labcnt = $labcnt + 1
		$labloc[$labcnt] = $Lloop - $adj
		GUICtrlCreateLabel($types[$labcnt], 0 + $xx, $labloc[$labcnt], 50, 30)
		GUICtrlCreateLabel("Asset Tag #:", 125 + $xx, $labloc[$labcnt], 72, 21)
		GUICtrlCreateLabel("Serial#:", 300 + $xx, $labloc[$labcnt], 45, 21)
		GUICtrlCreateLabel("Model#:", 450 + $xx, $labloc[$labcnt], 40, 21)
	Next
	For $Lloop = 1 To 12
		GUICtrlCreateLabel($labels[$Lloop], ($Lloop * 45) - 10 + $xx, 546, 20, 21)
	Next
	$B1[$t] = GUICtrlCreateButton("Submit", 150 + $xx, 665, 50, 24)
	$b2[$t] = GUICtrlCreateButton("Next Sheet", 348 + $xx, 665, 100, 24)
	
	;* Inputs fields
	If $CRfields[0] = 0 Then
		$temp = ""
	Else
		$temp = $CRfields[11] & ", " & $CRfields[12]
	EndIf
	If $t <> 1 Then $temp = GUICtrlRead($input[$t - 1][1])
	$input[$t][1] = GUICtrlCreateInput($temp, 96 + $xx, 49, 348, 24) ;$Username
	GUICtrlSetFont(-1, 10, 400, 4, "MS Sans Serif")
	$dropbox[$t][1] = GUICtrlCreateCombo($temp, 96 + $xx, 49, 348, 24) ;$Username Dropdown
	GUICtrlSetState(-1, $GUI_DISABLE + $gui_hide)
	$input[$t][3] = GUICtrlCreateInput("", 486 + $xx, 49, 75, 24); $Date
	GUICtrlSetData(-1, Today())
	$input[$t][24] = GUICtrlCreateInput($CRfields[2], 154 + $xx, 76, 188, 21) ;$CRnum
	$input[$t][4] = GUICtrlCreateInput($CRfields[14], 463 + $xx, 76, 120, 21);$Location
	GUIStartGroup()
	$ntype[$t][1] = GUICtrlCreateRadio("", 104 + $xx, 120, 30, 20);$Ninstall
	$ntype[$t][2] = GUICtrlCreateRadio("", 304 + $xx, 120, 30, 20);$Replace
	$ntype[$t][3] = GUICtrlCreateRadio("", 496 + $xx, 120, 30, 20);$Redeploy
	$ntype[$t][4] = GUICtrlCreateRadio("", 104 + $xx, 142, 30, 20);$expensed
	$ntype[$t][5] = GUICtrlCreateRadio("", 254 + $xx, 142, 30, 20);$special
	$ntype[$t][6] = GUICtrlCreateRadio("", 368 + $xx, 142, 30, 20);$Loaner
	GUIStartGroup()
	$input[$t][52] = GUICtrlCreateInput("", 472 + $xx, 145, 113, 15);Returndate
	$labcnt = 8
	For $Lloop = 1 To 7
		$labcnt = $labcnt + 2
		
		$input[$t][$labcnt] = GUICtrlCreateInput("", 72 + $xx, $labloc[$Lloop], 41, 21);Colunm1
		
		$input[$t][$labcnt + 27] = GUICtrlCreateInput("", 190 + $xx, $labloc[$Lloop], 100, 21);Colunm2
		
		$input[$t][$labcnt + 28] = GUICtrlCreateInput("", 340 + $xx, $labloc[$Lloop], 100, 21);Colunm3
		
		$input[$t][$labcnt + 1] = GUICtrlCreateInput("", 496 + $xx, $labloc[$Lloop], 97, 21);Column 4
		
	Next
	$input[$t][25] = GUICtrlCreateInput("", 64 + $xx, 442, 57, 21);$keyboard
	$input[$t][26] = GUICtrlCreateInput("", 200 + $xx, 442, 57, 21);$Mouse
	$input[$t][27] = GUICtrlCreateInput("", 360 + $xx, 442, 57, 21);$PC
	$input[$t][28] = GUICtrlCreateInput("", 504 + $xx, 442, 57, 21);$AC
	$input[$t][29] = GUICtrlCreateInput("", 64 + $xx, 465, 57, 21);$JD
	$input[$t][30] = GUICtrlCreateInput("", 216 + $xx, 465, 57, 21);$DVideo
	$input[$t][31] = GUICtrlCreateInput("", 320 + $xx, 465, 57, 21);$Battery
	$input[$t][32] = GUICtrlCreateInput("", 448 + $xx, 465, 57, 21);$Bag
	$input[$t][33] = GUICtrlCreateInput("", 64 + $xx, 490, 57, 42, $ES_MULTILINE);$Memory
	$input[$t][34] = GUICtrlCreateInput("", 176 + $xx, 490, 185, 21);$other1
	$input[$t][35] = GUICtrlCreateInput("", 400 + $xx, 490, 185, 21);$other2
	GUICtrlCreateLabel("Keyboard:", 10 + $xx, 445, 50, 17)
	GUICtrlCreateLabel("Mouse:", 160 + $xx, 445, 35, 17)
	GUICtrlCreateLabel("Printer Cables:", 290 + $xx, 445, 70, 17)
	GUICtrlCreateLabel("A/C Adaptor:", 435 + $xx, 445, 65, 17)
	GUICtrlCreateLabel("Jet Direct:", 10 + $xx, 469, 50, 17)
	GUICtrlCreateLabel("Dual Video:", 150 + $xx, 469, 65, 17)
	GUICtrlCreateLabel("Battery:", 280 + $xx, 469, 35, 17)
	GUICtrlCreateLabel("Bag:", 420 + $xx, 469, 25, 17)
	GUICtrlCreateLabel("Memory:", 10 + $xx, 494, 50, 17)
	GUICtrlCreateLabel("Other:", 140 + $xx, 494, 35, 17)
	GUICtrlCreateLabel("Other:", 365 + $xx, 494, 35, 17)
	GUIStartGroup()
	For $Lloop = 1 To 12
		$radio[$t][$Lloop] = GUICtrlCreateRadio("", ($Lloop * 45) + 15 + $xx, 546, 17, 17)
	Next
	GUIStartGroup()
	GUICtrlCreateLabel("Department Number:", 10 + $xx, 586, 105, 17)
	GUICtrlCreateLabel("Enity Name:", 305 + $xx, 586, 68, 17)
	$input[$t][51] = GUICtrlCreateInput(StringRight("000000" & $CRfields[7], 6), 112 + $xx, 584, 161, 21);$Deptnum
	$input[$t][2] = GUICtrlCreateInput($CRfields[1], 368 + $xx, 584, 209, 42, $ES_MULTILINE);$Deptname
	$input[$t][53] = GUICtrlCreateInput($CRfields[52], 112 + $xx, 608, 169, 21);$Shipping
	GUICtrlSetState($input[$t][53], $GUI_DISABLE)
	GUICtrlCreateLabel("Street:", 10 + $xx, 642, 35, 17)
	$input[$t][54] = GUICtrlCreateInput($CRfields[4], 45 + $xx, 640, 169, 21);Street
	GUICtrlCreateLabel("Start Date:", 305 + $xx, 642, 68, 17)
	$input[$t][57] = GUICtrlCreateInput($CRfields[17], 368 + $xx, 640, 75, 21);Start Date
	GUICtrlCreateLabel("Contractor:", 300 + $xx, 164, 75, 21)
	$input[$t][58] = GUICtrlCreateInput($CRfields[53], 360 + $xx, 162, 225, 21);Contractor
	If Not $contractor Then GUICtrlSetState($input[$t][58], $GUI_DISABLE)
	$button0 = GUICtrlCreateButton("dummy", 248 + $xx, 655, 100, 24)
	GUICtrlSetState(-1, $GUI_DEFBUTTON + $gui_hide)
	GUICtrlSetState($radio[$t][@MON], $GUI_CHECKED)
	GUICtrlCreateTabItem("")
EndFunc   ;==>setupscreen
Func Today()
	Return @MON & "/" & @MDAY & "/" & @YEAR
EndFunc   ;==>Today