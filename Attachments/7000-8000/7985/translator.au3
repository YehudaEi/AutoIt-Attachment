#cs

Multilingual support. (translation tool for your scripts) by LibrE

Totaly freeware.
Only you have to add a little text in the credits of your program like “Translations done with help of Libre’s multilingual support”.
Enjoy it.

Version 0.1 --- NOW WITH PREVIEW MODE !!! 
Version 0.2 --- 11/4/2006 23:58--- Spacing Bug Fixed
Version 0.3 --- 12/4/2006 14:48--- Beautifulling and listview "|" char problem fixed.
Version 0.4 --- 14/4/2006 13:22--- Addings 10 variables more at the final of each script in the lang.lng for 
									manual use in emergency case ,showing the name of the script in each portion 
									of the file. look at the example file -> lang.lng
known bugs:
-Double quotes ""hi"" ----> someday i´ll fix it.

Notes:
-Copy your scripts to the translator folder and then run it.
-Dont use ¨ character in your scripts, i use it to make stringsplits, normaly nobody uses it, but u must to know.

#ce

#include <GUIConstants.au3>
#include <GuiListView.au3>
#include <File.au3>
#include <trans.au3>


Global $MinLen = 1
Global $VarCount = 1            ; Sets the number of the initial var found to translate.
Global $Separator = '"'
;Global $Separator = "'"
Global $NewProgram = "new.au3"
Global $NewLangFile = "Lang.lng"
Global $AddNewFile = 0            ;  To use for add various scripts to a same ini definition file
Global $aPreview
Global $ContPreview = 1
Global $PreviewMode = "on"


$GUI = GUICreate("Multilingual Support By Libre", 353, 143, 209, 156)
GUICtrlCreateLabel("Choose a File to Tanslate                             - thanks. Valuater ;)", 24, 8, 300, 17)
GUICtrlCreateLabel("New File", 24, 48, 45, 17)

$NFile = GUICtrlCreateInput(@ScriptDir, 24, 24, 305, 21, -1, $WS_EX_CLIENTEDGE)
$NLFile = GUICtrlCreateInput("New.au3", 24, 64, 81, 21, -1, $WS_EX_CLIENTEDGE)

$ButtonGetFile = GUICtrlCreateButton("&Add Script", 120, 64, 75, 25)
$ButtonTranslate = GUICtrlCreateButton("&Translate", 208, 64, 123, 25)
$Progress = GUICtrlCreateProgress(24, 96, 305, 25)
;GUICtrlSetState( -1, $GUI_HIDE)
GUISetState(@SW_SHOW)

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $ButtonGetFile
			$GFile = FileOpenDialog("au3 to translate", @ScriptDir, "Scripts (*.au3)")
			If $GFile <> "" Then
				GUICtrlSetData($NFile, $GFile)
			EndIf
		Case $msg = $ButtonTranslate
			$File = GUICtrlRead($NFile)
			If FileExists($File) And StringInStr($File, ".au3") <> 0 Then
				$NProg = GUICtrlRead($NLFile)
				$NewProgram = $File & "-" & $NProg
				ReadLines($File)
				
				If $PreviewMode = "on" Then
					$aPreview = GetLangArray ($NewLangFile)
					$aPreview = ShowVars($aPreview)
					If IsArray($aPreview) Then
						$PreviewMode = "off"
						$ContPreview = 1
						ReadLines($File)
						
						For $i = 0 To 9
							IniWrite($NewLangFile, "Data", $VarCount + $AddNewFile + $i, "¨" & "¨")
						Next
						IniWrite($NewLangFile, "Data", $VarCount + $AddNewFile + $i, "¨" & _
								">------------------------------/ Heres Ends /---------->" & StringTrimLeft($GFile, StringInStr($GFile, "\", 0, -1)) & "¨")
						
						$PreviewMode = "on"
						MsgBox(262208, "Great!", "Translation Complete   ", 2)
					EndIf
				Else
					
				EndIf
			Else
				MsgBox(262208, "Sorry!", "Please choose an Au3 File First   ", 3)
			EndIf
			FileDelete(@ScriptDir & "\tmp.txt")
			FileDelete(@ScriptDir & "\tmp.au3")
		Case Else
			;;;;;;;
	EndSelect
WEnd
Exit

Func ReadLines($File)
	Local $Line, $Cont, $aTmpSection
	
	If $PreviewMode = "on" Then
		$NewLangFile = "tmp.txt"
		$NewProgram = "tmp.au3"
		FileDelete(@ScriptDir & "\tmp.txt")
		FileDelete(@ScriptDir & "\tmp.au3")
	Else
		$NewLangFile = "Lang.lng"
		$NewProgram = $File & "-" & $NProg
	EndIf
	
	$aTmpSection = IniReadSection(@ScriptDir & "\" & $NewLangFile, "Data")
	If @error = 1 Then
		$AddNewFile = 0
		
		FileWriteLine($NewProgram,"#include <trans.au3>"&@CRLF&"Global $LANG = GetLangArray('"&$NewLangFile&"')")
	Else
		$AddNewFile = UBound($aTmpSection, 1) - 1    ; Set the number to add when the translate ini file exists.
		If MsgBox(4, "ini file exists", "Add to var from line " & $AddNewFile & "?   ") <> 6 Then Return
	EndIf
	GUICtrlSetState($ButtonTranslate, $GUI_HIDE)
	GUICtrlSetState($Progress, $GUI_SHOW)
	$Size = _FileCountLines ($File)
	$Cont = 1
	$VarCount = 1
	While 1
		$Line = FileReadLine($File, $Cont)
		If @error = -1 Then ExitLoop
		
		FileWriteLine($NewProgram, LookForStrings($Line))
		$Cont += 1
		GUICtrlSetData($Progress, 100 / $Size * $Cont)
	WEnd
	GUICtrlSetState($ButtonTranslate, $GUI_SHOW)
	GUICtrlSetState($Progress, $GUI_HIDE)
EndFunc   ;==>ReadLines

Func LookForStrings($Line)
	Local $Newline = $Line
	Local $TextLine
	Local $i = 2
	
	$TextLine = StringSplit($Line, $Separator)
	If @error <> 1 Then
		While $i < UBound($TextLine)
			If $TextLine[$i] <> "" And StringInStr($TextLine[$i], "\") = 0 And StringInStr($TextLine[$i], "/") = 0 And StringLen($TextLine[$i]) > $MinLen Then; "\" to deny the path strings - "/" start command and web addresses
				;MsgBox(0,"",$TextLine[$i])
				If StringInStr($TextLine[$i - 1], "HotKeySet") <> 0 Then
					$i += 4
					ContinueLoop
				EndIf
				
				If StringInStr($TextLine[$i - 1], "Opt(") <> 0 Or StringInStr($TextLine[$i - 1], "Call(") <> 0 Then
					$i += 2
					ContinueLoop
				EndIf
				
				If $PreviewMode = "on" Then
					$Newline = SaveVar($Newline, $TextLine[$i], $VarCount)
					$VarCount += 1
				Else
					;MsgBox(0,StringInStr($aPreview[$ContPreview],$TextLine[$i]),"-"&$aPreview[$ContPreview] & "-     -" &$TextLine[$i]&"-")
					If $aPreview[$ContPreview] = $TextLine[$i] Then
						$Newline = SaveVar($Newline, $TextLine[$i], $VarCount)
						$VarCount += 1
						$ContPreview += 1
					EndIf
				EndIf
				
			EndIf
			$i += 2
		WEnd
	EndIf
	
	If $Newline <> $Line Then
		$Newline &= ";" & $Line
	EndIf
	
	Return $Newline
EndFunc   ;==>LookForStrings

Func SaveVar($Newline, $VarToChange, $i)
	$Newline = StringReplace($Newline, $Separator & $VarToChange & $Separator, "$LANG[" & $i + $AddNewFile & "]")
	IniWrite($NewLangFile, "Data", $i + $AddNewFile, "¨" & $VarToChange & "¨")
	Return $Newline
EndFunc   ;==>SaveVar


Func ShowVars($aPreview)
	Local $aListitems[UBound($aPreview) ]
	
	$ChildWin = GUICreate("Deselect the variables you dont want to be changed", 500, 280, -1, -1, BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS), -1, $GUI)
	GUICtrlCreateGroup("", 10, 10, 483, 260)
	$ListViewVar = GUICtrlCreateListView("Variable       |Text", 20, 25, 460, 200)
	GUICtrlSendMsg($ListViewVar, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_CHECKBOXES, $LVS_EX_CHECKBOXES)
	_GUICtrlListViewSetColumnWidth ($ListViewVar, 1, 340)
	$ButtonRmk = GUICtrlCreateButton("Add Variables", 170, 245, 180, 20, 0)
	
	For $z = 1 To UBound($aPreview) - 1
		$aListitems[$z] = GUICtrlCreateListViewItem("$LANG" & $z & "|" & StringReplace($aPreview[$z], "|", "l"), $ListViewVar)
		_GUICtrlListViewSetCheckState ($ListViewVar, $z - 1)
	Next
	
	GUISetState(@SW_SHOW)
	
	While 1
		Sleep(25)
		$msg = GUIGetMsg(1)
		
		Select
			Case $msg[0] = $ButtonRmk
				$y = 0
				For $z = 1 To UBound($aPreview) - 1
					
					If Not _GUICtrlListViewGetCheckedState ($ListViewVar, $z - 1) Then
						_ArrayDelete ($aPreview, $z - $y)
						$y = $y + 1
					EndIf
				Next
				
				GUISwitch($ChildWin)
				GUIDelete()
				Return $aPreview
				
			Case $msg[0] = $GUI_EVENT_CLOSE
				If $msg[1] = $ChildWin Then
					GUISwitch($ChildWin)
					GUIDelete()
					ExitLoop
				EndIf
				
		EndSelect
	WEnd
	
EndFunc   ;==>ShowVars





