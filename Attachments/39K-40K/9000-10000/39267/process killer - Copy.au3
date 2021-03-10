#include <GUIConstantsEx.au3>
#include <GuiComboBox.au3>
#include <GuiListView.au3>
#include <WindowsConstants.au3>
#include <file.au3>

Global $result, $Add, $Form1, $Form2, $EndProcess, $confirm, $Pingable, $ProcessToKill, $Process, $SelectedComp, $CompListView, $ipAddress, $index, $aRecords, $Remove, $OK, $CompName, $file, $CompNameInput, $Text, $i3, $CountFile3
Global $hFile = "computers.txt"

Opt("GUIOnEventMode", 1)
Main()

  Func Main()
    Local $hFile = FileOpen("Computers.txt")
    $Form1 = GUICreate("Process Killer", 331, 251, 192, 124)
	GUISetOnEvent($GUI_EVENT_CLOSE, "On_Close")
    GUISetState(@SW_SHOW)
	$Process = GUICtrlCreateCombo("", 200, 48, 121, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
    $CompListView = GUICtrlCreateListView("Computers", 8, 48, 169, 162, $LVS_SORTASCENDING)
	GUICtrlSetBkColor(-1, 0xFFCCCC)
	GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 165)
    $Add = GUICtrlCreateButton("Add", 8, 216, 81, 25)
    GUICtrlSetOnEvent(-1, "On_Button")
    $Remove = GUICtrlCreateButton("Remove", 96, 216, 81, 25)
    GUICtrlSetOnEvent(-1, "On_Button")
    $EndProcess = GUICtrlCreateButton("End Process", 200, 80, 121, 25)
    GUICtrlSetOnEvent(-1, "On_Button")
    popComboBox()
	While 1
        $Text = FileReadLine($hFile)
        If @error = -1 Then Exitloop
        GUICtrlCreateListViewItem($Text, $CompListView)
    WEnd

	  GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

  While 1
   Sleep(1000)
  WEnd
  EndFunc   ;==>Main

  Func addComputer()
	  $Form2 = GUICreate("Add", 194, 88, 190, 255)
	  GUISetOnEvent($GUI_EVENT_CLOSE, "On_Close")
	  $CompName = GUICtrlCreateInput("", 8, 32, 169, 21)
	  $LabelComp = GUICtrlCreateLabel("Computer Name:", 8, 8, 83, 17)
	  $OK = GUICtrlCreateButton("OK", 104, 56, 73, 25)
	  GUICtrlSetOnEvent(-1, "On_Button")
	  GUISetState(@SW_SHOW)
  EndFunc ; Func addComputer()

Func On_Button()
    Switch @GUI_CTRLID ; See which button sent the message
    Case $Add
	  addComputer()
		Case $EndProcess
			TCPStartup()
			$ProcessToKill = GUICtrlRead($Process)
		Local $index = Int(_GUICtrlListView_GetSelectedIndices($CompListview))
		 $SelectedComp = _GUICtrlListView_GetItemTextString($CompListView, $index)
		 Local $result = StringCompare($SelectedComp, "192.168.")
		 If $result = 1 Then
		 $ipAddress = $SelectedComp
		 Global $Pingable = Ping($ipAddress)
		 ConsoleWrite($Pingable)
		 ElseIf $Pingable = 0 Then
			 MsgBox(4112, "Error", "The selected IP address is currently not available.  Please check that the computer is on and has network connectivity.")

		 Else
		$ipAddress = TCPNameToIP($SelectedComp)
EndIf
  	 If $ipAddress = "" Then
		MsgBox(4112, "Error", "Couldn't Resolve IP Address.  Please check that the computer is on and has network connectivity.")
		Return
Else
   Switch $ProcessToKill
      Case "", "explorer.exe", "svchost.exe", "winlogon.exe", "crss.exe", "services.exe", "lsass.exe", "dllhost.exe", "spoolsv.exe", "regsvc.exe", "smss.exe", "alg.exe", "wscntfy.exe", "dwm.exe", "wininit.exe", "msascui.exe", "slsvc.exe", "taskhost.exe", "lsm.exe", "sppsvc.exe"
         MsgBox(4112, "Error", "Either you didn't select a process, or the process you selected can not be terminated.  Please make a selection.")
       Return
   Case Else
            TCPShutdown()
			runCheck()
			Return
   EndSwitch
EndIf
		 Case $Remove
			Local $index = Int(_GUICtrlListView_GetSelectedIndices($CompListview))
		 $SelectedComp = _GUICtrlListView_GetItemTextString($CompListView, $index)
			$confirm = MsgBox(4100, "Confirm", "Are you sure you want to remove " & "'" & $SelectedComp & "'" & " from the list?")
If $confirm = 6 Then ; Checks for 'Yes'
     delSelected()

  Else
     Return
EndIf
		  Case $OK
			 If GUICtrlRead($CompName) = "" Then
				MsgBox(48, "ERROR", "Can't add a blank entry to the computer list.  Try again.")
				Else
				addToFile()
			EndIf
	EndSwitch
EndFunc

 Func On_Close()
     Switch @GUI_WINHANDLE ; See which GUI sent the CLOSE message
         Case $Form1
             Exit ; If it was this GUI - we exit <<<<<<<<<<<<<<<
         Case $Form2
             GUIDelete($Form2) ; If it was this GUI - we just delete the GUI <<<<<<<<<<<<<<<
             GUICtrlSetState($Add, $GUI_ENABLE)
     EndSwitch
  EndFunc ; Func On_Close()

  Func popComboBox()
	  $Countfile2= _FileCountLines("processes.txt")
	  $file2 = "processes.txt"
	  For $i2 = 1 To $CountFile2
	  $var2= FileReadLine($file2, $i2)
	  Global $text2 = $var2
	  _GUICtrlComboBox_AddString($Process, $text2)
	  Next
  EndFunc

  Func EndProc()
	 $oWMIService = ObjGet("winmgmts:" & "{impersonationLevel=impersonate}!\\" & $ipAddress & "\root\CIMV2")
    If Not IsObj($oWMIService) Then
		MsgBox(48, "ERROR", "Couldn't locate the computer. Please make sure you've selected the correct computer and try again.")
		Return
	EndIf

	Dim $handle, $colProc

	$cProc = $oWMIService.ExecQuery('SELECT * FROM Win32_Process WHERE Name = "' & $ProcessToKill & '"')
 	ConsoleWrite($cProc)
	For $oProc In $cProc
		$oProc.Terminate()
	  Next
	If $handle Then
		Return $handle
	Else
		Return 0
	EndIf
 EndFunc ; Func EndProc()

 Func runCheck()
	dim $processes [1]

$wbemFlagReturnImmediately = 0x10
$wbemFlagForwardOnly = 0x20
$processtocheck = GUICtrlRead($Process)
$colItems = ""
$RemoteComputer = $ipAddress

$Output=""
$objWMIService = ObjGet("winmgmts:" & "{impersonationLevel=impersonate}!\\" & $RemoteComputer & "\root\CIMV2")
If Not IsObj($objWMIService) Then
		MsgBox(48, "ERROR", "You are either not set up as an Administrator on the selected computer, or the IP address you selected is not valid.  Please try again.")
		Return
	 EndIf
$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Process", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)

If IsObj($colItems) then
   For $objItem In $colItems
  	$Output &= $objItem.Name
	  _ArrayAdd($processes, $Output)
	  $Output=""
   Next
Else
   Msgbox(0,"WMI Output","No WMI Objects Found for class: " & "Win32_Process" )
Endif

$result = _ArraySearch($processes, $processtocheck)
if $result >= 0 then
   $confirm = MsgBox(4100, "Confirm", "Are you sure you want to kill the process " & $processtocheck & "?")
   EndIf
If $confirm = 6 Then ; Checks for 'Yes'
     EndProc()
	 $confirm = 0
	Return
  ElseIf $result < 0 then
	 MsgBox(48, "ERROR", "The selected process was not found.  Please check the process name and try again.")
	 Return
EndIf

EndFunc ; Func runCheck()

  Func delSelected()
Dim $aRecords
   _FileReadToArray("computers.txt",$aRecords)
Local $index = Int(_GUICtrlListView_GetSelectedIndices($CompListview))
		 $SelectedComp = _GUICtrlListView_GetItemTextString($CompListView, $index)
		For $x = 1 to $aRecords[0]
   	if stringinstr($aRecords[$x], $SelectedComp) then _FileWriteToLine("computers.txt", $x, "", 1)
	  dataRefresh()
	_GUICtrlListView_SetItemFocused($CompListView, -1)
 Next
EndFunc

Func addToFile()
   FileWriteLine("Computers.txt", GUICtrlRead($CompName))
GUIDelete($Form2) ; If it was this GUI - we just delete the GUI <<<<<<<<<<<<<<<
   GUICtrlSetState($Add, $GUI_ENABLE)
   	   _GUICtrlListView_DeleteAllItems($CompListView)
dataRefresh()
	_GUICtrlListView_SetItemFocused($CompListView, -1)
 EndFunc

Func _ListView_Sort($cIndex = 0)
    Global $iColumnsCount, $iDimension, $iItemsCount, $aItemsTemp, $aItemsText, $iCurPos, $i, $j

    $iColumnsCount = _GUICtrlListView_GetColumnCount($CompListView)

    $iDimension = $iColumnsCount * 1

    $iItemsCount = _GUICtrlListView_GetItemCount($CompListView)

    Global $aItemsTemp[1][$iDimension]

    For $i = 0 To $iItemsCount - 1
        $aItemsTemp[0][0] += 1
        ReDim $aItemsTemp[$aItemsTemp[0][0] + 1][$iDimension]

        $aItemsText = _GUICtrlListView_GetItemTextArray($CompListView, $i)

        For $j = 1 To $aItemsText[0]
            $aItemsTemp[$aItemsTemp[0][0]][$j - 1] = $aItemsText[$j]
            Next
    Next

    $iCurPos = $aItemsTemp[1][$cIndex]
    _ArraySort($aItemsTemp, 0, 1, 0, $cIndex)
    If StringInStr($iCurPos, $aItemsTemp[1][$cIndex]) Then _ArraySort($aItemsTemp, 1, 1, 0, $cIndex)

    For $i = 1 To $aItemsTemp[0][0]
        For $j = 1 To $iColumnsCount
            _GUICtrlListView_SetItemText($CompListView, $i - 1, $aItemsTemp[$i][$j - 1], $j - 1)
            Next
    Next
EndFunc
;================================================================================

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
    Global $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndListView
    $hWndListView = $CompListView
    If Not IsHWnd($CompListView) Then $hWndListView = GUICtrlGetHandle($CompListView)

    $tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iCode = DllStructGetData($tNMHDR, "Code")

    Switch $hWndFrom
    Case $hWndListView
        Switch $iCode
        Case $LVN_COLUMNCLICK
            Global $tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
            Global $ColumnIndex = DllStructGetData($tInfo, "SubItem")
            _ListView_Sort($ColumnIndex)
        EndSwitch
    EndSwitch

    Return $GUI_RUNDEFMSG
    EndFunc

 Func dataRefresh()
   	   _GUICtrlListView_DeleteAllItems($CompListView)
	   Local $hFile = FileOpen("Computers.txt")
	   	While 1
        $Text = FileReadLine($hFile)
        If @error = -1 Then Exitloop
        GUICtrlCreateListViewItem($Text, $CompListView)
    WEnd
	EndFunc