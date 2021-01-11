#cs ----------------------------------------------------------------------------

If you have a valid UK Postcode on your clipboard it will automatically show a map
of the location using the browser (Internet explorer or Firefox) and the web site 
of your choice (Multimap or Streetmap).
If there is nothing on the clipboard it will prompt you for a postcode

A little checking is done for valid post code formats
some test codes are 'GU7 1DN', 'DE7 8HL', 'SG19 3RD'

Using the configuraton detailed in the ini file below

Put the program in your startup to run automatically and use

 Ctrl-Alt-m  (Change the hotkey in the ini file if you feel like it.)
 
or right click on the tray-icon to activate it


Create a map.ini with these contents and place it in the same folder as the script
if you add/change the web site to use then you need to make sure that the 
value for the [Defaults] 'Sitename' must have a corresponding key & value under [Siteurl]

; ############################## Ini file Start ##############################
; default sitename can be whatever you want it to be
: as long as there is a matching Siteurl
;
; HotKey Below = Ctrl+ALt+m change it if you want
;

[Defaults]
HotKey=^!m
Sitename=Multimap
;Sitename=Streetmap

; Configure the correct browser here 
BrowserPath=C:\Program Files\Internet Explorer\iexplore.exe
;BrowserPath="C:\Program Files\Mozilla Firefox\Firefox.exe"


[Siteurl]
Multimap=                                                                                           
Streetmap=http://www.streetmap.co.uk/newsearch.srf?mapp=newmap&searchp=newsearch&name=

; ############################## Ini file End ##############################

#ce ----------------------------------------------------------------------------
;~ #notrayicon
#include <GUIConstants.au3>
#include <Array.au3>
Opt("GUIOnEventMode", 1)
Opt("TrayMenuMode",1)          

$restoreitem	= TrayCreateItem("Restore")
$dummy			= TrayCreateItem("")
$exititem       = TrayCreateItem("Exit")


$g_szVersion = "MAP 1.2"
If WinExists($g_szVersion) Then 
	WinActivate ( $g_szVersion )
	Exit ; It's already running
EndIf

Global $Site = ""
Global $BrowserPath = ""
Global $SiteUrl = ""

;~ uncomment the 'FileInstall' line below and change the path if your ini is in a different place 
;~ and you need to re-compile the source and distribute it!
;FileInstall( "C:\Program Files\AutoIt3\Examples\Mine\Map\map.ini", @ScriptDir & "\map.ini")

#Region ### START  GUI section ### 
$Form1_1 = GUICreate("" , 160, 70,@DesktopWidth/2-80, @Desktopheight/2-35,-1, BitOR($WS_EX_TOOLWINDOW,$WS_EX_TOPMOST))
$PostCode = GUICtrlCreateInput("", 70, 10, 60, 20)
$Search = GUICtrlCreateButton("Search", 10, 40, 140, 25, 0)
GUICtrlSetOnEvent(-1, "SearchClick")
GUICtrlSetState($Search ,$GUI_DEFBUTTON)
$PostcodeLabel = GUICtrlCreateLabel("Post Code", 8, 8, 53, 17)
#EndRegion ### END GUI section ###

GUISetOnEvent($GUI_EVENT_CLOSE,"OnExit")

Init()

While 1
	$msg = TrayGetMsg()
    Select
        Case $msg = $exititem
            Exit
		Case $msg = $restoreitem
			GUISetState(@SW_SHOW)  
			WinSetTitle("","",$Site)
    EndSelect
WEnd
		
Func Init()
	$Site = IniRead(@ScriptDir & "\map.ini","Defaults","Sitename","Multimap")
	$BrowserPath = IniRead(@ScriptDir & "\map.ini","Defaults","BrowserPath","")
	$SiteUrl = IniRead(@ScriptDir & "\map.ini","Siteurl",$Site,"")
	HotKeySet("^!m", "DoSearch")  ;Ctrl-Alt-m
EndFunc

Func DoSearch()
	$clipbrd = ClipGet()
	GUICtrlSetData($PostCode,IsThisAPostCode($clipbrd))
	If StringLen(GUICtrlRead($postcode)) > 5 Then	; If there is a valid postcode on the clipboard the automatically search
		SearchClick()								
	Else	; Otherwise show the form
			GUISetState(@SW_SHOW)  
			WinSetTitle("","",$Site)
		EndIf											
EndFunc

Func SearchClick()
	Run($BrowserPath & " " & $SiteUrl & IsThisAPostCode(GUICtrlRead($postcode)))
	onExit()
EndFunc

Func IsThisAPostCode($clipbrd)
	; a bit of a bodge and should have been done using StringMid, but it works and was fun
	$clipbrd =StringStripWS($clipbrd,8)
	$bits = StringSplit($clipbrd,"")
	If $bits[0] > 7 Then	;to long
		Return ""
	EndIf
;~ 	Valid UK Post Code formats
;~ 	ANNAA  	M1 1AA
;~ ANNNAA 	M60 1NW
;~ AANNAA 	CR2 6XH
;~ AANNNAA 	DN55 1PT
;~ ANANAA 	W1A 1HP
;~ AANANAA 	EC1A 1BB 

	$teststr = ""
	For $loop = 1 To $bits[0]
		If StringIsAlpha($bits[$loop]) Then
			$teststr = $teststr & "A"
		EndIf
		If StringIsDigit($bits[$loop]) Then
			$teststr = $teststr & "N"
		EndIf
	Next
	
	; valid UK postcode Masks
	If $teststr = "ANNAA" then Return $clipbrd
	If $teststr = "ANNNAA" then Return $clipbrd
	If $teststr = "AANNAA" then Return $clipbrd
	If $teststr = "AANNNAA" then Return $clipbrd
	If $teststr = "ANANAA" then Return $clipbrd
	If $teststr = "AANANAA" then Return $clipbrd

	Return ""	;not a valid Post code so return nothing (and prompt the user)
EndFunc

Func onExit()
	GUISetState(@SW_HIDE)  
EndFunc