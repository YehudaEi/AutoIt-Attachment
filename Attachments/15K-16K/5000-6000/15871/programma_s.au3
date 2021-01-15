#include <GUIConstants.au3>
#include <GUIConstants.au3>
	
$window = GUICreate("Program",500,300)
GUISetState (@SW_SHOW)
GUISetBkColor (0xbbFF99)

	
$programmenu = GUICtrlCreateMenu ("Programmeren")
$exeitem = GUICtrlCreateMenuitem ("exe",$programmenu)
GUICtrlSetOnEvent (-1, "exe")

$runitem = GUICtrlCreateMenuitem ("run",$programmenu)
GUICtrlSetOnEvent (-1, "runi")



func exe()

	$flg = BitOr($GUI_SS_DEFAULT_GUI, $WS_DLGFRAME, $DS_MODALFRAME, $DS_SETFOREGROUND)
	$flg = BitAnd ($flg, not $WS_MAXIMIZEBOX, not $WS_MINIMIZEBOX)
	GUICreate ("Info ", 310, 310, -1, -1, $flg, $WS_EX_TOPMOST)

	$codea = GUICTRLREAD($code)
	$program = GUICtrlCreateEdit($codea, 0, 0, 305, 230, BitOR($ES_AUTOVSCROLL,$ES_WANTRETURN,$WS_VSCROLL))

	$ok = GUICtrlCreateButton ("OK", 115, 240, 80, -1, BitOr($GUI_SS_DEFAULT_BUTTON, $BS_DEFPUSHBUTTON))
	Opt ("GUIOnEventMode", 0)
	GUICtrlSetState ($ok, $GUI_ENABLE)
	GUISetState ()
		while 1
			$msg = GUIGetMsg()
			$programa = GUICTRLREAD($program)
			if $msg = $ok then GUICtrlSetData($code, $programa)
			if $msg = $ok then exitloop
		wend
	GUIDelete ()
	Opt ("GUIOnEventMode", 1)
	GUISwitch ($window)
endfunc


GUICtrlCreatelabel ("Uw Code:", 220, 0, 200, 18)
$code = GUICtrlCreateEdit ("", 140, 14, 200, 200, BitOR($ES_AUTOVSCROLL,$ES_WANTRETURN,$WS_VSCROLL))

func runi()
$window = GUICreate("Program",500,300)
DirCreate("hallo")
$bestand = BitXOR(@sec + @min, 4)

$codea = GUICTRLREAD($code)
$file = FileOpen("hallo/" & $bestand & ".txt", 1)

FileWrite($file, $codea)

FileClose($file)


$text = StringReplace($codea, "Stuur(", "Send('{")
$text = StringReplace($text, ")", "}')")


MsgBox(0, "New string is", $text)

endfunc


While 1
	$msg = GUIGetMsg() 
		Select
			Case $msg = $exeitem
			exe()
			Case $msg = $runitem
			runi()
			Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
	EndSelect
Wend
