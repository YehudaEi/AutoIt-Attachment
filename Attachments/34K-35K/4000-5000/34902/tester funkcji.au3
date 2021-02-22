#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <GuiListView.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>

#include 'myFileListToArray_AllFiles.au3'

;Opt('MustDeclareVars', 1)

Global $gui, $label, $label_2, $bution, $listview, $Input_Filter, $Input_MinSiz, $Input_MaxSiz
Global $label_sPath, $label_filter, $label_3
Global $Input_Flag, $Input_Adress, $Input_methody, $Input_AccAtryb, $Input_NO_AccAtryb, $Imput_LevDown
Global $szukane = "*.mp?  ; *.wma ; *.wav; *.avi ; *.rmvb ; *.flv"
;Global $szukane = "*Au???t v* S*r?p*.au?"

Global $title = 'myFileListToArray_AllFiles()'

$gui = GUICreate($title, 920, 585, -1, -1, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
GUISetBkColor(0xF0F4F9)
$label = GUICtrlCreateLabel($szukane, 10, 12, 590, 20)
GUICtrlSetFont(-1, 12, 800)

$Input_Filter = GUICtrlCreateInput($szukane, 10, 40, 380, 20)

GUICtrlCreateLabel('* = 0 or more.     ? = 0 or 1.     ; = next pattern', 10, 60, 380, 20, $SS_CENTERIMAGE)
GUICtrlSetColor(-1, 0x0000ff)

$bution = GUICtrlCreateButton("Search", 412, 36, 129, 25)

$label_sPath = GUICtrlCreateLabel('$sPath = ', 715, 10, 200, 20, $SS_CENTERIMAGE)
$label_filter = GUICtrlCreateLabel('$sFilter = ' & $szukane, 715, 40, 200, 20, $SS_CENTERIMAGE)

GUICtrlCreateLabel('', 715, 70, 200, 3, $SS_SUNKEN)

GUICtrlCreateLabel('$iFlag= 1 (Default) [Optional]', 715, 80, 200, 20, $SS_CENTERIMAGE)
GUICtrlSetColor(-1, 0xff0000)
$Input_Flag = GUICtrlCreateInput('1', 715, 100, 40, 20, $ES_NUMBER + $ES_READONLY)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlCreateUpdown(-1)
GUICtrlSetLimit(-1, 2, 0)
GUICtrlCreateLabel('0 = all, 1 = files, 2 = folders', 760, 100, 140, 20, $SS_CENTERIMAGE)

GUICtrlCreateLabel('$full_adress = 1 (Default is True) [Optional]', 715, 140, 200, 20, $SS_CENTERIMAGE)
GUICtrlSetColor(-1, 0xff0000)
$Input_Adress = GUICtrlCreateInput('1', 715, 160, 40, 20, $ES_NUMBER + $ES_READONLY)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlCreateUpdown(-1)
GUICtrlSetLimit(-1, 1, 0)
GUICtrlCreateLabel('0 = file name, 1 = full adress', 760, 160, 140, 20, $SS_CENTERIMAGE)

GUICtrlCreateLabel('$methody = 1 (Default) [Optional]', 715, 200, 200, 20, $SS_CENTERIMAGE)
GUICtrlSetColor(-1, 0xff0000)
$Input_methody = GUICtrlCreateInput('1', 715, 220, 40, 20, $ES_NUMBER + $ES_READONLY)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlCreateUpdown(-1)
GUICtrlSetLimit(-1, 1, 0)
GUICtrlCreateLabel('0 = simple, 1 = is full pattern', 760, 220, 140, 20, $SS_CENTERIMAGE)

GUICtrlCreateLabel('$size_min = 0 (Default) [Optional]', 715, 260, 200, 20, $SS_CENTERIMAGE)
GUICtrlSetColor(-1, 0xff0000)
$Input_MinSiz = GUICtrlCreateInput('0', 715, 280, 40, 20, $ES_NUMBER)
GUICtrlCreateLabel('minmal size [MB]', 760, 280, 140, 20, $SS_CENTERIMAGE)

GUICtrlCreateLabel('$size_max = 0 (Default) [Optional]', 715, 320, 200, 20, $SS_CENTERIMAGE)
GUICtrlSetColor(-1, 0xff0000)
$Input_MaxSiz = GUICtrlCreateInput('0', 715, 340, 40, 20, $ES_NUMBER)
GUICtrlCreateLabel('maxymal size [MB]', 760, 340, 140, 20, $SS_CENTERIMAGE)

GUICtrlCreateLabel('$Accept_Attribute = "" (Default) [Optional]', 715, 380, 200, 20, $SS_CENTERIMAGE)
GUICtrlSetColor(-1, 0xff0000)
$Input_AccAtryb = GUICtrlCreateInput('', 715, 400, 40, 20)
GUICtrlCreateLabel('accept attribute', 760, 400, 140, 20, $SS_CENTERIMAGE)
GUICtrlCreateLabel('attribute: R,A,S,H,N,D,O,C,T', 740, 420, 140, 20, $SS_CENTERIMAGE)
GUICtrlSetColor(-1, 0x0000ff)
GUICtrlSetTip(-1, 'String returned could contain a combination of these letters "RASHNDOCT":' & @CRLF & _
		'"R" = READONLY' & @CRLF & '"A" = ARCHIVE ' & @CRLF & '"S" = SYSTEM ' & @CRLF & '"H" = HIDDEN ' & @CRLF & _
		'"N" = NORMAL ' & @CRLF & '"D" = DIRECTORY ' & @CRLF & '"O" = OFFLINE ' & @CRLF & _
		'"C" = COMPRESSED (NTFS compression, not ZIP compression) ' & @CRLF & '"T" = TEMPORARY')

GUICtrlCreateLabel('$NO_Accept_Attribute = "" (Default) [Optional]', 715, 450, 200, 20, $SS_CENTERIMAGE)
GUICtrlSetColor(-1, 0xff0000)
$Input_NO_AccAtryb = GUICtrlCreateInput('', 715, 470, 40, 20)
GUICtrlCreateLabel('NO accept attribute', 760, 470, 140, 20, $SS_CENTERIMAGE)

GUICtrlCreateLabel('attribute: R,A,S,H,N,D,O,C,T', 740, 490, 140, 20, $SS_CENTERIMAGE)
GUICtrlSetColor(-1, 0x0000ff)
GUICtrlSetTip(-1, 'String returned could contain a combination of these letters "RASHNDOCT":' & @CRLF & _
		'"R" = READONLY' & @CRLF & '"A" = ARCHIVE ' & @CRLF & '"S" = SYSTEM ' & @CRLF & '"H" = HIDDEN ' & @CRLF & _
		'"N" = NORMAL ' & @CRLF & '"D" = DIRECTORY ' & @CRLF & '"O" = OFFLINE ' & @CRLF & _
		'"C" = COMPRESSED (NTFS compression, not ZIP compression) ' & @CRLF & '"T" = TEMPORARY')

GUICtrlCreateLabel('$LevelTooDown = 0 (Default) [Optional]', 715, 520, 200, 20, $SS_CENTERIMAGE)
GUICtrlSetColor(-1, 0xff0000)
$Imput_LevDown = GUICtrlCreateInput('0', 715, 540, 40, 20, $ES_NUMBER + $ES_READONLY)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlCreateUpdown(-1)
GUICtrlCreateLabel('0 = all, 1 = 1lev, x = xlev, ect', 760, 540, 200, 20, $SS_CENTERIMAGE)
$label_2 = GUICtrlCreateLabel('"+" = tree level down, "-" = level up', 740, 560, 200, 20, $SS_CENTERIMAGE)
GUICtrlSetColor(-1, 0x0000ff)
GUICtrlSetTip(-1, 'how many level too down / up' & @CRLF & _
		'0 = full tree (all files)' & @CRLF & _
		'1 = search only one folder' & @CRLF & _
		'2 = 2 level down' & @CRLF & _
		'3 = 3 level down' & @CRLF & _
		'x = x level down' & @CRLF & _
		'-1 = 1 level up (+ full tree)' & @CRLF & _
		'-2 = 2 level up (+ full tree)' & @CRLF & _
		'-x = x level up (+ full tree)')

$listview = GUICtrlCreateListView("No|WYNIK WYSZUKIWANIA|Nazwa|Format|Size[MB]", 10, 80, 700, 480)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
GUICtrlSendMsg($listview, 0x101E, 0, 35)
GUICtrlSendMsg($listview, 0x101E, 1, 350)
GUICtrlSendMsg($listview, 0x101E, 2, 170)
GUICtrlSendMsg($listview, 0x101E, 3, 60)
GUICtrlSendMsg($listview, 0x101E, 4, 60)
_GUICtrlListView_SetSelectedColumn($listview, 1)

$label_3 = GUICtrlCreateLabel('speed: = = = = ', 20, 560, 200, 20, $SS_CENTERIMAGE)
GUICtrlSetColor(-1, 0x0000ff)

GUISetState(@SW_SHOW)
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")

While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			Exit
		Case $bution
			Search_Files()
	EndSwitch
	Sleep(20)
WEnd

Func Search_Files()
	Local $mySave = IniRead(@ScriptDir & "\configbot.ini", "tester", "File Select", @ScriptDir)
	Local $var = FileSelectFolder("", '', "", $mySave, $gui)
	IniWrite(@ScriptDir & "\configbot.ini", "tester", "File Select", $var)
	Local $FileList
	Local $ile = 0
	Local $Skrucona_Nazwa
	Local $format
	Local $rozmiar
	Local $mTimer
	Local $myExtended = 0
	Local $i, $id
	Local $SEARCH = GUICtrlRead($Input_Filter)
	Local $myFlag = GUICtrlRead($Input_Flag)
	Local $myAdress = GUICtrlRead($Input_Adress)
	Local $myMethody = GUICtrlRead($Input_methody)
	Local $size_min = GUICtrlRead($Input_MinSiz)
	Local $size_max = GUICtrlRead($Input_MaxSiz)
	Local $myAccAtryb = GUICtrlRead($Input_AccAtryb)
	Local $myNOAccAtryb = GUICtrlRead($Input_NO_AccAtryb)
	Local $myLevTooDown = GUICtrlRead($Imput_LevDown)

	For $i = $Input_Filter To $label_2
		GUICtrlSetState($i, $GUI_DISABLE)
	Next

	WinSetTitle($gui, "", $title & '     [ 0 / 0 ]')
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($listview))

	GUICtrlSetData($label, "Sprawdzam  " & $var)
	GUICtrlSetData($label_sPath, '$sPath = ' & $var)
	GUICtrlSetData($label_3, 'test speed = START')
	ConsoleWrite(myConsoleWriteTXT($var, $SEARCH, $myFlag, $myAdress, $myMethody, $size_min, $size_max, $myAccAtryb, $myNOAccAtryb, $myLevTooDown))

	$mTimer = TimerInit()
	$FileList = myFileListToArray_AllFiles($var, $SEARCH, $myFlag, $myAdress, $myMethody, $size_min, $size_max, $myAccAtryb, $myNOAccAtryb, $myLevTooDown)
	$myExtended = @extended
	GUICtrlSetData($label_3, 'test speed = ' & TimerDiff($mTimer) / 1000 & ' sek.')

	If IsArray($FileList) Then
		local $array_AD[UBound($FileList)-1][5]
		For $id = 1 To $FileList[0]
			$ile = $ile + 1
			$Skrucona_Nazwa = StringRegExpReplace($FileList[$id], "((?:.*?[\\/]+)*)(.*?\z)", "$2")
			$format = StringRegExpReplace($FileList[$id], "((?:.*?[\\/.]+)*)(.*?\z)", "$2")
			If $format = $Skrucona_Nazwa Then $format = ''
			$rozmiar = Round(FileGetSize($FileList[$id]) / 1048576, 2)

			;GUICtrlCreateListViewItem($ile & '|' & $FileList[$id] & '|' & $Skrucona_Nazwa & '|' & $format & '|' & $rozmiar, $listview)
			$array_AD[$id-1][0]= $ile
			$array_AD[$id-1][1]= $FileList[$id]
			$array_AD[$id-1][2]=  $Skrucona_Nazwa
			$array_AD[$id-1][3]=  $format
			$array_AD[$id-1][4]= $rozmiar
			;WinSetTitle($gui, "", StringFormat(' [ [ %s / %s ] / %s ]  %s', $ile, $FileList[0], $myExtended, $FileList[$id]))
		Next
		_GUICtrlListView_AddArray($listview, $array_AD)
	EndIf

	WinSetTitle($gui, "", ' [' & $ile & ' / ' & $myExtended & ' ]  succes / all files')

	For $i = $Input_Filter To $label_2
		GUICtrlSetState($i, $GUI_ENABLE)
	Next

	GUICtrlSetData($label, $SEARCH);'lista plikow')

EndFunc   ;==>Search_Files


Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndListView, $tInfo
	$hWndListView = $listview
	If Not IsHWnd($listview) Then $hWndListView = GUICtrlGetHandle($listview)

	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $hWndListView
			Switch $iCode
				Case $LVN_COLUMNCLICK ; A column was clicked
					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
					Local $B_DESCENDING[_GUICtrlListView_GetColumnCount($listview)]
					_GUICtrlListView_SimpleSort($hWndListView, $B_DESCENDING, DllStructGetData($tInfo, "SubItem"))
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY


Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg
	Local $hWndFrom, $iIDFrom, $iCode
	$hWndFrom = $ilParam
	$iIDFrom = BitAND($iwParam, 0xFFFF) ; Low Word
	$iCode = BitShift($iwParam, 16) ; Hi Word
	Switch $hWndFrom
		Case GUICtrlGetHandle($Input_Filter)
			Switch $iCode
				Case $EN_UPDATE
					GUICtrlSetData($label_filter, '$sFilter = ' & GUICtrlRead($Input_Filter))
			EndSwitch
	EndSwitch
EndFunc   ;==>WM_COMMAND

Func myConsoleWriteTXT($pth, $flt, $flg, $adr, $meth, $min, $max, $Acpt, $NOacpt, $LevD)
	If $max - $min < 0 Then $max = 0
	If $LevD <> 0 Then Return StringFormat('myFileListToArray_AllFiles("%s", "%s", %s, %s, %s, %s, %s, "%s", "%s", %s)', _
			$pth, $flt, $flg, $adr, $meth, $min, $max, $Acpt, $NOacpt, $LevD) & @CRLF
	If $NOacpt <> '' Then Return StringFormat('myFileListToArray_AllFiles("%s", "%s", %s, %s, %s, %s, %s, "%s", "%s")', _
			$pth, $flt, $flg, $adr, $meth, $min, $max, $Acpt, $NOacpt) & @CRLF
	If $Acpt <> '' Then Return StringFormat('myFileListToArray_AllFiles("%s", "%s", %s, %s, %s, %s, %s, "%s")', _
			$pth, $flt, $flg, $adr, $meth, $min, $max, $Acpt) & @CRLF
	If $max <> 0 Then Return StringFormat('myFileListToArray_AllFiles("%s", "%s", %s, %s, %s, %s, %s)', _
			$pth, $flt, $flg, $adr, $meth, $min, $max) & @CRLF
	If $min <> 0 Then Return StringFormat('myFileListToArray_AllFiles("%s", "%s", %s, %s, %s, %s)', _
			$pth, $flt, $flg, $adr, $meth, $min) & @CRLF
	If $meth <> 1 Then Return StringFormat('myFileListToArray_AllFiles("%s", "%s", %s, %s, %s)', _
			$pth, $flt, $flg, $adr, $meth) & @CRLF
	If $adr <> 1 Then Return StringFormat('myFileListToArray_AllFiles("%s", "%s", %s, %s)', _
			$pth, $flt, $flg, $adr) & @CRLF
	If $flg <> 1 Then Return StringFormat('myFileListToArray_AllFiles("%s", "%s", %s)', _
			$pth, $flt, $flg) & @CRLF
	If $flt = '*.*' Or $flt = '*' Or $flt = '' Then Return StringFormat('myFileListToArray_AllFiles("%s")', _
			$pth) & @CRLF
	Return StringFormat('myFileListToArray_AllFiles("%s", "%s")', _
			$pth, $flt) & @CRLF
EndFunc   ;==>myConsoleWriteTXT