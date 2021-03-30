#include <Excel.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>


PO()

Func PO()
   Local $hGUI = GUICreate("Automatic Mail Sending program for RLAM", 500, 400)
   Local $REM1 = GUICtrlCreateButton("Reminder #1", 80, 100, 160, 25)
   Local $test3 = GUICtrlCreateButton("Reminder #2", 80, 150, 160, 25)
   Local $test4 = GUICtrlCreateButton("Download RND_WCDMA", 300, 100, 150, 25)
   Local $test5 = GUICtrlCreateButton("Download RND_LTE", 300, 150, 150, 25)
   Local $iExit = GUICtrlCreateButton("Exit", 220, 250, 85, 25)
   Local $oExcel = _ExcelSheetActivate

GUISetState(@SW_SHOW, $hGUI)
   While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $iexit
				ExitLoop
Case $REM1
Sleep(300)
Global $Employee = InputBox("To how people do you want to send Reminder today ?", "Enter the no of count please", "" , "" , 500, 200, 436, 282, Default )
Switch $Employee
Case 1
send("#r")                                ;--------------------to open Pending PO Data folder--------------
Sleep(500)
send("C:\Pending PO Data{enter}")
sleep(200)
WinWaitActive("Pending PO Data")
sleep(200)
WinSetState("Pending PO Data", "", @SW_MAXIMIZE)
sleep(200)
WinActivate("Pending PO Data")
sleep(300)                                 ;---------------------------to click on 1st sheet---------------
MouseClick("left", 206, 128, 1)
Sleep(200)
Send("{ENTER}")                            ;---------------------------to open first sheet--------------
sleep(2000)
MouseClick("left", 985, 241, 1)            ;--------------------------to click on Reminder filter column----------
Sleep(500)
MouseClick("left", 874, 402, 1)
Sleep(500)
Send("{#}1")
Sleep(1000)
Send("{ENTER}")
Sleep(300)
Send("^g")
Sleep(200)
Send("B2")
Sleep(200)
Send("{ENTER}")
Sleep(200)
Send("^c")
Sleep(1000)
WinActivate("Inbox - gaurav.vogue@gmail.com - Microsoft Outlook")
Sleep(500)
WinWaitActive("Inbox - gaurav.vogue@gmail.com - Microsoft Outlook")
Sleep(800)
MouseClick("left", 23, 79, 1)      ;-------------------to click on new mail--------------------
Sleep(600)
WinWaitActive("Untitled - Message (HTML) ")
Sleep(1000)
WinSetState("Untitled - Message (HTML) ", "", @SW_MAXIMIZE)
sleep(200)
WinActivate("Untitled - Message (HTML) ")
sleep(200)
MouseClick("left", 239, 159, 1) ;----------------to click on "TO"----------------------
Sleep(200)
Send("^v")
Sleep(200)
Send("^k")
Sleep(500)
MouseClick("left", 239, 186, 1) ;----------------to click on "CC"----------------------
Sleep(200)
Send("Gaurav.vogue@gmail.com")
Sleep(200)
Send("{ENTER}")
Sleep(200)
MouseClick("left", 239, 213, 1) ;----------------to click on "Subject"----------------------
Sleep(200)
Send("Pending PO/ICRRB tracker for RLAM")
Sleep(200)
Send("{ENTER}")
Sleep(200)
MouseClick("left", 38, 262, 1)   ;------------------to click on the msg body---------------
Sleep(200)
Send("Hello Receiver")
Sleep(200)
Send("{ENTER 2}")
sleep(200)
Send("Please find below the pending PO details till date")  ;------------------to write details on the msg body------------
Sleep(200)
Send("{ENTER 3}")
Sleep(200)
_ExcelSheetActivate($oExcel, "Sheet1")
Sleep(500)
Send("regards")
sleep(200)
Send("{ENTER}")
Sleep(200)
Send("Gaurav Kumar")
Sleep(200)
EndSwitch
EndSwitch
   WEnd
EndFunc