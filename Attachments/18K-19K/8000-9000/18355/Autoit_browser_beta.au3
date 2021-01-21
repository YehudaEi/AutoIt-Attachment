#include <GUIConstants.au3>
#include <Constants.au3>
#include <IE.au3>
#include <Array.au3>
#include <File.au3>
#include <String.au3>
#NoTrayIcon
#RequireAdmin
$oIE = _IECreateEmbedded()
$Form1 = GUICreate("Bux.to Autobrowser", 728, 429,(@DesktopWidth-640)/2, (@DesktopHeight-580)/2, BitOr($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS, $WS_CLIPCHILDREN))
$File = GUICtrlCreateMenu("&File")
$Exit = GUICtrlCreateMenu("&Exit")
$MenuItem8 = GUICtrlCreateMenuItem("Exit", $File)
$GUIActiveX = GUICtrlCreateObj($oIE, 10, 40, 700, 350)
GUISetState(@SW_HIDE)
$Settings = GUICreate("Settings", 204, 269, 193, 125)

$Scheduletime = GUICtrlCreateGroup("Schedule Time", 8, 8, 185, 105)
$Time1 = GUICtrlCreateInput("", 48, 48, 89, 21, $ES_NUMBER)
$Label1 = GUICtrlCreateLabel("Run Every:", 48, 24, 57, 17)
$Label2 = GUICtrlCreateLabel("mins", 128, 72, 25, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Login", 8, 128, 185, 137)
$Userinput = GUICtrlCreateInput("", 40, 160, 121, 21)
$Passinput = GUICtrlCreateInput("", 40, 208, 121, 21,$ES_PASSWORD)
GUICtrlCreateLabel("Username", 72, 136, 52, 17)
GUICtrlCreateLabel("Password", 72, 184, 50, 17)
$set2 = GUICtrlCreateButton("Set", 56, 240, 75, 17, 0)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_HIDE)

Opt("TrayMenuMode",1)
$Runitem   = TrayCreateItem("Run")
$settingsitem = TrayCreateItem("Settings")
$viewitem = TrayCreateItem("View")
$helpitem   = TrayCreateItem("Help")
$exititem   = TrayCreateItem("Exit (ESC)")
TraySetState()

; Random
Local $fileLineArray
Opt("TrayMenuMode",1)
HotKeySet("{ESC}", "close")
		$stamp = TimerInit()

$min=False

; Deletes to avoid errors
FileDelete("output.txt")
FileDelete("links.txt")

If FileExists(@scriptdir & "\settings.ini") = 0 Then
	MsgBox(0,"Bux.to Autobrowser", "Please fill in the settings")
	GUISetState(@SW_SHOW,$Settings)
Else
	$User = IniRead(@ScriptDir & "\settings.ini","Login Details","User","")
	$Pass = IniRead(@ScriptDir & "\settings.ini","Login Details","Pass","")
	_decrypt()
EndIf
 
While 1
	$gMsg=GUIGetMsg()
    Switch $gMsg
    Case $GUI_EVENT_CLOSE
		GUISetState(@SW_HIDE)
	Case $MenuItem8
		GUISetState(@SW_HIDE, $Form1)
	Case $Exit
		GUISetState(@SW_HIDE)
	Case $set2
		If GUICtrlRead($Time1) = "" Then
			MsgBox(0,"Bux.to Auto Browser","Please fill in missing details")
			GUISetState(@SW_SHOW,$Settings)
		ElseIf GUICtrlRead($Userinput) = "" Then
			MsgBox(0,"Bux.to Auto Browser","Please fill in missing details")
			GUISetState(@SW_SHOW,$Settings)
		ElseIf GUICtrlRead($Passinput) = "" Then
			MsgBox(0,"Bux.to Auto Browser","Please fill in missing details")
			GUISetState(@SW_SHOW,$Settings)
		EndIf
		$input = GUICtrlRead($Time1)
		IniWrite(@ScriptDir & "\settings.ini","Time","Runevery",$input)
		GUISetState(@SW_HIDE,$Settings)
		$User = GUICtrlRead($Userinput)
		$Pass = GUICtrlRead($Passinput)
		$Pass = _StringEncrypt(1,$Pass,"lol")
		IniWrite(@ScriptDir & "\settings.ini","Login Details","User",$User)
		IniWrite(@ScriptDir & "\settings.ini","Login Details","Pass",$Pass)
		_decrypt()
		GUISetState(@SW_HIDE,$Settings)
	EndSwitch
    $tMsg=TrayGetMsg()
    Switch $tMsg
    Case $settingsitem
		$Time11 = IniRead(@scriptdir & "\settings.ini","Time","Runevery","")
		$User2 = IniRead(@ScriptDir & "\settings.ini","Login Details","User","")
		GUICtrlSetData($Userinput,$User2)
		GUICtrlSetData($Time1,$Time11)
        GUISetState(@SW_SHOW,$Settings)
	Case $Runitem
        GUISetState(@SW_SHOW,$Form1)
		Do
			_login()
		Until _IEPropertyGet($oIE, "locationurl") = "                       "
    Case $exititem
        close()
	Case $helpitem
		help()
	Case $viewitem
		GUISetState(@SW_SHOW,$Form1)
    EndSwitch
	If FileExists(@scriptdir & "\settings.ini") = 1 And ((TimerDiff($stamp) / 1000) / 60) >= IniRead(@scriptdir & "\settings.ini","Time","Runevery","") Then
		Get()
		Browse()
		$stamp = TimerInit()
	EndIf	
WEnd


; Get Function
Func Get()
	If @OSVersion = "WIN_NT4" or @OSVersion = "WIN_ME" or @OSVersion = "WIN_98" or @OSVersion = "WIN_95" then
                TraySetToolTip ("Bux.to Browser - Collecting ads")
            Else
                Traytip ("Bux.to Browser", "Collecting ads", 5)
            EndIf
			_IENavigate($oIE, "                          ")
Sleep(2000)
$oLinks = _IELinkGetCollection ($oIE)
$iNumLinks = @extended
Global $Link_Array[$iNumLinks]
For $oLink In $oLinks
    If StringInStr($oLink.href,'view.php?ad=') Then
        _ArrayAdd($Link_Array,$oLink.href)
    EndIf
   
Next
_FileWriteFromArray("links.txt",$Link_Array,1)


$fil = "links.txt"
$fil = FileRead($fil)
$fil = StringSplit($fil, @CRLF)

For $i = $fil[0] To 1 Step - 1
    $tempstr = StringStripWS($fil[$i], 3)
    If $tempstr = "" Then
        _ArrayDelete($fil, $i)
    Else
        If $i = 1 Then ExitLoop
        For $n = $i - 1 To 1 Step - 1
            If $tempstr = $fil[$n] Then
                _ArrayDelete($fil, $i)
                ExitLoop
            EndIf
        Next
    EndIf
Next
$fil[0] = UBound($fil) - 1

If $fil[0] > 0 Then
    _FileWriteFromArray("output.txt", $fil, 1)
	ads()
Else
    Traytip ("Bux.to Browser", "No Links Found", 5)
EndIf
sleep(8000)

FileDelete("links.txt")
EndFunc

; Browse Function
Func Browse()
	If @OSVersion = "WIN_NT4" or @OSVersion = "WIN_ME" or @OSVersion = "WIN_98" or @OSVersion = "WIN_95" then
		TraySetToolTip ("Bux.to Browser - Browsing ads")
	Else
		Traytip ("Bux.to Browser", "Browsing ads", 5)
	EndIf	
For $i = 1 To _FileCountLines("output.txt")
_IENavigate($oIE, FileReadLine("output.txt", $i))
_IELoadWait($oIE)
sleep(35000)
Next
If @OSVersion = "WIN_NT4" or @OSVersion = "WIN_ME" or @OSVersion = "WIN_98" or @OSVersion = "WIN_95" then
		TraySetToolTip ("Bux.to Browser - Finished Browsing ads")
	Else
		Traytip ("Bux.to Browser", "Finished Browsing ads", 5)
	EndIf
FileDelete("output.txt")	
EndFunc

; display ads
Func ads()
Dim $aRecords
If Not _FileReadToArray("output.txt",$aRecords) Then
   MsgBox(4096,"Error", " Error reading log to Array     error:" & @error)
   Exit
EndIf
For $x = 1 to $aRecords[0]
    _FileWriteLog(@ScriptDir & "\log.log", $aRecords[$x])
Next
	EndFunc
	
Func help()
GUISetState(@SW_SHOW,$Form1)
$sHTML = "<HTML>" & @CR
$sHTML &= "<HEAD>" & @CR
$sHTML &= "<TITLE>Help</TITLE>" & @CR
$sHTML &= "</HEAD>" & @CR
$sHtml &= "<center><h1>Contact : alex_lmao@hotmail.co.uk</h1></center>"
$sHTML &= "</HTML>"
_IEDocWriteHTML ($oIE, $sHTML)
_IEAction ($oIE, "refresh")
EndFunc
	
Func close()
	Exit 0
EndFunc

Func _decrypt()
	$Pass = _StringEncrypt(0,$Pass,"lol")
EndFunc

Func _Login()
	_IENavigate($oIE, "                       ")
	_IELoadWait($oIE)
	$oForm = _IEFormGetCollection($oIE, 0)
	$oUser = _IEFormElementGetObjByName($oForm, "COOKIEusername")
	$oPass = _IEFormElementGetObjByName($oForm, "COOKIEpass")
	$oCode = _IEFormElementGetObjByName($oForm, "verify")
	$oAction = _IEFormElementGetObjByName($oForm, "loginsubmit")
	_IEFormElementSetValue($oUser, $User)
	_IEFormElementSetValue($oPass, $Pass)
	GUISetState(@SW_SHOW,$Form1)
	_IEFormElementSetValue($oCode, InputBox("what is the security code", "enter the security code for Bux.to"))
	GUISetState(@SW_HIDE,$Form1)
	_IEAction($oAction, "click")
	Sleep(4000)
EndFunc