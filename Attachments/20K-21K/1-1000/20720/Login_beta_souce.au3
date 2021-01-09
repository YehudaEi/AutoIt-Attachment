#include <GUIConstantsEx.au3>
#include <GUIConstantsEx.au3>
#include <IE.au3>
#include <WindowsConstants.au3>
$var = Ping("www.google.com",500)
If $var Then;kiem tra ket noi
    
Else
    Msgbox(0,"cc.haph@gmail.com SAY :Conection False","OPP ! Sorry I must send quit command     Recheck you network because you conection too slow so progame can not work or unsafe")
	Exit
EndIf
WinSetOnTop("Auto Login-beta", "", 1)

_IEErrorHandlerRegister ();bat loi~

$oIE_main = _IECreateEmbedded ();khai bao frame
Opt('MustDeclareVars', 2)

Ex()

Func Ex()
	Global $Button_1, $Button_2, $Button_3,$Button_4,$Button_Update, $msg,$GUIActiveX
	GUICreate("Auto Login-beta", 260,170,500,200) ; will create a dialog box that when displayed is centered

	Opt("GUICoordMode", 1)
	$Button_1 = GUICtrlCreateButton("YahooMail", 5, 10,80,30)
	$Button_2 = GUICtrlCreateButton("Gmail", 5, 40,80,30)
	$Button_3 = GUICtrlCreateButton("Mocxi", 5, 70,80,30)
	$Button_4 = GUICtrlCreateButton("Y!Messenger", 5, 100,80,30)
	$Button_Update=GUICtrlCreateButton("Chek Update", 5, 130,80,30)
	$GUIActiveX = GUICtrlCreateObj($oIE_main, 90, 10, 250, 150)
		   
	GUISetState()      ; will display an  dialog box 
_IENavigate ($oIE_main, "                                           ")
_IELoadWait ($oIE_main)
	; Run the GUI until the dialog is closed
	While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE				
				ExitLoop
				Exit
			Case $msg = $Button_1
				    ;yahoomail
				
Local $answer = InputBox("Enter ID", "Enter you ID acount","","",20,20)
Local $passwd = InputBox("Enter PW", "Enter your password.", "", "*",20,20)
Local $PW=$passwd
Local $ID=$answer
; Create a browser window and navigate
Local $oIEYmail = _IECreate ("https://login.yahoo.com/config/login_verify2?&.src=ym",0)
; get pointers to the login form and username, password and signin fields
Local $o_form = _IEFormGetObjByName ($oIEYmail, "login_form")
Local $o_login = _IEFormElementGetObjByName ($o_form, "login")
Local $o_password = _IEFormElementGetObjByName ($o_form, "passwd")
Local $o_signin = _IEFormElementGetObjByName ($o_form, ".save")
; Set field values and submit the form
_IEFormElementSetValue ($o_login, $ID)
_IEFormElementSetValue ($o_password, $PW)
_IEAction ($o_signin, "click")
Sleep(5000)
If WinExists("Yahoo! Mail: The best web-based email! - Microsoft Internet Explorer") Then; kiem tra tinh trng log in dua vao title
    MsgBox(0, "", "Login that bai vui long kiem tra lai ")
else
MsgBox(4096, "Da thuc thi xong", "ban da login thanh cong")
EndIf
Exit


			Case $msg = $Button_2
				
				; gmail
Local $answer = InputBox("Enter ID", "Enter you ID acount","","",20,20)
Local $passwd = InputBox("Enter PW", "Enter your password.", "", "*",20,20)
Local $PW=$passwd
Local $ID=$answer
; Create a browser window and navigate
Local $oIEGmail = _IECreate ("http://www.gmail.com",0)
; get pointers to the login form and username, password and signin fields
Local $o_form = _IEFormGetObjByName ($oIEGmail, "gaia_loginform")
Local $o_login = _IEFormElementGetObjByName ($o_form, "Email")
Local $o_password = _IEFormElementGetObjByName ($o_form, "Passwd")
Local $o_signin = _IEFormElementGetObjByName ($o_form, "signIn")
; Set field values and submit the form
_IEFormElementSetValue ($o_login, $ID)
_IEFormElementSetValue ($o_password, $PW)
_IEAction ($o_signin, "click")
Sleep(5000)
If WinExists("Gmail: Email from Google - Microsoft Internet Explorer") Then
    MsgBox(0, "", "Login that bai vui long kiem tra lai ")
else
MsgBox(4096, "Da thuc thi xong", "ban da login thanh cong" )
EndIf
Exit


			Case $msg = $Button_3
				    ; mocxi
Local $varProxy=(MsgBox(0x4, "Chon lua", "Ban co muon dung proxy ko?"))
if $varProxy=6 Then
Local $answer = InputBox("Enter ID", "Enter you ID acount","","",20,20)
Local $passwd = InputBox("Enter PW", "Enter your password.", "", "*",20,20)
Local $PW=$passwd
Local $ID=$answer
; Create a browser window and navigate
Local $oIEMoc = _IECreate ("                                                                                               ",0)
; get pointers to the login form and username, password and signin fields
Local $o_form = _IEFormGetObjByName ($oIEMoc, "LOGIN")
Local $o_login = _IEFormElementGetObjByName ($o_form, "UserName")
Local $o_password = _IEFormElementGetObjByName ($o_form, "PassWord")
Local $o_signin = _IEFormElementGetObjByName ($o_form, "submit")
; Set field values and submit the form
_IEFormElementSetValue ($o_login, $ID)
_IEFormElementSetValue ($o_password, $PW)
_IEAction ($o_signin, "click")
Sleep(5000)
If WinExists("Log In - Microsoft Internet Explorer") Then
    MsgBox(0, "", "Login that bai vui long kiem tra lai ")
else
MsgBox(4096, "Da thuc thi xong", "ban da login thanh cong" )
EndIf
Exit


	ElseIf $varProxy = 7 Then
Local $answer = InputBox("Enter ID", "Enter you ID acount","","",20,20)
Local $passwd = InputBox("Enter PW", "Enter your password.", "", "*",20,20)
Local $PW=$passwd
Local $ID=$answer
; Create a browser window and navigate
Local $oIEMoc = _IECreate ("                                                    ",0)
; get pointers to the login form and username, password and signin fields
Local $o_form = _IEFormGetObjByName ($oIEMoc, "LOGIN")
Local $o_login = _IEFormElementGetObjByName ($o_form, "UserName")
Local $o_password = _IEFormElementGetObjByName ($o_form, "PassWord")
Local $o_signin = _IEFormElementGetObjByName ($o_form, "submit")
; Set field values and submit the form
_IEFormElementSetValue ($o_login, $ID)
_IEFormElementSetValue ($o_password, $PW)
_IEAction ($o_signin, "click")
Sleep(5000)
If WinExists("Log In - Microsoft Internet Explorer") Then
	
    MsgBox(0, "", "Login that bai vui long kiem tra lai ")
else
MsgBox(4096, "Da thuc thi xong", "ban da login thanh cong" )
EndIf
EndIf
Exit


			Case $msg = $Button_4
				
				Local $oIEYM = _IECreate ("ymsgr:sendim?0989152598&m=Some+Bug+For+You",0)
				MsgBox(0, 'Testing-Login manual', 'Chuc nang dang cap nhat')    ; CHat
				
			Case $msg = $Button_Update
				MsgBox(0, "Update-Beta","Viec nay se tien hanh tai phien ban moi ve")
				InetGet("                                                        ","Login-beta_souce.zip", 10, 16)
				While @InetGetActive
	TrayTip("Dang tai ....", "Bytes = " & @InetGetBytesRead, 1, 1)
	
	Wend

	MsgBox(0, "Cap nhat hoan thanh-phien ban Beta","dung luong phien ban hien tai (KB):"& @InetGetBytesRead)

		EndSelect
	WEnd
EndFunc  
Exit

;==>Example
