#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=OfficeMacroSecurity_EN.exe
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_File_Add=OfficeMacroSecurity_HLP_EN.txt
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

; MS OFFICE SECURITY SETTINGS GET/SET TOOL

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; ===WARNING!===
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; 1. USE THIS TOOL AT YOUR OWN DISCRETION. THE AUTHOR(S) IS/ARE NOT LIABLE FOR ANY DETRIMENTAL CONSEQUENCES OF USING THIS TOOL! PLEASE READ THE PARAMETER HELP BEFORE USE
; (CALL THE .EXE WITH NO PARAMETERS TO EVOKE THE HELP DIALOG OR SEE THE DESCRIPTION BELOW IN THIS SOURCE FILE)

; 2. CURRENTLY ONLY 2 OFFICE VERSIONS ARE SUPPORTED: 11.0 (OFFICE 2003) AND 12.0 (OFFICE 2007). HOWEVER, MORE VERSION SUPPORT CAN BE INTEGRATED INTO THE SCRIPT
; (SEE 'GetRegKey' FUNCTION)

; 3. CURRENTLY THE TOOL SUPPORTS ONLY THE FOLLOWING MS OFFICE APPLICATIONS:
;	- MS WORD
;	- MS EXCEL
;	- MS ACCESS
; 	- MS POWERPOINT
;	- MS OUTLOOK
;	IN CASE MORE APPLICATIONS ARE NEEDED, THE CORRESPONDING FUNCTIONS AND THE MAIN CODE, AS WELL AS THE COMMAND LINE PARAMETERS MUST BE CHANGED.

; 4. NO GUI IS PROVIDED. THIS IS A PURELY CONSOLE-RUN (COMMAND-LINE) APPLICATION (SEE PARAMETER DESCRIPTION BELOW)
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; ===COMMAND LINE PARAMETERS===
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#CS COMMAND LINE PARAMETERS
	
	---------------------
	Reg values used
	---------------------
	
	Macro security level (DWORD): 							1 (0x00000001)=low (enable all macros), 2 (0x00000002)=medium (warn user), 3 (0x00000003)=high (disable all macros)
	Access to Visual Basic Object Model (VBOM) (DWORD): 	1 (0x00000001)=access granted, 0 (0x00000000)=access dented
	
	---------------------
	MS Office 2003 (11.0) Registry Keys
	---------------------
	
	WORD:
	Macro security: 				HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Word\security\Level
	VBOM access: 					HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Word\security\AccessVBOM
	
	EXCEL:
	Macro security: 				HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Excel\security\Level
	VBOM access: 					HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Excel\security\AccessVBOM
	
	ACCESS:
	Macro security: 				HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Access\security\Level
	VBOM access: 					HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Access\security\AccessVBOM
	
	POWERPOINT:
	Macro security: 				HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\PowerPoint\security\Level
	VBOM access: 					HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\PowerPoint\security\AccessVBOM
	
	OUTLOOK:
	Macro security: 				HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Outlook\security\Level
	VBOM access: 					<NOT PROVIDED>
	
	---------------------
	MS Office 2007 (12.0) Registry Keys
	---------------------
	
	WORD:
	Macro security: 				HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\Word\Security\VBAWarnings
	VBOM access: 					HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\Word\Security\AccessVBOM
	
	EXCEL:
	Macro security: 				HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\Excel\Security\VBAWarnings
	VBOM access: 					HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\Excel\Security\AccessVBOM
	
	ACCESS:
	Macro security: 				HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\Access\Security\VBAWarnings
	VBOM access: 					HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\Access\Security\AccessVBOM
	
	POWERPOINT:
	Macro security: 				HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\PowerPoint\Security\VBAWarnings
	VBOM access: 					HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\PowerPoint\Security\AccessVBOM
	
	OUTLOOK:
	Macro security: 				HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\Outlook\Security\Level
	VBOM access: 					<NOT PROVIDED>
	
	---------------------
	Command line parameters:
	---------------------
	
	Command enumeration:
	
	---- core commands (1st parameter passed)
	get								- get data (output to stdout)
	set								- set data
	
	---- ms office applications (2nd parameter passed)
	-w OR -word						- get/set value(s) for MS Word
	-e OR -excel					- get/set value(s) for MS Excel
	-a OR -access					- get/set value(s) for MS Access
	-p OR -powerpoint				- get/set value(s) for MS PowerPoint
	-o OR -outlook					- get/set value(s) for MS Outlook
	
	---- values to get or set (parameters 3 to 5)
	-ov								- get application version (only used with 'GET')
	-s »À» -security=...				- get/set macro security level:
	;									- 1=low (enable all)
	;									- 2=medium (warn user)
	;									- 3=high (disable all)
	-v »À» -vbom=...					- get/set VBOM (VBA Object Model) access - UNAVAILABLE IN OUTLOOK (!)
	;									- 1=access granted
	;									- 0=access dented
	
	---------------------
	Calling scheme:
	---------------------
	[Square brackets] denote optional parameters
	Vertical|separator denotes interchangeable parameters/values
	
	GET DATA:
	OfficeMacroSecurity.exe get -w[ord]|-e[xcel]|-a[ccess]|-p[owerpoint]|-o[utlook] [ [-ov] [-s[ecurity]] [v[bom]] ]
	
	”—“¿ÕŒ¬»“‹ œ¿–¿Ã≈“–€
	OfficeMacroSecurity.exe set -w[ord]|-e[xcel]|-a[ccess]|-p[owerpoint]|-o[utlook] [-s[ecurity]=1|2|3] [-v[bom]=0|1]
	
	---------------------
	Examples:
	---------------------
	OfficeMacroSecurity.exe set -w[ord] -s[ecurity]=1 -v[bom]=1		-- For MS Word, set macro security = 1 (low) and VBOM access = 1 (enable)
	OfficeMacroSecurity.exe set -w[ord] -s[ecurity]=2				-- For MS Word, set macro security = 2 (medium), do not change VBOM access
	OfficeMacroSecurity.exe get -w[ord]								-- For MS Word, get (show) all the available settings (version, security level, VBOM access)
	OfficeMacroSecurity.exe get -e[xcel] -v[bom]					-- For MS Excel, get (show) the current VBOM access
	OfficeMacroSecurity.exe get -a[ccess] -ov						-- For MS Access, get (show) the current application version (e.g. "12.0" = 2007)
#CE

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Global $PCT = $CmdLine[0]
;~ Global $HLP_FILE = @ScriptDir & "\OfficeMacroSecurity_HLP_EN.txt"
Global $HLP_FILE = "OfficeMacroSecurity_HLP_EN.txt"
Global $s_HLP_FILE = ""

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$file = FileOpen($HLP_FILE, 0)
If $file <> -1 Then
	$s_HLP_FILE = FileRead($file)
	FileClose($file)
EndIf

;===============================================================================================================
Func GetRegKey($app, $key)
	Local $ov, $arr[3] = ["", "", ""]
	Switch $app
		Case "w"
			$ov = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\Word", "WordName")
			If $ov = "" And @error <> 0 Then
				$ov = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Word", "WordName")
				If $ov = "" And @error <> 0 Then
					ShowError("Unable to get the version of MS Word (must be 11.0 or 12.0)!")
				Else
					; word 11.0
					Switch $key
						Case "s"
							$arr[0] = "11.0"
							$arr[1] = "HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Word\security"
							$arr[2] = "Level"
							Return $arr
						Case "v"
							$arr[0] = "11.0"
							$arr[1] = "HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Word\security"
							$arr[2] = "AccessVBOM"
							Return $arr
						Case Else
							Return $arr
					EndSwitch
				EndIf
			Else
				; word 12.0
				Switch $key
					Case "s"
						$arr[0] = "12.0"
						$arr[1] = "HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\Word\Security"
						$arr[2] = "VBAWarnings"
						Return $arr
					Case "v"
						$arr[0] = "12.0"
						$arr[1] = "HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\Word\Security"
						$arr[2] = "AccessVBOM"
						Return $arr
					Case Else
						Return $arr
				EndSwitch
			EndIf
		Case "e"
			$ov = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\Excel", "ExcelName")
			If $ov = "" And @error <> 0 Then
				$ov = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Excel", "ExcelName")
				If $ov = "" And @error <> 0 Then
					ShowError("Unable to get the version of MS Excel (must be 11.0 or 12.0)!")
				Else
					; excel 11.0
					Switch $key
						Case "s"
							$arr[0] = "11.0"
							$arr[1] = "HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Excel\security"
							$arr[2] = "Level"
							Return $arr
						Case "v"
							$arr[0] = "11.0"
							$arr[1] = "HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Excel\security"
							$arr[2] = "AccessVBOM"
							Return $arr
						Case Else
							Return $arr
					EndSwitch
				EndIf
			Else
				; excel 12.0
				Switch $key
					Case "s"
						$arr[0] = "12.0"
						$arr[1] = "HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\Excel\Security"
						$arr[2] = "VBAWarnings"
						Return $arr
					Case "v"
						$arr[0] = "12.0"
						$arr[1] = "HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\Excel\Security"
						$arr[2] = "AccessVBOM"
						Return $arr
					Case Else
						Return $arr
				EndSwitch
			EndIf
		Case "a"
			$ov = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\Access", "AccessName")
			If $ov = "" And @error <> 0 Then
				$ov = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Access", "AccessName")
				If $ov = "" And @error <> 0 Then
					ShowError("Unable to get the version of MS Access (must be 11.0 or 12.0)!")
				Else
					; access 11.0
					Switch $key
						Case "s"
							$arr[0] = "11.0"
							$arr[1] = "HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Access\security"
							$arr[2] = "Level"
							Return $arr
						Case "v"
							$arr[0] = "11.0"
							$arr[1] = "HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Access\security"
							$arr[2] = "AccessVBOM"
							Return $arr
						Case Else
							Return $arr
					EndSwitch
				EndIf
			Else
				; excel 12.0
				Switch $key
					Case "s"
						$arr[0] = "12.0"
						$arr[1] = "HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\Access\Security"
						$arr[2] = "VBAWarnings"
						Return $arr
					Case "v"
						$arr[0] = "12.0"
						$arr[1] = "HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\Access\Security"
						$arr[2] = "AccessVBOM"
						Return $arr
					Case Else
						Return $arr
				EndSwitch
			EndIf
		Case "p"
			$ov = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\PowerPoint", "PowerPointName")
			If $ov = "" And @error <> 0 Then
				$ov = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\PowerPoint", "PowerPointName")
				If $ov = "" And @error <> 0 Then
					ShowError("Unable to get the version of MS PowerPoint (must be 11.0 or 12.0)!")
				Else
					; powerpoint 11.0
					Switch $key
						Case "s"
							$arr[0] = "11.0"
							$arr[1] = "HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\PowerPoint\security"
							$arr[2] = "Level"
							Return $arr
						Case "v"
							$arr[0] = "11.0"
							$arr[1] = "HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\PowerPoint\security"
							$arr[2] = "AccessVBOM"
							Return $arr
						Case Else
							Return $arr
					EndSwitch
				EndIf
			Else
				; powerpoint 12.0
				Switch $key
					Case "s"
						$arr[0] = "12.0"
						$arr[1] = "HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\PowerPoint\Security"
						$arr[2] = "VBAWarnings"
						Return $arr
					Case "v"
						$arr[0] = "12.0"
						$arr[1] = "HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\PowerPoint\Security"
						$arr[2] = "AccessVBOM"
						Return $arr
					Case Else
						Return $arr
				EndSwitch
			EndIf
		Case "o"
			$ov = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\Outlook", "OutlookName")
			If $ov = "" And @error <> 0 Then
				$ov = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Outlook", "OutlookName")
				If $ov = "" And @error <> 0 Then
					ShowError("Unable to get the version of MS Outlook (must be 11.0 or 12.0)!")
				Else
					; outlook 11.0
					Switch $key
						Case "s"
							$arr[0] = "11.0"
							$arr[1] = "HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Outlook\security"
							$arr[2] = "Level"
							Return $arr
						Case Else
							Return $arr
					EndSwitch
				EndIf
			Else
				; outlook 12.0
				Switch $key
					Case "s"
						$arr[0] = "12.0"
						$arr[1] = "HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\Outlook\Security"
						$arr[2] = "Level"
						Return $arr
					Case Else
						Return $arr
				EndSwitch
			EndIf
		Case Else
			Return $arr
	EndSwitch
	;return $arr
EndFunc   ;==>GetRegKey
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Func GetData($app, $b_ov = True, $b_sec = True, $b_vbom = True)

	Local $arr_sec[3], $arr_vbom[3], $app_

	Switch StringLower($app)
		Case "-w", "-word"
			$app_ = "w"
		Case "-e", "-excel"
			$app_ = "e"
		Case "-a", "-access"
			$app_ = "a"
		Case "-p", "-powerpoint"
			$app_ = "p"
		Case "-o", "-outlook"
			$app_ = "o"
		Case Else
			ShowError("Error in parameter '" & $app & "'!")
	EndSwitch

	If $b_sec = True Or $b_ov = True Then
		$arr_sec = GetRegKey($app_, "s")
	EndIf
	If $b_vbom = True Then
		$arr_vbom = GetRegKey($app_, "v")
	EndIf

	Local $s_value = "", $v_value = "", $ov_value = ""

	If $b_ov = True Then
		$ov_value = $arr_sec[0]
	EndIf

	If $b_sec = True And $arr_sec[0] <> "" Then
		$s_value = RegRead($arr_sec[1], $arr_sec[2])
	EndIf

	If $b_vbom = True And $arr_vbom[0] <> "" Then
		$v_value = RegRead($arr_vbom[1], $arr_vbom[2])
	EndIf

	OutputData($app_, $ov_value, $s_value, $v_value)

EndFunc   ;==>GetData
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Func OutputData($app, $ov, $sec, $vbom)
	$theapp = ""
	Switch $app
		Case "w"
			$theapp = "WORD"
		Case "e"
			$theapp = "EXCEL"
		Case "a"
			$theapp = "ACCESS"
		Case "p"
			$theapp = "POWERPOINT"
		Case "o"
			$theapp = "OUTLOOK"
		Case Else
			ShowError("First parameter wrong (application name)!")
	EndSwitch

	ConsoleWrite(@CRLF & @TAB & "OMS => RETRIEVING VERSION/SECURITY DATA FOR MS " & $theapp & ":" & @CRLF & @CRLF)

	If $ov <> "" Then
		ConsoleWrite(@TAB & @TAB & "MS " & $theapp & " VERSION=" & $ov & @CRLF)
	EndIf

	If $sec <> "" Then
		$sec_n = Int($sec)
		If @error Then
			ConsoleWrite(@TAB & @TAB & "MS " & $theapp & " SECURITY LEVEL=<NOT AVAILABLE>" & @CRLF)
		Else
			Switch $sec_n
				Case 1
					ConsoleWrite(@TAB & @TAB & "MS " & $theapp & " SECURITY LEVEL=" & $sec_n & " (LOW)" & @CRLF)
				Case 2
					ConsoleWrite(@TAB & @TAB & "MS " & $theapp & " SECURITY LEVEL=" & $sec_n & " (MEDIUM)" & @CRLF)
				Case 3
					ConsoleWrite(@TAB & @TAB & "MS " & $theapp & " SECURITY LEVEL=" & $sec_n & " (HIGH)" & @CRLF)
				Case Else
					ConsoleWrite(@TAB & @TAB & "MS " & $theapp & " SECURITY LEVEL=<NOT AVAILABLE>" & @CRLF)
			EndSwitch
		EndIf
	EndIf

	If $vbom <> "" Then
		$vbom_n = Int($vbom)
		If @error Then
			ConsoleWrite("MS " & $theapp & " VBOM ACCESS=<NOT AVAILABLE>" & @CRLF)
		Else
			Switch $vbom_n
				Case 0
					ConsoleWrite(@TAB & @TAB & "MS " & $theapp & " VBOM ACCESS=ACCESS DENTED" & @CRLF)
				Case 1
					ConsoleWrite(@TAB & @TAB & "MS " & $theapp & " VBOM ACCESS=ACCESS GRANTED" & @CRLF)
				Case Else
					ConsoleWrite(@TAB & @TAB & "MS " & $theapp & " VBOM ACCESS=<NOT AVAILABLE>" & @CRLF)
			EndSwitch
		EndIf
	EndIf

	ConsoleWrite(@CRLF & @TAB & "OMS => VERSION/SECURITY DATA RETRIEVED!" & @CRLF)

EndFunc   ;==>OutputData
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Func SetAppData($app, $s, $v)

	$theapp = ""
	Switch $app
		Case "w"
			$theapp = "WORD"
		Case "e"
			$theapp = "EXCEL"
		Case "a"
			$theapp = "ACCESS"
		Case "p"
			$theapp = "POWERPOINT"
		Case "o"
			$theapp = "OUTLOOK"
		Case Else
			ShowError("First parameter wrong (application name)!")
	EndSwitch

	ConsoleWrite(@CRLF & @TAB & "OMS => SETTING VERSION/SECURITY DATA FOR MS " & $theapp & ":" & @CRLF & @CRLF)

	If $s = -1 And $v = -1 Then
		ShowError("You must specify at least 1 parameter whose value is to be changed - either 'VBAWarnings' or 'AccessVBOM', or both!")
	EndIf

	Local $arr_sec[3], $arr_vbom[3], $result, $sec_s = "<NOT AVAILABLE>", $vbom_s = "<NOT AVAILABLE>"

	If $s <> -1 Then
		$arr_sec = GetRegKey($app, "s")
		If $arr_sec[0] = "" Then
			ShowError("Error getting registry key!")
		EndIf
		$result = RegWrite($arr_sec[1], $arr_sec[2], "REG_DWORD", $s)
		If $result = 0 Then
			ShowError("Error writing '" & $s & "' to '" & $arr_sec[1] & "\" & $arr_sec[2] & "'!")
		EndIf

		Switch $s
			Case 1
				$sec_s = "LOW"
			Case 2
				$sec_s = "MEDIUM"
			Case 3
				$sec_s = "HIGH"
		EndSwitch

		ConsoleWrite(@TAB & @TAB & "MS " & $theapp & " SECURITY LEVEL CHANGED TO " & $s & " (" & $sec_s & ")" & @CRLF)
	EndIf

	If $v <> -1 And $app <> "o" Then
		$arr_vbom = GetRegKey($app, "v")
		If $arr_vbom[0] = "" Then
			ShowError("Error getting registry key!")
		EndIf
		$result = RegWrite($arr_vbom[1], $arr_vbom[2], "REG_DWORD", $v)
		If $result = 0 Then
			ShowError("Error writing '" & $v & "' to '" & $arr_vbom[1] & "\" & $arr_vbom[2] & "'!")
		EndIf

		Switch $v
			Case 0
				$vbom_s = "ACCESS DENTED"
			Case 1
				$vbom_s = "ACCESS GRANTED"
		EndSwitch

		ConsoleWrite(@TAB & @TAB & "MS " & $theapp & " VBOM ACCESS CHANGED TO " & $v & " (" & $vbom_s & ")" & @CRLF)
	EndIf

	ConsoleWrite(@CRLF & @TAB & "OMS => VERSION/SECURITY DATA SET!" & @CRLF)

EndFunc   ;==>SetAppData
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Func SetData($p_app, $p1, $p2)
	; œÓ‚ÂÍË Ì‡ ‰ÓÓ„‡ı ;)
	If $p1 = "" And $p2 = "" Then
		ShowError("The 2nd and 3d parameters passed to 'SetData' are empty!")
	EndIf

	Local $s = -1, $v = -1, $p1data, $p2data, $p1_1, $p1_2, $p1_2_n = -1, $p2_1, $p2_2, $p2_2_n = -1

	If $p1 <> "" Then
		$p1data = StringSplit($p1, "=")
		If @error <> 0 Or $p1data[0] <> 2 Then
			ShowError("Error in parameter '" & $p1 & "'!")
		EndIf
		$p1_1 = StringLower(StringStripWS($p1data[1], 8))
		$p1_2 = StringLower(StringStripWS($p1data[2], 8))
		$p1_2_n = Int($p1_2)
		If @error <> 0 Or $p1_2_n < 0 Or $p1_2_n > 3 Then
			ShowError("Error in parameter '" & $p1 & "'!")
		EndIf

		Switch $p1_1
			Case "-s", "-security"
				Switch $p1_2_n
					Case 1 To 3
						$s = $p1_2_n
					Case Else
						ShowError("Error in parameter '" & $p1 & "'!")
				EndSwitch
			Case "-v", "-vbom"
				Switch $p1_2_n
					Case 0 To 1
						$v = $p1_2_n
					Case Else
						ShowError("Error in parameter '" & $p1 & "'!")
				EndSwitch
			Case Else
				ShowError("Error in parameter '" & $p1 & "'!")
		EndSwitch
	EndIf

	If $p2 <> "" Then
		$p2data = StringSplit($p2, "=")
		If @error <> 0 Or $p2data[0] <> 2 Then
			ShowError("Error in parameter '" & $p2 & "'!")
		EndIf
		$p2_1 = StringLower(StringStripWS($p2data[1], 8))
		$p2_2 = StringLower(StringStripWS($p2data[2], 8))
		$p2_2_n = Int($p2_2)
		If @error <> 0 Or $p2_2_n < 0 Or $p2_2_n > 3 Then
			ShowError("Error in parameter '" & $p2 & "'!")
		EndIf

		Switch $p2_1
			Case "-s", "-security"
				Switch $p2_2_n
					Case 1 To 3
						If $s = -1 Then
							$s = $p2_2_n
						Else
							ShowError("Multiple occurrence of parameter '" & $p2 & "'!")
						EndIf
					Case Else
						ShowError("Error in parameter '" & $p2 & "'!")
				EndSwitch
			Case "-v", "-vbom"
				Switch $p2_2_n
					Case 0 To 1
						If $v = -1 Then
							$v = $p2_2_n
						Else
							ShowError("Multiple occurrence of parameter '" & $p2 & "'!")
						EndIf
					Case Else
						ShowError("Error in parameter '" & $p2 & "'!")
				EndSwitch
			Case Else
				ShowError("Error in parameter '" & $p2 & "'!")
		EndSwitch
	EndIf

	Switch StringLower($p_app)
		Case "-w", "-word"
			SetAppData("w", $s, $v)
		Case "-e", "-excel"
			SetAppData("e", $s, $v)
		Case "-a", "-access"
			SetAppData("a", $s, $v)
		Case "-p", "-powerpoint"
			SetAppData("p", $s, $v)
		Case "-o", "-outlook"
			SetAppData("o", $s, -1)
		Case Else
			ShowError("Error in parameter '" & $p_app & "'!", True)
	EndSwitch

EndFunc   ;==>SetData
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Func ShowError($custom_text = "", $bShowHelp = False)
	If $custom_text <> "" Then
		MsgBox(16, "Error!", $custom_text)
	EndIf

	ConsoleWrite(@CRLF & @TAB & "OMS => Error occurred! Quitting ..." & @CRLF)

	If $bShowHelp = True Then
		ConsoleWrite(@CRLF & @TAB & "COMMAND LINE PARAMETERS HELP:" & @CRLF & @CRLF)
		ConsoleWrite($s_HLP_FILE & @CRLF)
	EndIf

	Exit 1
EndFunc   ;==>ShowError

;===============================================================================================================

Dim $getov = False, $gets = False, $getv = False, $par1, $par2, $par3 = "", $par4 = "", $i

If $PCT < 2 Or $PCT > 5 Then
	ShowError("Wrong number of command line parameters!", True)
EndIf

$par1 = StringLower($CmdLine[1])
$par2 = StringLower($CmdLine[2])

If $par2 <> "-w" And $par2 <> "-word" And $par2 <> "-e" And $par2 <> "-excel" _
		And $par2 <> "-a" And $par2 <> "-access" And $par2 <> "-p" And $par2 <> "-powerpoint" _
		And $par2 <> "-o" And $par2 <> "-outlook" Then
	ShowError("Error in parameter '" & $par2 & "'!", True)
EndIf

If $par1 = "get" Then

	If $PCT = 2 Then
		GetData($par2, True, True, True)
	Else
		For $i = 3 To $PCT
			Switch StringLower($CmdLine[$i])
				Case "-ov"
					If $getov = False Then
						$getov = True
					Else
						ShowError("Multiple occurrence of parameter '-ov'!")
					EndIf
				Case "-s", "-security"
					If $gets = False Then
						$gets = True
					Else
						ShowError("Multiple occurrence of parameter '-s (-security)'!")
					EndIf
				Case "-v", "-vbom"
					If $getv = False Then
						$getv = True
					Else
						ShowError("Multiple occurrence of parameter '-v (-vbom)'!")
					EndIf
				Case Else
					ShowError("Undefined parameter '" & StringLower($CmdLine[$i]) & "'!", True)
			EndSwitch
		Next
		GetData($par2, $getov, $gets, $getv)
	EndIf

	Exit 0

ElseIf $par1 = "set" Then

	Switch $PCT
		Case 3
			$par3 = StringLower($CmdLine[3])
			SetData($par2, $par3, "")
			Exit 0
		Case 4
			$par3 = StringLower($CmdLine[3])
			$par4 = StringLower($CmdLine[4])
			SetData($par2, $par3, $par4)
			Exit 0
		Case Else
			ShowError("Wrong number of parameters required after 'set'!", True)
	EndSwitch

Else

	ShowError("First parameter must be either 'get' or 'set'!", True)

EndIf