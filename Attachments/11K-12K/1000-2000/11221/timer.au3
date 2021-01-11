#notrayicon
#include <GUIConstants.au3>
#include <Date.au3>
#include <GuiListView.au3>

Opt("GUIOnEventMode", 1)

$g_szVersion = "Timer 1.3"

HotKeySet("{PRINTSCREEN}", "StartTimer")

$time = ""
$now = 0
$total = 0
$oldtotal = 0
$elapsed = 0
$timerstarted = 0
$RetVal = 0
$clipStr = ""

$Form1 = GUICreate($g_szVersion , 275, 110, 195, 123, -1, BitOR($WS_EX_TOOLWINDOW,$WS_EX_TOPMOST))

$filemenu = GuiCtrlCreateMenu ("File")
$exititem = GuiCtrlCreateMenuitem ("Exit",$filemenu)
GUICtrlSetOnEvent($exititem ,"OnExit")

$helpmenu = GuiCtrlCreateMenu ("Help")
$Infoitem = GuiCtrlCreateMenuitem ("Info",$helpmenu)
GUICtrlSetOnEvent($Infoitem ,"OnInfo")

$separator1 = GuiCtrlCreateMenuitem ("",$helpmenu)
$aboutitem = GuiCtrlCreateMenuitem ("About",$helpmenu)
GUICtrlSetOnEvent($aboutitem ,"OnAbout")

$Button1 = GUICtrlCreateButton("Start/Mark", 0, 0, 73, 25, 0)
GUICtrlSetOnEvent($Button1 ,"StartTimer")

$Button2 = GUICtrlCreateButton("To Clipboard", 0, 32, 73, 25, 0)
GUICtrlSetOnEvent($Button2 ,"SendtoClip")

$Button3 = GUICtrlCreateButton("Reset", 0, 64, 73, 25, 0)
GUICtrlSetOnEvent($Button3 ,"ResetTimer")

$List1 = GUICtrlCreateListView ("Curr. Time|Interval|Elapsed",80,0,195,90)
;GUICtrlCreateListViewItem( "Use|Print|Scrn",$List1)


;GUISetOnEvent($GUI_EVENT_CLOSE,"OnExit")
GUISetState(@SW_SHOW)

While 1
	sleep(100)
	if $timerstarted Then	;Update the title bar (mostly just to have something to look at.)
		ReadTimer()
		WinSetTitle($g_szVersion , "", $g_szVersion & "         (" & FMTMSec($elapsed) & ")")
	EndIf
WEnd

Func StartTimer()
	if $timerstarted = 0 then
		$RetVal = InitTimer()
		WinSetTrans ( $g_szVersion , "", 210 )
	else
		$RetVal = MarkTimer()
	endif
EndFunc

Func InitTimer ()
	$clipStr = ""
	$total = 0
	$oldtotal = 0
	$elapsed=0
	$now = TimerInit()
	$time = @HOUR & ":" & @MIN & ":" & @SEC
	$timerstarted = 1
	$RetVal = AddtoList()
EndFunc

Func MarkTimer()
	ReadTimer()
	$oldTotal = $total
	$RetVal = AddtoList()
EndFunc

Func ReadTimer()
	$total = TimerDiff($now)
	$time = @HOUR & ":" & @MIN & ":" & @SEC
	$elapsed = $total - $oldtotal
EndFunc

Func ResetTimer()
	$timerstarted=0
	_GUICtrlListViewDeleteAllItems ($List1)
	WinSetTitle($g_szVersion , "", $g_szVersion)
	WinSetTrans ( $g_szVersion , "", 255 )
EndFunc

Func FMTMSec($iTicks)

$iSec=0
$iMin=0
$iHour=0
$retstr = "SDF"

$iTicks = $iTicks/100 ; 10ths of seconds

	$iSec  = mod(Int($iTicks/10),60)
	$iMin = mod(Int($iTicks / 600),60)
	$iHour = mod(Int($iTicks/ 600 / 60 ),60)
	$retstr = $iHour & ":" & $iMin & ":" & $iSec & "." & int(mod($iTicks, 10))
	Return $retstr 

EndFunc

Func AddtoList()
	$OutStr = $time & "|" & FMTMSec($elapsed) & "|" & FMTMSec($total)
	GUICtrlCreateListViewItem( $OutStr,$List1)
	$clipStr = $clipStr &  $OutStr & @CRLF
EndFunc

Func SendtoClip()
	ClipPut($clipStr)
EndFunc

Func OnAbout()
	Msgbox(0,"About",$g_szVersion & @CRLF & @CRLF & "© Not Really.")
EndFunc

Func onInfo()
	$msg = $g_szVersion & @CRLF & "© Not Really." & @CRLF & @CRLF
	$msg = $msg & "This is a helper application to assist in obtaining timing details" & @CRLF 
	$msg = $msg & "'Time' is the current time." & @CRLF
	$msg = $msg & "'Interval' is the time since the last 'Mark'" & @CRLF
	$msg = $msg & "'TElapsed' is the time since starting the Timer" & @CRLF 
	$msg = $msg & "All times are in Hours:Minutes:Seconds.Decimal seconds" & @CRLF & @CRLF
	
	$msg = $msg & "The Timer will always try and remain above other windows." & @CRLF
	$msg = $msg & "To prevent closing the application accidentally," & @CRLF
	$msg = $msg & "It can only be closed using the 'File' --> 'Exit' menu" & @CRLF & @CRLF

	$msg = $msg & "Start timing by clicking the 'Start/Mark' button" & @CRLF 
	$msg = $msg & "Clicking 'Start/Mark' again will place another timing mark in the listview." & @CRLF
	$msg = $msg & "Pressing 'Print Screen' will have the same effect as pressing 'Start/Mark'" & @CRLF
	$msg = $msg & "Copy to Clipboard' will copy contents of the timing listview to the clipboard." & @CRLF 
	$msg = $msg & "this pastes into Excel very nicely." & @CRLF 
	$msg = $msg & "'Reset' does exactly that."  & @CRLF
	
	Msgbox(0,"Information",$msg )
EndFunc

Func onExit()
	GUIDelete()
	Exit
EndFunc

