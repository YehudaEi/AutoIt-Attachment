#include <Array.au3>

Opt( "OnExitFunc", "FlushTestResults" )

Global $iTestCount = 0
Global $iTotalAssertions =0
Global $iTotalPass = 0
Global $iTotalFail = 0
Global $aResults[1]
Global $iTimeBegin = TimerInit()
Global $bUseSetup = false
Global $sCurrentTestName = ""

Func Test( $testName )	
	; Reset Global Variables
	$iTestCount += 1
	$sCurrentTestName = $testName	

	If $iTestCount > 1 Then
		Call ("TestTearDown" )
	EndIf
	
	Call( "TestSetup" )
EndFunc

Func AssertTrue( $expression, $msg )
	$iTotalAssertions += 1
	If Not $expression then 
		DoTestFail( $msg )
	Else
		DoTestPass()
	EndIf 
EndFunc

Func AssertFalse( $expression, $msg )
	$iTotalAssertions += 1
	If $expression then 
		DoTestFail( $msg )
	Else
		DoTestPass()
	EndIf 	
EndFunc

Func AssertEqual( $a, $b, $msg )
	$iTotalAssertions += 1
	If $a <> $b Then
		DoTestFail( StringFormat( $msg & " ( $a=[%s], $b=[%s] )", $a, $b ))
	Else
		DoTestPass()
	EndIf
EndFunc


Func FlushTestResults()	
	Call ("TestTearDown" )
	
	If FileExists( @ScriptFullPath & ".log" ) then 
		FileDelete( @ScriptFullPath & ".log" )
	EndIf
	
	$TimeEnd = Round(TimerDiff($iTimeBegin) / 1000, 2)
	
	$FinalResults = StringFormat( "(%d) Tests (%d) Total Assertions (%d) Pass (%d) Fail", _
		$iTestCount, $iTotalAssertions, $iTotalPass, $iTotalFail )
	ReportTestInfo( "" )				
	ReportTestInfo( $FinalResults )	
	ReportTestInfo( "Total Time: " & $TimeEnd & " seconds" )
	
	$aResultsMessages = 	_ArrayToString( $aResults, @CRLF, 1 )
	If StringLen( $aResultsMessages ) <> 0 then 
		ReportTestInfo( "" )				
		ReportTestInfo( "ASSERTION" & @TAB & "MESSAGE" )
		ReportTestInfo( $aResultsMessages )
	EndIf 	
EndFunc

Func DoTestPass()
	$iTotalPass += 1
	ConsoleWrite( "." )
EndFunc

Func DoTestFail( $msg = "")
	$iTotalFail += 1
	Local $message = StringFormat( "%-15s %s", _ 
		$iTotalAssertions, "Error in " & $sCurrentTestName & " -> " & $msg  )
	_ArrayAdd( $aResults, $message )	
	ConsoleWrite( "F" )	
EndFunc

Func ReportTestInfo( $data )
	ConsoleWrite( $data & @CRLF )
	FileWriteLine( @ScriptFullPath & ".log", $data )
EndFunc