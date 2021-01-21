;==================================================================
;Au3Preprocess 1.5 Included Global style constants
;==================================================================
Global Const $GUI_CHECKED  = 1
Global Const $GUI_ENABLE  = 64
Global Const $GUI_DISABLE  = 128
Global Const $GUI_FOCUS   = 256
Global Const $WS_MINIMIZEBOX  = 0x00020000
Global Const $WS_SIZEBOX   = 0x00040000
Global Const $WS_SYSMENU   = 0x00080000
Global Const $WS_MINIMIZE   = 0x20000000
Global Const $WS_CHILD    = 0x40000000
Global Const $DS_MODALFRAME   = 0x80
Global Const $DS_SETFOREGROUND  = 0x00000200
Global Const $WS_EX_CLIENTEDGE   = 0x00000200
Global Const $WS_EX_TOOLWINDOW   = 0x00000080
Global Const $SS_CENTER   = 1
Global Const $SS_SUNKEN   = 0x1000
; =======================================================================
; Au3UpDate 1.6.3 by Kåre Johansson based on idear from Rob Saunders 17.12.05
; needs CWebPage.dll, Unzip.exe 
; arguments no / return no
; =======================================================================
#NoTrayIcon
HotKeySet("^q", "Exits") ;trap Q to quit
Global Const $Title = 'Au3UpDate',$Rev = '1.6.3',$bar = 117 ; Main application title and TBar time divide value
Global Const $Au3UpReg = 'HKCU\Software\AutoIt v3\Au3UpDate' ; main initreg base entry
Global $MainW,$Child,$ProjM,$HelpM,$QuitM,$TopicsM,$AboutM,$AgentM,$LabelC,$ReleaseVerC,$ReleaseDateC,$ReleaseDlC,$ReleasePageC,$ReleaseDocC,$BetaVerC,$BetaDateC ; main controls ID
Global $BetaDlC,$BetaPageC,$BetaDocC,$ReleasePage,$BetaPage,$NotifyC,$SaveLibC,$ZipC,$ExeC,$CurrVerC,$CurrDateC,$ZipPath,$obj = 0; Main controls ID

Global $CurrBetaVer, $CurrBetaDate, $CurrBetaPath

Global $dm1, $Notify, $filetype, $DefDownDir,$BetaFile,$BetaSize,$ClearSM,$EditSM,$OpenSM,$ReInstSM,$DownM,$ZipEditM ; main menu ID
Global $ReleaseVer, $ReleaseFile,$BetaVer,$Downtemp, $SaveLib,$LastUpdateC,$LastUpdate ; Init data
Global $AboutW,$HomepageC ; Aout window related variables
Global $SystemW ; Au3 system information
Global $GetI,$GetIM ; Is autoit info page available or not - bool
Global $Unzip =  '"' & @SystemDir & '\UnZip.exe" -o * -d ' ; execute line for unzip application
Global $EditW,$dm2,$SpecialLn[99],$SMenuM[99],$SpinObj,$SpinC,$SpinEvt,$Input1,$Input2,$Input3,$NewC,$DeleteC,$SaveC,$Dir1,$Dir2,$up,$Edited = 0,$ThisUpDown ; Special zip editor update menu
Global Const $DatFile = 'http://www.autoitscript.com/autoit3/files/beta/update.dat' ; The INI file location
Global Const $DatFile_Local = @TempDir & '\au3_update.dat' ; where to save the INI downloaded file
Global $oAgent,$oAgentEvt,$strAgentName,$strAgentPath,$Merlin,$MSAgent ; MSAgent related

$CurrBetaPath = RegRead ( 'HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt', 'betaInstallDir' )
If FileExists ( $CurrBetaPath & '\AutoIt3.exe' ) Then
	$CurrBetaVer = FileGetVersion ( $CurrBetaPath & '\AutoIt3.exe' )
	$Ret = FileGetTime ( $CurrBetaPath & '\AutoIt3.exe' )
	$CurrBetaDate = $Ret[1] & '/' & $Ret[2] & '/' & $Ret[0]
Else
	$CurrBetaVer = 'Not Installed'
	$CurrBetaDate = ''
EndIf


If WinExists($title & ' ' & $Rev) Then Exit ; quits if there if the application is already opened
ReadPrefs($Au3UpReg) ; read the application default parametres
If FileExists(@ScriptDir & '\Updates.ini') Then
	$SpecialLn = LoadText(@ScriptDir & '\Updates.ini','L') ; ( 'L' load / $array Save )
Else
	$SpecialLn[0] = 0
EndIf
Global $Au3Path = RegRead('HKLM\Software\AutoIt v3\AutoIt', 'InstallDir') ; get AutoIt3 path
If Not @error And FileExists($Au3Path & '\AutoIt3.exe') Then ; Check autoit3 path and do roundup variables
	Global $CurrVer = FileGetVersion($Au3Path & "\AutoIt3.exe")
	Global $CurrDate = GetDate($Au3Path & "\AutoIt3.exe")
Else
	MsgBox(16,"ERROR...","Could not find AutoIt3 path - has to quit")
	Exit
EndIf
Global Const $dll = DLLOpen("cwebpage.dll") ; load in the Html library for the about window
If $dll = -1 then
	MsgBox(16,"ERROR...","Could not find cwebpage library - has to quit")
	Exit
EndIf
$strAgentName = MSAgentCheck() ; check to see for MSAgent components and if Genie is available
$oMyError = ObjEvent("AutoIt.Error","MyErrFunc")

MainWin()
IF $strAgentName <> '' Then ; activate the MSAgent component
	$oAgent = ObjCreate("Agent.Control")
	if not IsObj($oAgent) then
		$strAgentName = ''
		$MSAgent = 0
	Else
		$oAgentEvt = ObjEvent($oAgent,"Agent_")
		$strAgentPath = $strAgentPath & $strAgentName
		If $MSAgent = 1 Then
			Open_Genie()
			$Merlin.Play("Read")
		EndIf
	EndIf
EndIf
For $a = 1 To 5 ; check to see autoit revision information
	$GetI = CheckInfoSite()
	If $GetI = 1 Then ExitLoop
Next	
If Discription('Forms.SpinButton.1') <> '' Then $obj = 1 ; look up if the component is available
IF Not FileExists(@ScriptDir & '\Library') Then ; check for the library path and create one if not available
	If Not DirCreate(@ScriptDir & '\Library') Then
		MsgBox(16,"ERROR...","Could not Create library path - has to quit")
		Exit
	Endif
EndIf
While 1
	$msg = GUIGetMsg(1)
	Select
	Case $msg[1] = 0 ; Main window handle
	Case Not @InetGetActive AND $GetI = 1; test for recieved informations from autoit site
		If @InetGetBytesRead > 0 Then
			GUICtrlSetData($LabelC,'Ready: Download information recieved')
			GetUpdateData()
		EndIf
		$GetI = 0
		If $MSAgent = 1 Then $Merlin.Stop
	Case $msg[1] = $MainW ; Main window handle
		Select
		Case $msg[0] = -3 OR $msg[0] = $QuitM ; Quit main control and menu
			Exits()
		Case $msg[0] = $GetIM ; Refresh autoit infos menu
			Gui_Disable(0,$GUI_DISABLE)
			Gui_Disable(1,$GUI_DISABLE)
			$GetI = 1
			GUICtrlSetData($LabelC,'')
			For $a = 1 To 5 ; check to see autoit revision information
				$GetI = CheckInfoSite()
				If $GetI = 1 Then ExitLoop
			Next
		Case $msg[0] = $OpenSM ; Open library menu
			$tmp = ReadContent()
			If $tmp <> '' Then
				Run('"' & EnvGet('windir') & '\explorer.exe" /select,"' & @ScriptDir & '\Library\' & $tmp & '"')
			Else
				GUICtrlSetData($LabelC,"Info: Can't open library it's empty")
			EndIf
		Case $msg[0] = $ReInstSM ; ReInstall from library menu
			$tmp = FileLoad('ReInstall from library...',@ScriptDir & '\Library','Files (*.zip;*.exe)')
			If $tmp = '' Then 
				GUICtrlSetData($LabelC,"Info: Okay ReInstall from library Cancel")
			Else
				If MsgBox(65,"REQUEST...",'ReInstall ' & StringMid($Tmp,StringInStr($Tmp,'\', 0, -1)+1) & '- Continue') = 1 Then
					GUICtrlSetData($LabelC,'Info: Auto install process on - Please wait')
					RunCom($tmp,0,'')
				Else
					GUICtrlSetData($LabelC,"Info: Okay Cancel")
					;FileDelete($DownTemp)
				EndIf
			EndIf
		Case $msg[0] = $EditSM ; Edit library menu
			$tmp = FileLoad('Remove files from libraries...',@ScriptDir & '\Library','Files (*.zip;*.exe)')
			If $tmp = '' Then 
				GUICtrlSetData($LabelC,"Info: Okay edit library Cancel")
			Else
				$tmp = StringSplit($tmp,'|')
				If $tmp[0] = 1 Then
					FileDelete($tmp[1])
					If @error then GUICtrlSetData($LabelC,"ERROR - Remove file failed")
				Else
					FOR $a = 2 TO $tmp[0]
						FileDelete($tmp[1] & '\' & $tmp[$a])
						If @error then GUICtrlSetData($LabelC,"ERROR - Remove file failed")
					Next
				EndIf
				GUICtrlSetData($LabelC,"Info: Edit library Contents done")
			EndIf
		Case $msg[0] = $ClearSM ; Clear library menu
			If MsgBox(65,"REQUEST...","Clear the library compleatly - Continue") = 1 Then
				FileDelete(@ScriptDir & '\Library\*.zip')
				FileDelete(@ScriptDir & '\Library\*.exe')
				GUICtrlSetData($LabelC,"Info: Library clear done")
			Else
				GUICtrlSetData($LabelC,"Info: Okay Cancel")
			EndIf
		Case $msg[0] = $TopicsM ; Topics menu
			Topics_Request('\Au3UpdateHelp.chm')
		Case $msg[0] = $AboutM ; About menu
				AboutWin()
		Case $msg[0] = $AgentM
			IF $MSAgent = 0 Then
				Open_Genie()
				Genie_Guide()
			Else
				Close_Genie()
			EndIf
		Case $msg[0] = $ReleaseDlC ; download control release version
			If $filetype = 'Exe' Then
				Download($ReleaseFile, 'AutoIt-v3-setup.exe','')
			Else
				Download(StringReplace($ReleaseFile,'-Setup.exe','.zip'), 'AutoIt-v3.zip','')
			EndIf
		Case $msg[0] = $BetaDlC ; download control beta version
			If $filetype = 'Exe' Then
				Download($BetaFile, 'AutoIt-v' & $BetaVer & '.exe','')
			Else
				Download(StringReplace($betafile,'-beta-Setup.exe','.zip'), 'AutoIt' & $BetaVer & '.zip','')
			EndIf
		Case $msg[0] = $ExeC ; Radio control download executes
			$Filetype = 'Exe'
		Case $msg[0] = $ZipC ; Radio control download archives
			$Filetype = 'Zip'
		Case $msg[0] = $SaveLibC ; Checkbox control save all as libraries
			$SaveLib = StringReplace(GUICtrlRead($SaveLibC),'4','0') 
		Case $msg[0] = $NotifyC ; Checkbox control install directly
			$Notify = StringReplace(GUICtrlRead($NotifyC),'4','0') 
		Case $msg[0] = $ReleasePageC ; internet pages interface
			RunCom($ReleasePage,1,'')
		Case $msg[0] = $ReleaseDocC
			RunCom('http://www.autoitscript.com/forum/index.php?showforum=1',1,'')	
		Case $msg[0] = $BetaPageC
			RunCom($BetaPage,1,'')
		Case $msg[0] = $BetaDocC
			RunCom('http://www.autoitscript.com/forum/index.php?showtopic=10256',1,'')
		Case $msg[0] = 	$ZipEditM ; the special zip editer
			SpecialEditWin()
		Case $msg[0] > 16
			$tmp = StringSplit($SpecialLn[$msg[0]-16],'´|')
			If $tmp[0] > 1 Then ; Bug fix
				$fil = StringSplit($tmp[2],'/')
				Download($tmp[2],$fil[$Fil[0]],$tmp[3])
			EndIf
		EndSelect
	$CurrVer = FileGetVersion($Au3Path & "\AutoIt3.exe") ; check current autoit version
	$CurrDate = GetDate($Au3Path & "\AutoIt3.exe")
	GUICtrlSetData($CurrVerC,'Version: ' & $CurrVer)
	GUICtrlSetData($CurrDateC,'Date: ' & $CurrDate)
	Case $msg[1] = $EditW  ; Special zip editer window handle
		Select
		Case $msg[0] = -3
			$tmp = WinGetPos($EditW)
			$dm2[1] = $tmp[0]
			$dm2[2] = $tmp[1]
			SpecialEditWin()
			If $Edited = 1 Then
				GUIDelete($MainW)
				MainWin()
				Gui_Disable(0,$GUI_ENABLE)
				Gui_Disable(1,$GUI_ENABLE)
			endif
			$Edited = 0
		Case $msg[0] = $NewC ; New button
			$a = $SpecialLn[0] + 1
			$SpecialLn[$a] = 'Item name|Url.Zip|Install Path'
			$SpecialLn[0] = $a
			$tmp = StringSplit($SpecialLn[$a],'´|')
			Change_Entries($tmp[1],$tmp[2],$tmp[3])
			Read_Entries($SpecialLn[0])
			LoadText(@ScriptDir & '\Updates.ini',$SpecialLn)
			GUICtrlSetData($LabelC,"Info: New menu item created")
			$Edited = 1
			GUICtrlSetState($Input2,$GUI_FOCUS)
		Case $msg[0] = $DeleteC ; Delete button
			$b = $SpinObj.value
			$ID = FileOpen(@ScriptDir & '\Updates.ini',2)
			For $a = 1 To $SpecialLn[0]
				If $a <> $SpinObj.value then FileWriteLine($ID,$SpecialLn[$a])
			Next
			FileClose($ID)
			$SpecialLn = 0
			$SpecialLn = LoadText(@ScriptDir & '\Updates.ini','L')
			$tmp = StringSplit($SpecialLn[$SpecialLn[0]],'´|')
			Change_Entries($tmp[1],$tmp[2],$tmp[3])
			GUICtrlSetData($LabelC,"Info: Menu item removed")
			$Edited = 1
			GUICtrlSetState($Input2,$GUI_FOCUS)
		Case $msg[0] = $Up ; Use plain buttons
			$ThisUpDown = $ThisUpDown - 1
			If $ThisUpDown < 1 Then $ThisUpDown = $SpecialLn[0]
			$tmp = StringSplit($SpecialLn[$ThisUpDown],'´|')
			Change_Entries($tmp[1],$tmp[2],$tmp[3])
			GUICtrlSetState($Input2,$GUI_FOCUS)
			GUICtrlSetData($LabelC,"Info: Edit Menu item: " & $ThisUpDown)
		Case $msg[0] = $Dir1 ; get clipboard contense button
			$val = ClipGet()
			GUICtrlSetData($Input2,$val)
			GUICtrlSetData($LabelC,"Info; Zip Url changed please save")
		Case $msg[0] = $Dir2 ; get path button
			GetPath()
		Case $msg[0] = $SaveC ; Save button
			$Edited = 1
			If $obj = 1 Then
				Read_Entries($SpinObj.value)
			Else
				Read_Entries($ThisUpDown)
			EndIf
			GUICtrlSetData($LabelC,"Info: Current Menu item saved")
		EndSelect
	Case $msg[1] = $SystemW ; Au3 system information window handle
		If $msg[0] = -3 Then
			Checksystem()
		EndIf
	Case $msg[1] = $AboutW ; about window handle
		If $msg[0] = $HomepageC Then
			Checksystem()
		ElseIf $msg[0] = -3 Then
			AboutWin()
		EndIf
	EndSelect
Wend
Exits()
; -------------------------------------------------------------
; Agent_Command: Agent menu event related functions
; argument: option / return no
; -------------------------------------------------------------
Func Agent_Command($UserInput)
$a = $UserInput.Name
		Select
		Case $a = "GUIDE"
			Genie_Guide()
		Case $a = "READPAGE"
			Topics_Request('\Au3UpdateHelp.chm')
		Case $a = "STOPALL"
			With $Merlin
				.Stop
				.MoveTo($dm1[1]+288,$dm1[2]+260)
			EndWith
		Case $a = "BYE"
			Close_Genie()
		EndSelect
EndFunc
; -------------------------------------------------------------
; GetUpdateData: Check the downloaded ini file to see latest
; versions, check it against extended and use highest value
; -------------------------------------------------------------
Func GetUpdateData()
	$a = 'Error reading file'
	$BetaVer = IniRead($DatFile_Local, 'AutoItBeta', 'version', $a); available beta version
	$ReleaseVer = IniRead($DatFile_Local, 'AutoIt', 'version', $a) ; avilable autoit3 version
	
	$ReleaseFile = IniRead($DatFile_Local, 'AutoIt', 'setup', '')
	$ReleasePage = IniRead($DatFile_Local, 'AutoIt', 'index', 'http://www.autoitscript.com')
	$ReleaseDate = IniRead($DatFile_Local, 'AutoIt', 'filetime', 0)
	If $ReleaseVer <> $a then
		GUICtrlSetData($ReleaseVerC,'Version: ' & $ReleaseVer)
		Gui_Disable(1,$GUI_ENABLE)
	EndIf
	
	$BetaFile = IniRead($DatFile_Local, 'AutoItBeta', 'setup', '')
	$BetaPage = IniRead($DatFile_Local,'AutoItBeta', 'index', 'http://www.autoitscript.com')
	$BetaDate = IniRead($DatFile_Local, 'AutoItBeta', 'filetime', 0)
	
	If $BetaVer <> $a then
		GUICtrlSetData($BetaVerC,'Version: ' & $BetaVer)
		Gui_Disable(0,$GUI_ENABLE)
	EndIf
	Sleep(1000)
	If $BetaVer <> $a AND $ReleaseVer <> $a Then ; check to see if any information about the two files is available
		GUICtrlSetData($LabelC,'Info: Initiation done as a succes')
	Else
		GUICtrlSetData($LabelC,'ERROR: Initiation failed')
	EndIf
EndFunc
; -------------------------------------------------------------
; Download: Download the files
; Argument: download address, download file as what / Return no 
; -------------------------------------------------------------
Func Download($DownUrl, $DownName,$whereto)
	$DownTemp = @ScriptDir & '\Library\' & $DownName
	GUICtrlSetData($LabelC,'Info: Download in progress - Please wait')
	If InetGet($DownUrl, $DownTemp, 1, 1) = 0 Then
		GUICtrlSetData($LabelC,'Info: Download failed')
		Return
	EndIF
	IF $MSAgent = 1 Then $Merlin.Play("Congratulate_2")
	GUICtrlSetData($LabelC,'')
	GuiCtrlSetColor($LabelC,0x008000)
	$size = InetGetSize($DownUrl)/$bar
	$a = 0
	While @InetGetActive 
		$tmp = StringSplit(@InetGetBytesRead / $size,'.')
		IF $tmp[1] <> $a Then StatusBar()
		$a = $tmp[1]
	Wend
	GuiCtrlSetColor($LabelC,0x000000)
	GUICtrlSetData($LabelC,'Info: Download done')
	If $Notify = 1 Then
		GUICtrlSetData($LabelC,'Info: Auto install process on - Please wait')
		RunCom($DownTemp,0,$whereto)
	ElseIf MsgBox(68,"REQUEST...","Download is compleated - Continue install") = 6 Then
		GUICtrlSetData($LabelC,'Info: Install process on - Please wait')
		RunCom($DownTemp,0,$whereto)
	Else
		GUICtrlSetData($LabelC,'Info: Cancel done')
		;FileDelete($DownTemp)
	EndIf
	If $MSAgent = 1 Then $Merlin.Stop
EndFunc
;==================================================================
;RunCom: Run Topics and do the installs
;argument the file to handle, what to do switz, special location / return no
;==================================================================
Func RunCom($StartPath,$a,$whereto)
	If @OSType = 'WIN32_NT' Then
		$StartStr = @ComSpec & ' /c start "" '
	Else
		$StartStr = @ComSpec & ' /c start '
	EndIf
	If $a > 0 Then ; display topics etc.
		RunWait($StartStr & '"' & $StartPath & '"', '', @SW_HIDE)
	Else  ; execute or unzip process
		$LastUpdate = StringMid($StartPath,StringInStr($StartPath,'\',0,-1)+1)
		If StringInStr(StringLower($StartPath),'.zip') > 0 Then
			If NOT fileexists(@SystemDir & '\Unzip.exe') Then Return GUICtrlSetData($LabelC,'ERROR - Unzip archiver not available')
			If NOT fileexists($StartPath) Then Return GUICtrlSetData($LabelC,'ERROR - The archive file to unzip failed')
			$startpath = '"' & $startpath & '"'
			$a = StringReplace($unzip,'*',$StartPath)
			If StringInStr($startpath,'AutoIt3') > 0 Then
				If $whereto <> '' Then
					$a = $a & '"' & $Whereto & '"'
				Else	
					$a = $a & '"' & $Au3Path & '"'
				EndIf
			EndIf
			RunWait($StartStr & $a,'', @SW_HIDE)
			GUICtrlSetData($LabelC,'Info: Install done as a success')
		Else
			RunWait($StartStr & '"' & $StartPath & '"', '', @SW_HIDE)
		EndIf
		If FileExists($StartPath) AND $SaveLib = 0 Then 
			Sleep(1000)
			FileDelete($StartPath)
		EndIf
		GUICtrlSetData($LastUpdateC,'Last Update: ' & $LastUpdate)
	EndIf
EndFunc
;==================================================================
;ReadPrefs: read in the preferences from initbase
;argument: the initbase address, no returns
;==================================================================
Func ReadPrefs($Prefs)
$var = RegRead($Prefs, '1')
If @error Then $var = '-1 -1' ;Main: x y Pref:1
$dm1 = StringSplit($var, " ")
$var = RegRead($Prefs, '2')
If @error Then $var = '-1 -1' ;Special edit: x y Pref:2
$dm2 = StringSplit($var, " ")
$DefDownDir = RegRead($Prefs, 'DownloadDir')
If @error Then $DefDownDir = @DesktopDir
$Notify = RegRead($Prefs, 'Notify')
If @error Then $Notify = 0
$SaveLib = RegRead($Prefs, 'SaveLib')
If @error Then $SaveLib = 0
$filetype = RegRead($Prefs, 'Filetype')
If @error Then $filetype = 'Exe'
$ZipPath = RegRead($Prefs, 'ZipPath')
If @error Then $ZipPath = 'C:\'
$MSAgent = RegRead($Prefs, 'MSAgent')
If @error Then $MSAgent = 0
$LastUpdate = RegRead($Prefs,'LastUpdate')
If @error Then $LastUpdate = '?'
EndFunc
;==================================================================
;Write the preferences back into Init base
;argument: the initbase address, no returns
;==================================================================
Func WritePrefs($Prefs)
	$tmp = WinGetPos($MainW)
	If $tmp[0] <> -32000 Then
		RegWrite($Prefs, '1', 'REG_SZ', $tmp[0] & ' ' & $tmp[1])
		RegWrite($Prefs, '2', 'REG_SZ', $dm2[1] & ' ' & $dm2[2])
		If @error Then MsgBox(48,"ERROR...","Save preferences failed")
		RegWrite($Prefs, 'DownloadDir', 'REG_SZ', $DefDownDir)
		RegWrite($Prefs, 'Notify', 'REG_SZ', $Notify)
		RegWrite($Prefs, 'SaveLib', 'REG_SZ', $SaveLib)
		RegWrite($Prefs, 'FileType', 'REG_SZ', $filetype)
		RegWrite($Prefs, 'ZipPath', 'REG_SZ', $ZipPath)
		RegWrite($Prefs, 'MSAgent', 'REG_SZ', $MSAgent)
		RegWrite($Prefs, 'LastUpdate', 'REG_SZ', $LastUpdate)
	EndIf
EndFunc
; ========================================
; MainWin - Main window and controls
; arguments no / returns no
; ========================================
Func MainWin()
$MainW = GuiCreate($Title & ' ' & $Rev, 356, 323,$dm1[1],$dm1[2],BitOR($WS_SYSMENU,$WS_MINIMIZEBOX))
$ProjM = GuiCtrlCreateMenu('Project')
$GetIM = GUICtrlCreateMenuItem("Refresh Autoit3 infos", $ProjM)
GuiCtrlCreateMenuItem('',$GetIM)
$LibM = GUICtrlCreateMenu("Library", $ProjM)
	$OpenSM = GUICtrlCreateMenuItem("Open", $LibM)
	GuiCtrlCreateMenuItem('',$LibM)
	$ReInstSM = GUICtrlCreateMenuItem("ReInstall", $LibM)
	GuiCtrlCreateMenuItem('',$LibM)
	$ClearSM = GUICtrlCreateMenuItem("Clear", $LibM)
	$EditSM = GuiCtrlCreateMenuItem('Edit',$LibM)
GuiCtrlCreateMenuItem('',$ProjM)
	$DownM = GUICtrlCreateMenu("Special ZIP UpDates", $ProjM)
	$ZipEditM = GUICtrlCreateMenuItem("Special Zip Editor", $DownM)
	GuiCtrlCreateMenuItem('',$DownM)
	For $a = 1 To $SpecialLn[0]
		$tmp = StringSplit($SpecialLn[$a],'´|')
		$SMenuM[$a] = GUICtrlCreateMenuItem($tmp[1], $DownM)
	Next
	
GuiCtrlCreateMenuItem('',$ProjM)
$QuitM = GuiCtrlCreateMenuItem('Quit	Ctrl+Q',$ProjM)
$HelpM = GuiCtrlCreateMenu('Help')
$TopicsM = GuiCtrlCreateMenuItem('Topics',$HelpM)
$AboutM = GuiCtrlCreateMenuItem('About...',$HelpM)
If $strAgentName <> '' Then
	GuiCtrlCreateMenuItem('',$HelpM)
	$AgentM = GuiCtrlCreateMenuItem('MSAgent',$HelpM)
EndIf
GuiCtrlCreateLabel('', 0, 0, 350, 2, $SS_SUNKEN)

GuiCtrlCreateGroup('Current AutoIt Details', 5, 0, 265, 86)	; -5 to top
$CurrVerC = GuiCtrlCreateLabel('AutoIt3 Version: ' & $CurrVer, 15, 13, 250, 15)
$CurrDateC = GuiCtrlCreateLabel('Date: ' & $CurrDate, 15, 27, 250, 15)
$LastUpdateC = GuiCtrlCreateLabel('Last Update: ' & $LastUpdate, 15, 41, 250, 15)
GuiCtrlCreateLabel('Install Path: ' & StringMid($Au3Path,Abs(_Min(30-StringLen($Au3Path),-1))), 15, 55, 250, 15)
GUICtrlCreateLabel ( 'Beta version installed: ' & $CurrBetaVer & ' - ' & $CurrBetaDate, 15, 69 )

GuiCtrlCreateGroup('Latest Public Release', 5, 90, 165, 40)
$ReleaseVerC = GuiCtrlCreateLabel('Version: Loading...', 15, 110, 145, 15)
GuiCtrlCreateGroup('Latest Beta Release', 180, 90, 165, 40)
$BetaVerC = GuiCtrlCreateLabel('Version: Loading...', 190, 110, 145, 15)
$NotifyC = GUICtrlCreateCheckbox('Install when download complete', 5, 135, 220, 15)
$SaveLibC = GUICtrlCreateCheckbox('Save download files into library', 5, 155, 220, 15)
GUIStartGroup() 
$ZipC = GuiCtrlCreateRadio('Install .Zip', 255, 135, 140, 15)
$ExeC = GuiCtrlCreateRadio('Install .Exe', 255, 155, 140, 15)
If $Notify = 1 Then GuiCtrlSetState($NotifyC, $GUI_CHECKED)
If $SaveLib = 1 Then GuiCtrlSetState($SaveLibC, $GUI_CHECKED)
If $filetype = 'Exe' Then
	GuiCtrlSetState($ExeC, $GUI_CHECKED)
Else
	GuiCtrlSetState($ZipC, $GUI_CHECKED)
EndIf
$ReleaseDlC = GuiCtrlCreateButton('Download Public Release', 5, 175, 165, 30)
$ReleasePageC = GuiCtrlCreateLabel('Visit Download Page', 5, 210, 165, 15, $SS_CENTER)
$ReleaseDocC = GuiCtrlCreateLabel('Visit Announcement News', 5, 225, 165, 15, $SS_CENTER)
Gui_Disable(1,$GUI_DISABLE)
$BetaDlC = GuiCtrlCreateButton('Download Beta', 180, 175, 165, 30)
$BetaPageC = GuiCtrlCreateLabel('Visit Download Page', 180, 210, 165, 15, $SS_CENTER)
$BetaDocC = GuiCtrlCreateLabel('Visit Beta Development', 180, 225, 165, 15, $SS_CENTER)
$LabelC = GuiCtrlCreateInput('',0,250,350,20)
Gui_Disable(0,$GUI_DISABLE)
GuiSetState()
$Child = GuiCreate('', 70,70,275,10,BitOR($WS_CHILD,$DS_SETFOREGROUND,$DS_MODALFRAME),'',$MainW)
DLLCall($dll,"long","EmbedBrowserObject","hwnd",$Child)
$b = @ScriptDir & '\Icons\Eye.gif'
$a = '<BODY scroll=no topmargin=0 leftmargin=0 onclick=window.open("                                         ")><IMG style="position:absolute;left:0;top:0;width:100%;height:100%;cursor:Hand"'
$a = $a & ' src= "' & $b & '" alt="Help I am caught somewhere in cyperspace">'
DLLCall($dll,"long","DisplayHTMLStr","hwnd",$Child,"str",$a)
GUISetState()
EndFunc
;==================================================================
;SpecialEditWin: The special zip editer
;argument no / return no 
;==================================================================
Func SpecialEditWin()
If WinExists("Special Zip Editer") Then
	GUIDelete($EditW)
	$SpinC = 0
	Return
EndIf
IF $MSAgent = 1 Then
	Close_Genie()
	While $MSAgent = 1
		Sleep(500)
	WEnd
EndIf
$tmp = StringSplit($SpecialLn[1],'´|')
$EditW = GUICreate("Special Zip Editer", 664, 150, $dm2[1], $dm2[2],$WS_SIZEBOX,$WS_EX_TOOLWINDOW)
GUICtrlCreateGroup("Zip Url to install", 8, 5, 610, 45)
$Input2 = GUICtrlCreateInput($tmp[2], 16, 22, 569, 21, -1, $WS_EX_CLIENTEDGE)
If $obj = 1 Then
$SpinObj = ObjCreate("Forms.SpinButton.1")
$SpinEvt = ObjEvent($SpinObj,"Spin_")
$SpinC = GUICtrlCreateObj($SpinObj, 625, 10 , 30 , 40 )
With $SpinObj
	.Min = 1
    .Max = 99
	.Value = True
	.Delay = 50
	.forecolor = 0000255
Endwith
Else
	$Up = GUICtrlCreateButton("<>", 625, 10, 30, 40)
	GUICtrlSetTip(-1,'Toggle between all menu items')
	$ThisUpDown = 1
EndIf
GUICtrlSetState($Input2,$GUI_FOCUS)
$Dir1 = GUICtrlCreateButton("_", 592, 18, 19, 25)
GUICtrlSetTip(-1,'Insert URL address from clipboard')
GUICtrlCreateGroup("Item name", 8, 52, 233, 45)
$Input1 = GUICtrlCreateInput($tmp[1], 16, 68, 217, 21, -1, $WS_EX_CLIENTEDGE)
$Dir2 = GUICtrlCreateButton("_", 632, 65, 19, 25)
GUICtrlSetTip(-1,'Insert path to unzip')
GUICtrlCreateGroup("Install path", 248, 52, 409, 45)
$Input3 = GUICtrlCreateInput($tmp[3], 256, 68, 369, 21, -1, $WS_EX_CLIENTEDGE)
$NewC = GUICtrlCreateButton("New", 8, 103, 75, 20)
$DeleteC = GUICtrlCreateButton("Delete", 88, 103, 75, 20)
$SaveC = GUICtrlCreateButton("Save", 168, 103, 75, 20)
GUICtrlSetTip($NewC,'Insert new menu item')
GUICtrlSetTip($DeleteC,'Remove current menu item')
GUICtrlSetTip($SaveC,'Force a save')
GUISetState()
EndFunc
;==================================================================
;About: Display the about window in middle of the screen 
;no arguments, no returns
;==================================================================
Func AboutWin()
If WinExists("About...") Then ; fade out and quit
	DllCall ( "user32.dll", "int", "AnimateWindow", "hwnd", $AboutW, "int", 1000, "long", 0x00090000 )
	Sleep(500)
	GUIDelete($AboutW)
	Return
EndIf
$font="Ariel"
$AboutW = GUICreate("About...",285,130,$dm1[1]+35,$dm1[2]+96,$WS_SIZEBOX,$WS_EX_TOOLWINDOW)
GUICtrlCreatePic(@ScriptDir & '\Icons\xp_designed.gif',5,5, 66,101)
GUICtrlCreateLabel($title & ' ' & $rev,77,15,200,30)
GUICtrlSetFont (-1,18, 400, 0, $font)
GUICtrlCreateLabel('(c)Copyright 2005 by Kåre Johansson',77,45,200,15)
GUICtrlCreateLabel('Autoit3 update system...' ,77,60,200,20)
$HomepageC = GUICtrlCreateButton('Check Au3 system',175,80,100)
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $AboutW, "int", 1000, "long", 0x00080000 )
Sleep(100)
GUISetState()
EndFunc
;==================================================================
;StatusBar: Write to the status bar
;argument no / return no 
;==================================================================
Func StatusBar()
	GUICtrlSetData($LabelC,_HexToString('07'),1)
EndFunc
;==================================================================
;GetDate: Make a readable date
; argument: the file to check / Return the modified date
;==================================================================
Func GetDate($f)
	$a = FileGetTime($f, 0, 2)
Return $a[2] & ':' & $a[1] & ':' & $a[0]
EndFunc
;==================================================================
;Gui_Disable: Disable / inable the Gui 
;argument Disable or enable / return no
;==================================================================
Func Gui_Disable($mode,$act)
If $mode = 1 Then
	GuiCtrlSetState($ReleaseDlC, $act)
	ChangeFState($ReleasePageC,$act)
	ChangeFState($ReleaseDocC,$act)
Else
	GuiCtrlSetState($BetaDlC,$act)
	ChangeFState($BetaPageC ,$act)
	ChangeFState($BetaDocC,$act)
EndIf
EndFunc
;==================================================================
;ChangeState: change the colors and state to controls in main
;argument: the ControlID, State
;==================================================================
Func ChangeFState($Id,$St)
	GuiCtrlSetState($Id, $St)
	GuiCtrlSetFont($Id,9,400,4)
	GuiCtrlSetColor($Id,0x0000ff)
	GuiCtrlSetCursor($Id,0)
EndFunc
;==================================================================
;ReadContent: read the functions scripts in the library
;argument no, return first file or no contense
;==================================================================
Func ReadContent()
$tmp = ''
$search = FileFindFirstFile(@ScriptDir & '\Library\*.*')  
If $search = -1 Then Return $tmp
While 1
    $file = FileFindNextFile($search)
    If @error Then
		ExitLoop
	ElseIf StringInStr(StringLower($file),'.exe') = 0 AND StringInStr(StringLower($file),'.zip') = 0 then
	Else
		$tmp = $file
		Exitloop
	Endif
WEnd
FileClose($search)
Return $tmp
EndFunc
;==================================================================
;FileLoad: open a filerequester to get finename and path
;argument: display text, starting path, suffix / return the selction or empty string
;==================================================================
Func FileLoad($mess,$Path,$suff)
$var = FileOpenDialog($mess, $Path, $Suff, 5)
If @error Then Return ''
Return $var
EndFunc
;==================================================================
;GetPath: open a browserequester to get a path to install zip into
;argument: display text, starting path, suffix / return the selction or empty string
;==================================================================
Func GetPath()
$var = FileSelectFolder("Select path to do install into", "", 7, $zippath)
If $var <> '' Then 
	$ZipPath = $var
	GUICtrlSetData($Input3,$ZipPath)
	GUICtrlSetData($LabelC,"Info; Path changed please save")
EndIf
EndFunc
; ===================================================================
; Topics_Request()
; display the topics in same path if available
; Example: Topics_Request('\Au3UpdateHelp.chm')
; ===================================================================
Func Topics_Request($t)
$Topic = @ScriptDir & $t
	If WinExists($title & ' Topics') Then
	ElseIf FileExists($Topic) = 1 Then
		run(@ComSpec & " /c " & '"'&$Topic&'"',"",@SW_HIDE)
	Else
		GUICtrlSetData($LabelC,"ERROR - Topics failed...")
	EndIf
EndFunc
;==================================================================
;CheckInfoSite: Check autoit info site for revisions
;argument no / return bool
;==================================================================
Func CheckInfoSite()
InetGet($DatFile, $DatFile_Local, 1, 1)
For $a = 1 To @InetGetActive
	If $a = 10000 Then
		GUICtrlSetData($LabelC,"")
		GUICtrlSetData($LabelC,"ERROR - Internet access not available...")
		Sleep(500)
		Return 0
	EndIf
	Sleep(10)
Next
GuiCtrlSetColor($LabelC,0x008000)
For $a = 1 To $bar
	StatusBar()
	Sleep(3)
Next
GuiCtrlSetColor($LabelC,0x000000)
GUICtrlSetData($LabelC,"")
Return 1
EndFunc
;==================================================================
;LoadText: Import text into an array or Save a array into text with 0 as counter
;argument: $File to load, $key ( 'L' Load, $array Save / Return 1 as failure and the lines as array
;$tmp = LoadText($file,$Keyword) ; ( 'L' load / $array Save )
;==================================================================
Func LoadText($file,$key)
$b = 0
If $key <> 'L' Then
	$b = 2
	$tmp = $key
EndIf
$ID = FileOpen($File,$b)
IF $ID = -1 THEN Return 1
If $b = 2 Then
	For $a = 1 To $tmp[0]
		FileWriteLine($ID,$tmp[$a])
	Next
	FileClose($ID)
	Return 0
Else
	$a = 0
	Dim $tmp[9999]
	While 1
		$Line = FileReadLine($ID) ; load file into an array
		If @error Then Exitloop
		$a = $a + 1
		$tmp[$a] = $line
	WEnd
	$tmp[0] = $a
	FileClose($ID)
	Return $tmp
EndIf
EndFunc
; ========================================
; Spin_SpinUp - catch spin form Up
; arguments no / returns no
; ========================================
Func Spin_SpinUp()
$a = $SpinObj.value
	If $a > $SpecialLn[0] Then 
		$SpinObj.value = $SpecialLn[0]
		GUICtrlSetData($LabelC,"Info: Last Menu item: " & $SpinObj.value)
	Else
		GUICtrlSetData($LabelC,"Info: Edit Menu item: " & $a)
	EndIf
	$tmp = StringSplit($SpecialLn[$SpinObj.value],'´|')
	Change_Entries($tmp[1],$tmp[2],$tmp[3])
	GUICtrlSetState($Input2,$GUI_FOCUS)
EndFunc
; ========================================
; Spin_SpinDown - catch spin form down
; arguments no / returns no
; ========================================
Func Spin_SpinDown()
	$tmp = StringSplit($SpecialLn[$SpinObj.value],'´|')
	Change_Entries($tmp[1],$tmp[2],$tmp[3])
	GUICtrlSetData($LabelC,"Info: Edit Menu item: " & $SpinObj.value)
	GUICtrlSetState($Input2,$GUI_FOCUS)
EndFunc
; ========================================
; Change_Entries - Change the three entries in Special edit
; arguments: new values / returns no
; ========================================
Func Change_Entries($a,$b,$c)
	GUICtrlSetData($Input1,$a)
	GUICtrlSetData($Input2,$b)
	GUICtrlSetData($Input3,$c)
EndFunc
; ========================================
; Write_Entries - Create the entry variable from Special edit
; arguments:the variable index / returns no
; ========================================
Func Read_Entries($i)
	$a = GUICtrlRead($Input1)
	$b = GUICtrlRead($Input2)
	$c = GUICtrlRead($Input3)
	$SpecialLn[$i] = $a & '|' & $b & '|' & $c
EndFunc
; ========================================
; Discription: - Check the component revision and abbiliaty
; arguments:the component init / returns revision ID
; ========================================
Func Discription($a)
$var0 = RegRead('HKEY_CLASSES_ROOT\' & $a & '\CurVer','')
If $var0 = '' Then
	$var1 = RegRead('HKEY_CLASSES_ROOT\' & $a & '\CLSID','')
Else
	$var1 = RegRead('HKEY_CLASSES_ROOT\' & $a & '\CLSID','')
EndIf
Return $var1
EndFunc
; ========================================
; MSAgentCheck: - Check the installed MSAgent component
; arguments: no / returns 
; ========================================
Func MSAgentCheck()
$tmp = RegRead('HKEY_CLASSES_ROOT\Agent.Control\CurVer','')
If $tmp <> '' Then
	$tmp = StringReplace($tmp,'Control','Character')
	$tmp = RegRead('HKEY_CLASSES_ROOT\' & $tmp & '\DefaultIcon','')
	If $tmp <> '' Then
		$tmp = StringMid($tmp,1,StringInStr($tmp,'\',0,-1))
		If FileExists($tmp & 'Chars\') Then
			$strAgentPath = $tmp & 'Chars\'
			If FileExists($strAgentPath & 'Genie.acs') then
				Return 'Genie.acs'
			Else
				Return
			EndIf
		EndIf
	EndIf
EndIf
Return
EndFunc
; ========================================
; Open_Genie: - Open the MSAgent components and load Genie character
; arguments: no / returns no
; ========================================
Func Open_Genie()
GUICtrlCreateObj($oAgent, 0, 0 , 64 , 55 )
With $oAgent
	.Connected = -1
	$Characters = .Characters
	$Characters.Load($strAgentName, $strAgentPath)
	$Merlin = $Characters.Character($strAgentName)
EndWith
With $Merlin
		.LanguageID = 2057
		.MoveTo($dm1[1]+288,$dm1[2]+260)
		.Show
		.Commands.RemoveAll
		.Commands.Add("GUIDE", "Start a Guided tour", "Use character to get information")
		.Commands.Add("READPAGE", "Read Web Page", "Read Web Page")
		.Commands.Add("STOPALL", "Shut Up!", "Shut Up")
		.Commands.Add("BYE" , "BYE!", "Bye")
EndWith
$MSAgent = 1
EndFunc
; ========================================
; Genie_Guide: - Open the MSAgent component Guided tour with Genie
; arguments: no / returns 
; ========================================
Func Genie_Guide()
$tmp = WinGetPos($MainW)
If $tmp[0] <> -32000 Then
	$dm1[1] = $tmp[0]
	$dm1[2] = $tmp[1]
EndIf
With $Merlin
	.Play("Confused")
	.Speak('Okay - lets take a tour around Au3Update')
	.MoveTo($dm1[1]+248,$dm1[2]+150)
	.Play("GestureRight")
	.Speak('Here is the latest available AutoIt3 beta version displayed')
	.Play("Explain")
	.Speak('This can contain bugs and there is no garanti that all things will work')
	.MoveTo($dm1[1]+90,$dm1[2]+150)
	.Play("GestureRight")
	.Speak('Here is the latest available AutoIt3 public version displayed')
	.Play("Explain")
	.Speak('This version is tested for some time by the maintainers and the user groups and should not contain bugs but new not fully tested options is not available with this version')
	.MoveTo($dm1[1]+90,$dm1[2]+65)
	.Play("GestureRight")
	.Speak('Here is your current AutoIt3 version displayed, this can both be the public as beta version - Match this revision number with the two revisions below')
	.Play("Explain")
	.Speak('Both versions can be installed but note there is a huge difference between the options available with the two versions')
	.MoveTo($dm1[1]+90,$dm1[2]+220)
	.Play("GestureRight")
	.Speak('This button starts the public version download process from the Internet')
	.Play("GestureLeft")
	.Speak('This button starts the Beta version download process from the Internet')
	.MoveTo($dm1[1]+130,$dm1[2]+170)
	.Play("Announce")
	.Speak('Au3Update can both download and use fully installer scripts as the smaller Zip archives to update your AutoIt3 system')
	.Play("GestureLeft")
	.Speak('These Radio buttons control what update process mode to use')
	.MoveTo($dm1[1]+120,$dm1[2]+265)
	.Play("GestureRight")
	.Speak('It is posible to read about the current updates before install - use these tags to open the browser to display the current pages')
	.Play("GestureLeft")
	.Play("GestureRight")
	.MoveTo($dm1[1]+120,$dm1[2]+285)
	.Play("GestureRight")
	.Speak('This statusline will the display current vital informations on process and success status')
	.MoveTo($dm1[1]+130,$dm1[2]+170)
	.Play("GestureRight")
	.Speak('Au3Update can automate the install process as this checkmark button control that the install process starts automatically')
	.MoveTo($dm1[1]+130,$dm1[2]+185)
	.Play("GestureRight")
	.Speak('Au3Update can save all downloaded updates into a library for later re updates if something goes wrong -  this checkmark button controls this library option')
	.MoveTo($dm1[1]+165,$dm1[2]+70)
	.Play("GestureLeft")
	.Speak('This person is caucht somewhere in Cyper.space but is also a link to my other AutoIt3 application homepages - Please Click to go for a visit')
	.MoveTo($dm1[1]+288,$dm1[2]+260)
	.Speak('Thankyou for letting Genie give you a guided tour around Au3Update')
	.Play("RestPose")
EndWith
EndFunc
; ========================================
; Close_Genie: - Close the MSAgent components and unload Genie
; arguments: no / returns no
; ========================================
Func Close_Genie()
$Merlin.StopAll
$Gesturehide = $Merlin.hide
While $GestureHide.Status = 2
   Sleep(1500)
WEnd
$oAgent.Characters.Unload($strAgentName)
$Characters = 0
$Merlin = 0
$MSAgent = 0
EndFunc
;==================================================================
;CheckSystem: Get revision numbers from au3 system, tools included
;arguments no / return no
;==================================================================
Func CheckSystem()
If WinExists("AutoIt3 System Information...") Then ; fade out and quit
	DllCall ( "user32.dll", "int", "AnimateWindow", "hwnd", $SystemW, "int", 1000, "long", 0x00090000 )
	Sleep(500)
	GUIDelete($SystemW)
	Return
EndIf
$SystemW = GUICreate("AutoIt3 System Information...",356, 323,$dm1[1],$dm1[2],$WS_SIZEBOX,$WS_EX_TOOLWINDOW)
GUICtrlCreateLabel('AutoIt3.exe: ' & FileGetVersion($Au3Path & "\AutoIt3.exe") & ' - The runtime execute file...',5,5,350,15)
GUICtrlCreateLabel('AutoIt3help.exe: ' & FileGetVersion($Au3Path & "\AutoIt3help.exe") & ' - The help system parser...',5,20,350,15)
GUICtrlCreateLabel('SciTe.exe: ' & FileGetVersion($Au3Path & "\SciTe\SciTe.exe") & ' - SCIntilla AutoIt3 Editor...',5,35,350,15)
GUICtrlCreateLabel('SciTeConfig.exe: ' & FileGetVersion($Au3Path & "\SciTe\SciTeConfig.exe") & ' - SciTe basic configuration...',5,50,350,15)
GUICtrlCreateLabel('Tidy.exe: ' & FileGetVersion($Au3Path & "\SciTe\Tidy\Tidy.exe") & ' - TidyUp text wraps...',5,65,350,15)
GUICtrlCreateLabel('Au3Record.exe: ' & FileGetVersion($Au3Path & "\SciTe\Scriptwriter\Au3Record.exe") & ' - Autoit3 system recorder...' ,5,80,350,15)
GUICtrlCreateLabel('Scriptwriter.exe: ' & FileGetVersion($Au3Path & "\SciTe\Scriptwriter\Scriptwriter.exe") & ' - Autoit3 system recorder...',5,95,350,15)
GUICtrlCreateLabel('OptCodeWizard.exe: ' & FileGetVersion($Au3Path & "\SciTe\OptCodeWizard\OptCodeWizard.exe") & ' - Script startup Opt generator...',5,110,350,15)
GUICtrlCreateLabel('FuncPopUp.exe: ' & FileGetVersion($Au3Path & "\SciTe\FuncPopUp\FuncPopUp.exe") & ' - Function documentation system...',5,125,350,15)
GUICtrlCreateLabel('CompileAu3.exe: ' & FileGetVersion($Au3Path & "\SciTe\CompileAu3\CompileAu3.exe") & ' - Compile frontend intuition...',5,140,350,15)
GUICtrlCreateLabel('ResHacker.exe: ' & FileGetVersion($Au3Path & "\SciTe\CompileAu3\ResHacker.exe") & ' - Copyright and revision system hacker...',5,155,350,15)
GUICtrlCreateLabel('Rc.exe: ' & FileGetVersion($Au3Path & "\SciTe\CompileAu3\Rc.exe") & ' - Resource inspector...',5,170,350,15)
GUICtrlCreateLabel('Codewizard.exe: ' & FileGetVersion($Au3Path & "\SciTe\CodeWizard\Codewizard.exe") & ' - Messageboxes code generator...',5,185,350,15)
GUICtrlCreateLabel('AutoItMacroGenerator.exe: ' & FileGetVersion($Au3Path & "\SciTe\AutoItMacroGenerator\AutoItMacroGenerator02.exe") & ' - Recorder macro code generator...',5,200,350,15)
GUICtrlCreateLabel('Koda: ' & FileGetVersion($Au3Path & "\Koda\FD.exe") & ' - Visual development system...',5,215,350,15)
GUICtrlCreateLabel('Aut2Exe.exe: ' & FileGetVersion($Au3Path & "\Aut2Exe\Aut2Exe.exe") & ' - Compile executer frontend intuition...',5,230,350,15)
GUICtrlCreateLabel('Upx.exe: ' & FileGetVersion($Au3Path & "\Aut2Exe\Upx.exe")& ' - Execute archiver...',5,245,350,15)
GUICtrlCreateLabel('Au3Update.exe: ' & FileGetVersion($Au3Path & "\Au3Update\Au3Update.exe") & ' - AutoIt3 check and update system...',5,260,350,15)
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $SystemW, "int", 1000, "long", 0x00080000 )
Sleep(100)
GUISetState()
EndFunc
Func MyErrFunc($r,$a)
	;
EndFunc
; ========================================
; Exits - Exit all and write preferences
; arguments no / returns no
; ========================================
Func Exits()
WritePrefs($Au3UpReg)
If $MSAgent = 1 Then Close_Genie()
$oAgentEvt = 0
$oAgent = 0
If WinExists("About...") Then GUIDelete($AboutW)
If WinExists("AutoIt3 System Information...") Then GUIDelete($ystemW)
If WinExists("Special Zip Editer") Then GUIDelete($EditW)
If WinExists('Library') Then WinClose('Library')
If WinExists($title & ' Topics') Then WinClose($title & ' Topics')
DLLCall($dll,"long","UnEmbedBrowserObject","hwnd",$Child)
GUIDelete($MainW)
If FileExists($DatFile_Local) then FileDelete($DatFile_Local)
$SpinEvt = 0
$SpinObj = 0
;DLLClose($dll) ; bug !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Exit
EndFunc
;==================================================================
;Au3Preprocess 1.5 Included used functions
;==================================================================
Func _HexToString($strHex)
	Local $strChar, $aryHex, $i, $iDec, $Char, $file, $iOne, $iTwo
	
	$aryHex = StringSplit($strHex, "")
	If Mod($aryHex[0], 2) <> 0 Then
		SetError(1)
		Return -1
	EndIf
	
	For $i = 1 To $aryHex[0]
		$iOne = $aryHex[$i]
		$i = $i + 1
		$iTwo = $aryHex[$i]
		$iDec = Dec($iOne & $iTwo)
		If @error <> 0 Then
			SetError(1)
			Return -1
		EndIf
		
		$Char = Chr($iDec)
		$strChar = $strChar & $Char
	Next
	
	Return $strChar
EndFunc
Func _Min($nNum1, $nNum2)
	; Check to see if the parameters are indeed numbers of some sort.
	If (Not IsNumber($nNum1)) Then
		SetError(1)
		Return (0)
	EndIf
	If (Not IsNumber($nNum2)) Then
		SetError(2)
		Return (0)
	EndIf
	
	If $nNum1 > $nNum2 Then
		Return $nNum2
	Else
		Return $nNum1
	EndIf
EndFunc
