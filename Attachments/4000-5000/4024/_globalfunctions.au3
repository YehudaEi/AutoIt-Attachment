#include-once
; ----------------------------------------------------------------------------
;
; AutoIt Version :	3.1.0
; Author :	Groumphy <groumphy@gmail.com>
;
; Script Function :
;	Alias of some AutoIt functions.
; 	Version : F.O.1
;
; ----------------------------------------------------------------------------

; Print a file by WinShell
; Author : SvenP
Func _FilePrint($FileName)
	Const $SW_SHOWNORMAL = 1
	$aResult = DllCall("shell32.dll","int","ShellExecute","hwnd",0,"str","print","str",$FileName,"str","","str","","int",$SW_SHOWNORMAL)
	return $aResult[0]
EndFunc ; ==> _FilePrint("NomDuFichierEtChemin.pdf")

; Date with european format
; Author : Groumphy
Func _DateHeure()
	Return (@MDAY & "/" & @MON & "/" & @YEAR & " " & @HOUR & ":" & @MIN)
EndFunc ; ==> _DateHeure()

; Search string value in a text file and call function if find or not
; Author : Burrup - Groumphy
Func _FindStringInTextfile($iFile, $iString, $iFunctionIfStringFound, $iFunctionIfStringNotFound)
	; success : ==> Function Call
	; failure : 1 (Incorrect function name for sample)
	$Source = FileRead($iFile,FileGetSize($iFile))
	If @error Then Return 1
	If StringInStr($Source, $iString) Then
		Call($iFunctionIfStringFound)
		If @error Then Return 1
	Else
		Call($iFunctionIfStringNotFound)
		If @error Then Return 1
	EndIf
EndFunc ; ==> _FindStringInTextfile("test.txt", "Xavier", "_iFunctionIfStringFound", "_iFunctionIfStringNotFound")

; Turn Off or Wake up the monitor
; Author : VicTT
; Modified : Groumphy
Func _Monitor($iNum)
	; 0 = Off
	; 1 = On
	; failure = -1
	; success = -2
	const $WM_SYSCommand = 274, $SC_MonitorPower = 61808, $Power_On = -1, $Power_Off = 2
	$HWND = WinGetHandle(WinGetTitle("",""))
	If $iNum = 0 Then
		DllCall("user32.dll","int","SendMessage","hwnd",$HWND,"int",$WM_SYSCommand,"int",$SC_MonitorPower,"int",$Power_Off)
				If @error Then
			Return -1
		Else
			Return -2
		EndIf
		Exit
	ElseIf $iNum = 1 Then
		DllCall("user32.dll","int","SendMessage","hwnd",$HWND,"int",$WM_SYSCommand,"int",$SC_MonitorPower,"int",$Power_On)
		If @error Then
			Return -1
		Else
			Return -2
		EndIf
		Exit
	Else
		Return -1
		Exit
	EndIf
EndFunc ; ==> _Monitor(1)

; Fades a window in or out if the OS supports it.
; Author(s) : CodeMaster Rapture
; Option : _Fade(Window Title [,Fade in/out, Speed])
Func _Fade($Window, $Fade = 1, $Speed = 10)
    If (NOT IsInt($Fade)) OR (($Fade <> 1) AND ($Fade <> -1)) Then
        MsgBox(16, "Error", "Illegal call to Fade Function: $Fade only allows integers of 1 or -1.")
        Exit
    ElseIf (NOT WinExists($Window)) Then
        MsgBox(16, "Error", "Could not find Window titled: " & $Window & ". Exiting.")
        Exit
    ElseIf (NOT IsString($Window)) Then
        MsgBox(16, "Error", "Illegal call to Fade Function: $Window must be a string.")
        Exit
    ElseIF ($Window == "") Then
        MsgBox(16, "Error", "Illegal call to Fade Function: No Window specified.")
        Exit
    ElseIf (NOT IsNumber($Speed)) Then
        MsgBox(16, "Error", "Illegal call to Fade Function: $Speed must be a number.")
        Exit
    ElseIf ($Speed < 1) Then
        $Speed = 1)
    ElseIf ($Speed > 10) Then
        $Speed = 10
    EndIf
    WinSetTrans($Title, "", 255)
    If NOT @error Then     ; If the OS doesn't supporty Transparencies, don't fade.
        If $Fade = 1 Then
        ;Fade-In
            For $loop = 1 to 255 Step 1
                WinSetTrans($Title, "", $loop)
                Sleep(10-$Speed)
            Next
        Else
        ;Fade-Out
            For $loop = 255 to 1 Step -1
                WinSetTrans($Title, "", $loop)
                Sleep(10-$Speed)
            Next
        EndIf
    EndIf
EndFunc ; ==> _Fade("Notepad")

; Remove the content of a folder
; Author(s) : eJan
Func _DirRemoveContents($sPath)
	; failure : 0
	; success : 1
    Local $sPattern
    Local $sFile
    Local $hFile
    If StringRight($sPath, 1) <> "\" Then $sPath = $sPath & "\"
    $sPattern = $sPath & "*.*"
    If Not FileExists($sPath) Then Return 0
    FileDelete($sPattern)
    $hFile = FileFindFirstFile($sPattern)
    If @error Then Return 0
    While 1
        $sFile = FileFindNextFile($hFile)
        If @error Then ExitLoop
        If $sFile <> "." And $sFile <> ".." Then
            If StringInStr( FileGetAttrib($sPath & $sFile), "D") Then
                DirRemove($sPath & $sFile, 1)
            EndIf
        EndIf
    WEnd
    FileClose($hFile)
    Return 1
EndFunc ; ==> _DirRemoveContents("C:\my_folder")

; Show Desktop
; Author(s) : Wouter & Groumphy
Func _ShowDesktop()
	Return Send("#d")
EndFunc