#include <GUIConstants.au3>
#include<constants.au3>
#include <Misc.au3>

Global $usernamesearch, $lastnamesearch, $search, $list, $edit, $close, $firstname, $lastname, $displayname, $description, $office
Global $strDomain, $oMyError, $strUserDN, $UserObj, $objRootDSE, $oMyError, $HexNumber, $objTrans

Global $oMyError

;Creation of GUI
GUICreate("Employee Contact Information App", 600,400)

;Search, list and TAB
GUICtrlCreateLabel("Employee Username:",20,16)
$usernamesearch=GUICtrlCreateInput("",20,30,100,"")
GUICtrlCreateLabel("Employee last name:",140,16)
$lastnamesearch=GUICtrlCreateInput("",140,30,100,"")
$search=GUICtrlCreateButton("Search",260,30,50,"",$BS_DEFPUSHBUTTON)
GUICtrlCreateLabel("Results:",330,16)
$list=GUICtrlCreateList("",330,30,160,75,-1)
$edit=GUICtrlCreateButton(" Edit Info ",510,30,70,22) 

;Close button
$close=guictrlcreatebutton(" Close ",321,360)

;General Information
guictrlcreatetab(15,100,370,250)
GUICtrlCreatetabitem(" General Info ")
guictrlcreatelabel("First Name :",25,130) 
$firstname=GUICtrlCreateinput("",25,145,200,20,-1)
guictrlcreatelabel("Last Name :",25,170)
$lastname=GUICtrlCreateinput("",25,185,200,20,-1)
guictrlcreatelabel("Display Name :",25,210) 
$displayname=GUICtrlCreateinput("",25,225,200,20,-1)
guictrlcreatelabel("Description :",25,250) 
$description=GUICtrlCreateinput("",25,265,200,20,-1)
guictrlcreatelabel("Office :",25,290)
$office=GUICtrlCreateinput("",25,305,200,20,-1)


GUISetState(@SW_SHOW)

while 1
	$msg=GUIGetMsg()
		Select
			Case $msg=$search 
				Call("SearchUsername")
			Case $msg=$GUI_EVENT_CLOSE
				ExitLoop
			Case $msg=$close
				ExitLoop
		EndSelect
wend

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Func SearchUsername()

Const $ADS_NAME_INITTYPE_GC = 3
Const $ADS_NAME_TYPE_NT4 = 3
Const $ADS_NAME_TYPE_1779 = 1

If @error Then Exit
$oMyError = ObjEvent("AutoIt.Error", "ComError")
$objRootDSE = ObjGet("LDAP://RootDSE")
If @error Then
    MsgBox(0, 'username', 'Username does not exist or not able to communicate with ' & @LogonDomain)
Else
    ; DNS domain name.
    $objTrans = ObjCreate("NameTranslate")
    $objTrans.Init ($ADS_NAME_INITTYPE_GC, "")
    $objTrans.Set ($ADS_NAME_TYPE_1779, @LogonDomain)
    $objTrans.Set ($ADS_NAME_TYPE_NT4, @LogonDomain & "\" & $usernamesearch)
    $strUserDN = $objTrans.Get ($ADS_NAME_TYPE_1779)
    $UserObj = ObjGet("LDAP://" & $strUserDN)
    If @error Then
        MsgBox(0, 'username', 'Username does not exist or not able to communicate with ' & @LogonDomain)
    Else
        ;$firstname=GUICtrlSetData($UserObj.FirstName,25,145,200,20,-1)
		GUICtrlSetData($firstname, $UserObj.FirstName) 

    EndIf
EndIf
$UserObj = ""
$oMyError = ObjEvent("AutoIt.Error", "")
EndFunc ;==>Search Username

;COM Error function
Func ComError()
    If IsObj($oMyError) Then
        $HexNumber = Hex($oMyError.number, 8)
        SetError($HexNumber)
    Else
        SetError(1)
    EndIf
    Return 0
EndFunc   ;==>ComError