#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <Constants.au3>
#Include <File.au3>
#Include <Array.au3>
;#RequireAdmin


$destPath = FileGetShortName(@ScriptDir & "\Hak5 (Quicktime Large)\")
;$filename=_FileListToArray(@ScriptDir,"*.mp4",1)
$filename = FileGetShortName(@ScriptDir & "\PDF Exploits - Hak5.mp4")

;For $i=1 To $filename[0]
	;Read the QuickTime tag to get Season an Episode numbers
	Local $TagEGUI = Run(@ComSpec & " /c " & 'exiftool.pl -b -EpisodeGlobalUniqueID ' & $filename, "", @SW_HIDE, $STDOUT_CHILD)
	Local $sStdOut = ""
	While 1
		$sStdOut &= StdoutRead($TagEGUI)
		If @error Then ExitLoop
	Wend
	$Season = StringMid(StringMid($sStdOut,18,4),1,2)
	$Episode = StringMid(StringMid($sStdOut,18,4),3,2)

	;Read the Album tag to get the name of the folder
	Local $TagAlbum = Run(@ComSpec & " /c " & 'exiftool.pl -b -album ' & $filename, "", @SW_HIDE, $STDOUT_CHILD)
	Local $sStdOut0 = ""
	While 1
		$sStdOut0 &= StdoutRead($TagAlbum)
		If @error Then ExitLoop
	Wend

	;Read the Title tag to get the title for nfo file
	Local $TagTitle = Run(@ComSpec & " /c " & 'exiftool.pl -b -title ' & $filename, "", @SW_HIDE, $STDOUT_CHILD)
	Local $sStdOut1 = ""
	While 1
		$sStdOut1 &= StdoutRead($TagTitle)
		If @error Then ExitLoop
	Wend

	;Read the Rating tag
	Local $TagRating = Run(@ComSpec & " /c " & 'exiftool.pl -b -rating ' & $filename, "", @SW_HIDE, $STDOUT_CHILD)
	Local $sStdOut2 = ""
	While 1
		$sStdOut2 &= StdoutRead($TagRating)
		If @error Then ExitLoop
	Wend

	;Read the Description tag for plot
	Local $TagPlot = Run(@ComSpec & " /c " & 'exiftool.pl -b -description ' & $filename, "", @SW_HIDE, $STDOUT_CHILD)
	Local $sStdOut3 = ""
	While 1
		$sStdOut3 &= StdoutRead($TagPlot)
		If @error Then ExitLoop
	Wend

	;Read the Create Date for Air Date
	Local $TagAired = Run(@ComSpec & " /c " & 'exiftool.pl -b -createdate ' & $filename, "", @SW_HIDE, $STDOUT_CHILD)
	Local $sStdOut4 = ""
	While 1
		$sStdOut4 &= StdoutRead($TagAired)
		If @error Then ExitLoop
	Wend
	$AirDate = StringReplace(StringMid($sStdOut4,1,10),":","-")

	;Read the Duration tag for runtime
	Local $TagDuration = Run(@ComSpec & " /c " & 'exiftool.pl -T -Duration ' & $filename, "", @SW_HIDE, $STDOUT_CHILD)
	Local $sStdOut5 = ""
	While 1
		$sStdOut5 &= StdoutRead($TagDuration)
		If @error Then ExitLoop
	Wend

	;Read the Genre tag
	Local $TagGenre = Run(@ComSpec & " /c " & 'exiftool.pl -b -Genre ' & $filename, "", @SW_HIDE, $STDOUT_CHILD)
	Local $sStdOut6 = ""
	While 1
		$sStdOut6 &= StdoutRead($TagGenre)
		If @error Then ExitLoop
	Wend

	;Read the Artist tag for studio
	Local $TagArtist = Run(@ComSpec & " /c " & 'exiftool.pl -b -artist ' & $filename, "", @SW_HIDE, $STDOUT_CHILD)
	Local $sStdOut7 = ""
	While 1
		$sStdOut7 &= StdoutRead($TagArtist)
		If @error Then ExitLoop
	Wend

	;Read the year tag
	Local $TagYear = Run(@ComSpec & " /c " & 'exiftool.pl -b -year ' & $filename, "", @SW_HIDE, $STDOUT_CHILD)
	Local $sStdOut8 = ""
	While 1
		$sStdOut8 &= StdoutRead($TagYear)
		If @error Then ExitLoop
	Wend
	$Year = StringMid($sStdOut8,1,4)

	; Create Episode nfo file for XBMC
	$file = FileOpen( $sStdOut0 & ".s" & $Season & "e" & $Episode & ".nfo", 1)

	; Check if file opened for writing OK
	If $file = -1 Then
		MsgBox(0, "Error", "Unable to open file.")
		Exit
	EndIf

	FileWriteLine($file, "<?xml version=""1.0"" encoding=""UTF-8""?>")
	FileWriteLine($file, "<episodedetails>")
	FileWriteLine($file, "<title>" & $sStdOut1 & "</title>")
	FileWriteLine($file, "<rating>" & $sStdOut2 & "</rating>")
	FileWriteLine($file, "<season>" & $Season & "</season>")
	FileWriteLine($file, "<episode>" & $Episode & "</episode>")
	FileWriteLine($file, "<plot>" & $sStdOut3 & "</plot>")
	FileWriteLine($file, "<aired>" & $AirDate & "</aired>")
	FileWriteLine($file, "<runtime>" & $sStdOut5 & "</runtime>")
	FileWriteLine($file, "<genre>" & $sStdOut6 & "</genre>")
	FileWriteLine($file, "<studio>" & $sStdOut7 & "</studio>")
	FileWriteLine($file, "<year>" & $Year & "</year>")
	FileWriteLine($file, "</episodedetails>")

	FileClose($file)

	;Rename the MP4 file to XBMC standard
	FileMove( $filename, $destPath & $sStdOut0 & ".s" & $Season & "e" & $Episode & ".mp4", 0 )
	;Move the episode nfo created above to the same folder as the MP4
	FileMove( $file, $destPath & $file, 0 )
;Next