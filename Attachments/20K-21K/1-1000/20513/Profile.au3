#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.0
 Author:         Andy Flesner (Airwolf123)

 Script Function:
	Skype COM Example - Profile.vbs
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

;// List the profile properties for the user:
$msgstring = "Full name: " & $oSkype.CurrentUserProfile.FullName
$msgstring = $msgstring & @CR & "Birthday: " & $oSkype.CurrentUserProfile.Birthday
$msgstring = $msgstring & @CR & "Sex: " & $oSkype.CurrentUserProfile.Sex
$msgstring = $msgstring & @CR & "Languages: " & $oSkype.CurrentUserProfile.Languages
$msgstring = $msgstring & @CR & "Country: " & $oSkype.CurrentUserProfile.Country
$msgstring = $msgstring & @CR & "IP Country: " & $oSkype.CurrentUserProfile.IPCountry
$msgstring = $msgstring & @CR & "Province: " & $oSkype.CurrentUserProfile.Province
$msgstring = $msgstring & @CR & "City: " & $oSkype.CurrentUserProfile.City
$msgstring = $msgstring & @CR & "Phone home: " & $oSkype.CurrentUserProfile.PhoneHome
$msgstring = $msgstring & @CR & "Phone office: " & $oSkype.CurrentUserProfile.PhoneOffice
$msgstring = $msgstring & @CR & "Phone mobile: " & $oSkype.CurrentUserProfile.PhoneMobile
$msgstring = $msgstring & @CR & "Homepage: " & $oSkype.CurrentUserProfile.Homepage
$msgstring = $msgstring & @CR & "About: " & $oSkype.CurrentUserProfile.About
$msgstring = $msgstring & @CR & "Mood: " & $oSkype.CurrentUserProfile.MoodText
$msgstring = $msgstring & @CR & "Timezone: " & $oSkype.CurrentUserProfile.Timezone
$msgstring = $msgstring & @CR & "Noanswer timeout: " & $oSkype.CurrentUserProfile.CallNoAnswerTimeout
$msgstring = $msgstring & @CR & "Forward rules: " & $oSkype.CurrentUserProfile.CallForwardRules
$msgstring = $msgstring & @CR & "Call apply forward: " & $oSkype.CurrentUserProfile.CallApplyCF
$msgstring = $msgstring & @CR & "Call send to voicemail: " & $oSkype.CurrentUserProfile.CallSendToVM
$msgstring = $msgstring & @CR & "Balance: " & $oSkype.CurrentUserProfile.Balance / 100 &" "& $oSkype.CurrentUserProfile.BalanceCurrency
$msgstring = $msgstring & @CR & "Balance Text: " & $oSkype.CurrentUserProfile.BalanceToText
$msgstring = $msgstring & @CR & "Validated SMS numbers: " & $oSkype.CurrentUserProfile.ValidatedSmsNumbers
MsgBox(0,"",$msgstring)

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