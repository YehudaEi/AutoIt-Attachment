#Region Header

#cs

    Title:          Event Log Files UDF Library for AutoIt3
    Filename:       Protect.au3
    Description:    Creates and writes the user's event messges into the text files (log)
    Author:         Yashied
    Version:        1.0
    Requirements:   AutoIt v3.3 +, Developed/Tested on WindowsXP Pro Service Pack 2
    Uses:           None
    Notes:          -

    Available functions:

    _Log_Close
    _Log_Open
    _Log_Report

    Example:

        #Include <Log.au3>

        Opt('MustDeclareVars', 1)

        Global $hLog, $Time

        $hLog = _Log_Open(@ScriptDir & '\MyProg.log', '###Event Log Files UDF Exaple###')
        _Log_Report($hLog, 'Program start', 6)
        _Log_Report($hLog, 'Pinging www.autoitscript.com...', 8)
        $Time = Ping('www.autoitscript.com')
        If $Time Then
            _Log_Report($hLog, 'Ping is successful, Time = ' & $Time & ' ms', 5)
        Else
            Switch @error
                Case 1
                    _Log_Report($hLog, 'Ping is fails, host is offline', 1)
                Case 2
                    _Log_Report($hLog, 'Ping is fails, host is unreachable', 2)
                Case 3
                    _Log_Report($hLog, 'Ping is fails, bad destination', 3)
                Case Else
                    _Log_Report($hLog, 'Ping is fails, unknown error', 4)
            EndSwitch
        EndIf
        _Log_Report($hLog, 'Program exit', 7)
        _Log_Close($hLog)

#ce

#Include-once

#EndRegion Header

#Region Local Variables and Constants

Dim $__Log[1][8] = [[0]]

#cs

DO NOT USE THIS ARRAY IN THE SCRIPT, INTERNAL USE ONLY!

$__Log[0][0]   - Number of items in array
      [0][1-7] - Don`t used

$__Log[i][0]   - The fully-qualified path to the log file
      [i][1]   - Handle to the log file
      [i][2]   - The first event report control flag
      [i][3]   - The empty log control flag
      [i][4]   - The previous date/time string
      [i][5]   - The date format
      [i][6]   - The time format
      [i][7]   - Reserved

#ce

#EndRegion Local Variables and Constants

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Name...........: _Log_Close
; Description....: Closes a log file.
; Syntax.........: _Log_Close ( $hLog [, $fDelete] )
;                  $hLog    - Handle to an open log file. This handle is returned by the _Log_Open() function.
;                  $fDelete - Specifies whether deletes a log file after its closure, valid values:
;                  |TRUE    - The log file will be deleted if function succeeds.
;                  |FALSE   - Don't deleted. (Default)
; Return values..: Success  - 1.
;                  Failure  - 0.
; Author.........: Yashied
; Modified.......:
; Remarks........: None
; Related .......:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _Log_Close($hLog, $fDelete = 0)

	Local $Ret

	For $i = 1 To $__Log[0][0]
		If $__Log[$i][1] = $hLog Then
			$Ret = DllCall('kernel32.dll', 'int', 'CloseHandle', 'ptr', $__Log[$i][1])
			If (@error) Or (Not $Ret[0]) Then
				Return 0
			EndIf
			If ($fDelete) Or ($__Log[$i][3]) Then
				FileDelete($__Log[$i][0])
			EndIf
			For $j = $i To $__Log[0][0] - 1
				For $k = 0 To 7
					$__Log[$j][$k] =  $__Log[$j + 1][$k]
				Next
			Next
			ReDim $__Log[$__Log[0][0]][8]
			$__Log[0][0] -= 1
			Return 1
		EndIf
	Next
	Return 0
EndFunc   ;==>_Log_Close

; #FUNCTION# ====================================================================================================================
; Name...........: _Log_Open
; Description....: Opens to use a log file.
; Syntax.........: _Log_Open ( $sFile [, $sName [, $fErase [, $sDate [, $sTime [, $iSize]]]]] )
;                  $sFile  - The name of a file (.log). If the file does not exist, it will be created.
;                  $sName  - The name of a log. This can be any text that is placed in the first line of a log file.
;                  $fErase - Specifies whether erases the contents of a log file, valid values:
;                  |TRUE   - The log file will be erased if function succeeds.
;                  |FALSE  - Don't erased. (Default)
;                  $sDate  - The format picture string that is used to form the date, for example "yyyy-MM-dd".
;                  $sTime  - The format picture string that is used to form the time, for example "HH:mm:ss".
;                  $iSize  - The maximum size of a log file, in kilobytes. If the file size exceeds this value, the contents of a log
;                            file will be reduced by half, starting with the first record. This parameter must be between 1 to 8192,
;                            otherwise, the function fails. Default is 64 KB.
; Return values..: Success - The handle to a log file.
;                  Failure - 0.
; Author.........: Yashied
; Modified.......:
; Remarks........: The opened log file will be accessed for other applications as read-only.
; Related .......:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _Log_Open($sFile, $sName = '', $fErase = 0, $sDate = '', $sTime = '', $iSize = 64)

	If ($iSize < 1) Or ($iSize > 8192) Then
		Return 0
	EndIf

	Local $hFile, $tData, $Ret, $Size, $Text

	$tData = DllStructCreate('wchar[1024]')
	$Ret = DllCall('shlwapi.dll', 'int', 'PathSearchAndQualifyW', 'wstr', StringStripWS($sFile, 7), 'ptr', DllStructGetPtr($tData), 'int', 1024)
	If (@error) Or (Not $Ret[0]) Then
		Return 0
	EndIf
	$sFile = DllStructGetData($tData, 1)
	If Not $sFile Then
		Return 0
	EndIf
	For $i = 1 To $__Log[0][0]
		If $__Log[$i][0] = $sFile Then
			Return 0
		EndIf
	Next
	If Not $fErase Then
		$Size = FileGetSize($sFile)
		If $Size > $iSize * 1024 Then
			$Text = FileRead($sFile)
			If @error Then
				Return 0
			EndIf
			$Pos = StringInStr($Text, @CRLF & @CRLF, 0, -1, $Size / 2)
			If Not $Pos Then
				$fErase = 1
			Else
				$Text = StringTrimLeft($Text, $Pos + 3)
				If $sName Then
					$Text  = $sName & @CRLF & @CRLF & $Text
				EndIf
				$hFile = FileOpen($sFile, 2)
				$Ret = FileWrite($hFile, $Text)
				FileClose($hFile)
				If Not $Ret Then
					Return 0
				EndIf
			EndIf
		EndIf
	EndIf
	If $fErase Then
		$Size = 0
		If (FileExists($sFile)) And (Not FileDelete($sFile)) Then
			Return 0
		EndIf
	EndIf
	$Ret = DllCall('kernel32.dll', 'ptr', 'CreateFileW', 'wstr', $sFile, 'dword', 0xC0000000, 'dword', 1, 'ptr', 0, 'dword', 4, 'dword', 0, 'ptr', 0)
	If (@error) Or ($Ret[0] = -1) Then
		Return 0
	EndIf
	$hFile = $Ret[0]
	DllCall('kernel32.dll', 'int', 'SetFilePointer', 'ptr', $hFile, 'long', 0, 'ptr', 0, 'dword', 2)
	If ($sName) And (Not $Size) Then
		$sName &= @CRLF
		$tData = DllStructCreate('char[' & StringLen($sName) & ']')
		DllStructSetData($tData, 1, $sName)
		$Ret = DllCall('kernel32.dll', 'int', 'WriteFile', 'ptr', $hFile, 'ptr', DllStructGetPtr($tData), 'dword', DllStructGetSize($tData), 'dword*', 0, 'ptr', 0)
		If (@error) Or (Not $Ret[0]) Then
			DllCall('kernel32.dll', 'int', 'CloseHandle', 'ptr', $hFile)
			If $fErase Then
				FileDelete($sFile)
			EndIf
			Return 0
		EndIf
	EndIf
	If Not StringStripWS($sDate, 3) Then
		$sDate = 'yyyy-MM-dd'
	EndIf
	If Not StringStripWS($sTime, 3) Then
		$sTime = 'HH:mm:ss'
	EndIf
	$__Log[0][0] += 1
	ReDim $__Log[$__Log[0][0] + 1][8]
	$__Log[$__Log[0][0]][0] = $sFile
	$__Log[$__Log[0][0]][1] = $hFile
	$__Log[$__Log[0][0]][2] = 0
	$__Log[$__Log[0][0]][3] = ($Size = 0)
	$__Log[$__Log[0][0]][4] = 0
	$__Log[$__Log[0][0]][5] = $sDate
	$__Log[$__Log[0][0]][6] = $sTime
	$__Log[$__Log[0][0]][7] = 0
	Return $hFile
EndFunc   ;==>_Log_Open

; #FUNCTION# ====================================================================================================================
; Name...........: _Log_Report
; Description....: Writes a specified event to the log file.
; Syntax.........: _Log_Report ( $hLog [, $sEvent [, $iID [, $tTime]]] )
;                  $hLog   - Handle to an open log file. This handle is returned by the _Log_Open() function.
;                  $sEvent - The event description. This can be any string that not contains @CR and @LF characters.
;                  $iID    - The event ID. This can be any number from 1 to 9999. If this parameter is 0, ID will be ignored, and not
;                            be written to a log file.
;                  $tTime  - $tagSYSTEMTIME structure that contains the date and time information. If $tTime is 0, the current
;                            date and time is used.
; Return values..: Success - 1.
;                  Failure - 0.
; Author.........: Yashied
; Modified.......:
; Remarks........: This function writes data to a log file in the following format.
;
;                  "date" "time" "(event ID)" "event description"
;
; Related .......:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _Log_Report($hLog, $sEvent = '', $iID = 0, $tTime = 0)

	Local $Index = 0

	For $i = 1 To $__Log[0][0]
		If $__Log[$i][1] = $hLog Then
			$Index = $i
			ExitLoop
		EndIf
	Next
	If Not $Index Then
		Return 0
	EndIf

	Local $tData, $Ret, $Text, $Date = ''

	$tData = DllStructCreate('wchar[1024]')
	$Ret = DllCall('kernel32.dll', 'int', 'GetDateFormatW', 'long', 0x0400, 'dword', 0, 'ptr', DllStructGetPtr($tTime), 'wstr', $__Log[$Index][5], 'ptr', DllStructGetPtr($tData), 'int', 1024)
    If (@error) Or (Not $Ret[0]) Then
		Return 0
	EndIf
	$Date &= DllStructGetData($tData, 1) & '  '
	$Ret = DllCall('kernel32.dll', 'int', 'GetTimeFormatW', 'long', 0x0400, 'dword', 0, 'ptr', DllStructGetPtr($tTime), 'wstr', $__Log[$Index][6], 'ptr', DllStructGetPtr($tData), 'int', 1024)
    If (@error) Or (Not $Ret[0]) Then
		Return 0
	EndIf
	$Date &= DllStructGetData($tData, 1)
	If ($tTime = -1) And ($__Log[$Index][2]) Then
		$Text = $__Log[$Index][4]
	Else
		$Text = $Date
	EndIf
	If $iID Then
		$Text &= '  (' & StringFormat('%04d', $iID) & ')'
;~		$Text &= '  (#' & Hex($iID, 4) & ')'
	EndIf
	$sEvent = StringReplace(StringReplace(StringStripWS($sEvent, 3), @CR, ''), @LF, '')
	If $sEvent Then
		$Text &= '  ' & $sEvent
	EndIf
	If Not $__Log[$Index][2] Then
		$Text = @CRLF & $Text
	EndIf
	$Text &= @CRLF
	$tData = DllStructCreate('char[' & StringLen($Text) & ']')
	DllStructSetData($tData, 1, $Text)
	$Ret = DllCall('kernel32.dll', 'int', 'WriteFile', 'ptr', $__Log[$Index][1], 'ptr', DllStructGetPtr($tData), 'dword', DllStructGetSize($tData), 'dword*', 0, 'ptr', 0)
	If (@error) Or (Not $Ret[0]) Then
		Return 0
	EndIf
	$__Log[$Index][2] = 1
	$__Log[$Index][3] = 0
	$__Log[$Index][4] = $Date
	Return 1
EndFunc   ;==>_Log_Report

#EndRegion Public Functions
