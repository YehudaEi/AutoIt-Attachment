#include <guiconstants.au3>
#include <misc.au3>
#include <file.au3>

$Window = GUICreate("Windows Startup Assistant", 375, 245, 357, 204)
$string = ""
$Name = ""
$workingdir = ""

Dim $input[8], $ChangeInput[8], $LaunchInput[8],$InputLabel[8]
$input[0] = GUICtrlCreateInput("", 88, 48, 201-80, 22, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$input[1] = GUICtrlCreateInput("", 88, 72, 201-80, 22, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$input[2] = GUICtrlCreateInput("", 88, 96, 201-80, 22, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$input[3] = GUICtrlCreateInput("", 88, 120, 201-80, 22, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$input[4] = GUICtrlCreateInput("", 88, 144, 201-80, 22, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$input[5] = GUICtrlCreateInput("", 88, 168, 201-80, 22, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$input[6] = GUICtrlCreateInput("", 88, 192, 201-80, 22, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$input[7] = GUICtrlCreateInput("", 88, 216, 201-80, 22, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$ProfileCombo = GUICtrlCreateCombo("", 80, 4, 129, 25)
$AddProfile = GUICtrlCreateButton("Create New", 216, 4, 75, 24, 0)
$DelProfile = GUICtrlCreateButton("Delete", 296, 4, 75, 24, 0)

$Label1 = GUICtrlCreateLabel("Select Profile:", 8, 8, 70, 18)
$Group1 = GUICtrlCreateGroup("AGroup1", -4, 32, 384, 215)

$ChangeInput[0] = GUICtrlCreateButton("Change", 216, 48, 75, 22, 0)
$ChangeInput[1] = GUICtrlCreateButton("Change", 216, 72, 75, 22, 0)
$ChangeInput[2] = GUICtrlCreateButton("Change", 216, 96, 75, 22, 0)
$ChangeInput[3] = GUICtrlCreateButton("Change", 216, 120, 75, 22, 0)
$ChangeInput[4] = GUICtrlCreateButton("Change", 216, 144, 75, 22, 0)
$ChangeInput[5] = GUICtrlCreateButton("Change", 216, 168, 75, 22, 0)
$ChangeInput[6] = GUICtrlCreateButton("Change", 216, 192, 75, 22, 0)
$ChangeInput[7] = GUICtrlCreateButton("Change", 216, 216, 75, 22, 0)

$LaunchInput[0] = GUICtrlCreateButton("Open", 296, 48, 75, 22, 0)
$LaunchInput[1] = GUICtrlCreateButton("Open", 296, 72, 75, 22, 0)
$LaunchInput[2] = GUICtrlCreateButton("Open", 296, 96, 75, 22, 0)
$LaunchInput[3] = GUICtrlCreateButton("Open", 296, 120, 75, 22, 0)
$LaunchInput[4] = GUICtrlCreateButton("Open", 296, 144, 75, 22, 0)
$LaunchInput[5] = GUICtrlCreateButton("Open", 296, 168, 75, 22, 0)
$LaunchInput[6] = GUICtrlCreateButton("Open", 296, 192, 75, 22, 0)
$LaunchInput[7] = GUICtrlCreateButton("Open", 296, 216, 75, 22, 0)

$InputLabel[0] = GUICtrlCreatelabel("", 4, 48, 74, 18)
$InputLabel[1] = GUICtrlCreatelabel("", 4, 72, 74, 18)
$InputLabel[2] = GUICtrlCreatelabel("", 4, 96, 74, 18)
$InputLabel[3] = GUICtrlCreatelabel("", 4, 120, 74, 18)
$InputLabel[4] = GUICtrlCreatelabel("", 4, 144, 74, 18)
$InputLabel[5] = GUICtrlCreatelabel("", 4, 168, 74, 18)
$InputLabel[6] = GUICtrlCreatelabel("", 4, 192, 74, 18)
$InputLabel[7] = GUICtrlCreatelabel("", 4, 216, 74, 18)

GUICtrlCreateGroup("", -99, -99, 1, 1)

If Not FileExists(RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\WSA", "Directory")) Then
	$path = FileOpenDialog("Select where to save configuration files", @MyDocumentsDir,"INI Data File (*.ini)",2,"WSAConfig.ini")
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\WSA", "Directory", "REG_SZ", $path)
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\WSA", "Last Profile", "REG_SZ", "DEFAULT")
	Msgbox(0,"",$path)
	INIWrite($path, "DEFAULT","Input 1","")
	INIWrite($path, "DEFAULT","Input 2","")
	INIWrite($path, "DEFAULT","Input 3","")
	INIWrite($path, "DEFAULT","Input 4","")
	INIWrite($path, "DEFAULT","Input 5","")
	INIWrite($path, "DEFAULT","Input 6","")
	INIWrite($path, "DEFAULT","Input 7","")
	INIWrite($path, "DEFAULT","Input 8","")
	Exit
Else
	$path = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\WSA", "Directory")
	$profile = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\WSA", "Last Profile")
	$var = IniReadSectionNames($path)
	For $i = 1 to $var[0]
		If $i = $var[0] Then 
			$string &= $var[$i]
		Else
			$string &= $var[$i] & "|" 
		EndIf
	Next
	$profilelist = $string
	if $profile = "" then 
		GUICtrlSetData($ProfileCombo, StringUpper($string),"DEFAULT")
	Else
		GUICtrlSetData($ProfileCombo, StringUpper($string),$profile)
EndIf
	EndIf
	$string = ""
	ResetInputData($path, $profile)

GUISetState(@SW_SHOW)

While 1
	$Msg = GUIGetMsg()
	Switch $Msg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $ProfileCombo
			$profile = GUICtrlRead($profilecombo)
			regwrite("HKEY_LOCAL_MACHINE\SOFTWARE\WSA", "Last Profile", "REG_SZ", $profile)
			ResetInputData($path,$profile)
		Case $AddProfile
			$string = Inputbox("Enter a name","Enter the name for new profile","")
			$string = StringUpper($string)
			$profilelist &= "|" & $string
			If $string <> "" Then GUICtrlSetData($profilecombo,$string,$string)
			$profile = GUICtrlRead($profilecombo)
			SaveInputData()
		Case $DelProfile
			$name = GUICtrlRead($ProfileCombo)
			If $name = "DEFAULT" or $name = "" Then
				If FileExists(@WindowsDir & "\media\Windows XP Information Bar.wav") Then
					SoundPlay(@WindowsDir & "\media\Windows XP Information Bar.wav")
				Else
					Beep(500,80)
				EndIf
			Else
				INIDelete($Path,$Name)
				GUICtrlSetData($ProfileCombo, "|")
				WriteCombo()
			EndIf
	EndSwitch
	For $i = 0 to 7
		If $msg = $ChangeInput[$i] Then ChangeInput($i)
		If $msg = $LaunchInput[$i] Then RunInput($i)
	Next
WEnd

Func ChangeInput($i)
	$File = FileOpenDialog("Select a file", @DesktopDir, "All Files (*.*)")
	GUICtrlSetData($Input[$i],$File)
	SetLabelName($i)
	FileClose($file)
EndFunc

Func WriteCombo()
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\WSA", "Last Profile", "REG_SZ", "DEFAULT")
	$path = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\WSA", "Directory")
	$profile = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\WSA", "Last Profile")
	$var = IniReadSectionNames($path)
	$string = "|"
	For $i = 1 to $var[0]
		If $i = $var[0] Then 
			$string &= $var[$i]
		Else
			$string &= $var[$i] & "|" 
		EndIf
	Next
	$profilelist = $string
	if $profile = "" then 
		GUICtrlSetData($ProfileCombo, StringUpper($string),"DEFAULT")
	Else
		GUICtrlSetData($ProfileCombo, StringUpper($string),$profile)
	EndIf
	For $i = 0 to 7
		ResetInputData($path, $profile)
	Next
EndFunc

Func RunInput($i)
	$name = GUICtrlRead($input[$i])
	$string = StringSplit($name, "\")
	$name = $i
	$Workingdir = ""
	For $i = 1 to UBound($string) -2
		$WorkingDir &= $string[$i] & "\"
	Next
	$i = $name
	$WorkingDir =StringTrimRight($Workingdir,1)
	If @error then $Workingdir = ""
	$string = msgbox(1,"Warning " & $i,"Run: " & GUICtrlRead($input[$i]) & @CRLF & "With Working Dir: " & $WorkingDir & "?")
	If $string = 1 then Run(GUICtrlRead($input[$i]), $WorkingDir)
EndFunc

Func ResetInputData($path, $profile)
	GUICtrlSetData($input[0],INIRead($path, $profile,"Input 1", ""))
	GUICtrlSetData($input[1],INIRead($path, $profile,"Input 2", ""))
	GUICtrlSetData($input[2],INIRead($path, $profile,"Input 3", ""))
	GUICtrlSetData($input[3],INIRead($path, $profile,"Input 4", ""))
	GUICtrlSetData($input[4],INIRead($path, $profile,"Input 5", ""))
	GUICtrlSetData($input[5],INIRead($path, $profile,"Input 6", ""))
	GUICtrlSetData($input[6],INIRead($path, $profile,"Input 7", ""))
	GUICtrlSetData($input[7],INIRead($path, $profile,"Input 8", ""))
	FOr $i = 0 to 7
		SetLabelName($i)
	Next
EndFunc

Func SaveInputData()
	INIWrite($path, GUICtrlRead($ProfileCombo), "Input 1", GUICtrlRead($input[0]))
	INIWrite($path, GUICtrlRead($ProfileCombo), "Input 2", GUICtrlRead($input[1]))
	INIWrite($path, GUICtrlRead($ProfileCombo), "Input 3", GUICtrlRead($input[2]))
	INIWrite($path, GUICtrlRead($ProfileCombo), "Input 4", GUICtrlRead($input[3]))
	INIWrite($path, GUICtrlRead($ProfileCombo), "Input 5", GUICtrlRead($input[4]))
	INIWrite($path, GUICtrlRead($ProfileCombo), "Input 6", GUICtrlRead($input[5]))
	INIWrite($path, GUICtrlRead($ProfileCombo), "Input 7", GUICtrlRead($input[6]))
	INIWrite($path, GUICtrlRead($ProfileCombo), "Input 8", GUICtrlRead($input[7]))
EndFunc

Func SetLabelName($i)
	$String = StringSplit(GUICtrlRead($Input[$i]), "\")
	if Not @error then 
		$Name = $String[UBound($String)-1]
		$string = StringSplit($name,".")
		If @error then
			GUICtrlSetData($InputLabel[$i],"")
		Else
			$Name = $String[1] & " (" & StringUpper($String[2]) & ")"
			GUICtrlSetData($InputLabel[$i],$Name)
		EndIf
	Else
		GUICtrlSetData($InputLabel[$i], "")
	EndIf
EndFunc