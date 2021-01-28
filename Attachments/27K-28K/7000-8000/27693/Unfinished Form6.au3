#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListBoxConstants.au3>
#include <WindowsConstants.au3>
#include <IE.au3>
#Include <Array.au3>
#include <file.au3>
#include <EditConstants.au3>

$Form1_1 = GUICreate("Form1", 609, 414, 186, 127)
$Button1 = GUICtrlCreateButton("Get Popular Keyword ", 32, 40, 241, 25)
$Button2 = GUICtrlCreateButton("Website Creation", 32, 136, 241, 33)
$Button3 = GUICtrlCreateButton("Generate Subtopic Keywords", 440, 40, 139, 33, 0)
$Button4 = GUICtrlCreateButton("Generate Websites", 32, 272, 243, 49)
$List1 = GUICtrlCreateEdit("", 280, 72, 129, 357)
$Button5 = GUICtrlCreateButton("Import Keywords", 296, 40, 105, 33)
$List2 = GUICtrlCreateList("", 440, 72, 137, 266)
GUICtrlSetData(-1, "")
$Button6 = GUICtrlCreateButton("Import Keywords 2", 456, 344, 105, 25, 0)
GUISetState(@SW_SHOW)


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
			_Button1_Pressed()
		Case $Button5
			_GetKeywords() ;-----------------------------------------------o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0
			Sleep(3000)
			_PopulateKeyWords()
		Case $Button3
			;_Button3_Pressed()
			_Button3_Pressed_NEW()
		Case $Button2
			_Button2_Pressed()
	EndSwitch
WEnd



Func _Button3_Pressed_NEW()
	$sKeyword = GUICtrlRead($List1)

	While 1
		$SM = StringMid($sKeyword,1,StringInStr($sKeyword,@CRLF))
		$sKeyword = StringTrimLeft($sKeyword,StringInStr($sKeyword,@CRLF)+1)
		GUICtrlSetData($List1,$sKeyword)
		If $SM = '' Then
			MsgBox(0,'','All Keywords Done')
			Return 0
		EndIf

		;MsgBox(0,'',$SM,1)
		_Button3_Pressed_SUB($SM)

		Sleep(4000)
		If WinExists("Keyword Elite","Please select the ke") Then
			MouseMove(178,77);This closes the box.
			MouseMove(178,77)
			MouseMove(178,77)
			MouseMove(178,77)
			MouseDown("left")
			MouseUp("left")
		EndIf

	Wend



EndFunc

Func _Button3_Pressed_SUB($sKeyword)
	Opt("WinWaitDelay",100)
	Opt("WinTitleMatchMode",4)
	Opt("WinDetectHiddenText",1)
	Opt("MouseCoordMode",0)
	sleep(4000)
	ShellExecute("D:\Program Files\Keyword Elite\Keyword Elite.exe")
	MouseMove(249,16)
	MouseDown("left")
	MouseUp("left")
	WinWait("Keyword Elite :: New Project","Step 1: Select the p")
	If Not WinActive("Keyword Elite :: New Project","Step 1: Select the p") Then WinActivate("Keyword Elite :: New Project","Step 1: Select the p")
	WinWaitActive("Keyword Elite :: New Project","Step 1: Select the p")
	MouseMove(128,125);This is where the cursor moves over the "enter main phrase or keywords.
	MouseDown("left")
	MouseUp("left")
	;Send("{CTRLDOWN}v{CTRLUP}")
	Send($sKeyword)
	sleep(4000)
	MouseMove(210,363);This is were the mouse over the 'ok' button.
	MouseDown("left")
	MouseUp("left")
	sleep(30000)
	MouseMove(647,95);This is were the mouse over the 'report view' button.
	MouseDown("left")
	MouseUp("left")
	sleep(30000)
	;ControlClick('Keyword Elite','Pause','1862270986', 'left')
	;MouseMove(190,47);This is were 'pause' button is pressed.
	sleep(3000)
	MouseMove(190,47)
	MouseDown("left")
	MouseUp("left")
	sleep(3000)
	;MouseDown("left")
	;MouseUp("left")
	sleep(3000)
	;MouseDown("left")
	;MouseUp("left")
	sleep(4000)
	MouseMove(520,227);This is where the cursor moves to "Only Show Phrases Containing" section.
	MouseDown("left")
	MouseUp("left")
	Send($sKeyword)
	;this is where the keyword needs to be placed. Preferbly a small function that directs AutoIT to go down the
	;list select the keyword that its on and place it here.
	MouseMove(24,128)
	sleep(7000)
	MouseDown("left")
	MouseUp("left")
	Send("{CTRLDOWN}a{CTRLUP}")
	MouseDown("right")
	MouseUp("right")
	WinWait("Keyword Elite","")
	If Not WinActive("Keyword Elite","") Then WinActivate("Keyword Elite","")
	WinWaitActive("Keyword Elite","")
	MouseMove(45,106)
	sleep(7000)
	MouseDown("left")
	MouseUp("left")
	MouseMove(54,283)
	sleep(7000)
	MouseDown("left")
	MouseUp("left")
	MouseMove(225,336)
	sleep(7000)
	MouseDown("left")
	MouseUp("left")
	;Send("^{v}")
	Send($sKeyword)
	MouseMove(496,344)
	sleep(7000)
	MouseDown("left")
	MouseUp("left")
	WinWait(" Keyword Elite ","")
MouseMove(685,12);This closes the app.
MouseMove(685,12)
MouseMove(685,12)
MouseMove(685,12)
MouseDown("left")
MouseUp("left")
sleep(7000)
MouseMove(120,87);This is where the app asked to save the app settings.
MouseMove(120,87)
MouseMove(120,87)
MouseMove(120,87)
MouseDown("left")
MouseUp("left")
EndFunc

Func _Button3_Pressed()
	Opt("WinWaitDelay",100)
	Opt("WinTitleMatchMode",4)
	Opt("WinDetectHiddenText",1)
	Opt("MouseCoordMode",0)

	sleep(4000)
	ShellExecute("D:\Program Files\Keyword Elite\Keyword Elite.exe")
	MouseMove(249,16)
	MouseDown("left")
	MouseUp("left")
	WinWait("Keyword Elite :: New Project","Step 1: Select the p")
	If Not WinActive("Keyword Elite :: New Project","Step 1: Select the p") Then WinActivate("Keyword Elite :: New Project","Step 1: Select the p")
	WinWaitActive("Keyword Elite :: New Project","Step 1: Select the p")
	MouseMove(128,125);This is where the cursor moves over the "enter main phrase or keywords.
	MouseDown("left")
	MouseUp("left")
	Send("{CTRLDOWN}v{CTRLUP}")
	sleep(4000)
	MouseMove(210,363);This is were the mouse over the 'ok' button.
	MouseDown("left")
	MouseUp("left")
	sleep(30000)
	MouseMove(647,95);This is were the mouse over the 'report view' button.
	MouseDown("left")
	MouseUp("left")
	;This is were the mouse moves over the add to master list button.
	sleep(30000)
	MouseMove(190,47);This is were 'pause' button is pressed.
	MouseDown("left")
	MouseUp("left")
	sleep(3000)
	MouseDown("left")
	MouseUp("left")
	exit
	MouseUp("left")
	WinWait(" Keyword Elite ","Total Keywords: 14; ")
	If Not WinActive(" Keyword Elite ","Total Keywords: 14; ") Then WinActivate(" Keyword Elite ","Total Keywords: 14; ")
	WinWaitActive(" Keyword Elite ","Total Keywords: 14; ")
	MouseMove(533,234)
	MouseDown("left")
	MouseUp("left")
	Send("{CTRLDOWN}v{CTRLUP}")
	WinWait(" Keyword Elite ","Total Keywords: 15; ")
	If Not WinActive(" Keyword Elite ","Total Keywords: 15; ") Then WinActivate(" Keyword Elite ","Total Keywords: 15; ")
	WinWaitActive(" Keyword Elite ","Total Keywords: 15; ")
	MouseMove(25,129)
	MouseDown("left")
	MouseUp("left")
	Send("{CTRLDOWN}a{CTRLUP}")
	MouseClick("left",26,131,2)
	Send("{CTRLDOWN}a{CTRLUP}")
	MouseDown("right")
	MouseUp("right")
	WinWait("Keyword Elite","")
	If Not WinActive("Keyword Elite","") Then WinActivate("Keyword Elite","")
	WinWaitActive("Keyword Elite","")
	MouseMove(44,108)
	MouseDown("left")
	MouseUp("left")
	WinWait("Save As","Save as &type:")
	If Not WinActive("Save As","Save as &type:") Then WinActivate("Save As","Save as &type:")
	WinWaitActive("Save As","Save as &type:")
	MouseMove(45,158)
	sleep(3000)
	MouseDown("left")
	MouseUp("left")
	MouseMove(427,46);This is were the cursor moves over the Make new folder button.
	sleep(3000)
	MouseDown("left")
	MouseUp("left")
	WinWait("classname=Shell_TrayWnd","Running Applications")
	If Not WinActive("classname=Shell_TrayWnd","Running Applications") Then WinActivate("classname=Shell_TrayWnd","Running Applications")
	WinWaitActive("classname=Shell_TrayWnd","Running Applications")
	MouseMove(318,19);This is were the new folder is made. After its made Right here I want a small function to search
	MouseDown("left")
	MouseUp("left")
	MouseMove(321,-11)
	MouseDown("left")
	MouseUp("left")
	WinWait("Document 2 - Notepad","");This is were the tagged keywords are accessed.
	If Not WinActive("Document 2 - Notepad","") Then WinActivate("Document 2 - Notepad","")
	WinWaitActive("Document 2 - Notepad","")
	Send("{CTRLDOWN}c{CTRLUP}")
	MouseMove(254,19)
	MouseDown("left")
	MouseUp("left")
	WinWait("Save As","Save as &type:")
	If Not WinActive("Save As","Save as &type:") Then WinActivate("Save As","Save as &type:")
	WinWaitActive("Save As","Save as &type:")
	MouseMove(302,125)
	sleep(3000)
	MouseDown("right");This is were the new folder is right clicked to be renamed.
	MouseUp("right")
	MouseMove(329,365)
	sleep(3000)
	MouseDown("left")
	MouseUp("left")
	Send("{CTRLDOWN}v{CTRLUP}{SPACE}")
	MouseMove(316,254)
	MouseDown("left")
	MouseMove(315,245)
	MouseUp("left")
	MouseClick("left",276,129,2)
	MouseMove(208,337)
	sleep(3000)
	MouseDown("left")
	MouseUp("left")
	Send("{CTRLDOWN}v{CTRLUP}{CTRLDOWN}{CTRLUP}{SPACE}generated{SPACE}keywords{SPACE}plus{SPACE}current{SPACE}date{SPACE}here")
	MouseMove(509,341)
	sleep(3000)
	MouseDown("left")
	MouseUp("left")
	Exit
	WinWait(" Keyword Elite ","Total Keywords: 15; ")
	If Not WinActive(" Keyword Elite ","Total Keywords: 15; ") Then WinActivate(" Keyword Elite ","Total Keywords: 15; ")
	WinWaitActive(" Keyword Elite ","Total Keywords: 15; ")
	MouseMove(225,11)
	MouseDown("left")
	MouseMove(265,10)
	MouseUp("left")
	MouseMove(34,51)
	MouseDown("left")
	MouseUp("left")
	WinWait("Keyword Elite","You will lose any un")
	If Not WinActive("Keyword Elite","You will lose any un") Then WinActivate("Keyword Elite","You will lose any un")
	WinWaitActive("Keyword Elite","You will lose any un")
	MouseMove(120,78)
	MouseDown("left")
	MouseUp("left")
	WinWait("classname=Shell_TrayWnd","Running Applications")
	If Not WinActive("classname=Shell_TrayWnd","Running Applications") Then WinActivate("classname=Shell_TrayWnd","Running Applications")
	WinWaitActive("classname=Shell_TrayWnd","Running Applications")
	MouseMove(164,16)
	MouseDown("left")
	MouseUp("left")
	MouseDown("left")
	MouseUp("left")
	MouseMove(340,14)
	MouseDown("left")
	MouseUp("left")
	MouseMove(331,15)
	MouseDown("left")
	MouseUp("left")
	MouseDown("left")
	MouseUp("left")
	MouseMove(317,-16)
	MouseDown("left")
	MouseUp("left")
	WinWait("Document 2 - Notepad","")
	If Not WinActive("Document 2 - Notepad","") Then WinActivate("Document 2 - Notepad","")
	WinWaitActive("Document 2 - Notepad","")
	Send("{DOWN}{LEFT}{LEFT}{LEFT}{LEFT}{LEFT}{LEFT}{LEFT}{LEFT}{LEFT}{RIGHT}{RIGHT}{SHIFTDOWN}{RIGHT}{RIGHT}{RIGHT}{RIGHT}{RIGHT}{RIGHT}{SHIFTUP}{CTRLDOWN}c{CTRLUP}")
	MouseMove(248,16)
	MouseDown("left")
	MouseUp("left")
	WinWait("Keyword Elite :: New Project","Step 1: Select the p")
	If Not WinActive("Keyword Elite :: New Project","Step 1: Select the p") Then WinActivate("Keyword Elite :: New Project","Step 1: Select the p")
	WinWaitActive("Keyword Elite :: New Project","Step 1: Select the p")
	MouseMove(120,130)
	MouseDown("left")
	MouseUp("left")
	Send("{CTRLDOWN}v{CTRLUP}")
	MouseMove(217,361)
	MouseDown("left")
	MouseUp("left")
	sleep(30000)
	WinWait(" Keyword Elite "," Threads view ")
	If Not WinActive(" Keyword Elite "," Threads view ") Then WinActivate(" Keyword Elite "," Threads view ")
	WinWaitActive(" Keyword Elite "," Threads view ")
	MouseMove(645,94)
	MouseDown("left")
	MouseUp("left")
	WinWait(" Keyword Elite ","Total Keywords: 6; G")
	If Not WinActive(" Keyword Elite ","Total Keywords: 6; G") Then WinActivate(" Keyword Elite ","Total Keywords: 6; G")
	WinWaitActive(" Keyword Elite ","Total Keywords: 6; G")
	MouseMove(520,232)
	MouseDown("left")
	MouseUp("left")
	Send("{CTRLDOWN}v{CTRLUP}")
	WinWait(" Keyword Elite ","Total Keywords: 8; G")
	If Not WinActive(" Keyword Elite ","Total Keywords: 8; G") Then WinActivate(" Keyword Elite ","Total Keywords: 8; G")
	WinWaitActive(" Keyword Elite ","Total Keywords: 8; G")
	MouseMove(562,297)
	MouseDown("left")
	MouseUp("left")
	WinWait(" Keyword Elite ","Total Keywords: 17; ")
	If Not WinActive(" Keyword Elite ","Total Keywords: 17; ") Then WinActivate(" Keyword Elite ","Total Keywords: 17; ")
	WinWaitActive(" Keyword Elite ","Total Keywords: 17; ")
	MouseMove(20,127)
	MouseDown("left")
	MouseUp("left")
	Send("{CTRLDOWN}a{CTRLUP}")
	MouseDown("right")
	MouseUp("right")
	WinWait("Keyword Elite","")
	If Not WinActive("Keyword Elite","") Then WinActivate("Keyword Elite","")
	WinWaitActive("Keyword Elite","")
	MouseMove(51,102)
	MouseDown("left")
	MouseUp("left")
	WinWait("Save As","Save as &type:")
	If Not WinActive("Save As","Save as &type:") Then WinActivate("Save As","Save as &type:")
	WinWaitActive("Save As","Save as &type:")
	Send("{CTRLDOWN}c{CTRLUP}")
	MouseMove(206,337)
	MouseDown("left")
	MouseUp("left")
	Send("{CTRLDOWN}v{CTRLUP}{SPACE}generated{SPACE}keywords{SPACE}plus{SPACE}current{SPACE}date")
	MouseMove(411,46)
	MouseDown("left")
	MouseUp("left")
	MouseMove(425,49)
	MouseDown("left")
	MouseUp("left")
	Send("{CTRLDOWN}v{CTRLUP}")
	MouseClick("left",278,140,2)
	MouseMove(507,342)
	MouseDown("left")
	MouseUp("left")
	WinWait(" Keyword Elite ","Total Keywords: 17; ")
	If Not WinActive(" Keyword Elite ","Total Keywords: 17; ") Then WinActivate(" Keyword Elite ","Total Keywords: 17; ")
	WinWaitActive(" Keyword Elite ","Total Keywords: 17; ")
	MouseMove(35,48)
	MouseDown("left")
	MouseUp("left")
	WinWait("Keyword Elite","You will lose any un")
	If Not WinActive("Keyword Elite","You will lose any un") Then WinActivate("Keyword Elite","You will lose any un")
	WinWaitActive("Keyword Elite","You will lose any un")
	MouseMove(132,82)
	MouseDown("left")
	MouseUp("left")
	WinWait("classname=Shell_TrayWnd","Running Applications")
	If Not WinActive("classname=Shell_TrayWnd","Running Applications") Then WinActivate("classname=Shell_TrayWnd","Running Applications")
	WinWaitActive("classname=Shell_TrayWnd","Running Applications")
	MouseMove(326,15)
	MouseDown("left")
	MouseUp("left")
	MouseMove(319,-11)
	MouseDown("left")
	MouseUp("left")
	WinWait("Document 2 - Notepad","")
	If Not WinActive("Document 2 - Notepad","") Then WinActivate("Document 2 - Notepad","")
	WinWaitActive("Document 2 - Notepad","")
	MouseMove(61,89)
	MouseDown("left")
	MouseUp("left")
	Send("{SHIFTDOWN}{RIGHT}{RIGHT}{RIGHT}{RIGHT}{RIGHT}{RIGHT}{RIGHT}{RIGHT}{RIGHT}{RIGHT}{SHIFTUP}{CTRLDOWN}c{CTRLUP}")
	MouseMove(250,16)
	MouseDown("left")
	MouseUp("left")
	WinWait("Keyword Elite :: New Project","Step 1: Select the p")
	If Not WinActive("Keyword Elite :: New Project","Step 1: Select the p") Then WinActivate("Keyword Elite :: New Project","Step 1: Select the p")
	WinWaitActive("Keyword Elite :: New Project","Step 1: Select the p")
	MouseMove(202,119)
	MouseDown("left")
	MouseUp("left")
	Send("{CTRLDOWN}v{CTRLUP}")
	MouseMove(212,366)
	MouseDown("left")
	MouseUp("left")
	WinWait(" Keyword Elite "," Threads view ")
	If Not WinActive(" Keyword Elite "," Threads view ") Then WinActivate(" Keyword Elite "," Threads view ")
	WinWaitActive(" Keyword Elite "," Threads view ")
	MouseMove(632,87)
	MouseDown("left")
	MouseUp("left")
	WinWait(" Keyword Elite ","Total Keywords: 11; ")
	If Not WinActive(" Keyword Elite ","Total Keywords: 11; ") Then WinActivate(" Keyword Elite ","Total Keywords: 11; ")
	WinWaitActive(" Keyword Elite ","Total Keywords: 11; ")
	MouseMove(584,248)
	MouseDown("left")
	MouseUp("left")
	WinWait(" Keyword Elite ","Total Keywords: 12; ")
	If Not WinActive(" Keyword Elite ","Total Keywords: 12; ") Then WinActivate(" Keyword Elite ","Total Keywords: 12; ")
	WinWaitActive(" Keyword Elite ","Total Keywords: 12; ")
	Send("{CTRLDOWN}v{CTRLUP}")
	MouseMove(586,299)
	MouseDown("left")
	MouseUp("left")
	WinWait(" Keyword Elite ","Total Keywords: 22; ")
	If Not WinActive(" Keyword Elite ","Total Keywords: 22; ") Then WinActivate(" Keyword Elite ","Total Keywords: 22; ")
	WinWaitActive(" Keyword Elite ","Total Keywords: 22; ")
	MouseMove(509,24)
	MouseDown("left")
	MouseUp("left")
	MouseMove(31,134)
	MouseDown("left")
	MouseUp("left")
	Send("{CTRLDOWN}a{CTRLUP}")
	MouseDown("left")
	MouseUp("left")
	MouseClick("left",30,134,2)
	Send("{CTRLDOWN}a{CTRLUP}")
	MouseMove(38,135)
	MouseDown("left")
	MouseUp("left")
	Send("{CTRLDOWN}a{CTRLUP}")
	MouseMove(26,130)
	MouseDown("right")
	MouseUp("right")
	WinWait("Keyword Elite","")
	If Not WinActive("Keyword Elite","") Then WinActivate("Keyword Elite","")
	WinWaitActive("Keyword Elite","")
	MouseMove(36,103)
	MouseDown("left")
	MouseUp("left")
	WinWait("Save As","Save as &type:")
	If Not WinActive("Save As","Save as &type:") Then WinActivate("Save As","Save as &type:")
	WinWaitActive("Save As","Save as &type:")
	MouseMove(406,48)
	MouseDown("left")
	MouseUp("left")
	MouseMove(429,51)
	MouseDown("left")
	MouseUp("left")
	Send("{CTRLDOWN}v{CTRLUP}")
	MouseClick("left",272,161,2)
	MouseMove(214,341)
	MouseDown("left")
	MouseUp("left")
	Send("{CTRLDOWN}v{CTRLUP}{SPACE}generated{SPACE}keywords{SPACE}plus{SPACE}date")
	MouseMove(521,336)
	MouseDown("left")
	MouseUp("left")



EndFunc

Func _Button2_Pressed()
;remember, you have to be logged into webhost
;and into the subdomain creation section in order for this script to activate.
Opt("WinWaitDelay",100)
Opt("WinTitleMatchMode",4)
Opt("WinDetectHiddenText",1)
Opt("MouseCoordMode",0)
;Right here, the script needs to select(copy) the 1st keyword from the edit box then send it

sleep(6000)
MouseMove(424,474);This is where orps.com control panel is selected.
MouseMove(424,474)
MouseMove(424,474)
MouseDown("left")
MouseUp("left")
sleep(5000)
MouseMove(786,253)
MouseDown("left")
MouseMove(783,328)
MouseUp("left")
sleep(5000)
_findChecksum('157131','2055787671')
sleep(1000)
MouseMove(783,263)
MouseMove(783,263)
MouseMove(783,263)
MouseDown("left")
MouseMove(783,370)
MouseMove(783,370)
MouseMove(783,370)
MouseUp("left")
sleep(5000)
MouseMove(147,287)
MouseMove(147,287)
MouseMove(147,287)
MouseDown("left")
MouseDown("left")
MouseUp("left")
MouseDown("left")
MouseDown("left")
MouseUp("left")
sleep(5000)
Send("^{v}");This is where you need to paste the keyword.
sleep(5000)
_findChecksum('10280959','3966997547')
sleep(5000)
;MouseMove(98,433)
;MouseMove(98,433)
;MouseMove(98,433)
;MouseDown("left")
;MouseMove(225,430)
;MouseUp("left")
;sleep(7000)
;Send("{CTRLDOWN}c{CTRLUP}")
;sleep(5000)
MouseMove(22,80)
MouseMove(22,80)
MouseMove(22,80)
MouseDown("left")
MouseUp("left")
MouseMove(49,212)
MouseMove(49,212)
MouseMove(49,212)
MouseDown("left")
MouseUp("left")
WinWait("Save Webpage","Save as &type:")
If Not WinActive("Save Webpage","Save as &type:") Then WinActivate("Save Webpage","Save as &type:")
WinWaitActive("Save Webpage","Save as &type:")
Send("bike")
MouseMove(433,398)
MouseDown("left")
MouseUp("left")
MouseMove(384,453)
MouseMove(384,453)
MouseMove(384,453)
MouseDown("left")
MouseUp("left")
MouseMove(499,366)
MouseMove(499,366)
MouseMove(499,366)
MouseDown("left")
MouseUp("left")
WinWait("Save Webpage","D:\Objects To Burn\D")
If Not WinActive("Save Webpage","D:\Objects To Burn\D") Then WinActivate("Save Webpage","D:\Objects To Burn\D")
WinWaitActive("Save Webpage","D:\Objects To Burn\D")
MouseMove(134,102)
MouseMove(134,102)
MouseMove(134,102)
MouseDown("left")
MouseUp("left")
sleep(5000)
_findChecksum('14937851','1052043970')
sleep(5000)
Send("www.adsense.com{ENTER}")
sleep(15000)
_findChecksum('255','3760163120');This is where AdSense Setup is clicked.
sleep(5000)
ControlFocus("Security Warning", "", "Button1")
ControlSend("Security Warning", "", "Button1","{ENTER}")
sleep(5000)
_findChecksum('11468929','2262949697');This is where "AdSense for Content "is clicked.
sleep(5000)
ControlFocus("Security Warning", "", "Button1")
ControlSend("Security Warning", "", "Button1","{ENTER}")
sleep(5000)
MouseMove(783,267)
MouseMove(783,267)
MouseMove(783,267)
MouseDown("left")
MouseDown("left")
MouseDown("left")
MouseMove(766,466)
MouseMove(766,466)
MouseMove(766,466)
MouseUp("left")
sleep(5000)
_findChecksum('4495060','2726865823');This is where the "Continue" button is clicked.
sleep(5000)
MouseMove(783,267)
MouseMove(783,267)
MouseMove(783,267)
MouseDown("left")
MouseDown("left")
MouseDown("left")
sleep(2000)
MouseMove(766,466)
MouseMove(766,466)
MouseMove(766,466)
MouseUp("left")
sleep(5000)
_findChecksum('16316662','3094926139');This is where the "Continue" button is clicked.
sleep(5000)
MouseMove(783,267)
MouseMove(783,267)
MouseMove(783,267)
MouseDown("left")
MouseDown("left")
MouseDown("left")
sleep(2000)
MouseMove(766,466)
MouseMove(766,466)
MouseMove(766,466)
MouseUp("left")
sleep(5000)
_findChecksum('12582911','718721344');This is where the "Add New Channel" button is clicked.
sleep(5000)
MouseMove(475,185);This is where the cursor moves over "This website is using a scripted.....".
MouseMove(475,185)
MouseMove(475,185)
sleep(5000)
MouseDown("left")
MouseDown("left")
MouseDown("left")
MouseUp("left")
sleep(5000)
MouseMove(457,185)
MouseDown("left")
MouseUp("left")
sleep(5000)
MouseMove(506,195)
MouseDown("left")
MouseUp("left")
sleep(5000)
_findChecksum('12582911','718721344')
sleep(5000)
Send("^{v}")
sleep(5000)
ControlFocus("Explorer User Prompt", "", "Button1")
ControlSend("Explorer User Prompt", "", "Button1","{ENTER}")
sleep(5000)
MouseMove(150,420)
MouseMove(150,420)
MouseMove(150,420)
MouseDown("left")
MouseUp("left")
MouseMove(786,284)
MouseMove(786,284)
MouseMove(786,284)
MouseDown("left")
MouseMove(767,550)
MouseMove(767,550)
MouseMove(767,550)
MouseUp("left")
Opt("WinWaitDelay",100)
Opt("WinTitleMatchMode",4)
Opt("WinDetectHiddenText",1)
Opt("MouseCoordMode",0)
WinWait("000webhost.com Members Area - Windows Internet Explorer","Address Combo Contro")
If Not WinActive("000webhost.com Members Area - Windows Internet Explorer","Address Combo Contro") Then WinActivate("000webhost.com Members Area - Windows Internet Explorer","Address Combo Contro")
WinWaitActive("000webhost.com Members Area - Windows Internet Explorer","Address Combo Contro")
MouseMove(22,80)
MouseMove(22,80)
MouseMove(22,80)
MouseDown("left")
MouseUp("left")
MouseMove(49,212)
MouseMove(49,212)
MouseMove(49,212)
MouseDown("left")
MouseUp("left")
WinWait("Save Webpage","Save as &type:")
If Not WinActive("Save Webpage","Save as &type:") Then WinActivate("Save Webpage","Save as &type:")
WinWaitActive("Save Webpage","Save as &type:")
Send("bike")
MouseMove(433,398)
MouseDown("left")
MouseUp("left")
MouseMove(384,453)
MouseMove(384,453)
MouseMove(384,453)
MouseDown("left")
MouseUp("left")
MouseMove(499,366)
MouseMove(499,366)
MouseMove(499,366)
MouseDown("left")
MouseUp("left")
WinWait("Save Webpage","D:\Objects To Burn\D")
If Not WinActive("Save Webpage","D:\Objects To Burn\D") Then WinActivate("Save Webpage","D:\Objects To Burn\D")
WinWaitActive("Save Webpage","D:\Objects To Burn\D")
MouseMove(134,102)
MouseMove(134,102)
MouseMove(134,102)
MouseDown("left")
MouseUp("left")
exit

MouseMove(340,160)
MouseDown("left")
MouseUp("left")
WinWait("Google AdSense - Reports - Windows Internet Explorer","Address Combo Contro")
If Not WinActive("Google AdSense - Reports - Windows Internet Explorer","Address Combo Contro") Then WinActivate("Google AdSense - Reports - Windows Internet Explorer","Address Combo Contro")
WinWaitActive("Google AdSense - Reports - Windows Internet Explorer","Address Combo Contro")
MouseMove(159,275)
MouseDown("left")
MouseUp("left")
WinWait("Security Warning","Do you want to view ")
If Not WinActive("Security Warning","Do you want to view ") Then WinActivate("Security Warning","Do you want to view ")
WinWaitActive("Security Warning","Do you want to view ")
MouseMove(322,141)
MouseDown("left")
MouseUp("left")
WinWait("Google AdSense - Get Ads - Windows Internet Explorer","Address Combo Contro")
If Not WinActive("Google AdSense - Get Ads - Windows Internet Explorer","Address Combo Contro") Then WinActivate("Google AdSense - Get Ads - Windows Internet Explorer","Address Combo Contro")
WinWaitActive("Google AdSense - Get Ads - Windows Internet Explorer","Address Combo Contro")
MouseMove(140,430)
MouseClick("left",139,430,2)
sleep(4000)
WinWait("Security Warning","Do you want to view ")
If Not WinActive("Security Warning","Do you want to view ") Then WinActivate("Security Warning","Do you want to view ")
WinWaitActive("Security Warning","Do you want to view ")
MouseMove(306,143)
sleep(4000)
MouseDown("left")
MouseUp("left")
WinWait("Google AdSense - AdSense for Content - Windows Internet Explorer","Address Combo Contro")
If Not WinActive("Google AdSense - AdSense for Content - Windows Internet Explorer","Address Combo Contro") Then WinActivate("Google AdSense - AdSense for Content - Windows Internet Explorer","Address Combo Contro")
WinWaitActive("Google AdSense - AdSense for Content - Windows Internet Explorer","Address Combo Contro")
MouseMove(357,420)
sleep(4000)
MouseDown("left")
MouseUp("left")
Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}")
MouseMove(82,413)
sleep(4000)
MouseDown("left")
MouseUp("left")
MouseMove(226,442)
sleep(4000)
MouseDown("left")
MouseUp("left")
Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}")
MouseMove(172,420)
sleep(4000)
MouseDown("left")
MouseUp("left")
MouseMove(212,422)
sleep(4000)
MouseDown("left")
MouseUp("left")
Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}")
MouseMove(99,390)
sleep(4000)
MouseDown("left")
MouseUp("left")
MouseMove(473,192)
sleep(4000)
MouseDown("left")
MouseUp("left")
MouseMove(493,201)
sleep(4000)
MouseDown("left")
MouseUp("left")
MouseMove(293,426)
sleep(4000)
MouseDown("left")
MouseUp("left")
Send("{UP}{UP}{UP}{DOWN}{DOWN}{DOWN}")
MouseMove(104,388)
sleep(4000)
MouseDown("left")
MouseUp("left")
WinWait("Explorer User Prompt","Please enter a name ")
If Not WinActive("Explorer User Prompt","Please enter a name ") Then WinActivate("Explorer User Prompt","Please enter a name ")
WinWaitActive("Explorer User Prompt","Please enter a name ")
Send("{CTRLDOWN}v{CTRLUP}")
MouseMove(446,54)
sleep(4000)
MouseDown("left")
MouseUp("left")
WinWait("Google AdSense - AdSense for Content - Windows Internet Explorer","Address Combo Contro")
If Not WinActive("Google AdSense - AdSense for Content - Windows Internet Explorer","Address Combo Contro") Then WinActivate("Google AdSense - AdSense for Content - Windows Internet Explorer","Address Combo Contro")
WinWaitActive("Google AdSense - AdSense for Content - Windows Internet Explorer","Address Combo Contro")
MouseMove(784,443)
sleep(4000)
MouseDown("left")
MouseMove(792,416)
MouseUp("left")
MouseMove(158,497)
sleep(4000)
MouseDown("left")
MouseUp("left")
MouseMove(264,449)
MouseDown("left")
MouseUp("left")
Send("{DOWN}{DOWN}{DOWN}{DOWN}")
MouseMove(550,368)
MouseDown("left")
MouseUp("left")
Send("..{CTRLDOWN}v{CTRLUP}")
EndFunc

Func _findChecksum($pixel,$chksum)

	$x = 5 ;LEFT pixel of Total Area to Search for $pixel
	$y = 5 ;TOP
	$xpixel = @DesktopWidth - 5 ;Right
	$ypixel = @DesktopHeight - 5 ;Bottom

	While 1
		$xy = PixelSearch($x,$y,$xpixel,$ypixel,$pixel, 0)

        If @error And $ypixel = (@DesktopHeight - 5)Then
            MsgBox(4096,"@Error ","Could not find Checksum" & @LF & '     Finished Searching all of Screen', 4)

			exit
		ElseIf @error Then
            $y = $ypixel + 1
            $ypixel = (@DesktopHeight - 5)
            $x = 0
		ElseIf $chksum = PixelCheckSum($xy[0]-4, $xy[1]-20, $xy[0]+4, $xy[1]+20) Then
			ToolTip("Found Checksum")
			MouseMove($xy[0],$xy[1], 20)
			MouseClick("Left",$xy[0],$xy[1])
			Sleep(500)
			;Exit
			Return 1
		Else
			$y = $xy[1]
            $ypixel = $y
            $x = $xy[0] + 1
		EndIf
	WEnd

EndFunc

Func _Button1_Pressed()

	Opt("WinWaitDelay",100)
	Opt("WinTitleMatchMode",4)
	Opt("WinDetectHiddenText",1)
	Opt("MouseCoordMode",0)

	$oIE = _IECreate ("www.igoogle.com")
	Send("{TAB 12}")
	Send("{ENTER}")
	_IELoadWait ($oIE)

	sleep(5000)
	;_findChecksum('14547148','3663187224');This is where the cursor moves over the "maximize" button right next to Google Insights For Search.
	;sleep(7000)
	;_findChecksum('14547148','3707155282');This is where the cursor moves over the "Edit Settings" selection.
	;sleep(7000)
	;MouseMove(783,249);This is where the cursor slides the slider down.
	;MouseDown("left")
	;MouseMove(775,296)
	;MouseUp("left")
	;sleep(7000)
	;MouseMove(546,348)
	;MouseDown("left")
	;MouseUp("left")
	;sleep(1000)
	;_findChecksum('16777215','2377961821');This is where the cursor moves over the "Arts and Humanities" selection.
	;sleep(7000)
	;_findChecksum('67','3026216628')
	sleep(12000)
	MouseMove(21,80);Cursor moves over the "File" tab at the top of the screen.
	sleep(7000)
	MouseDown("left")
	MouseUp("left")
	MouseMove(46,212);Cursor moves over "Save As" .
	sleep(11000)
	MouseDown("left")
	MouseUp("left")
	sleep(8000)
	MouseMove(373,394);Cursor moves over "Save As Type" .
	sleep(7000)
	MouseDown("left")
	MouseUp("left")
	MouseMove(345,451);Cursor moves over "Text File.txt" .
	sleep(6000)
	MouseDown("left")
	MouseUp("left")
	sleep(7000)
	sleep(4000)
	MouseMove(510,371);Cursor moves over the "Save" button .
	sleep(4000)
	MouseDown("left")
	MouseUp("left")
	sleep(7000)

EndFunc

Func _GetKeywords()
	Local $hFile = FileOpen("D:\Documents and Settings\Taevon Jones\Desktop\New Text Document.txt", 2)

	Dim $aRecords
	If Not _FileReadToArray("D:\Objects To Burn\Documents\iGoogle.txt",$aRecords) Then
		MsgBox(4096,"Error", " Error reading log to Array     error:" & @error)
		Exit
	EndIf

	For $i = 1 to $aRecords[0]

		If StringInStr( $aRecords[$i] ,'Location: United States') > 1 Then
			For $x = $i+1 to $aRecords[0]
				$aRecords[$x] = StringRegExpReplace($aRecords[$x], "\+\d+%", "")
				If StringInStr( $aRecords[$x],'View full report') > 1 Then ExitLoop
				If not $aRecords[$x] = "" and _
					not (StringInStr( $aRecords[$x],'Not enough search') > 1) and _
					not (StringInStr( $aRecords[$x],'criteria and try') > 1) Then FileWriteLine($hFile,StringStripWS($aRecords[$x],1) )
			Next
		EndIf
		If StringInStr( $aRecords[$i] ,'Category: Automotive') > 1 Then
			For $x = $i+1 to $aRecords[0]
				$aRecords[$x] = StringRegExpReplace($aRecords[$x], "\+\d+%", "")
				If StringInStr( $aRecords[$x] ,'View full report') > 1 Then ExitLoop
				If not $aRecords[$x] = "" and _
					not (StringInStr( $aRecords[$x],'Not enough search') > 1) and _
					not (StringInStr( $aRecords[$x],'criteria and try') > 1) Then FileWriteLine($hFile,StringStripWS($aRecords[$x],1) )
			Next
		EndIf

	Next
	FileClose($hFile)
EndFunc

Func _PopulateKeyWords()
	Dim $chars, $data
	;-----------------------------------------------o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0
	_FileReadToArray("D:\Documents and Settings\Taevon Jones\Desktop\New Text Document.txt", $chars)
    _ArraySort($chars)
	For $i = 1 to $chars[0]
		GUICtrlSetData($List1,GUICtrlRead($List1)&$chars[$i]&@CRLF)
	Next

EndFunc

Func _ReadFile($File)
	$file = FileOpen($File, 0)

	$chars = FileRead($file)

	FileClose($file)
	Return $chars
EndFunc

Func _GetKeywords2()
Local $hFile = FileOpen("D:\Documents and Settings\Taevon Jones\Desktop\New Text Document.txt", 2)

Dim $aRecords
	If Not _FileReadToArray("D:\Objects To Burn\Documents\iGoogle.txt",$aRecords) Then
		MsgBox(4096,"Error", " Error reading log to Array     error:" & @error)
		Exit
	EndIf

	Dim $chars, $data
	;-----------------------------------------------o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0o0
	_FileReadToArray("D:\Documents and Settings\Taevon Jones\Desktop\New Text Document.txt", $chars)
    _ArraySort($chars)
	For $i = 1 to $chars[0]
		GUICtrlSetData($List1,GUICtrlRead($List1)&$chars[$i]&@CRLF)
	Next

EndFunc

