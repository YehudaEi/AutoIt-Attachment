#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=ALIBI_Run_ico.ico
#AutoIt3Wrapper_Res_Comment=ALIBI run prompt replacement
#AutoIt3Wrapper_Res_Fileversion=4.1.0.0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;################ CHANGE #AutoIt3Wrapper_Res_Fileversion= TO!!! ################
$VER = "4.1.0"
;################ CHANGE #AutoIt3Wrapper_Res_Fileversion= TO!!! ################
AutoItSetOption("TrayAutoPause", 0)
Opt("TrayIconHide", 1)



#CS ##################################################################################
	|
	|		Script Name		Run.au3
	|		Program Name	ALIBI Run
	|		Company			ALIBI
	|		Author			Rickard Lantz
	|		Forum Name		ColaFrysen
	|		Contact			rickard.lantz(at)gmail.com
	|
	|		Script Function ALIBI Run is a replacement for the run prompt in
	|						Windows XP. It adds Live calculations, Open applications
	|						Using keywords, an editor for editing the keywords
	|						(Prefs.au3) And easy access to information such as IP,
	|						Computername, IP of other computers etc. It also
	|						Features functions to quicky run a command in CMD,
	|						Google with a click and more.
	|
	|		Notes			This code Is by part badly written, the project has
	|						been going on a While and therefore some parts of the
	|						code are from the time a was a biginner. (well more
	|						noobish than i am now :P)
	|
#Ce #################################################################################

#cs -----CREDITS-----
	Colafrysen - Idea and script, exept parts made by:
	MrCreatoR - Function "_Execute_Proc()"
	Sandin - The Sliding ChildGUI Functions (They are scattered throughout the script)
	Amel27? (i have seen this on many places on the forums) - For the "_NetServerEnum" Function, and the corresponding constants
#ce

#cs VERISION CHANGES
	4.1.0 Commented out includes that are not used
	4.1.0 Added setting to have last entered text default in main input
	4.1.0 No restart required when changed the topmost setting
	4.0.8 Rewrote the custom list functions.
	4.0.7 Fixed a bug where the last two items in the custom list appeared as one
	4.0.6 Declared copyitem to avoid crash when nothing has been written in the prompt
	4.0.6 Cleaned
	4.0.5 Added in application help
	4.0.5 Fixed a bug with an trailing 0 after Show Workgroup()Computers after changes had been made.
	4.0.5 Fixed a bug where the window faded twice when "open preferences editor" was selected.
	4.0.5 Added Web: to open link with googles i'm feeling lucky(Same syntax as calc and google)
	4.0.5 Made the Dos-prompt look like i want it to :P
	4.0.5 Added Run in CMD (Same syntax as calc and google)
	4.0.5 Added Google-search by writing Google:[searchstring]
	4.0.5 Added new functionality; if Ctrl is held down when ok or enter is pressed, ALIBI Run does not close.
	4.0.4 Added some more folders to menu
	4.0.3 Declered Specialinput at top as it was not declared by the else in main loop (no change in input was made so ELSE not triggered)
	4.0.3 Commented a lot of the script, added (requires restart) to Always on top checkbox
	4.0.2 Fixed IpE - now shows after update
	4.0.2 Disabled Childguisettrans to improve loopspeed
	4.0.2 Fixed issue where labels flickered, by putting an "If $OldInp <> $Input Then" Func in script #Thanks to MDiesel#
	4.0.1 Fixed issue where the fadeout was triggered (OK) even when animations=0
	4.0.0 Made changes apply when "Save and Apply" is pushed; no restart needed
	4.0.0 Increased Slide Speed from 1000 to 500 & added constant 'e' NEED MORE DIGITS
	3.9.3 Changed label Opacity to Opacity
	3.9.3 Changed "computer" to "name" for getting computername
	3.9.3 Fixed an issue where custom list was shown even when INI was set to 0
	3.9.3 Cleaned up so that all preferences read at start are in one function
	3.9.3 Cleaned up a bit (its a start...) by making the get computers a separate function.
	3.9.2 New fix, added @AppDataDir for ini functions
	3.9.1 Tries to create the ini before checking if it exists....
	3.9 CRITICAL FIX - Error where no values in custom list triggered a state where list became unpopulated (guictrlsetdata("|")
	3.8.7 Spelling Fixes when creating INI + added button to open ALIBI Prefs
	3.8.6 removed the ability to pause the program via the tray + removed trayicon
	3.8.5 fixed a misspelling with adress instead of address
	3.8 added the functionality to do calculations with PI u NA and to automaticaly change the ',' to'.' new Func _StringUseVars()
	3.8 Also removed an misstyped whitespace in title label after ALIBI Also added ablility to open EnvVariables
	3.7 added func _IPRENEW() to renew ip also added a label indicating the IPR command exists
#CE



;~ #include <GUIComboBox.au3>
#include <GuiComboBoxEx.au3>
#include <ButtonConstants.au3>
;~ #include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
;~ #include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Process.au3>
;~ #include <WinAPI.au3>
#include <String.au3>
#include <Array.au3>
#include <INet.au3>
;~ #include <Math.au3>
#include <Misc.au3>
TCPStartup()

#Region SETING VARIABLES
$StartingPos = 0
$INI_CUST_ITEMS = 15 ;Specifies how many items there are in custom list, This affects how many items that is created in the $INI on first run-
$Icons = 1 ;Set to one if script should be compiled with icons
$Dir = @MyDocumentsDir ;The standard working dir when running something, also opens if pressed ok when ni input is entered
$Start_TRANS = 240 ;The opacity that will be applied to ALIBI Run on first start, not used if $INI exists
$Title = "ALIBI Run " & $VER ;The title of the program
$ipremote = "Not set";_GetIP() ;Activating this causes a slight lag on startup while contacting autoit's servers, especially if you are offline
$temp = EnvGet("TEMP") ;The temporary files variable. this is where icons and such are extracted to
Global Const $AlibiWeb = "                                                                                        " ;My website
$updatedIpE = False ;Variable to specify if the External IP has been updated, if true then updated ip will update in main loop
$SpecialInput = False ;Variable to tell that specialinput is not set at script start
$COPYITEM = ''
$Editor_Path = @ScriptDir & "\Prefs.exe" ;The path where the ALIBI Run Preferences (Prefs.exe) is located
$Input = "" ;What input is set to before it is owerwritten by main loop, needed bucause of "$OldInp = $Input" (first lines in main loop)
Dim $file, $2, $hiddenmsg2, $aCompList, $INI_CUST[$INI_CUST_ITEMS + 1], $INI_CUST_PATH[$INI_CUST_ITEMS + 1], $INI_CUST_DIR[$INI_CUST_ITEMS + 1], $CUST_LIST = '          ', $CUST_LIST_PATH, $CUST_LIST_DIR
Dim $CUST_LIST_SET
$HiddenMSG = "" ;What the hidden message is before being owerwritten by main loop
;~ $pi = 3.14159265358979 ;PI
;~ $pi_long = 3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282306647 ;A more accurate PI (worthless)
$NOReplacements = 5 ;The number of replacements to be done in the "_StringUseVars" Function, this must be same as in the $Replacements array
Dim $Replacements[$NOReplacements][2] = [["pi", '(3.14159265358979)'],["e", '(2.71828)'],["u", '(1.660539*10^-27)'],['NA', '(6.022142*10^23)'],[',', '.']]; the replacements to be done in the "_StringUseVars" Function
Global $INI_ANIM ;Creates Variables for the ini-read & write which is now in functions
Global $INI_TRAN ;Creates Variables for the ini-read & write which is now in functions
Global $INI_AWOT ;Creates Variables for the ini-read & write which is now in functions
Global $INI_SWGC ;Creates Variables for the ini-read & write which is now in functions
Global $INI_SWGCIP ;Creates Variables for the ini-read & write which is now in functions
Global $INI_UYCL ;Creates Variables for the ini-read & write which is now in functions
Global $INI_LEID ;Creates Variables for the ini-read & write which is now in functions
Global $AWOT_CONSTANT ;Creates Variables for the ini-read & write which is now in functions
Global $WorkGroup ;Creates Variables for the get computers in lan function
#Region ---CREATING INI-FILE---
$INI = @AppDataDir & "\ALIBIRunPreferences.ini" ;Where the preferences will be stored
If FileExists($INI) = 0 Then
	_Create_INI($INI)
EndIf
If FileExists($INI) = 0 Then
	$INI = @MyDocumentsDir & "\ALIBIRunPreferences.ini" ;Where the preferences will be stored if the last place was protected
	_Create_INI($INI)
EndIf
#EndRegion ---CREATING INI-FILE---
#EndRegion SETING VARIABLES
#Region ---GET COMPUTERNAMES---
$wbemFlagReturnImmediately = 0x10 ;---------Variables used by the get computers in lan function----------
$wbemFlagForwardOnly = 0x20 ;---------Variables used by the get computers in lan function----------
$strComputer = "localhost" ;;---------Variables used by the get computers in lan function----------
$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2") ;;---------Variables used by the get computers in lan function----------
$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_ComputerSystem", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly) ;;---------Variables used by the get computers in lan function----------
Global Const $SV_TYPE_WORKSTATION = 0x1
Global Const $SV_TYPE_SERVER = 0x2
Global Const $SV_TYPE_SQLSERVER = 0x4
Global Const $SV_TYPE_DOMAIN_CTRL = 0x8
Global Const $SV_TYPE_DOMAIN_BAKCTRL = 0x10
Global Const $SV_TYPE_TIME_SOURCE = 0x20
Global Const $SV_TYPE_AFP = 0x40
Global Const $SV_TYPE_NOVELL = 0x80
Global Const $SV_TYPE_DOMAIN_MEMBER = 0x100
Global Const $SV_TYPE_PRINTQ_SERVER = 0x200
Global Const $SV_TYPE_DIALIN_SERVER = 0x400
Global Const $SV_TYPE_XENIX_SERVER = 0x800
Global Const $SV_TYPE_NT = 0x1000
Global Const $SV_TYPE_WFW = 0x2000
Global Const $SV_TYPE_SERVER_MFPN = 0x4000
Global Const $SV_TYPE_SERVER_NT = 0x8000
Global Const $SV_TYPE_POTENTIAL_BROWSER = 0x10000
Global Const $SV_TYPE_BACKUP_BROWSER = 0x20000
Global Const $SV_TYPE_MASTER_BROWSER = 0x40000
Global Const $SV_TYPE_DOMAIN_MASTER = 0x80000
Global Const $SV_TYPE_WINDOWS = 0x400000
Global Const $SV_TYPE_CLUSTER_NT = 0x1000000
Global Const $SV_TYPE_TERMINALSERVER = 0x2000000
Global Const $SV_TYPE_CLUSTER_VS_NT = 0x4000000
Global Const $SV_TYPE_LOCAL_LIST_ONLY = 0x40000000
Global Const $SV_TYPE_DOMAIN_ENUM = 0x80000000
Global Const $SV_TYPE_ALL = 0xFFFFFFFF
#EndRegion ---GET COMPUTERNAMES---



#Region INSTALL TEMP
If $Icons = 1 Then ;Extraction of icons to $temp
	$INSTALLOK = FileInstall("run_icon.ico", $temp & '\run_icon.ico', 0)
	$INSTALLOK = FileInstall("help_icon.ico", $temp & '\help_icon.ico', 0)
	$INSTALLOK = FileInstall("INI_icon.ico", $temp & '\INI_icon.ico', 0)
Else
	$INSTALLOK = 0
EndIf
#EndRegion INSTALL TEMP

#Region _StartUp ;STARTING up script by reading preferences and applying them
_Read_INI() ;Reading INI-File
_Apply_Prefs() ;Applying Preferences
#EndRegion _StartUp 

#Region HOTKEYS
HotKeySet("!c", "F_EXIT") ;Exit hotkey, shown on cancel button
HotKeySet("!o", "F_OK") ;OK hotkey, shown on OK button
HotKeySet("!b", "F_BROWSE") ;Browse hotkey, shown on Browse button
HotKeySet("^+c", "COPY") ;Hotkey for copying values from the hiddenmsg
HotKeySet("{F1}", "HELP") ;Hotkey for opening the Help/about msgbox

#EndRegion HOTKEYS
#Region GUI CREATION ;OLD KODA (HEAVILY CHANGED MANUALLY) Form=c:\documents and settings\ricky\desktop\run.kxf
$RunBox = GUICreate($Title, 345, 155, 515, 285, BitOR($WS_BORDER, $WS_POPUP), BitOR($WS_EX_WINDOWEDGE, $AWOT_CONSTANT))
$Pos = _PosConv($RunBox, $StartingPos)
WinMove($RunBox, "", $Pos[0], $Pos[1])
If $INI_AWOT = 1 Then GUISetStyle(-1, $WS_EX_TOPMOST, $RunBox) ;If variable (defined by $INI) Always on top = 1 then...
$IconRUN = GUICtrlCreateIcon($temp & '\run_icon.ico', "", 8, 8, 42, 42, 0, $GUI_WS_EX_PARENTDRAG) ;Create app main icon
$IconHELP = GUICtrlCreateIcon($temp & '\help_icon.ico', "", 311, 8, 24, 24) ;Create '?' icon
$Label1 = GUICtrlCreateLabel("Type the name of a program, folder, document, or" & @CRLF & "Internet resource, and ALIBI will open it for you.", 58, 18, 250, 29, -1, $GUI_WS_EX_PARENTDRAG) ;Main label, you can drag the window in this one
$Label3 = GUICtrlCreateLabel("", 48, 85, 260, 30, -1, $GUI_WS_EX_PARENTDRAG) ;HiddenMSG Label
$Label2 = GUICtrlCreateLabel("Open:", 11, 63, 33, 17) ;Open label
$Path = GUICtrlCreateCombo("", 48, 60, 260, 20, 0x50210842, 0x00000000);Main Combo
GUICtrlSetState($Path, $GUI_FOCUS) ;Set focus on combo
$OK = GUICtrlCreateButton("&OK", 93, 114, 75, 23, $BS_DEFPUSHBUTTON) ;_OK (default)
$Cancel = GUICtrlCreateButton("&Cancel", 174, 114, 75, 23, 0) ;_Cancel
$Browse = GUICtrlCreateButton("&Browse...", 255, 114, 75, 23, 0) ;_Browse
$SLIDE_Info = GUICtrlCreateLabel("Help and preferences", 5, 140, 330) ;Help and prefs
GUICtrlSetFont($SLIDE_Info, 8.5, 400, 4) ;Help and prefs set font
WinSetTrans($RunBox, "", $Start_TRANS) ;Set opacity
GUISetState(@SW_SHOW) ;Show GUI
#EndRegion GUI CREATION 

#Region SLIDE GUI
$parrent = $RunBox ;Define parrent window
;Constants
Global Const $WM_ENTERSIZEMOVE = 0x0231
Global Const $WM_EXITSIZEMOVE = 0x0232
$main_height = 255 ;Height of the CHILD Window
$slide_speed = 500 ;SLIDE SPEED, Lower = Faster
$ParentPosArr = WinGetPos($parrent) ; Get MAIN GUI position

#Region CHILD GUI CREATION
$nocenter = -115 ;Constant to make controls created in childgui not appearing in center
$offset = 0 ;Offset all items vertically in childgui
$fullwidth = 320 ;the full width of child
$ChildGui = GUICreate("Info and preferences", 100, $main_height, $ParentPosArr[0] + $ParentPosArr[2], $ParentPosArr[1] + 5, $WS_POPUP, $WS_EX_MDICHILD, $parrent)
$childpos = WinGetPos($ChildGui)
$ChildButton1 = GUICtrlCreateButton("Save and Close", $childpos[2] / 2 - 100, 5, 200, 20)
GUICtrlSetResizing(-1, $GUI_DOCKWIDTH + $GUI_DOCKHCENTER) ;button will be in center, and will not change width in case of window increasement (like when u press button2)
$ChildButton2 = GUICtrlCreateButton("Save and Apply", $childpos[2] / 2 - 100, 25, 200, 20)
GUICtrlSetResizing(-1, $GUI_DOCKWIDTH + $GUI_DOCKHCENTER)
$PREFS_TransLabel = GUICtrlCreateLabel("Opacity", $nocenter + 5, 60 + $offset, $fullwidth, 20, -1, $GUI_WS_EX_PARENTDRAG)
GUICtrlSetResizing(-1, $GUI_DOCKWIDTH + $GUI_DOCKHCENTER)
$PREFS_Trans = GUICtrlCreateSlider($nocenter + 5, 80 + $offset, $fullwidth, 20)
GUICtrlSetResizing(-1, $GUI_DOCKWIDTH + $GUI_DOCKHCENTER)
GUICtrlSetLimit($PREFS_Trans, 254, 20) ;Limit slider values (max causes flicker, and min... well window dissapears)
GUICtrlSetData($PREFS_Trans, $INI_TRAN) ;Apply the value read in the INI file to the slider
$PREFS_Icon = GUICtrlCreateIcon($temp & '\INI_icon.ico', "", $nocenter + 7, 5 + $offset, 48, 48)
GUICtrlSetResizing(-1, $GUI_DOCKWIDTH + $GUI_DOCKHCENTER)

$PREFS_Import = GUICtrlCreateCheckbox("Use Custom list of items", $nocenter + 5, 110 + $offset, $fullwidth - 150, 20)
GUICtrlSetResizing(-1, $GUI_DOCKWIDTH + $GUI_DOCKHCENTER)
_SETSTATE(-1, $INI_UYCL)
$PREFS_ImportButton = GUICtrlCreateButton("Open Custom List", $nocenter + 200, 110 + $offset, $fullwidth - 200, 20)
GUICtrlSetTip(-1, "With your default text editor." & @CRLF & "Open it with ALIBI Preferences editor by clicking the button at the bottom of this window")
GUICtrlSetResizing(-1, $GUI_DOCKWIDTH + $GUI_DOCKHCENTER)
$PREFS_Animate_me = GUICtrlCreateCheckbox("Use window animations", $nocenter + 5, 130 + $offset, $fullwidth, 20)
GUICtrlSetResizing(-1, $GUI_DOCKWIDTH + $GUI_DOCKHCENTER)
_SETSTATE(-1, $INI_ANIM)
$PREFS_Show_Workgroup = GUICtrlCreateCheckbox('Show computers when chosen "' & '--Workgroup () computers:' & '"', $nocenter + 5, 150 + $offset, $fullwidth, 20)
GUICtrlSetResizing(-1, $GUI_DOCKWIDTH + $GUI_DOCKHCENTER)
_SETSTATE(-1, $INI_SWGC)
$PREFS_Show_IP = GUICtrlCreateCheckbox("Show remote IP-Address when selecting a workgroup computer", $nocenter + 5, 170 + $offset, $fullwidth, 20)
GUICtrlSetResizing(-1, $GUI_DOCKWIDTH + $GUI_DOCKHCENTER)
_SETSTATE(-1, $INI_SWGCIP)
$PREFS_Show_Topmost = GUICtrlCreateCheckbox("Always on top", $nocenter + 5, 190 + $offset, $fullwidth, 20)
GUICtrlSetResizing(-1, $GUI_DOCKWIDTH + $GUI_DOCKHCENTER)
_SETSTATE(-1, $INI_AWOT)
$PREFS_Make_Default = GUICtrlCreateCheckbox("Make last executed item default", $nocenter + 5, 210 + $offset, $fullwidth, 20)
GUICtrlSetResizing(-1, $GUI_DOCKWIDTH + $GUI_DOCKHCENTER)
_SETSTATE(-1, $INI_AWOT)
$PREFS_OPEN_EDITOR = GUICtrlCreateButton("Open ALIBI Run Preferences editor", $nocenter + 5, 230 + $offset, $fullwidth, 20)
GUICtrlSetResizing(-1, $GUI_DOCKWIDTH + $GUI_DOCKHCENTER)
;~ $PREFS_Auto_Complete = GUICtrlCreateCheckbox("Make sugesstions as you write", $nocenter + 5, 210 + $offset, $fullwidth, 20)
;~ GUICtrlSetResizing(-1, $GUI_DOCKWIDTH + $GUI_DOCKHCENTER)
;~ _SETSTATE(-1, $INI_ACWW)
$childpos = WinGetPos($ChildGui)
GUICtrlCreateGraphic(0, 0, 330, $main_height, 0x07) ;gray line on the edge of the pop up window
GUISetState(@SW_HIDE, $ChildGui)
#EndRegion CHILD GUI CREATION

#Region SHADED GUI CREATION
$child2 = GUICreate("Shade", 100, $main_height, $ParentPosArr[0] + $ParentPosArr[2], $ParentPosArr[1] + 5, $WS_POPUP, $WS_EX_MDICHILD, $parrent) ;transparent window to lock main window when child is opened
GUISetBkColor(0x000000, $child2) ;Set the color of the shade
WinSetTrans($child2, "", 100) ;Opacity of shade
GUISetState(@SW_HIDE, $child2) ;Hide shade until later
#EndRegion SHADED GUI CREATION
_Standard_List() ;---------------------------------------------------------APPLYING LIST---------------------------------------------------------------------------------
#EndRegion SLIDE GUI



#Region WHILE ########################### THIS IS THE MAIN LOOP ##############################
While 1
;~ 	_FadeDistance(10) ;Uncomment if you want ALIBI run to fade when your cursor is not near it
	$nMsg = GUIGetMsg(0) ;Get GUI-MSG
	Switch $nMsg ;Switch it
		Case $GUI_EVENT_CLOSE ;If closed
			Exit ;Exit without any animations ect.
		Case $OK ;If OK
			Call("F_OK") ;Call OK Function
		Case $Cancel ;If Cancel
			Call("F_EXIT", 2) ;Call Cancel Function
		Case $Browse ;If Browse
			Call("F_BROWSE") ;Call Browse Function
		Case $SLIDE_Info ;If Slider info
			_show_child_window($SLIDE_Info, $slide_speed) ;slide in pop-up window
		Case $ChildButton1 ; CLOSE THE CHILD GUI
			_slide_out($ChildGui, $slide_speed) ;close it
		Case $IconHELP ;if '?' Icon AND icon installed
			HELP() ;slide out pop-up window
		Case $PREFS_ImportButton ;Case "open custom list"
			$SpecialInput = "PRESET";Set preset to be handled by "F_OK()"
			F_OK()
		Case $ChildButton2 ;Save and apply
			_SAVEPREFS() ;Save
		Case $PREFS_OPEN_EDITOR ;Open ALIBI Run Preferences
			_OPEN_EDITOR() ;Open it
		Case $PREFS_Animate_me
			_UPDATEPREFS()
		Case $PREFS_Import
			_UPDATEPREFS()
		Case $PREFS_Show_IP
			_UPDATEPREFS()
		Case $PREFS_Show_Topmost
			_UPDATEPREFS()
		Case $PREFS_Show_Workgroup
			_UPDATEPREFS()
		Case $PREFS_Trans
			_UPDATEPREFS()
		Case $PREFS_Make_Default
			_UPDATEPREFS()
	EndSwitch
	$OldHiddenMsg = $HiddenMSG
	$OldInp = $Input ;Check for changes in combo
	$Input = GUICtrlRead($Path) ;Check combo
	If $OldInp <> $Input Or $updatedIpE = True Or $OldHiddenMsg <> $HiddenMSG Then ;if changes made OR IPE was updated Then update HiddenMSG
		$updatedIpE = False
		Switch $Input

			Case "          My Documents"
				$HiddenMSG = 'Press OK to open "My Documents"'
				$SpecialInput = "MyDocs"
			Case "          My Computer"
				$HiddenMSG = 'Press OK to open "My Computer"'
				$SpecialInput = "MyComp"
			Case "          Control Panel"
				$HiddenMSG = 'Press OK to open the Control Panel' & @CRLF & 'This does not work on all computers'
				$SpecialInput = "ControlPanel"
			Case "          My Network places"
				$HiddenMSG = 'Press OK to open "My network places"'
				$SpecialInput = "MyNetw"
			Case "ALIBI" ;If ALIBI --> Link website
				$HiddenMSG = "Yep thats me, Press OK to open website"
				$SpecialInput = "ALIBI" ;Set var to open webbsite when handeled by "F_OK()"
			Case "help"
				$HiddenMSG = "Press F1 to open a help box"
			Case "CALC"
				$HiddenMSG = "Format: Calc:[expression]"
			Case "Google"
				$HiddenMSG = "Format: Google:[searchstring]"
			Case "Web"
				$HiddenMSG = "Format: Web:[searchstring]"
			Case "CMD"
				$HiddenMSG = "Format: CMD:[Command]"
			Case "ip"
				$HiddenMSG = "Your IP is " & @IPAddress1 & @CRLF & 'The command "IPR" Renews the IP'
				$COPYITEM = @IPAddress1
			Case "ip2"
				$HiddenMSG = "Your IP is " & @IPAddress2 & @CRLF & 'The command "IPR" Renews the IP'
				$COPYITEM = @IPAddress2
			Case "ip3"
				$HiddenMSG = "Your IP is " & @IPAddress3 & @CRLF & 'The command "IPR" Renews the IP'
				$COPYITEM = @IPAddress3
			Case "ip4"
				$HiddenMSG = "Your IP is " & @IPAddress4 & @CRLF & 'The command "IPR" Renews the IP'
				$COPYITEM = @IPAddress4
			Case "ipr"
				$HiddenMSG = "Press OK to release and renew your IP (using ipconfig)"
				$SpecialInput = "iprenew"
			Case "ipE"
				$HiddenMSG = "Your external IP is " & $ipremote & @CRLF & "Press OK to update"
				$COPYITEM = $ipremote
				$SpecialInput = "UPDATEIP"
			Case "Name"
				$HiddenMSG = "Your computername is " & @ComputerName
				$COPYITEM = @ComputerName
			Case "User"
				$HiddenMSG = "Your username is " & @UserName
				$COPYITEM = @UserName
			Case "--Custom"
				$HiddenMSG = "Press OK to change your Custom Presets"
				$COPYITEM = "Not Set"
				$SpecialInput = "PRESET"
			Case "Function Not Enabled..."
				$HiddenMSG = "Press OK to enable"
				$SpecialInput = "Enable_SWGC"
			Case "--Workgroup(" & $WorkGroup & ") computers:"
				$SpecialInput = "Get_Computers"
				If $INI_SWGC = 1 Then ;if $INI specifies that the list should be gathered at hover then
					_Get_Computers() ;Do so
				Else ;If not
					$HiddenMSG = "Press OK to enumerate computer list" ;Ask
				EndIf
			Case Else ;if none of above applies...
				$HiddenMSG = ""
				$COPYITEM = "Not Set"
				$SpecialInput = False
		EndSwitch

		If StringInStr($Input, "\\") = 1 And $INI_SWGCIP = 1 Then ;If $INI specifies that IP should be gathered, and string starts with '\\' THEN
			$ComputertoIP1 = '"' & $Input & '"' ;Quote inputed string
			$ComputertoIP2 = _StringBetween($ComputertoIP1, '"\\', '"') ;Get the computers name ONLY (by taking the info between the '"' and '"\\')
			$ComputertoIP3 = TCPNameToIP($ComputertoIP2[0]) ;get computers IP
			$HiddenMSG = $ComputertoIP3 ;Set as HiddenMSG and CopyItem
			$COPYITEM = $ComputertoIP3
			_UPDATEINPUT($HiddenMSG) ;Update the HiddenMSG
		EndIf

		If StringInStr($Input, "Calc:") = 1 Then ;IF String starts with "Calc:" THEN
			$SpecialInput = "DISABLE" ;No special action if pressed OK
			$1 = '"' & $Input & '"' ;Quote...
			$2 = _StringBetween($1, '"Calc:', '"') ;Get all info after 'Calc:'
			$3 = _StringUseVars($2[0], $NOReplacements, $Replacements) ;Replace some strings like 'Pi' and ',' with '3.14...' and '.'
			$HiddenMSG = Execute($3[0]) ;execute the string to get an answer
			$COPYITEM = $HiddenMSG ;set hiddenMSG
		EndIf

		If StringInStr($Input, "Google:") = 1 Then ;IF String starts with "Google:" THEN
			$SpecialInput = "Google" ;special input Google if pressed OK
			$G_1 = '"' & $Input & '"' ;Quote...
			$Google_String = _StringBetween($G_1, '"Google:', '"') ;Get all info after 'Google:'
			If $Google_String[0] <> "" Then $HiddenMSG = 'Google "' & $Google_String[0] & '"'
		EndIf

		If StringInStr($Input, "Web:") = 1 Then ;IF String starts with "Web:" THEN
			$SpecialInput = "Web" ;special input Web if pressed OK
			$W_1 = '"' & $Input & '"' ;Quote...
			$Web_String = _StringBetween($W_1, '"Web:', '"') ;Get all info after 'Web:'
			If $Web_String[0] <> "" Then $HiddenMSG = 'Open "' & $Web_String[0] & '" with I''m feeling lucky from Google'
		EndIf

		If StringInStr($Input, "CMD:") = 1 Then ;IF String starts with "CMD:" THEN
			$SpecialInput = "CMD" ;special input CMD if pressed OK
			$CMD_1 = '"' & $Input & '"' ;Quote...
			$CMD_String = _StringBetween($CMD_1, '"CMD:', '"') ;Get all info after 'CMD:'
			If $CMD_String[0] <> "" Then $HiddenMSG = 'Run "' & $CMD_String[0] & '" in the command prompt'
		EndIf
		_UPDATEINPUT($HiddenMSG)
	EndIf
	Sleep(50) ;Sleep to avoid Flicker and to save CPU & Memory
WEnd
#EndRegion WHILE ########################### THIS IS THE MAIN LOOP ##############################


#Region FUNCTIONS
Func F_EXIT($flag) ;Exits the program ### ;1 - Exit, 2 - Exit with fade, 3 - Check if Ctrl is pressed and exit if its not.
	Switch $flag
		Case 1
			Exit
		Case 2
			If $INI_ANIM = 1 Then ;IF animations are on, Fade ELSE just exit
				; GUIWindow,START TRANSPARANCY, END TRANSPARANCY, DECRESE TRANS EVERY LOOP, SLEEP EVERY LOOP
				_Fade_OUT($RunBox, $Start_TRANS, 1, 0.8, 0)
				Exit
			Else
				Exit
			EndIf
		Case 3
			If _IsPressed("11") Then
				WinActivate($Title)
			Else
				If $INI_ANIM = 1 Then ;IF animations are on, Fade ELSE just exit
					; GUIWindow,START TRANSPARANCY, END TRANSPARANCY, DECRESE TRANS EVERY LOOP, SLEEP EVERY LOOP
					_Fade_OUT($RunBox, $Start_TRANS, 1, 10, 1)
				EndIf
				Exit
			EndIf
		Case 4
			If _IsPressed("11") Then
			Else
				Exit
			EndIf
	EndSwitch
EndFunc   ;==>F_EXIT

Func F_OK() ;OK Button was pushed
	IniWrite($INI, "Preferences", "LastExecutedItem", $Input)
	$InputStrip = StringStripWS($Input, 3) ;Remove the tab (the 10 Spaces)
	$INDEX = _ArrayFindAll($INI_CUST, $InputStrip) ;Se if input contains a code for custom list
	If @error <> 1 And IsArray($INDEX) = 1 Then ;If there was no error and the $INDEX is an array
		$InputStrip = $INI_CUST_PATH[$INDEX[0]] ;Get item from array (Path to EXE)
		$Dir = $INI_CUST_DIR[$INDEX[0]] ;Get item from array (Working dir)
		$Dir = StringTrimRight($Dir, 1) ;Remove Pipe (|)
	EndIf
	$IS_VAR = _StringBetween($InputStrip, '%', '%') ;If input is between '%' (env variable)
	If @error = 0 Then ;If no error
		$InputStrip = '"' & EnvGet($IS_VAR[0]) & '"' ;Get Env-Var
	EndIf



	Switch $SpecialInput ;Switch to see if special item is set
		Case "MyDocs"
			_Execute_Proc(@MyDocumentsDir)
			F_EXIT(3)
		Case "MyComp"
			_Execute_Proc("explorer.exe /root, ,::{20D04FE0-3AEA-1069-A2D8-08002B30309D}") ;Found them strings in "CLSID List" in helpfile
			F_EXIT(3)
		Case "ControlPanel"
			_Execute_Proc("explorer.exe /root, ,::{21EC2020-3AEA-1069-A2DD-08002b30309d}") ;Found them strings in "CLSID List" in helpfile
			F_EXIT(3)
		Case "MyNetw"
			_Execute_Proc("explorer.exe /root, ,::{208D2C60-3AEA-1069-A2D7-08002B30309D}") ;Found them strings in "CLSID List" in helpfile
			F_EXIT(3)
		Case "ALIBI"
			_Execute_Proc($AlibiWeb) ;Open website in default browser
		Case "PRESET"
			_Execute_Proc($INI) ;Open INI-File with default text-editor
		Case "Enable_SWGC"
			$INI_SWGC = 1
		Case "UPDATEIP"
			_UPDATEIP() ;Update external IP-Adress
			$updatedIpE = True
		Case "iprenew"
			_IPRENEW() ;Ipconfig /release --> Ipconfig /renew
		Case "Get_Computers"
			_Get_Computers() ;Enumarate computer list
		Case "Google"
			_Execute_Proc("http://www.google.com/search?hl=en&q=" & $Google_String[0] & "&aq=f&oq=&aqi=g10")
			F_EXIT(3)
		Case "CMD"
			_Execute_Proc('CMD /T:0A  /K  Title ALIBI Run generated CMD && prompt Alibi Run$B$T$B[$P]-$G&&' & $CMD_String[0])
			F_EXIT(3)
		Case "WEB"
			_Execute_Proc('http://google.com/search?btnI=1&q=' & $Web_String[0])
			F_EXIT(3)
		Case Else
			_Execute_Proc($InputStrip, "", $Dir) ;If no specia item is set, run whatever is in the input field
			If @error <> 1 Then ;If no error was set THEN Fade out and close
				F_EXIT(3)
			Else ;Else do nothing
			EndIf
	EndSwitch
EndFunc   ;==>F_OK

Func F_BROWSE()
	$BROWSEFILE = _WinAPI_GetOpenFileName("Browse for file", "All Files (*.*)", @HomeDrive) ;Open Browse prompt
	If Not $BROWSEFILE[0] = 0 Then GUICtrlSetData($Path, $BROWSEFILE[1] & '\' & $BROWSEFILE[2], $BROWSEFILE[1] & '\' & $BROWSEFILE[2]) ;If user shose a file then set path as input
EndFunc   ;==>F_BROWSE

Func _UPDATEINPUT($New)
	GUICtrlSetData($Label3, $New) ;Set data in hiddenMSG
EndFunc   ;==>_UPDATEINPUT

Func COPY()
;~ 	MsgBox(1, "", WinGetState($Title))
	If WinGetState($Title) = 15 And $COPYITEM <> "Not Set" Or "" Then ;If ALIBI Run has focus and $COPYITEM is set then...
		$COPY = $COPYITEM
		ClipPut($COPY) ;Add data to clipboard
		ToolTip('Copied "' & $COPY & '" To Clipboard') ;Show user action is performed
		Sleep(1500) ;sleep
		ToolTip("") ;clear tooltip
	EndIf
EndFunc   ;==>COPY

Func _PosConv($hGui, $StartingPos)
	;15 = middle
	;1 = Top
	;2 = Bottom
	;4 = Left
	;8 = Right
	$Pos_Offset = 30
	$Pos_Offset_border = 0
	$Pos_hGui = WinGetPos($hGui)
	$1_Top = 0 - $Pos_Offset_border; @DesktopHeight/2 + $Pos_hGui[3]/2
	$2_Bottom = @DesktopHeight - $Pos_hGui[3] - $Pos_Offset
	$4_Left = 0 - $Pos_Offset_border; @DesktopWidth/2 +$Pos_hGui[2]/2
	$8_Right = @DesktopWidth - $Pos_hGui[2]
	Dim $Return_Array[2] = [$8_Right / 2, $2_Bottom / 2]
	Return $Return_Array
EndFunc   ;==>_PosConv

Func _SETSTATE($ContHndl, $INI_Var) ;Set state on checkboxes
	If $INI_Var = 1 Then
		GUICtrlSetState($ContHndl, $GUI_CHECKED)
	Else
		GUICtrlSetState($ContHndl, $GUI_UNCHECKED)
	EndIf
EndFunc   ;==>_SETSTATE

Func _GETSTATE($ContHndl) ;Get state on checkboxes
	$State = GUICtrlRead($ContHndl)
	If $State = $GUI_UNCHECKED Then
		$ReturnValue = 0
	Else
		$ReturnValue = 1
	EndIf
	Return $ReturnValue
EndFunc   ;==>_GETSTATE

Func _Read_INI() ;Read the INI-File
	#Region READINI
	Global $INI_ANIM = IniRead($INI, "Preferences", "UseAnimations", 1)
	Global $INI_TRAN = IniRead($INI, "Preferences", "Transparancy", $Start_TRANS)
	Global $INI_AWOT = IniRead($INI, "Preferences", "AlwaysOnTop", 1)
	Global $INI_SWGC = IniRead($INI, "Preferences", "ShowWorkGroupComputers", 1)
	Global $INI_SWGCIP = IniRead($INI, "Preferences", "ShowWorkGroupComputersIP", 1)
	Global $INI_UYCL = IniRead($INI, "Preferences", "UseCustomList", 1)
	Global $INI_LEID = IniRead($INI, "Preferences", "MakeLastUsedItemDefault", 1)
;~ $INI_ACWW = IniRead($INI, "Preferences", "AutoCompleteWhileWriting", 1)
	;######## CLEAR LIST IN CASE OF UPDATE #########
	$CUST_LIST_SET = ''

	Dim $INI_CUST[$INI_CUST_ITEMS + 1], $INI_CUST_PATH[$INI_CUST_ITEMS + 1], $INI_CUST_DIR[$INI_CUST_ITEMS + 1]

	For $x = 1 To $INI_CUST_ITEMS
		$INI_CUST_CURR = IniRead($INI, "CustomList", $x, '')
		If $INI_CUST_CURR <> '' Then $INI_CUST[$x] = $INI_CUST_CURR
		$INI_CUST_CURR_PATH = IniRead($INI, "CustomList", $x & "Path", '')
		If $INI_CUST_CURR_PATH <> '' Then $INI_CUST_PATH[$x] = $INI_CUST_CURR_PATH
		$INI_CUST_CURR_DIR = IniRead($INI, "CustomList", $x & "Dir", '')
		If $INI_CUST_CURR_DIR <> '' Then $INI_CUST_DIR[$x] = $INI_CUST_CURR_DIR
	Next
	Global $Start_TRANS = $INI_TRAN
	#EndRegion READINI
EndFunc   ;==>_Read_INI

Func _Apply_Prefs() ;Apply preferences to script
	If $INI_AWOT = 1 Then
		Global $AWOT_CONSTANT = $WS_EX_TOPMOST ;Set constant for Always on top
	Else
		Global $AWOT_CONSTANT = 0
	EndIf

	#Region GATHERING COMPUTER NAMES IN WORKGROUP
	If IsObj($colItems) Then ;If $colitems is an object (Defined at top of script)
		For $objItem In $colItems
			Global $WorkGroup = $objItem.Domain
		Next
	Else
		Global $WorkGroup = "FAIL" ; if not THEN FAIL
	EndIf
	#EndRegion GATHERING COMPUTER NAMES IN WORKGROUP

EndFunc   ;==>_Apply_Prefs

Func _SAVEPREFS() ;Safe preferences
	If FileExists($INI) Then
		IniWrite($INI, "Preferences", "UseAnimations", _GETSTATE($PREFS_Animate_me))
		IniWrite($INI, "Preferences", "Transparancy", GUICtrlRead($PREFS_Trans))
		IniWrite($INI, "Preferences", "AlwaysOnTop", _GETSTATE($PREFS_Show_Topmost))
		IniWrite($INI, "Preferences", "ShowWorkGroupComputers", _GETSTATE($PREFS_Show_Workgroup))
		IniWrite($INI, "Preferences", "ShowWorkGroupComputersIP", _GETSTATE($PREFS_Show_IP))
		IniWrite($INI, "Preferences", "UseCustomList", _GETSTATE($PREFS_Import))
		IniWrite($INI, "Preferences", "MakeLastUsedItemDefault", _GETSTATE($PREFS_Make_Default))
;~ 		IniWrite($INI, "Preferences", "AutoCompleteWhileWriting", _GETSTATE($PREFS_Auto_Complete))
;~ 		MsgBox (1,"Button values",'animate:'&_GETSTATE($PREFS_Animate_me)&'Slider:'&GUICtrlRead($PREFS_Trans)&'tm:'&_GETSTATE($PREFS_Show_Topmost)&'WG:'&_GETSTATE($PREFS_Show_Workgroup)&'IP:'&_GETSTATE($PREFS_Show_IP)&'AC:'&_GETSTATE($PREFS_Auto_Complete)&'Imp'&_GETSTATE($PREFS_Import))
	EndIf
	Sleep(200)
	GUICtrlSetData($Path, '')
	_Read_INI() ;Read INI
	_Apply_Prefs() ;Apply the preferences
	_Standard_List() ;Reset the list
	WinSetTrans($RunBox, "", GUICtrlRead($PREFS_Trans)) ;Set the transpanrancy
	WinSetOnTop($parrent, "", _GETSTATE($PREFS_Show_Topmost));Set topmost attribute
	_slide_out($ChildGui, $slide_speed) ;Hide the shild window
EndFunc   ;==>_SAVEPREFS

Func _UPDATEPREFS()
	If FileExists($INI) Then
		IniWrite($INI, "Preferences", "UseAnimations", _GETSTATE($PREFS_Animate_me))
		IniWrite($INI, "Preferences", "Transparancy", GUICtrlRead($PREFS_Trans))
		IniWrite($INI, "Preferences", "AlwaysOnTop", _GETSTATE($PREFS_Show_Topmost))
		IniWrite($INI, "Preferences", "ShowWorkGroupComputers", _GETSTATE($PREFS_Show_Workgroup))
		IniWrite($INI, "Preferences", "ShowWorkGroupComputersIP", _GETSTATE($PREFS_Show_IP))
		IniWrite($INI, "Preferences", "UseCustomList", _GETSTATE($PREFS_Import))
		IniWrite($INI, "Preferences", "MakeLastUsedItemDefault", _GETSTATE($PREFS_Make_Default))
;~ 		IniWrite($INI, "Preferences", "AutoCompleteWhileWriting", _GETSTATE($PREFS_Auto_Complete))
;~ 		MsgBox (1,"Button values",'animate:'&_GETSTATE($PREFS_Animate_me)&'Slider:'&GUICtrlRead($PREFS_Trans)&'tm:'&_GETSTATE($PREFS_Show_Topmost)&'WG:'&_GETSTATE($PREFS_Show_Workgroup)&'IP:'&_GETSTATE($PREFS_Show_IP)&'AC:'&_GETSTATE($PREFS_Auto_Complete)&'Imp'&_GETSTATE($PREFS_Import))
	EndIf
	Sleep(20)
	GUICtrlSetData($Path, '')
	_Read_INI();Read INI
	_Apply_Prefs();Apply the preferences
	_Standard_List();Reset the list
	WinSetOnTop($parrent, "", _GETSTATE($PREFS_Show_Topmost));Set topmost attribute
EndFunc   ;==>_UPDATEPREFS

Func _NetServerEnum($iSrvType = -1, $sDomain = '') ;Credd to Amel27?
	Local $uBufPtr = DllStructCreate("ptr;int;int"), $res[1] = [0], $i
	Local $uRecord = DllStructCreate("dword;ptr"), $iRecLen = DllStructGetSize($uRecord)
	Local $uString = DllStructCreate("char[16]")
	Local $uDomain = DllStructCreate("byte[32]"), $pDomain = 0
	If Not ($sDomain = '' Or $sDomain = '*') Then
		DllStructSetData($uDomain, 1, StringToBinary($sDomain, 2))
		$pDomain = DllStructGetPtr($uDomain)
	EndIf
	Local $ret = DllCall("netapi32.dll", "int", "NetServerEnum", _
			"ptr", 0, "int", 100, _
			"ptr", DllStructGetPtr($uBufPtr, 1), "int", -1, _
			"ptr", DllStructGetPtr($uBufPtr, 2), _
			"ptr", DllStructGetPtr($uBufPtr, 3), _
			"int", $iSrvType, "ptr", $pDomain, "int", 0)
	If $ret[0] Then Return SetError(1, $ret[0], '')
	Local $res[DllStructGetData($uBufPtr, 3) + 1] = [DllStructGetData($uBufPtr, 3)]
	For $i = 1 To DllStructGetData($uBufPtr, 3)
		Local $uRecord = DllStructCreate("dword;ptr", DllStructGetData($uBufPtr, 1) + ($i - 1) * $iRecLen)
		Local $sNBName = DllStructCreate("byte[32]", DllStructGetData($uRecord, 2))
		DllStructSetData($uString, 1, BinaryToString(DllStructGetData($sNBName, 1), 2))
		$res[$i] = DllStructGetData($uString, 1)
	Next
	$ret = DllCall("netapi32.dll", "int", "NetApiBufferFree", "ptr", DllStructGetData($uBufPtr, 1))
	Return $res
EndFunc   ;==>_NetServerEnum

Func _Get_Computers() ;Add computer list to combo
	_GUICtrlComboBoxEx_ShowDropDown($Path, False) ;close combo
	$HiddenMSG = "Searching LAN, Please wait"
	$aCompList = _NetServerEnum($SV_TYPE_WORKSTATION) ;Run function to gather computernames
	If IsArray($aCompList) = 1 Then ;If the function "_NetServerEnum($SV_TYPE_WORKSTATION)" Suceceded
		GUICtrlSetData($Path, '\\' & _ArrayToString($aCompList, "|\\", 1)) ;Set the data in combo, prefix every line with \\
	Else ;if it failed... say so
		GUICtrlSetData($Path, "Function Failed...")
		Dim $aCompList[1]
		$aCompList[0] = 0
	EndIf

	Dim $aCompList[1]
	$aCompList[0] = 0

	If $aCompList[0] > 0 Then $aCompList[0] = "None"
	If $aCompList[0] = 1 Then
		$Plural = "Computer"
	Else
		$Plural = "Computers"

	EndIf
	$HiddenMSG = "Done! " & $aCompList[0] & ' ' & $Plural & " Found"
	_GUICtrlComboBoxEx_ShowDropDown($Path, True)
	Sleep(500)
EndFunc   ;==>_Get_Computers



Func _Fade_OUT($FADE_GUI, $FADE_FROM, $FADE_TO, $FADE_SPEED, $FADE_SPEED2)
	For $FADE_AMOUNT = $FADE_FROM To $FADE_TO Step -$FADE_SPEED
		Sleep($FADE_SPEED2)
		WinSetTrans($FADE_GUI, "", $FADE_AMOUNT)
	Next
EndFunc   ;==>_Fade_OUT



Func _Execute_Proc($sCmd, $sArgs = "", $sFolder = @MyDocumentsDir, $sVerb = "", $vState = @SW_SHOWNORMAL) ; Credd to MrCreatoR
	Local $sCmdPid = Run($sCmd, $sFolder, $vState)
	Local $iRun_Error = @error

	If Not $iRun_Error Then Return SetError(0, 0, 1)

	If StringRight($sCmd, 3) = "lnk" Then
		Local $aShortcutInfo = FileGetShortcut($sCmd)
		If IsArray($aShortcutInfo) Then $sCmd = $aShortcutInfo[0]
	EndIf

	ShellExecute($sCmd, $sArgs, $sFolder, $sVerb, $vState)
	Return SetError(@error)

EndFunc   ;==>_Execute_Proc



Func _FadeDistance($Sensitivity)
	$Sensitivity = 2
;~ 	$RunBox = GUICreate($Title, 345, 155, 515, 285
	$Cursor_Position = GUIGetCursorInfo($RunBox)
	$Cursor_Distance = (Abs($Cursor_Position[0] - (165)) + Abs($Cursor_Position[1] - (75))) / (10 / $Sensitivity)
	If $Cursor_Distance < 255 Then
		WinSetTrans($RunBox, "", 255 - $Cursor_Distance)
	Else
		WinSetTrans($RunBox, "", 0)
	EndIf
EndFunc   ;==>_FadeDistance

#EndRegion FUNCTIONS

Func _Create_INI($INI)
	If FileExists($INI) = 0 Then
		IniWrite($INI, "Preferences", "UseAnimations", 1)
		IniWrite($INI, "Preferences", "Transparancy", $Start_TRANS)
		IniWrite($INI, "Preferences", "AlwaysOnTop", 1)
		IniWrite($INI, "Preferences", "ShowWorkGroupComputers", 0)
		IniWrite($INI, "Preferences", "ShowWorkGroupComputersIP", 0)
;~ 		IniWrite($INI, "Preferences", "AutoCompleteWhileWriting", 1)
		IniWrite($INI, "Preferences", "UseCustomList", 1)
		IniWrite($INI, "Preferences", "MakeLastUsedItemDefault", 1)
		IniWrite($INI, "CustomList", 1, 'Paint')
		IniWrite($INI, "CustomList", 1 & 'Path', 'MSPaint.exe')
		IniWrite($INI, "CustomList", 1 & 'Dir', '')


		For $x = 2 To $INI_CUST_ITEMS
			IniWrite($INI, "CustomList", $x, '')
			IniWrite($INI, "CustomList", $x & 'Path', '')
			IniWrite($INI, "CustomList", $x & 'Dir', '')
		Next
	EndIf
EndFunc   ;==>_Create_INI

#Region CHILDGUI FUNCTIONS ;Credd to Sandin

Func _show_child_window($button_handle, $Speed)
	If WinExists($ChildGui) Then
		_slide_out($ChildGui, $Speed / 2) ;2x faster if switching between button pop-ups
	EndIf
	_slide_in($parrent, $ChildGui, $Speed, $button_handle, True)
EndFunc   ;==>_show_child_window

Func _slide_in($SI_Gui, $hwGui, $Speed, $hwCtrl, $HideParrent)
	Local $position = ControlGetPos($SI_Gui, "", $hwCtrl)
	Local $position2 = WinGetPos($SI_Gui)
	Local $position2b = WinGetClientSize($SI_Gui)
	Local $position3 = WinGetPos($hwGui)
	Local $light_border = ($position2[2] - $position2b[0]) / 2
	Local $thick_border = ($position2[3] - $position2b[1]) - $light_border

	WinMove($hwGui, "", $position2[0] + $position[0] + $light_border, $position2[1] + $position[1] + $position[3] + $thick_border - 4, $position[2]);set the window exacly below button
	DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwGui, "int", $Speed, "long", 0x00040004);0x00040004
	_WinAPI_RedrawWindow($hwGui)
	GUISetState(@SW_SHOW, $hwGui)

	If $HideParrent = True Then
		WinMove($child2, "", $position2[0] + $light_border, $position2[1] + $thick_border, $position2b[0], $position2b[1])
		WinSetTrans($child2, "", 0)
		GUISetState(@SW_DISABLE, $child2)
		GUISetState(@SW_SHOWNOACTIVATE, $child2)
		For $i = 1 To 100 Step 2 ;showing "lock window" in smooth transparency
			WinSetTrans($child2, "", $i)
			Sleep(1)
		Next
	EndIf
EndFunc   ;==>_slide_in



Func _slide_out($hwGui, $Speed)
	If WinExists($child2) Then
		For $i = 100 To 1 Step -5
			WinSetTrans($child2, "", $i)
			Sleep(1)
		Next
		GUISetState(@SW_HIDE, $child2)
	EndIf
	DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwGui, "int", $Speed, "long", 0x00050008);0x00050008
	GUISetState(@SW_HIDE, $hwGui)
EndFunc   ;==>_slide_out





#EndRegion CHILDGUI FUNCTIONS 



Func _TEST($Data, $Data2 = "", $data3 = "", $data4 = "", $data5 = "")
	MsgBox(4096, "TEST", $Data & @CRLF & $Data2 & @CRLF & $data3 & @CRLF & $data4 & @CRLF & $data5)
EndFunc   ;==>_TEST

Func _UPDATEIP()
	$ipremote = _GetIP()
EndFunc   ;==>_UPDATEIP

Func _IPRENEW()
	ProgressOn($Title & "     IP Renewal", "Renewing your IP")
	ProgressSet(20, "Renewing your IP", "ipconfig /release")
	_RunDOS("ipconfig /release")
	ProgressSet(50, "Renewing your IP", "ipconfig /release")
	_RunDOS("ipconfig /renew")
	ProgressOff()
	_GUICtrlComboBoxEx_SetEditText($Path, 'IP')


EndFunc   ;==>_IPRENEW

Func HELP()
;~ 	MsgBox(262144 + 0, $Title & "     Help", "Here i will post some help later on when i have time to make documentation")
	MsgBox(262144, "Help & Commands", "You can use the following commands:" & @CRLF & _
			"IP - Shows your IP-address" & @CRLF & _
			"IP2 - Shows IP for a second network adapter" & @CRLF & _
			"IP3 - Shows IP for a third network adapter" & @CRLF & _
			"IP4 - Shows IP for a fourth network adapter" & @CRLF & _
			"IPE - Shows your outgoing (external) IP-address" & @CRLF & _
			"IPR - Renews your ip (good if you have an IP conflict or other network issues)" & @CRLF & _
			"Name - Shows your computername" & @CRLF & _
			"calc: - Make calculations, you can use some included functions such as:" & @CRLF & _
			@TAB & "- The normal operators +,-,*,/ and ^" & @CRLF & _
			@TAB & "- sqrt(#)- Takes the squereroot of a number" & @CRLF & _
			@TAB & "- Sin(#)& aSin(#) - Sine and ArcSine" & @CRLF & _
			@TAB & "- Cos(#)& aCos(#) - Cosine and ArcCosine" & @CRLF & _
			@TAB & "- Tan(#)& aTan(#) - Tangent and ArcTangent" & @CRLF & _
			@TAB & "- PI - 3.14159265358979" & @CRLF & _
			@TAB & "- NA - Avogadros constant - 6.022142*10^23" & @CRLF & _
			@TAB & "- u - Unified atomic mass unit - 1.660539*10^-27" & @CRLF & @CRLF & _
			"Google: - Google a string" & @CRLF & _
			"CMD: - Run a command in a command prompt" & @CRLF & _
			"Web: - Use google's i'm feeling lucky function" & @CRLF & @CRLF & _
			"Do you want to run a command without exiting " & $Title & "? Just press Ctrl when clicking OK/pressing Enter." & @CRLF & _
			"You can drag the window by grabbig the text above the inputbox")
EndFunc   ;==>HELP

Func _StringUseVars($SUV_Start, $SUV_Amount = "", $SUV_ARRAY = "NONE")

	If $SUV_ARRAY <> "NONE" And IsArray($SUV_ARRAY) = 1 Then

		$SUV_MAINSTRING = $SUV_Start

		For $SUV_C = 0 To $SUV_Amount - 1 Step 1

			$SUV_C_T = $SUV_ARRAY[$SUV_C][0]
			$SUV_C_R = $SUV_ARRAY[$SUV_C][1]

			$SUV_MAINSTRING = StringReplace($SUV_MAINSTRING, $SUV_C_T, '' & $SUV_C_R & '')
		Next
		$SUV_RETURN = Execute($SUV_MAINSTRING)
		Dim $RETURN[2]
		$RETURN[0] = $SUV_MAINSTRING
		$RETURN[1] = $SUV_RETURN
		Return $RETURN

	EndIf
EndFunc   ;==>_StringUseVars

Func _OPEN_EDITOR()

	ShellExecute($Editor_Path)
	_slide_out($ChildGui, $slide_speed)
	F_EXIT(2)

EndFunc   ;==>_OPEN_EDITOR

Func _Standard_List()
	If $INI_LEID = 1 Then GUICtrlSetData($Path, IniRead($INI, "Preferences", "LastExecutedItem", ""), IniRead($INI, "Preferences", "LastExecutedItem", ""))
	GUICtrlSetData($Path, "--Programs:")
	GUICtrlSetData($Path, "          " & "CMD")
	GUICtrlSetData($Path, "          " & "MSConfig")
	GUICtrlSetData($Path, "          " & "Regedit")
	GUICtrlSetData($Path, "--Dirs:")
	GUICtrlSetData($Path, "          " & "%WINDIR%")
	GUICtrlSetData($Path, "          " & "%TEMP%")
	If @OSVersion <> 'WIN_VISTA' Then
		GUICtrlSetData($Path, "          " & "My Documents")
		GUICtrlSetData($Path, "          " & "My Computer")
		GUICtrlSetData($Path, "          " & "Control Panel")
		GUICtrlSetData($Path, "          " & "My Network places")
	EndIf
;~ MsgBox(0,"",$INI_UYCL)
	If $INI_UYCL = 1 Then
		GUICtrlSetData($Path, "--Custom")
		For $x = 1 To $INI_CUST_ITEMS Step 1
			If $INI_CUST[$x] <> '' Then
				$CUST_LIST_SET &= '          ' & $INI_CUST[$x] & '|'
			EndIf
		Next
		GUICtrlSetData($Path, $CUST_LIST_SET)
	EndIf
	GUICtrlSetData($Path, "--Workgroup(" & $WorkGroup & ") computers:" & _ArrayToString($aCompList, "|\\", 1))

EndFunc   ;==>_Standard_List

Func _Process_List()
	$StringExpl = "Process name|" & _
			"Process ID (PID)|" & _
			"number of read operations performed|" & _
			"number of write operations performed|" & _
			"number of I/O operations performed, other than read and write operations|" & _
			"number of bytes read|" & _
			"number of bytes write|" & _
			"number of bytes transferred during operations other than read and write operations"
	$Stringarray = StringSplit($StringExpl, '|')
	$plist = ProcessList()
	Dim $Nlist[$plist[0][0] + 1][2 + 6]
	For $liststep3 = 1 To UBound($Stringarray) - 1
		$Nlist[0][$liststep3 - 1] = $Stringarray[$liststep3]
	Next
	For $liststep = 1 To $plist[0][0]
		$plistEX = ProcessGetStats($plist[$liststep][0], 1)
		For $liststep1 = 0 To UBound($plist, 2) - 1
			$Nlist[$liststep][$liststep1] = $plist[$liststep][$liststep1]
		Next
		For $liststep2 = 0 To UBound($plistEX, 1) - 1
			If IsArray($plistEX) = 1 Then $Nlist[$liststep][$liststep2 + UBound($plist, 2)] = $plistEX[$liststep2]
		Next
	Next
	_ArraySort($Nlist, 0, 1)
	_ArrayDisplay($Nlist)
EndFunc   ;==>_Process_List

Func _AutoComplete()
	_GUICtrlComboBox_AutoComplete($Path)
EndFunc   ;==>_AutoComplete

Func OnAutoItExit()
	TCPShutdown()
EndFunc   ;==>OnAutoItExit