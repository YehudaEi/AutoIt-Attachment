#include <IE.au3>
#include <GUIConstants.au3>
autoitsetoption("WinTitleMatchMode", 4)

;Program Counter
$TIMES=iniread("C:\windows\mafialife.ini", "LOGIN #", "TIMES", "")
$TIMES=$TIMES + 1
iniwrite("C:\windows\mafialife.ini","LOGIN #", "TIMES", $TIMES)

; INI Information
dim $info[2]
$info[0]=iniread("C:\Windows\Mafialife.ini", "EMAIL", "LAST", "")
$info[1]=iniread("C:\Windows\Mafialife.ini", "PASS", "LAST", "")

;Establish GUI
guicreate("Mafialife Login", 200, 100)
guictrlcreatelabel("E-Mail", 5, 12)
$email=guictrlcreateinput($info[0], 80, 10, 100)
guictrlcreatelabel("Password", 5, 42)
$pass=guictrlcreateinput($info[1], 80, 40, 100,-1,$ES_PASSWORD)
$check=guictrlcreatecheckbox("Save Info", 5, 70)
$button_1=guictrlcreatebutton("Login", 150, 70)
$button_2=guictrlcreatebutton("Register",100,70)
guisetstate(@SW_SHOW)


while 1
    $msg = GUIGetMsg()
   Select
       Case $msg = $GUI_EVENT_CLOSE
         ExitLoop
      
  Case $msg = $button_1
	  guisetstate(@SW_HIDE)
		If guictrlread($check)= $GUI_CHECKED Then
			INIWRITE("C:\windows\mafialife.ini", "EMAIL", "LAST", guictrlread($email))
			INIWRITE("C:\windows\mafialife.ini","PASS", "LAST", guictrlread($pass))
			login(guictrlread($email), guictrlread($pass))
			exitloop
		Else
		login(guictrlread($email), guictrlread($pass))
		exitloop
	EndIf
Case $msg = $button_2
	_IECreate("                                                             ")
	ExitLoop
        
EndSelect

	
WEnd



func login($name, $pass)
	$oIE = _IECreate ("                                   ",0,0)
	_IELoadWait($oIE)
	$oForm = _IEFormGetObjByName ($oIE, "login_form")
	$oQuery1 = _IEFormElementGetObjByName ($oForm, "email")
	$oQuery2 = _IEFormElementGetObjByName ($oForm, "password")
	$oSubmit = _IEFormElementGetObjByName ($oForm, "submit")
	_IEFormElementSetValue ($oQuery1, $name)
	_IEFormElementSetValue ($oQuery2, $pass)
	_IEAction ($oSubmit, "click")
	_IELoadWait($oIE)
	_IEAction ($oIE, "visible")
	$title=wingettitle("active")
	WinSetState($title,"",@SW_Maximize)
EndFunc
