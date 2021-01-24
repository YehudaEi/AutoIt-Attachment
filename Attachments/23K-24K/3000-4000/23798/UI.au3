#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=Autoit Lock.exe
#AutoIt3Wrapper_Compression=4
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Constants.au3>
#include <guiconstants.au3>
#include <misc.au3>
#include <em.au3>
#include "securun.au3"
#NoTrayIcon
#include <string.au3>
Global $locked
Global $mp
Global $splash
Global $upasswd
Global $taskman
Global $toutpwd = 30
Global $toutic = 3
If $cmdline[0] <> 0 Then
	If $cmdline[1] = "-lock" Then
		$upasswd = $cmdline[2]
		_lock()
	EndIf
Else
	_passwdset()
EndIf
MsgBox(0, "Info", "You can change the password at any time by right clicking the tray icon and click set password. to lock your Desktop right click the tray icon and click lock. To unlock your Desktop while it's locked press p.")
Opt("TrayMenuMode", 1) ; Default tray menu items (Script Paused/Exit) will not be shown.
$lock = TrayCreateItem("Lock")
TrayCreateItem("")
$setp = TrayCreateItem("Set password")
TrayCreateItem("")
$exit = TrayCreateItem("Exit")
TraySetState()
While 1
	$msg = TrayGetMsg()
	Select
		Case $msg = 0
			ContinueLoop
		Case $msg = $lock
			_lock()
		Case $msg = $exit
			Exit
		Case $msg = $setp
			_passwdset()
	EndSelect
WEnd
Func _lock()
	$securunkey = _StringEncrypt(1, @YDAY + @MDAY + @HOUR + @MIN + @MON, "securun")
	_secure_run("lock.lck " & $securunkey & " " & $upasswd)
EndFunc   ;==>_lock
Func _passwdset()
	$b = 1
	While $b = 1
		$upasswd = InputBox("Password", "Please set the password. You will need this password to unlock youre desktop.", "", "*")
		$vp = InputBox("Verify", "Please verify the password.", "", "*")
		If $upasswd <> $vp Then
			MsgBox(0, "Don't match", "The password don't match")
		ElseIf $upasswd = "" Then
			MsgBox(0, "", "the pasword can not be blank")
		Else
			$b = 0
		EndIf
	WEnd
EndFunc   ;==>_passwdset