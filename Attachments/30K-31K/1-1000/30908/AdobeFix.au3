#cs
The scanforit function needs some work, I will improve it after I see
	how the next couple version affect the code.
The update to 10.1.53.64 Invovled a new method pathching the dll.
If that happens again the ability to possibly patch future untested versions won't have a
	chance in HE double hockey sticks of working.

To Add a version you need to increment the ubound of the 5 global consts
	ie... $vFlashVer[7] becomes $vFlashVer[8]

And the New Version's data for each
	Don't forget the comma between or 'Quotes' for string values

Global Const $vFlashVer[7] 	  = Version of the NPSWF32.dll
Global Const $vFlashSize[7]   = Size of the NPSWF32.dll file in bytes
Global Const $vFlashOffset[7] = Offset in bytes to location of bytes needing replacement
Global Const $vFlashOrig[7]   = Original bytes
Global Const $vFlashNew[7] 	  = Replacement Bytes
#ce

Global Const $vFlashVer[7] 	  = [ '10.0.12.36','10.0.22.87','10.0.32.18','10.0.42.34','10.0.45.2' ,'10.1.53.64']
Global Const $vFlashSize[7]   = [ 3695008, 3771296, 3883424, 3885984, 3884312, 5612496 ]
Global Const $vFlashOffset[7] = [ 1271652, 1270591, 1274696, 1276282, 1277053, 1575445 ]
Global Const $vFlashOrig[7]   = [ '0x0074', '0x0074', '0x0074', '0x0074', '0x0074', '0x7439' ]
Global Const $vFlashNew[7] 	  = [ '0x00EB', '0x00EB', '0x00EB', '0x00EB', '0x00EB', '0x9090' ]


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

	For $i = 0 To UBound($vFlashVer) - 1
		If $sVer = $vFlashVer[$i] Then
			$ver = $sVer
			ExitLoop
		EndIf
	Next
	$oFSO = ""
	If Not $ver Then
		If Not WrongVersion($sVer) Then
			ScanForIt($sDll, $sVer, Binary('0x743983E807741183E80575138B'),Binary('0x743983E807741183E80575138B'))
		Else
            Exit
        EndIf
	EndIf
    Openit($sDll)
EndFunc

Func Openit($sDll)
    Local $hDLL, $bFile
    $hDLL = FileOpen($sDll,16)
    If @error = -1 Then
        FileOpenFail()
        Exit
    EndIf
    $bFile = FileRead($hDLL)
    If @error = 1 Then
        FileReadFail()
        Exit
    EndIf
    FileClose($hDLL)
	For $i = 0 To UBound($vFlashVer) - 1
		PatchIt($bFile,$sDll,$vFlashVer[$i],$vFlashSize[$i],$vFlashOffset[$i],Binary($vFlashOrig[$i]),Binary($vFlashNew[$i]))
	Next
EndFunc

Func ScanForIt($sDll,$sVer,$bFind, $bFindPatched)
	Local $loc1,$loc2,$i,$nSize
	$ver = $sVer
	$nSize = FileGetSize($sDll)

    $hDLL = FileOpen($sDll,16)
    If @error Then
        FileOpenFail()
        Exit
    EndIf
    $bFile = FileRead($hDLL)
    If @error Then
        FileReadFail()
        Exit
    EndIf
	FileClose($hDLL)

	$loc1 = StringInStr(BinaryToString($bFile),BinaryToString($bFind),Default,1)
	If $loc1 Then
		ConsoleWrite('Location 1= ' & $loc1 & @CRLF)
		$sLocs = 'Location 1= ' & $loc1 & @CRLF
	Else
		$loc1 = StringInStr(BinaryToString($bFile),BinaryToString($bFindPatched),Default,1)
		If $loc1 Then
			If MsgBox(1,'FullScreen Fix : Untested Version',"      Found a 'possible' location where an untested version was patched    " & @CRLF & '      Version = ' & $ver & '      Location = ' & $loc1 & @CRLF & @CRLF & '      DO NOT proceed unless you have previously patched an untested version.      ' & @CRLF ) <> 1 Then
				Exit
			Else
				PatchIt($bFile,$sDll,$ver,$nSize,$loc1,Binary("0x7439"),Binary("0x9090"))
				Exit
			EndIf
		EndIf
		MsgBox(0,'FullScreen Fix - Error','      Unable to locate the correct byte sequence in the dll file       ' & @CRLF & '      Version = ' & $ver & @CRLF & '      Critical failure...Exiting....'  & @CRLF & @CRLF)
		Exit
	EndIf


	$loc2 = StringInStr(BinaryToString($bFile),BinaryToString($bFind),Default,2)
	If $loc2 Then
		ConsoleWrite('Location 2= ' & $loc2 & @CRLF)
		$sLocs &= 'Location 2= ' & $loc2 & @CRLF
		$i = 3
		While True
			$p = StringInStr(BinaryToString($bFile),BinaryToString($bFind),Default,$i)
			If Not $p Then ExitLoop
			$sLocs &= 'Location ' & $i & '= ' & $p & @CRLF
			ConsoleWrite('Location ' & $i & '= ' & $p & @CRLF)
			$i += 1
			If $i > 20 Then ExitLoop
		WEnd
		ConsoleWrite($sLocs & @CRLF)
		MsgBox(0,'FullScreen Fix - Error','      Found multiple possible locations to patch      ' & @CRLF & '      Version = ' & $ver & @CRLF & $sLocs & @CRLF & '      Critical failure...Exiting....'  & @CRLF & @CRLF)
		Exit
	Else
		MsgBox(0,'FullScreen Fix','      Scan Success found 1 possible location to patch.      ' & @CRLF & '      Version = ' & $ver & @CRLF & '      Location = ' & $loc1 & @CRLF & @CRLF )
		PatchIt($bFile,$sDll,$ver,$nSize,$loc1,Binary("0x7439"),Binary("0x9090"))
	EndIf
	Exit
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
        $ReplacementMsg = '      ' & $bOrig & ' Indicates that this file is not currently pathed.      ' & @CRLF & @CRLF & '      Would you like to patch it now?'
    ElseIf $bTarget = $bNew Then
        $bTarget = $bOrig
        $ReplacementMsg = '      ' & $bNew & ' Indicates that this file has been patched.      ' & @CRLF & @CRLF & '      Would you like to remove the patch?'
    Else
        BinNotMatch($bTarget,$bOrig)
        Exit
    EndIf

    $bReplace = $bPart1 & $bTarget & $bPart2
    If BinaryLen($bReplace) <> BinaryLen($bFile) Then
        MsgBox(0,'FullScreen Fix - Error','      Critical error: the length of the original file' & @CRLF & '      and the length of the new file would have not been the same.      ' & @CRLF & '      Commit changes to file has beeen aborted. ' & @CRLF & @CRLF & '      Uknown reason how or why this would happen. ' & @CRLF & @CRLF & '      Exiting....' & @CRLF)
        Exit
    EndIf
    If MsgBox(4,'FullScreen Fix - Patch','      Found the target dll file, ' & $sDll & '.' & @CRLF & @CRLF & _
        @CRLF & $ReplacementMsg & @CRLF & @CRLF ) = 6 Then
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

Func BinNotMatch($bIs,$bShouldbe)
    MsgBox(0,'FullScreen Fix - Error','      The 2 bytes to patch are incorrect ' & $bShouldbe & ',      ' & @CRLF & '      they are ' & $bIs & @CRLF & @CRLF & '       Critical failure...Exiting....'  & @CRLF)
    Return False
EndFunc

Func FileOpenFail()
    MsgBox(0,'FullScreen Fix - Error','      Unable to open file, File may be in use.      ' & @CRLF & '      Try the following' & @CRLF & '        Quit any applications that maybe using flash.' & @CRLF & '        Restart your system.' & @CRLF & '        Use an account with administrator privledges.' & @CRLF & '        Check permissions to make sure you have read & write privledges.' & @CRLF & @CRLF & '      Critical failure...Exiting....'  & @CRLF & @CRLF)
    Return False
EndFunc

Func WrongVersion($sVerIs)
    If MsgBox(4,'FullScreen Fix - Error', "     Current NPSWF32.dll Version = " & $sVerIs & @CRLF & "      That version hasn't been added yet"  & @CRLF & @CRLF & '      Would you like to scan the file for the target bytes ?' & @CRLF & @CRLF) = 6 Then Return True
	Exit
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




