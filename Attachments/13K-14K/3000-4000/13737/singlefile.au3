#include <web.au3>
#include <string.au3>

$action = _Get ("act")
$script = StringRight ($_SCRIPT_NAME, StringLen($_SCRIPT_NAME)-StringInStr($_SCRIPT_NAME, "/", 0, -1))

If $action = "about" Then
	_StartWebApp ("About")
	echo ("<center>")
	echol ("<b>About</b>")
	echol ("Created by AutoItKing. Simple sign-up and log-in script using INI's instead of a database server such as MySQL, Acess, et cetera.")
	echo ("</canter>")
	

ElseIf $action = "signup" Then
	
	;Sign Up Form
	
	_StartWebApp("Sign Up")

	echo ("<center>")
	$form11 = "<form action=" & $script & "?act=signup2 method=post>"
	$form12 = "User Name: <input name=usrnm><br />"
	$form13 = "E-Mail: <input name=email><br />"
	$form14 = "Password: <input type=password name=password><br />"
	$form15 = "Re-Type Password: <input type=password name=password2><br />"
	$form16 = "<input type=submit value='Sign Up!'></form>"
	$form1 = $form11 & $form12 & $form13 & $form14 & $form15 & $form16
	echo ($form1)
	echo ("<center>")

ElseIf $action = "signup2" Then

	;Sign Up Processor

	_StartWebApp("Sign Up")

	echo ("<center>")
	$dir = IniRead("config.ini","config","usersdir","C:\users\") ;@ScriptDir & "\users\"
	$usrnm1 = False
	$email1 = False
	$pass1 = False

	If _Post("usrnm") <> "" Then
		;echo (_Post("usrnm") & "<br />")
		$usrnm1 = True
	Else
		echo ("Please enter a user name!<br />")
	EndIf

	If _Post("email") <> "" Then
		;echo (_Post("email") & "<br />")
		$email1 =  True
	Else
		echo ("Please enter an email address!<br />")
	EndIf

	If _Post("password") <> "" And _Post("password2") <> "" Then
		;echo (_Post("password") & "<br />")
		$pass1 = True
	Else
		echo ("Please enter a password in both password fields!<br />")
	EndIf

	If  _Post("password") <> _Post("password2") Then
		echo ("Passwords must match!<br />")
		$pass1 = False
	EndIf


	If $usrnm1 And $email1 And $pass1 Then
		echo ("Processing your request:<br />")
		$user = $dir & _Post("usrnm") & ".ini"
		If Not FileExists($user) Then
			echo ("Creating file: " & $user & "<br />")
			echo ("Write Username to INI<br />")
			IniWrite($user,"main","username",_Post("usrnm"))
			If @error Then
				echo ("Error!!")
			Else
				echo ("Write Password to INI<br />")
				IniWrite($user,"main","password",_StringEncrypt(1,_Post("password"),_Post("password")))
				If @error Then
					echo ("Error!!")
				Else
					echo ("Write Email to INI<br />")
					IniWrite($user,"main","email",_Post("email"))
					If @error Then
						echo ("Error!!")
					EndIf
				EndIf
			EndIf
			echo ("DONE! You may now <a href=" & $script & "?act=login>Log In</a>")
		Else
			echo ("That Username already exists!!!")
		EndIf
	EndIf

	echo ("</center>")

ElseIf $action = "login" Then
	
	;Log In Form

	_StartWebApp("Log In")
	echo ("<center>")
	$form11 = "<form action=" & $script & "?act=login2 method=post>"
	$form12 = "User Name: <input name=usrnm><br />"
	$form13 = "Password: <input type=password name=password><br />"
	$form14 = "<input type=submit value='Log In!'></form>"
	$form1 = $form11 & $form12 & $form13 & $form14
	echo ($form1)
	echo ("<center>")

ElseIf $action = "login2" Then
	
	;Log In Processor

	_StartWebApp("Logged In?")

	$dir = IniRead("config.ini","config","usersdir","C:\users\") ;@ScriptDir & "\users\"
	$user = $dir & _Post("usrnm") & ".ini"

	echo ("<center>")

	If Not _Post("usrnm") Then
		echo ("Please Log In")
	EndIf

	If Not FileExists($user) Then
		echo ("User does not exist")
	Else
		If _StringEncrypt(1,_Post("password"),_Post("password")) <> IniRead($user,"main","password","") Then
			echo ("Incorrect password for that user")
		Else
			;_StartWebApp("Logged In")
			echo ("Logged in as: " & _Post("usrnm") & "<br />")
		EndIf
	EndIf

	echo ("</center>")

Else 
	
	;Log In Form

	_StartWebApp("Log In")
	echo ("<center>")
	$form11 = "<form action=" & $script & "?act=login2 method=post>"
	$form12 = "User Name: <input name=usrnm><br />"
	$form13 = "Password: <input type=password name=password><br />"
	$form14 = "<input type=submit value='Log In!'></form><br /><a href=" & $script & "?act=signup>Sign Up</a><br /><a href=" & $script & "?act=about>About</a>"
	$form1 = $form11 & $form12 & $form13 & $form14
	echo ($form1)
	echo ("<center>")
	
EndIf