;#Include <Constants.au3>
;#include <File.au3>
;#include <EditConstants.au3>
;#include <WindowsConstants.au3>
#Include <GuiTab.au3>
#Include <GuiListBox.au3>
#include <GuiTreeView.au3>
#Include <GuiListView.au3>
#include <Array.au3>
#include <Date.au3>
Opt("TrayIconHide",1)

#region Functions
Func CheckExec()
	If GUICtrlRead($program) <> "" and _GUICtrlListBox_GetCount($hostlist) > 0 Then
		GUICtrlSetState($btnExecute,64)
	Else
		GUICtrlSetState($btnExecute,128)
	EndIf
EndFunc

Func BrowseHosts($debug = False)
	$domain = GetRootDSE()
	If $domain = "Failed" Then
		msgbox(0,"No Domain to Query","Not a member of a domain.")
		Return
	EndIf
	$arrComputers = GetComputers($domain)
	$arrSelectedHosts = DispComputers($arrComputers)
	If $debug <> False Then _ArrayDisplay($arrSelectedHosts)
	Return $arrSelectedHosts
EndFunc

Func DispComputers($arrComputers)
	Dim $tTreeArr[1]
	$tGui = GUICreate("Browse for Hosts",250,326,-1,-1,"","",$gui)
	$tTree = GUICtrlCreateTreeView(5,5,235,258,BitOr(256,55))
	$tSelectAll = GUICtrlCreateButton("Select All",85,270,75,20)
	$tDeSelectAll = GUICtrlCreateButton("Deselect All",165,270,75,20)
	$tOKBtn = GUICtrlCreateButton("OK",5,270,75,20)
		GUICtrlSetState(-1,$GUI_FOCUS)

	For $i = 0 to UBound($arrComputers) - 1
		$tTreeArr[$i] = GUICtrlCreateTreeViewItem($arrComputers[$i],$tTree)
		ReDim $tTreeArr[$i + 2]
	Next

	$tVarTreeCount = _GUICtrlTreeView_GetCount($tTree)
	GUISetState(@SW_SHOW,$tGui)

	While 1

		$msg = GUIGetMsg()

		If $msg = $tSelectAll Then
			For $i = 0 to $tVarTreeCount - 1
				GUICtrlSetState($tTreeArr[$i],1)
			Next
		EndIf

		If $msg = $tDeSelectAll Then
			For $i = 0 to $tVarTreeCount - 1
				GUICtrlSetState($tTreeArr[$i],4)
			Next
		EndIf

		If $msg = $tOKBtn Then
			Local $tStrSelectedHosts
			For $i = 0 to $tVarTreeCount - 1
				If BitAnd(GUICtrlRead($tTreeArr[$i]),1) Then
					$tStrSelectedHosts = $tStrSelectedHosts & GUICtrlRead($tTreeArr[$i],1) & ","
				EndIf
			Next
			GUIDelete($tGui)
			$tArrSelectedHosts = StringSplit($tStrSelectedHosts,",")
			_ArrayDelete($tArrSelectedHosts,0)
			_ArrayDelete($tArrSelectedHosts,UBound($tArrSelectedHosts)-1)
			Return $tArrSelectedHosts
		EndIf

	WEnd
EndFunc

Func ExecMethod($psexecloc,$hostname,$execfile,$context,$wrkdir="",$args="",$debug = False)
	$strExe = $psexecloc
	$strExe = $strExe & " \\" & $hostname
	Select
		Case $context = "Interactive"
			$strExe = $strExe & " -i "
		Case $context = "Non-Interactive"
			$strExe = $strExe & " "
		Case $context = "System"
			$strExe = $strExe & " -s "
		Case $context = "System Interactive"
			$strExe = $strExe & " -s -i "
	EndSelect
	$strExe = $strExe & "-d -c -f "
	If $wrkdir <> "" Then $strExe = $strExe & "-w " & $wrkdir
	$strExe = $strExe & Chr(34) & $execfile & Chr(34)
	If $args <> "" Then $strExe = $strExe & " " & $args
	If $debug <> False Then
		Msgbox(0,"exec cmd",$strExe)
		ClipPut(@ComSpec & " /c " & $strExe & " 2> C:\psexec.Log")
	Else
		RunWait(@ComSpec & " /c " & $strExe &" 2> C:\" & $hostname & "psexec.Log","",@SW_HIDE)
	EndIf
EndFunc

Func ExecStatus($indx,$strHost,$strStatus,$strResult = "")
	$list = GUICtrlGetHandle($tListView)
	_GUICtrlListView_DeleteItem($list,$indx)
	_GUICtrlListView_InsertItem($list,$strHost,$indx)
	_GUICtrlListView_AddSubItem($list,$indx,$strStatus,1)
	If $strResult <> "" Then _GUICtrlListView_AddSubItem($list,$indx,$strResult,2)
EndFunc

Func ExecStatusInfo($indx,$strHost)
	$tmpfile = FileOpen("C:\" & $strHost & "psexec.Log",0)
	$strStatus = FileRead($tmpfile)
	FileClose($tmpfile)
	FileDelete("C:\" & $strHost & "psexec.Log")
	If StringInstr($strStatus,"Process ID") > 0 Then
		$str = StringRight($strStatus,StringLen($strStatus) - StringInstr($strStatus,"Process ID") + 1)
		$str = StringLeft($str,StringInstr($str,"."))
		ExecStatus($indx,$strHost,"Finished",$str)
		Return
	EndIf

	If StringInstr($strStatus,"error copying") > 0 Then
		ExecStatus($indx,$strHost,"Error copying file to host.","Failed")
		Return
	EndIf

	ExecStatus($indx,$strHost,"Failed to Execute.","Failed")
	Return
EndFunc

Func ExecStatusWin()
	$tGui = GUICreate("Execution Status",450,400,-1,-1,458752)
	$tListView = GUICtrlCreateListView("Hostname|Status|Result",0,0,448,380)
		_GUICtrlListView_SetColumnWidth ($tListView, 0, 100)
		_GUICtrlListView_SetColumnWidth ($tListView, 1, 160)
		_GUICtrlListView_SetColumnWidth ($tListView, 2, 100)
	GUISetState(@SW_SHOW,$tGui)
	Return WinGetHandle("Execution Status")
EndFunc

Func GetComputers($domainname)
	$objComputers = ObjGet("LDAP://CN=Computers," & $domainname)
	local $strComputers
	For $obj In $objComputers
		$strComputers = $strComputers & $obj.Name & ","
	Next
	$obj = ""
	$objComputers = ""
	$strComputers = StringLeft($strComputers,StringLen($strComputers)-1)
	$strComputers = StringReplace($strComputers,"CN=","")
	$arrComputers = StringSplit($strComputers,",")
	_ArrayDelete($arrComputers,0)
	_ArraySort($arrComputers)
	Return $arrComputers
EndFunc

Func GenPSEXEC($host)
	FileInstall("psexec.exe","C:\" & $host & "psexec.exe")
	$psexecpath = "C:\" & $host & "psexec.exe"
	Return $psexecpath
EndFunc

Func GetRootDSE()
	$RootDSE = ObjGet("LDAP://RootDSE")
	If IsObj($RootDSE) Then
		Return $RootDSE.get( "DefaultNamingContext" )
	Else
		Return "Failed"
	EndIf
EndFunc
#endregion

#region Main GUI
	Global $gui, $tGui, $tListView, $ExecStatWin, $execLog
	$gui = GUICreate("RemoteIT - Remote Execution Tool",400,300,-1,-1)
	$mnuFile = GUICtrlCreateMenu("&File")
		$mnuSeparator = GUICtrlCreateMenuitem ("",$mnuFile,2)
		$mnuExit = GUICtrlCreateMenuitem ("E&xit",$mnuFile)
	$btnExecute = GUICtrlCreateButton("&Execute",205,243,90,30)
		GUICtrlSetState(-1,128)
	$btnQuit = GUICtrlCreateButton("&Quit",305,243,90,30)
	$tabs = GUICtrlCreateTab(5,0,390,234)
	$tabExecute = GUICtrlCreateTabItem("Action")
		$label0 = GUICtrlCreateLabel("* = Optional",320,32,75,22)
		$btnNext1 = GUICtrlCreateButton("&Next",105,243,90,30)
		$label1 = GUICtrlCreateLabel("Executable: ",26,60,75,22)
		$program = GUICtrlCreateInput("",90,57,250,22,2176)
		$btnProgram = GUICtrlCreateButton("...",345,57,22,22)
			GUICtrlSetState(-1,$GUI_FOCUS)
		$label2 = GUICtrlCreateLabel("* Working Dir: ",16,100,80,22)
		$directory = GUICtrlCreateInput("",90,97,250,22,2176)
		$btnDir = GUICtrlCreateButton("...",345,97,22,22)
		$label3 = GUICtrlCreateLabel("* Arguments: ",22,140,80,22)
		$arguments = GUICtrlCreateInput("",90,137,250,22)
		$label4 = GUICtrlCreateLabel("Context: ",44,180,80,22)
		$context = GUICtrlCreateCombo("",90,177,120,22)
			GUICtrlSetData(-1,"Interactive|System|System Interactive|Non-Interactive","Interactive")
		$btnTestLocal = GUICtrlCreateButton("&Test Local",250,177,90,22)
			GUICtrlSetState(-1,64)
	$tabHosts = GUICtrlCreateTabItem("Hosts")
		$btnPrev1 = GUICtrlCreateButton("&Previous",5,243,90,30)
		$btnNext2 = GUICtrlCreateButton("&Next",105,243,90,30)
		$hostlist = GUICtrlCreateList("",10,27,290,201)
		$btnAdd = GUICtrlCreateButton("&Add",305,28,83,22)
		$btnRemove = GUICtrlCreateButton("&Remove",305,58,83,22)
		$btnBrowse = GUICtrlCreateButton("&Browse",305,88,83,22)
		$btnClear = GUICtrlCreateButton("&Clear",305,118,83,22)
		$btnLoad = GUICtrlCreateButton("&Load",305,175,83,22)
		$btnSave = GUICtrlCreateButton("&Save",305,205,83,22)
	$tabFilter = GUICtrlCreateTabItem("Filters")
		$btnPrev2 = GUICtrlCreateButton("&Previous",5,243,90,30)

	GUISetState()

	While 1

		$msg = GUIGetMsg()

		If $msg = $btnAdd Then
			$hosttoadd = InputBox("Hostname:","Enter a hostname.","","",200,120)
			If $hosttoadd Then
				_GUICtrlListBox_AddString($hostlist,StringUpper($hosttoadd))
				CheckExec()
			EndIf
		EndIf

		If $msg = $btnBrowse Then
			$hosttoadd = BrowseHosts()
			If IsArray($hosttoadd) And $hosttoadd[0] <> "" Then
				For $i = 0 to UBound($hosttoadd) - 1
					_GUICtrlListBox_AddString($hostlist,$hosttoadd[$i])
				Next
				CheckExec()
			EndIf
		EndIf

		If $msg = $btnClear Then
			_GUICtrlListBox_ResetContent($hostlist)
			CheckExec()
		EndIf

		If $msg = $btnDir Then
			$wrkDir = FileSelectFolder("Working Directory","C:\")
			If $wrkDir <> "" Then GUICtrlSetData($directory,$wrkDir)
		EndIf

		If $msg = $btnExecute Then
			$ExecStatWin = ExecStatusWin()
			$execfilevar = GUICtrlRead($program)
			$contextvar = GUICtrlRead($context)
			$wrkdirvar = GUICtrlRead($directory)
			$argsvar = GUICtrlRead($arguments)
			$logfilename = StringReplace(_NowTime(5),":","") & "remoteit.log"
			$execLog = FileOpen(@TempDir & "\" & $logfilename,2)
			FileWrite($execLog,_Now() & @CRLF & "EXE: " & $execfilevar & @CRLF & "DIR: " & $wrkdirvar & @CRLF & "ARGS: " & $argsvar & @CRLF & "Context: " & $contextvar & @CRLF & @CRLF)
			For $i = 0 to _GUICtrlListBox_GetCount($hostlist) - 1
				$hostnamevar = _GUICtrlListBox_GetText($hostlist,$i)
				If StringUpper($hostnamevar) = StringUpper(@ComputerName) Then $hostnamevar = "127.0.0.1"
				If $hostnamevar = "LOCALHOST" Then $hostnamevar = "127.0.0.1"
				ExecStatus($i,$hostnamevar,"Attempting connection...")
				If Ping($hostnamevar) Then
					ExecStatus($i,$hostnamevar,"Executing...")
					$psexecpath = GenPSEXEC($hostnamevar)
					ExecMethod($psexecpath,$hostnamevar,$execfilevar,$contextvar,$wrkdirvar,$argsvar)
					ExecStatusInfo($i,$hostnamevar)
					FileWrite($execLog,_GUICtrlListView_GetItemTextString(GUICtrlGetHandle($tListView),$i))
					FileDelete($psexecpath)
				Else
					ExecStatus($i,$hostnamevar,"Failed to ping...","Failed")
				EndIf
			Next
			FileClose($execLog)
			Msgbox(0,"Execution Complete","Finished")
		EndIf

		If $msg = $btnLoad Then
			$hostfile = FileOpenDialog("Hostname List",@WorkingDir,"Text files (*.txt)",1)
			If $hostfile <> "" Then
				$hosttoadd = ""
				_FileReadToArray($hostfile,$hosttoadd)
				_ArrayDelete($hosttoadd,0)
				If IsArray($hosttoadd) And $hosttoadd[0] <> "" Then
					For $i = 0 to UBound($hosttoadd) - 1
						_GUICtrlListBox_AddString($hostlist,StringUpper($hosttoadd[$i]))
					Next
					CheckExec()
				EndIf
			EndIf
		EndIf

		If $msg = $btnNext1 Then GUICtrlSetState($tabHosts,$GUI_SHOW)

		If $msg = $btnNext2 Then GUICtrlSetState($tabFilter,$GUI_SHOW)

		If $msg = $btnPrev1 Then GUICtrlSetState($tabExecute,$GUI_SHOW)

		If $msg = $btnPrev2 Then GUICtrlSetState($tabHosts,$GUI_SHOW)

		If $msg = $btnProgram Then
			$exec = FileOpenDialog("Executable",@WorkingDir,"Executables (*.exe)",1)
			If $exec <> "" Then
				GUICtrlSetData($program,$exec)
				CheckExec()
			EndIf
		EndIf

		If $msg = $btnRemove Then
			If _GUICtrlListBox_GetCount($hostlist) > 0 Then
				$idx = _GUICtrlListBox_GetCurSel($hostlist)
				If $idx > -1 Then _GUICtrlListBox_DeleteString($hostlist,$idx)
				CheckExec()
			EndIf
		EndIf

		If $msg = $btnSave Then
			$hostfile = FileSaveDialog("Save Hostname List",@workingdir,"Text files (*.txt)",18,"hostlist.txt")
			If $hostfile <> "" Then
				$wrkfile = FileOpen($hostfile,2)
				For $i = 0 to _GUICtrlListBox_GetCount($hostlist) - 1
					FileWriteLine($hostfile,_GUICtrlListBox_GetText($hostlist,$i))
				Next
				FileClose($wrkfile)
				msgbox(0,"Hostname list Created","File Saved Successfully")
			EndIf
		EndIf

		If $msg = $btnTestLocal Then
			$hostnamevar = "127.0.0.1"
			$psexecvar = GenPSEXEC($hostnamevar)
			$execfilevar = GUICtrlRead($program)
			If $execfilevar <> "" Then
				$contextvar = GUICtrlRead($context)
				$wrkdirvar = GUICtrlRead($directory)
				$argsvar = GUICtrlRead($arguments)
				$psexecpath = GenPSEXEC($hostnamevar)
				ExecMethod($psexecvar,$hostnamevar,$execfilevar,$contextvar,$wrkdirvar,$argsvar)
				FileDelete($psexecvar)
				FileDelete("C:\" & $hostnamevar & "psexec.Log")
			EndIf
		EndIf

		If $msg = $mnuExit Or $msg = $GUI_EVENT_CLOSE or $msg = $btnQuit Then
			If WinActive("Execution Status") Then
				GUISwitch($tGui)
				GUIDelete()
			Else
				Exit
			EndIf
		EndIf

	WEnd
#endregion