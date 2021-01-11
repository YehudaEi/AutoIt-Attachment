#include <GUIConstants.au3>
Opt("GUIResizeMode", 1)
Opt("TrayIconDebug", 1)
HotKeySet("{F5}", "_DataRefresh")
Global $Version = "v0.01"

#CS ===========================================================================
	==== Section: 	Primary GUI Componenets ( Core GUI [ GO | STOP | BACK | ETC ] ).
#CE ===========================================================================
$InetExplorer = ObjCreate("Shell.Explorer.2") ; Create the initial Object Shell
$InetExplorer.RegisterAsBrowser = 1

$GUI = GUICreate( "BrowseIt " & $Version, 640, 580, (@DesktopWidth - 640) / 2, (@DesktopHeight - 580) / 2, BitOR($WS_OVERLAPPEDWINDOW, $WS_VISIBLE, $WS_CLIPSIBLINGS))
GUISetBkColor(0xF4F3EE)
$GUIActiveX = GUICtrlCreateObj($InetExplorer, 5, 75, 630, 480)
$GUI_Button_Back = GUICtrlCreateButton("Back", 4, 21, 100, 30)
$GUI_Button_Forward = GUICtrlCreateButton("Forward", 105, 21, 100, 30)
$GUI_Button_Stop = GUICtrlCreateButton("Stop", 206, 21, 100, 30)
$GUI_Button_Home = GUICtrlCreateButton("Home", 307, 21, 100, 30)
$GUI_Button_Refresh = GUICtrlCreateButton("Refresh", 408, 21, 100, 30)
$GUI_Button_Go = GUICtrlCreateButton("Go", 576, 52, 60, 22, $BS_DEFPUSHBUTTON)
$GUI_Input_Address = GUICtrlCreateInput("", 5, 53, 570, 20, "", BitOr($WS_EX_CLIENTEDGE, $WS_EX_ACCEPTFILES) )
$GUI_Label_Status = GUICtrlCreateLabel("", 5, 560, 200, 20)

#CS ===========================================================================
	==== Section: 	Menu GUI Creation.
#CE ===========================================================================
$GUI_File_Menu = GUICtrlCreateMenu("&File")
$GUI_File_Exit = GUICtrlCreateMenuitem("Exit", $GUI_File_Menu)

$GUI_Tools_Menu = GUICtrlCreateMenu("&Tools")
$GUI_Tools_Home = GUICtrlCreateMenuitem("Set Homepage", $GUI_Tools_Menu)
$GUI_Tools_Conf = GUICtrlCreateMenuitem("Configure Options", $GUI_Tools_Menu)

$GUI_Book_Menu = GUICtrlCreateMenu("&Bookmarks")

$GUI_Help_Menu = GUICtrlCreateMenu("&Help")

$GUI_About_Menu = GUICtrlCreateMenu("&About")

#CS ===========================================================================
	==== Section: 	GUI State Changes and finalizing creation of GUI.
#CE ===========================================================================
$GET_HomePage = RegRead("HKCU\Software\BrowseIt", "HomePage")
If @error Then
	$InetExplorer.Navigate ("http://www.autoitscript.com")
Else
	$InetExplorer.Navigate ($GET_HomePage)
EndIf
Do
	Sleep(100)
Until Not $InetExplorer.Busy
GUICtrlSetData($GUI_Input_Address, $InetExplorer.LocationURL)
GUICtrlSetFont($GUI_Label_Status, 9, 600)
GUICtrlSetColor($GUI_Label_Status, 0x0782C0)
GUICtrlSetState($GUI_Input_Address, $GUI_DROPACCEPTED)
;GUICtrlSetState($GUI_Button_Back, $GUI_DISABLE)
GUICtrlSetState($GUI_Button_Forward, $GUI_DISABLE)
GUISetState()

#CS ===========================================================================
	==== Section: 	*__*  MAIN LOOP  *__* *__*  MAIN LOOP  *__* *__*  MAIN LOOP
#CE ===========================================================================
While 1
	$msg = GUIGetMsg()
	_IsBusy()
	
	Select
		
		Case $msg = $GUI_Button_Go
			_rData()
			
		Case $msg = $GUI_Button_Back
			$InetExplorer.GoBack
			
		Case $msg = $GUI_Button_Forward
			$InetExplorer.GoForward
			
		Case $msg = $GUI_Button_Home
			_GetHomePage()
			
		Case $msg = $GUI_Button_Refresh
			_DataRefresh()
			
		Case $msg = $GUI_Tools_Home
			_SetHomePage()
			
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $GUI_File_Exit
			_Terminate()
			
	EndSelect
	
WEnd

#CS ===========================================================================
	==== Section: 	*__* FUNCTIONS  *__* *__*  FUNCTIONS  *__* *__*  FUNCTIONS
#CE ===========================================================================

#CS ===========================================================================
	==== Name:	_Terminate
	==== Description:	Terminates the GUI and ends the script.
#CE ===========================================================================
Func _Terminate()
	
	Local $ConfirmTerminate = MsgBox(36, "Terminate!", "Are you sure?")
	
	If $ConfirmTerminate = 6 Then
		GUIDelete($GUI)
		Exit
	ElseIf $ConfirmTerminate = 7 Then
		Return
	EndIf
	
EndFunc   ;==>_Terminate

#CS ===========================================================================
	==== Name:	_IsBusy
	==== Description:	Determines if GUI is busy, and displays loading if so.
#CE ===========================================================================
Func _IsBusy()
	Local $IsBusy = 0
	Local $ReadLabel = GUICtrlRead($GUI_Label_Status)
	Local $ReadAddr  = GUICtrlRead($GUI_Input_Address)
	
	While $InetExplorer.Busy
		$IsBusy += 1
		
		Select
			Case $IsBusy = 1
				GUICtrlSetData($GUI_Label_Status, "Loading")
				Sleep(250)
			Case $IsBusy = 2
				GUICtrlSetData($GUI_Label_Status, "Loading.")
				Sleep(250)
			Case $IsBusy = 3
				GUICtrlSetData($GUI_Label_Status, "Loading..")
				Sleep(250)
			Case $IsBusy = 5
				GUICtrlSetData($GUI_Label_Status, "Loading...")
				Sleep(250)
			Case $IsBusy = 6
				GUICtrlSetData($GUI_Label_Status, "Loading..")
				Sleep(250)
			Case $IsBusy = 7
				GUICtrlSetData($GUI_Label_Status, "Loading.")
				Sleep(250)
			Case $IsBusy = 8
				GUICtrlSetData($GUI_Label_Status, "Loading")
				Sleep(250)
			Case $IsBusy = 9
				$IsBusy = 0
		EndSelect
		
		If  $ReadAddr <> $InetExplorer.LocationURL  Then
			GUICtrlSetData($GUI_Input_Address, $InetExplorer.LocationURL)
		EndIf
	WEnd
	
	If StringInStr($ReadLabel, "Loading") Then
		GUICtrlSetData($GUI_Label_Status, "")
	EndIf
	
	Return
	
EndFunc   ;==>_IsBusy

#CS ===========================================================================
	==== Name:	_rData()
	==== Description:	Recieves the web data to be displayed.
#CE ===========================================================================
Func _rData()
	
	Local $Address_Read = GUICtrlRead($GUI_Input_Address)
	
	$InetExplorer.navigate ($Address_Read)
	Do
		_IsBusy()
	Until Not $InetExplorer.Busy
	GUICtrlSetData($GUI_Input_Address, $InetExplorer.LocationURL)
	
EndFunc   ;==>_rData

#CS ===========================================================================
	==== Name:	_DataRefresh()
	==== Description:	Refreshes the current page.
#CE ===========================================================================
Func _DataRefresh()
	
	$InetExplorer.Refresh
	
	Do
		_IsBusy()
	Until Not $InetExplorer.Busy
	GUICtrlSetData($GUI_Input_Address, $InetExplorer.LocationURL)
	
EndFunc   ;==>_DataRefresh

#CS ===========================================================================
	==== Name:	_SetHomePage()
	==== Description:	Adds a registry key in "HKCU\Software\BrowseIt" for the
	==== 				homepage, and sets its value according to the users input.
#CE ===========================================================================
Func _SetHomePage()
	
	Local $SET_HomePage = $InetExplorer.LocationURL
	
	If $SET_HomePage = "" Then
		MsgBox(0, "Error", "Warning, No homepage was set.")
	Else
		RegWrite("HKCU\Software\BrowseIt", "HomePage", "REG_SZ", $SET_HomePage)
	EndIf
	
EndFunc   ;==>_SetHomePage

#CS ===========================================================================
	==== Name:	_GetHomePage()
	==== Description:	Gets the registry key in "HKCU\Software\BrowseIt" for the
	==== 				homepage, and sets its value according to the keys data.
#CE ===========================================================================
Func _GetHomePage()
	
	$GET_HomePage = RegRead("HKCU\Software\BrowseIt", "HomePage")
	
	If @error Then
		$InetExplorer.Navigate ("http://www.autoitscript.com")
	Else
		$InetExplorer.Navigate ($GET_HomePage)
	EndIf
	Do
		Sleep(10)
	Until Not $InetExplorer.Busy
	GUICtrlSetData($GUI_Input_Address, $InetExplorer.LocationURL)
	
EndFunc   ;==>_GetHomePage