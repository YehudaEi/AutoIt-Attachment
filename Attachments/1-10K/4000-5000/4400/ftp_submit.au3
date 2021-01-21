; ----------------------------------------------------------------------------
;
; Author:			Jared Breland <jbreland@legroom.net>
; Script Version:	1.0
; AutoIt Version:	3.1.1.68-beta
;
; Script Function:
;	Automate FTP submission
;
; ----------------------------------------------------------------------------

; -----------------
; Setup environment
; -----------------
#notrayicon
#include <FTP_passive.au3>
#include <GUIConstants.au3>
#include <GUIListView.au3>
$version = "1.0"
$ftpserver = 'ftp.domain.com'
$ftpuser = 'username'
$ftppass = 'password'
$ftppassive = 1
$ftpdir = '/incoming/'
$title = "FTP Submission v" & $version
$url = '                                  '
$height = round(@desktopheight/4)
dim $files = 0, $size = 0, $exitcode = 0, $submitfiles = 0


; ----------------------------------
; Display GUI
; ----------------------------------
; build GUI
GUICreate($title, 400, 180, -1, -1, -1)
GUICtrlCreateLabel("For more information, please visit:", 5, 5, 160, 15)
$address = GuiCtrlCreateLabel($url, 170, 5, 200, 15)
GUICtrlCreateLabel('Selected files for upload:', 5, 25, 120, 15)
$upload = GUICtrlCreateListView("File Name", 5, 40, 390, 75, $LVS_NOCOLUMNHEADER)
$add = GUICtrlCreateButton("&Add Files", 5, 125, 80, 20)
$clear = GUICtrlCreateButton("&Clear Files", 95, 125, 80, 20)
GUICtrlCreateGroup("", 190, 118, 110, 52)
$fstatus = GUICtrlCreateLabel("", 195, 130, 105, 40)
$sstatus = GUICtrlCreateLabel("", 195, 150, 105, 40)
GUICtrlCreateGroup ("",-99,-99,1,1)
$submit = GUICtrlCreateButton("&Submit", 315, 125, 80, 20)
$cancel = GUICtrlCreateButton("Ca&ncel", 315, 150, 80, 20)

; enable context menu
$context = GUICtrlCreateContextMenu($upload)
$remove = GUICtrlCreateMenuItem("&Remove File", $context)
GUICtrlCreateMenuItem("", $context)
$submit2 = GUICtrlCreateMenuItem("&Submit Files", $context)

; set GUI properties
GUICtrlSetFont($address, -1, -1, 4)
GUICtrlSetColor($address, 0x0000ff)
GUICtrlSetCursor($address, 0)
_GUICtrlListViewSetColumnWidth($upload, 0, 373)
GUICtrlSetState($fstatus, $GUI_HIDE)
GUICtrlSetState($sstatus, $GUI_HIDE)
GUICtrlSetState($add, $GUI_FOCUS)
GUICtrlSetState($add, $GUI_DEFBUTTON)
GUISetState(@SW_SHOW)

; set GUI actions
while 1
	$action = GUIGetMsg()
	select
		; add new file(s) to list
		case $action = $add
			local $newfile = 0
			$newfile = stringsplit(fileopendialog("Add files", "", "All (*.*)", 5), '|')
			if $newfile[0] = 1 then
				if $newfile[1] = "" then
					continueloop
				else
					if NOT _ListViewAdded($newfile[1]) then
						GUICtrlCreateListViewItem($newfile[1], $upload)
						$files += 1
						$size += filegetsize($newfile[1])
					endif
				endif
			elseif $newfile[0] > 1 then
				for $i = 2 to $newfile[0]
					if NOT _ListViewAdded($newfile[1] & '\' & $newfile[$i]) then
						GUICtrlCreateListViewItem($newfile[1] & '\' & $newfile[$i], $upload)
						$files += 1
						$size += filegetsize($newfile[1] & '\' & $newfile[$i])
					endif
				next
			endif
			_UpdateStats($files, $size)

		; remove individual file(s) from list
		case $action = $remove
			$deleted = _GUICtrlListViewGetSelectedIndices($upload, 1)
			if isarray($deleted) then
				for $i = 1 to $deleted[0]
					$files -= 1
					$size -= filegetsize(ControlListView($title, "", $upload, "GetText", $i, 0))
					_GUICtrlListViewDeleteItem($upload, $i)
				next
			endif
			_UpdateStats($files, $size)

		; remove all files from list
		case $action = $clear
			_GUICtrlListViewDeleteAllItems($upload)
			$files = 0
			$size = 0
			GUICtrlSetState($fstatus, $GUI_HIDE)
			GUICtrlSetState($sstatus, $GUI_HIDE)

		; launch website
		case $action = $address
			if @OSTYPE = "WIN32_NT" then
				run(@ComSpec & ' /c start "FTPsubmit" ' & $url, '', @SW_HIDE)
			elseif @OSTYPE = "WIN32_WINDOWS" then
				run(@ComSpec & ' /c start ' & $url, '', @SW_HIDE)
			endif

		; begin uploading files
		case $action = $submit OR $action = $submit2
			if ControlListView($title, "", $upload, "GetItemCount") = 0 then
				msgbox(48, $title, "No files have been selected.")
			else
				; rename title to enable later access to ListView
				winsettitle($title, "", "ListView")
				GUISetState(@SW_HIDE)
				exitloop
			endif

		; quit program
		case $action = $GUI_EVENT_CLOSE OR $action = $cancel
			exit
	endselect
wend


; --------------------------
; Upload files and finish up
; --------------------------
; upload each file
progresson($title, "FTP upload progress", "Uploading ", -1, $height, 16)
for $i = 0 to ControlListView("ListView", "", $upload, "GetItemCount") - 1
	$fname = ControlListView("ListView", "", $upload, "GetText", $i, 0)
	progressset(round(($i+1)/ControlListView("ListView", "", $upload, "GetItemCount"), 2)*100, "Uploading " & stringtrimleft($fname, stringinstr($fname, '\', 0, -1)))
	if NOT _UploadFile($fname) then $exitcode = 5
next

; exit program
progressoff()
if $exitcode = 5 then
	msgbox(48, $title, "FTP submission failed.")
else
	msgbox(64, $title, "FTP submission was successful.")
endif
exit $exitcode


; -------------------------- Begin Custom Functions ---------------------------


; ----------------------------------------------------
; Determine if file has already been added
; ----------------------------------------------------
func _ListViewAdded($item)
	for $i = 0 to ControlListView($title, "", $upload, "GetItemCount") - 1
		if $item = ControlListView($title, "", $upload, "GetText", $i, 0) then return 1
	next
	return 0
endfunc


; --------------------------------------
; Update the file statistics
; --------------------------------------
func _UpdateStats($count, $sum)
	local $dispsize
	GUICtrlSetData($fstatus, "Total files: " & $count)
	if $sum > 1048576 then
		$dispsize = round($sum/1048576, 1) & " MB"
	else
		$dispsize = round($sum/1024, 1) & " KB"
	endif
	GUICtrlSetData($sstatus, "Total size: " & $dispsize)
	GUICtrlSetState($fstatus, $GUI_SHOW)
	GUICtrlSetState($sstatus, $GUI_SHOW)
endfunc


; --------------------------------------
; Upload files to FTP server
; --------------------------------------
func _UploadFile($file)
	local $ftpstatus
	$ftpopen = _FTPOpen('MyFTP Control')
	$ftpconn = _FTPConnect($ftpopen, $ftpserver, $ftpuser, $ftppass, $ftppassive)
	if $ftpconn == 13369352 then 
		$ftpput = _FtpPutFile($ftpconn, $file, $ftpdir & stringtrimleft($file, stringinstr($file, '\', 0, -1)))
		if $ftpput <> 0 then $ftpstatus = 1
	endif
	_FTPClose($ftpopen)
	return $ftpstatus
endfunc
