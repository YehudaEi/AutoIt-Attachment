;~ Coded by Ian Maxwell (llewxam)
;~ AutoIt 3.3.6.1
;~ Amended by Jamie Cowin
;~ Includes transparent code from UEZ 20011
;~ Code for getting command line options from here http://www.autoitscript.com/forum/topic/88214-winapi-getcommandlinefrompid-from-any-process/
;~ Code for getting exe location from pid from here http://www.autoitscript.com/forum/topic/49888-find-the-path-of-a-exe-files-running-the-the-handlepid/
;~ Code for getting window selected http://www.autoitscript.com/forum/topic/129401-winselect-allows-user-to-select-window/page__p__898784__hl__select+window__fromsearch__1#entry898784
#include <GUIConstantsEx.au3>
#include <GDIPlus.au3>
#include <WindowsConstants.au3>                     ;needed for $WS_CAPTION, $WS_VSCROLL, $WM_COMMAND
#include <array.au3>                                ;needed for _ArrayAdd, _ArrayDelete, _ArrayUnique, _ArraySort, _ArrayBinarySearch
#include <ProgressConstants.au3>                    ;needed for $PBS_SMOOTH, $PBS_MARQUEE
#include <GuiListBox.au3>                           ;needed for $LBS_NOTIFY, $LBS_SORT, $LBS_NOSEL, $GUI_RUNDEFMSG, _GUICtrlListBox_* functions
#include <WinAPI.au3>
#include <EditConstants.au3>
#include "WinSelect.au3"
#include <GuiListView.au3>


_GetPrivilege_SEDEBUG() ; I need this for tricky processes. Not needed for most...

AdlibRegister("_Alive", 50)
AdlibRegister("_Scan")

Global $sSft
$strCompName = @ComputerName
$oFile = @scriptdir &"\"& $strCompName & ".html"
Global $hGUI, $hImage, $hGraphic, $hImage
Global Const $SC_DRAGMOVE = 0xF012

;~ uninst stuff


Global $i
Local $JsJft
Global $sGui = GUICreate('Currently Installed Software', 810, 650, -1, -1)
Global $sLvw = GUICtrlCreateListView('#|Installed Software|Display Version|Publisher|Uninstall String', 5, 5, 800, 600)

;~ end of uninst

$exceptionList = "Process Killer.exe,[System Process],System,smss.exe,csrss.exe,wininit.exe,csrss.exe,services.exe,winlogon.exe,lsass.exe,lsm.exe,svchost.exe,atiesrxx.exe,audiodg.exe,CTAudSvc.exe,atieclxx.exe,spoolsv.exe,taskhost.exe,dwm.exe,explorer.exe,rundll32.exe,GoogleCrashHandler.exe,MOM.exe,CCC.exe,SearchIndexer.exe,wmpnetwk.exe,SearchProtocolHost.exe,SearchFilterHost.exe,dllhost.exe,mpcmdrun.exe,msiexec.exe,unsecapp.exe,vds.exe,WmiPrvSE.exe"
$exceptions = StringSplit($exceptionList, ",") ;list of what not to kill
Local $pList[1] ;list of running processes
$pListOld = $pList ;to compare a previous process list, so $liveProc is only updated if the process list changes
Local $killList[1] ;list of processes to kill
$liveProcCount = 0 ;tally of processes running
$killProcCount = 0 ;tally of processes to be killed
$killListTrimmed = False ;flag for detecting when $killList has been trimmed
$goNuclear = False ;flag set by /nuke command line switch
$started = False ;used in Nuke mode to avoid crashes due to no GUI


;check for and run nuke
If $CmdLine[0] Then ;many viruses/spyware apps suppress EXEs from running, nuke mode is meant to sneak
	For $c = 1 To $CmdLine[0] ;PPK in before it can be suppressed.  Just run "ppk /nuke" or "ppk nuke" repeatedly until it starts
		If StringLower($CmdLine[$c]) == "/nuke" Or StringLower($CmdLine[$c]) == "nuke" Then $goNuclear = True
	Next
EndIf
If $goNuclear == True Then
	$pListRaw = ProcessList()
	If @error Then
		MsgBox(48, "ERROR", "The process list could not be built!")
		Exit
	EndIf
	Local $pListTemp[1] ;used to get the list of running processes down to a 1-dimensional array
	For $a = 1 To $pListRaw[0][0]
		_ArrayAdd($pListTemp, $pListRaw[$a][0])
	Next
	_ArrayDelete($pListTemp, 0)
	$pList = _ArrayUnique($pListTemp)

	If $pList[0] > 0 Then
		Local $killList[1]
		For $a = 1 To $pList[0]
			For $b = 1 To $exceptions[0]
				If StringLower($pList[$a]) == StringLower($exceptions[$b]) Then ContinueLoop (2)
			Next
			_Execute($pList[$a])
			_ArrayAdd($killList, $pList[$a])
		Next
	EndIf
	_ArrayDelete($killList, 0)
	$goNuclear = False
EndIf

_GDIPlus_Startup()
; Load PNG image
$hImage = _GDIPlus_ImageLoadFromFile("process killer2.png")
$iWidth = _GDIPlus_ImageGetWidth($hImage)
$iHeight = _GDIPlus_ImageGetHeight($hImage)

; Create GUI
$hGUI = GUICreate("Show PNG", $iWidth, $iHeight, -1, -1, $WS_POPUP, $WS_EX_LAYERED + $WS_EX_TOPMOST)
$hGUI_child = GUICreate("", $iWidth, $iHeight, 0, 0, $WS_POPUP, $WS_EX_LAYERED + $WS_EX_TOPMOST + $WS_EX_MDICHILD, $hGUI)
$ExitButton1 = GUICtrlCreateButton("Exit", 280, 471, 65, 40)
GUICtrlSetTip(-1, "Exits the Program")
$NukeButton = GUICtrlCreateButton("Nuke!", 388, 471, 65, 40)
GUICtrlSetTip(-1, "Nukes Everything except important system processes")
$AboutButton = GUICtrlCreateButton("About", 388, 421, 65, 40)
GUICtrlSetTip(-1, "Show the about information in the Data window")
$GoogleButton = GUICtrlCreateButton("Google", 721, 32, 65, 30)
GUICtrlSetTip(-1, "Google search the program selected in the running process window")
$ProcesslibraryButton = GUICtrlCreateButton("Check Process Library", 975, 327, 144, 30)
GUICtrlSetTip(-1, "Searches the process library for the program selected in the running process window")
$PathButton = GUICtrlCreateButton("Path", 864, 32, 65, 30)
GUICtrlSetTip(-1, "Gets the path of the program selected in the running process window")
$CommandButton = GUICtrlCreateButton("Command Params", 928, 32, 92, 30)
GUICtrlSetTip(-1, "Gets the command line parameters of the program selected in the running process window if available")
$WindowButton = GUICtrlCreateButton("Select Process Window", 864, 62, 156, 30)
GUICtrlSetTip(-1, "If you dont know what the program is called use this then select the program and press CTRL which will tell you the program name and where its started from")
$DeleteButton = GUICtrlCreateButton("Delete Process", 721, 62, 144, 30)
GUICtrlSetTip(-1, "Deletes the program selected in the running process window")
$spywarelibraryButton = GUICtrlCreateButton("Check Spyware Library", 975, 357, 144, 30)
GUICtrlSetTip(-1, "Searches the process library for the program selected in the running process window")
$VTOSButton = GUICtrlCreateButton("Virus Total Online Scan", 975, 195, 144, 30)
GUICtrlSetTip(-1, "Opens the Virus total online scan page")
$KASPButton = GUICtrlCreateButton("Kaspersky Online Scan", 975, 225, 144, 30)
GUICtrlSetTip(-1, "Opens the kaspersky online scan page")
$BitDefButton = GUICtrlCreateButton("Bitdefender Online Scan", 975, 255, 144, 30)
GUICtrlSetTip(-1, "Opens the bitdefender online scan page")
$SpywareButton = GUICtrlCreateButton("Online Spyware Scan", 975, 285, 144, 30)
GUICtrlSetTip(-1, "Opens the online spyware scan page")
$ReportButton = GUICtrlCreateButton("Create Report", 785, 32, 80, 30)
GUICtrlSetTip(-1, "Creates a report for you to view")
$UninstallButton = GUICtrlCreateButton("Uninstaller", 280, 421, 65, 40)
GUICtrlSetTip(-1, "Starts the Basic Uninstaller")
GUISetBkColor(0xFFFFFF, $hGUI_child)

$Label1 = GUICtrlCreateLabel("Data: Select Live Process then Click on Path or Parameters buttons ", 500, 130, 920, 17)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xC0C0C0)
$alive = GUICtrlCreateProgress(160, 380, 195, 20, BitOR($PBS_SMOOTH, $PBS_MARQUEE)) ;just to let the user know the app is still running
$aliveStatus = 0

$liveProcLabel = GUICtrlCreateLabel(":", 358, 111, 190)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xC0C0C0)
$liveProc = GUICtrlCreateList("", 100, 140, 290, 219, BitOR($WS_VSCROLL, $LBS_NOTIFY, $LBS_SORT))
GUICtrlSetBkColor(-1, 0x292929)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xC0C0C0)
$killProcLabel = GUICtrlCreateLabel("Processes to Kill:", 540, 170, 190,17)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x000000)
$killProc = GUICtrlCreateList("", 505, 190, 230, 200, BitOR($WS_VSCROLL, $LBS_NOTIFY, $LBS_SORT))
;GUICtrlSetBkColor(-1, 0x292929)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x000000)
GUICtrlCreateLabel("Errors:", 820, 170,190,17)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x000000)
$errors = GUICtrlCreateList("",740, 190, 230, 200, BitOR($WS_VSCROLL, $LBS_SORT, $LBS_NOSEL))
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x000000)
$myedit = GUICtrlCreateEdit("" & @CRLF, 505, 389, 590, 98, $ES_AUTOVSCROLL + $WS_VSCROLL)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x000000)
GUICtrlSetData($myedit, "Running Log" & @CRLF)

GUICtrlSetState($NukeButton, $GUI_disable)

GUIRegisterMsg($WM_COMMAND, "_WM_COMMAND")

;perform initial scan for running processes
$pListRaw = ProcessList()
If @error Then
	MsgBox(48, "ERROR", "The process list could not be built!")
	Exit
EndIf
Local $pListTemp[1]
For $a = 1 To $pListRaw[0][0]
	_ArrayAdd($pListTemp, $pListRaw[$a][0])
Next
_ArrayDelete($pListTemp, 0)
$pList = _ArrayUnique($pListTemp)

If $pList[0] > 0 Then
	For $a = 1 To $pList[0]
		For $b = 1 To $exceptions[0]
			If StringLower($pList[$a]) == StringLower($exceptions[$b]) Then ContinueLoop (2)
		Next
		GUICtrlSetData($liveProc, $pList[$a])
		$liveProcCount += 1
	Next
EndIf
GUICtrlSetData($liveProcLabel, ": " & $liveProcCount)

For $a = 1 To UBound($killList) - 1
	GUICtrlSetData($killProc, $killList[$a])
	$killProcCount += 1
Next
GUICtrlSetData($killProcLabel, "Processes to Kill: " & $killProcCount)

$started = True ;now all GUI controls will be used


;GUISetBkColor(0xFFFFFF, $hGUI_child)
GUISetState(@SW_SHOW, $hGUI)
GUISetState(@SW_SHOW, $hGUI_child)
SetTransparentBitmap($hGUI, $hImage)
_WinAPI_SetLayeredWindowAttributes($hGUI_child, 0xFFFFFF, 0xff)

$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGUI_child)
_GDIPlus_GraphicsSetSmoothingMode($hGraphic, 2)
DllCall($ghGDIPDll, "uint", "GdipSetTextRenderingHint", "handle", $hGraphic, "int", 4)
;_GDIPlus_GraphicsDrawString($hGraphic, "GDI+ Full Transparency", 0, $iHeight / 2 - 20, "Arial", 24)

GUIRegisterMsg($WM_LBUTTONDOWN, "_WM_LBUTTONDOWN")

;While 1
Do
    $nMsg = GUIGetMsg()
    Switch $nMsg
		        Case $GUI_EVENT_CLOSE, $ExitButton1
            GUIRegisterMsg($WM_LBUTTONDOWN, "")
            _GDIPlus_ImageDispose($hImage)
            _GDIPlus_GraphicsDispose($hGraphic)
            _GDIPlus_Shutdown()
            GUIDelete($hGUI)
            ExitLoop
		Case $Label1
			GUIRegisterMsg($WM_LBUTTONDOWN, "")
            _GDIPlus_ImageDispose($hImage)
            _GDIPlus_GraphicsDispose($hGraphic)
            _GDIPlus_Shutdown()
            GUIDelete($hGUI)
            ExitLoop
		Case $NukeButton
			nukemanual()
		Case $GoogleButton
			ShellExecute("http://www.google.com/search?hl=en&q=" & GUICtrlRead($liveProc) & "&btnG=Search")
		Case $ProcesslibraryButton
			ShellExecute("http://www.processlibrary.com/search/?q=" & GUICtrlRead($liveProc))
		Case $spywarelibraryButton
			ShellExecute("                                                        " & GUICtrlRead($liveProc))
		Case $PathButton
			getpath()

		Case $CommandButton
			Processparams()
		Case $WindowButton
			StopProcesswindowselect()
		Case $DeleteButton
			DeleteProcess()
		case $ReportButton
				GUICtrlSetData($Label1, "Creating Report")
				GUICtrlSetData($myedit, "Creating Report" & @crlf, ' ')
			reportcreate()
		case $AboutButton
			GUICtrlSetData($Label1, "ABOUT: - Program to kill selected processes. Command Line /nuke to close all but neccessary processes")
		Case $VTOSButton
			ShellExecute("http://www.virustotal.com/")
		Case $KASPButton
			ShellExecute("http://support.kaspersky.com/viruses/online")
		Case $BitDefButton
			ShellExecute("http://www.bitdefender.com/scanner/online/free.html")
		Case $SpywareButton
			ShellExecute("                                            ")
		Case $UninstallButton
			Juninst()
    EndSwitch
;WEnd
For $a = 1 To UBound($killList) - 1

		;placed this check at beginning and end of loop so when $killList is decreased an out-of-range error will be avoided
		If $killListTrimmed == True Then
			$killListTrimmed = False
			ExitLoop
		EndIf

		If ProcessExists($killList[$a]) Then
			_Execute($killList[$a])
		EndIf

		If $killListTrimmed == True Then
			$killListTrimmed = False
			ExitLoop
		EndIf
	Next

Until 1 = 2

Func _WM_LBUTTONDOWN($hWnd, $iMsg, $wParam, $lParam)
   _SendMessage($hGUI, $WM_SYSCOMMAND, $SC_DRAGMOVE, 0)
EndFunc   ;==>_WM_LBUTTONDOWN

Func SetTransparentBitmap($hGUI, $hImage, $iOpacity = 0xFF)
    Local $hScrDC, $hMemDC, $hBitmap, $hOld, $pSize, $tSize, $pSource, $tSource, $pBlend, $tBlend
    $hScrDC = _WinAPI_GetDC(0)
    $hMemDC = _WinAPI_CreateCompatibleDC($hScrDC)
    $hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
    $hOld = _WinAPI_SelectObject($hMemDC, $hBitmap)
    $tSize = DllStructCreate($tagSIZE)
    $pSize = DllStructGetPtr($tSize)
    DllStructSetData($tSize, "X", _GDIPlus_ImageGetWidth($hImage))
    DllStructSetData($tSize, "Y", _GDIPlus_ImageGetHeight($hImage))
    $tSource = DllStructCreate($tagPOINT)
    $pSource = DllStructGetPtr($tSource)
    $tBlend = DllStructCreate($tagBLENDFUNCTION)
    $pBlend = DllStructGetPtr($tBlend)
    DllStructSetData($tBlend, "Alpha", $iOpacity)
    DllStructSetData($tBlend, "Format", 1)
    _WinAPI_UpdateLayeredWindow($hGUI,  $hMemDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
    _WinAPI_ReleaseDC(0, $hScrDC)
    _WinAPI_SelectObject($hMemDC, $hOld)
    _WinAPI_DeleteObject($hBitmap)
    _WinAPI_DeleteDC($hMemDC)
EndFunc   ;==>SetTransparentBitmap



Func _Scan()
	If $started == True Then
		$pListOld = $pList
		$pListRaw = ProcessList()
		If @error Then
			MsgBox(48, "ERROR", "The process list could not be built!")
			Exit
		EndIf

		Local $pListTemp[1]
		For $a = 1 To $pListRaw[0][0]
			_ArrayAdd($pListTemp, $pListRaw[$a][0])
		Next
		_ArrayDelete($pListTemp, 0)
		$pList = _ArrayUnique($pListTemp)

		If $pList[0] > 0 Then
			$refresh = False ;assume a refresh of $liveProc is not needed

			If $pList[0] <> $pListOld[0] Then
				$refresh = True ;different number of elements = refresh needed
			Else
				For $z = 1 To $pList[0]
					If $pList[$z] <> $pListOld[$z] Then $refresh = True ;something is not matching up, so a refresh is needed
				Next
			EndIf

			If $refresh = True Then
				$liveProcCount = 0
				_GUICtrlListBox_BeginUpdate($liveProc)
				_GUICtrlListBox_ResetContent($liveProc)
				For $a = 1 To $pList[0]
					For $b = 1 To $exceptions[0]
						If StringLower($pList[$a]) == StringLower($exceptions[$b]) Then ContinueLoop (2)
					Next
					_GUICtrlListBox_AddString($liveProc, $pList[$a])
					$liveProcCount += 1
				Next
				_GUICtrlListBox_EndUpdate($liveProc)
				GUICtrlSetData($liveProcLabel, ": " & $liveProcCount)
			EndIf
		EndIf
	EndIf
	Return
EndFunc   ;==>_Scan


Func _Execute($victim)
	$killed = False
	$delay = TimerInit()
	Do
		ProcessClose($victim)
		If @error Then
			$status = @error
		Else
			$killed = True
			ExitLoop
		EndIf
		Sleep(50)
	Until TimerDiff($delay) > 1000

	If $killed = False Then
		If $started == True Then
			GUICtrlSetData($errors, $victim & " could not be killed! (" & $status & ")")
			_ArraySort($killList)
			$index = _ArrayBinarySearch($killList, $victim)
			_ArrayDelete($killList, $index)
			_GUICtrlListBox_BeginUpdate($killProc)
			_GUICtrlListBox_ResetContent($killProc)
			For $a = 1 To UBound($killList) - 1
				GUICtrlSetData($killProc, $killList[$a])
			Next
			_GUICtrlListBox_EndUpdate($killProc)
			$killProcCount -= 1
			GUICtrlSetData($killProcLabel, "Processes to Kill: " & $killProcCount)
			$killListTrimmed = True
		EndIf
	EndIf
	Return
EndFunc   ;==>_Execute


Func _liveProc_DoubleClick()
	$sListItem = GUICtrlRead($liveProc)
	If $sListItem <> "" Then
		_ArrayAdd($killList, $sListItem)
		$killProcCount += 1
		GUICtrlSetData($killProc, $sListItem)
		GUICtrlSetData($killProcLabel, "Processes to Kill: " & $killProcCount)
	EndIf
	Return
EndFunc   ;==>_liveProc_DoubleClick


Func _killProc_DoubleClick()
	$sListItem = GUICtrlRead($killProc)
	If $sListItem <> "" Then
		$killProcCount = 0
		_ArraySort($killList)
		$index = _ArrayBinarySearch($killList, $sListItem)
		_ArrayDelete($killList, $index)
		_GUICtrlListBox_BeginUpdate($killProc)
		_GUICtrlListBox_ResetContent($killProc)
		For $a = 1 To UBound($killList) - 1
			GUICtrlSetData($killProc, $killList[$a])
			$killProcCount += 1
		Next
		_GUICtrlListBox_EndUpdate($killProc)
		GUICtrlSetData($killProcLabel, "Processes to Kill: " & $killProcCount)
		$killListTrimmed = True
	EndIf
	Return
EndFunc   ;==>_killProc_DoubleClick


Func _WM_COMMAND($hWnd, $msg, $wParam, $lParam)
	Local $nNotifyCode = BitShift($wParam, 16)
	Local $nID = BitAND($wParam, 0xFFFF)
	Local Const $LBN_DBLCLK = 2

	Switch $nID
		Case $liveProc
			Switch $nNotifyCode
				Case $LBN_DBLCLK
					_liveProc_DoubleClick()
			EndSwitch
		Case $killProc
			Switch $nNotifyCode
				Case $LBN_DBLCLK
					_killProc_DoubleClick()
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_COMMAND


Func _Alive()
	If $started = True Then
		$aliveStatus += 2
		If $aliveStatus > 102 Then $aliveStatus = 0
		GUICtrlSetData($alive, $aliveStatus)
	EndIf
	Return
EndFunc   ;==>_Alive


Func _Exit()
	$reallyQuit = MsgBox(4, "Quit?", "Are you sure you want to quit?")
	If $reallyQuit = 6 Then Exit
	Return
EndFunc   ;==>_Exit


Func Processparams()
	$filecom = GUICtrlRead($liveProc)
If $filecom = "" then
	GUICtrlSetData($Label1, "No Program Selected. Please select one from the running processes window <------")
	GUICtrlSetData($myedit, "No Program Selected" & @crlf, ' ')
Else
	ConsoleWrite($filecom)
	$list = ProcessList($filecom)
	For $i = 1 To $list[0][0]
		;MsgBox(0, $list[$i][0], $list[$i][1])
	Next
	;ConsoleWrite($list[1][1])
	;MsgBox(4096, "Path", _WinGetPath(($list[1][1])))
	GUICtrlSetData($Label1, _WinAPI_GetCommandLineFromPID($list[1][1]))
	GUICtrlSetData($myedit, _WinAPI_GetCommandLineFromPID($list[1][1]) & @crlf, ' ')
	;MsgBox(4096, "Parameters", _WinAPI_GetCommandLineFromPID($list[1][1])) ;get parameters

	;_WinGetPath($list[1][1]))

EndIf
EndFunc   ;==>Processparams

func uninstallersingle()
$sSearch2 = GUICtrlRead($liveProc)
ConsoleWrite($sSearch2)
If $sSearch2 = "" then
	GUICtrlSetData($Label1, "No Program Selected. Please select one from the running processes window <------")
	GUICtrlSetData($myedit, "No Program Selected" & @crlf, ' ')
Else
$sBase = "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\"
$iEval = 1

;needs the .exe removing first
$sSearch = $sSearch2
While 1
    $sUninst = ""
    $sDisplay = ""
    $sCurrent = RegEnumKey($sBase, $iEval)
    If @Error Then ExitLoop
    $sKey = $sBase & $sCurrent
    $sDisplay = RegRead($sKey, "DisplayName")
    If StringRegExp($sDisplay, "(?i).*" & $sSearch & ".*") Then
        $sUninst = RegRead($sKey, "UninstallString")
        If $sUninst Then
            Run($sUninst)
            WinwaitActive("Windows Installer")
            WinActive("Windows Installer")
                sleep(20)
            ControlClick("Windows Installer", "Are you sure you want to uninstall this product?", "Yes")

        EndIf
    EndIf
        $iEval += 1
	WEnd
EndIf
EndFunc

func getpath()
	$filecom = GUICtrlRead($liveProc)
If $filecom = "" then
	GUICtrlSetData($Label1, "No Program Selected. Please select one from the running processes window <------")
	GUICtrlSetData($myedit, "No Program Selected" & @crlf, ' ')
Else
	ConsoleWrite($filecom)
	$list = ProcessList($filecom)
	For $i = 1 To $list[0][0]
		;MsgBox(0, $list[$i][0], $list[$i][1])
	Next
GUICtrlSetData($Label1, _WinGetPath(($list[1][1])))
GUICtrlSetData($myedit, _WinGetPath(($list[1][1])) & @crlf, ' ')
	;MsgBox(4096, "Path", _WinGetPath(($list[1][1])))
Endif
EndFunc

Func DeleteProcess()
	$delfile = GUICtrlRead($liveProc) ; could change to the killproc list to maybe make safer and get rid of processclose in this func ?????
If $delfile = "" then
	GUICtrlSetData($Label1, "No Program Selected. Please select one from the running processes window <------")
	GUICtrlSetData($myedit, "No Program Selected" & @crlf, ' ')
Else
	ConsoleWrite($delfile & @LF)
	$list = ProcessList($delfile)
	For $i = 1 To $list[0][0]
		;MsgBox(0, $list[$i][0], $list[$i][1])
	Next
	;ConsoleWrite($list[1][1] & @LF)

	$filetodelete = _WinGetPath($list[1][1])
	ConsoleWrite($filetodelete & @LF)
	GUICtrlSetData($myedit, "File to delete:" & $filetodelete & @crlf, ' ')
	If $filetodelete = "" Then
		ConsoleWrite("No Path Found" & @LF)
	Else
		ConsoleWrite("Path Found Closing and Deleting Process" & @LF)
		GUICtrlSetData($myedit, "Path Found Closing and Deleting Process" & @crlf, ' ')
		ProcessClose($delfile)
		ProcessWaitClose($delfile)
		FileDelete($filetodelete)
		If @error Then GUICtrlSetData($myedit, "Cannot Delete" & @crlf, ' ')
	EndIf
endif
EndFunc   ;==>DeleteProcess


Func StopProcesswindowselect()
	$hStopWindow = _WinSelect(True, 0xff0000, 0x0000ff, 0xABCDEF, 12, 800, "Tahoma", "11", "", "1B")
	;MsgBox(4096, "PID", $hStopWindow)
	$hStopWindowpath = _WinGetPath($hStopWindow)
	GUICtrlSetData($Label1, "Window Selected is: " & $hStopWindowpath)
	GUICtrlSetData($myedit, "Window Selected is: " & $hStopWindowpath & @crlf, ' ')

	;section to possibly check if user wants to stop and delete that process but msg box seems to stay under the main program

	;sleep(1000)
	;$reallydel = MsgBox(4, "Delete?", "Would you like to close and delete the file??")
;If $reallydel = 6 Then
	;ProcessClose($hStopWindow)
	;ConsoleWrite("Path Found Closing and Deleting Process" & @LF)
	;GUICtrlSetData($myedit, "Path Found Closing and Deleting Process" & @crlf, ' ')
	;ProcessWaitClose($delfile)
	;FileDelete($filetodelete)
	;	If @error Then ConsoleWrite("Cannot Delete" & @LF)
;EndIf

EndFunc   ;==>StopProcesswindowselect

func nukemanual()
	$started = False
	$goNuclear = True
	If $goNuclear == True Then
	$pListRaw = ProcessList()
	If @error Then
		MsgBox(48, "ERROR", "The process list could not be built!")
		Exit
	EndIf
	Local $pListTemp[1] ;used to get the list of running processes down to a 1-dimensional array
	For $a = 1 To $pListRaw[0][0]
		_ArrayAdd($pListTemp, $pListRaw[$a][0])
	Next
	_ArrayDelete($pListTemp, 0)
	$pList = _ArrayUnique($pListTemp)

	If $pList[0] > 0 Then
		Local $killList[1]
		For $a = 1 To $pList[0]
			For $b = 1 To $exceptions[0]
				If StringLower($pList[$a]) == StringLower($exceptions[$b]) Then ContinueLoop (2)
			Next
			_Execute($pList[$a])
			_ArrayAdd($killList, $pList[$a])
		Next
	EndIf
	_ArrayDelete($killList, 0)
	$goNuclear = False
EndIf

$started = True

EndFunc

;Gets Path via PID
Func _WinGetPath($PID = "")

	$colItems = ""
	$objWMIService = ObjGet("winmgmts:\\" & @ComputerName & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Process WHERE ProcessId = " & $PID, "WQL", _
			0x10 + 0x20)
	If IsObj($colItems) Then
		For $objItem In $colItems
			If $objItem.ExecutablePath Then Return $objItem.ExecutablePath
		Next
	EndIf
EndFunc   ;==>_WinGetPath

Func _WinAPI_GetCommandLineFromPID($PID)
	$ret1 = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', $PROCESS_VM_READ + $PROCESS_QUERY_INFORMATION, 'int', False, 'int', $PID)
	$tag_PROCESS_BASIC_INFORMATION = "int ExitStatus;" & _
			"ptr PebBaseAddress;" & _
			"ptr AffinityMask;" & _
			"ptr BasePriority;" & _
			"ulong UniqueProcessId;" & _
			"ulong InheritedFromUniqueProcessId;"
	$PBI = DllStructCreate($tag_PROCESS_BASIC_INFORMATION)
	DllCall("ntdll.dll", "int", "ZwQueryInformationProcess", "hwnd", $ret1[0], "int", 0, "ptr", DllStructGetPtr($PBI), "int", _
			DllStructGetSize($PBI), "int", 0)
	$dw = DllStructCreate("ptr")
	DllCall("kernel32.dll", "int", "ReadProcessMemory", "hwnd", $ret1[0], _
			"ptr", DllStructGetData($PBI, 2) + 0x10, _ ; PebBaseAddress+16 bytes <-- ptr _PROCESS_PARAMETERS
			"ptr", DllStructGetPtr($dw), "int", 4, "ptr", 0)
	$unicode_string = DllStructCreate("ushort Length;ushort MaxLength;ptr String")
	DllCall("kernel32.dll", "int", "ReadProcessMemory", "hwnd", $ret1[0], _
			"ptr", DllStructGetData($dw, 1) + 0x40, _ ; _PROCESS_PARAMETERS+64 bytes <-- ptr CommandLine Offset (UNICODE_STRING struct) - Win XP / Vista.
			"ptr", DllStructGetPtr($unicode_string), "int", DllStructGetSize($unicode_string), "ptr", 0)
	$ret = DllCall("kernel32.dll", "int", "ReadProcessMemory", "hwnd", $ret1[0], _
			"ptr", DllStructGetData($unicode_string, "String"), _ ; <-- ptr Commandline Unicode String
			"wstr", 0, "int", DllStructGetData($unicode_string, "Length") + 2, "int*", 0) ; read Length + terminating NULL (2 bytes in unicode)
	DllCall("kernel32.dll", 'int', 'CloseHandle', "hwnd", $ret1[0])
	;ConsoleWrite($ret[3] & @LF)
	If $ret[5] Then Return $ret[3] ; If bytes returned, return commandline...
	Return "Program run with no Parameters" ; Getting empty string is correct behaviour when there is no commandline to be had...
EndFunc   ;==>_WinAPI_GetCommandLineFromPID

; ####################### Below Func is Part of example - Needed to get commandline from more processes. ############
; ####################### Thanks for this function, wraithdu! (Didn't know it was your.) :) #########################

Func _GetPrivilege_SEDEBUG()
	Local $tagLUIDANDATTRIB = "int64 Luid;dword Attributes"
	Local $count = 1
	Local $tagTOKENPRIVILEGES = "dword PrivilegeCount;byte LUIDandATTRIB[" & $count * 12 & "]" ; count of LUID structs * sizeof LUID struct
	Local $TOKEN_ADJUST_PRIVILEGES = 0x20
	Local $call = DllCall("advapi32.dll", "int", "OpenProcessToken", "ptr", _WinAPI_GetCurrentProcess(), "dword", $TOKEN_ADJUST_PRIVILEGES, "ptr*", "")
	Local $hToken = $call[3]
	$call = DllCall("advapi32.dll", "int", "LookupPrivilegeValue", "str", Chr(0), "str", "SeDebugPrivilege", "int64*", "")
	;msgbox(0,"",$call[3] & " " & _WinAPI_GetLastErrorMessage())
	Local $iLuid = $call[3]
	Local $TP = DllStructCreate($tagTOKENPRIVILEGES)
	Local $LUID = DllStructCreate($tagLUIDANDATTRIB, DllStructGetPtr($TP, "LUIDandATTRIB"))
	DllStructSetData($TP, "PrivilegeCount", $count)
	DllStructSetData($LUID, "Luid", $iLuid)
	DllStructSetData($LUID, "Attributes", $SE_PRIVILEGE_ENABLED)
	$call = DllCall("advapi32.dll", "int", "AdjustTokenPrivileges", "ptr", $hToken, "int", 0, "ptr", DllStructGetPtr($TP), "dword", 0, "ptr", Chr(0), "ptr", Chr(0))
	Return ($call[0] <> 0) ; $call[0] <> 0 is success
EndFunc   ;==>_GetPrivilege_SEDEBUG




func tools()
Filewriteline($oFile,'<P>')
Filewriteline($oFile,'<P>')
Filewriteline($oFile,'<H2>Tools</H2>')
;Filewriteline($oFile,'<A HREF="http://www.google.com">Click to visit GOOGLE</A>')
Filewriteline($oFile,'<P>')
Filewriteline($oFile,'Information Librarys:<br>')
Filewriteline($oFile,'<br>')
Filewriteline($oFile,'<ul>')
Filewriteline($oFile,'<li><A HREF="http://www.processlibrary.com" target="_blank">Click to goto the Process Library</A></li>')
Filewriteline($oFile,'<li><A HREF="                          " target="_blank">Click to goto the Spyware Library</A></li>')
Filewriteline($oFile,'<li><A HREF="http://www.neuber.com/taskmanager/process" target="_blank">Click to goto the Neuber Library</A></li>')
Filewriteline($oFile,'</ul>')
Filewriteline($oFile,'<br>')
;av n spyware
Filewriteline($oFile,'<P>')
Filewriteline($oFile,'Anti-Virus and Spyware:<br>')
Filewriteline($oFile,'<br>')
Filewriteline($oFile,'<ul>')
Filewriteline($oFile,'<li><A HREF="                                                     " target="_blank">Click to get MBAM</A></li>')
Filewriteline($oFile,'<li><A HREF="http://www.superantispyware.com/" target="_blank">Click to goto the SAS</A></li>')
Filewriteline($oFile,'<li><A HREF="http://support.kaspersky.com/viruses/online" target="_blank">Click to goto the Kaspersky Online Scanner</A></li>')
Filewriteline($oFile,'<li><A HREF="http://www.virustotal.com/" target="_blank">Click to goto the Virus Total Online Scanner</A></li>')
Filewriteline($oFile,'<li><A HREF="http://www.bitdefender.com/scanner/online/free.html" target="_blank">Click to goto the Bitdefender Online Scanner</A></li>')
Filewriteline($oFile,'<li><A HREF="                                            " target="_blank">Click to goto the Spywarelib Online Scanner</A></li>')
Filewriteline($oFile,'<li><A HREF="http://www.freedrweb.com/cureit/?lng=en" target="_blank">Click to goto the DR Web Cureit Scanner</A></li>')
Filewriteline($oFile,'<li><A HREF="http://www.avg.com/us-en/avg-rescue-cd-download" target="_blank">Click to goto the AVG Rescue CDr</A></li>')
Filewriteline($oFile,'<li><A HREF="                                              " target="_blank">Click to goto the Bit Defender Rescue CD</A></li>')
Filewriteline($oFile,'</ul>')
Filewriteline($oFile,'<br>')
Filewriteline($oFile,'<P>')
Filewriteline($oFile,'<hr width="50%" size="3" noshade />')
Filewriteline($oFile,'<P>')
EndFunc


Func _ComputerGetSoftware(ByRef $aSoftwareInfo)
;start writing html

        Filewriteline($oFile,'<table border="1">')
		Filewriteline($oFile,'<table border="4" cellpadding="2" cellspacing="2" width="100%">')
		FileWriteLine($oFile,"<tr>")
		Filewriteline($oFile,'<th>Display Name</th>')
		Filewriteline($oFile,'<th>Display Version</th>')
		Filewriteline($oFile,'<th>Publisher</th>')
		Filewriteline($oFile,'<th>Uninstall String</th>')


		Filewriteline($oFile,'<tr style="background-color:#e0f0f0;font:10pt Calibri;"')
		Filewriteline($oFile,'<td>' & '</td>')
    Local Const $UnInstKey = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
    Local $i = 1
    Dim $aSoftwareInfo[1][4]
    $input = "ALL"

    If @Error = 1 Then Exit
    If $input = 'ALL' Then
    For $j = 1 To 900
        $AppKey = RegEnumKey($UnInstKey, $j)
        If @error <> 0 Then Exitloop
        If RegRead($UnInstKey & "\" & $AppKey, "DisplayName") = '' Then ContinueLoop
        ReDim $aSoftwareInfo[UBound($aSoftwareInfo) + 1][4]
		Filewriteline($oFile,'<tr style="background-color:#e0f0f0;font:10pt Calibri;"')
	FileWriteLine($oFile,"<tr>")
        $aSoftwareInfo[$i][0] = StringStripWS(StringReplace(RegRead($UnInstKey & "\" & $AppKey, "DisplayName"), " (remove only)", ""), 3)
       FileWrite($oFile , '<td>' & $aSoftwareInfo[$i][0] & '</td>')

	   $aSoftwareInfo[$i][1] = StringStripWS(RegRead($UnInstKey & "\" & $AppKey, "DisplayVersion"), 3)
			FileWrite($oFile , '<td>' & $aSoftwareInfo[$i][1] & '</td>')
	   $aSoftwareInfo[$i][2] = StringStripWS(RegRead($UnInstKey & "\" & $AppKey, "Publisher"), 3)
			FileWrite($oFile , '<td>' & $aSoftwareInfo[$i][2] & '</td>')
	   $aSoftwareInfo[$i][3] = StringStripWS(RegRead($UnInstKey & "\" & $AppKey, "UninstallString"), 3)
			FileWrite($oFile , '<td>' & $aSoftwareInfo[$i][3] & '</td>')
		;$aSoftwareInfo[$i][3] = StringStripWS(RegRead($UnInstKey & "\" & $AppKey, "UninstallString"), 3)
		;	FileWrite($oFile , 'A HREF=' & $aSoftwareInfo[$i][3] & '>Click to Uninstall</A>')

        $i = $i + 1
    Next
	$aSoftwareInfo[0][0] = UBound($aSoftwareInfo, 1) - 1
	Filewriteline($oFile,'</tr>')
    Filewriteline($oFile,'</table></body></html>')
Endif
if FileExists($oFile) Then
ShellExecute($oFile)
GUICtrlSetData($Label1, "Report Created in: " & @ScriptDir)
GUICtrlSetData($myedit, "Report Created in: " & @ScriptDir & @crlf, ' ')
Else
GUICtrlSetData($Label1, "Report could not be Created ")
GUICtrlSetData($myedit, "Report could not be Created "& @crlf, ' ')
EndIf
EndFunc

func reportcreate()


FileDelete($oFile)

Filewriteline($oFile,'<HTML><HEAD><TITLE>Installed Updates</TITLE></HEAD><BODY>')
Filewriteline($oFile,'<center><h1>Process Killer Report for ' & @ComputerName & ' on ' & @MDAY & "/" & @MON & "/" & @YEAR & '</h1></center>')
Filewriteline($oFile,'<P>')
Filewriteline($oFile,'<hr width="50%" size="3" noshade />')

tools()
_ComputerGetSoftware($sSft)

EndFunc



; this is start of uninst
func Juninst()

GUISetState(@SW_HIDE, $hGUI)
GUISetState(@SW_HIDE, $hGUI_child)

	_ComputerGetSoftwareuninst($JsJft)



For $i = 1 To ubound($JsJft) - 1
    GUICtrlCreateListViewItem($i & '|' & $JsJft[$i][0] & '|' & $JsJft[$i][1] & '|' & $JsJft[$i][2] & '|' & $JsJft[$i][3], $sLvw)
Next
GUICtrlSendMsg($sLvw, 0x101E, 1, 175)
GUICtrlSendMsg($sLvw, 0x101E, 2, 65)
GUICtrlSendMsg($sLvw, 0x101E, 3, 150)
GUICtrlSendMsg($sLvw, 0x101E, 4, 350)
Local $mMen = GUICtrlCreateContextMenu($sLvw)
Local $CopI = GUICtrlCreateMenuItem('Uninstall Current Selection', $mMen)
Local $exp = GUICtrlCreateMenuItem('Expand', $mMen)
;GUICtrlSetOnEvent($CopI, '_Uninstall')
;Local $exp = GUICtrlCreateButton('  Expand  ', 620, 615)
;GUICtrlSetOnEvent($exp, '_Expand')
;GUISetOnEvent(-3, '_AllExit')
GUISetState(@SW_SHOW, $sGui)

While 1
	 $uMsg = GUIGetMsg()
    Switch $uMsg
			Case $GUI_EVENT_CLOSE, $ExitButton1
				;GUIDelete($sGUI)

				_AllExit()
				ExitLoop
			Case $CopI
				_Uninstall()
			case $exp
				_Expand()



    EndSwitch
    ;Sleep(10)
WEnd


EndFunc

Func _AllExit()
    GUIDelete($sGui)
    GUISetState(@SW_SHOW, $hGUI)
GUISetState(@SW_SHOW, $hGUI_child)
EndFunc
;
Func _Uninstall()
    Local $proc = StringSplit(GUICtrlRead(GUICtrlRead($sLvw)), '|', 1)
    If $proc[1] == 0 Then Return -1
    If $proc[5] Then ShellExecuteWait ($proc[5])
        exit
EndFunc
;
Func _Copy2Clip()
    Local $proc = StringSplit(GUICtrlRead(GUICtrlRead($sLvw)), '|', 1)
    If $proc[1] == 0 Then Return -1
    If $proc[5] Then ClipPut($proc[5])
EndFunc
;
; Author JSThePatriot - Modified June 20, 2010 by ripdad
Func _ComputerGetSoftwareuninst(ByRef $aSoftwareInfoUninst)
    Local Const $UnInstKey = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
    Local $i = 1
    Dim $aSoftwareInfoUninst[1][4]
    $input = "ALL";inputbox ("Which Software" , "You are running " & @OSVersion & " " & @OSARCH & @CRLF & @CRLF & "Which Software would you like to view?", 'ALL')
    If @Error = 1 Then Exit
    If $input = 'ALL' Then
    For $j = 1 To 500
        $AppKey = RegEnumKey($UnInstKey, $j)
        If @error <> 0 Then Exitloop
        If RegRead($UnInstKey & "\" & $AppKey, "DisplayName") = '' Then ContinueLoop
        ReDim $aSoftwareInfoUninst[UBound($aSoftwareInfoUninst) + 1][4]
        $aSoftwareInfoUninst[$i][0] = StringStripWS(StringReplace(RegRead($UnInstKey & "\" & $AppKey, "DisplayName"), " (remove only)", ""), 3)
        $aSoftwareInfoUninst[$i][1] = StringStripWS(RegRead($UnInstKey & "\" & $AppKey, "DisplayVersion"), 3)
        $aSoftwareInfoUninst[$i][2] = StringStripWS(RegRead($UnInstKey & "\" & $AppKey, "Publisher"), 3)
        $aSoftwareInfoUninst[$i][3] = StringStripWS(RegRead($UnInstKey & "\" & $AppKey, "UninstallString"), 3)
        $i = $i + 1

    Next
    $aSoftwareInfoUninst[0][0] = UBound($aSoftwareInfoUninst, 1) - 1
    If $aSoftwareInfoUninst[0][0] < 1 Then SetError(1, 1, 0)
    Return _ArraySort($aSoftwareInfoUninst)

Else

    For $j = 1 To 500
        $AppKey = RegEnumKey($UnInstKey, $j)
        If @error <> 0 Then Exitloop
        $Reg = RegRead($UnInstKey & "\" & $AppKey, "DisplayName")
        $string = stringinstr($Reg, $input)
        If $string = 0 Then Continueloop
        ReDim $aSoftwareInfoUninst[UBound($aSoftwareInfoUninst) + 1][4]
        $aSoftwareInfoUninst[$i][0] = StringStripWS(StringReplace(RegRead($UnInstKey & "\" & $AppKey, "DisplayName"), " (remove only)", ""), 3)
        $aSoftwareInfoUninst[$i][1] = StringStripWS(RegRead($UnInstKey & "\" & $AppKey, "DisplayVersion"), 3)
        $aSoftwareInfoUninst[$i][2] = StringStripWS(RegRead($UnInstKey & "\" & $AppKey, "Publisher"), 3)
        $aSoftwareInfoUninst[$i][3] = StringStripWS(RegRead($UnInstKey & "\" & $AppKey, "UninstallString"), 3)
        $i = $i + 1

    Next
    $aSoftwareInfoUninst[0][0] = UBound($aSoftwareInfoUninst, 1) - 1
    If $aSoftwareInfoUninst[0][0] < 1 Then SetError(1, 1, 0)
    Return _ArraySort($aSoftwareInfoUninst)

    Endif
EndFunc
;
Func _Expand()
    _GUICtrlListView_SetColumnWidth($sLvw, 1, $LVSCW_AUTOSIZE)
    _GUICtrlListView_SetColumnWidth($sLvw, 2, $LVSCW_AUTOSIZE)
    _GUICtrlListView_SetColumnWidth($sLvw, 3, $LVSCW_AUTOSIZE)
    _GUICtrlListView_SetColumnWidth($sLvw, 4, $LVSCW_AUTOSIZE)
EndFunc