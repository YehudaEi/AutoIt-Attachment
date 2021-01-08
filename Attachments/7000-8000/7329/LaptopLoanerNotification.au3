; ----------------------------------------------------------------------------
; LaptopLoanerNotification.au3
; AutoIt Version: 3.1.1 - 3/1/06
; Author:          Sage
;
; Script Function:
;	Laptop Loaner Checkout Email Notification 
;   Requirements: Compile with Beta release
;
; ----------------------------------------------------------------------------

;Include statements
#include <INet.au3>
#include <GUIConstants.au3>
#include <file.au3>
#include <Date.au3>

; Checks for existence of image file and if not found installs it. Replace with any graphic file you wish.
If FileExists(@WorkingDir &"\Blue hills.gif") Then
    ; Do nothing and continue
Else
	FileInstall("C:\Program Files\AutoIt3\Source Code\Blue hills.gif", @WorkingDir &"\Blue hills.gif") ;Image file
EndIf

; Checks for existence of data file and if not found installs it.
If FileExists(@WorkingDir &"\Lap-eMail.dat") Then
    ; Do nothing and continue
Else
	FileInstall("C:\Program Files\AutoIt3\Source Code\Lap-eMail.dat", @WorkingDir &"\Lap-eMail.dat") ;Image file
EndIf

; Read data file and put data into variables
$MailTo = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "mailto", "NotFound")
$Subject = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "subject", "NotFound")
$pickup = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "pickup", "NotFound")
$address = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "address", "NotFound")
$city = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "city", "NotFound")
$phone = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "phone", "NotFound")
$note = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "note", "NotFound")
$dept = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "dept", "NotFound")
$company = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "company", "NotFound")
$tagline = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "tagline", "NotFound")


; Input for checkout date; == GUI generated with Koda ==
$Form1 = GUICreate("e-Mail Notifier", 722, 448, 214, 125)
GUISetBkColor(0xC0DCC0)
GUICtrlCreateLabel("Laptop Loaner Request Auto-Email Notification ", 120, 24, 444, 28)
GUICtrlSetFont(-1, 14, 800, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xC0DCC0)
$Group1 = GUICtrlCreateGroup("", 32, 72, 545, 281)
GUICtrlSetBkColor(-1, 0xC0DCC0)
GUICtrlCreateLabel("User's email Address (i.e. John.Doe):", 48, 125, 378, 19)
GUICtrlSetFont(-1, 10, 800, 0, "Rockwell")
GUICtrlSetBkColor(-1, 0xC0DCC0)
GUICtrlCreateLabel("Checkout Date:", 48, 184, 132, 19)
GUICtrlSetFont(-1, 10, 800, 0, "Rockwell")
GUICtrlSetBkColor(-1, 0xC0DCC0)
GUICtrlCreateLabel("Return Date:", 64, 240, 132, 19)
GUICtrlSetFont(-1, 10, 800, 0, "Rockwell")
GUICtrlSetBkColor(-1, 0xC0DCC0)
$Requestor = GUICtrlCreateInput("", 358, 125, 249, 21, -1, $WS_EX_CLIENTEDGE) ; Input for user's email address
GUICtrlSetTip(-1, "Type in firstname . lastname only...")
$ChkoutDate = GUICtrlCreateDate(_NowDate(), 182, 184, 236, 21) ; Input for checkout date
$MonthCal1 = GUICtrlCreateMonthCal(_NowDate(), 450, 168, 240, 200 ) ; Calendar for reference only
GUICtrlSetTip(-1, "Reference calendar...")
$ReturnDate = GUICtrlCreateDate(_NowDate(), 182, 240, 236, 21) ; Input for return date
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Pic1 = GUICtrlCreatePic(@WorkingDir &"\Blue hills", 2, 2, 84, 68)
GUICtrlSetTip(-1, "Written by author") ;Type in program author
$Send = GUICtrlCreateButton("Send", 194, 410, 73, 25) ; Send email button
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Cancel = GUICtrlCreateButton("Cancel", 392, 410, 75, 25) ; Cancel button
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Edit = GUICtrlCreateButton("Edit Data", 235, 310, 85, 25, $BS_DEFPUSHBUTTON ) ; Send email button
GUICtrlSetTip(-1, "Click to edit deafult system data...")
GUICtrlSetFont(-1, 8, 800, 2, "MS Sans Serif")
GUISetState(@SW_SHOW)


While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE 
		ExitLoop
	Case $msg = $Cancel
		ExitLoop	
	Case $msg = $Edit
		Call("editor")	;Call editor function
	Case $msg = $Send
		$ChkoutDate = GUICtrlRead($ChkoutDate)
		$ReturnDate = GUICtrlRead($ReturnDate)
		$MailTo = GUICtrlRead($Requestor) & $MailTo
		$MailBody = "This is to confirm your service request for a loaner laptop for " & $ChkoutDate & " with a return date on " &  $ReturnDate & " is available." & " Your loaner laptop will be ready for pickup " & $pickup & ", " & $ChkoutDate &"." & @CRLF & @CRLF &  "Please reply to this email to schedule and confirm a pickup time with the Support Analyst handling your request." & @CRLF & @CRLF & @CRLF & $note  & @CRLF & @CRLF & @CRLF & $dept & @CRLF & $company & @CRLF & $address  & @CRLF & $city & @CRLF & $phone & @CRLF & $tagline 
		Opt('RunErrorsFatal', 0)
		$sSend_Mail = _INetMail($MailTo, $subject, $MailBody) ; Creates email based on default email installed
		
		_restart() ;Restarts the GUI interface
		
	EndSelect
WEnd
Exit


Func editor()
	; == GUI generated with Koda ==
	; Read data file and put data into variables
	$MailTo = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "mailto", "NotFound")
	$dept = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "dept", "NotFound")
	$company = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "company", "NotFound")
	$tagline = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "tagline", "NotFound")
	$Subject = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "subject", "NotFound")
	$pickup = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "pickup", "NotFound")
	$address = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "address", "NotFound")
	$city = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "city", "NotFound")
	$phone = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "phone", "NotFound")
	$note = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "note", "NotFound")
	
	$Editor = GUICreate("Laptop Loaner Notification System Editor", 734, 635, 192, 125, -1, BitOR($WS_EX_OVERLAPPEDWINDOW,$WS_EX_CLIENTEDGE))
	GUISetIcon(@WorkingDir &"\Blue hills.ico")
	GUISetFont(10, 400, 0, "MS Sans Serif")
	GUISetBkColor(0xA6CAF0)
	GUICtrlCreateLabel("Edit Data File Options", 194, 8, 260, 33)
	GUICtrlSetFont(-1, 18, 800, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0x000080)
	GUICtrlSetBkColor(-1, 0xA6CAF0)
	GUICtrlCreateLabel("Default e-Mail:", 24, 80, 130, 20)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	GUICtrlSetBkColor(-1, 0xA6CAF0)
	GUICtrlCreateLabel("Subject:", 24, 120, 130, 20)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	GUICtrlSetBkColor(-1, 0xA6CAF0)
	GUICtrlCreateLabel("Pickup Info:", 24, 160, 130, 20)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	
	GUICtrlSetBkColor(-1, 0xA6CAF0)
	GUICtrlCreateLabel("Department:", 24, 200, 130, 20)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	GUICtrlSetBkColor(-1, 0xA6CAF0)
	GUICtrlCreateLabel("Company:", 24, 240, 130, 20)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	GUICtrlSetBkColor(-1, 0xA6CAF0)
	GUICtrlCreateLabel("TagLine:", 24, 280, 130, 20)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	
	GUICtrlSetBkColor(-1, 0xA6CAF0)
	GUICtrlCreateLabel("Address:", 24, 320, 130, 20)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	GUICtrlSetBkColor(-1, 0xA6CAF0)
	GUICtrlCreateLabel("City:", 24, 362, 130, 20)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	GUICtrlSetBkColor(-1, 0xA6CAF0)
	GUICtrlCreateLabel("Phone:", 24, 402, 130, 20)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	GUICtrlSetBkColor(-1, 0xA6CAF0)
	GUICtrlCreateLabel("Note Field:", 24, 444, 130, 20)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	GUICtrlSetBkColor(-1, 0xA6CAF0)
	$umailto = GUICtrlCreateInput($mailto, 180, 80, 217, 24, -1, $WS_EX_CLIENTEDGE)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	$usubject = GUICtrlCreateInput($subject, 180, 120, 505, 24, -1, $WS_EX_CLIENTEDGE)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	$upickup = GUICtrlCreateInput($pickup, 180, 160, 505, 24, -1, $WS_EX_CLIENTEDGE)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	$udept = GUICtrlCreateInput($dept, 180, 200, 505, 24, -1, $WS_EX_CLIENTEDGE)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	$ucompany = GUICtrlCreateInput($company, 180, 240, 505, 24, -1, $WS_EX_CLIENTEDGE)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	$utagline = GUICtrlCreateInput($tagline, 180, 280, 505, 24, -1, $WS_EX_CLIENTEDGE)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	$uaddress = GUICtrlCreateInput($address, 180, 320, 329, 24, -1, $WS_EX_CLIENTEDGE)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	$ucity = GUICtrlCreateInput($city, 180, 362, 329, 24, -1, $WS_EX_CLIENTEDGE)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	$uphone = GUICtrlCreateInput($phone, 180, 402, 265, 24, -1, $WS_EX_CLIENTEDGE)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	$unote = GUICtrlCreateEdit($note, 180, 444, 441, 105, -1, $WS_EX_CLIENTEDGE)
	GUICtrlSetData(-1, $note)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	$Save = GUICtrlCreateButton("Save", 216, 596, 75, 25)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	$Quit = GUICtrlCreateButton("Cancel", 392, 596, 75, 25)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	
	
	GUISetState(@SW_SHOW)
	
	While 1
		$msg = GuiGetMsg()
		Select
		Case $msg = $GUI_EVENT_CLOSE
			GUIDelete()
			ExitLoop
		Case $msg = $Quit
			GUIDelete()
			ExitLoop
		Case $msg = $Save
			;Read data and save to variables
			$uMailto = GUICtrlRead($uMailto)
			$uSubject = GUICtrlRead($uSubject)
			$uPickup = GUICtrlRead($uPickup)
			$uAddress = GUICtrlRead($uAddress)
			$uCity = GUICtrlRead($uCity)
			$uPhone = GUICtrlRead($uPhone)
			$uNote = GUICtrlRead($uNote)
			$uDept = GUICtrlRead($uDept)
			$uCompany = GUICtrlRead($uCompany)
			$uTagline = GUICtrlRead($uTagline)
			
			
			;Write data to Lap-eMail.dat file
			IniWrite(@WorkingDir &"\Lap-eMail.dat", "Main", "mailto", $uMailto)
			IniWrite(@WorkingDir &"\Lap-eMail.dat", "Main", "subject", $uSubject)
			IniWrite(@WorkingDir &"\Lap-eMail.dat", "Main", "pickup", $uPickup)
			IniWrite(@WorkingDir &"\Lap-eMail.dat", "Main", "address", $uAddress)
			IniWrite(@WorkingDir &"\Lap-eMail.dat", "Main", "city", $uCity)
			IniWrite(@WorkingDir &"\Lap-eMail.dat", "Main", "phone", $uPhone)
			IniWrite(@WorkingDir &"\Lap-eMail.dat", "Main", "note", $uNote)
			IniWrite(@WorkingDir &"\Lap-eMail.dat", "Main", "dept", $uDept)
			IniWrite(@WorkingDir &"\Lap-eMail.dat", "Main", "company", $uCompany)
			IniWrite(@WorkingDir &"\Lap-eMail.dat", "Main", "tagline", $uTagline)
			
			
			#Region --- CodeWizard generated code Start ---
			;SpashText features: Title=No, Text=Yes, Width=250, Height=75, Center justified text, Fontname=Engravers MT, Font size=10, Font weight=700
			SplashTextOn("",@CRLF & "File Updated...","250","75","-1","-1",3,"Engravers MT","10","700")
			#EndRegion --- CodeWizard generated code End ---
			Sleep(3000)
			SplashOff()
			; Refresh variables
			$MailTo = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "mailto", "NotFound")
			$Subject = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "subject", "NotFound")
			$pickup = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "pickup", "NotFound")
			$address = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "address", "NotFound")
			$city = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "city", "NotFound")
			$phone = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "phone", "NotFound")
			$note = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "note", "NotFound")
			$dept = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "dept", "NotFound")
			$company = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "company", "NotFound")
			$tagline = IniRead(@WorkingDir &"\Lap-eMail.dat", "Main", "tagline", "NotFound")

			GUIDelete()
			ExitLoop
		EndSelect
	WEnd
	

EndFunc

Func _restart()
    If @Compiled = 1 Then
		GUIDelete()
        Run( FileGetShortName(@ScriptFullPath))
    Else
		GUIDelete()
        Run( FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
    EndIf
    Exit
EndFunc