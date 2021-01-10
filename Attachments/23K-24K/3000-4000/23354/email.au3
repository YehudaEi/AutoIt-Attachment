;=================================================================================
;Created By:
; billthecreator
; Bill Reithmeyer
;Moth Email v2.0.0.30
;=================================================================================
;Includes
;=================================================================================
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <GuiStatusBar.au3>
#include <GUIComboBox.au3>
#include <GuiToolBar.au3>
#include <GUIListBox.au3>
#include <GuiEdit.au3>
#include <GuiMenu.au3>
#include <String.au3>
#include <File.au3>
#include <Misc.au3>
#NoTrayIcon
;=================================================================================
;Globals
;=================================================================================
Global Const $sEmailer_Dir = @AppDataDir & "\Moth Email"
Global Const $SMTPSettings = $sEmailer_Dir & "\EmailSettings.ini"
Global Const $Draft = $sEmailer_Dir & "\Draft.ini"
Global Const $THEME = $sEmailer_Dir & "\Theme.ini"
Global Const $MthAbt= $sEmailer_Dir & "\AboutPic.bmp"
Global Const $Icon  = $sEmailer_Dir & "\Icon.ico"
Global Const $s_Version = 'v. 2.0.0.30' & ' (20081203)'
Global $s_AttachFiles = "", $a_AttachFiles[1], $f_size = 0
Global $Body_Color = 0x000000
Global $oMyRet[2]
Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
$Begin = TimerInit()
$time = 10 ;Wait one hundreth of a second to determine if online
$Change = False
$SW_SHOWHIDE = @SW_HIDE
$BackGroundQ = False

If Not FileExists($sEmailer_Dir) Then 
#Region ### START Koda GUI section ### Form=
$Download	= GUICreate("Downloading", 354, 106, -1, -1, 0, 0)
$Progress0 	= GUICtrlCreateProgress(8, 40, 334, 17)
			  GUICtrlCreateLabel("Retrieving information...", 8, 8, 115, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
DirCreate($sEmailer_Dir)
While 1
	InetGet("                                              ", $MthAbt)
		GUICtrlSetData($Progress0, (1/6)*100)
	InetGet("                                          ", $Icon)
		GUICtrlSetData($Progress0, (2/6)*100)
	InetGet("                                           ", $THEME)
		GUICtrlSetData($Progress0, (3/6)*100)
	InetGet("                                           ", $Draft)
		GUICtrlSetData($Progress0, (4/6)*100)
	InetGet("                                                   ", $SMTPSettings)
		GUICtrlSetData($Progress0, (5/6)*100)
	InetGet("                                              ", $sEmailer_Dir & "\settings.bmp")
		GUICtrlSetData($Progress0, (6/6)*100)
	GUIDelete($Download)
	$SW_SHOWHIDE = @SW_SHOW
	ExitLoop
WEnd
EndIf

If Not FileExists($MthAbt) Then
	InetGet("                                              ", $MthAbt)
ElseIf Not FileExists($Icon) Then
	InetGet("                                          ", $Icon)
ElseIf Not FileExists($THEME) Then
	InetGet("                                           ", $THEME)
ElseIf Not FileExists($Draft) Then
	InetGet("                                           ", $Draft)
ElseIf Not FileExists($SMTPSettings) Then
	InetGet("                                                   ", $SMTPSettings)
	$SW_SHOWHIDE = @SW_SHOW
ElseIf Not FileExists($sEmailer_Dir & "\settings.bmp") Then
	InetGet("                                              ", $sEmailer_Dir & "\settings.bmp")
EndIf

;=================================================================================
;Get Theme Settings
;=================================================================================
$GuiTheme		= IniRead($THEME, "Theme Settings", "ThemeSelect", "Theme 1")
$GUIBACKGRND 	= IniRead($THEME, $GuiTheme, "Background", "")
$GUIBKCOLOR 	= IniRead($THEME, $GuiTheme, "BkColor", "")
$GUIFONTCLR 	= IniRead($THEME, $GuiTheme, "FontColor", "")
$GUIBODYCLR 	= IniRead($THEME, $GuiTheme, "BodyColor", "")
$THEME_COUNT 	= IniReadSection($THEME, "Theme Count")
$THEME_BK_COLOR = $GUIBKCOLOR
$THEME_FONT_COLOR = $GUIFONTCLR
$THEME_BC_COLOR = $GUIBODYCLR
;=================================================================================
;Font and Size of Edit
;=================================================================================
$FontFace 		= IniRead($SMTPSettings, "Font", "Face", "Courier New")
$FontSize 		= IniRead($SMTPSettings, "Font", "Size", "9")
;=================================================================================
;Get SMTP Settings If Any
;=================================================================================
$account		= IniRead($SMTPSettings, "Current Account", "Value", "")
$s_SmtpServer 	= IniRead($SMTPSettings, $account, "SMTP", "")
$s_FromName 	= IniRead($SMTPSettings, $account, "Name", "")
$s_FromAddress 	= IniRead($SMTPSettings, $account, "Address", "")
$s_Username 	= IniRead($SMTPSettings, $account, "Username", "")
$s_Password 	= IniRead($SMTPSettings, $account, "Password", "")
$IPPort 		= IniRead($SMTPSettings, $account, "IPPort", "")
$ssl 			= IniRead($SMTPSettings, $account, "SSL", "")
$account_list 	= IniReadSection($SMTPSettings, "List")
$s_Password 	= _StringEncrypt(0, $s_Password, 1001101, 2)

$ContactVar 	= IniReadSection($SMTPSettings, "Contacts")
;=================================================================================
;Get Draft Email Parts If Any. Does Not Remember Attached Files
;=================================================================================
$Draft_Ask 		= IniRead($Draft, "Draft", "Ask", "")
$Draft_To 		= IniRead($Draft, "Draft", "To", "")
$Draft_CC 		= IniRead($Draft, "Draft", "CC", "")
$Draft_BCC 		= IniRead($Draft, "Draft", "BCC", "")
$Draft_SJ 		= IniRead($Draft, "Draft", "Subject", "")
$Draft_Body 	= IniRead($Draft, "Draft", "Body", "")
;=================================================================================
;Gui [5] = [Main,Settings,Contacts,Theme,About]
;=================================================================================
#Region ### START Koda GUI section ### Form1=Main Gui
$Title 					= "Moth Email  Compose: "
$Form1 					= GUICreate($Title, 626, 455, -1, -1)

If $GUIBKCOLOR <> "" Then
	  GUISetBkColor($GUIBKCOLOR)
Else
	  GuiSetBKToFit($GUIBACKGRND)
EndIf
						  GUISetFont(8, 400, 0, "Arial")
						  GUISetIcon($Icon)
;=================================================================================
;Menu and Items
;=================================================================================
$Menu 					= GUICtrlCreateMenu("&File")
$MenuAttach 			= GUICtrlCreateMenuItem("Attach &File(s)...", $Menu)
						  GUICtrlCreateMenuItem("", $Menu)
$MenuNew 				= GUICtrlCreateMenuItem("&New and Discard" & @TAB & "Ctrl+N", $Menu)
$MenuSave 				= GUICtrlCreateMenuItem("Save &Draft" & @TAB & "Ctrl+S", $Menu)
$Drftvw 				= GUICtrlCreateMenuItem("&View Draft", $Menu)
						  GUICtrlCreateMenuItem("", $Menu)
$SendNow 				= GUICtrlCreateMenuItem("&Send Now" & @TAB & "Ctrl+Return", $Menu)
$Preview			 	= GUICtrlCreateMenuItem("&Preview" & @TAB & "F11", $Menu)
						  GUICtrlCreateMenuItem("", $Menu)
$ExitWOSaving			= GUICtrlCreateMenuItem("E&xit Without Saving", $Menu)
$Exit 					= GUICtrlCreateMenuItem("&Exit" & @TAB & "Ctrl+Q", $Menu)

$View 					= GUICtrlCreateMenu("&View")
$StatusBarSwHd 			= GUICtrlCreateMenuItem("Hide &Status Bar", $View)
						  GUICtrlSetState(-1, $GUI_CHECKED)
$FormatBarSwHd 			= GUICtrlCreateMenuItem("Hide &Format Bar", $View)
						  GUICtrlSetState(-1, $GUI_CHECKED)

$Tools 					= GUICtrlCreateMenu("&Tools")
$Settings 				= GUICtrlCreateMenuItem("SMTP &Settings" & @TAB & "Ctrl+P", $Tools)
$AddContact 			= GUICtrlCreateMenuItem("Add &Contact" & @TAB & "Ctrl+Z", $Tools)
						  GUICtrlCreateMenuItem("", $Tools)
$ChooseTheme 			= GUICtrlCreateMenuItem("Choose &Theme..." & @TAB & "Ctrl+T", $Tools)

$Help					= GUICtrlCreateMenu("&Help")
$AboutEmail	 			= GUICtrlCreateMenuItem("&About Moth Email", $Help)

$hMain 					= _GUICtrlMenu_GetMenu ($Form1)
$hBrush 				= _WinAPI_GetSysColorBrush ($COLOR_INFOBK)
For $o = 0 To 3 
	Local $hFile[4]	
	$hFile[$o]			= _GUICtrlMenu_GetItemSubMenu ($hMain, $o)
						  _GUICtrlMenu_SetMenuStyle ($hFile[$o], $MNS_NOCHECK)
						  _GUICtrlMenu_SetMenuBackground ($hFile[$o], $hBrush)
Next
					  
						  GUICtrlCreateLabel("From:", 4, 26, 43, 17, $SS_RIGHT)
						  GUICtrlSetColor(-1, $GUIFONTCLR)
						  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
$NameAddress 			= GUICtrlCreateLabel('"' & $s_FromName & '" <' & $s_FromAddress & '>', 56, 26, 319, 18)
						  GUICtrlSetColor(-1, $GUIFONTCLR)
						  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
$SMTPconItem			= GUICtrlCreatePic($sEmailer_Dir & "\settings.bmp",375,26,18,18)
						  GUICtrlSetTip(-1, "SMTP Settings")
						  GUICtrlSetCursor(-1, 0)
						  GUICtrlCreateLabel("To:", 4, 52, 43, 17, $SS_RIGHT)
						  GUICtrlSetColor(-1, $GUIFONTCLR)
						  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
$ContactCombo 			= GUICtrlCreateCombo("", 56, 49, 337, 22)

For $d = 1 To $ContactVar[0][0]
	_GUICtrlComboBox_AddString($ContactCombo, $ContactVar[$d][1])
Next

$AttachList 			= GUICtrlCreateList("", 399, 48, 217, 74)
						  GUICtrlSetState(-1, $GUI_HIDE)
$FileDelete 			= GUICtrlCreateButton("Delete", 399, 120, 50, 22)
						  GUICtrlSetState(-1, $GUI_HIDE)
$File_sizes 			= GUICtrlCreateLabel(" KB", 450, 120, 166, 22, $SS_RIGHT)
						  GUICtrlSetState(-1, $GUI_HIDE)
						  GUICtrlSetColor(-1, $GUIFONTCLR)
						  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
						  GUICtrlCreateLabel("CC:", 4, 75, 43, 17, $SS_RIGHT)
						  GUICtrlSetColor(-1, $GUIFONTCLR)
						  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
$CC_Input 				= GUICtrlCreateInput("", 56, 72, 337, 22)
						  GUICtrlCreateLabel("BCC:", 4, 98, 43, 17, $SS_RIGHT)
						  GUICtrlSetColor(-1, $GUIFONTCLR)
						  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
$BCC_Input 				= GUICtrlCreateInput("", 56, 96, 337, 22)
						  GUICtrlCreateLabel("Subject:", 4, 156, 43, 17, $SS_RIGHT)
						  GUICtrlSetColor(-1, $GUIFONTCLR)
						  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
$Subject_Input 			= GUICtrlCreateInput("", 56, 152, 337, 21)
$Body_Edit 				= GUICtrlCreateEdit("", 5, 224, 615, 185, BitOR($ES_AUTOVSCROLL, $ES_WANTRETURN, $WS_VSCROLL))
						  GUICtrlSetFont(-1, $FontSize, 400, 0, $FontFace)
						  GUICtrlSetBkColor($Body_Edit, $GUIBODYCLR)
						  GUICtrlSetColor($Body_Edit,  _LightDark($GUIBODYCLR))
						  _GUICtrlEdit_SetMargins($Body_Edit, BitOR($EC_LEFTMARGIN, $EC_RIGHTMARGIN), 5, 5)
						  
$s_Inputs 				= StringSplit($AttachList & "/\" & $CC_Input & "/\" & $BCC_Input & "/\" & $Subject_Input & "/\" & $Body_Edit, "/\")

$Send_Button		 	= GUICtrlCreateButton("Send", 544, 200, 75, 21, 0)
$Italic 				= GUICtrlCreateButton("I", 272, 200, 21, 21)
						  GUICtrlSetTip(-1, "Italic")
						  GUICtrlSetFont(-1, 8, 400, 2)
$Bold 					= GUICtrlCreateButton("B", 293, 200, 21, 21)
						  GUICtrlSetTip(-1, "Bold")
						  GUICtrlSetFont(-1, 8, 800)
$UnderLine 				= GUICtrlCreateButton("U", 314, 200, 21, 21)
						  GUICtrlSetTip(-1, "Underline")
						  GUICtrlSetFont(-1, 8, 400, 4)
$Color 					= GUICtrlCreateButton("", 335, 200, 21, 21, $BS_PUSHBOX)
						  GUICtrlSetTip(-1, "Change Font Color")
						  GUICtrlSetBkColor(-1, 0x000000)
$s_FormatBar			= StringSplit($Italic & "/\" & $Bold & "/\" & $UnderLine & "/\" & $Color, "/\")
$StatusBar1 			= _GUICtrlStatusBar_Create($Form1, -1, "")
						  _GUICtrlStatusBar_SetMinHeight($StatusBar1, 0)
						  Dim $StatusBar1_PartsWidth[6] = [90, 150, 250, 400, 450, -1]
						  _GUICtrlStatusBar_SetParts($StatusBar1, $StatusBar1_PartsWidth)
						  _GUICtrlStatusBar_SetText($StatusBar1, "Not Connected", 0)
						  _GUICtrlStatusBar_SetText($StatusBar1, "", 1)
						  _GUICtrlStatusBar_SetText($StatusBar1, "Text Len: 0", 2)
						  _GUICtrlStatusBar_SetText($StatusBar1, "", 3)
						  _GUICtrlStatusBar_SetText($StatusBar1, "", 4)
						  _GUICtrlStatusBar_SetText($StatusBar1, "", 5)
						  
$FontCombo 				= GUICtrlCreateCombo("", 0,0, -1, -1, $CBS_DROPDOWNLIST)
						  GUICtrlSetData(-1, "Arial|Arial Black|Arial Bold|Arial Bold Italic|Arial Italic|" & _
							"Comic Sans MS|Courier|Courier New|Courier New Bold|Courier New Bold Italic|" & _
							"Courier New Italic|Georgia|Georgia Bold|Georgia Bold Italic|Georgia Italic|Lucida Console|" & _
							"MS Sans Serif|MS Serif|Tahoma|Times New Roman|Times New Roman Bold|Times New Roman Bold Italic|" & _
							"Times New Roman Italic|Verdana|Verdana Bold|Verdana Bold Italic|Verdana Italic", $FontFace)
$SizeCombo 				= GUICtrlCreateCombo("", 0, 0, -1, -1, $CBS_DROPDOWNLIST)
						  GUICtrlSetData(-1, "8|9|12|16|20|24|28|32|36", $FontSize)
$progress 				= GUICtrlCreateProgress(0, 0, -1, -1)
$hProgress 				= GUICtrlGetHandle($progress)
$hCombo 				= GUICtrlGetHandle($SizeCombo)
$hCombo1 				= GUICtrlGetHandle($FontCombo)
						  _GUICtrlStatusBar_EmbedControl($StatusBar1, 5, $hProgress)
						  _GUICtrlStatusBar_EmbedControl($StatusBar1, 3, $hCombo1)
						  _GUICtrlStatusBar_EmbedControl($StatusBar1, 4, $hCombo)
If IniRead($Draft, "Draft", "Ask", "") = "True" Then
	$DraftNotify = MsgBox(51, "", "You have a saved draft, do you want to view it now?" & @CRLF & @CRLF & "Press 'Cancel' to delete it.")
	If $DraftNotify = 6 Then
		_GUICtrlComboBox_SelectString($ContactCombo, $Draft_To)
		GUICtrlSetData($CC_Input, $Draft_CC)
		GUICtrlSetData($BCC_Input, $Draft_BCC)
		GUICtrlSetData($Subject_Input, $Draft_SJ)
		GUICtrlSetData($Body_Edit, $Draft_Body)
		GUICtrlSetState($Drftvw, $GUI_DISABLE)
	ElseIf $DraftNotify = 2 Then
		IniWrite($Draft, "Draft", "Ask", "False")
		IniWrite($Draft, "Draft", "To", "")
		IniWrite($Draft, "Draft", "CC", "")
		IniWrite($Draft, "Draft", "BCC", "")
		IniWrite($Draft, "Draft", "Subject", "")
		IniWrite($Draft, "Draft", "Body", "")
		GUICtrlSetState($Drftvw, $GUI_DISABLE)
	Else
		IniWrite($Draft, "Draft", "Ask", "False")
		GUICtrlSetState($Drftvw, $GUI_ENABLE)
	EndIf
Else
	_GUICtrlComboBox_SelectString($ContactCombo, $Draft_To)
	GUICtrlSetData($CC_Input, $Draft_CC)
	GUICtrlSetData($BCC_Input, $Draft_BCC)
	GUICtrlSetData($Subject_Input, $Draft_SJ)
	GUICtrlSetData($Body_Edit, $Draft_Body)
	GUICtrlSetState($Drftvw, $GUI_DISABLE)
EndIf
GUISetState(@SW_SHOW)
#EndRegion ### START Koda GUI section ### Form1=Main Gui
;
#Region ### START Koda GUI section ### Form2=Settings
$Form2 					= GUICreate("SMTP Settings", 358, 295 - 26, -1, -1, 0, 0, $Form1)
						  GUISetFont(8, 400, 0, "Arial")
						  GUISetBkColor(0xBFCDDB, $Form2)
						  GUICtrlCreateLabel("Your Name:", 16, 34 - 26, 61, 18)
						  GUICtrlCreateLabel("Email Adress:", 16, 58 - 26, 70, 18)
						  GUICtrlCreateLabel("Outgoing Server (SMTP):", 16, 106 - 26, 124, 18)
						  GUICtrlCreateLabel("Port:", 16, 130 - 26, 26, 18)
						  GUICtrlCreateLabel("SSL:", 16, 154 - 26, 27, 18)
						  GUICtrlCreateLabel("Username:", 16, 178 - 26, 56, 18)
						  GUICtrlCreateLabel("Password:", 16, 202 - 26, 57, 18)
$SETTING_NAME 			= GUICtrlCreateInput($s_FromName, 144, 32 - 26, 193, 22)
$SETTING_EMAIL 			= GUICtrlCreateEdit($s_FromAddress, 144, 56 - 26, 193, 22, 0)
$SETTING_SSL 			= GUICtrlCreateCheckbox("Enable/Disable", 144, 152 - 26, 193, 22)

If $ssl = 1 Then
	GUICtrlSetState($SETTING_SSL, $GUI_CHECKED)
Else
	GUICtrlSetState($SETTING_SSL, $GUI_UNCHECKED)
EndIf

$SETTING_UserName 		= GUICtrlCreateInput($s_Username, 144, 176 - 26, 193, 22)
$SETTING_Password 		= GUICtrlCreateInput($s_Password, 144, 200 - 26, 193, 22, $ES_PASSWORD)
$SETTING_Confirm 		= GUICtrlCreateButton("Save", 264, 240 - 26, 75, 25, 0)
$SETTING_Cancel 		= GUICtrlCreateButton("Cancel", 184, 240 - 26, 75, 25, 0)
$SMTP_ACCOUNT			= GUICtrlCreateCombo($account_list[1][0], 8, 216, 145, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
$Setting_delete			= GUICtrlCreateButton("X", 155, 216, 25, 21, 0)
$SETTING_SMTP 					= GUICtrlCreateEdit($s_SmtpServer, 144, 104 - 26, 193, 22, 0)
$SETTING_PORT 					= GUICtrlCreateInput($IPPort, 144, 128 - 26, 193, 22, $ES_NUMBER)

If $account_list[0][0] > 1 Then
	For $t = 2 To $account_list[0][0]-1
		_GUICtrlComboBox_AddString($SMTP_ACCOUNT, $account_list[$t][0])
	Next
GUICtrlSetData($SMTP_ACCOUNT, $account_list[$account_list[0][0]][0], $account)
EndIf
GUISetState($SW_SHOWHIDE)
#EndRegion ### START Koda GUI section ### Form2=Settings
;
#Region ### START Koda GUI section ### Form3=Add Contact
$Form3 					= GUICreate("Add Contact", 242, 190, -1, -1, 0, 0, $Form1)
						  GUISetBkColor($GUIBKCOLOR)
						  GUISetFont(8, 400, 0, "Arial")
						  GUICtrlCreateLabel("Contact Name:", 8, 16, 200, 18)
						  GUICtrlSetColor(-1, $GUIFONTCLR)
$AddName 				= GUICtrlCreateEdit("", 8, 40, 217, 22, 0)
$AddEmail 				= GUICtrlCreateEdit("", 8, 96, 217, 22, 0)
						  GUICtrlCreateLabel("Contact's Email Address:", 8, 72, 200, 18)
						  GUICtrlSetColor(-1, $GUIFONTCLR)
$CONTACT_CONFIRM 		= GUICtrlCreateButton("Ok", 152, 128, 75, 25)
$CONTACT_CANCEL 		= GUICtrlCreateButton("Cancel", 70, 128, 75, 25)
						  GUICtrlSetState(-1, $GUI_FOCUS)
						  
GUISetState(@SW_HIDE)
#EndRegion ### START Koda GUI section ### Form3=Add Contact
;
#Region ### START Koda GUI section ### Form4=Theme
$Form4 					= GUICreate("Theme", 177, 315, -1, -1, 0, 0, $Form1)
						  GUISetFont(8, 400, 0, "Arial")
$THEME_COMBO 			= GUICtrlCreateCombo($THEME_COUNT[1][0], 8, 8, 154, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))

For $t = 2 To $THEME_COUNT[0][0]
	_GUICtrlComboBox_AddString($THEME_COMBO, $THEME_COUNT[$t][0])
Next


$EXPBK 					= IniRead($THEME, GUICtrlRead($THEME_COMBO), "BkColor", "")
$EXPBG 					= IniRead($THEME, GUICtrlRead($THEME_COMBO), "Background", "")
$EXPFC 					= IniRead($THEME, GUICtrlRead($THEME_COMBO), "FontColor", "")
$EXPBC 					= IniRead($THEME, GUICtrlRead($THEME_COMBO), "BodyColor", "")

$THEME_CB 				= GUICtrlCreateCheckbox("Custom Theme", 24, 40, 94, 17)
$THEME_BC 				= GUICtrlCreateLabel("Background Color:", 24, 72, 93, 18)
$THEME_BK 				= GUICtrlCreateLabel("Background:", 24, 89, 88, 18)
$THEME_TC 				= GUICtrlCreateLabel("Text Color:", 24, 88 + 18, 88, 18)
$THEME_DC 				= GUICtrlCreateLabel("Body Color:", 24, 104 + 18, 88, 18)
$BK_COLOR 				= GUICtrlCreateButton("", 128, 72, 19, 17, $BS_PUSHBOX)
						  GUICtrlSetBkColor(-1, $EXPBK)
						  GUICtrlSetCursor(-1, 0)
$BACKGROUND 			= GUICtrlCreateButton("Browse", 100, 89, 49, 17, $BS_PUSHBOX)
						  GUICtrlSetBkColor(-1, 0xFFFFFF)
						  GUICtrlSetCursor(-1, 0)
$FONT_COLOR 			= GUICtrlCreateButton("", 128, 88 + 18, 19, 17, $BS_PUSHBOX)
						  GUICtrlSetBkColor(-1, $EXPFC)
						  GUICtrlSetCursor(-1, 0)
$BOD_COLOR 				= GUICtrlCreateButton("", 128, 104 + 18, 19, 17, $BS_PUSHBOX)
						  GUICtrlSetBkColor(-1, $EXPBC)
						  GUICtrlSetCursor(-1, 0)
$THEME_EXAMPLE 			= GUICtrlCreateLabel(' From:       ' & '"' & StringTrimRight($s_FromName,StringLen($s_FromName)-9) & '...', 24, 128 + 18, 124, 18)
						  GUICtrlSetColor(-1, $EXPFC)
						  GUICtrlSetBkColor(-1, $EXPBK)
$THEME_EXAMPLE2			= GUICtrlCreateEdit("Body", 24, 147 + 18, 124, 18,0)
						  GUICtrlSetColor(-1, _LightDark($EXPBC))
						  GUICtrlSetBkColor(-1, $EXPBC)
$BACKG_INPUT			= GUICtrlCreateInput($EXPBG, 8, 209, 154, 20)
						  GUICtrlSetState(-1, $GUI_DISABLE)
$bb						= GUICtrlCreateLabel("Background", 8, 190, 88, 18)
$BACKG_DELT 			= GUICtrlCreateButton("Delete", 119, 168 + 18, 43, 20)
$THEME_SAVE 			= GUICtrlCreateButton("Save", 8, 235, 75, 25)
$THEME_CANC 			= GUICtrlCreateButton("Cancel", 88, 235, 75, 25)
$THEME_DELT 			= GUICtrlCreateButton("Delete", 119, 32, 43, 20)
						  GUICtrlCreateLabel("Changing theme will result in an automatic restart.", 8, 261, 154, 30)
$a_DisableGroup 		= StringSplit($THEME_BC & "." & _
							$THEME_BK & "." & _
							$THEME_TC & "." & _
							$THEME_DC & "." & _
							$BK_COLOR & "." & _
							$bb & "." & _
							$BACKGROUND & "." & _
							$BACKG_DELT & "." & _
							$BOD_COLOR & "." & _
							$FONT_COLOR, ".")
						  _GuiCtrlGroupSetState($a_DisableGroup, $GUI_DISABLE)
						  
GUISetState(@SW_HIDE)
#EndRegion ### START Koda GUI section ### Form4=Theme
;
#Region ### START Koda GUI section ### Form5=About
$Form5 					= GUICreate("About Moth Email", 372, 270, -1, -1, 0, 0, $Form1)
						  GUISetFont(8, 400, 0, "Arial")
						  GUISetBkColor(0xFFFFFF, $Form5)
						  GUICtrlCreateLabel($s_Version, 8, 187, 201, 17)
						  GUICtrlSetColor(-1, _LightDark(0xFFFFFF))
$mailto					= GUICtrlCreateLabel("billreithmeyer@gmail.com", 8, 212, 129, 17)
					      GUICtrlSetFont(-1, 8, 400, 4, "Arial")
						  GUICtrlSetColor(-1, _LightDark(0xFFFFFF))
						  GUICtrlSetCursor(-1, 0)
$about_exit				= GUICtrlCreateButton("Close", 280, 212, 75, 25)
$Pic1 					= GUICtrlCreatePic($MthAbt, 0, 0, 372, 170, BitOR($SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS))

GUISetState(@SW_HIDE)
#EndRegion ### END Koda GUI section ###
;
GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
WinActivate("Moth Email")
;=================================================================================
;Script
;=================================================================================
While 1
	;==========================================
	;Set Title To Subject
	$Subject = GUICtrlRead($Subject_Input)
		If $Subject = "" Then
			$Subject = "Moth Email  Compose: (no subject)"
		Else
			$Subject = "Moth Email  Compose: " & $Subject
		EndIf
	If $Change Then
		WinSetTitle($Title, "", $Subject & "*")
	Else
		WinSetTitle($Title, "", $Subject)
	EndIf
	$Title = $Subject
	If WinActive($Title) Then
		HotKeySet("^q", "_Quit")
		HotKeySet("^s", "_Save")
		HotKeySet("^n", "_New")
		HotKeySet("^p", "_Show_SMTP")
		HotKeySet("^z", "_Show_Contact")
		HotKeySet("^t", "_Show_Theme")
	Else
		HotKeySet("^q")
		HotKeySet("^s")
		HotKeySet("^n")
		HotKeySet("^p")
		HotKeySet("^z")
		HotKeySet("^t")
	EndIf
	;==========================================
	If GUICtrlRead($SETTING_SSL) = $GUI_CHECKED Then
		$ssl = 1
	Else
		$ssl = 0
	EndIf
	If $Change Then
		If _Timer_GetIdleTime() > 30000 Then 
			_Save()
		EndIf
	EndIf
	If TimerDiff($Begin) > $time Then
		If Ping("www.AutoItScript.com") = 0 Then
			_GUICtrlStatusBar_SetText($StatusBar1, "Not Connected", 0)
			GUICtrlSetState($SendNow, $GUI_DISABLE)
			GUICtrlSetState($Send_Button, $GUI_DISABLE)
		Else
			_GUICtrlStatusBar_SetText($StatusBar1, "Connected", 0)
			If GUICtrlRead($Body_Edit) = "" Then
				GUICtrlSetState($Send_Button, $GUI_DISABLE)
				GUICtrlSetState($SendNow, $GUI_DISABLE)
				GUICtrlSetState($Preview, $GUI_DISABLE)
			Else
				GUICtrlSetState($Send_Button, $GUI_ENABLE)
				GUICtrlSetState($SendNow, $GUI_ENABLE)
				GUICtrlSetState($Preview, $GUI_ENABLE)
			EndIf
		EndIf
		_GUICtrlStatusBar_SetText($StatusBar1, _MilitaryTo12Hour(@HOUR, @MIN), 1)
		$Begin = TimerInit()
		$time = 1000 ;1 second checks
	EndIf
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $AboutEmail
			GUISetState(@SW_DISABLE, $Form1)
			GUISetState(@SW_SHOW, $Form5)
		Case $mailto
			ShellExecute("mailto:billreithmeyer@gmail.com")
		Case $about_exit
			GUISetState(@SW_ENABLE, $Form1)
			GUISetState(@SW_HIDE, $Form5)			
		Case $GUI_EVENT_CLOSE, $Exit
			_Quit()
		Case $UnderLine
			$Sel = _GUICtrlEdit_GetSel($Body_Edit)
			_GUICtrlEdit_SetSel($Body_Edit, $Sel[1], $Sel[1])
			_GUICtrlEdit_ReplaceSel($Body_Edit, "[/u]")
			_GUICtrlEdit_SetSel($Body_Edit, $Sel[0], $Sel[0])
			_GUICtrlEdit_ReplaceSel($Body_Edit, "[u]")
		Case $Bold
			$Sel = _GUICtrlEdit_GetSel($Body_Edit)
			_GUICtrlEdit_SetSel($Body_Edit, $Sel[1], $Sel[1])
			_GUICtrlEdit_ReplaceSel($Body_Edit, "[/b]")
			_GUICtrlEdit_SetSel($Body_Edit, $Sel[0], $Sel[0])
			_GUICtrlEdit_ReplaceSel($Body_Edit, "[b]")
		Case $Italic
			$Sel = _GUICtrlEdit_GetSel($Body_Edit)
			_GUICtrlEdit_SetSel($Body_Edit, $Sel[1], $Sel[1])
			_GUICtrlEdit_ReplaceSel($Body_Edit, "[/i]")
			_GUICtrlEdit_SetSel($Body_Edit, $Sel[0], $Sel[0])
			_GUICtrlEdit_ReplaceSel($Body_Edit, "[i]")
		Case $Color
			$Body_Color = _ChooseColor(2, $Body_Color, 2)
			If Not @error Then
				GUICtrlSetBkColor($Color, $Body_Color)
				$Sel = _GUICtrlEdit_GetSel($Body_Edit)
				_GUICtrlEdit_SetSel($Body_Edit, $Sel[1], $Sel[1])
				_GUICtrlEdit_ReplaceSel($Body_Edit, "[/color]")
				_GUICtrlEdit_SetSel($Body_Edit, $Sel[0], $Sel[0])
				_GUICtrlEdit_ReplaceSel($Body_Edit, '[color="#' & StringTrimLeft($Body_Color, 2) & '"]')
			Else
			EndIf
		Case $THEME_DELT
			If _GUICtrlComboBox_GetCount($THEME_COMBO) = 1 Then
				MsgBox(48, "", "Can't delete theme if there is only one left!")
			Else
				$DeletTheme = MsgBox(52, "", "Are you sure you want to delete '" & GUICtrlRead($THEME_COMBO) & "'?")
				If $DeletTheme = 6 Then
					IniDelete($THEME, GUICtrlRead($THEME_COMBO))
					IniDelete($THEME, "Theme Count", GUICtrlRead($THEME_COMBO))
					_GUICtrlComboBox_DeleteString($THEME_COMBO, _GUICtrlComboBox_GetCurSel($THEME_COMBO))
					_GUICtrlComboBox_SetCurSel($THEME_COMBO, 0)
					IniWrite($THEME, "Theme Settings", "ThemeSelect", GUICtrlRead($THEME_COMBO))
				Else
				EndIf
			EndIf
		Case $Setting_delete
			If _GUICtrlComboBox_GetCount($SMTP_ACCOUNT) = 1 Then
				
			Else
				$DeletTheme = MsgBox(52, "", "Are you sure you want to delete '" & GUICtrlRead($SMTP_ACCOUNT) & "'?")
				If $DeletTheme = 6 Then
					IniDelete($SMTPSettings, GUICtrlRead($SMTP_ACCOUNT))
					IniDelete($SMTPSettings, "List", GUICtrlRead($SMTP_ACCOUNT))
					_GUICtrlComboBox_DeleteString($SMTP_ACCOUNT, _GUICtrlComboBox_GetCurSel($SMTP_ACCOUNT))
					_GUICtrlComboBox_SetCurSel($SMTP_ACCOUNT, 0)
					IniWrite($SMTPSettings, "Current Account", "Value", GUICtrlRead($SMTP_ACCOUNT))
				Else
				EndIf
			EndIf
		Case $THEME_CB
			If BitAND(GUICtrlRead($THEME_CB), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($THEME_CB, $GUI_CHECKED)
				_GuiCtrlGroupSetState($a_DisableGroup, $GUI_ENABLE)
				GUICtrlSetState($THEME_COMBO, $GUI_DISABLE)
				GUICtrlSetState($THEME_DELT, $GUI_DISABLE)
			Else
				GUICtrlSetState($THEME_CB, $GUI_UNCHECKED)
				_GuiCtrlGroupSetState($a_DisableGroup, $GUI_DISABLE)
				GUICtrlSetState($THEME_COMBO, $GUI_ENABLE)
				GUICtrlSetState($THEME_DELT, $GUI_ENABLE)
			EndIf
		Case $BK_COLOR
			$THEME_BK_COLOR = _ChooseColor(2, $THEME_BK_COLOR, 2)
			GUICtrlSetBkColor($BK_COLOR, $THEME_BK_COLOR)
			GUICtrlSetBkColor($THEME_EXAMPLE, $THEME_BK_COLOR)
		Case $FONT_COLOR
			$THEME_FONT_COLOR = _ChooseColor(2, $THEME_FONT_COLOR, 2)
			GUICtrlSetBkColor($FONT_COLOR, $THEME_FONT_COLOR)
			GUICtrlSetColor($THEME_EXAMPLE, $THEME_FONT_COLOR)
		Case $BOD_COLOR
			$THEME_BC_COLOR = _ChooseColor(2, $THEME_BC_COLOR, 2)
			GUICtrlSetBkColor($BOD_COLOR, $THEME_BC_COLOR)
			GUICtrlSetBkColor($THEME_EXAMPLE2, $THEME_BC_COLOR)
			GUICtrlSetColor($THEME_EXAMPLE2, _LightDark($THEME_BC_COLOR))
		Case $BACKGROUND
			$ChooseBackG = FileOpenDialog("Choose Background", $sEmailer_Dir, "Images (*.jpg;*.bmp)", 1)
			If Not @error Then
				GUICtrlSetData($BACKG_INPUT, $ChooseBackG)
				$BackGroundQ = True
			EndIf
		Case $BACKG_DELT
				GUICtrlSetData($BACKG_INPUT, "")
				$BackGroundQ = False
		Case $THEME_SAVE
			Local $THEME_BK_COLOR, $THEME_FONT_COLOR, $THEME_BC_COLOR, $ChooseBackG
			If GUICtrlRead($THEME_CB) = $GUI_CHECKED Then
				$NEW_THEME = InputBox("New Theme", "What will be the name of your new theme?" & @CRLF & @CRLF & _
								"You may save an existing one, by naming it the same as that existing theme.")
				If Not @error Then
					If $BackGroundQ = True Then
						IniWrite($THEME, $NEW_THEME, "Background", $ChooseBackG)
						IniWrite($THEME, $NEW_THEME, "BkColor", "")
					Else
						IniWrite($THEME, $NEW_THEME, "BkColor", $THEME_BK_COLOR)
						IniWrite($THEME, $NEW_THEME, "Background", "")
					EndIf
					IniWrite($THEME, $NEW_THEME, "FontColor", $THEME_FONT_COLOR)
					IniWrite($THEME, $NEW_THEME, "BodyColor", $THEME_BC_COLOR)
					IniWrite($THEME, "Theme Settings", "ThemeSelect", $NEW_THEME)
					IniWrite($THEME, "Theme Count", $NEW_THEME, "")
					Sleep(500)
					GUISetState(@SW_ENABLE, $Form1)
					GUISetState(@SW_HIDE, $Form4)
					WinActivate("Compose:")
					_restart()
				EndIf
			Else
				IniWrite($THEME, "Theme Settings", "ThemeSelect", GUICtrlRead($THEME_COMBO))
				GUISetState(@SW_ENABLE, $Form1)
				GUISetState(@SW_HIDE, $Form4)
				WinActivate("Compose:")
				If GUICtrlRead($THEME_COMBO) <> $GuiTheme Then _restart()
			EndIf
		Case $THEME_CANC
			GUISetState(@SW_ENABLE, $Form1)
			GUISetState(@SW_HIDE, $Form4)
			WinActivate("Compose:")
		Case $MenuNew
			_New()
		Case $SETTING_Confirm
			$s_FromName 	= GUICtrlRead($SETTING_NAME)
			$s_FromAddress 	= GUICtrlRead($SETTING_EMAIL)
			$s_SmtpServer 	= GUICtrlRead($SETTING_SMTP)
			$IPPort 		= GUICtrlRead($SETTING_PORT)
			$ssl 			= GUICtrlRead($SETTING_SSL)
			$s_Username 	= GUICtrlRead($SETTING_UserName)
			$s_Password 	= GUICtrlRead($SETTING_Password)
			
			If $s_FromName = "" And $s_FromAddress = "" And $s_SmtpServer = "" And $IPPort = "" Then
				MsgBox(48, "No!", "Can not continue due to the lack of information.")
			Else
				GUISetState(@SW_ENABLE, $Form1)
				GUISetState(@SW_HIDE, $Form2)
				
				IniWrite($SMTPSettings, $s_FromName, "SMTP", $s_SmtpServer)
				IniWrite($SMTPSettings, $s_FromName, "IPPort", $IPPort)
				IniWrite($SMTPSettings, $s_FromName, "SSL", $ssl)
				IniWrite($SMTPSettings, $s_FromName, "Name", $s_FromName)
				IniWrite($SMTPSettings, $s_FromName, "Address", $s_FromAddress)
				IniWrite($SMTPSettings, $s_FromName, "Username", $s_Username)
				IniWrite($SMTPSettings, $s_FromName, "Password", _StringEncrypt(1, $s_Password, 1001101, 2))
				IniWrite($SMTPSettings, "Current Account", "Value", $s_FromName)
				IniWrite($SMTPSettings, "List", $s_FromName, "")
				GUICtrlSetData($NameAddress, '"' & $s_FromName & '" <' & $s_FromAddress & '>')
				If GUICtrlRead($SMTP_ACCOUNT) <> $s_FromName Then _restart()
			EndIf
			
		Case $SETTING_Cancel
			GUISetState(@SW_ENABLE, $Form1)
			GUISetState(@SW_HIDE, $Form2)
			GUICtrlSetData($SETTING_SMTP, $s_SmtpServer)
			GUICtrlSetData($SETTING_NAME, $s_FromName)
			GUICtrlSetData($SETTING_EMAIL, $s_FromAddress)
			GUICtrlSetData($SETTING_UserName, $s_Username)
			GUICtrlSetData($SETTING_Password, $s_Password)
			GUICtrlSetData($SETTING_PORT, $IPPort)
			If $ssl = 1 Then
				GUICtrlSetState($SETTING_SSL, $GUI_CHECKED)
			Else
				GUICtrlSetState($SETTING_SSL, $GUI_UNCHECKED)
			EndIf
			WinActivate("Compose:")
		Case $Settings, $SMTPconItem
			_Show_SMTP()
		Case $ChooseTheme
			_Show_Theme()
		Case $AddContact
			_Show_Contact()
		Case $CONTACT_CANCEL
			GUISetState(@SW_ENABLE, $Form1)
			GUISetState(@SW_HIDE, $Form3)
			GUICtrlSetData($AddName, "")
			GUICtrlSetData($AddEmail, "")
		Case $CONTACT_CONFIRM
			If GUICtrlRead($AddName) = "" Then
				If StringInStr(GUICtrlRead($AddEmail), "@") And StringInStr(GUICtrlRead($AddEmail), ".com") Then
					IniWrite($SMTPSettings, "Contacts", $ContactVar[0][0] + 1, GUICtrlRead($AddEmail))
					_GUICtrlComboBox_AddString($ContactCombo, GUICtrlRead($AddEmail))
					GUISetState(@SW_ENABLE, $Form1)
					GUISetState(@SW_HIDE, $Form3)
				Else
					MsgBox(0, "", "Incorrect Email")
				EndIf
			Else
				If GUICtrlRead($AddEmail) = "" Then
				Else
					If StringInStr(GUICtrlRead($AddEmail), "@") Then
						IniWrite($SMTPSettings, "Contacts", $ContactVar[0][0] + 1, GUICtrlRead($AddName) & ' <' & GUICtrlRead($AddEmail) & '>')
						_GUICtrlComboBox_AddString($ContactCombo, GUICtrlRead($AddName) & ' <' & GUICtrlRead($AddEmail) & '>')
						GUISetState(@SW_ENABLE, $Form1)
						GUISetState(@SW_HIDE, $Form3)
					Else
						MsgBox(0, "", "Incorrect Email")
					EndIf
				EndIf
			EndIf
			GUICtrlSetData($AddName, "")
			GUICtrlSetData($AddEmail, "")
		Case $StatusBarSwHd
			If BitAND(GUICtrlRead($StatusBarSwHd), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($StatusBarSwHd, $GUI_UNCHECKED)
				_GUICtrlStatusBar_ShowHide($StatusBar1, @SW_HIDE)
				GUICtrlSetPos ($Body_Edit, 5, 224, 615, 205)
				GUICtrlSetData($StatusBarSwHd, "Show &Status Bar")
			Else
				GUICtrlSetState($StatusBarSwHd, $GUI_CHECKED)
				_GUICtrlStatusBar_ShowHide($StatusBar1, @SW_SHOW)
				GUICtrlSetPos ($Body_Edit, 5, 224, 615, 185)
				GUICtrlSetData($StatusBarSwHd, "Hide &Status Bar")
			EndIf
		Case $FormatBarSwHd
			If BitAND(GUICtrlRead($FormatBarSwHd), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($FormatBarSwHd, $GUI_UNCHECKED)
				_GuiCtrlGroupSetState($s_FormatBar, $GUI_HIDE)
				GUICtrlSetData($FormatBarSwHd, "Show &Format Bar")
			Else
				GUICtrlSetState($FormatBarSwHd, $GUI_CHECKED)
				_GuiCtrlGroupSetState($s_FormatBar, $GUI_SHOW)
				GUICtrlSetData($FormatBarSwHd, "Hide &Format Bar")
			EndIf
		Case $MenuAttach
			$ATTACHFILE = FileOpenDialog("Attach File", "", "Common Files (*.jpg;*.bmp;*.gif;*.txt;*.ini;*.dat;*.html;*.htm;*.doc;*.ppt;*.pdf;*.mp2;*.mp3;*.mp4;*.mpeg;*.wav)", 5)
			If Not @error Then
				GUICtrlSetState($AttachList, $GUI_SHOW)
				GUICtrlSetState($File_sizes, $GUI_SHOW)
				GUICtrlSetState($FileDelete, $GUI_SHOW)
				
				$ATTACHFILE = StringSplit($ATTACHFILE, "|")
				
				If $ATTACHFILE[0] = 1 Then
					$a_AttachFiles[0] += 1
					ReDim $a_AttachFiles[$a_AttachFiles[0]+1]
					$a_AttachFiles[$a_AttachFiles[0]] = $ATTACHFILE[1]
					
					GUICtrlSetData($AttachList, _GetShortName($ATTACHFILE[1]) & "|")
					$f_size += FileGetSize($ATTACHFILE[1])
				Else
					For $r = 2 To $ATTACHFILE[0]
						$a_AttachFiles[0] += 1
						ReDim $a_AttachFiles[$a_AttachFiles[0]+1]
						$a_AttachFiles[$a_AttachFiles[0]] = $ATTACHFILE[1] & "\" & $ATTACHFILE[$r]
						
						GUICtrlSetData($AttachList, _GetShortName($ATTACHFILE[$r]) & "|")
						$f_size += FileGetSize($a_AttachFiles[$a_AttachFiles[0]])
					Next
				EndIf
			EndIf
			
			GUICtrlSetData($File_sizes, _GetDisplaySize($f_size))
		Case $FileDelete
			Local $iCurrentSelIndex = _GUICtrlListBox_GetCurSel($AttachList)
			_GUICtrlListBox_DeleteString($AttachList, $iCurrentSelIndex)
			
			Local $a_TmpAttachs[1]
			
			For $i = 1 To $a_AttachFiles[0]
				If $i <> $iCurrentSelIndex+1 Then
					$a_TmpAttachs[0] += 1
					ReDim $a_TmpAttachs[$a_TmpAttachs[0]+1]
					$a_TmpAttachs[$a_TmpAttachs[0]] = $a_AttachFiles[$i]
				Else
					$f_size -= FileGetSize($a_AttachFiles[$i])
				EndIf
			Next
			
			$a_AttachFiles = $a_TmpAttachs
			GUICtrlSetData($File_sizes, _GetDisplaySize($f_size))
		Case $MenuSave
			_Save()
		Case $Drftvw
			IniWrite($Draft, "Draft", "Ask", "True")
			_GUICtrlComboBox_SelectString($ContactCombo, $Draft_To)
			GUICtrlSetData($CC_Input, $Draft_CC)
			GUICtrlSetData($BCC_Input, $Draft_BCC)
			GUICtrlSetData($Subject_Input, $Draft_SJ)
			GUICtrlSetData($Body_Edit, $Draft_Body)
			GUICtrlSetState($Drftvw, $GUI_DISABLE)
		Case $Send_Button, $SendNow
			_SendEmail()
		Case $Preview
			_PreviewEmail()
		Case $ExitWOSaving
			Exit
	EndSwitch
WEnd

Func _Show_SMTP()
	GUISetState(@SW_DISABLE, $Form1)
	GUISetState(@SW_SHOW, $Form2)
EndFunc

Func _Show_Contact()
	GUISetState(@SW_DISABLE, $Form1)
	GUISetState(@SW_SHOW, $Form3)
	GUICtrlSetState($CONTACT_CANCEL, $GUI_FOCUS)
EndFunc

Func _Show_Theme()
	GUISetState(@SW_DISABLE, $Form1)
	GUISetState(@SW_SHOW, $Form4)
	GUICtrlSetState($THEME_COMBO, $GUI_FOCUS)
EndFunc

Func _Save()
	IniWrite($Draft, "Draft", "Ask", "False")
	IniWrite($Draft, "Draft", "To", GUICtrlRead($ContactCombo))
	IniWrite($Draft, "Draft", "CC", GUICtrlRead($CC_Input))
	IniWrite($Draft, "Draft", "BCC", GUICtrlRead($BCC_Input))
	IniWrite($Draft, "Draft", "Subject", GUICtrlRead($Subject_Input))
	IniWrite($Draft, "Draft", "Body", GUICtrlRead($Body_Edit))
	
	$Change = False
EndFunc   ;==>_Save

Func _Quit()
	If IniRead($Draft, "Draft", "Ask", "") = "True" Then
		$AskToSave = MsgBox(3, "Save", "Message not sent! Would you like to save to the Draft file?")
		If $AskToSave = 6 Then
			IniWrite($Draft, "Draft", "Ask", "True")
			IniWrite($Draft, "Draft", "To", GUICtrlRead($ContactCombo))
			IniWrite($Draft, "Draft", "CC", GUICtrlRead($CC_Input))
			IniWrite($Draft, "Draft", "BCC", GUICtrlRead($BCC_Input))
			IniWrite($Draft, "Draft", "Subject", GUICtrlRead($Subject_Input))
			IniWrite($Draft, "Draft", "Body", GUICtrlRead($Body_Edit))
			Exit
		ElseIf $AskToSave = 7 Then
			IniWrite($Draft, "Draft", "Ask", "False")
			IniWrite($Draft, "Draft", "To", "")
			IniWrite($Draft, "Draft", "CC", "")
			IniWrite($Draft, "Draft", "BCC", "")
			IniWrite($Draft, "Draft", "Subject", "")
			IniWrite($Draft, "Draft", "Body", "")
			Exit
		Else
		EndIf
	Else
		If $Draft_To <> "" Or $Draft_BCC <> "" Or $Draft_CC <> "" Or $Draft_Body <> "" Or $Draft_SJ <> "" Then 
			IniWrite($Draft, "Draft", "Ask", "True")
		Else
			IniWrite($Draft, "Draft", "Ask", "False")
		EndIf
		Exit
	EndIf
EndFunc   ;==>_Quit

Func _New()
	IniWrite($Draft, "Draft", "Ask", "False")
	IniWrite($Draft, "Draft", "To", "")
	IniWrite($Draft, "Draft", "CC", "")
	IniWrite($Draft, "Draft", "BCC", "")
	IniWrite($Draft, "Draft", "Subject", "")
	IniWrite($Draft, "Draft", "Body", "")
		
	_GUICtrlComboBox_SetCurSel($ContactCombo,0)
	_GuiCtrlGroupSetData($s_Inputs, "")
	$Change = False
EndFunc   ;==>_New

Func _Delete($a_selected)
	_GUICtrlListBox_DeleteString($AttachList, $a_selected)
EndFunc   ;==>_Delete

Func _PreviewEmail()
	$get_body = GUICtrlRead($Body_Edit)
	$get_body = StringReplace($get_body, "<", '&#60;')
	$get_body = StringReplace($get_body, ">", '&#62;')
	$get_body = StringReplace($get_body, "[color", '<Font color')
	$get_body = StringReplace($get_body, "[/color]", '</font>')
	$get_body = StringReplace($get_body, "[", "<")
	$get_body = StringReplace($get_body, "]", ">")
	$get_body = StringReplace($get_body, "    ", @TAB)
	$get_body = StringReplace($get_body, @CRLF, "<br>")

	$sHTML = ""
	$sHTML &= "<HTML>" & @CR
	$sHTML &= "<HEAD>" & @CR
	$sHTML &= "<TITLE>Moth Email</TITLE>" & @CR
	$sHTML &= "</HEAD>" & @CR
	$sHTML &= '<BODY bgcolor="#' & Hex($THEME_BK_COLOR, 6) & '">' & @CR
	$sHTML &= '<table width="800px" border="0" cellpadding="0" cellspacing="2" bgcolor="#' & Hex($THEME_BK_COLOR, 6) & '">' & @CR
	$sHTML &= "<tr>" & @CR
	$sHTML &=   '<td width="5%">' & @CR
	$sHTML &=     '<font size="3" face="monospace" color="#' & Hex($THEME_FONT_COLOR, 6) & '">'  & @CR
	$sHTML &=       '<div align="right">from:<br />' & @CR
	$sHTML &=       'to:<br />' & @CR
	$sHTML &=       'subject:</div></font></td>' & @CR
	$sHTML &=   '<td width="95%"><p>' & @CR
	$sHTML &=     '<font size="3" face="monospace" color="#' & Hex($THEME_FONT_COLOR, 6) & '">' & $s_FromName & '  &#60;' & $s_FromAddress & '&#62;'  & '<br />' & @CR
	$sHTML &=       StringReplace(StringReplace(GUICtrlRead($ContactCombo), "<", "&#60;"), ">", "&#62;") & '<br />' & @CR
	$sHTML &=       StringReplace($Title, "Moth Email  Compose: ", "") & '</p></td>' & @CR
	$sHTML &=     "</font></td></tr></table>" & @CR
	$sHTML &= '<table width="800px" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFF99">' & @CR
	$sHTML &= '<tr><td><font face="' & $FontFace & '" size="' & ($FontSize / 4) & '">' & $get_body & '<br/> </font></td></tr></table>'& @CR
	$sHTML &= "</BODY>" & @CR
	$sHTML &= "</HTML>"

	FileDelete($sEmailer_Dir & "/email.html")
	FileWrite($sEmailer_Dir & "/email.html", $sHTML)
	ShellExecute($sEmailer_Dir & "/email.html")
EndFunc

Func _SendEmail()
	$s_ToAddress 	= GUICtrlRead($ContactCombo) 	
	$s_Subject 		= GUICtrlRead($Subject_Input) 
	$as_Body 		= GUICtrlRead($Body_Edit) 		
	$s_CcAddress 	= GUICtrlRead($CC_Input) 
	$s_BccAddress 	= GUICtrlRead($BCC_Input)
	
	$s_AttachFiles 	= ""
	
	For $i = 1 To $a_AttachFiles[0]
		$s_AttachFiles &= $a_AttachFiles[$i] & "|"
	Next
	
	$s_AttachFiles = StringRegExpReplace($s_AttachFiles, "\|+$", "")
	
	GUISetCursor(1, 1, $Form1)
	GUISetState(@SW_DISABLE, $Form1)
	
	$rc = _INetSmtpMailCom($s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress, _
		$s_Subject, $as_Body, $s_AttachFiles, $s_CcAddress, $s_BccAddress, $s_Username, $s_Password, $IPPort, $ssl)
	
	If @error Then MsgBox(16, "Error sending message", $rc, 2)
	
	GUISetState(@SW_ENABLE, $Form1)
	
	IniWrite($Draft, "Draft", "To", "")
	IniWrite($Draft, "Draft", "CC", "")
	IniWrite($Draft, "Draft", "BCC", "")
	IniWrite($Draft, "Draft", "Attach", "")
	IniWrite($Draft, "Draft", "Subject", "")
	IniWrite($Draft, "Draft", "Body", "")
	
	GUICtrlSetData($progress, 0)
EndFunc   ;==>_SendEmail

Func _INetSmtpMailCom($s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress, $s_Subject = "", $as_Body = "", $s_AttachFiles = "", $s_CcAddress = "", $s_BccAddress = "", $s_Username = "", $s_Password = "", $IPPort = 25, $ssl = 0)
	$objEmail = ObjCreate("CDO.Message")
	$objEmail.From = '"' & $s_FromName & '" <' & $s_FromAddress & '>'
	$objEmail.To = $s_ToAddress
	
	Local $i_Error = 0
	Local $i_Error_desciption = ""
	
	If $s_CcAddress <> "" Then $objEmail.Cc = $s_CcAddress
	If $s_BccAddress <> "" Then $objEmail.Bcc = $s_BccAddress
	
	If $s_Subject <> "" Then
		$objEmail.Subject = $s_Subject
	Else
		$objEmail.Subject = "(no subject)"
	EndIf
	
	$as_Body = StringReplace($as_Body, "<", '&#60;')
	$as_Body = StringReplace($as_Body, ">", '&#62;')
	$as_Body = StringReplace($as_Body, "[color", '<Font color')
	$as_Body = StringReplace($as_Body, "[/color]", '</font>')
	$as_Body = StringReplace($as_Body, "[", "<")
	$as_Body = StringReplace($as_Body, "]", ">")
	$as_Body = StringReplace($as_Body, @CRLF, "<br>")
	
	$objEmail.HTMLBody = '<font face="' & $FontFace & '" size="' & ($FontSize / 4) & '">' & $as_Body & @CRLF & '</font>'
	
	If $s_AttachFiles <> "" Then
		Local $S_Files2Attach = StringSplit($s_AttachFiles, "|")
		
		For $x = 1 To $S_Files2Attach[0]
			$S_Files2Attach[$x] = _PathFull($S_Files2Attach[$x])
			
			If FileExists($S_Files2Attach[$x]) Then
				$objEmail.AddAttachment($S_Files2Attach[$x])
			Else
				SetError(1)
				Return 0
			EndIf
		Next
	EndIf
	
	$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
	$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = $s_SmtpServer
	$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = $IPPort
	
	;Authenticated SMTP
	If $s_Username <> "" Then
		$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
		$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = $s_Username
		$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = $s_Password
	EndIf
	
	If $ssl Then $objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True
	
	;Update settings
	$objEmail.Configuration.Fields.Update
	
	For $e = 1 To 80
		GUICtrlSetData($progress, $e)
		Sleep(2)
	Next
	
	; Sent the Message
	$objEmail.Send
	
	If @error Then
		SetError(2)
		Return $oMyRet[1]
	Else
		GUICtrlSetData($progress, 100)
		
		MsgBox(64, "Sent", "Mail Successfully Sent!", 2)
		
		_GuiCtrlGroupSetData($s_Inputs, "")
		
		_GUICtrlComboBox_SetCurSel($ContactCombo,0)
		GUICtrlSetState($AttachList, $GUI_HIDE)
		GUICtrlSetState($File_sizes, $GUI_HIDE)
		GUICtrlSetState($FileDelete, $GUI_HIDE)
		GUICtrlSetData($File_sizes, "")
		IniWrite($Draft, "Draft", "Ask", "False")
	EndIf
EndFunc   ;==>_INetSmtpMailCom

Func MyErrFunc()
	$HexNumber = Hex($oMyError.number, 8)
	$oMyRet[0] = $HexNumber
	$oMyRet[1] = StringStripWS($oMyError.description, 3)
	SetError(1); something to check for when this function returns
	Return
EndFunc   ;==>MyErrFunc

Func _GetShortName($h_Data, $i_Char = "\")
	$h_Data = StringSplit($h_Data, $i_Char)
	$s_Data = $h_Data[$h_Data[0]]
	Return $s_Data
EndFunc   ;==>_GetShortName

Func _GuiCtrlGroupSetData(ByRef $a_GroupArray, $i_Data)
	For $i = 1 To $a_GroupArray[0]
		GUICtrlSetData($a_GroupArray[$i], $i_Data)
	Next
EndFunc   ;==>_GuiCtrlGroupSetData

Func _GuiCtrlGroupSetState(ByRef $a_GroupArray, $i_State)
	For $i = 1 To $a_GroupArray[0]
		GUICtrlSetState($a_GroupArray[$i], $i_State)
	Next
EndFunc   ;==>_GuiCtrlGroupSetState

Func _GetDisplaySize($iByteSize, $iRound=2)
	Local $asBytes[9] = [8, ' KB', ' MB', ' GB', ' TB', ' PB', ' EB', ' ZB', ' YB'] ;Last two unreachable ;)
	Local $iBytes_Val = 2 ^ 10
	
	If $iByteSize < $iBytes_Val Then Return $iByteSize & ' Bytes'
	
	For $i = 8 To 1 Step -1
		If $iByteSize >= $iBytes_Val ^ $i Then Return Round($iByteSize / $iBytes_Val ^ $i, $iRound) & $asBytes[$i]
	Next
EndFunc   ;==>_GetDisplaySize

Func _LightDark($i_Color)
	If $i_Color > 0xFFFFFF/2 Then $o_Color = 0x000000
	If $i_Color < 0xFFFFFF/2 Then $o_Color = 0xFFFFFF
	Return $o_Color
EndFunc

Func _restart()
	_Save()
	IniWrite($Draft, "Draft", "Ask", "False")
    If @Compiled = 1 Then
        Run( FileGetShortName(@ScriptFullPath))
    Else
        Run( FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
    EndIf
	Exit
EndFunc

Func GuiSetBKToFit($BKValue)
	Local $pos
	$BK 	= 	GUICtrlCreatePic($BKValue, -1, -1, 0, 0, 0, $WS_EX_LAYERED)
	$pos 	= 	ControlGetPos($Title, "", $BK)
				GUICtrlDelete($BK)
	$ratio 	= $pos[2] / $pos[3]
	
	If $pos[2] >= 626 Then
		If $pos[3] >= 455 Then
			$BK = GUICtrlCreatePic($BKValue, -(($pos[2]-626)/2), -(($pos[3]-455)/2), $pos[2], $pos[3], 0, $WS_EX_LAYERED)
		EndIf
	EndIf
		
	If $pos[2] < 626 Then
		If $pos[3] < 455 Then
			$BK = GUICtrlCreatePic($BKValue, 0, 0, 626 * $ratio, 455, 0, $WS_EX_LAYERED)
		EndIf
	EndIf
EndFunc

Func _Timer_GetIdleTime()
; Get ticks at last activity
    Local $tStruct = DllStructCreate("uint;dword");
    DllStructSetData($tStruct, 1, DllStructGetSize($tStruct));
    DllCall("user32.dll", "int", "GetLastInputInfo", "ptr", DllStructGetPtr($tStruct))

; Get current ticks since last restart
    Local $avTicks = DllCall("Kernel32.dll", "int", "GetTickCount")

; Return time since last activity, in ticks (approx milliseconds)
    Local $iDiff = $avTicks[0] - DllStructGetData($tStruct, 2)
    If $iDiff >= 0 Then
    ; Normal return
        Return $iDiff
    Else
    ; Rollover of ticks counter has occured
        Return SetError(0, 1, $avTicks[0])
    EndIf
EndFunc  ;==>_Timer_GetIdleTime

Func _MilitaryTo12Hour($hHour, $mMin, $AMPM = 0)
Local $apM = " AM"
	Switch $hHour
		Case 00
			$nHour = 12
		Case 1 to 12
			$nHour = $hHour
		Case 13 To 24
			$nHour = $hHour - 12
			$apM = " PM"
	EndSwitch
	If $AMPM = 1 Then $apM = ""
	Return $nHour & ":" & $mMin & $apM
EndFunc   ;==>_ChangeTime

Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	Local $hWndFrom, $iIDFrom, $iCode
	$hWndEdit = GUICtrlGetHandle($SETTING_EMAIL)
	$hWndEdit1 = GUICtrlGetHandle($Body_Edit)
	$hWndCombo = GUICtrlGetHandle($ContactCombo)
	$hWndCombo2 = GUICtrlGetHandle($FontCombo)
	$hWndCombo3 = GUICtrlGetHandle($SizeCombo)
	$hWndThemeCombo = GUICtrlGetHandle($THEME_COMBO)
	$hWndSMTPCombo = GUICtrlGetHandle($SMTP_ACCOUNT)
	$hWndListView = GUICtrlGetHandle($AttachList)
	$hWndFrom = $ilParam
	$iIDFrom = _WinAPI_LoWord($iwParam)
	$iCode = _WinAPI_HiWord($iwParam)
	Switch $hWndFrom
		Case $hWndEdit1
			Switch $iCode
				Case $EN_CHANGE
					IniWrite($Draft, "Draft", "Ask", "True")
					$Change = True
					_GUICtrlStatusBar_SetText($StatusBar1, "Text Len: " & _GUICtrlEdit_GetTextLen($hWndEdit1), 2)
					If _GUICtrlEdit_GetTextLen($hWndEdit1) = 0 Then
						GUICtrlSetState($Send_Button, $GUI_DISABLE)
						GUICtrlSetState($SendNow, $GUI_DISABLE)
						GUICtrlSetState($Preview, $GUI_DISABLE)
						HotKeySet("{F11}")
						HotKeySet("^{ENTER}")
					Else
						If @IPAddress1 = "127.0.0.1" Then
							_GUICtrlStatusBar_SetText($StatusBar1, "Not Connected", 0)
							GUICtrlSetState($SendNow, $GUI_DISABLE)
							GUICtrlSetState($Send_Button, $GUI_DISABLE)
							GUICtrlSetState($Preview, $GUI_DISABLE)
						Else
							GUICtrlSetState($Send_Button, $GUI_ENABLE)
							GUICtrlSetState($SendNow, $GUI_ENABLE)
							GUICtrlSetState($Preview, $GUI_ENABLE)
							HotKeySet("{F11}", "_PreviewEmail")
							HotKeySet("^{ENTER}", "_SendEmail")
							EndIf
					EndIf
				Case $EN_SETFOCUS
				Case $EN_KILLFOCUS
			EndSwitch
		Case $hWndCombo2
			Switch $iCode
				Case $CBN_SELCHANGE
					GUICtrlSetFont($Body_Edit, GUICtrlRead($SizeCombo), 400, 0, GUICtrlRead($FontCombo))
;~ 					_GUICtrlStatusBar_SetText($StatusBar1, GUICtrlRead($FontCombo) & " [" & GUICtrlRead($SizeCombo) & "]", 1)
					IniWrite($SMTPSettings, "Font", "Face", GUICtrlRead($FontCombo))
					IniWrite($SMTPSettings, "Font", "Size", GUICtrlRead($SizeCombo))
					$FontFace = GUICtrlRead($FontCombo)
					$FontSize = GUICtrlRead($SizeCombo)
			EndSwitch
		Case $hWndCombo3
			Switch $iCode
				Case $CBN_SELCHANGE
					GUICtrlSetFont($Body_Edit, GUICtrlRead($SizeCombo), 400, 0, GUICtrlRead($FontCombo))
;~ 					_GUICtrlStatusBar_SetText($StatusBar1, GUICtrlRead($FontCombo) & " [" & GUICtrlRead($SizeCombo) & "]", 1)
					IniWrite($SMTPSettings, "Font", "Face", GUICtrlRead($FontCombo))
					IniWrite($SMTPSettings, "Font", "Size", GUICtrlRead($SizeCombo))
					$FontFace = GUICtrlRead($FontCombo)
					$FontSize = GUICtrlRead($SizeCombo)
			EndSwitch
		Case $hWndCombo
			Switch $iCode
				Case $CBN_EDITCHANGE
					_GUICtrlComboBox_AutoComplete($ContactCombo)
					IniWrite($Draft, "Draft", "Ask", "True")
			EndSwitch
		Case $hWndEdit
			Switch $iCode
				Case $EN_KILLFOCUS
					$Read_Email = GUICtrlRead($SETTING_EMAIL)
					
					If StringInStr($Read_Email, "gmail") Then
						GUICtrlSetData($SETTING_SMTP, "smtp.gmail.com")
						GUICtrlSetData($SETTING_PORT, "465")
					ElseIf StringInStr($Read_Email, "yahoo") Then
						GUICtrlSetData($SETTING_SMTP, "smtp.mail.yahoo.com")
						GUICtrlSetData($SETTING_PORT, "587")
					ElseIf StringInStr($Read_Email, "comcast") Then
						GUICtrlSetData($SETTING_SMTP, "smtp.comcast.net")
						GUICtrlSetData($SETTING_PORT, "110")
					ElseIf StringInStr($Read_Email, "aol") Then
						GUICtrlSetData($SETTING_SMTP, "smtp.aol.net")
						GUICtrlSetData($SETTING_PORT, "587")
					ElseIf StringInStr($Read_Email, "earthlink") Then
						GUICtrlSetData($SETTING_SMTP, "smtpauth.earthlink.net")
						GUICtrlSetData($SETTING_PORT, "25")
					EndIf
			EndSwitch
		Case $hWndThemeCombo
			Switch $iCode
				Case $CBN_SELCHANGE
					$EXPBK = IniRead($THEME, GUICtrlRead($THEME_COMBO), "BkColor", "")
					$EXPBG = IniRead($THEME, GUICtrlRead($THEME_COMBO), "Background", "")
					$EXPFC = IniRead($THEME, GUICtrlRead($THEME_COMBO), "FontColor", "")
					$EXPBC = IniRead($THEME, GUICtrlRead($THEME_COMBO), "BodyColor", "")
					$THEME_BK_COLOR = $EXPBK
					$THEME_BACKGROUND = $EXPBG
					$THEME_FONT_COLOR = $EXPFC
					$THEME_BC_COLOR = $EXPBC
					GUICtrlSetBkColor($BK_COLOR, $EXPBK)
					GUICtrlSetBkColor($FONT_COLOR, $EXPFC)
					GUICtrlSetBkColor($BOD_COLOR, $EXPBC)
					GUICtrlSetColor($THEME_EXAMPLE, $EXPFC)
					GUICtrlSetBkColor($THEME_EXAMPLE, $EXPBK)
					GUICtrlSetColor($THEME_EXAMPLE2, _LightDark($EXPBC))
					GUICtrlSetBkColor($THEME_EXAMPLE2, $EXPBC)
					GUICtrlSetData($BACKG_INPUT, $THEME_BACKGROUND)
			EndSwitch
		Case $hWndSMTPCombo
			Switch $iCode
				Case $CBN_SELCHANGE
					If GUICtrlRead($SMTP_ACCOUNT) = "Create New..." Then 
						GUICtrlSetState($Setting_delete, $GUI_DISABLE)
					Else
						GUICtrlSetState($Setting_delete, $GUI_ENABLE)
					EndIf
					$SMTP1 = IniRead($SMTPSettings, GUICtrlRead($SMTP_ACCOUNT), "Name", "")
					$SMTP2 = IniRead($SMTPSettings, GUICtrlRead($SMTP_ACCOUNT), "Address", "")
					$SMTP3 = IniRead($SMTPSettings, GUICtrlRead($SMTP_ACCOUNT), "SMTP", "")
					$SMTP4 = IniRead($SMTPSettings, GUICtrlRead($SMTP_ACCOUNT), "IPPort", "")
					$SMTP5 = IniRead($SMTPSettings, GUICtrlRead($SMTP_ACCOUNT), "SSL", "")
					$SMTP6 = IniRead($SMTPSettings, GUICtrlRead($SMTP_ACCOUNT), "Username", "")
					$SMTP7 = IniRead($SMTPSettings, GUICtrlRead($SMTP_ACCOUNT), "Password", "")
					$SMTP7 	= _StringEncrypt(0, $SMTP7, 1001101, 2)
					
					GUICtrlSetData($SETTING_NAME, $SMTP1)
					GUICtrlSetData($SETTING_EMAIL, $SMTP2)
					GUICtrlSetData($SETTING_SMTP, $SMTP3)
					GUICtrlSetData($SETTING_PORT, $SMTP4)
					GUICtrlSetState($SETTING_SSL, $SMTP5)
					GUICtrlSetData($SETTING_UserName, $SMTP6)
					GUICtrlSetData($SETTING_Password, $SMTP7)
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND