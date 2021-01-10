#include <GUIConstants.au3>
#include<constants.au3>
#include <Misc.au3>

Global $usernamesearch, $lastnamesearch, $search, $list, $edit, $close, $firstname, $lastname, $displayname, $description, $office
Global $strDomain, $oMyError, $strUserDN, $UserObj, $objRootDSE, $oMyError, $HexNumber, $objTrans

Global $oMyError

;Creation of GUI
GUICreate("Employee Contact Information App", 700,550)

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
$close=guictrlcreatebutton(" Close ",510,60)

;General Information
guictrlcreatetab(15,100,570,400)
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
guictrlcreatelabel("Telephone :",25,330)
$telephone=GUICtrlCreateinput("",25,345,200,20,-1)
guictrlcreatelabel("Email :",25,370)
$email=GUICtrlCreateinput("",25,385,200,20,-1)
guictrlcreatelabel("Webpage :",25,410)
$webpage=GUICtrlCreateinput("",25,425,200,20,-1)

GUICtrlCreateLabel("Logon Script :", 240, 130)
$loginscript=GUICtrlCreateinput("",240,145,200,20,-1)
GUICtrlCreateLabel("# of bad logon attempts since last reset :", 240, 170)
;$badlogin=GUICtrlCreateinput("",240,185,200,20,-1)
GUICtrlCreateLabel("Password Last Changed: ", 240, 210)

;$lastchange=GUICtrlCreateinput($Date & " " & $Time,240,225,200,20,-1)
GUICtrlCreateLabel("90 Day Password Expiration: ", 240, 250)
;$pwdexpires=GUICtrlCreateinput("",240,265,200,20,-1)
GUICtrlCreateLabel("Last Logon: ", 240, 290)
;$lastlogin=GUICtrlCreateinput("",240,305,200,20,-1)
GUICtrlCreateLabel("User Account Status: ", 240, 330)
$userlocked = GUICtrlCreateLabel("", 240, 345, 80, 15) ; information label to show if account is locked

$loginworkstations = GUICtrlCreateLabel("test", 240, 445, 80, 15) ; 

$unlock = GUICtrlCreateButton("UNLOCK User's Account", 240, 385, 200, 20)
GUICtrlSetState($unlock, $Gui_Disable)
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
    ;$objTrans.Set ($ADS_NAME_TYPE_NT4, @LogonDomain & "\" & $usernamesearch)
	$objTrans.Set ($ADS_NAME_TYPE_NT4, @LogonDomain & "\" & GUICtrlRead($usernamesearch))
    $strUserDN = $objTrans.Get ($ADS_NAME_TYPE_1779)
    $UserObj = ObjGet("LDAP://" & $strUserDN)
    If @error Then
        MsgBox(0, 'username', 'Username does not exist or not able to communicate with ' & @LogonDomain)
    Else
        ;$firstname=GUICtrlSetData($UserObj.FirstName,25,145,200,20,-1)
		GUICtrlSetData($firstname, $UserObj.FirstName) 
		GUICtrlSetData($lastname, $UserObj.LastName)
		GUICtrlSetData($displayname, $UserObj.FullName)
		GUICtrlSetData($description, $UserObj.Description)
		GUICtrlSetData($office, $UserObj.physicalDeliveryOfficeName)
		GUICtrlSetData($telephone, $UserObj.TelephoneNumber)
		GUICtrlSetData($email, $UserObj.EmailAddress)
		GUICtrlSetData($webpage, $UserObj.homepage)
		GUICtrlSetData($loginscript, $UserObj.LoginScript)
		;
		GUICtrlSetData($loginworkstations,GUICtrlRead($UserObj.LoginWorkstations))
		;
		$lastchange = $UserObj.PasswordLastChanged
		$Date = StringMid($lastchange, 5, 2) & "/" & StringMid($lastchange, 7, 2) & "/" & StringMid($lastchange, 1, 4)
		$Time = StringMid($lastchange, 9, 2) & ":" & StringMid($lastchange, 11, 2) & ":" & StringMid($lastchange, 13, 2)
		GUICtrlCreateLabel($Date & " " & $Time, 240,225,200,20,-1)
		$pwdexpires = StringMid($lastchange, 5, 2) + 3 & "/" & StringMid($lastchange, 7, 2) & "/" & StringMid($lastchange, 1, 4)
		GUICtrlCreateLabel($pwdexpires & ' ' & $Time, 240,265,200,20,-1)

		$lastlogin = $UserObj.LastLogin
    
		$Date = StringMid($lastlogin, 5, 2) & "/" & StringMid($lastlogin, 7, 2) & "/" & StringMid($lastlogin, 1, 4)
		$Time = StringMid($lastlogin, 9, 2) & ":" & StringMid($lastlogin, 11, 2) & ":" & StringMid($lastlogin, 13, 2)
		GUICtrlCreateLabel($Date & " " & $Time, 240,305,200,20,-1)
		$badlogin = GUICtrlCreateLabel("" & $UserObj.BadLoginCount, 240,185,200,20,-1)
		If GUICtrlRead($badlogin) = 0 Then
        GUICtrlSetBkColor(-1, 0x00ff00);Green
		Else
        GUICtrlSetBkColor(-1, 0xff0000) ; Red
		EndIf
		
		if $UserObj.lockoutTime<>0 then
            if $UserObj.lockoutTime.HighPart<>0 then
				GUICtrlSetData($userlocked, "Locked") 
				GUICtrlSetBkColor($userlocked, 0xff0000) ;Red
				GUICtrlSetState($unlock, $Gui_Enable)
            Else
				GUICtrlSetData($userlocked, "NOT Locked")
				GUICtrlSetBkColor($userlocked, 0x00ff00) ;Green
				GUICtrlSetState($unlock, $Gui_Disable)
            EndIf
		EndIf

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