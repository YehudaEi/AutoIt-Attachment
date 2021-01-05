; ----------------------------------------------------------------------------
; HotKeys
; ----------------------------------------------------------------------------

HotKeySet("^!h", "Hide")
HotKeySet("^!s", "Pause")

; ----------------------------------------------------------------------------
; Imported from GuiConstants.au3
; ----------------------------------------------------------------------------

$GUI_EVENT_CLOSE = -3

; ----------------------------------------------------------------------------
; BlockFile
; ----------------------------------------------------------------------------

$BlockFile = @ScriptDir & "\Block\" & @UserName & " - BlockFile.ini"
$LogFile = @ScriptDir & "\Log\" & @UserName & " - LogFile.txt"

; ----------------------------------------------------------------------------
; Mike's Process Blocker (MPB) - GUI
; ----------------------------------------------------------------------------

$MPBGUI = GUICreate("Mike's Process Blocker", 250, 300)
$MPBProcessList = GUICtrlCreateList("", 0, 0, 250, 200)
$MPBRefresh = GUICtrlCreateButton("Refresh List", 0, 190, 250, 20)
$MPBAdd = GUICtrlCreateButton("Add to BlockList", 0, 210, 250, 20)
$MPBShow = GUICtrlCreateButton("Show BlockList", 0, 230, 250, 20)
$MPBStart = GUICtrlCreateButton("Start", 0, 260, 125, 20)
$MPBStop = GUICtrlCreateButton("Stop", 125, 260, 125, 20)
GUICtrlCreateLabel("State:", 50, 285)
$MPBState = GUICtrlCreateLabel("Not Active", 100, 285)
GUICtrlSetColor($MPBState, 0xFF0000)

; ----------------------------------------------------------------------------
; BlockList (BL) - GUI
; ----------------------------------------------------------------------------

$BLGUI = GUICreate("Mike's Process Blocker", 250, 250)
$BLBlockList = GUICtrlCreateList("", 0, 0, 250, 200)
$BLRefresh = GUICtrlCreateButton("Refresh List", 0, 190, 250, 20)
$BLRemove = GUICtrlCreateButton("Remove from BlockList", 0, 210, 250, 20)
$BLBack = GUICtrlCreateButton("Back to the MainWindow", 0, 230, 250, 20)

; ----------------------------------------------------------------------------
; Script Start
; ----------------------------------------------------------------------------

$MPBActive = 0
$MPBActiveGUI = $MPBGUI
$MPBShown = 0

ShowMPB()

While 1
	$MPBMsg = GUIGetMsg(1)
	
	CreateBlockFile()
	
	MPB()
	
	If $MPBMsg[1] = $MPBGUI Then
		If $MPBMsg[0] = $MPBRefresh Then RefreshProcessList()
		If $MPBMsg[0] = $MPBAdd Then AddToBlockList()
		If $MPBMsg[0] = $MPBShow Then ShowBL()
		If $MPBMsg[0] = $MPBStart And $MPBActive = 0 Then Start()
		If $MPBMsg[0] = $MPBStop And $MPBActive = 1 Then Stop()
		If $MPBMsg[0] = $GUI_EVENT_CLOSE Then Exit
	ElseIf $MPBMsg[1] = $BLGUI Then
		If $MPBMsg[0] = $BLRefresh Then RefreshBlockList()
		If $MPBMsg[0] = $BLRemove Then RemoveFromBlockList()
		If $MPBMsg[0] = $BLBack Or $MPBMsg[0] = $GUI_EVENT_CLOSE Then ShowMPB()
	EndIf
WEnd

Func CreateBlockFile()
	If Not DirGetSize(@ScriptDir & "\Block") >= 0 Then DirCreate(@ScriptDir & "\Block")
	If Not FileExists($BlockFile) Then
		Local $hFile = FileOpen($BlockFile, 2)
		FileWriteLine($hFile, "[BlockList]")
		FileClose($hFile)
	EndIf
EndFunc

Func RefreshProcessList()
	Local $ProcessList = ProcessList()
	Local $i
	GUICtrlSetData($MPBProcessList, "")
	For $i = 1 To $ProcessList[0][0]
		If $ProcessList[$i][0] <> "[System Process]" And $ProcessList[$i][0] <> "System" Then GUICtrlSetData($MPBProcessList, $ProcessList[$i][0])
	Next
EndFunc

Func AddToBlockList()
	Local $Read = GUICtrlRead($MPBProcessList)
	If $Read <> "" Then
		Local $Split = StringSplit($Read, ".")
		IniWrite($BlockFile, "BlockList", $Split[1], $Read)
	EndIf
	RefreshProcessList()
EndFunc

Func Start()
	$MPBActive = 1
	GUICtrlSetData($MPBState, "Active")
	GUICtrlSetColor($MPBState, 0x0000FF)
EndFunc

Func Stop()
	$MPBActive = 0
	GUICtrlSetData($MPBState, "Not Active")
	GUICtrlSetColor($MPBState, 0xFF0000)
EndFunc

Func RefreshBlockList()
	Local $i
	GUICtrlSetData($BLBlockList, "")
	Local $Read = IniReadSection($BlockFile, "BLockList")
	If Not @error Then
		For $i = 1 To $Read[0][0]
			If $Read[$i][1] <> "" Then GUICtrlSetData($BLBlockList, $Read[$i][1])
		Next
	EndIf
EndFunc

Func RemoveFromBlockList()
	Local $Read = GUICtrlRead($BLBlockList)
	If $Read <> "" Then
		Local $Split = StringSplit($Read, ".")
		IniDelete($BlockFile, "BlockList", $Split[1])
		RefreshBlockList()
	EndIf
EndFunc

Func ShowMPB()
	GUISetState(@SW_HIDE, $BLGUI)
	GUISwitch($MPBGUI)
	GUISetState(@SW_SHOW, $MPBGUI)
	$MPBActiveGUI = $MPBGUI
	$MPBShown = 1
	RefreshProcessList()
EndFunc

Func ShowBL()
	GUISetState(@SW_HIDE, $MPBGUI)
	GUISwitch($BLGUI)
	GUISetState(@SW_SHOW, $BLGUI)
	$MPBActiveGUI = $BLGUI
	$MPBShown = 1
	RefreshBlockList()
EndFunc

Func MPB()
	If $MPBActive = 1 Then
		Local $Read = IniReadSection($BlockFile, "BlockLIst")
		If Not @error Then
			Local $i
			For $i = 1 To $Read[0][0]
				If ProcessExists($Read[$i][1]) Then
					ProcessClose($Read[$i][1])
					BlockEvent($Read[$i][1])
				EndIf
			Next
		EndIf
	EndIf
EndFunc

Func BlockEvent($Process)
	If Not DirGetSize(@ScriptDir & "\Log") >= 0 Then DirCreate(@ScriptDir & "\Log")
	Local $DateFormat = "[" & @MDAY & "." & @MON & "." & @YEAR & "]"
	Local $hFile = FileOpen($LogFile, 0)
	Local $i = 0
	Local $SectionExisting = 0
	Do
		$i += 1
		If FileReadLine($hFile, $i) = $DateFormat Then $SectionExisting = 1
	Until @error Or $SectionExisting
	FileClose($hFile)
	$hFile = FileOpen($LogFile, 1)
	If Not $SectionExisting Then FileWriteLine($hFile, $DateFormat)
	FileWriteLine($hFile, @HOUR & ":" & @MIN &  ":" & @SEC & @TAB & $Process)
	FileClose($hFile)
EndFunc

Func Hide()
	If $MPBShown Then
		GUISetState(@SW_HIDE, $MPBActiveGUI)
		$MPBShown = 0
	Else
		GUISetState(@SW_SHOW, $MPBActiveGUI)
		$MPBShown = 1
	EndIf
EndFunc

Func Pause()
	If $MPBActive Then
		Stop()
		If Not $MPBShown Or $MPBActiveGUI = $BLGUI Then TrayTip("MPB", "stopped", 2)
	Else
		Start()
		If Not $MPBShown Or $MPBActiveGUI = $BLGUI Then TrayTip("MPB", "started", 2)
	EndIf
EndFunc