#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=Resource\proelogo.ico
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; AutoIt Script - Pro/Startup

;-----------------------------------------------------------------
;INCLUDES AND OPTIONS
;-----------------------------------------------------------------
#include <GuiConstants.au3>
#include <GuiEdit.au3>
#include <_XMLDomWrapper.au3>

;-----------------------------------------------------------------
;PROCESS VERSIONS, CONFIGS and MAPKEYS SETTINGS FILES
;-----------------------------------------------------------------
	Opt("ExpandEnvStrings", 1)
if FileExists ("d:\ptc\creo_m065_%PROCESSOR_ARCHITECTURE%") then
$XML_FILE = "resource/startuptest.xml"
$LOGO = "Resource\proelogo.ico"
_XMLFileOpen($XML_FILE)
Global $PRO_VERSIONS_IDs = _XMLGetValue("/startup/pro_versions/pro_version/id")
Global $PRO_VERSIONS = _XMLGetValue("/startup/pro_versions/pro_version/name")
Global $PRO_VERSIONS_FILES = _XMLGetValue("/startup/pro_versions/pro_version/file")
Global $version = _XMLGetValue("/startup/pro_versions/pro_version/version")
Global $code = _XMLGetValue("/startup/pro_versions/pro_version/code")
Global $pro_drive = _XMLGetValue("/startup/pro_versions/pro_version/pro_drive")

Global $PRO_CONFIG_PROS_IDs = _XMLGetValue("/startup/config_pro_files/config_pro_file/id")
Global $PRO_CONFIG_PROS = _XMLGetValue("/startup/config_pro_files/config_pro_file/name")
Global $PRO_CONFIG_PROS_FILES = _XMLGetValue("/startup/config_pro_files/config_pro_file/file")

Global $PRO_CONFIG_WINS_IDs = _XMLGetValue("/startup/config_win_files/config_win_file/id")
Global $PRO_CONFIG_WINS = _XMLGetValue("/startup/config_win_files/config_win_file/name")
Global $PRO_CONFIG_WINS_FILES = _XMLGetValue("/startup/config_win_files/config_win_file/file")

Global $PRO_MAPKEYS_IDs = _XMLGetValue("/startup/mapkey_files/mapkey_file/id")
Global $PRO_MAPKEYS = _XMLGetValue("/startup/mapkey_files/mapkey_file/name")
Global $PRO_MAPKEYS_FILES = _XMLGetValue("/startup/mapkey_files/mapkey_file/file")

Global $DEF_PRO_VERSION = _XMLGetValue("/startup/def_preferences/def_pro_version")
Global $DEF_CONFIG_PRO_FILE = _XMLGetValue("/startup/def_preferences/def_config_pro_file")
Global $DEF_CONFIG_WIN_FILE = _XMLGetValue("/startup/def_preferences/def_config_win_file")
Global $DEF_MAPKEY_FILES = _XMLGetValue("/startup/def_preferences/def_mapkey_files/def_mapkey_file")
Global $DEF_PROE_WORK_DIR = _XMLGetValue("/startup/def_preferences/def_proe_work_dir")
Else
if FileExists ("d:\ptc\wf3_m240_%PROCESSOR_ARCHITECTURE%") then
	$XML_FILE = "resource/startupwf3.xml"
$LOGO = "Resource\proelogo.ico"
_XMLFileOpen($XML_FILE)
Global $PRO_VERSIONS_IDs = _XMLGetValue("/startup/pro_versions/pro_version/id")
Global $PRO_VERSIONS = _XMLGetValue("/startup/pro_versions/pro_version/name")
Global $PRO_VERSIONS_FILES = _XMLGetValue("/startup/pro_versions/pro_version/file")
Global $version = _XMLGetValue("/startup/pro_versions/pro_version/version")
Global $code = _XMLGetValue("/startup/pro_versions/pro_version/code")
Global $pro_drive = _XMLGetValue("/startup/pro_versions/pro_version/pro_drive")

Global $PRO_CONFIG_PROS_IDs = _XMLGetValue("/startup/config_pro_files/config_pro_file/id")
Global $PRO_CONFIG_PROS = _XMLGetValue("/startup/config_pro_files/config_pro_file/name")
Global $PRO_CONFIG_PROS_FILES = _XMLGetValue("/startup/config_pro_files/config_pro_file/file")

Global $PRO_CONFIG_WINS_IDs = _XMLGetValue("/startup/config_win_files/config_win_file/id")
Global $PRO_CONFIG_WINS = _XMLGetValue("/startup/config_win_files/config_win_file/name")
Global $PRO_CONFIG_WINS_FILES = _XMLGetValue("/startup/config_win_files/config_win_file/file")

Global $PRO_MAPKEYS_IDs = _XMLGetValue("/startup/mapkey_files/mapkey_file/id")
Global $PRO_MAPKEYS = _XMLGetValue("/startup/mapkey_files/mapkey_file/name")
Global $PRO_MAPKEYS_FILES = _XMLGetValue("/startup/mapkey_files/mapkey_file/file")

Global $DEF_PRO_VERSION = _XMLGetValue("/startup/def_preferences/def_pro_version")
Global $DEF_CONFIG_PRO_FILE = _XMLGetValue("/startup/def_preferences/def_config_pro_file")
Global $DEF_CONFIG_WIN_FILE = _XMLGetValue("/startup/def_preferences/def_config_win_file")
Global $DEF_MAPKEY_FILES = _XMLGetValue("/startup/def_preferences/def_mapkey_files/def_mapkey_file")
Global $DEF_PROE_WORK_DIR = _XMLGetValue("/startup/def_preferences/def_proe_work_dir")
endif
endif
;-----------------------------------------------------------------
;set enviroment variables
;-----------------------------------------------------------------

RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "MaxConnectionsPerServer", "REG_DWORD", "0x0000000a")
RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "MaxConnectionsPer1_0Server", "REG_DWORD", "0x0000000a")

;-----------------------------------------------------------------
;GENERATE THE UI
;-----------------------------------------------------------------
; will create a dialog box that when displayed is centered
GUICreate("Creo Elements/Pro", 500, 410)
GUISetIcon($LOGO)
GUICtrlCreatePic("Resource\logo_hd.bmp", 375, 330, 108, 40)
; will create a tab control (container for a set of tabs)
$tab = GUICtrlCreateTab(5, 5, 490, 400)

;GENERATE THE LAUNCH TAB
;-----------------------------------------------------------------
$tab0 = GUICtrlCreateTabItem("LAUNCH")
GUICtrlSetState(-1, $GUI_SHOW); will be display first

;Instructions to user
GUICtrlCreateLabel("Select Version to use and select Start.", 10, 40, 460, 50)

;Pro/E Versions group box
$Y = 70
GUICtrlCreateGroup("Pro/E Version", 10, $Y, 200, 300)
Dim $VERSION_RADIOS[$PRO_VERSIONS_IDs[0]]
$Y = $Y + 30
For $i = 1 To $PRO_VERSIONS_IDs[0]
	$VERSION_RADIOS[$i - 1] = GUICtrlCreateRadio($PRO_VERSIONS[$i], 15, $Y, 190, 20)
	$Y = $Y + 20
Next
GUICtrlSetState($VERSION_RADIOS[$DEF_PRO_VERSION[1] - 1], $GUI_CHECKED)

;Config.pro Group box
;$Y = 70
;GUICtrlCreateGroup  ("Config Pro File", 185,$Y,120,300)
;Dim $CONFIGS_RADIOS[$PRO_CONFIG_PROS_IDs[0]]
;$Y = $Y + 30
;For $i=1 to $PRO_CONFIG_PROS_IDs[0]
;	$CONFIGS_RADIOS[$i-1] = GUICtrlCreateRadio ($PRO_CONFIG_PROS[$i], 190,$Y,110,20)
;	$Y = $Y + 20
;Next
;GUICtrlSetState ($CONFIGS_RADIOS[$DEF_CONFIG_PRO_FILE[1]-1], $GUI_CHECKED)

;Config.win Group box
;$Y = 70
;GUICtrlCreateGroup  ("Config Win File", 320,$Y,150,300)
;Dim $CONFIGS_WIN_RADIOS[$PRO_CONFIG_WINS_IDs[0]]
;$Y = $Y + 30
;For $i=1 to $PRO_CONFIG_WINS_IDs[0]
;	$CONFIGS_WIN_RADIOS[$i-1] = GUICtrlCreateRadio ($PRO_CONFIG_WINS[$i], 325,$Y,140,20)
;	$Y = $Y + 20
;Next
;GUICtrlSetState ($CONFIGS_WIN_RADIOS[$DEF_CONFIG_WIN_FILE[1]-1], $GUI_CHECKED)

;Mapkey files Group box
$Y = 70
GUICtrlCreateGroup("Variable Settings", 215, $Y, 150, 300)
Dim $MAPKEY_CBS[$PRO_MAPKEYS_IDs[0]]
$Y = $Y + 30
For $i = 1 To $PRO_MAPKEYS_IDs[0]
	$MAPKEY_CBS[$i - 1] = GUICtrlCreateCheckbox($PRO_MAPKEYS[$i], 220, $Y, 140, 20)
	$Y = $Y + 20
Next
For $i = 1 To $DEF_MAPKEY_FILES[0]
	GUICtrlSetState($MAPKEY_CBS[$DEF_MAPKEY_FILES[$i] - 1], $GUI_CHECKED)
Next

;End the group definitions
GUICtrlCreateGroup("", -99, -99, 1, 1)

;LAUNCH Tab Buttons...
$PTCSTATUS = GUICtrlCreateButton("PTC STATUS", 215, 375, 100, 20)
$LAUNCH = GUICtrlCreateButton("START", 315, 375, 50, 20)


;END THE TAB DEFINITIONS
;-----------------------------------------------------------------
GUICtrlCreateTabItem("")

;DISPLAY THE UI
;-----------------------------------------------------------------
GUISetState()
;-----------------------------------------------------------------
;=> END GENERATE THE UI
;-----------------------------------------------------------------

;-----------------------------------------------------------------
;RUN THE UI
;-----------------------------------------------------------------
; Run the GUI until the dialog is closed
$cmdline[1]
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $LAUNCH
			LaunchProE()
		CASE $MSG = $PTCSTATUS
			RUNWAIT (@ComSpec & " /c ptcstatus")
			;Case $msg = $CLEARWORKDIR
			;	ClearWorkingDirectory()
			;Case $msg = $SAVEXMLFILE
			;	SaveEditedXML()
	EndSelect
WEnd
;-----------------------------------------------------------------
;=> END GENERATE THE UI
;-----------------------------------------------------------------

;-----------------------------------------------------------------
;<--------------------------END OF PROGRAM----------------------->
;-----------------------------------------------------------------


;-----------------------------------------------------------------
;USER DEFINED FUNCTIONS AREA
;-----------------------------------------------------------------

;THIS FUNCTION READS WHAT THE USER HAS SELECTED, MAKES COPIES OF
;SELECTED FILES INTO WORKING DIRECTORY AND LAUNCHES PRO/E
Func LaunchProE()
	;Figure out which version is selected
	$SelVersionExecutable = "proe"
	For $i = 0 To $PRO_VERSIONS_IDs[0] - 1
		If BitAND(GUICtrlRead($VERSION_RADIOS[$i]), $GUI_CHECKED) = $GUI_CHECKED Then
			$SelVersionExecutable = $PRO_VERSIONS_FILES[$i + 1]
				RegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment", "pro_ver", "reg_sz", $version[$i + 1])
				RegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment", "pro_date", "reg_sz", $code[$i + 1])
				;RegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment", "proe_work_dir", "reg_sz", "d:\HOME\users\%username%")
				RegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment", "ptc_wf_root", "reg_sz", "d:\HOME\users\%username%")
				EnvSet ("pro_ver", $version[$i + 1])
				EnvSet ("pro_date", $code[$i + 1])
				EnvUpdate()
			ExitLoop
		EndIf
	Next

	;Figure out which config.pro has been selected
	;$SelConfig = "config"
	;for $i=0 to $PRO_CONFIG_PROS_IDS[0]-1
	;	If BitAND(GUICtrlRead($CONFIGS_RADIOS[$i]), $GUI_CHECKED)= $GUI_CHECKED Then
	;		$SelConfig = $PRO_CONFIG_PROS_FILES[$i+1]
	;		ExitLoop
	;	EndIf
	;Next

	;Figure out which config.win has been selected
	;$SelConfigWin = "config"
	;for $i=0 to $PRO_CONFIG_WINS_IDS[0]-1
	;	If BitAND(GUICtrlRead($CONFIGS_WIN_RADIOS[$i]), $GUI_CHECKED)= $GUI_CHECKED Then
	;		$SelConfigWin = $PRO_CONFIG_WINS_FILES[$i+1]
	;		ExitLoop
	;	EndIf
	;Next
	Opt("ExpandEnvStrings", 1)
	;Start the new Config.pro and copy the config.win
	$dest = ("D:\ptc\%pro_ver%_%pro_date%_%PROCESSOR_ARCHITECTURE%\text\")
	$dest2 = ("D:\ptc\%pro_ver%_%pro_date%_%PROCESSOR_ARCHITECTURE%\bin\")
	;FileCopy ( $SelConfig, $dest , 1 )
	;FileCopy ( $SelConfigWin, $dest , 1 )
	;$bits = StringSplit ($SelConfig, "\")
	;$config_pro_file_name = $bits[$bits[0]]
	;$bits = StringSplit ($SelConfigWin, "\")
	;$config_win_file_name = $bits[$bits[0]]
	FileCopy("config_pros\config.pro", $dest & "\config.pro", 1)
	FileCopy("config_wins\config.win", $dest & "\config.win", 1)
	FileCopy("config_sup\config.sup", $dest & "\config.sup", 1)
	FileCopy("bin\*", $dest2 & "\", 1)


	;Figure out which mapkeys are needed
	;Append mapkeys to end of config file
	$file1 = FileOpen($dest & "\config.pro", 1)
	If $file1 = -1 Then
		MsgBox(0, "Error", "Unable to open generated Config file.")
		Exit
	EndIf
	FileWriteLine($file1, @CRLF & "!MAPKEYS SECTION" & @CRLF & @CRLF)
	For $i = 0 To $PRO_MAPKEYS_IDs[0] - 1
		If BitAND(GUICtrlRead($MAPKEY_CBS[$i]), $GUI_CHECKED) = $GUI_CHECKED Then

			$file2 = FileOpen($PRO_MAPKEYS_FILES[$i + 1], 0)
			While 1
				$line = FileReadLine($file2)
				If @error = -1 Then ExitLoop
				FileWriteLine($file1, $line)
			WEnd
			FileClose($file2)
		EndIf
	Next
	FileClose($file1)
if ProcessExists('xtop.exe') Then
    MsgBox(0,'','Pro/E is already running')
	Exit
EndIf
	;Launch Correct Pro/E with correct Config
	Run($SelVersionExecutable, "d:\home\users\%username%", @SW_MAXIMIZE)
MsgBox(0,'','Please wait for Pro/E to run')
EndFunc   ;==>LaunchProE


;FUNCTION OVERWRITES XML_FILE WITH CONTENT FROM EDIT CONTROL
;IT ALSO EXITS THE APPLICATION
Func SaveEditedXML()
	$NEW_XML_CONTENTS = GUICtrlRead($STARTUP_XML_FILE_INPUT)
	$file = FileOpen("startup.xml", 2)

	; Check if file opened for writing OK
	If $file = -1 Then
		MsgBox(0, "Error", "Unable to write Startup.xml file.")
		Exit
	EndIf

	FileWrite($file, $NEW_XML_CONTENTS)
	FileClose($file)
	MsgBox(0, "Info", "XML Saved. Restart Application to see changes.")
	Exit
EndFunc   ;==>SaveEditedXML