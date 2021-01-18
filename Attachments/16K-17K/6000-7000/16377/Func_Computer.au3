;----------------------------------------------------------------------------
; Script: 		Func-Computer
; Purpose:		Computer related functions
; Application:	Windows
; Author:		Justin Taylor - justin.taylor@sage.com
;---------------------------------------------------------------------------

;----------------------------------------------------------------------------
;Requires:
; 
;---------------------------------------------------------------------------

;----------------------------------------------------------------------------
;Functions in this script
; 
;---------------------------------------------------------------------------

#include-once

#region --- Include Files ---
    
#endregion --- Include Files ---

#region --- Variables ---
    
#endregion --- Variables ---

AutoItSetoption( "TrayIconDebug", 1 )


Func Computer_Rename( $sComputerName, $sLocalUser, $sPassword )
;***************************************************************
; Function:     System_Computer_Rename
; Actions:      Renames the machine - from http://msdn2.microsoft.com/en-us/library/aa393056.aspx
; Parameters:   $sComputerName - new computer name
;				$sLocalUser - local admin username
;				$sPassword - local admin password
; Returns:      1 - success
;				0 - failure
; Requirements: none
; Author:       Justin Taylor
;***************************************************************
	
	Local $objWMIService, $objComputer, $sReturn
	
	;Create a WMI object
	$objWMIService = ObjGet( "Winmgmts:root\cimv2" )

	;Verify the object was created
	If IsObj( $objWMIService ) Then
		For $objComputer in $objWMIService.InstancesOf( "Win32_ComputerSystem" )
			;Rename the computer
			$sReturn = $objComputer.rename( $sComputerName, $sPassword, $sLocalUser )
			If $sReturn <> 0 Then
				If IsDeclared( "sFileName" ) Then FileWriteLine( $sFileName, "System_Computer_Rename: Unable to rename the computer, possible Error: " &$sReturn &". - ScriptLine Number: " &@ScriptLineNumber )
				SetError( 1 )
				Return 0
				
			EndIf
			
		Next
		
	Else
		;Object was not created
		If IsDeclared( "sFileName" ) Then FileWriteLine( $sFileName, "System_Computer_Rename: The WMI object was not created. - ScriptLine Number: " &@ScriptLineNumber )
		SetError( 1 )
		Return 0
		
	EndIf
	
	Return 1
	
EndFunc


Func Computer_AddToDomainOrWorkgroup( $sDomain, $sDomainUsername, $sPassword )
;***************************************************************
; Function:     System_Computer_AddToDomainOrWorkgroup
; Actions:      Adds the local machine to the specified domain using the specified credentials - from http://msdn2.microsoft.com/en-us/library/aa392154.aspx
; Parameters:   $sDomain - domain to add computer to
;				$sDomainUsername - domain username with credentials to add machines to the domain
;				$sPassword - password
; Returns:      1 - success
;				0 - failure
; Requirements: none
; Author:       Justin Taylor
;***************************************************************
	
	Const $iJoin_Domain             = 1
	Const $iAcct_Create             = 2
	Const $iAcct_Delete             = 4
	Const $iWin9X_Upgrade           = 16
	Const $iDomain_Join_If_Joined   = 32
	Const $iJoin_Unsecure           = 64
	Const $iMachine_Password_Passed = 128
	Const $iDeffered_Spn_Set        = 256
	Const $iInstall_Invocation      = 262144
	
	Local $objNetwork, $sComputer, $objComputer, $sReturnValue
	
	;Create a WMI object
	$objNetwork = ObjCreate( "WScript.Network" )
	
	;Verify the object was created
	If IsObj( $objNetwork ) Then
		;Retrieve the computer name
		$sComputer = $objNetwork.ComputerName
		
		;Set impersonation
		$objComputer = ObjGet( "winmgmts:{impersonationLevel=Impersonate}!\\" &$sComputer &"\root\cimv2:Win32_ComputerSystem.Name='" &$sComputer &"'" )
		
		If IsObj( $objComputer ) Then
			;Add the machine to the domain
			$sReturnValue = $objComputer.JoinDomainOrWorkGroup( $sDomain, $sPassword, $sDomain &"\" &$sDomainUsername, "", $iJoin_Domain + $iAcct_Create )
			
		Else
			;Object was not created
			If IsDeclared( "sFileName" ) Then FileWriteLine( $sFileName, "System_Computer_AddToDomainOrWorkgroup: The WMI object was not created - $objComputer. - ScriptLine Number: " &@ScriptLineNumber )
			SetError( 1 )
			Return 0
		EndIf
		
	Else
		;Object was not created
		If IsDeclared( "sFileName" ) Then FileWriteLine( $sFileName, "System_Computer_AddToDomainOrWorkgroup: The WMI object was not created - $objNetwork. - ScriptLine Number: " &@ScriptLineNumber )
		SetError( 2 )
		Return 0
		
	EndIf
	
	Return 1
	
EndFunc


Func Computer_RemoveFromDomain( $sDomainUsername, $sPassword )
;***************************************************************
; Function:     Computer_RemoveFromDomain
; Actions:      Removes the machine from the domain the machine - from http://msdn2.microsoft.com/en-us/library/aa393056.aspx
; Parameters:   $sDomainUsername - domain username with credentials to add machines to the domain
;				$sPassword - password
; Returns:      1 - success
;				0 - failure
; Requirements: none
; Author:       Justin Taylor
;***************************************************************
	
	Local $objWMIService, $objComputer
	
	;Create a WMI object
	$objWMIService = ObjGet( "Winmgmts:root\cimv2" )

	;Verify the object was created
	If IsObj( $objWMIService ) Then
		For $objComputer in $objWMIService.InstancesOf( "Win32_ComputerSystem" )
			;Remove the computer from the domain
			$sReturn = $objComputer.UnjoinDomainOrWorkgroup( $sPassword, $sDomainUsername, 0 )
			If $sReturn <> 0 Then
				If IsDeclared( "sFileName" ) Then FileWriteLine( $sFileName, "System_Computer_Rename: Unable to rename the computer, possible Error: " &$sReturn &". - ScriptLine Number: " &@ScriptLineNumber )
				SetError( 1 )
				Return 0
				
			EndIf
			
		Next
		
	Else
		;Object was not created
		If IsDeclared( "sFileName" ) Then FileWriteLine( $sFileName, "System_Computer_Rename: The WMI object was not created. - ScriptLine Number: " &@ScriptLineNumber )
		SetError( 1 )
		Return 0
		
	EndIf
	
	Return 1
	
EndFunc	
	

Func Computer_MemberOfDomainOrWorkgroup( )
;***************************************************************
; Function:     Computer_MemberOfDomainOrWorkgroup
; Actions:      Dtermines if the machine is on a domain or a workgroup
; Parameters:   none
; Returns:      1 for member of a domain
;				2 for member of a workgroup
;				0 for errors
; Requirements: none
; Author:       Justin Taylor
;***************************************************************

	Local $iDomainState 
	
	;Determine if the machine is part of a domain
	Local $wbemFlagReturnImmediately = 0x10
	Local $wbemFlagForwardOnly = 0x20
	Local $colItems = ""
	Local $strComputer = "localhost"
	
	;Create the WMI Object
	Local $objWMIService = ObjGet( "winmgmts:\\" & $strComputer & "\root\CIMV2" )
	
	;Query WMI
	Local $colItems = $objWMIService.ExecQuery( "SELECT * FROM Win32_ComputerSystem", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly )
	
	;Verify result was returned as an object
	If IsObj( $colItems ) Then
		;Retrieve result
		For $objItem In $colItems
			$iDomainState = $objItem.DomainRole
			
		Next
		
	Else
		If IsDeclared( "sFileName" ) Then FileWriteLine( $sFileName, ": " &" - ScriptLine Number: " &@ScriptLineNumber )
		SetError( 1 )
		Return 0
		
	EndIf
	
	;Translate outpur from WMI
	Switch $iDomainState
		Case 1
			$iDomainState = 1
			
		Case 0
			$iDomainState = 2
			
	EndSwitch
	
	Return $iDomainState

EndFunc

;EndOfFile