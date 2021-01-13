#cs ----------------------------------------------------------------------------

 AutoIt Version		: 3.2.2.0
 Author				: Christophe Savard (christophe.savard@fr.ibm.com)

 Script Function	: Make Network drives connections more confortable for those whom have to be connected to multiple shares and need to often manipulate them (explore/connect/disconnect)
					  - Connect or Disconnect manually a network drive (as same as Windows options)
					  - Register/Unregister a Network drive in a list (ini file created near the script)
						This option avoids to reconnect manually a network drive and also to use the "Reconnect at logon" proposed by Windows.
						The Windows functionality is replaced by a "Reconnect at program startup" which try to connect if the parameter is set and if connection is not successful no Network
						drive is displayed (not necessary when not connected to a network).
					  - Dynamic view of the connected drives (registered or not)
					    Of course the listview is updated if you add/modify an item from the list but it also updates the listview if you manually connect/disconnect (without using the tool)
						to a network share.
						
 Restrictions		: This script only works on WinXP or Win 2003. Some functions do not work under other Windows version.
 
 Remark				: The line 165 contains the following instruction : If $NetworkCards[$i][0] <> "AGN Virtual Network Adapter" And $NetworkCards[$i][20] = 2 Then
					  This line can be modified, depending of the Network adapters you have on your own machine.
					  "AGN Virtual Network Adapter" is only mentioned because this was present on the machine where the script was developed.
					  If you remove the first part of the test, the first connected network card will satisfy the test.
					  Therefore the line would be "If $NetworkCards[$i][20] = 2 Then"
					  
					  If you use this tool with remote connection (Dialer/ADLS) you could experience problems with the "Folder" field in the listview.
					  After a manual connection, and if the toll is already active, this field is not always filled (I'm investigating) 
#ce ----------------------------------------------------------------------------


#include <GuiConstants.au3>
#include <Constants.au3>
#Include <GuiStatusBar.au3>
#include <GuiListView.au3>
#Include <date.au3>
#Include <String.au3>
#NoTrayIcon
Opt("GUIOnEventMode", 1)
Opt("WinTitleMatchMode",1)
Opt("TrayIconDebug",0)
Opt("TrayMenuMode",1)
Opt("TrayOnEventMode",1)
$TrayInit=TrayCreateItem("Restore")
TrayItemSetOnEvent(-1,"InitGui")
TrayCreateItem("")
$TrayExit=TrayCreateItem("Exit")
TrayItemSetOnEvent(-1,"ExitPrgm")
TraySetState()

Dim $Drive,$StatusBar,$StatusBarSize,$StatusBarText,$MainGuiTitle,$ShareGuiTitle,$Guicolor,$ItemListColor,$Top,$Left,$CtrlHeigth,$CtrlWidth,$Result,$ErrFlag,$Msg,$GuiWidth,$GuiHeight,$Flag,$ConnectBut
Dim $ShareList,$ShareListRecord,$ShareDesc,$SelectedShare,$ShareModify,$ShareCreate,$ShareDescMenu,$MainGui,$ShareNickName,$ShareLetter,$ShareUser,$SharePasswd,$ShareRecon,$DeleteBut
Dim $ListView,$SharesGUI,$LetterInput,$UserInput,$PwdInput,$AutoConnect,$ValidateBut,$CancelBut,$FreeDrives,$StateIcon,$OldDrive,$MainGUIState,$ListViewItemCount,$SelectedListItemData
Dim $NameInput,$InputNickName,$MenuConnect,$MenuDisconnect,$MenuUnregister,$MenuListViewRegister,$MenuListViewConnect,$MenuListViewDisconnect,$ListViewItem,$ItemArray,$Oldrive,$ListViewContextMenu
Dim $ActualConnectedDrives,$BaseRegisteredShares,$BaseConnectedDrives,$ShareManage,$ShareConnect,$ShareDisconnect,$ItemsInList,$ShareConnectItem,$ShareDisConnectItem,$ToolsMenu,$ShareMap,$ShareUnMap,$Action
Dim $AutoConnect,$NetworkConnected,$NetworkCards,$StartFlag,$RunAutoConnect,$ConnectCTXTMENU
Dim $Column1,$Column2,$Column3,$Column4,$Column5,$Column6,$Column7
$Pname=@ScriptName
If $Cmdline[0]=0 Then ; This could be helpfull if you want to use this script but call it from an other program. You could send the Caller Program's Title as parameter
	$MainGuiTitle="NetWork Drive Map Utility"
Else
	$MainGuiTitle=$Cmdline[1] & " - NetWork Drive Map Utility"
EndIf
SplashTextOn($MainGuiTitle,"Loading Application... Please wait !",500,80,-1,-1,0+16+32,"",10,300)
TraySetToolTip($MainGuiTitle & @LF & _NowDate ( ) & "-" & _NowTime(3))
#region COMPATIBILITY TEST ; Only WinXp or Win2004 Machines can fully run this script, for other Win version an alert message is displayed
	Switch @OSVersion
		Case "WIN_XP" or "WIN_2003"
			; OK
		Case "WIN_2000" Or "WIN_NT4" Or "WIN_ME" Or "WIN_98" Or "WIN_95"
			$OSValid = "?"
			$msg = "Part of this software's features are NOT SUPPORTED by the current operating system." & @LF & @LF & "      *** USING THIS SOFTWARE IS UNDER YOUR FULL RESPONSABILITY *** "
			SplashOff()
			MsgBox(64,$MainGuiTitle & " - Compatibility",$msg)
		Case "WIN_6.0" Or "WIN_6.1"
			$OSValid = "NO"
			$msg = "This application is NOT SUPPORTED by the current operating system."
			SplashOff()
			MsgBox(16,$MainGuiTitle & " - Compatibility !!!",$msg,3)
			Exit
	EndSwitch
	if _Singleton($PName,1) = 0 Then ; Call the test function which check if an other occurence of this program is already running
		SplashOff()
		MsgBox(48,$MainGuiTitle & " - WARNING !!!", "Application  " & '" ' & $PName & ' "' & "  is already running... !",5); If Yes error message is returned and Exit
		Exit
	EndIf
#endregion COMPATIBILITY TEST

#region NETWORK ACTIVITY TEST ; Avoid running AutoConnect if no network connection
If Not(IsDeclared("$cI_CompName")) Then
	Global	$cI_CompName = @ComputerName
EndIf
Global Const $cI_VersionInfo		= "00.03.08"
Global Const $cI_aName				= 0, _
			 $cI_aDesc				= 4
Global	$wbemFlagReturnImmediately	= 0x10, _	;DO NOT CHANGE
$wbemFlagForwardOnly		= 0x20				;DO NOT CHANGE
Global	$ERR_NO_INFO				= "Array contains no information", _
		$ERR_NOT_OBJ				= "$colItems isnt an object"
		
Func __StringVersion()
	Return $cI_VersionInfo
EndFunc ;_StringVersion

Func __StringToDate($dtmDate)
	Return (StringMid($dtmDate, 5, 2) & "/" & _
			StringMid($dtmDate, 7, 2) & "/" & StringLeft($dtmDate, 4) _
			& " " & StringMid($dtmDate, 9, 2) & ":" & StringMid($dtmDate, 11, 2) & ":" & StringMid($dtmDate,13, 2))
EndFunc ;__StringToDate Function created by SvenP Modified by JSThePatriot

Func _ComputerGetNetworkCards(ByRef $aNetworkInfo)
	Local $colItems, $objWMIService, $objItem
	Dim $aNetworkInfo[1][34], $i = 1
	
	$objWMIService = ObjGet("winmgmts:\\" & $cI_Compname & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapter", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	
	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aNetworkInfo[UBound($aNetworkInfo) + 1][34]
			$aNetworkInfo[$i][0]  = $objItem.Name
			$aNetworkInfo[$i][1]  = $objItem.AdapterType
			$aNetworkInfo[$i][2]  = $objItem.AdapterTypeId
			$aNetworkInfo[$i][3]  = $objItem.AutoSense
			$aNetworkInfo[$i][4]  = $objItem.Description
			$aNetworkInfo[$i][5]  = $objItem.Availability
			$aNetworkInfo[$i][6]  = $objItem.ConfigManagerErrorCode
			$aNetworkInfo[$i][7]  = $objItem.ConfigManagerUserConfig
			$aNetworkInfo[$i][8]  = $objItem.CreationClassName
			$aNetworkInfo[$i][9]  = $objItem.DeviceID
			$aNetworkInfo[$i][10] = $objItem.ErrorCleared
			$aNetworkInfo[$i][11] = $objItem.ErrorDescription
			$aNetworkInfo[$i][12] = $objItem.Index
			$aNetworkInfo[$i][13] = $objItem.Installed
			$aNetworkInfo[$i][14] = $objItem.LastErrorCode
			$aNetworkInfo[$i][15] = $objItem.MACAddress
			$aNetworkInfo[$i][16] = $objItem.Manufacturer
			$aNetworkInfo[$i][17] = $objItem.MaxNumberControlled
			$aNetworkInfo[$i][18] = $objItem.MaxSpeed
			$aNetworkInfo[$i][19] = $objItem.NetConnectionID
			$aNetworkInfo[$i][20] = $objItem.NetConnectionStatus
			$aNetworkInfo[$i][21] = $objItem.NetworkAddresses(0)
			$aNetworkInfo[$i][22] = $objItem.PermanentAddress
			$aNetworkInfo[$i][23] = $objItem.PNPDeviceID
			$aNetworkInfo[$i][24] = $objItem.PowerManagementCapabilities(0)
			$aNetworkInfo[$i][25] = $objItem.PowerManagementSupported
			$aNetworkInfo[$i][26] = $objItem.ProductName
			$aNetworkInfo[$i][27] = $objItem.ServiceName
			$aNetworkInfo[$i][28] = $objItem.Speed
			$aNetworkInfo[$i][29] = $objItem.Status
			$aNetworkInfo[$i][30] = $objItem.StatusInfo
			$aNetworkInfo[$i][31] = $objItem.SystemCreationClassName
			$aNetworkInfo[$i][32] = $objItem.SystemName
			$aNetworkInfo[$i][33] = __StringToDate($objItem.TimeOfLastReset)
			$i += 1
		Next
		$aNetworkInfo[0][0] = UBound($aNetworkInfo) - 1
		If $aNetworkInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc ;_ComputerGetNetworkCards

_ComputerGetNetworkCards($NetworkCards) ; Call the function which checks if there is an active network connection
If @error Then
	$error = @error
	$extended = @extended
	Switch $extended
		Case 1
			_ErrorMsg($ERR_NO_INFO)
		Case 2
			_ErrorMsg($ERR_NOT_OBJ)
	EndSwitch
EndIf

For $i = 1 To $NetworkCards[0][0] Step 1
	If $NetworkCards[$i][0] <> "AGN Virtual Network Adapter" And $NetworkCards[$i][20] = 2 Then ; Adapters can be modified if needed
		$NetworkConnected="YES"
		ExitLoop
	Else
		$NetworkConnected = "NO"
		ContinueLoop
	EndIf
Next

If $NetworkConnected = "NO" Then ; Sends an alert if no Network connection is active
	$Msg="You're not connected to a Network !"
	SplashOff()
	Call("Message",$Msg)
EndIf
#endregion NETWORK ACTIVITY TEST
#region Main GUI ; All functions related with the main GUI
$Guicolor=0xE0E0FF
$ItemListColor=0xD0D0FF
$ShareList=IniReadSection(StringLeft ( @ScriptFullPath, StringInStr ( @ScriptFullPath, ".",0,-1 ) ) & "ini","Shares")
If Not IsArray($ShareList) Then $ShareList=""
$Share=""
$Flag=""
$IP=""
$ConnectIcon=9
$ProcessingIcon=85
$DisconnectIcon=10
$ReadyIcon=176
$GuiWidth=580
$GuiHeight=220
$Top=10
$Left=10
Local $StatusBarSize[2] = [70,-1]
Local $StatusBarText[2] = ["Ready", ""]
Call ("InitGui")
	Func Minimize()
		$RunAutoConnect="NO" ; Avoid to run autoconnect on restore if drives are disconnected and flag set to yes
		GUIDelete($Maingui)
	EndFunc
	Func InitGui() ; Creates the main GUI
		If WinExists($MainGuiTitle,"Ready") Then 
			WinActivate($MainGuiTitle,"Ready")
			Return
		EndIf
		
		$StartFlag="YES"
		$MainGui=GUICreate($MainGuiTitle,$GuiWidth,$GuiHeight,@DesktopWidth-($GuiWidth+5),0)
		GUISetBkColor ($GuiColor)
		GUISetOnEvent($GUI_EVENT_CLOSE,"Quit")
		$FileMenu=GUICtrlCreateMenu("&File")
		$FileAbout=$FileMenu=GUICtrlCreateMenuitem("&About",$FileMenu)
		GUICtrlSetOnEvent(-1,"About")
		$FileExit=GUICtrlCreateMenuitem("&Close",$FileMenu)
		GUICtrlSetOnEvent(-1,"Minimize")
		Call("CreateListView")
		$Result=Call("BuildListView")
		$Result=StringSplit($Result,",",1)
		$BaseConnectedDrives=$Result[1]
		$BaseRegisteredShares=$Result[2]
		Call("CreateManageMenu")
		GUICtrlSetColor(-1,0x0000FF)
		SplashOff()
		GUISetState()
		$StatusBar=_GUICtrlStatusBarCreate($MainGui,$StatusBarSize,$StatusBarText)
		_GUICtrlStatusBarSetIcon($StatusBar, 0, "shell32.dll", $ReadyIcon)
		_GUICtrlStatusBarSetText ($StatusBar, "Use " & '"' &  " Tools " & '"' & " Menu or Select an item in list (left click) and than right click to diplay context menu...", 1)
		GUISetState(@SW_DISABLE,$MainGui)
		If $NetworkConnected="YES" Then Call("AutoConnectShares") ; Only called if an active network ccnnection exists
		GUISetState(@SW_ENABLE,$MainGui)
		$MainGUIState="OK"
	EndFunc
	
	Func CreateManageMenu() ; Create the appropriate options in the Tool Menu
		GUICtrlDelete($ToolsMenu)
		$ToolsMenu=GUICtrlCreateMenu("&Tools")
		$ShareMap = GUICtrlCreateMenuitem("&Map Network Drive...",$ToolsMenu)
		GUICtrlSetOnEvent(-1,"MapOnce")
		GUICtrlCreateMenuItem("",$ToolsMenu)
		$ShareUnMap = GUICtrlCreateMenuitem("&Disconnect Network Drive...",$ToolsMenu)
		GUICtrlSetOnEvent(-1,"UnMapOnce")	
		GUICtrlCreateMenuItem("",$ToolsMenu)		
		$ShareCreate = GUICtrlCreateMenuItem("&Register New Share",$ToolsMenu)
		GUICtrlSetOnEvent(-1,"ShareGUI")
	EndFunc
	
	Func CreateListView() ; Creates the Listview
		$State=""
		$Found=""
		$Folder=""
		$Column1="Connected"
		$Column2="Drive"
		$Column3="Nickname"
		$Column4="Folder"
		$Column5="User"
		$Column6="Reconnect"
		$Column7="St"
		$ListView=GUICtrlCreateListView($Column7& "|" &$Column1 & "|" & $Column2 & "|" & $Column3 & "|" & $Column4 &  "|" & $Column5 & "|" & $Column6 ,20,20,$GuiWidth-45,$GuiHeight-100,BitOr($LVS_SHOWSELALWAYS, $LVS_SINGLESEL,$LVS_EX_FULLROWSELECT,$LVS_SORTASCENDING))
		GUICtrlSetBkColor(-1, $Guicolor)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_LV_ALTERNATE)
		;Call("ListViewColumnResize")
		_GUICtrlListViewJustifyColumn ( $ListView, 2, 2)
		_GUICtrlListViewJustifyColumn ( $ListView, 6, 2)
	EndFunc
	
	Func BuildListView() ; Deletes and recreates listview entries
		Local $BaseCountConnectedDrives,$BaseCountRegisteredShares
		_GUICtrlListViewDeleteAllItems($Listview) ; Delete all items of the listview if any
		$OldDrive=DriveGetDrive ( "NETWORK" )
		If Not IsArray ($Sharelist) And Not IsArray($OldDrive) Then  ; Nothing connected & Sharlist empty
			$BaseCountConnectedDrives=0
			$BaseCountRegisteredShares=0
			$RetVal=$BaseCountConnectedDrives & "," & $BaseCountRegisteredShares
			Call("ListViewColumnResize")
			Return $RetVal
		EndIf
		
		If Not IsArray ($Sharelist) And IsArray($OldDrive) Then  ; Sharelist is empty but unregistered drive is connected
			For $i=1 To $OldDrive[0]
				$OldDriveInfo=DriveMapGet($OldDrive[$i])
				GUICtrlCreateListViewItem("" & "|"& "YES" & "|" & StringUpper($OldDrive[$i]) & "| " & "Unregistered" & "| " & $OldDriveInfo & "| " & "N/A"  & "|" & "N/A",$Listview)
				GUICtrlSetBkColor(-1,$ItemListColor)
				GUICtrlSetImage ( -1, "Shell32.dll", $ConnectIcon,0 )

			Next
			$BaseCountConnectedDrives=$OldDrive[0]
			$BaseCountRegisteredShares=0
			$RetVal=$BaseCountConnectedDrives & "," & $BaseCountRegisteredShares
			Call("ListViewColumnResize")
			Return $RetVal
		EndIf
		
		If IsArray ($Sharelist) And Not IsArray($OldDrive) Then  ; Sharelist is not empty and no drive is connected
			For $i=1 To $Sharelist[0][0]
				$ShareListRecord=StringSplit($ShareList[$i][1],",",1)
				If $ShareListRecord[2]="" Then $ShareListRecord[2]= "*"
				If $ShareListRecord[5]="" Or $ShareListRecord[5]=0 Then 
					$ShareListRecord[5]="NO"
				Else
					$ShareListRecord[5]="YES"
				EndIf
				GUICtrlCreateListViewItem("" & "|" & "NO" & "|" & "[" & $ShareListRecord[2] & "]" & "| " & $ShareList[$i][0] & "| " & $ShareListRecord[1] & "| " & $ShareListRecord[3] & "|" & $ShareListRecord[5],$ListView)
				GUICtrlSetBkColor(-1,$ItemListColor)
				GUICtrlSetImage ( -1, "Shell32.dll", $DisconnectIcon,0 )
				IniDelete(StringLeft ( @ScriptFullPath, StringInStr ( @ScriptFullPath, ".",0,-1 ) )& "ini","Connected",$ShareList[$i][0])
			Next
			$BaseCountConnectedDrives=0
			$BaseCountRegisteredShares=$Sharelist[0][0]
			$RetVal=$BaseCountConnectedDrives & "," & $BaseCountRegisteredShares
			Call("ListViewColumnResize")
			Return $RetVal
		EndIf
		
		If IsArray ($Sharelist) And IsArray($OldDrive) Then   ; Sharelist is not empty and drive is/are connected
			For $i=1 To $ShareList[0][0]
				$ShareListRecord=StringSplit($ShareList[$i][1],",",1)
				$Folder=$ShareListRecord[1]
				If $ShareListRecord[5]="" Or $ShareListRecord[5]=0 Then 
					$ShareListRecord[5]="NO"
				Else
					$ShareListRecord[5]="YES"
				EndIf
				$ShareState=""
				For $j=1 to $OldDrive[0]
					$OldDriveInfo=DriveMapGet($OldDrive[$j])
					If $OldDriveInfo=$Folder Then
						$ShareState="YES"
						GUICtrlCreateListViewItem("" & "|" & $ShareState & "|" & StringUpper($OldDrive[$j]) & "| " & $ShareList[$i][0] & "| " & $ShareListRecord[1] & "| " & $ShareListRecord[3] & "|" & $ShareListRecord[5],$Listview)
						GUICtrlSetBkColor(-1,$ItemListColor)
						GUICtrlSetImage ( -1, "Shell32.dll", $ConnectIcon,0 )
						IniWrite(StringLeft ( @ScriptFullPath, StringInStr ( @ScriptFullPath, ".",0,-1 ) )& "ini","Connected",$ShareList[$i][0],StringUpper($OldDrive[$j])) ; Creates file and add a blank share section
					EndIf
				Next
				
				If $ShareState <> "YES" Then
					If $ShareListRecord[2]="" Then $ShareListRecord[2]= "*"
					GUICtrlCreateListViewItem("" & "|" & "NO" & "|" & "[" & $ShareListRecord[2] & "]" & "| " & $ShareList[$i][0] & "| " & $ShareListRecord[1] & "| " & $ShareListRecord[3] & "|" & $ShareListRecord[5],$Listview)
					GUICtrlSetBkColor(-1,$ItemListColor)
					GUICtrlSetImage ( -1, "Shell32.dll", $DisconnectIcon,0 )
					IniDelete(StringLeft ( @ScriptFullPath, StringInStr ( @ScriptFullPath, ".",0,-1 ) )& "ini","Connected",$ShareList[$i][0])
				EndIf
			Next
			
			For $j=1 to $OldDrive[0] ; Check for unregistered Connected drives 
				$OldDriveInfo=DriveMapGet($OldDrive[$j])
				$AlreadyInList=""
				$ListViewItemCount=_GUICtrlListViewGetItemCount ( $ListView) ; Gets the existing items in listview
				For $i=0 To $ListViewItemCount-1
					$ItemArray=_GUICtrlListViewGetItemTextArray ( $ListView,$i )	
					If StringStripWS($ItemArray[3],1)=StringUpper($OldDrive[$j]) And StringStripWS($ItemArray[5],1)=$OldDriveInfo Then
						$AlreadyInList="YES" ; Eliminate drives already in listview
						ExitLoop
					EndIf
				Next
				If $AlreadyInList<>"YES" Then 
					GUICtrlCreateListViewItem("" & "|" & "YES" & "|" & StringUpper($OldDrive[$j]) & "| " & "Unregistered" & "| " & $OldDriveInfo & "| " & "N/A" & "|" & "N/A",$Listview)
					GUICtrlSetBkColor(-1,$ItemListColor)
					GUICtrlSetImage ( -1, "Shell32.dll", $ConnectIcon,0 )
				EndIf
			Next
		EndIf
		;========= Counts all items in the sharelist and all connected network drives and set the base for comparison in case of modification
		$ShareList=IniReadSection(StringLeft ( @ScriptFullPath, StringInStr ( @ScriptFullPath, ".",0,-1 ) )& "ini","Shares")
		$OldDrive=DriveGetDrive ( "NETWORK" )
		If Not IsArray($ShareList) Then 
			$BaseCountRegisteredShares=0
		Else
			$BaseCountRegisteredShares=$ShareList[0][0]
		EndIf
		
		If Not IsArray($OldDrive) Then 
			$BaseCountConnectedDrives=0
		Else
			$BaseCountConnectedDrives=$OldDrive[0]
		EndIf
		;=======================================================================
		$BaseCountConnectedDrives=$OldDrive[0]
		$BaseCountRegisteredShares=$Sharelist[0][0]
		$RetVal=$BaseCountConnectedDrives & "," & $BaseCountRegisteredShares
		Call("ListViewColumnResize")
		Return $RetVal
	EndFunc
	
	Func ListViewColumnResize()
		_GUICtrlListViewSetColumnWidth ( $ListView, 0,30)
		_GUICtrlListViewSetColumnWidth ( $ListView, 1,0)
		_GUICtrlListViewSetColumnWidth ( $ListView, 2,40)
		_GUICtrlListViewSetColumnWidth ( $ListView, 3,90)
		_GUICtrlListViewSetColumnWidth ( $ListView, 4,210)
		_GUICtrlListViewSetColumnWidth ( $ListView, 5,70)
		If _GUICtrlListViewGetItemCount ( $ListView ) > 5 Then ; Allows to make the vertical scroll to appear without the Horizontal scroll
			_GUICtrlListViewSetColumnWidth ( $ListView, 6,70)
		Else
			_GUICtrlListViewSetColumnWidth ( $ListView, 6,90)
		EndIf
	EndFunc
	
	Func ListViewRefresh() ; Check if modifications occured in the sharelist or in the connected network drives list
		Local $ActualCountConnectedDrives,$ActualCountRegisteredShares
		$ShareList=IniReadSection(StringLeft ( @ScriptFullPath, StringInStr ( @ScriptFullPath, ".",0,-1 ) ) &"ini","Shares")
		$OldDrive=DriveGetDrive ( "NETWORK" )
		If Not IsArray($ShareList) Then 
			$ActualCountRegisteredShares=0
		Else
			$ActualCountRegisteredShares=$ShareList[0][0]
		EndIf
		
		If Not IsArray($OldDrive) Then 
			$ActualCountConnectedDrives=0
		Else
			$ActualCountConnectedDrives=$OldDrive[0]
		EndIf
		
		$RetVal=$ActualCountConnectedDrives & "," & $ActualCountRegisteredShares
		Return $RetVal ; Return actual values for sharelist items and conneted network drives
	EndFunc	
		
	Func LeftClickMouse() ; Selects the Item and also reset the context menu for each ListView Item
		Local $CursorPos
		$CursorPos = GUIGetCursorInfo($MainGui)
		If $CursorPos[4] <> $ListView Then Return; checks if a right click has been done on a list view item
		If Not IsArray($CursorPos) Then Return ; ListView is empty
		
		GUICtrlDelete($ListViewContextMenu)
		$SelectedListItemData=_GUICtrlListViewGetItemTextArray ($ListView, _GUICtrlListViewGetSelectedIndices($ListView))
		
		If $SelectedListItemData=0 Then Return ; Empty listview
		
		If StringStripWS($SelectedListItemData[4],1) <> "Unregistered" Then
			_GUICtrlStatusBarSetText ($StatusBar, "Selected share is " & '"' & StringStripWS($SelectedListItemData[4],1) & '"', 1)
		Else
			_GUICtrlStatusBarSetText ($StatusBar, "Selected share is " & '"' & $SelectedListItemData[3]& '"' & " (" & StringStripWS($SelectedListItemData[4],1) & " share)", 1)
		EndIf
		
		$ListViewContextMenu = GUICtrlCreateContextMenu ($ListView)
		
		If StringStripWS($SelectedListItemData[2],1)="NO" Then 
			$ConnectCTXTMENU=GUICtrlCreateMenuitem("Connect", $ListViewContextMenu)
			GUICtrlSetOnEvent(-1,"ControlConnect")
		ElseIf StringStripWS($SelectedListItemData[2],1)="YES" Then
			GUICtrlCreateMenuitem("Explore", $ListViewContextMenu)
			GUICtrlSetOnEvent(-1,"ExploreShare")
			GUICtrlCreateMenuitem("Disconnect", $ListViewContextMenu)
			GUICtrlSetOnEvent(-1,"ControlDisconnect")
		EndIf
				
		If StringStripWS($SelectedListItemData[4],1)="Unregistered" Then
			$ListViewContextManageItem= GUICtrlCreateMenuitem("Register", $ListViewContextMenu)
			GUICtrlSetOnEvent(-1,"ShareGUI")
		ElseIf StringStripWS($SelectedListItemData[4],1)<>"Unregistered" Then
			$ListViewContextManageItem= GUICtrlCreateMenuitem("Manage", $ListViewContextMenu)
			If StringStripWS($SelectedListItemData[2],1) = "YES" Then 
				GUICtrlSetState(-1,$GUI_DISABLE)
			Else
				GUICtrlSetState(-1,$GUI_ENABLE)
			EndIf
			GUICtrlSetOnEvent(-1,"ShareGUI")
		EndIf
		GUISetState()
	EndFunc
	
	Func AutoConnectShares() ; Perform an automatic connection if share has the Autoreconnect parameter checked
		If $RunAutoConnect="NO" Then Return ; Exit the function if Guicreation is called by the Restore option in Tray menu
		
		Local $AlreayConnected
		$ShareList=IniReadSection(StringLeft ( @ScriptFullPath, StringInStr ( @ScriptFullPath, ".",0,-1 ) )& "ini","Shares")
		If Not IsArray($ShareList) Then Return ; Share list empty => nothing to reconnect		
		$ConnectedDrives=IniReadSection(StringLeft ( @ScriptFullPath, StringInStr ( @ScriptFullPath, ".",0,-1 ) )& "ini","Connected")
		If Not IsArray($ConnectedDrives) Then ; No Autologon drives connected
			For $i=1 To $ShareList[0][0]
				If StringRight($ShareList[$i][1],1)=0 Then ;Autologon flag not set
					ContinueLoop
				Else ; Autologon flag set so connection must be done !!!
					$AutoConnect="YES"
					$ShareItems=StringSplit($ShareList[$i][1],",",1)
					$ShareLetter= $ShareItems[2]
					$Share=$ShareItems[1]
					$ShareNickName=$ShareList[$i][0]
					$ShareUser=$ShareItems[3]
					$SharePasswd=_StringEncrypt(0,$ShareItems[4],"ALE081993",1)
					$ShareRecon="YES"
					Call ("ControlConnect")
				EndIf
			Next
		Else ; registered shares are already connected => Verifiy which ones and connect the ones which aren't and whitch have the autologon flag)
			For $i=1 To $ShareList[0][0]
				If StringRight($ShareList[$i][1],1)=0 Then ;Autologon flag not set
					ContinueLoop
				Else ; Autologon flag set => Test if alreay connected must be done !!!
					For $j=1 To $ConnectedDrives[0][0]
						$AlreayConnected=""
						If $ConnectedDrives[$j][0]= $ShareList[$i][0] And $ConnectedDrives[$j][1]<>"" Then
							$AlreayConnected="YES"
							ExitLoop ; Already connected => Go to Next Share
						EndIf
					Next
					If 	$AlreayConnected="YES" Then
						ContinueLoop
					Else
						$AutoConnect="YES"
						$ShareItems=StringSplit($ShareList[$i][1],",",1)
						$ShareLetter= $ShareItems[2]
						$Share=$ShareItems[1]
						$ShareNickName=$ShareList[$i][0]
						$ShareUser=$ShareItems[3]
						$SharePasswd=_StringEncrypt(0,$ShareItems[4],"ALE081993",1)
						$ShareRecon="YES"
						Call ("ControlConnect")
					EndIf
				EndIf
			Next
		EndIf
	$AutoConnect="NO"	
	EndFunc
	
#endregion Main GUI
#region Internal Functions ; All functions related with Connect/Disconnect actions as well as refresh function
	Func Refresh()
		Local $CountDrives,$UnkCount,$Found,$ShareListRecord,$IniSections, $ActualConnectedDrives, $ActualRegisteredShares
		$CountDrives=0
		$UnkCount=0
		$Found=""
		;=== Compare values given by the ListViewRefresh functions with the values given by the Buildlistview (last modification)
		$Result=Call ("ListViewRefresh")
		$Result=StringSplit($Result,",",1)
		$ActualConnectedDrives=$Result[1]
		$ActualRegisteredShares=$Result[2]
		If $OldDrive = "" Then ; No Network drives connected
			TraySetToolTip($MainGuiTitle & @LF & "No Network Drive connected")
		ElseIf Not IsArray($ShareList) And $OldDrive <> "" Then
			TraySetToolTip($MainGuiTitle & @LF & $OldDrive[0] & " Unregistered Drive" & _Iif($OldDrive[0]>1,"s","") & " connected")
		EndIf
			
		If ($ActualConnectedDrives <> $BaseConnectedDrives) Or ($ActualRegisteredShares <> $BaseRegisteredShares)Then
			$Result=Call ("BuildListView")
			$Result=StringSplit($Result,",",1)
			$BaseConnectedDrives=$Result[1]
			$BaseRegisteredShares=$Result[2]
			
			If $OldDrive = "" Then ; No Network drives connected
				$ShareList=""
				If WinActive($MainGuiTitle) Then
					TraySetToolTip($MainGuiTitle & @LF & _NowDate ( ) & "-" & _NowTime(3))
					_GUICtrlStatusBarSetIcon($StatusBar, 0, "shell32.dll", $ReadyIcon)
					_GUICtrlStatusBarSetText ($StatusBar, "Ready", 0)
					_GUICtrlStatusBarSetText ($StatusBar, "No Network Drive connected", 1)
				Else
					TraySetToolTip($MainGuiTitle & @LF & "No Network Drive connected")
				EndIf
				
			ElseIf Not IsArray($ShareList) And $OldDrive <> "" Then ; Sharelist is empty and network volume(s) is/are connected
				If WinActive($MainGuiTitle) Then
					TraySetToolTip($MainGuiTitle & @LF & _NowDate ( ) & "-" & _NowTime(3))
					_GUICtrlStatusBarSetText ($StatusBar, "You're connected to " & $OldDrive[0] & " Unregistered Drive" & _Iif($OldDrive[0]>1,"s",""), 1)
				Else
					TraySetToolTip($MainGuiTitle & @LF & $OldDrive[0] & " Unregistered Drive" & _Iif($OldDrive[0]>1,"s","") & " connected")
				EndIf
			
			ElseIf IsArray($ShareList) And $OldDrive <> "" Then ; Sharelist is not empty and network volume(s) is/are connected
				For $i=1 to $OldDrive[0]
					$OldDriveInfo=DriveMapGet($OldDrive[$i])
					For $j=1 To $ShareList[0][0]
						$Found="YES"
						$ShareListRecord=StringSplit($ShareList[$j][1],",",1)
						If $ShareListRecord[1]=$OldDriveInfo Then
							$CountDrives=$CountDrives+1
							$State="CONNECTED"
							ExitLoop
						Else
							$State="NOTCON"
						EndIf
					Next
					$UnkCount=$OldDrive[0]-$CountDrives
				Next
				If $UnkCount <>0 Then
					If WinActive($MainGuiTitle)Then
						TraySetToolTip($MainGuiTitle & @LF & _NowDate ( ) & "-" & _NowTime(3))
						_GUICtrlStatusBarSetText ($StatusBar, "You're connected to " & $CountDrives & " Registered Drive" & _Iif($CountDrives>1,"s","") & " And " & $UnkCount & " Unregistered Drive" & _Iif($UnkCount>1,"s",""), 1)
					Else
						TraySetToolTip($MainGuiTitle & @LF & $CountDrives & " Registered Drive" & _Iif($CountDrives>1,"s","") & "connected" & @LF & $UnkCount & " Unregistered Drive" & _Iif($UnkCount>1,"s","") & "connected")
					EndIf
				Else
					If WinActive($MainGuiTitle)Then
						TraySetToolTip($MainGuiTitle & @LF & _NowDate ( ) & "-" & _NowTime(3))
						_GUICtrlStatusBarSetText ($StatusBar, "You're connected to " & $CountDrives & " Registered Drive" & _Iif($CountDrives>1,"s",""), 1)
					Else
						TraySetToolTip($MainGuiTitle & @LF & $CountDrives & " Registered Drive" & _Iif($CountDrives>1,"s","") & "connected")
					EndIf
				EndIf
			EndIf
		EndIf
	EndFunc

	Func ExploreShare()
		Run("explorer.exe" & " " & $SelectedListItemData[3] & ",/N")	
	EndFunc

	Func ControlConnect()
		GUICtrlSetState($ListView,$GUI_DISABLE)
		If $AutoConnect <> "YES" Then Call ("ShareGetInfo")
		If $Share="" Then $Share='" ' & "Undetermined share..." & ' "'
		_GUICtrlStatusBarSetIcon($StatusBar, 0, "shell32.dll", $ProcessingIcon)
		_GUICtrlStatusBarSetText ($StatusBar, "Working", 0)
		_GUICtrlStatusBarSetText ($StatusBar, "Attempting to connect to " & '"' & $ShareNickName & '"', 1)
		Sleep(700)
		Call ("Connect")
		GUICtrlDelete($ListViewContextMenu)
	EndFunc
	
	Func ControlDisconnect()
		GUICtrlSetState($ListView,$GUI_DISABLE)
		Call ("ShareGetInfo")
		_GUICtrlStatusBarSetIcon($StatusBar, 0, "shell32.dll", $ProcessingIcon)
		_GUICtrlStatusBarSetText ($StatusBar, "Working", 0)
		If $ShareNickName <> "Unregistered" Then
			_GUICtrlStatusBarSetText ($StatusBar, "Disconnecting from " & '"' & $ShareNickName & '"', 1)
		Else
			_GUICtrlStatusBarSetText ($StatusBar, "Disconnecting from " & '"' &  $ShareLetter & '"' &  " (" & $ShareNickName & " share)", 1)
		EndIf
		Sleep(700)
		Call ("Disconnect")
		GUICtrlDelete($ListViewContextMenu)
	EndFunc

	Func Connect()
		$Result = Call ("CheckConnect"); vérifie que le partage n'est pas déjà actif sur une autre lette et effectue la connexion
		
		;If $Result <> "YES" and $Result <> "" Then
		If $Drive="" Or $Drive=0 Then
			_GUICtrlStatusBarSetIcon($StatusBar, 0, "shell32.dll", 219)
			_GUICtrlStatusBarSetText ($StatusBar, "Error !", 0)
			_GUICtrlStatusBarSetText ($StatusBar, "Connection to " & '"' & $ShareNickName & '"' & "  failed" & "  (Reason : " & $Result & ")", 1)
			Sleep(4000)
			$Share=""
			_GUICtrlStatusBarSetIcon($StatusBar, 0, "shell32.dll", $ReadyIcon)
			_GUICtrlStatusBarSetText ($StatusBar, "Ready", 0)
			_GUICtrlStatusBarSetText ($StatusBar, "Use " & '"' &  " Tools " & '"' & " Menu or Select an item in list (left click) and than right click to diplay context menu...", 1)
		Else
			_GUICtrlStatusBarSetIcon($StatusBar, 0, "shell32.dll", $ConnectIcon)
			_GUICtrlStatusBarSetText ($StatusBar, "Done", 0)
			_GUICtrlStatusBarSetText ($StatusBar, "Connected to " & '"' & $ShareNickName & '"', 1)
			Sleep(1000)
			_GUICtrlStatusBarSetIcon($StatusBar, 0, "shell32.dll", $ReadyIcon)
			_GUICtrlStatusBarSetText ($StatusBar, "Ready", 0)
			_GUICtrlStatusBarSetText ($StatusBar, "Use " & '"' &  " Tools " & '"' & " Menu or Select an item in list (left click) and than right click to diplay context menu...", 1)
		EndIf
		GUICtrlSetState($ListView,$GUI_ENABLE)
		Refresh() ; Force refresh
	EndFunc

	Func CheckConnect(); ===== Check if network share already exist=====
	Local $Laps,$Error,$Extended
		$Error=""
		$Isconnected=""
		$Laps=0
		$OldDrive=DriveGetDrive ( "NETWORK" )
		$Error=@error
		If IsArray($OldDrive) Then ; Disconnect any similar and already connected drive
			For $i=1 to $OldDrive[0]
				Do
				$OldDriveInfo=DriveMapGet($OldDrive[$i])
				Until $OldDriveInfo <>""
				
				If $OldDriveInfo = $Share And $OldDrive[$i] = $ShareLetter Then
					DriveMapDel($OldDrive[$i]); Si oui alors déconnexion du partage (évite les multiples connexions au même partage)
					Sleep(200)
				EndIf
				If $OldDrive[$i] = $ShareLetter And $OldDriveInfo <> $Share Then
					$Isconnected="NO"
					ExitLoop
				EndIf	
				
			Next
		EndIf
		If $Shareletter="" Or $ShareLetter="0" Then $ShareLetter="*"
		$Drive= DriveMapAdd($ShareLetter,$Share,0,$ShareUser,$SharePasswd) ; Connexion en utilisant la première lettre de lecteur disponible
		$Error=@error
		$Extended=@extended
		Do
			$DriveStatus = DriveStatus ($Drive)
			
			If $DriveStatus="READY" And $Drive <> "" Then 
				$IsConnected = "YES"
				ExitLoop
			ElseIf $DriveStatus="READY" And $Drive = "" Then 
				$IsConnected = "Drive not ready"
			ElseIf $DriveStatus="NOTREADY" Or $DriveStatus="INVALID"Then 
				$IsConnected = "Drive is " & $DriveStatus
			EndIf
			$Laps=$Laps+1
		Until $IsConnected = "YES" Or $Laps=10; sortie de la boucle si connecté
		
		If $Drive=1 Or $IsConnected = "YES" Then ; Mapping fait...
			Return $IsConnected; retour à la fonction appelante
		ElseIf $IsConnected <> "YES" Then	; Mapping non fait ($Laps=10 soit dix tours de boucle d'attente)
			Switch $Error
				Case 0 To 1
					If $Extended = 53 Then
						$IsConnected = "Path not found"
					ElseIf $Extended = 54 Then
						$IsConnected = "Network is busy"
					ElseIf $Extended = 57 Then
						$IsConnected = "Adapter hardware error"
					ElseIf $Extended = 59 Then
						$IsConnected = "Unexpected network error"
					ElseIf $Extended = 71 Then
						$IsConnected = "Connections limit exceeded"
					ElseIf $Extended = 69 Then
						$IsConnected = "Bios sessions limit exceeded"
					ElseIf $Extended = 1220 Then
						$IsConnected = "Concurrent sessions limit exceeded"
					ElseIf $Extended = 1231 Then
						$IsConnected = "Network not active"
					ElseIf $Extended = 1326 Then
						$IsConnected = "Invalid user/password"
					ElseIf $Extended = 2202 Then
						$IsConnected = "Invalid user name"
					ElseIf $Extended = 1327 Then
						$IsConnected = "Account restricted"
					ElseIf $Extended = 1328 Then
						$IsConnected = "Invalid logon hours"
					ElseIf $Extended = 1330 Then
						$IsConnected = "Password expired"
					ElseIf $Extended = 1331 Then
						$IsConnected = "Account disabled"
					ElseIf $Extended = 1238 Then
						$IsConnected = "Concurrent connections limit exceeded"
					Else
						$IsConnected = "Undetermined error"
					EndIf
				Case 2
					$IsConnected = "Access denied"
				Case 3
					$IsConnected = "Drive already assigned"
				Case 4
					$IsConnected = "Invalid device name"
				Case 5
					$IsConnected = "Invalid remote share format"
				Case 6
					$IsConnected = "Invalid password"
			EndSwitch
			DriveMapDel($Drive)
			Return $Isconnected ; retourne 0 si non comnecté
		EndIf
	EndFunc

	Func Disconnect()
		DriveMapDel($Shareletter)
		_GUICtrlStatusBarSetIcon($StatusBar, 0, "shell32.dll", $DisconnectIcon)
		_GUICtrlStatusBarSetText ($StatusBar, "Done", 0)
		If $ShareNickName <> "Unregistered" Then
			_GUICtrlStatusBarSetText ($StatusBar, "Disconnected from " & '"' & $ShareNickName & '"', 1)
		Else
			_GUICtrlStatusBarSetText ($StatusBar, "Disconnected from " & '"' &  $ShareLetter & '"' &  " (" & $ShareNickName & " share)", 1)
		EndIf
		Sleep(1000)
		_GUICtrlStatusBarSetIcon($StatusBar, 0, "shell32.dll",  $ReadyIcon)
		_GUICtrlStatusBarSetText ($StatusBar, "Ready", 0)
		_GUICtrlStatusBarSetText ($StatusBar, "Use " & '"' &  " Tools " & '"' & " Menu or Select an item in list (left click) and than right click to diplay context menu...", 1)
		GUICtrlSetState($ListView,$GUI_ENABLE)
		Refresh() ; Force refresh
	EndFunc

	Func About()
		$Msg=@LF & _
		"This simple tool has been designed to allow you to perform easy network drive mapping." & @LF & _
		"You can either automatically connect to or disconnet from network drives and also manage your share list." & @LF & @LF & _
		"The Autor is verry happy to share this small and TOTALLY FREE tool with you !" & @LF & _
		"For any comments or suggestions, please contact " & ' "' & "christophe.savard@fr.ibm.com" & '"' & @LF & @LF & _
		"                                                               Enjoy your use..." & @LF & @LF & _
		"Developed with Autoit V-" & FileGetVersion(@ScriptName)
		MsgBox(64+262144,$MainGuiTitle,$Msg)
	EndFunc

	Func Quit()
			$MainGUIState = "OK"
			If @GUI_WinHandle=$SharesGUI And (@GUI_CtrlId=$DeleteBut Or @GUI_CtrlId=$ValidateBut) Then
				GUISetState(@SW_SHOW,$MainGui)
				GUIDelete($SharesGUI)
			ElseIf @GUI_WinHandle=$SharesGUI And @GUI_CtrlId=$CancelBut Then
				GUISetState(@SW_SHOW,$MainGui)
				GUIDelete($SharesGUI)
			EndIf
	EndFunc

	Func ExitPrgm()
		Exit
	EndFunc
	
	Func Message($Msg)
		MsgBox(0+64+262144,$MainGuiTitle,$Msg,3)
	EndFunc

	Func OnAutoItExit()
		
	EndFunc
#endregion Internal Functions

#region Register/Manage Share GUI ; All functions related with Share management
	Func ShareGUI()
		$MainGUIState = "NOK"
		GUICtrlDelete($ListViewContextMenu)
		Local $CtrlId
		$CtrlId=@GUI_CtrlId
		$FreeDrives=Call ("GetFreeDrivesList")
		$Left=20
		$Top=10
		$CtrlHeigth=20
		$CtrlWidth=90
		If StringInStr(GUICtrlRead($CtrlId,1),"Register New Share",1) Or GUICtrlRead($CtrlId,1)="Register" Then	; New share register is requested
			$ShareGuiTitle="Create a New Share"
			$ShareNickName=""
			If StringInStr(GUICtrlRead($CtrlId,1),"Register New Share",1) Then
				$Share=""
				$ShareLetter=""
			Else
				$Share=StringStripWS($SelectedListItemData[5],1)
				$ShareLetter=StringStripWS($SelectedListItemData[3],1)
			EndIf
			$ShareUser=""
			$SharePasswd=""
		
		ElseIf GUICtrlRead($CtrlId,1)="Manage" Then; Manage existing share using context Menu
			$ShareGuiTitle="Manage Share"
			$Shareletter=StringStripWS($SelectedListItemData[3],1)
			If StringInStr($ShareLetter,"[",0,1) Then ; Remove brackets if necessary
				$ShareLetter=StringRegExpReplace($ShareLetter,"[][]","",2)
			EndIf
			If $ShareLetter="*" And GUICtrlRead(@GUI_CtrlId,1) = "Manage" Then $ShareLetter="(none)"
			$Share=StringStripWS($SelectedListItemData[5],1)
			$ShareNickName=StringStripWS($SelectedListItemData[4],1)
			$ShareUser=StringStripWS($SelectedListItemData[6],1)
			$SharePasswd=IniRead(StringLeft ( @ScriptFullPath, StringInStr ( @ScriptFullPath, ".",0,-1 ) ) &"ini","Shares",$ShareNickName,"")
			$SharePasswd=StringSplit($SharePasswd,",",1)
			$SharePasswd=_StringEncrypt(0,$SharePasswd[4],"ALE081993",1)
			$ShareRecon=StringStripWS($SelectedListItemData[7],1)
		EndIf
				
		If GUICtrlRead($CtrlId,1) <> "Register New Share" Then 
			Call("ShareGetInfo")
			GUISetState(@SW_HIDE,$MainGui)
			IniDelete(StringLeft ( @ScriptFullPath, StringInStr ( @ScriptFullPath, ".",0,-1 ) ) &"ini","Shares",$ShareNickName)
		Else ; Register has been launched from tools menu
			$ShareNickName=""
			$Share=""
			$ShareLetter=""
			$ShareUser=""
			$SharePasswd=""
		EndIf
		; Extracts the shareletter from the freedrive list recombining before and after strings
		$Start=StringInStr($FreeDrives,$ShareLetter,0,1)
		$Extract=StringMid($FreeDrives,$Start)
		$End=StringInStr($Extract,"|",0,1)+($Start-1)
		$FreeDrives=StringMid($FreeDrives,1,$Start-1) & StringMid($FreeDrives,$End+1)
		;=====================================================
		$SharesGUI=GUICreate($ShareGuiTitle,$GuiWidth-150,$GuiHeight+60)
		GUISetBkColor ($GuiColor)
		GUISetOnEvent($GUI_EVENT_CLOSE,"Quit")
		$NickNameLbl=GUICtrlCreateLabel("Share Nickname (*)",$Left,$Top,$CtrlWidth+30,$CtrlHeigth)
		GUICtrlSetTip(-1,"What you input here will be displayed in menus" & @LF & "and will be used to identify the share." & @LF & "Therefore use a significant name !",StringLeft(GUICtrlRead(-1,1),StringInStr(GUICtrlRead(-1,1)," (")-1),1,1)
		$Top=$Top+15
		$InputNickName=GUICtrlCreateInput($ShareNickName,$Left,$Top,$GuiWidth-320,$CtrlHeigth)
		GUICtrlSetLimit(-1,20)
		$Top=$Top+25
		$NameLbl=GUICtrlCreateLabel("Share Name (*)",$Left,$Top,$CtrlWidth,$CtrlHeigth)
		GUICtrlSetTip(-1,"Enter here the share name using the regular expression" & @LF & '"' &  "\\Server\Share" & '"',StringLeft(GUICtrlRead(-1,1),StringInStr(GUICtrlRead(-1,1)," (")-1),1,1)
		$Top=$Top+15
		$NameInput=GUICtrlCreateInput($Share,$Left,$Top,$GuiWidth-200,$CtrlHeigth)
		GUICtrlSetTip(-1,"Enter here the share name using the regular expression" & @LF & '"' &  "\\Server\Share" & '"',StringLeft(GUICtrlRead(-1,1),StringInStr(GUICtrlRead(-1,1)," (")-1),1,1)
		$Top=$Top+25
		$LetterLbl=GUICtrlCreateLabel("Drive Letter",$Left,$Top,$CtrlWidth,$CtrlHeigth)
		GUICtrlSetTip(-1,"If blank the first available letter will be assigned on connection.",GUICtrlRead(-1,1),1,1)
		$Top=$Top+15
		If $ShareLetter="*" Then
			$LetterInput=GUICtrlCreateCombo("(none)",$Left,$Top,130,$CtrlHeigth+150,BitOr($GUI_SS_DEFAULT_COMBO,$CBS_NOINTEGRALHEIGHT,$CBS_DROPDOWNLIST))
		Else
			$LetterInput=GUICtrlCreateCombo($ShareLetter,$Left,$Top,130,$CtrlHeigth+150,BitOr($GUI_SS_DEFAULT_COMBO,$CBS_NOINTEGRALHEIGHT,$CBS_DROPDOWNLIST))
		EndIf
		
		GUICtrlSetData(-1,$FreeDrives)
		$RefreshDriveListBut=GUICtrlCreateButton("Refresh List",$Left+140,$Top,$CtrlWidth,$CtrlHeigth+3)
		GUICtrlSetOnEvent(-1,"DriveListRefresh")
		$Top=$Top+25
		$UserLbl=GUICtrlCreateLabel("User Name",$Left,$Top,$CtrlWidth,$CtrlHeigth)
		GUICtrlSetTip(-1,"If not indicated, the logon window will be displayed" & @LF & "Advise : Fillup this field when using Auto reconnect option",GUICtrlRead(-1,1),1,1)
		$Top=$Top+15
		$UserInput=GUICtrlCreateInput($ShareUser,$Left,$Top,70,$CtrlHeigth,$ES_UPPERCASE)
		GUICtrlSetOnEvent(-1,"CheckInput")
		GUICtrlSetLimit(-1,8)
		$Top=$Top-15
		$PwdLbl=GUICtrlCreateLabel("Password",$Left+90,$Top,$CtrlWidth,$CtrlHeigth)
		$Top=$Top+15
		$PwdInput=GUICtrlCreateInput($SharePasswd,$Left+90,$Top,70,$CtrlHeigth,$ES_PASSWORD)
		GUICtrlSetOnEvent(-1,"CheckInput")
		GUICtrlSetState ( -1, $GUI_DISABLE )
		GUICtrlSetLimit(-1,9)
		$RevealPwdBut=GUICtrlCreateButton("Verify Password",$Left+175,$Top,$CtrlWidth,$CtrlHeigth)
		GUICtrlSetOnEvent(-1,"RevealPasswd")
		$Top=$Top+25
		$AutoConnect=GUICtrlCreateCheckbox("Auto Reconnect",$Left,$Top)
		GUICtrlSetTip(-1,"Check this box if you want the share to be automatically reconnected at programm startup",GUICtrlRead(-1,1),1,1)
		GUICtrlSetState ( -1, $GUI_DISABLE )
		If $ShareUser <> "" Then
			GUICtrlSetState ( $PwdInput, $GUI_ENABLE )
			If $ShareRecon="YES" Then 
				GUICtrlSetState ($AutoConnect,BitOR ($GUI_ENABLE,$GUI_CHECKED ))
			Else
				GUICtrlSetState ($AutoConnect,BitOR ($GUI_ENABLE,$GUI_UNCHECKED ))
			EndIf
		Else
			GUICtrlSetState ($PwdInput, $GUI_DISABLE )
			GUICtrlSetState ($AutoConnect,BitOR ($GUI_DISABLE,$GUI_UNCHECKED ))
			ControlFocus($ShareGuiTitle,"",$ValidateBut)
		EndIf
		$Top=$Top+35
		If $ShareGuiTitle="Create a New Share" Then
			$ValidateBut=GUICtrlCreateButton("Validate",$Left,$Top,80,30)
		ElseIf $ShareGuiTitle="Manage Share" Then
			$ValidateBut=GUICtrlCreateButton("Update",$Left,$Top,80,30)
		EndIf
		GUICtrlSetOnEvent(-1,"ValidateShare")
		GUICtrlSetFont(-1,-1,600)
		If $ShareGuiTitle="Create a New Share" Then
			GUICtrlSetTip(-1,"Create an entry in the share list",GUICtrlRead(-1,1),1,1)
		ElseIf $ShareGuiTitle="Manage Share" Then
			GUICtrlSetTip(-1,"Update entry in the share list",GUICtrlRead(-1,1),1,1)
		EndIf
		$CancelBut=GUICtrlCreateButton("Cancel",$Left+100,$Top,80,30)
		GUICtrlSetOnEvent(-1,"ValidateShare")
		GUICtrlSetFont(-1,-1,600)
		GUICtrlSetTip(-1,"Cancel you inputs (if any) and close this GUI",GUICtrlRead(-1,1),1,1)
		If $ShareGuiTitle="Manage Share" Then
		$DeleteBut=GUICtrlCreateButton("Delete",$Left+200,$Top,80,30)
			GUICtrlSetOnEvent(-1,"ValidateShare")
			GUICtrlSetFont(-1,-1,600)
			GUICtrlSetTip(-1,"Deleting a share will only remove it from the list" & @LF & "and will not disconnect it (if connected)",GUICtrlRead(-1,1),1,1)
		EndIf
		GUICtrlCreateLabel("(*) = Mandatory Field",$Left,$Top+40)
		GUISetState(@SW_SHOW,$ShareGuiTitle)
	EndFunc
	
	Func RevealPasswd()
		$Msg=Guictrlread($PwdInput)
		If $Msg="" Then
			Call("Message","In order to verify a password must be typed !")
		Else
			Call("Message","The password for this share is " & '" ' & $Msg & ' "' & @LF & @LF & "Remark : Password is case sensitive")
		EndIf
	EndFunc
	
	Func ShareGetInfo() ; Gets share informations...
		$ShareList=IniReadSection(StringLeft ( @ScriptFullPath, StringInStr ( @ScriptFullPath, ".",0,-1 ) ) &"ini","Shares")
		$SelectedListItemData=_GUICtrlListViewGetItemTextArray ($ListView, _GUICtrlListViewGetSelectedIndices($ListView))
		
		If GUICtrlRead(@GUI_CtrlId,1)= "Connect" Or GUICtrlRead(@GUI_CtrlId,1)= "Disconnect" Or GUICtrlRead(@GUI_CtrlId,1)= "Manage" Then
			$ShareLetter= StringStripWS($SelectedListItemData[3],1)
			If StringInStr($ShareLetter,"[",0,1) Then ; Remove brackets if necessary
				$ShareLetter=StringRegExpReplace($ShareLetter,"[][]","",2)
			EndIf
			If $ShareLetter="*" And GUICtrlRead(@GUI_CtrlId,1) = "Manage" Then $ShareLetter="(none)"
			$Share=StringStripWS($SelectedListItemData[5],1)
			$ShareNickName=StringStripWS($SelectedListItemData[4],1)
			$ShareUser=StringStripWS($SelectedListItemData[6],1)
			$SharePasswd=IniRead(StringLeft ( @ScriptFullPath, StringInStr ( @ScriptFullPath, ".",0,-1 ) ) &"ini","Shares",$ShareNickName,"")
			$SharePasswd=StringSplit($SharePasswd,",",1)
			If GUICtrlRead(@GUI_CtrlId,1)= "Connect" Or GUICtrlRead(@GUI_CtrlId,1)= "Manage" Then
				$SharePasswd=_StringEncrypt(0,$SharePasswd[4],"ALE081993",1)
				$ShareRecon=StringStripWS($SelectedListItemData[7],1)
			EndIf
		EndIf

		If IsArray($SelectedListItemData) And StringStripWS($SelectedListItemData[4],1)= "Register" Then
			$ShareLetter= StringStripWS($SelectedListItemData[3],1)
			If StringInStr($ShareLetter,"[",0,1) Then ; Remove brackets if necessary
				$ShareLetter=StringRegExpReplace($ShareLetter,"[][]","",2)
			EndIf
			$Share=StringStripWS($SelectedListItemData[5],1)
			$ShareNickName=""
			$ShareUser=""
			$SharePasswd=""
			$ShareRecon=""
		EndIf
	EndFunc
	
	Func GetFreeDrivesList()
		Local $ReservedLetters,$UsedDriveLetters,$DriveInfo,$UsedLetters,$LetterList,$LetterOnly,$Flag
		$UsedDriveLetters=DriveGetDrive("ALL")
		If Not IsArray ($Sharelist) Then
			$ReservedLetters=""
		Else
			$ReservedLetters=""
			For $i=1 to $Sharelist[0][0]
				$ShareListRecord=StringSplit($ShareList[$i][1],",",1)
				If $ShareListRecord[2] <> "" And $i < $Sharelist[0][0] Then
					$ReservedLetters=$ReservedLetters & $ShareListRecord[2] & ":|"
				ElseIf $ShareListRecord[2] <> "" And $i = $Sharelist[0][0] Then
					$ReservedLetters=$ReservedLetters & $ShareListRecord[2]
				EndIf
			Next
		EndIf
		$UsedLetters=""
		$DriveInfo=""
		$LetterList=""
		$LettersOnly=""
	
		For $i=1 to $UsedDriveLetters[0] ; Already assigned letters building loop
			$DriveInfo= DriveMapGet($UsedDriveLetters[$i])
			If DriveGetType ($UsedDriveLetters[$i]) <> "NETWORK" Then $DriveInfo = "Not Assignable (Local Drive)"
					
			If $i=$UsedDriveLetters[0] Then
				$UsedLetters=$UsedLetters & StringUpper($UsedDriveLetters[$i]) & "   " & $DriveInfo
			Else
				$UsedLetters=$UsedLetters & StringUpper($UsedDriveLetters[$i]) & "   " & $DriveInfo &  "|"
			EndIf
		Next
		
		$UsedLetters=StringSplit($UsedLetters,"|",1) ; Splits the result of previous loop into an array containing distinct records
		
		
		For $i=90 to 65 Step -1 ; Test the complete alphabet list starting Z letter
			For $j=$UsedLetters[0] To 1 Step -1
				$Flag=""
				If Chr($i) = StringLeft($UsedLetters[$j],1) Then
					If StringInStr($UsedLetters[$j],"Not Assignable") Then
						ExitLoop ; Exlcude local drives letters
					Else
						If $i=65 Then
							$LetterList=$LetterList & $UsedLetters[$j] & "|" & "(none)"
						Elseif $i > 65 Then
							$LetterList=$LetterList & $UsedLetters[$j] & "|"
						EndIf
						ExitLoop
					EndIf
				EndIf
				
				$Flag="FREE"
			Next
			
			If $Flag = "FREE" Then ; List assigned network letters and free letters
				If $i=65 Then
					If StringInStr($ReservedLetters,Chr($i),0,1) Then
						$LetterList=$LetterList & Chr($i) & ":" & "   "  & "(Reserved)"& "|" & "(none)"
					Else							
						$LetterList=$LetterList & Chr($i) & ":" & "|" & "(none)"
					EndIf
				Else
					If StringInStr($ReservedLetters,Chr($i),0,1) Then
						$LetterList=$LetterList & Chr($i) & ":" & "   "  & "(Reserved)"& "|"
					Else							
						$LetterList=$LetterList & Chr($i) & ":" & "|"
					EndIf
				EndIf
			Else
				ContinueLoop
			EndIf
		Next
		Return $LetterList
	EndFunc
	
	Func CheckInput()
		Local $CtrlID
		$CtrlID=@GUI_CtrlId
		
		If StringStripWS(Guictrlread($InputNickName),8) = "" Then
			$Msg="A Nickname must be given !"
			Call("Message",$Msg)
			ControlFocus($ShareGuiTitle,"",$InputNickName)	
			Return
		EndIf
		
		If StringStripWS(Guictrlread($NameInput),8) = "" Then
			$Msg="A valid share name must be given !"
			Call("Message",$Msg)
			ControlFocus($ShareGuiTitle,"",$NameInput)	
			Return
		EndIf
		
		If $CtrlID = $UserInput Then
			If GUICtrlRead($UserInput) <> "" Then 
				GUICtrlSetState ($PwdInput,$GUI_ENABLE)
				GUICtrlSetState ($AutoConnect,$GUI_ENABLE)
				ControlFocus($ShareGuiTitle,"",$PwdInput)	
				Return
			Else
				GUICtrlSetState ($PwdInput,$GUI_DISABLE)
				GUICtrlSetData($PwdInput,"")
				GUICtrlSetState ($AutoConnect,BitOR ($GUI_DISABLE,$GUI_UNCHECKED ))
				ControlFocus($ShareGuiTitle,"",$ValidateBut)	
				Return
			EndIf
		EndIf
		
		If $CtrlID = $PwdInput And StringLen(Guictrlread($PwdInput)) < 8 Then
				$Msg="Password must contain 8 caracters !"
				Call("Message",$Msg)
				Return
		EndIf
			
	EndFunc
	
	Func ValidateShare() ; Function called just after validate a share Creation/modification/deletion
		
		Local $CtrlID
		$CtrlID=@GUI_CtrlId
		If $CtrlID = $CancelBut And $ShareGuiTitle="Create a New Share" then ; Cancel New Share creation
			Call ("Quit")
			Return
		ElseIf $CtrlID = $CancelBut And $ShareGuiTitle="Manage Share" then ; Cancel Manage Share => Write initial values
			If $Shareletter="(none)" Then $Shareletter=""
			$SharePasswd=_StringEncrypt(1,$SharePasswd,"ALE081993",1)
			If $ShareRecon="NO" Then
				$ShareRecon="0"
			Else
				$ShareRecon="1"
			EndIf
			IniWrite(StringLeft ( @ScriptFullPath, StringInStr ( @ScriptFullPath, ".",0,-1 ) ) & "ini","Shares",$ShareNickName,$Share&","& $ShareLetter & "," & $ShareUser & "," & $SharePasswd & "," & $ShareRecon)
			Call ("Quit")
			Return
		EndIf
		
		If $CtrlID = $DeleteBut Or Guictrlread($CtrlID,1)="Unregister" Then ; Share unregister has been asked
			Local $Response
			If Guictrlread($CtrlID,1)="Unregister" Then $InputNickName=$SelectedListItemData[4] ; Request comes from Listview
			$Response=Msgbox(4+32+262144,"Unregister share " & '"' & Guictrlread($InputNickName) & '"', "You're about to remove " & '"' & Guictrlread($InputNickName) & '"' & " from the share list."& @LF & "          Is this realy what you want to do ?")
			If $Response=7 Then ; No has been clicked
				Return
			ElseIf $Response=6 Then ; Yes has been clicked
				For $i=1 to $ShareList[0][0]
					If $ShareList[$i][0]=Guictrlread($InputNickName)Then
						IniDelete(StringLeft ( @ScriptFullPath, StringInStr ( @ScriptFullPath, ".",0,-1 ) )& "ini","Shares",$ShareList[$i][0]) ; Deletes entry in the share list
						ExitLoop
					EndIf
				Next
			EndIf
			;Refresh() ; Force  refresh list view
			Call ("Quit")
			Return
		EndIf
		
		
		If $ShareGuiTitle="Create a New Share" Or $ShareGuiTitle="Manage Share" Then ; Checks inputs if Share creation is requested
		
			If $ShareGuiTitle="Create a New Share" And StringStripWS(Guictrlread($InputNickName),8) = "" Then
				$Msg="A Nickname must be given !"
				Call("Message",$Msg)
				ControlFocus($ShareGuiTitle,"",$InputNickName)	
				Return
			ElseIf StringStripWS(Guictrlread($InputNickName),8) <> "" Then ; Control if Nickname not already in use
				$ShareList=IniReadSection(StringLeft ( @ScriptFullPath, StringInStr ( @ScriptFullPath, ".",0,-1 ) ) & "ini","Shares")
				If IsArray($ShareList) Then ; Share List is not empty
					For $i=1 to $ShareList[0][0]
						If Guictrlread($InputNickName) = $ShareList[$i][0] And Not StringInStr (  $NameInput, $ShareList[$i][1] ,0,1) Then ; Nickname already in use...
							$Msg="Nickmane is already in use... Please modify !"
							Call("Message",$Msg)
							GUICtrlSetData($InputNickName,"")
							ControlFocus($ShareGuiTitle,"",$InputNickName)	
							Return
						EndIf
					Next
				EndIf
			EndIf
			
			If StringStripWS(Guictrlread($NameInput),8) = "" Then
				$Msg="A valid share name must be given !"
				Call("Message",$Msg)
				ControlFocus($ShareGuiTitle,"",$NameInput)	
				Return
			EndIf
			
			If StringStripWS(Guictrlread($UserInput),8) = "" Then
				$Msg="A User name is mandatory !"
				Call("Message",$Msg)
				ControlFocus($ShareGuiTitle,"",$UserInput)	
				Return
			EndIf
			
			If StringStripWS(Guictrlread($PwdInput),8) = "" Then
				$Msg="A Password is mandatory !"
				Call("Message",$Msg)
				GUICtrlSetState($PwdInput,$GUI_ENABLE)
				ControlFocus($ShareGuiTitle,"",$PwdInput)	
				Return
			EndIf
			
			If Not FileExists(StringLeft ( @ScriptFullPath, StringInStr ( @ScriptFullPath, ".",0,-1 ) )& "ini") Then ; Test if Ini file containing share list already exist or not
				IniWriteSection(StringLeft ( @ScriptFullPath, StringInStr ( @ScriptFullPath, ".",0,-1 ) )& "ini","Shares","") ; Creates file and add a blank share section
				IniWriteSection(StringLeft ( @ScriptFullPath, StringInStr ( @ScriptFullPath, ".",0,-1 ) )& "ini","Connected","") ; Creates file and add a blank Connected section
			EndIf
		EndIf
			
		If $ShareGuiTitle="Manage Share" Then; Checks inputs if Share Modification/deletion is requested
			$Result=Call ("ShareMoficationControl"); Looks for modifications comparing inputs with original values on GUI load
			If $Result = "NO" Then ; No modification done
				$Msg="No modification has been done !!! "
				Call("Message",$Msg)
				Return
			ElseIf $Result="" Then
				Return
			Else
				IniDelete(StringLeft ( @ScriptFullPath, StringInStr ( @ScriptFullPath, ".",0,-1 ) ) & "ini","Shares",Guictrlread($InputNickName))
				Refresh() ; Force  refresh list view
			EndIf
		EndIf
		
		;============= COMON CODE TO CREATE AND MANAGE SHARES ===============================================================================
		If StringStripWS(Guictrlread($LetterInput),8) = "(none)" Then GUICtrlSetData($LetterInput,"")
		
		If GUICtrlRead($AutoConnect)=$GUI_CHECKED Then ; Creates/Update entry
			$ShareRecon=1
		Else
			$ShareRecon=0
		EndIf
		IniWrite(StringLeft ( @ScriptFullPath, StringInStr ( @ScriptFullPath, ".",0,-1 ) ) & "ini","Shares",Guictrlread($InputNickName),Guictrlread($NameInput)&","& Guictrlread($LetterInput) & "," & Guictrlread($UserInput) & "," & _StringEncrypt(1,Guictrlread($PwdInput),"ALE081993",1) & "," & $ShareRecon)
		;=====================================================================================================================================
		Call ("Quit")
	Endfunc
	
	Func ShareMoficationControl()
		Local $ModifFlag
		$ModifFlag=""
		If Guictrlread($InputNickName)=$ShareNickName Then 
			$ModifFlag="NO"
		Else
			If Guictrlread($InputNickName)="" Then
				$Msg="You cannot suppress the nickname !"
				Call("Message",$Msg)
				ControlFocus($ShareGuiTitle,"",$InputNickName)	
				$ModifFlag=""
				Return $ModifFlag
			EndIf
			$ModifFlag="YES"
			Return $ModifFlag
		EndIf
		If Guictrlread($NameInput)=$Share Then
			$ModifFlag="NO"
		Else
			If Guictrlread($NameInput)="" Then
				$Msg="You cannot suppress the share name !"
				Call("Message",$Msg)
				ControlFocus($ShareGuiTitle,"",$NameInput)	
				$ModifFlag=""
				Return $ModifFlag
			EndIf
			$ModifFlag="YES"
			Return $ModifFlag
		EndIf
		If Guictrlread($LetterInput)=$ShareLetter Then
			$ModifFlag="NO"
		Else
			If StringInStr(Guictrlread($LetterInput),"Reserved",0,1) Then
				$Msg="This drive letter is already assigned !"
				Call("Message",$Msg)
				GUICtrlSetData($LetterInput,"")
				DriveListRefresh()
				ControlFocus($ShareGuiTitle,"",$LetterInput)	
				$ModifFlag=""
				Return $ModifFlag
			EndIf
			$ModifFlag="YES"
			Return $ModifFlag
		EndIf
		If Guictrlread($UserInput)=$ShareUser Then
			$ModifFlag="NO"
		Else
			If StringLen(Guictrlread($ShareUser))=0 Then
				$Msg="You cannot suppress the User name !"
				Call("Message",$Msg)
				ControlFocus($ShareGuiTitle,"",$ShareUser)	
				$ModifFlag=""
				Return $ModifFlag
			EndIf
			$ModifFlag="YES"
			Return $ModifFlag
		EndIf
		If Guictrlread($PwdInput)=_StringEncrypt(0,$SharePasswd,"ALE081993",1) Then
			$ModifFlag="NO"
		Else
			If Guictrlread($PwdInput)="" Then
				$Msg="You cannot suppress the Password !"
				Call("Message",$Msg)
				ControlFocus($ShareGuiTitle,"",$PwdInput)	
				$ModifFlag=""
				Return $ModifFlag
			EndIf
			$ModifFlag="YES"
			Return $ModifFlag
		EndIf
		If (GUICtrlRead($AutoConnect)=$GUI_CHECKED And $ShareRecon=0) Or (GUICtrlRead($AutoConnect)=$GUI_UNCHECKED And $ShareRecon=1) Then
			$ModifFlag="YES"
			Return $ModifFlag
		Else	
			$ModifFlag="NO"
		EndIf
		Return $ModifFlag
	EndFunc
	
	Func DriveListRefresh()
		$FreeDrives=Call ("GetFreeDrivesList"); refresh the letter list in the Register GUI
		GUICtrlSetData($LetterInput,"")
		GUICtrlSetData($LetterInput,$FreeDrives)
	EndFunc
	
	Func MapOnce()
		Run ("RunDll32.exe shell32.dll,SHHelpShortcuts_RunDLL Connect")
	EndFunc
	
	Func UnMapOnce()
		Run ("RunDll32.exe shell32.dll,SHHelpShortcuts_RunDLL Disconnect")
	EndFunc
		
#endregion  Register/Manage Share GUI
#region GUI LOOP ; Script main loop
While 1
	Sleep(250)
	If $MainGUIState <> "OK" Or BitAND(WinGetState($MainGuiTitle),16) Or Not WinActive($MainGuiTitle) Then ; waits for complete GUI initialisation to start the refresh and does not refresh if window is not active
		ContinueLoop
	Else
		Call("Refresh")
		GUISetOnEvent($GUI_EVENT_PRIMARYDOWN, "LeftClickMouse",$MainGui)
		GUISetOnEvent($GUI_EVENT_MINIMIZE, "Minimize")
		GUISetOnEvent($GUI_EVENT_CLOSE, "Minimize")
	EndIf
WEnd
#endregion GUI LOOP
