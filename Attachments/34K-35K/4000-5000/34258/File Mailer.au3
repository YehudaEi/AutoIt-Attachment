#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=mail.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Include<file.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Global $oMyRet[2]
Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
$SmtpServer = "mymailserver.com"
$FromName = " My Company Name"
$FromAddress = "NoReply@mymailserver.com"
Global $ToAddress = "", $Manager, $Mail
$Subject = "Quotation "
Global $Body = "Dear Client" & @CRLF & @CRLF & "As requested, your quotation has been attached to this mail." & @CRLF & _
	"Kindly print, sign and fax back to the number indicated on the " & @CRLF & "quote." & @CRLF & @CRLF & _
	"Regards" & @CRLF & "Account Manager"
Global $AttachFiles = "", $message = "Hold down Ctrl or Shift to choose multiple files."
Global $CcAddress = "", $BccAddress = "", $Importance = "High", $Username = "dt.sz0", $Password = "yb5cXPpRET"
Global $IPPort = 25, $ssl = 0, $IniFile = @ScriptDir & "\QuotationMailer.ini", $Cc

If Not FileExists($IniFile) Then
	IniWrite($IniFile, "MANAGERS", "Diane Courtman", "dianec@mymailserver.com")
	IniWrite($IniFile, "MANAGERS", "Jeanne Ledger", "jeannel@mymailserver.com")
	IniWrite($IniFile, "MANAGERS", "Linda Roodt", "lindar@mymailserver.com")
EndIf

If FileExists($IniFile) Then
	$var = IniReadSection($IniFile, "MANAGERS")
    For $i = 1 To $var[0][0]
        $Cc = $Cc & "|" & $var[$i][0]
    Next
EndIf

GUICreate("Galileo Quotation Mailer", 346, 386, -1, -1)
$BtnTo = GUICtrlCreateButton("To: >>", 8, 8, 45, 20)
GUICtrlSetTip(-1, "Please click to open Addressbook detail.")
$InpTo = GUICtrlCreateInput("", 56, 8, 281, 21)
GUICtrlSetTip(-1, "Please enter the clients email address here.")
$BtnCc = GUICtrlCreateButton("Cc: >>", 8, 35, 45, 20)
GUICtrlSetTip(-1, "Please click to add or edit Account Manager detail.")
$ComboCc = GUICtrlCreateCombo("", 56, 35, 281, 21)
GUICtrlSetData($ComboCc, $Cc)
GUICtrlSetTip($ComboCc, "Please enter Account Manager email address here.")

GUICtrlCreateLabel("Subject:", 4, 66, 45, 17,$SS_RIGHT )
$InpSubj = GUICtrlCreateInput($Subject, 56, 62, 281, 21)
GUICtrlSetTip(-1, "Please add Quote number here.")
$InpAttach = GUICtrlCreateInput("", 56, 89, 281, 21)
GUICtrlSetTip(-1, "Quote file to be sent.")
$BtnAttach = GUICtrlCreateButton("Attach", 8, 89, 45, 21)
GUICtrlSetTip(-1, "Please click to select Quote file.")
$EditBody = GUICtrlCreateEdit("", 8, 116, 329, 241)
GUICtrlSetData($EditBody, $Body)
$BtnCancel = GUICtrlCreateButton("Cancel", 225, 362, 50, 20)
GUICtrlSetTip(-1, "Click to Cancel sending Quote.")
$BtnSend = GUICtrlCreateButton("Send", 285, 362, 50, 20)
GUICtrlSetTip(-1, "Click to Send Quote.")
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			$PID = ProcessExists("notepad.exe")
			If $PID Then ProcessClose($PID)
			$PID = ProcessExists("wab.exe")
			If $PID Then ProcessClose($PID)
			Exit
		Case $BtnCancel
			$PID = ProcessExists("notepad.exe")
			If $PID Then ProcessClose($PID)
			$PID = ProcessExists("wab.exe")
			If $PID Then ProcessClose($PID)
			Exit
		Case $BtnAttach
			$AttachFiles = FileOpenDialog($message, "C:\PdfDocs\", "Quotation file (*.pdf)", 1 + 4 )
			If @error Then
				MsgBox(4096,"","No File(s) chosen")
			Else
				MsgBox(0,"PDF","File(s) chosen: " & $AttachFiles)
				$AttachFiles = StringReplace($AttachFiles, "|", ";")
				GUICtrlSetData($InpAttach, $AttachFiles)
			EndIf
		Case $BtnTo
			_To()
		Case $BtnCc
			_Cc()
		Case $BtnSend
			$Val = 0
			$Msg = ""

            $ToAddress = GUICtrlRead($InpTo)
			If $ToAddress = "" Then
				$Msg = $Msg & @CRLF & @CRLF & "Send To is blank"
				$Val = 1
			Else
				$result = StringInStr($ToAddress, "@")
				If $result < 2 Then
					$Msg = $Msg & @CRLF & @CRLF & "Error with Sent To Address - please check"
					$Val = 1
				EndIf
			EndIf

            $CcAddress = GUICtrlRead($ComboCc)
 			If $CcAddress = "" Then
				$Msg = $Msg & @CRLF & @CRLF & "Cc is blank"
				$Val = 1
			Else
				$result = StringInStr($CcAddress, "@")
				If $result = 1 Then
					$Msg = $Msg & @CRLF & @CRLF & "Error with Cc Address - please check"
					$Val = 1
				EndIf
				If $result = 0 Then
					$var = $CcAddress
					$CcAddress = IniRead($IniFile, "MANAGERS", $var, "NotFound")
					If $CcAddress = "NotFound" Then
						$Msg = $Msg & @CRLF & @CRLF & "Error with Cc Address, Account Manager" & _
						@CRLF & "detail Not Found in IniFile, please check again."
						$Val = 1
					EndIf
				EndIf
			EndIf

           $Subject = GUICtrlRead($InpSubj)
 			If $Subject = "" Then
				$Msg = $Msg & @CRLF & @CRLF & "No Subject"
				$Val = 1
			EndIf

            $AttachFiles = GUICtrlRead($InpAttach)
			If $AttachFiles = "" Then
				$Msg = $Msg & @CRLF & @CRLF & "No files attached"
				$Val = 1
			EndIf

            $Body = GUICtrlRead($EditBody)
			If $Body = "" Then
				$Msg = $Msg & @CRLF & @CRLF & "The Body of the mail is empty"
				$Val = 1
			EndIf

			If $Val = 1 Then
				MsgBox(48,"Message not ready for sending!","This message has the following problems:" & @CRLF & $Msg & _
				@CRLF & @CRLF & @CRLF & "Please correct and retry")
			Else
				$rc = _INetSmtpMailCom($SmtpServer, $FromName, $FromAddress, $ToAddress, $Subject, _
					$Body, $AttachFiles, $CcAddress, $BccAddress, $Importance, $Username, $Password, $IPPort, $ssl)
				If @error Then
					MsgBox(0, "Error sending message", "Error code:" & @error & "  Description:" & $rc)
				Else
					MsgBox(0, "Confirmation", "Quotation sent" & @CRLF & @CRLF & _
					"To: " & $ToAddress & @CRLF& @CRLF & "Cc: " & $CcAddress, 2)
					$PID = ProcessExists("notepad.exe")
					If $PID Then ProcessClose($PID)
					$PID = ProcessExists("wab.exe")
					If $PID Then ProcessClose($PID)
					Exit
				EndIf
			EndIf
	EndSwitch
WEnd

Func _To()
	Run(@ScriptDir & "\wab.exe Agents.wab", @ScriptDir, @SW_MAXIMIZE)
EndFunc

Func _Cc()
	Run(@WindowsDir & "\Notepad.exe " & $IniFile, @ScriptDir, @SW_MAXIMIZE)
EndFunc

Func _SendMail()
	$rc = _INetSmtpMailCom($SmtpServer, $FromName, $FromAddress, $ToAddress, $Subject, $Body, $AttachFiles, $CcAddress, $BccAddress, $Importance, $Username, $Password, $IPPort, $ssl)
	If @error Then
		MsgBox(0, "Error sending message", "Error code:" & @error & "  Description:" & $rc)
	EndIf
EndFunc

Func _INetSmtpMailCom($s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress, $s_Subject = "", $as_Body = "", $s_AttachFiles = "", $s_CcAddress = "", $s_BccAddress = "", $s_Importance="Normal", $s_Username = "", $s_Password = "", $IPPort = 25, $ssl = 0)
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
        Local $S_Files2Attach = StringSplit($s_AttachFiles, ";")
        For $x = 1 To $S_Files2Attach[0]
            $S_Files2Attach[$x] = _PathFull($S_Files2Attach[$x])
;~          ConsoleWrite('@@ Debug : $S_Files2Attach[$x] = ' & $S_Files2Attach[$x] & @LF & '>Error code: ' & @error & @LF) ;### Debug Console
            If FileExists($S_Files2Attach[$x]) Then
                ConsoleWrite('+> File attachment added: ' & $S_Files2Attach[$x] & @LF)
                $objEmail.AddAttachment($S_Files2Attach[$x])
            Else
                ConsoleWrite('!> File not found to attach: ' & $S_Files2Attach[$x] & @LF)
                SetError(1)
                Return 0
            EndIf
        Next
    EndIf
    $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
    $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = $s_SmtpServer
    If Number($IPPort) = 0 then $IPPort = 25
    $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = $IPPort
    ;Authenticated SMTP
    If $s_Username <> "" Then
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusername") = $s_Username
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendpassword") = $s_Password
    EndIf
    If $ssl Then
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True
    EndIf
    ;Update settings
    $objEmail.Configuration.Fields.Update
    ; Set Email Importance
    Switch $s_Importance
        Case "High"
            $objEmail.Fields.Item ("urn:schemas:mailheader:Importance") = "High"
        Case "Normal"
            $objEmail.Fields.Item ("urn:schemas:mailheader:Importance") = "Normal"
        Case "Low"
            $objEmail.Fields.Item ("urn:schemas:mailheader:Importance") = "Low"
    EndSwitch
    $objEmail.Fields.Update
    ; Sent the Message
    $objEmail.Send
    If @error Then
        SetError(2)
        Return $oMyRet[1]
    EndIf
    $objEmail=""
EndFunc   ;==>_INetSmtpMailCom

Func MyErrFunc()	; Com Error Handler
    $HexNumber = Hex($oMyError.number, 8)
    $oMyRet[0] = $HexNumber
    $oMyRet[1] = StringStripWS($oMyError.description, 3)
    ConsoleWrite("### COM Error !  Number: " & $HexNumber & "   ScriptLine: " & $oMyError.scriptline & "   Description:" & $oMyRet[1] & @LF)
    SetError(1); something to check for when this function returns
    Return
EndFunc   			;==>MyErrFunc

