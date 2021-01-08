;=============================================================================
;
; Description:     	Returns a hash for a string using one of the *Deep command line utilities
; Version:          1.0.1
; Syntax:           _StringHash($sString,$iMethod,$iRunErrorsFatal = -1, $vEXEPath = -1)
;
; Parameter(s):     $sString                    = The string to generate the hash for.
;					$iMethod                    = determines which hashing method to use on the string
;								0        Use MD5 hashing method
;								1        Use SHA1 hashing method
;								2        Use SHA256 hashing method
;								3        Use Tiger hashing method
;								4        Use WhirlPool hashing method
;					$iRunErrorsFatal (optional) = Determines whether the script should exit with a runtime error if the run of the *Deep utility fails.
;								-1 (Default)  Use whatever the "RunErrorsFatal" option is currently set to. (1 unless it was changed using the “Opt” or “AutoItSetOption” functions)
;								0             Set @Error to 2 if the run fails
;								1             Exit with a runtime error if the run fails.
;					$vEXEPath (Optional)        = Indicates the full path of the *Deep command line utility
; Requirement(s):   *Deep Command Line utilities (can be found at http://sourceforge.net/projects/md5deep)
; Return Value(s):  On Success - Returns the hash for $sString
;					On Failure - Returns an empty string and sets @Error on errors
;						   @Error=1 $iMethod was invalid (must be an integer between 0 and 4)
;                          @Error=2 $iRunErrorsFatal was invalid (Must be 1,0,-1 or omitted)
;                          @Error=3 The *Deep utility was not found (This function expects it to be in @ScriptDir & "\<HASHMETHODNAME>Deep.exe" (where <HASHMETHODNAME> is name of the hash method such as MD5) unless set differently with the parameter $vEXEPath)
;                          @Error=4 Run Failed (only possible if the parameter $RunErrorsFatal=0 or the "RunErrorsFatal" option was manually set to 1.)
;                          @Error=5 Hash Generation Failed (The output from the *Deep utility was invalid.)
; Author(s):        SolidSnake <MetalGearX91@Hotmail.com>
; Note(s):	 -To use each hashing method you need to have the respective *Deep command line utility in the same directory as the script 
;                    or you have to set the parameter $vEXEPath to its location at the time you call that particular hash method. 
;                    For example to use the SHA1 hashing method you need SHA1Deep.exe in the same directory as your script or you would have to set the parameter $vEXEPath to
;                    its location (such as "C:\SHA1Deep.exe"), for example if you were using MD5 you would need MD5Deep.exe and so on.
;	        -This version (1.0) of _StringHash has been tested to be compatible with V1.9.2 (Recommended) of the *Deep utilities
;	        -You do not need to include all the *Deep utilities with\in your script, just the ones for the hash method(s) your script uses.
;           -You cannot not $vEXEPath point to a different exe other than the one for the hash method you are using or an @Error will occur , however you can rename the exes as long 
;                    as you set $vEXEPath to it's new name and location. For example “C:\RenamedDeepMD5.exe”
;===============================================================================
Func _StringHash($sString,$iMethod,$iRunErrorsFatal = -1, $vEXEPath = -1)
	Local $sEXEPath,$iHashLen,$iOpt, $hPID, $sHash,$sEXEPath,$iError
	Switch $iMethod
	Case 0
		$sEXEPath=@ScriptDir & "\MD5Deep.exe"
		$iHashLen=32
	Case 1
		$sEXEPath=@ScriptDir & "\SHA1Deep.exe"
		$iHashLen=40
	Case 2
		$sEXEPath=@ScriptDir & "\SHA256Deep.exe"
		$iHashLen=64
	Case 3
		$sEXEPath=@ScriptDir & "\TigerDeep.exe"
		$iHashLen=48
	Case 4
		$sEXEPath=@ScriptDir & "\WhirlPoolDeep.exe"
		$iHashLen=128
	Case Else
		SetError(1)
		Return ""
	EndSwitch
		
	If Not ($iRunErrorsFatal = 0 Or $iRunErrorsFatal = 1 Or $iRunErrorsFatal = -1) Then
		SetError(2)
		Return ""
	EndIf
	If $vEXEPath <> -1 Then
		$sEXEPath = $vEXEPath
	EndIf
	If Not FileExists($sEXEPath) Or StringInStr($sEXEPath, "*") Or StringInStr($sEXEPath, "?") or not StringInStr($sEXEPath,"\") Then
		SetError(3)
		Return ""
	EndIf
	If $iRunErrorsFatal<>-1 then $iOpt = opt("RunErrorsFatal", $iRunErrorsFatal)
	$hPID = Run($sEXEPath, @SystemDir, @SW_HIDE, 3)
	$iError=@Error
	If $iRunErrorsFatal<>-1 then opt("RunErrorsFatal", $iOpt)
	If $iRunErrorsFatal <> - 1 Then opt("RunErrorsFatal", $iOpt)
	If $iError Then
		SetError(4)
		Return ""
	EndIf
	StdinWrite($hPID, $sString)
	StdinWrite($hPID)
	$sHash = StringTrimRight(StdoutRead($hPID), 2)
	If Not StringIsXDigit($sHash) Or StringLen($sHash) <> $iHashLen Then
		SetError(5)
		Return ""
	EndIf
	SetError(0)
	Return $sHash
EndFunc   ;==>_StringHash