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
;The Reaper's elite translator. (Hacked by the Black One)
;Version 1.7
;@Created by the Reaper.
;left to right, top to bottom, length, width. 

#include "GUIConstants.au3"

$window1 = GUICreate("The Reaper's 1337 Translator -Version 1.7", 700, 400)
GUISetBkColor(0x000000)
GUICtrlCreateLabel("The Reaper's 1337 Translator", 225, 10, 300, 300)
GUICtrlSetColor(-1,0xff0000)
GUICtrlSetFont(-1, 14, 40)
GUICtrlCreateLabel("(|-|@¢ked bÿ †he ßL@Ç|< 0n3)", 265, 40, 300, 300)
GUICtrlSetColor(-1,0xff0000)
GUICtrlSetFont(-1, 10, 10)
$translate = GUICtrlCreateButton("&Translate", 10, 120, 90, 25)
$detranslate = GUICtrlCreateButton("&Detranslate", 10, 150, 90, 25)
$copy = GUICtrlCreateButton("&Add to Clipboard", 10, 180, 90, 25)
$save = GUICtrlCreateButton("&Save to File", 10, 210, 90, 25)
$instructions = GUICtrlCreateButton("&Instructions", 10, 240, 90, 25)
$clearbox = GUICtrlCreateButton("&Clear Box", 10, 270, 90, 25)
GUICtrlCreateLabel("Reaper Industries- ßringing ÿ0u †3h m0s† 3|i†3 shi† 0n †3h in†erne†.", 160, 340, 400, 400)
GUICtrlSetColor(-1,0xff0000)
GUICtrlSetFont(-1, 10, 40)
$input = GUICtrlCreateEdit("Enter the text you wish to translate / detranslate here.", 160, 120, 475, 172, 0x00200000)

$style = BitOr($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL)

$window2 = GUICreate("TheReaper's 1337 Translator -Instructions", 700, 400)
GUISetBkColor(0x000000)
GUICtrlCreateLabel("Instructions", 285, 10, 300, 300)
GUICtrlSetColor(-1,0xff0000)
GUICtrlSetFont(-1, 14, 10)
$help = GUICtrlCreateEdit("Welcome to the Reaper's elite translator. It can translate, and detranslate the Reaper's standard ASCII character alphabet for you. Type in the normal text you wish to translate into the edit box, then press one of the buttons on the left to Translate, or Detranslate your text. Press the Clear Box button to clear your text. To copy the text that you have already translated / detranslated, press the Add to Clipboard button which will copy it for you. If you wish to save your translated / detranslated text to a .txt Notepad file then press the Save File button and chose a location to save your file. Also, I have added hotkeys for all of the buttons to make it easier. Alt + T will translate your text. Alt + D will detranslate your text. Alt + s will save your text to a file. Alt + C will clear the box. Alt + a will add your text to the clipboard. Alt + i will take you back to this page. And Alt + r will exit your out of this page. Enjoy.", 100, 100, 500, 200, $style)
GUICtrlSetState($help, $GUI_DISABLE)
$return = GUICtrlCreateButton("&Return to Main Page", 295, 370, 110, 25)

GUISwitch($window1)
GUISetState(@SW_SHOW)

While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE
         ExitLoop
      Case $msg = $clearbox
         GuiCtrlSetData($input, "")
      Case $msg = $instructions
         GUISetState(@SW_HIDE)
         GUISwitch($window2)
         GUISetState(@SW_SHOW)
      Case $msg = $return
         GUISetState(@SW_HIDE)
         GUISwitch($window1)
         GUISetState(@SW_SHOW)
      Case $msg = $translate
         $translated = Advanced(GUIRead($input))
         GUICtrlSetData($input, "")
         GUICtrlSetData($input, $translated)
      Case $msg = $detranslate
         $detranslated = DetranslateFunc(GUIRead($input))
         GUICtrlSetData($input, "")
         GUICtrlSetData($input, $detranslated)
      Case $msg = $copy
         ClipPut(GUIRead($input))
      Case $msg = $save
         $writing = GUIRead($input)
         $file = FileSaveDialog("Where would you like to save the file?", @DesktopDir, "Text files (*.txt)")
         FileWrite($file & ".txt", $writing)
   EndSelect
Wend
   
Func Advanced($text)
   $lowera = StringReplace($text, "a", "@", 0, 1) ;Replaces lowercase letters
   $lowerb = StringReplace($lowera, "b", "b", 0, 1)
   $lowerc = StringReplace($lowerb, "c", "¢", 0, 1)
   $lowerd = StringReplace($lowerc, "d", "d", 0, 1)
   $lowere = StringReplace($lowerd, "e", "e", 0, 1)
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
   $lowert = StringReplace($lowers, "t", "†", 0, 1)
   $loweru = StringReplace($lowert, "u", "u", 0, 1)
   $lowerv = StringReplace($loweru, "v", "v", 0, 1)
   $lowerw = StringReplace($lowerv, "w", "w", 0, 1)
   $lowerx = StringReplace($lowerw, "x", "x", 0, 1)
   $lowery = StringReplace($lowerx, "y", "ÿ", 0, 1)
   $lowerz = StringReplace($lowery, "z", "z", 0, 1)

;End of LowerCase

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Capital Letters

   $higha = StringReplace($lowerz, "A", "4", 0, 1) ;Replaces capital letters
   $highb = StringReplace($higha, "B", "ß", 0, 1)
   $highc = StringReplace($highb, "C", "Ç", 0, 1)
   $highd = StringReplace($highc, "D", "|)", 0, 1)
   $highe = StringReplace($highd, "E", "3", 0, 1)
   $highf = StringReplace($highe, "F", "F", 0, 1)
   $highg = StringReplace($highf, "G", "G", 0, 1)
   $highh = StringReplace($highg, "H", "|-|", 0, 1)
   $highi = StringReplace($highh, "I", "1", 0, 1)
   $highj = StringReplace($highi, "J", "J", 0, 1)
   $highk = StringReplace($highj, "K", "|<", 0, 1)
   $highl = StringReplace($highk, "L", "L", 0, 1)
   $highm = StringReplace($highl, "M", "/\/\", 0, 1)
   $highn = StringReplace($highm, "N", "/\/", 0, 1)
   $higho = StringReplace($highn, "O", "()", 0, 1)
   $highp = StringReplace($higho, "P", "P", 0, 1)
   $highq = StringReplace($highp, "Q", "Q", 0, 1)
   $highr = StringReplace($highq, "R", "R", 0, 1)
   $highs = StringReplace($highr, "S", "$", 0, 1)
   $hight = StringReplace($highs, "T", "7", 0, 1)
   $highu = StringReplace($hight, "U", "|_|", 0, 1)
   $highv = StringReplace($highu, "V", "\%", 0, 1)
   $highw = StringReplace($highv, "W", "VV", 0, 1)
   $highx = StringReplace($highw, "X", "><", 0, 1)
   $highy = StringReplace($highx, "Y", "¥", 0, 1)
   $highz = StringReplace($highy, "Z", "Z", 0, 1)
   Return $highz
EndFunc

Func DetranslateFunc($text)
   $replaceb = StringReplace($text, "ß", "B", 0, 1) ;replaces strings
   $replaceo = StringReplace($replaceb, "()", "O", 0, 1)
   $replacea = StringReplace($replaceo, "4", "A", 0, 1)
   $replaced = StringReplace($replacea, "|)", "D", 0, 1)
   $replaceh = StringReplace($replaced, "|-|", "H", 0, 1)
   $replacei = StringReplace($replaceh, "1", "I", 0, 1)
   $replacek = StringReplace($replacei, "|<", "K", 0, 1)
   $replacev = StringReplace($replacek, "\%", "V", 0, 1)
   $replacem = StringReplace($replacev, "/\/\", "M", 0, 1)
   $replacen = StringReplace($replacem, "/\/", "N", 0, 1)
   $replacew = StringReplace($replacen, "VV", "W", 0, 1)
   $replacec = StringReplace($replacew, "Ç", "C", 0, 1)
   $replaces = StringReplace($replacec, "$", "S", 0, 1)
   $replacet = StringReplace($replaces, "7", "T", 0, 1)
   $replacex = StringReplace($replacet, "><", "X", 0, 1)
   $replaceu = StringReplace($replacex, "|_|", "U", 0, 1)
   $replacey = StringReplace($replaceu, "¥", "Y", 0, 1)
   $replacee = StringReplace($replacey, "3", "E", 0, 1)

;End Capital Letters

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Begin Lowercase

   $rplca = StringReplace($replacee, "@", "a", 0, 1)
   $rplcc = StringReplace($rplca, "¢", "c", 0, 1)
   $rplcl = StringReplace($rplcc, "|", "l", 0, 1)
   $rplcy = StringReplace($rplcl, "ÿ", "y", 0, 1)
   $rplct = StringReplace($rplcy, "†", "t", 0, 1)
   $rplco = StringReplace($rplct, "0", "o", 0, 1)
   Return $rplco
EndFunc

;End Capital Letters

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;