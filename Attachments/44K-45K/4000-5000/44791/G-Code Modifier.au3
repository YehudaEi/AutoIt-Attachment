#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_Icon=..\Icon.ico
#AutoIt3Wrapper_Outfile=..\G-Code Modifier.exe
#AutoIt3Wrapper_Res_Fileversion=1.0.0.14
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#include <GuiListView.au3>
#include <ListviewConstants.au3>
#include <GuiStatusBar.au3>
#include <StaticConstants.au3>
#include <ButtonConstants.au3>
 #include <GuiMenu.au3>
 #include <WinAPI.au3>

#Region File install
$Res = @ScriptDir & "\Res"
DirCreate($Res)
FileInstall("Good.ico", $Res & "\Good.ico", 1)
FileInstall("Warning.ico", $Res & "\Warning.ico", 1)
$Good = $Res & "\Good.ico"
$Warning = $Res & "\Warning.ico"
#EndRegion File install
#Region Global variables
$Version = "1.3" ;Error message when unable to detect slicer
;CURA 14.07 does not generate 1st line of code with word cura in it so my code cant detect it unless i search entire file.
;FileReadToAray is changed to _FileReadToAray. Code changed slightly to work with autoit v3.3.8.1.
$INI = (@ScriptDir & "\Settings.ini")
If IniRead($INI, "Settings", "SearchAtOpen", "") = "" Then IniWrite($INI, "Settings", "SearchAtOpen", "No")
If IniRead($INI, "Settings", "ClearValulesOnClick", "") = "" Then IniWrite($INI, "Settings", "ClearValulesOnClick", "Yes")
Global $Found = 1
Global $Source = ""
Global $DefBed = ""
Global $DefNoz = ""
Global $StartLineToRemove = "" ;Used to remove selected layers. Assigned in While 1
Global $EndLineToRemove = "" ;Used to remove selected layers. Assigned in While 1
#EndRegion Global variables
Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 1 + 2)
$TrayAbout = TrayCreateItem("About")
TrayItemSetOnEvent($TrayAbout , "_AboutFunction") ;function name
TrayCreateItem('')
$TrayExit = TrayCreateItem('Exit')
TrayItemSetOnEvent($TrayExit, "_ExitFunction") ;function name
TraySetState()
TraySetToolTip("G-Code Mofidier V" & $Version)
#Region GUI Components
$MainGUI = GUICreate("G-Code Layer Modifier", 500, 475, -1, -1, $WS_MAXIMIZEBOX + $WS_SIZEBOX)
$FileMenu = GUICtrlCreateMenu("File")
$FileMenuOpen = GUICtrlCreateMenuItem("Open G-Code", $FileMenu)
$OptionsMenu = GUICtrlCreateMenu("Options")
$OptionsMenuSearchOptions = GUICtrlCreateMenuItem("AutoSearch (slow)", $OptionsMenu)
If IniRead($INI, "Settings", "SearchAtOpen", "") = "No" Then
	GUICtrlSetState($OptionsMenuSearchOptions, $GUI_UNCHECKED)
Else
	GUICtrlSetState($OptionsMenuSearchOptions, $GUI_CHECKED)
EndIf
$HelpMenu = GUICtrlCreateMenu("Help")
$HelpMenuHelp = GUICtrlCreateMenuItem("Help", $HelpMenu)
$HelpMenuAbout = GUICtrlCreateMenuItem("About", $HelpMenu)

GUICtrlCreateGroup("Open G-Code File", 5, 5, 495, 45)
GUICtrlSetResizing(-1, 1)
$OpenFile = GUICtrlCreateButton("Open G-Code", 10, 20, 90, 22)
GUICtrlSetTip(-1, "Open CURA or Slic3r generated G-Code file", "Press this button to:")
GUICtrlSetResizing(-1, 1)
GUICtrlCreateLabel("Code by:", 100, 15, 80, 20, $SS_CENTER)
$SlicerIdentified = GUICtrlCreateLabel("N/A", 100, 30, 80, 12, $SS_CENTER)
$Default = GUICtrlCreateInput("Default Values", 190, 20, 160, 20)
GUICtrlSetData($Default, "Default Nozzle:N/A Bed:N/A")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetResizing(-1, 512)
;GUICtrlSetFont (-1,10,800)
$Status = GUICtrlCreateInput("Waiting for User..", 350, 20, 140, 20)
GUICtrlSetResizing(-1, 1)

GUICtrlCreateGroup("Layers Found", 5, 50, 260, 360)
$ListView = GUICtrlCreateListView("Layer|Line|ModStart|ModEnd", 10, 65, 250, 305, '', $LVS_EX_GRIDLINES)
ResizeCollumns()

GUICtrlCreateGroup("Changes for remaining layers", 270, 50, 225, 165)
$CustomCommandTop = GUICtrlCreateCombo("", 350, 65, 140, 20)
GUICtrlSetData(-1, "M117 Type your message|M201 X500 Y500 ;Motors damper")
GUICtrlSetResizing(-1, 1)
GUICtrlCreateLabel("Custom Code", 280, 70, 65, 15)
GUICtrlSetResizing(-1, 1)

$NewNozzleTemp = GUICtrlCreateInput("", 460, 90, 30, 20)
GUICtrlCreateLabel("Extruder Temp Celcius", 280, 95, 100, 15)
GUICtrlSetResizing(-1, 1)
$NewBedTemp = GUICtrlCreateInput("", 460, 115, 30, 20)
GUICtrlCreateLabel("Bed Temp Celcius", 280, 120, 100, 15)
GUICtrlSetResizing(-1, 1)
$NewCoolingFanSpeed = GUICtrlCreateInput("", 460, 140, 30, 20)
GUICtrlCreateLabel("Cooling Fan Speed 0-255", 280, 145, 120, 25)
GUICtrlSetResizing(-1, 1)
$NewSpeed = GUICtrlCreateInput("", 460, 165, 30, 20)
GUICtrlCreateLabel("Print Speed %", 280, 170, 100, 15)
GUICtrlSetResizing(-1, 1)
$NewFeedRate = GUICtrlCreateInput("", 460, 190, 30, 20)
GUICtrlSetResizing(-1, 1)
GUICtrlCreateLabel("Extruder Feed Rate %", 280, 195, 110, 15)
GUICtrlSetResizing(-1, 1)

GUICtrlCreateGroup("Pause and Resume", 270, 215, 225, 130)
$PauseResume = GUICtrlCreateCombo("", 450, 230, 40, 15)
GUICtrlSetData(-1, "Yes|No", "No")
GUICtrlCreateLabel("Pause/Resume by User", 280, 235, 120, 20)
GUICtrlSetResizing(-1, 1)
$MoveAxis = GUICtrlCreateCombo("", 450, 250, 40, 20)
GUICtrlSetData(-1, "Yes|No", "No")
GUICtrlCreateLabel("Move Before Pause ?", 280, 255, 105, 15)
GUICtrlSetResizing(-1, 1)
$MoveX = GUICtrlCreateInput("0", 340, 275, 40, 20)
GUICtrlSetTip(-1, "Move Right=Positive value." & @CRLF & "Move Left=Negative value")
GUICtrlCreateLabel("X Right/Left", 280, 280, 60, 15)
GUICtrlSetResizing(-1, 1)
$MoveY = GUICtrlCreateInput("0", 450, 275, 40, 20)
GUICtrlSetTip(-1, "Move Forward=Positive value." & @CRLF & "Move Backward=Negative value")
GUICtrlCreateLabel("Y Front Back", 385, 280, 65, 15)
GUICtrlSetResizing(-1, 1)

$CustomCommand = GUICtrlCreateCombo("", 350, 300, 140, 20)
GUICtrlSetData(-1, "M81 ;Power OFF|M117 Type your message")
GUICtrlCreateLabel("Custom Code", 280, 305, 65, 15)
GUICtrlCreateLabel("Write At the end ?", 280, 325, 90, 12)
GUICtrlSetResizing(-1, 1)
$YesAtTheEnd = GUICtrlCreateRadio("Yes", 380, 325, 40, 12)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetTip(-1, "This code will be executed when print is finished.","Apply Custom code at the end of the Gcode.")
GUICtrlSetResizing(-1, 1)
$NoAtTheEnd = GUICtrlCreateRadio("No", 430, 325, 35, 12)
GUICtrlSetTip(-1,"This code will be executed before all other changes you make.","Apply Custom code to selected layer.")
GUICtrlSetResizing(-1, 1)

$UpdateButton = GUICtrlCreateButton("Apply changes", 270, 345, 100, 30, $BS_CENTER)
GUICtrlSetTip(-1, "Changes you apply to any Layer, will effect all layers that go after selected layer." & @CRLF & "If you need to restore changes in later layers, you have to select Layer you want to restore and enter old values")
GUICtrlSetResizing(-1, 1)
$ClearButon = GUICtrlCreateButton("Clear changes", 370, 345, 80, 30, $BS_CENTER)
GUICtrlSetResizing(-1, 1)
$ClearEntrys = GUICtrlCreateCheckbox("", 470, 345, 20, 20)
GUICtrlSetTip(-1, "Reset entered values to default when done.", "Check this box to:")
GUICtrlCreateLabel("Reset", 455, 364, 50, 12, $SS_CENTER)
GUICtrlSetResizing(-1, 1)

GUICtrlCreateLabel ("Assign range of layers to be removed.",10,370,250,15,$SS_CENTER)
$StartLayerInput = GUICtrlCreateInput ("Start",5,385,40,20)
$StartLayerAssign = GUICtrlCreateButton ("<<Selected",45,385,60,20)
$RemoveSelected = GUICtrlCreateButton ("Remove",105,385,55,20)
$EndLayerInput = GUICtrlCreateInput ("End",220,385,40,20)
$EndLayerAssign = GUICtrlCreateButton ("Selected>>",160,385,60,20)


$StatusBar = _GUICtrlStatusBar_Create($MainGUI, '', '', $SBARS_SIZEGRIP)
GUIRegisterMsg($WM_SIZE, "MY_WM_SIZE")
#EndRegion GUI Components
GUISetState(@SW_SHOW, $MainGUI) ;Show main GUI
While 1
	$msg = GUIGetMsg()
	$GetClickedItem = GUICtrlRead($ListView) ;Constantly get clicked item ID from $listview
	If $msg = $GUI_EVENT_CLOSE Then Exit
	If $msg = $FileMenuOpen Then _OpenFileDialog()
	If $msg = $OptionsMenuSearchOptions Then _EnableAutoSearch()
	If $msg = $HelpMenuAbout Then _AboutFunction()
	If $msg = $HelpMenuHelp Then _Help()
	If $msg = $OpenFile Then _OpenFileDialog()
	If $msg = $UpdateButton Then ;Apply button clicked
		$WaitGUI = GUICreate ("Applying",200,100,-1,-1,-1,-1,$MainGUI)
		$waitLabel = GUICtrlCreateLabel ("Clearing previous changes.",10,50,180,20,$SS_CENTER)
		GUISetState (@SW_SHOW,$WaitGUI)
		_ClearLayer() ;Search G-Code lines range and erase any previously entered values
		GUICtrlSetData ($waitLabel ,"Adding new changes")
		_ModifyLayer() ;Add new values into code
		GUIDelete ($WaitGUI)
	EndIf
	If $msg = $GetClickedItem Then ;$Listview item is clicked
		If $GetClickedItem > "" Then
			$Index = _GUICtrlListView_GetHotItem($ListView) ;Get selected item index
			$Layer = _GUICtrlListView_GetItemText($ListView, $Index) ;Read 1st collumn for selected item
			$Line = _GUICtrlListView_GetItemText($ListView, $Index, 1) ;Read 2nd collumn for selected item
			_ModifyModSTarttoModEnd() ;Above variables must be here because they are used by more then one function.
		EndIf
	EndIf
	If $msg = $ClearButon Then
		_ClearLayer()
		MsgBox(64, "Information", "Code will be reloaded", "", $MainGUI)
		If GUICtrlRead($SlicerIdentified) = "CURA" Then _OpenCura()
		If GUICtrlRead($SlicerIdentified) = "Slic3r" Then _OpenSlic3r()
		If GUICtrlRead($SlicerIdentified) = "CraftWare" Then _OpenCraftWare()
	EndIf
	If $msg = $StartLayerAssign And $GetClickedItem > "" Then
		GUICtrlSetData ($StartLayerInput,StringTrimLeft ($Layer,6)) ;Remove word Layer to have only number left
		Assign ("StartLineToRemove",$Line)
	EndIf
	If $msg = $EndLayerAssign And $GetClickedItem > "" Then
		$Z = StringTrimLeft ($Layer,6)
		If $Z > GUICtrlRead ($StartLayerInput) Then
			Assign ("EndLineToRemove",$Line)
			GUICtrlSetData ($EndLayerInput,StringTrimLeft ($Layer,6)) ;Remove word Layer to have only number left
		Else
			MsgBox(16,'Error',"End layer must be higher value then start layer")
		EndIf
	EndIf
	If $msg = $RemoveSelected Then
		$Check1 = GUICtrlRead($StartLayerInput)
		$Check2 = guictrlread($EndLayerInput)
		If StringIsDigit ($Check1) And StringIsDigit ($Check1) Then
			$LineStart =$StartLineToRemove-1
			$LineEnd =$EndLineToRemove
			;$LineStart2 =7
			;$LineEnd2 =10
			;;Type the path of the file you'd like to modify
			$sFilePath = $Source
			_RemoveLayers($LineStart, $LineEnd)
		Else
			MsgBox(16,"Error","Please select start and ending layers to be remove.")
		EndIf
	EndIf
WEnd
Func _OpenFileDialog()
	$Source = FileOpenDialog("Open G-Code file", "", "G-Code files (*.gcode;*.gco;*.g)","","",$MainGUI)
	If $Source > "" Then
		If StringInStr(FileRead ($Source), "Cura") > "" Then ;Reading entire file looking for word "cura"
		;If StringInStr(FileReadLine ($Source,1), "Cura") > "" Then ;Code is generated by Cura. Should i search entire file for Cura or just one line ?
			GUICtrlSetData($SlicerIdentified, "CURA")
			For $d = 0 To 24 ;Find defaut values:
				$SearchForDef = FileReadLine($Source, $d)
				If StringInStr($SearchForDef, "M140 S") > 0 Then Assign("DefBed", $SearchForDef);Found Bed temp
				If StringInStr($SearchForDef, "M109 T0 S") > 0 Then Assign("DefNoz", $SearchForDef);Found BNozzle temp
			Next
			$FinalNoz = StringTrimRight(StringTrimLeft($DefNoz, StringInStr($DefNoz, "S")), 7)
			$FinalBed = StringTrimRight(StringTrimLeft($DefBed, StringInStr($DefBed, "S")), 7)
			GUICtrlSetData($Default, " Default Nozzle:" & $FinalNoz & " Bed:" & $FinalBed)
			_OpenCura() ;Reload file again. File reloads because $Source has value
			GUICtrlSetData($Status, "Please select Layer")
		ElseIf StringInStr(FileRead($Source), "Slic3r") > "" Then ;Code is generated by Slic3r
		;ElseIf StringInStr(FileReadLine($Source, 1), "Slic3r") > "" Then ;Code is generated by Slic3r
			GUICtrlSetData($SlicerIdentified, "Slic3r")
			For $d = 0 To 50 ;Find defaut values:
				$SearchForDef = FileReadLine($Source, $d)
				If StringInStr($SearchForDef, "M140 S") > 0 Then Assign("DefBed", $SearchForDef);Found Bed temp
				If StringInStr($SearchForDef, "M109 S") > 0 Then Assign("DefNoz", $SearchForDef);Found BNozzle temp
				;MsgBox(0,'',$SearchForDef)
			Next
			$FinalNozLeft = StringTrimLeft($DefNoz, 6)
			$FinalNoz = StringLeft($FinalNozLeft, 3)
			$FinalBedLeft = StringTrimLeft($DefBed, 6)
			$FinalBed = StringLeft($FinalBedLeft, 3)
			GUICtrlSetData($Default, " Default Nozzle:" & $FinalNoz & " Bed:" & $FinalBed)
			_OpenSlic3r()
			GUICtrlSetData($Status, "Please select Layer")
		ElseIf StringInStr(FileRead ($Source), "CraftWare") > "" Then ;Reading entire file looking for word "cura"
			GUICtrlSetData($SlicerIdentified, "CraftWare")
			For $d = 0 To 24 ;Find defaut values:
				$SearchForDef = FileReadLine($Source, $d)
				If StringInStr($SearchForDef, "M140 S") > 0 Then Assign("DefBed", $SearchForDef);Found Bed temp
				If StringInStr($SearchForDef, "M109 S") > 0 Then Assign("DefNoz", $SearchForDef);Found BNozzle temp
			Next
			$FinalNoz = StringTrimRight(StringTrimLeft($DefNoz, StringInStr($DefNoz, "S")), 32) ;# of characters to remove from the right
			$FinalBed = StringTrimRight(StringTrimLeft($DefBed, StringInStr($DefBed, "S")), 22) ;# of characters to remove from the right
			GUICtrlSetData($Default, " Default Nozzle:" & $FinalNoz & " Bed:" & $FinalBed)
			_OpenCraftWare() ;Reload file again. File reloads because $Source has value
			GUICtrlSetData($Status, "Please select Layer")
		Else
			MsgBox (16,"Error","Unable to detect Slicer generated this G-Code")
			GUICtrlSetData($SlicerIdentified, "UNKNOWN") ;unknown slicer
		EndIf
	Else
		MsgBox(16, "Error", "No file selected.")
	EndIf
EndFunc   ;==>_OpenFileDialog
Func _EnableAutoSearch()
	If IniRead($INI, "Settings", "SearchAtOpen", "") = "No" Then
		IniWrite($INI, "Settings", "SearchAtOpen", "Yes")
		GUICtrlSetState($OptionsMenuSearchOptions, $GUI_CHECKED)
	ElseIf IniRead($INI, "Settings", "SearchAtOpen", "") = "Yes" Then
		IniWrite($INI, "Settings", "SearchAtOpen", "No")
		GUICtrlSetState($OptionsMenuSearchOptions, $GUI_UNCHECKED)
	EndIf
EndFunc   ;==>_EnableAutoSearch
Func _Help()
	$HelpGUI = GUICreate("Help", 200, 220, -1, -1, -1, -1, $MainGUI)
	$HelpText1 = ("NOTE to Slic3r users" & @CRLF & "Slic3r must have [Verbose G-code] option enabled under 'Output options'" & @CRLF & "Using Repetier, G-code must be saved from G-Code Editor tab")
	$HelpText2 = (@CRLF & @CRLF & "AutoSearch will attempt to find previously made changes." & @CRLF & "This will slow search down by allot, so use it only when you need to." & @CRLF & "If layer had been changed, clicking it will reflect those changes automatically without the need to enable this option.")
	$HelpLabel = GUICtrlCreateLabel($HelpText1 & $HelpText2 & @CRLF & "God Bless you !", 10, 10, 180, 200, $SS_CENTER)
	GUISetState(@SW_SHOW, $HelpGUI)
	While 1
		$Hmsg = GUIGetMsg()
		If $Hmsg = $GUI_EVENT_CLOSE Then ExitLoop
	WEnd
	GUIDelete($HelpGUI)
EndFunc   ;==>_Help
Func _ModifyLayer()
	If GUICtrlRead($ListView) = "" Then
		MsgBox(16, 'Error', 'Please select layer first')
	Else
		;file has to be reloaded each time after update is done
		Local $SourceRead, $Found, $aLayers, $aLineNumber, $i
		$CurrentLine = 2 ;1 added top each time code is written so it writes it in next line rather then previous.
		_FileWriteToLine($Source, $Line + $CurrentLine, ";G-Code Modifier DATA Start")
		Assign("CurrentLine", $CurrentLine + 1)
		If GUICtrlRead($CustomCommandTop) > "" Then ;Write custom command before all other commands
			_FileWriteToLine($Source, $Line + $CurrentLine, GUICtrlRead($CustomCommandTop) & " ;1st Command LAYER")
			Assign("CurrentLine", $CurrentLine + 1)
		EndIf
		If GUICtrlRead($NewNozzleTemp) > "" Then
			_FileWriteToLine($Source, $Line + $CurrentLine, "M104 S" & GUICtrlRead($NewNozzleTemp) & " ;New Nozzle Temperature")
			Assign("CurrentLine", $CurrentLine + 1)
		EndIf
		If GUICtrlRead($NewBedTemp) > "" Then
			_FileWriteToLine($Source, $Line + $CurrentLine, "M140 S" & GUICtrlRead($NewBedTemp) & " ;New Bed Temperature")
			Assign("CurrentLine", $CurrentLine + 1)
		EndIf
		If GUICtrlRead($NewCoolingFanSpeed) > "" Then
			_FileWriteToLine($Source, $Line + $CurrentLine, "M106 S" & GUICtrlRead($NewCoolingFanSpeed) & " ;New Fan Speed")
			Assign("CurrentLine", $CurrentLine + 1)
		EndIf
		If GUICtrlRead($NewSpeed) > "" Then
			_FileWriteToLine($Source, $Line + $CurrentLine, "M220 S" & GUICtrlRead($NewSpeed) & " ;New Print Speed")
			Assign("CurrentLine", $CurrentLine + 1)
		EndIf
		If GUICtrlRead($NewFeedRate) > "" Then
			_FileWriteToLine($Source, $Line + $CurrentLine, "M221 S" & GUICtrlRead($NewFeedRate) & " ;New Feed/Flow rate")
			Assign("CurrentLine", $CurrentLine + 1)
		EndIf
		If GUICtrlRead($PauseResume) = "Yes" Then
			If GUICtrlRead($MoveAxis) = "Yes" Then
				$X = " X" & GUICtrlRead($MoveX)
				$Y = " Y" & GUICtrlRead($MoveY)
				_FileWriteToLine($Source, $Line + $CurrentLine, "M114" & " ;Remember last position") ;Remember current position
				Assign("CurrentLine", $CurrentLine + 1)
				_FileWriteToLine($Source, $Line + $CurrentLine, "G1" & $X & $Y & " ;Move extruder") ;Move away
				Assign("CurrentLine", $CurrentLine + 1)
				_FileWriteToLine($Source, $Line + $CurrentLine, "M18" & " ;Disable stepper motors") ;Disable all motors to allow user to move the extruder if required
				Assign("CurrentLine", $CurrentLine + 1)
				_FileWriteToLine($Source, $Line + $CurrentLine, "M0" & " ;Pause") ;pause
				Assign("CurrentLine", $CurrentLine + 1)
				_FileWriteToLine($Source, $Line + $CurrentLine, "G28 X0 Y0" & " ;Home X and Y") ;Go HOME for X and Y in case if user moved extruder or if move was in error due to going too far
				Assign("CurrentLine", $CurrentLine + 1)
				_FileWriteToLine($Source, $Line + $CurrentLine, "G92" & " ;Move back to remembered position") ;Move back to remembered position
				Assign("CurrentLine", $CurrentLine + 1)
			Else
				_FileWriteToLine($Source, $Line + $CurrentLine, "M114" & " ;Remember last position") ;Remember current position
				Assign("CurrentLine", $CurrentLine + 1)
				_FileWriteToLine($Source, $Line + $CurrentLine, "M18" & " ;Disable stepper motors") ;Disable all motors to allow user to move the extruder if required
				Assign("CurrentLine", $CurrentLine + 1)
				_FileWriteToLine($Source, $Line + $CurrentLine, "M0" & " ;Pause") ;pause
				Assign("CurrentLine", $CurrentLine + 1)
				_FileWriteToLine($Source, $Line + $CurrentLine, "G28 X0 Y0" & " ;Home X and Y") ;Go HOME for X and Y in case if user moved extruder or if move was in error due to going too far
				Assign("CurrentLine", $CurrentLine + 1)
				_FileWriteToLine($Source, $Line + $CurrentLine, "G92" & " ;Move back to remembered position") ;Move back to remembered position
				Assign("CurrentLine", $CurrentLine + 1)
			EndIf
		EndIf
		If GUICtrlRead($CustomCommand) > "" Then ;Write custom command below all codes here because in case of message on the LCD
			$TotalLines = _FileCountLines($Source)+1
			If GUICtrlRead($YesAtTheEnd) = $GUI_CHECKED Then _FileWriteToLine($Source, $TotalLines, @CRLF & GUICtrlRead($CustomCommand) & " ;Custom Command END OF CODE")
			If GUICtrlRead($NoAtTheEnd) = $GUI_CHECKED Then _FileWriteToLine($Source, $Line + $CurrentLine, GUICtrlRead($CustomCommand) & " ;Custom Command LAYER")
		EndIf
		_FileWriteToLine($Source, $Line + $CurrentLine, ";G-Code Modifier DATA End")
		Assign("CurrentLine", $CurrentLine + 1)
		MsgBox(32, "G-Code Layer Modifier", "Code Saved. Code will now reload.")
		If GUICtrlRead($SlicerIdentified) = "CURA" Then
			_OpenCura()
		ElseIf GUICtrlRead ($SlicerIdentified) = "Slic3r" Then
			_OpenSlic3r()
		ElseIf GUICtrlRead ($SlicerIdentified) = "CraftWare" Then
			_OpenCraftWare()
		EndIf
		_GUICtrlStatusBar_SetText($StatusBar, "Found " & $Found & " Layer records")
		GUICtrlSetData($Status, "Please select Layer")
		If GUICtrlRead($ClearEntrys) = $GUI_CHECKED Then ;Clear all values
			_ClearValues()
		EndIf
	EndIf
EndFunc   ;==>_ModifyLayer
Func MY_WM_SIZE($hWnd, $iMsg, $iwParam, $ilParam) ;this function is for resizing status bar with the window
	_GUICtrlStatusBar_Resize($StatusBar)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_SIZE
Func _AboutFunction()
	;GUISetState(@SW_DISABLE, $MainGUI)
	$AboutGUI = GUICreate("Information", 400, 200, -1, -1, -1, -1, $MainGUI)
	GUICtrlCreateLabel("G-Code Layer Modifier" & $Version & @CRLF & "Coded using AUTOIT V3", 10, 10, 380, 30, $SS_CENTER)
	GUICtrlCreateLabel("", 10, 50, 380, 30, $SS_CENTER)
	GUICtrlCreateLabel("Special thanks to: jchd and PhoenixXL from AUTOIT FORUM for faster search function." & @CRLF & 'Coded by tonycstech', 10, 80, 380, 200, $SS_CENTER)
	GUISetState(@SW_SHOW, $AboutGUI)
	While 1
		$msg1 = GUIGetMsg()
		If $msg1 = $GUI_EVENT_CLOSE Then ExitLoop
	WEnd
	GUIDelete($AboutGUI)
EndFunc   ;==>_AboutFunction
Func ResizeCollumns()
	_GUICtrlListView_SetColumnWidth($ListView, 0, 75)
	_GUICtrlListView_SetColumnWidth($ListView, 1, 50)
	_GUICtrlListView_SetColumnWidth($ListView, 2, 60)
	_GUICtrlListView_SetColumnWidth($ListView, 3, 60)
EndFunc   ;==>ResizeCollumns
Func _ExitFunction()
	Exit
EndFunc   ;==>ExitFunction
Func _OpenCura() ;Open file
	GUISetState (@SW_HIDE,$MainGUI)
	$SearchInputCura = ";Layer:" ;This is what i am searching for in the entire file. Every one found is displayed.
	If $Source = "" Then
		$Source = FileOpenDialog("Open G-Code file", "", "G-Code files (*.gcode;*.gco;*.g)")
	EndIf
	$SearchGUI = GUICreate("Searching", 200, 100, -1, -1, -1, -1, $MainGUI)
	$SearchLabel = GUICtrlCreateLabel("Searching: Please wait", 10, 30, 180, 20, $SS_CENTER)
	GUICtrlSetFont(-1, 10, 600)
	$CANCEL = GUICtrlCreateButton("CANCEL", 10, 60, 180, 40)
	GUICtrlSetFont(-1, 12, 600)
	GUISetState(@SW_SHOW, $SearchGUI)
	Assign("Found", 1)
	Local $SourceRead, $aLayers, $aLineNumber, $i
	$SourceRead = FileRead($Source) ;created by fileopendialog
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView))
	_GUICtrlStatusBar_SetText($StatusBar, "Searching")
	$aLayers = "" ;Array is stored here by next line
	$array =  _FileReadToArray($Source,$aLayers) ;New update ?
	;Used to be $aLayers = FileReadToArray($Source)
	$aLineNumber = _ArrayFindAll($aLayers, $SearchInputCura, 0, 0, 0, 1) ;Search for this array containing given text
	For $i = 0 To UBound($aLineNumber) - 1
		$cMSG = GUIGetMsg()
		If $cMSG = $CANCEL Then ExitLoop 1
		If StringInStr($aLayers[$aLineNumber[$i]], ";Layer:-") > 0 Then
			$NewItem = GUICtrlCreateListViewItem("RAFT Layer" & $i & "|" & $aLineNumber[$i], $ListView)
			GUICtrlSetImage($NewItem, $Warning)
			Assign("Found", $Found + 1)
		Else
			$Item = GUICtrlCreateListViewItem("Layer " & $Found & "|" & $aLineNumber[$i], $ListView)
			GUICtrlSetImage($Item, $Good)
			If IniRead($INI, "Settings", "SearchAtOpen", "") = "Yes" Then
				$localIndex = _GUICtrlListView_MapIDToIndex($ListView, $Item)
				For $s = 1 To 15 ;read 10 lines ahead because i only have 10 parameters that would create 10 lines max
					$c2MSG = GUIGetMsg()
					If $c2MSG = $CANCEL Then ExitLoop 2
					$SearchLine = FileReadLine($Source, $aLineNumber[$i] + $s)
					If $SearchLine = ";G-Code Modifier DATA Start" Then
						_GUICtrlListView_SetItemText($ListView, $Found - 1, $aLineNumber[$i] + $s, 2) ;Item index is -1 from found count.
						GUICtrlSetImage($localIndex, $Warning)
					EndIf
					If $SearchLine = ";G-Code Modifier DATA End" Then
						_GUICtrlListView_SetItemText($ListView, $Found - 1, $aLineNumber[$i] + $s, 3) ;Item index is -1 from found count.
						GUICtrlSetImage($localIndex, $Warning)
					EndIf
				Next
			EndIf
			Assign("Found", $Found + 1)
		EndIf
	Next
	$CountLines = _FileCountLines($Source)
	If StringInStr (FileReadLine ($Source,$CountLines)," ;Custom Command END OF CODE") > "" Then
		If MsgBox (4,"FYI","WARNING" & @CRLF & "There is: " & FileReadLine ($Source,$CountLines) & @CRLF & "Would you like to remove this custom code ?",'',$MainGUI) = 6 Then _FileWriteToLine($Source,$CountLines,"",1); erase line
	EndIf
	GUIDelete($SearchGUI)
	WinActivate($MainGUI)
	_GUICtrlStatusBar_SetText($StatusBar, "Found " & $Found & " Layer records")
	Assign("Found", 1)
	GUISetState (@SW_SHOW,$MainGUI)
EndFunc   ;==>_OpenCura
Func _OpenSlic3r()
	$SearchInputSlic3r = "; move to next layer (" ; move to next layer (0)"
	If $Source = "" Then
		$Source = FileOpenDialog("Open G-Code file", "", "G-Code files (*.gcode;*.gco;*.g)")
	EndIf
	$SearchGUI = GUICreate("SEarching", 200, 100, -1, -1, -1, -1, $MainGUI)
	$SearchLabel = GUICtrlCreateLabel("Searching: Please wait", 10, 30, 180, 20, $SS_CENTER)
	GUICtrlSetFont(-1, 10, 600)
	$CANCEL = GUICtrlCreateButton("CANCEL", 10, 60, 180, 40)
	GUICtrlSetFont(-1, 12, 600)
	GUISetState(@SW_SHOW, $SearchGUI)
	Assign("Found", 1)
	Local $SourceRead, $aLayers, $aLineNumber, $i
	$SourceRead = FileRead($Source) ;created by fileopendialog
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView))
	_GUICtrlStatusBar_SetText($StatusBar, "Searching")
	$aLayers = FileReadToArray($Source)
	$aLineNumber = _ArrayFindAll($aLayers, $SearchInputSlic3r, 0, 0, 0, 1) ;Search for this array containing given text
	For $i = 0 To UBound($aLineNumber) - 1
		$cMSG = GUIGetMsg()
		If $cMSG = $CANCEL Then ExitLoop 1
		If StringInStr($aLayers[$aLineNumber[$i]], ";Layer:-") > 0 Then
			$NewItem = GUICtrlCreateListViewItem("RAFT Layer" & $i & "|" & $aLineNumber[$i], $ListView)
			GUICtrlSetImage($NewItem, $Warning)
			Assign("Found", $Found + 1)
		Else
			$Item = GUICtrlCreateListViewItem("Layer " & $Found & "|" & $aLineNumber[$i], $ListView)
			GUICtrlSetImage($Item, $Good)
			If IniRead($INI, "Settings", "SearchAtOpen", "") = "Yes" Then
				$localIndex = _GUICtrlListView_MapIDToIndex($ListView, $Item)
				For $s = 1 To 15 ;read 14 lines ahead because i only have 10 parameters that would create 10 lines max
					$c2MSG = GUIGetMsg()
					If $c2MSG = $CANCEL Then ExitLoop 2
					$SearchLine = FileReadLine($Source, $aLineNumber[$i] + $s)
					If $SearchLine = ";G-Code Modifier DATA Start" Then
						_GUICtrlListView_SetItemText($ListView, $Found - 1, $aLineNumber[$i] + $s, 2) ;Item index is -1 from found count.
						GUICtrlSetImage($localIndex, $Warning)
					EndIf
					If $SearchLine = ";G-Code Modifier DATA End" Then
						_GUICtrlListView_SetItemText($ListView, $Found - 1, $aLineNumber[$i] + $s, 3) ;Item index is -1 from found count.
						GUICtrlSetImage($localIndex, $Warning)
					EndIf
				Next
			EndIf
			Assign("Found", $Found + 1)
		EndIf
	Next
	$CountLines = _FileCountLines($Source)
	If StringInStr (FileReadLine ($Source,$CountLines)," ;Custom Command END OF CODE") > "" Then
		If MsgBox (4,"FYI","WARNING" & @CRLF & "There is: " & FileReadLine ($Source,$CountLines) & @CRLF & "Would you like to remove this custom code ?",'',$MainGUI) = 6 Then _FileWriteToLine($Source,$CountLines,"",1); erase line
	EndIf
	GUIDelete($SearchGUI)
	WinActivate($MainGUI)
	_GUICtrlStatusBar_SetText($StatusBar, "Found " & $Found & " Layer records")
	Assign("Found", 1)
EndFunc   ;==>_OpenSlic3r
Func _OpenCraftWare() ;Open file
	$SearchInputCraftWare = "; Layer #"
	If $Source = "" Then
		$Source = FileOpenDialog("Open G-Code file", "", "G-Code files (*.gcode;*.gco;*.g)")
	EndIf
	$SearchGUI = GUICreate("Searching", 200, 100, -1, -1, -1, -1, $MainGUI)
	$SearchLabel = GUICtrlCreateLabel("Searching: Please wait", 10, 30, 180, 20, $SS_CENTER)
	GUICtrlSetFont(-1, 10, 600)
	$CANCEL = GUICtrlCreateButton("CANCEL", 10, 60, 180, 40)
	GUICtrlSetFont(-1, 12, 600)
	GUISetState(@SW_SHOW, $SearchGUI)
	Assign("Found", 1)
	Local $SourceRead, $aLayers, $aLineNumber, $i
	$SourceRead = FileRead($Source) ;created by fileopendialog
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView))
	_GUICtrlStatusBar_SetText($StatusBar, "Searching")
	$aLayers = "" ;Array is stored here by next line
	$array =  _FileReadToArray($Source,$aLayers) ;New update ?
	;Used to be $aLayers = FileReadToArray($Source)
	$aLineNumber = _ArrayFindAll($aLayers, $SearchInputCraftWare, 0, 0, 0, 1) ;Search for this array containing given text
	For $i = 0 To UBound($aLineNumber) - 1
		$cMSG = GUIGetMsg()
		If $cMSG = $CANCEL Then ExitLoop 1
		;If StringInStr($aLayers[$aLineNumber[$i]], "; Layer #0") > 0 Then
			;$NewItem = GUICtrlCreateListViewItem("RAFT Layer" & $i & "|" & $aLineNumber[$i], $ListView)
			;GUICtrlSetImage($NewItem, $Warning)
			;Assign("Found", $Found + 1)
		;Else
		;Not counting rafts or brims, they all start with layer 0 1 2 3 etc, no negative values
			$Item = GUICtrlCreateListViewItem("Layer " & $Found & "|" & $aLineNumber[$i], $ListView)
			GUICtrlSetImage($Item, $Good)
		If IniRead($INI, "Settings", "SearchAtOpen", "") = "Yes" Then
				$localIndex = _GUICtrlListView_MapIDToIndex($ListView, $Item)
				For $s = 1 To 15 ;read 10 lines ahead because i only have 10 parameters that would create 10 lines max
					$c2MSG = GUIGetMsg()
					If $c2MSG = $CANCEL Then ExitLoop 2
					$SearchLine = FileReadLine($Source, $aLineNumber[$i] + $s)
					If $SearchLine = ";G-Code Modifier DATA Start" Then
						_GUICtrlListView_SetItemText($ListView, $Found - 1, $aLineNumber[$i] + $s, 2) ;Item index is -1 from found count.
						GUICtrlSetImage($localIndex, $Warning)
					EndIf
					If $SearchLine = ";G-Code Modifier DATA End" Then
						_GUICtrlListView_SetItemText($ListView, $Found - 1, $aLineNumber[$i] + $s, 3) ;Item index is -1 from found count.
						GUICtrlSetImage($localIndex, $Warning)
					EndIf
				Next
			EndIf
		Assign("Found", $Found + 1)
		;EndIf ;REMOVE THIS QUOTE to enable raft layer search.
	Next
	$CountLines = _FileCountLines($Source)
	If StringInStr (FileReadLine ($Source,$CountLines)," ;Custom Command END OF CODE") > "" Then
		If MsgBox (4,"FYI","WARNING" & @CRLF & "There is: " & FileReadLine ($Source,$CountLines) & @CRLF & "Would you like to remove this custom code ?",'',$MainGUI) = 6 Then _FileWriteToLine($Source,$CountLines,"",1); erase line
	EndIf
	GUIDelete($SearchGUI)
	WinActivate($MainGUI)
	_GUICtrlStatusBar_SetText($StatusBar, "Found " & $Found & " Layer records")
	Assign("Found", 1)
EndFunc   ;==>_OpenCraftWare
Func _ClearLayer() ;Delete entries from file
	$ErasedLines = 0
	$LineToDelete = _GUICtrlListView_GetItemText($ListView, $Index, 2) ;Read 3nd collumn for selected item
	$LastLine = _GUICtrlListView_GetItemText($ListView, $Index, 3);Read 4th collumn for selected item
	If StringInStr(FileReadLine($Source, $LastLine + 1), ";Custom Command LAYER") > "" Then _FileWriteToLine($Source, $LastLine + 1, "", 1) ;delete custom command first
	For $l = $LineToDelete To $LastLine ;Erase line including start and end of my codes
		_FileWriteToLine($Source, $LineToDelete, "", 1) ;delete the line
		Assign("ErasedLines", $ErasedLines + 1)
	Next
EndFunc   ;==>_ClearLayer
Func _ClearValues() ;clear GUI controls
	GUICtrlSetData($NewNozzleTemp, "")
	GUICtrlSetData($NewBedTemp, "")
	GUICtrlSetData($NewCoolingFanSpeed, "")
	GUICtrlSetData($NewSpeed, "")
	GUICtrlSetData($NewFeedRate, "")
	GUICtrlSetData($PauseResume, "No")
	GUICtrlSetData($MoveAxis, "No")
	GUICtrlSetData($MoveX, "0")
	GUICtrlSetData($MoveY, "0")
	GUICtrlSetData($CustomCommand, "")
	GUICtrlSetData($CustomCommand, "M81 ;Power OFF|M117 Type your message", "")
	GUICtrlSetData($CustomCommandTop, "")
	GUICtrlSetData($CustomCommandTop, "M117 Type your message|M201 X500 Y500 ;Motors damper","")
EndFunc   ;==>_ClearValues
Func _ModifyModSTarttoModEnd()
	GUISetState (@SW_LOCK)
	For $s = 1 To 15 ;read 14 lines ahead because i only have 13 parameters that would create 13 lines max
		$SearchLine = FileReadLine($Source, $Line + $s)
		If $SearchLine = ";G-Code Modifier DATA Start" Then
			_GUICtrlListView_SetItemText($ListView, $Index, $Line + $s, 2)
			GUICtrlSetImage(GUICtrlRead($ListView), $Warning)
		EndIf
		If $SearchLine = ";G-Code Modifier DATA End" Then
			_GUICtrlListView_SetItemText($ListView, $Index, $Line + $s, 3)
			GUICtrlSetImage(GUICtrlRead($ListView), $Warning)
		EndIf
	Next
	$ModStart = _GUICtrlListView_GetItemText($ListView, $Index, 2) ;Read 3nd collumn for selected item
	$ModEnd = _GUICtrlListView_GetItemText($ListView, $Index, 3) ;Read 4th collumn for selected item
	_GUICtrlStatusBar_SetText($StatusBar, "Selected " & $Layer & " in line " & $Line)
	GUICtrlSetData($Status, $Layer & " selected.")
	If $ModStart > "" Then ;Clear all GUI values
		GUICtrlSetData($NewNozzleTemp, '')
		GUICtrlSetData($NewBedTemp, '')
		GUICtrlSetData($NewCoolingFanSpeed, '')
		GUICtrlSetData($NewSpeed, '')
		GUICtrlSetData($NewSpeed, '')
		GUICtrlSetData($NewFeedRate, '')
		GUICtrlSetData($MoveX, '0')
		GUICtrlSetData($MoveY, '0')
		GUICtrlSetData($PauseResume, "No")
		GUICtrlSetData($MoveAxis, "No")
		GUICtrlSetData($CustomCommand, "")
		GUICtrlSetData($CustomCommand, "M81 ;Power OFF|M117 Type your message", "")
		For $B = 1 To 14 ;Search 13 lines below for any text and set data if found some.
			$String = FileReadLine($Source, $ModStart + $B)
			$Code = StringLeft($String, StringInStr($String, ";") - 1)
			If StringInStr($String, ";New Nozzle Temperature") > "" Then
				$ValueOnly = StringTrimLeft($Code, 6) ;M104 S code found Extruder Temperature
				GUICtrlSetData($NewNozzleTemp, $ValueOnly)
			EndIf
			If StringInStr($String, ";New Bed Temperature") > "" Then
				$ValueOnly = StringTrimLeft($Code, 6) ;M106 S code found bed temperature
				GUICtrlSetData($NewBedTemp, $ValueOnly)
			EndIf
			If StringInStr($String, ";New Fan Speed") > "" Then
				$ValueOnly = StringTrimLeft($Code, 6) ;M106 S code found Fan speed
				GUICtrlSetData($NewCoolingFanSpeed, $ValueOnly)
			EndIf
			If StringInStr($String, ";New Print Speed") > "" Then
				$ValueOnly = StringTrimLeft($Code, 6) ; code found speed factor
				GUICtrlSetData($NewSpeed, $ValueOnly)
			EndIf
			If StringInStr($String, ";New Feed/Flow rate") > "" Then
				$ValueOnly = StringTrimLeft($Code, 6) ; code found Feedrate/Extrusion
				GUICtrlSetData($NewFeedRate, $ValueOnly)
			EndIf
			If StringInStr($String, ";Move extruder") > "" Then
				$ValueOnlyX = StringTrimLeft($Code, 4) ; code found Move away coordinates G1 XY
				$XOnly = Stringleft($ValueOnlyX, StringInStr($ValueOnlyX, "Y")-2)
				$ValueOnlyY = StringTrimLeft($Code, StringInStr($Code, "Y")) ; code found Move away coordinates G1 XY
				$YOnly = StringTrimRight($ValueOnlyY, 1)
				GUICtrlSetData($MoveX, $XOnly)
				GUICtrlSetData($MoveY, $YOnly)
			EndIf
			If StringInStr($String, ";Pause") > "" Then GUICtrlSetData($PauseResume, "Yes")
			If StringInStr($String, ";Move back to remembered position") > "" Then GUICtrlSetData($MoveAxis, "Yes")
			If StringInStr($String, ";Custom Command END OF CODE") > "" Then
				GUICtrlSetData($CustomCommand, "") ;NOT SURE
				$FoundCommand = StringLeft($String, StringInStr($String, " ;Custom Command END OF CODE") - 1)
				GUICtrlSetData($CustomCommand, "M81 ;Power OFF|M117 Type your message|" & $FoundCommand, $FoundCommand)
				GUICtrlSetState($YesAtTheEnd, $GUI_CHECKED)
			EndIf
			If StringInStr($String, ";Custom Command LAYER") > "" Then
				GUICtrlSetData($CustomCommand, "") ;NOT SURE
				$FoundCommand = StringLeft($String, StringInStr($String, " ;Custom Command LAYER") - 1)
				GUICtrlSetData($CustomCommand, "M81 ;Power OFF|M117 Type your message|" & $FoundCommand, $FoundCommand)
				GUICtrlSetState($NoAtTheEnd, $GUI_CHECKED)
			EndIf
		Next
	Else ;entere default valuse
		If IniRead($INI, "Settings", "ClearValulesOnClick", "") = "Yes" Then _ClearValues()
	EndIf
	GUISetState (@SW_UNLOCK)
EndFunc   ;==>_ModifyModSTarttoModEnd
Func _RemoveLayers ($LS, $LE)
	;Starting and ending line numbers are $StartLineToRemove and $EndLineToRemove
	If $LS < $LE Then ;; Can't go backwards...
        For $i = $LS To $LE
            $line = _FileWriteToLine($sFilePath, $i, "", 1)
        Next
    EndIf
	MsgBox(0,'','DONE')
EndFunc