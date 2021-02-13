#include <WinAPI.au3>

Local $download = InputBox('Multi-Segment Downloader', 'Type or Paste URL then Click Ok', Default, Default, Default, 125)
If Not $download Then Exit

Global $size = InetGetSize($download, 1); This works most of the time
If @error Then $size = 10000000; If not, then preset the size to 10MB

Global $refer = $download
$download = StringReplace($download, 'http://', '', 1)

Local $ss = StringSplit($download, '/')
Local $sFile = @ScriptDir & '\' & $ss[$ss[0]]; File to write the download data

If FileExists($sFile) Then FileDelete($sFile)

Global $PFileURL = '', $string = StringSplit($download, '/', 2)

For $i = 1 To UBound($string) - 1
    $PFileURL &= '/' & $string[$i]
Next

TCPStartup()
Global $ip = TCPNameToIP($string[0])
Global $sw = 0, $pb1 = 0, $nextchunkPos = 0
Global $hFile = _WinAPI_CreateFile($sFile, 3, 4, 2)

Global $chunkarr[4][7]; [4] = Maximum number of simultaneous chunks
#cs
    [0] = Socket
    [1] = ChunkStart
    [2] = ChunkEnd
    [3] = ChunkSize
    [4] = Data
    [5] = Downloading
    [6] = 0d0a0d0a
#ce

Global $chunksize = 2 * 1024 * 1024; This seems to be the best setting (overall)

Local $chunksactive
Local $myGUI = GUICreate('Multi-Segment Downloader', 300, 250)
Local $dn = GUICtrlCreateLabel('', 20, 25, 250, 20)
Local $sz = GUICtrlCreateLabel('', 20, 45, 250, 20)
Local $prg = GUICtrlCreateProgress(20, 75, 250, 15)
Local $sIP = GUICtrlCreateLabel('', 20, 100, 250, 20)
Local $sock = GUICtrlCreateLabel('', 20, 120, 250, 20)
Local $st = GUICtrlCreateLabel('', 20, 160, 250, 20)
Local $ct = GUICtrlCreateLabel('', 20, 180, 75, 20)
Local $act = GUICtrlCreateInput('', 20, 215, 100, 20)
Local $d1 = GUICtrlCreateInput('0', 120, 215, 20, 20)
Local $d2 = GUICtrlCreateInput('0', 140, 215, 20, 20)
Local $d3 = GUICtrlCreateInput('0', 160, 215, 20, 20)
Local $d4 = GUICtrlCreateInput('0', 180, 215, 20, 20)
Local $MouseTrap = GUICtrlCreateInput('', 300, 215, 4, 20)
GUICtrlSetData($dn, 'File: ' & $ss[$ss[0]])
GUICtrlSetData($sz, 'Size: ' & Round($size / 1024 / 1024) & ' mb')
GUICtrlSetData($sIP, 'IP Address: ' & $ip)
GUISetState(@SW_SHOW, $myGUI)
ControlFocus('', '', $MouseTrap)

Global $DLT = TimerInit()
AdlibRegister('HMS_TimerDiff', 1000)

While 1
    Sleep(50)
    $chunksactive = 0
    For $i = 0 To UBound($chunkarr) - 1; Go through each chunk
        If $chunkarr[$i][5] = 0 And $nextchunkPos < $size Then; Unused ChunkSlot --> Request new chunk
            $chunkarr[$i][1] = $nextchunkPos; Start
            $chunkarr[$i][2] = $nextchunkPos + $chunksize - 1; End
            $chunkarr[$i][4] = Binary(''); Data
            $chunkarr[$i][5] = 1; Downloading
            $chunkarr[$i][6] = 0; Found 0d0a0d0a after header
            If $chunkarr[$i][2] + $chunksize >= $size Then $chunkarr[$i][2] = $size - 1; If last chunk set end to last byte
            $chunkarr[$i][3] = $chunkarr[$i][2] - $chunkarr[$i][1] + 1; size
            RequestChunk($i)
            $nextchunkPos = $chunkarr[$i][2] + 1
        EndIf
        If $chunkarr[$i][5] = 1 Then; Current chunk is marked downloading
            $chunksactive += 1
            RecvChunk($i)
        EndIf
        GUICtrlSetData($d1, $chunkarr[0][5])
        GUICtrlSetData($d2, $chunkarr[1][5])
        GUICtrlSetData($d3, $chunkarr[2][5])
        GUICtrlSetData($d4, $chunkarr[3][5])
    Next
    If $chunksactive = 0 Then ExitLoop
WEnd
_WinAPI_CloseHandle($hFile)
AdlibUnRegister('HMS_TimerDiff')
GUICtrlSetData($st, 'Status: Finished')
Sleep(2000)
GUIDelete($myGUI)
$sw = 1
;
If FileGetSize($sFile) == $size Then
    MsgBox(8256, 'Multi-Segment Downloader', 'Download Finished' & @CRLF & 'Time: ' & HMS_TimerDiff())
Else
    MsgBox(8208, 'Multi-Segment Downloader', 'File Error')
EndIf
Exit

Func HMS_TimerDiff(); Snipet Author: JackDinn - modified by ripdad
    Local $Time = TimerDiff($DLT)
    Local $hour = Floor($Time / 3600000)
    If $hour < 10 Then $hour = '0' & $hour
    Local $remanH = Mod($Time, 3600000)
    Local $min = Floor($remanH / 60000)
    If $min < 10 Then $min = '0' & $min
    Local $remanM = Mod($remanH, 60000)
    Local $sec = Floor($remanM / 1000)
    If $sec < 10 Then $sec = '0' & $sec
    Local $ft = $hour & ':' & $min & ':' & $sec
    If $sw = 0 Then GUICtrlSetData($ct, $ft)
    If $sw = 1 Then Return $ft
EndFunc

Func RequestChunk($chunknr)
    GUICtrlSetData($act, 'RequestChunk')
    Local $h = "GET " & $PFileURL & " HTTP/1.1" & @CRLF
    $h &= "Referer: " & $refer & @CRLF
    $h &= "Range: bytes=" & $chunkarr[$chunknr][1] & "-" & $chunkarr[$chunknr][2] & @CRLF
    $h &= "User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; de; rv:1.9.2.8) Gecko/20100722 Ant.com Toolbar 2.0.1 Firefox/3.6.8" & @CRLF
    $h &= "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" & @CRLF
    $h &= "Accept-Language: de-de,de;q=0.8,en-us;q=0.5,en;q=0.3" & @CRLF
    $h &= "Accept-Encoding: gzip,deflate" & @CRLF
    $h &= "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7" & @CRLF
    $h &= "Keep-Alive: 115" & @CRLF
    $h &= "Connection: keep-alive" & @CRLF
    $h &= "Host: " & $string[0] & @CRLF
    $h &= "Pragma: no-cache" & @CRLF
    $h &= @CRLF
    $chunkarr[$chunknr][0] = TCPConnect($ip, 80)
    Local $err = @error
    Local $bs = TCPSend($chunkarr[$chunknr][0], $h)
    If $chunkarr[$chunknr][0] = -1 Or $err Then
        GUIDelete($myGUI)
        MsgBox(8208, '', 'TCPConnect Error')
        Exit
    EndIf
    If $chunkarr[0][0] > 0 Then GUICtrlSetData($sock, 'Open Sockets: ' & $chunkarr[0][0] & ' - ' & $chunkarr[1][0] & ' - ' & $chunkarr[2][0] & ' - ' & $chunkarr[3][0])
    If $chunkarr[0][5] > 0 Then GUICtrlSetData($st, 'Status: Connected')
EndFunc

Func RecvChunk($chunknr)
    GUICtrlSetData($act, 'RecvChunk I')
    Local $timer = '', $data = ''
    $data = TCPRecv($chunkarr[$chunknr][0], 512, 1)
    If @error <> 0 Then
        If BinaryLen($chunkarr[$chunknr][4]) < $chunkarr[$chunknr][3] Then
            Local $cs = TCPCloseSocket($chunkarr[$chunknr][0])
            $chunkarr[$chunknr][4] = Binary('')
            RequestChunk($chunknr)
        Else
            GUICtrlSetData($act, 'WriteChunk')
            $chunkarr[$chunknr][5] = 0
            Local $tBuffer = DllStructCreate("byte[" & BinaryLen($chunkarr[$chunknr][4]) & "]")
            DllStructSetData($tBuffer, 1, $chunkarr[$chunknr][4])
            Local $nBytes
            Local $fp = _WinAPI_SetFilePointer($hFile, $chunkarr[$chunknr][1])
            Local $wf = _WinAPI_WriteFile($hFile, DllStructGetPtr($tBuffer), $chunkarr[$i][3], $nBytes)
            Local $cs = TCPCloseSocket($chunkarr[$chunknr][0])
            $tBuffer = ''
        EndIf
        Return 0
    EndIf
    If Not ($data == '') Then
        $timer = ''
        $timer = TimerInit()
        Do
            Sleep(10)
            If $chunkarr[$chunknr][6] = 0 Then
                Local $data2 = Binary('')
                For $i = 0 To BinaryLen($data)
                    $bit = BinaryMid($data, $i, 1)
                    $data2 &= $bit
                    If StringRight($data2, 8) = Binary("0D0A0D0A") Then
                        $marr = StringRegExp(BinaryToString($data2), "Content-Range: bytes \d+-\d+/(\d+)", 3)
                        $size = $marr[0]
                        $data2 = Binary('')
                        $chunkarr[$chunknr][6] = 1
                    EndIf
                Next
                $data = $data2
            EndIf
            $chunkarr[$chunknr][4] &= $data
            GUICtrlSetData($act, 'RecvChunk I I')
            $data = TCPRecv($chunkarr[$chunknr][0], $chunksize, 1)
            $pb1 += BinaryLen($chunkarr[0][4])
            GUICtrlSetData($prg, Round($pb1 / $size * 1.5))
        Until $data == '' Or TimerDiff($timer) > 10000
    EndIf
    Return 1
EndFunc
;
