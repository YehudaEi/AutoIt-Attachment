#region Script Options ======================================================================================================
#AutoIt3Wrapper_icon=
;** AUT2EXE settings
#AutoIt3Wrapper_Icon=.\Protected.ico		;Filename of the Ico file to use
#AutoIt3Wrapper_OutFile=Executable Blocker Client.exe           ;Target exe/a3x filename.
#AutoIt3Wrapper_OutFile_Type=exe                ;a3x=small AutoIt3 file;  exe=Standalone executable (Default)
#AutoIt3Wrapper_Compression=2                   ;Compression parameter 0-4  0=Low 2=normal 4=High. Default=2
#AutoIt3Wrapper_UseUpx=Y                        ;(Y/N) Compress output program.  Default=Y
;~ #AutoIt3Wrapper_Change2CUI=Y                    ;(Y/N) Change output program to CUI in stead of GUI. Default=N
;** Target program Resource info
#AutoIt3Wrapper_res_comment=Executable Blocker Block all exes from running
#AutoIt3Wrapper_res_description=Executable Blocker
#AutoIt3Wrapper_Res_Fileversion=1.0.3.7
#AutoIt3Wrapper_res_fileversion_autoincrement=Y
#AutoIt3Wrapper_res_legalcopyright=Copyright © 2010 Shafayat
#AutoIt3Wrapper_res_field=Made By|Shafayat
#AutoIt3Wrapper_res_field=Email|Shafayat at yahoo dot com
#AutoIt3Wrapper_res_field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_res_field=Compile Date|%date% %time%
#AutoIt3Wrapper_Run_Debug_Mode=N
#AutoIt3Wrapper_run_cvswrapper=v
#AutoIt3Wrapper_run_obfuscator=y
; Obfuscator
#Obfuscator_parameters=/cs=0 /cn=0 /cf=0 /cv=0 /sf=1
#AutoIt3Wrapper_Add_Constants=n
#AutoIt3Wrapper_Change2CUI=n

; Script: Executable Blocker Client.au3
; Version: 1.02
; Author: Shafayat
; File: 1 of 2
;
; No Includes Needed
#Include <String.au3>
#NoTrayIcon
;
Global Const $TRAY_CHECKED = 1
Global Const $TRAY_UNCHECKED = 4
Global $TRAY_ITEM_ENA, $TRAY_ITEM_DIS; tray check feature
;
Global Const $PROCESS_VM_READ=0x10
Global Const $PROCESS_QUERY_INFORMATION = 0x400
;
Global $PRODUCT_NAME = ("Executable Blocker"); program name
Global $SETUP_DIR = @ScriptDir ;(@ProgramFilesDir & "\Executable Blocker"); program path
Global $HOME_KEY = ("HKEY_CURRENT_USER\Software\" & $PRODUCT_NAME); program software key
;
Global $INI_NAME = @ScriptDir&"\"&$PRODUCT_NAME & ".INI"
;
; Be sure the Program name is what you want ...
Global $EXE_NAME = ("Executable Blocker Client.exe"); program name
If @Compiled Then
	Global $SCRIPT_VERSION = FileGetVersion(@ScriptName)
	If @ScriptName<>$EXE_NAME Then
		If FileExists($EXE_NAME) Then FileDelete($EXE_NAME)
		FileCopy(@ScriptName,$EXE_NAME,1)
		Run($EXE_NAME)
		Exit
	Else
		FileInstall(".\Executable Blocker.exe",@ScriptDir&"\Executable Blocker.exe")
	EndIf
EndIf
;
TraySetIcon($SETUP_DIR & '\Protected.ico')
;
;RegWrite($HOME_KEY,"Do Not Ask For Setup","REG_SZ", "0")
;------------------------------------------------------
;
;If (@ScriptDir = $SETUP_DIR) Then
;
;Else
;	If RegRead($HOME_KEY, "Do Not Ask For Setup") = 0 Then
;		;F_SetUp()
;		;MsgBox(0,"F","FAKE SETUP")
;	EndIf
;EndIf
;
;-----------------------------------------------
;
If Int(IniRead($INI_NAME,"Config","FirstRun","1")) = 1 Then _Setup()
;
F_CreateRegistryEntry()
;
F_RegisterShell()
;
Opt("TrayMenuMode", 1)
Opt("TrayOnEventMode", 1)
;
#Region TRAY MENU
$TRAY_MENU_INFO = TrayCreateMenu("Information")
$TRAY_ITEM_LOGFILE = TrayCreateItem("Logfile" , $TRAY_MENU_INFO)
$TRAY_ITEM_TRUSTED = TrayCreateItem("Trusted .exe" , $TRAY_MENU_INFO)
TrayCreateItem("",$TRAY_MENU_INFO)
$TRAY_ITEM_ABOUT = TrayCreateItem("About", $TRAY_MENU_INFO)
$TRAY_ITEM_VISIT = TrayCreateItem("Visit Website", $TRAY_MENU_INFO)
TrayCreateItem("")
$TRAY_ITEM_ENA = TrayCreateItem("Block Executables")
$TRAY_ITEM_DIS = TrayCreateItem("Unblock Executables")
TrayCreateItem("")
$TRAY_ITEM_TERMINATE = TrayCreateItem("Exit")
TraySetToolTip($PRODUCT_NAME)
;
TraySetState()
;
TrayItemSetOnEvent($TRAY_ITEM_ABOUT, "F_About")
TrayItemSetOnEvent($TRAY_ITEM_TERMINATE, "F_Terminate")
TrayItemSetOnEvent($TRAY_ITEM_VISIT, "F_Visit")
TrayItemSetOnEvent($TRAY_ITEM_ENA, "F_RegisterShell")
TrayItemSetOnEvent($TRAY_ITEM_DIS, "F_UnRegisterShell")
TrayItemSetOnEvent($TRAY_ITEM_LOGFILE, "F_Logfile")
TrayItemSetOnEvent($TRAY_ITEM_TRUSTED, "F_Trusted")
TrayItemSetState($TRAY_ITEM_ENA, $TRAY_CHECKED)
HotKeySet("#{ESC}", "F_Terminate")
#EndRegion TRAY MENU
;
;-----------------------------------------------
While 1
	Sleep(250); Loop
WEnd
;-----------------------------------------------
Func F_Visit()
	ShellExecute('http://sss13x.co.nr')
	TrayItemSetState($TRAY_ITEM_VISIT, $TRAY_UNCHECKED)
EndFunc
;
Func F_Terminate()
	F_UnRegisterShell()
	Exit
EndFunc
;
Func F_About()
	MsgBox(0, "About " & $PRODUCT_NAME, "Executable Blocker ver1.02" & @CRLF & @CRLF & "A shield against all kinds of mobile disk virus." & @CRLF & @CRLF & "- Shafayat" & @CRLF & "sss13x.co.nr")
	TrayItemSetState($TRAY_ITEM_ABOUT, $TRAY_UNCHECKED)
EndFunc
;
Func F_Logfile()
	ShellExecute(@AppDataCommonDir&"\"&$PRODUCT_NAME&"\"&$PRODUCT_NAME&".LOG")
EndFunc
;
Func F_Trusted()
	ShellExecute('"'&$INI_NAME&'"')
EndFunc

;------------------------------------------------- exehost Enabled
Func F_RegisterShell()
	RegWrite("HKEY_CLASSES_ROOT\.exe", "", "REG_SZ", "exehost")
	RegWrite("HKEY_CLASSES_ROOT\.com", "", "REG_SZ", "exehost")
	RegWrite("HKEY_CLASSES_ROOT\.bat", "", "REG_SZ", "exehost")
	RegWrite("HKEY_CLASSES_ROOT\.pif", "", "REG_SZ", "exehost")
	TrayTip("Executable Blocker", "Executable Blocker has been enabled. ", 5)
	TrayItemSetState($TRAY_ITEM_DIS, $TRAY_UNCHECKED)
	Sleep(2000)
	TrayItemSetState($TRAY_ITEM_ENA, $TRAY_CHECKED)
	TrayTip("", "", 5)
EndFunc
;------------------------------------------------- exehost Disabled
Func F_UnRegisterShell()
	RegWrite("HKEY_CLASSES_ROOT\.exe", "", "REG_SZ", "exefile")
	RegWrite("HKEY_CLASSES_ROOT\.com", "", "REG_SZ", "comfile")
	RegWrite("HKEY_CLASSES_ROOT\.bat", "", "REG_SZ", "batfile")
	RegWrite("HKEY_CLASSES_ROOT\.pif", "", "REG_SZ", "piffile")
	TrayTip("Executable Blocker", "Executable Blocker has been disabled.", 5)
	TrayItemSetState($TRAY_ITEM_ENA, $TRAY_UNCHECKED)
	Sleep(2000)
	TrayItemSetState($TRAY_ITEM_DIS, $TRAY_CHECKED)
	TrayTip("", "", 5)
EndFunc
;------------------------------------------------- exehost pass to 'Executable Blocker.exe' with Path and File String
Func F_CreateRegistryEntry()
	$ShellOpenCommand = '\Executable Blocker.exe" "%1" %*'  ;"%1" "%2" "%3" "%4" "%5" "%6" "%7" "%8"
	RegWrite("HKEY_CLASSES_ROOT\exehost", "", "REG_SZ", "Filtered Executable File")
	RegWrite("HKEY_CLASSES_ROOT\exehost\DefaultIcon", "", "REG_SZ", "%1")
	RegWrite("HKEY_CLASSES_ROOT\exehost\Shell", "", "REG_SZ", "Open")
	RegWrite("HKEY_CLASSES_ROOT\exehost\Shell\Open", "", "REG_SZ", "Open")
	RegWrite("HKEY_CLASSES_ROOT\exehost\Shell\Open\Command", "", "REG_SZ", '"' & $SETUP_DIR & $ShellOpenCommand)
EndFunc
;-------------------------------------------------
;Func F_SetUp()
;	MsgBox(0,"SET UP","ASDSDASD")
;	Exit
;	FileCopy(@ScriptDir & "\Disk Guard.dll", $SETUP_DIR & "\Disk Guard.exe",9)
;	FileCopy(@AutoItExe, $SETUP_DIR & "\Start Disk Guard.exe",9)
;	FileCopy(@ScriptDir & "\Enabled.dll", $SETUP_DIR & "\Enabled.dll",9)
;	FileCopy(@ScriptDir & "\Protected.dll", $SETUP_DIR & "\Protected.ico",9)
;	FileCopy(@ScriptDir & "\Disabled.dll", $SETUP_DIR & "\Disabled.dll",9)
;	FileCreateShortcut($SETUP_DIR & "\Start Disk Guard.exe", @DesktopCommonDir & "\Start Disk Guardian","","","",$SETUP_DIR & "\Protected.ico")
;EndFunc
;

Func _Setup()
	TraySetToolTip($PRODUCT_NAME&@CRLF&"Building White list ...")
	Local $CmdLine, $list = ProcessList()
	IniWrite($INI_NAME,"Config","FirstRun","0")
	For $i = 1 to $list[0][0]
		$CmdLine = _WinAPI_GetCommandLineFromPID($list[$i][1])
		IniWrite($INI_NAME,"Allowed",$CmdLine,_StringEncrypt (1 , $CmdLine, $PRODUCT_NAME))
	Next
EndFunc
;
Func _WinAPI_GetCommandLineFromPID($PID)
    $ret1=DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', $PROCESS_VM_READ+$PROCESS_QUERY_INFORMATION, 'int', False, 'int', $PID)
    $tag_PROCESS_BASIC_INFORMATION = "int ExitStatus;" & _
                                     "ptr PebBaseAddress;" & _
                                     "ptr AffinityMask;" & _
                                     "ptr BasePriority;" & _
                                     "ulong UniqueProcessId;" & _
                                     "ulong InheritedFromUniqueProcessId;"
    $PBI=DllStructCreate($tag_PROCESS_BASIC_INFORMATION)
    DllCall("ntdll.dll", "int", "ZwQueryInformationProcess", "hwnd", $ret1[0], "int", 0, "ptr", DllStructGetPtr($PBI), "int", _
                                                                                                DllStructGetSize($PBI), "int",0)
    $dw=DllStructCreate("ptr")
    DllCall("kernel32.dll", "int", "ReadProcessMemory", "hwnd", $ret1[0], _
                            "ptr", DllStructGetData($PBI,2)+0x10, _ ; PebBaseAddress+16 bytes <-- ptr _PROCESS_PARAMETERS
                            "ptr", DllStructGetPtr($dw), "int", 4, "ptr", 0)
    $unicode_string = DllStructCreate("ushort Length;ushort MaxLength;ptr String")
    DllCall("kernel32.dll", "int", "ReadProcessMemory", "hwnd", $ret1[0], _
                                 "ptr", DllStructGetData($dw, 1)+0x40, _ ; _PROCESS_PARAMETERS+64 bytes <-- ptr CommandLine Offset (UNICODE_STRING struct) - Win XP / Vista.
                                 "ptr", DllStructGetPtr($unicode_string), "int", DllStructGetSize($unicode_string), "ptr", 0)
    $ret=DllCall("kernel32.dll", "int", "ReadProcessMemory", "hwnd", $ret1[0], _
                                 "ptr", DllStructGetData($unicode_string, "String"), _ ; <-- ptr Commandline Unicode String
                                 "wstr", 0, "int", DllStructGetData($unicode_string, "Length") + 2, "int*", 0) ; read Length + terminating NULL (2 bytes in unicode)
    DllCall("kernel32.dll", 'int', 'CloseHandle', "hwnd", $ret1[0])
    If $ret[5] Then Return $ret[3]   ; If bytes returned, return commandline...
    Return ""                     ; Getting empty string is correct behaviour when there is no commandline to be had...
EndFunc