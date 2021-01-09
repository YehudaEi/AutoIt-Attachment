;===============================================================================
;
; Function Name:   File Property Management
; Description: 	   This utility is for reading/writing file properties
; Parameter(s):    _FileProperty( )  
;				   $fFile - File path of file to be adjusted
;                  $fProperty - Property to be adjusted (title, subject, category,
;				 			    keywords, comments, company, author)
;				   $fValue - Value to insert into field
;                  $fMode - 0 for read, 1 for write, 2 for remove
; Requirement(s):  DLL File in script directory - dsofile.dll
; Return Value(s): Property read if the read mode is specified.
; Author(s): 	   Andrew Goulart
;
;===============================================================================
;

Func _FileProperty($fFile, $fProperty = "Title", $fValue = "", $fMode = 0)	
	_DLLstartup()
	$return = ""

	Global $g_eventerror = 0  ; to be checked to know if com error occurs. Must be reset after handling.
	Global $oMyError = ObjEvent("AutoIt.Error", "ComErrorHandler"); Install a custom error handler
	$objFile = ObjCreate("DSOFile.OleDocumentProperties")
	If $g_eventerror Then Exit
	$g_eventerror = 0
	If Not IsObj($objFile) Then Exit
	
	$objFile.Open($fFile) ; bind to the summary information metadata attached to the file.
	If $g_eventerror Then Exit
	$g_eventerror = 0

	; Remove properties
	Switch $fProperty
		Case "Title"
			Switch $fMode
				Case 0
					$return = $objFile.SummaryProperties.Title
				Case 1
					$objFile.SummaryProperties.Title = $fValue
				Case 2
					$objFile.SummaryProperties.Title = ""
			EndSwitch
		Case "Subject"
			Switch $fMode
				Case 0
					$return = $objFile.SummaryProperties.Subject
				Case 1
					$objFile.SummaryProperties.Subject = $fValue
				Case 2
					$objFile.SummaryProperties.Subject = ""
			EndSwitch
		Case "Category"
			Switch $fMode
				Case 0
					$return = $objFile.SummaryProperties.Category
				Case 1
					$objFile.SummaryProperties.Category = $fValue
				Case 2
					$objFile.SummaryProperties.Category = ""
			EndSwitch
		Case "Keywords"
			Switch $fMode
				Case 0
					$return = $objFile.SummaryProperties.Keywords
				Case 1
					$objFile.SummaryProperties.Keywords = $fValue
				Case 2
					$objFile.SummaryProperties.Keywords = ""
			EndSwitch
		Case "Comments"
			Switch $fMode
				Case 0
					$return = $objFile.SummaryProperties.Comments
				Case 1
					$objFile.SummaryProperties.Comments = $fValue
				Case 2
					$objFile.SummaryProperties.Comments = ""
			EndSwitch
		Case "Company"
			Switch $fMode
				Case 0
					$return = $objFile.SummaryProperties.Company
				Case 1
					$objFile.SummaryProperties.Company = $fValue
				Case 2
					$objFile.SummaryProperties.Company = ""
			EndSwitch
		Case "Author"
			Switch $fMode
				Case 0
					$return = $objFile.SummaryProperties.Author
				Case 1
					$objFile.SummaryProperties.Author = $fValue
				Case 2
					$objFile.SummaryProperties.Author = ""
			EndSwitch
	EndSwitch

	$objFile.Save ; save changes to file properties
	If $g_eventerror Then Exit
	$g_eventerror = 0

	$objFile.Close ; unbind from the summary information metadata attached to the file.
	
	If $return <> "" Then Return $return
	_DLLshutdown()
EndFunc

Func ComErrorHandler() ; optionally bypass message box, or use ConsoleWrite, Debugview or log errors to file
    Local $sHexNumber = Hex($oMyError.number,8)
    Local $sDesc = StringStripWS($oMyError.windescription, 2)
    Msgbox(0,"AutoItCOM Test","We intercepted a COM Error !"        & @CRLF & @CRLF & _
             "err.description is: "    & @TAB & $oMyError.description       & @CRLF & _
             "err.windescription:"     & @TAB & $oMyError.windescription    & @CRLF & _
             "err.number is: "         & @TAB & $sHexNumber                & @CRLF & _
             "err.scriptline is: "     & @TAB & $oMyError.scriptline        & @CRLF)
    $g_eventerror = 1 ; something to check for when this function returns
    $oMyError.clear
Endfunc

Func _DLLstartup($DLLpath = '')
    If $DLLpath = Default Or $DLLpath = '' Then $DLLpath = @ScriptDir & '\dsofile.dll'
    ShellExecuteWait('regsvr32', '/s /i ' & $DLLpath, @WindowsDir, 'open', @SW_HIDE)
EndFunc   ;==>_DLLstartup

Func _DLLshutdown($DLLpath = '')
    If $DLLpath = Default Or $DLLpath = '' Then $DLLpath = @ScriptDir & '\dsofile.dll'
    ShellExecuteWait('regsvr32', ' /s /u ' & $DLLpath, @WindowsDir, 'open', @SW_HIDE)
EndFunc   ;==>_DLLshutdown