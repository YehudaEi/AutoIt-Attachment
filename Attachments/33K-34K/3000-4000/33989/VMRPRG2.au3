;5/15/2008. The following code calculates a date suffix for the Vantage MRP log file then logs into Vantage, runs MRP regeneration, and logsout.
;MRP Regeneration is as of this writing a 2.5 hour process.
;Added code to log start and end time to a file and send an email with same. 5/21/2008.

#include <Date.au3>
#include <INet.au3>
#include <WinWaitActive.au3>

Dim $FileName
Dim $StartTime

;Assign $FileName the destination file that logs the start and end times of this script
$FileName = "C:\Documents and Settings\Administrator.Stamp\My Documents\MRPLog"


$StartTime =  _DateTimeFormat(_NowCalc(),1) & " " & _DateTimeFormat(_NowCalc(),5)
;Opening the file MRPLog and appending the start date and time to the file
FileOpen($FileName,1)

FileWrite($FileName,@CRLF)
FileWrite($FileName,"Start MRP " & $StartTime) 

;For use in the email


;Calculating date suffix for MRPLog file name in Vantage
Dim $logdate1
Dim $logdate2
Dim $logdate3
Dim $logtime1
Dim $logtime2
Dim $logtime3
Dim $logyear
Dim $logfiledate
Dim $var
Dim $EndTime

$var = StringInStr(_Now(),"/",0,2) + 1
$logyear = StringMid(_Now(),$var,4)				;Extracting 4 digit year from today's date

;Extract 1 or 2 digit month from today's date
If StringInStr(_Now(),"/") = 2 Then				;Looking for first occurrence of /
	$logdate1 = 0 & StringMid(_Now(),1,1)		;If / in position 2 Extract first character only and prefix with 0
Else
	$logdate1 = StringMid(_Now(),1,2)			;Extract 1st and 2nd character
EndIf

;Extract 1 or 2 digit day from today's date. If 1st  occurrence of / is position 2 and 2nd occurence of / is position 4 Or
;If 1st  occurrence of / is position 3 and 2nd occurence of / is position 5 then prefix the day with a 0. 
If (StringInStr(_Now(),"/") = 2  and StringInStr(_Now(),"/",0,2) = 4) or (StringInStr(_Now(),"/") = 3  and StringInStr(_Now(),"/",0,2) = 5) Then
	If StringInStr(_Now(),"/",0,2) = 4 then		;If 2nd occurrence of / is position 4
		$logdate2 = 0 & StringMid(_Now(),3,1)
	Else
		$logdate2 = 0 & StringMid(_Now(),4,1)
	EndIf
Else
	If StringInStr(_Now(),"/",0,2) = 5 then
		$logdate2 = StringMid(_Now(),3,2)
	Else
		$logdate2 = StringMid(_Now(),4,2)
	EndIf
EndIf

;Extracting the 1 or 2 digit hour from the current time(24 hour format)
If StringInStr(_DateTimeFormat(_NowCalc(),5),":") = 2 Then			;If the 1st occurrence of : is position 2
	$logtime1 = 0 & StringMid(_DateTimeFormat(_NowCalc(),5),1,1)
Else
	$logtime1 = StringMid(_DateTimeFormat(_NowCalc(),5),1,2)
EndIf

;Extracting the 2 digit minute from the current time(24 hour format)
If StringInStr(_DateTimeFormat(_NowCalc(),5),":") = 2 Then
	$logtime2 = StringMid(_DateTimeFormat(_NowCalc(),5),3,2)
Else
	$logtime2 = StringMid(_DateTimeFormat(_NowCalc(),5),4,2)
EndIf

;Extracting the 2 digit second from the current time(24 hour format)
If StringInStr(_DateTimeFormat(_NowCalc(),5),":") = 2 Then
	$logtime3 = StringMid(_DateTimeFormat(_NowCalc(),5),6,2)
Else
	$logtime3 = StringMid(_DateTimeFormat(_NowCalc(),5),7,2)
EndIf

$logfiledate = $logdate1 & $logdate2 & $logyear & $logtime1 & $logtime2 & $logtime3

;Write $logfiledate to log file for debug purposes
FileOpen($FileName,1)
FileWrite($FileName,@CRLF)
FileWrite($FileName,"File name " & $logfiledate & " created " & _DateTimeFormat(_NowCalc(),1) & " " & _DateTimeFormat(_NowCalc(),5)) 
;End Calculation


;Dim $LogQues

;Login to Vantage and Run MRP Regen
Run("V:\mfgsys61\mfg.exe V:\mfgsys61\Vantage.MFG")
_WinWaitActive("System Login")
send("mrpuser{TAB}runmrp{ENTER}")		;Log into Vantage
_WinWaitActive("Vantage - Dubuque Stamping and Manufacturing - Main Plant")		;Main Window. Code added 7/7/2008.
;sleep(2500)
send("{DOWN}{ENTER}")					;Production Management
sleep(1000)
send("{DOWN}{ENTER}")					;Material Requirements Planning
sleep(1000)
send("{DOWN}{ENTER}")					;General Operations
sleep(1000)
send("{DOWN}{ENTER}")					;Process MRP
_WinWaitActive("Process MRP")
send("{RIGHT}{TAB 3}")					;Move to Regeneration and then to MRP log file window
sleep(1000)
send("MRPLog" & $logfiledate)			;MRPLog suffixed with date and time calcualted above
sleep(2500)
send("{TAB}{ENTER}")					;Tab to OK and Enter - Launch MRP
If WinActive("Question") = 0 Then		;Is the Window "View Log Yes/No" Active. If not activate it.
	WinActivate("Question")
EndIf
_WinWaitActive("Question")
send("{TAB}{ENTER}")					;View Log File? Tab to No and Enter
_WinWaitActive("Information")
send("{ENTER}")							;MRP complete. Enter.
sleep(1000)
Send ("!{F4}")							;Command to exit Vantage
_WinWaitActive("Vantage")
Send("{TAB}{ENTER}")					;Exit Vantage? Tab to Yes. Enter.


$EndTime =  _DateTimeFormat(_NowCalc(),1) & " " & _DateTimeFormat(_NowCalc(),5)
;Open MRPlog file and append the ending date and time to the file
FileOpen($FileName,1)

FileWrite($FileName,@CRLF)
FileWrite($FileName,"End MRP " & $EndTime) 

;Begin Send email to MJD
;Settng varaibles for email function
$s_SmtpServer = "192.168.0.12"
$s_FromName = "MHoneywell"
$s_FromAddress = "MHoneywell"
$s_ToAddress = "MikeDunn@dbqstamp.com"
$s_Subject = "MRP Log"
Dim $as_Body[3]
;Dim $err
;Dim $Response
$as_Body[0] = "MRP Started " & $StartTime & @CRLF
$as_Body[1] = "MRP Finished. " & $EndTime & @CRLF
$as_Body[2] = "AutoIT MRP Script Ended " & _DateTimeFormat(_NowCalc(),1) & " " & _DateTimeFormat(_NowCalc(),5)

;Send email function. The value of $Response indicates success or failure
$Response = _INetSmtpMail($s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress, $s_Subject, $as_Body)
$err = @error
;End Send email to MJD

;Begin Send email to Mitch
;Settng varaibles for email function
$s_SmtpServer = "192.168.0.12"
$s_FromName = "MHoneywell"
$s_FromAddress = "MHoneywell"
$s_ToAddress = "mitch@dbqstamp.com"
$s_Subject = "MRP Log"
Dim $as_Body[3]
;Dim $err
;Dim $Response
$as_Body[0] = "MRP Started " & $StartTime & @CRLF
$as_Body[1] = "MRP Finished. " & $EndTime & @CRLF
$as_Body[2] = "AutoIT MRP Script Ended " & _DateTimeFormat(_NowCalc(),1) & " " & _DateTimeFormat(_NowCalc(),5)

;Send email function. The value of $Response indicates success or failure
$Response = _INetSmtpMail($s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress, $s_Subject, $as_Body)
$err = @error
;End Send email to Mitch

;Want to know when script actually finishes
FileOpen($FileName,1)

FileWrite($FileName,@CRLF)
FileWrite($FileName,"AutoIT MRP Script Ended " & _DateTimeFormat(_NowCalc(),1) & " " & _DateTimeFormat(_NowCalc(),5)) 

;Used for testing
;If $Response = 1 Then	
	;MsgBox(0, "Success!", "Mail Sent")
;Else
	;MsgBox(0, "Error!", "Mail failed with error code " & $err)
;EndIf




