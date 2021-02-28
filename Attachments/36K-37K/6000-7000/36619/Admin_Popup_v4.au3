#cs

Admin_Popup
Show computer information or launch shell when hotkey is pressed
-John Taylor
May-24-2005 (version 1)
Nov-08-2007 (version 2)
May-12-2010 (version 3) [1] commented out GP / regedit functionality   [2] updated RunAs() for AutoIt v3.3.4.0
Jul-28-2010 added crtl-alt-A to start Admin Tools
Feb-10-2012 update for Windows 7 UAC

#ce

#include <GUICONSTANTS.au3>
#include <EditConstants.au3>

#NoTrayIcon
;; #RequireAdmin

Opt ("GUIOnEventMode", 1)
Opt ("MustDeclareVars", 1)
Opt ("RunErrorsFatal", 0 )

Global $Info_Title="System Info v4"
Global $Shell_Title="Run Admin Tools"
Global $UsernameID
Global $PasswordID
Global $Shell_Win
Global $_In_Shell = 0

Global $reg_entry[10][3]
Global $reg_entry_last = 2

$reg_entry[0][0] = "HKCU\Software\Policies\Microsoft\Windows\System"
$reg_entry[0][1] = "DisableCMD"
$reg_entry[0][2] = ""

$reg_entry[1][0] = "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System"
$reg_entry[1][1] = "DisableTaskMgr"
$reg_entry[1][2] = ""

$reg_entry[2][0] = "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System"
$reg_entry[2][1] = "DisableRegistryTools"
$reg_entry[2][2] = ""

;; These do not work, unless you reboot the machine; therefore, making them useless...
;;
;; Prevent access to drives from My Computer
;$reg_entry[3][0] = "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
;$reg_entry[3][1] = "NoViewOnDrive"
;$reg_entry[3][2] = ""             ;0x03ffffff means restrict all drives

; Hide these specified drives from My Computer
;$reg_entry[4][0] = "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
;$reg_entry[4][1] = "NoDrives"
;$reg_entry[4][2] = ""             ;0x03ffffff means restrict all drives


HotKeySet("^!~", "OnInfo")                ; control alt ~
HotKeySet("^!A", "OnAdminTools")          ; control alt A   (not lowercase A)
HotKeySet("+^!{TAB}", "OnAdminTools")     ; shift control alt tab

;MsgBox(0,"isadmin()", isadmin())
if IsAdmin() then
	;MsgBox(0,"Info", "isadmin if stmt")
	AdminTools()
	exit
endif

WaitForever()

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

func _ReduceMemory($i_PID = -1)
	if $i_PID <> -1 then
		local $ai_Handle = dllcall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $i_PID)
		local $ai_Return = dllcall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
		dllcall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
	else
		local $ai_Return = dllcall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
	endif
	return $ai_Return[0]
endfunc

func WaitForever()
	_ReduceMemory()
	while 1
		sleep(500)
	wend
endfunc

func OnAdminTools()
	Local $SubmitID
	$_In_Shell = 1

	$Shell_Win = GUICreate($Shell_Title, 270, 150)
	GUISetState ()

	GUICtrlCreateLabel ("Username:", 10, 30 )
	$UsernameID = GUICtrlCreateInput ("AdminAcct", 65, 30, 120)

	GUICtrlCreateLabel ("Password:", 10, 60 )
	$PasswordID = GUICtrlCreateInput ("", 65, 60, 120, -1, $ES_PASSWORD)

	$SubmitID = GUICtrlCreateButton("OK", 10, 90, 60)
	GUICtrlSetOnEvent($SubmitID,"OnSubmit")

	GUISetOnEvent($GUI_EVENT_CLOSE,"OnExit")
	ControlFocus($Shell_Title, "", $PasswordID)

	_ReduceMemory()
	while 1 = $_In_Shell 
		sleep(1000)
	wend
endfunc
#cs
func UnlockPermissions()
	local $i, $val, $rv
	local $reg_val = 0
	
	for $i=0 to $reg_entry_last
		;MsgBox(0,"Dbg", $reg_entry[$i][0] & @CRLF & $reg_entry[$i][1])
		$val = -2
		$reg_entry[$i][2] = -4
		$val = RegRead($reg_entry[$i][0], $reg_entry[$i][1])
		$rv = @error
		if 0 <> @error then
			; error reading reg key
			; do not change [$i][2] so that it will not try to get used in LockPermissions()
			;MsgBox(0,"error", "RegRead()" &@CRLF& $rv)
			continueloop
		endif

		if StringInstr($reg_entry[$i][0], "Explorer", 0 ) > 0 then
			;MsgBox(0,"Explorer", "Match " &$reg_entry[$i][1] )
			$reg_val = 3; where 3 = restrict A & B drives only
		endif

		if $val > -1 then
			;MsgBox(0,"val", $val &@CRLF& $reg_val)
			$rv = RegWrite($reg_entry[$i][0], $reg_entry[$i][1], "REG_DWORD", $reg_val)
			;MsgBox(0,"Unlock()", "RegWrite rv: " & $rv)
			if 1 == $rv then
				$reg_entry[$i][2] = $val
			endif
		endif
	next
endfunc

func LockPermissions()
	local $i
	
	for $i=0 to $reg_entry_last
		if -4 <> $reg_entry[$i][2] then
			RegWrite($reg_entry[$i][0], $reg_entry[$i][1], "REG_DWORD", $reg_entry[$i][2])
			$reg_entry[$i][2] = ""
		endif
	next
endfunc
#ce

func RunPrograms()
	local $tmp = ""
	local $wait=125
	sleep($wait)

	;MsgBox(0,"Dbg", "In RunPrograms()")

	Run(@ComSpec, "C:\") 
	sleep($wait)

	Run(@SystemDir & "\taskmgr.exe")
	sleep($wait)

	;Run(@WindowsDir & "\regedit.exe")
	;sleep($wait)

	;$tmp = @SystemDir & "\gpedit.msc"
	;Run(@ComSpec & " /c " & $tmp, "")
	;sleep($wait)

	;$tmp = @SystemDir & "\sysdm.cpl"
	;Run(@ComSpec & " /c " & $tmp, "")
	;sleep($wait)

	;$tmp = @SystemDir & "\rundll32.exe SHELL32.DLL, SHHelpShortcuts_RunDLL PrintersFolder"
	;Run(@ComSpec & " /c " & $tmp, "", @SW_MINIMIZE )
	;sleep($wait)

	$tmp ="C:\WINDOWS\explorer.exe C:\" 
	Run(@ComSpec & " /c " & $tmp)
	sleep($wait)

	; System Properties
	Run("C:\WINDOWS\system32\control.exe sysdm.cpl", "c:\windows\system32")
	sleep($wait)

	; Desktop Properties: Screen Saver, Display Resolution, etc.
	Run("C:\WINDOWS\system32\control.exe desk.cpl", "c:\windows\system32")
	sleep($wait)

	; Crazy hack to run: explorer.exe c:\
	Run("C:\WINDOWS\system32\control.exe ncpa.cpl", "c:\windows\system32")
	sleep($wait)

	; Internet Explorer
	$tmp = '"c:\Program Files\Internet Explorer\iexplore.exe" http://www.google.com/'
	Run($tmp)
	sleep($wait)
endfunc

func AdminTools()
	local $rv
	;MsgBox(0,"Dbg","In AdminTools()")
	;UnlockPermissions()
	$rv = MsgBox(4,'Admin Tools', 'Do you want to run the Admin Tools?')
	if $rv == 6 then
		RunPrograms()
	endif
	;LockPermissions()
	OnExit()
endfunc

Func OnExit()
	$_In_Shell = 0
	;MsgBox(0,"Debug","starting OnExit()")
	GUIDelete( $Shell_Win )
	_ReduceMemory()
endfunc

func OnInfo()
	Local $data[25]
	Local $i = 0
	Local $output = ""

	$data[1] = "Computer name: " & @ComputerName
	$data[2] = "User name: " & @UserName
	$data[3] = "Logon server: " & @LogonServer
	$data[4] = "---------------------------------------"
	$data[5] = "1st IP: " & @IPAddress1
	$data[6] = "2nd IP: " & @IPAddress2
	$data[7] = "---------------------------------------"
	$data[8] = "OS: " & @OSVersion & "  " & @OSServicePack
	$data[9] = "Desktop: " & @DesktopWidth & "x" & @DesktopHeight & " @ " & @DesktopDepth & "bpp"
	$data[10] = "AutoIt version: " & @AutoItVersion

	for $i = 1 to 10
		$output = $output & $data[$i] & @CR
	next
	
	MsgBox(0,$Info_Title, $output, 14)
	_ReduceMemory()
endfunc

func OnSubmit()
	;MsgBox(0,"Info", "In OnSubmit()")
	Local $u, $p, $rv
	$u = GUICtrlRead($UsernameID)
	$p = GUICtrlRead($PasswordID)

	;MsgBox(0,"OnSubmit()", $u & @TAB & $p & @TAB & @AutoItExe)
	$rv = RunAs( $u, @ComputerName, $p, 1, @AutoItExe, "c:\windows" )
	;MsgBox(0, $rv, @Error & " " & @AutoItExe)

	_ReduceMemory()
	OnExit()
endfunc

; end of script

