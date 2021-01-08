; ===================================================
; Made By: nfwu
; Made to work as a windows screensaver by: Onoitsu2
; ===================================================
#NoTrayIcon
#include <GUIConstants.au3>

$gSpeed      = (50)
$gFieldColor = (0)
;~ $gRandColor  = (1)
$gFontSize   = (25)
$gLabelWidth = $gFontSize * 40
$gLabelHeight = $gFontSize * 12
$message = RegRead("HKEY_CURRENT_USER\Software\AutoItSCR","Message")
$gRandColor = RegRead("HKEY_CURRENT_USER\Software\AutoItSCR","RColor")
$direction = RegRead("HKEY_CURRENT_USER\Software\AutoItSCR","Direction")
If $message = "" Then $message = "AutoIt is simple, subtle, elegant."
If $gRandColor = "" Then $gRandColor = 0
If $direction = "" Then $direction = 0
Func SaverWindow($nWidth, $nHeight, $nLeft, $nTop, $hParent = 0)
    MouseMove($nWidth + 1, $nHeight + 1, 0)
    $mPos = MouseGetPos() 
    $hGUI = GUICreate("", $nWidth, $nHeight, $nLeft, $nTop, $WS_POPUPWINDOW, $WS_EX_TOPMOST, $hParent)
    GUISetBkColor($gFieldColor)
    Local $labelx = Random(0, $nWidth), $labely = Random(0, $nHeight)

    Local $label = GUICtrlCreateLabel ( $message, $labelx, $labely, $gLabelWidth, $gLabelHeight)

	if $gRandColor Then GUICtrlSetColor ( $label, "0x"&hex(Random(0,254,1),2)&hex(Random(0,254,1),2)&hex(Random(0,254,1),2))
	if NOT $gRandColor Then GUICtrlSetColor ( $label, 0xFFFFFF)
    GUICtrlSetFont ($label, $gFontSize )

    GUISetState()
    
    While 1
        $msg = GuiGetMsg()
        $mcPos = MouseGetPos()
        If $mPos[0] <> $mcPos[0] or $mPos[1] <> $mcPos[1] or $msg = $GUI_EVENT_CLOSE Then
            GUIDelete($hGUI)
            Return
        EndIf
		If $direction = 0 Then
		$labelx = $labelx + 5
        If $labelx > $nWidth Then
			if $gRandColor Then GUICtrlSetColor ( $label, "0x"&hex(Random(0,254,1),2)&hex(Random(0,254,1),2)&hex(Random(0,254,1),2))
			if NOT $gRandColor Then GUICtrlSetColor ( $label, 0xFFFFFF)
            $labelx = $nLeft - ($gLabelWidth / 2)
		EndIf
		Elseif $direction = 1 Then
        $labelx = $labelx - 5
        If $labelx < $nLeft - $gLabelWidth Then
			if $gRandColor Then GUICtrlSetColor ( $label, "0x"&hex(Random(0,254,1),2)&hex(Random(0,254,1),2)&hex(Random(0,254,1),2))
			if NOT $gRandColor Then GUICtrlSetColor ( $label, 0xFFFFFF)
            $labelx = $nWidth + ($gLabelWidth / 2)
            $labely = Random(0, $nHeight)
        EndIf
		EndIf
        GUICtrlSetPos ( $label, $labelx, $labely )
        Sleep(50 - $gSpeed)
    WEnd
EndFunc
Func setmessage()
	$sMessageAnswer = InputBox("Message to Display?","Message you want the screensaver to display?",$message," M","-1","-1","-1","-1")
Select
   Case @Error = 0 ;OK - The string returned is valid
$message = $sMessageAnswer
	RegWrite("HKEY_CURRENT_USER\Software\AutoItSCR","Message","REG_SZ",$message)
   Case @Error = 1 ;The Cancel button was pushed
   Case @Error = 3 ;The InputBox failed to open
   EndSelect
$iRColorAnswer = MsgBox(4,"Random Color?","Do you want the message to be a randomly generated color?" & @CRLF & "If NO it will be White")
Select
   Case $iRColorAnswer = 6 ;Yes
RegWrite("HKEY_CURRENT_USER\Software\AutoItSCR","RColor","REG_SZ",1)
   Case $iRColorAnswer = 7 ;No
RegWrite("HKEY_CURRENT_USER\Software\AutoItSCR","RColor","REG_SZ",0)
EndSelect
$iDirectionAnswer = MsgBox(4,"Text Direction?","Do You Want The Text To Move TO The Right?" & @CRLF & "NO Makes Text Come In From The Right TO The Left.")
Select
   Case $iDirectionAnswer = 6 ;Yes
RegWrite("HKEY_CURRENT_USER\Software\AutoItSCR","Direction","REG_SZ",0)
   Case $iDirectionAnswer = 7 ;No
RegWrite("HKEY_CURRENT_USER\Software\AutoItSCR","Direction","REG_SZ",1)
EndSelect

EndFunc

if $cmdline[0] > 0 Then
	if $cmdline[1] = "/S" Then
		SaverWindow(@DesktopWidth, @DesktopHeight, 0, 0)
	Exit
	ElseIf StringMid($cmdline[1],1,3) = "/c:" Then
		setmessage()
	ElseIf $cmdline[1] = "/p" Then
	EndIf
Elseif $cmdline[0] = 0 Then
setmessage()
EndIf

