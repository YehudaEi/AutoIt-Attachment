;used for demonstration purposes only
local $foundAudioAudio,$thisdrive

;DEMO USE of Function
$foundAudioCD=_IsAudioCD($thisdrive)

if $foundAudioCD then msgbox(0,"","You have an Audio CD in your " &$thisdrive&" drive")


Func _IsAudioCD(ByRef $whatdrive)
;search through all the drives to find a cd rom drive,
;then see if it has an audio cd in there.
; TRUE = found audio cd,
; and returns the drive letter of the drive that had the audio cd in $whatdrive

; FALSE = didn't find audio cd, or user doesn't have a cd-rom drive

;used for return values
Local const $TRUE=1
Local const $FALSE=0

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
				;return what drive the Audio CD was in
				;and let user know we found an Audio CD ($TRUE)
				$whatdrive=StringUpper(StringLeft($var[$i],1))
				Return $TRUE
			EndIf
		Next
	Else
		return $FALSE
	EndIf

EndFunc