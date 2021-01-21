; http://www.xstandard.com/en/documentation/xmd5/

#include <GuiConstantsEx.au3>
#include <GuiListView.au3>
#include <GuiMenu.au3>
#Include <String.au3>
#include <Date.au3>
#include <Misc.au3>
#Include <File.au3>
#Include <Array.au3>
#include <SQLite.au3>

Global $Secs, $Mins, $Hour, $Time
Dim $MenuPath, $Diff, $LVSelect, $iIndex
Dim $szDrive, $szDir, $szFName, $szExt
Dim $dll = DllOpen("user32.dll")

AdlibEnable("_Exit")

; Initialize error handler 
$oMyError = ObjEvent("AutoIt.Error","MyErrFunc")

; Declare Objects
$oMD5 = ObjCreate("XStandard.MD5") ;"ActiveX MD5 Hash/CheckSum

If Not IsObj($oMD5) Then
	MsgBox(48,"Error","You don't have the MD5 COM object installed on !!")
	Exit
EndIf

;---------------------------------------- Register MSG ---------------------------------
GUIRegisterMsg($WM_MENUSELECT,"MouseOverMenu")

;----------------------------------------- Main GUI ------------------------------------
$Gui = GuiCreate("Duplicate File Finder" , 975, 771,(@DesktopWidth-975)/2, (@DesktopHeight-840)/2 , _ 
$WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

;----------------------------------------- ListView ------------------------------------
$ListView1 = GUICtrlCreateListView("Duplicate Files |Date |Size in Kb |MD5 Hash ", 10, 45, 957, 478,-1, BitOR($LVS_SHOWSELALWAYS,$LVS_REPORT)) 
GUICtrlSendMsg($listview1, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_HEADERDRAGDROP, $LVS_EX_HEADERDRAGDROP) ;Drag & Drop 
GUICtrlSendMsg($listview1, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
GUICtrlSendMsg($listview1, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_TRACKSELECT, $LVS_EX_TRACKSELECT)
GUICtrlSetImage($ListView1, "compstui.dll", -15)
GUICtrlSetResizing ($ListView1,$GUI_DOCKAUTO)
_GUICtrlListView_SetColumnWidth ($ListView1, 0,600) 
_GUICtrlListView_SetColumnWidth ($ListView1, 3,300)
_GUICtrlListView_SetHoverTime ($ListView1,500) ; Set Hoover to x Sec.

$ListView2 = GUICtrlCreateListView("Related Duplicate Files |Date |Size in Kb |MD5 Hash ", 10, 530, 957, 200,-1,$LVS_REPORT)
GUICtrlSendMsg($listview1, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_HEADERDRAGDROP, $LVS_EX_HEADERDRAGDROP) ; Drag & Drop 
GUICtrlSendMsg($listview1, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
GUICtrlSetImage($ListView2, "compstui.dll", -16)
GUICtrlSetResizing ($ListView2,$GUI_DOCKAUTO)
_GUICtrlListView_SetColumnWidth ($ListView2, 0,600) 
_GUICtrlListView_SetColumnWidth ($ListView2, 3,300)

;------------------------------------ Labels -------------------------------------------
$Progressbar1 = GUICtrlCreateProgress (167,732,800,15)
GUICtrlSetColor(-1,32250) ; not working with Windows XP Style

$ProgressLabel = GUICtrlCreateLabel("Processing MD5 Checksum : ",10 ,732 ,155,15)
$PathLabel = GUICtrlCreateLabel("Reading Files : ",10 ,750 ,695,18,$SS_SUNKEN)
$TimeLabel = GUICtrlCreateLabel("Time Elapsed : ",710 ,750 ,135,18,$SS_SUNKEN)
$VersionLabel = GUICtrlCreateLabel("MD5 Version - " & $oMD5.Version,850 ,750 ,120,18,$SS_SUNKEN)

;------------------------------------ Menu ---------------------------------------------
Dim $sPath = @MyDocumentsDir
$sShortPath = StringSplit($sPath,"\")

$nFileMenu1		= GUICtrlCreateMenu(" &Open")
$nFileSelFolder1= GUICtrlCreateMenuItem("Select Folder ...",$nFileMenu1)
GUICtrlSetState(-1,$GUI_DEFBUTTON)
$nFileSelFolder2= GUICtrlCreateMenuItem("Export to File",$nFileMenu1)
$nFileSelFolder0= GUICtrlCreateMenuItem("",$nFileMenu1)
$nFileSelFolder3 = GUICtrlCreateMenuItem($sShortPath[1]&"\ ...\" & $sShortPath[$sShortPath[0]]  ,$nFileMenu1)

$nFileMenu2		= GUICtrlCreateMenu("&Info")
$nFileSelFolderH= GUICtrlCreateMenuItem("Help" ,$nFileMenu2)
$nFileSelFolderA= GUICtrlCreateMenuItem("About ...",$nFileMenu2)

;------------------------------------ Button -------------------------------------------
$bScan = GuiCtrlCreateButton("Scan ...", 10, 2, 40, 40, BitOr($BS_BOTTOM,$BS_ICON))
GUICtrlSetImage ($bScan, "shell32.dll",-219)
GUICtrlSetTip($bScan,"Press F3 to Scan")
HotKeySet("{F3}", "_FindDups_F3")

;------------------------------------- Input --------------------------------------------
$Group = GUICtrlCreateGroup("Filters ", 100, 5, 400, 30)
$sExtention = GUICtrlCreateLabel("File Extention : ",110 ,18 ,80,15)
$sFileSize = GUICtrlCreateLabel("File Size in Kb : ",270 ,18 ,70 ,15)
$sFilter = GUICtrlCreateInput ("*", 200,  14, 40, 17)
GUICtrlSetTip($sFilter,"Extention like PDF, ZIP, EXE, ... ")
$sSize = GUICtrlCreateInput ("1", 350, 14, 60, 17)
GUICtrlSetTip($sSize,"Input a Size number to filter on ... ")

;-------------------------------------- Context Menu ------------------------------------
$OptionsContext	= GUICtrlCreateContextMenu($ListView2)
$OptionsFile1	= GUICtrlCreateMenuItem("Open File ", $OptionsContext)
$OptionsFile2	= GUICtrlCreateMenuItem("Delete File ", $OptionsContext)

;-------------------------------------- Group -------------------------------------------
$Group = GUICtrlCreateGroup("Statistics ", 620, 5, 300, 30)
$ItemsCnt = GUICtrlCreateLabel("Duplicate Items : 0" , 630, 18, 160, 15)
$FilesCnt = GUICtrlCreateLabel("Number of Files Processed : 0" , 740, 18, 160, 15)

;-------------------------------------- DB Init -----------------------------------------
_SQLite_Startup ()
_SQLite_Open () ; open :memory: Database
_SQLite_Exec (-1, "CREATE TABLE Duplicates (File,Date,Size,md5);")
_SQLite_Exec (-1, "CREATE TABLE Bookmarks (Pointer,ShortPointer);")	

;GUI handling
;------------
GuiSetState()

GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY") ; Simple HeaderSort
Global $B_DESCENDING [_GUICtrlListView_GetColumnCount ($ListView1) ]

While 1
	$nMsg = GUIGetMsg()
Switch $nMsg
	Case $GUI_EVENT_CLOSE
		_SQLite_Exec (-1, "DROP TABLE Duplicates;")
		_SQLite_Exec (-1, "DROP TABLE Bookmarks;")
		_SQLite_Close ()
		_SQLite_Shutdown ()
		DllClose($dll)
		Exit
		
	Case $nFileSelFolder1
		$MenuPath = FileSelectFolder("Select a Folder to Scan ...", "", "", $sPath)
	
	Case $nFileSelFolder3
		$MenuPath = FileSelectFolder("Select a Folder to Scan ...", "", "", $sPath)
	
	Case $nFileSelFolder2
		_Export()
		
	Case $nFileSelFolderH
		Help()
	
	Case $nFileSelFolderA
		About()
	
	Case $bScan
		If $MenuPath = "" then
			MsgBox(48,"Error","No Folders selected !!")
		Else
		_FindDups(GUICtrlRead($sFilter),GUICtrlRead($sSize))
		EndIf
	
	Case $OptionsFile1
		$LVSelect = _GUICtrlListView_GetItemText($ListView1, Int(_GUICtrlListView_GetSelectedIndices($ListView1)), 0) 
		$DuplicateFilePath  =  _PathSplit($LVSelect,$szDrive, $szDir, $szFName, $szExt)
		$Zxtension = StringSplit($DuplicateFilePath[4],".")
		If StringInStr(Assoc($DuplicateFilePath[4]),":\") Then
			ShellExecute($DuplicateFilePath[3]&$DuplicateFilePath[4],"",$DuplicateFilePath[1]&$DuplicateFilePath[2])
		EndIf
		
	Case $OptionsFile2
		$iIndex = _GUICtrlListView_GetSelectedIndices ($ListView2)
		$LVSelect = _GUICtrlListView_GetItemText($ListView2, int($iIndex), 0)
		If MsgBox(1,"Important","Are you sure you want to delelete " & @CR & @CR & $LVSelect) = 1 Then
			_FileDelete($LVSelect,int($iIndex))
		EndIf
		
	Case $nMsg = $GUI_EVENT_PRIMARYDOWN
			$Pos = GUIGetCursorInfo()
			If IsArray($Pos) Then
				If ($Pos[4] == $listview1) Then
					If 	$iIndex <> _GUICtrlListView_GetSelectedIndices ($ListView1) Then
						$iIndex = _GUICtrlListView_GetSelectedIndices ($ListView1) ; Bug _GUICtrlListView_GetSelectedIndices returns a string i/o Int
						$LVSelect = _GUICtrlListView_GetItemText($ListView1, int($iIndex), 3)
					_SelectDups($LVSelect)
					EndIf
				EndIf
			EndIf
	EndSwitch
WEnd

;--------------------------------------- Functions ----------------------------------
Func _FindDups_F3()
	_FindDups(GUICtrlRead($sFilter),GUICtrlRead($sSize))
EndFunc

Func _FindDups($sExt, $sFSize)
Local $hQuery, $aRow
local $sPathMenu, $i, $y

;$hWnd = WinGetHandle("Duplicate File Finder")
;$hMain = _GUICtrlMenu_GetMenu ($hWnd)
;$hFile = _GUICtrlMenu_GetItemSubMenu ($hMain, 0)

_GUICtrlListView_DeleteAllItems ($ListView1)
_GUICtrlListView_DeleteAllItems ($ListView2)
	GuiCtrlSetData($PathLabel,"Reading Files : ")
	GuiCtrlSetData($TimeLabel,"Time Elapsed : ")
	GuiCtrlSetData($ItemsCnt,"Duplicate Items : 0")
	GuiCtrlSetData($FilesCnt,"Number of Files Processed : 0")
	
_SQLite_Exec (-1, "DELETE FROM Duplicates;")

If $MenuPath = "" Then
	MsgBox(0,"Error","No valid Selection made ... Try again")
		Return
	Else

	$sPath = $MenuPath 
	$sShortPath = StringSplit($sPath,"\")
	$ShortMenu = $sShortPath[1]&"\ ...\"&$sShortPath[$sShortPath[0]]
	
	_SQLite_Exec (-1, 'INSERT INTO Bookmarks (Pointer,ShortPointer) VALUES' & '("' &  $sPath & '","' & $ShortMenu & '");')
	
	;_SQlite_Query (-1, "SELECT Count(*) From (SELECT DISTINCT(Pointer) FROM Bookmarks);", $hQuery)
	;	While _SQLite_FetchData ($hQuery, $aRow) = $SQLITE_OK 
	;		consolewrite("Counter" & $aRow[0]  & @CRLF)
	;		$y = $aRow[0]
	;	WEnd
		
	_SQlite_Query (-1, "SELECT DISTINCT(Pointer) FROM Bookmarks;", $hQuery)
		While _SQLite_FetchData ($hQuery, $aRow) = $SQLITE_OK 
			;consolewrite("Pointer " & $aRow[0]  &  @CRLF) 
		WEnd
	
	_SQlite_Query (-1, "SELECT DISTINCT(ShortPointer) FROM Bookmarks;", $hQuery)
		While _SQLite_FetchData ($hQuery, $aRow) = $SQLITE_OK 
			;consolewrite("ShortPointer " &$aRow[0]  &  @CRLF)
			GUICtrlSetData($nFileSelFolder3,$aRow[0])
		WEnd
EndIf

$Begin = TimerInit()
GuiCtrlSetData($PathLabel,"Reading Files : ")

$aFilesList = _FileListToArrayEx ($sPath, "*."&$sExt)
	
For $n = 1 To $aFilesList[0]
	GUICtrlSetData ($Progressbar1,($n/$aFilesList[0])*100)
	
	$sFileSize = Round(FileGetSize($aFilesList[$n])/1024,2)
	$sFileDate = FileGetTime($aFilesList[$n], 1)
	$sDateStamp = $sFileDate[2] & "/" & $sFileDate[1] & "/" & $sFileDate[0]

	If $sFileSize  >= $sFSize Then
		$oDict1_key = $oMD5.GetCheckSumFromFile($aFilesList[$n]) ; Or Reverse $oMD5.GetCheckSumFromString
	
		_SQLite_Exec (-1, 'INSERT INTO Duplicates(File,Date,Size,md5) VALUES' & _ 
					  '("' &  $aFilesList[$n] & '","' & $sDateStamp & '","' &  $sFileSize & '","' & $oDict1_key & '");')
	EndIf	
	Sleep (25)
	_TicksToTime(Int(TimerDiff($Begin)), $Hour, $Mins, $Secs )
		Local $sTime = $Time  ; save current time to be able to test and avoid flicker..
	$Time = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
	GuiCtrlSetData($TimeLabel,"Time Elapsed : " & $Time )
Next

GuiCtrlSetData($FilesCnt,"Number of Files Processed : " & $aFilesList[0])

_SQlite_Query (-1, "SELECT * FROM Duplicates GROUP BY md5 HAVING COUNT(*) > 1;", $hQuery)

While _SQLite_FetchData ($hQuery, $aRow) = $SQLITE_OK 
	;ConsoleWrite(StringFormat(" %-10s  %-10s  %-10s  %-10s ", $aRow[0], $aRow[1]) & @CR)
	$DataCol = GUICtrlCreateListViewItem($aRow[0] & "|" & $aRow[1] & "|" & $aRow[2] & "|" & $aRow[3],$ListView1)
WEnd

GuiCtrlSetData($ItemsCnt,"Duplicate Items : " & _GUICtrlListView_GetItemCount ($ListView1))
	_GUICtrlListView_SetColumnWidth ($ListView1, 0,$LVSCW_AUTOSIZE) ; AutoSize Listview, needs to be called after filling the LV
EndFunc

Func _SelectDups($LVSelect)
Local $hQuery, $aRow
_GUICtrlListView_DeleteAllItems	($ListView2)

_SQlite_Query (-1, "SELECT * FROM Duplicates WHERE md5='" & $LVSelect & "';", $hQuery)

While _SQLite_FetchData ($hQuery, $aRow) = $SQLITE_OK 
	;ConsoleWrite(StringFormat(" %-10s  %-10s  %-10s  %-10s ", $aRow[0], $aRow[1]) & @CR)
	$DataCol = GUICtrlCreateListViewItem($aRow[0] & "|" & $aRow[1] & "|" & $aRow[2] & "|" & $aRow[3],$ListView2)
WEnd
_GUICtrlListView_SetColumnWidth ($ListView2, 0,$LVSCW_AUTOSIZE) 
EndFunc

Func _Export()
Local $hQuery, $aRow, $avExport

$file = FileOpen(@ScriptDir & "\Duplicate Files.csv",2)

FileWrite($file,"Path" & ";" & "Date" & ";" & "Size / Kb" & ";" & "Md5" & @LF)

_SQlite_Query (-1, "SELECT * FROM Duplicates WHERE md5 IN (SELECT md5 FROM Duplicates GROUP BY md5 HAVING COUNT(*) > 1) ORDER BY md5;", $hQuery)

While _SQLite_FetchData ($hQuery, $aRow) = $SQLITE_OK 
	;ConsoleWrite( $aRow[0] & ";" & $aRow[1] & ";" & StringReplace($aRow[2],".",",") & ";" & $aRow[3] & @LF)
	FileWrite($file,$aRow[0] & ";" & $aRow[1] & ";" & StringReplace($aRow[2],".",",") & ";" & $aRow[3] & @LF)
WEnd

FileClose($file)

MsgBox(64,"Info ... ","Report finished.")
EndFunc

Func _FileListToArrayEx($sPath, $sMask='*')
    Local $i, $j, $RetList[1], $DirsArr = _FileListToArray($sPath, '*', 2), $SubDirFiles, $FilesArr

	$FilesArr = _FileListToArray($sPath, $sMask, 1)
	For $i = 1 To UBound($FilesArr) - 1
        ReDim $RetList[UBound($RetList)+1]
        $RetList[UBound($RetList)-1] = $sPath & "\" & $FilesArr[$i]
		GuiCtrlSetData($PathLabel,"Reading Files : " &  $sPath & "\" & $FilesArr[$i])
	Next
			
    If UBound($DirsArr) > 0 Then
		
        For $i = 1 To $DirsArr[0]
            $SubDirFiles = _FileListToArrayEx($sPath & "\" & $DirsArr[$i], $sMask)
            If $SubDirFiles[0] > 0 Then
				
                For $j = 1 To $SubDirFiles[0]
                    ReDim $RetList[UBound($RetList)+1]
                    $RetList[UBound($RetList)-1] = $SubDirFiles[$j]
					GuiCtrlSetData($PathLabel,"Reading Files : " &  $SubDirFiles[$j])
                Next
            Else
                $FilesArr = _FileListToArray($sPath & "\" & $DirsArr[$i], $sMask, 1)
                For $j = 1 To UBound($FilesArr) - 1
                    ReDim $RetList[UBound($RetList)+1]
                    $RetList[UBound($RetList)-1] = $sPath & "\" & $DirsArr[$i] & "\" & $FilesArr[$j]
                Next
            EndIf
		Next
    EndIf
	
	$RetList[0] = UBound($RetList) - 1
    Return $RetList
EndFunc

Func _FileDelete($Filename,$Index)
FileDelete($Filename)
	_SQLite_Exec (-1, 'DELETE FROM Duplicates Where File="'& $Filename & '";')
	_GUICtrlListView_DeleteItem($ListView2,$Index)
EndFunc

Func Assoc($Filename)
   If StringRight($Filename, 3) = "exe" Or StringInStr($Filename, ".") = 0 Then Return -1
   $Ext = StringRight($Filename, 3)
   $Descr = RegRead("HKEY_CLASSES_ROOT\" & "." & $Ext, "")
   $Program = RegRead("HKEY_CLASSES_ROOT\" & $Descr & "\Shell\Open\Command", "")
   $Program = StringReplace($Program, '"', "")
   $Match = StringInStr($Program, ".exe")
   If $Match = 0 Then
      Return $Filename
   EndIf
   
   $Program = SubString($Program, 1, $Match + 3, 1, 1)
   Return $Program
EndFunc   

Func SubString($String, $start, $end, $StartOccur, $EndOccur)
   Local $Match1
   Local $Match2
   Local $i
   If IsString($start) Then
      $Match1 = StringInStr($String, $start, 0, $StartOccur)
      If $Match1 = 0 Then Return 1
   Else
      $Match1 = $start
   EndIf
   
   If IsString($end) Then
      $Match2 = StringInStr($String, $end, 0, $EndOccur)
      If $Match2 = 0 Then Return 11
   Else
      $Match2 = $end
   EndIf
   
   If $end = -1 Then
      $NewString = StringMid($String, $Match1)
   Else
      For $i = 1 To 3
         If IsNumber($Match2) Then ExitLoop
         Select
            Case $i = 1
               $Match2 = StringInStr($String, $end)
            Case $i = 2
               $TempString = StringTrimLeft($String, $Match1)
               $Match2 = StringInStr($TempString, $end)
               $Match2 = $Match1 + $Match2
         EndSelect
         
         If $Match2 > 0 Then
            ExitLoop
         ElseIf $i = 3 Then
            Return 1
         EndIf
      Next
      
      $NewString = StringTrimLeft($String, $Match1 - 1)
      $NewString = StringTrimRight($NewString, StringLen($String) - $Match2)
   EndIf
   
   If IsNumber($NewString) Then Return 2
   
   Return $NewString
EndFunc

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam) ; HeaderSort
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndListView
	$hWndListView = $ListView1
	If Not IsHWnd($ListView1) Then $hWndListView = GUICtrlGetHandle($ListView1)

	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $hWndListView
			Switch $iCode
				Case $LVN_COLUMNCLICK ; A column was clicked
					Local $tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
						_GUICtrlListView_SimpleSort ($hWndListView, $B_DESCENDING, DllStructGetData($tInfo, "SubItem"))
					; No return value
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc

Func MouseOverMenu($hWndGUI, $MsgID, $WParam, $LParam)
	Local $id = BitAnd($WParam, 0xFFFF), $hQuery, $aRow
		;ConsoleWrite( "hWndGui= "&$hWndGUI& @LF &"MsgId= "&$MsgID& @LF &"WParam= " &$WParam& @LF &"$LParam= "&$LParam& @LF)
		;ConsoleWrite("ID= "& $id & @LF)
		;ConsoleWrite(GUICtrlRead ($id,1) & @LF)
		$sMenuText= GUICtrlRead ($id,1)
		;ConsoleWrite("test" & $sMenuText & @LF)
		ToolTip("")
		If $ID  > 13 Then
		_SQlite_Query (-1, "SELECT DISTINCT(Pointer) FROM Bookmarks WHERE Shortpointer='"& $sMenuText & "';", $hQuery)
			While _SQLite_FetchData ($hQuery, $aRow) = $SQLITE_OK 
				;consolewrite($aRow[0]  &  @CRLF)
				;ConsoleWrite("Output " & $aRow[0] & @LF)
				Tooltip($aRow[0])
			WEnd
		EndIf
		
		Return $GUI_RUNDEFMSG
	EndFunc

Func Help()
	MsgBox(64,"Help info", _
				"IMPORTANT : " & @CRLF & _ 
				"When selecting a folder to scan it is recommended not to select the top level 'C:' drive" & @CRLF & _ 
				"This will take to much time and CPU, to scan and process. Better is select a smaller range to scan." & @CRLF & _ 
				@CRLF & _ 
				"USAGE :" & @CRLF & _ 
				"To start, hoover the mouse over an item in the top listview." & @CRLF & _ 
				"On the bottem listview you will see all duplicate items appear" & @CRLF & @CRLF & _ 
				"Richt click an item in the bottom listview, and select OPEN or DELETE." & @CRLF & _
				"OPEN will run the file. If there is an associated application on your system to run it" & @CRLF & @CRLF & _
				"Press F3 to start scanning and ESC to quit while processing the MD5 checksums" & @CRLF & _
				@CRLF )
EndFunc

Func About()
$GUI = GUICreate ("About ..." , 450 , 130)

GUICtrlCreateLabel ("IMPORTANT : " & @CRLF & _ 
					"This application uses the MD5 Com object from :" & @CRLF, 10 , 15, 400,40)
$link_1 = GUICtrlCreateLabel ("http://www.xstandard.com/en/documentation/xmd5/", 10 , 45, 420,20)
GUICtrlSetFont (-1 , 13 , 600)
GUICtrlSetColor (-1 ,0x004080)
GUICtrlSetCursor (-1 , 0)
GUICtrlCreateLabel ("As well as the SQLite database component." & @CRLF & _ 
					"Make sure both are properly installed on your machine." & @CRLF & _ 
					@CRLF, 10 , 75, 400,40)

GUISetState (@SW_SHOW , $GUI)

While 1
    $msg = GUIGetMsg ()
    If $msg = $gui_event_close Then Exit
    If $msg = $link_1 Then
        ShellExecute ("http://www.xstandard.com/en/documentation/xmd5/",1)
    EndIf
WEnd
EndFunc

Func MyErrFunc()
  $HexNumber=hex($oMyError.number,8)
  Msgbox(0,"COM Error Test","We intercepted a COM Error !"       & @CRLF  & @CRLF & _
			 "err.description is: "    & @TAB & $oMyError.description    & @CRLF & _
			 "err.windescription:"     & @TAB & $oMyError.windescription & @CRLF & _
			 "err.number is: "         & @TAB & $HexNumber              & @CRLF & _
			 "err.lastdllerror is: "   & @TAB & $oMyError.lastdllerror   & @CRLF & _
			 "err.scriptline is: "     & @TAB & $oMyError.scriptline     & @CRLF & _
			 "err.source is: "         & @TAB & $oMyError.source         & @CRLF & _
			 "err.helpfile is: "       & @TAB & $oMyError.helpfile       & @CRLF & _
			 "err.helpcontext is: "    & @TAB & $oMyError.helpcontext _
			)
  SetError(1)  ; to check for after this function returns
Endfunc

Func _Exit()
	If _IsPressed("1b", $dll) Then
        MsgBox(0,"Esc Key Pressed", "Quit Application")
		Exit
    EndIf
EndFunc