#include <GUIConstantsEx.au3>
#include <Guiconstants.au3>
#include <EditConstants.au3>
#include <GuiEdit.au3>
#include <Buttonconstants.au3>

HotKeySet("{END}", "On_Exit")
Func On_Exit()
    Exit
EndFunc


$chinh = GUICreate("Caculator",450, 300 )

$input = GUICtrlCreateInput("", 8, 2, 530, 23, $ES_AUTOHSCROLL)
GUICtrlSetFont($input, 11, 580, 1, "Comic Sans MS")

$output = GUICtrlCreateInput("0", 8, 27, 530, 23, $ES_READONLY)
GUICtrlSetFont($output, 11, 580, 1, "Comic Sans MS")
$demtong = GUICtrlCreateInput("0", 200, 60, 36, 29, $ES_READONLY)
GUICtrlSetFont($demtong, 11, 580, 1, "Comic Sans MS")
GUICtrlSetLimit($demtong, 19, 0)
$demkq = GUICtrlCreateInput("0", 200, 100, 36, 29, $ES_READONLY)
GUICtrlSetFont($demkq, 11, 580, 1, "Comic Sans MS")


$0 = GUICtrlCreateButton("0", 10, 261, 36, 29, BitOr($GUI_SS_DEFAULT_BUTTON, $BS_VCENTER))
$1 = GUICtrlCreateButton("1", 10, 228, 36, 29, BitOr($GUI_SS_DEFAULT_BUTTON, $BS_VCENTER))
$2 = GUICtrlCreateButton("2", 49, 228, 36, 29, BitOr($GUI_SS_DEFAULT_BUTTON, $BS_VCENTER))
$3 = GUICtrlCreateButton("3", 88, 228, 36, 29, BitOr($GUI_SS_DEFAULT_BUTTON, $BS_VCENTER))
$4 = GUICtrlCreateButton("4", 10, 195, 36, 29, BitOr($GUI_SS_DEFAULT_BUTTON, $BS_VCENTER))
$5 = GUICtrlCreateButton("5", 49, 195, 36, 29, BitOr($GUI_SS_DEFAULT_BUTTON, $BS_VCENTER))
$6 = GUICtrlCreateButton("6", 88, 195, 36, 29, BitOr($GUI_SS_DEFAULT_BUTTON, $BS_VCENTER))
$7 = GUICtrlCreateButton("7", 10, 162, 36, 29, BitOr($GUI_SS_DEFAULT_BUTTON, $BS_VCENTER))
$8 = GUICtrlCreateButton("8", 49, 162, 36, 29, BitOr($GUI_SS_DEFAULT_BUTTON, $BS_VCENTER))
$9 = GUICtrlCreateButton("9", 88, 162, 36, 29, BitOr($GUI_SS_DEFAULT_BUTTON, $BS_VCENTER))

$dot = GUICtrlCreateButton(".", 49, 261, 36, 29, BitOr($GUI_SS_DEFAULT_BUTTON, $BS_VCENTER))
$exp = GUICtrlCreateButton("Exp", 88, 261, 36, 29, BitOr($GUI_SS_DEFAULT_BUTTON, $BS_VCENTER))
$Ans = GUICtrlCreateButton("Ans", 127, 261, 36, 29, BitOr($GUI_SS_DEFAULT_BUTTON, $BS_VCENTER))
$bang = GUICtrlCreateButton("=", 166, 261, 36, 29, BitOr($GUI_SS_DEFAULT_BUTTON, $BS_VCENTER))
GUICtrlSetState($bang, $GUI_DEFBUTTON)
$cong = GUICtrlCreateButton("+", 127, 228, 36, 29, BitOr($GUI_SS_DEFAULT_BUTTON, $BS_VCENTER))
$nhan = GUICtrlCreateButton("*", 127, 195, 36, 29, BitOr($GUI_SS_DEFAULT_BUTTON, $BS_VCENTER))
$chia = GUICtrlCreateButton("/", 166, 195, 36, 29, BitOr($GUI_SS_DEFAULT_BUTTON, $BS_VCENTER))
$tru = GUICtrlCreateButton("--", 166, 228, 36, 29, BitOr($GUI_SS_DEFAULT_BUTTON, $BS_VCENTER))

$AC = GUICtrlCreateButton("AC", 166, 162, 36, 29, BitOr($GUI_SS_DEFAULT_BUTTON, $BS_VCENTER))
$DEL = GUICtrlCreateButton("DEL", 127, 162, 36, 29, BitOr($GUI_SS_DEFAULT_BUTTON, $BS_VCENTER))


GUISetState()


Func cb2($so)
    $ketqua = Number($so) ^ (1 / 2)
    Return $ketqua
EndFunc   
Func cb3($so)
    $ketqua = Number($so) ^ (1 / 3)
    Return $ketqua
EndFunc   

Func cb($heso, $so)
    $ketqua = $so ^ (1 / $heso)
    Return $ketqua
EndFunc   


$deminput = 0
Func Ans()
    Return Execute(GUICtrlRead($output))
EndFunc

tinhtoan()
Func tinhtoan()

    While 1
        $msg = GUIGetMsg()
        Select
            Case $msg = $gui_event_close
                ExitLoop
    
            Case $msg = $0
                GUICtrlSetData($input, GUICtrlRead($input) & "0")
                GUICtrlSetData($demtong, Execute("$deminput + 1"))
                $deminput = Execute("$deminput + 1")
            Case $msg = $1
                GUICtrlSetData($input, GUICtrlRead($input) & "1")
                GUICtrlSetData($demtong, Execute("$deminput + 1"))
                $deminput = Execute("$deminput + 1")
            Case $msg = $2
                GUICtrlSetData($input, GUICtrlRead($input) & "2")
                GUICtrlSetData($demtong, Execute("$deminput + 1"))
                $deminput = Execute("$deminput + 1")
            Case $msg = $3
                GUICtrlSetData($input, GUICtrlRead($input) & "3")
                GUICtrlSetData($demtong, Execute("$deminput + 1"))
                $deminput = Execute("$deminput + 1")
            Case $msg = $4
                GUICtrlSetData($input, GUICtrlRead($input) & "4")
                GUICtrlSetData($demtong, Execute("$deminput + 1"))
                $deminput = Execute("$deminput + 1")
            Case $msg = $5
                GUICtrlSetData($input, GUICtrlRead($input) & "5")
                GUICtrlSetData($demtong, Execute("$deminput + 1"))
                $deminput = Execute("$deminput + 1")
            Case $msg = $6
                GUICtrlSetData($input, GUICtrlRead($input) & "6")
                GUICtrlSetData($demtong, Execute("$deminput + 1"))
                $deminput = Execute("$deminput + 1")
            Case $msg = $7
                GUICtrlSetData($input, GUICtrlRead($input) & "7")
                GUICtrlSetData($demtong, Execute("$deminput + 1"))
                $deminput = Execute("$deminput + 1")
            Case $msg = $8
                GUICtrlSetData($input, GUICtrlRead($input) & "8")
                GUICtrlSetData($demtong, Execute("$deminput + 1"))
                $deminput = Execute("$deminput + 1")
            Case $msg = $9
                GUICtrlSetData($input, GUICtrlRead($input) & "9")
                GUICtrlSetData($demtong, Execute("$deminput + 1"))
                $deminput = Execute("$deminput + 1")

            Case $msg = $cong
                GUICtrlSetData($input, GUICtrlRead($input) & "+")

            Case $msg = $tru
                GUICtrlSetData($input, GUICtrlRead($input) & "-")

            Case $msg = $nhan
                GUICtrlSetData($input, GUICtrlRead($input) & "*")

            Case $msg = $chia
                GUICtrlSetData($input, GUICtrlRead($input) & "/")

            Case $msg = $exp
                GUICtrlSetData($input, GUICtrlRead($input) & "E")

            Case $msg = $dot
                GUICtrlSetData($input, GUICtrlRead($input) & ".")

            Case $msg = $AC
                GUICtrlSetData($input, "")
                $deminput = 0
                GUICtrlSetData($demtong, $deminput)

            Case $msg = $DEL
                If StringIsDigit(StringMid(GUICtrlRead($input), StringLen(GUICtrlRead($input)), 1)) = 1 Then
                GUICtrlSetData($input, StringTrimRight(GUICtrlRead($input), 1))
                GUICtrlSetData($demtong, Execute("$deminput - 1"))
                $deminput = Execute("$deminput - 1")
                ElseIf StringIsDigit(StringMid(GUICtrlRead($input), StringLen(GUICtrlRead($input)), 1)) <> 1 And StringMid(GUICtrlRead($input), StringLen(GUICtrlRead($input)) - 4, 5) <> "Ans()" Then
                GUICtrlSetData($input, StringTrimRight(GUICtrlRead($input), 1))
                ElseIf StringMid(GUICtrlRead($input), StringLen(GUICtrlRead($input)) - 4, 5) = "Ans()" Then
                GUICtrlSetData($input, StringTrimRight(GUICtrlRead($input), 5))
                EndIf
                If $deminput < 0 Then
                    $deminput = 0
                    GUICtrlSetData($demtong, $deminput)
                EndIf

            Case $msg = $Ans
                GUICtrlSetData($input, GUICtrlRead($input) & 'Ans()')

            Case $msg = $bang
                $outputkq = Execute(GUICtrlRead($input))
                If $outputkq = "9223372036854775807" Then
                    GUICtrlSetData($demkq, 0)
                Else
                    GUICtrlSetData($output, $outputkq)
                EndIf

                GUICtrlSetData($demkq, StringLen(Floor($outputkq)))
                $dai = StringLen(GUICtrlRead($output))
                If $outputkq >= 1 Or $outputkq <=-1 And StringMid(GUICtrlRead($output), $dai - 4, 1) = "e" Then
                    GUICtrlSetData($demkq, Execute(StringRight(GUICtrlRead($output), 3) + 1))
                ElseIf (0 <= $outputkq and $outputkq < 1) Or (0 > $outputkq and $outputkq > -1) Then
                    GUICtrlSetData($demkq, 0)
                ElseIf $outputkq < 0 And StringMid(GUICtrlRead($output), $dai - 4, 1) <> "e" Then
                    GUICtrlSetData($demkq, StringLen(Ceiling($outputkq)) - 1)
                ElseIf GUICtrlRead($output) = "1.#INF" Then
                    MsgBox(16, 'Warning', "Data error")
                EndIf
        EndSelect
    WEnd
EndFunc   
