#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\..\..\My Pictures\universe.ico
#AutoIt3Wrapper_Outfile=AssetCollect.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include "String.au3"
#include "ADFunctions.au3"
#include "ServiceControl.au3"
#include "array.au3"
#include "Date.au3"

;----- Customize the following constants for your needs -----
Const $statusfile = "status" & @MON & @MDAY & @YEAR & ".txt"
Const $ResultsFile = "AssetCollect" & @MON & @MDAY & @YEAR & ".csv"
Const $ScriptVersion = 1.0
Global $g_eventerror = 0 ; to be checked to know if com error occurs. Must be reset after handling.
Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc") ; Install a custom error handler
Global $psservice = @ComSpec & ' /c "' & @ScriptDir & '\psservice.exe"'
Global $recheck = ""

;------ Constant Declarantions ----------
Const $ForReading = 0
Const $ForWriting = 2
Const $ForAppending = 1
Const $LDAP_Suffix = "DC=yourcompany,DC=local"
Const $adOpenStatic = 3
Const $adLockOptimistic = 3
Const $adCmdText = "&H0001"
Const $ADS_SCOPE_SUBTREE = 2

;     Constants for the NameTranslate function.
Const $ADS_NAME_INITTYPE_GC = 3
Const $ADS_NAME_TYPE_NT4 = 3
Const $ADS_NAME_TYPE_1779 = 1

; Dim the Variables used
Dim $LogFile, $objAD_Recordset, $strDN, $strPCName, $objPC, $RecordCount, $pcc, $objAD_Command, $a_PCNames
Dim $i = 0
Dim $ErrorFile, $timenow, $start

; Initalize ;Progress bar
;ProgressOn("Asset Collect Working...", "Checking Computers", "Please wait...", 2, -2, 18)

; Establish Log File to write results to
$LogFile = FileOpen($ResultsFile, $ForWriting)
If @error = -1 Then
	MsgBox(0, "Error", "ERROR: Unable to initialize requested log file, " & $ResultsFile & ".")
	FileClose($ResultsFile)
	Exit
EndIf ;Err.Number <> 0

$ErrorFile = FileOpen("ErrorFile" & @MON & @MDAY & @YEAR & ".csv", $ForWriting)
If @error = -1 Then
	MsgBox(0, "Error", "ERROR: Unable to initialize requested Error log file.")
	FileClose($ErrorFile)
	Exit
EndIf

; Set start time in status file
FileOpen($statusfile, $ForWriting)
$now = _Now()
FileWriteLine($statusfile, "Started Collect at : " & $now)
;FileClose($statusfile)

; Prepare Active Directory and Query
Global $objConnection = ObjCreate("ADODB.Connection"); Create COM object to AD
$objConnection.ConnectionString = "Provider=ADsDSOObject"
$objConnection.Open("Active Directory Provider"); Open connection to AD
$objAD_Command = ObjCreate("ADODB.Command")
$objAD_Command.ActiveConnection = $objConnection
$objAD_Command.CommandText = "SELECT * FROM 'LDAP://DC=yourcompany,DC=local' WHERE objectClass='computer'"
$objAD_Command.Properties("Page Size") = 1000
$objAD_Command.Properties("Searchscope") = 2
$objAD_Recordset = $objAD_Command.Execute
$RecordCount = $objAD_Recordset.recordcount
; Set ;Progress bar with number of records to check
;ProgressSet($i, "Checking " & $RecordCount & " Computers", "Please wait...")

; Set Results File Headers
FileWriteLine($LogFile, "Computer Name, Ping?, OS, OS SP, OS Version, Date Changed (GMT), Date Created (GMT), Password Changed, IP Address, Tuner File?, Tuner Installed?, Tuner Service?, Trend?, TrendServer, GoverLan?, Region, AD Group, Free C: MB")
FileWriteLine($statusfile, "Working with " & $RecordCount & " computers.")

Do
	$strDN = $objAD_Recordset.Fields(0).value
	$objPC = ObjGet($strDN)
	$strPCName = ($objPC.cn)
	$pcc = $pcc + 1
	;$i = 1
	;ProgressSet($i, $pcc & " of " & $RecordCount, "Working on " & $strPCName)
	Call("InfoCollect", $strPCName, $objPC, $pcc)
	$objAD_Recordset.MoveNext()
Until $objAD_Recordset.EOF()

; re-check unavailable computers
; Set complete time for first run
;FileOpen($statusfile, $ForAppending)
$now = _Now()
FileWriteLine($statusfile, "Completed & Started Re-Check at : " & $now)
;FileClose($statusfile)
$pcc = 0

; make sure time is during working hours to capture laptops missed by midnight launch
Do
	$timenow = @HOUR & @MIN
	If $timenow > "0820" And $timenow < "1700" Then
		$start = "YES"
		ExitLoop
	Else
		$start = "No"
		Sleep(2700000)
	EndIf
Until $start = "YES"

$a_PCNames = StringSplit($recheck, ",")
If Not IsArray($a_PCNames) Then
	$a_PCNames[0] = 1
	$a_PCNames[1] = $recheck
EndIf
$RecordCount = $a_PCNames[0]

$now = _Now()
FileWriteLine($statusfile, "Re-checking " & $RecordCount & " computers, starting : " & $now)

Do
	$pcc = $pcc + 1
	$strPCName = $a_PCNames[$pcc]
	$strDN = _ADGetFQDN($strPCName)
	$objPC = ObjGet($strDN)
	;$i = 1
	;ProgressSet($i, $pcc & " of " & $RecordCount, "Rechecking " & $strPCName)
	Call("InfoCollect", $strPCName, $objPC, $pcc)
Until $pcc = $RecordCount

FileClose($LogFile)
FileClose($ErrorFile)
;ProgressOff()

Call("ResultsCleanup")

; Set complete time for full run
;FileOpen($statusfile, $ForAppending)
$now = _Now()
FileWriteLine($statusfile, "Completed : " & $now)
FileClose($statusfile)

Exit

; ********* Functions that do the actual working **********

Func InfoCollect($strPCName, $objPC, $pcc)
	
	Dim $strOS, $strOSsp, $strOSv, $strChange, $strCreate, $sTempFile, $IsAlive
	Dim $stripIP, $arrIP, $strSubnet, $pingresult, $sStart, $sEnd, $sString, $strADGROUP
	Dim $cDay, $cHour, $cMin, $cMonth, $cYear, $crDay, $crYear, $crHour, $crMin, $crMonth, $netwrkAddr
	Dim $strGroup, $Group, $Groups, $s, $sTrendService, $qTrendService, $qTunerService, $sTunerService, $lastlogon
	Dim $arrGroups[1000], $fqdn, $memberof, $strTunerPathC, $strTunerPathD, $strTunerPathE, $TunerPath, $strPwdCh, $strPwdChd
	Dim $IPSubkey, $IPkey, $keyread = "No", $r = 0, $drivespace, $Locator, $Service, $TrendServer, $hundreds
	Dim $ABCDService, $ABCSAService, $ABCRpService, $ABCLaptop, $ApplicationPkgr, $EndNode, $TheCityMain, $Test
	Dim $ABCDay, $ABCMirror, $ABCATM, $sTunerServicei, $WMITest, $psscmd, $pss_check, $sGoverLan, $qGoverLan, $ABC_Server
	Dim $services = "\HKLM\SYSTEM\CurrentControlSet\Services"
	Global $trendkey = "\\" & $strPCName & "\HKLM\SOFTWARE\TrendMicro"
	$qTunerService = 0
	$qGoverLan = 0
	$qTrendService = 0
	$sTunerService = ""
	$sTrendService = ""
	$sGoverLan = ""
	$TrendServer = "No Trend"
	
	;$hundreds = 0
	;$hundreds = $pcc / 100
	;If IsInt($hundreds) Then
		; Set status on each 100 with time
		;FileOpen($statusfile, $ForAppending)
	;	$now = _Now()
	;	FileWriteLine($statusfile, "   " & $pcc & " at : " & $now)
		;FileClose($statusfile)
	;EndIf
	
	If Not Mod($pcc,50) Then
		$now = _Now()
		FileWriteLine($statusfile, "   " & $pcc & " at : " & $now)
	EndIf
	
	;MsgBox(0, "PC Name", $strPCName)
	$fqdn = $objPC.distinguishedName
	$strOS = $objPC.operatingSystem
	$strOSsp = $objPC.operatingSystemServicePack
	$strOSv = $objPC.operatingSystemVersion
	$strChange = $objPC.whenChanged
	$strCreate = $objPC.whenCreated
	$strPwdCh = $objPC.passwordLastChanged
	;$lastlogon = $objPC.LastLogon
	;$netwrkAddr = $objPC.networkAddress
	;msgbox(0, "Password Last Set", $strPwdCh & @CRLF & $lastlogon & @CRLF & $netwrkAddr)
	
	;Inserted to find error causing computer
	;FileWriteLine($LogFile, "ERRORFINDER, " & $fqdn & "," & $objPC)
	;Above is Error Finder line
	If IsObj($objPC) Then
		$arrGroups = $objPC.GetEx("memberOf")
	Else
		ReDim $arrGroups[2]
		$arrGroups[0] = "Not an Object"
		$arrGroups[1] = "Not in BMC"
	EndIf
	;_ADRecursiveGetMemberOf($memberof, $fqdn)
	;Sleep(100) ; to eleminate ADFunctions error - suggested from AutoIT forums
	;$arrGroups = $objPC.GetEx("memberOf")
	;IF $g_eventerror=1 Then
	;	Dim $arrGroups[2]
	;	$arrGroups[0] = $oMyError.description
	;	$Groups = $oMyError.description
	;	$g_eventerror = 0 ; resetting after handling
	;EndIf

	;$i = $i + 15
	;ProgressSet($i, $pcc & " of " & $RecordCount & " - Changing Date Format", "Working on " & $strPCName)


	;	Convert the whenChanged date to something useable by Excel
	$cYear = StringLeft($strChange, 4)
	$cMonth = StringMid($strChange, 5, 2)
	$cDay = StringMid($strChange, 7, 2)
	$cHour = StringMid($strChange, 9, 2)
	$cMin = StringMid($strChange, 11, 2)
	$strChanged = $cMonth & "/" & $cDay & "/" & $cYear & " " & $cHour & ":" & $cMin

	;	Convert the whenCreated date to something useable by Excel
	$crYear = StringLeft($strCreate, 4)
	$crMonth = StringMid($strCreate, 5, 2)
	$crDay = StringMid($strCreate, 7, 2)
	$crHour = StringMid($strCreate, 9, 2)
	$crMin = StringMid($strCreate, 11, 2)
	$strCreated = $crMonth & "/" & $crDay & "/" & $crYear & " " & $crHour & ":" & $crMin
	
	; 	Convert the pwdLastSet to something useable by Excel
	$crYear = StringLeft($strPwdCh, 4)
	$crMonth = StringMid($strPwdCh, 5, 2)
	$crDay = StringMid($strPwdCh, 7, 2)
	$crHour = StringMid($strPwdCh, 9, 2)
	$crMin = StringMid($strPwdCh, 11, 2)
	$strPwdChd = $crMonth & "/" & $crDay & "/" & $crYear & " " & $crHour & ":" & $crMin
	
	;$i = $i + 15
	;ProgressSet($i, $pcc & " of " & $RecordCount & " - Pinging", "Working on " & $strPCName)

	;	Ping the computer and store results in a temp file
	$sTempFile = "c:\Temp\ACRegionsAU3.txt"
	FileDelete($sTempFile)
	$strPingCmd = " /c ping -n 3 -w 1000 " & $strPCName & " > " & $sTempFile
	;MsgBox(0, "Ping Command", $strPingCmd)
	$pingresult = RunWait(@ComSpec & $strPingCmd, "", @SW_HIDE)
	;MsgBox(0, "Ping resulted in: ", $pingresult)
	$fFile = FileOpen($sTempFile, $ForReading)
	$fFileText = FileRead($fFile)

	;$i = $i + 15
	;ProgressSet($i, $pcc & " of " & $RecordCount & " - Checking Ping", "Working on " & $strPCName)
	
	;	Check to see if there was a Time to Live on the ping, meaning the pc responded.
	$TTL = StringInStr($fFileText, "TTL=")
	Select
		Case $TTL > 0
			$IsAlive = "Responding"
		Case Else
			$IsAlive = "Not Responding to Ping"
	EndSelect

	;	IF ping succeeded, pull the IP address from the ping response file *otherwise* Try to pull from the Registry if Ping Failed
	If $IsAlive = "Responding" Then
		$sString = $fFileText
		$sStart = "["
		$sEnd = "]"
		$stripIP = _StringBetween($sString, $sStart, $sEnd)
	Else
		;$i = $i + 5
		;ProgressSet($i, $pcc & " of " & $RecordCount & " - Trying to pull IP from Registry", "Working on " & $strPCName)
		$keyread = "working"
		While $keyread = "working"
			$r = $r + 1
			$IPSubkey = RegEnumKey("\\" & $strPCName & "\HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\Tcpip\Parameters\Interfaces\", $r)
			If @error <> 0 Then
				Select
					Case @error = -1
						$keyread = "outofrange"
					Case @error = 3
						$keyread = "Unable to connect to Registry"
					Case @error = 2
						$keyread = "No such Key"
					Case @error = 1
						$keyread = "No Subkey Found"
				EndSelect
			EndIf
			SetError(0)
			$IPkey = RegRead("\\" & $strPCName & "\HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\Tcpip\Parameters\Interfaces\" & $IPSubkey, "DhcpIPAddress")
			If $IPkey <> "" Then
				$keyread = "GotIt"
			EndIf
			SetError(0)
		WEnd
		If $IPkey = "" Then
			$IPkey = "Can Not.Acquire IP." & $keyread & ".Error"
		EndIf
	EndIf

	If $keyread = "GotIt" Or $IsAlive = "Responding" Then

		;	Take either method's IP address and pull out the subnet only
		;MsgBox(0, "StringBetween", $stripIP[0])
		$isip = StringInStr($stripIP, ".")
		If $isip > 0 Then
			$arrIP = StringSplit($stripIP[0], ".")
			;MsgBox(0, "Array size for IP", $arrIP[0])
			$strSubnet = $arrIP[1] & "." & $arrIP[2] & "." & $arrIP[3]
		Else
			If StringInStr($IPkey, ".") Then
				$arrIP = StringSplit($IPkey, ".")
				If $arrIP[0] > 3 Then
					$strSubnet = $arrIP[1] & "." & $arrIP[2] & "." & $arrIP[3]
				Else
					$strSubnet = $IPkey
				EndIf
				
			Else
				$strSubnet = $IPkey
			EndIf
		EndIf
		
		;$i = $i + 15
		;ProgressSet($i, $pcc & " of " & $RecordCount & " - Searching for Tuner File", "Working on " & $strPCName)

		; 	Check for the BMC Tuner File
		$strTunerPathC = "\\" & $strPCName & "\C$\Program Files\marimba\tuner\tuner.exe"
		$strTunerPathE = "\\" & $strPCName & "\E$\Program Files\marimba\tuner\tuner.exe"
		$strTunerPathD = "\\" & $strPCName & "\D$\Program Files\marimba\tuner\tuner.exe"
		
		Select
			Case FileExists($strTunerPathC)
				$TunerPath = "C Drive"
			Case FileExists($strTunerPathE)
				$TunerPath = "E Drive"
			Case FileExists($strTunerPathD)
				$TunerPath = "D Drive"
			Case Else
				$TunerPath = "No Tuner File"
		EndSelect

		;	Check for the BMC Tuner Service
		;ProgressSet($i, $pcc & " of " & $RecordCount & " - Checking Registry for Service", "Working on " & $strPCName)
		$ABCATM = RegRead("\\" & $strPCName & $services & "\ABCATM", "DisplayName")
		$ABCDay = RegRead("\\" & $strPCName & $services & "\ABCDayCenter", "DisplayName")
		$ABCDService = RegRead("\\" & $strPCName & $services & "\ABCDefault", "DisplayName")
		$ABC_Server = RegRead("\\" & $strPCName & $services & "\ABC_Server", "DisplayName")
		$ABCLaptop = RegRead("\\" & $strPCName & $services & "\ABCLaptop", "DisplayName")
		$ABCMirror = RegRead("\\" & $strPCName & $services & "\ABCMirror", "DisplayName")
		$ApplicationPkgr = RegRead("\\" & $strPCName & $services & "\ApplicationPackager", "DisplayName")
		$EndNode = RegRead("\\" & $strPCName & $services & "\EndNode-MIS", "DisplayName")
		$TheCityMain = RegRead("\\" & $strPCName & $services & "\TheCityMain", "DisplayName")
		$Test = RegRead("\\" & $strPCName & $services & "\Test", "DisplayName")
		$ABCSAService = RegRead("\\" & $strPCName & $services & "\ABCSpecialAssets", "DisplayName")
		$ABCRpService = RegRead("\\" & $strPCName & $services & "\ABCRepeater", "DisplayName")
		$sTunerServicei = $ABCDService & $ABCSAService & $ABCRpService & $ABC_Server & $ABCLaptop & $ApplicationPkgr & $EndNode & $TheCityMain & $Test & $ABCDay & $ABCMirror & $ABCATM
		
		;ProgressSet($i, $pcc & " of " & $RecordCount & " - Checking for Running BMC Services", "Working on " & $strPCName)
		
		$Locator = ObjCreate("WbemScripting.SWbemLocator")
		$Service = $Locator.ConnectServer($strPCName, "root/cimv2", "", "", "", "", 128)
		
		
		If IsObj($Service) Then
			; Test to see if the WMI Service is behaving
			$psscmd = " \\" & $strPCName & " query winmgmt"
			$WMITest = Run($psservice & $psscmd, "", @SW_MINIMIZE)
			
			$pss_check = ProcessWaitClose($WMITest, 128)
			If $pss_check = 1 Then
				
				$TrendServer = RegRead($trendkey & "\PC-cillinNTCorp\CurrentVersion", "Server")
				Select
					Case $TrendServer = 1
						$TrendServer = "Unable to open Key"
					Case $TrendServer = 2
						$TrendServer = "Trend Registry Not Found"
					Case $TrendServer = 3
						$TrendServer = "Unable to Connect Registry"
					Case $TrendServer = -1
						$TrendServer = "Value Not Found"
					Case $TrendServer = -2
						$TrendServer = "Value Type Not Supported"
				EndSelect
				
				$drivespace = DriveSpaceFree("\\" & $strPCName & "\c$")
				
				; Check Tuner Services (some excluded)
				$qTunerService = _ServiceRunning($strPCName, "ABCDefault")
				If $qTunerService = 1 Then
					$sTunerService = "ABC Default"
				EndIf
				$qTunerService = _ServiceRunning($strPCName, "ABCSpecialAssets")
				If $qTunerService = 1 Then
					$sTunerService = $sTunerService & "ABC Special Assets"
				EndIf
				$qTunerService = _ServiceRunning($strPCName, "ABCRepeater")
				If $qTunerService = 1 Then
					$sTunerService = $sTunerService & "ABC Repeater"
				EndIf
				$qTunerService = _ServiceRunning($strPCName, "ABC_Server")
				If $qTunerService = 1 Then
					$sTunerService = $sTunerService & "ABC Server"
				EndIf
				$qTunerService = _ServiceRunning($strPCName, "ABCDayCenter")
				If $qTunerService = 1 Then
					$sTunerService = $sTunerService & "ABC Day Center"
				EndIf
				$qTunerService = _ServiceRunning($strPCName, "ApplicationPackager")
				If $qTunerService = 1 Then
					$sTunerService = $sTunerService & "Application Packager"
				EndIf
				$qTunerService = _ServiceRunning($strPCName, "ABCMirror")
				If $qTunerService = 1 Then
					$sTunerService = $sTunerService & " Mirror"
				EndIf
				$qTunerService = _ServiceRunning($strPCName, "ABCLaptop")
				If $qTunerService = 1 Then
					$sTunerService = $sTunerService & "ABC Laptop"
				EndIf
				; If no tuner found then say so
				If $sTunerService = "" Then
					$sTunerService = "No Tuner Running"
				EndIf
				
				; Check Trend Service
				$qTrendService = _ServiceRunning($strPCName, "ntrtscan")
				If $qTrendService = 1 Then
					$sTrendService = "Trend Running"
				Else
					$sTrendService = "No Trend Running"
				EndIf
				
				; Check GoverLan Service
				$qGoverLan = _ServiceRunning($strPCName, "GOVsrv")
				If $qGoverLan = 1 Then
					$sGoverLan = "GoverLan Running"
				Else
					$sGoverLan = "No GoverLan Running"
				EndIf
				
			Else
				ProcessClose($WMITest)
				$sTunerService = "WMI Locked Up"
				$sTrendService = "WMI Locked Up"
			EndIf
		Else
			$sTunerService = "WMI Unavailable"
		EndIf
		
		;$i = $i + 15
		;ProgressSet($i, $pcc & " of " & $RecordCount & " - Checking subnet", "Working on " & $strPCName)
		
		;	Use Subnet to see what group it Should be in
		If $strSubnet <> "Unknown" Then
			Select
				Case $strSubnet = "10.9.160" Or $strSubnet = "10.9.144" Or $strSubnet = "10.9.112" Or $strSubnet = "10.9.128" Or $strSubnet = "10.8.128" Or $strSubnet = "10.8.64" Or $strSubnet = "10.8.48" Or $strSubnet = "10.8.32" Or $strSubnet = "10.8.80" Or $strSubnet = "10.8.96" Or $strSubnet = "10.8.112" Or $strSubnet = "10.50.32" Or $strSubnet = "10.50.80" Or $strSubnet = "10.50.64" Or $strSubnet = "10.50.0" Or $strSubnet = "10.50.96" Or $strSubnet = "10.50.48" Or $strSubnet = "10.50.16"
					$strADGROUP = "A"
				Case $strSubnet = "10.25.176" Or $strSubnet = "10.24.148" Or $strSubnet = "10.13.176" Or $strSubnet = "10.13.160" Or $strSubnet = "10.13.128" Or $strSubnet = "10.29.128" Or $strSubnet = "10.8.208" Or $strSubnet = "10.9.64" Or $strSubnet = "10.9.96" Or $strSubnet = "10.16.96" Or $strSubnet = "10.16.64" Or $strSubnet = "10.16.80" Or $strSubnet = "10.16.16" Or $strSubnet = "10.16.32" Or $strSubnet = "10.16.128" Or $strSubnet = "10.16.160" Or $strSubnet = "10.16.112" Or $strSubnet = "10.16.144" Or $strSubnet = "10.21.48" Or $strSubnet = "10.24.144" Or $strSubnet = "10.24.145" Or $strSubnet = "10.24.146" Or $strSubnet = "10.24.147" Or $strSubnet = "10.24.159" Or $strSubnet = "10.29.112" Or $strSubnet = "10.28.64" Or $strSubnet = "10.28.48" Or $strSubnet = "10.29.0" Or $strSubnet = "10.20.112" Or $strSubnet = "10.20.176" Or $strSubnet = "10.20.128" Or $strSubnet = "10.20.144" Or $strSubnet = "10.20.160" Or $strSubnet = "10.8.192" Or $strSubnet = "10.8.144" Or $strSubnet = "10.16.208" Or $strSubnet = "10.16.176" Or $strSubnet = "10.16.240" Or $strSubnet = "10.16.224" Or $strSubnet = "10.17.32" Or $strSubnet = "10.17.0" Or $strSubnet = "10.24.96" Or $strSubnet = "10.25.160" Or $strSubnet = "10.8.160" Or $strSubnet = "10.8.176"
					$strADGROUP = "B"
				Case $strSubnet = "10.24.177" Or $strSubnet = "10.8.224" Or $strSubnet = "10.8.240" Or $strSubnet = "10.9.0" Or $strSubnet = "10.9.16" Or $strSubnet = "10.12.64" Or $strSubnet = "10.12.16" Or $strSubnet = "10.12.176" Or $strSubnet = "10.12.96" Or $strSubnet = "10.12.112" Or $strSubnet = "10.12.144" Or $strSubnet = "10.13.48" Or $strSubnet = "10.12.160" Or $strSubnet = "10.12.128" Or $strSubnet = "10.29.144" Or $strSubnet = "10.24.80" Or $strSubnet = "10.24.64" Or $strSubnet = "10.12.192" Or $strSubnet = "10.13.0" Or $strSubnet = "10.12.208" Or $strSubnet = "10.12.224" Or $strSubnet = "10.12.240" Or $strSubnet = "10.28.96" Or $strSubnet = "10.28.80" Or $strSubnet = "10.20.48" Or $strSubnet = "10.20.32" Or $strSubnet = "10.12.80" Or $strSubnet = "10.13.16" Or $strSubnet = "10.13.112" Or $strSubnet = "10.24.32" Or $strSubnet = "10.28.128" Or $strSubnet = "10.28.112" Or $strSubnet = "10.28.144" Or $strSubnet = "10.28.208" Or $strSubnet = "10.13.32" Or $strSubnet = "10.28.160" Or $strSubnet = "10.28.176" Or $strSubnet = "10.13.144" Or $strSubnet = "10.13.64"
					$strADGROUP = "C"
				Case $strSubnet = "10.9.48" Or $strSubnet = "10.24.224" Or $strSubnet = "10.25.0" Or $strSubnet = "10.12.32" Or $strSubnet = "10.20.80" Or $strSubnet = "10.20.96" Or $strSubnet = "10.13.80" Or $strSubnet = "10.13.96" Or $strSubnet = "10.29.48" Or $strSubnet = "10.29.80" Or $strSubnet = "10.29.96" Or $strSubnet = "10.29.16" Or $strSubnet = "10.28.192" Or $strSubnet = "10.29.64" Or $strSubnet = "10.29.32" Or $strSubnet = "10.25.96"
					$strADGROUP = "D"
				Case $strSubnet = "10.53.32" Or $strSubnet = "10.53.16" Or $strSubnet = "10.53.0" Or $strSubnet = "10.52.224" Or $strSubnet = "10.52.32" Or $strSubnet = "10.52.16" Or $strSubnet = "10.52.96" Or $strSubnet = "10.52.64" Or $strSubnet = "10.52.112" Or $strSubnet = "10.52.48" Or $strSubnet = "10.52.176" Or $strSubnet = "10.52.208" Or $strSubnet = "10.52.128" Or $strSubnet = "10.52.144" Or $strSubnet = "10.52.192" Or $strSubnet = "10.52.160" Or $strSubnet = "10.52.240" Or $strSubnet = "10.52.80"
					$strADGROUP = "E"
				Case $strSubnet = "10.21.112" Or $strSubnet = "10.20.224" Or $strSubnet = "10.20.240" Or $strSubnet = "10.20.16" Or $strSubnet = "10.21.94" Or $strSubnet = "10.21.64" Or $strSubnet = "10.21.16" Or $strSubnet = "10.16.192" Or $strSubnet = "10.20.192" Or $strSubnet = "10.20.208" Or $strSubnet = "10.21.80" Or $strSubnet = "10.21.32" Or $strSubnet = "10.21.0"
					$strADGROUP = "F"
				Case $strSubnet = "10.48.176" Or $strSubnet = "10.49.32" Or $strSubnet = "10.49.0" Or $strSubnet = "10.49.112" Or $strSubnet = "10.49.96" Or $strSubnet = "10.49.64" Or $strSubnet = "10.50.112" Or $strSubnet = "10.48.16" Or $strSubnet = "10.50.144" Or $strSubnet = "10.49.80" Or $strSubnet = "10.48.160" Or $strSubnet = "10.50.128" Or $strSubnet = "10.48.32" Or $strSubnet = "10.48.48" Or $strSubnet = "10.48.80" Or $strSubnet = "10.48.0" Or $strSubnet = "10.48.64" Or $strSubnet = "10.48.112" Or $strSubnet = "10.49.48"
					$strADGROUP = "G"
				Case $strSubnet = "10.25.193" Or $strSubnet = "10.24.128" Or $strSubnet = "10.24.208" Or $strSubnet = "10.9.80" Or $strSubnet = "10.25.80" Or $strSubnet = "10.25.128" Or $strSubnet = "10.24.160" Or $strSubnet = "10.24.240" Or $strSubnet = "10.25.144" Or $strSubnet = "10.24.16" Or $strSubnet = "10.28.32" Or $strSubnet = "10.24.112" Or $strSubnet = "10.25.64" Or $strSubnet = "10.28.240" Or $strSubnet = "10.25.32" Or $strSubnet = "10.25.192" Or $strSubnet = "10.25.112" Or $strSubnet = "10.28.16" Or $strSubnet = "10.25.48" Or $strSubnet = "10.24.48" Or $strSubnet = "10.25.16"
					$strADGROUP = "J"
				Case $strSubnet = "10.4.101" Or $strSubnet = "10.4.102" Or $strSubnet = "10.4.110" Or $strSubnet = "10.4.120" Or $strSubnet = "10.4.130" Or $strSubnet = "10.4.140" Or $strSubnet = "10.4.150" Or $strSubnet = "10.4.159" Or $strSubnet = "10.4.160" Or $strSubnet = "10.4.169" Or $strSubnet = "10.4.170" Or $strSubnet = "10.4.179" Or $strSubnet = "10.4.180" Or $strSubnet = "10.4.190" Or $strSubnet = "10.4.103" Or $strSubnet = "10.4.168" Or $strSubnet = "10.4.178"
					$strADGROUP = "M"
				Case Else
					$strADGROUP = $strSubnet
			EndSelect
		Else
			$strADGROUP = $strSubnet
		EndIf
		
		;$i = $i + 15
		;ProgressSet($i, $pcc & " of " & $RecordCount & " - Checking AD Groups", "Working on " & $strPCName)
		
		;	Get the AD Group it is in
		If IsArray($arrGroups) Then
			For $Group In $arrGroups
				;MsgBox(0, "Group", $Group)
				Select
					Case StringInStr($Group, "A_NW_MS")
						$strGroup = "A_NW_MS"
					Case StringInStr($Group, "B_NE_MS")
						$strGroup = "B_NE_MS"
					Case StringInStr($Group, "C_SE_MS")
						$strGroup = "C_SE_MS"
					Case StringInStr($Group, "D_SW_MS")
						$strGroup = "D_SW_MS"
					Case StringInStr($Group, "E_Texas")
						$strGroup = "E_Texas"
					Case StringInStr($Group, "F_Flordia")
						$strGroup = "F_Flordia"
					Case StringInStr($Group, "G_Tennessee")
						$strGroup = "G_Tennessee"
					Case StringInStr($Group, "J_TheCity_MS")
						$strGroup = "J_TheCity_MS"
					Case StringInStr($Group, "M_TheCity_Main")
						$strGroup = "M_TheCity_Main"
					Case Else
						$strGroup = "NotBMC"
				EndSelect
				If $strGroup <> "NotBMC" Then
					$Groups = $Groups & " " & $strGroup
				EndIf
			Next
		Else
			$Groups = $arrGroups
		EndIf
		If $Groups = "" Then
			$Groups = $strGroup
		EndIf

		;	Write the results to the Results file
		;ProgressSet($i, $pcc & " of " & $RecordCount & " - Writing the Results to file", "Working on " & $strPCName)
		FileWriteLine($LogFile, $strPCName & "," & $IsAlive & "," & $strOS & "," & $strOSsp & "," & $strOSv & "," & $strChanged & "," & $strCreated & "," & $strPwdChd & "," & $strSubnet & "," & $TunerPath & "," & $sTunerServicei & "," & $sTunerService & "," & $sTrendService & "," & $TrendServer & "," & $sGoverLan & "," & $strADGROUP & "," & $Groups & "," & $drivespace)

	Else
		FileWriteLine($LogFile, $strPCName & "," & $IsAlive & "," & $strOS & "," & $strOSsp & "," & $strOSv & "," & $strChanged & "," & $strCreated & "," & $strPwdChd & "," & $strSubnet & "," & $TunerPath & "," & $sTunerServicei & "," & $sTunerService & "," & $sTrendService & "," & $TrendServer & "," & $sGoverLan & "," & $strADGROUP & "," & $Groups & "," & $drivespace)
		$recheck = $recheck & "," & $strPCName
	EndIf

	;$i = 100
	;ProgressSet($i, $pcc & " of " & $RecordCount & " - cleanup and on to next computer", "Working on " & $strPCName)

	;	Cleanup all variables, just to see if there is carryover and prevent contamination of next record
	$strPCName = "carryover"
	$IsAlive = "carryover"
	$strOS = "carryover"
	$strOSsp = "carryover"
	$strOSv = "carryover"
	$strChanged = "carryover"
	$strCreated = "carryover"
	$strSubnet = "carryover"
	$sTunerService = "carryover"
	$sTrendService = "carryover"
	$strADGROUP = "carryover"
	$Groups = "carryover"
	$strSubnet = "carryover"
	$IPkey = "carryover"
	$TunerPath = "carryover"
	$sTunerServicei = "carryover"
	$sGoverLan = "carryover"

EndFunc   ;==>InfoCollect

; This is my custom COM error handler
Func MyErrFunc()
	$HexNumber = Hex($oMyError.number, 8)
	FileWriteLine($ErrorFile, $strPCName & "," & $oMyError.description & "," & $HexNumber & ", Line " & $oMyError.scriptline & "," & $oMyError.windescription)
	$g_eventerror = 1 ; something to check for when this function returns
EndFunc   ;==>MyErrFunc

Func ResultsCleanup()
	Dim $sfile, $search, $filecreated, $now, $datetest, $created
	
	$search = FileFindFirstFile("AssetCollect*.csv")
	If $search = -1 Then Return
	
	While 1
		$sfile = FileFindNextFile($search)
		If @error Then ExitLoop
		
		$created = FileGetTime($sfile)
		$filecreated = $created[0] & "/" & $created[1] & "/" & $created[2] & " " & $created[3] & ":" & $created[4] & ":" & $created[5]
		$now = _NowCalc()
		$datetest = _DateDiff("D", $filecreated, $now)
		If $datetest > 14 Then
			FileDelete($sfile)
		EndIf
	WEnd
	$search = FileFindFirstFile("status*.txt")
	If $search = -1 Then Return
	
	While 1
		$sfile = FileFindNextFile($search)
		If @error Then ExitLoop
		
		$created = FileGetTime($sfile)
		$filecreated = $created[0] & "/" & $created[1] & "/" & $created[2] & " " & $created[3] & ":" & $created[4] & ":" & $created[5]
		$now = _NowCalc()
		$datetest = _DateDiff("D", $filecreated, $now)
		If $datetest > 7 Then
			FileDelete($sfile)
		EndIf
	WEnd
	$search = FileFindFirstFile("Error*.csv")
	If $search = -1 Then Return
	
	While 1
		$sfile = FileFindNextFile($search)
		If @error Then ExitLoop
		
		$created = FileGetTime($sfile)
		$filecreated = $created[0] & "/" & $created[1] & "/" & $created[2] & " " & $created[3] & ":" & $created[4] & ":" & $created[5]
		$now = _NowCalc()
		$datetest = _DateDiff("D", $filecreated, $now)
		If $datetest > 7 Then
			FileDelete($sfile)
		EndIf
	WEnd
EndFunc   ;==>ResultsCleanup