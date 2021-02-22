#include "FileGetShortNameV2.au3"

; CONSTANTS

Const $AUTOIT_UNIT_TEST_WORKSPACE = @TempDir & "\AutoIT_Unit_Test_Workspace"

Dim $SUB_DIR_LIST[10] = ["Aaaaaaaaaaa-aaaa_aaaa" _
		, "Bbb.00.0000.000000-00-00-0000" _
		, "CccccCccccc.Ccc.Cccc.CcccCccccCccccCcCccccccCccccc" _
		, "Ddddddddd" _
		, "Eeeeeeeeeeee" _
		, "FFFF FFFFF" _
		, "ggggggggg" _
		, "hhhhhh_hhhh_hhhhh.hhh.hhhhhhhh" _
		, "iiiiiiiiii_iiiii_iii.iii.iiiiiiii" _
		, "jjjjjjjj.jjj.jjjjjjjj" _
		]

Const $UNIT_TEST_DIR_ROOT = $AUTOIT_UNIT_TEST_WORKSPACE & "\FileGetShortNameVx\CrashTest"


; MAIN

$ONLY_CLEANUP_RUN = 0
FileGetShortNameV2_Demo_Main()


; FUNCTIONS

Func FileGetShortNameV2_Demo_Main()
	If $ONLY_CLEANUP_RUN Then
		FileGetShortNameV2_Demo_TearDownV2()
	Else
		$currentParentPath = FileGetShortNameV2_Demo_SetUp()
		FileGetShortNameV2_Demo_Test01($currentParentPath)
	EndIf
EndFunc   ;==>FileGetShortNameV2_Demo_Main


Func FileGetShortNameV2_Demo_SetUp()

	;  --- SAMPLE OUTPUT ---
	; DirCreate('C:\DOCUME~1\PSZCZE~1\LOCALS~1\Temp\AUTOIT~1\FILEGE~1\CRASHT~1\Aaaaaaaaaaa-aaaa_aaaa')...
	; DirCreate('C:\DOCUME~1\PSZCZE~1\LOCALS~1\Temp\AUTOIT~1\FILEGE~1\CRASHT~1\AAAAAA~1\Bbb.00.0000.000000-00-00-0000')...
	; DirCreate('C:\DOCUME~1\PSZCZE~1\LOCALS~1\Temp\AUTOIT~1\FILEGE~1\CRASHT~1\AAAAAA~1\BBB000~1.000\CccccCccccc.Ccc.Cccc.CcccCccccCccccCcCccccccCccccc')...
	; DirCreate('C:\DOCUME~1\PSZCZE~1\LOCALS~1\Temp\AUTOIT~1\FILEGE~1\CRASHT~1\AAAAAA~1\BBB000~1.000\CCCCCC~1.CCC\Ddddddddd')...
	; DirCreate('C:\DOCUME~1\PSZCZE~1\LOCALS~1\Temp\AUTOIT~1\FILEGE~1\CRASHT~1\AAAAAA~1\BBB000~1.000\CCCCCC~1.CCC\DDDDDD~1\Eeeeeeeeeeee')...
	; DirCreate('C:\DOCUME~1\PSZCZE~1\LOCALS~1\Temp\AUTOIT~1\FILEGE~1\CRASHT~1\AAAAAA~1\BBB000~1.000\CCCCCC~1.CCC\DDDDDD~1\EEEEEE~1\FFFF FFFFF')...
	; DirCreate('C:\DOCUME~1\PSZCZE~1\LOCALS~1\Temp\AUTOIT~1\FILEGE~1\CRASHT~1\AAAAAA~1\BBB000~1.000\CCCCCC~1.CCC\DDDDDD~1\EEEEEE~1\FFFFFF~1\ggggggggg')...
	; DirCreate('C:\DOCUME~1\PSZCZE~1\LOCALS~1\Temp\AUTOIT~1\FILEGE~1\CRASHT~1\AAAAAA~1\BBB000~1.000\CCCCCC~1.CCC\DDDDDD~1\EEEEEE~1\FFFFFF~1\GGGGGG~1\hhhhhh_hhhh_hhhhh.hhh.hhhhhhhh')...
	; DirCreate('C:\DOCUME~1\PSZCZE~1\LOCALS~1\Temp\AUTOIT~1\FILEGE~1\CRASHT~1\AAAAAA~1\BBB000~1.000\CCCCCC~1.CCC\DDDDDD~1\EEEEEE~1\FFFFFF~1\GGGGGG~1\HHHHHH~1.HHH\iiiiiiiiii_iiiii_iii.iii.iiiiiiii')...
	; DirCreate('C:\DOCUME~1\PSZCZE~1\LOCALS~1\Temp\AUTOIT~1\FILEGE~1\CRASHT~1\AAAAAA~1\BBB000~1.000\CCCCCC~1.CCC\DDDDDD~1\EEEEEE~1\FFFFFF~1\GGGGGG~1\HHHHHH~1.HHH\IIIIII~1.III\jjjjjjjj.jjj.jjjjjjjj')...
	; ----------------------

	ConsoleWrite("DirCreate('" & $UNIT_TEST_DIR_ROOT & "')..." & @CRLF)
	DirCreate($UNIT_TEST_DIR_ROOT)

	; prepare next iteration
	$currentParentPath = $UNIT_TEST_DIR_ROOT
	$currentParentShortPath = FileGetShortName($currentParentPath)
	; loop down the path
	For $subDir In $SUB_DIR_LIST
		; create the directories
		$currentDirPath = $currentParentPath & "\" & $subDir
		$currentDirPseudoShortPath = $currentParentShortPath & "\" & $subDir
		; action - create the directories
		ConsoleWrite("DirCreate('" & $currentDirPseudoShortPath & "')..." & @CRLF)
		DirCreate($currentDirPseudoShortPath)
		; prepare next iteration
		$currentParentPath = $currentDirPath
		$currentParentShortPath = FileGetShortName($currentDirPseudoShortPath)
	Next

	Return $currentParentPath

EndFunc   ;==>FileGetShortNameV2_Demo_SetUp

Func FileGetShortNameV2_Demo_TearDownV1() ; USELESSS
	; not able to remove... -> crashes
	; DirRemove with 'recurs' option does not work when the directory contains
	; sub-directories that have a path that is too long.
	If Not DirRemove($AUTOIT_UNIT_TEST_WORKSPACE, 1) Then
		MsgBox(48, "Error", "Unable to delete...")
	EndIf
EndFunc   ;==>FileGetShortNameV2_Demo_TearDownV1

Func FileGetShortNameV2_Demo_TearDownV2()

	;  --- SAMPLE OUTPUT ---
	; DirRemove('C:\DOCUME~1\PSZCZE~1\LOCALS~1\Temp\AUTOIT~1\FILEGE~1\CRASHT~1\AAAAAA~1\BBB000~1.000\CCCCCC~1.CCC\DDDDDD~1\EEEEEE~1\FFFFFF~1\GGGGGG~1\HHHHHH~1.HHH\IIIIII~1.III\JJJJJJ~1.JJJ')...
	; DirRemove('C:\DOCUME~1\PSZCZE~1\LOCALS~1\Temp\AUTOIT~1\FILEGE~1\CRASHT~1\AAAAAA~1\BBB000~1.000\CCCCCC~1.CCC\DDDDDD~1\EEEEEE~1\FFFFFF~1\GGGGGG~1\HHHHHH~1.HHH\IIIIII~1.III')...
	; DirRemove('C:\DOCUME~1\PSZCZE~1\LOCALS~1\Temp\AUTOIT~1\FILEGE~1\CRASHT~1\AAAAAA~1\BBB000~1.000\CCCCCC~1.CCC\DDDDDD~1\EEEEEE~1\FFFFFF~1\GGGGGG~1\HHHHHH~1.HHH')...
	; DirRemove('C:\DOCUME~1\PSZCZE~1\LOCALS~1\Temp\AUTOIT~1\FILEGE~1\CRASHT~1\AAAAAA~1\BBB000~1.000\CCCCCC~1.CCC\DDDDDD~1\EEEEEE~1\FFFFFF~1\GGGGGG~1')...
	; DirRemove('C:\DOCUME~1\PSZCZE~1\LOCALS~1\Temp\AUTOIT~1\FILEGE~1\CRASHT~1\AAAAAA~1\BBB000~1.000\CCCCCC~1.CCC\DDDDDD~1\EEEEEE~1\FFFFFF~1')...
	; DirRemove('C:\DOCUME~1\PSZCZE~1\LOCALS~1\Temp\AUTOIT~1\FILEGE~1\CRASHT~1\AAAAAA~1\BBB000~1.000\CCCCCC~1.CCC\DDDDDD~1\EEEEEE~1')...
	; DirRemove('C:\DOCUME~1\PSZCZE~1\LOCALS~1\Temp\AUTOIT~1\FILEGE~1\CRASHT~1\AAAAAA~1\BBB000~1.000\CCCCCC~1.CCC\DDDDDD~1')...
	; DirRemove('C:\DOCUME~1\PSZCZE~1\LOCALS~1\Temp\AUTOIT~1\FILEGE~1\CRASHT~1\AAAAAA~1\BBB000~1.000\CCCCCC~1.CCC')...
	; DirRemove('C:\DOCUME~1\PSZCZE~1\LOCALS~1\Temp\AUTOIT~1\FILEGE~1\CRASHT~1\AAAAAA~1\BBB000~1.000')...
	; DirRemove('C:\DOCUME~1\PSZCZE~1\LOCALS~1\Temp\AUTOIT~1\FILEGE~1\CRASHT~1\AAAAAA~1')...
	; ----------------------


	; prepare next iteration
	$currentParentPath = $UNIT_TEST_DIR_ROOT
	$currentParentShortPath = FileGetShortName($currentParentPath)
	; loop down the path
	For $i = 0 To UBound($SUB_DIR_LIST) - 1
		$subDir = $SUB_DIR_LIST[$i]
		; create the directories
		$currentDirPath = $currentParentPath & "\" & $subDir
		$currentDirPseudoShortPath = $currentParentShortPath & "\" & $subDir
		; prepare next iteration
		$currentParentPath = $currentDirPath
		$currentParentShortPath = FileGetShortName($currentDirPseudoShortPath)
		; action - store data
		; WARNING: do not continue -> FileGetShortName will continue if file does not exist
		If Not FileExists($currentDirPseudoShortPath) Then Exit
		$SUB_DIR_LIST[$i] = FileGetShortName($currentDirPseudoShortPath)
	Next

	; loop down the path
	For $i = UBound($SUB_DIR_LIST) - 1 To 0 Step -1
		If FileExists($SUB_DIR_LIST[$i]) Then
			ConsoleWrite("DirRemove('" & $SUB_DIR_LIST[$i] & "')..." & @CRLF)
			DirRemove($SUB_DIR_LIST[$i])
		EndIf
	Next

EndFunc   ;==>FileGetShortNameV2_Demo_TearDownV2



Func FileGetShortNameV2_Demo_Test01($currentPath)

	;  --- SAMPLE OUTPUT ---
	; CALLING FileGetShortNameV2('C:\DOCUME~1\PSZCZE~1\LOCALS~1\Temp\AutoIT_Unit_Test_Workspace\FileGetShortNameVx\CrashTest\Aaaaaaaaaaa-aaaa_aaaa\Bbb.00.0000.000000-00-00-0000\CccccCccccc.Ccc.Cccc.CcccCccccCccccCcCccccccCccccc\Ddddddddd\Eeeeeeeeeeee\FFFF FFFFF\ggggggggg\hhhhhh_hhhh_hhhhh.hhh.hhhhhhhh\iiiiiiiiii_iiiii_iii.iii.iiiiiiii\jjjjjjjj.jjj.jjjjjjjj')...
	; @@ Debug(43) : $theRealTest = C:\DOCUME~1\PSZCZE~1\LOCALS~1\Temp\AUTOIT~1\FILEGE~1\CRASHT~1\AAAAAA~1\BBB000~1.000\CCCCCC~1.CCC\DDDDDD~1\EEEEEE~1\FFFFFF~1\GGGGGG~1\hhhhhh_hhhh_hhhhh.hhh.hhhhhhhh\iiiiiiiiii_iiiii_iii.iii.iiiiiiii\jjjjjjjj.jjj.jjjjjjjj
	; CALLING FileGetShortName('C:\DOCUME~1\PSZCZE~1\LOCALS~1\Temp\AutoIT_Unit_Test_Workspace\FileGetShortNameVx\CrashTest\Aaaaaaaaaaa-aaaa_aaaa\Bbb.00.0000.000000-00-00-0000\CccccCccccc.Ccc.Cccc.CcccCccccCccccCcCccccccCccccc\Ddddddddd\Eeeeeeeeeeee\FFFF FFFFF\ggggggggg\hhhhhh_hhhh_hhhhh.hhh.hhhhhhhh\iiiiiiiiii_iiiii_iii.iii.iiiiiiii\jjjjjjjj.jjj.jjjjjjjj')...
	; ---- + CRASH !!!
	; ----------------------

	ConsoleWrite("CALLING FileGetShortNameV2('" & $currentPath & "')..." & @CRLF)
	$theRealTest = FileGetShortNameV2($currentPath)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $theRealTest = ' & $theRealTest & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

	ConsoleWrite("CALLING FileGetShortName('" & $currentPath & "')..." & @CRLF)
	$theRealTest = FileGetShortName($currentPath)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $theRealTest = ' & $theRealTest & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

EndFunc   ;==>FileGetShortNameV2_Demo_Test01
