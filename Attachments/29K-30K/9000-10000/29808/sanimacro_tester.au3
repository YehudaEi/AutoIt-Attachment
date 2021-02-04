#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.0.0
	Author:         Bill Hall

	Script Function:
	DMS h8r Macroset - Gives macro Function to the F1 - F11 keyz

#ce ----------------------------------------------------------------------------


#include<Date.au3>
#include <Excel.au3>
#include<IE.au3>
#include <WindowsConstants.au3>
#include <GuiConstants.au3>





Global $Paused
HotKeySet("{F1}", "_help")
HotKeySet("^{F1}", "_helpp")
HotKeySet("{F2}", "_screenshot")
HotKeySet("^{F2}", "_screenshotp")
HotKeySet("{F3}", "_scan")
HotKeySet("{F4}", "_date")
HotKeySet("^{F4}", "_datey")
HotKeySet("{F5}", "_searchap")
HotKeySet("{F6}", "_csearchp")
HotKeySet("{F7}", "_tab2mask")
HotKeySet("{F8}", "_savefrommask")
HotKeySet("{F9}", "_f9textpaste")
HotKeySet("^{F9}", "_createf9text")
HotKeySet("{F10}", "_f10textpaste")
HotKeySet("^{F10}", "_createf10text")
HotKeySet("{F11}", "_snowmail")
HotKeySet("^{F11}", "_createf11text")



While 1
	Sleep(28800)
WEnd


;F1
Func _help()
	;opens and prepares TLL for data from excel sheet

#include <GuiConstants.au3>
#include <Excel.au3>
#include<Date.au3>

$oExcel = _ExcelBookAttach("22022010001.xlsx", "FileName");part of the original function key

;start code for popup Facility Selector
$msg = ""

$gui = GUICreate("Ship to:", 220, 120) ; will create a dialog box that when displayed is centered
$button_ok = GUICtrlCreateButton("Send", 10, 80, 100)
$button_cancel = GUICtrlCreateButton("Cancel", 110, 80, 100)
$Combo_1 = GUICtrlCreateCombo("Select", 10, 40, 200, 21)
GUICtrlSetData($Combo_1, "|Grunstadt|Stuttgart|Mainz|Italy|Schweinfurt|Illesheim|")
GUICtrlSetData(-1, "Grunstadt")
GUICtrlCreateLabel("Select Receiving Facility", 10, 10)
GUISetState(@SW_SHOW)

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $button_cancel Or $msg = $GUI_EVENT_CLOSE
			Exit

		Case $msg = $button_ok
             $Menustate = GUICtrlRead($Combo_1)
            If $Menustate = "Grunstadt" Then
                $var1 = "1342560"
                $var2 = "7014290600"
                ExitLoop
            EndIf

			;and so on with the rest of the Facilities ca. 20
	EndSelect
WEnd


Run("C:\Program Files\Adobe\Reader 9.0\Reader\AcroRd32.exe C:\Documents and Settings\HallWi\Desktop\TLL.pdf")
WinWaitActive("TLL.pdf")
Sleep(1500)
Send("00012")
Sleep(300)
Send($var1)
Send("{TAB}")
Send($var2)
Sleep(800)
Send("{TAB}")
Sleep(300)
Send("1349995")
Sleep(300)
Send("{TAB}")
Sleep(800)
Send("7014290500")
Sleep(600)
Send("{TAB 3}")
Sleep(300)
Send(_NowDate())
Sleep(300)
Send("{TAB}")
Sleep(300)

For $c = 1 To 25

Send ($c)
Sleep(200)
Send("{TAB 6}")
Sleep(200)

Next


Send("{TAB 38}")





EndFunc   ;==>_help
;Ctrl & F1
Func _helpp()

EndFunc   ;==>_helpp
;F2
Func _screenshot()

Run("C:\Program Files\Adobe\Reader 9.0\Reader\AcroRd32.exe C:\Documents and Settings\HallWi\Desktop\sanirecord.pdf")
WinWaitActive("sanirecord.pdf")
$oExcel=_ExcelBookAttach("22022010001.xlsx", "FileName")

    For $i = 1 To 4
    $sCellValue = _ExcelReadCell($oExcel, $i, 1)

Sleep(200)
Send("{TAB}")
Sleep(100)
Send ($sCellValue)
Sleep(200)
Send("{TAB}")
Sleep(200)
Send ("Oasis")
Sleep(300)
Send("{TAB 2}")
Sleep(300)
Send ("Grunstadt")
Sleep(300)
Send("{TAB}")
Sleep(300)
Send(_NowDate())
Sleep(200)


Next

Send("^p")
Send("{ENTER}")
Sleep(1000)
WinWaitActive("sanirecord.pdf")
Sleep(1000)
Send("^q")

EndFunc   ;==>_screenshot
;Ctrl & F2
Func _screenshotp()

	Send("{ALTDOWN}")
	Send("{PRINTSCREEN}")
	Send("{ALTUP}")
	Run("T:\Gruenstadt\Picture Service\Viewer\i_view32.exe /clippaste /print")
	#cs-----------------------------------------------------------------------------
	WinWaitActive("IrfanView")
	Send("^v")
	Send("{CTRLDOWN}")
	Send("p")
	Send("{CTRLUP}")
	WinWaitActive("Print Preview")
	Send("^c")
	Sleep(1000)
	Send("{ENTER}")
	Sleep(1000)
	Send("{ALTDOWN}")
	Send("{F4}")
	Send("{ALTUP}")
	#ce-----------------------------------------------------------------------------

EndFunc   ;==>_screenshotp
;F3
Func _scan()

WinActivate("etiketten tmplat.pub ", "")
WinWaitActive("etiketten tmplat.pub")
Sleep(1000)

$oExcel=_ExcelBookAttach("22022010001.xlsx", "FileName")

    For $i = 1 To 12
    $sCellValue = _ExcelReadCell($oExcel, $i, 1)

Send("{TAB}")
Sleep(300)
Send("{ENTER}")
Send("^a")
Send ($sCellValue)
Sleep(300)
Send("{ESC}")
Sleep(300)
Send("{TAB 2}")
Sleep(300)
Send("{ENTER}")
Send("^a")
Send(_NowDate())
Sleep(300)
Send("^{PGDN}")
Sleep(800)


Next


EndFunc   ;==>_scan
;F4
Func _date()

	Send(_NowDate())


EndFunc   ;==>_date
;Ctrl & F4
Func _datey()

	$NowDate = _DateAdd('d', -1, _NowCalcDate())
	$sNewDate = _DateTimeFormat($NowDate, 2)

	Send($sNewDate)


EndFunc   ;==>_datey
;F5
Func _searchap()


$oExcel = _ExcelBookAttach("22022010001.xlsx", "FileName");part of the original function key

;start code for popup Facility Selector
$msg = ""

$gui = GUICreate("Ship to:", 220, 120) ; will create a dialog box that when displayed is centered
$button_ok = GUICtrlCreateButton("Send", 10, 80, 100)
$button_cancel = GUICtrlCreateButton("Cancel", 110, 80, 100)
$Combo_1 = GUICtrlCreateCombo("Select", 10, 40, 200, 21)
GUICtrlSetData($Combo_1, "|Grunstadt|Stuttgart|Mainz|Italy|Schweinfurt|Illesheim|")
GUICtrlSetData(-1, "Grunstadt")
GUICtrlCreateLabel("Select Receiving Facility", 10, 10)
GUISetState(@SW_SHOW)

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $button_cancel Or $msg = $GUI_EVENT_CLOSE
			Exit

		Case $msg = $button_ok
            $Menustate = GUICtrlRead($Combo_1)
            If $Menustate = "Grunstadt" Then
                $var1 = "1342560"
                $var2 = "7014290600"
                ExitLoop
            EndIf
			If $Menustate = "Stuttgart" Then
                $var1 = "1352570"
                $var2 = "7014290700"
                ExitLoop
            EndIf
            If $Menustate = "Mainz" Then
                $var1 = "1362590"
                $var2 = "7014290900"
                ExitLoop
            EndIf
			;and so on with the rest of the Facilities ca. 20
	EndSelect
WEnd

run( "notepad.exe","")
WinWaitActive( "Untitled" )
Sleep(2000)
Send($var1)
Sleep(2000)
Send("{ALT}")
Send("F")
Send("X")
Send("N")

EndFunc   ;==>_searchap
;F6
Func _csearchp() ;copy search paste

	Send("^c") ;CTRL C - copies number
	WinActivate("DMS Plus", "")
	Send("!c")
	Send("{ENTER}")
	Send("f")
	Send("{TAB}")
	Send("{ENTER}")
	Sleep(1000)
	Send("^v")
	Send("{ENTER}")

EndFunc   ;==>_csearchp
;F7
Func _tab2mask()

	Send("{ENTER}")
	Send("{TAB 21}") ;hit tab button 21 times to get to the delivery info mask
	Sleep(500)
	Send("{END}") ;to get to the end of any text already there


EndFunc   ;==>_tab2mask
;F8
Func _savefrommask()

	Send("{TAB 11}") ;hit tab button 21 times to get to the delivery info mask
	Send("{ENTER}") ;save and closes



EndFunc   ;==>_savefrommask
;F9
Func _f9textpaste()

	$macrof9 = WinGetText("f9.txt", "")
	Send($macrof9) ;enter text from f9.txt file

EndFunc   ;==>_f9textpaste
;Ctrl & F9
Func _createf9text()

	Run("notepad.exe")
	WinWaitActive("Untitled - Notepad")
	Send("Type your text here for the F9 button.")
	Send("^s")
	Send("f9.txt")
	Send("!s")
	Send("y")


EndFunc   ;==>_createf9text
;F10
Func _f10textpaste()

	$macrof10 = WinGetText("f10.txt", "")
	Send($macrof10) ;enter text from f10.txt file

EndFunc   ;==>_f10textpaste
;Ctrl & F10
Func _createf10text()

	Run("notepad.exe")
	WinWaitActive("Untitled - Notepad")
	Send("Type your text here for the F10 button.")
	Send("^s")
	Send("f10.txt")
	Send("!s")
	Send("y")


EndFunc   ;==>_createf10text
;F11
Func _snowmail()

	Send("^c") ;CTRL C - copies number
	Send("{ESC}") ;closes DMS mask
   	WinActivate("Inbox - Microsoft Outlook", "")
	Send("^n")
	Send("^v")
	Send("!u")
	Send("Culligan Delivery Cancelled due to Adverse Weather Conditions")
	Send("{TAB}")
	Send("Dear Culligan Customer,")
	Send("{ENTER}")
	Send("{ENTER}")
	Send("    We regret to inform you that due to the extreme weather and adverse road conditions we are unable to complete normal deliveries to your area.")
    Send("    We sincerely apologize for any inconvenience this may have caused and thank you for understanding and sharing our safety concerns for our drivers.")
    Send("{ENTER}")
	Send("{ENTER}")
	Send("    As the road conditions allow, we suggest getting water at your local Shoppette to tide you over until we can get back to our normal delivery cycle as it will be impossible to do any make up deliveries.  Weather permitting, we will be able to continue normal route cycles in time for your next  delivery.")
    Send("{ENTER}")
	Send("{ENTER}")
	Send("Best regards,")
	Send("{ENTER}")
	Send("Bill")
	Sleep(1000)
	Send("^{ENTER}")

EndFunc   ;==>_f11textpaste
;Ctrl & F11
Func _createf11text()

	Run("notepad.exe")
	WinWaitActive("Untitled - Notepad")
	Send("Type your text here for the F11 button.")
	Send("^s")
	Send("f11.txt")
	Send("!s")
	Send("y")


EndFunc   ;==>_createf11text
