#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.0
 Author:         Andy Flesner (Airwolf123)

 Script Function:
	Skype COM Example - MissedMessages.vbs
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

;// Query the total number of missed messages:
MsgBox(0,"","Total missed message count: " & $oSkype.MissedMessages.Count)

;// Query the id, timestamp, and sender Skypename of the message:
For $oMsg In $oSkype.MissedMessages
  MsgBox(0,"","Msg id: " & $oMsg.Id & " at " & $oMsg.Timestamp & " from " & $oMsg.FromHandle)
Next  

;// Mark the missed message as "Read"
For $oMsg In $oSkype.MissedMessages
	$oMsg.Seen = True
Next

;// The AttachmentStatus event handler monitors attachment status and automatically attempts to reattach to the API following loss of connection:
Func Skype_AttachmentStatus($aStatus)
	MsgBox(0,"","Attachment status " & $oSkype.Convert.AttachmentStatusToText($aStatus))
	If $aStatus = $oSkype.Convert.TextToAttachmentStatus("AVAILABLE") Then
		$oSkype.Attach()
	EndIf
EndFunc

Func MyErrFunc()
	;Do Nothing
EndFunc