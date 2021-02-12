#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Francisca Carstens
 Date Created:   June 2010

 Script Function:
	Locate RapidStudio installdir and delete duplicate files in the Cliparts Directory.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <Array.au3>
#include <file.au3>
#include <GUIConstantsEx.au3>
#include <GuiButton.au3>
#include <StaticConstants.au3>
#include <ProgressConstants.au3>

Opt("TrayAutoPause",0)
Opt("TrayIconHide", 1)

Global $iMemo, $appath, $submitpath, $albumspath

;Declare variables for content update



_Main()

Func _Main()

	_RegRead()

	Local $theme = "replacethistextwiththemevariablefromcreatecontentupdate.au3" ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> (remove the underscore) "replacethistextwiththemevariablefromcreatecontentupdate._au3"
	Local $themePicDest = @TempDir & "\" & "themeimage.jpg", $updateEXE = "update.exe", $updateDest = @TempDir & "\" & $updateEXE
	Local $textBoxTop = 60, $textBoxLeft = 200, $textBoxWidth = 230, $butLeft = 350, $butTop = 210, $butWidth = 90, $butHeight = 30
	Local $gui = GUICreate("Update RapidStudio Content - " & $theme, 460, 250)
	FileInstall("GUI\images\gui_header.jpg", @TempDir & "\" & "gui_header.jpg",1)
	if FileExists($themePicDest) then FileDelete($themePicDest)
	if FileExists($updateDest) then FileDelete($updateDest)
	FileInstall("temp\themeimage.jpg", $themePicDest,1)
	GUICtrlCreatePic(@TempDir & "\" & "gui_header.jpg",0,0,460,33)
	GUICtrlCreatePic(@TempDir & "\" & "themeimage.jpg",0, 33, 186, 217)

	Local $box = GUICtrlCreateGroup("Content Update", 187, 40, 253, 160)
	Local $text = "Click 'Next' to update your RapidStudio Software with the " & $theme & " theme set."
	Local $textBox = GUICtrlCreateLabel($text, $textBoxLeft, $textBoxTop, $textBoxWidth, 100,  ($SS_LEFT))
	Local $textBox2 = GUICtrlCreateLabel("Extracting update file to temp directory...", $textBoxLeft, 100, $textBoxWidth, 30, ($SS_LEFT))
	Local $textBox3 = GUICtrlCreateLabel("Running update...", $textBoxLeft, 120, $textBoxWidth, 30, ($SS_LEFT))
	Local $textbox4 = GUICtrlCreateLabel("Initialising setup configuration...",  $textBoxLeft, 140, $textBoxWidth, 30, ($SS_LEFT))
	Local $textbox5 = GUICtrlCreateLabel("Applying patches and clean up...",  $textBoxLeft, 160, $textBoxWidth, 15, ($SS_LEFT))
	GUICtrlSetState($textBox2, $GUI_HIDE)
	GUICtrlSetState($textBox3, $GUI_HIDE)
	GUICtrlSetState($textBox4, $GUI_HIDE)
	GUICtrlSetState($textBox5, $GUI_HIDE)
	Local $butNext = GUICtrlCreateButton("Next", $butLeft, $butTop, $butWidth, $butHeight, $BS_DEFPUSHBUTTON)
	Local $butCancel = GUICtrlCreateButton("Cancel", $butLeft-100, $butTop, $butWidth, $butHeight)
	Local $chk = GUICtrlCreateCheckbox("Run RapidStudio now", 190, 205, 150, 50)
	GUICtrlSetState($chk, $GUI_HIDE + $GUI_CHECKED)
	Local $progressbar = GUICtrlCreateProgress($textBoxLeft, 180, 230, 15, $PBS_MARQUEE)
	_SendMessage(GUICtrlGetHandle(-1), $PBM_SETMARQUEE, True, 20) ; final parameter is update time in ms
	GUICtrlSetState($progressbar, $GUI_HIDE)


	GUISetState()
	While 1
		Switch GUIGetMsg()
				Case $GUI_EVENT_CLOSE, $butCancel
;~ 					If MsgBox(8196, "Cancel setup", "Are you sure you want to cancel this operation?") = 6 Then Exit
					Exit
		Case $butNext
			GUICtrlSetData($box, "Updating content")
				; Disable buttons while running update.
				GUICtrlSetState($butNext, $GUI_DISABLE)
				GUICtrlSetState($butCancel, $GUI_DISABLE)
				GUICtrlSetData($textBox,"Please be patient and DO NOT CLOSE this window.")
				; Start the progress bar
				GUICtrlSetState($progressbar, $GUI_SHOW)
;~ 				Sleep(2000)

				_CheckProcess ("AlbumMaker.exe","RapidStudio")
				_KillProcess ("AlbumFTPUploader.exe")

				GUICtrlSetState($textBox2, $GUI_SHOW)
				;Include the theme exe (content update) from Mphoto with the compiled exe and dumps it in the user's temp directory.
				FileInstall("temp\update.exe", $updateDest)
;~ 				Sleep(2000) ;sleep for 2 seconds

				GUICtrlSetState($textBox3, $GUI_SHOW)
;~ 				Sleep(2000);~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

				;Run the RapidStudio content update exe and pause script execution until the update is finished.
				Run($updateDest, "", @SW_MAXIMIZE)
					While ProcessExists("update.exe")
						if ProcessExists ("UpdateSetup.exe") Then
						GUICtrlSetState($textBox4, $GUI_SHOW)
							ExitLoop
						EndIf
					WEnd
				ProcessWaitClose ("update.exe")
				Sleep(2000)

				GUICtrlSetState($textBox5, $GUI_SHOW)

				_RS_Patch ()

				FileDelete($updateDest)
				FileDelete($themePicDest)

				Sleep(2000)
			ExitLoop
		EndSwitch
	WEnd



GUICtrlDelete($progressbar)
GUICtrlDelete($textbox2)
GUICtrlDelete($textbox3)
GUICtrlDelete($textbox4)
GUICtrlDelete($textbox5)
GUICtrlSetData($butNext,"Finish")
GUICtrlSetState($butNext, $GUI_ENABLE)
GUICtrlSetData($box,"Update Complete")
$text = "RapidStudio has been successfully updated with the new content." & @CRLF & @CRLF & "You will now be able to choose from the new album types or sample albums when creating a new album in RapidStudio."
GUICtrlSetData($textBox,$text)
GUICtrlSetState($chk, $GUI_SHOW)

	GUISetState()
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				Exit
			Case $butNext
				If GUICtrlRead($chk) = 4 Then Exit
				Run($appath & "\MPR500 Pro 5\AlbumMaker.exe")
				Exit
		EndSwitch
	WEnd


EndFunc ;==>_Main
Exit

#Region Functions
Func _RegRead()
RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\RapidStudio_RapidStudio","")
If @Error > 0 Then
   ;Key does not exist
   	MsgBox (16, "Warning", "RapidStudio is not installed on this computer." & @CRLF & "Please call support on 011 225 0522 if you require assistance.")
Else
   ;Key does exist
	$appath = RegRead ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\RapidStudio_RapidStudio", "AppFolder")
;~ 	   	MsgBox (4096, "Sucess", "RapidStudio is installed in the following directory:" & @CRLF & $appath) ; for testing
EndIf
EndFunc   ;==> _RegRead

Func _CheckProcess ($Process,$App)
	While ProcessExists($Process)
		if MsgBox(270389,"Error","Please exit "&$App&" and try again.") = 2 Then
			if MsgBox(8196,"Cancel update", "Are you sure you want to cancel this update?") = 6 then Exit
		EndIf
	WEnd
EndFunc   ;==> _CheckAlbumMakerProcess

Func _KillProcess ($Process)
	If ProcessExists($Process) Then
	ProcessClose($Process)
	ProcessWaitClose ($Process)
	EndIf
EndFunc   ;==> _KillProcess

; Copy script from latest Patch
;~ Func _RS_Patch ()
Func _RS_Patch()
	Local $FolderName, $Target_Folder, $Array, $Array2

	; Detect BASE_FOLDER and BASE_SUBMIT_FOLDER from AlbumMaker.ini
	FileCopy($appath & "\MPR500 Pro 5\AlbumMaker.ini", @TempDir & "\AlbumMaker.ini")
	_FileWriteToLine(@TempDir & "\AlbumMaker.ini", 1, "[MYSECTION]", 0)
	$submitpath = IniRead(@TempDir & "\AlbumMaker.ini", "MYSECTION", "BASE_SUBMIT_FOLDER", "C:\RapidStudio_Submitted_Orders")
	$albumspath = IniRead(@TempDir & "\AlbumMaker.ini", "MYSECTION", "BASE_FOLDER", "C:\MPR500_Resources")
	FileDelete(@TempDir & "\AlbumMaker.ini")

	;find and delete thumbs.db
	FileSetAttrib($appath &"\MPR500 Pro 5\*.*", "-RHS",1)
	$FolderName = $appath &"\MPR500 Pro 5"
	ScanFolder($FolderName)

	;Install help boxes
	FileInstall("GUI\Help submit my files.exe", $submitpath & "\")

	;Clear readonly attributes in installation directory as well as albums folders
	FileSetAttrib($appath &"\MPR500 Pro 5\*.*", "-RHS",1)
	FileSetAttrib($albumspath & "\*.*", "-RHS",1)
	FileSetAttrib($submitpath & "\*.*", "-RHS",1)

	;Install FTP Uploader shortcuts
	FileCreateShortcut ($appath & "\MPR500 Pro 5\AlbumFTPUploader.exe", $submitpath & "\AlbumFTPUploader.lnk")
	FileCreateShortcut ($appath & "\MPR500 Pro 5\AlbumFTPUploader.exe", @StartMenuCommonDir & "\Programs\RapidStudio\AlbumFTPUploader.lnk")

	;Update FTP Time-out
	IniWrite($appath & "\MPR500 Pro 5\FTPCore.ini","FTPAgent","DefaultNoConnectionTimeout","15")
	IniWrite($appath & "\MPR500 Pro 5\FTPCore.ini","FTPAgent","DefaultTimeout","15")

	;Delete duplicate items in cliparts folders
	$Target_Folder = $appath & "\MPR500 Pro 5\Cliparts"
	$Array = _FileListToArray_Recursive($Target_Folder, "", "*", "", 1, 2, True)
	;~ _ArrayDisplay($Array) ; for testing

	; expand to 2-dimension array with filename, fullpath
	dim $Array2[$Array[0] + 1][2]
	$Array2[0][0] = $Array[0]
	For $x = 1 to $Array[0]
		$Array2[$x][0] = StringTrimLeft($Array[$x],StringInStr($Array[$x], "\", 0, -1))
		$Array2[$x][1] = $Array[$x]
	Next
	;~ _ArrayDisplay($Array2) ; for testing

	; sort by filename
	_ArraySort($Array2, 0, 1)
	;~ _ArrayDisplay($Array2) ; for testing

	; delete duplicates
	$x = 2
	While $x <= $Array2[0][0]
		If $Array2[$x][0] = $Array2[$x -1][0] Then
		   If FileDelete($Array2[$x][1]) Then
	;~ 										ToolTip("Deleting file: " & $Array2[$x][1]) ; for testing
				_ArrayDelete($Array2, $x)
				$Array2[0][0] -= 1
		   Else
			   MsgBox(1,"", "Unable to delete file: " & $Array2[$x][1])
			   ExitLoop
		   EndIf
		Else
			$x += 1
		EndIf
	WEnd
EndFunc ;==> _RS_Patch

Func _FileListToArray_Recursive($sPath, $sExcludeFolderList = "", $sIncludeList = "*", $sExcludeList = "", $iReturnType = 0, $iReturnFormat = 0, $bRecursive = False)
    ; Recursive version of _FileListToArray() from thread #96952

	Local $sRet = "", $sReturnFormat = ""

    ; Edit include path (strip trailing slashes, and append single slash)
    $sPath = StringRegExpReplace($sPath, "[\\/]+\z", "") & "\"
    If Not FileExists($sPath) Then Return SetError(1, 1, "")

    ; Edit exclude folders list
    If $sExcludeFolderList Then
        ; Strip leading/trailing spaces and semi-colons, any adjacent semi-colons, and spaces surrounding semi-colons
        $sExcludeFolderList = StringRegExpReplace(StringRegExpReplace($sExcludeFolderList, "(\s*;\s*)+", ";"), "\A;|;\z", "")
        ; Convert to Regular Expression, step 1: Wrap brackets around . and $ (what other characters needed?)
        $sExcludeFolderList = StringRegExpReplace($sExcludeFolderList, '[.$]', '\[\0\]')
        ; Convert to Regular Expression, step 2: Convert '?' to '.', and '*' to '.*?'
        $sExcludeFolderList = StringReplace(StringReplace($sExcludeFolderList, "?", "."), "*", ".*?")
        ; Convert to Regular Expression, step 3; case-insensitive, convert ';' to '|', match from first char, terminate strings
        $sExcludeFolderList = "(?i)\A(?!" & StringReplace($sExcludeFolderList, ";", "$|")  & "$)"
    EndIf

    ; Edit include files list
    If $sIncludeList ="*" Then
        $sIncludeList = ""
    Else
        If StringRegExp($sIncludeList, "[\\/ :> <\|]|(?s)\A\s*\z") Then Return SetError(2, 2, "")
        ; Strip leading/trailing spaces and semi-colons, any adjacent semi-colons, and spaces surrounding semi-colons
        $sIncludeList = StringRegExpReplace(StringRegExpReplace($sIncludeList, "(\s*;\s*)+", ";"), "\A;|;\z", "")
        ; Convert to Regular Expression, step 1: Wrap brackets around . and $ (what other characters needed?)
        $sIncludeList = StringRegExpReplace($sIncludeList, '[.$]', '\[\0\]')
        ; Convert to Regular Expression, step 2: Convert '?' to '.', and '*' to '.*?'
        $sIncludeList = StringReplace(StringReplace($sIncludeList, "?", "."), "*", ".*?")
        ; Convert to Regular Expression, step 3; case-insensitive, convert ';' to '|', match from first char, terminate strings
        $sIncludeList = "(?i)\A(" & StringReplace($sIncludeList, ";", "$|")  & "$)"
    EndIf

    ; Edit exclude files list
    If $sExcludeList Then
        ; Strip leading/trailing spaces and semi-colons, any adjacent semi-colons, and spaces surrounding semi-colons
        $sExcludeList = StringRegExpReplace(StringRegExpReplace($sExcludeList, "(\s*;\s*)+", ";"), "\A;|;\z", "")
        ; Convert to Regular Expression, step 1: Wrap brackets around . and $ (what other characters needed?)
        $sExcludeList = StringRegExpReplace($sExcludeList, '[.$]', '\[\0\]')
        ; Convert to Regular Expression, step 2: Convert '?' to '.', and '*' to '.*?'
        $sExcludeList = StringReplace(StringReplace($sExcludeList, "?", "."), "*", ".*?")
        ; Convert to Regular Expression, step 3; case-insensitive, convert ';' to '|', match from first char, terminate strings
        $sExcludeList = "(?i)\A(?!" & StringReplace($sExcludeList, ";", "$|")  & "$)"
    EndIf

;   MsgBox(1,"Masks","File include: " & $sIncludeList & @CRLF & "File exclude: " & $ExcludeList & @CRLF _
;           & "Dir include : " & $FolderInclude & @CRLF & "Dir exclude : " & $ExcludeFolderList)

    If Not ($iReturnType = 0 Or $iReturnType = 1 Or $iReturnType = 2) Then Return SetError(3, 3, "")

    Local $sOrigPathLen = StringLen($sPath), $aQueue[64] = [1,$sPath], $iQMax = 63, $WorkFolder, $search, $file
    While $aQueue[0]
        $WorkFolder = $aQueue[$aQueue[0]]
        $aQueue[0] -= 1
        $search = FileFindFirstFile($WorkFolder & "*")
        If @error Then ContinueLoop
        Switch $iReturnFormat
            Case 1 ; relative path
                $sReturnFormat = StringTrimLeft($WorkFolder, $sOrigPathLen)
            Case 2 ; full path
                $sReturnFormat = $WorkFolder
        EndSwitch
        While 1
            $file = FileFindNextFile($search)
            If @error Then ExitLoop
            If @extended Then ; Folder
                If $sExcludeFolderList And Not StringRegExp($file, $sExcludeFolderList) Then ContinueLoop
                If $bRecursive Then
                    If $aQueue[0] = $iQMax Then
                        $iQMax += 128
                        ReDim $aQueue[$iQMax + 1]
                    EndIf
                    $aQueue[0] += 1
                    $aQueue[$aQueue[0]] = $WorkFolder & $file & "\"
                EndIf
                If $iReturnType = 1 Then ContinueLoop
            Else ; File
                If $iReturnType = 2 Then ContinueLoop
            EndIf
            If $sIncludeList And Not StringRegExp($file, $sIncludeList) Then ContinueLoop
            If $sExcludeList And Not StringRegExp($file, $sExcludeList) Then ContinueLoop
            $sRet &= $sReturnFormat & $file & "|"
        WEnd
        FileClose($search)
    WEnd
    If Not $sRet Then Return SetError(4, 4, "")
    Return StringSplit(StringTrimRight($sRet, 1), "|")
EndFunc   ;==>_FileListToArray_Recursive

Func ScanFolder($SourceFolder)
	Local $Search
	Local $File
	Local $FileAttributes
	Local $FullFilePath

	$Search = FileFindFirstFile($SourceFolder & "\*.*")

	While 1
		If $Search = -1 Then
			ExitLoop
		EndIf

		$File = FileFindNextFile($Search)
		If @error Then ExitLoop

		$FullFilePath = $SourceFolder & "\" & $File
		$FileAttributes = FileGetAttrib($FullFilePath)
		if $File = "thumbs.db" then FileDelete($FullFilePath)

		If StringInStr($FileAttributes,"D") Then ScanFolder($FullFilePath) ;Resursive

	WEnd

	FileClose($Search)
EndFunc ;==> ScanFolder
#EndRegion
