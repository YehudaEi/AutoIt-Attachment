#cs ----------------------------------------------------------------------------

 Script Function:
	A Disk/CD/DVD Catalogue tool including search facility
	Scan - Indexes a Disk/CD/DVD to enable searching 
			includes a file mask
			Allows Multiple Catalogues for the same drive 
			.bak & .tmp files are excluded. Edit the Func IndexDrive($drive,$catalogue) to change this.
			
	Search - Searches existing Catalogues for a String
	        enables you to search only the filename or the full path
			(setup.exe is not much use, but if you know what directory it is in it helps)
			Selecting a file shows you what Catalogue it is in as well as what folder it is in
	
Use:
	Use SINGLE Clicks to select items
	Double Click to launche a selected file (including things like .txt,.mp3 files etc)
		(for best results here always use the same drive for scanning you CD's)
	
	The Include mask on the scan page follows autoit format. Multiple masks can be separated by a ;
		e.g. *.avi;*.mpg;*.mp?g;*.swf 
		*.mpg;*.mp* will not duplicate .mpg file entries (a file will only be included once for a single directory)
		*.jpg;*.jpeg will make sure you have all jpeg Files		
	
ToDo :
	Add an exclude mask to help the IndexDrive() function
	Merge ???-index.index and ???-master.index
	Include a Help --> About with some appropriate text/helpfile
	Think about enabling the cataloging of a directory and its children rather than an entire drive.

Other:
	Uses an updated _FileListToArray that accepts multiple file masks (re-named and included in this source.)
	It could probably do with optimisation as it is a little slow indexing all files on a pretty full 80 GB drive
	(works well on covermount CD's though)
	Includes blatant plagiarism from various sources on the forums.
	
#ce ----------------------------------------------------------------------------
#include <GUIConstants.au3>
#include <File.au3>
#include <Array.au3>
#Include <GuiList.au3>
#include <Constants.au3>
#NoTrayIcon

Opt("GUIOnEventMode", 1)

global $level
global $dirclicked
global $pos = 0
global $dirhistory[1] ; directory history
global $master [1] ;array containing list of directories for a catalogue
global $fileindex [1] ;index to files
global $filelist	; the index file containing the list of titles/filemanes
global $catalogue	; the current active Catalogue
global $catarray[1]	;array of catalogues
Global $WhatCatamiin [1]	; what catalogue is the selected file in
Global $FoundNames [1]

Global Const $WM_COMMAND    = 0x0111
Global Const $LBN_DBLCLK    = 2
GUIRegisterMsg($WM_COMMAND, "MY_DBL_CLICK")

Global $Searching = 0

#Region Main form
$MainForm = GUICreate("Catalogue", 610, 450, 200, 120)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
$Cats = GUICtrlCreateList("", 10, 10, 240, 150)
GUICtrlSetOnEvent(-1, "CatsClick")
$Dirs = GUICtrlCreateList("", 10, 168, 240, 266)
GUICtrlSetOnEvent(-1, "DirsClick")
$Files = GUICtrlCreateList("", 260, 40, 340, 400, $WS_BORDER+ $WS_VSCROLL)	; no Autosort
GUICtrlSetOnEvent(-1, "FilesClick")
$FullPath = GUICtrlCreateLabel("", 10, 420, 590, 28)
$ScanButton = GUICtrlCreateButton("Scan", 500, 8, 97, 25, 0)
GUICtrlSetOnEvent(-1, "ScanButtonClick")
$SearchButton = GUICtrlCreateButton("Search", 260, 8, 81, 25, 0)
GUICtrlSetOnEvent(-1, "SearchButtonClick")
#EndRegion 

#Region Drive Scan form
$ScanDlg = GUICreate("Select Drive to Scan", 316, 150, 347, 263)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
$ScanOK = GUICtrlCreateButton("&OK", 25, 90, 75, 25, 0)
GUICtrlSetOnEvent(-1, "ScanOKClick")
GUICtrlSetState(-1,$GUI_DEFBUTTON)  
$ScanCancel = GUICtrlCreateButton("&Cancel", 210, 90, 75, 25, 0)
GUICtrlSetOnEvent(-1, "CLOSEClicked")

$Label1 = GUICtrlCreateLabel("Drive :", 64, 5, 35, 17)
$Drive = GUICtrlCreateCombo("", 100, 5, 175, 21)
GUICtrlSetOnEvent(-1, "DriveChange")

$Label2 = GUICtrlCreateLabel("Catalogue Name :", 8, 30, 89, 17)
$CatName = GUICtrlCreateInput("", 100, 30, 180, 21)

$indexstatuslabel = GUICtrlCreateLabel("", 24, 115, 250, 25)

$Label3 = GUICtrlCreateLabel("Include Mask :", 24, 58, 89, 17)
$IncludeMask = GUICtrlCreateInput("*.*", 100, 58, 180, 21)


#EndRegion 

#Region Catalogue Search Form
$SearchDlg = GUICreate("Search for", 316, 90, 347, 263)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
$SearchOK = GUICtrlCreateButton("&OK", 22, 60, 75, 25, 0)
GUICtrlSetOnEvent(-1, "SearchOKClick")
GUICtrlSetState($SearchOK ,$GUI_DEFBUTTON)
$SearchCancel = GUICtrlCreateButton("&Cancel", 210, 60, 75, 25, 0)
GUICtrlSetOnEvent(-1, "CLOSEClicked")
$AllCats = GUICtrlCreateCheckbox("All Catalogues",24,2,100,14,$BS_AUTOCHECKBOX)
GUICtrlSetState($AllCats,$GUI_CHECKED)
$AndPath = GUICtrlCreateCheckbox("Search Directory Names",150,2,150,14,$BS_AUTOCHECKBOX)
GUICtrlSetState($AndPath ,$GUI_CHECKED)
$SearchStr = GUICtrlCreateInput("", 24, 28, 265, 21)
GUICtrlSetState($SearchStr,$GUI_FOCUS)
#EndRegion 


Init()	

GUISwitch($MainForm)
GUISetState(@SW_SHOW)

While 1
	Sleep(1000)
WEnd

#======================

Func Init()
	WhatDrives()
	ReadCats()
EndFunc

Func CatsClick()
	$Searching = 0
	_GUICtrlListClear ($Dirs)
	_GUICtrlListClear ($Files)
	_GUICtrlListAddItem ($Dirs,"..")
	$catalogue =  GUICtrlRead($Cats)
	if StringLen($catalogue) > 0 then	
		_FileReadToArray($catalogue & "-Master.index",$master)
		_FileReadToArray($catalogue & "-Index.index",$fileindex)
		For $loop = 1 to  $master[0]
			$array = StringSplit($master[$loop] , "|")
			If  $array[1] = 1 Then	
				_GUICtrlListAddItem ($Dirs,$array[2])
				$dirclicked = StringLeft($array[2],3)
			EndIf
		Next

		$pos = 1
		$level=1
		AddFiles()
	EndIf
EndFunc
		
Func DirsClick()
	$Searching = 0
	$dirclicked = GUICtrlRead($Dirs)
	_GUICtrlListClear ($Files)
	_GUICtrlListClear ($Dirs)
	_GUICtrlListAddItem ($Dirs,"..")
	If $dirclicked = ".." Then
		$level -= 1
		If $level < 1 Then
			$level = 1
		EndIf
		If $level = 1 Then
			CatsClick()
		EndIf
		$dirclicked = $dirhistory[$level - 1]
	Else
		$level += 1
	EndIf	
	
	$searchstrx = $level - 1  & "|" & $dirclicked
	If UBound($dirhistory) < $level Then
		_ArrayAdd($dirhistory,$dirclicked)
	Else
		$dirhistory[$level - 1] = $dirclicked
	EndIf
	$pos  = _ArraySearch($master,$searchstrx,1,$master[0],1)
	$searchstrx =  StringSplit($searchstrx,"\")
	If ($pos > 0) And ($pos + 1 <= $master[0]) Then
		AddFiles()
		For $loop = $pos + 1 to  $master[0]
			$array = StringSplit($master[$loop] , "|")
			If $array[0] > 1 Then
			$array2 =  StringSplit($array[2],"\")
			If $array[1] = $level Then
				If  $array2[$level] <> $searchstrx[$level] Then	
					ExitLoop
				EndIf
				If $array[1] = $level  Then
					_GUICtrlListAddItem ($Dirs,$dirclicked & "\" & $array2[$level+1])
				EndIf
			EndIf
			EndIf
		Next
	EndIf
	GUICtrlSetData($FullPath,$dirclicked)
EndFunc
		
Func AddFiles()	
	if $filelist Then FileClose($filelist)
	$filelist = FileOpen($catalogue & "-TitleList.index",0)
	$line = FileReadLine($filelist,$fileindex[$pos])
	While 1
		$array = StringSplit($line , "|")
		If $array[0] = 3 Then 
			if $array[2] <> $dirclicked Then ExitLoop	
			_GUICtrlListAddItem ($Files,$array[3])
			$line = FileReadLine($filelist)
		Else
			ExitLoop
		EndIf
	WEnd
	FileClose($filelist)
EndFunc

Func FilesClick()
	If $searching = 1 Then	
		$idx = _GUICtrlListSelectedIndex($Files)  + 1	; index of selected item
		_GUICtrlListSelectString($Cats,$catarray[$WhatCatamiin[$idx]])	; select the correct catalogue
		GUICtrlSetData($FullPath,$FoundNames[$idx])
	Else
	EndIf
EndFunc
		
Func ScanButtonClick()	; show the drive scan form
	GUISetState(@SW_SHOW, $ScanDlg)
	GUICtrlSetState($ScanOK,$GUI_ENABLE)
	GUICtrlSetState($ScanCancel,$GUI_ENABLE)
	DriveChange()	;make sure we pick up any disk change and update the label/catalogue
EndFunc
		
Func SearchButtonClick()	; show the search form
	GUISetState(@SW_SHOW, $SearchDlg)
	GUICtrlSetState($SearchStr,$GUI_FOCUS)
	GUICtrlSetState($SearchOK,$GUI_ENABLE)
	GUICtrlSetState($SearchCancel,$GUI_ENABLE)
EndFunc
		
Func DriveChange()
	GUICtrlSetData($CatName,DriveGetLabel(GUICtrlRead($Drive)))
EndFunc
		
Func ScanOKClick() ;start Scanning the Drive
	If DriveStatus ( GUICtrlRead($Drive)) <> "READY" Then
		MsgBox(0,"Drive Status", "Drive not ready!")
	Else
		IF StringLen(GUICtrlRead($CatName))<1 Then
			MsgBox(0,"Catalogue Name", "Invalid Catalogue Name!")
		Else
			GUICtrlSetState($ScanOK,$GUI_DISABLE)
			GUICtrlSetState($ScanCancel,$GUI_DISABLE)
			IndexDrive(GUICtrlRead($Drive),GUICtrlRead($CatName))
			GUISetState(@SW_HIDE,$ScanDlg)
		EndIf
	EndIf
	ReadCats()
EndFunc
		
Func SearchOKClick()	; Start the search
	GUICtrlSetState($SearchOK,$GUI_DISABLE)
	GUICtrlSetState($SearchCancel,$GUI_DISABLE)
	GUICtrlSetData($FullPath,"")
	
	ReDim $WhatCatamiin [1]
	ReDim $FoundNames [1]
	Local $SearchLine
	$Onecat = 1
	$SearchPath = 0
	
	If GUICtrlRead($AllCats) = $GUI_CHECKED Then
		$Onecat = 0
	EndIf
	If GUICtrlRead($AndPath) = $GUI_CHECKED Then
		$SearchPath = 1
	EndIf
	
	If $Onecat = 1 And StringLen(GUICtrlRead($Cats)) < 2 Then
		MsgBox(0,"Catalogue Search", "No Catalogue Selected!")
	Else
		_GUICtrlListClear ($Files)
		_GUICtrlListClear ($Dirs)
		if $filelist Then FileClose($filelist)
		If $Onecat = 0 Then
			$filelist = FileFindFirstFile("*-TitleList.index")
		Else
			$filelist = FileFindFirstFile($catalogue & "-TitleList.index")
		EndIf
		If $filelist <> -1 Then	; -1 means no more files to read
			$searchfor = GUICtrlRead($SearchStr)	
			While 1		; Loop thru index files
				$file = FileFindNextFile($filelist) 	
				If @error Then ExitLoop
				$filesearch=FileOpen($file,0)
				While 2 = 2							; loop thru records in the file
					$line = FileReadLine($filesearch)
					If @error = -1 Then 			; no more lines to read
						ExitLoop
					EndIf
					$sarray=StringSplit($line,"|")
					If $SearchPath = 1 Then
						$SearchLine = $sarray[2] & "\" & $sarray[3]
					Else
						$SearchLine = $sarray[3]
					EndIf
					If StringInStr($SearchLine,$searchfor) Then	; found what we are looking for 
						_GUICtrlListAddItem ($Files,$sarray[3])
						$idx = _ArraySearch($catarray,StringMid($file,1,StringLen($file)-16))
						_ArrayAdd ($FoundNames,$sarray[2])
						_ArrayAdd ($WhatCatamiin,_ArraySearch($catarray,StringMid($file,1,StringLen($file)-16)))			; what catalogue is this file in
					EndIf
				Wend
				FileClose($filesearch)
				If $Onecat = 1 Then ExitLoop
			WEnd
		EndIf
		FileClose($filelist)
		$Searching = 1
	EndIf
	GUISetState(@SW_HIDE,$SearchDlg)
EndFunc
		
Func CLOSEClicked()	; probably obvious?
	If @GUI_WINHANDLE = $MainForm  Then 
		Exit
	Else
		GUISetState(@SW_HIDE)
	EndIf 
EndFunc

Func ReadCats()	; read a list of catalogue file from the current directory
	_GUICtrlListClear ($Cats)
	$Search = FileFindFirstFile("*TitleList.index")
	If $search <> -1 Then
		While 1
			$file = FileFindNextFile($search) 
			If @error Then ExitLoop
			GUICtrlSetData($Cats,StringMid($file,1,StringLen($file)-16) & "|")
			_ArrayAdd($CatArray,StringMid($file,1,StringLen($file)-16))
		WEnd
	EndIf
	FileClose($search)
	CatsClick()
;~ 	_ArrayDisplay($CatArray,"")
EndFunc

Func WhatDrives()	;What drives are present on this PC
	$var = DriveGetDrive( "all" )	; what drives are there on this PC
	If NOT @error Then
		$drivestr = ""
		For $i = 1 to $var[0]
			$drivestr = StringUpper($drivestr & $var[$i]) & "\|"
		Next
		StringLeft($drivestr,stringlen($drivestr)-1)
		GUICtrlSetData($Drive,$drivestr)
	EndIf
EndFunc

Func IndexDrive($drive,$catalogue)	; Index the drive
	Local $dirarray[1] 
	$dirarray[0] = $drive 
	$foo = Run(@ComSpec & " /c dir " & $drive & " /A:D /B /S /O:N", @ScriptDir, @SW_HIDE, $STDOUT_CHILD)
	GUICtrlSetData($indexstatuslabel,"Reading Directories ")
	While 1
		$line = StdoutRead($foo)
		If @error Then ExitLoop
		$array = StringSplit($line , @CRLF)
		For $loop = 1 to $array[0]
			If StringLen($array[$loop]) > 0 Then
				_ArrayAdd($dirarray, $array[$loop])
			EndIf
		Next
	Wend
	GUICtrlSetData($indexstatuslabel,"Sorting Directories ")
	_ArraySort($dirarray)

	$master = FileOpen( $catalogue & "-Master.index",2)
	$masterindex = FileOpen( $catalogue & "-Index.index",2)
	$filelist = FileOpen($catalogue & "-TitleList.index",2)
	
	$filestart = 1
	For $loop = 0 To UBound($dirarray)-1
		$cnt = StringSplit($dirarray[$loop],"\")
		if $loop = 0 Then $cnt[0] = 0
		GUICtrlSetData($indexstatuslabel,$dirarray[$loop])
		; write master line
		FileWriteLine($master ,$cnt[0]-1 & "|" & $dirarray[$loop])
		FileWriteLine($masterindex ,$filestart)
		; write file list
		$filenames = MY_FileListToArray($dirarray[$loop] & "\",GUICtrlRead($IncludeMask),1)
		If @error = 0 Then
			For $loop2 = 1 To $filenames[0]
				$filestart += 1
				$fext = StringUpper(StringRight($filenames[$loop2],4))
				; change exclude files here (use UPPER CASE !!!)
				If $fext <> ".BAK" And $fext <> ".TMP" Then
					FileWriteLine($filelist ,$cnt[0]-1 & "|" & $dirarray[$loop] & "|"& $filenames[$loop2])
				EndIf
			Next
		EndIf
	Next
	GUICtrlSetData($indexstatuslabel,"")
	FileClose($master)
	FileClose($masterindex)
	FileClose($filelist)
EndFunc   

Func MY_DBL_CLICK($hWnd, $Msg, $wParam, $lParam)	; handle any double clicks on controls
    $nNotifyCode    = BitShift($wParam, 16)
    $nID            = BitAnd($wParam, 0x0000FFFF)	; Control ID of what was doubleclicked
    $hCtrl          = $lParam
    
    If $nID = $Files Then	; I have double clicked the files control
        Switch $nNotifyCode                    
		Case $LBN_DBLCLK
			; try and start whatever it is that I have doubleclicked.
			$runfile = @COMSPEC & " /c ""Start " & FileGetShortName(GUICtrlRead($FullPath) & "\" & GUICtrlRead($Files)) & """";save messing about with longfilenames & spaces
			RunWait($runfile,"",@SW_HIDE)
			Return 0
        EndSwitch
    EndIf
EndFunc

Func MY_FileListToArray($sPath, $sFilter = "*.*", $iFlag = 0)
; an updated version that accepts multiple file masks (needs to #include <Array.au3>)
	Local $hSearch, $sFile, $asFileList[1]
	local $filterarray = stringsplit($sFilter,";")
	
    If Not FileExists($sPath) Then Return SetError(1,1,"")
    If (StringInStr($sFilter, "\")) or (StringInStr($sFilter, "/")) or (StringInStr($sFilter, ":")) or (StringInStr($sFilter, ">")) or (StringInStr($sFilter, "<")) or (StringInStr($sFilter, "|")) or (StringStripWS($sFilter, 8) = "") Then Return SetError(2,2,"")
    If Not ($iFlag = 0 Or $iFlag = 1 Or $iFlag = 2) Then Return SetError(3,3,"")
	For $filters = 1 To $filterarray[0] 
		$sFilter = $filterarray[$filters ]
		$hSearch = FileFindFirstFile($sPath & "\" & $sFilter)
		If $hSearch = -1 Then ContinueLoop ; no files for this filter in this directory
		While 1
			$sFile = FileFindNextFile($hSearch)
			If @error Then 
				SetError(0)
				ExitLoop
			EndIf
			If $iFlag = 1 And StringInStr(FileGetAttrib($sPath & "\" & $sFile), "D") <> 0 Then ContinueLoop
			If $iFlag = 2 And StringInStr(FileGetAttrib($sPath & "\" & $sFile), "D") = 0 Then ContinueLoop
			If $filters > 1 Then	; only  do the check for the second array just to try keep the speed up a bit.
				If _ArraySearch($asFileList,$sFile) = -1 Then	; if this file is NOT already in the list then add it.
					ReDim $asFileList[UBound($asFileList) + 1]
					$asFileList[0] = $asFileList[0] + 1
					$asFileList[UBound($asFileList) - 1] = $sFile
				EndIf
			Else
				ReDim $asFileList[UBound($asFileList) + 1]
				$asFileList[0] = $asFileList[0] + 1
				$asFileList[UBound($asFileList) - 1] = $sFile
			EndIf
		WEnd
		FileClose($hSearch)
	Next
	Return $asFileList
EndFunc   ;==>_FileListToArray

