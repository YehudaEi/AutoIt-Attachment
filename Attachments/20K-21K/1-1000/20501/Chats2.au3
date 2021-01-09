#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.0
 Author:         Andy Flesner (Airwolf123)

 Script Function:
	Skype COM Example - Chats2.vbs
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
Const $chatTypeUnknown = -1
Const $chatTypeDialog = 0
Const $chatTypeLegacyDialog = 1
Const $chatTypeLegacyUnsubscribed = 2
Const $chatTypeMultiChat = 3
Const $chatTypeSharedGroup = 4
Const $chatMemberRoleUnknown = -1
Const $chatMemberRoleCreator = 0
Const $chatMemberRoleMaster = 1
Const $chatMemberRoleHelper = 2
Const $chatMemberRoleUser = 3
Const $chatMemberRoleListener = 4
Const $chatMemberRoleApplicant = 5
Const $chatStatusUnknown = -1
Const $chatStatusConnecting = 0
Const $chatStatusWaitingRemoteAccept = 1
Const $chatStatusAcceptRequired = 2
Const $chatStatusPasswordRequired = 3
Const $chatStatusSubscribed = 4
Const $chatStatusUnsubscribed = 5
Const $chatStatusDisbanded = 6
Const $chatStatusQueuedBecauseChatIsFull = 7
Const $chatStatusApplicationDenied = 8
Const $chatStatusKicked = 9
Const $chatStatusBanned = 10
Const $chatStatusRetryConnecting = 11

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

;// Query properties of all recent chats:
For $oChat In $oSkype.RecentChats
	MsgBox(0,"","Recent chats:" & @CR & @CR & displayChatProperties($oChat))
Next  

;// Query properties of all bookmarked chats:
For $oChat In $oSkype.BookmarkedChats
  MsgBox(0,"","Bookmarked chats:" & @CR & @CR & displayChatProperties($oChat))
Next

;// Returns chat properties as string
Func displayChatProperties($aChat)
	$output = "Label: " & $aChat.FriendlyName
	$output = $output & @CR & "Created at: " & $aChat.Timestamp
	$output = $output & @CR & "Last activity at: " & $aChat.ActivityTimestamp
	$output = $output & @CR & "Id: " & $aChat.Name
	$output = $output & @CR & "Blob: " & $aChat.Blob
	$output = $output & @CR & "Description: " & $aChat.Description
	$output = $output & @CR & "Guidelines: " & $aChat.Guidelines
	$output = $output & @CR & "My role: " & chatMemberRoleToText($aChat.MyRole)
	$output = $output & @CR & "My status: " & chatStatusToText($aChat.MyStatus)
	$output = $output & @CR & "Type: " & chatTypeToText($aChat.Type)
	If $aChat.Type = $chatTypeDialog Or $aChat.Type = $chatTypeLegacyDialog Then
		$output = $output & @CR & "Dialog partner: " & $aChat.DialogPartner
	EndIf
	If $aChat.Members.Count > 0 Then 
		$output = $output & @CR & "Members:" 
		For $oMember In $aChat.Members
			$output = $output & @CR & " " & $oMember.Handle
		Next 
	EndIf
	If $aChat.Applicants.Count > 0 Then 
		$output = $output & @CR & "Applicants:" 
		For $oApplicant In $aChat.Applicants
			$output = $output & @CR & " " & $oApplicant.Handle
		Next 
	EndIf
	Return $output
EndFunc

;// Converts chat types to plaintext
Func chatTypeToText($aType)
	Select 
		Case $aType = $chatTypeUnknown
			Return "Unknown"
		Case $aType = $chatTypeDialog
			Return "Dialog"
		Case $aType = $chatTypeLegacyDialog
			Return "Legacy Dialog"
		Case $aType = $chatTypeLegacyUnsubscribed
			Return "Unsubscribed Legacy Dialog"
		Case $aType = $chatTypeMultiChat
			Return "Multichat"
		Case $aType = $chatTypeSharedGroup
			Return "Shared Group"
	EndSelect  
EndFunc

;// Converts chat roles to plaintext
Func chatMemberRoleToText($aRole)
	Select
		Case $aRole = $chatMemberRoleUnknown
			Return "Unknown"
		Case $aRole = $chatMemberRoleCreator
			Return "Creator"
		Case $aRole = $chatMemberRoleMaster
			Return "Master"
		Case $aRole = $chatMemberRoleHelper
			Return "Helper"
		Case $aRole = $chatMemberRoleUser
			Return "User"
		Case $aRole = $chatMemberRoleListener
			Return "Listener"
		Case $aRole = $chatMemberRoleApplicant
			Return "Applicant"      
	EndSelect  
EndFunc

;// Converts chat status to plaintext
Func chatStatusToText($aStatus)
	Select
		Case $aStatus = $chatStatusUnknown
			Return "Unknown"
		Case $aStatus = $chatStatusConnecting
			Return "Connecting"      
		Case $aStatus = $chatStatusWaitingRemoteAccept
			Return "Waiting for Remote Accept"      
		Case $aStatus = $chatStatusAcceptRequired
			Return "Accept Required"      
		Case $aStatus = $chatStatusPasswordRequired
			Return "Password Required"      
		Case $aStatus = $chatStatusSubscribed
			Return "Subscribed"      
		Case $aStatus = $chatStatusUnsubscribed
			Return "Unsubscribed"      
		Case $aStatus = $chatStatusDisbanded
			Return "Disbanded"      
		Case $aStatus = $chatStatusQueuedBecauseChatIsFull
			Return "Queued"      
		Case $aStatus = $chatStatusApplicationDenied
			Return "Application Denied"      
		Case $aStatus = $chatStatusKicked
			Return "Kicked"      
		Case $aStatus = $chatStatusBanned
			Return "Banned"      
		Case $aStatus = $chatStatusRetryConnecting
			Return "Reconnecting"      
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