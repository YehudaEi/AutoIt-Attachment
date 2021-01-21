; ----------------------------------------------------------------------------
;
; AutoFLAC v1.0.1
; Author:	Jared Breland <jbreland@legroom.net>
; Homepage:	                             
; Language:	AutoIt v3.1.1
; License:	GNU General Public License (http://www.gnu.org/copyleft/gpl.html)
;
; Script Function:
;	Automate ripping and buring flac files with EAC
;
; ----------------------------------------------------------------------------

; Setup environment
#include <GUIConstants.au3>
global $name = "AutoFLAC"
global $version = "1.0.1"
global $title = $name & ' ' & $version
global $eactitle = "Exact Audio Copy"
global $regprefs = "HKCU\Software\" & $name
global $write = 0

; Program Options
global $ejectcomplete = 1
global $notifycomplete = 1
global $notifywav = "notify.wav"
global $flac = "flac.exe"
global $metaflac = "metaflac.exe"
global $md5sum = "md5sum.exe"
global $cdromdrive = "D:"
global $eac = regread("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\EAC.exe", "")
$regvalue = regread("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders", "My Music")
if not @error then
	global $outputdir = $regvalue
else
	global $outputdir = @mydocumentsdir & "\Music"
endif

; Extract options
global $extractmethod = 'all'
global $createcue = 1
global $createlog = 1

; Disc options
global $replaygain = 1
global $copydata = 1
global $multidisc = 0
global $discnum = 1

; Output options
global $checksums = 0

; Validate EAC binary exists
ReadPrefs()
while NOT fileexists($eac) AND NOT SearchPath($eac)
	$eac = inputbox($title, "EAC could not be automatically located." & @CRLF & "Please enter the full path for EAC.exe and click OK.", "C:\Path\To\EAC.exe", "", 275, 125)
	if @error then exit
wend

; Check for command line arguments
if $cmdline[0] > 0 then
	$write = 1
	$cuefile = ''
	if $cmdline[1] = "/write" then
		if $cmdline[0] > 1 then
			$cuefile = $cmdline[2]
		endif
	else
		$cuefile = $cmdline[1]
	endif

	; Validate cue file
	if $cuefile <> '' then
		; Must be a cue file
		if stringtrimleft($cuefile, stringinstr($cuefile, '.', 0, -1)) <> "cue" then
			msgbox(64, $title, "Usage:" & @CRLF & @scriptname & " [/write [album.cue]]")
			exit
		endif

		; Qualify full path
		if stringmid($cuefile, 2, 1) <> ":" then
			if stringleft($cuefile, 1) == "\" then
				$cuefile = stringleft(@workingdir, 2) & $cuefile
			else
				$cuefile = @workingdir & "\" & $cuefile
			endif
		endif

		; make sure cue file exists
		if NOT fileexists($cuefile) then
			msgbox(64, $title, "Usage:" & @CRLF & @scriptname & " [/write [album.cue]]")
			exit
		endif

	; Otherwise, prompt for cue file
	else
		$cuefile = fileopendialog($title, "", "Cue file (*.cue)", 1)
		if @error then exit
	endif
endif

; If /write passed, decompress flacs and load cue sheet for burning
if $write then

	; Setup paths and file names
	progresson($title, "Preparing files for writing", "Converting cue sheet", -1, -1, 16)
	$cuedir = stringleft($cuefile, stringinstr($cuefile, '\', 0, -1)-1)
	$cueext = stringtrimleft($cuefile, stringinstr($cuefile, '.', 0, -1))
	$cuename = stringtrimright(stringtrimleft($cuefile, stringlen($cuedir)+1), stringlen($cueext)+1)
	$tempdir = $cuedir & "\" & $name
	dircreate($tempdir)
	$infile = fileopen($cuefile, 0)
	$outfile = fileopen($tempdir & "\" & $cuename & ".wav.cue", 2)

	; Create new cue file, save flac filenames
	$i = 0
	dim $wavs[$i+1]
	while 1
		$line = filereadline($infile)
		if @error then exitloop
		if stringinstr($line, ".flac") then
			$wavs[$i] = stringmid($line, stringinstr($line, '"') + 1, stringinstr($line, '.', 0, -1) - stringinstr($line, '"')-1)
			$i = $i + 1
			redim $wavs[$i+1]
			$line = stringreplace($line, ".flac", ".wav", 0, 0)
		endif
		if stringinstr($line, "TRACK", 1) AND stringinstr($line, "MODE", 1) then
			exitloop
		endif
		filewriteline($outfile, $line)
	wend
	redim $wavs[$i]
	fileclose($outfile)
	fileclose($infile)

	; Verify checksums
	$md5file = $cuename & '.md5'
	if fileexists($cuedir & '\' & $md5file) then
		progressset(0, "Verifying MD5 checksums")
		runwait(@comspec & ' /c ' & filegetshortname($md5sum) & ' -c "' & $md5file & '" >"' & $tempdir & '\' & $cuename & '.md5.txt"', $cuedir, @SW_HIDE)
		$infile = fileopen($tempdir & "\" & $cuename & ".md5.txt", 0)
		$warning = ''
		$line = filereadline($infile)
		do
			if not stringinstr($line, ": OK", 1) then
				$warning = $warning & stringleft($line, stringinstr($line, '-')-1) & ', '
			endif
			$line = filereadline($infile)
		until @error
		fileclose($infile)
		if $warning <> '' then
			$warning = stringtrimright($warning, 2)
			progressoff()
			$prompt = msgbox(49, $title, "Warning: The following tracks could not be verified:" & @CRLF & $warning & @CRLF & @CRLF & "Click OK to continue writing this CD, or Cancel to abort.")
			if $prompt <> 1 then exit
			progresson($title, "Preparing files for writing", "Verifying MD5 checksums", -1, -1, 16)
		endif
	endif

	; Begin decompression
	for $i = 0 to ubound($wavs) - 1
		progressset(round($i/ubound($wavs), 2)*100, "Converting " & $wavs[$i] & ".wav")
		runwait(@comspec & ' /c ' & $flac & ' -d -o "' & $tempdir & '\' & $wavs[$i] & '.wav" "' & $cuedir & '\' & $wavs[$i] & '.flac"', $cuedir, @SW_HIDE)
	next
	progressoff()
endif

; Run EAC
if $write then
	$pid = runwait($eac & ' "' & $tempdir & '\' & $cuename & '.wav.cue"')
	dirremove($tempdir, 1)
	exit
else
	if NOT processexists("eac.exe") then run($eac)
endif
if winwait($eactitle, '', 15) then
	winactivate($eactitle)
else
	msgbox(48, $title, "Error: EAC could not be started.")
	exit
endif

; Otherwise, begine extract process
$extract = 1
while $extract
	$extract = ExtractCD()
wend
exit

; main function to extract CD contents
func ExtractCD()

	; Prompt to insert disc if necessary
	winactivate($eactitle)
	$album = controlgettext($eactitle, '', 'myedit1')
	if $album == '' then
		$prompt = msgbox(49, $title, "Please insert the CD you'd like to extract and click OK.")
		if $prompt <> 1 then exit
		while $album == ''
			$album = controlgettext($eactitle, '', 'myedit1')
		wend
	endif

	; If unknown disc is loaded, query FreeDB and prompt to edit
	;winactivate($eactitle)
	;if stringinstr($album, "Unknown") then
	;	send("!g")
	;	if winwait("Warning", "All data of the current CD", 1) then
	;		winactivate("Warning", "All data of the current CD")
	;		send("!y")
	;	endif
	;	sleep(500)
	;	while 1
	;		if winexists("Transfer", "CD Identification") then
	;			continueloop
	;		elseif winexists("Select CD", "Several exact matches") then
	;			continueloop
	;		else
	;			exitloop
	;		endif
	;	wend
	;endif

	; Prompt for CD info edit
	ExtractSetup()
	winactivate($eactitle)

	; Get CD info
	$artist = stringstripws(controlgettext($eactitle, '', 'myedit2'), 3)
	if $artist == "Various" then $artist = "Various Artists"
	$album = stringstripws(controlgettext($eactitle, '', 'myedit1'), 3)
	$genre = stringstripws(controlgettext($eactitle, '', 'Edit1'), 3)
	$ripdir = $outputdir & "\" & $genre & "\" & $artist & "\" & $album
	if $multidisc then
		$meta = $discnum & "00-"
	else
		$meta = "00-"
	endif

	; Select all tracks
	if $extractmethod == "all" then send("^a")

	; Create cue sheet
	if $createcue then
		send("!as{DOWN 2}{ENTER}")
		winwait("Analyzing", "", 5)
		while winexists("Analyzing")
			sleep(500)
		wend
		winactivate($eactitle)
	endif

	; Rip tracks
	opt("WinTitleMatchMode", 2)
	send("+{F5}")
	winwait("Extracting Audio Data", "", 5)
	while controlgettext("Extracting Audio Data", '', 'Button3') == "Cancel"
		sleep(500)
	wend

	; Check status for erros
	controlclick("Extracting Audio Data", '', 'Button3')
	sleep(200)
	winactivate("Status and Error Messages")
	sleep(200)
	dim $i, $warning, $track, $past
	while 1
		controlcommand("Status and Error Messages", '', 'ListBox1', 'SetCurrentSelection', $i)
		if @error then exitloop
		$line = controlcommand("Status and Error Messages", '', 'ListBox1', 'GetCurrentSelection')
		if stringleft($line, 5) == "Track" then
			$track = stringtrimleft($line, stringinstr($line, " ", 0, -1))
		endif
		if stringinstr($line, "Suspicious") then
			if $track <> $past then
				$warning = $warning & $track & ", "
				$past = $track
			endif
		endif
		$i = $i + 1
	wend
	controlclick("Status and Error Messages", '', 'Button1')
	winactivate($eactitle)

	; Update cue sheet for flacs
	if $createcue then
		$old = fileopen($outputdir & "\" & $album & ".cue", 0)
		if $multidisc then
			$new = fileopen($ripdir & "\" & $meta & $album & " (Disc " & $discnum & ").cue", 2)
		else
			$new = fileopen($ripdir & "\" & $meta & $album & ".cue", 2)
		endif
		$line = filereadline($old)
		do
			if $multidisc AND (stringleft($line, 5) == "TITLE") then
				$line = 'TITLE "' & $album & ' (Disc ' & $discnum & ')"'
			elseif stringinstr($line, "FILE ", 1) then
				$temp = stringtrimleft($line, stringinstr($line, '\', 0, -1))
				$tracknum = stringleft($temp, stringinstr($temp, '-')-1)
				$temp = stringleft($temp, stringinstr($temp, '.', 0, -1)-1)
				$trackname = stringtrimleft($temp, stringlen($tracknum)+1)
				if $multidisc then $tracknum = $discnum & $tracknum
				$line = 'FILE "' & $tracknum & '-' & $trackname & '.flac" WAVE'
			endif
			filewriteline($new, $line)
			$line = filereadline($old)
		until @error
		fileclose($new)
		fileclose($old)
		filerecycle($outputdir & "\" & $album & ".cue")
	endif

	; Process log file
	if $createlog then
		if $multidisc then
			filemove($outputdir & "\" & $album & ".log", $ripdir & "\" & $meta & $album & " (Disc " & $discnum & ").log", 1)
		else
			filemove($outputdir & "\" & $album & ".log", $ripdir & "\" & $meta & $album & ".log", 1)
		endif
	else
		filedelete($outputdir & "\" & $album & ".log")
	endif

	; Wait for flac compression to complete
	while processexists("flac.exe")
		sleep(3000)
	wend

	; Update tracknumbers
	if $multidisc then
		$flacs = filefindfirstfile($ripdir & "\*.flac")
		$flac = filefindnextfile($flacs)
		do
			if stringlen(stringleft($flac, stringinstr($flac, '-')-1)) == 2 then
				$tracknum = stringleft($flac, stringinstr($flac, "-")-1)
				runwait($metaflac & ' --remove-first-tag=TRACKNUMBER --set-tag=TRACKNUMBER=' & $discnum & $tracknum & ' "' & $ripdir & '\' & $flac & '"', $ripdir, @SW_HIDE)
				filemove($ripdir & '\' & $flac, $ripdir & '\' & $discnum & $flac, 1)
			endif
			$flac = filefindnextfile($flacs)
		until @error
		fileclose($flacs)
	endif

	; Add ReplayGain data
	if $replaygain then
		$flacs = filefindfirstfile($ripdir & "\*.flac")
		$flac = filefindnextfile($flacs)
		$list = ''
		do
			$list = $list & '"' & $flac & '" '
			$flac = filefindnextfile($flacs)
		until @error
		fileclose($flacs)
		run($metaflac & ' --add-replay-gain ' & $list, $ripdir, @SW_HIDE)
	endif

	; Add MD5 checksums
	if $checksums then
		if $replaygain then processwaitclose('metaflac.exe')
		runwait(@comspec & ' /c ' & filegetshortname($md5sum) & ' -b *.flac >"' & $meta & $album & '.md5"', $ripdir, @SW_HIDE)
	endif

	; Copy data
	if $copydata then
		$items = controllistview($eactitle, '', 'SysListView321', "GetItemCount")
		$lasttrack = controllistview($eactitle, '', 'SysListView321', "GetText", $items - 1, 0)
		if stringleft($lasttrack, 4) = "DATA" then
			$copyfailed = 0
			processclose("eac.exe")
			cdtray($cdromdrive, "open")
			sleep(1000)
			cdtray($cdromdrive, "closed")
			sleep(1000)
			dircreate($ripdir & "\Data")
			dircopy($cdromdrive, $ripdir & "\Data", 1)
			if dirgetsize($cdromdrive) <> dirgetsize($ripdir & "\Data") then $copyfailed = 1
			run($eac)
			winwait($eactitle)
			if $copyfailed then
				msgbox(48, $title, "Error: Not all data files were copied." & @CRLF & "One or more files could not be read from the CD.")
			endif
		endif
	endif

	; Notify that extraction is complete
	if $notifycomplete then
		if fileexists($notifywav) then
			soundplay($notifywav)
		else
			soundplay(@windowsdir & "\media\" & $notifywav)
		endif
	endif

	; Eject the disc
	if $ejectcomplete then
		cdtray($cdromdrive, "open")
	endif

	; Prompt to extract next CD
	if $warning then
		$warning = stringtrimright($warning, 2)
		$prompt = msgbox(49, $title, "Possible errors were detected in track(s): " & $warning & @CRLF & @CRLF & "Click OK to extract another CD, or Cancel to manually validate and repair the errors.")
	else
		$prompt = msgbox(33, $title, "Extraction complete with 0 detected errors." & @CRLF & @CRLF & "Would you like to extract another CD?")
	endif
	if $prompt <> 1 then
		processclose("eac.exe")
		return 0
	else
		return 1
	endif
endfunc

; Function to display extraction method prompt
func ExtractSetup()
	; Create GUI
	ReadPrefs()
	GUICreate($title, 400, 360)
	GUICtrlCreateLabel("Please make any changes you would like to the CD information before continuing.", 5, 5, -1, 20)
	GUICtrlCreateLabel("If you would like to extract individual tracks rather than the entire album,", 5, 20, -1, 20)
	GUICtrlCreateLabel("select each individual track in EAC, then select ""Individual Tracks"" below.", 5, 35, -1, 20)
	GUICtrlCreateLabel("Click OK when you are ready to begin extraction.", 5, 55, -1, 20)
	; Extract options
	GUICtrlCreateGroup("Extract Options", 5, 80, 115, 105)
	local $all = GUICtrlCreateRadio("&All Tracks", 10, 100, 100, 20)
	GUICtrlSetTip(-1, "Rip all tracks from the CD")
	local $sel = GUICtrlCreateRadio("&Selected Tracks", 10, 120, 100, 20)
	GUICtrlSetTip(-1, "Only rip tracks currently selected in EAC")
	local $cue = GUICtrlCreateCheckBox("Create &cue sheet", 10, 140, 100, 20)
	GUICtrlSetTip(-1, "Create a CUE sheet for the CD, which can be used to burn a duplicate backup copy")
	local $log = GUICtrlCreateCheckBox("Write &log file", 10, 160, 100, 20)
	GUICtrlSetTip(-1, "Save EAC's ripping output to a logfile")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	; Disc options
	GUICtrlCreateGroup("Disc Options", 135, 80, 125, 105)
	local $gain = GUICtrlCreateCheckBox("Enable ReplyGain", 140, 100, 110, 20)
	GUICtrlSetTip(-1, "Calculates and stores the Track and Album ReplayGain values")
	local $data = GUICtrlCreateCheckBox("Copy &data files", 140, 120, 100, 20)
	GUICtrlSetTip(-1, "If the CD is a multi-session disc with a ""data track""," & @CRLF & "copy all data files after ripping the CD")
	local $multi = GUICtrlCreateCheckBox("&Multi-disc set", 140, 140, 100, 20)
	GUICtrlSetTip(-1, "If the CD is part of a multi-disc set, this option will instruct" & @CRLF & $name & " to renumber/retag the ripped files to the format Nxx" & @CRLF & "where N is the Disc number and xx is the track number")
	GUICtrlCreateLabel("Disc", 160, 162, 20, 15)
	local $disc = GUICtrlCreateInput("", 185, 160, 15, 20)
	GUICtrlSetTip(-1, "Specifies the current disc number in a multi-disc set")
	GUICtrlCreateLabel("of the set", 205, 162, 50, 15)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	; Output options
	GUICtrlCreateGroup("Output Options", 275, 80, 120, 105)
	local $verify = GUICtrlCreateCheckBox("Write c&hecksums", 280, 100, 110, 20)
	GUICtrlSetTip(-1, "Calculates and stores the MD5 checksums for each track;" & @CRLF & "Can be used to verify track integrity before creating backup copy")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	; Program Options
	GUICtrlCreateGroup($name & " Options", 5, 190, 390, 125)
	GUICtrlCreateLabel("Output &base:", 10, 212, 80, 15, $SS_RIGHT)
	local $basedir = GUICtrlCreateInput($outputdir, 95, 210, 100, 20)
	GUICtrlSetTip(-1, "All tracks will be ripped to this root directory" & @CRLF & "in the format Base\Genre\Artist\Album\")
	local $basebut = GUICtrlCreateButton("...", 200, 210, 25, 20)
	GUICtrlCreateLabel("EAC binary:", 10, 232, 80, 15, $SS_RIGHT)
	local $eacbin = GUICtrlCreateInput($eac, 95, 230, 100, 20)
	GUICtrlSetTip(-1, "Location of EAC.exe")
	local $eacbut = GUICtrlCreateButton("...", 200, 230, 25, 20)
	GUICtrlCreateLabel("&Flac binary:", 10, 252, 80, 15, $SS_RIGHT)
	local $flacbin = GUICtrlCreateInput($flac, 95, 250, 100, 20)
	GUICtrlSetTip(-1, "Location of flac.exe")
	local $flacbut = GUICtrlCreateButton("...", 200, 250, 25, 20)
	GUICtrlCreateLabel("M&etaflac binary:", 10, 272, 80, 15, $SS_RIGHT)
	local $metaflacbin = GUICtrlCreateInput($metaflac, 95, 270, 100, 20)
	GUICtrlSetTip(-1, "Location of metaflac.exe")
	local $metaflacbut = GUICtrlCreateButton("...", 200, 270, 25, 20)
	GUICtrlCreateLabel("MD5sum binary:", 10, 292, 80, 15, $SS_RIGHT)
	local $md5bin = GUICtrlCreateInput($md5sum, 95, 290, 100, 20)
	GUICtrlSetTip(-1, "Location of md5sum.exe")
	local $md5but = GUICtrlCreateButton("...", 200, 290, 25, 20)
	GUICtrlCreateLabel("&Use CD-ROM drive: ", 240, 211, 95, 15)
	local $cdrom = GUICtrlCreateCombo("", 340, 208, 35, 20, $CBS_DROPDOWNLIST)
	GUICtrlSetTip(-1, "Specifies the CD-ROM drive from which " & $name & "will copy data;" & @CRLF & "This option should match the drive used by EAC")
	local $eject = GUICtrlCreateCheckBox("E&ject on complete", 240, 230, 115, 20)
	GUICtrlSetTip(-1, "Ejects the disc after ripping process is complete")
	local $notify = GUICtrlCreateCheckBox("&Notify on complete", 240, 250, 115, 20)
	GUICtrlSetTip(-1, "Plays a WAVE file after ripping process is complete")
	local $wave = GUICtrlCreateInput($notifywav, 260, 270, 100, 20)
	GUICtrlSetTip(-1, "The WAVE file that should be played after ripping process is complete")
	local $wavebut = GUICtrlCreateButton("...", 365, 270, 25, 20)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	; Buttons
	local $ok = GUICtrlCreateButton("&OK", 100, 330, 80, 20)
	local $cancel = GUICtrlCreateButton("Cancel", 200, 330, 80, 20)

	; Set properties
	if $extractmethod == 'all' then
		GUICtrlSetState($all, $GUI_CHECKED)
	elseif $extractmethod == 'sel' then
		GUICtrlSetState($all, $GUI_CHECKED)
	endif
	if $createcue then GUICtrlSetState($cue, $GUI_CHECKED)
	if $createlog then GUICtrlSetState($log, $GUI_CHECKED)
	if $replaygain then GUICtrlSetState($gain, $GUI_CHECKED)
	if $copydata then GUICtrlSetState($data, $GUI_CHECKED)
	if $multidisc then
		GUICtrlSetState($multi, $GUI_CHECKED)
		GUICtrlSetData($disc, $discnum)
	else
		GUICtrlSetState($disc, $GUI_DISABLE)
	endif
	if $checksums then GUICtrlSetState($verify, $GUI_CHECKED)
	if stringinstr(GetCDROMs(), $cdromdrive, 0) then
		GUICtrlSetData($cdrom, GetCDROMs(), $cdromdrive)
	else
		GUICtrlSetData($cdrom, GetCDROMs(), stringleft(GetCDROMs(), stringinstr(GetCDROMs(), '|')-1))
	endif
	if $ejectcomplete then GUICtrlSetState($eject, $GUI_CHECKED)
	if $notifycomplete then
		GUICtrlSetState($notify, $GUI_CHECKED)
	else
		GUICtrlSetState($wave, $GUI_DISABLE)
		GUICtrlSetState($wavebut, $GUI_DISABLE)
	endif
	GUICtrlSetState($ok, $GUI_DEFBUTTON)

	; Display GUI and wait for action
	GUISetState(@SW_SHOW)
	while 1
		$action = GUIGetMsg()
		select
			; Enable cue sheet creation if all tracks selected
			case $action == $all
				GUICtrlSetState($cue, $GUI_CHECKED)

			; Disable cue sheet creation if individual tracks selected
			case $action == $sel
				GUICtrlSetState($cue, $GUI_UNCHECKED)

			; Enable Disc field if Multi-disc option checked
			case $action == $multi
				if GUICtrlRead($multi) == $GUI_CHECKED then
					GUICtrlSetState($disc, $GUI_ENABLE)
					GUICtrlSetState($disc, $GUI_FOCUS)
				else
					GUICtrlSetState($disc, $GUI_DISABLE)
				endif

			; Enable Wave field if notify option checked
			case $action == $notify
				if GUICtrlRead($notify) == $GUI_CHECKED then
					GUICtrlSetState($wave, $GUI_ENABLE)
					GUICtrlSetState($wavebut, $GUI_ENABLE)
				else
					GUICtrlSetState($wave, $GUI_DISABLE)
					GUICtrlSetState($wavebut, $GUI_DISABLE)
				endif

			; Process output dir selection
			case $action == $basebut
				$dir = fileselectfolder("Select directory", "", 7, GUICtrlRead($basedir))
				if not @error then GUICtrlSetData($basedir, $dir)

			; Process EAC binary selection
			case $action == $eacbut
				$file = fileopendialog("Select file", "", "EXE file (*.exe)", 1)
				if not @error then GUICtrlSetData($eacbin, $file)

			; Process flac binary selection
			case $action == $flacbut
				$file = fileopendialog("Select file", "", "EXE file (*.exe)", 1)
				if not @error then GUICtrlSetData($flacbin, $file)

			; Process metaflac binary selection
			case $action == $metaflacbut
				$file = fileopendialog("Select file", "", "EXE file (*.exe)", 1)
				if not @error then GUICtrlSetData($metaflacbin, $file)

			; Process md5sum binary selection
			case $action == $md5but
				$file = fileopendialog("Select file", "", "EXE file (*.exe)", 1)
				if not @error then GUICtrlSetData($md5bin, $file)

			; Process wave file selection
			case $action == $wavebut
				$file = fileopendialog("Select file", @windowsdir & "\media", "Wave file (*.wav)", 1)
				if not @error then GUICtrlSetData($wave, $file)

			; Begin processing options
			case $action == $ok

				; Validate output dir
				if NOT fileexists(GUICtrlRead($basedir)) then
					msgbox(48, $title, "Error: You must select a valid output base directory.")
					GUICtrlSetState($basedir, $GUI_FOCUS)
					continueloop
				endif

				; Validate EAC binary
				if NOT fileexists(GUICtrlRead($eacbin)) AND NOT SearchPath(GUICtrlRead($eacbin)) then
					msgbox(48, $title, "Error: You must select the EAC binary to use for ripping.")
					GUICtrlSetState($eacbin, $GUI_FOCUS)
					continueloop
				endif

				; Validate flac binary
				if NOT fileexists(GUICtrlRead($flacbin)) AND NOT SearchPath(GUICtrlRead($flacbin)) then
					msgbox(48, $title, "Error: You must select the flac binary to use for encoding.")
					GUICtrlSetState($flacbin, $GUI_FOCUS)
					continueloop
				endif

				; Validate metaflac binary
				if NOT fileexists(GUICtrlRead($metaflacbin)) AND NOT SearchPath(GUICtrlRead($metaflacbin)) then
					msgbox(48, $title, "Error: You must select the metaflac binary to use for encoding.")
					GUICtrlSetState($metaflacbin, $GUI_FOCUS)
					continueloop
				endif

				; Validate md5sum binary
				if NOT fileexists(GUICtrlRead($md5bin)) AND NOT SearchPath(GUICtrlRead($md5bin)) then
					msgbox(48, $title, "Error: You must select the md5sum binary to use for encoding.")
					GUICtrlSetState($md5bin, $GUI_FOCUS)
					continueloop
				endif

				; Validate wave file
				if GUICtrlRead($notify) == $GUI_CHECKED AND NOT fileexists(GUICtrlRead($wave)) AND NOT fileexists(@windowsdir & "\media\" & GUICtrlRead($wave)) then
					msgbox(48, $title, "Error: You must select the wave file to use for notification.")
					GUICtrlSetState($wave, $GUI_FOCUS)
					continueloop
				endif

				; Validate disc input
				if GUICtrlRead($multi) == $GUI_CHECKED AND NOT stringisint(GUICtrlRead($disc)) then
					msgbox(48, $title, "Error: You must enter the disc number.")
					GUICtrlSetState($disc, $GUI_FOCUS)
					continueloop
				endif

				; Update global variables
				$outputdir = GUICtrlRead($basedir)
				$eac = GUICtrlRead($eacbin)
				$flac = GUICtrlRead($flacbin)
				$metaflac = GUICtrlRead($metaflacbin)
				$md5sum = GUICtrlRead($md5bin)
				$cdromdrive = GUICtrlRead($cdrom)
				if GUICtrlRead($eject) == $GUI_CHECKED then
					$ejectcomplete = 1
				else
					$ejectcomplete = 0
				endif
				if GUICtrlRead($notify) == $GUI_CHECKED then
					$notifycomplete = 1
					$notifywav = GUICtrlRead($wave)
				else
					$notifycomplete = 0
				endif
				if GUICtrlRead($cue) == $GUI_CHECKED then
					$createcue = 1
				else
					$createcue = 0
				endif
				if GUICtrlRead($log) == $GUI_CHECKED then
					$createlog = 1
				else
					$createlog = 0
				endif
				if GUICtrlRead($gain) == $GUI_CHECKED then
					$replaygain = 1
				else
					$replaygain = 0
				endif
				if GUICtrlRead($data) == $GUI_CHECKED then
					$copydata = 1
				else
					$copydata = 0
				endif
				if GUICtrlRead($multi) == $GUI_CHECKED then
					$multidisc = 1
					$discnum = GUICtrlRead($disc)
				else
					$multidisc = 0
				endif
				if GUICtrlRead($verify) == $GUI_CHECKED then
					$checksums = 1
				else
					$checksums = 0
				endif
				if GUICtrlRead($all) == $GUI_CHECKED then
					$extractmethod = 'all'
				else
					$extractmethod = 'sel'
				endif

				; Save preferences and begin extraction
				SavePrefs()
				GUIDelete()
				return

			; Exit if Cancel clicked or window closed
			case $action == $GUI_EVENT_CLOSE OR $action == $cancel
				exit
		endselect
	wend
endfunc

; Function to read AutoFLAC preferences
func ReadPrefs()
	$value = regread($regprefs, "createlog")
	if $value <> '' then $createlog = int($value)
	$value = regread($regprefs, "copydata")
	if $value <> '' then $copydata = int($value)
	$value = regread($regprefs, "replaygain")
	if $value <> '' then $replaygain = int($value)
	$value = regread($regprefs, "checksums")
	if $value <> '' then $checksums = int($value)
	$value = regread($regprefs, "outputdir")
	if $value <> '' then $outputdir = $value
	$value = regread($regprefs, "eac")
	if $value <> '' then $eac = $value
	$value = regread($regprefs, "flac")
	if $value <> '' then $flac = $value
	$value = regread($regprefs, "metaflac")
	if $value <> '' then $metaflac = $value
	$value = regread($regprefs, "md5sum")
	if $value <> '' then $md5sum = $value
	$value = regread($regprefs, "cdromdrive")
	if $value <> '' then $cdromdrive = $value
	$value = regread($regprefs, "ejectcomplete")
	if $value <> '' then $ejectcomplete = int($value)
	$value = regread($regprefs, "notifycomplete")
	if $value <> '' then $notifycomplete = int($value)
	$value = regread($regprefs, "notifywav")
	if $value <> '' then $notifywav = $value
	$extractmethod = 'all'
	$createcue = 1
	$multidisc = 0
endfunc

; Function to save AutoFLAC preferences
func SavePrefs()
	regwrite($regprefs, "createlog", "REG_SZ", $createlog)
	regwrite($regprefs, "copydata", "REG_SZ", $copydata)
	regwrite($regprefs, "replaygain", "REG_SZ", $replaygain)
	regwrite($regprefs, "checksums", "REG_SZ", $checksums)
	regwrite($regprefs, "outputdir", "REG_SZ", $outputdir)
	regwrite($regprefs, "eac", "REG_SZ", $eac)
	regwrite($regprefs, "flac", "REG_SZ", $flac)
	regwrite($regprefs, "metaflac", "REG_SZ", $metaflac)
	regwrite($regprefs, "md5sum", "REG_SZ", $md5sum)
	regwrite($regprefs, "cdromdrive", "REG_SZ", $cdromdrive)
	regwrite($regprefs, "ejectcomplete", "REG_SZ", $ejectcomplete)
	regwrite($regprefs, "notifycomplete", "REG_SZ", $notifycomplete)
	regwrite($regprefs, "notifywav", "REG_SZ", $notifywav)
endfunc

; Function to search %path% for executable
func SearchPath($file)
	; Search DOS path directories
	$dir = stringsplit(envget("path"), ';')
	redim $dir[$dir[0]+1]
	$dir[$dir[0]] = @scriptdir
	for $i = 1 to $dir[0]
		$exefiles = filefindfirstfile($dir[$i] & "\*.exe")
		if $exefiles == -1 then continueloop
		$exename = filefindnextfile($exefiles)
		do
			if $exename = $file then return 1
			$exename = filefindnextfile($exefiles)
		until @error
		fileclose($exefiles)
	next

	; Search Windows registered applications
	;$apppaths = "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths"
	;$i = 1
	;$exefile = regenumkey($apppaths, $i)
	;do
	;	if $exefile = $file then
	;		$exepath = regread($apppaths & '\' & $exefile, '')
	;		if fileexists($exepath) then
	;			return 1
	;		else
	;			return 0
	;		endif
	;	endif
	;	$i = $i + 1
	;	$exefile = regenumkey($apppaths, $i)
	;until @error
	return 0
endfunc

; Function to return list of CD-ROM drives
func GetCDROMs()
	$cdarr = drivegetdrive("CDROM")
	$cdlist = ""
	for $i = 1 to $cdarr[0]
		$cdlist = $cdlist & stringupper($cdarr[$i]) & "|"
	next
	stringtrimright($cdlist, 1)
	return $cdlist
endfunc
