#include <Crypt.au3>

$Value = Ini_Read("Password","c:\cred3.ini","Section","Key")
if Not @error Then _
serial () ; THIS WILL BE THE FUNCTION WITH WHATEVER CODE YOU ARE USING. I USE IT TO RUN AN EXE ON A REMOTE MACHINE THAT NEEDS THIS PASSWORD TO BE SENT INTO A HARDWARE INSTALLATION WIZARD CREDENTIAL BOX.

;~    THIS IS THE DECRYPTION CODE   *****************
Func Ini_Read($Password,$Filename,$Section,$Key,$Default = "NotFound")
	$EncryptedValue = IniRead($Filename,$Section,$Key,$Default)
	if $EncryptedValue == $Default Then Return SetError(1,0,$Default)
	_Crypt_Startup()
	if @error Then Return SetError(2,@error,$Default)
	$hKey =_Crypt_DeriveKey($Password,$CALG_RC4)
	if @error Then Return SetError(3,@error,$Default)
	$Binary = _Crypt_DecryptData($EncryptedValue,$hKey,$CALG_USERKEY)
	if @error Then Return SetError(4,@error,$Default)
	$StrByte = BinaryToString($Binary)
	if @error Then Return SetError(5,@error,$Default)
	$ByteStruct =  DllStructCreate("BYTE[" & BinaryLen($StrByte) & "]")
	DllStructSetData($ByteStruct,1,$StrByte)
	$CharStruct = _
	DllStructCreate("CHAR[" & DllStructGetSize($ByteStruct) & "]",DllStructGetPtr($ByteStruct))
	_Crypt_DestroyKey($hKey)
	_Crypt_Shutdown()
	Return SetError(0,0,DllStructGetData($CharStruct,1))
EndFunc

func serial ()  ; THIS IS THE FUNCTION CALLED
	$Value = Ini_Read("Password","c:\cred3.ini","Section","Key")
	$user=iniread("c:\cred3.ini","Section","Key2","")  ; THIS IS OPTIONAL. IT WAS WRITTEN IN WITH THE PREVIOUS ENCRYTION SCRIPT
	if Not @error Then _
	; PUT WHATEVER CODE YOU ARE WANTING TO RUN HERE
		msgbox(0,"Whaddayaknow","The password is: "&$value&"")
	FileDelete("c:\cred3.ini") ; IT'S ALWAYS A GOOD IDEA TO HAVE THIS FILE DELTED AT SOME POINT. IT'S JUST GOOD SECURITY.
	Exit
EndFunc