#include <GUIConstants.au3>

Dim $pics[3] = ["", "", ""]
Dim $count = -1, $width, $height
Global $nMaxWidth = 392, $nMaxHeight = 392

$Form1 = GUICreate("AForm1", 498, 412, 193, 115)
$Pic1 = GUICtrlCreatePic("", 12, 80, 392, 260)
$Button1 = GUICtrlCreateButton("Next", 416, 8, 75, 25, 0)
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
        Case $Button1
            $count += 1
            If $count = UBound($pics) Then Exit

            GUICtrlDelete($Pic1)
            $height = $nMaxHeight
            $size = _GetImageSize($pics[$count])
            If IsArray($size) Then
                $aspect = 1
                If $size[0] > $nMaxWidth Then $aspect = $nMaxWidth / $size[0]
                $width = $aspect * $size[0]
                $height = $aspect * $size[1]
                If $height > $nMaxHeight Then
                    $width = $width * ($nMaxHeight / $height)
                    $height = $nMaxHeight
                Endif
            Endif
            $Pic1 = GUICtrlCreatePic($pics[$count], 12, 12, $width, $height)
	EndSwitch
WEnd














;;;;; Support ;;;;;;
Func _GetImageSize($file)
Local $size[2]
Local $fs, $pos = 3
Local $marker

$marker = _FileReadAtOffsetHEX ($file, 1, 2)

If $marker = "424D" then
    $size[0] = _Dec(_FileReadAtOffsetHEX($file, 19, 2))
    $size[1] = _Dec(_FileReadAtOffsetHEX($file, 23, 2))
    Return($size)
Endif

If $marker = "FFD8" then
    $fs = FileGetSize($file)
    While $pos < $fs
        $data = _FileReadAtOffsetHEX ($file, $pos, 4)
        if StringLeft($data, 2) = "FF" then ; Valid segment start
            if StringInStr("C0 C2 CA C1 C3 C5 C6 C7 C9 CB CD CE CF", StringMid($data, 3, 2)) then ; Segment with size data
               $seg = _FileReadAtOffsetHEX ($file, $pos+5, 4)
               $size[1] = Dec(StringLeft($seg, 4))
               $size[0] = Dec(StringRight($seg, 4))
               Return($size)
            else
               $pos = $pos + Dec(StringRight($data, 4)) + 2
            endif
        else
            exitloop
        endif
    Wend
    SetError(2) ; Segment not found
    Return("")
EndIf
SetError(1) ; Not image
Return("")
EndFunc

Func _FileReadAtOffsetHEX ($file, $offset, $bytes)
    Local $tfile = FileOpen($file, 0)
    Local $tstr = ""
    FileRead($tfile, $offset-1)
    For $i = $offset To $offset + $bytes - 1
        $tstr =  $tstr & Hex(Asc(FileRead($tfile, 1)), 2)
    Next
    FileClose($tfile)
    Return ($tstr)
Endfunc

Func _Dec($input)
    Local $tStr = ""
    While StringLen($input) > 0
        $tStr = $tStr & StringRight($input, 2)
        $input = StringTrimRight($input, 2)
    WEnd
    Return (Dec($tStr))
EndFunc
