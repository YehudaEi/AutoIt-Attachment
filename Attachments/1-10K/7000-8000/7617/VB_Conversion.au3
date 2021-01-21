
#include <Constants.au3>						; Defines common AutoIt variables
#include <_COMErrHandler.au3>					; COM Object error handler
#include <_ADQuery.au3>

;Option Explicit
AutoItSetOption ( 'MustDeclareVars', 1 )		; All variables must be declared before using them


;Dim strCN, objRootDSE, strDNSDomain, objCommand, objConnection
Dim $strCN, $objRootDSE, $strDNSDomain, $objCommand, $objConnection
;Dim strBase, strFilter, strAttributes, strQuery, objRecordSet
Dim $strBase, $strFilter, $strAttributes, $strQuery, $objRecordSet
;Dim strDN, strDisplay, strObjectCategory, intIndex
Dim $strDN, $strDisplay, $strObjectCategory, $intIndex

;' Check for required argument.
;If Wscript.Arguments.Count < 1 Then
If $CmdLine[0] <> 1 Then
;	Wscript.Echo "Required argument <Common Name> missing. For example:" _
;		& vbCrLf & "cscript CommonName.vbs TestUser"
	MsgBox ( 0, '', 'Required argument <Common Name> missing. For example:' & _
					@CRLF & @ScriptName & ' TestUser' )
;	Wscript.Quit(0)
	Exit 0
;End If
EndIf

;strCN = Wscript.Arguments(0)
$strCN = $CmdLine[1]

;' Determine DNS domain name.
;Set objRootDSE = GetObject("LDAP://RootDSE")
$objRootDSE = ObjGet("LDAP://RootDSE")
;strDNSDomain = objRootDSE.Get("defaultNamingContext")
$strDNSDomain = $objRootDSE.Get("defaultNamingContext")

;' Use ADO to search Active Directory.
;Set objCommand = CreateObject("ADODB.Command")
$objCommand = ObjCreate("ADODB.Command")
;Set objConnection = CreateObject("ADODB.Connection")
$objConnection = ObjCreate("ADODB.Connection")
;objConnection.Provider = "ADsDSOObject"
$objConnection.Provider = "ADsDSOObject"
;objConnection.Open "Active Directory Provider"
$objConnection.Open ("Active Directory Provider")
;objCommand.ActiveConnection = objConnection
$objCommand.ActiveConnection = $objConnection
;strBase = "<LDAP://" & strDNSDomain & ">"
$strBase = "<LDAP://" & $strDNSDomain & ">"

;strFilter = "(cn=" & strCN & ")"
$strFilter = "(cn=" & $strCN & ")"
;strAttributes = "distinguishedName,objectCategory"
$strAttributes = "distinguishedName,objectCategory"
;strQuery = strBase & ";" & strFilter & ";" & strAttributes & ";subtree"
$strQuery = $strBase & ";" & $strFilter & ";" & $strAttributes & ";subtree"
;objCommand.CommandText = strQuery
$objCommand.CommandText = $strQuery
;objCommand.Properties("Page Size") = 100
$objCommand.Properties("Page Size") = 100
;objCommand.Properties("Timeout") = 30
$objCommand.Properties("Timeout") = 30
;objCommand.Properties("Cache Results") = False
$objCommand.Properties("Cache Results") = False
;Set objRecordSet = objCommand.Execute
$objRecordSet = $objCommand.Execute

;If objRecordSet.EOF Then
If $objRecordSet.EOF Then
;	Wscript.Echo "Object not found with cn=" & strCN
		MsgBox ( 0, '', "Object not found with cn=" & $strCN )
;	Wscript.Quit
	Exit
;End If
EndIf

;strDisplay = "Object(s) found"
$strDisplay = "Object(s) found"
;Do Until objRecordSet.EOF
Do
;	strDN = objRecordSet.Fields("distinguishedName")
	$strDN = $objRecordSet.Fields("distinguishedName")
;	strObjectCategory = objRecordSet.Fields("objectCategory")
	$strObjectCategory = $objRecordSet.Fields("objectCategory")
;	intIndex = InStr(strObjectCategory, "=")
	$intIndex = StringInStr($strObjectCategory, "=")
;	strObjectCategory = Mid(strObjectCategory, intIndex + 1)
	$strObjectCategory = StringRight($strObjectCategory, Stringlen($strObjectCategory) - $intIndex + 1)	; !!! MAY NOT BE CORRECT !!!
;	intIndex = InStr(strObjectCategory, ",")
	$intIndex = StringInStr($strObjectCategory, ",")
;	strObjectCategory = Mid(strObjectCategory, 1, intIndex - 1)
	$strObjectCategory = StringMid($strObjectCategory, 1, $intIndex - 1)	; I think this should be right
;	strDisplay = strDisplay & vbCrLf & strDN & " (" _
;		& strObjectCategory & ")"
	$strDisplay = $strDisplay & @CRLF & $strDN & " (" & _
		$strObjectCategory & ")"
;	objRecordSet.MoveNext
	$objRecordSet.MoveNext
;Loop
Until $objRecordSet.EOF

;Wscript.Echo strDisplay
MsgBox ( 0, '', $strDisplay )

; ' Clean up.			; This shouldn't be needed, but here it is anyway...
;objConnection.Close
$objConnection.Close
;Set objRootDSE = Nothing
$objRootDSE = ''
;Set objCommand = Nothing
$objCommand = ''
;Set objConnection = Nothing
$objConnection = ''
;Set objRecordSet = Nothing
$objRecordSet = ''
