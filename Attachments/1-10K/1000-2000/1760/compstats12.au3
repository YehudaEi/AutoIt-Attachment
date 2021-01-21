; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         Ben Caplins <caplins@yahoo.com>
;
; Script Function:
;	output basic hardware info
;
; ----------------------------------------------------------------------------

; Script Start - Add your code below here

; obviously pull the cpu name
$cpugen = regRead("HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\CentralProcessor\0", "processornamestring")

; obviously pulls the cpu speed
$cpuat = " @ " &regRead("HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\CentralProcessor\0", "~MHz") & "MHz"

; combines the two for easy output .. also used stringstripws to strip spaces from front of cpu name
$cpuraw = $cpugen & $cpuat
$cpu = StringStripWS($cpuraw, 1)
; as requested by someone i will add in some xp version entries
; i decided not to include the buildlab... seemed redundant but its here if anyone wants to add it... just make an entry in the msg box and clipboard
; $buildlab = RegRead( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\", "BuildLab")
$servpackversion = RegRead( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\", "CSDversion")



; this was party of my revisions... some people dont have controlset001 in their registry some have 
; 002 or 003 so this part just uses the first subkey in the section
global $crtset
$crtset = RegEnumKey ( "HKEY_LOCAL_MACHINE\SYSTEM", 1)

; pulls the name for the video card drivers
dim $vide, $vidcard
$vide = "HKEY_LOCAL_MACHINE\SYSTEM\" & $crtset & "\Control\Class\{4D36E968-E325-11CE-BFC1-08002BE10318}\0000"
$vidcard = "Video card= " & regread ( $vide , "driverdesc" )

; this part got complicated... the general idea is the same as the video card but i had to write a bit of
; code to search through the key containing the sound infor for the actual audio device instead of ; the codecs and such
; I did this by looking for a certain regdword entry called "SetupPreferredAudioDevicesCount" which appeared to be indicitive of
; the actual audio device (although far from fool proof)
; the value for this regdword is different from machine to machne and several entries may exist with this
; "SetupPreferredAudioDevicesCount" so I just took the two that were the highest in magnitude and only displayed those
; I used a complicated array and function and If..endif to make it work but for the most part it seems to work although
; its not perfect
dim $soun, $soundcard

$string = _zounds("HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Class\{4D36E96C-E325-11CE-BFC1-08002BE10318}")
Dim $subkeystring
$subkeystring = _subkey($string)
$subarray = stringsplit($subkeystring, "|")


$soun = "HKEY_LOCAL_MACHINE\SYSTEM\" & $crtset & "\Control\Class\{4D36E96C-E325-11CE-BFC1-08002BE10318}\" & $subarray[1]
$soundcardone = "Sound device= " & regread ( $soun, "driverdesc")

$sountwo = "HKEY_LOCAL_MACHINE\SYSTEM\" & $crtset & "\Control\Class\{4D36E96C-E325-11CE-BFC1-08002BE10318}\" & $subarray[2]
$soundcardtwo = "Sound device= " & regread ( $sountwo, "driverdesc")

If $soundcardone = $soundcardtwo then
$soundcard = $soundcardone
endif

If $soundcardtwo <> $soundcardone and regread ( $sountwo, "driverdesc") <> "" then
$soundcard = $soundcardone & @crlf & $soundcardtwo
endif

If $soundcardtwo <> $soundcardone and regread ( $sountwo, "driverdesc") = "" then
$soundcard = $soundcardone
endif

; this pulls the monitor info
dim $monito, $monitor
$monito = "HKEY_LOCAL_MACHINE\SYSTEM\" & $crtset & "\Control\Class\{4D36E96E-E325-11CE-BFC1-08002BE10318}\0000"
$monitor = "Monitor= " & regread ($monito, "driverdesc")

; this pulls mouse info
dim $mous, $mouse
$mous = "HKEY_LOCAL_MACHINE\SYSTEM\" & $crtset & "\Control\Class\{4D36E96F-E325-11CE-BFC1-08002BE10318}\0000"
$mouse = "Mouse= " & regread ($mous, "driverdesc")

; mem info followed by drive infor
$mem = memgetstats( )

$szHardDrives        = ""
$szOpticalDrives    = ""
For $i = Asc("A") To Asc("Z")
    Dim $Drive    = Chr($i) & ":\"
    if DriveGetType($Drive) = "CDROM" Then
        $szOpticalDrives    = $szOpticalDrives & $Drive & " "
    Elseif DriveGetType($Drive) = "Fixed" Then
        $szHardDrives    = $szHardDrives & $Drive & "|"
  ;  ElseIf DriveGetType($Drive) = "
	Endif
Next
$OPletters = StringSplit( $szopticaldrives, "|")
$HDletters = StringSplit( $szHardDrives, "|")


for $inst = 1 to ($HDletters[0] - 1)
	global $diskdrives
	$diskdrives = $diskdrives & "Total space on   " & $HDletters[$inst] & " (" & DriveGetLabel($HDletters[$inst]) & ") = " & Round((DriveSpaceTotal($HDletters[$inst]) / 1000), 2) & " Gb" & @CRLF & "Free space on    " & $HDletters[$inst] & " (" & DriveGetLabel($HDletters[$inst]) & ") = " & Round((DriveSpaceFree($HDletters[$inst]) / 1000), 2) & " Gb" & @CRLF
Next

$opticaldrives = $szopticaldrives
	

$memfreeun = ($mem[2] / 1000)
$memtotalun = ($mem[1] / 1000)

$memfree = round($memfreeun, 0)
$memtotal = round($memtotalun, 0)

	
; displays in msg box
msgbox(48, "PC Stats", $cpu & @crlf & @osversion & " Build " & @OSBuild & " " & $servpackversion & @CRLF & $diskdrives & "Opticaldrives = " & $opticaldrives & @crlf & "Free physical memory = " & $memfree & " MB" & @crlf & "Total physical memory = " & $memtotal & " MB" & @crlf & $vidcard & @crlf & $soundcard & @crlf & $mouse & @crlf & $monitor)

; asks if you want to copy to clipboard
$answer = msgbox(4, "PC Stats", "Would you like to copy PC Stats to clipboard?")
If $answer = 6 Then
clipput ($cpu & @crlf & @osversion & " Build " & @OSBuild & " " & $servpackversion & @CRLF & $diskdrives & "Opticaldrives = " & $opticaldrives & @crlf & "Free physical memory = " & $memfree & " MB" & @crlf & "Total physical memory = " & $memtotal & " MB" & @crlf & $vidcard & @crlf & $soundcard & @crlf & $mouse & @crlf & $monitor)
endif

msgbox(48, "PC Stats", "Bye Bye and dont forget to thank WUS for this program")

; Various function used in the script (some of mine and some of the included ones)


FUNC _zounds($soundcardkey)
global $string
$i = 1
While 1
   $key = RegEnumKey($soundcardkey, $i)
   If @error = -1 Then ExitLoop
   $reg = RegRead($soundcardkey & "\" & $key,"SetupPreferredAudioDevicesCount")
 If $reg = "0" then
 $reg = "0"
  endif
  If $reg = "" then
   $reg = "-1"
   endif

$string = $string & $reg & " | "
   seterror(1)

   $i = $i + 1
WEnd
return $string
endfunc


FUNC _subkey($str)

$array = stringsplit( $str, "|")
_arraydelete ($array, 0)
$arrayoriginal = $array
$maxinda = _arraymaxindex($arrayoriginal, 1)
$maxa = $arrayoriginal[$maxinda]
_arraydelete ($array, $maxinda)
$arrayafter = $array
$maxindb = _arraymaxindex($arrayafter, 1)
$maxb = $arrayafter[$maxindb]

If $maxinda = 0 AND $maxa = -1 then
$subkeyone = "0000"
$subkeytwo = "0000"
return $subkeyone & "|" & $subkeytwo
endif

If $maxindb = 0 AND $maxb = -1 then
	If $maxinda < 10 then
	$subkeyone = "000" & $maxinda
	$subkeytwo = $subkeyone
	endif
	If $maxinda > 9 then
	$subkeyone = "00" & $maxinda
	$subkeytwo = $subkeyone
	endif
	 return  $subkeyone & "|" & $subkeytwo
endif
	IF $maxinda < 10 AND $maxindb < 9 AND $maxinda < $maxindb then
	$subkeyone = "000" & $maxinda
	$subkeytwo = "000" & ($maxindb + 1)
endif
	IF $maxinda < 10 AND $maxindb < 10 AND $maxinda > $maxindb then
	$subkeyone = "000" & $maxinda
	$subkeytwo = "000" & $maxindb
endif
	IF $maxinda > 9 AND $maxindb > 9 AND $maxinda > $maxindb then
	$subkeyone = "00" & $maxinda
	$subkeytwo = "00" & $maxindb
endif
	IF $maxinda > 9 AND $maxindb > 8 AND $maxinda < $maxindb then
	$subkeyone = "00" & $maxinda
	$subkeytwo = "00" & ($maxindb + 1)
endif
	IF $maxinda > 9 AND $maxindb < 10 AND $maxinda > $maxindb then
	$subkeyone = "00" & $maxinda
	$subkeytwo = "000" & $maxindb
endif
	If $maxinda < 10 AND $maxindb > 9 AND $maxinda < $maxindb then
	$subkeyone = "000" & $maxinda
	$subkeytwo = "00" & ($maxindb + 1)
endif
	return $subkeyone & "|" &$subkeytwo
endfunc


FUNC _ArrayMaxIndex($avArray, $iCompNumeric = 0, $i_Base = 0)
	Local $iCntr, $iMaxIndex = 0

	If Not IsArray($avArray) Then
		SetError(1)
		Return ""
	EndIf

	Local $iUpper = UBound($avArray)
	For $iCntr = $i_Base To ($iUpper - 1)
		If $iCompNumeric = 1 Then
			If Number($avArray[$iMaxIndex]) < Number($avArray[$iCntr]) Then
				$iMaxIndex = $iCntr
			EndIf
		Else
			If $avArray[$iMaxIndex] < $avArray[$iCntr] Then
				$iMaxIndex = $iCntr
			EndIf
		EndIf
	Next
	SetError(0)
	Return $iMaxIndex
EndFunc   ;==>_ArrayMaxIndex

FUNC _ArrayDelete(ByRef $avArray, $iElement)
	Local $iCntr = 0, $iUpper = 0, $iNewSize = 0

	If (Not IsArray($avArray)) Then
		SetError(1)
		Return ""
	EndIf

	; We have to define this here so that we're sure that $avArray is an array
	; before we get it's size.
	Local $iUpper = UBound($avArray)    ; Size of original array

	; If the array is only 1 element in size then we can't delete the 1 element.
	If $iUpper = 1 Then
		SetError(2)
		Return ""
	EndIf

	Local $avNewArray[$iUpper - 1]
	If $iElement < 0 Then
		$iElement = 0
	EndIf
	If $iElement > ($iUpper - 1) Then
		$iElement = ($iUpper - 1)
	EndIf
	If $iElement > 0 Then
		For $iCntr = 0 To $iElement - 1
			$avNewArray[$iCntr] = $avArray[$iCntr]
		Next
	EndIf
	If $iElement < ($iUpper - 1) Then
		For $iCntr = ($iElement + 1) To ($iUpper - 1)
			$avNewArray[$iCntr - 1] = $avArray[$iCntr]
		Next
	EndIf
	$avArray = $avNewArray
	SetError(0)
	Return 1
EndFunc   ;==>_ArrayDelete

