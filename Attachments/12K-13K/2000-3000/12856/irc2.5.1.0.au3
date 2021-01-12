$starttimer = TimerInit()
#CS
________ PLANS ________________________________________________________________________________
	*Need to make an array with the room, and the people in the room and use it for the userlist not to have to refresh on room change
	* layer to copy full link
__________________ SITES _____________________________________________________________________
	                                                
	http://msdn.microsoft.com/library/default.asp?url=/workshop/browser/webbrowser/reference/properties/document.asp
_____________________________________________________________________________________________
	                                             
	                                        
	asimov.freenode.net
_________________NOTES______________________________________________________________________
	Getting values from text boxes:
	    	$textline='<input type="hidden" id="pixels" value="1">	  	The textbox
	   	$h_s=$oIE.document.getElementById("pixels").value ;		Accessing it
___________________________________________________________________________________________
#CE
If @Compiled Then
	Global $lines = 3515
EndIf
Global $version= "2.5.1.0"
global $autosettext=1
; ============= INCLUDE FILES ===================================
#include <Array.au3>
#Include <Constants.au3>
#Include <date.au3>
#include <file.au3>
#include <GuiCombo.au3>
#include <GuiConstants.au3>
#Include <GuiEdit.au3>
#Include <GuiList.au3>
#Include <GuiTab.au3>
#include <IE.au3>
#include <Misc.au3>
#include <Process.au3>
#include <String.au3>
;____________________ OPTIONS ____________________________________
;opt("SendKeyDelay", 1)
opt("GUICloseOnESC", 0)         ;1=ESC  closes, 0=ESC won't close
opt("GUIOnEventMode", 1)        ;0=disable, 1=enable

opt("TrayOnEventMode", 1)        ;0=disable, 1=enable
opt("TrayAutoPause", 0)          ;0=no pause, 1=Pause

opt("MouseCoordMode"  , 0)
opt("WinTitleMatchMode", 2)
;_______________________ DIRECTORY __________________________________
global $temptext=""
Global $scriptdir2 = @ScriptDir
global $path = @ProgramFilesDir & "\Adam1213\IRC"
Global $c4path = @ProgramFilesDir & "\Adam1213\Connect 4"

DirCreate($path)
DirCreate($c4path)
DirCreate($path & "\Logs")
DirCreate($path & "\Log")
DirCreate($path & "\Images")
FileChangeDir($path)
; _______________________ FILE INSTALL ___________________________
; --------------------------------------HELP FILE --------------------------------------------------
Global $helpfile = "help.chm"

FileInstall("IRC\Help\help.chm", $path & "\help.chm", 1)
FileInstall("IRC\Help\help.html", $path, 1)

FileInstall("IRC\autoit.jpg", $path & "\autoit.jpg", 1)
FileInstall("IRC\bar.gif", $path & "\bar.gif", 1)
FileInstall("IRC\chat-inbound.wav", $path & "\chat-inbound.wav", 1)
;_____________________ IMAGES (EMOTion ICONS)  __________________
FileInstall("Colours\0.bmp", $path & "\Images\",1)
FileInstall("Colours\1.bmp", $path & "\Images\",1)
FileInstall("Colours\2.bmp", $path & "\Images\",1)
FileInstall("Colours\3.bmp", $path & "\Images\",1)
FileInstall("Colours\4.bmp", $path & "\Images\",1)
FileInstall("Colours\5.bmp", $path & "\Images\",1)
FileInstall("Colours\6.bmp", $path & "\Images\",1)
FileInstall("Colours\7.bmp", $path & "\Images\",1)
FileInstall("Colours\8.bmp", $path & "\Images\",1)
FileInstall("Colours\9.bmp", $path & "\Images\",1)
FileInstall("Colours\10.bmp", $path & "\Images\",1)
FileInstall("Colours\11.bmp", $path & "\Images\",1)
FileInstall("Colours\12.bmp", $path & "\Images\",1)
FileInstall("Colours\13.bmp", $path & "\Images\",1)
FileInstall("Colours\14.bmp", $path & "\Images\",1)
FileInstall("Colours\15.bmp", $path & "\Images\",1)
FileInstall("Colours\bold.bmp", $path & "\Images\",1)
FileInstall("Colours\underline.bmp", $path & "\Images\",1)

FileInstall("Colours\brb.png", $path & "\Images\",1)
FileInstall("Colours\E\e1-1.png", $path & "\Images\",1)   ;  :)
FileInstall("Colours\E\e2-1.png", $path & "\Images\",1)  ; :(
FileInstall("Colours\E\e1-12.png", $path & "\Images\",1) ; LMAO
FileInstall("Colours\E\e8-1.png", $path & "\Images\",1) ; ;-) 
FileInstall("Colours\E\e1-9.png", $path & "\Images\",1) ; :-?

FileInstall("IRC\cog.ico", $path & "\Images\",1)
FileInstall("IRC\IRC.ico", $path & "\Images\",1)
FileInstall("IRC\settings_ico.bmp", $path & "\Images\",1)

;____________________ CONNECT 4 ________________________________
FileInstall("IRC\conframes.html",	$path,   1)
FileInstall("c41\con4app3.html",	$c4path, 1)
FileInstall("c41\con4arrow2.gif",	$c4path, 1)
FileInstall("c41\con4blank2.gif",	$c4path, 1)
FileInstall("c41\con4noarrow2.gif",	$c4path, 1)
FileInstall("c41\con4red2.gif",		$c4path, 1)
FileInstall("c41\con4yel2.gif",		$c4path, 1)
;____________________________Settings ___________________________________
$settingsplace = $path & "\settings.ini"

global $rightclick=0

Global $rrothershow = "off"
Global $quitreason = "0909,01 Adam1213's IRC Client www.cjb.cc/members/adam1213/update.exe - www.adam1213.tk 01"
Global $fullname=@UserName
Global $allowflash=0
global $clear_after_send=1

;Global $flash = "no"
;Global $ftimes = 4
;Global $fdelay = 1
$speakrecv=0;  
;_________________ Config __________________________________
$displayst=1
Global $pixelsperline=0
global $pixelsperlinecalebrated=0
global $entermode =1
global $showcolours=1
global $roomtimer="", $roomtimerwait=1
global $rawspecial="off"

global $comlock=""
global $soundon

$tcptimeout = IniRead($settingsplace, "Connection", "TCP Timeout", 100)
IniWrite($settingsplace, "Connection", "TCP Timeout", $tcptimeout)
opt("TCPTimeout",50)

global $chat12s="edit4"

global $c4open=0

Global $colour="", $ecolour = "</font>"
Global $textline=""
Global $nameslist
Global $lrecv
; ---------- Release date ---------------------------
$t = FileGetTime(@ScriptFullPath) ; Modified (default) get release date

If Not @error Then
	Global $releasedate = $t[2] & "/" & $t[1] & "/" & $t[0] ; [2] = day (range 01 - 31)/[1] = month (range 01 - 12)/[0] = year (four digits)
EndIf

Global $namesrequest = "no"
Global $connectparm = "no", $noattemptauto = "no", $fakeconnected = "off"

$dpass = "Your password will be encryped" ; default text for password
$passad = "PWD:"
$pass2 = "adam1213-encrpt"
$level = 2

Global $tabinfo="", $tabsel=""

Global $selected = ""

Global $rrname = "", $ssrecv = "", $rrmessage = "", $rrplace="", $rrother = "", $rrother2 = "", $deltext = "", $rrrnewname = ""

Global $failsafe
Global $rawsetschange="no"

ondefaults()

Global $save
Global $showtruesentm = "off", $norawshowtext = "off"
Global $rawonly = "off"

; ____________________________ TRAY _________________________________________________

TraySetToolTip("Adam1213's IRC Client")
TraySetIcon("Images\irc.ico")

TrayItemSetText($TRAY_ITEM_PAUSE, "Pause Program")

TrayCreateItem("")
$settingsitem = TrayCreateItem("Settings")
TrayItemSetOnEvent(-1, "onsettings")

$aboutitem = TrayCreateItem("About")
TrayItemSetOnEvent(-1, "onabout")

Global $lastkey = ""

;$exit = TrayCreateItem("Exit")
;TrayItemSetOnEvent(-1,"onexit")

TraySetPauseIcon("shell32.dll", 12)

; ============ MORE CONFIG ==================

;$fdelay = $fdelay * 1000

Global $lastplacechanged = "no"
$passadl = StringLen($passad) + 1
Global $connected = "no", $exit = "no", $fping = "0", $text = ""
Dim $sendtextb, $socket, $err, $g_IP

Global $recv

; ====================== REGISTRY =============================

$regplace = "HKEY_LOCAL_MACHINE\SOFTWARE\Adam1213 Software\IRC"
$regplace2 = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Regedit"

; ------------- Nick ---------------------
Global $nick = RegRead($regplace, "1 Nick")
If "t" & $nick = "t" Then
	$nick = @UserName & Random(1, 99, 1)
	RegWrite($regplace, "1 Nick", "REG_SZ", $nick)
EndIf

$newnick = $nick

; ------------- Name ---------------------
Global $name = RegRead($regplace, "2 Name")
If "t" & $name = "t" Then
	$name = @UserName & Random(1, 99, 1)
	RegWrite($regplace, "2 Name", "REG_SZ", $name)
EndIf

$name &= Random(1, 99, 1)

; ------------- Room ---------------------
Global $chatto = stringstripws(RegRead($regplace, "3 Room"),8)
If "t" & $chatto = "t" Then
	$chatto = "#adam1213"
	RegWrite($regplace, "3 Room", "REG_SZ", $chatto)
EndIf
Global $joinf = $chatto
Global $dchatto = $chatto

; ------------- server ---------------------
Global $server = RegRead($regplace, "4 Server")
If "t" & $server = "t" Then
	$server = "irc.freenode.net"
	RegWrite($regplace, "4 Server", "REG_SZ", $server)
EndIf

; ------------- Password ---------------------
Global $epassword = RegRead($regplace, "6 Password")
If "t" & $epassword = "t" Then
	$epassword = $dpass
	RegWrite($regplace, "6 Password", "REG_SZ", $epassword)
EndIf

; -------------- server name ----------------
	Global $vvserver = RegRead($regplace, "Server name")
	RegWrite($regplace, "Server name","REG_SZ",$vvserver)

;==================== INI SETTINGS =================
;Global $pixelsperline = IniRead($settingsplace, "Display \ chat log", "Pixels Per Line", "50") ; Number of pixels per line (used for scrolling)

Global $linelenmax = IniRead($settingsplace, "Display \ chat log", "Max Characters Per Line", "500") ; Number of characters per line (used for scrolling, if line is going to be split)

Global $bcolour = IniRead($settingsplace, "Display \ chat log", "Background Colour", "0xFFFFFF") ; white is the default
Global $tcolour = IniRead($settingsplace, "Display \ chat log", "Text Colour", "0x000000") ; black is the default

Global $fsize = IniRead($settingsplace, "Display \ chat log", "Text Size", "9")
Global $fweight = IniRead($settingsplace, "Display \ chat log", "Text Weight", "400")
Global $fattribute = IniRead($settingsplace, "Display \ chat log", "Text Attribute", " ")
Global $fontname = IniRead($settingsplace, "Display \ chat log", "Text Font", " ")


$filedest2=$path & "\Log\Console.html"
onfilemake($filedest2)

$filedest2=$path & "\Log\" & $chatto & ".html"
onfilemake($filedest2)

; ======================= Settings =============================================
$ssssdscroll = IniRead($settingsplace, "Settings", 'Auto scroll', $ssssdscroll)
$sssDSIRCRAWIRC = IniRead($settingsplace, "Settings", 'Raw IRC', $sssDSIRCRAWIRC)
$ssssdwordwrap = IniRead($settingsplace, "Settings", 'Word wrap', $ssssdwordwrap)
$sssDSIRCtray = IniRead($settingsplace, "Settings", 'Tray icon', $sssDSIRCtray)
$sssDSIRCPOPUP = IniRead($settingsplace, "Settings", 'Pop up', $sssDSIRCPOPUP)
global $sssDSIRCFlash = IniRead($settingsplace, "Settings", 'Flash', $sssDSIRCFlash)
$sssDSIRCSound = IniRead($settingsplace, "Settings", 'Sound', $sssDSIRCSound)
$ssssdsoundfile   = IniRead($settingsplace, "Settings", 'Sound file', $ssssdsoundfile)
$sssSDIRMRnickalert = IniRead($settingsplace, "Settings", "sssSDIRMRnickalert", $sssSDIRMRnickalert)
$sssscac = IniRead($settingsplace, "Settings", "sssscac", $sssscac)
$sssSOlog = IniRead($settingsplace, "Settings", "sssSOlog", $sssSOlog)
global $sssSDIRCMRtimes = IniRead($settingsplace, "Settings", "sssSDIRCMRtimes", $sssSDIRCMRtimes)
global $sssSDIRCMRdelay = IniRead($settingsplace, "Settings", "sssSDIRCMRdelay", $sssSDIRCMRdelay)
$sssSCport = IniRead($settingsplace, "Settings", "sssSCport", $sssSCport)
global $sssSCD = IniRead($settingsplace, "Settings", "sssSCD", $sssSCD)
$sssSCServer = IniRead($settingsplace, "Settings", "sssSCServer", $sssSCServer)
$ssslog = IniRead($settingsplace, "Settings", "ssslog", $ssslog)

;----------- Msgbox --------------------

If $sssDSIRCPOPUP = 1 Then
	$msgboxm = "on"
Else
	$msgboxm = "off"
EndIf

;----------- Tray --------------------
If $sssDSIRCtray = 1 Then
	$traym = "on"
Else
	$traym = "off"
EndIf

;----------- Raw --------------------
If $sssDSIRCRAWIRC = 1 Then
	global			$raw = "on"
Else
	global			$raw = "off"
EndIf


;--------- Scroll ----------
If $ssssdscroll = 1 Then	
	Global $scroll = "yes"
Else
	Global $scroll = "no"
EndIf

global $rawsplit="off"

Global $port = $sssSCport

If StringInStr($epassword, $passad) < 1 And $epassword <> $dpass Then
	$epassword = $passad & _StringEncrypt(1, $epassword, $pass2, $level) ; encrypt
	RegWrite($regplace, "6 Password", "REG_SZ", $epassword)
EndIf

$password = _StringEncrypt(0, StringMid($epassword, $passadl), $pass2, $level)

Global $connectatstart = "no"
If $sssscac = 1 Then $connectatstart = "yes" ; if it is 4 than it will be off

Global $text = "", $dtext = "", $textd = "", $sendtext=1, $showtext=1, $monly = "yes"

;=================== Main program =========================================
Global $title = "Adam1213's IRC Client"

;============================ GUI =========================================
$IRCGUIW = GUICreate($title, 800, 455, -1, -1, $WS_OVERLAPPEDWINDOW) ;$WS_VISIBLE
;630,455   (@DesktopWidth - 548) / 2, (@DesktopHeight - 410) / 2
GUISetIcon("Images\irc.ico")
GUISetHelp(@ComSpec & " /c echo a & "& _
		"cd " & $path & "\" & _
		"& Start " & $helpfile)

$filemenu = GUICtrlCreateMenu("&File")
$exititem = GUICtrlCreateMenuItem("E&xit", $filemenu)
GUICtrlSetOnEvent($exititem, "onexit")

$settingsm = GUICtrlCreateMenu("&Settings")
;GUICtrlSetOnEvent(-1, "onsettings")
$mmsettings22 = GUICtrlCreateMenuItem("&Settings", $settingsm)
GUICtrlSetOnEvent($mmsettings22, "onsettings")

global $userlist = GUICtrlCreateList("", 655, 40, 140, 365);,$LBS_SORT)

$helpmenu = GUICtrlCreateMenu("&help")
$helpitem = GUICtrlCreateMenuItem("&Help", $helpmenu)
$aboutitem = GUICtrlCreateMenuItem("&About", $helpmenu)
$updateitem = GUICtrlCreateMenuItem("&Update", $helpmenu)

GUICtrlSetOnEvent($helpitem, "onhelp")
GUICtrlSetOnEvent($aboutitem, "onabout")
GUICtrlSetOnEvent($updateitem, "onupdate")

$Label_2 = GUICtrlCreateLabel("Server:", 5, 4, 40, 14)     ;  Display server
Global $vserver = GUICtrlCreateCombo($server, 40, 2, 140, 12)     ; Input server
GUICtrlSetData(-1, "irc.freenode.net|chat.au.freenode.net|nsw-chat.bigpond.com", $server)
GUICtrlCreateLabel("Nick:", 190, 4, 26, 12)       ;  Display Nick
$vnick1e = GUICtrlCreateInput($nick, 225, 2, 90, 20)      ; Input Nick

GUICtrlCreateLabel("Room: ", 320, 5, 30, 12)      ;  Display Room
$vchatto = GUICtrlCreateInput($chatto & " + others", 355, 2, 100, 20,$ES_READONLY)      ; input room

$partbutton= GUICtrlCreateButton("Part", 450, 2, 40, 20) 
guictrlsetonevent($partbutton,"partbutton")

$joinbutton= GUICtrlCreateButton("Join a channel", 490, 2, 80, 20)
guictrlsetonevent($joinbutton,"joinbutton")

$dpassword = GUICtrlCreateButton("Password", 640, 2, 60, 20) ;   Button password

$connect = GUICtrlCreateButton("Connect", 570, 2, 65, 20) ;   Button connect
$connect2 = GUICtrlCreateButton("Connect", 640, 400, 50, 30) ;   Button connect

$filedest2=$path & "\Log\Console.html"

global $oIE = ObjCreate("Shell.Explorer.2")
Global $Edit_10 = GUICtrlCreateObj ($oIE, 10, 40,645, 345)
$oIE.navigate($filedest2)
$oIE.silent = 1
$oIE.StatusBar = True
GUICtrlSetResizing ($edit_10, $GUI_DOCKAUTO)

$chat12 = GUICtrlCreateinput("", 5, 392, 465, 40)          ; Input send
$sendtextb = GUICtrlCreateButton("Send", 560, 392, 70, 40,$BS_DEFPUSHBUTTON )    ;   Button send  560 470
Global $usersn = GUICtrlCreateLabel("Users: 0", 680, 400, 55, 100)     ;  Display users

GUICtrlSetOnEvent($sendtextb, "onsend")

;========================== TABS ==============================
global $tabarray[30]
global $listarray[30]

global $tabchan=GUICtrlCreateTab (5,20, 1015,585,$TCS_FLATBUTTONS + $TCS_FIXEDWIDTH  + $TCS_FOCUSNEVER)
GUICtrlSetOnEvent (-1, "ontabclick" )
$tabarray[_GUICtrlTabGetItemCount($tabchan)]="Console"
GUICtrlCreateTabitem ("Console")
$tabarray[_GUICtrlTabGetItemCount($tabchan)]=$chatto
GUICtrlCreateTabitem ($chatto)
GUICtrlCreateTabitem ("")

_GUICtrlTabSetCurSel($tabchan,0)

global $lasttab=$chatto
global $lasttab2=$chatto
ontabclick()

;global $userlistarray[30]


;================ END TABS ==============================

GUICtrlSetBkColor($Edit_10, $bcolour)
GUICtrlSetColor($Edit_10, $tcolour)
GUICtrlSetFont($Edit_10, $fsize, $fweight, $fattribute, $fontname)
;0x00000200  + $UDS_WRAP

GUICtrlSetOnEvent($connect, "onconnect")
GUICtrlSetOnEvent($connect2, "onconnect")
GUICtrlSetOnEvent($dpassword, "onpassword")

GUISetOnEvent($GUI_EVENT_CLOSE, "OnExit")
GUISetOnEvent($GUI_EVENT_SECONDARYDOWN, "Onrightclick")

$ctx=473
$cty=385
	$colour0 = GUICtrlCreateButton("0", $ctx, $cty, 23, 16, BitOR($BS_FLAT,$BS_BITMAP))
	GUICtrlSetImage($colour0, "Images\0.bmp")
	GUICtrlSetTip(-1, "0")
	GUICtrlSetCursor ($colour0, 0)
$ctx+=17
	$colour1 = GUICtrlCreateButton("1", $ctx, $cty, 23, 16, BitOR($BS_FLAT,$BS_BITMAP))
	GUICtrlSetImage($colour1, "Images\1.bmp")
	GUICtrlSetTip(-1, "1")
	GUICtrlSetCursor ($colour1, 1)
$ctx+=17
	$colour2 = GUICtrlCreateButton("2", $ctx, $cty, 23, 16, BitOR($BS_FLAT,$BS_BITMAP))
	GUICtrlSetImage($colour2, "Images\2.bmp")
	GUICtrlSetTip(-1, "2")
	GUICtrlSetCursor ($colour2, 1)
$ctx+=17
	$colour3 = GUICtrlCreateButton("3", $ctx, $cty, 23, 16, BitOR($BS_FLAT,$BS_BITMAP))
	GUICtrlSetImage($colour3, "Images\3.bmp")
	GUICtrlSetTip(-1, "3")
	GUICtrlSetCursor ($colour3, 1)
$ctx+=17
	$colourbold = GUICtrlCreateButton("B", $ctx, $cty, 23, 16, BitOR($BS_FLAT,$BS_BITMAP))
	GUICtrlSetImage($colourbold, "Images\bold.bmp")
	GUICtrlSetTip(-1, "Bold")
	GUICtrlSetCursor ($colourbold, 1)
$ctx=473
$cty=395
	$colour4 = GUICtrlCreateButton("4",  $ctx, $cty, 23, 16, BitOR($BS_FLAT,$BS_BITMAP))
	GUICtrlSetImage($colour4, "Images\4.bmp")
	GUICtrlSetTip(-1, "4")
	GUICtrlSetCursor ($colour4, 1)
$ctx+=17
	$colour5 = GUICtrlCreateButton("5",  $ctx, $cty, 23, 16, BitOR($BS_FLAT,$BS_BITMAP))
	GUICtrlSetImage($colour5, "Images\5.bmp")
	GUICtrlSetTip(-1, "5")
	GUICtrlSetCursor ($colour5, 1)
$ctx+=17
	$colour6 = GUICtrlCreateButton("6", $ctx, $cty, 23, 16, BitOR($BS_FLAT,$BS_BITMAP))
	GUICtrlSetImage($colour6, "Images\6.bmp")
	GUICtrlSetTip(-1, "6")
	GUICtrlSetCursor ($colour6, 1)
$ctx+=17
	$colour7 = GUICtrlCreateButton("7", $ctx, $cty, 23, 16, BitOR($BS_FLAT,$BS_BITMAP))
	GUICtrlSetImage($colour7, "Images\7.bmp")
	GUICtrlSetTip(-1, "7")
	GUICtrlSetCursor ($colour7, 1)
$ctx+=17
	$colourunderline = GUICtrlCreateButton("U", $ctx, $cty, 23, 16, BitOR($BS_FLAT,$BS_BITMAP))
	GUICtrlSetImage($colourunderline, "Images\underline.bmp")
	GUICtrlSetTip(-1, "Underline")
	GUICtrlSetCursor ($colourunderline, 1)
$ctx=473
$cty=405
	$colour8 = GUICtrlCreateButton("8", $ctx, $cty, 23, 16, BitOR($BS_FLAT,$BS_BITMAP))
	GUICtrlSetImage($colour8, "Images\8.bmp")
	GUICtrlSetTip(-1, "8")
	GUICtrlSetCursor ($colour8, 8)
$ctx+=17
	$colour9 = GUICtrlCreateButton("9", $ctx, $cty, 23, 16, BitOR($BS_FLAT,$BS_BITMAP))
	GUICtrlSetImage($colour9, "Images\9.bmp")
	GUICtrlSetTip(-1, "9")
	GUICtrlSetCursor ($colour9, 1)
$ctx+=17
	$colour10 = GUICtrlCreateButton("10", $ctx, $cty, 23, 16, BitOR($BS_FLAT,$BS_BITMAP))
	GUICtrlSetImage($colour10, "Images\10.bmp")
	GUICtrlSetTip(-1, "10")
	GUICtrlSetCursor ($colour10, 1)
$ctx+=17
	$colour11 = GUICtrlCreateButton("11)", $ctx, $cty, 23, 16, BitOR($BS_FLAT,$BS_BITMAP))
	GUICtrlSetImage($colour11, "Images\11.bmp")
	GUICtrlSetTip(-1, "11")
	GUICtrlSetCursor ($colour11, 1)
$ctx+=17
	$coloure1 = GUICtrlCreateButton(":-)", $ctx, $cty, 23, 16, BitOR($BS_FLAT,$BS_BITMAP))
	GUICtrlSetImage($coloure1, "Images\e1.bmp")
	GUICtrlSetTip(-1, ":-)")
	GUICtrlSetCursor ($coloure1, 1)
$ctx=473
$cty=415
	$colour12 = GUICtrlCreateButton("12", $ctx, $cty, 23, 16, BitOR($BS_FLAT,$BS_BITMAP))
	GUICtrlSetImage($colour12, "Images\12.bmp")
	GUICtrlSetTip(-1, "12")
	GUICtrlSetCursor ($colour12, 1)
$ctx+=17	
	$colour13 = GUICtrlCreateButton("13", $ctx, $cty, 23, 16, BitOR($BS_FLAT,$BS_BITMAP))
	GUICtrlSetImage($colour13, "Images\13.bmp")
	GUICtrlSetTip(-1, "13")
	GUICtrlSetCursor ($colour13, 1)
$ctx+=17	
	$colour14 = GUICtrlCreateButton("14)", $ctx, $cty, 23, 16, BitOR($BS_FLAT,$BS_BITMAP))
	GUICtrlSetImage($colour14, "Images\14.bmp")
	GUICtrlSetTip(-1, "14")
	GUICtrlSetCursor ($colour14, 1)
$ctx+=17	
	$colour15 = GUICtrlCreateButton("15", $ctx, $cty, 23, 16, BitOR($BS_FLAT,$BS_BITMAP))
	GUICtrlSetImage($colour15, "Images\15.bmp")
	GUICtrlSetTip(-1, "15")
	GUICtrlSetCursor ($colour15, 1)
$ctx+=17
	$coloure28 = GUICtrlCreateButton(":-(", $ctx, $cty, 23, 16, BitOR($BS_FLAT,$BS_BITMAP))
	GUICtrlSetImage($coloure28, "Images\e28.bmp")
	GUICtrlSetTip(-1, ":-(")
	GUICtrlSetCursor ($coloure28, 1)

GUICtrlSetOnEvent($colour0,  "oncolour0" )
GUICtrlSetOnEvent($colour1,  "oncolour1" )
GUICtrlSetOnEvent($colour2,  "oncolour2" )
GUICtrlSetOnEvent($colour3,   "oncolour3" )
GUICtrlSetOnEvent($colour4,   "oncolour4")
GUICtrlSetOnEvent($colour5,   "oncolour5" )
GUICtrlSetOnEvent($colour6,   "oncolour6" )
GUICtrlSetOnEvent($colour7,   "oncolour7" )
GUICtrlSetOnEvent($colour8,  "oncolour8"  )
GUICtrlSetOnEvent($colour9,  "oncolour9"  )
GUICtrlSetOnEvent($colour10, "oncolour10")
GUICtrlSetOnEvent($colour11, "oncolour11")
GUICtrlSetOnEvent($colour12, "oncolour12")
GUICtrlSetOnEvent($colour13, "oncolour13")
GUICtrlSetOnEvent($colour14, "oncolour14")
GUICtrlSetOnEvent($colour15, "oncolour15")

GUICtrlSetOnEvent($colourbold, "oncolourbold")
GUICtrlSetOnEvent($colourunderline, "oncolourunderline")

GUICtrlSetOnEvent($coloure1, "oncoloure1")
GUICtrlSetOnEvent($coloure28, "oncoloure28")

;$userlist     = GUICtrlCreateButton("&Options", 400, 10, 70, 20, $BS_FLAT)

;=============== USER LIST MENU =================================

; At first create a dummy control for the options and a contextmenu for it
; At first create a dummy control for the options and a contextmenu for it


$OptionsDummy   = GUICtrlCreateDummy()
$OptionsContext = GUICtrlCreateContextMenu($optionsdummy) ;$userlist

$optionmessage = GUICtrlCreateMenuItem("Message", $OptionsContext)
GUICtrlCreateMenuItem("", $OptionsContext)
$OptionsWhois = GUICtrlCreateMenuItem("Whois", $OptionsContext)
$Optionscontrol = GUICtrlCreateMenu("Control", $OptionsContext, $OptionsContext)
$Optionsop = GUICtrlCreateMenuItem("Op ", $Optionscontrol)
$Optionsdeop = GUICtrlCreateMenuItem("Deop", $Optionscontrol)
$Optionsvoice = GUICtrlCreateMenuItem("Voice", $Optionscontrol)
$Optionsdevoice = GUICtrlCreateMenuItem("Devoice", $Optionscontrol)
$Optionskick = GUICtrlCreateMenuItem("Kick", $Optionscontrol)
$Optionsban = GUICtrlCreateMenuItem("Ban", $Optionscontrol)
$Optionsbankick = GUICtrlCreateMenuItem("Ban, Kick", $Optionscontrol)
$Optionssilence = GUICtrlCreateMenuItem("Silence", $Optionscontrol)
$Optionssilencer = GUICtrlCreateMenuItem("Un silence", $Optionscontrol)
GUICtrlCreateMenuItem("", $OptionsContext)
$Optionsslap = GUICtrlCreateMenuItem("Slap!", $OptionsContext)

GUICtrlSetOnEvent($userlist, "onoptions")


GUICtrlSetOnEvent($optionmessage, "onoptmessage")
GUICtrlSetOnEvent($OptionsWhois, "whois")

GUICtrlSetOnEvent($Optionsop, "onop")
GUICtrlSetOnEvent($Optionsdeop, "ondeop")

GUICtrlSetOnEvent($Optionsvoice, "onvoice")
GUICtrlSetOnEvent($Optionsdevoice, "ondevoice")

GUICtrlSetOnEvent($Optionskick, "onkick")

GUICtrlSetOnEvent($Optionssilence, "onsilence")
GUICtrlSetOnEvent($Optionssilencer, "onsilencer")

GUICtrlSetOnEvent($Optionsban, "onban")
GUICtrlSetOnEvent($Optionsbankick, "onbankick")

GUICtrlSetOnEvent($Optionsslap, "onslap")

;============= CONNECT MENU ===============================

$connectContext = GUICtrlCreateContextMenu($connect)
GUICtrlCreateMenuItem("Reconnect", $connectcontext)
GUICtrlSetOnEvent(-1, "onreconnect")

$connectContext2 = GUICtrlCreateContextMenu($connect2)
GUICtrlCreateMenuItem("Reconnect", $connectcontext2)
GUICtrlSetOnEvent(-1, "onreconnect")

func onreconnect()
	onsend("/connect")
endfunc

;=============== TAB MENU =================================

; At first create a dummy control for the options and a contextmenu for it
$tabchanContext = GUICtrlCreateContextMenu($tabchan)

GUICtrlCreateMenuItem("Part", $tabchanContext)
GUICtrlSetOnEvent(-1, "ontabchanmpart")
GUICtrlCreateMenuItem("Rejoin", $tabchanContext)
GUICtrlSetOnEvent(-1, "ontabchanmrejoin")
GUICtrlCreateMenuItem("", $tabchanContext)
GUICtrlCreateMenuItem("Clear", $tabchanContext)
GUICtrlSetOnEvent(-1, "ontabchanmclear")
$tabchanmnames = GUICtrlCreateMenuItem("Names", $tabchanContext)
GUICtrlSetOnEvent(-1, "ontabchanmnames")

func ontabchanmpart()
	ontabclick()
	onsend("/part")
endfunc

func ontabchanmrejoin()
	onsend("/join")
endfunc

func ontabchanmclear()
	ontabclick()
	onsend("/clear")
endfunc

func ontabchanmnames()
	ontabclick()
	onsend("/namesc")
endfunc


;======================= RIGHT CLICK =============================
global $rightclick=0
func Onrightclick()
	$rightclick=1
	MouseClick ("primary")
endfunc

;GUISetBkColor (0xCDE1FF)

GUISetState()
guisetstate(@SW_MAXIMIZE)
_GUICtrlComboSetExtendedUI ($vserver, 1)

GUICtrlSetState($chat12, $GUI_FOCUS)
;GUICtrlSetState($chat12, $GUI_DEFBUTTON)

if $entermode then HotKeySet("{Enter}", "EnterSends");register hotkey when our GUI messenger window is active

GUICtrlSetData($vchatto, $chatto) 

; ================== END OF GUI ===========================================================

$begin = TimerInit()

;=========== CMD LINE ===================
If $CmdLine[0] > 0 Then
	If $CmdLine[1] = "autoconnect" Then
		$connectparm = "yes"
		if $CmdLine[0]>1 then
			if $CmdLine[2] <> $server AND $CmdLine[2] <> "console" then $chatto = $CmdLine[2]
		Global $joinf = $chatto
		Global $dchatto = $chatto
		endif
	EndIf
	
	If $CmdLine[1] = "fakeconnected" Then
		$text = "fakeconnect"
		oncommands()
	$textline= "[" & @HOUR & ":" & @MIN & "]  " & $dtext & @CRLF
	onchatlog ($textline)
	EndIf
	
	If StringInStr($CmdLine[1], "#") then
	if  $CmdLine[1] <> $server AND $CmdLine[1] <> "console" then $chatto = $CmdLine[1]
	endif
	ontabclick()
	GUICtrlSetData($vchatto, $chatto) 

EndIf

$objwait = TimerInit()
while not IsObj($oie)
	sleep(5)
	if TimerDiff($objwait)>3000 then 
		msgbox(0,"ERROR", "Failed to make a com object",5)
	endif
wend
dim $objwait ; clear it

GUISetState(@SW_LOCK, $IRCGUIW)
GUISetState()

;$dif = TimerDiff($starttimer)/1000
;MsgBox(0,"Time Difference",$dif)

While $exit = "no"

	if $c4open then onc4update()
	
	Sleep(10)
	;if $roomtimerwait AND timerDiff($roomtimer)/1000>2000  then
	
	If $connected = "no" And $noattemptauto = "no" Then
		If $connectparm = "yes" Then
			 onconnect()
		else
			If $connectatstart = "yes" And TimerDiff($begin) / 1000 > $sssSCD Then onconnect()
		Endif
	EndIf

		
	;--------------the socket Recv ------------------------------
	$recv = TCPRecv($socket, 512)
	;------------------call socket recv func-------------------------
	If $recv <> "" Then recv($Edit_10)
	;--------------end socket Recv f----------------------------------
WEnd
Onsaveinfo()

;___________________ FUNCTIONS _________________________________________________________
; ======================= CHAT LOG ================================
func onchatlog($textline)
	$textline2=$textline

	$tabinfo=""
	$tabsel=""
	$rrplace=stringstripws($rrplace,3)
	$pos=1
	$pos=_ArraySearch($tabArray, $rrplace)
	if $pos=-1 OR $rrplace="" then 
		$rrplace="Console"
		$filedest2=$path & "\Log\Console.html"
		$pos=_ArraySearch($tabArray, $rrplace)
	endif

	$tabsel2=_GUICtrlTabGetCurSel($tabchan)
	if $tabsel2>-1 then
		 $tabinfo=$tabarray[$tabsel2]
	else
		$tabinfo=guictrlread($vserver)
	endif
	$filedest2=$path & "\Log\" & $rrplace & ".html"

	$rrmessage=$textline2
	onhyperlinks()
	$textline2=$rrmessage

	$textline2=StringReplace ($textline2,  @CRLF, "@CRLF@")
	$textline2=StringReplace ($textline2, @CR,    "@CRLF@")
	$textline2=StringReplace ($textline2, @LF,     "@CRLF@")
	$textline2=StringReplace ($textline2, "@CRLF@", "</br>" & @CRLF)
	$scrolllines=@extended
	$textline2=StringReplace ($textline2, "@CRLF", @CRLF)
	
	global $textline3=$textline2 & @CRLF
	$linespiltnow=0

	FileWrite ($filedest2, $textline2) 	;$oIE.Document.WriteLn ("aaaa")

	if $rrplace=$tabinfo then 	
		;SoundSetWaveVolume(0)
		If $c4open Then
			$oIE.navigate("javascript:parent.chatframe.location.reload();")
			sleep(10)
			while $oIE.Busy
				sleep(1)
			wend
		Else
			;$oIE.Document.Writeln ($textline2) ;
	$oIE.refresh 
		EndIf
		;$oIE.navigate("javascript:<BODY onLoad=window.setTimeout("location.href='next-page.html'",10000)>")
	
		if $scroll="yes" then
			while stringinstr($textline3,@CRLF)>0
				$spplace=stringinstr($textline3,@CRLF)
				$spline=stringleft($textline3,$spplace+1)
				$textline3 =stringright($textline3,$spplace)
				if stringlen($spline)>$linelenmax then $scrolllines+=1
			wend
			if $pixelsperlinecalebrated=0 AND $pixelsperline=0 then Oncalabratepixelsperline(1)
			;traytip('lines to scroll', $scrolllines, 10,16) ; ########################!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			$scrollcom="javascript:scrollBy(0," & $scrolllines*$pixelsperline & ")"
			If $c4open Then
				$scrollcom="javascript:parent.chatframe.scrollBy(0," & $scrolllines*$pixelsperline & ")"
			EndIf
			$oIE.navigate($scrollcom)
		endif
	endif
;	GUICtrlSetState($chat12, $GUI_FOCUS)
;	If WinActive($IRCGUIW) Then ControlSend ($title, "", $chat12s, "{end}")
endfunc

; ==================== Hyperlinks and colours ======================
func onhyperlinks()
; ------------------------------------- HYPERLINKS ---------------

	; _convertHyper takes a string and returns the string with the "www." addresses as links.

	$workmessage = $rrmessage & " " ;										 "start www.adam1213.tk end "
	$workmessage = StringReplace($workmessage, "http://www.", "www.")
	$workmessage = StringReplace($workmessage, "http://", "www.")
	Local $dumpmsg = ""
	Local $finmessage
	Local $tempmsg
	Local $noweb = 1
	While StringInStr($workmessage,"www.") <> 0
		$noweb = 0
		$dumpmsg &= StringTrimRight($workmessage,StringLen($workmessage)-StringInStr($workmessage,"www.")+1) ;	"start "
		$workmessage = StringTrimLeft($workmessage,StringInStr($workmessage,"www.")-1) ;				"www.adam1213.tk end "
		$tempmsg = StringTrimRight($workmessage,StringLen($workmessage)-StringInStr($workmessage," ")+1) ;	"www.adam1213.tk"

		$tempmsg2=stringreplace($tempmsg,"","") ;

		$workmessage = StringReplace($workmessage,$tempmsg,"<a href='http://"&$tempmsg2 &"'>" & $tempmsg & "</a>",1); "<a href='                       '>www.adam1213.tk</a> end "
		$dumpmsg &= StringTrimRight($workmessage,StringLen($workmessage)-StringInStr($workmessage,"</a>")-3) ; 	"start <a href='                       '>www.adam1213.tk</a>"
		$workmessage = StringTrimLeft($workmessage,StringInStr($workmessage,"</a>")+3) ;				" end "
		If StringInStr($workmessage,"www.") == 0 Then
			$dumpmsg &= $workmessage
		EndIf
	Wend
	If $noweb Then
		$rrmessage = $workmessage
	Else
		$rrmessage = $dumpmsg
	EndIf

;	 ------------ Wikipedia links ---------------------------------------
	$workmessage = $rrmessage & " " ; "start start [[a]] end "
	Local $dumpmsg = "";                                     ^^
	Local $finmessage
	Local $tempmsg
	Local $noweb = 1
	While StringInStr($workmessage,"[[") <> 0
		$noweb = 0
		$dumpmsg &= StringTrimRight($workmessage,StringLen($workmessage)-StringInStr($workmessage,"[[")+1) ;	"start "
		$workmessage = StringTrimLeft($workmessage,StringInStr($workmessage,"[[")-1) 
		$tempmsg = StringTrimRight($workmessage,StringLen($workmessage)-StringInStr($workmessage,"]]")-1) ;	"www.adam1213.tk"
		$tempmsg2="http://en.wikipedia.org/wiki/Special:Search?search=" & stringmid($tempmsg,3,stringlen($tempmsg)-4)
		$workmessage = StringReplace($workmessage,$tempmsg,"<a href='"& $tempmsg2 &"'>"& $tempmsg &"</a>",1); "<a href='                       '>www.adam1213.tk</a> end "
		$dumpmsg &= StringTrimRight($workmessage,StringLen($workmessage)-StringInStr($workmessage,"</a>")-3) ; 	"start <a href='                       '>www.adam1213.tk</a>"
		$workmessage = StringTrimLeft($workmessage,StringInStr($workmessage,"</a>")+3) ;				" end "
		If StringInStr($workmessage,"[[") == 0 Then $dumpmsg &= $workmessage
	Wend
	If $noweb Then
		$rrmessage = $workmessage ; www. not found
	Else
		$rrmessage = $dumpmsg ;      www. found!
	EndIf

if $showcolours then
; =================== colour ======================================================

	$workmessage = $rrmessage & " " ;

	$workmessage = $rrmessage & "" 
	Local $dumpmsg = ""
	Local $finmessage
	Local $tempmsg
	Local $noweb = 1
	While StringInStr($workmessage,"") <> 0
		$noweb = 0
		$ucolour=""
		$cpplace=stringinstr($workmessage, "")
		$dumpmsg &= StringTrimRight($workmessage,StringLen($workmessage)-$cpplace+1) ;	"start "
		$workmessage = StringTrimLeft($workmessage,$cpplace -1) ;
		$tempmsg = StringTrimRight($workmessage,StringLen($workmessage)-StringInStr($workmessage,"",0,2)+1) 
		$tempmsg3=$tempmsg
		if stringinstr($tempmsg,"") = 1 then
		
			$tempmsg2=stringmid($tempmsg,2)
	
			$digits=2
			$colourc=""
			while $digits>0
				$colourc=stringleft($tempmsg2,$digits)
				if StringIsdigit ($colourc) then exitloop
				$digits-=1
			wend
			$tempmsg3=stringmid($tempmsg,$digits+2)
	
			if $colourc<>"" then $colourc=$colourc+1-1

			switch $colourc
				case "0"
					$ucolour="#FFFFFF"
				case "1"
					$ucolour="#000000"
				case "2"
					$ucolour="#00007F"
				case "3"
					$ucolour="#009300"
				case "4"
					$ucolour="#FF0000"
				case "5"
					$ucolour="#7F0000"
				case "6"
					$ucolour="#9C009C"
				case "7"
					$ucolour="#FC7F00"
				case "8"
					$ucolour="#FFFF00"
				case "9"
					$ucolour="#00FC00"
				case "10"
					$ucolour="#009393"
				case "11"
					$ucolour="#00FFFF"
				case "12"
					$ucolour="#0000FC"
				case "13"
					$ucolour="#FF00FF"
				case "14"
					$ucolour="#7F7F7F"
				case "15"
					$ucolour="#D2D2D2"
	
			endswitch

		; ---------------------------- background colour -------------------------------------
			if stringinstr($tempmsg3,",")=1 then
	
				$tempmsg3=stringmid($tempmsg3,2)
		
				$digits=2
				$colourb=""
				while $digits>0
					$colourb=stringleft($tempmsg3,$digits)
					if StringIsdigit ($colourb) then exitloop
					$digits-=1
				wend

				$tempmsg3=stringmid($tempmsg3,$digits+1)

				if $colourb<>"" then $colourb=$colourb+1-1
	
				switch $colourb
					case "0"
						$bcolour="#FFFFFF"
					case "1"
						$bcolour="#000000"
					case "2"
						$bcolour="#00007F"
					case "3"
						$bcolour="#009300"
					case "4"
						$bcolour="#FF0000"
					case "5"
						$bcolour="#7F0000"
					case "6"
						$bcolour="#9C009C"
					case "7"
						$bcolour="#FC7F00"
					case "8"
						$bcolour="#FFFF00"
					case "9"
						$bcolour="#00FC00"
					case "10"
						$bcolour="#009393"
					case "11"
						$bcolour="#00FFFF"
					case "12"
						$bcolour="#0000FC"
					case "13"
						$bcolour="#FF00FF"
					case "14"
						$bcolour="#7F7F7F"
					case "15"
						$bcolour="#D2D2D2"	
				endswitch
	
			endif	
		endif


		$workmessage = StringReplace($workmessage,$tempmsg, "<font color=""" & $ucolour & """><span style=""background-color: " & $bcolour & """>" & $tempmsg3 & "</font></span>",1)
		$dumpmsg &= StringTrimRight($workmessage,StringLen($workmessage)-StringInStr($workmessage,"</font>")-3)
		$workmessage = StringTrimLeft($workmessage,StringInStr($workmessage,"</font>")+3)

		If StringInStr($workmessage,"") == 0 Then
			$dumpmsg &= $workmessage
		EndIf
	Wend
	If $noweb Then
			$rrmessage = $workmessage
		Else
			$rrmessage = $dumpmsg
		EndIf

	$rrmessage=stringreplace($rrmessage,":)",  ":-)"  )
	$rrmessage=stringreplace($rrmessage,":(",  ":-(" )

	$rrmessage=stringreplace($rrmessage,"brb","<img border=""0""  src=""Images/brb.PNG"" width=""14"" height=""16"">")
	$rrmessage=stringreplace($rrmessage,":-)", "<img border=""0"" src=""Images/e1-1.jpg"" width=""16"" height=""16"">")
	$rrmessage=stringreplace($rrmessage,":-(", "<img border=""0"" src=""Images/e2-1.jpg"" width=""16"" height=""16"">")
	$rrmessage=stringreplace($rrmessage,"LMAO", "<img border=""0"" src=""Images/e1-12.jpg"" width=""16"" height=""16"">")
	$rrmessage=stringreplace($rrmessage,":-?", "<img border=""0"" src=""Images/e8-9.bmp"" width=""16"" height=""16"">")

;========================= BOLD ================================
	$workmessage = $rrmessage & " "  ; - bold
	Local $dumpmsg = ""
	Local $finmessage
	Local $tempmsg
	Local $noweb = 1
	While StringInStr($workmessage,"") <> 0
		$noweb = 0
		$ucolour=""
		$cpplace=stringinstr($workmessage, "")
		$dumpmsg &= StringTrimRight($workmessage,StringLen($workmessage)-$cpplace+1) ;	"start "
		$workmessage = StringTrimLeft($workmessage,$cpplace -1) ;
		$tempmsg = StringTrimRight($workmessage,StringLen($workmessage)-StringInStr($workmessage,"",0,2)+1) 
		$tempmsg3=$tempmsg
		if stringinstr($tempmsg,"") = 1 then
			$tempmsg3=stringmid($tempmsg,2)
		endif
		$workmessage = StringReplace($workmessage,$tempmsg, "<b>" & $tempmsg3 & "</b>",1)
		$dumpmsg &= StringTrimRight($workmessage,StringLen($workmessage)-StringInStr($workmessage,"</b>")-3)
		$workmessage = StringTrimLeft($workmessage,StringInStr($workmessage,"</b>")+3)

		If StringInStr($workmessage,"") == 0 Then
			$dumpmsg &= $workmessage
		EndIf
	Wend
	If $noweb Then
		$rrmessage = $workmessage
	Else
		$rrmessage = $dumpmsg
	EndIf

	;========================= Underline ================================
	$workmessage = $rrmessage & " "  ; - underline
	Local $dumpmsg = ""
	Local $finmessage
	Local $tempmsg
	Local $noweb = 1
	While StringInStr($workmessage,"") <> 0
		$noweb = 0
		$ucolour=""
		$cpplace=stringinstr($workmessage, "")
		$dumpmsg &= StringTrimRight($workmessage,StringLen($workmessage)-$cpplace+1) ;	"start "
		$workmessage = StringTrimLeft($workmessage,$cpplace -1) ;
		$tempmsg = StringTrimRight($workmessage,StringLen($workmessage)-StringInStr($workmessage,"",0,2)+1) 
		$tempmsg3=$tempmsg
		if stringinstr($tempmsg,"") = 1 then
			$tempmsg3=stringmid($tempmsg,2)
		endif
		$workmessage = StringReplace($workmessage,$tempmsg, "<u>" & $tempmsg3 & "</u>",1)
		$dumpmsg &= StringTrimRight($workmessage,StringLen($workmessage)-StringInStr($workmessage,"</u>")-3)
		$workmessage = StringTrimLeft($workmessage,StringInStr($workmessage,"</u>")+3)

		If StringInStr($workmessage,"") == 0 Then
			$dumpmsg &= $workmessage
		EndIf
	Wend
	If $noweb Then
			$rrmessage = $workmessage
		Else
			$rrmessage = $dumpmsg
		EndIf

endif
	if $rawspecial="off" then

		$rrmessage=stringreplace ($rrmessage,"", "")
		$rrmessage=stringreplace ($rrmessage,"", "")
		$rrmessage=stringreplace ($rrmessage,"", "")
		$rrmessage=stringreplace ($rrmessage,"", "")
	endif

endfunc

;========================= LIST OPTIONS ==================================================
Func onselectinfo()
	Global $idleb = TimerInit()
	$selected = _GUICtrlListGetSelItemsText ($userlist)
	$selected = $selected[1]
	If StringInStr($selected, "@") Or StringInStr($selected, "+") Then $selected = StringMid($selected, 2)
EndFunc   ;==>onselectinfo

Func onoptmessage()
	onselectinfo()
	;TCPSend($socket, "whois " & $selected & @CRLF) ; Send to the IRC server that you have quit and a quit reason
	$textline="Message """ & $selected & """ (Messaging is for future use)" & @CRLF
	onchatlog ($textline)
EndFunc   ;==>whois

Func whois()
	onselectinfo()
	TCPSend($socket, "whois " & $selected & @CRLF) ; Send to the IRC server that you have quit and a quit reason
	$textline="Whois request on " & $selected & @CRLF
	onchatlog ($textline)
EndFunc   ;==>whois

Func onop() ; when you pick op  - /mode #channel +o nickname
	onselectinfo()
	If $selected = $newnick Then
		TCPSend($socket, "privmsg chanserv : op " & $chatto & @CRLF)
	Else
		TCPSend($socket, "mode " & $chatto & " +o " & $selected & @CRLF)
	EndIf
	
	$textline="Opped " & $selected & @CRLF
	onchatlog ($textline)
endfunc

Func ondeop() ; when you pick deop
	onselectinfo()
	TCPSend($socket, "mode " & $chatto & " -o " & $selected & @CRLF)
	$textline="Deopped " & $selected & @CRLF
	onchatlog ($textline)
endfunc () ;

Func onvoice()
	onselectinfo()
	TCPSend($socket, "mode " & $chatto & " +v " & $selected & @CRLF)
	$textline="Voiced " & $selected & @CRLF
	onchatlog ($textline)
endfunc ()

Func ondevoice() ; when you pick deop
	onselectinfo()
	TCPSend($socket, "mode " & $chatto & " -v " & $selected & @CRLF)
	$textline="Devoiced " & $selected & @CRLF
	onchatlog ($textline)
endfunc ()

Func onkick() ; when you pick kick
	onselectinfo()
	TCPSend($socket, "kick " & $chatto & " " & $selected & @CRLF)
	$textline="Kicked " & $selected & @CRLF
	onchatlog ($textline)
endfunc ()

Func onban() ; when you pick ban
	onselectinfo()
	TCPSend($socket, "mode " & $chatto & " +b " & $selected & @CRLF)
	$textline="Has been banned " & $selected & @CRLF
	onchatlog ($textline)
endfunc ()

Func onbankick() ; when you pick ban kick
	onselectinfo()
	TCPSend($socket, "mode " & $chatto & " +b " & $selected & @CRLF & "Kick " & $chatto & " " & $selected & @CRLF) ;mode #adam1213 +q nick
	$textline="Has been ban kicked " & $selected & @CRLF
	onchatlog ($textline)
endfunc ()

Func onsilence() ; when you pick silence
	onselectinfo()
	TCPSend($socket, "mode " & $chatto & " +q " & $selected & @CRLF)
	$textline= "Silienced " & $selected & @CRLF
	onchatlog ($textline)
endfunc ()

Func onsilencer() ; when you pick un silence
	onselectinfo()
	TCPSend($socket, "mode " & $chatto & " -q " & $selected & @CRLF)
$textline= "Un silienced " & $selected & @CRLF
	onchatlog ($textline)
endfunc ()

Func onoptions()
	ShowMenu($IRCGUIW, $userlist, $OptionsContext)
EndFunc   ;==>onoptions

Func onslap() ; when you pick slap
	onselectinfo()
	onsend("/slap " & $selected)
endfunc ()

;________________________ on CONNECT _______________________________________
Func onconnect()
	
	;global $firstenter="no"

	Global $idleb = TimerInit()
	HotKeySet("{Enter}"); Un register hotkey to prevent enter not working during connection
	If $connected = "yes" Then
		ondisconnect()
	EndIf	

	$connected = "yes"
	GUICtrlSetData($connect,"Disconnect")
	GUICtrlSetData($connect2,"Disconnect")
	GUICtrlSetOnEvent($connect, "ondisconnect")
	GUICtrlSetOnEvent($connect2, "ondisconnect")

	;GUICtrlSetState($chat12, $GUI_FOCUS)
	GUICtrlSetState($chat12, $GUI_DEFBUTTON)
	;$begin = TimerInit()

	$textline="<p align=""center""><img border=""0"" src=""bar.gif"" width=""754"" height=""4"">" & @CRLF & _
	"<font color=""#00FF00""><span style=""font-weight: 700; background: #000000"">---CONNECTING---</span></font></p> @CRLF"
	onchatlog ($textline)
	$g_IP = $g_IP
	
	;$vserver=GUICtrlRead($vserver) ; check that the IRC server can be found to prevent freezing while attempting to connect
	$attempts = 0
	$found = "no"
	
	
	TCPStartup()
	;GUICtrlSetState(-1, $GUI_FOCUS)
	;----name to number isp---au3 can only use number isp---------------------
	$g_IP = TCPNameToIP(GUICtrlRead($vserver))
	; ------------- server name ---------------------
	$vvvserver= GUICtrlRead($vserver)
	if $vvserver="" then $vvserver = $vvvserver
	if $vvvserver="chat.au.freenode.net" then $vvserver="asimov.freenode.net"
	;$tabarray[0]=$vvvserver
	;$port=GUICtrlRead($vPorte)
	$socket = TCPConnect($g_IP, $port)
	If $socket = 1 Then Exit
	;--------winsettitle sends connect to the gui title-when connected------------------------------
	$title = "Establishing connection - Adam1213's IRC Client"
	WinSetTitle($IRCGUIW, "", $title)
	;------------tcp send the user and nick commands on conenct----------------
	$nick = GUICtrlRead($vnick1e)
	TCPSend($socket, "NICK " & $nick & @CRLF)
	TCPSend($socket, "USER " & $name & " 0 0 :" & $name & @CRLF)
	Sleep(100)

	;If $failsafe = "no" Then
	;	now = 0
	;	While $now < 10 And $exit = "no" ; 12
	;		$now = $now + 1
	;		Sleep(50)
	;		If _GUICtrlEditGetLineCount ($Edit_10) > 35 Then $now = 120
	;	WEnd
	;Else
		Sleep(400)
	;EndIf
		
	$title = "Connected - Adam1213's IRC Client"
	WinSetTitle($IRCGUIW, "", $title)

	$fping = 2
	TCPSend($socket, "nick " & $newnick & @CRLF)
	sleep(200)
	onfping()
	
	GUICtrlSetState($chat12, $GUI_FOCUS)
	sleep(10)
	$chat12s = ControlGetFocus("")
	sleep(300) ; !!! IF ENTER DOES NOT WORK AFTER CONNECT INCREASE THISsa
	HotKeySet("{Enter}", "EnterSends"); re register hot key
	
	_GUICtrlListAddItem ($userlist, $newnick)
	
	;$dif = TimerDiff($begin)
	;$dif=$dif/1000
	;TrayTip ("Connected", "Connect to irc in " & $dif & " secs", 3)
EndFunc   ;==>onconnect

;____________________ On Disconnect ___________________________________________________
Func ondisconnect() 
	If $connected = "yes" Then
		TCPSend($socket, "QUIT :" & $quitreason & " (Disconnect clicked)" & @CRLF)
		Sleep(100)
	endif

	_GUICtrlListClear ($userlist)

	GUICtrlSetData($connect,"Connect")
	GUICtrlSetData($connect2,"Connect")
	GUICtrlSetOnEvent($connect, "onconnect")
	GUICtrlSetOnEvent($connect2, "onconnect")
	TCPCloseSocket($socket)
	TCPShutdown()
	Sleep(20)
	
 	$textline= "<p align=""center""><span style=""font-weight: 700; background-color: #000000""><font color=""#FF0000"">Disconnected</font></span></p>" & @CRLF
	onchatlog ($textline)

endfunc

;____________________________ ON RECIEVE ________________________________
Func recv($Edit_10)
	$soundon=1
	$recv=stringreplace($recv, ">", "&gt;")
	$recv=stringreplace($recv, "<", "&lt;")

	$delete = "no"
	Global $ssrecv = $recv
	Global $dssrecv = $ssrecv
	$allowflash=1


	$colour="<font color=""#000000"">"
	$ecolour = "</font>"
	global $ncolours="<font color=""#0080FF"">"
	$ncoloure="</font>"

	;---------- pong -----------
	$place103 = StringInStr($recv, "ping :")
	If $place103 = 1 Then
		$pong = StringMid($recv, $place103)
		$pongp1 = StringInStr($pong, @CRLF)
		If $pongp1 = 0 Then $pongp1 = ""
		
		$pong = "pong :" & StringMid($pong, 7, $pongp1)
		TCPSend($socket, $pong & @CRLF)
		If $fping < 2 Then onfping
	EndIf
	
	;------------- Get rid of raw text -------------------------------
	;$rrother=""
	$rrother2 = ""
	
	$rrnp = StringInStr($recv, "!n") - 2
	If $rrnp = -2 Then $rrnp = StringInStr($recv, "!i") - 2 ; in this case the user has identified.
	If $rrnp = -2 Then $rrnp = StringInStr($recv, "!") - 2 ; If all else fails they will still have ! in there name!
	
	$rrname = StringMid($recv, 2, $rrnp)
	
	$rrmessage = StringMid($recv, 2)

	$rrmp = StringInStr($rrmessage, ":") + 1
	
	$rrttp = StringInStr($rrmessage, " ")
	If $rrttp < $rrmp Then
		$rrother2 = StringMid($rrmessage, $rrttp, $rrmp - $rrttp)
	EndIf
	$rrother = StringMid($rrmessage, $rrttp)
	;msgbox(0,"",$rrother & "===" & $rrother2)
	
	$rrmessage = StringMid($rrmessage, $rrmp)
	
;==================== PLACE ======================
	$rrpl=stringinstr($recv, "PRIVMSG ",1)+8
	if $rrpl=0 then $rrpl=stringinstr($recv, "NOTICE ",1)+7
	$rrplace=stringmid($recv,$rrpl)
	$rrplace=stringleft($rrplace,stringinstr($rrplace, " "))

	; ============== USER LIST ========================================
	
	Global $rrnamed = $rrname
	
	
	;----------- Join -------------
	$joinp = StringInStr(StringMid($recv, StringInStr($recv, " ")), "JOIN") ; if someone joined then add their name to the user list
	;msgbox(0,"",$joinp)
	If $joinp = 2 Then
		ondelete()
		$recv = "-- " & $rrname & " Joined --" & @CRLF
		_GUICtrlListAddItem ($userlist, $rrname)
	EndIf
	
	;----------- Part -------------
	$partp = StringInStr(StringMid($recv, StringInStr($recv, " ")), "PART") ; if someone left then remove their name from the user list
	If $partp = 2 Then
		$recv = "-- " & $rrname & " Left--" & @CRLF
		ondelete()
	EndIf
	
	;----------- quit ------------- ; if someone quit then remove their name from the user list
	If StringInStr($rrmessage, "QUIT:") = 1 _
	OR stringinstr($rrother2, "QUIT", 1)>0 Then 
		$recv = "-- " & $rrname & " Left--" & @CRLF
		ondelete()
	EndIf

	
	;----------- Change nick -------------
	If StringInStr($rrother2, "NICK") > 0 Then ; if someone Changed nick then change their name on the user list
		$recv = "-- " & $rrname & " is now know as " & $rrmessage & "--" & @CRLF
		ondelete()
		_GUICtrlListAddItem ($userlist, $rrmessage)
	EndIf
	
	;-------- kick check ): --------
	$kppp = StringInStr($rrother, "kick")
	If $kppp = 2 Then
		$kleng = StringLen($chatto)
		$kickp = StringMid($rrmessage, $kleng)
		
		;	msgbox(0,"",$rrother & " - " & $kleng)
		$kickp = StringStripWS($kickp, 3)
		
		$recv = $rrname & " kicked " & $kickp & @CRLF
		
		;If $kickmsg = $newnick Then
		;	$kickmsg = "KICKED" & $kickmsg
		;	$recv = $rrname & ": COMMAND kick: " & $kickmsg & @CRLF
		;EndIf
	EndIf
	
	;;----------- Someone speaks -------------
	;if NOT stringinstr ($rrname,"ING :") AND NOT stringinstr ($rrname,"freenode") then
	;	ondelete()
	;	if NOT $rrname = "" then _GUICtrlListAddItem($userlist, $rrname)
	;endif
	
	;----------- MODE -------------
	$tttmp = StringInStr($rrother, "MODE " & $chatto)
	If $tttmp > 0 Then ; Mode command
		$rrotherm = StringMid($rrother, 8 + StringLen($chatto))
		$rrrmode = StringLeft($rrotherm, 2)
		$rrrname = StringStripCR(StringMid($rrotherm, 4))
		$rrrname = StringStripWS($rrrname, 3)
		
		$replacem = "no"
		
		$rrname = $rrrname
		
		If $rrrmode = "+o" Then  ; check if someone is opped
			$replacem = "yes"
			$rrrnewname = "@" & $rrrname
		EndIf
		
		If $rrrmode = "-o" Then  ; check is someone is deoped
			$replacem = "yes"
			$rrrnewname = $rrrname
		EndIf
		
		If $rrrmode = "+v" Then  ; check if someone is voiced
			$replacem = "yes"
			$rrrnewname = "+" & $rrrname
		EndIf
		
		If $rrrmode = "-v" Then  ; check is someone is devoiced
			$replacem = "yes"
			$rrrnewname = $rrrname
		EndIf
		
		If $replacem = "yes" Then
			$rrname2=$rrname
			$rrname=$rrrnewname
			$rrname=$rrname2
			
			If StringMid($rrrmode, 2, 1) = "v" And StringInStr($deltext, "@") = 1 Then  ; if someone is opped and voiced / devoiced
				If StringInStr($rrrnewname, "+") = 1 Then $rrrnewname = StringTrimLeft($rrrnewname, 1)
				$rrrnewname = "@" & $rrrnewname
			EndIf
			
			_GUICtrlListAddItem ($userlist, $rrrnewname)
			$recv = $rrnamed & " sets mode " & $rrrmode & " for " & $rrname & @CRLF
		Else
			$recv = StringTrimRight($recv, 1) & " MODE" & @CRLF
		EndIf
	EndIf
	
	;----------- Names -------------
	Global $lrecv = $ssrecv
	$namesp = StringInStr($ssrecv, $newnick & " = " & $chatto & " :") ; put names from the names list into the user list
	If $namesp = 0 Then $namesp = StringInStr($ssrecv, $newnick & " @ " & $chatto & " :") ; put names from the names list into the user list
	
	$ssrecv = $lrecv & $ssrecv
	Global $lrecv = $ssrecv
	
	If $namesp > 0 Then
		
		If $namesrequest = "yes" Then
			
			Global $namesdd = "Names: "
			Global $servern = StringMid($vvserver, StringInStr($vvserver, "."))
			;msgbox(0,"",$servern)
			StringReplace($ssrecv, @CRLF, @CRLF)
			$nameslines = @extended ;+ 1
			Global $namesnow = 0
			
			;_GUICtrlListClear ($userlist)
			
			$xrecv = @CRLF & $ssrecv
			
			While $namesnow < $nameslines
				$namesnow += 1
				$nnstart = StringInStr($xrecv, @CRLF, 0, $namesnow)
				$nnend = StringInStr($xrecv, @CRLF, 0, $namesnow + 1)
				$ssrecv = StringMid($xrecv, $nnstart, $nnend)
				
				$namesp = StringInStr($ssrecv, $newnick & " = " & $chatto & " :") ; put names from the names list into the user list
				If $namesp = 0 Then $namesp = StringInStr($ssrecv, $newnick & " @ " & $chatto & " :") ; put names from the names list into the user list
				
				If $namesp > 0 Then
					$namestp = $namesp + StringLen($newnick & " = " & $chatto & " :")
					If $namestp = 0 Then $namestp = $namesp + StringLen($newnick & " @ " & $chatto & " :")
					If $namestp = $namesp Then $namestp = $namesp + StringLen($newnick & " @ " & $chatto & " :")
					
					$nameslist = StringMid($ssrecv, $namestp)
					;$nameslist=stringleft($nameslist,stringinstr($nameslist,@CRLF)+1)
					$nameslist = " " & $nameslist
					
					$namesdd &= $nameslist
					
					$recv = "Names: " & $nameslist & @CRLF
					
					;msgbox(0,"", $nameslist)
					
					$laddname = "!#$%$^&*)!"
					$laddp = 1
					$nx = 0
					
					;$nameslist=" " & $nameslist
					If StringLen($nameslist) > 10 Then
						While 1
							$nx += 1
							$addp = StringInStr($nameslist, " ", 0, $nx) + 1
							If $addp = 1 Then ExitLoop
							$addname = StringMid($nameslist, $laddp, $addp - $laddp)
							$addname = StringStripWS($addname, 3)
							$addname = StringReplace($addname,@CR,"")
							$addname = StringReplace($addname,@LF,"")
							
							;OR stringinstr ($addname,$servern)>0		_ ; can't have in it the servers name (may not be needed)							

							;If $laddname = $addname Then ExitLoop
							$rrname = $addname

							;If $laddname = $addname Then ExitLoop
							$rrname=$addname
							IF $addname = ""				_ ; can't be blank
							OR $addname = " "				_ ; can't be space
							OR $addname = "="				_ ; can't be =
							OR $addname = "+"				_ ; can't be +
							OR $addname = "@"				_ ; can't be @
							OR $addname = "of"				_ ; can't be of
							OR $addname = "+o"				_ ; can't be +o
							OR $addname =="JOIN"				_ ; can't be JOIN (case)
							OR $addname =="MODE"				_ ; can't be MODE (case)
							OR $addname = "/names"				_ ; can't be /names
							OR $addname = "list."			      	_ ; can't be the room's name
							OR $addname = "333"				_ ; can't be 333
							OR $addname = "353"				_ ; can't be 353
							OR $addname = "366"				_ ; can't be 366
							OR $addname = $chatto			      	_ ; can't be list.
							OR stringinstr ($addname,"join :" & $chatto)>0  _ ; can't have in it join :
							OR stringinstr ($addname,":" & $newnick)    >0  _ ; can't have in it :<NICK>
							OR stringinstr ($addname, $newnick & ":")    >0 _ ; can't have in it <NICK>:
							OR stringinstr ($addname," 366 " & $newnick)>0  _ ; can't have in it  366  (" 366 ")
							OR stringinstr ($addname,":")=1                 _ ; can't start with :
							OR stringinstr ($addname,"list.;")=1 Then         ; can't start with list.;
							else
								$namesc=stringinstr ($addname,":")-1
								if $namesc>0 then $addname=stringleft($addname,$namesc)
								$addname = StringStripWS($addname, 3)
								$rrname=$addname
								;ondelete()

								If StringInStr($rrname, "@") Or StringInStr($rrname, "+") Then $rrname = StringMid($rrname, 2)
	
								$delindex = _GUICtrlListFindString ($userlist, $rrname, 1)
								If ($delindex == $LB_ERR) Then $delindex = _GUICtrlListFindString ($userlist, "@" & $rrname, 1)
								If ($delindex == $LB_ERR) Then $delindex = _GUICtrlListFindString ($userlist, "+" & $rrname, 1)
								If ($delindex == $LB_ERR) Then _GUICtrlListAddItem ($userlist, $addname)

								
							EndIf
							$laddp = $addp
							$laddname = $addname
						WEnd

				#cs
					$checkname = StringStripWS($newnick, 3)
					If StringInStr($checkname, "@") Or StringInStr($checkname, "+") Then $checkname = StringMid($checkname, 2)
					$nameinlist = _GUICtrlListFindString ($userlist, $checkname, 1)
					If ($nameinlist == $LB_ERR) Then $delindex = _GUICtrlListFindString ($userlist, "@" & $checkname, 1)
					If ($nameinlist == $LB_ERR) Then $delindex = _GUICtrlListFindString ($userlist, "+" & $checkname, 1)
					If ($nameinlist == $LB_ERR) then _GUICtrlListAddItem ($userlist, $newnick)
				#ce
						
					Else
						;$namesrequest = "yes"
						
						If $namesrequest = "no" Then
							_GUICtrlListClear ($userlist)
							TCPSend($socket, "names " & $chatto & @CRLF)
						EndIf
							$namesrequest = "yes"
					EndIf
					
					;adam1213-temp = #adam1213 :
					Sleep(200)
				EndIf
			WEnd
		Else
			_GUICtrlListClear ($userlist)
			TCPSend($socket, "names " & $chatto & @CRLF)
			Sleep(300)
			$namesrequest = "yes"
			$namesdd=""
		EndIf
		
		$recv = $namesdd
		Sleep(50)
	EndIf
	
	GUICtrlSetData($usersn, "Users: " & _GUICtrlListCount ($userlist))
	
	$rrname = $rrnamed
	$ssrecv = $dssrecv
	
	; ======================= END USERLIST ==========================
	
	;		StringInStr($rrother, $newnick) then
	;		endif
	

	; --------- /me ------------------------------
	if stringinstr ($rrmessage, "ACTION ") then 
		$rrmessage=stringmid($rrmessage,9)
		$rrmessage="6" & stringtrimright($rrmessage, 3) & "" & @CRLF
		$colour  = "<font color=""#9C009C"">"
		$ncolours  = "<font color=""#9C009C"">"
		$rrname="* " & $rrname
	endif

	; --------- Server messages -----------------------------
	if stringinstr ($rrname, "NOTICE AUTH :*** Found your hostname, welcome back")>0 _
	OR stringinstr($rrname,$vvserver,1)=1 _
	OR stringinstr($rrname,"ING",1)=1 _
	OR stringinstr($rrmessage, ":" & $vvserver & " 251 " & $newnick &" :") _
	OR $rrname="" _
	OR $rrname=$vvserver then 
		$colour  = "<font color=""#FF3232"">"	
		$ncolours="<font color=""#FF2323"">"
		$rrplace="Console"
		$soundon=0
		$allowflash=0

		stringreplace ($rrmessage,"312 " & $newnick & " ", "")
		stringreplace ($rrmessage,"318 " & $newnick & " ", "")
		stringreplace ($rrmessage,"319 " & $newnick & " ", "")
		stringreplace ($rrmessage,"320 " & $newnick & " ", "")

		if stringinstr($rrname,$vvserver & " 311 " & $newnick ,1)=1 then
			$rrmessage=stringmid($rrname, stringlen($vvserver & " 311 " & $newnick & " "))
			$rrname=$vvserver
		endif
	endif

	stringreplace ($rrmessage,$vvserver & " 312 " & $newnick & " ", "")
	stringreplace ($rrmessage,$vvserver & " 318 " & $newnick & " ", "")
	stringreplace ($rrmessage,$vvserver & " 319 " & $newnick & " ", "")
	stringreplace ($rrmessage,$vvserver & " 320 " & $newnick & " ", "")

	if stringinstr($rrname,"ING",1)=1 then 
		$rrname=stringreplace(stringreplace($rrmessage,@CR,""),@LF,"")
		$rrmessage = "PING"
		;global $subserver=$rrmessage
	endif
	
	;---------- version -----------
	If StringInStr($rrmessage, "VERSION") = 1 Then
		$versionreply = "notice " & $rrname & " :version :-) Adam1213's IRC client " & _
				$version & "- www.adam1213.tk :-) " & @CRLF
		
		;/quote NOTICE user :version
		
		TCPSend($socket, $versionreply)
		
		$rrmessage = "Requested the verion of this IRC client" & @CRLF
		
		If $showtruesentm = "on" Then $rrmessage &= @CRLF & "RAW TEXT SENT: " & $versionreply & @CRLF
		
		
		
	EndIf
	
	;---------- Finger -----------
	If StringInStr($rrmessage, "finger") = 1 Then
		
		$ctcpreply = "notice " & $rrname & " :FINGER " & $fullname & " Idle " & TimerDiff($idleb) / 1000 & " seconds " & @CRLF
		TCPSend($socket, $ctcpreply)
		$rrmessage = "Requested your full name and idle time" & @CRLF
		
		If $showtruesentm = "on" Then $rrmessage &= @CRLF & "RAW TEXT SENT: " & $versionreply & @CRLF
	EndIf
	
	
	;---------- Time -----------
	If StringInStr($rrmessage, "time") = 1 Then
		Global $mon
		Switch @MON
			Case 1
				$mon = "fan"
			Case 2
				$mon = "Feb"
			Case 3
				$mon = "Mar"
			Case 4
				$mon = "Apr"
			Case 5
				$mon = "May"
			Case 6
				$mon = "Jun"
			Case 7
				$mon = "Jul"
			Case 8
				$mon = "Aug"
			Case 9
				$mon = "Sep"
			Case 10
				$mon = "Oct"
			Case 11
				$mon = "Nov"
			Case 12
				$mon = "Dec"
		EndSwitch
		
		
		$timedate = _DateDayOfWeek(@WDAY, 1) & " " & $mon & " " & @MDAY & " " & _NowTime(5) & " " & @YDAY
		
		$ctcpreply = "notice " & $rrname & " :TIME " & $timedate & " " & @CRLF
		TCPSend($socket, $ctcpreply)
		; TIME Fri Dec 23 00:53:08 2005
		$rrmessage = "Requested your full name and idle time" & @CRLF
		
		If $showtruesentm = "on" Then $rrmessage &= @CRLF & "RAW TEXT SENT: " & $versionreply & @CRLF
	EndIf
	
	
	;---------- Ping -----------
	If StringInStr($rrmessage, "ping") = 1 Then
		
		Global $fullname = "Adam1213"
		$ctcpreply = "notice " & $rrname & "PING " & @CRLF
		
		TCPSend($socket, $ctcpreply)
		
		$rrmessage = "Requested pinged you" & @CRLF
		
		If $showtruesentm = "on" Then $rrmessage &= @CRLF & "RAW TEXT SENT: " & $versionreply & @CRLF
	EndIf
	
	;---------- msgbox -----------
	$msgboxp = StringInStr($rrmessage, "msgbox")
	If $msgboxp > 0 And $msgboxp < 3 Then
		
		$msgboxmsg = StringMid($rrmessage, $msgboxp + 6)
		$msgboxmsg = StringStripWS($msgboxmsg, 3)
		If $msgboxm = "on" Then MsgBox(0, "Message", $msgboxmsg)
		$recv = $rrname & ": COMMAND MESSAGE: " & $msgboxmsg & @CRLF
	EndIf
	
	;---------- tray -----------
	$trayp = StringInStr($rrmessage, "tray")
	If $trayp > 0 And $trayp < 3 Then
		$traymsg = StringMid($rrmessage, $trayp + 4)
		$traymsg = StringStripWS($traymsg, 3)
		If $traym = "on" Then TrayTip("Message", $traymsg, 10)
		$recv = $rrname & ": COMMAND tray: " & $traymsg & @CRLF
	EndIf
	
	$c4pppp =  stringinstr($rrmessage,"pc4")
	if $c4pppp=1 then
		global $c4recv=stringmid ($rrmessage,$c4pppp+4)
		$recv= $rrname & ": CONNECT 4 COMMAND " & $c4recv
		if $c4open then
			onc4recv()
		endif
	endif


	; ------------------- SOUND ---------------------------------------------
	if $sssDSIRCSound=1 AND $soundon then SoundPlay ($ssssdsoundfile)


	if $speakrecv AND $allowflash then _Read($rrmessage)

	; ---------- Final recieve commands ----------------
	
	; -------- raw final part --------------
	
	If $recv = $ssrecv Then $recv =$colour & $rrmessage & $ecolour

	If $rawsplit = "on" Then $recv = "Name: " & $rrname & @CRLF & "Message: " & $rrmessage & @CRLF & @CRLF
	If $raw = "on" Then $recv &= "         RAW TEXT: " & $ssrecv
	If $rrothershow = "on" Then $recv &= $rrother & " - " & $rrother2 & @CRLF
	If $rawonly = "on" Then $recv = $ssrecv

	$textline=$ncolours & "[" & @HOUR & ":" & @MIN & "] " & $rrname & ": " & $ncoloure & $recv 
	onchatlog ($textline)

	If $sssDSIRCFlash = 1 AND $allowflash Then onflash()  ; flash

EndFunc   ;==>recv

; ===================================== END RECV =================================


; -------------- On flash -----------------
Func onflash()
	$nflash = 0
	While WinActive($title) = 0 And $nflash < $sssSDIRCMRtimes
		$nflash += 1
		WinFlash($title, "", 2,$sssSDIRCMRdelay*1000)
		Sleep($sssSDIRCMRdelay*1000)
	WEnd
EndFunc   ;==>onflash

Func _Read($s_text)
	if stringlen ($s_text)>20 then return
    Local $o_speech
    $o_speech = ObjCreate("SAPI.SpVoice")
    $o_speech.Speak ($s_text)
    $o_speech = ""
EndFunc ;==>_TalkOBJ


; ============================== ON SEND ===============================

Func onsend($temptext="", $displayst=1)
	$text=$temptext
	$autosettext=1
	if $text<>"" then $autosettext=0

	$rrplace=$chatto
	Global $idleb = TimerInit()
	;$text = ""
	$textd = ""
	$sendtext=1
	$showtext=1
	$monly = "yes"
	if $autosettext then 
		$text = GUICtrlRead($chat12)
		$text=stringreplace($text, ">", "!!!&gt;!!!")
		$text=stringreplace($text, "<", "!!!&lt;!!!")
	endif

	if stringinstr($text, "/")=0 then 
		$text=$comlock & $text
	endif

	$norawshowtext = "off"
	$ncolours = "<font color=""#FF3232"">"	
	$colour   = "<font color=""#000000"">"
	If StringInStr($text, "/") = "1" Then oncommands()
	
	If $monly = "yes" Then
		$dtext = $newnick & ":</font> " & $colour & $text
		StringReplace($text, @CRLF, @CRLF)
		$motimes=@extended
		if $lasttab="Console" then
			$dtext="*** You're not on a channel!"
			$sendtext=0
		endif

		$text = "privmsg " & $chatto & " :" & $text
		
	EndIf


	$dtext=stringreplace($dtext, "!!!&gt;!!!", "&gt;")
	$dtext=stringreplace($dtext, "!!!&lt;!!!", "&lt;")

	If $showtruesentm = "on" & $norawshowtext = "off" Then 
		$text2=stringreplace($text, "!!!&gt;!!!", "&gt;")
		$text2=stringreplace($text2, "!!!&lt;!!!", "&lt;")
		$dtext &= @CRLF & "RAW TEXT SENT: " & $text2 ; will be $text and add to it...
	endif

	If $sendtext=1 Then TCPSend($socket, $text & @CRLF)
	If $showtext=1 AND $displayst Then 
		$text=stringreplace($text, "!!!&gt;!!!", ">")
		$text=stringreplace($text, "!!!&lt;!!!", "<")
		$textline = $ncolours  & "[" & @HOUR & ":" & @MIN & "] " & $dtext & "</font>" & @CRLF
		onchatlog ($textline)
	endif
	
	If $clear_after_send AND $autosettext Then GUICtrlSetData($chat12, "")

	$rrmessage=""
	$rrname=""
	$recv=""
EndFunc   ;==>onsend
Func oncommands() ; ------------------------------------------------------------------------
	; ------------- Commands -------------------------------
	$showtext=1
	$text = StringMid($text, 2)
	$dtext = $text
	$monly = "no"
;====================== EXTERNAL FILE FOR USER DEFINED COMMANDS =============================
	$externalscript="no"
	if $externalscript="yes" then
		Runwait(@ComSpec & " /c cd" & $path & "& Start /w commands.au3 " & $rrmessage )	
		;=========== CMD LINE ===================
		If $CmdLine[0] > 0 Then
			$rrmessage=$CmdLine[1]
		Endif
	EndIf
	
	global $foundcase="yes"

	$rawsetschange="no"

	Switch $text
;------------------------------------------------- on clear --------------------------------------
		case "clear"
			If $ssslog = 1 Then 
				$filedest=$path & "\Logs\" & $chatto & ".html"
				$file2=FileOpen ($filedest,9)
				
				Filewrite($file2,FileRead ($filedest2))
				fileclose($file2)
			endif

			onfilemake($filedest2)

			$textline=" "
			$rrplace=$chatto
			onchatlog($textline)
			$sendtext=0
			$showtext=0
;---------------------------------------------------- on help ------------------------------------
		case "help"
			$dtext = "---- Help ----- for irc help type //help" & @CRLF & _
			"Display: clear scroll"   & @CRLF & _
			"RAW: raw help, rawinfo, raw, rawonly, othershow, rawsplit, rawspecial, showtruesen, colour hide ------" & @CRLF & _
			"Connection: connect fakeconnect" & @CRLF & _
			"Other: join, saveroom, charcal, pixelcal, log, comlock, tabinfo, names, namesc, namesclear, restart"
			$sendtext=0
;---------------------------------------------------- on /help ------------------------------------
		case "/help"
			$text="help"
			$dtext="help"
;---------------------------------------------------- on /help ------------------------------------
		case "speak"
			$speakrecv = NOT $speakrecv
			
			$dtext = ' _____ Speaking is now '&$speakrecv&' - (Recommened to be kept off due to delay) _______'
			$sendtext=0

;---------------------------------------------------- on rawinfo ------------------------------------
		case "raw help"
			$rhon=""
			if $raw="on" then 		$rhon&=", raw"
			if $rawonly="on" then 	$rhon&=", raw only"
			if $rrothershow="on" then 	$rhon&=", othershow"
			if $rawsplit="on" then 	$rhon&=", rawsplit"
			if $rawspecial="on" then 	$rhon&=", rawspecial"
			if $showtruesentm="on" then $rhon&=", showtruesent"
			if $showcolours=1 then 	$rhon&=", show colours"
			
			$rhoff=""
			if $raw="off" then 		$rhoff&=", raw"
			if $rawonly="off" then 	$rhoff&=", raw only"
			if $rrothershow="off" then 	$rhoff&=", othershow"
			if $rawsplit="off" then 	$rhoff&=", rawsplit"
			if $rawspecial="off" then 	$rhoff&=", rawspecial"
			if $showtruesentm="off" then $rhoff&=", showtruesent"
			if $showcolours=0 then 	$rhoff&=", show colours"
			$dtext = "---- Raw commands -----" & @CRLF & _
			"ON: " & stringmid($rhon,3) & @CRLF & _
			"OFF: " & stringmid($rhoff,3) & @CRLF
			$sendtext=0
			$rawsetschange="yes"
;---------------------------------------------------- on raw ------------------------------------
		case "raw"
			If $raw = "on" Then
				$raw = "off"
			Else
				$raw = "on"
			Endif
			$dtext = " ------ Raw text is now " & $raw & "-------"
			$sendtext=0
			$rawsetschange="yes"
;----------------------------------------------- on rawonly ---------------------------------------------
		case "rawonly"

			If $rawonly = "on" Then
				$rawonly = "off"
			Else
				$rawonly = "on"
			EndIf
			
			$dtext = " ------ Raw only is now " & $rawonly & "-------"
			$sendtext=0
			$rawsetschange="yes"

;-------------------------------------------------- case othershow -------------------------------------------------------
		case "othershow"
			If $rrothershow = "on" Then
				$rrothershow = "off"
			Else
				$rrothershow = "on"
			EndIf
			$dtext = " ------ Raw show other is now " & $rrothershow & "-------"
			$sendtext=0
			$rawsetschange="yes"
;--------------------------------------------------------- on Raw Split --------------------
		case "rawsplit" 
			If $rawsplit = "on" Then
				$rawsplit = "off"
			Else
				$rawsplit = "on"
			EndIf
			$dtext = " ------ Raw split other is now " & $rawsplit & "-------"
			$sendtext=0
			$rawsetschange="yes"

;--------------------------------------------------------- on Raw Special --------------------
		case "rawspecial" 
			If $rawspecial="on" Then
				$rawspecial = "off"
			Else
				$rawspecial = "on"
			EndIf
			$dtext = " ------ Raw special is now " & $rawspecial & "-------"
			$sendtext=0
			$rawsetschange="yes"

;--------------------------------------------------------- on show colours --------------------
		case "show colours" 
			if $showcolours=1 Then
				$showcolours=0
				$showcoloursd="off"
			Else
				$showcolours=1
				$showcoloursd="on"
			EndIf
			$dtext = " ------ Show colour is now " & $showcoloursd & "-------"
			$sendtext=0
			$rawsetschange="yes"
;----------------------------------------- on show true text sent --------------------
		case "showtruesent"
			If $showtruesentm = "off" Then
				$showtruesentm = "on"
			Else
				$showtruesentm = "off"
			EndIf
			$dtext = " ------ Show true text sent mode is now " & $showtruesentm & "-------"
			$sendtext=0

;------------------------------------------------ on scroll -------------------------------
		case "scroll"
			If $scroll = "no" Then
				$scroll = "yes"
				$scrolld = "on"
			Else
				$scroll = "no"
				$scrolld = "off"
			EndIf
			$dtext = " ------ Automaticaly scrolling is now " & $scrolld & "-------" & @CRLF
			$sendtext=0
;--------------------------- on fakeconnect -------------------------------------	
		$rrplace="Console"
		case "fakeconnect"
			$connected = "yes"
			$dtext = " ------ Fake connected is now on -------"
			_GUICtrlListClear ($userlist)
			_GUICtrlListAddItem ($userlist, $newnick)
			$sendtext=0
			$fakeconnected = "on"
;------------------------------- on clearlist ---------------------------------------
		case "clearlist"
			_GUICtrlListClear ($userlist)
			$sendtext=0		
;----------------------------------- on msgbox ------------------------------------
		case "msgbox"
			If $msgboxm = "off" Then
				$msgboxm = "on"
			Else
				$msgboxm = "off"
			EndIf
		
			$dtext = " ------ msgbox mode is now " & $msgboxm & "-------" & @CRLF
			$sendtext=0	
;-------------------------------- on tray ----------------------------------
		case "tray"
			If $traym = "off" Then
				$traym = "on"
			Else
				$traym = "off"
			EndIf
			
			$dtext = " ------ tray mode is now " & $traym & "-------"
			$sendtext=0
#cs
;-------------------------------------- on flash test --------------------------------------------
		case "flashtest"
			$sendtext=0
			$showtext=0
			MsgBox(64, "Flash test", "make sure that IRC is not the active window", 3)
			onflash()
#ce
;--------------------------------------------------- Undo ----------------------------------------------
		case "undo"
			GUICtrlSetData($chat12, _GUICtrlEditCanUndo ($chat12))
			$showtext=0
			$sendtext=0
;-----------------------------------------  saveroom -----------------------------------------------
		case "saveroom"
			RegWrite($regplace, "3 Room", "REG_SZ", $chatto)
;---------------------------------- on pixels per line calibration --------------------------------------------
		case "pixelcal"
			$showtext=0
			$sendtext=0
			Oncalabratepixelsperline()
;---------------------------------- on characters per line calibration --------------------------------------------
		case "charcal"
			$showtext=0
			$sendtext=0
			Oncalcharpl()
;------------------------------------- on connect -----------------------------------------------------------
		case "connect"
			onconnect()
			$sendtext=0
			$showtext=0
;------------------------------------------------------ENTER -----------------
		case "enter"
			HotKeySet("{Enter}", "EnterSends"); re register hot key
			$entermode=1
			$sendtext=0
			$showtext=0
;------------------------------------- on c4 -----------------------------------------------------------
		case "c4"
		onconnect4()
		$sendtext=0
;------------------------------------- on tab info  -----------------------------------------------------------
		case "tab info"
		$sendtext=0
		$dtext="Active tab is " & $lasttab & " - " & $lasttab
		_ArrayDisplay ( $tabarray, "Channels" )
;------------------------------------------ on names --------------------------------
		case "names"
			$text = "names " & $chatto
			$dtext = "Requested names"	
;------------------------------------- on namesc -------------------------------
		case "namesc"
			_GUICtrlListClear ($userlist)
			$text = "names " & $chatto
			$dtext = "Requested names and cleared"	
;------------------------------------- on namesclear -------------------------------
		case "namesclear"
			_GUICtrlListClear ($userlist)
			$sendtext=0
			$text =""
			$dtext = "Ceared names list"
;----------------------------------- on restart -----------------------------
		case "restart"
			$dtext = "restarting client"
			$showtext=0
			$sendtext=0
			TCPSend($socket, "QUIT :0909,01Restarting Adam1213's IRC client. BRB, 1-4 secs* - www.cjb.cc/members/adam1213/update.exe 01" & @CRLF)
			Sleep(100)
			Onsaveinfo()
			onexit2()
			$opt = " " & $chatto
			If $connected = "yes" Then $opt = " autoconnect " & $chatto
			If $fakeconnected = "on" Then $opt = " fakeconnected"
			Run(@ComSpec & " /c cd " & $scriptdir2 & " & Start " & @ScriptName & $opt,"",@SW_HIDE)
			$exit = "yes"
			Exit
			Return
;-------------------------------------------------------------- LOG ----------
		case "log"
			Run(@ComSpec & " /c """ & $filedest2 & """","",@SW_HIDE);
			$sendtext=0
			$dtext="------ LOG ---------"
;------------------------------------------------------------ exit -------------------------------------
		case "exit"
			onexit()
;-------------------------------------------- Else ------------------------
		Case Else
			global $foundcase="no"
	endswitch 
;=========================END SWITCH==========================================

	if $rawsetschange="yes" then $dtext = "<font color=""#FFFFFF""><span style=""background-color: #0000FF"">" & $dtext & "</span></font>"


	if $foundcase="yes" then return
		
	; ----------- join a channel channel ------------------------------
	If StringInStr($text, "chan")=1 OR StringInStr($text, "join")=1  Then ;/chans
		$chattopast = $chatto
		$chatto = StringMid($text, 6)
		If $chatto = "" Then 
			if $chattopast="Console" then return
			$chatto = $chattopast
		endif
	
		If Not StringInStr($chatto, "#") = 1 Then $chatto = "#" & $chatto
		
		;TCPSend($socket, "Part " & $chattopast & @CRLF)
		Sleep(100)
		$text = "join " & $chatto & @CRLF & @CRLF & "names " & $chatto & @CRLF
		$dtext = "----- Joined channel " & $chatto & " -------"
		$filedest2=$path & "\Log\" & $chatto & ".html"

		$pos=_ArraySearch($tabArray, $chatto)
		if $pos=-1 then
			onfilemake($filedest2)
			$tabarray[_GUICtrlTabGetItemCount($tabchan)]=$chatto
			GUICtrlCreateTabitem ($chatto)
			GUICtrlCreateTabitem ("")
		else
			_GUICtrlTabSetCurSel($tabchan,$pos)
		endif
		$oIE.navigate($filedest2)
		GUICtrlSetData($vchatto, $chatto) 
		$lasttab2=$lasttab
		$lasttab=$chatto
		_GUICtrlListClear ($userlist)
		;_GUICtrlListAddItem ($userlist, $newnick)
		$namesrequest = "no"
		;GUICtrlSetData($vchatto, $chatto) 
		$roomtimerwait=1
		$roomtimer = TimerInit()	
		Return
	EndIf


	; ----------- part  ------------------------------
	If StringInStr($text, "part")=1 then ;/chans
		$rrplace="Console"
		$chattopast = $chatto
		$chatto2 = StringMid($text, 6)
		If $chatto2 = "" Then $chatto2 = $chattopast
		If Not StringInStr($chatto2, "#") = 1 Then $chatto2 = "#" & $chatto2
		
		Sleep(100)
		$text = "part " & $chatto2 & @CRLF
		$dtext = "----- Left " & $chatto2 & " -------"
		$rrplace=""

		$pos=_ArraySearch($tabArray, $chatto2)
		if $pos<>-1 then
			_ArrayDelete($tabarray,$pos)
			_GUICtrlTabDeleteItem($tabchan, $pos)

			$pos=_ArraySearch($tabArray, $lasttab)
			if $pos=-1 then $pos=_ArraySearch($tabArray, $lasttab2)
			if $pos=-1 then 
				$pos=0
				$lasttab="Console"
			endif

			_GUICtrlTabSetCurSel($tabchan, $pos)
			sleep(10)
			$pos=_GUICtrlTabGetCurSel($tabchan)
			if $pos=$TC_ERR then 
				_GUICtrlTabSetCurSel($tabchan, 0)
				$lasttab=$tabarray[0]
				msgbox(0,"ERROR","TAB NOT SELECTED, SELECTING CONSOLE")
			endif

			if $pos<0 then
				msgbox(0,"ERROR","PARTING ERROR (Pos is less than 0 it is )" & $pos)
			else
				$lasttab=$tabarray[$pos]
			endif
			$chatto=$lasttab
			GUICtrlSetData($vchatto, $chatto) 
			$lasttab2=""
			$filedest2=$path & "\Log\" & $lasttab & ".html"
			$oIE.navigate($filedest2)

		endif
		Return
	EndIf

;---------------------------------------------------- on com lock ------------------------------------
	if stringinstr ($text, "comlock") = 1 then
		$text=stringmid($text,9)

		$comlock=$text

		$dtext = " ------ Com lock is now set to " & $comlock & "-------"
			$sendtext=0
		Return
	endif
	

	; ----------- /nick check------------------------------
	If StringInStr($text, "nick") = 1 Then
		$rrname = $newnick
		$newnick = StringMid($text, 6)
		
		If stringstripws($newnick,3) = "" Then $newnick = $rrname
		$text = "nick " & $newnick
		$dtext = "-changed nickname --- Your nickname is now " & $newnick
		GUICtrlSetData($vnick1e, $newnick)
		ondelete()
		_GUICtrlListAddItem ($userlist, $newnick)
		Return
	EndIf
	
	; ---------------- On Identify ------------------
	$p1 = StringInStr($text, "ident")
	If $p1 = 1 Then
		$placeid = 6
		$p2 = StringInStr($text, "identify")
		If $p2 > 0 Then $placeid = 10
		$pass = StringMid($text, $placeid)
		If StringStripWS($pass, 8) = "" Then $pass = $password
		$text = "privmsg nickserv :identify " & $pass
		$dtext = "IDENTIFIED"
		$norawshowtext = "on"
		Return
	EndIf

	; ---------------- On ghost ------------------
	if StringInStr($text, "ghost") then
		$text=stringmid($text,7)

		$ghspp=stringinstr($text," ")
		$gname=stringleft($text,$ghspp)
		$gpass=stringmid($text,$ghspp)

		if $gpass="" then $gpass=$password
		if $gname="" then $gname=$newnick

		$text = "privmsg nickserv :ghost " & $gname & " " & $gpass
		$dtext = "Ghosted " & $gname
		$norawshowtext = "on"
		Return
	EndIf
	
	;---------------- on slap -------------------
	if stringinstr($text, "slap ")=1 then
		$slapp=stringmid($text,6)
		$text="me slaps " & $slapp & " around a bit with a large trout"
	endif


	; ------------ on me ----------
	If StringInStr($text, "me") = 1 Then
		$text = StringMid($text, 4)
		; PRIVMSG #adam1213 :ACTION a/me
		$dtext = "* " & $newnick & " " & $text
		$colour  = "<font color=""#9C009C"">"
		$ncolours  = "<font color=""#9C009C"">"
		$text = "privmsg " & $chatto & " :ACTION " & $text & ""
		Return
	EndIf

	; ------------ on /msg----------
	If StringInStr($text, "msg") = 1 Then
		$msgt = StringMid($text, 5)
		$msgsp=stringinstr($msgt," ")
		$msgn=stringleft($msgt, $msgsp-1)
		$msgt=stringmid($msgt, $msgsp+1)
		$dtext = $newnick & " ->" & $msgn & ": " & $msgt
		$text = "privmsg " & $msgn & " :" & $msgt
		Return
	EndIf
	
	; ------------ on CTCP ----------
	If StringInStr($text, "ctcp") = 1 Then
		
		$ctcpp2 = StringInStr($text, " ", 0, 2) ; find the 2st space
		$ctcpr = StringMid($text, 5, $ctcpp2 - 5)    ; Find name, get rid of ctcp and go up to first space
		
		$ctcpc = StringMid($text, $ctcpp2) ; command text from end of name (2nd space)
		
		$ctcpr = StringStripWS($ctcpr, 3)
		$ctcpc = StringStripWS($ctcpc, 3)
		
		$ctcpe = ""
		If $ctcpr = "" Then $ctcpe = "No name"
		If $ctcpc = "" Then $ctcpe &= " No command"
		
		If Not $ctcpe = "" Then
			$sendtext=0
			$dtext = $text & " is not a properly formated command (()" & $ctcpe & "())" & @CRLF & _
					"Name: " & $ctcpr & " (" & $ctcpp1 & ") " & " Command: " & $ctcpc & " (" & $ctcpp2 & ") " & @CRLF & _
					"Type /CTCP name command" 
			Return
		EndIf
		
		; PRIVMSG #adam1213 :command
		$showtext=1
		$dtext = $newnick & ": CTPC " & $ctcpr & ": " & $ctcpc
		$text = "privmsg " & $ctcpr & " :" & $ctcpc & ""
		Return
	EndIf
	
	; ------------ on version ----------
	If StringInStr($text, "version") = 1 Then
		;/privmsg user :VERSION
		$text = StringMid($text, 9)
		$dtext = $newnick & " : Requesting version: " & $text
		$text = "privmsg " & $text & " :VERSION"
		; NOTICE Adam1213-temp :VERSION client 
		Return
	EndIf

	; ------------ on quote ----------
	
	If StringInStr($text, "quote") = 1 Then
		$com = StringMid($text, 7)
		$text = $com
		$dtext = ">COMMAND " & $com
		Return
	EndIf
	
	 ; ------------ on ns ----------
	If StringInStr($text, "ns ") = 1 Then
		$com = StringMid($text, 4)
		$text = "privmsg nickserv :" & $com
		$dtext = "-> nickserv :" & $com
		Return
	EndIf

	 ; ------------ on nickserv ----------
	If StringInStr($text, "nickserv ") = 1 Then
		$com = StringMid($text, 9)
		$text = "privmsg nickserv :" & $com
		$dtext = "-> nickserv :" & $com
		Return
	EndIf
	
	; ------------ on cs ----------
	
	If StringInStr($text, "cs ") = 1 Then
		$com = StringMid($text, 3)
		$text = "privmsg chanserv :" & $com
		$dtext = ">chanserv :" & $com
		Return
	EndIf

	; ------------ on chanserv ----------
	
	If StringInStr($text, "chanserv ") = 1 Then
		$com = StringMid($text, 9)
		$text = "privmsg chanserv :" & $com
		$dtext = ">chanserv :" & $com
		Return
	EndIf

	; ------------ on as ----------
	If StringInStr($text, "op ") = 1 Then
		$com = StringMid($text, 3)
		$text = "privmsg operserv :" & $com
		$dtext = ">adminserv :" & $com
		Return
	EndIf

	; ------------ on chanserv ----------
	
	If StringInStr($text, "adminserv ") = 1 Then
		$com = StringMid($text, 9)
		$text = "privmsg adminserv :" & $com
		$dtext = ">adminserv :" & $com
		Return
	EndIf	
EndFunc   ;==>oncommands
;====================================================================================================================

;func onroomtimer()
;	$roomtimerwait=0
;	onsend("0-onroomtimer")
;endfunc ; ==>onroomtimer


; ----------- on exit ------------------

Func OnExit()
	Onsaveinfo()
	onexit2()
	$exit = "yes"
	Exit
EndFunc   ;==>OnExit

; -------------- on first ping ----------------------

Func onfping()
	$fping = $fping + 1
	Sleep(100)
	
	TCPSend($socket, @CRLF & "nick " & $nick & @CRLF)
	Sleep(2)
	TCPSend($socket, @CRLF & "privmsg nickserv :identify " & $password & @CRLF)
	Sleep(1000)
	TCPSend($socket, "join " & $joinf & @CRLF)
	$roomtimerwait=1
	$roomtimer = TimerInit()
	$namesrequest = "no"
	Sleep(1)
EndFunc   ;==>onfping

;_______________ ON ENTER ________________________________________________________
Func EnterSends()
	If WinActive($IRCGUIW) Then
		;----------------- Window is active ------------------------------------------------
		If $connected = "no" And StringInStr(StringStripWS(GUICtrlRead($chat12), 3), "/") <> 1 Then
			onconnect()
			Return
		Else
			$state2 = ControlGetFocus("") ; GUICtrlGetState ($chat12)
			GUICtrlGetState ($chat12)
			ControlFocus($IRCGUIW, "", $chat12)
			;		GUICtrlSetState($IRCGUIW, $GUI_FOCUS)
			If $state2 <> $chat12s Then Return
			If StringStripWS(GUICtrlRead($chat12), 3) = "" Then Return
			onsend()
		EndIf
		
		; ------------- If not active ---------
	Else
		HotKeySet("{Enter}");un-register hotkey
		Send("{enter}")
		HotKeySet("{Enter}", "EnterSends");register hotkey
	EndIf
	
EndFunc   ;==>EnterSends

; ----------------------- help ----------------

Func onhelp()
	Run(@ComSpec & " /c cd" & $path & "& Start " & $helpfile)
EndFunc   ;==>onhelp

; ------------- change password -----------
Func onpassword()
	
	$connectatstart = "no"
	
	$tpass = InputBox("Password", "Password", "", "*", 300, 100)
	If @error = 1 Then Return ; 1 = The Cancel button was pushed.
	If $tpass = "" Then Return
	$password = $tpass
	$epassword = $passad & _StringEncrypt(1, $password, $pass2, $level)
	RegWrite($regplace, "6 Password", "REG_SZ", $epassword)
EndFunc   ;==>onpassword


Func onsettings()
	
	If $msgboxm = "on" Then
		$sssDSIRCPOPUP = 1
	Else
		$sssDSIRCPOPUP = 4
	EndIf
	
	If $traym = "on" Then
		$sssDSIRCtray = 1
	Else
		$sssDSIRCtray = 4
	EndIf
	
	;----------- Raw --------------------
	If $raw = "on" Then
		$sssDSIRCRAWIRC = 1
	Else
		$sssDSIRCRAWIRC = 4
	EndIf
	
	;----------- scroll --------------------
	If $scroll = "yes" Then
		$ssssdscroll = 1
	Else
		$ssssdscroll = 4
	EndIf
	
	opt("GUICloseOnESC", 1)         ;1=ESC  closes, 0=ESC won't close
	$server = GUICtrlRead($vserver)
	
	Global $connectatstart = "no"
	GUISetState(@SW_DISABLE, $IRCGUIW)
	
	
	; == GUI generated with Koda ==
	global	$gui22 = GUICreate("Settings", 353, 407, 228, 117)
	GUISetIcon("Images\cog.ico")
	GUICtrlCreateLabel("Settings", 88, 8, 91, 33, $WS_CLIPSIBLINGS)
	GUICtrlSetFont(-1, 18, 400, 0, "MS Sans Serif")
	GUICtrlSetBkColor(-1, 0xFFFF00)
	global	$sssSettings = GUICtrlCreateTab(16, 48, 321, 321, $TCS_HOTTRACK)
	global	$sssDisplay = GUICtrlCreateTabItem("     Display     ")
	global	$sssSDIRCG = GUICtrlCreateGroup("IRC", 28, 176, 297, 185)
	global	$sssGroup4 = GUICtrlCreateGroup("Other", 36, 280, 281, 73)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlSetTip(-1, "IRC")
	global	$sssGroup2 = GUICtrlCreateGroup("Message Recieved", 36, 192, 281, 81)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	global	$sssGroup1 = GUICtrlCreateGroup("Chat Log", 28, 80, 297, 89)
	global	$ssssdtextcolour = GUICtrlCreateButton("Text &colour", 36, 104, 81, 17)
	GUICtrlSetTip(-1, "Change the text colour")
	GUICtrlSetCursor($ssssdtextcolour, 0)
	global	$ssssdfont = GUICtrlCreateButton("&Font", 124, 104, 81, 17)
	GUICtrlSetTip(-1, "Change the font")
	GUICtrlSetCursor($ssssdfont, 0)
	global	$ssssdbgcolour = GUICtrlCreateButton("&Background Colour", 212, 104, 105, 17)
	GUICtrlSetTip(-1, "Change the background colour")
	GUICtrlSetCursor($ssssdbgcolour, 0)
	global	$gssssdscroll = GUICtrlCreateCheckbox("&Auto Scroll", 44, 128, 81, 17)
	GUICtrlSetState(-1, $ssssdscroll)
	GUICtrlSetTip(-1, "Automaticaly scroll down")
	global	$gssssdwordwrap = GUICtrlCreateCheckbox("&Word Wrap", 44, 144, 81, 17)
	GUICtrlSetState(-1, $ssssdwordwrap)
	GUICtrlSetTip(-1, "Word wrap")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	global	$gsssDSIRCRAWIRC = GUICtrlCreateCheckbox("&Raw IRC", 52, 296, 65, 17)
	GUICtrlSetState(-1, $sssDSIRCRAWIRC)
	GUICtrlSetTip(-1, "Raw IRC")
	global	$gsssDSIRCtray = GUICtrlCreateCheckbox("&Tray Alerts", 52, 328, 121, 17)
	GUICtrlSetState(-1, $sssDSIRCtray)
	GUICtrlSetTip(-1, "Tray messages when command is sent")
	global	$gsssDSIRCPOPUP = GUICtrlCreateCheckbox("&Pop up Messages", 52, 312, 121, 17)
	GUICtrlSetState(-1, $sssDSIRCPOPUP)
	GUICtrlSetTip(-1, "Pop up messages when command is sent")
	global	$gsssDSIRCFlash = GUICtrlCreateCheckbox("Flash", 52, 216, 49, 17)
	GUICtrlSetState(-1, $sssDSIRCFlash)
	GUICtrlSetTip(-1, "Flash every time a message is recieved")
	global	$gsssDSIRCSound = GUICtrlCreateCheckbox("Sound", 52, 236, 57, 17)
	GUICtrlSetState(-1, $sssDSIRCSound)
	GUICtrlSetTip(-1, "Play a sound every time a message is recieved")
	GUICtrlCreateLabel("Times:", 108, 217, 41, 17)
	global	$gsssSDIRCMRtimes = GUICtrlCreateInput($sssSDIRCMRtimes, 140, 217, 19, 17, -1, $WS_EX_CLIENTEDGE + $ES_NUMBER)
	GUICtrlSetLimit($gsssSDIRCMRtimes, 2)
	GUICtrlSetTip(-1, "Number of times to flash when a message is recived")
	GUICtrlSetCursor($gsssSDIRCMRtimes, 5)
	global	$gsssSDIRCMRdelay = GUICtrlCreateInput($sssSDIRCMRdelay, 196, 217, 33, 17, -1, $WS_EX_CLIENTEDGE + $ES_NUMBER)
	GUICtrlSetLimit($gsssSDIRCMRdelay, 4)
	GUICtrlSetTip(-1, "Delay between flashes")
	GUICtrlSetCursor($gsssSDIRCMRdelay, 5)
	GUICtrlCreateLabel("Delay:", 164, 217, 34, 17)
	global	$ssss2oundfile = GUICtrlCreateButton("File", 108, 236, 57, 17)
	GUICtrlSetCursor ($ssss2oundfile, 0)
	global	$gsssSDIRMRnickalert = GUICtrlCreateCheckbox("&Nick Alert", 52, 252, 73, 17)
	GUICtrlSetState(-1, $sssSDIRMRnickalert)
	GUICtrlSetTip(-1, "Tray message when someone says your nickname")
	GUICtrlSetTip(-1, "Display settings")
	GUICtrlSetCursor($sssDisplay, 0)
	global	$sssconnecttab = GUICtrlCreateTabItem("   Connection   ")
	global	$sssGroup3 = GUICtrlCreateGroup("Server", 28, 80, 297, 73)
	global	$gsssSCServer = GUICtrlCreateCombo("", 72, 96, 201, 21)
	GUICtrlSetData($gsssSCServer, "nsw-chat.bigpond.com|irc.freenode.net", $server)
	GUICtrlSetTip(-1, "Server")
	GUICtrlSetCursor($gsssSCServer, 5)
	GUICtrlCreateLabel("Server:", 32, 104, 38, 17)
	GUICtrlCreateLabel("Port:", 40, 128, 26, 17)
	global	$gsssSCport = GUICtrlCreateInput($sssSCport, 72, 128, 41, 17, -1, $WS_EX_CLIENTEDGE + $ES_NUMBER)
	GUICtrlSetLimit($gsssSCport, 5)
	GUICtrlSetTip(-1, "Port")
	GUICtrlSetCursor($gsssSCport, 5)
	global	$sssSCsadd = GUICtrlCreateButton("A&dd", 280, 96, 33, 17)
	GUICtrlSetTip(-1, "Add another server")
	GUICtrlSetCursor($sssSCsadd, 0)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	global	$gsssscac = GUICtrlCreateCheckbox("Auto &connect", 32, 168, 89, 17)
	GUICtrlSetState(-1, $sssscac)
	GUICtrlCreateLabel("Delay:", 128, 168, 34, 17)
	global	$gSsssCD = GUICtrlCreateInput($sssSCD, 160, 168, 25, 17, -1, $WS_EX_CLIENTEDGE + $ES_NUMBER)
	GUICtrlSetLimit($gsssSCD, 3)
	GUICtrlSetTip(-1, "Time until it automaticaly connects (in seconds)")
	GUICtrlSetCursor($gsssSCD, 5)
	GUICtrlSetTip(-1, "Connection")
	GUICtrlSetCursor($sssconnecttab, 0)
	global	$sssTabSheet2 = GUICtrlCreateTabItem("      Other      ")
	global	$sssGroup5 = GUICtrlCreateGroup("Log", 28, 88, 297, 41)
	global	$gsssSOlog = GUICtrlCreateCheckbox("Log chat", 40, 104, 65, 17)
	GUICtrlSetState(-1, $sssSOlog)
	GUICtrlSetTip(-1, "Log chat")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	global	$sssrestoredefault = GUICtrlCreateButton("Restore defaults", 32, 136, 89, 25)
	GUICtrlSetCursor($sssTabSheet2, 0)
	GUICtrlCreateTabItem("")
	GUICtrlSetCursor($sssSettings, 0)
	global	$sssSSsave = GUICtrlCreateButton("&Save", 16, 376, 241, 25)
	GUICtrlSetTip(-1, "Save settings")
	GUICtrlSetCursor($sssSSsave, 0)
	GUICtrlSetOnEvent($sssSSsave, "onsavesettings")
	global	$sssSSdiscard = GUICtrlCreateButton("Discard", 256, 376, 81, 25)
	GUICtrlSetOnEvent($sssSSdiscard, "Onsettingsclose")
	GUICtrlSetTip(-1, "Discard settings")
	GUICtrlSetCursor($sssSSdiscard, 0)
	global	$sssPic1 = GUICtrlCreatePic("Images\settings_ico.bmp", 184, 8, 41, 41)
	
	GUICtrlSetOnEvent($sssrestoredefault, "Onrestore")
	
	GUICtrlSetOnEvent($ssssdbgcolour, "onbackcolourchange")
	GUICtrlSetOnEvent($ssssdtextcolour, "ontextcolourchange")
	GUICtrlSetOnEvent($ssssdfont, "onfont")
	GUICtrlSetOnEvent($ssss2oundfile, "onsoundfile")
	
	;GUICtrlSetState ($gssssdscroll,$ssssdscroll);		checkbox
	;GUICtrlSetState ($gssssdwordwrap,$ssssdwordwrap);		checkbox
	;GUICtrlSetState ($gsssDSIRCRAWIRC,$sssDSIRCRAWIRC);		checkbox
	;GUICtrlSetState ($gsssDSIRCtray,$sssDSIRCtray);		checkbox
	;GUICtrlSetState ($gsssDSIRCPOPUP,$sssDSIRCPOPUP);		checkbox
	;GUICtrlSetState ($gsssDSIRCFlash,$sssDSIRCFlash);		checkbox
	;GUICtrlSetState ($gsssDSIRCSound,$sssDSIRCSound);		checkbox
	;GUICtrlSetState ($gsssSDIRMRnickalert,$sssSDIRMRnickalert);		checkbox
	;GUICtrlSetState ($gsssscac,$sssscac);		checkbox
	;GUICtrlSetState ($gsssSOlog,$sssSOlog);		checkbox
	
	;GUICtrlSetData ($sssSDIRCMRtimes,$sssSDIRCMRtimes);		input
	;GUICtrlSetData ($sssSDIRCMRdelay,$sssSDIRCMRdelay);		input
	;GUICtrlSetData ($sssSCport,$sssSCport);		input
	;GUICtrlSetData ($sssSCD,$sssSCD);		input
	
	
	;GUICtrlSetData($gsssSCServer, $sssSCServer);		Combo
	
	GUISetOnEvent($GUI_EVENT_CLOSE, "Onsettingsask", $gui22)
	
	
	GUISwitch($gui22)
	GUISetState()
	;hotkeyset ("^{f3}","oncoonecttab")
endfunc ()


; -------------------- Onsettingsask -----------------------

Func Onsettingsask()
	$save1 = MsgBox(32 + 3, "Save", "Save settings?") ; returns | 6 - yes | 7 - no |-1 timed out
	
	If $save1 = 6 Then onsavesettings() ; yes
	If $save1 = 7 Then Onsettingsclose(); no
	;If $save1 = 2 Then return ; cancel
EndFunc   ;==>Onsettingsask


; ------------------ Save settings --------------
Func onsavesettings()
	
	; ================== Read GUI CTRL ====================================
	
	$ssssdscroll = GUICtrlRead($gssssdscroll);		"&Auto Scroll"	- 1 checked, 4 not checked	checkbox
	$ssssdwordwrap = GUICtrlRead($gssssdwordwrap);	"&Word Wrap" 	- 1 checked, 4 not checked		checkbox
	$sssDSIRCRAWIRC = GUICtrlRead($gsssDSIRCRAWIRC);	"&Raw IRC" 	- 1 checked, 4 not checked		checkbox
	$sssDSIRCtray = GUICtrlRead($gsssDSIRCtray);	"&Tray Alerts"	- 1 checked, 4 not checked	checkbox
	$sssDSIRCPOPUP = GUICtrlRead($gsssDSIRCPOPUP);	"&Pop up Messages" - 1 checked, 4 not checked	checkbox
	$sssDSIRCFlash = GUICtrlRead($gsssDSIRCFlash);	"Flash"		- 1 checked, 4 not checked		checkbox
	$sssDSIRCSound = GUICtrlRead($gsssDSIRCSound);	"Sound" 	- 1 checked, 4 not checked		checkbox
	$sssSDIRMRnickalert = GUICtrlRead($gsssSDIRMRnickalert);	"&Nick Alert" 	- 1 checked, 4 not checked	checkbox
	$sssscac = GUICtrlRead($gsssscac);		"&Auto connect" - 1 checked, 4 not checked	checkbox
	$sssSOlog = GUICtrlRead($gsssSOlog);		"Log chat" 	- 1 checked, 4 not checked	checkbox
	$sssSDIRCMRtimes = GUICtrlRead($gsssSDIRCMRtimes);	"" - input
	$sssSDIRCMRdelay = GUICtrlRead($gsssSDIRCMRdelay);	"" - input
	$sssSCport = GUICtrlRead($gsssSCport);	 		"6667" - input
	$sssSCD = GUICtrlRead($gsssSCD);			"3" - input
	
	$sssSCServer = GUICtrlRead($gsssSCServer);		"" - Combo
	
	;if $gsssscac=1 then
	
	$port = $sssSCport
	
	;----------- Msgbox --------------------
	If $sssDSIRCPOPUP = 1 Then
		$msgboxm = "on"
	Else
		$msgboxm = "off"
	EndIf
	
	;----------- Tray --------------------
	If $sssDSIRCtray = 1 Then
		$traym = "on"
	Else
		$traym = "off"
	EndIf
	
	;----------- Raw --------------------
	If $sssDSIRCRAWIRC = 1 Then
		$raw = "on"
	Else
		$raw = "off"
	EndIf
	
	;----------- scroll --------------------
	If $ssssdscroll = 1 Then
		
		$scroll = "yes"
	Else
		$scroll = "no"
	EndIf
	
	
	$nn = 22
	;	_GUICtrlComboGetLBText($gsssSCServer, $nn, ByRef $s_text)
	;	$gsssSCServer2=
	
	
	;	_GUICtrlComboResetContent($vserver)
	
	;GUICtrlSetData($vserver, "", $sssSCServer)
	; "nsw-chat.bigpond.com|irc.freenode.net", $server)
	
	Onsaveinfo()
	Onsettingsclose()
EndFunc   ;==>onsavesettings


; ----------------delete ------------
Func ondelete()
	$dname = StringStripWS($rrname, 3)
	If StringInStr($dname, "@") Or StringInStr($dname, "+") Then $dname = StringMid($dname, 2)
	
	$delindex = _GUICtrlListFindString ($userlist, $dname, 1)
	If ($delindex == $LB_ERR) Then $delindex = _GUICtrlListFindString ($userlist, "@" & $dname, 1)
	If ($delindex == $LB_ERR) Then $delindex = _GUICtrlListFindString ($userlist, "+" & $dname, 1)
	
	If NOT ($delindex == $LB_ERR) Then _GUICtrlListDeleteItem ($userlist, $delindex)
EndFunc   ;==>ondelete



; ------------- settings close ---------------------

Func Onsettingsclose()
	opt("GUICloseOnESC", 0)         ;1=ESC  closes, 0=ESC won't close
	GUISwitch($IRCGUIW)
	GUISetState(@SW_ENABLE, $IRCGUIW)
	GUIDelete($gui22)
	
EndFunc   ;==>Onsettingsclose


; ------------- Save info ---------------------


Func Onsaveinfo()
	$nick = GUICtrlRead($vnick1e)
	$server = GUICtrlRead($vserver)
	;$port = GUICtrlRead($vPorte)
	RegWrite($regplace, "1 Nick", "REG_SZ", $nick)
	;RegWrite($regplace, "2 Name", "REG_SZ", $name)
	RegWrite($regplace, "4 Server", "REG_SZ", $server)
	;RegWrite($regplace, "5 Port", "REG_SZ", $port)
	
	RegWrite($regplace, "7 Save on exit", "REG_SZ", $save)
	
	; ---------------- ini settings -------------------------

	IniWrite($settingsplace, "Display \ chat log", "Chat Background Colour", $bcolour)
	IniWrite($settingsplace, "Display \ chat log", "Chat Text Colour",            $tcolour)
	
	IniWrite($settingsplace, "Display \ chat log", "Text Size",      $fsize       )
	IniWrite($settingsplace, "Display \ chat log", "Text Weight",  $fweight    )
	IniWrite($settingsplace, "Display \ chat log", "Text Attribute", $fattribute )
	IniWrite($settingsplace, "Display \ chat log", "Text Font",       $fontname)
	
	; ======================= Settings =============================================
	
	IniWrite($settingsplace, "Settings", 'Auto scroll', $ssssdscroll)
	IniWrite($settingsplace, "Settings", 'Raw IRC', $sssDSIRCRAWIRC)
	IniWrite($settingsplace, "Settings", 'Word wrap', $ssssdwordwrap)
	IniWrite($settingsplace, "Settings", 'Tray icon', $sssDSIRCtray)
	IniWrite($settingsplace, "Settings", 'Pop up', $sssDSIRCPOPUP)
	IniWrite($settingsplace, "Settings", 'Flash', $sssDSIRCFlash)
	IniWrite($settingsplace, "Settings", 'Sound', $sssDSIRCSound)
	IniWrite($settingsplace, "Settings", 'Sound file', $ssssdsoundfile)
	IniWrite($settingsplace, "Settings", "sssSDIRMRnickalert", $sssSDIRMRnickalert)
	IniWrite($settingsplace, "Settings", "sssscac", $sssscac)
	IniWrite($settingsplace, "Settings", "sssSOlog", $sssSOlog)
	IniWrite($settingsplace, "Settings", "sssSDIRCMRtimes", $sssSDIRCMRtimes)
	IniWrite($settingsplace, "Settings", "sssSDIRCMRdelay", $sssSDIRCMRdelay)
	IniWrite($settingsplace, "Settings", "sssSCport", $sssSCport)
	IniWrite($settingsplace, "Settings", "sssSCD", $sssSCD)
	IniWrite($settingsplace, "Settings", "sssSCServer", $sssSCServer)
	IniWrite($settingsplace, "Settings", "ssslog", $ssslog)
	
EndFunc   ;==>Onsaveinfo


; --------------- on restore ---------------------------------

Func onrestore()
	
	$save1 = MsgBox(32 + 4, "Restore Defaults?", "Are you sure that you want to restore the default settings?") ; returns | 6 - yes | 7 - no |-1 timed out
	If $save1 = 7 Then Return; no
	
	ondefaults()
	
	GUICtrlSetState($gssssdscroll, $ssssdscroll);			checkbox
	GUICtrlSetState($gssssdwordwrap, $ssssdwordwrap);		checkbox
	GUICtrlSetState($gsssDSIRCRAWIRC, $sssDSIRCRAWIRC);		checkbox
	GUICtrlSetState($gsssDSIRCtray, $sssDSIRCtray);			checkbox
	GUICtrlSetState($gsssDSIRCPOPUP, $sssDSIRCPOPUP);		checkbox
	GUICtrlSetState($gsssDSIRCFlash, $sssDSIRCFlash);		checkbox
	GUICtrlSetState($gsssDSIRCSound, $sssDSIRCSound);		checkbox
	GUICtrlSetState($gsssSDIRMRnickalert, $sssSDIRMRnickalert);	checkbox
	GUICtrlSetState($gsssscac, $sssscac);				checkbox
	GUICtrlSetState($gsssSOlog, $sssSOlog);				checkbox
	
	GUICtrlSetData($gsssSDIRCMRtimes, $sssSDIRCMRtimes);		input
	GUICtrlSetData($gsssSDIRCMRdelay, $sssSDIRCMRdelay);		input
	GUICtrlSetData($gsssSCport, $sssSCport);				input
	GUICtrlSetData($gsssSCD, $sssSCD);
	
	GUICtrlSetFont($Edit_10, $fsize, $fweight, $fattribute, $fontname)
	
	GUICtrlSetBkColor($Edit_10, $bcolour)
	GUICtrlSetColor($Edit_10, $tcolour)
	
EndFunc   ;==>onrestore



; ======================= on Defaults =============================================

Func ondefaults()
	
	Global $ssssdscroll = $GUI_CHECKED ;  checkbox at 737
	Global $ssssdwordwrap = $GUI_UNCHECKED;  checkbox at 740
	Global $sssDSIRCRAWIRC = $GUI_UNCHECKED;  checkbox at 743
	Global $sssDSIRCtray = $GUI_CHECKED ;  checkbox at 745
	Global $sssDSIRCPOPUP = $GUI_CHECKED ;  checkbox at 748
	Global $sssDSIRCFlash = $GUI_UNCHECKED;  checkbox at 751
	Global $sssDSIRCSound = $GUI_CHECKED;  checkbox at 753
	Global $sssSDIRMRnickalert = $GUI_CHECKED ;  checkbox at 767
	Global $sssscac = $GUI_UNCHECKED;  checkbox at 788
	Global $sssSOlog = $GUI_CHECKED ;  checkbox at 798
	
	Global $sssSDIRCMRtimes = "" ; 	input at 756
	Global $sssSDIRCMRdelay = "10" ; 	input at 760
	Global $sssSCport = 		"6667" ; 	input at 780
	Global $sssSCD = 		"3" ; 	input at 790
	
	Global $sssSCServer = "" ; 			Combo at 774
	Global $ssslog = 1
	
	Global $ssssdsoundfile = $path & "\chat-inbound.wav" 

	$bcolour = "0xFFFFFF" ; white is the default
	$tcolour = "0x000000" ; black is the default
	
	
	Global $fattribute = ""
	Global $fontname = ""
	Global $fsize = ""
	Global $fweight = ""
	
	
	
EndFunc   ;==>ondefaults

;----------------- chat log Change background colour---------

Func onbackcolourchange()
	$bcolour = _ChooseColor (2, $bcolour, 2)
	;If (@error) Then
	GUICtrlSetBkColor($Edit_10, $bcolour)
	;endif
EndFunc   ;==>onbackcolourchange

;----------------- chat log change text colour---------
Func ontextcolourchange()
	$tcolour = _ChooseColor (2, $tcolour, 2)
	;If (@error) Then
	GUICtrlSetColor($Edit_10, $tcolour)
	;endif
EndFunc   ;==>ontextcolourchange


;-------------- Change chat log font --------------------

Func onfont()
	
	$fontinfo = _ChooseFont ($fontname, $fsize, 1)
	;If (@error) Then
	$fattribute = $fontinfo[1]
	$fontname = $fontinfo[2]
	$fsize = $fontinfo[3]
	$fweight = $fontinfo[4]
	;$fcolour    = $fontinfo[5]
	
	GUICtrlSetFont($Edit_10, $fsize, $fweight, $fattribute, $fontname)
	;endif
EndFunc   ;==>onfont


Func oncoonecttab()
	_GUICtrlTabSetCurFocus ($sssSettings,2)
EndFunc   ;==>oncoonecttab

;------------------------------ on sound file ----------------------------------------
func onsoundfile() 
	$ssssdsoundfile = FileOpenDialog ("Recieve message sound", $path, "Wav files (*.wav)" , 1 , $ssssdsoundfile)
endfunc

; --------------------------------- on exit ---------------------------------


Func onexit2()
	
	TCPSend($socket, "QUIT :" & $quitreason & @CRLF) ; Send to the IRC server that you have quit and a quit reason
	Sleep(100)
	If $ssslog = 1 Then 
		$filedest=$path & "\Logs\" & $chatto & ".html"
		$file2=FileOpen ($filedest,9)
		Filewrite($file2,FileRead ("log.html"))
		fileclose($file2)

	;FileListToArray($path & "\log" [, $sFilter [, $iFlag]])




	endif
	
	If $lastplacechanged = "yes" Then RegWrite($regplace2, "LastKey", "REG_SZ", $lastkey)
	
	Global $save = RegRead($regplace, "7 Save on exit")
	If "t" & $save = "t" Then
		$save = "yes"
		RegWrite($regplace, "7 Save on exit", "REG_SZ", $save)
	EndIf
	
	If $save = "no" Then Return
	
	If $save > "-1" And $save < "1000" And $save <> "yes" Then
		$save1 = MsgBox(4, "Save", "Save settings?", $save) ; returns | 6 - yes | 7 - no |-1 timed out
		If $save1 > 6 Then Return
	EndIf
	
	onsaveinfo()
	
EndFunc   ;==>onexit2

; Show a menu in a given GUI window which belongs to a given GUI ctrl
Func ShowMenu($hWnd, $CtrlID, $nContextID)
	Local $hMenu = GUICtrlGetHandle ($nContextID)
	
	$arPos2 = ControlGetPos($hWnd, "", $CtrlID)
	$arpos = MouseGetPos()
	
	;msgbox(0,"",$arpos [1]  & " - " & $arpos2 [1])
	
	Local $x = $arpos[0]
	Local $y = $arpos[1] - 50
	
	ClientToScreen($hWnd, $x, $y)
	TrackPopupMenu($hWnd, $hMenu, $x, $y)
EndFunc   ;==>ShowMenu

; Convert the client (GUI) coordinates to screen (desktop) coordinates
Func ClientToScreen($hWnd, ByRef $x, ByRef $y)
	Local $stPoint = DllStructCreate("int;int")
	
	DllStructSetData($stPoint, 1, $x)
	DllStructSetData($stPoint, 2, $y)
	
	DllCall("user32.dll", "int", "ClientToScreen", "hwnd", $hWnd, "ptr", DllStructGetPtr($stPoint))
	
	$x = DllStructGetData($stPoint, 1)
	$y = DllStructGetData($stPoint, 2)
	; release Struct not really needed as it is a local
	$stPoint = 0
EndFunc   ;==>ClientToScreen


; Show at the given coordinates (x, y) the popup menu (hMenu) which belongs to a given GUI window (hWnd)
Func TrackPopupMenu($hWnd, $hMenu, $x, $y)
	DllCall("user32.dll", "int", "TrackPopupMenuEx", "hwnd", $hMenu, "int", 0, "int", $x, "int", $y, "hwnd", $hWnd, "ptr", 0)
EndFunc   ;==>TrackPopupMenu

;====================== ABOUT GUI ===============
Func onabout()
	onlines()
	
	GUISetState(@SW_DISABLE, $IRCGUIW)
	opt("GUICloseOnESC", 1)         ;1=ESC  closes, 0=ESC won't close
	
	; == GUI generated with Koda ==
	Global $AboutGUI = GUICreate("About", 456, 259, 302, 218, $WS_CLIPSIBLINGS);  $DS_CONTEXTHELP
	$GroupBox1 = GUICtrlCreateGroup("", 8, 8, 435, 185)
	GUICtrlCreatePic($path & "\autoit.jpg", 16, 24, 105, 97)
	GUICtrlCreateLabel("Adam1213's IRC Client", 152, 16, 139, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	GUICtrlSetBkColor(-1, 0xFFFF00)
	GUICtrlCreateLabel("Version: " & $version, 152, 40, 98, 17)
	GUICtrlCreateLabel("Release Date: " & $releasedate, 152, 56, 144, 17)
	GUICtrlCreateLabel("Lines: " & $lines, 152, 72, 80, 17)
	GUICtrlCreateLabel("Pages: " & $pages, 152, 88, 77, 17)
	GUICtrlCreateLabel("Adam1213™© - www.adam1213.tk (main programer)", 152, 104, 278, 17)
	GUICtrlCreateLabel("David            - www.totaldave.tk (Connect 4, links and more)", 152, 120, 289, 17)
	
	GUICtrlCreateLabel("Programed in Autoit script. Beta version: " & @AutoItVersion, 16, 144, 265, 17)
	GUICtrlCreateLabel("Some of the GUI was made in Koda FormDesigner 1.4", 16, 160, 259, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	$aboutok = GUICtrlCreateButton("&OK", 152, 200, 83, 25)
	GUICtrlSetCursor($aboutok, 0)
	GUICtrlSetOnEvent($aboutok, "Onaboutclose")
	
	GUISetOnEvent($GUI_EVENT_CLOSE, "Onaboutclose", $AboutGUI)
	
	GUISwitch($AboutGUI)
	
	GUISetState()
EndFunc   ;==>onabout

Func Onaboutclose() ;---- Onaboutclose ----
	opt("GUICloseOnESC", 0)         ;1=ESC  closes, 0=ESC won't close
	GUISwitch($IRCGUIW)
	GUISetState(@SW_ENABLE, $IRCGUIW)
	GUIDelete($AboutGUI)
EndFunc   ;==>Onaboutclose

;===================== CALABRATION ========================================================================
Func Oncalabratepixelsperline($silent=0) ; --------------------------------------------------------------------------------------
	;$pixelsperlinecalebrated=1
	$textline=''
	for $i=0 to @DesktopWidth/3
		$textline&='<BR>'
	next
	$old_URL=$oIE.LocationURL
	$oIE.Document.WriteLn ($textline)
	sleep(200)
	$pixel_s=$oIE.document.body.scrollHeight
	$oIE.Document.WriteLn ('<br>a')
	$pixel_e=$oIE.document.body.scrollHeight
	$pixelsperline=$pixel_e-$pixel_s*2
	sleep(30)
	$oIE.navigate($old_URL)
	;IniWrite($settingsplace, "Display \ chat log", "Pixels Per Line",              $pixelsperline) ; Number of pixels per line (used for scrolling)	
	if $silent=0 then 
		$textline=@CRLF & "<span style=""background-color: #000000""><font color=""#FFFF00"">Pixels Per Line calibration Complete. Now set to " & $pixelsperline & " pixels per line</font></span>" & @CRLF
		onchatlog ($textline)
	endif
EndFunc

Func Oncalcharpl()

	$textline="<p dir=""ltr""><span style=""background-color: #FFFF00"">123456789</span><span style=""background-color: #008000"">0123456789</span><span style=""background-color: #00FF00"">0123456789</span><span style=""background-color: #00FFFF"">0123456789</span><span style=""background-color: #0000FF"">0123456789</span><span style=""background-color: #008080"">0123456789</span><span style=""background-color: #808080"">0123456789</span><span style=""background-color: #000000""><font color=""#FFFFFF"">0123456789</font><font color=""#00FFFF"">0123456789</font></span><span style=""background-color: #000000""><font color=""#00FF00"">0123456789</font><font color=""#0000FF"">0123456789</font><font color=""#008080"">0123456789</font></span></p>" & @CRLF & _
	"<p dir=""ltr""><span style=""background-color: #FFFF00"">00x<br>" & @CRLF & _
	"</span><span style=""background-color: #008000"">01x</span><span style=""background-color: #FFFF00""><br>" & @CRLF & _
	"</span><span style=""background-color: #00FF00"">02x</span><span style=""background-color: #FFFF00""><br>" & @CRLF & _
	"</span><span style=""background-color: #00FFFF"">03x</span><span style=""background-color: #FFFF00""><br>" & @CRLF & _
	"</span><span style=""background-color: #0000FF"">04x</span><span style=""background-color: #FFFF00""><br>" & @CRLF & _
	"</span><span style=""background-color: #008080"">05x</span><span style=""background-color: #FFFF00""><br>" & @CRLF & _
	"</span><span style=""background-color: #808080"">06x</span><span style=""background-color: #FFFF00""><br>" & @CRLF & _
	"</span><font color=""#FFFFFF""><span style=""background-color: #000000"">07x</span></font><span style=""background-color: #FFFF00""><br>" & @CRLF & _
	"</span><span style=""background-color: #000000""><font color=""#00FFFF"">08x</font></span><span style=""background-color: #FFFF00""><br>" & @CRLF & _
	"</span><font color=""#00FF00""><span style=""background-color: #000000"">09x</span></font><span style=""background-color: #FFFF00""><br>" & @CRLF & _
	"</span><span style=""background-color: #000000""><font color=""#0000FF"">10</font></span><font color=""#0000FF""><span style=""background-color: #000000"">x</span></font><span style=""background-color: #FFFF00""><br>" & @CRLF & _
	"</span><font color=""#008080""><span style=""background-color: #000000"">11x</span></font></p>" & @CRLF

	onchatlog ($textline)
	sleep(200)
	$textline="" ; blank textline as there is so much in it

	$linelenmax=InputBox ( "Characters per line ", "Enter the coresponding number to the number at the end of the line", $linelenmax)

	IniWrite($settingsplace, "Display \ chat log", "Max Characters Per Line", $linelenmax) ; Number of characters per line (used for scrolling, if line is going to be split)	
EndFunc


;==========================================================================================================

; ------------------ colour functions -------------------------
func oncolour0()
	oncolour(0)
endfunc
func oncolour1()
	oncolour(1)
endfunc
func oncolour2()
	oncolour(2)
endfunc
func oncolour3()
	oncolour(3)
endfunc
func oncolour4()
	oncolour(4)
endfunc
func oncolour5()
	oncolour(5)
endfunc
func oncolour6()
	oncolour(6)
endfunc

func oncolour7()
	oncolour(7)
endfunc

func oncolour8()
	oncolour(8)
endfunc

func oncolour9()
	oncolour(9)
endfunc

func oncolour10()
	oncolour(10)
endfunc

func oncolour11()
	oncolour(11)
endfunc

func oncolour12()
	oncolour(12)
endfunc

func oncolour13()
	oncolour(13)
endfunc

func oncolour14()
	oncolour(14)
endfunc

func oncolour15()
	oncolour(15)
endfunc

func oncolourbold()
	oncolourg("")
endfunc

func oncolourunderline()
	oncolourg("")
endfunc

func oncoloure1()
	oncolourg(":-)")
endfunc

func oncoloure28()
	oncolourg(":-(")
endfunc


; -----------------------------------------------

func oncolour($button)
	if $rightclick=0 then
		$chat12n="" & $button
	else
		$chat12n="," & $button
	endif
	oncolourg($chat12n)
endfunc

func oncolourg($chat12n)
	$chat12f=GUICtrlRead($chat12) & $chat12n
	GUICtrlSetData($chat12,  $chat12f )
	GUICtrlSetState($chat12, $GUI_FOCUS)
	If WinActive($IRCGUIW) Then ControlSend ($title, "", $chat12s, "{end}")
endfunc

;======================= TAB =========================================================


func ontabclick()

	$lasttab2=$lasttab
	sleep(100)
	$tabsel=_GUICtrlTabGetCurSel($tabchan)
	$tabinfo=$tabarray[$tabsel]
	$chatto=$tabinfo
	$lasttab=$chatto
	$filedest2=$path & "\Log\" & $tabinfo & ".html"
	$oIE.navigate($filedest2)
	while $oIE.Busy
		sleep(1)
	wend
	 $textline2 = _IEBodyReadHTML($oIE)
	if $textline2="0" then $textline2=@CRLF
	onchatlog($textline2)
	GUICtrlSetData($vchatto, $chatto) 

	if $chatto<>"Console" then
		onsend("/namesc",0) 
	else
		onsend("/names",0)
	endif

endfunc

func joinbutton()
	HotKeySet("{Enter}")
	$room=inputbox("Room", "Enter the room that you want to join", "")
	HotKeySet("{Enter}", "EnterSends");
	$room=stringstripws($room,3)
	if $room<>"#" AND $room<>"" then
		onsend("/join " & $room)
	endif
endfunc

func partbutton()
	$room=GUICtrlRead ($vchatto)
	onsend("/part " & $room)
endfunc


func onfilemake($filedest2)
	_FileCreate ($filedest2)
	FileWrite ($filedest2,   		   _
	"<head>" & @CRLF & 		   _
	"<base target=""_blank"">" & @CRLF & _
	"</head>" & @CRLF)
endfunc


;====================== ON UPDATE ==================================
Func onUpdate()
	Dim $URL
	$URL = "                                   "
	_filecreate("newest.txt")
	InetGet($URL & "/newest.txt", "newest.txt", 1)
	;TrayTip ( "loaded", "done", 1)
	
	FileOpen("newest.txt", 1)
	
	$nversion = FileReadLine("newest.txt", 1)
	$nrdate = FileReadLine("newest.txt", 2)
	
	if $nversion="" AND $nrdate="" then 
		MsgBox(16, "Error", "Could not connect to the server")
	else
	
		If $nversion > $version Then
			$asku = MsgBox(36, "New version available", "You have " & $version & " - Released " & $releasedate & @CRLF & "Version  " & $nversion & " - Released " & $nrdate & " is available" & @CRLF & @CRLF & "Do you want to Update?")
			
			If $asku == "6" Then
				;6 - means yes was selected
				
				$desktop = @DesktopDir
				
				$updateplace = FileSaveDialog( "Place for the new version", $desktop, "Executable (*.exe)", 2, "IRC.exe")
				InetGet($URL & "update.exe", $updateplace, 1, 0)
				$sstarted = $updateplace
				
				$place22 = StringLeft($updateplace, StringInStr($updateplace, "\", 0, -1))
				Run("explorer.exe " & $place22)
					
				EndIf
				
			Else
				MsgBox(64, "Latest version", "You have " & $version & " - Released " & $releasedate & " which is the latest version.")
			EndIf
	endif

#cs
	onlines()
	GUISetState(@SW_DISABLE, $IRCGUIW)
	; == GUI generated with Koda ==
	Global $AboutGUI = GUICreate("Update", 323, 233, 302, 218, $DS_CONTEXTHELP)
	GUICtrlCreateGroup("", 8, 8, 305, 155)
	GUICtrlCreatePic($path & "\autoit.jpg", 16, 24, 105, 97)
	GUICtrlCreateLabel("Adam1213's IRC Client", 152, 16, 139, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	GUICtrlSetBkColor(-1, 0xFFFF00)
	GUICtrlCreateLabel("Version: " & $version,                152,  40,  98,   17)
	GUICtrlCreateLabel("Release Date: " & $releasedate, 152,  56,  144, 17)
	GUICtrlCreateLabel("Lines: " & $lines,                       152,  72,  80,  17)
	GUICtrlCreateLabel("Pages: " & $pages,                   152,  88,  77,   17)
	GUICtrlCreateLabel("Adam1213™©",                        152, 104, 100, 17)
	
	GUICtrlCreateLabel("Version: " & $version, 200, 40, 98, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	$aboutok = GUICtrlCreateButton("&OK", 112, 170, 75, 25)
	GUICtrlSetCursor($aboutok, 0)
	GUICtrlSetOnEvent($aboutok, "Onaboutclose")
	
	GUISetOnEvent($GUI_EVENT_CLOSE, "Onaboutclose", $AboutGUI)
	
	GUISwitch($AboutGUI)
	
	GUISetState()
#ce 


EndFunc   ;==>onUpdate


;================================= CONNNECT 4==========================================================================

Func onconnect4()
	if $c4open=0 then
		HotKeySet("^p","c4putpiece")
		Global $c4place
		Global $c4othercolour
		Global $c4colour
	
		$oIE.navigate ($path & "\conframes.html")
		$oIE.StatusBar = True
		Global $c4last = ""
		Global $c4close = "no"
		$c4open = 1
	endif
EndFunc   ;==>onconnect4

	GUISetState()       ;Show GUI

;While $c4close = "no"
Func onc4update()

	if $c4open  then 
		global $c4text = _IEFormElementGetValue (_IEFormElementGetObjByName (_IEFormGetObjByName (_IEFrameGetObjByName($oIE,"c4appframe"), "c4form"), "placeinfo"))
		If $c4text <> $c4last Then
			$c4last = $c4text
			TrayTip("status text", $c4text, 10, 16)
			onsend("pc4 " & $c4text)

			;msgbox(0,"status text", $c4text)
			If StringInStr($c4text, "won") <> 0 Then
				$c4woncol = StringMid($c4text, StringInStr($c4text, "won") + 3)
				onsend("pc4 AUW")
				MsgBox(0, "Victory", "AutoIt realises that " & $c4woncol & " has won. Hehe.")
				sleep(1000)
				$oIE.refresh
			ElseIf StringInStr($c4text, "close") <> 0 Then
				$c4open = 0
				$oIE.navigate($filedest2)
			EndIf
		EndIf
	endif
	
	;WEnd
EndFunc   ;==>onc4update

func onc4recv()
	c4extractrecv()
	c4sendplace($c4place,$c4colour)
endfunc

Func c4sendplace($numplace, $imgcolour)
	$oIE.navigate ("javascript:void(parent.c4appframe.document.conseg[" & $numplace & "].src=" & $imgcolour & "img.src);")
EndFunc   ;==>c4sendplace

Func c4putpiece()
	If $c4text <> "waiting" Then
		c4extractvars()
		$c4otherplace = InputBox("place", "Where should other person go? (number)", "")
		c4sendplace($c4otherplace, $c4othercolour)
	EndIf
EndFunc   ;==>c4putpiece
Func c4extractvars()
	If StringInStr($c4text,"waiting") == 0 Then
		; $c4tpl, $c4epl, and $c4diffamt are used in extracting the place var...
		$c4tpl = StringInStr($c4text, "t")
		$c4epl = StringInStr($c4text, "e")
		$c4diffamt = $c4tpl - $c4epl - 1
		; The place variable!
		$c4place = StringMid($c4text, 6, $c4diffamt)
		; The colour variable!
		$c4colour = StringMid($c4text, StringInStr($c4text, "turn") + 4, 3)
		; And finally, othercolour.
		If $c4colour == "yel" Then
			$c4othercolour = "red"
		ElseIf $c4colour == "red" Then
				$c4othercolour = "yel"
		EndIf
	EndIf
EndFunc   ;==>c4extractvars

Func c4extractrecv()
	If StringInStr($c4recv,"waiting") == 0 Then
		If StringInStr($c4recv,"AUW") <> 0 Then
			MsgBox(0,"",$rrname & " has won!")
			$oIE.navigate("javascript:parent.c4appframe.location.reload();")
		Else
			; $c4tpl, $c4epl, and $c4diffamt are used in extracting the place var...
			$c4tpl = StringInStr($c4recv, "t")
			$c4epl = StringInStr($c4recv, "e")
			$c4diffamt = $c4tpl - $c4epl - 1
			; The place variable!
			$c4place = StringMid($c4recv, 6, $c4diffamt)
			; The colour variable!
			$c4colour = StringMid($c4recv, StringInStr($c4recv, "turn") + 4, 3)
			; And finally, othercolour.
			If $c4colour == "yel" Then
				$c4othercolour = "red"
			ElseIf $c4colour == "red" Then
				$c4othercolour = "yel"
			EndIf
		EndIf
	EndIf
EndFunc   ;==>c4extractrecv

Func c4OnExit()
	HotKeySet("^p")
	$c4close = "yes"
	$c4open = 0
EndFunc   ;==>c4OnExit

Func onlines() ; count lines
	If @Compiled = 0 Then Global $lines = @ScriptLineNumber + 2
	Global $pages = Round($lines / 50+0.49999999)
EndFunc