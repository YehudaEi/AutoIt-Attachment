;~   Smtp   Mailer

;[url]http://www.autoitscript.com/forum/index.php?showtopic=23860&st=0[/url]
#Include <file.au3>
Global   $oMyError   =   ObjEvent("AutoIt.Error",   "MyErrFunc")
;##################################
;   Include
;##################################
#Include <file.au3>
;##################################
;   Variables
;##################################
#CS $s_SmtpServer   =   "smtp.gmail.com"    ;   smtp������   address   for   the   smtp-server   to   use   -   REQUIRED
   $s_FromName   =   "www.yidabu.com"        ;   �ʼ�������   name   from   who   the   email   was   sent
   $s_FromAddress   =   "your@gmail.com" ; �ʼ������ߵ�ַaddress   from   where   the   mail   should   come
   $s_ToAddress   =   "your@gmail.com"        ;   �ʼ����͸�˭   destination   address   of   the   email   -   REQUIRED
   $s_Subject   =   "bbs.yidabu.com"          ;�ʼ�����   subject   from   the   email   -   can   be   anything   you   want   it   to   be
   $as_Body   =   "autoit��̳"   &   @CRLF   &   _
   "http://bbs.yidabu.com/forum-2-1.html"    ;   �ʼ�����the   messagebody   from   the   mail   -   can   be   left   blank   but   then   you   get   a   blank   mail
   $s_AttachFiles   =   ""                                ;   ������ַ   the   file   you   want   to   attach-   leave   blank   if   not   needed
   $s_CcAddress   =   ""       ;   address   for   cc   -   leave   blank   if   not   needed
   $s_BccAddress   =   ""        ;   address   for   bcc   -   leave   blank   if   not   needed
   $s_Username   =   "yidabu"                         ;  �û���   username   for   the   account   used   from   where   the   mail   gets   sent   -   REQUIRED
   $s_Password   =   "www.yidabu.com"             ;   ����password   for   the   account   used   from   where   the   mail   gets   sent   -   REQUIRED
   $IPPort   =   25                                     ;   ���Ͷ˿�   port   used   for   sending   the   mail
   $ssl   =   0                                           ;   ��ȫ����   enables/disables   secure   socket   layer   sending   -   put   to   1   if   using   httpS
   ;~   $IPPort=465                                      ;   yidabu.com��ʾ��Gmailʹ�õķ��Ͷ˿�  
   ;~   $ssl=1                                            ;   yidabu.com��ʾ��GmailҪ���ð�ȫ����  
#CE

;##################################
;   Script
;##################################
Global   $oMyRet[2]
Global   $oMyError   =   ObjEvent("AutoIt.Error",   "MyErrFunc")
;~   $rc   =   _INetSmtpMailCom($s_SmtpServer,   $s_FromName,   $s_FromAddress,   $s_ToAddress,   $s_Subject,   $as_Body,   $s_AttachFiles,   $s_CcAddress,   $s_BccAddress,   $s_Username,   $s_Password,   $IPPort,   $ssl)
;~   If   @error   Then
;~        MsgBox(0,   "Error   sending   message",   "Error   code:"   &   @error   &   " Description:"   &   $rc)
;~   EndIf
;

Func   _INetSmtpMailCom($s_SmtpServer,   $s_FromName,   $s_FromAddress,   $s_ToAddress,   $s_Subject   =   "",   $as_Body   =   "",   $s_AttachFiles   =   "",   $s_CcAddress   =   "",   $s_BccAddress   =   "",   $s_Username   =   "",   $s_Password   =   "",$IPPort=25,   $ssl=0)
   $objEmail   =   ObjCreate("CDO.Message")
   $objEmail.From   =   '"'   &   $s_FromName   &   '"   <'   &   $s_FromAddress   &   '>'
   $objEmail.To   =   $s_ToAddress
   Local   $i_Error   =   0
   Local   $i_Error_desciption   =   ""
   If   $s_CcAddress   <>   ""   Then   $objEmail.Cc   =   $s_CcAddress
   If   $s_BccAddress   <>   ""   Then   $objEmail.Bcc   =   $s_BccAddress
   $objEmail.Subject   =   $s_Subject
   If   StringInStr($as_Body,"<")   and   StringInStr($as_Body,">")   Then
         $objEmail.HTMLBody   =   $as_Body  
   Else
         $objEmail.Textbody   =   $as_Body   &   @CRLF
   EndIf
   If   $s_AttachFiles   <>   ""   Then
         Local   $S_Files2Attach   =   StringSplit($s_AttachFiles,   ";")
         For   $x   =   1   To   $S_Files2Attach[0]
            $S_Files2Attach[$x]   =   _PathFull   ($S_Files2Attach[$x])
            If   FileExists($S_Files2Attach[$x])   Then
                  $objEmail.AddAttachment   ($S_Files2Attach[$x])
            Else
                  $i_Error_desciption   =   $i_Error_desciption   &   @lf   &   'File   not   found   to   attach:   '   &   $S_Files2Attach[$x]
                  SetError(1)
                  return   0
            EndIf
         Next
   EndIf
   $objEmail.Configuration.Fields.Item   ("http://schemas.microsoft.com/cdo/configuration/sendusing")   =   2
   $objEmail.Configuration.Fields.Item   ("http://schemas.microsoft.com/cdo/configuration/smtpserver")   =   $s_SmtpServer
   $objEmail.Configuration.Fields.Item   ("http://schemas.microsoft.com/cdo/configuration/smtpserverport")   =   $IPPort
;Authenticated   SMTP
   If   $s_Username   <>   ""   Then
         $objEmail.Configuration.Fields.Item   ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate")   =   1
         $objEmail.Configuration.Fields.Item   ("http://schemas.microsoft.com/cdo/configuration/sendusername")   =   $s_Username
         $objEmail.Configuration.Fields.Item   ("http://schemas.microsoft.com/cdo/configuration/sendpassword")   =   $s_Password
   EndIf
   If   $Ssl   Then  
         $objEmail.Configuration.Fields.Item   ("http://schemas.microsoft.com/cdo/configuration/smtpusessl")   =   True
   EndIf
;Update   settings
   $objEmail.Configuration.Fields.Update
;   Sent   the   Message
   $objEmail.Send
   if   @error   then  
         SetError(2)
         return   $oMyRet[1]
   EndIf
EndFunc   ;==>_INetSmtpMailCom
;
;
;   Com   Error   Handler
Func   MyErrFunc()
   $HexNumber   =   Hex($oMyError.number,   8)
   $oMyRet[0]   =   $HexNumber
   $oMyRet[1]   =   StringStripWS($oMyError.description,3)
   ConsoleWrite("###   COM   Error   ! Number:   "   &   $HexNumber   &   " ScriptLine:   "   &   $oMyError.scriptline   &   " Description:"   &   $oMyRet[1]   &   @LF)  
   SetError(1);   something   to   check   for   when   this   function   returns
   Return
EndFunc   ;==>MyErrFunc