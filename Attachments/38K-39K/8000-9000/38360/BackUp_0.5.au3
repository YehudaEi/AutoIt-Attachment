#include <Timers.au3>
#include <File.au3>
#include <Array.au3>

Local Const $iHour = 3600000
Local $sBackUpDir = 'c:\backup\'			;Location of new .rar file
Local $sRarFile = 'Drafting.rar'			;Name of new .rar file
Local $sSRC = 'h:\drafting\*.*'				;Directory with files to back up
Local $sEXE = 'C:\Progra~1\WinRAR\rar.exe'	;location of rar.exe
Local $iBUStart = 1 						;time to start back-up: 24hr format
Local $iBUEnd = 8 							;time to stop trying to start back up: 24hr format
Local $iIdleTime = 1.0*$iHour 				;Required Idle Time before starting Back-Up
Local $sDST = $sBackUpDir & $sRarFile
If Not FileExists($sDST) Then
	$sOPT = ' a -ilog' & $sBackUpDir & 'error.log -r -rr5p -v4500000 -x*.bak -x*.dwl -xplot.log -xthumbs.db -x*\0_Temp_Saves_0\ ' & $sDST & ' ' & $sSRC ; command line options here
Else
	$sOPT = ' u -ilog' & $sBackUpDir & 'error.log -r -rr5p -v4500000 -x*.bak -x*.dwl -xplot.log -xthumbs.db -x*\0_Temp_Saves_0\ ' & $sDST & ' ' & $sSRC ; command line options here
EndIf
Local $iRTime = 0
Local $aLog
Local $aLogErr
While 1
	$iIdleTime = _Timer_GetIdleTime()
	If @HOUR > $iBUStart and @HOUR < $iBUEnd and _Timer_GetIdleTime() > $iIdleTime then ;OR NOT FileExists($sDST) then ;use to create back-up @ runtime
		$iRStart = _Timer_Init()
		$iExitCode 	= RunWait(@ComSpec & ' /c ' & $sEXE & ' ' & $sOPT & ' > ' & $sBackUpDir & 'output.tmp', @TempDir, @SW_HIDE)
		Local $iRTime = _Timer_Diff($iRStart)
		_FileReadToArray($sBackUpDir & 'output.tmp',$aLog)
		FIleDelete($sBackUpDir & 'output.tmp')
		If FileExists ($sBackUpDir & 'error.log') Then
			_FileReadToArray($sBackUpDir & 'error.log',$aLogErr)
			FIleDelete($sBackUpDir & 'error.log')
		EndIf
		$aLog = FormatLog($aLog)
		$iFileCount = CountFiles($aLog)
		Create_File($aLog,$aLogErr,Time_Convert($iRTime),$iExitCode,$iFileCount,$sBackUpDir,$sRarFile)
		Sleep(12 * $iHour)
	EndIf
	Sleep(0.5 * $iHour)
WEnd

Func Time_Convert($iTimeDiff)
;
;	Converts TimerDiff (ms) to HMS format
;
;	$TimeDiff = 	Integer; 	Milliseconds
;
	$hrs = 0
	$min = 0
	$sec= Round($iTimeDiff/1000,0)
	if $sec>59 then
		$hrs = int($sec / 3600)
		$sec = $sec - $hrs * 3600
		$min = int($sec / 60)
		$sec = $sec - $min * 60
	EndIf
	return $hrs & "h" & $min & "m" & $sec & "s"
EndFunc

Func Create_Header($theLog,$theTime,$theExit,$theFileCount)
;
;	Creates Output File Header
;
;	$theLog = 		Array;  	Output Data
;	$theTime = 		Integer; 	Runtime for Rar.exe in ms
;	$theExit = 		Integer; 	Exit Code for Rar.exe
;	$theFileCount = Integer;	Return from CountFiles()
;
	Local $sExitDesc
	Local $aExitDesc[11] = ['Successful operation.',  _
							'Warning. Non fatal error(s) occurred.',  _
							'A fatal error occurred.',  _
							'Invalid CRC32 control sum. Data is damaged.',  _
							'Attempt to modify a locked archive.',  _
							'Write error.',  _
							'File open error.',  _
							'Wrong command line option.',  _
							'Not enough memory.',  _
							'File create error.',  _
							'No files matching the specified mask were found.']
	_ArrayInsert($theLog, 0)
	_ArrayInsert($theLog, 0)
	_ArrayInsert($theLog, 0)
	If $iExitCode > Ubound($aExitDesc) Then
		$sExitDesc = 'User break.'
	Else
		$sExitDesc = $aExitDesc[$iExitCode]
	EndIf
	$theLog[0] = 'Update Time: ' & Time_Convert($theTime) & @TAB & 'File Count: '& $theFileCount
	$theLog[1] = 'Exit Code: ' & $theExit & ' ' & $sExitDesc
	Return $theLog
EndFunc

Func Create_File($theLog,$theErrorLog,$theTime,$theExitCode,$theFileCount,$theLocation,$theName)
;
;	Creates Output File
;
;	$theLog = 		Array;  	Output from Rar.exe
;	$theErrorLog =	Array;  	Error Output from Rar.exe
;	$theTime = 		Integer; 	Runtime for Rar.exe in ms
;	$theExit = 		Integer; 	Exit Code for Rar.exe
;	$theFileCount = Integer;	Return from CountFiles()
;   $theLocation = 	String;		Path to backup dir
;	$theName =		String;		Filename of .rar file
;
	Local $theData, $theSuffix = ''
	If _ArraySearch($theLog,"WARNING: No files") > -1 Then
		$theSuffix = '-NoAction'
		Dim $theLog[3] = ['','','WARNING: No files']
	EndIf

	If IsArray($theErrorLog) Then ;put errors at top of file
		$theSuffix &= '-Errors'
		$theErrorLog[0] = 'Errors: '
		$TheData = Create_Header($theErrorLog,$theTime,$theExitCode,$theFileCount)
		_ArrayConcatenate($TheData,$theLog) ;add Rar output to the Error Log
	Else
		$TheData = Create_Header($theLog,$theTime,$theExitCode,$theFileCount)
	EndIf
	_FileWriteFromArray($theLocation & StringTrimRight ( $theName, 4 ) & '_' & @Mon & '-' & @MDay & '-' & @Year & $theSuffix & '.log',$TheData)
EndFunc

Func FormatLog($theLog)
;
;	Formats Output from Rar.exe
;		Removes: Backspace Chacters, ' OK ', 'xxx%', and empty elements
;
;	$theLog = 		Array;  	Output from Rar.exe
;
	Local $PerLoc, $TMP
	If _ArraySearch($theLog,"WARNING: No files") > -1 Then
		Dim $theReturn[3] = ['','','WARNING: No files']
		Return $theLog
	EndIf
	While StringInStr($theLog[0],"ing archive") < 1 ;remove Rar header upto either 'UPDATing ...' Or 'ADDing ...'
		  _ArrayDelete($theLog,0)
	WEnd
	For $i = 0 to UBound($theLog)-1
		$TMP = StringReplace($theLog[$i],'',"") 	;removes BackSpace character codes
		$TMP = StringReplace($TMP, ' OK ','') 		;removes OK from End Of Line
		while StringInStr($TMP,"%") 				;removes xxx%
			$PerLoc = StringInStr($TMP,"%")
			$TMP = StringReplace($TMP,StringMid($TMP,$PerLoc-3,4),"")
		wend
		$theLog[$i] = $TMP
	Next
	Return $theLog
EndFunc

Func CountFiles($theFileList)
;
;	Creates Output File Header
;
;	$theFileList = 	Array;  	Output from Rar.exe
;
	Local $CntAdd, $CntUpd
	$CntAdd = _ArrayFindAll($theFileList,'Adding  ','','','',1)
	$CntUpd = _ArrayFindAll($theFileList,'Updating  ','','','',1)
	Return Ubound($CntAdd)+Ubound($CntUpd)
EndFunc
