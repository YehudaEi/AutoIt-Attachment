#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=aspl.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Constants.au3>
#include <GuiConstantsEx.au3>
#include <GUIDefaultConstants.au3>
#include <Misc.au3>
AutoItSetOption('GUICloseOnEsc',1)
AutoItSetOption('MustDeclareVars',1)
AutoItSetOption('GUIOnEventMode',1)

;aspell options
Global $pathAspell = @ProgramFilesDir & '\Aspell\bin'					; path to aspell.exe
Global $useAspellConfig = 'English,Deutsch'								; list of used aspell config sections
Global $aspTitleEN = 'English'											; english title string
Global $aspLangEN = '--lang en_US'										; english aspell language string
Global $aspOptsEN = '--ignore-case --ignore-accents'					; english aspell options string
Global $aspPersonalEN = '--personal '&@UserName&'.EN'					; english aspell personal dictionary file
Global $aspTitleDE = 'Deutsch'											; german title string
Global $aspLangDE = '--lang de_DE --add-extra-dicts de_CH'				; german aspell language string
Global $aspOptsDE = '--ignore-case --ignore-accents'					; german aspell options string
Global $aspPersonalDE = '--personal '&@UserName&'.DE'					; german aspell personal dictionary file
Global $aspTitleFR = 'Francais'											; french title string
Global $aspLangFR = '--lang fr_FR'										; french aspell language string
Global $aspOptsFR = '--ignore-case --ignore-accents'					; french aspell options string
Global $aspPersonalFR = '--personal '&@UserName&'.FR'					; french aspell personal dictionary file

; ini config settings
Global $sAppTitle = 'aspl'												; title string
Global $defaultLang = 'English'											; default language setting
Global $hotkeySearch = '^d'												; hotkey to start search
Global $hotkeyExit = '^x'												; hotkey to quit program
Global $autoSelect = 1													; auto select word per double mouse click
Global $smallDisplay = 0												; 1/2 lines gui
Global $useTrayInfo = 0													; show infos in tray bubble or at mouse cursor
Global $colPopup = '0xFFCC66'											; main gui color
Global $showMaxHits = 22												; max nmuber

; program vars
Global $sAppIni = @ScriptDir & '\' & Stringleft(@ScriptName,StringLen(@ScriptName)-4) & '.ini'		; application ini file
Global $gWin,$gAddPersonal,$gDump										; gui objects
Global $trayExit,$trayHelp,$trayDCfg,$trayAutoSelect,$trayShowPersonal	; tray objects
Global $hAspl															; aspell.exe handle
Global $aCfg[1][4]														; aspell cfg: name - lang - option - personal
Global $agTrayItem[1]													; traymenu items: languages
Global $agSuggestion[1][2]												; contextmenu items: suggestions
Global $user32DLL = DllOpen('user32.dll')								; dll handle
Global $txtToTest = ''													; text will be queried
Global $bFineSelection													; exactly one word is selected
Global $bDebug = True													; debug console output
Global $aHkSearch[2]													; hex hotkey values
Global $iWordsReplaced = 0												; replaced word count per program run
Global $aspOpts = $aspOptsEN											; active aspell options string
Global $aspLang = $aspLangEN											; active aspell language string
Global $aspPersonal = $aspPersonalEN									; active aspell personal dictionary file

setupApp()
While 1
	Sleep(6000)
WEnd


Func setupApp()
	readIni($sAppIni)
	checkUniqueInstance($sAppTitle)
	If Not @Compiled Then mkIconFile($sAppTitle)
	setupHotkeys()
	setupTray()
	switchLanguage($defaultLang)
EndFunc

Func checkTrayEvent()
	Switch @TRAY_ID
		Case $agTrayItem[1] To $agTrayItem[$agTrayItem[0]]
			switchLanguage($aCfg[@TRAY_ID-$agTrayItem[1]+1][0],@TRAY_ID-$agTrayItem[1]+1)
			markTrayItem(@TRAY_ID)
		Case $trayDCfg
			showConfigDmp()
		Case $trayShowPersonal
			showPersonalWordlist()
		Case $trayAutoSelect
			If $autoSelect Then
				$autoSelect = 0
				TrayItemSetState($trayAutoSelect,$TRAY_UNCHECKED)
			Else
				$autoSelect = 1
				TrayItemSetState($trayAutoSelect,$TRAY_CHECKED)
			EndIf
		Case $trayHelp
			showHelp()
		Case $trayExit
			quitApp()
	EndSwitch
EndFunc

Func setSuggestion()
	Switch @GUI_CtrlId
		Case $agSuggestion[1][0] To $agSuggestion[$agSuggestion[0][0]][0]
			If Not $bFineSelection Then
				If MsgBox(49,'Selection too big','Selection is larger than the suggested word.' & @LF & _
												'More text than the suggested word will be replaced in the editor.'&@LF&@LF& _
												'Dou you want to replace the text?') <> 1 Then
					removeGui()
					Return
				EndIf
			EndIf
			ClipPut($agSuggestion[@GUI_CtrlId-$agSuggestion[1][0]+1][1])
			removeGui()
			Send('+{INS}')
			$iWordsReplaced += 1
	EndSwitch
EndFunc

Func switchLanguage($l,$j=0)
	$defaultLang = $l
	ProcessClose($hAspl)
	If $j = 0 Then
		Local $chk = False
		For $i = 1 To $aCfg[0][0]
			If $l = $aCfg[$i][0] Then
				$chk = True
				$aspLang = $aCfg[$i][1]
				$aspOpts = $aCfg[$i][2]
				$aspPersonal = $aCfg[$i][3]
				ExitLoop
			EndIf
		Next
		If Not $chk Then MsgBox(48,'Config error:','No settings found for language: ' & $l)
	Else
		$aspLang = $aCfg[$j][1]
		$aspOpts = $aCfg[$j][2]
		$aspPersonal = $aCfg[$j][3]
	EndIf
	If Not initAspell() Then Exit
EndFunc

Func addPersonal()
	StdinWrite($hAspl,'*' & $txtToTest & @CRLF)
	StdinWrite($hAspl,'#' & @CRLF)
	If @error Then 
		MsgBox(48,'Personal Wordlist Error','Error writing to process: aspell.exe')
		Return False
	EndIf
	removeGui()
	showTip("'" & $txtToTest & "' added to personal wordlist",1)
	Return True
EndFunc

Func removeGui()
	GUIDelete($gWin)
	$gWin = 0
EndFunc

Func getMax($a,$b)
	If $a > $b Then Return $a
	Return $b
EndFunc

Func showDialog($txt,ByRef $aSuggs,$winLeft,$winTop)
	Local Const $WM_ACTIVATEAPP = 0x01C
	If $gWin Then removeGui()
	$winTop += 8
	Local $winWidth,$winHeight
	Local $gDisplay,$gMenu
	If $smallDisplay Then
		$winWidth = StringLen('   suggestions')*5 + 30
		$winHeight = 15
		$gWin = GUICreate($sAppTitle,$winWidth,$winHeight,$winLeft,$winTop,$WS_POPUP,$WS_EX_TOOLWINDOW)
		$gDisplay = GUICtrlCreateLabel($aSuggs[0] & ' suggestions',0,0,$winWidth,$winHeight,BitOR($GUI_SS_DEFAULT_LABEL,$SS_CENTER),$GUI_WS_EX_PARENTDRAG)
	Else
		$winWidth = getMax(StringLen(" ?   ''")*5 + StringLen($txt)*5 + 40, _
						   StringLen('  !   suggestions ')*5 + 20)
		$winHeight = 28
		$gWin = GUICreate($sAppTitle,$winWidth,$winHeight,$winLeft,$winTop,$WS_POPUP,$WS_EX_TOOLWINDOW)
		$gDisplay = GUICtrlCreateLabel(" ?   '" & $txt & "'" & @CRLF & '  !   ' & $aSuggs[0] & ' suggestions',0,0,$winWidth,$winHeight,$GUI_SS_DEFAULT_LABEL,$GUI_WS_EX_PARENTDRAG)
	EndIf
	GUICtrlSetBkColor(-1,$colPopup)
	GUISetOnEvent($GUI_EVENT_CLOSE,'removeGui')
	GUIRegisterMsg($WM_ACTIVATEAPP,'MY_WM_GETFOCUS')
	$gMenu = GUICtrlCreateContextMenu($gDisplay)
	If $aspPersonal Then 
		$gAddPersonal = GUICtrlCreateMenuitem("--> add  '"&$txt&"'",$gMenu)
		GUICtrlSetOnEvent(-1,'addPersonal')
	EndIf
	$agSuggestion[0][0] = 0
	For $i = 1 To $aSuggs[0]
		If $aSuggs[$i] Then
			$agSuggestion[0][0] += 1
			If $agSuggestion[0][0] >= UBound($agSuggestion,1) Then ReDim $agSuggestion[$agSuggestion[0][0]+12][UBound($agSuggestion,UBound($agSuggestion,0))]
			$agSuggestion[$agSuggestion[0][0]][0] = GUICtrlCreateMenuitem($aSuggs[$i],$gMenu)
			$agSuggestion[$agSuggestion[0][0]][1] = $aSuggs[$i]
			GUICtrlSetOnEvent(-1,'setSuggestion')
			If $agSuggestion[0][0] >= $showMaxHits Then ExitLoop
		EndIf
	Next
	GUISetState()
	MouseMove($winLeft+$winWidth-10,$winTop+$winHeight/2,5)
	MouseClick('secondary')
EndFunc

Func getSuggestions()
	HotKeySet($hotkeySearch)
	Do
		Sleep(10)
	Until hotKeyReleased($aHkSearch)
	Local $rc,$rcLine = '',$txt = '',$flag = 3
	Local $aSuggs[1]
	Local $mPos = MouseGetPos()
	If $autoSelect Then MouseClick('primary',$mPos[0],$mPos[1],2)
	ClipPut('')
	Sleep(10)
	Send('^{INS}')
	Sleep(10)
	$txt = ClipGet()
	$txtToTest = getFirstWord($txt)
	cons("txt: '" & $txt & "'")
	cons("firstWord: '" & $txtToTest & "'")
	$bFineSelection = False
	If $txt = $txtToTest Then $bFineSelection = True
	If $txtToTest Then
		StdinWrite($hAspl,$txtToTest & @CRLF)
		If @error Then
			MsgBox(16,'Error','Error writing to process: aspell.exe')
			Return False
		EndIf
		While 1
			$rcLine &= StdoutRead($hAspl)
			If @error Then ExitLoop
			$rc = StringSplit($rcLine,@CR)
			If $rc[$rc[0]] = @LF Then ExitLoop
		WEnd
		For $i = 1 To $rc[0]
			If StringLeft($rc[$i],1) = '&' Then
				$aSuggs = StringMid($rc[$i],StringInStr($rc[$i],':')+2)
				$aSuggs = StringReplace($aSuggs,', ',',')
				Cons("aSuggs:"&$aSuggs&":")
				$aSuggs = StringSplit($aSuggs,',')
				$flag = 1
				ExitLoop
			ElseIf StringLeft($rc[$i],1) = '#' Then
				$flag = 0
				ExitLoop
			ElseIf StringLeft($rc[$i],1) = '*' Then
				$flag = 2
				ExitLoop
			Else
				$flag = 0
			EndIf
		Next
		Switch $flag
			Case 0
				showTip("'" & $txtToTest & "' - nothing found.",2)
			Case 1
				If $aSuggs[0] > 0 Then showDialog($txtToTest,$aSuggs,$mPos[0],$mPos[1])
			Case 2
				showTip("'" & $txtToTest & "' - is correct.",1)
			Case Else
				MsgBox(1,'Error','Unexpected result:' & @CRLF & @CRLF & "'" & $rcLine & "'")
		EndSwitch
	Else
		showTip('Clipboard error, empty searchstring.',3)
	EndIf
	HotKeySet($hotkeySearch,'getSuggestions')
	Return True
EndFunc

Func getFirstWord($t)
	Local $stopChar[27] =  [' ','(',')','{','}','[',']','_','.',';', _
							',','#','\','/','0','1','2','3','4','5', _
							'6','7','8','9','$','@','&']
	$t = StringReplace($t,@CR,' ')
	$t = StringReplace($t,@LF,' ')
	$t = StringReplace($t,@TAB,' ')
	Local $bFound = True
	While $t And $bFound
		For $str in $stopChar
			If StringLeft($t,1) = $str Then
				$t = StringMid($t,2)
				$bFound = True
				ContinueLoop(2)
			EndIf
		Next
		$bFound = False
	WEnd
	For $i = 1 To StringLen($t)
		For $str in $stopChar
			If StringMid($t,$i,1) = $str Then
				$t = StringLeft($t,$i-1)
				ExitLoop(2)
			EndIf
		Next
	Next
	Return $t
EndFunc

Func showTip($txt,$flag=1)
	If $useTrayInfo Then
		TrayTip($sAppTitle & '         ',$txt,5,$flag)
	Else
		ToolTip($txt,Default,Default,$sAppTitle,$flag,1)
		Sleep(800)
		ToolTip('')
	EndIf
EndFunc

Func showHelp()
	MsgBox(64,'Short Help Info','Aspell GUI Interface' & @CRLF & @CRLF & _
								'- hoover your mouse over a word in any application' & @CRLF & _
								'- select the word to query (only if "autoSelect" is set to "0" in the ini file)' & @CRLF & _
								'- click Ctrl-D to search' & @CRLF & @CRLF & _
								'Active aspell settings:' & @CRLF & _
								$aspLang & ',' & @CRLF & _
								$aspOpts & ',' & @CRLF & _
								$aspPersonal & ';' & @CRLF & @CRLF & _
								'Running aspell.exe pid: ' & $hAspl & @CRLF & _
								'Replaced words: ' & $iWordsReplaced)
EndFunc

Func showPersonalWordlist()
	Local $p = StringRegExpReplace($aspPersonal,'--personal\s+','')
	If Not FileExists($p) Then $p = StringRegExpReplace($pathAspell,'\\bin$','') & '\' & $p
	If Not FileExists($p) Then
		MsgBox(16,'File not found error','Cannot find personal word file: ' & $p)
		Return False
	EndIf
	Run('notepad.exe "' & $p & '"')
	Return True
EndFunc


Func showConfigDmp()
	Local $dumpTitle = 'Aspell Config Dump'
	If WinExists($dumpTitle) Then 
		WinActivate($dumpTitle)
		Return
	EndIf
	Local $rcLine
	Local $h = Run($pathAspell & '\aspell.exe dump config ' &$aspOpts& ' ' &$aspLang& ' ' &$aspPersonal,$pathAspell,@SW_HIDE,$STDOUT_CHILD+$STDIN_CHILD+$STDERR_CHILD)
	If @error Then
		MsgBox(16,'Error dump config','Error writing to process: aspell.exe')
		Return False
	EndIf
	While 1
		$rcLine &= StdoutRead($h)
		If @error Then ExitLoop
	WEnd
	$rcLine = 'Active aspell config dump:' & @CRLF & @CRLF & @CRLF & $rcLine
	$gDump = GUICreate($dumpTitle,@DesktopWidth-200,400,-1,-1,BitOR($WS_CAPTION,$WS_MAXIMIZEBOX,$WS_THICKFRAME))
	GUISetOnEvent($GUI_EVENT_CLOSE,'showConfigDmpClose',$gDump)
	GUICtrlCreateEdit($rcLine,0,0,@DesktopWidth-200,400)
	GUICtrlSetTip(-1,'You may copy and paste config settings into the ini file.')
	GUISetState(@SW_SHOW,$gDump)
EndFunc

Func showConfigDmpClose()
	GUIDelete($gDump)
EndFunc

Func initAspell()
	Local $rcLine
	If Not FileExists($pathAspell & '\aspell.exe') Then
		MsgBox(16,'Aspell init error:','File does not exist: ' & $pathAspell & '\aspell.exe')
		Return False
	EndIf
	$hAspl = Run($pathAspell & '\aspell.exe -a ' &$aspOpts& ' ' &$aspLang& ' ' &$aspPersonal,$pathAspell,@SW_HIDE,$STDOUT_CHILD+$STDIN_CHILD+$STDERR_CHILD)
	If @error Then 
		MsgBox(16,'Aspell init error:','Error starting process: aspell.exe')
		Return False
	EndIf
	StdinWrite($hAspl,'123456789' & @CRLF)
	If @error Then 
		MsgBox(16,'Aspell init error:','Error writing to process: aspell.exe')
		Return False
	EndIf
	While 1
		$rcLine &= StdoutRead($hAspl)
		If @error Then ExitLoop
		If StringInStr($rcLine,@CRLF) Then ExitLoop
	Wend
	If ProcessExists($hAspl) Then 
		Return True
	Else
		$rcLine = ''
		While 1
			$rcLine &= StdErrRead($hAspl)
			If @error Then ExitLoop
		Wend
		If $rcLine Then MsgBox(16,'Aspell start error','aspell.exe returned an error:' &@CRLF& $rcLine &@CRLF&@CRLF& _
									'Please review your configuration, ' & $sAppTitle & ' will quit now.')
		Return False
	EndIf
EndFunc

Func setupTray()
	Local $defaultOK = False
	AutoItSetOption('TrayMenuMode',1)
	AutoItSetOption('TrayAutoPause',0)
	AutoItSetOption('TrayOnEventMode',1)
	TraySetToolTip($sAppTitle)
	TraySetState(9)
	TraySetClick(8)
	For $i = 1 to $aCfg[0][0]
		pushArray1($agTrayItem,TrayCreateItem($aCfg[$i][0]))
		TrayItemSetOnEvent(-1,'checkTrayEvent')
		If $defaultLang = $aCfg[$i][0] Then
			markTrayItem($agTrayItem[$i])
			$defaultOK = True
		EndIf
	Next
	TrayCreateItem('')
	$trayAutoSelect = TrayCreateItem('Autoselect word')
	TrayItemSetOnEvent(-1,'checkTrayEvent')
	If $autoSelect Then TrayItemSetState($trayAutoSelect,$TRAY_CHECKED)
	$trayDCfg = TrayCreateItem('Aspell config dump')
	TrayItemSetOnEvent(-1,'checkTrayEvent')
	$trayShowPersonal = TrayCreateItem('Personal dictionary')
	TrayItemSetOnEvent(-1,'checkTrayEvent')
	$trayHelp = TrayCreateItem('Help info')
	TrayItemSetOnEvent(-1,'checkTrayEvent')
	$trayExit = TrayCreateItem('Exit')
	TrayItemSetOnEvent(-1,'checkTrayEvent')
	If Not $defaultOK Then markTrayItem($agTrayItem[1])
EndFunc

Func markTrayItem($id)
	For $i = 1 To $agTrayItem[0]
		TrayItemSetState($agTrayItem[$i],$TRAY_UNCHECKED)
	Next
	TrayItemSetState($id,$TRAY_CHECKED)
EndFunc

Func saveIni($f)
	If Not FileExists($f) Then
		Local $msg = ';aspl Configuration Settings' & @CRLF
		$msg &= '[Config]' & @CRLF
		$msg &= ';application title string' & @CRLF
		$msg &= 'appTitle=' & $sAppTitle & @CRLF
		$msg &= ';path to aspell.exe' & @CRLF
		$msg &= 'pathAspell=' & $pathAspell & @CRLF
		$msg &= ';autoselect word under mouse cursor, when hotkey is pressed' & @CRLF
		$msg &= 'autoSelect=' & $autoSelect & @CRLF
		$msg &= ';AspellConfig-Settings to be used in tray menu' & @CRLF
		$msg &= 'useAspellConfig=' & $useAspellConfig & @CRLF
		$msg &= ';active default Language' & @CRLF
		$msg &= 'defaultLang=' & $defaultLang & @CRLF
		$msg &= ';hotkey to start search for suggestions' & @CRLF
		$msg &= 'hotkeySearch=' & $hotkeySearch & @CRLF
		$msg &= ';hotkey for program exit, leave empty to disable' & @CRLF
		$msg &= 'hotkeyExit=' & $hotkeyExit & @CRLF
		$msg &= ';single line gui' & @CRLF
		$msg &= 'smallDisplay= ' & $smallDisplay & @CRLF
		$msg &= ';show infos via tray bubble' & @CRLF
		$msg &= 'useTrayInfo=' & $useTrayInfo & @CRLF
		$msg &= ';main gui color' & @CRLF
		$msg &= 'popupColor=' & $colPopup & @CRLF
		$msg &= ';max number of suggestions shown' & @CRLF
		$msg &= 'showMaxHits=' & $showMaxHits & @CRLF

		$msg &= ';here you may define as many aspell-config-settings as you like' & @CRLF
		$msg &= ';we will start with three languages' & @CRLF
		$msg &= ';languages actually used in tray menu are defined in key "useAspellConfig" above' & @CRLF
		$msg &= ';' & @CRLF
		$msg &= ';aspell settings for language: English' & @CRLF
		$msg &= '[AspellConfig-English]' & @CRLF
		$msg &= 'title=' & $aspTitleEN & @CRLF
		$msg &= ';aspell language setting' & @CRLF
		$msg &= 'lang=' & $aspLangEN & @CRLF
		$msg &= ';aspell options, use whatever aspell command line options you want' & @CRLF
		$msg &= 'options=' & $aspOptsEN & @CRLF
		$msg &= ';personal dictionary, will be created if it does not exist' & @CRLF
		$msg &= 'personal=' & $aspPersonalEN & @CRLF

		$msg &= ';aspell settings for language: German' & @CRLF
		$msg &= '[AspellConfig-Deutsch]' & @CRLF
		$msg &= 'title=' & $aspTitleDE & @CRLF
		$msg &= 'lang=' & $aspLangDE & @CRLF
		$msg &= 'options=' & $aspOptsDE & @CRLF
		$msg &= 'personal=' & $aspPersonalDE & @CRLF

		$msg &= ';aspell settings for language: French' & @CRLF
		$msg &= '[AspellConfig-Francais]' & @CRLF
		$msg &= 'title=' & $aspTitleFR & @CRLF
		$msg &= 'lang=' & $aspLangFR & @CRLF
		$msg &= 'options=' & $aspOptsFR & @CRLF
		$msg &= 'personal=' & $aspPersonalFR & @CRLF
		FileWrite($f,$msg)
	Else
		IniWrite($f,'Config','defaultLang',$defaultLang)
		IniWrite($f,'Config','autoSelect',$autoSelect)
	EndIf
EndFunc

Func readIni($f)
	If Not FileExists($f) Then saveIni($f)
	$pathAspell = IniRead($f,'Config','pathAspell',$pathAspell)
	If Not FileExists($pathAspell & '\aspell.exe') Then
		$pathAspell = RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\Aspell','Path')
		If Not FileExists($pathAspell & '\aspell.exe') Then
			MsgBox(16,'Aspell install error:','Aspell seems not to be installed on this computer. Quit.')
			Exit
		EndIf
		IniWrite($f,'Config','pathAspell',$pathAspell)
	EndIf
	$sAppTitle = IniRead($f,'Config','appTitle',$sAppTitle)
	$autoSelect = Number(IniRead($f,'Config','autoSelect',$autoSelect))
	$defaultLang = String(IniRead($f,'Config','defaultLang',$defaultLang))
	$hotkeySearch = IniRead($f,'Config','hotkeySearch',$hotkeySearch)
	$hotkeyExit = IniRead($f,'Config','hotkeyExit',$hotkeyExit)
	$smallDisplay = Number(IniRead($f,'Config','smallDisplay',$smallDisplay))
	$useTrayInfo = Number(IniRead($f,'Config','useTrayInfo',$useTrayInfo))
	$colPopup = IniRead($f,'Config','popupColor',$colPopup)
	$showMaxHits = IniRead($f,'Config','showMaxHits',$showMaxHits)
	Local $aLangs = StringSplit(IniRead($f,'Config','useAspellConfig',$useAspellConfig),',')
	For $i = 1 To $aLangs[0]
		Local $s,$s1,$s2,$s3,$s4
		$s = IniReadSection($f,'AspellConfig-'&$aLangs[$i])
		If Not IsArray($s) Then
			MsgBox(48,'Config Error','Language section not found: '&'AspellConfig-'&$aLangs[$i] & @LF)
			ContinueLoop
		EndIf
		$s1 = IniRead($f,'AspellConfig-'&$aLangs[$i],'title','')
		If Not $s1 Then
			MsgBox(48,'Config Error','no key "title" found in section :'&'AspellConfig-'&$aLangs[$i] & @LF)
			ContinueLoop
		EndIf
		$s2 = IniRead($f,'AspellConfig-'&$aLangs[$i],'lang','')
		If Not $s2 Then
			MsgBox(48,'Config Error','no key "lang" found in section :'&'AspellConfig-'&$aLangs[$i] & @LF)
			ContinueLoop
		EndIf
		$s3 = IniRead($f,'AspellConfig-'&$aLangs[$i],'options','')
		If Not $s3 Then
			MsgBox(48,'Config Error','no key "options" found in section :'&'AspellConfig-'&$aLangs[$i] & @LF)
			ContinueLoop
		EndIf
		$s4 = IniRead($f,'AspellConfig-'&$aLangs[$i],'personal','')
		pushArray($aCfg,$s1,$s2,$s3,$s4)
	Next
EndFunc	

Func pushArray1(ByRef $a,$v0)
	$a[0] += 1
	If $a[0] >= UBound($a) Then ReDim $a[$a[0]+12]
	$a[$a[0]] = $v0
EndFunc

Func pushArray(ByRef $a,$v0,$v1,$v2,$v3)
	$a[0][0] += 1
	If $a[0][0] >= UBound($a,1) Then ReDim $a[$a[0][0]+12][UBound($a,UBound($a,0))]
	$a[$a[0][0]][0] = $v0
	$a[$a[0][0]][1] = $v1
	$a[$a[0][0]][2] = $v2
	$a[$a[0][0]][3] = $v3
EndFunc

Func quitApp()
	saveIni($sAppIni)
	If ProcessExists($hAspl) Then ProcessClose($hAspl)
	DllClose($user32DLL)
	removeGui()
	Exit
EndFunc

Func checkUniqueInstance($app)
	If _Singleton($app,1) = 0 Then
		MsgBox(48+4096+262144,'Application already running.',$app & ' is active already. There is an icon in the system tray.')
		Exit
	EndIf
EndFunc

Func setupHotkeys()
	HotKeySet($hotkeySearch,'getSuggestions')
	For $i = 1 To StringLen($hotkeySearch) - 1
		Switch StringMid($hotkeySearch,$i,1)
			Case '+'	; Shift
				$aHkSearch[$i-1] = '10'
			Case '^'	; Ctrl
				$aHkSearch[$i-1] = '11'
			Case '!'	; Alt
				$aHkSearch[$i-1] = '12'
			Case Else	; Left mouse button
				$aHkSearch[$i-1] = '01'
		EndSwitch
	Next
	$aHkSearch[StringLen($hotkeySearch)-1] = Hex(Asc(StringUpper(StringRight($hotkeySearch,1))),2)
	If $hotkeyExit Then HotKeySet($hotkeyExit,'quitApp')
EndFunc

Func hotKeyReleased(ByRef $a)
	For $i = 0 to UBound($a)-1
		If _IsPressed($a[$i],$user32DLL) Then Return False
	Next
	Return True
EndFunc

Func cons($t)
	If Not $bDebug Then Return
	ConsoleWrite(@HOUR&':'&@MIN&':'&@SEC& ': ' & $t & @LF)
EndFunc

Func MY_WM_GETFOCUS($hwnd,$msg,$wParam,$lParam)
    Local $nNotifyCode = BitShift($wParam,16)
    Local $nID = BitAND($wParam,0xFFFF)
    Local $hCtrl = $lParam
    If $nID = 0 Then
		If $gWin Then removeGui()
    EndIf
EndFunc

Func mkIconFile($name)
	Local $iconFileName = @ScriptDir & '\' & $name & '.ico'
	If Not FileExists($iconFileName) Then
		Local $iconFile = '0x0000010001001010000001001800680300001600000028000000100000002000000001001800000000000000000000000000000000000000000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0F96502FA6803C0C0C0FB6B03FC6C06C0C0C0FF0000FF0000FF0000FF0000FF0000FF0000C0C0C0FF6E03C0C0C0C0C0C0F96401F96502C0C0C0FB6B03FE6A02C0C0C0FF0000FFFF00808000808000808000FF0000C0C0C0FA6803C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0FF0000FFFF00FFFF00FFFF00FFFF00FF0000C0C0C0F96502C0C0C0C0C0C0000080000080000080000080000080C0C0C0FF0000FF0000FF0000FF0000FF0000FF0000C0C0C0F66103C0C0C0C0C0C0000080FF00FF0000FF0000FF000080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000080FF00FF0000FF0000FF000080C0C0C0008080008080008080008080008080008080008080008080C0C0C0C0C0C0000080FF00FF0000FF0000FF000080C0C0C0008080FFFFFF00FFFF00FFFF00FFFF00FFFF00FFFF008080C0C0C0C0C0C0000080FF00FFFF00FFFF00FF000080C0C0C0008080FFFFFF00FFFF00FFFF00FFFF00FFFF00FFFF008080C0C0C0C0C0C0000080000080000080000080000080C0C0C0008080FFFFFF00FFFF00FFFF00FFFF00FFFF00FFFF008080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0008080FFFFFF00FFFF00FFFF00FFFF00FFFF00FFFF008080C0C0C0C0C0C0E95C00E95E00E95E00EA6101EA6101C0C0C0008080FFFFFF00FFFF00FFFF00FFFF00FFFF00FFFF008080C0C0C0C0C0C0E95C00E95E00E95E00EA6101EA6101C0C0C0008080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF008080C0C0C0C0C0C0E75E00E95E00EA6101EA6101EA6101C0C0C0008080008080008080008080008080008080008080008080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0DF5A00E45A00E75E00E96200E96200EB6501EB6501EB6501EB6501EB6501EB6501E96200E96200EA6101E95E00E75E0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
		Local $h = FileOpen($iconFileName,18)
		FileWrite($h,Binary($iconFile))
		FileClose($h)
	EndIf
EndFunc
