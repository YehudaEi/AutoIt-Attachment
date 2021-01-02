#include <GuiImageList.au3>
#include <GUIListView.au3>
#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include<Misc.au3>
#include <StaticConstants.au3>
#Include <WinAPI.au3>
#include <GuiMenu.au3>
#include <GuiToolbar.au3>
#include <Constants.au3>
#include <ButtonConstants.au3>
#include <TabConstants.au3>
#include <GuiComboBox.au3>
#Region Initial startup
Global $iItem ; Command identifier of the button associated with the notification.
Global Enum $idNew = 1000, $idOpen, $idSave, $idHelp
Global Enum $id1 = 1000, $id2, $id3, $id4, $id5 ; ID's for each ToolBar button
Global $wStateTop=0,$allbuts,$excludedblclick, $hoveringmenu=0,$time, $lasttime,$alreadyactive=1

HotKeySet("^q","quickview")
$dll = DllOpen("user32.dll")
global $transcolour="0x666666", $countingtest=0

Global $WM_DROPFILES = 0x233, $aStrings[5], $counting=0
Global $gaDropFiles[1], $str = "", $labelled
Global Const $tagSHFILEINFO = "dword hIcon; int iIcon; DWORD dwAttributes; CHAR szDisplayName[255]; CHAR szTypeName[80];"
Global Const $SHGFI_USEFILEATTRIBUTES = 0x10
Global Const $SHGFI_SYSICONINDEX = 0x4000
Global Const $SHGFI_SMALLICON = 0x1
Global Const $SHGFI_LARGEICON = 0x0
Global $listison=0, $hListView1, $deletelater=-1
Global Const $FOLDER_ICON_INDEX = _GUIImageList_GetFileIconIndex(@SystemDir, 0, 1)
Global Const $NOICON_ICON_INDEX = _GUIImageList_GetFileIconIndex("nb lgl", 0, 0)
Global $currenttitle="File Manager", $winhandled
Global $Plusx=290, $Plusy=510,$winshade=0
Opt("GUIOnEventMode", 1)
	Global $nameofwin="File Manager"
	$xcoord=@DesktopWidth-438
	$ycoord=@DesktopHeight-548
	$width=438
Global $GUI_MAIN = GUICreate($nameofwin, $width, 520, $xcoord, $ycoord,$WS_POPUP)
GUISetStyle($WS_EX_ACCEPTFILES -1)
GUISetBkColor($transcolour,$GUI_MAIN)
Global $combobox = GUICtrlCreateCombo("", 256, 495, 180, 36,BitOR($CBS_SORT,$CBS_DROPDOWN))
no_tab()
GuiCtrlSetResizing(-1,'544')
GUICtrlSetFont(-1,11,500,"Arial")

timeupdater()
sysbuttons()
GUICtrlCreateTab(0,0,$width,496,$TCS_FOCUSNEVER)
no_tab()
GuiCtrlSetResizing(-1,'64')
Global $explorer=GUICtrlCreateTabItem("Explorer")
GUICtrlSetFont(-1,11,500,"Arial")
explorergui()
Global $programs=GUICtrlCreateTabItem("Programs")
GUICtrlSetFont(-1,11,500,"Arial")
programsgui()

GUISetOnEvent(-3,"GUI_Close")

AdlibEnable("timeupdater",10000)
_ReduceMemory()
GUISetState(@SW_SHOW)
#EndRegion
While 1
;ToolTip(ControlGetFocus($GUI_MAIN))
    Sleep(100)
	If _IsPressed("0D", $dll) then ;enter
		If ControlGetFocus($GUI_MAIN)="Edit1" Then
		
			$var = IniRead("progressexplorer.ini","files", guictrlread($combobox), "")
			if StringInStr($var,",") Then
				$varo=StringRight($var,StringLen($var)-StringInStr($var,";"))
				$var=StringLeft($var,StringInStr($var,";")-1)
				ShellExecute($var,$varo)
			Else
				ShellExecute($var)
			
			EndIf
			_GUICtrlComboBox_SetCurSel($combobox, 0)
			
	
		elseif $listison=1 and WinActive($nameofwin) Then ;enter pressed
					_GUICtrlListView_ClickItem($hListView1,_GUICtrlListView_GetNextItem($hListView1,-1,0,8),"left",False,2)

		elseIf ControlGetFocus($GUI_MAIN)="Edit2" and WinActive($nameofwin) Then
				$DIRECTORY_LOCAL = GUICtrlRead($inpLocalDirectory)
				_SHLV_PopulateLocalListView($SHELLLISTVIEWHANDLE,$DIRECTORY_LOCAL)

		EndIf
	
	ElseIf _IsPressed("08", $dll) and $listison=1 and WinActive($nameofwin) Then ;backspace pressed
				_GUICtrlListView_ClickItem($hListView1,0,"left",False,2)
	
	ElseIf _IsPressed("1B", $dll) and ControlGetFocus($GUI_MAIN)="Edit1" Then ;esc pressed
		_GUICtrlComboBox_SetCurSel($combobox, 0)
		$alreadyactive=0
	elseIf ControlGetFocus($GUI_MAIN)="Edit1" and $alreadyactive=0 Then
		$alreadyactive=1
		;GUICtrlSetData ($combobox, "")
		_GUICtrlComboBox_SetEditSel($combobox, 0, -1)
	ElseIf not ControlGetFocus($GUI_MAIN)="Edit1" and $alreadyactive=1 then
		_GUICtrlComboBox_SetCurSel($combobox, 0)
		$alreadyactive=0
	EndIf
	
					
			$handl=WinGetHandle($GUI_MAIN,"")
			$hover=GUIGetCursorInfo($handl)
			$hoveredyes=0
			For $j = 1 To $counting
			if $hover[4]=$iconslist[$j][1] then
				$hoveredyes=1
				if $labelison=0 Then
					IF $labelison<>0 then GUICtrlSetData($iconslabel[$labelison],"")
					GUICtrlSetData($iconslabel[$iconslist[$j][2]],$iconslist[$j][0])
					$labelison=$iconslist[$j][2]
					ExitLoop
				ElseIf $labelison>0 and not $hover[4]=$iconslist[$labelison][1] then
					GUICtrlSetData($iconslabel[$labelison],"")
					$labelison=0
				EndIf
				
			EndIf
			Next
			if $hoveredyes=0 and $labelison>0 then
				GUICtrlSetData($iconslabel[$labelison],"")
				$labelison=0
			EndIf

if $countingtest=7 Then
movedecision()
$countingtest=0
Else
$countingtest=1+$countingtest
EndIf
	
	WEnd


Func GUI_Close()
    Exit
EndFunc
#Region Listview functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Listview Functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Prog@ndy
Func _SHLV_PopulateLocalListView($hListView1,ByRef $DIRECTORY_LOCAL)
	
    If $DIRECTORY_LOCAL = "" Then
        Local $drives = DriveGetDrive("ALL")
        GUICtrlSetData($inpLocalDirectory, "Drive Selection")
        _GUICtrlListView_BeginUpdate($hListView1)
        _GUICtrlListView_DeleteAllItems($hListView1)
        For $i = 1 To $drives[0]
            _GUICtrlListView_AddItem($hListView1, StringUpper($drives[$i]) & "\", _GUIImageList_GetFileIconIndex($drives[$i] & "\"))
        Next
        _GUICtrlListView_EndUpdate($hListView1)
        Return
    EndIf
    If StringRight($DIRECTORY_LOCAL, 1) <> "\" Then $DIRECTORY_LOCAL &= "\"
  ;  If DriveStatus(StringLeft($DIRECTORY_LOCAL, 3)) <> "READY" Then Return 0 * MsgBox(16 + 8192, 'Error on Drive Access', "Drive " & StringLeft($DIRECTORY_LOCAL, 3) & " not ready!")
    GUICtrlSetData($inpLocalDirectory, $DIRECTORY_LOCAL)
    $files = _SHLV__FileListToArray2($DIRECTORY_LOCAL, "*.*", 2)
    If UBound($files)==0 Then Return
    _GUICtrlListView_BeginUpdate($hListView1)
    _GUICtrlListView_DeleteAllItems($hListView1)
    _GUICtrlListView_SetItemCount($hListView1,$files[0])
    _GUICtrlListView_AddItem($hListView1, "[..]", 1)
    If IsArray($files) Then
        For $i = 1 To $files[0]
            $item = _GUICtrlListView_AddItem($hListView1, $files[$i], $FOLDER_ICON_INDEX)
        Next
    EndIf
    Local $foldercount
    $files = _SHLV__FileListToArray2($DIRECTORY_LOCAL, "*.*", 1)
    _GUICtrlListView_EndUpdate($hListView1)
    _GUICtrlListView_BeginUpdate($hListView1)
    _GUICtrlListView_SetItemCount($hListView1,$files[0]+$foldercount)
    If IsArray($files) Then
        For $i = 1 To $files[0]
			$item = _GUICtrlListView_AddItem($hListView1, $files[$i], _GUIImageList_GetFileIconIndex($DIRECTORY_LOCAL & $files[$i],0,0))
           ; $item = _GUICtrlListView_AddItem($hListView1, $files[$i], _GUIImageList_GetFileIconIndex($files[$i]))
            _GUICtrlListView_AddSubItem($hListView1, $item, __SHLV_FileDateString2Calc(FileGetTime($DIRECTORY_LOCAL & $files[$i], 0, 1)), 1)
        Next
    EndIf
    _GUICtrlListView_EndUpdate($hListView1)
EndFunc   ;==>_SHLV_PopulateLocalListView

; Prog@ndy
Func _GUIImageList_GetSystemImageList($bLargeIcons = False)
    Local $dwFlags, $hIml, $FileInfo = DllStructCreate($tagSHFILEINFO)
    $dwFlags = BitOR($SHGFI_USEFILEATTRIBUTES, $SHGFI_SYSICONINDEX)
    If Not ($bLargeIcons) Then
        $dwFlags = BitOR($dwFlags, $SHGFI_SMALLICON)
    EndIf
    $hIml = _WinAPI_SHGetFileInfo(".txt", $FILE_ATTRIBUTE_NORMAL, _
            DllStructGetPtr($FileInfo), DllStructGetSize($FileInfo), $dwFlags)
    Return $hIml
EndFunc   ;==>_GUIImageList_GetSystemImageList

; Prog@ndy
Func _WinAPI_SHGetFileInfo($pszPath, $dwFileAttributes, $psfi, $cbFileInfo, $uFlags)
    Local $return = DllCall("shell32.dll", "DWORD*", "SHGetFileInfo", "str", $pszPath, "DWORD", $dwFileAttributes, "ptr", $psfi, "UINT", $cbFileInfo, "UINT", $uFlags)
    If @error Then Return SetError(@error, 0, 0)
    Return $return[0]
EndFunc   ;==>_WinAPI_SHGetFileInfo

; Prog@ndy
Func _GUIImageList_GetFileIconIndex($sFileSpec, $bLargeIcons = False, $bForceLoadFromDisk = False)
    Local $dwFlags, $FileInfo = DllStructCreate($tagSHFILEINFO)

    $dwFlags = $SHGFI_SYSICONINDEX
    If $bLargeIcons Then
        $dwFlags = BitOR($dwFlags, $SHGFI_LARGEICON)
    Else
        $dwFlags = BitOR($dwFlags, $SHGFI_SMALLICON)
    EndIf
    If Not $bForceLoadFromDisk Then
        $dwFlags = BitOR($dwFlags, $SHGFI_USEFILEATTRIBUTES)
    EndIf
    Local $lR = _WinAPI_SHGetFileInfo( _
            $sFileSpec, $FILE_ATTRIBUTE_NORMAL, DllStructGetPtr($FileInfo), DllStructGetSize($FileInfo), _
            $dwFlags _
            )

    If ($lR = 0) Then
        Return SetError(1, 0, -1)
    Else
        Return DllStructGetData($FileInfo, "iIcon")
    EndIf
EndFunc   ;==>_GUIImageList_GetFileIconIndex

; Author(s):   Prog@ndy
Func __SHLV_FileDateString2Calc($filedate)
    Return StringLeft(StringRegExpReplace($filedate, "(\d{4})(\d{2})(\d{2})", "$1/$2/$3"),10)
EndFunc   ;==>_FileDateString2Calc
; Author(s):   Prog@ndy
Func __SHLV_CalcDate2FileDateString($calcdate)
    Return StringRegExpReplace($calcdate, "(\d{4})/(\d{2})/(\d{2}) (\d{2})sad.gif\d{2})sad.gif\d{2})", "$1$2$3$4$5$6")
EndFunc   ;==>_CalcDate2FileDateString

; Prog@ndy
Func _SHLV_WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
    #forceref $hWnd, $iMsg, $iwParam
    Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $tInfo, $hListView1 = $SHELLLISTVIEWHANDLE

    $tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
    $iCode = DllStructGetData($tNMHDR, "Code")
    Switch $hWndFrom
		
		Case $hListView1
            Switch $iCode
                Case $NM_DBLCLK ; Sent by a list-view control when the user double-clicks an item with the left mouse button
                    $tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
					If _GUICtrlListView_GetItemText($hListView1, DllStructGetData($tInfo, "Index")) = "[..]" Then
                        Local $slash = StringInStr($DIRECTORY_LOCAL, "\", 1, -2)
                        If $slash Then
                            $DIRECTORY_LOCAL = StringLeft($DIRECTORY_LOCAL, $slash)
                        ElseIf StringRegExp($DIRECTORY_LOCAL, "\A[A-Za-z]:\\\Z") Then
                            $DIRECTORY_LOCAL = ""
                        EndIf
                        _SHLV_PopulateLocalListView($hListView1,$DIRECTORY_LOCAL)
					ElseIf _GUICtrlListView_GetItemImage($hListView1, DllStructGetData($tInfo, "Index")) = $FOLDER_ICON_INDEX Then
                        $DIRECTORY_LOCAL &= _GUICtrlListView_GetItemText($hListView1, DllStructGetData($tInfo, "Index"))
                        _SHLV_PopulateLocalListView($hListView1,$DIRECTORY_LOCAL)
					ElseIf StringRegExp(_GUICtrlListView_GetItemText($hListView1, DllStructGetData($tInfo, "Index"), 0), "\A[A-Za-z]:\\\Z") Then
                        $DIRECTORY_LOCAL = _GUICtrlListView_GetItemText($hListView1, DllStructGetData($tInfo, "Index"))
                        _SHLV_PopulateLocalListView($hListView1,$DIRECTORY_LOCAL)

					else
						$extens=StringRight(_GUICtrlListView_GetItemText($hListView1, DllStructGetData($tInfo, "Index")),4)
						if $extens =".au3" Then
							ShellExecute(@AutoItExe,$DIRECTORY_LOCAL&"\"&_GUICtrlListView_GetItemText($hListView1, DllStructGetData($tInfo, "Index")))
						elseif $extens=".mpg" or $extens="mpeg" or $extens=".avi" Then
							ShellExecute("C:\Program Files\VideoLAN\VLC\vlc.exe",""""&$DIRECTORY_LOCAL&"\"&_GUICtrlListView_GetItemText($hListView1, DllStructGetData($tInfo, "Index"))&"""")
						Else
						ShellExecute($DIRECTORY_LOCAL&"\"&_GUICtrlListView_GetItemText($hListView1, DllStructGetData($tInfo, "Index")))
						EndIf
					EndIf
                    ; No return value
				Case $NM_KILLFOCUS
					$listison=0
					HotKeySet("^c")
					HotKeySet("^x")
					HotKeySet("^v")
					HotKeySet("{del}")
					Opt("GUIOnEventMode", 1)
				Case $NM_SETFOCUS ; The control has received the input focus
					HotKeySet("^c","copy")
					HotKeySet("^x","cut")
					HotKeySet("^v","paste")
					HotKeySet("{del}","delete")
					$listison=1
					Opt("GUIOnEventMode", 1)
				;Case $NM_RCLICK
				;	

				EndSwitch
		EndSwitch

    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

; Author ........: SolidSnake <MetalGX91 at GMail dot com>
; Modified by Prog@ndy
Func _SHLV__FileListToArray2($sPath, $sFilter = "*", $iFlag = 0)
    Local $hSearch, $sFile, $asFileList
    If Not FileExists($sPath) Then Return SetError(1, 1, "")
    If (StringInStr($sFilter, "\")) Or (StringInStr($sFilter, "/")) Or (StringInStr($sFilter, ":")) Or (StringInStr($sFilter, ">")) Or (StringInStr($sFilter, "<")) Or (StringInStr($sFilter, "|")) Or (StringStripWS($sFilter, 8) = "") Then Return SetError(2, 2, "")
    If Not ($iFlag = 0 Or $iFlag = 1 Or $iFlag = 2) Then Return SetError(3, 3, "")
    If (StringMid($sPath, StringLen($sPath), 1) = "\") Then $sPath = StringTrimRight($sPath, 1) ; needed for Win98 for x:\  root dir
    $hSearch = FileFindFirstFile($sPath & "\" & $sFilter)
    If $hSearch = -1 Then Return SetError(4, 4, "")
    While 1
        $sFile = FileFindNextFile($hSearch)
        If @error Then
            SetError(0)
            ExitLoop
        EndIf
        If $iFlag = 1 And StringInStr(FileGetAttrib($sPath & "\" & $sFile), "D") <> 0 Then ContinueLoop
        If $iFlag = 2 And StringInStr(FileGetAttrib($sPath & "\" & $sFile), "D") = 0 Then ContinueLoop
        $asFileList &= $sFile & @CR
;~   ReDim $asFileList[UBound($asFileList) + 1]
;~   $asFileList[0] = $asFileList[0] + 1
;~   $asFileList[UBound($asFileList) - 1] = $sFile
    WEnd
    FileClose($hSearch)
    Return StringSplit(StringTrimRight($asFileList,1),@CR)
EndFunc   ;==>_SHLV__FileListToArray2
#EndRegion
#region Quickview Cut Paste Delete
func quickview()
if $listison=1 Then
	$filename= _GUICtrlListView_GetItemText($hListView1, _GUICtrlListView_GetNextItem($hListView1,-1,0,8))
				if StringRight($filename,3)="au3" Then
					ShellExecute("C:\Program Files\AutoIt3\SciTE\SciTE.exe", """"&$DIRECTORY_LOCAL & "\" & $filename&"""")
				ElseIf StringRight($filename,3)="hta" or StringRight($filename,3)="vbs" or StringRight($filename,3)="bat" Then
					ShellExecute("c:\windows\system32\notepad.exe", """"&$DIRECTORY_LOCAL & "\" & $filename&"""")
				EndIf
EndIf
EndFunc

func copy()
	if WinActive("File Manager") then 
		$filename= _GUICtrlListView_GetItemText($hListView1, _GUICtrlListView_GetNextItem($hListView1,-1,0,8))
		_ClipPutFile($DIRECTORY_LOCAL & "\" & $filename)
		ToolTip("Copied "&$DIRECTORY_LOCAL & "\" & $filename)
		Sleep(2000)
		ToolTip("")
		$deletelater=0
	EndIf
EndFunc

func cut()
	if WinActive("File Manager") then
		$filename= _GUICtrlListView_GetItemText($hListView1, _GUICtrlListView_GetNextItem($hListView1,-1,0,8))
		_ClipPutFile($DIRECTORY_LOCAL & "\" & $filename)
		ToolTip("Cut "&$DIRECTORY_LOCAL & "\" & $filename)
		Sleep(2000)
		ToolTip("")
		$deletelater=1
	EndIf
EndFunc
func paste()
	if WinActive("File Manager") then
		$filenameclip=ClipGet()
		$moving=FileMove($filenameclip,$DIRECTORY_LOCAL,0)
		if $moving=0 then
			ToolTip("File Already exists....move cancelled")
		
		Else
				ToolTip("Pasted "&$DIRECTORY_LOCAL & "\" & $filename)
		EndIf
			Sleep(2000)
			ToolTip("")
		
		if $deletelater=1 Then
		 FileDelete($filenameclip)
		EndIf
		$filename= _GUICtrlListView_GetItemText($hListView1, _GUICtrlListView_GetNextItem($hListView1,-1,0,8))
		_ClipPutFile($DIRECTORY_LOCAL & "\" & $filename)
		$deletelater=-1
		_GUICtrlListView_DeleteAllItems($hListView1)
		_SHLV_PopulateLocalListView($hListView1,$DIRECTORY_LOCAL)
	EndIf
EndFunc

func delete()
$filename= _GUICtrlListView_GetItemText($hListView1, _GUICtrlListView_GetNextItem($hListView1,-1,0,8))
FileDelete($DIRECTORY_LOCAL & "\" & $filename)
_GUICtrlListView_DeleteAllItems($hListView1)
_SHLV_PopulateLocalListView($hListView1,$DIRECTORY_LOCAL)
EndFunc
#EndRegion
#Region Setting up Controls
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Buttons and Labels and Listview;;;;;;;;;;;;;;;;;;;;;;;;;;;
func explorergui()
	Global $inisource2=IniReadSection("progressexplorer.ini","shortcuts")
	if @error=1 then
		writetheini()
		Global $inisource2=IniReadSection("progressexplorer.ini","shortcuts")
	EndIf
	;_ArraySort($inisource2)

	$downby=45
	dim $allbuts[$inisource2[0][0]+1][3]
	for $i = 1 to $inisource2[0][0]
		$allbuts[$i][0]=GUICtrlCreateRadio($inisource2[$i][0],3,$downby,75,25,BitOr($BS_PUSHLIKE, $BS_LEFT))
		GUICtrlSetBkColor(-1,$transcolour)
		GUICtrlSetOnEvent($allbuts[$i][0],"working")
		GUICtrlSetFont(-1,9,400,"Verdana")
		GuiCtrlSetResizing(-1,'64')
		no_tab()
		$allbuts[$i][1]=$inisource2[$i][1]
		$downby=$downby+25
	Next

	Global $hListView1 = GUICtrlCreateListView("Name|Date", 80, 44, 354, 451,$LVS_NOCOLUMNHEADER)
	GUICtrlSetState (-1, $GUI_DROPACCEPTED)
	GuiCtrlSetResizing(-1,'256')
	GUIctrlSetBkColor(-1,"0x250517")
	GUICtrlSetColor(-1,"0xCCFFFF")
	GUICtrlSetFont(-1,11,500,"Arial")

	Global $SHELLLISTVIEWHANDLE = GUICtrlGetHandle($hListView1) ; Get the Handle

	GUICtrlSendMsg($hListView1, 0x101E, 0, 264)
	GUICtrlSendMsg($hListView1, 0x101E, 1, 85)
	GUIRegisterMsg($WM_NOTIFY, "_SHLV_WM_NOTIFY")
	GUIRegisterMsg ($WM_DROPFILES, "WM_DROPFILES_UNICODE_FUNC")

	_GUICtrlListView_SetImageList($hListView1, _GUIImageList_GetSystemImageList(), 1)
		Global $inpLocalDirectory = GUICtrlCreateInput("", 0, 22, 437, 21,bitor($ES_LEFT,$ES_AUTOHSCROLL))
	GUICtrlSetFont(-1,11,500,"Arial")
	GuiCtrlSetResizing(-1,'64')
	;MsgBox(0,"",$CmdLine[0])
	if $CmdLine[0]=0 then
		Global $DIRECTORY_LOCAL = "" ; Start with Selection of drives smile.gif
	Else
		Global $DIRECTORY_LOCAL = $CmdLine[1]
	EndIf
	_SHLV_PopulateLocalListView($SHELLLISTVIEWHANDLE,$DIRECTORY_LOCAL)
EndFunc
	
func sysbuttons()
;// AXWindow - AutoIt eXperimental Window (7/08/2004)
;// By: 'Josbe' (mrjosbe AT yahoo DOT com)
;// Based in Ideas: CyberSlug, Rednhead (                               )
	GuiSetFont(11,300,0,'Wingdings')
	; ASCII Characters for icons
	$charM="y"
	$charX="x"

	If $wStateTop=0 Then
		$chrSTop='m'
	Else
		$chrSTop='l'
	EndIf
	Global $btnTop=GUICtrlCreateButton($chrSTop,$width-86,0,20,20,$BS_FLAT)
	GuiCtrlSetResizing(-1,'802')
	GUICtrlSetOnEvent($btnTop,"workingbut")
	no_tab()
	GuiCtrlSetTip(-1,'Always on top')
	Global $btnMin=GUICtrlCreateButton('Ú',$width-64,0,20,20,$BS_FLAT)
	GuiCtrlSetResizing(-1,'802')
	GUICtrlSetOnEvent($btnMin,"workingbut")
	no_tab()
	GuiCtrlSetTip(-1,'Minimize')
	Global $btnCut=GUICtrlCreateButton($charM,$width-42,0,20,20,$BS_FLAT)
	GuiCtrlSetResizing(-1,'802')
	GUICtrlSetOnEvent($btnCut,"workingbut")
	no_tab()
	GuiCtrlSetTip(-1,'Toggle Winshade Mode')
	Global $btnClose=GUICtrlCreateButton($charX,$width-20,0,20,20,$BS_FLAT)
	GuiCtrlSetResizing(-1,'802')
	GUICtrlSetOnEvent($btnClose,"workingbut")
	no_tab()
	GuiCtrlSetResizing(-1,'802')
	GuiCtrlSetTip(-1,'Close')
	GuiSetFont(11,300,0,'Arial'); Font by default
EndFunc

Func programsgui()
global $goingdown,$goingleft, $oonoff=0,$toolbar, $keepwindowon=0
Global $iconslist, $iconslabel, $names,$labelison=0, $act="", $biglabelname
Global $gw=600,$gh=@DesktopHeight-60

	;set up variables
$names = IniReadSectionNames("cons.ini")
	If @error Then
		createini()
		$names = IniReadSectionNames("cons.ini")
	EndIf
dim $iconslist[100][5]
dim $iconslabel[$names[0]+1]
dim $biglabelname[$names[0]+1]
$longest_row=0
;read the ini
For $j = 1 To $names[0]
	$sections = IniReadSection("cons.ini", $names[$j])
	if $sections[0][0]>$longest_row then $longest_row=$sections[0][0]
Next
;set window size, colour etc.
Global $menuwidth=100+50*$longest_row
Global $menuheight=25+$names[0]*70


$goingdown=65
;add icons
For $j = 1 To $names[0]
	$biglabelname[$j]= GUICtrlCreateLabel($names[$j],5,$goingdown+9,120,34,$SS_left)
	GUICtrlSetState ($biglabelname[$j], $GUI_DROPACCEPTED)
	GuiCtrlSetResizing(-1,'64')
	GUICtrlSetFont(-1,14, 600,2,"Verdana")
	GUICtrlSetColor(-1,"0x3D8B37")
	$iconslabel[$j]=GUICtrlCreateLabel("",25,$goingdown+40,200,25)
	GUICtrlSetFont(-1,13, 550,"Arial")
	GuiCtrlSetResizing(-1,'64')
	
	$goingleft=105
	$sections = IniReadSection("cons.ini", $names[$j])
		For $i = 1 To $sections[0][0]
			$counting=$counting+1
			$iconslist[$counting][0] = $sections[$i][0]
			$iconslist[$counting][1] = GUICtrlCreateIcon($sections[$i][1], 0, $goingleft, $goingdown,32,32)
			GuiCtrlSetResizing(-1,'64')
			GUICtrlSetCursor(-1, 0)
			$iconslist[$counting][2] = $j
			$iconslist[$counting][3] = $i
			$iconslist[$counting][4] = $sections[$i][1]
		;	SetIcon($iconslist[$counting][1], $transcolour, $sections[$i][1], 0, 48, 48)
			$goingleft=$goingleft+50
			GUICtrlSetOnEvent($iconslist[$counting][1],"shortcutlinks")
		Next

	$goingdown=$goingdown+70
Next

redim $iconslist[$counting+1][5]
;guisetstate(@SW_SHOW,$toolbar)

EndFunc
#EndRegion


#region Time Updater
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ADLIB Function;;;;;;;;;;;;;;;;;;;;;;;;;;;
func timeupdater()
	if not ControlGetFocus($GUI_MAIN)="Edit1" then
		$filelist=IniReadSection("progressexplorer.ini","files")
		If @error Then
		writetheini()
		$filelist=IniReadSection("progressexplorer.ini","files")
	EndIf
		Global $sString=""
			For $i = 1 To $filelist[0][0]
				$sString= $sString&"|"&$filelist[$i][0]
			Next
		$sString= $sString&"| "&update()
		GUICtrlSetData($combobox, $sString, "")
		$refreshing=1
		_GUICtrlComboBox_SetCurSel($combobox, 0)
		;MsgBox(0,"","sdfsdf")
;		$lasttime=update()
	EndIf
EndFunc
#EndRegion
#Region On event Functions
;;;;;;;;;;;;;;;;;;On event Functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

func shortcutlinks()
	;MsgBox(0,"","sdfsdf")
For $j = 1 To $counting
		if @GUI_CTRLID=$iconslist[$j][1] Then
			ShellExecute($iconslist[$j][4])

		EndIf
Next
EndFunc

Func workingbut()
if @GUI_CTRLID=$btnTop Then
	If $wStateTop=0 Then
		ControlSetText($GUI_MAIN,'',$btnTop,'l')
	;	ControlFocus($GUI_MAIN,"","Static1"); remove the focus
		$wStateTop=1
	Else
		ControlSetText($GUI_MAIN,'',$btnTop,'m')
	;	ControlFocus($GUI_MAIN,"","Static1"); remove the focus
		$wStateTop=0
	EndIf
	WinSetOnTop($GUI_MAIN,"",$wStateTop)
ElseIf @GUI_CTRLID=$btnMin Then
	WinSetState($GUI_MAIN,"",@SW_MINIMIZE)
ElseIf @GUI_CTRLID=$btnCut Then
	If $winshade=1 Then
		WinMove($GUI_MAIN,'',$xcoord,$ycoord,$width,520)
		GUICtrlDelete($btnCut)
		sysbuttons()
		GUICtrlSetPos($hListView1,80, 44, 354, 451)
		GUICtrlSetPos($combobox, 256, 495, 180, 36)
		GUICtrlSendMsg($hListView1, 0x101E, 1, 85)
		$winshade=0
	Else
		WinMove($GUI_MAIN,'',$xcoord-28,$ycoord+500,$width+28,20)
		GUICtrlDelete($btnTop)
		GUICtrlDelete($btnMin)
		GUICtrlDelete($btnClose)
		GUICtrlSetPos($btnCut,$width+8,0)
		GUICtrlSetPos($hListView1,0, 0, 270, 38)
		GUICtrlSetPos($combobox, 270, 0, 180, 36)
		GUICtrlSendMsg($hListView1, 0x101E, 1, 0)
		$winshade=1
	EndIf
	;guisetstate()
ElseIf @GUI_CTRLID=$btnClose Then
	Exit 0
EndIf
EndFunc

func working()
	for $j=1 to $inisource2[0][0]-1
		if @GUI_CTRLID=$allbuts[$j][0] Then
			$DIRECTORY_LOCAL=$allbuts[$j][1]
			_SHLV_PopulateLocalListView($SHELLLISTVIEWHANDLE,$DIRECTORY_LOCAL)
			GUISetState(@SW_SHOW)
			GUICtrlSetState($hListView1, $GUI_FOCUS)
			ExitLoop
		EndIf
	Next
EndFunc
#EndRegion

#Region Stand alone functions
;;;;;;;;;;;;;;;;;;;referenced stand-alone functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;Date and Time
Func Update()
$h = @HOUR
$m = @MIN
if $m<>$time Then

If $h<10 then $h=StringRight($h,1)
If $h > 12 Then
$h = $h - 12
$m = $m & " PM"
Else
If $h = 12 Then
$m = $m & " PM"
Else
$m = $m & " AM"
EndIf
EndIf

$variable=$h & ":" & $m& " " &GetDayOfWeek() & " " & GetMonth() & " " & @MDAY

Return $variable
EndIf
EndFunc

Func GetDayOfWeek()
    Return _WinAPI_GetLocaleInfo(_WinAPI_GetUserDefaultLCID(), 49 + Mod(@WDAY + 5, 7))
EndFunc   ;==>GetDayOfWeek

Func GetMonth()
    Return _WinAPI_GetLocaleInfo(_WinAPI_GetUserDefaultLCID(), 67 + @MON)
EndFunc   ;==>GetMonth

Func Getyear()
    Return StringRight(@YEAR, 2)
EndFunc   ;==>Getyear

Func _WinAPI_GetLocaleInfo($Locale, $LCType)
    Local $aResult = DllCall("kernel32.dll", "long", "GetLocaleInfo", "long", $Locale, "long", $LCType, "ptr", 0, "long", 0)
    If @error Then Return SetError(1, 0, "")
    Local $lpBuffer = DllStructCreate("char[" & $aResult[0] & "]")
    $aResult = DllCall("kernel32.dll", "long", "GetLocaleInfo", "long", $Locale, "long", $LCType, "ptr", DllStructGetPtr($lpBuffer), "long", $aResult[0])
    If @error Or ($aResult[0] = 0) Then Return SetError(1, 0, "")
    Return SetError(0, 0, DllStructGetData($lpBuffer, 1))
EndFunc

Func _WinAPI_GetUserDefaultLCID()
    Local $aResult = DllCall("kernel32.dll", "long", "GetUserDefaultLCID") ; Get the default LCID for this user
    If @error Then Return SetError(1, 0, 0)
    Return SetError(0, 0, $aResult[0])
EndFunc

func movedecision()
local $excludemove="|Internet Explorer_Server|SysListView32|SysTreeView32|Scintilla|Edit|OperaWindowClass|ComboLBox|ComboBox|_WwG|ScrollBar|EXCEL<|EXCEL7|SUPERGRID|RichEdit20W|VbaWindow|"

	$po=MouseGetCursor()
	$pos = _WinAPI_GetMousePos()
	$point=_WinAPI_WindowFromPoint($pos)
	;$hWnd=_WinAPI_GetParent($point)
	$hWnd =WinGetHandle("","")
	$titled=WinGetTitle($hWnd)
	$contrlhandled=ControlGetHandle($hWnd,'',$point)
	
Dim $iStyle = _WinAPI_GetWindowLong($contrlhandled, $GWL_STYLE)
$tRect=_WinAPI_GetWindowRect($hWnd)
$mouseloc=MouseGetPos()
$pow=WinGetState($hWnd,"")
;ToolTip(_WinAPI_GetClassName($point))
if _IsPressed("01", $dll) and _IsPressed("10", $dll)then movewin($hWnd) ;bypass
If _IsPressed("02", $dll) and _IsPressed("10", $dll)then rgtclwin($hWnd)

If Not StringInStr($excludemove, "|" & _WinAPI_GetClassName($point) & "|") and $po=2 and not BitAnd($pow, 32) and not WinExists("Drag") Then
	if $mouseloc[1]> DllStructGetData($tRect, 2)+25 or $titled="Program Manager" then
		if _IsPressed("01", $dll) and not _IsPressed("02", $dll) Then movewin($hWnd)
		if _IsPressed("02", $dll) and Not _IsPressed("01", $dll) Then rgtclwin($hWnd)
	EndIf
EndIf
EndFunc

func movewin($hWnd)
Local $MousePos, $WinPos, $PosDiff[2]
	While 1
		$MousePos = MouseGetPos ()
		$WinPos = WinGetPos ("","")
		$PosDiff[0] = $WinPos[0] - $MousePos[0]
		$PosDiff[1] = $WinPos[1] - $MousePos[1]
		While _IsPressed ("01", $dll)
			$MousePos = MouseGetPos ()
			WinMove ("", "", $MousePos[0] + $PosDiff[0], $MousePos[1] + $PosDiff[1])
			$WinPos = WinGetPos ("","")
			Sleep (10)
				if _IsPressed ("02", $dll) then
					WinSetState($hWnd,"",@SW_MINIMIZE)
					sleep(200)
					return
				EndIf
		WEnd
		ExitLoop
		Sleep (10)
	WEnd 
EndFunc

func rgtclwin($hWnd)
	While _IsPressed ("02", $dll)
		Sleep (10)
		if _IsPressed ("01", $dll) then
			$lk=WinGetState($hWnd)
			If BitAnd($lk, 16) Then
				WinSetState($hWnd,"",@SW_MAXIMIZE)
			elseIf BitAnd($lk, 32) Then
				WinSetState($hWnd,"",@SW_RESTORE)
			EndIf
			sleep(200)
			return
		EndIf
	WEnd
EndFunc

Func WM_DROPFILES_UNICODE_FUNC($hWnd, $msgID, $wParam, $lParam)
	
	Local $nSize, $pFileName
	Local $nAmt = DllCall("shell32.dll", "int", "DragQueryFileW", "hwnd", $wParam, "int", 0xFFFFFFFF, "ptr", 0, "int", 255)
	For $i = 0 To $nAmt[0] - 1
		$nSize = DllCall("shell32.dll", "int", "DragQueryFileW", "hwnd", $wParam, "int", $i, "ptr", 0, "int", 0)
		$nSize = $nSize[0] + 1
		$pFileName = DllStructCreate("wchar[" & $nSize & "]")
		DllCall("shell32.dll", "int", "DragQueryFileW", "hwnd", $wParam, "int", $i, "int", DllStructGetPtr($pFileName), "int", $nSize)
		ReDim $gaDropFiles[$i + 1]
		$gaDropFiles[$i] = DllStructGetData($pFileName, 1)
		
		If StringInStr($gaDropFiles[$i],".") Then
			FileCopy($gaDropFiles[$i], $DIRECTORY_LOCAL&"\*.*")
			FileDelete($gaDropFiles[$i])
			ToolTip("Moved to "&$DIRECTORY_LOCAL,-1,-1)
		Else
			DirMove($gaDropFiles[$i],$DIRECTORY_LOCAL,1)
			DirRemove($gaDropFiles[$i],1)
			ToolTip("Moved to "&$DIRECTORY_LOCAL,-1,-1)
		EndIf
		$pFileName = 0
		Sleep(3000)
		ToolTip("",930,0)
	Next
	
EndFunc   ;==>WM_DROPFILES_UNICODE_FUNC

; Reduce memory usage
; Author wOuter ( mostly )

Func _ReduceMemory($i_PID = -1)
    
    If $i_PID <> -1 Then
        Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $i_PID)
        Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
        DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
    Else
        Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
    EndIf
    
    Return $ai_Return[0]
EndFunc;==> _ReduceMemory()

func no_tab()
    _WinAPI_SetWindowLong(GUICtrlGetHandle(-1), $GWL_STYLE, _
	BitAND(_WinAPI_GetWindowLong(GUICtrlGetHandle(-1), $GWL_STYLE), BitNOT($WS_TABSTOP)))
EndFunc

#EndRegion
#Region INI Files
func writetheini()
IniWrite("progressexplorer.ini","shortcuts","C:\","C:\")
IniWrite("progressexplorer.ini","shortcuts","D:\","D:\")
IniWrite("progressexplorer.ini","shortcuts","E:\","E:\")
IniWrite("progressexplorer.ini","shortcuts","F:\","F:\")

_WinAPI_CreateFile("c:\ProgressExplorer.txt", 0)
_WinAPI_CreateFile("c:\ExplorerProgress.txt", 0)

IniWrite("progressexplorer.ini","files","Test","C:\ProgressExplorer.txt")
IniWrite("progressexplorer.ini","files","Another Text","C:\ExplorerProgress.txt")
sleep(200)
EndFunc

func createini()
;cons ini
IniWrite("cons.ini", "Editors", "Wordpad", "C:\Windows\System32\write.exe")
IniWrite("cons.ini", "Editors", "Notepad", "C:\Windows\System32\notepad.exe")
IniWrite("cons.ini", "Tools", "Calculator", "C:\Windows\System32\calc.exe")
IniWrite("cons.ini", "Tools", "Paint", "C:\Windows\System32\mspaint.exe")
IniWrite("cons.ini", "Media","MediaPlayer","C:\Program Files\Windows Media Player\wmplayer.exe")
EndFunc
#EndRegion