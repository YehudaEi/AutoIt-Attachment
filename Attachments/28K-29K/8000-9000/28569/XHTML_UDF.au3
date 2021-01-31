#include-once

; Functions
; _XHTML_Start($sTitle = "Index")
; _XHTML_End($sPath)
; _XHTML_StartForm($sName, $sMethod = "", $sAction = "")
; _XHTML_EndForm()
; _XHTML_StartTable($iBorder = 1, $iWidth = "")
; _XHTML_AddTrTd($iMode = 0)
; _XHTML_EndTable()
; _XHTML_AddHeader($sText, $sSize = 1)
; _XHTML_AddLabel($sText)
; _XHTML_AddInput($sName, $iSize, $iMaxlength, $iPass = 0)
; _XHTML_AddButton($sName $sValue, $sType = "button")
; _XHTML_AddBr($iNumber = 1)
; _XHTML_StartSelect($sName)
; _XHTML_AddOption($sText)
; _XHTML_EndSelect()
; _XHTML_Custom($sCode)
; _XHTML_Save($sPath)
; _LineFeed($iNumber = 1)

Global $sSource

; #FUNCTION # =======================================================
; Name............; _XHTML_Start()
; Description.....; Starts the XHTML code.
; Syntax..........; _XHTML_Start($sTitle = "Index")
; Parameters......; $sTitle		- The title of your HTML page.
; Return Values...; - 
; Author..........; Almar Mulder (AlmarM)
; Modified........; -
; Remarks.........; -
; Related.........; _XHTML_End()
; Link............; -
; Example.........; Yes
; ===================================================================
Func _XHTML_Start($sTitle = "Index")
	$sSource =	"<html>" & @CRLF & _
				"<head>" & @CRLF & _
				"<title>" & $sTitle & "</title>" & @CRLF & _
				"</head>" & @CRLF & _
				"<body>" & @CRLF
EndFunc

; #FUNCTION # =======================================================
; Name............; _XHTML_End()
; Description.....; Ends the current HTML code.
; Syntax..........; _XHTML_End($sPath)
; Parameters......;	$sPath		- The html file that should be created
; Return Values...; -
; Author..........; Almar Mulder (AlmarM)
; Modified........; -
; Remarks.........; -
; Related.........; _XHTML_Start()
; Link............; -
; Example.........; Yes
; ===================================================================
Func _XHTML_End($sPath)
	$sSource &=	"</body>" & @CRLF & _
				"</html>"
	
	FileWrite($sPath, "...")
	If Not FileExists($sPath) Then
		___ERROR("$sPath is not a correct path!")
	Else
		FileDelete($sPath)
		FileWrite($sPath, $sSource)
		$sSource = ""
	EndIf
EndFunc

; #FUNCTION # =======================================================
; Name............; _XHTML_StartForm()
; Description.....; Starts the form code.
; Syntax..........; _XHTML_StartForm($sName, $sMethod = "", $sAction = "")
; Parameters......;	$sName		- The name of the form
;					$sMethod 	- The form send method
;					$sAction	- The file used for the 'submit' button
; Return Values...; - 
; Author..........; Almar Mulder (AlmarM)
; Modified........; -
; Remarks.........; -
; Related.........; _XHTML_EndForm()
; Link............; -
; Example.........; Yes
; ===================================================================
Func _XHTML_StartForm($sName, $sMethod = "", $sAction = "")
	$sSource &=	'<form name="' & $sName & '" method="' & $sMethod & '" action="' & $sAction & '">'
EndFunc

; #FUNCTION # =======================================================
; Name............; _XHTML_EndForm()
; Description.....; Ends the previous started form.
; Syntax..........; _XHTML_EndForm()
; Parameters......; -
; Return Values...; -
; Author..........; Almar Mulder (AlmarM)
; Modified........; -
; Remarks.........; -
; Related.........; _XHTML_StartForm()
; Link............; -
; Example.........; Yes
; ===================================================================
Func _XHTML_EndForm()
	$sSource &= '</form>'
EndFunc

; #FUNCTION # =======================================================
; Name............; _XHTML_StartTable()
; Description.....; Starts a table code.
; Syntax..........; _XHTML_StartTable($iBorder = 1, $iWidth = "")
; Parameters......;	$iBorder	- Show border, 0 = no ~ 1 = yes
;					$iWidth		- The width the table should use.
; Return Values...; -
; Author..........; Almar Mulder (AlmarM)
; Modified........; -
; Remarks.........; -
; Related.........; _XHTML_AddTrTd(), _XHTML_EndTable()
; Link............; -
; Example.........; Yes
; ===================================================================
Func _XHTML_StartTable($iBorder = 1, $iWidth = "")
	$sSource &= '<table border="' & $iBorder & '" width="' & $iWidth & '">'
EndFunc

; #FUNCTION # =======================================================
; Name............; _XHTML_AddTrTd()
; Description.....; Adds a Table Row or Table Data to the code.
; Syntax..........; _XHTML_AddTrTd($iMode = 0)
; Parameters......;	$iMode		- | 0 ~ Open Table row
;								- | 1 ~ Open Table data
;								- | 2 ~ Open Table row, Open Table data
;								- | 3 ~ Close Table row
;								- | 4 ~ Close Table data
;								- | 5 ~ Close Table data, Close Table row
;								- | 6 ~ Close Table data, Open Table data
;								- | Use _XHTML_Custom() for custom open and close
; Return Values...; -
; Author..........; Almar Mulder (AlmarM)
; Modified........; -
; Remarks.........; -
; Related.........; _XHTML_StartTable(), _XHTML_EndTable()
; Link............; -
; Example.........; Yes
; ===================================================================
Func _XHTML_AddTrTd($iMode = 0)
	If $iMode = 0 Then
		$sSource &= "<tr>"
	ElseIf $iMode = 1 Then
		$sSource &= "<td>"
	ElseIf $iMode = 2 Then
		$sSource &= "<tr><td>"
	ElseIf $iMode = 3 Then
		$sSource &= "</td>"
	ElseIf $iMode = 4 Then
		$sSource &= "</tr>"
	ElseIf $iMode = 5 Then
		$sSource &= "</td></tr>"
	ElseIf $iMode = 6 Then
		$sSource &= "</td><td>"
	Else
		___ERROR("$iMode must equal to 0, 1, 2, 3, 4, 5 or 6!")
	EndIf
EndFunc

; #FUNCTION # =======================================================
; Name............; _XHTML_EndTable()
; Description.....; Ends the previous started table.
; Syntax..........; _XHTML_EndTable()
; Parameters......; -
; Return Values...; -
; Author..........; Almar Mulder (AlmarM)
; Modified........; -
; Remarks.........; -
; Related.........; _XHTML_StartTable(), _XHTML_AddTrTd()
; Link............; -
; Example.........; Yes
; ===================================================================
Func _XHTML_EndTable()
	$sSource &= '</table>'
EndFunc

; #FUNCTION # =======================================================
; Name............; _XHTML_AddHeader()
; Description.....; Adds a header to the code.
; Syntax..........; _XHTML_AddHeader($sText, $sSize = 1)
; Parameters......;	$sText		- The header text
;					$sSize		- The header size (Range: 1 ~ 7)
; Return Values...; -
; Author..........; Almar Mulder (AlmarM)
; Modified........; -
; Remarks.........; -
; Related.........; _XHTML_AddLabel()
; Link............; -
; Example.........; Yes
; ===================================================================	
Func _XHTML_AddHeader($sText, $sSize = 1)
	$sSource &= '<h' & $sSize & '>' & $sText & '</h' & $sSize & '>'
EndFunc

; #FUNCTION # =======================================================
; Name............; _XHTML_AddLabel()
; Description.....; Adds text to the code.
; Syntax..........; _XHTML_AddLabel($sText)
; Parameters......;	$sText		- The text that needs to be added
; Return Values...; -
; Author..........; Almar Mulder (AlmarM)
; Modified........; -
; Remarks.........; -
; Related.........; _XHTML_AddHeader()
; Link............; -
; Example.........; Yes
; ===================================================================
Func _XHTML_AddLabel($sText)
	$sSource &= $sText
EndFunc

; #FUNCTION # =======================================================
; Name............; _XHTML_AddInput()
; Description.....; Adds a input to the code.
; Syntax..........; _XHTML_AddInput($sName, $iSize, $iMaxlength, $iPass = 0)
; Parameters......;	$sName		- The input name
;					$iSize		- The input size
;					$iMexLength	- The input max string length
;					$iPass		- Make the input an password on, 0 = no ~ 1 = yes
; Return Values...; -
; Author..........; Almar Mulder (AlmarM)
; Modified........; -
; Remarks.........; -
; Related.........; _XHTML_AddButton(), _XHTML_AddBr()
; Link............; -
; Example.........; Yes
; ===================================================================
Func _XHTML_AddInput($sName, $iSize, $iMaxlength, $iPass = 0)
	If $iPass = 1 Then
		$sSource &= '<input type="password" name="' & $sName & '" size="' & $iSize & '" maxlength="' & $iMaxLength & '">'
	ElseIf $iPass = 0 Then
		$sSource &= '<input type="text" name="' & $sName & '" size="' & $iSize & '" maxlength="' & $iMaxLength & '">'
	Else
		___ERROR("$iPass must equal to 0 or 1!")
	EndIf
EndFunc

; #FUNCTION # =======================================================
; Name............; _XHTML_AddButton()
; Description.....; Adds a button to the code.
; Syntax..........; _XHTML_AddButton($sName $sValue, $sType = "button")
; Parameters......;	$sName		- The button name
;					$sValue		- Text displayed on the button
;					$sType		- The button type (Range: button, submit, reset)
; Return Values...; -
; Author..........; Almar Mulder (AlmarM)
; Modified........; -
; Remarks.........; -
; Related.........; _XHTML_AddInput(), _XHTML_AddBr()
; Link............; -
; Example.........; Yes
; ===================================================================
Func _XHTML_AddButton($sName, $sValue, $sType = "button")
		$sSource &= '<input type="' & $sType & '" name="' & $sName & '" value="' & $sValue & '">'
EndFunc

; #FUNCTION # =======================================================
; Name............; _XHTML_AddBr()
; Description.....; Adds a br tag to the code.
; Syntax..........; _XHTML_AddBr($iNumber = 1)
; Parameters......;	$iNumber		- How many br tags you need
; Return Values...; -
; Author..........; Almar Mulder (AlmarM)
; Modified........; -
; Remarks.........; -
; Related.........; _XHTML_AddInput(), _XHTML_AddButton()
; Link............; -
; Example.........; Yes
; ===================================================================
Func _XHTML_AddBr($iNumber = 1)
	If Not IsNumber($iNumber) Then
		___ERROR("$iNumber must be a valid integer!")
	Else
		For $i = 1 To $iNumber
			$sSource &= "<br/>"
		Next
		$sSource &= @CRLF
	EndIf
EndFunc

; #FUNCTION # =======================================================
; Name............; _XHTML_StartSelect()
; Description.....; Opens a Select tag.
; Syntax..........; _XHTML_StartSelect($sName)
; Parameters......;	$sName		- The name of this object
; Return Values...; -
; Author..........; Almar Mulder (AlmarM)
; Modified........; -
; Remarks.........; -
; Related.........; _XHTML_AddOption(), _XHTML_EndSelect()
; Link............; -
; Example.........; Yes
; ===================================================================
Func _XHTML_StartSelect($sName)
	$sSource &= '<select name="' & $sName & '">'
EndFunc

; #FUNCTION # =======================================================
; Name............; _XHTML_AddOption()
; Description.....; Adds an option tab for the previous openen select tag.
; Syntax..........; _XHTML_AddOption($sText)
; Parameters......;	$sText		- The text to be displayed
; Return Values...; -
; Author..........; Almar Mulder (AlmarM)
; Modified........; -
; Remarks.........; -
; Related.........; _XHTML_StartSelect(), _XHTML_EndSelect()
; Link............; -
; Example.........; Yes
; ===================================================================
Func _XHTML_AddOption($sText)
	$sSource &= '<option>' & $sText & '</option>'
EndFunc

; #FUNCTION # =======================================================
; Name............; _XHTML_EndSelect()
; Description.....; Closes the privious started select.
; Syntax..........; _XHTML_EndSelect()
; Parameters......;	-
; Return Values...; -
; Author..........; Almar Mulder (AlmarM)
; Modified........; -
; Remarks.........; -
; Related.........; _XHTML_StartSelect(), _XHTML_AddOption()
; Link............; -
; Example.........; Yes
; ===================================================================
Func _XHTML_EndSelect()
	$sSource &= '</select>'
EndFunc

; #FUNCTION # =======================================================
; Name............; _XHTML_Custom()
; Description.....; Enables the user to create his own code.
; Syntax..........; _XHTML_Custom($sCode)
; Parameters......;	$sCode		- Code
; Return Values...; -
; Author..........; Almar Mulder (AlmarM)
; Modified........; -
; Remarks.........; -
; Related.........; -
; Link............; -
; Example.........; Yes
; ===================================================================
Func _XHTML_Custom($sCode)
	$sSource &= $sCode
EndFunc

; #FUNCTION # =======================================================
; Name............; _XHTML_Save()
; Description.....; Good for saving other formats like PHP.
; Syntax..........; _XHTML_Save($sPath)
; Parameters......;	$sPath		- The file that should be created
; Return Values...; -
; Author..........; Almar Mulder (AlmarM)
; Modified........; -
; Remarks.........; -
; Related.........; -
; Link............; -
; Example.........; Yes
; ===================================================================
Func _XHTML_Save($sPath)	
	FileWrite($sPath, "...")
	If Not FileExists($sPath) Then
		___ERROR("$sPath is not a correct path!")
	Else
		FileDelete($sPath)
		FileWrite($sPath, $sSource)
		$sSource = ""
	EndIf
EndFunc

; Description....; Good for cleaning up the code a bit.
; Syntax.........; _LineFeed($iNumber = 1)
; Parameters.....;	$iNumber		- How many times you want a line feed between your code
Func _LineFeed($iNumber = 1)
	For $i = 1 To $iNumber
		$sSource &= @CRLF
	Next
EndFunc

Func ___ERROR($sERROR)
	ConsoleWrite("+---------------------------------------------------------------------+" & @CRLF)
	ConsoleWrite("+---	ERROR: " & $sERROR & @CRLF)
	ConsoleWrite("+---------------------------------------------------------------------+" & @CRLF)
EndFunc