#include-once
#Include <Date.au3>
#Include <String.au3>
#Include <File.au3>
#include <Array.au3>
#include "C:\$user\Program Files\Scripts\Scripts\$Include\ftp.au3"
Global $Language = ""
If Not $Language Then $Language = StringLeft(RegRead("HKEY_CURRENT_USER\Control Panel\International","sLanguage"),2); Default language is the windows default language
#cs===============================================================================
 Function Name:    MainControls
 Description:      Performs Single On control and Windows compatibility control
 Parameter(s):     None
 Requirement(s):   Misc.au3
 Return Value(s):  On Success - "" (nothing)
                   On Failure - Error Message
 Author(s):        Christophe Savard
#ce===============================================================================
Func MainControls()
	If _Singleton(@ScriptName,1) = 0 Then ; If already active then script exits
		If StringInStr($Language,"EN",2) Then
			$Msg = "Application " & @ScriptName & " already active !!!"
		ElseIf StringInStr($Language,"FR",2) Then
			$Msg = "Application " & @ScriptName & " déjà active !!!"
		Else ; Any other language
		
		EndIf
		ProgressOff()
		MsgBox(48+262144,$Title & " - ATTENTION !!!", $Msg,5)
		Exit
	EndIf
	
	If @OSVersion <> "WIN_XP" And @OSVersion <>  "WIN_VISTA" And @OSVersion <> "WIN_2003" Then ; Test if the OS is compatible Test de l'OS with scripts requirements.
		If StringInStr($Language,"EN",2) Then
			$Msg = "The Windows version installed on your computer" & @CRLF & "do not allow to use this utility." & @CRLF & @CRLF & " Supported Versions are : Windows XP and above" & @CRLF & @CRLF
		ElseIf StringInStr($Language,"FR",2) Then
			$Msg = "La version de Windows installée sur votre machine" & @CRLF & "ne permet pas d'utiliser ce programme." & @CRLF & @CRLF & " Versions supportées : Windows XP et plus" & @CRLF & @CRLF
		Else ; Any other language
			
		EndIf
		ProgressOff()
		MsgBox(48+262144,$Title & " - ATTENTION !!!", $Msg,5)
		Exit
	EndIf
EndFunc
#cs===============================================================================
 Function Name:    _TestNetCon
 Description:      Test the network connection at 3 levels (Server,Intranet,Public)
 Parameter(s):		$server = Ftp Server
					$username = Ftp UserID
					$pass = Ftp Password
					$MaxAttempt (Optional) = Maximum nbr of connection attempts
					$CurrAttempt (Optional) = Current Attempt number (this parameter is only set on recalling the function and never on the original call)
 Requirement(s):   _ConnectToFtpServer, _ConnectToIBM, _ConnectToPublic, $STDOUT_CHILD constant to be declared
 Return Value(s):  On Success - "" (nothing)
                   On Failure - Error Message
 Author(s):        Christophe Savard
#ce===============================================================================
Func _TestNetCon($server, $username, $pass , $MaxAttempt = 1 , $CurrAttempt = 1)
	If @Compiled = 0 Then ConsoleWrite("Connection Test Nbr : " & $CurrAttempt & "/" & $MaxAttempt & @CRLF)
	If ProcessExists("artbcast.exe") Then Return "" ; Already connected to an IBM Network (DCT)
	
	$LANConnected=Call("_ConnectToLan","9.64.163.21", $MaxAttempt)
	If Not $LANConnected And $ServerTest = 1 Then
		Return $ServerIsOn ; You're connected to local lan... Therefore problem comes from the Ftp Server
	ElseIf $LANConnected Then
		Return $LANConnected
	EndIf
	
	$PUBLICConnected=Call("_ConnectToPublic","www.google.com",$MaxAttempt); Not connected to IBM intranet => Connection to public network must be tested
	If Not $PUBLICConnected  Then Return $LANConnected ; Connected to public network... Therefore the problem comes form local LAN
	
	Return $PUBLICConnected ; You're not conneted at all
EndFunc
#cs===============================================================================
 Function Name:    _ConnectToLan
 Description:      Test the network connection to local LAN/Intranet
 Parameter(s):     $IP - A valid IP address or Hostname
 Requirement(s):   $STDOUT_CHILD constant to be declared
 Return Value(s):  On Success - "" (nothing)
                   On Failure - Error Message
 Author(s):        Christophe Savard
#ce===============================================================================
Func _ConnectToLan($IP,$MaxAttempt = 1 , $CurrAttempt = 1)
	Local $Connected,$Foo
	$Foo=Run(@ComSpec & " /c ipconfig /all", @SystemDir, @SW_HIDE,$STDOUT_CHILD)  ; Ping to check the private network connection
	
	While 1
		$StdOutLine = StdoutRead($Foo)
		If @error Then ExitLoop
		If Not StringInStr($StdOutLine,$IP) Then ContinueLoop ; Put here the "private" IP address to test
		$Connected="YES"
	WEnd
	
	If Not $Connected Then ; Not connected to the specific network
		If StringInStr($Language,"FR",2) Then
			$Msg="Vous n'êtes probablement pas connecté à votre réseau local..." & @CRLF & "Veuillez vérifier et essayer de nouveau !"
		ElseIf StringInStr($Language,"EN",2) Then
			$Msg="You're probably not connected to your LAN..." & @CRLF & "Please verify and try again !"
		Else;If StringInStr($Language,"xx",2)
			; Put additional language's message here...
		EndIf
		
		If $MaxAttempt > 1 And $CurrAttempt < $MaxAttempt Then ; User asked for more than one attempt and the max nbre of attempts is not achieved
			$CurrAttempt += 1 ; Increments by 1 the current attempt counter
			_ConnectToLan($IP,$MaxAttempt, $CurrAttempt); Run the function again
		EndIf
		
		Return $Msg
	EndIf
EndFunc
#cs===============================================================================
 Function Name:    _ConnectToPublic
 Description:      Test the network connection to public network (Internet)
 Parameter(s):     $IP - A valid IP address or Hostname
 Requirement(s):   $STDOUT_CHILD constant to be declared
 Return Value(s):  On Success - "" (nothing)
                   On Failure - Error Message
 Author(s):        Christophe Savard
#ce===============================================================================
Func _ConnectToPublic($IP,$MaxAttempt = 1 , $CurrAttempt = 1)
	Local $Connected,$Foo
	$Foo=Run(@ComSpec & " /c ping.exe " & $IP, @SystemDir, @SW_HIDE,$STDOUT_CHILD) ; Ping to check the "Public" network connection
	While 1
		$StdOutLine = StdoutRead($Foo)
		If @error Then ExitLoop
		If StringInStr($StdOutLine,"Ping Request could not find") > 0 Then ContinueLoop
		$Connected="YES"
		ExitLoop
	WEnd
	If Not $Connected Then ; Not connected to the specific network
		If StringInStr($Language,"FR",2) Then
			$Msg="Aucune connexion réseau détectée..." & @CRLF & "Veuillez vérifier et essayer de nouveau !"
		ElseIf StringInStr($Language,"EN",2) Then
			$Msg="No network connection detected..." & @CRLF & "Please verify and try again !"
		Else;If StringInStr($Language,"xx",2)
			; Put additional language's message here...
		EndIf
		
		If $MaxAttempt > 1 And $CurrAttempt < $MaxAttempt Then ; User asked for more than one attempt and the max nbre of attempts is not achieved
			$CurrAttempt += 1 ; Increments by 1 the current attempt counter
			_ConnectToPublic($IP,$MaxAttempt, $CurrAttempt); Run the function again
		EndIf
		
		Return $Msg
	EndIf
EndFunc
#cs===============================================================================
 Function Name:    AutoMaj
 Description:      Allow a file to replace itself (AutoUpdate) and restart if required
				   creating a ".bat" file in the @TempDir which performs :
						- Delete the current script
						- Loop until script does not exists anymore
						- Rename the "scriptname.tmp" in "scriptname.exe"
						- Restart the script if required.
						- Deletes itself
					Runs the ".bat" file and exits immediately.
 Parameter(s):     $FileToRename : "scriptname.tmp"
				   $NewFileName  : "scriptname.exe"
				   $Restart - If the file is an application and you want it to restart automatically
 Requirement(s):   Nonne
 Return Value(s):  None
 Author(s):        Christophe Savard
#ce===============================================================================
Func AutoMaj($FileToRename,$NewFileName,$Restart)
	$SC_File = @TEMPDIR & "\automaj.bat"
    FileDelete($SC_File)
    $SC_batch = 'loop:' & @CRLF & _
	'del "' & @ScriptFullPath & '"'  & @CRLF & _
    'if exist "' & @ScriptFullPath & _
    '" goto loop' & @CRLF & _
	'ren "'  & $FileToRename & '" ' & $NewFileName & @CRLF & _
	'del "' & $FileToRename & '"'  & @CRLF
	If $Restart = "YES" Then $SC_batch = $SC_batch & '"' & @ScriptFullPath & '" ' & '"' & "RESTART" & '"' & @CRLF
	$SC_batch = $SC_batch & 'del automaj.bat' & @CRLF
	FileWrite($SC_File,$SC_batch)
    Run($SC_File,@TEMPDIR,@SW_HIDE)
	Exit
EndFunc
#cs===============================================================================
 Function Name:    SuiCide
 Description:      Allow a file to delete itself (Uninstall)
				   creating a ".bat" file in the @TempDir which performs :
						- Delete the current script
						- Loop until script does not exists anymore
						- Delete the given directory structure
						- Delete itselft
					Runs the ".bat" file and exits immediately.
 Parameter(s):     None
 Requirement(s):   None
 Return Value(s):  None
 Author(s):        ???
#ce===============================================================================
Func SuiCide()
    $SC_File = @TEMPDIR & "\suicide.bat"
    FileDelete($SC_File)
    $SC_batch = 'loop:' & @CRLF & _
	'del "' & @ScriptFullPath & '"'  & @CRLF & _
    'ping -n 1 -w 250 zxywqxz_q' & @CRLF & _
	'if exist "' & @ScriptFullPath & _
    '" goto loop' & @CRLF & _
	'rmdir /S /Q "' & @ScriptDir & '"' & @CRLF & _
	'del suicide.bat' & @CRLF
	FileWrite($SC_File,$SC_batch)
    Run($SC_File,@TEMPDIR,@SW_HIDE)
	Exit
EndFunc

#cs===============================================================================
 Function Name:		_ProcessNT
 Description:		Suspend or Resume a process
 Parameter(s):		$iPID =PID or Process Name
 Requirement(s):		Windows XP/2003 or VISTA
 Return Value(s):	0 failure
						@error = 1 means that it failed because something errored when calling the dll
						@error = 2 means that it failed because the process was not found or is not running
					1 Success
 Author(s):			The Kandie Man
					Modified by SmOke_N (group function Suspend and Resume in one)
#ce===============================================================================
Func _ProcessNT($iPID, $iSuspend = True)
    If IsString($iPID) Then $iPID = ProcessExists($iPID)
    If Not $iPID Then Return SetError(2, 0, 0)
    Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $iPID)
    If $iSuspend Then
        Local $i_sucess = DllCall("ntdll.dll","int","NtSuspendProcess","int",$ai_Handle[0])
    Else
        Local $i_sucess = DllCall("ntdll.dll","int","NtResumeProcess","int",$ai_Handle[0])
    EndIf
    DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $ai_Handle)
    If IsArray($i_sucess) Then Return 1
    Return SetError(1, 0, 0)
EndFunc

Func _GuiCtrlSatusBarCreateProgBar ($hStatus,$PartIdx,$BarTyp)
    If @OSTYPE = "WIN32_WINDOWS" Then
        $ProgressBar = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_SMOOTH)
        $hProgress = GUICtrlGetHandle($ProgressBar)
         _GUICtrlStatusBar_EmbedControl ($hStatus, $PartIdx, $hProgress)
    Else
        $ProgressBar = GUICtrlCreateProgress(0, 0, -1, -1, $BarTyp); marquee works on Win XP and above
        $hProgress = GUICtrlGetHandle($ProgressBar)
		_GUICtrlStatusBar_EmbedControl ($hStatus, $PartIdx, $hProgress)
        If $BarTyp=$PBS_MARQUEE Then _SendMessage($hProgress, $PBM_SETMARQUEE, True, 50); marquee works on Win XP and above
    EndIf
EndFunc

Func _FileSearch($szRoot, $Szmask = "*.*", $nFlag = 7, $nOcc = 0)
		Local $hArray = $Szmask, $iRec, $iPath, $iSort
		
		Switch $nFlag
			Case 1
				$iRec = 1
				$iPath = 0
				$iSort = 0
			Case 2
				$iRec = 0
				$iPath = 1
				$iSort = 0
			Case 3
				$iRec = 1
				$iPath = 1
				$iSort = 0
			Case 4
				$iRec = 0
				$iPath = 0
				$iSort = 1
			Case 5
				$iRec = 1
				$iPath = 0
				$iSort = 1
			Case 6
				$iRec = 0
				$iPath = 1
				$iSort = 1
			Case Else
				$iRec = 1
				$iPath = 1
				$iSort = 1
		EndSwitch
		If NOT IsArray($hArray) Then $hArray = StringSplit($hArray, '|')

		Local $Hfile = 0, $F_List = ''
		$szBuffer = ""
		$szReturn = ""
		$szPathlist = "*"
		For $I = 1 To Ubound($hArray)-1
			$szMask = $hArray[$I]
			If NOT StringInStr ($Szmask, "\") Then
				$szRoot &= ''
			Else
				$iTrim = StringInStr ($Szmask, "\",0,-1)
				$szRoot &= StringLeft ($Szmask, $iTrim)
				$Szmask = StringTrimLeft ($Szmask, $iTrim)
			EndIf

			If $iRec = 0 Then
				$Hfile = FileFindFirstFile ($szRoot & $szMask)
				If $Hfile >= 0 Then
					$szBuffer = FileFindNextFile ($Hfile)
					While NOT @Error
						If $iPath = 1 Then $szReturn &= $szRoot
						If $szBuffer <> "." AND $szBuffer <> ".." Then $szReturn &= $szBuffer & "*"
						$szBuffer = FileFindNextFile ($Hfile)
					Wend
					FileClose ($Hfile)
				EndIf
			Else
				While 1
					$Hfile = FileFindFirstFile ($szRoot & "*.*")
					If $Hfile >= 0 Then
						$szBuffer = FileFindNextFile ($Hfile)

						While NOT @Error
						If $szBuffer <> "." AND $szBuffer <> ".." AND StringInStr (FileGetAttrib ($szRoot & $szBuffer), "D") Then _
							$szPathlist &= $szRoot & $szBuffer & "*"
							$szBuffer = FileFindNextFile ($Hfile)
						Wend

						FileClose ($Hfile)
					EndIf
					
					If StringInStr ($szReturn, $Szmask) > 0 AND $nOcc = 1 Then
						$szRoot = ''
						ExitLoop
					EndIf
					
					$Hfile = FileFindFirstFile ($szRoot & $szMask)
					
					If $Hfile >= 0 Then
						$szBuffer = FileFindNextFile ($Hfile)
						While NOT @Error
							If $iPath = 1 Then $szReturn &= $szRoot
							If $szBuffer <> "." AND $szBuffer <> ".." Then $szReturn &= $szBuffer & "*"
							$szBuffer = FileFindNextFile ($Hfile)
						Wend
						FileClose ($Hfile)
					EndIf
					
					If $szPathlist == "*" Then ExitLoop
					$szPathlist = StringTrimLeft ($szPathlist, 1)
					$szRoot = StringLeft ($szPathlist, StringInStr ($szPathlist, "*") - 1) & "\"
					$szPathlist = StringTrimLeft ($szPathlist, StringInStr ($szPathlist, "*") - 1)
				Wend
			EndIf
		Next
		If $szReturn = "" Then
			Return 0
		Else
			;$szReturn = StringReplace($szReturn,'\', '')
			$F_List = StringSplit (StringTrimRight ($szReturn, 1), "*")
			;If $iSort = 1 Then _ArraySort($F_List)
			Return $F_List
		EndIf
EndFunc ;<===> _FileSearch()
	
Func TextSplash($Msg)
	SplashTextOn($Title,$Msg,500,80,-1,-1,0+16+32,"",10,300)
	WinActivate($Title,$Msg)
EndFunc

Func EndScript ($Progress="")
	$ExitMethod=@exitMethod
	If $ExitMethod="2" Or $ExitMethod="3" Or $ExitMethod="4" Then
		If StringInStr($Language,"EN",2) Then
			$Msg="Closing application, please wait..."
		ElseIf StringInStr($Language,"FR",2) Then
			$Msg="Fermeture de l'application, veuillez patienter..."
		;If StringInStr($Language,"xx",2) Then
		
		EndIf
		If $Progress Then
			ProgressOn($Title,$MainText,$Msg)
			ProgressSet(100,$Msg,$MainText)
			Sleep(250)
			ProgressSet(75,$Msg,$MainText)
			Sleep(250)
			ProgressSet(50,$Msg,$MainText)
			Sleep(250)
			ProgressSet(25,$Msg,$MainText)
			Sleep(250)
			ProgressSet(0,$Msg,$MainText)
			Sleep(250)
		EndIf
	EndIf
	Exit
EndFunc

Func _INetBrowse($s_URL, $i_OPT = 2)
    Switch $i_OPT
        Case 0
        ;drawback: doesnt work on urls with "&"
            RunWait(@comspec & ' /c start ' & $s_URL, @WorkingDir, @SW_HIDE)
            return 1
        Case 1
        ;thx to sykes <---------------------------------------------
            RunWait("rundll32.exe url.dll,FileProtocolHandler " & $s_URL, @WorkingDir)
            Return 1
        Case 2
        ;prefered 1
            DllCall("Shell32.dll", "int", "ShellExecute", "hwnd", 0, "str", 'open', "str", $s_URL, "str", '', "str", @WorkingDir, "int", 10)
            return 1
        Case 3
        ;prefered 2
            $o_SA = ObjCreate('Shell.Application')
            $o_SA.Open($s_URL)
            return 1
    EndSwitch
    Return 0
EndFunc  ;==>_INetBrowse

Func _INetSmtpMailCom($SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress, $s_Subject = "", $as_Body = "", $s_AttachFiles = "", $s_CcAddress = "", $s_BccAddress = "", $s_Username = "", $s_Password = "",$IPPort=25, $ssl=0)
	$objEmail = ObjCreate("CDO.Message")
	$objEmail.From = '"' & $s_FromName & '" <' & $s_FromAddress & '>'
	$objEmail.To = $s_ToAddress
	Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
	Global $oMyRet[2]
	Local $i_Error = 0
	Local $i_Error_desciption = ""
	If $s_CcAddress <> "" Then $objEmail.Cc = $s_CcAddress
	If $s_BccAddress <> "" Then $objEmail.Bcc = $s_BccAddress
	$objEmail.Subject = $s_Subject
	If StringInStr($as_Body,"<") and StringInStr($as_Body,">") Then
		$objEmail.HTMLBody = $as_Body
	Else
		$objEmail.Textbody = $as_Body & @CRLF
	EndIf
	If $s_AttachFiles <> "" Then
		Local $S_Files2Attach = StringSplit($s_AttachFiles, ";")
		For $x = 1 To $S_Files2Attach[0]
			$S_Files2Attach[$x] = _PathFull ($S_Files2Attach[$x])
			If FileExists($S_Files2Attach[$x]) Then
				$objEmail.AddAttachment ($S_Files2Attach[$x])
			Else
				$i_Error_desciption = $i_Error_desciption & @CRLF & 'File not found to attach: ' & $S_Files2Attach[$x]
				SetError(1)
				Return 0
			EndIf
		Next
	EndIf
		
	$objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
	$objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = $SmtpServer
	$objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = $IPPort
	;Authenticated SMTP
	If $s_Username <> "" Then
		$objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
		$objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusername") = $s_Username
		$objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendpassword") = $s_Password
	EndIf
	If $Ssl Then
		$objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True
	EndIf
	;Update settings
	$objEmail.Configuration.Fields.Update
	$objEmail.Send ; ***** ENVOI DU MAIL *****
	
	If $oMyRet[0] <> "" then ; Erreur d'envoi du mail
		SetError(2)
		Return @error
	Else ; Mail envoyé avec succès
		Return "" ; 
	EndIf
	
EndFunc ;==>_INetSmtpMailCom

Func MyErrFunc()
	$HexNumber = Hex($oMyError.number, 8)
	$oMyRet[0] = $HexNumber
	$oMyRet[1] = StringStripWS($oMyError.description,3)
	;ConsoleWrite("### COM Error !  Number : " & $HexNumber & "   ScriptLine : " & $oMyError.scriptline & "   Description : " & $oMyRet[1])
	SetError(1); something to check for when this function returns
	Return
EndFunc ;==>MyErrFunc

Func _GetLastError()
    Local $aResult
    $aResult = DllCall("Kernel32.dll", "int", "GetLastError")
    Return $aResult[0]
EndFunc   ;==>_GetLastError

Func _FormatMessage($iFlags, $pSource, $iMessageID, $iLanguageID, $pBuffer, $iSize, $vArguments)
    Local $aResult
    $aResult = DllCall("Kernel32.dll", "int", "FormatMessageA", "int", $iFlags, "hwnd", $pSource, _
            "int", $iMessageID, "int", $iLanguageID, "ptr", $pBuffer, "int", $iSize, _
            "ptr", $vArguments)
    Return $aResult[0]
EndFunc   ;==>_FormatMessage

Func _GetLastErrorMessage()
    Local $pBuffer, $rBuffer, $ErrCode
    $rBuffer = DllStructCreate("char[4096]")
    $pBuffer = DllStructGetPtr($rBuffer)
	$Errcode = _GetLastError()
    _FormatMessage($FORMAT_MESSAGE_FROM_SYSTEM, 0, $ErrCode, 0, $pBuffer, 4096, 0)
    Return "Error : " & $ErrCode & @CRLF & DllStructGetData($rBuffer, 1)
EndFunc   ;==>_GetLastErrorMessage

#cs===============================================================================
 Function Name:    _MsgBoxCustom
 Description:      Allow to modify standard Msgbox text for buttons
				   - Automatically sets the number of buttons flag
Parameter(s):		$iFlag = Standard flag (see autoit help) except buttons flag as this flag is function of the buttons nbr.
					$STitle = Title of the Message box
					$SText = Text of the Message box
					$sButText = Text of the buttons (if more than one pipe ["|"] must be used as separator... ex : "Ja|Nein|Vielleicht")
 Requirement(s):	None
 Return Value(s):	An array as follow
					- $Array[0] = Nbr of buttons
					- $Array[1] = Text for Button 1
					- $Array[2] = Text for Button 2 ===> Only if a 2 buttons box is required
					- $Array[3] = Text for Button 3 ===> Only if a 3 buttons box is required
					- $Array[n] = Where "n" is the last element of the array (index is not always the same, it's buttons depending).
								  Return code of the MsgBox Autoit function 
					
 Author(s):			Don't remember (this function is based on a function found on the forum but I can't find the topic again and don't remember the original name)
					If the author reads this topic, he just can leave a message and I'll include his name...
					Modified by : Christophe Savard (France)
					Modifcations :
						- $ButText replace the 3 parameter for Button 1 to 3
						- Test and "clean", if necessary, the $ButText parameter (eliminate leading/trailing and doubles white space)
						handling several errors and diplaying a formated message instead or only returning an error code.
						- Returns an array with extendend informations instead of the MsgBox function return code only.
#ce===============================================================================
Func _MsgBoxCustom($iFlag, $sTitle, $sText, $sButText, $iMBTimeOut = 0, $xMBpos = "", $yMBpos = "")
    If Not IsNumber ($iFlag) then
        Seterror (1 )
		MsgBox(0,"Erreur","Error : " & @error & @CRLF & "Flag is missing.")
        Return -1
    ElseIf Not IsNumber ($iMBTimeOut) then
        Seterror (2 )
		MsgBox(0,"Erreur","Error : " & @error & @CRLF & "Timout must be a number.")
        Return -1
    ElseIf $xMBpos <> "" and IsNumber ($xMBpos) = 0 then
        Seterror (3 )
		MsgBox(0,"Erreur","Error : " & @error & @CRLF & "Positioning variable " & '"' & "x" & '"' & " error.")
        Return -1
    ElseIf $yMBpos <> "" and IsNumber ($yMBpos) = 0 then
        Seterror (4 )
		MsgBox(0,"Erreur","Error : " & @error & @CRLF & "Positioning variable " & '"' & "y" & '"' & " error.")
        Return -1
	ElseIf $sButText = "" Then
		SetError (5)
		MsgBox(0,"Erreur","Error : " & @error & @CRLF & "A message text is required.")
		Return -1
	Endif
	
	$sButText = StringStripWS($sButText,7) ; removes leading/Trailing and doubles spaces between words
	If StringInStr($sButText,'||',0,1) Then
		SetError (6)
		MsgBox(0,"Erreur","Error : " & @error & @CRLF & "Format separator error.")
		Return -1
	ElseIf StringRight($sButText,1)="|" Or StringLeft($sButText,1) = "|" Then
		SetError (7)
		MsgBox(0,"Erreur","Error : " & @error & @CRLF & "No Leading/trailing separator is allowed.")
		Return -1
	EndIf
		
	$sButton = StringSplit($sButText,"|",1) ; Splits the $sButton content to determine the required number of buttons and the text for the each one
	If $sButton[0]=1 Then ; Defines the button flag depending of the nbr of buttons => Therefore possible return codes are limited to 1, 6, 7 and 2
		$ButFlag = 0 ; Flag for 1 button (ret code 1)
	ElseIf $sButton[0]=2 Then
		$ButFlag = 4 ; Flag for 2 buttons (Ret code 6 or 7)
	Else
		$ButFlag = 3 ; Flag for 3 buttons (Ret code 6 or 7 and 2)
	EndIf
	
	#region external script 
    Local $MBFile = FileOpen(@TempDir & '\MiscMMB.txt', 2)
	Local $MBLine1 = 'Opt("TrayIconHide",1)'
    Local $MBLine2 = 'Opt("WinWaitDelay", 0)'
    Local $MBLine3 = 'WinWait("' & $sTitle & '")'
    Local $MBLine4 = 'ControlSetText("' & $sTitle & '", "", "Button1", "' & $sButton[1] & '")'
    
	If $sButton[0] = 2 Then
		Local $MBLine5 = 'ControlSetText("' & $sTitle & '", "", "Button2", "' & $sButton[2] & '")'
	ElseIf $sButton[0] = 3 Then
		Local $MBLine5 = 'ControlSetText("' & $sTitle & '", "", "Button2", "' & $sButton[2] & '")'
		Local $MBLine6 = 'ControlSetText("' & $sTitle & '", "", "Button3", "' & $sButton[3] & '")'
	EndIf
    Local $MBline7 = 'WinMove("' & $sTitle & '", ""' & ', ' & $xMBpos & ', ' & $yMBpos & ')'
    Local $MBline8 = '$pos = WingetPos("' & $sTitle & '", "")'
    Local $MBline9 = 'WinMove("' & $sTitle & '", ""' & ', ' & $xMBpos & ',$pos[1])'
    Local $MBline10 ='WinMove("' & $sTitle & '", ""' & ', $pos[0], ' & $yMBpos & ')'
	
	If $sButton[0] = 1 Then ; 1 Button
        FileWrite(@TempDir & '\MiscMMB.txt',$MBLine1 & @CRLF & $MBLine2 & @CRLF & $MBLine3 & @CRLF & $MBLine4)
    ElseIf $sButton[0] = 2 Then ; 2 buttons
        FileWrite(@TempDir & '\MiscMMB.txt',$MBLine1 & @CRLF & $MBLine2 & @CRLF & $MBLine3 & @CRLF & $MBLine4 & @CRLF & $MBLine5)
    ElseIf $sButton[0] = 3 Then ; 3 buttons
        FileWrite(@TempDir & '\MiscMMB.txt',$MBLine1 & @CRLF & $MBLine2 & @CRLF & $MBLine3 & @CRLF & $MBLine4 & @CRLF & $MBLine5 & @CRLF & $MBLine6)
    EndIf
	
	If $xMBpos <> "" and $yMBpos <> "" then ; Only if the custom MsgBox is not at the same position than to original
		FileWriteLine(@TempDir & '\MiscMMB.txt', @crlf & $MBLine7)
	ElseIf $xMBpos <> "" and $yMBpos = "" then
		FileWriteLine (@TempDir & '\MiscMMB.txt', @crlf & $MBLine8)
		FileWriteLine (@TempDir & '\MiscMMB.txt', @crlf & $MBLine9)
	Elseif $xMBpos = "" and $yMBpos <> "" then
		FileWriteLine (@TempDir & '\MiscMMB.txt', @crlf & $MBLine8)
		FileWriteLine (@TempDir & '\MiscMMB.txt', @crlf & $MBLine10)
	Endif
    #endregion external script 
	
    $MBPID1 = Run(@AutoItExe & ' /AutoIt3ExecuteScript ' & EnvGet('TEMP') & '\MiscMMB.txt') ; Run the script which will wait for the MsgBox to handle
    $MBBox = MsgBox(262144 + $iFlag + $ButFlag, $sTitle, $sText, $iMBTimeOut) ; Run the native MsgBox Autoit function
    FileClose($MBFile)
    Do
		FileDelete(@TempDir & '\MiscMMB.txt')
    Until Not FileExists(@TempDir & '\MiscMMB.txt')
	
	ReDim $sButton [UBound($sButton)+1] ; Redim the $Sbutton to host the return code of the Msgbox Function
	$sButton [UBound($sButton)-1] = $MBBox ; Adds the return code from Msgbox autoit function to the array to return
	Return $sButton  ; Returns
EndFunc ;Func _MsgBoxCustom
