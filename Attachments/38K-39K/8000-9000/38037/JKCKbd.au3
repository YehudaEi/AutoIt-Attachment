#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#Include <GuiListView.au3>
#Include <GuiStatusBar.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Dim $frmMain, $cboLang, $cboScript, $lblLang, $lblOut, $lblScript, $txtOut, $txtOutRO, $btnExit, $btnTogglePause, $btnCopy, $btnToggleEdit;, $sb
Dim $lblSB, $lblSB1, $lblSB2, $lblSB3
Dim $BtnToggleText, $CurrentLanguage, $CurrentScript, $WaitBetKeyStokes
Dim $lvKanji

Main()

func Main()
	Local $ScriptFiles = ListFiles("* - *.data")
	ShowGui($ScriptFiles)
EndFunc

;---------------------

func ShowGui($ScriptFiles)
	Local $JapaneseScripts = "Hiragana|Katagana"
	if StringInStr(StringLower($ScriptFiles), "|japanese - kanji.data")>0 Then
		$JapaneseScripts &= "|Kanji"
	EndIf
	Local $KoreanScripts = "Hangul"
	if StringInStr(StringLower($ScriptFiles), "|korean - hanja.data")>0 Then
		$KoreanScripts &= "|Hanja"
	EndIf

	$BtnToggleText = "Pause"
	$btnToggleEditText = "Editable"

	$WaitBetKeyStokes = RegRead("HKCU\software\typer", "KeyWait")
	if $WaitBetKeyStokes="" then $WaitBetKeyStokes=70

#Region START GUI section
	$frmMain = GUICreate("Typer", 429, 184, 280, 174, $WS_SIZEBOX)

	$btnCopy = GUICtrlCreateButton("&Copy", 380, 14, 48, 25)
	GUICtrlSetResizing(-1,$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKSIZE)
	$btnTogglePause = GUICtrlCreateButton($BtnToggleText, 380, 38, 48, 25)
	GUICtrlSetResizing(-1,$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKSIZE)
	$btnToggleEdit = GUICtrlCreateButton($btnToggleEditText, 380, 62, 48, 25)
	GUICtrlSetResizing(-1,$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKSIZE)

	$lblLang = GUICtrlCreateLabel("Language :", 24, 50, 58, 17)
	GUICtrlSetResizing(-1,$GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKSIZE)
	$cboLang = GUICtrlCreateCombo("", 24, 66, 137, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
	GUICtrlSetResizing(-1,$GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKSIZE)
	GUICtrlSetData(-1, "Japanese|Korean|Simplified Chinese", "Japanese")

	$lblScript = GUICtrlCreateLabel("Script :", 232, 50, 37, 17)
	GUICtrlSetResizing(-1,$GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKSIZE)
	$cboScript = GUICtrlCreateCombo("", 232, 66, 145, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
	GUICtrlSetResizing(-1,$GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKSIZE)
	GUICtrlSetData(-1, $JapaneseScripts, "Hiragana")

	$lblOut = GUICtrlCreateLabel("Out :", 24, 0, 31, 17)
	GUICtrlSetResizing(-1,$GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKSIZE)
	$txtOutRO = GUICtrlCreateLabel("", 24, 20, 350, 30, $SS_SUNKEN)
	GUICtrlSetResizing(-1,$GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKRIGHT+$GUI_DOCKBOTTOM)
	$txtOut = GUICtrlCreateEdit("", 24, 20, 350, 38)
	GUICtrlSetResizing(-1,$GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKRIGHT+$GUI_DOCKBOTTOM)
	GUICtrlSetState(-1, $GUI_HIDE)

;~	; removing the statusbar, found that it keeps crashing
;~ 	$sb = _GUICtrlStatusBar_Create($frmMain)
;~ 	Local $aParts[12] = [200, -1]
;~ 	_GUICtrlStatusBar_SetParts ($sb, $aParts)
;~ 	_GUICtrlStatusBar_SetSimple($sb, True)

	; build something that looks like a status bar
	$lblSB1 = GUICtrlCreateLabel("", 0, 146, 58, 18, $SS_ETCHEDFRAME)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT+$GUI_DOCKWIDTH)
	$lblSB2 = GUICtrlCreateLabel("", 56, 146, 96, 18, $SS_ETCHEDFRAME)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT+$GUI_DOCKWIDTH)
	$lblSB3 = GUICtrlCreateLabel("", 150, 146, 278, 18, $SS_ETCHEDFRAME)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKLEFT+$GUI_DOCKHEIGHT)
	$lblSB = GUICtrlCreateLabel("", 58, 148, 92, 14, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT+$GUI_DOCKWIDTH)

 	Local $txtHidden = GUICtrlCreateInput("", 6664, 128, 33, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))


	$lblTypingSpeed = GUICtrlCreateLabel("Wait Between Reading Keystrokes (ms) :", 120, 92, 197, 17)
	GUICtrlSetResizing(-1,$GUI_DOCKBOTTOM+$GUI_DOCKSIZE+$GUI_DOCKHCENTER)
	$sliWaitBetKeys = GUICtrlCreateSlider(112, 108, 241, 17)
	GUICtrlSetResizing(-1,$GUI_DOCKBOTTOM+$GUI_DOCKSIZE+$GUI_DOCKHCENTER)
	GUICtrlSetLimit(-1, 200, 10)
	GUICtrlSetData(-1, $WaitBetKeyStokes)
	$lblCurWait = GUICtrlCreateLabel($WaitBetKeyStokes, 216, 124, 22, 17)
	GUICtrlSetResizing(-1,$GUI_DOCKBOTTOM+$GUI_DOCKSIZE+$GUI_DOCKHCENTER)

	$btnExit = GUICtrlCreateButton("&Exit", 382, 108, 41, 17)
	GUICtrlSetResizing(-1,$GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKSIZE)

	GUISetState(@SW_SHOW)

#EndRegion END GUI section

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $btnExit
				RegWrite("HKCU\software\typer", "KeyWait", "REG_SZ", $WaitBetKeyStokes)
				Exit
			case $btnCopy
				if GUICtrlRead($btnToggleEdit)="Editable" Then
					ClipPut(GUICtrlRead($txtOutRO))
				Else
					ClipPut(GUICtrlRead($txtOut))
				EndIf
			case $btnToggleEdit
				if $btnToggleEditText = "Editable" Then
					$btnToggleEditText = "Read Only"
					GUICtrlSetData($btnToggleEdit, "Read Only")
					GUICtrlSetState($txtOutRO, $GUI_HIDE)
					GUICtrlSetState($txtOut, $GUI_SHOW)
					GUICtrlSetData($txtOutRO, GUICtrlRead($txtOut))
				Else
					$btnToggleEditText = "Editable"
					GUICtrlSetData($btnToggleEdit, "Editable")
					GUICtrlSetState($txtOut, $GUI_HIDE)
					GUICtrlSetState($txtOutRO, $GUI_SHOW)
					GUICtrlSetData($txtOut, GUICtrlRead($txtOutRO))
				EndIf
			case $btnTogglePause
				if $BtnToggleText = "Pause" Then
					$BtnToggleText = "&Start"
				Else
					$BtnToggleText = "Pause"
				EndIf
				GUICtrlSetData($btnTogglePause, $BtnToggleText)
			case $cboLang
				Local $CurLang = GUICtrlRead($cboLang)
				Switch $CurLang
					case "Korean"
						GUICtrlSetData($cboScript,"|")
						GUICtrlSetData($cboScript, $KoreanScripts, "Hangul")
					case "Simplified Chinese"
						GUICtrlSetData($cboScript,"|")
						GUICtrlSetData($cboScript, "Characters", "Characters")
					case else
						GUICtrlSetData($cboScript,"|")
						GUICtrlSetData($cboScript, $JapaneseScripts, "Hiragana")
				EndSwitch
				GUICtrlSetState($txtHidden, $GUI_FOCUS)
			case $cboScript
				GUICtrlSetState($txtHidden, $GUI_FOCUS)
			case $sliWaitBetKeys
				$WaitBetKeyStokes = GUICtrlRead($sliWaitBetKeys)
				GUICtrlSetData($lblCurWait, $WaitBetKeyStokes)
			case Else
				if $BtnToggleText = "Pause" Then
					ProcessKeyboard()
				EndIf
		EndSwitch
	WEnd
EndFunc

;---------------------

Func cboLang_Changed()
	Local $CurLang = GUICtrlRead($cboLang)
	if $CurLang = "Japanese" Or $CurLang = "Korean" Or $CurLang = "Simplified Chinese" Then
		$CurrentLanguage = $CurLang
	Else
		GUICtrlSetData($cboLang, "Japanese")
		$CurrentLanguage = "Japanese"
	EndIf
EndFunc

;---------------------

Func CharCodeFromConsPart($ConsonantPart, $bIsFirstPart)
	; 1- parse the sequence, generate a sequential array of matching Korean "letters"
	Local $CharSequence = ""
	; remove letters that can't be mapped, map the ones that can
	$ConsonantPart = StringReplace($ConsonantPart, "f", "")
	$ConsonantPart = StringReplace($ConsonantPart, "v", "")
	$ConsonantPart = StringReplace($ConsonantPart, "x", "")
	$ConsonantPart = StringReplace($ConsonantPart, "z", "")
	$ConsonantPart = StringReplace($ConsonantPart, "q", "k")
	$ConsonantPart = StringReplace($ConsonantPart, "dj", "ch")
	$ConsonantPart = StringReplace($ConsonantPart, "j", "ch")
	if StringLen($ConsonantPart)=0 and $bIsFirstPart Then
		$CharSequence=",ng"
	ElseIf StringLen($ConsonantPart)=0 and Not $bIsFirstPart Then
		Return 0
	EndIf
	for $i = 1 to StringLen($ConsonantPart)
		Switch StringMid($ConsonantPart, $i, 1)
			case "k"
				if $i < StringLen($ConsonantPart) Then
					if StringMid($ConsonantPart, $i+1, 1) = "h" Then
						$CharSequence &= ",kh"
						ExitLoop
					EndIf
				EndIf
				$CharSequence &= ",k"
			case "n"
				if $i < StringLen($ConsonantPart) Then
					if StringMid($ConsonantPart, $i+1, 1) = "g" Then
						$CharSequence &= ",ng"
						ExitLoop
					EndIf
				EndIf
				$CharSequence &= ",n"
			case "t", "d"
				if $i < StringLen($ConsonantPart) Then
					if StringMid($ConsonantPart, $i+1, 1) = "h" Then
						$CharSequence &= ",th"
						ExitLoop
					EndIf
				EndIf
				$CharSequence &= ",t"
			case "r", "l"
				$CharSequence &= ",r"
			case "m"
				$CharSequence &= ",m"
			case "p", "b"
				if $i < StringLen($ConsonantPart) Then
					if StringMid($ConsonantPart, $i+1, 1) = "h" Then
						$CharSequence &= ",ph"
						ExitLoop
					EndIf
				EndIf
				$CharSequence &= ",p"
			case "s"
				$CharSequence &= ",s"
			case "c"
				if $i < StringLen($ConsonantPart) Then
					if StringMid($ConsonantPart, $i+1, 1) = "h" Then
						if $i < StringLen($ConsonantPart) - 1 Then
							if StringMid($ConsonantPart, $i+1, 1) = "h" Then
								$CharSequence &= ",chh"
								ExitLoop
							EndIf
						EndIf
						$CharSequence &= ",ch"
						ExitLoop
					EndIf
				EndIf
			case "h"
				$CharSequence &= ",h"
		EndSwitch
	Next
	Local $ChrCode = -1
	if $CharSequence = "" Then Return $ChrCode
	$CharSequence = StringRight($CharSequence,StringLen($CharSequence)-1)
	if $bIsFirstPart Then
		Local $arKLetters = StringSplit($CharSequence, ",")
		for $i=1 to $arKLetters[0]
			Switch $arKLetters[$i]
				case "k"
					Switch $i
						case 1
							$ChrCode = 44032
						case 2
							$ChrCode = 44620	;kk
					EndSwitch
				case "n"
					$ChrCode = 45208
				case "t"
					Switch $i
						case 1
							$ChrCode = 45796
						case 2
							$ChrCode = 46384
					EndSwitch
				case "r"
					$ChrCode = 46972
				case "m"
					$ChrCode = 47560
				case "p"
					Switch $i
						case 1
							$ChrCode = 48148
						case 2
							$ChrCode = 48736
					EndSwitch
				case "s"
					Switch $i
						case 1
							$ChrCode = 49324
						case 2
							$ChrCode = 49912
					EndSwitch
				case "ng"
					$ChrCode = 50500
				case "ch"
					Switch $i
						case 1
							$ChrCode = 51088
						case 2
							$ChrCode = 51676
					EndSwitch
				case "chh"
					$ChrCode = 52264
				case "kh"
					$ChrCode = 52852
				case "th"
					$ChrCode = 53440
				case "ph"
					$ChrCode = 54028
				case "h"
					$ChrCode = 54616
			EndSwitch
		Next
	Else
		Switch $CharSequence
			case ""
				$ChrCode = 0
			case "k"
				$ChrCode = 1
			case "k,k"
				$ChrCode = 2
			case "k,s"
				$ChrCode = 3
			case "n"
				$ChrCode = 4
			case "n,ch"
				$ChrCode = 5
			case "n,h"
				$ChrCode = 6
			case "t"
				$ChrCode = 7
			case "r"
				$ChrCode = 8
			case "r,k"
				$ChrCode = 9
			case "r,m"
				$ChrCode = 10
			case "r,p"
				$ChrCode = 11
			case "r,s"
				$ChrCode = 12
			case "r,th"
				$ChrCode = 13
			case "r,ph"
				$ChrCode = 14
			case "r,h"
				$ChrCode = 15
			case "m"
				$ChrCode = 16
			case "p"
				$ChrCode = 17
			case "p,s"
				$ChrCode = 18
			case "s"
				$ChrCode = 19
			case "s,s"
				$ChrCode = 20
			case "ng"
				$ChrCode = 21
			case "ch"
				$ChrCode = 22
			case "kh"
				$ChrCode = 23
			case "th"
				$ChrCode = 24
			case "ph"
				$ChrCode = 25
			case "h"
				$ChrCode = 26
			case Else
				$ChrCode = -1
		EndSwitch
	EndIf
	Return $ChrCode
EndFunc

;---------------------

Func charCodeFromVowPart($VowelPart)
	Switch $VowelPart
		case "a"
			Return 0
		case "ai"
			Return 28
		case "ya"
			Return 56
		case "yai"
			Return 84
		case "eo"
			Return 112
		case "eoi"
			Return 140
		case "yeo"
			Return 168
		case "yeoi"
			Return 196
		case "o"
			Return 224
		case "oa"
			Return 252
		case "oai"
			Return 280
		case "oeo"
			Return 308
		case "yo"
			Return 336
		case "u"
			Return 364
		case "ueo"
			Return 392
		case "ueoi"
			Return 420
		case "ui"
			Return 448
		case "yu"
			Return 476
		case "eu"
			Return 504
		case "eui"
			Return 532
		case "i"
			Return 560
	EndSwitch
EndFunc

;---------------------

Func CharDecCode($RomanSyllable, $bShift)
	Local $Lang = GUICtrlRead($cboLang)
	Local $Vowels
	Local $Consonants
	Switch $Lang
		case "Japanese"
			$Vowels = "AIUEO"
			$Consonants = "KGSZTDNHBPMYRW"
			Switch StringLen($RomanSyllable)
				case 1
					Local $VowelOffset = StringInStr($Vowels, $RomanSyllable)
					if $VowelOffset > 0 Then
						if $bShift Then
							Return Dec(3040) + $VowelOffset + 1
						Else
							Return Dec(3040) + $VowelOffset
						EndIf
					EndIf
				case 2
					Local $First = StringLeft($RomanSyllable, 1)
					Local $Second = StringRight($RomanSyllable, 1)
					if $First=$Second Then
						Return $First
					EndIf
					Local $ConsonantOffset = StringInStr($Consonants, $First)
					Local $VowelOffset = StringInStr($Vowels, $Second)
					if $ConsonantOffset = 0 or $VowelOffset = 0 Then
						return 0
					Else
						Switch $First
							case "K"
								Return dec("304B") + ($VowelOffset - 1) * 2
							case "G"
								Return dec("304C") + ($VowelOffset - 1) * 2
							case "S"
								Return dec("3055") + ($VowelOffset - 1) * 2
							case "Z"
								Return dec("3056") + ($VowelOffset - 1) * 2
							case "T"
								Return dec("305F") + ($VowelOffset - 1) * 2
							case "D"
								Return dec("3060") + ($VowelOffset - 1) * 2
							case "N"
								Return dec("306A") + $VowelOffset - 1
							case "H"
								Return dec("306F") + ($VowelOffset - 1) * 3
							case "B"
								Return dec("3070") + ($VowelOffset - 1) * 3
							case "P"
								Return dec("3071") + ($VowelOffset - 1) * 3
							case "M"
								Return dec("307E") + $VowelOffset - 1
							case "M"
								Return dec("307E") + $VowelOffset - 1
							case "Y"
								$VowelOffset = StringInStr("aAuUoO", $Second)
								Return dec("307E") + $VowelOffset - 1	; ya Ya yu Yu yo Yo
							case "R"
								Return dec("3089") + $VowelOffset - 1
							case "W"
								$VowelOffset = StringInStr("aAIEO", $Second)
								Return dec("308E") + $VowelOffset - 1	; wa Wa wi we wo
							case "V"
								Return dec("3094") ; vu
						EndSwitch
					EndIf
				case Else
			EndSwitch
		case Else
			Return 0
	EndSwitch
EndFunc

;---------------------

Func GetKeyboardState_Wrapper()
	Local $aDllRet, $lpKeyState = DllStructCreate("byte[256]")
	$aDllRet = DllCall("User32.dll", "int", "GetKeyboardState", "ptr", DllStructGetPtr($lpKeyState))
	If @error Then Return SetError(@error, 0, 0)
	If $aDllRet[0] = 0 Then
		Return SetError(1, 0, 0)
	Else
		Local $aReturn[256]
		For $i = 1 To 256
			$aReturn[$i - 1] = DllStructGetData($lpKeyState, 1, $i)
		Next
		Return $aReturn
	EndIf
EndFunc

;---------------------

Func GetPosOfFirstSearchChar($Search, $Find)
	Local $OldPos = 0
	Local $NewPos
	for $iFind=1 to StringLen($Find)
		$NewPos = StringInStr($Search, StringMid($Find, $iFind, 1))
		if $NewPos > 0 Then
			if $OldPos = 0 Then
				$OldPos = $NewPos
			ElseIf $NewPos < $OldPos Then
				$OldPos = $NewPos
			EndIf
		EndIf
	Next
	Return $OldPos
EndFunc

;---------------------

Func GetPosOfLastSearchChar($Search, $Find)
	Local $OldPos = 0
	Local $NewPos
	for $iFind=1 to StringLen($Find)
		$NewPos = StringInStr($Search, StringMid($Find, $iFind, 1))
		if $NewPos > 0 Then
			if $OldPos = 0 Then
				$OldPos = $NewPos
			ElseIf $NewPos > $OldPos Then
				$OldPos = $NewPos
			EndIf
		EndIf
	Next
	Return $OldPos
EndFunc

;---------------------

Func ListFiles($Filter)
	Local $bDone = False
	Local $Search = FileFindFirstFile($Filter)
	if $Search = -1 then Return ""
	Local $Ret
	while Not $bDone
		$Ret &= "|" & FileFindNextFile($Search)
		$bDone = @error <> 0
	WEnd
	return $Ret
EndFunc

;---------------------

Func ProcessCharInfo($bShift)
	Local $ScriptName = GUICtrlRead($cboScript)
	Switch $ScriptName
		case "Hiragana"
			Local $CurOut
			if GUICtrlRead($btnToggleEdit)="Editable" Then
				$CurOut = GUICtrlRead($txtOutRO)
			Else
				$CurOut = GUICtrlRead($txtOut)
			EndIf
			Local $CurNewRoman = GUICtrlRead($lblSB);_GUICtrlStatusBar_GetText($sb, 0)
			Local $CurNewHiragana = CharDecCode($CurNewRoman, $bShift)
			if Not IsNumber($CurNewHiragana) Then
				GUICtrlSetData($lblSB, $CurNewHiragana)
				;_GUICtrlStatusBar_SetText($sb, $CurNewHiragana, 0)
				Return
			EndIf
			$CurOut &= chrw($CurNewHiragana)
			if $CurNewHiragana <> 0 Then
				GUICtrlSetData($lblSB, "")
				;_GUICtrlStatusBar_SetText($sb, "", 0)
				GUICtrlSetData($txtOutRO, $CurOut)
				GUICtrlSetData($txtOut, $CurOut)
			EndIf
		case "Katagana"
			Local $CurOut
			if GUICtrlRead($btnToggleEdit)="Editable" Then
				$CurOut = GUICtrlRead($txtOutRO)
			Else
				$CurOut = GUICtrlRead($txtOut)
			EndIf
			Local $CurNewRoman = GUICtrlRead($lblSB);_GUICtrlStatusBar_GetText($sb, 0)
			Local $CurNewHiragana = CharDecCode($CurNewRoman, $bShift)
			if Not IsNumber($CurNewHiragana) Then
				GUICtrlSetData($lblSB, $CurNewHiragana)
				;_GUICtrlStatusBar_SetText($sb, $CurNewHiragana, 0)
				Return
			EndIf
			if $CurNewHiragana <> 0 Then
				$CurNewHiragana += 96 ;offset for katagana
			EndIf
			$CurOut &= chrw($CurNewHiragana)

			if $CurNewHiragana <> 0 Then
				GUICtrlSetData($lblSB, "")
				;_GUICtrlStatusBar_SetText($sb, "", 0)
				GUICtrlSetData($txtOutRO, $CurOut)
				GUICtrlSetData($txtOut, $CurOut)
			EndIf
		case "Kanji","Hangul"
		case Else
			GUICtrlSetData($cboScript, "Hiragana")
	EndSwitch
EndFunc

;---------------------

Func ProcessCharacters($UserInput)
	Local $Lang = GUICtrlRead($cboLang)
	Local $Script = GUICtrlRead($cboScript)
	Switch $Script
		case "Hangul"
			Local $Vowels="aeiouyw"
			$UserInput = StringLower($UserInput)
			Local $FirstVowelPos = GetPosOfFirstSearchChar($UserInput, $Vowels)
			if $FirstVowelPos = 0 Then
				Return 0	; no vowel sound, can't be, time to quit on this one
			EndIf
			Local $FirstConsonantPart = StringLeft($UserInput, $FirstVowelPos - 1)
			Local $SyllableWoutFirstConspart = StringRight($UserInput, StringLen($UserInput) - $FirstVowelPos + 1)
			Local $LastVowelPos = GetPosOfLastSearchChar($UserInput, $Vowels)
			Local $VowelPart = StringMid($UserInput, $FirstVowelPos, $LastVowelPos - $FirstVowelPos + 1)
			Local $LastConsonantPart = StringRight($UserInput, StringLen($UserInput) - $LastVowelPos)
			Local $CharCode = CharCodeFromConsPart($FirstConsonantPart, True)
			$CharCode += charCodeFromVowPart($VowelPart)
			$CharCode += CharCodeFromConsPart($LastConsonantPart, False)
			Local $sOut
			if GUICtrlRead($btnToggleEdit)="Editable" Then
				$sOut = GUICtrlRead($txtOutRO)
			Else
				$sOut = GUICtrlRead($txtOut)
			EndIf
			$sOut &= ChrW($CharCode)
			GUICtrlSetData($txtOutRO, $sOut)
			GUICtrlSetData($txtOut, $sOut)
		case "Hanja"
			if not FileExists(@ScriptDir & "\" & $Lang & " - " & $Script & ".data") Then
				MsgBox(0,"","file not found: " & @ScriptDir & "\" & $Lang & " - " & $Script & ".data")
				Return
			EndIf
			Local $Contents = FileRead(@ScriptDir & "\" & $Lang & " - " & $Script & ".data")
			if StringLen($Contents)>0 Then
				GUISetState(@SW_DISABLE, $frmMain)
				$Contents = @CRLF & $Contents
				if StringInStr($Contents, @CRLF & "Sound " & $UserInput & @CRLF)>0 Then
					Local $ContentsForInput = StringRight($Contents, StringLen($Contents) - StringInStr($Contents, @CRLF & "Sound " & $UserInput & @CRLF) - 10)
					if StringInStr($ContentsForInput, @CRLF & "Sound ")>0 Then
						$ContentsForInput = StringLeft($ContentsForInput, StringInStr($ContentsForInput, @CRLF & "Sound "))
					EndIf
					Local $arLines = StringSplit($ContentsForInput, @CRLF, 1)
					if $arLines[0]>0 Then
						Local $HanjaChars[$arLines[0]+1]
						Local $HanjaCodes[$arLines[0]+1]
						Local $HanjaInfo[$arLines[0]+1]
						Local $HanjaExamples[$arLines[0]+1]
						$HanjaChars[0] = $arLines[0]
						$HanjaCodes[0] = $arLines[0]
						$HanjaInfo[0] = $arLines[0]
						$HanjaExamples[0] = $arLines[0]
						for $i=1 to $arLines[0]
							if StringLen($arLines[$i])>0 Then
								if StringInStr($arLines[$i], @TAB)>0 Then
									Local $arTokens = StringSplit($arLines[$i], @TAB)
									if $arTokens[0]>1 Then
										$HanjaChars[$i]=$arTokens[1]
										if $arTokens[0]>1 Then
											$HanjaCodes[$i]=$arTokens[2]
											if $arTokens[0]>2 Then
												$HanjaInfo[$i]=$arTokens[3]
												if $arTokens[0]>3 Then
													$HanjaExamples[$i]=$arTokens[4]
												EndIf
											EndIf
										EndIf
									EndIf
								EndIf
							EndIf
						Next
						ShowCharList($HanjaChars, $HanjaCodes, $HanjaInfo, $HanjaExamples, $UserInput)
					EndIf
				EndIf
			EndIf
		case "Kanji"
			if not FileExists(@ScriptDir & "\" & $Lang & " - " & $Script & ".data") Then
				MsgBox(0,"","file not found: " & @ScriptDir & "\" & $Lang & " - " & $Script & ".data")
				Return
			EndIf
			Local $Contents = FileRead(@ScriptDir & "\" & $Lang & " - " & $Script & ".data")
			if StringLen($Contents)>0 Then
				GUISetState(@SW_DISABLE, $frmMain)
				$Contents = @CRLF & $Contents
				if StringInStr($Contents, @CRLF & "Sound " & $UserInput & @CRLF)>0 Then
					Local $ContentsForInput = StringRight($Contents, StringLen($Contents) - StringInStr($Contents, @CRLF & "Sound " & $UserInput & @CRLF) - 10)
					if StringInStr($ContentsForInput, @CRLF & "Sound ")>0 Then
						$ContentsForInput = StringLeft($ContentsForInput, StringInStr($ContentsForInput, @CRLF & "Sound "))
					EndIf
					Local $arLines = StringSplit($ContentsForInput, @CRLF, 1)
					if $arLines[0]>0 Then
						Local $KanjiChars[$arLines[0]+1]
						Local $KanjiCodes[$arLines[0]+1]
						Local $KanjiInfo[$arLines[0]+1]
						Local $KanjiExamples[$arLines[0]+1]
						$KanjiChars[0] = $arLines[0]
						$KanjiCodes[0] = $arLines[0]
						$KanjiInfo[0] = $arLines[0]
						$KanjiExamples[0] = $arLines[0]
						for $i=1 to $arLines[0]
							if StringLen($arLines[$i])>0 Then
								if StringInStr($arLines[$i], @TAB)>0 Then
									Local $arTokens = StringSplit($arLines[$i], @TAB)
									if $arTokens[0]>1 Then
										$KanjiChars[$i]=$arTokens[1]
										if $arTokens[0]>1 Then
											$KanjiCodes[$i]=$arTokens[2]
											if $arTokens[0]>2 Then
												$KanjiInfo[$i]=$arTokens[3]
												if $arTokens[0]>3 Then
													$KanjiExamples[$i]=$arTokens[4]
												EndIf
											EndIf
										EndIf
									EndIf
								EndIf
							EndIf
						Next
						ShowCharList($KanjiChars, $KanjiCodes, $KanjiInfo, $KanjiExamples, $UserInput)
					EndIf
				EndIf
			EndIf
	EndSwitch
EndFunc

;---------------------

Func ProcessKeyboard()
	Local $aKeyboardState = GetKeyboardState_Wrapper()
	Local $bShift = $aKeyboardState[16] > 127
	Local $bBkSp = $aKeyboardState[8] > 127
	Local $bDel = $aKeyboardState[46] > 127
	Local $bSpace = $aKeyboardState[32] > 127
	Local $bF2Pressed = $aKeyboardState[113] > 127
	Local $CurrentCharInfo = GUICtrlRead($lblSB);_GUICtrlStatusBar_GetText($sb, 0)
	; handle backspace and delete keystrokes
	if $bBkSp Or $bDel Then
		if StringLen($CurrentCharInfo) > 0 Then
			$CurrentCharInfo = StringLeft($CurrentCharInfo, StringLen($CurrentCharInfo)-1)
			GUICtrlSetData($lblSB, $CurrentCharInfo)
		Else
			Local $strOut
			if GUICtrlRead($btnToggleEdit)="Editable" Then
				$strOut = GUICtrlRead($txtOutRO)
			Else
				$strOut = GUICtrlRead($txtOut)
			EndIf
			if StringLen($strOut)>0 Then
				GUICtrlSetData($txtOutRO, StringLeft($strOut, StringLen($strOut) - 1))
				GUICtrlSetData($txtOut, StringLeft($strOut, StringLen($strOut) - 1))
				Return
			EndIf
		EndIf
		Sleep($WaitBetKeyStokes)
		Return
	EndIf
	; handle space keystroke
	if $bSpace Then
		GUICtrlSetData($txtOutRO, $CurrentCharInfo & " ")
		GUICtrlSetData($txtOut, $CurrentCharInfo & " ")
		Return
	EndIf

	Local $CurScript = GUICtrlRead($cboScript)
	Switch $CurScript
		case "Hiragana", "Katagana"
			; the array $aKeyboardState has one entry per letter in a-z A-Z, look for it and from it build a syllable that will then be converted
			For $i = 65 To 90
				if BitAND($aKeyboardState[$i], 0xF0) > 0 Then
					$CurrentCharInfo &= Chr($i)
					GUICtrlSetData($lblSB, $CurrentCharInfo); let the user know what has been received so far
					ProcessCharInfo($bShift); if the syllable is complete, convert to hiragana or katagana
					ExitLoop
				EndIf
			Next
		case "Hangul"
			if $bF2Pressed Then
				Local $UserInput = GUICtrlRead($lblSB)
				ProcessCharacters($UserInput)
				GUICtrlSetData($lblSB,"")
				Return
			else
				For $i = 65 To 90
					if BitAND($aKeyboardState[$i], 0xF0) > 0 Then
						$CurrentCharInfo &= Chr($i)
						GUICtrlSetData($lblSB,$CurrentCharInfo)
						ExitLoop
					EndIf
				Next
			EndIf
		case "Kanji", "Hanja", "Characters"
			if $bF2Pressed Then
				Local $UserInput = GUICtrlRead($lblSB)
				ProcessCharacters($UserInput)
				GUICtrlSetData($lblSB, "")
				Return
			else
				For $i = 65 To 90
					if BitAND($aKeyboardState[$i], 0xF0) > 0 Then
						$CurrentCharInfo &= Chr($i)
						GUICtrlSetData($lblSB, $CurrentCharInfo)
						ExitLoop
					EndIf
				Next

			EndIf

	EndSwitch
	Sleep($WaitBetKeyStokes)
EndFunc

;----------------------------------

Func ShowCharList($arKanjiChars, $arKanjiCodes, $arKanjiInfo, $arKanjiExamples, $Sound)
	Local $frmCharacters = GUICreate("Character List - '" & $Sound & "'", 413, 258, 302, 218, $WS_SIZEBOX)
	$lvKanji = GUICtrlCreateListView("Kanji|Meanings|Examples", 4, 4, 408, 194)
	GUICtrlSetResizing(-1, $GUI_DOCKAUTO)
	GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 50)
	GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 150)
	GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 250)
	Local $lvItem
	for $i=1 to $arKanjiChars[0]
		if StringLen($arKanjiChars[$i])>0 Then
			Local $ItemInfo = $arKanjiChars[$i] & "|"
			$ItemInfo &= $arKanjiInfo[$i] & "|"
			$ItemInfo &= $arKanjiExamples[$i]
			$lvItem = GUICtrlCreateListViewItem($ItemInfo, $lvKanji)
		EndIf
	Next

	Local $btnOKKanji = GUICtrlCreateButton("OK", 338, 206, 65, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKSIZE)
	Local $btnCancelKanji = GUICtrlCreateButton("Cancel", 242, 206, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKSIZE)
	GUISetState(@SW_SHOW)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUISetState(@SW_ENABLE, $frmMain)
				GUIDelete($frmCharacters)
				ExitLoop
			case $btnCancelKanji
				GUISetState(@SW_ENABLE, $frmMain)
				GUIDelete($frmCharacters)
				ExitLoop
			case $btnOKKanji
				Local $sOut
				if GUICtrlRead($btnToggleEdit)="Editable" Then
					$sOut = GUICtrlRead($txtOutRO)
				Else
					$sOut = GUICtrlRead($txtOut)
				EndIf
				$sOut &=  _GUICtrlListView_GetItemText($lvKanji, _GUICtrlListView_GetNextItem($lvKanji), 0)
				GUICtrlSetData($txtOutRO, $sOut)
				GUICtrlSetData($txtOut, $sOut)
				GUISetState(@SW_ENABLE, $frmMain)
				GUIDelete($frmCharacters)
				ExitLoop
		EndSwitch
	WEnd
EndFunc

;---------------------

