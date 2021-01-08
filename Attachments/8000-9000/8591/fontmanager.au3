;|¯ |¯| |\| ¯|¯   |\/| /¯\ |\| /¯\ |¯  |¯ |¯| 
;|¯ |_| | |  |      |  | |¯| | | |¯|  | | |¯ |¯\ 
;                                    ¯   ¯     
; ===== By Brad Reddicopp =======
;           ----------Enjoy----------
;
;For use with: http://www.webpagepublicity.com/free-fonts.html
;
;Readme:
;            All your downloaded fonts are stored in "My Documents\My Fonts" folder.
; Simply run this program and go to http://www.webpagepublicity.com/free-fonts.html 
; and then find your favorite fonts to download. click the download link, and then this script will 
; interrupt your download and download it with its own bulit in downloader. After it downloads'
;, it will ask you wheather if you want to install it. Click yes or no. There you go! a easy, 
;free, font download manager!

#include <INet.au3>
#include <GUIConstants.au3>
Global $dlurl = ""
Global $filename = ""
dircreate(@MyDocumentsDir & "\My Fonts\")
iniwrite(@MyDocumentsDir & "\My Fonts\desktop.ini", ".ShellClassInfo", "IconFile", "%SystemRoot%\system32\SHELL32.dll")
iniwrite(@MyDocumentsDir & "\My Fonts\desktop.ini", ".ShellClassInfo", "IconIndex", "38")
FileSetAttrib(@MyDocumentsDir & "\My Fonts\desktop.ini", "+HS")
while 1
find()

wend

func find()
if winexists("File Download", "www.webpagepublicity.com") and winexists("File Download", ".ttf") then
$url1 = ""
do
$url1 = ControlGetText ( "File Download", "www.webpagepublicity.com", 4419 )
until $url1 <> ""
winclose("File Download", "www.webpagepublicity.com")
$url2 = "http://www.webpagepublicity.com/free-fonts/" & StringLower (StringLeft ( $url1, 1 )) & "/" & _INetExplorerCapable ( $url1 )
Global $dlurl = $url2
Global $filename = $url1
download()
endif
endfunc

func download()
if $dlurl = "" then return
if $filename = "" then return
TrayTip("Downloading", "Downloading Your Font..." & @CRLF & "Progress: Starting...", 10, 1)
$size = InetGetSize ( $dlurl )
InetGet($dlurl, @MyDocumentsDir & "\My Fonts\" & $filename, 1, 1)
global $ffile = @MyDocumentsDir & "\My Fonts\" & $filename
While @InetGetActive
  TrayTip("Downloading", "Downloading Your Font..." & @CRLF & "Progress: " & @InetGetBytesRead / 1024 & " KB", 0, 116)
Wend
TrayTip("Downloading", "Downloading Your Font..." & @CRLF & "Progress: Done", 5, 1)
sleep(2000)
TrayTip("", "",0)
if FileGetSize ( $ffile) <> $size then
msgbox(0, "Font Manager", "Download Failed")
filedelete($ffile)
return
endif
Global $hwnd2 = GUICreate("Font Manager", 150, 100, @Desktopwidth - 150, @DesktopHeight - 100 - 20, 0, BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
$yes = GUICtrlCreateButton("Yes", 22, 44, 43, 29, 0)
$no = GUICtrlCreateButton("No", 76, 44, 43, 29, $BS_DEFPUSHBUTTON)
GUICtrlCreateLabel("Install Downloaded Font?", 14, 14, 124, 17)
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd2, "int", 500, "long", 0x00040002);
GUISetState(@SW_SHOW)
while 1
	$msg = GUIGetMsg()
	IF $msg = $GUI_EVENT_CLOSE then
	exitloop
	endif
	if $msg = $yes then
	fade()
	guidelete($hwnd2)
	$inst = installfont($ffile)
	if $inst = 1 then
	msgbox(0,"Font Manager", "Font '" & $filename & "' Has Been Installed")
	endif
	if $inst = 2 then
	msgbox(0,"Font Manager", "Font '" & $filename & "' Is Already Installed")
	endif
	if $inst = 0 then
	msgbox(0,"Font Manager", "Font '" & $filename & "' Failed To Install")
	endif
	exitloop
	endif
	if $msg = $no then
	fade()
	guidelete($hwnd2)
	exitloop
	endif
	
wend

endfunc

Func Slide_in()
	DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd2, "int", 500, "long", 0x00040002);slide in from right
	WinActivate($hwnd2)
EndFunc  

Func fade()
	DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd2, "int", 500, "long", 0x00090000);fade-out
EndFunc

#include <file.au3>

func installfont($file)
; Font Function By Spyrorocks
dim $drive,$dir,$fname,$ext
if not fileexists($file) then
seterror(-1)
return 0
endif
$path = _PathSplit($file, $drive, $dir, $fname, $ext)
if not $path[4] = "ttf" then
if not $path[4] = "fon" then
seterror(2)
return 0
endif
endif
if fileexists(@WindowsDir & "\Fonts\" & $path[3] & $path[4]) then return 2
if filecopy($file, @WindowsDir & "\Fonts\" & $path[3] & $path[4]) = 0 then
seterror(1)
return 0
endif
return 1
endfunc
