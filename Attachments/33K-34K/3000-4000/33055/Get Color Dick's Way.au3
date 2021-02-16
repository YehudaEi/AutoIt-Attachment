;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Good example of tray tip control and continue loop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Include <Constants.au3>

Opt("TrayAutoPause",1)
Opt("TrayMenuMode",1)

HotKeySet("^!x" , "getcolor")
HotKeySet("{ESC}" , "fexit")

$setclip = 1

dim $vdif, $wdif, $output, $black, $cyanng, $magentang, $yellowng

$main = GUICreate("Get cursor Color", 75, 45, @DesktopWidth - 140, @DesktopHeight - 120, $WS_BORDER, $WS_EX_CLIENTEDGE + $WS_EX_TOPMOST )
GUISetState()

;Tray GUI Creation
$Clip = TrayCreateItem("To Clipboard ")
TrayItemSetState($clip, $TRAY_CHECKED)
$setclip = 1
TrayCreateItem("")
$valitem    = TrayCreateItem("Instructions")
TrayCreateItem("")
$aboutitem  = TrayCreateItem("About")
TrayCreateItem("")
$exit = TrayCreateItem("Exit")
TraySetState()

While 1
    $mouse = MouseGetPos()
    $msg = TrayGetMsg()
    Select
        Case $msg = 0
            $var = PixelGetColor( $mouse[0] , $mouse[1])
            $background = GUICtrlSetBkColor($main, $var)
            GUISetBkColor($var, $main)
            ContinueLoop
        Case $msg = $Clip
            $decide = TrayItemGetState($clip)
            If $decide = 1 then
                $setclip = 1
            Else
                $setclip = 0
            endif
        Case $msg = $valitem
            Msgbox(64,"Instructions:","ALT+CTRL+X - Get Color" & @CRLF & "ESC - Exit Program")
        Case $msg = $aboutitem
            Msgbox(64,"About:","November 2009" & @CRLF & "Free usage")
        Case $msg = $exit
            exit
    EndSelect
WEnd

Func getcolor()
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; GUISetBkColor(0xF0F4F9)
;Hex color to RGB
    $output = ""
    $hex = Hex ( $var , 6)
;~     $HR = StringMid($hex, 1, 2)
;~     $HG = StringMid($hex, 3, 2)
;~     $HB = StringMid($hex, 5, 2)
;~     $R = Dec($HR)
;~     $G = Dec($HG)
;~     $B = Dec($HB)

;Convert RGB to CMY
;~     $cyanr = 1-($r/255)
;~     $magentar = 1-($g/255)
;~     $yellowr= 1-($b/255)

;Convert CMY to CMYK
;~     $blackr=1

;~     If $blackr > $cyanr Then $blackr = $cyanr
;~     if $blackr > $magentar Then $blackr= $magentar
;~     if $blackr > $yellowr Then $blackr = $yellowr
;~     if $blackr = 1 Then
;~         $cyanr = 0
;~         $magentar = 0
;~         $yellowr = 0
;~     Else
;~         $cyanr = ($cyanr-$blackr)/(1-$blackr)
;~         $magentar = ($magentar-$blackr)/(1-$blackr)
;~         $yellowr = ($yellowr-$blackr)/(1-$blackr)
;~     EndIf
;~     $kr = $blackr

;Let's get only the three decimal numbert to match YMCK requirements
;~     $cyan = StringFormat("%.3f", $cyanr)
;~     $magenta = StringFormat("%.3f", $magentar)
;~     $yellow = StringFormat("%.3f", $yellowr)
;~     $k = StringFormat("%.3f", $kr)

;Output results in a a ballon or to the clipboard
;~     $output = "Hexadecimal : " & $hex & @CRLF
;~     $output = $output & "RGB : " & $R & ", " & $G & ", " & $B & @CRLF
;~     $output = $output & "CYMK : C-" & $cyan & ", M-" & $magenta & ", Y-" &  $yellow & ", K-" & $k
	$output = "GUISetBkColor(0x" & $hex & ")"
    TrayTip("RGB / CYMK Color", $output, 1)
    $backup = ClipGet()
    If $setclip = 1 then
        ClipPut($output)
    Else
        ClipPut($backup)
    EndIf

EndFunc

func fexit()
    Exit
EndFunc
