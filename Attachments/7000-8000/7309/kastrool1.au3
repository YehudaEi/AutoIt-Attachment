
;
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x/NT
; Author:         Samuel Murray (leuce@absamail.co.za)

; Script Function:
;   Checks for typing errors in the clipboard by comparing the clipboard contents
;   to an existing list of correctly spelt words and outputting the balance.

; System Requirements:
;   * OmegaT (from                                         )
;   * AutoIt 3 (latest version)
;   * UnxUtils tools cut.exe, diff.exe and grep.exe
;   * A large spelling dictionary called WSpel.txt -- one word per line
;   The script, the three tools and the dictionary should all be in a single
;   folder called C:\Kastrool\ (you can change this, but then you must change
;   the script... very easy).

; Customisation:
;   !!! 1 !!! If you don't want to change all to lowercase, comment out.
;   !!! 2 !!! Set your own punctuation (plus one space) to suit yourself.
;   !!! 3 !!! Alter @CRLF according to your system's newline character.

; The hotkey for exiting the script is Ctrl+Alt+X firmly.

HotKeySet("^!x", "MyExit")

; When any hotkey is pressed, execute the associated function.

; SpellCheck does the typing error check.
HotKeySet ("^{ENTER}", "SpellCheck")

; UnToolTip dismisses the tooltip (otherwise it remains for 1 hour).
HotKeySet ("^{BACKSPACE}", "UnToolTip")

; AddWords adds the words currently in the tooltip to WSpel2.txt so that
; you can integrate it with your existing spelling dictionary later.
HotKeySet ("!{ENTER}", "AddWords")

; Let the script stay resident in memory and let the hotkey be active.

While 1
Sleep (10000)
WEnd

; This is the SpellCheck function.  If OmegaT is active, it performs the
; spell-check, but if the Command window is active, it returns to OmegaT.

Func SpellCheck()

If WinActive ("OmegaT", "") Then

; Selects all in the segment in OmegaT and adds it to the clipboard.

WinWaitActive ("OmegaT", "")
Send ("^a")
Send ("^c")

; Grabs the clipboard.

$bak0 = ClipGet()

; Converts the text to lowercase.
$bak1 = StringLower($bak0) ; !!! 1 !!!

; Writes the clipboard contents to a temporary file.

$file = FileOpen("C:\Kastrool\ClipA.txt", 2)
FileWrite ($file, $bak1)
FileClose ($file)

; Reads the temporary file text, replace spaces with hard returns, so that each
; word is on a separate line, and writes it to a second temporary file.

$FileText1 = FileRead("C:\Kastrool\ClipA.txt", FileGetSize("C:\Kastrool\ClipA.txt"))
$FileTextARRAY = StringSplit($FileText1, " ,.?!;:", 0) ; !!! 2 !!!
$file2 = FileOpen("C:\Kastrool\ClipB.txt", 2)

For $i = 1 To $FileTextARRAY[0]
FileWrite ($file2, $FileTextARRAY[$i] & @CRLF) ; !!! 3 !!!
Next

FileClose ($file2)

; Runs UnxUtils function to compare the text of the second temporary file against
; an existing large wordlist with correctly spelt words, and puts the balance in
; a third temporary file.

RunWait(@ComSpec & ' /c C:\Kastrool\diff.exe WSpel.txt ClipB.txt | grep.exe ">" | cut.exe -d" " -f2 > Typos.txt', 'C:\Kastrool', @SW_HIDE)

; Displays a tooltip with the typing errors.  Customise as you will.

$Alt2 = FileRead("C:\Kastrool\Typos.txt", FileGetSize("C:\Kastrool\Typos.txt"))
ToolTip($Alt2, 600, 100) ; 100 and 100 is the position on your screen.
Sleep(3600000) ; 3600000 is a display time in milliseconds (1 hour).

EndIf

EndFunc

Func UnToolTip()
ToolTip("", 600, 100)
EndFunc

Func AddWords ()
$File4 = FileRead("C:\Kastrool\Typos.txt", FileGetSize("C:\Kastrool\Typos.txt"))
$file5 = FileOpen("C:\Kastrool\WSpel2.txt", 1)
FileWrite ($file5, $file4)
FileClose ($file5)
EndFunc

; This is the script ending function.

Func MyExit()
    Exit 
EndFunc 

Exit

