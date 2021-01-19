#include <GUIConstants.au3>
#include <Misc.au3>
#include <Date.au3>

Opt("RunErrorsFatal",0)

Global $List1, $Close, $Open, $Start, $Form1, $startmenu
Global $DoubleClicked   = False
Global Const $WM_NOTIFY = 0x004E
Global $StartMenuShow=False
Global $DateMenuShow=False

$BackColor = IniRead(@ScriptDir & "\Settings.ini", "Settings", "BackColor", "0xC0C0C0") ; Reads the users Background Color from the settings ini file

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("OS shell", 633, 430, 193, 115, BitOR($WS_MAXIMIZEBOX, $WS_MINIMIZEBOX, $WS_SYSMENU, $WS_CAPTION))
$ContMenu=GUICtrlCreateContextMenu()
$Run=GUICtrlCreateMenuItem("Run an application",$ContMenu)
GUICtrlCreateMenuItem("",$ContMenu)
$ChangeColor=GUICtrlCreateMenuItem("Change Background Color",$ContMenu)
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
GUISetBkColor($BackColor) ; Sets the color read from the ini
$Start = GUICtrlCreateButton("Start", 3, 409, 75, 17, 0)
$Open = GUICtrlCreateButton("Open", 3, 409, 75, 17, 0)
GUICtrlSetState(-1, $GUI_HIDE)
$startmenu = GUICtrlCreateListView("Applications ", 8, 305, 85, 97,$LVS_NOSORTHEADER)
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlCreateListViewItem("Paint",$startmenu )
GUICtrlSetImage (-1, "shell32.dll",-35)
GUICtrlCreateListViewItem("Notepad",$startmenu )
GUICtrlSetImage (-1, "shell32.dll",-71)
$date = GUICtrlCreateMonthCal("2007/10/14", 432, 246, 191, 161)
GUICtrlSetState(-1, $GUI_HIDE)
$Time = GUICtrlCreateButton(_NowTime(), 544, 409, 75, 17, 0)
$Paint = GUICtrlCreateButton("Paint", 8, 8, 59, 49,BitOR($BS_PUSHBOX,$BS_FLAT,$BS_ICON))
GUICtrlSetImage (-1, "shell32.dll",-35)
$Notepad = GUICtrlCreateButton("Notepad", 8, 80, 59, 49, BitOR($BS_PUSHBOX,$BS_FLAT,$BS_ICON))
GUICtrlSetImage (-1, "shell32.dll",-71)
GUISetState()
#EndRegion ### END Koda GUI section ###

AdlibEnable("refresh_time",1000)

While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
        Case $Start
            Startmenu()
        Case $Time
            If not $DateMenuShow Then
                GUICtrlSetState($date, $GUI_SHOW)
                $DateMenuShow=True
            Else
                GUICtrlSetState($date, $GUI_HIDE)
                $DateMenuShow=False
            EndIf
        Case $Paint
            GUICtrlDelete($Paint)
            $Paint = GUICtrlCreateButton("Paint", 8, 8, 59, 49,BitOR($BS_PUSHBOX,$BS_FLAT,$BS_ICON))
            GUICtrlSetImage (-1, "shell32.dll",-35)
            Run("MSpaint")
        Case $Notepad
            GUICtrlDelete($Notepad)
            $Notepad = GUICtrlCreateButton("Notepad", 8, 64, 59, 49, BitOR($BS_PUSHBOX,$BS_FLAT,$BS_ICON))
            GUICtrlSetImage (-1, "shell32.dll",-71)
            Run("notepad")
        Case $Run
            _Run()
        Case $ChangeColor
            _ChangeColor()
        EndSwitch
    If $DoubleClicked Then
        DoubleClickFunc()
        $DoubleClicked = False
    EndIf
WEnd
Func Startmenu()
    If not $StartMenuShow Then
        GUICtrlSetState($Startmenu, $GUI_SHOW)
        $StartMenuShow=True
    Else
        GUICtrlSetState($Startmenu, $GUI_HIDE)
        $StartMenuShow=False
    EndIf
EndFunc

Func refresh_time()
    GUICtrlSetData($Time,_NowTime())
EndFunc

Func WM_NOTIFY($hWnd, $MsgID, $wParam, $lParam)
    Local $tagNMHDR, $event, $hwndFrom, $code
    $tagNMHDR = DllStructCreate("int;int;int", $lParam)
    If @error Then Return 0
    $code = DllStructGetData($tagNMHDR, 3)
    If $wParam = $startmenu And $code = -3 Then $DoubleClicked = True
    Return $GUI_RUNDEFMSG
EndFunc

Func DoubleClickFunc()
   $App=GUICtrlRead(GUICtrlRead($Startmenu))
   Switch $App
       Case "Notepad"
           Run("notepad")
       Case "Paint"
            Run("mspaint")
    EndSwitch
EndFunc

Func _Run()
    GUISetState(@SW_DISABLE,$Form1)
    $RunCHild=GUICreate("Run", 291, 120, 226, 156, BitOR($WS_SYSMENU,$WS_CAPTION,$WS_POPUP,$WS_POPUPWINDOW,$WS_BORDER,$WS_CLIPSIBLINGS),-1,$Form1)
    GUICtrlCreateLabel("Type the name of the application you wish to execute", 8, 16, 276, 17)
    $Path = GUICtrlCreateInput("", 8, 40, 273, 21)
    $RunButton = GUICtrlCreateButton("&Run", 8, 80, 73, 25, $BS_DEFPUSHBUTTON)
    $CancelButton= GUICtrlCreateButton("&Cancel", 104, 80, 75, 25, 0)
    $Browse = GUICtrlCreateButton("&Browse", 200, 80, 75, 25, 0)
    GUISetState()
    While 1
        $CMsg=GUIGetMsg()
        Select
        Case $CMsg=$GUI_EVENT_CLOSE OR $CMsg=$CancelButton
            GUISetState(@SW_ENABLE,$Form1)
            GUIDelete($RunChild)
            ExitLoop
        Case $CMsg=$RunButton
            Run(GUICtrlRead($Path))
            If @error Then
                MsgBox(4112,"Error","Unable to execute external program")
            Else
                GUISetState(@SW_ENABLE,$Form1)
                GUIDelete($RunChild)
                ExitLoop
            EndIf
        Case $CMsg=$Browse
            $PathOfFile=FileOpenDialog("Run Application",@Programfilesdir,"Programs (*.exe)", 1 )
            If not @error Then
                GUICtrlSetData($Path,$PathofFile)
            EndIf
        EndSelect
    WEnd
EndFunc

Func _ChangeColor()
    $bkColor=_ChooseColor(2)
    If not @error Then
        GUISetBkColor($bkColor)
    EndIf
	IniWrite(@ScriptDir & "\Settings.ini", "Settings", "BackColor", $bkColor) ; Saves the color
EndFunc