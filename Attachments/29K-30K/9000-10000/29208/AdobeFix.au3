Global $debug = False
Global $ver
start()

Func start()    
    If Not FileExists(@SystemDir & '\Macromed\Flash\NPSWF32.dll') Then
        FindDll('NPSWF32.dll')
    Else
        VerifyDll(@SystemDir & '\Macromed\Flash\NPSWF32.dll')
    EndIf
EndFunc

Func VerifyDll($sDll)
    Local $sVer,$oFSO
    $oFSO = ObjCreate("Scripting.FileSystemObject")
    $sVer = $oFSO.GetFileVersion( $sDll )
	If $sVer = '10.0.22.87' Then
		$ver = '2287'
	ElseIf $sVer = '10.0.32.18' Then
		$ver = '3218'
	ElseIf $sVer = '10.0.42.34' Then
		$ver = '4234'
	Else
		If $debug Then ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') Version <> 10.0.22.87' & @crlf);### Debug Console
        If Not WrongVersion($sVer,'10.0.22.87, 10.0.32.18, or 10.0.42.34') Then
            $oFSO = ""
            Exit
        EndIf
		$ver = '4234'
	EndIf
    $oFSO = ""
    Openit($sDll)
EndFunc

Func Openit($sDll)
    Local $hDLL, $bFile
    $hDLL = FileOpen($sDll,16)
    If @error = -1 Then
        If $debug Then ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') File open (read binary mode) failed' & @crlf);### Debug Console
        FileOpenFail()
        Exit
    EndIf
    $bFile = FileRead($hDLL)
    If @error = 1 Then
        If $debug Then ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') Read failed' & @crlf);### Debug Console
        FileReadFail()
        Exit
    EndIf    
    FileClose($hDLL)
	PatchIt($bFile,$sDll,'2287',3771296,1270591)
	PatchIt($bFile,$sDll,'3218',3883424,1274696)
	PatchIt($bFile,$sDll,'4234',3885984,1276282)
	Exit
EndFunc

Func PatchIt(byref $bFile,$sDll,$sV,$nL,$nO)
	If $ver <> $sV then return
	
	Local $bReplace, $bReplacement, $bPart1, $bPart2, $bTarget, $hDLL
	
	If BinaryLen($bFile) <> $nL Then
		If Not WrongSize(BinaryLen($bFile),$nL) Then Exit
	EndIf
	$bPart1 = BinaryMid($bFile, 1, $nO)
	$bTarget = BinaryMid($bFile, $nO + 1, 2)
	$bPart2 = BinaryMid($bFile, $nO + 3, BinaryLen($bFile))


   If $bTarget = Binary("0x0074") Then
        $bTarget = Binary("0x00EB")
        $ReplacementMsg = '      0xEB Indicates that this file is not currently pathed.      ' & @CRLF & @CRLF & '      Would you like to patch it now?'
    ElseIf $bTarget = Binary("0x00EB") Then
        $bTarget = Binary("0x0074")
        $ReplacementMsg = '      0x74 Indicates that this file has been patched.      ' & @CRLF & @CRLF & '      Would you like to remove the patch?'
    Else
        If $debug Then ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') Byte not match 74 or EB' & @crlf);### Debug Console
        BinNotMatch($bTarget,Binary("0x0074"))
        Exit
    EndIf
    
    $bReplace = $bPart1 & $bTarget & $bPart2    
    If BinaryLen($bReplace) <> BinaryLen($bFile) Then
        If $debug Then ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') Replacment file length <> Original file length' & @crlf);### Debug Console
        If $debug Then ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $bFile = ' & BinaryLen($bFile) & @crlf & '>Error code: ' & @error & @crlf);### Debug Console
        If $debug Then ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $bReplace = ' & BinaryLen($bReplace) & @crlf & '>Error code: ' & @error & @crlf);### Debug Console
        
        MsgBox(0,'FullScreen Fix - Error','      Critical error: the length of the original file' & @CRLF & '      and the length of the new file would have not been the same.      ' & @CRLF & '      Commit changes to file has beeen aborted. ' & @CRLF & @CRLF & '      Uknown reason how or why this would happen. ' & @CRLF & @CRLF & '      Exiting....' & @CRLF)
        Exit
    EndIf
    If MsgBox(4,'FullScreen Fix - Patch','      Found the target dll file, ' & $sDll & '.' & @CRLF & @CRLF & _
        '      The 2 target bytes equal 0x' & StringRight($bTarget,2) & @CRLF & @CRLF & $ReplacementMsg & @CRLF & @CRLF ) = 6 Then
        $hDLL = FileOpen($sDll,18)
        If @error = -1 Then
        If $debug Then ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') File open (binary overwrite mode) failed' & @crlf);### Debug Console
            FileOpenFail()
            Exit
        EndIf            
        If Not FileWrite($hDLL,$bReplace) Then
        If $debug Then ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') File write failed' & @crlf);### Debug Console
            FileClose($hDLL)
            FileWriteFail()
            Exit
        EndIf
        FileClose($hDLL)
    EndIf
    Exit
EndFunc

Func BinNotMatch($bIs,$bShouldbe)
    MsgBox(0,'FullScreen Fix - Error','      The 2 bytes at location 0x136340,0x137349,or 0x137979 should be' & $bShouldbe & ',      ' & @CRLF & '      however they are ' & $bIs & @CRLF & @CRLF & '       Critical failure...Exiting....'  & @CRLF)
    Return False
EndFunc

Func FileOpenFail()    
    MsgBox(0,'FullScreen Fix - Error','      Unable to open file, File may be in use.      ' & @CRLF & '      Try the following' & @CRLF & '        Quit any applications that maybe using flash.' & @CRLF & '        Restart your system.' & @CRLF & '        Use an account with administrator privledges.' & @CRLF & '        Check permissions to make sure you have read & write privledges.' & @CRLF & @CRLF & '      Critical failure...Exiting....'  & @CRLF & @CRLF)
    Return False
EndFunc

Func WrongVersion($sVerIs, $sVerShouldBe)
    If MsgBox(4,'FullScreen Fix - Error','The dll file version should be' & $sVerShouldBe & ',' & @CRLF & "      however it returned a version of " & $sVerIs & @CRLF & "      It's possible this information is in error." & @CRLF & '      There are a number of additional checks to make sure the wrong file does not get patched      ' & @CRLF & @CRLF & '      Would you like to continue ?' & @CRLF & @CRLF) = 6 Then Return True
EndFunc

Func WrongSize($nSizeIs, $nSizeShouldBe)
    If MsgBox(4,'FullScreen Fix - Error', 'The dll file size should be' & $nSizeShouldBe & ',' & @CRLF & "however it is " & $nSizeIs & @CRLF & "It's possible the patch may work still." & @CRLF & 'There are a number of additional checks to make sure the wrong file does not get patched' & @CRLF & @CRLF & 'Would you like to continue ?' & @CRLF & @CRLF) = 6 Then Return True
EndFunc

Func FindDll($sDll)
    If MsgBox(4,'FullScreen Fix - Error',$sDll & '      Does not exist' & @CRLF & '      Would you like to select the file manually?      ' & @CRLF & @CRLF) = 6 Then
        $sNewFileName = FileOpenDialog('Adobe FullScreen Fix', @SystemDir , 'Dll File (*.dll)' , 1 , 'NPSWF32.dll')
        If StringRight($sNewFileName,11) = "NPSWF32.DLL" Then
            Return True
        EndIf
    EndIf
    Return False
EndFunc

Func FileReadFail()
    FileOpenFail()
    Return False
EndFunc

Func FileWriteFail()
    FileOpenFail()    
    Return False
EndFunc