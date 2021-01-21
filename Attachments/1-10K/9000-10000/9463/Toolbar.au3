; Animated toolbar
; Created June 2006
; By greenmachine
; Credit: Lazycat (enumicons.au3)

; Features:
; Animated
; Hides to Upper-Left or Lower-Right corner of screen
; Customizable buttons with icons
; Order of buttons is changeable
; Button commands are editable
; Unlimited buttons due to page layout
; Easy Setup GUI - no direct INI editing necessary


; Using font Wingdings 3, j is diag arrow up left, m is diag arrow down right
; Using font Wingdings 3, f is arrow left, g is arrow right
; Using font Wingdings 3, y is thick arrow (triangle) down right, z is thick arrow (triangle) up left
; Using font Wingdings 3, t is thick arrow (triangle) left, u is thick arrow (triangle) right


#NoTrayIcon

Opt ("WinTitleMatchMode", 4)
Opt ("GUICloseOnESC", 0)
#region - Constants For AnimateWindow
Global Const $AW_HOR_POSITIVE		=	0x00000001
Global Const $AW_HOR_NEGATIVE		=	0x00000002
Global Const $AW_VER_POSITIVE		=	0x00000004
Global Const $AW_VER_NEGATIVE		=	0x00000008
Global Const $AW_HIDE				=	0x00010000
Global Const $AW_SLIDE				=	0x00040000
#endregion
#region Constants For _GUICtrlCombo Functions
Global Const $CB_GETCURSEL 			=	0x147
Global Const $CB_SETCURSEL 			=	0x14E
#endregion
#region GUI Constants
Global Const $GUI_EVENT_CLOSE		=	-3
Global Const $GUI_CHECKED			=	1
Global Const $GUI_UNCHECKED			=	4
Global Const $GUI_DROPACCEPTED		=	8
Global Const $GUI_ENABLE			=	64
Global Const $GUI_DISABLE			=	128
Global Const $GUI_DEFBUTTON			=	512
Global Const $WS_MINIMIZEBOX		=	0x00020000
Global Const $WS_SYSMENU			=	0x00080000
Global Const $WS_CAPTION			=	0x00C00000
Global Const $WS_POPUP				=	0x80000000
Global Const $WS_EX_ACCEPTFILES		=	0x00000010
Global Const $WS_EX_TOOLWINDOW		=	0x00000080
Global Const $WS_EX_TOPMOST			=	0x00000008
Global Const $SS_CENTER				=	1
Global Const $SS_LEFTNOWORDWRAP		=	12
Global Const $SS_SUNKEN				=	0x1000
Global Const $BS_CENTER				=	0x0300
Global Const $BS_DEFPUSHBUTTON		=	0x0001
Global Const $BS_VCENTER			=	0x0C00
Global Const $BS_FLAT				=	0x8000
Global Const $BS_ICON				=	0x0040
Global Const $GUI_SS_DEFAULT_GUI	=	BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU)
#endregion

Global Const $WindowTitleBarHeight = 24 ; not my doing.. 20 top, 4 bottom.. 4 (3?) either side

Global $CurrentActiveWindow, $IniPath = @ScriptDir & "\Toolbar.ini"

Global $StartingLabel = "" ; Tell user to click setup, killed after first submit

Global $Toolbar_WinLocation = 0 ; 0 = Upper-Left (default), 1 = Lower-Right

Global $Button_Width = 40, $Button_Height = 40, $Button_SideGaps = 25, $Button_MidGaps = 5
Global $NumButtonsMax = Int ((@DesktopHeight - ($WindowTitleBarHeight + $Button_Height + 2*$Button_MidGaps)) / ($Button_Height+$Button_MidGaps))

Global $Toolbar_Width = 250
Global $Toolbar_Height = @DesktopHeight - $WindowTitleBarHeight, $Slide_Delay = 100

Global $NumPages = 1, $CurrentPage = 1, $CurrentCommand = 1, $NumCommands = 0

Global $Toolbar_Buttons[$NumButtonsMax + 1] ; gui control ... constant dimension size
Global $Toolbar_LabelControls[$NumButtonsMax + 1] ; gui control ... constant dimension size
Global $Toolbar_LabelText[$NumButtonsMax*$NumPages + 1] ; text
Global $Toolbar_FileLocations[$NumButtonsMax*$NumPages + 1][4] ; file location, params, working dir, flag
Global $Toolbar_Icons[$NumButtonsMax*$NumPages + 1][2] ; file location, icon number (-1 is def)


#region - Location-specific Variables
; Defaults to Upper-Left Toolbar Location - only changes on restart
$Toolbar_OpenWin_Left = 0
$Toolbar_OpenWin_Top = 0
$Toolbar_OpenButton_Text = "y" ; y or z

$Toolbar_MainWin_Left = 0
$Toolbar_CloseButton_Text = "j" ; j or m
$Toolbar_CloseButton_Left = $Toolbar_Width - ($Button_Width + 5)
$Toolbar_CloseButton_Top = $Toolbar_Height - ($Button_Height + 5)
$Toolbar_PrevPageButton_Top = $Toolbar_Height - ($Button_Width + 5)
$Toolbar_NextPageButton_Top = $Toolbar_Height - ($Button_Width + 5)
$Toolbar_ConfigButton_Left = 5
$Toolbar_ConfigButton_Top = $Toolbar_Height - ($Button_Width + 5)
$Button_Top = 0

$Toolbar_MainWinAnimationOpen = $AW_SLIDE + $AW_HOR_POSITIVE + $AW_VER_POSITIVE
$Toolbar_MainWinAnimationClosed = $AW_HIDE + $AW_SLIDE + $AW_HOR_NEGATIVE + $AW_VER_NEGATIVE
#endregion


If FileExists ($IniPath) Then
	LoadINI()
	$Toolbar_WinLocation = IniRead ($IniPath, "Universal Setup", "Toolbar Location", 0)
ElseIf @Compiled Then
	If RegRead ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "Toolbar") = "" And _ 
		MsgBox (4, "Toolbar", "Do you want Toolbar to start on computer startup?") = 6 Then _ 
		RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "Toolbar", "REG_SZ", @ScriptFullPath)
EndIf

If $Toolbar_WinLocation = 1 Then
	$Toolbar_OpenWin_Left = @DesktopWidth - 11
	$Toolbar_OpenWin_Top = @DesktopHeight - 11
	$Toolbar_OpenButton_Text = "z" ; y or z

	$Toolbar_MainWin_Left = @DesktopWidth - $Toolbar_Width - 6
	$Toolbar_CloseButton_Text = "m" ; j or m
	$Toolbar_CloseButton_Left = 5 ; $Toolbar_Width - ($Button_Width + 5)
	$Toolbar_CloseButton_Top = 5 ; $Toolbar_Height - ($Button_Height + 5)
	$Toolbar_PrevPageButton_Top = 5 ; $Toolbar_Height - ($Button_Width + 5)
	$Toolbar_NextPageButton_Top = 5 ; $Toolbar_Height - ($Button_Width + 5)
	$Toolbar_ConfigButton_Left = $Toolbar_Width - ($Button_Width + 5) ; 5
	$Toolbar_ConfigButton_Top = 5 ; $Toolbar_Height - ($Button_Width + 5)
	$Button_Top = $Toolbar_Height - (5 + $Button_Top + $NumButtonsMax*($Button_Height + $Button_MidGaps)) ; 45

	$Toolbar_MainWinAnimationOpen = $AW_SLIDE + $AW_HOR_NEGATIVE + $AW_VER_NEGATIVE
	$Toolbar_MainWinAnimationClosed = $AW_HIDE + $AW_SLIDE + $AW_HOR_POSITIVE + $AW_VER_POSITIVE
EndIf

$Toolbar_OpenWin = GUICreate ("Tool", 11, 11, $Toolbar_OpenWin_Left, $Toolbar_OpenWin_Top, $WS_POPUP, BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
GUISetFont (12, "", "", "Wingdings 3")
$Toolbar_OpenButton = GUICtrlCreateButton ($Toolbar_OpenButton_Text, 0, 0, 11, 11, $BS_FLAT)
GUICtrlSetTip ($Toolbar_OpenButton, "Show Toolbar")
WinSetTrans ($Toolbar_OpenWin, "", 150)
GUISetState (@SW_HIDE)


$Toolbar_MainWin = GUICreate ("Sliding Toolbar", $Toolbar_Width, $Toolbar_Height, $Toolbar_MainWin_Left, 0, Default, BitOR($WS_EX_TOPMOST, _ 
$WS_EX_TOOLWINDOW))
GUISetFont (24, 800, "", "Wingdings 3")
$Toolbar_CloseButton = GUICtrlCreateButton ($Toolbar_CloseButton_Text, $Toolbar_CloseButton_Left, $Toolbar_CloseButton_Top, $Button_Width, $Button_Height, BitOR ($BS_CENTER, $BS_VCENTER, $BS_FLAT))
GUICtrlSetTip ($Toolbar_CloseButton, "Hide Toolbar")
GUISetFont (18, "", "", "Wingdings 3")
$Toolbar_NextPageButton = GUICtrlCreateButton ("u", 130, $Toolbar_NextPageButton_Top, $Button_Width, $Button_Height, BitOR ($BS_CENTER, $BS_VCENTER, $BS_FLAT))
GUICtrlSetTip ($Toolbar_NextPageButton, "Next Page")
If $NumPages = 1 Then GUICtrlSetState ($Toolbar_NextPageButton, $GUI_DISABLE)
$Toolbar_PrevPageButton = GUICtrlCreateButton ("t", 80, $Toolbar_PrevPageButton_Top, $Button_Width, $Button_Height, BitOR ($BS_CENTER, $BS_VCENTER, $BS_FLAT))
GUICtrlSetTip ($Toolbar_PrevPageButton, "Previous Page")
GUICtrlSetState ($Toolbar_PrevPageButton, $GUI_DISABLE)
GUISetFont (9, 800)
$Toolbar_ConfigButton = GUICtrlCreateButton ("Setup", $Toolbar_ConfigButton_Left, $Toolbar_ConfigButton_Top, $Button_Width, $Button_Height, BitOR ($BS_CENTER, $BS_VCENTER, $BS_FLAT))
GUICtrlSetTip ($Toolbar_ConfigButton, "Configure Toolbar")
GUISetFont (11, "")

For $i = 1 To $NumButtonsMax
	$Toolbar_LabelControls[$i] = GUICtrlCreateLabel ($i & ". " & $Toolbar_LabelText[$i], 5, 15 + $Button_Top + ($i-1)*($Button_Height + $Button_MidGaps), $Toolbar_Width - $Button_Width - 3*$Button_MidGaps, 20, $SS_LEFTNOWORDWRAP)
	$Toolbar_Buttons[$i] = GUICtrlCreateButton ($i, $Toolbar_Width - ($Button_Width + 5), _ 
	5 + $Button_Top + ($i-1)*($Button_Height + $Button_MidGaps), $Button_Width, $Button_Height, $BS_ICON)
	If $Toolbar_LabelText[$i] = "" Then GUICtrlSetState ($Toolbar_Buttons[$i], $GUI_DISABLE)
	GUICtrlSetImage ($Toolbar_Buttons[$i], $Toolbar_Icons[$i][0], $Toolbar_Icons[$i][1])
Next

If Not FileExists ($IniPath) Then
	$StartingLabel = GUICtrlCreateLabel ("Click Setup To Start", $Toolbar_Width/2 - 75, $NumButtonsMax/2*($Button_Height + $Button_MidGaps), 140, 100, $SS_CENTER)
	GUICtrlSetFont ($StartingLabel, 16, 800)
EndIf

DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $Toolbar_MainWin, "int", $Slide_Delay, "long", $Toolbar_MainWinAnimationOpen)
GUISetState (@SW_SHOW)



While 1
	$msg1 = GUIGetMsg()
	Switch $msg1
		Case 0
			If Not (WinActive ($Toolbar_MainWin) Or WinActive ($Toolbar_OpenWin)) Then $CurrentActiveWindow = WinGetHandle ("active")
			ContinueLoop
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Toolbar_CloseButton
			Slide_Closed()
		Case $Toolbar_OpenButton
			Slide_Open()
		Case $Toolbar_ConfigButton
			Config()
		Case $Toolbar_PrevPageButton
			$CurrentPage -= 1
			GUICtrlSetState ($Toolbar_NextPageButton, $GUI_ENABLE)
			If $CurrentPage = 1 Then GUICtrlSetState ($Toolbar_PrevPageButton, $GUI_DISABLE)
			UpdateButtons ($CurrentPage)
		Case $Toolbar_NextPageButton
			$CurrentPage += 1
			GUICtrlSetState ($Toolbar_PrevPageButton, $GUI_ENABLE)
			If $CurrentPage = $NumPages Then GUICtrlSetState ($Toolbar_NextPageButton, $GUI_DISABLE)
			UpdateButtons ($CurrentPage)
		Case Else
			For $i = 1 To $NumButtonsMax
				If $msg1 = $Toolbar_Buttons[$i] Then Button($i)
			Next
	EndSwitch
WEnd

Func Slide_Open()
    GUISetState(@SW_HIDE, $Toolbar_OpenWin)
    DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $Toolbar_MainWin, "int", $Slide_Delay, "long", $Toolbar_MainWinAnimationOpen)
    WinActivate($Toolbar_MainWin)
    WinWaitActive($Toolbar_MainWin)
EndFunc ;==>Slide_Open

Func Slide_Closed($button = 0)
    DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $Toolbar_MainWin, "int", $Slide_Delay, "long", $Toolbar_MainWinAnimationClosed)
    GUISetState(@SW_SHOW, $Toolbar_OpenWin)
	If Not $button Then
		WinActivate($CurrentActiveWindow)
		WinWaitActive($CurrentActiveWindow)
	EndIf
EndFunc ;==>Slide_Closed

Func Button($B_Num)
	Slide_Closed(1)
	$B_Num += ($CurrentPage-1)*$NumButtonsMax
	Select
		Case $Toolbar_FileLocations[$B_Num][2] = ""
			If String ($Toolbar_FileLocations[$B_Num][3]) = "" Then
				Run ($Toolbar_FileLocations[$B_Num][0] & " " & $Toolbar_FileLocations[$B_Num][1])
			Else
				Run ($Toolbar_FileLocations[$B_Num][0] & " " & $Toolbar_FileLocations[$B_Num][1], "", _ 
					Number ($Toolbar_FileLocations[$B_Num][3]))
			EndIf
		Case $Toolbar_FileLocations[$B_Num][2] = "Default"
			If String ($Toolbar_FileLocations[$B_Num][3]) = "" Then
				Run ($Toolbar_FileLocations[$B_Num][0] & " " & $Toolbar_FileLocations[$B_Num][1], @WorkingDir)
			Else
				Run ($Toolbar_FileLocations[$B_Num][0] & " " & $Toolbar_FileLocations[$B_Num][1], @WorkingDir, _ 
					Number ($Toolbar_FileLocations[$B_Num][3]))
			EndIf
		Case String ($Toolbar_FileLocations[$B_Num][3]) = ""
			Run ($Toolbar_FileLocations[$B_Num][0] & " " & $Toolbar_FileLocations[$B_Num][1], $Toolbar_FileLocations[$B_Num][2])
		Case Else
			Run ($Toolbar_FileLocations[$B_Num][0] & " " & $Toolbar_FileLocations[$B_Num][1], $Toolbar_FileLocations[$B_Num][2], _ 
				Number ($Toolbar_FileLocations[$B_Num][3]))
	EndSelect
EndFunc

Func Config()
	Local $NewIcon[3] = [2, "", -1]
	Local $Config_OrderButtons[$NumCommands+1][2] ; gui control, order position
	Local $Config_OrderLabels[$NumCommands+1] ; gui control
	Local $SelectedOne[4] = [0, 0, 0, 0] ; is selected, gui control to selected one, order position of selected, button number of selected
	$Config_ButtonTop = 355
	$Config_ButtonGapW = 5
	$Config_ButtonGapH = 20
	$Config_ButtonWidth = 25
	$Config_ButtonHeight = 25
	$Config_MaxButtons = Int (390/($Config_ButtonWidth + $Config_ButtonGapW))
	$Config_ButtonRows = Int (Ceiling ($NumCommands / $Config_MaxButtons))
	$InEditMode = 0
	$InOrderMode = 0
	$InSwapMode = 0
	$SelectedCommand = 0
	$Config_Win = GUICreate ("Config", 400, 350 + 50*$Config_ButtonRows, 100, 100, $GUI_SS_DEFAULT_GUI, $WS_EX_ACCEPTFILES)
	
	GUICtrlCreateLabel ("Toolbar Location", 5, 10, 85, 20)
	$Config_ToolbarLocCombo = GUICtrlCreateCombo ("Upper Left (Default)", 90, 10, 135, 20)
	GUICtrlSetData ($Config_ToolbarLocCombo, "Lower Right")
	_GUICtrlComboSetCurSel ($Config_ToolbarLocCombo, Int (IniRead ($IniPath, "Universal Setup", "Toolbar Location", 0)))
	GUICtrlCreateLabel ("Position will update on Toolbar restart.", 230, 5, 100, 30, $SS_CENTER)
	$Config_SetPosButton = GUICtrlCreateButton ("Set", 335, 10, 60, 20)
	
	GUICtrlCreateGroup ("New / Edit Command", 2, 35, 396, 270)
	
	GUICtrlCreateLabel ("Edit Command", 5, 50, 70, 20)
	$Config_EditCombo = GUICtrlCreateCombo ("---- Select Command ----", 90, 50, 175, 20)
	For $i = 1 To $NumCommands
		If $Toolbar_LabelText[$i] <> "" Then
			GUICtrlSetData ($Config_EditCombo, $i & ". " & $Toolbar_LabelText[$i] & "|")
		EndIf
	Next
	$Config_EditButton = GUICtrlCreateButton ("Edit", 270, 50, 125, 20)
	
	GUICtrlCreateLabel ("---------------------------------------------------------------------" & _ 
	"---------------------------------------------------------------------", 5, 73, 390, 8)
	
	GUICtrlCreateLabel ("Command Name", 5, 90, 80, 20)
	$Config_CmdNameInput = GUICtrlCreateInput ("", 90, 90, 175, 20)
	$Config_CmdNumLabel = GUICtrlCreateLabel ("Command Number: " & $CurrentCommand, 270, 90, 120, 20)
	
	GUICtrlCreateLabel ("File Path", 5, 120, 80, 20)
	$Config_FilePathInput = GUICtrlCreateInput ("", 90, 120, 175, 20)
	GUICtrlSetState (-1, $GUI_DROPACCEPTED)
	$Config_BrowseButton = GUICtrlCreateButton ("Browse", 270, 120, 125, 20)
	
	GUICtrlCreateLabel ("Params", 5, 150, 80, 20)
	$Config_ParamsInput = GUICtrlCreateInput ("", 90, 150, 175, 20)
	GUICtrlSetState (-1, $GUI_DROPACCEPTED)
	$Config_ParamsFile = GUICtrlCreateButton ("File", 270, 150, 60, 20)
	$Config_ParamsFolder = GUICtrlCreateButton ("Folder", 335, 150, 60, 20)
	
	GUICtrlCreateLabel ("Working Dir", 5, 180, 80, 20)
	$Config_WorkDirInput = GUICtrlCreateInput ("", 90, 180, 175, 20)
	GUICtrlSetState (-1, $GUI_DROPACCEPTED)
	$Config_WorkDirCheck = GUICtrlCreateCheckbox ("Use Default", 270, 180, 75, 20)
	
	GUICtrlCreateLabel ("Show/Hide Flag", 5, 210, 80, 20)
	$Config_FlagCombo = GUICtrlCreateCombo ("---- Default (None) ----", 90, 210, 175, 20)
	GUICtrlSetData (-1, "@SW_DISABLE|@SW_ENABLE|@SW_HIDE|@SW_LOCK|@SW_MAXIMIZE|@SW_MINIMIZE" & _ 
		"|@SW_RESTORE|@SW_SHOW|@SW_SHOWDEFAULT|@SW_SHOWMAXIMIZED|@SW_SHOWMINIMIZED|@SW_SHOWMINNOACTIVE" & _ 
		"|@SW_SHOWNA|@SW_SHOWNOACTIVATE|@SW_SHOWNORMAL|@SW_UNLOCK")
	
	$Config_SubmitButton = GUICtrlCreateButton ("Submit Change", 270, 235, 125, 35)
	GUICtrlSetState (-1, $GUI_DISABLE)
	$Config_ClearButton = GUICtrlCreateButton ("Clear", 270, 275, 125, 20)
	
	GUICtrlCreateLabel ("Current Icon:", 5, 250, 65, 20)
	GUICtrlCreateGroup ("", 80, 237, 42, 52)
	$Config_CurrentIcon = GUICtrlCreateIcon ("", "", 85, 250, 32, 32)
	$Config_ChangeIconButton = GUICtrlCreateButton ("Change Icon", 125, 250, 80, 20)
	
	GUICtrlCreateGroup ("Change Command Order", 2, 315, 396, 50*$Config_ButtonRows + 33)
	$Config_OrderStatus = GUICtrlCreateLabel ("Status: Order Saved", 280, 315, 110, 15, $SS_CENTER)
	$Config_SwapButtonOrder = GUICtrlCreateButton ("Swap Two", 145, 330, 80, 20)
	$Config_ResetButtonOrder = GUICtrlCreateButton ("Reset Order", 230, 330, 80, 20)
	$Config_SubmitButtonOrder = GUICtrlCreateButton ("Save Order", 315, 330, 80, 20)
	GUICtrlSetState ($Config_SubmitButtonOrder, $GUI_DISABLE)
	GUICtrlCreateLabel ("One Page = " & $NumButtonsMax & " Buttons", 5, 333)
	
	For $i = 1 To $Config_ButtonRows
		For $j = 1 To $Config_MaxButtons
			$Config_TempCounter = ($i-1)*$Config_MaxButtons + $j
			If $Config_TempCounter <= $NumCommands Then
				$Config_OrderButtons[$Config_TempCounter][0] = GUICtrlCreateButton ($Config_TempCounter, 5 + ($j-1)*($Config_ButtonWidth + $Config_ButtonGapW), _ 
				$Config_ButtonTop + ($i-1)*($Config_ButtonHeight + $Config_ButtonGapH), $Config_ButtonWidth, $Config_ButtonHeight, $BS_ICON)
				GUICtrlSetImage (-1, $Toolbar_Icons[$Config_TempCounter][0], $Toolbar_Icons[$Config_TempCounter][1], 0)
				GUICtrlSetTip (-1, $Toolbar_LabelText[$Config_TempCounter])
				$Config_OrderLabels[$Config_TempCounter] = GUICtrlCreateLabel ($Config_TempCounter, 5 + ($j-1)*($Config_ButtonWidth + $Config_ButtonGapW), _ 
				$Config_ButtonTop + $i*$Config_ButtonHeight + ($i-1)*$Config_ButtonGapH, 20, 15, $SS_CENTER)
				$Config_OrderButtons[$Config_TempCounter][1] = $Config_TempCounter
			EndIf
		Next
	Next
	
	Slide_Closed(1)
	GUISetState (@SW_SHOW, $Config_Win)
	While 1
		If GUICtrlRead ($Config_CmdNameInput) <> "" And GUICtrlRead ($Config_FilePathInput) <> "" And _ 
			BitAND (GUICtrlGetState ($Config_SubmitButton), $GUI_DISABLE) = $GUI_DISABLE Then
			GUICtrlSetState ($Config_SubmitButton, $GUI_ENABLE)
		ElseIf (GUICtrlRead ($Config_CmdNameInput) = "" Or GUICtrlRead ($Config_FilePathInput) = "") And _ 
			BitAND (GUICtrlGetState ($Config_SubmitButton), $GUI_ENABLE) = $GUI_ENABLE Then
			GUICtrlSetState ($Config_SubmitButton, $GUI_DISABLE)
		EndIf
		$msg2 = GUIGetMsg ()
		If $InOrderMode Then
			For $i = 1 To $NumCommands
				If $msg2 = $Config_OrderButtons[$i][0] Then
					If $Config_OrderButtons[$i][1] = 0 Then
						$Config_OrderButtons[0][1] += 1
						$Config_OrderButtons[$i][1] = $Config_OrderButtons[0][1]
						GUICtrlSetData ($Config_OrderLabels[$i], $Config_OrderButtons[$i][1])
						If $SelectedOne[0] Then GUICtrlSetColor ($Config_OrderLabels[$SelectedOne[3]], 0x000000)
						GUICtrlSetColor ($Config_OrderLabels[$i], 0xFF0000)
						$SelectedOne[0] = 1
						$SelectedOne[1] = $Config_OrderButtons[$i][0]
						$SelectedOne[2] = $Config_OrderButtons[$i][1]
						$SelectedOne[3] = $i
					ElseIf $SelectedOne[1] = $Config_OrderButtons[$i][0] Then
						$Config_OrderButtons[0][1] -= 1
						$Config_OrderButtons[$i][1] = 0
						GUICtrlSetData ($Config_OrderLabels[$i], "")
						GUICtrlSetColor ($Config_OrderLabels[$i], 0x000000)
						$SelectedOne[0] = 0
						$SelectedOne[1] = 0
						$SelectedOne[2] = 0
						$SelectedOne[3] = 0
					EndIf
				EndIf
			Next
			If BitAND (GUICtrlGetState ($Config_SubmitButtonOrder), $GUI_DISABLE) = $GUI_DISABLE And $Config_OrderButtons[0][1] = $NumCommands Then
				GUICtrlSetState ($Config_SubmitButtonOrder, $GUI_ENABLE)
				GUICtrlSetColor ($Config_OrderLabels[$SelectedOne[3]], 0x000000)
				$SelectedOne[0] = 0
				$SelectedOne[1] = 0
				$SelectedOne[2] = 0
				$SelectedOne[3] = 0
				$InOrderMode = 0
			EndIf
			; order stuff
		EndIf
		If $InSwapMode And Not $InOrderMode Then
			For $i = 1 To $NumCommands
				If $msg2 = $Config_OrderButtons[$i][0] Then
					If Not $SelectedOne[0] Then
						GUICtrlSetColor ($Config_OrderLabels[$i], 0xFF0000)
						$SelectedOne[0] = 1
						$SelectedOne[1] = $Config_OrderButtons[$i][0]
						$SelectedOne[2] = $Config_OrderButtons[$i][1]
						$SelectedOne[3] = $i
					ElseIf $SelectedOne[1] = $Config_OrderButtons[$i][0] Then
						GUICtrlSetColor ($Config_OrderLabels[$i], 0x000000)
						$SelectedOne[0] = 0
						$SelectedOne[1] = 0
						$SelectedOne[2] = 0
						$SelectedOne[3] = 0
						ToolTip ("")
						$InSwapMode = 0
					Else
						GUICtrlSetColor ($Config_OrderLabels[$SelectedOne[3]], 0x000000)
						$temp = $Config_OrderButtons[$i][1]
						$Config_OrderButtons[$i][1] = $SelectedOne[2]
						$Config_OrderButtons[$SelectedOne[3]][1] = $temp
						GUICtrlSetData ($Config_OrderLabels[$i], $Config_OrderButtons[$i][1])
						GUICtrlSetData ($Config_OrderLabels[$SelectedOne[3]], $Config_OrderButtons[$SelectedOne[3]][1])
						$SelectedOne[0] = 0
						$SelectedOne[1] = 0
						$SelectedOne[2] = 0
						$SelectedOne[3] = 0
						ToolTip ("")
						$InSwapMode = 0
						GUICtrlSetData ($Config_OrderStatus, "Status: Order Unsaved")
						GUICtrlSetState ($Config_SubmitButtonOrder, $GUI_ENABLE)
					EndIf
				EndIf
			Next
		EndIf
		Switch $msg2
			Case 0
				ContinueLoop
			Case $GUI_EVENT_CLOSE
				ToolTip ("")
				GUIDelete ($Config_Win)
				ExitLoop
			Case $Config_EditButton ; EDIT
				If GUICtrlRead ($Config_EditCombo) = "---- Select Command ----" Then
					MsgBox (0, "Error", "No Command Selected")
				Else
					$InEditMode = 1
					$SelectedCommand = _GUICtrlComboGetCurSel ($Config_EditCombo)
					GUICtrlSetData ($Config_CmdNameInput, $Toolbar_LabelText[$SelectedCommand])
					GUICtrlSetData ($Config_FilePathInput, $Toolbar_FileLocations[$SelectedCommand][0])
					GUICtrlSetData ($Config_ParamsInput, $Toolbar_FileLocations[$SelectedCommand][1])
					GUICtrlSetData ($Config_WorkDirInput, $Toolbar_FileLocations[$SelectedCommand][2])
					If $Toolbar_FileLocations[$SelectedCommand][2] = "Default" Then
						GUICtrlSetState ($Config_WorkDirCheck, $GUI_CHECKED)
					Else
						GUICtrlSetState ($Config_WorkDirCheck, $GUI_UNCHECKED)
					EndIf
					Switch Number ($Toolbar_FileLocations[$SelectedCommand][3])
						Case @SW_DISABLE
							_GUICtrlComboSetCurSel ($Config_FlagCombo, 1)
						Case @SW_ENABLE
							_GUICtrlComboSetCurSel ($Config_FlagCombo, 2)
						Case @SW_HIDE
							_GUICtrlComboSetCurSel ($Config_FlagCombo, 3)
						Case @SW_LOCK
							_GUICtrlComboSetCurSel ($Config_FlagCombo, 4)
						Case @SW_MAXIMIZE
							_GUICtrlComboSetCurSel ($Config_FlagCombo, 5)
						Case @SW_MINIMIZE
							_GUICtrlComboSetCurSel ($Config_FlagCombo, 6)
						Case @SW_RESTORE
							_GUICtrlComboSetCurSel ($Config_FlagCombo, 7)
						Case @SW_SHOW
							_GUICtrlComboSetCurSel ($Config_FlagCombo, 8)
						Case @SW_SHOWDEFAULT
							_GUICtrlComboSetCurSel ($Config_FlagCombo, 9)
						Case @SW_SHOWMAXIMIZED
							_GUICtrlComboSetCurSel ($Config_FlagCombo, 10)
						Case @SW_SHOWMINIMIZED
							_GUICtrlComboSetCurSel ($Config_FlagCombo, 11)
						Case @SW_SHOWMINNOACTIVE
							_GUICtrlComboSetCurSel ($Config_FlagCombo, 12)
						Case @SW_SHOWNA
							_GUICtrlComboSetCurSel ($Config_FlagCombo, 13)
						Case @SW_SHOWNOACTIVATE
							_GUICtrlComboSetCurSel ($Config_FlagCombo, 14)
						Case @SW_SHOWNORMAL
							_GUICtrlComboSetCurSel ($Config_FlagCombo, 15)
						Case @SW_UNLOCK
							_GUICtrlComboSetCurSel ($Config_FlagCombo, 16)
					EndSwitch
					If $Toolbar_FileLocations[$SelectedCommand][3] = "" Then
						_GUICtrlComboSetCurSel ($Config_FlagCombo, 0)
					EndIf
					GUICtrlSetData ($Config_CmdNumLabel, "Command Number: " & $SelectedCommand)
					GUICtrlSetImage ($Config_CurrentIcon, $Toolbar_Icons[$SelectedCommand][0], $Toolbar_Icons[$SelectedCommand][1])
				EndIf
			Case $Config_ClearButton ; CLEAR
				$InEditMode = 0
				_GUICtrlComboSetCurSel ($Config_EditCombo, 0)
				GUICtrlSetData ($Config_CmdNameInput, "")
				GUICtrlSetData ($Config_FilePathInput, "")
				GUICtrlSetData ($Config_ParamsInput, "")
				GUICtrlSetData ($Config_WorkDirInput, "")
				GUICtrlSetState ($Config_WorkDirCheck, $GUI_UNCHECKED)
				_GUICtrlComboSetCurSel ($Config_FlagCombo, 0)
				GUICtrlSetData ($Config_CmdNumLabel, "Command Number: " & $CurrentCommand)
				GUICtrlSetImage ($Config_CurrentIcon, "")
			Case $Config_WorkDirCheck ; WORKING DIR CHECKBOX
				If GUICtrlRead ($Config_WorkDirCheck) = $GUI_CHECKED Then
					GUICtrlSetData ($Config_WorkDirInput, "Default")
				Else
					GUICtrlSetData ($Config_WorkDirInput, "")
				EndIf
			Case $Config_BrowseButton ; BROWSE FOR FILE
				$BrowsedFile = FileOpenDialog ("Select File To Run", "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", _ 
				"All Files (*.*)|Executable Files (*.exe)") ; "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}" is My Computer
				If $BrowsedFile <> "" Then GUICtrlSetData ($Config_FilePathInput, $BrowsedFile)
			Case $Config_ParamsFile ; BROWSE PARAM FILE
				$BrowsedParamFile = FileOpenDialog ("Select File", "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", _ 
				"All Files (*.*)|Executable Files (*.exe)|Images (*.jpeg;*.jpg;*.gif;*.png;*.bmp)")
				If $BrowsedParamFile <> "" Then GUICtrlSetData ($Config_ParamsInput, '"' & $BrowsedParamFile & '"')
			Case $Config_ParamsFolder ; BROWSE PARAM FOLDER
				$BrowsedParamFolder = FileSelectFolder ("Select Folder", "")
				If $BrowsedParamFolder <> "" Then GUICtrlSetData ($Config_ParamsInput, '"' & $BrowsedParamFolder & '"')
			Case $Config_SubmitButton ; SUBMIT NEW/EDITED COMMAND
				$WinPos = WinGetPos ($Config_Win)
				SplashTextOn ("Submitting", "Please Wait", 100, 50, $WinPos[0] + $WinPos[2]/2 - 50, $WinPos[1] + $WinPos[3]/2 - 25)
				If Not $InEditMode Then
					IniWrite ($IniPath, "Universal Setup", "Number of Commands", $CurrentCommand)
					$SelectedCommand = $CurrentCommand
				EndIf
				IniWrite ($IniPath, "Command " & $SelectedCommand, "Command Name", GUICtrlRead ($Config_CmdNameInput))
				IniWrite ($IniPath, "Command " & $SelectedCommand, "File Location", GUICtrlRead ($Config_FilePathInput))
				IniWrite ($IniPath, "Command " & $SelectedCommand, "Params", GUICtrlRead ($Config_ParamsInput))
				IniWrite ($IniPath, "Command " & $SelectedCommand, "Working Dir", GUICtrlRead ($Config_WorkDirInput))
				If _GUICtrlComboGetCurSel ($Config_FlagCombo) <> 0 Then
					IniWrite ($IniPath, "Command " & $SelectedCommand, "Flag", Eval (GUICtrlRead ($Config_FlagCombo)))
				Else
					IniWrite ($IniPath, "Command " & $SelectedCommand, "Flag", "")
				EndIf
				IniWrite ($IniPath, "Command " & $SelectedCommand, "Icon File", $NewIcon[1])
				IniWrite ($IniPath, "Command " & $SelectedCommand, "Icon Number", $NewIcon[2])
				LoadINI()
				$InEditMode = 0
				_GUICtrlComboSetCurSel ($Config_EditCombo, 0)
				GUICtrlSetData ($Config_CmdNameInput, "")
				GUICtrlSetData ($Config_FilePathInput, "")
				GUICtrlSetData ($Config_ParamsInput, "")
				GUICtrlSetData ($Config_WorkDirInput, "")
				GUICtrlSetState ($Config_WorkDirCheck, $GUI_UNCHECKED)
				_GUICtrlComboSetCurSel ($Config_FlagCombo, 0)
				GUICtrlSetData ($Config_CmdNumLabel, "Command Number: " & $CurrentCommand)
				GUICtrlSetImage ($Config_CurrentIcon, "")
				If $StartingLabel <> "" Then GUICtrlDelete ($StartingLabel)
				SplashOff ()
			Case $Config_ChangeIconButton ; CHANGE ICON
				If FileExists (GUICtrlRead ($Config_FilePathInput)) Then
					$NewIcon = IconSelect (GUICtrlRead ($Config_FilePathInput))
				ElseIf FileExists ($Toolbar_FileLocations[$SelectedCommand][0]) Then
					$NewIcon = IconSelect ($Toolbar_FileLocations[$SelectedCommand][0])
				Else
					$NewIcon = IconSelect ()
				EndIf
				If Not @error Then
					GUICtrlSetImage ($Config_CurrentIcon, $NewIcon[1], $NewIcon[2])
				EndIf
			Case $Config_SwapButtonOrder ; SWAP TWO BUTTON LOCATIONS
				$InSwapMode = 1
				ToolTip ("Click on any two buttons to swap their position", MouseGetPos (0), MouseGetPos (1) - 25, "", 0, 2)
			Case $Config_ResetButtonOrder ; RESET BUTTON ORDER
				If $InSwapMode And $SelectedOne[0] Then
					GUICtrlSetColor ($Config_OrderLabels[$SelectedOne[3]], 0x000000)
					$SelectedOne[0] = 0
					$SelectedOne[1] = 0
					$SelectedOne[2] = 0
					$SelectedOne[3] = 0
				EndIf
				$InSwapMode = 0
				ToolTip ("")
				$InOrderMode = 1
				For $i = 0 To $NumCommands
					$Config_OrderButtons[$i][1] = 0
					GUICtrlSetData ($Config_OrderLabels[$i], "")
				Next
				GUICtrlSetState ($Config_SubmitButtonOrder, $GUI_DISABLE)
				GUICtrlSetData ($Config_OrderStatus, "Status: Order Unsaved")
			Case $Config_SubmitButtonOrder ; SUBMIT BUTTON ORDER
				$WinPos = WinGetPos ($Config_Win)
				SplashTextOn ("Submitting", "Please Wait", 100, 50, $WinPos[0] + $WinPos[2]/2 - 50, $WinPos[1] + $WinPos[3]/2 - 25)
				If $InSwapMode And $SelectedOne[0] Then
					GUICtrlSetColor ($Config_OrderLabels[$SelectedOne[3]], 0x000000)
					ToolTip ("")
					$SelectedOne[0] = 0
					$SelectedOne[1] = 0
					$SelectedOne[2] = 0
					$SelectedOne[3] = 0
					$InSwapMode = 0
				EndIf
				For $i = 1 To $NumCommands
					IniWrite ($IniPath, "Command " & $Config_OrderButtons[$i][1], "Command Name", $Toolbar_LabelText[$i])
					IniWrite ($IniPath, "Command " & $Config_OrderButtons[$i][1], "File Location", $Toolbar_FileLocations[$i][0])
					IniWrite ($IniPath, "Command " & $Config_OrderButtons[$i][1], "Params", $Toolbar_FileLocations[$i][1])
					IniWrite ($IniPath, "Command " & $Config_OrderButtons[$i][1], "Working Dir", $Toolbar_FileLocations[$i][2])
					IniWrite ($IniPath, "Command " & $Config_OrderButtons[$i][1], "Flag", $Toolbar_FileLocations[$i][3])
					IniWrite ($IniPath, "Command " & $Config_OrderButtons[$i][1], "Icon File", $Toolbar_Icons[$i][0])
					IniWrite ($IniPath, "Command " & $Config_OrderButtons[$i][1], "Icon Number", $Toolbar_Icons[$i][1])
				Next
				GUICtrlSetData ($Config_OrderStatus, "Status: Order Saved")
				SplashOff ()
				If MsgBox (4, "Toolbar", "The Toolbar updates its command orders on restart.  Do you want to restart now?") = 6 Then
					SelfRestart (2)
					Exit
				EndIf
			Case $Config_SetPosButton ; SET TOOLBAR POSITION
				IniWrite ($IniPath, "Universal Setup", "Toolbar Location", _GUICtrlComboGetCurSel ($Config_ToolbarLocCombo))
				If MsgBox (4, "Toolbar", "The Toolbar updates its location on restart.  Do you want to restart now?") = 6 Then
					SelfRestart (2)
					Exit
				EndIf
		EndSwitch
	WEnd
	UpdateButtons()
	Slide_Open()
EndFunc

Func LoadINI()
	$NumCommands = IniRead ($IniPath, "Universal Setup", "Number of Commands", 0)
	$CurrentCommand = $NumCommands + 1
	$NumPages = Int (Ceiling ($NumCommands / $NumButtonsMax))
	If $NumCommands > (UBound ($Toolbar_LabelText) - 1) Then
		ReDim $Toolbar_LabelText[$NumButtonsMax*$NumPages + 1] ; text
		ReDim $Toolbar_FileLocations[$NumButtonsMax*$NumPages + 1][4] ; file location, params, working dir, flag
		ReDim $Toolbar_Icons[$NumButtonsMax*$NumPages + 1][2] ; file location, icon number (-1 is def)
	EndIf
	For $i = 1 To $NumCommands
		$Toolbar_LabelText[$i] = IniRead ($IniPath, "Command " & $i, "Command Name", "")
		$Toolbar_FileLocations[$i][0] = IniRead ($IniPath, "Command " & $i, "File Location", "")
		$Toolbar_FileLocations[$i][1] = IniRead ($IniPath, "Command " & $i, "Params", "")
		$Toolbar_FileLocations[$i][2] = IniRead ($IniPath, "Command " & $i, "Working Dir", "")
		$Toolbar_FileLocations[$i][3] = IniRead ($IniPath, "Command " & $i, "Flag", "")
		$Toolbar_Icons[$i][0] = IniRead ($IniPath, "Command " & $i, "Icon File", "")
		$Toolbar_Icons[$i][1] = IniRead ($IniPath, "Command " & $i, "Icon Number", "")
	Next
EndFunc

Func UpdateButtons($Page = 1)
	For $i = 1 To $NumButtonsMax
		GUICtrlSetData ($Toolbar_LabelControls[$i], ($Page-1)*$NumButtonsMax + $i & ". " & $Toolbar_LabelText[($Page-1)*$NumButtonsMax + $i])
		If $Toolbar_LabelText[($Page-1)*$NumButtonsMax + $i] = "" Then
			GUICtrlSetStyle ($Toolbar_Buttons[$i], 0)
			GUICtrlSetData ($Toolbar_Buttons[$i], ($Page-1)*$NumButtonsMax + $i)
			GUICtrlSetState ($Toolbar_Buttons[$i], $GUI_DISABLE)
		Else
			GUICtrlSetState ($Toolbar_Buttons[$i], $GUI_ENABLE)
			GUICtrlSetStyle ($Toolbar_Buttons[$i], $BS_ICON)
			GUICtrlSetImage ($Toolbar_Buttons[$i], $Toolbar_Icons[($Page-1)*$NumButtonsMax + $i][0], $Toolbar_Icons[($Page-1)*$NumButtonsMax + $i][1])
		EndIf
	Next
	If $NumPages > 1 And $CurrentPage < $NumPages Then GUICtrlSetState ($Toolbar_NextPageButton, $GUI_ENABLE)
	If $CurrentPage > 1 Then GUICtrlSetState ($Toolbar_PrevPageButton, $GUI_ENABLE)
EndFunc

Func TertIf ($Statement, $True, $False)
	If $Statement Then Return $True
	Return $False
EndFunc

Func IconSelect($sFilename = "")
	Local $ahIcons[30], $ahLabels[30] 
	Local $iStartIndex = 0, $iCntRow, $iCntCol, $iCurIndex
	If $sFilename = "" Then
		$sFilename = @SystemDir & "\shell32.dll"
	ElseIf $sFilename = "explorer.exe" Then
		$sFilename = @WindowsDir & "\explorer.exe"
	EndIf
	
	$IconSelector = GUICreate ("Icon Selector", 385, 435)
	GUICtrlCreateGroup ("", 5, 50, 375, 380)
	$hFile = GUICtrlCreateLabel ($sFilename, 5, 5, 305, 40, $SS_SUNKEN)
	$hFileSel = GUICtrlCreateButton ("Browse", 315, 5, 65, 40, $BS_DEFPUSHBUTTON)
	$hPrev = GUICtrlCreateButton ("Previous", 10, 45, 60, 24)
	GUICtrlSetState (-1, $GUI_DISABLE)
	$hNext = GUICtrlCreateButton ("Next", 75, 45, 60, 24)

	For $iCntRow = 0 to 4
		For $iCntCol = 0 to 5
			$iCurIndex = $iCntRow * 6 + $iCntCol
			$ahIcons[$iCurIndex] = GUICtrlCreateIcon ($sFilename, $iCurIndex, 60 * $iCntCol + 25, 70 * $iCntRow + 80)
			$ahLabels[$iCurIndex] = GUICtrlCreateButton ($iCurIndex, 60 * $iCntCol+11, 70 * $iCntRow + 115, 60, 20)
		Next
	Next
	GUICtrlSetState ($hFileSel, $GUI_DEFBUTTON)
	GUISetState (@SW_SHOW, $IconSelector)

	While 1
		$iMsg = GUIGetMsg ()
		Switch $iMsg
			Case 0
				ContinueLoop
			Case $GUI_EVENT_CLOSE
				GUIDelete ($IconSelector)
				Return SetError (1, 0, StringSplit ("|-1", "|"))
			Case $hFileSel
				$sTmpFile = FileOpenDialog ("Select file:", "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "Executables & dll's (*.exe;*.dll;*.ocx;*.icl)|Icons (*.ico)")
				If @error Then ContinueLoop
				If StringRight ($sTmpFile, 4) = ".ico" Then
					GUIDelete ($IconSelector)
					Return SetError (0, 0, StringSplit($sTmpFile & "|-1", "|"))
				EndIf
				GUICtrlSetData ($hFile, $sTmpFile)
				$iStartIndex = 0
				$sFilename = $sTmpFile
			Case $hPrev
				$iStartIndex -= 30
			Case $hNext
				$iStartIndex += 30
			Case Else
				For $iCntRow = 0 to 4
					For $iCntCol = 0 to 5
						$iCurIndex = $iCntRow * 6 + $iCntCol
						If $iMsg = $ahLabels[$iCurIndex] Then
							GUIDelete ($IconSelector)
							Return SetError (0, 0, StringSplit ($sFilename & "|" & $iCurIndex + $iStartIndex, "|"))
						EndIf
					Next
				Next
				ContinueLoop
		EndSwitch
		For $iCntRow = 0 to 4
			For $iCntCol = 0 to 5
				$iCurIndex = $iCntRow * 6 + $iCntCol
				GUICtrlSetImage ($ahIcons[$iCurIndex], $sFilename, $iCurIndex + $iStartIndex)
				GUICtrlSetData ($ahLabels[$iCurIndex], $iCurIndex + $iStartIndex)
			Next
		Next
		If $iStartIndex = 0 Then
			GUICtrlSetState ($hPrev, $GUI_DISABLE)
		Else
			GUICtrlSetState ($hPrev, $GUI_ENABLE)
		Endif        
	Wend
EndFunc

Func SelfRestart($iDelay = 0)
	FileDelete (@TempDir & "\temprestart.bat")
	FileWrite (@TempDir & "\temprestart.bat", 'ping -n ' & $iDelay & ' 127.0.0.1 > nul' & @CRLF _
	& '"' & @ScriptFullPath & '"' & @CRLF & 'ping -n 2 127.0.0.1 > nul' & @CRLF & 'del ' & @TempDir & '\temprestart.bat')
	Run (@TempDir & "\temprestart.bat", @TempDir, @SW_HIDE)
EndFunc

;===============================================================================
;
; Description:			_GUICtrlComboGetCurSel
; Parameter(s):		$h_combobox - controlID
; Requirement:			None
; Return Value(s):	The return value is the zero-based index of the currently selected item.
;							If no item is selected, it is $CB_ERR
; User CallTip:		_GUICtrlComboGetCurSel($h_combobox) Retrieve the index of the currently selected item, if any, in the list box of a combo box (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlComboGetCurSel($h_combobox)
	If IsHWnd($h_combobox) Then
		Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_combobox, "int", $CB_GETCURSEL, "int", 0, "int", 0)
		Return $a_ret[0]
	Else
		Return GUICtrlSendMsg($h_combobox, $CB_GETCURSEL, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlComboGetCurSel

;===============================================================================
;
; Description:			_GUICtrlComboSetCurSel
; Parameter(s):		$h_combobox - controlID
;							$i_index - Specifies the zero-based index of the string to select
; Requirement:			None
; Return Value(s):	If the message is successful, the return value is the index of the item selected.
;							If $i_index is greater than the number of items in the list or if $i_index is –1,
;							the return value is $CB_ERR and the selection is cleared
; User CallTip:		_GUICtrlComboSetCurSel($h_combobox, $i_index) Select a string in the list of a combo box (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				If this $i_index is –1, any current selection in the list is removed and the edit control is cleared
;
;===============================================================================
Func _GUICtrlComboSetCurSel($h_combobox, $i_index)
	If IsHWnd($h_combobox) Then
		Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_combobox, "int", $CB_SETCURSEL, "int", $i_index, "int", 0)
		Return $a_ret[0]
	Else
		Return GUICtrlSendMsg($h_combobox, $CB_SETCURSEL, $i_index, 0)
	EndIf
EndFunc   ;==>_GUICtrlComboSetCurSel