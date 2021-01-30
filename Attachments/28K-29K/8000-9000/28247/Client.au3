#region *** INCLUDES & CONSTANTS ***
#include <EditConstants.au3>
#include <File.au3>
#include <GuiConstantsEx.au3>
#include <GuiTreeView.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>


Global Const $MAX_LENGTH = 4096
Global Const $STR_BEG = '<<'
Global Const $STR_END = '>>'
Global Const $FILE_PATH = @TempDir & '\files.txt'

Global Const $WIDTH = 300
Global Const $HEIGHT = 400
Global Const $BUFFER = 4

Global $ipAddress = @IPAddress1
Global $portNumber = 1234
Global $password = ''
Global $downloadDir = @DesktopDir

_SetOptions()
Opt('GUIOnEventMode', 1) ; MUST be kept after _SetOptions()
#endregion
#region *** GUI SETUP & LOOP ***
;~ Msgbox(0, '', '$ip = ' & $ipAddress & @CRLF & '$port = ' & $portNumber)
_GetFileList() ; writes the files to $FILE_PATH
;~ Msgbox(0, '', '')

$mainGUI = GUICreate('Portal', $WIDTH, $HEIGHT)
	GUISetOnEvent($GUI_EVENT_CLOSE, '_Exit')

$iStyle = BitOR($TVS_EDITLABELS, $TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS)

$fileTree =  GUICtrlCreateTreeView($BUFFER, $BUFFER, $WIDTH - 2 * $BUFFER, $HEIGHT - 2 * $BUFFER, $iStyle, $WS_EX_CLIENTEDGE)

$numLines = _FileCountLines($FILE_PATH)

$treeContents = FileOpen($FILE_PATH, 0)
$index = 1
_AddFiles($index, 0)

GUIRegisterMsg($WM_NOTIFY, 'WM_NOTIFY')
GUISetState()

While 1
	Sleep(200)
WEnd
#endregion ***
#region *** TCP FUNCTIONS ***
Func _DownloadFile($file)
	TCPStartUp()
	$connection = TCPConnect($ipAddress, $portNumber)
	If $connection = -1 then
		Msgbox(16, 'Error', 'Server is no accesible...')
		TCPShutdown()
		Exit
	EndIf

	TCPSend($connection, $file)

	$pass = _TCPFileRecv($connection, $downloadDir & '\' & _GetFileName($file))
	If Not $pass then Msgbox(16, 'Error', 'An error occured while trying to recieve the following file:' & @CRLF & $downloadDir & '\' & _GetFileName($file))
	TCPCloseSocket($connection)
	TCPShutdown()
EndFunc

Func _GetFileList()
	TCPStartUp()
	$connection = TCPConnect($ipAddress, $portNumber)

	TCPSend($connection, 'files')
;~ 		Msgbox(0, '', $connection)

	$pass = _TCPFileRecv($connection, $FILE_PATH)
	If Not $pass then Msgbox(16, 'Error', 'Client failed to access the server...')

	TCPCloseSocket($connection)
	TCPShutdown()
EndFunc

Func _TCPFileRecv($iAccSocket, $sFileName)
    Local $sBuff, $sRecv = "", $i = 0, $iFirstWhile = True

    If @error Then Return False

    $sBuff = Binary ($sBuff)

    While $sRecv = ""
        $sRecv = TCPRecv($iAccSocket, 2048, 1)
        $sRecv = BinaryToString ($sRecv)
    WEnd

    While $sRecv <> ""
        If StringInStr($sRecv, ',') And $iFirstWhile Then
            $sTmp = StringLeft($sRecv, StringInStr($sRecv, ",") - 1)
            $sRecv = StringTrimLeft($sRecv, StringLen($sTmp) + 1)
            If StringLen($sFileName) < 1 Then $sFileName = $sTmp
            $iFirstWhile = False
        EndIf
        $sBuff &= $sRecv
        $sRecv = BinaryToString (TCPRecv($iAccSocket, $MAX_LENGTH, 1))
        If @error Then ExitLoop
;~ 		Sleep(50)
    WEnd

    $iFileOp = FileOpen($sFileName, 16 + 2)
    If @error Then Return False
    FileWrite($iFileOp, $sBuff)
    If @error Then Return False
    FileClose($iFileOp)

    Return True
EndFunc  ;==>_FileReceive
#endregion
#region *** HELPERS ***
Func _AddFiles(ByRef $index, $parent)
	Do
		$text = FileReadLine($treeContents, $index)
		$index += 1
		If $text = $STR_BEG then

			$text = FileReadLine($treeContents, $index)
			If $text <> $STR_END then
				$temp = _GUICtrlTreeView_AddChild($fileTree, $parent, $text)
				$index += 1
				_AddFiles($index, $temp)
			EndIf
		ElseIf $text <> $STR_END then
			_GUICtrlTreeView_AddChild($fileTree, $parent, $text)
		EndIf
	Until $text = $STR_END
EndFunc

Func _Exit()
	FileDelete($FILE_PATH)
	Exit
EndFunc

Func _GetFileName($file) ; assumes file exists
	$split = StringSplit($file, '\')
	Return $split[$split[0]]
EndFunc

Func _GetFullPath($sel)
	$path = _GUICtrlTreeView_GetText($fileTree, $sel)
	Do
		$sel = _GUICtrlTreeView_GetParentHandle($fileTree, $sel)
		If $sel <> 0 then
			$path = _GUICtrlTreeView_GetText($fileTree, $sel) & '\' & $path
		EndIf
	Until $sel = 0
	Return $path
EndFunc

Func _SetOptions()
	Local Const $WIDTH = 200
	Local Const $HEIGHT = 178
	Local Const $BUFFER = 5
	Local Const $LABEL_WIDTH = 62
	Local Const $CTRL_HEIGHT = 22
	Local Const $INPUT_WIDTH = $WIDTH - $LABEL_WIDTH - $BUFFER * 5 - 2
	Local Const $GROUP_OFFSET = 16

	GUICreate('Portal', $WIDTH, $HEIGHT)

	GUICtrlCreateGroup('Server Information', $BUFFER, $BUFFER, $WIDTH - 2*$BUFFER, $HEIGHT - 2*$BUFFER)

	GUICtrlCreateLabel('IP Address:', $BUFFER * 2, $BUFFER + $GROUP_OFFSET, $LABEL_WIDTH, $CTRL_HEIGHT, BitOR($SS_CENTERIMAGE, $SS_RIGHT))
	$txtIP = GUICtrlCreateInput($ipAddress, $BUFFER * 3 + $LABEL_WIDTH, $BUFFER + $GROUP_OFFSET, $INPUT_WIDTH, $CTRL_HEIGHT)

	GUICtrlCreatelabel('Port number:', $BUFFER * 2, $BUFFER * 2 + $CTRL_HEIGHT + $GROUP_OFFSET, $LABEL_WIDTH, $CTRL_HEIGHT, BitOR($SS_CENTERIMAGE, $SS_RIGHT))
	$txtPortNumber = GUICtrlCreateInput($portNumber, $BUFFER * 3 + $LABEL_WIDTH, $BUFFER * 2 + $CTRL_HEIGHT + $GROUP_OFFSET, $INPUT_WIDTH, $CTRL_HEIGHT, $ES_NUMBER)

	GUICtrlCreatelabel('Password:', $BUFFER * 2, $BUFFER * 3 + $CTRL_HEIGHT * 2 + $GROUP_OFFSET, $LABEL_WIDTH, $CTRL_HEIGHT, BitOR($SS_CENTERIMAGE, $SS_RIGHT))
	$txtPassword = GUICtrlCreateInput('', $BUFFER * 3 + $LABEL_WIDTH, $BUFFER * 3 + $CTRL_HEIGHT * 2 + $GROUP_OFFSET, $INPUT_WIDTH, $CTRL_HEIGHT, $ES_PASSWORD)

	GUICtrlCreatelabel('Download to:', $BUFFER * 2, $BUFFER * 4 + $CTRL_HEIGHT * 3 + $GROUP_OFFSET, $LABEL_WIDTH, $CTRL_HEIGHT - 4, BitOR($SS_CENTERIMAGE, $SS_RIGHT))
	$txtDir = GUICtrlCreateInput($downloadDir, $BUFFER * 3 + $LABEL_WIDTH, $BUFFER * 4 + $CTRL_HEIGHT * 3 + $GROUP_OFFSET, $INPUT_WIDTH, $CTRL_HEIGHT * 2 - 8, $ES_MULTILINE)
	$btnBrowse = GUICtrlCreateButton('Browse', $BUFFER * 2 + $LABEL_WIDTH - 54, $BUFFER * 4 + $CTRL_HEIGHT * 4 + $GROUP_OFFSET - 4, 50, 17)

	$btnAccess = GUICtrlCreateButton('Access server', $BUFFER * 2, $HEIGHT - 35, $WIDTH - $BUFFER * 4, $CTRL_HEIGHT)

	GUISetState()

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				Exit
			Case $btnBrowse
				$dir = FileSelectFolder('Select a folder...', $downloadDir, 3)
				If FileExists($dir) then GUICtrlSetData($txtDir, $dir)
			Case $btnAccess
				$portNumber = GUICtrlRead($txtPortNumber)
				$password = GUICtrlRead($txtPassword)
				$ipAddress = GUICtrlRead($txtIP)
				$downloadDir = GUICtrlRead($txtDir)
				ExitLoop
		EndSwitch
	WEnd
	GUIDelete()
;~ 	Exit
EndFunc

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
    #forceref $hWnd, $iMsg, $iwParam
    Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndTreeview

    $tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
    $iCode = DllStructGetData($tNMHDR, "Code")
    Switch $hWndFrom
        Case GUICtrlGetHandle($fileTree)
            Switch $iCode
                Case $NM_DBLCLK ; The user has double-clicked the left mouse button within the control
					$sel = _GUICtrlTreeView_GetSelection($fileTree)
					$text = _GUICtrlTreeView_GetText($fileTree, $sel)
					$child = _GUICtrlTreeView_GetFirstChild($fileTree, $sel)
					If $child = 0 then
;~ 						ConsoleWrite('--> Full path = ' & _GetFullPath($sel) & @CRLF)
						_DownloadFile(_GetFullPath($sel))
					EndIf
                    Return 0 ; zero to allow the default processing
            EndSwitch
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY
#endregion
