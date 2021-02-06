#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=..\_Icons\Music.ico
#AutoIt3Wrapper_outfile=Music Organiser.exe
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

Something I use to organise/merge music ripped from the various laptops in the house.
what it does is loop through a source directory (as well as any sub-directories)
reading mp3 file properties and copying them into a target directory containing a
very specific directory and file structure.

The source directory can have any structure as we use the file properties to derive
the target structure & file names.

Albumn Artist
	Albumn
		Track# - Track Name

I look in 3 places for an artist as sometimes the albumn artist is not populated, or
the contributing artist is populated with the albumn artist.
order is as follows:
if Artist has a value then use it,
if not use the value in artist 1,
if artist 1 is empty,
then use artist2
if that is empty, then use the literal string "Unknown"

For Windows 7 I use the following (VISTA & XP are different, so check)

Artist=216 (Album Artist
Artist1=20 (Author)
Artist2=13 (Contributing Artist/s)

There is some manipulation of ARTIST name to make it easier to filter out errors
in that in all instances the word 'The' is moved to the end.
eg. 'The Who' becomes 'Who, The'
this does NOT happen with albumns or tracks.

Other directory/filename manipulation is as follows:
in all instances, if an artist, albumn or track is not available it is replaced with the string 'Unknown'
All ocurences of illegal filename characters  as well as ,!` are removed
instances of & or = are replaced with 'and'
_ and - are changed to spaces.
any instances of .. are replaced with a .
all instances of multiple whitespace is replaced with a single space.
everything is changed to Proper Case"/"Title Case"

File Processing is as follows
if we do not have the file on our target directory, then we create it.
if we already have the file and the new one is of similar length (+- 20 seconds) we take the one with the highest bitrate.
if there is more than 20 seconds we take the longer one.
lastly, if we have processed any mp3 files and there is albumn art in our source folder, then that is also processed.

By default a log file is created detailing any new filed created.
detailed logging includes shedloads more, check the code.

this uses a bespoke version of _GetExtProperty() specifically for speed.

NO SOURCE mp3 file is deleted, you will have to do this manually, or change the code.

IMPORTANT
before you use this for real hit the 'Check ini' button and browse to an mp3 file with known properties.
then use the index of the results displayed to update the ini file.
remember that there is a difference between contributing artist (the default presented) and albumn artist
the higher values are nornmally the albumn artist and the lower ones contributing artist/s

Typical ini file contents for Windows 7 (These are NOT the same for Vista or XP)

[Defaults]
Artist=216
Artist1=20
Artist2=13
Albumn=14
Year=15
Title=21
Track=26
Duration=27
Bitrate=28



#ce ----------------------------------------------------------------------------

;; Script Start - Add your code below here
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#Include <String.au3>
#include <Array.au3>
#include <file.au3>
#Include <Misc.au3>
#include <Date.au3>


Global $previous, $current

$g_szVersion = "Music Organiser v1.1"
_Singleton($g_szVersion)
;~ If WinExists($g_szVersion) Then Exit ; It's already running

Opt("GUIOnEventMode", 1)

;~ Globals
Global $fileDirray[1]=[0]
; actual props returned
Global $pArtist = IniRead("Music Organiser.ini","Defaults","Artist",216)
Global $pArtist1 = IniRead("Music Organiser.ini","Defaults","Artist1",20)
Global $pArtist2 = IniRead("Music Organiser.ini","Defaults","Artist2",13)
Global $pAlbumn = IniRead("Music Organiser.ini","Defaults","Albumn",14)
Global $pYear = IniRead("Music Organiser.ini","Defaults","Year",15)
Global $pTitle = IniRead("Music Organiser.ini","Defaults","Title",21)
Global $pTrack = IniRead("Music Organiser.ini","Defaults","Track",26)
Global $pDuration = IniRead("Music Organiser.ini","Defaults","Duration",27)
Global $pBitrate = IniRead("Music Organiser.ini","Defaults","Bitrate",28)

#Region Form
$Form1 = GUICreate($g_szVersion, 400, 155, 205, 115)

$Label1 = GUICtrlCreateLabel("Merge From:", 8, 8, 60, 18,$SS_Right)
$Input1 = GUICtrlCreateInput("",70,8,290,18)
$Button1 = GUICtrlCreateButton("...", 365,8,30,18)
GUICtrlSetOnEvent($Button1,"getFrom")

$Label2 = GUICtrlCreateLabel("Merge To:", 8, 28, 60, 18,$SS_Right)
$Input2 = GUICtrlCreateInput("",70,28,290,18)
$Button2 = GUICtrlCreateButton("...", 365,28,30,18)
GUICtrlSetOnEvent($Button2,"getTo")

$Label3 = GUICtrlCreateLabel("", 8, 46, 380, 60)
$Checkbox1 = GUICtrlCreateCheckbox("Create Detailed Log",8,102)
$Button3 = GUICtrlCreateButton("Start", 78, 125, 240, 25, 0)
GUICtrlSetOnEvent($Button3,"StartMerge")

$Button4 = GUICtrlCreateButton("Check Ini", 340, 125, 60, 25, 0)
GUICtrlSetOnEvent($Button4,"MultiFunc")

GUISetOnEvent($GUI_EVENT_CLOSE,"OnExit")
GUISetState(@SW_SHOW)

#EndRegion ###

While 1
	Sleep(200)
WEnd


Func getFrom()
	GUICtrlSetData($Input1,FileSelectFolder ( "Browse for Merge Source (From)", "" , 0 ))
EndFunc

Func getTo()
	GUICtrlSetData($Input2,FileSelectFolder ( "Browse for Merge Target (To)", "" , 0 ))
EndFunc


Func StartMerge()

	ReDim $fileDirray[1]
	$fileDirray[0]=0

	local $fileArray, $ToRoot, $FromRoot, $FromFile, $ToFile
	local $i, $j, $Top1, $Top2, $FromProps, $ToProps
	Local $FullFilePath, $err, $DetailedLogFile, $gotMP3, $logFileHandle

;~ 	index to returned music props (Not the real ones)
	Local $iArtist, $iArtist1, $iArtist2, $iAlbumn, $iYear, $iTitle, $iTrack, $iDuration, $iBitrate
	$iArtist = 1
	$iArtist1 = 2
	$iArtist2 = 3
	$iAlbumn = 4
	$iYear = 5
	$iTitle = 6
	$iTrack = 7
	$iDuration = 8
	$iBitrate = 9

	$tCur = _Date_Time_GetLocalTime()
	$logFileHandle = FileOpen(@scriptdir & "\Log-"& StringRegExpReplace(_Date_Time_SystemTimeToDateTimeStr($tCur), '[\''\/:]', "-") &  ".txt",2)

	If GUICtrlRead($Checkbox1) = $GUI_CHECKED Then
		$DetailedLogFile = True
	Else
		$DetailedLogFile = False
	EndIf

	$FromRoot = GUICtrlRead($Input1)
	$ToRoot = GUICtrlRead($Input2)
	$Tofolder = ""

	GUICtrlSetState($Button1,$GUI_DISABLE)
	GUICtrlSetState($Button2,$GUI_DISABLE)
	GUICtrlSetState($Button3,$GUI_DISABLE)
	GUICtrlSetState($Input1,$GUI_DISABLE)
	GUICtrlSetState($Input2,$GUI_DISABLE)

	GUICtrlSetData($Label3,"Getting Directories.")
	getDirList(GUICtrlRead($Input1))

	GUICtrlSetData($Label3,"Sorting Directories")
	_ArraySort($fileDirray,0,1)

	$Top1 = $fileDirray[0]

	For $i = 1 to $Top1	;loop through directories
		$gotMP3 = False
		GUICtrlSetData($Label3,"Processing " & $fileDirray[$i])
		$fileArray = _FileListToArray($fileDirray[$i])	; get a list of files in this directory
		If IsArray($fileArray) Then
			$Top2 = $fileArray[0]
			_ArraySort($fileArray,0,1) ; put MP3 before jpg
;~ 			_ArrayDisplay($fileArray)
			For $j = 1 to $Top2	; loop through files
				If StringUpper(StringRight($fileArray[$j],3)) = "MP3" Then	; don't care about the others
					$gotMP3 = True
					If $DetailedLogFile Then
						filewriteline($logFileHandle, "Original: " & $fileDirray[$i] & "\" & $fileArray[$j])
					EndIf
					$FromProps = _GetExtProperty($fileDirray[$i] & "\" & $fileArray[$j],0 )
					$FromProps[$iDuration] = StringLeft($FromProps[$iDuration],2) & StringMID($FromProps[$iDuration],4,2) & StringRight($FromProps[$iDuration],2)
					$FromProps[$iBitrate] = StringLeft($FromProps[$iBitrate],StringLen($FromProps[$iBitrate]) -4)

					If StringLen(StringStripWS($FromProps[$iTrack],8)) = 1 Then $FromProps[$iTrack] = "0" & $FromProps[$iTrack]
					If StringLen(StringStripWS($FromProps[$iTrack],8)) > 0 then $FromProps[$iTrack] =  $FromProps[$iTrack] & " - "

;~ 					get rid if illegal filename characters (and a handful of others)
					$FromProps[$iArtist] = StringRegExpReplace($FromProps[$iArtist], '[\''\/@:?*"<>|,!`]', "")
					$FromProps[$iArtist1] = StringRegExpReplace($FromProps[$iArtist1], '[\''\/@:?*"<>|,!`]', "")
					$FromProps[$iArtist2] = StringRegExpReplace($FromProps[$iArtist2], '[\''\/@:?*"<>|,!`]', "")
					$FromProps[$iAlbumn] = StringRegExpReplace($FromProps[$iAlbumn], '[\''\/@:?*"<>|,!`]', "")
					$FromProps[$iTitle] = StringRegExpReplace($FromProps[$iTitle] , '[\''\/@:?*"<>|,!`]', "")

;~ 					Make everything consistent
					$FromProps[$iArtist] = StringRegExpReplace($FromProps[$iArtist], "[&+]", " and ")
					$FromProps[$iArtist1] = StringRegExpReplace($FromProps[$iArtist1], "[&+]", " and ")
					$FromProps[$iArtist2] = StringRegExpReplace($FromProps[$iArtist2], "[&+]", " and ")
					$FromProps[$iAlbumn] = StringRegExpReplace($FromProps[$iAlbumn], "[&+]", " and ")
					$FromProps[$iTitle] = StringRegExpReplace($FromProps[$iTitle] , "[&+]", " and ")

;~ 					turnen dashes or underscores into Spaces
					$FromProps[$iArtist] = StringRegExpReplace($FromProps[$iArtist], '[\-_]', " ")
					$FromProps[$iArtist1] = StringRegExpReplace($FromProps[$iArtist1], '[\-_]', " ")
					$FromProps[$iArtist2] = StringRegExpReplace($FromProps[$iArtist2], '[\-_]', " ")
					$FromProps[$iAlbumn] = StringRegExpReplace($FromProps[$iAlbumn], '[\-_]', " ")
					$FromProps[$iTitle] = StringRegExpReplace($FromProps[$iTitle] , '[\-_]', " ")

;~ 					Get rid of extra whitespace and change to 'Proper Case"

					$FromProps[$iArtist] = _StringProper(StringStripWS($FromProps[$iArtist],7))
					$FromProps[$iArtist1] = _StringProper(StringStripWS($FromProps[$iArtist1],7))
					$FromProps[$iArtist2] = _StringProper(StringStripWS($FromProps[$iArtist2],7))
					$FromProps[$iAlbumn] = _StringProper(StringStripWS($FromProps[$iAlbumn],7))
					$FromProps[$iTitle] = _StringProper(StringStripWS($FromProps[$iTitle],7))

					If StringLen(StringStripWS($FromProps[$iArtist],8)) = 0  Then $FromProps[$iArtist] = $FromProps[$iArtist1]
					If StringLen(StringStripWS($FromProps[$iArtist],8)) = 0  Then $FromProps[$iArtist] = $FromProps[$iArtist2]
					If StringLen(StringStripWS($FromProps[$iArtist],8)) = 0  Then $FromProps[$iArtist] = "Unknown"
					If StringLen(StringStripWS($FromProps[$iAlbumn],8)) = 0  Then $FromProps[$iAlbumn] = "Unknown"
					If StringLen(StringStripWS($FromProps[$iTitle],8)) = 0  Then $FromProps[$iTitle] = "Unknown"

;~ 					to make it easier to find lazy naming conventions
					If StringUpper(StringLeft($FromProps[$iArtist],4)) = "THE " Then
						$FromProps[$iArtist] = StringMid($FromProps[$iArtist],5) & ", The"
					EndIf

					$ToFile = $ToRoot & "\" & $FromProps[$iArtist] & "\" & $FromProps[$iAlbumn] & "\" & $FromProps[$iTrack] & $FromProps[$iTitle] & ".mp3"
					$Tofolder =  $ToRoot & "\" & $FromProps[$iArtist] & "\" & $FromProps[$iAlbumn] & "\"

;~ 					Not to Mention loads of ....
					For $loop = 1 To 5
						$ToFile = StringReplace($ToFile,"..",".")
						$Tofolder = StringReplace($Tofolder,"..",".")
					Next

					$Fromfile =  $fileDirray[$i] & "\" & $fileArray[$j]
					If FileExists($ToFile) Then
;~ 						ConsoleWrite (@ScriptLineNumber & " " & $ToFile & @crlf)
;~ 						We do have the file so, lets see which on is best.
						$ToProps = _GetExtProperty($ToFile,0 )
						$ToProps[$iDuration] = StringLeft($ToProps[$iDuration],2) & StringMID($ToProps[$iDuration],4,2) & StringRight($ToProps[$iDuration],2)
						$ToProps[$iBitrate] = StringLeft($ToProps[$iBitrate],StringLen($ToProps[$iBitrate]) -4)
						If CloseEnough($ToProps[$iDuration], $FromProps[$iDuration]) Then	; similar duration
							If $ToProps[$iBitrate] < $FromProps[$iBitrate]	Then ; take the one with the highest bitrate
								FileCopy($Fromfile, $ToFile,9)
								If $err = 0 Then
									filewriteline($logFileHandle,"Error replacing low bitrate " & $ToFile & " with " & $FromFile & @crlf)
								EndIf
								If $DetailedLogFile Then
									filewriteline($logFileHandle, "Higher Bitrate: " & $ToFile)
								EndIf
							EndIf
						Else	; Big difference in duration so take the longer one.
							If $FromProps[$iDuration] > $ToProps[$iDuration] Then
								$err = FileCopy($Fromfile, $ToFile,9)
								If $err = 0 Then
									filewriteline($logFileHandle,"Error replacing short " & $ToFile & " with " & $FromFile & @crlf)
								EndIf
								If $DetailedLogFile Then
									filewriteline($logFileHandle, "Longer Track: " & $ToFile)
								EndIf
							EndIf
						EndIf
					Else
;~ 						We don't already have the file so create it.
						$err = FileCopy($Fromfile, $ToFile,9)
						If $err = 0 Then
							filewriteline($logFileHandle,"Error copying " & $FromFile & " To " & $ToFile & @crlf)
						Else
							filewriteline($logFileHandle, "Created New File: " & $ToFile)
						EndIf
					EndIf
					$copiedMusic = True
				Else
					If $gotMP3 Then	; only of we had mp3's (otherwise we do not have an accurate target directory)
						If StringUpper(StringRight($fileArray[$j],3)) = "JPG" Then
							$Fromfile =  $fileDirray[$i] & "\" & $fileArray[$j]
							$ToFile = $Tofolder & $fileArray[$j]
							If FileGetSize($Fromfile) > FileGetSize($ToFile) Then	; Copy any albumn art if larger
								FileCopy($Fromfile, $ToFile,1)	; only is there is a directory
							EndIf
						EndIf
					EndIf
				EndIf
			Next
		EndIf
	Next

	FileClose($logFileHandle)

	GUICtrlSetState($Button1,$GUI_ENABLE)
	GUICtrlSetState($Button2,$GUI_ENABLE)
	GUICtrlSetState($Button3,$GUI_ENABLE)
	GUICtrlSetState($Input1,$GUI_ENABLE)
	GUICtrlSetState($Input2,$GUI_ENABLE)
	GUICtrlSetData($Label3,"Done.")

EndFunc

Func getDirList($folderName)	; Get list of source directories
Local $fileArray, $i, $FullFilePath, $fileAttributes

$fileArray = _FileListToArray($folderName)

_ArrayAdd($fileDirray,$folderName)

If IsArray($fileArray) Then
	For $i=1 To $fileArray[0]
		$fullFilePath = $folderName & "\" & $fileArray[$i] ;retrieve the full path
		$fileAttributes = FileGetAttrib($fullFilePath)
		If StringInStr($fileAttributes,"D")  > 0 Then ;folder, have to explore
			Dim $tempArray = getDirList($fullFilePath) ;recursive call
			_ArrayConcatenate($fileDirray,$tempArray,1) ;add returned results to already found files
		EndIf
	Next
	$fileDirray[0] = UBound($fileDirray) - 1 ;adjust the size of the array
 EndIf

EndFunc

Func CloseEnough($a,$b)
	local $diff = Abs($a - $b)
	If $diff < 20 Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc

Func MultiFunc()
	local $FromProps
	$FromProps = _GetExtProperty(FileOpenDialog("Browse for Source MP3 file","","Music (*.mp3)"),-1 )
	_ArrayDisplay($FromProps)
EndFunc

Func showElapsed($line)

	$current = _Date_Time_GetTickCount()
	consolewrite ($line & " " & _Date_Time_GetTickCount() & " " & $previous - $current    & @CRLF)
	$previous = $current

EndFunc

Func onExit()
	Exit
EndFunc

;===============================================================================
; Function Name:	GetExtProperty($sPath,$iProp)
; Description:      Returns an extended property of a given file.
; Parameter(s):     $sPath - The path to the file you are attempting to retrieve an extended property from.
;                   $iProp - The numerical value for the property you want returned. If $iProp is is set
;							  to -1 then all properties will be returned in a 1 dimensional array in their corresponding order.
;
;	Vista and WIn 7 have  loads of extended file properties (Most of them are blank though!!)
;
; Requirement(s):   File specified in $spath must exist.
; Return Value(s):  On Success - The extended file property, or if $iProp = -1 then an array with all properties
;                   On Failure - 0, @Error - 1 (If file does not exist)
; Author(s):        Simucal (Simucal@gmail.com)
;                     - Modified by: Sean Hart <autoit@hartmail.ca>
;                     - Modified by: teh_hahn <sPiTsHiT@gmx.de>
;
; Note(s):		THIS HAS BEEN CHANGED TO BE SPECIFIC FOR THIS USE!!
;
;===============================================================================
Func _GetExtProperty($sPath, $iProp)
	Local $iExist, $sFile, $sDir, $oShellApp, $oDir, $oFile, $aProperty, $sProperty
	$iExist = FileExists($sPath)
	If $iExist = 0 Then
		SetError(1)
		Return 0
	Else
		$sFile = StringTrimLeft($sPath, StringInStr($sPath, "\", 0, -1))
		$sDir = StringTrimRight($sPath, (StringLen($sPath) - StringInStr($sPath, "\", 0, -1)))
		$oShellApp = ObjCreate ("shell.application")
		$oDir = $oShellApp.NameSpace ($sDir)
		$oFile = $oDir.Parsename ($sFile)
		If $iProp = -1 Then
		    Local $aProperty[1][2] = [[1]]
			For $i = 0 To 300
				If $oDir.GetDetailsOf($oDir.Items, $i) Then
					ReDim $aProperty[ $i + 1][2]
					$aProperty[$i][0] = $oDir.GetDetailsOf($oDir.Items, $i)
					$aProperty[$i][1] = $oDir.GetDetailsOf($oFile, $i)
				EndIf
			Next
			Return $aProperty
		Else
			Local $aProperty[10]
			$aProperty[0] = 9
			$aProperty[1] = $oDir.GetDetailsOf ($oFile, $pArtist)
			$aProperty[2] = $oDir.GetDetailsOf ($oFile, $pArtist1)
			$aProperty[3] = $oDir.GetDetailsOf ($oFile, $pArtist2)
			$aProperty[4] = $oDir.GetDetailsOf ($oFile, $pAlbumn)
			$aProperty[5] = $oDir.GetDetailsOf ($oFile, $pYear)
			$aProperty[6] = $oDir.GetDetailsOf ($oFile, $pTitle)
			$aProperty[7] = $oDir.GetDetailsOf ($oFile, $pTrack)
			$aProperty[8] = $oDir.GetDetailsOf ($oFile, $pDuration)
			$aProperty[9] = $oDir.GetDetailsOf ($oFile, $pBitrate)
			Return $aProperty
		EndIf
	EndIf
EndFunc   ;==>_GetExtProperty
