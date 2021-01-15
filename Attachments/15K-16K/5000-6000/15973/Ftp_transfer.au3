#include <GUIConstants.au3>
#include <GuiListView.au3>
#Include <GuiList.au3>
#include <array.au3>
#include <file.au3>
#include <ftp s.au3>

Const $INTERNET_FLAG_PASSIVE = 0x08000000
Const $INTERNET_FLAG_TRANSFER_ASCII = 0x00000001
Const $INTERNET_FLAG_TRANSFER_BINARY = 0x00000002
Const $INTERNET_DEFAULT_FTP_PORT = 21
Const $INTERNET_SERVICE_FTP = 1
Global $WM_DROPFILES = 0x233
Global $gaDropFiles[1]
Local $tranferlist2, $tranferlist, $dir, $length, $IPread, $XBOX, $conn, $Folderadd, $setdir, $ani1, $IPread, $wininet, $shell32, $nItem, $Total_Bytes

$reg = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Bjs FTP Xbox", "IP")

If @error Then
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Bjs FTP Xbox", "IP", "REG_SZ", "192.168.0.174")
EndIf
$reg = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Bjs FTP Xbox", "IP")

$hGUI = GUICreate("~Beege~ Xbox FTP Transfer", 543, 339, 233, 193, -1, BitOR($WS_EX_ACCEPTFILES, $WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))

$wininet = DllOpen('wininet.dll')
$shell32 = DllOpen('shell32.dll')
$hList = GUICtrlCreateListView("", 16, 16, 297, 185)
_GUICtrlListViewInsertColumn($hList, 1, 'Filename', 0, 233)
_GUICtrlListViewInsertColumn($hList, 1, 'Size', 0, 60)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)

$IP = GUICtrlCreateInput($reg, 336, 16, 105, 21)
GUICtrlCreateLabel("", 72, 304, 4, 4)

GUICtrlCreateLabel("Total Files :", 16, 220, 58, 17)
$total = GUICtrlCreateLabel("0", 76, 220, 25, 17)
GUICtrlCreateLabel("Total Size :", 206, 220, 58, 17)
$tsize = GUICtrlCreateLabel("0", 266, 220, 65, 17)

$Progress1 = GUICtrlCreateProgress(16, 240, 513, 17)
GUICtrlCreateLabel("Current File :", 16, 266, 63, 17)

$Combo1 = GUICtrlCreateCombo("", 336, 72, 161, 25)
GUICtrlSetData(-1, "/F/Videos/|/F/Music/|/F/Pictures/|/F/Games/|/E/Videos/|/E/Music/|/E/Pictures/|/E/Games/", "/F/Videos/")

$Label1 = GUICtrlCreateLabel("Select or Type Transfer Folder :", 336, 48, 153, 17)
$currentfile = GUICtrlCreateLabel("", 84, 266, 200, 16)

$Delete = GUICtrlCreateButton("Remove File", 352, 104, 115, 25)
$Clearlist = GUICtrlCreateButton("Clear List", 352, 136, 115, 25)
$Transfer = GUICtrlCreateButton("Transfer Files", 352, 168, 115, 25)
$Connect = GUICtrlCreateButton("Connect", 456, 14, 57, 25)

GUICtrlSetState($ani1, 0)
GUIRegisterMsg($WM_DROPFILES, "WM_DROPFILES_FUNC")
GUICtrlSetData($Progress1, 0)
GUISetState(@SW_SHOW)

Do
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_DROPPED
			For $i = 0 To UBound($gaDropFiles) - 1
				$fileorfolder = FileGetAttrib($gaDropFiles[$i])
				If $fileorfolder = 'D' Then
					$foldersize = DirGetSize($gaDropFiles[$i])
					$Total_Bytes = $Total_Bytes + $foldersize
					GUICtrlSetData($tsize, _Bytes_Convert($Total_Bytes))
					$nItem = GUICtrlCreateListViewItem($gaDropFiles[$i] & '|' & _Bytes_Convert($foldersize), $hList)
					ContinueLoop
				EndIf
				$dSize = FileGetSize($gaDropFiles[$i])
				$Total_Bytes = $Total_Bytes + $dSize
				GUICtrlSetData($tsize, _Bytes_Convert($Total_Bytes))
				$nItem = GUICtrlCreateListViewItem($gaDropFiles[$i] & '|' & _Bytes_Convert($dSize), $hList)
			Next
			GUICtrlSetData($total, _GUICtrlListViewGetItemCount($hList))
		Case $msg = $Connect
			_connect()
		Case $msg = $Delete
			$ret = _GUICtrlListViewGetItemText($hList, _GUICtrlListViewGetCurSel($hList),0)
			$attri = FileGetAttrib($ret)
			$file = _GUICtrlListViewGetCurSel($hList) 
			Select
				Case $attri = "D"
			    _Delete($file, 2)
				Case Else
				_Delete($file, 1)
			EndSelect
		Case $msg = $Transfer
			_Transfer()
		Case $msg = $Clearlist
			_GUICtrlListViewDeleteAllItems($hList)
			$Total_Bytes = 0
			GUICtrlSetData($total, '0')
			GUICtrlSetData($tsize, '0 Bytes')
	EndSelect
Until $msg = $GUI_EVENT_CLOSE

Func WM_DROPFILES_FUNC($hWnd, $msgID, $wParam, $lParam)
	Local $nSize, $pFileName
	Local $nAmt = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", 0xFFFFFFFF, "ptr", 0, "int", 255)
	For $i = 0 To $nAmt[0] - 1
		$nSize = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", 0, "int", 0)
		$nSize = $nSize[0] + 1
		$pFileName = DllStructCreate("char[" & $nSize & "]")
		DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", DllStructGetPtr($pFileName), "int", $nSize)
		ReDim $gaDropFiles[$i + 1]
		$gaDropFiles[$i] = DllStructGetData($pFileName, 1)
		$pFileName = 0
	Next
EndFunc   ;==>WM_DROPFILES_FUNC

Func _Transfer()
	$tranferlist = _ArrayCreate($tranferlist)
	$tranferlist2 = _ArrayCreate($tranferlist2)
	$count = _GUICtrlListViewGetItemCount($hList)
	If $count <= 0 Then
		MsgBox(0, 'ERROR', 'No Items are in the list')
		Return
	EndIf
	For $i = 0 To $count - 1
		$text = _GUICtrlListViewGetItemText($hList, $i, 0)
		_ArrayAdd($tranferlist, $text)
		$length = StringInStr($text, '\', 0, -1)
		$transfername = StringTrimLeft($text, $length)
		_ArrayAdd($tranferlist2, $transfername)
	Next
	$tranferlist[0] = UBound($tranferlist) - 1
	$IPread = GUICtrlRead($IP)
	$tranferlist[0] = UBound($tranferlist) - 1
	$XBOX = _FTPOpen ('XBOX')
	$conn = _FTPConnect ($XBOX, $IPread, 'xbox', 'xbox', 1)
	If @error Then
		GUICtrlSetState($ani1, 0)
		SplashTextOn('ERROR', 'Could Not Connect to ' & $IPread, 500, 50)
		Sleep(4000)
		SplashOff()
		_FTPClose ($XBOX)
		Return
	EndIf
	$setdir = _FtpSetCurrentDir ($conn, GUICtrlRead($Combo1))
	If @error Then
		$setdir = _FtpSetCurrentDir ($conn, '/F/')
		$dir1 = StringTrimLeft($dir, 3)
		$Mdir = _FTPMakeDir ($conn, StringTrimRight($dir1, 1))
		$setdir = _FtpSetCurrentDir ($conn, $dir)
		$cur = _FTPGetCurrentDir ($conn)
	EndIf
	For $i = 1 To $tranferlist[0]
		$attri = FileGetAttrib($tranferlist[$i])
		If $attri = 'D' Then
			GUICtrlSetData($currentfile, $tranferlist[$i])
			_FTPPutFolder ($conn, $tranferlist[$i], $tranferlist2[$i], 1)
			$index = _GUICtrlListViewGetTopIndex($hList)
			GUICtrlSetData($Progress1, (($i / $tranferlist[0]) * 100))
			_Delete($index, 2)
		Else
			GUICtrlSetData($currentfile, $tranferlist[$i])
			_FTPPutFile ($conn, $tranferlist[$i], $tranferlist2[$i])
			$index = _GUICtrlListViewGetTopIndex($hList)
			GUICtrlSetData($Progress1, (($i / $tranferlist[0]) * 100))
			_Delete($index, 1)
		EndIf
	Next
	GUICtrlSetData($Progress1, 0)
	GUICtrlSetData($currentfile, '')
	_FTPClose ($XBOX)
	$str = ""
EndFunc   ;==>_Transfer

Func _connect()
	$IPread = GUICtrlRead($IP)
	$XBOX = _FTPOpen ('XBOX')
	$conn = _FTPConnect ($XBOX, $IPread, 'xbox', 'xbox', 0)
	If @error Then
		SplashTextOn('ERROR', 'Could Not Connect to ' & $IPread, 500, 50)
		Sleep(4000)
		SplashOff()
		_FTPClose ($XBOX)
	Else
		SplashTextOn('Good', 'Connected!', 500, 50)
		RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Bjs FTP Xbox", "IP", "REG_SZ", $IPread)
		Sleep(900)
		SplashOff()
		_FTPClose ($XBOX)
	EndIf
EndFunc   ;==>_connect

Func _Delete($item, $type)
	$cselecttext = _GUICtrlListViewGetItemText($hList, $item)
	$split = StringSplit($cselecttext, '|')
	Select
		Case $type = 1
			$bytes = FileGetSize($split[1])
	    Case $type = 2
			$bytes = DirGetSize($split[1])
	EndSelect
	$Total_Bytes = $Total_Bytes - $bytes
	GUICtrlSetData($tsize, _Bytes_Convert($Total_Bytes))
	_GUICtrlListViewDeleteItem($hList, $item)
	GUICtrlSetData($total, _GUICtrlListViewGetItemCount($hList))
EndFunc   ;==>_Delete

Func _Bytes_Convert($bytes)
	Select
	Case $bytes >= 1024000000
		Return Round($bytes / 1024000000, 2) & ' GB'
	Case $bytes >= 1024000
		Return Round($bytes / 1024000, 2) & ' MB'
	Case $bytes >= 1024
		Return Round($bytes / 1024, 2) & ' KB'
	Case Else
		Return $bytes & ' Bytes'
	EndSelect
EndFunc

;FTP Functions
Func _FTPGetCurrentDir($l_FTPSession)
	Local $ai_FTPGetCurrentDir = DllCall('wininet.dll', 'int', 'FtpGetCurrentDirectory', 'long', $l_FTPSession, 'str', "", 'long_ptr', 260)
	If @error Or $ai_FTPGetCurrentDir[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf
	
	Return $ai_FTPGetCurrentDir[2]
EndFunc   ;==>_FTPGetCurrentDir

Func _FtpSetCurrentDir($l_FTPSession, $s_Remote)
	Local $ai_FTPSetCurrentDir = DllCall('wininet.dll', 'int', 'FtpSetCurrentDirectory', 'long', $l_FTPSession, 'str', $s_Remote)
	If @error Or $ai_FTPSetCurrentDir[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf
	Return $ai_FTPSetCurrentDir[0]
EndFunc   ;==>_FtpSetCurrentDir

Func _FTPPutFolderContents($l_InternetSession, $s_LocalFolder, $s_RemoteFolder, $b_RecursivePut)
dim $i
    $search = FileFindFirstFile($s_LocalFolder & "\*.*")
    If $search = -1 Then
		Return $i
    EndIf
    While 1
        $file = FileFindNextFile($search)
        If @error Then ExitLoop
        If StringInStr(FileGetAttrib($s_LocalFolder & "\" & $file), "D") Then
            _FTPMakeDir($l_InternetSession, $s_RemoteFolder & "/" & $file)
            If $b_RecursivePut Then
                _FTPPutFolderContents($l_InternetSession, $s_LocalFolder & "\" & $file, $s_RemoteFolder & "/" & $file, $b_RecursivePut)
            EndIf
        Else
            _FTPPutFile($l_InternetSession, $s_LocalFolder & "\" & $file, $s_RemoteFolder & "/" & $file, 0, 0)
        EndIf
WEnd
FileClose($search)
EndFunc ;==>_FTPPutFolderContents

Func _FTPPutFolder($l_InternetSession, $s_LocalFolder, $s_RemoteFolder, $b_RecursivePut)
	Dim $direxists
	$cur = _FTPGetCurrentDir($l_InternetSession)
	$dirlist = _FTPFilesListToArray($l_InternetSession, 1)
	If @error then 
		_FTPMakeDir($l_InternetSession, $s_RemoteFolder)
		$setdir = _FtpSetCurrentDir($l_InternetSession, $cur &'/'& $s_RemoteFolder)
		$cur2 = _FTPGetCurrentDir($l_InternetSession)
		_FTPPutFolderContents($l_InternetSession, $s_LocalFolder, $cur2, 1)
		$setdir = _FtpSetCurrentDir($l_InternetSession, $cur & '/')
		$curorign = _FTPGetCurrentDir($l_InternetSession)
		Return
	EndIf
	For $i = 1 to $dirlist[0]
		If $dirlist[$i] = $s_RemoteFolder Then
			$direxists = 1
		Else
			$direxists = 0
		EndIf
	Next
	If $direxists = 0 Then 
		_FTPMakeDir($l_InternetSession, $s_RemoteFolder)
		$setdir = _FtpSetCurrentDir($l_InternetSession, $cur &'/'& $s_RemoteFolder)
		$cur2 = _FTPGetCurrentDir($l_InternetSession)
		_FTPPutFolderContents($l_InternetSession, $s_LocalFolder, $cur2, 1)
	Else
		$setdir = _FtpSetCurrentDir($l_InternetSession, $cur &'/'& $s_RemoteFolder)
		$cur2 = _FTPGetCurrentDir($l_InternetSession)
		_FTPPutFolderContents($l_InternetSession, $s_LocalFolder, $cur2, 1)
	EndIf
		$setdir = _FtpSetCurrentDir($l_InternetSession, $cur & '/')
		$curorign = _FTPGetCurrentDir($l_InternetSession)
		;MsgBox(0,'',$curorign)
EndFunc
	
Func _FTPFilesListToArray($l_FTPSession, $Return_Type = 0, $l_Flags = 0, $l_Context = 0)
	Dim $array, $array2d
	$array = _ArrayCreate($array)
	$array2d = _ArrayCreate($array2d)
	$str = "dword;int64;int64;int64;dword;dword;dword;dword;char[256];char[14]"
	$WIN32_FIND_DATA = DllStructCreate($str)
	Local $callFindFirst = DllCall('wininet.dll', 'int', 'FtpFindFirstFile', 'long', $l_FTPSession, 'str', "", 'ptr', DllStructGetPtr($WIN32_FIND_DATA), 'long', $l_Flags, 'long', $l_Context)
	If Not $callFindFirst[0] Then
		MsgBox(0, "Folder Empty", "No Files Found ",1)
		SetError(-1)
		Return 0
	EndIf
	$ret = ""
	While 1
		Select
			Case $Return_Type = 0 ; Folders and files
				If DllStructGetData($WIN32_FIND_DATA, 1) = 16 Then
					_ArrayInsert($array, 1, DllStructGetData($WIN32_FIND_DATA, 9)) ; Add Folder to top of array
				Else
					_ArrayAdd($array, DllStructGetData($WIN32_FIND_DATA, 9))  ; Add folder to array
				EndIf
			Case $Return_Type = 1 ; Folders only
				If DllStructGetData($WIN32_FIND_DATA, 1) = 16 Then _ArrayAdd($array, DllStructGetData($WIN32_FIND_DATA, 9))
			Case $Return_Type = 2 ; Files only
				If DllStructGetData($WIN32_FIND_DATA, 1) <> 16 Then _ArrayAdd($array, DllStructGetData($WIN32_FIND_DATA, 9))
		EndSelect
		Local $callFindNext = DllCall('wininet.dll', 'int', 'InternetFindNextFile', 'long', $callFindFirst[0], 'ptr', DllStructGetPtr($WIN32_FIND_DATA))
		If Not $callFindNext[0] Then
			ExitLoop
		EndIf
	WEnd
	$WIN32_FIND_DATA = 0
	$array[0] = UBound($array) - 1
	Return $array
EndFunc   ;==>_FTPFilesListToArray