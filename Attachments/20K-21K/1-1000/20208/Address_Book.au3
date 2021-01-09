#include <GUIConstants.au3> ;Include; simple, yet effective
#include <GuiComboBox.au3> ; ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

;Lets go ahead and declare some variables for later
$a = 1
$Clear = 0
$disabled = "NO"
$line=1
$loop=1
$pline = ""
$Start = 0


;Set an escape key just incase the BIG RED X doesn't work
HotKeySet("{Esc}", "_end")

;Let's make those god forsaken GUI's
GUICreate("Address Book",600, 400)
$combo = GUICtrlCreateCombo( "Add New Contact", 10,10, 200)
$label1 = GUICtrlCreateLabel( "Name -> ", 10,40)
$name = GUICtrlCreateInput( "", 54, 40, 130)
$label2 = GUICtrlCreateLabel( "Address -> ", 10, 70)
$address = GUICtrlCreateInput( "", 64, 70, 300)
$label3 = GUICtrlCreateLabel( "Home Phone -> ", 10, 100)
$phone = GUICtrlCreateInput( "", 100, 100, 100)
$label4 = GUICtrlCreateLabel( "Other Phone -> ", 10, 130)
$phone2 = GUICtrlCreateInput( "", 100, 130, 100)
$label5 = GUICtrlCreateLabel( "Email -> ", 10, 160)
$email = GUICtrlCreateInput( "", 60, 160, 250)
$store = GUICtrlCreateButton("Store / Save", 400, 350, 175)
$DeleteUser = GUICtrlCreateButton( "Delete Contact", 400, 315)
GUISetState()

;See if the person has any contacts
If FileExists("People.txt") Then
	FileOpen( "People.txt", 0)
	Opencontacts() ;Run the function to open the contacts
EndIf

;Lets start on all the fun, lovely code to get these gears grinding
While GUIGetMsg() <> $GUI_EVENT_CLOSE ;Just to make sure your not trying to close the program :)
	$selection = _GUICtrlComboBox_GetCurSel($combo) ;Lets see what they have selected
	Select
		Case $selection = 0 ;They have selected to make a new user (Next release there will be a button!!)
			ResetBlank()
			GUICtrlSetState($DeleteUser, $GUI_DISABLE) ;What will they delete when making a new user??
			$disabled = "YES" ;CTRL is disabled
			While $loop = 1 ;Wait until they have hit store or done something else
				$msg = GUIGetMsg()
				Select
					Case $msg=$store ;They hit the store button
						$loop = 0
						$nameconverted = GUICtrlRead($name)
						$addressconverted = GUICtrlRead($address)
						$phoneconverted = GUICtrlRead($phone)
						$phone2converted = GUICtrlRead($phone2)
						$emailconverted = GUICtrlRead($email)
						StoreUser()
					Case $msg=$GUI_EVENT_CLOSE
						Exit
					Case _GUICtrlComboBox_GetCurSel($combo) <> 0
						$loop = 0
				EndSelect
			WEnd
		Case $selection <> 0 ;Lets get that information from that dang .TXT (soon might incoorperate My SQL, if I can learn it)
			If $disabled = "YES" Then ;Make sure the delete button is'nt already enabled/disabled!
				GUICtrlSetState( $DeleteUser, $GUI_ENABLE) ;Make sure that you can delete a user
				$disabled = "NO" ;Lets enable this baby!
			EndIf
			GUICtrlSetData($name, FileReadLine("People.txt", (_GUICtrlComboBox_GetCurSel($combo) * 5 - 4)))
			GUICtrlSetData($address, FileReadLine("People.txt", (_GUICtrlComboBox_GetCurSel($combo) * 5 - 3)))
			GUICtrlSetData($phone, FileReadLine("People.txt", (_GUICtrlComboBox_GetCurSel($combo) * 5 - 2)))
			GUICtrlSetData($phone2, FileReadLine("People.txt", (_GUICtrlComboBox_GetCurSel($combo) * 5 - 1)))
			GUICtrlSetData($email, FileReadLine("People.txt", (_GUICtrlComboBox_GetCurSel($combo) * 5)))
			$oldselection = _GUICtrlComboBox_GetCurSel($combo) ;Store selection
			GUISetState()
			While $loop = 0
				CheckStatus()
			WEnd
	EndSelect
Wend

Func CheckStatus() ;Lets see if anything new is happenin'
	If _GUICtrlComboBox_GetCurSel($combo) <> $oldselection Then ;If the selection has changed then update. Sometimes doesn't work
		GUICtrlSetData($name, FileReadLine("People.txt", (_GUICtrlComboBox_GetCurSel($combo) * 5 - 4)))
		GUICtrlSetData($address, FileReadLine("People.txt", (_GUICtrlComboBox_GetCurSel($combo) * 5 - 3)))
		GUICtrlSetData($phone, FileReadLine("People.txt", (_GUICtrlComboBox_GetCurSel($combo) * 5 - 2)))
		GUICtrlSetData($phone2, FileReadLine("People.txt", (_GUICtrlComboBox_GetCurSel($combo) * 5 - 1)))
		GUICtrlSetData($email, FileReadLine("People.txt", (_GUICtrlComboBox_GetCurSel($combo) * 5)))
	EndIf
	$msg2 = GUIGetMsg()
	If _GUICtrlComboBox_GetCurSel($combo) = 0 Then $loop = 1
	Select
		Case $msg2 = $DeleteUser ;They hit the delete contact button
			DeleteUser() ;Run the function to delete the contact (AKA USER)
		Case $msg2 = $GUI_EVENT_CLOSE
			Exit
	EndSelect
EndFunc ;One down, a few more to go!

Func Opencontacts() ;Lets go ahead and see who you got in your book
	While $a = 1
		$pline = FileReadLine("People.txt", $line) ;Read only the lines that have names in them
		If @error = -1 Then ;If this is done REALLY fast, get some more friends or talk to your family
			$a = 0
			ExitLoop
		EndIf
		$line = $line + 5 ;Go to the next line with a name in it
		GUICtrlSetData( $combo, $pline) ;Make a new combo selection to see who you have!
	WEnd
EndFunc ;Finally, lets continue, shall we?

Func DeleteUser() ;Awww who did you just get in a fight with?
	$delete = MsgBox(4, "Delete User", "Are you sure you want to delete "& FileReadLine("People.txt", (_GUICtrlComboBox_GetCurSel($combo) * 5 - 4)) & "?") ;Did you accidently hit the button?
	If $delete = 6 Then ;Oh no! You really are mad at that person!
		MsgBox(0,"","Haha just kidding, this was just a test delete!") ;Not done with delete code, will be in next release!
	EndIf
EndFunc ;Yay the functions over! ON TO THE NEXT ONE!!

Func ResetBlank() ;This resets the input box to blanks!
	GUICtrlSetData($name, "")    ;Seems pointless, but if I don't screws up the program
	GUICtrlSetData($address, "") ;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	GUICtrlSetData($phone, "")   ;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	GUICtrlSetData($phone2, "")  ;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	GUICtrlSetData($email, "")   ;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
EndFunc

Func StoreUser() ;You just added someone new! You are loved by someone!
	If $nameconverted = "" Then ;Lets make sure you have at least a name typed in!
		MsgBox(0, "Error", "You must type a name!") ;Haha caught you!
	Else ;Whew you were smart enough to type a name!
		If $a <> 0 Then FileClose("People.txt") ;Aww crap, not the right mode!
		$file = Fileopen("People.txt", 1) ;Yayyy right mode!
		FileWriteLine("People.txt", $nameconverted)
		FileWriteLine("People.txt", $addressconverted)
		FileWriteline("People.txt", $phoneconverted)
		FileWriteLine("People.txt", $phone2converted)
		FileWriteLine("People.txt", $emailconverted & @CRLF)
		FileClose("People.txt") ;Lets stop writing and start reading again!
		FileOpen("People.txt", 0) ;Reading is boring!
		$a = 1
		$loop = 1
		GUICtrlDelete($combo) ;Lets delete that old book!
		$combo = GUICtrlCreateCombo( "Add New Contact", 10,10, 200) ;Yay we made a new one, so there is'nt so much re-writing going on
		ResetBlank()
		UpdateUser()
		GUISetState() ;Just to make sure we have everything drawn
	EndIf
EndFunc ;Done!

Func UpdateUser() ;Yayyy update!
	$line = 1
	While $a = 1
		$pline = FileReadLine("People.txt", $line) ;Read only the lines that have names in them
		If @error = -1 Then ;If this is done REALLY fast, get some more friends or talk to your family
			$a = 0
			ExitLoop
		EndIf
		$line = $line + 5 ;Go to the next line with a name in it
		GUICtrlSetData( $combo, $pline) ;Make a new combo selection to see who you have!
	WEnd
	$a = 1
EndFunc

Func _end() ;Escape function
	Exit
EndFunc ;Aww dang you escaped