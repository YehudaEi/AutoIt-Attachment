;
;##################################
; Include
;##################################
#Include<file.au3>
#include <Constants.au3>


Func _GetMAC()
Global $Result, $mac, $line

$mac = Run(@ComSpec & " /c " & 'GETMAC /FO table',@SystemDir, @SW_HIDE,$STDERR_CHILD + $STDOUT_CHILD)

While 1
	$line &= StdoutRead($mac)
	If @error Then ExitLoop
Wend
$line = StringSplit($line,@CRLF,1)
if @error then Return ""
$Result = StringSplit($line[4]," ",1)
if @error then Return ""
Return $Result[1]
EndFunc

Local $szDrive, $szDir, $szFName, $szExt
Local $TestPath = _PathSplit(@ScriptFullPath, $szDrive, $szDir, $szFName, $szExt)
$drive = $szDrive
$id = _GetPNPDeviceID($drive)


Func _GetPNPDeviceID($drive,$fullid=0)
    $objWMIService = ObjGet("winmgmts:{impersonationLevel=Impersonate}!\\.\root\cimv2")
    If Not IsObj($objWMIService) Then Return -1 ;Failed to Connect to WMI on Local Machine
    
    $colDevice = $objWMIService.ExecQuery("SELECT * from Win32_LogicalDiskToPartition")
    $var=""
    For $objItem in $colDevice
        If StringInStr($objItem.Dependent,$drive) Then 
            $var=StringTrimLeft($objItem.Antecedent,stringInstr($objItem.Antecedent,"="))
        EndIf
    Next
    If Not $var Then Return -2 ;Failed to Find Drive Letter
    
    $colDevice = $objWMIService.ExecQuery("SELECT * from Win32_DiskDriveToDiskPartition")
    $diskpartition = $var
    $var=""
    For $objItem in $colDevice
        If StringInStr($objItem.Dependent,$diskpartition) Then
            $var=StringTrimLeft($objItem.Antecedent,stringInstr($objItem.Antecedent,"="))
        EndIf
    Next
    If Not $var Then Return -3 ;Failed to Find Physical Drive #

    $colDevice = $objWMIService.ExecQuery("SELECT * from Win32_DiskDrive")
    $physicaldrive = StringReplace(StringReplace($var,"\\","\"),'"',"")
    $var=""
    For $objItem in $colDevice
        If $objItem.DeviceID = $physicaldrive Then
            $var=$objItem.PNPDeviceID
        EndIf
    Next
    If Not $var Then Return -4 ;Failed to Find PNPDeviceID
    
    If Not $fullid Then $var = StringTrimLeft($var,StringInstr($var,"\",0,-1)) ;Return Ugly Full PNPDeviceID
    Return $var
EndFunc

;##################################
; Variables
;##################################
$SmtpServer = "smtp.mail.yahoo.com"                            ; address for the smtp-server to use - REQUIRED
$FromName = "data flasdisk"                          ; name from who the email was sent
$FromAddress = "xxxxxxxx@yahoo.com"                           ; e-mail asal
$ToAddress = "xxxxxxx@yahoo.com"                             ; e-mail tujuan
$Subject = "serial flashdisk"                       ; subject from the email - can be anything you want it to be
$Body = "serial flashdisk =  " & _GetPNPDeviceID($drive)                   ; the messagebody from the mail - can be left blank but then you get a blank mail
$AttachFiles = ""                           ; the file you want to attach- leave blank if not needed
$CcAddress = ""                             ; address for cc - leave blank if not needed
$BccAddress = ""                            ; address for bcc - leave blank if not needed
$Importance = "Normal"                      ; Send message priority: "High", "Normal", "Low"
$Username = "xxxxxxx@yahoo.com"                              ; username for the account used from where the mail gets sent - REQUIRED
$Password = "xxxxxxx"                              ; password for the account used from where the mail gets sent - REQUIRED
$IPPort = 465                               ; port used for sending the mail
$ssl = 1                                    ; enables/disables secure socket layer sending - put to 1 if using httpS
;~ $IPPort=465                              ; GMAIL port used for sending the mail
;~ $ssl=1                                   ; GMAILenables/disables secure socket layer sending - put to 1 if using httpS

;##################################
; Script
;##################################
Global $oMyRet[2]
Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
$rc = _INetSmtpMailCom($SmtpServer, $FromName, $FromAddress, $ToAddress, $Subject, $Body, $AttachFiles, $CcAddress, $BccAddress, $Importance, $Username, $Password, $IPPort, $ssl)
If @error Then
    MsgBox(0, "Error sending message", "Error code:" & @error & "  Description:" & $rc)
EndIf
;
; The UDF
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
            ConsoleWrite('@@ Debug(62) : $S_Files2Attach = ' & $S_Files2Attach & @LF & '>Error code: ' & @error & @LF) ;### Debug Console
            If FileExists($S_Files2Attach[$x]) Then
                $objEmail.AddAttachment ($S_Files2Attach[$x])
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
;
;
; Com Error Handler
Func MyErrFunc()
    $HexNumber = Hex($oMyError.number, 8)
    $oMyRet[0] = $HexNumber
    $oMyRet[1] = StringStripWS($oMyError.description, 3)
    ConsoleWrite("### COM Error !  Number: " & $HexNumber & "   ScriptLine: " & $oMyError.scriptline & "   Description:" & $oMyRet[1] & @LF)
    SetError(1); something to check for when this function returns
    Return
 EndFunc   ;==>MyErrFunc
 
 MsgBox (0,"System Backup " ,"Backup Finished!" , 5)