
;routine to find all hard drives i got this routine from a help file in auto it, it would be great if it could be adapted to do all the things i need
$var = DriveGetDrive( "all" )
If NOT @error Then
	MsgBox(4096,"", "Found " & $var[0] & " drives")
	For $i = 1 to $var[0]
		MsgBox(4096,"Drive " & $i, $var[$i])
	Next
EndIf

; need a decent routine to get free space of all hard drives and assignig drive space left to variables
;below is my novice way of doing the most common drive letters but if someone had a drive labeled j
;this would be missed .Any pointers on how to  improve this part of the script so that all connected hard drives will be accounted for would be appriciated.
$fsc = DriveSpaceFree( "c:\" )
$fsd = DriveSpaceFree( "d:\" )
$fse = DriveSpaceFree( "e:\" )
$fsf = DriveSpaceFree( "f:\" )
$fsg = DriveSpaceFree( "g:\" )
$fsh = DriveSpaceFree( "h:\" )
$uhd =@HomeDrive
;displaying space left for each drive
MsgBox(0, "Free space on C:", $fsc & " MB")
MsgBox(0, "Free space on D:", $fsd & " MB")
MsgBox(0, "Free space on E:", $fse & " MB")
MsgBox(0, "Free space on F:", $fsf & " MB")
MsgBox(0, "Free space on G:", $fsg & " MB")
MsgBox(0, "Free space on H:", $fsh & " MB")

MsgBox(0, " Home drive and operating system drive:", $uhd & " ")
MsgBox(0, "Total Free space on c and d:", $fsc+$fsd & " MB")

    ;this is where i want the main body of my coding to start the below routine's need to work out os version architecture free hard drive space
	;for all connected hard drives ,deliver software to the home drive, and folders to the first available hard drive with enougth space that does not
	;contain the operating system,if there is no other hard drive connected the routine must deliver folders to the homedrive user area.
	;I am a novice and I know this code dosen't have to be so long if this main body could some how be incorporated in the very first routine above to
	;find hard drives connected it would be great!

If $fsc<(1024 & "MB") Or @HomeDrive<> ('c:')Then
     MsgBox(0,"Cannot Install","Not enougth space or Operating System on wrong Drive"&@OSVersion&@OSArch)
	  Exit
  EndIf


;checking operating system version and architecture for windows 7.
If @OSVersion = ("WIN_7")And @OSArch =("X86")Then
	;the  next line just adds the total space left of drives ,d,e,f,g,h ,If the total is under 1gig
	;then there is either no other hard drive or not enougth space on whatever other hard drive
	;is present.therefor it then installs to drive c: it's not perfect because if there was 500mb on three drives
	; totaling over 1gig then   routine below becomes flawed it wont work  because no condition is met.

	If $fsd+$fse+$fsf+$fsg+$fsh< (1024 & "MB") And $fsc>= (1024 & "MB")Then
	MsgBox(0,"","Installing 32 bit Software and Folders to Drive C:"&@OSVersion&@OSArch)
	; install windows 7 32bit routine  to drive c: only ,will go here
	Exit
	EndIf

	ElseIf @OSVersion = ("WIN_7")And @OSArch =("X64")Then
	If $fsd+$fse+$fsf+$fsg+$fsh< (1024 & "MB") And $fsc>= (1024 & "MB")Then
	MsgBox(0,"","Installing 64bit software and Folders to Drive C:"&@OSVersion&@OSArch)
	; install xwindows 7 64bit routines  to drive c: only ,will go here
	Exit
	EndIf

EndIf


;installs folders to drive d if it's there and if it has space

If @OSVersion = ("WIN_7")And @OSArch =("X86")Then
	If $fsd>= (1024 & "MB") And $fsc> (1024 & "MB")Then
	MsgBox(0,"Installation Location","Installing 32 bit Software to Drive C: and Folders to Drive D:"&@OSVersion&@OSArch)
	; install windows 7 32bit routines  to drive c: and folders to drive d: to go here
	Exit
	EndIf

	ElseIf @OSVersion = ("WIN_7")And @OSArch =("X64")Then
	If $fsd>= (1024 & "MB") And $fsc> (1024 & "MB")Then
	MsgBox(0,"Installation Location","Installing 64bit software to Drive C: and Folders to Drive D:"&@OSVersion&@OSArch)
    ; install xwindows 7 64bit routines  to drive c: and folders to drive d: to go here
	Exit
	EndIf

EndIf

;installs folders to drive e if it's there and if it has space

If @OSVersion = ("WIN_7")And @OSArch =("X86")Then
	If $fse>= (1024 & "MB") And $fsc> (1024 & "MB")Then
	MsgBox(0,"Installation Location","Installing 32 bit Software to Drive C: and Folders to Drive E:"&@OSVersion&@OSArch)
	; install windows 7 32bit routines  to drive c: and folders to drive e: to go here
	Exit
	EndIf

	ElseIf @OSVersion = ("WIN_7")And @OSArch =("X64")Then
	If $fse>= (1024 & "MB") And $fsc> (1024 & "MB")Then
	MsgBox(0,"Installation Location","Installing 64bit software  to Drive C: and Folders to Drive E:"&@OSVersion&@OSArch)
    ; install xwindows 7 64bit routines  to drive c: and fiolders to drive e: to go here
	Exit
	EndIf

EndIf

;installs folders to drive f if it's there and if it has space

If @OSVersion = ("WIN_7")And @OSArch =("X86")Then
	If $fsf>= (1024 & "MB") And $fsc> (1024 & "MB")Then
	MsgBox(0,"Installation Location","Installing 32 bit Software to Drive C: and Folders to Drive F:"&@OSVersion&@OSArch)
	; install xwindow7 32bit routines  to drive c: and folders to drive f: to go here
	Exit
	EndIf

	ElseIf @OSVersion = ("WIN_7")And @OSArch =("X64")Then
	If $fsf>= (1024 & "MB") And $fsc> (1024 & "MB")Then
	MsgBox(0,"Installation Location","Installing 64bit software  to Drive C: and Folders to Drive F:"&@OSVersion&@OSArch)
    ; install xwindows 7 64bit routines  to drive c: and folders to drive f: to go here
	Exit
	EndIf

EndIf


;installs library to drive g if it's there and if it has space

If @OSVersion = ("WIN_7")And @OSArch =("X86")Then
	If $fsg>= (1024 & "MB") And $fsc> (1024 & "MB")Then
	MsgBox(0,"Installation Location","Installing 32 bit Software to Drive C: and Folders to Drive G:"&@OSVersion&@OSArch)
	; install xwindows 7 32bit routines  to drive c: and folders to drive g: to go here
	Exit
	EndIf

	ElseIf @OSVersion = ("WIN_7")And @OSArch =("X64")Then
	If $fsg>= (1024 & "MB") And $fsc> (1024 & "MB")Then
	MsgBox(0,"Installation Location","Installing 64bit software  to Drive C: and Folders to Drive G:"&@OSVersion&@OSArch)
    ; install xwindows 7 64bit routines  to drive c: and folders to drive g: to go here
	Exit
	EndIf

EndIf

;installs library to drive h if it's there and if it has space

If @OSVersion = ("WIN_7")And @OSArch =("X86")Then
	If $fsh>= (1024 & "MB") And $fsc> (1024 & "MB")Then
	MsgBox(0,"Installation Location","Installing 32 bit Software to Drive C: and Folders to Drive H:"&@OSVersion&@OSArch)
	; install xp 32bit routines  to drive c: and folders to drive h: to go here
	Exit
	EndIf

	ElseIf @OSVersion = ("WIN_7")And @OSArch =("X64")Then
	If $fsh>= (1024 & "MB") And $fsc> (1024 & "MB")Then
	MsgBox(0,"Installation Location","Installing 64bit software  to Drive C: and Folders to Drive H:"&@OSVersion&@OSArch)
    ; install xp 64bit routines  to drive c: and folders to drive h: to go here
	Exit
	EndIf

EndIf

;now I have to repeat all the routines above to check for for vista and xp  operating systems if there is no windows 7 operating system.

;this coding is cumbersome and is not ideal even though it works to a certain degree
;I would appreciate any pointers in the right direction
;I basicaly need to install software on drive c if there is enougth space
;and folders on The first available hard drive that enougth space and is not the home drive if available.
;if there are no other hard drives then install folders to the homedrive.






If @OSVersion <> ("WIN_7") Then
	MsgBox(0,"Just Testing","OS Version is not windows7 it is "&@OSVersion)
EndIf
