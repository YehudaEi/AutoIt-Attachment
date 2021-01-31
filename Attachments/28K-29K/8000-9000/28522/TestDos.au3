#include <Constants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Include <GuiEdit.au3>
#Region ### START Koda GUI section ### Form=c:\franck\_distrib_\senddicom\test\testdos.kxf
$GUI_MainWindow  = GUICreate("TestDos", 727, 452, 192, 124)
$LogText = GUICtrlCreateEdit("", 16, 96, 697, 341, BitOR($ES_AUTOVSCROLL,$ES_WANTRETURN,$WS_HSCROLL,$WS_VSCROLL))
GUICtrlSetFont(-1, 10, 400, 0, "Courier New")
$Btn_Exit = GUICtrlCreateButton("Exit", 634, 14, 73, 25, $WS_GROUP)
$Group1 = GUICtrlCreateGroup("Application", 16, 8, 525, 81)
$Btn_RunShow = GUICtrlCreateButton("Run Show Res", 440, 53, 89, 25, $WS_GROUP)
$Inp_Command = GUICtrlCreateInput("DIR C:\Windows /B /S", 36, 28, 397, 21)
$Btn_RunRes = GUICtrlCreateButton("Run Get Res", 440, 26, 89, 25, $WS_GROUP)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

ManageEvents()
While 1
	Sleep(10)
WEnd

Func ManageEvents()
	Opt("GUIOnEventMode", 1)
	GUISetOnEvent($GUI_EVENT_CLOSE, "Close",$GUI_MainWindow)
	GUICtrlSetOnEvent($Btn_Exit			, "Close")
	GUICtrlSetOnEvent($Btn_RunRes		, "RunCmdGetRes")
	GUICtrlSetOnEvent($Btn_RunShow		, "RunCmdShow")
EndFunc
Func Close()
	Exit
EndFunc
Func RunCmdGetRes()
	GUICtrlSetData($LogText,"")
	GUICtrlSetData($LogText,GUICtrlRead($LogText)&RunDosGetData(GUICtrlRead($Inp_Command)))
	_GUICtrlEdit_LineScroll($LogText, 0, 100000)
EndFunc
Func RunCmdShow()
	Local $BufOut,$BufErr,$Pid, $BufSize=10000
	GUICtrlSetData($LogText,"")
	$Pid=Run(@ComSpec & " /c " &GUICtrlRead($Inp_Command),@TempDir,@SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	While 1
		$BufOut=StdOutRead($Pid)
		If @error then ExitLoop
		$BufErr=StderrRead($Pid)
		If @error then ExitLoop
		_GUICtrlEdit_BeginUpdate($LogText)
		GUICtrlSetData($LogText,StringRight(GUICtrlRead($LogText)&$BufOut&$BufErr, $BufSize ))
		_GUICtrlEdit_LineScroll($LogText, 0, 10000)
		_GUICtrlEdit_EndUpdate($LogText)
		Sleep(10)
	WEnd
	GUICtrlSetData($LogText,StringRight(GUICtrlRead($LogText)&$BufOut&$BufErr, $BufSize ))
	_GUICtrlEdit_LineScroll($LogText, 0, 100000)
	StdioClose($Pid)
EndFunc
Func RunDosGetData($Command)
	Local $StdOut,$Pid=Run(@ComSpec & " /c " &$Command,@TempDir,@SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	ProcessWaitClose ($Pid)
	$StdOut=StdOutRead($Pid)
	StdioClose($Pid)
	Return $StdOut
EndFunc
