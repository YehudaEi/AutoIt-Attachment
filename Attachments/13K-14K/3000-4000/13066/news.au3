#include <Array.au3>

;Settings
Global $downdir = "E:\Dokumenter\NFG Downloads\"
Global $minfree = 2048 ;Megabyte
Global $dirlist
Global $winrar = "C:\Programmer\Winrar\winrar.exe"
Global $quickpar = "C:\Programmer\QuickPar\QuickPar.exe"
Global $hksfv = "C:\Programmer\hkSFV\hkSFV.exe"


Func UpdateNewslog()
	If FileExists($downdir & "News.log") Then
		FileDelete($downdir & "News.log")
	EndIf
	RunWait(@COMSPEC & " /c dir /A:D /B /O:D """ & $downdir & """ >> News.log", $downdir)
EndFunc

Func InitKey($section)
	IniWrite($downdir & "News.ini", $section, "Status","New")
	IniWrite($downdir & "News.ini", $section, "Par","None")
	IniWrite($downdir & "News.ini", $section, "Sfv","None")
	IniWrite($downdir & "News.ini", $section, "Rar", "None")
	IniWrite($downdir & "News.ini", $section, "Unpacked","None")
EndFunc

Func UpdateIni()
	Local $loglist = _ArrayCreate("Liste")
	UpdateNewslog()
	$ini = 1
	$log = 0
	
	$dirlist = IniReadSectionNames($downdir & "News.ini")
	If @error Then
		$ini = 0
	EndIf
	
	$file = FileOpen($downdir & "News.log", 0)
	While 1
		$line = FileReadLine($file)
		If @error = -1 Then
			ExitLoop
		EndIf
		$log = 1
		_ArrayAdd($loglist, $line)		
	Wend
	FileClose($file)
	
	If $log = 0 Then
		If $ini = 1 Then FileDelete($downdir & "News.ini")
		FileDelete($downdir & "News.log")
		MsgBox(0, "Ingen mapper", "Der kunne ikke findes nogle mapper i downloadmappen")
		Exit
	EndIf
	
	_ArrayDelete($loglist, 0)
	
	If $ini = 1 Then
		For $section In $dirlist
			$pos = _ArraySearch($loglist, $section)
			If $pos = -1 Then
				IniDelete($downdir & "News.ini", $section)
			EndIf
		Next
	EndIf
	
	For $section In $loglist
		$status = IniRead ($downdir & "News.ini", $section, "Status", "None")
		If $status = "None" Then
			InitKey($section)
		EndIf
	Next
	
EndFunc

Func ParCheck($section)
	IniWrite($downdir & "News.ini", $section, "Par", "Started")
	Local $temprep
	$search = FileFindFirstFile($downdir & $section & "\*.par2")
	If $search = -1 Then
		IniWrite($downdir & "News.ini", $section, "Par", "NoPar")
		Return "NoPar"
	EndIf
	$parfil = FileFindNextFile($search) 
	FileClose($search)
	Run("""" & $quickpar & """ """ & $downdir & $section & "\" & $parfil & """")
	$staus = "Started"
	WinWait("QuickPar")
	While WinExists("QuickPar")
		If WinExists("QuickPar - Alle data verificeret") Then
			$status = "Succes"
			ExitLoop
		EndIf
		If WinExists("QuickPar - Reparation lykkedes") Then
			$status = "Succes"
			ExitLoop
		EndIf
		If WinExists("QuickPar - Mangler") Then
			If $status = "Failed" Then
				If $temprep = WinGetTitle("Quickpar") Then
					ExitLoop
				EndIf
			EndIf
			$status = "Failed"
			$temprep = WinGetTitle("Quickpar")
		EndIf
		Sleep(1000)
	WEnd
	WinClose("QuickPar")
	IniWrite($downdir & "News.ini", $section, "Par", $status)
	IniWrite($downdir & "News.ini", $section, "Status", $status)
	Return $status	
EndFunc

Func SfvCheck($section)
	IniWrite($downdir & "News.ini", $section, "Sfv", "Started")
	$search = FileFindFirstFile($downdir & $section & "\*.sfv")
	If $search = -1 Then
		IniWrite($downdir & "News.ini", $section, "Sfv", "NoSfv")
		Return "NoSfv"
	EndIf
	$sfvfil = FileFindNextFile($search) 
	FileClose($search)
	Run("""" & $hksfv & """ """ & $downdir & $section & "\" & $sfvfil & """")
	WinWait("hkSFV")
	While WinExists("hkSFV")
		Sleep(1000)
		$bad = StatusbarGetText("hkSFV", "", 4)
		$missing = StatusbarGetText("hkSFV", "", 5)
		If Not($bad = "Bad: 0") or Not($missing = "Miss: 0") Then
			WinClose("hkSFV")
			IniWrite($downdir & "News.ini", $section, "Sfv", "Failed")
			IniWrite($downdir & "News.ini", $section, "Status", "Failed")
			Return "Failed"
		EndIf
	WEnd
	IniWrite($downdir & "News.ini", $section, "Sfv", "Succes")
	IniWrite($downdir & "News.ini", $section, "Status", "Checked")
	Return "Succes"
EndFunc

Func RarCheck($section)
	IniWrite($downdir & "News.ini", $section, "Rar", "Started")
	$code = RunWait($winrar & " t -y """ & $downdir & $section & "\*.*" & """")
	If $code = 0 Then
		IniWrite($downdir & "News.ini", $section, "Status", "Checked")
		$status = "Succes"
	Else
		IniWrite($downdir & "News.ini", $section, "Status", "Failed")
		$status = "Failed"
	EndIf
	IniWrite($downdir & "News.ini", $section, "Rar", $status)
	Return $status	
EndFunc

Func Unpack($section)
	IniWrite($downdir & "News.ini", $section, "Unpacked", "Started")
	$size = DirGetSize($downdir & $section & "\", 2)
	$size = Round(($size / 1024 / 1024) + $minfree)
	$space = DriveSpaceFree ($downdir)
	$space = Round($space, 0)
	If $size > $space Then
		IniWrite($downdir & "News.ini", $section, "Unpacked", "NoSpace")
		IniWrite($downdir & "News.ini", $section, "Status", "Failed")
		Return "Failed"
	EndIf
	$code = RunWait($winrar & " x -y -o+ """ & $downdir & $section & "\*"" """ & $downdir & $section & "\Unpacked\""")
	If ($code = 0) Then
		$status = "Succes"
	Else
		$status = "Failed"
	EndIf
	IniWrite($downdir & "News.ini", $section, "Unpacked", $status)
	IniWrite($downdir & "News.ini", $section, "Status", $status)
	Return $status
EndFunc



UpdateIni()
$dirlist = IniReadSectionNames($downdir & "News.ini")
$i = 0
While 1
	$status = IniRead($downdir & "News.ini", $dirlist[$i], "Status", "None")
	
	If $status = "Succes" Then

	EndIf
	
	If $status = "Failed" Then

	EndIf
	
	If $status = "New" Then
		$result = ParCheck($dirlist[$i])
		If $result = "NoPar" Then $result = SfvCheck($dirlist[$i])
		If (($result = "NoSfv") or ($result = "NoPar")) Then $result = RarCheck($dirlist[$i])
		If $result = "Succes" Then $result = Unpack($dirlist[$i])
	EndIf
	
	If $status = "Checked" Then
		$result = Unpack($dirlist[$i])
		
	EndIf
	
	_ArrayDelete($dirlist, $i)
	If @error = 2 Then ExitLoop
	
WEnd


