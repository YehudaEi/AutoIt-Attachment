#cs ------------------------------------------------------------------------------------\

 AutoIt Version: 3.2.12.1
 Author:         Andy Flesner (Airwolf)

 Script Function:
	Skype4COM UDF Library

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

#ce ------------------------------------------------------------------------------------/

#include-once

; Set custom error handler
$oError = ObjEvent("AutoIt.Error","ErrFunc")

; Create Skype Object
Global $oSkype = ObjCreate("Skype4COM.Skype")

; Declare Constants
Const $UserStatus_Offline = $oSkype.Convert.TextToUserStatus("OFFLINE")
Const $UserStatus_Online = $oSkype.Convert.TextToUserStatus("ONLINE")
Const $UserStatus_Away = $oSkype.Convert.TextToUserStatus("AWAY")
Const $UserStatus_NotAvailable = $oSkype.Convert.TextToUserStatus("NA")
Const $UserStatus_DoNotDisturb = $oSkype.Convert.TextToUserStatus("DND")
Const $UserStatus_Invisible = $oSkype.Convert.TextToUserStatus("INVISIBLE")
Const $UserStatus_SkypeMe = $oSkype.Convert.TextToUserStatus("SKYPEME")
Const $CallStatus_Ringing = $oSkype.Convert.TextToCallStatus("RINGING")
Const $CallStatus_Inprogress = $oSkype.Convert.TextToCallStatus("INPROGRESS")
Const $CallStatus_Failed = $oSkype.Convert.TextToCallStatus("FAILED")
Const $CallStatus_Refused = $oSkype.Convert.TextToCallStatus("REFUSED")
Const $CallStatus_Cancelled = $oSkype.Convert.TextToCallStatus("CANCELLED")
Const $CallStatus_Finished = $oSkype.Convert.TextToCallStatus("FINISHED")
Const $CallStatus_Busy = $oSkype.Convert.TextToCallStatus("BUSY")
Const $AttachmentStatus_Available = $oSkype.Convert.TextToAttachmentStatus("AVAILABLE")

;---------------------------------------------------------------------------------------\
; _SkypeCOM_StartClient()																|
;																						|
; Purpose: 	Starts the Skype client software if it is not running.						|
; Input:	None.																		|
;																						|
; Returns: 	0 - Skype client is running (sets @error to 1)								|
;			1 - Skype client was sent the Start command and is now running				|
;---------------------------------------------------------------------------------------/
Func _SkypeCOM_StartClient()
	If $oSkype.Client.IsRunning Then
		Return 0
		SetError(1)
	Else
		$oSkype.Client.Start()
		Do
			Sleep(250)
		Until $oSkype.Client.IsRunning
		Return 1
	EndIf
EndFunc

;---------------------------------------------------------------------------------------\
; _SkypeCOM_CurrentUserStatus()															|
;																						|
; Purpose: 	Queries the currently logged in Skype user's status.						|
; Input:	None.																		|
;																						|
; Returns:	Status of current user in Text format.										|
;---------------------------------------------------------------------------------------/
Func _SkypeCOM_CurrentUserStatus()
	Return $oSkype.Convert.UserStatusToText($oSkype.CurrentUserStatus)
EndFunc

;---------------------------------------------------------------------------------------\
; _SkypeCOM_ChangeUserStatus($status)													|
;																						|
; Purpose: 	Changes the status of the current Skype user.								|
; Input:	$status can be any of the following integer values:							|
;			1 - Online																	|
;			2 - Offline																	|
;			3 - Away																	|
;			4 - Not Available															|
; 			5 - Do Not Disturb															|
; 			6 - Invisible																|
;			7 - SkypeMe																	|
;																						|
; Returns:	0 - Status change unsuccessful.												|
;			1 - Status change was successful.											|
;---------------------------------------------------------------------------------------/
Func _SkypeCOM_ChangeUserStatus($status)
	Select
		Case $status = 1
			$status = $UserStatus_Online
		Case $status = 2
			$status = $UserStatus_Offline
		Case $status = 3
			$status = $UserStatus_Away
		Case $status = 4
			$status = $UserStatus_NotAvailable
		Case $status = 5
			$status = $UserStatus_DoNotDisturb
		Case $status = 6
			$status = $UserStatus_Invisible
		Case $status = 7
			$status = $UserStatus_SkypeMe
	EndSelect
	$oSkype.ChangeUserStatus($status)
	If _SkypeCOM_CurrentUserStatus() = $oSkype.Convert.UserStatusToText($status) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc

;---------------------------------------------------------------------------------------\
; _SkypeCOM_PlaceCall($target1, $target2 = "", $target3 = "", $target4 = "")			|
;																						|
; Purpose: 	Places a call to another Skype user											|
; Input:	$target1 - Any Skype name, phone number, or speed dial code. 				|
;			$target2 [optional] - Second target for conference.							|
;			$target3 [optional] - Third target for conference.							|
;			$target4 [optional] - Fourth target for conference.							|
;																						|
; Returns:	Skype ID of call.															|
;---------------------------------------------------------------------------------------/
Func _SkypeCOM_PlaceCall($target1, $target2 = "", $target3 = "", $target4 = "")
	Dim $target[4] = [$target1, $target2, $target3, $target4]
	If $oSkype.CurrentUserStatus = $UserStatus_Offline Then
		$oSkype.ChangeUserStatus($UserStatus_Online)
	EndIf
	$callString = ""
	For $i = 0 To 3
		If $target[$i] <> "" Then
			$callString = $callString & $target[$i] & " ,"
		EndIf
	Next
	If StringRight($callString,1) = "," Then
		$callString = StringTrimRight($callString, 2)
	EndIf
	$oCall = $oSkype.PlaceCall($callString)
	Return $oCall.Id
EndFunc

;---------------------------------------------------------------------------------------\
; _SkypeCOM_CallStatus($id)																|
;																						|
; Purpose: 	Queries a Skype call for its status.										|
; Input:	$id - Skype call Id to query.								 				|
;																						|
; Returns:	Status of call in Text format.												|
;---------------------------------------------------------------------------------------/
Func _SkypeCOM_CallStatus($id)
	$oCall = $oSkype.Call($id)
	Return $oSkype.Convert.CallStatusToText($oCall.Status)
EndFunc

;---------------------------------------------------------------------------------------\
; _SkypeCOM_ActiveCalls()																|
;																						|
; Purpose: 	Queries all active calls and returns an array of data.						|
; Input:	None.														 				|
;																						|
; Returns:	Zero-based two-dimensional array with Id, PartnerHandle and					|
; 			TargetIdentity properties of each call.										|
;---------------------------------------------------------------------------------------/
Func _SkypeCOM_ActiveCalls()
	Dim $callarray[1][3]
	Dim $i = 0
	For $oCall In $oSkype.ActiveCalls
		ReDim $callarray[$i + 1][3]
		$callarray[$i][0] = $oCall.Id
		$callarray[$i][1] = $oCall.PartnerHandle
		$callarray[$i][2] = $oCall.TargetIdentity
		$i += 1
	Next
	Return $callarray
EndFunc

;---------------------------------------------------------------------------------------\
; _SkypeCOM_MissedCalls()																|
;																						|
; Purpose: 	Queries all missed calls and returns an array of data.						|
; Input:	None.														 				|
;																						|
; Returns:	Zero-based two-dimensional array with Id, PartnerHandle and					|
; 			TargetIdentity properties of each call.										|
;---------------------------------------------------------------------------------------/
Func _SkypeCOM_MissedCalls()
	Dim $callarray[1][3]
	Dim $i = 0
	For $oCall In $oSkype.MissedCalls
		ReDim $callarray[$i + 1][3]
		$callarray[$i][0] = $oCall.Id
		$callarray[$i][1] = $oCall.PartnerHandle
		$callarray[$i][2] = $oCall.TargetIdentity
		$i += 1
	Next
	Return $callarray
EndFunc

;---------------------------------------------------------------------------------------\
; _SkypeCOM_CallDTMFCodes($id, $dtmf)													|
;																						|
; Purpose: 	Sends a DTMF (touch-tone) to a call.										|
; Input:	$id - Skype ID of active call.								 				|
;			$dtmf - Dual-Tone Multi-Frequency tone to send (must be 0-9, # or *)		|
;																						|
; Returns:	0 - DTMF send has failed because the call ID is not in progress.			|
;				(sets @error to 1)														|
;			1 - DTMF tone sent successfully.											|
;---------------------------------------------------------------------------------------/
Func _SkypeCOM_CallDTMFCodes($id, $dtmf)
	$oCall = $oSkype.Call($id)
	If $oCall.Status = $CallStatus_InProgress Then
		$oCall.DTMF = $dtmf
		Return 1
	Else
		Return 0
		SetError(1)
	EndIf
EndFunc

;---------------------------------------------------------------------------------------\
; _SkypeCOM_CallAnswer($id)																|
;																						|
; Purpose: 	Answers an incoming call by its Skype ID.									|
; Input:	$id - Skype ID of incoming call.								 			|
;																						|
; Returns:	Nothing.																	|
;---------------------------------------------------------------------------------------/
Func _SkypeCOM_CallAnswer($id)
	$oCall = $oSkype.Call($id)
	$oCall.Answer
EndFunc

;---------------------------------------------------------------------------------------\
; _SkypeCOM_CallFinish($id)																|
;																						|
; Purpose: 	Finishes (hangs up) an incoming call by its Skype ID.						|
; Input:	$id - Skype ID of incoming call.								 			|
;																						|
; Returns:	0 - Call has already been finished.											|
;			1 - Finish command successfully sent to call.								|
;---------------------------------------------------------------------------------------/
Func _SkypeCOM_CallFinish($id)
	$oCall = $oSkype.Call($id)
	If $oCall.Status <> $CallStatus_Finished Then
		$oCall.Finish
		Return 1
	Else
		Return 0
		SetError(1)
	EndIf
EndFunc

;---------------------------------------------------------------------------------------\
; _SkypeCOM_CallHold($id)																|
;																						|
; Purpose: 	Places an active call on hold by its Skype ID.								|
; Input:	$id - Skype ID of active call.									 			|
;																						|
; Returns:	Nothing.																	|
;---------------------------------------------------------------------------------------/
Func _SkypeCOM_CallHold($id)
	$oCall = $oSkype.Call($id)
	$oCall.Hold
EndFunc

;---------------------------------------------------------------------------------------\
; _SkypeCOM_CallResume($id)																|
;																						|
; Purpose: 	Resumes an active call on hold by its Skype ID.								|
; Input:	$id - Skype ID of active call on hold.							 			|
;																						|
; Returns:	Nothing.																	|
;---------------------------------------------------------------------------------------/
Func _SkypeCOM_CallResume($id)
	$oCall = $oSkype.Call($id)
	$oCall.Resume
EndFunc

;---------------------------------------------------------------------------------------\
; _SkypeCOM_CallJoin($primaryid, $joiningid)											|
;																						|
; Purpose: 	Joins a call to another to create a conference.								|
; Input:	$primaryid - Skype ID of primary call.							 			|
;			$joiningid - Skype ID of call joining primary call.							|
;																						|
; Returns:	Conference call Skype ID number.											|
;---------------------------------------------------------------------------------------/
Func _SkypeCOM_CallJoin($primaryid, $joiningid)
	$oCall = $oSkype.Call($primaryid)
	$oCall.Join($joiningid)
	Return $oCall.ConferenceId
EndFunc

;---------------------------------------------------------------------------------------\
; _SkypeCOM_CallForward($target)														|
;																						|
; Purpose: 	Sets call forwarding to a Skype user or phone number. This service is an	|
;			additional charge through Skype.											|
; Input:	$target1 - Any Skype name or phone number.					 				|
;																						|
; Returns:	None.																		|
;---------------------------------------------------------------------------------------/
Func _SkypeCOM_CallForward($target)
	$oCall = $oSkype.Call($id)
	$oCall.Forward($target)
EndFunc

;---------------------------------------------------------------------------------------\
; _SkypeCOM_CallTransfer($id, $target1, $target2 = "", $target3 = "", $target4 = "")	|
;																						|
; Purpose: 	Transfers call to 1-4 different numbers or users. If call is transferred to	|
;			more than one user, the first to answer it will receive the call.			|
; Input:	$target1 - Any Skype name or phone number.					 				|
;			$target2 [optional] - Second target for transfer.							|
;			$target3 [optional] - Third target for transfer.							|
;			$target4 [optional] - Fourth target for transfer.							|
;																						|
; Returns:	0 - Call not transferrable.	(sets @error to 1)								|
;			1 - Call transfer initiated.												|
;---------------------------------------------------------------------------------------/
Func _SkypeCOM_CallTransfer($id, $target1, $target2 = "", $target3 = "", $target4 = "")
	Dim $target[4] = [$target1, $target2, $target3, $target4]
	$oCall = $oSkype.Call($id)
	$transferString = ""
	For $i = 0 To 3
		If $target[$i] <> "" Then
			$transferString = $transferString & $target[$i] & " ,"
		EndIf
	Next
	If StringRight($transferString,1) = "," Then
		$transferString = StringTrimRight($transferString, 2)
	EndIf
	If $oCall.CanTransfer Then
		$oCall.Transfer($transferString)
		Return 1
	EndIf
	Return 0
	SetError(1)
EndFunc

;---------------------------------------------------------------------------------------\
; _SkypeCOM_CallRedirectToVoicemail($id)												|
;																						|
; Purpose: 	Redirects call to voicemail based on Skype ID.								|
; Input:	$id - Skype call ID.										 				|
;																						|
; Returns:	None.																		|
;---------------------------------------------------------------------------------------/
Func _SkypeCOM_CallRedirectToVoicemail($id)
	$oCall = $oSkype.Call($id)
	$oCall.RedirectToVoicemail
EndFunc

;---------------------------------------------------------------------------------------\
; _SkypeCOM_CallStartVideo()															|
;																						|
; Purpose: 	Starts sending video.														|
; Input:	$id - Skype call ID.										 				|
;																						|
; Returns:	Skype VideoSendStatus in Text format.										|
;---------------------------------------------------------------------------------------/
Func _SkypeCOM_CallStartVideo($id)
	$oCall = $oSkype.Call($id)
	$oCall.StartVideoSend
	Return $oSkype.Convert.CallVideoSendStatusToText($oCall.VideoSendStatus)
EndFunc

;---------------------------------------------------------------------------------------\
; _SkypeCOM_CallStopVideo()															|
;																						|
; Purpose: 	Stops sending video.														|
; Input:	$id - Skype call ID.										 				|
;																						|
; Returns:	Skype VideoSendStatus in Text format.										|
;---------------------------------------------------------------------------------------/
Func _SkypeCOM_CallStopVideo($id)
	$oCall = $oSkype.Call($id)
	$oCall.StopVideoSend
	Return $oSkype.Convert.CallVideoSendStatusToText($oCall.VideoSendStatus)
EndFunc

;---------------------------------------------------------------------------------------\
; _SkypeCOM_AttachmentStatus()															|
;																						|
; Purpose: 	Returns Skype attachment status.											|
; Input:	None.														 				|
;																						|
; Returns:	Skype AttachmentStatus in Text format.										|
;---------------------------------------------------------------------------------------/
Func _SkypeCOM_AttachmentStatus()
	Return $oSkype.Convert.AttachmentStatusToText($oSkype.AttachmentStatus)
EndFunc

;---------------------------------------------------------------------------------------\
; _SkypeCOM_Attach()																	|
;																						|
; Purpose: 	Attaches to current instance of Skype.										|
; Input:	None.														 				|
;																						|
; Returns:	0 - AttachmentStatus is not Success. Program is not attached to Skype.		|
;				(sets @error to 1)														|
;			1 - Skype AttachmentStatus is Success. Program is attached to Skype.		|
;---------------------------------------------------------------------------------------/
Func _SkypeCOM_Attach()
	$oSkype.Attach()
	If _SkypeCOM_AttachmentStatus() = "Success" Then
		Return 1
	Else
		Return 0
		SetError(1)
	EndIf
EndFunc

; Custom COM Error Handler
Func ErrFunc() 
   $HexNumber=hex($oError.number,8) 
   Msgbox(0,"","We intercepted a COM Error !" & @CRLF & _
                "Number is: " & $HexNumber & @CRLF & _
                "Windescription is: " & $oError.windescription & @CRLF & _
				"Source is: " & $oError.source & @CRLF & _
				"Description is: " & $oError.description & @CRLF & _
				"Help file is: " & $oError.helpfile & @CRLF & _
				"Help context is: " & $oError.helpcontext & @CRLF & _
				"Last DLL error: " & $oError.lastdllerror & @CRLF & _
				"Script line: " & $oError.scriptline)

   $g_eventerror = 1 ; something to check for when this function returns 
Endfunc