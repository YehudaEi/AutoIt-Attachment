; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1.76 Beta
;
; Script Function:
;	Switch Outlook profile.
;
; ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <guiconstants.au3>
#include <constants.au3>
;#include <Array.au3>

$AppName = "OutSwitch"
if WinExists($AppName) = "1" then Exit
	
Dim $Cnt,$Str
Dim $Outlookrunning
Dim $LastProfile
Dim $hcnt
Dim $IniFile

Global $Lang
Global $OptLang
Global $LangDispOpt[3]
Global $LangDispSwitch[3]
Global $LangOptDefProf[3]
Global $LangStat[3]
Global $LangOptAutoStart[3]
Global $LangOptAutoSwitch[3]
Global $LangQuit[3]
Global $LangLoaded[3]
Global $LangLang[3]

Global $SwitchButton


Opt("WinTitleMatchMode", 2)
Opt("TrayMenuMode",1)   ; Default tray menu items (Script Paused/Exit) will not be shown.

$Version = "0.1"
$VersionDate = "28-08-2005"

$IniFile = @ScriptDir  & "\OutSwitch.ini"
SetLang()

;Show splash
SplashImageOn (@ScriptDir & "\splash", "logo.bmp" , 276, 63, (@DesktopWidth/2) - (276/2),(@DesktopHeight/2)-(63/2),1)

$OutlookWinCap = "- Microsoft Outlook"
$OutlookPath = regread("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\OUTLOOK.EXE\","Path")
$Outlookcommand  = $OutlookPath & "outlook.exe /profile "

if FileExists($OutlookPath) = "0" Then
	MsgBox(16,$AppName,"It looks like Outlook is not installed." & @CRLF & @CRLF & "Exiting in 5 seconds.",5)
	Exit
EndIf

if @OSType = "WIN32_NT" Then
	$MainKey = "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles\"
ElseIf @OSType ="WIN32_WINDOWS" Then
	$MainKey = "HKEY_CURRENT_USER\Software\Microsoft\Windows Messaging Subsystem\Profiles\"
Endif

; ############################### Create Main Window
$WinMain = GuiCreate($AppName,300,70,@DesktopWidth-300-100,@DesktopHeight-70-100)
$List = GUICtrlCreateCombo("item1", 10,10,140,80, BitOR(  $LBS_STANDARD, $CBS_SORT))
GetProfiles()
GetDefaultProfile()
$SwitchButton = GuiCtrlCreateButton($LangDispSwitch[$lang], 160,10, 65, 22)
$MainOptionsButton = GuiCtrlCreateButton($LangDispOpt[$lang], 230,10, 65, 22)
$MainProfileDefault = GUICtrlCreateCheckbox ($LangOptDefProf[$lang], 10, 40, 130, 20)
$LabelStatus = GUICtrlCreateLabel  ("", 150, 43, 220, 20)

; ############################### Create Options Window
$WinOptions = GuiCreate($AppName,220,150,@DesktopWidth-320-100,@DesktopHeight-100-150,$WS_SYSMENU,-1, $WinMain)


$OptAutoSwitch = GUICtrlCreateCheckbox ($LangOptAutoSwitch[$Lang], 10, 30, 135, 20)
$OptAutoStart = GUICtrlCreateCheckbox ($LangOptAutoStart[$Lang], 10, 10, 135, 20)
$OptLang = GUICtrlCreateCombo("English", 10,70,100,80,$LBS_STANDARD)
GUICtrlSetData(-1,"Nederlands",IniRead($IniFile, "General", "Language", "English"))

$OptLabLang = GUICtrlCreateLabel  ($langLang[$lang], 10, 55, 220, 20)
$OptOKButton = GuiCtrlCreateButton('Ok', 146,70, 65, 22,$GUI_SS_DEFAULT_BUTTON)

GUICtrlSetState($OptAutoSwitch,iniRead($IniFile, "General", "AutoSwitch", "4"))
GUICtrlSetState($OptAutoStart,iniRead($IniFile, "General", "AutoStart", "4"))

GUISwitch($WinMain)
if iniRead($IniFile, "General", "AutoStart", "4") = 1 then
	GUISetState(@SW_Hide)
Else
	GUISetState(@SW_Show)
EndIf

; ############################### Shows Main window

;Hide splash
Sleep(2000)
SplashOff() 
While 1
    $msg = GUIGetMsg(1)
    If $msg[0] = $SwitchButton Then DoSwitch()
	If $msg[0] = $List Then
		if GuiCtrlRead($OptAutoSwitch) = '1' Then
		DoSwitch()
		EndIf
	EndIf

	If $msg[0] = $GUI_EVENT_MINIMIZE Then GuiSetState(@SW_HIDE,$WinMain)
    If $msg[0] = $GUI_EVENT_CLOSE And $msg[1] = $WinMain  Then DoExit() ;ExitLoop
		
	If $msg[0] = $MainOptionsButton then
		GUISwitch($WinOptions)
		GUISetState(@SW_SHOW)
	EndIf
	
	;Options
	If $msg[0] = $OptOKButton Then
		GUISetState(@SW_HIDE,$WinOptions)
	EndIf
	If $msg[0] = $OptAutoSwitch Then IniWrite($IniFile, "General", "AutoSwitch", GuiCtrlRead($OptAutoSwitch))
	if $msg[0] = $OptAutoStart Then
		IniWrite($IniFile, "General", "AutoStart", GuiCtrlRead($OptAutoStart))
		if GuiCtrlRead($OptAutoStart) = 1 Then
			RegWrite('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run','OutSwitch','REG_SZ',@ScriptDir & '\OutSwitch.exe')
		Else
			RegDelete('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run','OutSwitch')
		EndIf
	EndIf
	if $msg[0] = $OptLang Then
		IniWrite($IniFile, "General", "Language", GuiCtrlRead($OptLang))
		if GuiCtrlRead($OptLang)="English" then
			$lang =1
		elseif GuiCtrlRead($OptLang)="Nederlands"then
			$lang = 2
		EndIf
		UpdateLang()
	EndIf
	If $msg[0] = $GUI_EVENT_CLOSE And $msg[1] = $WinOptions  Then GUISetState(@SW_HIDE,$WinOptions) ;ExitLoop
	;Get Tray 

$TrayMsg = TrayGetMsg()
    Select
        Case $TrayMsg = 0
            ContinueLoop
        Case $TrayMsg = $TRAY_EVENT_PRIMARYDOWN
            GuiSetState(@SW_SHOWNORMAL,$WinMain)
	EndSelect
Wend

Func OutlookClose()
	Do
		$PID = ProcessExists("OUTLOOK.EXE")
		ProcessClose($PID)
		ProcessWaitClose($PID)
	Until $PID = 0
EndFunc

Func GetProfiles()
Do
$Cnt = $Cnt + 1
$var = RegEnumKey($MainKey, $cnt)
$Str = $Var & "|" & $Str
GUICtrlSetData($List,$Str)
Until $var = "";
EndFunc

Func GetDefaultProfile ()
$DefaultKey = regread($MainKey,"DefaultProfile")
GUICtrlSetData($List,$DefaultKey)
EndFunc

Func DoSwitch()
$PID = ProcessExists("OUTLOOK.EXE")
	If $PID > 0 Then
		$Outlookrunning = "1"
	Else
		$Outlookrunning = "0"
	EndIf
		if GuiCtrlRead($MainProfileDefault) = "1" Then
			RegWrite($MainKey,"DefaultProfile","REG_SZ",GuiCtrlRead($List))
		EndIf
		
		$a=$Outlookcommand & chr(34) & GuiCtrlRead($List) & chr(34)
		If $Outlookrunning = "1" Then
			if GuiCtrlRead($List) <> $LastProfile Then
				GUICtrlSetData($LabelStatus,$LangStat[$lang])
				GuiSetState(@SW_DISABLE,$WinMain) ; Turn the window off
				OutlookClose()
				run($a)
				$LastProfile = GuiCtrlRead($List)
				GuiSetState(@SW_ENABLE,$WinMain); Turns the window back on
				GUICtrlSetData($LabelStatus,"")
			Else
				MsgBox(64,$AppName,$LangLoaded[$lang],10)
			endif
		Else
			run($a)
			$LastProfile = GuiCtrlRead($List)
		EndIf
EndFunc

Func DoExit ()
If Not IsDeclared("iMsgBoxAnswer") Then Dim $iMsgBoxAnswer
$iMsgBoxAnswer = MsgBox(270628,$AppName,$LangQuit[$lang])
Select
   Case $iMsgBoxAnswer = 6 ;Yes
	exit
   Case $iMsgBoxAnswer = 7 ;No

EndSelect
EndFunc

Func ReadIni()
	$lang=IniRead($IniFile, "General", "Language", "English")
EndFunc

Func SetLang()
	$LangDispOpt[1]="Options"
	$LangDispOpt[2]="Opties"
	$LangDispSwitch[1]="Switch"
	$LangDispSwitch[2]="Wissel"
	$LangOptDefProf[1]="Set as default profile"
	$LangOptDefProf[2]="Maak standaard profiel"
	$LangStat[1]="Wait, switching profile..."
	$LangStat[2]="Moment, wisselen profiel..."
	$LangQuit[1]="Do you really want to quit this program?"
	$LangQuit[2]="Wilt u dit programma echt afsluiten?"
	$LangLoaded[1]="Profile already active!"
	$LangLoaded[2]="Profiel al aktief!"
	$LangLang[1]="Language:"
	$LangLang[2]="Taal:"
	
	$LangOptAutoStart[1]="Startup with windows"
	$LangOptAutoStart[2]="Opstarten met windows"
	$LangOptAutoSwitch[1]="Automatic switch"
	$LangOptAutoSwitch[2]="Automatisch wisselen"
	
	;$lang=GuiCtrlRead($OptLang)
	$lang=IniRead($IniFile, "General", "Language", "English")
	if $lang="English" then
		$lang =1
	elseif $lang="Nederlands" then
		$lang = 2
	EndIf
EndFunc

Func UpdateLang()
GUICtrlSetData ( $SwitchButton, $LangDispSwitch[$lang] )
GUICtrlSetData ( $MainOptionsButton,$LangDispOpt[$lang])
GUICtrlSetData ( $MainProfileDefault,$LangOptDefProf[$lang])
GUICtrlSetData ( $OptAutoSwitch,$LangOptAutoSwitch[$Lang])
GUICtrlSetData ( $OptAutoStart,$LangOptAutoStart[$Lang])
GUICtrlSetData ( $OptLabLang,$LangLang[$Lang])
EndFunc
