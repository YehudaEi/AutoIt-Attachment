#NoTrayIcon

Opt('RunErrorsFatal',0)
HTTPSetProxy(1)

; Constanten
Const $ScriptStartTime = @YEAR & '/' & @MON & '/' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
Const $ScriptIdentifier = 'Squid Proxy domain selector script'
Const $IniFile = @ScriptDir & '\watchdnsserver.ini'
Const $DisallowedCharacters = '!"#$%&()*+,-/:;<=>?@[\]^_{|}~¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿŒœŠšŸƒ–—‘’‚“”„†‡•…‰€™' & "'"

If WinExists($ScriptIdentifier) Then Exit
AutoItWinSetTitle($ScriptIdentifier)

; Locatie van de scriptlogfile.
CreateGlobalOtherVariable('ScriptLogFile','c:\squid\var\logs\script.log')

; Iedere zoveel seconden wordt er gepolld. Maximaal 60 seconden.
CreateGlobalOtherVariable('PollTimer','5')
$PollTimer = Round(Number($PollTimer))

If $PollTimer > 60 Then
	$PollTimer = 60
ElseIf $PollTimer < 1 Then
	$PollTimer = 1
EndIf

WriteLog('------------------------------------------------')
WriteLog('Starting ' & $ScriptIdentifier & '...')
WriteLog('IniFile: ' & $IniFile)
WriteLog('')
ReadVariables()

Global $Connection = 1

WriteVariablesToLog()

WriteLog('These variables can be overridden by adding them')
WriteLog('to the ini file under the Variables section.')
WriteLog('------------------------------------------------')

AutoItWinSetTitle($ScriptIdentifier)

If RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\GNU\SquidNT\2.5\SquidNT','CommandLine') <> '-f ' & $SquidConfFile & '.byscript' Then RunWait($SquidExeFile & ' -O "-f ' & $SquidConfFile & '.byscript','',@SW_HIDE)

$Domain = ''
$PrevDomain = 'none'

RunWait('ipconfig /renew','',@SW_HIDE)

RotateSizerFunction()

While 1
	$Domain = TestConnection()
	If $Domain = -1 Then
		NoConnection()
	ElseIf $Domain <> $PrevDomain Then
		ReadDomainConfig($Domain)
		$SquidShutdownTimer = $MaxSquidShutdownTimer
		$Connection = 1
	Else
		If $UseSquid = 1 Then
			If ParentTimerFunction() = -1 Then ReadDomainConfig($Domain)
			SquidProcessExistsTimerFunction()
		EndIf
	EndIf
	$PrevDomain = $Domain
	Sleep($PollTimer * 1000)
	RotateTimerFunction()
WEnd

; ===============
; Timer functions
; ===============

Func SquidProcessExistsTimerFunction()
	$SquidProcessTimer = $SquidProcessTimer - 1
	If $SquidProcessTimer = 0 Then
		If Not ProcessExists($SquidProcess) And $SquidProcess <> 0 Then Fatal('Squid process terminated unexpectedly.')
		$SquidProcessTimer = $MaxSquidProcessTimer
	EndIf
EndFunc

Func ParentTimerFunction()
	$ParentAliveTimer = $ParentAliveTimer - 1
	If $ParentAliveTimer = 0 Then
		$ParentAliveTimer = $MaxParentAliveTimer
		For $A = 1 To $ParentCounter
			If InetGetSize('http://' & $ParentName[$A] & ':' & $TCPPort[$A]) = 0 Then
				If $ParentPresent[$A] = 1 Then Return -1
			Else
				If $ParentPresent[$A] = 0 Then Return -1
			EndIf
		Next
	EndIf
EndFunc

; ==================
; Rotation functions
; ==================

Func RotateTimerFunction()
	$RotateTimer = $RotateTimer -1
	If $RotateTimer = 0 Then RotateSizerFunction()
EndFunc

Func RotateSizerFunction()
	If FileGetSize($ScriptLogFile) > $MaxScriptLogFileSize Then
		writelog('Rotate: ScriptLogFile exceeds ' & BytesToUnits($MaxScriptLogFileSize) & '.')
		WriteLog('  Attempting to rotate ScriptLogFile.')
		For $A = $MaxNumberOfScriptLogFiles - 1 To 1 Step -1
			FileMove($ScriptLogFile & '.' & $A - 1,$ScriptLogFile & '.' & $A,1)
		Next
		If FileMove($ScriptLogFile,$ScriptLogFile & '.0',1) = 0 Then
			WriteLog('  Cannot rotate ScriptLogFile. Will retry later.')
		Else
			WriteLog('Script log file rotated successfully.')
			WriteLog('The script has been running since ' & $ScriptStartTime & '.')
			WriteVariablesToLog()
		EndIf
	EndIf
	If $SquidProcess <> 0 Then
		If RotateSquidLogIfNecessary('AccessLogFile') = -1 Then Return
		If RotateSquidLogIfNecessary('CacheLogFile') = -1 Then Return
		If RotateSquidLogIfNecessary('StoreLogFile') = -1 Then Return
	EndIf
	$RotateTimer = $MaxRotateTimer
EndFunc

Func RotateSquidLogIfNecessary($LogFile)
	If Eval($LogFile) <> 'none' Then
		$PreviousFileSize = FileGetSize(Eval($LogFile))
		If $PreviousFileSize > Eval('Max' & $LogFile & 'Size') Then
			WriteLog('Rotate: ' & $LogFile & ' exceeds ' & BytesToUnits(Eval('Max' & $LogFile & 'Size')) & '.')
			WriteLog('  Attempting to rotate Squid log files.')
			Run($SquidExeFile & ' -k rotate -n ' & $NTServiceName,'',@SW_HIDE)
			Return -1
		EndIf
	EndIf
EndFunc

Func StopSquid()
	If ProcessExists($SquidProcess) Then
		WriteLog('Stopping Squid...')
		RunWait('net stop ' & $NTServiceName,'',@SW_HIDE)
		ProcessWaitClose($SquidProcess)
		WriteLog('  Squid stopped.')
	EndIf
	$SquidProcess = 0
EndFunc

; ====================
; Conversion functions
; ====================

Func TimeToPoll($Variable)
  	$Variable = StringStripWS($Variable,8)
  	$TimeUnit = StringRight($Variable,1)
  	Select
  		Case $TimeUnit = 'd'
  			$Variable = Number($Variable) * 24 * 60 * (60 / $PollTimer)
  		Case $TimeUnit = 'h'
  			$Variable = Number($Variable) * 60 * (60 / $PollTimer)
  		Case $TimeUnit = 'm'
  			$Variable = Number($Variable) * (60 / $PollTimer)
  		Case $TimeUnit = 's'
  			$Variable = Number($Variable / $PollTimer)
  			If $Variable < 1 Then $Variable = 1
  		Case Else
  			Fatal('Error in time unit ' & $Variable & '. Expected s, m, h, d.')
  	EndSelect
  	Return $Variable
EndFunc

Func PollToTime($Variable)
	$Variable = $Variable * $PollTimer
	Select
		Case $Variable >= 86400
			$Variable = Round($Variable / 60 / 60 / 24,2) & ' day(s)'
		Case $Variable >= 3600
			$Variable = Round($Variable / 60 / 60,1) & ' hour(s)'
		Case $Variable >= 60
			$Variable = Round($Variable / 60,1) & ' minute(s)'
		Case $Variable >= 0
			$Variable = $Variable & ' second(s)'
	EndSelect
	Return $Variable
EndFunc

Func UnitsToBytes($Variable)
	$Variable = StringStripWS($Variable,8)
	$SizeUnit = StringRight($Variable,1)
	Select
		Case $SizeUnit = 'g'
			$Variable = Number($Variable) * 1073741824
		Case $SizeUnit = 'm'
			$Variable = Number($Variable) * 1048576
		Case $SizeUnit = 'k'
			$Variable = Number($Variable) * 1024
		Case $SizeUnit = 'b'
			$Variable = Number($Variable)
		Case Else
			Fatal('Error in size unit ' & $Variable & '. Expected b, k, m, g.')
	EndSelect
	Return $Variable
EndFunc

Func BytesToUnits($Variable)
	Select
		Case $Variable >= 1073741824
			$Variable = Round($Variable / 1073741824,2) & ' GB'
		Case $Variable >= 1048576
			$Variable = Round($Variable / 1048576,2) & ' MB'
		Case $Variable >= 1024
			$Variable = Round($Variable / 1024,2) & ' KB'
		Case $Variable >= 0
			$Variable = $Variable & ' B'
	EndSelect
	Return $Variable
EndFunc

; ====================
; Connection functions
; ====================

Func NoConnection()
	If $Connection = 1 Then
		$Connection = 0
		ToolTipTee('No network connection.')
	EndIf
	If ProcessExists($SquidProcess) Then
		If $SquidShutdownTimer = $MaxSquidShutdownTimer Then WriteLog('Shutting Squid down in ' & PollToTime($MaxSquidShutdownTimer) & ' if not connected.')
		If $SquidShutdownTimer > 0 Then $SquidShutdownTimer = $SquidShutdownTimer - 1
		If $SquidShutdownTimer = 0 Then
			StopSquid()
			WriteLog('Waiting for network connection.')
		EndIf
	EndIf
EndFunc

Func TestConnection()
	$Domain = RegRead('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters','DHCPDomain')
	If $Domain <> '' Then
		Return $Domain
	Else
		Return -1
	EndIf
EndFunc

; ===========================
; Variable creation functions
; ===========================

Func CreateGlobalOtherVariable($Variable,$Default)
	Assign($Variable,IniRead($IniFile,'Variables',$Variable,$Default),2)
EndFunc

Func CreateGlobalTimeVariable($Variable,$Default)
	Assign('Max' & $Variable,Round(TimeToPoll(IniRead($IniFile,'Variables','Max' & $Variable,$Default))),2)
	Assign($Variable,Eval('Max' & $Variable),2)
EndFunc

Func CreateGlobalSizeVariable($Variable,$Default)
	Assign($Variable,UnitsToBytes(IniRead($IniFile,'Variables',$Variable,$Default)),2)
EndFunc

Func WriteSizeVariable($Variable)
	If FileExists(Eval($Variable)) Then
		FileWriteLine($WriteLogFile,$CurrentTime & '  ' & StringFormat('%-24s: ','Max' & $Variable & 'Size') & 	StringFormat('%9s',BytesToUnits(Eval('Max' & $Variable & 'Size'))))
		FileWriteLine($WriteLogFile,$CurrentTime & '  ' & StringFormat('%-24s: ','Current' & $Variable & 'Size') & 	StringFormat('%9s',BytesToUnits(FileGetSize(Eval($Variable)))))
	EndIf
EndFunc

Func WriteOtherVariable($Variable)
	FileWriteLine($WriteLogFile,$CurrentTime & '  ' & StringFormat('%-25s: ',$Variable) & Eval($Variable))
EndFunc

Func ReadVariables()
	CreateGlobalOtherVariable('SquidConfFile','c:\squid\etc\squid.conf')
	CreateGlobalOtherVariable('MaxNumberOfScriptLogFiles','5')
	CreateGlobalOtherVariable('NTServicename','squidnt')
	CreateGlobalOtherVariable('SquidExeFile','c:\squid\sbin\squid.exe')
	CreateGlobalSizeVariable('MaxScriptLogFileSize','1m')
	CreateGlobalSizeVariable('MaxAccessLogFileSize','4m')
	CreateGlobalSizeVariable('MaxCacheLogFileSize','1m')
	CreateGlobalSizeVariable('MaxStoreLogFileSize','4m')
	CreateGlobalTimeVariable('RotateTimer','4h')
	CreateGlobalTimeVariable('SquidShutdownTimer','5m')
	CreateGlobalTimeVariable('ParentAliveTimer','5m')
	CreateGlobalTimeVariable('SquidProcessTimer','1m')

	RequiredFilesExistCheck()

	Global $AccessLogFile = 'c:\squid\var\logs\access.log'
	Global $CacheLogFile = 'c:\squid\var\logs\cache.log'
	Global $StoreLogFile = 'c:\squid\var\logs\store.log'
	Global $PidFile = 'c:\squid\var\logs\squid.pid'

	$ReadSquidConfFile = FileOpen($SquidConfFile,0)

	While 1
		$ConfLine = FileReadLine($ReadSquidConfFile)
		If @error = -1 Then ExitLoop
		$ConfLine = StringStripWS($ConfLine,7)
		Select
			Case StringLeft($ConfLine,16) = 'cache_access_log'
				$AccessLogFile = StringTrimLeft($ConfLine,17)
			Case StringLeft($ConfLine,12) = 'pid_filename'
				$PidFile = StringTrimLeft($ConfLine,13)
			Case StringLeft($ConfLine,9) = 'cache_log'
				$CacheLogFile = StringTrimLeft($ConfLine,10)
			Case StringLeft($ConfLine,15) = 'cache_store_log'
				$StoreLogFile = StringTrimLeft($ConfLine,16)
		EndSelect
	WEnd

	FileClose($ReadSquidConfFile)

	Global $SquidProcess = ProcessExists('squid.exe')
EndFunc

; ====================
; Validation functions
; ====================

Func DetermineValidConfigLines($DomainConfig)
	Global $Parent[1024]
	Global $Sibling[1024]
	Global $Fallback[1024]
	Global $Literal[1024]
	Global $PrelimNameServers[1024]
	Global $NameServersString[1024]
	$NameServersCounter = 0

	For $a = 1 To $DomainConfig[0][0]
		Global $StringName = StringStripWS($DomainConfig[$a][0],7)
		Global $StringValue = StringStripWS($DomainConfig[$a][1],7)

		$ConfigString = StringSplit($StringValue,' ')

		Select
		Case $StringName = 'Parent'
			If ValidateServerString($StringValue,$StringName,$Domain,$A) = -1 Then ContinueLoop
			$ParentCounter = $ParentCounter + 1
			$Parent[$ParentCounter] = $StringValue
		Case $StringName = 'Sibling'
			If ValidateServerString($StringValue,$StringName,$Domain,$A) = -1 Then ContinueLoop
			$SiblingCounter = $SiblingCounter + 1
			$Sibling[$SiblingCounter] = $StringValue
		Case $StringName = 'Fallback'
			If ValidateServerString($StringValue,'Sibling',$Domain,$A) = -1 Then ContinueLoop
			$FallbackCounter = $FallbackCounter + 1
			$Fallback[$FallbackCounter] = $StringValue
		Case $StringName = 'Literal'
			$LiteralCounter = $LiteralCounter + 1
			$Literal[$LiteralCounter] = $StringValue
		Case $StringName = 'NameServers'
			$TempNameServersString = StringSplit(StringStripWS(StringReplace($StringValue,',',' '),7),' ')
			For $b = 1 To $TempNameServersString[0]
				$NameServersCounter = $NameServersCounter + 1
				$NameServersString[$NameServersCounter] = $TempNameServersString[$b]
			Next
		Case $StringName = 'UseSquid'
			If $StringValue = 'No' Then $UseSquid = 0
		EndSelect
	Next

	ReDim $Parent[$ParentCounter+1]
	ReDim $Sibling[$SiblingCounter+1]
	ReDim $Fallback[$FallbackCounter+1]
	ReDim $Literal[$LiteralCounter+1]
	ReDim $NameServersString[$NameServersCounter+1]
EndFunc

Func ValidateServerString($Server,$Type,$DomainSectionInIniFile,$Line)
	$Error = 0
	$StringPart = StringSplit($Server,' ')

	Select
	Case $StringPart[0] < 5
		$Error = 1
	Case $StringPart[1] <> 'cache_peer'
		$Error = 1
	Case StringLen($StringPart[2]) > 50
		$Error = 1
	Case StringLeft($StringPart[2],1) = '-' Or StringRight($StringPart[2],1) = '-'
		$Error = 1
	Case StringLeft($StringPart[2],1) = '.' Or StringRight($StringPart[2],1) = '.'
		$Error = 1
	Case $Type = 'Parent' And $StringPart[3] <> 'Parent'
		$Error = 1
	Case $Type = 'Sibling' And $StringPart[3] <> 'Sibling'
		$Error = 1
	Case $StringPart[4] <= 0 Or $StringPart[5] <= 0
		$Error = 1
	Case $StringPart[4] = $StringPart[5]
		$Error = 1
	Case Else
		$TestServerString = StringSplit($StringPart[2],$DisallowedCharacters)
		If @Error <> 1 Then $Error = 1
	EndSelect

	If $Error = 1  Then
		WriteLog('    Error in section ' & $DomainSectionInIniFile & ', line ' & $Line & '.')
		Return -1
	EndIf
EndFunc

Func ValidateNameServerIPAddress($ServerName)
	$TestServerString = StringSplit($ServerName,'abcdefghijklmnopqrstuvwxyz' & $DisallowedCharacters)
	If @Error <> 1 Then Return -1

	If StringLen($ServerName) > 15 Or StringLen($ServerName) < 7 Then Return -1

	$NameServerNamePart = StringSplit($ServerName,'.')
	If $NameServerNamePart[0] <> 4 Then Return -1

	For $a = 1 To 4
		If Number($NameServerNamePart[$A]) > 255 Then Return -1
	Next
EndFunc

; ============================
; Configuration file functions
; ============================

Func ReadDomainConfig($CurrentDomain)
	WriteLog('Updating network configuration...')

	Global $ParentCounter = 0
	Global $SiblingCounter = 0
	Global $FallbackCounter = 0
	Global $LiteralCounter = 0
	Global $NameServersCounter = 0
	Global $UseSquid = 1

	RequiredFilesExistCheck()

	$IpAddress1 = @IPAddress1
	$IpAddress2 = @IPAddress2

	If $IpAddress1 = '127.0.0.1' And $IpAddress2 <> '0.0.0.0' And $IpAddress2 <> '127.0.0.1' Then
		Global $IpAddress = $IpAddress2
	ElseIf $IpAddress1 <> '127.0.0.1' And StringLeft($IpAddress1,3) <> '169' Then
		Global $IpAddress = $IpAddress1
	Else
		Return
	EndIf

	If $SquidProcess <> 0 Then
		WriteLog('  Squid is running. The PID is ' & $SquidProcess & '.')
	Else
		WriteLog('  Squid is not running.')
	EndIf

	WriteLog('  IP Address: ' & $IpAddress & ', domain: ' & $Domain & '.')

	Global $DomainSection = IniReadSectionNames($IniFile)
	$DomainFound = 0
	For $A = 1 To $DomainSection[0]
		If $Domain = $DomainSection[$A] Then $DomainFound = 1
	Next

	If $DomainFound = 0 Then
		$DomainToRead = 'Default'
		WriteLog('  Domain not found. Using default configuration.')
	Else
		$DomainToRead = $Domain
	EndIf

	$DomainSection = IniReadSection($IniFile,$DomainToRead)

	If Not @Error Then DetermineValidConfigLines($DomainSection)

	If $UseSquid = 0 Then
		$Message = 'Squid not required in this domain.'
		WriteLog('  ' & $Message)
		StopSquid()
		WriteLog('Waiting for other connection.')
		ToolTipTee($Message)
		Return
	EndIf

	WriteSquidConfig()
EndFunc

Func WriteSquidConfig()
	WriteLog('Writing Squid configuration file...')

	$SquidConfWrite = FileOpen($SquidConfFile & '.byscript',2)
	If $SquidConfWrite = -1 Then Fatal('Cannot write to ' & $SquidConfFile & '.byscript.')

	$ThisComputer = @ComputerName

	FileWriteLine($SquidConfWrite,'# Generated by ' & $ScriptIdentifier & '.')
	FileWriteLine($SquidConfWrite,'# Do not make changes to this file. Change ' & $SquidConfFile & ' instead.')
	FileWriteLine($SquidConfWrite,"# The script's ini file is: " & $IniFile & '.')
	FileWriteLine($SquidConfWrite,@LF)
	FileWriteLine($SquidConfWrite,'#################################################################')
	FileWriteLine($SquidConfWrite,'# The following lines are machine specific and cannot be altered.')
	FileWriteLine($SquidConfWrite,@LF)
	FileWriteLine($SquidConfWrite,'visible_hostname ' & $ThisComputer)
	FileWriteLine($SquidConfWrite,'acl ' & $ThisComputer & ' src ' & $ThisComputer)
	FileWriteLine($SquidConfWrite,'http_access allow ' & $ThisComputer)
	FileWriteLine($SquidConfWrite,'#################################################################')
	FileWriteLine($SquidConfWrite,@LF)

	$SquidConfRead = FileOpen($SquidConfFile,0)
	If $SquidConfRead = -1 Then Fatal('Could not access Squid configuration file.')

	While 1
		$ConfLine = FileReadLine($SquidConfRead)
		If @Error = -1 Then ExitLoop
		$ConfLine = StringStripWS($ConfLine,7)
		If StringLeft($ConfLine,1) = '#' Or $ConfLine = '' Then ContinueLoop
		FileWriteLine($SquidConfWrite,$ConfLine)
	WEnd

	FileClose($SquidConfRead)

	FileWriteLine($SquidConfWrite,@LF)
	FileWriteLine($SquidConfWrite,'# The following settings are defined in the ini file.')
	FileWriteLine($SquidConfWrite,"# They are specific to domain " & $Domain & '.')
	FileWriteLine($SquidConfWrite,@LF)

	$ParentIsAlive = 0
	Global $ParentPresent[$ParentCounter+1]
	Global $ParentName[$ParentCounter+1]
	Global $TCPPort[$ParentCounter+1]
	Global $UDPPort[$ParentCounter+1]

	If $ParentCounter > 0 Then
		Writelog('  Adding parents:')
		For $A = 1 To $ParentCounter
			$ConfigString = StringSplit($Parent[$A],' ')
			$ParentName[$A] = $ConfigString[2]
			$TCPPort[$A] = $ConfigString[4]
			$UDPPort[$A] = $ConfigString[5]

			If InetGetSize('http://' & $ParentName[$A] & ':' & $TCPPort[$A]) = 0 Then
				WriteLog('    ' & $ParentName[$A] & '/' & $TCPPort[$A] & '/' & $UDPPort[$A] & ' appears to be dead.')
				$ParentPresent[$A] = 0
			Else
				WriteLog('    ' & $ParentName[$A] & '/' & $TCPPort[$A] & '/' & $UDPPort[$A] & ' is alive.')
				$ParentPresent[$A] = 1
				$ParentIsAlive = 1
				FileWriteLine($SquidConfWrite,$ParentName[$A])
			EndIf
		Next
	Else
		WriteLog('  No parents are defined for this domain.')
	EndIf

	If $SiblingCounter > 0 Then
		Writelog('  Adding siblings:')
		For $A = 1 To $SiblingCounter
			$ConfigString = StringSplit($Sibling[$A],' ')
			WriteLog('    ' & $ConfigString[2] & '/' &  $ConfigString[4] & '/' & $ConfigString[5])
			FileWriteLine($SquidConfWrite,$Sibling[$A])
		Next
	EndIf

	If $LiteralCounter > 0 Then
		Writelog('  Adding literal strings:')
		For $A = 1 To $LiteralCounter
			WriteLog('    ' & StringLeft($Literal[$A],54))
			FileWriteLine($SquidConfWrite,$Literal[$A])
		Next
	EndIf

	If $ParentIsAlive = 0 And $ParentCounter > 0 And $FallbackCounter > 0 Then
		WriteLog('  No live parents found - going standalone.')
		Writelog('  Adding fallback siblings:')
		For $A = 1 To $FallbackCounter
			$ConfigString = StringSplit($Fallback[$A],' ')
			WriteLog('    ' & $ConfigString[2] & '/' & $ConfigString[4] & '/' & $ConfigString[5])
			FileWriteLine($SquidConfWrite,$Fallback[$A])
		Next
	EndIf

	If $FallbackCounter = 0 And $ParentCounter > 0 Then WriteLog('    No fallback siblings are defined for this domain.')

	If $NameServersCounter > 0 Then
		WriteLog('  Adding name servers from ini file:')
	Else
		$NameServersString = StringSplit(RegRead('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters','DHCPNameServer'),' ')
		WriteLog('  Adding name servers from network:')
		$NameServersCounter = $NameServersString[0]
	EndIf

	If $NameServersCounter = 0 Then
		WriteLog('  Could not determine name servers.')
	Else
		For $i = 1 To $NameServersCounter
			If ValidateNameServerIPAddress($NameServersString[$i]) <> -1 Then
				WriteLog('    ' & $NameServersString[$i])
				FileWriteLine($SquidConfWrite,'dns_nameservers ' & $NameServersString[$i])
			Else
				WriteLog('    Invalid IP address: ' & $NameServersString[$i])
			EndIf
		Next
	EndIf

	FileClose($SquidConfWrite)

	WriteLog('Squid configuration file written.')

	$RunResult = RunWait($SquidExeFile & ' -k parse -f ' & $SquidConfFile & '.byscript','',@SW_HIDE)
	If $RunResult <> 0 Then Fatal('Error in Squid configuration file!')

	If ProcessExists($SquidProcess) Then
		If Not FileExists($PidFile) Then
			WriteLog('  Squid PID file not found! Restarting Squid...')
			RunWait('net stop squidnt','',@SW_HIDE)
			RunWait('net start squidnt','',@SW_HIDE)
			$Message = ' restarted'
		Else
			RunWait($SquidExeFile & ' -k reconfigure -n ' & $NTServiceName,'',@SW_HIDE)
			$Message = ' reconfigured'
		EndIf
	Else
		WriteLog('  Starting Squid...')
		RunWait('net start ' & $NTServiceName,'',@SW_HIDE)
		$Message = ' started'
	EndIf

	$SquidProcess = ProcessExists('squid.exe')
	If $SquidProcess = 0 Then Fatal('Squid is not running. Possible configuration error.')

	ToolTipTee('Service ' & $NTServiceName & $Message & ' successfully.')
	WriteLog('Serving requests.')
EndFunc

; =================
; Logging functions
; =================

Func RequiredFilesExistCheck()
	If Not FileExists($SquidConfFile) Then Fatal($SquidConfFile & ' does not exist!')
	If Not FileExists($SquidExeFile) Then Fatal($SquidExeFile & ' does not exist!')
	If Not FileExists($IniFile) Then Fatal($IniFile & ' does not exist!')
EndFunc

Func WriteLog($Message)
	FileWriteLine($ScriptLogFile,@YEAR & '/' & @MON & '/' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC & '| ' & $Message)
EndFunc

Func ToolTipTee($MessageString)
	WriteLog($MessageString)
	$XPos = @DesktopWidth / 2
	For $a = 1 To 7
		ToolTip('')
		Sleep(70)
		ToolTip($MessageString,$XPos,0)
		Sleep(70)
	Next
	Sleep(2000)
	ToolTip('')
EndFunc

Func Fatal($FatalErrorMessage)
	WriteLog('*** Fatal ERROR - ABORTING ***')
	WriteLog($FatalErrorMessage)
	MsgBox(262144 + 16,'Fatal Error',$FatalErrorMessage)
	Exit
EndFunc

Func WriteVariablesToLog()
	Global $CurrentTime = @YEAR & '/' & @MON & '/' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC & '| '
	Global $WriteLogFile = FileOpen($ScriptLogFile,1)
	FileWriteLine($WriteLogFile,$CurrentTime & 'Using the following variables:')
	FileWriteLine($WriteLogFile,$CurrentTime & @LF)
	FileWriteLine($WriteLogFile,$CurrentTime & '  PollTimer            : ' & $PollTimer & ' second(s)')
	FileWriteLine($WriteLogFile,$CurrentTime & @LF)
	WriteTimeVariable('MaxRotateTimer')
	WriteTimeVariable('MaxSquidShutdownTimer')
	WriteTimeVariable('MaxParentAliveTimer')
	WriteTimeVariable('MaxSquidProcessTimer')
	FileWriteLine($WriteLogFile,$CurrentTime & @LF)
	WriteFileVariable('ScriptLogFile')
	WriteFileVariable('SquidConfFile')
	FileWriteLine($WriteLogFile,$CurrentTime & @LF)
	WriteSizeVariable('ScriptLogFile')
	FileWriteLine($WriteLogFile,$CurrentTime & @LF)
	WriteSizeVariable('AccessLogFile')
	WriteSizeVariable('CacheLogFile')
	WriteSizeVariable('StoreLogFile')
	FileWriteLine($WriteLogFile,$CurrentTime & '  (files taken from SquidConfFile)')

	FileWriteLine($WriteLogFile,$CurrentTime & @LF)
	WriteOtherVariable('MaxNumberOfScriptLogFiles')
	WriteOtherVariable('NTServiceName')
	FileWriteLine($WriteLogFile,$CurrentTime & '------------------------------------------------')
	FileClose($WriteLogFile)
EndFunc

Func WriteTimeVariable($Variable)
	FileWriteLine($WriteLogFile,$CurrentTime & '  ' & StringFormat('%-21s: ',$Variable) & PollToTime(Eval($Variable)))
EndFunc

Func WriteFileVariable($Variable)
	FileWriteLine($WriteLogFile,$CurrentTime & '  ' & StringFormat('%-13s: ',$Variable) & Eval($Variable))
EndFunc

; =============
; End of script
; =============