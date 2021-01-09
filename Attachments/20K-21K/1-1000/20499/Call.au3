#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.0
 Author:         Andy Flesner (Airwolf123)

 Script Function:
	Skype COM Example - Call.vbs
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

;// Declare the following Skype constants:
$cUserStatus_Offline = $oSkype.Convert.TextToUserStatus("OFFLINE")
$cUserStatus_Online = $oSkype.Convert.TextToUserStatus("ONLINE")
$cCallStatus_Ringing = $oSkype.Convert.TextToCallStatus("RINGING")
$cCallStatus_Inprogress = $oSkype.Convert.TextToCallStatus("INPROGRESS")
$cCallStatus_Failed = $oSkype.Convert.TextToCallStatus("FAILED")
$cCallStatus_Refused = $oSkype.Convert.TextToCallStatus("REFUSED")
$cCallStatus_Cancelled = $oSkype.Convert.TextToCallStatus("CANCELLED")
$cCallStatus_Finished = $oSkype.Convert.TextToCallStatus("FINISHED")
$cCallStatus_Busy = $oSkype.Convert.TextToCallStatus("BUSY")
$cAttachmentStatus_Available = $oSkype.Convert.TextToAttachmentStatus("AVAILABLE")

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

;// The PlaceCall command will fail if the user is offline. To avoid failure, check user status and change to online if necessary:
If $cUserStatus_Offline = $oSkype.CurrentUserStatus Then
	$oSkype.ChangeUserStatus($cUserStatus_Online)
EndIf  

;// Create a user object:
$oUser = $oSkype.User("echo123")
MsgBox(0,"","User " & $oUser.Handle & " online status is " & $oSkype.Convert.OnlineStatusToText($oUser.OnlineStatus))

;// Place a call:
$oCall = $oSkype.PlaceCall($oUser.Handle)

;// Wait until the call is in progress and return the relevant error if any other status occurs:
While $oCall.Status <> $cCallStatus_Inprogress
	If $oCall.Status = $cCallStatus_Failed Or _
    $oCall.Status = $cCallStatus_Refused Or _
    $oCall.Status = $cCallStatus_Cancelled Or _
    $oCall.Status = $cCallStatus_Finished Or _
    $oCall.Status = $cCallStatus_Busy Then
		MsgBox(0,"","Call status: " & $oSkype.Convert.CallStatusToText($oCall.Status))
	EndIf    
	Sleep(500)
WEnd

;// Check sending DTMF tones for use with interactive voice response (IVR) applications:
Sleep(10000)    
If $cCallStatus_InProgress = $oCall.Status Then
	$oCall.DTMF = "0"
EndIf
Sleep(500)
If $cCallStatus_InProgress = $oCall.Status Then
	$oCall.DTMF = "1"
EndIf
Sleep(500)
If $cCallStatus_InProgress = $oCall.Status Then
	$oCall.DTMF = "2"
EndIf
Sleep(500)
If $cCallStatus_InProgress = $oCall.Status Then
	$oCall.DTMF = "3"
EndIf
Sleep(500)
If $cCallStatus_InProgress = $oCall.Status Then
	$oCall.DTMF = "4"
EndIf
Sleep(500)
If $cCallStatus_InProgress = $oCall.Status Then
	$oCall.DTMF = "5"
EndIf
Sleep(500)
If $cCallStatus_InProgress = $oCall.Status Then
	$oCall.DTMF = "6"
EndIf
Sleep(500)
If $cCallStatus_InProgress = $oCall.Status Then
	$oCall.DTMF = "7"
EndIf
Sleep(500)
If $cCallStatus_InProgress = $oCall.Status Then
	$oCall.DTMF = "8"
EndIf
Sleep(500)
If $cCallStatus_InProgress = $oCall.Status Then
	$oCall.DTMF = "9"
EndIf
Sleep(500)
If $cCallStatus_InProgress = $oCall.Status Then
	$oCall.DTMF = "#"
EndIf
Sleep(500)
If $cCallStatus_InProgress = $oCall.Status Then
	$oCall.DTMF = "*"
EndIf
Sleep(500)

;// Finish the call: 
If $oCall.Status <> $cCallStatus_Finished Then
	$oCall.Finish()
EndIf

;// The AttachmentStatus event handler monitors attachment status and automatically attempts to reattach to the API following loss of connection:
Func Skype_AttachmentStatus($aStatus)
	MsgBox(0,"","Attachment status " & $oSkype.Convert.AttachmentStatusToText($aStatus))
	If $aStatus = $cAttachmentStatus_Available Then
		$oSkype.Attach()
	EndIf
EndFunc

;// If the call status is "failed", the CallStatus event handler returns the relevant failure reason as text:
Func Skype_CallStatus($aCall, $aStatus)
	MsgBox(0,"","Call " & $aCall.Id & " status " & $aStatus & " " & $oSkype.Convert.CallStatusToText($aStatus))
	If $cCallStatus_Failed = $aStatus Then
		MsgBox(0,"","Failure reason:" & $oSkype.Convert.CallFailureReasonToText($aCall.FailureReason))
	EndIf
EndFunc

Func MyErrFunc()
	;Do Nothing
EndFunc