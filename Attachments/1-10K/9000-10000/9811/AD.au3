; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <GUIConstants.au3>
#include <Misc.au3>

Const $ADS_NAME_INITTYPE_GC = 3
Const $ADS_NAME_TYPE_NT4 = 3
Const $ADS_NAME_TYPE_1779 = 1
DIM $unlock
DIM $mgrvalue
DIM $mgrsplit
DIM $manager
DIM $mgr
DIM $title
DIM $pwdexpires
$oMyError = ObjEvent("AutoIt.Error", "ComError")
$objRootDSE = ObjGet("LDAP://RootDSE")
$username = InputBox("Username","Please input a username:")  
If @error Then
    MsgBox(0, 'username', 'Username does not exist or not able to communicate with ' & @LogonDomain)
Else
; DNS domain name.
    $objTrans = ObjCreate("NameTranslate")
    $objTrans.Init ($ADS_NAME_INITTYPE_GC, "")
    $objTrans.Set ($ADS_NAME_TYPE_1779, @LogonDomain)
    $objTrans.Set ($ADS_NAME_TYPE_NT4, @LogonDomain & "\" & $username)
    $strUserDN = $objTrans.Get ($ADS_NAME_TYPE_1779)
    $UserObj = ObjGet("LDAP://" & $strUserDN)
    If @error Then
        MsgBox(0, 'username', 'Username does not exist or not able to communicate with ' & @LogonDomain)
    Else
        Call ("Displayinfo")
        
    
    EndIf
EndIf
$UserObj = ""
$oMyError = ObjEvent("AutoIt.Error", "")
;COM Error function
Func ComError()
    If IsObj($oMyError) Then
        $HexNumber = Hex($oMyError.number, 8)
        SetError($HexNumber)
    Else
        SetError(1)
    EndIf
    Return 0
EndFunc ;==>ComError


Func Displayinfo()
    GUICreate ( "Active Directory Information", 500, 600, 300, 300)
    
    GUICtrlCreateLabel ("Username: ", 10, 10, 60, 20)   
    GUICtrlCreateLabel ("First Name: ", 10, 30, 60, 20) 
    GUICtrlCreateLabel ("Last Name: ", 200, 30, 60, 20) 
    GUICtrlCreateLabel ("Display Name: ", 10, 50, 100, 20)  
    GUICtrlCreateLabel ("Title: ", 10, 70, 100, 20) 
    GUICtrlCreateLabel ("Manager: ", 10, 90, 100, 20)   
    GUICtrlCreateLabel ("Description: ", 10, 150, 100, 20)  
    GUICtrlCreateLabel ("Office: ", 10, 190, 60, 20)    
    GUICtrlCreateLabel ("Department: ", 10, 250, 100, 20)   
    GUICtrlCreateLabel ("Telephone Number: ", 10, 290, 90, 40)  
    GUICtrlCreateLabel ("Mobile Number: ", 10, 320, 100, 20)    
    GUICtrlCreateLabel ("Home Number: ", 10, 350, 100, 20)  
    GUICtrlCreateLabel ("Email Address: ", 10, 370, 100, 20)    
    GUICtrlCreateLabel ("Logon Script: ", 10, 410, 100, 20)
    GUICtrlCreateLabel ("Account:", 10, 430, 100, 20)
    GUICtrlCreateLabel ("Number of bad logon attempts since last reset: ", 310, 420, 120, 40)
    GUICtrlCreateLabel ("Password Last Changed: ", 10, 460, 100, 40)
    GUICtrlCreateLabel ("90 Day Password Expiration: ", 10, 490, 100, 40)
    GUICtrlCreateLabel ("Last Logon: ", 10, 540, 100, 20)   

$font="Tahoma"
GUISetFont (9, 600, $font)   ; will display underlined characters
$unlock = GUICtrlCreateButton ( "UNLOCK Account", 180, 425, 120, 25)
GUICtrlSetState ( $unlock, $Gui_Disable )
GUICtrlCreateLabel ( ''& $username, 100, 10, 100, 20)
GUICtrlSetColor(-1,0x0000CC)    ; Blue
GUICtrlCreateLabel (''& $UserObj.FirstName, 100, 30, 100, 20)   
GUICtrlCreateLabel (''& $UserObj.LastName, 300, 30, 100, 20)    
GUICtrlCreateLabel (''& $UserObj.FullName, 100, 50, 300, 20)    
GUICtrlCreateLabel (''& $UserObj.Title, 100, 70, 100, 20)
$title = GUICtrlRead ( $title )
If $title = 0 Then
    GUICtrlCreateLabel ('', 100, 70, 100, 20)
Endif

$mgr = GUICtrlCreateLabel (''& $UserObj.Manager, 100, 90, 400, 70)  
$mgrvalue = GUICtrlRead ( $mgr )
$mgrsplit = StringSplit ( ""& $mgrvalue, ",")
$manager = StringTrimLeft ( ''& $mgrsplit[1], 3 )
GUICtrlCreateLabel (''& $manager, 100, 90, 400, 70)
GUICtrlCreateLabel (''& $UserObj.Description, 100, 150, 300, 40)    
GUICtrlCreateLabel (''& $UserObj.physicalDeliveryOfficeName, 100, 190, 100, 50) 
GUICtrlCreateLabel (''& $UserObj.Department, 100, 250, 200, 20) 
GUICtrlCreateLabel (''& $UserObj.TelephoneNumber, 100, 300, 250, 20)    
GUICtrlCreateLabel (''& $UserObj.TelephoneMobile, 100, 320, 250, 20)    
GUICtrlCreateLabel (''& $UserObj.TelephoneHome, 120, 350, 250, 20)  
GUICtrlCreateLabel (''& $UserObj.EmailAddress, 100, 370, 300, 20)   
GUICtrlCreateLabel (''& $UserObj.LoginScript, 100, 410, 200, 15)
$locked = GUICtrlCreateLabel (""& $UserObj.IsAccountLocked, 100, 430, 10, 20)
If GuiCtrlread ($locked) = 0 Then
GUICtrlCreateLabel ("NOT Locked", 100, 430, 80, 15)
GUICtrlSetBkColor(-1, 0x00ff00);Green
Else
GUICtrlCreateLabel ("LOCKED", 10, 430, 50, 20)
GUICtrlSetBkColor(-1, 0xff0000) ; Red
GUICtrlSetState ( $unlock, $Gui_Enable )

EndIf
$lastchange = $UserObj.PasswordLastChanged

$Date = StringMid($lastchange, 5, 2) & "/" & StringMid($lastchange, 7, 2) & "/" & StringMid($lastchange, 1, 4)
$Time = StringMid($lastchange, 9, 2) & ":" & StringMid($lastchange, 11, 2) & ":" & StringMid($lastchange, 13, 2)
GUICtrlCreateLabel ($Date & " "& $Time, 100, 460, 150, 20)
$pwdexpires = StringMid($lastchange, 5, 2) + 3 & "/" & StringMid($lastchange, 7, 2) & "/" & StringMid($lastchange, 1, 4)
GUICtrlCreateLabel ( $pwdexpires & ' ' & $Time, 100, 490, 150, 20)





$lastlogin = $UserObj.LastLogin

$Date = StringMid($lastlogin, 5, 2) & "/" & StringMid($lastlogin, 7, 2) & "/" & StringMid($lastlogin, 1, 4)
$Time = StringMid($lastlogin, 9, 2) & ":" & StringMid($lastlogin, 11, 2) & ":" & StringMid($lastlogin, 13, 2)
GUICtrlCreateLabel ($Date & " "& $Time, 100, 540, 150, 20)
$badlogin = GUICtrlCreateLabel (""& $UserObj.BadLoginCount, 430, 430, 20, 15)
If GuiCtrlread ($badlogin) = 0 Then
GUICtrlSetBkColor(-1, 0x00ff00);Green
Else
GUICtrlSetBkColor(-1, 0xff0000) ; Red
EndIf

    GUISetState ()
    
    
    
 While 1
        $msg = GUIGetMsg()
        Select
            Case $msg = $unlock
                If $UserObj.IsAccountLocked Then
                $UserObj.IsAccountLocked = False
                $UserObj.SetInfo
                EndIf
            
            Case $msg = $GUI_EVENT_CLOSE
            Exit
        EndSelect
    WEnd
    
    
    
    EndFunc
