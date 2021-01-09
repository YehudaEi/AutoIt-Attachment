#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.0
 Author:         Andy Flesner (Airwolf123)

 Script Function:
	Skype COM Example - Conferences.vbs
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

;// Count conference calls hosted by the current user. A conference call hosted by the current user is represented by multiple call objects which have a common conference ID (conf_id). For each conference object,  return the conf_id, the number of calls, and the number of active calls:
MsgBox(0,"","There are " & $oSkype.Conferences.Count & " conference calls hosted by " & $oSkype.CurrentUser.Handle)
For $oConf In $oSkype.Conferences
	MsgBox(0,"","Conference " & $oConf.Id & " includes " & $oConf.Calls.Count & " calls from which " & $oConf.ActiveCalls.Count & " are active.")
Next

;//  To list conference calls in which the current user is active but not the host, begin by listing active calls for a user:
MsgBox(0,"","There are total " & $oSkype.ActiveCalls.Count & " active calls.")

;//Conference calls not hosted by the current user are all calls which have one or more participants (participants do not include the current user or the conference host). For each active call, return the Skypename and display name of each participant:
For $oCall In $oSkype.ActiveCalls
	If $oCall.Participants.Count > 0 Then 
		MsgBox(0,"","Conference call " & $oCall.Id & " with " & $oCall.PartnerHandle & " has " & $oCall.Participants.Count & " participants.")
		For $oParticipant In $oCall.Participants
			MsgBox(0,"","Participant " & $oParticipant.Handle & " display name is " & $oParticipant.DisplayName)
		Next
	Else
		MsgBox(0,"","Active call " & $oCall.Id & " with " & $oCall.PartnerHandle & " is not a conference call.")
	EndIf
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