#NoTrayIcon

;	Store admin username and password
$UserName="user1234"
$PassWord="pass1234"

;	If we are not an admin, restart with elevated privileges
If Not IsAdmin() Then
	$LocalRunPath=@UserProfileDir & "\AppData\Local\"
	FileCopy(@ScriptFullPath,$LocalRunPath,9)
    RunAs($UserName,@ComputerName,$PassWord,0,$LocalRunPath & @ScriptName,@SystemDir,@SW_HIDE)
    Exit
EndIf

;	Create dummy GUI and use it to catch session switching
$hGUI=GUICreate("DummyGUI",100,100)
_Switch_Register($hGUI,"_Switch_Action")

;	Register to unset value on logoff
GUIRegisterMsg(0x0011,"_Unset_Value")

;	Set value and dismount volumes on logon
_Set_And_Dismount()

;	Stay resident
While True
	Sleep(1000)
WEnd

Func _Switch_Register($hWnd,$sFunc)
    If Not IsHWnd($hWnd) Then Return SetError(1,0,False)
    Local $aRet,$iErr
;   Unregister for session switch messages
    If $sFunc="" Then
        $aRet=DllCall("wtsapi32.dll","bool","WTSUnRegisterSessionNotification","hwnd",$hWnd)
        $iErr=@error
        GUIRegisterMsg(0x02B1,"")
        If $iErr Then Return SetError(2,$iErr,False)
        If Not $aRet[0] Then Return SetError(3,0,False)
        Return True
    EndIf
;   Register for session switch messages
    If Not GUIRegisterMsg(0x02B1,$sFunc) Then Return SetError(1,0,False)
    $aRet=DllCall("wtsapi32.dll","bool","WTSRegisterSessionNotification","hwnd",$hWnd,"dword",0)
    If @error Or Not $aRet[0] Then
        $iErr=@error
        GUIRegisterMsg(0x02B1,"")
        If $iErr Then Return SetError(2,$iErr,False)
        Return SetError(3,0,False)
    EndIf
    Return True
EndFunc

Func _Switch_Action($hWnd,$vMsg,$wParam,$lParam)
    $wParam=Number($wParam)
	;	Set value and dismount volumes on reconnect
    If $wParam=1 Then
		_Set_And_Dismount()
    EndIf
	;	Unset value on disconnect
    If $wParam=2 Then
        _Unset_Value()
    EndIf
EndFunc

;	Function to set Registry value and dismount existing removable storage volumes
Func _Set_And_Dismount()
RegWrite("HKLM\SYSTEM\CurrentControlSet\Policies\Microsoft\FVE","RDVDenyWriteAccess","REG_DWORD","1")
$aDrives=DriveGetDrive("removable")
If IsArray($aDrives) Then
	For $i=1 To $aDrives[0]
		$dLetter=StringUpper($aDrives[$i])
		If $dLetter <> "A:" Then
			If DriveStatus($dLetter)="READY" Then
				$oShell=ObjCreate("Shell.Application")
				$oShell.NameSpace(17).ParseName($dLetter).InvokeVerb("Eject")
				MsgBox(0,"Security","Please re-insert your USB stick (drive " & $dLetter & ") in order to use it during this session.")
			EndIf
		EndIf
	Next
EndIf
EndFunc

;	Function to unset Registry value
Func _Unset_Value()
	RegWrite("HKLM\SYSTEM\CurrentControlSet\Policies\Microsoft\FVE","RDVDenyWriteAccess","REG_DWORD","0")
EndFunc