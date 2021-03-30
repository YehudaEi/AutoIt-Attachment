#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_Outfile_x64=One4AllAddUser.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

; Multiple filter group
#include <IE.au3>
#include <Excel.au3>
#include <Array.au3>

$sFormName = "modalCreateForm"
$sTableId = "modalCreateForm:UniqueId_j_id987"
$sDiv1Id = "modalCreateForm:externalRolePicker-outer"
$sDiv2Id = "duallist-container"
$sTableCellId = "duallist-available"
$sListItemText = "User"


Local $Openmessage = "Please, open Excel template for One4Al."
Local $var = FileOpenDialog($Openmessage, @ScriptDir & "\", "Excel (*.xlsx;*.xls)", 1)
Global $oAppl = _Excel_Open()


If @error Then
	MsgBox(4096, "", "No File(s) chosen")
Else
	Global $oWorkbook = _Excel_BookOpen($oAppl, $var)
	If @error Then
		_Excel_Close($oAppl)
		Exit
	EndIf
	Local $aResult = _Excel_RangeRead($oWorkbook, 1, "F5:Y42")
	If @error Then Exit
	Local $username = InputBox("Username", "Enter your AD username.", "username", "")
	Local $passwd = InputBox("Security Check", "Enter your password for One4All.", "password", "*")
	Local $oIE = _IECreate("OurWeb")
	Local $oForm = _IEFormGetObjByName($oIE, "mainForm")
	Local $oText = _IEFormElementGetObjByName($oForm, "j_username")
	_IEFormElementSetValue($oText, $username)
	$oText = _IEFormElementGetObjByName($oForm, "j_password")
	_IEFormElementSetValue($oText, $passwd)
	Local $LoginButton = _IEGetObjById($oIE, 'loginLink')
	_IEAction($LoginButton, "click")
	$oObjId = _WaitFor_IEGetObjById($oIE, "footer")
	If IsObj($oObjId) Then
		Local $osv = _IEGetObjById($oIE, "headerForm:menuUsers")
		$osv.fireEvent("onclick")
	Else
		MsgBox(1,1,"unable to grab object within 10 seconds")
	EndIf
	_IELoadWait($oIE)
	For $i = 0 to UBound($aResult,2) - 1
		If $aResult[0][$i] <> "" Then
			Local $searchobj = $aResult[0][$i]
			$oForm = _IEFormGetObjByName($oIE, "coreForm")
			$oText = _IEFormElementGetObjByName($oForm, "coreForm:filter:login")
			_IEFormElementSetValue($oText, $searchobj)
			Local $SearchBtn = _IEGetObjById($oForm, "coreForm:filter:search")
			_IEAction($SearchBtn, "click")
			if _IELinkClickByText($oIE, $searchobj) <> -1 Then
				Local $NewUserButton = _IEGetObjById($oForm, 'coreForm:table1:createUserToolbar:createUserButton')
				_IEAction($NewUserButton, "click")
				Sleep(5000)
				$oNextUser = _WaitFor_IEGetObjById($oIE, "modalCreateForm:createUserWizard-toolbar:createUserWizard-next")
				If IsObj($oNextUser) Then		;	Type of the User
					Local $oFormNextUser = _IEFormGetObjByName($oIE, "modalCreateForm")
					_IEFormElementRadioSelect($oFormNextUser,"INTERNAL","modalCreateForm:selectType:option:INTERNAL", 1, "byValue")
					Local $NextUserButton = _IEGetObjById($oFormNextUser, "modalCreateForm:createUserWizard-toolbar:createUserWizard-next")
					_IEAction($NextUserButton, "click")
					Sleep(5000)
					$oNextInfo = _WaitFor_IEGetObjById($oIE, "modalCreateForm:createUserWizard-toolbar:createUserWizard-next")
					If IsObj($oNextInfo) Then	;	User Information
						Local $oFormNextInfo = _IEFormGetObjByName($oIE, "modalCreateForm")
						$oText = _IEFormElementGetObjByName($oFormNextInfo, "modalCreateForm:loginInput")
						_IEFormElementSetValue($oText, $aResult[0][$i])
						$oText = _IEFormElementGetObjByName($oFormNextInfo, "modalCreateForm:firstnameInput")
						_IEFormElementSetValue($oText, $aResult[4][$i])
						$oText = _IEFormElementGetObjByName($oFormNextInfo, "modalCreateForm:lastnameInput")
						_IEFormElementSetValue($oText, $aResult[5][$i])
						$oText = _IEFormElementGetObjByName($oFormNextInfo, "modalCreateForm:emailInput")
						_IEFormElementSetValue($oText, $aResult[6][$i])
						Local $CheckBoxResult = _IEFormElementCheckBoxSelect($oFormNextInfo,"on","modalCreateForm:activeCheckbox", -1)
						If $CheckBoxResult = False Then
							_IEFormElementCheckBoxSelect($oFormNextInfo,"on","modalCreateForm:activeCheckbox", 1)
						EndIf
						Local $NextButtonInfo = _IEGetObjById($oFormNextInfo, "modalCreateForm:createUserWizard-toolbar:createUserWizard-next")
						_IEAction($NextButtonInfo, "click")
						$oNextInterface = _WaitFor_IEGetObjById($oIE, "modalCreateForm:createUserWizard-toolbar:createUserWizard-next")
						If IsObj($oNextInterface) Then	;	User Interface
							Sleep(5000)
							Local $oInputs = _IETagNameGetCollection($oIE, "span")
							Local $sText = "Test"
							For $oInput In $oInputs
								ConsoleWrite($oInput.class & @LF)
								If $oInput.class = "value-showcase" Then
									$sText = $oInput.innerText    ;check the properties in the help files
								EndIf
							Next
							MsgBox(1,1,$sText)
							If $sText <> False Then
								ConsoleWrite("Text: " & $sText & @LF)
								;do some dirty things with that text!
							EndIf
							Local $NextButtonInterface = _IEGetObjById($oNextInterface, "modalCreateForm:createUserWizard-toolbar:createUserWizard-next")
							_IEAction($NextButtonInterface, "click")
						Else
							MsgBox(1,1,"unable to grab Next3 object within 10 seconds")
						EndIf
					Else
						MsgBox(1,1,"unable to grab Next2 object within 10 seconds")
					EndIf
				Else
					MsgBox(1,1,"unable to grab Next1 object within 10 seconds")
				EndIf
			Else
				MsgBox(1,1,"Yehaa!")
			EndIf
		EndIf
	Next
EndIf

Func _IEGetObjInfo(ByRef $o_object)
    Local $s_Info = ""
    $s_Info &= "Object Name: " & ObjName($o_object) & @CRLF
    $s_Info &= "Object Tag Name: " & $o_object.tagName & @CRLF
    $s_Info &= "Object Id: " & $o_object.Id & @CRLF
    $s_Info &= "Object Class Name: " & $o_object.className & @CRLF
    $s_Info &= "Object HTML Start: " & @CRLF & $o_object.innerHTML & @CRLF & "Object HTML End"

    Return $s_Info
EndFunc   ;==>_IEGetObjInfo


Func _WaitFor_IEGetObjById($oCallersIE, $iCallersID, $iCallersMaxWaitMilSec = 20000)
    ConsoleWrite("Func[_WaitFor_IEGetObjById]: Start with params=[IsObj(" & $oCallersIE & ")," & $iCallersID & "," & $iCallersMaxWaitMilSec & "]." & @CRLF)
    $iTimer = TimerInit()
    $oObj = _IEGetObjById($oCallersIE, $iCallersID)
    While Not IsObj($oObj) And TimerDiff($iTimer) < $iCallersMaxWaitMilSec
        Sleep(100)
        $oObj = _IEGetObjById($oCallersIE, $iCallersID)
    WEnd
    If IsObj($oObj) Then
        ConsoleWrite("Func[_WaitFor_IEGetObjById]: Found callers ID=[" & $iCallersID & "]." & @CRLF)
        Return $oObj
    Else
        ConsoleWrite("Func[_WaitFor_IEGetObjById]: UNable to find callers ID=[" & $iCallersID & "] within milliseconds=[" &  $iCallersMaxWaitMilSec & "]." & @CRLF)
        Return False
    EndIf
EndFunc   ;==>_WaitFor_IEGetObjById

Func _IEGetObjByClass(ByRef $o_object, $s_Class, $s_TagName = "*", $i_index = 0)
    ;
    Local $i_found = 0
    ;
    $o_tags = _IETagNameGetCollection($o_object, $s_TagName)
    For $o_tag In $o_tags
        If IsString($o_tag.className) And $o_tag.className = $s_Class Then
            If $i_found = $i_index Then Return $o_tag
            $i_found += 1
        EndIf
    Next
    ;
    Return SetError(1)
EndFunc   ;==>_IEGetObjByClass

Func _IEGetObjByText(ByRef $o_object, $s_Text, $s_TagName = "*", $i_index = 0)
    ;
    Local $i_found = 0
    ;
    $o_tags = _IETagNameGetCollection($o_object, $s_TagName)
    For $o_tag In $o_tags
        If IsString($o_tag.innerText) And $o_tag.innerText = $s_Text Then
            If $i_found = $i_index Then Return $o_tag
            $i_found += 1
        EndIf
    Next
    ;
    Return SetError(1)
EndFunc   ;==>_IEGetObjByText

Func _ExitError($msg)
    ConsoleWriteError($msg & @CRLF)
    Exit
EndFunc   ;==>_ExitError

