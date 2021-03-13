#include <WinApi.au3>
#include <Constants.au3>
Global $__SHAKEWINHWND = 0
Global $__SHAKES = 0
Global $__SHAKEPOWER = 0
Global $__SHAKEPHASE = 0
Global $__SHAKEPOS = 0
Global $__WINPOS = 0
Global $__WINSHAKE_SOUND = 0

; #FUNCTION# ====================================================================================================================
; Name ..........: _WinShake
; Description ...: Shake a window
; Syntax ........: _WinShake($Hwnd[, $Shakes = 5[, $ShakePower = 10[, $ShakeSpeed = 25]]])
; Parameters ....: $Hwnd                - An Windows Hwnd
;                  $Shakes              - Number of shakes
;                  $ShakePower          - Pixel to move
;                  $ShakeSpeed          - Time to wait between sheakes
;				   $SoundPath			- Path to a *.mp3 sound to play while shake is happen
;										- -1/Default keyword/True to Default Sound
;										- 0/False for no sound
; Return values .:  Succes - 1
;					Fail - 0
; Author ........: PlayHD
; Modified ......: PlayHD
; Remarks .......: 0.3
; Related .......: WinMove, _WinAPI_SetWindowPos
; Link ..........: http://www.autoitscript.com/forum/topic/149400-winshake/
; Example .......: Yes
; ===============================================================================================================================
Func _WinShake($Hwnd,$Shakes = 5,$ShakePower = 10, $ShakeSpeed = 40, $SoundPath = False)
	If $__WINPOS <> 0 Then __WINSHAKE_END()
	If $SoundPath = Default Then $SoundPath = -1
	If $SoundPath Then $__WINSHAKE_SOUND = _WinShake_Sound($SoundPath)
	If Not IsHWnd($Hwnd) Then $Hwnd = HWnd($Hwnd)
	$__SHAKEWINHWND = $Hwnd
	$__SHAKES = $Shakes
	$__SHAKEPOWER = $ShakePower
	$__WINPOS = _WinAPI_GetWindowPlacement($Hwnd)
	If Not IsDllStruct($__WINPOS) Then Return 0
	_WinAPI_SetWindowPos($__SHAKEWINHWND,0,DllStructGetData($__WINPOS,"rcNormalPosition", 1)+5,DllStructGetData($__WINPOS,"rcNormalPosition", 2),0,0,$SWP_NOSIZE )
	AdlibRegister("__WINSHAKE",$ShakeSpeed)
	$__SHAKEPHASE = 0
	Return 1
EndFunc

Func __WINSHAKE()
	Local Static $WINSHAKEMOVE	;0 Left ;;;; 1 Right
	If $WINSHAKEMOVE = 0 Then
		_WinAPI_SetWindowPos($__SHAKEWINHWND,0,DllStructGetData($__WINPOS,"rcNormalPosition", 1)+$__SHAKEPOWER,DllStructGetData($__WINPOS,"rcNormalPosition", 2),0,0,$SWP_NOSIZE )
		$WINSHAKEMOVE = 1
	Else
		_WinAPI_SetWindowPos($__SHAKEWINHWND,0,DllStructGetData($__WINPOS,"rcNormalPosition", 1)-$__SHAKEPOWER,DllStructGetData($__WINPOS,"rcNormalPosition", 2),0,0,$SWP_NOSIZE )
		$WINSHAKEMOVE = 0
	EndIf
	$__SHAKEPHASE += 1
	If $__SHAKEPHASE = $__SHAKES Then __WINSHAKE_END()
	Return 1
EndFunc

Func __WINSHAKE_END()
	_WinAPI_SetWindowPos($__SHAKEWINHWND,0,DllStructGetData($__WINPOS,"rcNormalPosition", 1),DllStructGetData($__WINPOS,"rcNormalPosition", 2),0,0,$SWP_NOSIZE )
	AdlibUnRegister("__WINSHAKE")
	$__WINPOS = 0
	FileDelete($__WINSHAKE_SOUND)
	SoundPlay("")
	SoundSetWaveVolume(100)
	$__WINSHAKE_SOUND = 0
	Return 1
EndFunc

#region Sound
Func _WinShake_Sound($FilePath)
	If $FilePath = -1 Then
		$FilePath = @TempDir&"\WinShake_Sound.MP3"
		Local $Sound
		$Sound &= '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'
		$Sound &= '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'
		$Sound &= '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'
		$Sound &= 'AACAAAAAACCXm00AZ0yImNIs44fPTnI6nu30KgshQgM+vxGECOATKhi3Z60x9Q4iJhV//yI8VTnFU5R7//+pqGoPlkVP/X/52dOkR4qyEeqdnP/yq//p4UebgcCoQ/qe2HijjvRNgFxcKALjvikijEcgB4gkOS0qL0ZoKYPgNEgDwP/7kmQWgAQDZleGCQAARil68MCcAA0Q6V34IwAA9RSrPwYgANEC2LPU/VB9I2JQUg2NAVCIxJvIrIES2vhuGEU9BIIcFBKMhDLRP/0ae5/ygzDGic4cH48U4RIM4FKkYZ/8VEVxK/IdyhasordGnUKsc//u//mDX//mLWNf9n+fRBwZPbTRiBiOEZVq9GIZkRxSaPlStpjvO3P0jo2OUvV6e52jol6mD7DgrMV9fzP/j86VeZ2f0ObtLwdnXovLYAIDREE0EhTZTKYSADcAmcMADFDe4XV4togDN9OxY9JRs0WZ6ndLXLG3ZcWka2FtL5zZmM7v9p239polcd8Y68/9+bb9tdu895+rdIpcLJaPcLs/8uUFFREDzDwcBRhNboaGAwOWB7mVADZkVgARISQXAAAAAAAJeISt/nWNTMpZw9H9sM5VdttDBXdOvwaKAoogtd3OEeVIW3/IqAv/S2xT//pV/nPGyEdUVt1EzKTnUBwcWUcHtXYTA44TVgGKAu1AcUa0MKIirW9dXbSowqkf/dlORTqqFVCqTb8l2yXFGKr/+5JEHwACrVnXBgSgAFHpCuDAoAAKqTtOuBUAAVewKmcCUAHFjBFmEW//I0jRTJkytEQmSFwmj/Of/0f/8W8LX24uyp+5YNzxYQRwPfNoWLh5IcjgeB0Gs2nB4pX45Vr6/r///4lf///5dO5WFWCRVP//zPr/61FaVYJCQad/nFTixglgqVOt/lP/50FQEfDm/v/mK46HLEGCHnVV52i1Pew/LzTZqO6HTUKGnaZimc80+p+q1V7aXmTT9U9DrNvPR3Y4eTDFq1Vovb6asT58eFnGnVKPCi8n+t464Yh/////pAAwq7RBaPTr///L6GWJh+5qq5zK6CLqc7Ch3lZio7ogIyDFD3SHDinAcLOxz/zkbSc7OH3b+if9Fux3shyqdURXbXWl1anZu1kI3/nejv6dB3a4487a/r5IdzOaKIFnEv53ma87YQnywGvP3LrGw3cOIVVSR/jXbAcP5fDUZpLs/2P2jg6d685My+4Uf6VuWxkcntnJV5acd4/v0rbjH5kdP3NnVTy05NV53tfrPud/0P9/z9DHO1kWKof/+U////uSRDSAA09dV4YIwABtx0s5wKQACr15QZwRAAFVLeq3gjAG1AAGff++ceef///5vjJi6l/n9SuKNskFeLkZPf6pVZ0IoZMJBSpSuOvYI06MCs3tp+4q1LIXT2JvUQGATFbcrjHxjHYVe7CeL6gQORzHA19IEC5CIAGH3CIKuwqGwgJAZNgMWVoWCDgFyx4Rf/9SeGSoT1rppCMPLIXQa3DesEMR72IeRern35gMoQWyO0ALTqgWnpdvQWLASCn1Yy/djs/hisRNAAKLCiitWYQcnknlvnLR/rv8xXpmKRzew6hjQ/UGgaAAAFtsaRIAX//zK5t594UPf0ulOXz9yZ2cofBxJovk1svPymf8yc1IzL9r88yfNO0EpJKaCKasoiXgh0lMy37sVNTnz/8//yPgczKZh3DhcABm/qQmAAEdFV143/8xh6VnDq+qmUB9YGLcU9lCohn4U8ErXgQMSzamQhPRJvUwaWlGd6f/1hvVzAwE3U6u3+bsDt+r17z66nQcMKfOOLDlAniGST6AAAAIh5fWSMlP/81+YWUPTv7USf/7kkQyAIKEXk/gIhNwUUuLDwRib4pVhWn0EQAxSbAndoIwAR0rmezOX8b535VM61XZ8yaSlT6ZjS0RP7f0MpWMl1VDKU2Z6836MlgrNWxavU298+50czvKphwuHSQhtT5IHeACAVntkbbdwAAAHxMfzOXy'
		$Sound &= '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'
		$Sound &= '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'
		$Sound &= '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'
		$Sound &= 'AEJKi1ES5mGxS4CykpwIEKEo2//qApFQUCrkCIRD24gAAAsdHI1nnW1bMwQXp/WWtQw03GToqioLRpHg7WNsQl4eQMhQBfiEHRqLQqi4geqKzmmlDzHY5UT1OVEVOioimO2n/Vf1RPoqIqLU4hIiIjBMy71t////qKz+RmXIyMyaaEf///rmJiHS6tY7plZRYHQeAcE4cC8TEjBjhnFP////xVv9VUxBTUUzLjk4LjRVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV'
		Local $bString = Binary(_Base64Decode($Sound))
		Local $hFile = FileOpen($FilePath, 18)
		FileWrite($hFile, $bString)
		FileClose($hFile)
	Else
		FileCopy($FilePath,@TempDir&"\WinShake_Sound.MP3",1)
		$FilePath = @TempDir&"\WinShake_Sound.MP3"
	EndIf
	SoundSetWaveVolume(20)
	SoundPlay($FilePath,0)
	Return $FilePath
EndFunc   ;==>_Sound

Func _Base64Decode($sB64String)
	Local $struct = DllStructCreate("int")
	Local $a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", "str", $sB64String, "int", 0, "int", 1, "ptr", 0, "ptr", DllStructGetPtr($struct, 1), "ptr", 0, "ptr", 0)
	If @error Or Not $a_Call[0] Then Return SetError(1, 0, "")
	Local $a = DllStructCreate("byte[" & DllStructGetData($struct, 1) & "]")
	$a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", "str", $sB64String, "int", 0, "int", 1, "ptr", DllStructGetPtr($a), "ptr", DllStructGetPtr($struct, 1), "ptr", 0, "ptr", 0)
	If @error Or Not $a_Call[0] Then Return SetError(2, 0, "")
	Return DllStructGetData($a, 1)
EndFunc   ;==>_Base64Decode
#endregion