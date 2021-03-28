#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=Check Public PCs in Use.exe
#AutoIt3Wrapper_Res_Description=Calculates the # of PCs Available in the library.
#AutoIt3Wrapper_Res_Fileversion=0.6.0.0
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_Field=Compiled Script|AutoIt v3 Script : 3.3.6.1
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author: Adam Lawrence (AdamUL)

 Script Function: Checks to see if Ekstrom Public PCs are in use and writes the
 in use and not in use PCs to file.

#ce ----------------------------------------------------------------------------
#include <Security.au3>
#include <String.au3>
#include <Array.au3>
#include <Date.au3>
#include <File.au3>
#include <Misc.au3>
#include <Debug.au3>

_Singleton("PCs in Use")

ProcessSetPriority(@AutoItPID, 1)
#Region - Data, Output File and Locations
$sPCInUseDataDir = @AppDataCommonDir & "\Public PCs in Use"

#Region - Error Logs
$sErrorLogsDir = $sPCInUseDataDir & "\Error Logs"
$sErrorLogFile = $sErrorLogsDir & "\Error Log.log"
If Not FileExists($sErrorLogsDir) Then DirCreate($sErrorLogsDir)
#EndRegion

#Region - Output HTML File
;~ $sDirNumPCsNotInUseHTML = "\\libs-web\www-staff\wopr" ;For Testing.
$sDirNumPCsNotInUseHTML = "\\libs-web\www-public\PCUse" ;Production Location.
$sFileNumPCsNotInUseHTML = $sDirNumPCsNotInUseHTML & "\NumPCsNotInUse.html" ;Output HTML file.
;~ $sFileNumPCsNotInUseHTML = $sDirNumPCsNotInUseHTML & "\NumPCsNotInUse2.html" ;Test Output HTML file.
;~ $sFileNumPCsNotInUseHTML = "NumPCsNotInUse.html" ;For Testing.

OnAutoItExitRegister("_ScriptClosing")
DriveMapAdd("", $sDirNumPCsNotInUseHTML)
If @error Then _FileWriteLog($sErrorLogFile, "ERROR: " & @error & ". Unable to access remote server.")
#EndRegion

#Region - Loop Logs
$sTime = StringReplace(StringReplace(_NowCalc(), "/", ""), ":", "-")
;~ $sLoopTimeLogDir = "Log Files"
$sLoopTimeLogDir = $sPCInUseDataDir & "\Log Files"
$sLoopTimeLog = $sLoopTimeLogDir & "\Loop Time Log " & $sTime & ".csv"
$sLoopTimeLogHeader = "Run,Time Run,Loop Time (s),Num PCs In Use,Num PCs Not In Use,Total PCs"
If Not FileExists($sLoopTimeLogDir) Then DirCreate($sLoopTimeLogDir)
If Not FileExists($sLoopTimeLog) Then FileWriteLine($sLoopTimeLog, $sLoopTimeLogHeader)
#EndRegion

#Region - Debugging Setup
$sDebugLogDir = $sPCInUseDataDir & "\Debug Logs"
If Not FileExists($sDebugLogDir) Then DirCreate($sDebugLogDir)
$sDebugTitle = 'Debugging "' & @ScriptName & '"'
;~ _DebugSetup($sDebugTitle, True) ;Use Debugging Window.
_DebugSetup($sDebugTitle, True, 4, $sDebugLogDir & "\Debug Log " & $sTime & ".log") ;Use Log File.
#EndRegion

#Endregion

#Region - PC Name List

$sPCNames = ""

;~ #cs Public PCs
For $iPCNum = 1 To 73 Step 1
	If $iPCNum <= 9 Then
		$sPCNames &= "libs-pub-0" & $iPCNum & "|"
	ElseIf $iPCNum = 71 Then
		ContinueLoop
;~ 	ElseIf $iPCNum = 74 Then
;~ 		$sPCNames &= "libs-metro-pub1|"
;~ 		$sPCNames &= "libs-metro-01|"
	Else
		$sPCNames &= "libs-pub-" & $iPCNum & "|"
	EndIf
Next
;~ #ce

;~ #cs Cafe PCs
For $iPCNum = 1 To 8 Step 1
	If $iPCNum <= 9 Then
		$sPCNames &= "libs-pub-c0" & $iPCNum & "|"
	Else
		$sPCNames &= "libs-pub-c" & $iPCNum & "|"
	EndIf
Next
;~ #ce

;~ #cs Microform PCs
For $iPCNum = 1 To 4 Step 1
	If $iPCNum <= 9 Then
		$sPCNames &= "libs-mfscan-0" & $iPCNum & "|"
	Else
		$sPCNames &= "libs-mfscan-" & $iPCNum & "|"
	EndIf
Next
;~ #ce

;~ #cs iMacs
$sPCNames &= "libs-imac-bart|libs-imac-homer|libs-imac-lisa|libs-imac-marge|"
;~ #ce


#Endregion

If StringRight($sPCNames, 1) = "|" Then $sPCNames = StringTrimRight($sPCNames, 1) ;Convert String to an Array.
$aPCNames = StringSplit($sPCNames, "|")
_ArraySort($aPCNames, 0, 1)
;~ _ArrayDisplay($aPCNames) ;For Testing.
;~ _DebugReportVar("aPCNames", $aPCNames) ;For Testing.

;~ $iNumPCsInUse = 0
;~ $iNumPCsNotInUse = 0
$iRuns = 1
;~ $iRunsMax = 20

While 1
	$iStartTime = TimerInit() ;For Testing.
	_DebugOut("#Region - Starting Main Loop Run: " & $iRuns )

	#Region - Reset Data Strings
	Global $sStringPub0147MetroPCsInUse = ""
	Global $sStringPub0147MetroPCsNotInUse = ""

	Global $sStringPub4870PCsInUse = ""
	Global $sStringPub4870PCsNotInUse = ""

	Global $sStringCafePCsInUse = ""
	Global $sStringCafePCsNotInUse = ""

	Global $sStringCPPCsInUse = ""
	Global $sStringCPPCsNotInUse = ""

	Global $sStringiMacsInUse = ""
	Global $sStringiMacsNotInUse = ""
	#Endregion

	_DebugOut(@CRLF & "Connecting to PCs")
	#cs #Region - Progress Bar Window
	$sTitle = "Checking PCs (Run " & $iRuns & " of " & $iRunsMax & ")" ;For Testing.
	ProgressOn($sTitle, "", "", -1, -1, 2 + 16) ;For Testing.
	ProgressOn($sTitle, "", "", -1, -1, 16) ;For Testing.
	WinMove($sTitle, "", 60, 150) ;For Testing.
	#ce #EndRegion

	Global $aiPIDs[UBound($aPCNames)] = [$aPCNames[0]]
	Global $ahHandles[UBound($aPCNames)] = [$aPCNames[0]]

	For $iPCNum = 1 To $aPCNames[0] Step 1
		$sPCName = $aPCNames[$iPCNum]
;~ 		ProgressSet(Round(($iPCNum / $aPCNames[0]) * 100), $iPCNum & " of " & $aPCNames[0], $sPCName) ;For Testing.
		$aiPIDs[$iPCNum] = Run("UserLoggedOn " & $sPCName, @ScriptDir, @SW_HIDE)
		$ahHandles[$iPCNum] = _ProcessGetHandle($aiPIDs[$iPCNum])
		Sleep(100)
	Next
;~ 	ProgressOff() ;For Testing.
;~ 	Sleep(1000 * 3) ;Wait 3 seconds.
;~ 	Sleep(1000 * 10) ;Wait 10 seconds.
;~ 	Sleep(1000 * 15) ;Wait 15 seconds.
	Sleep(1000 * 20) ;Wait 15 seconds.
;~ 	Sleep(1000 * 30) ;Wait 30 seconds.


;~ 	_ArrayDisplay($aiPIDs) ;For Testing.
;~ 	_ArrayDisplay($ahHandles) ;For Testing.
;~ 	_DebugReportVar("aiPIDs", $aiPIDs) ;For Testing.
;~ 	_DebugReportVar("ahHandles", $ahHandles) ;For Testing.

;~ 	_DebugOut(@CRLF & "Getting PC States")
	For $iPCNum = 1 To $aiPIDs[0] Step 1
		If Not ProcessExists($aiPIDs[$iPCNum]) Then
			Switch _ProcessGetExitCode($ahHandles[$iPCNum])
				Case 0, 2
					_WriteInUseString($aPCNames[$iPCNum])
;~ 					_DebugOut("PC in use: " & $aPCNames[$iPCNum])
				Case 1
					_WriteNotInUseString($aPCNames[$iPCNum])
;~ 					_DebugOut("PC in not use: " & $aPCNames[$iPCNum])
				Case Else
					_WriteInUseString($aPCNames[$iPCNum])
;~ 					_WriteNotInUseString($aPCNames[$iPCNum])
;~ 					_DebugOut("_ProcessGetExitCode Case Else - PC in use: " & $aPCNames[$iPCNum])
			EndSwitch
		Else
			_WriteInUseString($aPCNames[$iPCNum])
;~ 			_WriteNotInUseString($aPCNames[$iPCNum])
;~ 			_DebugOut("ProcessExists Case Else - PC in use: " & $aPCNames[$iPCNum])
		EndIf
		_ProcessCloseHandle($ahHandles[$iPCNum])
		Sleep(10)
	Next


	For $iPCNum = 1 To $aiPIDs[0] Step 1 ;Stop the remaining processes.
;~ 		If ProcessClose($aiPIDs[$iPCNum]) Then _WriteInUseString($aPCNames[$iPCNum]) ;Write to *PCsInUse files for PC Name with process that was stopped.
		If ProcessClose($aiPIDs[$iPCNum]) Then
			_WriteInUseString($aPCNames[$iPCNum]) ;Write to *PCsInUse files for PC Name with process that was stopped.
;~ 			_WriteNotInUseString($aPCNames[$iPCNum])
;~ 			_DebugOut("ProcessClose - PC in use: " & $aPCNames[$iPCNum])
		EndIf
		Sleep(10)
	Next
;~ 	Sleep(125)

	#Region - Calculate PCs in use from Strings.
	_DebugOut(@CRLF & "Calculating Number of PCs")

	If $sStringPub0147MetroPCsInUse <> "" Then
		$aStringPub0147MetroPCsInUse = StringSplit(StringTrimRight($sStringPub0147MetroPCsInUse, 1), "|")
		$iNumPub0147MetroPCsInUse = $aStringPub0147MetroPCsInUse[0]
	Else
		$iNumPub0147MetroPCsInUse = 0
	EndIf
	_DebugReportVar("iNumPub0147MetroPCsInUse", $iNumPub0147MetroPCsInUse)

	If $sStringPub0147MetroPCsNotInUse <> "" Then
		$aStringPub0147MetroPCsNotInUse = StringSplit(StringTrimRight($sStringPub0147MetroPCsNotInUse, 1), "|")
		$iNumPub0147MetroPCsNotInUse = $aStringPub0147MetroPCsNotInUse[0]
	Else
		$iNumPub0147MetroPCsNotInUse = 0
	EndIf
	_DebugReportVar("iNumPub0147MetroPCsNotInUse", $iNumPub0147MetroPCsNotInUse)

	If $sStringPub4870PCsInUse <> "" Then
		$aStringPub4870PCsInUse = StringSplit(StringTrimRight($sStringPub4870PCsInUse, 1), "|")
		$iNumPub4870PCsInUse = $aStringPub4870PCsInUse[0]
	Else
		$iNumPub4870PCsInUse = 0
	EndIf
	_DebugReportVar("iNumPub4870PCsInUse", $iNumPub4870PCsInUse)

	If $sStringPub4870PCsNotInUse <> "" Then
		$aStringPub4870PCsNotInUse = StringSplit(StringTrimRight($sStringPub4870PCsNotInUse, 1), "|")
		$iNumPub4870PCsNotInUse = $aStringPub4870PCsNotInUse[0]
	Else
		$iNumPub4870PCsNotInUse = 0
	EndIf
	_DebugReportVar("iNumPub4870PCsNotInUse", $iNumPub4870PCsNotInUse)

	If $sStringCafePCsInUse <> "" Then
		$aStringCafePCsInUse = StringSplit(StringTrimRight($sStringCafePCsInUse, 1), "|")
		$iNumCafePCsInUse = $aStringCafePCsInUse[0]
	Else
		$iNumCafePCsInUse = 0
	EndIf
	_DebugReportVar("iNumCafePCsInUse", $iNumCafePCsInUse)

	If $sStringCafePCsNotInUse <> "" Then
		$aStringCafePCsNotInUse = StringSplit(StringTrimRight($sStringCafePCsNotInUse, 1), "|")
		$iNumCafePCsNotInUse = $aStringCafePCsNotInUse[0]
	Else
		$iNumCafePCsNotInUse = 0
	EndIf
	_DebugReportVar("iNumCafePCsNotInUse", $iNumCafePCsNotInUse)

	If $sStringCPPCsInUse <> "" Then
		$aStringCPPCsInUse = StringSplit(StringTrimRight($sStringCPPCsInUse, 1), "|")
		$iNumCPPCsInUse = $aStringCPPCsInUse[0]
	Else
		$iNumCPPCsInUse = 0
	EndIf
	_DebugReportVar("iNumCPPCsInUse", $iNumCPPCsInUse)

	If $sStringCPPCsNotInUse <> "" Then
		$aStringCPPCsNotInUse = StringSplit(StringTrimRight($sStringCPPCsNotInUse, 1), "|")
		$iNumCPPCsNotInUse = $aStringCPPCsNotInUse[0]
	Else
		$iNumCPPCsNotInUse = 0
	EndIf
	_DebugReportVar("iNumCPPCsNotInUse", $iNumCPPCsNotInUse)

	If $sStringiMacsInUse <> "" Then
		$aStringiMacsInUse = StringSplit(StringTrimRight($sStringiMacsInUse, 1), "|")
		$iNumiMacsInUse = $aStringiMacsInUse[0]
	Else
		$iNumiMacsInUse = 0
	EndIf
	_DebugReportVar("iNumiMacsInUse", $iNumiMacsInUse)

	If $sStringiMacsNotInUse <> "" Then
		$aStringiMacsNotInUse = StringSplit(StringTrimRight($sStringiMacsNotInUse, 1), "|")
		$iNumiMacsNotInUse = $aStringiMacsNotInUse[0]
	Else
		$iNumiMacsNotInUse = 0
	EndIf
	_DebugReportVar("iNumiMacsNotInUse", $iNumiMacsNotInUse)


	$iNumPCsInUse = $iNumiMacsInUse + $iNumCafePCsInUse + $iNumCPPCsInUse + $iNumPub0147MetroPCsInUse + $iNumPub4870PCsInUse
	$iNumPCsNotInUse = $iNumiMacsNotInUse + $iNumCafePCsNotInUse + $iNumCPPCsNotInUse + $iNumPub0147MetroPCsNotInUse + $iNumPub4870PCsNotInUse
	#Endregion

	#Region - Write Output and Log Files
;~ 	If FileExists($sFileNumPCsNotInUseHTML) And Not FileDelete($sFileNumPCsNotInUseHTML) Then _FileWriteLog($sErrorLogFile, "Unable to delete HTML file.")
;~ 	If Not FileDelete($sPCInUseDataDir & "\" & $sFileNumPCsNotInUseHTML) Then _FileWriteLog($sErrorLogFile, "Unable to delete HTML file.")
	$hFileNumPCsNotInUseHTML = FileOpen($sFileNumPCsNotInUseHTML, 2)
	$sHTMLNumPCsNotInUseString = _HTMLStringNumPCsNotInUse($iNumPub0147MetroPCsNotInUse, $iNumPub4870PCsNotInUse, $iNumCafePCsNotInUse, $iNumCPPCsNotInUse, $iNumiMacsNotInUse)
	If Not FileWrite($hFileNumPCsNotInUseHTML, $sHTMLNumPCsNotInUseString) Then _FileWriteLog($sErrorLogFile, "Unable to write HTML file.")
	FileClose($hFileNumPCsNotInUseHTML)

;~ 	_ReduceMemory(@AutoItPID) ;Do not uses, caused large swap file issue on server.
	Sleep(1000 * 5) ;Wait 5 seconds.

	$iLoopTime = TimerDiff($iStartTime) / 1000 ;For Testing.
;~ 	MsgBox(0, "Data", "Loop Time = " & $iLoopTime & " s" & @CRLF & @CRLF & "$iNumPCsInUse = " & $iNumPCsInUse & @CRLF & @CRLF & "$iNumPCsNotInUse = " & $iNumPCsNotInUse) ;For Testing.
	$sLoopTimeLogString = $iRuns & "," & _NowCalc() & "," & $iLoopTime & "," & $iNumPCsInUse & "," & $iNumPCsNotInUse & "," & $iNumPCsInUse + $iNumPCsNotInUse ;For Testing.
	FileWriteLine($sLoopTimeLog, $sLoopTimeLogString) ;For Testing.
	_DebugOut(@CRLF & $sLoopTimeLogHeader) ;For Testing.
	_DebugOut($sLoopTimeLogString & @CRLF) ;For Testing.
	#EndRegion

	_DebugOut("#Endregion - Ending Main Loop Run: " & $iRuns & @CRLF)

	$iRuns += 1 ;For Testing.
	;~ 	If $iRuns = $iRunsMax Then ExitLoop ;For Testing.
WEnd

Func _ProcessGetHandle($iPID) ;Return handle of given PID
    Local Const $PROCESS_QUERY_INFORMATION = 0x0400
    Local $avRET = DllCall("kernel32.dll", "ptr", "OpenProcess", "int", $PROCESS_QUERY_INFORMATION, "int", 0, "int", $iPID)
    If @error Then
        Return SetError(1, 0, 0)
    Else
        Return $avRET[0]
    EndIf
EndFunc   ;==>_ProcessGetHandle

Func _ProcessCloseHandle($hProc) ;Close process handle
    Local $avRET = DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $hProc)
    If @error Then
        Return SetError(1, 0, 0)
    Else
        Return 1
    EndIf
EndFunc   ;==>_ProcessCloseHandle

Func _ProcessGetExitCode($hProc) ;Get process exit code from handle
    Local $t_ExitCode = DllStructCreate("int")
    Local $avRET = DllCall("kernel32.dll", "int", "GetExitCodeProcess", "ptr", $hProc, "ptr", DllStructGetPtr($t_ExitCode))
    If @error Then
        Return SetError(1, 0, 0)
    Else
        Return DllStructGetData($t_ExitCode, 1)
    EndIf
EndFunc   ;==>_ProcessGetExitCode

Func _WriteInUseString($sComputer)
;~ 	_DebugReportVar("$sComputer _WriteInUseString", $sComputer)
	Select
		Case StringInStr($sComputer, "libs-imac")
			If Not StringInStr($sStringiMacsInUse, $sComputer) Then $sStringiMacsInUse &= $sComputer & "|"
		Case StringInStr($sComputer, "libs-metro")
			If Not StringInStr($sStringPub0147MetroPCsInUse, $sComputer) Then $sStringPub0147MetroPCsInUse &= $sComputer & "|"
		Case StringInStr($sComputer, "libs-mfscan") Or StringInStr($sComputer, "libs-ek-mfs") Or StringInStr($sComputer, "libs-per-pub")
			If Not StringInStr($sStringCPPCsInUse, $sComputer) Then $sStringCPPCsInUse &= $sComputer & "|"
		Case StringInStr($sComputer, "libs-pub-c")
			If Not StringInStr($sStringCafePCsInUse, $sComputer) Then $sStringCafePCsInUse &= $sComputer & "|"
		Case StringInStr($sComputer, "libs-pub")
			$iComputerNum = Number(StringReplace($sComputer,"libs-pub-", ""))
			Switch $iComputerNum
				Case 1 To 47, 72 To 73
					If Not StringInStr($sStringPub0147MetroPCsInUse, $sComputer) Then $sStringPub0147MetroPCsInUse &= $sComputer & "|"
				Case 48 To 70
					If Not StringInStr($sStringPub4870PCsInUse, $sComputer) Then $sStringPub4870PCsInUse &= $sComputer & "|"
			EndSwitch
	EndSelect
EndFunc

Func _WriteNotInUseString($sComputer)
;~ 	_DebugReportVar("$sComputer _WriteNotInUseString", $sComputer)
	Select
		Case StringInStr($sComputer, "libs-imac")
			If Not StringInStr($sStringiMacsNotInUse, $sComputer) Then $sStringiMacsNotInUse &= $sComputer & "|"
		Case StringInStr($sComputer, "libs-metro")
			If Not StringInStr($sStringPub0147MetroPCsNotInUse, $sComputer) Then $sStringPub0147MetroPCsNotInUse &= $sComputer & "|"
		Case StringInStr($sComputer, "libs-mfscan") Or StringInStr($sComputer, "libs-ek-mfs") Or StringInStr($sComputer, "libs-per-pub")
			If Not StringInStr($sStringCPPCsNotInUse, $sComputer) Then $sStringCPPCsNotInUse &= $sComputer & "|"
		Case StringInStr($sComputer, "libs-pub-c")
			If Not StringInStr($sStringCafePCsNotInUse, $sComputer) Then $sStringCafePCsNotInUse &= $sComputer & "|"
		Case StringInStr($sComputer, "libs-pub")
			$iComputerNum = Number(StringReplace($sComputer,"libs-pub-", ""))
			Switch $iComputerNum
				Case 1 To 47, 72 To 73
					If Not StringInStr($sStringPub0147MetroPCsNotInUse, $sComputer) Then $sStringPub0147MetroPCsNotInUse &= $sComputer & "|"
				Case 48 To 70
					If Not StringInStr($sStringPub4870PCsNotInUse, $sComputer) Then $sStringPub4870PCsNotInUse &= $sComputer & "|"
			EndSwitch
	EndSelect
EndFunc

Func _ReduceMemory($i_PID = -1)

    If $i_PID <> -1 Then
        Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $i_PID)
        Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
        DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
    Else
        Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
    EndIf

    Return $ai_Return[0]
EndFunc;==> _ReduceMemory()

Func _ScriptClosing()
	DriveMapDel($sDirNumPCsNotInUseHTML)
	While ProcessExists("UserLoggedOn")
		ProcessClose("UserLoggedOn")
	WEnd
EndFunc

Func _HTMLStringNumPCsNotInUse($iNumPub0147, $iNumPub4870, $iNumCafe, $iNumCP, $iNumiMac, $iRefreshRate = 10, $iDataUpdateRate = 40)

	$sStartHTML = '<head>'& @CRLF
	$sStartHTML &= '<title>Computers Available in the library</title>'& @CRLF & @CRLF
;~ 	$sStartHTML &= '<style type="text/css"><!-- @import url(                                                                          ); --></style>'& @CRLF & @CRLF
;~ 	$sStartHTML &= '<style>'& @CRLF
;~ 	$sStartHTML &= 'body { padding: 2em; }'& @CRLF
;~ 	$sStartHTML &= '#comps, .note { width: 350px; }'& @CRLF
;~ 	$sStartHTML &= 'p.number { font-size: 2.2em; color:#ff0000; margin-bottom:0; text-align:center; font-weight:bold; }'& @CRLF
;~ 	$sStartHTML &= 'p.area { font-size: 1.5em; margin-top: 0;  text-align:center; }'& @CRLF
;~ 	$sStartHTML &= '</style>'& @CRLF & @CRLF
	$sStartHTML &= '<style type="text/css"><!-- @import url(                                        ); --></style>'& @CRLF & @CRLF
;~ 	$sStartHTML &= '<META HTTP-EQUIV="Refresh" CONTENT="' & $iRefreshRate & '">' & @CRLF
;~ 	$sStartHTML &= '<script type="text/javascript">' & @CRLF & '<!--	' & @CRLF & 'var timer = setInterval("autoRefresh()", 1000 * ' & $iRefreshRate & ');' & @CRLF
	$sStartHTML &= '<script type="text/javascript">' & @CRLF & '<!--	' & @CRLF & 'var timer = setInterval("autoRefresh()", 1000 * ' & $iRefreshRate & ');' & @CRLF
	$sStartHTML &= 'function autoRefresh(){self.location.reload(true);}' & @CRLF & '//--> ' & @CRLF & '</script>' & @CRLF & @CRLF
	$sStartHTML &= '<script type="text/javascript">' & @CRLF & @CRLF
	$sStartHTML &= '  var _gaq = _gaq || [];' & @CRLF
	$sStartHTML &= "  _gaq.push(['_setAccount', 'UA-12430214-8']);" & @CRLF
	$sStartHTML &= "  _gaq.push(['_trackPageview']);" & @CRLF & @CRLF
	$sStartHTML &= '  (function() {' & @CRLF
	$sStartHTML &= "    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;" & @CRLF
	$sStartHTML &= "    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';" & @CRLF
	$sStartHTML &= "    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);" & @CRLF
	$sStartHTML &= '  })();' & @CRLF & @CRLF
	$sStartHTML &= '</script>' & @CRLF & @CRLF
	$sStartHTML &= '</head>' & @CRLF & @CRLF
	$sStartHTML &= '<body>' & @CRLF & @CRLF
	$sStartHTML &= '<h1> Computers Available in the Library</h1>'& @CRLF & @CRLF
	$sStartHTML &= '<div id="comps">'& @CRLF

	$sNumPub0147HTML = '<p class="number">' & $iNumPub0147 & '</p>' & @CRLF
	$sNumPub0147HTML &=  '<p class="area">Learning Commons</p>' & @CRLF & @CRLF

	$sNumPub4870HTML = '<p class="number">' & $iNumPub4870 & '</p>' & @CRLF
	$sNumPub4870HTML &= '<p class="area">Reference Area</p>' & @CRLF & @CRLF

	$sNumCafeHTML = '<p class="number">' & $iNumCafe & '</p>' & @CRLF
	$sNumCafeHTML &= '<p class="area">Cafe</p>' & @CRLF & @CRLF

	$sNumCPHTML = '<p class="number">' & $iNumCP & '</p>' & @CRLF
	$sNumCPHTML &= '<p class="area">Current Periodicals</p>' & @CRLF & @CRLF

	$sNumiMacHTML = '<p class="number">' & $iNumiMac & '</p>' & @CRLF
	$sNumiMacHTML &= '<p class="area">iMacs</p>' & @CRLF

	$sEndHTML = '</div>' & @CRLF & @CRLF
	$sEndHTML &= '<p class="note">This information is updated every ' & $iDataUpdateRate & ' seconds.</p>' & @CRLF & @CRLF
	$sEndHTML &= '<div id="portal-breadcrumbs">' & @CRLF
	$sEndHTML &= '<span id="breadcrumbs-you-are-here">Return to:</span>' & @CRLF
	$sEndHTML &= '    <a href="                          ">University Libraries</a> | ' & @CRLF
	$sEndHTML &= '    <a href="                                   ">Library</a> | ' & @CRLF
	$sEndHTML &= '    <a href="                             ">Libraries Mobile</a>' & @CRLF
	$sEndHTML &= '</div>' & @CRLF & @CRLF
	$sEndHTML &= '</body>'

	Return $sStartHTML & $sNumPub0147HTML & $sNumPub4870HTML & $sNumCafeHTML & $sNumCPHTML & $sNumiMacHTML & $sEndHTML
EndFunc
