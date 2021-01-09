#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.0
 Author:         Andy Flesner (Airwolf123)

 Script Function:
	Skype COM Example - Attach.vbs
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

;// Connect to the Skype API:
$oSkype.Attach(5)

;// When attached to the API, send repeated commands to the API to test if they succeed:
While 1
	Sleep(1000)
	If $oSkype.AttachmentStatus = $oSkype.Convert.TextToAttachmentStatus("SUCCESS") Then 
		ConsoleWrite("PING..")
		$oSkype.SendCommand($oSkype.Command(0, "PING","PONG",TRUE))
		;oSkype.SendCommand(oSkype.Command(0, "PING")) 
		ConsoleWrite("ok")
		MsgBox(0,"","")
	EndIf
WEnd
 
;// The AttachmentStatus event handler monitors attachment status and returns the Skypename of the user when the status is "success":
Func Skype_AttachmentStatus($aStatus)
	MsgBox(0,"","Attachment status " & $oSkype.Convert.AttachmentStatusToText($aStatus))
	If $aStatus = $oSkype.Convert.TextToAttachmentStatus("AVAILABLE") Then
		$oSkype.Attach()
	EndIf
	If $aStatus = $oSkype.Convert.TextToAttachmentStatus("SUCCESS") Then
		MsgBox(0,"","Current user is " & $oSkype.CurrentUserHandle)
	EndIf
EndFunc

Func MyErrFunc()
	;Do Nothing
EndFunc