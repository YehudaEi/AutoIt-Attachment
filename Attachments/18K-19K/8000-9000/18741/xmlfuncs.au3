#Include <Array.au3>
#include-once

;Func _XMLCopyObjectAsObjectChild( $oSource, $oDest, $bIncludeAll=True )
;Func _XMLCreateChild($iIndex, $strXPath, $strNode, $strData = "", $strNameSpc = "")
;Func _XMLCreateObjectChild($oNode, $strNode, $strData = "", $strNameSpc = "")
;Func _XMLCreateChildWAttrib( $iIndex, $strXPath, $strNode, $aAttr, $aVal, $strData = "", $strNameSpc = "")
;Func _XMLCreateObjectChildWAttrib( $oNode, $strNode, $aAttr, $aVal, $strData = "", $strNameSpc = "")
;Func _XMLDeleteObject( ByRef $oNode )
;Func _XMLGetNodeCount( $iIndex, $sPath )
;Func _XMLGetAttrib($iIndex, $strXPath, $strAttrib)
;Func _XMLGetAllAttrib($iIndex, $strXPath, ByRef $aAttrib, ByRef $aValue )
;Func _XMLGetObjectAttrib($oNode, $strAttrib)
;Func _XMLGetObjectChildren( $oNode )

Global $__debugFunctions[ 1 ] = [ "Main" ]
Global $__debugEnabled = False
Global Const $__MAXXMLFILES =5
Global Const $_XMLUDFVER = "1.0.0.5"; udf version
Global $__DOMVERSION = -1

Global $strXMLFile[$__MAXXMLFILES];the current xml file name
Global $objXMLDoc[$__MAXXMLFILES];the current XML object
Global $bXMLAutoSave[$__MAXXMLFILES]
Global $oMyError ;COM error handler OBJ ; Initialize SvenP 's  error handler

Func _XMLCopyObjectAsObjectChild( $oSource, $oDest, $bIncludeAll=True, $bSubNodes=True )
	Local $i
	__DebugPushFunction( "_XMLCopyObjectAsObjectChild" )
	
	If Not IsObj( $oSource ) Then
		__DebugWrite( "Source is not an object." )
		__DebugPopFunction()
		SetError( 1 )
		Return -1
	EndIf
	If Not IsObj( $oDest ) Then
		__DebugWrite( "Destination is not an object." )
		__DebugPopFunction()
		SetError( 1 )
		Return -1
	EndIf
	
	Local $oClone = $oSource.CloneNode( $bIncludeAll )
	If Not IsObj( $oClone ) Then
		__DebugWrite( "Source object clone failed." )
		__DebugPopFunction()
		SetError( 1 )
		Return -1
	EndIf
	__DebugWrite( "Cloned source node." )
	
	If $bSubNodes Then
		Local $aoKiddies = _XMLGetObjectChildren( $oSource )
		  For $i = 1 to $aoKiddies[0]
			  _XMLCopyObjectAsObjectChild( $aoKiddies[ $i ], $oClone )
		  Next
	  EndIf
	  
	
	$oDest.appendChild( $oClone )
	__DebugWrite( "Inserted copy at destination." )
	
	
	__DebugPopFunction()
	Return $oClone
	
EndFunc

	
Func _XMLCreateChild($iIndex, $strXPath, $strNode, $strData = "", $strNameSpc = "")
	__DebugPushFunction( "_XMLCreateChild" )
	Local $objParent, $objChild, $aobjNodeList
	While @error = 0
		$aobjNodeList = _XMLSelectNodes( $iIndex, $strXPath)
		If $aobjNodeList[0] > 0 Then;.length <> 0 Then
			$objChild = _XMLCreateObjectChild( $aobjNodeList[1], $strNode, $strData, $strNameSpc )
			If 	$bXMLAutoSave[$iIndex] = True Then
				_XMLFileSave( $iIndex )
			EndIf
			__DebugPopFunction()
			Return $objChild
		Else
			ExitLoop
		EndIf
	WEnd
	;	__XMLError( "Error creating child node: " & $strNode & @CRLF & $strXPath & " does not exist." & @CRLF & $oMyError.windescription)
	_XMLError( 1, "Error creating child node: " & $strNode & @CRLF & $strXPath & " does not exist." & @CRLF)
	__DebugPopFunction()
	SetError(1)
	Return -1
EndFunc   ;==>__XMLCreateChildNode

Func _XMLCreateObjectChild($oNode, $strNode, $strData = "", $strNameSpc = "")
	__DebugPushFunction( "_XMLCreateObjectChild" )
	Local $objParent, $objChild, $objNodeList
	While @error = 0
		$objNodeList = $oNode
		If IsObj($objNodeList) Then;.length <> 0 Then
			;			For $objParent In $objNodeList.documentElement.selectNodes ($strXPath)
			$objParent=$objNodeList
				$objChild = $objParent.ownerDocument.createNode (1, $strNode, $strNameSpc)
				If $strData <> "" Then $objChild.text = $strData
				$objParent.appendChild ($objChild)
				__DebugWrite( "Node '" & $strNode & "' created." )
			$objParent = ""
			__DebugPopFunction()
			Return $objChild
		Else
			ExitLoop
		EndIf
	WEnd
	;	__XMLError( "Error creating child node: " & $strNode & @CRLF & $strXPath & " does not exist." & @CRLF & $oMyError.windescription)
	_XMLError( 1, "Error creating child node: " & $strNode & @CRLF & " does not exist." & @CRLF)
	__DebugPopFunction()
	SetError(1)
	Return -1
EndFunc   ;==>__XMLCreateChildNode

Func _XMLCreateChildWAttrib( $iIndex, $strXPath, $strNode, $aAttr, $aVal, $strData = "", $strNameSpc = "")
	__DebugPushFunction( "_XMLCreateChildWAttrib" )
	Local $oChild = _XMLCreateChild( $iIndex, $strXPath, $strNode, $strData, $strNameSpc )

	If Not IsObj( $oChild ) Then
		__DebugWrite( "Child Node not created successfully." )
		__DebugPopFunction()
		Return -1
	EndIf
	
	_XMLSetObjectAttrib( $oChild, $aAttr, $aVal )

	If 	$bXMLAutoSave[$iIndex] = True Then
		_XMLFileSave( $iIndex )
	EndIf

	__DebugPopFunction()
	Return $oChild

EndFunc

Func _XMLCreateObjectChildWAttrib( $oNode, $strNode, $aAttr, $aVal, $strData = "", $strNameSpc = "")
	__DebugPushFunction( "_XMLCreateObjectChildWAttrib" )
	If Not IsObj( $oNode ) Then
		__DebugWrite( "Error.  oNode is not an object." )
		_XMLError( 1, "Error creating child node: " & $strNode & ".")
		__DebugPopFunction()
		SetError(1)
		Return -1
	EndIf
		
	Local $oChild = _XMLCreateObjectChild( $oNode, $strNode, $strData, $strNameSpc )

	If Not IsObj( $oChild ) Then
		__DebugWrite( "Child Node not created successfully." )
		__DebugPopFunction()
		Return -1
	EndIf
	
	_XMLSetObjectAttrib( $oChild, $aAttr, $aVal )

	__DebugPopFunction()
	Return $oChild

EndFunc

Func _XMLDeleteObject( ByRef $oNode )
	__DebugPushFunction( "_XMLDeleteObject" )
	Local $xmlerr
	;$objNode = $objDoc[$oIndex].selectSingleNode ($strXPath)
	If Not IsObj($oNode) Then 
		__DebugWrite( "Node Not found" )
		__DebugPopFunction()
		Return False
	EndIf
	
	While @error = 0 ;And $objNode.length > 0
		$oNode.parentNode.removeChild ($oNode)
		$oNode=""
		__DebugWrite( "Node Deleted" )
		__DebugPopFunction()
		Return True
	WEnd
	;	__XMLError( "Error Deleting Node: " & $strXPath & @CRLF & $oMyError.windescription)
	_XMLError( 1, "Error Deleting Node: " & $xmlerr)
	__DebugPopFunction()
	SetError(1)
	Return -1
EndFunc   ;==>_XMLDeleteNode

Func _XMLGetNodeCount( $iIndex, $sPath )
	__DebugPushFunction( "_XMLGetNodeCount" )
	Local $aNodes = _XMLSelectNodes( $iIndex, $sPath )
	
	__DebugPopFunction()
	Return $aNodes[0]
EndFunc

Func _XMLGetAttrib($iIndex, $strXPath, $strAttrib)
	__DebugPushFunction( "_XMLGetAttrib" )
	Local $error, $objAttr, $aNodes
	;	If @error = 0 Then
	
	$aNodes = _XMLSelectNodes( $iIndex, $strXPath )
	If $aNodes[0] < 1 Then
		__DebugWrite( "Node not found." )
		__DebugPopFunction()
		SetError(1)
		Return -1
	EndIf
	
	$objAttr = _XMLGetObjectAttrib( $aNodes[1], $strAttrib )
	$error = @error
	__DebugPopFunction()
	SetError( $error )
	Return $objAttr
EndFunc   ;==>XMLGetAttribFromObject

Func _XMLGetAllAttrib($iIndex, $strXPath, ByRef $aAttrib, ByRef $aValue )
	__DebugPushFunction( "_XMLGetAllAttrib" )
	Local $error, $aNodes
	;	If @error = 0 Then
	
	$aNodes = _XMLSelectNodes( $iIndex, $strXPath )
	If $aNodes[0] < 1 Then
		__DebugWrite( "Node not found." )
		__DebugPopFunction()
		SetError(1)
		Return 
	EndIf
	
	_XMLGetObjectAllAttrib( $aNodes[1], $aAttrib, $aValue )
	$error = @error
	__DebugPopFunction()
	SetError( $error )
	Return 
EndFunc   ;==>XMLGetAttribFromObject

Func _XMLGetObjectAllAttrib($oNode, ByRef $aAttrib, ByRef $aValue )
	__DebugPushFunction( "_XMLGetObjectAllAttrib" )
	Local $xmlerr, $objAttr
	;	If @error = 0 Then
	While @error = 0
		
		If IsObj( $oNode ) > 0 Then
			$objAttr = $oNode.attributes
			If ($objAttr.length) Then
				__DebugWrite("Get all attrib " & $objAttr.length)
				ReDim $aAttrib[$objAttr.length]
				ReDim $aValue[$objAttr.length]
				For $i = 0 To $objAttr.length - 1
					$aAttrib[$i] = $objAttr.item ($i).nodeName
					$aValue[$i] = $objAttr.item ($i).Value
				Next
			Else
				__DebugWrite("Error:  no attributes found.")
				__DebugPopFunction()
				SetError(1)
				Return
			EndIf

			Return 
		Else
			_XMLError( 1, "No qualified items found" )
			__DebugWrite( "No qualified items found" )
			SetError(1)
			Return
		EndIf
	WEnd
	
	;_XMLError( 1, "Attribute " & $strAttrib & " not found for node " & $xmlerr)
	__DebugPopFunction()
	SetError(1)
	Return -1
EndFunc   ;==>XMLGetAttribFromObject

Func _XMLGetObjectAttrib($oNode, $strAttrib)
	__DebugPushFunction( "_XMLGetObjectAttrib" )
	Local $xmlerr, $objAttr
	;	If @error = 0 Then
	While @error = 0
		
		If IsObj( $oNode ) > 0 Then
			$objAttr = $oNode.getAttribute ($strAttrib)
			;				$arrResponse[$i] = $objAttr.text
			;				$arrResponse[$i] = $objAttr
			__DebugWrite($strAttrib & "=" & $objAttr)
			;__DebugWrite(>>" & $objAttr.text)
			
			__DebugPopFunction()
			Return $objAttr
		Else
			$xmlerr = @CRLF & "No qualified items found"
			ExitLoop
		EndIf
	WEnd
	
	_XMLError( 1, "Attribute " & $strAttrib & " not found for node " & $xmlerr)
	__DebugPopFunction()
	SetError(1)
	Return -1
EndFunc   ;==>XMLGetAttribFromObject

Func _XMLGetObjectChildren( $oNode )
	__DebugPushFunction( "_XMLGetObjectChildren" )
	Local $objNodeList, $arrResponse[1], $i, $xmlerr, $objAttr
	
	If IsObj( $oNode ) > 0 Then
		__DebugWrite( "Selecting object's children. ( '" & $oNode.nodeName & "' )" )
	Else
		__DebugPopFunction()
		SetError( 1 )
		Return -1
	EndIf
	
	$objNodeList = $oNode.childNodes
	;__DebugWrite("Get Attrib length= " & $objNodeList.length)
	;	If @error = 0 Then
	While @error = 0
		
		If $objNodeList.Length > 0 Then
			__DebugWrite( "Found " & $objNodeList.Length & " matching nodes." )
			ReDim $arrResponse[$objNodeList.length + 1]
			$arrResponse[ 0 ] = $objNodeList.length
			For $i = 0 To $objNodeList.length - 1
				$objAttr = $objNodeList.item ($i)
				$arrResponse[ $i + 1 ] = $objAttr
				;__DebugWrite("RET>>" & $objAttr)
				;__DebugWrite("Text>>" & $objAttr.text)
			Next
			__DebugPopFunction()
			Return $arrResponse
			
		Else
			__DebugWrite( "No qualified items found" )
			$arrResponse[0]=0
			__DebugPopFunction()
			Return $arrResponse
		EndIf
	WEnd
	
	;EndIf
;~ 	__XMLError( "Attribute " & $strAttrib & " not found for: " & $strXPath & @CRLF & $oMyError.windescription)
	;_XMLError( "Attribute " & $strAttrib & " not found for: " & $strXPath & $xmlerr)
	SetError(1)
	Return -1
	;	EndIf
EndFunc   ;==>_XMLGetAttrib

Func _XMLGetObjectName( $oNode )
	;__DebugPushFunction( "_XMLGetObjectName" )

	If IsObj( $oNode ) then
		Return $oNode.nodeName
	Else
		Return ""
	EndIf
	
EndFunc   ;==>XMLGetAttribFromObject

Func _XMLSetObjectAttrib($oNode, $aAttr, $aVal="")
	__DebugPushFunction( "_XMLSetObjectAttrib" )
	Local $xmlerr, $objAttr
	;	If @error = 0 Then
	While @error = 0
		
		If IsObj( $oNode ) > 0 Then
		If IsArray($aAttr) And IsArray($aVal) Then
			If UBound($aAttr) <> UBound($aVal) Then
				_XMLError( 1, "Attribute and value mismatch" & @CRLF & "Please make sure each attribute has a matching value.")
				__DebugPopFunction()
				SetError(2)
				Return -1
			Else
				Local $i
				For $i = 0 To UBound($aAttr) - 1
					__DebugWrite("Setting attribute '" & $aAttr[$i] & "'='" & $aVal[$i] & "'")
					If $aAttr[$i] = "" Then
						_XMLError( 1, "Error creating child node: " & @CRLF & " Attribute Name Cannot be NULL." & @CRLF)
						__DebugPopFunction()
						SetError(1)
						Return -1
					EndIf
					$oNode.SetAttribute ($aAttr[ $i ], $aVal[ $i ] )
					If @error <> 0 Then
						_XMLError( 1, "Error creating child node: " & @CRLF & "Node does not exist." & @CRLF)
						__DebugPopFunction()
						SetError(1)
						Return -1
					EndIf
				Next
				__DebugPopFunction()
				Return 0
			EndIf
		Else
			if isArray($aAttr) or IsArray($aVal) then 
				_XMLError( 1, "Attribute and value mismatch" & @CRLF & "Please make sure each attribute has a matching value.")
				__DebugPopFunction()
				SetError(1)
				Return -1
			EndIf
			if $aAttr ="" Then
				_XMLError(1, "Attribute Name cannot be empty string."&@LF)
				__DebugPopFunction()
				SetError(5)
				Return -1
			EndIf
					
			__DebugWrite("Setting attribute '" & $aAttr & "'='" & $aVal & "'")
			$oNode.SetAttribute ($aAttr, $aVal )
			If @error <> 0 Then
				_XMLError( 1, "Error creating child node: " & @CRLF & "Node does not exist." & @CRLF)
				__DebugPopFunction()
				SetError(1)
				Return -1
			EndIf
			__DebugPopFunction()
			Return 0

		EndIf

		Else
			$xmlerr = @CRLF & "No qualified items found"
			ExitLoop
		EndIf
	WEnd
	
	_XMLError( 1, "Error setting attribute for node: " & $xmlerr)
	__DebugPopFunction()
	SetError(1)
	Return -1
EndFunc   ;==>XMLGetAttribFromObject

Func _XMLFileClose( $iIndex )
	__DebugPushFunction( "_XMLFileClose" )
	If IsObj( $objXMLDoc[ $iIndex ] ) Then
		_XMLFileSave($iIndex)
		$objXMLDoc[ $iIndex ] = ""
		__DebugWrite( "Closed file #" & $iIndex & "." )
	EndIf
	__DebugPopFunction()
EndFunc

Func _XMLFileCreate( $strPath, $strRoot, $bOverwrite = False, $iIndex=-1, $ver=-1 )
	__DebugPushFunction( "_XMLFileCreate" )
	Local $retval, $fe, $objPI, $rootElement

	If $iIndex = -1 Then
		$iIndex = _XMLGetFreeFileHandle()
		If $iIndex = -1 then 
			_XMLError( 2, "No free file handles available with which to create '" & $strXMLFile & "'." )
			__DebugPopFunction()
			Return -1
		EndIf
	EndIf

	If _XMLFileInUse( $iIndex ) Then
		_XMLFileClose( $iIndex )
	EndIf

	$fe = FileExists($strPath)
	If $fe And Not $bOverwrite Then
			_XMLError( 2, "Error failed to create file: " & $strPath & @CRLF & "File exists.")
			__DebugPopFunction()
			SetError(1)
			Return -1
	Else
		FileCopy($strPath, $strPath & ".old", 1)
		FileDelete($strPath)
	EndIf
	
	;==== pick your poison
	;	$objDoc[$oIndex] = ObjCreate("Microsoft.XMLDOM")
	If $ver <> -1 Then
		If $ver > -1 And $ver < 7 Then
			$objXMLDoc[ $iIndex ] = ObjCreate("Msxml2.DOMDocument." & $ver & ".0")
			If IsObj($objXMLDoc[ $iIndex ]) Then
				$__DOMVERSION = $ver
			EndIf
		Else
			MsgBox(266288, "Error:", "Failed to create object with MSXML version " & $ver)
			__DebugPopFunction()
			SetError(1)
			Return -1
		EndIf
	Else
		For $x = 8 To 0 Step - 1
;			ConsoleWrite(@SystemDir & "\msxml" & $x & ".dll" & @LF)
			If FileExists(@SystemDir & "\msxml" & $x & ".dll") Then
				$objXMLDoc[ $iIndex ] = ObjCreate("Msxml2.DOMDocument." & $x & ".0")
				If IsObj($objXMLDoc[ $iIndex ]) Then
					$__DOMVERSION = $x
					__DebugWrite( "Autoselected MSXML Version" & $x & "." )
					ExitLoop
				EndIf
			EndIf
		Next
	EndIf
	if $oMyError = "" then	$oMyError = ObjEvent("AutoIt.Error", "_COMerr") ; ; Initialize SvenP 's  error handler
	$objPI = $objXMLDoc[$iIndex].createProcessingInstruction ("xml", "version=""1.0""")
	$objXMLDoc[$iIndex].appendChild ($objPI)
	$rootElement = $objXMLDoc[$iIndex].createElement ($strRoot)
	$objXMLDoc[$iIndex].documentElement = $rootElement
	$strXMLFile[$iIndex] = $strPath
	$bXMLAutoSave[$iIndex] = True
	$objXMLDoc[$iIndex].save ($strPath)
	__DebugWrite( "Created file '" & $strPath & "' as #" & $iIndex & "." )
	If $objXMLDoc[$iIndex].parseError.errorCode <> 0 Then
		_XMLError( 1, "Error Creating specified file: " & $strPath)
		__DebugPopFunction()
		SetError($objXMLDoc[$iIndex].parseError.errorCode)
		Return -1
	EndIf
	
	__DebugPopFunction()
	Return $iIndex
EndFunc   ;==>_XMLCreateFile

Func _XMLFileInUse( $iIndex )
	Return IsObj( $objXMLDoc[ $iIndex ] )
EndFunc

Func _XMLFileOpen($strFile, $iIndex=-1, $strNameSpc = "", $ver = -1)
	__DebugPushFunction( "_XMLFileOpen" )
	If $iIndex = -1 Then
		$iIndex = _XMLGetFreeFileHandle()
		If $iIndex = -1 then 
			_XMLError( 2, "No free file handles available with which to open '" & $strXMLFile & "'." )
			__DebugPopFunction()
			Return -1
		EndIf
	EndIf
	
	If _XMLFileInUse( $iIndex ) Then
		_XMLFileClose( $iIndex )
	EndIf
	
	;==== pick your poison
	If $ver <> -1 Then
		If $ver > -1 And $ver < 7 Then
			$objXMLDoc[ $iIndex ] = ObjCreate("Msxml2.DOMDocument." & $ver & ".0")
			If IsObj($objXMLDoc[ $iIndex ]) Then
				$__DOMVERSION = $ver
			EndIf
		Else
			MsgBox(266288, "Error:", "Failed to create object with MSXML version " & $ver)
			__DebugPopFunction()
			SetError(1)
			Return -1
		EndIf
	Else
		For $x = 8 To 0 Step - 1
;			ConsoleWrite(@SystemDir & "\msxml" & $x & ".dll" & @LF)
			If FileExists(@SystemDir & "\msxml" & $x & ".dll") Then
				$objXMLDoc[ $iIndex ] = ObjCreate("Msxml2.DOMDocument." & $x & ".0")
				If IsObj($objXMLDoc[ $iIndex ]) Then
					$__DOMVERSION = $x
					__DebugWrite( "Autoselected MSXML Version" & $x & "." )
					ExitLoop
				EndIf
			EndIf
		Next
	EndIf
	if @error Then
;		If Not IsObj($objXMLDoc[$oIndex]) Then
		_XMLError( 0, "Error: MSXML not found. This object is required to use this program.")
		;		msgBox(0,"Error","MSXML not found. This object is required to use this program.")
		__DebugPopFunction()
		SetError(2)
		Return -1
	EndIf
	if $oMyError = "" then	$oMyError = ObjEvent("AutoIt.Error", "_COMerr") ; ; Initialize SvenP 's  error handler
	$objXMLDoc[$iIndex].async = False
	$strXMLFile[$iIndex] = $strFile
	$objXMLDoc[$iIndex].Load ($strXMLFile[$iIndex])
	__DebugWrite( "Loaded file '" & $strFile & "' as #" & $iIndex & "." )
	$objXMLDoc[$iIndex].setProperty ("SelectionNamespaces", $strNameSpc); "xmlns:ms='urn:schemas-microsoft-com:xslt'"
	$objXMLDoc[$iIndex].setProperty ("SelectionLanguage", "XPath")
	$bXMLAutoSave[$iIndex] = True
	If $objXMLDoc[$iIndex].parseError.errorCode <> 0 Then
		_XMLError( 2, "Error opening specified file: " & $strFile & @CRLF & $objXMLDoc[$iIndex].parseError.reason)
		__DebugPopFunction()
		SetError($objXMLDoc[$iIndex].parseError.errorCode)
		Return -1
	EndIf
	__DebugPopFunction()
	Return $iIndex
EndFunc   ;==>__XMLFileOpen

Func _XMLFileSave( $iIndex )
	__DebugPushFunction( "_XMLFileSave" )
	If IsObj( $objXMLDoc[ $iIndex ] ) Then
		$objXMLDoc[$iIndex].Save ($strXMLFile[$iIndex])
		__DebugWrite( "File #" & $iIndex & " saved." )
	EndIf
	__DebugPopFunction()
EndFunc

Func _XMLFileSetAutoSave( $iIndex, $bState=True )
	__DebugPushFunction( "_XMLFileSetAutoSave" )
	
	If $bState<>False Then
		$bState = True
	EndIf
	
	$bXMLAutoSave[ $iIndex ] = $bState
	__DebugWrite( "Autosave set to " & $bState & " for file #" & $iIndex & "." )
	
	If $bState = True Then
		_XMLFileSave( $iIndex )
	EndIf
	
	__DebugPopFunction()
EndFunc

Func _XMLGetFreeFileHandle()
	__DebugPushFunction( "_XMLGetFreeFileHandle" )
	Local $i
	For $i = 0 to $__MAXXMLFILES - 1
		If Not IsObj( $objXMLDoc[ $i ] ) then
			__DebugWrite( "Handle is " & $i & "." )
			__DebugPopFunction()
			Return $i
		EndIf
	Next
	__DebugPopFunction()
	Return -1
EndFunc

Func _XMLSelectNodes($iIndex, $strXPath )
	__DebugPushFunction( "_XMLSelectNodes" )
	Local $objNodeList, $arrResponse[1], $i, $xmlerr, $objAttr
	
	__DebugWrite( "Selecting '" & $strXPath & "' from file #" & $iIndex & "." )
	$objNodeList = $objXMLDoc[$iIndex].selectNodes ($strXPath )
	;__DebugWrite("Get Attrib length= " & $objNodeList.length)
	;	If @error = 0 Then
	While @error = 0
		
		If $objNodeList.Length > 0 Then
			__DebugWrite( "Found " & $objNodeList.Length & " matching nodes." )
			ReDim $arrResponse[$objNodeList.length + 1]
			$arrResponse[ 0 ] = $objNodeList.length
			For $i = 0 To $objNodeList.length - 1
				$objAttr = $objNodeList.item ($i)
				$arrResponse[ $i + 1 ] = $objAttr
				;__DebugWrite("RET>>" & $objAttr)
				;__DebugWrite("Text>>" & $objAttr.text)
			Next
			__DebugPopFunction()
			Return $arrResponse
			
		Else
			__DebugWrite( "No qualified items found" )
			$arrResponse[0]=0
			__DebugPopFunction()
			Return $arrResponse
		EndIf
	WEnd
	
	;EndIf
;~ 	__XMLError( "Attribute " & $strAttrib & " not found for: " & $strXPath & @CRLF & $oMyError.windescription)
	;_XMLError( "Attribute " & $strAttrib & " not found for: " & $strXPath & $xmlerr)
	SetError(1)
	Return -1
	;	EndIf
EndFunc   ;==>_XMLGetAttrib

Func _XMLError( $iSeverity, $sMsg )
	ConsoleWrite( @CRLF & "Error Severity " & $iSeverity & " - " & $sMsg )
EndFunc

Func __DebugMode( $bMode = True )
	If $bMode <> False Then
		$bMode = True
	EndIf
	
	$__debugEnabled = $bMode
EndFunc

Func __DebugPopFunction( )
	_ArrayPop( $__debugFunctions )
EndFunc

Func __DebugPushFunction( $sString )
	_ArrayAdd( $__debugFunctions, $sString )
EndFunc

Func __DebugWrite( $sString )
	If $__debugEnabled = True Then
		ConsoleWrite( _ArrayToString( $__debugFunctions, ":" ) & " " & $sString & @CRLF )
	EndIf
EndFunc

Func _COMerr()
	_ComErrorHandler()
	Return
	Local $COMErr_Silent, $HexNumber,$quiet
;~ 	;===============================================================================
;~ 	;added silent switch to allow the func returned to the option to display custom
;~ 	;error messages
;~ 	If $quiet = True Or $quiet = False Then
;~ 		$COMErr_Silent = $quiet
;~ 		$quiet = ""
;~ 		Return
;~ 	EndIf
;~ 	;===============================================================================
;~ 	If $COMErr_Silent <> True Then
		
		;	ConsoleWrite("COM Error")
		$HexNumber = Hex($oMyError.number, 8)
		if @error then return
			
		MsgBox(0, @AutoItExe, "COM Error with DOM!" & @CRLF & @CRLF & _
				"err.description is: " & @TAB & $oMyError.description & @CRLF & _
				"err.windescription:" & @TAB & $oMyError.windescription & @CRLF & _
				"err.number is: " & @TAB & $HexNumber & @CRLF & _
				"err.lastdllerror is: " & @TAB & $oMyError.lastdllerror & @CRLF & _
				"err.scriptline is: " & @TAB & $oMyError.scriptline & @CRLF & _
				"err.source is: " & @TAB & $oMyError.source & @CRLF & _
				"err.helpfile is: " & @TAB & $oMyError.helpfile & @CRLF & _
				"err.helpcontext is: " & @TAB & $oMyError.helpcontext _
				)
		SetError(1) ; to check for after this function returns
		;	MsgBox(4096, "COM Error", "There is a COM Error")
;~ 	EndIf
EndFunc   ;==>_COMerr
Func _ComErrorHandler($quiet = False)
	Local $COMErr_Silent, $HexNumber
	;===============================================================================
	;added silent switch to allow the func returned to the option to display custom
	;error messages
	If $quiet = True Or $quiet = False Then
		$COMErr_Silent = $quiet
		$quiet = ""
		Return
	EndIf
	;===============================================================================
	If $COMErr_Silent <> True Then
		
		;	ConsoleWrite("COM Error")
		$HexNumber = Hex($oMyError.number, 8)
		if @error then return
			
		MsgBox(0, @AutoItExe, "COM Error with DOM!" & @CRLF & @CRLF & _
				"err.description is: " & @TAB & $oMyError.description & @CRLF & _
				"err.windescription:" & @TAB & $oMyError.windescription & @CRLF & _
				"err.number is: " & @TAB & $HexNumber & @CRLF & _
				"err.lastdllerror is: " & @TAB & $oMyError.lastdllerror & @CRLF & _
				"err.scriptline is: " & @TAB & $oMyError.scriptline & @CRLF & _
				"err.source is: " & @TAB & $oMyError.source & @CRLF & _
				"err.helpfile is: " & @TAB & $oMyError.helpfile & @CRLF & _
				"err.helpcontext is: " & @TAB & $oMyError.helpcontext _
				)
		SetError(1) ; to check for after this function returns
		;	MsgBox(4096, "COM Error", "There is a COM Error")
	EndIf
EndFunc