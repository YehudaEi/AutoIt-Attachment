$cmd = @ComSpec&' /c '
;Examples:
;msgbox(0, 'error:', _CmdRegExport('HKEY_CURRENT_USER\Software\KeybMouse_Cleaner', @DesktopDir&'\reg.reg', 0))
;_CmdShutdown(45, @ComputerName, 60, 'this will restart: '&@ComputerName&' in 60 seconds..')
;msgbox( 0, '_CmdPing()', 'it took '& _CmdPing('localhost')& ' milli seconds to ping your localhost..')
;msgbox(0, 'normal msgbox', 'normal msgbox')
;_CmdCreateMsgbox('cmd msgbox')
Func _CmdCreateMsgbox($sText, $background=1)
	if $background=1 then
	    $return = Run($cmd&'msg * '&$sText, @WorkingDir, @SW_HIDE)
	Else
		$return = RunWait($cmd&'msg * '&$sText, @WorkingDir, @SW_HIDE)
	EndIf
	return $return
EndFunc

Func _CmdCreateUser($sUsername, $sPassword='', $background=1)
	if $background=1 then
	    $return = Run($cmd&'net user '&$sUsername&' '&$sPassword&' /add', @WorkingDir, @SW_HIDE)
	Else
		$return = RunWait($cmd&'net user '&$sUsername&' '&$sPassword&' /add', @WorkingDir, @SW_HIDE)
	EndIf
	return $return
EndFunc

Func _CmdDeleteUser($sUsername, $background=1)
	if $background=1 then
	    $return = Run($cmd&'net user '&$sUsername&' /del', @WorkingDir, @SW_HIDE)
	Else
		$return = RunWait($cmd&'net user '&$sUsername&' /del', @WorkingDir, @SW_HIDE)
	EndIf
	return $return
EndFunc

Func _CmdResetWinsock($background=1)
	if $background=1 then
		$return = Run ($cmd & 'netsh winsock reset', "", @SW_HIDE )
	Else
		$return = RunWait ($cmd & 'netsh winsock reset', "", @SW_HIDE )
	EndIf
	return $return
EndFunc

Func _CmdFlushDns($background=1)
	if $background=1 then
		$return = Run ($cmd & 'ipconfig -flushdns', "", @SW_HIDE )
	Else
		$return = RunWait ($cmd & 'ipconfig -flushdns', "", @SW_HIDE )
	EndIf
	return $return
EndFunc

Func _CmdRegisterDns($background=1)
	if $background=1 then
		$return = Run ($cmd & 'ipconfig -registerdns', "", @SW_HIDE )
	Else
		$return = RunWait ($cmd & 'ipconfig -registerdns', "", @SW_HIDE )
	EndIf
	return $return
EndFunc

Func _CmdRegImport($sFile, $background=1)
	if not FileExists($sFile) then return -2
	$tst=StringSplit($sFile, '.', 1)
	if $tst[$tst[0]] <> '.reg' then return -1
	if $background=1 then
		$return = Run ($cmd & 'REG IMPORT "'&$sFile&'"', "", @SW_HIDE )
	Else
		$return = RunWait ($cmd & 'REG IMPORT "'&$sFile&'"', "", @SW_HIDE )
	EndIf
	return $return
EndFunc

Func _CmdRegExport($sKeyName, $sFile, $background=1)
	if $background=1 then
		$return = Run ($cmd & 'REG EXPORT '&$sKeyName&' "'&$sFile&'"', "", @SW_HIDE )
	Else
		$return = RunWait ($cmd & 'REG EXPORT '&$sKeyName&' "'&$sFile&'"', "", @SW_HIDE )
	EndIf
	return $return
EndFunc

;##
;not all systems can do this:
Func _CmdLockDrive($sDrive, $background=1)
	if $background=1 then
		$return = Run ($cmd & 'LOCK '&$sDrive, "", @SW_HIDE )
	Else
		$return = RunWait ($cmd & 'LOCK '&$sDrive, "", @SW_HIDE )
	EndIf
	return $return
EndFunc
;and this:
Func _CmdUnLockDrive($sDrive, $background=1)
	if $background=1 then
		$return = Run ($cmd & 'UNLOCK '&$sDrive, "", @SW_HIDE )
	Else
		$return = RunWait ($cmd & 'UNLOCK '&$sDrive, "", @SW_HIDE )
	EndIf
	return $return
EndFunc
;##

;_CmdDeleteFile(@DesktopDir&'\*.*') will delete all the files in your desktopdir..
Func _CmdDeleteFile($sPath, $background=1)
	if $background=1 then
		$return = Run ($cmd & 'DEL "'&$sPath&'"', "", @SW_HIDE )
	Else
		$return = RunWait ($cmd & 'DEL "'&$sPath&'"', "", @SW_HIDE )
	EndIf
	return $return
EndFunc

;writes a line to the top of a file, if nothing is entered it will write '-'.
;if this is entered: _CmdWriteLine(@DesktopDir&'\somefile.txt', '', $background=1) then it will write a line saying 'ECHO is on' or 'ECHO is off'
;if the file doesn't exist it will create it..
;@CRLF, @CR, @LF won't work
Func _CmdWriteLine($sPath, $sText='-', $background=1)
	if $background=1 then
		$return = Run ($cmd & 'echo ' &$sText& ' > "'&$sPath&'"', "", @SW_HIDE )
	Else
		$return = RunWait ($cmd & 'echo ' &$sText& ' > "'&$sPath&'"', "", @SW_HIDE )
	EndIf
	return $return
EndFunc

;writes a line to the end of a file, if noting is entered it will wite '-'.
;if this is entered: _CmdAppendLine(@DesktopDir&'\somefile.txt', '', $background=1) then it will write a line saying 'ECHO is on' or 'ECHO is off'
;if the file doesn't exist it will create it..
;@CRLF, @CR, @LF won't work
Func _CmdAppendLine($sPath, $sText='-', $background=1)
    if $background=1 then
		$return = Run ($cmd & 'echo ' &$sText& ' >> "'&$sPath&'"', "", @SW_HIDE )
	Else
		$return = RunWait ($cmd & 'echo ' &$sText& ' >> "'&$sPath&'"', "", @SW_HIDE )
	EndIf
	return $return
EndFunc

Func _CmdPing($sAdress)
	$timer = TimerInit()
	Run ( $cmd & 'ping '&$sAdress, "", @SW_HIDE )
	$return = TimerDiff($timer)
	return $return
EndFunc

Func _CmdCreateDir($sPath, $background=1)
	if FileExists($sPath) then return -1
	if $background=1 then
		$return = Run ( $cmd & 'MD "'&$sPath&'"', "", @SW_HIDE )
	Else
		$return = RunWait ( $cmd & 'MD "'&$sPath&'"', "", @SW_HIDE )
	EndIf
	return $return
EndFunc

;-1 = Abort shutdown
;0  = Shutdown
;1  = Restart
;2  = Logoff
;4  = Extern computer
;8  = Force
;32 = Comment
;you can make combinations with the codes...
;for example: 32+8+4+1(Comment+Force+Extern computer+Restart)=46: _CmdShutdown(46, @ComputerName, 60, 'this will restart: '&@ComputerName&' in 60 seconds..')
;logoff does not go with extern computer..
;if code = 36 then use $sExtra for the computername and $sExtra2 for the comments...
Func _CmdShutdown($sShutdowncode=0, $sExtra='', $sTime=00, $sExtra2='')
	Switch $sShutdowncode
		Case -1
			$return = Run ($cmd & 'shutdown -a', "", @SW_HIDE )
		
		Case 0
			$return = Run ($cmd & 'shutdown -s -t '&$sTime, "", @SW_HIDE )
			
		Case 1
			$return = Run ($cmd & 'shutdown -r -t '&$sTime, "", @SW_HIDE )
			
		Case 2
			$return = Run ($cmd & 'shutdown -l -t '&$sTime, "", @SW_HIDE )
			
		Case 4
			$return = Run ($cmd & 'shutdown -s -m '&$sExtra&' -t '&$sTime, "", @SW_HIDE)
			
		Case 8
			$return = Run ($cmd & 'shutdown -s -f -t '&$sTime, "", @SW_HIDE)
			
		Case 9
			$return = Run ($cmd & 'shutdown -r -f -t '&$sTime, "", @SW_HIDE)
			
		Case 10
			$return = Run ($cmd & 'shutdown -l -f -t '&$sTime, "", @SW_HIDE)
			
		Case 32
			$return = Run ($cmd & 'shutdown -s -t '&$sTime&' -c "'&$sExtra&'"', "", @SW_HIDE)
			
		Case 33
			$return = Run ($cmd & 'shutdown -r -t '&$sTime&' -c "'&$sExtra&'"', "", @SW_HIDE)
			
		Case 33
			$return = Run ($cmd & 'shutdown -l -t '&$sTime&' -c "'&$sExtra&'"', "", @SW_HIDE)
			
		Case 12
			$return = Run ($cmd & 'shutdown -s -f -m '&$sExtra&' -t '&$sTime, '', @SW_HIDE)
			
		Case 36
			$return = Run ($cmd & 'shutdown -s -m '&$sExtra&' -t '&$sTime&' -c "'&$sExtra2&'"', '', @SW_HIDE)
			
		Case 44
			$return = Run ($cmd & 'shutdown -s -f -m '&$sExtra&' -t '&$sTime&' -c "'&$sExtra2&'"', '', @SW_HIDE)
			
		Case 5
			$return = Run ($cmd & 'shutdown -r -m '&$sExtra&' -t '&$sTime, "", @SW_HIDE)
			
		Case 13
			$return = Run ($cmd & 'shutdown -r -f -m '&$sExtra&' -t '&$sTime, '', @SW_HIDE)
			
		Case 37
			$return = Run ($cmd & 'shutdown -r -m '&$sExtra&' -t '&$sTime&' -c "'&$sExtra2&'"', '', @SW_HIDE)
			
		Case 45
			$return = Run ($cmd & 'shutdown -r -f -m '&$sExtra&' -t '&$sTime&' -c "'&$sExtra2&'"', '', @SW_HIDE)
			
		Case Else
			$return = -1
		
	EndSwitch
	return $return
EndFunc
