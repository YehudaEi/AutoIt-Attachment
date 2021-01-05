#include <GUIConstants.au3>

Opt("TrayIconDebug", 1)

HotKeySet("{Esc}", "CloseCalc")
HotKeySet("{NUMPADMULT}","MultKey")
HotKeySet("{NUMPADDIV}", "DivKey")
HotKeySet("{NUMPADADD}", "AddKey")
HotKeySet("{NUMPADSUB}", "SubKey")
HotKeySet("{DELETE}", "DeleteKey")
HotKeySet("{ENTER}", "EnterKey")

Global $mem[9]

GUICreate ("Calculator", 335, 210)
;GUIDefaultFont(8, 400, "MS Sans Serif") 
$dispold = GUICtrlCreateInput("0", 30, 5, 150, 16, BitOr($ES_RIGHT, $ES_READONLY), $WS_EX_STATICEDGE)
$display = GUICtrlCreateInput("0", 30, 25, 150, 16, BitOr($ES_RIGHT, $ES_WANTRETURN), $WS_EX_STATICEDGE)
GUICtrlSetState(-1, 256)

$bs =  GUICtrlCreateButton("+/-",45, 175, 30, 25)
$bd =  GUICtrlCreateButton(",", 80, 175, 30, 25)
$b0 =  GUICtrlCreateButton("0",  10, 175, 30, 25)
$b1 =  GUICtrlCreateButton("1",  10, 145, 30, 25)
$b2 =  GUICtrlCreateButton("2",  45, 145, 30, 25)
$b3 =  GUICtrlCreateButton("3",  80, 145, 30, 25)
$b4 =  GUICtrlCreateButton("4",  10, 115, 30, 25)
$b5 =  GUICtrlCreateButton("5",  45, 115, 30, 25)
$b6 =  GUICtrlCreateButton("6",  80, 115, 30, 25)
$b7 =  GUICtrlCreateButton("7",  10, 85, 30, 25)
$b8 =  GUICtrlCreateButton("8",  45, 85, 30, 25)
$b9 =  GUICtrlCreateButton("9",  80, 85, 30, 25)

$bdiv =   GUICtrlCreateButton("/", 115, 85, 30, 25)
$bmult =  GUICtrlCreateButton("*", 115, 115, 30, 25)
$bminus = GUICtrlCreateButton("–", 115, 145, 30, 25)
$bplus =  GUICtrlCreateButton("+", 115, 175, 30, 25)
$bsqrt =   GUICtrlCreateButton("sqrt", 150, 85, 30, 25)
$bsquare = GUICtrlCreateButton("x^2", 150, 115, 30, 25)
$bdivx =   GUICtrlCreateButton("1/x",  150, 145, 30, 25)
$bequal =  GUICtrlCreateButton("=",  150, 175, 30, 25)

$bcorrl =  GUICtrlCreateButton("<<",  80, 50, 30, 25)
$bcorr =  GUICtrlCreateButton("CE",  115, 50, 30, 25)
$bclear =  GUICtrlCreateButton("C",  150, 50, 30, 25)

$actind = GUICtrlCreateLabel("", 10, 15, 16, 16, $ES_CENTER, $WS_EX_STATICEDGE)

$memlist = GUICtrlCreateList("",  225, 82, 100, 130, 0, $WS_EX_STATICEDGE)
$bmemred =  GUICtrlCreateButton("MR",  190, 85, 30, 25)
$bmemadd =  GUICtrlCreateButton("M+", 190, 115, 30, 25)
$bmemchg =  GUICtrlCreateButton("MS",  190, 145, 30, 25)
$bmemclr =  GUICtrlCreateButton("MC",  190, 175, 30, 25)

$loglist = GUICtrlCreateEdit("",  190, 5, 135, 70, 0, $WS_EX_STATICEDGE)

GUISetState()
SetList(0)

While 1
    Sleep(1)
    $iResult=GUIGetMsg ()
    $curstr = GUICtrlRead($display)
    $oldstr = GUICtrlRead($dispold)
    Select
        Case ($iResult = $bclear)
            Display(0)
        Case ($iResult = -3)
            Exit
        Case ($iResult = $bmemchg)
            $index = GUICtrlSendMsg($memlist, 0x019F, 0, 0)
            $mem[$index] = GUICtrlRead($display)
            If $mem[$index] = 0 Then $mem[$index] = GUICtrlRead($dispold)
            SetList($index)
        Case ($iResult = $bmemclr)
            $index = GUICtrlSendMsg($memlist, 0x019F, 0, 0)
            $mem[$index] = 0
            SetList($index)
        Case ($iResult = $bmemadd)
            $index = GUICtrlSendMsg($memlist, 0x019F, 0, 0)
            $mem[$index] = $mem[$index] + GUICtrlRead($display)
            If $mem[$index] = 0 Then $mem[$index] = $mem[$index] + GUICtrlRead($dispold)
            SetList($index)
        Case ($iResult = $bmemred)
            $index = GUICtrlSendMsg($memlist, 0x019F, 0, 0)
            GUICtrlSetData($display, $mem[$index])
        Case ($iResult = $b0)
            If not ($curstr == "0") Then GUICtrlSetData($display, $curstr & "0")
        Case ($iResult >= $b1) and ($iResult <= $b9)
            $curstr = $curstr & ($iResult - 7)
            GUICtrlSetData($display, CheckLeadZero ($curstr))
        Case ($iResult = $bcorr)
            GUICtrlSetData($display, 0)
        Case ($iResult = $bcorrl)
            GUICtrlSetData($display, StringTrimRight($curstr, 1))
            If StringLen($curstr) = 1 Then GUICtrlSetData($display, 0)
        Case ($iResult = $bd)
            If not StringInStr($curstr, ".") Then GUICtrlSetData($display, $curstr & ".")
        Case ($iResult = $bdivx)
            If GUICtrlRead($display) = 0 Then $curstr = GUICtrlRead($dispold)
            Display(1/Number($curstr))
        Case ($iResult = $bsquare)
            If GUICtrlRead($display) = 0 Then $curstr = GUICtrlRead($dispold)
            Display(Number($curstr)^2)
        Case ($iResult = $bsqrt)
            If GUICtrlRead($display) = 0 Then $curstr = GUICtrlRead($dispold)
            Display(Sqrt(Number($curstr)))
        Case ($iResult = $bs)
            If $curstr == "0" then ContinueLoop;
            If StringLeft($curstr, 1) == "-" Then
                GUICtrlSetData($display, StringTrimLeft($curstr, 1))
            Else
                GUICtrlSetData($display, "-" & $curstr)
            Endif
        Case ($iResult >= $bdiv) and ($iResult <= $bplus)
            If GUICtrlRead($actind) == "" Then
                If GUICtrlRead($display) <> 0 Then Display($curstr)
            Else
                Evaluate()
            Endif
            GUICtrlSetData ($actind, StringMid("/*-+", $iResult-16, 1))
        Case ($iResult >= $bequal)
            EnterKey()
    EndSelect
Wend

Func Evaluate ()
    $pnum = Number(GUICtrlRead($dispold))
    $cnum = Number(GUICtrlRead($display))
    $action = GUICtrlRead($actind)
    Select
        Case $action = "/"
            $nResult = $pnum / $cnum
        Case $action = "*"
            $nResult = $pnum * $cnum                   
        Case $action = "-"
            $nResult = $pnum - $cnum                   
        Case $action = "+"
            $nResult = $pnum + $cnum
    EndSelect
    Display($nResult)
EndFunc

Func CheckLeadZero ($str)
    If (StringLeft($curstr, 1) == "0") Then
        If (StringMid($curstr, 2, 1) == ".") Then Return($str)
        If (StringLen($curstr) > 1) Then Return(StringTrimLeft($curstr, 1))
    Endif
    Return($str)
EndFunc

Func Display ($str)
    GUICtrlSetData($dispold, $str)
    GUICtrlSetData($display, 0)
    GUICtrlSetData($actind, "")
EndFunc

Func SetList($idx)
    Local $defsymbol, $memlistdata = ""
    For $ic = 1 to 9
;        $defsymbol = ""
;        If $ic = $idx+1 Then $defsymbol = "*"
        $memlistdata = $memlistdata & "|" & "M" & $ic & "=" & $mem[$ic-1]
    Next
    GUICtrlSetData($memlist, $memlistdata, $mem[$idx])
    GUICtrlSetState($memlist, $GUI_FOCUS)
EndFunc

;HotKeySet("{Esc}", "CloseCalc")
Func CloseCalc()
    GUIDelete()
    HotKeySet("{Esc}")
    Exit
EndFunc

Func MultKey()
    If GUICtrlRead($actind) == "" Then
        If GUICtrlRead($display) <> 0 Then Display($curstr)
    Else
        Evaluate()
    Endif
    GUICtrlSetData($actind, "*")
    GUICtrlSetState($display, 256)
EndFunc

Func DivKey()
    If GUICtrlRead($actind) == "" Then
        If GUICtrlRead($display) <> 0 Then Display($curstr)
    Else
        Evaluate()
    Endif
    GUICtrlSetData($actind, "/")
    GUICtrlSetState($display, 256)
EndFunc

Func AddKey()
    If GUICtrlRead($actind) == "" Then
        If GUICtrlRead($display) <> 0 Then Display($curstr)
    Else
        Evaluate()
    Endif
    GUICtrlSetData($actind, "+")
    GUICtrlSetState($display, 256)
EndFunc

Func SubKey()
    If GUICtrlRead($actind) == "" Then
        If GUICtrlRead($display) <> 0 Then Display($curstr)
    Else
        Evaluate()
    Endif
    GUICtrlSetData($actind, "-")
    GUICtrlSetState($display, 256)
EndFunc

Func DeleteKey()
    Display(0)
    GUICtrlSetState($display, 256)
EndFunc

Func EnterKey()
    If GUICtrlRead($actind) == "" Then Return
    If $curstr = "0" Then GUICtrlSetData($display, $oldstr)
    Evaluate()
    GUICtrlSetState($display, 256)
EndFunc

