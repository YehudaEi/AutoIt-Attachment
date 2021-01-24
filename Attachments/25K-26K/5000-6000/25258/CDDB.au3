#include-once
#include <File.au3>

;CDDB.au3 - By GtaSpider (slightly modified by TheSaint for his Example.au3)

; A wait ($wait) feature was added by TheSaint
; See TheSaint's Example.au3 file for further detail about any changes.
; OPEN & CLOSE dll portions of code moved to TheSaint's Example.au3

;~ Global $hWinmmDLL = DllOpen("winmm.dll")

; FUNCTIONS IN UDF
; _CDDBCreateQuery($sCD),  _FreeDBRecvDB($sQuery, $wait, $fSecTry = False)
; _FreeDBRetCDInfos($sDatabase), _FreeDBRetCDTracks($sDatabase), __CDDBGetTrack($iTrack)
; __CDDBGetLeadOut(), __CDDBSum($iSum), __CDDBGetCDID($iTotal), __SplitMSF($sMSF)
; __ReadDatabase($sDatabase, $sKey), __SendMCIString($sString, $iBuf = 255)
; __TCPRecv($hSocket, $iSleep = 50, $iTimeOut = 20000, $iBuffersize = 1024, $iForceBinary = 0)

; REMOVED FUNCTION & RELOCATED (to TheSaint's Example.au3)
; OnAutoItExit()

;===============================================================================
;
; Function Name:   _CDDBCreateQuery($sCD)
; Description::    Create a CDDB Query for e.g. freedb.org
; Parameter(s):    $sCd - The CD Drive, e.g. e: or D:
; Requirement(s):  -
; Return Value(s): On Success: Returns the CD Query.
;			: On Error:
;			: @error = 1 $sCD isn't a CD Drive
;			: @error = 2 MCICommand failed - @extended = 0 --> Open CD faild
;									   @extended = 1 --> Number of Tracks faild
;			: @error = 3 Failed to get the CD Checksum (CD ID) - @extended: Errorcode from __CDDBGetCDID()
;			: @error = 4 Failed to get tracks
;			: @error = 5 Failed to get LeadOut
;
; Author(s):       GtaSpider
;
;===============================================================================
;
Func _CDDBCreateQuery($sCD)
	Local $sRet, $iTotal, $i
	$sCD = StringUpper(StringLeft($sCD, 2))
	If (Not FileExists($sCD)) Or DriveGetType($sCD) <> "CDROM" Then Return SetError(1, 0, 0)
	$sRet = __SendMCIString("open " & $sCD & " type cdaudio alias cd1")
	If @error Then Return SetError(2, 0, 0)
	$sRet = __SendMCIString("status cd1 number of tracks wait")
	If @error Then Return SetError(2, 1, 0)
	$iTotal = $sRet
	$sRet = "cddb query " & __CDDBGetCDID($iTotal) & " " & $iTotal & " "
	If @error Then Return SetError(3, @error, 0)
	For $i = 1 To $iTotal
		$sRet &= __CDDBGetTrack($i) & " "
		If @error Then Return SetError(4, 0, 0)
	Next
	$sRet &= __CDDBGetLeadOut()
	If @error Then Return SetError(4, 0, 0)
	Return $sRet
EndFunc   ;==>_CDDBCreateQuery


;===============================================================================
;
; Function Name:   _FreeDBRecvDB($sQuery, $wait, $fSecTry = False)
; Description::    Connect to the Freedb.org Database
; Parameter(s):    $sQuery: The Query Returned e.g. by _CDDBCreateQuery
; Requirement(s):  Internet Connection
; Return Value(s): On Success: Returns the string received from freedb.org in "INI format"
;			: On Error:
;			: @error = 1 - Wrong Query
;			: @error = 2 - Failed to get the IP from freedb.org
;			: @error = 3 - Failed to connect to freedb.org
;			: @error = 4 - Error on freedb.org - Freedb is not ready (maybe too much Clients)
;			: @error = 5 - Error on freedb.org - Authorization failed
;			: @error = 6 - Error on freedb.org - Failed to set protocol ID
;			: @error = 7 - Error on freedb.org - No matches found
;			: @error = 8 - Error on freedb.org - No informations found
; Author(s):       GtaSpider
;
;===============================================================================
;
Func _FreeDBRecvDB($sQuery, $wait, $fSecTry = False)
	Local $sIP, $hSocket, $sCDChcksum
	$sCDChcksum = StringRegExp($sQuery, "cddb query (.*?) ", 3)
	If @error Or (Not IsArray($sCDChcksum)) Then Return SetError(1, 0, 0)
	$sCDChcksum = $sCDChcksum[0]
	TCPStartup()
	;$sIP = TCPNameToIP("freedb.freedb.org")
	$sIP = TCPNameToIP("mirror1.freedb.org")
	If @error Or (Not StringLen($sIP)) Then Return SetError(2, 0, 0)
	$hSocket = TCPConnect($sIP, 8880)
	If @error Then Return SetError(3, @error, 0)
	$sRecv = __TCPRecv($hSocket)
	If (Not StringInStr($sRecv, "201")) And (Not StringInStr($sRecv, "ready")) Then Return SetError(4, 0, $sRecv)
	TCPSend($hSocket, "cddb hello GtaSpider AutoIt AutoIt " & @AutoItVersion & @CRLF)
	$sRecv = __TCPRecv($hSocket)
	If Not StringInStr($sRecv, "200 Hello and welcome") Then Return SetError(5, 0, $sRecv)

	TCPSend($hSocket, "proto 5" & @CRLF)
	$sRecv = __TCPRecv($hSocket)
	If Not StringInStr($sRecv, "201 OK, CDDB protocol level now: 5") Then Return SetError(6, 0, $sRecv)
	
	TCPSend($hSocket, $sQuery & @CRLF)
	$sRecv = __TCPRecv($hSocket) ; genre CDID Artist / CDName, z.B. 200 rock b009520e Green Day / Dookie
	If StringInStr($sRecv, "211 Found inexact matches") And $fSecTry = False Then
		TCPCloseSocket($hSocket)
		TCPShutdown()
		Return _FreeDBRecvDB(StringReplace($sQuery, $sCDChcksum, StringLower(Hex(Number("0x" & $sCDChcksum) - 0x200, 8))), $wait, True)
	ElseIf StringInStr($sRecv, "211 Found inexact matches") And $fSecTry Then
		Return $sRecv
	EndIf
	If Not StringInStr($sRecv, "200") Then Return SetError(7, 0, $sRecv)
	$aSS = StringSplit($sRecv, " ")
	$recval = TCPSend($hSocket, "cddb read " & $aSS[2] & " " & $sCDChcksum & @CRLF)
	
	If $wait <> "" Then Sleep($wait)
	
	$sRecv = __TCPRecv($hSocket)
	If Not StringInStr($sRecv, "210") Then Return SetError(8, 0, $sRecv)
	Return $sRecv
EndFunc   ;==>_FreeDBRecvDB

;===============================================================================
;
; Function Name:   _FreeDBRetCDInfos($sDatabase)
; Description::    Returns Artist, Albumname, Genre, Year and other informations of the CD in an array
; Parameter(s):    $sDatabase - The Databasestring from e.g. _FreeDBRecvDB
; Requirement(s):  -
; Return Value(s): On Success: Returns an array with following informations:
;			: $aRet[0] = Artist
;			: $aRet[1] = Album
;			: $aRet[2] = Genre
;			: $aRet[3] = Year
;			: $aRet[4] = Other Informations
; Author(s):       GtaSpider
;
;===============================================================================
;
Func _FreeDBRetCDInfos($sDatabase)
	Local $aSS, $aRet[5], $sRDB
	$sRDB = __ReadDatabase($sDatabase, "DTITLE")
	If @error Then
		$aRet[0] = "NO ARTIST"
		$aRet[1] = "NO ALBUM"
	Else
		$aSS = StringSplit($sRDB, " / ", 1)
		If $aSS[0] < 2 Then
			$aRet[0] = __ReadDatabase($sDatabase, "DTITLE")
		Else
			$aRet[0] = $aSS[1]
			$aRet[1] = $aSS[2]
		EndIf
	EndIf
	$sRDB = __ReadDatabase($sDatabase, "DGENRE")
	If @error Then
		$aRet[2] = "NO GENRE"
	Else
		$aRet[2] = $sRDB
	EndIf
	$sRDB = __ReadDatabase($sDatabase, "DYEAR")
	If @error Then
		$aRet[3] = "NO YEAR"
	Else
		$aRet[3] = $sRDB
	EndIf
	$sRDB = __ReadDatabase($sDatabase, "EXTD")
	If @error Then
		$aRet[4] = "NO EXTD"
	Else
		$aRet[4] = $sRDB
	EndIf
	
	Return $aRet
EndFunc   ;==>_FreeDBRetCDInfos

;===============================================================================
;
; Function Name:   _FreeDBRetCDTracks($sDatabase)
; Description::    Returns tracks, length of tracks and position of tracks of the CD in an 2D array
; Parameter(s):    $sDatabase - The Databasestring from e.g. _FreeDBRecvDB
; Requirement(s):  -
; Return Value(s): On Success returns an 0 based 2D array:
;			: $aRet[0][0] = First track name
;			: $aRet[0][1] = First track length
;			: $aRet[0][2] = First track position
;			: $aRet[n][0] = n track name
;			: ....
; Author(s):       GtaSpider
;
;===============================================================================
;
Func _FreeDBRetCDTracks($sDatabase)
	Local $aRet[1][1], $sRead, $iTotal
	$iTotal = __SendMCIString("status cd1 number of tracks wait")
	If @error Then Return SetError(1, 0, 0)
	ReDim $aRet[$iTotal][3]
	;MsgBox(262144, "Number Of Tracks", $iTotal)
	;MsgBox(262144, "$sDatabase", $sDatabase)
	;_FileCreate(@ScriptDir & "\CDDB_capture.txt")
	;_FileWriteToLine(@ScriptDir & "\CDDB_capture.txt", 1, $sDatabase, 1)
	For $i = 1 To $iTotal
		$sRead = __ReadDatabase($sDatabase, "TTITLE" & $i - 1)
		If @error Or $sRead = '' Then
			Return SetError(2, 0, 0)
		EndIf
		$aRet[$i - 1][0] = $sRead
		$aMSF = __SplitMSF(__SendMCIString("status cd1 length track " & $i))
		If @error Then Return SetError(3, 0, 0)
		$aRet[$i - 1][1] = $aMSF[1] & ":" & StringTrimLeft("00", StringLen(Round(Number($aMSF[2] & "." & $aMSF[3])))) & Round(Number($aMSF[2] & "." & $aMSF[3]))
		$aMSF = __SplitMSF(__SendMCIString("status cd1 position track " & $i))
		If @error Then Return SetError(3, 1, 0)
		$aRet[$i - 1][2] = $aMSF[1] & ":" & StringTrimLeft("00", StringLen(Round(Number($aMSF[2] & "." & $aMSF[3])))) & Round(Number($aMSF[2] & "." & $aMSF[3]))
	Next
	Return $aRet
EndFunc   ;==>_FreeDBRetCDTracks




Func __CDDBGetTrack($iTrack)
	Local $sRet = __SendMCIString("status cd1 position track " & $iTrack), $aMSF
	If @error Then Return SetError(1, 0, 0)
	$aMSF = __SplitMSF($sRet)
	If @error Then Return SetError(2, @extended, 0)
	Return ($aMSF[1] * 75 * 60) + ($aMSF[2] * 75) + $aMSF[3]
EndFunc   ;==>__CDDBGetTrack

Func __CDDBGetLeadOut()
	Local $sRet = __SendMCIString("status cd1 length wait"), $aMSF
	If @error Then Return SetError(1, 0, 0)
	$aMSF = __SplitMSF($sRet)
	If @error Then Return SetError(2, @extended, 0)
	Return ($aMSF[1] * 60) + $aMSF[2] + 2
EndFunc   ;==>__CDDBGetLeadOut

Func __CDDBSum($iSum)
	Local $aSS = StringSplit($iSum, ""), $iRet
	For $i = 1 To $aSS[0]
		$iRet += Number($aSS[$i])
	Next
	Return $iRet
EndFunc   ;==>__CDDBSum

Func __CDDBGetCDID($iTotal)
	Local $iChecksum
	For $i = 1 To $iTotal
		$sRet = __SendMCIString("status cd1 position track " & $i)
		$aMSF = __SplitMSF($sRet)
		If @error Then Return SetError(1, @extended, 0)
		$iChecksum += __CDDBSum($aMSF[1] * 60 + $aMSF[2])
	Next
	$aMSF = __SplitMSF(__SendMCIString("status cd1 length wait"))
	If @error Then Return SetError(1, @extended, 0)
	$leadout = ($aMSF[1] * 60 * 75 + ($aMSF[2]) * 75 + $aMSF[3])
	$tottime = ($leadout / 75) - ($iTotal / 75)
	$iChecksum = BitOR(BitShift(Mod($iChecksum, 0xff), -24), BitShift($tottime, -8), $iTotal)
	Return StringLower(Hex($iChecksum, 8))
EndFunc   ;==>__CDDBGetCDID

Func __SplitMSF($sMSF)
	Local $aSS = StringSplit($sMSF, ":")
	If @error Or $aSS[0] <> 3 Then Return SetError(1, @error, 0)
	Return $aSS
EndFunc   ;==>__SplitMSF

Func __ReadDatabase($sDatabase, $sKey)
	Local $aRet = StringRegExp($sDatabase, $sKey & "=(.*?)\r\n", 3)
	If @error Or IsArray($aRet) = False Then
		;MsgBox(262144, "$aRet", $aRet)
		Return SetError(1, @error, 0)
	EndIf
	Return $aRet[0]
EndFunc   ;==>__ReadDatabase

Func __SendMCIString($sString, $iBuf = 255)
	Local $aRet = DllCall($hWinmmDLL, "int", "mciSendString", "str", $sString, "str", "str", "int", $iBuf, "long", 0)
	If @error Then Return SetError(@error, 0, 0)
	Return $aRet[2]
EndFunc   ;==>__SendMCIString

Func __TCPRecv($hSocket, $iSleep = 50, $iTimeOut = 20000, $iBuffersize = 1024, $iForceBinary = 0)
	Local $sRecv, $sRet, $iErr = 0, $hTi
	$hTi = TimerInit()
	While TimerDiff($hTi) <= $iTimeOut
		$sRecv = TCPRecv($hSocket, $iBuffersize, $iForceBinary)
		$iErr = @error
		If $iErr Then ExitLoop
		While StringLen($sRecv)
			$sRet &= $sRecv
			$sRecv = TCPRecv($hSocket, $iBuffersize, $iForceBinary)
			$iErr = @error
			If (Not StringLen($sRecv)) Or $iErr Then ExitLoop 2
			If TimerDiff($hTi) > $iTimeOut Then ExitLoop
			If StringRight($sRecv, 1) = "." Then ExitLoop 2
		WEnd
		Sleep($iSleep)
	WEnd
	If $sRecv <> "" Then MsgBox(262144, "$sRecv", StringRight($sRecv, 1))
	If TimerDiff($hTi) > $iTimeOut Then Return SetError(1, 0, "Timeout")
	If $iErr Then Return SetError($iErr, 0, 0)
	Return $sRet
EndFunc   ;==>__TCPRecv

