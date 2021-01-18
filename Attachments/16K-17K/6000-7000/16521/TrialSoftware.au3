#Region converted Directives from D:\My Documents\AutoITscripts\DriveTester\TrialSoftware.au3.ini
#AutoIt3Wrapper_aut2exe=C:\Program Files\AutoIt3\Aut2Exe\Aut2Exe.exe
#AutoIt3Wrapper_outfile=D:\My Documents\AutoITscripts\DriveTester\TrialSoftware.exe
#AutoIt3Wrapper_Res_Comment=                                               
#AutoIt3Wrapper_Res_Description=AutoIt v3 Compiled Script
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=n
#AutoIt3Wrapper_Run_AU3Check=4
#EndRegion converted Directives from D:\My Documents\AutoITscripts\DriveTester\TrialSoftware.au3.ini
;
; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.2.4.9 
; Author:         Chris Lambert
;
; Script Function: trial/licensed software system
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <date.au3>
#include <string.au3>

Global $Debugit = 0
Local $securityCodeEncryptionKey = "MyPa55w0rd" ;this must match the key generator
Global $mac
Global $Generate
Global $restore
Global $RequiresRegCode = 1 ;if set to 1 then software will prompt for a registration code if set to 0 then no registration code is required but can still be ran as a time limited trial

If $RequiresRegCode then 
	$mac = StringUpper (StringReplace (_GetMAC(),":","") & StringRight ( Hex(@mon),1)); this makes the mac address only valid during this month or registration, so if they discover the fake dll and delete it, the code only registers during this month of cousre they could figure on putting it back to the original registration month
	$Generate = StringRight ($mac,5)
	$restore = StringUpper (_StringEncrypt (1, $Generate, $securityCodeEncryptionKey , 1 ))
EndIf

Global $myFakeDll = @Windowsdir & "\TMy.dll" ; I suggest using a prefix of T for Trial software in the dllname and be sure it's not a dll name that is going to already exist you could hide it in the windows directory or anywhere else really
Global $trialPeriod = 14 ;days (use -1 if not trial software just regkey licenced)
Global $ShowEvaluationWarning = 1 ;1 displays an evaluation warning during checking the authorisation, 0 will not show a warning
Global $applicationName = "My App"
Global $dllEncKey = "aBc" ;you can change this to whatever you like it is the ini encryption if made too long and it takes longer to read and write
Global $dlliniSection = Encrypt("iniSectionName");you can change this too if you really want to

If NOT FileExists ($myFakeDll) then 
	EnterNewCode()
	FileSetAttrib($myFakeDll,"+HS")
EndIf

$validation = CheckValidation()

;============================================Main app Starts here============================================

If $validation <> -1 then 
	Msgbox(0,"","This is the main application start point" & @crlf & "If you can see this then you have a successfully registered application" & @crlf & "You have " & $validation & " Days left to evaluate this software")
Else
	Msgbox(0,"","This is the main application start point" & @crlf & "If you can see this then you have a successfully registered application")	
EndIf

;Your code
















;============================================Main app Finishes here============================================


Func EnterNewCode()
	ClipPut ($mac)
	If $RequiresRegCode then 
		$entered = InPutBox ("Register", "This software is for trial please telephone" & @crlf & "00000 0000000 to obtain a registration code" & @crlf & "Please quote the following Code " & @crlf & @crlf & $mac & @crlf & @crlf & "Enter the unlock code below","","",-1,200 )
		If @error = 1 then Exit ;CANCEL WAS PRESSED
		Else
			$entered = $restore
		EndIf
		
	If $entered = $restore then 
		If $RequiresRegCode then MsgBox (262144,$applicationName,"Successfully Registered")
		
		IniWrite ($myFakeDll,$dlliniSection,Encrypt ("DecodeKey"),Encrypt ($restore))
		IniWrite ($myFakeDll,$dlliniSection,Encrypt ("GeneratedMac"),Encrypt ($Mac))
		
		If $trialPeriod <> -1 then
			IniWrite ($myFakeDll,$dlliniSection,Encrypt ("RegDate"),Encrypt (_NowCalcDate()))
			$sysprep = _DateAdd ( "D", $trialPeriod, _NowCalcDate() )
			IniWrite ($myFakeDll,$dlliniSection,Encrypt ("FinalDate"),Encrypt ($sysprep))
			IniWrite ($myFakeDll,$dlliniSection,Encrypt ("LastRunDate"),Encrypt (_NowCalcDate()))
			IniWrite ($myFakeDll,$dlliniSection,Encrypt ("Count"),Encrypt (0))
		endif

	Else 
		MsgBox (262144,"Error","Registration code is incorrect")
		Exit
		
	EndIf
EndFunc ;==> EnterNewRegCode()

	
	

Func CheckValidation()	
	
		If $RequiresRegCode then 
			$RecordedMacCheck = StringLeft (StringRight (Decrypt (IniRead ($myFakeDll,$dlliniSection,Encrypt ("GeneratedMac"),"Eric")),5),4)
			$MacCheck = StringLeft (StringRight ($mac,5),4) 
			If $RecordedMacCheck <> $MacCheck then 
				Debug ("Recorded Mac = " & $RecordedMacCheck)
				Debug ("Macaddress = " & $MacCheck )
				Debug ("The Mac code didn't match")
				If FileExists ($myFakeDll) then FileDelete($myFakeDll)
				EnterNewCode()
				Return -1
			EndIf
		EndIf
		
		If $trialPeriod = -1 then return -1
	
		If $ShowEvaluationWarning then Splashtexton ($applicationName,@crlf & "This is evaluation software",250,60)
		
		$finalDateCheck =  Decrypt ( IniRead ($myFakeDll,$dlliniSection, Encrypt("FinalDate"),"")) 
		$RegDateCheck = Decrypt ( IniRead ($myFakeDll,$dlliniSection, Encrypt("RegDate"),"")) 
		$LastRunDateCheck =  Decrypt ( IniRead ($myFakeDll,$dlliniSection, Encrypt("LastRunDate"),"")) 
		$CountCheck = Number( Decrypt ( IniRead ($myFakeDll,$dlliniSection, Encrypt("Count"),"")) )
		
		If  _DateDiff ("D", _NowCalcDate(),$finalDateCheck) < 0 Then
			;the date is 14 days past the registration date
			Debug ("passed the " & $trialPeriod & " days Expired " &  _DateDiff ("D",$finalDateCheck, _NowCalcDate() ) )
			SplashOff()
			Msgbox (262144,$applicationName,"Evaluation Expired")
			IniWrite ($myFakeDll,$dlliniSection,Encrypt ("Count"),Encrypt ($trialPeriod + 1))
			Exit
		EndIf
		
		
		If _DateDiff ("D",$LastRunDateCheck,_NowCalcDate()) < 0 Then
			;they have changed the clock bacwards so expire
			Debug ("Clock date is set before last run date")
			SplashOff()
			Msgbox (262144,$applicationName,"Date tampering detected Evaluation Expired")
			IniWrite ($myFakeDll,$dlliniSection,Encrypt ("Count"),Encrypt ($trialPeriod + 1))
			Exit
		EndIf
		
		If $CountCheck >= $trialPeriod then ;second method for checking days used
			;trialPeriod days are up so expire
			Debug ("Count is greater than " & $trialPeriod)
			SplashOff()
			Msgbox (262144,$applicationName,"Evaluation Expired")
			Exit
		EndIf
		
		If _NowCalcDate() <> $LastRunDateCheck Then ;if the date is different to the last ran date then increase the days used by 1
			$CountCheck += 1
			Debug ("Increase the used count; Count is now " & $CountCheck)
			IniWrite ($myFakeDll,$dlliniSection,Encrypt ("Count"),Encrypt ($CountCheck))
			IniWrite ($myFakeDll,$dlliniSection,Encrypt ("LastRunDate"),Encrypt (_NowCalcDate()));log the new last run date
		EndIf
		
		If $ShowEvaluationWarning then 
			Sleep (2000)
			SplashOff()
		EndIf
		
		Return ($trialPeriod - $CountCheck)
EndFunc ;==> CheckValidation()

Func Encrypt ($string) 
	
	 Return _StringEncrypt (1, $String, $dllEncKey , 1 )
	
EndFunc ;==> Encrypt()


Func Decrypt ($String)
	
	Return _StringEncrypt (0, $String, $dllEncKey , 1 )
	
EndFunc ;==> Decrypt()

Func Debug ($var)
	
	If $Debugit then ConsoleWrite ($var & @crlf)

EndFunc;==> Debug to Scite()

Func _GetMAC($getmacindex = 1)
    $ipHandle = Run(@ComSpec & ' /c ipconfig /all', '', @SW_HIDE, 2)
	$read = ""
	Do
		$read &= StdoutRead($ipHandle)
	Until @error
	
	$read = StringStripWS($read,7)
	
    $macdashed = StringRegExp( $read , '([0-9A-F]{2}-[0-9A-F]{2}-[0-9A-F]{2}-[0-9A-F]{2}-[0-9A-F]{2}-[0-9A-F]{2})', 3)
    If Not IsArray($macdashed) Then Return 0
    If $getmacindex <  1 Then Return 0
    If $getmacindex > UBound($macdashed) Or $getmacindex = -1 Then $getmacindex = UBound($macdashed)
    $macnosemicolon = StringReplace($macdashed[$getmacindex - 1], '-', ':', 0)
    Return $macnosemicolon 
EndFunc;==>_GetMAC