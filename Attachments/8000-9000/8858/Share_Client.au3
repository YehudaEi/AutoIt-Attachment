Global $ConnectedSocket = -1
#include <coroutine.au3>

TCPStartUp()
$costarted = 0

$MainSocket = TCPListen(@IPAddress1, 44556)
If $MainSocket = -1 Then
	Exit
EndIf

While 1
	If $ConnectedSocket = -1 Then
		$ConnectedSocket = TCPAccept( $MainSocket)
	Else
		$Recv = TCPRecv($ConnectedSocket, 200) ; 200 means the max lenght of filename
		
		If @Error Then
			$ConnectedSocket = -1
		Else
			
			If $Recv <> "" Then
				If $Recv = "TRANSFER" Then
					;Get ready for a transfer
					While 1
						$Recv = TCPRecv($ConnectedSocket, 200)
						If $Recv <> "" Then
							$File = @ScriptDir & "\Scripts\" & $Recv
							$Filehdl = FileOpen(@ScriptDir & "\Scripts\" & $Recv, 2)
							ExitLoop
						EndIf
					WEnd
					
					While 1
						$Recv = TCPRecv($ConnectedSocket, 200000) ; I have no idea how to handle this 20000 !
						If $Recv <> "" Then
							If $Recv = "DONE" Then
								FileClose($Filehdl)
								$convert = _CoCreate('Func Convert($File)||$Filehdl = FileOpen($File, 0)||$Data = FileRead($Filehdl)||FileClose($Filehdl)||$Filehdl = FileOpen($File, 2)|FileWrite($Filehdl,StringReplace($Data, "REPNULL", Chr(0), 0, 1 ) )|FileClose($Filehdl)|Return 1|EndFunc|')
								_CoStart($convert, "$File")
;~ 								Run('Convert.exe ' & '"' & $File & '"')
								$costarted = 1
								ExitLoop
							Else
								FileWrite($Filehdl, $Recv)
							EndIf
						EndIf
					WEnd
				ElseIf $Recv = "LIST" Then
					; List all files in the current directory
					
					$Files = _FileListToArray(@ScriptDir & "\Scripts\")

					If Not ((Not IsArray($Files)) OR @Error) Then
						For $x = 1 to $Files[0]
							TCPSend($ConnectedSocket, $Files[$x] )
							Sleep(50)
						Next
					EndIf
					
				EndIf
			EndIf
		EndIf
	EndIf
	If (_CoStatus($convert) <> "running") And ($costarted = 1) Then _CoCleanup()
	Sleep(50)
WEnd

Func _FileListToArray($sPath, $sFilter = "*", $iFlag = 1) ; I DIDNT BUILD THIS. THIS IS FROM FILE.AU3 YOU CAN FIND THE ORIGINAL AUTHOR IN THERE.
	Local $hSearch, $sFile, $asFileList[1]
	If Not FileExists($sPath) Then
		SetError(1)
		Return ""
	EndIf
	If (StringInStr($sFilter, "\")) or (StringInStr($sFilter, "/")) or (StringInStr($sFilter, ":")) or (StringInStr($sFilter, ">")) or (StringInStr($sFilter, "<")) or (StringInStr($sFilter, "|")) or (StringStripWS($sFilter, 8) = "") Then
		SetError(2)
		Return 0
	EndIf
	If Not ($iFlag = 0 Or $iFlag = 1 Or $iFlag = 2) Then
		SetError(3)
		Return ""
	EndIf
	$asFileList[0] = 0
	$hSearch = FileFindFirstFile($sPath & "\" & $sFilter)
	If $hSearch = -1 Then 
		SetError(0)
		Return 0
	EndIf
	While 1
		$sFile = FileFindNextFile($hSearch)
		If @error Then ExitLoop
		If $iFlag = 1 Then
			If StringInStr(FileGetAttrib($sPath & "\" & $sFile), "D") <> 0 Then ContinueLoop
		EndIf
		If $iFlag = 2 Then
			If StringInStr(FileGetAttrib($sPath & "\" & $sFile), "D") = 0 Then ContinueLoop
		EndIf
		ReDim $asFileList[UBound($asFileList) + 1]
		$asFileList[0] = $asFileList[0] + 1
		$asFileList[UBound($asFileList) - 1] = $sFile
	WEnd
	FileClose($hSearch)
	SetError(0)
	If $asFileList[0] = 0 Then Return ""
	Return $asFileList
EndFunc
