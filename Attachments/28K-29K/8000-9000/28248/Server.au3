#region *** CONSTANTS & GLOBAL VARIABLES ***
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>


Global Const $IP_ADDRESS = @IPAddress1
Global Const $FILE_PATH = @TempDir & '\files.txt'

Global Const $MAX_LENGTH = 1024
Global Const $STR_BEG = '<<'
Global Const $STR_END = '>>'

Global $portNumber = 1234
Global $password
Global $passwordProtected
Global $openDirectory = @MyDocumentsDir

Global $connection
Global $socket

_SetOptions()
_WriteFilesToFile($openDirectory, $FILE_PATH)
#endregion
#region *** LOOP ***
TCPStartUp()
$socket = TCPListen($IP_ADDRESS, $portNumber)

If $socket =-1 then
	Msgbox(16, 'Error', 'Error code ' & @error & '...')
EndIf

While 1
	$connection = TCPAccept($socket)
	If $connection >= 0 then
		$command = TCPRecv($connection, $MAX_LENGTH)
;~ 		Msgbox(0, '$command', $command)
		If $command = 'files' then
;~ 			Msgbox(0, '', 'Writing then sending files')
			_WriteFilesToFile($openDirectory, $FILE_PATH)
			_TCPFileSend($connection, $FILE_PATH)

		Else
;~ 			Msgbox(0, 'Sending file...', $openDirectory & '\' & $command)
			$pass = _TCPFileSend($connection, $openDirectory & '\' & $command)
;~ 			Msgbox(0, $pass, $openDirectory & '\' & $command)
		EndIf
		TCPCloseSocket($connection)

	EndIf
WENd
#endregion
#region *** FUNCTIONS ***
Func _TCPFileSend($iMainSocket, $sFile)
    Local $sBuff, $iFileOp,$sRecv

    $iFileOp = FileOpen($sFile, 16)
    If @error Then Return False
    $sBuff = Binary(StringTrimLeft($sFile,StringInStr($sFile,"\",-1,-1))&",")&FileRead($iFileOp)
    FileClose($iFileOp)
	$size = BinaryLen($sBuff)

    While BinaryLen($sBuff)
        $iSendReturn = TCPSend($iMainSocket, $sBuff)
;~ 		Sleep(50)
        If @error Then Return False

        $sBuff = BinaryMid ($sBuff, $iSendReturn + 1, BinaryLen ($sBuff) - $iSendReturn)
    WEnd

	Msgbox(0, 'Sending file', 'Binary length = ' & $size)

    Return True
EndFunc

Func _SetOptions()
	Local Const $WIDTH = 200
	Local Const $HEIGHT = 178
	Local Const $BUFFER = 5
	Local Const $LABEL_WIDTH = 60
	Local Const $CTRL_HEIGHT = 22
	Local Const $INPUT_WIDTH = $WIDTH - $LABEL_WIDTH - $BUFFER * 5
	Local Const $GROUP_OFFSET = 16

	GUICreate('Portal', $WIDTH, $HEIGHT)

	GUICtrlCreateGroup('Server Setup', $BUFFER, $BUFFER, $WIDTH - 2*$BUFFER, $HEIGHT - 2*$BUFFER)

	GUICtrlCreateLabel('IP Address:', $BUFFER * 2, $BUFFER + $GROUP_OFFSET, $LABEL_WIDTH, $CTRL_HEIGHT, BitOR($SS_CENTERIMAGE, $SS_RIGHT))
	GUICtrlCreateInput($IP_ADDRESS, $BUFFER * 3 + $LABEL_WIDTH, $BUFFER + $GROUP_OFFSET, $INPUT_WIDTH, $CTRL_HEIGHT, $ES_READONLY)

	GUICtrlCreatelabel('Port number:', $BUFFER * 2, $BUFFER * 2 + $CTRL_HEIGHT + $GROUP_OFFSET, $LABEL_WIDTH, $CTRL_HEIGHT, BitOR($SS_CENTERIMAGE, $SS_RIGHT))
	$txtPortNumber = GUICtrlCreateInput($portNumber, $BUFFER * 3 + $LABEL_WIDTH, $BUFFER * 2 + $CTRL_HEIGHT + $GROUP_OFFSET, $INPUT_WIDTH, $CTRL_HEIGHT, $ES_NUMBER)

	GUICtrlCreatelabel('Password:', $BUFFER * 2, $BUFFER * 3 + $CTRL_HEIGHT * 2 + $GROUP_OFFSET, $LABEL_WIDTH, $CTRL_HEIGHT, BitOR($SS_CENTERIMAGE, $SS_RIGHT))
	$txtPassword = GUICtrlCreateInput('', $BUFFER * 3 + $LABEL_WIDTH, $BUFFER * 3 + $CTRL_HEIGHT * 2 + $GROUP_OFFSET, $INPUT_WIDTH, $CTRL_HEIGHT, $ES_PASSWORD)

	GUICtrlCreatelabel('Directory:', $BUFFER * 2, $BUFFER * 4 + $CTRL_HEIGHT * 3 + $GROUP_OFFSET, $LABEL_WIDTH, $CTRL_HEIGHT - 4, BitOR($SS_CENTERIMAGE, $SS_RIGHT))
	$txtDir = GUICtrlCreateInput($openDirectory, $BUFFER * 3 + $LABEL_WIDTH, $BUFFER * 4 + $CTRL_HEIGHT * 3 + $GROUP_OFFSET, $INPUT_WIDTH, $CTRL_HEIGHT * 2 - 8, $ES_MULTILINE)
	$btnBrowse = GUICtrlCreateButton('Browse', $BUFFER * 2 + $LABEL_WIDTH - 48, $BUFFER * 4 + $CTRL_HEIGHT * 4 + $GROUP_OFFSET - 4, 50, 17)

	$btnStart = GUICtrlCreateButton('Start server', $BUFFER * 2, $HEIGHT - 35, $WIDTH - $BUFFER * 4, $CTRL_HEIGHT)

	GUISetState()

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				Exit
			Case $btnBrowse
				$dir = FileSelectFolder('Select a folder...', @HomePath, 3, $openDirectory)
				If FileExists($dir) then GUICtrlSetData($txtDir, $dir)

			Case $btnStart
				$portNumber = GUICtrlRead($txtPortNumber)
				$password = GUICtrlRead($txtPassword)
				$passwordProtected = ($password <> '')
				ExitLoop
		EndSwitch
	WEnd
	GUIDelete()
;~ 	Exit
EndFunc

Func _WriteFilesToFile($dir, $file)
	$fileH = FileOpen($file, 10) ; creates directory and file if necessary

	_WriteFileToFileEx($dir, $file)

	FileClose($fileH)
EndFunc

Func _WriteFileToFileEx($path, $fileH) ; recursive method
    $search = FileFindFirstFile($path & '\*.*')
    If @error Then
		FileWriteLine($fileH, $STR_END)
		Return
	EndIf

	$file = FileFindNextFile($search)
	$err = @error
	While $err <> 1
		$fileAtt = FileGetAttrib($path & '\' & $file)
		If Not (StringInStr($fileAtt, 'S') > 0 or StringInStr($fileAtt, 'H') > 0) then ; don't include system files or hidden files
			ConsoleWrite('+> $file = ' & $file & @TAB & @TAB & '$att = ' & $fileAtt & @CRLF)
			If StringInStr($fileAtt, 'D') > 0  then
				FileWriteLine($fileH, $STR_BEG)
				FileWriteLine($fileH, $file)
				_WriteFileToFileEx($path & '\' & $file, $fileH)
			Else
				FileWriteLine($fileH, $file)
			EndIf
		EndIf
		$file = FileFindNextFile($search)
		$err = @error
	WEnd
	FileWriteLine($fileH, $STR_END)

	FileClose($search)
EndFunc
#endregion
