#include <GUIConstants.au3>
#include <array.au3>
#include <file.au3>
#include <winapi.au3>

Opt("GUIOnEventMode", 1)

Dim $arraydat[1][5]
Global $folder, $dir
$i = 75
$help = ""
$fname = "Form1"
$Form1 = GUICreate($fname, 633, 447, 193, 125)
$Button1 = GUICtrlCreateButton("Start", 512, 400, 113, 41, 0)
$Obj1 = ObjCreate("CompatUI.SelectFile.1")
$Obj1_ctrl = GUICtrlCreateObj(obj($Obj1), 56, 56, 486, 93)
GUISetState(@SW_SHOW)
GUISetOnEvent(-3, "exitgui")
GUICtrlSetOnEvent($Button1, "Startp")
$is = -1
While 1
	$is += 1
	While 1
	$gettext = $Obj1.FileName()
	If $gettext <> $help Then
		$i += 11
		$arraydat[$is][0] = $gettext ;path C:\a\a.vad
		GUICtrlCreateLabel($gettext, 56, $i)
		$Obj1.FileName = ""
		If FileExists(Getun($gettext, ".") & ".srt") Then 
		GUICtrlSetColor(-1, 0x0000FF)
		$arraydat[$is][2]= "1" ;1 or n
	Else
	EndIf
	$Obj1.BrowseInitialDirectory = getdir($gettext)
		ExitLoop
	Else
	EndIf
WEnd
ReDim $arraydat[$is+2][5]
WEnd
Func exitgui()
	Exit
EndFunc   ;==>exitgui

Func Getun($str, $stop)
	Local $word = ""
	For $iasdf = 1 To StringLen($str) Step 1
		$charat = StringMid($str, $iasdf, 1)
		If $charat = $stop Then ExitLoop
		$word &= $charat
	Next
	Return $word
EndFunc   ;==>Getun
Func obj($var)
	with $var
		.BrowseTitle = "Διάλεξε αρχεία"
		.BrowseInitialDirectory = "E:\ADownloads"
		.BrowseFilter = "Allfiles (*.*)"
	EndWith
	Return $var
EndFunc

Func Startp()
	$folder = FileSelectFolder("Choose folder", "")
	$rows = UBound($arraydat)
	for $sc = 0 to $rows-1 step 1
	$thename = Getname($arraydat[$sc][0])
	$arraydat[$sc][1]= $thename ;movie.avi
	$strrep = StringReplace($arraydat[$sc][0], "avi", "srt")
	$arraydat[$sc][3] = $strrep ;path with sub
	$rereplace = StringReplace($thename, "avi", "srt")
	$arraydat[$sc][4]= $rereplace ;sub name
	next
	For $1i = 0 To UBound($arraydat) - 1 Step 1
	$num = $arraydat[$1i][2]
	If $num = 0 Then
		_FileCopy($arraydat[$1i][0], $folder & "\")
	Else
		_FileCreate($folder & "\" & $arraydat[$1i][4])
		$fo = FileOpen($arraydat[$1i][3], 0)
		$fr = FileRead($fo)
		$unic = DllStructGetData(_WinAPI_MultiByteToWideChar($fr), 1)
		$fw = FileOpen($folder & "\" & $arraydat[$1i][4], 2)
		FileWrite($fw, $unic)
		_FileCopy($arraydat[$1i][0], $folder & "\")
	EndIf
Next
EndFunc

Func _FileCopy($fromFile, $tofile)
	Local $FOF_RESPOND_YES = 16
	Local $FOF_SIMPLEPROGRESS = 256
	$winShell = ObjCreate("shell.application")
	$winShell.namespace($tofile).CopyHere($fromFile, $FOF_RESPOND_YES)
EndFunc   ;==>_FileCopy

Func Getname($patht)
	$splitter = StringSplit($patht, "\")
	$countf = UBound($splitter)
	Return $splitter[$countf-1]
EndFunc

Func getdir($dpath)
$ns = _stringchangeorder($dpath)
$namesd = Getun($ns, "\")
Return StringReplace($dpath, _stringchangeorder($namesd), "")
EndFunc

Func _stringchangeorder($ithecstring)
	Local $ithestringlenforde, $inrewstringcont
	
	$ithestringlenforde = StringLen($ithecstring)
	for $theiloop = $ithestringlenforde to 1 step -1
		$itakechar = StringMid($ithecstring, $theiloop, 1)
		$inrewstringcont = $inrewstringcont & $itakechar
	Next
	Return $inrewstringcont
EndFunc