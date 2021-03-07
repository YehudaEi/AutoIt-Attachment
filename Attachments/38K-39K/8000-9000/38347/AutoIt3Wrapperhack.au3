#NoTrayIcon
#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=AutoIt3Wrapper.ico
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Comment=Compile,Run,Check,Tidy or Obfuscater your Autoit3 script with options like update the resource information.
#AutoIt3Wrapper_Res_Description=Compile,Run,Check,Tidy or Obfuscater your Autoit3 script with options like update the resource information.
#AutoIt3Wrapper_Res_Fileversion=2.1.0.8
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © 2011 Jos van der Zande
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Res_Field=Made By|Jos van der Zande
#AutoIt3Wrapper_Res_Field=Email|jdeb at autoitscript dot com
#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_Res_Field=Compile Date|%date% %time%
#AutoIt3Wrapper_Res_Field=Productname|Autoit3Wrapper for AutoIt3 scripts
#AutoIt3Wrapper_Res_Field=ProductVersion|Version 2.0
#AutoIt3Wrapper_Res_Field=CompanyName|Jos van der Zande
#AutoIt3Wrapper_Res_Field=Credits|wraithdu - Updating the Resource UDFs allowing other sections to be included.
#AutoIt3Wrapper_Res_Field=Credits|jchd - added support for UTF files.
#AutoIt3Wrapper_AU3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_Run_After=copy "%in%" "..\..\Programs_Updates\AutoIt3Wrapper"
#AutoIt3Wrapper_Run_After=copy "%out%" "..\..\Programs_Updates\AutoIt3Wrapper"
#AutoIt3Wrapper_Run_After=Copy "%in%" "c:\Program Files (x86)\autoit3\SciTE\AutoIt3Wrapper"
#AutoIt3Wrapper_Run_After=aaCopy2Prod.exe "AutoIt3Wrapper.exe" "AutoIt3Wrapper.exe" "C:\Program Files (x86)\AutoIt3\SciTE\AutoIt3Wrapper" "%in%" %fileversion% %fileversionnew%
#AutoIt3Wrapper_Run_Tidy=y
#Tidy_Parameters=/nsdp
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/striponly
#AutoIt3Wrapper_Run_cvsWrapper=v
#AutoIt3Wrapper_cvsWrapper_Parameters=/Comments %fileversion%
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#region AutoIT General Settings & Includes
#include <Array.au3>
#include <Date.au3>
#include <File.au3>
#include <GuiTab.au3>
#include <WinAPI.au3>
#include <Constants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
;
; get program version for display purpose
Global $VERSION = FileGetVersion(@ScriptFullPath)
;~ $VERSION = StringLeft($VERSION, StringInStr($VERSION, ".", 0, -1) - 1)
; Only show general info for the main script
If Not StringInStr($CMDLINERAW, "/watcher") _
		And Not StringInStr($CMDLINERAW, "/au3record") _
		And Not StringInStr($CMDLINERAW, "/au3info") _
		Then
	ConsoleWrite("+>" & @HOUR & ":" & @MIN & ":" & @SEC & " Starting AutoIt3Wrapper v." & $VERSION)
	ConsoleWrite('    Environment(Language:' & @OSLang & "  Keyboard:" & @KBLayout & "  OS:" & @OSVersion & "/" & @OSServicePack & "  CPU:" & @CPUArch & " OS:" & @OSArch)
	ConsoleWrite(")" & @CRLF)
EndIf
#endregion AutoIT General Settings & Includes
#region Declare variables
Global $ShowGUI = 0
;
; RESOURCE CONSTANTS
;
Global Const $IMAGE_DOS_SIGNATURE = 0x5A4D
Global Const $tagIMAGE_SECTION_HEADER = _
		"byte Name[8];" & _
		"dword Misc;" & _
		"dword VirtualAddress;" & _
		"dword SizeOfRawData;" & _
		"dword PointerToRawData;" & _
		"dword PointerToRelocations;" & _
		"dword PointerToLinenumber;" & _
		"ushort NumberOfRelocations;" & _
		"ushort NumberOfLinenumbers;" & _
		"dword Characteristics"
Global Const $tagIMAGE_DOS_HEADER = _
		"ushort emagic;" & _
		"ushort ecblp;" & _
		"ushort ecp;" & _
		"ushort ecrlc;" & _
		"ushort ecparhdr;" & _
		"ushort eminalloc;" & _
		"ushort emaxalloc;" & _
		"ushort ess;" & _
		"ushort esp;" & _
		"ushort ecsum;" & _
		"ushort eip;" & _
		"ushort ecs;" & _
		"ushort elfarlc;" & _
		"ushort eovno;" & _
		"ushort eres[4];" & _
		"ushort eoemid;" & _
		"ushort eoeminfo;" & _
		"ushort eres2[10];" & _
		"long elfanew"
Global Const $tagIMAGE_FILE_HEADER = _
		"ushort Machine;" & _
		"ushort NumberOfSections;" & _
		"dword TimeDateStamp;" & _
		"dword PointerToSymbolTable;" & _
		"dword NumberOfSymbols;" & _
		"ushort SizeOfOptionalHeader;" & _
		"ushort Characteristics"
Global $tagTEMP = _
		"ushort Magic;" & _ ; Standard fields
		"byte MajorLinkerVersion;" & _
		"byte MinorLinkerVersion;" & _
		"dword SizeOfCode;" & _
		"dword SizeOfInitializedData;" & _
		"dword SizeOfUninitializedData;" & _
		"dword AddressOfEntryPoint;" & _
		"dword BaseOfCode;" & _
		"dword BaseOfData;" & _
		"dword ImageBase;" & _ ; NT additional fields
		"dword SectionAlignment;" & _
		"dword FileAlignment;" & _
		"ushort MajorOperatingSystemVersion;" & _
		"ushort MinorOperatingSystemVersion;" & _
		"ushort MajorImageVersion;" & _
		"ushort MinorImageVersion;" & _
		"ushort MajorSubsystemVersion;" & _
		"ushort MinorSubsystemVersion;" & _
		"dword Win32VersionValue;" & _
		"dword SizeOfImage;" & _
		"dword SizeOfHeaders;" & _
		"dword CheckSum;" & _
		"ushort Subsystem;" & _
		"ushort DllCharacteristics;" & _
		"dword SizeOfStackReserve;" & _
		"dword SizeOfStackCommit;" & _
		"dword SizeOfHeapReserve;" & _
		"dword SizeOfHeapCommit;" & _
		"dword LoaderFlags;" & _
		"dword NumberOfRvaAndSizes"
; assign indexes to each IMAGE_DATA_DIRECTORY struct so we can find them later
For $i = 0 To 15
	$tagTEMP &= ";ulong VirtualAddress" & $i & ";ulong Size" & $i
Next
Global Const $tagIMAGE_OPTIONAL_HEADER = $tagTEMP
$tagTEMP = 0
Global Const $tagIMAGE_NT_HEADERS = _
		"dword Signature;" & _
		$tagIMAGE_FILE_HEADER & ";" & _ ; offset = 4
		$tagIMAGE_OPTIONAL_HEADER ; offset = 24
Global $g_aResNamesAndLangs[1][2] = [[0, 0]] ; reset array
Global $rh, $hLangCallback
Global $aVersionInfo, $aManifestInfo, $aTemp
Global $IconFileInfo
Global $ScriptFile_In = "", $ScriptFile_In_Ext = "", $ScriptFile_In_Obfuscated = "", $ScriptFile_Out = "", $ScriptFile_Out_x86 = "", $ScriptFile_Out_x64 = "", $ScriptFile_Out_Type = ""
Global $INP_Compile_Both = 0
Global $INP_Icon = "", $INP_Compression = "", $INP_AutoIT3_Version = ""
Global $AutoIT3_PGM = "", $AUT2EXE_PGM = "", $INP_AutoitDir = ""
Global $INP_Run_Debug_Mode = 0, $INP_UseUpx = "", $INP_Upx_Parameters = "", $INP_UseAnsi = "n", $INP_UseX64 = "", $INP_Comment = "", $INP_Description = "", $INP_Res_SaveSource = ""
Global $INP_Res_Language = "", $INP_RES_requestedExecutionLevel = "", $INP_RES_HiDpi = "", $INP_RES_Compatibility = "", $INP_Fileversion = "", $INP_Fileversion_New = "", $INP_Fileversion_AutoIncrement = "", $INP_LegalCopyright = ""
Global $INP_ProductVersion = "", $INP_CompiledScript = "", $INP_FieldName1 = "", $INP_FieldValue1 = "", $INP_FieldName2 = "", $INP_FieldValue2 = "", $INP_RES_FieldCount = 0, $INP_FieldName[16]
Global $INP_FieldValue[16], $INP_Run_Tidy = "", $INP_Run_Obfuscator = "", $INP_Tidy_Stop_OnError = "Y", $INP_Run_AU3Check = "", $INP_Add_Constants = "", $INP_Run_SciTE_Minimized = "n", $INP_Run_SciTE_OutputPane_Minimized = "n"
Global $INP_AU3Check_Stop_OnWarning, $INP_AU3Check_Parameters, $INP_Run_Before, $INP_Run_After, $INP_Run_cvsWrapper, $INP_cvsWrapper_Parameters
Global $INP_Plugin, $INP_Change2CUI, $INP_Icons[1], $INP_Icons_cnt = 0, $INP_Res_Files[1], $INP_Res_Files_Cnt = 0, $TempFile, $TempFile2
Global $INP_Au3check_Plugin, $INP_Tidy_Parameters = "", $INP_Obfuscator_Parameters = "", $INP_AutoIt3Wrapper_LogFile = ""
Global $H_Resource, $H_Comment, $H_Description, $H_Fileversion, $H_Fileversion_AutoIncrement_n, $H_Fileversion_AutoIncrement_p, $H_Fileversion_AutoIncrement_y
Global $H_LegalCopyright, $H_FieldNameEdit, $H_Res_Language
Global $IconResBase = 49
Global $ObfuscatorCmdLine
Global $DebugIcon = ""
Global $INP_Resource = 0
Global $INP_Resource_Version = 0
Global $Parameter_Mode = 0
Global $Debug = 0
Global $Registry = "HKCU\Software\AutoIt v3"
Global $RegistryLM = "HKLM\Software\AutoIt v3\Autoit"
Global $Option = "Compile"
Global $s_CMDLine = ""
Global $ToTalFile
Global $H_Outf
Global $CurSciTEFile, $CurSciTELine, $FindVer, $CurSelection
Global $dummy, $V_Arg, $T_Var, $H_Cmp, $H_au3, $rc, $Save_Workdir, $AUT2EXE_DIR, $AUT2EXE_PGM_N, $msg, $AUT2EXE_PGM_VER
Global $LSCRIPTDIR, $AutoIt_Icon, $INP_Icon_Temp, $AutoIt_Icon_Dir
Global $InputFileIsUTF8 = 0
Global $InputFileIsUTF16 = 0
Global $InputFileIsUTF32 = 0
Global $ProcessBar_Title
Global $Pid, $Handle, $Return_Text, $ExitCode
Global $sCmd
Global $SrceUnicodeFlag, $UTFtype
;
Global $SciTE_Dir = _PathFull(@ScriptDir & "..\..")
Global $CurrentAutoIt_InstallDir = _PathFull(@ScriptDir & "..\..\..")
If StringLeft($SciTE_Dir, 3) = "\\\" Then $SciTE_Dir = StringMid($SciTE_Dir, 2)
If StringLeft($CurrentAutoIt_InstallDir, 3) = "\\\" Then $CurrentAutoIt_InstallDir = StringMid($CurrentAutoIt_InstallDir, 2)
;~ If StringInStr($SciTE_Dir, "\", '', -1) > 0 Then $SciTE_Dir = StringLeft($SciTE_Dir, StringInStr($SciTE_Dir, "\", '', -1) - 1)
;
#endregion Declare variables
#region Commandline lexing
; retrieve commandline parameters
;-------------------------------------------------------------------------------------------
$V_Arg = "Valid Arguments are:" & @CRLF
$V_Arg = $V_Arg & "    /in  ScriptFile " & @CRLF
$V_Arg = $V_Arg & "    /out Targetfile " & @CRLF
$V_Arg = $V_Arg & "    /icon IconFile " & @CRLF
;~ $V_Arg = $V_Arg & "    /pass passphrase " & @CRLF
$V_Arg = $V_Arg & "    /comp 0 to 4  (Lowest to Highest) " & @CRLF
$V_Arg = $V_Arg & "    /nopack  Skip UPX step." & @CRLF
$V_Arg = $V_Arg & "    /pack    Run UPX (Default) " & @CRLF
$V_Arg = $V_Arg & "    /ansi    Compile as Ansi for use with Win9x. " & @CRLF
$V_Arg = $V_Arg & "    /unicode Default compile with Unocode support. " & @CRLF
$V_Arg = $V_Arg & "    /x86     Compile for x86 OS." & @CRLF
$V_Arg = $V_Arg & "    /x64     Compile for x64 OS." & @CRLF
$V_Arg = $V_Arg & "    /console Change output program to CUI" & @CRLF
$V_Arg = $V_Arg & "    /Gui     Default, output program will be GUI" & @CRLF
; switch on debug messages when requested
If StringInStr(" " & $CMDLINERAW & " ", " /debug ") Then $Debug = 1
;
If $Debug Then ConsoleWrite("-debug cmdlineraw: " & $CMDLINERAW & @CRLF)
For $x = 1 To $CMDLINE[0]
	$T_Var = StringLower($CMDLINE[$x])
	If $Debug Then
		ConsoleWrite("-debug argument: " & $CMDLINE[$x])
		If $x < $CMDLINE[0] Then ConsoleWrite("     next argument: " & $CMDLINE[$x + 1])
		ConsoleWrite(@CRLF)
	EndIf
	$Parameter_Mode = 1
	Select
		Case $T_Var = "/Watcher"
			; when AutoIt3Wrapper is lanched as watcher to see if the original AutoIt3Wrapper is canceled.
			$H_Cmp = $CMDLINE[$x + 1]
			$H_au3 = $CMDLINE[$x + 2]
			While ProcessExists($H_Cmp) And ProcessExists($H_au3)
				Sleep(500)
			WEnd
			Sleep(500)
			If ProcessExists($H_au3) Then
				ProcessClose($H_au3)
				_RefreshSystemTray()
			EndIf
			Exit
		Case $T_Var = "/au3info"
			; start the correct au3info version
			If $INP_AutoitDir <> "" Then
				$CurrentAutoIt_InstallDir = $INP_AutoitDir
			EndIf
			If @OSArch = "X64" Then
				Run($CurrentAutoIt_InstallDir & "\au3info_x64.exe")
			Else
				Run($CurrentAutoIt_InstallDir & "\au3info.exe")
			EndIf
			Exit
		Case $T_Var = "/au3record"
			If $INP_AutoitDir <> "" Then
				$CurrentAutoIt_InstallDir = $INP_AutoitDir
			EndIf
			; start the correct au3info version
			If @OSArch = "X64" Then
				$Pid = Run($CurrentAutoIt_InstallDir & "\Extras\Au3Record\au3record_x64.exe /o", '', @SW_SHOW, $STDOUT_CHILD + $STDERR_CHILD)
			Else
				$Pid = Run($CurrentAutoIt_InstallDir & "\Extras\Au3Record\au3record.exe /o", '', @SW_SHOW, $STDOUT_CHILD + $STDERR_CHILD)
			EndIf
			$Handle = _ProcessExitCode($Pid)
			$Return_Text = ShowStdOutErr($Pid)
			$ExitCode = _ProcessExitCode($Pid, $Handle)
			_ProcessCloseHandle($Handle)
			StdioClose($Pid)
			Exit
		Case $T_Var = "/?" Or $T_Var = "/help"
			MsgBox(1, "Compile Aut2EXE", "Compile an AutoIt3 Script." & @LF & "commandline argument: " & $T_Var & @LF & $V_Arg)
			Exit
		Case $T_Var = "/in"
			$x = $x + 1
			$ScriptFile_In = $CMDLINE[$x]
		Case $T_Var = "/out"
			$x = $x + 1
			$ScriptFile_Out = $CMDLINE[$x]
		Case $T_Var = "/icon"
			$x = $x + 1
			$INP_Icon = $CMDLINE[$x]
			$DebugIcon = $DebugIcon & "/icon: " & $INP_Icon & @CRLF
		Case $T_Var = "/pass" ; Obsolete
			$x = $x + 1
;~ 			$INP_PassPhrase = $CMDLINE[$x]
;~ 			$INP_PassPhrase2 = $CMDLINE[$x]
;~ 			$INP_Allow_Decompile = "y"
		Case $T_Var = "/compress" Or $T_Var = "/comp" Or $T_Var = "/compression"
			$x = $x + 1
			$INP_Compression = Number($CMDLINE[$x])
		Case $T_Var = "/nodecompile"
;~ 			$INP_Allow_Decompile = "n"
		Case $T_Var = "/Pack"
			$INP_UseUpx = "y"
		Case $T_Var = "/NoPack"
			$INP_UseUpx = "n"
		Case $T_Var = "/Compression"
			$INP_Compression = "y"
		Case $T_Var = "/GUI"
;~ 			Just for compatibility sake
		Case $T_Var = "/Console"
			$INP_Change2CUI = "y"
		Case $T_Var = "/Unicode"
			$INP_UseAnsi = "n"
			$INP_UseX64 = "n"
		Case $T_Var = "/x64"
			$INP_UseX64 = "y"
			$INP_UseAnsi = "n"
		Case $T_Var = "/x86"
			$INP_UseX64 = "n"
			$INP_UseAnsi = "n"
		Case $T_Var = "/run"
			$Option = "Run"
		Case $T_Var = "/debug"
			$Debug = 1
		Case $T_Var = "/au3check"
			$Option = "AU3Check"
		Case $T_Var = "/compiledefaults" ; Obsolete
			; $Option2 = "defaults"  ; Obsolete
		Case $T_Var = "/beta"
			$INP_AutoIT3_Version = "Beta"
		Case $T_Var = "/prod"
			$INP_AutoIT3_Version = "Prod"
		Case $T_Var = "/showgui"
			$ShowGUI = 1
		Case $T_Var = "/Autoit3Dir"
			$x = $x + 1
			$INP_AutoitDir = _PathFull($CMDLINE[$x])
		Case $T_Var = "/UserParams"
			$s_CMDLine = StringTrimLeft($CMDLINERAW, StringInStr($CMDLINERAW, "/UserParams") + 11)
			ExitLoop
		Case Else
			; when /run then optional parameters are allowed
			If $Option = "Compile" Then
				MsgBox(1, "Compile Aut2EXE", "Wrong commandline argument: " & $T_Var & @LF & $V_Arg)
				Exit
			EndIf
			; Build the other params used for running autoit
			$s_CMDLine &= " " & $T_Var
	EndSelect
Next
#endregion Commandline lexing
#region SciTE Director Init
; Try to update the file directly in SciTE in stead of externally by means of the Director interface.
Opt("WinSearchChildren", 1)
;Global $WM_COPYDATA = 74
Global $SciTECmd
Global $SciTE_hwnd = WinGetHandle("DirectorExtension")
; Get My GUI Handle numeric
Global $My_Hwnd = GUICreate("SciTE interface", 300, 600, Default, Default, Default, $WS_EX_TOPMOST)
Global $My_Dec_Hwnd = Dec(StringTrimLeft($My_Hwnd, 2))
;Register COPYDATA message.
GUIRegisterMsg($WM_COPYDATA, "MY_WM_COPYDATA")
; Get SciTE prograqm directory
If Not FileExists($SciTE_Dir & "\SciTE.exe") Then
	$SciTE_Dir = StringReplace(SendSciTE_GetInfo($My_Hwnd, $SciTE_hwnd, "askproperty:SciteDefaultHome"), "\\", "\")
EndIf
#endregion SciTE Director Init
#region Check For SciTE4AutoIt3 updates
If SendSciTE_GetInfo($My_Hwnd, $SciTE_hwnd, "askproperty:check.updates.scite4autoit3") = 1 Then
	If IniRead($SciTE_Dir & "\SciTEVersion.ini", 'SciTE4AutoIt3', 'LastCheckDate', '') <> _NowDate() Then
		CheckForUpdates()
		IniWrite($SciTE_Dir & "\SciTEVersion.ini", 'SciTE4AutoIt3', 'LastCheckDate', _NowDate())
	EndIf
EndIf
#endregion Check For SciTE4AutoIt3 updates
#region Input retrieval/validation
; check/request for input Script File
;-------------------------------------------------------------------------------------------
While Not FileExists($ScriptFile_In) ; Or StringRight($ScriptFile_In, 4) <> '.au3'
	$ScriptFile_In = FileOpenDialog("Select script to Compile with AUT2EXE ?", RegRead($Registry & "\Aut2Exe", "LastScriptDir"), "autoit3(*.au3)", 1)
	If @error = 1 Then
		$rc = MsgBox(4100, "Autoit3 Compile", "do you want to stop the process?")
		If $rc = 6 Then Exit
	EndIf
WEnd
; Get the default values for this particular script from the ini when not specified on the commandline
;-----------------------------------------------------------------------------------------------------
If $ScriptFile_Out = "" Then
	$ScriptFile_Out = IniRead($ScriptFile_In & ".ini", "Autoit", "outfile", "")
	$ScriptFile_Out_Type = IniRead($ScriptFile_In & ".ini", "Autoit", "outfile_type", "")
Else
	$ScriptFile_Out_Type = StringRight($ScriptFile_Out, 3)
EndIf
If $INP_Icon = "" Then
	$INP_Icon = IniRead($ScriptFile_In & ".ini", "Autoit", "icon", "")
	$DebugIcon = $DebugIcon & "INI icon: " & $INP_Icon & @CRLF
EndIf
; Retrieve Script defaults from its previous saved INI file
If FileExists($ScriptFile_In & ".ini") Then
	If MsgBox(262144 + 4096 + 4, "AutoIt3Wrappper", "Found INI file containing OLD AutoIt3Wrapper information." & @LF & _
			"Do you want to updated your script with the appropriate #Directives and Recycle the INI ?", 10) = 6 Then
		Convert_RES_INI_to_Directives()
	EndIf
	If $INP_Compression = "" Then $INP_Compression = IniRead($ScriptFile_In & ".ini", "Autoit", "Compression", "")
;~ 	If $INP_PassPhrase = "" Then $INP_PassPhrase = IniRead($ScriptFile_In & ".ini", "Autoit", "PassPhrase", "")
;~ 	If $INP_PassPhrase2 = "" Then $INP_PassPhrase2 = IniRead($ScriptFile_In & ".ini", "Autoit", "PassPhrase", "")
;~ 	If $INP_Allow_Decompile = "" Then $INP_Allow_Decompile = IniRead($ScriptFile_In & ".ini", "Autoit", "Allow_Decompile", "")
	If $INP_UseUpx = "" Then $INP_UseUpx = IniRead($ScriptFile_In & ".ini", "Autoit", "UseUpx", "")
;~ 	If $INP_UseAnsi = "" Then $INP_UseAnsi = IniRead($ScriptFile_In & ".ini", "Autoit", "UseAnsi", "")
	If $INP_UseX64 = "" Then $INP_UseX64 = IniRead($ScriptFile_In & ".ini", "Autoit", "Usex64", "")
	$INP_Comment = IniRead($ScriptFile_In & ".ini", "Res", "Comment", "")
	$INP_Description = IniRead($ScriptFile_In & ".ini", "Res", "Description", "")
	$INP_Fileversion = IniRead($ScriptFile_In & ".ini", "Res", "Fileversion", "")
	$INP_Fileversion_AutoIncrement = IniRead($ScriptFile_In & ".ini", "Res", "Fileversion_AutoIncrement", "")
	$INP_ProductVersion = IniRead($ScriptFile_In & ".ini", "Res", "ProductVersion", "")
	$INP_LegalCopyright = IniRead($ScriptFile_In & ".ini", "Res", "LegalCopyright", "")
	$INP_Res_SaveSource = IniRead($ScriptFile_In & ".ini", "Res", "SaveSource", "")
	$INP_FieldName1 = IniRead($ScriptFile_In & ".ini", "Res", "Field1Name", "")
	$INP_FieldValue1 = IniRead($ScriptFile_In & ".ini", "Res", "Field1Value", "")
	$INP_FieldName2 = IniRead($ScriptFile_In & ".ini", "Res", "Field2Name", "")
	$INP_FieldValue2 = IniRead($ScriptFile_In & ".ini", "Res", "Field2Value", "")
	$INP_Run_AU3Check = IniRead($ScriptFile_In & ".ini", "Other", "Run_AU3Check", "")
	$INP_AU3Check_Stop_OnWarning = IniRead($ScriptFile_In & ".ini", "Other", "AU3Check_Stop_OnWarning", "")
	$INP_AU3Check_Parameters = IniRead($ScriptFile_In & ".ini", "Other", "AU3Check_Parameter", "")
	$INP_Run_Before = IniRead($ScriptFile_In & ".ini", "Other", "Run_Before", "")
	$INP_Run_After = IniRead($ScriptFile_In & ".ini", "Other", "Run_After", "")
	$INP_Run_cvsWrapper = IniRead($ScriptFile_In & ".ini", "Other", "Run_cvsWrapper", "")
	$INP_cvsWrapper_Parameters = IniRead($ScriptFile_In & ".ini", "Other", "cvsWrapper_Parameter", "")
	$INP_Change2CUI = IniRead($ScriptFile_In & ".ini", "Other", "Change2CUI", "")
EndIf
;Retrieve AutoIt3Wrapper Defaults from AutoIt3Wrapper.INI
If $ScriptFile_Out_Type = "" Then $ScriptFile_Out_Type = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Autoit", "outfile_type", "")
If $INP_Icon = "" Then $INP_Icon = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Autoit", "icon", "")
If $INP_Compression = "" Then $INP_Compression = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Autoit", "Compression", "")
;~ If $INP_PassPhrase = "" Then $INP_PassPhrase = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Autoit", "PassPhrase", "")
;~ If $INP_PassPhrase2 = "" Then $INP_PassPhrase2 = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Autoit", "PassPhrase", "")
;~ If $INP_Allow_Decompile = "" Then $INP_Allow_Decompile = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Autoit", "Allow_Decompile", "")
If $INP_UseUpx = "" Then $INP_UseUpx = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Autoit", "UseUpx", "")
;~ If $INP_UseAnsi = "" Then $INP_UseAnsi = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Autoit", "UseAnsi", "")
If $INP_UseX64 = "" Then $INP_UseX64 = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Autoit", "UseX64", "")
If $INP_AutoitDir = "" Then $AUT2EXE_PGM = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Autoit", "aut2exe", "")
If $INP_Res_Language = "" Then $INP_Res_Language = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Res", "Language", "")
If $INP_RES_requestedExecutionLevel = "" Then $INP_RES_requestedExecutionLevel = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Res", "RequestedExecutionLevel", "")
If $INP_RES_HiDpi = "" Then $INP_RES_HiDpi = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Res", "HiDpi", "")
If $INP_RES_Compatibility = "" Then $INP_RES_Compatibility = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Res", "Compatibility", "")
If $INP_Comment = "" Then $INP_Comment = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Res", "Comment", "")
If $INP_Description = "" Then $INP_Description = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Res", "Description", "")
If $INP_Fileversion = "" Then $INP_Fileversion = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Res", "Fileversion", "")
If $INP_Fileversion_AutoIncrement = "" Then $INP_Fileversion_AutoIncrement = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Res", "Fileversion_AutoIncrement", "")
If $INP_ProductVersion = "" Then $INP_ProductVersion = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Res", "ProductVersion", "")
If $INP_LegalCopyright = "" Then $INP_LegalCopyright = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Res", "LegalCopyright", "")
If $INP_Res_SaveSource = "" Then $INP_Res_SaveSource = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Res", "SaveSource", "")
If $INP_FieldName1 = "" Then $INP_FieldName1 = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Res", "Field1Name", "")
If $INP_FieldValue1 = "" Then $INP_FieldValue1 = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Res", "Field1Value", "")
If $INP_FieldName2 = "" Then $INP_FieldName2 = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Res", "Field2Name", "")
If $INP_FieldValue2 = "" Then $INP_FieldValue2 = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Res", "Field2Value", "")
If $INP_Run_Tidy = "" Then $INP_Run_Tidy = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Other", "Run_Tidy", "")
If $INP_Tidy_Parameters = "" Then $INP_Tidy_Parameters = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Other", "Tidy_Parameter", "")
If $INP_Run_Obfuscator = "" Then $INP_Run_Obfuscator = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Other", "Run_Obfuscator", "")
If $INP_Obfuscator_Parameters = "" Then $INP_Obfuscator_Parameters = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Other", "Obfuscator_Parameters", "")
If $INP_Run_AU3Check = "" Then $INP_Run_AU3Check = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Other", "Run_AU3Check", "")
If $INP_AU3Check_Stop_OnWarning = "" Then $INP_AU3Check_Stop_OnWarning = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Other", "AU3Check_Stop_OnWarning", "")
If $INP_AU3Check_Parameters = "" Then $INP_AU3Check_Parameters = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Other", "AU3Check_Parameter", "")
If $INP_Run_Before = "" Then $INP_Run_Before = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Other", "Run_Before", "")
If $INP_Run_After = "" Then $INP_Run_After = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Other", "Run_After", "")
If $INP_Run_cvsWrapper = "" Then $INP_Run_cvsWrapper = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Other", "Run_cvsWrapper", "")
If $INP_cvsWrapper_Parameters = "" Then $INP_cvsWrapper_Parameters = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Other", "cvsWrapper_Parameter", "")
If $INP_Change2CUI = "" Then $INP_Change2CUI = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Other", "Change2CUI", "")
; Set Fields use to determine the extension
_PathSplit($ScriptFile_In, $dummy, $dummy, $dummy, $ScriptFile_In_Ext)
; Get Predefined settings from the Scriptfile itself. These will override all other settings
;-------------------------------------------------------------------------------------------
Retrieve_PreProcessor_Info()
; set proper defaults and translate/validate values
SetDefaults($INP_AutoIT3_Version, "Prod", "P=Prod;B=Beta", "Prod;Beta", 0)
SetDefaults($ScriptFile_Out_Type, "exe", "", "exe;a3x", 0)
If Not ($INP_AutoitDir = "") And FileExists($INP_AutoitDir & "\Autoit3.exe") Then $CurrentAutoIt_InstallDir = $INP_AutoitDir
;
If Not FileExists($CurrentAutoIt_InstallDir & "\Autoit3.exe") Then
	ConsoleWrite("! Unable to determine the location of the AutoIt3 program directory!" & @CRLF)
	Exit
EndIf
If $INP_AutoIT3_Version = "beta" And FileExists($CurrentAutoIt_InstallDir & "\beta\Autoit3.exe") Then
	$CurrentAutoIt_InstallDir &= "\beta"
EndIf
;
SetDefaults($INP_Compression, 2, "", "0;1;2;3;4", 1)
;~ SetDefaults($INP_Allow_Decompile, "y", "yes=y;no=n;1=y;0=n;4=n", "y;n", 0)
SetDefaults($INP_Compile_Both, "n", "yes=y;no=n;1=y;0=n;4=n", "y;n", 0, 0)
SetDefaults($INP_UseUpx, "y", "yes=y;no=n;1=y;0=n;4=n", "y;n", 0, 0)
;~ SetDefaults($INP_UseAnsi, "n", "yes=y;no=n;1=y;0=n;4=n", "y;n", 0, 0)
SetDefaults($INP_Compile_Both, "n", "yes=y;no=n;1=y;0=n;4=n", "y;n", 0, 0)
If @OSArch = "X86" Or StringInStr(RegRead("HKCR\AutoIt3Script\Shell\Run\Command", ""), "AutoIt3.exe") Then
	SetDefaults($INP_UseX64, "n", "auto=a;yes=y;no=n;1=y;0=n;4=n", "y;n", 0, 0)
Else
	SetDefaults($INP_UseX64, "y", "auto=a;yes=y;no=n;1=y;0=n;4=n", "y;n", 0, 0)
EndIf
SetDefaults($INP_Fileversion_AutoIncrement, "n", "prompt=p;yes=y;no=n;1=y;0=n;4=n", "y;n;p", 0, 0)
SetDefaults($INP_Run_AU3Check, "y", "yes=y;no=n;1=y;0=n;4=n", "y;n", 0, 0)
SetDefaults($INP_Run_Tidy, "n", "yes=y;no=n;1=y;0=n;4=n", "y;n", 0, 0)
SetDefaults($INP_Run_Obfuscator, "n", "yes=y;no=n;1=y;0=n;4=n", "y;n", 0, 0)
SetDefaults($INP_Run_cvsWrapper, "n", "yes=y;no=n;1=y;0=n;4=n", "y;n;v", 0, 0)
SetDefaults($INP_AU3Check_Stop_OnWarning, "n", "yes=y;no=n;1=y;0=n;4=n", "y;n", 0, 0)
SetDefaults($INP_Res_SaveSource, "n", "yes=y;no=n;1=y;0=n;4=n", "y;n", 0, 0)
SetDefaults($INP_Change2CUI, "n", "yes=y;no=n;1=y;0=n;4=n", "y;n", 0, 0)
SetDefaults($INP_Add_Constants, "n", "yes=y;no=n;1=y;0=n;4=n", "y;n", 0)
SetDefaults($INP_Tidy_Stop_OnError, "y", "yes=y;no=n;1=y;0=n;4=n", "y;n", 0)
SetDefaults($ShowGUI, 0, "yes=1;no=0;y=1;n=0", "0;1", 0)
SetDefaults($INP_Run_SciTE_Minimized, "n", "yes=y;no=n;1=y;0=n;4=n", "y;n", 0, 0)
SetDefaults($INP_Run_SciTE_OutputPane_Minimized, "n", "yes=y;no=n;1=y;0=n;4=n", "y;n", 0, 0)
; Show GUI when requested but only during Compile
If $ShowGUI And $Option = "Compile" And $InputFileIsUTF8 <> 9 Then GUI_Show()
;
If $ScriptFile_Out = StringRight($ScriptFile_In, StringLen($ScriptFile_In)) Then
	ConsoleWrite("- Cannot specify the same output filename as the inputfile: " & $ScriptFile_Out & " ==> Changing to default (scriptname.exe)." & @CRLF)
	$ScriptFile_Out = ""
EndIf
;
;Set default for x86 exe
If $ScriptFile_Out = "" Then
	If $ScriptFile_Out_Type <> "" Then
		$ScriptFile_Out = StringTrimRight($ScriptFile_In, StringLen($ScriptFile_In_Ext)) & '.' & $ScriptFile_Out_Type
	Else
		$ScriptFile_Out = StringTrimRight($ScriptFile_In, StringLen($ScriptFile_In_Ext)) & '.exe'
	EndIf
EndIf
$ScriptFile_Out = _PathFull($ScriptFile_Out)
; fix _PathFull() problem
If StringLeft($ScriptFile_Out, 3) = "\\\" Then $ScriptFile_Out = StringMid($ScriptFile_Out, 2)
;
; Set default for x64 exe
If $ScriptFile_Out_x64 = "" Then
	If $INP_Compile_Both = "y" Then
		$ScriptFile_Out_x64 = StringReplace($ScriptFile_Out, ".", "_x64.", -1)
	Else
		$ScriptFile_Out_x64 = $ScriptFile_Out
	EndIf
EndIf
$ScriptFile_Out_x64 = _PathFull($ScriptFile_Out_x64)
; fix _PathFull() problem
If StringLeft($ScriptFile_Out_x64, 3) = "\\\" Then $ScriptFile_Out_x64 = StringMid($ScriptFile_Out_x64, 2)
;
;
;If $INP_Icon <> "" Then $INP_Icon = _PathFull($INP_Icon)
; save current workdir for later use
$Save_Workdir = @WorkingDir
; retrieve aut3exe directory
;-------------------------------------------------------------------------------------------
If $Option = "Compile" Then
	If $AUT2EXE_PGM <> "" And FileExists($AUT2EXE_PGM) Then
		; support old override for AUT2EXE
	ElseIf $CurrentAutoIt_InstallDir <> "" And FileExists($CurrentAutoIt_InstallDir & "\aut2exe\aut2exe.exe") Then
		If @OSArch <> "x86" And FileExists($CurrentAutoIt_InstallDir & "\aut2exe\aut2exe_x64.exe") And StringInStr(RegRead("HKCR\AutoIt3Script\Shell\Compile\Command", ""), "aut2exe_x64.exe") Then
			$AUT2EXE_PGM = $CurrentAutoIt_InstallDir & "\aut2exe\aut2exe_x64.exe"
		Else
			$AUT2EXE_PGM = $CurrentAutoIt_InstallDir & "\aut2exe\aut2exe.exe"
		EndIf
	Else
		If @OSArch <> "x86" And FileExists($CurrentAutoIt_InstallDir & "\aut2exe\aut2exe_x64.exe") And StringInStr(RegRead("HKCR\AutoIt3Script\Shell\Compile\Command", ""), "aut2exe_x64.exe") Then
			$AUT2EXE_PGM = $CurrentAutoIt_InstallDir & "\aut2exe\aut2exe_x64.exe"
		Else
			$AUT2EXE_PGM = $CurrentAutoIt_InstallDir & '\aut2exe\Aut2Exe.exe'
		EndIf
	EndIf
	$AUT2EXE_DIR = StringLeft($AUT2EXE_PGM, StringInStr($AUT2EXE_PGM, "\", 0, -1))
	; check if aut2exe.exe files are all there
	;-------------------------------------------------------------------------------------------
	$AUT2EXE_PGM_N = ""
	; ensure the drive letter in part of the path to aut2exe
	; this is needed when aut2exe is specified as: "#AutoIt3Wrapper_AUT2EXE=\winutil\AutoIt3\Au3beta\aut2exe.exe"
	If FileExists($AUT2EXE_PGM) Then
		FileChangeDir($AUT2EXE_DIR)
		$AUT2EXE_DIR = @WorkingDir
		FileChangeDir($Save_Workdir)
	Else
		; Prompt for the location of AUT2EXE
		While (Not FileExists($AUT2EXE_PGM)) Or (Not FileExists($AUT2EXE_DIR & "\AutoItSC.bin")) Or (Not FileExists($AUT2EXE_DIR & "\upx.exe"))
			If $AUT2EXE_PGM_N <> "" Then
				$msg = ""
				If Not FileExists($AUT2EXE_PGM) Then $msg = $AUT2EXE_PGM & " doesn exist." & @LF
				If Not FileExists($AUT2EXE_DIR & "\AutoItSC.bin") Then $msg = $AUT2EXE_DIR & "\AutoItSC.bin" & " doesn't exist." & @LF
				If Not FileExists($AUT2EXE_DIR & "\upx.exe") Then $msg = $AUT2EXE_DIR & "\upx.exe" & " doesn't exist." & @LF
				MsgBox(4096, "Error.", $msg)
			EndIf
			$AUT2EXE_PGM_N = FileOpenDialog("Select the correct directory with AUT2EXE,AutoItSC.bin and upx.exe ", $AUT2EXE_PGM, "aut2exe(*.*)", 1)
			If @error = 1 Then
				$rc = MsgBox(4100, "Autoit3 Compile", "do you want to stop the process?")
				If $rc = 6 Then Exit
			EndIf
			$AUT2EXE_DIR = StringLeft($AUT2EXE_PGM_N, StringInStr($AUT2EXE_PGM_N, "\", 0, -1) - 1)
			$AUT2EXE_PGM = $AUT2EXE_DIR & "\Aut2Exe.exe"
			;If FileExists($AUT2EXE_PGM) Then
			;	RegWrite('HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\Aut2Exe.exe', '', "REG_SZ", $AUT2EXE_PGM)
			;EndIf
		WEnd
	EndIf
	;get aut2exe fileversion
	;-------------------------------------------------------------------------------------------
	$AUT2EXE_PGM_VER = FileGetVersion($AUT2EXE_DIR & "\AutoitSC.bin")
	$LSCRIPTDIR = StringLeft($ScriptFile_In, StringInStr($ScriptFile_In, "\", 0, -1))
	; when just a file name is supplied it assumed it's in the scriptdirectory or Autoit ICO dir
	$AutoIt_Icon = RegRead("HKCR\AutoIt3Script\DefaultIcon", "")
	; When an ICON is specified in an INI/Commandline/Compiler directive it will check it here
	If $INP_Icon <> "" Then
		If Not StringInStr($INP_Icon, "\") Then
			$INP_Icon_Temp = $LSCRIPTDIR & $INP_Icon
			; check the scriptdir for the ICO file
			If Not FileExists($INP_Icon_Temp) Or StringInStr(FileGetAttrib($INP_Icon_Temp), "D") Then
				$AutoIt_Icon_Dir = StringLeft($AutoIt_Icon, StringInStr($AutoIt_Icon, "\", 0, -1))
				$INP_Icon_Temp = $AutoIt_Icon_Dir & $INP_Icon
				; check the Autoit ICON dir for the ICO file
				If FileExists($INP_Icon_Temp) And StringInStr(FileGetAttrib($INP_Icon_Temp), "D") = 0 Then
					$INP_Icon = $INP_Icon_Temp
				Else
					If Not (StringRight($ScriptFile_Out, 4) = ".a3x") Then ConsoleWrite("- Icon not found:  " & $INP_Icon & " ==> Changing to default ICON." & @CRLF)
					$INP_Icon = ""
				EndIf
			Else
				$INP_Icon = $INP_Icon_Temp
			EndIf
		Else
			If Not FileExists($INP_Icon) Then
				ConsoleWrite("- Icon not found: " & $INP_Icon & " ==> Changing to default ICON." & @CRLF)
				$INP_Icon = ""
			EndIf
			If StringInStr(FileGetAttrib($INP_Icon), "D") Then
				ConsoleWrite("- Icon is a Directory: " & $INP_Icon & " ==> Changing to default ICON." & @CRLF)
				$INP_Icon = ""
			EndIf
		EndIf
	EndIf
	; when icon is not specified then check if the lasticon used is valid
	If $INP_Icon = "" Then
		$INP_Icon = RegRead($Registry & "\Aut2exe", "LastIcon")
		; When LastIcon doesnt exists then use Default Icon
		If $INP_Icon <> "" And Not FileExists($INP_Icon) Then
			ConsoleWrite("- LastUsed Icon not found: " & $INP_Icon & " ==> Changing to default ICON:" & $AutoIt_Icon & @CRLF)
			$INP_Icon = $AutoIt_Icon
		EndIf
	EndIf
	;
	; determine if the release is higher than 101..  if so then add this to the possible parameter list
	If $AUT2EXE_PGM_VER > '3.0.101.0' Then
		$V_Arg = $V_Arg & "    /nodecompile " & @CRLF
	EndIf
;~ 	;-------------------------------------------------------------------------------------------
;~ 	; prepare all variables for the commandline programs and AUT2EXE
;~ 	;-------------------------------------------------------------------------------------------
;~ 	If $INP_Run_Obfuscator = "y" Then
;~ 		$s_CMDLine = ' /in "' & StringTrimRight($ScriptFile_In, StringLen($ScriptFile_In_Ext)) & '_Obfuscated' & $ScriptFile_In_Ext & '"'
;~ 		If $ScriptFile_Out = "" Then $ScriptFile_Out = StringTrimRight($ScriptFile_In, StringLen($ScriptFile_In_Ext)) & '.exe'
;~ 	Else
;~ 		$s_CMDLine = ' /in "' & $ScriptFile_In & '"'
;~ 	EndIf
;~ 	If $ScriptFile_Out <> "" Then
;~ 		; Check it the target directory is valid
;~ 		$ScriptFile_Out = StringReplace($ScriptFile_Out, "/", "\")
;~ 		If StringInStr($ScriptFile_Out, "\", 0, -1) And Not FileExists(StringLeft($ScriptFile_Out, StringInStr($ScriptFile_Out, "\", 0, -1) - 1)) Then
;~ 			;$s_CMDLine = $s_CMDLine & ' /out "' & $ScriptFile_Out & '"'
;~ 			ConsoleWrite("- Output path: " & StringLeft($ScriptFile_Out, StringInStr($ScriptFile_Out, "\", 0, -1) - 1) & " not found, changing it to:")
;~ 			$ScriptFile_Out = StringTrimRight($ScriptFile_In, StringLen($ScriptFile_In_Ext)) & '.exe'
;~ 			ConsoleWrite($ScriptFile_Out & @CRLF)
;~ 		EndIf
;~ 		$s_CMDLine &= ' /out "' & $ScriptFile_Out & '"'
;~ 	EndIf
;~ 	If $ScriptFile_In = $ScriptFile_Out Then
;~ 		ConsoleWrite("! Input source file should never be equal to the target output file !" & @CRLF)
;~ 		Exit
;~ 	EndIf
;~ 	; we handle resources and UPX later, so no packing from compiler
;~ 	$s_CMDLine &= ' /nopack'
;~ 	;
;~ 	If $INP_Icon <> "" Then $s_CMDLine &= ' /icon "' & $INP_Icon & '"'
;~ 	If $INP_Compression > -1 And $INP_Compression < 5 Then $s_CMDLine &= ' /comp ' & $INP_Compression & ''
	; When the info doesn't come from preprocessor statements then,
	; Show progress bar
	$ProcessBar_Title = "(" & $VERSION & ") Processing : " & StringTrimLeft($ScriptFile_In, StringInStr($ScriptFile_In, "\", 0, -1))
	ProgressOn($ProcessBar_Title, "Compile", "Starting", 50, 10, 18)
	; run process defined to be run before the compile process
	$INP_Run_Before = StringSplit($INP_Run_Before, "|")
	For $x = 1 To $INP_Run_Before[0]
		If StringStripWS($INP_Run_Before[$x], 3) <> "" Then
			ProgressSet(95, "Running :" & $INP_Run_Before[$x])
			; translate possible %..% to the actual values
			$INP_Run_Before[$x] = Convert_Variables($INP_Run_Before[$x])
			ConsoleWrite("> Running:" & $INP_Run_Before[$x] & @CRLF)
			$rc = Run(@ComSpec & ' /C ' & $INP_Run_Before[$x] & '', '', @SW_HIDE, 2)
			ShowStdOutErr($rc)
			;$RC = RunWait($INP_Run_Before)
		EndIf
	Next
	;
	WinActivate($ProcessBar_Title)
ElseIf $Option = "AU3Check" Then
	$INP_Run_AU3Check = "y"
Else ; $Option = "Run"
	$ProcessBar_Title = "(" & $VERSION & ") Processing : " & StringTrimLeft($ScriptFile_In, StringInStr($ScriptFile_In, "\", 0, -1))
	; set AutoIt3.Exe to the Autoit3dir specified on the commandline when supplied
	If $AutoIT3_PGM <> "" Then
		; use the autoit3.exe defined by the #autoit3wrapper_autoit3 directive
	ElseIf $CurrentAutoIt_InstallDir <> "" And FileExists($CurrentAutoIt_InstallDir & "\autoit3.exe") Then
		If @OSArch <> "x86" And $INP_UseX64 = "y" And FileExists($CurrentAutoIt_InstallDir & "\autoit3_x64.exe") Then
			$AutoIT3_PGM = $CurrentAutoIt_InstallDir & "\autoit3_x64.exe"
		Else
			$AutoIT3_PGM = $CurrentAutoIt_InstallDir & "\autoit3.exe"
		EndIf
	Else
		If @OSArch <> "x86" And $INP_UseX64 = "y" And FileExists($CurrentAutoIt_InstallDir & "\autoit3_x64.exe") Then
			$AutoIT3_PGM = $CurrentAutoIt_InstallDir & "\autoit3_x64.exe"
		Else
			$AutoIT3_PGM = $CurrentAutoIt_InstallDir & '\autoit3.exe'
		EndIf
	EndIf
	; Check if AutoIt3 really exists
	If Not FileExists($AutoIT3_PGM) Then
		ConsoleWrite('!>Error: program "' & $AutoIT3_PGM & '" is missing. Check your installation.' & @CRLF)
		Exit 999
	EndIf
EndIf
#endregion Input retrieval/validation
#region Fix Includes
If $INP_Add_Constants = "y" Then Add_Constants()
#endregion Fix Includes
#region Run Tidy
; Run Tidy when requested.
If Not ($Option = "AU3Check") And $INP_Run_Tidy = "y" Then
	If $InputFileIsUTF16 Or $InputFileIsUTF32 Then
;~ 		ConsoleWrite("! *************************************************************************************" & @CRLF)
		ConsoleWrite("! Input file is UTF" & $UTFtype & " encoded. Tidy does not support this and will be skipped." & @CRLF)
;~ 		ConsoleWrite("! *************************************************************************************" & @CRLF)
	Else
		Global $TidypgmVer = ""
		Global $Tidypgm = $SciTE_Dir & "\tidy\Tidy.exe"
		Global $Tidypgmdir
		If FileExists($Tidypgm) Then
			$Tidypgmdir = $SciTE_Dir & "\tidy"
			$TidypgmVer = FileGetVersion($Tidypgm)
			If $TidypgmVer = "0.0.0.0" Then
				$TidypgmVer = ""
			Else
				$TidypgmVer = "(" & $TidypgmVer & ")"
			EndIf
			ProgressSet(7, "Running Tidy ...")
			ConsoleWrite(">Running Tidy " & $TidypgmVer & "  from:" & $Tidypgmdir & @CRLF)
			;---- uses the Beta STDOUT fuunctionality ------------------------------------------
			;$Pid = Run(@ComSpec & ' /c ""' & $Tidypgm & '" "' & $ScriptFile_In & '""', '', @SW_HIDE, 2)
			$Pid = Run('"' & $Tidypgm & '" "' & $ScriptFile_In & '" /q', '', @SW_HIDE, $STDOUT_CHILD + $STDERR_CHILD)
			$Handle = _ProcessExitCode($Pid)
			$Return_Text = ShowStdOutErr($Pid)
			$ExitCode = _ProcessExitCode($Pid, $Handle)
			_ProcessCloseHandle($Handle)
			StdioClose($Pid)
			; Show the Errors in a MSGBox
			If $ExitCode > 0 Then
				;ConsoleWrite(">Tidy Ended with Error(s). rc:" & $exitcode & @crlf)
				Write_RC_Console_Msg("Tidy ended.", $ExitCode)
				If $Option <> "Tidy" And ProcessExists("SciTe.exe") Then
					If $INP_Tidy_Stop_OnError <> "y" And StringInStr($Return_Text, " - 0 error(s)") > 0 Then
					Else
						Show_Warnings("Tidy errors", StringReplace($Return_Text, @CR, ""))
					EndIf
				EndIf
			Else
				;ConsoleWrite(">Tidy Ended. No Error(s).   rc:" & $exitcode & @crlf)
				Write_RC_Console_Msg("Tidy ended.", $ExitCode)
			EndIf
		Else
			ConsoleWrite("! *** Tidy Error: *** Skipping Tidy: " & $Tidypgm & " Not Found !" & @CRLF & @CRLF)
		EndIf
	EndIf
EndIf
#endregion Run Tidy
#region Run AU3Check
; Run AU3Check when requested.
;If Not $InputFileIsUTF16 And ($INP_Run_AU3Check = "y" Or $INP_Run_AU3Check = 1) Then
Global $Au3Check_UTF = False, $TempScript
If $INP_Run_AU3Check = "y" Then
	; copy the UTF encode file to a ANSI version for processing by AU3Check
	If $InputFileIsUTF8 Or $InputFileIsUTF16 Or $InputFileIsUTF32 Then
		$Au3Check_UTF = True
		$TempScript = @TempDir & "\au3checkScript.au3"
		Global $h_Output = FileOpen($TempScript, 2)
		FileWrite($h_Output, FileRead($ScriptFile_In))
		FileClose($h_Output)
	EndIf
	; New INclude logic with au3check in the AutoIT directory
	Global $Au3checkpgmVer = ""
	Global $Au3checkpgmdir
	Global $Au3checkpgm = $CurrentAutoIt_InstallDir & "\au3check.exe"
	If FileExists($Au3checkpgm) Then
		$Au3checkpgmdir = $CurrentAutoIt_InstallDir
		$Au3checkpgmVer = FileGetVersion($Au3checkpgm)
		If $Au3checkpgmVer = "0.0.0.0" Then
			$Au3checkpgmVer = ""
		Else
			$Au3checkpgmVer = "(" & $Au3checkpgmVer & ")"
		EndIf
		;		ProgressSet(5, "Running AU3Check ...")
		$TempFile = @TempDir & '\au3check.log'
		;FileDelete($TempFile)
		; If PlugIn functions are specified then add that to the temp au3Check.dat
		If $INP_Plugin <> "" Then
			If FileCopy($Au3checkpgmdir & "\au3check.dat", @TempDir & "\au3check.dat", 1) Then
				$INP_Plugin = StringSplit($INP_Plugin, ",")
				For $x = 1 To $INP_Plugin[0]
					FileWriteLine($Au3checkpgmdir & "\au3check.dat", "!" & StringStripWS($INP_Plugin[$x], 3) & " 0 99")
				Next
			Else
				ConsoleWrite("+> Unable to add PlugIn functions to the Au3Check tables" & @LF)
				$INP_Plugin = ""
			EndIf
		EndIf
		If $INP_AU3Check_Parameters <> "" Then
			ConsoleWrite(">Running AU3Check " & $Au3checkpgmVer & "  params:" & $INP_AU3Check_Parameters & "  from:" & $Au3checkpgmdir & @CRLF)
		Else
			ConsoleWrite(">Running AU3Check " & $Au3checkpgmVer & "  from:" & $Au3checkpgmdir & @CRLF)
		EndIf
		; Process the TEMPFILE in case of an UTF encoded file
		If $InputFileIsUTF8 Or $InputFileIsUTF16 Or $InputFileIsUTF32 Then
			$Pid = Run('"' & $Au3checkpgm & '" ' & $INP_AU3Check_Parameters & ' -q "' & $TempScript & '"', '', @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
		Else
			$Pid = Run('"' & $Au3checkpgm & '" ' & $INP_AU3Check_Parameters & ' -q "' & $ScriptFile_In & '"', '', @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
		EndIf
;~ 		$Pid = Run('"' & $Au3checkpgm & '" ' & $INP_AU3Check_Parameters & ' "' & $ScriptFile_In & '"', '', @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
		$Handle = _ProcessExitCode($Pid)
		; Replace the TEMPFILE name with Original Script file name when UNICODE
		If $InputFileIsUTF8 Or $InputFileIsUTF16 Or $InputFileIsUTF32 Then
			$Return_Text = ShowStdOutErr($Pid, 1, $TempScript, $ScriptFile_In)
		Else
			$Return_Text = ShowStdOutErr($Pid)
		EndIf
		$ExitCode = _ProcessExitCode($Pid, $Handle)
		_ProcessCloseHandle($Handle)
		StdioClose($Pid)
		If $INP_Plugin <> "" Then
			FileMove(@TempDir & "\au3check.dat", $Au3checkpgmdir & "\au3check.dat", 1)
		EndIf
		; Show the Errors in a MSGBox
		If $Return_Text <> "" Then
			;ConsoleWrite(">AU3Check Ended with Error(s). rc:" & $exitcode & @crlf)
			Write_RC_Console_Msg("AU3Check ended.", $ExitCode)
			If $Option <> "AU3Check" And ProcessExists("SciTe.exe") Then
				If $INP_AU3Check_Stop_OnWarning <> "y" And StringInStr($Return_Text, " - 0 error(s)") > 0 Then
				Else
					Show_Warnings("Au3Check errors", StringReplace($Return_Text, @CR, ""))
				EndIf
			EndIf
		Else
			;ConsoleWrite(">AU3Check Ended. No Error(s).   rc:" & $exitcode & @crlf)
			Write_RC_Console_Msg("AU3Check ended.", $ExitCode)
		EndIf
		;
	Else
		;ConsoleWrite("*** AU3CHECK (1) : ERROR: *** Skipping AU3Check: " & $Au3checkpgm & " Not Found !" & @crlf & @crlf)
		ConsoleWrite("! *** AU3CHECK Error: *** Skipping AU3Check: " & $Au3checkpgm & " Not Found !" & @CRLF & @CRLF)
	EndIf
	FileDelete($TempFile)
EndIf
; if AU3Check parameter was specified than stop the process.
If $Option = "AU3Check" Then Exit
#endregion Run AU3Check
#region Run Obfuscator
; Run Obfuscator when requested.
If $Option = "Compile" And $INP_Run_Obfuscator = "y" Then
	If $InputFileIsUTF8 Or $InputFileIsUTF16 Or $InputFileIsUTF32 Then
;~ 		ConsoleWrite("! *************************************************************************************" & @CRLF)
		ConsoleWrite("! Input file is UTF" & $UTFtype & " encoded. Obfuscator does not support this and will be skipped." & @CRLF)
;~ 		ConsoleWrite("! *************************************************************************************" & @CRLF)
	Else
		Global $ObfuscatorpgmVer = ""
		Global $Obfuscatorpgm = $SciTE_Dir & "\Obfuscator\Obfuscator.exe"
		Global $Obfuscatorpgmdir
		If FileExists($Obfuscatorpgm) Then
			$Obfuscatorpgmdir = $SciTE_Dir & "\Obfuscator"
			$ObfuscatorpgmVer = FileGetVersion($Obfuscatorpgm)
			If $ObfuscatorpgmVer = "0.0.0.0" Then
				$ObfuscatorpgmVer = ""
			Else
				$ObfuscatorpgmVer = "(" & $ObfuscatorpgmVer & ")"
			EndIf
			ProgressSet(7, "Running Obfuscator ...")
			ConsoleWrite(">Running Obfuscator " & $ObfuscatorpgmVer & "  from:" & $Obfuscatorpgmdir & " cmdline:" & $ObfuscatorCmdLine & @CRLF)
			$Pid = Run('"' & $Obfuscatorpgm & '" "' & $ScriptFile_In & '" ' & $ObfuscatorCmdLine, '', @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
			$Handle = _ProcessExitCode($Pid)
			$Return_Text = ShowStdOutErr($Pid)
			$ExitCode = _ProcessExitCode($Pid, $Handle)
			_ProcessCloseHandle($Handle)
			StdioClose($Pid)
			; Show the Errors in a MSGBox
;~ 		Write_RC_Console_Msg("Obfuscator ended.", $ExitCode)
			;
			$ScriptFile_In_Obfuscated = StringTrimRight($ScriptFile_In, StringLen($ScriptFile_In_Ext)) & '_Obfuscated' & $ScriptFile_In_Ext
			;
			If $ExitCode > 0 And $ExitCode < 999 Then
				;There were warnings ...   show msbox to make sure they know what they are doing.
				Show_Warnings("Obfuscator Warnings/Errors", StringReplace($Return_Text, @CR, ""))
				$ExitCode = 0
			ElseIf $ExitCode = 999 Then
				Write_RC_Console_Msg("Obfuscator ended with errors, using original scriptfile.", $ExitCode)
				FileCopy($ScriptFile_In, $ScriptFile_In_Obfuscated, 1)
			EndIf
			; change input file to the obfuscated file
			; Run au3check on the obfuscated source
			If $ExitCode < 999 And $INP_Run_AU3Check = "y" Then
				$TempFile = @TempDir & '\au3check.log'
				FileDelete($TempFile)
				If $INP_AU3Check_Parameters <> "" Then
					ConsoleWrite(">Running AU3Check for obfuscated file" & $Au3checkpgmVer & "  params:" & $INP_AU3Check_Parameters & "  from:" & $Au3checkpgmdir & @CRLF)
				Else
					ConsoleWrite(">Running AU3Check for obfuscated file" & $Au3checkpgmVer & "  from:" & $Au3checkpgmdir & @CRLF)
				EndIf
				;---- uses the Beta STDOUT fuunctionality ------------------------------------------
				$Pid = Run('"' & $Au3checkpgm & '" ' & $INP_AU3Check_Parameters & ' -q "' & $ScriptFile_In_Obfuscated & '"', '', @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
				$Handle = _ProcessExitCode($Pid)
				$Return_Text = ShowStdOutErr($Pid)
				$ExitCode = _ProcessExitCode($Pid, $Handle)
				_ProcessCloseHandle($Handle)
				StdioClose($Pid)
				; Show the Errors in a MSGBox
				If $Return_Text <> "" Then
					;ConsoleWrite(">AU3Check Ended with Error(s). rc:" & $exitcode & @crlf)
					Write_RC_Console_Msg("AU3Check Obfuscated code ended.", $ExitCode)
					If $Option <> "AU3Check" And ProcessExists("SciTe.exe") Then
						If $INP_AU3Check_Stop_OnWarning <> "y" And StringInStr($Return_Text, " - 0 error(s)") > 0 Then
						Else
							Show_Warnings("Au3Check errors", StringReplace($Return_Text, @CR, ""))
						EndIf
					EndIf
				Else
					;ConsoleWrite(">AU3Check Ended. No Error(s).   rc:" & $exitcode & @crlf)
					Write_RC_Console_Msg("AU3Check Obfuscated code ended.", $ExitCode)
				EndIf
			EndIf
		Else
			ConsoleWrite("! *** Obfuscator Error: *** Skipping Obfuscator: " & $Obfuscatorpgm & " Not Found !" & @CRLF & @CRLF)
		EndIf
	EndIf
EndIf
#endregion Run Obfuscator
#region Compile the script
; If Compile is the option then
If $Option = "Compile" Then
	#region Run AUT2EXE/RESUPD/UPX
	;Use the explicit x86 or x64 outputfile when specified.
	If $INP_Compile_Both = "y" Or $INP_UseX64 = 'n' Then
		Compile_Run_AUT2EXE('x86', $ScriptFile_Out)
		If Compile_Upd_res($ScriptFile_Out) And $INP_UseUpx = "y" Then
			Compile_UPX($ScriptFile_Out)
		EndIf
		Write_RC_Console_Msg("Created program:" & $ScriptFile_Out, "", "+")
	EndIf
	If $INP_Compile_Both = "y" Or $INP_UseX64 <> 'n' Then
		Compile_Run_AUT2EXE('x64', $ScriptFile_Out_x64)
		Compile_Upd_res($ScriptFile_Out_x64)
		Write_RC_Console_Msg("Created program:" & $ScriptFile_Out_x64, "", "+")
	EndIf
	#endregion Run AUT2EXE/RESUPD/UPX
	#region Run cvsWrapper
	; Check if the Version needs updating
	If $INP_Fileversion_AutoIncrement = "p" Then
		If MsgBox(262144 + 4096 + 4, "AutoIt3Wrappper", "Do you want to increase the version number of the source to:" & @LF & $INP_Fileversion_New, 10) = 6 Then
			$INP_Fileversion_AutoIncrement = 'y'
		Else
			$INP_Fileversion_New = $INP_Fileversion
		EndIf
	EndIf
	; run cvsWrapper
	If $INP_Run_cvsWrapper = 'y' Or ($INP_Run_cvsWrapper = 'v' And $INP_Fileversion_AutoIncrement = 'y') Then
		If FileExists($SciTE_Dir & "\cvsWrapper\cvsWrapper.exe") Then
			ProgressSet(92, "Running cvsWrapper.")
			$INP_cvsWrapper_Parameters = Convert_Variables($INP_cvsWrapper_Parameters, 1)
			$Pid = Run('"' & $SciTE_Dir & '\cvsWrapper\cvsWrapper.exe" "' & $ScriptFile_In & '" ' & $INP_cvsWrapper_Parameters, "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
			$Handle = _ProcessExitCode($Pid)
			ShowStdOutErr($Pid)
			$ExitCode = _ProcessExitCode($Pid, $Handle)
			_ProcessCloseHandle($Handle)
			;ConsoleWrite(">Aut2exe.exe ended.  rc:" & $exitcode & @crlf)
			Write_RC_Console_Msg("cvsWrapper.exe ended.", $ExitCode)
		Else
			ConsoleWrite("- cvsWrapper program not found. skipping this step")
		EndIf
	EndIf
	#endregion Run cvsWrapper
	#region Run RunAfter Steps
	WinActivate($ProcessBar_Title)
	$INP_Run_After = StringSplit($INP_Run_After, "|")
	For $x = 1 To $INP_Run_After[0]
		If StringStripWS($INP_Run_After[$x], 3) <> "" Then
			ProgressSet(95, "Running :" & $INP_Run_After[$x])
			; translate possible %..% to the actual values
			$INP_Run_After[$x] = Convert_Variables($INP_Run_After[$x])
			ConsoleWrite(">Running:" & $INP_Run_After[$x] & @CRLF)
			$Pid = Run(@ComSpec & ' /C ' & $INP_Run_After[$x] & '', '', @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
			$Handle = _ProcessExitCode($Pid)
			ShowStdOutErr($Pid)
			$ExitCode = _ProcessExitCode($Pid, $Handle)
			_ProcessCloseHandle($Handle)
			ConsoleWrite(">" & $INP_Run_After[$x] & " Ended   rc:" & $ExitCode & @CRLF)
		EndIf
	Next
	#endregion Run RunAfter Steps
	#region Update FileVersion
	;
	; Increment the #Compiler_Res_Fileversion= value in the source file but only when not UTF8 wihtout BOM to avoid problems.
	;
	If $InputFileIsUTF16 = 9 Then
		ConsoleWrite("- Skipping Updated of the Source Version because this file is detected as UTF8 without BOM which could cause script corruption." & @CRLF)
	Else
		If $INP_Fileversion_AutoIncrement = 'y' Then
			If $INP_Fileversion = "" Then
				ConsoleWrite("- Failed to Updated the Source Version. The Source doesnt contain the #Compiler_Res_Fileversion directive." & @CRLF)
			Else
				If $INP_Fileversion_New <> "" Then
					$ToTalFile = @CRLF & FileRead($ScriptFile_In)
					;$ToTalFile = StringReplace($ToTalFile, $INP_Fileversion, $INP_Fileversion_New, 1)
					; added & chr(61) & to avoid replacing this statement when the version is updated
					$ToTalFile = StringRegExpReplace($ToTalFile, '(?i)' & @CRLF & '(\h*?)#AutoIt3Wrapper_Res_Fileversion(\h*?)=(.*?)' & @CRLF, @CRLF & '\1#AutoIt3Wrapper_Res_Fileversion=' & $INP_Fileversion_New & @CRLF)
					$H_Outf = FileOpen($ScriptFile_In, 2 + $SrceUnicodeFlag)
					FileWrite($H_Outf, StringMid($ToTalFile, 3))
					FileClose($H_Outf)
					ConsoleWrite(">Updated the Source Version to:" & $INP_Fileversion_New & "..." & @CRLF)
				EndIf
			EndIf
		EndIf
	EndIf
	#endregion Update FileVersion
EndIf
#endregion Compile the script
#region Run the Script
If $Option = "Run" Then
	ProgressOff()
	If Not FileExists($AutoIT3_PGM) Then
		ConsoleWrite('!>Error: program "' & $AutoIT3_PGM & '" is missing. Check your installation.' & @CRLF)
		Exit 999
	EndIf
	$s_CMDLine = StringReplace($s_CMDLine, "/ErrorStdOut", "")
	ConsoleWrite('>Running:(' & FileGetVersion($AutoIT3_PGM) & "):" & $AutoIT3_PGM & ' "' & $ScriptFile_In & '" ' & $s_CMDLine & @CRLF)
	;Add debug statements
	Global $sDebugFile = ""
	;
	If $INP_Run_SciTE_Minimized = "y" Then
		Global $SciTE_State = WinGetState("[CLASS:SciTEWindow]", "")
		WinSetState("[CLASS:SciTEWindow]", "", @SW_MINIMIZE)
	EndIf
	;
	If $INP_Run_SciTE_OutputPane_Minimized = "y" Then
		SendSciTE_Command($My_Hwnd, $SciTE_hwnd, "menucommand:409") ; IDM_TOGGLEOUTPUT
	EndIf
	;
	If $INP_Run_Debug_Mode Then
		ConsoleWrite('!> Starting in DebugMode..' & @CRLF)
		ConsoleWrite('Line: @error-@extended: Line syntax' & @CRLF)
		RunAutoItDebug($ScriptFile_In, $sDebugFile)
		; Run your script in debug mode
		$Pid = Run('"' & $AutoIT3_PGM & '" /ErrorStdOut "' & $sDebugFile & '" ' & $s_CMDLine, "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	Else
		; Run your script
		$Pid = Run('"' & $AutoIT3_PGM & '" /ErrorStdOut "' & $ScriptFile_In & '" ' & $s_CMDLine, "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	EndIf
	; Run second version as Watcher to kill this The running AutoItscript when AutoIt3Wrapper is killed.
	Global $CW = Run(@ScriptFullPath & " /Watcher " & @AutoItPID & " " & $Pid)
	;
	$Handle = _ProcessExitCode($Pid)
	ShowStdOutErr($Pid)
	$ExitCode = _ProcessExitCode($Pid, $Handle)
	_ProcessCloseHandle($Handle)
	;ConsoleWrite($pref & ">AutoIT3.exe ended.  rc:" & $exitcode & @crlf)
	Write_RC_Console_Msg("AutoIT3.exe ended.", $ExitCode)
	ProcessWaitClose($CW)
	If $INP_Run_Debug_Mode Then FileDelete($sDebugFile)
	;
	If $INP_Run_SciTE_Minimized = "y" Then
		WinSetState("[CLASS:SciTEWindow]", "", @SW_RESTORE)
	EndIf
	;
	Exit $ExitCode ; exit with the returncode of the run script
EndIf
#endregion Run the Script
#region End AutoIt3Wrapper
; End of the program
ProgressOff()
; Done
Exit
#endregion End AutoIt3Wrapper
#region Functions

Func _appendFileExtraData($fname, ByRef $extraData, ByRef $dwSize)
	Local $bytesWritten = 0
	If Not IsDllStruct($extraData) Or $dwSize = 0 Then Return SetError(1, 0, 0)
	Local $pextraData = DllStructGetPtr($extraData)

	Local $hFile = _WinAPI_CreateFile($fname, 2, 4) ; open for writing
	If Not $hFile Then Return SetError(2, 0, 0)

	Local $pos = _WinAPI_SetFilePointer($hFile, 0, 2) ; set pointer to end of file
	If @error Or $pos = -1 Then
		_WinAPI_CloseHandle($hFile)
		Return SetError(3, 0, 0)
	EndIf

	Local $ret = _WinAPI_WriteFile($hFile, $pextraData, $dwSize, $bytesWritten, 0) ; write the extra data
	_WinAPI_CloseHandle($hFile)
	$extraData = 0 ; release extra data

	If Not $ret Or $bytesWritten <> $dwSize Then Return SetError(4, 0, 0)
	Return 1
EndFunc   ;==>_appendFileExtraData
;Helper function to compare the Version dates
Func _Compare_Date_GT($date1, $Date2)
	Local $Id1 = StringSplit($date1, "/")
	Local $Id2 = StringSplit($Date2, "/")
	ReDim $Id1[4]
	ReDim $Id2[4]
	$date1 = $Id1[3] & "/" & $Id1[1] & "/" & $Id1[2]
	$Date2 = $Id2[3] & "/" & $Id2[1] & "/" & $Id2[2]
	If Not _DateIsValid($date1) Then Return 0
	If Not _DateIsValid($Date2) Then Return 0
	Return _DateDiff("d", $Date2, $date1)
EndFunc   ;==>_Compare_Date_GT

Func _EnumResourceNamesAndLangs($fname, $RType)
	; reset content of the Array
	Dim $g_aResNamesAndLangs[1][2] = [[0, 0]]
	; enumerate resource names and languages to a global array
	Local $RType_Type
	Local $aRESOURCE_TYPES[24] = ["RT_CURSOR", "RT_BITMAP", "RT_ICON", "RT_MENU", "RT_DIALOG", "RT_STRING", "RT_FONTDIR", "RT_FONT", "RT_ACCELERATOR", _
			"RT_RCDATA", "RT_MESSAGETABLE", "RT_GROUPCURSOR", "", "RT_GROUPICON", "", "RT_VERSION", "RT_DLGINCLUDE", "", "RT_PLUGPLAY", _
			"RT_VXD", "RT_ANICURSOR", "RT_ANIICON", "RT_HTML", "RT_MANIFEST"]
	; did we really get a number?
	If StringIsDigit($RType) Then $RType = Number($RType)
	; check for known resource types and convert to ordinal
	If IsString($RType) Then
		For $k = 0 To UBound($aRESOURCE_TYPES) - 1
			If $RType = $aRESOURCE_TYPES[$k] Then
				$RType = $k + 1
				$RType_Type = "long"
			EndIf
		Next
	EndIf
	; set parameter types
	If IsString($RType) Then
		$RType_Type = "wstr"
		$RType = StringUpper($RType)
	Else
		$RType_Type = "long"
	EndIf

	; load the file
	Local $hModule = _WinAPI_LoadLibraryEx($fname, 0x22) ; LOAD_LIBRARY_AS_DATAFILE|LOAD_LIBRARY_AS_IMAGE_RESOURCE
	If @error Then
		Local $terror = @error
		Local $textended = @extended
		Write_RC_Console_Msg("WinAPI_GetLastError:" & _WinAPI_GetLastError(), "", "!")
		Write_RC_Console_Msg("WinAPI_GetLastErrorMessage:" & _WinAPI_GetLastErrorMessage(), "", "!")
		Write_RC_Console_Msg("Error: Failed _WinAPI_LoadLibraryEx   error:" & $terror & "   extended:" & $textended, "", "!")
	EndIf
	If Not $hModule Then Return SetError(1, 0, 0)
	; register callbacks
	Local $hNameCallback = DllCallbackRegister("_ResNameCallback", "int", "ptr;ptr;ptr;long_ptr")
	$hLangCallback = DllCallbackRegister("_ResLangCallback", "int", "ptr;ptr;ptr;ushort;long_ptr")
	; enum the names
	DllCall("kernel32.dll", "int", "EnumResourceNamesW", "ptr", $hModule, $RType_Type, $RType, "ptr", DllCallbackGetPtr($hNameCallback), "long_ptr", 0)

	; free resources
	_WinAPI_FreeLibrary($hModule)
	DllCallbackFree($hNameCallback)
	DllCallbackFree($hLangCallback)

	Return 1
EndFunc   ;==>_EnumResourceNamesAndLangs

Func _FIELD_OFFSET(ByRef $s, $element)
	If (Not IsDllStruct($s)) Or (Not IsString($element)) Then Return SetError(1, 0, 0)
	Local $s_ptr = DllStructGetPtr($s, 1) ; ptr to first byte of struct
	If @error Then Return SetError(2, 0, 0)
	Local $f_ptr = DllStructGetPtr($s, $element) ; ptr to first byte of element
	If @error Then Return SetError(3, 0, 0)
	Return Number($f_ptr - $s_ptr) ; offset of element in struct
EndFunc   ;==>_FIELD_OFFSET

Func _GetBlockIDIdx(ByRef $aBlocks, $iBlock)
	Local $aBlock
	For $i = 1 To $aBlocks[0]
		$aBlock = $aBlocks[$i]
		If $aBlock[0] = $iBlock Then
			; found the block
			Return $i
		EndIf
	Next
	Return -1
EndFunc   ;==>_GetBlockIDIdx

Func _getFileExtraData($fname, ByRef $extraData, ByRef $dwSize)
	; get target file as binary struct
	Local $hFile = FileOpen($fname, 16)
	If $hFile = -1 Then Return SetError(1, 0, 0)
	Local $bin = FileRead($hFile)
	FileClose($hFile)
	Local $dataSize = BinaryLen($bin)
	Local $sdata = DllStructCreate("byte[" & $dataSize & "]")
	Local $data = DllStructGetPtr($sdata) ; ptr to data
	DllStructSetData($sdata, 1, $bin)

	; read the DOS header to make sure we have a valid file
	Local $dos_header = DllStructCreate($tagIMAGE_DOS_HEADER, $data)
	If DllStructGetData($dos_header, "emagic") <> $IMAGE_DOS_SIGNATURE Then
		ConsoleWrite("Not a valid executable file." & @CRLF)
		Return SetError(2, 0, 0)
	EndIf

	; parse sections to calculate real data size
	Local $endOfImage = 0
	Local $psec = _IMAGE_FIRST_SECTION(DllStructGetPtr($dos_header) + DllStructGetData($dos_header, "elfanew")) ; ptr to first section
	Local $section = DllStructCreate($tagIMAGE_SECTION_HEADER, $psec) ; SECTION header
	Local $headers = DllStructCreate($tagIMAGE_NT_HEADERS, DllStructGetPtr($dos_header) + DllStructGetData($dos_header, "elfanew")) ; NT header
	Local $pRawData, $sizeRawData

	; loop through sections to get the end of image
	For $i = 0 To DllStructGetData($headers, "NumberOfSections") - 1
		$pRawData = DllStructGetData($section, "PointerToRawData")
		$sizeRawData = DllStructGetData($section, "SizeOfRawData")
		If $endOfImage < ($pRawData + $sizeRawData) Then _
				$endOfImage = $pRawData + $sizeRawData
		; get next section
		$psec += DllStructGetSize($section)
		$section = DllStructCreate($tagIMAGE_SECTION_HEADER, $psec)
	Next

	; copy extra data
	If $dataSize > $endOfImage Then
		; for some reason, SizeOfImage has a value that doesn't work for us, so we us the binary data length
		$dwSize = $dataSize - $endOfImage
		$extraData = DllStructCreate("byte[" & $dwSize & "]")
		; ptr to end of image - extra data
		_memcpy(DllStructGetPtr($extraData), $data + $endOfImage, $dwSize)
	Else
		Return SetError(3, 0, 0)
	EndIf

	Return 1
EndFunc   ;==>_getFileExtraData

;; #define IMAGE_FIRST_SECTION( ntheader ) ((PIMAGE_SECTION_HEADER)       \
;;    ((ULONG_PTR)ntheader +                                              \
;;     FIELD_OFFSET( IMAGE_NT_HEADERS, OptionalHeader ) +                 \
;;     ((PIMAGE_NT_HEADERS)(ntheader))->FileHeader.SizeOfOptionalHeader   \
;;    ))
Func _IMAGE_FIRST_SECTION($h)
	Local $header = DllStructCreate($tagIMAGE_NT_HEADERS, $h)
	; _FIELD_OFFSET of OptionalHeader ('Magic' field) in IMAGE_NT_HEADERS stucture = 24
	Return ($h + _FIELD_OFFSET($header, "Magic") + DllStructGetData($header, "SizeOfOptionalHeader"))
EndFunc   ;==>_IMAGE_FIRST_SECTION

Func _memcpy($dest, $src, $size)
	Local $ret = DllCall("msvcrt.dll", "ptr:cdecl", "memcpy", "ptr", $dest, "ptr", $src, "uint", $size)
	Return $ret[0]
EndFunc   ;==>_memcpy
;
Func _ProcessCloseHandle($h_Process)
	; Close the process handle of a PID
	DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $h_Process)
	If Not @error Then Return 1
	Return 0
EndFunc   ;==>_ProcessCloseHandle
;===============================================================================
;
; Function Name:    _ProcessExitCode()
; Description:      Returns a handle/exitcode from use of Run().
; Parameter(s):     $i_Pid        - ProcessID returned from a Run() execution
;                   $h_Process    - Process handle
; Requirement(s):   None
; Return Value(s):  On Success - Returns Process handle while Run() is executing
;                                (use above directly after Run() line with only PID parameter)
;                              - Returns Process Exitcode when Process does not exist
;                                (use above with PID and Process Handle parameter returned from first UDF call)
;                   On Failure - 0
; Author(s):        MHz (Thanks to DaveF for posting these DllCalls in Support Forum)
;
;===============================================================================
;
Func _ProcessExitCode($i_Pid, $h_Process = 0)
	; 0 = Return Process Handle of PID else use Handle to Return Exitcode of a PID
	Local $v_Placeholder
	If Not IsArray($h_Process) Then
		; Return the process handle of a PID
		$h_Process = DllCall('kernel32.dll', 'ptr', 'OpenProcess', 'int', 0x400, 'int', 0, 'int', $i_Pid)
		If Not @error Then Return $h_Process
	Else
		; Return Process Exitcode of PID
		$h_Process = DllCall('kernel32.dll', 'ptr', 'GetExitCodeProcess', 'ptr', $h_Process[0], 'int*', $v_Placeholder)
		If Not @error Then Return $h_Process[2]
	EndIf
	Return 0
EndFunc   ;==>_ProcessExitCode
;
; Removes any dead icons from the notification area.
; Parameters:
;    $nDelay - IN/OPTIONAL - The delay to wait for the notification area to expand with Windows XP's
;        "Hide Inactive Icons" feature (In milliseconds).
; Returns:
;    Sets @error on failure:
;        1 - Tray couldn't be found.
;        2 - DllCall error.
; ===================================================================
Func _RefreshSystemTray($nDelay = 1000)
	; Save Opt settings
	Local $oldMatchMode = Opt("WinTitleMatchMode", 4)
	Local $oldChildMode = Opt("WinSearchChildren", 1)
	Local $error = 0
	Do; Pseudo loop
		Local $hWnd = WinGetHandle("classname=TrayNotifyWnd")
		If @error Then
			$error = 1
			ExitLoop
		EndIf

		Local $hControl = ControlGetHandle($hWnd, "", "Button1")

		; We're on XP and the Hide Inactive Icons button is there, so expand it
		If $hControl <> "" And ControlCommand($hWnd, "", $hControl, "IsVisible", "") Then
			ControlClick($hWnd, "", $hControl)
			Sleep($nDelay)
		EndIf

		Local $posStart = MouseGetPos()
		Local $posWin = WinGetPos($hWnd)

		Local $y = $posWin[1]
		While $y < $posWin[3] + $posWin[1]
			Local $x = $posWin[0]
			While $x < $posWin[2] + $posWin[0]
				DllCall("user32.dll", "int", "SetCursorPos", "int", $x, "int", $y)
				If @error Then
					$error = 2
					ExitLoop 3; Jump out of While/While/Do
				EndIf
				$x = $x + 8
			WEnd
			$y = $y + 8
		WEnd
		DllCall("user32.dll", "int", "SetCursorPos", "int", $posStart[0], "int", $posStart[1])
		; We're on XP so we need to hide the inactive icons again.
		If $hControl <> "" And ControlCommand($hWnd, "", $hControl, "IsVisible", "") Then
			ControlClick($hWnd, "", $hControl)
		EndIf
	Until 1

	; Restore Opt settings
	Opt("WinTitleMatchMode", $oldMatchMode)
	Opt("WinSearchChildren", $oldChildMode)
	SetError($error)
EndFunc   ;==>_RefreshSystemTray
;
;
Func _Res_Create_RTVersion_BuildStringTableEntry($Key, $value)
	Local $padding = 1 - Mod(6 + StringLen($Key) + 1, 2)
	Local $padding2 = 1 - Mod(6 + StringLen($Key) + 1 + $padding + StringLen($value) + 1, 2)
	Local $p_VS_String = DllStructCreate( _
			"short   wLength;" & _                                       ;Specifies the length, in bytes, of this String structure.
			"short   wValueLength;" & _                                  ;Specifies the size, in words, of the Value member.
			"short   wType;" & _                                         ;Specifies the type of data in the version resource. This member is 1 if the version resource contains text data and 0 if the version resource contains binary data.
			"wchar   szKey[" & StringLen($Key) + 1 + $padding & "];" & _ ;Specifies an arbitrary Unicode string. The szKey member can be one or more of the following values. These values are guidelines only.
			"wchar   Value[" & StringLen($value) + 1 + $padding2 & "]") ;Specifies a zero-terminated string. See the szKey member description for more information.
	DllStructSetData($p_VS_String, "Wlength", DllStructGetSize($p_VS_String) - $padding2 * 2)
	DllStructSetData($p_VS_String, "wValueLength", StringLen($value) + 1)
	DllStructSetData($p_VS_String, "wType", 1)
	DllStructSetData($p_VS_String, "szKey", $Key)
	DllStructSetData($p_VS_String, "Value", $value)
	Return StringMid(DllStructGetData(DllStructCreate("byte[" & DllStructGetSize($p_VS_String) & "]", DllStructGetPtr($p_VS_String)), 1), 3)
EndFunc   ;==>_Res_Create_RTVersion_BuildStringTableEntry
;
;
Func _Res_Create_RTVersion(ByRef $OutResPath)
	; construct the Stringtable Entries in a Binary string for easy concatenation
	Local $Res_StringTable_Children = "0x"
;~ 	$Res_StringTable_Children &= _Res_Create_RTVersion_BuildStringTableEntry("CompiledScript", $INP_CompiledScript)
	$Res_StringTable_Children &= _Res_Create_RTVersion_BuildStringTableEntry("FileVersion", $INP_Fileversion)
	If $INP_Comment <> "" Then $Res_StringTable_Children &= _Res_Create_RTVersion_BuildStringTableEntry("Comments", $INP_Comment)
	If $INP_Description <> "" Then $Res_StringTable_Children &= _Res_Create_RTVersion_BuildStringTableEntry("FileDescription", $INP_Description)
;~ 	If $INP_Description <> "" Then $Res_StringTable_Children &= _Res_Create_RTVersion_BuildStringTableEntry("ProductName", $INP_ProductName)
;~ 	If $INP_Description <> "" Then $Res_StringTable_Children &= _Res_Create_RTVersion_BuildStringTableEntry("ProductVersion", $INP_ProductVersion)
	If $INP_LegalCopyright <> "" Then $Res_StringTable_Children &= _Res_Create_RTVersion_BuildStringTableEntry("LegalCopyright", $INP_LegalCopyright)
	If $INP_FieldName1 & $INP_FieldValue1 <> "" Then $Res_StringTable_Children &= _Res_Create_RTVersion_BuildStringTableEntry($INP_FieldName1, $INP_FieldValue1)
	If $INP_FieldName2 & $INP_FieldValue2 <> "" Then $Res_StringTable_Children &= _Res_Create_RTVersion_BuildStringTableEntry($INP_FieldName2, $INP_FieldValue2)
	For $U = 1 To $INP_RES_FieldCount
		If $INP_FieldName[$U] <> "" And $INP_FieldValue[$U] <> "" Then
			$INP_FieldValue[$U] = Convert_Variables($INP_FieldValue[$U])
			$Res_StringTable_Children &= _Res_Create_RTVersion_BuildStringTableEntry($INP_FieldName[$U], $INP_FieldValue[$U])
		EndIf
	Next
	;
	; construct the Stringtable
	Local $p_VS_StringTable = DllStructCreate( _
			"short   wLength;" & _       ;Specifies the length, in bytes, of this StringTable structure, including all structures indicated by the Children member.
			"short   wValueLength;" & _  ;This member is always equal to zero.
			"short   wType;" & _         ;Specifies the type of data in the version resource. This member is 1 if the version resource contains text data and 0 if the version resource contains binary data.
			"byte    szKey[16];" & _     ;Specifies an 8-digit hexadecimal number stored as a Unicode string. The four most significant digits represent the language identifier. The four least significant digits represent the code page for which the data is formatted. Each Microsoft Standard Language identifier contains two parts: the low-order 10 bits specify the major language, and the high-order 6 bits specify the sublanguage. For a table of valid identifiers see .
			"byte    Padding[2];" & _    ;Contains as many zero words as necessary to align the Children member on a 32-bit boundary.
			"byte    Children[" & (StringLen($Res_StringTable_Children) - 2) / 2 & "]") ;Specifies an array of one or more String structures.
	DllStructSetData($p_VS_StringTable, "Wlength", DllStructGetSize($p_VS_StringTable))
	DllStructSetData($p_VS_StringTable, "wValueLength", 0)
	DllStructSetData($p_VS_StringTable, "wType", 1)
	DllStructSetData($p_VS_StringTable, "szKey", StringToBinary(Hex($INP_Res_Language, 4) & '04b0', 2))
	DllStructSetData($p_VS_StringTable, "Children", Binary($Res_StringTable_Children))
	;
	; construct the StringFileInfo
	Local $p_VS_StringFileInfo = DllStructCreate( _
			"short  wLength;" & _      ;Specifies the length, in bytes, of the entire StringFileInfo block, including all structures indicated by the Children member.
			"short  wValueLength;" & _ ;This member is always equal to zero.
			"short  wType;" & _        ;Specifies the type of data in the version resource. This member is 1 if the version resource contains text data and 0 if the version resource contains binary data.
			"WCHAR  szKey[15];" & _    ;Contains the Unicode string "StringFileInfo".
			"byte   Children[" & DllStructGetSize($p_VS_StringTable) & "]") ;Contains an array of one or mcore StringTable structures. Each StringTable structure's szKey member indicates the appropriate language and code page for displaying the text in that StringTable structure.
	DllStructSetData($p_VS_StringFileInfo, "Wlength", DllStructGetSize($p_VS_StringFileInfo))
	DllStructSetData($p_VS_StringFileInfo, "wValueLength", 0)
	DllStructSetData($p_VS_StringFileInfo, "wType", 1)
	DllStructSetData($p_VS_StringFileInfo, "szKey", "StringFileInfo")
	Local $p_VS_StringTable_Total = DllStructCreate("byte Children[" & DllStructGetSize($p_VS_StringTable) & "]", DllStructGetPtr($p_VS_StringTable))
	DllStructSetData($p_VS_StringFileInfo, "Children", DllStructGetData($p_VS_StringTable_Total, 1))
	;
	; construct the Var
	Local $p_VS_Var = DllStructCreate( _
			"short  wLength;" & _       ;Specifies the length, in bytes, of the Var structure.
			"short  wValueLength;" & _  ;Specifies the length, in bytes, of the Value member.
			"short  wType;" & _         ;Specifies the type of data in the version resource. This member is 1 if the version resource contains text data and 0 if the version resource contains binary data.
			"WCHAR  szKey[12];" & _     ;Contains the Unicode string "Translation".
			"char  Padding[1];" & _     ;Contains as many zero words as necessary to align the Value member on a 32-bit boundary.
			"short  lang;" & _          ;Specifies an array of one or more values that are language and code page identifier pairs. For additional information, see the following Remarks section.
			"short  lang2") ;Specifies an array of one or more values that are language and code page identifier pairs. For additional information, see the following Remarks section.
	DllStructSetData($p_VS_Var, "Wlength", DllStructGetSize($p_VS_Var))
	DllStructSetData($p_VS_Var, "wValueLength", 4)
	DllStructSetData($p_VS_Var, "wType", 0)
	DllStructSetData($p_VS_Var, "szKey", "Translation")
	DllStructSetData($p_VS_Var, "lang", $INP_Res_Language)
	DllStructSetData($p_VS_Var, "lang2", 0x04B0)
	;
	; construct the VarFileInfo
	Local $p_VS_VarFileInfo = DllStructCreate( _
			"short  wLength;" & _       ;Specifies the length, in bytes, of the entire VarFileInfo block, including all structures indicated by the Children member.
			"short  wValueLength;" & _  ;This member is always equal to zero.
			"short  wType;" & _         ;Specifies the type of data in the version resource. This member is 1 if the version resource contains text data and 0 if the version resource contains binary data.
			"WCHAR szKey[12];" & _      ;Contains the Unicode string "VarFileInfo".
			"char  Padding[2];" & _     ;Contains as many zero words as necessary to align the Value member on a 32-bit boundary.
			"Byte   Children[" & DllStructGetSize($p_VS_Var) & "]") ;Specifies a Var structure that typically contains a list of languages that the application or DLL supports.
	DllStructSetData($p_VS_VarFileInfo, "Wlength", DllStructGetSize($p_VS_VarFileInfo))
	DllStructSetData($p_VS_VarFileInfo, "wValueLength", 0)
	DllStructSetData($p_VS_VarFileInfo, "wType", 1)
	DllStructSetData($p_VS_VarFileInfo, "szKey", "VarFileInfo")
	Local $p_VS_Var_Total = DllStructCreate("byte Children[" & DllStructGetSize($p_VS_Var) & "]", DllStructGetPtr($p_VS_Var))
	DllStructSetData($p_VS_VarFileInfo, "Children", DllStructGetData($p_VS_Var_Total, 1))
	;
	; construct the FIXEDFILEINFO
	Local $p_VS_FIXEDFILEINFO = DllStructCreate( _
			"DWORD dwSignature;" & _
			"DWORD dwStrucVersion;" & _
			"DWORD dwFileVersionMS;" & _
			"DWORD dwFileVersionLS;" & _
			"DWORD dwProductVersionMS;" & _
			"DWORD dwProductVersionLS;" & _
			"DWORD dwFileFlagsMask;" & _
			"DWORD dwFileFlags;" & _
			"DWORD dwFileOS;" & _
			"DWORD dwFileType;" & _
			"DWORD dwFileSubtype;" & _
			"DWORD dwFileDateMS;" & _
			"DWORD dwFileDateLS")
	DllStructSetData($p_VS_FIXEDFILEINFO, "dwSignature", 0xFEEF04BD)
	DllStructSetData($p_VS_FIXEDFILEINFO, "dwStrucVersion", 0x00010000)
	$INP_Fileversion = Valid_FileVersion($INP_Fileversion)
	Local $tFileversion = StringSplit($INP_Fileversion, ".")
	DllStructSetData($p_VS_FIXEDFILEINFO, "dwFileVersionMS", Number("0x" & Hex($tFileversion[1], 4) & Hex($tFileversion[2], 4)))
	DllStructSetData($p_VS_FIXEDFILEINFO, "dwFileVersionLS", Number("0x" & Hex($tFileversion[3], 4) & Hex($tFileversion[4], 4)))
	$INP_ProductVersion = Valid_FileVersion($INP_ProductVersion, 0)
	$tFileversion = StringSplit($INP_ProductVersion, ".")
	DllStructSetData($p_VS_FIXEDFILEINFO, "dwProductVersionMS", Number("0x" & Hex($tFileversion[1], 4) & Hex($tFileversion[2], 4)))
	DllStructSetData($p_VS_FIXEDFILEINFO, "dwProductVersionLS", Number("0x" & Hex($tFileversion[3], 4) & Hex($tFileversion[4], 4)))
	DllStructSetData($p_VS_FIXEDFILEINFO, "dwFileFlagsMask", 0)
	DllStructSetData($p_VS_FIXEDFILEINFO, "dwFileFlags", 0)
	DllStructSetData($p_VS_FIXEDFILEINFO, "dwFileOS", 0x00004)
	DllStructSetData($p_VS_FIXEDFILEINFO, "dwFileType", 0)
	DllStructSetData($p_VS_FIXEDFILEINFO, "dwFileSubtype", 0)
	DllStructSetData($p_VS_FIXEDFILEINFO, "dwFileDateLS", 0)
	;
	; construct the Final VERSIONINFO
	Local $p_VS_VERSIONINFO = DllStructCreate( _
			"short  wLength;" & _       ;Specifies the length, in bytes, of the VS_VERSIONINFO structure. This length does not include any padding that aligns any subsequent version resource data on a 32-bit boundary.
			"short  wValueLength;" & _  ;Specifies the length, in bytes, of the Value member. This value is zero if there is no Value member associated with the current version structure.
			"short  wType;" & _         ;Specifies the type of data in the version resource. This member is 1 if the version resource contains text data and 0 if the version resource contains binary data.
			"wchar  szKey[16];" & _     ;Contains the Unicode string "VS_VERSION_INFO".
			"wchar  Padding1[1];" & _   ;Contains as many zero words as necessary to align the Value member on a 32-bit boundary.
			"byte   value[" & DllStructGetSize($p_VS_FIXEDFILEINFO) & "];" & _     ;Contains a VS_FIXEDFILEINFO structure that specifies arbitrary data associated with this VS_VERSIONINFO structure. The wValueLength member specifies the length of this member; if wValueLength is zero, this member does not exist.
			"byte   Children[" & DllStructGetSize($p_VS_StringFileInfo) & "];" & _ ;Specifies an array of zero or one StringFileInfo structures, and
			"byte   Children2[" & DllStructGetSize($p_VS_VarFileInfo) & "]") ;          zero or one VarFileInfo structures that are children of the current VS_VERSIONINFO structure.
	DllStructSetData($p_VS_VERSIONINFO, "Wlength", DllStructGetSize($p_VS_VERSIONINFO))
	DllStructSetData($p_VS_VERSIONINFO, "wValueLength", DllStructGetSize($p_VS_FIXEDFILEINFO))
	DllStructSetData($p_VS_VERSIONINFO, "wType", 0)
	DllStructSetData($p_VS_VERSIONINFO, "szKey", "VS_VERSION_INFO")
	; Add the VS_FIXEDFILEINFO structure
	Local $p_VS_FIXEDFILEINFO_Total = DllStructCreate("byte Children[" & DllStructGetSize($p_VS_FIXEDFILEINFO) & "]", DllStructGetPtr($p_VS_FIXEDFILEINFO))
	DllStructSetData($p_VS_VERSIONINFO, "value", DllStructGetData($p_VS_FIXEDFILEINFO_Total, 1))
	; Add the VS_StringFileInfo structure
	Local $p_VS_StringFileInfo_Total = DllStructCreate("byte Children[" & DllStructGetSize($p_VS_StringFileInfo) & "]", DllStructGetPtr($p_VS_StringFileInfo))
	DllStructSetData($p_VS_VERSIONINFO, "Children", DllStructGetData($p_VS_StringFileInfo_Total, 1))
	; Add the VarFileInfo structure
	Local $p_VS_VarFileInfo_Total = DllStructCreate("byte Children[" & DllStructGetSize($p_VS_VarFileInfo) & "]", DllStructGetPtr($p_VS_VarFileInfo))
	DllStructSetData($p_VS_VERSIONINFO, "Children2", DllStructGetData($p_VS_VarFileInfo_Total, 1))
	; Write the Whole structure to a RES file
	Local $p_VS_VERSIONINFO_Total = DllStructCreate("byte Children[" & DllStructGetSize($p_VS_VERSIONINFO) & "]", DllStructGetPtr($p_VS_VERSIONINFO))
	#forceref $OutResPath
	If $OutResPath = "" Then $OutResPath = @TempDir & "\temp.res"
	Local $Fh = FileOpen($OutResPath, 2 + 16)
	FileWrite($Fh, DllStructGetData($p_VS_VERSIONINFO_Total, 1))
	FileClose($Fh)
EndFunc   ;==>_Res_Create_RTVersion
;
;
; Call UpdateResource DllCalls to update the requested resource with the provided RES or ICO file.
;

Func _Res_Update($rh, $InpResFile, $RType, $RName, $RLanguage = 1033)
	Local $result, $hFile, $tSize, $tBuffer, $pBuffer, $bread = 0
	Local $RType_Type, $RName_Type
	Local $aRESOURCE_TYPES[24] = ["RT_CURSOR", "RT_BITMAP", "RT_ICON", "RT_MENU", "RT_DIALOG", "RT_STRING", "RT_FONTDIR", "RT_FONT", "RT_ACCELERATOR", _
			"RT_RCDATA", "RT_MESSAGETABLE", "RT_GROUPCURSOR", "", "RT_GROUPICON", "", "RT_VERSION", "RT_DLGINCLUDE", "", "RT_PLUGPLAY", _
			"RT_VXD", "RT_ANICURSOR", "RT_ANIICON", "RT_HTML", "RT_MANIFEST"]
	; did we really get a number?
	If StringIsDigit($RType) Then $RType = Number($RType)
	If StringIsDigit($RName) Then $RName = Number($RName)
	; check for known resource types and convert to ordinal
	If IsString($RType) Then
		For $k = 0 To UBound($aRESOURCE_TYPES) - 1
			If $RType = $aRESOURCE_TYPES[$k] Then
				$RType = $k + 1
				$RType_Type = "long"
			EndIf
		Next
	EndIf
	; set parameter types
	If IsString($RType) Then
		$RType_Type = "wstr"
		$RType = StringUpper($RType)
	Else
		$RType_Type = "long"
	EndIf
	If IsString($RName) Then
		$RName_Type = "wstr"
		$RName = StringUpper($RName)
	Else
		$RName_Type = "long"
	EndIf
	;
	; Remove requested Section from the program resources.
	If $InpResFile = "" Then
		; No resource file defined thus delete the existing resource
		$result = DllCall("kernel32.dll", "int", "UpdateResourceW", "ptr", $rh, $RType_Type, $RType, $RName_Type, $RName, "ushort", $RLanguage, "ptr", 0, 'dword', 0)
		Return
	EndIf
	; Make sure the input res file exists
	If Not FileExists($InpResFile) Then
		Write_RC_Console_Msg("Resource Update skipped: missing Resfile :" & $InpResFile, "", "+")
		Return
	EndIf
	;
	; Open the Resource File
	If ($RType <> 6) Then ; not for RT_STRING
		$hFile = _WinAPI_CreateFile($InpResFile, 2, 2)
		If Not $hFile Then
			Write_RC_Console_Msg("Resource Update skipped: error opening Resfile :" & $InpResFile, "", "+")
			Return
		EndIf
	EndIf
	;
	; Process the different Update types
	Switch $RType
		Case 2 ; *** RT_BITMAP
			$tSize = FileGetSize($InpResFile) - 14 ; file size minus the bitmap header
			$tBuffer = DllStructCreate("char Text[" & $tSize & "]") ; Create the buffer.
			$pBuffer = DllStructGetPtr($tBuffer)
			_WinAPI_SetFilePointer($hFile, 14) ; skip reading the bitmap header
			_WinAPI_ReadFile($hFile, $pBuffer, $tSize, $bread, 0)
			If $hFile Then _WinAPI_CloseHandle($hFile)
			If $bread > 0 Then
				$result = DllCall("kernel32.dll", "int", "UpdateResourceW", "ptr", $rh, $RType_Type, $RType, $RName_Type, $RName, "ushort", $RLanguage, "ptr", $pBuffer, 'dword', $tSize)
				If $result[0] <> 1 Then ConsoleWrite('UpdateResources other: $result[0] = ' & $result[0] & " - LastError:" & _WinAPI_GetLastError() & ":" & _WinAPI_GetLastErrorMessage())
			EndIf
		Case 3 ; *** RT_ICON
			;ICO section
			$tSize = FileGetSize($InpResFile) - 6
			Local $tB_Input_Header = DllStructCreate("short res;short type;short ImageCount;char rest[" & $tSize + 1 & "]") ; Create the buffer.
			Local $pB_Input_Header = DllStructGetPtr($tB_Input_Header)
			_WinAPI_ReadFile($hFile, $pB_Input_Header, FileGetSize($InpResFile), $bread, 0)
			If $hFile Then
				$rc = _WinAPI_CloseHandle($hFile)
			EndIf
			; Read input file header
			Local $IconType = DllStructGetData($tB_Input_Header, "Type")
			Local $IconCount = DllStructGetData($tB_Input_Header, "ImageCount")
			; Created IconGroup Structure
			Local $tB_IconGroupHeader = DllStructCreate("short res;short type;short ImageCount;char rest[" & $IconCount * 14 & "]") ; Create the buffer.
			Local $pB_IconGroupHeader = DllStructGetPtr($tB_IconGroupHeader)
			DllStructSetData($tB_IconGroupHeader, "Res", 0)
			DllStructSetData($tB_IconGroupHeader, "Type", $IconType)
			DllStructSetData($tB_IconGroupHeader, "ImageCount", $IconCount)
			; process all internal Icons
			For $x = 1 To $IconCount
				; Set pointer correct in the input struct
				Local $pB_Input_IconHeader = DllStructGetPtr($tB_Input_Header, 4) + ($x - 1) * 16
				Local $tB_Input_IconHeader = DllStructCreate("byte Width;byte Heigth;Byte Colors;Byte res;Short Planes;Short BitPerPixel;dword ImageSize;dword ImageOffset", $pB_Input_IconHeader) ; Create the buffer.
				; get info form the input
				Local $IconWidth = DllStructGetData($tB_Input_IconHeader, "Width")
;~ 				If $IconWidth = 0 then $IconWidth = 256
				Local $IconHeigth = DllStructGetData($tB_Input_IconHeader, "Heigth")
;~ 				If $IconHeigth = 0 then $IconHeigth = 256
				Local $IconColors = DllStructGetData($tB_Input_IconHeader, "Colors")
				Local $IconPlanes = DllStructGetData($tB_Input_IconHeader, "Planes")
				Local $IconBitPerPixel = DllStructGetData($tB_Input_IconHeader, "BitPerPixel")
				Local $IconImageSize = DllStructGetData($tB_Input_IconHeader, "ImageSize")
				Local $IconImageOffset = DllStructGetData($tB_Input_IconHeader, "ImageOffset")
				; Update the ICO Group header struc
				$pB_IconGroupHeader = DllStructGetPtr($tB_IconGroupHeader, 4) + ($x - 1) * 14
				Local $tB_GroupIcon = DllStructCreate("byte Width;byte Heigth;Byte Colors;Byte res;Short Planes;Short BitPerPixel;dword ImageSize;word ResourceID", $pB_IconGroupHeader) ; Create the buffer.
				DllStructSetData($tB_GroupIcon, "Width", $IconWidth)
				DllStructSetData($tB_GroupIcon, "Heigth", $IconHeigth)
				DllStructSetData($tB_GroupIcon, "Colors", $IconColors)
				DllStructSetData($tB_GroupIcon, "res", 0)
				DllStructSetData($tB_GroupIcon, "Planes", $IconPlanes)
				DllStructSetData($tB_GroupIcon, "BitPerPixel", $IconBitPerPixel)
				DllStructSetData($tB_GroupIcon, "ImageSize", $IconImageSize)
				$IconResBase += 1
				DllStructSetData($tB_GroupIcon, "ResourceID", $IconResBase)
				; Get data pointer
				Local $pB_IconData = DllStructGetPtr($tB_Input_Header) + $IconImageOffset
				; add Icon
				$result = DllCall("kernel32.dll", "int", "UpdateResourceW", "ptr", $rh, "long", 3, "long", $IconResBase, "ushort", $RLanguage, "ptr", $pB_IconData, 'dword', $IconImageSize)
				If $result[0] <> 1 Then
					ConsoleWrite('Icon UpdateResources: $result[0] = ' & $result[0] & " - LastError:" & _WinAPI_GetLastError() & ":" & _WinAPI_GetLastErrorMessage())
;~ 				Else
;~ 					ConsoleWrite('Icon UpdateResources: $result[0] = ' & $result[0] & " - LastError:" & _WinAPI_GetLastError() & ":" & _WinAPI_GetLastErrorMessage())
				EndIf
			Next
			; Add Icongroup entry
			$pB_IconGroupHeader = DllStructGetPtr($tB_IconGroupHeader)
			$result = DllCall("kernel32.dll", "int", "UpdateResourceW", "ptr", $rh, "long", 14, $RName_Type, $RName, "ushort", $RLanguage, "ptr", $pB_IconGroupHeader, 'dword', DllStructGetSize($tB_IconGroupHeader))
			If $result[0] <> 1 Then ConsoleWrite('GroupIconUpdateResources: $result[0] = ' & $result[0] & " - LastError:" & _WinAPI_GetLastError() & ":" & _WinAPI_GetLastErrorMessage())
		Case 6 ; RT_STRING
			Local $aLangs = IniReadSectionNames($InpResFile)
			If @error Then
				Write_RC_Console_Msg("Resource Update skipped: string file did not contain valid input", "", "+")
				Return
			EndIf
			; loop each language section
			Local $aStrings, $aBlocks, $aBlock
			Local $iBlock, $iIdx, $iID, $sStr, $iBlockIdx
			Local $iElem, $sStruct, $oStruct
			For $i = 1 To $aLangs[0]
				; aLangs[i] = current language
				$aStrings = IniReadSection($InpResFile, $aLangs[$i])
				If @error Then
					Write_RC_Console_Msg("Resource Update skipped: language '" & $aLangs[$i] & "' is not valid", "", "+")
					ContinueLoop
				EndIf
				; reset block array
				Dim $aBlocks[1] = [0]
				; loop strings, create blocks and update resources
				; string ID is as follows:
				; ID is a WORD (16 bits)
				; first 4 bits = string index in block, 0-15
				; top 12 bits = block ID, starting at 1
				; string IDX = BitAND(ID, 0xF)
				; block ID = BitAND(BitShift(ID, 4), 0xFFF) + 1
				;
				; aBlocks will contain all the string blocks
				; aBlocks[0] = count
				; aBlocks[n] = block array
				; aBlock[0] = block ID
				; aBlock[1] to [16] = string
				For $j = 1 To $aStrings[0][0]
					; iID = string ID
					; sStr = string
					; iBlock = block ID
					; iIdx = string index in block
					; iBlockIdx = string block index in aBlocks container array
					$iID = Number($aStrings[$j][0])
					$sStr = $aStrings[$j][1]
					$iBlock = BitAND(BitShift($iID, 4), 0xFFF) + 1
					$iIdx = BitAND($iID, 0xF)
					; check if we created the block that contains the string, if not, initialize it
					$iBlockIdx = _GetBlockIDIdx($aBlocks, $iBlock)
					If $iBlockIdx = -1 Then
						; initialize the block and resize aBlocks array
						Dim $aBlock[17] = [$iBlock]
						$aBlocks[0] += 1
						ReDim $aBlocks[$aBlocks[0] + 1]
						$iBlockIdx = $aBlocks[0]
					Else
						$aBlock = $aBlocks[$iBlockIdx]
					EndIf
					; we have the string block, set new string in block
					$aBlock[$iIdx + 1] = $sStr
					; set the updated array into aBlocks container
					$aBlocks[$iBlockIdx] = $aBlock
				Next
				; all string blocks for this language have been created, update the resource
				; create the data structure <word;text;word...>
				; empty strings have length 0
				For $j = 1 To $aBlocks[0]
					; get each block
					$aBlock = $aBlocks[$j]
					; we have to loop each block twice, once to create the structure, then once to fill it
					; reset structure
					$sStruct = ""
					For $k = 1 To 16
						$sStruct &= "word;"
						If ($aBlock[$k] <> "") Then
							; there is a string
							$sStruct &= "wchar[" & StringLen($aBlock[$k]) & "];"
						EndIf
					Next
					; create the structure
					$oStruct = DllStructCreate($sStruct)
					; reset element counter
					$iElem = 1
					For $k = 1 To 16
						If ($aBlock[$k] <> "") Then
							; there is a string
							; set count
							DllStructSetData($oStruct, $iElem, StringLen($aBlock[$k]))
							; set string
							DllStructSetData($oStruct, $iElem + 1, $aBlock[$k])
							; increment counter
							$iElem += 2
						Else
							; no string, set count to 0 and increment counter
							DllStructSetData($oStruct, $iElem, 0)
							$iElem += 1
						EndIf
					Next
					; the block structure is created, update the resource
					; aLangs[i] is the language, aBlock[0] is the block ID
					$tSize = DllStructGetSize($oStruct)
					$pBuffer = DllStructGetPtr($oStruct)
					$result = DllCall("kernel32.dll", "int", "UpdateResourceW", "ptr", $rh, $RType_Type, $RType, "long", $aBlock[0], "ushort", $aLangs[$i], "ptr", $pBuffer, 'dword', $tSize)
					If $result[0] <> 1 Then ConsoleWrite('String UpdateResources: $result[0] = ' & $result[0] & " - LastError:" & _WinAPI_GetLastError() & ":" & _WinAPI_GetLastErrorMessage())
				Next
			Next
		Case Else ; 10, 16, 24 *** RT_RCDATA, RT_VERSION and RT_MANIFEST *** and Other
			$tSize = FileGetSize($InpResFile)
			$tBuffer = DllStructCreate("char Text[" & $tSize & "]") ; Create the buffer.
			$pBuffer = DllStructGetPtr($tBuffer)
			_WinAPI_ReadFile($hFile, $pBuffer, $tSize, $bread, 0)
			If $hFile Then _WinAPI_CloseHandle($hFile)
			If $bread > 0 Then
				$result = DllCall("kernel32.dll", "int", "UpdateResourceW", "ptr", $rh, $RType_Type, $RType, $RName_Type, $RName, "ushort", $RLanguage, "ptr", $pBuffer, 'dword', $tSize)
				If $result[0] <> 1 Then ConsoleWrite('UpdateResources other: $result[0] = ' & $result[0] & " - LastError:" & _WinAPI_GetLastError() & ":" & _WinAPI_GetLastErrorMessage())
			EndIf
	EndSwitch
	;
EndFunc   ;==>_Res_Update

Func _ResLangCallback($hModule, $lpszType, $lpszName, $wLangID, $lParam)
	#forceref $hModule, $lpszType, $lpszName, $lParam
	If $g_aResNamesAndLangs[$g_aResNamesAndLangs[0][0]][1] = "" Then
		$g_aResNamesAndLangs[$g_aResNamesAndLangs[0][0]][1] &= $wLangID
	Else
		$g_aResNamesAndLangs[$g_aResNamesAndLangs[0][0]][1] &= "," & $wLangID
	EndIf
	Return 1 ; continue
EndFunc   ;==>_ResLangCallback

Func _ResNameCallback($hModule, $lpszType, $lpszName, $lParam)
	#forceref $hModule, $lParam
	$g_aResNamesAndLangs[0][0] += 1
	ReDim $g_aResNamesAndLangs[UBound($g_aResNamesAndLangs) + 1][2]
	; get name
	If IS_INTRESOURCE($lpszName) Then
		;lpszName is an ordinal
		$g_aResNamesAndLangs[$g_aResNamesAndLangs[0][0]][0] = Number($lpszName)
	Else
		;lpszName is a pointer to a string
		Local $tName = DllStructCreate("wchar[256]", $lpszName)
		Local $sName = DllStructGetData($tName, 1)
		If StringLeft($sName, 1) = "#" Then
			;rest of string is an ordinal
			$g_aResNamesAndLangs[$g_aResNamesAndLangs[0][0]][0] = Number(StringTrimLeft($sName, 1))
		Else
			;regular string
			$g_aResNamesAndLangs[$g_aResNamesAndLangs[0][0]][0] = $sName
		EndIf
	EndIf
	; call language callback
	DllCall("kernel32.dll", "int", "EnumResourceLanguages", "ptr", $hModule, "ptr", $lpszType, "ptr", $lpszName, _
			"ptr", DllCallbackGetPtr($hLangCallback), "long_ptr", 0)

	Return 1 ; continue enumerating
EndFunc   ;==>_ResNameCallback
;
; Add all needed standard Constants Include files
Func Add_Constants()
	ConsoleWrite("+>Check for missing standard constants/udf include files:")
	Local $ScriptData, $Stripped_ScriptData
	Local $count = 0
	Local $Lines2Add
	; Read the script into a variable
	$ScriptData = @CRLF & FileRead($ScriptFile_In)
	; Strip all comments (pulled from Smoke_N example code)
	$Stripped_ScriptData = StringRegExpReplace($ScriptData & @CRLF, "(?s)(?i)(\s*#cs\s*.+?\#ce\s*)(\r\n)", "\2")
	$Stripped_ScriptData = StringRegExpReplace($Stripped_ScriptData, "(?s)(?i)" & '("")|(".*?")|' & "('')|('.*?')|" & "(\s*;.*?)(\r\n)", "\1\2\3\4\6")
	$Stripped_ScriptData = StringRegExpReplace($Stripped_ScriptData, "(\r\n){2,}", @CRLF)
	;
	Local $includes = _FileListToArray($CurrentAutoIt_InstallDir & "\include", "*Constants*.au3")
	Local $AddInclude = 0
	For $i = 1 To UBound($includes) - 1
		; don't include GUIConstants.au3
		If $includes[$i] = "GUIConstants.au3" Then ContinueLoop
		; Skip already included Include files
		If StringRegExp($Stripped_ScriptData, "(?i)(?s)#include(\s*?)<" & $includes[$i] & ">", 0) Then ContinueLoop
		$AddInclude = 0
		; Get all Constants from include file into Array
		Local $ConstArray = StringRegExp(FileRead($CurrentAutoIt_InstallDir & "\include\" & $includes[$i]), "(?i)\n[\s]*Global[\s]*Const[\s]*(.*?) = ", 3)
		For $j = 0 To UBound($ConstArray) - 1
			If StringRegExp($Stripped_ScriptData, "(?i)(?s)\" & $ConstArray[$j] & "", 0) Then
				$count += 1
				$AddInclude = 1
				ExitLoop
			EndIf
		Next
		If $AddInclude Then $Lines2Add &= "#include <" & $includes[$i] & ">" & @CRLF
		;
	Next
	FileRecycle($ScriptFile_In)
	; sleep 500 ms to ensure SciTE detects the file was changed.
	Sleep(500)
	Local $H_Outf = FileOpen($ScriptFile_In, 2 + $SrceUnicodeFlag)
	If $count Then
		FileWriteLine($H_Outf, "; *** Start added by AutoIt3Wrapper ***")
		FileWrite($H_Outf, $Lines2Add)
		FileWriteLine($H_Outf, "; *** End added by AutoIt3Wrapper ***")
	EndIf
	; update directive to n to avoid running it each time
	$ScriptData = StringRegExpReplace($ScriptData, '(?i)' & @CRLF & '(\h?)#AutoIt3Wrapper_Add_Constants(\h*?)=(.*?)' & @CRLF, @CRLF & '#AutoIt3Wrapper_Add_Constants=n' & @CRLF)
	; strip extra leading and trailing CRLF's and write back to file
	FileWrite($H_Outf, StringMid($ScriptData, 3))
	FileClose($H_Outf)
	ConsoleWrite(" " & $count & " include(s) were added" & @CRLF)
EndFunc   ;==>Add_Constants
;
; Check for the availablility of New installers for SciTE4AutoIT3
Func CheckForUpdates()
	$rc = InetGet('http://www.autoitscript.com/autoit3/scite/download/scite4autoit3version.ini', $SciTE_Dir & "\scite4autoit3versionWeb.ini", 16, 1)
	For $x = 1 To 15
		If InetGetInfo($rc, 2) Then ExitLoop ; download complete
		Sleep(200)
	Next
	If Not InetGetInfo($rc, 2) Then
		; download not complete, abort
		InetClose($rc)
		Return 0
	EndIf
	If InetGetInfo($rc, 3) Then ; download successful
		Local $SciTE4AutoIt3WebDate = IniRead($SciTE_Dir & "\scite4autoit3versionWeb.ini", 'SciTE4AutoIt3', 'Date', '')
		Local $SciTE4Au3UpdWebDate = IniRead($SciTE_Dir & "\scite4autoit3versionWeb.ini", 'SciTE4Au3Upd', 'Date', '')
		Local $SciTE4AutoIt3RegDate = RegRead("HKLM\Software\Microsoft\Windows\Currentversion\Uninstall\SciTE4AutoIt3", 'DisplayVersion')
		Local $SciTE4AutoIt3Date = IniRead($SciTE_Dir & "\SciTEVersion.ini", 'SciTE4AutoIt3', 'Date', '')
		Local $SciTE4Au3UpdDate = IniRead($SciTE_Dir & "\SciTEVersion.ini", 'SciTE4Au3Upd', 'Date', '')
		; If the INI date is blank then use the registry Date
		If $SciTE4AutoIt3Date = "" Then
			; If registry date is empty then assume the installer is never used and thus Return.
			If $SciTE4AutoIt3RegDate = "" Then Return
			$SciTE4AutoIt3Date = $SciTE4AutoIt3RegDate
			IniWrite($SciTE_Dir & "\SciTEVersion.ini", 'SciTE4AutoIt3', 'Date', $SciTE4AutoIt3Date)
		EndIf
		; Check for updated SciTE4AutoIt3 Installer
		If _Compare_Date_GT($SciTE4AutoIt3WebDate, $SciTE4AutoIt3Date) > 0 Then
			$msg = "->***********************************************************************************************" & @CRLF & _
					"->There is a new SciTE4AutoIt3 version available dated " & $SciTE4AutoIt3WebDate & _
					", your version is dated " & $SciTE4AutoIt3Date & @CRLF & _
					"->Visit http://www.autoitscript.com/autoit3/scite to download latest version." & @CRLF & _
					"->***********************************************************************************************" & @CRLF
			ConsoleWrite($msg)
		Else
			; Check for Patch updates
			If $SciTE4Au3UpdWebDate <> "" And _Compare_Date_GT($SciTE4Au3UpdWebDate, $SciTE4Au3UpdDate) > 0 Then
				$msg = "->***********************************************************************************************" & @CRLF & _
						"->There is a SciTE4Au3Upd installer available dated: " & $SciTE4Au3UpdWebDate & @CRLF & _
						"->Visit http://www.autoitscript.com/autoit3/scite to download latest version." & @CRLF & _
						"->***********************************************************************************************" & @CRLF
				ConsoleWrite($msg)
			EndIf
		EndIf
	EndIf
	InetClose($rc)
	Return 1
EndFunc   ;==>CheckForUpdates
;
Func Compile_Run_AUT2EXE($out_env, $ScriptFile_Out)
	Local $PgmVer = FileGetVersion($AUT2EXE_PGM)
	Local $s_CMDLine = ""
	;  Run aut2exe to compile the script
	ProgressSet(40, "Running Aut2exe.exe.")
	; Set the proper compile option
	; Set the CUI / GUI
	;-------------------------------------------------------------------------------------------
	; prepare all variables for the commandline programs and AUT2EXE
	;-------------------------------------------------------------------------------------------
	If $INP_Run_Obfuscator = "y" Then
		$s_CMDLine = ' /in "' & StringTrimRight($ScriptFile_In, StringLen($ScriptFile_In_Ext)) & '_Obfuscated' & $ScriptFile_In_Ext & '"'
		If $ScriptFile_Out = "" Then $ScriptFile_Out = StringTrimRight($ScriptFile_In, StringLen($ScriptFile_In_Ext)) & '.exe'
	Else
		$s_CMDLine = ' /in "' & $ScriptFile_In & '"'
	EndIf
	If $ScriptFile_Out <> "" Then
		; Check it the target directory is valid
		$ScriptFile_Out = StringReplace($ScriptFile_Out, "/", "\")
		If StringInStr($ScriptFile_Out, "\", 0, -1) And Not FileExists(StringLeft($ScriptFile_Out, StringInStr($ScriptFile_Out, "\", 0, -1) - 1)) Then
			;$s_CMDLine = $s_CMDLine & ' /out "' & $ScriptFile_Out & '"'
			ConsoleWrite("- Output path: " & StringLeft($ScriptFile_Out, StringInStr($ScriptFile_Out, "\", 0, -1) - 1) & " not found, changing it to:")
			$ScriptFile_Out = StringTrimRight($ScriptFile_In, StringLen($ScriptFile_In_Ext)) & '.exe'
			ConsoleWrite($ScriptFile_Out & @CRLF)
		EndIf
		$s_CMDLine &= ' /out "' & $ScriptFile_Out & '"'
	EndIf
	If $ScriptFile_In = $ScriptFile_Out Then
		ConsoleWrite("! Input source file should never be equal to the target output file !" & @CRLF)
		Exit
	EndIf
	; we handle resources and UPX later, so no packing from compiler
	$s_CMDLine &= ' /nopack'
	;
	If $INP_Icon <> "" Then $s_CMDLine &= ' /icon "' & $INP_Icon & '"'
	If $INP_Compression > -1 And $INP_Compression < 5 Then $s_CMDLine &= ' /comp ' & $INP_Compression & ''
	If $INP_Change2CUI = "y" Then $s_CMDLine &= " /Console"
	; add flag to make x86 EXEs on x64 systems
	If $out_env = "x86" And StringInStr($AUT2EXE_PGM, "aut2exe_x64.exe") Then $s_CMDLine &= " /x86"
	; add flag to make x64 EXEs on x86 systems
	If $out_env = "x64" And StringInStr($AUT2EXE_PGM, "aut2exe.exe") Then $s_CMDLine &= " /x64"
	;
	If $Debug Then ConsoleWrite(">*** AUT2EXE:" & '"' & $AUT2EXE_PGM & '"' & $s_CMDLine & " " & @CRLF)
	;
	ConsoleWrite(">Running:(" & $PgmVer & "):" & $AUT2EXE_PGM & " " & $s_CMDLine & @CRLF)
	;effort to avoid the resource update issue when the Windows Explorer is open and has the output program selected
	;    by deleting the original file and give a little time to update.
	FileDelete($ScriptFile_Out)
	Sleep(600)
	$Pid = Run('"' & $AUT2EXE_PGM & '"' & $s_CMDLine, "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	If $Pid Then
		$Handle = _ProcessExitCode($Pid)
		ProcessWaitClose($Pid)
		; Show console output
		ShowStdOutErr($Pid)
		$ExitCode = _ProcessExitCode($Pid, $Handle)
		_ProcessCloseHandle($Handle)
		;ConsoleWrite(">Aut2exe.exe ended.  rc:" & $exitcode & @crlf)
	EndIf
	;
	If Not $Pid Or Not FileExists($ScriptFile_Out) Then
		Write_RC_Console_Msg("Aut2exe.exe ended errors because the target exe wasn't created, abandon build.", 9999)
		Exit
	Else
		Write_RC_Console_Msg("Aut2exe.exe ended.", $ExitCode)
	EndIf
EndFunc   ;==>Compile_Run_AUT2EXE
;
Func Compile_Upd_res($ScriptFile_Out)
	Local $ResUpdateSuccess = 1
	; Update resources only if the outfile is an EXE
	If $INP_Resource And StringRight($ScriptFile_Out, 4) = ".exe" Then
		ProgressSet(50, "Creating Resource file.")
		Write_RC_Console_Msg("Performing the Program Resource Update steps:")
		;
		$ResUpdateSuccess = 0
		;
		; get and save 'extra data' at end of script
		Local $extraData, $dwSize = 0
		If Not _getFileExtraData($ScriptFile_Out, $extraData, $dwSize) Or $dwSize = 0 Then
			; something went wrong
			Write_RC_Console_Msg("Error: Failed to get script data from end of target file.  Skipping resource update.", 2)
		Else
			; begin resource update
			$rh = DllCall("kernel32.dll", "ptr", "BeginUpdateResourceW", "wstr", $ScriptFile_Out, "int", 0)
			$rh = $rh[0]
			; set language
			$INP_Res_Language = Number($INP_Res_Language)
			If $INP_Res_Language = 0 Then $INP_Res_Language = 2057
			; create the source of the VERSION resource update file
			If $INP_Resource_Version = 1 Then
				Local $Version_Res_File = ""
				; enum RT_VERSION resources in target file
				If Not _EnumResourceNamesAndLangs($ScriptFile_Out, 16) Then ; RT_VERSION
					; error, use default
					Write_RC_Console_Msg("Error: Failed to enumerate RT_VERSION resources, using defaults.", "", "!")
					Dim $aVersionInfo[2][2] = [[1, 0],[1, 2057]]
				Else
					$aVersionInfo = $g_aResNamesAndLangs
				EndIf
				; retrieve the current info when not all fields are filled to preserve those:
				Local $AutoItBin = $AUT2EXE_DIR & "\AutoItSC.bin" ; used for default version info only
				If $INP_Comment = "" Then $INP_Comment = FileGetVersion($AutoItBin, "Comments")
				If $INP_Description = "" Then $INP_Description = FileGetVersion($AutoItBin, "FileDescription")
				If $INP_Fileversion = "" Then $INP_Fileversion = FileGetVersion($AutoItBin)
				If $INP_LegalCopyright = "" Then $INP_LegalCopyright = FileGetVersion($AutoItBin, "LegalCopyright")
				If $INP_ProductVersion = "" Then $INP_ProductVersion = FileGetVersion($AutoItBin)
				; Delete current resources for all but 1 and the input language
				For $y = 1 To $aVersionInfo[0][0]
					$aTemp = StringSplit($aVersionInfo[$y][1], ",") ; create temp array of languages for this name
					For $z = 1 To $aTemp[0]
						; remove any version info that is not 1 or our input language
						If ($aVersionInfo[$y][0] <> 1) Or ($aTemp[$z] <> $INP_Res_Language) Then _
								_Res_Update($rh, "", 16, $aVersionInfo[$y][0], $aTemp[$z])
					Next
				Next
				_Res_Create_RTVersion($Version_Res_File) ; Build the RT_VERSION structure
				_Res_Update($rh, $Version_Res_File, 16, 1, $INP_Res_Language) ; Update RT_VERSION in the Bin file
				FileDelete($Version_Res_File)
				Write_RC_Console_Msg("Updating Program Version information.", "", "...", 0)
			EndIf
			;
			;Update manifest
			If $INP_RES_requestedExecutionLevel <> "" Or $INP_RES_Compatibility <> "" Or $INP_RES_HiDpi <> "" Then
				; enum RT_MANIFEST resources in target file
				If Not _EnumResourceNamesAndLangs($ScriptFile_Out, 24) Then ; RT_MANIFEST
					; error, use default
					Write_RC_Console_Msg("Error: Failed to enumerate RT_MANIFEST resources, using defaults.", "", "!")
					Dim $aManifestInfo[2][2] = [[1, 0],[1, 1033]]
				Else
					$aManifestInfo = $g_aResNamesAndLangs
				EndIf
				$TempFile2 = @TempDir & '\RHManifest.txt'
				Local $hTempFile2 = FileOpen($TempFile2, 2)
				FileWriteLine($hTempFile2, '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>')
				FileWriteLine($hTempFile2, '<assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0" xmlns:asmv3="urn:schemas-microsoft-com:asm.v3">')
				FileWriteLine($hTempFile2, '')
				If $INP_RES_requestedExecutionLevel = "" Then
					$INP_RES_requestedExecutionLevel = "asInvoker"
				Else
					Write_RC_Console_Msg("Setting Program ExecutionLevel Manifest information to " & $INP_RES_requestedExecutionLevel, "", "...", 0)
				EndIf
				If $INP_RES_requestedExecutionLevel <> "None" Then
					FileWriteLine($hTempFile2, '	<!-- Identify the application security requirements. -->')
					FileWriteLine($hTempFile2, '	<trustInfo xmlns="urn:schemas-microsoft-com:asm.v2">')
					FileWriteLine($hTempFile2, '		<security>')
					FileWriteLine($hTempFile2, '			<requestedPrivileges>')
					FileWriteLine($hTempFile2, '				<requestedExecutionLevel')
					FileWriteLine($hTempFile2, ' 					level="' & $INP_RES_requestedExecutionLevel & '"')
					FileWriteLine($hTempFile2, '					uiAccess="false"')
					FileWriteLine($hTempFile2, '				/>')
					FileWriteLine($hTempFile2, '			</requestedPrivileges>')
					FileWriteLine($hTempFile2, '		</security>')
					FileWriteLine($hTempFile2, '	</trustInfo>')
					FileWriteLine($hTempFile2, '')
				EndIf
				FileWriteLine($hTempFile2, '	<!-- Identify the application dependencies. -->')
				FileWriteLine($hTempFile2, '	<dependency>')
				FileWriteLine($hTempFile2, '		<dependentAssembly>')
				FileWriteLine($hTempFile2, '			<assemblyIdentity')
				FileWriteLine($hTempFile2, '				type="win32"')
				FileWriteLine($hTempFile2, '				name="Microsoft.Windows.Common-Controls"')
				FileWriteLine($hTempFile2, '				version="6.0.0.0"')
				FileWriteLine($hTempFile2, '				language="*"')
				FileWriteLine($hTempFile2, '				processorArchitecture="*"')
				FileWriteLine($hTempFile2, '				publicKeyToken="6595b64144ccf1df"')
				FileWriteLine($hTempFile2, '			/>')
				FileWriteLine($hTempFile2, '		</dependentAssembly>')
				FileWriteLine($hTempFile2, '	</dependency>')
				FileWriteLine($hTempFile2, '')
				If $INP_RES_HiDpi <> "" Then
					Write_RC_Console_Msg("Setting DPI awareness Manifest information to true", "", "...", 0)
					FileWriteLine($hTempFile2, '	<asmv3:application>')
					FileWriteLine($hTempFile2, '		<asmv3:windowsSettings xmlns="http://schemas.microsoft.com/SMI/2005/WindowsSettings">')
					FileWriteLine($hTempFile2, '		      <dpiAware>true</dpiAware>')
					FileWriteLine($hTempFile2, '		</asmv3:windowsSettings>')
					FileWriteLine($hTempFile2, '	</asmv3:application>')
				EndIf

				If $INP_RES_Compatibility <> "" Then
					FileWriteLine($hTempFile2, '	<compatibility xmlns="urn:schemas-microsoft-com:compatibility.v1">')
					FileWriteLine($hTempFile2, '		<application>')
					If StringInStr($INP_RES_Compatibility, "Vista") Then
						FileWriteLine($hTempFile2, '			<!--The ID below indicates application support for Windows Vista -->')
						FileWriteLine($hTempFile2, '			<supportedOS Id="{e2011457-1546-43c5-a5fe-008deee3d3f0}"/>')
						Write_RC_Console_Msg("Setting Program Compatibility Manifest information to Vista.", "", "...", 0)
					EndIf
					If StringInStr($INP_RES_Compatibility, "Windows7") Then
						FileWriteLine($hTempFile2, '			<!--The ID below indicates application support for Windows 7 -->')
						FileWriteLine($hTempFile2, '			<supportedOS Id="{35138b9a-5d96-4fbd-8e2d-a2440225f93a}"/>')
						Write_RC_Console_Msg("Setting Program Compatibility Manifest information to Windows7", "", "...", 0)
					EndIf
					FileWriteLine($hTempFile2, '		</application>')
					FileWriteLine($hTempFile2, '	</compatibility>')
				EndIf
				;
				FileWriteLine($hTempFile2, '</assembly>')
				FileClose($hTempFile2)
				For $y = 1 To $aManifestInfo[0][0]
					$aTemp = StringSplit($aManifestInfo[$y][1], ",") ; create temp array of languages for this name
					For $z = 1 To $aTemp[0]
						; remove any manifest that is not 1 or our input language
						If ($aManifestInfo[$y][0] <> 1) Or ($aTemp[$z] <> $INP_Res_Language) Then _
								_Res_Update($rh, "", 24, $aManifestInfo[$y][0], $aTemp[$z])
					Next
				Next
				_Res_Update($rh, $TempFile2, 24, 1, $INP_Res_Language)
				FileDelete($TempFile2)
				Write_RC_Console_Msg("Updating Program Manifest information.", "", "...", 0)
			EndIf
			;
			; Add original source to Resources
			If $INP_Res_SaveSource = "y" Then
				If $INP_Run_Obfuscator = "y" Then
					If StringInStr($INP_Obfuscator_Parameters, "/so") Or StringInStr($INP_Obfuscator_Parameters, "/striponly") Then
						FileCopy(StringTrimRight($ScriptFile_In, StringLen($ScriptFile_In_Ext)) & '_Obfuscated' & $ScriptFile_In_Ext, @TempDir & "\scriptin.tmp", 1)
						Write_RC_Console_Msg("Adding stripped Script source to RT_RCDATA,999 in the Output executable.", "", "...", 0)
					Else
						Write_RC_Console_Msg("Skipping SourceSave because this is an obfuscated script.", 2)
					EndIf
				Else
					FileCopy($ScriptFile_In, @TempDir & "\scriptin.tmp", 1)
					Write_RC_Console_Msg("Adding original Script source to RT_RCDATA,999 in the Output executable.", "", "...", 0)
				EndIf
				_Res_Update($rh, @TempDir & "\scriptin.tmp", 10, 999, $INP_Res_Language)
				FileDelete(@TempDir & "\scriptin.tmp")
			EndIf
			;
			; Add ICO's to Resources
			For $x = 1 To $INP_Icons_cnt
				$IconFileInfo = StringSplit($INP_Icons[$x], ",")
				ReDim $IconFileInfo[4]
				If StringStripWS($IconFileInfo[2], 3) = "" Then $IconFileInfo[2] = 200 + $x
				If StringStripWS($IconFileInfo[3], 3) = "" Then $IconFileInfo[3] = $INP_Res_Language
				_Res_Update($rh, StringStripWS($IconFileInfo[1], 3), 3, StringStripWS($IconFileInfo[2], 3), StringStripWS($IconFileInfo[3], 3))
			Next
			If $INP_Icons_cnt Then Write_RC_Console_Msg("Adding " & $INP_Icons_cnt & " Icon(s).", "", "...", 0)
			; Add Files to Resources
			Local $ResFileInfo
			For $x = 1 To $INP_Res_Files_Cnt
				$ResFileInfo = StringSplit($INP_Res_Files[$x], ",")
				ReDim $ResFileInfo[5]
				If $ResFileInfo[2] = "" Then $ResFileInfo[2] = 10
				If $ResFileInfo[3] = "" Then $ResFileInfo[3] = $x
				If $ResFileInfo[4] = "" Then $ResFileInfo[4] = $INP_Res_Language
				$ResFileInfo[1] = StringReplace($ResFileInfo[1], "\", "\\")
				$ResFileInfo[1] = StringReplace($ResFileInfo[1], "/", "\\")
				_Res_Update($rh, StringStripWS($ResFileInfo[1], 3), StringStripWS($ResFileInfo[2], 3), StringStripWS($ResFileInfo[3], 3), StringStripWS($ResFileInfo[4], 3))
			Next
			If $INP_Res_Files_Cnt Then Write_RC_Console_Msg("Adding " & $INP_Res_Files_Cnt & " file(s).", "", "...", 0)
			;
			; end resource update
			Local $result = DllCall("kernel32.dll", "int", "EndUpdateResourceW", "ptr", $rh, "int", 0)
			If $result[0] <> 1 Then
				$Return_Text = "Error: EndUpdateResource: Returncode = " & $result[0] & " - LastError:" & _WinAPI_GetLastError() & ":" & StringReplace(_WinAPI_GetLastErrorMessage(), @CRLF, "")
				Write_RC_Console_Msg($Return_Text, 2)
				Write_RC_Console_Msg("Error: Program Resource updating Failed. The output program will not contain the Resource updates!", 2)
				Show_Warnings("Resource Update errors", $Return_Text)
			Else
				; append 'extra data' back to end of updated script
				If Not _appendFileExtraData($ScriptFile_Out, $extraData, $dwSize) Then
					; something ELSE went wrong
					Write_RC_Console_Msg("Error: Failed to append script data to end of updated executable. Try recompiling your script.", 2)
					Exit
				Else
					$ResUpdateSuccess = 1
					Write_RC_Console_Msg("Program Resource updating finished successfully.", 0)
				EndIf
			EndIf
		EndIf
	EndIf
	Return $ResUpdateSuccess
	;
EndFunc   ;==>Compile_Upd_res
;
Func Compile_UPX($ScriptFile_Out)
	; run UPX if asked, and if outfile is x86 EXE
	If StringRight($ScriptFile_Out, 4) = ".exe" Then
		Local $UPX_Pgm = $AUT2EXE_DIR & "\upx.exe"
		Local $PgmVer = FileGetVersion($UPX_Pgm)
		If $INP_Upx_Parameters = "" Then $INP_Upx_Parameters = "--best --compress-icons=0 -qq"
		If FileExists($UPX_Pgm) Then
			ConsoleWrite(">Running:(" & $PgmVer & "):" & $UPX_Pgm & '" ' & $INP_Upx_Parameters & ' "' & $ScriptFile_Out & '"' & @CRLF)
			$Pid = Run('"' & $UPX_Pgm & '" ' & $INP_Upx_Parameters & ' "' & $ScriptFile_Out & '"', "", @SW_HIDE, $STDOUT_CHILD)
			If $Pid Then
				$Handle = _ProcessExitCode($Pid)
				ProcessWaitClose($Pid)
				ConsoleWrite(StdoutRead($Pid))
				StdioClose($Pid)
				$ExitCode = _ProcessExitCode($Pid, $Handle)
				_ProcessCloseHandle($Handle)
				Write_RC_Console_Msg("UPX Ended: ", $ExitCode)
			Else
				Write_RC_Console_Msg("Error: Failed to UPX the executable.", 2)
			EndIf
		Else
			Write_RC_Console_Msg("Error: " & $UPX_Pgm & " is missing.", 2)
		EndIf
	EndIf
EndFunc   ;==>Compile_UPX
;
Func Convert_RES_GenDirective($section, $kword, $directive, $default, $translate, ByRef $directives)
	Local $tarray = StringSplit($translate, ";")
	Local $value = IniRead($ScriptFile_In & ".ini", $section, $kword, $default)
	Local $varray
	For $x = 1 To $tarray[0]
		$varray = StringSplit($tarray[$x], "=")
		If $varray[0] > 1 And $varray[1] = $value Then $value = $varray[2]
	Next
	If $value = "" Or $value = $default Then Return
	$directives &= $directive & "=" & IniRead($ScriptFile_In & ".ini", $section, $kword, $default) & @CRLF
EndFunc   ;==>Convert_RES_GenDirective
Func Convert_RES_INI_to_Directives()
	Local $directives = "#Region converted Directives from " & $ScriptFile_In & ".ini" & @CRLF
	Convert_RES_GenDirective("Autoit", "aut2exe", "#AutoIt3Wrapper_aut2exe", "", "", $directives)
	Convert_RES_GenDirective("Autoit", "icon", "#AutoIt3Wrapper_Icon", "", "", $directives)
	Convert_RES_GenDirective("Autoit", "outfile", "#AutoIt3Wrapper_outfile", "", "", $directives)
	Convert_RES_GenDirective("Autoit", "Compression", "#AutoIt3Wrapper_Compression", "2", "", $directives)
	Convert_RES_GenDirective("Autoit", "PassPhrase", "#AutoIt3Wrapper_PassPhrase", "", "", $directives)
	Convert_RES_GenDirective("Autoit", "UseUpx", "#AutoIt3Wrapper_UseUpx", "y", "1=y;0=n;4=n", $directives)
	Convert_RES_GenDirective("Autoit", "UseAnsi", "#AutoIt3Wrapper_UseAnsi", "n", "1=y;0=n;4=n", $directives)
	Convert_RES_GenDirective("Autoit", "UseX64", "#AutoIt3Wrapper_UseX64", "n", "1=y;0=n;4=n", $directives)
	Convert_RES_GenDirective("Autoit", "Allow_Decompile", "#AutoIt3Wrapper_Allow_Decompile", "y", "1=y;0=n;4=n", $directives)
	;
	Convert_RES_GenDirective("Res", "Comment", "#AutoIt3Wrapper_Res_Comment", "", "", $directives)
	Convert_RES_GenDirective("Res", "Description", "#AutoIt3Wrapper_Res_Description", "", "", $directives)
	Convert_RES_GenDirective("Res", "Fileversion", "#AutoIt3Wrapper_Res_Fileversion", "", "", $directives)
	Convert_RES_GenDirective("Res", "Fileversion_AutoIncrement", "#AutoIt3Wrapper_Res_Fileversion_AutoIncrement", "", "", $directives)
	Convert_RES_GenDirective("Res", "ProductVersion", "#AutoIt3Wrapper_Res_ProductVersion", "", "", $directives)
	Convert_RES_GenDirective("Res", "LegalCopyright", "#AutoIt3Wrapper_Res_LegalCopyright", "", "", $directives)
	Convert_RES_GenDirective("Res", "Field1Name", "#AutoIt3Wrapper_Res_Field1Name", "", "", $directives)
	Convert_RES_GenDirective("Res", "Field2Name", "#AutoIt3Wrapper_Res_Field2Name", "", "", $directives)
	Convert_RES_GenDirective("Res", "Field1Value", "#AutoIt3Wrapper_Res_Field1Value", "", "", $directives)
	Convert_RES_GenDirective("Res", "Field2Value", "#AutoIt3Wrapper_Res_Field2Value", "", "", $directives)
	;
	Convert_RES_GenDirective("Other", "Run_AU3Check", "#AutoIt3Wrapper_Run_AU3Check", "y", "1=y;0=n;4=n", $directives)
	Convert_RES_GenDirective("Other", "AU3Check_Stop_OnWarning", "#AutoIt3Wrapper_AU3Check_Stop_OnWarning", "", "", $directives)
	Convert_RES_GenDirective("Other", "AU3Check_Parameter", "#AutoIt3Wrapper_AU3Check_Parameters", "", "", $directives)
	Convert_RES_GenDirective("Other", "Run_Before", "#AutoIt3Wrapper_Run_Before", "", "", $directives)
	Convert_RES_GenDirective("Other", "Run_After", "#AutoIt3Wrapper_Run_After", "", "", $directives)
	Convert_RES_GenDirective("Other", "Run_cvsWrapper", "#AutoIt3Wrapper_Run_cvsWrapper", "", "", $directives)
	Convert_RES_GenDirective("Other", "cvsWrapper_Parameter", "#AutoIt3Wrapper_cvsWrapper_Parameters", "", "", $directives)
	;
	$directives &= "#EndRegion converted Directives from " & $ScriptFile_In & ".ini" & @CRLF & ";" & @CRLF
	$directives &= FileRead($ScriptFile_In)
	Local $Fh = FileOpen($ScriptFile_In, 2 + $SrceUnicodeFlag)
	FileWrite($Fh, $directives)
	FileClose($Fh)
	FileRecycle($ScriptFile_In & ".ini")
	ConsoleWrite('->================================================================================================================' & @CRLF)
	ConsoleWrite('->File:' & $ScriptFile_In & ".ini" & @CRLF)
	ConsoleWrite('-> converted to #Directives at the top of the script and the file put into the recycleBin.' & @CRLF)
	ConsoleWrite('->================================================================================================================' & @CRLF)
EndFunc   ;==>Convert_RES_INI_to_Directives
Func Convert_Variables($I_String, $text = 0)
	$I_String = StringReplace($I_String, "%in%", $ScriptFile_In)
	$I_String = StringReplace($I_String, "%out%", $ScriptFile_Out)
	$I_String = StringReplace($I_String, "%outx64%", $ScriptFile_Out_x64)
	$I_String = StringReplace($I_String, "%icon%", $INP_Icon)
	$I_String = StringReplace($I_String, "%fileversion%", $INP_Fileversion)
	$I_String = StringReplace($I_String, "%fileversionnew%", $INP_Fileversion_New)
	Local $ScriptName = StringTrimLeft($ScriptFile_In, StringInStr($ScriptFile_In, "\", 0, -1))
	Local $ScriptDir = StringLeft($ScriptFile_In, StringInStr($ScriptFile_In, "\", 0, -1) - 1)
	$I_String = StringReplace($I_String, "%scriptfile%", StringReplace($ScriptName, $ScriptFile_In_Ext, ''))
	$I_String = StringReplace($I_String, "%scriptdir%", $ScriptDir)
	$I_String = StringReplace($I_String, "%scitedir%", $SciTE_Dir)
	$I_String = StringReplace($I_String, "%autoitdir%", $CurrentAutoIt_InstallDir)
	$I_String = StringReplace($I_String, "%AutoItVer%", $AUT2EXE_PGM_VER)
	$I_String = StringReplace($I_String, "%Date%", _NowDate())
	$I_String = StringReplace($I_String, "%LongDate%", _DateTimeFormat(_NowCalcDate(), 1))
	$I_String = StringReplace($I_String, "%Time%", _NowTime())
	; These should only be done on text Items, strings containing a File/Path will give problems
	If $text Then
		$I_String = StringReplace($I_String, "\n", @CRLF)
	EndIf
	Return $I_String
EndFunc   ;==>Convert_Variables

Func IS_INTRESOURCE($r)
	Return (Not BitAND($r, 0xFFFF0000))
EndFunc   ;==>IS_INTRESOURCE
;
;
;
Func Language_Code(ByRef $code, ByRef $CountryTable, ByRef $Country, $task = 1)
	Local $CountryArray[120][2] = [["Afrikaans", "1078"],["Albanian", "1052"],["Arabic (Algeria)", "5121"],["Arabic (Bahrain)", "15361"], _
			["Arabic (Egypt)", "3073"],["Arabic (Iraq)", "2049"],["Arabic (Jordan)", "11265"],["Arabic (Kuwait)", "13313"],["Arabic (Lebanon)", "12289"], _
			["Arabic (Libya)", "4097"],["Arabic (Morocco)", "6145"],["Arabic (Oman)", "8193"],["Arabic (Qatar)", "16385"],["Arabic (Saudi Arabia)", "1025"], _
			["Arabic (Syria)", "10241"],["Arabic (Tunisia)", "7169"],["Arabic (U.A.E.)", "14337"],["Arabic (Yemen)", "9217"],["Basque", "1069"], _
			["Belarusian", "1059"],["Bulgarian", "1026"],["Catalan", "1027"],["Chinese (Hong Kong SAR)", "3076"],["Chinese (PRC)", "2052"], _
			["Chinese (Singapore)", "4100"],["Chinese (Taiwan)", "1028"],["Croatian", "1050"],["Czech", "1029"],["Danish", "1030"], _
			["Dutch", "1043"],["Dutch (Belgium)", "2067"],["English (Australia)", "3081"],["English (Belize)", "10249"],["English (Canada)", "4105"], _
			["English (Ireland)", "6153"],["English (Jamaica)", "8201"],["English (New Zealand)", "5129"],["English (South Africa)", "7177"], _
			["English (Trinidad)", "11273"],["English (United Kingdom)", "2057"],["English (United States)", "1033"],["Estonian", "1061"], _
			["Faeroese", "1080"],["Farsi", "1065"],["Finnish", "1035"],["French (Standard)", "1036"],["French (Belgium)", "2060"], _
			["French (Canada)", "3084"],["French (Luxembourg)", "5132"],["French (Switzerland)", "4108"],["Gaelic (Scotland)", "1084"], _
			["German (Standard)", "1031"],["German (Austrian)", "3079"],["German (Liechtenstein)", "5127"],["German (Luxembourg)", "4103"], _
			["German (Switzerland)", "2055"],["Greek", "1032"],["Hebrew", "1037"],["Hindi", "1081"],["Hungarian", "1038"],["Icelandic", "1039"], _
			["Indonesian", "1057"],["Italian (Standard)", "1040"],["Italian (Switzerland)", "2064"],["Japanese", "1041"],["Korean", "1042"], _
			["Latvian", "1062"],["Lithuanian", "1063"],["Macedonian (FYROM)", "1071"],["Malay (Malaysia)", "1086"],["Maltese", "1082"], _
			["Norwegian (Bokmål)", "1044"],["Polish", "1045"],["Portuguese (Brazil)", "1046"],["Portuguese (Portugal)", "2070"], _
			["Raeto (Romance)", "1047"],["Romanian", "1048"],["Romanian (Moldova)", "2072"],["Russian", "1049"],["Russian (Moldova)", "2073"], _
			["Serbian (Cyrillic)", "3098"],["Setsuana", "1074"],["Slovak", "1051"],["Slovenian", "1060"],["Sorbian", "1070"], _
			["Spanish (Argentina)", "11274"],["Spanish (Bolivia)", "16394"],["Spanish (Chile)", "13322"],["Spanish (Columbia)", "9226"], _
			["Spanish (Costa Rica)", "5130"],["Spanish (Dominican Republic)", "7178"],["Spanish (Ecuador)", "12298"],["Spanish (El Salvador)", "17418"], _
			["Spanish (Guatemala)", "4106"],["Spanish (Honduras)", "18442"],["Spanish (Mexico)", "2058"],["Spanish (Nicaragua)", "19466"], _
			["Spanish (Panama)", "6154"],["Spanish (Paraguay)", "15370"],["Spanish (Peru)", "10250"],["Spanish (Puerto Rico)", "20490"], _
			["Spanish (Spain)", "1034"],["Spanish (Uruguay)", "14346"],["Spanish (Venezuela)", "8202"],["Sutu", "1072"], _
			["Swedish", "1053"],["Swedish (Finland)", "2077"],["Thai", "1054"],["Turkish", "1055"],["Tsonga", "1073"], _
			["Ukranian", "1058"],["Urdu (Pakistan)", "1056"],["Vietnamese", "1066"],["Xhosa", "1076"],["Yiddish", "1085"],["Zulu", "1077"]]
	$CountryTable = ""
	If $task = 1 And $code = 0 Then $code = 2057
	If $task = 2 And $Country = "" Then
		$code = 2057
		Return
	EndIf
	For $x = 0 To UBound($CountryArray) - 1
		Switch $task
			Case 1
				$CountryTable &= $CountryArray[$x][0] & "|"
				If $CountryArray[$x][1] = $code Then
					$Country = $CountryArray[$x][0]
				EndIf
			Case 2
				If $CountryArray[$x][0] = $Country Then
					$code = $CountryArray[$x][1]
					ExitLoop
				EndIf
		EndSwitch
	Next
	; Default to UK English when specified name isn't found
	If $task = 2 And $code = 0 Then $code = 2057
EndFunc   ;==>Language_Code
;
Func OnAutoItExit()
	; only show this line for main script run not the Watcher
	If Not StringInStr($CMDLINERAW, "/watcher") _
			And Not StringInStr($CMDLINERAW, "/au3record") _
			And Not StringInStr($CMDLINERAW, "/au3info") _
			Then Write_RC_Console_Msg("AutoIt3Wrapper Finished..", "", "+")
EndFunc   ;==>OnAutoItExit
; Retrieve the compiler settings from the scriptfile when available
Func Retrieve_PreProcessor_Info()
	Local $I_Rec
	Local $In_File
	Local $hTest_UTF = FileOpen($ScriptFile_In, 16)
	Local $Test_UTF = FileRead($hTest_UTF, 4)
	Local $i_Rec_Param, $i_Rec_Value, $Temp_Val, $Fh
	FileClose($hTest_UTF)
;~ 00 00 FE FF UTF-32, big-endian
;~ FF FE 00 00 UTF-32, little-endian
;~ FE FF UTF-16, big-endian
;~ FF FE UTF-16, little-endian
;~ EF BB BF UTF-8
	Select
		Case BinaryMid($Test_UTF, 1, 3) = '0x0000FEFF' ; UTF-32 BE
			$UTFtype = '32BE'
			$SrceUnicodeFlag = 0
			$InputFileIsUTF32 = 1
		Case BinaryMid($Test_UTF, 1, 3) = '0xFFFE0000' ; UTF-32 LE
			$UTFtype = '32LE'
			$SrceUnicodeFlag = 0
			$InputFileIsUTF32 = 1
		Case BinaryMid($Test_UTF, 1, 2) = '0xFEFF' Or BinaryMid($Test_UTF, 1, 4) = '0x0000FEFF' ; UTF-16 BE
			$UTFtype = '16BE'
			$SrceUnicodeFlag = 64
			$InputFileIsUTF16 = 1
		Case BinaryMid($Test_UTF, 1, 2) = '0xFFFE' ; UTF-16 LE
			$UTFtype = '16LE'
			$SrceUnicodeFlag = 32
			$InputFileIsUTF16 = 1
		Case BinaryMid($Test_UTF, 1, 3) = '0xEFBBBF' ; UTF-8
			$UTFtype = '8'
			$SrceUnicodeFlag = 128
			$InputFileIsUTF8 = 1
		Case Else
			$UTFtype = ''
			$SrceUnicodeFlag = 0
			$InputFileIsUTF8 = 0
			$InputFileIsUTF16 = 0
			$InputFileIsUTF32 = 0
	EndSelect
	; -------------------------------------------------------------------------------------------------------------------------------------------------------------
	Local $aFile
	Local $hFile = FileOpen($ScriptFile_In, 16384)
	If $hFile = -1 Then Return SetError(1, 0, 0);; unable to open the file
	; Read the file and dump into an Array and also check if the Filesize is different from the Read Characters which will be an indication of UTF8 without BOM
	Local $aFile_tot = FileRead($hFile)
	Local $aFile_len = @extended
	FileClose($hFile)
	; Write warning for UTF encoded files or else check for UTF8 without BOM files
	If $InputFileIsUTF8 Then
;~ 		ConsoleWrite("! ***************************************************************************************************" & @CRLF)
;~ 		ConsoleWrite("! * Input file is UTF" & $UTFtype & " encoded, Obfuscator do not support UNICODE and will be skipped.*" & @CRLF)
;~ 		ConsoleWrite("! ***************************************************************************************************" & @CRLF)
	ElseIf $InputFileIsUTF16 Or $InputFileIsUTF32 Then
;~ 		ConsoleWrite("! ***************************************************************************************************" & @CRLF)
;~ 		ConsoleWrite("! * Input file is UTF" & $UTFtype & " encoded, Tidy and Obfuscator do not support UNICODE and will be skipped.*" & @CRLF)
;~ 		ConsoleWrite("! ***************************************************************************************************" & @CRLF)
	Else
		; check for UTF8 without BOM, if so Warn and tell them the file will be changed to UTF8 with BOM
		If $aFile_len > StringLen($aFile_tot) Then
			$UTFtype = '8 Without BOM'
			$SrceUnicodeFlag = 128
			ConsoleWrite("! ***************************************************************************************************************" & @CRLF)
			ConsoleWrite("! * Input file is UTF8 without BOM encoded, Obfuscator do not support UNICODE and will be skipped.      *" & @CRLF)
			ConsoleWrite("! * The file SHOULD BE encoded as UTF8 with BOM to continue processing by AutoIT3Wrapper.                       *" & @CRLF)
			ConsoleWrite("! *    #####################################################################################################    *" & @CRLF)
			ConsoleWrite("! * ##### AutoIt3Wrapper will not show a GUI or update the script to avoid any damage to your scriptfile. ##### *" & @CRLF)
			ConsoleWrite("! *    #####################################################################################################    *" & @CRLF)
			ConsoleWrite("! * When your file isn't a UTF8 file without BOM then please report this to me for review.                      *" & @CRLF)
			ConsoleWrite("! ***************************************************************************************************************" & @CRLF)
			$InputFileIsUTF8 = 9
;~ 			$InputFileIsUTF16 = 9
		EndIf
	EndIf
	; build Array
	If StringInStr($aFile_tot, @LF) Then
		$In_File = StringSplit(StringStripCR($aFile_tot), @LF)
	ElseIf StringInStr($aFile, @CR) Then ;; @LF does not exist so split on the @CR
		$In_File = StringSplit($aFile_tot, @CR)
	Else ;; unable to split the file
		If StringLen($aFile_tot) Then
			Dim $In_File[2] = [1, $aFile]
		Else
			Return SetError(2, 0, 0)
		EndIf
	EndIf
	; -------------------------------------------------------------------------------------------------------------------------------------------------------------
	;
	Local $Found_Old_Compiler = 0
	For $rcount = 1 To $In_File[0]
		$I_Rec = $In_File[$rcount]
		$I_Rec = StringStripWS($I_Rec, 1)
		If StringLeft($I_Rec, 16) <> "#AutoIt3Wrapper_" _
				And StringLeft($I_Rec, 9) <> "#Compiler" _
				And StringLeft($I_Rec, 5) <> "#Run_" _
				And StringLeft($I_Rec, 6) <> "#Tidy_" _
				And StringLeft($I_Rec, 12) <> "#Obfuscator_" _
				Then ContinueLoop
		; no need for this as this is build into au3check now
		If StringLeft($I_Rec, 22) = "#Compiler_plugin_funcs" Then ContinueLoop
		If StringInStr($I_Rec, ";") Then
			$I_Rec = StringLeft($I_Rec, StringInStr($I_Rec, ";") - 1)
		EndIf
		$I_Rec = StringStripWS($I_Rec, 3)
		$i_Rec_Param = StringLeft($I_Rec, StringInStr($I_Rec, "=") - 1)
		$i_Rec_Param = StringStripWS($i_Rec_Param, 3)
		$i_Rec_Value = StringTrimLeft($I_Rec, StringInStr($I_Rec, "="))
		$i_Rec_Value = StringStripWS($i_Rec_Value, 3)
		; we added AutoIt3Wrapper_ for clearity to the compiler directives.
		If Not $Found_Old_Compiler And StringLeft($I_Rec, 10) = "#Compiler_" Then $Found_Old_Compiler = 1
		If StringLeft($I_Rec, 15) = "#Run_Debug_Mode" Then $Found_Old_Compiler = 2
		$i_Rec_Param = StringReplace($i_Rec_Param, "#Compiler_", "#AutoIt3Wrapper_")
		Select
			; ================ Other  =========================================================================
			Case $i_Rec_Param = "#Obfuscator_Parameters"
				$INP_Obfuscator_Parameters = $i_Rec_Value
			Case StringLeft($I_Rec, 12) = "#Obfuscator_"
				; skip other #obfuscator directives
			Case $i_Rec_Param = "#Tidy_Parameters"
				$INP_Tidy_Parameters = $i_Rec_Value
			Case StringLeft($I_Rec, 6) = "#Tidy_"
				; skip other #obfuscator directives
				; ================ AutoIt3/Aut2EXE  =========================================================================
			Case $i_Rec_Param = "#AutoIt3Wrapper_LogFile"
				$INP_AutoIt3Wrapper_LogFile = StringReplace($i_Rec_Value, '"', '')
			Case $i_Rec_Param = "#AutoIt3Wrapper_Prompt"
				; Obsolete..... Only override the command line when an actual value is given
			Case $i_Rec_Param = "#AutoIt3Wrapper_Compile_both"
				$INP_Compile_Both = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_OutFile"
				$ScriptFile_Out = StringReplace($i_Rec_Value, '"', '')
			Case $i_Rec_Param = "#AutoIt3Wrapper_OutFile_x64"
				$ScriptFile_Out_x64 = StringReplace($i_Rec_Value, '"', '')
			Case $i_Rec_Param = "#AutoIt3Wrapper_OutFile_x86"
				$ScriptFile_Out_x86 = StringReplace($i_Rec_Value, '"', '')
			Case $i_Rec_Param = "#AutoIt3Wrapper_OutFile_Type"
				$ScriptFile_Out_Type = $i_Rec_Value
				If $ScriptFile_Out_Type <> "A3X" And $ScriptFile_Out_Type <> "EXE" Then
					$ScriptFile_Out_Type = ""
					ConsoleWrite("- Skipping #Compiler_OutFile_Type directive. Invalid type:" & $i_Rec_Value & ". Can only be A3X or EXE" & @CRLF)
				Else
					; Only use the "#AutoIt3Wrapper_OutFile_Type" when "#AutoIt3Wrapper_OutFile" isn't given
					If $ScriptFile_Out = "" Then
						$ScriptFile_Out = StringTrimRight($ScriptFile_In, StringLen($ScriptFile_In_Ext)) & '.' & $ScriptFile_Out_Type
					EndIf
				EndIf
			Case $i_Rec_Param = "#AutoIt3Wrapper_Icon"
				$INP_Icon = StringReplace($i_Rec_Value, '"', '')
				$DebugIcon = $DebugIcon & "Comp directive icon: " & $INP_Icon & @CRLF
			Case $i_Rec_Param = "#AutoIt3Wrapper_Compression"
				$INP_Compression = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_PassPhrase"
;~ 				$INP_PassPhrase = $i_Rec_Value
;~ 				$INP_PassPhrase2 = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_Version"
				; Only use the compiler directive when the /prod or /beta is missing from the commandline
				If $INP_AutoIT3_Version = "" Then
					If $i_Rec_Value = "b" Or $i_Rec_Value = "beta" Then
						$INP_AutoIT3_Version = "beta"
						If Not StringInStr($ObfuscatorCmdLine, "/beta") Then $ObfuscatorCmdLine &= " /Beta"
					Else
						$INP_AutoIT3_Version = "prod"
					EndIf
				EndIf
			Case $i_Rec_Param = "#AutoIt3Wrapper_Autoit3Dir"
				If StringReplace($i_Rec_Value, '"', '') <> "" Then
					$INP_AutoitDir = StringReplace($i_Rec_Value, '"', '')
					If Not FileExists($INP_AutoitDir) Then
						ConsoleWrite("- Skipping #AutoIt3Wrapper_Autoit3Dir because the Directory is not found:" & $INP_AutoitDir & @CRLF)
						$INP_AutoitDir = ""
					ElseIf Not StringInStr(FileGetAttrib($INP_AutoitDir), "D") Then
						ConsoleWrite("- Skipping #AutoIt3Wrapper_AUTOIT3 because it is not a direcoty:" & $INP_AutoitDir & @CRLF)
						$INP_AutoitDir = ""
					EndIf
				EndIf
			Case $i_Rec_Param = "#AutoIt3Wrapper_AUTOIT3"
				If StringReplace($i_Rec_Value, '"', '') <> "" Then
					$AutoIT3_PGM = StringReplace($i_Rec_Value, '"', '')
					If Not FileExists($AutoIT3_PGM) Then
						ConsoleWrite("- Skipping #AutoIt3Wrapper_AUTOIT3 because the file is not found:" & $AutoIT3_PGM & @CRLF)
						$AutoIT3_PGM = ""
					EndIf
				EndIf
			Case $i_Rec_Param = "#AutoIt3Wrapper_AU3Check_Dat"
				; Obsolete..... Only override the command line when an actual value is given
			Case $i_Rec_Param = "#AutoIt3Wrapper_AUT2EXE"
				If StringReplace($i_Rec_Value, '"', '') <> "" Then
					$AUT2EXE_PGM = StringReplace($i_Rec_Value, '"', '')
					If Not FileExists($AUT2EXE_PGM) Then
						ConsoleWrite("- Skipping #AutoIt3Wrapper_AUT2EXE because the file is not found:" & $AUT2EXE_PGM & @CRLF)
						$AUT2EXE_PGM = ""
					EndIf
				EndIf
			Case $i_Rec_Param = "#AutoIt3Wrapper_UseUpx"
				$INP_UseUpx = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_UPX_Parameters"
				$INP_Upx_Parameters = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_UseAnsi"
				ConsoleWrite("- Skipping #AutoIt3Wrapper_UseAnsi directive because ANSI is not supported anymore." & @CRLF)
				$INP_UseAnsi = "N"
			Case $i_Rec_Param = "#AutoIt3Wrapper_UseX64"
				$INP_UseX64 = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_Allow_Decompile"
				; Obsolete.....  $INP_Allow_Decompile = $i_Rec_Value
			Case $i_Rec_Param = "#Run_Debug_Mode" Or $i_Rec_Param = "#AutoIt3Wrapper_Run_Debug_Mode"
				If $i_Rec_Value = "y" Or $i_Rec_Value = 1 Then $INP_Run_Debug_Mode = 1
			Case $i_Rec_Param = "#AutoIt3Wrapper_run_debug"
				; debug on or off direction
				; ================ Resources  =========================================================================
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_Language"
				$INP_Res_Language = Number($i_Rec_Value)
				If $INP_Res_Language = 0 Then $INP_Res_Language = 2057
				$INP_Resource_Version = 1
				$INP_Resource = 1
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_Comment"
				$INP_Comment = $i_Rec_Value
				$INP_Resource_Version = 1
				$INP_Resource = 1
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_Description"
				$INP_Description = $i_Rec_Value
				$INP_Resource_Version = 1
				$INP_Resource = 1
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_Fileversion"
				$INP_Fileversion = $i_Rec_Value
				$INP_Resource_Version = 1
				$INP_Resource = 1
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_FileVersion_AutoIncrement"
				$INP_Fileversion_AutoIncrement = $i_Rec_Value
				$INP_Resource_Version = 1
				$INP_Resource = 1
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_ProductVersion"
				$INP_ProductVersion = $i_Rec_Value
				$INP_Resource_Version = 1
				$INP_Resource = 1
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_LegalCopyright"
				$INP_LegalCopyright = $i_Rec_Value
				$INP_Resource_Version = 1
				$INP_Resource = 1
				; limited number of free format resource info fields
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_Icon_Add"
				If $i_Rec_Value <> "" Then
					$INP_Icons_cnt += 1
					ReDim $INP_Icons[$INP_Icons_cnt + 1]
					$INP_Icons[$INP_Icons_cnt] = Convert_Variables(StringReplace($i_Rec_Value, '"', ''))
					$IconFileInfo = StringSplit($INP_Icons[$INP_Icons_cnt], ",")
					If Not FileExists($IconFileInfo[1]) Then
						ConsoleWrite("- Skipping #AutoIt3Wrapper_Res_Icon_Add because the Ico file is not found:" & $INP_Icons[$INP_Icons_cnt] & @CRLF)
						$INP_Icons_cnt -= 1
					Else
						$INP_Resource = 1
					EndIf
				EndIf
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_File_Add"
				If $i_Rec_Value <> "" Then
					$INP_Res_Files_Cnt += 1
					ReDim $INP_Res_Files[$INP_Res_Files_Cnt + 1]
					$INP_Res_Files[$INP_Res_Files_Cnt] = Convert_Variables(StringReplace($i_Rec_Value, '"', ''))
					Local $ResFileInfo
					$ResFileInfo = StringSplit($INP_Res_Files[$INP_Res_Files_Cnt], ",")
					If Not FileExists($ResFileInfo[1]) Then
						ConsoleWrite("- Skipping #AutoIt3Wrapper_Res_File_Add because the file is not found:" & $INP_Res_Files[$INP_Res_Files_Cnt] & @CRLF)
						$INP_Res_Files_Cnt -= 1
					Else
						$INP_Resource = 1
					EndIf
				EndIf
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_SaveSource"
				$INP_Res_SaveSource = $i_Rec_Value
				$INP_Resource = 1
				; ================ Other =========================================================================
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_Field"
				$Temp_Val = StringSplit($i_Rec_Value, "|")
				If $INP_RES_FieldCount > 14 Then
					ConsoleWrite("- Skipping #Compiler_Res_Field directive. You can only have 15 field max:" & $i_Rec_Value & @CRLF)
				ElseIf $Temp_Val[0] <> 2 Then
					ConsoleWrite("- Skipping #Compiler_Res_Field directive. Doesn't have a | in it:" & $i_Rec_Value & @CRLF)
				Else
					$INP_RES_FieldCount = $INP_RES_FieldCount + 1
					$INP_FieldName[$INP_RES_FieldCount] = $Temp_Val[1]
					$INP_FieldValue[$INP_RES_FieldCount] = $Temp_Val[2]
				EndIf
				$INP_Resource_Version = 1
				$INP_Resource = 1
				; Old format for Resource fields
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_Field1Value"
				$INP_FieldValue1 = $i_Rec_Value
				$INP_Resource_Version = 1
				$INP_Resource = 1
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_Field1Name"
				$INP_FieldName1 = $i_Rec_Value
				$INP_Resource_Version = 1
				$INP_Resource = 1
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_Field2Value"
				$INP_FieldValue2 = $i_Rec_Value
				$INP_Resource_Version = 1
				$INP_Resource = 1
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_Field2Name"
				$INP_FieldName2 = $i_Rec_Value
				$INP_Resource_Version = 1
				$INP_Resource = 1
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_requestedExecutionLevel"
				;None, asInvoker, highestAvailable or requireAdministrator   (default=None)"
				Switch $i_Rec_Value
					Case ""
						$INP_RES_requestedExecutionLevel = ""
					Case "asInvoker", "highestAvailable", "requireAdministrator", "None"
						$INP_RES_requestedExecutionLevel = $i_Rec_Value
						$INP_Resource = 1
					Case Else
						$INP_RES_requestedExecutionLevel = ""
						ConsoleWrite("- Skipping #AutoIt3Wrapper_res_requestedExecutionLevel directive. Invalid value:" & $i_Rec_Value & @CRLF)
				EndSwitch
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_HiDpi"
				Switch $i_Rec_Value
					Case "", "0", "no"
						$INP_RES_HiDpi = ""
					Case "1", "yes"
						$INP_RES_HiDpi = $i_Rec_Value
						$INP_Resource = 1
					Case Else
						$INP_RES_HiDpi = ""
						ConsoleWrite("- Skipiing #AutoIt3Wrapper_res_HiDpi directive. Invalid value:" & $i_Rec_Value & @CRLF)
				EndSwitch


			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_Compatibility"
				$INP_RES_Compatibility = $i_Rec_Value
				$Temp_Val = StringSplit($i_Rec_Value, ",")
				For $x = 1 To $Temp_Val[0]
					;None, Vista, Windows7 or both   (default=None)"
					Switch $Temp_Val[$x]
						Case "", "None"
							$INP_RES_Compatibility = ""
							$INP_Resource = 1
						Case "Vista", "Windows7"
							$INP_Resource = 1
						Case Else
							ConsoleWrite("- Skipping #AutoIt3Wrapper_res_Compatibility directive invalid value:" & $Temp_Val & @CRLF)
					EndSwitch
				Next
			Case $i_Rec_Param = "#AutoIt3Wrapper_Run_AU3Check"
				$INP_Run_AU3Check = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_AU3Check_Parameters"
				$INP_AU3Check_Parameters = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_AU3Check_Stop_OnWarning"
				$INP_AU3Check_Stop_OnWarning = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_Run_Tidy"
				$INP_Run_Tidy = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_Run_Obfuscator"
				$INP_Run_Obfuscator = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_Tidy_Stop_OnError"
				$INP_Tidy_Stop_OnError = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_Run_Before"
				$INP_Run_Before = $INP_Run_Before & $i_Rec_Value & "|"
			Case $i_Rec_Param = "#AutoIt3Wrapper_Run_After"
				$INP_Run_After = $INP_Run_After & $i_Rec_Value & "|"
			Case $i_Rec_Param = "#AutoIt3Wrapper_Run_cvsWrapper"
				$INP_Run_cvsWrapper = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_cvsWrapper_Parameters"
				$INP_cvsWrapper_Parameters = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_PlugIn_Funcs"
				$INP_Plugin = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_Change2CUI"
				$INP_Change2CUI = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_Add_Constants"
				$INP_Add_Constants = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_ShowGui"
				$ShowGUI = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_Run_SciTE_Minimized"
				$INP_Run_SciTE_Minimized = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_Run_SciTE_OutputPane_Minimized"
				$INP_Run_SciTE_OutputPane_Minimized = $i_Rec_Value
			Case Else
				MsgBox(262144 + 32, 'Invalid Autoit3Wrapper directive', 'Keyword:' & $i_Rec_Param & @LF & 'Value:' & $i_Rec_Value)
		EndSelect
	Next
	If $Found_Old_Compiler Then
		If MsgBox(262144 + 4096 + 4, "AutoIt3Wrappper", "Found OLD #Compiler Directives." & @LF & _
				"Do you want to updated your script to #AutoIt3Wrapper Directives?", 10) = 6 Then
			Local $ScriptSource = FileRead($ScriptFile_In)
			$ScriptSource = StringReplace($ScriptSource, "#Compiler_", "#AutoIt3Wrapper_")
			$ScriptSource = StringReplace($ScriptSource, "#Run_Debug_Mode", "#AutoIt3Wrapper_Run_Debug_Mode")
			$Fh = FileOpen($ScriptFile_In, 2 + $SrceUnicodeFlag)
			FileWrite($Fh, $ScriptSource)
			FileClose($Fh)
			ConsoleWrite('>Updated the directives from "#Compiler_" to "#AutoIt3Wrapper_" ...' & @CRLF)
;~ 			EndIf
		EndIf
	EndIf
EndFunc   ;==>Retrieve_PreProcessor_Info
;
Func RunAutoItDebug($sFileToDebug, ByRef $sDebugFile)
	; Klaatu on AutoIt3 forum
	; DebugIt.au3  http://www.autoitscript.com/forum/index.php?s=&showtopic=35218&view=findpost&p=258014
	;
	; Version 1.0 - initial release
	;
	; Run an AutoIt script, outputing each line executed to a window.
	;
	; Syntax 1:
	;    AutoIt3 DebugIt.au3 yourscript.au3 params
	; Syntax 2:
	;    DebugIt.exe yourscript.au3 params
	;
	; Run DebugIt - choose a file - the script will then write out a file called
	; filename_DebugIt.au3 This file should be identical to your script except that
	; before every line of code there is an instruction to write out the original
	; script line to a control in a window we create.
	; If the script crashes out - or whatever - you just look at the the last line
	; written out to indicate where the script crashed.
	;
	; You can prevent any particular section of code (such as an AdLib function)
	; from having debug code added by placing a line with just ";debug" before and
	; after the section.
	;
	; NOTE: Requires AutoIt 3.2+!!!
	;
	Local $fhFileToDebug, $fhDebugFile
	Local $iLineNumber, $sCurrentLine, $sComment, $sModifiedLine, $bDebugging
	Local $sRandom = '', $sIndent, $sTitle, $x
	Local $sDrive, $sDir, $sFName, $iSavedLine, $I_Rec, $i_Rec_Param, $i_Rec_Value

	_PathSplit($sFileToDebug, $sDrive, $sDir, $sFName, $x)
	; The title of our debug window will be the filename portion only, but with "_DebugIt" added.
	$sTitle = $sFName & '_DebugIt'
	; Our temporary script will use this title for its name. We also make sure to create the
	; temporary script in the same folder as the original, in case it relies on other things
	; being found relative to where it is.
	$sDebugFile = _PathMake($sDrive, $sDir, $sTitle, $x)
	; We use a Random 8 character string for 2 purposes:
	;   1) to almost guarantee that the variables we add to the script don't conflict
	;      with the script's own variables, and
	;   2) to make sure we're communicating with one and only one debug window, as we
	;      look for this random string to be text in the window we want to communicate with.
	While StringLen($sRandom) < 8
		$sRandom &= Chr(Round(Random(97, 122), 0))
	WEnd
	$fhDebugFile = FileOpen($sDebugFile, 2)
	If @error Then
		MsgBox(0, @ScriptName, 'File ' & $sDebugFile & ' could not be opened')
		Exit (3)
	EndIf
	;
	FileWriteLine($fhDebugFile, "Global $__err" & $sRandom & "[2] = [0, 0]")
	$fhFileToDebug = FileOpen($sFileToDebug, 0)
	$iLineNumber = 1
	$bDebugging = True
	While True
		$iSavedLine = $iLineNumber
		$sCurrentLine = FileReadLine($fhFileToDebug)
		If @error = -1 Then ExitLoop
		; Handle continuation lines. This does need to be more sophisticated to handle
		; comments that follow line continuations; right now it's pretty basic.
		While StringRight($sCurrentLine, 2) = ' _'
			$sCurrentLine = StringTrimRight($sCurrentLine, 1)
			$iLineNumber += 1
			$sCurrentLine &= StringStripWS(FileReadLine($fhFileToDebug, $iLineNumber), 1)
			If @error = -1 Then ExitLoop
		WEnd
		; look for lines that tell us whether to stop or start adding debugging to the script
		; there's no special code to watch for #cs/#ce blocks, as it actually doesn't matter;
		; debug code will be added to these blocks, but so what?
		$I_Rec = StringStripWS($sCurrentLine, 3)
		If StringLeft($I_Rec, 26) = "#AutoIt3Wrapper_run_debug=" Then
			$i_Rec_Param = StringLeft($I_Rec, StringInStr($I_Rec, "=") - 1)
			$i_Rec_Param = StringStripWS($i_Rec_Param, 3)
			$i_Rec_Value = StringTrimLeft($I_Rec, StringInStr($I_Rec, "="))
			$i_Rec_Value = StringStripWS($i_Rec_Value, 3)
			Switch $i_Rec_Value
				Case "on"
					$bDebugging = 1
				Case "off"
					$bDebugging = 0
				Case Else
			EndSwitch
			$iLineNumber += 1
			FileWriteLine($fhDebugFile, $sCurrentLine)
			ContinueLoop
		EndIf
		If StringStripWS($sCurrentLine, 8) = ";debug" Then
			$bDebugging = Not $bDebugging
			$iLineNumber += 1
			FileWriteLine($fhDebugFile, $sCurrentLine)
			ContinueLoop
		EndIf
		;
		If $bDebugging Then
			; Turn all single quotes into double quotes so we can use single quotes to delimit the
			; line when adding it to the debugging script.
			$sModifiedLine = StringReplace($sCurrentLine, "'", '"')
			$sComment = StringStripWS(StringLeft($sModifiedLine, StringInStr($sModifiedLine, ";", -1)), 3)
			If Not ($sComment = ";") And Not (StringStripWS($sCurrentLine, 3) = "") Then
				; Proper indenting is not really needed, but it makes the temporary script
				; look a hell of a lot better if someone needs to look at it for some reason.
				$sIndent = ''
				While StringIsSpace(StringLeft($sCurrentLine, StringLen($sIndent) + 1))
					$sIndent = StringLeft($sCurrentLine, StringLen($sIndent) + 1)
				WEnd
				; First we save the values of @Error and @Extended, then add our command that
				; updates the Edit control on our form with the script's current line, then we
				; restore @Error and @Extended to what they were. This guarantees that the
				; original script's code that relies on these values will continue to execute
				; as intended.
				FileWriteLine($fhDebugFile, StringFormat("%sDim $__err%s[2] = [@Error, @Extended]", $sIndent, $sRandom))
				; FileWriteLine($fhDebugFile, StringFormat("%sControlSetText('%s', '%s', 'Edit1', ControlGetText('%s', '%s', 'Edit1') & @CRLF & '%04u: %s')", $sIndent, $sTitle, $sRandom, $sTitle, $sRandom, $iLineNumber, $sModifiedLine))
				;FileWriteLine($fhDebugFile, StringFormat("%sControlCommand('%s', '%s', 'Edit1', 'EditPaste', '%04u: %s' & @CRLF)", $sIndent, $sTitle, $sRandom, $iSavedLine, $sModifiedLine))
				FileWriteLine($fhDebugFile, StringFormat("%sConsoleWrite('%04u: ' & $__err%s[0] & '-' & $__err%s[1] & ': %s' & @CRLF)", $sIndent, $iSavedLine, $sRandom, $sRandom, $sModifiedLine))
				FileWriteLine($fhDebugFile, StringFormat("%sSetError($__err%s[0], $__err%s[1])", $sIndent, $sRandom, $sRandom))
			EndIf
		EndIf
		FileWriteLine($fhDebugFile, $sCurrentLine)
		$iLineNumber += 1
	WEnd
	FileWriteLine($fhDebugFile, $sCurrentLine)
	FileClose($fhFileToDebug)
	FileClose($fhDebugFile)
EndFunc   ;==>RunAutoItDebug
; Validate/Translate/Set Input field value
Func SetDefaults(ByRef $fieldval, $default, $translate = "", $valid = "", $Number = 0, $Case = 0)
;~ 	ConsoleWrite('@@ ######## start Setdefaults : $fieldval = ' & $fieldval & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	Local $tarray, $varray, $IsValid
	If $fieldval = "" Then
		$fieldval = $default
	ElseIf $translate <> "" Then
		$tarray = StringSplit($translate, ";")
		For $x = 1 To $tarray[0]
			$varray = StringSplit($tarray[$x], "=")
			If $varray[0] > 1 And $varray[1] = $fieldval Then $fieldval = $varray[2]
		Next
	EndIf
;~ 	ConsoleWrite('@@ after translate : $fieldval = ' & $fieldval & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	If $valid <> "" Then
		$IsValid = False
		$tarray = StringSplit($valid, ";")
		For $x = 1 To $tarray[0]
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $tarray[$x] = ' & $tarray[$x] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			If (StringLower($tarray[$x]) == StringLower($fieldval) And $Case = 0) Or ($tarray[$x] == $fieldval And $Case = 1) Then
				$IsValid = True
;~ 				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $IsValid = ' & $IsValid & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
				ExitLoop
			EndIf
		Next
		If $IsValid = False Then
			$fieldval = $default
		EndIf
	EndIf
;~ 	ConsoleWrite('@@ After validate: $fieldval = ' & $fieldval & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	If $Number Then $fieldval = Number($fieldval)
;~ 	ConsoleWrite('@@ after number : $fieldval = ' & $fieldval & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
EndFunc   ;==>SetDefaults
;
Func Show_Warnings($Warning_TiTle, $Warning_Text)
	GUICreate($Warning_TiTle, 700, 310, -1, -1, $WS_SIZEBOX + $WS_SYSMENU + $WS_MINIMIZEBOX)
	GUICtrlCreateLabel("Do you want to stop the " & $Option & "?", 5, 257, 180, 20)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKSIZE)
	Local $H_Yes = GUICtrlCreateButton("Stop", 280, 253, 60, 25)
	GUICtrlSetResizing($H_Yes, $GUI_DOCKBOTTOM + $GUI_DOCKSIZE + $GUI_DOCKHCENTER)
	Local $H_No = GUICtrlCreateButton("Continue anyway", 360, 253, 100, 25)
	GUICtrlSetResizing($H_No, $GUI_DOCKBOTTOM + $GUI_DOCKSIZE + $GUI_DOCKHCENTER)
	GUISetFont(9, 400, 0, "Courier New")
	GUICtrlCreateEdit(StringReplace($Warning_Text, @LF, @CRLF), 5, 5, 690, 240, BitOR($ES_WANTRETURN, $WS_VSCROLL, $WS_HSCROLL, $ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY))
	GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)
	GUICtrlSetBkColor(-1, 0xFFEFEF)
	GUICtrlSetState($H_Yes, $GUI_FOCUS)
	GUISetState(@SW_SHOW) ; Process GUI Input
	; Process GUI Input
	;-------------------------------------------------------------------------------------------
	While 1
		$rc = GUIGetMsg()
		Sleep(10)
		If $rc = 0 Then ContinueLoop
		; Cancel clicked
		If $rc = $H_Yes Then Exit
		If $rc = $H_No Then ExitLoop
		If $rc = -3 Then Exit
	WEnd
	GUIDelete()
EndFunc   ;==>Show_Warnings
;
Func ShowStdOutErr($l_Handle, $ShowConsole = 1, $Replace = "", $ReplaceWith = "")
	Local $Line = "x", $Line2 = "x", $tot_out, $err1 = 0, $err2 = 0
	Do
		Sleep(10)
		$Line = StdoutRead($l_Handle)
		$err1 = @error
		If $Replace <> "" Then $Line = StringReplace($Line, $Replace, $ReplaceWith)
		$tot_out &= $Line
		If $ShowConsole Then ConsoleWrite($Line)
		$Line2 = StderrRead($l_Handle)
		$err2 = @error
		If $Replace <> "" Then $Line2 = StringReplace($Line2, $Replace, $ReplaceWith)
		$tot_out &= $Line2
		If $ShowConsole Then ConsoleWrite($Line2)
	Until ($err1 And $err2)
	Return $tot_out
EndFunc   ;==>ShowStdOutErr
;
Func Valid_FileVersion($i_FileVersion, $IsFileVersion = 1)
	Local $T_Numbers = StringSplit($i_FileVersion, ".")
	If $T_Numbers[0] > 4 Then
		ConsoleWrite("- RC Invalid FileVersion :" & $i_FileVersion & ", contains more then 4 numbers.... Changed to:" & $AUT2EXE_PGM_VER & @CRLF)
		Return $AUT2EXE_PGM_VER
	EndIf
	;
	If $T_Numbers[0] < 4 Then ReDim $T_Numbers[5]
	For $x = 1 To 4
		If $T_Numbers[$x] = '' Then $T_Numbers[$x] = 0
		If Not ($T_Numbers[$x] == Number($T_Numbers[$x])) Then
			ConsoleWrite("! Invalid FileVersion value " & $x & "=" & $T_Numbers[$x] & ". It will be changed to:" & Number($T_Numbers[$x]) & @CRLF)
			$T_Numbers[$x] = Number($T_Numbers[$x])
		EndIf
	Next
	If $IsFileVersion Then
		; Auto Increment when requested
		If $INP_Fileversion_AutoIncrement <> "n" Then
			$INP_Fileversion_New = $T_Numbers[1] & "." & $T_Numbers[2] & "." & $T_Numbers[3] & "." & $T_Numbers[4] + 1
		EndIf
	EndIf
	Return $T_Numbers[1] & "." & $T_Numbers[2] & "." & $T_Numbers[3] & "." & $T_Numbers[4]
EndFunc   ;==>Valid_FileVersion
;
; Write colored console message..
Func Write_RC_Console_Msg($text, $rc = "", $symbol = "", $Time = 1)
	If $Time Then $text = @HOUR & ":" & @MIN & ":" & @SEC & " " & $text
	If $symbol <> "" Then
		If $rc == "" Then
			ConsoleWrite($symbol & ">" & $text & @CRLF)
		Else
			ConsoleWrite($symbol & ">" & $text & "rc:" & $rc & @CRLF)
		EndIf
	Else
		If $rc == "" Then
			ConsoleWrite(">" & $text & @CRLF)
		Else
			Switch $rc
				Case 0
					ConsoleWrite("+>" & $text & "rc:" & $rc & @CRLF)
				Case 1
					ConsoleWrite("->" & $text & "rc:" & $rc & @CRLF)
				Case Else
					ConsoleWrite("!>" & $text & "rc:" & $rc & @CRLF)
			EndSwitch
		EndIf
	EndIf
EndFunc   ;==>Write_RC_Console_Msg
#endregion Functions
#region SciTE Functions
; Received Data from SciTE
Func MY_WM_COPYDATA($hWnd, $msg, $wParam, $lParam)
	#forceref $hWnd, $msg,  $wParam
	Local $COPYDATA = DllStructCreate('Ptr;DWord;Ptr', $lParam)
	Local $SciTECmdLen = DllStructGetData($COPYDATA, 2)
	Local $CmdStruct = DllStructCreate('Char[255]', DllStructGetData($COPYDATA, 3))
	$SciTECmd = StringLeft(DllStructGetData($CmdStruct, 1), $SciTECmdLen)
;~ 	ConsoleWrite('<--' & $SciTECmd & @CRLF)
EndFunc   ;==>MY_WM_COPYDATA
;
Func SendSciTE_Command($My_Hwnd, $SciTE_hwnd, $sCmd)
	Local $WM_COPYDATA = 74
	Local $CmdStruct = DllStructCreate('Char[' & StringLen($sCmd) + 1 & ']')
	DllStructSetData($CmdStruct, 1, $sCmd)
	Local $COPYDATA = DllStructCreate('Ptr;DWord;Ptr')
	DllStructSetData($COPYDATA, 1, 1)
	DllStructSetData($COPYDATA, 2, StringLen($sCmd) + 1)
	DllStructSetData($COPYDATA, 3, DllStructGetPtr($CmdStruct))
	DllCall('User32.dll', 'None', 'SendMessageA', 'HWnd', $SciTE_hwnd, _
			'Int', $WM_COPYDATA, 'HWnd', $My_Hwnd, _
			'Ptr', DllStructGetPtr($COPYDATA))
;~ 	ConsoleWrite('-->' & $sCmd & @CRLF)
EndFunc   ;==>SendSciTE_Command
;
Func SendSciTE_GetInfo($My_Hwnd, $SciTE_hwnd, $sCmd)
	$sCmd = ":" & $My_Dec_Hwnd & ":" & $sCmd
	$SciTECmd = ""
	SendSciTE_Command($My_Hwnd, $SciTE_hwnd, $sCmd)
	For $x = 1 To 10
		If $SciTECmd <> "" Then ExitLoop
		Sleep(20)
	Next
	$SciTECmd = StringTrimLeft($SciTECmd, StringLen(":" & $My_Dec_Hwnd & ":"))
	$SciTECmd = StringReplace($SciTECmd, "macro:stringinfo:", "")
	Return $SciTECmd
EndFunc   ;==>SendSciTE_GetInfo
#endregion SciTE Functions
#region GUI Functions
Func DirGetRelativePath($source, $target)
	; This UDF will get the relative Path to the file ... written by JdeB
	$source = StringReplace($source, "/", "\")
	$target = StringReplace($target, "/", "\")
	Local $sz_sDrive, $sz_sDir, $sz_sFName, $sz_sExt
	Local $sz_tDrive, $sz_tDir, $sz_tFName, $sz_tExt
	_PathSplit($source, $sz_sDrive, $sz_sDir, $sz_sFName, $sz_sExt)
	_PathSplit($target, $sz_tDrive, $sz_tDir, $sz_tFName, $sz_tExt)
	If $sz_sDrive <> $sz_tDrive Then
		Return $target
	EndIf
	;
	Local $a_sDir = StringSplit($sz_sDir, "\")
	Local $a_tDir = StringSplit($sz_tDir, "\")
	For $x = 1 To $a_sDir[0]
		If $a_sDir[$x] <> $a_tDir[$x] Then ExitLoop
	Next
	Local $R_Path = ""
	For $y = $x To $a_sDir[0] - 1
		$R_Path &= "..\"
	Next
	For $y = $x To $a_tDir[0] - 1
		$R_Path &= $a_tDir[$y] & "\"
	Next
	$R_Path &= $sz_tFName & $sz_tExt
	Return $R_Path
EndFunc   ;==>DirGetRelativePath
; Func to retrieve field content from GUI and check if it changed
Func GUI_GetValue($GUI_Ctrl_Hnd, ByRef $Current_Val, $translate = "")
	Local $GUI_Val = GUICtrlRead($GUI_Ctrl_Hnd)
	; Translate read value if needed
	Local $tarray = StringSplit($translate, ";")
	Local $varray
	For $x = 1 To $tarray[0]
		$varray = StringSplit($tarray[$x], "=")
		If $varray[0] > 1 And $varray[1] = $GUI_Val Then $GUI_Val = $varray[2]
	Next
	;
	If String($Current_Val) = String($GUI_Val) Then
		Return 0
	Else
		$Current_Val = $GUI_Val
		Return 1
	EndIf
EndFunc   ;==>GUI_GetValue
;
Func GUI_Show()
	; GUI Definition
	;-------------------------------------------------------------------------------------------
;~ 	Local $H_Comment, $H_Description, $H_Fileversion, $H_Fileversion_AutoIncrement_n, $H_Fileversion_AutoIncrement_p, $H_Fileversion_AutoIncrement_y
;~ 	local $H_LegalCopyright, $H_FieldNameEdit, $H_Res_Language
	Opt("GUICoordMode", 1)
	GUICreate("AutoIt3Wrapper GUI to Compile AutotIt3 Script (ver " & $VERSION & ")", 650, 500, (@DesktopWidth - 650) / 2, (@DesktopHeight - 500) / 2)
	GUISetHelp('"' & @WindowsDir & '\hh.exe" "' & @ScriptDir & '\..\Scite4AutoIt3.chm::/AutoIt3Wrapper.htm"')
	Local $h_File = GUICtrlCreateMenu("&File")
	Local $h_Exit = GUICtrlCreateMenuItem("&Exit", $h_File)
	Local $h_Help = GUICtrlCreateMenu("&Help")
	Local $h_HelpFile = GUICtrlCreateMenuItem("&Help", $h_Help)
	Local $h_About = GUICtrlCreateMenuItem("&About", $h_Help)
	Local $Init_Dir, $tempval
	Local $szDrive, $szDir, $szFName, $szExt
	Local $tab = GUICtrlCreateTab(10, 10, 630, 430)
	;=========================================================================================================================================
	Local $tab0 = GUICtrlCreateTabItem("AutoIt3/Aut2Exe")
	GUICtrlCreateLabel("Autoit3 version to use:", 30, 60, 110)
	GUIStartGroup()
	Local $H_AUTOIT3_Version_P = GUICtrlCreateRadio("Production:", 150, 57)
	Local $H_AUTOIT3_Version_B = GUICtrlCreateRadio("Beta:", 150, 77)
	GUICtrlCreateLabel("Ver:" & FileGetVersion($CurrentAutoIt_InstallDir & "\aut2exe\AutoitSC.bin"), 230, 60, 70, 20)
	GUICtrlCreateLabel("Ver:" & FileGetVersion($CurrentAutoIt_InstallDir & "\Beta\aut2exe\AutoitSC.bin"), 230, 80, 70, 20)
	If $INP_AutoIT3_Version = "beta" Then
		GUICtrlSetState($H_AUTOIT3_Version_B, $GUI_CHECKED)
	Else
		GUICtrlSetState($H_AUTOIT3_Version_P, $GUI_CHECKED)
	EndIf
	;
	GUICtrlCreateLabel("Source:", 30, 105, 65, 20, $SS_RIGHT)
	GUICtrlCreateLabel($ScriptFile_In, 100, 105, 500, 20, BitOR($WS_BORDER, $SS_LEFTNOWORDWRAP, $SS_NOPREFIX))
	;
	GUICtrlCreateLabel("Output type:", 30, 130, 65, 20, $SS_RIGHT)
	GUIStartGroup()

	Local $H_Out_Type_e = GUICtrlCreateRadio("EXE:", 100, 130)
	Local $H_Out_Type_a = GUICtrlCreateRadio("A3X:", 150, 130)
	GUIStartGroup()
	If $ScriptFile_Out_Type = "a3x" Then
		GUICtrlSetState($H_Out_Type_a, $GUI_CHECKED)
	Else
		GUICtrlSetState($H_Out_Type_e, $GUI_CHECKED)
	EndIf
	;
	GUICtrlCreateLabel("Target x86:", 30, 155, 65, 20, $SS_RIGHT)
	;$ScriptFile_Out = DirGetRelativePath($ScriptFile_In,$ScriptFile_Out)
	Local $H_SCRIPTFILE_OUT = GUICtrlCreateInput($ScriptFile_Out, 100, 155, 440, 20)
	Local $H_SCRIPTFILE_OUT_CHANGE = GUICtrlCreateButton("...", 542, 155, 40, 20)
	GUICtrlCreateLabel("Target x64:", 30, 180, 65, 20, $SS_RIGHT)
	Local $H_SCRIPTFILE_OUT_X64 = GUICtrlCreateInput($ScriptFile_Out_x64, 100, 180, 440, 20)
	Local $H_SCRIPTFILE_OUT_CHANGE_X64 = GUICtrlCreateButton("...", 542, 180, 40, 20)
	;
	GUICtrlCreateLabel("Icon:", 30, 207, 65, 20, $SS_RIGHT)
	Local $H_INP_ICON_ICO = 0
	Local $AutoIt_Icon = RegRead("HKCR\AutoIt3Script\DefaultIcon", "")
	Local $AutoIt_Icon_Dir = StringLeft($AutoIt_Icon, StringInStr($AutoIt_Icon, "\", 0, -1))
	If FileExists($INP_Icon) Or FileExists($AutoIt_Icon_Dir & $INP_Icon) Then
		$H_INP_ICON_ICO = GUICtrlCreateIcon($INP_Icon, Default, 545, 230)
	Else
		ConsoleWrite("->Icon not found:" & _PathFull($INP_Icon) & @CRLF)
	EndIf
	;$INP_Icon = DirGetRelativePath($ScriptFile_In,$INP_Icon)
	Local $H_INP_ICON = GUICtrlCreateEdit($INP_Icon, 100, 205, 440, 20)
	Local $H_INP_ICON_CHANGE = GUICtrlCreateButton("...", 542, 205, 40, 20)
	;
	;
	GUICtrlCreateLabel("FileInstall Compression:", 20, 235, 120, 20) ;, $SS_RIGHT)
	Local $H_Compression = GUICtrlCreateCombo("", 142, 232, 170, 80, $CBS_DROPDOWNLIST)
	Local $INP_W_Compression = "Normal"
	If $INP_Compression = 0 Then $INP_W_Compression = "Lowest"
	If $INP_Compression = 1 Then $INP_W_Compression = "Low"
	If $INP_Compression = 2 Then $INP_W_Compression = "Normal"
	If $INP_Compression = 3 Then $INP_W_Compression = "High"
	If $INP_Compression = 4 Then $INP_W_Compression = "Highest"
	GUICtrlSetData($H_Compression, "Lowest|Low|Normal|High|Highest", $INP_W_Compression)
	;
;~ 	Global $H_AUTOIT3_Ansi = GUICtrlCreateCheckbox("Use ANSI version of AutoIt3/Aut2Exe (Only works up till AutoIt3 v 3.2.12.0", 100, 230)
;~ 	If $INP_UseAnsi = "y" Then GUICtrlSetState($H_AUTOIT3_Ansi, $GUI_CHECKED)
	;
;~ 	Global $H_AUTOIT3_X64 = GUICtrlCreateCheckbox("Use X64 version of AutoIt3/Aut2Exe", 100, 255)
;~ 	If $INP_UseX64 = "y" Then GUICtrlSetState($H_AUTOIT3_X64, $GUI_CHECKED)
	GUICtrlCreateLabel("Output arch:", 30, 265, 69)
	GUIStartGroup()
;~ 	Global $H_AUTOIT3_X86 = GUICtrlCreateRadio("Use X86 version.", 100, 255)
;~ 	Global $H_AUTOIT3_X64 = GUICtrlCreateRadio("Use X64 version.", 100, 272)
	Local $H_AUTOIT3_X86 = GUICtrlCreateCheckbox("Compile X86 version. (default)", 100, 255)
	Local $H_AUTOIT3_X64 = GUICtrlCreateCheckbox("Compile X64 version.", 100, 272)
	If $INP_UseX64 = "y" Then
		GUICtrlSetState($H_AUTOIT3_X64, $GUI_CHECKED)
	Else
		GUICtrlSetState($H_AUTOIT3_X86, $GUI_CHECKED)
	EndIf
	If $INP_Compile_Both = "y" Then
		GUICtrlSetState($H_AUTOIT3_X64, $GUI_CHECKED)
		GUICtrlSetState($H_AUTOIT3_X86, $GUI_CHECKED)
	EndIf
	;
	Local $H_AUTOIT3_Upx = GUICtrlCreateCheckbox("Use UPX", 100, 305)
	If $INP_UseUpx = "y" Then GUICtrlSetState($H_AUTOIT3_Upx, $GUI_CHECKED)
	;
	Local $H_Change2CUI = GUICtrlCreateCheckbox("Create CUI instead of GUI EXE.", 100, 330)
	If $INP_Change2CUI = "y" Then GUICtrlSetState($H_Change2CUI, $GUI_CHECKED)
	;
	Local $H_Add_Constants = GUICtrlCreateCheckbox("Add required Constants*.au3 to your script.", 100, 355)
	If $INP_Add_Constants = "y" Then GUICtrlSetState($H_Add_Constants, $GUI_CHECKED)
	; Help info
	GUICtrlSetTip($H_SCRIPTFILE_OUT, "Specify when a different outputfile is wanted. Default: scriptname.exe.")
;~ 	GUICtrlSetTip($H_INP_NODECOMPILE, "UNCheck to compile with a Random password.")
	GUICtrlSetTip($H_Compression, "Compression level used on the FileInstall() included files.")
;~ 	GUICtrlSetTip($H_AUTOIT3_Ansi, "Check to compile with the Ansi version when Win9x/Me support is needed.")
	GUICtrlSetTip($H_AUTOIT3_X86, "Check to compile with the X86 version of AutoIt3.")
	GUICtrlSetTip($H_AUTOIT3_X64, "Check to compile with the X64 version of AutoIt3.")
	GUICtrlSetTip($H_AUTOIT3_Upx, "Check to run UPX on the Output EXE.")
	GUICtrlSetTip($H_Add_Constants, "This will add all required Constands*.au3 includes to your Script. It will only run one time.")
	;=========================================================================================================================================
	Local $tab1 = GUICtrlCreateTabItem("Resource Update")
	; resource info
	Local $H_Res_L01 = GUICtrlCreateLabel("Comment:", 30, 60, 65, 20, $SS_RIGHT)
	$H_Comment = GUICtrlCreateInput($INP_Comment, 100, 45, 500, 35, 0x0004)
	;
	Local $H_Res_L02 = GUICtrlCreateLabel("Description:", 30, 87, 65, 20, $SS_RIGHT)
	$H_Description = GUICtrlCreateInput($INP_Description, 100, 85, 500, 20)
	If $INP_Fileversion <> "" Then $INP_Fileversion = Valid_FileVersion($INP_Fileversion)
	Local $H_Res_L03 = GUICtrlCreateLabel("FileVersion:", 30, 112, 65, 20, $SS_RIGHT)
	$H_Fileversion = GUICtrlCreateInput($INP_Fileversion, 100, 110, 100, 20)
	;
	$H_Fileversion_AutoIncrement_n = GUICtrlCreateRadio("Don't Auto Increment.", 210, 110, Default, Default, $WS_GROUP)
	$H_Fileversion_AutoIncrement_y = GUICtrlCreateRadio("Auto Increment", 340, 110)
	$H_Fileversion_AutoIncrement_p = GUICtrlCreateRadio("Prompt to Auto Increment", 450, 110)
	Switch $INP_Fileversion_AutoIncrement
		Case "y"
			GUICtrlSetState($H_Fileversion_AutoIncrement_y, $GUI_CHECKED)
		Case "p"
			GUICtrlSetState($H_Fileversion_AutoIncrement_p, $GUI_CHECKED)
		Case Else
			GUICtrlSetState($H_Fileversion_AutoIncrement_n, $GUI_CHECKED)
	EndSwitch
	;
	Local $H_Res_L04 = GUICtrlCreateLabel("LegalCopyright:", 21, 140, 74, 20, BitOR($SS_RIGHT, $WS_GROUP))
	$H_LegalCopyright = GUICtrlCreateInput($INP_LegalCopyright, 100, 135, 500, 20)
	;
	Local $H_Res_L05 = GUICtrlCreateLabel("Language:", 21, 165, 74, 20, $SS_RIGHT)
	$H_Res_Language = GUICtrlCreateCombo("", 100, 160, 500, 20, $CBS_DROPDOWNLIST)
	Local $CountryTable, $Country
	Language_Code($INP_Res_Language, $CountryTable, $Country, 1)
	GUICtrlSetData(-1, $CountryTable, $Country) ; add other item snd set a new default
	Local $INP_FieldNameEdit = ""
	For $U = 1 To $INP_RES_FieldCount
		$INP_FieldNameEdit &= $INP_FieldName[$U] & " = " & $INP_FieldValue[$U] & @CRLF
	Next
	; "asInvoker", "highestAvailable", "requireAdministrator"
	Local $H_Res_L06 = GUICtrlCreateLabel("RequestedExecutionLevel:", 21, 189, 76, 20, $SS_RIGHT)
	Local $H_Res_requestedExecutionLevel_d = GUICtrlCreateRadio("Default", 105, 186, Default, Default, $WS_GROUP)
	Local $H_Res_requestedExecutionLevel_a = GUICtrlCreateRadio("asInvoker", 160, 186)
	Local $H_Res_requestedExecutionLevel_h = GUICtrlCreateRadio("highestAvailable", 235, 186)
	Local $H_Res_requestedExecutionLevel_r = GUICtrlCreateRadio("requireAdministrator", 335, 186)
	Local $H_Res_requestedExecutionLevel_n = GUICtrlCreateRadio("None", 450, 186)
	Switch $INP_RES_requestedExecutionLevel
		Case "None"
			GUICtrlSetState($H_Res_requestedExecutionLevel_n, $GUI_CHECKED)
		Case "", "asInvoker"
			GUICtrlSetState($H_Res_requestedExecutionLevel_a, $GUI_CHECKED)
		Case "highestAvailable"
			GUICtrlSetState($H_Res_requestedExecutionLevel_h, $GUI_CHECKED)
		Case "requireAdministrator"
			GUICtrlSetState($H_Res_requestedExecutionLevel_r, $GUI_CHECKED)
		Case Else
			GUICtrlSetState($H_Res_requestedExecutionLevel_d, $GUI_CHECKED)
	EndSwitch
	;
	Local $H_Res_L07 = GUICtrlCreateLabel("Extra resource Fields:", 11, 230, 74, 40, BitOR($SS_RIGHT, $WS_GROUP))
	$H_FieldNameEdit = GUICtrlCreateEdit($INP_FieldNameEdit, 100, 210, 500, 180)
	;
	Local $H_Res_SaveSource = GUICtrlCreateCheckbox("Save a copy of the Scriptsource in the output program resources.", 100, 395)
	If $INP_Res_SaveSource = "y" Then GUICtrlSetState($H_Res_SaveSource, $GUI_CHECKED)
	;
	;=========================================================================================================================================
	Local $tab1b = GUICtrlCreateTabItem("Res Add Files")
	Local $H_Res_L08 = GUICtrlCreateLabel("Extra Icons:", 11, 80, 74, 40, $SS_RIGHT)
	Local $INP_Icons_txt = ""
	For $x = 1 To $INP_Icons_cnt
		$INP_Icons_txt &= $INP_Icons[$x] & @CRLF
	Next
	Local $H_Icons = GUICtrlCreateEdit($INP_Icons_txt, 100, 60, 500, 160)
	Local $H_Res_L09 = GUICtrlCreateLabel("Extra Files:", 11, 250, 74, 40, $SS_RIGHT)
	;
	Local $Inp_Res_Files_txt = ""
	For $x = 1 To $INP_Res_Files_Cnt
		$Inp_Res_Files_txt &= $INP_Res_Files[$x] & @CRLF
	Next
	Local $H_Res_Files = GUICtrlCreateEdit($Inp_Res_Files_txt, 100, 230, 500, 160)
	GUICtrlSetTip($H_Res_L06, "Specify the RequestedExecutionLevel to be set in the Program Manifest.")
	GUICtrlSetTip($H_Res_requestedExecutionLevel_d, "Use the default from AUT2EXE setting in the Program Manifest.")
	GUICtrlSetTip($H_Res_requestedExecutionLevel_a, "Specify the RequestedExecutionLevel to be set in the Program Manifest.")
	GUICtrlSetTip($H_Res_requestedExecutionLevel_h, "Specify the RequestedExecutionLevel to be set in the Program Manifest.")
	GUICtrlSetTip($H_Res_requestedExecutionLevel_r, "Specify the RequestedExecutionLevel to be set in the Program Manifest.")
	GUICtrlSetTip($H_Res_requestedExecutionLevel_n, "Remove the current RequestedExecutionLevel from the Program Manifest set by AUT2EXE.")
	GUICtrlSetTip($H_FieldNameEdit, 'Add extra Resource info. One per line.' & @CRLF & 'Syntax: Fieldname = Description.' & @CRLF & 'Example:Made By = Jos van der Zande')
	GUICtrlSetTip($H_Res_L07, 'Add extra Resource info. One per line.' & @CRLF & 'Syntax: Fieldname = Description.' & @CRLF & 'Example:Made By = Jos van der Zande')
	GUICtrlSetTip($H_Icons, "Specify additional Icons to be included in the programs resources." & @CRLF & "One file per line." & @CRLF & "(F1-see helpfile for details)")
	GUICtrlSetTip($H_Res_L09, "Specify additional Files to be included in the programs resources." & @CRLF & "One file per line. Format: Filename[,Section [,ResName]]" & @CRLF & "(F1-see helpfile for details)")
	GUICtrlSetTip($H_Res_Files, "Specify additional Files to be included in the programs resources." & @CRLF & "One file per line. Format: Filename[,Section [,ResName]]" & @CRLF & "(F1-see helpfile for details)")
	;=================================================================================================================================
	Local $tab2 = GUICtrlCreateTabItem("Run Before/After")
	; run before program
	GUICtrlCreateLabel("Specify here the commands to run before and after the Compilation process.", 50, 60, 500, 20)
	GUICtrlCreateLabel("Run before :", 30, 100, 65, 20, $SS_RIGHT)
	$INP_Run_Before = StringReplace($INP_Run_Before, "|", @CRLF)
	Local $H_Run_Before = GUICtrlCreateEdit($INP_Run_Before, 100, 85, 445, 80)
	GUICtrlCreateLabel("Run after :", 30, 200, 65, 20, $SS_RIGHT)
	$INP_Run_After = StringReplace($INP_Run_After, "|", @CRLF)
	Local $H_Run_After = GUICtrlCreateEdit($INP_Run_After, 100, 170, 445, 80)
	Local $temp = "These commands will be executed one at a time as cmdline commands. " & @CRLF & _
			'The Commandlines can contain the following variables:' & @CRLF & _
			'  %in% , %out%, %outx64%, %icon% which will be replaced by the fullpath\filename.' & @CRLF & _
			'  %scriptdir% same as @ScriptDir and %scriptfile% = filename without extension.' & @CRLF & _
			'  %fileversion% set to the #AutoIt3Wrapper_Res_Fileversion directive value.' & @CRLF & _
			'  %scitedir% will be replaced by the SciTE program directory' & @CRLF & _
			'Examples:' & @CRLF & _
			'   copy "%in%" "c:\program files\autoit3\SciTE\AutoIt3Wrapper"' & @CRLF & _
			'   copy "%out%" "c:\program files\autoit3\SciTE\AutoIt3Wrapper"' & @CRLF & _
			'   start aacopy.bat "%out%" "C:\Program Files\AutoIt3\SciTE\AutoIt3Wrapper"'
	GUICtrlCreateEdit($temp, 20, 260, 600, 170, $ES_READONLY)
	GUICtrlSetFont(-1, Default, Default, Default, "Courier New")
	GUICtrlSetTip($H_Run_Before, "Specify the command(s), one on each line, to be executed before compilation.")
	GUICtrlSetTip($H_Run_After, "Specify the command(s), one on each line, to be executed after compilation.")
	;=================================================================================================================================
	Local $tab3 = GUICtrlCreateTabItem("Au3Check")
	; Run au3Check before compilation?
	GUICtrlCreateLabel("Au3Check Version: " & FileGetVersion($CurrentAutoIt_InstallDir & "\Au3check.exe"), 400, 50, 180, 20, $SS_RIGHT)
	Local $H_Run_AU3Check = GUICtrlCreateCheckbox("Run AU3Check before compilation.", 100, 65, 250, 20)
	If $INP_Run_AU3Check = "y" Then GUICtrlSetState($H_Run_AU3Check, $GUI_CHECKED)
	If $INP_Add_Constants = "y" Then GUICtrlSetState($H_Add_Constants, $GUI_CHECKED)
	Local $H_AU3Check_Stop_OnWarning = GUICtrlCreateCheckbox("Also stop on warnings", 100, 90, 250, 20)
	If $INP_AU3Check_Stop_OnWarning = "y" Then GUICtrlSetState($H_AU3Check_Stop_OnWarning, $GUI_CHECKED)
	GUICtrlCreateLabel("Skip Plugin Func(s):", 30, 115, 120, 20, $SS_RIGHT)
	Local $H_AU3Check_Plugin = GUICtrlCreateInput($INP_Au3check_Plugin, 155, 113, 390, 20)
	GUICtrlCreateLabel("Au3Check Parameters :", 30, 145, 120, 20, $SS_RIGHT)
	Local $H_AU3Check_Parameters = GUICtrlCreateInput($INP_AU3Check_Parameters, 155, 143, 390, 20)
	$temp = "Possible Parameters: " & @CRLF & _
			'     -q        : quiet (only error/warn output)' & @CRLF & _
			'     -d        : as Opt("MustDeclareVars", 1)' & @CRLF & _
			'     -I dir    : additional directories for searching include files' & @CRLF & _
			'     -U -|file : output unreferenced UDFs and global variables' & @CRLF & _
			'     -w 1      : already included file (on)' & @CRLF & _
			'     -w 2      : missing #comments-end (on)' & @CRLF & _
			'     -w 3      : already declared var (off)' & @CRLF & _
			'     -w 4      : local var used in global scope (off)' & @CRLF & _
			'     -w 5      : local var declared but not used (off)' & @CRLF & _
			'     -w 6      : warn when using Dim (off)' & @CRLF & _
			'     -v 1      : show include paths/files (off)' & @CRLF & _
			'     -v 2      : show lexer tokens (off)'

	GUICtrlCreateEdit($temp, 20, 180, 600, 240, $ES_READONLY)
	GUICtrlSetFont(-1, Default, Default, Default, "Courier New")
	GUICtrlSetTip($H_Run_AU3Check, "Run Au3Check to check your source for possible problems.")
	GUICtrlSetTip($H_AU3Check_Stop_OnWarning, "Also stop when Au3Check detects warnings." & @CRLF & "Normal behaviour is to continue.")
	;=================================================================================================================================
	Local $tab4 = GUICtrlCreateTabItem("Tidy")
	; Run Tidy ?
	GUICtrlCreateLabel("Tidy Version: " & FileGetVersion($SciTE_Dir & "\Tidy\Tidy.exe"), 400, 50, 180, 20, $SS_RIGHT)
	Local $H_Run_Tidy = GUICtrlCreateCheckbox("Run Tidy before compilation.", 100, 65, 250, 20)
	If $INP_Run_Tidy = "y" Then GUICtrlSetState($H_Run_Tidy, $GUI_CHECKED)
	;
	Local $H_Tidy_Stop_OnError = GUICtrlCreateCheckbox("Stop on Tidy Errors", 100, 90, 250, 20)
	If $INP_Tidy_Stop_OnError = "y" Then GUICtrlSetState($H_Tidy_Stop_OnError, $GUI_CHECKED)
	;
	GUICtrlCreateLabel("Tidy Parameters :", 30, 115, 120, 20, $SS_RIGHT)
	Local $H_Tidy_Parameters = GUICtrlCreateInput($INP_Tidy_Parameters, 155, 113, 390, 20)
	$temp = "Possible Parameters: " & @CRLF & _
			"   /tc n  : 0=Tab >0=Number of Spaces." & @CRLF & _
			"   /gd    : Generate documentation file." & @CRLF & _
			"   /rel   : Remove empty lines from the source." & @CRLF & _
			"   /sci 0 : Default Minimal output to the console: warning and errors." & @CRLF & _
			"   /sci 1 : Show more progress information. " & @CRLF & _
			"   /sci 9 : Show all debug lines as found in the Obfuscator.log." & @CRLF & _
			"   /gds   : Show generated doc file in Notepad." & @CRLF & _
			'   /sdp x : Specify Diffprogram to use eg: ' & @CRLF & _
			'            /sdp C:\Progra~1\WinMerge\winmerge.exe "%new%" "%old%"' & @CRLF & _
			"   /nsdp  : Don't run program as specified by /sdp." & @CRLF & _
			"   /kv n  : n = number of backcopies to keep. 0 = all" & @CRLF & _
			"   /bdir x: x = Target backup directory." & @CRLF & _
			"   /sf    : Sort all Func-Endfunc Blocks in sequence FuncName." & @CRLF & _
			"            When #Region-#EndRegion is used sort them within that scope." & @CRLF & _
			"   /sfc   : Same as /sf but first sorts on Comment at the end of the Func() statement"
	GUICtrlCreateEdit($temp, 20, 150, 605, 250, $ES_READONLY)
	GUICtrlSetFont(-1, Default, Default, Default, "Courier New")
	;=================================================================================================================================
	Local $tab5 = GUICtrlCreateTabItem("Obfuscator")
	; Run Obfuscator ?
	GUICtrlCreateLabel("Obfuscator Version: " & FileGetVersion($SciTE_Dir & "\Obfuscator\Obfuscator.exe"), 400, 50, 180, 20, $SS_RIGHT)
	Local $H_Run_Obfuscator = GUICtrlCreateCheckbox("Run Obfuscator before compilation.", 100, 65, 250, 20)
	If $INP_Run_Obfuscator = "y" Then GUICtrlSetState($H_Run_Obfuscator, $GUI_CHECKED)
	GUICtrlCreateLabel("Obfuscator Parameters :", 30, 90, 120, 20, $SS_RIGHT)
	Local $H_Obuscator_Parameters = GUICtrlCreateInput($INP_Obfuscator_Parameters, 155, 87, 390, 20)
	$temp = "Possible Parameters: " & @CRLF & _
			"   /cs 0/1   : 0=No String encryption (1=default)" & @CRLF & _
			"   /cn 0/1   : 0=No Numeric encryption (1=default)" & @CRLF & _
			"   /cf 0/1   : 0=No Func rename (1=default)" & @CRLF & _
			"   /cv 0/1   : 0=No Var rename (1=default)" & @CRLF & _
			"   /sf 0/1   : 1=Strip all unused Func's (0=default)" & @CRLF & _
			"   /sv 0/1   : 1=Strip all unused Global var records (0=default)" & @CRLF & _
			"   /striponly: same as /cs=0 /cn=0 /cf=0 /cv=0 /sf=1 /sv=1" & @CRLF & _
			"   /striponlyincludes: same as /striponly but will leave master script untouched." & @CRLF & _
			"   /sci 0    : Default Minimal output to the console: warning and errors." & @CRLF & _
			"   /sci 1    : Show more progress information. " & @CRLF & _
			"   /sci 9    : Show all debug lines as found in the Obfuscator.log." & @CRLF & _
			"   /Beta     : Use Beta Includes. Dont use AutoIt3Wrapper_Run_Obfuscator." & @CRLF & _
			"  " & @CRLF & _
			"To strip the source, which is included in the output EXE, from all Comments, Whitespace and All un-used Func's (also included UDF's), you just specify :   " & @CRLF & _
			"/striponly"
	GUICtrlCreateEdit($temp, 20, 130, 600, 250, $ES_READONLY)
	GUICtrlSetFont(-1, Default, Default, Default, "Courier New")
	;=================================================================================================================================
	Local $H_Run_cvsWrapper_n, $H_Run_cvsWrapper_y, $H_Run_cvsWrapper_v
	Local $H_cvs_Parameters, $tab6
	If FileExists($SciTE_Dir & "\cvsWrapper\cvsWrapper.exe") Then
		$tab6 = GUICtrlCreateTabItem("cvsWrapper")
		; Run cvsWrapper
		GUICtrlCreateLabel("cvsWrapper Version: " & FileGetVersion($SciTE_Dir & "\cvsWrapper\cvsWrapper.exe"), 400, 50, 180, 20, $SS_RIGHT)
		GUICtrlCreateLabel("Options to run the installed cvsWrapper addon", 30, 70, 600, 20)
		$H_Run_cvsWrapper_n = GUICtrlCreateRadio("Don't run cvsWrapper.", 100, 95, 260, 20)
		$H_Run_cvsWrapper_y = GUICtrlCreateRadio("Always Run cvsWrapper.", 100, 115, 260, 20)
		$H_Run_cvsWrapper_v = GUICtrlCreateRadio("Only when FileVersion_AutoIncrement is set to yes.", 100, 135, 260, 20)
		Switch $INP_Run_cvsWrapper
			Case "y"
				GUICtrlSetState($H_Run_cvsWrapper_y, $GUI_CHECKED)
			Case "v"
				GUICtrlSetState($H_Run_cvsWrapper_v, $GUI_CHECKED)
			Case Else
				GUICtrlSetState($H_Run_cvsWrapper_n, $GUI_CHECKED)
		EndSwitch
		GUICtrlCreateLabel("cvs Parameters :", 10, 165, 90, 20, $SS_RIGHT)
		$H_cvs_Parameters = GUICtrlCreateInput($INP_cvsWrapper_Parameters, 110, 162, 500, 20)
		$temp = "Possible parameters. " & @CRLF & _
				"   /NoPrompt  : Will skip the cvsComments prompt" & @CRLF & _
				"   /Comments  : Text to added in the cvsComments. It can contain the below variables." & @CRLF & _
				'The Commandlines can contain the following variables:' & @CRLF & _
				'  %in% , %out%, %outx64%, %icon% which will be replaced by the fullpath\filename.' & @CRLF & _
				'  %scriptdir% same as @ScriptDir and %scriptfile% = filename without extension.' & @CRLF & _
				'  %fileversion% set to the #AutoIt3Wrapper_Res_Fileversion directive value.' & @CRLF & _
				'  %scitedir% will be replaced by the SciTE program directory'
		GUICtrlCreateEdit($temp, 20, 190, 605, 240, $ES_READONLY)
		GUICtrlSetFont(-1, Default, Default, Default, "Courier New")
	EndIf
	;=================================================================================================================================
	GUICtrlCreateTabItem("") ; end tabitem definition
	Local $H_COMPILE = GUICtrlCreateButton("&Compile Script", 120, 445, 100, 30)
	; make compile the default button with focus
	GUICtrlSetState($H_COMPILE, 256)
	Local $H_SaveOnly = GUICtrlCreateButton("&Save Only", 250, 445, 100, 30)
	;
	Local $H_CANCEL = GUICtrlCreateButton("C&ancel", 380, 445, 100, 30)
	GUICtrlCreateLabel("(F1 = Help)", 590, 460)
	GUISetState(@SW_SHOW)
	; Process GUI Input
	;-------------------------------------------------------------------------------------------
	While 1
		$rc = GUIGetMsg()
		If $rc = 0 Then ContinueLoop
		; Cancel clicked
		If $rc = $H_CANCEL Then Exit
		If $rc = $h_Exit Then Exit
		If $rc = $h_HelpFile Then
			Run('"' & @WindowsDir & '\hh.exe" "' & @ScriptDir & '\..\Scite4AutoIt3.chm::/AutoIt3Wrapper.htm"')
			ContinueLoop
		EndIf
		If $rc = $h_About Then
			MsgBox(262208, "AutoIt3Wrapper_GUI", _
					"AutoIt3Wrapper GUI is written to add Directives to the scriptsource which are used by AutoIt3Wrapper" & @CRLF & @CRLF & "Copyright (c) Jos van der Zande.")
		EndIf
		If $rc = -3 Then Exit
		; Change Target program clicked
		Switch $rc
			Case $tab
				Switch GUICtrlRead($tab)
					Case 1
						GUISetHelp('"' & @WindowsDir & '\hh.exe" "' & @ScriptDir & '\..\Scite4AutoIt3.chm::/AutoIt3Wrapper.htm"')
					Case 2
						GUISetHelp('"' & @WindowsDir & '\hh.exe" "' & @ScriptDir & '\..\Scite4AutoIt3.chm::/AutoIt3Wrapper.htm"')
					Case 3
						GUISetHelp('"' & @WindowsDir & '\hh.exe" "' & @ScriptDir & '\..\Scite4AutoIt3.chm::/AutoIt3Wrapper.htm"')
					Case 4
						GUISetHelp('"' & @WindowsDir & '\hh.exe" "' & @ScriptDir & '\..\Scite4AutoIt3.chm::/AutoIt3Wrapper.htm"')
					Case 5
						GUISetHelp('"' & @WindowsDir & '\hh.exe" "' & @ScriptDir & '\..\Scite4AutoIt3.chm::/tidy_doc.htm"')
					Case 6
						GUISetHelp('"' & @WindowsDir & '\hh.exe" "' & @ScriptDir & '\..\Scite4AutoIt3.chm::/Obfuscator_doc.htm"')
					Case 7
						GUISetHelp('"' & @WindowsDir & '\hh.exe" "' & @ScriptDir & '\..\cvsWrapper\cvsWrapper.htm"')
				EndSwitch
			Case $H_SCRIPTFILE_OUT_CHANGE
				$Init_Dir = GUICtrlRead($H_SCRIPTFILE_OUT)
				$Init_Dir = _PathFull($Init_Dir)
				$Save_Workdir = @WorkingDir
				Local $ScriptFile_Out_New = FileOpenDialog("Select the Target program?", $Init_Dir, "Programs(*.Exe;*.A3x)", 2)
				If @error = 0 And $ScriptFile_Out_New <> "" Then
					;$ScriptFile_Out = $ScriptFile_Out_New
					$ScriptFile_Out_New = DirGetRelativePath($ScriptFile_In, $ScriptFile_Out_New)
					_PathSplit($ScriptFile_Out_New, $szDrive, $szDir, $szFName, $szExt)
					If GUICtrlRead($H_Out_Type_a) = $GUI_CHECKED Then
						If $szExt <> ".a3x" Then $ScriptFile_Out_New = $szDrive & $szDir & $szFName & ".a3x"
					Else
						If $szExt <> ".exe" Then $ScriptFile_Out_New = $szDrive & $szDir & $szFName & ".exe"
					EndIf
					GUICtrlSetData($H_SCRIPTFILE_OUT, $ScriptFile_Out_New)
					If StringRight($ScriptFile_Out_New, 3) = "a3x" Then
						Set_Res_state($GUI_DISABLE)
					Else
						Set_Res_state($GUI_ENABLE)
					EndIf
				EndIf
				FileChangeDir($Save_Workdir)
			Case $H_SCRIPTFILE_OUT_CHANGE_X64
				$Init_Dir = GUICtrlRead($H_SCRIPTFILE_OUT_X64)
				$Init_Dir = _PathFull($Init_Dir)
				$Save_Workdir = @WorkingDir
				Local $ScriptFile_Out_New_x64 = FileOpenDialog("Select the Target program?", $Init_Dir, "Programs(*.Exe;*.A3x)", 2)
				If @error = 0 And $ScriptFile_Out_New_x64 <> "" Then
					;$ScriptFile_Out = $ScriptFile_Out_New
					$ScriptFile_Out_New_x64 = DirGetRelativePath($ScriptFile_In, $ScriptFile_Out_New_x64)
					_PathSplit($ScriptFile_Out_New_x64, $szDrive, $szDir, $szFName, $szExt)
					If GUICtrlRead($H_Out_Type_a) = $GUI_CHECKED Then
						If $szExt <> ".a3x" Then $ScriptFile_Out_New_x64 = $szDrive & $szDir & $szFName & ".a3x"
					Else
						If $szExt <> ".exe" Then $ScriptFile_Out_New_x64 = $szDrive & $szDir & $szFName & ".exe"
					EndIf
					GUICtrlSetData($H_SCRIPTFILE_OUT_X64, $ScriptFile_Out_New_x64)
					If StringRight($ScriptFile_Out_New_x64, 3) = "a3x" Then
						Set_Res_state($GUI_DISABLE)
					Else
						Set_Res_state($GUI_ENABLE)
					EndIf
				EndIf
				FileChangeDir($Save_Workdir)
				; Change icon clicked
			Case $H_INP_ICON_CHANGE
				;$Init_Dir = RegRead($Registry & "\Aut2Exe", "LastIcon")
				$Init_Dir = GUICtrlRead($H_INP_ICON)
				$Init_Dir = _PathFull($Init_Dir)
				$Save_Workdir = @WorkingDir
				Local $H_INP_ICON_NEW = FileOpenDialog("Select the ICON for the program?", $Init_Dir, "Icons(*.ico)", 1)
				If @error = 0 Then
					If $H_INP_ICON_ICO = 0 Then
						$H_INP_ICON_ICO = GUICtrlCreateIcon($H_INP_ICON_NEW, Default, 545, 205)
						GUICtrlSetImage($H_INP_ICON_ICO, $H_INP_ICON_NEW)
					Else
						GUICtrlSetImage($H_INP_ICON_ICO, $H_INP_ICON_NEW)
					EndIf
;~ 					$INP_Icon = $H_INP_ICON_NEW
					$H_INP_ICON_NEW = DirGetRelativePath($ScriptFile_In, $H_INP_ICON_NEW)
					GUICtrlSetData($H_INP_ICON, $H_INP_ICON_NEW)
				EndIf
				FileChangeDir($Save_Workdir)
			Case $H_COMPILE, $H_SaveOnly
				; Validate Extra resource Information
				Local $tempvalues = StringSplit(GUICtrlRead($H_FieldNameEdit), @CRLF)
				For $U = 1 To $tempvalues[0]
					If StringStripWS($tempvalues[$U], 3) <> "" And StringInStr($tempvalues[$U], "|") + StringInStr($tempvalues[$U], "=") = 0 Then
						_GUICtrlTab_SetCurFocus($tab, 1)
						GUICtrlSetState($H_FieldNameEdit, $GUI_FOCUS)
						GUICtrlSetTip($H_FieldNameEdit, 'Add extra Resource info. One per line.' & @CRLF & 'Syntax: Fieldname = Description.' & @CRLF & 'Example:Made By = Jos van der Zande')
						MsgBox(4096 + 16 + 1, "Extra Resource Fields Error.", "There is one or more lines that doesn't contain a =.")
						ContinueLoop 2
					EndIf
				Next
				ExitLoop
		EndSwitch
	WEnd
	GUISetState(@SW_HIDE)
	; --- Read all info from the GUI
	Local $Save_Only = 0
	Local $Changes = 0
	;
	If $rc = $H_SaveOnly Then $Save_Only = 1
	;
	$ScriptFile_Out_New = GUICtrlRead($H_SCRIPTFILE_OUT)
	_PathSplit($ScriptFile_Out_New, $szDrive, $szDir, $szFName, $szExt)
	If $ScriptFile_Out_New <> "" Then
		If GUICtrlRead($H_Out_Type_a) = $GUI_CHECKED Then
			If $szExt <> ".a3x" Then $ScriptFile_Out_New = $szDrive & $szDir & $szFName & ".a3x"
		Else
			If $szExt <> ".exe" Then $ScriptFile_Out_New = $szDrive & $szDir & $szFName & ".exe"
		EndIf
	EndIf
	GUICtrlSetData($H_SCRIPTFILE_OUT, $ScriptFile_Out_New)
	$Changes += GUI_GetValue($H_SCRIPTFILE_OUT, $ScriptFile_Out)
	;
	$ScriptFile_Out_New_x64 = GUICtrlRead($H_SCRIPTFILE_OUT_X64)
	_PathSplit($ScriptFile_Out_New_x64, $szDrive, $szDir, $szFName, $szExt)
	If $ScriptFile_Out_New_x64 <> "" Then
		If GUICtrlRead($H_Out_Type_a) = $GUI_CHECKED Then
			If $szExt <> ".a3x" Then $ScriptFile_Out_New_x64 = $szDrive & $szDir & $szFName & ".a3x"
		Else
			If $szExt <> ".exe" Then $ScriptFile_Out_New_x64 = $szDrive & $szDir & $szFName & ".exe"
		EndIf
	EndIf
	GUICtrlSetData($H_SCRIPTFILE_OUT_X64, $ScriptFile_Out_New_x64)
	$Changes += GUI_GetValue($H_SCRIPTFILE_OUT_X64, $ScriptFile_Out_x64)
	;
	Local $GUI_ScriptFile_Out_Type
	If GUICtrlRead($H_Out_Type_a) = $GUI_CHECKED Then
		$GUI_ScriptFile_Out_Type = "a3x"
	Else
		$GUI_ScriptFile_Out_Type = "exe"
	EndIf
	If $ScriptFile_Out_Type <> $GUI_ScriptFile_Out_Type Then
		$ScriptFile_Out_Type = $GUI_ScriptFile_Out_Type
		$Changes += 1
	EndIf
	;
	$Changes += GUI_GetValue($H_INP_ICON, $INP_Icon)
	;
	$Changes += GUI_GetValue($H_Compression, $INP_W_Compression)
	If $INP_W_Compression = "Lowest" Then $INP_Compression = "0"
	If $INP_W_Compression = "Low" Then $INP_Compression = 1
	If $INP_W_Compression = "Normal" Then $INP_Compression = 2
	If $INP_W_Compression = "High" Then $INP_Compression = 3
	If $INP_W_Compression = "Highest" Then $INP_Compression = 4
	$Changes += GUI_GetValue($H_Change2CUI, $INP_Change2CUI, "1=y;0=n;4=n")
	;
;~ 	$INP_Allow_Decompile = GUICtrlRead($H_INP_NODECOMPILE)
	;
	$Changes += GUI_GetValue($H_Comment, $INP_Comment)
	$Changes += GUI_GetValue($H_Description, $INP_Description)
	$Changes += GUI_GetValue($H_Fileversion, $INP_Fileversion)
	$Changes += GUI_GetValue($H_Res_Language, $Country)
	Language_Code($INP_Res_Language, $CountryTable, $Country, 2)
	;None, asInvoker, highestAvailable or requireAdministrator   (default=None)"
	Local $GUI_RES_requestedExecutionLevel
	If GUICtrlRead($H_Res_requestedExecutionLevel_n) = $GUI_CHECKED Then
		$GUI_RES_requestedExecutionLevel = "None"
	ElseIf GUICtrlRead($H_Res_requestedExecutionLevel_a) = $GUI_CHECKED Then
		$GUI_RES_requestedExecutionLevel = "asInvoker"
	ElseIf GUICtrlRead($H_Res_requestedExecutionLevel_h) = $GUI_CHECKED Then
		$GUI_RES_requestedExecutionLevel = "highestAvailable"
	ElseIf GUICtrlRead($H_Res_requestedExecutionLevel_r) = $GUI_CHECKED Then
		$GUI_RES_requestedExecutionLevel = "requireAdministrator"
	Else
		$GUI_RES_requestedExecutionLevel = ""
	EndIf
	If $INP_RES_requestedExecutionLevel <> $GUI_RES_requestedExecutionLevel Then
		$INP_RES_requestedExecutionLevel = $GUI_RES_requestedExecutionLevel
		$Changes += 1
	EndIf
	;
	Local $GUI_Fileversion_AutoIncrement
	If GUICtrlRead($H_Fileversion_AutoIncrement_y) = $GUI_CHECKED Then
		$GUI_Fileversion_AutoIncrement = "y"
	ElseIf GUICtrlRead($H_Fileversion_AutoIncrement_p) = $GUI_CHECKED Then
		$GUI_Fileversion_AutoIncrement = "p"
	Else
		$GUI_Fileversion_AutoIncrement = "n"
	EndIf
	If $INP_Fileversion_AutoIncrement <> $GUI_Fileversion_AutoIncrement Then
		$INP_Fileversion_AutoIncrement = $GUI_Fileversion_AutoIncrement
		$Changes += 1
	EndIf
	;
	$Changes += GUI_GetValue($H_LegalCopyright, $INP_LegalCopyright)
	$Changes += GUI_GetValue($H_FieldNameEdit, $INP_FieldNameEdit)
	$Changes += GUI_GetValue($H_Icons, $INP_Icons_txt)
	$Changes += GUI_GetValue($H_Res_Files, $Inp_Res_Files_txt)
	$Changes += GUI_GetValue($H_Res_SaveSource, $INP_Res_SaveSource, "1=y;0=n;4=n")
	;
	$Changes += GUI_GetValue($H_Run_AU3Check, $INP_Run_AU3Check, "1=y;0=n;4=n")
	$Changes += GUI_GetValue($H_Add_Constants, $INP_Add_Constants, "1=y;0=n;4=n")
	$Changes += GUI_GetValue($H_AU3Check_Stop_OnWarning, $INP_AU3Check_Stop_OnWarning, "1=y;0=n;4=n")
	$Changes += GUI_GetValue($H_AU3Check_Plugin, $INP_Au3check_Plugin)
	$Changes += GUI_GetValue($H_AU3Check_Parameters, $INP_AU3Check_Parameters)
	$Changes += GUI_GetValue($H_Run_Before, $INP_Run_Before)
	$Changes += GUI_GetValue($H_Run_After, $INP_Run_After)
	$Changes += GUI_GetValue($H_Run_Tidy, $INP_Run_Tidy, "1=y;0=n;4=n")
	$Changes += GUI_GetValue($H_Tidy_Stop_OnError, $INP_Tidy_Stop_OnError, "1=y;0=n;4=n")
	$Changes += GUI_GetValue($H_Tidy_Parameters, $INP_Tidy_Parameters)
	$Changes += GUI_GetValue($H_Run_Obfuscator, $INP_Run_Obfuscator, "1=y;0=n;4=n")
	$Changes += GUI_GetValue($H_Obuscator_Parameters, $INP_Obfuscator_Parameters)
	;
	Local $GUI_AutoIT3_Version
	If GUICtrlRead($H_AUTOIT3_Version_B) = $GUI_CHECKED Then
		$GUI_AutoIT3_Version = "Beta"
	Else
		$GUI_AutoIT3_Version = "Prod"
	EndIf
	If $INP_AutoIT3_Version <> $GUI_AutoIT3_Version Then
		$INP_AutoIT3_Version = $GUI_AutoIT3_Version
		$Changes += 1
	EndIf
	;
	; X86/X64 logic
	Local $GUI_UseX64
	If GUICtrlRead($H_AUTOIT3_X64) = $GUI_CHECKED And GUICtrlRead($H_AUTOIT3_X86) = $GUI_CHECKED Then
		If $INP_Compile_Both = 'n' Then
			$INP_Compile_Both = 'y'
			$Changes += 1
		EndIf
	Else
		If $INP_Compile_Both = 'y' Then
			$INP_Compile_Both = 'n'
			$Changes += 1
		EndIf
	EndIf
	;
	If GUICtrlRead($H_AUTOIT3_X64) = $GUI_CHECKED Then
		$GUI_UseX64 = "y"
	Else
		$GUI_UseX64 = "n"
	EndIf
	If $INP_UseX64 <> $GUI_UseX64 Then
		$INP_UseX64 = $GUI_UseX64
		$Changes += 1
	EndIf
	; UPX
	Local $GUI_UseUpx
	If GUICtrlRead($H_AUTOIT3_Upx) = $GUI_CHECKED Then
		$GUI_UseUpx = "y"
	Else
		$GUI_UseUpx = "n"
	EndIf
	If $INP_UseUpx <> $GUI_UseUpx Then
		$INP_UseUpx = $GUI_UseUpx
		$Changes += 1
	EndIf
	;
	If $H_cvs_Parameters Then
		; Check cvsWrapper parameters when cvsWrapper is installed
		Local $GUI_Run_cvsWrapper
		If GUICtrlRead($H_Run_cvsWrapper_y) = $GUI_CHECKED Then
			$GUI_Run_cvsWrapper = "y"
		ElseIf GUICtrlRead($H_Run_cvsWrapper_v) = $GUI_CHECKED Then
			$GUI_Run_cvsWrapper = "v"
		Else
			$GUI_Run_cvsWrapper = "n"
		EndIf
		If $INP_Run_cvsWrapper <> $GUI_Run_cvsWrapper Then
			$INP_Run_cvsWrapper = $GUI_Run_cvsWrapper
			$Changes += 1
		EndIf
		$Changes += GUI_GetValue($H_cvs_Parameters, $INP_cvsWrapper_Parameters)
	EndIf
	;
	GUIDelete()
	; Update the source when there where changes.
	If $Changes > 0 Then
		ConsoleWrite('-> ' & $Changes & ' Change(s) made.' & @CRLF)
		Local $Full_source = @CRLF & FileRead($ScriptFile_In)
		; Add one @CRLF for REGEX testing purpose to be able to test for whole record.
		$Full_source = StringRegExpReplace($Full_source, "(?s)(?i)\r\n(\s*)#Region ;\*\*\*\* Directives created by AutoIt3Wrapper_GUI \*\*\*\*(.*?)\r\n", @CRLF)
		$Full_source = StringRegExpReplace($Full_source, "(?s)(?i)\r\n(\s*)#EndRegion ;\*\*\*\* Directives created by AutoIt3Wrapper_GUI \*\*\*\*(.*?)\r\n", @CRLF)
		Local $directives = ""
		If StringRegExp($Full_source, '(?s)(?i)' & @CRLF & '(\s*)#NoTrayIcon(.*?)' & @CRLF) Then
			$Full_source = StringRegExpReplace($Full_source, '(?s)(?i)' & @CRLF & '#NoTrayIcon(.*?)' & @CRLF, @CRLF)
			$directives &= "#NoTrayIcon" & @CRLF
		EndIf
		;
		If StringRegExp($Full_source, '(?s)(?i)' & @CRLF & '(\s*)#RequireAdmin(.*?)' & @CRLF) Then
			$Full_source = StringRegExpReplace($Full_source, '(?s)(?i)' & @CRLF & '#RequireAdmin(.*?)' & @CRLF, @CRLF)
			$directives &= "#RequireAdmin" & @CRLF
		EndIf
		$directives &= "#Region ;**** Directives created by AutoIt3Wrapper_GUI ****" & @CRLF
		; Aut2Exe Directives
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Prompt", "", "", "") ; Remove this obsolete paremeter
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Version", $INP_AutoIT3_Version, "prod", "p=prod;b=beta")
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Outfile_type", $ScriptFile_Out_Type, "exe", "")
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_aut2exe", "", "", "")
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Icon", $INP_Icon, "", "")
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Outfile", $ScriptFile_Out, "", "")
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Outfile_x64", $ScriptFile_Out_x64, "", "")
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Compression", $INP_Compression, "2", "")
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_UseUpx", $INP_UseUpx, "y", "1=y;0=n;4=n")
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_UPX_Parameters", $INP_Upx_Parameters, "", "")
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Compile_Both", $INP_Compile_Both, "n", "1=y;0=n")
		If @OSArch = "X86" Or StringInStr(RegRead("HKCR\AutoIt3Script\Shell\Run\Command", ""), "AutoIt3.exe") Then
			Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_UseX64", $INP_UseX64, "n", "1=y;0=n;4=n")
		Else
			Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_UseX64", $INP_UseX64, "y", "1=y;0=n;4=n")
		EndIf
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Change2CUI", $INP_Change2CUI, "n", "1=y;0=n;4=n")
		; Resource Directives
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Res_Comment", $INP_Comment, "", "")
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Res_Description", $INP_Description, "", "")
		If $INP_Fileversion_AutoIncrement <> "n" And $INP_Fileversion = "" Then $INP_Fileversion = "0.0.0.0"
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Res_Fileversion", $INP_Fileversion, "", "")
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Res_Fileversion_AutoIncrement", $INP_Fileversion_AutoIncrement, "n", "")
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Res_ProductVersion", $INP_ProductVersion, "", "")
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Res_LegalCopyright", $INP_LegalCopyright, "", "")
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Res_SaveSource", $INP_Res_SaveSource, "n", "1=y;0=n;4=n")
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Res_Language", $INP_Res_Language, "2057", "")
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Res_requestedExecutionLevel", $INP_RES_requestedExecutionLevel, "", "")
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Res_Compatibility", $INP_RES_Compatibility, "", "")
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Res_HiDpi", $INP_RES_HiDpi, "", "")
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Res_Field1Name", "", "", "") ; Remove this obsolete paremeter
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Res_Field2Name", "", "", "") ; Remove this obsolete paremeter
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Res_Field1Value", "", "", "") ; Remove this obsolete paremeter
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Res_Field2Value", "", "", "") ; Remove this obsolete paremeter
		$tempvalues = StringSplit($INP_FieldNameEdit, @CRLF)
		For $U = 1 To $tempvalues[0]
			$tempval = StringReplace($tempvalues[$U], "=", "|", 1)
			$tempval = StringReplace($tempval, " | ", "|", 1)
			If $tempval <> "|" Then Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Res_Field", $tempval, "", "")
		Next
		$tempvalues = StringSplit($INP_Icons_txt, @CRLF)
		Local $y = 0
		ReDim $INP_Icons[$tempvalues[0] + 1]
		For $x = 1 To $tempvalues[0]
			$tempval = $tempvalues[$x]
			If $tempval <> "" Then
				$y += 1
				Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Res_Icon_Add", $tempval, "", "")
				$INP_Icons[$y] = $tempval
			EndIf
		Next
		ReDim $INP_Icons[$y + 1]
		;
		$y = 0
		$tempvalues = StringSplit($Inp_Res_Files_txt, @CRLF)
		ReDim $INP_Res_Files[$tempvalues[0] + 1]
		For $x = 1 To $tempvalues[0]
			$tempval = $tempvalues[$x]
			If $tempval <> "" Then
				$y += 1
				Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Res_File_Add", $tempval, "", "")
				$INP_Res_Files[$y] = $tempval
			EndIf
		Next
		ReDim $INP_Res_Files[$y + 1]
		; Au3Check directives
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Run_AU3Check", $INP_Run_AU3Check, "y", "1=y;0=n;4=n")
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Add_Constants", $INP_Add_Constants, "n", "1=y;0=n;4=n")
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_AU3Check_Stop_OnWarning", $INP_AU3Check_Stop_OnWarning, "n", "1=y;0=n;4=n")
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_AU3Check_Parameters", $INP_AU3Check_Parameters, "", "")
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Run_Before", "", "", "")
		; Run Before/After Directives
		$INP_Run_Before = StringReplace($INP_Run_Before, @CRLF, "|")
		$tempvalues = StringSplit($INP_Run_Before, "|")
		For $U = 1 To $tempvalues[0]
			If $tempvalues[0] <> "|" Then Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Run_Before", $tempvalues[$U], "", "")
		Next
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Run_After", "", "", "")
		$INP_Run_After = StringReplace($INP_Run_After, @CRLF, "|")
		$tempvalues = StringSplit($INP_Run_After, "|")
		For $U = 1 To $tempvalues[0]
			If $tempvalues[$U] <> "|" Then Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Run_After", $tempvalues[$U], "", "")
		Next
		; Tidy Directives
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Run_Tidy", $INP_Run_Tidy, "n", "1=y;0=n;4=n")
		Update_Directive($Full_source, $directives, "#Tidy_Parameters", $INP_Tidy_Parameters, "", "")
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Tidy_Stop_OnError", $INP_Tidy_Stop_OnError, "y", "1=y;0=n;4=n")
		; Obfuscator Directives
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Run_Obfuscator", $INP_Run_Obfuscator, "n", "1=y;0=n;4=n")
		Update_Directive($Full_source, $directives, "#Obfuscator_Parameters", $INP_Obfuscator_Parameters, "", "")
		; cvsWrapper Directives
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_Run_cvsWrapper", $INP_Run_cvsWrapper, "n", "")
		Update_Directive($Full_source, $directives, "#AutoIt3Wrapper_cvsWrapper_Parameters", $INP_cvsWrapper_Parameters, "", "")
		;
		Local $test = "#Region ;**** Directives created by AutoIt3Wrapper_GUI ****" & @CRLF
		If StringRight($directives, StringLen($test)) = $test Then
			$directives = StringTrimRight($directives, StringLen($test))
		Else
			$directives &= "#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****" & @CRLF
		EndIf
		;
		FileRecycle($ScriptFile_In)
		Local $Fh = FileOpen($ScriptFile_In, 2 + $SrceUnicodeFlag)
		FileWrite($Fh, $directives)
		; remove the added @CRLF
		FileWrite($Fh, StringMid($Full_source, 3))
		FileClose($Fh)
	Else
		; Change the Run_Before and Run_After back to the proper format.
		$INP_Run_Before = StringReplace($INP_Run_Before, @CRLF, "|")
		$INP_Run_After = StringReplace($INP_Run_After, @CRLF, "|")
		ConsoleWrite('-> No changes made..' & @CRLF)
	EndIf
	#forceref $H_Res_L01, $H_Res_L02, $H_Res_L03, $H_Res_L04, $H_Res_L05, $H_Res_L06, $H_Res_L07, $H_Res_L08, $H_Res_L09
	#forceref $Changes
	#forceref $tab0, $tab1, $tab1b, $tab2, $tab3, $tab4, $tab5, $tab6, $H_Run_cvsWrapper_n, $H_Run_cvsWrapper_y, $H_Run_cvsWrapper_v
	If $Save_Only Then Exit
	;
EndFunc   ;==>GUI_Show
;
Func Set_Res_state($G_state)
	GUICtrlSetState($H_Resource, $G_state)
	GUICtrlSetState($H_Comment, $G_state)
	GUICtrlSetState($H_Description, $G_state)
	GUICtrlSetState($H_Fileversion, $G_state)
	GUICtrlSetState($H_Fileversion_AutoIncrement_n, $G_state)
	GUICtrlSetState($H_Fileversion_AutoIncrement_p, $G_state)
	GUICtrlSetState($H_Fileversion_AutoIncrement_y, $G_state)
	GUICtrlSetState($H_LegalCopyright, $G_state)
	GUICtrlSetState($H_FieldNameEdit, $G_state)
	GUICtrlSetState($H_Res_Language, $G_state)
EndFunc   ;==>Set_Res_state
;
Func Update_Directive(ByRef $source, ByRef $directives, $directive, $Directive_Value, $default, $translate)
	; Remove directives from source
	Do
		$source = StringRegExpReplace($source, '(?s)(?i)' & @CRLF & "(\s*)" & $directive & '(.*?)' & @CRLF, @CRLF)
	Until Not @extended
;~ 	If @extended Then ConsoleWrite($directive & " Removed..  " & @extended & @CRLF)
	; Remove old version directives from source
	Local $Tdirective = StringReplace($directive, "#AutoIt3Wrapper_", "#Compiler_")
	Do
		$source = StringRegExpReplace($source, '(?s)(?i)' & @CRLF & "(\s*)" & $Tdirective & '(.*?)' & @CRLF, @CRLF)
	Until Not @extended
	;If @extended Then ConsoleWrite($Tdirective & " Removed..  " & @extended & @CRLF)
	Local $tarray = StringSplit($translate, ";")
	Local $varray
	For $x = 1 To $tarray[0]
		$varray = StringSplit($tarray[$x], "=")
		If $varray[0] > 1 And $varray[1] = $Directive_Value Then $Directive_Value = $varray[2]
	Next
	If $Directive_Value = "" Or $Directive_Value = $default Then Return
	$directives &= $directive & "=" & $Directive_Value & @CRLF
EndFunc   ;==>Update_Directive
#endregion GUI Functions
