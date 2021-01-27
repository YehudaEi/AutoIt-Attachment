;A Big Thanks To RazerM for his IDEA File Encryption Algorithm
;http://www.autoitscript.com/forum/index.php?showtopic=33238&st=0&p=240202&hl=idea%20encryption&fromsearch=1&#entry240202

If @Compiled Then ;allows testing in noncompiled version
	If $CMDLINE[0] = 0 Then
		MsgBox(0, '', "Can't be run from file")
		Exit
	EndIf
	Switch $CMDLINE[1]
		Case "-Lock"
			$State = "Lock"
		Case "-Unlock"
			$State = "Unlock"
		Case Else
			MsgBox(0, '', "ERROR")
			Exit
	EndSwitch
EndIf

;~ #include <Array.au3>
#include <IDEA File Encryption.au3>

HotKeySet("!{F4}", "Nothing") ;disable Alt+F4
Global Const $Pass = "abc123" ;edit this. Haven't gotten around to supporting password encryption
Global Const $ES_PASSWORD = 32
Global Const $WS_POPUP = 0x80000000
Global Const $WS_EX_ACCEPTFILES = 0x00000010
Global Const $GUI_DROPACCEPTED = 8

;WinAPI Constants
Global Const $__WINAPCONSTANT_CREATE_NEW = 1
Global Const $__WINAPCONSTANT_CREATE_ALWAYS = 2
Global Const $__WINAPCONSTANT_OPEN_EXISTING = 3
Global Const $__WINAPCONSTANT_OPEN_ALWAYS = 4
Global Const $__WINAPCONSTANT_TRUNCATE_EXISTING = 5
Global Const $__WINAPCONSTANT_FILE_ATTRIBUTE_READONLY = 0x00000001
Global Const $__WINAPCONSTANT_FILE_ATTRIBUTE_HIDDEN = 0x00000002
Global Const $__WINAPCONSTANT_FILE_ATTRIBUTE_SYSTEM = 0x00000004
Global Const $__WINAPCONSTANT_FILE_ATTRIBUTE_ARCHIVE = 0x00000020
Global Const $__WINAPCONSTANT_FILE_SHARE_READ = 0x00000001
Global Const $__WINAPCONSTANT_FILE_SHARE_WRITE = 0x00000002
Global Const $__WINAPCONSTANT_FILE_SHARE_DELETE = 0x00000004
Global Const $__WINAPCONSTANT_GENERIC_EXECUTE = 0x20000000
Global Const $__WINAPCONSTANT_GENERIC_WRITE = 0x40000000
Global Const $__WINAPCONSTANT_GENERIC_READ = 0x80000000

Global $szDrive, $szDir, $szFName, $szExt

$Form1 = GUICreate("Encrypt", 350, 146, -1, -1, $WS_POPUP, $WS_EX_ACCEPTFILES)
GUICtrlCreateLabel("Directory: ", 20, 20, 75, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$Input1 = GUICtrlCreateInput("", 104, 22, 225, 21)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
GUICtrlCreateLabel("Password: ", 20, 66, 81, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$Input2 = GUICtrlCreateInput("abc123", 104, 68, 225, 21, $ES_PASSWORD)
$OK = GUICtrlCreateButton("OK", 50, 104, 100, 25)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Cancel = GUICtrlCreateButton("Cancel", 199, 104, 100, 25)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUISetState(@SW_SHOW)

While 1
	$msg = GUIGetMsg()
	Switch $msg
		Case $Cancel
			Exit
		Case $OK
			If Not FileExists(GUICtrlRead($Input1)) Then Exit
			If GUICtrlRead($Input2) = $Pass Then
				$ActiveFolder = GUICtrlRead($Input1)
				If $State = "Lock" Then
					UnlockFolder($ActiveFolder)

					_WinAPI_CreateFile($ActiveFolder & "\Encrypted.ini", 0, 4, 0, 2 + 8)
					If Not @error Then
						RecursiveFolderUnlock($ActiveFolder)

						RecursiveFileLock($ActiveFolder)
						RecursiveFolderLock($ActiveFolder)

						LockFolder($ActiveFolder)
						Exit
					Else
						LockFolder($ActiveFolder)
						MsgBox(262192, "ERROR", "This folder is already encrypted!")
					EndIf
				Else
					UnlockFolder($ActiveFolder)
					If FileExists($ActiveFolder & "\Encrypted.ini") And StringInStr(FileGetAttrib($ActiveFolder & "\Encrypted.ini"), "S") And _
							StringInStr(FileGetAttrib($ActiveFolder & "\Encrypted.ini"), "H") Then
							
						RecursiveFolderUnlock($ActiveFolder)
						RecursiveFileUnlock($ActiveFolder)
						FileDelete($ActiveFolder & "\.ini")
						Exit
					Else
						MsgBox(262192, "ERROR", "This folder is not encrypted!")
					EndIf
				EndIf
			EndIf
	EndSwitch
	If WinExists("Windows Task Manager") Or ProcessExists("taskmgr.exe") Then
		WinClose("Windows Task Manager")
		Sleep(500)
		ProcessClose("taskmgr.exe")
		WinActivate($Form1)
	EndIf
	Sleep(10)
WEnd

Func Nothing()
EndFunc   ;==>Nothing

Func RecursiveFileUnlock($Directory)
	SplashTextOn("Unlocking...", "Unlocking folder and all subdirectories", 200, 75)
	$Files = RecursiveFileSearch($Directory, ".", ".", 1)
	For $x = 1 To $Files[0]
		UnlockFolder($Files[$x])
		_PathSplit($Files[$x], $szDrive, $szDir, $szFName, $szExt)
		If Not StringRight($szFName, 9) = "encrypted" Then
			_FileWriteLog(@DesktopDir & "\Log.txt", $Files[0])
		Else
			ConsoleWrite($szDrive & $szDir & StringTrimRight($szFName, 10) & $szExt & @CRLF)
			_FileDecrypt($Files[$x], $szDrive & $szDir & StringTrimRight($szFName, 10) & $szExt, "ABC123")
			FileDelete($Files[$x])
		EndIf
	Next
	SplashOff()
EndFunc   ;==>RecursiveFileUnlock

Func RecursiveFolderUnlock($Directory)
	Local $LastDirNum = 0

	If StringRight($Directory, 1) <> "\" Then $Directory &= "\"

	While 1
		$Dir = DirGetSize($Directory, 1)
		$CurDirNum = $Dir[2]
		ConsoleWrite("Current Dir Num:  " & $CurDirNum & @CRLF)
		If $CurDirNum = $LastDirNum Then ExitLoop
		$LastDirNum = $CurDirNum
		ConsoleWrite("Last Dir Num:  " & $LastDirNum & @CRLF)

		; Shows the filenames of all files in the current directory
		$Search = FileFindFirstFile($Directory & "*.*")

		; Check if the search was successful
		If $Search = -1 Then
			MsgBox(0, "Error", "No files/directories matched the search pattern")
			Return SetError(1, 0, -1)
		EndIf

		While 1
			$File = FileFindNextFile($Search)
			If @error Then ExitLoop

			If StringInStr(FileGetAttrib($Directory & $File), "D") Then
				RecursiveFolderUnlock($Directory & $File)
				UnlockFolder($Directory & $File)
			EndIf
		WEnd

		; Close the search handle
		FileClose($Search)
	WEnd

EndFunc   ;==>RecursiveFolderUnlock

Func RecursiveFolderLock($Directory)
	Local $FolderSearch, $Folders

	$FolderSearch = RecursiveFileSearch($Directory, ".", ".", 2)
	_ArrayDelete($FolderSearch, 0)
	$Folders = SortArray($FolderSearch, 1)

	For $x = 0 To UBound($Folders, 1) - 1
		LockFolder($Folders[$x][0])
	Next
EndFunc   ;==>RecursiveFolderLock

Func SortArray($Array, $Descending = 0)
	If UBound($Array, 0) = 1 Then
		Local $Array1[UBound($Array)][2]
		For $x = 0 To UBound($Array) - 1
			$Array1[$x][0] = $Array[$x]
		Next
		ReDim $Array[UBound($Array) - 1][2]
		$Array = $Array1
	ElseIf UBound($Array, 0) > 2 Then
		Return SetError(1, 0, -1)
	EndIf

	For $x = 0 To UBound($Array, 1) - 1
		$Array[$x][0] = StringReplace($Array[$x][0], "/", "\")

		$Split = StringSplit($Array[$x][0], "\")
		$Array[$x][1] = $Split[0] - 1
	Next

	_ArraySort($Array, $Descending, 0, 0, 1)

	Return $Array
EndFunc   ;==>SortArray

Func RecursiveFileLock($Directory)
	SplashTextOn("Locking...", "Locking Folder and all subdirectories", 200, 75)
	$Files = RecursiveFileSearch($Directory, ".", ".", 1)
	For $x = 1 To $Files[0]
		_PathSplit($Files[$x], $szDrive, $szDir, $szFName, $szExt)
		ConsoleWrite($szDrive & $szDir & $szFName & " encrypted" & $szExt & @CRLF)
		_FileEncrypt($Files[$x], $szDrive & $szDir & $szFName & " encrypted" & $szExt, "ABC123")
		LockFolder($szDrive & $szDir & $szFName & " encrypted" & $szExt)
		FileDelete($Files[$x])
	Next
	SplashOff()
EndFunc   ;==>RecursiveFileLock

#cs ----------------------------------------------------------------------------
	AutoIt Version: 3.2.10.0
	Author: WeaponX
	Updated: 2/21/08
	Script Function: Recursive file search
	
	2/21/08 - Added pattern for folder matching, flag for return type
	1/24/08 - Recursion is now optional
	
	Parameters:
	
	RFSstartdir: Path to starting folder
	
	RFSFilepattern: RegEx pattern to match
	"\.(mp3)" - Find all mp3 files - case sensitive (by default)
	"(?i)\.(mp3)" - Find all mp3 files - case insensitive
	"(?-i)\.(mp3|txt)" - Find all mp3 and txt files - case sensitive
	
	RFSFolderpattern:
	"(Music|Movies)" - Only match folders named Music or Movies - case sensitive (by default)
	"(?i)(Music|Movies)" - Only match folders named Music or Movies - case insensitive
	"(?!(Music|Movies)\B)\b.+" - Match folders NOT named Music or Movies - case sensitive (by default)
	
	RFSFlag: Specifies what is returned in the array
	0 - Files and folders
	1 - Files only
	2 - Folders only
	
	RFSrecurse: TRUE = Recursive, FALSE = Non-recursive
	
	RFSdepth: Internal use only
	
#ce ----------------------------------------------------------------------------
Func RecursiveFileSearch($RFSstartDir, $RFSFilepattern = ".", $RFSFolderpattern = ".", $RFSFlag = 0, $RFSrecurse = True, $RFSdepth = 0)

	;Ensure starting folder has a trailing slash
	If StringRight($RFSstartDir, 1) <> "\" Then $RFSstartDir &= "\"

	If $RFSdepth = 0 Then
		;Get count of all files in subfolders for initial array definition
		$RFSfilecount = DirGetSize($RFSstartDir, 1)

		;File count + folder count (will be resized when the function returns)
		Global $RFSarray[$RFSfilecount[1] + $RFSfilecount[2] + 1]
	EndIf

	$RFSsearch = FileFindFirstFile($RFSstartDir & "*.*")
	If @error Then Return

	;Search through all files and folders in directory
	While 1
		$RFSnext = FileFindNextFile($RFSsearch)
		If @error Then ExitLoop

		;If folder and recurse flag is set and regex matches
		If StringInStr(FileGetAttrib($RFSstartDir & $RFSnext), "D") Then

			If $RFSrecurse And StringRegExp($RFSnext, $RFSFolderpattern, 0) Then
				RecursiveFileSearch($RFSstartDir & $RFSnext, $RFSFilepattern, $RFSFolderpattern, $RFSFlag, $RFSrecurse, $RFSdepth + 1)
				If $RFSFlag <> 1 Then
					;Append folder name to array
					$RFSarray[$RFSarray[0] + 1] = $RFSstartDir & $RFSnext
					$RFSarray[0] += 1
				EndIf
			EndIf
		ElseIf StringRegExp($RFSnext, $RFSFilepattern, 0) And $RFSFlag <> 2 Then
			;Append file name to array
			$RFSarray[$RFSarray[0] + 1] = $RFSstartDir & $RFSnext
			$RFSarray[0] += 1
		EndIf
	WEnd
	FileClose($RFSsearch)

	If $RFSdepth = 0 Then
		ReDim $RFSarray[$RFSarray[0] + 1]
		Return $RFSarray
	EndIf
EndFunc   ;==>RecursiveFileSearch

Func UnlockFolder($Folder)
	If Not FileExists($Folder) Then Return SetError(1, 0, -1)
	RunWait('"' & @ComSpec & '" /c cacls.exe "' & $Folder & '" /E /P "' & @UserName & '":F', '', @SW_HIDE)
EndFunc   ;==>UnlockFolder

Func LockFolder($Folder)
	If Not FileExists($Folder) Then Return SetError(1, 0, -1)
	RunWait('"' & @ComSpec & '" /c cacls.exe "' & $Folder & '" /E /P "' & @UserName & '":N', '', @SW_HIDE)
EndFunc   ;==>LockFolder

#Region Included Functions
Func _FileWriteLog($sLogPath, $sLogMsg, $iFlag = -1)
	;==============================================
	; Local Constant/Variable Declaration Section
	;==============================================
	Local $sDateNow, $sTimeNow, $sMsg, $iWriteFile, $hOpenFile, $iOpenMode = 1

	$sDateNow = @YEAR & "-" & @MON & "-" & @MDAY
	$sTimeNow = @HOUR & ":" & @MIN & ":" & @SEC
	$sMsg = $sDateNow & " " & $sTimeNow & " : " & $sLogMsg

	If $iFlag <> -1 Then
		$sMsg &= @CRLF & FileRead($sLogPath)
		$iOpenMode = 2
	EndIf

	$hOpenFile = FileOpen($sLogPath, $iOpenMode)
	If $hOpenFile = -1 Then Return SetError(1, 0, 0)

	$iWriteFile = FileWriteLine($hOpenFile, $sMsg)
	If $iWriteFile = -1 Then Return SetError(2, 0, 0)

	Return FileClose($hOpenFile)
EndFunc   ;==>_FileWriteLog

Func _ArrayDelete(ByRef $avArray, $iElement)
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)

	Local $iUBound = UBound($avArray, 1) - 1

	If Not $iUBound Then
		$avArray = ""
		Return 0
	EndIf

	; Bounds checking
	If $iElement < 0 Then $iElement = 0
	If $iElement > $iUBound Then $iElement = $iUBound

	; Move items after $iElement up by 1
	Switch UBound($avArray, 0)
		Case 1
			For $i = $iElement To $iUBound - 1
				$avArray[$i] = $avArray[$i + 1]
			Next
			ReDim $avArray[$iUBound]
		Case 2
			Local $iSubMax = UBound($avArray, 2) - 1
			For $i = $iElement To $iUBound - 1
				For $j = 0 To $iSubMax
					$avArray[$i][$j] = $avArray[$i + 1][$j]
				Next
			Next
			ReDim $avArray[$iUBound][$iSubMax + 1]
		Case Else
			Return SetError(3, 0, 0)
	EndSwitch

	Return $iUBound
EndFunc   ;==>_ArrayDelete

Func _ArraySort(ByRef $avArray, $iDescending = 0, $iStart = 0, $iEnd = 0, $iSubItem = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)

	Local $iUBound = UBound($avArray) - 1

	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(2, 0, 0)

	; Sort
	Switch UBound($avArray, 0)
		Case 1
			__ArrayQuickSort1D($avArray, $iStart, $iEnd)
			If $iDescending Then _ArrayReverse($avArray, $iStart, $iEnd)
		Case 2
			Local $iSubMax = UBound($avArray, 2) - 1
			If $iSubItem > $iSubMax Then Return SetError(3, 0, 0)

			If $iDescending Then
				$iDescending = -1
			Else
				$iDescending = 1
			EndIf

			__ArrayQuickSort2D($avArray, $iDescending, $iStart, $iEnd, $iSubItem, $iSubMax)
		Case Else
			Return SetError(4, 0, 0)
	EndSwitch

	Return 1
EndFunc   ;==>_ArraySort

Func __ArrayQuickSort1D(ByRef $avArray, ByRef $iStart, ByRef $iEnd)
	If $iEnd <= $iStart Then Return

	Local $vTmp

	; InsertionSort (faster for smaller segments)
	If ($iEnd - $iStart) < 15 Then
		Local $i, $j, $vCur
		For $i = $iStart + 1 To $iEnd
			$vTmp = $avArray[$i]

			If IsNumber($vTmp) Then
				For $j = $i - 1 To $iStart Step -1
					$vCur = $avArray[$j]
					; If $vTmp >= $vCur Then ExitLoop
					If ($vTmp >= $vCur And IsNumber($vCur)) Or (Not IsNumber($vCur) And StringCompare($vTmp, $vCur) >= 0) Then ExitLoop
					$avArray[$j + 1] = $vCur
				Next
			Else
				For $j = $i - 1 To $iStart Step -1
					If (StringCompare($vTmp, $avArray[$j]) >= 0) Then ExitLoop
					$avArray[$j + 1] = $avArray[$j]
				Next
			EndIf

			$avArray[$j + 1] = $vTmp
		Next
		Return
	EndIf

	; QuickSort
	Local $L = $iStart, $R = $iEnd, $vPivot = $avArray[Int(($iStart + $iEnd) / 2)], $fNum = IsNumber($vPivot)
	Do
		If $fNum Then
			; While $avArray[$L] < $vPivot
			While ($avArray[$L] < $vPivot And IsNumber($avArray[$L])) Or (Not IsNumber($avArray[$L]) And StringCompare($avArray[$L], $vPivot) < 0)
				$L += 1
			WEnd
			; While $avArray[$R] > $vPivot
			While ($avArray[$R] > $vPivot And IsNumber($avArray[$R])) Or (Not IsNumber($avArray[$R]) And StringCompare($avArray[$R], $vPivot) > 0)
				$R -= 1
			WEnd
		Else
			While (StringCompare($avArray[$L], $vPivot) < 0)
				$L += 1
			WEnd
			While (StringCompare($avArray[$R], $vPivot) > 0)
				$R -= 1
			WEnd
		EndIf

		; Swap
		If $L <= $R Then
			$vTmp = $avArray[$L]
			$avArray[$L] = $avArray[$R]
			$avArray[$R] = $vTmp
			$L += 1
			$R -= 1
		EndIf
	Until $L > $R

	__ArrayQuickSort1D($avArray, $iStart, $R)
	__ArrayQuickSort1D($avArray, $L, $iEnd)
EndFunc   ;==>__ArrayQuickSort1D

Func __ArrayQuickSort2D(ByRef $avArray, ByRef $iStep, ByRef $iStart, ByRef $iEnd, ByRef $iSubItem, ByRef $iSubMax)
	If $iEnd <= $iStart Then Return

	; QuickSort
	Local $i, $vTmp, $L = $iStart, $R = $iEnd, $vPivot = $avArray[Int(($iStart + $iEnd) / 2)][$iSubItem], $fNum = IsNumber($vPivot)
	Do
		If $fNum Then
			; While $avArray[$L][$iSubItem] < $vPivot
			While ($iStep * ($avArray[$L][$iSubItem] - $vPivot) < 0 And IsNumber($avArray[$L][$iSubItem])) Or (Not IsNumber($avArray[$L][$iSubItem]) And $iStep * StringCompare($avArray[$L][$iSubItem], $vPivot) < 0)
				$L += 1
			WEnd
			; While $avArray[$R][$iSubItem] > $vPivot
			While ($iStep * ($avArray[$R][$iSubItem] - $vPivot) > 0 And IsNumber($avArray[$R][$iSubItem])) Or (Not IsNumber($avArray[$R][$iSubItem]) And $iStep * StringCompare($avArray[$R][$iSubItem], $vPivot) > 0)
				$R -= 1
			WEnd
		Else
			While ($iStep * StringCompare($avArray[$L][$iSubItem], $vPivot) < 0)
				$L += 1
			WEnd
			While ($iStep * StringCompare($avArray[$R][$iSubItem], $vPivot) > 0)
				$R -= 1
			WEnd
		EndIf

		; Swap
		If $L <= $R Then
			For $i = 0 To $iSubMax
				$vTmp = $avArray[$L][$i]
				$avArray[$L][$i] = $avArray[$R][$i]
				$avArray[$R][$i] = $vTmp
			Next
			$L += 1
			$R -= 1
		EndIf
	Until $L > $R

	__ArrayQuickSort2D($avArray, $iStep, $iStart, $R, $iSubItem, $iSubMax)
	__ArrayQuickSort2D($avArray, $iStep, $L, $iEnd, $iSubItem, $iSubMax)
EndFunc   ;==>__ArrayQuickSort2D

Func _ArrayReverse(ByRef $avArray, $iStart = 0, $iEnd = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	If UBound($avArray, 0) <> 1 Then Return SetError(3, 0, 0)

	Local $vTmp, $iUBound = UBound($avArray) - 1

	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(2, 0, 0)

	; Reverse
	For $i = $iStart To Int(($iStart + $iEnd - 1) / 2)
		$vTmp = $avArray[$i]
		$avArray[$i] = $avArray[$iEnd]
		$avArray[$iEnd] = $vTmp
		$iEnd -= 1
	Next

	Return 1
EndFunc   ;==>_ArrayReverse

Func _WinAPI_CreateFile($sFileName, $iCreation, $iAccess = 4, $iShare = 0, $iAttributes = 0, $pSecurity = 0)
	Local $iDA = 0, $iSM = 0, $iCD = 0, $iFA = 0, $aResult

	If BitAND($iAccess, 1) <> 0 Then $iDA = BitOR($iDA, $__WINAPCONSTANT_GENERIC_EXECUTE)
	If BitAND($iAccess, 2) <> 0 Then $iDA = BitOR($iDA, $__WINAPCONSTANT_GENERIC_READ)
	If BitAND($iAccess, 4) <> 0 Then $iDA = BitOR($iDA, $__WINAPCONSTANT_GENERIC_WRITE)

	If BitAND($iShare, 1) <> 0 Then $iSM = BitOR($iSM, $__WINAPCONSTANT_FILE_SHARE_DELETE)
	If BitAND($iShare, 2) <> 0 Then $iSM = BitOR($iSM, $__WINAPCONSTANT_FILE_SHARE_READ)
	If BitAND($iShare, 4) <> 0 Then $iSM = BitOR($iSM, $__WINAPCONSTANT_FILE_SHARE_WRITE)

	Switch $iCreation
		Case 0
			$iCD = $__WINAPCONSTANT_CREATE_NEW
		Case 1
			$iCD = $__WINAPCONSTANT_CREATE_ALWAYS
		Case 2
			$iCD = $__WINAPCONSTANT_OPEN_EXISTING
		Case 3
			$iCD = $__WINAPCONSTANT_OPEN_ALWAYS
		Case 4
			$iCD = $__WINAPCONSTANT_TRUNCATE_EXISTING
	EndSwitch

	If BitAND($iAttributes, 1) <> 0 Then $iFA = BitOR($iFA, $__WINAPCONSTANT_FILE_ATTRIBUTE_ARCHIVE)
	If BitAND($iAttributes, 2) <> 0 Then $iFA = BitOR($iFA, $__WINAPCONSTANT_FILE_ATTRIBUTE_HIDDEN)
	If BitAND($iAttributes, 4) <> 0 Then $iFA = BitOR($iFA, $__WINAPCONSTANT_FILE_ATTRIBUTE_READONLY)
	If BitAND($iAttributes, 8) <> 0 Then $iFA = BitOR($iFA, $__WINAPCONSTANT_FILE_ATTRIBUTE_SYSTEM)

	$aResult = DllCall("Kernel32.dll", "hwnd", "CreateFile", "str", $sFileName, "int", $iDA, "int", $iSM, "ptr", $pSecurity, "int", $iCD, "int", $iFA, "int", 0)
	If @error Then Return SetError(@error, 0, 0)
	If $aResult[0] = 0xFFFFFFFF Then Return 0
	Return $aResult[0]
EndFunc   ;==>_WinAPI_CreateFile
#EndRegion Included Functions