;lasftfile_tabs.au3 0_2
#include <GUIConstants.au3>
#Include <GuiTab.au3>
#include <Constants.au3>
#include <Date.au3>
#include <_GUICtrlListView.au3>
#region--lastfiles
Global $hide_state = 0, $btn_state = 0, $pass = 0
Global $Button_[15], $Label_[15], $config_[8],$listview_[10],$dossier[10],$t_tab[10]
$hwnd= GUICreate("Sliding Launcher", 603, 85+85, -588, -1, -1,  BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW, $WS_EX_ACCEPTFILES))
$config_[1] = GUICtrlCreateLabel("Label Name", 15, 32, 60, 20)
$config_[2] = GUICtrlCreateInput("", 75, 30, 80, 20)
$config_[3] = GUICtrlCreateLabel("Program to Launch", 175, 32, 100, 20)
$config_[4] = GUICtrlCreateInput("", 270, 30, 255, 20)
GUICtrlSetState( -1, $GUI_DROPACCEPTED )
$config_[5] = GUICtrlCreateButton("Cancel", 530, 5, 50, 20)
$config_[6] = GUICtrlCreateButton("Browse", 530, 30, 50, 20)
$config_[7] = GUICtrlCreateButton("Accept", 530, 55, 50, 20)
For $x = 1 To 7
    GUICtrlSetState($config_[$x], $GUI_HIDE)
Next
;~ ;$author = GUICtrlCreateLabel(" By...   Simucal  &&  Valuater", 120, 25, 400, 40)
;~ ;GUICtrlSetFont(-1, 20, 700)
$Show = GUICtrlCreateButton(">", 585, 8, 17, 155, BitOR($BS_CENTER, $BS_FLAT))
GUISetState(@SW_HIDE, $hwnd)
$hwnd2 = GUICreate("Sliding Launcher", 603, 160+160, 3, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
$Hide = GUICtrlCreateButton("<", 585, 8, 17, 155, BitOR($BS_CENTER, $BS_FLAT, $BS_MULTILINE))
$Edit = GUICtrlCreateButton("[]", 0, 8, 15, 155, BitOR($BS_CENTER, $BS_FLAT, $BS_MULTILINE))
GUICtrlSetTip(-1, "Config")
;DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd2, "int", 100, "long", 0x00040001);slide in from left
GUISetState()
Opt("TrayMenuMode", 1)
Opt("TrayOnEventMode", 1)
 $config_tray = TrayCreateItem("Configure...")
 TrayItemSetOnEvent(-1, "Set_config")
TrayCreateItem("")
$exit_tray = TrayCreateItem("Exit  Sliding Launcher")
TrayItemSetOnEvent(-1, "Set_Exit")
TraySetState()
$nombretabs= 2
$nombretabs=IniRead("lastfilesettings.ini","tab","number","error")
;If $nombretabs= "error" Then
;	MsgBox(0,"Error","Impossible to find the number of tabs")
;	Exit
;EndIf

;$dossier="H:\"
$nombrecolonne=2
;$gui=GUICreate("Last Files Browser",500,420,300,150)
;$gui=GUICreate("Last Files Browser")
$exec = GUICtrlCreateButton ( "Refresh", 5, 280,100 )
$jourenmoins = GUICtrlCreateButton ( "Day -1", 110, 280,80 )
$jourenplus = GUICtrlCreateButton ( "Day +1", 200, 280,80 )
$ouvrir = GUICtrlCreateButton ( "Open", 290, 280,100 )
$delete= GUICtrlCreateButton ( "Delete", 420, 280,100 )
global $MouseDown = 0, $jour=0,$mois=@MON,$i_PrevLine=0
global $sNewDate = _NowCalcDate(),	$s_AnswerFile=@ScriptDir&"\AnswerFindLines.txt",$s_AnswerFileSorted=@ScriptDir&"\AnsSorted.txt"
global $s_AnswerFile2=@ScriptDir&"\AnswerFindLines2.txt",$i_MinJour=0, $ar_ArrayLists[1],$i_Found=0,$ar_DatesArray[1];,$ar_Files[1]
global $s_FindFiles=@ScriptDir&"\FindFiles.txt"
$s_FindFiles=FileGetShortName($s_FindFiles)
$s_AnswerFile=FileGetShortName($s_AnswerFile)
$s_AnswerFile2=FileGetShortName($s_AnswerFile2)
$s_AnswerFileSorted=FileGetShortName($s_AnswerFileSorted)
$tab=GUICtrlCreateTab(20,2,560,260)
$timertotal=TimerInit()
For $i=0 To $nombretabs-1
	;$dossier[0]=@ScriptDir&"\"
	;$dossier[1]=@ScriptDir&"\backup\"
	$dossier[$i]=IniRead("lastfilesettings.ini","tab","folder"& $i,"error")
	If $dossier[$i]="error" Then MsgBox (0,"error","error tab " & $i)
	$t_tab[$i]=GUICtrlCreateTabItem($dossier[$i])
	$listview_[$i]=_GUICtrlCreateListView("Files written on "& _DateTimeFormat($sNewDate,1) & "            | Heure |Size...Mb|Ext",20,22,560,240,$LVS_REPORT)
	$timerstamp1 = TimerInit()
	_FileList($dossier[$i])
	$ar_Files=__FileListToArray($dossier[$i])
	_FileSetIconDefault($listview_[$i])
	ConsoleWrite("_FirstList :"&round(TimerDiff($timerstamp1)) & " mseconds to search. for "& $dossier[$i]&@lf)
	_refresh($dossier[$i],$listview_[$i])
	;$listview_[$i_tab]=_GUICtrlCreateListView("Files created the " & _DateTimeFormat($sNewDate,1) & " | Heure ",10,30,575,315,$LVS_REPORT)
	_GUICtrlListViewSetColumnWidth($listview_[$i],0,300)
	_GUICtrlListViewJustifyColumn($listview_[$i], 2,1)
	;_GUICtrlListViewHideColumn($listview_[$i_tab],3)
	_GUICtrlTabSetCurFocus($tab,$i)
Next
GUISetState (@SW_SHOW,$t_tab[$i])
ConsoleWrite("_FirstList :"&round(TimerDiff($timertotal)) & " mseconds to search. for total"&@lf)
TimerStop($timerstamp1)
TimerStop($timertotal)
Local $B_DESCENDING
$timerstamp1 = TimerInit()
$i_LISTVIEWPrevcolumn=1
GUISetState ()
$ar_Files=__FileListToArray($dossier[$i])
_refresh($dossier[0],$listview_[0])
_GUICtrlTabSetCurFocus($tab, 0)
;GUISetState ()
global $i_PrevTab=0
#endregion
While 1
	$msg1 = GUIGetMsg()
	If $msg1 = $GUI_EVENT_CLOSE Then Exit
	If $msg1 = $Hide Then
		If $pass = 1 Then
			WinSetTitle($hwnd2, "", "Sliding Launcher")
			$pass = 0
		Else
			Slide_out()
		EndIf
	EndIf
	If $msg1 = $Show Then Slide_in()
		;_GUICtrlTabSetCurFocus($tab, $i_PrevTab)
		;_refresh($dossier[$i_PrevTab],$listview_[$i_PrevTab])
	;EndIf
		
	If $msg1 = $Edit Then $pass = 1
	$a_pos = WinGetPos($hwnd2)
	$a_pos2 = WinGetPos($hwnd)
	If $a_pos[0] <> 0 And $hide_state = 0 Then
		WinMove($hwnd2, "", 3, $a_pos[1])
		WinMove($hwnd, "", -588, $a_pos[1])
	EndIf
	If $a_pos2[0] <> - 588 And $hide_state = 1 Then
		WinMove($hwnd, "", -588, $a_pos2[1])
		WinMove($hwnd2, "", 3, $a_pos2[1])
	EndIf
	If $pass = 1 Then WinSetTitle($hwnd2, "", "Config Mode - Please Press the Button to Configure...  Press  ""<""  to Cancel")
	$i_tab= GUICtrlread ($tab)
	if $i_tab<> $i_PrevTab Then
		$i_PrevTab=$i_tab
		$MSG1 = $exec
	EndIf
	
	select ;code du programme
		Case $msg1 = $listview_[$i_tab]
			if GUICtrlGetState($listview_[$i_tab])=1 and $i_LISTVIEWPrevcolumn<>1 Then
				_refresh($dossier[$i_tab],$listview_[$i_tab])
				$i_LISTVIEWPrevcolumn=1; so if we click again, we reverse on the sort
			EndIf
				__GUICtrlListViewSort( $listview_[$i_tab],$B_DESCENDING,GUICtrlGetState($listview_[$i_tab])); normal sort/ reverese for other columns
		case $msg1 = $GUI_EVENT_CLOSE
			GUISetState(@SW_HIDE)
			exit
		Case $MSG1 = $exec
			$sNewDate = _DateAdd( 'd',$jour, _NowCalcDate())
			GUICtrlSetData($listview_[$i_tab],"Files written on " & _DateTimeFormat($sNewDate,1))
			$ar_Files=__FileListToArray($dossier[$i_tab])
			_refresh($dossier[$i_tab],$listview_[$i_tab])
		Case $msg1 = $ouvrir
			$index=_GUICtrlListViewGetCurSel($listview_[$i_tab])
			$run=_GUICtrlListViewGetItemText($listview_[$i_tab],$index,0)
			_Rundos("start " & $dossier[$i_tab] & '"' & $run & '"')
			Slide_out()
		Case $msg1= $delete
			$index=_GUICtrlListViewGetCurSel($listview_[$i_tab])
			$run=_GUICtrlListViewGetItemText($listview_[$i_tab],$index,0)
			$rep=MsgBox(4,"Delete","Remove : " & @CR & $run)
			If $rep=6 Then FileDelete($dossier[$i_tab] & $run )
		Case $msg1 = $jourenmoins
			$jour -= 1
			$sNewDate = _DateAdd( 'd',$jour, _NowCalcDate())
			GUICtrlSetData($listview_[$i_tab],"Files created the " & _DateTimeFormat($sNewDate,1))
				$i_MinJour=$jour
				$timerstamp1 = TimerInit()
				_refresh($dossier[$i_tab],$listview_[$i_tab])
				ConsoleWrite("_refresh :"&round(TimerDiff($timerstamp1)) & " mseconds to search."&@lf)
		Case $msg1 = $jourenplus
			if $jour then
				$jour += 1
				$sNewDate = _DateAdd( 'd',$jour, _NowCalcDate())
				$timerstamp1 = TimerInit()
				GUICtrlSetData($listview_[$i_tab],"Files created the " & _DateTimeFormat($sNewDate,1))
				_refresh($dossier[$i_tab],$listview_[$i_tab])
				ConsoleWrite("_refreshArray :"&round(TimerDiff($timerstamp1)) & " mseconds to search."&@lf)
			EndIf
	EndSelect
	If $msg1 = $GUI_EVENT_PRIMARYDOWN Then
		If $MouseDown = 0 Then
			$MouseDown = TimerInit()
		Else
			If TimerDiff($MouseDown) < 200 Then
				$SelectLine = StringSplit((GUICtrlRead(GUICtrlRead($listview_[$i_tab]))),"|")
				$run=$SelectLine[1]
				ConsoleWrite("dossier : " & $dossier & @CR)
				_Rundos("start " & $dossier & '"' & $run & '"')
			EndIf
		EndIf
	EndIf
	; Réinitialise le compteur si aucun autre click n'est détécté
	If $MouseDown > 0 And TimerDiff($MouseDown) > 200 Then $MouseDown = 0
WEnd
Func Slide_in()
	$hide_state = 0
	GUISetState(@SW_HIDE, $hwnd)
	DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd2, "int", 100, "long", 0x00040001);slide in from left
	GUISetState(@SW_SHOW, $hwnd2)
	WinActivate($hwnd2)
	WinWaitActive($hwnd2)
	_GUICtrlTabSetCurFocus($tab, 0)
	_GUICtrlTabSetCurFocus($tab, 1)
	_GUICtrlTabSetCurFocus($tab, $i_PrevTab)
EndFunc   ;==>Slide_in
Func Slide_out()
	$hide_state = 1
	DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd2, "int", 100, "long", 0x00050002);slide out to left
	GUISetState(@SW_HIDE, $hwnd2)
	GUISetState(@SW_SHOW, $hwnd)
	WinActivate($hwnd)
	WinWaitActive($hwnd)
EndFunc   ;==>Slide_out
Func Function(ByRef $b)
	Slide_out() 
EndFunc   ;==>Function
Func Set_Exit()
	Exit
EndFunc   ;==>Set_Exit
Func Set_Config()
	$a_pos = WinGetPos($hwnd)
	If $a_pos[0] = 3 Then Return
	Slide_in()
	$pass = 1
EndFunc   ;==>Set_Config
Func _FileList($dossier)
	$dossierShort=FileGetShortName($dossier)
	$sCommand=	" dir " & $dossierShort & "*.*   /TW/Od /-C /a-d-h-s | FIND "&'"/"'&"> " &  $s_AnswerFile2
	_RunDOS($sCommand)
EndFunc   ;==>_FileList
Func _refresh($dossier,$liste)
	local $szIconFile
	$searchquierie=_DateTimeFormat($sNewDate,2)
	_LockAndWait3()
	__GUICtrlListViewDeleteAllItems($liste)
	if StringLen($searchquierie)=9 then $searchquierie="0"&$searchquierie
;	for $k= $i_PrevLine to UBound($ar_Files)-1
	for $k= 0 to UBound($ar_Files)-1
		If StringInStr($ar_Files[$k],$searchquierie) Then
			$tmp=StringMid($ar_Files[$k],12)
			_GUICtrlCreateListViewItem($tmp,$liste)
			$i_Found=1
		Elseif  $i_Found then
			;$i_PrevLine=$k
			$i_Found=0
			ExitLoop
		EndIf
	Next
	_ResetLockWait3()
	_GUIListViewReDim()
	redim $ar_ArrayLists[ubound($ar_ArrayLists)+1]
	$ar_ArrayLists[-$jour]=$ar_LISTVIEWArray
EndFunc   ;==>_refresh
