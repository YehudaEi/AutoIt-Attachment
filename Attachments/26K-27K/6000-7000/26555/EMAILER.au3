#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=1.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <file.au3>
#include <ComboConstants.au3>
#include <GUIComboBox.au3>
#include <ButtonConstants.au3>
#include <GUIListBox.au3>
#include <StaticConstants.au3>

Global $oMyRet[2]
Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
$Form1 = GUICreate("e-Mailer", 450, 285, 283, 172, BitOR($WS_SYSMENU, $WS_CAPTION, $WS_POPUP, $WS_POPUPWINDOW, $WS_BORDER, $WS_CLIPSIBLINGS), BitOR($WS_EX_ACCEPTFILES, $WS_EX_WINDOWEDGE))
GUISetCursor(0)
$ToAddress = GUICtrlCreateInput("", 32, 16, 145, 21)
$Label1 = GUICtrlCreateLabel("Recipient:", 176, 0, 62, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Group1 = GUICtrlCreateGroup("", 0, 104, 449, 129)
$Body = GUICtrlCreateEdit("", 8, 128, 433, 121)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Label2 = GUICtrlCreateLabel("Attachments:", 174, 47, 78, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Browse = GUICtrlCreateButton("Browse", 280, 72, 41, 25, 0)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$AttachFiles = GUICtrlCreateInput("", 16, 72, 233, 32)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
$Send = GUICtrlCreateButton("SEND", 56, 250, 49, 25, 0)
$Exit = GUICtrlCreateButton("EXIT", 321, 250, 49, 25, 0)
$Combo1 = GUICtrlCreateCombo(@TAB, 232, 16, 145, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
$emails = FileOpen("emails.txt",0)
GUISetState(@SW_SHOW)
GUISetState(@SW_SHOW)
FileInstall("1.ico",@TempDir & "\1.ico")
$Icon1 = GUICtrlCreateIcon(@TempDir & "\1.ico",-1, 335, 45, 128,128, BitOR($SS_NOTIFY,$WS_GROUP))
                    While 1
                        $line = FileReadLine($emails)
                        If @error =-1 Then ExitLoop
                        $xc = StringFormat("%s",$line)
                        GUICtrlSetData($Combo1, $xc)
                    WEnd

$SmtpServer = "smtp.gmail.com"
$Username = ""
$Password = ""
$FromName = ""
$FromAddress = ""

While 1
	$nMsg = GUIGetMsg()
			$h = GUICtrlRead($Combo1)
			If GUICtrlRead($Combo1) = @TAB Then
			Sleep(100)
		Else
			GUICtrlSetData($ToAddress,$h)
			EndIf
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			FileDelete(@TempDir & "\1.ico")
			Exit
		Case $Send
			MsgBox(0, "MAIL", "Attempting To Send Mail", 3)
			_INetSmtpMailCom($SmtpServer, $FromName, $FromAddress, GUICtrlRead($ToAddress), "Info", GUICtrlRead($Body), GUICtrlRead($AttachFiles),"","", $Username, $Password)
		Case $Browse
			$files = FileOpenDialog("Attach Stuff", @MyDocumentsDir, "All (*.*)", 7)
			GUICtrlSetData($AttachFiles, $files)
		Case $Exit
			FileDelete(@TempDir & "\1.ico")
			Exit
	EndSwitch
WEnd

If @error Then
	MsgBox(0, "Error sending message", "Error code: " & @error & "  Description: " & $Send)
EndIf
; The UDF
Func _INetSmtpMailCom($s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress, $s_Subject = "", $as_Body = "", $s_AttachFiles = "", $s_CcAddress = "", $s_BccAddress = "", $s_Username = "", $s_Password = "",$IPPort=465, $ssl=1)
    $objEmail = ObjCreate("CDO.Message")
    $objEmail.From = '"' & $s_FromName & '" <' & $s_FromAddress & '>'
    $objEmail.To = $s_ToAddress
    Local $i_Error = 0
    Local $i_Error_desciption = ""
    If $s_CcAddress <> "" Then $objEmail.Cc = $s_CcAddress
    If $s_BccAddress <> "" Then $objEmail.Bcc = $s_BccAddress
    $objEmail.Subject = $s_Subject
    If StringInStr($as_Body,"<") and StringInStr($as_Body,">") Then
        $objEmail.HTMLBody = $as_Body
    Else
        $objEmail.Textbody = $as_Body & @CRLF
    EndIf
    If $s_AttachFiles <> "" Then
        Local $S_Files2Attach = StringSplit($s_AttachFiles, ";")
        For $x = 1 To $S_Files2Attach[0]
            $S_Files2Attach[$x] = _PathFull ($S_Files2Attach[$x])
            If FileExists($S_Files2Attach[$x]) Then
                $objEmail.AddAttachment ($S_Files2Attach[$x])
            Else
                $i_Error_desciption = $i_Error_desciption & @lf & 'File not found to attach: ' & $S_Files2Attach[$x]
                SetError(1)
                return 0
            EndIf
        Next
    EndIf
    $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
    $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = $s_SmtpServer
    $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = $IPPort
;Authenticated SMTP
    If $s_Username <> "" Then
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusername") = $s_Username
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendpassword") = $s_Password
    EndIf
    If $Ssl Then
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True
    EndIf
;Update settings
    $objEmail.Configuration.Fields.Update
; Send the Message
    $objEmail.Send
    if @error then
        SetError(2)
        return $oMyRet[1]
	Else
		MsgBox(4096,"Done","Mail Sent Successfully")
    EndIf
EndFunc ;==>_INetSmtpMailCom

; Com Error Handler
Func MyErrFunc()
    $HexNumber = Hex($oMyError.number, 8)
    $oMyRet[0] = $HexNumber
    $oMyRet[1] = StringStripWS($oMyError.description,3)
    ConsoleWrite("### COM Error !  Number: " & $HexNumber & "   ScriptLine: " & $oMyError.scriptline & "   Description:" & $oMyRet[1] & @LF)
    SetError(1); something to check for when this function returns
    Return
EndFunc ;==>MyErrFunc
