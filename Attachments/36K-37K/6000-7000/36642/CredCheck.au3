;~ YOU NEED TO GO HERE FIRST: http://www.autoitscript.com/forum/topic/106163-active-directory-udf/. DOWNLOAD THE ZIP IN THE FIRST POST.
;~ ALL THAT NEEDS TO BE DONE FOR THIS TO WORK. FROM THE README FILE:
;~ This step is mandatory
;~ 		* Copy AD.au3 into the %ProgramFiles%\AutoIt3\Include
;~ For SciTE integration (user calltips and syntax highlighting)
;~ 		* Copy au3.user.calltips.api into %ProgramFiles%\AutoIt3\SciTE\api.
;~ 		If the file already exists and contains other definitions as from the AD UDF then append it to the existing file
;~ 		* Copy au3.userudfs.properties into %ProgramFiles%\AutoIt3\SciTE\properties
;~   	If the file already exists and contains other definitions as from the AD UDF then append it to the existing file

#include <AD.au3>
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

while 1
	$SUserId = GUICtrlRead($usern) ;  READS WHATEVER IS PUT INTO THE "$USERN" FIELD
	$SPassword = GUICtrlRead($passn); READS WHATEVER IS PUT INTO THE "$PASSN" FIELD
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
			_AD_Close()
		case $cancel
			Exit
			_AD_Close()
		case $ok
			If $SUserId = "" Or $SPassword = "" Then
				MsgBox(16, "Active Directory Functions", "User Id or Pass can not be blank!!!");  GET CREATIVE WITH WHAT YOU WANT IT TO SAY!
			ElseIf _AD_Open($SUserId, $SPassword) Then
				Ini_Write("Password","c:\cred3.ini","Section","Key",$SPassword); WRITES AN INI FILE WITH THE PASSWORD ENCYPTED FOR LATER USE.
				IniWrite("c:\cred3.ini","Section","Key2",$SUserId) ; THIS IS OPTIONAL IF YOU NEED IT OR NOT
				RunAs($SUserId, "bbl",$SPassword , 2,@ScriptDir&"\YOUR PROGRAM OR SCRIPT.exe",@ScriptDir,"",0x1);  CHANGE  "@ScriptDir&"\YOUR PROGRAM OR SCRIPT.exe" TO YOUR PROGRAMS FILE PATH
				_AD_Close()
				ExitLoop
			ElseIf @error <= 8 Then
				MsgBox(16, "H4XX0r!","The Username or Password... It is wrong.");  GET CREATIVE WITH WHAT YOU WANT IT TO SAY!
			Else
				MsgBox(16, "H4XX0r!","The Username or Password... It is wrong.");  GET CREATIVE WITH WHAT YOU WANT IT TO SAY!
				Global $aError = _AD_GetLastADSIError()
				_ArrayDisplay($aError)
			EndIf
	EndSwitch
WEnd

;~                    THIS ENCRYPTS THE PASSWORD	********************
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
