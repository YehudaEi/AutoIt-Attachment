#include <Date.au3>
#include <Array.au3>
#include <File.au3>
#include <Email.au3>

$FolderList = _ArrayCreate("E:\LSR2\HAI-002", "E:\LSR2\HAI-003", "E:\LSR2\HAI-008", "E:\LSR2\HAI-009", "E:\LSR2\HAI-010", "E:\LSR2\HAI-012");<----Substitute these with your folders

For $Fdlr = 0 to 4; <----Number of entries above minus 1
    EvaluateFiles($FolderList[$Fdlr])
Next

Func EvaluateFiles($Folder)
    $avFiles = _FileListToArray($Folder & "\", "*",1)
    If @Error<>0 Then
        Return
    EndIf
    
    $iNewestTime = 11111111111111; YYYYMMDDhhmmss
    $iNewestIndex = 0; Array index of newest file
; Find the newest file
    For $p = 1 To $avFiles[0]
        $iFileTime2 = Number(FileGetTime($Folder & "\" & $avFiles[$p], 0, 1))
        If $iFileTime2 > $iNewestTime Then
            $iNewestTime = $iFileTime2
            $iNewestIndex = $p
        EndIf
    Next

    
    If $iNewestIndex > 0 Then
        $t = FileGetTime($Folder & "\" & $avFiles[$iNewestIndex])
        $iDateCalc = _DateDiff( 'd',$t[0] & "/" & $t[1] & "/" & $t[2] & " " & $t[3] & ":" & $t[4] & ":" & $t[5],_NowCalc())
        If $iDateCalc > 0 Then;<---Flags files that are older than today
            MsgBox(16,"ATTENTION","The files in - " & $Folder & " - have not been updated today." & @CRLF & @CRLF & $avFiles[$iNewestIndex] & " is the newest file with a modified date of" & @CRLF & @CRLF & $t[1] & "/" & $t[2] & "/" & $t[0] & " " & $t[3] & ":" & $t[4] & ":" & $t[5])
        
		
		Global $oMyRet[2]
		Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
		_INetSmtpMailCom("server", "From", "Something@something.com", "it@there.com", $Folder & " failed backup!", "The files in - " & $Folder & " - have not been updated today." & @CRLF & @CRLF & $avFiles[$iNewestIndex] & " is the newest file with a modified date of" & @CRLF & @CRLF & $t[1] & "/" & $t[2] & "/" & $t[0] & " " & $t[3] & ":" & $t[4] & ":" & $t[5], "")
		If @error then
			msgbox(0,"Error sending message","Error code:" & @error & "  Description:" & $rc)
		EndIf
		
		;PUT YOUR CODE FOR EMAILING HERE.  USE $avFiles[$iNewestIndex] TO REFERENCE THE FILE NAME IF YOU NEED TO
        EndIf
    Else
        MsgBox(16, "Error", _NowCalc() & " Failed to find a newest file.")
    EndIf

EndFunc	 