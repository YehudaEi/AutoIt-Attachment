#include <GuiButton.au3>
#include <ButtonConstants.au3>
#include <GuiComboBox.au3>
#include <GUIListBox.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <_XMLDomWrapper.au3>
#Include <Array.au3>
#include <Date.au3>
#include <INet.au3>


Opt("MouseCoordMode", 2) ;1=absolute, 0=relative, 2=client
Opt("PixelCoordMode", 2) ;1=absolute, 0=relative, 2=client
Opt("GUIResizeMode", $GUI_DOCKALL) ;$GUI_DOCKALL = so the control will not move during resizing

Global $DebuggerWindow, $DebuggerList, $Paused, $Name = "Morte Program v1.8", $sVersion = "1.8", $ver, $update, $MorteX
Global $sXPath, $sXMLFile, $sXML, $stringSearch, $replaceWrite, $xmlCheck = 0, $sNewData1, $sNewData0

Global $PixelSearchx[2], $PixelSearchy[2], $PixelGetColorx[4], $PixelGetColory[4], $MouseClickx[4] = ["", "", "", "396"], $MouseClicky[4] = ["", "", "", "375"]
Global $PixelMColorx[4], $PixelMColory
Global $searchTxtF, $searchTxtS

Global $Colors[3], $counters0, $counters1, $counters2, $counter

Global $screenRes, $logoutOC, $debugMode, $restoreWin

Global $screenResCMB, $debugCHK

Global $ready, $stopped, $running, $blankBG, $drac, $durRed, $durGreen, $DuraSF, $dracCHK, $sTimer, $rChecker = 0

Global $size = WinGetPos("[CLASS:Notepad]")
Global $state = WinGetState ( "[CLASS:Notepad]")

AdlibRegister("Variable_Checker", 7)
AdlibRegister("Counter_Checker", 7)

;! = Alt, ^ = Ctrl
HotKeySet("!{INSERT}", "TogglePause")
HotKeySet("!{DELETE}", "ToggleReset")
HotKeySet("!{ESCAPE}", "Terminate")


;Checks Input for Correct Name format to edit correct XML File
Local $userName = Inputbox("Fill in User name", "Please fill in your User name" )
Global $UserN = NameChecker($userName) ;Checks to make sure userName Correct Format for filename.

loadSettings(0) ;Load ini Settings.

iniChecker() ;Check to make sure ini exist

;Edits the Xml files with the following	($searchStart, $searchEnd, $sNewData, $replaceStart, $replaceEnd, $advOpt)
If IniRead("Settings.ini", "Settings", "byPass", "") = False or IniRead("Settings.ini", "Settings", "byPass", "") = 0 Then
	xmlAdjusterChk()
	xmlAdjusterBak()
	xmlAdjusterGen('<Window Name="Message"', ' size="232,79" visible="true" />', StringReplace('  size="232,79" visible="false" ', "\", "\\"), '<Window Name="Message"', ' />', 0)
	xmlAdjusterGen('<Window Name="User"', ' size="160,106" visible="true" />', StringReplace(' size="160,106" visible="false" ', "\", "\\"), '<Window Name="User"', ' />', 1)
Else
	Starter(0, $UserN)
EndIf

;----------Programmer Notes----------;
;
;			   Hex Color Display site:    http://www.color-hex.com/color/573D38
;Binary/Decimal/Hexadecimal Converter:    http://www.mathsisfun.com/binary-decimal-hexadecimal-converter.html
;		  Convery Hex(RGB) to Decimal:    http://www.psyclops.com/tools/rgb/
;                                    
;------------------------------------;

Func Counter_Checker()
		
	If WinActive("[CLASS:Notepad]") = True And $rChecker = 1 Then
		
		If $ready = $stopped Then
			
			If $drac = $durRed Then
				
				If $counter = $Colors[2] OR IsArray($counters2) = True Then
					Send(3)
					If $debugMode = 1 then Debugger("$Counterkey:", 3)
				ElseIf $counter = $Colors[1] OR IsArray($counters1) = True Then
					Send(2)
					If $debugMode = 1 then Debugger("$Counterkey:", 2)
				ElseIf $counter = $Colors[0] OR IsArray($counters0) = True Then
					Send(1)
					If $debugMode = 1 then Debugger("$Counterkey:", 1)
				EndIf
				
			ElseIf $drac = $durGreen Then
					
				If $counter = $Colors[2] OR IsArray($counters2) = True  Then
					Send(6)
					If $debugMode = 1 then Debugger("$Counterkey:", 6)
				ElseIf $counter = $Colors[1] OR IsArray($counters1) = True Then
					Send(5)
					If $debugMode = 1 then Debugger("$Counterkey:", 5)
				ElseIf $counter = $Colors[0] OR IsArray($counters0) = True Then 
					Send(4)
					If $debugMode = 1 then Debugger("$Counterkey:", 4)
				EndIf
			
			EndIf
		
		EndIf
	
	EndIf
	
EndFunc

Func Variable_Checker()
	
	If WinActive("[CLASS:Notepad]") = True Then
		
		$ready = PixelGetColor($PixelGetColorx[0], $PixelGetColory[0])
		$stopped = 9514768
		$running = 7250747
		$counter = PixelGetColor($PixelGetColorx[1], $PixelGetColory[1])
				
		$counters0 = PixelSearch($PixelGetColorx[1], $PixelGetColory[1], $PixelGetColorx[1], $PixelGetColory[1], $Colors[0], 7)
		$counters1 = PixelSearch($PixelGetColorx[1], $PixelGetColory[1], $PixelGetColorx[1], $PixelGetColory[1], $Colors[1], 7)
		$counters2 = PixelSearch($PixelGetColorx[1], $PixelGetColory[1], $PixelGetColorx[1], $PixelGetColory[1], $Colors[2], 7)
		
		$blankBG = 2038302
		$drac = PixelGetColor($PixelGetColorx[2], $PixelGetColory[2])
		$durRed = 3805467
		$durGreen = 2079786
		$DuraSF = 2078762
		$dracCHK = PixelSearch($PixelGetColorx[3], $PixelGetColory[3], $PixelGetColorx[3], $PixelGetColory[3], $DuraSF, 4)
		$sTimer = Random(1300, 1600)
	
		
		$searchTxtF = PixelSearch(45, 145, 45, 145, 1116940, 7)
		$searchTxtS = PixelSearch(46, 190, 46, 190, 1182475, 7)
		
		;Debug Variables
		If $debugMode = 1 then Debugger("$Counter:", $counter)
		If $debugMode = 1 then Debugger("$rChecker:", $rChecker)
		
	EndIf
	
EndFunc

;/////////////////////////////////GUI Inferface\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Func mygui()

#Region ### Start-GUI
	$MorteX = GUICreate($Name, 300, 162, 719, 467)
	GUISetBkColor(0x3A6EA5)
	WinSetOnTop($MorteX, "", 1) 

	#Region ###
		$file = GUICtrlCreateMenu("File")
		$config = GUICtrlCreateMenuItem("Configure", $file)
		$exit = GUICtrlCreateMenuItem("Exit", $file)
		
		$help = GUICtrlCreateMenu("Help")
	#EndRegion ###
		
	#Region ### Version Checker
	$ver_label = GUICtrlCreateLabel("Version:", 112, 123, 50, 17)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0xFFFFFF)
	
	$ver = GUICtrlCreateLabel(" ", 160, 123, 100, 17)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0xC0C0C0)
	GUICtrlSetState($ver, $GUI_HIDE)
	
	$update = GUICtrlCreateLabel(" ", 160, 123, 100, 17)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0xC0C0C0)
	GUICtrlSetState($update, $GUI_HIDE)
	#EndRegion ###
	
				
	#Region ### Start-GUI Debugger Window
		$DebuggerWindow = GUICreate("Debugger Window", 302, 334, 355, 185, BitOR($WS_BORDER, $WS_CAPTION))
		GUISetBkColor(0x000000)
		WinSetOnTop($DebuggerWindow, "", 1)
	
		$DWClear = GUICtrlCreateButton("Clear", 5, 312, 50, 17)
		GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0xFFFFFF)
		GUICtrlSetBkColor(-1, 0x000000)
		
		$DWCopy = GUICtrlCreateButton("Copy", 245, 312, 50, 17)
		GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0xFFFFFF)
		GUICtrlSetBkColor(-1, 0x000000)

		$Group0 = GUICtrlCreateGroup("Debugger", 5, 5, 290, 302)
		GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0xFFFFFF)
	
			$DebuggerList = GUICtrlCreateList("", 10, 23, 280, 279, BitOR($WS_BORDER, $WS_VSCROLL, $LBS_EXTENDEDSEL))
			GUICtrlSetData(-1, "")

			GUICtrlSetData($DebuggerList, "$Colors[0]:" & " = " & "")
			GUICtrlSetData($DebuggerList, "$Colors[1]:" & " = " & "")
			GUICtrlSetData($DebuggerList, "$Colors[2]:" & " = " & "")
			GUICtrlSetData($DebuggerList, "/" & " = " & "---------------------------- = \")
			GUICtrlSetData($DebuggerList, "$Counter:" & " = " & "")
			GUICtrlSetData($DebuggerList, "$Counter:Red" & " = " & "")
			GUICtrlSetData($DebuggerList, "$Counter:Green" & " = " & "")
			GUICtrlSetData($DebuggerList, "$key:" & " = " & "")
			GUICtrlSetData($DebuggerList, "$Counterkey:" & " = " & "")
			GUICtrlSetData($DebuggerList, "$rChecker:" & " = " & "")
		
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		
	#EndRegion ### End-GUI
	
	GUISetState(@SW_SHOW, $MorteX)

#EndRegion ### End-GUI


;~ Sets and Checks main program version w/ Links to Update.
Version_Checker()

loadSettings(1) ;Load ini Settings.

While 1
	
	$nMsg = GUIGetMsg()
	Switch $nMsg
		
		Case $GUI_EVENT_CLOSE
		
			If $restoreWin = 1 Then programQuit()
			
			;Check if XML has been backup already, Delete it.
			If FileExists($sXPath & $sXMLFile & ".bak") Then
				FileDelete($sXPath & $sXMLFile & ".bak")
			EndIf				
	
			ExitLoop
				
		Case $config
			
			GUISetState(@SW_DISABLE, $MorteX)
            MorteConfig(1, 0, 0)
            GUISetState(@SW_ENABLE, $MorteX)
			loadSettings(1) ;Load ini Settings.
				
		Case $exit
				
			If $restoreWin = 1 Then programQuit()
				
			;Check if XML has been backup already, Delete it.
			If FileExists($sXPath & $sXMLFile & ".bak") Then
				FileDelete($sXPath & $sXMLFile & ".bak")
			EndIf				
	
			ExitLoop

		Case $DebuggerList
				
			$listSelected = GUICtrlRead ($DebuggerList, 1)
			ClipPut($listSelected)	

		Case $DWClear
			
			GUICtrlSetData($DebuggerList, "") ;Clear Listbox
			GUICtrlSetData($DebuggerList, "$Colors[0]:" & " = " & "")
			GUICtrlSetData($DebuggerList, "$Colors[1]:" & " = " & "")
			GUICtrlSetData($DebuggerList, "$Colors[2]:" & " = " & "")
			GUICtrlSetData($DebuggerList, "/" & " = " & "---------------------------- = \")
			GUICtrlSetData($DebuggerList, "$Counter:" & " = " & "")
			GUICtrlSetData($DebuggerList, "$Counter:Red" & " = " & "")
			GUICtrlSetData($DebuggerList, "$Counter:Green" & " = " & "")
			GUICtrlSetData($DebuggerList, "$key:" & " = " & "")
			GUICtrlSetData($DebuggerList, "$Counterkey:" & " = " & "")
			GUICtrlSetData($DebuggerList, "$rChecker:" & " = " & "")
				
			ClipPut("")
			
		Case $DWCopy
			
			;Count how many lines in DebuggerList
			$DWCount = _GUICtrlListBox_GetCount($DebuggerList)
			
			ClipPut("") ;Make sure clipboard is clear
			Local $sItems = "" ;Make sure Variable is clear
						
			;Set a String With Each Line in DebuggerList, Add Return Key
			For $dwI = 0 To $DWCount -1 Step 1
				$sItems = $sItems & _GUICtrlListBox_GetText($DebuggerList, $dwI) & @CRLF
			Next
			ClipPut($sItems)
		Case $update
			ShellExecute("http://127.0.0.1/file_dump/MorteX v" & $CurrentVer & ".zip")
		Case $ver
			ShellExecute("http://127.0.01/file_dump/")

		
	EndSwitch
	
WEnd	

EndFunc   ;==>mygui

Func MorteConfig($NoDebugCHK, $TSSR, $BDIR)
#Region ###
	$MorteXConfig = GUICreate("Choices Dialog", 537, 385, 192, 176)
	GUISetBkColor(0x3A6EA5)

	#Region ### Screen Size Section
		$Group2 = GUICtrlCreateGroup("Screen Size", 360, 5, 169, 177)
		GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0xFFFFFF)
	
			;Combobox for selecting Screen Size
			$screenResCMB = GUICtrlCreateCombo("", 371, 133, 146, 25)
			_GUICtrlComboBox_InsertString($screenResCMB, "Select One...", 0)
			_GUICtrlComboBox_SetCurSel($screenResCMB, 0) ;Have "Select One" Set as Default setting
			_GUICtrlComboBox_InsertString($screenResCMB, "Default", 1)
			
			If $TSSR = 0 Then
				GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
				GUICtrlSetColor(-1, 0x000000)
			ElseIf $TSSR = 1 Then
				GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
				GUICtrlSetColor(-1, 0x000000)
				GUICtrlSetBkColor(-1, 0xFF0000)
			EndIf

		GUICtrlCreateGroup("", -99, -99, 1, 1)
	#EndRegion ###
	
	#Region ### Misc Configure Options
		$Group3 = GUICtrlCreateGroup("Misc Options", 8, 192, 521, 153)
		GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0xFFFFFF)
			
			$divider0 = GUICtrlCreateGraphic(228, 199, 3, 145)
			GUICtrlSetBkColor(-1, 0xFFFFFF)
			GUICtrlCreateGroup("", -99, -99, 1, 1)

			$debugCHK = GUICtrlCreateCheckbox("Debug Mode", 238, 285, 105, 25)
			GUICtrlSetColor(-1, 0xC0C0C0)
			

		GUICtrlCreateGroup("", -99, -99, 1, 1)
	#EndRegion ###
	
	#Region ### Configure buttons
		
		$buttonsave = GUICtrlCreateButton("OK", 376, 353, 75, 25)
		GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0xFFFFFF)
		GUICtrlSetBkColor(-1, 0x000000)
		
		$buttoncancel = GUICtrlCreateButton("Cancel", 456, 353, 75, 25)
		GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0xFFFFFF)
		GUICtrlSetBkColor(-1, 0x000000)		

	#EndRegion ###
	
	GUISetState(@SW_SHOW)

iniSetSettings()

While 1
	
	$nMsg = GUIGetMsg()
	
	Switch $nMsg
		
		Case $GUI_EVENT_CLOSE
		
			GUIDelete($MorteXConfig)
			ExitLoop
			
		Case $buttonsave
			Global $screenRes = GUICtrlRead($screenResCMB), $debugMode = BitAnd(GUICtrlRead($debugCHK),$GUI_CHECKED)
			
			If $screenRes = "Select One..." Then
				$screenRes = ""
			EndIf
			
			If FileExists(@ScriptDir & "\Settings.ini") Then
				FileDelete(@ScriptDir & "\Settings.ini")
			EndIf

			Opt("MustDeclareVars", 1)       ;0=no, 1=require pre-declare
			
			;Help Section
			IniWrite("Settings.ini", "HELP", "#0", $Name & " Configure File")
			IniWrite("Settings.ini", "HELP", "#1", "Value 0 equals No")
			IniWrite("Settings.ini", "HELP", "#2", "Value 1 equals Yes" & @CRLF & @CRLF)
			
			
			;[ScreenSize]
			IniWrite("Settings.ini", "ScreenSize", "resolutions",  $screenRes & @CRLF)
			
			;[Settings]
			IniWrite("Settings.ini", "Settings", "debug_mode",  $debugMode)
					
			Opt("MustDeclareVars", 0)       ;0=no, 1=require pre-declare
			
			GUIDelete($MorteXConfig)
			
			If $NoDebugCHK = 0 Then
				loadSettings(0) ;Load ini Settings, Load Debugger if Checked.
			ElseIf $NoDebugCHK = 1 Then
				loadSettings(1) ;Load ini Settings, Load Debugger if Checked.
			EndIf
			
			ExitLoop

		Case $buttoncancel
			
			GUIDelete($MorteXConfig)
			ExitLoop
			
	EndSwitch
	
WEnd

EndFunc

;/////////////////////////////////Extra Functions\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Func Version_Checker()

$hDownload = InetGet("http://127.0.0.1/check.ver", @TempDir & "\check.ver", 1, 1)

Do
Sleep(250)
Until InetGetInfo($hDownload, 2)	; Check if the download is complete.

Global $CurrentVer = IniRead(@TempDir & "\check.ver", "Main", "version", "")

FileDelete(@TempDir & "\check.ver")

if $CurrentVer > $sVersion then
	GUICtrlSetState($update, $GUI_SHOW)
	GUICtrlSetState($ver, $GUI_HIDE)
	
	GUICtrlSetData($update, "Out of Date " & $CurrentVer)
	GUICtrlSetColor($update, 0xFF0000)
ElseIf $CurrentVer = $sVersion then
	GUICtrlSetState($ver, $GUI_SHOW)
	GUICtrlSetState($update, $GUI_HIDE)
	
	GUICtrlSetData($ver, $CurrentVer)
	GUICtrlSetColor($ver, 0x00FF00)
Else
	GUICtrlSetState($update, $GUI_SHOW)
	GUICtrlSetState($ver, $GUI_HIDE)
	
	GUICtrlSetData($update, "Out of Date " & $CurrentVer)
	GUICtrlSetColor($update, 0xFF0000)
EndIf

EndFunc

Func TogglePause()
	
	$Paused = Not $Paused
	While $Paused
		Sleep(100)
		ToolTip('Script is "Paused"', 0, 0)
		$rChecker = 0
	WEnd
	$rChecker = 1
	ToolTip("")
	
EndFunc   ;==>TogglePause

Func ToggleReset()

If $rChecker <> 0 Then $rChecker = 0

EndFunc

Func Terminate()
	
	If $restoreWin = 1 Then programQuit()
		
	;Check if XML has been backup already, Delete it.
	If FileExists($sXPath & $sXMLFile & ".bak") Then
		FileDelete($sXPath & $sXMLFile & ".bak")
	EndIf
	
	Exit 0
	
EndFunc

Func iniChecker()

If Not FileExists(@ScriptDir & "\Settings.ini") Then
	MorteConfig(1, 0, 0)
	loadSettings(0) ;Load ini Settings.
EndIf

EndFunc

Func loadSettings($noIni)

;Resolution Size Variables Set
If IniRead("Settings.ini", "ScreenSize", "resolutions", "") = "Default" Then
	Call ("ResChooser","0", "0")
EndIf

If IniRead("Settings.ini", "Settings", "debug_mode", "") = True Then $debugMode = IniRead("Settings.ini", "Settings", "debug_mode", "")

If $noIni <> 0 Then
	
	If $debugMode = 1 Then

		$Win1 = WinGetPos($MorteX) ; X, Y, W, H
		$Win2 = WinGetPos($DebuggerWindow)
		WinMove ( $DebuggerWindow, "", $Win1[0], $Win1[1] - $Win2[3], Default, Default, 2 )
		
		GUISetState(@SW_SHOW, $DebuggerWindow)

	ElseIf $debugMode = 0 Then

		GUISetState(@SW_HIDE, $DebuggerWindow)

	EndIf
		
EndIf

EndFunc

Func iniSetSettings()

	;Check ini for screen resolution
	If IniRead("Settings.ini", "ScreenSize", "resolutions", "") = "Default" Then
		_GUICtrlComboBox_SetCurSel($screenResCMB, 1)
	Else 
		_GUICtrlComboBox_SetCurSel($screenResCMB, 0) ;Default Setting
	EndIf
	
	If IniRead("Settings.ini", "Settings", "debug_mode", "") = 1 Then
		GUICtrlSetState($debugCHK, $GUI_CHECKED)
	Else 
		GUICtrlSetState($debugCHK, $GUI_UNCHECKED)
	EndIf
	
EndFunc

Func Starter($loader, $User)

;Check Make sure XML wasn't edited if edited then Load Settings.
If $xmlCheck > 0 Then
	$loader = 1
Else
	$loader = 0
EndIf

If $loader = 0 Then
	
	WinActivate("[CLASS:Notepad]")
	$winWait = WinWaitActive("[CLASS:Notepad]", "", 60)
	
	If $winWait = 0 Then
		MsgBox(16, "Error " & $winWait, "Failure: Timeout occurred. ")
	EndIf
	
	If WinActivate("[CLASS:Notepad]") Then
		
		Opt("SendKeyDelay", 60)
		Sleep(1600)

		Send("Z")
						
		Opt("SendKeyDelay", 5)	
		
		Call ("mygui")
						
	EndIf

ElseIf $loader = 1 Then
	
	WinActivate("[CLASS:Notepad]")
	$winWait = WinWaitActive("[CLASS:Notepad]", "", 60)
	
	If $winWait = 0 Then
		MsgBox(16, "Error " & $winWait, "Failure: Timeout occurred. ")
	EndIf
	
	If WinActivate("[CLASS:Notepad]") Then
		
		Opt("SendKeyDelay", 60)
		Sleep(1600)
		

	Send("{ENTER}")
	Sleep(700)
	Send("settings.xml " & " Edited BY: " & $User & "  " & _DateTimeFormat( _NowCalc(),1))
	Sleep(700)
	Send("{ENTER}")
	Sleep(700)
		
		Opt("SendKeyDelay", 5)
			
		Call ("mygui")
		
	EndIf
					
EndIf

EndFunc

Func ResChooser($resSize0, $resSize1)

	If $resSize0 = 0 & $resSize1 = 0 Then
		$resSize = "Default"
	Else
		$resSize = $resSize0 & " x " & $resSize1
	EndIf

	Select
		
		Case $resSize = "Default"
		
		Case $resSize = "1920 x 1080" ;Desktop 1
		
		Case $resSize = "1366 x 768" ;Laptop 1
		
		Case $resSize = "1280 x 1024" ;Desktop 2
		
		Case $resSize = "1600 x 900" ;Laptop 2
		
		Case $resSize = "1024 x 768" ;Desktop 3
	
	EndSelect
	
EndFunc

Func NameChecker($UserName)
	
;Start of User Name Capitalization  Checker
	If @error Or $UserName = "" Then
		MsgBox(0,"ERROR","Please Insert your User Name.")
		Exit
	EndIf

	If StringIsUpper(StringLeft($UserName, 1)) Then
		
		$var0 = StringLeft($UserName, 1) ;Leave first Character Capitalized
		$var1 = StringMid($UserName, 2, 16) ;Force rest of Characters Lowercase
			
		$UserName = $var0 & StringLower($var1) ;Combine output
		
	Else
        
		$var0 = StringLeft($UserName, 1) ;Leave first Character Capitalized
		$var1 = StringMid($UserName, 2, 16) ;Force rest of Characters Lowercase
		
		$UserName = StringUpper($var0) & StringLower($var1) ;Combine output
	
	EndIf
;End User Name Capitalization

Return ($UserName)

EndFunc

Func xmlAdjusterChk()
	
	;XML File to Read/Write	
	$sXPath = "C:\temp" ;Default Location for older Operating Systems
	$sXMLFile = "settings.xml"
	;~ 	ConsoleWrite("sXPath:" & $sXPath & @CRLF)
	If Not FileExists($sXPath & $sXMLFile) Then
		
		$sXPath = "C:\Users\Public\temp\" ;Default Location for Windows 7/Vista
		;~	ConsoleWrite("sXPath:" & $sXPath & @CRLF)
		
		If Not FileExists($sXPath & $sXMLFile) Then
			$sXPath = "C:\ProgramData\temp\" ;Other Location (Dave)
			;~ ConsoleWrite("sXPath:" & $sXPath & @CRLF)
		EndIf
		
		If Not FileExists($sXPath & $sXMLFile) Then
			$sXPath = "D:\temp\" ;Other Location
			;~	ConsoleWrite("sXPath:" & $sXPath & @CRLF)
		EndIf
		
	EndIf

	If FileExists($sXPath & $sXMLFile) Then
		;Do nothing End False Loop
		Return
	EndIf
	
EndFunc

Func xmlAdjusterBak()
	
 FileCopy($sXPath & $sXMLFile, $sXPath & $sXMLFile & ".bak", 1) ;Backup XML before editing it.

EndFunc

Func xmlAdjusterGen($searchStart, $searchEnd, $sNewData, $replaceStart, $replaceEnd, $advOpt)

;Start XML Editing
	
	$sXML = FileRead($sXPath & $sXMLFile)

	; Will Find all matches in ($sXPath + $sXMLFile) File
	$stringSearch = StringRegExp($sXML, "(?i)(" & $searchStart & ")(.*?)(" & $searchEnd & ")", 4)
	
	;XML File String Replace
	$replaceWrite = StringRegExpReplace($sXML, "(?i)(" & $replaceStart & ")(.*?)(" & $replaceEnd & ")", "$1" & $sNewData & "$3") ; Will replace all matches in file
	;End XML Editing

	;If $advOpt <> 0 Then MsgBox(0, "", "Active")
	;If $advOpt <> 1 Then MsgBox(0, "", "Not Active")
		
;Check if XML already has been edited
	If IsArray($stringSearch) = True Then
		
		;MsgBox(0, "", "Changed: " & $searchStart_Res)

		If $advOpt <> 0 Then Starter(0, $UserN)

	
	ElseIf IsArray($stringSearch) = False Then
		
		;MsgBox(0, "", "Changed: " & $searchStart_Res)
		
		$xmlCheck = $xmlCheck + 1
		
		;Check if File was Copied OK.

			FileClose(FileOpen($sXPath & $sXMLFile, 2))
			FileWrite($sXPath & $sXMLFile, $replaceWrite)
			
			;If $advOpt <> 0 Then MsgBox(0, "Active window stats (x,y,width,height):", $size[0] & " " & $size[1] & " " & $size[2] & " " & $size[3])
		
			;Load XML changes then start running
			If $advOpt <> 0 Then Starter(1, $UserN)			
		
	EndIf

EndFunc

Func xmlAdjusterRestore($searchStart_Res, $searchEnd_Res)

;Start XML Editing
	
	; Will Find all matches in ($sXPath + $sXMLFile) File
	$sXML = FileRead($sXPath & $sXMLFile & ".bak")
	$stringSearch0 = StringRegExp($sXML, "(?i)(" & $searchStart_Res & ")(.*?)(" & $searchEnd_Res & ")", 1)
	If IsArray($stringSearch0) Then $sNewData0 = $stringSearch0[1] ;Make sNewData Equal String Searched for Replace.
	
	;Replace XML file thats in use
	$sXML = FileRead($sXPath & $sXMLFile)
	$stringSearch1 = StringRegExp($sXML, "(?i)(" & $searchStart_Res & ")(.*?)(" & $searchEnd_Res & ")", 1)
	If IsArray($stringSearch1) Then $sNewData1 = $stringSearch1[1] ;Make sNewData Equal String Searched for Replace.
	
	;XML File String Replace
	$sXML = FileRead($sXPath & $sXMLFile)
	$replaceWrite0 = StringRegExpReplace($sXML, "(?i)(" & $searchStart_Res & ")(.*?)(" & $searchEnd_Res & ")", "$1" & $sNewData0 & "$3") ; Will replace all matches in file
	
;End XML Editing

;Check if XML already has been edited
	If $sNewData1 = $sNewData0 Then
		
		;MsgBox(0, "", "Changed: " & $searchStart_Res)
	
	ElseIf $sNewData1 <> $sNewData0 Then
		
		;MsgBox(0, "", "Changing: " & $searchStart_Res)
			
		FileClose(FileOpen($sXPath & $sXMLFile, 2))
		FileWrite($sXPath & $sXMLFile, $replaceWrite0)
		
	EndIf

EndFunc

Func programQuit()
	
	WinActivate("[CLASS:Notepad]")
	WinWaitActive("[CLASS:Notepad]")
		
	xmlAdjusterRestore('<Window Name="Message"', ' />')
	xmlAdjusterRestore('<Window Name="User"', ' />')
	
		
	Opt("SendKeyDelay", 60)
	Sleep(1600)
	

	Send("{ENTER}")
	Sleep(700)
	Send("settings.xml " & " Edited BY: " & $User & "  " & _DateTimeFormat( _NowCalc(),1))
	Sleep(700)
	Send("{ENTER}")
	Sleep(700)
	
	If $logoutOC = 1 Then
	
		Send("{ENTER}")
		Sleep(700)
		Send("!{F4}")
		Sleep(700)
		Send("{ENTER}")
						
	EndIf
			
	Opt("SendKeyDelay", 5)


	;Check if XML has been backup already, Delete it.
	If FileExists($sXPath & $sXMLFile & ".bak") Then
		FileDelete($sXPath & $sXMLFile & ".bak")
	EndIf
	
Exit 0
	
EndFunc

Func Debugger($sVarName, $sOutput)

	If IsNumber($sOutput) = 0 And IsString($sOutput) = 0 And IsBool($sOutput) = 0 Then
		$sOutput = "Data cannot be printed."
	EndIf
	
	If $sVarName == "$Colors[0]:" Then
		_GUICtrlListBox_ReplaceString($DebuggerList, 0, $sVarName & " = " & $sOutput)
	ElseIf $sVarName == "$Colors[1]:" Then
		_GUICtrlListBox_ReplaceString($DebuggerList, 1, $sVarName & " = " & $sOutput)
	ElseIf $sVarName == "$Colors[2]:" Then
		_GUICtrlListBox_ReplaceString($DebuggerList, 2, $sVarName & " = " & $sOutput)
	ElseIf $sVarName == "$Counter:" Then
		_GUICtrlListBox_ReplaceString($DebuggerList, 3, $sVarName & " = " & $sOutput)
	ElseIf $sVarName == "$Counter:Red" Then
		_GUICtrlListBox_ReplaceString($DebuggerList, 4, $sVarName & " = " & $sOutput)
	ElseIf $sVarName == "$Counter:Green" Then
		_GUICtrlListBox_ReplaceString($DebuggerList, 5, $sVarName & " = " & $sOutput)
	ElseIf $sVarName == "$key:" Then
		_GUICtrlListBox_ReplaceString($DebuggerList, 6, $sVarName & " = " & $sOutput)
	ElseIf $sVarName == "$Counterkey:" Then
		_GUICtrlListBox_ReplaceString($DebuggerList, 7, $sVarName & " = " & $sOutput)
	ElseIf $sVarName == "$rChecker:" Then
		_GUICtrlListBox_ReplaceString($DebuggerList, 8, $sVarName & " = " & $sOutput)
	Else
		GUICtrlSetData($DebuggerList, $sVarName & " = " & $sOutput)
	EndIf
	
EndFunc
	