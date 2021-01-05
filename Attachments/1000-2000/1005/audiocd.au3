Global const $TRUE=1
Global const $FALSE=0


local $findAudio
local $cddrive="e:"

$findAudio=_IsAudioCD()

if $findAudio then msgbox(0,"","You have an Audio CD in your cd-rom")
if _IsAudioCDdrive($cddrive) then msgbox(0,"",$cddrive&" has an audio cd in it")

Func _IsAudioCD()
;search through all the drives to find a cd rom drive,
;then see if it has an audio cd in there.
; TRUE = found audio cd
; FALSE = didn't find audio cd, or user doesn't have a cd-rom drive

	;get all CDROM drives
	$var = DriveGetDrive( "CDROM" )

	;if we found 1 or more cdrom drives then check if there's an 
	;audio cd in any of them
	If NOT @error Then
		For $i = 1 to $var[0]
			;change the path ---- used to tell FileFindFirstFile where to search
			;change it to our cd-rom
			FileChangeDir ( $var[$i]&"\" )
			; if find a .cda file then means we got an audio cd
			$search = FileFindFirstFile("*.cda")
			; Check if the search was successful
			; return appropriate value as specified in func description
			If $search = -1 Then
				Return $FALSE
			Else
				Return $TRUE
			EndIf
		Next
	Else
		return $FALSE
	EndIf

EndFunc

Func _IsAudioCdDrive($drive)
;$drive MUST be only drive w/colon otherwise causes error

	FileChangeDir ( $drive &"\" )
	; if find a .cda file then means we got an audio cd
	$search = FileFindFirstFile("*.cda")
	; Check if the search was successful
	; return appropriate value as specified in func description
	If $search = -1 Then
		Return $FALSE
	Else
		Return $TRUE
	EndIf
EndFunc