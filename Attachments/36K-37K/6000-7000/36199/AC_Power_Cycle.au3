#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#comments-start
Author:			Jeri Saunders
Filename:		"CPMS_AC_Power_Cycle.au3"
Date Created:	12-28-2011
Purpose:		This script subjects the CPMS to a series of power cycles for
				Stress and Stability (SAS) testing. The initial platform undergoing
				SAS testing is CPMS 3.1 (Crystal CS100S platform).

The CPMS and iBootBar IP addresses are hardcoded in this script.
Change $CpmsIpAddr and $iBootBarIpAddr if they differ.
Set the $numIterations to the desired number of power cycles.
Log files are written to the "C:\Stress_And_Stability\Test_results_logs\AC_POWER_CYCLE\CPMS_R3.1" directory.

Before running this script, ensure that there are no users logged into the CPMS and that
the PC running this AutoIT script has network access to the CPMS and the iBootBar.  This
script assumes that the CPMS power connector is connected to outlet number 8 on the iBootBar.
It is not uncommon for the CPMS transaction simulation tool (tester) to timeout when
first attempting to connect to the CPMS.  It is also not uncommon for error messages
to appear in the window in which the simulator is running.  These errors are typically
related to transaction times taking longer than 500 msec.  Success or failure of the
simulated transactions will be determined based on a text search of the resultant
simulator log file.  Once the simulator has completed, the simulator log file will be
copied to the Log files location, identifying the power cycle number for that run.

Note: Using the SciTE Editor, you can get more information about any code in this file by placing the cursor
within a word (e.g., "Const" or "Ping"), right-click it while pressing the F1 key.
#comments-end

AutoItSetOption ( "WinTitleMatchMode" , -2)
#include <Array.au3>
#include "C:\Stress_And_Stability\AutoIT scripts\AC Power Cycle\TextSearchUtils.au3"

;Set $numIterations to the desired number of power cycles:
Const $numIterations         = 3 ; number of power cycles

;Change IP addresses and outlet value if they differ from below:
Const $CpmsIpAddr            = "192.168.90.133";use unique IP address for CPMS
Const $iBootBarIpAddr        = "192.168.90.134";use unique IP address for iBootBar
Const $iBootBarOutlet        = 8 ;assumes CPMS is connected to outlet #8 on iBootBar

;Identify main directory for logs
Const $CPMS_Power_Cycle_Logs = "C:\Stress_And_Stability\Test_results_logs\AC_POWER_CYCLE\CPMS_R3.1\"
Const $Telnet_Logname        = "Telnet_Log.log"

;Constants needed to run the CPMS transaction simulator tool
Const $CpmsTesterExe         = "C:\Stress_And_Stability\AutoIT scripts\AC Power Cycle\CpmsTester\datasim.bat"
Const $CpmsTesterWorkingDir  = "C:\Stress_And_Stability\AutoIT scripts\AC Power Cycle\CpmsTester\"
Const $CpmsUrl               = StringFormat('http://%s/CPMSTransaction', $CpmsIpAddr)
Const $CcardRanges           = "0x0000000001099700-0x0000000001099705" ;Add 6 pairings
Const $hostId                = "0x0000000001" ;to Host ID 1 (will overwrite if ccard already exists)
Const $TesterVars = stringFormat('""-url %s -ccardRanges %s -clients 1 -hostId %s -type ADD""', $CpmsUrl, $CcardRanges, $hostId)

;Constants needed to search the CPMS tester output file for successful transaction string
Const $CpmsTesterLogDir      = "C:\Stress_And_Stability\AutoIT scripts\AC Power Cycle\CpmsTester\logs\"
Const $CpmsTesterLogName     = "CpmsMultiThreadDatasim.log"
	  $CpmsTesterLogPath     = ($CpmsTesterLogDir & $CpmsTesterLogName)
Const $CPMS_TRANSACTION_SUCCESSFUL = "PairingStatus severity=""success"" statusNumber=""10"""

;First, check to make sure the CPMS is reachable on the network
If Ping ( $CpmsIpAddr ) = 0 Then
	ConsoleWrite ( @CRLF & @CRLF )
	ConsoleWrite ( "! CPMS is not reachable, ending script." & @CRLF )
	Exit
Else
	ConsoleWrite ( @CRLF & @CRLF )
	ConsoleWrite ( "+> CPMS is up." & @CRLF & @CRLF )
EndIf

;Write out Test information and number of iterations to be attempted on console
consolewrite( "Stress and Stability: CPMS AC Power Cycle Test" & @CRLF )
consolewrite( "Number of Iterations:  " & $numIterations & @CRLF )

;Create Log folder for this run and write out name
$LOG_LOCATION = StringFormat('%sCPMS_Logs_%s_%s_%s_%s%s%s', $CPMS_Power_Cycle_Logs, @YEAR, @MON, @MDAY, @HOUR, @MIN, @SEC)
If DirCreate ($LOG_LOCATION) = False Then
	ConsoleWrite("! Could not create directory." & @CRLF )
	Exit
EndIf
$LOG_PATH = $LOG_LOCATION & "\"
ConsoleWrite("Log location: " & $LOG_PATH & @CRLF )

;Open command prompt window to run Telnet and set up telnet logging
Run("cmd")
WinActivate("cmd")
WinWaitActive("cmd")
Send ("cd " & $LOG_LOCATION & "{ENTER}")
Sleep(10000)
	Send ("telnet {ENTER}")
	Sleep (1000)
	Send (StringFormat('set logfile %s', $Telnet_Logname & "{ENTER}") )
	Sleep(1000)
	If FileExists($LOG_PATH & $Telnet_Logname) = 0 Then
		ConsoleWrite("! Failed to create " & $LOG_PATH & $Telnet_Logname & @CRLF)
		Exit
	EndIf

$num_cycles = 0
$ColdRestart = 0
$ExtendedStartup = 0
$NumFailures = 0

Local $FailureArray[1] ;creates a local array - first value (0) will be "Cycle" header
$FailureArray[0] = "Cycle"


for $j = 1 to $numIterations ; # of Power cycles entered
	$num_cycles = $num_cycles + 1 ; count for number of loops

	Sleep(1000)
	consolewrite( @CRLF )
	consolewrite(StringFormat ('Cycle %s of %s', $num_cycles, $numIterations ))
	consolewrite( @CRLF )
	If WinActivate("telnet") = False Then
		ConsoleWrite("! Can't find Telnet window. Closing script at cycle #" & $num_cycles & @CRLF )
		Exit
	EndIf

	If $ColdRestart = 0 Then ; CPMS shutdown was graceful before last power cycle
		;Shutdown CPMS Services
		consolewrite( "  1 - Shut Down CPMS Services." & @CRLF )
		Send( StringFormat("open " & $CpmsIpAddr & "{ENTER}") )
		Sleep(10000)
		Send("Administrator" & "{ENTER}")
		Sleep(1000)
		Send("guvUS6UcuC" & "{ENTER}")
		Sleep(3000)
		Send (StringFormat ('echo Cycle %s of %s {ENTER}', $num_cycles, $numIterations ))
		Send("date /T {ENTER}")
		Send("time /T {ENTER}")
		Send("shutdown -s -t 5 {ENTER}")
		Sleep(2000)
		Send("^]")
		Sleep(1000)
		Send ("close {ENTER}")
		consolewrite( "      > CPMS shutting down. Allowing 2 minutes..." & @CRLF )
		Sleep(120000)
		;Verify CPMS shuts down
		$ExtendedStartup = 0
		$PingResponse = 0
		$PingResponse = Ping ( $CpmsIpAddr )
		If $PingResponse = 1 Then ;CPMS did not shut down successfully - still responds to ping
			ConsoleWrite ("! CPMS did not shut down successfully for cycle #" & $num_cycles )
			ConsoleWrite ("  - Continuing with power cycle..." & @CRLF )
			$ExtendedStartup = 1
		EndIf
	EndIf

	;Power cycle CPMS - assumes CPMS is in outlet 8 of iBootBar
	consolewrite( "  2 - Power Cycling via iBootBar." & @CRLF )
	Send( StringFormat("open " & $iBootBarIpAddr & "{ENTER}") )
	Sleep(1000)
	Send("admin" & "{ENTER}") ; iBootBar username
	Sleep(1000)
	Send("admin" & "{ENTER}") ; iBootBar password
	Sleep(1000)
	Send("set cycle 5 {ENTER}")
	Sleep(1000)
	Send( StringFormat('set outlet %s cycle {ENTER}', $iBootBarOutlet) )
	Sleep(2000)
	Send("{ENTER}") ;Adding some lines to telnet log
	Send("{ENTER}")
	Send("{ENTER}")
	Sleep(1000)
	Send("^]")
	Sleep(1000)
	Send ("close" & "{ENTER}")
	If $ExtendedStartup = 1 Then ;CPMS will take longer to reboot if shutdown not successful
	consolewrite( "      > Waiting for CPMS to reboot and restart services. Allowing 4 minutes after abrupt shutdown." & @CRLF )
		Sleep(240000) ; wait 4 minutes after a cold restart (CPMS did not shutdown gracefully)
	Else
	consolewrite( "      > Waiting for CPMS to reboot and restart services. Allowing 2 minutes after graceful shutdown." & @CRLF )
		Sleep(120000) ; on graceful shutdown wait 2 minutes for CPMS to reboot and for services to restart
	EndIf
	Send ("{ENTER}")

    ;Check that CPMS is reachable after power cycle
	$PingResponse = 0
	$PingResponse = Ping ( $CpmsIpAddr )
	If $PingResponse = 0 Then
		ConsoleWrite ( "! CPMS is not reachable after cycle #" & $num_cycles )
		ConsoleWrite ( "  - power cycling again." & @CRLF )
		$ColdRestart = 1
		$ExtendedStartup = 1
		$NumFailures = $NumFailures + 1
		_ArrayAdd($FailureArray, $num_cycles) ;indicate cycle in which failure occurred
	Else
		;Run CMPS Transaction
		consolewrite( "  3 - Initiating Card Pairing Transactions." & @CRLF )
		If FileExists($CpmsTesterLogPath) = 1 Then
			FileDelete($CpmsTesterLogPath)
			ConsoleWrite("      > Deleted existing tester log." & @CRLF )
		EndIf
		ShellExecute ( $CpmsTesterExe , $TesterVars, $CpmsTesterWorkingDir )
		ConsoleWrite ("      > Running transaction simulator tool - Waiting 60 seconds." & @CRLF )
		Sleep(60000);run tester and wait because sometimes it hangs
		If Ping( $CpmsIpAddr ) = 0 Then
			ConsoleWrite ("! CPMS not reachable after transaction simultor run." & @CRLF )
			If WinExists("C:\WINDOWS\system32\cmd.exe") = True Then
				WinKill("C:\WINDOWS\system32\cmd.exe")
				ConsoleWrite ("! CPMS Tester appears to have hung after cycle #" & $num_cycles & @CRLF )
			EndIf
			ConsoleWrite ( "! CPMS is not responding after cycle #" & $num_cycles )
			ConsoleWrite ( "  - power cycling again." & @CRLF )
			$ColdRestart = 1
			$ExtendedStartup = 1
			$NumFailures = $NumFailures + 1
			_ArrayAdd($FailureArray, $num_cycles) ;indicate cycle in which failure occurred
		Else			;Search tester log for status
			ConsoleWrite ("      > Searching transaction log for status." & @CRLF )
			$foundtext = SearchForString ($CpmsTesterLogPath, $CPMS_TRANSACTION_SUCCESSFUL)
			If $foundtext = false Then
				Consolewrite( "! Failure:  CPMS transaction failed after power cycle #"  & $num_cycles & @CRLF )
				$NumFailures = $NumFailures + 1
				_ArrayAdd($FailureArray, $num_cycles) ;indicate cycle in which failure occurred
			Else
				consolewrite( "      > Transaction Successful..." & @CRLF )
				$ColdRestart = 0
				$ExtendedStartup = 0
			EndIf
			$NewFile = StringFormat('%sCpmsTransactionLog_Cycle_%s.log', $LOG_PATH, $num_cycles )
			FileMove($CpmsTesterLogPath, $NewFile, 9)
		EndIf
	EndIf

Next  ; end of main loop

Send ("quit" & "{ENTER}")
Send ("exit" & "{ENTER}")

consolewrite( @CRLF )
consolewrite( "> Total number of Power Cycles: " & $num_cycles & @CRLF )
consolewrite( "! Total number of Failures Detected: " & $NumFailures & @CRLF & @CRLF )

$count = 0
While $count < $NumFailures
	ConsoleWrite (StringFormat ('%s       %s', $count, $FailureArray[$count]))
	ConsoleWrite (@CRLF)
	$count = $count + 1
WEnd

