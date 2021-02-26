;------------------------------------------------------------------------------
;
; AutoIt Version: 3.0
;
; Script Function:
;  Join Domain - A GUI to join a Active Directory domain by specifying the OU
;
;  Requires:
;  Latest version of AutoIT with COM Support
;  	
;
; Author:         Walt Howd
;
; Version 1.0   03/04/2006  Initial internal release
; Version 1.1   05/05/2006  Small update. Added prompt for username and password.
;
; Copyright Walt Howd
;
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
;
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; Includes and AutoIT Options
;------------------------------------------------------------------------------
#NoTrayIcon
#Include <GUIConstants.au3>
#Include <GuiListView.au3>
#Include <Array.au3>

;------------------------------------------------------------------------------
; Domain details
;
; Change these three lines to match your enviroment
;------------------------------------------------------------------------------
$adDefaultContext	= "DC=BC,DC=EDU"
$adDomainController	= "c-utility.bc.edu"
$adDomain		= "BCEDU"

;------------------------------------------------------------------------------
; Username and password
;
; If you wish to be prompted for these values instead of hardcoding them
; here you may leave these blank.
;------------------------------------------------------------------------------
$adUsername		= ""
$adPassword		= ""

;------------------------------------------------------------------------------
; Active Directory Constants
;------------------------------------------------------------------------------
Const $ldapConnectionString 	= "LDAP://" & $adDomainController & "/" & $adDefaultContext
Const $ouIdentifier		= "OU="
Const $cnIdentifier		= "CN="
Const $ouSeparator		= ","

;------------------------------------------------------------------------------
; GUI Look and Feel Configuration
;------------------------------------------------------------------------------
$guiWidth		= 640
$guiHeight		= $guiWidth * 0.75
$guiOffset		= $guiHeight / 32
$guiBannerMessage	= "Broward College - Join Domain Tool"
$guiWindowTitle		= "Join Domain Tool"
$guiTooManyResultsTitle	= "Too many results found - Please select one"
$guiJoinButtonTitle	= "Join Domain"
$guiListOUSButtonTitle	= "List all OUs"
$guiProgressMessage	= "Please wait while querying Active Directory"

;------------------------------------------------------------------------------
; Prompt for the username if it is not hardcoded above
;------------------------------------------------------------------------------
If $adUsername = "" Then
	$adUsername        = InputBox("Input username", "Please enter the username of the account you wish to use to " & _
					"join the domain. This should be just the username." & @LF & @LF & _
					"Example:" & @LF & "jdoe")
	If @error Then 
		MsgBox(0, "Error with username - " & @error, "There was an error proccessing your username." & @LF & @LF & _
				"The username I received was:" & @LF & _
				$adUsername & @LF & @LF & _
				"Please restart this application and try again. If this problem persists you can try" & _
				"hard coding this information into this program by editing the source file.")
		Exit(900)
	EndIf
EndIf

;------------------------------------------------------------------------------
; Prompt for the password if it is not hardcoded above
;------------------------------------------------------------------------------
If $adPassword = "" Then
	$adPassword        = InputBox("Input password","Please enter the password:",'','*')
	If @error Then 
		MsgBox(0, "Error with password - " & @error, "There was an error proccessing your password." & @LF & @LF & _
				"Please restart this application and try again. If this problem persists you can try" & _
				"hard coding this information into this program by editing the source file.")
		Exit(901)
	EndIf
EndIf

;------------------------------------------------------------------------------
; Initiate our COM object to connect to Active Directory
;------------------------------------------------------------------------------
$comError 		= ObjEvent("AutoIt.Error", "comError")
$ldapObj		= objGet("LDAP:")
$domain 		= $ldapObj.OpenDsObject($ldapConnectionString, $adUsername, $adPassword, 1)
If @error Then
	MsgBox(0,	"Error connecting to Active Directory", "Error - " & @error & @LF & @LF & _ 
			"Could not connect to Active Directory." & @LF & @LF & _
			"Please check your network connectivity, that your LDAP connection string " & @LF & _
			"is set correctly and that the embedded credentials in this script are valid." & @LF & @LF & _
			"LDAP Connection String:" & @LF & _
			$ldapConnectionString & @LF & @LF & _
			"Username:" & @LF & _
			$adUsername)
	GUIDelete()
	Exit(1000)
EndIf

;------------------------------------------------------------------------------
; Initiate our ADO connection to Active Directory
;------------------------------------------------------------------------------
$connObj		= objCreate("ADODB.Connection")
$connObj.Provider	= "ADsDSOObject"
$connObj.ConnectionTimeout = "1"
$connObj.Open("Active Directory Provider", $adDomain & "\" & $adUsername, $adPassword)

;------------------------------------------------------------------------------
; Find and store the computer name of the system running this program
;------------------------------------------------------------------------------
$computername	= returnComputerName()

;------------------------------------------------------------------------------
; Create the GUI
;------------------------------------------------------------------------------
$joinDomainGUI		= GUICreate($guiWindowTitle,$guiWidth,$guiHeight,-1,-1,BitOr($WS_MINIMIZEBOX,$WS_MAXIMIZEBOX,$WS_GROUP,$WS_CAPTION,$WS_POPUP,$WS_SYSMENU))

;------------------------------------------------------------------------------
; Create the banner text
;------------------------------------------------------------------------------
$bannerText		= GuiCtrlCreateLabel($guiBannerMessage, $guiOffset,$guiOffset, $guiWidth*0.75)
$bannerTextFont		= GUICtrlSetFont($bannerText, 10, 600)

;------------------------------------------------------------------------------
; Create our Join Domain button
;------------------------------------------------------------------------------
$joinButton 		= GUICtrlCreateButton ($guiJoinButtonTitle,$guiOffset,$guiOffset*3,($guiWidth/3),$guiOffset*2)

;------------------------------------------------------------------------------
; Create the TreeView - This is where all the OU's will be listed
;------------------------------------------------------------------------------
$defaultTreeView	= GUICtrlCreateTreeView ($guiOffset,$guiOffset*10,($guiWidth-($guiOffset*2)),($guiHeight-($guiOffset*11)) )

;------------------------------------------------------------------------------
; Create the control to handle too many hits from an Object Search
; This will be hidden until a search with multiple hits is performed
;------------------------------------------------------------------------------
$tooManyObjectsList 	= GuiCtrlCreateListView("Name|OU", $guiOffset,$guiOffset*10,($guiWidth-($guiOffset*2)),($guiHeight-($guiOffset*11)))
$hideTooManyObjectsList	= GuiCtrlSetState($tooManyObjectsList, $GUI_HIDE);

;------------------------------------------------------------------------------
; Create the Progress Bar and Text controls
;------------------------------------------------------------------------------
$progressGroup		= GUICtrlCreateGroup("Progress", $guiOffset, $guiOffset*6, $guiWidth-($guiOffset*2), "54")
$progressBar		= GUICtrlCreateProgress($guiOffset*1.5,$guiOffset*7,($guiWidth-($guiOffset*3)),$guiOffset*1)
$progessBarStartAtZero  = GuiCtrlSetData ($progressBar, 0)
$progressText		= GuiCtrlCreateLabel($guiProgressMessage, $guiOffset*1.5,$guiOffset*8.5,($guiWidth-($guiOffset*3)),$guiOffset*1)

;------------------------------------------------------------------------------
; Create the Object search controls
;------------------------------------------------------------------------------
$objectSearchGroup	= GUICtrlCreateGroup("Search", $guiWidth-($guiOffset*14), $guiOffset-5, "195", "80")
$objectSearchLabel	= GuiCtrlCreateLabel("Enter username, computer or OU:", $guiWidth-($guiOffset*13), $guiOffset*2)
$objectSearchInput	= GUICtrlCreateInput("", $guiWidth-($guiOffset*13), $guiOffset*3, "100")
$objectSearchButton	= GUICtrlCreateButton("Search", $guiWidth-($guiOffset*5), $guiOffset*3)

;------------------------------------------------------------------------------
; Disable the buttons until our OU enumeration is done
;------------------------------------------------------------------------------
$disableJoinButton		= GUICtrlSetState($joinButton, $GUI_DISABLE);
$disableObjectSearchButton 	= GUICtrlSetState($objectSearchButton, $GUI_DISABLE);

;------------------------------------------------------------------------------
; Make the GUI Visible
;------------------------------------------------------------------------------
$joinDomainGUIVisible	= GUISetState(@SW_SHOW, $joinDomainGUI)

;------------------------------------------------------------------------------
; Query for all organizational units
;------------------------------------------------------------------------------
$allOUStringSepByLF	= returnObjectDN("*", "organizationalUnit");
If $allOUStringSepByLF <> "0" Then
	$allOUsArray 		= StringSplit($allOUStringSepByLF, @LF, 1)
	$deleteStringSplitCount	= _ArrayDelete($allOUsArray, 0)
Else
	MsgBox(0,	"Could not query Active Directory", "Could not query Active Directory via ADO." & @LF & @LF & _
			"Please check your network connectivity, that your LDAP connection string " & @LF & _
			"is set correctly and that the embedded credentials in this script are valid." & @LF & @LF & _
			"LDAP Connection String:" & @LF & _
			$ldapConnectionString & @LF & @LF & _
			"Username:" & @LF & _
			$adUsername & @LF & @LF & _
			"Password:" & @LF & _
			$adPassword)
	GUIDelete()
	Exit(1001)
EndIf
			
;------------------------------------------------------------------------------
; Reverse the order of all the OUs so we can do an easy alpabetical sort
; on the names
;------------------------------------------------------------------------------						
Dim $reversedAllOUsArray[1]
For $ou in $allOUsArray
	$reversedOU 	= returnReversedOU($ou)
	$arrayAddStatus = _ArrayAdd($reversedAllOUsArray, $reversedOU)	
Next

;------------------------------------------------------------------------------
; Sort the array alpabetically
;------------------------------------------------------------------------------
$sortRevArrayStatus	= _ArraySort($reversedAllOUsArray)		

;------------------------------------------------------------------------------
; Initialize our treeIDArray
; This will be used to look up the ID number of the GUI TreeView entries
; We need this to make nesting/child-parent relationships work.
;------------------------------------------------------------------------------
Dim $treeIDArray[UBound($reversedAllOUsArray)*2]

;------------------------------------------------------------------------------
; Return the OUs to their original format and create the TreeView Entries.
;------------------------------------------------------------------------------
$adCurrentObjectNumber = 0
For $reversedOU in $reversedAllOUsArray
	If $reversedOU = "" then 
		ContinueLoop
	EndIf
	
	;------------------------------------------------------------------------------
	; Reverse the order back to the orginal format 	
	;------------------------------------------------------------------------------	
	$ou				= returnReversedOU($reversedou)
	
	;------------------------------------------------------------------------------
	; Calculate the additional values for this OU and check to see if its
	; parentou has a GUI TreeID
	;------------------------------------------------------------------------------		
	$fullOU				= StringStripWS($ou, 3)			
	$friendlyOU			= returnFriendlyName($fullOU)			
	$parentFullOU			= returnParentOU($fullOU)			
	$parentTreeID			= _ArraySearch($treeIDArray, $parentFullOU)
	
	;------------------------------------------------------------------------------
	; Check if this OU has a parent. If it does make this TreeView item a child
	; of that parent.
	;------------------------------------------------------------------------------
	If ( $parentTreeID <> "-1" ) Then	
		$treeID 		= GUICtrlCreateTreeViewItem ($friendlyOU, $parentTreeID)
	Else	
		$treeID			= GUICtrlCreateTreeViewItem ($friendlyOU, $defaultTreeView)
	EndIf	

	;------------------------------------------------------------------------------
	; The returned $treeID is sequential. We can use this to cheat and emulate
	; a hashtable.
	;------------------------------------------------------------------------------
	$treeIDArray[$treeID] = $fullOU
	
	;------------------------------------------------------------------------------
	; Update the progress bar and increment the object count
	;------------------------------------------------------------------------------		
	UpdateProgressBar(($adCurrentObjectNumber / UBound($allOUsArray)) * 100)
	UpdateProgressText($guiProgressMessage & " - Currently querying " & $friendlyOU)
	$adCurrentObjectNumber = $adCurrentObjectNumber + 1	
Next

;------------------------------------------------------------------------------
; Query is complete, update Progress Text
;------------------------------------------------------------------------------
UpdateProgressText("Please select an OU to join from the list below.")

;------------------------------------------------------------------------------
; Check and see if this computername is already present in AD
;------------------------------------------------------------------------------
$computersCN = returnObjectDN($computername, "computer")
If $computersCN <> "0" Then
	$computersOU = returnFullOUfromDN($computersCN)	
	UpdateProgressText("Found this computer (" & $computername & ") in the " & _
				returnFriendlyName($computersOU) & " OU - This has been selected " & _
				"for you below.")
	GuiCtrlSetState(_ArraySearch($treeIDArray, $computersOU), $GUI_FOCUS)
EndIf

;------------------------------------------------------------------------------
; Enable the buttons
;------------------------------------------------------------------------------
$enableJoinButton		= GUICtrlSetState($joinButton, $GUI_ENABLE);
$enableObjectSearchButton 	= GUICtrlSetState($objectSearchButton, $GUI_ENABLE);

;------------------------------------------------------------------------------
; GUI Message Loop
;------------------------------------------------------------------------------
While 1
	$msg 		= GUIGetMsg()
	Select
		;-----------------------------------------------------------------------------------
		; User clicked "Close" button
		;-----------------------------------------------------------------------------------
		Case $msg = -3 Or $msg = -1 

			GUIDelete()
			ExitLoop
			
		;-----------------------------------------------------------------------------------
		; User clicked "Join Domain" button
		;-----------------------------------------------------------------------------------			
		Case $msg = $joinButton
			If GUICtrlRead($defaultTreeView) <> 0 Then
				$selectedOU	= $treeIDArray[GUICtrlRead($defaultTreeView)]				
				
				;-----------------------------------------------------------------------------------
				; Check if the OU selected matches OU in which this computer already exists (if any)
				;
				; If so prompt the user to see if they really want to join this different OU
				;-----------------------------------------------------------------------------------
				$computername	= returnComputerName()
				$computerDN	= returnObjectDN($computername, "computer")
				$existingOU	= returnFullOUfromDN($computerDN)
				If $existingOU <> "0" AND $existingOU <> $selectedOU Then
					$attemptJoin = MsgBox(4, "Computer exists in a different OU", "This computer already exists in a different OU." & @LF & @LF & _
					"A computer with this name (" & $computername & ") already exists in another OU." & @LF & @LF & _
					"The existing OU::" & @LF & _
					$existingOU & @LF & @LF & _
					"The OU you selected:" & @LF & _ 
					$selectedOU & @LF & @LF & _
					"Do you want to attempt to join the domain in this OU anway?")	

					;------------------------------------------------------------------------------
					; If user clicked "No" skip out of the loop
					;------------------------------------------------------------------------------
					If $attemptJoin = 7 Then
						ContinueLoop
					EndIf
				EndIf
				
				;------------------------------------------------------------------------------
				; Join the system to the domain
				;------------------------------------------------------------------------------
				$joinDomainResult = joinDomain($selectedOU)
				
				;------------------------------------------------------------------------------
				; If domain join was successfull ask user if they want to restart system
				;------------------------------------------------------------------------------				
				If $joinDomainResult = 0 Then
					$restartQuery = MsgBox(4, "Restart system", "You joined the domain successfully." & @LF & @LF & _
									"Do you want to restart now?")
					
					if $restartQuery = 6 Then
						Shutdown(6)
					EndIf
					
					GuiDelete()
					Exit
				;------------------------------------------------------------------------------
				; If domain join failed notify user and try to give them a pertitent error
				; message
				;------------------------------------------------------------------------------
				Else
					MsgBox(0, "Domain Join Failed (" & $joinDomainResult & ")", "I wasn't able to join the domain successfully." & @LF & @LF & _
						$joinDomainResult)	
				EndIF				
			Else
				;------------------------------------------------------------------------------
				; If the user forgot to select an OU from the TreeView
				;------------------------------------------------------------------------------
				MsgBox(0, "Oopsies", "You must select an OU to join. Please select one from the list below.")
			EndIf	
		;-----------------------------------------------------------------------------------
		; User searched for an Object
		;-----------------------------------------------------------------------------------	
		Case $msg = $objectSearchButton
			$objectSearchedFor 	= StringStripWS(GUICtrlRead($objectSearchInput), 3)				
			$objectsDN 		= returnObjectDN($objectSearchedFor, "*")
			$objectsDNArray		= StringSplit($objectsDN, @LF)	
			$deleteStringSplitCount = _ArrayDelete($objectsDNArray, 0)
					
			;-----------------------------------------------------------------------------------
			; If we found just one record, highlight it in the TreeView
			;-----------------------------------------------------------------------------------
			If $objectsDN <> "0" AND UBound($objectsDNArray) = 1 Then
				$objectsOU = returnFullOUfromDN($objectsDN)
				
				GuiCtrlSetState(_ArraySearch($treeIDArray, $objectsOU), $GUI_FOCUS)
				
				UpdateProgressText("Found this object (" & $objectSearchedFor & ") in the " & _
						     returnFriendlyName($objectsOU) & " OU - This has been selected " & _
						     "for you below.")
			;-----------------------------------------------------------------------------------
			; If we found more then one record let the user choose which one they wanted
			;-----------------------------------------------------------------------------------						     
			ElseIf $objectsDN <> "0" AND UBound($objectsDNArray) > 1 Then
				MsgBox(0, "Too many matching objects found", "Too many matching objects found for your search term (" & $objectSearchedFor & ")" & @LF & @LF & _
					     "Please enter enough information to uniquely identify"  & @LF & _
					     "a single object." & @LF & @LF & _
					     "Objects that matches your search:" & @LF & _
					      $objectsDN)	
					      
				;-----------------------------------------------------------------------------------
				; Delete any entries from the ListView control and then show the control
				;-----------------------------------------------------------------------------------		   
				;$deleteAllListViewItems	= _GUICtrlListViewDeleteAllItems($tooManyObjectsList)
				;$showTooManyObjectsList	= GUICtrlSetState($tooManyObjectsList, $GUI_SHOW)
				
				;-----------------------------------------------------------------------------------
				; Disable the TreeView list of OUs and the JoinDomain button
				;-----------------------------------------------------------------------------------
				;$hideTreeView		= GUICtrlSetState($defaultTreeView, $GUI_HIDE)
				;$disableJoinButton	= GUICtrlSetState($joinButton, $GUI_DISABLE)				
								
				;-----------------------------------------------------------------------------------
				; Update Progress Text
				;-----------------------------------------------------------------------------------
				;UpdateProgressText("Please select the object you were searching for from the list below:")				
				
				;For $objectName in $objectsDNArray
				;	$name 	= returnFriendlyName($objectname);
				;	$ou	= returnFullOUfromDN($objectname)
				;	GuiCtrlCreateListViewItem($name & "|" & $ou, $tooManyObjectsList)
				;Next
			;-----------------------------------------------------------------------------------
			; If we didn't find any records
			;-----------------------------------------------------------------------------------
			ElseIf $objectsDN = 0 Then
				MsgBox(0, "No matching objects found", "No objects were found for your search term (" & $objectSearchedFor & ")" & @LF & @LF & _
					     "Please enter just the object name."  & @LF & @LF & _
					     "Example:" & @LF & _
					     "jdoe" & @LF & @LF & _
					     "You may also use wildcards in your search." & @LF & @LF & _
					     "Example:" & @LF & _
					     "jdoe*")		
			EndIf	
	EndSelect
WEnd
GUIDelete()

;------------------------------------------------------------------------------
; Shared Functions
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; Joins the computer running this script to the domain $adDomain in the
; OU passed to the function
;------------------------------------------------------------------------------	
Func joinDomain($joinDomainOU)

	;------------------------------------------------------------------------------
	; Make sure we got *something* passed as an OU
	;------------------------------------------------------------------------------	
	If $joinDomainOU = "" OR ( StringLen($joinDomainOU) < StringLen($adDomain) ) Then
		MsgBox(0, "Invalid or no OU specified", "No OU was specified for the domain join." & @LF & @LF & _
				"It appears that this program did not correctly specify which OU you were attempting to join." & @LF & @LF & _
				"Please try again and if this error reappears check the configuration.")
	EndIf	

	;------------------------------------------------------------------------------
	; Create our WMI object
	;------------------------------------------------------------------------------	
	$computerObj 	= ObjGet("winmgmts:{impersonationLevel=Impersonate}!\\" & _
			  $computername & "\root\cimv2:Win32_ComputerSystem.Name='" & _
			  $computername & "'")

	;------------------------------------------------------------------------------
	; Attempt domain join
	;------------------------------------------------------------------------------					  
	$joinDomainResultNumber	= $computerObj.JoinDomainOrWorkGroup($adDomain, $adPassword, $adDomain & "\" & $adUsername, $joinDomainOU, 3)				
	
	;------------------------------------------------------------------------------
	; Check our results
	;------------------------------------------------------------------------------	
	Select
		Case $joinDomainResultNumber  = 0
			global $joinDomainResultText = "The domain join completed successfully."
		Case $joinDomainResultNumber  = 5
			global $joinDomainResultText = "The " & $adUsername & " account does not have permissions. Most likely this computer was originally joined to the domain with a Account operator account. The account you are using does not have permissions to overwrite the workstation object"
		Case $joinDomainResultNumber  = 86 Or $joinDomainResultNumber = 1326
			global $joinDomainResultText = "The username or password you specified is incorrect. Check the username and password as they appear below. If these values are incorrect the image will have to be updated with the current values" 
		Case $joinDomainResultNumber  = 1909
			global $joinDomainResultText = "The " & $adUsername & " account is locked out. Most likely someone has tried the password incorrectly too many times. The system sometimes will lock the account out if too many simultaneous connection attempts are occuring."
		Case $joinDomainResultNumber  = 2224
			global $joinDomainResultText = "The computer account already exists on the domain and could not be overwritten. A workstation object with the same name exists in another OU. You will have to have the existing workstation object deleted."
		Case $joinDomainResultNumber  = 2453
			global $joinDomainResultText = "Could not find a domain controller. Please make sure all domain controllers are online and that your network access is functional."
		Case $joinDomainResultNumber  = 2102
			global $joinDomainResultText = "The workstation service is not started. Please start this service and try again."
		Case $joinDomainResultNumber  = 2691
			global $joinDomainResultText = "This machine is already joined to a domain. If you wish to join this system to another domain or this domain again you will first have to unjoin your existing domain."
	EndSelect
	
	return $joinDomainResultNumber
	
EndFunc

;------------------------------------------------------------------------------
; Searches AD via ADO for the DN of an object
; 
;
; If the DN is found then it is returned.
;
; If no match is found then 0 is returned
; 
;
; If more then one match is found then they are returned
; as a single string, separated by linebreaks.
;
; The second paramter dictates the object type to
; search for. It can either by user, computer, or
; organizationalunit. Alternatively it can be an objectclass
; your AD structure supports.
; 
;------------------------------------------------------------------------------	
Func returnObjectDN($objectName, $objectClass)
	$objectsFoundCount			= 0
	Dim $objectsFoundNames
	
	;------------------------------------------------------------------------------
	; Create the ADO object and execute the search
	;------------------------------------------------------------------------------		
	$commandObj				= objCreate("ADODB.Command")
	$commandObj.ActiveConnection 		= $connObj
	$commandObj.CommandText 		= "SELECT distinguishedName FROM '" & $ldapConnectionString & "' " & _
						  "WHERE objectClass='" & $objectClass & "' AND name ='" & $objectName & "'"  
	$commandObj.Properties("Page Size") 	= 10000
	$commandObj.Properties("Cache Results") = True
	$commandObj.Properties("SearchScope") 	= 2

	$objRecordSet				= objCreate("ADODB.Recordset")
	$objRecordSet				= $commandObj.Execute
	
	If($objRecordSet.RecordCount <> "") Then		
		;------------------------------------------------------------------------------
		; Loop through the record set
		;------------------------------------------------------------------------------	
		$objRecordSet.MoveFirst
		While Not $objRecordSet.EOF
			If $objectsFoundCount > 0 Then
				$objectsFoundNames	= $objectsFoundNames & @LF & $objRecordSet.Fields("distinguishedName").Value
			Else 
				$objectsFoundNames	= $objRecordSet.Fields("distinguishedName").Value
			EndIf
			
			$objRecordSet.MoveNext
			$objectsFoundCount= $objectsFoundCount+1
		WEnd

		If $objectsFoundCount > 0 Then
			return $objectsFoundNames
		Else
			return 0;
		EndIf
	Else
		return 0;
	EndIf
EndFunc

;------------------------------------------------------------------------------
;Reverse the order of all the OUs 
;
; Example:
;
; The full OU of:
; OU=IT Shop,OU=Service Groups,DC=domain,DC=com
;
; Is returned as:
; DC=com,DC=domain,OU=Service Groups,OU=IT Shop
; 
; We do this so we can do an easy alphabetical sort
;
; At this time ADO/ADSI doesn't support ORDER BY for
; organizational units
;------------------------------------------------------------------------------	
Func returnReversedOU($ou)
	$subOUArray = StringSplit($ou, $ouSeparator)
	$reversedOU = ""
	For $i = (UBound($subOUArray) - 1 ) To 1 Step -1 
		If $i = (UBound($subOUArray) -  1 ) Then
			$reversedOU = $reversedOU & $subOUArray[$i]
		Else
			$reversedOU = $reversedOU & $ouSeparator & $subOUArray[$i]
		EndIf
	Next
	return $reversedOU
EndFunc

;------------------------------------------------------------------------------
; Replaces the Progress Text control with supplied text
;------------------------------------------------------------------------------	
Func UpdateProgressText($text) 
	GUICtrlSetData($progressText, $text)
EndFunc

;------------------------------------------------------------------------------
; Updates the progress bar to the passed percentage
;------------------------------------------------------------------------------	
Func UpdateProgressBar($percentage)
	GuiCtrlSetData($progressBar, $percentage)
EndFunc

;------------------------------------------------------------------------------
; Will return the current computername of the system running this script
;------------------------------------------------------------------------------	
Func returnComputerName()
	$networkObj 		= ObjCreate("WScript.Network")
	$computerName 		= $networkObj.ComputerName
	return $computerName
EndFunc

;------------------------------------------------------------------------------
; Returns the friendly object name:
;
; Example:
;
; The full OU of:
; OU=IT Shop,OU=Service Groups,DC=domain,DC=com
;
; Is returned as:
; IT Shop
;------------------------------------------------------------------------------	
Func returnFriendlyName($dn)
	return StringMid($dn, StringInStr($dn, "=")+1, StringInStr($dn, $ouSeparator)-(StringInStr($dn, "=")+1))
EndFunc

;------------------------------------------------------------------------------
; Returns the full OU name from a DN record:
;
; Example:
;
; The DN:
; CN=Paula,OU=IT Shop,OU=Service Groups,DC=domain,DC=com
;
; Is returned as:
; OU=IT Shop,OU=Service Groups,DC=domain,DC=com
;------------------------------------------------------------------------------	
Func returnFullOUfromDN($dn)
	If $dn <> "0" Then
		return StringRight($dn, StringLen($dn)-StringInStr($dn, $ouIdentifier)+1)
	Else
		return 0
	EndIf
EndFunc

;------------------------------------------------------------------------------
; Returns the parent OU name:
;
; Example:
;
; The full OU of:
; OU=IT Shop,OU=Service Groups,DC=domain,DC=com
;
; Is returned as:
; OU=Service Groups,DC=domain,DC=com
;------------------------------------------------------------------------------	
Func returnParentOU($fullOU)
	return StringRight($fullOU, ( StringLen($fullOU)-StringInStr($fullOU, $ouSeparator) ) )
EndFunc

;------------------------------------------------------------------------------
; Custom COM error handler
;
; Needs to be trapped with:
; $comError 		= ObjEvent("AutoIt.Error", "comError")
;------------------------------------------------------------------------------	
Func comError()
    If IsObj($comError) Then
        $hexNumber = Hex($comError.number, 8)
        SetError($hexNumber)	
    EndIf
    Return 0
EndFunc