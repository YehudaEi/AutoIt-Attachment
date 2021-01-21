#include <GUIConstants.au3>
Opt("RunErrorsFatal", 0)
Opt("GUICloseOnESC",1)
Opt("TrayIconHide",1)
$ErrorLevel=1

$Form1 = GUICreate("RunAsGui", 318, 124, 192, 125, -1, BitOR($WS_EX_TOOLWINDOW,$WS_EX_WINDOWEDGE))
$Ok = GUICtrlCreateButton("&Ok", 216, 72, 81, 25, 0)
$Input1 = GUICtrlCreateInput("", 104, 40, 193, 21, BitOR($ES_PASSWORD,$ES_AUTOHSCROLL))
GUICtrlCreateLabel("Admin Account", 8, 16, 92, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlCreateLabel("Password", 8, 40, 64, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Combo1 = GUICtrlCreateCombo("Administrator", 104, 16, 193, 21)
GUICtrlSetData(-1, "Administrateur")
GUICtrlCreateLabel("Provided By WhatDoYouWant", 8, 80, 146, 17)
GUISetState(@SW_SHOW)
GUICtrlSetState($Input1,$GUI_FOCUS)

While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case $msg = $Ok
		$UserCpt=@UserName
		WinSetState("RunAsGui","",@SW_HIDE)
		RunAsSet(GUICtrlRead($Combo1), @ComputerName,GUICtrlRead($Input1))
		run("cmd exit",@SystemDir,@SW_HIDE)
		$ErrorLevel=@error

		If $ErrorLevel<>0 then 
			MsgBox(64,"","Wrong Password.")
			Exit		
		Else
			ProcessClose("explorer.exe")
			$PID = ProcessExists("explorer.exe") ; Will return the PID or 0 if the process isn't found.
			ProcessClose($PID)
			Run(@WindowsDir & "\explorer.exe",@WindowsDir,@SW_HIDE)
			SplashTextOn("Warning", "You are logged with " & GUICtrlRead($Combo1) & " account.", 530,30 , 0, 0, 1+4, "", 20)
			$click_Ok=MsgBox(64,"","Click Ok to return under the profile of " & @UserName & "." &@CRLF &"The session will be closed and all your applications too.")
			
		EndIf
			Do 
			Until $click_Ok= 1
				Shutdown(0)
	EndSelect
WEnd
Exit
