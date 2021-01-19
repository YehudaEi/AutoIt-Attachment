#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=..\ajoin.ico
#AutoIt3Wrapper_outfile=Http1.1 Console.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseAnsi=y
#AutoIt3Wrapper_Res_Comment=Http1.1 Console, Made by SK.
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstants.au3>

$PostData = IniRead("HTTPCheck.ini", "Settings", "RunCMD", "login:command/username=admin&login:command/password=password")
$ObjUsed = IniRead("HTTPCheck.ini", "Settings", "OBJ", "MSXML2.ServerXMLHTTP")
$Method = IniRead("HTTPCheck.ini", "Settings", "Method", "POST")
$username = IniRead("HTTPCheck.ini", "Settings", "USRN", "admin")
$password = IniRead("HTTPCheck.ini", "Settings", "PASS", "password")
$sUrl = IniRead("HTTPCheck.ini", "Settings", "URL", "                              ")
$Header1 = IniRead("HTTPCheck.ini", "Settings", "HEADER1T", "Content-Type")
$Header1D = IniRead("HTTPCheck.ini", "Settings", "HEADER1C", "application/x-www-form-urlencoded")
$Header2 = IniRead("HTTPCheck.ini", "Settings", "HEADER2T", "")
$Header2D = IniRead("HTTPCheck.ini", "Settings", "HEADER2C", "")
$Header3 = IniRead("HTTPCheck.ini", "Settings", "HEADER3T", "")
$Header3D = IniRead("HTTPCheck.ini", "Settings", "HEADER3C", "")
$Header4 = IniRead("HTTPCheck.ini", "Settings", "HEADER4T", "")
$Header4D = IniRead("HTTPCheck.ini", "Settings", "HEADER4C", "")
$TimeOut_Resolve = IniRead("HTTPCheck.ini", "Settings", "TimeOut_Resolve", "")
$TimeOut_Connect = IniRead("HTTPCheck.ini", "Settings", "TimeOut_Connect", 60)
$TimeOut_Send = IniRead("HTTPCheck.ini", "Settings", "TimeOut_Send", 30)
$TimeOut_Recv = IniRead("HTTPCheck.ini", "Settings", "TimeOut_Recv", 30)

Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=C:\KodaForms\OBJChecker.kxf
$Form1 = GUICreate("Http1.1 Console", 917, 527, 100, 119)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
$Edit1 = GUICtrlCreateEdit("", 5, 115, 905, 374)
$RunCMDButton = GUICtrlCreateButton("Send Http1.1", 560, 0, 75, 25)
GUICtrlSetOnEvent(-1, "RunCMDButtonClick")
GUICtrlSetTip(-1, "Sends the current Http1.1 CMD")
$RunCMDInput = GUICtrlCreateInput($PostData, 5, 5, 551, 21)
GUICtrlSetTip(-1, "Http1.1 data to send")
$UserNameInput = GUICtrlCreateInput($username, 645, 5, 76, 21)
GUICtrlSetTip(-1, "Username for credentials to be sent")
$PassInput = GUICtrlCreateInput($password, 725, 5, 81, 21)
GUICtrlSetTip(-1, "Password for credentials to be sent")
$SetUsrPassButton = GUICtrlCreateButton("Set usr+pass", 820, 0, 85, 25, 0)
GUICtrlSetOnEvent(-1, "SetUsrPassButtonClick")
$ChangeOBJInput = GUICtrlCreateInput($ObjUsed, 525, 30, 156, 21)
GUICtrlSetTip(-1, "Obj to use for the send.")
$ChangeOBJButton = GUICtrlCreateButton("Set OBJ", 690, 30, 75, 25)
GUICtrlSetOnEvent(-1, "ChangeOBJButtonClick")
$MethodInput = GUICtrlCreateInput($Method, 770, 30, 61, 21)
GUICtrlSetTip(-1, "Method to send with [EG: Post, Get...]")
$SetMethodButton = GUICtrlCreateButton("Set Method", 835, 25, 70, 25, 0)
GUICtrlSetOnEvent(-1, "SetMethodButtonClick")
$Label4 = GUICtrlCreateLabel("Address:", 4, 36, 91, 17)
$SetAddressButton = GUICtrlCreateButton("Set Address", 445, 30, 75, 25, 0)
GUICtrlSetOnEvent(-1, "SetAddressButtonClick")
GUICtrlSetTip(-1, "The address to send the Http1.1 request to.")
$AddressInput = GUICtrlCreateInput($sUrl, 104, 31, 331, 21)
$SaveButton = GUICtrlCreateButton("Save All", 5, 90, 50, 17)
GUICtrlSetOnEvent(-1, "SaveButtonClick")
GUICtrlSetTip(-1, "Saves all settings")
$Label1 = GUICtrlCreateLabel("Headers: ", 5, 60, 50, 17)
$HeadersInput1 = GUICtrlCreateInput("", 105, 60, 331, 21)
If $Header1<> "" Then GUICtrlSetData(-1, $Header1 & "|" & $Header1D)	
$SetHeaderButton = GUICtrlCreateButton("Set Header", 785, 60, 120, 50)
GUICtrlSetOnEvent(-1, "SetHeaderButtonClick")
GUICtrlSetTip(-1, "Set a header for the send. [Title|Content]")
$HeadersInput2 = GUICtrlCreateInput("", 445, 59, 331, 21)
If $Header2<> "" Then GUICtrlSetData(-1, $Header2 & "|" & $Header2D)
GUICtrlSetTip(-1, "Set a header for the send. [Title|Content]")
$HeadersInput3 = GUICtrlCreateInput("", 103, 89, 331, 21)
If $Header3<> "" Then GUICtrlSetData(-1, $Header3 & "|" & $Header3D)
GUICtrlSetTip(-1, "Set a header for the send. [Title|Content]")
$HeadersInput4 = GUICtrlCreateInput("", 446, 90, 331, 21)
If $Header4<> "" Then GUICtrlSetData(-1, $Header4 & "|" & $Header4D)
GUICtrlSetTip(-1, "Set a header for the send. [Title|Content]")
$ClearButton = GUICtrlCreateButton("Clear All", 10, 495, 75, 25, 0)
GUICtrlSetOnEvent(-1, "ClearButtonClick")
GUICtrlSetTip(-1, "Clears the EditBox")
$ExportButton = GUICtrlCreateButton("Export...", 100, 495, 75, 25, 0)
GUICtrlSetOnEvent(-1, "ExportButtonClick")
GUICtrlSetTip(-1, "Exports the content of the editbox")
$ResolveTimeOutInput = GUICtrlCreateInput($TimeOut_Resolve, 205, 496, 46, 21)
GUICtrlSetTip(-1, "Reslove Ip Time Out [D=infinite], The value is applied to mapping host names to IP addresses")
$ConnectTimeOutInput = GUICtrlCreateInput($TimeOut_Connect, 254, 496, 46, 21)
GUICtrlSetTip(-1, "Connect Time Out [D=60], The value is applied to establishing a communication socket with the target server")
$SendTimeOutInput = GUICtrlCreateInput($TimeOut_Send, 305, 496, 46, 21)
GUICtrlSetTip(-1, "Send Time Out [D=30], The value applies to sending an individual packet of request data to the target server")
$RecvTimeOutInput = GUICtrlCreateInput($TimeOut_Recv, 358, 496, 46, 21)
GUICtrlSetTip(-1, "Recive Time Out [D=30], The value applies to receiving a packet of response data from the target server")
$SetTimeOutsButton = GUICtrlCreateButton("Set Time-Outs", 410, 495, 75, 25, 0)
GUICtrlSetOnEvent(-1, "SetTimeOutsButtonClick")
$LinkL = GUICtrlCreateLabel("http://msdn2.microsoft.com/en-us/library/ms757828.aspx", 525, 500, 276, 17)
GUICtrlSetOnEvent(-1, "LinkLClick")
$ExitButton = GUICtrlCreateButton("Exit", 825, 495, 75, 25, 0)
GUICtrlSetOnEvent(-1, "Form1Close")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $oHttpRequest
$EditData = ""

$oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
$UseLogFile = IniRead(@ScriptDir & "\" & @ScriptName & ".Settings.ini", "Sets:", "LogProcess", 1)
__LOG("______________________________Script Start______________________________" & @CRLF)
While 1
	Sleep(100)
WEnd

Func RunCMDButtonClick()
	$PostData = GUICtrlRead($RunCMDInput)
	If IsObj($oHttpRequest) <> 1 Then Return MsgBox(0, "failed", "You must set an OBJ")
	If $Method = "" Then Return MsgBox(0, "failed", "You must set a method")
	If $sUrl = "" Then Return MsgBox(0, "failed", "You must set an address")
	
	$EditData &= "[Obj:" & $ObjUsed & "][IP:" & $sUrl & "][Method:" & $Method & "][Data:" & $PostData & "]" & @CRLF & "[Headers:" & @CRLF
	
	$oHttpRequest.Open($Method, $sUrl, False, $username, $password)
	If $Header1 <> "" Then
		$oHttpRequest.setRequestHeader($Header1, $Header1D)
		$EditData &= $Header1 & " | " & $Header1D & @CRLF
	EndIf
	If $Header2 <> "" Then
		$oHttpRequest.setRequestHeader($Header2, $Header2D)
		$EditData &= $Header2 & " | " & $Header2D & @CRLF
	EndIf
	If $Header3 <> "" Then
		$oHttpRequest.setRequestHeader($Header3, $Header3D)
		$EditData &= $Header3 & " | " & $Header3D & @CRLF
	EndIf
	If $Header4 <> "" Then
		$oHttpRequest.setRequestHeader($Header4, $Header4D)
		$EditData &= $Header4 & " | " & $Header4D & @CRLF
	EndIf
	$EditData &= "/Headers]" & @CRLF
	$oHttpRequest.setTimeouts($TimeOut_Resolve, $TimeOut_Connect, $TimeOut_Send, $TimeOut_Recv)
	GUICtrlSetData($Edit1, $EditData)
	$oHttpRequest.Send($PostData)
	$Recieved = $oHttpRequest.Responsetext
	$EditData &= @CRLF & $Recieved & @CRLF & "____________________________________________________________________" & @CRLF
	GUICtrlSetData($Edit1, $EditData)
	__LOG($EditData & @CRLF & @CRLF)
EndFunc   ;==>RunCMDButtonClick
Func SetUsrPassButtonClick()
	$username = GUICtrlRead($UserNameInput)
	$password = GUICtrlRead($PassInput)
EndFunc   ;==>SetUsrPassButtonClick
Func ChangeOBJButtonClick()
	$ObjUsed = GUICtrlRead($ChangeOBJInput)
	If IsObj($oHttpRequest) Then $oHttpRequest.Quit
	$oHttpRequest = ObjCreate($ObjUsed)
EndFunc   ;==>ChangeOBJButtonClick
Func SetAddressButtonClick()
	$sUrl = GUICtrlRead($AddressInput)
EndFunc   ;==>SetAddressButtonClick
Func SetMethodButtonClick()
	$Method = GUICtrlRead($MethodInput)
EndFunc   ;==>SetMethodButtonClick
Func SetHeaderButtonClick()
	If GUICtrlRead($HeadersInput1) <> "" Then
		$text = StringSplit(GUICtrlRead($HeadersInput1), "|")
		If @error <> 1 Then
			If $text[0] > 1 Then
				$Header1 = $text[1]
				$Header1D = $text[2]
			EndIf
		EndIf
	EndIf
	If GUICtrlRead($HeadersInput2) <> "" Then
		$text = StringSplit(GUICtrlRead($HeadersInput2), "|")
		If @error <> 1 Then
			If $text[0] > 1 Then
				$Header2 = $text[1]
				$Header2D = $text[2]
			EndIf
		EndIf
	EndIf
	If GUICtrlRead($HeadersInput3) <> "" Then
		$text = StringSplit(GUICtrlRead($HeadersInput3), "|")
		If @error <> 1 Then
			If $text[0] > 1 Then
				$Header3 = $text[1]
				$Header3D = $text[2]
			EndIf
		EndIf
	EndIf
	If GUICtrlRead($HeadersInput4) <> "" Then
		$text = StringSplit(GUICtrlRead($HeadersInput4), "|")
		If @error <> 1 Then
			If $text[0] > 1 Then
				$Header4 = $text[1]
				$Header4D = $text[2]
			EndIf
		EndIf
	EndIf
EndFunc   ;==>SetHeaderButtonClick
Func ClearButtonClick()
	$EditData = ""
	GUICtrlSetData($Edit1, $EditData)
EndFunc   ;==>ClearButtonClick
Func SaveButtonClick()
	IniWrite("HTTPCheck.ini", "Settings", "RunCMD", GUICtrlRead($RunCMDInput))
	IniWrite("HTTPCheck.ini", "Settings", "OBJ", $ObjUsed)
	IniWrite("HTTPCheck.ini", "Settings", "Method", $Method)
	IniWrite("HTTPCheck.ini", "Settings", "USRN", $username)
	IniWrite("HTTPCheck.ini", "Settings", "PASS", $password)
	IniWrite("HTTPCheck.ini", "Settings", "URL", $sUrl)
	IniWrite("HTTPCheck.ini", "Settings", "HEADER1T", $Header1)
	IniWrite("HTTPCheck.ini", "Settings", "HEADER1C", $Header1D)
	IniWrite("HTTPCheck.ini", "Settings", "HEADER2T", $Header2)
	IniWrite("HTTPCheck.ini", "Settings", "HEADER2C", $Header2D)
	IniWrite("HTTPCheck.ini", "Settings", "HEADER3T", $Header3)
	IniWrite("HTTPCheck.ini", "Settings", "HEADER3C", $Header3D)
	IniWrite("HTTPCheck.ini", "Settings", "HEADER4T", $Header4)
	IniWrite("HTTPCheck.ini", "Settings", "HEADER4C", $Header4D)
	IniRead("HTTPCheck.ini", "Settings", "TimeOut_Resolve", $TimeOut_Resolve)
	IniRead("HTTPCheck.ini", "Settings", "TimeOut_Connect", $TimeOut_Connect)
	IniRead("HTTPCheck.ini", "Settings", "TimeOut_Send", $TimeOut_Send)
	IniRead("HTTPCheck.ini", "Settings", "TimeOut_Recv", $TimeOut_Recv)
EndFunc   ;==>SaveButtonClick
Func ExportButtonClick()
	$exporttxt = GUICtrlRead($Edit1)
	$file = FileSaveDialog("Http1.1 Exporter", @DesktopCommonDir, "All (*.*)", 18, "Returned.html")
	If @error = 1 Then Return
	$filehandle = FileOpen($file, 9)
	FileWrite($filehandle, $exporttxt)
	FileClose($filehandle)
EndFunc
Func SetTimeOutsButtonClick()
	$TimeOut_Resolve = GUICtrlRead($ResolveTimeOutInput)
	$TimeOut_Connect = GUICtrlRead($ConnectTimeOutInput)
	$TimeOut_Send = GUICtrlRead($SendTimeOutInput)
	$TimeOut_Recv = GUICtrlRead($RecvTimeOutInput)
EndFunc
Func LinkLClick()
	Run(@ComSpec & " /c " & "start " & GUICtrlRead($LinkL) & " /SEPARATE", "", @SW_HIDE)
EndFunc
Func Form1Close()
	If IsObj($oHttpRequest) Then $oHttpRequest.Quit
	Exit
EndFunc   ;==>Form1Close

Func MyErrFunc() ;Error Handler - so that users won't see the autoit errors...
	$HexNumber = Hex($oMyError.number, 8)
	__LOG("###  We intercepted a COM Error :" & $HexNumber & @CRLF & @CRLF & _
			"err.description is: " & @TAB & $oMyError.description & @CRLF & _
			"err.windescription:" & @TAB & $oMyError.windescription & @CRLF & _
			"err.number is: " & @TAB & Hex($oMyError.number, 8) & @CRLF & _
			"err.lastdllerror is: " & @TAB & $oMyError.lastdllerror & @CRLF & _
			"err.scriptline is: " & @TAB & $oMyError.scriptline & @CRLF & _
			"err.source is: " & @TAB & $oMyError.source & @CRLF & _
			"err.helpfile is: " & @TAB & $oMyError.helpfile & @CRLF & _
			"err.helpcontext is: " & @TAB & $oMyError.helpcontext & @CRLF _
			)
	If $HexNumber = 80020009 Then Return
	MsgBox(262144, "Http1.1 Exporter :(", "We intercepted a COM Error :" & $HexNumber & @CRLF & @CRLF & _
			"err.description is: " & @TAB & $oMyError.description & @CRLF & _
			"err.windescription:" & @TAB & $oMyError.windescription & @CRLF & _
			"err.number is: " & @TAB & Hex($oMyError.number, 8) & @CRLF & _
			"err.lastdllerror is: " & @TAB & $oMyError.lastdllerror & @CRLF & _
			"err.scriptline is: " & @TAB & $oMyError.scriptline & @CRLF & _
			"err.source is: " & @TAB & $oMyError.source & @CRLF & _
			"err.helpfile is: " & @TAB & $oMyError.helpfile & @CRLF & _
			"err.helpcontext is: " & @TAB & $oMyError.helpcontext _
			)
EndFunc   ;==>MyErrFunc

Func __LOG($text)
	ConsoleWrite($text & @CRLF)
	If $UseLogFile = 0 Then Return
	
	$html_fileH = FileOpen(@ScriptDir & "\" & @ScriptName & ".Log", 9)
	FileWrite($html_fileH, @MDAY & "-" & @MON & "-" & @YEAR & " " & @HOUR & ":" & @MIN & @TAB & $text & @CRLF)
	FileClose($html_fileH)
EndFunc   ;==>__LOG