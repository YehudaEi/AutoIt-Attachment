;#include <IE.au3>
#include <GuiConstants.au3>

HotKeySet("{ESC}", "MyExit")

$x = 0 

; GUI
GuiCreate("Test", 200, 350)
$var = RegEnumVal("HKEY_LOCAL_MACHINE\SOFTWARE\Test", 2)
$var2 = RegEnumVal("HKEY_LOCAL_MACHINE\SOFTWARE\Test", 3)
$oldemail = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Test",$var)
$oldpasswd = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Test",$var2)

GuiCtrlCreateLabel("Your Login Information:", 10, 20)
GuiCtrlCreateLabel("Email: ", 45, 48)
GuiCtrlCreateLabel("Password: ", 24, 70)
$EmailLabel = GuiCtrlCreateLabel($oldemail, 78, 48,150,20)
$PasswordLabel = GuiCtrlCreateLabel($oldpasswd, 78, 70,150,20)

$new = GUICtrlCreateButton("Change Login", 58, 100, 100, 30)
$new2 = GuiCtrlCreateButton("Go!", 58, 175, 100, 30)
$new3 = GuiCtrlCreateButton("Stop", 58, 225, 100, 30)
GUISetState () 


; GUI MESSAGE LOOP
While 1
	$msg = GUIGetMsg()
Select	
	Case $msg = $GUI_EVENT_CLOSE
		Exit
	
	Case $msg = $new
		Addnew()
	
	Case $msg = $new2
		Edit()
		
	Case $msg = $new3
		MyExit()	
			
EndSelect
WEnd


Func Addnew()
	$email = InputBox("Email","Please enter your email address")
	$passwd = InputBox("Password","Please enter your password","","*")
	$rw = RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Test","Email","REG_SZ",$email)
	$rw = RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Test","Password","REG_SZ",$passwd)
	GUICtrlSetData($EmailLabel,$email)
	GUICtrlSetData($PasswordLabel,$passwd)
EndFunc


Func Edit()
	$x = 0
	
	;~ $oIE = _IECreate()
	;~ _IENavigate ($oIE, "http://www.autoitscript.com")
	
	;~ $o_form = _IEFormGetObjByName($oIE, "theForm")
	;~ $o_login = _IEFormElementGetObjByName($o_form, "email")
	;~ $o_password = _IEFormElementGetObjByName($o_form, "password")
	
	;~ _IEFormElementSetValue($o_login, $email)
	;~ _IEFormElementSetValue($o_password, $passwd)
	;~ _IEFormSubmit($o_form)
	
	;~ _IELoadWait($oIE)
	
	;~ _IEClickLinkByText($oIE, "Forum")
	;~ _IELoadWait($oIE)
	
	;~ $begin = TimerInit()
	
	While 1
	Sleep(10)	
		$msg = GUIGetMsg()
		If $msg = $GUI_EVENT_CLOSE Then Exit
		If $msg = $new3 Then  MyExit()
		
		;~ $temp = _IEFormGetCount($OIE)
		
		;~ If $temp = 3 Then
			;~ $oFrom = _IEFormGetObjByIndex($oIE, 2)
			;~ $change = Random(4, 13, 1) 
			;~ $oRelevant = _IEFormElementGetObjByIndex($oFrom, $change)
			;~ $oRelevant.Click
			;~ _IELoadWait($oIE)
		;~ Else
			;~ _IENavigate ($oIE, "http://www.autoitscript.com")
			;~ $o_form = _IEFormGetObjByName($oIE, "theForm")
			;~ $o_login = _IEFormElementGetObjByName($o_form, "email")
			;~ $o_password = _IEFormElementGetObjByName($o_form, "password")
			;~ ;----------Set field values and submit the form
			;~ _IEFormElementSetValue($o_login, $email)
			;~ _IEFormElementSetValue($o_password, $passwd)
			;~ _IEFormSubmit($o_form)
			;~ _IELoadWait($oIE)
			;~ _IEClickLinkByText ($oIE, "Forum")
			;~ _IELoadWait($oIE)
		;~ EndIf
	WEnd
EndFunc

Func MyExit()
	;~ $diff = TimerDiff($begin)
	MsgBox(0,"Test","")
	Exit
EndFunc

Func OnExit()
	Exit
EndFunc

