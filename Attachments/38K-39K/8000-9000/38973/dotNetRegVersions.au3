#include-once

#cs
  ; Change History
  ===================================================================================================
  2012-11-13 - Ron
  Version:  1.0.3
  Changed:  Now accepts integers/numbers/strings for versionexists()
  Fixed:    __dotNet_reg_hasVersion1_0(); reading wrong val
  ===================================================================================================
  2012-11-12 - Ron
  Version:  1.0.2 & 1.0.1
  Changed:  Combined most helper funcs
  Added:    4.5 validation
  ===================================================================================================
  2012-11-11 - Ron
  Version:  1.0.0
  Initital
  ===================================================================================================
#ce


; #Function Names#===================================================================================
;    _dotNet_reg_Exists()
;    _dotNet_reg_VersionAll()
;    _dotNet_reg_VersionExists()
;    _dotNet_reg_VersionIsAtLeast()
;    _dotNet_reg_VersionLatest()
; ===================================================================================================

;===================================================================================================
;
; Function Name....:    _dotNet_reg_Exists()
; Description......:    Verifies if .Net is installed from registry
; Parameter(s).....:    none
; Return Value(s)..:
;                       Success...: True
;                       Failure...: False
;                       Error.....:
;                                   1. Does not exist
; Requirement(s)...:    .Net 1.0 to 4.5
; Author(s)........:    SmOke_N (Ron Nielsen)
; Modified.........:    N/A
; Comment(s).......:
; Example(s).......:
;
;===================================================================================================

Func _dotNet_reg_Exists()

	_dotNet_reg_VersionAll()
	If @error Then Return SetError(1, 0, False)

	Return True
EndFunc   ;==>_dotNet_reg_Exists

;===================================================================================================
;
; Function Name....:    _dotNet_reg_VersionAll()
; Description......:    Return an array of all the installed versions, service packs, and other
; Parameter(s).....:    none
; Return Value(s)..:
;                       Success...: A 2D array (Columns: Version, Service Pack, Other )
;                       Failure...: Zero and @error set
;                       Error.....:
;                                   1. No version or service pack data
;                                   2. Version array bounds less/greater than service pack bounds
; Requirement(s)...:    .Net 1.0 to 4.5
; Author(s)........:    SmOke_N (Ron Nielsen)
; Modified.........:    N/A
; Comment(s).......:
; Example(s).......:
;
;===================================================================================================

Func _dotNet_reg_VersionAll()
	; return version, service pack, and other ( eg. full/client )
	Local $s_vers, $s_servpack, $s_other

	Local $s_val = ""
	$s_val = __dotNet_reg_hasVersion("4.5", "Full")
	If Not @error Then
		$s_vers &= "4.5" & @LF
		$s_servpack &= String(Number($s_val)) & @LF
		$s_other &= "Full" & @LF
	EndIf

	$s_val = __dotNet_reg_hasVersion("4.5", "Client")
	If Not @error Then
		$s_vers &= "4.5" & @LF
		$s_servpack &= String(Number($s_val)) & @LF
		$s_other &= "Client" & @LF
	EndIf

	$s_val = __dotNet_reg_hasVersion("4.0", "Full")
	If Not @error Then
		$s_vers &= "4.0" & @LF
		$s_servpack &= String(Number($s_val)) & @LF
		$s_other &= "Full" & @LF
	EndIf

	$s_val = __dotNet_reg_hasVersion("4.0", "Client")
	If Not @error Then
		$s_vers &= "4.0" & @LF
		$s_servpack &= String(Number($s_val)) & @LF
		$s_other &= "Client" & @LF
	EndIf

	$s_val = __dotNet_reg_hasVersion("3.5")
	If Not @error Then
		$s_vers &= "3.5" & @LF
		$s_servpack &= String(Number($s_val)) & @LF
		$s_other &= @LF
	EndIf

	$s_val = __dotNet_reg_hasVersion("3.0")
	If Not @error Then
		$s_vers &= "3.0" & @LF
		$s_servpack &= String(Number($s_val)) & @LF
		$s_other &= @LF
	EndIf

	$s_val = __dotNet_reg_hasVersion("2.0")
	If Not @error Then
		$s_vers &= "2.0" & @LF
		$s_servpack &= String(Number($s_val)) & @LF
		$s_other &= @LF
	EndIf

	$s_val = __dotNet_reg_hasVersion("1.1")
	If Not @error Then
		$s_vers &= "1.1" & @LF
		$s_servpack &= String(Number($s_val)) & @LF
		$s_other &= @LF
	EndIf

	$s_val = __dotNet_reg_hasVersion("1.0")
	If Not @error Then
		$s_vers &= "1.0" & @LF
		$s_servpack &= String(Number($s_val)) & @LF
		$s_other &= @LF
	EndIf

	$s_vers = StringTrimRight($s_vers, 1)
	$s_servpack = StringTrimRight($s_servpack, 1)
	$s_other = StringTrimRight($s_other, 1)

	If Not $s_vers Or Not $s_servpack Then Return SetError(1, 0, 0)

	Local $a_vers = StringSplit($s_vers, @LF)
	Local $a_serpack = StringSplit($s_servpack, @LF)
	Local $a_other = StringSplit($s_other, @LF)

	If $a_vers[0] <> $a_serpack[0] Then Return SetError(2, 0, 0)

	Local $a_ret[$a_vers[0] + 1][3] = [[$a_vers[0]]]

	For $i = 1 To $a_vers[0]
		$a_ret[$i][0] = $a_vers[$i]
		$a_ret[$i][1] = $a_serpack[$i]
		$a_ret[$i][2] = $a_other[$i]
	Next

	Return $a_ret
EndFunc   ;==>_dotNet_reg_VersionAll

;===================================================================================================
;
; Function Name....:    _dotNet_reg_VersionExists()
; Description......:    Validate that the version you need exists
; Parameter(s).....:
;                       $s_vers: Version type from 1.0, 1.1, 2.0, 3.0, 3.5, 4.0, to 4.5
; Return Value(s)..:
;                       Success...: True
;                       Failure...: False
;                       Error.....:
;                                   1. Does not exist
; Requirement(s)...:    .Net 1.0 to 4.5
; Author(s)........:    SmOke_N (Ron Nielsen)
; Modified.........:    N/A
; Comment(s).......:
; Example(s).......:
;
;===================================================================================================

Func _dotNet_reg_VersionExists($s_vers)

	Local $s_val = __dotNet_reg_hasVersion($s_vers)
	If @error Then Return SetError(1, 0, False)

	Return True
EndFunc   ;==>_dotNet_reg_VersionExists

;===================================================================================================
;
; Function Name....:    _dotNet_reg_VersionIsAtLeast()
; Description......:    Validate a minimum value version exists
; Parameter(s).....:
;                       $s_vers: Version type from 1.0, 1.1, 2.0, 3.0, 3.5, 4.0, to 4.5
; Return Value(s)..:
;                       Success...: True
;                       Failure...: False
;                       Error.....:
;                                   1. .Net does not exist
; Requirement(s)...:    .Net 1.0 to 4.5
; Author(s)........:    SmOke_N (Ron Nielsen)
; Modified.........:    N/A
; Comment(s).......:
; Example(s).......:
;
;===================================================================================================

Func _dotNet_reg_VersionIsAtLeast($s_vers)

	Local $a_val = _dotNet_reg_VersionAll()
	If @error Then Return SetError(1, 0, False)

	$s_vers = Number($s_vers)

	For $i = 1 To UBound($a_val) - 1
		If Number($a_val[$i][0]) >= $s_vers Then Return True
	Next

	Return SetError(2, 0, False)
EndFunc   ;==>_dotNet_reg_VersionIsAtLeast

;===================================================================================================
;
; Function Name....:    _dotNet_reg_VersionLatest()
; Description......:    Get the latest released version installed
; Parameter(s).....:    none
; Return Value(s)..:
;                       Success...: A 2D array of the version, service pack, and other
;                       Failure...: 0
;                       Error.....:
;                                   1. .Net does not exist
; Requirement(s)...:    .Net 1.0 to 4.5
; Author(s)........:    SmOke_N (Ron Nielsen)
; Modified.........:    N/A
; Comment(s).......:
; Example(s).......:
;
;===================================================================================================

Func _dotNet_reg_VersionLatest()

	Local $a_val = _dotNet_reg_VersionAll()
	If @error Then Return SetError(1, 0, 0)

	Local $a_ret[2][3] = [[1]]
	$a_ret[1][0] = $a_val[1][0]
	$a_ret[1][1] = $a_val[1][1]
	$a_ret[1][2] = $a_val[1][2]

	Return $a_ret
EndFunc   ;==>_dotNet_reg_VersionLatest

#region helper funcs
;===================================================================================================
;
; Function Name....:    __dotNet_reg_hasVersion()
; Description......:    Internal function, do not use
; Author(s)........:    SmOke_N (Ron Nielsen)
;
;===================================================================================================

Func __dotNet_reg_hasVersion($v_version, $s_other = "")

	Local $s_hklm = "HKLM64"
	If @OSArch = "x86" Then $s_hklm = "HKLM"

	Local $s_netv, $s_netsp
	Switch Number($v_version)
		Case 4.5, 4
			$s_netv = $s_hklm & "\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\" & $s_other
			If StringLeft(RegRead($s_netv, "Version"), 3) <> $v_version Then Return SetError(-1, 0, 0)
			If Number($v_version) = 4.5 And Int(RegRead($s_netv, "Release")) < 378389 Then Return SetError(-2, 0, 0)
		Case 3.5
			$s_netv = $s_hklm & "\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5"
		Case 3
			$s_netv = $s_hklm & "\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.0"
		Case 2
			$s_netv = $s_hklm & "\SOFTWARE\Microsoft\NET Framework Setup\NDP\v2.0.50727"
		Case 1.1
			$s_netv = $s_hklm & "\SOFTWARE\Microsoft\NET Framework Setup\NDP\v1.1.4322"
		Case 1
			$s_val = __dotNet_reg_hasVersion1_0($s_hklm)
			Return SetError(@error, @extended, $s_val)
	EndSwitch

	If Int(RegRead($s_netv, "Install")) <> 1 Then Return SetError(1, 0, 0)

	$s_netsp = Number(RegRead($s_netv, "SP"))
	If $s_netsp = 0 Then $s_netsp = 1

	Return $s_netsp
EndFunc   ;==>__dotNet_reg_hasVersion

;===================================================================================================
;
; Function Name....:    __dotNet_reg_hasVersion1_0()
; Description......:    Internal function, do not use
; Author(s)........:    SmOke_N (Ron Nielsen)
;
;===================================================================================================

Func __dotNet_reg_hasVersion1_0($s_hklm)

	Local $s_netv = $s_hklm & "\Software\Microsoft\.NET Framework\Policy\v1.0"
	Local $s_netsp = $s_hklm & "\Software\Microsoft\Active Setup\Installed Components" & _
		"{78705f0d-e8db-4b2d-8193-982bdda15ecd}"
	Local $s_netspmc = $s_hklm & "\Software\Microsoft\Active Setup\Installed Components\" & _
		"{FDC11A6F-17D1-48f9-9EA3-9051954BAA24}"

	RegRead($s_netv, "3705")
	If @error Then
		$s_netv = $s_hklm & "\Software\Microsoft\.NETFramework\Policy\v1.0"
		RegRead($s_netv, "3705")
		If @error Then Return SetError(1, 0, 0)
	EndIf

	Local $s_val = RegRead($s_netsp, "Version")
	Local $a_sre = StringRegExp($s_val, "1\.0\.3705\.(\d+)", 1)
	If @error Then
		$s_val = RegRead($s_netspmc, "Version")
		$a_sre = StringRegExp($s_val, "1\.0\.3705\.(\d+)", 1)
		If @error Then Return 1
	EndIf

	Return Number($a_sre[0])
EndFunc   ;==>__dotNet_reg_hasVersion1_0
#endregion helper funcs