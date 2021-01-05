Func MyStatus()
	
	
	;    	MISTATUS_UNKNOWN = 0x0000,
	;    	MISTATUS_OFFLINE = 0x0001,
	;    	MISTATUS_ONLINE = 0x0002,
	;    	MISTATUS_INVISIBLE = 0x0006,
	;    	MISTATUS_BUSY = 0x000A,
	;    	MISTATUS_BE_RIGHT_BACK = 0x000E,
	;    	MISTATUS_IDLE = 0x0012,
	;    	MISTATUS_AWAY = 0x0022,
	;    	MISTATUS_ON_THE_PHONE = 0x0032,
	;    	MISTATUS_OUT_TO_LUNCH = 0x0042,
	;    	MISTATUS_LOCAL_FINDING_SERVER = 0x0100,
	;    	MISTATUS_LOCAL_CONNECTING_TO_SERVER = 0x0200,
	;    	MISTATUS_LOCAL_SYNCHRONIZING_WITH_SERVER = 0x0300,
	;    	MISTATUS_LOCAL_DISCONNECTING_FROM_SERVER = 0x0400,
	
	Local $o_Messenger = ObjCreate ("Messenger.UIAutomation.1")
	If @error Then
		SetError(-1)
		Return 0
	EndIf
	
	Return $o_Messenger.MyStatus ()
	
EndFunc   ;==>MyStatus


Func AddContact($s_email)
	
	; Opens Add contact wizard, $s_email is the person you want to add
	Local $o_Messenger = ObjCreate ("Messenger.UIAutomation.1")
	If @error Then
		SetError(-1)
		Return 0
	EndIf
	
	Return $o_Messenger.AddContact (0, $s_email)
	
EndFunc   ;==>AddContact


Func InstantMessage($s_email)
	
	; Open an message window to $s_email
	Local $o_Messenger = ObjCreate ("Messenger.UIAutomation.1")
	If @error Then
		SetError(-1)
		Return 0
	EndIf
	
	Return $o_Messenger.InstantMessage ($s_email)
	
EndFunc   ;==>InstantMessage

Func SendMail($s_email)
	
	; Open an email window to $s_email
	Local $o_Messenger = ObjCreate ("Messenger.UIAutomation.1")
	If @error Then
		SetError(-1)
		Return 0
	EndIf
	
	Return $o_Messenger.SendMail ($s_email)
	
EndFunc   ;==>SendMail

Func OpenInbox()
	
	; Open the Inbox off the current account
	Local $o_Messenger = ObjCreate ("Messenger.UIAutomation.1")
	If @error Then
		SetError(-1)
		Return 0
	EndIf
	
	Return $o_Messenger.OpenInbox ()
	
EndFunc   ;==>OpenInbox

Func SignOut()
	
	; Sign out of messenger
	Local $o_Messenger = ObjCreate ("Messenger.UIAutomation.1")
	If @error Then
		SetError(-1)
		Return 0
	EndIf
	
	Return $o_Messenger.SignOut ()
	
EndFunc   ;==>SignOut

Func SignIn($s_email)
	
	; Goto the Signin screen
	Local $o_Messenger = ObjCreate ("Messenger.UIAutomation.1")
	If @error Then
		SetError(-1)
		Return 0
	EndIf
	
	Return $o_Messenger.SignIn (0, $s_email, '')
	
EndFunc   ;==>SignIn

Func SendFile($s_email, $s_file)
	
	; Goto the SendFile screen
	Local $o_Messenger = ObjCreate ("Messenger.UIAutomation.1")
	If @error Then
		SetError(-1)
		Return 0
	EndIf
	
	Return $o_Messenger.SendFile ($s_email, $s_file)
	
EndFunc   ;==>SendFile

Func OffSets()
	
	; Get offsets
	Local $o_Messenger = ObjCreate ("Messenger.UIAutomation.1")
	If @error Then
		SetError(-1)
		Return 0
	EndIf
	
	Local $o_MesWindow = $o_Messenger.Window ()
	Local $a_array[4]
	$a_array[0] = $o_MesWindow.Top ()
	$a_array[1] = $o_MesWindow.left ()
	$a_array[2] = $o_MesWindow.Height ()
	$a_array[3] = $o_MesWindow.Width ()
	Return $a_array
	
EndFunc   ;==>OffSets

Func ServiceName()
	
	; Get your current service name
	Local $o_Messenger = ObjCreate ("Messenger.UIAutomation.1")
	If @error Then
		SetError(-1)
		Return 0
	EndIf
	
	Local $o_Services = $o_Messenger.Services ()
	Local $o_Primserv = $o_Services.PrimaryService ()
	Return $o_Primserv.ServiceName ()
	
EndFunc   ;==>ServiceName

Func MySigninName()
	
	; Get your current Email
	Local $o_Messenger = ObjCreate ("Messenger.UIAutomation.1")
	If @error Then
		SetError(-1)
		Return 0
	EndIf
	
	Local $o_Services = $o_Messenger.Services ()
	Local $o_Primserv = $o_Services.PrimaryService ()
	Return $o_Primserv.MySigninName ()
	
EndFunc   ;==>MySigninName

Func MyFriendlyName()
	
	; Get your current name
	Local $o_Messenger = ObjCreate ("Messenger.UIAutomation.1")
	If @error Then
		SetError(-1)
		Return 0
	EndIf
	
	Local $o_Services = $o_Messenger.Services ()
	Local $o_Primserv = $o_Services.PrimaryService ()
	Return $o_Primserv.MyFriendlyName ()
	
EndFunc   ;==>MyFriendlyName

Func MyContacts()
	
	#cs
		Private Sub LoadContacts()
		Dim MsgrContacts As IMessengerContacts
		Dim MsgrContact As IMessengerContact
		Set MsgrContacts = objMessenger.MyContacts
		For Each MsgrContact In MsgrContacts
		List1.AddItem MsgrContact.SigninName
		Next
		End Sub
	#ce
	
	Local $o_Messenger = ObjCreate ("Messenger.UIAutomation.1")
	If @error Then
		SetError(-1)
		Return 0
	EndIf
	
	Local $o_MsgrContacts = $o_Messenger.MyContacts ()
	Local $s_PeopleString = ''
	Local $s_status = ''
	Local $s_FriendlyName = ''
	Local $s_Blocked = ''
	
	For $o_Messenger In $o_MsgrContacts
		$s_PeopleString &= ';' & $o_Messenger.SigninName
		$s_status &= ';' & $o_Messenger.Status
		$s_FriendlyName &= ';' & $o_Messenger.FriendlyName
		$s_Blocked &= ';' & $o_Messenger.Blocked
	Next
	
	If StringLeft($s_PeopleString, 1) = ';' Then $s_PeopleString = StringTrimLeft($s_PeopleString, 1)
	If StringLeft($s_status, 1) 	  = ';' Then $s_status 		 = StringTrimLeft($s_status, 1)
	If StringLeft($s_FriendlyName, 1) = ';' Then $s_FriendlyName = StringTrimLeft($s_FriendlyName, 1)
	If StringLeft($s_Blocked, 1) 	  = ';' Then $s_Blocked 	 = StringTrimLeft($s_Blocked, 1)		

	
	$s_PeopleString = StringSplit($s_PeopleString, ';')
	$s_status = StringSplit($s_status, ';')
	$s_FriendlyName = StringSplit($s_FriendlyName, ';')
	$s_Blocked = StringSplit($s_Blocked, ';')
	
	Local $a_ret[$s_PeopleString[0]][4]
	
	$a_ret[0][0] = $s_PeopleString[0]
	$a_ret[0][1] = $s_PeopleString[0]
	$a_ret[0][2] = $s_PeopleString[0]
	$a_ret[0][3] = $s_PeopleString[0]
	
	For $i = 1 To $s_PeopleString[0]-1
		$a_ret[$i][0] = $s_PeopleString[$i]
		$a_ret[$i][1] = $s_FriendlyName[$i]
		$a_ret[$i][2] = $s_status[$i]
		$a_ret[$i][3] = $s_Blocked[$i]
	Next
	
	return $a_ret
	
EndFunc   ;==>MyContacts

Func IsSelf($s_email)
	
	Local $o_Messenger = ObjCreate("Messenger.UIAutomation.1")
	If @error Then
		SetError(-1)
		Return 0
	EndIf

	If $s_email = MySigninName() Then Return 1
	Return 0
EndFunc


$test = MyContacts()
for $i = 1 To $test[0][0]-1
	ConsoleWrite('email: ' & $test[$i][0] & @lf)
	ConsoleWrite('name: ' & $test[$i][1] & @lf)
	ConsoleWrite('status: ' & $test[$i][2] & @lf)
	ConsoleWrite('blocked: ' & $test[$i][3] & @lf & @lf)
Next
	