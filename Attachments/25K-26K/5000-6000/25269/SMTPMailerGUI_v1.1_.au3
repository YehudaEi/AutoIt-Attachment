#Include <File.au3>
#include <GUIConstants.au3>
#include <WindowsConstants.au3>
#include <String.au3>
Const $ES_PASSWORD = 0x0020  ; to avoid error unknown :-(


;v1.1 includes variation to include dropdown selection of server addresses..


Global $s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress, $s_Subject, $s_Body, $s_AttachFiles, $s_CcAddress, $s_BccAddress, $s_Username, $s_Password, $IPPort, $ssl, $oMyRet[2], $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")

$Width = 322
$Height = 382
$Form = GUICreate("Mail Sender", $Width, $Height, -1, -1, BitOR($WS_POPUP, $WS_BORDER))
$Close = GUICtrlCreateLabel("X", $Width - 15, 0, 11, 20)
GUICtrlSetFont(-1, 10, 800, 0, "Comic Sans MS")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetCursor(-1, 0)
$Other = GUICtrlCreateLabel("+", $Width - 30, 0, 11, 20)
GUICtrlSetFont(-1, 10, 800, 0, "Comic Sans MS")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetCursor(-1, 0)
$Formtitle = GUICtrlCreateLabel(" Mail Sender", 0, 4, @DesktopWidth, 20, -1, $GUI_WS_EX_PARENTDRAG)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$Formtitlebackground = GUICtrlCreateGraphic(0, 0, @DesktopWidth, 22)
GUICtrlSetBkColor(-1, 0x000000)
$Edit1 = GUICtrlCreateEdit("", 8, 76, 305, 265)
$Input1 = GUICtrlCreateInput("", 56, 28, 257, 21)
$Input2 = GUICtrlCreateInput("", 56, 52, 257, 21)
$Label1 = GUICtrlCreateLabel("To :", 8, 30, 23, 17)
$Label2 = GUICtrlCreateLabel("Subject :", 8, 54, 46, 17)
$Button1 = GUICtrlCreateButton("Send", 8, 348, 150, 25, 0)
$Button2 = GUICtrlCreateButton("Settings", 167, 348, 147, 25, 0)

$Width2 = 263
$Height2 = 247
$Form2 = GUICreate("Settings", $Width2, $Height2, -1, -1, BitOR($WS_POPUP, $WS_BORDER))
$Close2 = GUICtrlCreateLabel("X", $Width2 - 15, 0, 11, 20)
GUICtrlSetFont(-1, 10, 800, 0, "Comic Sans MS")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetCursor(-1, 0)
$Formtitle2 = GUICtrlCreateLabel(" Settings", 0, 4, @DesktopWidth, 20, -1, $GUI_WS_EX_PARENTDRAG)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$Formtitlebackground2 = GUICtrlCreateGraphic(0, 0, @DesktopWidth, 22)
GUICtrlSetBkColor(-1, 0x000000)

$Label12 = GUICtrlCreateLabel("Smtp Server :", 16, 32, 68, 17)
$Label22 = GUICtrlCreateLabel("From name :", 16, 128, 62, 17)
$Label32 = GUICtrlCreateLabel("From address :", 16, 152, 73, 17)
$Label42 = GUICtrlCreateLabel("Username :", 16, 80, 58, 17)
$Label52 = GUICtrlCreateLabel("Password :", 16, 104, 56, 17)
$Label62 = GUICtrlCreateLabel("Port :", 16, 56, 29, 17)
$Label72 = GUICtrlCreateLabel("SSL :", 120, 56, 30, 17)
$Input12 = GUICtrlCreateInput("", 96, 32, 121, 21)
$Input22 = GUICtrlCreateInput("", 56, 56, 49, 21)
$Input32 = GUICtrlCreateInput("", 96, 80, 121, 21)
$Input42 = GUICtrlCreateInput("", 96, 104, 121, 21, $ES_PASSWORD)
$Input52 = GUICtrlCreateInput("", 96, 128, 121, 21)
$Input62 = GUICtrlCreateInput("", 96, 152, 121, 21)
$Checkbox1 = GUICtrlCreateCheckbox("Enable / Disable", 152, 56, 97, 17)
$Button12 = GUICtrlCreateButton("Apply Settings", 16, 184, 83, 25, 0)
$Button22 = GUICtrlCreateButton("Apply and Save Settings", 112 , 184, 131, 25, 0)
$Combo1 = GUICtrlCreateCombo("<Select from list of Available servers>", 16, 220 ,225, 20 )
$Button22 = GUICtrlCreateButton("Apply and Save Settings", 112 , 184, 131, 25, 0)

$Width3 = 283
$Height3 = 115
$Form3 = GUICreate("Options", $Width3, $Height3, -1, -1, BitOR($WS_POPUP, $WS_BORDER))
$Close3 = GUICtrlCreateLabel("X", $Width3 - 15, 0, 11, 20)
GUICtrlSetFont(-1, 10, 800, 0, "Comic Sans MS")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetCursor(-1, 0)
$Formtitle3 = GUICtrlCreateLabel(" Options", 0, 4, @DesktopWidth, 20, -1, $GUI_WS_EX_PARENTDRAG)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$Formtitlebackground3 = GUICtrlCreateGraphic(0, 0, @DesktopWidth, 22)
GUICtrlSetBkColor(-1, 0x000000)
$Label13 = GUICtrlCreateLabel("Cc :", 16, 34, 23, 17)
$Label23 = GUICtrlCreateLabel("Bcc", 16, 59, 23, 17)
$Label33 = GUICtrlCreateLabel("Attach :", 16, 82, 41, 17)
$Input13 = GUICtrlCreateInput("", 64, 32, 201, 21)
$Input23 = GUICtrlCreateInput("", 64, 56, 201, 21)
$Input33 = GUICtrlCreateInput("", 64, 80, 121, 21)
$Button13 = GUICtrlCreateButton("Browse", 192, 80, 75, 25, 0)

GUISetState(@SW_SHOW, $Form)

Load()

While 1
    $msg = GUIGetMsg()
    Switch $msg
        Case $Close
            Save()
            Exit
        Case $Button1
            GUICtrlSetState($Button1, $GUI_DISABLE)
            GUICtrlSetData($Button1, "Loading...")
            $s_ToAddress = GUICtrlRead($Input1)
            $s_Subject = GUICtrlRead($Input2)
            $s_Body = GUICtrlRead($Edit1)
            $s_CcAddress = GUICtrlRead($Input13)
            $s_BccAddress = GUICtrlRead($Input23)
            $s_AttachFiles = GUICtrlRead($Input33)
            $Send = _INetSmtpMailCom($s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress, $s_Subject, $s_Body, $s_AttachFiles, $s_CcAddress, $s_BccAddress, $s_Username, $s_Password, $IPPort, $ssl)
            If @error Then MsgBox(0, "Error sending message", "Error code:" & @error & "  Rc:" & $Send)
            GUICtrlSetData($Button1, "Send")
            GUICtrlSetState($Button1, $GUI_ENABLE)
        Case $Button2
            GUISetState(@SW_SHOW, $Form2)
        Case $Other
            GUISetState(@SW_SHOW, $Form3)
        Case $Close2
            GUISetState(@SW_HIDE, $Form2)
        Case $Button12
            Apply()
        Case $Button22
            Save()
        Case $Button13
            $File = FileOpenDialog('Please choose file', '', 'All files (*.*)', 1)
            GUICtrlSetData($Input33, $File)
		Case $Combo1
			Dim $selection = GUICtrlRead($combo1)
			If $selection = "<Select from list of Available servers>" Then 
				; do nothing  or clear selection.
				GUICtrlSetData($input12,"")
			Else
				GUICtrlSetData($input12,$selection)
			Endif 
		Case $Close3
            GUISetState(@SW_HIDE, $Form3)
    EndSwitch
WEnd

Func _INetSmtpMailCom($s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress, $s_Subject = "", $s_Body = "", $s_AttachFiles = "", $s_CcAddress = "", $s_BccAddress = "", $s_Username = "", $s_Password = "", $IPPort = 25, $ssl = 0)
    $objEmail = ObjCreate("CDO.Message")
    $objEmail.From = '"' & $s_FromName & '" <' & $s_FromAddress & '>'
    $objEmail.To = $s_ToAddress
    Local $i_Error = 0
    Local $i_Error_desciption = ""
    If $s_CcAddress <> "" Then $objEmail.Cc = $s_CcAddress
    If $s_BccAddress <> "" Then $objEmail.Bcc = $s_BccAddress
    $objEmail.Subject = $s_Subject
    If StringInStr($s_Body, "<") And StringInStr($s_Body, ">") Then
        $objEmail.HTMLBody = $s_Body
    Else
        $objEmail.Textbody = $s_Body & @CRLF
    EndIf
    If $s_AttachFiles <> "" Then
        Local $S_Files2Attach = StringSplit($s_AttachFiles, ";")
        For $x = 1 To $S_Files2Attach[0]
            $S_Files2Attach[$x] = _PathFull($S_Files2Attach[$x])
            If FileExists($S_Files2Attach[$x]) Then
                $objEmail.AddAttachment($S_Files2Attach[$x])
            Else
                $i_Error_desciption = $i_Error_desciption & @LF & 'File not found to attach: ' & $S_Files2Attach[$x]
                SetError(1)
                Return 0
            EndIf
        Next
    EndIf
    $objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
    $objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = $s_SmtpServer
    $objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = $IPPort
    If $s_Username <> "" Then
        $objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
        $objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = $s_Username
        $objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = $s_Password
    EndIf
    If $ssl Then
        $objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True
    EndIf
    $objEmail.Configuration.Fields.Update
    $objEmail.Send
    If @error Then
        SetError(2)
        Return $oMyRet[1]
    EndIf
EndFunc   ;==>_INetSmtpMailCom

Func MyErrFunc()
    $HexNumber = Hex($oMyError.number, 8)
    $oMyRet[0] = $HexNumber
    $oMyRet[1] = StringStripWS($oMyError.description, 3)
    ConsoleWrite("### COM Error !  Number: " & $HexNumber & "   ScriptLine: " & $oMyError.scriptline & "   Description:" & $oMyRet[1] & @LF)
    SetError(1)
    Return
EndFunc   ;==>MyErrFunc

Func Apply()
    $s_SmtpServer = GUICtrlRead($Input12)
    $s_FromName = GUICtrlRead($Input52)
    $s_FromAddress = GUICtrlRead($Input62)
    $s_Username = GUICtrlRead($Input32)
    $s_Password = GUICtrlRead($Input42)
    $IPPort = GUICtrlRead($Input22)
    If GUICtrlRead($Checkbox1) = $GUI_CHECKED Then
        $ssl = "1"
    Else
        $ssl = "0"
    EndIf
EndFunc   ;==>Apply

Func Save()
    Apply()
    $Save = _StringEncrypt(1, $s_SmtpServer & "†" & $s_FromName & "†" & $s_FromAddress & "†" & $s_Username & "†" & $s_Password & "†" & $IPPort & "†" & $ssl, "Secret")
    If FileExists("Settings.txt") Then FileDelete("Settings.txt")
    FileWrite("Settings.txt", $Save)
EndFunc   ;==>Save

Func Load()
	_ListServers()
	If FileExists("Settings.txt") Then
        $Load = FileRead("Settings.txt")
        $Decrypt = _StringEncrypt(0, $Load, "Secret")
        $Settings = StringSplit($Decrypt, "†", 1)
        GUICtrlSetData($Input12, $Settings[1])
        GUICtrlSetData($Input52, $Settings[2])
        GUICtrlSetData($Input62, $Settings[3])
        GUICtrlSetData($Input32, $Settings[4])
        GUICtrlSetData($Input42, $Settings[5])
        GUICtrlSetData($Input22, $Settings[6])
        If $Settings[7] = "1"  Then
            GUICtrlSetState($Checkbox1, $GUI_CHECKED)
        Else
            GUICtrlSetState($Checkbox1, $GUI_UNCHECKED)
        EndIf
        Apply()
    EndIf
EndFunc   ;==>Load




Func _ListServers()
	Global $smtpServer[51]
	
	$smtpServer[1] = "relay.clara.net"
	$smtpServer[2] = "smtp.ntlworld.com"
	$smtpServer[3] = "post.demon.co.uk"
	$smtpServer[4] = "smtp.easynet.co.uk"
	$smtpServer[5] = "smtp.freeserve.co.uk"
	$smtpServer[6] = "mail.genie.co.uk"
	$smtpServer[7] = "smtp.ic24.net"
	$smtpServer[8] = "mail.dsl.interdart.net"
	$smtpServer[9] = "smtp.domain.ext"
	$smtpServer[10] = "smtp.lineone.net"
	$smtpServer[11] = "smtp.lycos.co.uk"
	$smtpServer[12] = "smtp.madasafish.com"
	$smtpServer[13] = "smtp.mistral.co.uk"
	$smtpServer[14] = "smtp.namestoday.ws"
	$smtpServer[15] = "mailhost.netscapeonline.co.uk"
	$smtpServer[16] = "post.newnet.co.uk"
	$smtpServer[17] = "smtp.nildram.co.uk"
	$smtpServer[18] = "smtp.ntlworld.com"
	$smtpServer[19] = "mail.onetel.net.uk"
	$smtpServer[20] = "smtp.dial.pipex.com"
	$smtpServer[21] = "smtp.purplenet.co.uk"
	$smtpServer[22] = "smtp.supanet.com"
	$smtpServer[23] = "smtp.tiscali.co.uk"
	$smtpServer[24] = "smtp.blueyonder.co.uk"
	$smtpServer[25] = "mail.tesco.net"
	$smtpServer[26] = "smtp.tiscali.co.uk"
	$smtpServer[27] = "mail.totalise.co.uk"
	$smtpServer[28] = "smtp.ukgateway.net"
	$smtpServer[29] = "smtp.v21.co.uk"
	$smtpServer[30] = "smtp.virgin.net"
	$smtpServer[31] = "mail.vispa.com"
	$smtpServer[32] = "smtpmail.waitrose.com"
	$smtpServer[33] = "mail.which.net"
	$smtpServer[34] = "smtp.tiscali.co.uk"
	$smtpServer[35] = "smtp.mail.yahoo.com"
	$smtpServer[36] = "smtp.gmail.com"
	$smtpServer[37] = "mx1.hotmail.com"
	$smtpServer[38] = "mx1.hotmail.com"
	$smtpServer[39] = "mx2.hotmail.com"
	$smtpServer[40] = "smtp.mac.com"
	$smtpServer[41] = "smtp.isp.netscape.com"
	$smtpServer[42] = "amauta.rcp.net.pe"
	$smtpServer[43] = "smtp.shylex.net"
	$smtpServer[44] = "outgoing.verizon.net"
	$smtpServer[45] = "smtp.aol.com"
	$smtpServer[46] = "smtp.attwireless.net"
	$smtpServer[47] = "mail.messagingengine.com"
	$smtpServer[48] = "smtp.tiscali.co.uk"
	$smtpServer[49] = "my.inbox.com"
	$smtpServer[50] = "smtp.zapak.com"

	Dim $i , $serverList

	For $i = 1 To UBound($smtpServer,1) -1
		$serverList &= $smtpServer[$i] & "|"
	Next
		
	GUICtrlSetData($combo1, $serverList)
	
EndFunc