#cs

	RunBlock Standalone Application
	-------------------------------
	
	Parameter: [-timeout <sec> [/force]] <cmdline_to_run>
	
	Timeout: max time blocking active
	Force: Ctrl+Alt+Del can't break the script!

#ce

#include <Constants.au3>
#include <BlockInputEx.au3>

$iTimeoutSec = 30  ;default
$bForce = False

If Not $CmdLine[0] Then Exit 1

$CmdLineRun = $CmdLineRaw

For $i = 1 To $CmdLine[0]
	$param = $CmdLine[$i]
	
	Switch StringLeft($param, 1)
		Case "-", "/"  ;option separators
			Switch StringTrimLeft($param, 1)
				Case "timeout"
					$i += 1
					
					If IsInt(Execute($CmdLine[$i])) Then $iTimeoutSec = Execute($CmdLine[$i])
					
					$CmdLineRun = StringTrimLeft($CmdLineRun, StringLen("-timeout ") + StringLen($CmdLine[$i]) + 1)
					
				Case "force"
					$bForce = True

					$CmdLineRun = StringTrimLeft($CmdLineRun, StringLen("-force "))
				
				Case Else
					MsgBox($MB_SYSTEMMODAL + $MB_ICONEXCLAMATION + $MB_OK, @ScriptName, "Invalid Parameter: " & @LF & $param, 8)
					
					Exit 1
			EndSwitch

		Case Else  ;start cmdline
			ExitLoop
	EndSwitch
Next

If $bForce Then
	_BlockInputEx(1)  ;UDF

	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer", "NoClose", 				"REG_DWORD", 1)
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer", "NoLogOff", 				"REG_DWORD", 1)
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System", 	 "DisableTaskMgr", 			"REG_DWORD", 1)
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System", 	 "DisableLockWorkstation", 	"REG_DWORD", 1)
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System", 	 "DisableChangePassword", 	"REG_DWORD", 1)

Else
	BlockInput(1)  ;regular AutoIt
EndIf

SplashTextOn("System Administrator Info", "Systemwartungsarbeiten." & @LF & "Bitte Rechner nicht ausschalten!", _
	360, 45, @DesktopWidth - 366, 0, 32, "Courier New", 11, 700)

$iPID = Run(StringStripWS($CmdLineRun, 1))  ;leading

If Not @error Then ProcessWaitClose($iPID, $iTimeoutSec)

If $bForce Then
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer", "NoClose", 				"REG_DWORD", 0)
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer", "NoLogOff", 				"REG_DWORD", 0)
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System",   "DisableTaskMgr", 			"REG_DWORD", 0)
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System",   "DisableLockWorkstation", 	"REG_DWORD", 0)
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System",   "DisableChangePassword", 	"REG_DWORD", 0)

	_BlockInputEx(0)
Else
	BlockInput(0)
EndIf

SplashOff()

Exit 0