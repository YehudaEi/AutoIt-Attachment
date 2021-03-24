; End of night reports program - Brett Nordstog 2013

HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{HOME}", "Terminate")
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <_ShutDown.au3>
#include <ScreenCapture.au3>

$Windows = "3700 POS Operations"

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Brett's Automatic MICROS", 357, 210, 302, 218)
$GroupBox1 = GUICtrlCreateGroup("", 8, 8, 257, 185)
$Combo1 = GUICtrlCreateCombo("", 16, 40, 177, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Theater|Bars|Kitchen|Pub", "Theater")
$Password = GUICtrlCreateInput("", 16, 96, 177, 21, $ES_NUMBER)
$Label1 = GUICtrlCreateLabel("Micros Password", 24, 72, 84, 17)
$Label2 = GUICtrlCreateLabel("Department", 24, 16, 59, 17)
$Label3 = GUICtrlCreateLabel("Label3", 24, 152, 36, 17)
$Group1 = GUICtrlCreateGroup("Status", 16, 136, 241, 41)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Button1 = GUICtrlCreateButton("&OK", 272, 16, 75, 25)
$Button2 = GUICtrlCreateButton("&Cancel", 272, 48, 75, 25)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
		 Case $Button2
			Exit
		 Case $Button1
			$Pass=GUICtrlRead($Password)
			$Department=GUICtrlRead($Combo1)
			If $Pass=0 Then
			   MsgBox(0,"Error", "Please Enter Password")
			Else
			If $Department='Theater' Then
			   Theater()
			ElseIf $Department='Bars' Then
			   Bars()
			ElseIf $Department='Kitchen' Then
			   Kitchen()
			ElseIf $Department='Pub' Then
			   Pub()

			EndIf
			EndIf

    EndSwitch
WEnd



Func TogglePause()
    $fPaused = Not $fPaused
    While $fPaused
        Sleep(100)
        ToolTip('Script is "Paused"', 0, 0)
    WEnd
    ToolTip("")
EndFunc   ;==>TogglePause

Func Terminate()
    Exit
 EndFunc   ;==>Terminate
Func Example()
    _ScreenCapture_Capture(@MyDocumentsDir & "\Sales.jpg")
EndFunc 

Func Theater()
   ;Theater Script
	_ShutDown(4, $Windows)
	;Open autosequences and wait for password box
   Run("C:\Micros\COMMON\Bin\AutoSeqExec.exe")
   WinWait("MICROS Security", "", 30)
   WinActivate("MICROS Security")
   ;Input password from box and send
   Sleep(3000)
   ControlSend("MICROS Security", "", "[CLASS:TEdit; INSTANCE:1]", GUICtrlRead($Password))
   ControlClick("MICROS Security", "", "[CLASS:TBitBtn; INSTANCE:2]", "left")
   ;Wait for autosequences window and switch to buttons page
   WinWait("MICROS Autosequences and Reports", "", 30)
   WinActivate("MICROS Autosequences and Reports")
   Opt("MouseCoordMode", 2)
   While 1
    If ControlCommand("MICROS Autosequences and Reports", "", "[CLASS:TMPageControl;INSTANCE:1]", "IsVisible", "") Then ExitLoop
    Sleep(10)
   WEnd
   ControlClick("MICROS Autosequences and Reports", "", "[CLASS:TMPageControl;INSTANCE:1]", "",1,114,12)
   ;Click Sales Report button
   While 1
    If ControlCommand("MICROS Autosequences and Reports", "", "[CLASS:TMBitBtn;INSTANCE:9]", "IsVisible", "") Then ExitLoop
    Sleep(10)
   WEnd
   ControlClick("MICROS Autosequences and Reports", "", "[CLASS:TMBitBtn;INSTANCE:9]", "")
   ;Click consolodated report menu and next
   While 1
    If ControlCommand("MICROS Autosequences and Reports", "", "[CLASS:TMDBGrid;INSTANCE:1]", "IsVisible", "") Then ExitLoop
    Sleep(10)
   WEnd
   ControlClick("MICROS Autosequences and Reports", "", "[CLASS:TMDBGrid;INSTANCE:1]", "",1,85,40)
   ControlClick("MICROS Autosequences and Reports", "", "[CLASS:TMBitBtn;INSTANCE:4]", "")
   ;Click first edit and select theater
    While 1
    If ControlCommand("MICROS Autosequences and Reports", "", "[CLASS:TEdit;INSTANCE:1]", "IsVisible", "") Then ExitLoop
    Sleep(10)
   WEnd
   ControlClick("MICROS Autosequences and Reports", "", "[CLASS:TEdit;INSTANCE:2]", "")
   While 1
    If ControlCommand("Revenue Center", "", "[CLASS:TMDBGrid;INSTANCE:1]", "IsVisible", "") Then ExitLoop
    Sleep(10)
   WEnd
   ControlClick("Revenue Center", "", "[CLASS:TMDBGrid;INSTANCE:1]", "",2,40,40)
   ;Click second edit and select theater
    While 1
    If ControlCommand("MICROS Autosequences and Reports", "", "[CLASS:TEdit;INSTANCE:1]", "IsVisible", "") Then ExitLoop
    Sleep(10)
   WEnd
   ControlClick("MICROS Autosequences and Reports", "", "[CLASS:TEdit;INSTANCE:1]", "")
   While 1
    If ControlCommand("Revenue Center", "", "[CLASS:TMDBGrid;INSTANCE:1]", "IsVisible", "") Then ExitLoop
    Sleep(10)
   WEnd
   ControlClick("Revenue Center", "", "[CLASS:TMDBGrid;INSTANCE:1]", "",2,40,40)
   ;Click preview and pull up report
   While 1
    If ControlCommand("MICROS Autosequences and Reports", "", "[CLASS:TEdit;INSTANCE:1]", "IsVisible", "") Then ExitLoop
    Sleep(10)
   WEnd
   ControlClick("MICROS Autosequences and Reports", "", "[CLASS:TMBitBtn;INSTANCE:3]", "")
   WinWait("3700 Report Viewer - [Daily Consolidated Revenue Center Sales Detail]", "", 30)
   ;Wait for cancel button to disappear
   ToolTip('Finding Cancel', 0, 0)
     While 1
    If ControlCommand("3700 Report Viewer - [Daily Consolidated Revenue Center Sales Detail]", "", "[CLASS:TMPanel;INSTANCE:1]", "IsVisible", "") Then ExitLoop
    Sleep(10)
   WEnd
   ToolTip('Waiting For Cancel to Die', 0, 0)
   While ControlCommand("3700 Report Viewer - [Daily Consolidated Revenue Center Sales Detail]", "", "[CLASS:TMPanel;INSTANCE:1]", "IsVisible", "")
    Sleep(10)
   WEnd
   ToolTip('', 0, 0)
   ;Print report on office printer
   Sleep(2000)
   Send("^p")
   While 1
    If ControlCommand("Print", "", "[CLASS:ComboBox;INSTANCE:1]", "IsVisible", "") Then ExitLoop
    Sleep(10)
   WEnd
   ControlCommand("Print", "", "[CLASS:ComboBox; INSTANCE:1]", "SelectString", 'OSF-RICOHC6501-OFFICE')
   Sleep(1000)
   ControlClick("Print", "", "[CLASS:Button;INSTANCE:10]", "")
   ;Sleep until print dialogue disappears
   While ControlCommand("Printing Records", "", "[CLASS:Button;INSTANCE:1]", "IsVisible", "")
    Sleep(10)
   WEnd
   Sleep(2000)
   ;Pull up autosequences window and reset the tab to buttons
   WinActivate("MICROS Autosequences and Reports")
   ControlClick("MICROS Autosequences and Reports", "", "[CLASS:TMPageControl;INSTANCE:1]", "",1,40,12)
   While 1
	  If ControlCommand("MICROS Autosequences and Reports", "", "[CLASS:TTabSheet;INSTANCE:1]", "IsVisible", "") Then ExitLoop
		 Sleep(10)
   Wend
   ControlClick("MICROS Autosequences and Reports", "", "[CLASS:TMPageControl;INSTANCE:1]", "",1,114,12)
   ;Open labor report screen
   While 1
    If ControlCommand("MICROS Autosequences and Reports", "", "[CLASS:TMBitBtn;INSTANCE:16]", "IsVisible", "") Then ExitLoop
    Sleep(10)
   WEnd
   ControlClick("MICROS Autosequences and Reports", "", "[CLASS:TMBitBtn;INSTANCE:16]", "")
   ;Select time card and detail and press next
    While 1
    If ControlCommand("MICROS Autosequences and Reports", "", "[CLASS:TMDBGrid;INSTANCE:1]", "IsVisible", "") Then ExitLoop
    Sleep(10)
   WEnd
   ControlClick("MICROS Autosequences and Reports", "", "[CLASS:TMDBGrid;INSTANCE:1]", "",1,120,60)
   ControlClick("MICROS Autosequences and Reports", "", "[CLASS:TMBitBtn;INSTANCE:4]", "")
   ;Click first edit and find catering/theater section
   While 1
    If ControlCommand("MICROS Autosequences and Reports", "", "[CLASS:TEdit;INSTANCE:1]", "IsVisible", "") Then ExitLoop
    Sleep(10)
   WEnd
   ControlClick("MICROS Autosequences and Reports", "", "[CLASS:TEdit;INSTANCE:2]", "")
   While 1
    If ControlCommand("Employee", "", "[CLASS:TDBEdit;INSTANCE:1]", "IsVisible", "") Then ExitLoop
    Sleep(10)
   WEnd
   Tooltip('Getting Name',0,0)
   $Name = ControlGetText("Employee", "", "[CLASS:TDBEdit;INSTANCE:1]")
   While $Name<>"==Catering/Theat"
   Send("{DOWN}")
   $Name = ControlGetText("Employee", "", "[CLASS:TDBEdit;INSTANCE:1]")
   ToolTip('Name=' & $Name, 0, 0)
Wend
ControlClick("Employee", "", "[CLASS:TMDBGrid;INSTANCE:1]", "",2,50,200)
;Click second edit and find small bars section
While 1
    If ControlCommand("MICROS Autosequences and Reports", "", "[CLASS:TEdit;INSTANCE:1]", "IsVisible", "") Then ExitLoop
    Sleep(10)
   WEnd
   ControlClick("MICROS Autosequences and Reports", "", "[CLASS:TEdit;INSTANCE:1]", "")
   While 1
    If ControlCommand("Employee", "", "[CLASS:TDBEdit;INSTANCE:1]", "IsVisible", "") Then ExitLoop
    Sleep(10)
   WEnd
   Tooltip('Getting Name',0,0)
   $Name = ControlGetText("Employee", "", "[CLASS:TDBEdit;INSTANCE:1]")
   While $Name<>"=====Small Bars"
   Send("{DOWN}")
   $Name = ControlGetText("Employee", "", "[CLASS:TDBEdit;INSTANCE:1]")
   ToolTip('Name=' & $Name, 0, 0)
Wend
ControlClick("Employee", "", "[CLASS:TMDBGrid;INSTANCE:1]", "",2,50,200)
;Click preview and open report
While 1
    If ControlCommand("MICROS Autosequences and Reports", "", "[CLASS:TMBitBtn;INSTANCE:3]", "IsVisible", "") Then ExitLoop
    Sleep(10)
   WEnd
ControlClick("MICROS Autosequences and Reports", "", "[CLASS:TMBitBtn;INSTANCE:3]", "")
;Wait for report
ToolTip('Finding Cancel', 0, 0)
     While 1
    If ControlCommand("3700 Report Viewer - [Employee Time Card And Job Detail]", "", "[CLASS:TMPanel;INSTANCE:1]", "IsVisible", "") Then ExitLoop
    Sleep(10)
   WEnd
   ToolTip('Waiting For Cancel to Die', 0, 0)
   While ControlCommand("3700 Report Viewer - [Employee Time Card And Job Detail]", "", "[CLASS:TMPanel;INSTANCE:1]", "IsVisible", "")
    Sleep(10)
   WEnd
   ToolTip('', 0, 0)
   ;Print report on office printer
   Sleep(2000)
   Send("^p")
   While 1
    If ControlCommand("Print", "", "[CLASS:ComboBox;INSTANCE:1]", "IsVisible", "") Then ExitLoop
    Sleep(10)
   WEnd
   ControlCommand("Print", "", "[CLASS:ComboBox; INSTANCE:1]", "SelectString", 'OSF-RICOHC6501-OFFICE')
   Sleep(1000)
   ControlClick("Print", "", "[CLASS:Button;INSTANCE:10]", "")
   ;Sleep until print dialogue disappears
   While ControlCommand("Printing Records", "", "[CLASS:Button;INSTANCE:1]", "IsVisible", "")
    Sleep(10)
   WEnd
   Sleep(2000)
   ;Reset Tabs
 WinActivate("MICROS Autosequences and Reports")
   ControlClick("MICROS Autosequences and Reports", "", "[CLASS:TMPageControl;INSTANCE:1]", "",1,40,12)
   While 1
	  If ControlCommand("MICROS Autosequences and Reports", "", "[CLASS:TTabSheet;INSTANCE:1]", "IsVisible", "") Then ExitLoop
		 Sleep(10)
   Wend
   ControlClick("MICROS Autosequences and Reports", "", "[CLASS:TMPageControl;INSTANCE:1]", "",1,114,12)
   ;Open menu item screen
   While 1
    If ControlCommand("MICROS Autosequences and Reports", "", "[CLASS:TMBitBtn;INSTANCE:21]", "IsVisible", "") Then ExitLoop
    Sleep(10)
   WEnd
   ControlClick("MICROS Autosequences and Reports", "", "[CLASS:TMBitBtn;INSTANCE:21]", "")
   ;Click consolodated report menu and next
   While 1
    If ControlCommand("MICROS Autosequences and Reports", "", "[CLASS:TMDBGrid;INSTANCE:1]", "IsVisible", "") Then ExitLoop
    Sleep(10)
   WEnd
   ControlClick("MICROS Autosequences and Reports", "", "[CLASS:TMDBGrid;INSTANCE:1]", "",1,145,170)
   ControlClick("MICROS Autosequences and Reports", "", "[CLASS:TMBitBtn;INSTANCE:4]", "")
   ;Click first edit and select theater
    While 1
    If ControlCommand("MICROS Autosequences and Reports", "", "[CLASS:TEdit;INSTANCE:4]", "IsVisible", "") Then ExitLoop
    Sleep(10)
   WEnd
   ControlClick("MICROS Autosequences and Reports", "", "[CLASS:TEdit;INSTANCE:4]", "")
   While 1
    If ControlCommand("Revenue Center", "", "[CLASS:TMDBGrid;INSTANCE:1]", "IsVisible", "") Then ExitLoop
    Sleep(10)
   WEnd
   ControlClick("Revenue Center", "", "[CLASS:TMDBGrid;INSTANCE:1]", "",2,40,40)
   ;Click second edit and select theater
    While 1
    If ControlCommand("MICROS Autosequences and Reports", "", "[CLASS:TEdit;INSTANCE:3]", "IsVisible", "") Then ExitLoop
    Sleep(10)
   WEnd
   ControlClick("MICROS Autosequences and Reports", "", "[CLASS:TEdit;INSTANCE:3]", "")
   While 1
    If ControlCommand("Revenue Center", "", "[CLASS:TMDBGrid;INSTANCE:1]", "IsVisible", "") Then ExitLoop
    Sleep(10)
   WEnd
   ControlClick("Revenue Center", "", "[CLASS:TMDBGrid;INSTANCE:1]", "",2,40,40)
   ;Click preview and pull up report
   While 1
    If ControlCommand("MICROS Autosequences and Reports", "", "[CLASS:TEdit;INSTANCE:1]", "IsVisible", "") Then ExitLoop
    Sleep(10)
   WEnd
   ControlClick("MICROS Autosequences and Reports", "", "[CLASS:TMBitBtn;INSTANCE:3]", "")
    While 1
    If ControlCommand("3700 Report Viewer - [McMenamins Custom Liquor Cost Report]", "", "[CLASS:TMPanel;INSTANCE:1]", "IsVisible", "") Then ExitLoop
    Sleep(10)
   WEnd
   ToolTip('Waiting For Cancel to Die', 0, 0)
   While ControlCommand("3700 Report Viewer - [McMenamins Custom Liquor Cost Report]", "", "[CLASS:TMPanel;INSTANCE:1]", "IsVisible", "")
    Sleep(10)
   WEnd
   ToolTip('', 0, 0)
   ;Print report on office printer
   Sleep(2000)
   Send("^p")
   While 1
    If ControlCommand("Print", "", "[CLASS:ComboBox;INSTANCE:1]", "IsVisible", "") Then ExitLoop
    Sleep(10)
   WEnd
   ControlCommand("Print", "", "[CLASS:ComboBox; INSTANCE:1]", "SelectString", 'OSF-RICOHC6501-OFFICE')
   Sleep(1000)
   ControlClick("Print", "", "[CLASS:Button;INSTANCE:10]", "")
   ;Sleep until print dialogue disappears
   While ControlCommand("Printing Records", "", "[CLASS:Button;INSTANCE:1]", "IsVisible", "")
    Sleep(10)
   WEnd
   Sleep(2000)
EndFunc

Func Bars()
   ;Bars Script
   MsgBox(0,"Test", "Bars")
EndFunc

Func Kitchen()
   ;Kitchen Script
   MsgBox(0,"Test", "Kitchen")
EndFunc

Func Pub()
   ;Pub Script
   MsgBox(0,"Test", "Pub")
EndFunc


