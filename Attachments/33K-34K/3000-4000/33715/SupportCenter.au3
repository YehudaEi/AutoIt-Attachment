#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=_Files\Exec.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.0
 Author:         myName

 Script Function:
				Central Support System for Windows devices on a Active Directory
				Domain infrastructure.

#ce ----------------------------------------------------------------------------

AutoItSetOption("TrayIconDebug",1)
AutoItSetOption("TrayMenuMode",0)
OnAutoItExitRegister("_MFunc_CSC_Quit")

;==================================INCLUDES=====================================
#Include <adfunctions.au3>
#include <Array.au3>			;?
#include <ButtonConstants.au3>	;?
#include <EditConstants.au3>	;?
#Include <File.au3>
#include <GUIConstants.au3>		;?
#include <GUIConstantsEx.au3>	;?
#Include <GuiListBox.au3>		;?
#Include <GuiListView.au3>
#include <IE.au3>
#include <StaticConstants.au3>	;?
#Include <String.au3>
#include <WindowsConstants.au3>
#include <SQLite.au3>
#include <TreeViewConstants.au3> ;?
#Include <GuiListView.au3>
#Include <GuiEdit.au3>
#Include <GuiButton.au3>

;==================================Global & Constant VARIABLES===================

Const  $hDB = @ScriptDir &"\_Files\Database\Data4.db"
Const  $userDB = @ScriptDir &"\_Files\UserSettings\"& @LogonDomain &"_" & @UserName &".db"
Const  $ReportDB = @ScriptDir &"\_Files\Reporting\BsRsCs.db"
Const  $IMG_RemoteAssist = @ScriptDir &"\_Files\Images\Remote.bmp"
Const  $IMG_Splash = @ScriptDir &"\_Files\Images\Splash.GIF"
Const  $UtilPath = '"' &@ScriptDir &"\_Files\Utilities\"

Global $PcName = ""
Global $AttachedUsername = ""
Global $AttachedUserSID = ""
Global $AttachedComputer = ""
Global $AttachedComputerStatus = ""
Global $AttachedUserHomeDir = ""
Global $AttachedUserProDir = ""
Global $AttachedUserGroupDir = ""
Global $Display_AttachedUsername, $Display_AttachedUserSID, $Display_AttachedDomain, $Display_AttachedComputer
Global $Display_AttachedUserHomePath, $Display_AttachedUserProfilePath, $Display_AttachedUserGroupPath
Global $Button_Goto_Home, $Button_Goto_Profile, $Button_Goto_Group, $Button_Att_RemoteAssist
Global $Form_Main, $Console_Display, $Console_Input, $DisplayInfo
Global $AttachedDomain = @LogonDomain
Global $GGLocRecords[1][1]
Global $GGLocUpdate = 0
Global $UpdateCount = 0
Global $UserAccessLevel = 0
Global $AttachedStatus = 0

_StartupChecksAndTasks()

Global $Version = Gsetting("Version")
Global $AppIcon = Gsetting("AppIcon")
Global $AppStatus = Gsetting("AppStatus")
Global $SCCMServerName = Gsetting("SCCMServerName")
Global $KnowledgeBaseAddress = Gsetting("KnowledgeBaseAddress")


;==================================MAIN SCRITP=========================================

_SplashLoad()
_BuildMenu()

;______________________________________________________________________________________
;==================================MENU FUNCTIONS======================================
Func _BuildMenu()
	Local $TMenu, $SMenu1, $SMenu2, $SMenu3, $SMenu4, $SSMenu5, $SSSMenu
	Local $MenuItem[300][2]
	Local $ICount = 0
	Local $TCount = 0
	Local $CNT, $CNT2, $CNT3, $CNT4, $CNT5, $CNT6
		  $Form_Main = GUICreate("Central Support Center", 950, 570, -1, -1)
		  GUICtrlCreateGroup("Attached To:",445,10,405,100)
	Local $Button_Att_Username = GUICtrlCreateButton("Attached Username: ",450,25,110,20,0x8000)
	Local $Button_Att_Domain = GUICtrlCreateButton("Attached Domain: ",450,45,110,20,0x8000)
	Local $Button_Att_SID = GUICtrlCreateButton("Attached SID: ",450,65,110,20,0x8800)
	Local $Button_Att_Computer = GUICtrlCreateButton("Attached Computer: ",450,85,110,20,0x8000)
	Local $Button_KB = GUICtrlCreateButton("Knowlegde Base",814,1,125,14,0x8000)

	$Display_AttachedUsername = GUICtrlCreateLabel($AttachedUsername,565,28,280,20)
	$Display_AttachedDomain = GUICtrlCreateLabel($AttachedDomain,565,48,280,20)
	$Display_AttachedUserSID = GUICtrlCreateLabel($AttachedUserSID,565,68,280,20)
	$Display_AttachedComputer = GUICtrlCreateLabel($AttachedComputer,565,88,200,20)

		  GUICtrlCreateGroup("Quick Path Loader:",445,110,495,85)
	$Button_Goto_Home = GUICtrlCreateButton("GoTo Home: ",450,130,75,20,0x8000)
	$Button_Goto_Profile = GUICtrlCreateButton("GoTo Profile: ",450,150,75,20,0x8000)
	$Button_Goto_Group = GUICtrlCreateButton("GoTo Group: ",450,170,75,20,0x8000)
	$Button_Att_RemoteAssist = GUICtrlCreateButton("Assist",828,88,19,19,0x8080)

	_GUICtrlButton_SetImage($Button_Att_RemoteAssist, $IMG_RemoteAssist)

	GUICtrlSetState($Button_Goto_Home,$GUI_DISABLE)
	GUICtrlSetState($Button_Goto_Profile,$GUI_DISABLE)
	GUICtrlSetState($Button_Goto_Group,$GUI_DISABLE)
	GUICtrlSetState($Button_Att_RemoteAssist,$GUI_HIDE)

	$Display_AttachedUserHomePath = GUICtrlCreateLabel($AttachedUserHomeDir,530,132,400,15)
	$Display_AttachedUserProfilePath = GUICtrlCreateLabel($AttachedUserProDir,530,153,400,15)
	$Display_AttachedUserGroupPath = GUICtrlCreateLabel($AttachedUserGroupDir,530,174,400,15)

	GUICtrlCreateGroup("Display Information:",10,10,430,530)
	$DisplayInfo = GUICtrlCreateEdit("",20,30,410,500,0x00201804)

	GUICtrlCreateIcon($AppIcon,"BackGround",854,16,85,93,0x1000,"")

	GUICtrlCreateGroup("Console:",445,195,495,345)
	Global $Console_Display = GUICtrlCreateEdit("",450,212,485,295,0x00201804)
	Global $Console_Input = GUICtrlCreateInput("",450,510,400,20)
	$Console_Button = GUICtrlCreateButton("Send Command",852,510,83,20)

	Local $DbInfo1 = _DBQuery($hDB,"SELECT * FROM ML_TopMenu order by Count")

	For $x1 = 0 to (UBound($DbInfo1) - 1) Step 1
		$TMenu = GUICtrlCreateMenu($DbInfo1[$x1][1])
		Local $DbInfo2 = _DBQuery($hDB,"SELECT * FROM ML_SubMenu where AttachMenuName = '" &$DbInfo1[$x1][1] &"' Order by ItemOrder")
		For $x2 = 0 to (UBound($DbInfo2) - 1) Step 1
			If $DbInfo2[$x2][4] = "I" Then
				$ICount = $ICount + 1
				$MenuItem[$ICount][0] = GUICtrlCreateMenuItem($DbInfo2[$x2][3],$TMenu)
				$MenuItem[$ICount][1] = $DbInfo2[$x2][3]
				$MenuItem[0][0] = $ICount
			ElseIf $DbInfo2[$x2][4] = "M" Then
				$SMenu1 = GUICtrlCreateMenu($DbInfo2[$x2][3],$TMenu)
			EndIf
			Local $DbInfo3 = _DBQuery($hDB,"SELECT * FROM ML_SubMenu where AttachMenuName = '" &$DbInfo2[$x2][3] &"' Order by ItemOrder")
			For $x3 = 0 to (UBound($DbInfo3) - 1) Step 1
				If $DbInfo3[$x3][4] = "I" Then
					$ICount = $ICount + 1
					$MenuItem[$ICount][0] = GUICtrlCreateMenuItem($DbInfo3[$x3][3],$SMenu1)
					$MenuItem[$ICount][1] = $DbInfo3[$x3][3]
					$MenuItem[0][0] = $ICount
				ElseIf $DbInfo3[$x3][4] = "M" Then
					$SMenu2 = GUICtrlCreateMenu($DbInfo3[$x3][3],$SMenu1)
				EndIf
				Local $DbInfo4 = _DBQuery($hDB,"SELECT * FROM ML_SubMenu where AttachMenuName = '" &$DbInfo3[$x3][3] &"' Order by ItemOrder")
				For $x4 = 0 to (UBound($DbInfo4) - 1) Step 1
					If $DbInfo4[$x4][4] = "I" Then
						$ICount = $ICount + 1
						$MenuItem[$ICount][0] = GUICtrlCreateMenuItem($DbInfo4[$x4][3],$SMenu2)
						$MenuItem[$ICount][1] = $DbInfo4[$x4][3]
						$MenuItem[0][0] = $ICount
					ElseIf $DbInfo4[$x4][4] = "M" Then
						$SMenu3 = GUICtrlCreateMenu($DbInfo4[$x4][3],$SMenu2)
					EndIf
					Local $DbInfo5 = _DBQuery($hDB,"SELECT * FROM ML_SubMenu where AttachMenuName = '" &$DbInfo4[$x4][3] &"' Order by ItemOrder")
					For $x5 = 0 to (UBound($DbInfo5) - 1) Step 1
						If $DbInfo5[$x5][4] = "I" Then
							$ICount = $ICount + 1
							$MenuItem[$ICount][0] = GUICtrlCreateMenuItem($DbInfo5[$x5][3],$SMenu3)
							$MenuItem[$ICount][1] = $DbInfo5[$x5][3]
							$MenuItem[0][0] = $ICount
						ElseIf $DbInfo5[$x5][4] = "M" Then

						EndIf
					Next
				Next
			Next
		Next
	Next

	GUISetState(@SW_SHOW)

	While 1
		Local $nMsg = GUIGetMsg()
		If $nMsg = $GUI_EVENT_CLOSE Then Exit
		If $nMsg > 0 Then
			For $cnt1 = 1 to $MenuItem[0][0] Step 1
				If $nMsg = $MenuItem[$cnt1][0] Then
					ConsoleWrite("_MFunc_" &StringReplace($MenuItem[$cnt1][1]," ","_") &Chr(13))
					Call("_MFunc_" &StringReplace($MenuItem[$cnt1][1]," ","_"))
				EndIf
			Next
		EndIf

		If $nMsg = $Button_Att_Username Then _MFunc_Attach_To("User")
		If $nMsg = $Button_Att_Domain Then _MFunc_Attach_To("User")
		If $nMsg = $Button_Att_SID Then _MFunc_Attach_To("User")
		If $nMsg = $Button_Att_Computer Then _MFunc_Attach_To("Computer")
		If $nMsg = $Button_KB Then _MFunc_Knowlegde_Base()
		If $nMsg = $Button_Goto_Home Then _OpenLocation("Home")
		If $nMsg = $Button_Goto_Profile Then _OpenLocation("Profile")
		If $nMsg = $Button_Goto_Group Then _OpenLocation("Group")
		If $nMsg = $Button_Att_RemoteAssist Then _MFunc_Remote_Assistant($AttachedComputer)
		If $nMsg = $Console_Input Then _CFunc_Command(GUICtrlRead($Console_Input))
		If $nMsg = $Console_Button Then _CFunc_Command(GUICtrlRead($Console_Input))

	WEnd
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Bugs_or_Features()

	Local $Form1 = GUICreate("Bugs or Features", 350, 199, -1, -1)
	Local $Group1 = GUICtrlCreateGroup("", 8, 0, 337, 193)
	Local $Label1 = GUICtrlCreateLabel("I would realy like to ", 16, 16, 97, 17)
	Local $Combo1 = GUICtrlCreateCombo("", 112, 16, 225, 25)
	GUICtrlSetData($Combo1,"report a bug in this application|request a feature for this application|tell you what I think of this application","report a bug in this application")
	Local $Edit1 = GUICtrlCreateEdit("", 16, 40, 321, 113)
	Local $Button_CloseAndExit = GUICtrlCreateButton("Close & Exit", 16, 160, 97, 25, $WS_GROUP)
	Local $Button_SaveAndClose = GUICtrlCreateButton("Save & Exit", 232, 160, 105, 25, $WS_GROUP)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUISetState(@SW_SHOW)


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			GUIDelete($Form1)
			Return
		Case $Button_SaveAndClose
			If GUICtrlRead($Edit1) <> "" Then
				Local $Message = GUICtrlRead($Edit1)
				If GUICtrlRead($Combo1) = "report a bug in this application" Then
					_DBExec($ReportDB,"INSERT INTO BUGS(UserName,Message) VALUES ('"&@LogonDomain &"_" &@UserName &"','"&$Message &"');")
				ElseIf GUICtrlRead($Combo1) =  "request a feature for this application" Then
					_DBExec($ReportDB,"INSERT INTO Requests(UserName,Message) VALUES ('"&@LogonDomain &"_" &@UserName &"','"&$Message &"');")
				ElseIf GUICtrlRead($Combo1) = "tell you what I think of this application" Then
					_DBExec($ReportDB,"INSERT INTO Comments(UserName,Message) VALUES ('"&@LogonDomain &"_" &@UserName &"','"&$Message &"');")
				EndIf
			EndIf
			GUIDelete($Form1)
			Return
		Case $Button_CloseAndExit
			GUIDelete($Form1)
			Return
	EndSwitch
WEnd

EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Network_1_Support_Server()
	Run(@SystemDir &"\mstsc.exe /v:Server1")
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Network_2_Support_Server()
	Run(@SystemDir &"\mstsc.exe /v:Server2")
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Network_3_Support_Server()
	Run(@SystemDir &"\mstsc.exe /v:Server3")
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Network_4_Support_Server()
	Run(@SystemDir &"\mstsc.exe /v:Server4")
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Network_5_Support_Server()
	Run(@SystemDir &"\mstsc.exe /v:Server5")
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Network_6_Support_Server()
	Run(@SystemDir &"\mstsc.exe /v:Server6")
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Convert_GG_Location_to_Path()
	If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
	$sInputBoxAnswer = InputBox("Convert GG_Location Group to its assigned Path","Please type the GG_Location you wish to convert.",""," ","-1","-1");,"-1","-1")
	Select
		Case @Error = 0 ;OK - The string returned is valid
			If $GGLocUpdate = 0 Then _GGLocationFinder()
			_Display("Conversion Completed" &Chr(13) &Chr(10) &Chr(13) &Chr(10) &_GGLocationFinder($sInputBoxAnswer))
		Case @Error = 1 ;The Cancel button was pushed
			Return
		Case @Error = 3 ;The InputBox failed to open
			Return
	EndSelect
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Path_to_Convert_GG_Location()
	If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
	$sInputBoxAnswer = InputBox("Convert Path to its assigned GG_Location Group","Please type the path you wish to convert.",""," ","-1","-1")
	Select
		Case @Error = 0 ;OK - The string returned is valid
			If $GGLocUpdate = 0 Then _GGLocationFinder()
			_Display("Conversion Completed" &Chr(13) &Chr(10) &Chr(13) &Chr(10) &_GGLocationFinder($sInputBoxAnswer,"Path"))
		Case @Error = 1 ;The Cancel button was pushed
			Return
		Case @Error = 3 ;The InputBox failed to open
			Return
	EndSelect
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Clean_Spooler()
	;++++++++++++++++++++++++++++++++++++
	;# 1 = Computer	|2 = User	|3 = Both
		If $AttachedStatus < 1 Then _MFunc_Attach_To("Computer")
		If $AttachedStatus < 1 Then Return
	;++++++++++++++++++++++++++++++++++++
	$CleanSPL = Run($UtilPath &"cleanspl.exe""",@TempDir)
	WinWaitActive("Clean Spooler")
	Send($AttachedComputer)
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Clear_Attach_To_Details()
	$AttachedUsername = ""
	$AttachedUserSID = ""
	$AttachedDomain = @LogonDomain
	$AttachedComputer = ""
	$AttachedStatus = 0
	$AttachedUserGroupDir = ""
	$AttachedUserHomeDir = ""
	$AttachedUserProDir = ""
	$AttachedComputerStatus = ""
	GUICtrlSetData($Display_AttachedUsername,$AttachedUsername)
	GUICtrlSetData($Display_AttachedUserSID,$AttachedUserSID)
	GUICtrlSetData($Display_AttachedDomain,$attachedDomain)
	GUICtrlSetData($Display_AttachedComputer,$AttachedComputer)
	GUICtrlSetData($Display_AttachedUserGroupPath,$AttachedUserGroupDir)
	GUICtrlSetData($Display_AttachedUserHomePath,$AttachedUserHomeDir)
	GUICtrlSetData($Display_AttachedUserProfilePath,$AttachedUserProDir)

	GUICtrlSetState($Button_Goto_Home,$GUI_DISABLE)
	GUICtrlSetState($Button_Goto_Profile,$GUI_DISABLE)
	GUICtrlSetState($Button_Goto_Group,$GUI_DISABLE)
	GUICtrlSetState($Button_Att_RemoteAssist,$GUI_HIDE)
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_List_User_Groups()
	_MFunc_Clear_Output_Window()
	If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
	$sInputBoxAnswer = InputBox("List User Groups","Please type a username in order to list its groups.",$AttachedUsername," M","200","135",_StartPos("X","300"),_StartPos("Y","200"))
	Select
		Case @Error = 0 ;OK - The string returned is valid
			Local $userG1[1000]
			Local $TmpStr1
			Local $strT3 = "USERNAME: " &$sInputBoxAnswer &chr(13) &chr(10) &"----------------------------------------------" &Chr(13) &Chr(10)
			_ADGetUserGroups($userG1,$sInputBoxAnswer)
			For $cnt9 = 1 to $userG1[0] Step 1
				$strT3 = $strT3 &_TrimADS($userG1[$cnt9]) &chr(13) &Chr(10)
			Next
			_Display($strT3)
		Case @Error = 1 ;The Cancel button was pushed
			Return
		Case @Error = 3 ;The InputBox failed to open
			Return
	EndSelect
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_UnLock_User_Option_TABS()
	;++++++++++++++++++++++++++++++++++++
	;# 1 = Computer	|2 = User	|3 = Both
		If $AttachedStatus < 3 Then _MFunc_Attach_To("Both")
		If $AttachedStatus < 3 Then Return
	;++++++++++++++++++++++++++++++++++++
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","Advanced","REG_DWORD","0")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","Autoconfig","REG_DWORD","0")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","CalendarContact","REG_DWORD","0")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","Certificates","REG_DWORD","0")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","Connection Settings","REG_DWORD","0")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","HomePage","REG_DWORD","0")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","Messaging","REG_DWORD","0")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","Profiles","REG_DWORD","0")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","Proxy","REG_DWORD","0")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","Ratings","REG_DWORD","0")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","Cache","REG_DWORD","0")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","Connwiz Admin Lock","REG_DWORD","0")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","ResetWebSettings","REG_DWORD","0")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","FormSuggest Passwords","REG_DWORD","0")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","AdvancedTab","REG_DWORD","0")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","ConnectionsTab","REG_DWORD","0")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","ContentTab","REG_DWORD","0")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","PrivacyTab","REG_DWORD","0")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","ProgramsTab","REG_DWORD","0")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","SecurityTab","REG_DWORD","0")
	_Display("IE Tabs Unlocked for User " &$AttachedUsername)
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Lock_User_Option_TABS()
	;++++++++++++++++++++++++++++++++++++
	;# 1 = Computer	|2 = User	|3 = Both
		If $AttachedStatus < 3 Then _MFunc_Attach_To("Both")
		If $AttachedStatus < 3 Then Return
	;++++++++++++++++++++++++++++++++++++
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","Advanced","REG_DWORD","1")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","Autoconfig","REG_DWORD","1")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","CalendarContact","REG_DWORD","1")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","Certificates","REG_DWORD","1")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","Connection Settings","REG_DWORD","1")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","HomePage","REG_DWORD","1")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","Messaging","REG_DWORD","1")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","Profiles","REG_DWORD","1")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","Proxy","REG_DWORD","1")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","Ratings","REG_DWORD","1")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","Cache","REG_DWORD","1")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","Connwiz Admin Lock","REG_DWORD","1")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","ResetWebSettings","REG_DWORD","1")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","FormSuggest Passwords","REG_DWORD","1")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","AdvancedTab","REG_DWORD","1")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","ConnectionsTab","REG_DWORD","1")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","ContentTab","REG_DWORD","1")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","PrivacyTab","REG_DWORD","1")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","ProgramsTab","REG_DWORD","1")
	RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Policies\Microsoft\Internet Explorer\Control Panel","SecurityTab","REG_DWORD","1")
	_Display("IE Tabs locked for User " &$AttachedUsername)
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _GGLocationFinder($LocSearchName = "",$LocSearchType = "GROUP")
	If $GGLocUpdate = 0 Then
		Local $LocFileLines = _FileCountLines("\\" &@LogonDNSDomain &"\SYSVOL\" &@LogonDNSDomain &"\scripts\LogonFiles\Static_User_Settings.ini")
		ReDim $GGLocRecords[$LocFileLines][2]
		For $x = 0 to $LocFileLines Step 1
			$RLine = FileReadLine("\\" &@LogonDNSDomain &"\SYSVOL\" &@LogonDNSDomain &"\scripts\LogonFiles\Static_User_Settings.ini",$x + 1)
			If $RLine <> "" Then
				$GGLocRecords[$x][0] = StringLeft($RLine,StringInStr($RLine,"	",0,1,1) - 1)
				$GGLocRecords[$x][1] = StringMid($RLine,StringInStr($RLine,"	",0,1,1) + 1,StringInStr($RLine,"	",0,2,1) - StringInStr($RLine,"	",0,1,1) - 1)
			EndIf
		Next
		_ArraySort($GGLocRecords, 0, 0, 0, 0)
		$GGLocUpdate = 1
	Else
		If StringUpper($LocSearchType) = "USER" Then
			Local $UserGroups
			If _ADObjectExists($LocSearchName) Then
				_ADGetUserGroups($UserGroups,$LocSearchName)
				$LocCount = 0
				For $x = 1 to $UserGroups[0] Step 1
					If StringInStr($UserGroups[$x],"GG_LOCATION_",0) Then
						$LocCount = $LocCount + 1
						If $LocCount > 1 Then
							Return "Multiple *GG_LOCATION GROUPS* detected"
						Else
							$LocSearchName = StringTrimLeft($UserGroups[$x],3)
							$LocSearchName = StringLeft($LocSearchName,StringInStr($LocSearchName,",") - 1)
						EndIf
					EndIf
				Next
			Else
				Return ""
			EndIf
		ElseIf StringUpper($LocSearchType) = "Path" Then
			For $x = 0 to (UBound($GGLocRecords) - 1) Step 1
				If StringInStr($GGLocRecords[$x][1],StringReplace($LocSearchName,@LogonDomain &"\",@LogonDNSDomain&"\"),0) Then Return $GGLocRecords[$x][0]
			Next
			Return "GG_Location Not Found"
		EndIf

		For $x = 0 to (UBound($GGLocRecords) - 1) Step 1
			If StringUpper($GGLocRecords[$x][0]) = StringUpper($LocSearchName) Then
				Return $GGLocRecords[$x][1]
				ExitLoop
			EndIf
		Next
		Return "Path Not Found For: "& StringUpper($LocSearchName)
	EndIf
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Remove_RESILIENCY_Key()
	;++++++++++++++++++++++++++++++++++++
	;# 1 = Computer	|2 = User	|3 = Both
		If $AttachedStatus < 3 Then _MFunc_Attach_To("Both")
		If $AttachedStatus < 3 Then Return
	;++++++++++++++++++++++++++++++++++++

	RegRead("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Microsoft\Office\11.0\Outlook\Resiliency","")
	If @error Then
		MsgBox(0,"INFORMATION","Unable to detect the RESILIENCY Key")
	Else
		RegDelete("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Microsoft\Office\11.0\Outlook\Resiliency")
		If @error Then
			MsgBox(0,"ERROR","RESILIENCY delete failed")
		Else
			MsgBox(0,"INFORMATION","RESILIENCY Key has been deleted.")
		EndIf
	EndIf
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Find_User_Groups_Differences()
	Local $userG1[1000], $userG2[1000]
	Local $strList = ""
	Local $strLast = ""
	Local $Form_CompareUserGroups = GUICreate("Compare User Goups", 239, 210, _StartPos("X",306), _StartPos("Y",156),$WS_SYSMENU,"",$Form_Main)
	Local $Group_CompareUserGroups = GUICtrlCreateGroup("Compare User Groups", 0, 0, 233, 185)
	Local $Label_CompareUserGroups_Username1 = GUICtrlCreateLabel("USERNAME 1:", 10, 20, 77, 20)
	Local $Input_CompareUserGroups_Username1 = GUICtrlCreateInput($AttachedUsername, 10, 40, 217, 20)
	Local $Label_CompareUserGroups_Username2 = GUICtrlCreateLabel("USERNAME 2:", 10, 88, 77, 20)
	Local $Input_CompareUserGroups_Username2 = GUICtrlCreateInput("", 10, 108, 217, 20)
	Local $Label_CompareUserGroups_Username1_Display = GUICtrlCreateLabel("", 88, 20, 140, 20)
	Local $Label_CompareUserGroups_Username2_Display = GUICtrlCreateLabel("", 88, 88, 140, 20)
	Local $Button_CompareUserGroups = GUICtrlCreateButton("Compare User Groups", 40, 152, 145, 25, $WS_GROUP)

	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUISetState(@SW_SHOW)

	Local $User1c = False
	Local $User2c = False

	If $AttachedUsername <> "" Then
		GUICtrlSetData($Label_CompareUserGroups_Username1_Display,_ADGetObjectAttribute($AttachedUsername,"displayname"))
		Local $User1 = GUICtrlRead($Input_CompareUserGroups_Username1)
		$User1c = True
	EndIf

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($Form_CompareUserGroups)
				Return
			Case $Input_CompareUserGroups_Username1
				Local $User1 = GUICtrlRead($Input_CompareUserGroups_Username1)
				$User1c = True
				If _ADObjectExists($User1) Then
					GUICtrlSetData($Label_CompareUserGroups_Username1_Display,_ADGetObjectAttribute($User1,"displayname"))
				Else
					GUICtrlSetData($Label_CompareUserGroups_Username1_Display,"ACCOUNT NOT FOUND")
				EndIf
			Case $Input_CompareUserGroups_Username2
				$User2 = GUICtrlRead($Input_CompareUserGroups_Username2)
				If _ADObjectExists($user2) Then
					Local $User2c = True
					GUICtrlSetData($Label_CompareUserGroups_Username2_Display,_ADGetObjectAttribute($User2,"displayname"))
				Else
					GUICtrlSetData($Label_CompareUserGroups_Username2_Display,"ACCOUNT NOT FOUND")
				EndIf
			Case $Button_CompareUserGroups
				If $User1c = True and $User2c = True Then
					GUIDelete($Form_CompareUserGroups)
					ExitLoop
				Else
					MsgBox(0,"ERROR","Unable to Proceed, Please check the entered account(s) details")
				EndIf
		EndSwitch
	WEnd

	_MFunc_Clear_Output_Window()
	_ADGetUserGroups($userG1,$User1)
	_ADGetUserGroups($userG2,$user2)

	$strT1 = ""
	$strT2 = ""
	$strOut = ""

	For $CNT9 = 1 to $userG1[0] Step 1
		$strT1 = $strT1 &"|" & _TrimADS($userG1[$cnt9])
	Next
	For $CNT9 = 1 to $userG2[0] Step 1
		$strT2 = $strT2 &"|" & _TrimADS($userG2[$cnt9])
	Next
	$strOut = "USERNAME1: " &$User1 &chr(13) &chr(10) &"------------------------------------------------------------------------" &chr(13) &chr(10)
	For $CNT9 = 1 to $userG1[0] Step 1
		$strTG = _TrimADS($userG1[$cnt9])
		If Not StringInStr($strT2,$strTG,0) Then
			$strOut = $strOut &$strTG &chr(13) &chr(10)
		EndIf
	Next
	$strOut = $strOut &chr(13) &chr(10) &chr(13) &chr(10) &"USERNAME2: " &$User2 &chr(13) &chr(10) &"------------------------------------------------------------------------" &chr(13) &chr(10)
	For $CNT9 = 1 to $userG2[0] Step 1
		$strTG = _TrimADS($userG2[$cnt9])
		If Not StringInStr($strT1,$strTG,0) Then
			$strOut = $strOut &$strTG &chr(13) &chr(10)
		EndIf
	Next
	_Display($strOut)
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Clear_Output_Window()
	GUICtrlSetData($DisplayInfo,"")
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Quit()
	Exit
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Active_Directory_Users_and_Computers($ConnDomain)
	Run(@ComSpec &" /c " &"dsa.msc /Domain=" &$ConnDomain,@SystemDir,@SW_HIDE)
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Account_Password_Tester()
	Local $Form_TestPass = GUICreate("Logon Test", 273, 188, _StartPos("x",270),_StartPos("y",125),$WS_SYSMENU,"",$Form_Main)
	Local $Label1 = GUICtrlCreateLabel("USERNAME:", 16, 16, 68, 17)
	Local $Input_User = GUICtrlCreateInput($AttachedUsername, 120, 16, 129, 21)
	Local $Label2 = GUICtrlCreateLabel("PASSWORD:", 16, 48, 70, 17)
	Local $Input_Pass = GUICtrlCreateInput("", 120, 48, 129, 21,0x0020)
	Local $Label3 = GUICtrlCreateLabel("DOMAIN", 16, 80, 55, 17)
	Local $Input_Domain = GUICtrlCreateInput(@LogonDomain, 120, 80, 129, 21)
	Local $Button1 = GUICtrlCreateButton("Test Logon Details", 80, 120, 113, 25, 0)
	GUISetState(@SW_SHOW)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($Form_TestPass)
				_MFunc_Clear_Output_Window()
				Return
			Case $Button1
				TestLogon(GUICtrlRead($Input_User),GUICtrlRead($Input_Domain),GUICtrlRead($Input_Pass))
		EndSwitch
	WEnd
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Logon_Server()
	Local $Form_LogonServer = GUICreate("Logon Server Check", 263, 130, _StartPos("x",270), _StartPos("y",175),$WS_SYSMENU,"",$Form_Main)
	Local $Label1 = GUICtrlCreateLabel("Name or IP address", 8, 16, 105, 17)
	Local $Input_Servername = GUICtrlCreateInput($AttachedComputer, 120, 16, 129, 21)
	Local $Input_LogonDomain = GUICtrlCreateInput(@LogonDomain, 120, 40, 129, 21)
	Local $Label2 = GUICtrlCreateLabel("Domain Name", 8, 40, 71, 17)
	Local $Button_LogonServerCheck = GUICtrlCreateButton("Check", 80, 68, 97, 25, 0)
	GUISetState(@SW_SHOW)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($Form_LogonServer)
				Return
			Case $Button_LogonServerCheck
				If Ping(GUICtrlRead($Input_Servername),1500) Then
					ExitLoop
				Else
					MsgBox(0,"Information - Ping failed.","Unable to contact the server. Please confirm the name entered.")
				EndIf
		EndSwitch
	WEnd

	Local $foo = Run(@ComSpec & " /c " &$UtilPath &"NLTEST.EXE""" &" /DSGETDC:" &GUICtrlRead($Input_LogonDomain) &" /server:" &GUICtrlRead($Input_Servername), @SystemDir, @SW_HIDE, 2)

	Local $line
	Local $DCLFile = FileGetShortName(@TempDir &"\DCL" &Random(10000,90000) &".txt")
	GUIDelete($Form_LogonServer)
	While 1
		$line = StdoutRead($foo)
		If @error Then
			ExitLoop
		Else
			If StringInStr($line,"DC:") Then
				FileWrite($DCLFile,$line)
			EndIf
		EndIf
	Wend
	Local $Lpost = ""

	If FileExists($DCLFile) Then
		For $cnt8 = 1 to _FileCountLines($DCLFile) Step 1
			$Lpost = $Lpost &StringStripWS(FileReadLine($DCLFile,$cnt8),1) &Chr(13) &Chr(10)
		Next
		_Display("LogonServer Information" &Chr(13) &Chr(10) &Chr(13) &Chr(10) &$Lpost)
		FileDelete($DCLFile)
	EndIf
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Convert_Path_to_Length()
	If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
	$sInputBoxAnswer = InputBox("Convert Path to Length","Please type the Path you wish to convert.",""," ","-1","-1");,"-1","-1")
	Select
		Case @Error = 0 ;OK - The string returned is valid
			_Display("Conversion Completed" &Chr(13) &Chr(10) &Chr(13) &Chr(10) &"The String contained "&StringLen($sInputBoxAnswer) &" characters")
		Case @Error = 1 ;The Cancel button was pushed
			Return
		Case @Error = 3 ;The InputBox failed to open
			Return
	EndSelect
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_User_Account_lockout_Checker()
	;++++++++++++++++++++++++++++++++++++
	;# 1 = Computer	|2 = User	|3 = Both
		If $AttachedStatus < 2 Then _MFunc_Attach_To("User")
		If $AttachedStatus < 2 Then Return
	;++++++++++++++++++++++++++++++++++++
	Run($UtilPath &"logoutstatus.exe""" &" -u:" &$attachedDomain &"\" &$AttachedUsername)
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Convert_Name_to_SID()
	If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
	$sInputBoxAnswer = InputBox("Convert Name to SID","Please type the name you wish to convert.",""," ","-1","-1")
	Select
		Case @Error = 0 ;OK - The string returned is valid
			_Display("Conversion completed" &chr(13) &chr(10) &chr(13) &chr(10) &GetSidbyUser($sInputBoxAnswer))
		Case @Error = 1 ;The Cancel button was pushed
			Return
		Case @Error = 3 ;The InputBox failed to open
			Return
	EndSelect
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Redirect_My_Documents()
	Local $LMDRPath
	;++++++++++++++++++++++++++++++++++++
	;# 1 = Computer	|2 = User	|3 = Both
		If $AttachedStatus < 3 Then _MFunc_Attach_To("")
		If $AttachedStatus < 3 Then Return
	;++++++++++++++++++++++++++++++++++++
	$LMDRPath = RegRead("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders","Personal")
	if @error Then
		MsgBox(0,"Error","Unable to detect the current My Documents path")
	Else
		$ADHPath = _ADGetObjectAttribute($AttachedUsername,"homedirectory")
		If $ADHPath = "0" or $ADHPath = "" Then
			MsgBox(0,"ERROR","AD home directory path not found.")
			Return
		Else

			$Form_Menu_Sub_Attached_Fixes_RedirectMyDocs = GUICreate("My Documents Redirect Fix", 655, 180, _StartPos("x",93), _StartPos("y",125),$WS_SYSMENU,"",$Form_Main)
			$Button_Yes = GUICtrlCreateButton("YES", 184, 120, 121, 25, 0)
			$Button_No = GUICtrlCreateButton("NO", 320, 120, 121, 25, 0)
			$Input_Current = GUICtrlCreateInput($LMDRPath, 24, 30, 609, 21,0x0800)
			$Label2 = GUICtrlCreateLabel("To:", 24, 64, 20, 17)
			$Input_New = GUICtrlCreateInput($ADHPath, 24, 80, 609, 21)
			$Group1 = GUICtrlCreateGroup("Change the My Documents path from:", 16, 8, 625, 105)

			GUICtrlCreateGroup("", -99, -99, 1, 1)
			GUISetState(@SW_SHOW)

			While 1
				$nMsg = GUIGetMsg()
				Switch $nMsg
					Case $GUI_EVENT_CLOSE
						Exit
					Case $Button_No
						GUIDelete($Form_Menu_Sub_Attached_Fixes_RedirectMyDocs)
						Return
					Case $Button_Yes
						RegWrite("\\" &$AttachedComputer &"\HKU\" &$AttachedUserSID &"\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders","Personal","REG_EXPAND_SZ",GUICtrlRead($Input_New))
						if @error Then
							MsgBox(0,"Error","Registry Update failed")
						Else

							MsgBox(0,"INFORMATION","Successfully Updated")
							GUIDelete($Form_Menu_Sub_Attached_Fixes_RedirectMyDocs)
							Return
						EndIf
				EndSwitch
			WEnd
		EndIf
	EndIf
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Launch_Remote_CMD()
	If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
	$sInputBoxAnswer = InputBox("Launch Remote CMD","Please type a PC name in order to execute a remote command prompt.",$AttachedComputer," M","200","135",_StartPos("X","300"),_StartPos("Y","200"))
	Select
		Case @Error = 0 ;OK - The string returned is valid
			Run($UtilPath &"psexec.exe""" &" \\" &$sInputBoxAnswer &" cmd.exe",@SystemDir)
		Case @Error = 1 ;The Cancel button was pushed
			Return
		Case @Error = 3 ;The InputBox failed to open
			Return
	EndSelect
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Trim_Context_In_Tray_Timeout_Fix()
	;++++++++++++++++++++++++++++++++++++
	;# 1 = Computer	|2 = User	|3 = Both
		If $AttachedStatus < 3 Then _MFunc_Attach_To("")
		If $AttachedStatus < 3 Then Return
	;++++++++++++++++++++++++++++++++++++
	RegWrite("\\" &$AttachedComputer &"\HKU\" &$AttachedUserSID &"\Software\TOWER Software\TRIM5\List Pane","EditDocumentSearch","REG_DWORD","1")
	MsgBox(0,"INFORMATION","Trim Context Timeout - In Tray - Fix Applied")
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Remote_Desktop()
	Run("mstsc.exe",@SystemDir)
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Remote_Assistant($ConnectTo = "")
	If $ConnectTo = "" Then
		$remoteAssist = _IECreate("hcp://CN=Microsoft%20Corporation,L=Redmond,S=Washington,C=US/Remote%20Assistance/Escalation/Unsolicited/Unsolicitedrcui.htm",0,1,0,1)
	Else
		$remoteAssist = _IECreate("hcp://CN=Microsoft%20Corporation,L=Redmond,S=Washington,C=US/Remote%20Assistance/Escalation/Unsolicited/Unsolicitedrcui.htm",0,1,0,1)
		Sleep(2000)
		If WinExists("Help and Support Center") Then
			WinActivate("Help and Support Center")
			Send($ConnectTo,1)
			Send("!c",0)
		EndIf

	EndIf
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Runas_Windows_Explorer()
	Local $Form_RunAsExplorer = GUICreate("Runas Windows Exporer", 273, 188, _StartPos("x",270),_StartPos("y",125),$WS_SYSMENU,"",$Form_Main)
	Local $Label1 = GUICtrlCreateLabel("USERNAME:", 16, 16, 68, 17)
	Local $Input_User = GUICtrlCreateInput("", 120, 16, 129, 21)
	Local $Label2 = GUICtrlCreateLabel("PASSWORD:", 16, 48, 70, 17)
	Local $Input_Pass = GUICtrlCreateInput("", 120, 48, 129, 21,0x0020)
	Local $Label3 = GUICtrlCreateLabel("DOMAIN", 16, 80, 55, 17)
	Local $Input_Domain = GUICtrlCreateInput(@LogonDomain, 120, 80, 129, 21)
	Local $Button1 = GUICtrlCreateButton("RunAs Explorer", 80, 120, 113, 25, 0)
	GUISetState(@SW_SHOW)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($Form_RunAsExplorer)
				Return
			Case $Button1
				$RunAsExplorerReg = RunAsWait(GUICtrlRead($Input_User),GUICtrlRead($Input_Domain),GUICtrlRead($Input_Pass),1,"reg ADD HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v SeparateProcess /t REG_DWORD /d 1 /f",@WindowsDir,@SW_HIDE)
				If @error Then
					MsgBox(0,"Error","RunAs Explorer Failed")
				Else
					RunAs(GUICtrlRead($Input_User),GUICtrlRead($Input_Domain),GUICtrlRead($Input_Pass),1,"Explorer",@WindowsDir)
					GUIDelete($Form_RunAsExplorer)
					Return
				EndIf
		EndSwitch
	WEnd
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_About()
	MsgBox(64,"About: Central Support Center - "&$Version,"The Central Support Center was created in order to" & @CRLF & "support the Microsoft Windows Domains estate more effectivly.")
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Find_General_Information()
	;++++++++++++++++++++++++++++++++++++
	;# 1 = Computer	|2 = User	|3 = Both
		If $AttachedStatus < 1 Then _MFunc_Attach_To("Computer")
		If $AttachedStatus < 1 Then Return
	;++++++++++++++++++++++++++++++++++++
		$InfoFile = "T" &Random(11111,99999,1) &".txt"
		$AddtoDisplay = ""
		_MFunc_Clear_Output_Window()
		RunWait(@ComSpec &" /c " &$UtilPath &"Psinfo.exe""" &" \\" &$AttachedComputer &" >" &@TempDir &"\" &$InfoFile,@SystemDir,@SW_HIDE)
		For $Cnt4 = 1 to _FileCountLines(@TempDir &"\" &$InfoFile) Step 1
			If $Cnt4 = 1 Then
				$AddtoDisplay = $AddtoDisplay & FileReadLine(@TempDir &"\" &$InfoFile,$Cnt4) &chr(13) &chr(10) &chr(13) &chr(10)
			Else
				$AddtoDisplay = $AddtoDisplay & FileReadLine(@TempDir &"\" &$InfoFile,$Cnt4) &chr(13) &chr(10)
			EndIf
		Next
		_Display($AddtoDisplay)
		FileDelete(@TempDir &"\" &$InfoFile)
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_CONVERT_Sid_To_Name()
	If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
	$sInputBoxAnswer = InputBox("Convert SID to Name","Please type the SID you wish to convert.",""," ","-1","-1");,"-1","-1")
	Select
		Case @Error = 0 ;OK - The string returned is valid
			_Display("Conversion Completed" &Chr(13) &Chr(10) &Chr(13) &Chr(10) &GetUserbySid($sInputBoxAnswer))
		Case @Error = 1 ;The Cancel button was pushed
			Return
		Case @Error = 3 ;The InputBox failed to open
			Return
	EndSelect
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Knowlegde_Base()
	Local $KB = _IECreate($KnowledgeBaseAddress,0,1,0)
	Sleep(1000)
	WinActivate($KnowledgeBaseAddress)
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_TRIM_Settings_Editor()
	;++++++++++++++++++++++++++++++++++++
	;# 1 = Computer	|2 = User	|3 = Both
		If $AttachedStatus < 3 Then _MFunc_Attach_To("Both")
		If $AttachedStatus < 3 Then Return
	;++++++++++++++++++++++++++++++++++++

	$Form_TrimEdit = GuiCreate("Remote Trim Information", 254, 260,_StartPos("X",300),_StartPos("Y",180),$WS_SYSMENU,"",$Form_Main)
	$Group_TrimInformation = GuiCtrlCreateGroup("Trim Information", 10, 5, 230, 220)
	$BC_dataloc = GUICtrlCreateButton("Data Location:", 20, 30, 115, 20)
	$Label_DataLocation = GuiCtrlCreateLabel("", 140, 32, 90, 20)
	$BC_WGS = GUICtrlCreateButton("Workgroup Server:", 20, 50, 115, 20)
	$Label_WorkgroupServer = GuiCtrlCreateLabel("", 140, 52, 90, 20)
	$BC_TV = GUICtrlCreateButton("Installed Trim Version:", 20, 70, 115, 20)
	$Label_TrimVersion = GuiCtrlCreateLabel("", 140, 72, 90, 20)
	$BC_CDS = GUICtrlCreateButton("Current Dataset:", 20, 90, 115, 20)
	$Label_CurrentDataset = GuiCtrlCreateLabel("", 140, 92, 90, 20)
	$BC_OMDA = GUICtrlCreateButton("OMDA Active:", 20, 110, 115, 20)
	$Label_OdmaActive = GuiCtrlCreateLabel("", 140, 112, 90, 20)
	$BC_ODMADWT = GUICtrlCreateButton("ODMA Direct with Trim:", 20, 130, 115, 20)
	$Label_OdmaDirectWithTrim = GuiCtrlCreateLabel("", 140, 132, 90, 20)
	$BC_ST = GUICtrlCreateButton("Suppress Topdrawer:", 20, 150, 115, 20)
	$Label_SuppressTopdrawer = GuiCtrlCreateLabel("", 140, 152, 90, 20)
	$BC_ALS = GUICtrlCreateButton("Allow Local Save:", 20, 170, 115, 20)
	$Label_AllowLocalSave = GuiCtrlCreateLabel("", 140, 172, 90, 20)
	$BC_TR5Ass = GUICtrlCreateButton("Tr5 Files association:", 20, 190, 115, 20)
	$Label_Tr5FilesAssWith = GuiCtrlCreateLabel("", 140, 192, 90, 20)

	GuiSetState()

		GUICtrlSetState($BC_TV,$GUI_DISABLE)

		$inf_trimver = FileGetVersion(FileGetShortName("\\" &$AttachedComputer &"\c$\Program Files\Tower Software\TRIM Context 5.2.4\trim.exe"))
		$inf_DL = RegRead("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\TOWER Software\TRIM5\DataPaths","TopDrawerDataPath")
		$inf_WS = RegRead("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\TOWER Software\TRIM5\WorkgroupServer\Remote","Mainserver")
		$inf_DS = RegRead("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\TOWER Software\TRIM5\WorkgroupServer\Remote","DefaultDB")
		$inf_ODMA = RegRead("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\TOWER Software\TRIM5\Integration","ODMA")
		If $inf_ODMA = 1 Then
			$inf_ODMA = "Yes"
		Else
			$inf_ODMA = "No"
		EndIf
		$inf_ODMA_D = RegRead("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\TOWER Software\TRIM5\Integration","TRIMDirect")
		If $inf_ODMA_D = 1 Then
			$inf_ODMA_D = "Yes"
		Else
			$inf_ODMA_D = "No"
		EndIf
		$inf_ST = RegRead("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\TOWER Software\TRIM5\Integration","HideTopDrawer")
		If $inf_ST = 1 Then
			$inf_ST = "Yes"
		Else
			$inf_ST = "No"
		EndIf
		$inf_ALS = RegRead("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\TOWER Software\TRIM5\Integration","DropBackToLocal")
		If $inf_ALS = 1 Then
			$inf_ALS = "Yes"
		Else
			$inf_ALS = "No"
		EndIf


		$inf_tr5 = RegRead("\\" &$AttachedComputer &"\HKEY_LOCAL_MACHINE\SOFTWARE\Classes\TRIM5.Record.Reference\Shell\Open\command","")

		If StringInStr($inf_tr5,"TRIM.exe",0) <> 0 Then $inf_tr5 = "Trim Context"
		If StringInStr($inf_tr5,"trimdesktop.exe",0) <> 0 Then $inf_tr5 = "Trim Desktop"
		If StringInStr($inf_tr5,"tdrawer.exe",0) <> 0 Then $inf_tr5 = "Trim TopDrawer"

		GUICtrlSetData($Label_TrimVersion,$inf_trimver)
		GUICtrlSetData($Label_DataLocation,$inf_DL)
		GUICtrlSetData($Label_WorkgroupServer,$inf_WS)
		GUICtrlSetData($Label_CurrentDataset,$inf_DS)
		GUICtrlSetData($Label_OdmaActive,$inf_ODMA)
		GUICtrlSetData($Label_OdmaDirectWithTrim,$inf_ODMA_D)
		GUICtrlSetData($Label_SuppressTopdrawer,$inf_ST)
		GUICtrlSetData($Label_AllowLocalSave,$inf_ALS)
		GUICtrlSetData($Label_Tr5FilesAssWith,$inf_tr5)

While 1
	$msg2 = GuiGetMsg()
	Select
		Case $msg2 = $GUI_EVENT_CLOSE
			GUIDelete($Form_TrimEdit)
			Return

		Case $msg2 = $BC_dataloc
			RegWrite("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Software\TOWER Software\TRIM5\DataPaths","TopDrawerDataPath","REG_SZ",TInput(GUICtrlRead($Label_DataLocation),"Trim Top Drawer Location?"))
		Case $msg2 = $BC_WGS

		Case $msg2 = $BC_CDS

		Case $msg2 = $BC_OMDA

		Case $msg2 = $BC_ODMADWT

		Case $msg2 = $BC_ST

		Case $msg2 = $BC_ALS

		Case $msg2 = $BC_TR5Ass

	EndSelect
WEnd

EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Local_Settings()
	$Form_LSettings = GUICreate("Local Settings", 637, 430,_StartPos("x",100),_StartPos("y",60),$WS_SYSMENU,"",$Form_Main)
	$Group1_LSettings = GUICtrlCreateGroup("Catagory", 8, 0, 169, 393)
	$List1_LSettings = GUICtrlCreateList("", 16, 24, 153, 357)
	$Button_LSettings_Close = GUICtrlCreateButton("Close", 184, 368, 153, 25, 0)
	$Group2_LSettings = GUICtrlCreateGroup("Availavle Settings", 184, 0, 441, 361)
	$Listview1_LSettings = GUICtrlCreateListView("Setting       |Value                             ", 192, 24, 425, 318,0x0004)
	$Button_LSettings_mofidy = GUICtrlCreateButton("Modify", 344, 368, 121, 25, 0)
	$Button_LSettings_Accept = GUICtrlCreateButton("Accept Changes", 472, 368, 153, 25, 0)
	GUISetState(@SW_SHOW)
	GUICtrlSetData($List1_LSettings,"Unicentre ServicePlus Service Desk","")

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($Form_LSettings)
				Return
			Case $Button_LSettings_Close
				GUIDelete($Form_LSettings)
				Return
			Case $Button_LSettings_mofidy
				If GUICtrlRead($List1_LSettings) = "Unicentre ServicePlus Service Desk" Then
					;MsgBox(0,"",GUICtrlRead($Listview1_LSettings))
					;MsgBox(0,"Password",_StringEncrypt(0,RegRead("HKEY_CURRENT_USER\Software\EASYLOGIN","password"),"USDLogin","1"))
				EndIf
			Case $Button_LSettings_Accept

			Case $List1_LSettings
				ScanOptions(GUICtrlRead($List1_LSettings),$Listview1_LSettings,"1")
		EndSwitch
	WEnd

EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Find_Desktop_Location()
	;++++++++++++++++++++++++++++++++++++
	;# 1 = Computer	|2 = User	|3 = Both
	If $AttachedStatus < 1 Then _MFunc_Attach_To("Computer")
	If $AttachedStatus < 1 Then Return
	;++++++++++++++++++++++++++++++++++++

	$Location = LocationByIP($AttachedComputer)
	_Display("Location for "&$AttachedComputer &" as obtained from IP Address:" &Chr(13) &Chr(10) &Chr(13) &Chr(10) &$Location )
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_List_user_Mapped_Drives()
	;++++++++++++++++++++++++++++++++++++
	;# 1 = Computer	|2 = User	|3 = Both
		If $AttachedStatus < 3 Then _MFunc_Attach_To("Both")
		If $AttachedStatus < 3 Then Return
	;++++++++++++++++++++++++++++++++++++
	$AString = "Mapped Drives for " &$AttachedUsername &chr(13) &chr(10) &chr(13) &Chr(10)
;	Local $DriveL, $TSCount

	For $CNT12 = 1 to 20 step 1
		$DriveL = RegEnumKey("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Network\",$CNT12)
		If @error Then ExitLoop
		$AString = $AString & $DriveL &": " &RegRead("\\" &$AttachedComputer &"\HKEY_USERS\" &$AttachedUserSID &"\Network\"&$DriveL,"RemotePath") &chr(13) &Chr(10)
	Next

	_Display($AString)
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Format_Offline_Database()
	;++++++++++++++++++++++++++++++++++++
	;# 1 = Computer	|2 = User	|3 = Both
		If $AttachedStatus < 1 Then _MFunc_Attach_To("Computer")
		If $AttachedStatus < 1 Then Return
	;++++++++++++++++++++++++++++++++++++
	If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(276,"Format Offline Database","Are you sure you want to format the offline database for this user?")
	Select
		Case $iMsgBoxAnswer = 6
			RegWrite("\\" &$AttachedComputer &"\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\NetCache","FormatDatabase","REG_DWORD","1")
			MsgBox(0,"Information","Format Database Key has been added. User needs to be restarted.")
		Case $iMsgBoxAnswer = 7
			Return
	EndSelect
EndFunc
;=-=-=-=-=-=
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Outlook_Set_full_dumpster_locally()
	Local $check = RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Exchange\Client\Options","DumpsterAlwaysOn","REG_DWORD","1")
	If $check = 1 Then
		MsgBox(0,"DumpsterAlwaysOn","Dumpster key has been added. Please restart your outlook.")
	EndIf
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Locate_user_PST_Files()
	Local $PST_RegPath
	Local $Form_PST_File_Locations = GUICreate("PST File Locations", 285, 222, _StartPos("x",260), _StartPos("y",125),$WS_SYSMENU,"",$Form_Main)
	Local $Button_PST_FIND = GUICtrlCreateButton("FIND PST FILES", 104, 160, 89, 25, 0)
	Local $Radio_PST_FL1 = GUICtrlCreateRadio("", 8, 32, 9, 20)
	Local $Radio_PST_FL2 = GUICtrlCreateRadio("", 8, 96, 9, 20)
	Local $Group_PST_SearchByAttached = GUICtrlCreateGroup("Search By Attached Details", 30, 5, 233, 65)
	Local $Label_PST_UserNameD = GUICtrlCreateLabel("Username:", 40, 25, 60, 20)
	Local $Label_PST_PCNameD = GUICtrlCreateLabel("Pc Name:", 40, 45, 60, 20)
	Local $Label_PST_UserName = GUICtrlCreateLabel($AttachedUsername, 100, 25, 150, 20)
	Local $Label_PST_PCName = GUICtrlCreateLabel($AttachedComputer, 100, 45, 150, 20)
	Local $Group_PST_SearchByBrowse = GUICtrlCreateGroup("Search By NTUSER.DAT", 24, 80, 233, 73)
	Local $Input_PST_NTUSER_Path = GUICtrlCreateInput("", 40, 105, 209, 21,0x0800)
	Local $Button_PST_Browse = GUICtrlCreateButton("Browse", 104, 130, 81, 17, 0,0x0800)
	GUISetState(@SW_SHOW)

	If $AttachedUsername = "" Or $AttachedComputer = "" Then
		GUICtrlSetState($Radio_PST_FL2, $GUI_CHECKED)
		GUICtrlSetState($Radio_PST_FL1, $GUI_DISABLE)
	Else
		GUICtrlSetState($Radio_PST_FL1, $GUI_CHECKED)
		GUICtrlSetState($Button_PST_Browse, $GUI_DISABLE)
	EndIf


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			GUIDelete($Form_PST_File_Locations)
			Return
		Case $Button_PST_Browse
			GUICtrlSetData($Input_PST_NTUSER_Path,FileOpenDialog("NTUser.dat Location","My Documents","NTUser.dat (*.Dat)",1))
		Case $Radio_PST_FL1
			GUICtrlSetState($Button_PST_Browse, $GUI_DISABLE)
		Case $Radio_PST_FL2
			GUICtrlSetState($Button_PST_Browse, $GUI_ENABLE)
		Case $Button_PST_FIND
			;-----------------------------------------------------------------------------------
			If GUICtrlRead($Radio_PST_FL1) = "1" Then
				$PST_RegPath = "\\"&$AttachedComputer &"\HKU\" &$AttachedUserSID &"\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles\"
				GUIDelete($Form_PST_File_Locations)
				Scanpst($PST_RegPath)
				Return
			ElseIf GUICtrlRead($Radio_PST_FL2) = "1" Then
				$NTUpath = FileGetShortName(GUICtrlRead($Input_PST_NTUSER_Path))
				If $NTUpath = "" Then
					MsgBox(0,"ERROR","NTUser.Dat Path required")
				Else
					$PRand = Random(1000,9999,1)
					$RegMount = ShellExecuteWait("Reg.exe","Load HKU\Temp" &$PRand &" "&$NTUpath,@SystemDir,"open",@SW_HIDE)
					If $RegMount = "0" Then
						$PST_RegPath = "HKU\Temp" &$PRand &"\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles\"
						GUIDelete($Form_PST_File_Locations)
						Scanpst($PST_RegPath)
						Sleep(1000)
						$RegUnMount = ShellExecuteWait("Reg.exe","UnLoad HKU\Temp" &$PRand &" "&$NTUpath,@SystemDir,"open",@SW_HIDE)
						RunWait(@SystemDir &"\reg.exe UnLoad HKU\Temp"&$PRand,"",@SW_MINIMIZE)
						Return
					Else
						MsgBox(0,"ERROR","It Seems this specified NTuser.Dat file has been mounted before. To Clear the mount Either restart your pc or select the help menu and run registry cleanup.")
					EndIf
				EndIf
			EndIf
			;-----------------------------------------------------------------------------------
	EndSwitch
WEnd
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Logged_on_PCs_by_Users()

	$Form_Bulk_LoggedOnPCsByUsers = GUICreate("Logged on PCs by Users", 216, 370,_StartPos("x",280), _StartPos("y",100),$WS_SYSMENU,"",$Form_Main)
	$Group_Bulk_LoggedOnPCsByUsers = GUICtrlCreateGroup("Information Gatherer", 16, 8, 185, 289)
	$Label_Bulk_LoggedOnPCsByUsers_1 = GUICtrlCreateLabel("Please paste the list of usernames you want to work with:", 24, 32, 175, 40)
	$Edit_Bulk_LoggedOnPCsByUsers_1 = GUICtrlCreateEdit("", 24, 70, 169, 210)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$Button_Bulk_LoggedOnPCsByUsers_ok = GUICtrlCreateButton("OK", 56, 312, 89, 17, $WS_GROUP)
	GUISetState(@SW_SHOW)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($Form_Bulk_LoggedOnPCsByUsers)
				Return
			Case $Button_Bulk_LoggedOnPCsByUsers_ok
				If _GUICtrlEdit_GetLine($Edit_Bulk_LoggedOnPCsByUsers_1, 0) = ""  Then
					GUIDelete($Form_Bulk_LoggedOnPCsByUsers)
					MsgBox(0,"ERROR","NO TEXT DETECTED")
					Return
				Else
					Local $bulkUserList[_GUICtrlEdit_GetLineCount($Edit_Bulk_LoggedOnPCsByUsers_1) + 1]
					For $Cnt11 = 1 to _GUICtrlEdit_GetLineCount($Edit_Bulk_LoggedOnPCsByUsers_1) Step 1
						$bulkUserList[$Cnt11] = _GUICtrlEdit_GetLine($Edit_Bulk_LoggedOnPCsByUsers_1, $Cnt11 - 1)
						$bulkUserList[0] = $Cnt11
					Next
					GUIDelete($Form_Bulk_LoggedOnPCsByUsers)
					Local $BulkString
					$BulkString = "BULK INFORMATION -> Logged on PCs by Users" &chr(13) &chr(10) &chr(13) &chr(10)
					ProcessBar("","Create")
					For $Cnt11 = 1 to $bulkUserList[0] Step 1
						ProcessBar(55,"Update")
						$BulkString = $BulkString & $bulkUserList[$cnt11] &": " & StringTrimRight(GetPcByUser($bulkUserList[$Cnt11],"BULK"),1) &chr(13) &chr(10)
					Next
					ProcessBar("","Close")
						_Display($BulkString)
					Return
				EndIf
		EndSwitch
	WEnd
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Locations_of_PCs_by_Name_or_IP()
	$Form_Bulk_LocationOfPCsByName = GUICreate("Locations of PCs by Name or IP", 216, 370,_StartPos("x",280), _StartPos("y",100),$WS_SYSMENU,"",$Form_Main)
	$Group_Bulk_LocationOfPCsByName = GUICtrlCreateGroup("Information Gatherer", 16, 8, 185, 289)
	$Label_Bulk_LocationOfPCsByName_1 = GUICtrlCreateLabel("Please paste the list of Computer names you want to work with:", 24, 32, 175, 40)
	$Edit_Bulk_LocationOfPCsByName_1 = GUICtrlCreateEdit("", 24, 70, 169, 210)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$Button_Bulk_LocationOfPCsByName_ok = GUICtrlCreateButton("OK", 56, 312, 89, 17, $WS_GROUP)
	GUISetState(@SW_SHOW)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($Form_Bulk_LocationOfPCsByName)
				Return
			Case $Button_Bulk_LocationOfPCsByName_ok
				If _GUICtrlEdit_GetLine($Edit_Bulk_LocationOfPCsByName_1, 0) = ""  Then
					GUIDelete($Form_Bulk_LocationOfPCsByName)
					MsgBox(0,"ERROR","NO TEXT DETECTED")
					Return
				Else
					Local $bulkUserList[_GUICtrlEdit_GetLineCount($Edit_Bulk_LocationOfPCsByName_1) + 1]
					For $Cnt11 = 1 to _GUICtrlEdit_GetLineCount($Edit_Bulk_LocationOfPCsByName_1) Step 1
						$bulkUserList[$Cnt11] = _GUICtrlEdit_GetLine($Edit_Bulk_LocationOfPCsByName_1, $Cnt11 - 1)
						$bulkUserList[0] = $Cnt11
					Next
					GUIDelete($Form_Bulk_LocationOfPCsByName)
					Local $BulkString
					$BulkString = "BULK INFORMATION -> Locations of PCs by Name or IP" &chr(13) &chr(10) &chr(13) &chr(10)
					ProcessBar("","Create")
					For $Cnt11 = 1 to $bulkUserList[0] Step 1
						ProcessBar(55,"Update")
						$BulkString = $BulkString & $bulkUserList[$cnt11] &": " & LocationByIP($bulkUserList[$Cnt11]) &chr(13) &chr(10)
					Next
					ProcessBar("","Close")
						_Display($BulkString)
					Return
				EndIf
		EndSwitch
	WEnd
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_CSC_Quit()
	_SQLite_Shutdown()
	Exit
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Remotely_Lock_Workstation()
	If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
	$sInputBoxAnswer = InputBox("Remotely Lock Workstation","Please type a PC name in order to Remotely Lock Workstation.",$AttachedComputer," M","200","135",_StartPos("X","300"),_StartPos("Y","200"))
	Select
		Case @Error = 0 ;OK - The string returned is valid
			Run($UtilPath &"psexec.exe""" &" \\" &$sInputBoxAnswer &" rundll32.exe user32.dll,LockWorkStation",@SystemDir)
		Case @Error = 1 ;The Cancel button was pushed
			Return
		Case @Error = 3 ;The InputBox failed to open
			Return
	EndSelect
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Check_Valid_AD_Computer()

	$Form_Bulk_CheckValidAdAccount = GUICreate("Check valid AD account exists", 216, 370,_StartPos("x",280), _StartPos("y",100),$WS_SYSMENU,"",$Form_Main)
	$Group_Bulk_CheckValidAdAccount = GUICtrlCreateGroup("Information Gatherer", 16, 8, 185, 289)
	$Label_Bulk_CheckValidAdAccount_1 = GUICtrlCreateLabel("Please paste the list of Computers you want to work with:", 24, 32, 175, 40)
	$Edit_Bulk_CheckValidAdAccount_1 = GUICtrlCreateEdit("", 24, 70, 169, 210)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$Button_Bulk_CheckValidAdAccount_ok = GUICtrlCreateButton("OK", 56, 312, 89, 17, $WS_GROUP)
	GUISetState(@SW_SHOW)
	Sleep(3000)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($Form_Bulk_CheckValidAdAccount)
				Return

			Case $Button_Bulk_CheckValidAdAccount_ok
				If _GUICtrlEdit_GetLine($Edit_Bulk_CheckValidAdAccount_1, 0) = ""  Then
					GUIDelete($Form_Bulk_CheckValidAdAccount)
					MsgBox(0,"ERROR","NO TEXT DETECTED")
					Return
				Else
					Local $bulkUserList[_GUICtrlEdit_GetLineCount($Edit_Bulk_CheckValidAdAccount_1) + 1]
					For $Cnt11 = 1 to _GUICtrlEdit_GetLineCount($Edit_Bulk_CheckValidAdAccount_1) Step 1
						$bulkUserList[$Cnt11] = _GUICtrlEdit_GetLine($Edit_Bulk_CheckValidAdAccount_1, $Cnt11 - 1)
						$bulkUserList[0] = $Cnt11
					Next
					GUIDelete($Form_Bulk_CheckValidAdAccount)
					Local $BulkString
					$BulkString = "BULK INFORMATION -> Check valid AD account exists" &chr(13) &chr(10) &chr(13) &chr(10)
					For $Cnt11 = 1 to $bulkUserList[0] Step 1

						$BulkString = $BulkString & $bulkUserList[$cnt11] &": " & _GetDesktopType($bulkUserList[$cnt11]) &chr(13) &chr(10)
					Next
						_Display($BulkString)
					Return
				EndIf
		EndSwitch
	WEnd

EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Bulk_Online_Ping_Check()
	$Form_Bulk_OnlinePingCheck = GUICreate("Online Ping Check", 216, 370,_StartPos("x",280), _StartPos("y",100),$WS_SYSMENU,"",$Form_Main)
	$Group_Bulk_OnlinePingCheck = GUICtrlCreateGroup("Information Gatherer", 16, 8, 185, 289)
	$Label_Bulk_OnlinePingCheck_1 = GUICtrlCreateLabel("Please paste the list of Computers you want to work with:", 24, 32, 175, 40)
	$Edit_Bulk_OnlinePingCheck_1 = GUICtrlCreateEdit("", 24, 70, 169, 210)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$Button_Bulk_OnlinePingCheck_ok = GUICtrlCreateButton("OK", 56, 312, 89, 17, $WS_GROUP)
	GUISetState(@SW_SHOW)
	Sleep(3000)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($Form_Bulk_OnlinePingCheck)
				Return

			Case $Button_Bulk_OnlinePingCheck_ok
				If _GUICtrlEdit_GetLine($Edit_Bulk_OnlinePingCheck_1, 0) = ""  Then
					GUIDelete($Form_Bulk_OnlinePingCheck)
					MsgBox(0,"ERROR","NO TEXT DETECTED")
					Return
				Else
					Local $bulkUserList[_GUICtrlEdit_GetLineCount($Edit_Bulk_OnlinePingCheck_1) + 1]
					For $Cnt11 = 1 to _GUICtrlEdit_GetLineCount($Edit_Bulk_OnlinePingCheck_1) Step 1
						$bulkUserList[$Cnt11] = _GUICtrlEdit_GetLine($Edit_Bulk_OnlinePingCheck_1, $Cnt11 - 1)
						$bulkUserList[0] = $Cnt11
					Next
					GUIDelete($Form_Bulk_OnlinePingCheck)
					Local $BulkString
					$BulkString = "BULK INFORMATION -> Bulk Online Ping Check" &chr(13) &chr(10) &chr(13) &chr(10)

					For $Cnt11 = 1 to $bulkUserList[0] Step 1

						$BulkString = $BulkString & $bulkUserList[$cnt11] &": " & _DesktopPing($bulkUserList[$cnt11]) &chr(13) &chr(10)
					Next

						_Display($BulkString)
					Return
				EndIf
		EndSwitch
	WEnd
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Change_log()
	Local $sMsg = ""
	Local $DbInfo = _DBQuery($hDB,"SELECT Changes FROM ChangeLog")
	If $DbInfo <> "-1" or $DbInfo <> "NoData" Then
		For $TCNT = 0 to (UBound($DbInfo) - 1) step 1
			$sMsg = $sMsg &$DbInfo[$TCNT][0] &chr(13) &Chr(10)
		Next
	EndIf
	MsgBox(0,"Central Support Centre Change Log- " &$Version,$sMsg)
EndFunc
;______________________________________________________________________________________
;==================================SCRIPT FUNCTIONS====================================
Func _StartupChecksAndTasks()
	If WinExists("Central Support Center") Then
		MsgBox(16,"ERROR","The application Central Support Center is already running.")
		Exit
	EndIf
	If Not FileExists($hDB) Then
		MsgBox(16,"ERROR","Unable to find the settings database. This is a required component.")
		Exit
	EndIf
	_SQLite_Startup("_Files\Library\sqlite3.dll")
	Local $LogTime = @YEAR &"-" &@MON &"-" &@MDAY &"-" &@HOUR &":" &@MIN &":" &@SEC
	Local $DBQuery,$QReturn
	Local $AllowRun = 0
	If Not FileExists($userDB) Then
		_DBExec($userDB, "CREATE TABLE Log (ActDate,Action,Computer,ScriptDir,User);") ; CREATE a Table
		_DBExec($userDB, "CREATE TABLE Settings (SetName,SetValue);") ; CREATE a Table
		_DBExec($userDB, "CREATE TABLE Accounts (Username,Domain);") ; CREATE a Table
	EndIf
		_DBExec($userDB,"INSERT INTO Log(ActDate,Action,Computer,ScriptDir,User) VALUES ('"&$LogTime &"','Launched','"&@ComputerName &"','"&@ScriptDir &"','"&@LogonDomain &"\" &@UserName &"');")


	Local $DbInfo = _DBQuery($hDB, "SELECT Location FROM Global_AllowRunFrom")
	If $DbInfo <> "-1" or $DbInfo <> "NoData" Then

		For $TCNT = 0 to (UBound($DbInfo) - 1) step 1
			If StringUpper($DbInfo[$TCNT][0]) = StringUpper(@ScriptDir) or StringUpper($DbInfo[$TCNT][0]) = "ANYWHERE" Then
				$AllowRun = 1
				ExitLoop
			EndIf
		Next
	EndIf

	If $AllowRun = 0 Then
		MsgBox(0,"ERROR","THIS APPLICATION NEEDS TO RUN FROM ITS SOURCE LOCATION AND THUS IS NOT ALLOWED TO BE COPIED.")
		Exit
	EndIf
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func TInput($Read,$prompt)


EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _DBExec($CDB,$Command)
	Local $ODB = _SQLite_Open ($CDB)
	_SQLite_Exec ($ODB,$Command)
	If @error Then MsgBox(0,"DBWrite","An Error occured while writing to the database")
	_SQLite_Close($ODB)
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _DBQuery($CDB,$Command)
	Local $ODB = _SQLite_Open ($CDB)
	Local $DBQuery, $QReturn
	Local $DBSwitch = 0
	Local $DbCount  = 1
	Local $DBArray
	_SQlite_Query ($ODB,$Command,$DBQuery)
	If @error Then Return @error

	While _SQLite_FetchData ($DBQuery, $QReturn) = $SQLITE_OK
		If IsArray($QReturn) Then
			If $DBSwitch = 0 Then
				Local $DBBound = UBound($QReturn)
				Local $DBArray[1][$DBBound]
				$DBSwitch = 1
			Else
				ReDim $DBArray[$DbCount][$DBBound]
			EndIf

			For $TCNT = 0 to ($DBBound - 1) Step 1
				$DBArray[($DbCount - 1)][$TCNT] = $QReturn[$TCNT]
			Next
			$DbCount = $DbCount + 1
		EndIf
	WEnd

	_SQLite_QueryFinalize($DBQuery)
	_SQLite_Close($ODB)
	If IsArray($DBArray) Then Return $DBArray
	Return "NoData"
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _GetDesktopType($PcName)
	Local $DN = _ADGetObjectAttribute($PcName &"$","distinguishedName")
	If StringInStr($DN,"OU=Desktops") Then
		Return "DESKTOP"
	ElseIf StringInStr($DN,"OU=Laptops") Then
		Return "LAPTOP"
	Else
		Return "NOT FOUND"
	EndIf
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Test_Function_Button()


EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _DesktopPing($PingName)
	If Ping($PingName,250) Then
		Return "ONLINE"
	Else
		Return "OFFLINE"
	EndIf
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func LocationByIP($NameOrAddress)

	Local $avArray1[1]
	Local $Subnet

	If StringInStr($NameOrAddress,".","",3,1) Then
		$NameOrAddress = StringStripWS($NameOrAddress,3)
		$Subnet = StringTrimRight($NameOrAddress,StringLen($NameOrAddress) - stringinstr($NameOrAddress,".","",3,1))
	Else
		$NameOrAddress = StringStripWS(GetIPByName($NameOrAddress),3)
		If $NameOrAddress = "" Then Return "Not Online"
		$Subnet = StringTrimRight($NameOrAddress,StringLen($NameOrAddress) - stringinstr($NameOrAddress,".","",3,1))
	EndIf

	$objRootDSE = ObjGet("LDAP://RootDSE")
	$strConfigurationNC = $objRootDSE.Get("configurationNamingContext")

	$strSubnetsContainer = "LDAP://cn=Subnets,cn=Sites," & $strConfigurationNC
	$objSubnetsContainer = ObjGet($strSubnetsContainer)

	$objSubnetsContainer.Filter = _ArrayAdd($avArray1, "subnet")

	For $objSubnet In $objSubnetsContainer
		If StringInStr($objSubnet.cn,$Subnet) Then
			$SubnetName = ObjGet($objSubnet.adspath)
			Return $SubnetName.location
			ExitLoop
		EndIf
	Next

	Return "Location NOT found for IP range: "&$Subnet &"x"

EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func GetIPByName($NetworkName)
	TCPStartup()
		$NetworkName = StringStripWS($NetworkName,3)
		$IP = TCPNameToIP($NetworkName)
	TCPShutdown()

	Return $IP
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func Scanpst($PST_RegPath)
	$PST_PC = StringReplace($PST_RegPath,"\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles\","\Software\Microsoft\Office\11.0\Outlook")
	$PST_PC = RegRead($PST_PC,"Machine Name")
	Local $AString = "Detected PC Name: " &$PST_PC  &chr(13) &chr(10) &chr(13) &chr(10)
	For $Count = 1 to 100 Step 1
		$TS = RegEnumKey($PST_RegPath,$Count)
		If @error Then
			ExitLoop
		Else
			For $cnt = 1 to 100 Step 1
				$RS = RegEnumKey($PST_RegPath &$TS,$cnt)
				If @error Then
					ExitLoop
				Else
					For $Cnt2 = 1 to 100 step 1
						$Key = RegEnumVal($PST_RegPath &$TS &"\" &$RS,$Cnt2)
						If @error Then
							ExitLoop
						Else
							If StringInStr($Key,"6700") Then
								$Val = RegRead($PST_RegPath &$TS &"\" &$RS,$Key)
								$AString = $AString &_HexToString(StringReplace($Val,"00","")) &chr(13) &chr(10)
								_Display($AString)
							EndIf
						EndIf
					Next
				EndIf
			Next
		EndIf
	Next
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func ProcessBar($ProcessCheck,$Options = "None")

EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func ScanOptions($SelectedOption,$Scan_Listview1_LSettings,$Scan_Action)
	Local $RegPath = "NotFound"
	_GUICtrlListView_DeleteAllItems($Scan_Listview1_LSettings)
	If $SelectedOption = "" Then $RegPath = "HKCU\Software\CentralSupportCenter"
	If $SelectedOption = "TEST" Then $RegPath = "HKCU\Volatile Environment"

	If $RegPath <> "NotFound" Then
		$cnt1 = 1
		While 1
			$RegEnVal = RegEnumVal($RegPath,$cnt1)
			if @error Then ExitLoop
			GUICtrlCreateListViewItem($RegEnVal &"|" &RegRead($RegPath,$RegEnVal),$Scan_Listview1_LSettings)
			$cnt1 = $cnt1 + 1
		WEnd
	Else
		MsgBox(0,"ERROR","OPTION NOT FOUND.")
		Return
	EndIf
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func GetUserbyPC($p1)
	If $p1 <> "" or $p1 <> "Not Found" Then
		If Ping($p1) <> 0 Then
			Local $TCNT1 = 0
			Local $Form_UserSelect = GUICreate("User Select", 205, 233, _StartPos("x",303), _StartPos("y",125),$WS_SYSMENU,"",$Form_Main)
			Local $List_UserSelect = GUICtrlCreateList("", 8, 8, 185, 175)
			Local $Button_UserSelect = GUICtrlCreateButton("User Select", 8, 184, 185, 17, 0)
			GUISetState(@SW_SHOW)

			For $count = 1 to 50 Step 1
				$RegSid = RegEnumKey("\\" &$P1 &"\HKU",$count)
				If @error Then ExitLoop
				$check = GetUserbySid($RegSid)
				If $check <> "0" Then
					GUICtrlSetData($List_UserSelect,$check,"")
				EndIf
			Next

			While 1
				$nMsg = GUIGetMsg()
				Switch $nMsg
					Case $GUI_EVENT_CLOSE
						GUIDelete($Form_UserSelect)
						Return
					Case $Button_UserSelect
						$ChosenUser = GUICtrlRead($List_UserSelect)
						GUIDelete($Form_UserSelect)
						Return StringReplace($ChosenUser,@LogonDomain &"\","")
				EndSwitch
			WEnd
		Else
			MsgBox(0,"ERROR","UNABLE TO PING THE PC IN QUESTION")
			Return
		EndIf
	Else
		MsgBox(0,"ERROR","INVALID PC NAME DETECTED")
		Return
	EndIf
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func GetSidbyUser($sUser,$GetSidDomain = @LogonDomain)
	$objWMIService = ObjGet("winmgmts:\\127.0.0.1\root\cimv2")
	$colItems = $objWMIService.ExecQuery("Select * from Win32_Account where Name = '" & $sUser & "' and Domain = '" &$GetSidDomain &"'" )

	For $T in $colItems
		Return $T.SID
	Next
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func GetUserbySid($SID)
	If Not StringInStr($SID,"classes") Then
		If Not StringInStr($SID,"default") Then
			If StringLen($SID) < 30 Then
				Return 0
			Else
				$objWMIService = ObjGet("winmgmts:\\127.0.0.1\root\cimv2")
				$objAccount = $objWMIService.Get("Win32_SID.SID='" &$SID &"'")
				Return $objAccount.ReferencedDomainName &"\" &$objAccount.AccountName
			EndIf
		EndIf
	EndIf
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _StartPos($PosType,$Add = 0)
	Local $Form_Main_Pos = WinGetPos("Central Support Center")
	If $PosType = "x" Then Return $Form_Main_Pos[0] + $Add
	If $PosType = "y" Then Return $Form_Main_Pos[1] + $Add
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func GSetting($SetName)
	Local $DbInfo = _DBQuery($hDB,"SELECT SetValue FROM Global_Settings where SetName = '" &$SetName &"';")
	If $DbInfo <> "-1" or $DbInfo <> "NoData" Then Return $DbInfo[0][0]
	Return "NotSet"
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func GetPcByUser($user,$Switch = "None")
	If $User = "" Then
		MsgBox(0,"ERROR","USERNAME FIELD CANNOT BE BLANK")
		Return
	EndIf
	$objSWbemServices = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\" &$SCCMServerName &"\root\sms\SITE_A00")
	$colCollection= $objSWbemServices.ExecQuery("SELECT * FROM sms_r_system Where LastLogonUserName='" & $USER & "'")
	If $colCollection.Count <> 0 Then
		If $Switch = "None" Then
		$Form_PcSelect = GUICreate("PC Select (" &$colCollection.Count &")" , 205, 237, _StartPos("x",303), _StartPos("y",175),$WS_SYSMENU,"",$Form_Main)
		$List_PcSelect = GUICtrlCreateList("", 8, 8, 185, 175)
		$Button_PcSelect = GUICtrlCreateButton("PC Select", 8, 184, 185, 17, 0)
			GUISetState(@SW_SHOW)
				For $objCollectionMember in $colCollection
				If Ping($objCollectionMember.NetbiosName,600) <> 0 Then
					$AddedInfo = "   {" &_GetDesktopType($objCollectionMember.NetbiosName) &"} {ONLINE}"
					GUICtrlSetData($List_PcSelect,$objCollectionMember.NetbiosName &$AddedInfo,"")
				Else
					$AddedInfo = "   {" &_GetDesktopType($objCollectionMember.NetbiosName) &"} {OFFLINE}"
					GUICtrlSetData($List_PcSelect,$objCollectionMember.NetbiosName &$AddedInfo,"")
				EndIf
			Next
				While 1
				$nMsg = GUIGetMsg()
				Switch $nMsg
					Case $GUI_EVENT_CLOSE
						GUIDelete($Form_PcSelect)
						Return
					Case $Button_PcSelect
						$ChosenPc = GUICtrlRead($List_PcSelect)
						If StringInStr($ChosenPc,"{ONLINE}") Then
							$ChosenPcConvert = StringLeft($ChosenPc,StringInStr($ChosenPc," ") - 1)
							$AttachedComputerStatus = "ONLINE"
						Else
							$ChosenPcConvert = StringLeft($ChosenPc,StringInStr($ChosenPc," ") - 1)
							$AttachedComputerStatus = "OFFLINE"
						EndIf
						GUIDelete($Form_PcSelect)
						Return $ChosenPcConvert
				EndSwitch
			WEnd
		Else
			Local $BulkReturn = ""
			For $objCollectionMember in $colCollection
				$BulkReturn = $BulkReturn & $objCollectionMember.NetbiosName &"|"
			Next
			Return $BulkReturn
		EndIf
			Return
	Else
		If $Switch = "None" Then
			Return "Not Found"
		Else
			Return "Not Found|"
		EndIf
	EndIf
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _Display($DInfo,$Opt1="0")
	If $Opt1 = "0" Then
		_MFunc_Clear_Output_Window()
	EndIf
	GUICtrlSetData($DisplayInfo,$DInfo,"Amend")
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func TestLogon($user,$domain,$pass)
	Local $Testlogon = RunAs($user,$domain,$pass,0,"NOTEPAD.EXE",@WindowsDir,@SW_HIDE)
	If $Testlogon = 0 Then
		MsgBox(16,"INFORMATIOn","ACCESS DENIED")
	Else
		MsgBox(64,"INFORMATIOn","ACCESS GRANTED")
		ProcessClose($Testlogon)
	EndIf
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _TrimADS($Path)
	$TmpStr1 = StringTrimLeft($Path,3)
	Return StringLeft($TmpStr1,StringInStr($TmpStr1,",") - 1)
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _AttStatus($AT_T,$AT_N = "")
	If $AT_T = "" or $AT_N = "" Then
		If $AT_T = "" Then
			Return
		Else

		EndIf
	ElseIf $AT_T = "Username" Then
		GUICtrlSetData($Display_AttachedUsername,$AT_N)
		If $AttachedUsername = "" Then $AttachedStatus = $AttachedStatus + 2
		$AttachedUsername = $AT_N
	ElseIf $AT_T = "Domain" Then
		GUICtrlSetData($Display_AttachedDomain,$AT_N)
		$attachedDomain = $AT_N
	ElseIf $AT_T = "Computer" Then
		GUICtrlSetData($Display_AttachedComputer,$AT_N)
		If $AttachedComputer = "" Then $AttachedStatus = $AttachedStatus + 1
		$AttachedComputer = $AT_N
	ElseIf $AT_T = "HomeDir" Then
		GUICtrlSetData($Display_AttachedUserHomePath,$AT_N)
		GUICtrlSetState($Button_Goto_Home,$GUI_ENABLE)
		$AttachedUserHomeDir = $AT_N
	ElseIf $AT_T = "ProfileDir" Then
		GUICtrlSetData($Display_AttachedUserProfilePath,$AT_N)
		GUICtrlSetState($Button_Goto_Profile,$GUI_ENABLE)
		$AttachedUserProDir = $AT_N
	ElseIf $AT_T = "GroupDir" Then
		GUICtrlSetData($Display_AttachedUserGroupPath,$AT_N)
		GUICtrlSetState($Button_Goto_Group,$GUI_ENABLE)
		$AttachedUserGroupDir = $AT_N
	ElseIf $AT_T = "SID" Then
		GUICtrlSetData($Display_AttachedUserSID,$AT_N)
		$AttachedUserSID = $AT_N
	EndIf
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _SplashLoad()
	SplashImageOn("Splash Screen", $IMG_Splash, 499, 217, -1, -1, 1)
	Sleep(3000)
	SplashOff()
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _OpenLocation($OpenLoc = "")
	If $OpenLoc = "Home" Then
		Run("explorer " &$AttachedUserHomeDir)
	ElseIf $OpenLoc = "Profile" Then
		Run("explorer " &$AttachedUserProDir)
	ElseIf $OpenLoc = "Group" Then
		Run("explorer " &$AttachedUserGroupDir)
	EndIf
EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _MFunc_Attach_To($AT_Hide="")
	Local $Form_AttachTo = GUICreate("Attach To", 422, 192, _StartPos("X",200), _StartPos("Y",200),$WS_SYSMENU,"",$Form_Main)
	Local $Group_AttachTo = GUICtrlCreateGroup("Attach To:", 8, 0, 401, 129)
	Local $Checkbox_User = GUICtrlCreateCheckbox("Attach To: Username:", 16, 24, 129, 17)
	Local $Checkbox_Computer = GUICtrlCreateCheckbox("Attach To: Computer", 16, 96, 145, 17)
	Local $Button_Close = GUICtrlCreateButton("Close", 8, 136, 89, 25)
	Local $Button_AttachTo = GUICtrlCreateButton("Attach To", 304, 136, 105, 25)
	Local $Input_Username = GUICtrlCreateInput($AttachedUsername, 176, 24, 140, 21)
	Local $Input_Domain = GUICtrlCreateInput($attachedDomain, 176, 48, 140, 21)
	Local $Input_SID = GUICtrlCreateInput($AttachedUserSID, 176, 72, 225, 21,0x0800)
	Local $Input_Computer = GUICtrlCreateInput($AttachedComputer, 176, 96, 140, 21)
	Local $Label1 = GUICtrlCreateLabel("Attach To: Domain", 35, 48, 109, 17)
	Local $Label2 = GUICtrlCreateLabel("Attach To: Secutiry Identifier", 35, 72, 138, 17)
	Local $Button_Detect_Username = GUICtrlCreateButton("Detect User", 320, 24, 81, 17)
	Local $Button_Detect_Computer = GUICtrlCreateButton("Detect Pc", 320, 96, 81, 17)

	GUISetState(@SW_SHOW)
	If $AT_Hide = "User" or $AT_Hide = "2" Then
		GUICtrlSetState($Checkbox_User,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_Computer,$GUI_UNCHECKED)
		GUICtrlSetState($Input_Computer,$GUI_DISABLE)
	ElseIf $AT_Hide = "Computer" or $AT_Hide = "1" Then
		GUICtrlSetState($Checkbox_User,$GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_Computer,$GUI_CHECKED)
		GUICtrlSetState($Input_Username,$GUI_DISABLE)
		GUICtrlSetState($Input_Domain,$GUI_DISABLE)
	Else
		GUICtrlSetState($Checkbox_User,$GUI_CHECKED)
		GUICtrlSetState($Checkbox_Computer,$GUI_CHECKED)
	EndIf

	_GGLocationFinder("")
	_MFunc_Clear_Attach_To_Details()

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($Form_AttachTo)
				Return
			Case $Button_Close
				GUIDelete($Form_AttachTo)
				Return
			Case $Button_Detect_Username
				If GUICtrlRead($Input_Computer) = "" Then
					$ChkComp = InputBox("INFORMATION REQUIRED","PLEASE TYPE THE COMPUTER NAME TO SCAN","")
					If Not @error Then
						GUICtrlSetData($Input_Username,GetUserbyPC($ChkComp))
						GUICtrlSetData($Input_SID,GetSidbyUser(GUICtrlRead($Input_Username)))
					EndIf
				Else
					GUICtrlSetData($Input_Username,GetUserbyPC(GUICtrlRead($Input_Computer)))
					GUICtrlSetData($Input_SID,GetSidbyUser(GUICtrlRead($Input_Username)))
				EndIf
			Case $Button_Detect_Computer
				If GUICtrlRead($Input_Username) = "" Then
					$ChkUsR = InputBox("INFORMATION REQUIRED","PLEASE TYPE THE USERNAME TO SCAN","")
					If Not @error Then
						GUICtrlSetData($Input_Computer,GetPcByUser($ChkUsR))
					EndIf
				Else
					GUICtrlSetData($Input_Computer,GetPcByUser(GUICtrlRead($Input_Username)))
				EndIf
			Case $Input_Username
				GUICtrlSetData($Input_SID,GetSidbyUser(GUICtrlRead($Input_Username),GUICtrlRead($Input_Domain)))
			Case $Checkbox_User
				If BitAND(GUICtrlRead($Checkbox_User), $GUI_CHECKED) = $GUI_CHECKED Then
					GUICtrlSetState($Input_Username,$GUI_ENABLE)
					GUICtrlSetState($Input_Domain,$GUI_ENABLE)
				Else
					GUICtrlSetState($Input_Username,$GUI_DISABLE)
					GUICtrlSetState($Input_Domain,$GUI_DISABLE)
				EndIf
			Case $Checkbox_Computer
				If BitAND(GUICtrlRead($Checkbox_Computer), $GUI_CHECKED) = $GUI_CHECKED Then
					GUICtrlSetState($Input_Computer,$GUI_ENABLE)
				Else
					GUICtrlSetState($Input_Computer,$GUI_DISABLE)
				EndIf
			Case $Button_AttachTo
				If BitAND(GUICtrlRead($Checkbox_Computer), $GUI_CHECKED) = $GUI_CHECKED And GUICtrlRead($Input_Computer) <> "" and GUICtrlRead($Input_Computer) <> "0"  Then
					_AttStatus("Computer",GUICtrlRead($Input_Computer))
					If ping($AttachedComputer,500) <> 0 Then GUICtrlSetState($Button_Att_RemoteAssist,$GUI_SHOW)
				EndIf
				If BitAND(GUICtrlRead($Checkbox_User), $GUI_CHECKED) = $GUI_CHECKED And GUICtrlRead($Input_Username) <> "" and GUICtrlRead($Input_Username) <> "0"  Then
					_AttStatus("Username",GUICtrlRead($Input_Username))
					_AttStatus("SID",GUICtrlRead($Input_SID))
					_AttStatus("Domain",GUICtrlRead($Input_Domain))
					_AttStatus("ProfileDir",_ADGetObjectAttribute($AttachedUsername,"ProfilePath"))
					_AttStatus("HomeDir",_ADGetObjectAttribute($AttachedUsername,"HomeDirectory"))
					_AttStatus("GroupDir",_GGLocationFinder($AttachedUsername,"USER"))

				EndIf
				WinActivate("Central Support Center")
				GUIDelete($Form_AttachTo)
				Return $AttachedStatus
		EndSwitch
	WEnd
EndFunc
;______________________________________________________________________________________
;==================================Console FUNCTIONS===================================
Func _CFunc_Command($CCommand)
	GUICtrlSetData($Console_Input,"")
	local $strHelp = ""
	Local $strConPath = @ScriptDir &"\_Files\_Console\"
	If $CCommand <> "" Then
		_Console_Display("Console: "&$CCommand)
		$ICommand = StringSplit($CCommand," ")
		If FileExists(@ScriptDir &"\_Files\_Console\" &$ICommand[1] &".Tx1") Then
			If $ICommand[0] <> "1" Then
				If $ICommand[1] = "Help" Then
					If FileExists($strConPath &$ICommand[2] &".Tx1") Then
						$lineCount = _FileCountLines($strConPath &$ICommand[2] &".Tx1")
						If $lineCount <> "0" Then
						For $Cnt13 = 1 to $lineCount Step 1
							$line = FileReadLine($strConPath &$ICommand[2] &".Tx1",$Cnt13)
							If StringLeft($line,1) = "#" Then
								_Console_Display($line)
							EndIf

						Next
						Else
							_Console_Display("Help: No help listed for command {" &$ICommand[2] &"}")
						EndIf
					Else
						_Console_Display("Help: Command not found {" &$ICommand[2] &"}")
					EndIf
				ElseIf $ICommand[1] = "cls" Then
					If $ICommand[2] = "1" Then
						_MFunc_Clear_Output_Window()
					ElseIf	$ICommand[2] = "2" Then
						GUICtrlSetData($Console_Display,"")
					EndIf
				ElseIf $ICommand[1] = "Int" Then
					Local $CallCom = ""
					For $cnt13 = 2 to $ICommand[0] Step 1
						$CallCom = $CallCom &"_" &$ICommand[$cnt13]
					Next

					Call("_MFunc" &$CallCom)

				ElseIf $ICommand[1] = "Run" Then
					If $AttachedStatus = "1" or $AttachedStatus = "3" Then
						$Comm = ""
						For $cnt13 = 2 to $ICommand[0] step 1
							$Comm = $comm & $ICommand[$cnt13] &" "
						Next

						$RunCom = Run($UtilPath &"psexec.exe""" &" \\" &$AttachedComputer &" " &$comm ,@SystemDir,@SW_HIDE,0x10000)
						While 1
							$line = StdoutRead($RunCom)
							If @error Then ExitLoop
							If $line <> "" Then
								_Console_Display($line)
							EndIf
						Wend
					Else
						_Console_Display(">Desktop Attachment Required")
					EndIf
				ElseIf $ICommand[1] = "RegAdd" Then
					$lineCount = _FileCountLines($strConPath &$ICommand[1] &".Tx1")
					If $lineCount <> "0" Then
						For $Cnt13 = 1 to $lineCount Step 1
							$line = FileReadLine($strConPath &$ICommand[1] &".Tx1",$Cnt13)
							If StringLeft($line,1) <> "#" Then
								$sLine = StringSplit($line,@TAB)
								If StringUpper($sLine[1]) = StringUpper($ICommand[2]) Then
									If StringInStr($sLine[3],"HKLM\") Then
										If $AttachedStatus = "1" or $AttachedStatus = "3" Then
											RegWrite(StringReplace($sLine[3],"HKLM\","\\"&$AttachedComputer &"\HKLM\",1,0),$sLine[4],$sLine[2],$sLine[5])
											If Not @error Then _Console_Display(">Command Successfully executed")
										Else
											_Console_Display(">Desktop Attachment Required")
										EndIf
									ElseIf	StringInStr($sLine[3],"HKCU\") Then
										If $AttachedStatus = "3" Then
											RegWrite(StringReplace($sLine[3],"HKCU\","\\"&$AttachedComputer &"\HKU\" &$AttachedUserSID &"\",1,0),$sLine[4],$sLine[2],$sLine[5])
											If Not @error Then _Console_Display(">Command Successfully executed")
										Else
											_Console_Display(">User and Desktop Attachment Required")
										EndIf
									EndIf
								EndIf

							EndIf
						Next
					EndIf
				Else
					For $Cnt13 = 1 to _FileCountLines($strConPath &$ICommand[1] &".Tx1") Step 1
						$line = FileReadLine($strConPath &$ICommand[1] &".Tx1",$Cnt13)
						;------------------------------------------------------------------
						If StringLeft($line,1) = "#" Then
							$strHelp = $strHelp & $line &Chr(13) &Chr(10)
						EndIf
						;------------------------------------------------------------------
					Next
					If $ICommand[0] = "1" Then
						_Console_Display($strHelp)
					Else

					EndIf
				EndIf
			Else
				If $ICommand[1] = "help" Then
					_Console_Display("> Type Help *Command* for further details on a specified command.")
				Else
					_Console_Display("> Incificient Options Supplied. Type Help *Command* for further details.")
				EndIf
			EndIf
		Else
			_Console_Display("> Command Not Found")
		EndIf
	EndIf

EndFunc
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Func _Console_Display($Message)
	GUICtrlSetData($Console_Display,GUICtrlRead($Console_Display)  &Chr(13) &Chr(10) &$Message)

EndFunc
;______________________________________________________________________________________