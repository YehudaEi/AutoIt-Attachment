Opt('MustDeclareVars', 1)

local $time,$input, $x, $Var

If not WinExists ("Microsoft Outlook 2003") Then
	msgbox (0, "User Message", "Outlook will start!", "2")
	Run ("C:\Program Files\Microsoft Office\Office\outlook.exe")
	Else 
	;msgbox (0, "User Message", "Please wait", "1")
Endif
	
$input = InputBox("Enter Email Address", "Please Enter a valid email address","") 
	
if @error= 1 then Exit

$time = Inputbox("Message", "Please enter how many message to be sent?", "") 

if @error= 1 then Exit	
	
$var = FileOpenDialog("Select a file to be added ", @WorkingDir & "\", "(*.*)")
	
If @error Then
	MsgBox(4096,"","No File chosen")
Else
	$var = StringReplace($var, "|", @CRLF)
	;	MsgBox(4096,"","You chose " & $var)
EndIf

	Sleep (500)	
$x=0

Do
	
	WinActivate("Inbox - Microsoft Outlook", "")
	Send("^n") ; Ctrl N "for  new email window"
	WinActivate("Untitled - Message (Rich Text) ", "")
	Send ($input) 
	Send ("!J") ; "Alt J"  key pressed for subject box
	Send ("Message" &  $x)
	Send("!if") ; Alt I F keys " to open Attachment window "
	WinWait("", "",5)
	send ($var)
	;Send ("C:\Program Files\test.txt")
	WinWait("", "", 5)
	Send("{ENTER}")
	Send("{ENTER}")
	WinWait("", "", 5)
	Send("^{ENTER}")
	Sleep (1000)
	$x=$x+1
Until $x=$time
MsgBox (0, "Message Sent", "Total of "& $x & " messages has been sent to " & $input) 



