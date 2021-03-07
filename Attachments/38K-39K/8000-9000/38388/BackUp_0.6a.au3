#include <Timers.au3>
#include <File.au3>
#include <Array.au3>
HotKeySet("{PRINTSCREEN}", "LaunchBackUp")
HotKeySet("{SCROLLLOCK}", "OpenOutput")
Local Const $iHour = 3600000
Local $sBackUpDir = 'c:\backup\'			;Location of new .rar file
Local $sRarFile = 'Drafting.rar'			;Name of new .rar file
Local $sSRC = 'h:\drafting\*.*'				;Directory with files to back up
Local $sEXE = 'C:\Progra~1\WinRAR\rar.exe'	;location of rar.exe
Local $sEXE_UnRar = 'C:\Progra~1\WinRAR\UnRaR.exe'
Local $iBUStart = 1 						;time to start back-up: 24hr format
Local $iBUEnd = 8 							;time to stop trying to start back up: 24hr format
Local $iIdleTime = 1.0*$iHour 				;Required Idle Time before starting Back-Up
Local $sDST = $sBackUpDir & $sRarFile
Global $sOutPath
Local $iRTime = 0
While 1
	$iIdleTime = _Timer_GetIdleTime()
	If @HOUR > $iBUStart and @HOUR < $iBUEnd and _Timer_GetIdleTime() > $iIdleTime then ;OR NOT FileExists($sDST) then ;use to create back-up @ runtime
		Main()
	EndIf
	Sleep(0.5 * $iHour)
WEnd

Func OpenOutput ()
	If StringLen ($sOutPath) > 0 Then
		Run('notepad.exe ' & $sOutPath)
	Else
		MsgBox(0,'Alert','No backup log generated.')
		;do a file open dialog in backup dir
	EndIf
EndFunc

Func LaunchBackUp()
	$iReturn = MsgBox(4,'Alert','Run BackUp Now?')
	If $iReturn = 7 then
		MsgBox(0,'Alert','BackUp Cancelled',3)
	Else
		Main()
	EndIf
EndFunc

Func Main()
		ConsoleWrite('Func Main() ' & @CRLF)
		If Not FileExists($sDST) Then ;add files to new  .rar
			$iDoUpdate = 1
			$sOPT = ' a -ilog' & $sBackUpDir & 'error.log -tl -r -rr5p -v4500000 -x*.bak -x*.dwl -xplot.log -xthumbs.db -x*\0_Temp_Saves_0\ ' & $sDST & ' ' & $sSRC ; command line options here
		Else ;update/add files to existing  .rar
			If Not FileExists($sBackUpDir & 'UpdateList.lst') Then
				$iDoUpdate =  CreateFileList($sBackUpDir,$sDST,$sSRC)
			EndIf
			$sOPT = ' u -ilog' & $sBackUpDir & 'error.log -tl -r -rr5p -v4500000 -x*.bak -x*.dwl -xplot.log -xthumbs.db -x*\0_Temp_Saves_0\ ' & $sDST & ' @' & $sBackUpDir & 'UpdateList.lst' ;& $sSRC ; command line options here
		EndIf
		If $iDoUpdate Then
			Local $aReturnLogs = DoBackUp ($sEXE , $sOPT , $sBackUpDir)
			$aLog = FormatLog($aReturnLogs[2])
			$aLogErr = $aReturnLogs[3]
			$iFileCount = CountFiles($aLog)
			$sOutPath = Create_File($aLog,$aLogErr,Time_Convert($aReturnLogs[1]),$aReturnLogs[0],$iFileCount,$sBackUpDir,$sRarFile)
			FileDelete($sBackUpDir & 'UpdateList.Lst')
		Else
			MsgBox(0,"Alert","No files to update.",20)
			Dim $aDumLog[1] = ["WARNING: No files"]
			Create_File($aDumLog,default,0,10,0,$sBackUpDir,$sRarFile)
		EndIf
		Sleep(12 * $iHour)
EndFunc

Func DoBackUp ($sEXE , $sOPT , $sBackUpDir)
	ConsoleWrite('Func DoBackUp ($sEXE , $sOPT , $sBackUpDir)' & @CRLF)
	Local $aLog
	Local $aLogErr
	Local $aReturn[4]
	Local $iRStart 		= _Timer_Init()
	$aReturn[0] 		= RunWait(@ComSpec & ' /c ' & $sEXE & ' ' & $sOPT & ' > ' & $sBackUpDir & 'output.tmp', @TempDir, @SW_HIDE)
	$aReturn[1] 		= _Timer_Diff($iRStart)
	_FileReadToArray($sBackUpDir & 'output.tmp',$aLog)
	FIleDelete($sBackUpDir & 'output.tmp')
	$aReturn[2] = $aLog
	If FileExists ($sBackUpDir & 'error.log') Then
		_FileReadToArray($sBackUpDir & 'error.log',$aLogErr)
		FIleDelete($sBackUpDir & 'error.log')
		$aReturn[3] = $aLogErr
	Else
		$aReturn[3] = Default
	EndIf
	Return $aReturn
EndFunc

Func Time_Convert($iTimeDiff)
	ConsoleWrite('Func Time_Convert($iTimeDiff)' & @CRLF)
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
ConsoleWrite('Func Create_Header($theLog,$theTime,$theExit,$theFileCount)' & @CRLF)
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
	If $theExit > Ubound($aExitDesc) Then
		$sExitDesc = 'User break.'
	Else
		$sExitDesc = $aExitDesc[$theExit]
	EndIf
	$theLog[0] = 'Update Time: ' & $theTime & @TAB & 'File Count: '& $theFileCount
	$theLog[1] = 'Exit Code: ' & $theExit & ' ' & $sExitDesc
	Return $theLog
EndFunc

Func Create_File($theLog,$theErrorLog,$theTime,$theExitCode,$theFileCount,$theLocation,$theName)
ConsoleWrite('Func Create_File($theLog,$theErrorLog,$theTime,$theExitCode,$theFileCount,$theLocation,$theName)' & @CRLF)
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
	Local $sFile = $theLocation & StringTrimRight ( $theName, 4 ) & '_' & @Mon & '-' & @MDay & '-' & @Year & $theSuffix & '.log'
	_FileWriteFromArray($sFile,$TheData)
	Return $sFile
EndFunc

Func FormatLog($theLog)
ConsoleWrite('Func FormatLog($theLog)' & @CRLF)
;
;	Formats Output from Rar.exe
;		Removes: Backspace Chacters, ' OK ', 'xxx%', and empty elements
;
;	$theLog = 		Array;  	Output from Rar.exe
;
	Local $PerLoc, $TMP
	If _ArraySearch($theLog,"WARNING: No files") > -1 Then
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
ConsoleWrite('Func CountFiles($theFileList)' & @CRLF)
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

Func CreateFileList($sOutPath,$sTheFile,$sSRC)
;
;	Finds New Files to BackUp
;
;	$sOutPath = 	String;  	Output directory
;	$sTheFile =		String;  	the file to use for time compare
;	$sSRC =			String;		The source for files to be backed up
;
;	!!!!!!!! -tl !!!!!!! This must stay in the options for rar.exe
;	This sets the rar's time to the most recently updated file
;	Anything newer than that file gets updated
;
ConsoleWrite('Func CreateFileList($sOutPath,$sTheFile)' & @CRLF)
	Local $aFileLog[1]
	Local $aFinalFileList[1]
	Local $sTempDir
	Local $aCurDate
	$aStdTime = FileGetTime ($sTheFile); Get the latest file time from rar file
	_ArrayDelete($aStdTime,5)
	$aStdTime[4] = $aStdTime[3]
	$aStdTime[3] = $aStdTime[0]
	_ArrayDelete($aStdTime,0)
	Local $sCommand = 'dir '&$sSRC&'*.* /T:w /x /s /O:d > ' & $sOutPath & 'UpdateList.lst'
	RunWait(@ComSpec & ' /c ' & $sCommand, @TempDir, @SW_HIDE)
	_FileReadToArray($sOutPath & 'UpdateList.lst',$aFileLog)
	FileDelete($sOutPath & 'UpdateList.lst')
	While StringInStr($aFileLog[0]," Directory of") < 1 				;delete array until first directory structure
		_ArrayDelete($aFileLog,0)
	WEnd
	For $i = 0 to Ubound($aFileLog) -1
		If 	StringInStr($aFileLog[$i],' Directory of ') > 0 Then 		;Set File Directory
			$sTempDir = StringReplace($aFileLog[$i],' Directory of ','') & '\'
		EndIf
		If 	StringInStr($aFileLog[$i],'/' & $aStdTime[2] ) > 0 And _	; If file was made in same year as rar file
				StringInStr($aFileLog[$i],"<DIR>") < 1 then				; and is not a directory
			$aCurDate = StringSplit( StringLeft($aFileLog[$i],10),'/')	;capture the date of the file save
			If StringMid( $aFileLog[$i], 19, 2 ) = "PM" Then
				$iHalfDay = 12
			Else
				$iHalfDay = 0
			EndIf
			_arrayAdd($aCurDate,StringMid( $aFileLog[$i], 13, 2 ) + $iHalfDay) 		;capture the hour of the file save
			_ArrayDelete($aCurDate,0)
			If $aCurDate[0] >= $aStdTime[0] Then
				If $aCurDate[1] >= $aStdTime[1] Then
					If $aCurDate[3] > $aStdTime[3] Then 				;Add File if newer than backup file
						_ArrayAdd($aFinalFileList,FileGetShortName($sTempDir& StringMid($aFileLog[$i],53)))
					EndIf
				EndIf
			EndIf
		EndIf
	Next
	_ArrayDelete($aFinalFileList,0)
	_FileWriteFromArray(FileGetShortName($sOutPath & "UpdateList.lst"),$aFinalFileList)
	Return IsArray($aFinalFileList)
EndFunc