#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.0
 Author:         Andy Flesner (Airwolf123)

 Script Function:
	Skype COM Example - Plugins.vbs
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

Const $pluginContextChat = 0
Const $pluginContextCall = 1
Const $pluginContextContact = 2
Const $pluginContextMyself = 3
Const $pluginContextTools = 4

Const $pluginContactTypeUndefined = -1
Const $pluginContactTypeAll = 0  
Const $pluginContactTypeSkype = 1  
Const $pluginContactTypeSkypeOut= 2 

Const $pluginIconPath = "c:\temp\icon.png"  

Global $bEventClicked = False

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

$oMenu1 = $oSkype.Client.CreateMenuItem("menu1", $pluginContextContact, ""&_
  "Single Contact of Any Type", "Plugin that does cool stuff for single contact of any type", $pluginIconPath, True, $pluginContactTypeAll)

$oMenu2 = $oSkype.Client.CreateMenuItem("menu2", $pluginContextContact, ""&_
  "Single Skype Contact", "Plugin that does cool stuff for single Skype contact", $pluginIconPath, True, $pluginContactTypeSkype, False)

$oMenu3 = $oSkype.Client.CreateMenuItem("menu3", $pluginContextContact, ""&_
  "Multiple Skype Contacts", "Plugin that does cool stuff for multple contacts", $pluginIconPath, True, $pluginContactTypeSkype, True)

$oMenu4 = $oSkype.Client.CreateMenuItem("menu4", $pluginContextContact, ""&_
  "Single SkypeOut Contact", "Plugin that does cool stuff for a single SkypeOut contact", $pluginIconPath, True, $pluginContactTypeSkypeOut, False)

$oMenu5 = $oSkype.Client.CreateMenuItem("menu5", $pluginContextContact, ""&_
  "Multiple SkypeOut Contacts", "Plugin that does cool stuff for a one or more SkypeOut contacts", $pluginIconPath, True, $pluginContactTypeSkypeOut, True)
  
$oMenu6 = $oSkype.Client.CreateMenuItem("menu6", $pluginContextCall, ""&_
  "Single Participant Call", "Plugin that does cool stuff in a call", $pluginIconPath, True, $pluginContactTypeUndefined, False)

$oMenu7 = $oSkype.Client.CreateMenuItem("menu7", $pluginContextCall, ""&_
  "Multiple Participants Call", "Plugin that does cool stuff in a conference call", $pluginIconPath, True, $pluginContactTypeUndefined, True)
  
$oMenu8 = $oSkype.Client.CreateMenuItem("menu8", $pluginContextChat, ""&_
  "Single Chat Member", "Plugin that does cool stuff for one-to-one chat", $pluginIconPath, True, $pluginContactTypeUndefined, False)

$oMenu9 = $oSkype.Client.CreateMenuItem("menu9", $pluginContextChat, ""&_
  "Multiple Chat Members", "Plugin that does cool stuff in group chat", $pluginIconPath, True, $pluginContactTypeUndefined, True)
  
$oMenu10 = $oSkype.Client.CreateMenuItem("menu10", $pluginContextTools, ""&_
  "Tools plugin", "Plugin that does cool stuff in tools menu", $pluginIconPath, True, $pluginContactTypeUndefined, False)

$oEvent = $oSkype.Client.CreateEvent("event1","Plugin example is running","Click here to stop the example")
While Not $bEventClicked
	Sleep(1000)
WEnd
$oEvent.Delete
$oMenu1.Delete
$oMenu2.Delete
$oMenu3.Delete
$oMenu4.Delete
$oMenu5.Delete
$oMenu6.Delete
$oMenu7.Delete
$oMenu8.Delete
$oMenu9.Delete
$oMenu10.Delete

Func Skype_PluginEventClicked($aEvent)
	MsgBox(0,"","Event "& $aEvent.Id &" clicked.")
	$bEventClicked = True  
EndFunc

Func Skype_PluginMenuItemClicked($aMenuItem, $aUsers, $aPluginContext, $aContextId)
	MsgBox(0,"","Menu item ["& $aMenuItem.Id &"] context [" & pluginContextToText($aPluginContext) & "] id ["& $aContextId &"] clicked.")
	For $oUser In $aUsers
		MsgBox(0,""," User: "& $oUser.FullName &" (" & $oUser.Handle &")")
	Next
EndFunc

Func pluginContextToText($context)
	Select
		Case $context = $pluginContextChat
			Return "Chat"
		Case $context = $pluginContextCall
			Return "Call"
		Case $context = $pluginContextContact
			Return "Contact"
		Case $context = $pluginContextMyself
			Return "Myself"
		Case $context = $pluginContextTools
			Return "Tools"      
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