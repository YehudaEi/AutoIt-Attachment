#include <GUIConstants.au3>
#include <adfunctions.au3>

$sDebug=0
$domainregsetting="HKey_Current_User\Software\PBA\Domain"
$sCompanyDomain=RegRead($domainregsetting,"ldapdomain")

#Region ### GUI
$Form1 = GUICreate("Delegates Search", 633, 515, 193, 115)
$Userid = GUICtrlCreateInput("", 64, 10, 233, 21)

if $scompanydomain Then
	$CompanyDomainGUI = GUICtrlCreateEdit($sCOMPANYDOMAIN, 465, 8, 145, 21,$ES_READONLY)
Else
	$CompanyDomainGUI = GUICtrlCreateEdit("dc=pba,dc=int", 465, 8, 145, 21,$ES_READONLY)
EndIf

$SEARCH = GUICtrlCreateButton("Search", 24, 456, 175, 25, 0)
$COPY = GUICtrlCreateButton("Copy to Clipboard", 227, 456, 175, 25, 0)
GUICtrlSetState($COPY, $GUI_DISABLE)
$CANCEL = GUICtrlCreateButton("Exit", 434, 456, 175, 25, 0)
$Delegates = GUICtrlCreateEdit("", 24, 96, 585, 158,$ES_MULTILINE+$WS_VSCROLL+$ES_READONLY)
$DelegatesBL = GUICtrlCreateEdit("", 24, 288, 585, 158,$WS_VSCROLL+$ES_MULTILINE+$ES_READONLY)
$Label1 = GUICtrlCreateLabel("Username:", 8, 10, 55, 17)
$adobject = GUICtrlCreateLabel("   ", 64, 40, 500, 17)
$Label3 = GUICtrlCreateLabel("AD Object:", 8, 40, 56, 17)
$LabelDelegates = GUICtrlCreateLabel("Mailbox delegates are:", 8, 72, 110, 17)
$LabelDelegatesBL = GUICtrlCreateLabel("Mailbox is a delegate of:", 8, 264, 118, 17)
$Label6 = GUICtrlCreateLabel("LDAP Search Domain:", 353, 8, 111, 17)
$MenuItem1 = GUICtrlCreateMenu("&Settings")
$MenuItem2 = GUICtrlCreateMenuItem("Domain", $MenuItem1)
$MenuItem3 = GUICtrlCreateMenu("&Help")
$MenuItem4 = GUICtrlCreateMenuItem("About", $MenuItem3)


GUICtrlSetTip($UserID, "Enter the nework username to be checked for delegates")
GUICtrlSetTip($CompanyDomainGUI, "The LDAP search root - once set, via the Settings menu, this value is saved to the registry")
GUICtrlSetTip($Delegates, "The users listed here are delegates OF the searched username")
GUICtrlSetTip($DelegatesBL, "The users listed here have delegated access to their mailbox or calendar TO the searched username")
GUICtrlSetTip($Copy, "Click to copy the delegates information to the clipboard")

GUISetState(@SW_SHOW)

#EndRegion ### GUI

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $CANCEL
			Exit
		Case $USERID
			UpdateGui()
			
		Case $SEARCH
			UpdateGUI()
			
		Case $COPY
			CopyToClipBoard()
			
		Case $MenuItem2
			$companydomain=(guictrlread($companyDomainGui))
 			$newdomain=InputBox("Set new LDAP Domain","Enter the new value as dc=domain,dc=com"&@CRLF&"The current value is "& $CompanyDomain & @CRLF & @CRLF & "The new value will be written to: "&$domainregsetting,"","",-1,170)
			UpdateDomain($newdomain)
			
		Case $MenuItem4
			msgbox(64,"About ...","This utility was written soley for use by the IT Department at Peter Brett Associates LLP (PBA LLP)" & @CRLF & @CRLF &"It has been made available to you on an as-is basis without any particular warranties or indemnities. Neither the Author nor PBA LLP accept any liablity for anything that may happen to you, your computer, your network or your domain as a result of your decision to use this utility.")
			
		Case $CompanyDomainGui
			UpdateDomain(guictrlread($CompanyDomainGUI))
		
	EndSwitch
WEnd

Func CopyToClipBoard()
	$clipboardtext="Delegate details for username: "& GUICtrlRead($userid)
	$clipboardtext&=GUICtrlRead($adobject)
	$clipboardtext&=@CRLF
	$clipboardtext&=@CRLF	
	$clipboardtext&=GUICtrlRead($labeldelegates)&@CRLF & GUICtrlRead($delegates)
	$clipboardtext&=@CRLF
	$clipboardtext&=GUICtrlRead($labeldelegatesBL)&@CRLF & GUICtrlRead($delegatesBL)
	ClipPut($clipboardtext)
EndFunc	

Func UpdateDomain($newdomain)
if @error=0 then 
			if $newdomain Then
				RegWrite($domainregsetting,"ldapdomain","reg_sz",$newdomain)
				GUICtrlSetData($CompanyDomainGUI,$newdomain)
			EndIf
	EndIf
EndFunc


Func UpdateGUI ()
			$sCompanyDomain=GUICtrlRead ($CompanyDomainGui)
			GUICtrlSetData($adobject,FindPropsforUser(guictrlread($userid), "distinguishedName"))
			GUICtrlSetData($Delegates,FindPropsforUser(guictrlread($userid), "publicDelegates"))
			GUICtrlSetData($DelegatesBL,FindPropsforUser(guictrlread($userid), "publicDelegatesBL"))
			if GUICtrlRead($adobject) <> "Nothing Found" Then
				GUICtrlSetState($COPY, $GUI_ENABLE)
				GUICtrlSetState($COPY, $GUI_FOCUS)
				GUICtrlSetState($COPY, $GUI_DEFBUTTON)
			Else
				GUICtrlSetState($COPY, $GUI_DISABLE)
				GUICtrlSetState($USERID, $GUI_FOCUS)
			EndIf
EndFunc
		

Func FindPropsforUser($sValue,$sField)

Dim $objRecordSet, $objCommand, $objConnection
$strname=""
$ADS_SCOPE_SUBTREE = 2
$objConnection = ObjCreate("ADODB.Connection")
$objCommand = ObjCreate("ADODB.Command")
$objConnection.Provider = "ADsDSOObject"
$objConnection.Open("Active Directory Provider")
$objCommand.ActiveConnection = $objConnection
$objCommand.CommandText = "SELECT " & $sField & " FROM 'LDAP://" & $sCompanyDomain & "' WHERE objectCategory='user' AND sAMAccountName='" & $sValue & "'"

$oUser = $objCommand.Execute

$output=""
if $sdebug then MsgBox(1,"",$oUser) EndIf
If IsObj($oUser) Then

$oDelegates = $oUser.Fields($sField)
if IsString ($oDelegates.value) Then
	$output = $oDelegates.value
	Else

	For $Value In $oDelegates.value
	$output &= $Value & @CRLF
	Next
EndIf

EndIf

if $sdebug then msgbox(1,"",$output) endif

If stringlen($output) <1 then
	$output="Nothing found"
EndIf

If @error <> 0 Then
Return "User Not Found"
Else

Return $output
EndIf
EndFunc