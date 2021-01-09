#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.0
 Author:         Andy Flesner (Airwolf123)

 Script Function:
	Skype COM Example - Command.vbs
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

Global $oSearchCommand

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
$oSkype.Attach()

;// Skype4COM can send two types of command; blocking commands and non-blocking commands. Blocking is defined as a Boolean variant of the command object and the default value is False, non-blocking. A blocking command awaits a reply before continuing. A non-blocking command does not require a reply. 

;// Send the following non-blocking commands:
$oSkype.SendCommand($oSkype.Command(0, "FOCUS"))
$oSkype.SendCommand($oSkype.Command(1, "GET AUDIO_IN", "AUDIO_IN"))
$oSkype.SendCommand($oSkype.Command(2, "GET AUDIO_OUT", "AUDIO_OUT"))
Sleep(1000)

;// Send the following blocking commands (note the True (blocking) variant for each command):
$oSkype.SendCommand($oSkype.Command(3, "GET CURRENTUSERHANDLE", "CURRENTUSERHANDLE", True))
$oSkype.SendCommand($oSkype.Command(4, "GET USER echo123 FULLNAME", "USER echo123 FULLNAME", True))
$oSkype.SendCommand($oSkype.Command(5, "GET USER echo123 DISPLAYNAME", "USER echo123 DISPLAYNAME", True))
$oSkype.SendCommand($oSkype.Command(6, "GET USER echo123 COUNTRY", "USER echo123 COUNTRY", True))
Sleep(1000)

;//As with command objects, search commands can be defined as blocking or non-blocking, and the default value is False, non-blocking. A blocking search requires a response before activities continue. Following is a blocking search (note the True (blocking) variant:
$oBlockingSearch = $oSkype.Command(8888, "SEARCH USERS echo123", "USERS ", True)
$oSkype.SendCommand($oBlockingSearch)
MsgBox(0,"","Search Result: " & $oBlockingSearch.Reply)

;//A non-blocking search does not require a response:
$oSearchCommand = $oSkype.Command(9999, "SEARCH USERS john doe", "USERS ")
$oSkype.SendCommand($oSearchCommand)

MsgBox(0,"","Sleeping ...")
Sleep(30000)

;// The AttachmentStatus event handler monitors attachment status and automatically attempts to reattach to the API following loss of connection:
Func Skype_AttachmentStatus($aStatus)
	MsgBox(0,"","Attachment status " & $oSkype.Convert.AttachmentStatusToText($aStatus))
	If $aStatus = $oSkype.Convert.TextToAttachmentStatus("AVAILABLE") Then
		$oSkype.Attach()
	EndIf
EndFunc

;// The reply event handler monitors the non-blocking search results:
Func Skype_Reply($aCmd)  
	If IsObj($oSearchCommand) Then 
		If $oSearchCommand.Id = $aCmd.Id Then
			MsgBox(0,"","Search Finished!")
		EndIf
	EndIf
EndFunc

Func MyErrFunc()
	;Do Nothing
EndFunc