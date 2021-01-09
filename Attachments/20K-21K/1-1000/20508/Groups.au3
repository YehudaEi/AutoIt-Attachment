#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.0
 Author:         Andy Flesner (Airwolf123)

 Script Function:
	Skype COM Example - Groups.vbs
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

;// Create a custom group:
$oMyGroup = $oSkype.CreateGroup("MyGroup")

;// Add user "echo123" to the group:
$oMyGroup.AddUser("echo123")

;// List the users in MyGroup and return the Skypename of each user:
MsgBox(0,"","Group ("& $oMyGroup.Id &") labelled ["& $oMyGroup.DisplayName &"] has " & $oMyGroup.Users.Count & " users.")
For $oUser In $oMyGroup.Users
	MsgBox(0,"",$oUser.Handle & " ("& $oUser.FullName &")")
Next

;// Remove a user from a group:
$oMyGroup.RemoveUser("echo123")
  
;// Delete a custom group:
$oSkype.DeleteGroup($oMyGroup.Id)

;// List all groups:
MsgBox(0,"","There are total " & $oSkype.Groups.Count & " groups (" & $oSkype.CustomGroups.Count & " custom and " & $oSkype.HardwiredGroups.Count & " hardwired)")

;// List all custom groups:
$msgstring = "Custom groups are:"
For $oGroup In $oSkype.CustomGroups
	$msgstring = $msgstring & @CR & "Group ("& $oGroup.Id &") labelled ["& $oGroup.DisplayName &"] has " & $oGroup.Users.Count & " users."
	For $oUser In $oGroup.Users
		$msgstring = $msgstring & @CR & $oUser.Handle & " ("& $oUser.FullName &")"
	Next
	MsgBox(0,"",$msgstring)
Next

;// List all hardwired groups and return the Skypename and full name of each member of each group:
$msgstring = "Hardwired groups are:" 
For $oGroup In $oSkype.HardwiredGroups
	$msgstring = $msgstring & @CR & "Group ("& $oGroup.Id &") type of ["& $oSkype.Convert.GroupTypeToText($oGroup.Type) &"] has " & $oGroup.Users.Count & " users."
	For $oUser In $oGroup.Users
		$msgstring = $msgstring & @CR & $oUser.Handle & " ("& $oUser.FullName &")"
	Next
	MsgBox(0,"",$msgstring)
Next

;// Keep the script running for 60 seconds:
Sleep(60000)

;// The GroupVisible event handler returns information about whether a group is visible or hidden:
Func Skype_GroupVisible($aGroup, $aVisible)     
	$msgstring = "Group ("& $aGroup.Id &") type of ["& $oSkype.Convert.GroupTypeToText($aGroup.Type) &"] labelled ["& $aGroup.DisplayName &"]"
	If $aVisible Then
		$msgstring = $msgstring & " is visible."
	Else
		$msgstring = $msgstring & " is hidden."
	EndIf
	MsgBox(0,"",$msgstring)
EndFunc

;// The GroupExpanded event handler returns information about whether a group is expanded or collapsed:
Func Skype_GroupExpanded($aGroup, $aExpanded)     
	$msgstring = "Group ("& $aGroup.Id &") type of ["& $oSkype.Convert.GroupTypeToText($aGroup.Type) &"] labelled ["& $aGroup.DisplayName &"]"
	If $aExpanded Then
		$msgstring = $msgstring & " is expanded."
	Else
		$msgstring = $msgstring & " is collapsed."
	EndIf
	MsgBox(0,"",$msgstring)
EndFunc

;// The GroupUsers event handler gets the Skypenames of members of a group:
Func Skype_GroupUsers($aGroup, $aUsers)     
	$msgstring = "Group ("& $aGroup.Id &") type of ["& $oSkype.Convert.GroupTypeToText($aGroup.Type) &"] labelled ["& $aGroup.DisplayName &"] users"
	Dim $oUser
	For $oUser In $aUsers
		$msgstring = $msgstring & @CR & " " & $oUser.Handle
	Next
	MsgBox(0,"",$msgstring)
EndFunc

;// Delete a group:
Func Skype_GroupDeleted($aGroupId)     
	MsgBox(0,"","Group " & $aGroupId & " deleted.")
EndFunc

;// Bring a contact into focus:
Func Skype_ContactsFocused($aHandle)     
	If StringLen($aHandle) Then
		MsgBox(0,"","Contact " & $aHandle & " focused.")
	Else
		MsgBox(0,"","No contact focused.")
	EndIf  
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