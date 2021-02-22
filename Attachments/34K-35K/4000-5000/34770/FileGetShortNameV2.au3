#include-once
#include <File.au3>

;-----------------------------------------------------------------------------------------
; Name .........: FileGetShortNameV2
; Description ..: Helper for paths that are too long.
;                 If provide a path such as:
;                      "\\storage01\versions$\AutoTesting
;                      \ATM_Ats600\Data\Data.NEW.[TESTSERV--XP].20100209175501
;                      \TestModule.Ats.Scenario1.PublishNotepad.TrainingData.Result
;                      \TEST BUILD\prepublish\test.assima_demo
;                      \test.assima_demo.eng.dtb"
;                 You will get the following output:
;                      "t:\AT9E7A~1\Data\DAF271~1.201\TESTMO~1.RES\TESTBU~1
;                      \PREPUB~1\TE78E5~1.ASS\test.assima_demo.eng.dtb"
; Note .........: [REF. 2010-07-15-164541] This function doesn't crash on a
;                 file such as:
;                      "C:\AutoTestingV2.Refs\AtsQa600v01-ALL_HOSTS
;                      \ATS.06.1000.100000-00-00-0000
;                      \TestModule.Ats.Base.OpenFirstLessonInContentPlanV1
;                      \Workspace\TrainingData\TEST BUILD\templates
;                      \assima_epss_theme.tpl.unpacked
;                      \contextual_enote_set.tpl.unpacked\business.tpl.unpacked
;                      \tpl_info.the"
; Return .......: String - See FileGetShortName for more info.
;-----------------------------------------------------------------------------------------
Func FileGetShortNameV2($path)
	;;;ValTrace($path, '$path')
	$path = DenormalizePath_For_FileGetShortNameV2_($path)
	;;;ValTrace($path, '$path')
	$part1 = ""
	$part2 = ""
	GetBiggestExistingSubPath_For_FileGetShortNameV2_($path, $part1, $part2)
	;;;ValTrace($part1, '$part1')
	;;;ValTrace($part2, '$part2')
	If $part1 = "" Then
		; Disable fatal errors (JUL 2, 2010 - For use with DynamicBehaviourAdding.au3)
		; FatalError("Path '"&$path&"' is invalid!")
	EndIf
	If $part2 = "" Then
		; get parent directory
		Dim $szDrive = "", $szDir = "", $szFName = "", $szExt = ""
		_PathSplit($path, $szDrive, $szDir, $szFName, $szExt)
		$part1 = $szDrive & $szDir
		; get file name
		Dim $szDrive = "", $szDir = "", $szFName = "", $szExt = ""
		_PathSplit($path, $szDrive, $szDir, $szFName, $szExt)
		$part2 = $szFName & $szExt
	EndIf
	$part1 = FileGetShortName($part1)
	;;;ValTrace($part1, '$part1')
	Return $part1 & $part2
EndFunc   ;==>FileGetShortNameV2

;-------------------------------------------------------------------------------
; Name .........: GetBiggestExistingSubPath_For_FileGetShortNameV2_
; Description ..: sub for 'FileGetShortNameV2'
; Return .......: string
;-------------------------------------------------------------------------------
Func GetBiggestExistingSubPath_For_FileGetShortNameV2_($path, ByRef $part1, ByRef $part2)
	If StringStartsWith_For_FileGetShortNameV2_($path, "\\") Then
		; Disable fatal errors (JUL 2, 2010 - For use with DynamicBehaviourAdding.au3)
		; FatalError("UNC Paths such as '"&$path&"' are not supported!")
	EndIf
	$pathBits = StringSplit($path, "\")

	$biggestExistingSubPath = ""
	$lastBitUsed = 0
	For $i = 1 To $pathBits[0]
		$tryPath = $pathBits[1]
		For $j = 2 To $i
			$tryPath &= "\" & $pathBits[$j]
		Next
		;ConsoleWrite($tryPath&"..."&@CRLF)
		If FileExists($tryPath) Then
			$biggestExistingSubPath = $tryPath
			$lastBitUsed = $i
		Else
			ExitLoop
		EndIf
	Next

	$part1 = $biggestExistingSubPath
	$part2 = ""

	If $part1 = "" Then
		$part2 &= $path
	Else
		For $i = $lastBitUsed + 1 To $pathBits[0]
			$part2 &= "\" & $pathBits[$i]
		Next
	EndIf

	Return True
EndFunc   ;==>GetBiggestExistingSubPath_For_FileGetShortNameV2_

;-------------------------------------------------------------------------------
; Name .........: DenormalizePath_For_FileGetShortNameV2_ (REF. PS40A4213F-1)
; Description ..: Replace UNC path by Mapped Drive
;                   ( eg. "\\storage01\versions$\AutoTesting\" -> "T:\" )
;
;                 For instance, using "diff.exe", if you call
;                     cmd.exe /c diff.exe --text "\\storage01\share\file1.txt"_
;                       "C:\local\file2.txt"
;                 you will get the follwing error message:
;					diff: \storage01\share\file1.txt: No such file or directory
;                 this is due to "diff.exe" that replaces '\\storage01\(...)'
;                 by '\storage01\(...)'.
;
;                 An other example is "EasyDump.bat" that fails dumping an
;                 assima thesaurus if this one is described using UNC paths.
;
;                 Calling this method before invoking some command line
;                 executable might prevent those problems.
; Return .......: string containing denormalized path
; TODO..........: use flags ( see "NormalizePath" ) and allow to also restore
;                 local paths ( eg. if @ComputerName == "testserv--xp" then
;                 "\\testserv--xp\C$\" <=> "C:\" )
;-------------------------------------------------------------------------------
Func DenormalizePath_For_FileGetShortNameV2_($szPath_in)
	$szDrive = ""
	$szMapping = ""
	$drives = DriveGetDrive("all")
	If Not @error Then
		For $i = 1 To $drives[0]
			If DriveGetType($drives[$i]) = "Network" Then
				$szMapping_tmp = DriveMapGet($drives[$i])
				If StringStartsWith_For_FileGetShortNameV2_($szPath_in, $szMapping_tmp) Then
					If StringLen($szMapping_tmp) > StringLen($szMapping) Then
						$szDrive = $drives[$i]
						$szMapping = $szMapping_tmp
					EndIf
				EndIf
			EndIf
		Next
	EndIf
	If $szDrive <> "" Then
		Return StringReplace($szPath_in, $szMapping, $szDrive)
	Else
		Return $szPath_in
	EndIf
EndFunc   ;==>DenormalizePath_For_FileGetShortNameV2_

;-------------------------------------------------------------------------------
; Name .........: StringStartsWith_For_FileGetShortNameV2_
; Description ..: case sensitive by default
; Return .......:
;-------------------------------------------------------------------------------
Func StringStartsWith_For_FileGetShortNameV2_($string, $begin, $casesense = 1)
	Return Not StringCompare(StringLeft($string, StringLen($begin)), $begin, $casesense)
EndFunc   ;==>StringStartsWith_For_FileGetShortNameV2_
