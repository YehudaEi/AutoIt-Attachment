#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.0
 Author:         Andy Flesner (Airwolf123)

 Script Function:
	Skype COM Example - FileTransfers.vbs
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

;// Constants:
Const $fileTransferTypeIncoming=0
Const $fileTransferTypeOutgoing=1
Const $fileTransferStatusNew = 0   
Const $fileTransferStatusConnecting = 1
Const $fileTransferStatusWaitingForAccept = 2
Const $fileTransferStatusTransferring = 3
Const $fileTransferStatusTransferringOverRelay = 4
Const $fileTransferStatusPaused = 5
Const $fileTransferStatusRemotelyPaused = 6
Const $fileTransferStatusCancelled = 7
Const $fileTransferStatusCompleted = 8
Const $fileTransferStatusFailed = 9
Const $fileTransferFailureReasonSenderNotAuthorized= 1
Const $fileTransferFailureReasonRemotelyCancelled= 2
Const $fileTransferFailureReasonFailedRead = 3
Const $fileTransferFailureReasonFailedRemoteRead = 4
Const $fileTransferFailureReasonFailedWrite = 5
Const $fileTransferFailureReasonFailedRemoteWrite = 6
Const $fileTransferFailureReasonRemoteDoesNotSupportFT = 7
Const $fileTransferFailureReasonRemoteOfflineTooLong = 8

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

For $oTransfer In $oSkype.FileTransfers
	MsgBox(0,"",FTDetails($oTransfer))
Next

For $oTransfer In $oSkype.ActiveFileTransfers
	MsgBox(0,"",FTDetails($oTransfer))
Next

Sleep(30000)

Func Skype_FileTransferStatusChanged($aTransfer, $aStatus)
	MsgBox(0,"","File Transfer " & $aTransfer.Id & " status " & FTStatusToText($aStatus))
EndFunc

Func FTDetails($aTransfer)
	$output = "Id:" & $aTransfer.Id & " start:" & $aTransfer.StartTime & " end:" & $aTransfer.FinishTime 
	$output = $output & @CR & " Type:" & FTTypeToText($aTransfer.Type) 
	$output = $output & @CR & " Status:" & FTStatusToText($aTransfer.Status)
	$output = $output & @CR & " Partner:" & $aTransfer.PartnerHandle & "(" & $aTransfer.PartnerDisplayName & ")"
	$output = $output & @CR & " File:" & $aTransfer.FilePath
	$output = $output & @CR & " Bytes Transferred:" & $aTransfer.BytesTransferred & " bytes"
	$output = $output & @CR & " Transfer Speed:" & $aTransfer.BytesPerSecond & " bytes/sec"
	$output = $output & @CR & " Failure Reason:" & FTFailureReasonToText($aTransfer.FailureReason)
	Return $output
EndFunc

Func FTTypeToText($aType)  
	Select
		Case $aType = $fileTransferTypeIncoming
			Return "Incoming"
		Case $aType = $fileTransferTypeOutgoing
			Return "Outgoing"
	EndSelect
EndFunc

Func FTStatusToText($aStatus)
	Select
		Case $aStatus = $fileTransferStatusNew
			Return "New"
		Case $aStatus = $fileTransferStatusConnecting
			Return "Connecting"
		Case $aStatus = $fileTransferStatusWaitingForAccept
			Return "Waiting for Accept"
		Case $aStatus = $fileTransferStatusTransferring
			Return "Transferring"
		Case $aStatus = $fileTransferStatusTransferringOverRelay
			Return "Transferring over Relay"
		Case $aStatus = $fileTransferStatusPaused
			Return "Paused"
		Case $aStatus = $fileTransferStatusRemotelyPaused
			Return "Remotely Paused"
		Case $aStatus = $fileTransferStatusCancelled
			Return "Cancelled"
		Case $aStatus = $fileTransferStatusCompleted
			Return "Completed"
		Case $aStatus = $fileTransferStatusFailed
			Return "Failed"      
	EndSelect
EndFunc

Func FTFailureReasonToText($aReason)
	Select
		Case $aReason = $fileTransferFailureReasonSenderNotAuthorized
			Return "Sender Not Authorized"
		Case $aReason = $fileTransferFailureReasonRemotelyCancelled
			Return "Remotely Cancelled"
		Case $aReason = $fileTransferFailureReasonFailedRead
			Return "Failed Read"
		Case $aReason = $fileTransferFailureReasonFailedRemoteRead
			Return "Remote Read"
		Case $aReason = $fileTransferFailureReasonFailedWrite
			Return "Write"
		Case $aReason = $fileTransferFailureReasonFailedRemoteWrite
			Return "Remote Write"
		Case $aReason = $fileTransferFailureReasonRemoteDoesNotSupportFT
			Return "Remote Does Not Support FT"
		Case $aReason = $fileTransferFailureReasonRemoteOfflineTooLong
			Return "Remote Offline Too Long"
  EndSelect
EndFunc

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