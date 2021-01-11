; ----------------------------------------------------------------------------
;
; extractMHT v1.0
; Author:	Jared Breland <jbreland@legroom.net>
; Homepage:	                             
; Language:	AutoIt v3.2.0.1
; License:	GNU General Public License (http://www.gnu.org/copyleft/gpl.html)
;
; Script Function:
;	Extract files from MHT harchives
;
; ----------------------------------------------------------------------------

; Setup environment
#include <GUIConstants.au3>
#include <File.au3>
#include "Base64.au3"
opt("ExpandVarStrings", 1)
opt("GUIOnEventMode", 1)
global $name = "extractMHT"
global $version = "1.0"
global $title = "$name$ v$version$"
global $prompt = false
global $mht, $outdir, $filedir, $filename, $boundary, $firstpart, $infile
global $part, $parts, $newpart, $type, $encoding, $location, $content

; Check parameters
if $cmdline[0] = 0 then
	$prompt = true
else
	if $cmdline[1] == "/help" OR $cmdline[1] == "/h" OR $cmdline[1] == "/?" _
						OR $cmdline[1] == "-h" OR $cmdline[1] == "-?" then
		terminate("syntax")
	else
		if fileexists($cmdline[1]) then
			$mht = $cmdline[1]
		else
			terminate("syntax")
		endif
		if $cmdline[0] > 1 then
			$outdir = $cmdline[2]
		else
			$prompt = true
		endif
	endif
endif

; If no file passed, display GUI to select file and set options
if $prompt then
	; Create GUI
	GUICreate($title, 300, 115, -1, -1, -1, $WS_EX_ACCEPTFILES)
	$dropzone = GUICtrlCreateLabel("", 0, 0, 300, 115)
	GUICtrlCreateLabel("MHT archive to extract:", 5, 5, -1, 15)
	$filecont = GUICtrlCreateInput("", 5, 20, 260, 20)
	$filebut = GUICtrlCreateButton("...", 270, 20, 25, 20)
	GUICtrlCreateLabel("Target directory:", 5, 45, -1, 15)
	$dircont = GUICtrlCreateInput("", 5, 60, 260, 20)
	$dirbut = GUICtrlCreateButton("...", 270, 60, 25, 20)
	$ok = GUICtrlCreateButton("&OK", 55, 90, 80, 20)
	$cancel = GUICtrlCreateButton("&Cancel", 165, 90, 80, 20)

	; Set properties
	GUICtrlSetBkColor($dropzone, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetState($dropzone, $GUI_DISABLE)
	GUICtrlSetState($dropzone, $GUI_DROPACCEPTED)
	GUICtrlSetState($filecont, $GUI_FOCUS)
	GUICtrlSetState($ok, $GUI_DEFBUTTON)
	if $mht <> "" then
		GUICtrlSetData($filecont, $mht)
		$filedir = stringleft($mht, stringinstr($mht, '\', 0, -1)-1)
		$filename = stringtrimright(stringtrimleft($mht, stringlen($filedir)+1), 4)
		GUICtrlSetData($dircont, "$filedir$\$filename$")
		GUICtrlSetState($dircont, $GUI_FOCUS)
	endif

	; Set events
	GUISetOnEvent($GUI_EVENT_DROPPED, "GUI_Drop")
	GUICtrlSetOnEvent($filebut, "GUI_File")
	GUICtrlSetOnEvent($dirbut, "GUI_Directory")
	GUICtrlSetOnEvent($ok, "GUI_Ok")
	GUICtrlSetOnEvent($cancel, "GUI_Exit")
	GUISetOnEvent($GUI_EVENT_CLOSE, "GUI_Exit")

	; Display GUI and wait for action
	GUISetState(@SW_SHOW)
	$finishgui = 0
	while 1
		if $finishgui then exitloop
	wend
endif

; Set full output directory
$filedir = stringleft($mht, stringinstr($mht, '\', 0, -1)-1)
$filename = stringtrimright(stringtrimleft($mht, stringlen($filedir)+1), 4)
if $outdir = '/sub' then
	$outdir = "$filedir$\$filename$"
elseif stringmid($outdir, 2, 1) <> ":" then
	if stringleft($outdir, 1) == '\' then
		$outdir = stringleft($filedir, 2) & $outdir
	else
		$outdir = _PathFull($filedir & '\' & $outdir)
	endif
endif

; Determine boundry
_filereadtoarray($mht, $infile)
for $i = 1 to $infile[0]
	if stringinstr($infile[$i], "boundary=", 0) then
		$temp = stringtrimleft($infile[$i], stringinstr($infile[$i], "boundary=")+8)
		if stringleft($temp, 1) == '"' then
			$boundary = stringmid($temp, 2, stringinstr($temp, '"', 0, -1)-2)
		elseif stringinstr($temp, ';') then
			$boundary = stringleft($temp, stringinstr($temp, ';')-1)
		else
			$boundary = stringmid($temp, 2, stringinstr($temp, '"')-2)
		endif

	; Continue processing to count number of parts
	elseif stringinstr($infile[$i], $boundary) then
		if $parts == '' then $firstpart = $i + 1
		$parts += 1
	endif
next
$parts -= 1

; Verify boundary exists
if $boundary == '' then
	msgbox(48, $title, "Error: This does not appear to be a valid MHT file.@CRLF@No boundary could be detected.")
	exit
endif

; Begin processing MHT file
progresson($title, 'Extracting $filename$.mht', "", -1, -1, 16)
$part = 0
$newpart = 1
for $i = $firstpart to $infile[0]

	; Initialize variables
	if $newpart then
		$type = ""
		$encoding = ""
		$location = ""
		$content = ""
		$newpart = false
		$part += 1
	endif

	; Determine filetype
	if stringinstr($infile[$i], "Content-Type:", 0) then
		$temp = stringregexp($infile[$i], ":\s*([A-Za-z0-9/-]+)", 1)
		$type = $temp[0]

	; Determine encoding method
	elseif stringinstr($infile[$i], "Content-Transfer-Encoding:", 0) then
		$temp = stringregexp($infile[$i], ":\s*([A-Za-z0-9-]+)", 1)
		$encoding = $temp[0]

	; Determine filename
	elseif stringinstr($infile[$i], "Content-Location:", 0) then
		$temp = stringtrimleft($infile[$i], stringinstr($infile[$i], "Content-Location:")+17)
		$location = getFName($temp, $type)
		progressset(round($part/$parts, 2)*100, "Processing file $part$ of $parts$:@CRLF@$location$")

	; Decode and write out new file when new boundary reached
	elseif stringinstr($infile[$i], $boundary) then
		writeFile($encoding, $location, $content)
		$newpart = true

	; Read encoded file content into memory until new boundary reached
	elseif $type <> "" AND $encoding <> "" AND $location <> "" then
		if $encoding = "base64" AND $infile[$i] <> "" then
			$content = $content & $infile[$i]
		elseif $encoding <> "base64" then
			$content = $content & $infile[$i] & @CRLF
		endif
	endif
next
progressoff()
exit

; -------------------------- Begin Custom Functions ---------------------------

func terminate($status)
	; Display error message if file could not be extracted
	select
		; Display usage information and exit
		case $status == "syntax"
			$syntax = "Extract files from MHT web archives."
			$syntax = $syntax & @CRLF & "Usage:  " & @scriptname & " [/help] [filename [destination]]"
			$syntax = $syntax & @CRLF & @CRLF & "Supported Arguments:"
			$syntax = $syntax & @CRLF & "     /help" & @tab & @tab & "Display this help information"
			$syntax = $syntax & @CRLF & "     filename" & @tab & "Name of file to extract"
			$syntax = $syntax & @CRLF & "     destination" & @tab & "Directory to which to extract"
			$syntax = $syntax & @CRLF & @CRLF & "Passing /sub instead of a destination directory name instructs" & @CRLF & $title & " to extract to subdirectory named after the archive."
			$syntax = $syntax & @CRLF & @CRLF & "Example:"
			$syntax = $syntax & @CRLF & "     " & @scriptname & " c:\1\example.mht c:\test"
			$syntax = $syntax & @CRLF & @CRLF & "Running " & $title & " without any arguments will" & @CRLF & "prompt the user for the filename and destination directory."
			msgbox(48, $title, $syntax)
	endselect
	exit
endfunc

; Return the filename from the passed URL
func getFName($url, $type)
	local $ext, $temp

	; Determine file extension
	if stringinstr($type, "jpeg") then
		$ext = "jpg"
	else
		$ext = stringtrimleft($type, stringinstr($type, '/'))
	endif

	; If no filename specified, generate based on content-type
	if stringright($url, 1) == "/" then
		return unique("index", $ext)

	; Otherwise take directlry from URL
	else
		$temp = stringtrimleft($url, stringinstr($url, '/', 0, -1))
		$temp = stringregexp($temp, "(.*?\.\a*)", 1)
		if NOT @error AND @extended then
			$fname = stringleft($temp[0], stringinstr($temp[0], '.', 0, -1)-1)
			$fext = stringtrimleft($temp[0], stringinstr($temp[0], '.', 0, -1))
			return unique($fname, $fext)
		else
			return unique("unknown", $ext)
		endif
	endif
endfunc

; Ensure a unique filename is returned
func unique($fname, $ext)
	local $i
	if fileexists("$outdir$\$fname$.$ext$") then
		$i = 1
		while fileexists("$outdir$\$fname$$i$.$ext$")
			$i += 1
		wend
		return "$fname$$i$.$ext$"
	else
		return "$fname$.$ext$"
	endif
endfunc

; Write contents to file
func writeFile($encoding, $location, $content)
	if NOT fileexists($outdir) then dircreate($outdir)
	$outfile = fileopen("$outdir$\$location$", 2)

	; Decode file according to encoding type
	if $encoding = "base64" then
		;$content = B64Dec($content)
		$content = _Base64Decode($content)
	elseif $encoding = "quoted-printable" then
		$content = QPDec($content)
	endif

	; Write decoded file
	filewriteline($outfile, $content)
	fileclose($outfile)
endfunc

; Decode quoted-printable data
func QPDec($text)
	; Replace line terminators (RFC Rule 5)
	$text = stringregexpreplace($text, "=\N\n", "")

	; Strip malformed content from HTML pages (debugging)
	$text = stringreplace($text, "=EF=BB=BF", "")

	; Find all unique hex codes in text
	$codes = stringregexp($text, "=(\x{2})", 3)
	$codes = ArrayUnique($codes)

	; Convert each hex code to ASCII character and replace in text (RFC rule 1)
	for $i = 1 to $codes[0]
		$text = stringreplace($text, '=' & $codes[$i], chr(dec($codes[$i])))
	next
	return $text
endfunc

; Return unique aray
func ArrayUnique($arr)
	local $i
	local $seen = ""
	for $i = 0 to ubound($arr)-1
		if NOT stringinstr($seen, $arr[$i]) then $seen = $seen & $arr[$i] & "|"
	next
	return stringsplit($seen, '|')
endfunc


; ------------------------ Begin GUI Control Functions ------------------------

; Prompt user for file
func GUI_File()
	$mht = fileopendialog("Open file", "", "Select file (*.mht)", 1)
	if not @error then
		GUICtrlSetData($filecont, $mht)
		if GUICtrlRead($dircont) = "" then
			$filedir = stringleft($mht, stringinstr($mht, '\', 0, -1)-1)
			$filename = stringtrimright(stringtrimleft($mht, stringlen($filedir)+1), 4)
			GUICtrlSetData($dircont, "$filedir$\$filename$")
		endif
		GUICtrlSetState($ok, $GUI_FOCUS)
	endif
endfunc

; Prompt user for directory
func GUI_Directory()
	if fileexists(GUICtrlRead($dircont)) then
		$defdir = GUICtrlRead($dircont)
	elseif fileexists(GUICtrlRead($filecont)) then
		$defdir = stringleft(GUICtrlRead($filecont), stringinstr(GUICtrlRead($filecont), '\', 0, -1)-1)
	else
		$defdir = '';
	endif
	$outdir = fileselectfolder("Extract to", "", 3, $defdir)
	if not @error then
		GUICtrlSetData($dircont, $outdir)
	endif
endfunc

; Set file to extract and target directory, then exit
func GUI_Ok()
	$mht = GUICtrlRead($filecont)
	if fileexists($mht) then
		if GUICtrlRead($dircont) == "" then
			$outdir = '/sub'
		else
			$outdir = GUICtrlRead($dircont)
		endif
		GUIDelete()
		$finishgui = true
	else
		if $mht == '' then
			$mht = '';
		else
			$mht = $mht & " does not exist." & @CRLF;
		endif
		msgbox(48, $title, $mht & "Please select valid file.")
	endif
endfunc

; Process dropped files outside of file input box
func GUI_Drop()
	if fileexists(@GUI_DragFile) then
		$mht = @GUI_DragFile
		GUICtrlSetData($filecont, $mht)
		if GUICtrlRead($dircont) = "" then
			$filedir = stringleft($mht, stringinstr($mht, '\', 0, -1)-1)
			$filename = stringtrimright(stringtrimleft($mht, stringlen($filedir)+1), 4)
			GUICtrlSetData($dircont, "$filedir$\$filename$")
		endif
	endif
endfunc

; Exit if Cancel clicked or window closed
func GUI_Exit()
	exit
endfunc

