#include <Timers.au3>
#include <File.au3>
#include <Array.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiComboBox.au3>
#include <Constants.au3>
$Form1_1 = GUICreate("Form1", 																			623, 	157, 	192, 	114)
$Input1 = GUICtrlCreateInput("c:\backup\", 																8, 		0, 		545, 	21)
GUICtrlSetTip(-1, "Location of the back up files.")
$Button1 = GUICtrlCreateButton("Locate", 																560, 	0, 		57, 	21)
$Input2 = GUICtrlCreateInput("Drafting.rar", 															8, 		24, 	545, 	21)
GUICtrlSetTip(-1, "Filename of the .rar file.")
$Button2 = GUICtrlCreateButton("Locate", 																560, 	24, 	57, 	21)
$Input3 = GUICtrlCreateInput("C:\Progra~1\WinRAR\rar.exe", 												8, 		48, 	545, 	21)
GUICtrlSetTip(-1, "Location of rar/unrar.exe.")
$Button3 = GUICtrlCreateButton("Locate", 																560, 	48, 	57, 	21)
$Input4 = GUICtrlCreateInput("-r -rr5p -x*.bak -x*.dwl -xplot.log -xthumbs.db -x*\0_Temp_Saves_0\", 	8, 		72, 	545, 	21)
GUICtrlSetTip(-1, "Rar.exe command line paramaters.")
$Combo1 = GUICtrlCreateCombo("h:\drafting\*.*", 														8, 		96, 	545, 	21, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetTip(-1, "Location of the files to back up.")
$Button4 = GUICtrlCreateButton("Locate", 																560, 	96, 	57, 	21)
$Input5 = GUICtrlCreateInput("1", 																		8, 		120, 	48, 	21)
GUICtrlSetTip(-1, "Wait for the pc to idle before starting back up (In Hours).")
$Label1 = GUICtrlCreateLabel("Idle Before Back Up", 												60, 	120, 	80, 	32)
$Input6 = GUICtrlCreateInput("12", 																		148, 	120, 	48, 	21)
GUICtrlSetTip(-1, "Time out before back up can begin again (In Hours).")
$Label2 = GUICtrlCreateLabel("Sleep After Back Up", 												200, 	120, 	72, 	32)
$Button5 = GUICtrlCreateButton("Cancel", 																503, 	120, 	57,	 	21)
$Button6 = GUICtrlCreateButton("Save", 																	560, 	120, 	57, 	21)

GUICtrlCreateUpdown($input5)
GUICtrlCreateUpdown($input6)


HotKeySet("{PRINTSCREEN}", "LaunchBackUp")
HotKeySet("{SCROLLLOCK}", "OpenOutput")
HotKeySet("{PGUP}", "OpenGUI")
Local Const $iHour = 3600000
Local $sBackUpDir = 'c:\backup\'			;Location of new .rar file
Local $sRarFile = 'Drafting.rar'			;Name of new .rar file
Local $sSRC = 'h:\drafting\*.*'				;Directory with files to back up
Local $sEXE = 'C:\Progra~1\WinRAR\rar.exe'	;location of rar.exe
Local $iBUStart = 1 						;time to start back-up: 24hr format
Local $iBUEnd = 8 							;time to stop trying to start back up: 24hr format
Local $iIdleTime = 1*$iHour 				;Required Idle Time before starting Back-Up
Local $iSleepTime = 10*$iHour
Local $sDST = $sBackUpDir & $sRarFile
Global $sOutPath
Local $iRTime = 0
local $sOPT_User
local $iSleepStart = TimerInit()
$iSleepTime_Const = 0
$iOn = 0
LoadFromINI()
RefreshVars()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			OpenGUI();Exit
		Case $Button5
			OpenGUI()
		Case $Button1
			$sTmp = FileSelectFolder ( "Select the location for back up files", '' ,7 )
			If Not @error Then
				GuiCtrlSetData($Input1,$sTmp & '\')
			EndIf
		Case $Button2
			$sTmp = FileOpenDialog ( 'Select the rar file to update.'&@CRLF&'Type a file name to create a new rar back up', GUICtrlRead($Input1), "RAR (*.rar)" ,'', "BackUp"  )
			If Not @error Then
				$i = StringInStr($sTmp,'\')
				While $i > 0
					$sTmp = StringMid($sTmp,$i + 1)
					$i = StringInStr($sTmp,'\')
				WEnd
				IF Not StringInStr(StringRight($sTmp,4), '.rar') Then
					$sTmp = $sTmp&'.rar'
				EndIf
				GuiCtrlSetData($Input2,$sTmp)
			EndIf
		Case $Button3
			ConsoleWrite(StringReplace(GUICtrlRead($Input3),'rar.exe','')& @CRLF)
			$sTmp = FileOpenDialog ( 'Select the location of rar.exe.', StringReplace(GUICtrlRead($Input3),'rar.exe',''), "RAR (rar.exe)" ,'', "rar.exe"  )
			If Not @error Then
				GuiCtrlSetData($Input3,$sTmp)
			EndIf
		Case $Button4
			$sTmp = FileSelectFolder ( "Select the location of files for back up", '' ,6 )
			If Not @error Then
				_GUICtrlComboBox_AddString($Combo1,$sTmp & '\*.*')
				_GUICtrlComboBox_SelectString($Combo1, $sTmp & '\*.*')
			EndIf
		Case $Button6
			Local $sIni = @ScriptDir & "\BackUp.ini"
			ConsoleWrite("Saving to INI"&@CRLF)
			Local $aData2[7][2] = [	[0,0] , ["BU_Dir", GUICtrlRead($Input1)],["BU_File", GUICtrlRead($Input2)],["RAR_Exe", GUICtrlRead($Input3)],["RAR_Opt", GUICtrlRead($Input4)], ["Slp_Pre", GUICtrlRead($Input5)], ["Slp_Pst", GUICtrlRead($Input6)] ]
			IniWriteSection($sIni, _GUICtrlComboBox_GetEditText($Combo1), $aData2)
			RefreshVars()
		Case $Combo1
			LoadFromINI()
	EndSwitch
	;
	Sleep(1)
	If @HOUR > $iBUStart and _  ;add timer and gate for sleep after
		@HOUR < $iBUEnd and _
		  $iSleepTime_Const <= timerDiff($iSleepStart) and _
		    _Timer_GetIdleTime() > $iIdleTime then ;OR NOT FileExists($sDST) then ;use to create back-up @ runtime
		Main()
		$iSleepStart = TimerInit()
		$iSleepTime_Const = $iSleepTime
		ConsoleWrite(_Timer_GetIdleTime()&@TAB&$iIdleTime&@TAB&$iSleepTime_Const&@TAB&timerDiff($iSleepStart)&@CRLF)
	EndIf
	;ConsoleWrite(_Timer_GetIdleTime()&@TAB&$iIdleTime&@TAB&$iSleepTime_Const&@TAB&timerDiff($iSleepStart)&@CRLF)
WEnd

Func OpenGUI()
	If $iOn Then
		GUISetState(@SW_HIDE)
		$iOn = 0
	Else
		GUISetState(@SW_SHOW)
		$iOn = 1
	EndIf
EndFunc

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
RefreshVars()
		ConsoleWrite('Func Main() ' & @CRLF)
		Local $iDoUpdate
		If Not FileExists($sDST) Then ;add files to new  .rar
			$iDoUpdate = 0
			$sOPT = ' a -tl ' & $sOPT_User & ' -ilog' & $sBackUpDir & 'error.log '  & $sDST & ' ' & $sSRC ; command line options here
		Else ;update/add files to existing  .rar
			If Not FileExists($sBackUpDir & 'UpdateList.lst') Then
				$iDoUpdate =  CreateFileList($sBackUpDir,$sDST,$sSRC)
			EndIf
			$sOPT = ' u -tl ' & $sOPT_User & ' -ilog' & $sBackUpDir & 'error.log '  & $sDST & ' @' & $sBackUpDir & 'UpdateList.lst' ;& $sSRC ; command line options here
		EndIf
		ConsoleWrite('$sOPT ' & $sOPT & @CRLF)
		If $iDoUpdate Then
			Local $aReturnLogs = DoBackUp ($sEXE , $sOPT , $sBackUpDir)
			$aLog = FormatLog($aReturnLogs[2])
			$aLogErr = $aReturnLogs[3]
			$iFileCount = CountFiles($aLog)
			$sOutPath = Create_File($aLog,$aLogErr,Time_Convert($aReturnLogs[1]),$aReturnLogs[0],$iFileCount,$sBackUpDir,$sRarFile)
			;FileDelete($sBackUpDir & 'UpdateList.Lst')
		Else
			MsgBox(0,"Alert","No files to update.",20)
			Dim $aDumLog[1] = ["WARNING: No files"]
			Create_File($aDumLog,default,0,10,0,$sBackUpDir,$sRarFile)
		EndIf

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
	Local $sCommand = 'dir '&$sSRC&' /T:w /x /s /O:d > ' & $sOutPath & 'UpdateList.lst'
	ConsoleWrite($sCommand& @CRLF)
	RunWait(@ComSpec & ' /c ' & $sCommand, @TempDir, @SW_HIDE)
	_FileReadToArray($sOutPath & 'UpdateList.lst',$aFileLog)
	FileDelete($sOutPath & 'UpdateList.lst')
	While StringInStr($aFileLog[0]," Directory of") < 1 				;delete array until first directory structure
		_ArrayDelete($aFileLog,0)
	WEnd
	For $i = 0 to Ubound($aFileLog) -1

		If 	StringInStr($aFileLog[$i],'Directory of ') > 0 Then 		;Set File Directory
			$sTempDir = StringReplace($aFileLog[$i],' Directory of ','') & '\'
			;ConsoleWrite('$sTempDir' & $i & ' ' & $sTempDir & @CRLF)
		EndIf
		If 	StringInStr($aFileLog[$i],'/' & $aStdTime[2] ) > 0 And _	; If file was made in same year as rar file
				StringInStr($aFileLog[$i],"<DIR>") < 1 then				; and is not a directory
			$aCurDate = StringSplit( StringLeft($aFileLog[$i],10),'/',2)	;capture the date of the file save
			If StringMid( $aFileLog[$i], 19, 2 ) = "PM" Then
				$iHalfDay = 12
			Else
				$iHalfDay = 0
			EndIf
			_arrayAdd($aCurDate,StringMid( $aFileLog[$i], 13, 2 ) + $iHalfDay) 		;capture the hour of the file save
			If $aCurDate[0] >= $aStdTime[0] Then
				If $aCurDate[1] > $aStdTime[1] OR ($aCurDate[1] = $aStdTime[1] And $aCurDate[3] > $aStdTime[3]) Then 				;Add File if newer than backup file
						_ArrayAdd($aFinalFileList,FileGetShortName($sTempDir& StringMid($aFileLog[$i],53)))
						;ConsoleWrite('Dates '& _ArrayToString($aCurDate) & ' ### ' & _ArrayToString( $aStdTime ) & @CRLF)

				EndIf
			EndIf
		EndIf
	Next
	;_ArrayDisplay($aFinalFileList)
	_ArrayDelete($aFinalFileList,0)
	_FileWriteFromArray(FileGetShortName($sOutPath & "UpdateList.lst"),$aFinalFileList)
	Return IsArray($aFinalFileList)
EndFunc

Func LoadFromINI()
;
;	Loads Values from INI based on Combobox selection
;
;	$theFileList = 	Array;  	Output from Rar.exe
;
ConsoleWrite("LoadFromINI "&@CRLF)
	If FileExists(@ScriptDir & "\BackUp.ini" ) Then
		$aIniSecNames = IniReadSectionNames ( @ScriptDir & "\BackUp.ini" )
		If Not @error Then
			_ArrayDelete($aIniSecNames,0)
			_GUICtrlComboBox_DeleteString($Combo1,0)
			GUICtrlSetData($Combo1,StringReplace(_ArrayToString($aIniSecNames),"?",''),$aIniSecNames[1])
						$aIniValues = IniReadSection ( @ScriptDir & "\BackUp.ini", _GUICtrlComboBox_GetEditText($Combo1) )
						If Not @error Then
							GUICtrlSetData($Input1,$aIniValues[1][1])
							GUICtrlSetData($Input2,$aIniValues[2][1])
							GUICtrlSetData($Input3,$aIniValues[3][1])
							GUICtrlSetData($Input4,$aIniValues[4][1])
							GUICtrlSetData($Input5,$aIniValues[5][1])
							GUICtrlSetData($Input6,$aIniValues[6][1])
							;ConsoleWrite($aIniValues[0][1]&@CRLF)
						EndIf
		EndIf
	EndIf
EndFunc

Func RefreshVars()
	ConsoleWrite("RefreshVars "&@CRLF)
	$sBackUpDir		= GuiCtrlRead($Input1)
	$sRarFile		= GuiCtrlRead($Input2)
	$sEXE			= GuiCtrlRead($Input3)
	$sOPT_User 		= GuiCtrlRead($Input4)
	$iIdleTime 		= number(GUICtrlRead($Input5))*$iHour
	$sSRC 			= StringTrimRight(_GUICtrlComboBox_GetEditText($Combo1),1)
	$iSleepTime 	= GUICtrlRead($Input6)*$iHour
	;$iBUStart 		= 								; redo gui to add these
	;$iBUEnd		=

	$iSleepTime_Const = $iSleepTime
EndFunc
