; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1.127
; Author:         Rick
;
; Script Function:
;	To find Drive letter of CD-RW Drive,   (For Win95 upwards)
;
;	Result = "CD-RW Drive letter" or "" for no CD-RW drive
;
; ----------------------------------------------------------------------------

MsgBox(0,"My CDRW Drive is:", _CDR() )

Func _CDR()
	$Drive=""
	if @OSTYPE = "WIN32_NT" then
		$VolReg=RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\CD Burning", "CD Recorder Drive")
		if not @error then
			$MD="HKEY_LOCAL_MACHINE\SYSTEM\MountedDevices"
			$Volume="\?" & StringMid($VolReg,3,StringLen($VolReg)-3)
			$VolReg=RegRead($MD,$Volume)
			For $i = 1 to 50
				$var = RegEnumVal($MD, $i)
				if @error <> 0 Then ExitLoop
				if Regread($MD,$var) = $VolReg AND Stringleft($var,4) = "\Dos" then $Drive = StringRight($var,2)
			next
		endif
	else
		$Regl="HKEY_LOCAL_MACHINE\Enum\SCSI\"
		$All= DriveGetDrive("All")
		For $i= 1 to $All[0]
			$var = RegEnumKey($Regl, $i)
			If @error <> 0 then ExitLoop
			$CDLine=$Regl & $var & "\" & RegEnumKey($Regl & $var,1)
			if RegRead( $CDLine,"Class") = "CDROM" AND Stringinstr(StringReplace($var,"ROM",""),"-R") > 0 then $Drive=RegRead( $CDLine,"CurrentDriveLetterAssignment") & ":"
		Next
	endif
	Return $Drive
Endfunc
