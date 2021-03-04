#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=ampac.ico
#AutoIt3Wrapper_outfile=QAHoldDatabase.exe
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseAnsi=y
#AutoIt3Wrapper_Res_Description=QA Database for EGV
#AutoIt3Wrapper_Res_Fileversion=1.2.0.0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; ------------------------------------------------------------------------------
; AutoIt Version: 	3.2.12
; Description:    	QA Database for Elk Grove Village
; Author:			Bob Flaherty
; Created:			December 2008
; Versuin 1.1		Fixed issue with number roll-over
; Version 1.2		Added Action Required to New Record
;					Added separate fields for rolls and boxes
;					Added Customer PO number field
;					Changed the report to handle the new fields
;					Changed Hold Tag for separate boxes and rolls fields
; ------------------------------------------------------------------------------
;CREATE TABLE Data (QA_Hold_Number TEXT, Defect_Description TEXT, Date_Entered NUMERIC, QCTech NUMERIC, Machine TEXT, Supplier TEXT, Customer TEXT, Product_Name TEXT, Customer_Order_Number TEXT, Ampac_Skid_Number TEXT, Ampac_Lot_Number TEXT, Quantity NUMERIC, Units TEXT, Disposition TEXT, Status TEXT, ImmediateAction TEXT, QADisposition TEXT, Notes TEXT, Customer_PO TEXT, Affected_Boxes TEXT)
#Region INCLUDES and OPTIONS
;Includes
#include-once
#include <SQLite.au3>
#include <SQLite.dll.au3>
;#include <Array.au3> ;included in SQLite.au3
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ListviewConstants.au3>
#include <GuiListView.au3>
#include <StaticConstants.au3>
#include <EditConstants.au3>
#include <ExcelCOM_UDF.au3>
#Include <GuiComboBox.au3>
#include <GuiListView.au3>
;Options
Opt("MustDeclareVars", 1)
Opt("GUICloseOnESC",0)
#EndRegion
#Region CONSTANTS AND VARIABLES
Global Const $MY_DATABASE = @ScriptDir & '\egv.qah '
Global Const $MY_INI = @ScriptDir & '\english.ini'
Global Const $MY_SCREENWIDTH = @DesktopWidth
Global Const $MY_SCREENHEIGHT = @DesktopHeight-32
Global Const $MY_WINTITLE = INIRead($MY_INI,"Others","WindowTitle","") & ' v. '& IniRead($MY_INI,"Others","Version","")

Global $iTrack, $iFirst, $dir, $TrackDir, $bDoubleClicked=FALSE
Global $hFile, $hLVItems, $hRadio[3], $bExportFlag=FALSE
Global $sTableHeader, $sLastSheet, $bSaveFlag, $sSupplier, $sDefects
Local $nMsg, $nTemp, $nDiff, $nTempID, $nPos, $nTemp1, $nTemp2, $nCID, $bFlag, $bOneSupplier
Local $sTemp, $sOld, $sPos, $iRow, $iCol, $sSupplierName, $arResult, $sResult, $sDate, $oBook
Local $nSupplierCount, $nBookCount, $sFirstBook, $sSaveName,$hSplashScreen
Dim $arSuppliers, $hSupplierTab, $arTemp, $hMenu, $hButtons, $arDefectCodes
#EndRegion

#Region INITIALIZATION
If NOT FileExists($MY_INI) Then
	MsgBox(0,"File Missing","An INI file is missing."&@CRLF&'Error Code: 0')
	Exit
EndIf
If NOT FileExists($MY_DATABASE) Then
	MsgBox(0,"Database Missing","The database file is missing."&@CRLF&'Error Code: 1')
	Exit
EndIf

;SQLite StartUp
_SQLite_Startup ()
If @error > 0 Then
	;error initilizing SQLite
EndIf
$hFile = _SQLite_Open($MY_DATABASE)
If @error > 0 Then
	;error opening database
EndIf

;Supplier Database
$arSuppliers=IniReadSection($MY_INI,"Suppliers") ;supplier list from INI file
If NOT IsArray($arSuppliers) Then
	MsgBox(0,"INI Corrupt","The INI file is corrupt."&@CRLF&"Error Code: 10")
	Exit
EndIf
If $arSuppliers[1][1] = "TRUE" Then _ArraySort($arSuppliers,0,2,0,1)
Dim $hSupplierTab[Ubound($arSuppliers)-1][2] ;all the suppliers plues one for "Custom View"
;supplier string - doesn't include first one - to be added when combo box is created
$sSupplier=''
For $nCount = 3 to UBound($arSuppliers)-1
	$sSupplier&=$arSuppliers[$nCount][1]
	If $nCount <> UBound($arSuppliers)-1 Then $sSupplier&='|'
Next
;defect string
$arDefectCodes=IniReadSection($MY_INI,"DefectCodes")
If NOT IsArray($arDefectCodes) Then
	MsgBox(0,"INI Corrupt","The INI file is corrupt."&@CRLF&"Error Code: 15")
	Exit
EndIf
_arraysort($arDefectCodes,0,2,0,1)
$sDefects=''
For $nCount = 2 to UBound($arDefectCodes)-1
	$sDefects&=$arDefectCodes[$nCount][1]
	If $nCount <> UBound($arDefectCodes)-1 Then $sDefects&='|'
Next

;Check for FDYear and reset if necessary
_SQLite_GetTable($hFile,"SELECT * FROM 'Preferences' WHERE Pref = 'FDYear';",$arResult,$iRow,$iCol)
If $arResult[$arResult[0]] <> @YEAR Then
	_SQLite_Exec($hFile,"UPDATE Preferences SET PrefValue ='"&@YEAR&"' WHERE Pref = 'FDYear';")
	_SQLite_Exec($hFile,"UPDATE Preferences SET PrefValue = '1' WHERE Pref = 'NextFDNo';")
EndIf

;Report headers
$arTemp=0
$arTemp=IniReadSection($MY_INI,"ReportHeaders")
If NOT IsArray($arTemp) Then
	MsgBox(0,"INI Corrupt","The INI file is corrupt."&@CRLF&"Error Code: 17")
	Exit
EndIf
$sTableHeader=""
For $nCount=1 To $arTemp[0][0]
	$sTableHeader&=$arTemp[$nCount][1]
	$nDiff=0
	If $nCount=2 OR $nCount = 5 OR $nCount = 6 OR $nCount=12 Then 
		$nDiff=34-StringLen($arTemp[$nCount][1])
	EndIf
	;pad header data
	While $nDiff > 0
		$sTableHeader&=' '
		$nDiff-=1
	WEnd
	If $nCount <> 13 Then $sTableHeader&='|'
Next
#EndRegion

Global $hMain = GUICreate($MY_WINTITLE,$MY_ScreenWidth,$My_ScreenHeight,-2,-3, BitOr($WS_MINIMIZEBOX, $WS_MAXIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU, $WS_SIZEBOX, $WS_MAXIMIZE))

#Region GUI MENU
#cs
$arTemp=IniReadSection($MY_INI,"Menu")
Dim $hMenu[Ubound($arTemp)-1][3]
Dim $arOld[2][2] ;old array Name,CID
For $nCount=1 To UBound($arTemp)-1
	If StringInStr($arTemp[$nCount][1],'?') > 0 Then ;menu heading
		$sTemp=StringReplace($arTemp[$nCount][1],'?','') ;stripper
		If StringInStr($arTemp[$nCount][0],$arOld[0][0]) > 0 Then ;sub menu
			$hMenu[$nCount-1][0]=GUICtrlCreateMenu($sTemp,$arOld[0][1])
			$arOld[1][0]=$arTemp[$nCount][0]
			$arOld[1][1]=$hMenu[$nCount-1][0]
		Else
			$hMenu[$nCount-1][0]=GUICtrlCreateMenu($sTemp)
			$arOld[0][0]=$arTemp[$nCount][0]
			$arOld[0][1]=$hMenu[$nCount-1][0]
		EndIf
		$hMenu[$nCount-1][1]=$sTemp
		$hMenu[$nCount-1][2]=$arTemp[$nCount][0]
	Else
		If $arTemp[$nCount][1]='^' Then ;divider
			$sTemp=''
		Else
			$sTemp=StringReplace($arTemp[$nCount][1],'*','') ;stripper
		EndIf
		If StringInStr($arTemp[$nCount][0],$arOld[1][0]) > 0 Then
			$hMenu[$nCount-1][0]=GUICtrlCreateMenuItem($sTemp,$arOld[1][1]) ;if part of the sub menu
		Else
			$hMenu[$nCount-1][0]=GUICtrlCreateMenuItem($sTemp,$arOld[0][1]) ;else part of the main menu
		EndIf
		If StringInStr($arTemp[$nCount][1],'*') > 0 Then GUICtrlSetState(-1,$GUI_DISABLE)
		$hMenu[$nCount-1][1]=$sTemp
		$hMenu[$nCount-1][2]=$arTemp[$nCount][0]
	EndIf
Next
#ce
#EndRegion
#Region GUI LEFT PANEL
GuiCtrlCreateLabel("",1,5,97,$MY_SCREENHEIGHT-77,$SS_SUNKEN)
GUICtrlSetBkColor(-1,0xFFFFFF)
GuiCtrlSetState(-1,$GUI_DISABLE)
GuiCtrlSetResizing(-1,$GUI_DOCKLEFT+$GUI_DOCKWIDTH+$GUI_DOCKTOP+$GUI_DOCKBOTTOM)

GUICtrlCreateGroup("View:",2,8,95,93)
GuiCtrlSetResizing(-1,$GUI_DOCKLEFT+$GUI_DOCKWIDTH+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
GUICtrlSetBkColor(-1,0xFFFFFF)
	$hRadio[0]=GUICtrlCreateRadio("All", 5, 23, 90, 20)
	GUICtrlSetBkColor(-1,0xFFFFFF)
	GuiCtrlSetResizing(-1,$GUI_DOCKLEFT+$GUI_DOCKWIDTH+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$hRadio[1]=GUICtrlCreateRadio("Open", 5, 48, 90, 20)
	GUICtrlSetBkColor(-1,0xFFFFFF)
	GuiCtrlSetResizing(-1,$GUI_DOCKLEFT+$GUI_DOCKWIDTH+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	GuiCtrlSetState(-1,$GUI_CHECKED)
	$hRadio[2]=GUICtrlCreateRadio("Closed", 5, 73, 90, 20)
	GUICtrlSetBkColor(-1,0xFFFFFF)
	GuiCtrlSetResizing(-1,$GUI_DOCKLEFT+$GUI_DOCKWIDTH+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
GUICtrlCreateGroup("", -99, -99, 1, 1)
	
$arTemp=0
$arTemp=IniReadSection($MY_INI,"Buttons")
If NOT IsArray($arTemp) Then
	MsgBox(0,"INI Corrupt","The INI file is corrupt."&@CRLF&"Error Code: 19")
	Exit
EndIf
Dim $hButtons[Ubound($arTemp)-1][3]
For $nCount = 1 To UBound($arTemp)-1
	$hButtons[$nCount-1][0]=GUICtrlCreateButton($arTemp[$nCount][1],2,32*($nCount-1)+8+95,95,30)
	GuiCtrlSetResizing(-1,$GUI_DOCKLEFT+$GUI_DOCKWIDTH+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$hButtons[$nCount-1][1]=$arTemp[$nCount][1]
	$hButtons[$nCount-1][2]=$arTemp[$nCount][0]
Next
#EndRegion
#Region GUI TABS
;Create Tabs
Global $hTab = GUICtrlCreateTab(100,5,$MY_ScreenWidth-100,$My_ScreenHeight-75)
GUICtrlSetResizing($hTab,$GUI_DOCKBOTTOM+$GUI_DOCKLEFT+$GUI_DOCKTOP)
Global $hListView = GUICtrlCreateListView($sTableHeader,105,33,$MY_ScreenWidth-12-100,$My_ScreenHeight-110,$LVS_SHOWSELALWAYS,BitOr($LVS_EX_GRIDLINES,$LVS_EX_FULLROWSELECT))
GUICtrlSetResizing($hListView,$GUI_DOCKBOTTOM+$GUI_DOCKLEFT+$GUI_DOCKTOP)

For $nCount=0 To $arSuppliers[0][0]-2
	$hSupplierTab[$nCount][0]=GuiCtrlCreateTabItem($arSuppliers[$nCount+2][1])
	$hSupplierTab[$nCount][1]=$arSuppliers[$nCount+2][1]
Next
$hSupplierTab[$nCount][0]=GuiCtrlCreateTabItem("Custom View")
$hSupplierTab[$nCount][1]="Custom View"
GUICtrlCreateTabItem("")
#EndRegion
#Region GUI LISTVIEW
_PopulateListView($hSupplierTab[0][1])
#EndRegion

GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

GUISetState(@SW_SHOW,$hMain)

#Region MAIN GUI CONTROL
While 1
	If $bDoubleClicked Then 
		_EditSelected()
	Else
		$nMsg = GUIGetMsg()
		
		$nTemp1=_ArraySearch($hMenu,$nMsg)
		$nTemp2=_ArraySearch($hButtons,$nMsg)
		If $nTemp1 >= 0 Then ;menu
;ConsoleWrite($hMenu[$nTemp1][1]&@CRLF)
		ElseIf $nTemp2 >= 0 Then ;buttons
			Switch $hButtons[$nTemp2][2]
				Case 'Button1' ;New Record
					_AddNewRecord()
				Case 'Button2' ;Print QA Hold Tag
					$arTemp=_GetQAHoldSelected(_GUICtrlListView_GetSelectedIndices($hListView, True))
					If $arTemp = -1 Then
						_CenteredMsg("No Record Selected","Please select the record(s) to print.","&Okay",$hMain,200,70)
					Else
						For $nCount=1 To $arTemp[0]
							_SQLite_QuerySingleRow($hFile,"SELECT * FROM Data WHERE QA_Hold_Number = '"&$arTemp[$nCount]&"';",$arResult)
							_PrintQAHoldTag($arResult)
						Next
					EndIf
				Case 'Button4' ;Export to Excel
					$bSaveFlag=True				
					$sSaveName=FileSaveDialog("Save File",@ScriptDir,"Excel Files (*.xls)")
					If $sSaveName='' Then $bSaveFlag = FALSE
					If StringRight($sSaveName,4)<> '.xls' Then $sSaveName&='.xls'
					If FileExists($sSaveName) Then
						$nTemp=_CenteredMsg("File Exists", "Do you wish to overwrite the current file?","&No|Yes",$hMain)
						If $nTemp = 2 Then 
							FileDelete($sSaveName)
						Else
							$bSaveFlag = False
						EndIf
					EndIf

					If $bSaveFlag Then
						$nTemp=GUICtrlRead($hTab,1)
						$sTemp=$hSupplierTab[_ArraySearch($hSupplierTab,$nTemp)][1]
						If $sTemp="Custom View" Then
							$nTemp=3
						Else	
							$nTemp=_CenteredMsg("Export Records", "Do you wish to export all suppliers or the selected supplier?", "&Selected Sheet|All Records", $hMain)
						EndIf
						$arResult=0
						If NOT $bExportFlag Then
							$hSplashScreen=_ShowExportingSplashScreen()
							$bExportFlag=TRUE
						Else
							GUISetState(@SW_SHOW,$hSplashScreen)
						EndIf
							
						Local $sStatus=''
						If GUICtrlRead($hRadio[1])=$GUI_CHECKED Then $sStatus="' AND Status='Open"
						If GUICtrlRead($hRadio[2])=$GUI_CHECKED Then $sStatus="' AND Status='Closed"
							
						$oBook=_ExcelBookNew(0)
						Switch $nTemp
							Case 1 ;Selected Sheet
								$nTemp1=GUICtrlRead($hTab,1)
								$sTemp="SELECT * FROM Data WHERE (Supplier = '"&$hSupplierTab[_ArraySearch($hSupplierTab,$nTemp1)][1]&$sStatus&"');"
								$arResult=0
								_SQLite_GetTable2d($hFile,$sTemp,$arResult,$iRow,$iCol)
								If IsArray($arResult) Then
									_ExcelSheetNameSet($oBook,$hSupplierTab[_ArraySearch($hSupplierTab,$nTemp1)][1])
									_WriteReportData($oBook,$arResult)
								EndIf
								
							Case 2 ;All Records
								$sResult=''
								$arTemp=_ExcelSheetList($oBook)
								$nSupplierCount=2
								$nBookCount=1
								$sFirstBook=''

								While $nBookCount < $arTemp[0] AND $nSupplierCount < $arSuppliers[0][0]
									$arResult=0
									$sTemp="SELECT * FROM Data WHERE (Supplier = '"&$arSuppliers[$nSupplierCount][1]&$sStatus&"');"
									$arResult=0
									_SQLite_GetTable2d($hFile,$sTemp,$arResult,$iRow,$iCol)
									If IsArray($arResult) Then
										_ExcelSheetActivate($oBook, $arTemp[$nBookCount])
										_ExcelSheetNameSet($oBook,$arSuppliers[$nSupplierCount][1])
											If $sFirstBook='' Then $sFirstBook=$arSuppliers[$nSupplierCount][1]
										$nBookCount+=1
										_WriteReportData($oBook,$arResult)
									EndIf
									$nSupplierCount+=1
								WEnd
								_ExcelSheetActivate($oBook, $arTemp[$nBookCount])
									
								For $nCount = $arSuppliers[0][0] To $nSupplierCount Step -1
									$arResult=0
									$sTemp="SELECT * FROM Data WHERE (Supplier = '"&$arSuppliers[$nCount][1]&$sStatus&"');"
									$arResult=0
									_SQLite_GetTable2d($hFile,$sTemp,$arResult,$iRow,$iCol)
									If IsArray($arResult) Then
										_ExcelSheetAddNew($oBook,$arSuppliers[$nCount][1])
										_WriteReportData($oBook,$arResult)
									EndIf
								Next
								_ExcelSheetDelete($oBook, $arTemp[$nBookCount])
								_ExcelSheetActivate($oBook,$sFirstBook)
								
							Case 3 ;Custom
								$arResult=0
								_SQLite_GetTable2d($hFile,"SELECT PrefValue FROM Preferences WHERE Pref='CustomSQLite'",$arResult,$iRow,$iCol)
								$sTemp=$arResult[1][0]
								$arResult=0
								_SQLite_GetTable2d($hFile,$sTemp,$arResult,$iRow,$iCol)
								If IsArray($arResult) Then
									_ExcelSheetNameSet($oBook,"Custom View")
									_ExportDatabase($arResult,$sSaveName)
								EndIf
								
						EndSwitch
					EndIf

					If $bSaveFlag Then
						_ExcelBookSaveAs($oBook,$sSaveName)
						_ExcelBookClose($oBook)
						GUISetState(@SW_ENABLE,$hMain)
						GUISetState(@SW_HIDE,$hSplashScreen)
						ShellExecute($sSaveName)
					EndIf

				Case 'Button3' ;Close Selected
					$arTemp=_GetQAHoldSelected(_GUICtrlListView_GetSelectedIndices($hListView, True))
					If $arTemp = -1 Then
						_CenteredMsg("No Record Selected","Please select the record(s) to close.","&Okay",$hMain,200,70)
					Else
						For $nCount=1 To $arTemp[0]
							_SQLite_Exec($hFile,"UPDATE Data SET Status='Closed' WHERE QA_Hold_Number = '"&$arTemp[$nCount]&"';")
						Next
					EndIf
					_TabUpdate()
				
				Case 'Button6' ;Export All
					$bSaveFlag=True				
					$sSaveName=FileSaveDialog("Save File",@ScriptDir,"Excel Files (*.xls)")
					If $sSaveName='' Then $bSaveFlag = FALSE
					If StringRight($sSaveName,4)<> '.xls' Then $sSaveName&='.xls'
					If FileExists($sSaveName) Then
						$nTemp=_CenteredMsg("File Exists", "Do you wish to overwrite the current file?","&No|Yes",$hMain)
						If $nTemp = 2 Then 
							FileDelete($sSaveName)
						Else
							$bSaveFlag = False
						EndIf
					EndIf
					If NOT $bExportFlag Then
						$hSplashScreen=_ShowExportingSplashScreen()
						$bExportFlag=TRUE
					Else
						GUISetState(@SW_SHOW,$hSplashScreen)
					EndIf
					$sTemp="SELECT * FROM Data ORDER BY QA_Hold_Number ASC;"
					$arResult=0
					_SQLite_GetTable2d($hFile,$sTemp,$arResult,$iRow,$iCol)
					If IsArray($arResult) Then _ExportDatabase($arResult,$sSaveName)
					
					GUISetState(@SW_ENABLE,$hMain)
					GUISetState(@SW_HIDE,$hSplashScreen)
					ShellExecute($sSaveName)
					
				Case 'Button5' ;Define Custom View
					$nTemp=_CustomMenu($hMain)
					If $nTemp = 0 Then 
						$nTemp=GUICtrlRead($hTab,1)
						$sTemp=$hSupplierTab[_ArraySearch($hSupplierTab,$nTemp)][1]
						If $sTemp="Custom View" Then _TabUpdate()
					EndIf
			EndSwitch
		Else
			Switch $nMsg
				Case $GUI_EVENT_CLOSE
					ExitLoop
				Case $hTab
					_TabUpdate()
				Case $hRadio[0] ;All
					_TabUpdate()		
				Case $hRadio[1] ;Open
					_TabUpdate()
				Case $hRadio[2] ;Closed
					_TabUpdate()
			EndSwitch
		EndIf
	EndIf
WEnd
#EndRegion
GUIDelete($hMain)
_SQLite_Close($hFile)
_SQLite_Shutdown()
Exit

#Region FUNCTION DEFINITIONS
Func WM_NOTIFY($hWnd, $Msg, $wParam, $lParam)
    Local $hWndListView, $tNMHDR, $hWndFrom, $iCode
   
    $hWndListView = $hListView
    If Not HWnd($hWndListView) Then $hWndListView = GUICtrlGetHandle($hListView)
   
    $tNMHDR = DllStructCreate($tagNMHDR, $lParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iCode = DllStructGetData($tNMHDR, "Code")

    Switch $hWndFrom
        Case $hWndListView
            Switch $iCode
				;Case $NM_DBLCLK ; Sent by a list-view control when the user double-clicks an item with the left mouse button
				Case $NM_RCLICK ;right click
                    $bDoubleClicked=True
                Case $LVN_BEGINDRAG
                    Local $tINFO = DllStructCreate($tagNMLISTVIEW, $lParam)
                    Local $iItem = DllStructGetData($tINFO, "Item")
                    $iTrack = $iItem
                    $iFirst = $iItem
                    _GUICtrlListView_SetItemSelected($hWndFrom, -1, False)
                    _GUICtrlListView_SetItemSelected($hWndFrom, $iItem)
                    Return 1
                Case $LVN_HOTTRACK
                    Local $tINFO = DllStructCreate($tagNMLISTVIEW, $lParam)
                    Local $iItem = DllStructGetData($tINFO, "Item")
                    Local $aCursInfo = GUIGetCursorInfo($hWnd)
                    If ($iItem <> -1) And ($aCursInfo[2] = 1) And ($iTrack <> $iItem) Then
                        If $iItem > $iTrack Then
                            $TrackDir = 1
                        Else
                            $TrackDir = -1
                        EndIf
                        If $iItem > $iFirst Then
                            $dir = 1
                        Else
                            $dir = -1
                        EndIf
                        _GUICtrlListView_EnsureVisible($hWndFrom, $iItem + $TrackDir)
                        If $TrackDir <> $dir Or $iItem == $iFirst Then
                            For $i = $iTrack To $iItem - $TrackDir Step $TrackDir
                                _GUICtrlListView_SetItemSelected($hWndFrom, $i, False, False)
                            Next
                        EndIf
                       
                        $iTrack = $iItem
                        For $i = $iFirst To $iItem Step $dir
                            _GUICtrlListView_SetItemSelected($hWndFrom, $i, True)
                        Next
                    EndIf
            EndSwitch
    EndSwitch
   
    Return $GUI_RUNDEFMSG
EndFunc ;=>WM_NOTIFY

Func _GetQAHoldSelected($aIndex)
    If $aIndex[0] < 1 Then Return -1
    Local $aData[UBound($aIndex)]
    $aData[0] = $aIndex[0]
    For $i = 1 To $aIndex[0]
        $aData[$i] = _GUICtrlListView_GetItemText($hListView, $aIndex[$i])
    Next
    Return $aData
EndFunc ;=>_GetQAHoldSelected

Func _CenteredMsg($title, $text, $button, $hWin=-1, $msgwidth=300,$msgheight=80,$buttonwidth=80,$ntimeout=-1)
    Local $nOldOpt = Opt('Guioneventmode',0)
	Local $buttonarray=StringSplit($button,"|")
	Local $msgButton[$buttonarray[0]+1]
    Local $buttoncount,$defbutton=0, $retvalue, $buttonwork, $buttonxpos, $mmsg
	
    If StringInStr($button,"&",0,2)<>0 Then ;if two buttons are showing focus
		$nOldOpt = Opt('Guioneventmode',$nOldOpt)
		SetError(1)
        Return -1
    EndIf
	If ($buttonwidth+8)*$buttonarray[0]+8>$msgwidth Then ;if button width exceeds window size, resize window
        $msgwidth=($buttonwidth+8)*$buttonarray[0]+8
    EndIf
	If $hWin <> -1 Then 
		$arTemp=WinGetPos($hWin)
		GUISetState(@SW_DISABLE,$hWin)
	Else
		Dim $arTemp[4]
		$arTemp[0]=0
		$arTemp[1]=0
		$arTemp[2]=$MY_SCREENWIDTH
		$arTemp[3]=$MY_SCREENHEIGHT
	EndIf
	Local $msggui = GUICreate($title, $msgwidth, $msgheight, ($arTemp[2]-$msgwidth)/2+$arTemp[0]-3,($arTemp[3]-$msgheight)/2+$arTemp[1]-16, Bitor($WS_POPUPWINDOW,$WS_CAPTION),Bitor($WS_EX_TOPMOST,$WS_EX_TOOLWINDOW))
	If $msggui=0 Then 
		$nOldOpt = Opt('Guioneventmode',$nOldOpt)
		SetError(1)
		Return -1
	EndIf
    Local $hDummy=GUICtrlCreateLabel($text, 8, 8, $msgwidth-16, $msgheight-40)
    $buttonxpos=(($msgwidth/$buttonarray[0])-($buttonwidth))/2
    For $buttoncount=0 To $buttonarray[0]-1
        $buttonwork=$buttonarray[$buttoncount+1]
        If StringLeft($buttonwork,1)="&" Then
            $defbutton=0x0001 ;$BS_DEFPUSHBUTTON
            $buttonarray[$buttoncount+1]=StringTrimLeft($buttonwork,1)
        EndIf
        $msgbutton[$buttoncount] = GUICtrlCreateButton($buttonarray[$buttoncount+1], $buttonxpos+($buttoncount*$buttonwidth)+($buttoncount*$buttonxpos*2), $msgheight-32, $buttonwidth, 24,$defbutton)
        $defbutton=0
    Next
    GUISetState(@SW_SHOW,$msggui)

	Dim $timeout
    If $ntimeout <> -1 Then $timeout = TimerInit()
    While 1
        $mmsg = GUIGetMsg()
		If $mmsg > $hDummy Then
			$retvalue = $mmsg-$hDummy ;ctrl number of button minus the ctrl number of the label will result in button 1 = 1, button 2 = 2
			ExitLoop
		Else
		Select
			Case $mmsg = -3 ;$GUI_EVENT_CLOSE = -3
				$retvalue=0
				ExitLoop
            Case Else
                If TimerDiff($timeout)/1000 >= $ntimeout AND $ntimeout <> -1 Then
					$retvalue=0
					ExitLoop
                EndIf
		EndSelect
		EndIf
        If $retvalue <> '' Then 
			$retvalue=0
			ExitLoop
		EndIf
    WEnd
	If $hWin <> -1 Then GUISetState(@SW_ENABLE,$hWin)
    GUIDelete($msggui)
	$nOldOpt = Opt('Guioneventmode',$nOldOpt)
    Return $retvalue
EndFunc;==> _CenteredMsg

Func _AddNewRecord()
	;Local $arDefectCodes, $sSupplier, $sDefects, 
	Local $iRow, $iCol, $arResult, $sFDetNum, $sValues, $sError, $nHeight, $sOldNumber
	Local $sErrorFlag=FALSE, $nHeightDelta=15

	GUISetState(@SW_DISABLE,$hMain)

	#cs
	;Check for FDYear and reset if necessary
	_SQLite_GetTable($hFile,"SELECT * FROM 'Preferences' WHERE Pref = 'FDYear';",$arResult,$iRow,$iCol)
	If $arResult[$arResult[0]] <> @YEAR Then
		_SQLite_Exec($hFile,"UPDATE Preferences SET PrefValue ='"&@YEAR&"' WHERE Pref = 'FDYear';")
		_SQLite_Exec($hFile,"UPDATE Preferences SET PrefValue = '1' WHERE Pref = 'NextFDNo';")
	EndIf

		_SQLite_GetTable($hFile,"SELECT * FROM 'Preferences' WHERE Pref = 'NextFDNo';",$arResult,$iRow,$iCol)
		$sFDetNum=$arResult[$arResult[0]]
		While StringLen($sFDetNum) < 4
			$sFDetNum = '0' & $sFDetNum
		WEnd
		$sFDetNum = StringRight(@YEAR,2) & '-' & $sFDetNum
	#ce
	_SQLite_GetTable($hFile,'SELECT max(rowid) FROM Data',$arResult,$iRow,$iCol)
	_SQLite_GetTable($hFile,'SELECT QA_Hold_Number FROM Data WHERE rowid='&$arResult[$arResult[0]],$arResult,$iRow,$iCol)
	$arTemp=StringSplit($arResult[$arResult[0]],'-')
	If $arTemp[1]=StringRight(@YEAR,2) Then
		$sFDetNum=String(Int($arTemp[2])+1)
		While StringLen($sFDetNum)<4
			$sFDetNum='0'&$sFDetNum
		WEnd
		$sFDetNum=StringRight(@YEAR,2)&'-'&$sFDetNum
		_SQLite_GetTable($hFile,"SELECT PrefValue FROM 'Preferences' WHERE Pref = 'FDYear';",$arResult,$iRow,$iCol)
		If $sFDetNum <> $arResult[$arResult[0]] Then
			;error
		EndIf
	Else
		_SQLite_Exec($hFile,"UPDATE Preferences SET PrefValue ='"&@YEAR&"' WHERE Pref = 'FDYear';")
		_SQLite_Exec($hFile,"UPDATE Preferences SET PrefValue = '1' WHERE Pref = 'NextFDNo';")
		$sFDetNum=StringRight(@YEAR,2)&'-0001'
	EndIf
	;end
	$arTemp=0
	$arTemp=IniReadSection($MY_INI,"NewRecord")
	If NOT IsArray($arTemp) Then
		MsgBox(0,"INI Corrupt","The INI file is corrupt."&@CRLF&"Error Code: 20")
		Exit
	EndIf

	Local $hNewRecord = GUICreate("New QA Hold - "&$sFDetNum, 633, 447, ($MY_SCREENWIDTH-633)/2, ($MY_SCREENHEIGHT-447)/2)
	GUISetBkColor(0xFFFFFF)
	GUICtrlCreatePic(@ScriptDir&'\back.bmp',0,0,633,447)
	GuiCtrlSetState(-1,$GUI_DISABLE)
	Local $LabelStart=GUICtrlCreateLabel($arTemp[1][1]&":", 16, 5, 297, 17)
	GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0xff0000)
	GUICtrlSetFont(-1,12,600)
	GUICtrlCreateLabel($arTemp[2][1]&":", 16, 64, 297, 17)
	GUICtrlCreateLabel($arTemp[3][1]&":", 16, 128, 153, 17)
	GUICtrlCreateLabel($arTemp[4][1]&":", 184, 128, 129, 17)
	GUICtrlCreateLabel($arTemp[5][1]&": "&@MON&'/'&@MDAY&'/'&@YEAR, 344, 8, 100, 17)
	GUICtrlCreateLabel($arTemp[6][1]&":", 344, 64, 257, 17)
	GUICtrlCreateLabel($arTemp[7][1]&":", 344, 184, 257, 17)
	GUICtrlCreateLabel($arTemp[8][1]&":", 16, 184, 127, 17)
	GUICtrlCreateLabel($arTemp[9][1]&":", 16, 248, 137, 17)
	GUICtrlCreateLabel($arTemp[10][1]&":", 176, 248, 137, 17)
	GUICtrlCreateLabel($arTemp[11][1]&":", 344, 128, 257, 17)
	GUICtrlCreateLabel("Affected Rolls:", 344, 248, 121, 17)
	GUICtrlCreateLabel("Affected Boxes:", 479,248,121,17)
	GUICtrlCreateLabel($arTemp[13][1]&":", 16, 328, 54, 17)
	Local $LabelEnd=GUICtrlCreateLabel("Customer PO Number:",176,184,137,17)
	For $i=$LabelStart To $LabelEnd
		GUICtrlSetBkColor($i,$GUI_BKCOLOR_TRANSPARENT)
	Next
	;immediate action
	GUICtrlCreateLabel($arTemp[16][1]&":", 16, 375, 297, 17)
	GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0xff0000)
	
		
	Local $LFaultDetNo = GUICtrlCreateLabel('#'&$sFDetNum, 16, 24, 110, 17)
	GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0xff0000)
	GUICtrlSetFont(-1,12,600)
	Local $CBSupplier = GUICtrlCreateCombo($arSuppliers[2][1], 16, 80, 297, 25, $CBS_DROPDOWNLIST)
	GUICtrlSetData(-1,$sSupplier,$hSupplierTab[_ArraySearch($hSupplierTab,GUICtrlRead($hTab,1))][1])
	Local $CBDescription = GUICtrlCreateCombo('--', 344, 80, 257, 25, $CBS_DROPDOWNLIST)
	GUICtrlSetData(-1,$sDefects)
	Local $ICustomer = GUICtrlCreateInput("Customer", 16, 144, 153, 21)
	Local $IProduct = GUICtrlCreateInput("Product Name", 184, 144, 129, 21)
	Local $IProdOrder = GUICtrlCreateInput("Customer Order Number", 16, 200, 121, 21)
	Local $ICustPO = GUICtrlCreateInput("N/A",176,200,137,21)
	Local $IMachine = GUICtrlCreateInput("Machine Number", 344, 144, 137, 21)
	Local $IQuantity = GUICtrlCreateInput("Quantity", 344, 200, 137, 21)
	Local $CBUnits = GUICtrlCreateCombo("Pouches", 496, 200, 105, 25, $CBS_DROPDOWNLIST)
	GUICtrlSetData(-1,'Pounds|Meters')
	Local $ISkidNo = GUICtrlCreateInput("N/A", 16, 264, 137, 21)
	Local $ILotNo = GUICtrlCreateInput("Lot Number", 176, 264, 137, 21)
	;Local $EQCTech=GUICtrlCreateInput(@CRLF&"",105,327,49,21,BitOr($ES_MULTILINE,$ES_CENTER))
	Local $EQCTech=GUICtrlCreateInput(@CRLF&"",105,313,49,49,BitOr($ES_MULTILINE,$ES_CENTER))
	Local $CBImmediateAction=GUICtrlCreateCombo("None", 16, 391, 297, 25, $CBS_DROPDOWNLIST)
	GUICtrlSetData(-1, "Release|Controlled Release|Waste|Quarantine","None")
	;Local $EAffectedRolls = GUICtrlCreateEdit("",344, 264, 265, 105,BitOr($WS_VSCROLL,$ES_MULTILINE)) ;rolls
	Local $EAffectedRolls = GUICtrlCreateEdit("None",344, 264, 130, 105,BitOr($WS_VSCROLL,$ES_MULTILINE)) ;rolls
	Local $EAffectedBoxes = GUICtrlCreateEdit("None",479,264,130,105,BitOr($WS_VSCROLL,$ES_MULTILINE)) ;boxes
	Local $BEnter = GUICtrlCreateButton($arTemp[14][1], 520, 384, 89, 25, 0)
	Local $BExit = GUICtrlCreateButton($arTemp[15][1], 520, 416, 89, 25, 0)

	GUISetState(@SW_SHOW, $hNewRecord)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $BExit
				ExitLoop
			Case $BEnter
				;ensure proper data is inputed
				$sErrorFlag=False
				$sError='Some required infomation is missing.'&@CRLF&@CRLF
				$nHeight=65
				If GUICtrlRead($CBSupplier) = '--' Then
					$sError&='Please enter a supplier name.'&@CRLF
					$sErrorFlag=True
					$nHeight+=$nHeightDelta
				EndIf
				If GUICtrlRead($CBDescription) = '--' Then
					$sError&="Please enter a defect description."&@CRLF
					$sErrorFlag=True
					$nHeight+=$nHeightDelta
				EndIf
				If GUICtrlRead($EQCTech) = @CRLF OR GUICtrlRead($EQCTech)='' Then
					$sError&="Please enter QC Tech number."&@CRLF
					$sErrorFlag=True
					$nHeight+=$nHeightDelta
				EndIf
				If GUICtrlRead($IMachine) = 'Machine Number' OR GUICtrlRead($IMachine)='' Then
					$sError&="Please enter the machine number."&@CRLF
					$sErrorFlag=True
					$nHeight+=$nHeightDelta
				EndIf
				If GUICtrlRead($ICustomer)='Customer' OR GUICtrlRead($ICustomer)='' Then
					$sError&='Please enter the customer name.'&@CRLF
					$sErrorFlag=True
					$nHeight+=$nHeightDelta
				EndIf
				If GUICtrlRead($IProduct)='Product Name' OR GUICtrlRead($IProduct)='' Then
					$sError&='Please enter the product name.'&@CRLF
					$sErrorFlag=True
					$nHeight+=$nHeightDelta
				EndIf
				If GUICtrlRead($IProdOrder)='Customer Order Number' OR GUICtrlRead($IProdOrder)='' Then
					$sError&='Please enter the customer order number.'&@CRLF
					$sErrorFlag=True
					$nHeight+=$nHeightDelta
				EndIf
				If GuiCtrlRead($IQuantity)='Quantity' OR GUICtrlRead($IQuantity)='' Then
					$sError&='Please enter a quantity of defective product.'&@CRLF
					$sErrorFlag=True
					$nHeight+=$nHeightDelta
				EndIf
				If GUICtrlRead($ILotNo)='Lot Number' OR GUICtrlRead($ILotNo)='' Then
					$sError&='Please enter the lot number.'&@CRLF
					$sErrorFlag=True
					$nHeight+=$nHeightDelta
				EndIf
				If (GUICtrlRead($EAffectedRolls)='None' Or GUICtrlRead($EAffectedBoxes)='None') Then
					If (GUICtrlRead($EAffectedRolls)='None' AND GUICtrlRead($EAffectedBoxes)='None') Then
						$sError&='Please enter the affected boxes and / or rolls.'&@CRLF
						$sErrorFlag=True
						$nHeight+=$nHeightDelta
					EndIf
				EndIf
				If $sErrorFlag Then
					_CenteredMsg("Missing Information",$sError,"&Okay",$hNewRecord,300,$nHeight)
				Else
					_SQLite_Exec($hFile, 'UPDATE Preferences SET PrefValue='& $arResult[$arResult[0]]+1 &" WHERE Pref='NextFDNo';")
;need to convert FaultDescription from language to english
					$sValues=	'"'&$sFDetNum & '",' & _ 										;Fault Number
								'"'&GUICtrlRead($CBDescription) & '",' & _ 						;Fault Description
								'"'&@YEAR & @MON & @MDAY & '",' & _								;Date Entered
								'"'&StringReplace(GUICtrlRead($EQCTech),@CRLF,'') & '",' & _	;QCTech
								'"'&GUICtrlRead($IMachine) & '",' & _							;Machine Number
								'"'&GUICtrlRead($CBSupplier) & '",' & _							;Supplier
								'"'&GUICtrlRead($ICustomer) & '",' & _							;Customer
								'"'&GUICtrlRead($IProduct) & '",' & _							;Product Name
								'"'&GUICtrlRead($IProdOrder) & '",' & _							;Production Order
								'"'&GUICtrlRead($ISkidNo) & '",' & _							;Ampac Skid
								'"'&GUICtrlRead($ILotNo) & '",' & _								;Ampac Lot
								'"'&GUICtrlRead($IQuantity) & '",' & _							;Quantity
								'"'&GUICtrlRead($CBUnits) & '",' & _							;Units
								'"'&GUICtrlRead($EAffectedRolls) & '",' & _						;Disposition -> Affected Rolls
								'"Open",' & _													;Status
								'"'&GUICtrlRead($CBImmediateAction) & '",' & _					;ImmediateAction
								'"None","None",' & _											;QADisposition, Notes
								'"'&GUICtrlRead($ICustPO) & _									;Customer PO
								'"'&GUICtrlRead($EAffectedBoxes) & '");'						;Affected Boxes
					$nTemp=_ArraySearch($arSuppliers,GUICtrlRead($CBSupplier),0,0,0,0,0,1)
					$sOldNumber=$sFDetNum
					_SQLite_Exec($hFile,'INSERT INTO Data VALUES ('&$sValues)
					;Update Form - Fault Number, quantity, fault description, skid
					#cs					
					;Check for FDYear and reset if necessary
					_SQLite_GetTable($hFile,"SELECT * FROM 'Preferences' WHERE Pref = 'FDYear';",$arResult,$iRow,$iCol)
					If $arResult[$arResult[0]] <> @YEAR Then
						_SQLite_Exec($hFile,"UPDATE Preferences SET PrefValue ='"&@YEAR&"' WHERE Pref = 'FDYear';")
						_SQLite_Exec($hFile,"UPDATE Preferences SET PrefValue = '1' WHERE Pref = 'NextFDNo';")
					EndIf

					_SQLite_GetTable($hFile,"SELECT * FROM 'Preferences' WHERE Pref = 'NextFDNo';",$arResult,$iRow,$iCol)
					$sFDetNum=$arResult[$arResult[0]]
					While StringLen($sFDetNum) < 4
						$sFDetNum = '0' & $sFDetNum
					WEnd
					$sFDetNum = StringRight(@YEAR,2) & '-' & $sFDetNum
					#ce
					_SQLite_GetTable($hFile,'SELECT max(rowid) FROM Data',$arResult,$iRow,$iCol)
					_SQLite_GetTable($hFile,'SELECT QA_Hold_Number FROM Data WHERE rowid='&$arResult[$arResult[0]],$arResult,$iRow,$iCol)
					$arTemp=StringSplit($arResult[$arResult[0]],'-')
					If $arTemp[1]=StringRight(@YEAR,2) Then
						$sFDetNum=String(Int($arTemp[2])+1)
						While StringLen($sFDetNum)<4
							$sFDetNum='0'&$sFDetNum
						WEnd
						$sFDetNum=StringRight(@YEAR,2)&'-'&$sFDetNum
						_SQLite_GetTable($hFile,"SELECT PrefValue FROM 'Preferences' WHERE Pref = 'FDYear';",$arResult,$iRow,$iCol)
						If $sFDetNum <> $arResult[$arResult[0]] Then
							;error
						EndIf
					Else
						_SQLite_Exec($hFile,"UPDATE Preferences SET PrefValue ='"&@YEAR&"' WHERE Pref = 'FDYear';")
						_SQLite_Exec($hFile,"UPDATE Preferences SET PrefValue = '1' WHERE Pref = 'NextFDNo';")
						$sFDetNum=StringRight(@YEAR,2)&'-0001'
					EndIf
					;end
					WinSetTitle("New QA Hold - "&$sOldNumber,'',"New QA Hold - "&$sFDetNum)
					GUICtrlSetData($LFaultDetNo,"#"&$sFDetNum)
					GuiCtrlSetData($IQuantity,"Quantity")
					GuiCtrlSetData($CBDescription,"--")
					GuiCtrlSetData($CBSupplier,"--")
					GUICtrlSetData($ISkidNo,"N/A")
					GuiCtrlSetData($EAffectedRolls,"None")
					GuiCtrlSetData($EAffectedBoxes,"None")
					GuiCtrlSetData($CBImmediateAction,"None")
					_TabUpdate()
					_SQLite_QuerySingleRow($hFile,"SELECT * FROM Data WHERE QA_Hold_Number = '"&$sOldNumber&"';",$arResult)
					If @Compiled Then _PrintQAHoldTag($arResult)
					;_CenteredMsg("Data Entered","New record successfully added."&@CRLF&"QA Hold Tag #"&$sOldNumber&' printed.','&Okay',$hNewRecord,200,75)
				EndIf
		EndSwitch
	WEnd
	GUISetState(@SW_ENABLE,$hMain)
	GUIDelete($hNewRecord)
EndFunc ;=> _AddNewRecord

Func _PopulateListView($sSupplierName)
	Local $sStatus='', $sTemp
	If $sSupplierName = "Custom View" Then
		$arResult=0
		_SQLite_GetTable2d($hFile,"SELECT PrefValue FROM Preferences WHERE Pref='CustomSQLite'",$arResult,$iRow,$iCol)
		$sTemp=$arResult[1][0]
		$arResult=0
		_SQLite_GetTable2d($hFile,$sTemp,$arResult,$iRow,$iCol)
	Else
		If GUICtrlRead($hRadio[1])=$GUI_CHECKED Then $sStatus="' AND Status='Open"
		If GUICtrlRead($hRadio[2])=$GUI_CHECKED Then $sStatus="' AND Status='Closed"
		_SQLite_GetTable2d($hFile,"SELECT * FROM Data WHERE (Supplier = '"&$sSupplierName&$sStatus&"');",$arResult,$iRow,$iCol)
	EndIf
	
	If $iRow > 0 Then
		Dim $hLVItems[$iRow][2]
		For $nCount=1 To $iRow
			$sTemp=''
			For $nPos=0 To $iCol-1
				If ($nPos <> 3 AND $nPos <> 5 AND $nPos < 15) Then ;QA_Tech, Supplier - 15,16,17 are ImmediateAction, QADisposition, and Notes
					If $nPos = 2 Then ;date
						$sDate=StringLeft($arResult[$nCount][2],4)
						$arResult[$nCount][2]=StringReplace($arResult[$nCount][2],$sDate,'')
						$sDate=StringLeft($arResult[$nCount][2],2)&'/'&StringRight($arResult[$nCount][2],2)&'/'&$sDate
						$sTemp&=$sDate
					Else
						$sTemp&=$arResult[$nCount][$nPos]
					EndIf
					If $nPos <> $iCol-1 Then $sTemp&='|'
				EndIf
			Next
			$hLVItems[$nCount-1][0]=GUICtrlCreateListViewItem($sTemp,$hListView)
			$hLVItems[$nCount-1][1]=$arResult[$nCount][0]
		Next
	EndIf
EndFunc ;=> _PopulateListView

Func _TabUpdate()
	Local $nCount
	Local $nTemp=GUICtrlRead($hTab,1)
	Local $sTemp=$hSupplierTab[_ArraySearch($hSupplierTab,$nTemp)][1];Database name of selected tab
	If IsArray($hLVItems) Then ;delete the array and elements
		For $nCount=0 To UBound($hLVItems)-1
			GUICtrlDelete($hLVItems[$nCount][0])
		Next
		$hLVItems=0
	EndIf
	_PopulateListView($sTemp)
EndFunc ;=> _TabUpdate

Func _PrintQAHoldTag($arResult)
	Local $hPrntExprt=_ShowExportingSplashScreen()
	Local $s1,$s2,$s3, $s4, $s5, $s6
	If StringLen($arResult[13]) > 16 Then
		$s1=StringLeft($arResult[13],16)
		$arResult[13]=StringReplace($arResult[13],$s1,'')
		If StringLen($arResult[13]) > 16 Then
			$s2=StringLeft($arResult[13],16)
			$s3=StringReplace($arResult[13],$s2,'')
		Else
			$s2=$arResult[13]
			$s3=''
		EndIf
	Else
		$s1=$arResult[13]
		$s2=''
		$s3=''
	EndIf
	
	If StringLen($arResult[19]) > 16 Then
		$s4=StringLeft($arResult[19],16)
		$arResult[13]=StringReplace($arResult[19],$s4,'')
		If StringLen($arResult[19]) > 16 Then
			$s5=StringLeft($arResult[19],16)
			$s6=StringReplace($arResult[19],$s5,'')
		Else
			$s5=$arResult[19]
			$s6=''
		EndIf
	Else
		$s4=$arResult[19]
		$s5=''
		$s6=''
	EndIf
	
	Local $sOrigDate=$arResult[2]
	$sDate=StringLeft($sOrigDate,4)
	$sOrigDate=StringReplace($sOrigDate,$sDate,'')
	$sDate=StringLeft($sOrigDate,2)&'/'&StringRight($sOrigDate,2)&'/'&$sDate
	Local $oPrintSheet=_CreatePrintTag()
	_ExcelWriteCell($oPrintSheet,'#'&$arResult[0],"G1")			;Hold Number
	_ExcelWriteCell($oPrintSheet,$arResult[1],"B9")				;Defect Description
	_ExcelWriteCell($oPrintSheet,$sDate,"B3")					;Date Entered
	_ExcelWriteCell($oPrintSheet,$arResult[3],"F8")				;QC Tech
	_ExcelWriteCell($oPrintSheet,$arResult[4],"F3")				;Machine
	_ExcelWriteCell($oPrintSheet,$arResult[5],"B4")				;Supplier
	_ExcelWriteCell($oPrintSheet,$arResult[6],"B5")				;Customer
	_ExcelWriteCell($oPrintSheet,$arResult[7],"B6")				;Product Name
	_ExcelWriteCell($oPrintSheet,$arResult[8],"B7")				;Customer Order Nubmer
	_ExcelWriteCell($oPrintSheet,$arResult[18],"B8")			;Customer PO Number
	_ExcelWriteCell($oPrintSheet,$arResult[10],"F6")			;Lot Number
	_ExcelWriteCell($oPrintSheet,$arResult[11],"F7")			;Quantity
	_ExcelWriteCell($oPrintSheet,$arResult[12],"G7")			;Units
	_ExcelWriteCell($oPrintSheet,$s1,"E10")
	_ExcelWriteCell($oPrintSheet,$s2,"E11")
	_ExcelWriteCell($oPrintSheet,$s3,"E12")
	_ExcelWriteCell($oPrintSheet,$s4,"g10")
	_ExcelWriteCell($oPrintSheet,$s5,"g11")
	_ExcelWriteCell($oPrintSheet,$s6,"g12")
	_ExcelWriteCell($oPrintSheet,$arResult[15],"B10")			;Immediate Action

	If @Compiled Then
		$oPrintSheet.ActiveSheet.PrintOut(Default, Default, 1, False, $oPrintSheet.ActivePrinter, FALSE, FALSE, "")
	EndIf
	
	_ExcelBookClose($oPrintSheet,0)
	$nTemp=WinWaitActive("Microsoft Excel","",5)
	If NOT $nTemp Then
		_CenteredMsg("Print Failed", "The QA Hold Tag failed to print.", "&Okay")
	Else
		If @Compiled Then
			ControlClick("Microsoft Excel","&No",'[CLASS:Button; INSTANCE:2]')
			_CenteredMsg("Print", "The QA Hold Tag #"&$arResult[0]&" was printed.", "&Okay")
		Else
			_CenteredMsg("Print", "Script not compiled.", "&Okay")
		EndIf
	EndIf
	
	GUISetState(@SW_ENABLE,$hMain)
	GUIDelete($hPrntExprt)
EndFunc ;=> _PrintQAHoldTag

Func _WriteReportData($oExcelSheet, $arData)
	;header data
	Local $nRow, $nColor
	_ExcelWriteCell($oExcelSheet, "'Ampac Floeter - Quarantine Report" ,1,1)
	_ExcelFontSetProperties($oExcelSheet, 1, 1, 1, 1, True) ; bold
	_ExcelFontSetSize($oExcelSheet, 1, 1, 1, 1, 16)
	Local $sTemp = 'Date Printed: '&@MON&'/'&@MDAY&'/'&@YEAR
	;_ExcelWriteCell($oExcelSheet, $sTemp, 1, 11)
	;_ExcelHorizontalAlignSet($oExcelSheet, 1, 11, 1, 11, "right")
	;_ExcelVerticalAlignSet($oExcelSheet, 1, 11, 1, 11, "center")
	
	_ExcelWriteCell($oExcelSheet, $sTemp, 1, 14)
	_ExcelHorizontalAlignSet($oExcelSheet, 1, 14, 1, 14, "right")
	_ExcelVerticalAlignSet($oExcelSheet, 1, 14, 1, 14, "center")
	
	_ExcelWriteCell($oExcelSheet, "'Date Generated",6,1)
	_ExcelColWidthSet($oExcelSheet, 1, 9.71)
	_ExcelWriteCell($oExcelSheet, "'Customer Order No.",6,2)
	_ExcelColWidthSet($oExcelSheet, 2, 9.43)
_ExcelWriteCell($oExcelSheet,"'Customer PO No.",6,3)
_ExcelColWidthSet($oExcelSheet,3,9.43)
	_ExcelWriteCell($oExcelSheet, "'QA Hold Number",6,4)
	_ExcelWriteCell($oExcelSheet, "'Defect Description",6,5)
	_ExcelColWidthSet($oExcelSheet, 5, 32.29)
	_ExcelWriteCell($oExcelSheet, "'Quantity",6,6)
	$oExcelSheet.ActiveSheet.Range("F6:G6").Merge
_ExcelWriteCell($oExcelSheet,"'Affected Rolls",6,8)
_ExcelColWidthSet($oExcelSheet,8,20)
_ExcelWriteCell($oExcelSheet,"'Affected Boxes",6,9)
_ExcelColWidthSet($oExcelSheet,9,20)
	_ExcelWriteCell($oExcelSheet, "'Ampac Lot No.",6,10)
	_ExcelWriteCell($oExcelSheet, "'Ampac Skid No.",6,11)
	_ExcelWriteCell($oExcelSheet, "'Product Name",6,12)
	_ExcelColWidthSet($oExcelSheet, 12, 30)
	_ExcelWriteCell($oExcelSheet, "'Notes",6,13)
	_ExcelColWidthSet($oExcelSheet, 13, 30)
	_ExcelWriteCell($oExcelSheet,"'Status",6,14)
	_ExcelColWidthSet($oExcelSheet,14,6)
	
	_ExcelHorizontalAlignSet($oExcelSheet, 6, 1, 6, 14, "center")
	_ExcelVerticalAlignSet($oExcelSheet, 6, 1, 6, 14, "center")
	_ExcelRowHeightSet($oExcelSheet, 6, 26.25)
	_ExcelCellFormat($oExcelSheet, 6, 1, 6, 14, True)
	_ExcelCellColorSet($oExcelSheet, 6, 1, 6, 14, 37)
	
	_ExcelWriteCell($oExcelSheet, "'- Rework Internally","B2")
	_ExcelWriteCell($oExcelSheet, "'- Rework Externally","B3")
	_ExcelWriteCell($oExcelSheet, "'- Release","B4")
	_ExcelWriteCell($oExcelSheet, "'- Waste","E2")
	_ExcelWriteCell($oExcelSheet, "'- Return of Material","E3")
	_ExcelCellColorSet($oExcelSheet, 2, 1, 2, 1, 38)
	_ExcelCellColorSet($oExcelSheet, 3, 1, 3, 1, 40)
	_ExcelCellColorSet($oExcelSheet, 4, 1, 4, 1, 36)
	_ExcelCellColorSet($oExcelSheet, 2, 4, 2, 4, 35)
	_ExcelCellColorSet($oExcelSheet, 3, 4, 3, 4, 34)
	
	;write data
	For $nCount=1 to Ubound($arData)-1
		$nRow=$nCount+6		
		Local $sDate=StringLeft($arData[$nCount][2],4)
		$arData[$nCount][2]=StringReplace($arData[$nCount][2],$sDate,'')
		$sDate=StringLeft($arData[$nCount][2],2)&'/'&StringRight($arData[$nCount][2],2)&'/'&$sDate
		_ExcelWriteCell($oExcelSheet,$sDate,$nRow,1)					; date
		_ExcelWriteCell($oExcelSheet,$arData[$nCount][8],$nRow,2)		; customer order
		_ExcelWriteCell($oExcelSheet,$arData[$nCount][18],$nRow,3)		; customer PO number
		_ExcelWriteCell($oExcelSheet,"'"&$arData[$nCount][0],$nRow,4)	; QA Hold
		_ExcelWriteCell($oExcelSheet,$arData[$nCount][1],$nRow,5)		; Defect Description
		_ExcelWriteCell($oExcelSheet,$arData[$nCount][11],$nRow,6)		; Quantity
		_ExcelWriteCell($oExcelSheet,$arData[$nCount][12],$nRow,7)		; Quantity Units
		_ExcelWriteCell($oExcelSheet,$arData[$nCount][13],$nRow,8)		; Affected Rolls (Disposition)
		_ExcelWriteCell($oExcelSheet,$arData[$nCount][19],$nRow,9)		; Affected Boxes
		_ExcelWriteCell($oExcelSheet,$arData[$nCount][10],$nRow,10)		; Ampac Lot
		_ExcelWriteCell($oExcelSheet,$arData[$nCount][9],$nRow,11)		; Ampac Skid
		_ExcelWriteCell($oExcelSheet,$arData[$nCount][7],$nRow,12)		; Product Name
		_ExcelWriteCell($oExcelSheet,$arData[$nCount][17],$nRow,13)		; Notes
		_ExcelWriteCell($oExcelSheet,$arData[$nCount][14],$nRow,14)		; Status
		
		;add color based on disposition
		If $arData[$nCount][16] <> "None" Then
			Switch $arData[$nCount][16]
				Case "Rework Internally"
					$nColor=38 ;rose
				Case "Rework Externally"
					$nColor=40 ;tan
				Case "Release"
					$nColor=36 ;light yellow
				Case "Waste"
					$nColor=35 ;light green
				Case "Return of Material"
					$nColor=34 ;light turquoise
			EndSwitch
			_ExcelCellColorSet($oExcelSheet, $nRow, 1, $nRow, 11, $nColor)
		EndIf
	Next
	
	;draw borders, align cells
	_ExcelHorizontalAlignSet($oExcelSheet, 7, 1, $nRow, 4, "center")
	_ExcelHorizontalAlignSet($oExcelSheet, 7, 6, $nRow, 6, "right")
	_ExcelHorizontalAlignSet($oExcelSheet, 7, 10, $nRow, 11, "center")
	_ExcelCreateBorders($oExcelSheet,$xlThin,7,1,$nRow,5,1,1,1,1,1,1)
	_ExcelCreateBorders($oExcelSheet,$xlThin,7,8,$nRow,14,1,1,1,1,1,1)
	_ExcelCreateBorders($oExcelSheet,$xlThin,7,6,$nRow,7,1,1,1,1,0,1)
	;header borders
	_ExcelCreateBorders($oExcelSheet, $xlThin, 2, 1, 4, 1, 1, 1, 1, 1,0,1)		;"A2:A4"
	_ExcelCreateBorders($oExcelSheet, $xlThin, 2, 4, 3, 4, 1, 1, 1, 1,0,1)		;"D2:D3"
	_ExcelCreateBorders($oExcelSheet, $xlThin, 6, 1, 6, 14, 1, 1, 1, 1, 1, 1)	;"A6:J6"
	_ExcelCreateDoubleBorders($oExcelSheet, 6, 1, 6, 14, 0, 0, 1, 0)			;"A6:J6"
	
	;change Affected Rolls, Affect Boxes, and Notes columns to wordwrap
	With $oExcelSheet.Range("H:H")
		.WrapText = True
	EndWith
	With $oExcelSheet.Range("I:I")
		.WrapText = True
	EndWith
	With $oExcelSheet.Range("M:M")
		.WrapText = True
	EndWith
	With $oExcelSheet.Range("L:L")
		.WrapText = True
	EndWith
	_ExcelVerticalAlignSet($oExcelSheet,7,1,$nRow,14,"center")
	
	;change margins, orientation and size for priting
	With $oExcelSheet.ActiveSheet.PageSetup
		.LeftMargin = 24
        .RightMargin = 24
        .TopMargin = 36
        .BottomMargin = 36
		.Orientation = 2 ;xlLandscape
		.Zoom = 61
	EndWith
	$oExcelSheet.ActiveWindow.Zoom=80
	
	
#cs
	_ExcelWriteCell($oExcelSheet, "'QA Hold Number",6,3)
	_ExcelWriteCell($oExcelSheet, "'Defect Description",6,4)
	_ExcelColWidthSet($oExcelSheet, 4, 32.29)
	_ExcelWriteCell($oExcelSheet, "'Quantity",6,5)
	;_ExcelCellMerge($oExcelSheet, True, 3, 5, 3, 6) ; not working?
	;_ExcelCellMerge($oExcelSheet,True,"E3:F3") ; not working?
	$oExcelSheet.ActiveSheet.Range("E6:F6").Merge
	_ExcelWriteCell($oExcelSheet, "'Ampac Lot No.",6,7)
	_ExcelWriteCell($oExcelSheet, "'Ampac Skid No.",6,8)
	_ExcelWriteCell($oExcelSheet, "'Product Name",6,9)
	_ExcelColWidthSet($oExcelSheet, 9, 39.86)
	_ExcelWriteCell($oExcelSheet, "'Notes",6,10)
	_ExcelColWidthSet($oExcelSheet, 10, 41)
	_ExcelWriteCell($oExcelSheet,"'Status",6,11)
	_ExcelColWidthSet($oExcelSheet,11,6)
	_ExcelHorizontalAlignSet($oExcelSheet, 6, 1, 6, 11, "center")
	_ExcelVerticalAlignSet($oExcelSheet, 6, 1, 6, 11, "center")
	_ExcelRowHeightSet($oExcelSheet, 6, 26.25)
	_ExcelCellFormat($oExcelSheet, 6, 1, 6, 11, True)
	_ExcelCellColorSet($oExcelSheet, 6, 1, 6, 11, 37)
	
	_ExcelWriteCell($oExcelSheet, "'- Rework Internally","B2")
	_ExcelWriteCell($oExcelSheet, "'- Rework Externally","B3")
	_ExcelWriteCell($oExcelSheet, "'- Release","B4")
	_ExcelWriteCell($oExcelSheet, "'- Waste","F2")
	_ExcelWriteCell($oExcelSheet, "'- Return of Material","F3")
	_ExcelCellColorSet($oExcelSheet, 2, 1, 2, 1, 38)
	_ExcelCellColorSet($oExcelSheet, 3, 1, 3, 1, 40)
	_ExcelCellColorSet($oExcelSheet, 4, 1, 4, 1, 36)
	_ExcelCellColorSet($oExcelSheet, 2, 5, 2, 5, 35)
	_ExcelCellColorSet($oExcelSheet, 3, 5, 3, 5, 34)
	
	;write data
	For $nCount=1 to Ubound($arData)-1
		$nRow=$nCount+6		
		Local $sDate=StringLeft($arData[$nCount][2],4)
		$arData[$nCount][2]=StringReplace($arData[$nCount][2],$sDate,'')
		$sDate=StringLeft($arData[$nCount][2],2)&'/'&StringRight($arData[$nCount][2],2)&'/'&$sDate
		_ExcelWriteCell($oExcelSheet,$sDate,$nRow,1)					; date
		_ExcelWriteCell($oExcelSheet,$arData[$nCount][8],$nRow,2)		; customer order
		_ExcelWriteCell($oExcelSheet,"'"&$arData[$nCount][0],$nRow,3)	; QA Hold
		_ExcelWriteCell($oExcelSheet,$arData[$nCount][1],$nRow,4)		; Defect Description
		_ExcelWriteCell($oExcelSheet,$arData[$nCount][11],$nRow,5)		; Quantity
		_ExcelWriteCell($oExcelSheet,$arData[$nCount][12],$nRow,6)		; Quantity Units
		_ExcelWriteCell($oExcelSheet,$arData[$nCount][10],$nRow,7)		; Ampac Lot
		_ExcelWriteCell($oExcelSheet,$arData[$nCount][9],$nRow,8)		; Ampac Skid
		_ExcelWriteCell($oExcelSheet,$arData[$nCount][7],$nRow,9)		; Product Name
		_ExcelWriteCell($oExcelSheet,$arData[$nCount][17],$nRow,10)		; Notes
		_ExcelWriteCell($oExcelSheet,$arData[$nCount][14],$nRow,11)			; Status
			
		;add color based on disposition
		If $arData[$nCount][16] <> "None" Then
			Switch $arData[$nCount][16]
				Case "Rework Internally"
					$nColor=38 ;rose
				Case "Rework Externally"
					$nColor=40 ;tan
				Case "Release"
					$nColor=36 ;light yellow
				Case "Waste"
					$nColor=35 ;light green
				Case "Return of Material"
					$nColor=34 ;light turquoise
			EndSwitch
			_ExcelCellColorSet($oExcelSheet, $nRow, 1, $nRow, 11, $nColor)
		EndIf
	Next
	
	;draw borders, align cells
	_ExcelHorizontalAlignSet($oExcelSheet, 7, 1, $nRow, 3, "center")
	_ExcelHorizontalAlignSet($oExcelSheet, 7, 5, $nRow, 5, "right")
	_ExcelHorizontalAlignSet($oExcelSheet, 7, 7, $nRow, 8, "center")
	_ExcelCreateBorders($oExcelSheet,$xlThin,7,1,$nRow,4,1,1,1,1,1,1)
	_ExcelCreateBorders($oExcelSheet,$xlThin,7,7,$nRow,11,1,1,1,1,1,1)
	_ExcelCreateBorders($oExcelSheet,$xlThin,7,5,$nRow,6,1,1,1,1,0,1)
	;header borders
	_ExcelCreateBorders($oExcelSheet, $xlThin, 2, 1, 4, 1, 1, 1, 1, 1,0,1)		;"A2:A4"
	_ExcelCreateBorders($oExcelSheet, $xlThin, 2, 5, 3, 5, 1, 1, 1, 1,0,1)		;"E2:E3"
	_ExcelCreateBorders($oExcelSheet, $xlThin, 6, 1, 6, 11, 1, 1, 1, 1, 1, 1)	;"A6:J6"
	_ExcelCreateDoubleBorders($oExcelSheet, 6, 1, 6, 11, 0, 0, 1, 0)			;"A6:J6"
	
	;change margins, orientation and size for priting
	$oExcelSheet.ActiveWindow.Zoom=85
	With $oExcelSheet.ActiveSheet.PageSetup
		.LeftMargin = 24
        .RightMargin = 24
        .TopMargin = 36
        .BottomMargin = 36
		.Orientation = 2 ;xlLandscape
		.Zoom = 71
	EndWith
#ce
EndFunc ;=>WriteReportData

Func _EditSelected()
	Local $arText, $sDate, $arSelected, $sValues
	Dim $arEditControls[21]
	$bDoubleClicked=False
	Local $nCount=1
	$arSelected=_GetQAHoldSelected(_GUICtrlListView_GetSelectedIndices($hListView, True))
	Local $sFDetNum=$arSelected[$nCount]
	_SQLite_QuerySingleRow($hFile,"SELECT * FROM Data WHERE QA_Hold_Number = '"&$sFDetNum&"';",$arResult)

	;Label Text
	$arText=0
	$arText=IniReadSection($MY_INI,"NewRecord")
	If NOT IsArray($arText) Then
		MsgBox(0,"INI Corrupt","The INI file is corrupt."&@CRLF&"Error Code: 20")
		Exit
	EndIf

	GUISetState(@SW_DISABLE,$hMain)
	
	Local $hEditRecord = GUICreate("Edit QA Hold - "&$sFDetNum, 633, 447, ($MY_SCREENWIDTH-633)/2, ($MY_SCREENHEIGHT-447)/2)
	GUISetBkColor(0xFFFFFF)
	Local $LabelStart=GUICtrlCreateLabel($arText[1][1]&":", 16, 8, 297, 17) ;supplier
	GUICtrlSetColor(-1, 0xff0000)
	GUICtrlSetFont(-1,12,600)
	GUICtrlCreateLabel($arText[2][1]&":", 16, 48, 153, 17) ;customer
	GUICtrlCreateLabel($arText[3][1]&":", 16, 96, 129, 17)	;product name
	GUICtrlCreateLabel($arText[4][1]&":", 184, 96, 153, 17)	;customer
	GUICtrlCreateLabel($arText[19][1]&":", 344, 8, 257, 17)	;date entered
	GUICtrlCreateLabel($arText[6][1]&":", 344, 48, 257, 17)	;description
	GUICtrlCreateLabel($arText[7][1]&":", 344, 144, 257, 17)	;quantity
	GUICtrlCreateLabel($arText[8][1]&":", 16, 144, 127, 17)	;order number
	GUICtrlCreateLabel("Customer PO Number:",176,144,137,17)
	GUICtrlCreateLabel($arText[9][1]&":", 16, 192, 137, 17) ;skid number
	GUICtrlCreateLabel($arText[10][1]&":", 176, 192, 137, 17) ;lot number
	GUICtrlCreateLabel($arText[11][1]&":", 344, 96, 137, 17) ;machine number
	;GUICtrlCreateLabel($arText[12][1]&":", 344, 192, 265, 17) ;affect quanities
	GUICtrlCreateLabel("Affected Rolls:", 344, 192, 130, 17) 
	GUICtrlCreateLabel("Affected Boxes:", 479, 192, 130, 17) 
	$arEditControls[18] = GUICtrlCreateLabel($arText[13][1]&" : ", 16, 240, 297, 17) ;qctech
	$arEditControls[1] = GUICtrlCreateLabel("Date", 344, 24, 257, 17)
	GUICtrlCreateLabel($arText[16][1]&":", 16, 264, 297, 17) ;immediate action
	GUICtrlSetColor(-1, 0xff0000)
	GUICtrlCreateLabel($arText[17][1]&":", 16, 312, 297, 17) ;disposition
	GUICtrlSetColor(-1, 0xff0000)
	Local $LabelEnd=GUICtrlCreateLabel($arText[18][1]&":", 16, 360, 297, 17) ;comments
	GUICtrlSetColor(-1, 0xff0000)
	Local $BEnter = GUICtrlCreateButton($arText[20][1], 520, 376, 89, 25, 0)
	Local $BExit = GUICtrlCreateButton($arText[15][1], 520, 408, 89, 25, 0)
	
	For $i=$LabelStart To $LabelEnd
		GUICtrlSetBkColor($i,$GUI_BKCOLOR_TRANSPARENT)
	Next
	
	GUICtrlCreateGroup("Status", 344, 320, 105, 81)
		GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
		$arEditControls[16] = GUICtrlCreateRadio("Open", 352, 344, 90, 17)
		GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
		$arEditControls[17] = GUICtrlCreateRadio("Closed", 352, 368, 90, 17)
		GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	$arEditControls[0] = GUICtrlCreateLabel("#", 16, 24, 110, 17)
	GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0xff0000)
	GUICtrlSetFont(-1,12,600)
	$arEditControls[2] = GUICtrlCreateCombo($arSuppliers[2][1], 16, 64, 297, 25, $CBS_DROPDOWNLIST)
		GUICtrlSetData(-1,$sSupplier,$arResult[5])
	$arEditControls[3] = GUICtrlCreateCombo("--", 344, 64, 257, 25, $CBS_DROPDOWNLIST)
		GUICtrlSetData(-1,$sDefects,$arResult[1])
	$arEditControls[4] = GUICtrlCreateInput("ICustomer", 16, 112, 153, 21)
	$arEditControls[19]= GUICtrlCreateInput("ICustPO", 176,160,137,21)
	$arEditControls[5] = GUICtrlCreateInput("IProduct", 184, 112, 129, 21)
	$arEditControls[6] = GUICtrlCreateInput("IProdOrder", 16, 160, 121, 21)
	$arEditControls[7] = GUICtrlCreateInput("IMachine", 344, 112, 137, 21)
	$arEditControls[8] = GUICtrlCreateInput("IResult", 344, 160, 137, 21)
	$arEditControls[9] = GUICtrlCreateCombo("Pouches", 496, 160, 105, 25, $CBS_DROPDOWNLIST)
		GUICtrlSetData(-1,'Pounds|Meters',$arResult[12])
	$arEditControls[10] = GUICtrlCreateInput("ISkidNo", 16, 208, 137, 21)
	$arEditControls[11] = GUICtrlCreateInput("ILotNo", 176, 208, 137, 21)
	;$arEditControls[12] = GUICtrlCreateEdit("", 344, 208, 265, 97,BitOr($WS_VSCROLL,$ES_MULTILINE)) ;affected boxes / rolls
	$arEditControls[12] = GUICtrlCreateEdit("", 344, 208, 130, 97,BitOr($WS_VSCROLL,$ES_MULTILINE)) ;affected rolls
	$arEditControls[20] = GUICtrlCreateEdit("", 479, 208, 130, 97,BitOr($WS_VSCROLL,$ES_MULTILINE)) ;affected boxes
	$arEditControls[13] = GUICtrlCreateCombo("None", 16, 280, 297, 25, $CBS_DROPDOWNLIST)
		GUICtrlSetData(-1, "Release|Controlled Release|Waste|Quarantine",$arResult[15])
	$arEditControls[14] = GUICtrlCreateCombo("None", 16, 328, 297, 25, $CBS_DROPDOWNLIST)
		GUICtrlSetData(-1, "Rework Internally|Rework Externally|Release|Waste|Return of Material",$arResult[16])
	$arEditControls[15] = GUICtrlCreateEdit("", 16, 376, 297, 65,BitOr($WS_VSCROLL,$ES_MULTILINE)) ;notes/comments
;_ArrayDisplay($arResult)
	_UpdateEditData($arResult,$arEditControls)

	GUISetState(@SW_SHOW,$hEditRecord)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $BExit
				ExitLoop
			Case $arEditControls[13]
				If GUICtrlRead($arEditControls[13]) <> "Quarantine" Then
					_GUICtrlComboBox_SetCurSel($arEditControls[14],_GUICtrlComboBox_SelectString($arEditControls[14],"None"))
					GUICtrlSetState($arEditControls[14],$GUI_DISABLE)
				Else
					GUICtrlSetState($arEditControls[14],$GUI_ENABLE)
				EndIf
			Case $BEnter
				$nCount+=1
				;update database
				Local $sStatus
				If GUICtrlRead($arEditControls[16])=$GUI_CHECKED Then
					$sStatus = 'Open'
				Else
					$sStatus = 'Closed'
				EndIf
				$sValues = 	'Defect_Description="' & GUICtrlRead($arEditControls[3]) & '",' & _
							'QCTech="' & StringReplace(GUICtrlRead($arEditControls[18]),'QC TECH : ','') & '",' & _
							'Machine="' & GUICtrlRead($arEditControls[7]) & '",' & _
							'Supplier="' & GUICtrlRead($arEditControls[2]) & '",' & _
							'Customer="' & GUICtrlRead($arEditControls[4]) & '",' & _
							'Product_Name="' & GUICtrlRead($arEditControls[5]) & '",' & _
							'Customer_Order_Number="' & GUICtrlRead($arEditControls[6]) & '",' & _
							'Ampac_Skid_Number="' & GUICtrlRead($arEditControls[10]) & '",' & _
							'Ampac_Lot_Number="' & GUICtrlRead($arEditControls[11]) & '",' & _
							'Quantity="' & GUICtrlRead($arEditControls[8]) & '",' & _
							'Units="' & GUICtrlRead($arEditControls[9]) & '",' & _
							'Disposition="' & GUICtrlRead($arEditControls[12]) & '",' & _
							'Status="' & $sStatus & '",' & _
							'ImmediateAction="' & GUICtrlRead($arEditControls[13]) & '",' & _
							'QADisposition="' & GUICtrlRead($arEditControls[14]) & '",' & _
							'Notes="' & GUICtrlRead($arEditControls[15]) & '",' & _
							'Customer_PO="' & GUICtrlRead($arEditControls[19]) & '",' & _
							'Affected_Boxes="' & GUICtrlRead($arEditControls[20]) & _
							'" WHERE QA_Hold_Number = "' & $arResult[0] & '";'
				_SQLite_Exec($hFile,"UPDATE Data SET "&$sValues)
				
				_TabUpdate()

				$nTemp=_CenteredMsg("Reprint QA Hold Tag","Should QA hold tag "&GUICtrlRead($arEditControls[0])&" be reprinted?","&Yes|No", $hMain)
				If $nTemp=1 Then
					_SQLite_QuerySingleRow($hFile,"SELECT * FROM Data WHERE QA_Hold_Number = '"&$sFDetNum&"';",$arResult)
					_PrintQAHoldTag($arResult)
				EndIf
				
				If $nCount > $arSelected[0] Then 
					ExitLoop
				Else
					;update window
					Local $sOldNumber=$sFDetNum
					$sFDetNum=$arSelected[$nCount]
					_SQLite_QuerySingleRow($hFile,"SELECT * FROM Data WHERE QA_Hold_Number = '"&$sFDetNum&"';",$arResult)				
					_UpdateEditData($arResult,$arEditControls)
					WinSetTitle("Edit QA Hold - "&$sOldNumber,'',"Edit QA Hold - "&$sFDetNum)
				EndIf
		EndSwitch
	WEnd
	
	GUISetState(@SW_ENABLE,$hMain)
	GUIDelete($hEditRecord)
EndFunc ;=>_EditSelected

Func _UpdateEditData($arData, $arControl)
	Local $arTemp=StringSplit(GUICtrlRead($arControl[18]),':')
	Local $sQCTech = $arTemp[1]&': '&$arResult[3]
	Local $sOrigDate=$arResult[2]
	$sDate=StringLeft($sOrigDate,4)
	$sOrigDate=StringReplace($sOrigDate,$sDate,'')
	$sDate=StringLeft($sOrigDate,2)&'/'&StringRight($sOrigDate,2)&'/'&$sDate
	GUICtrlSetData($arControl[0],"#"&$arResult[0])
	GUICtrlSetData($arControl[1],$sDate)
	_GUICtrlComboBox_SetCurSel($arControl[2],_GUICtrlComboBox_SelectString($arControl[2],$arResult[5]))
	_GUICtrlComboBox_SetCurSel($arControl[3],_GUICtrlComboBox_SelectString($arControl[3],$arResult[1]))
	GuiCtrlSetData($arControl[4],$arResult[6])
	GUICtrlSetData($arControl[5],$arResult[7])
	GUICtrlSetData($arControl[6],$arResult[8])
	GUICtrlSetData($arControl[7],$arResult[4])
	GUICtrlSetData($arControl[8],$arResult[11])
	_GUICtrlComboBox_SetCurSel($arControl[9],_GUICtrlComboBox_SelectString($arControl[9],$arResult[12]))
	GUICtrlSetData($arControl[10],$arResult[9])
	GUICtrlSetData($arControl[11],$arResult[10])
	GUICtrlSetData($arControl[12], $arResult[13])
	_GUICtrlComboBox_SetCurSel($arControl[13],_GUICtrlComboBox_SelectString($arControl[13],$arResult[15]))
	_GUICtrlComboBox_SetCurSel($arControl[14],_GUICtrlComboBox_SelectString($arControl[14],$arResult[16]))
	GUICtrlSetData($arControl[15], $arResult[17])
	GUICtrlSetData($arControl[18], $sQCTech)
	GUICtrlSetData($arControl[19], $arResult[18])
	GUICtrlSetData($arControl[20], $arResult[19])

	If $arResult[14] = 'Open' Then
		GUICtrlSetState($arControl[16],$GUI_CHECKED)
	Else
		GUICtrlSetState($arControl[17],$GUI_CHECKED)
	EndIf

	If GUICtrlRead($arControl[13]) <> "Quarantine" Then GUICtrlSetState($arControl[14],$GUI_DISABLE)
EndFunc ;=>_UpdateEditData

Func _ShowExportingSplashScreen()
	Local $hSS=GUICreate("Exporting",200,100,($MY_SCREENWIDTH-200)/2, ($MY_SCREENHEIGHT-100)/2, $WS_DLGFRAME, $WS_EX_TOOLWINDOW)
	Local $LabelSS1=GUICtrlCreateLabel(@CRLF&"Please Wait.",0,0,200,100,$SS_CENTER)
	GUICtrlSetFont(-1,16,800)
	GUISetState(@SW_SHOW,$hSplashScreen)
	GUISetState(@SW_DISABLE,$hMain)
	Return $hSS
EndFunc ;=>_ShowExportingSplashScreen

Func _ExportDatabase($arData, $sSaveName)
	Local $nRow=1, $nCol
	Local $oExcelSheet=_ExcelBookNew(0)
	_ExcelWriteCell($oExcelSheet,"'QA Hold #",$nRow,1)
	_ExcelWriteCell($oExcelSheet,"'Defect Description",$nRow,2)
	_ExcelWriteCell($oExcelSheet,"'Date",$nRow,3)
	_ExcelWriteCell($oExcelSheet,"'QC Tech",$nRow,4)
	_ExcelWriteCell($oExcelSheet,"'Machine #",$nRow,5)
	_ExcelWriteCell($oExcelSheet,"'Supplier",$nRow,6)
	_ExcelWriteCell($oExcelSheet,"'Customer",$nRow,7)
	_ExcelWriteCell($oExcelSheet,"'Product Name",$nRow,8)
	_ExcelWriteCell($oExcelSheet,"'Customer Order #",$nRow,9)
	_ExcelWriteCell($oExcelSheet,"'Ampac Skid #",$nRow,10)
	_ExcelWriteCell($oExcelSheet,"'Ampac Lot #",$nRow,11)
	_ExcelWriteCell($oExcelSheet,"'Quantity",$nRow,12)
	_ExcelWriteCell($oExcelSheet,"'Units",$nRow,13)
	_ExcelWriteCell($oExcelSheet,"'Affected Rolls",$nRow,14)
	_ExcelWriteCell($oExcelSheet,"'Status",$nRow,15)
	_ExcelWriteCell($oExcelSheet,"'Immediate Action",$nRow,16)
	_ExcelWriteCell($oExcelSheet,"'QA Disposition",$nRow,17)
	_ExcelWriteCell($oExcelSheet,"'Notes",$nRow,18)
	_ExcelWriteCell($oExcelSheet,"'Customer PO",$nRow,19)
	_ExcelWriteCell($oExcelSheet,"'Affected Boxes",$nRow,20)
	_ExcelCreateBorders($oExcelSheet, $xlThin, 1, 1, 1, 20, 1, 1, 1, 1, 1, 1)
	_ExcelCreateDoubleBorders($oExcelSheet, 1, 1, 1, 20, 0, 0, 1, 0)
	
	For $nRow=1 To Ubound($arData)-1
		For $nCol = 0 To 19
			_ExcelWriteCell($oExcelSheet,$arData[$nRow][$nCol],$nRow+1,$nCol+1)
		Next
	Next
	
	With $oExcelSheet.ActiveSheet.PageSetup
		.RightFooter = "Date Printed: &D"
	EndWith
	
	_ExcelBookSaveAs($oExcelSheet,$sSaveName)
	_ExcelBookClose($oExcelSheet)
EndFunc ;=>_ExportDatabase

Func _CustomMenu($hWin)
;Func _CustomMenu()
	Local $sSQLite,$iRow,$iCol,$nARPos,$sTemp, $sSDate, $sEDate
	Local $bSQLiteFlag=FALSE, $bANDFlag, $sReturn
	Dim $arResult
	Dim $arRBAll[8][2] ;second column = specific label variable name
	Dim $arRBSpec[8][2] ;second column = database column name
	$arResult=0
	_SQLite_GetTable2d($hFile,"SELECT * FROM Preferences",$arResult,$iRow,$iCol)
	;Read Preferences - custom selections are located at following indices
	;supplier = 4, defect = 5, tech = 6, machine = 7, immediate action = 8, customer = 9, qa description = 10, date = 11, status = 12
	Local $hCustom = GUICreate("Define Custom View", 633, 447, ($MY_SCREENWIDTH-633)/2, ($MY_SCREENHEIGHT-447)/2)
	GUISetBkColor(0xFFFFFF)

	GUICtrlCreateGroup("Supplier", 16, 8, 169, 49)
		$arRBAll[0][0] = GUICtrlCreateRadio("All", 24, 32, 41, 17)
		$arRBSpec[0][0] = GUICtrlCreateRadio("Specific", 88, 32, 89, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$arRBAll[0][1] = "LSSupplier"
	$arRBSpec[0][1] = "Supplier"
	If $arResult[4][1]="All" Then
		GUICtrlSetState($arRBAll[0][0],$GUI_CHECKED)
		$sTemp=''
	Else
		GUICtrlSetState($arRBSpec[0][0],$GUI_CHECKED)
		$sTemp=$arResult[4][1]
	EndIf
	Local $LSSupplier = GUICtrlCreateLabel("Specific Supplier", 16, 64, 168, 49)
	GUICtrlSetData(-1,$sTemp)

	GUICtrlCreateGroup("Defects", 16, 112, 169, 49)
		$arRBAll[1][0] = GUICtrlCreateRadio("All", 24, 136, 41, 17)
		$arRBSpec[1][0] = GUICtrlCreateRadio("Specific", 88, 136, 89, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$arRBAll[1][1]="LSDefects"
	$arRBSpec[1][1]="Defect_Description"
	If $arResult[5][1]="All" Then
		GUICtrlSetState($arRBAll[1][0],$GUI_CHECKED)
		$sTemp=''
	Else
		GUICtrlSetState($arRBSpec[1][0],$GUI_CHECKED)
		$sTemp=$arResult[5][1]
	EndIf
	Local $LSDefects = GUICtrlCreateLabel("Specific Defects", 16, 167, 168, 49)
	GUICtrlSetData(-1,$sTemp)

	GUICtrlCreateGroup("QC Tech", 16, 216, 169, 49)
		$arRBAll[2][0] = GUICtrlCreateRadio("All", 24, 240, 41, 17)
		$arRBSpec[2][0] = GUICtrlCreateRadio("Specific", 88, 240, 89, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$arRBAll[2][1]="LSTech"
	$arRBSpec[2][1]="QCTech"
	If $arResult[6][1]="All" Then
		GUICtrlSetState($arRBAll[2][0],$GUI_CHECKED)
		$sTemp=''
	Else
		GUICtrlSetState($arRBSpec[2][0],$GUI_CHECKED)
		$sTemp=$arResult[6][1]
	EndIf
	Local $LSTech = GUICtrlCreateLabel("Specific Tech", 16, 271, 168, 49)
	GUICtrlSetData(-1,$sTemp)

	GUICtrlCreateGroup("Machine", 232, 8, 169, 49)
		$arRBAll[3][0] = GUICtrlCreateRadio("All", 240, 32, 41, 17)
		$arRBSpec[3][0] = GUICtrlCreateRadio("Specific", 304, 32, 89, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$arRBAll[3][1]="LSMachine"
	$arRBSpec[3][1]="Machine"
	If $arResult[7][1]="All" Then
		GUICtrlSetState($arRBAll[3][0],$GUI_CHECKED)
		$sTemp=''
	Else
		GUICtrlSetState($arRBSpec[3][0],$GUI_CHECKED)
		$sTemp=$arResult[7][1]
	EndIf
	Local $LSMachine = GUICtrlCreateLabel("Specific Machine", 232, 63, 168, 49)
	GUICtrlSetData(-1,$sTemp)

	GUICtrlCreateGroup("Immediate Action", 232, 216, 169, 49)
		$arRBAll[4][0] = GUICtrlCreateRadio("All", 240, 240, 41, 17)
		$arRBSpec[4][0] = GUICtrlCreateRadio("Specific", 304, 240, 89, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$arRBAll[4][1]="LSAction"
	$arRBSpec[4][1]="ImmediateAction"
	If $arResult[8][1]="All" Then
		GUICtrlSetState($arRBAll[4][0],$GUI_CHECKED)
		$sTemp=''
	Else
		GUICtrlSetState($arRBSpec[4][0],$GUI_CHECKED)
		$sTemp=$arResult[8][1]
	EndIf
	Local $LSAction = GUICtrlCreateLabel("Specific Action", 232, 271, 168, 49)
	GUICtrlSetData(-1,$sTemp)

	GUICtrlCreateGroup("Customer", 232, 112, 169, 49)
		$arRBAll[5][0] = GUICtrlCreateRadio("All", 240, 136, 41, 17)
		$arRBSpec[5][0] = GUICtrlCreateRadio("Specific", 304, 136, 89, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$arRBAll[5][1]="LSCustomer"
	$arRBSpec[5][1]="Customer"	
	If $arResult[9][1]="All" Then
		GUICtrlSetState($arRBAll[5][0],$GUI_CHECKED)
		$sTemp=''
	Else
		GUICtrlSetState($arRBSpec[5][0],$GUI_CHECKED)
		$sTemp=$arResult[9][1]
	EndIf
	Local $LSCustomer = GUICtrlCreateLabel("Specific Customer", 232, 167, 168, 49)
	GUICtrlSetData(-1,$sTemp)

	GUICtrlCreateGroup("QA Disposition", 232, 328, 169, 49)
		$arRBAll[6][0] = GUICtrlCreateRadio("All", 240, 352, 41, 17)
		$arRBSpec[6][0] = GUICtrlCreateRadio("Specific", 304, 352, 89, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$arRBAll[6][1]="LSDisposition"
	$arRBSpec[6][1]="QADisposition"	
	If $arResult[10][1]="All" Then
		GUICtrlSetState($arRBAll[6][0],$GUI_CHECKED)
		$sTemp=''
	Else
		GUICtrlSetState($arRBSpec[6][0],$GUI_CHECKED)
		$sTemp=$arResult[10][1]
	EndIf
	Local $LSDisposition = GUICtrlCreateLabel("Specific Disposition", 232, 383, 168, 49)
	GUICtrlSetData(-1,$sTemp)

	GUICtrlCreateGroup("Date", 456, 8, 169, 49)
		$arRBAll[7][0] = GUICtrlCreateRadio("All", 464, 32, 41, 17)
		$arRBSpec[7][0] = GUICtrlCreateRadio("Specific", 528, 32, 89, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$arRBAll[7][1]="LSDate"
	$arRBSpec[7][1]="Date_Entered"
	If $arResult[11][1]="All" Then
		GUICtrlSetState($arRBAll[7][0],$GUI_CHECKED)
		$sTemp=''
	Else
		GUICtrlSetState($arRBSpec[7][0],$GUI_CHECKED)
		$sTemp=StringReplace($arResult[11][1],'|',@CRLF)
	EndIf
	Local $LSDate = GUICtrlCreateLabel("Specific Date", 456, 63, 168, 49)
	GUICtrlSetData(-1,$sTemp)

	GUICtrlCreateGroup("Status", 456, 112, 105, 113)
		Local $RBCSAll = GUICtrlCreateRadio("All", 464, 143, 41, 17)
		Local $RBCSOpen = GUICtrlCreateRadio("Open", 464, 167, 89, 17)
		Local $RBCSClosed = GUICtrlCreateRadio("Closed", 464, 191, 89, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	If $arResult[12][1]="All" Then GUICtrlSetState($RBCSAll,$GUI_CHECKED)
	If $arResult[12][1]="Open" Then GUICtrlSetState($RBCSAll,$GUI_CHECKED)
	If $arResult[12][1]="Closed" Then GUICtrlSetState($RBCSAll,$GUI_CHECKED)

	Local $BCEnter = GUICtrlCreateButton("Enter", 512, 336, 89, 33, 0)
	Local $BCCancel = GUICtrlCreateButton("Cancel", 512, 384, 89, 33, 0)

	GUISetState(@SW_DISABLE,$hWin)
	GUISetState(@SW_SHOW,$hCustom)

	While 1
		$nMsg = GUIGetMsg()
		If _ArraySearch($arRBSpec,$nMsg) >= 0 Then ;if the GUIMessage is in the "Specific" radio button array
			$nARPos=_ArraySearch($arRBSpec,$nMsg)
			$arResult=0
			_SQLite_GetTable2d($hFile,"SELECT * FROM Data",$arResult,$iRow,$iCol)
			If IsArray($arResult) Then
				$sTemp=_GenerateCheckBox($arResult,$iCol,$arRBSpec,GUICtrlRead(Eval($arRBAll[$nARPos][1])),$nARPos,$hCustom)
				If $sTemp <> -1 Then GUICtrlSetData(Eval($arRBAll[$nARPos][1]),$sTemp)
			Else
				GUICtrlSetState($arRBAll[$nARPos][0],$GUI_CHECKED)
				_CenteredMsg("No Data", "There is no data to select from.", "&Okay")
			EndIf
		ElseIf _ArraySearch($arRBAll, $nMsg) >= 0 Then ;if the GUIMessage is in the "All" radio button array
			$nARPos=_ArraySearch($arRBAll,$nMsg)
			GUICtrlSetData(Eval($arRBAll[$nARPos][1]),'') ;delete the specific data in the lable
		Else
			Switch $nMsg
				Case $GUI_EVENT_CLOSE
					$sReturn=-1
					ExitLoop
				Case $BCCancel
					$sReturn=-1
					ExitLoop
				Case $BCEnter
					$sSQLite="SELECT * FROM Data"
					$bSQLiteFlag=FALSE
					;Status
					If GUICtrlRead($RBCSOpen) = $GUI_CHECKED Then 
						$sSQLite &= " WHERE (Status='Open'"
						_SQLite_Exec($hFile,"UPDATE Preferences SET PrefValue='Open' WHERE Pref='Status';")
						$bSQLiteFlag=TRUE
					ElseIf GUICtrlRead($RBCSClosed) = $GUI_CHECKED Then 
						$sSQLite &= " WHERE (Status='Closed'"
						_SQLite_Exec($hFile,"UPDATE Preferences SET PrefValue='Closed' WHERE Pref='Status';")
						$bSQLiteFlag = TRUE
					ElseIf GUICtrlRead($RBCSAll) = $GUI_CHECKED Then
						_SQLite_Exec($hFile,"UPDATE Preferences SET PrefValue='All' WHERE Pref='Status';")
					EndIf
					;Date
					If GUICtrlRead($arRBSpec[7][0]) = $GUI_CHECKED Then
						$sTemp=GUICtrlRead(Eval($arRBAll[7][1])) ;$arRBall[7][1] is the variable name associated with the Specific Date label
						$arTemp=StringSplit($sTemp,@CRLF)
						$sSDate=StringReplace($arTemp[1],"Start Date: ","")
						$sEDate=StringReplace($arTemp[3],"End Date: ","")
						If NOT $bSQLiteFlag Then
							$bSQLiteFlag=TRUE
							$sSQLite &= " WHERE ("
						Else
							$sSQLite &= " AND "
						EndIf
						$sSQLite &= '('&$arRBSpec[7][1]&" BETWEEN '"&$sSDate&"' AND '"&$sEDate&"')"
						$sTemp=StringReplace($sTemp,@CRLF,"|")
						_SQLite_Exec($hFile,"UPDATE Preferences SET PrefValue='"&$sTemp&"' WHERE Pref='Date_Entered';")
					Else
						_SQLite_Exec($hFile,"UPDATE Preferences SET PrefValue='All' WHERE Pref='Date_Entered';")
					EndIf
					;All the rest 0-Supplier, 1-Defect, 2-Tech, 3-Machine, 4-Action, 5-Customer, 6-Dispostion
					For $nCount=0 To 6
						$sTemp=GUICtrlRead(Eval($arRBAll[$nCount][1])) ;$arRBall[X][1] is the variable name associated with the Specific Label
						If $sTemp <> "" Then
							If NOT $bSQLiteFlag Then
								$bSQLiteFlag=TRUE
								$sSQLite &= " WHERE ("
							Else
								$sSQLite &= ") AND " ;and between different categories
							EndIf
							$arTemp=StringSplit($sTemp,',')
							$bANDFlag=TRUE
							$sTemp=''
							For $nPos = 1 To $arTemp[0]
								If $bANDFlag Then
									$sTemp &= '('& $arRBSpec[$nCount][1]&"='"&$arTemp[$nPos]&"'"
									$bANDFlag=FALSE
								Else
									$sTemp &= ' OR '&$arRBSpec[$nCount][1]&"='"&$arTemp[$nPos]&"'" ;or between differnt elements of same category
								EndIf
							Next
							$sSQLite &= $sTemp
							_SQLite_Exec($hFile, "UPDATE Preferences SET PrefValue='"&GUICtrlRead(Eval($arRBAll[$nCount][1]))&"' WHERE Pref='"&$arRBSpec[$nCount][1]&"';")
						Else
							_SQLite_Exec($hFile, "UPDATE Preferences SET PrefValue='All' WHERE Pref='"&$arRBSpec[$nCount][1]&"';")
						EndIf
					Next
					If $bSQLiteFlag Then 
						$sSQLite&='))'
					EndIf
					_SQLite_Exec($hFile,'UPDATE Preferences SET PrefValue="'&$sSQLite&';" WHERE Pref="CustomSQLite";')
					$sReturn=0 ;Success
					ExitLoop
			EndSwitch
		EndIf
	WEnd

GuiSetState(@SW_ENABLE,$hWin)
	GUIDelete($hCustom)
	Return $sReturn

EndFunc ; => _CustomMenu

Func _GenerateCheckBox($arData, $nCol, $arGUI, $sLabel, $nGUIPosition, $hWin) ;sqlite data, columns in sqlite data, array of specific columns, string with value in specific label, index of click, window to disable
	GUISetState(@SW_DISABLE,$hWin)
	Local $nCount,$sHeader='',$nCol2Keep, $nTotalH, $sChecked
	Local $sStartDate, $sEndDate
	Dim $arHeader,$arUnique, $arCheckBox, $arTemp, $arLabel
	;put specific label data into an array
	$arLabel=StringSplit($sLabel,',')
	$arTemp=WinGetPos($hWin)
	;obtain array of header names
	For $nCount=0 To $nCol-1
		$sHeader&=$arData[0][$nCount]
		If $nCount <> $nCol-1 Then $sHeader &="|"
	Next
	$arHeader=StringSplit($sHeader,"|")
	_ArrayDelete($arHeader,0)
	$nCol2Keep=_ArraySearch($arHeader,$arGUI[$nGUIPosition][1]) ;find the column index number of the header data to keep
	;put that column into an array of unique values, i.e. only keep it if it isn't currently found in $arUnique
	For $nCount=1 to Ubound($arData)-1
		If IsArray($arUnique) Then
			If _ArraySearch($arUnique,$arData[$nCount][$nCol2Keep]) < 0 Then
				Local $i=UBound($arUnique)
				ReDim $arUnique[$i+1]
				$arUnique[$i]=$arData[$nCount][$nCol2Keep]
			EndIf
		Else
			Dim $arUnique[1]
			$arUnique[0]=$arData[$nCount][$nCol2Keep]
		EndIf
	Next
	If $arGUI[$nGUIPosition][1] <> "Date_Entered" Then
		;create a GUI of Checkboxes based on the unique values found in the database
		_ArraySort($arUnique)
		Dim $arCheckBox[Ubound($arUnique)]
		$nTotalH=17*(Ubound($arUnique)-1)+30+45+32 ;17 pts per check box+label(at 8 and 17 high and 5 clearance)+Button (25 tall plus 10 clearance each side)+window header
		Local $hCheckBox=GUICreate("Specific Selection",236,$nTotalH,($arTemp[2]-236)/2+$arTemp[0]-3,($arTemp[3]-$nTotalH)/2+$arTemp[1]-16)
		GUICtrlCreateLabel("Please check which values you wish to veiw.",8,8,220,17)
		GUICtrlSetBkColor(-1,0xFFFFFF)
		For $nCount=0 To Ubound($arUnique)-1
			$arCheckBox[$nCount]=GUICtrlCreateCheckbox($arUnique[$nCount],8,($nCount)*17+30,220,17)
			GUICtrlSetBkColor($arCheckBox[$nCount],0xFFFFFF)
			;if the checkbox name is found in the specific lable data the check the checkbox
			If _ArraySearch($arLabel,$arUnique[$nCount]) >= 0 Then GUICtrlSetState($arCheckBox[$nCount],$GUI_CHECKED)
		Next
		Local $hCBCancel=GUICtrlCreateButton("Cancel",32,($nCount)*17+30+10,73,25)
		Local $hCBEnter=GUICtrlCreateButton("Enter",128,($nCount)*17+30+10,73,25)
		;these are dummy controls that show up in the specific date GUI but aren't used in this GUI
		Local $hCBStart=GUICtrlCreateDummy()
		Local $hCBEnd=GUICtrlCreateDummy()
	Else
		;create a GUI to select specific starting and ending dates
		Local $hCheckBox=GUICreate("Date Selection",236,134,($arTemp[2]-236)/2+$arTemp[0]-3,($arTemp[3]-134)/2+$arTemp[1]-16)
		Local $hCBStart = GUICtrlCreateButton("Start Date", 16, 16, 65, 25)
		Local $hCBEnd = GUICtrlCreateButton("End Date", 16, 48, 65, 25)
		Local $hCBLStart = GUICtrlCreateLabel(@MON&'/'&@MDAY&'/'&@YEAR, 88, 22, 200, 17)
		Local $hCBLEnd = GUICtrlCreateLabel(@MON&'/'&@MDAY&'/'&@YEAR, 88, 54, 200, 17)
		Local $hCBCancel = GUICtrlCreateButton("Cancel", 32, 88, 65, 25)
		Local $hCBEnter = GUICtrlCreateButton("Enter", 136, 88, 65, 25)
		;determine starting and ending dates from the specific label information
		If $sLabel="" Then
			$sStartDate=-1
			$sEndDate=-1
		Else
			$arTemp=StringSplit($sLabel,@CRLF)
			$sStartDate=StringReplace($arTemp[1],"Start Date: ","")
			GUICtrlSetData($hCBLStart,$sStartDate)
			$sEndDate=StringReplace($arTemp[3],"End Date: ","")
			GUICTrlSetData($hCBLEnd,$sEndDate)
		EndIf
	EndIf
	GUISetBkColor(0xFFFFFF,$hCheckBox)
	
	GUISetState(@SW_SHOW,$hCheckBox)

	While 1
		$nMsg=GUIGetMsg()
		
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				$sChecked=-1
				ExitLoop
			Case $hCBCancel
				$sChecked=-1
				ExitLoop
			Case $hCBEnter
				If $arGUI[$nGUIPosition][1] <> "Date_Entered" Then
					For $nCount=0 To Ubound($arCheckBox)-1
						If GUICtrlRead($arCheckBox[$nCount]) = $GUI_CHECKED Then
							If $sChecked="" Then 
								$sChecked&=$arUnique[$nCount]
							Else
								$sChecked&=","&$arUnique[$nCount]
							EndIf
						EndIf
					Next
				Else
					$sChecked = "Start Date: "&GUICtrlRead($hCBLStart)&@CRLF&"End Date: "&GUICtrlRead($hCBLEnd)
				EndIf
				ExitLoop
			Case $hCBStart
				If $sStartDate=-1 Then ;if no specific date, then use today
					$sStartDate = _GetDate("Start Date",@YEAR&'/'&@MON&'/'&@MDAY,$hCheckBox)
				Else
					;date for calendar needs to be YYYY/MM/DD
					$arTemp=StringSplit($sStartDate,'/')
					$sStartDate = _GetDate("Start Date",$arTemp[3]&'/'&$arTemp[1]&'/'&$arTemp[2],$hCheckBox)
				EndIf
				If $sStartDate <> -1 Then GUICtrlSetData($hCBLStart,$sStartDate) ;if a new start date is returned update data label
			Case $hCBEnd
				If $sEndDate = -1 Then ;if no specific date, then use today
					$sEndDate = _GetDate("End Date",@YEAR&'/'&@MON&'/'&@MDAY,$hCheckBox)
				Else
					;date for calendar needs to be YYYY/MM/DD
					$arTemp=StringSplit($sEndDate,'/')
					$sEndDate = _GetDate("End Date",$arTemp[3]&'/'&$arTemp[1]&'/'&$arTemp[2],$hCheckBox)
				EndIf
				If $sEndDate <> -1 Then GUICtrlSetData($hCBLEnd,$sEndDate) ;if a new end date is returned update the data label
		EndSwitch
	WEnd
	GUISetState(@SW_ENABLE,$hWin)
	GUIDelete($hCheckBox)
	Return $sChecked
EndFunc ;=> _GenerateCheckBox

Func _GetDate($sTitle, $sStartDate, $hWin)
	Local $arTemp, $sReturn = -1, $nMsg
	$arTemp=WinGetPos($hWin)
	GUISetState(@SW_DISABLE,$hWin)
	Local $hDate=GUICreate($sTitle, 197, 210, ($arTemp[2]-197)/2+$arTemp[0]-3,($arTemp[3]-210)/2+$arTemp[1]-16)
	Local $hCal=GUICtrlCreateMonthCal($sStartDate,10,10)
	Local $BDateEnter = GUICtrlCreateButton("Enter",122,175,65,25)
	Local $BDateCancel = GUICtrlCreateButton("Cancel",10,175,65,25)
	GUISetState(@SW_SHOW,$hDate)
	
	Do
		$nMsg = GUIGetMsg()
		If $nMsg=$hCal Then
			$sReturn = GUICtrlRead($hCal)
			$arTemp = StringSplit($sReturn,'/')
			$sReturn = $arTemp[2]&'/'&$arTemp[3]&'/'&$arTemp[1] ;return MM/DD/YYYY
		EndIf
		If $nMsg=$BDateEnter Then
			If $sReturn = -1 Then $sReturn=@MON&'/'&@MDAY&'/'&@YEAR
			ExitLoop
		EndIf
		If $nMsg=$BDateCancel Then
			$sReturn=-1
			ExitLoop
		EndIf
	Until $nMsg=$GUI_EVENT_CLOSE
	
	GUISetState(@SW_ENABLE,$hWin)
	GUIDelete($hDate)
	Return $sReturn
EndFunc ;=> _GetDate

Func _CreatePrintTag()
	Local $nCount
	Local $oBook=_ExcelBookNew(0)
	Dim $arCol[8] = [7,17.71,9.29,8.86,13,16.14,8.14,16.71] ;column widths A-G
	Dim $arRow[27] = [26,27,12.75,19.5,19.5,19.5,19.5,19.5,39,19.5,19.5,19.5,22.5,26.25,13.5,19.5,7.5,19.5,7.5,19.5,12.75,22.5,7.5,24.75,12.75,21,241.5] ; row heights 1-26
	Dim $arColA[16] = [15,"Date Entered:","Supplier:",'Customer:','Product Name:','Cust. Order Number:','Cust. PO Number:','Description of Defect:','Immediate Action:','Disposition of Quarantined Product:','Rework Internally:','Release:','Return of Material:','Date:','Signature:','Roll Stock Label:']

	;Resize Columns
	For $nCount = 1 To $arCol[0]
		_ExcelColWidthSet($oBook, $nCount, $arCol[$nCount])
	Next
	;Resize Rows
	For $nCount = 1 to $arRow[0]
		_ExcelRowHeightSet($oBook, $nCount, $arRow[$nCount])
	Next
	;set font size
	_ExcelFontSetSize($oBook,1,1,1,1,22)
	_ExcelFontSetSize($oBook,1,7,1,7,22)
	_ExcelFontSetSize($oBook,13,1,13,1,12)
	_ExcelFontSetSize($oBook,26,1,26,7,16)
	_ExcelFontSetColor($oBook,1,1,1,1,3)
	_ExcelFontSetColor($oBook,1,7,1,7,3)
	_ExcelFontSetProperties($oBook, 13, 1, 13, 1, TRUE)
	;set alignment
	_ExcelVerticalAlignSet($oBook, 1, 1, 19, 7, "center")
	_ExcelHorizontalAlignSet($oBook, 1, 7, 1, 7, "right")
	_ExcelVerticalAlignSet($oBook,13,1,13,1,"bottom")
	_ExcelHorizontalAlignSet($oBook, 21, 1, 23, 7, "right")
	_ExcelHorizontalAlignSet($oBook, 8, 6, 8, 6, "center")
	;_ExcelVerticalAlignSet($oBook,1,8,2,8,"top")
	With $oBook.ActiveSheet.Range("A26:G26")
        .HorizontalAlignment = $xlCenter
        .VerticalAlignment = $xlCenter
		.MergeCells = True
	EndWith
	;draw borders
	Local $xlMedium=-4138
	_ExcelCreateBorders($oBook,$xlMedium,8,6,8,6,1,1,1,1)
	For $nCount = 15 To 19 Step 2
		_ExcelCreateBorders($oBook,$xlMedium,$nCount,2,$nCount,2,1,1,1,1)
	Next
	_ExcelCreateBorders($oBook,$xlMedium,15,6,15,6,1,1,1,1)
	_ExcelCreateBorders($oBook,$xlMedium,17,6,17,6,1,1,1,1)
	_ExcelCreateBorders($oBook,$xlThin,12,1,12,7,0,0,1,0)
	_ExcelCreateBorders($oBook,$xlMedium,21,2,21,3,0,0,1,0)
	_ExcelCreateBorders($oBook,$xlMedium,21,5,21,5,0,0,1,0)
	_ExcelCreateBorders($oBook,$xlMedium,21,7,21,7,0,0,1,0)
	_ExcelCreateBorders($oBook,$xlMedium,23,2,23,5,0,0,1,0)
	_ExcelCreateBorders($oBook,$xlMedium,26,1,26,7,1,1,1,1)
	;Write Data
	_ExcelWriteCell($oBook,"QA HOLD TAG",1,1)
	For $nCount = 1 To 8
		_ExcelWriteCell($oBook,$arColA[$nCount],$nCount+2,1)
	Next
	For $nCount = 1 To 7
		_ExcelWriteCell($oBook,$arColA[$nCount+8],($nCount-1)*2+13)
	Next
	_ExcelWriteCell($oBook,'Time:',21,4)
	_ExcelWriteCell($oBook,'Cost:',21,6)
	_ExcelWriteCell($oBook,'Place only one roll stock label here.',26,1)
	_ExcelWriteCell($oBook,'Machine Number:',3,5)
	_ExcelWriteCell($oBook,'Lot Number:',6,5)
	_ExcelWriteCell($oBook,'Defective Quantity:',7,5)
	_ExcelWriteCell($oBook,'QC Tech:',8,5)
	;_ExcelWriteCell($oBook,'Affected Rolls and Boxes:',9,5)
	_ExcelWriteCell($oBook,'Affected Rolls:',9,5)
	_ExcelWriteCell($oBook,'Affected Boxes:',9,7)
	_ExcelWriteCell($oBook,'Rework Externally:',15,5)
	_ExcelWriteCell($oBook,'Waste:',17,5)
	;set margins and print setup
	With $oBook.ActiveSheet.PageSetup
		.RightFooter = "Date Printed: &D"
		.LeftMargin = 43.2
        .RightMargin = 43.2
        .TopMargin = 41.76
        .BottomMargin = 44.64
		.Orientation = 1 ;xlPortrait
		.FitToPagesWide = 1
		.FitToPagesTall = 1
	EndWith
	Return $oBook
EndFunc ;=> _CreatePrintTag
#EndRegion