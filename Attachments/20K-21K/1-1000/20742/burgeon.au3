#cs
Burgeon 1.06 Beta
Sean Randall <sean@randylaptop.com>
A hacked-together menu infrastructure, made for my removable 
disk.
Modified by Alex Hall, mehgcap@gwi.net. My comments will be 
denoted by ;; whereas the original author's will be the normal, 
single ;. I have left most of his code intact (there were no 
bugs) but I wanted a way of using the ini file to get information 
and display it in a MsgBox.
#ce
#include <Array.au3>
#include <GuiConstants.au3>
#include <GuiListBox.au3>
#include <ListBoxConstants.au3>
#include <misc.au3>
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
;#include "keyboard.au3"
#no tray icon
;stuff for speech:
global $usespeech = 0
global $speech = objCreate("sapi.spVoice")
if stringinstr($cmdlineraw,"/s") then global $usespeech =1
;everything in this program relies upon an INI file,
;so we have to get the name and check if it exists.
;the file is in the dir of the program and called progname.ini 
;(usually burgeon.ini)
;this approach means you can have more than one going in one 
;place.
global $file = stringTrimRight(@scriptfullpath,3) & "ini"
if fileGetSize($file) == 0 then
speak("Error!  This program cannot run because the file "& $file &" does not exist.  OK Button.",1)
msgBox(64,"Error","This program cannot run because the file "&$file&" does not exist.")
exit
endIf

;before we can create the main functions of the program
;we need functions.


;this function reads from the INI file.

func read($section,$key,$value = "")
$read = iniRead($file,$section,$key,$value)
if @error then return $value
$cmd = execute($read)

if @error then return $read
return $cmd
endFunc

;lets define how things are gonna start.


if $cmdline[0] == 0 then
;there are no command line parameters what soever, so just go.
showMenu()
else
if $cmdline[1] == "/s" then
;we want speech
global $usespeech = 1
$f = "main"
if $cmdline[0] == 2 then $f = $cmdline[2]
else
$f = $cmdline[1]
endIf
showmenu($f)

endIf


$oMyError = ObjEvent("AutoIt.Error","MyErrFunc")
Func MyErrFunc()
endFunc
;that handles that. ish, and we hope.
;lets make a speak function.
func speak ($text,$flags =3)
if $usespeech == 1 then
if not isDeclared($speech) then
global $speech = objCreate("sapi.spVoice")
endIf

$speech.speak($text,$flags)
endIf
endFunc

;now we may compose our GUI, but in a function so as to be able 
;to use a submenu.
func showMenu($id="main")
;lets get us a menu
$menuArray = iniReadSection($file,$id)

if @error then
;no menu, whoopsy bad.
speak("Error!  Unable to show menu "& $ID &".  OK Button",2)
msgBox(64,"Error!","Unable to read menu "& $id&".")
;if we can't read the main menu we have to die.
if $ID == "main" then exit
;else we go back to the main menu.
showMenu()
endIf
;set up the title and label.
$title = read($id,"title")
$label = read($id,"label")
;if there are none in provided menu, use defaults.
if $title == "" then $title = read("settings","Title","Burgeon")
if $label == "" then $label = read("Settings","label","Select an option.")
;gui time!
guiDelete()
;always good to clean up before you even start, if things might be dirty.
$ourwindow = guiCreate($title)
;make us a beautiful label!
guiCtrlCreateLabel($label,0,0,100,50)
;now we have to make our list!
$lstItems = GuiCtrlCreateList("",120,100, 180, 120,$lbs_sort)
;make sure it's got focus.
guiCtrlSetState(-1,$gui_focus)
;and now put our menu keys (aqa item names) in it.
    _GUICtrlListBox_BeginUpdate($lstItems)
for $counter = 1 to $menuArray[0][0]
$item = $menuarray[$counter][0]
if $item = "label" or $item = "title" then continueLoop
_GUICtrlListBox_AddString($lstItems,$item)

next
    _GUICtrlListBox_EndUpdate($lstItems)
;make go and exit buttons.
$btnGo = GuiCtrlCreateButton("&Go",350,100,10)
;make it default but unavailable until the list is used.
guiCtrlSetState(-1,$gui_defbutton+$gui_disable)
$btnExit = GuiCtrlCreateButton("e&xit",350,120,20)
$btnSpeech = GuiCtrlCreateButton("TTS "& _iif($usespeech=1,"off","on"),350,340)
;speak the intro stuff.
speak($title&".  "&$label&".  List box")
;stuff interspersed here is for the self voicing bits.
;we need to have holder variables for window,
$owf = $ourwindow
;and control
$ocf = ControlGetFocus("","")
GuiSetState()
do
$msg = GuiGetMsg()
;here be our cool control stuff!
$wf = WinGetHandle("","")
$cf = ControlGetFocus("","")

if $wf <> $owf then
;window has changed.
$owf = $wf
;user comes back to our window.
if $wf == $ourwindow then speak($title)
endIf
if $cf <> $ocf and $wf == $ourwindow then
;a control changed in our window.
$ocf = $cf
if _ispressed("^{i}") then
showMenu("internet")
endif


;here we can handle what's read with our various controls.

if $cf = "button1" then speak("Go Button")
if $cf = "button2" then speak("Exit Button")
if $cf = "button3" then speak(GuiCtrlRead($btnSpeech)&" button")
if $cf = "listbox1" then speak("Items List: "&GuiCtrlRead($lstitems))
endIf


;we need to enable the go button if user uses list.
if $msg = $lstItems then
guiCtrlSetState($btnGO,$gui_enable)
;and speak the item.
speak(GuiCtrlRead($msg))
endIf
;if they click go...
if $msg = $btnGo then
$item = GuiCtrlRead($lstItems)
;we need the command string.
$string = read($id,$item)

;we must decide what to do now.
;if the final character of the string is an _ then it is a menu.
if stringright($string,1) == "_" then
$string = StringTrimRight($string,1)


showMenu($string)
;;my addition: if the first 7 letters are msgbox call, trim that 
;;and pass string to msgbox()
;else
;if stringleft($string,7)=="msgbox(" then
;;get "msgbox(" off so I can call msgbox from here, then just pass 
;;that call this string
;$string=stringtrimleft($string,7)
;;get the ) off of string
;stringtrimright($string,1)
;;and finally pass string to msgbox call and show box
;MsgBox($string)
;Exit
else
;;not a msg or menu, so run it
;MsgBox(0,"test",$string)
Run(@COMSPEC & " /c Start " & $string)
$quit = read("settings","exitAfterClick",0)
if $quit == 1 then exit
endIf
EndIf
;EndIf
;if they click speech
if $msg = $btnSpeech then
if $usespeech == 1 then
speak("Speech Off.",2)
$usespeech = 0
else
$usespeech = 1
speak("Speech on")
endIf
GuiCtrlSetData($btnSpeech,"TTS "&_iif($usespeech = 1,"off","on"))
endIf
;let the ctrl key stop speech
if _IsPressed(11) then speak("")
until $msg = $gui_event_close or $msg = $btnexit
exit
endFunc
