; ==================================================================
; == xxxxxxxxxxxxxxxxxxxxxxxxx Labor xxxxx Reporter
; == 
; == Developed and maintained By The Workspace Solution, Inc.
; == The Workspace Solution Copyright June, 2006
; == GUI initially generated with Koda
; == Created June 18, 2006
; ==================================================================
Opt("WinWaitDelay",100)
Opt("WinTitleMatchMode",4)
Opt("WinDetectHiddenText",1)
Opt("MouseCoordMode",0)

; Active xxxxx then position & size xxxxx window for menu controls
WinWait("xxxxx yyyyy","")
If Not WinActive("xxxxx yyyyy","") Then WinActivate("xxxxx yyyyy","")
WinWaitActive("xxxxx yyyyy","")
; Position & size xxxxx window for menu controls
WinMove("xxxxx yyyyy","",1,1,655,481)
; Select Report menu
WinWait("xxxxx yyyyy","")
If Not WinActive("xxxxx yyyyy","") Then WinActivate("xxxxx yyyyy","")
WinWaitActive("xxxxx yyyyy","")
Sleep(2000)

; If Reports menu item is not there then have to login into software
If WinMenuSelectItem("xxxxx Manager - TableService","","&Reports","&Employee","&Labor") = 0 Then
	WinMenuSelectItem("xxxxx Manager - TableService","","&File","Log&in")
	WinWait("xxxxx Manager Login","")
	If Not WinActive("xxxxx Manager Login","") Then WinActivate("xxxxx Manager Login","")
	WinWaitActive("xxxxx Manager Login","")
	ControlSend ("xxxxx Manager Login", "", "Edit1", "999")
	Sleep(1000)
	ControlSend ("xxxxx Manager Login", "", "Edit2", "4096")
	Sleep(1000)
	ControlClick ( "xxxxx Manager Login","&Login", "Button1","Left")
	Sleep(2000)
	WinWait("xxxxx yyyyy","")
	If Not WinActive("xxxxx yyyyy","") Then WinActivate("xxxxx yyyyy","")
	WinWaitActive("xxxxx yyyyy","")
	WinMenuSelectItem("xxxxx yyyyy","","&Reports","&Employee","&Labor")
EndIf

WinWait("Labor Report","")
If Not WinActive("Labor Report","") Then WinActivate("Labor Report","")
WinWaitActive("Labor Report","")
; Select first dated item in select date listbox
;ControlListView ( "Labor Report", "", 24219, "select",2 ) --- this did not work
;ControlListView ( "Labor Report", "", "ListBox1", "select",2 ) --- nor this one - guess listbox is
;                                                                   not listview???
MouseClick("left",60,83)
Sleep(2000)

; Click click on select all employees checkbox
ControlClick ( "Labor Report", "", 1190,"left")
;MouseMove(175,281)
;MouseDown("left")
;MouseUp("left")
Sleep(2000)

; Make sure Select Report Settings is set to 'Default1'
;ControlListView ( "Labor Report", "", 2186, "Select" ,1) --- this did not work - guess it should not
;                                                             since it is a combobox and not listview
MouseClick("left",410,83)
sleep(1000)
MouseClick("left",313,105)

; Click on the Export button to get export done message box
;ControlClick ( "Labor Report", "$Export", 17216,"left") --- this did not work - have to use mouse click
;ControlClick ( "Labor Report", "$Export", "button1","left") --- not this one
MouseClick("left",270,330)
Sleep(2000)

WinWait("Export File","")
If Not WinActive("Export File","") Then WinActivate("Export File","")
WinWaitActive("Export File","")
ControlClick ( "Export File", "OK",2,"left")
Sleep(1000)

; Click on Close button to finish
WinWait("Labor Report","")
If Not WinActive("Labor Report","") Then WinActivate("Labor Report","")
WinWaitActive("Labor Report","")
;ControlClick ( "Sales Report", "$Close",2,"left") --- this did not work - have to use mouse click
;ControlClick ( "Sales Report", "$Close","Button2","left") --- this did not work - have to use mouse click
MouseClick("left",370,330)
Sleep(1000)
