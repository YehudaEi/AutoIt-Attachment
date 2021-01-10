#cs

	AutoIt Installer Core
	---------------------

#ce

#include <Constants.au3>
#include <File.au3>
#include <Array.au3>
#Include <Misc.au3>

$bDebug = True

$sLogPath = _Iif(DriveGetType(@ScriptDir) = "CDROM", @MyDocumentsDir & "\Log\", "..\Log\")

DirCreate($sLogPath)

$sLogFile = $sLogPath & @ComputerName & "-" & @UserName & ".log"

_Log("-------------------------------------------------------", 0)
_Log(@OSVersion & " " & @OSServicePack & " Build: " & @OSBuild, 0)

$iCmdDelayInLoopMSec = 800
$iDefaultTimoutWinWaitSec = 7

Dim $gFF  ;FileFind*()
Dim $gRR1, $gRR2, $gRR3  ;RegRead()

;======================================================= Commands ===============================================
;
;  ww = WinWaitActive(3, +cmds)  cc = ControlCommand(5)  ck = ControlClick(7)  sd = Send(2)  pc = ProcessClose(1)
;
;  dm = DirMove(2)  fm = FileMove(2)  dr = DirRemove(1)  fd = FileDelete(1)  ff = FileFind(1, ret:$gFF)
;
;  rk = RegDelete(key)  rv = RegDelete(key, value)  rr = RegRead(2, gRR1|2|3 w.o.'$')
;
;  rl = _RunLog(3)  x1 = eXtra#
;
;================================================================================================================

If Not $CmdLine[1] Then _Log('No command line param!', 1)

$sInstDir = ".\" & $CmdLine[1]
$sDestDir = @ProgramFilesDir

$a  = ''
$a &= ',  , , , , , , ,'
$a &= ',  , , , , , , ,'
$a &= ',  , , , , , , ,'
$a &= ',  , , , , , , ,'
$a &= ',  , , , , , , ,'
$a &= ',  , , , , , , ,'
$a &= ',  , , , , , , ,'
$a &= ',  , , , , , , ,'
$a &= ',  , , , , , , ,'
$a &= ',  , , , , , , ,'
$a &= ',  , , , , , , ,'
$a &= ',  , , , , , , ,'
$a &= ',  , , , , , , ,'
$a &= ',  , , , , , , ,'
$a &= ',  , , , , , , ,'
$a &= ',  , , , , , , ,'
$a &= ',  , , , , , , ,'
$a &= ',  , , , , , , ,'
$a &= ',  , , , , , , ,'
$a &= ',  , , , , , , ,'

;=================================================================================================================

$aAll = StringSplit($a, ',')

Dim $aCmd[Ceiling($aAll[0] / 8)][8]

$i = 1
For $y = 0 To 999
	For $x = 0 To 7
		$aCmd[$y][$x] = StringStripWS($aAll[$i], 1 + 2)  ;leading + trailing
		$i += 1
		If $i > $aAll[0] Then ExitLoop 2
	Next
Next

If $bDebug Then _ArrayDisplay($aCmd)

For $cnt = 0 To UBound($aCmd) - 1
	Dim $p0 = $aCmd[$cnt][0], $p1 = $aCmd[$cnt][1], $p2 = $aCmd[$cnt][2], $p3 = $aCmd[$cnt][3]
	Dim $p4 = $aCmd[$cnt][4], $p5 = $aCmd[$cnt][5], $p6 = $aCmd[$cnt][6], $p7 = $aCmd[$cnt][7]

	Switch $p0
		Case "ww"
			If Not $p3 Then $p3 = $iDefaultTimoutWinWaitSec

			If Not WinWaitActive($p1, $p2, $p3) Then
				If Not $p4 Then _Log("TimeOut: " & $p1 & " - " & $p2, 1)
				
				$cnt += $p4  ;jump in cmd list
			EndIf

		Case "cc"
			ControlCommand($p1, $p2, $p3, $p4, $p5)

		Case "ck"
			If Not $p5 Then $p5 = 1  ;single-click
			ControlClick($p1, $p2, $p3, $p4, $p5, $p6, $p7)

		Case "sd"
			Send($p1, $p2)
		
		Case "pc"
			ProcessClose($p1)
			
		Case "dm"
			DirMove(Execute($p1), Execute($p2), 1)  ;overwrite
		
		Case "fm"
			FileMove(Execute($p1), Execute($p2), 1 + 8)  ;overwrite + create
		
		Case "dr"
			DirRemove(Execute($p1), 1)  ;files and dirs
		
		Case "fd"
			FileDelete(Execute($p1))
		
		Case "ff"
			$fh = FileFindFirstFile(Execute($p1))
			If $fh = -1 Then ContinueLoop

			$gFF = FileFindNextFile($fh)
			FileClose($fh)

		Case "rk"
			RegDelete($p1)  ;complete key
		
		Case "rv"
			RegDelete($p1, $p2)  ;single value, (Default) value is ""
		
		Case "rr"
			Assign($p3, RegRead($p1, $p2))  ;$gRR1-3, $p3 w.o.'$'!
		
		Case "rl"
			If $p3 = "0" Then $p3 = ""
			_RunLog(Execute($p1), Execute($p2), $p3)

		Case "x1"  ;special cases

		Case ""
			ExitLoop

		Case Else
			_Log("Invalid command: " & $p0, 1)
	EndSwitch

	Sleep($iCmdDelayInLoopMSec)
Next

_Log("Installation successful.", 0)

Func _Log($string, $exit)
	_FileWriteLog($sLogFile, $string)
	If $exit And $bDebug Then MsgBox(0x1000, "Error Log", $string)
	If $exit Then Exit
EndFunc

Func _RunLog($cmdline, $workdir, $wait)
	_Log($cmdline, 0)

	If $bDebug Then MsgBox(0x1000, "Params", "p1: " & $cmdline & @LF & "p2: " & $workdir & @LF & "p3: " & _Iif($wait, "WAIT", "NO WAIT"))

	Dim $rWait, $rRun
	If $wait Then
		$rWait = RunWait($cmdline, $workdir)
	Else
		$rRun = Run($cmdline, $workdir)
	EndIf
	
	If $bDebug Then MsgBox(0x1000, "Return", "Run: " & $rRun & @LF & "RunWait: " & $rWait & @LF & _Iif(@error, "Error!", "Ok."))

	If @error Then _Log("Execution error!", 1)

	Sleep(3000)
EndFunc
