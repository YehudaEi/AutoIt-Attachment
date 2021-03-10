$version = "75a"




#include <array.au3>
 #include <file.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include 'PredictText.au3'

; this would be read from my dictonary
Dim $avArray [13] = ["crazy|baliw", "good|magandang", "morning|umaga", "kid|bata", "kids|mga bata", "good|mabait", "it's ok|okey lang", "i'm ok|okey lang ako", "money|kwarta", "to trick|atik", "eat|kain", "old|tiguwang", "flirty|igat"]
Dim $English_Filipino[1][3] 	; 1 row, 3 columns
Dim $DisplayEng_Filipino[1][4] 	; 1 row, 3 columns
Dim $SoundButton[1]
; would be read from my list or key words
Dim $Dictionary [13] =	["crazy", "good", "morning", "kid", "kids", "good", "it's ok", "i'm ok", "money", "to trick", "eat", "old", "flirty"]					; Dictonary for Auto Complete

$Language   = 0
$Toclear = True
$ToRank = True
$find_Any_Part_word = False
$LaungTxt = "Bisaya"
$find_Full_word = False
$find_Any_word = False
$PartAny = False
$trap = False
$BuildSentence = False
$TempToRank = False
$Drives = DriveGetDrive("ALL")
$DictionaryLanguage = "EnglishDict.txt"

if @Compiled then
	$Path = @ScriptDir & "\Audio\"
Else
	$Path = "H:\. My How To Docs\Coding\AutoIT Code\Bisaya\Audio\"
;	$Path = "D:\CD-Burn\Apps\Coding\AutoIT Code\Bisaya\Audio\"
EndIf



; _ArrayDisplay($CmdLine)
if ($CmdLine[0] > 0) and ($CmdLine[0] < 2) Then
   if StringLower($CmdLine[1]) ="tagalog" Then
	  $LaungTxt="Tagalog"
	  $sSrc = "Tagalog.txt"
   ElseIf StringLower($CmdLine[1]) ="bisayan" Then
	  $LaungTxt="Bisaya"
	  $sSrc = "Bisaya.txt"
   EndIf
Else
   Global $Form1 = GUICreate("", 233, 186)
;   Global $Button1 = GUICtrlCreateButton("Bisaya", 56, 16, 121, 41)
   Global $Button2 = GUICtrlCreateButton("Tagalog", 56, 72, 121, 41)
   Global $Button3 = GUICtrlCreateButton("Exit", 56, 128, 121, 41)

   GUISetState(@SW_SHOW)
   While 1
	  $nMsg = GUIGetMsg()
	  Switch $nMsg
		 Case $GUI_EVENT_CLOSE
			   Exit
;		 Case $Button1
;			   GUISetState(@SW_HIDE)
;			   $LaungTxt="Bisaya"
;			   $sSrc = "Bisaya.txt"
;			   ExitLoop
		 Case $Button2
			   GUISetState(@SW_HIDE)
			   $LaungTxt="Tagalog"
			   $sSrc = "Tagalog.txt"
			   ExitLoop
		 Case $Button3
			   Exit
	  EndSwitch
   WEnd
 EndIf


_Initilize($English_Filipino)   ;  reads database


; create the form
Global $Form1 = GUICreate("English to "& $LaungTxt& " 1." & $version & "      database size - "& UBound($avArray), 600, 420,-1,-1,$WS_MINIMIZEBOX + $WS_SIZEBOX), $Form2 = 999
GUICtrlSetResizing(-1, $GUI_DOCKLEFT)

; create input
Global $Input1 = GUICtrlCreateInput("", 16, 8, 323, 21)
Local $Edit_hWnd=GUICtrlGetHandle(-1)								; 75a  Preditcive text   This attaches to the     $Input1 = GUICtrlCreateInput("", 16, 8, 323, 21)   line above
GUICtrlSetFont(-1, 11, 400, 0, "Consolas")
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUISetState()

_InitilizeDict()													; Load English word list for PredictText


;----------------

; select font size
$hCombo = GUICtrlCreateCombo("10", 350, 8, 40, 20)
GUICtrlSetData(-1, "11|12|13|14|15|16|17|18|19|20")
GUICtrlSetResizing(-1, $GUI_DOCKALL)

; search & reload buttons
Global $Search = GUICtrlCreateButton("Search", 18, 38, 97, 33)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
Global $BuildButton = GUICtrlCreateButton("Build", 32, 75, 70, 25)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

Global $Reload = GUICtrlCreateButton("Reload", 400, 8, 55, 22)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

If $LaungTxt="Tagalog" Then
   Global $Restart = GUICtrlCreateButton("Bisayan", 400, 38, 55, 22)
   GUICtrlSetResizing(-1, $GUI_DOCKALL)
Else
   Global $Restart = GUICtrlCreateButton("Tagalog", 400, 38, 55, 22)
   GUICtrlSetResizing(-1, $GUI_DOCKALL)
EndIf

;Global $Restart = GUICtrlCreateButton("Restart", 400, 38, 55, 22)
;GUICtrlSetResizing(-1, $GUI_DOCKALL)
Global $Sound = GUICtrlCreateButton("Sound", 400, 65, 55, 22)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

$yy=36
; radio button for full or partial word search
GUIStartGroup()
Global $Radio3 = GUICtrlCreateRadio("Full", 135, $yy, 65, 18)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
Global $Radio4 = GUICtrlCreateRadio("Part Full", 135, $yy+16, 65, 18)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
Global $Radio6 = GUICtrlCreateRadio("Part Any", 135, $yy+32, 65, 18)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
Global $Radio5 = GUICtrlCreateRadio("Any", 135, $yy+48, 65, 18)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
Global $Group2 = GUICtrlCreateGroup("", 125, 26, 80, 80)
GUICtrlSetResizing(-1, $GUI_DOCKALL)


GUIStartGroup()
$Checkbox1 = GUICtrlCreateCheckbox("Clear", 224, 40, 57, 25)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$Checkbox2 = GUICtrlCreateCheckbox("Rank", 224, 59, 65, 25)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$Group3 = GUICtrlCreateGroup("", 216, 32, 81, 55)
GUICtrlSetResizing(-1, $GUI_DOCKALL)


; radio buttons for launage type to search on
GUIStartGroup()
Global $Radio1 = GUICtrlCreateRadio("English", 316, 40, 57, 25)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
Global $Radio2 = GUICtrlCreateRadio($LaungTxt, 316, 60, 57, 25)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
Global $Group1 = GUICtrlCreateGroup("", 308, 32, 81, 55)
GUICtrlSetResizing(-1, $GUI_DOCKALL)


; preset what is set as default
GUICtrlSetState($Checkbox1, $GUI_CHECKED)
GUICtrlSetState($Checkbox2, $GUI_CHECKED)
GUICtrlSetState($Radio1, $GUI_CHECKED)
GUICtrlSetState($Radio4, $GUI_CHECKED)
GUICtrlSetState($Sound, $GUI_DISABLE)

; creates output area with Consolas Font
$Edit1 = GUICtrlCreateEdit("", 16, 110, 570, 275)
GUICtrlSetFont(-1, 11, 400, 0, "Consolas")
GUICtrlSetData(-1, "")
GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)

GUISetState(@SW_SHOW)


$WordtoFind="try these words" & @CRLF & @CRLF & "crazy, good, morning, kid, kids, good, it's ok" & @CRLF & "i'm ok, money, to trick, eat, old, flirty"
_DisplayOutput ()


winsetontop("English to "& $LaungTxt,"",1)
While 1
	$nMsg = GUIGetMsg(1)
	Switch $nMsg[1]
		Case $Form1
			Switch $nMsg[0]
				Case $GUI_EVENT_CLOSE
					Exit
				Case $Sound
					GUISetState(@SW_DISABLE, $Form1)
					_Form2()

				Case $Radio1
					$DictionaryLanguage = "EnglishDict.txt"
					_InitilizeDict()
;					MsgBox(0,"","eng")

				Case $Radio2
					$DictionaryLanguage = $LaungTxt & "Dict.txt"
					 _InitilizeDict()
;					 MsgBox(0,"",$LaungTxt)

				Case $Search
					GUICtrlSetState($Sound, $GUI_DISABLE)
					$WordtoFind = StringStripWS ( StringLower (GUICtrlRead($Input1)),1)
					if $WordtoFind <> "" Then
						$WordtoFind = _StripString ($WordtoFind)
						If BitAnd(GUICtrlRead($Radio1),$GUI_CHECKED) Then
							$Language = 0
						Else
							$Language =1
						EndIf
						If BitAnd(GUICtrlRead($Radio3),$GUI_CHECKED) Then
							If $Toclear then Guictrlsetdata($Edit1,"")
							_Findfullword($English_Filipino,$WordtoFind)
							$find_Full_word = False
						ElseIf BitAnd(GUICtrlRead($Radio4),$GUI_CHECKED) Then
							If $Toclear then Guictrlsetdata($Edit1,"")
							$find_Any_Part_word = False
							_Findpartword($English_Filipino,$WordtoFind)
						ElseIf BitAnd(GUICtrlRead($Radio5),$GUI_CHECKED) Then
							If $Toclear then Guictrlsetdata($Edit1,"")
							$find_Any_Part_word = True
							_Findpartword($English_Filipino,$WordtoFind)
							$find_Any_Part_word = False
						ElseIf BitAnd(GUICtrlRead($Radio6),$GUI_CHECKED) Then
							If $Toclear then Guictrlsetdata($Edit1,"")
								$PartAny = True
								_Findfullword($English_Filipino,$WordtoFind)
;								$find_Full_word = False
								$PartAny = False
						EndIf
					EndIf
				Case $BuildButton
					If BitAnd(GUICtrlRead($Radio1),$GUI_CHECKED) Then
							$Language = 0
						Else
							$Language =1
					EndIf
					$WordtoFind = StringStripWS ( StringLower (GUICtrlRead($Input1)),1)
					If $WordtoFind <> "" Then
						GUICtrlSetState($Sound, $GUI_DISABLE)
						$WordtoFind = _StripString ($WordtoFind)
						If $Toclear then Guictrlsetdata($Edit1,"")
						$find_Full_word = True
						$BuildSentence = True
						$find_Any_Part_word = False
						_BuildSentence($English_Filipino, $WordtoFind)
					EndIf

				Case $Reload
					_Initilize($English_Filipino)
				Case $Checkbox1
					$Toclear = Not $Toclear
				Case $Checkbox2
					$ToRank = Not $ToRank
				Case $hCombo
					GUICtrlSetFont(-1,GUICtrlRead($hCombo), 400, 0, "Consolas")
				 Case $Restart
					 If $LaungTxt="Tagalog" then
						Run("English-Bisaya.exe Bisayan")
					 Else
						Run("English-Bisaya.exe Tagalog")
					 EndIf
					sleep(500)
					exit
			EndSwitch

			Case $Form2
				Switch $nMsg[0]
					Case $GUI_EVENT_CLOSE
						GUIDelete($Form2)
						GUISetState(@SW_ENABLE, $Form1)
						GUICtrlSetState($Sound, $GUI_DISABLE)
						WinActivate ("English to "& $LaungTxt,"")
					Case $SoundButton[1] To $SoundButton[$SoundButton[0]]
						For $_x = 1 To UBound($SoundButton)-1
							If ($nMsg[0] = $SoundButton[$_x]) Then
	;							msgbox(0,"",$Path & $LaungTxt &"\" & $DisplayEng_Filipino[$_x][3] & ".mp3")
								SoundPlay ($Path & $LaungTxt &"\" & $DisplayEng_Filipino[$_x][3] & ".mp3",1)
							EndIf
						Next
			EndSwitch
		EndSwitch
	WEnd

Func _Form2()														; audio buttons selection
    GUISetState(@SW_SHOW)
EndFunc


Func _Initilize(ByRef $English_Filipino)
	$xy = 0

;	if NOT FileExists ($sSrc) Then
;		MsgBox (0,"","Files does not exist")
;		Exit
;	EndIf
; 	_FileReadToArray($sSrc, $avArray)

	ReDim $English_Filipino[UBound($avArray)][3]
	$tt=TimerInit()
	For $xy = 0 To UBound($avArray) - 1													;  	build English and Filipino Arrays
		if StringRegExp ($avArray[$xy],"(.*)\|(.*)\|(.*)") Then							;	checks for 3  fields  	2 x |
			$StrReEx=StringRegExp ($avArray[$xy],"(.*)\|(.*)\|(.*)",1)
;			msgbox(0,"",$StReEx[0])
			$English_Filipino[$xy][0]=$StrReEx[0]
			$English_Filipino[$xy][1]=$StrReEx[1]
			$English_Filipino[$xy][2]=$StrReEx[2]

		ElseIf StringRegExp ($avArray[$xy],"(.*)\|(.*)") Then							;	checks for 2 fields		1 x |
			$StrReEx=StringRegExp ($avArray[$xy],"(.*)\|(.*)",1)
;			msgbox(0,"",$StReEx[0])
			$English_Filipino[$xy][0]=$StrReEx[0]
			$English_Filipino[$xy][1]=$StrReEx[1]
		EndIf
	Next
EndFunc

Func _InitilizeDict()
;	if NOT FileExists ($DictionaryLanguage) Then
;		MsgBox (0,"","Dictionary Files do not exist")
;		Exit
;	EndIf
;	_FileReadToArray($DictionaryLanguage, $Dictionary)									; Dictionarry for Autocomplete

	_RegisterPrediction($Edit_hWnd,$Dictionary,2,0)
EndFunc




Func _BuildSentence(byRef $English_Filipino, $WordtoFindX)
_DisplayOutput()
EndFunc


Func _Findfullword(ByRef $English_Filipino, $WordtoFindX)						; find partial string non Case
_DisplayOutput()
EndFunc


Func _Findpartword(ByRef $English_Filipino,$WordtoFind)
_DisplayOutput()
EndFunc



Func _DisplayOutput ()
	GUICtrlSetData($Edit1, $WordtoFind & @CRLF)
EndFunc

Func _StripString ($stringstrip)
		;
	;  use StrinRegExp   to strip   ,    '   ;   /   ( including inside )     [ includng inside ]
	;
	$stringstrip=StringRegExpReplace($stringstrip,"  "," ")												; strips any double spaces to a single space
	$stringstrip=StringRegExpReplace($stringstrip,"([{}\^$&._%#!@=<>:;,~`'\’\*\?\/\+\|\\\\]|\-)","")	; looks for   \^$&._%#!@=<>:;,~`'’*?\    and removes them,      but not ( [ ] )
	$stringstrip=StringRegExpReplace($stringstrip,"\(.*\)","")											; removes all information between  ( and )
	$stringstrip=StringRegExpReplace($stringstrip,"\[.*\]","")											; removes all information between  [ and ]

;	msgbox(0,"",$stringstrip)
Return StringStripWS ( $stringstrip, 2 )
EndFunc

Exit



