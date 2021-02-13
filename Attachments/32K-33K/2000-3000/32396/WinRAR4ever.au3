#AutoIt3Wrapper_UseX64=Y
#AutoIt3Wrapper_Icon=e:\#Scriptek\--=Saj�t=--\WinRAR4ever\wrar.ico
#AutoIt3Wrapper_Compression=2
#AutoIt3Wrapper_Res_Description=Csoportos kit�m�r�t� alkalmaz�s
#AutoIt3Wrapper_Res_Fileversion=2.1.2
#AutoIt3Wrapper_Res_ProductVersion=2.1.2
#AutoIt3Wrapper_Res_Language=1038

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#Include <GuiListView.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ProgressConstants.au3>
#Include <Date.au3>
#include <ComboConstants.au3>
#Include <Constants.au3>
#Include <Array.au3>
#Include <File.au3>
#NoTrayIcon

Global $rar[500], $list[500], $date[500], $meret[500], $forras[6], $celok[6], $kivetelek[10]
Global $a=0, $max=499 ;H�ny mapp�t tal�lt
Global $source, $source_size, $destination, $egyedi
Global $Progress2, $Progress1
Global $lista ;H�ny kiv�lasztott mappa van
Global $exit ;Eredm�nyes-e a keres�s 0 ok
;Global $searchnfo, $search, $keres1, $keres2, $testreszab
Global $sStartDate, $icon, $settico
Global $iniver="1.9", $ver="2.1.3", $ini=@ScriptDir & "\WinRAR4ever.ini", $SoundEnd
Global $log=@ScriptDir & "\WinRAR4ever.log"
Global $torol, $Run, $pbar_slice, $done, $search, $searchsample, $searchnfo, $searchfilm
If $search<>"" Then FileClose($search)
;iniben
Global $ftype1, $ftype2, $filetype[10], $filmtype[20], $winrar, $forr, $forr2, $forr3, $cel, $same_dest, $hang, $nfo_masol, $kilepes, $quickscan, $datum, $sample, $film, $naplo, $kivetel_list, $kivetel

$settico = @TempDir & "\wrar_sett.ico"
FileInstall ("sett.ico", $settico, 1)
$icon = @TempDir & "\wrar.ico"
FileInstall ("wrar.ico", $icon, 1)

TraySetIcon($icon)

Opt("GUICloseOnESC", 0)
Opt("TrayIconHide", 1)
;Opt("TrayIconDebug",1)

$egyedi=0 ;Nem volt testreszab�s

$space=2000 ;Min szabad hely MB

;If FileExists($log) Then FileDelete($log)

IniOlvas()

#Region ### START Koda GUI section ### Form=e:\#scriptek\koda\forms\winrar4ever.kxf
$Winrar_1 = GUICreate("WinRAR4ever " & $ver, 580, 360, -1, -1, -1, $WS_EX_ACCEPTFILES)
GUISetIcon($icon)
;men�
$MenuFile = GUICtrlCreateMenu("&F�jl")
$MenuBeall = GUICtrlCreateMenuItem("&Be�ll�ts�ok" & @TAB & "Ctrl+B", $MenuFile)
GUICtrlCreateMenuItem("", $MenuFile)
$MenuKilep = GUICtrlCreateMenuItem("&Kil�p" & @TAB & "Alt+F4", $MenuFile)
$MenuAbout = GUICtrlCreateMenu("?")
$MenuNevjegy = GUICtrlCreateMenuItem("&N�vjegy" & @TAB & "Ctrl+N", $MenuAbout)

$Groupm1 = GUICtrlCreateGroup("Honnan", 8, 24, 271, 121)
$gui=$forras[1]
For $i=2 To $forras[0]
	$gui=$gui & "|" & $forras[$i]
Next
$src_gui = GUICtrlCreateCombo("", 15, 56, 230, 25)
GUICtrlSetData($src_gui, $gui, $forras[1])
$keres1 = GUICtrlCreateButton("...", 250, 56, 20, 20)
$testreszab = GUICtrlCreateButton("&Testreszab", 42, 98, 89, 33)
GUICtrlSetTip(-1, "Almapp�k kiv�laszt�sa")
GUICtrlSetFont(-1, 10, 600, 0, "Arial")
$gyors = GUICtrlCreateCheckbox("Gy&ors elemz�s", 160, 103, 100, 20)
GUICtrlSetTip(-1, "Nem olvassa be a mappa m�ret�t")
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Groupm2 = GUICtrlCreateGroup("Hova", 296, 24, 270, 121)
$gui=$celok[1]
For $i=2 To $celok[0]
	$gui=$gui & "|" & $celok[$i]
Next
$dest_gui = GUICtrlCreateCombo("", 305, 56, 230, 25)
GUICtrlSetData(-1, $gui, $celok[1])
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
$azonos_gui = GUICtrlCreateCheckbox("Mindent &egyhelyre", 360, 101, 113, 20)
GUICtrlSetTip(-1, "Nem k�sz�t minden arch�vumhoz k�l�n mapp�t")
GUICtrlCreateGroup("", -99, -99, 1, 1)

$keres2 = GUICtrlCreateButton("...", 540, 56, 20, 20)
$Label5 = GUICtrlCreateLabel("", 66, 214, 460, 20, $SS_CENTER)
;$Progress1 = GUICtrlCreateProgress(66, 160, 460, 33) ;overall progress
;$Progress2 = GUICtrlCreateProgress(66, 254, 460, 17, $PBS_SMOOTH)
$btn = GUICtrlCreateButton("&Gyer�nk!", 229, 284, 121, 41)
GUICtrlSetFont(-1, 14, 600, 0, "Times New Roman")
GUICtrlSetState(-1, $GUI_DEFBUTTON)
$Label4 = GUICtrlCreateLabel("Brudi edition", 509, 316, 62, 17)

Dim $Winrar_1_AccelTable[2][2] = [["^b", $MenuBeall],["^n", $MenuNevjegy]]
GUISetAccelerators($Winrar_1_AccelTable)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

GUICtrlSetState ( $azonos_gui, $same_dest )
GUICtrlSetState ( $gyors, $quickscan )

;Winrar ellen�rz�se
If Not FileExists (StringReplace($winrar, '"', '')) Then
	;SoundPlay($SoundError, 0)
	MsgBox(16, "Hiba a M�trixban!", "A WinRAR nem tal�lhat�!" & @CRLF & "(" & $winrar & ")" & @CRLF & "M�dos�tsd a be�ll�t�sokban!", 0, $Winrar_1)
	Beallitas()
EndIf


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $keres1
			$old=$forr
			$message = "Forr�smappa"
			$forr  = GUICtrlRead($src_gui)
			$forr = FileSelectFolder($message, "", 6 ,$forr, $Winrar_1 )
			If $forr<>"" Then
				GUICtrlSetData($src_gui, $forr, $forr)
				_ArrayInsert($forras, 1, $forr)
				$forras[0]=$forras[0]+1
				If $forras[0]>5 Then
					_ArrayDelete($forras, 5)
					$forras[0]=$forras[0]-1
				EndIf
			EndIf
		Case $keres2
			$message = "C�lmappa"
			$cel  = GUICtrlRead($dest_gui)
			$cel = FileSelectFolder($message, "", 3 ,$cel, $Winrar_1 )
			If $cel<>"" Then
				GUICtrlSetData( $dest_gui, $cel, $cel )
				_ArrayInsert($celok, 1, $cel)
				$celok[0]=$celok[0]+1
				If $celok[0]>5 Then
					_ArrayDelete($celok, 5)
					$celok[0]=$celok[0]-1
				EndIf
			EndIf
		Case $testreszab
			$source=GUICtrlRead($src_gui)
			$egyedi=1
			Testreszab()
		Case $GUI_EVENT_CLOSE
			Exitel()
		Case $MenuKilep
			Exitel()
		Case $MenuBeall
			Beallitas()
		Case $MenuNevjegy
			Nevjegy()
		Case $btn
			winrar4ever()
			GUI_be()
			If $kilepes=$GUI_CHECKED Then
				sleep(500)
				Exitel()
			EndIf
	EndSwitch
	
WEnd




Func winrar4ever()

;ha forr�s �j, akkor menti a t�mbbe
$forr  = GUICtrlRead($src_gui)
If $forr<>$forras[1] Then
	GUICtrlSetData($src_gui, $forr, $forr)
	_ArrayInsert($forras, 1, $forr)
	$forras[0]=$forras[0]+1
	If $forras[0]>5 Then
		_ArrayDelete($forras, 5)
		$forras[0]=$forras[0]-1
	EndIf
EndIf

;ha c�l �j, akkor menti a t�mbbe
$cel  = GUICtrlRead($dest_gui)
If $cel<>$celok[1] Then
	GUICtrlSetData( $dest_gui, $cel, $cel )
	_ArrayInsert($celok, 1, $cel)
	$celok[0]=$celok[0]+1
	If $celok[0]>5 Then
		_ArrayDelete($celok, 5)
		$celok[0]=$celok[0]-1
	EndIf
EndIf

$exit=0
$search=-1

;kezd�s ideje
$sStartDate=_NowCalc()

;gombok tilt�sa
GUI_ki()

Opt("GUIOnEventMode", 1)
ControlSetText ($Winrar_1, "", $btn, "�llj")
GUICtrlSetOnEvent($btn, "kilep")
ControlEnable($Winrar_1, "", $btn)

$source = GUICtrlRead($src_gui)
$destination  = GUICtrlRead($dest_gui)
$same_dest = GUICtrlRead($azonos_gui)
$quickscan = GUICtrlRead($gyors)

;Mapp�k ment�s ini-be
$save=$forras[1]
For $i=2 To $forras[0]
	$save=$save & ";" & $forras[$i]
Next
IniWrite($ini, "Path", "Source", $save)

$save=$celok[1]
For $i=2 To $celok[0]
	$save=$save & ";" & $celok[$i]
Next
IniWrite($ini, "Path", "Destination", $save)

IniWrite($ini, "Settings", "Destination_Same", $same_dest)
IniWrite($ini, "Settings", "QuickScan", $quickscan)

If $destination="" Then
	ControlSetText ($Winrar_1, "", $Label5, "Nincs c�l kiv�lasztva!")
	$exit=1
EndIf

;keres�s ha nem volt testreszab�s
If $egyedi=0 Then
	Listaz()
	$lista=$a+1
EndIf


$Progress1 = GUICtrlCreateProgress(66, 160, 460, 33)
$Progress2 = GUICtrlCreateProgress(66, 254, 460, 17, $PBS_SMOOTH)

;kev�s a hely
$destdrive=StringSplit($destination, ":")
$destination_space=Round(DriveSpaceFree($destdrive & ":"), 1)

If $destination_space<$space And $destination_space>1 Then
	;SoundPlay($SoundError, 0)
	$quest=MsgBox(20, "Nincs el�g hely!?!", "A meghajt�n kevesebb, mint " & $space & " MiB szabad hely van!" & @CRLF & "Elkezded a kit�m�r�t�st?", 0, $Winrar_1)
	If $naplo=1 Then FileWriteLine($log, _Now() & "-" & "A lemezen kev�cs a szabad hely! " & $destination_space & " MiB")
	If $quest=7 Then $exit=1 ;Ha nem, akkor v�ge
EndIf

;Van-e el�g szabad hely
If $quickscan=$GUI_UNCHECKED Then
	$source_size=Meret()

	If $naplo=1 Then FileWriteLine($log, _Now() & "-" & "A kijel�lt mapp�k m�rete " & $source_size & " MiB, a szabad hely pedig " & $destination_space & " MiB.")

	;Nagyobb a forr�s, mint a szabad hely
	If $source_size>=$destination_space And $source_size>10 Then
		;SoundPlay($SoundError, 0)
		$quest=MsgBox(20, "Nincs el�g hely!?!", "A kijel�lt mapp�k m�rete " & $source_size & " MiB, szabad hely " & $destination_space & " MiB." & @CRLF & "Nincs el�g szabad hely a lemezen. Elkezded a kit�m�r�t�st?", 0, $Winrar_1)
		If $quest=7 Then $exit=1 ;Ha nem, akkor nem t�m�r�t
	EndIf
EndIf

;C�mappa l�trehoz�sa ha kell
If Not FileExists($destination) And $exit=0 Then DirCreate($destination)

;kit�m�r�t�s
$done=0
$progmax=$lista;+1
$b=0
$pbar_slice=100/$progmax

While $exit=0
	;progressbar
 	GUICtrlSetData($Progress1, $done*$pbar_slice)
	WinSetTitle($Winrar_1, "", Round($done*$pbar_slice) & "% - WinRAR4ever " & $ver)
	
	;ha �res, akkor kihagyja
	While 1
		If $rar[$b]="??" Then
			$b=$b+1
		Else
			Exitloop
		EndIf
	WEnd
	
	If $b>$a Then ExitLoop
	
;aktu�lis mappa v�lt�sa
	FileChangeDir($source & "\" & $rar[$b])
	
;nfo keres�se
	If $nfo_masol=$GUI_CHECKED Then
		$searchnfo = FileFindFirstFile("*.nfo")
		If $searchnfo <> -1 Then
			$nfo = FileFindNextFile($searchnfo)
			If $naplo=1 Then FileWriteLine($log, _Now() & "-" & "NFO m�solva:" & $rar[$b] & "\" & $nfo)
			If $same_dest = $GUI_CHECKED Then
				FileCopy ($source & "\" & $rar[$b] & "\" & $nfo, $destination & "\", 8)
			Else
				FileCopy ($source & "\" & $rar[$b] & "\" & $nfo, $destination & "\" & $rar[$b] & "\", 8)
			EndIf
		EndIf
		FileClose($searchnfo)
	EndIf
	
;sample keres�se
	If $sample=$GUI_CHECKED Then
		$searchsample = FileFindFirstFile("*sample*.*")
		If $searchsample = -1 And FileExists($source & "\" & $rar[$b] & "\Sample") Then
			FileChangeDir($source & "\" & $rar[$b] & "\Sample")
			$searchsample = FileFindFirstFile("*.*")
		EndIf
			
		If $searchsample <> -1 Then	
			$samplefile = FileFindNextFile($searchsample)
			If $naplo=1 Then FileWriteLine($log, _Now() & "-" & "Sample m�solva:" & $rar[$b] & "\" & $samplefile)
			If $same_dest = $GUI_CHECKED Then
				_CopyWait($source & "\" & $rar[$b] & "\" & $samplefile, $destination & "\" & $samplefile)
			Else
				_CopyWait($source & "\" & $rar[$b] & "\" & $samplefile, $destination & "\" & $rar[$b] & "\" & $samplefile)
			EndIf
		EndIf
		FileClose($searchsample)
	EndIf

;keres�s
	FileChangeDir($source & "\" & $rar[$b])
	For $k=1 To $filetype[0]
		If $exit=1 Then ExitLoop
		$search = FileFindFirstFile($filetype[$k])
		If $search=-1 Then ContinueLoop
		;sima kit�m�r�t�s, ha van tal�lat
		$rarfile = FileFindNextFile($search)
		
		;kit�m�r�t�s
 		ControlSetText ($Winrar_1, "", $Label5, $done+1 & "/" & $lista & " " & StringFormat("%.65s", $rar[$b]))
		If $same_dest = $GUI_CHECKED Then
			If $naplo=1 Then FileWriteLine($log, _Now() & "-" & "Kit�m�rt�s:" & $rar[$b] & "\" & $rarfile & " -> " & $destination & '\"')
			If Kivetel($source & '\' & $rar[$b] & '\' & $rarfile) Then $Run=Run($winrar & ' x ' & '-ibck "' & $source & '\' & $rar[$b] & '\' & $rarfile & '" "' & $destination & '\')
			WinRARWait($Run, $source & '\' & $rar[$b])
		Else
			If $naplo=1 Then FileWriteLine($log, _Now() & "-" & "Kit�m�rt�s:" & $rar[$b] & "\" & $rarfile & " -> " & $destination & '\' & $rar[$b] & '\')
			If Kivetel($source & '\' & $rar[$b] & '\' & $rarfile) Then $Run=Run($winrar & ' x ' & '-ibck "' & $source & '\' & $rar[$b] & '\' & $rarfile & '" "' & $destination & '\' & $rar[$b] & '\"')
			WinRARWait($Run, $source & '\' & $rar[$b])
		EndIf
	Next
	FileClose($search)

;alk�nyvt�rban keres�s t�m�r�t�st
	$dirlist=_FileListToArray($source & "\" & $rar[$b], "*", 2)
	If @error=0 Then

	For $i=1 To $dirlist[0]
			FileChangeDir($source & "\" & $rar[$b] & "\" & $dirlist[$i])
			For $k=1 To $filetype[0]
				$search = FileFindFirstFile($filetype[$k])
				If $search=-1 Then ContinueLoop
				;sima kit�m�r�t�s, ha van tal�lat
				$rarfile = FileFindNextFile($search)
		
				;kit�m�r�t�s
				ControlSetText ($Winrar_1, "", $Label5, $done+1 & "/" & $lista & " " & StringFormat("%.65s", $rar[$b]))
				If $same_dest = $GUI_CHECKED Then
					If $naplo=1 Then FileWriteLine($log, _Now() & "-" & "Kit�m�rt�s:" & $rar[$b] & "\" & $rarfile & "\" & $dirlist[$i] & '\' & $rarfile & " -> " & $destination & '\')
					If Kivetel($source & '\' & $rar[$b] & "\" & $dirlist[$i] & '\' & $rarfile) Then $Run=Run($winrar & ' x ' & '-ibck "' & $source & '\' & $rar[$b] & "\" & $dirlist[$i] & '\' & $rarfile & '" "' & $destination & '\"')
					WinRARWait($Run, $source & '\' & $rar[$b] & "\" & $dirlist[$i])
				Else
					If $naplo=1 Then FileWriteLine($log, _Now() & "-" & "Kit�m�rt�s:" & $rar[$b] & "\" & $rarfile & "\" & $dirlist[$i] & '\' & $rarfile & " -> " & $destination & '\' & $rar[$b] & '\')
					If Kivetel($source & '\' & $rar[$b] & "\" & $dirlist[$i] & '\' & $rarfile) Then $Run=Run($winrar & ' x ' & '-ibck "' & $source & '\' & $rar[$b] & "\" & $dirlist[$i] & '\' & $rarfile & '" "' & $destination & '\' & $rar[$b] & '\"')
					WinRARWait($Run, $source & '\' & $rar[$b] & "\" & $dirlist[$i])
				EndIf
				If $exit=1 Then ExitLoop(2)
			Next
			FileClose($search)
	Next
	EndIf
	;f�jlok m�sol�sa
	If $film=$GUI_CHECKED And $exit=0 Then
		FileChangeDir($source & "\" & $rar[$b])

		For $k=1 To $filmtype[0]
			$searchfilm = FileFindFirstFile($filmtype[$k])
			If $searchfilm = -1  Then ContinueLoop
			
			;ha van ilyen form�tum akkor keresi
			While $exit=0
				$filmnev = FileFindNextFile($searchfilm)
				If @error Then ExitLoop
			
				If Not StringInStr($filmnev, "sample" ) Then
					ControlSetText ($Winrar_1, "", $Label5, $done+1 & "/" & $lista & " " & StringFormat("%.65s", "M�sol�s: " & $rar[$b]))
					;GUICtrlSetData($Progress1, 100*$done/$progmax)
					
					If $same_dest = $GUI_CHECKED Then
						If $naplo=1 Then FileWriteLine($log, _Now() & "-" & "M�sol�s:" & $rar[$b] & "\" & $filmnev & " -> " & $destination & '\')
						If Kivetel($source & "\" & $rar[$b] & "\" & $filmnev) Then _CopyWait($source & "\" & $rar[$b] & "\" & $filmnev, $destination & "\" & $filmnev)
					Else
						If $naplo=1 Then FileWriteLine($log, _Now() & "-" & "M�sol�s:" & $rar[$b] & "\" & $filmnev & " -> " & $destination & '\' & $rar[$b] & '\')
						If Kivetel($source & "\" & $rar[$b] & "\" & $filmnev) Then _CopyWait($source & "\" & $rar[$b] & "\" & $filmnev, $destination & "\" & $rar[$b] & "\" & $filmnev)
					EndIf
				EndIf
			WEnd
			FileClose($searchfilm)
		Next


		;alk�nyvt�rban filmkeres�s
		
		$dirlist=_FileListToArray($source & "\" & $rar[$b], "*", 2)
		If @error=0 Then
			For $i=1 To $dirlist[0]
				If Not StringInStr($dirlist[$i], "sample" ) Then
					FileChangeDir($source & "\" & $rar[$b] & "\" & $dirlist[$i])
					For $k=1 To $filmtype[0]
						$searchfilm = FileFindFirstFile($filmtype[$k])
						If $searchfilm = -1  Then ContinueLoop
						
						While $exit=0
							$filmnev=FileFindNextFile($searchfilm)
							If @error Then ExitLoop
							;ControlSetText ($Winrar_1, "", $Label5, $done+1 & "/" & $lista & " " & StringFormat("%.65s", "M�sol�s: " & $dirlist[$i]))
							
							If $same_dest = $GUI_CHECKED Then
								If $naplo=1 Then FileWriteLine($log, _Now() & "-" & "M�sol�s:" & $rar[$b] & "\" & $dirlist[$i] & "\" & $filmnev & " -> " & $destination)
								If Kivetel($source & "\" & $rar[$b] & "\" & $dirlist[$i] & "\" & $filmnev) Then _CopyWait($source & "\" & $rar[$b] & "\" & $dirlist[$i] & "\" & $filmnev, $destination & "\" & $filmnev)
							Else
								If $naplo=1 Then FileWriteLine($log, _Now() & "-" & "M�sol�s:" & $rar[$b] & "\" & $dirlist[$i] & "\" & $filmnev & " -> " & $destination & '\' & $rar[$b] & '\')
								If Kivetel($source & "\" & $rar[$b] & "\" & $dirlist[$i] & "\" & $filmnev) Then _CopyWait($source & "\" & $rar[$b] & "\" & $dirlist[$i] & "\" & $filmnev, $destination & "\" & $rar[$b] & "\" & $filmnev)
							EndIf
						WEnd
					Next
				EndIf
			Next
		EndIf
		FileClose($searchfilm)
	EndIf


	;D�tum be�ll�t�sa
	If $datum=$GUI_CHECKED And FileExists($destination & '\' & $rar[$b]) Then
		$date[$b]=StringReplace($date[$b], ".", "")
		$date[$b]=StringReplace($date[$b], ":", "")
		$date[$b]=StringReplace($date[$b], " ", "")
		$date[$b]=$date[$b] & "00"
		FileSetTime($destination & '\' & $rar[$b], $date[$b])
	EndIf

	$b=$b+1
	If $b>$a Then ExitLoop
	$done=$done+1
WEnd

;progressbar k�sz
GUICtrlSetData($Progress2, "100")
GUICtrlSetData($Progress1, "100")
WinSetTitle($Winrar_1, "", "100% - WinRAR4ever " & $ver)

;Keres�sek bez�r�sa
If $search<>"" Then FileClose($search)
FileClose($searchsample)
FileClose($searchnfo)
FileClose($searchfilm)

$egyedi=0

;Gui aktiv�l�sa, befejez�s
ControlSetText ($Winrar_1, "", $Label5, "")
Opt("GUIOnEventMode", 0)
ControlSetText ($Winrar_1, "", $btn, "Gyer�nk!")
GUICtrlSetOnEvent($btn, "")

;Hangjelz�s
If $hang = $GUI_CHECKED Then SoundPlay($SoundEnd, 0)

;id� sz�m�t�s
$ido=_DateDiff("s", $sStartDate, _NowCalc())
$perc=Int($ido/60)
$mp=$ido-($perc*60)
If $mp<10 Then $mp="0" & $mp

If $naplo=$GUI_CHECKED Then FileWriteLine($log, _Now() & "-" & "BEFEJEZVE! " & $perc & ":" & $mp )

If $kilepes=$GUI_UNCHECKED Then Befejezve($perc, $mp)
	
;MsgBox(64, "K�sz!", "Befejezve!" & @CRLF & @CRLF & $perc & ":" & $mp & " mp", 0, $Winrar_1)

GUICtrlDelete($Progress1)
GUICtrlDelete($Progress2)
WinSetTitle($Winrar_1, "", "WinRAR4ever " & $ver)

FileChangeDir(@DesktopDir)

EndFunc




;ini beolvas�sa
Func IniOlvas()

;r�gi ini t�rl�se
If $iniver<>IniRead($ini, "Settings", "Ini ver", "new") Then FileDelete($ini)

;WinRAR-ral
$ftype1=IniRead($ini, "Settings", "Filetype", "*.rar;*.001;*.zip;*.7z")
$filetype=StringSplit($ftype1, ";")
;max filetype[0]

;M�sol�shoz
$ftype2=IniRead($ini, "Settings", "Filetype copy", "*.avi;*.iso;*.mkv;*.mp4;*.nrg;*.cue;*.bin;*.mds;*.mdf;*.jpg;*.srt")
$filmtype=StringSplit($ftype2, ";")
;max filmtype[0]

$winrar=IniRead($ini, "Settings", "WinRAR", '"' & @ProgramFilesDir & '\WinRAR\WinRAR.exe"')

;be�ll�t�sok olvas�sa
$forr=IniRead($ini, "Path", "Source", @DesktopDir)
$forras=StringSplit($forr, ";")
$cel=IniRead($ini, "Path", "Destination", @DocumentsCommonDir )
$celok=StringSplit($cel, ";")

$naplo=IniRead($ini, "Settings", "Naplo", $GUI_UNCHECKED )
$same_dest=IniRead($ini, "Settings", "Destination_Same", $GUI_UNCHECKED )
$hang=IniRead($ini, "Settings", "Sound", $GUI_CHECKED )
$nfo_masol=IniRead($ini, "Settings", "nfoCopy", $GUI_CHECKED )
$kilepes=IniRead($ini, "Settings", "AutoExit", $GUI_UNCHECKED )
$quickscan=IniRead($ini, "Settings", "QuickScan", $GUI_CHECKED )
$datum=IniRead($ini, "Settings", "Date", $GUI_CHECKED )
$sample=IniRead($ini, "Settings", "Sample", $GUI_UNCHECKED )
$film=IniRead($ini, "Settings", "MovieCopy", $GUI_CHECKED )

$kivetel=IniRead($ini, "Settings", "Kivetel", $GUI_UNCHECKED )
$kivetel_list=IniRead($ini, "Settings", "Kivetel_list", "Sample;Minta;AutoCut;.exe" )
$kivetelek=StringSplit($kivetel_list, ";")

$SoundEnd=IniRead($ini, "Settings", "SoundEnd", @ScriptDir & "\Sound\tada.wav")
;$SoundError=IniRead($ini, "Settings", "SoundError", @WindowsDir & "\Sound\Error.wav")

If Not FileExists($ini) Then IniMent()

EndFunc


;Be�ll�t�sok ment�se ini-be
Func IniMent()

	IniWrite($ini, "Settings", "WinRAR", $winrar)
	IniWrite($ini, "Settings", "Sound", $hang)
	IniWrite($ini, "Settings", "nfoCopy", $nfo_masol)
	IniWrite($ini, "Settings", "AutoExit", $kilepes)
	IniWrite($ini, "Settings", "Date", $datum)
	IniWrite($ini, "Settings", "Sample", $sample)
	IniWrite($ini, "Settings", "MovieCopy", $film)
	IniWrite($ini, "Settings", "Filetype", $ftype1)
	IniWrite($ini, "Settings", "Filetype copy", $ftype2)
	IniWrite($ini, "Settings", "Naplo", $naplo)
	IniWrite($ini, "Settings", "Ini ver", $iniver)
	
	IniWrite($ini, "Settings", "Kivetel", $kivetel)
	IniWrite($ini, "Settings", "Kivetel_list", $kivetel_list)
	
	IniWrite($ini, "Settings", "SoundEnd", $SoundEnd)
	;IniWrite($ini, "Settings", "SoundError", $SoundError)

EndFunc





;Beolvassa a forr�smapp�t
Func Listaz()

GUICtrlSetColor ( $Label5, 0x000000)

$exit=0 ;v�gigmegy

$quickscan = GUICtrlRead($gyors)

If Not FileExists ($source) Then
	;SoundPlay($SoundError, 0)
	MsgBox(16, "Hiba!","A forr�smappa nem l�tezik!!! " & $source, 0, $Winrar_1)
	$exit=1
Else

	FileChangeDir($source)

	; Shows the filenames of all files in the current directory
	$search = FileFindFirstFile("*")  
	
	; Check if the search was successful
	If $search = -1 Then
		ControlSetText ($Winrar_1, "", $Label5, "Nincs tal�lat")
		$exit=1
	Else

		GUI_ki()
		ControlSetText ($Winrar_1, "", $Label5, "Adatok beolvas�sa...")


		$a=0
		While $exit=0
			$file = FileFindNextFile($search)
			If @error Then ExitLoop
	
			$attrib=FileGetAttrib ($file)
			If StringInStr($attrib, "D") Then
				$rar[$a]=$file
				$ido=FileGetTime($source & "\" & $file, 0, 0)
				$date[$a]=$ido[0] & "." & $ido[1] & "." & $ido[2] & " " & $ido[3] & ":" & $ido[4]
		
				If $quickscan = $GUI_UNCHECKED Then
					$meret[$a]=Round(DirGetSize($source & "\" & $file)/(1024*1024), 1)
				EndIf
		
				$a=$a+1
				If $a=$max Then Exitloop
			EndIf
		WEnd
	EndIf
EndIf


If $a=$max Then
	;SoundPlay($SoundError, 0)
	MsgBox(48, "Figyelem!", "T�bb mint 500 mapp�t tal�ltam! A program nem tudja mindegyiket megjelen�teni!", 0, $Winrar_1)
EndIf

$a=$a-1

; Close the search handle
If $exit=0 Then
	FileClose($search)
	ControlSetText ($Winrar_1, "", $Label5, "")
Else
	GUICtrlSetColor ( $Label5, 0xff0000) ;v�r�s
EndIf



Return ($exit)

EndFunc



;testreszab ablak, almapp�k kiv�laszt�sa
Func Testreszab()

Global $nCurCol = -1
Global $nSortDir = 1
Global $bSet = 0
Global $nCol = -1

$ret=Listaz()
;1 hiba 0 ok

If $ret=0 Then

If $quickscan=$GUI_UNCHECKED Then
	$label="�sszesen: " & $a+1 & " mappa, " & Meret() & " MiB"
Else
	$label="�sszesen: " & $a+1 & " mappa"
EndIf

#Region ### START Koda GUI section ### Form=e:\cd\v�logat�s\rendszer\autoit\koda\forms\winrar4ever_2.kxf
$Winrar_2 = GUICreate("WinRAR4ever - V�laszt�", 555, 445, -1, -1, BitOR($WS_SIZEBOX,$WS_TABSTOP), "",$Winrar_1)
GUISetIcon($icon)
If $quickscan=$GUI_UNCHECKED Then
	$ListView1 = GUICtrlCreateListView("N�v|D�tum|M�ret (Mib)", 17, 16, 513, 297, BitOR($WS_BORDER,$LVS_SORTASCENDING,$WS_HSCROLL), $LVS_EX_CHECKBOXES)
Else
	$ListView1 = GUICtrlCreateListView("N�v|D�tum", 17, 16, 513, 297, BitOR($WS_BORDER,$LVS_SORTASCENDING,$WS_HSCROLL), $LVS_EX_CHECKBOXES)
EndIf
GUICtrlRegisterListViewSort(-1, "LVSort")
$mind = GUICtrlCreateButton("M&ind", 453, 320, 65, 25, 0)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKSIZE)
$Button2 = GUICtrlCreateButton("&Egyik sem", 365, 320, 65, 25, 0)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKSIZE)
$OKt = GUICtrlCreateButton("&OK", 305, 368, 89, 41, 0)
GUICtrlSetFont(-1, 12, 800, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKHCENTER + $GUI_DOCKSIZE)
$Megsem = GUICtrlCreateButton("&M�gsem", 169, 368, 89, 41, 0)
GUICtrlSetFont(-1, 12, 800, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKHCENTER + $GUI_DOCKSIZE)
$Label1 = GUICtrlCreateLabel($label, 24, 328, 240, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Times New Roman")
;$Label = GUICtrlCreateLabel("*Maximum 500 mappa", 16, 320, 102, 17)

For $c=0 To $a
	If $quickscan=$GUI_UNCHECKED Then
		$List[$c] = GUICtrlCreateListViewItem($rar[$c] & "|" & $date[$c] & "|" & $meret[$c], $ListView1)
	Else
		$List[$c] = GUICtrlCreateListViewItem($rar[$c] & "|" & $date[$c], $ListView1)
	EndIf
	GUICtrlSetState ( $List[$c], $GUI_CHECKED )
Next

_GUICtrlListView_SetColumnWidth($ListView1, 0, 400)
_GUICtrlListView_SetColumnWidth($ListView1, 1, 100)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

$nochange=1

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
	Case $GUI_EVENT_CLOSE
		ExitLoop
	Case $Megsem
		ExitLoop
	Case $OKt
		$nochange=0
		ExitLoop	
	Case $mind
		$c=0
		For $c=0 To $a
			GUICtrlSetState ( $List[$c], $GUI_CHECKED )
		Next
	Case $Button2
		For $c=0 To $a
			GUICtrlSetState ( $List[$c], $GUI_UNCHECKED )
		Next
	Case $ListView1
		$bSet = 0
		$nCurCol = $nCol
		GUICtrlSendMsg($ListView1, $LVM_SETSELECTEDCOLUMN, GUICtrlGetState($ListView1), 0)
		DllCall("user32.dll", "int", "InvalidateRect", "hwnd", GUICtrlGetHandle($ListView1), "int", 0, "int", 1)
	EndSwitch
WEnd

$lista=0

If $nochange=0 Then
	For $c=0 To $a
		$check = GUICtrlRead ( $List[$c], 1 )
		If $check = $GUI_UNCHECKED Then
			$rar[$c]="??"
		Else
			$lista=$lista+1
		EndIf
	Next
EndIf

GUIDelete ( $Winrar_2 )
WinActivate ($Winrar_1)

EndIf

GUI_be()

EndFunc



;N�vjegy ablak
Func Nevjegy()
	
#Region ### START Koda GUI section ### Form=F:\#Scriptek\Koda\Forms\winrar4ever_nevjegy.kxf
$Nevjegy = GUICreate("N�vjegy", 320, 240, -1, -1, "", "", $Winrar_1)
GUISetIcon($icon)
$Label1 = GUICtrlCreateLabel("WinRAR4ever v" & $ver,  65, 32, 206, 26, $SS_CENTER)
GUICtrlSetFont(-1, 14, 800, 0, "Arial")
$Label2 = GUICtrlCreateLabel("K�sz�tette: SSJoc�", 110, 69, 116, 20, $SS_CENTER)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$web = GUICtrlCreateLabel("                       ", 90, 92, 156, 20, $SS_CENTER)
GUICtrlSetFont(-1, 10, 400, 4, "Arial")
GUICtrlSetColor(-1, 0x0000FF)
$Labelnev4 = GUICtrlCreateLabel("Verzi�v�ltoz�sok", 114, 136, 108,  17, $SS_CENTER)
GUICtrlSetFont(-1, 10, 400, 4, "Arial")
GUICtrlSetColor(-1, 0x0000FF)
$Button1 = GUICtrlCreateButton("&OK", 124, 175, 89, 25, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $web
			ShellExecute("                                             ")
		Case $Button1
			ExitLoop
		Case $Labelnev4
			If FileExists(@ScriptDir & "\WinRAR4ever.txt") Then
				Run("notepad.exe " & @ScriptDir & "\WinRAR4ever.txt")
			Else
				MsgBox(16, "Hiba!", 'Nem tal�lom a "WinRAR4ever.txt"-t!', 0, $Winrar_1)
			EndIf
	EndSwitch
WEnd

GUIDelete ( $Nevjegy )
WinActivate ($Winrar_1)

EndFunc




;Be�ll�t�sok ablak
Func Beallitas()
	
#Region ### START Koda GUI section ### Form=F:\#Scriptek\Koda\Forms\winrar4ever_beall.kxf
$Beall = GUICreate("WinRAR4ever " & $ver & " - Be�ll�t�sok", 430, 450, -1, -1, $WS_TABSTOP, "", $Winrar_1)
GUISetIcon($settico)
;Be�ll�t�sok
$Groupb2 = GUICtrlCreateGroup("Be�ll�t�sok",  10, 16, 410, 185)
$Inputb1 = GUICtrlCreateInput(StringReplace($winrar, '"', ''), 111, 40, 249, 21)
$Labelb1 = GUICtrlCreateLabel("WinRAR helye:", 32, 42, 77, 18)
$Buttonb1 = GUICtrlCreateButton("...", 370, 40, 30, 20, 0)
$sound_gui = GUICtrlCreateCheckbox("&Hangjelz�s ha k�sz", 32, 112, 113, 20)
GUICtrlSetTip(-1, "Hangjelz�s, ha minden kicsomagol�s elk�sz�lt")
$kilep_gui = GUICtrlCreateCheckbox("&Kil�p�s a v�g�n", 208, 112, 113, 20)
GUICtrlSetTip(-1, "A WinRAR4ever kil�p, a feladat befejezt�vel.")
$Type1_gui = GUICtrlCreateInput($ftype1, 106, 80, 297, 21)
GUICtrlSetTip(-1, "WinRAR �ltal t�mogatott t�m�r�tett form�tumok. pl.: *.rar;*.zip")
$labelbft1 = GUICtrlCreateLabel("F�jt�pusok", 34, 80, 53, 18)
$kivetel_gui = GUICtrlCreateCheckbox("Kiv�telek keres�n�l", 32, 137, 113, 20)
GUICtrlSetTip(-1, "Ha a teljes el�r�si �tvan szerepel az al�bbi sz�vegek egyike, akkor nem veszi figyelembe. Csak sz�veg t�mogatott! pl.: .exe, *exe NEM!")
$kivetell_gui = GUICtrlCreateInput($kivetel_list, 32, 159, 369, 21)
GUICtrlSetTip(-1, "Le�r�s")
GUICtrlCreateGroup("", -99, -99, 1, 1)
;Kit�m�r�t�s
$Groupb1 = GUICtrlCreateGroup("M�sol�s", 10, 210, 410, 153)
$datum_gui = GUICtrlCreateCheckbox("&D�tum megtart�sa",  25, 226, 113, 20)
GUICtrlSetTip(-1, "Az �j mappa �r�kli az eredeti d�tum�t")
$naplo_gui = GUICtrlCreateCheckbox("&Napl� k�sz�t�se",  25, 250, 113, 20)
GUICtrlSetTip(-1, "Napl�f�jl k�sz�l az esem�nyekr�l")
$nfo_gui = GUICtrlCreateCheckbox("&nfo m�sol�sa", 209, 250, 89, 20)
GUICtrlSetTip(-1, "nfo kiterjheszt�s� f�j m�sol�sa (ha van)")
$sample_gui = GUICtrlCreateCheckbox("&Sample m�sol�sa", 209, 226, 113, 20)
GUICtrlSetTip(-1, "Sample (minta) f�jl m�sol�sa")
$film_gui = GUICtrlCreateCheckbox("&F�jlok m�sol�sa", 25, 290, 160, 20)
GUICtrlSetTip(-1, "�tm�solja a nem t�m�r�tett vide�- �s lemezk�pf�jlokat.")
$labelbft2 = GUICtrlCreateLabel("F�jt�pusok", 30, 323, 53, 17)
$Type2_gui = GUICtrlCreateInput($ftype2, 108, 318, 297, 21)
GUICtrlSetTip(-1, "A keres�si felt�telnek megfelel� f�jlokat fogja �tm�solni. pl.: *.avi;*.mkv")
GUICtrlCreateGroup("", -99, -99, 1, 1)

$OKb = GUICtrlCreateButton("&OK", 254, 390, 75, 25, 0)
$Megsem = GUICtrlCreateButton("&M�gsem", 119, 390, 75, 25, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

GUICtrlSetState ( $datum_gui, $datum )
GUICtrlSetState ( $sound_gui, $hang )
GUICtrlSetState ( $nfo_gui, $nfo_masol )
GUICtrlSetState ( $kilep_gui, $kilepes )
GUICtrlSetState ( $sample_gui, $sample )
GUICtrlSetState ( $film_gui, $film )
GUICtrlSetState ( $naplo_gui, $naplo )
GUICtrlSetState ( $kivetel_gui, $kivetel )

;nem ment ini-be
$save=0

If $film=$GUI_CHECKED Then
	ControlEnable($Beall, "", $Type2_gui)
Else
	ControlDisable($Beall, "", $Type2_gui)
EndIf

If $kivetel=$GUI_CHECKED Then
	ControlEnable($Beall, "", $kivetell_gui)
Else
	ControlDisable($Beall, "", $kivetell_gui)
EndIf

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $Megsem
			ExitLoop
		Case $OKb
			$winrar='"' & GUICtrlRead($Inputb1) & '"'
			If FileExists(StringReplace($winrar, '"', '')) Then
				$save=1
				ExitLoop
			Else
				MsgBox(16, "Hiba!", "A WinRAR el�r�si �t hib�s!", 0, $Beall)
			EndIf
		Case $Buttonb1
			$message = "WinRAR helye"
			$winrar  = GUICtrlRead($Inputb1)
			$winrar = FileOpenDialog($message, @ProgramFilesDir, "Programok (*.exe)", 1 , "WinRAR.exe", $Beall)
			If $winrar<>"" Then GUICtrlSetData( $Inputb1, $winrar )
		Case $film_gui
			$film = GUICtrlRead($film_gui)
			If $film=$GUI_CHECKED Then
				ControlEnable($Beall, "", $Type2_gui)
			Else
				ControlDisable($Beall, "", $Type2_gui)
			EndIf
		Case $kivetel_gui
			$kivetel = GUICtrlRead($kivetel_gui)
			If $kivetel=$GUI_CHECKED Then
				ControlEnable($Beall, "", $kivetell_gui)
			Else
				ControlDisable($Beall, "", $kivetell_gui)
			EndIf
		EndSwitch	
WEnd

If $save=1 Then

	;Be�ll�t�sok olvas�sa GUI-b�l
	$hang = GUICtrlRead($sound_gui)
	$nfo_masol = GUICtrlRead($nfo_gui)
	$kilepes = GUICtrlRead($kilep_gui)
	$datum = GUICtrlRead($datum_gui)
	$sample = GUICtrlRead($sample_gui)
	$film = GUICtrlRead($film_gui)
	$ftype1 = GUICtrlRead($Type1_gui)
	$filetype=StringSplit($ftype1, ";") ;keres�s friss�t�se
	$ftype2 = GUICtrlRead($Type2_gui)
	$filmtype=StringSplit($ftype2, ";") ;keres�sek friss�t�se
	$naplo = GUICtrlRead($naplo_gui)
	$kivetel = GUICtrlRead($kivetel_gui)
	$kivetel_list = GUICtrlRead($kivetell_gui)
	$kivetelek=StringSplit($kivetel_list, ";") ;kiv�tellista friss�t�se

	;ment�s ini-be
	IniMent()
	
EndIf


GUIDelete ( $Beall )
WinActivate ($Winrar_1)

EndFunc



; Our sorting callback funtion
Func LVSort($hWnd, $nItem1, $nItem2, $nColumn)
	Local $nSort, $val1, $val2, $nResult
	
	; Switch the sorting direction
	If $nColumn = $nCurCol Then
		If Not $bSet Then
			$nSortDir = $nSortDir * - 1
			$bSet = 1
		EndIf
	Else
		$nSortDir = 1
	EndIf
	$nCol = $nColumn
	
	$val1 = GetSubItemText($hWnd, $nItem1, $nColumn)
	$val2 = GetSubItemText($hWnd, $nItem2, $nColumn)
		
	; If it is the 3rd colum (column starts with 0) then compare the dates
	If $nColumn = 1 Then
		$val1 = Number(StringLeft($val1, 4) & StringMid($val1, 6, 2) & StringMid($val1, 9, 2) & StringMid($val1, 12, 2) & StringRight($val1, 2))
		$val2 = Number(StringLeft($val2, 4) & StringMid($val2, 6, 2) & StringMid($val2, 9, 2) & StringMid($val2, 12, 2) & StringRight($val2, 2))
	EndIf
	
	If $nColumn = 2 Then
		$val1 = Number($val1)
		$val2 = Number($val2)
	EndIf
		
	$nResult = 0 	; No change of item1 and item2 positions
	
	If $val1 < $val2 Then
		$nResult = -1	; Put item2 before item1
	ElseIf $val1 > $val2 Then
		$nResult = 1	; Put item2 behind item1
	EndIf

	$nResult = $nResult * $nSortDir
	
	Return $nResult
EndFunc   ;==>LVSort


; Retrieve the text of a listview item in a specified column
Func GetSubItemText($nCtrlID, $nItemID, $nColumn)
	Local $stLvfi = DllStructCreate("uint;ptr;int;int[2];int")
	Local $nIndex, $stBuffer, $stLvi, $sItemText
	
	DllStructSetData($stLvfi, 1, $LVFI_PARAM)
	DllStructSetData($stLvfi, 3, $nItemID)

	$stBuffer = DllStructCreate("char[260]")
	
	$nIndex = GUICtrlSendMsg($nCtrlID, $LVM_FINDITEM, -1, DllStructGetPtr($stLvfi));
	
	$stLvi = DllStructCreate("uint;int;int;uint;uint;ptr;int;int;int;int")
	
	DllStructSetData($stLvi, 1, $LVIF_TEXT)
	DllStructSetData($stLvi, 2, $nIndex)
	DllStructSetData($stLvi, 3, $nColumn)
	DllStructSetData($stLvi, 6, DllStructGetPtr($stBuffer))
	DllStructSetData($stLvi, 7, 260)

	GUICtrlSendMsg($nCtrlID, $LVM_GETITEMA, 0, DllStructGetPtr($stLvi));

	$sItemText = DllStructGetData($stBuffer, 1)

	$stLvi = 0
	$stLvfi = 0
	$stBuffer = 0
	
	Return $sItemText
EndFunc   ;==>GetSubItemText


;Befejezve �zenet, eltelt id�vel
Func Befejezve($perc, $mp)
	ControlDisable ($Winrar_1, "", $btn)
	#Region ### START Koda GUI section ### Form=F:\#Scriptek\Koda\Forms\winrar4ever_befejez.kxf
	$Bef = GUICreate("Befejezve!", 320, 170, -1, -1, BitOR($WS_SIZEBOX,$WS_SYSMENU), "", $Winrar_1)
	$beflab = GUICtrlCreateLabel("A m�sol�s befejezve!", 57, 20, 220, 28, $SS_CENTER)
	GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
	$befido = GUICtrlCreateLabel($perc & ":" & $mp & " mp", 129, 50, 76, 17, $SS_CENTER)
	$befok = GUICtrlCreateButton("&OK", 131, 90, 73, 33, 0)
	$Beflog = GUICtrlCreateButton("Button2", 256, 100, 40, 40, $BS_ICON)
	GUICtrlSetImage(-1, "shell32.dll", 152)
	GUICtrlSetTip(-1, "Napl� megtekint�se")
	GUICtrlSetState(-1, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###
	
	If $naplo=$GUI_UNCHECKED Then ControlDisable($Bef, "", $Beflog)
	
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $befok
				ExitLoop
			Case $beflog
				Run("notepad.exe " & $log)
		EndSwitch
	WEnd
	
	GUIDelete($Bef)
	ControlEnable ($Winrar_1, "", $btn)
	WinActivate ($Winrar_1)
	
EndFunc


;Testreszab ablakban az �sszes forr�s m�ret�t sz�molja ki
Func Meret()
	$size=0
	For $b=0 to $a
		If $rar[$b]<>"??" Then $size=$size+$meret[$b]
	Next
	Return($size)
EndFunc



;letiltja a f�ablak vez�rl�it
Func GUI_ki()
	ControlDisable ($Winrar_1, "", $keres1)
	ControlDisable ($Winrar_1, "", $keres2)
	ControlDisable ($Winrar_1, "", $testreszab)
	ControlDisable ($Winrar_1, "", $azonos_gui)
	ControlDisable ($Winrar_1, "", $gyors)
	ControlDisable ($Winrar_1, "", $src_gui)
	ControlDisable ($Winrar_1, "", $dest_gui)
	ControlDisable ($Winrar_1, "", $MenuFile)
	ControlDisable ($Winrar_1, "", $MenuAbout)
EndFunc


;enged�lyezi a f�ablak vez�rl�it
Func GUI_be()
	ControlEnable ($Winrar_1, "", $keres1)
	ControlEnable ($Winrar_1, "", $keres2)
	ControlEnable ($Winrar_1, "", $testreszab)
	ControlEnable ($Winrar_1, "", $azonos_gui)
	ControlEnable ($Winrar_1, "", $gyors)
	ControlEnable ($Winrar_1, "", $src_gui)
	ControlEnable ($Winrar_1, "", $dest_gui)
	ControlEnable ($Winrar_1, "", $MenuFile)
	ControlEnable ($Winrar_1, "", $MenuAbout)
EndFunc


;V�r a WinRAR-ra, friss�ti a progressbart
Func WinRARWait($process, $sdir)
	$dirsize=DirGetSize($sdir, 2)
	While ProcessExists($process)
		$procstats = ProcessGetStats($process, 1)
		;al pbar
		$prog2=$procstats[4]/$dirsize*100
		GUICtrlSetData($Progress2, $prog2)
		;main pbar
		$prog1=$done*$pbar_slice+($pbar_slice*$prog2)/100
		$oldprog1=GUICtrlRead ($Progress1)
		If $oldprog1<$prog1 Then
			GUICtrlSetData($Progress1, $prog1)
			WinSetTitle($Winrar_1, "", Round($prog1) & "% - WinRAR4ever " & $ver)
		EndIf
		Sleep(1000)
	WEnd
	
	GUICtrlSetData($Progress2, "0")
EndFunc


;M�sol�s �s folyamatjelz�
Func _CopyWait($sfile, $dfile)
		
	; Get Destination Directory - without filename
    $DestDir = StringLeft($dfile, StringInStr($dfile, "\", "", -1))
	; Check destination directory exists and create it if it doesn't try to create it
    If Not FileExists($DestDir) Then
        $DirCreate = DirCreate($DestDir)
        If $DirCreate = 0 Then
			;SoundPlay($SoundError, 0)
			MsgBox(16, "Hiba!", "A k�vetkez� mapp�t nem tudtam l�trehozni: " & $DestDir)
		EndIf
    EndIf
	
	$destfree=DriveSpaceFree ( $DestDir )
	$filesize=FileGetSize($sfile)
		
	If $destfree>0 And $destfree<$filesize/1048576 Then
		;SoundPlay($SoundError, 0)
		MsgBox(16, "Kev�s a hely!!!", "A c�llemezen t�l kev�s a hely! (" & Round($destfree) & " MiB)" & @CRLF & "Szabad�ts fel helyet, majd kattint az OK-ra!" , 0, $Winrar_1)
	EndIf
	
	
	$torol=$dfile
	
	$sfile='"' & $sfile & '"'
	$dfile='"' & $dfile & '"'
	$run=Run(@ComSpec & " /c copy /y " & $sfile & " " & $dfile, @ScriptDir, @SW_HIDE)
	While ProcessExists($Run)
		$procstats = ProcessGetStats($Run, 1)
		;al pbar
		$prog2=$procstats[4]/$filesize*100
		GUICtrlSetData($Progress2, $prog2)
		;main pbar
		$prog1=$done*$pbar_slice+($pbar_slice*$prog2)/100
		$oldprog1=GUICtrlRead ($Progress1)
		If $oldprog1<$prog1 Then
			GUICtrlSetData($Progress1, $prog1)
			WinSetTitle($Winrar_1, "", Round($prog1) & "% - WinRAR4ever " & $ver)
		EndIf
		Sleep(1000)
	WEnd
	
	$torol=""
	GUICtrlSetData($Progress2, "0")
EndFunc

Func Kivetel($path)
	$return=1
	If $kivetel=$GUI_CHECKED Then
		For $i=1 To $kivetelek[0]
			If StringInStr($path, $kivetelek[$i]) Then
				$return=0
				If $naplo=1 Then FileWriteLine($log, _Now() & "A k�vetkez� f�jl kihagyva: " & $path)
				ExitLoop
			EndIf
		Next
	EndIf
	Return($return)
EndFunc

;Bez�rja a WinRAR-t, ha kell
Func Kilep()
	If ProcessExists($Run) Then
		$q=MsgBox(35, "Bez�rod ???", "M�sol�s/kit�m�r�t�s folyamatban... Megszak�tod most?" & @CRLF & "Igen - Megszak�tja, Nem - Befejezi az aktu�list, M�gsem - Folytat�s", 0, $Winrar_1)
		Switch $q
			Case 6 ;igen
				ProcessClose($Run)
				sleep(300)
				If WinExists("Bez�rod?") Then
					WinActivate("Bez�rod?")
					Send("i")
				EndIf
				$exit=1
			Case 7 ;Nem
				$exit=0
			;Case 3 ;m�gsem
		EndSwitch
	EndIf
	
	;Sleep(500)
	If $torol<>"" Then FileDelete($torol)
EndFunc


;t�rli az ablakot, ikonokat �s kil�p
Func Exitel()
	GUIDelete($Winrar_1)
	FileDelete($icon)
	FileDelete($settico)
	Exit
EndFunc