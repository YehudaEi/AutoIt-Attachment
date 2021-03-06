#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=filetype-blank.ico
#AutoIt3Wrapper_Outfile=AC Show IE objects.exe
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Comment=Has run on 22 nov 2011 with AutoIT3 version 3.3.6.1 and AutoIT3 version 3.3.7.21, both under Windows 7 and IE8.
#AutoIt3Wrapper_Res_Fileversion=3.0.8
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;	Give the .exe an OTHER NAME than that of the .au3 (that runs from SCITE).


; #INDEX# =======================================================================================================================
; Title .........: AC Show IE objects v3.0.au3
; Version 		 : 3.0.8
; Date			 : 22 november 2011
; Language ......: English en Nederlands
; Description ...: 	Executable to spy on the Internet Explorer Webpage-Controls.
; Author(s) .....: Martin van Leeuwen
; ===============================================================================================================================

#include-once

Opt("MustDeclareVars", 1); 0=no, 1=variables must be declared on forehand.
Opt("WinTitleMatchMode", 1) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase


; DECLARATION of variables
Global $IE_oBrowser
Global $x_oFrames, $x_oFrame
Global $x_oForms, $x_oForm, $x_oFormObjects, $x_oFormObject
Global $x_oButtons, $x_oButton
Global $x_oDIVs, $x_oDIV, $x_oDIVitems, $x_oDIVitem
Global $x_oTables, $x_oTable, $x_oLinks, $x_oLink, $x_oImgs, $x_oImg

Global $x_iNumFrames
Global $x_iNumForms
Global $x_iNumFormObjects
Global $x_iNumButtons, $x_Button_Arr
Global $x_iNumDIVs, $x_iNumDIVitems
Global $x_iNumTables, $x_Table_Arr
Global $x_iNumLinks
Global $x_iNumImgs
Global $x_oMyError

Global $C_WaitForAUTsec = 4;	Number of seconds to wait, before the next window of the AUT is there.
;								Can be dependent on the speed of the network at any moment.

#include <IE.au3> ;
#include <File.au3>
#include <Date.au3>
#include <Array.au3>
#include <Excel.au3>


Global $SchermNaam = "????"
Global $Transparancy = 220
Global $Array[1000][2]
Global $Arri
Global $Test1
Global $oExcel, $a, $b, $c, $d
Global $IE_Show_IE_objects_out = @MyDocumentsDir & "\AC_IE_Objects_Map_View.txt"
Global $IE_Title, $MarkerPos, $IE_Show_IEobjects_fileID, $NowCalcDate, $HulpString
_main_viewer()
Exit


Func MyErrFuncViewer() ; This is my custom defined COM error handler, that is referred to in the first line of the _main_viewer() function.
	; No error handling wanted
EndFunc   ;==>MyErrFuncViewer

Func _main_viewer()
	$x_oMyError = ObjEvent("AutoIt.Error", "MyErrFuncViewer") ; Initialize my COM error handler
	_IEErrorNotify(False) ; No _IEErrorNotifications wanted (IE.au3 writes diagnostic information, warnings and errors to the console by default).

	; With <Alt>l (lower case L) you get a listbox with the functions in this .au3
	; With <Control>j , while the cursor is on the functioncall, you jump to the function code.
	IE_Start()
	IE_and_Frames_Show_a_Forms()
	IE_and_Frames_Show_b_Buttons()
	IE_and_Frames_Show_c_DIVs()
	IE_and_Frames_Show_d_Links()
	IE_Stop()
EndFunc   ;==>_main_viewer


;  +++++++++++++++++++++++++++++++++++++++++++++  a_Forms  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Func IE_and_Frames_Show_a_Forms()
	$x_oForms = _IEFormGetCollection($IE_oBrowser)
	$x_iNumForms = @extended
	IE_and_Frames_Show_a_Forms_Report($IE_oBrowser, -1)
	$x_oFrames = _IEFrameGetCollection($IE_oBrowser, -1)
	$x_iNumFrames = @extended
	For $iFrame = 0 To $x_iNumFrames - 1
		GetFrame($iFrame)
		$x_oForms = _IEFormGetCollection($x_oFrame)
		$x_iNumForms = @extended
		If $x_iNumForms > 0 Then
			IE_and_Frames_Show_a_Forms_Report($x_oFrame, $iFrame)
		EndIf
	Next
EndFunc   ;==>IE_and_Frames_Show_a_Forms


;  +++++++++++++++++++++++++++++++++++++++++++++  b_Buttons   +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; http://www.w3schools.com/tags/tag_button.asp
; The <button> tag defines a push button.
; Inside a button element you can put content, like text or images. This is the difference between this element and buttons created with the input element.
Func IE_and_Frames_Show_b_Buttons()
	IE_and_Frames_Show_b_Buttons_Report($IE_oBrowser, -1)
	$x_oFrames = _IEFrameGetCollection($IE_oBrowser, -1)
	$x_iNumFrames = @extended
	For $iFrame = 0 To $x_iNumFrames - 1
		GetFrame($iFrame)
		IE_and_Frames_Show_b_Buttons_Report($x_oFrame, $iFrame)
	Next
EndFunc   ;==>IE_and_Frames_Show_b_Buttons

; cheks if there is an outertext
Func IE_and_Frames_Show_b_Buttons_Report(ByRef $o_object, $iFrame)
	$x_oButtons = ya9_IEbuttonGetCollection($o_object, -1)
	$x_iNumButtons = @extended
	If $x_iNumButtons > 0 Then
		For $iButton = 0 To $x_iNumButtons - 1
			$x_oButton = ya9_IEbuttonGetCollection($o_object, $iButton)
			$Test1 = _IEPropertyGet($x_oButton, "outertext")
			If $Test1 <> "" Then
				; ; The 'button' tag does not have an action function yet, instead _IEGetObjByName() is used.
				IE_xy($x_oButton, @TAB & "Frame, Form is: " & $iFrame & ", -1     Button Index (not on a form) with ID, Name, Outertext: " _
						 & $iButton & ' , "' & $x_oButton.Id & '" , "' & $x_oButton.Name & '" , "' & $Test1 & '"' & @CRLF)
				; The  'button' tag might have a .name attribute, but the value will probably be ""
				; The only place you can use a name attribute (that hasn't been deprecated) is on form controls,
				; see:  http://stackoverflow.com/questions/4962070/attribute-name-not-allowed-on-element-div-at-this-point
			EndIf
		Next
	EndIf
EndFunc   ;==>IE_and_Frames_Show_b_Buttons_Report


;  +++++++++++++++++++++++++++++++++++++++++++++  c_DIVs   +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Explanation of DIV
; http://msdn.microsoft.com/en-us/library/ms536439(VS.85).aspx

; http://www.w3schools.com/tags/tag_DIV.asp
; Tip: The div element is very often used with CSS to layout a web page.

Func IE_and_Frames_Show_c_DIVs()
	IE_and_Frames_Show_c_DIVs_Report($IE_oBrowser, -1)
	$x_oFrames = _IEFrameGetCollection($IE_oBrowser, -1)
	$x_iNumFrames = @extended
	For $iFrame = 0 To $x_iNumFrames - 1
		GetFrame($iFrame)
		IE_and_Frames_Show_c_DIVs_Report($x_oFrame, $iFrame)
	Next
EndFunc   ;==>IE_and_Frames_Show_c_DIVs

Func IE_and_Frames_Show_c_DIVs_Report(ByRef $o_object, $iFrame)
	$x_oDIVs = ya9_IEDIVGetCollection($o_object, -1)
	$x_iNumDIVs = @extended
	If $x_iNumDIVs > 0 Then
		; FileWriteLine($IE_Show_IEobjects_fileID, @TAB & @TAB & "DIVs with '<INPUT id=': " & @CRLF)
		For $iDIV = 0 To $x_iNumDIVs - 1
			$x_oDIV = ya9_IEDIVGetCollection($o_object, $iDIV)
			$Test1 = _IEPropertyGet($x_oDIV, "innerhtml")
			If StringInStr($Test1, "<INPUT id=") > 0 Then
				$Test1 = StringLeft($Test1, 400)
				$Test1 = StringReplace($Test1, Chr(10), "") ; linefeed character
				$Test1 = StringReplace($Test1, Chr(11), "") ; vertical tab
				$Test1 = StringReplace($Test1, Chr(12), "") ; page break
				$Test1 = StringReplace($Test1, Chr(13), "") ; carrage return
				; http://stackoverflow.com/questions/4962070/attribute-name-not-allowed-on-element-div-at-this-point
				; You cannot have a name attribute on a div tag. The only place you can use a name attribute (that hasn't been deprecated) is on form controls
				IE_xy($x_oDIV, "   Frame, Form is: " & $iFrame & ", -1  DIV Index, ID, InnerHTML:  " & $iDIV & ' , "' & $x_oDIV.id & '"  ,  "' & $Test1 & '"' & @CRLF)
			EndIf
		Next
	EndIf
EndFunc   ;==>IE_and_Frames_Show_c_DIVs_Report


;  +++++++++++++++++++++++++++++++++++++++++++++  e_Links   +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Func IE_and_Frames_Show_d_Links()
	IE_and_Frames_Show_d_Links_Report($IE_oBrowser, -1)
	For $iFrame = 0 To $x_iNumFrames - 1
		GetFrame($iFrame)
		IE_and_Frames_Show_d_Links_Report($x_oFrame, $iFrame)
	Next
EndFunc   ;==>IE_and_Frames_Show_d_Links

Func IE_and_Frames_Show_d_Links_Report(ByRef $o_object, $iFrame)
	$x_oLinks = _IELinkGetCollection($o_object, -1)
	$x_iNumLinks = @extended
	For $iLink = 0 To $x_iNumLinks - 1
		$x_oLink = _IELinkGetCollection($o_object, $iLink)
		IE_xy($x_oLink, @TAB & "Frame, Form is: " & $iFrame & ", -1           Link index:  " & $iLink & '  , Link: "' & $x_oLink.href & '"' & @CRLF & @CRLF)
		; 0-values for: _IEPropertyGet($IE_oBrowser, "screenx") and _IEPropertyGet($IE_oBrowser, "screeny")
	Next
EndFunc   ;==>IE_and_Frames_Show_d_Links_Report


;  ++++++++++++++++++++++++++++++++++++++++++++++  IE_and_Frames_Show - Functions    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Func IE_and_Frames_Show_a_Forms_Report(ByRef $o_object, $iFrameLocal)
	; $o_object is an object variable of an InternetExplorer.Application, Window, Frame or iFrame object
	Local $ArrayForm[1000][6], $iForm, $i, $NameIndexnr, $TussenArr
	For $iForm = 0 To $x_iNumForms - 1
		$x_oForm = _IEFormGetCollection($o_object, $iForm)
		$x_oFormObjects = _IEFormElementGetCollection($x_oForm, -1)
		$x_iNumFormObjects = @extended
		For $iFormObject = 0 To $x_iNumFormObjects - 1
			$x_oFormObject = _IEFormElementGetCollection($x_oForm, $iFormObject)
			$ArrayForm[$iFormObject][0] = $iFormObject
			$ArrayForm[$iFormObject][1] = $x_oFormObject.Name & ", " & StringRight("0000" & $iFormObject, 4) ; for sorting
			$ArrayForm[$iFormObject][2] = $x_oFormObject.Id
			$ArrayForm[$iFormObject][3] = $x_oFormObject.Name
			$ArrayForm[$iFormObject][4] = $iFrameLocal & ", " & $iForm & "   FormElement Index, ID, Name:  " & $iFormObject
			$ArrayForm[$iFormObject][5] = $x_oFormObject
		Next ; Object

		; For multiple occurences of form element 'Name': add the indexnr of the name after the string 'Name#'
		_ArraySort($ArrayForm, 0, 0, $x_iNumFormObjects - 1, 1) ; Sort on 'Name', '$iFormObject'
		$NameIndexnr = 0
		$i = 0
		While $i < $x_iNumFormObjects - 1
			$i = $i + 1
			If $ArrayForm[$i][3] And $ArrayForm[$i - 1][3] Then ; No empty string
				$TussenArr = StringSplit($ArrayForm[$i - 1][3], "#") ;  $ArrayForm[$i - 1][3] contains the #
				If $ArrayForm[$i][3] = $TussenArr[1] Then ; $x_oFormObject.Name
					; MsgBox(4096, $ArrayForm[$i - 1][3], $ArrayForm[$i][3])
					If $NameIndexnr = 0 Then
						$ArrayForm[$i - 1][3] = $ArrayForm[$i - 1][3] & "#0"
					EndIf
					$NameIndexnr = $NameIndexnr + 1
					$ArrayForm[$i][3] = $ArrayForm[$i][3] & "#" & $NameIndexnr
				Else
					$NameIndexnr = 0
				EndIf
			EndIf ; No empty string
		WEnd
		_ArraySort($ArrayForm, 0, 0, $x_iNumFormObjects - 1, 0) ; sort back on '$iFormObject', that is, in the order they were found in the Formelement collection.

		For $iFormObject = 0 To $x_iNumFormObjects - 1
			IE_xy($ArrayForm[$iFormObject][5], "Frame, Form is: " & $ArrayForm[$iFormObject][4] & @TAB & IE_and_Frames_Show_a_Forms_Report_Obj($ArrayForm[$iFormObject][2], $ArrayForm[$iFormObject][3]) & @CRLF)
		Next
	Next ; form
EndFunc   ;==>IE_and_Frames_Show_a_Forms_Report


Func IE_and_Frames_Show_a_Forms_Report_Obj($id, $name)
	; 	DOM elements can have Name or ID attributes or both.
	; 	A specific Name can be assigned to multiple elements. For example:
	; 		_IEGetObjByName ( ByRef $o_object, $s_Id [, $i_index = 0] )
	;	is making call to:
	;		$o_object.document.GetElementsByName($s_Id).item($i_index)
	;	and thos allows the selection of the element by the value of it's Name attribute,
	;	�nd by it's index (starting from 0)

	;	A specific ID can be assigned to only a single element. For example:
	; 		_IEGetObjById ( ByRef $o_object, $s_Id)
	;	is making call to:
	;		$o_object.document.getElementById($s_Id)
	;	You can also pass the value of the element's Name attribute, instead of the element's ID attribute,
	;	but only when that name occurs only once in a Frame or Form.

	;	Look out: 	In AutoIT, when $Object.Name is not defined, then it's nummeric value is 0, and the following rules apply
	;     			(0			= "any text" ) is True , because a numeric comparison takes a string for 0
	;				(0 			= ""    	 ) is also True !
	;				("any text" = 0          ) is also True !
	;   Therefor, test $id or $name with IsString() first, before using string-comparisons.
	If IsString($id) And IsString($name) Then
		If $id = $name Then
			Return ', "' & $id & '"' & @TAB & ' = "' & $name & '"'; Name and Id have the same string-value
		Else
			Return ', "' & $id & '"' & @TAB & ' , "' & $name & '"';   Id and Name have a different string-value
		EndIf
	Else ;  ; Name has no string-value and/or Id has no string-value
		If IsString($name) Then ; $Id has no string value, value is 0
			Return ', No Id ,  "' & $name & '"'
		ElseIf IsString($id) Then ; $Name has no string value, value is 0
			Return ', "' & $id & '"' & @TAB & '  , No name, use the Id'
		Else ; $Id has no string-value �nd $Name has no string-value, both value's are 0
			Return ', No Id and no Name, use the Object index nr.' & @TAB & @TAB
		EndIf
	EndIf
EndFunc   ;==>IE_and_Frames_Show_a_Forms_Report_Obj


;  ++++++++++++++++++++++++++++++++++++++++++++++  GetFrame en IE_xy   - Functies    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Func GetFrame($iFrameLocal)
	;Local $Locationurl_Arr, $DerdeSlash
	$x_oFrame = _IEFrameGetCollection($IE_oBrowser, $iFrameLocal)
	; Frames are recognized in Internet Explorer by their name.
	;     FileWriteLine($IE_Show_IEobjects_fileID, "Frame Index: " & $iFrameLocal & @TAB & "Frame Naam: " & $x_oFrame.name & @CRLF & @CRLF)
	; Frames are recognized in the IE Developer Toolbar by their action:
	;       $Locationurl_Arr = StringSplit(_IEPropertyGet($x_oFrame, "locationurl"), "?")
	;       $ThirdSlash = StringInStr($Locationurl_Arr[1], "/", 0, 3)
	;        FileWriteLine($IE_Show_IEobjects_fileID, @TAB & "Frame Action: " & StringTrimLeft($Locationurl_Arr[1], $ThirdSlash - 1) & @CRLF & @CRLF)
EndFunc   ;==>GetFrame


Func IE_xy(ByRef $o_object, $Text)
	Local $ExcelX, $ExcelY, $paddingArri

	$ExcelX = StringRight("0000" & fX(_IEPropertyGet($o_object, "screenx")), 4)
	$ExcelY = StringRight("0000" & gZ(_IEPropertyGet($o_object, "screeny")), 4)
	If Not $Text Then
		Return "  " & $ExcelY & ", " & $ExcelX & @TAB & @CRLF & @CRLF
	Else
		$paddingArri = StringRight("0000" & $Arri, 4) ; $Arri is sequence nr.

		; 	MsgBox(4096, "error $Arri: ", $Arri)
		$Array[$Arri][0] = $ExcelY & ", " & $ExcelX & ", " & $paddingArri
		$Array[$Arri][1] = $ExcelY & ", " & $ExcelX & " " & @TAB & $Text & @CRLF & @CRLF
		$Arri = $Arri + 1
		Return $Array[$Arri][1]
	EndIf
EndFunc   ;==>IE_xy

;  ++++++++++++++++++++++++++++++++++++++++++++++  IE_Start en IE_Stop - Functies    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Func IE_Start()
	Local $ExeDir, $Whnd
	Local $handle, $StartX, $StartY, $EndX, $EndY

	If $CmdLine[0] >= 1 Then
		If $CmdLine[1] = "" Then
			Exit ; nothing to do.
		Else
			$SchermNaam = $CmdLine[1]
		EndIf
	Else
		$IE_Title = IE_Start_Find()
		If $IE_Title <> "" Then $SchermNaam = $IE_Title
	EndIf
	If $CmdLine[0] >= 2 Then
		If $CmdLine[2] = "" Then
			Exit ; nothing to do.
		Else
			$IE_Show_IE_objects_out = $CmdLine[2]
		EndIf
	EndIf
	$MarkerPos = StringInStr($SchermNaam, " ")
	If $MarkerPos > 0 Then $SchermNaam = StringMid($SchermNaam, 1, $MarkerPos - 1)
	$MarkerPos = StringInStr($SchermNaam, ",")
	If $MarkerPos > 0 Then $SchermNaam = StringMid($SchermNaam, 1, $MarkerPos - 1)
	If $CmdLine[0] = 0 Then
		$SchermNaam = InputBox("Internet Explorer Object-Viewer", "(First part of the) Title of the IE window: ", $SchermNaam) ;    "Terneuzen"
		If @error = 1 Then ; The Cancel button was pushed.
			Exit
		EndIf
		$IE_Show_IE_objects_out = InputBox("Internet Explorer Object-Viewer", "Output file: ", $IE_Show_IE_objects_out)
		If @error = 1 Then ; The Cancel button was pushed.
			Exit
		EndIf
		$Transparancy = InputBox("Transparancy", "Transparancy (255 = Solid, 0 = Invisible): ", $Transparancy)
	EndIf
	$IE_oBrowser = _IEAttach($SchermNaam)
	If @error <> 0 Then
		; MsgBox(4096, "AC_IE_ObjectViewer", "Error in finding screen name: " & $SchermNaam & @CRLF & "Error is: " & @error)
		Exit
	EndIf

	; Set IE browser zoom to 100%, the text size is not relevant for this script.
	$Whnd = _IEPropertyGet($IE_oBrowser, "hwnd")
	WinActivate($Whnd, "")
	WinWaitActive($Whnd, "")
	Send("^0") ;  < Ctrl > 0


	; Open the .txt file for reporting
	If Not _FileCreate($IE_Show_IE_objects_out) Then
		;  MsgBox(0, "Error", " Error Creating/Resetting " & $IE_Show_IE_objects_out & "   error:" & @error)
		Exit
	EndIf
	$IE_Show_IEobjects_fileID = FileOpen($IE_Show_IE_objects_out, 2) ; 2 = Write mode (erase previous contents)
	If $IE_Show_IEobjects_fileID = -1 Then
		;  MsgBox(0, "Error", "Unable to open file: " & $IE_Show_IE_objects_out)
		Exit
	EndIf
	$NowCalcDate = _NowCalcDate() & " " & _NowTime(5)
	$HulpString = "Field list, " & $NowCalcDate & " of screen: " & $SchermNaam
	FileWriteLine($IE_Show_IEobjects_fileID, $HulpString & @CRLF & @CRLF)
	FileWriteLine($IE_Show_IEobjects_fileID, "The row and column numbers of the fields are listed below, for Zoom 100% ." & @CRLF & @CRLF)
	FileWriteLine($IE_Show_IEobjects_fileID, "When all the row or column nummers have the vale 1: Change the Text size of the IE Browser to NORMAL with menu-option View or Page." & @CRLF & @CRLF)

	;  ### Open Excel Mapping file ###

	$oExcel = _ExcelBookNew(1) ; $oExcel = _ExcelBookNew(0)
	$handle = WinWait("[CLASS:XLMAIN]", "")
	If $handle = 1 Then $handle = WinGetHandle("[CLASS:XLMAIN]", "") ; For Winwait(), 'handle = 1  when successful', is old functionality for AutIT3 v3.3.12.1,
	;												change #764 is implemented: Return Pid on ProcessWait() and handle on WinWait(), WinWaitActive, WinActivate(), WinActive(), WinMove() when successful.


	$oExcel.Cells.Select
	$oExcel.Selection.Comment.Visible = False ; Comment must pop-up when you set the mouse pointer on the comment.
	$oExcel.Selection.ColumnWidth = 0.67 ; 8 pixels
	$oExcel.Selection.RowHeight = 3.75 ; 5 pixels
	WinSetTrans($handle, "", 205)
	$oExcel.Cells(1, 1).Select
	WinSetState($handle, "", @SW_MAXIMIZE)
	WinSetState($handle, "", @SW_SHOW)
	WinActivate($handle, "")
	WinWaitActive($handle, "")
	; WinMove($handle, "", 0, 20)


	MouseMove(200, 200, 0)
	MouseClick("left")
	Sleep(100)
	$StartX = $oExcel.Selection.Column
	$StartY = $oExcel.Selection.Row

	MouseMove(600, 600, 0)
	MouseClick("left")
	Sleep(100)
	$EndX = $oExcel.Selection.Column
	$EndY = $oExcel.Selection.Row
	$oExcel.Cells(1, 1).Select

	; Calibration:
	; f(x) = ax + b
	$a = ($EndX - $StartX) / 400
	$b = $StartX - ($a * 200)

	; g(z) = cz + d
	$c = ($EndY - $StartY) / 400
	$d = $StartY - ($c * 200)
EndFunc   ;==>IE_Start

Func IE_Start_Find()
	Local $var, $IEframe_Occurences, $i, $hWnd, $aClass
	$var = WinList()
	$IEframe_Occurences = 0
	For $i = 1 To $var[0][0]
		; Only display visible windows that have a title
		$hWnd = $var[$i][1]
		If $var[$i][0] <> "" And BitAND(WinGetState($hWnd), 2) Then ; Is visible is governed by: BitAND(WinGetState($hWnd), 2)
			; ;  MsgBox(0, "Details", "Title=" & $var[$i][0] & @LF & "Handle=" & $var[$i][1])
			$aClass = DllCall("User32.dll", "int", "GetClassName", "hwnd", $hWnd, "str", "", "int", 4096)
			If $aClass[2] = "IEframe" Then
				Return $var[$i][0]
			EndIf
			; ;  MsgBox(4096, "$IEframe_Occurences: ", $IEframe_Occurences & @CR & $aClass[2] & @CR & "Title=" & $var[$i][0])
			If $IEframe_Occurences > 1 Then ExitLoop 1
		EndIf
	Next
	Return ""
EndFunc   ;==>IE_Start_Find


Func IE_Stop()
	Local $handle, $PID, $ExeDir, $arrxy, $i, $j, $str, $Row, $Column

	FileWriteLine($IE_Show_IEobjects_fileID, "Use  ..\bin\AC Show IE objects.exe  or the  Internet Explorer Developer Toolbar (key F12 in IE8, or download for IE7) ")
	FileWriteLine($IE_Show_IEobjects_fileID, "to Find and id-entify the objects on a Web page.")
	FileWriteLine($IE_Show_IEobjects_fileID, @CRLF & @CRLF)

	;  In y, x order: Rows, Columns in Excel, then sequence nr.
	_ArraySort($Array, 0, 0, $Arri - 1, 0)
	For $i = 0 To $Arri - 1
		FileWriteLine($IE_Show_IEobjects_fileID, $Array[$i][1])
	Next
	FileWriteLine($IE_Show_IEobjects_fileID, @CRLF & @CRLF)
	$NowCalcDate = _NowCalcDate() & " " & _NowTime(5)
	FileWriteLine($IE_Show_IEobjects_fileID, @CRLF & @CRLF & "++ Ended on " & $NowCalcDate & " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
	FileClose($IE_Show_IEobjects_fileID)


	$i = -1
	While $i < $Arri - 1
		$i = $i + 1

		$arrxy = StringSplit($Array[$i][1], ",")
		$Row = Int($arrxy[1])
		$Column = Int($arrxy[2])

		$oExcel.Cells($Row, $Column).AddComment
		$oExcel.Cells($Row, $Column).Comment.Shape.Width = 250
		$oExcel.Cells($Row, $Column).Comment.Shape.Height = 100
		$str = $Array[$i][1]

		; Look for other objects in the same Excel-cell.
		$j = $i + 1
		While $j <= $Arri - 1
			$arrxy = StringSplit($Array[$j][1], ",")
			If($Row = Int($arrxy[1])) and($Column = Int($arrxy[2])) Then
				$str = $str & @CRLF & $Array[$j][1]
				$i = $j
				$j = $j + 1
			Else
				$j = $Arri ; > max
			EndIf
		WEnd
		$oExcel.Cells($Row, $Column).Comment.Text($str) ; Limited to ... length string ??
	WEnd

	; MsgBox(4096, "", "Ready.")

	Sleep(80)
	$PID = Run("notepad " & $IE_Show_IE_objects_out, "", @SW_HIDE)
	Sleep(80)
	$handle = WinWait("[CLASS:Notepad]", "")
	If $handle = 1 Then $handle = WinGetHandle("[CLASS:Notepad]", "") ; For Winwait(), 'handle = 1  when successful', is old functionality for AutIT3 v3.3.12.1,
	;												change #764 is implemented: Return Pid on ProcessWait() and handle on WinWait(), WinWaitActive, WinActivate(), WinActive(), WinMove() when successful.


	WinSetTrans($handle, "", $Transparancy) ;
	WinSetState($handle, "", @SW_RESTORE)
	WinSetState($handle, "", @SW_SHOW)


EndFunc   ;==>IE_Stop

Func fX($x)
	Local $y
	$y = Ceiling(($a * $x) + $b)
	If $y < 1 Then $y = 1
	Return $y
EndFunc   ;==>fX

Func gZ($z)
	Local $y
	$y = Ceiling(($c * $z) + $d)
	If $y < 1 Then $y = 1
	Return $y
EndFunc   ;==>gZ

; #FUNCTION# ====================================================================================================================
; Name...........: ya9_IEbuttonGetCollection
; Return values .: On Success 	- Returns 1 :  Radio element has been clicked on
;                  On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 7 ($_IEStatus_NoMatch) = No Match
;								  or: The @error code from ya9_IEDIVetCollection(),  _IETagNameGetCollection()  or _IEAction()
;					@Extended	- 0 when No Match
;								  or: The @extended code from ya9_IEDIVetCollection(),  _IETagNameGetCollection() or  _IEAction()
; Author ........: Maetin van Leeuen, kopied and adjusted _IEtableGetCollection() from Dale Hohm
; ===============================================================================================================================
Func ya9_IEbuttonGetCollection(ByRef $o_object, $i_index = -1)
	If Not IsObj($o_object) Then
		__IEErrorNotify("Error", "v_IEbuttonGetCollection", "$_IEStatus_InvalidDataType")

	EndIf
	;
	$i_index = Number($i_index)
	Select
		Case $i_index = -1
			Return SetError($_IEStatus_Success, $o_object.document.GetElementsByTagName("button").length, _
					$o_object.document.GetElementsByTagName("button"))
		Case $i_index > -1 And $i_index < $o_object.document.GetElementsByTagName("button").length
			Return SetError($_IEStatus_Success, $o_object.document.GetElementsByTagName("button").length, _
					$o_object.document.GetElementsByTagName("button").item($i_index))
		Case $i_index < -1
			__IEErrorNotify("Error", "v_IEbuttonGetCollection", "$_IEStatus_InvalidValue", "$i_index < -1")
			Return SetError($_IEStatus_InvalidValue, 2, 0)
		Case Else
			__IEErrorNotify("Warning", "v_IEbuttonGetCollection", "$_IEStatus_NoMatch")
			Return SetError($_IEStatus_NoMatch, 1, 0)
	EndSelect
EndFunc   ;==>ya9_IEbuttonGetCollection

; #FUNCTION# ====================================================================================================================
; Name...........: ya9_IEDIVGetCollection
; Description ...: Returns a collection object variable representing all the DIV's in a document
; Parameters ....: $o_object	- Object variable of an InternetExplorer.Application, Window or Frame object
;				   $i_index	- Optional: specifies whether to return a collection or indexed instance
;								- 0 or positive integer returns an indexed instance
;								- -1 = (Default) returns a collection
; Return values .: On Success 	- Returns an object collection of all DIV's in the document, @EXTENDED = DIV count
;                  On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 ($_IEStatus_Success) = No Error
;								- 3 ($_IEStatus_InvalidDataType) = Invalid Data Type
;								- 5 ($_IEStatus_InvalidValue) = Invalid Value
;								- 7 ($_IEStatus_NoMatch) = No Match
;					@Extended	- Contains invalid parameter number
; Author ........: Dale Hohm
; ===============================================================================================================================
Func ya9_IEDIVGetCollection(ByRef $o_object, $i_index = -1)
	If Not IsObj($o_object) Then
		__IEErrorNotify("Error", "v_IEDIVGetCollection", "$_IEStatus_InvalidDataType")
		Return SetError($_IEStatus_InvalidDataType, 1, 0)
	EndIf
	;
	$i_index = Number($i_index)
	Select
		Case $i_index = -1
			Return SetError($_IEStatus_Success, $o_object.document.GetElementsByTagName("DIV").length, _
					$o_object.document.GetElementsByTagName("DIV"))
		Case $i_index > -1 And $i_index < $o_object.document.GetElementsByTagName("DIV").length
			Return SetError($_IEStatus_Success, $o_object.document.GetElementsByTagName("DIV").length, _
					$o_object.document.GetElementsByTagName("DIV").item($i_index))
		Case $i_index < -1
			__IEErrorNotify("Error", "v_IEDIVGetCollection", "$_IEStatus_InvalidValue", "$i_index < -1")
			Return SetError($_IEStatus_InvalidValue, 2, 0)
		Case Else
			__IEErrorNotify("Warning", "v_IEDIVGetCollection", "$_IEStatus_NoMatch")
			Return SetError($_IEStatus_NoMatch, 1, 0)
	EndSelect
EndFunc   ;==>ya9_IEDIVGetCollection
