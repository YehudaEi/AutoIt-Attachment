#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=dircompare.exe
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <File.au3>
#include <Array.au3>
#include <GuiButton.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiTab.au3>
#include <GuiListView.au3>
#include <GuiStatusBar.au3>
#include <Misc.au3>


Global $hGui, $rUpper, $rLower, $rNormal, $process1, $makefile, $make, $openfile, $open, $lcase, $ucase, $forward, $backward, $both, $path1, $path2
Global $afile, $bfile, $path1text, $path2text, $setpath1, $setpath2, $path1texts, $path2texts, $openpath1, $openpath2, $chkCreated, $chkModified, $chkAccessed, $chkSize
global $filepath = @ScriptDir & "\data\settings.dta", $stopwork = false, $hStatus, $remMatch
global $tabP1,$hListView1,$hListView2,$tab1,$tab2, $sep = "|",$currlinecount = 0, $B_DESCENDING = TRUE, $all, $none, $selected,$remove, $separator, $autoremove, $ruleint
global $copydest, $copy1dest, $copydestfolder, $setcopy, $opencopy, $copyfile, $copyfiledir, $rembeforecopy, $autocopy
if @year > 2012 Then
	msgbox(0,"Error 20-13","Contact Program Creator.")
	Exit
endif
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
OnAutoItExitRegister("savesettings")
creategui()
loadsettings()
main()

Func main()
	While 1
		Sleep(20)
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $process1
				selectall($hListView1)
				removefiles($hListView1)
				selectall($hListView2)
				removefiles($hListView2)
					process()
			Case $makefile
				If BitAND(GUICtrlRead($makefile), $GUI_CHECKED) = $GUI_CHECKED Then
					GUICtrlSetState($openfile, $GUI_ENABLE)
				Else
					GUICtrlSetState($openfile, $GUI_UNCHECKED)
					GUICtrlSetState($openfile, $GUI_DISABLE)
				EndIf
			case $setcopy
				if _GUICtrlButton_GetFocus($setcopy) = true then
					If GUICtrlRead($copydest) <> "" And FileExists(GUICtrlRead($copydest)) Then
						$copydestfolder = FileSelectFolder("Choose an source folder.", "", 3, GUICtrlRead($copydest))
					Else
						$copydestfolder = FileSelectFolder("Choose an source folder.", "", 3, @Desktopdir)
					EndIf
					If $copydestfolder <> "" Then
						GUICtrlSetData($copydest, $copydestfolder)
						$copyfiledir = $copydestfolder
						shortendir($copydestfolder, $copy1dest,70)
						GUICtrlSetTip($copyfile, "Copy all selected files to destination " & @crlf & $copydestfolder)
						$copydestfolder = ""
					EndIf
				endif
			case $opencopy
				if _GUICtrlButton_GetFocus($opencopy) = true then
					If GUICtrlRead($copydest) <> "" And FileExists(GUICtrlRead($copydest)) Then
						ShellExecute(GUICtrlRead($copydest))
					Else
						MsgBox(0, "Error", "Path does not exist")
					EndIf
				endif
			Case $setpath1
;~ 				_GUICtrlListView_SetColumn($hListView1, 0, "New Column 1", 150, 1)
				if _GUICtrlButton_GetFocus($setpath1) = true then
					If GUICtrlRead($path1text) <> "" And FileExists(GUICtrlRead($path1text)) Then
						$path1 = FileSelectFolder("Choose an source folder.", "", 2, GUICtrlRead($path1text))
					Else
						$path1 = FileSelectFolder("Choose an source folder.", "", 2, @Desktopdir)
					EndIf
					If $path1 <> "" Then
						GUICtrlSetData($path1text, $path1)
						shortendir($path1, $path1texts,70)
						$path1 = ""
					EndIf
				endif
			Case $openpath1
				if _GUICtrlButton_GetFocus($openpath1) = true then
					If GUICtrlRead($path1text) <> "" And FileExists(GUICtrlRead($path1text)) Then
						ShellExecute(GUICtrlRead($path1text))
					Else
						MsgBox(0, "Error", "Path does not exist")
					EndIf
				endif
			Case $setpath2
				if _GUICtrlButton_GetFocus($setpath2) = true then
					If GUICtrlRead($path2text) <> "" And FileExists(GUICtrlRead($path2text)) Then
						$path2 = FileSelectFolder("Choose an compare folder.", "", 2, GUICtrlRead($path2text))
					Else
						$path2 = FileSelectFolder("Choose an compare folder.", "", 2, @Desktopdir)
					EndIf
					If $path2 <> "" Then
						GUICtrlSetData($path2text, $path2)
						shortendir($path2, $path2texts,70)
						$path2 = ""
					EndIf
				endif
			Case $openpath2
				if _GUICtrlButton_GetFocus($openpath2) = true then
					If GUICtrlRead($path2text) <> "" And FileExists(GUICtrlRead($path2text)) Then
						ShellExecute(GUICtrlRead($path2text))
					Else
						MsgBox(0, "Error", "Path does not exist")
					EndIf
				endif
			case $hListView1
				$B_DESCENDING = not $B_DESCENDING
			case $hListView2
				$B_DESCENDING = not $B_DESCENDING
			case $all
				if _GUICtrlButton_GetFocus($all) = true then
					if _GUICtrlTab_GetCurSel($tabP1) = 0 Then
						selectall($hListView1)
					Else
						selectall($hListView2)
					endif

				endif
			case $none
				if _GUICtrlButton_GetFocus($none) = true then
					if _GUICtrlTab_GetCurSel($tabP1) = 0 Then
						deselectall($hListView1)
					Else
						deselectall($hListView2)
					endif
				endif
			case $selected
				if _GUICtrlButton_GetFocus($selected) = true then
					if _GUICtrlTab_GetCurSel($tabP1) = 0 Then
						sel($hListView1)
					Else
						sel($hListView2)
					endif
				endif
			case $remove
				if _GUICtrlButton_GetFocus($remove) = true then
					if _GUICtrlTab_GetCurSel($tabP1) = 0 Then
						removefiles($hListView1)
					Else
						removefiles($hListView2)
					endif
				endif
			case $remMatch
				if _GUICtrlButton_GetFocus($remMatch) = true then
					if _GUICtrlTab_GetCurSel($tabP1) = 0 Then
						removeMatches($hListView1)
					Else
						removeMatches($hListView2)
					endif
				endif
			case $copyfile
				If _GUICtrlButton_GetFocus($copyfile) = True Then
					copydir($hListView1,"Forward",$path1)
					copydir($hListView2,"Backward",$path2)
					deselectall($hListView1)
					deselectall($hListView2)
				EndIf

		EndSwitch
	WEnd
	Exit
EndFunc   ;==>main

func process()
;~ 				msgbox(0,"Process","Process")
local $tempN
	readsep()
	if _GUICtrlButton_GetFocus($process1) = true then
		for $tempN = 0 to 10
			_GUICtrlListView_SetColumn($hListView1, $tempN, "", 695/11)
		next
		for $tempN = 0 to 10
			_GUICtrlListView_SetColumn($hListView2, $tempN, "", 695/11)
		next
		setvar()
		setpaths()
;~ 			consolewrite($path1 & " " & @scriptdir & @crlf)
			if stringinstr($path1, @ScriptDir) then
				msgbox(0,"Error","Source path can not be within script program directory. Comparison Aborted!")
				return
			endif
;~ 			consolewrite($path2 & " " & @scriptdir & @crlf)
			if stringinstr($path2,@ScriptDir) then
				msgbox(0,"Error","Comparison path can not be within script program directory. Comparison Aborted!")
				return
			endif
;~ 			consolewrite($copyfiledir & " " & @scriptdir & @crlf)
			if stringinstr($copyfiledir,@ScriptDir) then
				msgbox(0,"Error","CopyTo path can not be within script program directory. Comparison Aborted!")
				return
			endif
		$stopwork = false
		$currlinecount = 0



		if BitAND(GUICtrlRead($ruleint), $GUI_CHECKED) = $GUI_CHECKED then
			intrulcheck($hListView1)
			intrulcheck($hListView2)
		endif
		if BitAND(GUICtrlRead($autoremove), $GUI_CHECKED) = $GUI_CHECKED then
;~ 			consolewrite(BitAND(GUICtrlRead($autoremove), $GUI_CHECKED) = $GUI_CHECKED & @crlf)
			removeMatches($hListView1)
			removeMatches($hListView2)
		endif
		if BitAND(GUICtrlRead($autocopy), $GUI_CHECKED) = $GUI_CHECKED then
			selectall($hListView1)
			selectall($hListView2)
			copydir($hListView1,"Forward",$path1)
			copydir($hListView2,"Backward",$path2)
			deselectall($hListView1)
			deselectall($hListView2)
		endif
	endif
endfunc


func copydir($LV,$text,$path)
	local $tempX, $itemcount, $copyfiledir1
	if BitAND(GUICtrlRead($rembeforecopy), $GUI_CHECKED) = $GUI_CHECKED then
		if fileexists($copyfiledir & "\" & $text) then
			DirRemove($copyfiledir & "\" & $text, 1)
		endif
	endif
	$itemcount = _GUICtrlListView_GetItemCount($LV)
	$copyfiledir = StringReplace($copyfiledir,"/","\")
	if stringright($copyfiledir,1) <> "\" Then
		$copyfiledir1 = $copyfiledir & "\" & $text
	endif
	if not fileexists($copyfiledir1) then
		dircreate($copyfiledir1)
	endif
	ProgressOn("Progress-Copying files-" & $text,"Progress...","",-1,-1)
	For $tempX = 0 to $itemcount

		ProgressSet(($tempX / $itemcount) * 100, "Copying... " & _GUICtrlListView_GetItemText($LV, $tempX, 0))
		sleep(10)
		if _GUICtrlListView_GetItemChecked($LV, $tempX) = True Then
			filecopy($path & "\" & _GUICtrlListView_GetItemText($LV, $tempX, 0),$copyfiledir1 & "\" & _GUICtrlListView_GetItemText($LV, $tempX, 0),9)
			consolewrite($path & "\" & _GUICtrlListView_GetItemText($LV, $tempX, 0) & " " & $copyfiledir1 & "\" & _GUICtrlListView_GetItemText($LV, $tempX, 0) & @crlf)
		endif
	next
		ProgressSet(100 , "Done", "Complete")
		progressoff()
endfunc

func intrulcheck($LV)
	local $tempcount1 = _GUICtrlListView_GetItemCount($LV)
	local $tempX, $filecol, $tempN, $colinfo, $tmpFile, $tmpText1, $tmpText2, $tmpFileMatch

#forceref $filecol
				for $tempN = 0 to _GUICtrlListView_GetColumnCount($LV)
					$colinfo = _GUICtrlListView_GetColumn($LV, $tempN)
					if $colinfo[5] = "File2" then
						$filecol = $tempN
						exitloop
					endif
				next
;~ 			consolewrite("$filecol:" & $filecol & @crlf)

	for $tempX = 0 to $tempcount1
;~ 		consolewrite(stringright(_GUICtrlListView_GetItemText($LV, $tempX, 0),4) & @crlf)
		if stringright(_GUICtrlListView_GetItemText($LV, $tempX, 0),4) = ".rul" then

			if fileexists($path1 & "\" & _GUICtrlListView_GetItemText($LV, $tempX, 0)) and fileexists($path2 & "\" & _GUICtrlListView_GetItemText($LV, $tempX, 0)) then
					$tmpFile = fileopen($path1 & "\" & _GUICtrlListView_GetItemText($LV, $tempX, 0),0)
					$tmpText1 = fileread($tmpFile)
					fileclose($tmpFile)
					$tmpFile = fileopen($path2 & "\" & _GUICtrlListView_GetItemText($LV, $tempX, 0),0)
					$tmpText2 = fileread($tmpFile)
					fileclose($tmpFile)
					$tmpFileMatch = comparefile($tmpText1,$tmpText2)
					if $tmpFileMatch = false then
						for $tempN = 0 to _GUICtrlListView_GetColumnCount($LV)
							$colinfo = _GUICtrlListView_GetColumn($LV, $tempN)
							consolewrite("$colinfo[5]1: " & " " & $colinfo[5] & " " & _GUICtrlListView_GetColumn($LV, $tempN) & " " & @crlf)
							if $colinfo[5] = "IntChk" then
								_GUICtrlListView_SetItemText($LV, $tempX, "X", $tempN)
								exitloop
							endif
						next
					endif
			else
				for $tempN = 0 to _GUICtrlListView_GetColumnCount($LV)
					$colinfo = _GUICtrlListView_GetColumn($LV, $tempN)
					consolewrite("$colinfo[5]2: " & " " & $colinfo[5] & " " & _GUICtrlListView_GetColumn($LV, $tempN) & " " & @crlf)
					if $colinfo[5] = "IntChk" then
						_GUICtrlListView_SetItemText($LV, $tempX, "X", $tempN)
						exitloop
					endif
				next
			endif
		endif
	next


endfunc

func comparefile($text1, $text2)
	local $tmpText[2], $tempX, $result
	$tmpText[0] = $text1
	$tmpText[1] = $text2
	for $tempX = 0 to 1
		$tmpText[$tempX] = stringreplace($tmpText[$tempX]," ","")
		$tmpText[$tempX] = stringreplace($tmpText[$tempX],@crlf,"")
		$tmpText[$tempX] = stringreplace($tmpText[$tempX],@tab,"")
	next
	$result = ($tmpText[0] = $tmpText[1])
	consolewrite("$result " & $result & @crlf)
	return $result
endfunc

func readsep()
	switch guictrlread($separator)
		case "Bar"
			$sep = "|"
		case "Tab"
			$sep = @tab
		case "Comma"
			$sep = ","
		case "Semi-Colon"
			$sep = ";"
		case "Dash"
			$sep = "-"


	endswitch
endfunc

func removeMatches($LV)

	Local $colInfo[1], $tempN, $columntext[1]
	local $file1, $file2, $created1, $created2, $modified1, $modified2, $accessed1, $accessed2, $size1, $size2, $rulecheck
	local $colCount = _GUICtrlListView_GetColumnCount($LV), $tempcount = _GUICtrlListView_GetItemCount($LV), $nomatch = false

	redim $columntext [$colcount + 1]

#forceref $file1, $file2, $created1, $created2, $modified1, $modified2, $accessed1, $accessed2, $size1, $size2, $rulecheck

	for $tempN = 0 to $colcount
		$colInfo = _GUICtrlListView_GetColumn($LV, $tempN)
		if $colinfo[5] <> "" then
			consolewrite($colinfo[5] & @crlf)
			$columntext[$tempN] = $colInfo[5]
		Else
			ExitLoop
		endif
	next


$file1 = _ArraySearch($columntext,"File1",0)
$file2 = _ArraySearch($columntext,"File2",0)
$created1 = _ArraySearch($columntext,"Created1",0)
$created2 = _ArraySearch($columntext,"Created2",0)
$modified1 = _ArraySearch($columntext,"Modified1",0)
$modified2 = _ArraySearch($columntext,"Modified2",0)
$accessed1 = _ArraySearch($columntext,"Accessed1",0)
$accessed2 = _ArraySearch($columntext,"Accessed2",0)
$size1 = _ArraySearch($columntext,"Size1",0)
$size2 = _ArraySearch($columntext,"Size2",0)
$rulecheck = _ArraySearch($columntext,"Size2",0)

consolewrite($file1 & " " & $file2 & " " & $created1 & " " & $created2 & " " & $modified1 & " " & $modified2 & " " & $accessed1 & " " & $accessed2 & " " & $size1 & " " & $size2 & @crlf)


for $tempN = 0 to $tempcount
	if ($file1 <> -1 and $file2 <> -1) Then
		if _GUICtrlListView_GetItemText($LV, $tempN, $file1) <> _GUICtrlListView_GetItemText($LV, $tempN, $file2) Then
;~ 			consolewrite("nomatch1 " & _GUICtrlListView_GetItemText($LV, $tempN, $file1) & " " &  _GUICtrlListView_GetItemText($LV, $tempN, $file2) & @crlf)
			$nomatch = true
		endif
	elseif $file1 = -1 and $file2 = -1 Then

	else
		$nomatch = true
;~ 		consolewrite("nomatch2" & @crlf)
	endif
	if $created1 <> -1 and $created2 <> -1 Then
		if _GUICtrlListView_GetItemText($LV, $tempN, $created1) <> _GUICtrlListView_GetItemText($LV, $tempN, $created2) then
			$nomatch = true
		endif
	elseif $created1 = -1 and $created2 = -1 Then

	else
		$nomatch = true
	endif
	if $accessed1 <> -1 and $accessed2 <> -1 Then
		if _GUICtrlListView_GetItemText($LV, $tempN, $accessed1) <> _GUICtrlListView_GetItemText($LV, $tempN, $accessed2) then
			$nomatch = true
		endif
	elseif $accessed1 = -1 and $accessed2 = -1 Then

	else
		$nomatch = true
	endif
	if $modified1 <> -1 and $modified2 <> -1 Then
		if _GUICtrlListView_GetItemText($LV, $tempN, $modified1) <> _GUICtrlListView_GetItemText($LV, $tempN, $modified2) then
			$nomatch = true
		endif
	elseif $modified1 = -1 and $modified2 = -1 Then

	else
		$nomatch = true
	endif
	if $size1 <> -1 and $size2 <> -1 Then
		if _GUICtrlListView_GetItemText($LV, $tempN, $size1) <> _GUICtrlListView_GetItemText($LV, $tempN, $size2) then
			$nomatch = true
		endif
	Elseif $size1 = -1 and $size2 = -1 then

	else
		$nomatch = true
	endif
	if _GUICtrlListView_GetItemText($LV, $tempN, $rulecheck) = "X" then
		$nomatch = true
	endif
	if $nomatch = true Then
		$nomatch = false
	Else
		_GUICtrlListView_SetItemChecked($LV, $tempN, True)
	endif

next
 removefiles($lv)

 			  	_GUICtrlStatusBar_SetText ($hStatus, _GUICtrlListView_GetItemCount($hListView1) & " source files")
				_GUICtrlStatusBar_SetText ($hStatus, _GUICtrlListView_GetItemCount($hListView2) & " compare files",1)
				_GUICtrlStatusBar_SetText ($hStatus, "",2)


endfunc


Func setvar()
	If GUICtrlRead($rLower) = $GUI_CHECKED Then
		$lcase = True
		$ucase = False
	ElseIf GUICtrlRead($rUpper) = $GUI_CHECKED Then
		$lcase = False
		$ucase = True
	Else
		$ucase = False
		$lcase = False
	EndIf
		$make = BitAND(GUICtrlRead($makefile), $GUI_CHECKED) = $GUI_CHECKED
		$open = BitAND(GUICtrlRead($openfile), $GUI_CHECKED) = $GUI_CHECKED
;~ 		consolewrite("setvar " & $make & @crlf)
;~ 		msgbox(0,"setvar","setvar")

EndFunc   ;==>setvar

Func creategui()
	Local $aParts[3] = [200, 400, -1]


	$hGui = GUICreate("Compare Directories", 800, 530)

	$process1 = GUICtrlCreateButton("Process", 10, 10, 90, 30)
	GUICtrlSetTip(-1, "Perform folder comparison")

	GUICtrlCreateGroup("File", 10, 45, 100, 60) ;create group
	$makefile = GUICtrlCreateCheckbox("Create", 20, 60, 50, 20)
	GUICtrlSetState($makefile, $GUI_CHECKED)
	GUICtrlSetTip(-1, "Create Delimited log file")
	$openfile = GUICtrlCreateCheckbox("Auto Open", 35, 80, 70, 20)
	GUICtrlSetState($openfile, $GUI_CHECKED)
	GUICtrlSetTip(-1, "Open Log file upon creation. ")

	GUICtrlCreateGroup("Force Case", 140, 10, 100, 95) ;create group
	$rNormal = GUICtrlCreateRadio("Normal", 150, 30, 50, 20)
	GUICtrlSetState($rNormal, $GUI_CHECKED)
	GUICtrlSetTip(-1, "Use default text case")
	$rLower = GUICtrlCreateRadio("Lower", 150, 50, 50, 20)
	GUICtrlSetTip(-1, "Force Lower text case")
	$rUpper = GUICtrlCreateRadio("Upper", 150, 70, 50, 20)
	GUICtrlSetTip(-1, "Force Upper text case")

	GUICtrlCreateGroup("Search Direction", 250, 10, 100, 95) ;create group
	$forward = GUICtrlCreateRadio("Forward", 260, 30, 60, 20)
	GUICtrlSetTip(-1, "Compare Source-> Comparison folder")
	$backward = GUICtrlCreateRadio("Backward", 260, 50, 70, 20)
	GUICtrlSetTip(-1, "Compare Comparison->Source folder")
	$both = GUICtrlCreateRadio("Both", 260, 70, 70, 20)
	GUICtrlSetTip(-1, "Compare Source->Comparision folder and Comparison->Source folder")
	GUICtrlSetState($both, $GUI_CHECKED)

	GUICtrlCreateGroup("Comparison", 360, 10, 180, 95) ;create group
	$chkCreated = GUICtrlCreateCheckbox("Created", 370, 30, 60, 20)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetTip(-1, "Check File Created Date")
	$chkModified = GUICtrlCreateCheckbox("Modified", 370, 50, 70, 20)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetTip(-1, "Check File Modified Date")
	$chkAccessed = GUICtrlCreateCheckbox("Accessed", 370, 70, 70, 20)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetTip(-1, "Check File Accessed Date")
	$chkSize = GUICtrlCreateCheckbox("Size", 470, 30, 60, 20)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetTip(-1, "Check File Size Date")


	GUICtrlCreateGroup("", 10, 100, 530, 90) ;create group

	GUICtrlCreateLabel("Source", 15, 110, 140, 20)
	$path1text = GUICtrlCreateLabel("", 15, 125, 400, 20)
	GUICtrlSetState(-1, $GUI_HIDE)
	$path1texts = GUICtrlCreateLabel("", 15, 125, 400, 20)
	$setpath1 = GUICtrlCreateButton("Set", 450, 125, 40, 20)
	GUICtrlSetTip(-1, "Set Source Path")
	$openpath1 = GUICtrlCreateButton("Open", 490, 125, 40, 20)
	GUICtrlSetTip(-1, "Open Source Path")

	GUICtrlCreateLabel("Compare", 15, 150, 140, 20)
	$path2text = GUICtrlCreateLabel("", 15, 165, 400, 20)
	GUICtrlSetState(-1, $GUI_HIDE)
	$path2texts = GUICtrlCreateLabel("", 15, 165, 400, 20)
	$setpath2 = GUICtrlCreateButton("Set", 450, 165, 40, 20)
	GUICtrlSetTip(-1, "Set Comparison Path")
	$openpath2 = GUICtrlCreateButton("Open", 490, 165, 40, 20)
	GUICtrlSetTip(-1, "Open Comparison Path")


	GUICtrlCreateGroup("Check", 710, 240, 85, 100)
	$all = GUICtrlCreateButton("All", 718, 253, 70, 25, $WS_GROUP)
	GUICtrlSetTip(-1, "Check all items.")
	$none = GUICtrlCreateButton("None", 718, 278, 70, 25, $WS_GROUP)
	GUICtrlSetTip(-1, "Uncheck all items.")
	$selected = GUICtrlCreateButton("Selected", 718, 303, 70, 25, $WS_GROUP)
	GUICtrlSetTip(-1, "Check selected items.")

	GUICtrlCreateGroup("Actions", 710, 333, 85, 100)
	$remove = GUICtrlCreateButton("Remove", 718, 348, 70, 25, $WS_GROUP)
	GUICtrlSetTip(-1, "Remove checked items. This does not delete files from the computer.")
	$remMatch = GUICtrlCreateButton("Rem Match", 718, 373, 70, 25, $WS_GROUP)
	GUICtrlSetTip(-1, "Searches for matching items and removes them from the list")
	$copyfile = GUICtrlCreateButton("Copy", 718, 398, 70, 25, $WS_GROUP)

	GUICtrlCreateGroup("Options", 550, 10, 245, 95) ;create group
	GUICtrlCreateLabel("Separator",560,30,47,18)
	$separator = GUICtrlCreateCombo("Bar", 615, 30, 80, 20) ; create first item
    GUICtrlSetData(-1, "Tab|Comma|Semi-Colon|Dash", "Bar") ; add other item snd set a new default
	GUICtrlSetTip(-1, "File Delimiter")
	$autoremove = GUICtrlCreateCheckbox("Remove Matches", 560, 60, 100, 20)
	GUICtrlSetTip(-1, "Automatically remove matches from lists")
	$ruleint = GUICtrlCreateCheckbox("rul Internal Check", 560, 80, 130, 20)
	GUICtrlSetTip(-1, "Compare internal contents of .rul files")
	$autocopy = GUICtrlCreateCheckbox("Auto Copy", 720, 60, 70, 20)
	GUICtrlSetTip(-1, "Automatically copy matches to CopyTo Forward and Backward folders")

	GUICtrlCreateGroup("", 550, 100, 245, 90) ;create group
	GUICtrlCreateLabel("Copy Destination",560,110,110,20)
	$rembeforecopy = GUICtrlCreateCheckbox("Clear Copy Sub-folders", 560, 165, 130, 20)
	GUICtrlSetTip(-1, "Clear copyto Forward and Backward sub-folders before copying files")
	GUICtrlSetState(-1, $GUI_CHECKED)
	$copydest = GUICtrlCreateLabel("",560,125,200,40)
	GUICtrlSetState(-1, $GUI_HIDE)
	$copy1dest = GUICtrlCreateLabel("",560,125,200,40)
	$setcopy = GUICtrlCreateButton("Set", 710, 165, 40, 20)
	GUICtrlSetTip(-1, "Set CopyTo Destination")
	$opencopy = GUICtrlCreateButton("Open", 750, 165, 40, 20)
	GUICtrlSetTip(-1, "Open CopyTo Destination")

	$tabP1 = GUICtrlCreateTab(10, 200, 700, 290)
	$tab1 = GUICtrlCreateTabItem("Forward")
	$hListView1 = GUICtrlCreateListView("", 12, 225, 695, 260,"",$LVS_EX_CHECKBOXES)
		_GUICtrlListView_InsertColumn($hListView1, 0, "Col 1", 695/11)
		_GUICtrlListView_InsertColumn($hListView1, 1, "Col 2", 695/11)
		_GUICtrlListView_InsertColumn($hListView1, 2, "Col 3", 695/11)
		_GUICtrlListView_InsertColumn($hListView1, 3, "Col 4", 695/11)
		_GUICtrlListView_InsertColumn($hListView1, 4, "Col 5", 695/11)
		_GUICtrlListView_InsertColumn($hListView1, 5, "Col 6", 695/11)
		_GUICtrlListView_InsertColumn($hListView1, 6, "Col 7", 695/11)
		_GUICtrlListView_InsertColumn($hListView1, 7, "Col 8", 695/11)
		_GUICtrlListView_InsertColumn($hListView1, 8, "Col 9", 695/11)
		_GUICtrlListView_InsertColumn($hListView1, 9, "Col 10", 695/11)
		_GUICtrlListView_InsertColumn($hListView1, 10, "Col 11", 695/11)
;~ 	_GUICtrlListView_AddItem($hListView1, "R1: C1", 0)
;~     _GUICtrlListView_AddSubItem($hListView1, 0, "R1: C2", 1)
;~     _GUICtrlListView_AddSubItem($hListView1, 0, "R1: C3", 2)

;~     _GUICtrlListView_AddItem($hListView1, "R2: C1", 1)
;~     _GUICtrlListView_AddSubItem($hListView1, 1, "R2: C2", 1)
;~ 	_GUICtrlListView_AddSubItem($hListView1, 1, "R2: C3", 2)

;~     _GUICtrlListView_AddItem($hListView1, "R3: C1", 2)
;~ 	_GUICtrlListView_AddSubItem($hListView1, 2, "R3: C2", 1)
;~ 	_GUICtrlListView_AddSubItem($hListView1, 2, "R3: C3", 2)

	$tab2 = GUICtrlCreateTabItem("Backward")
	$hListView2 = GUICtrlCreateListView("", 12, 225, 695, 258,"",$LVS_EX_CHECKBOXES)
		_GUICtrlListView_InsertColumn($hListView2, 0, "Col 11", 695/11)
		_GUICtrlListView_InsertColumn($hListView2, 1, "Col 12", 695/11)
		_GUICtrlListView_InsertColumn($hListView2, 2, "Col 13", 695/11)
		_GUICtrlListView_InsertColumn($hListView2, 3, "Col 14", 695/11)
		_GUICtrlListView_InsertColumn($hListView2, 4, "Col 15", 695/11)
		_GUICtrlListView_InsertColumn($hListView2, 5, "Col 16", 695/11)
		_GUICtrlListView_InsertColumn($hListView2, 6, "Col 17", 695/11)
		_GUICtrlListView_InsertColumn($hListView2, 7, "Col 18", 695/11)
		_GUICtrlListView_InsertColumn($hListView2, 8, "Col 19", 695/11)
		_GUICtrlListView_InsertColumn($hListView2, 9, "Col 20", 695/11)
		_GUICtrlListView_InsertColumn($hListView2, 11, "Col 21", 695/11)

		$hStatus = _GUICtrlStatusBar_Create($hGui)
		_GUICtrlStatusBar_SetParts($hStatus, $aParts)



	guisetstate()
EndFunc   ;==>creategui

Func setpaths()
	$path1 = GUICtrlRead($path1text)
	If $path1 <> "" Then
		$path2 = GUICtrlRead($path2text)
		If $path2 <> "" Then
			$afile = _FileListToArray($path1, "*.*", 1)
			$bfile = _FileListToArray($path2, "*.*", 1)
			consolewrite("setpaths " & @crlf)
			If GUICtrlRead($forward) = $GUI_CHECKED Then
				_GUICtrlTab_SetCurFocus($tabP1, 0)
				comparedir($afile,$bfile,@ScriptDir & "\resultsfor.txt",$hListView1,"Forward", $path1, $path2)

			ElseIf GUICtrlRead($backward) = $GUI_CHECKED Then
				_GUICtrlTab_SetCurFocus($tabP1, 1)
				comparedir($bfile,$afile,@ScriptDir & "\resultsback.txt",$hListView2,"Backward", $path2, $path1)
			Else
				_GUICtrlTab_SetCurFocus($tabP1, 0)
				comparedir($afile,$bfile,@ScriptDir & "\resultsfor.txt",$hListView1,"Forward", $path1, $path2)
				if $stopwork = false then
					comparedir($bfile,$afile,@ScriptDir & "\resultsback.txt",$hListView2,"Backward", $path2, $path1)
				endif
			EndIf
		Else
			MsgBox(0, "Error", "No Folder Selected for compare directory")
		EndIf
	Else
		MsgBox(0, "Error", "No Folder Selected for source directory")
	EndIf
EndFunc   ;==>setpaths

Func comparedir($array1,$array2,$logfile,$LV,$text,$tempPath1, $tempPath2)
	Local $found, $NotFound, $matchcount = 0, $notmatchcount = 0, $filecontents = "", $resfile
	Local $iIndex, $tempX, $tempafile[1], $tempbfile[1], $createda = "", $modifieda = "", $accesseda = "", $createdb = "", $modifiedb = "", $accessedb = ""
	local $logCreated, $logAccessed, $logModified, $tempnewline, $sepCreated = "", $sepAccessed = ""
	local $arraysize, $tempN
	local $temptext, $sepSize = "", $logSize, $sizeA, $sizeB, $coltext, $sepModified = ""
	local $txt1Created = "", $txt1Accessed = "", $txt1Modified = "", $txt1Size = ""
	local $txt2Created = "", $txt2Accessed = "", $txt2Modified = "", $txt2Size = "", $txtInt

#forceref $iIndex, $found, $notfound
	If IsArray($array1) And $array1[0] > 1 Then
		If IsArray($array2) And $array2[0] > 1 Then
			if $array1[0] > $array2[0] Then
				$arraysize = $array1[0]
			Else
				$arraysize = $array2[0]
			endif
			ProgressOn("Progress-" & $text & " comparison","Progress...","",-1,-1)
			redim $tempafile[$arraysize + 1]
			redim $tempbfile[$arraysize + 1]
			$tempafile[0] = $arraysize
			$tempbfile[0] = $arraysize
			$logCreated = BitAND(GUICtrlRead($chkCreated), $GUI_CHECKED) = $GUI_CHECKED
			$logModified = BitAND(GUICtrlRead($chkModified), $GUI_CHECKED) = $GUI_CHECKED
			$logAccessed = BitAND(GUICtrlRead($chkAccessed), $GUI_CHECKED) = $GUI_CHECKED
			$logSize = BitAND(GUICtrlRead($chkSize), $GUI_CHECKED) = $GUI_CHECKED
			If $lcase = True Then
				For $tempX = 1 To $tempafile[0]
					$tempafile[$tempX] = StringLower($array1[$tempX])
				Next
				For $tempX = 1 To $tempbfile[0]
					$tempbfile[$tempX] = StringLower($array2[$tempX])
				Next
			ElseIf $ucase = True Then
				For $tempX = 1 To $tempafile[0]
					$tempafile[$tempX] = StringUpper($array1[$tempX])
				Next
				For $tempX = 1 To $tempbfile[0]
					$tempbfile[$tempX] = StringUpper($array2[$tempX])
				Next
			Else
				For $tempX = 1 To $array1[0]
;~ 					consolewrite($arraysize & " " & $tempafile[0] & " " & $tempX )
;~ 					consolewrite($tempafile[$tempX] & " $afile[$tempX]: " & $array1[$tempX] & @crlf)
					$tempafile[$tempX] = $array1[$tempX]

				Next
				For $tempX = 1 To $array2[0]
;~ 					consolewrite($arraysize & " " & $tempbfile[0] & " " & $tempX & @crlf)
;~ 					consolewrite($tempbfile[$tempX] & " $bfile[$tempX]: " & $array2[$tempX] & @crlf)
					$tempbfile[$tempX] = $array2[$tempX]

				Next
			EndIf



			For $i = 1 To $tempafile[0]
				sleep(10)
;~ 				if $ < $bFile[0] then
				_GUICtrlListView_BeginUpdate($LV)
				ProgressSet(($i / $tempafile[0]) * 100, Round(($i / $tempafile[0]) * 100, 0))

				$iIndex = _ArraySearch($tempbfile, $tempafile[$i], 0, 0, 0, 2)
				If @error Then
					$notmatchcount += 1
					$NotFound &= $tempafile[$i] & @LF
					if $logCreated = true then
						$txt1Created = "Created1" & $sep
						$txt2Created = "Created2" & $sep
						if string($tempafile[$i]) <> "" then
							if fileexists($temppath1 & "\" & $tempafile[$i]) then
								$createda = gettime($temppath1 & "\" & $tempafile[$i],1, $i, $tempafile[0])
							Else
								$createda = $sep
							endif
						Else
							$createda = $sep
						endif
					Else
						$createda = $sep
					endif
					if $logModified = true then
						$txt1Modified = "Modified1" & $sep
						$txt2Modified = "Modified2" & $sep
						if string($tempafile[$i]) <> "" then
							if fileexists($temppath1 & "\" & $tempafile[$i]) then
								$modifieda = gettime($temppath1 & "\" & $tempafile[$i],	0, $i,$tempafile[0] )
							Else
								$modifieda = $sep
							endif
						Else
							$modifieda = $sep
						endif
					Else
						$modifieda = ""
					endif
					if $logAccessed = true then
						$txt1Accessed = "Accessed1" & $sep
						$txt2Accessed = "Accessed2" & $sep
						if string($tempafile[0]) <> "" then
							if fileexists($temppath1 & "\" & $tempafile[$i]) then
;~ 								consolewrite("$accesseda = gettime($temppath1 & $tempafile[$i],	2, $i, $tempafile[0]:::" & $temppath1 & "\" & $tempafile[$i] & @crlf)
								$accesseda = gettime($temppath1 & "\" & $tempafile[$i],	2, $i, $tempafile[0] )
;~ 								consolewrite($accesseda)
							Else
								$accesseda = $sep
							endif
						Else
							$accesseda = $sep
						endif
					endif
					if $logSize = true Then
						$txt1Size = "Size1" & $sep
						$txt2Size = "Size2" & $sep
						if string($tempafile[0]) <> "" then
							if FileExists($temppath1 & "\" & $tempafile[$i]) then
								$sizeA = filegetsize($temppath1 & "\" & $tempafile[$i]) & $sep
							Else
								$sizeA = $sep
							endif
						Else
							$sizeA = $sep
						endif
					EndIf
					if $logCreated = true then
						$tempnewline = $tempafile[$i] & $sep & $createda  & $modifieda & $accesseda & $sizea
					Else
						$tempnewline = $tempafile[$i] & $createda  & $modifieda & $accesseda & $sizea
					endif
						if stringright($tempnewline,1) = $sep Then
							$tempnewline = stringleft($tempnewline,stringlen($tempnewline) - 1)
						endif


					if string(stringreplace(stringreplace($tempnewline,$sep,""),"0","")) <> "" then
;~ 						ConsoleWrite(stringreplace($tempnewline,$sep,"") & @crlf)
						_addrow($LV,$tempnewline)
						$filecontents &= $tempnewline & @CRLF
					endif

					$tempnewline = ""
				Else
					$matchcount += 1
					$Found &= $tempafile[$i] & @LF
					if $logCreated = true then
						$createda = gettime($temppath1 & "\" & $tempafile[$i],1, $i, $tempafile[0])
						$createdb = gettime($temppath2 & "\" & $tempbfile[$iIndex],	1, $i,$tempbfile[0])
						$sepCreated = $sep
						$txt1Created = "Created1" & $sep
						$txt2Created = "Created2" & $sep
					Else
						$createda = ""
						$createdb = ""
					endif

					if $logModified = true then
						$modifieda = gettime($temppath1 & "\" & $tempafile[$i],	0, $i,$tempafile[0] )
						$modifiedb = gettime($temppath2 & "\" & $tempbfile[$iIndex],0,$i,$tempbfile[0])
						$sepModified = $sep
						$txt1Modified = "Modified1" & $sep
						$txt2Modified = "Modified2" & $sep
					Else
						$txt1Modified = ""
						$txt2Modified = ""
					endif

					if $logAccessed = true then
						$accesseda = gettime($temppath1 & "\" & $tempafile[$i],	2, $i, $tempafile[0] )
						$accessedb = gettime($temppath2 & "\" & $tempbfile[$iIndex],2, $i,$tempbfile[0] )
						$sepAccessed = $sep
						$txt1Accessed = "Accessed1" & $sep
						$txt2Accessed = "Accessed2" & $sep
;~ 					Else
;~ 						$txt1Accessed = ""
;~ 						$txt2Accessed = ""
					endif

					if $logSize = true Then
						$sizeA = filegetsize($temppath1 & "\" & $tempafile[$i]) & $sep
						if $i <= $tempbfile[0] then
							$sizeB = filegetsize($temppath2 & "\" & $tempbfile[$iIndex]) & $sep
						Else
							$sizeB = "0"
						endif
						$sepSize = $sep
						$txt1Size = "Size1" & $sep
						$txt2Size = "Size2" & $sep
;~ 					Else
;~ 						$txt1Size = ""
;~ 						$txt2Size = ""
					endif


;~ 					consolewrite($i & @crlf)
					$tempnewline = $tempafile[$i] & $sep & $createda  & $modifieda & $accesseda & $sizea & $tempbfile[$iIndex] & $sep & $createdb & $modifiedb & $accessedb & $sizeb
						if stringright($tempnewline,1) = $sep Then
							$tempnewline = stringleft($tempnewline,stringlen($tempnewline) - 1)
						endif


					$filecontents &=  $tempnewline & @CRLF
				EndIf
				if string(stringreplace(stringreplace($tempnewline,$sep,""),"0","")) <> "" then
					_addrow($LV,$tempnewline)
				endif
				$tempnewline = ""
			Next
		Else
			MsgBox(0, "Error", "Compare Directory contains no files")
			$stopwork = true
		EndIf
	Else
		MsgBox(0, "Error", "Source Directory contains no files")
		$stopwork = true
	EndIf
					if BitAND(GUICtrlRead($ruleint), $GUI_CHECKED) = $GUI_CHECKED then
						$txtInt = "IntChk" & $sep
					else
						$txtInt = $sep
					endif
	If StringLen($filecontents) > 0 Then
		consolewrite("make " & $make & @crlf)
		If Not @Compiled Then
;~ 			ConsoleWrite("Source Directory: " & $path1 & @CRLF & "Compare Directory: " & $path2 & @CRLF & @CRLF)
;~ 			ConsoleWrite("Same files: " & $matchcount & " matches found in " & $path2 & @CRLF & @CRLF & $Found & @CRLF)
;~ 			ConsoleWrite("Not Found files: " & $notmatchcount & " files missing in " & $path2 & @CRLF & @CRLF & $NotFound & @CRLF)
		EndIf
		If $make = True Then

			$temptext = "File1" & $sep & $txt1Created & $txt1Accessed & $txt1Modified & $txt1Size & "File2" & $sep & $txt2Created & $txt2Accessed & $txt2Modified & $txt2Size & $txtInt
			$temptext = stringleft($temptext,stringlen($temptext)-1)

			$coltext = stringsplit($temptext,$sep)

			for $tempN = 0 to $coltext[0]-1
				_GUICtrlListView_SetColumn($LV, $tempN, $coltext[$tempN + 1], 695/$coltext[0])
			next



			$resfile = FileOpen($logfile, 10)
			if $text = "Forward" then
						$filecontents = $afile[0] & " source files" & $sepCreated & $sepAccessed & $sepModified & $sepsize & $sep & _
										$bfile[0] & " compare files" & $sepCreated & $sepAccessed & $sepModified & $sepsize & $sep & _
										$matchcount & " matches;" & $notmatchcount & " missing" & @CRLF & _
										$temptext & @crlf & $filecontents & @crlf
			Else
						$filecontents = $bfile[0] & " compare files" & $sepCreated & $sepAccessed & $sepModified & $sepsize & $sep & _
										$afile[0] & " source files" & $sepCreated & $sepAccessed & $sepModified & $sepsize & $sep & _
										$matchcount & " matches;" & $notmatchcount & " missing" & @CRLF & _
										$temptext & @crlf & $filecontents & @crlf
			endif
			FileWrite($resfile, $filecontents)
			FileClose($resfile)
			Sleep(2000)
			If $open = True Then
				ShellExecute($logfile)
			EndIf

			  	_GUICtrlStatusBar_SetText ($hStatus,$afile[0] & " source files")
				_GUICtrlStatusBar_SetText ($hStatus, $bfile[0] & " compare files",1)
				_GUICtrlStatusBar_SetText ($hStatus, $matchcount & " matches; " & $notmatchcount & " missing",2)

		EndIf
			deselectall($hListView1)
			deselectall($hListView2)
		ProgressSet(100 , "Done", "Complete")
		progressoff()
		_GUICtrlListView_EndUpdate($LV)
	EndIf
EndFunc   ;==>comparedirforward

func gettime($path,$number,$number1,$number2)
	local $result, $t
;~ 	consolewrite("Path " & $path & @crlf)
	if $number1 <= $number2 then
		$t = filegettime($path,$number)
		if isarray($t) and $t[0] > 2 then
			$result = $t[0] & "/" & $t[1] & "/" & $t[2] & " " & $t[3] & ":" & $t[4] & ":" & $t[5] & $sep
		Else
			$result = $sep
		endif
	Else
		$result = $sep
	endif
	return $result
endfunc


Func savesettings()
	Local $file, $sData

	If GUICtrlRead($path1text) <> "" And GUICtrlRead($path2text) <> "" Then
		if not fileexists($filepath) then
			$file = FileOpen($filepath, 10)
			FileClose($file)
		EndIf

		$sData = "Path1=" & GUICtrlRead($path1text) & @crlf & "Path2=" & GUICtrlRead($path2text) & @crlf & "Dest=" & GUICtrlRead($copydest)
		IniWriteSection($filepath, "Paths", $sData)

		$sData = "Make=" & Guictrlread($makefile) & @crlf & "Open=" & guictrlread($openfile) & @crlf & _
					"Forward=" & GuiCtrlRead($forward) & @crlf & "Backward=" & guictrlread($backward) & @crlf & "Both=" & guictrlread($both) & @crlf & _
					"Created=" & guictrlread($chkCreated) & @crlf & "Modified=" & guictrlread($chkModified) & @crlf & "Accessed=" & guictrlread($chkAccessed) & _
					@crlf & "Size=" & guictrlread($chkSize) & @crlf & "Separator=" & guictrlread($separator) & @crlf & "AutoRemove=" & guictrlread($autoremove) & _
					@crlf & "RulInt=" & guictrlread($ruleint) & @crlf & "RemoveBeforeCopy=" & guictrlread($rembeforecopy) & @crlf & "AutoCopy=" & guictrlread($autocopy)
		IniWriteSection($filepath, "Options", $sData)


	EndIf

EndFunc   ;==>savesettings

Func loadsettings()
	local $var
	If FileExists($filepath) Then
		$var = IniReadSection($filepath, "Paths")
;~ 			consolewrite($line & @crlf)
		if $var[0][0] = 3 then
			If $var[1][1] <> "" And FileExists($var[1][1]) Then
				GUICtrlSetData($path1text, $var[1][1])
				shortendir($var[1][1], $path1texts,70)
			Else
				GUICtrlSetData($path1text, @Desktopdir)
				shortendir(@Desktopdir, $path1texts,70)
			EndIf

			If $var[2][1] <> "" And FileExists($var[2][1]) Then
				GUICtrlSetData($path2text, $var[2][1])
				shortendir($var[2][1], $path2texts,70)
			Else
				GUICtrlSetData($path2text, @Desktopdir)
				shortendir(@Desktopdir, $path2texts,70)
			EndIf

			If $var[3][1] <> "" And FileExists($var[3][1]) Then
				GUICtrlSetData($copydest, $var[3][1])
				shortendir($var[3][1], $copy1dest,70)
				if fileexists($var[3][1]) Then
					$copyfiledir = $var[3][1]
				Else
					$copyfiledir = "C:\"
				endif
				GUICtrlSetTip($copyfile, "Copy all selected files to destination " & @crlf & $copyfiledir)
			Else
				GUICtrlSetData($copydest, @Desktopdir)
				shortendir(@Desktopdir, $copy1dest,70)
			EndIf
		else
				GUICtrlSetData($path1text, @Desktopdir)
				shortendir(@Desktopdir, $path1texts,70)
				GUICtrlSetData($path2text, @Desktopdir)
				shortendir(@Desktopdir, $path2texts,70)
				GUICtrlSetData($copydest, @Desktopdir)
				shortendir(@Desktopdir, $copy1dest,70)
				msgbox(0,"Error","Problem with settings file, resetting paths to defaults")
		endif



		$var = IniReadSection($filepath,"Options")
		local $match = true
		for $i = 1 to $var[0][0]
			switch $var[$i][1]
				case "1","4","Bar","Semi-Colon","Tab","Dash","Comma"

				case Else
					$match = false
					ExitLoop
				Endswitch
		next

		if $match = false or $var[0][0] <> 14 Then
			guictrlsetstate($makefile,"1")
			GUICtrlSetState($openfile,"4")
			guictrlsetstate($forward,"4")
			GUICtrlSetState($backward,"4")
			guictrlsetstate($both,"1")
			guictrlsetstate($chkCreated,"4")
			guictrlsetstate($chkModified,"4")
			guictrlsetstate($chkAccessed,"4")
			guictrlsetstate($chkSize,"1")
			guictrlsetdata($separator,"Bar")
			guictrlsetstate($autoremove,"4")
			guictrlsetstate($ruleint,"4")
			guictrlsetstate($rembeforecopy,"1")
			guictrlsetstate($autocopy,"4")
			msgbox(0,"Error","Problem with settings file, resetting options to defaults")
		Else
			guictrlsetstate($makefile,$var[1][1])
			GUICtrlSetState($openfile,$var[2][1])
			guictrlsetstate($forward,$var[3][1])
			GUICtrlSetState($backward,$var[4][1])
			guictrlsetstate($both,$var[5][1])
			guictrlsetstate($chkCreated,$var[6][1])
			guictrlsetstate($chkModified,$var[7][1])
			guictrlsetstate($chkAccessed,$var[8][1])
			guictrlsetstate($chkSize,$var[9][1])
			guictrlsetdata($separator,$var[10][1])
			guictrlsetstate($autoremove,$var[11][1])
			guictrlsetstate($ruleint,$var[12][1])
			guictrlsetstate($rembeforecopy,$var[13][1])
			guictrlsetstate($autocopy,$var[14][1])
		endif


	EndIf
EndFunc   ;==>loadsettings


Func shortendir($line, $field,$len)
;~ 	consolewrite($line & " " & $field & @crlf)
	If StringLen($line) > $len Then
		GUICtrlSetData($field, (StringLeft($line, 3) & "..." & StringRight($line, $len-6)))
	Else
		GUICtrlSetData($field, $line)
	EndIf
EndFunc   ;==>shortendir

func reset()
	_GUICtrlStatusBar_SetText ($hStatus, "")
	_GUICtrlStatusBar_SetText ($hStatus, "",1)
	_GUICtrlStatusBar_SetText ($hStatus, "",2)
endfunc


func sel($LV)
	local $tempX
	for $tempX = 0 to _GUICtrlListView_GetItemCount($LV)
		if _GUICtrlListView_GetItemSelected($LV, $tempX) = true then
			_GUICtrlListView_SetItemChecked($LV, $tempX, True)
		endif
	next
EndFunc

func selectall($LV)
	local $tempX
	for $tempX = 0 to _GUICtrlListView_GetItemCount($LV)
		_GUICtrlListView_SetItemChecked($LV, $tempX, True)
	next
EndFunc

func deselectall($LV)
	local $tempX
	for $tempX = 0 to _GUICtrlListView_GetItemCount($LV)
		_GUICtrlListView_SetItemChecked($LV, $tempX, False)

	next

EndFunc

func deleteitems($LV)
	local $tempX, $itemcount
	#forceref $tempX
	_GUICtrlStatusBar_SetText ($hStatus, "")
	progresson("Processing...","Clearing Matches...")
	$itemcount = _GUICtrlListView_GetItemCount($LV)
	for $tempX = 0 to $itemcount
		_GUICtrlListView_DeleteItem($LV, 0)
		ProgressSet(($tempX / $itemcount) * 100 & " %", Round(($tempX / $itemcount) * 100 & " %", 0))
	next
	ProgressOff()

endfunc

func removefiles($LV)
	local $tempX, $tempY, $itemcount
	$itemcount = _GUICtrlListView_GetItemCount($LV)
	ProgressOn("Progress-Removing Files","Progress...","",-1,-1)
	For $tempX = $itemcount to 0 step -1
		$tempY += 1
		ProgressSet(($tempY / $itemcount) * 100, Round(($tempY / $itemcount) * 100, 0))

		if _GUICtrlListView_GetItemChecked($LV, $tempX) = True Then
;~ 			consolewrite($tempX & @crlf)
			_GUICtrlListView_DeleteItem(GUICtrlGetHandle($LV),$tempX)
			sleep(10)
		endif

	next
	ProgressSet(100 , "Done", "Complete")
	progressoff()
	if _GUICtrlListView_GetItemCount($LV) = 0 then
		_GUICtrlStatusBar_SetText ($hStatus, "")
	elseif _GUICtrlListView_GetItemCount($LV) = 1 then
		_GUICtrlStatusBar_SetText ($hStatus, "1 match")
	Else
		_GUICtrlStatusBar_SetText ($hStatus, _GUICtrlListView_GetItemCount($LV) & " matches")
	endif
endfunc

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)

    Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndListView, $tInfo,$tempfile, $tempdir, $hWndListView2
	local $pathbreak
	  #forceref $hWnd, $iMsg, $iwParam, $iIDFrom, $tInfo
    $hWndListView = $hListView1
	$hWndListView2 = $hListView2
    If Not IsHWnd($hListView1) Then $hWndListView = GUICtrlGetHandle($hListView1)
	If Not IsHWnd($hListView2) Then $hWndListView2 = GUICtrlGetHandle($hListView2)
    $tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
    $iCode = DllStructGetData($tNMHDR, "Code")
;~ 	consolewrite("wmnotify" & $tNMHDR & " " & $hWndFrom & " " & $iIDFrom & " " & $iCode & @crlf)
    Switch $hWndFrom
        Case $hWndListView
            Switch $iCode
                Case $LVN_COLUMNCLICK ; A column was clicked
                    $tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
                    _GUICtrlListView_SimpleSort($hWndListView, $B_DESCENDING, DllStructGetData($tInfo, "SubItem"))
						$B_DESCENDING = not $B_DESCENDING
                Case $NM_DBLCLK ; Sent by a list-view control when the user double-clicks an item with the left mouse button
                    $tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
					consolewrite("DllStructGetData(Index) " & DllStructGetData($tInfo, "Index") & " " & DllStructGetData($tInfo, "SubItem") & @crlf)
					if not @Compiled then
						consolewrite(@OSVersion & @crlf)
					endif
					if @OSVersion = "WIN_7"then
						$tempfile = $path1 & "\" &  _GUICtrlListView_GetItemTextString($hListView1,DllStructGetData($tInfo, "Index"))
						$pathbreak = StringSplit($tempfile,"|")
						$tempfile = $pathbreak[1]
					else
						$tempfile = $path1 & "\" & _GUICtrlListView_GetItemText($hListView1,DllStructGetData($tInfo, "Index"),DllStructGetData($tInfo, "SubItem"))
					endif
					sleep(10)
					if not @Compiled then
						consolewrite("Tempfile: " & $tempfile & @crlf)
					endif
					if FileExists($tempfile) then
						If _IsPressed("11") Then
							$tempdir = lastdir($tempfile)
							ShellExecute($tempdir)
						Else

							Switch stringright($tempfile,3)
								case "dll","ini","key","exe"

								case else
									ShellExecute($tempfile)

							EndSwitch
						endif
					Else
						msgbox(0,"Error","Unable to open file: " & @crlf & $tempfile)
					endif
				Case $LVN_ENDSCROLL
					_WinAPI_InvalidateRect($hListView1)
		EndSwitch
		Case $hWndListView2
            Switch $iCode
                Case $LVN_COLUMNCLICK ; A column was clicked
                    $tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
                    _GUICtrlListView_SimpleSort($hWndListView2, $B_DESCENDING, DllStructGetData($tInfo, "SubItem"))
							$B_DESCENDING = not $B_DESCENDING
                Case $NM_DBLCLK ; Sent by a list-view control when the user double-clicks an item with the left mouse button
                    $tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
;~ 					consolewrite("DllStructGetData(Index) " & DllStructGetData($tInfo, "Index") & " " & DllStructGetData($tInfo, "SubItem") & @crlf)
					if not @Compiled then
						consolewrite(@OSVersion & @crlf)
					endif
					if @OSVersion = "WIN_7"then
						$tempfile = $path2 & "\" &  _GUICtrlListView_GetItemTextString($hListView2,DllStructGetData($tInfo, "Index"))
						$pathbreak = StringSplit($tempfile,"|")
						$tempfile = $pathbreak[1]
					else
						$tempfile = $path2 & "\" & _GUICtrlListView_GetItemText($hListView2,DllStructGetData($tInfo, "Index"),DllStructGetData($tInfo, "SubItem"))
					endif
					sleep(10)
					if not @Compiled then
						consolewrite("Tempfile: " & $tempfile & @crlf)
					endif
					if FileExists($tempfile) then
						If _IsPressed("11") Then
							$tempdir = lastdir($tempfile)
							ShellExecute($tempdir)
						Else
							Switch stringright($tempfile,3)
								case "dll","ini","key","exe"

								case else
									ShellExecute($tempfile)
							EndSwitch
						endif
					Else
						msgbox(0,"Error","Unable to open file: " & @crlf & $tempfile)
					endif
				Case $LVN_ENDSCROLL
					_WinAPI_InvalidateRect($hListView2)

            EndSwitch
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func _AddRow($hWnd, $sItem)
	Local $sortorder
	;debugit
	Local $aItem = StringSplit($sItem, $sep)
	Local $iIndex = _GUICtrlListView_AddItem($hWnd, $aItem[1], 0, $currlinecount)
	For $x = 2 To $aItem[0]
		_GUICtrlListView_AddSubItem($hWnd, $iIndex, $aItem[$x], $x - 1, 0)
	Next
	$currlinecount += 1
	$sortorder = False
	_GUICtrlListView_SimpleSort($hWnd, $sortorder, 1)
EndFunc   ;==>_AddRow

func lastdir($file)
	local $testpath, $directory, $szDrive, $szDir, $szFName, $szExt
	#forceref $testpath
	$testpath = _PathSplit($file, $szDrive, $szDir, $szFName, $szExt)
	$directory = $szDrive & $szDir
	return($directory)
endfunc