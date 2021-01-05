; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x / NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------

; Setup some useful options that you may want to turn on - see the helpfile for details.

; Expand all types of variables inside strings
;Opt("ExpandEnvStrings", 1)
;Opt("ExpandVarStrings", 1)

; Require that variables are declared (Dim) before use (helps to eliminate silly mistakes)
;Opt("MustDeclareVars", 1)


; ----------------------------------------------------------------------------
; Script Start - Add your code below here
; ----------------------------------------------------------------------------
;GUICtrlCreate... ("Text", left-right, top-bottom, howlong, howthick)
;black = 0x000000, green = 0x00FF00, red = 0xFF0000

#include <GUIConstants.au3>
AutoItSetOption("TrayIconDebug", 1)

Global $style1
Global $IniFile
Global $GUIWidth
Global $GUIHeight

$winwidth = @DesktopWidth - 7
$winheight = 234
$IniFile = StringTrimRight(@ScriptFullPath, 3) & "ini"

; First window before translated.
$win1 = GuiCreate("Mephy/Python's 1337 translator", $winwidth, $winheight, 1, 1)
   GuiSetBkColor( 0x000000 )
   GuiSetFont(20, 20, 0, "Comic Sans MS")
   GuiCtrlCreateLabel("Enter normal text you wish to translate to 1337:", 1, 1, $winwidth, 43)
   GuiCtrlSetColor( -1,0xFF0000 )
   $englishtext = GUICtrlCreateInput("", 1, 44, $winwidth - 250, 43)
   GuiCtrlSetColor( $englishtext,0xFF0000 )
   $convert = GUICtrlCreateButton("Translate", $winwidth - 250, 44, 215, 43)
   GUICtrlSetState( $convert, $GUI_DEFBUTTON)
   GuiCtrlCreateLabel("Enter 1337 text you wish to translate to normal:", 1, 87, $winwidth, 43)
   GuiCtrlSetColor( -1,0xFF0000 )
   $1337text = GUICtrlCreateInput("", 1, 130, $winwidth - 250, 43)
   $deconvert = GUICtrlCreateButton("Detranslate", $winwidth - 250, 130, 215, 43)
   $progressbar = GuiCtrlCreateProgress(1/4 * $winwidth, 183, 1/2 * $winwidth, 46)
   GuiCtrlSetColor(-1, 0x000000)
   $wait = .001
   $s = 0
   
;Sedond window after translate button pressed.
$win2 = GuiCreate("Mephy/Python's 1337 translator", $winwidth, $winheight, 1, 1)
   GuiSetBkColor( 0x000000)
   GuiSetFont(20, 20, 0, "Comic Sans MS")
   GuiCtrlCreateLabel("Your translated text is:", 1, 1, $winwidth , 43)
   GuiCtrlSetColor( -1,0xFF0000 )
   $1337 = GUICtrlCreateInput("", 1, 44, $winwidth - 250, 43)
   GuiCtrlSetColor( $1337,0xFF0000 )
   GuiCtrlSetState($1337, $GUI_DISABLE)
   $clipboard = GUICtrlCreateButton("Add To Clipboard", $winwidth - 250, 44, 215, 43)
   GUICtrlSetState( $clipboard, $GUI_DEFBUTTON)
   GuiCtrlCreateLabel("Your detranslated text is:", 1, 87, $winwidth, 43)
   GuiCtrlSetColor( -1,0xFF0000 )
   $normal = GUICtrlCreateInput("", 1, 130, $winwidth - 250, 43)
   GuiCtrlSetColor( -1,0xFF0000 )
   GuiCtrlSetState( $normal, $GUI_DISABLE)
   $clipboard2 = GUICtrlCreateButton("Add to Clipboard", $winwidth - 250, 130, 215, 43)
   $restart = GUICtrlCreateButton("Restart", $winwidth - 250, 181, 215, 45)

GUISwitch($win1)
GuiSetState(@SW_SHOW)

While 1
   $msg = GUIGetMsg()
   Select
   Case $msg = $GUI_EVENT_CLOSE
      Exit
   Case $msg = $convert
      For $i = $s To 100
         $m = GUIGetMsg ()
      If  $s=0 Then
         GUICtrlSetData ($progressbar,$i)
         Sleep($wait)
      EndIf
   Next
   $translated = Advanced(GUIRead($englishtext))
      GuiCtrlSetData($1337, $translated, 1)
      GuiSetState(@SW_HIDE)
      GuiSwitch($win2)
      GuiSetState(@SW_SHOW)
   Case $msg = $clipboard
      ClipPut(GUIRead($1337))
      GuiCtrlSetState( $convert, $GUI_DEFBUTTON)
   Case $msg = $clipboard2
      ClipPut(GUIRead($normal))
   Case $msg = $restart
      GuiSetState(@SW_HIDE)
      GuiSwitch($win1)
      GuiSetState(@SW_RESTORE)
   Case $msg = $deconvert
      For $i = $s To 100
         $m = GUIGetMsg ()
      If  $s=0 Then
         GUICtrlSetData ($progressbar,$i)
         Sleep($wait)
      EndIf
      Next
      $detranslated = DetranslateFunc(GUIRead($1337text))
      GuiCtrlSetData($normal, $detranslated, 1)
      GuiSetState(@SW_HIDE)
      GuiSwitch($win2)
      GuiSetState(@SW_SHOW)
      EndSelect
Wend
Func Advanced($text)
   $lowera = StringReplace($text, "a", "@", 0, 1) ;Replaces lowercase letters
   $lowerb = StringReplace($lowera, "b", "b", 0, 1)
   $lowerc = StringReplace($lowerb, "c", "(", 0, 1)
   $lowerd = StringReplace($lowerc, "d", "d", 0, 1)
   $lowere = StringReplace($lowerd, "e", "3", 0, 1)
   $lowerf = StringReplace($lowere, "f", "f", 0, 1)
   $lowerg = StringReplace($lowerf, "g", "g", 0, 1)
   $lowerh = StringReplace($lowerg, "h", "h", 0, 1)
   $loweri = StringReplace($lowerh, "i", "i", 0, 1)
   $lowerj = StringReplace($loweri, "j", "j", 0, 1)
   $lowerk = StringReplace($lowerj, "k", "k", 0, 1)
   $lowerl = StringReplace($lowerk, "l", "|", 0, 1)
   $lowerm = StringReplace($lowerl, "m", "m", 0, 1)
   $lowern = StringReplace($lowerm, "n", "n", 0, 1)
   $lowero = StringReplace($lowern, "o", "0", 0, 1)
   $lowerp = StringReplace($lowero, "p", "p", 0, 1)
   $lowerq = StringReplace($lowerp, "q", "q", 0, 1)
   $lowerr = StringReplace($lowerq, "r", "r", 0, 1)
   $lowers = StringReplace($lowerr, "s", "s", 0, 1)
   $lowert = StringReplace($lowers, "t", "t", 0, 1)
   $loweru = StringReplace($lowert, "u", "u", 0, 1)
   $lowerv = StringReplace($loweru, "v", "v", 0, 1)
   $lowerw = StringReplace($lowerv, "w", "w", 0, 1)
   $lowerx = StringReplace($lowerw, "x", "x", 0, 1)
   $lowery = StringReplace($lowerx, "y", "y", 0, 1)
   $lowerz = StringReplace($lowery, "z", "z", 0, 1)

;End of LowerCase

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Capital Letters

   $higha = StringReplace($lowerz, "A", "4", 0, 1) ;Replaces capital letters
   $highb = StringReplace($higha, "B", "|3", 0, 1)
   $highc = StringReplace($highb, "C", "[", 0, 1)
   $highd = StringReplace($highc, "D", "|)", 0, 1)
   $highe = StringReplace($highd, "E", "3", 0, 1)
   $highf = StringReplace($highe, "F", "F", 0, 1)
   $highg = StringReplace($highf, "G", "G", 0, 1)
   $highh = StringReplace($highg, "H", "|-|", 0, 1)
   $highi = StringReplace($highh, "I", "1", 0, 1)
   $highj = StringReplace($highi, "J", "J", 0, 1)
   $highk = StringReplace($highj, "K", "|<", 0, 1)
   $highl = StringReplace($highk, "L", "|", 0, 1)
   $highm = StringReplace($highl, "M", "/\/\", 0, 1)
   $highn = StringReplace($highm, "N", "/\/", 0, 1)
   $higho = StringReplace($highn, "O", "()", 0, 1)
   $highp = StringReplace($higho, "P", "P", 0, 1)
   $highq = StringReplace($highp, "Q", "Q", 0, 1)
   $highr = StringReplace($highq, "R", "R", 0, 1)
   $highs = StringReplace($highr, "S", "5", 0, 1)
   $hight = StringReplace($highs, "T", "7", 0, 1)
   $highu = StringReplace($hight, "U", "U", 0, 1)
   $highv = StringReplace($highu, "V", "\/", 0, 1)
   $highw = StringReplace($highv, "W", "\/\/", 0, 1)
   $highx = StringReplace($highw, "X", "><", 0, 1)
   $highy = StringReplace($highx, "Y", "Y", 0, 1)
   $highz = StringReplace($highy, "Z", "Z", 0, 1)
   Return $highz
EndFunc

Func DetranslateFunc($text)
   $replaceb = StringReplace($text, "|3", "B", 0, 1) ;replaces strings
   $replaceo = StringReplace($replaceb, "()", "O", 0, 1)
   $replacea = StringReplace($replaceo, "4", "A", 0, 1)
   $replaced = StringReplace($replacea, "|)", "D", 0, 1)
   $replaceh = StringReplace($replaced, "|-|", "H", 0, 1)
   $replacei = StringReplace($replaceh, "1", "I", 0, 1)
   $replacek = StringReplace($replacei, "|<", "K", 0, 1)
   $replacew = StringReplace($replacek, "\/\/", "W", 0, 1)
   $replacem = StringReplace($replacew, "/\/\", "M", 0, 1)
   $replacen = StringReplace($replacem, "/\/", "N", 0, 1)
   $replacec = StringReplace($replacen, "[", "C", 0, 1)
   $replaces = StringReplace($replacec, "5", "S", 0, 1)
   $replacet = StringReplace($replaces, "7", "T", 0, 1)
   $replacev = StringReplace($replacet, "\/", "V", 0, 1)
   $replacex = StringReplace($replacev, "><", "X", 0, 1)

;End Capital Letters

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Begin Lowercase

   $rplca = StringReplace($replacex, "@", "a", 0, 1)
   $rplcc = StringReplace($rplca, "(", "c", 0, 1)
   $rplce = StringReplace($rplcc, "3", "e", 0, 1)
   $rplcl = StringReplace($rplce, "|", "l", 0, 1)
   $rplco = StringReplace($rplcl, "0", "o", 0, 1)
   Return $rplco
EndFunc

;End Capital Letters

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
