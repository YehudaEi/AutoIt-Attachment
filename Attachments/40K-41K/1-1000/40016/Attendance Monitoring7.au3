#include <GuiConstants.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <GUIConstantsEx.au3>
#include <GDIPlus.au3>
#include <Memory.au3>
#include <Webcam.au3>

#Include <GuiDateTimePicker.au3>
#include <GUIListBox.au3>
#include <ComboConstants.au3>
#Include <Array.au3>

#include "quote.au3"
#include <Misc.au3>
#Include <GuiButton.au3>
#include <Date.au3>
#include <File.au3>
#include <WinAPI.au3>
#include <GUIComboBox.au3>
#include <Timers.au3>
#include <GuiListView.au3>
#Include <String.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>

#AutoIt3Wrapper_Add_Constants=n

#region GLOBAL VARIABLES
Global $iW = 700, $iH = 600, $iT = 103, $iB = 52, $iLeftWidth = 150, $iGap = 10, $hMainGUI, $ht, $iStatus

Global Const $IMAGE_BITMAP = 0 ; Needed for GUICtrlSendMsg.
Global Const $STM_SETIMAGE = 0x0172 ; Needed for GUICtrlSendMsg.

global $hQuery , $dbfile
global $viewButton
global $deleteDb
global $closeButton
global $curID
global $Indexnew
global $Index
global $group,$editID,$editStatus
Global $result,$row,$column,$r1,$c1,$selArray,$guicolor
global $addButton
global $curAct,$curActHandle
global $curDate,$color,$qvals
global $donecheck
global $allcheck
global $newButton,$iTimer1,$iTimer2,$editWindow,$tasktypelist,$tasktypefilter
global $updateButton,$deleteButton,$zoomButton,$priority,$save,$cancel,$edit,$savedflag,$editContent,$textcolor,$quotecolor
global $itemactivity,$itemactivity,$itemstatus,$timeline,$dat,$quotechangeButton2
global $activelist,$viewClosed,$pipette,$QuoteID,$editWindowHandle,$quotenumber

Global $clock,$Cursor,$quoteLabel,$quotechangeButton,$changequoteCheck,$activitytable,$settingstable,$mastertable,$buttonfontname,$buttonfontsize

Global $iSearch, $iCID, $bCID, $bAttendance, $bFullname, $bFreligion, $bAddress, $bGender, $bStatus, $dateBirth, $bContact, $db, $nbrows, $nbcols
Global $recordtable, $aResult, $irow, $icolumn, $bRecord, $cRecord, $cRecord2, $bGetpic, $aSearch, $Sresult, $STresult, $STedt010, $sre, $sSearch, $aRow
Global $display,$lvitmstr,$lst010,$ret1,$ret2,$ret3,$ret4,$ret5,$ret6,$ret7,$ret8,$ret9,$ret10,$ret11,$ret12,$ret13,$ret14,$ret15,$ret16,$ret17,$ret18,$ret19,$ret20,$ret21,$ret22
Global $mFont="Calibri Bold"

#endregion GLOBAL VARIABLES

_MainGui()

Func _MainGui()
Local $hFooter, $nMsg, $aPos
Local $iLinks = 6
Local $sMainGuiTitle = "V 0.0.0.1"
Local $sHeader = "Attendace Monitoring"
Local $sFooter = "MCGI link"
Local $aLink[$iLinks], $aPanel[$iLinks]
$aLink[0] = $iLinks - 1
$aPanel[0] = $iLinks - 1
$hMainGUI = GUICreate($sMainGuiTitle, $iW, $iH, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_EX_OVERLAPPEDWINDOW)) ;$WS_MAXIMIZEBOX, $WS_TABSTOP
Local $GUIImage = GUICtrlCreatePic("..\Downloads\MCGI image\MCGI logo.bmp", 300, 5, 0, 0)

local $updatebuttoncolor,$deletebuttoncolor,$newbuttoncolor,$addbuttoncolor
$buttonfontname="Calibri Bold"
$buttonfontsize=9
$savedflag=0

$updatebuttoncolor="0x0000ff"
$deletebuttoncolor="0xff2301"
$newbuttoncolor="0x00B300"
$addbuttoncolor="0x00B300"
local $updatebuttoncolor,$deletebuttoncolor,$newbuttoncolor,$addbuttoncolor

$dbfile="churchid.db" ;<<----------------database file----------------dont delete in the directory

GUISetIcon("shell32.dll", -58, $hMainGUI)
GUICtrlCreateLabel($sHeader, 48, 30, $iW - 500, 32, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 14, 800, 0, "Arial", 5)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

GUICtrlCreateIcon("shell32.dll", -131, 8, 30, 32, 32)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlCreateLabel("", 0, $iT, $iW, 2, $SS_SUNKEN);separator
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)
GUICtrlCreateLabel("", $iLeftWidth, $iT + 2, 2, $iH - $iT - $iB - 2, $SS_SUNKEN);separator
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH)
GUICtrlCreateLabel("", 0, $iH - $iB, $iW, 2, $SS_SUNKEN);separator
GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)

$hFooter = GUICtrlCreateLabel($sFooter, 10, $iH - 34, $iW - 20, 17, BitOR($SS_LEFT, $SS_CENTERIMAGE))
GUICtrlSetTip(-1, "Members Church of God International", "Click to open...")
GUICtrlSetCursor(-1, 0)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT)

;add links to the left side
$aLink[1] = _AddNewLink("Brethrens")

_WebcamOpen($hMainGUI, 10, 330, 130, 130)

Local $hLabel = GUICtrlCreateLabel("", 12, 520, 90, 20)
GUICtrlSetResizing(-$hLabel, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetColor(-1, 0x0000CC)
GUICtrlSetFont(-1, 14.5, 600)
_HalfTime()
Local $thread = _ClockThisInAnotherThread($hLabel)

$aLink[2] = _AddNewLink("New Brethren", -167)
$aLink[3] = _AddNewLink("Visitors", -222)
$aLink[4] = _AddNewLink("Church Activities", -25)
$aLink[5] = _AddNewLink("Summary Report", -22)
;and the corresponding GUI's
$aPanel[1] = _AddNewPanel("Members Local of B. Pag-asa")
$aPanel[2] = _AddNewPanel("New Brethren Local of B. Pag-asa")
$aPanel[3] = _AddNewPanel("Visitors Local of B. Pag-asa")
$aPanel[4] = _AddNewPanel("Activities")
$aPanel[5] = _AddNewPanel("Summary")

;add some controls to the panels
;---------------------------------------------------------------------------------------------------------------
_AddControlsToPanel($aPanel[1])
;---------------------------------------------------------------------------------------------------------------
_updateView()
GUICtrlCreateGroup("", 10, 35, 530, 290)
GUICtrlCreateGroup("", 400, 45, 130, 160)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKALL + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlCreateGroup("Status :" & $iStatus, 400, 230, 130, 80)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKALL + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$iCID = GUICtrlCreateEdit("", 15, 345, 221, 41, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_UPPERCASE))
GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetFont(-1, 20, 400, 0, $mFont)
GUICtrlSetLimit(-1, 15)
GUICtrlSetTip(-1, "Type in your church ID")

;$sSearch = guictrlcreateedit("",20,145,221,41,BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_UPPERCASE))

$iSearch = GUICtrlCreateButton("<<Search Now", 245, 345, 100, 41)
GUICtrlSetResizing(-1 , $GUI_DOCKHCENTER + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

local $enter = guictrlcreatedummy()
Dim $aAccelerators[1][2] = [["{ENTER}", $Enter]]
GUISetAccelerators($aAccelerators)

local $enter    =    guictrlcreatedummy()

GUICtrlCreateLabel($ret6, 50, 75, 320, 100)
GUICtrlSetFont(-1, 50, 400, 0, $mFont)
GUICtrlCreateLabel("Westhills California USA", 100, 150, 190, 30)
GUICtrlSetFont(-1, 12, 400, 0, $mFont)
GUICtrlCreateLabel("picture here", 440, 120, 50, 15)
GUICtrlSetFont(-1, 8, 400, 0, $mFont)
GUICtrlCreateLabel("ACTIVE", 450, 270, 40, 20)
GUICtrlSetFont(-1, 10, 400, 0, $mFont)
;GUICtrlCreateLabel($ret4, 100, 290, 90, 20)
;GUICtrlSetFont(-1, 15, 400, 0, $mFont)

GUICtrlCreateLabel("Barcode Here", 150, 270, 90, 20)
GUICtrlSetFont(-1, 10, 400, 0, $mFont)
GUICtrlCreateLabel("", 920, 70, 190, 50)

;---------------------------------------------------------------------------------------------------------------
_AddControlsToPanel($aPanel[2])
;---------------------------------------------------------------------------------------------------------------
_updateView()

$bCID = GUICtrlCreateEdit("", 25, 55, 120, 20, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_UPPERCASE))
GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetFont(-1, 10, 400, 0, $mFont)
GUICtrlSetLimit(-1, 10)
GUICtrlSetTip(-1, "Enter Church ID")

$bGender=GUICtrlCreateCombo("Male",155,55,65,18,$CBS_DROPDOWNLIST) ; Combo Box
_GUICtrlComboBox_AddString($bGender,"Female")

$bFullname = GUICtrlCreateEdit("", 25, 80, 230, 20, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_UPPERCASE))
GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetFont(-1, 10, 400, 0, $mFont)
GUICtrlSetTip(-1, "Enter Full Name")

$bAddress = GUICtrlCreateEdit("", 25, 105, 230, 55, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_UPPERCASE))
GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetFont(-1, 10, 400, 0, $mFont)
GUICtrlSetTip(-1, "Enter Address")

$curDate = GUICtrlCreateDate("", 25, 165, 185, 20)
GUICtrlSetTip(-1, "Date of Baptism")
$dateBirth = GUICtrlCreateDate("", 25, 190, 185, 20)
GUICtrlSetTip(-1, "Date of Birth")

$bContact = GUICtrlCreateEdit("", 25, 215, 120, 20, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_NUMBER))
GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetFont(-1, 10, 400, 0, $mFont)
GUICtrlSetLimit(-1, 13)
GUICtrlSetTip(-1, "Contact Number")

$bFreligion = GUICtrlCreateEdit("", 25, 240, 120, 20, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_UPPERCASE))
GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetFont(-1, 10, 400, 0, $mFont)
GUICtrlSetLimit(-1, 20)
GUICtrlSetTip(-1, "Enter Previews Religion")

GUICtrlCreateGroup("", 10, 35, 530, 290)
$bGetpic = GUICtrlCreateGroup("", 400, 45, 130, 160)
GUICtrlCreateGroup("Status : EDIT" , 400, 230, 130, 80)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKALL + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

$bStatus=GUICtrlCreateCombo("Active",415,260,100,20,$CBS_DROPDOWNLIST) ; Combo Box
_GUICtrlComboBox_AddString($bStatus,"Inactive")
_GUICtrlComboBox_AddString($bStatus,"Suspended")
_GUICtrlComboBox_AddString($bStatus,"Missing")
_GUICtrlComboBox_AddString($bStatus,"Unknown")
_GUICtrlComboBox_AddString($bStatus,"Cast Out")

Local $inImage1 = GUICtrlCreateButton("Insert image", 420, 410, 75, 25)
GUICtrlSetResizing(-1, $GUI_DOCKHCENTER + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
Local $iSave1 = GUICtrlCreateButton("save", 505, 410, 35, 25)
GUICtrlSetResizing(-1, $GUI_DOCKHCENTER + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

$iCID2 = GUICtrlCreateInput("", 10, 345, 245, 41, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_UPPERCASE))
GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetFont(-1, 20, 400, 0, $mFont)
GUICtrlSetLimit(-1, 20)
GUICtrlSetTip(-1, "Search Engine for Name or Curch ID")
;---------------------------------------------------------------------------------------------------------------
_AddControlsToPanel($aPanel[3])
;---------------------------------------------------------------------------------------------------------------
_updateView()
;_MCGIupdateView()

GUICtrlCreateGroup("", 10, 35, 530, 290)
GUICtrlCreateGroup("", 400, 45, 130, 160)
;Local $iCID = GUICtrlCreateInput("", 15, 345, 221, 41, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_UPPERCASE))
;GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
;GUICtrlSetFont(-1, 20, 400, 0, "Minion Pro")
;GUICtrlSetLimit(-1, 10)
;GUICtrlSetTip(-1, "")

Local $vCam2 = GUICtrlCreateButton("View Cam", 335, 410, 75, 25)
GUICtrlSetResizing($vCam2 -30, $GUI_DOCKHCENTER + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
Local $inImage2 = GUICtrlCreateButton("Insert image", 420, 410, 75, 25)
GUICtrlSetResizing($inImage2, $GUI_DOCKHCENTER + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
Local $iSave2 = GUICtrlCreateButton("save", 505, 410, 35, 25)
GUICtrlSetResizing($iSave2 -30, $GUI_DOCKHCENTER + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
;---------------------------------------------------------------------------------------------------------------
_AddControlsToPanel($aPanel[4])
;---------------------------------------------------------------------------------------------------------------
_updateView()
;_MCGIupdateView()

$viewButton=GUIctrlcreateButton("ViewAll",0,0,50,25)

$deleteDb=GUICtrlcreateButton("Delete All",50,0,60,25)
$viewClosed=GUIctrlcreatebutton("ViewClosed",110,0,63,25)
$quotegroup=guictrlcreategroup("",5,470,395,143)

$quoteLabel=Guictrlcreatelabel("",10,480,385,110)
guictrlsetbkcolor($quoteLabel,"0xffffff")
$quotechangeButton=guictrlcreatebutton(">",375,590,20,20)
$quotechangeButton2=guictrlcreatebutton("<",355,590,20,20)
$changequoteCheck=guictrlcreateCheckbox("Auto change(every minute)",9,593,150,15)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Index=""
$Indexnew=""

GUICtrlSetFont($quoteLabel,9,400,1,"Arial Bold")
$group=GUICtrlCreateGroup("New Task", 1, 30, 395, 125)

$curID =GUICtrlCreateLabel("",11,50,20,13,$SS_CENTER)
$clockBorder=guictrlcreategroup("",195,445,203,28)
$clock=guictrlcreatelabel("",200,455,193,15)
guictrlsetbkcolor($clock,"0xffffff")
guictrlcreategroup("",-99,-99,1,1)

$pipette=guictrlcreatebutton("Skin color",3,450,60,20)
$pipette2=guictrlcreatebutton("Quote color",65,450,63,20)
$curAct=GUICtrlCreateEdit("",35,50,355,45,BitOr($WS_VSCROLL,$ES_MULTILINE,$ES_WANTRETURN))
$curActHandle=GUIctrlgethandle($curAct)

$timeline=GUictrlcreatelabel(" Timeline",5,105,45,15)
$curDate=GUIctrlCreateDate("",55,97,100,25)
$help=guictrlcreatebutton("HELP",60,50,35,20)

$allcheck=GUIctrlCreateCheckBox("Show Closed Tasks",190,5,112,15)
$updateButton=GUIctrlcreatebutton("update",10,125,50,25)
guictrlsetcolor($updateButton,$updatebuttoncolor)
guictrlsetfont($updateButton,$buttonfontsize,400,1,$buttonfontname)
$deleteButton=GUictrlcreatebutton("delete",60,125,50,25)
guictrlsetfont($deleteButton,$buttonfontsize,400,1,$buttonfontname)
guictrlsetcolor($deleteButton,$deletebuttoncolor)
$zoomButton=GUIctrlcreateButton("E->",4,70,30,25)
guictrlsetcolor($zoomButton,"0x0000FF")
GUIctrlsetfont($zoomButton,$buttonfontsize,400,1,$buttonfontname)
$priority=GUICtrlCreateCombo("Medium",170,97,60,25,$CBS_DROPDOWNLIST) ; Combo Box
_GUICtrlComboBox_AddString($priority,"High")
_GUICtrlComboBox_AddString($priority,"Low")
$donelabel=guictrlcreatelabel("",300,120,70,32,$SS_GRAYFRAME)
guictrlsetstate($donelabel,$GUI_DISABLE)
$donecheck=GUICtrlCreateCheckbox("Close",310,123,50,25)

$newButton=GUIctrlcreatebutton("new",190,125,50,25)
guictrlsetfont($newButton,$buttonfontsize,400,1,$buttonfontname)
guictrlsetcolor($newButton,$newbuttoncolor)
$addButton=GUIctrlCreatebutton("add",240,125,50,25)
guictrlsetfont($addButton,$buttonfontsize,400,1,$buttonfontname)
guictrlsetcolor($addButton,$addbuttoncolor)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlSetState($curAct,$GUI_FOCUS)
guictrlsetstate($newButton,$GUI_DISABLE)

;---------------------------------------------------------------------------------------------------------------
_AddControlsToPanel($aPanel[5])
;---------------------------------------------------------------------------------------------------------------
_updateView()
;_MCGIupdateView()

GUICtrlCreateTab(10, 40, 530, 347)
$TabSheet1 = GUICtrlCreateTabItem("Attendance")
$attendance = GUICtrlCreateListView("Church ID|Name|Date and Time Login|Gender|Status", 14, 70, 520, 304)
_GUICtrlListView_SetExtendedListViewStyle($attendance, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_CHECKBOXES, $LVS_EX_GRIDLINES))

$TabSheet2 = GUICtrlCreateTabItem("Church Record")
$cRecord = GUICtrlCreateListView("No.|ChurchID|FullName|Gender|Status|DateofBaptism|FormerReligion", 14, 70, 520, 304)
_GUICtrlListView_SetExtendedListViewStyle($cRecord, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_CHECKBOXES, $LVS_EX_GRIDLINES))

$TabSheet3 = GUICtrlCreateTabItem("Personal Record")
$cRecord2 = GUICtrlCreateListView("No.|ChurchID|FullName|DateofBirth|Address|ContactNumber|DateCreated", 14, 70, 520, 304)
_GUICtrlListView_SetExtendedListViewStyle($cRecord2, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_CHECKBOXES, $LVS_EX_GRIDLINES))

$TabSheet4 = GUICtrlCreateTabItem("Visitors")
$aVisitors = GUICtrlCreateListView("Visitors Name|Gender|Religion", 14, 70, 520, 304)
_GUICtrlListView_SetExtendedListViewStyle($aVisitors, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_CHECKBOXES, $LVS_EX_GRIDLINES))

$TabSheet5 = GUICtrlCreateTabItem("Activities")
$activelist= GuiCtrlCreateListView("ID|Activity|TimeLine|Status|Created|Due|Priority", 14, 70, 520, 304)
_GUICtrlListView_SetExtendedListViewStyle($activelist, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_CHECKBOXES, $LVS_EX_GRIDLINES))
GUICtrlSetState($activelist, $GUI_SHOW) ; will be display first

$TabSheet6 = GUICtrlCreateTabItem("Search Tab")
$aSearch = GUICtrlCreateListView("SearcResult1|SearcResult2|SearcResult3|SearcResult4|SearcResult5|SearcResult6|SearcResult7|SearcResult8", 14, 70, 520, 304)
_GUICtrlListView_SetExtendedListViewStyle($aSearch, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_CHECKBOXES, $LVS_EX_GRIDLINES))

;GUISetCoord (100, 10 ,$hGUImain)
GUIRegisterMsg($WM_TIMER, "WM_TIMER")
$iTimer1 = _Timer_SetTimer($hMainGUI, 3000)
$iTimer2= _Timer_settimer($hMainGUI,60000)

;set default to Panel1
GUISwitch($aPanel[1])
;show the main GUI

_CheckTable()
_settings()
_updateView()
_mCGIupdateView()
_updateColor()


GUISetState(@SW_SHOW, $hMainGUI)

While 1
Sleep(10)
$nMsg = GUIGetMsg(1)

_checkSelected()
Switch $nMsg[1]
	Case $hMainGUI
		Switch $nMsg[0]
			Case $GUI_EVENT_CLOSE
			Exit
			Case $GUI_EVENT_MINIMIZE, $GUI_EVENT_MAXIMIZE, $GUI_EVENT_RESTORE
				$aPos = WinGetPos($hMainGUI)
				$iW = $aPos[2]
				$iH = $aPos[3]
				For $i = 0 To $aPanel[0]
				WinMove($aPanel[$i], "", $iLeftWidth , $iT, $iW - $iLeftWidth , $iH - $iT - $iB - 20)
				;omitted - WinMove($aPanel[$i], "", $iLeftWidth + 2, $iT, $iW - $iLeftWidth + 2, $iH - $iT - $iB - 20)
			Next
			Case $aLink[1], $aLink[2], $aLink[3], $aLink[4], $aLink[5]
				For $i = 1 To $aLink[0]
				If $nMsg[0] = $aLink[$i] Then
				GUISetState(@SW_SHOW, $aPanel[$i])
				Else
				GUISetState(@SW_HIDE, $aPanel[$i])
				EndIf
			Next
			Case $hFooter
				ShellExecute("http://www.mcgi.org")
		EndSwitch

	Case $aPanel[1]
		Switch $nMsg[0]
			case 0;$iSearch
			;	_mCGIsearch()
			case $iSearch or $enter

			_sqlite_startup()
			$db=_sqlite_open($dbfile)

			$txt=Stringreplace(Stringreplace(guictrlread($iCID),"'",""),"|","")

			$ret1 = 'SELECT NO FROM record WHERE ChurchID = "' & $txt & '" ;' 			; get the value of NO
			_SQLite_QuerySingleRow($db, $ret1, $aRow)
			$ret2 &= $aRow[0] ; output1
			$ret3 = 'SELECT ChurchID FROM record WHERE NO = "' & $ret2 & '" ;'			; get the value of ChurchID
			_SQLite_QuerySingleRow($db, $ret3, $aRow)
			$ret4 &= $aRow[0] ; output2

			$ret5 = 'SELECT FullName FROM record WHERE ChurchID = "' & $ret4 & '" ;'	; get the value of FullName
			_SQLite_QuerySingleRow($db, $ret5, $aRow)
			$ret6 &= $aRow[0] ; output3
			$ret7 = 'SELECT Gender FROM record WHERE FullName = "' & $ret6 & '" ;'		; get the value of Gender
			_SQLite_QuerySingleRow($db, $ret7, $aRow)
			$ret8 &= $aRow[0] ; output4
			$ret9 = 'SELECT Status FROM record WHERE Gender = "' & $ret8 & '" ;'		; get the value of Status
			_SQLite_QuerySingleRow($db, $ret9, $aRow)
			$ret10 &= $aRow[0] ; output5
			$ret11 = 'SELECT DateofBaptism FROM record WHERE Status = "' & $ret10 & '" ;'		; get the value of DateofBaptism
			_SQLite_QuerySingleRow($db, $ret11, $aRow)
			$ret12 &= $aRow[0] ; output6
			$ret13 = 'SELECT DateofBirth FROM record WHERE DateofBaptism = "' & $ret12 & '" ;'	; get the value of DateofBirth
			_SQLite_QuerySingleRow($db, $ret13, $aRow)
			$ret14 &= $aRow[0] ; output7
			$ret15 = 'SELECT Address FROM record WHERE DateofBirth = "' & $ret14 & '" ;'		; get the value of Address
			_SQLite_QuerySingleRow($db, $ret15, $aRow)
			$ret16 &= $aRow[0] ; output8
			$ret17 = 'SELECT ContactNumber FROM record WHERE Address = "' & $ret16 & '" ;'		; get the value of ContactNumber
			_SQLite_QuerySingleRow($db, $ret17, $aRow)
			$ret18 &= $aRow[0] ; output9
			$ret19 = 'SELECT FormerReligion FROM record WHERE ContactNumber = "' & $ret18 & '" ;'	; get the value of FormerReligion
			_SQLite_QuerySingleRow($db, $ret19, $aRow)
			$ret20 &= $aRow[0] ; output10
			$ret21 = 'SELECT DateCreated FROM record WHERE FormerReligion = "' & $ret20 & '" ;'		; get the value of DateCreated
			_SQLite_QuerySingleRow($db, $ret21, $aRow)
			$ret22 &= $aRow[0] ; output11

			MsgBox(0, "Char From $ret2", $ret2)
			MsgBox(0, "Char From $ret4", $ret4)
			MsgBox(0, "Char from $ret6", $ret6)
			MsgBox(0, "Char from $ret8", $ret8)
			MsgBox(0, "Char from $ret10", $ret10)
			MsgBox(0, "Char from $ret12", $ret12)
			MsgBox(0, "Char from $ret14", $ret14)
			MsgBox(0, "Char from $ret16", $ret16)
			MsgBox(0, "Char from $ret18", $ret18)
			MsgBox(0, "Char from $ret20", $ret20)
			MsgBox(0, "Char from $ret22", $ret22)

			_GUIctrlListView_DeleteAllitems($cRecord)
			;0=NO 1=ChurchID 2=FullName 3=Gender 4=Status 5=DateofBaptism 6=DateofBirth 7=Address 8=ContactNumber 9=FormerReligion 10=DateCreated
			;guictrlsetbkcolor(-1,$cl)

;			_ArrayDisplay($aResult)
	_SQLite_Close()
	_SQLite_Shutdown()


			case 0

		EndSwitch

	Case $aPanel[2]
		Switch $nMsg[0]
			Case 0


			Case $inImage1
				Local $hQuery, $aRow
				Local $x = 120, $y = 141
				$GUIImage = GUICtrlCreatePic("",556, 160, $x, $y)
				$filename = FileOpenDialog("Select image", @ScriptDir, "Image (*.jpg;*.bmp)", 3)

;				_SQLite_Startup()
;						ConsoleWrite("_SQLite_LibVersion=" & _SQLite_LibVersion() & @CRLF)
;						_GDIPlus_Startup()
;						 $hBitmap = _GDIPlus_ScaleImage($filename, $x , $y)
;						 $hHBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap)
;						 $bImage = _GDIPlus_SaveImage2BinaryString($hBitmap)
;						;~ MsgBox(0, "Binary", $bImage)
;
;						_WinAPI_DeleteObject(GUICtrlSendMsg($GUIImage, $STM_SETIMAGE, $IMAGE_BITMAP, $hHBitmap)) ; Does not seems to work
;
;						;_WinAPI_DeleteObject(GUICtrlSendMsg($GUIImage, $STM_SETIMAGE, $IMAGE_BITMAP, $hBitmap)) ; Also tried this with no luck
;						_WinAPI_DeleteObject($hHBitmap)
;						_SQLite_Open()
;						; Without $sCallback it's a resultless statement
;						_SQLite_Exec(-1, "Create table brImage (a);" & _
;							"Insert into brImage values ($GUIImage);")
;
;						Local $d = _SQLite_Exec(-1, "Select rowid,* From brImage", "_cb") ; _cb will be called for each row

;				_SQLite_Close()
;				_SQLite_Shutdown()

			Case $iSave1()
				_MCGIaddRecord()

		EndSwitch
	Case $aPanel[3]
		Switch $nMsg[0]
			case 0

		EndSwitch
	Case $aPanel[4]
		Switch $nMsg[0]
			case $changequoteCheck()
				_changequoteCheck()

			CASE $quotechangeButton()
				_UpdateQuoteForce()
			CASE $quotechangeButton2()
				_UpdateQuoteForce2()

			case $help
				$hmsg="HELP DOCUMENT: 				       Application Version 1.2"&@CRLF & _
					"-------------------- 				       -------------------------" &@CRLF & _
					"ViewAll(button): This will display the Database in a popup window.User can copy records from this pop up window by using the copy button there"&@CRLF & _
					"DeleteAll(button) : This will delete all the tasks permanently from the database"& @CRLF & _
					"ViewClosed(button) : This will show all the closed tasks in a popup window." & @CRLF & _
					"view all(checkbox): This will filter the Open tasks and Closed Tasks"& @CRLF & _
					"add(button) : This will add the current entry to database"& @CRLF & _
					"new(button) : This will clear the current entries and let the user to enter new data in the fields"& @CRLF & _
					"update(button): This will update the Database with the updated fields(description,date,priority and Done(status))"& @CRLF & _
					"delete(button) : This will delete the currently selected task permenantly from the database"& @CRLF & _
					"Timeline(calander) :User can set the deadline date for the task using calendar" & @CRLF & _
					"Priority list: User can set the priority for the selected task"& @CRLF & _
					"Close (checkbox):To update the status of task to Closed, select this check box and click update button"& @CRLF & _
					"Notes:"&@CRLF & _
					"--------"& @CRLF & _
					"1.Any change in the task description,date,priority,Timeline and Status (Close:checkbox) should be explicitly updated by clicking the *Update* button"& @CRLF & _
					"2.Have a WINDOWS SHORT CUT created for this Application on your task bar :)"&@CRLF&@CRLF & _
					"Caution"&@CRLF & _
					"----------"&@CRLF & _
					"Dont delete the *myactivities.db* file which is created in the current folder.This is the database file containing all the task list"&@CRLF& _
					""&@CRLF&@CRLF & _
					"For queries contact:  athankappan@prysm.com"

					guisetstate(@SW_DISABLE,$hMainGUI)
					Msgbox(0,"Help",$hmsg)
					guisetstate(@sw_enable,$hMainGUI)
					guisetstate(@sw_restore,$hMainGUI)
			case $viewButton

				_viewAll()
			case $deleteDB
				_deleteDB()
			case $newButton()
				_newButton()
			case $zoomButton
				_zoomButton()
			case $viewClosed()
				_viewClosed()
			case $addButton

				_addButton()
			case $pipette()
				_pipette()
			case $pipette2()
				_pipette2()
			case $updateButton()

				_updateDB()
			case $deleteButton()
				_deleteButton()
			case $allcheck()
				_allCheck()

		EndSwitch
	Case $aPanel[5]
		Switch $nMsg[0]
			Case 0
				;$activelist= GuiCtrlCreateListView("ID|Activity|TimeLine|Status|Created|Due|Priority", 1, 160, 398, 290) ; List Vew
				;_GUICtrlListView_SetExtendedListViewStyle($activelist, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_CHECKBOXES))
		EndSwitch

EndSwitch
WEnd
EndFunc ;==>_MainGui

Func _AddNewLink($sTxt, $iIcon = -44)
Local $hLink = GUICtrlCreateLabel($sTxt, 36, $iT + $iGap, $iLeftWidth - 46, 17)
GUICtrlSetCursor(-1, 0)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlCreateIcon("shell32.dll", $iIcon, 10, $iT + $iGap, 16, 16)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$iGap += 22
Return $hLink
EndFunc ;==>_AddNewLink

Func _AddNewPanel($sTxt)
Local $gui = GUICreate("", $iW - $iLeftWidth + 2, $iH - $iT - $iB, $iLeftWidth + 2, $iT, $WS_CHILD + $WS_VISIBLE, -1, $hMainGUI)
GUICtrlCreateLabel($sTxt, 10, 10, $iW - $iLeftWidth - 20, 17, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 9, 800, 4, "Arial", 5)
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
Return $gui
EndFunc ;==>_AddNewPanel

Func _AddControlsToPanel($hPanel)
GUISwitch($hPanel)
EndFunc ;==>_AddControlsToPanel


Func _GDIPlus_SaveImage2BinaryString($hBitmap, $iQuality = 50, $bSave = False, $sFilename = "Converted.jpg") ;coded by Andreik, modified by UEZ
    Local $sImgCLSID = _GDIPlus_EncodersGetCLSID("jpg")
    Local $tGUID = _WinAPI_GUIDFromString($sImgCLSID)
    Local $pEncoder = DllStructGetPtr($tGUID)
    Local $tParams = _GDIPlus_ParamInit(1)
    Local $tData = DllStructCreate("int Quality")
    DllStructSetData($tData, "Quality", $iQuality) ;quality 0-100
    Local $pData = DllStructGetPtr($tData)
    _GDIPlus_ParamAdd($tParams, $GDIP_EPGQUALITY, 1, $GDIP_EPTLONG, $pData)
    Local $pParams = DllStructGetPtr($tParams)
    Local $hStream = DllCall("ole32.dll", "uint", "CreateStreamOnHGlobal", "ptr", 0, "bool", True, "ptr*", 0) ;http://msdn.microsoft.com/en-us/library/ms864401.aspx
    If @error Then Return SetError(1, 0, 0)
    $hStream = $hStream[3]
    DllCall($ghGDIPDll, "uint", "GdipSaveImageToStream", "ptr", $hBitmap, "ptr", $hStream, "ptr", $pEncoder, "ptr", $pParams)
    _GDIPlus_BitmapDispose($hBitmap)
    Local $hMemory = DllCall("ole32.dll", "uint", "GetHGlobalFromStream", "ptr", $hStream, "ptr*", 0) ;http://msdn.microsoft.com/en-us/library/aa911736.aspx
    If @error Then Return SetError(2, 0, 0)
    $hMemory = $hMemory[2]
    Local $iMemSize = _MemGlobalSize($hMemory)
    Local $pMem = _MemGlobalLock($hMemory)
    $tData = DllStructCreate("byte[" & $iMemSize & "]", $pMem)
    Local $bData = DllStructGetData($tData, 1)
    Local $tVARIANT = DllStructCreate("word vt;word r1;word r2;word r3;ptr data;ptr")
    Local $aCall = DllCall("oleaut32.dll", "long", "DispCallFunc", "ptr", $hStream, "dword", 8 + 8 * @AutoItX64, "dword", 4, "dword", 23, "dword", 0, "ptr", 0, "ptr", 0, "ptr", DllStructGetPtr($tVARIANT)) ;http://msdn.microsoft.com/en-us/library/windows/desktop/ms221473(v=vs.85).aspx
    _MemGlobalFree($hMemory)
    If $bSave Then
        Local $hFile = FileOpen(@ScriptDir & "" & $sFilename, 18)
        FileWrite($hFile, $bData)
        FileClose($hFile)
    EndIf
    Return $bData
EndFunc   ;==>_GDIPlus_SaveImage2BinaryString

Func _GDIPlus_ScaleImage($sFile, $iW, $iH, $iInterpolationMode = 7) ;coded by UEZ 2012
    If Not FileExists($sFile) Then Return SetError(1, 0, 0)
    Local $hImage = _GDIPlus_ImageLoadFromFile($sFile)
    If @error Then Return SetError(2, 0, 0)
    Local $hBitmap = DllCall($ghGDIPDll, "uint", "GdipCreateBitmapFromScan0", "int", $iW, "int", $iH, "int", 0, "int", 0x0026200A, "ptr", 0, "int*", 0)
    If @error Then Return SetError(3, 0, 0)
    $hBitmap = $hBitmap[6]
    Local $hBmpCtxt = _GDIPlus_ImageGetGraphicsContext($hBitmap)
    DllCall($ghGDIPDll, "uint", "GdipSetInterpolationMode", "handle", $hBmpCtxt, "int", $iInterpolationMode)
    _GDIPlus_GraphicsDrawImageRect($hBmpCtxt, $hImage, 0, 0, $iW, $iH)
    _GDIPlus_ImageDispose($hImage)
    _GDIPlus_GraphicsDispose($hBmpCtxt)
    Return $hBitmap
EndFunc   ;==>_GDIPlus_ScaleImage

Func _ClockThisInAnotherThread($hControl)

    ; Get kernel32.dll handle
    Local $aCall = DllCall("kernel32.dll", "ptr", "GetModuleHandleW", "wstr", "kernel32.dll")

    If @error Or Not $aCall[0] Then
        Return SetError(1, 0, 0)
    EndIf

    Local $hHandle = $aCall[0]

    ; Get addresses of functions from kernel32.dll. Sleep first:
    Local $aSleep = DllCall("kernel32.dll", "ptr", "GetProcAddress", _
            "ptr", $hHandle, _
            "str", "Sleep")

    If @error Or Not $aCall[0] Then
        Return SetError(2, 0, 0)
    EndIf

    Local $pSleep = $aSleep[0]

    ; GetTimeFormatW then:
    Local $aGetTimeFormatW = DllCall("kernel32.dll", "ptr", "GetProcAddress", _
            "ptr", $hHandle, _
            "str", "GetTimeFormatW")

    If @error Or Not $aCall[0] Then
        Return SetError(3, 0, 0)
    EndIf

    Local $pGetTimeFormatW = $aGetTimeFormatW[0]

    ; Get user32.dll handle
    $aCall = DllCall("kernel32.dll", "ptr", "GetModuleHandleW", "wstr", "user32.dll")

    If @error Or Not $aCall[0] Then
        Return SetError(4, 0, 0)
    EndIf

    $hHandle = $aCall[0]

    ; Get address of function from user32.dll, SendMessageW:
    Local $aSendMessageW = DllCall("kernel32.dll", "ptr", "GetProcAddress", _
            "ptr", $hHandle, _
            "str", "SendMessageW")

    If @error Or Not $aCall[0] Then
        Return SetError(5, 0, 0)
    EndIf

    Local $pSendMessageW = $aSendMessageW[0]

    ; Allocate enough memory with PAGE_EXECUTE_READWRITE for code to run
    $aCall = DllCall("kernel32.dll", "ptr", "VirtualAlloc", _
            "ptr", 0, _
            "dword", 82, _
            "dword", 4096, _ ; MEM_COMMIT
            "dword", 64) ; PAGE_EXECUTE_READWRITE

    If @error Or Not $aCall[0] Then
        Return SetError(6, 0, 0)
    EndIf

    Local $pRemoteCode = $aCall[0]

    ; Make structure in reserved space
    Local $CodeBuffer = DllStructCreate("byte[82]", $pRemoteCode)

    ; Allocate global memory with PAGE_READWRITE. This can be done with ByRef-ing too.
    $aCall = DllCall("kernel32.dll", "ptr", "VirtualAlloc", _
            "ptr", 0, _
            "dword", 36, _
            "dword", 4096, _ ; MEM_COMMIT
            "dword", 4) ; PAGE_READWRITE

    If @error Or Not $aCall[0] Then
        Return SetError(7, 0, 0)
    EndIf

    Local $pStrings = $aCall[0]

    ; Arrange strings in reserved space
    Local $tSpace = DllStructCreate("wchar Format[9];wchar Result[9]", $pStrings)
    DllStructSetData($tSpace, "Format", "hh:mm:ss")

    ; Write assembly on the fly
    DllStructSetData($CodeBuffer, 1, _
            "0x" & _
            "68" & SwapEndian(9) & _                                           ; push output size
            "68" & SwapEndian(DllStructGetPtr($tSpace, "Result")) & _          ; push pointer to output container
            "68" & SwapEndian(DllStructGetPtr($tSpace, "Format")) & _          ; push pointer to format string
            "68" & SwapEndian(0) & _                                           ; push NULL
            "68" & SwapEndian(4) & _                                           ; push TIME_FORCE24HOURFORMAT
            "68" & SwapEndian(0) & _                                           ; push Locale
            "B8" & SwapEndian($pGetTimeFormatW) & _                            ; mov eax, [$pGetTimeFormatW]
            "FFD0" & _                                                         ; call eax
            "68" & SwapEndian(DllStructGetPtr($tSpace, "Result")) & _          ; push pointer to the result
            "68" & SwapEndian(0) & _                                           ; push wParam
            "68" & SwapEndian(12) & _                                          ; push WM_SETTEXT
            "68" & SwapEndian(GUICtrlGetHandle($hControl)) & _                 ; push HANDLE
            "B8" & SwapEndian($pSendMessageW) & _                              ; mov eax, [$pSendMessageW]
            "FFD0" & _                                                         ; call eax
            "68" & SwapEndian(491) & _                                         ; push Milliseconds
            "B8" & SwapEndian($pSleep) & _                                     ; mov eax, [$pSleep]
            "FFD0" & _                                                         ; call eax
            "E9" & SwapEndian(-81) & _                                         ; jump back 81 bytes (start address)
            "C3" _                                                             ; Ret
            )

    ; Create new thread to execute code in
    $aCall = DllCall("kernel32.dll", "hwnd", "CreateThread", _
            "ptr", 0, _
            "dword", 0, _
            "ptr", $pRemoteCode, _
            "ptr", 0, _
            "dword", 0, _
            "dword*", 0)

    If @error Or Not $aCall[0] Then
        Return SetError(8, 0, 0)
    EndIf

    Local $hThread = $aCall[0]

    ; Return thread handle
    Return $hThread

EndFunc   ;==>_ClockThisInAnotherThread

Func SwapEndian($iValue)
    Return Hex(BinaryMid($iValue, 1, 4))
EndFunc   ;==>SwapEndian

Func _HalfTime()
	If @HOUR > 12 Then
		$ht = (GUICtrlCreateLabel("PM", 108, 520, 40, 20))
				GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
				GUICtrlSetColor(-1, 0xFF0000)
				GUICtrlSetFont(-1, 14.5, 600)
	Else
		$ht = (GUICtrlCreateLabel("AM", 108, 520, 40, 20))
				GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
				GUICtrlSetColor(-1, 0xFF0000)
				GUICtrlSetFont(-1, 14.5, 600)
	EndIf
		Return $ht
EndFunc

;Func _cb($aRow)
;	For $s In $aRow
;		ConsoleWrite($s & @TAB)
;	Next
;	ConsoleWrite(@CRLF)
;	; Return $SQLITE_ABORT ; Would Abort the process and trigger an @error in _SQLite_Exec()
;EndFunc   ;==>_cb

func _mCGIaddRecord()

if guictrlread($curID)="" Then

		_sqlite_startup()
			$db=_sqlite_open($dbfile)
			$h=GUIctrlgethandle($curDate)
			_GUICtrlDTP_SetFormat($h, "ddd MMM dd, yyyy")

			$bStat=guictrlread($bStatus) ; brethren status 	4
			$bGen=guictrlread($bGender) ; brethren Gender 	3
			$baptism=guictrlread($curDate)
			$bBirth=guictrlread($dateBirth)

			$createddate=_NowDate()							;10
			if stringinstr($createddate,"/") Then
				$createddate=stringreplace($createddate,"/","-")
			EndIf
;			$txt=Stringreplace(Stringreplace(guictrlread($iCID),"'",""),"|","")
			$cid=Stringreplace(Stringreplace(guictrlread($bCID),"'",""),"|","")				;1
			$fname=Stringreplace(Stringreplace(guictrlread($bFullname),"'",""),"|","")		;2
			$reli=Stringreplace(Stringreplace(guictrlread($bFreligion),"'",""),"|","")		;9
			$address=Stringreplace(Stringreplace(guictrlread($bAddress),"'",""),"|","")		;7
			$contact=Stringreplace(StringReplace(guictrlread($bContact),"'",""),"|","")		;8


			$crtime=_NowTime()
			;_SQLite_Exec ($db, "INSERT INTO activity(CurchID,TimeLine,Status,Created,CreatedTime,Priority) VALUES ('"&$txt&"','"&$d&"','Open','"&$createddate&"','"&$crtime&"','"&$pri&"');") ; INSERT Data
			_SQLite_Exec ($db, "INSERT INTO record(ChurchID,FullName,Gender,Status,DateofBaptism,DateofBirth,Address,ContactNumber,FormerReligion,DateCreated) VALUES ('"&$cid&"','"&$fname&"','"&$bGen&"','"&$bStat&"','"&$baptism&"','"&$bBirth&"','"&$address&"','"&$contact&"','"&$reli&"','"&$createddate&"');") ; INSERT Data

			_SQLite_Close()
			_SQLite_Shutdown()
			;guictrlsetdata($iSearch,"")
			;guictrlsetstate($iSearch,$GUI_FOCUS)

			_mCGIupdateView()

	Endif
EndFunc

func _mCGIupdateView()
			_sqlite_startup()
			$db=_sqlite_open($dbfile)

			_SQlite_gettable2d($db, "SELECT * from record;", $aResult,$irow,$icolumn) ;

;			_GUIctrlListView_DeleteAllitems($cRecord)
;			_GUIctrlListView_DeleteAllitems($cRecord2)

			for $i=1 to $irow

			GUICtrlCreateListViewItem($aResult[$i][0]&"|"&$aResult[$i][1]&"|"&$aResult[$i][2]&"|"&$aResult[$i][3]&"|"&$aResult[$i][4]&"|"&$aResult[$i][5]&"|"&$aResult[$i][9],$cRecord)
			GUICtrlCreateListViewItem($aResult[$i][0]&"|"&$aResult[$i][1]&"|"&$aResult[$i][2]&"|"&$aResult[$i][6]&"|"&$aResult[$i][7]&"|"&$aResult[$i][8]&"|"&$aResult[$i][10],$cRecord2)

			;GUICtrlCreateListViewItem($aResult[$i][0],$cRecord2)
			;0=NO 1=ChurchID 2=FullName 3=Gender 4=Status 5=DateofBaptism 6=DateofBirth 7=Address 8=ContactNumber 9=FormerReligion 10=DateCreated
			;guictrlsetbkcolor(-1,$cl)

			Next

			_SQLite_Close()
			_SQLite_Shutdown()
EndFunc

Func _mCGIsearch()
	local $aRow
			_sqlite_startup()
			$db=_sqlite_open($dbfile)

			$txt=Stringreplace(Stringreplace(guictrlread($iCID),"'",""),"|","")

			$ret1 = 'SELECT NO FROM record WHERE ChurchID = "' & $txt & '" ;' 			; get the value of NO
			_SQLite_QuerySingleRow($db, $ret1, $aRow)
			$ret2 &= $aRow[0] ; output1
			$ret3 = 'SELECT ChurchID FROM record WHERE NO = "' & $ret2 & '" ;'			; get the value of ChurchID
			_SQLite_QuerySingleRow($db, $ret3, $aRow)
			$ret4 &= $aRow[0] ; output2


			$ret5 = 'SELECT FullName FROM record WHERE ChurchID = "' & $ret4 & '" ;'	; get the value of FullName
			_SQLite_QuerySingleRow($db, $ret5, $aRow)
			$ret6 &= $aRow[0] ; output3
			$ret7 = 'SELECT Gender FROM record WHERE FullName = "' & $ret6 & '" ;'		; get the value of Gender
			_SQLite_QuerySingleRow($db, $ret7, $aRow)
			$ret8 &= $aRow[0] ; output4
			$ret9 = 'SELECT Status FROM record WHERE Gender = "' & $ret8 & '" ;'		; get the value of Status
			_SQLite_QuerySingleRow($db, $ret9, $aRow)
			$ret10 &= $aRow[0] ; output5
			$ret11 = 'SELECT DateofBaptism FROM record WHERE Status = "' & $ret10 & '" ;'		; get the value of DateofBaptism
			_SQLite_QuerySingleRow($db, $ret11, $aRow)
			$ret12 &= $aRow[0] ; output6
			$ret13 = 'SELECT DateofBirth FROM record WHERE DateofBaptism = "' & $ret12 & '" ;'	; get the value of DateofBirth
			_SQLite_QuerySingleRow($db, $ret13, $aRow)
			$ret14 &= $aRow[0] ; output7
			$ret15 = 'SELECT Address FROM record WHERE DateofBirth = "' & $ret14 & '" ;'		; get the value of Address
			_SQLite_QuerySingleRow($db, $ret15, $aRow)
			$ret16 &= $aRow[0] ; output8
			$ret17 = 'SELECT ContactNumber FROM record WHERE Address = "' & $ret14 & '" ;'		; get the value of ContactNumber
			_SQLite_QuerySingleRow($db, $ret17, $aRow)
			$ret18 &= $aRow[0] ; output9
			$ret19 = 'SELECT FormerReligion FROM record WHERE ContactNumber = "' & $ret14 & '" ;'	; get the value of FormerReligion
			_SQLite_QuerySingleRow($db, $ret19, $aRow)
			$ret20 &= $aRow[0] ; output10
			$ret21 = 'SELECT DateCreated FROM record WHERE FormerReligion = "' & $ret14 & '" ;'		; get the value of DateCreated
			_SQLite_QuerySingleRow($db, $ret21, $aRow)
			$ret22 &= $aRow[0] ; output11

			MsgBox(0, "Char From $ret2", $ret2)
			MsgBox(0, "Char From $ret4", $ret4)
			MsgBox(0, "Char from $ret6", $ret6)
			MsgBox(0, "Char from $ret8", $ret8)
			MsgBox(0, "Char from $ret10", $ret10)
			MsgBox(0, "Char from $ret12", $ret12)
			MsgBox(0, "Char from $ret14", $ret14)
			MsgBox(0, "Char from $ret16", $ret16)
			MsgBox(0, "Char from $ret18", $ret18)
			MsgBox(0, "Char from $ret20", $ret20)
			MsgBox(0, "Char from $ret22", $ret22)

			_GUIctrlListView_DeleteAllitems($cRecord)
			;0=NO 1=ChurchID 2=FullName 3=Gender 4=Status 5=DateofBaptism 6=DateofBirth 7=Address 8=ContactNumber 9=FormerReligion 10=DateCreated
			;guictrlsetbkcolor(-1,$cl)

;			_ArrayDisplay($aResult)
	_SQLite_Close()
	_SQLite_Shutdown()
EndFunc   ;==>_mCGIsearch

func _mCGIsearch2()

			_sqlite_startup()
			$db=_sqlite_open($dbfile)

			$txt=Stringreplace(Stringreplace(guictrlread($iCID),"'",""),"|","")

			$sql = 'select * from record where ChurchID like "%' & $txt & '%" or FullName like "%'  & $txt & '%" order by ChurchID, FullName;'
			$ret = _SQLite_GetTable2d($db, $sql, $aResult, $row, $column)

			;_SQlite_gettable2d($db, "SELECT * from record;", $result,$irow,$icolumn) ;

			_GUIctrlListView_DeleteAllitems($cRecord)
			;_ArrayDisplay($aResult)

;			for $i=1 to $irow

;			$display = 'record'


;			_SQLite_Getline2dByData($display,$column,$aResult)



;			$display = _GUICtrlListView_SetExtendedListViewStyle($cRecord, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_CHECKBOXES, $LVS_EX_GRIDLINES))

			$display = "$aResult[$i][1]"
			$dis = GUICtrlCreateListViewItem($display,$cRecord)
			GUICtrlCreateLabel($dis,100,100,100,20)
;
;			GUICtrlCreateListViewItem($aResult[$i][1],$cRecord)
;			_GUICtrlListView_SetExtendedListViewStyle($cRecord, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_CHECKBOXES, $LVS_EX_GRIDLINES))
;
			;GUICtrlCreateLabel($dis, 130, 260, 220, 17, $SS_CENTERIMAGE)
;			GUICtrlRead(GUICtrlCreateListViewItem($aResult[$i][1],$cRecord))

;			Next

			_SQLite_Close()
			_SQLite_Shutdown()

EndFunc ;mCGI search

func _mCGIsearch3()

	local $enter = guictrlcreatedummy()

	Dim $aAccelerators[1][2] = [["{ENTER}", $Enter]]
	GUISetAccelerators($aAccelerators)

		_sqlite_startup()
		$db=_sqlite_open($dbfile)

		$txt=Stringreplace(Stringreplace(guictrlread($iCID),"'",""),"|","")

		$sql = 'select * from record where ChurchID like "%' & $txt & '%" or FullName like "%' & $txt & '%" order by ChurchID, FullName;'
		$ret = _SQLite_GetTable2d(-1, $sql, $aResult, $nbrows, $nbcols)

		_GUIctrlListView_DeleteAllitems($cRecord)

		_ArrayDisplay($aResult)


		_SQLite_Close()
		_SQLite_Shutdown()

EndFunc ;mCGI search

func _allCheck()
		_updateView()
		Guictrlsetdata($curID,"")
		GUIctrlsetData($curAct,"")
		GUIctrlsetdata($group,"New Task")
		$dd=_nowdate()
		if stringinstr($dd,"/","-") then
		$dd=stringreplace($dd,"/","-")
		EndIf

		$d=stringsplit($dd,"-")
		$d1=$d[3]&"/"&$d[2]&"/"&$d[1]
		guictrlsetdata($curDate,$d1)
		GUICtrlSetState($curAct,$GUI_FOCUS)
		guictrlsetstate($addButton,$GUI_ENABLE)
		guictrlsetstate($updateButton,$GUI_DISABLE)

		GUictrlsetstate($doneCheck,$GUI_DISABLE)
		GUictrlsetstate($zoomButton,$GUI_DISABLE)
		guictrlsetstate($newButton,$GUI_DISABLE)

			$c=guictrlread($allCheck)
				if $c=1 Then
					$c=1
				Else
					$c=0
				EndIf

				_sqlite_startup()
				$db=_sqlite_open($dbfile)
				_SQLite_Exec($db, "UPDATE settings SET ViewAll='"&$c&"' WHERE ID=1;")
				_SQLite_Close()
			_SQLite_Shutdown()

EndFunc

func _deleteButton()
	$m=_GUICtrlListView_GetSelectedIndices($activelist)
	$itc=_GUICtrlListView_GetItemCount($activelist)

	$k=0
		for $i=0 to int($itc)-1
		if _Guictrllistview_getitemchecked($activelist,$i) then
		$k=$k+1
		EndIf
		Next

	if $k <> 0 Then
				guisetstate(@sw_disable,$hMainGUI)

				$rep=Msgbox(1,"Warning",$k&" selected Activity(s) will be deleted permanently from the list.Are you sure?")
				guisetstate(@sw_enable,$hMainGUI)
				guisetstate(@sw_restore,$hMainGUI)
				if $rep=1 then
				_sqlite_startup()

				$db=_sqlite_open($dbfile)
				for $i=0 to int($itc)-1


				if _Guictrllistview_getitemchecked($activelist,$i) then
					$itid=_guictrllistview_getitemtext($activelist,$i,0)

				_SQLite_Exec ($db, "DELETE FROM activity WHERE ID='"&$itid&"';")
				endif
				next
				_SQLite_Close()
			_SQLite_Shutdown()

			_newButton()
			EndIf
		Else
			MSgbox(0,"No Items selected","No items selected for deletion.")
		EndIf



EndFunc

func _viewClosed()

			_sqlite_startup()
			$db=_sqlite_open($dbfile)

			_SQlite_gettable2d($db, "SELECT * from activity WHERE Status='Done';", $result,$row,$column) ;
			guisetstate(@sw_disable,$hMainGUI)
				_ArrayDisplay($result)
				guisetstate(@sw_enable,$hMainGUI)
				guisetstate(@sw_restore,$hMainGUI)

			_SQLite_Close()
			_SQLite_Shutdown()

EndFunc

func _deleteDB()
		guisetstate(@sw_disable,$hMainGUI)
		$resp=MsgBox(1,"Warning","Are you sure.?This will delete all the records permanently!")
		guisetstate(@sw_enable,$hMainGUI)
		guisetstate(@sw_restore,$hMainGUI)
		if $resp=1 then
		_sqlite_startup()
		$db=_sqlite_open($dbfile)
		_sqlite_exec($db,"DELETE FROM activity;")
		_sqlite_close()
		_sqlite_shutdown()

		guictrlsetdata($curID,"")
		guictrlsetdata($curAct,"")
		guictrlsetdata($group,"New Task")

		$dd=_Nowdate()
		if stringinstr($dd,"/") then
			$dd=stringreplace($dd,"/","-")
		EndIf

		$d=stringsplit($dd,"-")
		$d1=$d[3]&"/"&$d[2]&"/"&$d[1]

		guictrlsetdata($curDate,$d1)
		guictrlsetstate($curAct,$GUI_FOCUS)
		guictrlsetstate($addButton,$GUI_ENABLE)
		guictrlsetstate($newButton,$GUI_DISABLE)
		guictrlsetstate($updateButton,$GUI_DISABLE)

		GUictrlsetstate($doneCheck,$GUI_DISABLE)
		GUictrlsetstate($zoomButton,$GUI_DISABLE)
		Guictrlsetdata($priority,"High")
		endif

		_updateView()

EndFunc

func _newButton()
		Guictrlsetdata($curID,"")
		GUIctrlsetData($curAct,"")
		GUIctrlsetdata($group,"New Task")
		guictrlsetdata($priority,"High")
		$dd=_nowdate()
		if stringinstr($dd,"/","-") then
		$dd=stringreplace($dd,"/","-")
		EndIf


		$d=stringsplit($dd,"-")
		$d1=$d[3]&"/"&$d[2]&"/"&$d[1]
		guictrlsetdata($curDate,$d1)
		GUICtrlSetState($curAct,$GUI_FOCUS)
		_updateView()
		guictrlsetstate($addButton,$GUI_ENABLE)
		guictrlsetstate($updateButton,$GUI_DISABLE)

		GUictrlsetstate($doneCheck,$GUI_DISABLE)
		GUictrlsetstate($zoomButton,$GUI_DISABLE)
		guictrlsetstate($newButton,$GUI_DISABLE)
EndFunc

func _addButton()

if guictrlread($curID)="" Then

		_sqlite_startup()
			$db=_sqlite_open($dbfile)
			$h=GUIctrlgethandle($curDate)
			_GUICtrlDTP_SetFormat($h, "yyyy/MM/dd")
			$pri=guictrlread($priority)
			$d=GUICtrlread($curDate)

			$createddate=_NowDate()
			if stringinstr($createddate,"/") Then
				$createddate=stringreplace($createddate,"/","-")
			EndIf
			$txt=Stringreplace(Stringreplace(guictrlread($curAct),"'",""),"|","")
			$crtime=_NowTime()
			_SQLite_Exec ($db, "INSERT INTO activity(Activity,TimeLine,Status,Created,CreatedTime,Priority) VALUES ('"&$txt&"','"&$d&"','Open','"&$createddate&"','"&$crtime&"','"&$pri&"');") ; INSERT Data

			_SQLite_Close()
			_SQLite_Shutdown()
			guictrlsetdata($curAct,"")
			guictrlsetstate($curAct,$GUI_FOCUS)

			_updateView()

	Endif
EndFunc

FUnc _zoomButton()
	$m=_GUICtrlListView_GetSelectedIndices($activelist)
	$dat=guictrlread($curAct)
	$edid=guictrlread($curID)
	$edstatus=guictrlread($donecheck)

   Opt("GUIOnEventMode", 1)
	guisetstate(@SW_DISABLE,$hMainGUI)

	$editWindow = GUICreate("EditWindow", 600,530, 250,100)
	guisetbkcolor($guicolor,$editwindow)
	guisetstyle($WS_BORDER,$GUI_WS_EX_PARENTDRAG,$editWindow)
	$edit=guictrlcreateedit($dat,10,50,590,430,BitOR($ES_WANTRETURN, $WS_VSCROLL))

	guictrlsetstate($edit,$GUI_FOCUS)
	guictrlsetfont($edit,12,400,1,"Lucida Console")
	$editWindowHandle=GUICtrlGetHandle($edit)


	$save=guictrlcreatebutton("Save and Close",500,500,90,25)
	GUIctrlsetonevent($save,"_Save")
	$lg=guictrlcreategroup("",5,2,91,36)
	$editIDlabel=guictrlcreatelabel(" TASK ID: ",10,13,60,20)
	guictrlsetbkcolor(-1,0xffffff)
	$editID=guictrlcreateLabel($edid,60,13,30,20)
	guictrlsetbkcolor(-1,0xffffff)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$lg=guictrlcreategroup("",115,2,100,36)
	$editStatus=guictrlcreatecheckbox("Close Task",120,13,90,20)
	guictrlsetbkcolor(-1,0xffffff)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	if $edstatus=1 Then
		guictrlsetstate($editStatus,$GUI_CHECKED)
	Else
		guictrlsetstate($editStatus,$GUI_UNCHECKED)
	EndIf


	$cancel=guictrlcreatebutton("Cancel",300,500,60,25)
	GUIctrlsetonevent(-1,"_Cancel")
	guisetstate(@SW_SHOW,$editWindow)
	Do


	sleep(100)

	Until $savedflag
	$savedflag=0
	guidelete($editWindow)
	guisetstate(@SW_ENABLE,$hMainGUI)
	guisetstate(@SW_RESTORE,$hMainGUI)
	  Opt("GUIOnEventMode", 0)
	  Opt("GUICoordMode", 1)

	guisetstate(@SW_SHOW,$hMainGUI)
	_updateView()
	_guictrllistview_setitemselected($activelist,int($m))
	_GUICtrlListView_SetItemFocused($activelist,int($m))

	guictrlsetdata($curAct,$editContent)


EndFunc

func _Save()
	$editContent=guictrlread($edit)
	$id1=guictrlread($editID)
	$s1=guictrlread($editStatus)
	if $s1=1 Then
		$s2="Done"
	Else
		$s2="Open"
	EndIf

				_sqlite_startup()
				$db=_sqlite_open($dbfile)
				_SQLite_Exec($db, "UPDATE activity SET Activity='"&$editContent&"',Status='"&$s2&"' WHERE ID='"&$id1&"';")
				_SQLite_Close()
			_SQLite_Shutdown()

		$savedflag=1

EndFunc

func _Cancel()

$savedflag=1
$editContent=$dat

EndFunc

func _checkSelected()
	$Indexnew=_GUICtrlListView_GetSelectedIndices($activelist)

	if $Indexnew <> "" and $Index<>$Indexnew then
guictrlsetstate($updateButton,$GUI_ENABLE)

guictrlsetstate($doneCheck,$GUI_ENABLE)
guictrlsetstate($zoomButton,$GUI_ENABLE)
guictrlsetdata($curID,_GUIctrllistview_getItemText($activelist,int($Indexnew),0))
		$n=$Indexnew

	$itemactivity=_GUICtrlListView_GetItemText($activelist,int($n),1)

	guictrlsetdata($curAct,$itemactivity)

	$itemdate=_GUICtrlListView_GetItemText($activelist,int($n),2)
	_GUICtrlDTP_SetFormat($curDate, "yyyy/MM/dd");

	GUICtrlSetData($curDate,$itemdate)
	$itemstatus=_GUICtrlListView_GetItemText($activelist,int($n),3)
	guictrlsetdata($priority,_guictrllistview_getitemText($activelist,int($n),6))
	$due=_GUICtrlListView_GetItemText($activelist,int($n),5)
	guictrlsetState($addButton,$GUI_DISABLE)

	guictrlsetstate($newButton,$GUI_ENABLE)
	if $itemstatus="Open" Then

	guictrlsetstate($donecheck,$GUI_UNCHECKED)

		if int($due) <0 Then

		GUIctrlsetdata($group,"Selected Task is Overdue for "&$due&" days")

		Else

		GUIctrlsetdata($group,"Selected Task is OPEN | Due in "&$due&" days.")
		EndIf

	ElseIf $itemstatus="Done" Then

	guictrlsetstate($donecheck,$GUI_CHECKED)
	GUIctrlsetdata($group,"Selected Task is Done.")

	EndIf

	EndIf
	$Index=$Indexnew

EndFunc

func _updateView()
			_sqlite_startup()
			$db=_sqlite_open($dbfile)

			if GUIctrlread($allcheck)=1 then
			_SQlite_gettable2d($db, "SELECT * from activity;", $result,$row,$column) ;
			else
			_SQlite_gettable2d($db, "SELECT * from activity where Status='Open';", $result,$row,$column) ;
			EndIf
			_GUIctrlListView_DeleteAllitems($activelist)
			for $i=1 to $row
			$dd=_Nowdate()
			if stringinstr($dd,"/") then
			$dd=stringreplace($dd,"/","-")
			EndIf

			$crd=StringSplit($dd,"-","/")
			$dued=$result[$i][2]
			$crd1=$crd[3]&"/"&$crd[2]&"/"&$crd[1]
			$dif=_DateDiff('D',$crd1,$dued)
				if $result[$i][3]="Open" and $dif >=0 Then
				$cl=0xfdd5c1
				Elseif $result[$i][3]="Open" and $dif <0 then
					$cl=0xED3203
				Else
					$cl=0xccffcc
					$dif=""
				EndIf

			GUICtrlCreateListViewItem($result[$i][0]&"|"&$result[$i][1]&"|"&$result[$i][2]&"|"&$result[$i][3]&"|"&$result[$i][4]&"|"&$dif&"|"&$result[$i][8],$activelist)
			guictrlsetbkcolor(-1,$cl)

			Next

			_SQLite_Close()
			_SQLite_Shutdown()
EndFunc

Func _viewAll()

			_sqlite_startup()
			$db=_sqlite_open($dbfile)
			_SQlite_gettable2d($db, "SELECT * from activity;", $result,$row,$column) ;
				guisetstate(@SW_DISABLE,$hMainGUI)
				_ArrayDisplay($result)
				GUISETSTATE(@SW_ENABLE,$hMainGUI)
				guisetstate(@SW_restore,$hMainGUI)

			_SQLite_Close()
			_SQLite_Shutdown()
EndFunc

Func _updateDB()
	$m=_GUICtrlListView_GetSelectedIndices($activelist)
	if $m <> "" Then
		_sqlite_startup()
			$db=_sqlite_open($dbfile)
			$h=GUIctrlgetHandle($curDate)
			_GUICtrlDTP_SetFormat($h, "yyyy/MM/dd")
					$d=GUICtrlread($curDate)

					$pri=guictrlread($priority)
					$done=GUIctrlread($donecheck)
					if $done=1 Then
						$donestatus="Done"
							$txt=Stringreplace(Stringreplace(guictrlread($curAct),"'",""),"|","")

							_SQlite_gettable2d($db, "SELECT Created,CreatedTime,FinishedTime from activity where ID='"&guictrlread($curID)&"';", $result,$row,$column)
							if $result[1][2]="" Then
							$cr1=Stringsplit($result[1][0]&" "&$result[1][1]," ")
							$f1d=_Nowdate()
							if Stringinstr($f1d,"/") then
								$f1d=stringreplace($f1d,"/","-")
							EndIf

							$ftime=StringSplit($f1d&" "&_NowTime()," ")
							$cr2=STringsplit($cr1[1],"-")
							$cr3=$cr2[3]&"/"&$cr2[2]&"/"&$cr2[1]
							$ftime2=Stringsplit($ftime[1],"-")
							$ftime3=$ftime2[3]&"/"&$ftime2[2]&"/"&$ftime2[1]
							$ftt=$ftime[1]& " " & $ftime[2]

							$mm=_DateDiff('n',$cr3&" "&$cr1[2],$ftime3&" "&$ftime[2])
							$tt=$mm&" min(s)"
							_SQLite_Exec ($db, "UPDATE activity SET Activity='"&$txt&"',TimeLine='"&$d&"',Status='"&$donestatus&"' , FinishedTime='"&$ftt&"', TurnaroundTime='"&$tt&"',Priority='"&$pri&"' WHERE ID='"&GUIctrlread($curID)&"';") ; INSERT Data
							Else
							_SQLite_Exec ($db, "UPDATE activity SET Activity='"&$txt&"',TimeLine='"&$d&"',Status='"&$donestatus&"',Priority='"&$pri&"' WHERE ID='"&GUIctrlread($curID)&"';")
							EndIf

					Else
						$donestatus="Open"
							$txt=Stringreplace(Stringreplace(guictrlread($curAct),"'",""),"|","")
							_SQLite_Exec ($db, "UPDATE activity SET Activity='"&$txt&"',TimeLine='"&$d&"',Status='"&$donestatus&"',FinishedTime='',TurnaroundTime='' ,Priority='"&$pri&"'WHERE ID='"&GUIctrlread($curID)&"';") ; INSERT Data

					endif

			_SQLite_Close()
			_SQLite_Shutdown()

			_updateView()
			_guictrllistview_setitemselected($activelist,int($m))

	EndIf

EndFunc

Func WM_TIMER($hWnd, $iMsg, $iwParam, $ilParam)
    #forceref $hWnd, $iMsg, $ilParam

    Switch _Timer_GetTimerID($iwParam)
        Case $iTimer1
            _UpdateStatusBarClock()

        case $iTimer2
			_AutoUpdateQuote()
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc
Func _UpdateStatusBarClock()
    guictrlsetdata($clock, " Now: "&_NowDate()&" "&_DateDayOfWeek( @WDAY )&" "&StringFormat("%02d:%02d:%02d", @HOUR, @MIN, @SEC))
EndFunc

Func _pipette()

    $Cursor = GUICreate('', 48, 48, -1, -1, $WS_POPUP,$WS_EX_TOPMOST)

    GUISetCursor(3, 0, $Cursor)
	WinSetTrans($Cursor, '', 10)


GUISetState(@SW_SHOW, $Cursor)
    Local $pos
    Do
        $pos = MouseGetPos()
        WinMove($Cursor, '', $pos[0]-24, $pos[1]-24)
        Sleep(10)
    Until _IsPressed('01')
    GUISetState(@SW_HIDE, $Cursor)
    Local $col = "0x"&Hex(PixelGetColor($pos[0], $pos[1]),6)
	$guicolor=$col
    GUISetState(@SW_SHOW, $hMainGUI)

    WinActivate($hMainGUI)
	guisetbkcolor($col,$hMainGUI)
		_sqlite_startup()
		$db=_sqlite_open($dbfile)
				_SQLite_Exec($db, "UPDATE settings set Color='"&$col&"' WHERE ID=1;")

				_SQLite_Close()
			_SQLite_Shutdown()
guidelete($Cursor)

EndFunc

Func _pipette2()

    $Cursor = GUICreate('', 48, 48, -1, -1, $WS_POPUP,$WS_EX_TOPMOST)

    GUISetCursor(3, 0, $Cursor)
	WinSetTrans($Cursor, '', 10)


GUISetState(@SW_SHOW, $Cursor)
    Local $pos
    Do
        $pos = MouseGetPos()
        WinMove($Cursor, '', $pos[0]-24, $pos[1]-24)
        Sleep(10)
    Until _IsPressed('01')
    GUISetState(@SW_HIDE, $Cursor)
    Local $col = "0x"&Hex(PixelGetColor($pos[0], $pos[1]),6)
	$textcolor=$col
    GUISetState(@SW_SHOW, $hMainGUI)

    WinActivate($hMainGUI)
				guictrlsetcolor($quoteLabel,$textcolor)
		_sqlite_startup()
		$db=_sqlite_open($dbfile)
				_SQLite_Exec($db, "UPDATE settings set QuoteColor='"&$col&"' WHERE ID=1;")
				_SQLite_Close()
			_SQLite_Shutdown()
guidelete($Cursor)

EndFunc

func _updateColor()
			_sqlite_startup()
				$db=_sqlite_open($dbfile)
				_SQlite_gettable2d($db, "SELECT Color,TextColor,QuoteColor from settings;",$color,$r1,$c1)
				$guicolor=$color[1][0]
				$textcolor=$color[1][1]
				$quotecolor=$color[1][2]
				guictrlsetbkcolor($curID,"0xf1f1ff")
				guictrlsetbkcolor($changequoteCheck,"0xffffff")
				guictrlsetbkcolor($timeline,"0xffffff")
				guictrlsetbkcolor($allcheck,"0xffffff")
				guictrlsetbkcolor($donecheck,"0xf1f1ff")
				guictrlsetbkcolor($group,"0xffffff")
				guisetbkcolor($group,"0xffffff")
				guisetbkcolor($guicolor,$hMainGUI)
				guictrlsetcolor($quoteLabel,$quotecolor)
				_SQLite_Close()
			_SQLite_Shutdown()

EndFunc

Func _AutoUpdateQuote()
	if guictrlread($changequoteCheck)=1 then
	$QuoteID=Random(1,371,1)
	guictrlsetdata($quoteLabel,$quoteArray[$QuoteID])
	endif
		_sqlite_startup()
				$qc=guictrlread($changequoteCheck)
				if $qc=4 Then
					$qc=0
				Else
					$qc=1
					EndIf
				$db=_sqlite_open($dbfile)
				_SQLite_Exec($db, "UPDATE settings SET QuoteID='"&$QuoteID&"',QuoteChange='"&$qc&"' WHERE ID=1;")
				_SQLite_Close()
			_SQLite_Shutdown()

EndFunc

func _UpdateQuoteForce()
	if $QuoteID=371 Then
	$QuoteID=0
	Else
	$QuoteID=$QuoteID+1
	EndIf

	guictrlsetdata($quoteLabel,$quoteArray[$QuoteID])
	_sqlite_startup()
				$db=_sqlite_open($dbfile)
				$qc=guictrlread($changequoteCheck)
				if $qc=4 Then
					$qc=0
				Else
					$qc=1
				EndIf

				_SQLite_Exec($db, "UPDATE settings SET QuoteID='"&$QuoteID&"',QuoteChange='"&$qc&"' WHERE ID=1;")
				_SQLite_Close()
			_SQLite_Shutdown()

EndFunc

func _UpdateQuoteForce2()
	if $QuoteID=0 Then
	$QuoteID=371
	Else
	$QuoteID=$QuoteID-1
	EndIf

	guictrlsetdata($quoteLabel,$quoteArray[$QuoteID])
	_sqlite_startup()
				$db=_sqlite_open($dbfile)
				$qc=guictrlread($changequoteCheck)
				if $qc=4 Then
					$qc=0
				Else
					$qc=1
				EndIf

				_SQLite_Exec($db, "UPDATE settings SET QuoteID='"&$QuoteID&"',QuoteChange='"&$qc&"' WHERE ID=1;")
				_SQLite_Close()
			_SQLite_Shutdown()

EndFunc

Func _settings()
		_sqlite_startup()
				$db=_sqlite_open($dbfile)
				_SQlite_gettable2d($db, "SELECT QuoteID,QuoteChange,ViewAll from settings;",$qvals,$r1,$c1)
				$QuoteID=$qvals[1][0]
				$qc=$qvals[1][1]
				$vc=$qvals[1][2]
				if $qc=1 Then
					guictrlsetstate($changequoteCheck,$GUI_CHECKED)
				Else
					guictrlsetstate($changequoteCheck,$GUI_UNCHECKED)
				EndIf
				if $vc=1 Then
						guictrlsetstate($allCheck,$GUI_CHECKED)
					Else
							guictrlsetstate($allCheck,$GUI_UNCHECKED)
				EndIf

				GUICTRLSETDATA($quoteLabel,$quoteArray[$QuoteID])

				_SQLite_Close()
			_SQLite_Shutdown()
EndFunc

func _changequoteCheck()
				$qc=guictrlread($changequoteCheck)
				if $qc=1 Then
					$qc=1
				Else
					$qc=0
				EndIf

				_sqlite_startup()
				$db=_sqlite_open($dbfile)
				_SQLite_Exec($db, "UPDATE settings SET QuoteID='"&$QuoteID&"',QuoteChange='"&$qc&"' WHERE ID=1;")
				_SQLite_Close()
			_SQLite_Shutdown()
EndFunc

func _CheckTable()
	_SQLite_Startup ()
				If @error Then
					MsgBox(16, "SQLite Error", "SQLite.dll Can't be Loaded!")
				Exit -1
				EndIf
					ConsoleWrite("_SQLite_LibVersion=" & _SQLite_LibVersion() & @CRLF)
				;	_SQLite_Open() ; Open a :memory: database
				If @error Then
				MsgBox(16, "SQLite Error", "Can't Load Database!")
				Exit -1
				EndIf

		if Not fileexists($dbfile) then

			_GUIctrlListView_DeleteAllitems($activelist)
			_GUIctrlListView_DeleteAllitems($cRecord)

			$db=_sqlite_open($dbfile)
			_SQLite_Exec ($db, "CREATE TABLE activity (ID INTEGER PRIMARY KEY ASC,Activity LONGTEXT,TimeLine TEXT,Status TEXT,Created TEXT,CreatedTime TEXT,FinishedTime TEXT,TurnaroundTime TEXT,Priority TEXT);") ; CREATE a Table
			_SQLite_Exec ($db, "CREATE TABLE settings (ID INTEGER PRIMARY KEY ASC,Color TEXT,QuoteID INTEGER,QuoteChange INTEGER,ViewAll INTEGER,TextColor TEXT,QuoteColor TEXT);")
			_SQLite_Exec ($db, "INSERT INTO settings(Color,QuoteID,QuoteChange,ViewAll,TextColor,QuoteColor) VALUES ('0x92B3E8',1,360,0,'0x000000','0x000000');") ; INSERT Data
			_SQLite_Exec ($db, "CREATE TABLE record (NO INTEGER PRIMARY KEY ASC,ChurchID TEXT,FullName TEXT,Gender TEXT,Status TEXT,DateofBaptism TEXT,DateofBirth TEXT,Address LONGTEXT,ContactNumber INTEGER,FormerReligion TEXT,DateCreated TEXT);") ; CREATE a Table

		else

			$db=_sqlite_open($dbfile)
			_SQlite_gettable2d($db,"SELECT name from sqlite_master;",$mastertable,$r1,$c1)
			$mt=""
			for $i=1 to $r1
			$mt=$mt&":"&$mastertable[$i][0]
			next
			if Stringinstr($mt,"activity") then
					_SQlite_gettable2d($db,"PRAGMA table_info(activity);",$activitytable,$r1,$c1)
					$at=""
					for $i=1 to $r1
					$at=$at&$activitytable[$i][1]
					Next

						if $at <>"IDActivityTimeLineStatusCreatedCreatedTimeFinishedTimeTurnaroundTimePriority" Then
						_SQLite_Exec ($db,"DROP TABLE activity;")
						_SQLite_Exec ($db, "CREATE TABLE activity (ID INTEGER PRIMARY KEY ASC,Activity LONGTEXT,TimeLine TEXT,Status TEXT,Created TEXT,CreatedTime TEXT,FinishedTime TEXT,TurnaroundTime TEXT,Priority TEXT);") ; CREATE a Table
						EndIf

			Else
					_SQLite_Exec ($db, "CREATE TABLE activity (ID INTEGER PRIMARY KEY ASC,Activity LONGTEXT,TimeLine TEXT,Status TEXT,Created TEXT,CreatedTime TEXT,FinishedTime TEXT,TurnaroundTime TEXT,Priority TEXT);") ; CREATE a Table
			EndIf

			if Stringinstr($mt,"record") then
					_SQlite_gettable2d($db,"PRAGMA table_info(record);",$recordtable,$r1,$c1)
					$atx=""
					for $i=1 to $r1
					$atx=$atx&$recordtable[$i][1]
					Next

						if $atx <>"NOChurchIDFullNameGenderStatusDateofBaptismDateofBirthAddressContactNumberFormerReligionDateCreated" Then
						_SQLite_Exec ($db,"DROP TABLE record;")
						;_SQLite_Exec ($db, "CREATE TABLE activity (ID INTEGER PRIMARY KEY ASC,Activity LONGTEXT,TimeLine TEXT,Status TEXT,Created TEXT,CreatedTime TEXT,FinishedTime TEXT,TurnaroundTime TEXT,Priority TEXT);") ; CREATE a Table
						_SQLite_Exec ($db, "CREATE TABLE record (NO INTEGER PRIMARY KEY ASC,ChurchID TEXT,FullName TEXT,Gender TEXT,Status TEXT,DateofBaptism TEXT,DateofBirth TEXT,Address LONGTEXT,ContactNumber INTEGER,FormerReligion TEXT,DateCreated TEXT);") ; CREATE a Table
						EndIf

			Else
;					_SQLite_Exec ($db, "CREATE TABLE activity (ID INTEGER PRIMARY KEY ASC,Activity LONGTEXT,TimeLine TEXT,Status TEXT,Created TEXT,CreatedTime TEXT,FinishedTime TEXT,TurnaroundTime TEXT,Priority TEXT);") ; CREATE a Table
					_SQLite_Exec ($db, "CREATE TABLE record (NO INTEGER PRIMARY KEY ASC,ChurchID TEXT,FullName TEXT,Gender TEXT,Status TEXT,DateofBaptism TEXT,DateofBirth TEXT,Address LONGTEXT,ContactNumber INTEGER,FormerReligion TEXT,DateCreated TEXT);") ; CREATE a Table
			EndIf

			if Stringinstr($mt,"settings") then
				_SQlite_gettable2d($db,"PRAGMA table_info(settings);",$settingstable,$r1,$c1)
					$st=""
					;msgbox(0,"",$r1)
					for $i=1 to $r1
					$st=$st&$settingstable[$i][1]
					Next

						if $st <>"IDColorQuoteIDQuoteChangeViewAllTextColorQuoteColor" Then
						_SQLite_Exec ($db, "DROP TABLE settings;")

						_SQLite_Exec ($db, "CREATE TABLE settings (ID INTEGER PRIMARY KEY ASC,Color TEXT,QuoteID INTEGER,QuoteChange INTEGER,ViewAll INTEGER,TextColor TEXT,QuoteColor TEXT);")
						_SQLite_Exec ($db, "INSERT INTO settings(Color,QuoteID,QuoteChange,ViewAll,TextColor,QuoteColor) VALUES ('0x92B3E8',1,360,0,'0x000000','0x000000');") ; INSERT Data

						EndIf
			Else
						_SQLite_Exec ($db, "CREATE TABLE settings (ID INTEGER PRIMARY KEY ASC,Color TEXT,QuoteID INTEGER,QuoteChange INTEGER,ViewAll INTEGER,TextColor TEXT,QuoteColor TEXT);")
						_SQLite_Exec ($db, "INSERT INTO settings(Color,QuoteID,QuoteChange,ViewAll,TextColor,QuoteColor) VALUES ('0x92B3E8',1,360,0,'0x000000','0x000000');") ; INSERT Data

			EndIf


		EndIf
			_sqlite_close()
			_SQLite_Shutdown()
EndFunc

func _mCGIcheckSelected()
	$Indexnew=_GUICtrlListView_GetSelectedIndices($cRecord)

	if $Indexnew <> "" and $Index<>$Indexnew then
guictrlsetstate($updateButton,$GUI_ENABLE)

guictrlsetstate($doneCheck,$GUI_ENABLE)
guictrlsetstate($zoomButton,$GUI_ENABLE)
guictrlsetdata($curID,_GUIctrllistview_getItemText($cRecord,int($Indexnew),0))
		$n=$Indexnew

	$itemactivity=_GUICtrlListView_GetItemText($cRecord,int($n),1)

	guictrlsetdata($curAct,$itemactivity)

	$itemdate=_GUICtrlListView_GetItemText($cRecord,int($n),2)
	_GUICtrlDTP_SetFormat($curDate, "yyyy/MM/dd");

	GUICtrlSetData($curDate,$itemdate)
	$itemstatus=_GUICtrlListView_GetItemText($cRecord,int($n),3)
	guictrlsetdata($priority,_guictrllistview_getitemText($cRecord,int($n),6))
	$due=_GUICtrlListView_GetItemText($cRecord,int($n),5)
	guictrlsetState($addButton,$GUI_DISABLE)

	guictrlsetstate($newButton,$GUI_ENABLE)

	if $itemstatus="Open" Then

	guictrlsetstate($donecheck,$GUI_UNCHECKED)

		if int($due) <0 Then

		GUIctrlsetdata($group,"Selected Task is Overdue for "&$due&" days")

		Else

		GUIctrlsetdata($group,"Selected Task is OPEN | Due in "&$due&" days.")
		EndIf

	ElseIf $itemstatus="Done" Then

	guictrlsetstate($donecheck,$GUI_CHECKED)
	GUIctrlsetdata($group,"Selected Task is Done.")

	EndIf

	EndIf
	$Index=$Indexnew

EndFunc

func _FindString($str, $srchstr)

    guictrlsetdata($STedt010 ,'String = ' & $str & @crlf & 'Search = ' & $srchstr & @crlf,1)

    $srchstr = stringregexpreplace($srchstr,'[\^\.\*\?\$\[\]\(\)]','\\$0')    ; precede reserved chars with a '\'

    local $pattern = '(?si)' & $srchstr

    guictrlsetdata($sre,'Pattern = ' & $pattern)

    local $aSrch = StringRegExp($str, $pattern, 1)

    switch @error
        case 0
            return 'Pattern found at ' & @extended - stringlen($aSrch[0])
        case 1
            return 'Not Found'
        case 2
            return 'Bad pattern, array is invalid. Pattern error at offset ' &  @extended
    endswitch

endfunc