#NoTrayIcon
#include <GUIConstants.au3>
#include <Array.au3>
#include <String.au3>
#Include <GuiEdit.au3>
$Convert = GUICreate("Convert API VB to Autoit Function", 466, 333, -1, -1)
GUISetBkColor(0xB6D9FC)
$Label1 = GUICtrlCreateLabel("Visual Basic API to convert", 32, 8, 132, 17)
$Label2 = GUICtrlCreateLabel("Convet to Dll Func in Autoit", 32, 144, 133, 17)
$Edit1 = GUICtrlCreateEdit("", 16, 24, 433, 105)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x800000)
$Edit2 = GUICtrlCreateEdit("", 17, 160, 431, 121)
GUICtrlSetData(-1, "")
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x000080)
$Button1 = GUICtrlCreateButton("&Convert", 64, 296, 75, 25, 0)
GUICtrlSetTip(-1, "Convert to autoit")
GUICtrlSetCursor (-1, 0)
$Button2 = GUICtrlCreateButton("&Paste", 200, 296, 75, 25, 0)
GUICtrlSetTip(-1, "Paste API")
GUICtrlSetCursor (-1, 0)
$Button3 = GUICtrlCreateButton("&Copy", 336, 296, 75, 25, 0)
GUICtrlSetTip(-1, "Copy Autoit Function")
GUICtrlSetCursor (-1, 0)
GUISetState (@SW_SHOW)

_GUICtrlEditGetRECT ( $Edit1 )
$About = GUICtrlCreateMenuitem ("About", GUICtrlCreateContextMenu ())

Global $String, $FuncName, $Dll, $Func, $VarNums, $i, $VarReturn, $Data, $FuncParam, $DllParam, $n

GUICtrlSetData ($Edit1, StringReplace (IniRead ("API_TO_AU.ini", "Setting", "Input", ""), "|", @CRLF))

GUICtrlSetData ($Edit2, StringReplace (IniRead ("API_TO_AU.ini", "Setting", "Output", ""), "|", @CRLF))
;Set Example
If StringInStr(GUICtrlRead($Edit1), "Function") = 0 Then
	$Example = 'Declare Function WindowFromPoint Lib "user32"' & @CRLF & _
		'Alias "WindowFromPoint" (ByVal xPoint As Long, ByVal yPoint As Long) As Long'
	GUICtrlSetData($Edit1, $Example)
EndIf
_GUICtrlEditSetSel ($Edit1, 0, -1)
While 1
	$nMsg = GUIGetMsg ()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch

	Select
		Case $nMsg = $Button1
			$String = GUICtrlRead ($Edit1)
			If $String <> "" Then
				$FuncName = _StringWordNext($String, "Function", 1)
				$Dll = StringReplace (_StringWordNext($String, "Function", 3), '"', "")
				If StringRight ($Dll, 4) <> ".dll"  then $Dll = $Dll & ".dll" 
				If StringInStr ($String, "Alias") Then
					$Func = _StringWordNext($String, "Alias", 1)
				Else
					$Func = $FuncName
				EndIf
				$VarReturn = ConvertType(_StringWordNext($String, "Function", -1))
				$StrExt = StringTrimLeft($String, StringInStr($String, "(") - 1)
				$AsSplit = StringRegExp($StrExt, '[ ]([Aa]s)[ ]', 3)
				If Not @error Then
					$n = UBound($AsSplit) - 1
					If $n > 0 Then
						Dim $Var1[$n], $Var2[$n], $Var3[$n]
						For $i = 0 To $n - 1
							$Var1[$i] = StringRegExpReplace (_StringWordPrevious($StrExt, "As", 1, $i + 1), '[,)(]', "")
							$Var2[$i] = ConvertType(StringRegExpReplace (_StringWordNext($StrExt, "As", 1, $i + 1), '[,)(]', ""))
							$Var3[$i] = StringRegExpReplace (_StringWordPrevious($StrExt, "As", 2, $i + 1), '[,)(]', "")
						Next
					EndIf
				EndIf
				;_ArrayDisplay($Var1 & $Var2 & $Var3, "fd")
				
				
				;Glue data
				$Data = 'Func ' & $FuncName
				If $n <> 0 Then
					If $Var3[0] = "ByRef"  Then
						$FuncParam = "ByRef $" & $Var1[0]
					Else
						$FuncParam = "$" & $Var1[0]
					EndIf
					For $i = 1 To UBound ($Var1) - 1
						If $Var3[$i] = "ByRef"  Then
							$FuncParam = $FuncParam & ", ByRef $" & $Var1[$i]
						Else
							$FuncParam = $FuncParam & ", $" & $Var1[$i]
						EndIf
					Next
					$Data = $Data & "(" & $FuncParam & ")" & @CRLF
				Else
					$Data = $Data & "()" & @CRLF
				EndIf
				$Data = $Data & "	Global $Return" & @CRLF
				$Data = $Data & "	$Return = DllCall (" & '"' & $Dll & '", ' & '"' & $VarReturn & '", ' 
				If $n <> 0 Then
					$Data = $Data & '"' & $Func
				Else
					$Data = $Data & '"' & $Func & '"'
				EndIf
				If $n <> 0 Then
					$DllParam = ""
					For $i = 0 To UBound ($Var1) - 2
						$DllParam = $DllParam & ', ' & $Var2[$i] & ', $' & $Var1[$i]
					Next
					$DllParam = $DllParam & ', ' & $Var2[UBound ($Var1) - 1] & ', $' & $Var1[UBound ($Var1) - 1] & ')' & @CRLF
					$Data = $Data & $DllParam
				Else
					$Data = $Data & ')' & @CRLF
				EndIf
				If $n <> 0 Then
					If $Var2[UBound ($Var1) - 1] <> "str"  And $Var2[UBound ($Var1) - 2] = "str"  Then
						$Data = $Data & '	Return $Return[2]' & @CRLF
					Else
						$Data = $Data & '	Return $Return[0]' & @CRLF
					EndIf
				Else
					$Data = $Data & '	Return $Return[0]' & @CRLF
				EndIf
				$Data = $Data & 'EndFunc' 
				GUICtrlSetData ($Edit2, $Data)
				IniWrite ("API_TO_AU.ini", "Setting", "Input", StringReplace ($String, @CRLF, "|"))
				IniWrite ("API_TO_AU.ini", "Setting", "Output", StringReplace ($Data, @CRLF, "|"))
			EndIf
		Case $nMsg = $Button2
			If ClipGet () <> "" Then
				GUICtrlSetData ($Edit1, ClipGet ())
			EndIf
		Case $nMsg = $Button3
			If _GUICtrlEditGetSel ($Edit1) <> 0 Then
				ClipPut(_GUICtrlEditGetSel ($Edit1))
			Else
				ClipPut (GUICtrlRead ($Edit2))
			EndIf
		Case $nMsg = $About
			MsgBox (64, "Infomation", "Author: HelloMotorola")
		EndSelect
		
WEnd

Func _StringWordNext($Phrase, $Word, $Next = 1, $PhrasePos = 1)
	If StringRight ($Phrase, 1) <> " "  Then $Phrase = $Phrase & " " 
	$WordPos = StringInStr ($Phrase, $Word, 0, $PhrasePos)
	If $WordPos <> 0 Then
		$StringSearch = StringTrimLeft ($Phrase, $WordPos - 1)
		$Array = StringRegExp ($StringSearch, "\b(.*?)[ ]", 3)
		If Not @error Then
			If $Next > 0 Then
				If $Next < UBound ($Array) Then
					Return $Array[$Next]
				Else
					Return ""
				EndIf
			ElseIf $Next = 0 Then
				Return UBound ($Array) ;Return number word Next
			Else
				If $Next = -1 Then
					Return $Array[UBound ($Array) - 1] ;Return word last
				Else
					Return ""
				EndIf
			EndIf
		Else
			Return ""
		EndIf
	Else
		Return ""
	EndIf
EndFunc   ;==>_StringWordNext


Func _StringWordPrevious($Phrase, $Word, $Previous = 1, $PhrasePos = 1)
	If StringRight ($Phrase, 1) <> " "  Then $Phrase = $Phrase & " " 
	$WordPos = StringInStr ($Phrase, $Word, 0, $PhrasePos)
	If $WordPos <> 0 Then
		$StringSearch = StringLeft ($Phrase, $WordPos - 1)
		$Array = StringRegExp ($StringSearch, "\b(.*?)[ ]", 3)
		If Not @error Then
			$ArraySize = UBound ($Array)
			If $Previous > 0 Then
				If $Previous < $ArraySize + 1 Then
					Return $Array[$ArraySize - $Previous]
				Else
					Return ""
				EndIf
			ElseIf $Previous = 0 Then
				Return UBound ($Array) ;Return number word Previous
			Else
				If $Previous = -1 Then ;Return word first
					Return $Array[0]
				Else
					Return ""
				EndIf
			EndIf
		Else
			Return ""
		EndIf
	Else
		Return ""
	EndIf
EndFunc   ;==>_StringWordPrevious


Func ConvertType($Value)
	$TypeAu = ""
	$VBType = StringSplit ("long|RECT|OVERLAPPED|Boolean|String|Integer|any", "|"); Boolean = int
	$AutoitType = StringSplit ("int|ptr|ptr|str|str|int|ptr", "|")
	
	For $t = 1 To UBound ($VBType) - 1
		If $Value = $VBType[$t] Then
			$TypeAu = '"' & $AutoitType[$t] & '"'
			ExitLoop
		EndIf
	Next
	If $TypeAu = "" Then
		If FileExists("API Constants.au3") Then
			$File = FileOpen("API Constants.au3", 0)
			$FileRead = FileRead ($File)
			$Line = StringSplit($FileRead, @CRLF, 1)
				If StringLeft($Value, 1) = "_" Then $m = "1"
			If StringLeft($Value, 1) = "0" Then $m = "9"
			If StringLeft($Value, 1) = "1" Then $m = "20"
			If StringLeft($Value, 1) = "A" Then $m = "22"
			If StringLeft($Value, 1) = "B" Then $m = "1702"
			If StringLeft($Value, 1) = "C" Then $m = "2459"
			If StringLeft($Value, 1) = "D" Then $m = "7008"
			If StringLeft($Value, 1) = "E" Then $m = "13144"
			If StringLeft($Value, 1) = "F" Then $m = "16196"
			If StringLeft($Value, 1) = "G" Then $m = "17280"
			If StringLeft($Value, 1) = "H" Then $m = "17942"
			If StringLeft($Value, 1) = "I" Then $m = "18716"
			If StringLeft($Value, 1) = "J" Then $m = "21704"
			If StringLeft($Value, 1) = "K" Then $m = "22113"
			If StringLeft($Value, 1) = "L" Then $m = "22590"
			If StringLeft($Value, 1) = "M" Then $m = "24603"
			If StringLeft($Value, 1) = "N" Then $m = "29715"
			If StringLeft($Value, 1) = "O" Then $m = "31642"
			If StringLeft($Value, 1) = "P" Then $m = "32933"
			If StringLeft($Value, 1) = "Q" Then $m = "35517"
			If StringLeft($Value, 1) = "R" Then $m = "35773"
			If StringLeft($Value, 1) = "S" Then $m = "38180"
			If StringLeft($Value, 1) = "T" Then $m = "45185"
			If StringLeft($Value, 1) = "U" Then $m = "46863"
			If StringLeft($Value, 1) = "V" Then $m = "47354"
			If StringLeft($Value, 1) = "W" Then $m = "48017"
			If StringLeft($Value, 1) = "X" Then $m = "50288"
			If StringLeft($Value, 1) = "Y" Then $m = "50451"
			If StringLeft($Value, 1) = "Z" Then $m = "50452"
			If $m < UBound($Line) - 1 Then
				For $m = 1 To UBound($Line) - 1
					If StringInStr($Line[$m], "Const") Then
						If StringInStr(_StringWordNext($Line[$m], "Const", 1), $Value) Then
							If StringIsDigit(StringRight(_StringWordNext($Line[$m], "Const", 2), 1)) Then
								$TypeAu = '"' & _StringWordNext($Line[$m], "Const", 2) & '"'
								ExitLoop
							EndIf
							If StringInStr($Line[$m], '"', 0 , 2) <> 0 Then
								$NewValue = _StringBetween($Line[$m], '"', '"')
								$TypeAu = '"' & $NewValue[0] & '"'
								ExitLoop
							EndIf
							If StringInStr($Line[$m], 'BitOR') Then
								If StringInStr($Line[$m], '(') And StringInStr($Line[$m], ')') Then
									$NewValue = _StringBetween($Line[$m], '(', ')')
									$TypeAu = 'BitOR' & '(' & $NewValue[0] & ')'
									ExitLoop
								EndIf
							EndIf
							ExitLoop
						EndIf
					EndIf
				Next
			EndIf
		EndIf
	EndIf
	If $TypeAu = "" Then $TypeAu = '"' & $Value & '"'
	Return $TypeAu
EndFunc   ;==>ConvertType