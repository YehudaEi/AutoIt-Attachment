; *******************************************************
; Imperfect and stripped down version of what I use
; by Jim Rumbaugh 4-3-2011
; to see tables and forms on a webpage
; *******************************************************
;
#include-once
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <guilistview.au3>
#include <StaticConstants.au3>
#include <IE.au3>
;;#include <SendtoNotepad.AU3>
Local $filemenu, $fileitem, $recentfilesmenu, $separator1
Local $exititem, $helpmenu, $aboutitem, $okbutton, $cancelbutton
Local $msg, $file , $cFile
Local $TrasnferExam , $TrasnferSpecs
Local $nButtontop, $nButtonWidth, $nButtonSpace, $GoButton, $TableInfo, $LinksInfo
Local $WebAddress = "google.com"
Local $cWindowTitle = "IE Automation Explorer by Jim Rumbaugh 3-2010"
#forceref $separator1
;Opt('MustDeclareVars', 1)

_IEErrorHandlerRegister ()


$oIE = _IECreateEmbedded ()
GUICreate( $cWindowTitle ,@DesktopWidth-40 ,@DesktopHeight -80, _
		-1, -1, _
		$WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS + $WS_CLIPCHILDREN)
$GUIActiveX   = GUICtrlCreateObj($oIE, 10, 40, @DesktopWidth-60, @DesktopHeight -130)
$nButtontop   = 5
$nButtonWidth = 70
$nButtonSpace = 10

$GUI_Button_Back =    GUICtrlCreateButton("Back"   ,                           $nButtonSpace , $nButtontop, $nButtonWidth, 30)
$GUI_Button_Forward = GUICtrlCreateButton("Forward",         $nButtonWidth*1 + $nButtonSpace , $nButtontop, $nButtonWidth, 30)
$GUI_Button_Home  =   GUICtrlCreateButton("Home"   ,         $nButtonWidth*2 + $nButtonSpace , $nButtontop, $nButtonWidth, 30)
$GUI_Button_Stop  =   GUICtrlCreateButton("Stop"   ,         $nButtonWidth*3 + $nButtonSpace , $nButtontop, $nButtonWidth, 30)
$Escapebutton     =   GUICtrlCreateButton("Escape" ,         $nButtonWidth*4 + $nButtonSpace , $nButtontop, $nButtonWidth, 30)
$TableInfo        =   GUICtrlCreateButton("Tables" , $nButtonWidth*5 + $nButtonSpace , $nButtontop, $nButtonWidth, 30)
$LinksInfo        =   GUICtrlCreateButton("Links " , $nButtonWidth*6 + $nButtonSpace , $nButtontop, $nButtonWidth, 30)
$PageInfo         =   GUICtrlCreateButton("Forms    " ,      $nButtonWidth*7 + $nButtonSpace , $nButtontop, $nButtonWidth, 30)
$WebPage          =   GuiCtrlCreateInput($WebAddress, ($nButtonWidth + $nButtonSpace)*7 + 10, $nButtontop ,  150 , 30)
$GoButton         =   GUICtrlCreateButton("GO" ,      ($nButtonWidth + $nButtonSpace)*7 + 160, $nButtontop,  30 , 30 )

GUISetState()       ;Show GUI

;=========================== browse to home page
;=========================== next line is for generic logon
_IENavigate( $oIE , $WebAddress )
;=========================== next line is for making automated logon
;_LogOnWebPages($oIE, ,$WebAddress ,"username" , "password" )



While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Escapebutton
			ExitLoop
		Case $msg = $GUI_Button_Back
			_IEAction ($oIE, "back")
		Case $msg = $GUI_Button_Forward
			_IEAction ($oIE, "forward")
		Case $msg = $GUI_Button_Stop
			_IEAction ($oIE, "stop")
		Case $msg = $TableInfo
			_IETableReport( $oIE)
		Case $msg = $LinksInfo
			_IELinksReport($oIE)
		Case $msg = $GoButton
			GUICtrlRead($WebPage)
			_IENavigate( $oIE , GUICtrlRead($WebPage) )
		Case $msg = $PageInfo
			_IEFrameFormReport($oIE)
			_IEFormReport( $oIE , "FORMS on this PAGE"  )

			;======================================== report on tables on page
;~ 			$colTables = _IETableGetCollection($oIE)
;~ 			;If @error Then Exit

;~ 			$iIndex = 0
;~ 			for $oTable In $colTables
;~ 				$aTableData = _IETableWriteToArray($oTable)
;~ 				_ArrayDisplay($aTableData, "Table #" & $iIndex)
;~ 				$iIndex += 1
;~ 			next
	EndSelect
WEnd

GUIDelete()

Exit


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; User Functions by Jim Rumbaugh 12-2009
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Func _AddPatient( $oIE , $patInfo	)
	Local $cPhone , $cFirst , $cMiddle, $cLast , $cBirth , $cSSN , $cGender , $cPatId , $cAddress1 , $cCity, $cState , $cZip , $aPatInfo

	$aPatInfo   = StringSplit( $PatInfo , '~',2 )

	$cPhone 	= StringStripWS( $aPatInfo[0] , 3 )
	$cFirst 	= StringStripWS( $aPatInfo[1] , 3 )
	$cMiddle	= StringStripWS( $aPatInfo[2] , 3 )
	$cLast 		= StringStripWS( $aPatInfo[3] , 3 )
	$cBirth 	= StringLeft(    $aPatInfo[4] , 10 )
	$cSSN 		= _SsnFormat(StringStripWS( $aPatInfo[5] , 3 ))
	$cGender 	= StringStripWS( $aPatInfo[6] , 3 )
	$cPatId 	= StringStripWS( $aPatInfo[7] , 3 )
	$cAddress1 	= StringStripWS( $aPatInfo[8] , 3 )
	$cCity		= StringStripWS( $aPatInfo[9] , 3 )
	$cState 	= StringStripWS( $aPatInfo[10] , 3 )
	$cZip		= StringStripWS( $aPatInfo[11] , 3 )



	; click on add patient
	Local $oInputs , $oText , $oform
	$oform = _IEFormGetObjByName ($oIE, "aspnetForm")
	$oText = _IEFormElementGetObjByName ($oForm , "ctl00$ContentPlaceHolder1$PatientSearch$btnAddPatient")
	_IEAction ($oText, "click")
	_IELoadWait( $oIE )
	$oform = _IEFormGetObjByName ($oIE, "aspnetForm")
	; add data

	$oText = _IEFormElementGetObjByName ($oForm, "ctl00$ContentPlaceHolder1$txtPhone")
	_IEFormElementSetValue ($oText, $cPhone )
	$oText = _IEFormElementGetObjByName ($oForm, "ctl00$ContentPlaceHolder1$txtFName")
	_IEFormElementSetValue ($oText, $cFirst)
		$oText = _IEFormElementGetObjByName ($oForm, "ctl00$ContentPlaceHolder1$txtMName")
	_IEFormElementSetValue ($oText, StringLeft($cMiddle, 1 ))
	$oText = _IEFormElementGetObjByName ($oForm, "ctl00$ContentPlaceHolder1$txtLName")
	_IEFormElementSetValue ($oText, $cLast)
	$oText = _IEFormElementGetObjByName ($oForm, "ctl00$ContentPlaceHolder1$txtDOB")
	_IEFormElementSetValue ($oText, $cBirth)
	$oText = _IEFormElementGetObjByName ($oForm, "ctl00$ContentPlaceHolder1$txtSSN")
	_IEFormElementSetValue ($oText, $cSSN)
	$oText = _IEFormElementGetObjByName ($oForm, "ctl00$ContentPlaceHolder1$DDLGender")
	_IEFormElementSetValue ($oText,$cGender )
	$oText = _IEFormElementGetObjByName ($oForm, "ctl00$ContentPlaceHolder1$txtMRN")
	_IEFormElementSetValue ($oText, $cPatId)
	$oText = _IEFormElementGetObjByName ($oForm, "ctl00$ContentPlaceHolder1$txtAddress1")
	_IEFormElementSetValue ($oText, $cAddress1 )
	$oText = _IEFormElementGetObjByName ($oForm, "ctl00$ContentPlaceHolder1$txtCity")
	_IEFormElementSetValue ($oText, $cCity )
	$oText = _IEFormElementGetObjByName ($oForm, "ctl00$ContentPlaceHolder1$txtState")
	_IEFormElementSetValue ($oText, $cState )
	$oText = _IEFormElementGetObjByName ($oForm, "ctl00$ContentPlaceHolder1$txtZip")
	_IEFormElementSetValue ($oText, $cZip )



	IF 2 = MsgBox(1, "ready to return" , "aray0 " & $aPatInfo[0] & Chr(13) & Chr(10) &  " aray1 " & $aPatInfo[1] & Chr(13) & Chr(10) &  " aray2 " & $aPatInfo[2] & Chr(13) & Chr(10) &  " aray3 " & $aPatInfo[3] & Chr(13) & Chr(10) &  " aray4 " & $aPatInfo[4] & Chr(13) & Chr(10) &  " aray5 " & $aPatInfo[5] &  " aray6 " & $aPatInfo[6] & Chr(13) & Chr(10) &  " aray7 " & $aPatInfo[7] &  Chr(13) & Chr(10) &  " aray8 " & $aPatInfo[8] & Chr(13) & Chr(10) &  " aray9 " & $aPatInfo[9]  ) Then
			Exit
	EndIf

	$oText = _IEFormElementGetObjByName ($oForm , "ctl00$ContentPlaceHolder1$btnChangePatient")
	_IEAction ($oText, "click")
	_IELoadWait( $oIE )

EndFunc

Func _SsnFormat( $cNumber )
	Local $cTemp
	$cTemp = ""
	If StringIsAlNum( $cNumber ) Then
		$cTemp = StringLeft( $cNumber , 3 ) & "-" & StringMid( $cNumber , 4,2 ) & "-" & StringMid( $cNumber , 6,4 )
	Else
		$cTemp = $cNumber
	ENDIF
	RETURN $cTemp
EndFunc


Func _StringExtract( $cString , $cDelimiter , $cCount )
	Local $nStart , $nEnd
	$nStart  = StringInStr( $cString, $cDelimiter, 0 , $cCount     )
	$nEnd    = StringInStr( $cString, $cDelimiter, 0 , $cCount + 1 )
	return    StringInStr( $cString , $nStart, $nEnd )
EndFunc

Func _LogOnWebPages($oIE, $WebAddress , $cUserid , $cPassWord )
	;; for AllScripts.com
	Local $o_form, $oInputs
	;;;;;; login page
	_IENavigate( $oIE , $WebAddress  )
	; get pointers to the login form and username, password and signin fields
	_IELoadWait( $oIE )
	$o_form = _IEFormGetObjByName ($oIE, "form1")

	$o_Userid   = _IEFormElementGetObjByName ($o_form, "txtUserName"    )
	$o_PassWord = _IEFormElementGetObjByName ($o_form, "txtPassword")
	; Set field values and submit the form
	_IEFormElementSetValue ($o_Userid  , $cUserid  )
	_IEFormElementSetValue ($o_PassWord, $cPassword)

	$oInputs = _IETagNameGetCollection ($oIE, "input")
	_IEFormElementClickValue( $oInputs , "Log In")
	_IELoadWait( $oIE )
	;_IELoadWait( $oIE )
EndFunc


FUNC _IEFrameReport( $oSource )
		;;;;;;;;;;;;;; FRAME report
	$oFrames = _IEFrameGetCollection ($oSource)
	$iNumFrames = @extended
	If $iNumFrames > 0 Then
		If _IEIsFrameSet ($oSource) Then
			$cReport =  "There are " & $iNumFrames & " frames in a FrameSet"& @CRLF
		Else
			$cReport =  "There are " & $iNumFrames & " iFrames"& @CRLF
		EndIf
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; loop through and collect info
		For $i = 0 to ($iNumFrames - 1)
			$oFrame = _IEFrameGetCollection ($oSource, $i)
			$cReport = $cReport &  _IEPropertyGet ($oFrame, "locationurl")     & @CRLF
		Next

	Else
			$cReport =  "There are NO FRAMES on this page" & @CRLF
	EndIf
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; display report
	MsgBox(0, "FRAME REPORT Info", $cReport )
	Return
EndFunc

FUNC _IEFormReport( $oSource , $cInfo )
	;;;;; .......... FORM report
	$oForms  = _IEFormGetCollection ($oSource)
	$cReport = $cInfo   & @CRLF
	$cReport = $cReport & "There are " & @extended & " FORMS on this page" & @CRLF
	$nCount  = 0
	For $oForm In $oForms
		$cReport = $cReport & "........Form Name:" & $oForm.name &"  Form Number:"& $nCount & " Form Length:" & $oForm.length & "..................." & @CRLF
		$oElements = _IEFormElementGetCollection ($oForm)
		For $oElement IN $oElements
			$cReport = $cReport & "element name: " & $oElement.name & "       value:" & $oElement.value & @CRLF
		Next
		$nCount += 1

	Next
	MyEditBox( "Form Report Info ", $cReport  )
	Return
EndFunc


FUNC _IEFrameFormReport( $oSource )
		;;;;;;;;;;;;;; FRAME report
	$oFrames = _IEFrameGetCollection ($oSource)
	$iNumFrames = @extended
	If $iNumFrames > 0 Then
		If _IEIsFrameSet ($oSource) Then
			$cReport =  "There are " & $iNumFrames & " frames in a FrameSet"& @CRLF
			MsgBox(0,"FRAME and Form report Info", $cReport )
		Else
			$cReport =  "There are NO iFrames"& @CRLF
			MsgBox(0, "FRAME and Form report Info", $cReport )
		EndIf
		;;;;;;; forms on page not in frame
		_IEFormReport( $oSource , "FORMS on page but not in a FRAME")
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; loop through and collect info
		For $i = 0 to ($iNumFrames - 1)
			$oFrame = _IEFrameGetCollection ($oSource, $i)
			_IEFormReport( $oFrame , "FRAME:"& $i & "  "& _IEPropertyGet ($oFrame, "locationurl") )
		Next
	Else
			$cReport =  "There are NO FRAMES on this page" & @CRLF
			MyEditBox( "FRAME and Form report Info", $cReport )
	EndIf
	Return
EndFunc


Func _IETableReport( $oIE)
	Local $iIndex = 0
	$colTables = _IETableGetCollection($oIE)
	MsgBox(0, "Table Info", "There are " & @extended & " tables on the page")

	for $oTable In $colTables
		;===== stolen from IE include _IETableWriteToArray, to find errors
		Local $i_cols = 0, $tds, $i_col
		Local $trs = $oTable.rows
		For $tr In $trs
			$tds = $tr.cells
			$i_col = 0
			For $td In $tds
				$i_col = $i_col + $td.colSpan
			Next
			If $i_col > $i_cols Then $i_cols = $i_col
		Next
		Local $i_rows = $trs.length
		If $i_cols = 0 Or $i_cols = 0 Then
			MsgBox(1, "Failure to make good array from table", "Column count=" & $i_cols & "  Row count =" & $i_cols )
				;======== end of , find array problems
		Else
			$aTableData = _IETableWriteToArray($oTable)
			_ArrayDisplay($aTableData, "Table #" & $iIndex)
			$iIndex += 1
		EndIf
	next
EndFunc

Func _IELinksReport( $oIE )
	Local $nCount = 0
	LOCAL $cReport = ""
	$oLinks = _IELinkGetCollection ($oIE)
	$iNumLinks = @extended
	For $oLink In $oLinks
		$nCount  = $nCount + 1
		$cReport = $cReport & $NCount & ": " & $oLink.href & @CRLF
	Next
	MyEditBox( "There are " & $nCount & " links on this page " , $cReport )
EndFunc

Func _IEFormElementClickName( $oElements , $cName )
	For $oElement IN $oElements
		IF $oElement.Name = $cName Then
			_IEAction($oElement,  "CLICK")
		EndIf
	Next
	Return
EndFunc

Func _IEFormElementClickValue( $oElements , $cName )
	For $oElement IN $oElements
		IF $oElement.value = $cName Then
			_IEAction($oElement,  "CLICK")
		EndIf
	Next
	Return
EndFunc


Func MyEditBox( $cTitle , $cText )
	Local $myedit, $msg

    GUICreate($cTitle , @DesktopWidth-60, @DesktopHeight -130)  ; will create a dialog box that when displayed is centered
	$GUI_Button_Print =    GUICtrlCreateButton("Send to NOTEPAD"   ,       10 , 5, 100, 20)

    $myedit = GUICtrlCreateEdit($cText & @CRLF, 10, 30, @DesktopWidth-100, @DesktopHeight -180, $ES_AUTOVSCROLL + $WS_VSCROLL)

    GUISetState()

    Send("{END}")

    ; will be append dont' forget 3rd parameter
    ;GUICtrlSetData($myedit, "Second line", 1)

    ; Run the GUI until the dialog is closed
    While 1
        $msg = GUIGetMsg()

        If $msg = $GUI_EVENT_CLOSE  Then ExitLoop
		;;If $msg = $GUI_Button_Print Then SendToNotepad( $cText )
    WEnd
    GUIDelete()
EndFunc   ;==>Example
