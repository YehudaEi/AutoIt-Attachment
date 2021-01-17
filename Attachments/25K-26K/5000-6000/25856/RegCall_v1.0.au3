
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.0.0
 Author:         Vincent Willems

 Script Function:
	Call management system.

#ce ----------------------------------------------------------------------------

#include <Date.au3>
#include <DateTimeConstants.au3>
#Include <Array.au3>
#Include <GuiListView.au3>
#include <GuiEdit.au3>
#include <GUIListBox.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <String.au3>
#include <ButtonConstants.au3>
Global $DoubleClicked = False, $callist

IF FileExists("calls.dat") then 
	check()
Else
	FileWrite("calls.dat", "")
	check()
EndIf

Func check()
IF FileExists("user.dat") then 
	login()
Else
	first_time()
EndIf

EndFunc

Func WM_NOTIFY($hWnd, $MsgID, $wParam, $lParam)
    Local $tagNMHDR, $event, $hwndFrom, $code
    $tagNMHDR = DllStructCreate("int;int;int", $lParam)
    If @error Then Return 0
    $code = DllStructGetData($tagNMHDR, 3)
    If $wParam = $callist And $code = -3 Then $DoubleClicked = True
    Return $GUI_RUNDEFMSG
EndFunc



Func First_time()
	
	MsgBox(0, "Error", "User database was not found."&@CRLF&"Please enter a username and password to create the admin account.")

	GUICreate("Wachtwoord", 340, 180)
	Opt("GUICoordMode", 2)
	             GUICtrlCreateLabel("Username:", 10, 20, 160, 20)
	$userfield = GUICtrlCreateInput("", 1, -20, 160, 20)
	             GUICtrlCreateLabel("Password:", -320, 20, 160, 20)
	$pwfield1  = GUICtrlCreateInput("", 1, -20, 160, 20, $ES_PASSWORD)
				 GUICtrlCreateLabel("Password again:", -320, 20, 160, 20)
	$pwfield2  = GUICtrlCreateInput("", 1, -1, 160, 20, $ES_PASSWORD)
	$ok        = GUICtrlCreateButton("Ok", -320, 20, 140, 20, $BS_DEFPUSHBUTTON)
	$cancel    = GUICtrlCreateButton("Cancel", 40, -20)

	GUISetState()
	While 1
			$msg = GUIGetMsg()
			Select
				Case $msg = $GUI_EVENT_CLOSE
					ExitLoop
				Case $msg = $ok
					if GUICtrlRead($pwfield1) = GUICtrlRead($pwfield2) then
						FileWrite("user.dat", "["&GUICtrlRead($userfield)&"]"&@CRLF)
						FileWriteLine("user.dat", "pass="&_StringEncrypt(1, GUICtrlRead($pwfield1), "admin", 1))
						MsgBox(0, "Info", "Admin username en password saved"&@CRLF&@CRLF&"Please login now.")
						GUIDelete("Wachtwoord")
						login()
						ExitLoop
					Else
						MsgBox(0, "Error", "Password does not match, please try again.")
					EndIf
				Case $msg = $cancel
					ExitLoop
			EndSelect
		WEnd


EndFunc

Func login()
	
	GUICreate("Login", 340, 130)
	Opt("GUICoordMode", 2)
	             GUICtrlCreateLabel("Username:", 10, 20, 160, 20)
	$userlogin = GUICtrlCreateInput("", 1, -20, 160, 20)
	             GUICtrlCreateLabel("Password:", -320, 20, 160, 20)
	$pwlogin   = GUICtrlCreateInput("", 1, -20, 160, 20, $ES_PASSWORD)
	$ok        = GUICtrlCreateButton("Ok", -320, 20, 140, 20, $BS_DEFPUSHBUTTON)
	$cancel    = GUICtrlCreateButton("Cancel", 40, -20)
	
	

	GUISetState()
	While 1
			$msg = GUIGetMsg()
			Select
				Case $msg = $GUI_EVENT_CLOSE
					ExitLoop
				Case $msg = $ok
					$key = GUICtrlRead($userlogin)
					$pass = _StringEncrypt(0, IniRead("user.dat", $key, "pass", "FAILED"), "admin", 1)
					if GUICtrlRead($pwlogin) = $pass Then
						Global $aanmeldernaam = IniRead("user.dat", GUICtrlRead($userlogin), "achternaam", "failed")&", "&IniRead("user.dat", GUICtrlRead($userlogin), "voornaam", "failed")
						Global $usedloginname = GUICtrlRead($userlogin)
						GUIDelete("Aanmelden")
						If FileExists("settings.ini") Then 
						Else
							MsgBox(0, "Info", "Settings are not configured yet. Please click Settings to configure them.")
						EndIf
						main()
						ExitLoop
					Else
						msgbox(0, "Error", "Username and/or password incorrect.")
					EndIf
				Case $msg = $cancel
					ExitLoop
			EndSelect
		WEnd

EndFunc



Func main()
	
	$mainscreen   = GUICreate("RegCall 1.0", 840, 600)
	Opt("GUICoordMode", 2)
	
	$callist        = GUICtrlCreateListView("Call no:|Status:|Name:|Subject:|Call date:|Priority:|Logged by:", 30, 30, 780, 250)
					  GUICtrlCreateLabel("Filters", -725, 50, 50, 20)
	$call_all       = GUICtrlCreateButton("All Calls", -105, 10, 140, 20)
	$call_open      = GUICtrlCreateButton("Open Calls", -1, 20)
	$call_waituser  = GUICtrlCreateButton("Wait for User Calls", -1, 20)
	$call_find      = GUICtrlCreateButton("Find Calls", -1, 20)
	$call_closed    = GUICtrlCreateButton("Closed Calls", -1, 20)
	
	$call_new		= GUICtrlCreateButton("New Call...",180 ,-180, 140, 20)
	$call_edit      = GUICtrlCreateButton("Edit Call...", -1, 20)
	$call_close     = GUICtrlCreateButton("Close Call", -1, 20)
	$call_reopen    = GUICtrlCreateButton("Reopen Call", -1, 20)
	$users          = GUICtrlCreateButton("Users...", 180 ,-140, 140, 20)
	$settings       = GUICtrlCreateButton("Settings...", -1 ,20, 140, 20)
	$exit           = GUICtrlCreateButton("Exit", -1, 20)
	$export         = GUICtrlCreateButton("Export to Excel...", -460, 60)
	
	GUICtrlCreateGraphic(15, 320, 800, 600)
	GUICtrlSetGraphic(-1, $GUI_GR_LINE, 0, 230)
	GUICtrlSetGraphic(-1, $GUI_GR_LINE, 165, 230)
	GUICtrlSetGraphic(-1, $GUI_GR_LINE, 165, -1)
	GUICtrlSetGraphic(-1, $GUI_GR_LINE, -1, -1)
	$var            = IniReadSectionNames("calls.dat")
	
	if $var = 1 Then
		$i = 1
	Else
		For $i = 1 To $var[0]
			GUICtrlCreateListViewItem(IniRead("calls.dat", $var[$i], "callno", "N/A")&"|"&(IniRead("calls.dat", $var[$i], "status", "N/A"))&"|"&IniRead("calls.dat", $var[$i], "name", "N/A")&"|"&IniRead("calls.dat", $var[$i], "subject", "N/A")&"|"&IniRead("calls.dat", $var[$i], "open_date", "N/A")&"|"&IniRead("calls.dat", $var[$i], "priority", "N/A")&"|"&IniRead("calls.dat", $var[$i], "made_by", "N/A"), $callist)
		Next
	EndIf	
	_GUICtrlListView_SetColumnWidth($callist, 3, 250)
	GUISetState()
	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
	While 1
			$msg = GUIGetMsg()
			Select
				Case $msg = $export
					ProgressOn("Progress Meter", "One moment please...", "")
					$oExcel = ObjCreate("Excel.Application")
					$oExcel.Visible = 0
					$oExcel.WorkBooks.Add
					$oExcel.ActiveWorkBook.ActiveSheet.Cells(1,1).Value="Call no:"
					$oExcel.ActiveWorkBook.ActiveSheet.Cells(1,2).Value="Status"
					$oExcel.ActiveWorkBook.ActiveSheet.Cells(1,3).Value="Name:"
					$oExcel.ActiveWorkBook.ActiveSheet.Cells(1,4).Value="Subject:"
					$oExcel.ActiveWorkBook.ActiveSheet.Cells(1,5).Value="Call date:"
					$oExcel.ActiveWorkBook.ActiveSheet.Cells(1,6).Value="Priority:"
					$oExcel.ActiveWorkBook.ActiveSheet.Cells(1,7).Value="Logged by:"
					ProgressSet(30)
					$var = IniReadSectionNames("calls.dat")
					$count = 1
					
					For $i = 1 To $var[0]
						$count = 1 + $count
						$oExcel.ActiveWorkBook.ActiveSheet.Cells($count,1).Value=IniRead("calls.dat", $var[$i], "callno", "N/A")
						$oExcel.ActiveWorkBook.ActiveSheet.Cells($count,2).Value=IniRead("calls.dat", $var[$i], "status", "N/A")
						$oExcel.ActiveWorkBook.ActiveSheet.Cells($count,3).Value=IniRead("calls.dat", $var[$i], "name", "N/A")
						$oExcel.ActiveWorkBook.ActiveSheet.Cells($count,4).Value=IniRead("calls.dat", $var[$i], "subject", "N/A")
						$oExcel.ActiveWorkBook.ActiveSheet.Cells($count,5).Value=IniRead("calls.dat", $var[$i], "open_date", "N/A")
						$oExcel.ActiveWorkBook.ActiveSheet.Cells($count,6).Value=IniRead("calls.dat", $var[$i], "priority", "N/A")
						$oExcel.ActiveWorkBook.ActiveSheet.Cells($count,7).Value=IniRead("calls.dat", $var[$i], "made_by", "N/A")
					Next
					ProgressSet(80)
					$oExcel.Range("A1:G1").Select
					$oExcel.Selection.Font.Bold = True
					$oExcel.Range("A1:A1").Select
					$oExcel.Selection.AutoFilter
					$oExcel.Columns("A:A").EntireColumn.AutoFit
					$oExcel.Columns("B:B").EntireColumn.AutoFit
					$oExcel.Columns("C:C").EntireColumn.AutoFit
					$oExcel.Columns("D:D").EntireColumn.AutoFit
					$oExcel.Columns("E:E").EntireColumn.AutoFit
					$oExcel.Columns("F:F").EntireColumn.AutoFit
					$oExcel.Columns("G:G").EntireColumn.AutoFit
					ProgressSet(99)
					ProgressOff()
					$oExcel.Visible = 1
					
					
				Case $msg = $settings
					settings()
				Case $msg = $call_edit or $DoubleClicked
				if GUICtrlRead($callist) = 0 Then
					MsgBox(0, "Error", "No selection made")
				Else
				$calledittemp = GUICtrlRead(GUICtrlRead($callist))
				$calleditnr = StringLeft($calledittemp, 6)
				
						$guiedit = GUICreate("Edit Call", 620, 590)
						Opt("GUICoordMode", 1)
						GUICtrlCreateLabel("Call no:", 30, 20)
						$callno           = GUICtrlCreateInput(IniRead("calls.dat", $calleditnr, "callno", "N/A"), 100, 20, 50, 20, $ES_READONLY)
						GUICtrlCreateLabel("Logged by:", 330, 20, 65)
						$madeby			 = GUICtrlCreateInput(IniRead("calls.dat", $calleditnr, "made_by", "N/A"), 400, 20, 190, 20, $ES_READONLY)
						GUICtrlCreateLabel("Name:", 30, 60, 49)
						$callname        = GUICtrlCreateInput(IniRead("calls.dat", $calleditnr, "name", "N/A"), 100, 60, 190, 20)
						GUICtrlCreateLabel("Subject:", 30, 100)
						$callsubject     = GUICtrlCreateInput(IniRead("calls.dat", $calleditnr, "subject", "N/A"), 100, 100, 190, 20)
						GUICtrlCreateLabel("Date:", 30, 140)
						$calldate        = GUICtrlCreateInput(IniRead("calls.dat", $calleditnr, "open_date", "N/A"), 100, 140, 190, 20, $ES_READONLY)
						GUICtrlCreateLabel("Priority:", 30, 180)
						$callprio		 = GUICtrlCreateCombo(IniRead("calls.dat", $calleditnr, "priority", "N/A"), 100, 180, 190, 20)
						GUICtrlSetData($callprio, "High|Medium|Low", IniRead("calls.dat", $calleditnr, "priority", "N/A"))
						GUICtrlCreateLabel("Status:", 30, 220)
						$callstatus		 = GUICtrlCreateCombo(IniRead("calls.dat", $calleditnr, "status", "N/A"), 100, 220, 190, 20)
						GUICtrlSetData($callstatus, "Open|Closed|Wait for user", IniRead("calls.dat", $calleditnr, "status", "N/A"))
						GUICtrlCreateLabel("Actions", 30, 260)
						$callaction      = GUICtrlCreateEdit(StringReplace(IniRead("calls.dat", $calleditnr, "actions", "N/A"),"[\r\n]",@CRLF), 100, 260, 500, 125, BitOR($ES_MULTILINE, $ES_WANTRETURN, $ES_AUTOVSCROLL, $WS_VSCROLL))
						GUICtrlCreateLabel("Description", 30, 400)
						GUICtrlCreateLabel("Close date:", 330, 60, 65)
						$close_date		 = GUICtrlCreateInput(Iniread("calls.dat", $calleditnr, "close_date", "N/A"), 400, 60, 190, 20, $ES_READONLY)
						$timestampaction = GUICtrlCreateButton("Timestamp ->", 15, 280, 80, 20)
						$timestampdisc   = GUICtrlCreateButton("Timestamp ->", 15, 420, 80, 20)
						$calldiscription = GUICtrlCreateEdit(StringReplace(IniRead("calls.dat", $calleditnr, "description", "N/A"),"[\r\n]",@CRLF), 100, 400, 500, 125, BitOR($ES_MULTILINE, $ES_WANTRETURN, $ES_AUTOVSCROLL, $WS_VSCROLL))
						$ok				 = GUICtrlCreateButton("OK", 100, 550, 100, 20)
						$cancel          = GUICtrlCreateButton("Annuleren", 220, 550, 100, 20)
						
				GUISetState()
				While 2
					$msg = GUIGetMsg()
						Select
							Case $msg = $GUI_EVENT_CLOSE
								GUIDelete($guiedit)
								Exitloop
							Case $msg = $ok
								if GUICtrlRead($callname)  = "" Or GUICtrlRead($callsubject) = "" Then 
									MsgBox(0, "Error", "Not all required field are filled in" & @CRLF & "Required fields are:" & @CRLF & @CRLF & "Name" &@CRLF & "Subject")
								Else
								IniWrite("calls.dat", Guictrlread($callno), "callno", Guictrlread($callno))
								IniWrite("calls.dat", Guictrlread($callno), "name", Guictrlread($callname))
								IniWrite("calls.dat", Guictrlread($callno), "subject", Guictrlread($callsubject))
								IniWrite("calls.dat", Guictrlread($callno), "open_date", Guictrlread($calldate))
								IniWrite("calls.dat", Guictrlread($callno), "description", StringReplace(Guictrlread($calldiscription), @CRLF, "[\r\n]"))
								IniWrite("calls.dat", Guictrlread($callno), "actions", StringReplace(Guictrlread($calldiscription), @CRLF, "[\r\n]"))
								IniWrite("calls.dat", Guictrlread($callno), "priority", Guictrlread($callprio))
								IniWrite("calls.dat", Guictrlread($callno), "status", Guictrlread($callstatus))
								IniWrite("calls.dat", Guictrlread($callno), "made_by", Guictrlread($madeby))
								If Guictrlread($callstatus) = "Closed" Then IniWrite("calls.dat", Guictrlread($callno), "close_date", _NowDate())
								If Guictrlread($callstatus) = "Open" Or "Wait for user" Then IniWrite("calls.dat", Guictrlread($callno), "close_date", "N/A")
								MsgBox(0, "Info", "Changes are saved.")
								GUIDelete($guiedit)
								_GUICtrlListView_DeleteAllItems($callist)
								For $i = 1 To $var[0]
									GUICtrlCreateListViewItem(IniRead("calls.dat", $var[$i], "callno", "N/A")&"|"&(IniRead("calls.dat", $var[$i], "status", "N/A"))&"|"&IniRead("calls.dat", $var[$i], "name", "N/A")&"|"&IniRead("calls.dat", $var[$i], "subject", "N/A")&"|"&IniRead("calls.dat", $var[$i], "open_date", "N/A")&"|"&IniRead("calls.dat", $var[$i], "priority", "N/A")&"|"&IniRead("calls.dat", $var[$i], "made_by", "N/A"), $callist)
								Next
								ExitLoop
								EndIf
							Case $msg = $timestampaction
								GUICtrlSetData($callaction, $aanmeldernaam & " on " & _NowDate() & " " & " wrote:" & @CRLF & "-> write comment here <-" & @CRLF & "=================================" & @CRLF & StringReplace(IniRead("calls.dat", $calleditnr, "actions", ""),"[\r\n]",@CRLF))
							Case $msg = $timestampdisc
								GUICtrlSetData($calldiscription, $aanmeldernaam & " on " & _NowDate() & " " & " wrote:" & @CRLF & "-> write comment here <-" & @CRLF & "=================================" & @CRLF & StringReplace(IniRead("calls.dat", $calleditnr, "description", ""),"[\r\n]",@CRLF))	
							Case $msg = $cancel
								GUIDelete($guiedit)
								ExitLoop
							EndSelect
						WEnd
					
					EndIf
					$DoubleClicked = False
				Case $msg = $users
					users()
				Case $msg = $call_close
					if GUICtrlRead($callist) = 0 Then
						MsgBox(0, "Error", "No selection made")
					Else
					$callclosetemp = GUICtrlRead(GUICtrlRead($callist))
					$callclosenr = StringLeft($callclosetemp, 6)
					$checkopen1  = IniRead("calls.dat", $callclosenr, "status", "")
					
					If $checkopen1 = "Closed" Then
						MsgBox(0, "Error", "Call allready Closed.")
					Else
					
					$guicall_close = GUICreate("Reason?", 450, 200)
					Opt("GUICoordMode", 2)
	                GUICtrlCreateLabel("Reason for close?", 10, 20, 160, 20)
					$closereason  = GUICtrlCreateEdit("", 1, -20, 260, 120)
					$ok           = GUICtrlCreateButton("Ok", -320, 20, 140, 20)
					$cancel       = GUICtrlCreateButton("Cancel", 40, -20)

					GUISetState()
					While 3
						$msg = GUIGetMsg()
						Select
							Case $msg = $GUI_EVENT_CLOSE
								GUIDelete($guicall_close)
								ExitLoop
							Case $msg = $ok
								IniWrite("calls.dat", $callclosenr, "actions", $aanmeldernaam & " on " & _NowDate() & " " & " call closed:[\r\n]" & GUICtrlRead($closereason) & "[\r\n]=================================[\r\n]" & IniRead("calls.dat", $callclosenr, "actions", ""))
								IniWrite("calls.dat", $callclosenr, "status", "Closed")
								IniWrite("calls.dat", $callclosenr, "close_date", _NowDate())
								MsgBox(0, "", "Call number "&$callclosenr&" Closed")
								_GUICtrlListView_DeleteAllItems($callist)
								$var = IniReadSectionNames("calls.dat")
								For $i = 1 To $var[0]
									if IniRead("calls.dat", $var[$i], "status", "N/A") = "Closed" Then GUICtrlCreateListViewItem(IniRead("calls.dat", $var[$i], "callno", "N/A")&"|"&(IniRead("calls.dat", $var[$i], "status", "N/A"))&"|"&IniRead("calls.dat", $var[$i], "name", "N/A")&"|"&IniRead("calls.dat", $var[$i], "subject", "N/A")&"|"&IniRead("calls.dat", $var[$i], "open_date", "N/A")&"|"&IniRead("calls.dat", $var[$i], "priority", "N/A")&"|"&IniRead("calls.dat", $var[$i], "made_by", "N/A"), $callist)
									Next
								;EndIf
								GUIDelete($guicall_close)
								ExitLoop
							Case $msg = $cancel
								GUIDelete($guicall_close)
								ExitLoop
						EndSelect
					WEnd
					EndIf
					EndIf
				Case $msg = $call_reopen
					if GUICtrlRead($callist) = 0 Then
					MsgBox(0, "Error", "No selection made")
					Else
					
					$callclosetemp = GUICtrlRead(GUICtrlRead($callist))
					$callclosenr = StringLeft($callclosetemp, 6)
					$checkopen1  = IniRead("calls.dat", $callclosenr, "status", "")
					
					If $checkopen1 = "Open" Or $checkopen1 = "Wait for user" Then
						MsgBox(0, "Error", "Call allready open.")
					Else
					
					$guicall_close = GUICreate("Reason?", 450, 200)
					Opt("GUICoordMode", 2)
	                GUICtrlCreateLabel("Reason for reopen?", 10, 20, 160, 20)
					$closereason  = GUICtrlCreateEdit("", 1, -20, 260, 120)
					$ok           = GUICtrlCreateButton("Ok", -320, 20, 140, 20)
					$cancel       = GUICtrlCreateButton("Cancel", 40, -20)

					GUISetState()
					While 3
						$msg = GUIGetMsg()
						Select
							Case $msg = $GUI_EVENT_CLOSE
								GUIDelete($guicall_close)
								ExitLoop
							Case $msg = $ok
								IniWrite("calls.dat", $callclosenr, "actions", $aanmeldernaam & " on " & _NowDate() & " " & " call reopened:[\r\n]" & GUICtrlRead($closereason) & "[\r\n]=================================[\r\n]" & IniRead("calls.dat", $callclosenr, "actions", ""))
								IniWrite("calls.dat", $callclosenr, "status", "Open")
								IniWrite("calls.dat", $callclosenr, "close_date", "N/A")
								MsgBox(0, "", "Call number "&$callclosenr&" reopened")
								_GUICtrlListView_DeleteAllItems($callist)
								$var = IniReadSectionNames("calls.dat")
								For $i = 1 To $var[0]
									if IniRead("calls.dat", $var[$i], "status", "N/A") = "Open" Then GUICtrlCreateListViewItem(IniRead("calls.dat", $var[$i], "callno", "N/A")&"|"&(IniRead("calls.dat", $var[$i], "status", "N/A"))&"|"&IniRead("calls.dat", $var[$i], "name", "N/A")&"|"&IniRead("calls.dat", $var[$i], "subject", "N/A")&"|"&IniRead("calls.dat", $var[$i], "open_date", "N/A")&"|"&IniRead("calls.dat", $var[$i], "priority", "N/A")&"|"&IniRead("calls.dat", $var[$i], "made_by", "N/A"), $callist)
									Next
								;EndIf
								GUIDelete($guicall_close)
								ExitLoop
							Case $msg = $cancel
								GUIDelete($guicall_close)
								ExitLoop
						EndSelect
					WEnd
					
					EndIf
					EndIf
				Case $msg = $call_new
					
						$guinewcall = GUICreate("New Call", 620, 530)
						Opt("GUICoordMode", 2)
	
						$var = IniReadSectionNames("calls.dat")
						if $var = 1 Then
							$i = 1
						Else	
							For $i = 1 To $var[0]
								IniRead("calls.dat", $var[$i], "callno", "N/A")
							Next
						EndIf
		
						if StringLen($i) = 1 Then
							$newcallno = "00000"&$i
						ElseIf StringLen($i) = 2 Then
							$newcallno = "0000"&$i
						ElseIf StringLen($i) = 3 Then
							$newcallno = "000"&$i
						ElseIf StringLen($i) = 4 Then
							$newcallno = "00"&$i
						ElseIf StringLen($i) = 4 Then
							$newcallno = "0"$i
						ElseIf StringLen($i) = 5 Then
							$newcallno = $i
						EndIf	

						$guinewcall = GUICreate("New Call", 620, 590)
						Opt("GUICoordMode", 1)
						GUICtrlCreateLabel("Call no:", 30, 20)
						$callno           = GUICtrlCreateInput($newcallno, 100, 20, 50, 20, $ES_READONLY)
						GUICtrlCreateLabel("Logged by:", 330, 20, 65)
						$madeby			 = GUICtrlCreateInput($aanmeldernaam, 400, 20, 190, 20, $ES_READONLY)
						GUICtrlCreateLabel("Name:", 30, 60, 49)
						$callname        = GUICtrlCreateInput("", 100, 60, 190, 20)
						GUICtrlCreateLabel("Subject:", 30, 100)
						$callsubject     = GUICtrlCreateInput("", 100, 100, 190, 20)
						GUICtrlCreateLabel("Date:", 30, 140)
						$calldate        = GUICtrlCreateDate("", 100, 140, 190, 20, $DTS_SHORTDATEFORMAT)
						GUICtrlCreateLabel("Priority:", 30, 180)
						$callprio		 = GUICtrlCreateCombo("", 100, 180, 190, 20)
						GUICtrlSetData($callprio, "High|Medium|Low", "Medium")
						GUICtrlCreateLabel("Status:", 30, 220)
						$callstatus		 = GUICtrlCreateCombo("", 100, 220, 190, 20)
						GUICtrlSetData($callstatus, "Open|Closed|Wait for user", "Open")
						GUICtrlCreateLabel("Actions", 30, 260)
						$callaction      = GUICtrlCreateEdit("", 100, 260, 500, 125, BitOR($ES_MULTILINE, $ES_WANTRETURN, $ES_AUTOVSCROLL, $WS_VSCROLL))
						GUICtrlCreateLabel("Description", 30, 400)
						$timestampaction = GUICtrlCreateButton("Timestamp ->", 15, 280, 80, 20)
						$timestampdisc   = GUICtrlCreateButton("Timestamp ->", 15, 420, 80, 20)
						$calldiscription = GUICtrlCreateEdit("", 100, 400, 500, 125, BitOR($ES_MULTILINE, $ES_WANTRETURN, $ES_AUTOVSCROLL, $WS_VSCROLL))
						$ok				 = GUICtrlCreateButton("OK", 100, 550, 100, 20)
						$cancel          = GUICtrlCreateButton("Annuleren", 220, 550, 100, 20)

						GUISetState()
						While 2
							$msg = GUIGetMsg()
								Select
									Case $msg = $timestampaction
										GUICtrlSetData($callaction, $aanmeldernaam & " on " & _NowDate() & " " & " wrote:" & @CRLF & "-> write comment here <-" & @CRLF & "=================================" & @CRLF & StringReplace(IniRead("calls.dat", $newcallno, "actions", ""),"[\r\n]",@CRLF))
									Case $msg = $timestampdisc
										GUICtrlSetData($calldiscription, $aanmeldernaam & " on " & _NowDate() & " " & " wrote:" & @CRLF & "-> write comment here <-" & @CRLF & "=================================" & @CRLF & StringReplace(IniRead("calls.dat", $newcallno, "description", ""),"[\r\n]",@CRLF))
									Case $msg = $GUI_EVENT_CLOSE
										GUIDelete($guinewcall)
										Exitloop
									Case $msg = $ok
										if GUICtrlRead($callname)  = "" Or GUICtrlRead($callsubject) = "" Then 
											MsgBox(0, "Error", "Not all required field are filled in" & @CRLF & "Required fields are:" & @CRLF & @CRLF & "Name" &@CRLF & "Subject")
										Else
										IniWrite("calls.dat", Guictrlread($callno), "callno", Guictrlread($callno))
										IniWrite("calls.dat", Guictrlread($callno), "name", Guictrlread($callname))
										IniWrite("calls.dat", Guictrlread($callno), "subject", Guictrlread($callsubject))
										IniWrite("calls.dat", Guictrlread($callno), "open_date", Guictrlread($calldate))
										IniWrite("calls.dat", Guictrlread($callno), "actions", StringReplace(Guictrlread($callaction), @CRLF, "[\r\n]"))
										IniWrite("calls.dat", Guictrlread($callno), "description", StringReplace(Guictrlread($calldiscription), @CRLF, "[\r\n]")) ;$value = MsgBox(0,"test",$value)
										IniWrite("calls.dat", Guictrlread($callno), "priority", Guictrlread($callprio))
										IniWrite("calls.dat", Guictrlread($callno), "status", Guictrlread($callstatus))
										IniWrite("calls.dat", Guictrlread($callno), "made_by", Guictrlread($madeby))
										MsgBox(0, "Info", "Call saved")
										GUIDelete($guinewcall)
										ExitLoop
										EndIf
										_GUICtrlListView_DeleteAllItems($callist)
										For $i = 1 To $var[0]
											GUICtrlCreateListViewItem(IniRead("calls.dat", $var[$i], "callno", "N/A")&"|"&(IniRead("calls.dat", $var[$i], "status", "N/A"))&"|"&IniRead("calls.dat", $var[$i], "name", "N/A")&"|"&IniRead("calls.dat", $var[$i], "subject", "N/A")&"|"&IniRead("calls.dat", $var[$i], "open_date", "N/A")&"|"&IniRead("calls.dat", $var[$i], "priority", "N/A")&"|"&IniRead("calls.dat", $var[$i], "made_by", "N/A"), $callist)
										Next
									Case $msg = $cancel
										GUIDelete($guinewcall)
										ExitLoop
								EndSelect
							WEnd
					_GUICtrlListView_DeleteAllItems($callist)
					$var = IniReadSectionNames("calls.dat")
						if $var = 1 Then
							$i = 1
						Else
							For $i = 1 To $var[0]
								GUICtrlCreateListViewItem(IniRead("calls.dat", $var[$i], "callno", "N/A")&"|"&(IniRead("calls.dat", $var[$i], "status", "N/A"))&"|"&IniRead("calls.dat", $var[$i], "name", "N/A")&"|"&IniRead("calls.dat", $var[$i], "subject", "N/A")&"|"&IniRead("calls.dat", $var[$i], "open_date", "N/A")&"|"&IniRead("calls.dat", $var[$i], "priority", "N/A")&"|"&IniRead("calls.dat", $var[$i], "made_by", "N/A"), $callist)
							Next
						EndIf	
				Case $msg = $GUI_EVENT_CLOSE
					Exitloop
				case $msg = $call_open
					_GUICtrlListView_DeleteAllItems($callist)
					$var = IniReadSectionNames("calls.dat")
					For $i = 1 To $var[0]
						if IniRead("calls.dat", $var[$i], "status", "N/A") = "Closed" Then
							Else
								GUICtrlCreateListViewItem(IniRead("calls.dat", $var[$i], "callno", "N/A")&"|"&(IniRead("calls.dat", $var[$i], "status", "N/A"))&"|"&IniRead("calls.dat", $var[$i], "name", "N/A")&"|"&IniRead("calls.dat", $var[$i], "subject", "N/A")&"|"&IniRead("calls.dat", $var[$i], "open_date", "N/A")&"|"&IniRead("calls.dat", $var[$i], "priority", "N/A")&"|"&IniRead("calls.dat", $var[$i], "made_by", "N/A"), $callist)
							EndIf
					Next
				Case $msg = $call_closed
					_GUICtrlListView_DeleteAllItems($callist)
					$var = IniReadSectionNames("calls.dat")
					For $i = 1 To $var[0]
						if IniRead("calls.dat", $var[$i], "status", "N/A") = "Closed" Then
							GUICtrlCreateListViewItem(IniRead("calls.dat", $var[$i], "callno", "N/A")&"|"&(IniRead("calls.dat", $var[$i], "status", "N/A"))&"|"&IniRead("calls.dat", $var[$i], "name", "N/A")&"|"&IniRead("calls.dat", $var[$i], "subject", "N/A")&"|"&IniRead("calls.dat", $var[$i], "open_date", "N/A")&"|"&IniRead("calls.dat", $var[$i], "priority", "N/A")&"|"&IniRead("calls.dat", $var[$i], "made_by", "N/A"), $callist)
							Else
							EndIf
					Next
				Case $msg = $call_waituser
					_GUICtrlListView_DeleteAllItems($callist)
					$var = IniReadSectionNames("calls.dat")
					For $i = 1 To $var[0]
						if IniRead("calls.dat", $var[$i], "status", "N/A") = "Wait for user" Then
							GUICtrlCreateListViewItem(IniRead("calls.dat", $var[$i], "callno", "N/A")&"|"&(IniRead("calls.dat", $var[$i], "status", "N/A"))&"|"&IniRead("calls.dat", $var[$i], "name", "N/A")&"|"&IniRead("calls.dat", $var[$i], "subject", "N/A")&"|"&IniRead("calls.dat", $var[$i], "open_date", "N/A")&"|"&IniRead("calls.dat", $var[$i], "priority", "N/A")&"|"&IniRead("calls.dat", $var[$i], "made_by", "N/A"), $callist)
							Else
							EndIf
					Next
				Case $msg = $call_all
					_GUICtrlListView_DeleteAllItems($callist)
					if $var = 1 Then
						$i = 1
					Else	
						For $i = 1 To $var[0]
							GUICtrlCreateListViewItem(IniRead("calls.dat", $var[$i], "callno", "N/A")&"|"&(IniRead("calls.dat", $var[$i], "status", "N/A"))&"|"&IniRead("calls.dat", $var[$i], "name", "N/A")&"|"&IniRead("calls.dat", $var[$i], "subject", "N/A")&"|"&IniRead("calls.dat", $var[$i], "open_date", "N/A")&"|"&IniRead("calls.dat", $var[$i], "priority", "N/A")&"|"&IniRead("calls.dat", $var[$i], "made_by", "N/A"), $callist)
						Next
					EndIf
				Case $msg = $exit
					GUIDelete($mainscreen)
					ExitLoop
				Case $msg = $call_find
						$searchscreen   = GUICreate("Search", 430, 100)
						Opt("GUICoordMode", 2)
	
										  GUICtrlCreateLabel("Field:", 20, 20, 30, 20)
						$search_field	= GUICtrlCreateCombo("", 20, -22, 75, 20)
										  GUICtrlSetData($search_field, "Call no|Status|Name|Subject|Call date|Priority|Logged by", "Call no")
										  GUICtrlCreateLabel("Search string:", 20, -17, 70, 20)
						$search_string	= GUICtrlCreateInput("",20,-23, 150,20)
						$ok				= GUICtrlCreateButton("Search", -1, 25, 70,20)
						$cancel			= GUICtrlCreateButton("Cancel", 10, -1, 70,20)

						$var            = IniReadSectionNames("calls.dat")
	

	
						GUISetState()
						While 1
							$msg = GUIGetMsg()
								Select
									Case $msg = $ok
										if GUICtrlRead($search_field) = "Call no" then $search_key = "callno"
										if GUICtrlRead($search_field) = "Status" then $search_key = "status"
										if GUICtrlRead($search_field) = "Name" then $search_key = "name"
										if GUICtrlRead($search_field) = "Subject" then $search_key = "subject"
										if GUICtrlRead($search_field) = "Call date" then $search_key = "open_date"
										if GUICtrlRead($search_field) = "Priority" then $search_key = "priority"
										if GUICtrlRead($search_field) = "Logged by" then $search_key = "made_by"
					
										_GUICtrlListView_DeleteAllItems($callist)
										$var = IniReadSectionNames("calls.dat")
										For $i = 1 To $var[0]
											if IniRead("calls.dat", $var[$i], $search_key, "N/A") = GuiCtrlRead($search_string) Then
											GUICtrlCreateListViewItem(IniRead("calls.dat", $var[$i], "callno", "N/A")&"|"&(IniRead("calls.dat", $var[$i], "status", "N/A"))&"|"&IniRead("calls.dat", $var[$i], "name", "N/A")&"|"&IniRead("calls.dat", $var[$i], "subject", "N/A")&"|"&IniRead("calls.dat", $var[$i], "open_date", "N/A")&"|"&IniRead("calls.dat", $var[$i], "priority", "N/A")&"|"&IniRead("calls.dat", $var[$i], "made_by", "N/A"), $callist)
										Else
										EndIf
										Next
										GUIDelete($searchscreen)
										ExitLoop
									Case $msg = $GUI_EVENT_CLOSE
										GUIDelete($searchscreen)
										Exitloop
									Case $msg = $cancel
										GUIDelete($searchscreen)
										Exitloop
								EndSelect
							WEnd

			EndSelect
		WEnd
EndFunc
	
Func users()
	$guigebruikers = GUICreate("Users", 280, 180)
	Opt("GUICoordMode", 2)
	$userlist   = GUICtrlCreateList("", 10, 20, 100, 130)
	$newuser    = GUICtrlCreateButton("New...", 10, -130, 140, 20)
	$edituser   = GUICtrlCreateButton("Edit user...", -1, 10)
	$deluser    = GUICtrlCreateButton("Delete...", -1, 10)
	$changepw   = GUICtrlCreateButton("Change password...", -1, 10)
	$sluiten    = GUICtrlCreateButton("Close", -1, 10)
	
	$var = IniReadSectionNames("user.dat")
	
	For $i = 1 To $var[0]
		GUICtrlSetData($userlist, $var[$i])
	Next

	GUISetState()
	While 1
			$msg = GUIGetMsg()
			Select
				Case $msg = $edituser
					if GUICtrlRead($userlist) = "" Then
						MsgBox(0, "Error", "No selection made")
					Else
					$guinewuser = GUICreate("Edit user", 340, 210)
					Opt("GUICoordMode", 2)
	                GUICtrlCreateLabel("Username:", 10, 20, 160, 20)
					$newuserfield = GUICtrlCreateInput(GUICtrlRead($userlist), 1, -20, 160, 20, $ES_READONLY)
	                GUICtrlCreateLabel("First name:", -321, 20, 160, 20)
					$newvoornaam  = GUICtrlCreateInput(IniRead("user.dat", GUICtrlRead($userlist), "voornaam", "Not found"), 1, -20, 160, 20)
					GUICtrlCreateLabel("Last name:", -321, 20, 160, 20)
					$newachternaam= GUICtrlCreateInput(IniRead("user.dat", GUICtrlRead($userlist), "achternaam", "Notfound"), 1, -20, 160, 20)
					GUICtrlCreateLabel("Email adress", -321, 20, 160, 20)
					$newemail	  = GUICtrlCreateInput(IniRead("user.dat", GUICtrlRead($userlist), "email", "Notfound"), 1, -20, 160, 20)
					$ok           = GUICtrlCreateButton("Ok", -321, 20, 140, 20)
					$cancel       = GUICtrlCreateButton("Cancel", 40, -20)

					GUISetState()
					While 1
							$msg = GUIGetMsg()
							Select
								Case $msg = $GUI_EVENT_CLOSE
									GUIDelete($guinewuser)
									ExitLoop
								Case $msg = $ok
									IniWrite("user.dat", GUICtrlRead($newuserfield), "voornaam", GUICtrlRead($newvoornaam))
									IniWrite("user.dat", GUICtrlRead($newuserfield), "achternaam", GUICtrlRead($newachternaam))
									IniWrite("user.dat", GUICtrlRead($newuserfield), "email", GUICtrlRead($newemail))
									GUIDelete($guinewuser)
									ExitLoop
								Case $msg = $cancel
									GUIDelete($guinewuser)
									ExitLoop
							EndSelect
						WEnd
					EndIf
					
				Case $msg = $GUI_EVENT_CLOSE
					GUIDelete($guigebruikers)
					Exitloop
				Case $msg = $changepw
					Global $selected_user
					$selected_user = GUICtrlRead($userlist)
					If $selected_user = "" Then
						MsgBox(0, "Error", "No user selected.")
					Else
						$guichangepw = GUICreate("Change password", 340, 130)
						Opt("GUICoordMode", 2)
	                    GUICtrlCreateLabel("New password", 10, 20, 160, 20)
						$newpass1 = GUICtrlCreateInput("", 1, -20, 160, 20,  $ES_PASSWORD)
						GUICtrlCreateLabel("Retype password", -320, 20, 160, 20)
						$newpass2   = GUICtrlCreateInput("", 1, -20, 160, 20, $ES_PASSWORD)
						$ok           = GUICtrlCreateButton("Ok", -320, 20, 140, 20)
						$cancel       = GUICtrlCreateButton("Cancel", 40, -20)

						GUISetState()
						While 1
							$msg = GUIGetMsg()
								Select
									Case $msg = $GUI_EVENT_CLOSE
										GUIDelete($guichangepw)
										ExitLoop
									Case $msg = $ok
										if GUICtrlRead($newpass1) = GUICtrlRead($newpass2) Then
										IniWrite("user.dat", GUICtrlRead($userlist), "pass", _StringEncrypt(1, GUICtrlRead($newpass1), "admin", 1))
										GUIDelete($guichangepw)
										ExitLoop
										Else
										MsgBox(0,"Error", "Password does not match. Please try again.")
										EndIf
									Case $msg = $cancel
										GUIDelete($guichangepw)
										ExitLoop
								EndSelect
							WEnd	
					EndIf
				Case $msg = $sluiten
					GUIDelete($guigebruikers)
					exitloop
				Case $msg = $deluser
					$msgbox = MsgBox(4, "Delete?", "Are you sure you want to delete user "&GUICtrlRead($userlist))
					If $msgbox = 6 Then
						Sleep(10)
						IniDelete("user.dat", GUICtrlRead($userlist))
						
						_GUICtrlListBox_BeginUpdate(GUICtrlGetHandle($userlist))
						_GUICtrlListBox_ResetContent(GUICtrlGetHandle($userlist))
						_GUICtrlListBox_EndUpdate(GUICtrlGetHandle($userlist))
						$var1 = IniReadSectionNames("user.dat")
						For $i = 1 To $var1[0]
							GUICtrlSetData($userlist, $var1[$i])
						Next
					EndIf
				Case $msg = $newuser
					new_user()
					_GUICtrlListBox_BeginUpdate(GUICtrlGetHandle($userlist))
					_GUICtrlListBox_ResetContent(GUICtrlGetHandle($userlist))
					_GUICtrlListBox_EndUpdate(GUICtrlGetHandle($userlist))
					$var1 = IniReadSectionNames("user.dat")
					For $i = 1 To $var1[0]
						GUICtrlSetData($userlist, $var1[$i])
					Next
				EndSelect
		WEnd
EndFunc

Func new_user()
	
	$guinewuser = GUICreate("New user", 340, 250)
	Opt("GUICoordMode", 2)
	                GUICtrlCreateLabel("Username:", 10, 20, 160, 20)
	$newuserfield = GUICtrlCreateInput("", 1, -20, 160, 20)
	                GUICtrlCreateLabel("Password:", -321, 20, 160, 20)
	$newpwfield   = GUICtrlCreateInput("", 1, -20, 160, 20, $ES_PASSWORD)
					GUICtrlCreateLabel("First name:", -321, 20, 160, 20)
	$newvoornaam  = GUICtrlCreateInput("", 1, -20, 160, 20)
					GUICtrlCreateLabel("Last name:", -321, 20, 160, 20)
	$newachternaam= GUICtrlCreateInput("", 1, -20, 160, 20)
					GUICtrlCreateLabel("Email adress:", -321, 20, 160, 20)
	$newemail	  = GUICtrlCreateInput("", 1, -20, 160, 20)
	$ok           = GUICtrlCreateButton("Ok", -320, 20, 140, 20)
	$cancel       = GUICtrlCreateButton("Cancel", 40, -20)

	GUISetState()
	While 1
			$msg = GUIGetMsg()
			Select
				Case $msg = $GUI_EVENT_CLOSE
					GUIDelete($guinewuser)
					ExitLoop
				Case $msg = $ok
					IniWrite("user.dat", GUICtrlRead($newuserfield), "pass", _StringEncrypt(1, GUICtrlRead($newpwfield), "admin", 1))
					IniWrite("user.dat", GUICtrlRead($newuserfield), "voornaam", GUICtrlRead($newvoornaam))
					IniWrite("user.dat", GUICtrlRead($newuserfield), "achternaam", GUICtrlRead($newachternaam))
					IniWrite("user.dat", GUICtrlRead($newuserfield), "email", GUICtrlRead($newemail))
					GUIDelete($guinewuser)
					ExitLoop
				Case $msg = $cancel
					GUIDelete($guinewuser)
					ExitLoop
			EndSelect
		WEnd


EndFunc

Func settings()
		
	$guisettings = GUICreate("Settings", 350, 100)
	Opt("GUICoordMode", 2)
	                GUICtrlCreateLabel("SMTP Server:", 10, 20, 160, 20)
	$smtpserver   = GUICtrlCreateInput("", 1, -20, 160, 20)
	$ok           = GUICtrlCreateButton("Ok", -320, 20, 140, 20)
	$cancel       = GUICtrlCreateButton("Cancel", 40, -20)

	If FileExists("settings.ini") Then GUICtrlSetData($smtpserver, IniRead("settings.ini", "settings", "smtp-server", ""))


	GUISetState()
	While 1
			$msg = GUIGetMsg()
			Select
				Case $msg = $GUI_EVENT_CLOSE
					GUIDelete($guisettings)
					ExitLoop
				Case $msg = $ok
					IniWrite("settings.ini", "settings", "smtp-server", GUICtrlRead($smtpserver))
					MsgBox(0, "Info", "Settings saved.")
					GUIDelete($guisettings)
					ExitLoop
				Case $msg = $cancel
					GUIDelete($guisettings)
					ExitLoop
			EndSelect
		WEnd

EndFunc