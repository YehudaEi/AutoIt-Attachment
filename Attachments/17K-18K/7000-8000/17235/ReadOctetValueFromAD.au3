 ;NOTES : Please use the following command to store the local user's groups for the function 'HasFullRights'. This is to allow cross-domain
; permission checks. $loggedonusergroups is a global variable declared in the 'Define AD Constants' region. If you are using this command
; in this library, move the command below the declaration of the variable and remove the comment charcater.

; _ADRecursiveGetMemberOf ($loggedonusergroups, _ADSamAccountNameToFQDN (@UserName))

; include array functions (we use _arraysearch in some functions)
#include-once 
#include <Array.au3>
#include <Date.au3>

#region  ; Define AD Constants
Global Const $ADS_GROUP_TYPE_GLOBAL_GROUP = 0x2
Global Const $ADS_GROUP_TYPE_DOMAIN_LOCAL_GROUP = 0x4
Global Const $ADS_GROUP_TYPE_UNIVERSAL_GROUP = 0x8
Global Const $ADS_GROUP_TYPE_SECURITY_ENABLED = 0x80000000
Global Const $ADS_GROUP_TYPE_GLOBAL_SECURITY = BitOR($ADS_GROUP_TYPE_GLOBAL_GROUP, $ADS_GROUP_TYPE_SECURITY_ENABLED)
Global Const $ADS_GROUP_TYPE_UNIVERSAL_SECURITY = BitOR($ADS_GROUP_TYPE_UNIVERSAL_GROUP, $ADS_GROUP_TYPE_SECURITY_ENABLED)
Global Const $ADS_GROUP_TYPE_DOMAIN_LOCAL_SECURITY = BitOR($ADS_GROUP_TYPE_DOMAIN_LOCAL_GROUP, $ADS_GROUP_TYPE_SECURITY_ENABLED)

Global Const $ADS_UF_PASSWD_NOTREQD = 0x0020
Global Const $ADS_UF_WORKSTATION_TRUST_ACCOUNT = 0x1000
Global Const $ADS_ACETYPE_ACCESS_ALLOWED = 0x0
Global Const $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT = 0x5
Global Const $ADS_FLAG_OBJECT_TYPE_PRESENT = 0x1
Global Const $ADS_RIGHT_GENERIC_READ = 0x80000000
Global Const $ADS_RIGHT_DS_SELF = 0x8
Global Const $ADS_RIGHT_DS_WRITE_PROP = 0x20
Global Const $ADS_RIGHT_DS_CONTROL_ACCESS = 0x100
Global Const $ADS_UF_ACCOUNTDISABLE = 2
Global Const $ADS_OPTION_SECURITY_MASK = 3
Global Const $ADS_SECURITY_INFO_DACL = 4

Global Const $ALLOWED_TO_AUTHENTICATE = "{68B1D179-0D15-4d4f-AB71-46152E79A7BC}"
Global Const $RECEIVE_AS = "{AB721A56-1E2f-11D0-9819-00AA0040529B}"
Global Const $SEND_AS = "{AB721A54-1E2f-11D0-9819-00AA0040529B}"
Global Const $USER_CHANGE_PASSWORD = "{AB721A53-1E2f-11D0-9819-00AA0040529b}"
Global Const $USER_FORCE_CHANGE_PASSWORD = "{00299570-246D-11D0-A768-00AA006E0529}"
Global Const $USER_ACCOUNT_RESTRICTIONS = "{4C164200-20C0-11D0-A768-00AA006E0529}"
Global Const $VALIDATED_DNS_HOST_NAME = "{72E39547-7B18-11D1-ADEF-00C04FD8D5CD}"
Global Const $VALIDATED_SPN = "{F3A64788-5306-11D1-A9C5-0000F80367C1}"
Const $Member_SchemaIDGuid = "{BF9679C0-0DE6-11D0-A285-00AA003049E2}"

Global $objConnection = ObjCreate("ADODB.Connection")  ; Create COM object to AD
$objConnection.ConnectionString = "Provider=ADsDSOObject"
$objConnection.Open ("Active Directory Provider")  ; Open connection to AD

Global $objRootDSE = ObjGet("LDAP://RootDSE")
Global $strDNSDomain = $objRootDSE.Get ("defaultNamingContext")  ; Retrieve the current AD domain name
Global $strHostServer = $objRootDSE.Get ("dnsHostName") ; Retrieve the name of the connected DC
Global $strConfiguration = $objRootDSE.Get ("ConfigurationNamingContext") ; Retrieve the Configuration naming context

Global $loggedonusergroups  ; populate this with the logged on user groups in your own app
#endregion


Global $oMyError = ObjEvent("AutoIt.Error", "_ADDoError") ; Install a custom error handler

AutoItSetOption("MustDeclareVars" , 1)



Local $groups
Local $temp
Local $Objectnames
Local $members
Local $Computerlist[1]
Local $Cl[1][1]
Local $Counter
Global $Properties[1]
Global $fqdn
Global $attrib
Global $userdata
;


; ----------------------------------------------------------------------------
; Description  : Ermittelt alle Eigenschaften eine DomainOBjects 
; Syntax   : _ADGetObjectProperties($object)
; Parameter(s)  : $object (z.B. @Computername, @UserName oder "GruppenName")
; Requirement(s) : $object
; Return Value(s) : Ein dimensionales Array: ValueName||Data
; Note(s)   : -
; ----------------------------------------------------------------------------
Func _ADGetObjectProperties($object)

If not _ADObjectExists($object) Then 
     Return 0
EndIf 

Local $oObject
Local $localObjectProps[1]
Local $strQuery
Local $objRecordSet
Local $ldap_entry
Local $props
Local $NumberOfDataObjects
Local $item
Local $propentry

Local Const $ADSTYPE_INVALID = 0
Local const $ADSTYPE_DN_STRING = 1
Local const $ADSTYPE_CASE_EXACT_STRING = 2
Local const $ADSTYPE_CASE_IGNORE_STRING = 3
Local const $ADSTYPE_PRINTABLE_STRING = 4
Local const $ADSTYPE_NUMERIC_STRING = 5
Local const $ADSTYPE_BOOLEAN = 6
Local const $ADSTYPE_INTEGER = 7
Local const $ADSTYPE_OCTET_STRING = 8
Local const $ADSTYPE_UTC_TIME = 9
Local const $ADSTYPE_LARGE_INTEGER = 10
Local const $ADSTYPE_PROV_SPECIFIC = 11
Local const $ADSTYPE_OBJECT_CLASS = 12
Local const $ADSTYPE_CASEIGNORE_LIST = 13
Local const $ADSTYPE_OCTET_LIST = 14
Local const $ADSTYPE_PATH = 15
Local const $ADSTYPE_POSTALADDRESS = 16
Local const $ADSTYPE_TIMESTAMP = 17
Local const $ADSTYPE_BACKLINK = 18
Local const $ADSTYPE_TYPEDNAME = 19
Local const $ADSTYPE_HOLD = 20
Local const $ADSTYPE_NETADDRESS = 21
Local const $ADSTYPE_REPLICAPOINTER = 22
Local const $ADSTYPE_FAXNUMBER = 23
Local const $ADSTYPE_EMAIL = 24
Local const $ADSTYPE_NT_SECURITY_DESCRIPTOR = 25
Local const $ADSTYPE_UNKNOWN = 26
Local const $ADSTYPE_DN_WITH_BINARY = 27
Local const $ADSTYPE_DN_WITH_STRING = 28


$strQuery = "<LDAP://" & $strHostServer & "/" & $strDNSDomain & ">;(sAMAccountName=" & $object & ");ADsPath;subtree"
$objRecordSet = $objConnection.Execute ($strQuery) ; Retrieve the FQDN for the logged on user

$ldap_entry = $objRecordSet.fields (0).value

If $ldap_entry = "" Then
; Object doesn't exist
  Return
EndIf
  
$oObject = ObjGet($ldap_entry) ; Retrieve the COM Object for the logged on user

$props = $oObject.GetInfo()
$NumberOfDataObjects = $oObject.PropertyCount()
For $i = 0 To $NumberOfDataObjects - 1
  $item = $oObject.Item($i)
  $propentry = $oObject.GetPropertyItem($item.Name, $ADSTYPE_UNKNOWN)
  
  If IsObj($propentry) = 0 Then
     MsgBox(0,"property (kein objekt)", $item.Name)
  Else
   For $v In $propentry.Values
    If $item.ADsType = $ADSTYPE_CASE_IGNORE_STRING Then
     _ArrayAdd($localObjectProps,$item.Name & "||" & $v.CaseIgnoreString)
    
    ElseIf $item.ADsType = $ADSTYPE_INTEGER Then
     _ArrayAdd($localObjectProps,$item.Name & "||" & $v.Integer)
    
    ElseIf $item.ADsType = $ADSTYPE_LARGE_INTEGER Then
    
     If $item.Name = "pwdLastSet" Or $item.Name = "accountExpires" or $item.Name = "lastLogonTimestamp" Or $item.Name = "badPasswordTime" Or $item.Name = "lastLogon" Then
      _ArrayAdd($localObjectProps,$item.Name & "||" & _DateAdd("s", Int(LargeInt2Double($v.LargeInteger.LowPart,$v.LargeInteger.HighPart) / (10000000) ), "1601/01/01 00:00:00") )
     Else
      _ArrayAdd($localObjectProps,$item.Name & "||" & LargeInt2Double($v.LargeInteger.LowPart,$v.LargeInteger.HighPart))      
     EndIf
    
    ElseIf $item.ADsType = $ADSTYPE_OCTET_STRING Then
     _ArrayAdd($localObjectProps,$item.Name & "||" & OctetToHexStr($v.OctetString))
    
    ElseIf $item.ADsType = $ADSTYPE_DN_STRING Then
     _ArrayAdd($localObjectProps,$item.Name & "||" & $v.DNString)
    
    ElseIf $item.ADsType = $ADSTYPE_UTC_TIME Then
     _ArrayAdd($localObjectProps,$item.Name & "||" & $v.UTCTime)
    
    ElseIf $item.ADsType = $ADSTYPE_BOOLEAN Then
     _ArrayAdd($localObjectProps,$item.Name & "||" & $v.Boolean)
     
    ElseIf $item.ADsType = $ADSTYPE_NT_SECURITY_DESCRIPTOR Then
     _ArrayAdd($localObjectProps,$item.Name & "||" & $v.SecurityDescriptor)
    
    Else
;~       MsgBox(0,"type ist",$item.ADsType & "||" & $item.Name)
    EndIf
    
   Next
  EndIf

Next

$oObject = 0

$localObjectProps[0] = UBound($localObjectProps) -1
  Return $localObjectProps

EndFunc  ;==>_ADGetObjectProperties


Func LargeInt2Double($Low,$High)
Local $result
Local $resLow
Local $resHigh


If $Low < 0 Then
  $resLow = 2 ^ 32 + $Low
Else
  $resLow = $Low
EndIf

If $High < 0 Then
  $resHigh = 2 ^ 32 + $High
Else
  $resHigh = $High
EndIf

$result = $resLow + $resHigh * 2 ^ 32

Return $result
EndFunc

Func OctetToHexStr($var_octet)
Local $Return
Local $stringmid
Local $ASC
Local $HEX
Dim $n

$Return = ""


For $n = 1 To BinaryLen($var_octet);StringLen($var_octet)
  $stringmid = BinaryMid($var_octet, $n, 1);StringMid($var_octet, $n, 1)
  $ASC = Asc($stringmid)
  $HEX = Hex($ASC)
  MsgBox(0,"oct",$stringmid & " | " & $ASC & " | " & $HEX)
  
  $Return = $Return & StringRight("0" & $HEX, 2)
Next
Return $Return
EndFunc


; _ADObjectExists
; Takes an object name (SamAccountName without leading 'CN=')
; Returns 1 if the object exists in the tree, 0 otherwise
Func _ADObjectExists($object)
	
	Local $strQuery
	Local $objRecordSet
	
	$strQuery = "<LDAP://" & $strHostServer & "/" & $strDNSDomain & ">;(sAMAccountName=" & $object & ");ADsPath;subtree"
	$objRecordSet = $ObjConnection.Execute ($strQuery)  ; Retrieve the FQDN for the group, if it exists
	
	If $objRecordSet.RecordCount = 1 Then
		$objRecordSet = 0
		Return 1
	Else
		$objRecordSet = 0
		Return 0
	EndIf
EndFunc   ;==>_ADObjectExists

; _ADDoError  : Error event handler for COM errors. This is global so will pick up errors from your program if you include this library
Func _ADDoError()
	Local $HexNumber = Hex($oMyError.number, 8)
	
	If $HexNumber = 80020009 Then
		SetError(3)
		Return
	EndIf
	
	If $HexNumber = "8007203A" Then
		SetError(4)
		Return
	EndIf
	
	MsgBox(262144, "", "COM Error !" & @CRLF & @CRLF & _
			"ErrorNumber " & @TAB & ": " & $HexNumber & @CRLF & _
			"WinDescription " & @TAB & ": " & $oMyError.windescription & @CRLF & _
			"LineNumber " & @TAB & ": " & $oMyError.scriptline)
		
	Select
		Case $oMyError.windescription = "Access is denied."
			$objConnection.Close ("Active Directory Provider")
			$objConnection.Open ("Active Directory Provider")
			SetError(2)
		Case 1
			SetError(1)
	EndSelect
	
EndFunc   ;==>_ADDoError



; here is the call to get the props
$Properties = _ADGetObjectProperties("nekes")
_ArrayDisplay($Properties)



