#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_outfile_type=a3x
#AutoIt3Wrapper_outfile=FTP Explorer.a3x
#AutoIt3Wrapper_Compression=4
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <ButtonConstants.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <array.au3>
#include <file.au3>
#include <GuiImageList.au3>
#include <GUIListView.au3>
#include <ListViewConstants.au3>
#include <EditConstants.au3>
#include <FTPEx.au3>
#include <GuiMenu.au3>
#include <Guiedit.au3>
#Region ### START Koda GUI section ### Form=d:\autoit\my projects\ftp explorer project\gui 2.kxf
Global Const $tagSHFILEINFO = "dword hIcon; int iIcon; DWORD dwAttributes; CHAR szDisplayName[255]; CHAR szTypeName[80];"
Global Const $SHGFI_USEFILEATTRIBUTES = 0x10, $SHGFI_SYSICONINDEX = 0x4000, $FILE_ATTRIBUTE_NORMAL = 0x80, $SHGFI_SMALLICON = 0x1, $SHGFI_LARGEICON = 0x0
Global Const $FOLDER_ICON_INDEX = _GUIImageList_GetFileIconIndex(@SystemDir, 0, 1)
Global Const $NOICON_ICON_INDEX = _GUIImageList_GetFileIconIndex("nb lgl", 0, 0)
Global $localCurrentDir[1], $FtpCurrentDir[1], $open, $conn, $queue_array[1], $ftpstatus = 'dis'
Global $Form1 = GUICreate("FTP Explorer", 899, 700)
$MenuItem2 = GUICtrlCreateMenu("&File")
$MenuItem1 = GUICtrlCreateMenuItem("Connect", $MenuItem2)
$MenuItem3 = GUICtrlCreateMenuItem("Disconnect", $MenuItem2)
$MenuItem4 = GUICtrlCreateMenuItem("Exit", $MenuItem2)
$Help = GUICtrlCreateMenu("&Help")
$MenuItem5 = GUICtrlCreateMenuItem("How To Use", $Help)
$MenuItem6 = GUICtrlCreateMenuItem("About", $Help)

Global $Local_List = GUICtrlCreateListView("File|Size", 8, 24, 433, 325, $LVS_SHOWSELALWAYS)
Global $FTP_List = GUICtrlCreateListView("File|Size", 456, 24, 433, 325, $LVS_SHOWSELALWAYS)
Global $Queue_List = GUICtrlCreateListView("Name|Target", 8, 355, 433, 201, $LVS_SHOWSELALWAYS)
Global $Status_List = GUICtrlCreateEdit("", 456, 355, 433, 201, BitOR($ES_WANTRETURN, $WS_VSCROLL, $WS_HSCROLL, $ES_AUTOVSCROLL, $ES_AUTOHSCROLL))
$Current_Local = GUICtrlCreateLabel("Current Directory :", 12, 5, 425, 17)
$Current_FTP = GUICtrlCreateLabel("Current Directory :", 457, 5, 425, 17)
$Button1 = GUICtrlCreateButton("Clear Queue", 305, 645, 116, 21, 0)
$Button2 = GUICtrlCreateButton("Transfer Queue", 470, 645, 116, 21, 0)
$Progress1 = GUICtrlCreateProgress(48, 568, 801, 17)
$lb_FileName = GUICtrlCreateLabel("label filename", 52, 600, 300, 17)
$lb_speed = GUICtrlCreateLabel("label speed", 420, 600, 163, 17)
$lb_size = GUICtrlCreateLabel("label size", 772, 600, 163, 17)
_GUICtrlListView_SetImageList($Local_List, _GUIImageList_GetSystemImageList(), 1)
_GUICtrlListView_SetImageList($FTP_List, _GUIImageList_GetSystemImageList(), 1)
_GUICtrlListView_SetImageList($Queue_List, _GUIImageList_GetSystemImageList(), 1)
Global $hStatus_List = GUICtrlGetHandle($Status_List)
Global $hQueue_list = GUICtrlGetHandle($Queue_List)
Global $hLocal_List = GUICtrlGetHandle($Local_List)
Global $hFTP_List = GUICtrlGetHandle($FTP_List)
_GUICtrlListView_SetColumnWidth($hQueue_list, 0, 217)
_GUICtrlListView_SetColumnWidth($hQueue_list, 1, 212)
_GUICtrlListView_SetColumnWidth($hFTP_List, 0, 354)
_GUICtrlListView_SetColumnWidth($hFTP_List, 1, 75)
_GUICtrlListView_SetColumnWidth($hLocal_List, 0, 354)
_GUICtrlListView_SetColumnWidth($hLocal_List, 1, 75)
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
GUISetState(@SW_SHOW)
Dim $past_history = 'ftp:/gatekeeper.dec.com/|ftp://ftp.x.org/|ftp://ftp.ncsa.uiuc.edu/'

_Home()

#EndRegion ### END Koda GUI section ###
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			_FTP_Close($open)
			Exit
		Case $MenuItem4 ;exit
			_FTP_Close($open)
			Exit
		Case $MenuItem1 ;connect
			$theaddress = _GUI_connectftp($past_history)
		Case $MenuItem3 ;disconnect
			_FTP_Close($open)
			_check_status()
			_GUICtrlEdit_AppendText($hStatus_List, 'Disconnected.. ' & @CRLF)
			_GUICtrlListView_DeleteAllItems($hFTP_List)
			$ftpstatus = 'dis'
			Global $FtpCurrentDir[1]
			GUICtrlSetData($Current_FTP, 'Current Directory : ')
		Case $Button2
			_Transfer($queue_array, True)
		Case $Button1
			Dim $queue_array[1]
			_GUICtrlListView_DeleteAllItems($hQueue_list)
	EndSwitch
WEnd


;Queue Functions
Func _Transfer(ByRef $a_items, $queue = False); True=Add to queue, False=Transfer files right now.
	Local $count, $i, $split, $last, $time, $timer
	$count = UBound($a_items) - 1
	For $i = 1 To $count
		$split = StringSplit($a_items[1], ';')
		;_ArrayDisplay($split)
		Select
			Case $split[1] = 'upload'
				If $split[2] = 'DIR' Then

					_FTP_DirCreate($conn, $split[5] & '/' & $split[4])
					_FTP_DirPutContents2($conn, $split[3] & '\' & $split[4], $split[5] & '/' & $split[4], 1)
				Else
					_FTP_ProgressUpload2($conn, $split[3] & '\' & $split[4], $split[5] & '/' & $split[4], '_progressupdate')
					;_FTP_FilePut($conn, $split[3] & '\' & $split[4], $split[5] & '/' & $split[4])
				EndIf
			Case $split[1] = 'download'
				If $split[2] = 'DIR' Then
					$timer = TimerInit()
					_FTP_DirDownload($conn, $split[5], $split[4], $split[3])
					$time = TimerDiff($timer)
					;	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $time = ' & $time & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
					_FTP_DirSetCurrent($conn, $split[5])
				Else
					_FTP_ProgressDownload2($conn, $split[3] & '\' & $split[4], $split[5] & '/' & $split[4], '_progressupdate')
					;_FTP_FileGet($conn, $split[5] & '/' & $split[4], $split[3] & '\' & $split[4])
				EndIf
		EndSelect
		_ArrayDelete($a_items, 1)
		If $queue = True Then _GUICtrlListView_DeleteItem($hQueue_list, 0)
	Next
	_FTP_DirSetCurrent($conn, $last)
	_FtpRefresh()
	_LocalRefresh()
EndFunc   ;==>_Transfer

Func _Queueupload($queue = False)
	Local $selectedlocal, $i, $text, $lcur, $item, $qitem, $ftploc, $at_items[1]
	$ftploc = _FTP_DirGetCurrent($conn)
	If $ftpstatus = 'dis' Then
		ConsoleWrite('No connected' & @LF)
		Return
	EndIf
	If UBound($localCurrentDir) > 2 Then
		$lcur = _LocalGetCurrent() & '\'
	Else
		$lcur = _LocalGetCurrent()
	EndIf
	$selectedlocal = _GUICtrlListView_GetSelectedIndices($hLocal_List, True)
	For $i = 1 To $selectedlocal[0]
		$qitem = 'upload'
		$text = _GUICtrlListView_GetItemText($hLocal_List, $selectedlocal[$i], 0)
		$type = _GUICtrlListView_GetItemText($hLocal_List, $selectedlocal[$i], 1)
		If $type = 'DIR' Then
			$qitem = $qitem & ';' & 'DIR;' & $lcur & ';' & $text & ';' & $ftploc
			If $queue = True Then
				$item = _GUICtrlListView_AddItem($hQueue_list, $lcur & $text, $FOLDER_ICON_INDEX)
				_GUICtrlListView_AddSubItem($hQueue_list, $item, $ftploc, 1)
			EndIf
		Else
			$qitem = $qitem & ';' & 'file;' & $lcur & ';' & $text & ';' & $ftploc
			If $queue = True Then
				$item = _GUICtrlListView_AddItem($hQueue_list, $lcur & $text, _GUICtrlListView_GetItemImage($hLocal_List, $selectedlocal[$i]))
				_GUICtrlListView_AddSubItem($hQueue_list, $item, $ftploc, 1)
			EndIf
		EndIf
		If $queue = True Then
			_ArrayAdd($queue_array, $qitem)
		Else
			_ArrayAdd($at_items, $qitem)
		EndIf
	Next
	If $queue = False Then _Transfer($at_items)
	;_ArrayDisplay($queue_array)
EndFunc   ;==>_Queueupload

Func _Queuedownload($queue = False)
	Local $selectedftp, $i, $text, $ftpcur, $item, $qitem, $at_items[1]
	If UBound($FtpCurrentDir) = 1 Then
		$ftpcur = _FTP_DirGetCurrent($conn)
	Else
		$ftpcur = _FTP_DirGetCurrent($conn) & '/'
	EndIf
	If _LocalGetCurrent() = 'My Computer' Then
		ConsoleWrite('My Computer' & @LF)
		Return
	EndIf
	;If UBound($FtpCurrentDir)
	$selectedftp = _GUICtrlListView_GetSelectedIndices($hFTP_List, True)
	For $i = 1 To $selectedftp[0]
		$qitem = 'download'
		$text = _GUICtrlListView_GetItemText($hFTP_List, $selectedftp[$i], 0)
		$type = _GUICtrlListView_GetItemText($hFTP_List, $selectedftp[$i], 1)
		If $type = 'DIR' Then
			$qitem = $qitem & ';' & 'DIR;' & _LocalGetCurrent() & ';' & $text & ';' & $ftpcur
			If $queue = True Then
				$item = _GUICtrlListView_AddItem($hQueue_list, $ftpcur & $text, $FOLDER_ICON_INDEX)
				_GUICtrlListView_AddSubItem($hQueue_list, $item, _LocalGetCurrent(), 1)
			EndIf
		Else
			$qitem = $qitem & ';' & 'file;' & _LocalGetCurrent() & ';' & $text & ';' & $ftpcur
			If $queue = True Then
				$item = _GUICtrlListView_AddItem($hQueue_list, $ftpcur & $text, _GUICtrlListView_GetItemImage($hFTP_List, $selectedftp[$i]))
				_GUICtrlListView_AddSubItem($hQueue_list, $item, _LocalGetCurrent(), 1)
			EndIf
		EndIf
		If $queue = True Then
			_ArrayAdd($queue_array, $qitem)
		Else
			_ArrayAdd($at_items, $qitem)
		EndIf
		ConsoleWrite($text & @LF)
	Next
	If $queue = False Then _Transfer($at_items)
	;_ArrayDisplay($queue_array)
	;_ArrayDisplay($selectedlocal)
EndFunc   ;==>_Queuedownload

Func _check_status()
	If _GUICtrlEdit_GetTextLen($hStatus_List) > 25000 Then
		_GUICtrlEdit_SetSel($hStatus_List, 0, 10000)
		_GUICtrlEdit_ReplaceSel($hStatus_List, '')
	EndIf
EndFunc   ;==>_check_status


;Ftp Functions...........................................
Func _FTP_DirPutContents2($l_InternetSession, $s_LocalFolder, $s_RemoteFolder, $b_RecursivePut)
	If StringRight($s_LocalFolder, 1) == "\" Then $s_LocalFolder = StringTrimRight($s_LocalFolder, 1)
	; Shows the filenames of all files in the current directory.
	$Search = FileFindFirstFile($s_LocalFolder & "\*.*")
	; Check if the search was successful
	If $Search = -1 Then Return SetError(1, 0, 0)
	While 1
		$File = FileFindNextFile($Search)
		If @error Then ExitLoop
		If StringInStr(FileGetAttrib($s_LocalFolder & "\" & $File), "D") Then
			_FTP_DirCreate($l_InternetSession, $s_RemoteFolder & "/" & $File)
			If $b_RecursivePut Then
				_FTP_DirPutContents2($l_InternetSession, $s_LocalFolder & "\" & $File, $s_RemoteFolder & "/" & $File, $b_RecursivePut)
			EndIf
		Else
			_FTP_ProgressUpload2($l_InternetSession, $s_LocalFolder & "\" & $File, $s_RemoteFolder & "/" & $File, '_progressupdate')
		EndIf
	WEnd
	; Close the search handle
	FileClose($Search)
	Return 1
EndFunc   ;==>_FTP_DirPutContents2

Func _progressupdate($data)
	Local $size
	If $data[0] >= $data[1] Then
		GUICtrlSetData($Progress1, 0)
		GUICtrlSetData($lb_FileName, '')
		GUICtrlSetData($lb_size, '')
		GUICtrlSetData($lb_speed, '')
		Return 1
	EndIf
	If GUICtrlRead($lb_FileName) <> $data[4] Then
		GUICtrlSetData($lb_FileName, $data[4])
	EndIf
	$size = _bytes($data[0]) & '/' & _bytes($data[1])
	If GUICtrlRead($lb_size) <> $size Then
		GUICtrlSetData($lb_size, $size)
	EndIf
	;If GUICtrlRead($lb_speed)<>$data[3] Then
	GUICtrlSetData($lb_speed, _bytes($data[3]) & "/sec")
	;EndIf
	GUICtrlSetData($Progress1, $data[2])
	Return 1
EndFunc   ;==>_progressupdate

Func _FTP_ProgressDownload2($l_FTPSession, $s_LocalFile, $s_RemoteFile, $FunctionToCall = "")
	Local $ai_ftpopenfile, $ai_InternetCloseHandle, $fhandle, $glen, $last, $x, $parts, $buffer, $ai_FTPread, $result[5], $out, $i, $bigsmall, $Timer_1
	;Local $maxdword = &HFFFFFFFF
	Local $fhandle = FileOpen($s_LocalFile, 18)
	If @error Then Return SetError(-1, 0, 0)
	_check_status()
	$s_RemoteFile = StringReplace($s_RemoteFile, '//', '/')
	_GUICtrlEdit_AppendText($hStatus_List, 'Downloading ' & $s_RemoteFile & @CRLF)
	$Timer_1 = TimerInit()
	Local $ai_ftpopenfile = DllCall($GLOBAL_FTP_WININETHANDLE, 'ptr', 'FtpOpenFile', 'hwnd', $l_FTPSession, 'str', $s_RemoteFile, 'dword', $__FTPCONSTANT_GENERIC_READ, 'dword', $FTP_TRANSFER_TYPE_BINARY, 'ulong_ptr', 0)
	If @error Or $ai_ftpopenfile[0] = 0 Then Return SetError(-3, _WinAPI_GetLastError(), 0)
	If $FunctionToCall = "" Then ProgressOn("FTP Download", "Downloading " & $s_LocalFile)
	Local $ai_FTPGetFileSize = DllCall($GLOBAL_FTP_WININETHANDLE, 'dword', 'FtpGetFileSize', 'ptr', $ai_ftpopenfile[0], 'dword*', 0)
	$glen = _WinAPI_MakeQWord($ai_FTPGetFileSize[0], $ai_FTPGetFileSize[2]);FileGetSize($s_RemoteFile)
	Select
		Case $glen < 1048576 ;;If file is less than 1mb
			$last = Mod($glen, 10)
			$x = ($glen - $last) / 10
			If $x = 0 Then
				$x = $last
				$parts = 1
			ElseIf $last > 0 Then
				$parts = 11
			Else
				$parts = 10
			EndIf
			If $x < $last Then
				$buffer = DllStructCreate("byte[" & $last & "]")
			Else
				$buffer = DllStructCreate("byte[" & $x & "]")
			EndIf
			$bigsmall = True
		Case Else
			$last = Mod($glen, 100)
			$x = ($glen - $last) / 100
			If $x = 0 Then
				$x = $last
				$parts = 1
			ElseIf $last > 0 Then
				$parts = 101
			Else
				$parts = 100
			EndIf
			If $x < $last Then
				$buffer = DllStructCreate("byte[" & $last & "]")
			Else
				$buffer = DllStructCreate("byte[" & $x & "]")
			EndIf
			$bigsmall = False
	EndSelect
	For $i = 1 To $parts
		Select
			Case BitAND($i = 101, $last > 0, $bigsmall = False)
				$x = $last
			Case BitAND($i = 11, $last > 0, $bigsmall = True)
				$x = $last
		EndSelect
		Local $ai_FTPread = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'InternetReadFile', 'ptr', $ai_ftpopenfile[0], 'ptr', DllStructGetPtr($buffer), 'int', $x, 'dword*', $out)
		If @error Or $ai_FTPread[0] = 0 Then
			Local $lasterror = _WinAPI_GetLastError()
			$ai_InternetCloseHandle = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'InternetCloseHandle', 'ptr', $ai_ftpopenfile[0])
			FileClose($fhandle)
			Return SetError(-4, $lasterror, 0)
		EndIf
		FileWrite($fhandle, BinaryMid(DllStructGetData($buffer, 1), 1, $ai_FTPread[4]))
		If $FunctionToCall = "" Then
			If $bigsmall = False Then
				ProgressSet($i)
			Else
				ProgressSet($i * 10)
			EndIf
		Else
			$result[0] += $x ; Total bytes sent
			$result[1] = $glen ;Total Filesize
			$result[2] = ($result[0] / $glen) * 100 ;percent
			$result[3] = $result[0] / (TimerDiff($Timer_1) / 1000) ;Speed in bytes per second
			$result[4] = $s_RemoteFile
			$ret = Call($FunctionToCall, $result)
			If $ret <= 0 Then
				$ai_InternetCloseHandle = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'InternetCloseHandle', 'ptr', $ai_ftpopenfile[0])
				FileClose($fhandle)
				FileDelete($s_LocalFile)
				Return SetError(-6, 0, $ret)
			EndIf
		EndIf
		;Sleep(10)
		Sleep(10)
	Next
	FileClose($fhandle)
	If $FunctionToCall = "" Then ProgressOff()
	$ai_InternetCloseHandle = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'InternetCloseHandle', 'ptr', $ai_ftpopenfile[0])
	If @error Or $ai_InternetCloseHandle[0] = 0 Then
		Return SetError(-5, _WinAPI_GetLastError(), 0)
	EndIf
	_check_status()
	_GUICtrlEdit_AppendText($hStatus_List, 'File Size:' & _bytes($glen) & '   Speed:' & _bytes($glen / (TimerDiff($Timer_1) / 1000)) & '/sec' & '  Time:' & Round(TimerDiff($Timer_1), 1) & @CRLF)
	_GUICtrlEdit_AppendText($hStatus_List, 'Download Finished..' & @CRLF)
	Return 1
EndFunc   ;==>_FTP_ProgressDownload2

Func _FTP_ProgressUpload2($l_FTPSession, $s_LocalFile, $s_RemoteFile, $FunctionToCall = "")
	Local $ai_ftpopenfile, $ai_InternetCloseHandle, $fhandle, $glen, $last, $x, $parts, $buffer, $ai_ftpwrite, $result[5], $out, $i, $Total_bytes_sent, $bigsmall, $Timer_1
	Local $ai_ftpopenfile = DllCall($GLOBAL_FTP_WININETHANDLE, 'ptr', 'FtpOpenFile', 'hwnd', $l_FTPSession, 'str', $s_RemoteFile, 'dword', $__FTPCONSTANT_GENERIC_WRITE, 'dword', $FTP_TRANSFER_TYPE_BINARY, 'ulong_ptr', 0)
	If @error Or $ai_ftpopenfile[0] = 0 Then Return SetError(-3, _WinAPI_GetLastError(), 0)
	_check_status()
	_GUICtrlEdit_AppendText($hStatus_List, 'Uploading ' & $s_RemoteFile & @CRLF)
	$s_LocalFile = StringReplace($s_LocalFile, '\\', '\')
	If $FunctionToCall = "" Then ProgressOn("FTP Upload", "Uploading " & $s_LocalFile)
	Local $fhandle = FileOpen($s_LocalFile, 16)
	$glen = FileGetSize($s_LocalFile)
	Select
		Case $glen < 1048576
			$last = Mod($glen, 10)
			$x = ($glen - $last) / 10
			If $x = 0 Then
				$x = $last
				$parts = 1
			ElseIf $last > 0 Then
				$parts = 11
			Else
				$parts = 10
			EndIf
			If $x < $last Then
				$buffer = DllStructCreate("byte[" & $last & "]")
			Else
				$buffer = DllStructCreate("byte[" & $x & "]")
			EndIf
			$bigsmall = True
		Case Else
			$last = Mod($glen, 100)
			$x = ($glen - $last) / 100
			If $x = 0 Then
				$x = $last
				$parts = 1
			ElseIf $last > 0 Then
				$parts = 101
			Else
				$parts = 100
			EndIf
			If $x < $last Then
				$buffer = DllStructCreate("byte[" & $last & "]")
			Else
				$buffer = DllStructCreate("byte[" & $x & "]")
			EndIf
	EndSelect
	$Timer_1 = TimerInit()
	For $i = 1 To $parts
		Select
			Case BitAND($i = 101, $last > 0, $bigsmall = False)
				$x = $last
			Case BitAND($i = 11, $last > 0, $bigsmall = True)
				$x = $last
		EndSelect
		DllStructSetData($buffer, 1, FileRead($fhandle, $x))
		Local $ai_ftpwrite = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'InternetWriteFile', 'ptr', $ai_ftpopenfile[0], 'ptr', DllStructGetPtr($buffer), 'int', $x, 'dword*', $out)
		If @error Or $ai_ftpwrite[0] = 0 Then
			Local $lasterror = _WinAPI_GetLastError()
			$ai_InternetCloseHandle = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'InternetCloseHandle', 'ptr', $ai_ftpopenfile[0])
			FileClose($fhandle)
			Return SetError(-4, $lasterror, 0)
		EndIf
		If $FunctionToCall == "" Then
			If $bigsmall = False Then
				ProgressSet($i * 10)
			Else
				ProgressSet($i)
			EndIf
		Else
			$result[0] += $x ; Total bytes sent
			$result[1] = $glen ;Total Filesize
			$result[2] = ($result[0] / $glen) * 100 ;percent
			$result[3] = $result[0] / (TimerDiff($Timer_1) / 1000) ;Speed in bytes per second
			$result[4] = $s_RemoteFile
			$ret = Call($FunctionToCall, $result)
			If $ret <= 0 Then
				$ai_InternetCloseHandle = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'InternetCloseHandle', 'ptr', $ai_ftpopenfile[0])
				DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'FtpDeleteFile', 'hwnd', $l_FTPSession, 'str', $s_RemoteFile)
				FileClose($fhandle)
				Return SetError(-6, 0, $ret)
			EndIf
		EndIf
		Sleep(10)
	Next
	FileClose($fhandle)
	If $FunctionToCall = "" Then ProgressOff()
	$ai_InternetCloseHandle = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'InternetCloseHandle', 'ptr', $ai_ftpopenfile[0])
	If @error Or $ai_InternetCloseHandle[0] = 0 Then Return SetError(-5, 0, 0)
	_check_status()
	_GUICtrlEdit_AppendText($hStatus_List, 'File Size:' & _bytes($glen) & '   Speed:' & _bytes($glen / (TimerDiff($Timer_1) / 1000)) & '/sec' & '  Time:' & Round(TimerDiff($Timer_1), 1) & @CRLF)
	_GUICtrlEdit_AppendText($hStatus_List, 'Upload Finished..' & @CRLF)
	Return 1
EndFunc   ;==>_FTP_ProgressUpload2

Func _FTP_DirDownload($l_FTPSession, $FTP_StartRoot, $FTP_DirName, $localRoot = '', $opt = False)
	Local $searchhandle, $Search, $array, $curdir, $i
	If StringRight($localRoot, 1) = '\' Then $localRoot = StringTrimRight($localRoot, 1)
	If FileExists($localRoot & '\' & $FTP_DirName) = 0 Then
		DirCreate($localRoot & '\' & $FTP_DirName)
	EndIf
	$curdir = StringReplace($FTP_StartRoot & '/' & $FTP_DirName, '//', '/')
	ConsoleWrite('ftpstart root = ' & $curdir & @LF)
	_FTP_DirSetCurrent($l_FTPSession, $curdir)
	$array = _FTP_ListToArrayEx($l_FTPSession, 0)
	If IsArray($array) Then
		For $i = 1 To $array[0][0]
			If $array[$i][2] = 16 Then
				ConsoleWrite($curdir & '/' & $array[$i][0] & '    changedir' & @LF)
				_FTP_DirDownload($l_FTPSession, $curdir, $array[$i][0], $localRoot & '\' & $FTP_DirName)
			Else
				If _FTP_DirGetCurrent($l_FTPSession) <> $curdir Then
					ConsoleWrite(_FTP_DirGetCurrent($l_FTPSession) & '<>' & $curdir & '  ERROR' & @LF)
					_FTP_DirSetCurrent($l_FTPSession, $curdir)
				EndIf
				ConsoleWrite($curdir & '/' & $array[$i][0] & '  download to ' & $localRoot & '\' & $FTP_DirName & '\' & $array[$i][0] & @LF)
				_FTP_ProgressDownload2($l_FTPSession, $localRoot & '\' & $FTP_DirName & '\' & $array[$i][0], $curdir & '/' & $array[$i][0], '_progressupdate')
			EndIf
		Next
		_FTP_DirSetCurrent($l_FTPSession, $FTP_StartRoot)
	EndIf
	Return
EndFunc   ;==>_FTP_DirDownload

Func _GUI_connectftp($history = '')
	Local $Form1, $inIP, $Label1, $inPort, $Label2, $inUser, $Label3, $inPass, $Label4, $butConnect, $address
	$Form1 = GUICreate("FTP Connect", 323, 140)
	$inIP = GUICtrlCreateCombo("", 80, 15, 166, 21)
	$Label1 = GUICtrlCreateLabel("Server or Url:", 10, 20, 66, 17)
	$inPort = GUICtrlCreateInput("21", 285, 15, 26, 21)
	$Label2 = GUICtrlCreateLabel("Port:", 255, 20, 26, 17)
	$inUser = GUICtrlCreateInput("", 80, 45, 231, 21)
	$Label3 = GUICtrlCreateLabel("User Name:", 10, 50, 60, 17)
	$inPass = GUICtrlCreateInput("", 80, 75, 231, 21)
	$Label4 = GUICtrlCreateLabel("Password:", 10, 80, 53, 17)
	$butConnect = GUICtrlCreateButton("Connect", 100, 105, 106, 26, 0)
	If $history <> '' Then GUICtrlSetData($inIP, $history)
	GUISetState(@SW_SHOW, GUICtrlGetHandle($Form1))
	While 1
		$lMsg = GUIGetMsg()
		Switch $lMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($Form1)
				$address = ''
				Return $address
			Case $butConnect
				If GUICtrlRead($inIP) = '' Then
					MsgBox(0, 'ERROR', 'Must Enter Server or Url.')
					ContinueLoop
				EndIf
				$taddress = _CheckIP(GUICtrlRead($inIP))
				If $taddress = '0' Then
					MsgBox(0, '', $taddress)
					ContinueLoop
				EndIf
				$address = StringStripWS($taddress & ',' & GUICtrlRead($inUser) & ',' & GUICtrlRead($inPass) & ',' & GUICtrlRead($inPort), 8)
				GUISetState(@SW_HIDE, GUICtrlGetHandle($Form1))
				$Gconn = _connect($taddress, GUICtrlRead($inUser), GUICtrlRead($inPass), GUICtrlRead($inPort))
				If @error = -3 Then MsgBox(0, '', 'Could Not Connect')
				GUIDelete($Form1)
				Return $address
		EndSwitch
	WEnd
EndFunc   ;==>_GUI_connectftp

Func _FTPDirSwitch($index)
	Local $cur, $list, $switch, $aFile
	If _GUICtrlListView_GetItemText($FTP_List, $index, 1) = 'DIR' Then
		_ArrayAdd($FtpCurrentDir, _GUICtrlListView_GetItemText($FTP_List, $index))
	EndIf
	If _GUICtrlListView_GetItemText($FTP_List, $index, 0) = '[..]' Then
		_FTPBack()
		Return
	EndIf
	Select
		Case UBound($FtpCurrentDir) = 2
			$switch = $FtpCurrentDir[0] & $FtpCurrentDir[1]
		Case Else
			$switch = $FtpCurrentDir[0] & $FtpCurrentDir[1]
			For $i = 2 To UBound($FtpCurrentDir) - 1
				$switch &= '/' & $FtpCurrentDir[$i]
			Next
	EndSelect
	_FTP_DirSetCurrent($conn, $switch)
	If @error Then
		MsgBox(0, '', 'ERROR Changing dirs')
		Return
	EndIf
	ConsoleWrite(_FTP_DirGetCurrent($conn) & @LF)
	_GUICtrlListView_DeleteAllItems($hFTP_List)
	_GUICtrlListView_AddItem($hFTP_List, "[..]", 1)
	$aFile = _FTP_ListToArrayEx($conn, 0, $INTERNET_FLAG_RELOAD)
	If IsArray($aFile) Then
		For $i = 1 To $aFile[0][0]
			If $aFile[$i][2] = 16 Then
				$item = _GUICtrlListView_AddItem($hFTP_List, $aFile[$i][0], $FOLDER_ICON_INDEX)
				_GUICtrlListView_AddSubItem($hFTP_List, $item, 'DIR', 1)
			Else
				$ext = StringRight($aFile[$i][0], 3)
				$item = _GUICtrlListView_AddItem($hFTP_List, $aFile[$i][0], _GUIImageList_GetFileIconIndex('c:\blank.' & $ext))
				_GUICtrlListView_AddSubItem($hFTP_List, $item, _bytes($aFile[$i][1]), 1)
			EndIf
		Next
		GUICtrlSetData($Current_FTP, "Current Directory : " & _FTP_DirGetCurrent($conn))
		_check_status()
		_GUICtrlEdit_AppendText($hStatus_List, 'FTP Directory Change to ' & _FTP_DirGetCurrent($conn) & @CRLF)
	EndIf
EndFunc   ;==>_FTPDirSwitch

Func _FTPBack()
	ConsoleWrite('ftpback')
	Local $i, $list, $switch
	ConsoleWrite(_FTP_DirGetCurrent($conn) & @LF)
	_GUICtrlListView_DeleteAllItems($hFTP_List)
	Select
		Case UBound($FtpCurrentDir) = 1
			Return
		Case UBound($FtpCurrentDir) = 2
			_ArrayDelete($FtpCurrentDir, UBound($FtpCurrentDir))
			$switch = $FtpCurrentDir[0]
		Case Else
			_ArrayDelete($FtpCurrentDir, UBound($FtpCurrentDir))
			$switch = $FtpCurrentDir[0] & $FtpCurrentDir[1]
			For $i = 2 To UBound($FtpCurrentDir) - 1
				$switch &= '/' & $FtpCurrentDir[$i]
			Next
			_GUICtrlListView_AddItem($hFTP_List, "[..]", 1)
	EndSelect
	_FTP_DirSetCurrent($conn, $switch)
	ConsoleWrite(_FTP_DirGetCurrent($conn) & '  switch ' & @LF)
	$aFile = _FTP_ListToArrayEx($conn, 0)
	For $i = 1 To $aFile[0][0]
		If $aFile[$i][2] = 16 Then
			$item = _GUICtrlListView_AddItem($hFTP_List, $aFile[$i][0], $FOLDER_ICON_INDEX)
			_GUICtrlListView_AddSubItem($hFTP_List, $item, 'DIR', 1)
		Else
			$ext = StringRight($aFile[$i][0], 3)
			$item = _GUICtrlListView_AddItem($hFTP_List, $aFile[$i][0], _GUIImageList_GetFileIconIndex('c:\blank.' & $ext))
			_GUICtrlListView_AddSubItem($hFTP_List, $item, _bytes($aFile[$i][1]), 1)
		EndIf
	Next
	GUICtrlSetData($Current_FTP, "Current Directory : " & _FTP_DirGetCurrent($conn))
	_check_status()
	_GUICtrlEdit_AppendText($hStatus_List, 'FTP Directory Change to ' & _FTP_DirGetCurrent($conn) & @CRLF)
	Return
EndFunc   ;==>_FTPBack

Func _FtpRefresh()
	Local $aFile, $i, $item, $ext
	_GUICtrlListView_DeleteAllItems($hFTP_List)
	$aFile = _FTP_ListToArrayEx($conn, 0, $INTERNET_FLAG_RELOAD)
	If _FTP_DirGetCurrent($conn) <> '/' Then
		_GUICtrlListView_AddItem($hFTP_List, "[..]", 1)
	EndIf
	If IsArray($aFile) Then
		For $i = 1 To $aFile[0][0]
			If $aFile[$i][2] = 16 Then
				$item = _GUICtrlListView_AddItem($hFTP_List, $aFile[$i][0], $FOLDER_ICON_INDEX)
				_GUICtrlListView_AddSubItem($hFTP_List, $item, 'DIR', 1)
			Else
				$ext = StringRight($aFile[$i][0], 3)
				$item = _GUICtrlListView_AddItem($hFTP_List, $aFile[$i][0], _GUIImageList_GetFileIconIndex('c:\blank.' & $ext))
				_GUICtrlListView_AddSubItem($hFTP_List, $item, _bytes($aFile[$i][1]), 1)
			EndIf
		Next
	EndIf
EndFunc   ;==>_FtpRefresh

Func _connect($ftpaddress, $ftpuser, $ftppass, $port, $session = 'session')
	Global $open = _FTP_Open($session)
	Global $conn = _FTP_Connect($open, $ftpaddress, $ftpuser, $ftppass, 1, $port)
	If @error = -1 Then
		_check_status()
		_GUICtrlEdit_AppendText($hStatus_List, 'Failed Connecting to ' & $ftpaddress & @CRLF)
		ConsoleWrite(@error)
		SetError(-3)
		Return
	EndIf
	_check_status()
	_GUICtrlEdit_AppendText($hStatus_List, 'Connected to ' & $ftpaddress & @CRLF)
	$ftpstatus = 'con'
	$FtpCurrentDir[0] = _FTP_DirGetCurrent($conn)
	$aFile = _FTP_ListToArrayEx($conn, 0, $INTERNET_FLAG_RELOAD)
	For $i = 1 To $aFile[0][0]
		If $aFile[$i][2] = 16 Then
			$item = _GUICtrlListView_AddItem($hFTP_List, $aFile[$i][0], $FOLDER_ICON_INDEX)
			_GUICtrlListView_AddSubItem($hFTP_List, $item, 'DIR', 1)
		Else
			$ext = StringRight($aFile[$i][0], 3)
			$item = _GUICtrlListView_AddItem($hFTP_List, $aFile[$i][0], _GUIImageList_GetFileIconIndex('c:\blank.' & $ext))
			_GUICtrlListView_AddSubItem($hFTP_List, $item, _bytes($aFile[$i][1]), 1)
		EndIf
	Next
	GUICtrlSetData($Current_FTP, "Current Directory : " & _FTP_DirGetCurrent($conn))
EndFunc   ;==>_connect

Func _CheckIP($ip) ; Verifys corrent IP format or converts URL to IP
	ConsoleWrite($ip)
	Local $ipcheck, $ipchange, $newip
	$ipcheck = StringReplace($ip, '.', '')
	If StringIsDigit($ipcheck) = 1 Then
		ConsoleWrite(StringIsDigit($ipcheck) & '   ' & $ipcheck)
		Return $ip
	Else
		If StringInStr($ip, 'ftp://') <> 0 Then $ip = StringReplace($ip, 'ftp://', '')
		ConsoleWrite($ip & @LF)
		If StringInStr($ip, 'ftp:/') <> 0 Then $ip = StringReplace($ip, 'ftp:/', '')
		ConsoleWrite($ip & @LF)
		If StringRight($ip, 1) = '/' Then $ip = StringTrimRight($ip, 1)
		ConsoleWrite($ip & @LF)
		TCPStartup()
		$newip = TCPNameToIP($ip)
		ConsoleWrite($newip & @LF)
		TCPShutdown()
		;$ipchange = $ip
		If $newip = '' Then
			MsgBox(0, 'ERROR', 'Problem with Server address.')
			Return 0
		EndIf
		ConsoleWrite($newip & @LF)
		Return $newip
	EndIf
EndFunc   ;==>_CheckIP

Func _FTPdelete()
	Local $selectedftp, $i, $curftpdir, $del
	$id = MsgBox(36, 'Confirm File Delete', 'Are you sure you want to delete selected files?')
	If $id = 7 Then Return
	$selectedftp = _GUICtrlListView_GetSelectedIndices($hFTP_List, True)
	$curftpdir = _FTP_DirGetCurrent($conn)
	For $i = 1 To $selectedftp[0]
		$text = _GUICtrlListView_GetItemText($hFTP_List, $selectedftp[$i], 0)
		$type = _GUICtrlListView_GetItemText($hFTP_List, $selectedftp[$i], 1)
		If $type = 'DIR' Then
			_FTPRemovedir($curftpdir & '/' & $text)
			_FTP_DirSetCurrent($conn, $curftpdir)
			$del = _FTP_DirDelete($conn, $text)
			If $del = 1 Then
				_check_status()
				_GUICtrlEdit_AppendText($hStatus_List, $curftpdir & '/' & $text & ' Directory Deleted' & @CRLF)
			EndIf
		Else
			$del = _FTP_FileDelete($conn, $text)
			If $del = 1 Then
				_check_status()
				_GUICtrlEdit_AppendText($hStatus_List, $curftpdir & '/' & $text & ' File Deleted' & @CRLF)
			EndIf
		EndIf
	Next
	_GUICtrlListView_DeleteItemsSelected($hFTP_List)
	_FtpRefresh()
EndFunc   ;==>_FTPdelete

Func _FTPRemovedir($FTPdir)
	Local $changeDir, $list
	_FTP_DirSetCurrent($conn, $FTPdir)
	$list = _FTP_ListToArrayEx($conn, 0)
	If IsArray($list) Then
		For $i = 1 To $list[0][0]
			If $list[$i][2] = 16 Then
				_FTPRemovedir($FTPdir & '/' & $list[$i][0])
				_FTP_DirSetCurrent($conn, $FTPdir)
				_FTP_DirDelete($conn, $list[$i][0])
				_check_status()
				_GUICtrlEdit_AppendText($hStatus_List, $FTPdir & '/' & $list[$i][0] & ' Directory Deleted' & @CRLF)
			Else
				_FTP_FileDelete($conn, $list[$i][0])
				_check_status()
				_GUICtrlEdit_AppendText($hStatus_List, $FTPdir & '/' & $list[$i][0] & ' File Deleted' & @CRLF)
			EndIf
		Next
	EndIf
EndFunc   ;==>_FTPRemovedir

Func _FTPCreateFolder()
	Local $d_Name
	$d_Name = InputBox('Create New Directory', 'Enter Directory Name', '')
	_FTP_DirCreate($conn, $d_Name)
	_FtpRefresh()
EndFunc   ;==>_FTPCreateFolder


;Local Browsing Functions.........................................
Func _Home()
	Local $drives, $item
	_GUICtrlListView_DeleteAllItems($hLocal_List)
	$drives = DriveGetDrive("ALL")
	For $i = 1 To $drives[0]
		$item = _GUICtrlListView_AddItem($hLocal_List, $drives[$i] & '\', _GUIImageList_GetFileIconIndex($drives[$i] & '\'))
		_GUICtrlListView_AddSubItem($hLocal_List, $item, 'DIR', 1)
	Next
	GUICtrlSetData($Current_Local, "Current Directory : " & _LocalGetCurrent())
	Return
EndFunc   ;==>_Home

Func _LocalDirSwitch($index)
	Local $folders, $files, $changeDir, $size, $item
	Select
		Case _GUICtrlListView_GetItemText($hLocal_List, $index) = '[..]'
			_LocalBack()
			Return
		Case _GUICtrlListView_GetItemText($hLocal_List, $index, 1) <> 'DIR'
			Return
		Case UBound($localCurrentDir) = 1
			$changeDir = _GUICtrlListView_GetItemText($hLocal_List, $index)
			_ArrayAdd($localCurrentDir, _GUICtrlListView_GetItemText($hLocal_List, $index))
		Case Else
			_ArrayAdd($localCurrentDir, _GUICtrlListView_GetItemText($hLocal_List, $index))
			For $i = 1 To UBound($localCurrentDir) - 1
				If $i = 1 Then
					$changeDir &= $localCurrentDir[$i]
				Else
					$changeDir &= $localCurrentDir[$i] & '\'
				EndIf
			Next
			$changeDir = StringTrimRight($changeDir, 1)
	EndSelect
	_GUICtrlListView_DeleteAllItems($hLocal_List)
	$folders = _FileListToArray($changeDir, "*", 2)
	$files = _FileListToArray($changeDir, "*", 1)
	_GUICtrlListView_BeginUpdate($hLocal_List)
	_GUICtrlListView_AddItem($hLocal_List, "[..]", 1)
	If IsArray($folders) Then
		For $i = 1 To $folders[0]
			$item = _GUICtrlListView_AddItem($hLocal_List, $folders[$i], $FOLDER_ICON_INDEX)
			_GUICtrlListView_AddSubItem($hLocal_List, $item, 'DIR', 1)
		Next
	EndIf
	If IsArray($files) Then
		For $i = 1 To $files[0]
			$size = _bytes(FileGetSize($changeDir & '\' & $files[$i]))
			$item = _GUICtrlListView_AddItem($hLocal_List, $files[$i], _GUIImageList_GetFileIconIndex($files[$i]))
			_GUICtrlListView_AddSubItem($hLocal_List, $item, $size, 1)
		Next
	EndIf
	_GUICtrlListView_EndUpdate($hLocal_List)
	GUICtrlSetData($Current_Local, "Current Directory : " & _LocalGetCurrent())
	;ConsoleWrite($changeDir & @LF)
EndFunc   ;==>_LocalDirSwitch

Func _LocalBack()
	ConsoleWrite('back' & @LF)
	Local $changeDir, $folders, $files, $size
	Select
		Case UBound($localCurrentDir) = 1
			Return
		Case UBound($localCurrentDir) = 2
			_ArrayDelete($localCurrentDir, 1)
			_Home()
			Return
		Case UBound($localCurrentDir) >= 3
			_ArrayDelete($localCurrentDir, UBound($localCurrentDir))
			For $i = 1 To UBound($localCurrentDir) - 1
				If $i = 1 Then
					$changeDir &= $localCurrentDir[$i]
				Else
					$changeDir &= $localCurrentDir[$i] & '\'
				EndIf
			Next
			ConsoleWrite('case 3 : ')
			ConsoleWrite($changeDir & @LF)
		Case Else
			_ArrayDelete($localCurrentDir, UBound($localCurrentDir))
			If $i = 1 Then
				$changeDir &= $localCurrentDir[$i]
			Else
				$changeDir &= $localCurrentDir[$i] & '\'
			EndIf
			ConsoleWrite('case else : ')
			ConsoleWrite($changeDir & @LF)
			$changeDir = StringTrimRight($changeDir, 1)
	EndSelect
	ConsoleWrite($changeDir & @LF)
	_GUICtrlListView_DeleteAllItems($hLocal_List)
	$folders = _FileListToArray($changeDir, '*', 2)
	$files = _FileListToArray($changeDir, '*', 1)
	_GUICtrlListView_BeginUpdate($hLocal_List)
	_GUICtrlListView_AddItem($hLocal_List, "[..]", 1)
	If IsArray($folders) Then
		For $i = 1 To $folders[0]
			$item = _GUICtrlListView_AddItem($hLocal_List, $folders[$i], $FOLDER_ICON_INDEX)
			_GUICtrlListView_AddSubItem($hLocal_List, $item, 'DIR', 1)
		Next
	EndIf
	If IsArray($files) Then
		For $i = 1 To $files[0]
			$size = _bytes(FileGetSize($changeDir & '\' & $files[$i]))
			$item = _GUICtrlListView_AddItem($hLocal_List, $files[$i], _GUIImageList_GetFileIconIndex($files[$i]))
			_GUICtrlListView_AddSubItem($hLocal_List, $item, $size, 1)
		Next
	EndIf
	_GUICtrlListView_EndUpdate($hLocal_List)
	GUICtrlSetData($Current_Local, "Current Directory : " & _LocalGetCurrent())
EndFunc   ;==>_LocalBack

Func _LocalGetCurrent()
	Local $cur, $i
	If UBound($localCurrentDir) = 1 Then
		Return 'My Computer'
	Else
		For $i = 1 To UBound($localCurrentDir) - 1
			If $i = 1 Then
				$cur &= $localCurrentDir[$i]
			Else
				$cur &= $localCurrentDir[$i] & '\'
			EndIf
		Next
		If UBound($localCurrentDir) = 2 Then Return $cur
		$cur = StringTrimRight($cur, 1)
	EndIf
	Return $cur
EndFunc   ;==>_LocalGetCurrent

Func _LocalRefresh()
	ConsoleWrite('back' & @LF)
	Local $refreshDir, $folders, $files, $size
	$refreshDir = _LocalGetCurrent()
	If $refreshDir = 'My Computer' Then
		_Home()
		Return
	EndIf
	_GUICtrlListView_DeleteAllItems($hLocal_List)
	$folders = _FileListToArray($refreshDir, '*', 2)
	$files = _FileListToArray($refreshDir, '*', 1)
	_GUICtrlListView_BeginUpdate($hLocal_List)
	_GUICtrlListView_AddItem($hLocal_List, "[..]", 1)
	If IsArray($folders) Then
		For $i = 1 To $folders[0]
			$item = _GUICtrlListView_AddItem($hLocal_List, $folders[$i], $FOLDER_ICON_INDEX)
			_GUICtrlListView_AddSubItem($hLocal_List, $item, 'DIR', 1)
		Next
	EndIf
	If IsArray($files) Then
		For $i = 1 To $files[0]
			$size = _bytes(FileGetSize($refreshDir & '\' & $files[$i]))
			$item = _GUICtrlListView_AddItem($hLocal_List, $files[$i], _GUIImageList_GetFileIconIndex($files[$i]))
			_GUICtrlListView_AddSubItem($hLocal_List, $item, $size, 1)
		Next
	EndIf
	_GUICtrlListView_EndUpdate($hLocal_List)
	GUICtrlSetData($Current_Local, "Current Directory : " & _LocalGetCurrent())
EndFunc   ;==>_LocalRefresh

Func _Localcreatefolder()
	Local $d_Name, $n
	$d_Name = InputBox('Create New Directory', 'Enter Directory Name', '')
	If $d_Name <> "" Then
		$n = StringReplace(_LocalGetCurrent() & '\' & $d_Name, '\\', '\')
		DirCreate($n)
		_LocalRefresh()
	EndIf
EndFunc   ;==>_Localcreatefolder

Func _LocalDelete()
	Local $selectedlocal, $i, $del, $curLocaldir
	$id = MsgBox(36, 'Confirm File Delete', 'Are you sure you want to delete selected files?')
	If $id = 7 Then Return
	$selectedlocal = _GUICtrlListView_GetSelectedIndices($hLocal_List, True)
	$curLocaldir = _LocalGetCurrent()
	For $i = 1 To $selectedlocal[0]
		$text = _GUICtrlListView_GetItemText($hLocal_List, $selectedlocal[$i], 0)
		$type = _GUICtrlListView_GetItemText($hLocal_List, $selectedlocal[$i], 1)
		If $type = 'DIR' Then
			DirRemove($curLocaldir & '\' & $text, 1)
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $curLocaldir & ''\'' & $text = ' & $curLocaldir & '\' & $text & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		Else
			FileDelete($curLocaldir & '\' & $text)
		EndIf
	Next
	_GUICtrlListView_DeleteItemsSelected($hLocal_List)
EndFunc   ;==>_LocalDelete


;Prog@ndy Icon Functions...................................
Func _GUIImageList_GetSystemImageList($bLargeIcons = False)
	Local $dwFlags, $hIml, $FileInfo = DllStructCreate($tagSHFILEINFO)
	$dwFlags = BitOR($SHGFI_USEFILEATTRIBUTES, $SHGFI_SYSICONINDEX)
	If Not ($bLargeIcons) Then
		$dwFlags = BitOR($dwFlags, $SHGFI_SMALLICON)
	EndIf
	$hIml = _WinAPI_SHGetFileInfo(".txt", $FILE_ATTRIBUTE_NORMAL, DllStructGetPtr($FileInfo), DllStructGetSize($FileInfo), $dwFlags)
	Return $hIml
EndFunc   ;==>_GUIImageList_GetSystemImageList

Func _GUIImageList_GetFileIconIndex($sFileSpec, $bLargeIcons = False, $bForceLoadFromDisk = False)
	Local $dwFlags, $FileInfo = DllStructCreate($tagSHFILEINFO)
	$dwFlags = $SHGFI_SYSICONINDEX
	If $bLargeIcons Then
		$dwFlags = BitOR($dwFlags, $SHGFI_LARGEICON)
	Else
		$dwFlags = BitOR($dwFlags, $SHGFI_SMALLICON)
	EndIf
	If Not $bForceLoadFromDisk Then
		$dwFlags = BitOR($dwFlags, $SHGFI_USEFILEATTRIBUTES)
	EndIf
	Local $lR = _WinAPI_SHGetFileInfo($sFileSpec, $FILE_ATTRIBUTE_NORMAL, DllStructGetPtr($FileInfo), DllStructGetSize($FileInfo), $dwFlags)
	If ($lR = 0) Then
		Return SetError(1, 0, -1)
	Else
		Return DllStructGetData($FileInfo, "iIcon")
	EndIf
EndFunc   ;==>_GUIImageList_GetFileIconIndex

Func _WinAPI_SHGetFileInfo($pszPath, $dwFileAttributes, $psfi, $cbFileInfo, $uFlags)
	Local $return = DllCall("shell32.dll", "DWORD*", "SHGetFileInfo", "str", $pszPath, "DWORD", $dwFileAttributes, "ptr", $psfi, "UINT", $cbFileInfo, "UINT", $uFlags)
	If @error Then Return SetError(@error, 0, 0)
	Return $return[0]
EndFunc   ;==>_WinAPI_SHGetFileInfo



;others....................
Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $tInfo, $hWndListViewFTP, $hWndListViewlocal, $hWndListViewQueue
	$hWndListViewlocal = $hLocal_List
	$hWndListViewFTP = $hFTP_List
	$hWndListViewQueue = $hQueue_list
	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $hWndListViewlocal
			Switch $iCode
				;Case $LVN_KEYDOWN ; A key has been pressed
				;	$tInfo = DllStructCreate($tagNMLVKEYDOWN, $ilParam)
				;If DllStructGetData($tInfo, "VKey") = 917512 Then _LocalBack()
				Case $NM_DBLCLK ; Sent by a list-view control when the user double-clicks an item with the left mouse button
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
					_LocalDirSwitch(DllStructGetData($tInfo, "Index"))
					;MsgBox(0,'',DllStructGetData($tInfo, "Index"))
				Case $NM_RCLICK
					;_submenu()
					_LocalListView_RClick()
					;ConsoleWrite('localright click' & @LF)
			EndSwitch
		Case $hWndListViewFTP
			Switch $iCode
				;Case $LVN_KEYDOWN ; A key has been pressed
				;	$tInfo = DllStructCreate($tagNMLVKEYDOWN, $ilParam)
				;	ConsoleWrite('ftpkey')
				;If DllStructGetData($tInfo, "VKey") = 917512 Then _FTPBack()
				Case $NM_DBLCLK ; Sent by a list-view control when the user double-clicks an item with the left mouse button
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
					_FTPDirSwitch(DllStructGetData($tInfo, "Index"))
					;_FTPDirSwitch(DllStructGetData($tInfo, "Index"))
					ConsoleWrite('ftplist_double')
				Case $NM_RCLICK
					_FTPListView_RClick()
					;ConsoleWrite('localright click' & @LF)
			EndSwitch
		Case $hWndListViewQueue
			Switch $iCode
				Case $NM_RCLICK
					; _QueueListView_RClick()
					ConsoleWrite('Queue right click' & @LF)
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func _FTPListView_RClick()
	Local $aHit, $hMenu, $selectedcount
	Local Enum $idQueue = 1000, $idTransfer, $idDelete, $idRename, $idRefresh, $idFolder
	;$aHit = _GUICtrlListView_SubItemHitTest($hFTP_List)
	;If ($aHit[0] <> -1) Then
	; Create a standard popup menu
	; -------------------- To Do --------------------
	$hMenu = _GUICtrlMenu_CreatePopup()
	$selectedcount = _GUICtrlListView_GetSelectedCount($hFTP_List)
	If $selectedcount = 1 Then
		_GUICtrlMenu_AddMenuItem($hMenu, "Queue", $idQueue)
		_GUICtrlMenu_AddMenuItem($hMenu, "Transfer", $idTransfer)
		_GUICtrlMenu_AddMenuItem($hMenu, "Rename", $idRename)
		_GUICtrlMenu_AddMenuItem($hMenu, "Delete", $idDelete)
		_GUICtrlMenu_AddMenuItem($hMenu, "Refresh", $idRefresh)
		_GUICtrlMenu_AddMenuItem($hMenu, "Create Folder", $idFolder)
	Else
		_GUICtrlMenu_AddMenuItem($hMenu, "Queue", $idQueue)
		_GUICtrlMenu_AddMenuItem($hMenu, "Transfer", $idTransfer)
		_GUICtrlMenu_AddMenuItem($hMenu, "Delete", $idDelete)
		_GUICtrlMenu_AddMenuItem($hMenu, "Refresh", $idRefresh)
		_GUICtrlMenu_AddMenuItem($hMenu, "Create Folder", $idFolder)
	EndIf
	; ========================================================================
	; Shows how to capture the context menu selections
	; ========================================================================
	Switch _GUICtrlMenu_TrackPopupMenu($hMenu, $hFTP_List, -1, -1, 1, 1, 2)
		Case $idQueue
			_Queuedownload(True)
		Case $idTransfer
			_Queuedownload(False)
			;ConsoleWrite("Save: " & StringFormat("Item, SubItem [%d, %d]", $aHit[0], $aHit[1]))
		Case $idRename

			;ConsoleWrite("Info: " & StringFormat("Item, SubItem [%d, %d]", $aHit[0], $aHit[1]))
		Case $idRefresh
			_FtpRefresh()
			;ConsoleWrite('FTPrefresh' & @LF)
		Case $idDelete
			_FTPdelete()
		Case $idFolder
			_FTPCreateFolder()
		Case Else
	EndSwitch
	_GUICtrlMenu_DestroyMenu($hMenu)
	;EndIf
EndFunc   ;==>_FTPListView_RClick

Func _LocalListView_RClick()
	Local $aHit, $selectedcount
	Local Enum $idQueue = 1000, $idTransfer, $idDelete, $idRename, $idRefresh, $idFolder
	;$aHit = _GUICtrlListView_SubItemHitTest($hLocal_List)
	;If ($aHit[0] <> -1) Then
	; Create a standard popup menu
	; -------------------- To Do --------------------
	$hMenu = _GUICtrlMenu_CreatePopup()
	$selectedcount = _GUICtrlListView_GetSelectedCount($hLocal_List)
	If $selectedcount = 1 Then
		_GUICtrlMenu_AddMenuItem($hMenu, "Queue", $idQueue)
		_GUICtrlMenu_AddMenuItem($hMenu, "Transfer", $idTransfer)
		;_GUICtrlMenu_AddMenuItem($hMenu, "Rename", $idRename)
		_GUICtrlMenu_AddMenuItem($hMenu, "Delete", $idDelete)
		_GUICtrlMenu_AddMenuItem($hMenu, "Refresh", $idRefresh)
		_GUICtrlMenu_AddMenuItem($hMenu, "Create Folder", $idFolder)
		;	$multi = False
	Else
		_GUICtrlMenu_AddMenuItem($hMenu, "Queue", $idQueue)
		_GUICtrlMenu_AddMenuItem($hMenu, "Transfer", $idTransfer)
		_GUICtrlMenu_AddMenuItem($hMenu, "Delete", $idDelete)
		_GUICtrlMenu_AddMenuItem($hMenu, "Refresh", $idRefresh)
		_GUICtrlMenu_AddMenuItem($hMenu, "Create Folder", $idFolder)
		;	$multi = True
	EndIf
	; ========================================================================
	; Shows how to capture the context menu selections
	; ========================================================================
	;_GUICtrlMenu_TrackPopupMenu($hMenu, $hLocal_List, -1, -1, 1, 1, 2)
	Switch _GUICtrlMenu_TrackPopupMenu($hMenu, $hLocal_List, -1, -1, 1, 1, 2)
		Case $idQueue
			_Queueupload(True)
		Case $idTransfer
			_Queueupload(False)
			;Case $idRename

		Case $idFolder
			_localcreatefolder()
		Case $idDelete
			_LocalDelete()
		Case $idRefresh
			_LocalRefresh()
	EndSwitch
	_GUICtrlMenu_DestroyMenu($hMenu)
	;EndIf
EndFunc   ;==>_LocalListView_RClick

Func _bytes($bytes)
	If $bytes >= 1073741824 Then Return Round($bytes / 1073741824, 2) & " GB"
	If $bytes >= 1048576 Then Return Round($bytes / 1048576, 2) & " MB"
	If $bytes >= 1024 Then Return Round($bytes / 1024, 2) & " KB"
	If $bytes < 1024 Then Return $bytes & " Bytes"
EndFunc   ;==>_bytes
