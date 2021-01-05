#Include <GUIConstants.au3>
#Include <GuiCombo.au3>
#Include <GuiListView.au3>
#NoTrayIcon
Opt("TrayMenuMode",1)   
TraySetState()
TraySetToolTip("Window Management")

Dim $WinListGUI
AdlibEnable("_UpdateWinList",1000)

;// Window List GUI
$WinListGUI = GuiCreate("Currently available windows",465,350)
GUICtrlSetFont(9,600)
$CheckBox1 = GUICtrlCreateCheckbox("Set trans for all MSN Windows",10,20,160,20)
$SliderData = GUICtrlCreateLabel("100 % Visible",230,7,100,20)
GUICtrlSetState(-1,$GUI_HIDE)
$WinSlider = GUICtrlCreateSlider(180,20,150,20)
$ListWinList = GUICtrlCreateListView("Window Title|State",0,60,330,290)
$Thelast = GUICtrlCreateLabel("",20,50,50,20)
GUICtrlCreateGroup("Window Options",333,58,130,292)
$StateCombo = GUICtrlCreateCombo("Minimize",345,80,105,22)
$Button1 = GUICtrlCreateButton("Set Title",345,150,105,22)
$Button2 = GUICtrlCreateButton("Set Transparency",345,180,105,22)
$Button3 = GUICtrlCreateButton("Win Minimize All",345,210,105,22)
$Button4 = GUICtrlCreateButton("Undo Minimize",345,240,105,22)
$Button5 = GUICtrlCreateButton("Set Allways OnTop",345,270,105,22)
$Button6 = GUICtrlCreateButton("Remove OnTop",345,300,105,22)

GUICtrlSetLimit($WinSlider,255,0)
GUICtrlSetData($WinSlider,255)
_GUICtrlComboAddString($StateCombo,"Maximize")
_GUICtrlComboAddString($StateCombo,"Restore")
_GUICtrlComboAddString($StateCombo,"Enable")
_GUICtrlComboAddString($StateCombo,"Disable")
_GUICtrlListViewSetColumnWidth($ListWinList, 0, 225)
_GUICtrlListViewSetColumnWidth($ListWinList, 1, 100)
$p = 100
$last = 100
GUISetState(@SW_Hide)

;// Tray Menu
$Winlistitem = TrayCreateItem("Show Winlist")
TrayCreateItem("")
$Exititem = TrayCreateItem("Exit")
TraySetState()



While 1
    $msg_array = GUIGetMsg(1)
	$msg = $msg_array[0] 
	$winActive = $msg_array[1] 
	$p = GuictrlRead($WinSlider)    
	
	If $last = $p Then	
	Else
		GUICtrlSetData($SliderData,$p & " % Visible")
		$last = $p	
	Endif
	
	Select
		Case $msg = $GUI_EVENT_CLOSE
			GUISetState(@SW_Hide)
		
		Case $msg = $Button1 
			$Gettxt = _GUICtrlListViewGetItemText($ListWinList, _GUICtrlListViewGetCurSel($ListWinList), 0)
			$Answer1 = InputBox("Set New Title", "Input the new title for the window", "", "",235,160)
			If NOT @Error Then WinSetTitle($Gettxt,"",$Answer1)
		
		Case $msg = $Button2
			$Gettxt = _GUICtrlListViewGetItemText($ListWinList, _GUICtrlListViewGetCurSel($ListWinList), 0)
			$Answer2 = InputBox("Set The Transparency", "Input a number between 0 and 255, were:" &@CRLF&@CRLF& "0 is invisible and 255 is totaly visible", "", "",235,160)
			If NOT @Error Then WinSetTrans($Gettxt,"",$Answer2)
		
		Case $msg = $Button3
			WinMinimizeAll()
		
		Case $msg = $Button4
			WinMinimizeAllUndo()
			
		Case $msg = $Button5	
			$Gettxt = _GUICtrlListViewGetItemText($ListWinList, _GUICtrlListViewGetCurSel($ListWinList), 0)
			WinSetOnTop($Gettxt, "", 1)
		
		Case $msg = $Button6
			$Gettxt = _GUICtrlListViewGetItemText($ListWinList, _GUICtrlListViewGetCurSel($ListWinList), 0)
			WinSetOnTop($Gettxt, "", 0)
		
		Case $msg = $StateCombo
			$Gettxt2 = _GUICtrlListViewGetItemText($ListWinList, _GUICtrlListViewGetCurSel($ListWinList), 0)
			If GUICtrlRead($StateCombo) = "Minimize" Then WinSetState($Gettxt2,"",@SW_Minimize)
			If GUICtrlRead($StateCombo) = "Maximize" Then WinSetState($Gettxt2,"",@SW_Maximize)
			If GUICtrlRead($StateCombo) = "Restore" Then WinSetState($Gettxt2,"",@SW_Restore)
			If GUICtrlRead($StateCombo) = "Enable" Then WinSetState($Gettxt2,"",@SW_Enable)
			If GUICtrlRead($StateCombo) = "Disable" Then WinSetState($Gettxt2,"",@SW_Disable)
	EndSelect
_GetTrayMsg()
WEnd





Func _UpdateWinList()
	$Selectet = _GUICtrlListViewGetCurSel($ListWinList)
	_GUICtrlListViewDeleteAllItems($ListWinList)
	$var = WinList()
	For $i = 1 to $var[0][0]
		If $var[$i][0] <> "" AND IsVisible($var[$i][1]) Then
			If $var[$i][0] = "Program Manager" Then ContinueLoop
			;Check to se if MSN should be trans
			If GUICtrlRead($CheckBox1) = 1 Then 
				If NOT GUICtrlRead($SliderData) = GUICtrlread($TheLast) Then
					If StringRight($var[$i][0],9) = "- Samtale" Or StringRight($var[$i][0],9) = "- Conversation" Then WinSetTrans($var[$i][0],"",GUICtrlRead($SliderData)-1)
				EndIf
			EndIf
			GUICtrlCreateListViewItem($var[$i][0] &"|"& _GetState($var[$i][0]),$ListWinList)
			_GUICtrlListViewSetItemSelState($ListWinList, $Selectet)
		EndIf
	Next
EndFunc

Func _GetState($hTitle)
	$State = WinGetState($hTitle, "")
	If BitAnd($state, 16) Then 
		Return "Minimized"
	Else
		Return "Maximized"
	EndIf
EndFunc	

Func _GetTrayMsg()
$Traymsg = TrayGetMsg()
Select	
	Case $Traymsg = $Winlistitem
		_UpdateWinList()
		GUISetState(@SW_Show)
           
	Case $Traymsg = $Exititem 
		Exit
EndSelect
EndFunc

Func IsVisible($handle)
  If BitAnd( WinGetState($handle), 2 ) Then 
    Return 1
  Else
    Return 0
  EndIf
EndFunc
