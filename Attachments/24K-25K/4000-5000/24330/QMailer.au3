#include <File.au3>
#include <GuiComboBox.au3>
#include <WindowsConstants.au3>
#include <GuiConstantsEx.au3>
#include <String.au3>
#include <Array.au3>
#include <ListviewConstants.au3>
#include <EditConstants.au3>

If @UserName = "DiegoHernandez" Then
	HotKeySet("{ESC}", "Terminate") ;for testing purposes
EndIf

Func Terminate()
	Exit
EndFunc   ;==>Terminate

Global $settings_ini = @ScriptDir & "\settings.ini"

Global $SmtpServer = IniRead($settings_ini, "EMAIL", "SmtpServer", "NeverRunBefore")
Global $FromName = IniRead($settings_ini, "EMAIL", "FromName", "NeverRunBefore")
Global $FromAddress = IniRead($settings_ini, "EMAIL", "FromAddress", "NeverRunBefore")
Global $Username = IniRead($settings_ini, "EMAIL", "UserName", "NeverRunBefore")
Global $Password = IniRead($settings_ini, "EMAIL", "Password", "NeverRunBefore")
Global $IPPort = IniRead($settings_ini, "EMAIL", "IPPort", "NeverRunBefore")
Global $ssl = IniRead($settings_ini, "EMAIL", "SSL", "NeverRunBefore")

Global $force = True

If $SmtpServer = "NeverRunBefore" Or $FromName = "NeverRunBefore" Or $FromAddress = "NeverRunBefore" Or $Username = "NeverRunBefore" Or $Password = "NeverRunBefore" Or $IPPort = "NeverRunBefore" Or $ssl = "NeverRunBefore" Then
	Call("SetSettings")
EndIf

#Region addition

$folder = IniRead($settings_ini, "MAIN", "Folder", "NeverRunBefore")
;msgBox (0, "", $folder)
If $folder = "NeverRunBefore" Then
	Do
		$folder = InputBox("Enter Thunderbird folder.", "Enter the absolute path to your Thunderbird folder (in the Application Data folder). If it is different than the one given below, please type it below.", @AppDataDir & "\Thunderbird\")
		If Not FileExists($folder) Then MsgBox(64, "Message", "Path does not exist. Remember to type absolute path.")
	Until FileExists($folder)
	$inistat = IniWrite($settings_ini, "MAIN", "Folder", $folder)
	If $inistat = 0 Then
		MsgBox(48, "Fatal Error!", "Error writing to .ini file. Make sure that " & $settings_ini & " is not" & @CRLF & "read-only. For questions, contact the programmer.")
		Exit
	EndIf
EndIf

If StringRight($folder, 1) <> "\" Then $folder = $folder & "\"
$chose_user = False

$user = IniRead($settings_ini, "MAIN", "Profile", "NeverRunBefore")
If $user = "NeverRunBefore" Or FileExists($folder & "Profiles\" & $user) = 0 Then
	$chose_user = True
	$user_choose_gui = GUICreate("Choose Thunderbird user to use", 300, 210)
	GUICtrlCreateLabel("Choose which Thunderbird user to use with this program." & @CRLF & "User names come from folder specified.", 10, 13)
	$user_listview = GUICtrlCreateListView("Choose which Thunderbird user to use", 10, 50, 280, 115, $LVS_REPORT + $LVS_SORTASCENDING + $LVS_NOCOLUMNHEADER)
	$profile_array = _FileListToArray($folder & "Profiles\")
	;msgBox (0, "", $folder)
	If @error Then
		MsgBox(48, "Fatal Error!", "_FileListToArray returned @error of " & @error & ". Please report. Read readme file for contact info.")
		Exit
	EndIf
	For $alpha = 1 To UBound($profile_array) - 1
		GUICtrlCreateListViewItem($profile_array[$alpha], $user_listview)
	Next
	$continue_button = GUICtrlCreateButton("Continue", 10, 173, 58)
	GUISetState()
	While 1
		$msg = GUIGetMsg()
		If $msg = $GUI_EVENT_CLOSE Then Exit
		If $msg = $continue_button And GUICtrlRead(GUICtrlRead($user_listview)) <> "" Then
			$user = GUICtrlRead(GUICtrlRead($user_listview))
			If StringRight($user, 1) = "|" Then $user = StringTrimRight($user, 1)
			IniWrite($settings_ini, "MAIN", "Profile", $user)
			ExitLoop
		EndIf
	WEnd
EndIf

$folder = $folder & "Profiles\" & $user ;may or may not have trailing backslash, so add one if it needs one

If StringRight($folder, 1) <> "\" Then $folder = $folder & "\"
;MsgBox (0, "", $folder)

If FileExists($folder) = 0 Then
	MsgBox(48, "Fatal Error!", "Specified Thunderbird folder and/or user do not exist. Please report. Read readme file for contact info." & @CRLF & "$folder is: " & $folder)
	IniWrite($settings_ini, "MAIN", "Folder", "NeverRunBefore")
	IniWrite($settings_ini, "MAIN", "Profile", "NeverRunBefore")
	Exit
Else
	If $chose_user = True Then GUIDelete($user_choose_gui)
EndIf

;"C:\Documents and Settings\@Username\Application Data\Thunderbird\Profiles\p4gqojrt.default\"

$list = ""
$t = FileFindFirstFile($folder & "abook*.mab")
If $t = -1 Then
	MsgBox(48, "Fatal Error!", "FileFindFirstFile returned -1. Check $folder." & @CRLF & "$folder is: " & $folder)
	Exit
EndIf

While 1
	$temp = FileFindNextFile($t)
	If @error Then ExitLoop
	$list = StringFormat("%s|%s", $list, $temp)
WEnd

If StringLeft($list, 1) = "|" Then $list = StringTrimLeft($list, 1)
$array_files = StringSplit($list, "|")
;_Arraydisplay ($array_files)

$con_a = ExtractThunderbirdAddressBook($array_files[1], $folder)
$con_b = ExtractThunderbirdAddressBook($array_files[2], $folder)
ConcatenateTwoDimArrays($con_a, $con_b) ;$con_a now contains $con_b
$con_b = 0

For $x = 1 To $array_files[0] - 2
	$con_b = ExtractThunderbirdAddressBook($array_files[$x + 2], $folder)
	ConcatenateTwoDimArrays($con_a, $con_b)
Next ;$con_a is the array you want to display

$con_b = 0 ;clear memory. Ooh, clever!

Func ExtractThunderbirdAddressBook($filename, $folder = "C:\Documents and Settings\DiegoHernandez\Application Data\Thunderbird\Profiles\p4gqojrt.default\")

	If StringRight($folder, 1) <> "\" Then
		$folder = $folder & "\"
	EndIf ;make trailing backslash if necessary

	$hnd = FileOpen($folder & $filename, 0)
	$text = FileRead($hnd)
	$array = _StringBetween($text, "(", ")")
	$error = @error
	If Not IsArray($array) Then
		MsgBox(48, "Fatal Error!", "_StringBetween in ExtractThunderbirdAddressBook returned False IsArray." & @CRLF & "@error is: " & $error)
		Exit
	EndIf

	$address_index_list = ""

	$i = 1
	For $i = 1 To UBound($array) - 1
		If StringInStr($array[$i], "@") > 0 Then $address_index_list = StringFormat("%s|%s", $address_index_list, $i)
	Next
	If StringLeft($address_index_list, 1) = "|" Then $address_index_list = StringTrimLeft($address_index_list, 1)

	$address_index_array = StringSplit($address_index_list, "|")

	$names_index_array = $address_index_array
	$j = 1
	For $j = 1 To UBound($names_index_array) - 1
		$names_index_array[$j] = $names_index_array[$j] - 1
		If StringInStr($array[$names_index_array[$j]], "@") > 0 Then
			$names_index_array[$j] = $names_index_array[$j] - 1
		EndIf ; "additional email" is listed right after the primary email. So subtract two instead of one.
	Next

	Local $address_array[$address_index_array[0] + 1]
	$k = 1
	For $k = 1 To UBound($address_index_array) - 1
		$address_array[$k] = $array[$address_index_array[$k]] & "ASDF"
	Next

	$l = 1
	For $l = 1 To UBound($address_array) - 1
		$temp = _StringBetween($address_array[$l], "=", "ASDF", 0)
		$address_array[$l] = $temp[0]
		$temp = 0
	Next ; now we have all the addresses in an array

	;_ArrayDisplay ($address_array)

	Local $names_array[$names_index_array[0] + 1]
	$m = 1
	For $m = 1 To UBound($names_array) - 1
		$names_array[$m] = $array[$names_index_array[$m]] & "GHJK"
	Next

	$n = 1
	For $n = 1 To UBound($names_array) - 1
		$tempo = _StringBetween($names_array[$n], "=", "GHJK", 0)
		$names_array[$n] = $tempo[0]
		$tempo = 0
	Next ;now we have all the names in an array

	;_ArrayDisplay ($names_array)

	Local $result[UBound($names_array)][2]

	$o = 1
	For $o = 1 To UBound($names_array) - 1
		$result[$o][0] = $names_array[$o]
		$result[$o][1] = $address_array[$o]
	Next

	;_ArrayDisplay ($result)

	FileClose($hnd)
	Return ($result)

EndFunc   ;==>ExtractThunderbirdAddressBook

Func ConcatenateTwoDimArrays(ByRef $first_array, ByRef $second_array) ;the SECOND array is added onto the end of the FIRST array.
	Local $array[UBound($first_array) + UBound($second_array)][2]

	For $a = 1 To UBound($first_array) - 1
		$array[$a][0] = $first_array[$a][0]
		$array[$a][1] = $first_array[$a][1]
	Next

	For $b = 1 To UBound($second_array) - 1
		$array[$a + $b][0] = $second_array[$b][0]
		$array[$a + $b][1] = $second_array[$b][1]
	Next
	
	ReDim $first_array[UBound($first_array) + UBound($second_array)][2]
	$first_array = $array
	
	Return
EndFunc   ;==>ConcatenateTwoDimArrays

#EndRegion addition

$y = 1
Local $temp_array[UBound($con_a)]
For $y = 1 To UBound($con_a) - 1
	$temp_array[$y] = $con_a[$y][0] & "|" & $con_a[$y][1]
	;MsgBox (0, "", $temp_array[$y])
Next

$temp_2_array = _ArrayUnique($temp_array, 1, 1, 0, "|")
;_Arraydisplay ($temp_2_array)

Global $add_added_today[1][2]

;delete strange entries (i.e. blank entries and entries starting with numbers)
$z = 1
Do
	$add_one = True
	If $temp_2_array[$z] = "|" Then
		_ArrayDelete($temp_2_array, $z)
		;MsgBox (0, "Blank entry", "Deleted "&$temp_2_Array[$z])
		$add_one = False
	EndIf
	If Not Number(StringLeft($temp_2_array[$z], 1)) = 0 Then
		_ArrayDelete($temp_2_array, $z)
		;MsgBox (0, "Number beginning", "Deleted "&$temp_2_Array[$z])
		$add_one = False
	EndIf
	If $add_one = True Then
		$z = $z + 1
	EndIf
Until $z = UBound($temp_2_array)

$to_gui = GUICreate("Choose recipient", 300, 200)
$to_list = GUICtrlCreateListView("Name of recipient|E-Mail Address", 10, 10, 280, 155, $LVS_REPORT + $LVS_SORTASCENDING)
$continue_button = GUICtrlCreateButton("Continue", 10, 170, 58)
$custom_button = GUICtrlCreateButton("Other", 73, 170, 58)
$edit_settings_button = GUICtrlCreateButton("Settings", 136, 170, 58)
$edit_list_button = GUICtrlCreateButton("Edit list", 199, 170, 58)
GUISetState()

$force = False

Global $control_id_and_data[UBound($temp_2_array)][2]

$z = 1
For $z = 1 To UBound($temp_2_array) - 1
	$y = GUICtrlCreateListViewItem($temp_2_array[$z], $to_list)
	$control_id_and_data[$z][0] = $y
	$control_id_and_data[$z][1] = $temp_2_array[$z] & "|"
	;MsgBox (0, "", $temp_array[$z])
Next

;custom add from ADD list

$custom_add_array = IniReadSection($settings_ini, "ADD")
If IsArray ($custom_add_array) Then
Global $additions_from_settings_ini[$custom_add_array[0][0] + 1][2]
For $h = 1 To UBound($custom_add_array) - 1
	$additions_from_settings_ini[$h][0] = GUICtrlCreateListViewItem($custom_add_array[$h][1], $to_list)
	$additions_from_settings_ini[$h][1] = $custom_add_array[$h][1] & "|"
Next
EndIf

$custom = False
$continue = False
$err = False
$activate = False

Do

	Do

		Do

			Do

				GUISetState(@SW_ENABLE, $to_gui)
				If $activate = True Then WinActivate("Choose recipient")
				$activate = False

				While 1
					GUISetState(@SW_ENABLE, $to_gui)
					$msg = GUIGetMsg()
					If $msg = $continue_button Then
						;MsgBox (0, "", (GUICtrlRead($to_list)))
						If GUICtrlRead(GUICtrlRead($to_list)) <> "" Then ExitLoop
					EndIf
					If $msg = $GUI_EVENT_CLOSE Then Exit
					If $msg = $custom_button Then
						GUISetState(@SW_DISABLE, $to_gui)
						Dim $to[1]
						$to[0] = InputBox("Custom", "Enter address.")
						If Not @error Then
							$custom = True
							ExitLoop
						Else
							WinActivate("Choose recipient")
						EndIf
					EndIf
					If $msg = $edit_settings_button Then
						GUISetState(@SW_DISABLE, $to_gui)
						Call("SetSettings")
						WinActivate("Choose recipient")
						GUISetState(@SW_ENABLE, $to_gui)
					EndIf
					If $msg = $edit_list_button Then
						GUISetState(@SW_DISABLE, $to_gui)
						Call("EditList")
						WinActivate("Choose recipient")
						GUISetState(@SW_ENABLE, $to_gui)
					EndIf
				WEnd

				If $custom = False Then
					$to = GUICtrlRead(GUICtrlRead($to_list))
					;MsgBox (0, "", $to)
					$to = _StringBetween($to, "|", "|")
					If @error Then
						MsgBox(0, "Error", "No inbetween string found for that entry.")
						$continue = False
					Else
						$continue = True
					EndIf
				EndIf

			Until $continue = True Or $custom = True

			;GUIDelete($to_gui)
			GUISetState(@SW_DISABLE, $to_gui)

			$a_subject = InputBox("Enter subject", "Enter subject. Sending to " & $to[0])
			If @error Then
				$err = True
				$activate = True
			Else
				$err = False
			EndIf
		Until $err = False

		$a_body = InputBox("Sending to " & $to[0], "One line body. (Future versions will improve.) Sending to " & $to[0])
		If @error Then
			$err = True
			$activate = True
		Else
			$err = False
		EndIf
	Until $err = False

	If $CmdLine[0] = 1 Then
		$attachments = $CmdLine[1]
		MsgBox(64, "Attachment", "Attachment specified through command line or Send To: " & @CRLF & $attachments)
	Else
		$attachments = FileOpenDialog("Choose attachment", @MyDocumentsDir & "\Diego's Documents", "All (*.*)")
		If @error Then $attachments = ""
	EndIf

	$cont = MsgBox(4 + 64, "Send message?", "Press No to cancel.")
	If $cont <> 6 Then $activate = True
Until $cont = 6 ; "Yes" button

GUIDelete($to_gui)

Global $oMyRet[2]
Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")

_SendQuickMail($to[0], $a_subject, $a_body, $attachments)

; SMTP mail function written by Jos from the AutoIt forums. http://www.autoitscript.com/forum/index.php?showtopic=23860
; Minor editions have been made to accommodate the current program.

#region By Jos

Func _SendQuickMail($to, $a_subject, $a_body, $attachments) ;not by me, but modified to suit this script

	;$SmtpServer = "smtp.gmail.com"           ; address for the smtp-server to use - REQUIRED
	;$FromName =    				          ; name from who the email was sent
	;$FromAddress =  					      ; address from where the mail should come
	$ToAddress = $to 						  ; destination address of the email - REQUIRED
	$AttachFiles = $attachments
	$Subject = $a_subject
	$Body = $a_body
	$CcAddress = "" 						 ; address for cc - leave blank if not needed
	$BccAddress = "" 						 ; address for bcc - leave blank if not needed
	$Importance = "Normal" 					 ; Send message priority: "High", "Normal", "Low"
	;$Username = 				             ; username for the account used from where the mail gets sent - REQUIRED
	;$Password =                             ; password for the account used from where the mail gets sent - REQUIRED
	;$IPPort = 25                            ; port used for sending the mail
	;$ssl = 0                                ; enables/disables secure socket layer sending - put to 1 if using httpS
	;~ $IPPort=465                           ; GMAIL port used for sending the mail
	;~ $ssl=1                                ; GMAILenables/disables secure socket layer sending - put to 1 if using httpS

	$rc = _INetSmtpMailCom($SmtpServer, $FromName, $FromAddress, $ToAddress, $Subject, $Body, $AttachFiles, $CcAddress, $BccAddress, $Importance, $Username, $Password, $IPPort, $ssl)
	If $rc = 10 Then $rc = "Attachment file not found."
	If @error Then
		$error = @error
		TrayTip("Error sending message", "Error code:" & @error & @CRLF & "Description:" & $rc, 15)
		Return ($error)
	Else
		$date = StringFormat("%s:%s:%s", @HOUR, @MIN, @SEC)
		TrayTip("Message sent", "Message sent successfully on " & $date, 15)
	EndIf

	Return (0)

EndFunc   ;==>_SendQuickMail

Func _INetSmtpMailCom($s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress, $s_Subject = "", $as_Body = "", $s_AttachFiles = "", $s_CcAddress = "", $s_BccAddress = "", $s_Importance = "Normal", $s_Username = "", $s_Password = "", $IPPort = 25, $ssl = 0)
	Local $objEmail = ObjCreate("CDO.Message")
	$objEmail.From = '"' & $s_FromName & '" <' & $s_FromAddress & '>'
	$objEmail.To = $s_ToAddress
	Local $i_Error = 0
	Local $i_Error_desciption = ""
	If $s_CcAddress <> "" Then $objEmail.Cc = $s_CcAddress
	If $s_BccAddress <> "" Then $objEmail.Bcc = $s_BccAddress
	$objEmail.Subject = $s_Subject
	If StringInStr($as_Body, "<") And StringInStr($as_Body, ">") Then
		$objEmail.HTMLBody = $as_Body
	Else
		$objEmail.Textbody = $as_Body & @CRLF
	EndIf
	If $s_AttachFiles <> "" Then
		Local $S_Files2Attach = StringSplit($s_AttachFiles, "|")
		For $x = 1 To $S_Files2Attach[0]
			$S_Files2Attach[$x] = _PathFull($S_Files2Attach[$x])
			ConsoleWrite('@@ Debug(62) : $S_Files2Attach = ' & $S_Files2Attach & @LF & '>Error code: ' & @error & @LF) ;### Debug Console
			If FileExists($S_Files2Attach[$x]) Then
				$objEmail.AddAttachment($S_Files2Attach[$x])
			Else
				ConsoleWrite('!> File not found to attach: ' & $S_Files2Attach[$x] & @LF)
				SetError(1)
				Return (10)
			EndIf
		Next
	EndIf
	$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
	$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = $s_SmtpServer
	If Number($IPPort) = 0 Then $IPPort = 25
	$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = $IPPort
	;Authenticated SMTP
	If $s_Username <> "" Then
		$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
		$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = $s_Username
		$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = $s_Password
	EndIf
	If $ssl Then
		$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True
	EndIf
	;Update settings
	$objEmail.Configuration.Fields.Update
	; Set Email Importance
	Switch $s_Importance
		Case "High"
			$objEmail.Fields.Item("urn:schemas:mailheader:Importance") = "High"
		Case "Normal"
			$objEmail.Fields.Item("urn:schemas:mailheader:Importance") = "Normal"
		Case "Low"
			$objEmail.Fields.Item("urn:schemas:mailheader:Importance") = "Low"
	EndSwitch
	$objEmail.Fields.Update
	; Sent the Message
	$objEmail.Send
	If @error Then
		SetError(2)
		Return $oMyRet[1]
	EndIf
	$objEmail = ""
EndFunc   ;==>_INetSmtpMailCom

; Com Error Handler
Func MyErrFunc()
	$HexNumber = Hex($oMyError.number, 8)
	$oMyRet[0] = $HexNumber
	$oMyRet[1] = StringStripWS($oMyError.description, 3)
	ConsoleWrite("### COM Error !  Number: " & $HexNumber & "   ScriptLine: " & $oMyError.scriptline & "   Description:" & $oMyRet[1] & @LF)
	SetError(1); something to check for when this function returns
	Return
EndFunc   ;==>MyErrFunc

#endregion By Jos

Func SetSettings()
	
	MsgBox(64, "Disclaimer", "This version saves your UNENCRYPTED password in an .ini file." & @CRLF & "Use at your own risk.")
	
	$smtp_settings = GUICreate("Set SMTP settings", 340, 225, 550, 150)
	$it = 10
	$smtp_server = GUICtrlCreateInput("", 10, $it, 120)
	GUICtrlCreateLabel("SMTP server (e.g. smtp.gmail.com)", 135, $it + 3)
	$from_name = GUICtrlCreateInput("", 10, $it + 25, 120)
	GUICtrlCreateLabel("Your name (e.g. John Smith)", 135, $it + 25 + 3)
	$from_address = GUICtrlCreateInput("", 10, $it + 50, 120)
	GUICtrlCreateLabel("Email address (e.g. j.smith@gmail.com)", 135, $it + 50 + 3)
	$user_name = GUICtrlCreateInput("", 10, $it + 75, 120)
	GUICtrlCreateLabel("Login name (e.g. j.smith)", 135, $it + 75 + 3)
	$pass_word = GUICtrlCreateInput("", 10, $it + 100, 120, Default, $ES_PASSWORD)
	GUICtrlCreateLabel("Your password", 135, $it + 100 + 3)
	$ip_port = GUICtrlCreateInput("", 10, $it + 125, 120)
	GUICtrlCreateLabel("IP port", 135, $it + 125 + 3)
	$s_sl = GUICtrlCreateCheckbox("Use SSL?", 10, $it + 150, 120)
	WinActivate("Choose recipient")
	GUISetState()

	If $SmtpServer <> "NeverRunBefore" Then GUICtrlSetData($smtp_server, $SmtpServer)
	If $FromName <> "NeverRunBefore" Then GUICtrlSetData($from_name, $FromName)
	If $FromAddress <> "NeverRunBefore" Then GUICtrlSetData($from_address, $FromAddress)
	If $Username <> "NeverRunBefore" Then GUICtrlSetData($user_name, $Username)
	If $Password <> "NeverRunBefore" Then GUICtrlSetData($pass_word, $Password)
	If $IPPort <> "NeverRunBefore" Then GUICtrlSetData($ip_port, $IPPort)
	If $ssl = "1" Then GUICtrlSetState($s_sl, $GUI_CHECKED)
	
	$continue_button_a = GUICtrlCreateButton("Done", 10, 190, 58)
	;$help_button = GUICtrlCreateButton("?", 73, 190, 25)
	While 1
		$msg2 = GUIGetMsg()
		Switch $msg2
			Case $GUI_EVENT_CLOSE
				If $force = True Then
					Exit
				Else
					$r = MsgBox(64 + 4, "Close without saving settings?", "Do you want to close without saving your settings? If you want to" & @CRLF & "save your settings, click No and press the Done button.")
					If $r = 6 Then
						GUIDelete($smtp_settings)
						ExitLoop
					EndIf
				EndIf
			;Case $help_button
				;MsgBox(0, "Help", "d.hernandez09@gmail.com")
			Case $continue_button_a
				If GUICtrlRead($smtp_server) <> "" And GUICtrlRead($from_name) <> "" And GUICtrlRead($from_address) <> "" And GUICtrlRead($user_name) <> "" And GUICtrlRead($pass_word) <> "" And GUICtrlRead($ip_port) <> 0 Then
					$SmtpServer = GUICtrlRead($smtp_server)
					IniWrite($settings_ini, "EMAIL", "SmtpServer", $SmtpServer)
					$FromName = GUICtrlRead($from_name)
					IniWrite($settings_ini, "EMAIL", "FromName", $FromName)
					$FromAddress = GUICtrlRead($from_address)
					IniWrite($settings_ini, "EMAIL", "FromAddress", $FromAddress)
					$Username = GUICtrlRead($user_name)
					IniWrite($settings_ini, "EMAIL", "UserName", $Username)
					$Password = GUICtrlRead($pass_word)
					IniWrite($settings_ini, "EMAIL", "Password", $Password)
					$IPPort = GUICtrlRead($ip_port)
					IniWrite($settings_ini, "EMAIL", "IPPort", $IPPort)
					If BitAND(GUICtrlRead($s_sl), $GUI_CHECKED) = $GUI_CHECKED Then
						$ssl = 1
						IniWrite($settings_ini, "EMAIL", "SSL", "1")
					Else
						$ssl = 0
						IniWrite($settings_ini, "EMAIL", "SSL", "0")
					EndIf
					GUIDelete($smtp_settings)
					ExitLoop
				Else
					GuiSetState (@sw_disable, $smtp_settings)
					MsgBox(0, "Message", "All parts of form have to be filled out.")
					WinActivate ("Set SMTP settings")
					Guisetstate (@sw_enable, $smtp_settings)
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>SetSettings

Func EditList()
	$beta = 1
	$edit_list_gui = GUICreate("Add to contacts list", 340, 195, 550, 150)
	
	$add_listview = GUICtrlCreateListView("Person's name |E-Mail Address", 10, 10, 320, 145)
	$addto_add_list_button = GUICtrlCreateButton("Add...", 10, 165, 50)
	$removefrom_add_list_button = GUICtrlCreateButton("Remove", 65, 165, 50)
	$add_array = IniReadSection($settings_ini, "ADD") ;$add_array[0][0] returns number of entries!
	If IsArray ($add_array) Then
	For $beta = 1 To $add_array[0][0]
		GUICtrlCreateListViewItem($add_array[$beta][1], $add_listview)
	Next
	EndIf
	
	GUISetState()

	While 1
		$msg3 = GUIGetMsg()
		Switch $msg3
			Case $GUI_EVENT_CLOSE
				GUIDelete($edit_list_gui)
				ExitLoop
			Case $addto_add_list_button
				_AddToAddList($add_listview)
			Case $removefrom_add_list_button
				_RemoveFromAddList($add_listview)
		EndSwitch
	WEnd
EndFunc   ;==>EditList

Func _RemoveFromAddList($add_listview)
	$find_array_ini = IniReadSection($settings_ini, "ADD")
	$delete_index = GUICtrlRead($add_listview)
	$delete_value = GUICtrlRead($delete_index)
	If String(StringReplace(StringReplace($delete_value, "|", " <", 1), "|", ">")) <> "0" Then
	$response = MsgBox(4 + 64, "Delete entry", "Are you sure you want to delete" & @CRLF & StringReplace(StringReplace($delete_value, "|", " <", 1), "|", ">") & "?")
	If $response = 6 Then ;6=yes
		$delete_value = StringTrimRight($delete_value, 1) ;trim the trailing "|"
		$find_index = _ArraySearch($find_array_ini, $delete_value, 0, 0, 0, 0, 1, 1)
		IniDelete($settings_ini, "ADD", $find_array_ini[$find_index][0])
		GUICtrlDelete($delete_index)
		$find_index_main_gui_deleteitem = _ArraySearch($additions_from_settings_ini, $delete_value & "|", 0, 0, 0, 0, 1, 1)
		; $find_index_main_gui_deleteitem will be -1 if you just added the entry to be removed without rebooting the program.
		If $find_index_main_gui_deleteitem <> -1 Then
			GUICtrlDelete($additions_from_settings_ini[$find_index_main_gui_deleteitem][0])
		Else
			$find_index_main_gui_deleteitem = _ArraySearch($add_added_today, $delete_value & "|", 0, 0, 0, 0, 1, 1)
			GUICtrlDelete($add_added_today[$find_index_main_gui_deleteitem][0])
		EndIf
	EndIf
	EndIf
EndFunc   ;==>_RemoveFromAddList

Func _AddToAddList($add_listview)
	$add_gui = GUICreate("Custom add entry", 300, 155)
	GUICtrlCreateLabel("Person's name", 10, 10)
	$name_input = GUICtrlCreateInput("", 10, 28, 280)
	GUICtrlCreateLabel("E-Mail Address", 10, 58)
	$address_input = GUICtrlCreateInput("", 10, 78, 280)
	$continue_button_b = GUICtrlCreateButton("Done", 10, 113, 50)
	$cancel_button = GUICtrlCreateButton("Cancel", 65, 113, 50)
	GUISetState()
	While 1
		$msg4 = GUIGetMsg()
		Switch $msg4
			Case $GUI_EVENT_CLOSE
				GUIDelete($add_gui)
				ExitLoop
			Case $cancel_button
				GUIDelete($add_gui)
				ExitLoop
			Case $continue_button_b
				$add_name = GUICtrlRead($name_input)
				$add_address = GUICtrlRead($address_input)
				$ini_add_section_read_array = IniReadSection($settings_ini, "ADD")
				Local $key_names_array[UBound($ini_add_section_read_array)]
				For $g = 1 To UBound($ini_add_section_read_array) - 1
					$key_names_array[$g] = $ini_add_section_read_array[$g][0]
				Next
				$max_value = _ArrayMax($key_names_array)
				$key_name = String($max_value + 1)
				IniWrite($settings_ini, "ADD", $key_name, $add_name & "|" & $add_address)
				$new_ctrl_id = GUICtrlCreateListViewItem($add_name & "|" & $add_address, $to_list)
				$first_dimens = UBound($add_added_today, 1)
				$second_dimens = UBound($add_added_today, 2)
				ReDim $add_added_today[$first_dimens + 1][$second_dimens]
				$add_added_today[$first_dimens][0] = $new_ctrl_id
				$add_added_today[$first_dimens][1] = $add_name & "|" & $add_address & "|"
				GUICtrlCreateListViewItem($add_name & "|" & $add_address, $add_listview)
				GUIDelete($add_gui)
				ExitLoop
		EndSwitch
	WEnd
EndFunc   ;==>_AddToAddList


Func _RemoveFromRemoveList($remove_listview)
	$remove_entry_number = GUICtrlRead($remove_listview)
	MsgBox(0, "$remove_entry_number", $remove_entry_number)
	$remove_entry = GUICtrlRead($remove_entry_number)
	If StringLeft($remove_entry, 1) = "|" Then $remove_entry = StringTrimLeft($remove_entry, 1)
	MsgBox(0, "$remove_entry", $remove_entry)
	;remove entry from Add list and the main GUI
	;GuiCtrlDelete ($remove_entry_number)
	$delete_main_gui_indexno = _ArraySearch($control_id_and_data, $remove_entry, 0, 0, 0, 0, 1, 1)
	MsgBox(0, "$delete_main_gui_indexno", $control_id_and_data[$delete_main_gui_indexno][0])
	If $delete_main_gui_indexno <> -1 Then
		$m = GUICtrlDelete($control_id_and_data[$delete_main_gui_indexno][0])
		;MsgBox (0, "", $m)
	EndIf
EndFunc   ;==>_RemoveFromRemoveList

; This function (NOT written by me) deletes duplicates in an array. I use it to delete duplicate contacts from the contact array.

; #INDEX# ====================================================================================================

; Title .........: ArrayUnique UDF for the Array.au3 library in AutoIt v3
; AutoIt Version: 3.2.3++
; Language:       English
; Description:    A function to return an Array with only unique strings
;                 Author(s) include: SmOke_N and litlmike
; ====================================================================================================

; #FUNCTION# ;===============================================================================
; Name...........: _ArrayUnique
; Description ...: Returns the Unique Elements of a 1-dimensional array.
; Syntax.........: Func _ArrayUnique($aArray[, $iDimension = 1[, $iBase = 0[, $iCase = 0[, $vDelim = "|"]]]])
; Parameters ....: $sArray - The Array to use
;                  $iDimension  - [optional] The Dimension of the Array to use
;                  $iBase  - [optional] Is the Array 0-base or 1-base index.  0-base by default
;                  $iCase  - [optional] Flag to indicate if the operations should be case sensitive.
;                  0 = not case sensitive, using the user's locale (default)
;                  1 = case sensitive
;                  2 = not case sensitive, using a basic/faster comparison
;                  $vDelim  - [optional] One or more characters to use as delimiters.  However, cannot forsee its usefullness
; Return values .: Success - Returns a 1-dimensional array containing containing only the unique elements of that Dimension
;                  Failure - Returns 0 and Sets @Error:
;                  0 - No error.
;                  1 - Returns 0 if parameter is not an array.
;                  2 - _ArrayUnique failed for some other reason
;                  3 - Array dimension is invalid, should be an integer greater than 0
; Author ........: SmOke_N
; Modified.......: litlmike
; Remarks .......: Returns an array, the first element ($array[0]) contains the number of strings returned, the remaining elements ($array[1], $array[2], etc.) contain the unique strings.
; Related .......: _ArrayMax, _ArrayMin
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _ArrayUnique($aArray, $iDimension = 1, $iBase = 0, $iCase = 0, $vDelim = "|")
	;$aArray used to be ByRef, but litlmike altered it to allow for the choosing of 1 Array Dimension, without altering the original array
	If $vDelim = "|" Then $vDelim = Chr(01) ; by SmOke_N, modified by litlmike
	If Not IsArray($aArray) Then Return SetError(1, 0, 0) ;Check to see if it is valid array

	;Checks that the given Dimension is Valid
	If Not $iDimension > 0 Then
		Return SetError(3, 0, 0) ;Check to see if it is valid array dimension, Should be greater than 0
	Else
		;If Dimension Exists, then get the number of "Rows"
		$iUboundDim = UBound($aArray, 1) ;Get Number of "Rows"
		If @error Then Return SetError(3, 0, 0) ;2 = Array dimension is invalid.

		;If $iDimension Exists, And the number of "Rows" is Valid:
		If $iDimension > 1 Then ;Makes sure the Array dimension desired is more than 1-dimensional
			Dim $aArrayTmp[1] ;Declare blank array, which will hold the dimension declared by user
			For $i = 0 To $iUboundDim - 1 ;Loop through "Rows"
				_ArrayAdd($aArrayTmp, $aArray[$i][$iDimension - 1]) ;$iDimension-1 to match Dimension
			Next
			_ArrayDelete($aArrayTmp, 0) ;Get rid of 1st-element which is blank
		Else ;Makes sure the Array dimension desired is 1-dimensional
			;If Dimension Exists, And the number of "Rows" is Valid, and the Dimension desired is not > 1, then:
			;For the Case that the array is 1-Dimensional
			If UBound($aArray, 0) = 1 Then ;Makes sure the Array is only 1-Dimensional
				Dim $aArrayTmp[1] ;Declare blank array, which will hold the dimension declared by user
				For $i = 0 To $iUboundDim - 1
					_ArrayAdd($aArrayTmp, $aArray[$i])
				Next
				_ArrayDelete($aArrayTmp, 0) ;Get rid of 1st-element which is blank
			Else ;For the Case that the array is 2-Dimensional
				Dim $aArrayTmp[1] ;Declare blank array, which will hold the dimension declared by user
				For $i = 0 To $iUboundDim - 1
					_ArrayAdd($aArrayTmp, $aArray[$i][$iDimension - 1]) ;$iDimension-1 to match Dimension
				Next
				_ArrayDelete($aArrayTmp, 0) ;Get rid of 1st-element which is blank
			EndIf
		EndIf
	EndIf

	Local $sHold ;String that holds the Unique array info
	For $iCC = $iBase To UBound($aArrayTmp) - 1 ;Loop Through array
		;If Not the case that the element is already in $sHold, then add it
		If Not StringInStr($vDelim & $sHold, $vDelim & $aArrayTmp[$iCC] & $vDelim, $iCase) Then _
				$sHold &= $aArrayTmp[$iCC] & $vDelim
	Next
	If $sHold Then
		$aArrayTmp = StringSplit(StringTrimRight($sHold, StringLen($vDelim)), $vDelim, 1) ;Split the string into an array
		Return $aArrayTmp ;SmOke_N's version used to Return SetError(0, 0, 0)
	EndIf
	Return SetError(2, 0, 0) ;If the script gets this far, it has failed
EndFunc   ;==>_ArrayUnique