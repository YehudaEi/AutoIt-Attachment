#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=Downloads\favicon(2).ico
#AutoIt3Wrapper_Res_Icon_Add=Downloads\favicon(3).ico
#AutoIt3Wrapper_outfile=..\AppData\Roaming\WeatherTray\Weather.exe
#AutoIt3Wrapper_Res_Comment=Weather Gadget allows you to see the local forcast of any U.S. city. Uses weather.com
#AutoIt3Wrapper_Res_Description=Weather Gadget
#AutoIt3Wrapper_Res_Fileversion=3.0.0.9
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field=Author|William Reithmeyer
#AutoIt3Wrapper_Res_Field=Name|Weather Gadget
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;
#include <INet.au3>
#include <Array.au3>
#include <String.au3>
#include <GuiMenu.au3>
#include <GuiEdit.au3>
#Include <Constants.au3>
#include <GUIConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
;
Global $EditTip = "Ex: Atlanta, GA or 30342"
Global $Town, $PIC, $NewZip
Global $IniFile = @AppDataDir & "\WeatherTray\WeatherGadget.ini"
$Version 	= FileGetVersion(@ScriptFullPath)
;
Opt("TrayMenuMode", 1)
Opt("WinTitleMatchMode", 3)
Opt("GuiOnEventMode", 1)
;
#Region ### Tray ###
TraySetClick(16)
$TYOP = TrayCreateItem("Show Gadget")
$MMTT = TrayCreateItem("Minimize to Tray")
		TrayCreateItem("")
$Exit = TrayCreateItem("Exit")
#EndRegion ### Tray ###
;
If @Compiled Then
	TraySetIcon(@ScriptFullPath, -5)
	If Not FileExists(@ProgramsDir & "\Weather Gadget\Backup\Version.ini") Then
		DirCreate(@ProgramsDir & "\Weather Gadget")
		DirCreate(@ProgramsDir & "\Weather Gadget\Backup")
		IniWrite (@ProgramsDir & "\Weather Gadget\Backup\Version.ini","Version","Value", $Version)
	EndIf
	If IniRead(@ProgramsDir & "\Weather Gadget\Backup\Version.ini", "Version", "Value", "0") <> $Version Then 
		FileDelete(@ProgramsDir & "\Weather Gadget\" & @ScriptName)
		FileCopy  (@ScriptFullPath, @ProgramsDir & "\Weather Gadget\")
		IniWrite  (@ProgramsDir & "\Weather Gadget\Backup\Version.ini","Version","Value", $Version)
	EndIf
EndIf
;
$ZipCode    = "Philadelphia, PA (19019)"
$GetHome    = IniRead($IniFile, "Settings", "Home", $ZipCode)
$GetEngMet	= IniRead($IniFile, "Settings", "EngMet", "Metric")
$LastVisit	= IniRead($IniFile, "Settings", "Last Visited", "N/A")
;
$No = False
;
If $GetEngMet = "English" Then
	$Metric  = True
	$English = False
Else
	$Metric  = False
	$English = True
EndIf
;
$Timer   	= TimerInit()
;
If Not FileExists(@AppDataDir& "\WeatherTray") Then
    DirCreate(@AppDataDir& "\WeatherTray")
    For $i = 0 to 48
        InetGet("http://image.weather.com/web/common/wxicons/52/" & $i & ".gif?12122006",@AppDataDir& "\WeatherTray\Pic" & $i & ".gif")
        If @error Then
        EndIf
    Next
EndIf
;
#Region ### Options GUI ###
$Form2 		= GUICreate("", 378, 225, -1, -1, BitOR($WS_MINIMIZEBOX,$WS_CAPTION,$WS_POPUP,$WS_GROUP,$WS_BORDER,$WS_CLIPSIBLINGS), BitOR($WS_EX_RIGHT,$WS_EX_WINDOWEDGE))
			GUISetFont(8, 400, 0, "Arial")
			GUICtrlCreateGroup(" Options ", 16, 8, 345, 177, BitOR($BS_CENTER,$BS_FLAT))
			GUICtrlCreateLabel("Refesh Rate", 32, 32, 64, 18)
$MinuteIN	= GUICtrlCreateInput("", 48, 56, 32, 20, BitOR($ES_RIGHT,$ES_AUTOHSCROLL,$ES_NUMBER))
			GUICtrlSetLimit(-1, 3)
			GUICtrlCreateLabel("minute(s)", 82, 58, 49, 18)
			GUICtrlCreateLabel("Other Weather Information", 32, 84, 131, 18)
$Checkbox1 	= GUICtrlCreateCheckbox("Show 'Feels Like'", 40, 108, 97, 17)
$Checkbox2 	= GUICtrlCreateCheckbox("Show 'Visibility'", 40, 128, 97, 17)
			GUICtrlCreateLabel("Home Location", 184, 32, 75, 18)
$HomeIN 	= GUICtrlCreateLabel("", 192, 56, 161, 20)
			GUICtrlSetColor(-1, 0x3689E8)
$UseCurrent = GUICtrlCreateButton("Use Current Location", 240, 78, 115, 18, 0)
			GUICtrlSetOnEvent(-1, "_Use_Current")
			GUICtrlCreateLabel("Current Location", 184, 104, 84, 18)
$Current	= GUICtrlCreateLabel("", 192, 128, 161, 20)
			GUICtrlSetColor(-1, 0xFF0000)
			GUICtrlCreateGroup("", -99, -99, 1, 1)
$OptOk	 	= GUICtrlCreateButton("Ok", 288, 192, 75, 25, 0)
			GUICtrlSetOnEvent(-1, "_Opt_OK")
$OptCan 	= GUICtrlCreateButton("Cancel", 208, 192, 75, 25, 0)
			GUICtrlSetOnEvent(-1, "_Opt_Can")
			GUICtrlCreateLabel($Version, 8, 211, 64, 14)
			GUICtrlSetColor(-1, 0x808080)
			GUISetState(@SW_HIDE)
#EndRegion ### Options GUI ###
;
#Region ### About GUI ###
Local $RanPic[7][5]
Local $Random[15]
$FileTime 	= FileGetTime(@ScriptFullPath)
$Random		= StringSplit(_Generate(15, 3, 47), "|")
$Form3 		= GUICreate("About", 260, 158, 429, 222, BitOR($WS_CAPTION,$WS_POPUP,$WS_BORDER,$WS_CLIPSIBLINGS))
			GUISetFont(9, 400, 0, "Arial")
			GUISetBkColor(0xFFFFFF)
			$u = 0
			For $xx = 0 to 4
				For $yy = 0 to 2
					$u += 1
					$RanPic[$xx][$yy] = GUICtrlCreatePic(@AppDataDir & "\WeatherTray\Pic" & $Random[$u] & ".gif", 52 * $xx, 52 * $yy, 52, 52)
					GuiCtrlSetState(-1,$GUI_DISABLE)
				Next
			Next
			GUICtrlCreateLabel("Weather Gadget", 8, 16, 200)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetFont(-1, 16, 800, 0, "Arial")
			GUICtrlSetColor(-1, 0x0000FF)
			GUICtrlSetState(-1, $GUI_SHOW)
			GUICtrlCreateLabel("Version: " & $Version, 24, 52)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlCreateLabel($FileTime[1] & "/" & $FileTime[2] & "/" & $FileTime[0] & " " & _MilitaryTo12Hour($FileTime[3], $FileTime[4]&":"&$FileTime[5]), 24, 72)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlCreateLabel("By: William Reithmeyer", 24, 90)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$AboutOk 	= GUICtrlCreateButton("Ok", 24, 120, 75, 25, 0)
			GUICtrlSetState(-1, $GUI_ENABLE + $GUI_FOCUS + $GUI_ONTOP)
			GUICtrlSetOnEvent(-1, "_Event_Get")
			GUICtrlCreateLabel("www.weather.com", 150, 140) 
			GUICtrlSetCursor  (-1, 0)
            GUICtrlSetFont    (-1, 8.5, 400, 4)
			GUICtrlSetOnEvent (-1, "_site")
			GUICtrlSetBkColor (-1, $GUI_BKCOLOR_TRANSPARENT)
GUISetState(@SW_HIDE)
#EndRegion ### About GUI ###
;
#Region ### Main GUI ###
$Form1   	= GUICreate("Weather Gadget", 200, 212)
            GUISetBkColor(0xFFFFFF)
			GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents")
			GUISetOnEvent($GUI_EVENT_MINIMIZE, "SpecialEvents")
			GUISetOnEvent($GUI_EVENT_RESTORE, "SpecialEvents")

			
$Menu 	 	= GUICtrlCreateMenu("&Options")
$MenuMin 	= GUICtrlCreateMenuItem("&Minimize to Tray", $Menu)
			GUICtrlSetOnEvent(-1, "_Event_Get")
$MenuOpt 	= GUICtrlCreateMenuItem("&Settings", $Menu)
			GUICtrlSetOnEvent(-1, "_Option")
			GUICtrlCreateMenuItem("", $Menu)	
$MenuExit 	= GUICtrlCreateMenuItem("&Exit", $Menu)		
			GUICtrlSetOnEvent(-1, "_Exit")

$History	= GUICtrlCreateMenu("H&istory")
$LastHist	= GUICtrlCreateMenuItem($LastVisit, $History)	
			GUICtrlSetOnEvent(-1, "_Event_Get")
			
$Help		= GUICtrlCreateMenu("&Help")
$About		= GUICtrlCreateMenuItem("&About", $Help)	
			GUICtrlSetOnEvent(-1, "_About")
			
$hMain 					= _GUICtrlMenu_GetMenu ($Form1)
$hBrush 				= _WinAPI_GetSysColorBrush ($COLOR_INFOBK)
For $o = 0 To 3 
	Local $hFile[4]	
	$hFile[$o]			= _GUICtrlMenu_GetItemSubMenu ($hMain, $o)
						  _GUICtrlMenu_SetMenuStyle ($hFile[$o], $MNS_NOCHECK)
						  _GUICtrlMenu_SetMenuBackground ($hFile[$o], $hBrush)
Next

$Label1     = GUICtrlCreateLabel("Right Now for", 16, 8, 200, 14)
            GUICtrlSetFont(-1, 8.5, 600)
$Label2     = GUICtrlCreateLabel($GetHome, 16, 22)
            GUICtrlSetCursor(-1, 0)
            GUICtrlSetFont(-1, 8.5, 400, 4)
			GUICtrlSetOnEvent(-1, "_Link")
$Label3     = GUICtrlCreateLabel("", 88, 45, 70, 31) ;Temperature
            GUICtrlSetFont(-1, 18, 400, 0, "Georgia")
			GUICtrlSetColor(-1, 0x565963)
$Label4     = GUICtrlCreateLabel("", 88, 80, 100, 28) ; Condition
            GUICtrlSetFont(-1, 8.5, 400, 0, "Georgia")
$Status     = GUICtrlCreateLabel("", 16, 110, 140, 32)
            GUICtrlSetFont(-1, 8)
$Edit1   	= GUICtrlCreateEdit($ZipCode, 12, 144, 150, 21, 0)
            GUICtrlSetFont(-1, 8)
            GUICtrlSetColor(-1, 0x808080)
	
$Button1    = GUICtrlCreateButton("Go", 164, 144, 26, 21, $BS_FLAT)
            DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
			GUICtrlSetOnEvent(-1, "_Event_Get")
$Home      = GUICtrlCreateButton("Home", 12, 166, 35, 20, $BS_FLAT)
            DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
			GUICtrlSetOnEvent(-1, "_Event_Get")
$SetHome    = GUICtrlCreateButton("Set Home", 48, 166, 60, 20, $BS_FLAT)
            DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
			GUICtrlSetOnEvent(-1, "_Event_Get")
$EngMet		= GUICtrlCreateLabel($GetEngMet, 160, 176, 100, 14)
            GUICtrlSetCursor(-1, 0)
            GUICtrlSetFont(-1, 8.5, 400, 4)
			GUICtrlSetColor(-1, 0x0000EE)
			GUICtrlSetOnEvent(-1, "_Eng_Met")
_GetWeatherInfo($GetHome)
_Home(2)
_VistaWinAnimate($Form1, 2, 0, 100, 0)
If @Compiled Then
	TraySetIcon(@ScriptFullPath, 0)
EndIf
GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
#EndRegion ### Main GUI ###
;
While 1
	$TMsg = TrayGetMsg()
	Switch $TMsg
		Case $TRAY_EVENT_PRIMARYDOUBLE, $TYOP
			_VistaWinAnimate($Form1, 5, 0, 100, 0)
		Case $MMTT
			_VistaWinAnimate($Form1, 5, 1, 100, 0)		
		Case $Exit
			_Exit()
	EndSwitch
    If TimerDiff($Timer) > (_RefreshRate() * 60000) Then
        If TimerDiff($Timer) < (_RefreshRate() * 60000) + 500 Then
			If Not $No Then
				_GetWeatherInfo(StringTrimRight(GUICtrlRead($Label2),8))
				Sleep(500)
			Else
				$Timer = TimerInit()
			EndIf
        EndIf
    EndIf
    If WinActive("Weather Gadget") Then
        HotKeySet("{Enter}", "_SendInfo")
    Else
        HotKeySet("{Enter}")
    EndIf
WEnd
;
Func _Link()
	ShellExecute("http://www.weather.com/weather/local/" & $NewZip)
EndFunc
;
Func _site()
	ShellExecute("http://www.weather.com")
EndFunc
;
Func _Generate($size=7, $min=1, $max=36)
    Local $array[$size]
    $array[0]=Random($min,$max,1)
    For $i=0 To $size-1
        While True
            $tempf=Random($min,$max,1)
            For $j=0 To $i-1
                If $array[$j]=$tempf Then ContinueLoop 2
            Next
            ExitLoop
        WEnd
        $array[$i]=$tempf
    Next	
    Return _ArrayToString($array, "|")
EndFunc
;
Func _About()
	$No = True
	GUISetState(@SW_DISABLE, $Form1)
	_VistaWinAnimate($Form3, 2, 0, 100, 0)
EndFunc
;
Func _RefreshRate()
	Return IniRead($IniFile, "Option", "Refresh Rate", "2")
EndFunc
;
Func _Eng_Met()
	Switch GUICtrlRead($EngMet)
		Case "Metric"
			$Metric  = True
			$English = False
			GUICtrlSetData($EngMet, "English")
			IniWrite($IniFile, "Settings", "EngMet", "English")
		Case "English"
			$Metric  = False
			$English = True
			GUICtrlSetData($EngMet, "Metric")
			IniWrite($IniFile, "Settings", "EngMet", "Metric")
	EndSwitch
	_GetWeatherInfo(StringTrimRight(GUICtrlRead($Label2),8),1)
EndFunc
;
Func _Home($num = 1)
		$GetHome = IniRead($IniFile, "Settings", "Home", "")
    Switch $num
        Case 1
            If $GetHome = "" Then
                Return ""
            Else
                Return StringTrimRight($GetHome,8)
            EndIf
        Case 2
            IniWrite($IniFile, "Settings", "Home", GUICtrlRead($Label2))
            GUICtrlSetState($SetHome, $GUI_HIDE)
            GUICtrlSetData($Home, "Set")
            GUICtrlSetTip($Home, GUICtrlRead($Label2))
            Sleep(500)
            GUICtrlSetData($Home, "Home")
        Case 3
            IniWrite($IniFile, "Settings", "Home", GUICtrlRead($HomeIN))
            GUICtrlSetTip($Home, GUICtrlRead($HomeIN))
            Sleep(500)
			If $GetHome = GUICtrlRead($HomeIN) Then
				GUICtrlSetState($SetHome, $GUI_HIDE)
			Else
				GUICtrlSetState($SetHome, $GUI_SHOW)
			EndIf	
        EndSwitch
EndFunc
;
Func _SendInfo()
    _GetWeatherInfo(GUICtrlRead($Edit1))
EndFunc
;
Func _Event_Get()
	Select
		Case GUICtrlRead(@GUI_CtrlId) = "Home"
			_GetWeatherInfo(_Home())
		Case GUICtrlRead(@GUI_CtrlId) = "Set Home"
			_Home(2)
		Case GUICtrlRead(@GUI_CtrlId) = "Ok"
			GUISetState(@SW_ENABLE, $Form1)
			_VistaWinAnimate($Form3, 2, 1, 100, 0)	
			$No = False
			_VistaWinAnimate($Form1)
			GUISetState(@SW_RESTORE, $Form1)		
		Case GUICtrlRead(@GUI_CtrlId) = "Go"
            GUICtrlSetData($Button1, "...")
            _SendInfo()
            GUICtrlSetData($Button1, "Go")
		Case GUICtrlRead(@GUI_CtrlId, 1) = "&Minimize to Tray"
			_VistaWinAnimate($Form1, 5, 1, 100, 0)
		Case Else
			_GetWeatherInfo(StringTrimRight(GUICtrlRead(@GUI_CtrlId, 1),8))
	EndSelect
EndFunc
;
Func _GetWeatherInfo($info = $EditTip, $opt = 0)
	
$ShowFeel    = IniRead($IniFile, "Option", "Feel", "1")
$ShowVisa    = IniRead($IniFile, "Option", "Visability", "1")
	Switch $opt
		Case 0
			If $info = $EditTip or $info = "" Then
				Return _SetError(0, "")
			EndIf
			If StringIsInt($info) Then
				$NewZip = $info
			Else   
				$CityState = StringRegExpReplace($info, "(?-i)[()1234567890]", "")
				$CityStateA = StringSplit($CityState,",")
				If @error Then
					Return _SetError(1, $info)
				Else
					$CityStateA[1] = StringReplace($CityStateA[1]," ","+")
					$CityStateA[2] = StringReplace($CityStateA[2]," ","")
					$GetZIP = _INetGetSource("http://zipcodes.addresses.com/results.php?ReportType=42&qc=" & $CityStateA[1] & "&qs=" & $CityStateA[2])
					$GetZip2 = _StringBetween($GetZIP, '<td class="F1">', '</td>')
					If @error Then
						Return _SetError(2, $info)
					Else
						$NewZip = $GetZip2[0]
					EndIf
				EndIf
			EndIf
			If @Compiled Then
				TraySetIcon(@ScriptFullPath, -5)
			EndIf
			$source = "http://www.weather.com/weather/local/" & $NewZip
			$File = _INetGetSource($source)
			$Town = _StringBetween($File, "<B>Right Now for</B><BR>", " (")
			$GetWVH = _StringBetween($File, '<TD VALIGN="top"  CLASS="obsTextA">', '</td>')
			If @error Then
				Return _SetError(3, $info)
			Else
				$TempArray = _StringBetween($File, "temp=", "&")
				$CondArray = _StringBetween($File, "<B CLASS=obsTextA>", "</B>")
				$PictArray = _StringBetween($File, '<IMG SRC="http://image.weather.com/web/common/wxicons/52/', '.gif?12122006" WIDTH=52 HEIGHT=52 BORDER=0 ALT=>')
				$Picw = $PictArray[0]
				If $TempArray <> 0 Then
					$Cond = $CondArray[0]
					$Feel = $CondArray[1]
					$Feel = StringRegExpReplace($Feel, "(?-i)[FelsLik<BR>&deg; ]", "")
					If $English	Then
						$Temp = $TempArray[0] & "°F"
						$Feel = "Feels Like " & $Feel & "°F"
						$vis  = $GetWVH[9]
					Else
						$Temp = Round(_English_Metric($TempArray[0]),0) & "°C"
						$Feel = "Feels Like " & Round(_English_Metric($Feel),0) & "°C"
						$vis  = Round(_English_Metric(StringRegExpReplace($GetWVH[9], "(?-i)[ miles]", ""), 1),1) & " kilometers"
					EndIf
					$GetWVH[1] = StringReplace($GetWVH[1], "<BR>", " ")
				EndIf
				$Town = $Town[0] & " (" & $NewZip & ")"
				
				If $Town <> GUICtrlRead($Label2) Then
					GUICtrlSetData($LastHist, GUICtrlRead($Label2))
				EndIf
				GUICtrlDelete($Label2)
				$Label2 = GUICtrlCreateLabel($Town, 16, 22)
				GUICtrlSetCursor(-1, 0)
				GUICtrlSetFont(-1, 8.5, 400, 4)
				GUICtrlSetOnEvent(-1, "_Link")
				GUICtrlSetData($Label3, $Temp)
				GUICtrlSetData($Label4, $Cond)
				If $ShowFeel = 1 And $ShowVisa = 1 Then
					GUICtrlSetData($Status,  $Feel & @CRLF & "Visibility: " & $vis)
				ElseIf $ShowFeel = 0 And $ShowVisa = 0 Then
					GUICtrlSetData($Status,  "")
				EndIf
				If $ShowFeel = 1 And $ShowVisa = 0 Then
					GUICtrlSetData($Status,  $Feel)
				ElseIf $ShowFeel = 0 And $ShowVisa = 1 Then
					GUICtrlSetData($Status,  "Visibility: " & $vis)
				EndIf									
				GUICtrlSetTip($Label2, "http://www.weather.com/weather/local/" & $NewZip)
				GUICtrlDelete($PIC)
				$PIC = GUICtrlCreatePic(@AppDataDir & "\WeatherTray\Pic" & $Picw & ".gif", 16, 48, 52, 52)
				GUICtrlSetState(-1, $GUI_SHOW)
				TraySetToolTip($Town & @CRLF & "Current Temp: " & $Temp & @CRLF & $Feel)
				GUICtrlSetData($Edit1, $EditTip)
				GUICtrlSetColor($Edit1, 0x808080)
				GUICtrlSetState($Label2, $GUI_FOCUS)
				$Timer = TimerInit()
				$Hour = @HOUR
				$Min = @MIN
				GUICtrlSetData($Label1, "Right Now for")
			EndIf
			If $GetHome = GUICtrlRead($Label2) Then
				GUICtrlSetState($SetHome, $GUI_HIDE)
			Else
				GUICtrlSetState($SetHome, $GUI_SHOW)
			EndIf
		Case 1
			$source = "http://www.weather.com/weather/local/" & $NewZip
			$File = _INetGetSource($source)
			$GetWVH = _StringBetween($File, '<TD VALIGN="top"  CLASS="obsTextA">', '</td>')
			$TempArray = _StringBetween($File, "temp=", "&")
			$CondArray = _StringBetween($File, "<B CLASS=obsTextA>", "</B>")
			If $TempArray <> 0 Then
				$Feel = $CondArray[1]
				$Feel = StringRegExpReplace($Feel, "(?-i)[FelsLik<BR>&deg; ]", "")
				If $English	Then
					$Temp = $TempArray[0] & "°F"
					$Feel = "Feels Like " & $Feel & "°F"
					$vis  = $GetWVH[9]
				Else
					$Temp = Round(_English_Metric($TempArray[0]),0) & "°C"
					$Feel = "Feels Like " & Round(_English_Metric($Feel),0) & "°C"
					$vis  = Round(_English_Metric(StringRegExpReplace($GetWVH[9], "(?-i)[ miles]", ""), 1),1) & " kilometers"
				EndIf
			EndIf
			GUICtrlSetData($Label3, $Temp)
			If $ShowFeel = 1 And $ShowVisa = 1 Then
				GUICtrlSetData($Status,  $Feel & @CRLF & "Visibility: " & $vis)
			ElseIf $ShowFeel = 0 And $ShowVisa = 0 Then
				GUICtrlSetData($Status,  "")
			EndIf
			If $ShowFeel = 1 And $ShowVisa = 0 Then
				GUICtrlSetData($Status,  $Feel)
			ElseIf $ShowFeel = 0 And $ShowVisa = 1 Then
				GUICtrlSetData($Status,  "Visibility: " & $vis)
			EndIf
		EndSwitch
        WinSetTrans($Form1, "", 255)
		If @Compiled Then
			TraySetIcon(@ScriptFullPath, 0)
		EndIf
EndFunc
;
Func _English_Metric($Value, $opt = 0)
	Switch $opt
		Case 0; To celcius
			$newValue = ((5 / 9) * ($Value - 32))
		Case 1; To kilometers
			$newValue = $Value * 1.61
	EndSwitch
	Return $newValue
EndFunc
;
Func _SetError($error, $data)
    Switch $error
        Case 0
            Return 0
        Case 1
            $ErrTitle = "Error: Comma"
            $ErrMsg = "'" & $data & "'" & " was not found." & @CRLF & _
                      "Please put city and state, with a comma between them."
        Case 2
            $ErrTitle = "Error: Spelling"
            $ErrMsg = "'" & $data & "'" & " was not found." & @CRLF & _
                      "Unable to find either city, state, or zip." & @CRLF & _
					  "Please check your spelling of both city and state."
        Case 3
            $ErrTitle = "Error: Zip Code"
            $ErrMsg = "'" & $data & "'" & " was not found." & @CRLF & _
                      "No matches found. Try another zip. U.S. zips" & @CRLF & _
					  " are 5 digits long. Try typing 'city, state'" & @CRLF & _
					  "if you can not find zip."
    EndSwitch
   
    Return MsgBox(0,$ErrTitle, $ErrMsg & @CRLF & @CRLF & $EditTip)
EndFunc
;
Func SpecialEvents()
    Select
        Case @GUI_CtrlId = $GUI_EVENT_CLOSE
            _Exit()
        Case @GUI_CtrlId = $GUI_EVENT_MINIMIZE
			GUISetState(@SW_MINIMIZE, $Form1)
        Case @GUI_CtrlId = $GUI_EVENT_RESTORE
			GUISetState(@SW_RESTORE, $Form1)
    EndSelect
EndFunc 
;
Func _Option()
	GUISetState(@SW_DISABLE, $Form1)
	
	$No = True
	$ShowFeel    = IniRead($IniFile, "Option", "Feel", "1")
	$ShowVisa    = IniRead($IniFile, "Option", "Visability", "1")
	$GetHome     = IniRead($IniFile, "Settings", "Home", $ZipCode)

	If $ShowFeel = 1 Then
		GUICtrlSetState($Checkbox1, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox1, $GUI_UNCHECKED)
	EndIf
	If $ShowVisa = 1 Then
		GUICtrlSetState($Checkbox2, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox2, $GUI_UNCHECKED)
	EndIf
	
		GUICtrlSetData($MinuteIN, _RefreshRate())
		GUICtrlSetData($HomeIN, $GetHome)
		GUICtrlSetData($Current, GUICtrlRead($Label2))
		If GUICtrlRead($Label2) = $GetHome Then
			GUICtrlSetState($UseCurrent, $GUI_DISABLE)
		Else
			GUICtrlSetState($UseCurrent, $GUI_ENABLE)
		EndIf			
		
		_VistaWinAnimate($Form2, 2, 0, 100, 0)				
EndFunc
;
Func _Use_Current()
	GUICtrlSetData($HomeIN, GUICtrlRead($Current))
EndFunc
;
Func _Opt_OK()
	If GUICtrlRead($Checkbox1) = $GUI_CHECKED Then
		$ShowFeel = 1
	Else
		$ShowFeel = 0
	EndIf
	If GUICtrlRead($Checkbox2) = $GUI_CHECKED Then
		$ShowVisa = 1
	Else
		$ShowVisa = 0
	EndIf
	If GUICtrlRead($MinuteIN) = "" Then
		IniWrite($IniFile, "Option", "Refresh Rate", _RefreshRate())
	Else
		IniWrite($IniFile, "Option", "Refresh Rate", GUICtrlRead($MinuteIN))
	EndIf
	IniWrite($IniFile, "Option", "Feel", $ShowFeel)
	IniWrite($IniFile, "Option", "Visability", $ShowVisa)
	IniWrite($IniFile, "Settings", "Home", GUICtrlRead($HomeIN))
	
	_Home(3)
	_GetWeatherInfo(StringTrimRight(GUICtrlRead($Label2),8),1)
	_Opt_Can()
EndFunc
;
Func _Opt_Can()
	GUISetState(@SW_ENABLE, $Form1)
	_VistaWinAnimate($Form2, 5, 1, 100, 0)
	$No = False
	_VistaWinAnimate($Form1)
	GUISetState(@SW_RESTORE, $Form1)
EndFunc
;
Func _Exit()
	IniWrite($IniFile, "Settings", "Last Visited", GUICtrlRead($LastHist, 1))
	$XPos = WinGetPos($Form1)
	$Delay = 0
	If $XPos[0] <= (@DesktopWidth/4) Then 
		$VState = 2
	ElseIf $XPos[0] > (@DesktopWidth - @DesktopWidth/4) Then 
		$VState = 3
	ElseIf $XPos[1] <= (@DesktopHeight/3) Then 
		$VState = 4
	ElseIf $XPos[1] > (@DesktopHeight - @DesktopHeight/3) Then 
		$VState = 5
	Else
		$VState = 1
		$Delay  = 2
	EndIf
    _VistaWinAnimate($Form1, $VState, 1, 100, $Delay)
	Exit
EndFunc
;
Func _VistaWinAnimate($Xwnd, $Xstyle = 0, $Xstate = 0, $Xdistance = 100, $Xdelay = 10)
    ; $Xstate  - 0 = Show, 1 = Hide,
    ; $Xstyle  - 1=Fade, 2=L-Slide, 3=R-Slide, 4=T-Slide, 5=B-Slide, 6=TL-Diag-Slide, 7=BL-Diag-Slide, 8=TR-Diag-Slide, 9=BR-Diag-Slide

    ; Error checking...
    If Not WinExists($Xwnd) Then Return SetError(1, -1, "window does not exist")
    If Not $Xstate == 0 Or Not $Xstate == 1 Then Return SetError(2, -1, "State is not Show or Hide")
    If $Xstyle == 0 Or $Xstyle >= 10 Then Return SetError(3, -1, "Style is out-of-range")

    ; Find Window location and Centered...
    Local $XPos = WinGetPos($Xwnd), $X_Move = 0, $Y_Move = 0, $MoveIt = 0
    $X_Start = $XPos[0]
    $Y_Start = $XPos[1]
    $X_Final = 8
    $Y_Final = (@DesktopHeight / 2) - ($XPos[3] / 2)

    If $Xstate == 0 Then ; to Show the GUI
        WinSetTrans($Xwnd, "", 0)
        GUISetState(@SW_SHOW, $Xwnd)
        $Xtrans = 255 / $Xdistance
        If $Xstyle = 2 Or $Xstyle = 6 Or $Xstyle = 7 Then
            $X_Move = 1
            $X_Final = $X_Final - $Xdistance
        ElseIf $Xstyle = 3 Or $Xstyle = 8 Or $Xstyle = 9 Then
            $X_Move = -1
            $X_Final = $X_Final + $Xdistance
        EndIf
        If $Xstyle = 4 Or $Xstyle = 6 Or $Xstyle = 8 Then
            $Y_Move = 2
            $Y_Final = $Y_Final - ($Xdistance * 2)
        ElseIf $Xstyle = 5 Or $Xstyle = 7 Or $Xstyle = 9 Then
            $Y_Move = -2
            $Y_Final = $Y_Final + ($Xdistance * 2)
        EndIf
    Else ; to hide the GUI
        $Xtrans = -1 * (255 / $Xdistance)
        $X_Final = $X_Start
        $Y_Final = $Y_Start
        If $Xstyle = 2 Or $Xstyle = 6 Or $Xstyle = 7 Then $X_Move = -1
        If $Xstyle = 3 Or $Xstyle = 8 Or $Xstyle = 9 Then $X_Move = 1
        If $Xstyle = 4 Or $Xstyle = 6 Or $Xstyle = 8 Then $Y_Move = -2
        If $Xstyle = 5 Or $Xstyle = 7 Or $Xstyle = 9 Then $Y_Move = 2
    EndIf
    If $Y_Move <> 0 Or $X_Move <> 0 Then $MoveIt = 1
    WinMove($Xwnd, "", $X_Final, $Y_Final)
    For $x = 1 To $Xdistance
        $XPos = WinGetPos($Xwnd)
        WinSetTrans($Xwnd, "", $x * $Xtrans)
        If $MoveIt = 1 Then WinMove($Xwnd, "", $XPos[0] + $X_Move, $XPos[1] + $Y_Move)
        Sleep($Xdelay)
    Next
    If $Xstate = 1 Then GUISetState(@SW_HIDE, $Xwnd)
EndFunc
;
Func _MilitaryTo12Hour($hHour, $mMin, $AMPM = 0)
Local $apM = " AM"
	Switch $hHour
		Case 00
			$nHour = 12
		Case 1 to 12
			$nHour = $hHour
		Case 13 To 24
			$nHour = $hHour - 12
			$apM = " PM"
	EndSwitch
	If $AMPM = 1 Then $apM = ""
	Return $nHour & ":" & $mMin & $apM
EndFunc
;
Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
    Local $hWndFrom, $iIDFrom, $iCode
    $hWndEdit1 = GUICtrlGetHandle($Edit1)
    $hWndFrom = $ilParam
    $iIDFrom = _WinAPI_LoWord($iwParam)
    $iCode = _WinAPI_HiWord($iwParam)
    Switch $hWndFrom
        Case $hWndEdit1
            Switch $iCode
                Case $EN_KILLFOCUS
                    If _GUICtrlEdit_GetTextLen($Edit1) = 0 Then
                        GUICtrlSetData($Edit1, $EditTip)
                        GUICtrlSetColor($Edit1, 0x808080)
                    EndIf
                Case $EN_SETFOCUS
                    If GUICtrlRead($Edit1) = $EditTip Then
                        GUICtrlSetData($Edit1, "")
                        GUICtrlSetColor($Edit1, 0x000000)
                    EndIf
                Case $EN_CHANGE
            EndSwitch
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc