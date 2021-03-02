#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=..\..\icons1\A\Recycle Bin Full 3.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <sqlite.au3>
#include <sqlite.dll.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiComboBoxEx.au3>
#include <GuiButton.au3>



Global $aRow , $Users, $DialogPartner, $DiaPartner, $NumRecDeleted ,$OpsExecuted,$SkypeCmdLine
Dim $TempList[1],$ListOfChages[30][2]

Const $Dbase = "main.db"
Const $Dir = @AppDataDir & "\Skype"; marcobtj\"
Const $IconRoot =  @SystemDir & "\shell32.dll"

$OpsExecuted = 0
$NumRecDeleted = 0
$TempList[0]=0
$OldUser = ""
$Users = LoadUsers()
$SelPartner="NULL"
$SkypeCmdLine=""

if ProcessExists("Skype.exe") then ;need to close skype to access the database
	$SkypeCmdLine = showmeitpliz("Skype.exe")
	if ProcessClose("Skype.exe") == 0 then exit 333
	ProcessWaitClose("Skype.exe",5)
EndIf

$Form1 = GUICreate("CLEAR SINGLE SKYPE USER HISTORY by Hermano", 573, 82, 250, 156, $GUI_SS_DEFAULT_GUI, BitOR($WS_EX_TOPMOST,$WS_EX_WINDOWEDGE))
$Combo1 = GUICtrlCreateCombo("", 8, 24, 257, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1,$Users,First($Users))
$Combo2 = GUICtrlCreateCombo("", 304, 24, 257, 25,bitor($CBS_DROPDOWN ,$WS_VSCROLL,$WS_DISABLED))
$Label1 = GUICtrlCreateLabel("FIRST select the skype user ...", 8, 2, 193, 21)
$Label2 = GUICtrlCreateLabel("THEN choose the contact to clear", 312, 2, 169, 21)
$Label3 = GUICtrlCreateLabel("",400, 55, 169, 21)

$B_Exec= GUICtrlCreateButton("",200, 48, 38, 34, $BS_ICON+$WS_DISABLED)
GUICtrlSetImage(-1, $IconRoot ,290,0)
GUICtrlSetTip(-1, "Execute histrory clean-up")
$B_Abort= GUICtrlCreateButton("",240, 48, 38, 34, $BS_ICON +$WS_DISABLED)
GUICtrlSetImage(-1, $IconRoot ,255,0) ;320
GUICtrlSetTip(-1, "Rollback each operation")
$B_Exit= GUICtrlCreateButton("",280, 48, 38, 34, $BS_ICON)
GUICtrlSetImage(-1, $IconRoot ,320,0) ;320
GUICtrlSetTip(-1, "Exit and Update the Database")


GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		case $Combo1
			if _GUICtrlComboBoxEx_GetDroppedState ($Combo1)= false then
				$SelUser = GUICtrlRead($Combo1)
				$DbFile = $Dir &"\"&$SelUser&"\"&$Dbase
					;$DbFile=$Dbase ;****************purely for testing purpose
				if NOT OpenSql($DbFile,$SelUser) then     ;check it is a realdatabase
					$DiaPartner = SqlUserCollection()
					WriteDataToCombo2()
					_SQLite_Exec(-1,"SAVEPOINT startingpoint")
					GUICtrlSetState($Combo1,$GUI_DISABLE)
				EndIf

			EndIf
		case $Combo2
			if _GUICtrlComboBoxEx_GetDroppedState ($Combo2)= false then
				$SelPartner = GUICtrlRead($Combo2)
				GUICtrlSetState($B_Exec,$GUI_ENABLE)
			EndIf

		case $B_Exec
				GUICtrlSetState($B_Abort,$GUI_ENABLE)
				$OpsExecuted +=1
				$cmd = "DELETE FROM Messages WHERE chatname LIKE ""%"&$SelPartner& "%"";"
				_SQLite_Exec(-1,$cmd)
				if @error then ConsoleWrite("Ec: " & _SQLite_ErrCode() & " Em: " & _SQLite_ErrMsg())

				$Nchg = _SQLite_TotalChanges() ;track record of changes
				$ListOfChages[$OpsExecuted][0]=$SelPartner
				$ListOfChages[$OpsExecuted][1]=$Nchg
				$ListOfChages[0][0] = $OpsExecuted
				$NumRecDeleted += $Nchg
				GUICtrlSetData($Label3,"Record Deleted =" & $NumRecDeleted)
				CleanDataStr ($Combo2,$SelPartner) ;clean user from the combobox

		case $B_Abort
				$NumRecDeleted -= $ListOfChages[$OpsExecuted][1]
				ReAddDataStr($Combo2,$ListOfChages[$OpsExecuted][0])
				GUICtrlSetData($Label3,"Record Deleted =" & $NumRecDeleted)
				_SQLite_Exec(-1,"ROLLBACK TO startingpoint")
				$OpsExecuted -=1
				$ListOfChages[0][0] = $OpsExecuted

		Case $GUI_EVENT_CLOSE, $B_Exit
				_SQLite_Exec(-1,"RELEASE SAVEPOINT startingpoint")
				_SQLite_Close()
				_SQLite_Shutdown()
				consoleWrite ("===>"& $SkypeCmdLine)
				if $SkypeCmdLine <> "" then Run($SkypeCmdLine)
				exit 0
	EndSwitch
sleep(40)
WEnd


;Func OpenSql opens sql file
;
;
Func OpenSql($dB,$Element)
	$hDb=0
	_SQLite_Startup ()
	$hDb =_SQLite_Open ($dB)
	_SQLite_Exec(-1,"SELECT * FROM DbMeta")
	if @error then
		GUICtrlSetData($Label3,"Not an active user")
		CleanDataStr ($Combo1,$Element)
		sleep(1000)
		GUICtrlSetData($Label3,"")
		return -1
	EndIf
EndFunc

;Func CleanDataStr from ComboBox erases an element and reloads
;
;
Func CleanDataStr ($Box,$Element)
	$Index = _GUICtrlComboBox_FindString($Box, $Element)
	_GUICtrlComboBox_DeleteString($Box, $Index)
   _GUICtrlComboBox_SetCurSel($Box, 0)
EndFunc
;Func ReAddDataStr restoring missing element in the combo
;
;
func ReAddDataStr($Box,$Element)
_GUICtrlComboBox_InsertString($Box, $Element,0)
_GUICtrlComboBox_SetCurSel($Box, 0)
EndFunc
;Func SqlUserCollection parses the database and cleans double entries
;
;
func SqlUserCollection()
	Local $FinalArray
	$Cursor= MouseGetCursor()
	GUISetCursor(15,1) ; set on wait
	_SQLite_Exec(-1,"SELECT dialog_partner FROM Messages ORDER BY dialog_partner ASC;", "Wrt")
	$TempList[0]=Ubound($TempList) -1
	$FinalArray = CleanArray($TempList)
	GUISetCursor($Cursor,1)
	return $FinalArray
EndFunc
Func WriteDataToCombo2 ()
	GUICtrlSetData($Combo2,PartnersLoad($DiaPartner),$DiaPartner[1])
	GUICtrlSetState($Combo2,$GUI_ENABLE)
endFunc
;Func clean doubles in the array
;
;
Func CleanArray($tmp)
Local $dum = 1
Dim $F_List[1]
	$F_List[0]= 0
	if $TempList[0]=0 then exit 500 ;to make sure there were no errors in the query
	For $dum = 1 to $TempList[0] -1
		if $TempList[$dum] = "" then ContinueLoop
		if $TempList[$dum]<>$TempList[$dum+1] then
			_ArrayAdd($F_List,$TempList[$dum])
		endif
	Next
	if $TempList[$TempList[0]-1] <> $TempList[$TempList[0]] then
		_ArrayAdd($F_List,$TempList[$TempList[0]])  ;add last element
	EndIf
	$F_List[0]= UBound($F_List)-1
	return $F_List
EndFunc
;Func WRT loads the array with sql return values
;
;
func Wrt ($aRow)
	For $s In $aRow
		_ArrayAdd($TempList,$s)
    Next
EndFunc
; Func First extract first elements of string
;
;
Func First ($a)
	$str =  StringSplit($a,"|")
	return ($str[1])
endFunc
;Func PartnersLoad concatenate the DiaPartner list
;
;
Func PartnersLoad($list)
	Local $FullList
	for $dum = 1 to $list[0]
		$FullList &= $list[$dum] & "|"
	next
 return StringTrimRight($FullList,1)
EndFunc
;Func LoadUsers concatenate all elements of the client list
;
;
Func LoadUsers()
	Local $FullList
	$list = _FileListToArray($Dir,"*",2)
	for $dum = 1 to $list[0]
		if StringLeft ($list[$dum],6) <> "shared" then
		$FullList &= $list[$dum] & "|"
		EndIf
	next
	;ConsoleWrite ("======> "& $FullList)
 return StringTrimRight($FullList,1)
EndFunc
; Func ShowMeitPliz  provides me with Skype Command line thanks Mass Smammer!
;
;

Func showmeitpliz($proc, $strComputer=".")

  $oWMI=ObjGet("winmgmts:{impersonationLevel=impersonate}!\\" & $strComputer & "\root\cimv2")
  $oProcessColl=$oWMI.ExecQuery("Select * from Win32_Process where Name= " & '"'& $Proc & '"')

  For $Process In $oProcessColl
	$Process=$Process.Commandline
 Next
return $process
EndFunc; ==>showmeitpliz()
