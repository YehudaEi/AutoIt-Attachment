#Include <GUIConstants.au3>

$g_IP = "" ;<----------------------IP HERE
$LogFile = @ScriptDir & "\TreeView.log"

TCPStartUp()
$GUI = GUICreate("Client test",400,400)
$MainTree = GUICtrlCreateTreeView(1, 1, 250, 390)
GUISetState()

Do
Sleep(200)
$socket = TCPConnect($g_IP, 65432 )
Until $socket > -1

WinsetTitle($GUI,"","Test Connected")
TCPSend($socket, "1") ;Confirm connection

While 1
Sleep(20)
	$msg = GUIGetMsg()
	If $msg = $GUI_EVENT_CLOSE Then Exit

	$recv = TCPRecv($socket,+512 )
	If $recv <> "" And $recv <> "~~bye" Then
		$RecvSplit = Stringsplit($recv,",")
		
		If $RecvSplit[1] = 1 Then
			_LoadTree(@ProgramFilesDir &"\", $MainTree, 1)
			If FileExists($LogFile) Then
				$LogSize = FileGetSize($LogFile)
				$LogRead = FileRead($LogFile,$LogSize)
				$LogSend = TCPSend($socket,"2," & $LogRead)
				If $LogSend - 2 = $LogSize Then
					;Equal all fine here
				Else	
					msgbox(0,"Bytes send",$LogSize & " " & $LogSend - 2) ;Not equal
				EndIf
			EndIf
		EndIf
	
	
	
	ElseIf @error Or $recv = "~~bye" Then
	EndIf
WEnd	


Func _LoadTree($sRoot, $hParent, $create_file = 0, $Level = 0)
    Local $s_file = $LogFile
    If $create_file Then
        If FileExists($s_file) Then FileDelete($s_file)
        _LogTreeItem($sRoot, $s_file, $Level); log the main root path
    EndIf
    Local $sMask = "*.*"
    Local $aFile[1], $nCnt = 1, $newParent
    Local $hSearch = FileFindFirstFile($sRoot & $sMask)
    Local $sFile
    If $hSearch >= 0 Then
        $sFile = FileFindNextFile($hSearch)
        While Not @error
            ReDim $aFile[$nCnt]
            $aFile[$nCnt - 1] = $sFile
            $nCnt = $nCnt + 1
            $sFile = FileFindNextFile($hSearch)
        WEnd
        FileClose($hSearch)
    EndIf
    For $i = 0 To UBound($aFile) - 1
        If $aFile[$i] == "." Or $aFile[$i] == ".." Then ContinueLoop
        If StringInStr(FileGetAttrib($sRoot & "\" & $aFile[$i]), "D") Then
            _LogTreeItem($aFile[$i], $s_file, $Level + 1);log item path
            $newParent = GUICtrlCreateTreeViewItem($aFile[$i], $hParent)
            _LoadTree($sRoot & $aFile[$i] & "\", $newParent, 0, $Level + 1)
            ContinueLoop
        EndIf
    Next
EndFunc  ;==>_LoadTree


Func _LogTreeItem($s_item, $s_file, $Level)
    Local $file
    $file = FileOpen($s_file, 1)
    
    If $file = -1 Then
        SetError(1)
        Return 0
    EndIf
    FileWriteLine($file, $Level & "|" & $s_item)
    FileClose($file)
    Return 1
EndFunc  ;==>_LogTreeItem

