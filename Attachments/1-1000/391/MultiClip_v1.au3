; ----------------------------------------------------------------------------
; MultiClip Ver 1.0.0 - 11-18-04
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x / NT
; Author:         Scott Swanson <scottswan@gmail.com>
;
; Script Function:	Windows style Clipboard with up to 10 keys for copying/pasting text only. 
; Copy and paste using:
; CTRL + ALT + 0-9 on number pad for copy.
; CTRL + 0-9 on number pad for paste.
; Stores all text in an ini file. See ReadMe or hit Win + h for instructions.
; ----------------------------------------------------------------------------

; Variables to pass the text to/from the clipboard and ini.
Dim $gettext
Dim $puttext

; Some global keys.
HotKeySet("{ESC}", "Quit")
HotKeySet("#i", "OpenINI")
HotKeySet("#h", "Help")

;;;;;;;;;Paste from INI;;;;;;;;;
; Assign the paste keys - Example: Ctrl + 1 (on number pad).
HotKeySet("^{NUMPAD0}", "Get0")
HotKeySet("^{NUMPAD1}", "Get1")
HotKeySet("^{NUMPAD2}", "Get2")
HotKeySet("^{NUMPAD3}", "Get3")
HotKeySet("^{NUMPAD4}", "Get4")
HotKeySet("^{NUMPAD5}", "Get5")
HotKeySet("^{NUMPAD6}", "Get6")
HotKeySet("^{NUMPAD7}", "Get7")
HotKeySet("^{NUMPAD8}", "Get8")
HotKeySet("^{NUMPAD9}", "Get9")

Func Get0()
; Read from the ini.
	$gettext = IniRead("MultiClip.ini", "Number 0", "text", "NotFound")
; Move text into the windows clipboard.
  ClipPut($gettext)
  Send("^v")
EndFunc

Func Get1()
; Read from the ini.
	$gettext = IniRead("MultiClip.ini", "Number 1", "text", "NotFound")
; Move text into the windows clipboard.
  ClipPut($gettext)
  Send("^v")
EndFunc

Func Get2()
; Read from the ini.
	$gettext = IniRead("MultiClip.ini", "Number 2", "text", "NotFound")
; Move text into the windows clipboard.
  ClipPut($gettext)
  Send("^v")
EndFunc

Func Get3()
; Read from the ini.
	$gettext = IniRead("MultiClip.ini", "Number 3", "text", "NotFound")
; Move text into the windows clipboard.
  ClipPut($gettext)
  Send("^v")
EndFunc

Func Get4()
; Read from the ini.
	$gettext = IniRead("MultiClip.ini", "Number 4", "text", "NotFound")
; Move text into the windows clipboard.
  ClipPut($gettext)
  Send("^v")
EndFunc

Func Get5()
; Read from the ini.
	$gettext = IniRead("MultiClip.ini", "Number 5", "text", "NotFound")
; Move text into the windows clipboard.
  ClipPut($gettext)
  Send("^v")
EndFunc

Func Get6()
; Read from the ini.
	$gettext = IniRead("MultiClip.ini", "Number 6", "text", "NotFound")
; Move text into the windows clipboard.
  ClipPut($gettext)
  Send("^v")
EndFunc

Func Get7()
; Read from the ini.
	$gettext = IniRead("MultiClip.ini", "Number 7", "text", "NotFound")
; Move text into the windows clipboard.
  ClipPut($gettext)
  Send("^v")
EndFunc

Func Get8()
; Read from the ini.
	$gettext = IniRead("MultiClip.ini", "Number 8", "text", "NotFound")
; Move text into the windows clipboard.
  ClipPut($gettext)
  Send("^v")
EndFunc

Func Get9()
; Read from the ini.
	$gettext = IniRead("MultiClip.ini", "Number 9", "text", "NotFound")
; Move text into the windows clipboard.
  ClipPut($gettext)
  Send("^v")
EndFunc

;;;;;;;;;Save to INI;;;;;;;;;
; Assign the save keys - Example: Ctrl + Alt + 1 (on number pad).
HotKeySet("^!{NUMPAD0}", "Put0")
HotKeySet("^!{NUMPAD1}", "Put1")
HotKeySet("^!{NUMPAD2}", "Put2")
HotKeySet("^!{NUMPAD3}", "Put3")
HotKeySet("^!{NUMPAD4}", "Put4")
HotKeySet("^!{NUMPAD5}", "Put5")
HotKeySet("^!{NUMPAD6}", "Put6")
HotKeySet("^!{NUMPAD7}", "Put7")
HotKeySet("^!{NUMPAD8}", "Put8")
HotKeySet("^!{NUMPAD9}", "Put9")

Func Put0()
	Send("^c")
; Get text from the windows clipboard.
	$puttext = ClipGet()
; Write to the ini.
	IniWrite("MultiClip.ini", "Number 0", "text", $puttext)
	Sleep(200)
	SoundPlay("C:\windows\media\tada.wav")
EndFunc

Func Put1()
  Send("^c")
; Get text from the windows clipboard.
	$puttext = ClipGet()
; Write to the ini.
	IniWrite("MultiClip.ini", "Number 1", "text", $puttext)
	Sleep(200)
	SoundPlay("C:\windows\media\tada.wav")
EndFunc

Func Put2()
  Send("^c")
; Get text from the windows clipboard.
	$puttext = ClipGet()
; Write to the ini.
	IniWrite("MultiClip.ini", "Number 2", "text", $puttext)
	Sleep(200)
	SoundPlay("C:\windows\media\tada.wav")
EndFunc

Func Put3()
  Send("^c")
; Get text from the windows clipboard.
	$puttext = ClipGet()
; Write to the ini.
	IniWrite("MultiClip.ini", "Number 3", "text", $puttext)
	Sleep(200)
	SoundPlay("C:\windows\media\tada.wav")
EndFunc

Func Put4()
  Send("^c")
; Get text from the windows clipboard.
	$puttext = ClipGet()
; Write to the ini.
	IniWrite("MultiClip.ini", "Number 4", "text", $puttext)
	Sleep(200)
	SoundPlay("C:\windows\media\tada.wav")
EndFunc

Func Put5()
  Send("^c")
; Get text from the windows clipboard.
	$puttext = ClipGet()
; Write to the ini.
	IniWrite("MultiClip.ini", "Number 5", "text", $puttext)
	Sleep(200)
	SoundPlay("C:\windows\media\tada.wav")
EndFunc

Func Put6()
  Send("^c")
; Get text from the windows clipboard.
	$puttext = ClipGet()
; Write to the ini.
	IniWrite("MultiClip.ini", "Number 6", "text", $puttext)
	Sleep(200)
	SoundPlay("C:\windows\media\tada.wav")
EndFunc

Func Put7()
  Send("^c")
; Get text from the windows clipboard.
	$puttext = ClipGet()
; Write to the ini.
	IniWrite("MultiClip.ini", "Number 7", "text", $puttext)
	Sleep(200)
	SoundPlay("C:\windows\media\tada.wav")
EndFunc

Func Put8()
  Send("^c")
; Get text from the windows clipboard.
	$puttext = ClipGet()
; Write to the ini.
	IniWrite("MultiClip.ini", "Number 8", "text", $puttext)
	Sleep(200)
	SoundPlay("C:\windows\media\tada.wav")
EndFunc

Func Put9()
  Send("^c")
; Get text from the windows clipboard.
	$puttext = ClipGet()
; Write to the ini.
	IniWrite("MultiClip.ini", "Number 9", "text", $puttext)
	Sleep(200)
	SoundPlay("C:\windows\media\tada.wav")
EndFunc

; Run endless loop to keep script alive.
While 1
  Sleep(100)
WEnd

Func OpenINI()
; Open the INI in Notepad.
	Run("notepad.exe MultiClip.ini")
EndFunc

Func Help()
; Open the readme in Notepad.
	Run("notepad.exe MultiClip_ReadMe.txt")
EndFunc

Func Quit()
  Exit
EndFunc
