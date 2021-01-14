;#include "XML DOM Wrapper.au3"
#include <Array.au3>

Global Const $_XMLUDFVER = "1.0.3.33"; udf version
Global Const $NODE_ELEMENT = 1;
Global Const $NODE_ATTRIBUTE = 2;
Global Const $NODE_TEXT = 3;
Global Const $NODE_CDATA_SECTION = 4;
Global Const $NODE_ENTITY_REFERENCE = 5;
Global Const $NODE_ENTITY = 6;
Global Const $NODE_PROCESSING_INSTRUCTION = 7;
Global Const $NODE_COMMENT = 8;
Global Const $NODE_DOCUMENT = 9;
Global Const $NODE_DOCUMENT_TYPE = 10;
Global Const $NODE_DOCUMENT_FRAGMENT = 11;
Global Const $NODE_NOTATION = 12;


Global $strFile, $oMyError, $debugging = True
Global $sXML_error
Global Enum $_xIniFileName, $_xIniFileHandle, $_xIniFileMax 
Global $_xIniFiles[1][$_xIniFileMax]
Global $_RootName = "IniXML"

$TestFile = "Test.xml"
xIniWrite($TestFile, "Section1", "key1", "One")
xIniWrite($TestFile, "Section1", "key2", "Two")
xIniWrite($TestFile, "Section1", "key1", "Three")
MsgBox(0,"Result", xIniRead($TestFile, "Section1", "key1", "Two"))
$var = xIniReadSection($TestFile, "Section1")
For $i = 1 To $var[0][0]
	MsgBox(4096, "", "Key: " & $var[$i][0] & @CRLF & "Value: " & $var[$i][1])
Next

$var = xIniReadSectionNames($TestFile)
_ArrayDisplay($var, "Section Names")
xIniRenameSection($TestFile, "Section1", "Section2")
Exit

Func xIniDelete($filename, $path, $key)
EndFunc

Func xIniRead($filename, $path, $key, $default)
local $xFile = GetFileHandle($filename), $FullPath = _CreatePath($path,$key), $Result
	$Value = _XMLGetValue($xFile, $FullPath)
	if IsArray($Value) Then
		$Result = $Value[1] 
	EndIf
	if @error Then
		$Result = $default
	EndIf
	Return $Result
EndFunc		

Func xIniReadSection($filename, $path)
Local $names[1], $nodes, $result[1][2]
Local $xFile = GetFileHandle($filename)
	$nNode = _XMLGetNodeCount($xFile, _CreatePath($path,"*"))
	;MsgBox(0,"nodecount", $nNode)
	if $nNode > 0 Then
		$nodes = _XMLSelectNodes($xFile, _CreatePath($path,"*") , $names)
		
		if not @error Then
			_ArrayResize($result, $nodes[0])
			$result[0][0] = $nodes[0]
			For $i = 1 to $nodes[0]
				$tmp = $nodes[$i]
				;MsgBox(0, "names[" & $i & "]", $names[$i] & " = " & $tmp.text)
				$result[$i][0] = $names[$i]
				$result[$i][1] = $nodes[$i].text
			Next
		EndIf
	EndIf
	Return $result			
EndFunc

Func xIniReadSectionNames($filename)
Local $names[1], $result
Local $xFile = GetFileHandle($filename)
	$nNode = _XMLGetNodeCount($xFile, $_RootName & "/*")
	if $nNode > 0 Then
		$nodes = _XMLSelectNodes($xFile, $_RootName & "/*", $names)
		if not @error Then
			$result = $names
		EndIf
	EndIf
	Return $result
EndFunc

Func xIniRenameSection($filename, $path, $newpath, $flag = 0)
Local $xFile = GetFileHandle($filename)
	_XMLUpdateField($xFile, _CreatePath($path), _CreatePath($newpath))
EndFunc

Func xIniWrite($filename, $path, $key, $value)
Local $xFile , $FullPath = _CreatePath($path,$key), $names[1], $Found
	$xFile = GetFileHandle($filename)
	$Found = False
	if Not IsObj($xFile) Then
		MsgBox(0,"Error", "No se obtuvo el handle")
	Else
		$nodes = _XMLSelectNodes($xFile,_CreatePath($path,"*"), $names)
		if UBound($nodes) > 1 Then
			For $i = 1 to $nodes[0]
				;MsgBox(0, "names[" & $i &"]", $names[$i])
				if $names[$i] = $key Then
					$Found = True
					ExitLoop
				EndIf
			Next
		Else
			_XMLCreateRootChild($xFile, $path)
			;$Found = False
		EndIf
		if $Found Then
			;MsgBox(0,"aviso", "Section found")
			_XMLUpdateField($xFile, $FullPath, $value)
		Else
			_XMLCreateChildNode($xFile, $_RootName & "/" & $path, $key, $value)
		EndIf
	EndIf
EndFunc

Func xIniWriteSection($filename, $path, $data, $index)
EndFunc

Func _ArrayResize(ByRef $Array, $Rows, $Cols=0)
	if UBound($Array,0) = 1 Then
		ReDim $Array[UBound($Array)+$Rows]
	ElseIf UBound($Array,0) = 2 Then
		ReDim $Array[UBound($Array)+$Rows][UBound($Array,2)+$Cols]
	EndIf
	Return UBound($Array) - 1
EndFunc

Func FileIsOpened($filename)
Local $i, $Found = 0
	For $i = 1 to UBound($_xIniFiles) -1
		if $_xIniFiles[$i][$_xIniFileName] = $filename Then
			$Found = $i
		EndIf
	Next
	Return $Found
EndFunc

Func GetFileHandle($filename)
Local $index = 0
	$index = FileIsOpened($filename)
	if not $index Then
		$index = _ArrayResize($_xIniFiles,1)
		If FileExists($filename) Then
			$_xIniFiles[$index][$_xIniFileName] = $filename
			$_xIniFiles[$index][$_xIniFileHandle] = _XMLFileOpen($filename)
		Else
			$_xIniFiles[$index][$_xIniFileName] = $filename
			_XMLCreateFile($filename, $_RootName, True)
			$_xIniFiles[$index][$_xIniFileHandle] = _XMLFileOpen($filename)
		EndIf
	EndIf
	$strFile = $filename
	Return $_xIniFiles[$index][$_xIniFileHandle]
EndFunc
	
Func _CreatePath($path, $key="")
	If $key = "" Then
		Return $_RootName & "/" & $path
	Else
		Return $_RootName & "/" & $path & "/" & $key
	EndIf
EndFunc
	
;===============================================================================
; Function Name:	_XMLGetAttrib
; Description:		Get XML Field(s) based on XPath input from root node.
; Parameters:		$path	xml tree path from root node (Root/child/child..)
; Syntax:			_XMLGetAttrib($path,$attrib)
; Author(s):		Stephen Podhajecki <gehossafats@netmdc.com>
; Returns:			array of fields text values
;					on error set error to 1 and returns -1
;===============================================================================
Func _XMLGetAttrib($objDoc, $strXPath, $strAttrib, $strQuery = "")
	Local $objNodeList, $arrResponse[1], $i, $xmlerr, $objAttr
	$objNodeList = $objDoc.selectNodes ($strXPath & $strQuery)
	;_DebugWrite("Get Attrib length= " & $objNodeList.length)
	;	If @error = 0 Then
	While @error = 0
		
		If $objNodeList.length > 0 Then
			;			_DebugWrite ("Length:" & $objNodeList.length)
			ReDim $arrResponse[$objNodeList.length]
			For $i = 0 To $objNodeList.length - 1
				$objAttr = $objNodeList.item ($i).getAttribute ($strAttrib)
				;				$arrResponse[$i] = $objAttr.text
				;				$arrResponse[$i] = $objAttr
				$arrResponse = $objAttr
				;_DebugWrite("RET>>" & $objAttr)
;				_DebugWrite("Text>>" & $objAttr.text)
			Next
			Return $arrResponse
		Else
			$xmlerr = @CRLF & "No qualified items found"
			ExitLoop
		EndIf
	WEnd
;	EndIf
	;EndIf
;~ 	_XMLError( "Attribute " & $strAttrib & " not found for: " & $strXPath & @CRLF & $oMyError.windescription)
	_XMLError( "Attribute " & $strAttrib & " not found for: " & $strXPath & $xmlerr)
	SetError(1)
	Return -1
	;	EndIf
EndFunc   ;==>_XMLGetAttrib

;===============================================================================
; Function Name:	_XMLUpdateField
; Description:		Update existing node(s) based on XPath specs.
; Parameters:		$path	Path from Root node
;					$new_data	Data to update node with
; Syntax:			_XMLUpdateField($path,$new_data)
; Author(s):		Stephen Podhajecki <gehossafats@netmdc.com>
; Returns:			on error set error to 1 and returns -1
;===============================================================================
Func _XMLUpdateField($objDoc, $strXPath, $strData)
	Local $objField, $objNodeList
	#forceref $objField
	While @error = 0
		$objNodeList = $objDoc.selectNodes ($strXPath)
		If IsObj($objNodeList) And $objNodeList.length > 0 Then
			;	If $objDoc.documentElement.selectNodes ($strXPath) Then
			For $objField In $objNodeList
				$objField.Text = $strData
			Next
			$objDoc.Save ($strFile)
			$objField = ""
			Return
		Else
			ExitLoop
		EndIf
	WEnd
	
	;	Else
	;		_XMLError( "Failed to update field for: " & $strXPath & @CRLF & $oMyError.windescription)
	_XMLError( "Failed to update field for: " & $strXPath & @CRLF)
	SetError(1)
	Return -1
	;	EndIf
EndFunc   ;==>_XMLUpdateField

;===============================================================================
; Function Name:	_XMLGetField
; Description:		Get XML Field(s) based on XPath input from Root node.
; Parameters:		$path	xml tree path from Root node (Root/child/child..)
; Syntax:			_XMLGetField($path)
; Author(s):		Stephen Podhajecki <gehossafats@netmdc.com>
; Returns:			array of fields text values -1 on failure
;===============================================================================
Func _XMLGetField($objDoc, $strXPath)
	Local $objNodeList, $arrResponse[1], $xmlerr
	While @error = 0
		$objNodeList = $objDoc.selectNodes ($strXPath)
		If $objNodeList.length > 0 Then
			;_DebugWrite("GetField list length:" & $objNodeList.length)
			For $objNode In $objNodeList
				_ArrayAdd($arrResponse, $objNode.Text)
				;_DebugWrite("GetField:" & $objNode.Text)
			Next
			$arrResponse[0] = $objNodeList.length
			Return $arrResponse
		Else
			$xmlerr = @CRLF & "No matching node(s)found!"
			ExitLoop
		EndIf
		
	WEnd
	;	_XMLError( "Error Retrieving: " & $strXPath & @CRLF & $oMyError.windescription)
	_XMLError( "Error Retrieving: " & $strXPath & $xmlerr)
	;			_XMLError( "No matching node(s)found for: " & $strXPath & @CRLF & $oMyError.windescription)
	SetError(1)
	Return -1
	
EndFunc   ;==>_XMLGetField	

;===============================================================================
; Function Name:	_XMLCreateChildNode
; Description:		Create a child node under the specified XPath Node.
; Parameters:		$path	Path from Root
;					$node	Node to add
; Syntax:			_XMLCreateChildNode($path,$node)
; Author(s):		Stephen Podhajecki <gehossafats@netmdc.com>
; Returns:			on error set error to 1 and returns -1
;===============================================================================
Func _XMLCreateChildNode($objDoc, $strXPath, $strNode, $strData = "", $strNameSpc = "")
	Local $objParent, $objChild, $objNodeList
	While @error = 0
		$objNodeList = $objDoc.selectNodes ($strXPath)
		If IsObj($objNodeList) And $objNodeList.length <> 0 Then;.length <> 0 Then
			;			For $objParent In $objNodeList.documentElement.selectNodes ($strXPath)
			For $objParent In $objNodeList
				$objChild = $objDoc.createNode (1, $strNode, $strNameSpc)
				If $strData <> "" Then $objChild.text = $strData
				$objParent.appendChild ($objChild)
				_AddFormat($objDoc)
			Next
			$objDoc.Save ($strFile)
			$objParent = ""
			$objChild = ""
			Return
		Else
			ExitLoop
		EndIf
	WEnd
	;	_XMLError( "Error creating child node: " & $strNode & @CRLF & $strXPath & " does not exist." & @CRLF & $oMyError.windescription)
	_XMLError( "Error creating child node: " & $strNode & @CRLF & $strXPath & " does not exist." & @CRLF)
	SetError(1)
	Return -1
EndFunc   ;==>_XMLCreateChildNode

;===============================================================================
; Function Name:    _XMLGetNodeCount
; Description:        Get Node Count based on XPath input from Root node.
; Parameters:        $path    xml tree path from Root node (Root/child/child..)
;                    [$query] DOM compliant query string  (not really necessary as it becomes part of the path
;					$iNodeType  The type of node to count. (element, attrib, comment etc.)
; Syntax:            _XMLGetNodeCount($path,$query)
; Author(s):        Stephen Podhajecki <gehossafats@netmdc.com> & DickB
; Returns:          0 or Number of Nodes found
;                    on error set error to 1 and returns -1
;===============================================================================
Func _XMLGetNodeCount($objDoc, $strXPath, $strQry = "", $iNodeType = 1)
	Local $objQueryNodes, $objNode, $nodeCount = 0, $errMsg
	;   $objQueryNodes = $objDoc.documentElement.selectNodes ($strXPath & $strQry)
	$objQueryNodes = $objDoc.selectNodes ($strXPath & $strQry)
	If @error = 0 And $objQueryNodes.length > 0 Then
		For $objNode In $objQueryNodes
			If $objNode.nodeType = $iNodeType Then $nodeCount = $nodeCount + 1
		Next
		Return $nodeCount
	Else
		$errMsg="No nodes of specified type found." 
	EndIf
	;    _XMLError( "Error retrieving node count for: " & $strXPath & @CRLF & $oMyError.windescription & @CRLF & $oMyError.scriptline)
	_XMLError( "Error retrieving node count for: " & $strXPath & @CRLF& $errMsg&@CRLF)
	SetError(1)
	Return -1
	;    EndIf
EndFunc   ;==>_XMLGetNodeCount

;===============================================================================
; Function Name:	_XMLSelectNodes
; Description:		Selects XML Node(s) based on XPath input from Root node.
; Parameters:		$path	xml tree path from Root node (Root/child/child..)
; Syntax:			_XMLDeleteNode($path)
; Author(s):		Stephen Podhajecki <gehossafats@netmdc.com>
; Returns:			array of Nodes or -1 on failure
;===============================================================================
Func _XMLSelectNodes($objDoc, $strXPath,ByRef $aNames)
	;MsgBox(266288,"Params",@NumParams)
	Local $objNode, $objNodeList, $arrResponse[1], $xmlerr
	$objNodeList = $objDoc.selectNodes ($strXPath)
	While @error = 0
		If Not IsObj($objNode) Then $xmlerr = @CRLF & "No Matching Nodes found"
		For $objNode In $objNodeList
			_ArrayAdd($arrResponse, $objNode)
			;_ArrayAdd($arrResponse, $objNode.baseName)
			_ArrayAdd($aNames,$objNode.nodeName)
		Next
		$arrResponse[0] = $objNodeList.length
		Return $arrResponse
	WEnd
	;	_XMLError( "Error Selecting Node(s): " & $strXPath & @CRLF & $oMyError.windescription)
	_XMLError( "Error Selecting Node(s): " & $strXPath & $xmlerr)
	SetError(1)
	Return -1
EndFunc   ;==>_XMLSelectNodes

;===============================================================================
; Function Name:	 _XMLFileOpen
; Description:		Creates an instance of an XML file.
; Parameters:		$filename
; Syntax:			 _XMLFileOpen($strFile)
; Author(s):		Stephen Podhajecki <gehossafats@netmdc.com>
; Returns:			Obj on success -1 on failure set error 2 = no obj or
;													error= parse error
;===============================================================================
Func _XMLFileOpen($strXMLFile, $strNameSpc = "")
	;==== pick your poison
		$objDoc = ObjCreate("Msxml2.DOMDocument.4.0")
		if not IsObj($objDoc) Then 	$objDoc = ObjCreate("Msxml2.DOMDocument.3.0")
		if not IsObj($objDoc) Then 	$objDoc = ObjCreate("Microsoft.XMLDOM")
	If Not IsObj($objDoc) Then
		_XMLError( "Error: MSXML not found. This object is required to use this program.")
		SetError(2)
		Return -1
	EndIf
	if $oMyError <> "" then $oMyError =""
	$oMyError = ObjEvent("AutoIt.Error", "_COMerr") ; ; Initialize SvenP 's  error handler
	$objDoc.async = False
	$objDoc.preserveWhiteSpace = true
	$strFile = $strXMLFile
	$objDoc.Load ($strFile)
	$objDoc.setProperty ("SelectionNamespaces", $strNameSpc); "xmlns:ms='urn:schemas-microsoft-com:xslt'"
	$objDoc.setProperty ("SelectionLanguage", "XPath")
	If $objDoc.parseError.errorCode <> 0 Then
		_XMLError( "Error opening specified file: " & $strXMLFile & @CRLF & $objDoc.parseError.reason)
		SetError($objDoc.parseError.errorCode)
		Return -1
	EndIf
	Return $objDoc
EndFunc   ;==>_XMLFileOpen

;===============================================================================
; Function Name:	_XMLCreateFile
; Description:		Create a new blank metafile with header.
; Parameters:		$filename	The xml filename with full path to create
;					$root		The root of the xml file to create
;					[overwrite] boolean flag to auto overwrite existing
;								xml file of same name. Defaults to false and
;								will prompt to overwrite.
;								Overwrite copies the file with the ext .old
;								Then deletes the original file.
; Syntax:			_XMLCreateFile($filename,$root,[flag])  flag is boolean
; Author(s):		Stephen Podhajecki <gehossafats@netmdc.com>
; Returns:			-1 on failure
;===============================================================================
Func _XMLCreateFile($strPath, $strRoot, $bOverwrite = False)
	Local $retval, $fe, $objPI, $objDoc, $rootElement
	$fe = FileExists($strPath)
	If $fe And Not $bOverwrite Then
		$retval = (MsgBox(4097, "File Exists:", "The specified file exits." & @CRLF & "Click OK to overwrite file or cancel to exit."))
		If $retval = 1 Then
			FileCopy($strPath, $strPath & ".old", 1)
			FileDelete($strPath)
			$fe = False
		Else
			_XMLError( "Error failed to create file: " & $strPath & @CRLF & "File exists.")
			SetError(1)
			Return -1
		EndIf
	Else
		FileCopy($strPath, $strPath & ".old", 1)
		FileDelete($strPath)
		$fe = False
	EndIf
	
	If $fe = False Then
		;==== pick your poison
		;	$objDoc = ObjCreate("Microsoft.XMLDOM")
		$objDoc = ObjCreate("Msxml2.DOMDocument.3.0")
		;	$objDoc = ObjCreate("Msxml2.DOMDocument.4.0")
		$objPI = $objDoc.createProcessingInstruction ("xml", "version=""1.0""")
		$objDoc.appendChild ($objPI)
		$rootElement = $objDoc.createElement ($strRoot)
		$objDoc.documentElement = $rootElement
		$objDoc.save ($strPath)
		If $objDoc.parseError.errorCode <> 0 Then
			;			_XMLError( "Error Creating specified file: " & $strPath & @CRLF & $oMyError.windescription)
			_XMLError( "Error Creating specified file: " & $strPath)
			SetError($objDoc.parseError.errorCode)
			Return -1
		EndIf
		Return
	Else
		_XMLError( "Error! Failed to create file: " & $strPath)
		SetError(1)
		Return -1
	EndIf
EndFunc   ;==>_XMLCreateFile


Func _ComErrorHandler($quiet = "")
	Local $COMErr_Silent, $HexNumber
	;===============================================================================
	;added silent switch to allow the func returned to the option to display custom
	;error messages

Select 
	case $quiet =True
		$COMErr_Silent = True
	Case $quiet =False
		$COMErr_Silent = False
EndSelect
	
		
;~ 	;===============================================================================
  If $COMErr_Silent = True Then Return @error
		
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
EndFunc

;===============================================================================
; Function Name:	_XMLError
; Description:		Sets error message generated by XML functs.
;					or Gets the message that was Set.
; Parameters:		$sError Node from Setting to delete
; Syntax:			_XMLError([$sError)
; Author(s):		Stephen Podhajecki <gehossafats@netmdc.com>
; Returns:			Nothing or Error message
;===============================================================================
Func _XMLError($sError = "")
	If $sError = "" Then
		$sError = $sXML_error
		$sXML_error = ""
		Return $sError
	Else
		$sXML_error = $sError
	EndIf
	_DebugWrite($sXML_error)
EndFunc   ;==>_XMLError

Func _AddFormat($objDoc,$objParent="")
	Local $objFORMAT
		if not IsObj($objDOC)  Then
			_Notifier("Error adding indent.")
			Return 0
		EndIf
		;ADD CARRIAGE RETURN <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        $objFORMAT = $objDOC.createTextNode(@CRLF)
		if IsObj($objParent) and $objParent <> "" then
			$objParent.appendChild($objFormat)
			$objDOC.documentElement.appendChild ($objParent)
		Else
			$objDOC.documentElement.appendChild ($objFORMAT)
		EndIf
		
EndFunc
;===============================================================================
; Function Name:	_Notifier($Notifier_msg)
; Description:		displays a simple "ok" messagebox
; Parameters:		$Notifier_Msg   The message to display
; Syntax:			_Notifier($Notifier_msg)
; Author(s):		-
; Returns:			-
;===============================================================================
Func _Notifier($Notifier_msg)
	Return	msgbox (266288, @ScriptName, $Notifier_msg)
EndFunc   ;==>_Notifier

; simple helper functions
;===============================================================================
; Function Name:	- 	_DebugWrite($message)
; Description:		-  Writes a message to console with a crlf on the end
; Parameters:		- $message   the message to display
; Syntax:			- _DebugWrite($message)
; Author(s):		-
; Returns:			-
;===============================================================================
Func _DebugWrite($message, $flag =@LF)
    If $debugging Then
        If $flag <> "" Then
            ConsoleWrite($message & $flag )
        Else
            ConsoleWrite($message)
        EndIf
    EndIf
EndFunc   ;==>_DebugWrite

;===============================================================================
; Function Name:	_XMLCreateRootChild
; Description:		Create node directly under root.
; Parameters:		$node	name of node to create
;					$value optional value to create
; Syntax:			_XMLCreateRootChild($node,[$value])
; Author(s):		Stephen Podhajecki <gehossafats@netmdc.com>
; Returns:			on error set error to 1 and returns -1
;===============================================================================
Func _XMLCreateRootChild($objDoc, $strNode, $strData = "", $strNameSpc = "")
	Local $objChild
	$objChild = $objDoc.createNode (1, $strNode, $strNameSpc)
	If $strData <> "" Then $objChild.text = $strData
	While @error = 0
		$objDoc.documentElement.appendChild ($objChild)
		_AddFormat($objDoc)
		$objDoc.Save ($strFile)
		$objChild = ""
		Return
	WEnd
	;	_XMLError( "Failed to root child: " & $strNode & @CRLF & $oMyError.windescription)
	_XMLError( "Failed to root child: " & $strNode & @CRLF)
	SetError(1)
	Return -1
EndFunc   ;==>_XMLCreateRootChild

;===============================================================================
; Function Name:    _XMLGetValue
; Description:        Get XML Fieldbased on XPath input from root node.
; Parameters:        $path    xml tree path from root node (root/child/child..)
; Syntax:            _XMLGetValue($path)
; Author(s):        Stephen Podhajecki <gehossafats@netmdc.com>
; Returns:            array of fields text values -1 on failure
;===============================================================================
Func _XMLGetValue($objDoc, $strXPath)
    Local $objNodeList, $arrResponse[1], $objNodeChild, $xmlerr
    While @error = 0
    $objNodeList = $objDoc.selectNodes($strXPath)
;    $objNodeList = $objDoc.selectNodes ($strXPath)
        If $objNodeList.length > 0 Then
            _DebugWrite("GetValue list length:" & $objNodeList.length)
            For $objNode In $objNodeList
            if $objNode.hasChildNodes() = False Then
                _ArrayAdd($arrResponse, $objNode.Text)
            Else
                $objNodeChild = $objNode.childNodes(0)
                if $objNodeChild.nodeType = $NODE_CDATA_SECTION Then
                    _ArrayAdd($arrResponse, $objNodeChild.data)
					   _DebugWrite("GetValue>CData:" & $objNodeChild.data)
                Else
                    _ArrayAdd($arrResponse, $objNode.Text)
					 _DebugWrite("GetValue>Text:" & $objNode.Text)
                EndIf
            EndIf
            
;            _DebugWrite("GetValue:" & $objNode.nodeValue)
        Next
		$arrResponse[0] = UBound($arrResponse)-1
			        Return $arrResponse
;            Return $objNode.nodeValue
           ;            Return $arrResponse
        Else
            $xmlerr = @CRLF & "No matching node(s)found!"
            Return -1
            ExitLoop
        EndIf
        
    WEnd
   ;    _XMLError( "Error Retrieving: " & $strXPath & @CRLF & $oMyError.windescription)
    _XMLError( "Error Retrieving: " & $strXPath & $xmlerr)
   ;            _XMLError( "No matching node(s)found for: " & $strXPath & @CRLF & $oMyError.windescription)
    SetError(1)
    Return -1
    
 EndFunc  ;==>_XMLGetValue

