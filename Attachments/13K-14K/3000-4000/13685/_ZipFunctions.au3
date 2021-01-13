#include-once
;======================================
;     _ZipFunctions.au3 -- v1.0 -- 20 June, 2006
;         An AutoIT User Defined Function (UDF) file.
;
;         Requires AutoIT 3.1.127 or later.
;         Uses the native compression API of Windows XP, Windows 2003, or later.
;
;     By PsaltyDS at http://www.autoitscript.com/forum
;        Includes code from other forum users, especially as posted at:
;            http://www.autoitscript.com/forum/index.php?showtopic=21004
;
;     Includes the following functions:
;         _ZipCreate($sZip, $iFlag = 0)
;         _ZipAdd($sZip, $sSrc)
;         _ZipList($sZip)
;         _UnZip($sZip, $sDest)
;     See each function below for full usage.
;======================================

;----------------------------------
; Function _ZipCreate($sZip, $iFlag = 0)
;     Creates an empty .zip archive file.
;     Where:
;         $sZip is the .zip file to create
;         $iFlag: 0 = prompts to overwrite (default)
;                 1 = overwrite without prompt
;     Returns 1 on success, 0 for fail
;   On fail, @Error is:
;         1 = Not permitted to overwrite
;         2 = FileOpen failed
;       3 = FileWrite failed
;----------------------------------
Func _ZipCreate($sZip, $iFlag = 0)
; Test zip file
    If FileExists($sZip) Then
        If Not $iFlag Then
            If MsgBox(32 + 4, "Zip Functions UDF", "Click YES to overwrite existing archive file: " & @CRLF & _
                    @TAB & $sZip) <> 6 Then Return SetError(1, 0, 0)
        EndIf
    EndIf
; Create header data
    Local $sHeader = Chr(80) & Chr(75) & Chr(5) & Chr(6)
    For $i = 1 To 18
        $sHeader &= Chr(0)
    Next
; Create empty zip file
    $hFile = FileOpen($sZip, 8 + 2); Mode = Create folder, Overwrite
    If $hFile <> - 1 Then
        If FileWrite($hFile, $sHeader) Then
            FileClose($hFile)
            Return 1
        Else
            Return SetError(3, 0, 0)
        EndIf
    Else
        Return SetError(2, 0, 0)
    EndIf
EndFunc  ;==>_ZipCreate


;----------------------------------
; Function _ZipAdd($sZip, $sSrc)
;     Adds a file or folder to a pre-existing .zip archive.
;     Where:
;         $sZip is the .zip file to add to
;         $sSrc is the source file or folder to add
;     Returns 1 on success, 0 for fail
;   On fail, @Error is:
;         1 = Creating Zip file failed [@Extended = @Error from _ZipCreate()]
;         2 = Source did not exist
;       3 = Shell ObjCreate error
;       4 = Zip file namespace object error
;         5 = Error copying data
;----------------------------------
Func _ZipAdd($sZip, $sSrc)
; Test zip file and create if required
    If Not FileExists($sZip) Then
        If Not _ZipCreate($sZip) Then Return SetError(1, @error, 0)
    EndIf
; Test source
    If FileExists($sSrc) Then
    ; Create shell object
        Local $oShell = ObjCreate('Shell.Application')
        If Not @error And IsObj($oShell) Then
        ; Get zip file object
            Local $oFolder = $oShell.NameSpace ($sZip)
            If Not @error And IsObj($oFolder) Then
            ; Copy source file or folder to zip file
                If StringInStr(FileGetAttrib($sSrc), "D") Then
                    $oFolder.CopyHere ($oShell.NameSpace ($sSrc).items)
                Else
                    $oFolder.CopyHere ($sSrc)
                EndIf
                Sleep(1000)
                If @error Then
                    Return SetError(5, 0, 0)
                Else
                    Return 1
                EndIf
            Else
                Return SetError(4, 0, 0)
            EndIf
        Else
            Return SetError(3, 0, 0)
        EndIf
    Else
        Return SetError(2, 0, 0)
    EndIf
EndFunc  ;==>_ZipAdd


;----------------------------------
; Function _ZipList($sZip)
;     List the contents of a .zip archive file
;     Where: $sZip is the .zip file
;     On Success, returns a 1D array of items in the zip file, with [0]=count
;   On fail, returns array with [0]=0 and @Error is:
;         1 = Zip file did not exist
;       2 = Shell ObjCreate error
;       3 = Zip file namespace object error
;         4 = Error copying data
;----------------------------------
Func _ZipList($sZip)
    Local $aNames[1] =[0], $i
; Test zip file
    If FileExists($sZip) Then
    ; Create shell object
        Local $oShell = ObjCreate('Shell.Application')
        If Not @error And IsObj($oShell) Then
        ; Get zip file object
            Local $oFolder = $oShell.NameSpace ($sZip)
            If Not @error And IsObj($oFolder) Then
            ; Get list of items
                Local $oItems = $oFolder.Items ()
                If Not @error And IsObj($oItems) Then
                ; Read items into array
                    For $i In $oItems
                        $aNames[0] += 1
                        ReDim $aNames[$aNames[0] + 1]
                        $aNames[$aNames[0]] = $oFolder.GetDetailsOf ($i, 0)
                    Next
                Else
                    SetError(4)
                EndIf
            Else
                SetError(3)
            EndIf
        Else
            SetError(2)
        EndIf
    Else
        SetError(1)
    EndIf
    Return $aNames
EndFunc  ;==>_ZipList


;----------------------------------
; Function _UnZip($sZip, $sDest)
;     Uncompress items from a .zip file a destination folder.
;     Where:
;         $sZip is the .zip file
;         $sDest is the folder to uncompress to (without trailing '\')
;     Returns 1 on success, 0 for fail
;   On fail, @Error is:
;         1 = Source zip file did not exist
;         2 = Error creating destination folder
;       3 = Shell ObjCreate error
;       4 = Zip file namespace object error
;         5 = Error creating item list object
;         6 = Destination folder namespace object error
;         7 = Error copying data
;----------------------------------
Func _UnZip($sZip, $sDest)
; Test zip file
    If FileExists($sZip) Then
    ; Test destination folder
        If Not FileExists($sDest & "\") Then
            If Not DirCreate($sDest) Then Return SetError(2, 0, 0)
        EndIf
    ; Create shell object
        Local $oShell = ObjCreate('Shell.Application')
        If Not @error And IsObj($oShell) Then
        ; Get zip file namespace object
            Local $oFolder = $oShell.NameSpace ($sZip)
            If Not @error And IsObj($oFolder) Then
            ; Get list of items in zip file
                Local $oItems = $oFolder.Items ()
                If Not @error And IsObj($oItems) Then
                ; Get destination folder namespace object
                    $oDest = $oShell.NameSpace ($sDest & "\")
                    If Not @error And IsObj($oDest) Then
                    ; Copy the files
                        $oDest.CopyHere ($oItems)
                        Sleep(500)
                        If @error = 0 Then
                            Return 1
                        Else
                            Return SetError(7, 0, 0)
                        EndIf
                    Else
                        Return SetError(6, 0, 0)
                    EndIf
                Else
                    Return SetError(5, 0, 0)
                EndIf
            Else
                Return SetError(4, 0, 0)
            EndIf
        Else
            Return SetError(3, 0, 0)
        EndIf
    Else
        Return SetError(1, 0, 0)
    EndIf
EndFunc  ;==>_UnZip