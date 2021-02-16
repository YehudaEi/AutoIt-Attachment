Global $ver

; Run this script with administrator privileges - otherwise it won't allow us to path the DLL
#RequireAdmin

; --------------------------------------------------------------------------------------------------------------------------- ;
;	To Add a version you need to increment the value of $nFlashVersions

Local $nFlashVersions = 7
; --------------------------------------------------------------------------------------------------------------------------- ;


; --------------------------------------------------------------------------------------------------------------------------- ;
;And the New Version's data for each
;	Don't forget the comma between or 'Quotes' for string values
;Global Const $vFlashVer[$nFlashVersions] 	  = Version of the NPSWF32.dll
;Global Const $vFlashSize[$nFlashVersions]     = Size of the NPSWF32.dll file in bytes
;Global Const $vFlashOffset[$nFlashVersions]   = Offset in bytes to location of bytes needing replacement
;Global Const $vFlashOrig[$nFlashVersions]     = Original bytes at offset location (to be patched)
;Global Const $vFlashNew[$nFlashVersions] 	  = Replacement Bytes

Global Const $vFlashVer[$nFlashVersions] 	= [ '10.0.12.36','10.0.22.87','10.0.32.18','10.0.42.34','10.0.45.2' ,'10.1.53.64', '10.1.102.64']
Global Const $vFlashSize[$nFlashVersions]   = [ 3695008,  3771296,  3883424,  3885984,  3884312,  5612496,  5971408 ]
Global Const $vFlashOffset[$nFlashVersions] = [ 1271652,  1270591,  1274696,  1276282,  1277053,  1575445,  1576519 ]
Global Const $vFlashOrig[$nFlashVersions]   = [ '0x0074', '0x0074', '0x0074', '0x0074', '0x0074', '0x7439', '0x7439' ]
Global Const $vFlashNew[$nFlashVersions]    = [ '0x00EB', '0x00EB', '0x00EB', '0x00EB', '0x00EB', '0x9090', '0x9090']
; --------------------------------------------------------------------------------------------------------------------------- ;


; --------------------------------------------------------------------------------------------------------------------------- ;
;Global Const $bSearchOrig     = a binary string to search for. marks the offset location
;Global Const $bSearchReplaced = a binary string to search for after the patch has been applied. marks the offset location
;
;Changing these values is only necessary the script cannot find the correct offset location

Global Const $bSearchOrig = Binary('0x743983E807741183E80575138B')
Global Const $bSearchReplaced =  Binary('0x909083E807741183E80575138B')
; --------------------------------------------------------------------------------------------------------------------------- ;


; --------------------------------------------------------------------------------------------------------------------------- ;
; The script looks for the Adobe Flash DLL file in
; 1st place it checks  C:\Windows\system32\Macromed\Flash\NPSWF32.dll
; 2nd place it checks  C:\Windows\SysWOW64\Macromed\Flash\NPSWF32.dll

; To patch a NPSWF32.dll file located elsewhere when the file also exists in one of the two locations above

; For example in order to patch a NPSWF32.dll located at D:\AdobeDll\NPSWF32.dll
; 	     change the following line from.
; Local $sPatchThisFile = ''     to
; Local $sPatchThisFile = 'D:\AdobeDll\NPSWF32.dll'

Local $sPatchThisFile = ''
; --------------------------------------------------------------------------------------------------------------------------- ;

; --------------------------------------------------------------------------------------------------------------------------- ;
; 			Do not edit below this line
; --------------------------------------------------------------------------------------------------------------------------- ;
start($sPatchThisFile)
Exit

Func start($sPatchThis)
	If $sPatchThis Then
		If FileExists($sPatchThis) Then
			VerifyDllVersion($sPatchThis)
			Return
		EndIf
	EndIf
	If FileExists(@WindowsDir & '\system32\Macromed\Flash\NPSWF32.dll') Then
		VerifyDllVersion(@WindowsDir & '\system32\Macromed\Flash\NPSWF32.dll')
	ElseIf FileExists(@WindowsDir & '\SysWOW64\Macromed\Flash\NPSWF32.dll') Then
		VerifyDllVersion(@WindowsDir & '\SysWOW64\Macromed\Flash\NPSWF32.dll')
	Else
		VerifyDllVersion(FindDll('NPSWF32.dll'))
	EndIf
EndFunc
Func FindDll($sDll)
    If MsgBox(4,'FullScreen Fix - Error',$sDll & '      Does not exist' & @CRLF & '      Would you like to select the file manually?      ' & @CRLF & @CRLF) = 6 Then
        $sNewFileName = FileOpenDialog('Adobe FullScreen Fix', @SystemDir , 'Dll File (*.dll)' , 1 , 'NPSWF32.dll')
        If StringRight($sNewFileName,11) = $sDll Then Return $sNewFileName
    EndIf
EndFunc
Func VerifyDllVersion($sDll)
    Local $sVer,$oFSO
    $oFSO = ObjCreate("Scripting.FileSystemObject")
    $sVer = $oFSO.GetFileVersion( $sDll )
    $oFSO = ""
    ;MsgBox(0,'test message','File version = ' & $sVer & @CRLF &  'test.')
    For $i = 0 To UBound($vFlashVer) - 1
        If $sVer = $vFlashVer[$i] Then
            $ver = $sVer
            ;Return         ----------------- ERROR ---------------------------
            ExitLoop
        EndIf
    Next
    ;MsgBox(0,'test message','File = ' & $ver & @CRLF &  'test.')
    If Not $ver Then
        ;MsgBox(0,'test message','File = ' & $ver & @CRLF &  'unsupported version.')
        If WrongVersion($sVer) Then VersionIsBad_ScanForIt($sDll, $sVer)
    Else
        ;MsgBox(0,'test message','File = ' & $ver & @CRLF &  'supported version.')
        VersionIsGood_Openit($sDll,$sVer)
    EndIf
EndFunc
Func VersionIsGood_Openit($sDll, $sVer)
    Local $hDLL, $bFile
    $hDLL = FileOpen($sDll,16)
    If @error = -1 Then FileOpenFail()
    $bFile = FileRead($hDLL)
    If @error = 1 Then FileReadFail()
    FileClose($hDLL)
	For $i = 0 To UBound($vFlashVer) - 1
		If $sVer = $vFlashVer[$i] Then
			PatchIt($bFile,$sDll,$vFlashVer[$i],$vFlashSize[$i],$vFlashOffset[$i],Binary($vFlashOrig[$i]),Binary($vFlashNew[$i]))
			Return
		EndIf
	Next
EndFunc
Func VersionIsBad_ScanForIt($sDll, $sVer)
	Local $loc1,$loc2,$i,$nSize
	$ver = $sVer
	$nSize = FileGetSize($sDll)
    $hDLL = FileOpen($sDll,16)
    If @error Then FileOpenFail()
    $bFile = FileRead($hDLL)
    If @error Then FileReadFail()
	FileClose($hDLL)
	$loc1 = StringInStr(BinaryToString($bFile),BinaryToString($bSearchOrig),Default,1)
	If Not $loc1 Then
		$loc1 = StringInStr(BinaryToString($bFile),BinaryToString($bSearchReplaced),Default,1)
		If Not $loc1 Then
			MsgBox(0,'FullScreen Fix - Error','      Unable to locate the correct byte sequence in the dll file       ' & @CRLF & '      Version = ' & $ver & @CRLF & '      Critical failure...Exiting....'  & @CRLF & @CRLF)
			Return
		Else
			If MsgBox(1,'FullScreen Fix : Untested Version',"      Found a 'possible' location where an untested version was patched    " & @CRLF & '      Version = ' & $ver & '      Location = ' & $loc1 & @CRLF & @CRLF & '      DO NOT proceed unless you have previously patched an untested version.      ' & @CRLF ) <> 1 Then PatchIt($bFile,$sDll,$ver,$nSize,$loc1 - 1,Binary("0x9090"),Binary("0x7439"))
			Return
		EndIf
	Else
		$loc1 -= 1
		$sLocs = 'Location 1= ' & $loc1 & @CRLF
		$loc2 = StringInStr(BinaryToString($bFile),BinaryToString($bSearchOrig),Default,2)
		If $loc2 Then
			$loc2 -= 1
			$sLocs &= 'Location 2= ' & $loc2 & @CRLF
			$i = 3
			While $i <= 20
				$p = StringInStr(BinaryToString($bFile),BinaryToString($bSearchOrig),Default,$i)
				If Not $p Then ExitLoop
				$sLocs &= 'Location ' & $i & '= ' & $p & @CRLF
				$i += 1
			WEnd
			MsgBox(0,'FullScreen Fix - Error','      Found multiple possible locations to patch      ' & @CRLF & '      Version = ' & $ver & @CRLF & $sLocs & @CRLF & '      Critical failure...Exiting....'  & @CRLF & @CRLF)
			Return
		EndIf
		PatchIt($bFile,$sDll,$ver,$nSize,$loc1,Binary("0x7439"),Binary("0x9090"))
		Return
	EndIf
EndFunc
Func PatchIt(byref $bFile,$sDll,$sV,$nL,$nO,$bOrig,$bNew)
	If $ver <> $sV then return
	Local $bReplace, $bReplacement, $bPart1, $bPart2, $bTarget, $hDLL
	If BinaryLen($bFile) <> $nL Then
		If Not WrongSize(BinaryLen($bFile),$nL) Then Exit
	EndIf
	$bPart1 = BinaryMid($bFile, 1, $nO)
	$bTarget = BinaryMid($bFile, $nO + 1, 2)
	$bPart2 = BinaryMid($bFile, $nO + 3, BinaryLen($bFile))
   If $bTarget = $bOrig Then
        $bTarget = $bNew
        $ReplacementMsg = '      The NPSWF32.dll file is not currently patched.      ' & @CRLF & @CRLF & '      Would you like to patch it now?'
    ElseIf $bTarget = $bNew Then
        $bTarget = $bOrig
        $ReplacementMsg = '      The NPSWF32.dll file has been patched.      ' & @CRLF & @CRLF & '      Would you like to remove the patch?'
    Else
        MsgBox(0,'FullScreen Fix - Error','      The 2 bytes to patch are incorrect ' & @CRLF & '      they should be  ' & $bShouldbe & ',      ' & @CRLF & '      they are ' & $bIs & @CRLF & @CRLF & '       Critical failure...Exiting....'  & @CRLF)
        Return
    EndIf
    $bReplace = $bPart1 & $bTarget & $bPart2
    If BinaryLen($bReplace) <> BinaryLen($bFile) Then
        MsgBox(0,'FullScreen Fix - Error','      Critical error: the length of the original file' & @CRLF & '      and the length of the new file would have not been the same.      ' & @CRLF & '      Commit changes to file has beeen aborted. ' & @CRLF & @CRLF & '      Uknown reason how or why this would happen. ' & @CRLF & @CRLF & '      Exiting....' & @CRLF)
		Return
    EndIf
    If MsgBox(4,'FullScreen Fix - Patch','      Found the target dll file in , '  & @CRLF & '      ' & $sDll & '.' & @CRLF & _
        @CRLF & $ReplacementMsg & @CRLF ) = 6 Then
        $hDLL = FileOpen($sDll,18)
        If @error = -1 Then
            FileOpenFail()
            Exit
        EndIf
        If Not FileWrite($hDLL,$bReplace) Then
            FileClose($hDLL)
            FileWriteFail()
            Exit
        EndIf
        FileClose($hDLL)
    EndIf
    Exit
EndFunc
Func WrongVersion($sVerIs)
    If MsgBox(4,'FullScreen Fix - Error', "     Current NPSWF32.dll Version = " & $sVerIs & @CRLF & "      That version hasn't been added yet"  & @CRLF & @CRLF & '      Would you like to scan the file for the target bytes ?' & @CRLF & @CRLF) = 6 Then
		Return True
	Else
		Exit
	EndIf
EndFunc
Func WrongSize($nSizeIs, $nSizeShouldBe)
    If MsgBox(4,'FullScreen Fix - Error', 'The dll file size should be' & $nSizeShouldBe & ',' & @CRLF & "however it is " & $nSizeIs & @CRLF & "It's possible the patch may work still." & @CRLF & 'There are a number of additional checks to make sure the wrong file does not get patched' & @CRLF & @CRLF & 'Would you like to continue ?' & @CRLF & @CRLF) = 6 Then Return True
EndFunc
Func FileOpenFail()
    MsgBox(0,'FullScreen Fix - Error','      Unable to open the file NPSWF32.dll.' & @CRLF & '      File may be in use.      ' & @CRLF & '      Try the following' & @CRLF & '        Quit any applications that maybe using flash.' & @CRLF & '        Restart your system.' & @CRLF & '        Use an account with administrator privledges.' & @CRLF & '        Check permissions to make sure you have read & write privledges.' & @CRLF & @CRLF & '      Critical failure...Exiting....'  & @CRLF & @CRLF)
EndFunc
Func FileReadFail()
    MsgBox(0,'FullScreen Fix - Error','      Unable to read the file NPSWF32.dll.' & @CRLF & '      File may be in use.      ' & @CRLF & '      Try the following' & @CRLF & '        Quit any applications that maybe using flash.' & @CRLF & '        Restart your system.' & @CRLF & '        Use an account with administrator privledges.' & @CRLF & '        Check permissions to make sure you have read & write privledges.' & @CRLF & @CRLF & '      Critical failure...Exiting....'  & @CRLF & @CRLF)
EndFunc
Func FileWriteFail()
    MsgBox(0,'FullScreen Fix - Error','      Unable to write to the file NPSWF32.dll.' & @CRLF & '      File may be in use.      ' & @CRLF & '      Try the following' & @CRLF & '        Quit any applications that maybe using flash.' & @CRLF & '        Restart your system.' & @CRLF & '        Use an account with administrator privledges.' & @CRLF & '        Check permissions to make sure you have read & write privledges.' & @CRLF & @CRLF & '      Critical failure...Exiting....'  & @CRLF & @CRLF)
EndFunc
