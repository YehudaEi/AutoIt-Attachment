#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_run_tidy=y
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****

Opt("MustDeclareVars", 1) ; 0=no, 1=require pre-declare
#RequireAdmin

Const $version = "Version: 0.0.1.0"

If _Singleton(@ScriptName, 1) = 0 Then
	Debug(@ScriptName & " is already running!", 0x40)
	Exit
EndIf

#include <GuiListView.au3>
#include <GUIConstants.au3>
#include <String.au3>
#include <Process.au3>
#include <_DougFunctions.au3>

DirCreate(@ScriptDir & "\AUXFiles")
FileInstall(".\AUXFiles\devcon.exe", @ScriptDir & "\AUXFiles\", 1)
DirCreate(@ScriptDir & "\temp")

Global $ShortPath = FileGetShortName(@ScriptDir)
Debug($ShortPath)

Const $DEVCON = "AUXFiles\devcon.exe"
Const $RESULTFILE = "temp\results.txt"
Const $DUMPFILE = "temp\Dev_dump.txt"
Const $RESCANFILE = "temp\rescan.txt"
Const $CLEANFILE = "temp\clean.txt"

Debug("DEVCON: " & $DEVCON)
Debug("RESULTFILE: " & $RESULTFILE)

FileDelete($RESULTFILE)
_RunDOS($DEVCON & ' /help > ' & $RESULTFILE)
If FileGetSize($RESULTFILE) < 1e3 Then
	Debug("Does devcon.exe exist in the path??", 0x010)
	Exit
EndIf
FileDelete($RESULTFILE)

Local $font = "Courier new"
GUISetFont(10, 400, -1, $font)
Local $SystemS = @OSVersion & "  " & @OSServicePack & "  " & @OSTYPE & "  " & @ProcessorArch
Global $Main = GUICreate("Show inactive " & $version & "  " & $SystemS, 820, 500, 20, 20);, $WS_SIZEBOX)

Global $check_USB = GUICtrlCreateCheckbox("USB", 10, 10)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetTip(-1, "List USB devices")
Global $check_STORAGE = GUICtrlCreateCheckbox("STORAGE", 10, 30)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetTip(-1, "List Storage devices")
Global $check_All = GUICtrlCreateCheckbox("All", 10, 50)
GUICtrlSetState(-1, $GUI_UNCHECKED)
GUICtrlSetTip(-1, "List all devices")

Global $check_PCI = GUICtrlCreateCheckbox("PCI", 100, 10)
GUICtrlSetState(-1, $GUI_UNCHECKED)
GUICtrlSetTip(-1, "List All PCI devices")
Global $check_Intel = GUICtrlCreateCheckbox("Intel", 100, 30)
GUICtrlSetState(-1, $GUI_UNCHECKED)
GUICtrlSetTip(-1, "List Intel devices")
Global $check_AMD = GUICtrlCreateCheckbox("AMD & VIA", 100, 50)
GUICtrlSetState(-1, $GUI_UNCHECKED)
GUICtrlSetTip(-1, "List AMD & VIA devices")

GUICtrlCreateGroup("Display", 300, 1, 100, 85) ;open group
Global $radio_All = GUICtrlCreateRadio("All", 310, 20, 80, 20)
Global $radio_Hidden = GUICtrlCreateRadio("Inactive", 310, 40, 80, 20)
Global $radio_Active = GUICtrlCreateRadio("Active", 310, 60, 80, 20)
GUICtrlCreateGroup("", -99, -99, 1, 1) ;close group
GUICtrlSetState($radio_Hidden, $GUI_CHECKED)

Global $button_getdata = GUICtrlCreateButton("Get the data", 450, 5, 80)
GUICtrlSetTip(-1, "Builds a list of all devices")
Global $button_filterdata = GUICtrlCreateButton("Re-filter", 450, 35, 80)
GUICtrlSetTip(-1, "Re-filter devices based on options selected")
Global $button_Dump = GUICtrlCreateButton("Dump", 450, 65, 80)
GUICtrlSetTip(-1, "Dump lists to file " & $DUMPFILE)
Global $button_clean = GUICtrlCreateButton("Clean", 550, 5, 80)
GUICtrlSetTip(-1, "Remove devices listed that have a count of one")
Global $button_rescan = GUICtrlCreateButton("Rescan", 550, 35, 80)
GUICtrlSetTip(-1, "Rescan for new devices")

Global $button_about = GUICtrlCreateButton("About", 730, 5, 80)
GUICtrlSetTip(-1, "About the program")
Global $button_help = GUICtrlCreateButton("Help", 730, 35, 80)
GUICtrlSetTip(-1, "Display help information")
Global $button_exit = GUICtrlCreateButton("Exit", 730, 65, 80)
GUICtrlSetTip(-1, "Exit the program")

GUISetFont(10, 400, -1, $font)

Local $iStyle = BitOR($LVS_REPORT, $LVS_EDITLABELS, $LVS_SINGLESEL, $LVS_SHOWSELALWAYS, $LVS_AUTOARRANGE)
Local $iExStyle = BitOR($WS_VISIBLE, $LVS_EX_GRIDLINES, $LVS_EX_SIMPLESELECT)
;Global $User_list3 = GUICtrlCreateList("", 10, 380, 500, 100, 0x00B01001)
;Debug(Hex($iStyle) & "   " & Hex($iExStyle), 1,5)

Global $hListView = _GUICtrlListView_Create($Main, "Count|ID|Name", 10, 90, 800, 400, $iStyle)
_GUICtrlListView_SetColumnWidth($hListView, 0, 50)
_GUICtrlListView_SetColumnWidth($hListView, 1, 400)
_GUICtrlListView_SetColumnWidth($hListView, 2, 450)
_GUICtrlListView_SetExtendedListViewStyle($hListView, $iExStyle)

GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP)

GUISetState()

HotKeySet("{F11}", "Toggle")
Func Toggle()
	GuiDisable("Toggle")
EndFunc   ;==>Toggle
;-----------------------------------------------
; Run the GUI until the dialog is closed
While 1
	Local $msg = GUIGetMsg()
	Switch $msg
		Case $button_getdata
			GetData()
			FilterData()
		Case $button_filterdata
			FilterData()
		Case $button_clean
			Clean()
		Case $button_rescan
			Rescan()
		Case $button_Dump
			DumpToFile()
		Case $button_about
			Debug(@ScriptName & " " & $version & @CRLF & "Written by Doug Kaynor because I wanted to!", 0x40, 5)
		Case $button_help
			Debug(@ScriptName & " " & $version & @CRLF & "Might put help here someday!", 0x40, 5)
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $button_exit
			ExitLoop
	EndSwitch
WEnd
;-----------------------------------------------
Func GetData()
	GuiDisable("Disable")
	Debug("Get data")
	_GUICtrlListView_DeleteAllItems($hListView)

	FileDelete($RESULTFILE)
	Global $parms1 = 'FIND *'
	Global $parms2 = 'FindAll *'
	_RunDOS($DEVCON & ' ' & $parms1 & '>> ' & $RESULTFILE)
	_RunDOS($DEVCON & ' ' & $parms2 & '>> ' & $RESULTFILE)
	Debug("Lines in " & $RESULTFILE & ":" & _FileCountLines($RESULTFILE))
	GuiDisable("Enable")
EndFunc   ;==>GetData
;-----------------------------------------------
Func FilterData()
	GuiDisable("Disable")
	Debug("Filter data")
	
	_GUICtrlListView_DeleteAllItems($hListView)
	If Not FileExists($RESULTFILE) Then
		MsgBox(0, "Results file not found", $RESULTFILE & ' not found', 10)
		GuiDisable("Enable")
		Return
	EndIf
	
	Dim $InArray[1] ;The file is read into this array and preprocesed
	_FileReadToArray($RESULTFILE, $InArray)
	_ArraySort($InArray)
	_FileWriteFromArray($RESULTFILE, $InArray)
	_ArrayReverse($InArray)
	;_ArrayDisplay($InArray)
	
	;Remove what we don't care about (filter)
	
	Global $OutArray[1] ;The data is filtered from $InArray to $OutArray
	For $X = 0 To UBound($InArray) - 1
		If StringLen($InArray[$X]) > 10 And StringInStr($InArray[$X], "matching device") = 0 Then
			If GUICtrlRead($check_All) = $GUI_CHECKED Then
				_ArrayAdd($OutArray, $InArray[$X])
				$InArray[$X] = ''
			Else
				If GUICtrlRead($check_USB) = $GUI_CHECKED And _
						(StringInStr($InArray[$X], "USB") = 1 Or _
						StringInStr($InArray[$X], "USBSTOR") = 1) Then
					_ArrayAdd($OutArray, $InArray[$X])
					$InArray[$X] = ''
				EndIf
				If GUICtrlRead($check_STORAGE) = $GUI_CHECKED And _
						(StringInStr($InArray[$X], "STORAGE") = 1 Or _
						StringInStr($InArray[$X], "USBSTOR") = 1) Then
					_ArrayAdd($OutArray, $InArray[$X])
					$InArray[$X] = ''
				EndIf
				If GUICtrlRead($check_PCI) = $GUI_CHECKED And _
						StringInStr($InArray[$X], "PCI") = 1 Then
					_ArrayAdd($OutArray, $InArray[$X])
					$InArray[$X] = ''
				EndIf
				If GUICtrlRead($check_Intel) = $GUI_CHECKED And _
						StringInStr($InArray[$X], "INTEL(R)") > 0 Then
					_ArrayAdd($OutArray, $InArray[$X])
					$InArray[$X] = ''
				EndIf
				If GUICtrlRead($check_AMD) = $GUI_CHECKED And _
						((StringInStr($InArray[$X], "AMD") > 0) Or _
						(StringInStr($InArray[$X], "VIA") > 0)) Then
					_ArrayAdd($OutArray, $InArray[$X])
					$InArray[$X] = ''
				EndIf
			EndIf
		EndIf
	Next

	;Debug("_ArrayDisplay($InArray)   " & "  " & @ScriptLineNumber)
	;redim $InArray = 0
	;Debug("_ArrayDisplay($OutArray)   " & "  " & @ScriptLineNumber)
	;_ArrayDisplay($OutArray)
	
	;This builds a hash of the items. The name is the key and the count is the data.
	;The hash is a one dimensional array
	Global $TmpArray[2] ;Create 2 slots so that a crash with no data is avoided
	For $X = 0 To UBound($OutArray) - 1
		Local $T = StringStripWS($OutArray[$X], 3)
		Local $POS = _ArraySearch($TmpArray, $T)
		If $POS = -1 Then
			_ArrayAdd($TmpArray, $T)
			_ArrayAdd($TmpArray, 1)
		Else
			$TmpArray[$POS + 1] += 1
		EndIf
	Next
	;Convert the hash to a two dimensional array
	Local $Count = 0
	Global $ZArray[1][2]
	While UBound($TmpArray) > 0
		$ZArray[$Count][0] = _ArrayPop($TmpArray)
		$ZArray[$Count][1] = _ArrayPop($TmpArray)
		$Count += 1
		ReDim $ZArray[UBound($ZArray) + 1][2]
	WEnd
	;_ArrayDisplay($ZArray)

	;Now go through the hash and display the results depending on user prefrences
	Global $ACount = 0
	Global $ICount = 0
	While $ACount < UBound($ZArray)
		Local $S1 = $ZArray[$ACount][0] ; This is the number of occurances
		Local $S2 = $ZArray[$ACount][1] ; This is the ID/Name string
		;Debug($S1 & "<<>>" & $S2)
		
		Global $Doit = False
		If (GUICtrlRead($radio_All) = $GUI_CHECKED) Then $Doit = True
		If (GUICtrlRead($radio_Hidden) = $GUI_CHECKED And $S1 = 1) Then $Doit = True
		If (GUICtrlRead($radio_Active) = $GUI_CHECKED And $S1 = 2) Then $Doit = True
		
		If $Doit = True Then
			If StringInStr($S2, ":") <> 0 Then
				Local $S3 = StringSplit($S2, ":")
				If $S3[0] = 2 Then
					_GUICtrlListView_AddItem($hListView, $S1)
					_GUICtrlListView_AddSubItem($hListView, $ICount, $S3[1], 1)
					_GUICtrlListView_AddSubItem($hListView, $ICount, $S3[2], 2)
				EndIf
			Else
				If StringCompare($S2, "") <> 0 Then
					_GUICtrlListView_AddItem($hListView, $S1)
					_GUICtrlListView_AddSubItem($hListView, $ICount, $S2, 1)
				EndIf
			EndIf
			$ICount += 1
		EndIf
		$ACount += 1
	WEnd
	GuiDisable("Enable")
EndFunc   ;==>FilterData
;-----------------------------------------------
#CS
	devcon remove @usb\*
	rescan
	devcon /r remove "PCI\VEN_8086&DEV_7110"
	devcon /r remove =printer
	devcon /r remove =printer *deskj*
	DevCon will return an error level for use in scripts:
	"0" indicates a success.
	"1" indicates that a restart is required.
	"2" indicates a failure.
	"3" indicates a syntax error.
	;Local $result = _RunDOS($DEVCON & ' remove')
#CE
Func Clean()
	GuiDisable("Disable")
	Debug("Clean")
	Local $result
	Local $msgbutton = MsgBox(1, "Are you sure?", "This should remove listed devices.")
	If $msgbutton = 2 Then ; cancel was pressed
		GuiDisable("Enable")
		Return
	EndIf
	FileDelete($CLEANFILE)
	FileDelete($RESULTFILE)
	Local $Max = _GUICtrlListView_GetItemCount($hListView)
	For $X = 0 To $Max
		Local $tmp = _GUICtrlListView_GetItemText($hListView, $X, 0)
		If $tmp = 1 Then
			Local $T = StringStripWS(_GUICtrlListView_GetItemText($hListView, $X, 1), 3)
			Local $cmd = $DEVCON & " remove " & '"@' & $T & '"' & " >> " & $CLEANFILE
			$result = _RunDOS($cmd)
			Debug(">>" & @error & "<<>>" & $result & "<<>>" & $cmd & "<<")
		EndIf
	Next
	_GUICtrlListView_DeleteAllItems($hListView)
	Dim $aArray[1]
	_FileReadToArray($CLEANFILE, $aArray)
	$aArray[0] = 'remove ' & $result
	_ArrayDisplay($aArray)
	GuiDisable("Enable")
EndFunc   ;==>Clean
;-----------------------------------------------
Func Rescan()
	GuiDisable("Disable")
	Debug("Rescan")
	FileDelete($RESCANFILE)
	FileDelete($RESULTFILE)
	_GUICtrlListView_DeleteAllItems($hListView)
	Local $result = _RunDOS($DEVCON & ' rescan >> ' & $RESCANFILE)
	Dim $aArray[1]
	_FileReadToArray($RESCANFILE, $aArray)
	$aArray[0] = 'Result ' & $result
	_ArrayDisplay($aArray)
	GuiDisable("Enable")
EndFunc   ;==>Rescan
;-----------------------------------------------
Func DumpToFile()
	Debug("DumpToFile")
	Local $Max = _GUICtrlListView_GetItemCount($hListView)
	Local $file = FileOpen($DUMPFILE, 2)
	For $X = 0 To $Max
		Local $tmps1 = _GUICtrlListView_GetItemText($hListView, $X, 0)
		Local $tmps2 = _GUICtrlListView_GetItemText($hListView, $X, 1)
		Local $tmps3 = _GUICtrlListView_GetItemText($hListView, $X, 2)
		FileWriteLine($file, StringFormat("%3s %-80s %-1s", $tmps1, $tmps2, $tmps3))
	Next
	FileClose($file)
	MsgBox(0, "Dump complete", "Displayed data sent to: " & $DUMPFILE, 5)
EndFunc   ;==>DumpToFile
;-----------------------------------------------
Func GuiDisable($choice) ;@SW_ENABLE @SW_disble
	Global $LastState
	Local $setting
	
	If $choice = "Enable" Then
		$setting = $GUI_ENABLE
	ElseIf $choice = "Disable" Then
		$setting = $GUI_DISABLE
	ElseIf $choice = "Toggle" Then
		If $LastState = $GUI_DISABLE Then
			$setting = $GUI_ENABLE
		Else
			$setting = $GUI_DISABLE
		EndIf
	Else
		Debug("Invalid choice at GuiDisable" & $choice & "   " & $setting, 0x40)
		Return
	EndIf

	$LastState = $setting
	For $X = 1 To 27
		GUICtrlSetState($X, $setting)
	Next

EndFunc   ;==>GuiDisable
;-----------------------------------------------