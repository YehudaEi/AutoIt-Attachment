#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.0
 Author:         Andy Flesner (Airwolf123)

 Script Function:
	Skype COM Example - Response.vbs
	Converted from VBS to AutoIt

 Licensed under BSD License:
	Copyright (c) 2004-2006, Skype Limited.
	All rights reserved. 

	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met: 
		- Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer. 
		- Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer 
		  in the documentation and/or other materials provided with the distribution. 
		- Neither the name of the Skype Limited nor the names of its contributors may be used to endorse or promote products derived from 
		  this software without specific prior written permission. 
	
	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
	LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
	OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
	LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON 
	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
	THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 

#ce ----------------------------------------------------------------------------

;// Create a Skype4COM object:
$oSkype = ObjCreate("Skype4COM.Skype")
$oSkypeEvent = ObjEvent($oSkype,"Skype_")
$oError = ObjEvent("AutoIt.Error","MyErrFunc")

;// Start the Skype client:
If Not $oSkype.Client.IsRunning Then
	$oSkype.Client.Start()
EndIf

;// Verify that a user is signed in and online before continuing
While 1
	If $oSkype.CurrentUserStatus = $oSkype.Convert.TextToUserStatus("ONLINE") Then
		ExitLoop
	Else
		$oSkype.ChangeUserStatus($oSkype.Convert.TextToUserStatus("ONLINE"))
	EndIf
	Sleep(1000)
WEnd

;// Declare the following Skype constants:
$cAttachmentStatus_Available = $oSkype.Convert.TextToAttachmentStatus("AVAILABLE")
$cMessageStatus_Sending = $oSkype.Convert.TextToChatMessageStatus("SENDING")
$cMessageStatus_Received = $oSkype.Convert.TextToChatMessageStatus("RECEIVED")
$cMessageType_Said = $oSkype.Convert.TextToChatMessageType("SAID")
$cMessageType_Left = $oSkype.Convert.TextToChatMessageType("LEFT")

;// The SendMessage command will fail if the user is offline. To avoid failure, check user status and change to online if necessary:
If $cUserStatus_Offline = $oSkype.CurrentUserStatus Then
	$oSkype.ChangeUserStatus($cUserStatus_Online)
EndIf  

;// Sleep 
While 1
	Sleep(60000)
WEnd

;// The AttachmentStatus event handler monitors attachment status and automatically attempts to reattach to the API following loss of connection:
Func Skype_AttachmentStatus($aStatus)
	MsgBox(0,"","Attachment status " & $oSkype.Convert.AttachmentStatusToText($aStatus))
	If $aStatus = $oSkype.Convert.TextToAttachmentStatus("AVAILABLE") Then
		$oSkype.Attach()
	EndIf
EndFunc

;// The MessageStatus event handler monitors message status, decodes received messages and, for those of type "Said", sends an autoresponse quoting the original message:
Func Skype_MessageStatus($aMsg, $aStatus)
	MsgBox(0,"","Message " & $aMsg.Id & " status " & $oSkype.Convert.ChatMessageStatusToText($aStatus))
	If $aStatus = $cMessageStatus_Received Then 
		DecodeMsg($aMsg)
		If $aMsg.Type = $cMessageType_Said Then 
			;$oSkype.SendMessage($aMsg.FromHandle, "This is autoresponse.")
			$aMsg.Chat.SendMessage("You said [" & $aMsg.Body & "]")
		EndIf
	EndIf    
EndFunc

;// The DecodeMsg event handler decodes messages in a chat and converts leave reasons to text for messages of type "Left":
Func DecodeMsg($oMsg)       
	$sText = $oMsg.FromHandle & " " & $oSkype.Convert.ChatMessageTypeToText($oMsg.Type) & ":"
	If StringLen($oMsg.Body) Then 
		$sText = $sText & " " & $oMsg.Body
	EndIf
	Dim $oUser
	For $oUser In $oMsg.Users
		$sText = $sText & " " & $oUser.Handle
	Next
	If $oMsg.Type = $cMessageType_Left Then 
		$sText = $sText & " " & $oSkype.Convert.ChatLeaveReasonToText($oMsg.LeaveReason)
	EndIf
	MsgBox(0,"",$sText)
EndFunc

Func MyErrFunc()
	;Do Nothing
EndFunc