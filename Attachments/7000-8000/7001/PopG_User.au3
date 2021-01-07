; PopG_User.au3 - Andy Swarbrick (c) 2005-6 - Provides user management functionality both on a domain and this local computer.
#Region		Doc:
#Region		Doc: Notes
; Extends au3 to provide user management on both a domain and a stand-alone computer via "NET USER" command
#EndRegion	Doc: Notes
#Region		Doc: Requirements
; Requires Au3 build 3.1.1.109 or better.  Also uses PopG Delim, Run and String include libraries.
#EndRegion	Doc: Requirements
#Region		Doc: History
; 19-Feb-06 Als Added	_UserGetAllUsers
; 18-Feb-06 Als Renamed	_UserGroups to _UserGetAllGroups
; 18-Feb-06 Als Added	_UserGetDetails
; 18-Feb-06 Als Added	_UserSetDetails
; 18-Feb-06 Als Added	$UD_xxx family of global constants
; 18-Feb-06 Als Renamed	_UserDetails	to __UserDetailsRaw
; 18-Feb-06 Als Added	_UdGet			private function 
#EndRegion	Doc: History
#Region		Doc: FunctionList
; _UserGetDetails				Returns one of the User details for the current user
; _UserGetAllGroups				Returns a list of all local and domain groups.
; _UserGetUsersGroups			Returns a list of local and domain groups this user belongs to.
; _UserGetUsers					Returns a list of users, either local or in the domain
; _UserIsMember					Returns true if the user is a member of specified group.
; _UserSetDetails				Sets one of the User details for the current user
#EndRegion	Doc: FunctionList
#EndRegion	Doc:
#Region		Init: 
#Region		Init: Absolute Decls
	Global Const $UD_Username				=1
	Global Const $UD_Fullname				=2
	Global Const $UD_Comment				=4
	Global Const $UD_UserComment			=8
	Global Const $UD_CountryCode			=16
	Global Const $UD_AccountActive			=32
	Global Const $UD_AccountExpires			=64
	Global Const $UD_PasswordExpires		=128
	Global Const $UD_PasswordRequired		=256
	Global Const $UD_MayChangePassword		=512
	Global Const $UD_WorkstationsAllowed	=1024
	Global Const $UD_LogonScript 			=2048
	Global Const $UD_UserProfile			=4096
	Global Const $UD_HomeDir				=8192
	Global Const $UD_LogonTimes				=16384
	Global Const $UD_Groups					=32768
#EndRegion	Init: Absolute Decls
#Region		Init: Includes
	#include-once
	#include '..\PopGincl\PopG_Delim.au3'
	#include '..\PopGincl\PopG_Run.au3'
	#include '..\PopGincl\PopG_String.au3'
;~ 	#include '..\PopGincl\PopG_Array.au3'		;Required for Test Harness only
#EndRegion	Init: Includes
#EndRegion	Init: 
#Region		Run:
#Region		Run: Test Harness
#Region		Run: Test _UserGetDetails
;~ 	Local $UserArr[1],$UserErr[1]
;~ 	Local $Comment,$FullName,$Password,$Email
;~ 	Local $CommentSplit
;~ 	$Comment	=_UserGetDetails($UD_Comment,$UserArr,$UserErr,@UserName,False)
;~ 																	ConsoleWrite('@@ Debug(41) : $Comment = ' & $Comment & @lf & '>Error code: ' & @error & @lf) ;### Debug Console
;~ 	$FullName	=_UserGetDetails($UD_Fullname,$UserArr,$UserErr,@UserName,False)
;~ 																	ConsoleWrite('@@ Debug(42) : $FullName = ' & $FullName & @lf & '>Error code: ' & @error & @lf) ;### Debug Console
;~ 	$CommentSplit=StringSplit($Comment,'|')
;~ 	$Password	=$CommentSplit[1]
;~ 																	ConsoleWrite('@@ Debug(44) : $Password = ' & $Password & @lf & '>Error code: ' & @error & @lf) ;### Debug Console
;~ 	$Email		=$CommentSplit[2]
;~ 																	ConsoleWrite('@@ Debug(45) : $Email = ' & $Email & @lf & '>Error code: ' & @error & @lf) ;### Debug Console
;~ 	Exit
#EndRegion	Run: Test _UserGetDetails
#Region		Run: Test _UserIsMember
;~ 	Local $Groups[1]
;~ 	MsgBox(0,'ismemadmin',_UserIsMember(@UserName,'administrators'))
;~ 	Exit
#EndRegion	Run: Test _UserIsMember
#Region		Run: Test _UserGetAllUsers
;~ 	MsgBox(0,'users',_UserGetAllUsers(True))
;~ 	Exit
#EndRegion	Run: Test _UserGetAllUsers
#Region		Run: Test _UserGetAllGroups
;~ 	Local $Groups=_UserGetAllGroups()
;~ 	MsgBox(262144,'Debug line ~76','Selection:' & @lf & '$Groups' & @lf & @lf & 'Return:' & @lf & $Groups & @lf & @lf & '@Error:' & @lf & @Error) ;### Debug MSGBOX
;~ 	Exit
#EndRegion	Run: Test _UserGetAllGroups
#Region		Run: Test _UserGetUsersGroups
;~ 	Local $Groups=_UserGetUsersGroups(@UserName)
;~ 	MsgBox(262144,'Debug line ~81','Selection:' & @lf & '$Groups' & @lf & @lf & 'Return:' & @lf & $Groups & @lf & @lf & '@Error:' & @lf & @Error) ;### Debug MSGBOX
;~ 	Exit
#EndRegion	Run: Test _UserGetUsersGroups
#Region		Run: Test for __UserDetailsRaw
;~ 	Local $Arr[1],$Err[1],$Result
;~ 	$Result=__UserDetailsRaw(@UserName,$Arr,$Err,True)
;~ 	MsgBox(0,'$result',$Result)
;~ 	_ArrayDisplay($Arr,'result='&$Result&' for '&@UserName&' on the domain')
;~ 	_ArrayDisplay($Err,'error result='&$Result&' for '&@UserName&' on the domain')
;~ 	$Result=__UserDetailsRaw(@UserName,$Arr,$Err,False)
;~ 	_ArrayDisplay($Arr,@UserName&' on a stand alone pc result='&$Result)
;~ 	_ArrayDisplay($Err,'error result='&$Result&' for '&@UserName&' local')
;~ 	MsgBox(0,'$result',$Result)
;~ 	Exit
#Region		Run: Test for __UserDetailsRaw
#EndRegion	Run: Test Harness
#Region		Run: Functions
; _UserIsMember						Returns true if the user is a member of specified group.
;
; Notes:
; All domain and local groups are checked.
;
; Parameters:
; $Username				The name of the user to be checked.
; $Group				The name of the group that you wish to see if they are a member of.
Func _UserIsMember($Username,$Group)
	Local $i,$Groups
	$Groups=_UserGetUsersGroups($Username)
	Return _DelimListGetIndex($Groups,$Group,False)>0
EndFunc ; _UserIsMember
; _UserGetUsersGroups						Returns a list of groups this user belongs to.
;
; Parameters:
; $Username				The name of the user to be checked.
Func _UserGetUsersGroups($Username)
	Local $UserArr[1],$UserErr[1]
	Local $Groups
	_RunWaitSysOutErr('net user "'&$Username&'" /domain | find "*"',@TempDir,@SW_HIDE,$UserArr,$UserErr)
	Local $Ok=False
	For $i=1 to $UserArr[0]
		If _StringBegins($UserArr[$i],'Local Group') Then $Ok=True
		If $Ok Then $Groups=$Groups&StringReplace(StringReplace(StringStripWS(StringMid($UserArr[$i],30),7),'*','|'),' |','|')
	Next
	$Groups=StringMid($Groups,2)
	Return $Groups	
EndFunc ; _UserGetUsersGroups
; _UserGetAllGroups				Returns a list of all local and domain groups.
;
; Parameters:
; none
Func _UserGetAllGroups()
	Dim $Details[1],$Err[1],$i,$GroupsStr
	Local $Result=__GroupDetailsRaw($Details,$Err,'',' | find "*"')
	For $i=1 To $Details[0]
		$GroupsStr=$GroupsStr&'|'&StringMid($Details[$i],2)
	Next
	SetError(0)
	Return StringMid($GroupsStr,2)
EndFunc ; _UserGetAllGroups
; _UserGetAllUsers					Returns a list of local and domain groups this user belongs to.
;
; Parameters:
; $OkDomain				Whether you wish to find a list of users on this computer (default) or on the domain (True).
Func _UserGetAllUsers($OkDomain=False)
	Dim $UserArr[1],$UserErr[1],$i,$UsersStr,$Cmd,$OkStart=False,$TmpStr
	$Cmd='Net user'
	If $OkDomain Then 
		$Cmd=$Cmd&' /domain | more +6'
	Else
		$Cmd=$Cmd&' | more +4'
	EndIf
	_RunWaitSysOutErr($Cmd,@TempDir,@SW_HIDE,$UserArr,$UserErr)
	If @error Then
		SetError(1)
		Return ''
	EndIf
	For $i=1 To $UserArr[0]
		If $UserArr[$i]='The command completed successfully.' Then ExitLoop
		$TmpStr=_StringReplaceRepeat($UserArr[$i],'  ','|')
		$TmpStr=_StringReplaceRepeat($TmpStr,'| ','|')
		$UsersStr=$UsersStr&'|'&$TmpStr
	Next
	$UsersStr=_StringReplaceRepeat($UsersStr, "||", "|")
	$UsersStr=StringReplace($UsersStr&'uniquestring','|uniquestring','')
	SetError(0)
	Return StringMid($UsersStr,2)	; trim off leading stick
EndFunc ; _UserGetAllUsers
; __GroupDetailsRaw					Returns an array of details for this group (private fuction)
Func __GroupDetailsRaw(ByRef $Details,ByRef $Err,$Groupname='',$filter='')
	Local $Cmd='net group '&$Groupname&' /domain'
	_RunWaitSysOutErr($Cmd&$filter,@TempDir,@SW_HIDE,$Details,$Err)
	Return $Err[0]==0
EndFunc ; __GroupDetailsRaw
; _UserGetSelUsers				Returns a list of local and domain groups this user belongs to.
;~ Func _UserGetSelUsers($OkDomain=False)
;~ 	Local $Details[1],$Err[1],$i,$j
;~ 	Const $LocalHdr		='Local Group Memberships'
;~ 	Const $GlobalHdr	='Global Group Memberships'
;~ 	Const $LocalHdrLen	=StringLen($LocalHdr)
;~ 	Const $GlobalHdrLen	=StringLen($GlobalHdr)
;~ 	Local $LineArr[1],$LineType,$Line
;~ 	ReDim $Groups[1]
;~ 	$Groups[0]=0
;~ 	; First try locally
;~ 	If __UserDetailsRaw($Details,$Err,$Username,False) Then
;~ 		$LineType=0
;~ 		For $i = 1 To $Details[0]
;~ 			$Line=$Details[$i]
;~ 			If StringLeft($Line,$LocalHdrLen)=$LocalHdr Then 
;~ 				$Line=StringMid($Line,$LocalHdrLen+1)
;~ 				$LineType=1
;~ 			EndIf
;~ 			If StringLeft($Line,$GlobalHdrLen)=$GlobalHdr Then 
;~ 				$Line=StringMid($Line,$GlobalHdrLen+1)
;~ 				$LineType=2
;~ 			EndIf
;~ 			If $LineType<>0 Then	; we could extend this to differentiate local & global, but usually this is in the name!
;~ 				$Line=StringStripWS($Line,7)
;~ 				If StringLeft($Line,1)='*' Then
;~ 					$LineArr=StringSplit($Line,'*')
;~ 					For $j=1 To $LineArr[0]
;~ 						$LineArr[$j]=StringStripWS($LineArr[$j],7)
;~ 						If $LineArr[$j]<>'None' And $LineArr[$j]<>'' Then
;~ 							ReDim $Groups[UBound($Groups)+1]
;~ 							$Groups[0]=$Groups[0]+1
;~ 							$Groups[$Groups[0]]=$LineArr[$j]
;~ 						EndIf
;~ 					Next
;~ 				EndIf
;~ 			EndIf
;~ 		Next
;~ 	EndIf
;~ 	; Now try on the domain
;~ 	If __UserDetailsRaw($Details,$Err,$Username,True) Then
;~ 		$LineType=0
;~ 		For $i = 1 To $Details[0]
;~ 			$Line=$Details[$i]
;~ 			If StringLeft($Line,$LocalHdrLen)=$LocalHdr Then 
;~ 				$Line=StringMid($Line,$LocalHdrLen+1)
;~ 				$LineType=1
;~ 			EndIf
;~ 			If StringLeft($Line,$GlobalHdrLen)=$GlobalHdr Then 
;~ 				$Line=StringMid($Line,$GlobalHdrLen+1)
;~ 				$LineType=2
;~ 			EndIf
;~ 			If $LineType<>0 Then	; we could extend this to differentiate local & global, but usually this is in the name!
;~ 				$Line=StringStripWS($Line,7)
;~ 				If StringLeft($Line,1)='*' Then
;~ 					$LineArr=StringSplit($Line,'*')
;~ 					For $j=1 To $LineArr[0]
;~ 						$LineArr[$j]=StringStripWS($LineArr[$j],7)
;~ 						If $LineArr[$j]<>'None' And $LineArr[$j]<>'' Then
;~ 							ReDim $Groups[UBound($Groups)+1]
;~ 							$Groups[0]=$Groups[0]+1
;~ 							$Groups[$Groups[0]]=$LineArr[$j]
;~ 						EndIf
;~ 					Next
;~ 				EndIf
;~ 			EndIf
;~ 		Next
;~ 	EndIf
;~ 	Return $Groups[0]
;~ EndFunc ; _UserGetSelUsers
; _UserSetDetails						Sets one of the User details for the current user
;
; Parameters:
; $Username				The name of the user to be modified.
; $Field				The field to be modified.  See $UD constants.
; $OkDomain				Whether the user exists on the domain or on this local computer.
Func _UserSetDetails($Username,$Field,$Val,$OkDomain=False)
	Local $Cmd='net user '&$Username
	Dim $Details[1],$Err[1]
	;
	If BitAND($Field,$UD_Fullname)				Then $Cmd=$Cmd&' /FullName:"'&$Val&'"'				; may contain spaces
	If BitAND($Field,$UD_Comment)				Then $Cmd=$Cmd&' /Comment:"'&$Val&'"'				; replace | with ^|
	If BitAND($Field,$UD_UserComment)			Then $Cmd=$Cmd&' /UserComment:"'&$Val&'"'			;
	If BitAND($Field,$UD_CountryCode)			Then $Cmd=$Cmd&' /CountryCode:"'&$Val&'"'			; nnn format
	If BitAND($Field,$UD_AccountActive)			Then $Cmd=$Cmd&' /Active:"'&$Val&'"'				; yes|no
	If BitAND($Field,$UD_AccountExpires)		Then $Cmd=$Cmd&' /Expires:"'&$Val&'"'				; date depends on country code
	If BitAND($Field,$UD_PasswordRequired)		Then $Cmd=$Cmd&' /PasswordReq:"'&$Val&'"'			; yes|no
	If BitAND($Field,$UD_MayChangePassword)		Then $Cmd=$Cmd&' /PasswordChg:"'&$Val&'"'			; yes|no
	If BitAND($Field,$UD_WorkstationsAllowed)	Then $Cmd=$Cmd&' /Workstations:"'&$Val&'"'			; up to 8 comma delimited workstations
	If BitAND($Field,$UD_LogonTimes)			Then $Cmd=$Cmd&' /Times:"'&$Val&'"'					; Logon times (M,T,W,Th,F,Sa,Su) (12 or 24h time notation) eg "M,4AM-5PM;T,1PM-3PM"
	If BitAND($Field,$UD_LogonScript) 			Then $Cmd=$Cmd&' /LogonScript:"'&$Val&'"'			; relative to $NetLogon
	If BitAND($Field,$UD_UserProfile)			Then $Cmd=$Cmd&' /ProfilePath:"'&$Val&'"'			; where user profile is stored
	If BitAND($Field,$UD_HomeDir)				Then $Cmd=$Cmd&' /HomeDirectory:"'&$Val&'"'			; path must exist
	;
	If $OkDomain Then $Cmd=$Cmd&' /domain'
	_RunWaitSysOutErr($Cmd,@TempDir,@SW_HIDE,$Details,$Err)
	Return $Err[0]=0
EndFunc ; _UserSetDetails
; _UserGetDetails						Returns one of the User details for the current user.
;
; Notes
; UserDetails is only called if it is not populated properly.
;
; Parameters:
; $Username				The name of the user to be modified.
; $Field				The field to be returned.  See $UD constants.
; $OkDomain				Whether the user exists on the domain or on this local computer.
Func _UserGetDetails($Username,$Field,$OkDomain=False)
	Local $UserArr[1],$UserErr[1]
	__UserDetailsRaw($UserArr,$UserErr,@UserName,$OkDomain)
	;
	Local $OkGetMoreGroups=False
	Local $Val=''
	For $i=1 To $UserArr[0]
		If BitAND($Field,$UD_Username)				Then $Val=__UdGet($UserArr[$i],'User name')
		If BitAND($Field,$UD_Fullname)				Then $Val=__UdGet($UserArr[$i],'Full Name')
		If BitAND($Field,$UD_Comment)				Then $Val=__UdGet($UserArr[$i],'Comment')
		If BitAND($Field,$UD_UserComment)			Then $Val=__UdGet($UserArr[$i],'User''s Comment')
		If BitAND($Field,$UD_CountryCode)			Then $Val=__UdGet($UserArr[$i],'Country Code')
		If BitAND($Field,$UD_AccountActive)			Then $Val=__UdGet($UserArr[$i],'Account active')
		If BitAND($Field,$UD_AccountExpires)		Then $Val=__UdGet($UserArr[$i],'Account expires')
		If BitAND($Field,$UD_PasswordExpires)		Then $Val=__UdGet($UserArr[$i],'Password expires')
		If BitAND($Field,$UD_PasswordRequired)		Then $Val=__UdGet($UserArr[$i],'Password required')
		If BitAND($Field,$UD_MayChangePassword)		Then $Val=__UdGet($UserArr[$i],'User may change password')
		If BitAND($Field,$UD_WorkstationsAllowed)	Then $Val=__UdGet($UserArr[$i],'Workstations allowed')
		If BitAND($Field,$UD_LogonScript) 			Then $Val=__UdGet($UserArr[$i],'Logon script')
		If BitAND($Field,$UD_UserProfile)			Then $Val=__UdGet($UserArr[$i],'User profile')
		If BitAND($Field,$UD_HomeDir)				Then $Val=__UdGet($UserArr[$i],'Home directory')
		If $Val<>'' Then Return $Val
	Next
	SetError(1)
	Return ''
EndFunc ; _UserGetDetails
; __UdGet							Private function to return the exact entry, if found.
Func __UdGet($Line,$Key)
	If StringLeft($Line,StringLen($Key))==$Key Then Return StringMid($Line,30)
	Return ''
EndFunc ; __UdGet
; __UserDetailsRaw					Returns an array of details for this user (private fuction).
Func __UserDetailsRaw(ByRef $Details,ByRef $Err,$Username='',$OkDomain=False)
	Local $Cmd='net user '&$Username
	If $OkDomain Then $Cmd=$Cmd&' /domain'
	_RunWaitSysOutErr($Cmd,@TempDir,@SW_HIDE,$Details,$Err)
	Return $Err[0]=0
EndFunc ; __UserDetailsRaw
#EndRegion	Run: Functions
#EndRegion	Run:
