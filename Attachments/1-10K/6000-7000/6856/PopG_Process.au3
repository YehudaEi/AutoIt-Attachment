; PopG_Process.au3 - Andy Swarbrick (c) 2005-6
#region		Doc:
#region		Doc: Notes
	; Extends functionality of Process functions.
	; Typically this is in the area of supporting Windows Terminal Services.
#endregion	Doc: Notes
#region		Doc: History
; 05-Feb-06 Als Added envupdate to _IsConnected to try to try to ensure this works reliably.
#endregion	Doc: History
#region		Doc: FunctionList
; _IsConnected							Returns true if this session is connected.
; _ProcessExistsTs						Checks if a process exists, returning a PID if found.  Works on Terminal Services.
; _ProcessListTs						Returns an array of processes as per _ProcessList.  Works on Terminal Services.
; _IsTerminalServer						Returns True if this server is running Terminal Services.
#endregion	Doc: FunctionList
#endregion	Doc:
#region		Init:
#region		Init: Includes
	#include-once
	#include <File.au3>
	#include '..\PopGincl\PopG_MsgBox.au3'
	#include '..\PopGincl\PopG_Reg.au3'
	#include '..\PopGincl\PopG_Run.au3'
	#include '..\PopGincl\PopG_Array.au3'
	#include <GUIConstants.au3>
#endregion	Init: Includes
#region		Init: Autoit options
	Opt('MustDeclareVars',True)
	Opt('RunErrorsFatal',False)
#endregion	Init: Autoit options
#endregion	Init:
#region		Run:
#region		Run: Test Program (comment this out for production.)
;~ 	Local $AppNam='Test Program for PopG_Process.au3'
;~ 	If WinExists($AppNam) Then _MsgBoxExit($mbfStop, $AppNam,'Already Running')
;~ 	Local $msg,$Form1
;~ 	Local $PrcNam1='explorer.exe'
;~ 	Local $PrcNam2='explorer2.exe'
;~ 	Local $Arr[2][1]
;~ 	Local $Test_IsTerminalServer,$Test_ProcessExistsTs,$Test_ProcessListTs,$DoneBtn
;~ 	;
;~ 	$Form1 = GUICreate($AppNam, 250, 170, 192, 125)
;~ 	GUICtrlCreateLabel('Select from the functions below to initiate a test.',		10, 10, 251, 34)
;~ 	$Test_ProcessExistsTs		=GUICtrlCreateButton('$Test_ProcessExistsTs',		10, 40, 200, 21)
;~ 	GUICtrlSetTip($Test_ProcessExistsTs,'Click me to run two tests.'&@LF&'No1. If "'&$PrcNam1&'" is running'&@LF&'No2. If "'&$PrcNam2&'" is running')
;~ 	$Test_ProcessListTs			=GUICtrlCreateButton('$Test_ProcessListTs',			10, 70, 200, 21)
;~ 	GUICtrlSetTip($Test_ProcessListTs,'Click me to display the array of running prcesses.')
;~ 	$Test_IsTerminalServer	=GUICtrlCreateButton('$Test_IsTerminalServer',	10, 100, 200, 21)
;~ 	GUICtrlSetTip($Test_IsTerminalServer,'Click me to test if this is a terminal server.')
;~ 	$DoneBtn					=GUICtrlCreateButton('$DoneBtn', 					10, 130, 100, 21)
;~ 	GUISetState(@SW_SHOW)
;~ 	While 1
;~ 		$msg = GuiGetMsg()
;~ 		Select
;~ 		Case $msg = $Test_ProcessExistsTs
;~ 			MsgBox($mbfInfo,'$Test_ProcessExistsTs No1','result for "'&$PrcNam1&'" is '&_ProcessExistsTs($PrcNam1)&@LF&'If Gt 0 Then it was successful in finding the process.')
;~ 			MsgBox($mbfInfo,'$Test_ProcessExistsTs No2','result for "'&$PrcNam2&'" is '&_ProcessExistsTs($PrcNam2)&@LF&'If Gt 0 Then it was successful in finding the process.')
;~ 		Case $msg = $Test_ProcessListTs
;~ 			_ProcessListTs($Arr)
;~ 			_ArrayDisplay2($Arr,'Process List')
;~ 		Case $msg = $Test_IsTerminalServer
;~ 			If _IsTerminalServer() Then
;~ 				MsgBox($mbfInfo,'Test result for $Test_IsTerminalServer','This is a terminal server')
;~ 			Else
;~ 				MsgBox($mbfInfo,'Test result for $Test_IsTerminalServer','This is a not terminal server')
;~ 			EndIf
;~ 		Case $msg = $GUI_EVENT_CLOSE Or $msg=$DoneBtn
;~ 			ExitLoop
;~ 		Case Else
;~ 			;;;;;;;
;~ 		EndSelect
;~ 	WEnd
;~ 	Exit
#endregion	Run: Test Program
#region		Run: Functions
; _ProcessExistsTs						Checks if a process exists, returning a PID if found.  Works on Terminal Services.
Func _ProcessExistsTs($PrcNam1)
	If Not _IsTerminalServer() Then Return ProcessExists($PrcNam1)
	;
	Local $tspeOutArr[1],$tspeErrArr[1],$tspeLineSplit,$tspeLine
	_RunWaitSysOutErr('qprocess.exe '&$PrcNam1&' | more +1',@TempDir,@SW_HIDE,$tspeOutArr,$tspeErrArr)
	If @error Then Return 0
	If $tspeOutArr[0]=1 Then 
		$tspeLine=StringStripWS($tspeOutArr[1],7)
		$tspeLineSplit=StringSplit($tspeLine,' ')
		Return $tspeLineSplit[5]
	EndIf
	Return -1
EndFunc ; _ProcessExistsTs
; _ProcessListTs						Returns an array of processes as per _ProcessList.  Works on Terminal Services.
Func _ProcessListTs(ByRef $tsplArgArr)
	If Not _IsTerminalServer() Then Return ProcessList($tsplArgArr)
	;
	If Not IsArray($tsplArgArr) Then Return -1
	Local $tsplOutArr[1],$tsplErrArr[1],$tsplLine,$tsplIdx
	ReDim $tsplArgArr[2][1]
	_RunWaitSysOutErr('qprocess.exe | more +1',@TempDir,@SW_HIDE,$tsplOutArr,$tsplErrArr)
	For $tsplIdx=1 To $tsplOutArr[0]-1
		ReDim $tsplArgArr[2][$tsplIdx+1]
		$tsplOutArr[$tsplIdx]=StringStripWS($tsplOutArr[$tsplIdx],7)
		$tsplLine=StringSplit($tsplOutArr[$tsplIdx],' ')
		$tsplArgArr[0][$tsplIdx]=$tsplLine[4]
		$tsplArgArr[1][$tsplIdx]=$tsplLine[5]
	Next
	$tsplArgArr[0][0]=UBound($tsplArgArr,1)+1
	$tsplArgArr[0][0]=0
EndFunc;_ProcessListTs
; _IsTerminalServer						Returns True if this server is running Terminal Services.
Func _IsTerminalServer()
   Local $ProductSuite,$PS
   $PS = RegRead ( $HklmSysCcsCtl & '\ProductOptions', 'ProductSuite' )
      Select
         Case StringInStr($PS, 'Terminal Server')
            Return True
         Case Else
            SetError(1)
            Return False
      EndSelect
EndFunc	; _IsTerminalServer()
;	_ProcessExistsTsForMe
; Notes:
; 1. Uses a temp file and qprocess.exe
; 2. Pipe qprocess output, filtered for this process, to temp file
; 3. Returns PID if process exists, else false (ie 0)
; 4. @error=4 if invalid process name, 3=not running on terminal server, 2=qprocess.exe not found, 1=process not found, 0=ok
; 5. Result=0 if process not found, gt 0 is the valid pid for this process.
; Vars:
; $tf - temp file
; $tl - temp file line
; $r - result
; $p - process name, eg userinit.exe
; $q - qprocess.exe in system32.  Run with no arguments it returns a list of processes for this user.
; returns true if the process exists and this is a terminal server
; History:
; 13-Dec-05 001 Als Created
Func _ProcessExistsTsForMe($p)
	Local $tf, $r, $q, $tl, $pl, $ta
	If StringRight($p,4) <> '.exe' Then ; stop nonsense if this is not a process name.
		SetError (4)
		Return False
	EndIf
	If Not _IsTerminalServer() Then ; Only allow this to run on terminal server!
		SetError (3)
		Return False
	EndIf
	$q = @SystemDir & '\qprocess.exe'
	If Not FileExists ($q) Then
		SetError (2)
		Return False
	EndIf
	$tf = _TempFile ()
	; 'find /i' is a case-independent search.
	RunWait (@ComSpec & ' /c '&$q&'|find /i ''&$p&'' >'&$tf, @TempDir, @SW_HIDE)
	If FileGetSize ($tf) = 0 Then 
		SetError (1)
		$r = False
	Else
		$tl = FileReadLine ($tf)
		$tl = StringStripWS ($tl,4)
		$ta = StringSplit ($tl,' ') ; returns $ta as an array with [0] as number of entries, and $ta[$ta[0]] as last and so $ta[0]-1 as PID column.
		$r = $ta[($ta[0]-1)]
		MsgBox (0,'_ProcessExistsTsForMe', 'tl='&$tl&@LF&',ta0='&$ta[0]&',ta[n-1]='&$r)
	EndIf
	FileDelete ($tf)
	Return $r
EndFunc ;_ProcessExistsTsForMe
; _IsConnected							Returns true if this session is connected.
Func _IsConnected()
	EnvUpdate()
	Return EnvGet('sessionname')<>''
EndFunc ; _IsConnected
#endregion	Run: Functions
#endregion	Run:
