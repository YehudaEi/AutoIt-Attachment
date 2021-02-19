#include-once

; Encrypt Ini Read/Write functions using Crypt.au3
; Default algorithm key is AES 256
; Because this involves read functions
;   The sections and keys are lower cased when
;   written to and read from the ini-file

#cs
	Name:         IniCrypt.au3
	Description:  Use in place of Standard Ini functions to
	                Read and Write encrypted/decrypted data to and from
					an ini file
	Author:       SmOke_N ( Ron Nielsen )
	Version:      0.0.2
	Last Update:  2011/05/01
	Note(s):      - Because of enc/dec - all sections and keys are lower
	                cased before decrypting/encrypting

				  - You must always use the set key function after initialization
				  - Use the Shutdown function when you are going to stop using the
				      encryption function or when you need/want to change passwords
					  or encrytpion method ( eg. AES 256 to RC4 etc. )
	AutoIt:       3.3.6.1

	Update Status:
	==========================================
	2011-05-01 - 0.0.2 - SmOke_N
	Fixed: Noticed issue if reading blank values; fixed with value check
	==========================================
	2011-05-01 - 0.0.1 - SmOke_N
	Initial Release
	==========================================
#ce

; #Function Names#===================================================================================
;    _IniCrypt_Delete()
;    _IniCrypt_Initiate()
;    _IniCrypt_Read()
;    _IniCrypt_ReadSection()
;    _IniCrypt_ReadSectionNames()
;    _IniCrypt_RenameSection()
;    _IniCrypt_SetPassword()
;    _IniCrypt_Shutdown()
;    _IniCrypt_Write()
;    _IniCrypt_WriteSection()
; ===================================================================================================

; #Example 1#========================================================================================
#cs
#include <array.au3>
_IniCrypt_Initiate()
_IniCrypt_SetPassword("mypassword")
Global $ga_data[3][2] = [ [ "FirstKey", "FirstValue" ], [ "SecondKey", "SecondValue" ], [ "ThirdKey", "ThirdValue" ] ]
_IniCrypt_WriteSection("mycrypttest.ini", "Section1", $ga_data, 0)
Global $ga_args = _IniCrypt_ReadSection("mycrypttest.ini", "Section1")
_ArrayDisplay($ga_args)
_IniCrypt_Shutdown()
#ce
; ===================================================================================================

#region includes
#include <Crypt.au3>
#endregion includes

#region globals
Global $gf_IniCrypt_Startup = False
Global $gi_IniCrypt_AlgID = -1
Global $gi_IniCrypt_HashAlgID = -1
Global $gh_IniCrypt_Key = -1
#endregion globals

#region standard functions
;===================================================================================================
;
; Function Name....:    _IniCrypt_Delete()
; Description......:    Deletes an encrypted value from a encrypted format .ini file.
; Parameter(s).....:
;                       $s_filename:  The filename of the .ini file.
;                       $s_section:   The section name in the .ini file.
;                       $s_key:       [optional] The key name in the .ini file to delete. If the
;                                       key name is not given the entire section is deleted. The
;                                       Default keyword may also be used which will cause the
;                                       section to be deleted.
; Return Value(s)..:
;                       Success...:  Returns 1
;                       Failure...:  Returns 0
;                       Error.....:  -1 ; Didn't pass validation, meaning that it is probably
;                                      not initialized or you didn't set a key
;                       Extended..:
; Requirement(s)...:    AutoIt 3.3.6.1
; Author(s)........:    SmOke_N (Ron Nielsen)
; Modified.........:
; Comment(s).......:
; Example(s).......:
;
;===================================================================================================

Func _IniCrypt_Delete($s_filename, $s_section, $s_key = "")

	__IniCrypt_ValidateCheck()
	If @error Then Return SetError(-1, 0, 0)

	$s_section = StringLower($s_section)
	$s_key = StringLower($s_key)
	Local $s_csection = Hex(_Crypt_EncryptData($s_section, $gh_IniCrypt_Key, $CALG_USERKEY))
	Local $s_ckey = $s_key
	If String($s_ckey) <> "" Then
		Hex(_Crypt_EncryptData($s_key, $gh_IniCrypt_Key, $CALG_USERKEY))
	EndIf

	Return IniDelete($s_filename, $s_csection, $s_key)
EndFunc

;===================================================================================================
;
; Function Name....:    _IniCrypt_Read()
; Description......:    Reads an encrypted value from a encrypted format .ini file.
; Parameter(s).....:
;                       $s_filename:  The filename of the .ini file.
;                       $s_section:   The section name in the .ini file.
;                       $s_key:       The key name in the in the .ini file.
;                       $s_default:   The default value to return if the requested key is not
;                                       found.
; Return Value(s)..:
;                       Success...:  Returns the requested key value.
;                       Failure...:  Returns the default string if requested key not found.
;                       Error.....:  -1 ; Didn't pass validation, meaning that it is probably
;                                      not initialized or you didn't set a key
;                       Extended..:
; Requirement(s)...:    AutoIt 3.3.6.1
; Author(s)........:    SmOke_N (Ron Nielsen)
; Modified.........:
; Comment(s).......:
; Example(s).......:
;
;===================================================================================================

Func _IniCrypt_Read($s_filename, $s_section, $s_key, $s_default)

	__IniCrypt_ValidateCheck()
	If @error Then Return SetError(-1, 0, 0)

	$s_section = StringLower($s_section)
	$s_key = StringLower($s_key)
	Local $s_csection = Hex(_Crypt_EncryptData($s_section, $gh_IniCrypt_Key, $CALG_USERKEY))
	Local $s_ckey = Hex(_Crypt_EncryptData($s_key, $gh_IniCrypt_Key, $CALG_USERKEY))

	Local $s_cread = IniRead($s_filename, $s_csection, $s_ckey, $s_default)
	If $s_cread = $s_default Then Return $s_default

	If String($s_cread) = "" Then Return ""

	Return BinaryToString(_Crypt_DecryptData("0x" & $s_cread, $gh_IniCrypt_Key, $CALG_USERKEY))
EndFunc

;===================================================================================================
;
; Function Name....:    _IniCrypt_Write()
; Description......:    Writes a value to an encrypted format .ini file.
; Parameter(s).....:
;                       $s_filename:  The filename of the .ini file.
;                       $s_section:   The section name in the .ini file.
;                       $s_key:       The key name in the in the .ini file.
;                       $s_write:     The value to write/change.
; Return Value(s)..:
;                       Success...:  Returns 1
;                       Failure...:  Returns 0 ; if file is read-only
;                       Error.....:
;                       Extended..:
; Requirement(s)...:    AutoIt 3.3.6.1
; Author(s)........:    SmOke_N (Ron Nielsen)
; Modified.........:
; Comment(s).......:
; Example(s).......:
;
;===================================================================================================

Func _IniCrypt_Write($s_filename, $s_section, $s_key, $s_write)

	__IniCrypt_ValidateCheck()
	If @error Then Return SetError(-1, 0, 0)

	$s_section = StringLower($s_section)
	$s_key = StringLower($s_key)
	Local $s_csection = Hex(_Crypt_EncryptData($s_section, $gh_IniCrypt_Key, $CALG_USERKEY))
	Local $s_ckey = Hex(_Crypt_EncryptData($s_key, $gh_IniCrypt_Key, $CALG_USERKEY))
	Local $s_cwrite = $s_write
	If String($s_cwrite) <> "" Then
		$s_cwrite = Hex(_Crypt_EncryptData($s_write, $gh_IniCrypt_Key, $CALG_USERKEY))
	EndIf

	Return IniWrite($s_filename, $s_csection, $s_ckey, $s_cwrite)
EndFunc

;===================================================================================================
;
; Function Name....:    _IniCrypt_ReadSection()
; Description......:    Reads all key/value pairs from a section in a encrypted format .ini file.
; Parameter(s).....:
;                       $s_filename:  The filename of the .ini file.
;                       $s_section:   The section name in the .ini file.
; Return Value(s)..:
;                       Success...:  Returns a 2 dimensional array where element[n][0] is the key
;                                      and element[n][1] is the value.
;                       Failure...:  Returns 0
;                       Error.....:  -1 ; Didn't pass validation, meaning that it is probably
;                                      not initialized or you didn't set a key
;
;                                    1 ; if unable to read the section
;                                      (The INI file may not exist or the section may not exist)
;                       Extended..:
; Requirement(s)...:    AutoIt 3.3.6.1
; Author(s)........:    SmOke_N (Ron Nielsen)
; Modified.........:
; Comment(s).......:
; Example(s).......:
;
;===================================================================================================

Func _IniCrypt_ReadSection($s_filename, $s_section)

	__IniCrypt_ValidateCheck()
	If @error Then Return SetError(-1, 0, 0)

	$s_section = StringLower($s_section)
	Local $s_csection = Hex(_Crypt_EncryptData($s_section, $gh_IniCrypt_Key, $CALG_USERKEY))

	Local $a_csection = IniReadSection($s_filename, $s_csection)
	If @error Or Not IsArray($a_csection) Then
		Return SetError(1, 0, 0)
	EndIf

	Local $a_section[$a_csection[0][0] + 1][2]
	$a_section[0][0] = $a_csection[0][0]

	For $i = 1 To $a_csection[0][0]
		$a_section[$i][0] = BinaryToString(_Crypt_DecryptData("0x" & _
			$a_csection[$i][0], $gh_IniCrypt_Key, $CALG_USERKEY))
		$a_section[$i][1] = $a_csection[$i][1]
		If String($a_csection[$i][1]) <> "" Then
			$a_section[$i][1] = BinaryToString(_Crypt_DecryptData("0x" & _
				$a_csection[$i][1], $gh_IniCrypt_Key, $CALG_USERKEY))
		EndIf
	Next

	Return $a_section
EndFunc

;===================================================================================================
;
; Function Name....:    _IniCrypt_ReadSectionNames()
; Description......:    Reads all sections in an encrypted format .ini file.
; Parameter(s).....:
;                       $s_filename:  The filename of the .ini file.
; Return Value(s)..:
;                       Success...:  Returns an array of all section names in the INI file.
;                       Failure...:  Returns 0
;                       Error.....:  -1 ; Didn't pass validation, meaning that it is probably
;                                      not initialized or you didn't set a key
;
;                                    1 ; Failed to retrieve data (Ini or sections may not exist)
;                       Extended..:
; Requirement(s)...:    AutoIt 3.3.6.1
; Author(s)........:    SmOke_N (Ron Nielsen)
; Modified.........:
; Comment(s).......:
; Example(s).......:
;
;===================================================================================================

Func _IniCrypt_ReadSectionNames($s_filename)

	__IniCrypt_ValidateCheck()
	If @error Then Return SetError(-1, 0, 0)

	Local $a_csections = IniReadSectionNames($s_filename)
	If @error Or Not IsArray($a_csections) Then
		Return SetError(1, 0 ,0)
	EndIf

	Local $a_sections[$a_csections[0] + 1] = [$a_csections[0]]
	For $i = 1 To $a_csections[0]
		$a_sections[$i] = $a_csections[$i]
		If String($a_csections[$i]) <> "" Then
			BinaryToString(_Crypt_DecryptData("0x" & _
			$a_csections[$i], $gh_IniCrypt_Key, $CALG_USERKEY))
		EndIf
	Next

	Return $a_sections
EndFunc

;===================================================================================================
;
; Function Name....:    _IniCrypt_RenameSection()
; Description......:    Renames a section in an encrypted format .ini file.
; Parameter(s).....:
;                       $s_filename:    The filename of the .ini file.
;                       $s_section:     The section name in the .ini file.
;                       $s_newsection:  The new section name.
;                       $i_flag:        [optional] 0 (Default) - Fail if "new section" already
;                                         exists. 1 - Overwrite "new section". This will erase
;                                         any existing keys in "new section"
; Return Value(s)..:
;                       Success...:  Returns a Non-Zero
;                       Failure...:  Returns 0 and may set @error if the section couldn't be
;                                      overwritten (flag = 0 only).
;                       Error.....:  -1 ; Didn't pass validation, meaning that it is probably
;                                      not initialized or you didn't set a key
;
;                                    Depends on flag ( See helpfile for IniRenameSection() )
;                       Extended..:
; Requirement(s)...:    AutoIt 3.3.6.1
; Author(s)........:    SmOke_N (Ron Nielsen)
; Modified.........:
; Comment(s).......:
; Example(s).......:
;
;===================================================================================================

Func _IniCrypt_RenameSection($s_filename, $s_section, $s_newsection, $i_flag = 0)

	__IniCrypt_ValidateCheck()
	If @error Then Return SetError(-1, 0, 0)

	$s_section = StringLower($s_section)
	$s_newsection = StringLower($s_newsection)
	Local $s_csection = Hex(_Crypt_EncryptData($s_section, $gh_IniCrypt_Key, $CALG_USERKEY))
	Local $s_cnewsection = $s_newsection
	If String($s_cnewsection) <> "" Then
		Hex(_Crypt_EncryptData($s_newsection, $gh_IniCrypt_Key, $CALG_USERKEY))
	EndIf

	Local $n_ret = IniRenameSection($s_filename, $s_section, $s_newsection, $i_flag)
	Return SetError(@error, 0, $n_ret)
EndFunc

;===================================================================================================
;
; Function Name....:    _IniCrypt_WriteSection()
; Description......:    Writes a section to an encrypted format .ini file.
; Parameter(s).....:
;                       $s_filename:    The filename of the .ini file.
;                       $s_section:     The section name in the .ini file.
;                       $v_data:        The data to write. The data can either be a string or an
;                                         array. If the data is a string, then each key=value pair
;                                         must be delimited by @LF. If the data is an array, the
;                                         array must be 2-dimensional and the second dimension
;                                         must be 2 elements.
;                       $i_index:       [optional] If an array is passed as data, this specifies
;                                         the index to start writing from. By default, this is 1
;                                         so that the return value of IniReadSection() can be
;                                         used immediately. For manually created arrays, this
;                                         value may need to be different depending on how the
;                                         array was created. This parameter is ignored if a string
;                                         is passed as data.
; Return Value(s)..:
;                       Success...:  Returns 1
;                       Failure...:  Returns 0
;                       Error.....:  -1 ; Didn't pass validation, meaning that it is probably
;                                      not initialized or you didn't set a key
;
;                                    -2 ; Passed a string but no values could be parsed
;
;                                    Depends on flag ( See helpfile for IniRenameSection() )
;                       Extended..:
; Requirement(s)...:    AutoIt 3.3.6.1
; Author(s)........:    SmOke_N (Ron Nielsen)
; Modified.........:
; Comment(s).......:
; Example(s).......:
;
;===================================================================================================

Func _IniCrypt_WriteSection($s_filename, $s_section, $v_data, $i_index = 1)

	__IniCrypt_ValidateCheck()
	If @error Then Return SetError(-1, 0, 0)

	$s_section = StringLower($s_section)
	Local $s_csection = Hex(_Crypt_EncryptData($s_section, $gh_IniCrypt_Key, $CALG_USERKEY))

	If $i_index = -1 Or $i_index = Default Then
		$i_index = 1
	EndIf

	; sep keys and encrypt data
	Local $a_data = $v_data, $a_tdata, $a_sre, $i_add = -1
	If Not IsArray($a_data) Then
		If $i_index > 0 Then
			$a_tdata = StringSplit($a_data, @LF)
		Else
			$a_tdata = StringSplit($a_data, @LF, 2)
		EndIf
		Dim $a_data[UBound($a_tdata)][2]
		For $i = $i_index To UBound($a_tdata) - 1
			If String($a_tdata) = "" Then ContinueLoop
			$a_sre = StringRegExp($a_tdata[$i], "^(.+?)\s*=\s*(.+?)", 1)
			If @error Then ContinueLoop
			$i_add += 1
			$a_data[$i][0] = Hex(_Crypt_EncryptData(StringLower($a_sre[0]), $gh_IniCrypt_Key, $CALG_USERKEY))
			If String($a_sre[0]) <> "" Then
				$a_data[$i][1] = Hex(_Crypt_EncryptData($a_sre[1], $gh_IniCrypt_Key, $CALG_USERKEY))
			EndIf
		Next
		If $i_add = -1 Then Return SetError(-2, 0, 0)
		ReDim $a_data[$i_add + 1][2]
	Else
		For $i = $i_index To UBound($a_data) - 1
			$a_data[$i][0] = Hex(_Crypt_EncryptData(StringLower($a_data[$i][0]), $gh_IniCrypt_Key, $CALG_USERKEY))
			If String($a_data[$i][1]) <> "" Then
				$a_data[$i][1] = Hex(_Crypt_EncryptData($a_data[$i][1], $gh_IniCrypt_Key, $CALG_USERKEY))
			EndIf
		Next
	EndIf

	Local $n_ret = IniWriteSection($s_filename, $s_csection, $a_data, $i_index)
	Return SetError(@error, 0, 0)
EndFunc
#endregion standard functions

#region initiate/shutdown functions

;===================================================================================================
;
; Function Name....:    _IniCrypt_Initiate()
; Description......:    Initiate the encryption ( _Crypt_Startup() ); Set globals
; Parameter(s).....:    none
; Return Value(s)..:
;                       Success...:  Returns 1
;                       Failure...:  Returns 0
;                       Error.....:  1 ; if _Crypt_Startup() failed
;                       Extended..:
; Requirement(s)...:    AutoIt 3.3.6.1
; Author(s)........:    SmOke_N (Ron Nielsen)
; Modified.........:
; Comment(s).......:
; Example(s).......:
;
;===================================================================================================

Func _IniCrypt_Initiate()

	If $gf_IniCrypt_Startup Then
		Return 1
	EndIf

	If Not $gf_IniCrypt_Startup Then
		$gf_IniCrypt_Startup = _Crypt_Startup()
	EndIf

	If Not $gf_IniCrypt_Startup Then
		Return SetError(1, 0, 0)
	EndIf

	Return 1
EndFunc

;===================================================================================================
;
; Function Name....:    _IniCrypt_Shutdown()
; Description......:    Shutdown _Crypt_* data ( use if done or want to reset passwords etc )
; Parameter(s).....:    none
; Return Value(s)..:
;                       Success...:
;                       Failure...:
;                       Error.....:
;                       Extended..:
; Requirement(s)...:    AutoIt 3.3.6.1
; Author(s)........:    SmOke_N (Ron Nielsen)
; Modified.........:
; Comment(s).......:
; Example(s).......:
;
;===================================================================================================

Func _IniCrypt_Shutdown()

	If Not $gf_IniCrypt_Startup Then Return

	_Crypt_Shutdown()

	$gf_IniCrypt_Startup = False
	$gi_IniCrypt_AlgID = -1
	$gi_IniCrypt_HashAlgID = -1
	$gh_IniCrypt_Key = -1
EndFunc

;===================================================================================================
;
; Function Name....:    _IniCrypt_SetPassword()
; Description......:    Set the encryption/decryption key/pass ( _Crypt_DeriveKey )
; Parameter(s).....:
;                       $v_password:    Pasword to set/hash
;                       $i_alg:         [optional] Enc/Dec Algorithm - Default is: $CALG_AES_256
;                       $i_hashalg:     [optional] Enc/Dec Hash Algorithm - Default is: $CALG_MD5
; Return Value(s)..:
;                       Success...:  Returns 1
;                       Failure...:  Returns 0
;                       Error.....:  -1 ; Didn't pass validation, meaning that it is probably
;                                       not initialized or you didn't set a key
;
;                                    Depends on error returned from _Crypt_DeriveKey
;                       Extended..:
; Requirement(s)...:    AutoIt 3.3.6.1
; Author(s)........:    SmOke_N (Ron Nielsen)
; Modified.........:
; Comment(s).......:
; Example(s).......:
;
;===================================================================================================

Func _IniCrypt_SetPassword($v_password, $i_alg = $CALG_AES_256, $i_hashalg = $CALG_MD5)

	__IniCrypt_ValidateCheck(1)
	If @error Then Return SetError(-1, 0, 0)

	If $i_alg = -1 Or $i_alg = Default Then
		$i_alg = $CALG_AES_256
	EndIf

	If $i_hashalg = -1 Or $i_hashalg = Default Then
		$i_hashalg = $CALG_MD5
	EndIf

	$gh_IniCrypt_Key = _Crypt_DeriveKey($v_password, $i_alg, $i_hashalg)

	If @error Or $gh_IniCrypt_Key < 0 Then
		Return SetError(@error, 0, 0)
	EndIf

	$gi_IniCrypt_AlgID = $i_alg
	$gi_IniCrypt_HashAlgID = $i_hashalg

	Return 1
EndFunc
#endregion initiate/shutdown functions

#region internal functions
;===================================================================================================
;
; Function Name....:    __IniCrypt_ValidateCheck()
; Description......:    Internal Use Only
; Parameter(s).....:
;                       $i_level:
; Return Value(s)..:
;                       Success...:
;                       Failure...:
;                       Error.....:
;                       Extended..:
; Requirement(s)...:
; Author(s)........:    SmOke_N (Ron Nielsen)
; Modified.........:
; Comment(s).......:
; Example(s).......:
;
;===================================================================================================

Func __IniCrypt_ValidateCheck($i_level = -1)

	_IniCrypt_Initiate()
	If @error Then Return SetError(1, 0, 0)
	If $i_level = 1 Then Return 1

	If $gi_IniCrypt_AlgID < 0 Then
		Return SetError(2, 0, 0)
	EndIf
	If $i_level = 2 Then Return 1

	If $gi_IniCrypt_HashAlgID < 0 Then
		Return SetError(3, 0, 0)
	EndIf
	If $i_level = 3 Then Return 1

	If $gh_IniCrypt_Key < 1 Then
		Return SetError(4, 0, 0)
	EndIf

	Return 1
EndFunc
#endregion internal functions