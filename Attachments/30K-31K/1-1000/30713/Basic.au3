;########################################## These are some basic script to use ###############################################

Func isLANOn()
	If(Ping("www.google.com.vn")==0) Then
		Return 0;
	Else
		Return 1;
	EndIf
EndFunc

Func getValue($url)
	$fileDownloadable=InetGet($url, @ScriptDir&"\"&$dataFileName);
	If($fileDownloadable==1) Then
		$returnValue=FileRead(@ScriptDir&"\"&$dataFileName);
		Return $returnValue;
	ElseIf($fileDownloadable==0) Then
		Return -1;
	EndIf
EndFunc

Func alert($ic, $txt)
	If($ic=="x" OR $ic=="X") Then
		MsgBox(16, $alertTitle, $txt);
	ElseIf($ic=="?") Then
		MsgBox(32, $alertTitle, $txt);
	ElseIf($ic=="!") Then
		MsgBox(48, $alertTitle, $txt);
	ElseIf($ic=="i" OR $ic=="I") Then
		MsgBox(64, $alertTitle, $txt);
	Else
		MsgBox(0, $alertTitle, $txt);
	EndIf
EndFunc

Func readReg($regKey, $regName)
	Return RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\NHT3004\"&$regKey,$regName);
EndFunc
	
Func writeReg($regKey, $regName, $regValue)
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\NHT3004\"&$regKey,$regName,"REG_SZ",$regValue);
EndFunc

Func deleteReg($regKey, $regValue)
	RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\NHT3004\"&$regKey,$regValue);
EndFunc

Func progressBy($IDOfProgressBar, $valueToProgressBy)
	$aimValue=Execute($currentProgress+$valueToProgressBy);
	If($aimValue>=100) Then
		GUICtrlSetData($IDOfProgressBar,100);
	Else
		While $currentProgress<$aimValue
			GUICtrlSetData($IDOfProgressBar,Execute($currentProgress+$percentPerUp));
			$currentProgress+=$percentPerUp;
			Sleep($speedOfUpdate);
		WEnd
	EndIf
	$currentProgress=$aimValue;
EndFunc

Func progressTo($IDOfProgressBar,$valueToProgressTo)
	If($valueToProgressTo>=100) Then
		GUICtrlSetData($IDOfProgressBar,100);
	Else
		While $currentProgress<$valueToProgressTo
			GUICtrlSetData($IDOfProgressBar,Execute($currentProgress+$percentPerUp));
			$currentProgress+=$percentPerUp;
			Sleep($speedOfUpdate);
		WEnd
	EndIf
	$currentProgress=$valueToProgressTo;
EndFunc

#cs
Func downloadFile($fileDownloadLink, $fileDownloadName)
	
	Global $downloadProgress;

	$progressForm=GUICreate("Downloading updates...", 220, 50, 0, 0);
	$downloadProgress=GUICtrlCreateProgress(10, 10, 200, 20);
	GUICtrlSetColor(-1, 32250);
	GUISetState(@SW_SHOW);
	
	$downloadFileSize=InetGetSize($fileDownloadLink);
	$isDownloaded=InetGet($fileDownloadLink, $fileDownloadName, "", 1);
	
	While @InetGetBytesRead<$downloadFileSize;
		progressTo($downloadProgress, @InetGetBytesRead/$downloadFileSize*100);
	WEnd
	
	GUIDelete($progressForm);Aftet delete progressForm, plz set $currentProgress to 0;
	$currentProgress=0;
	
	Return $isDownloaded;
EndFunc
#ce

Func sizeOf($arrayName)
	SetError(0);
	$index=0;
	Do
		$pop=_ArrayPop($arrayName);
		$index+=1;
	Until @error=1;
	Return $index-2;
EndFunc

Func encode($txt, $pass, $lvl)
	Return _StringEncrypt(1, BinaryToString(StringToBinary($txt, $Flag_UTF8), $Flag_ANSI), $pass, $lvl);
EndFunc

Func decode($txt, $pass, $lvl)
	Return BinaryToString(StringToBinary(_StringEncrypt(0, $txt, $pass, $lvl), $Flag_ANSI), $Flag_UTF8);
EndFunc

Func _Base64Decode($Data)
	Local $Opcode="0xC81000005356578365F800E8500000003EFFFFFF3F3435363738393A3B3C3DFFFFFF00FFFFFF000102030405060708090A0B0C0D0E0F10111213141516171819FFFFFFFFFFFF1A1B1C1D1E1F202122232425262728292A2B2C2D2E2F303132338F45F08B7D0C8B5D0831D2E9910000008365FC00837DFC047D548A034384C0750383EA033C3D75094A803B3D75014AB00084C0751A837DFC047D0D8B75FCC64435F400FF45FCEBED6A018F45F8EB1F3C2B72193C7A77150FB6F083EE2B0375F08A068B75FC884435F4FF45FCEBA68D75F4668B06C0E002C0EC0408E08807668B4601C0E004C0EC0208E08847018A4602C0E00624C00A46038847028D7F038D5203837DF8000F8465FFFFFF89D05F5E5BC9C21000";
	
	Local $CodeBuffer=DllStructCreate("byte[" & BinaryLen($Opcode) & "]");
	DllStructSetData($CodeBuffer, 1, $Opcode);

	Local $Ouput=DllStructCreate("byte[" & BinaryLen($Data) & "]");
	Local $Ret=DllCall("user32.dll", "int", "CallWindowProc", "ptr", DllStructGetPtr($CodeBuffer), _
													"str", $Data, _
													"ptr", DllStructGetPtr($Ouput), _
													"int", 0, _
													"int", 0);

	$res=BinaryToString(BinaryMid(DllStructGetData($Ouput, 1), 1, $Ret[0]));
	Return BinaryToString(StringToBinary($res, $Flag_ANSI), $Flag_UTF8);
EndFunc

Func _Base64Encode($Data, $LineBreak=76)
	$Data=BinaryToString(StringToBinary($Data, $Flag_UTF8), $Flag_ANSI);
	Local $Opcode="0x5589E5FF7514535657E8410000004142434445464748494A4B4C4D4E4F505152535455565758595A6162636465666768696A6B6C6D6E6F707172737475767778797A303132333435363738392B2F005A8B5D088B7D108B4D0CE98F0000000FB633C1EE0201D68A06880731C083F901760C0FB6430125F0000000C1E8040FB63383E603C1E60409C601D68A0688470183F90176210FB6430225C0000000C1E8060FB6730183E60FC1E60209C601D68A06884702EB04C647023D83F90276100FB6730283E63F01D68A06884703EB04C647033D8D5B038D7F0483E903836DFC04750C8B45148945FC66B80D0A66AB85C90F8F69FFFFFFC607005F5E5BC9C21000";

	Local $CodeBuffer=DllStructCreate("byte[" & BinaryLen($Opcode) & "]");
	DllStructSetData($CodeBuffer, 1, $Opcode);

	$Data=Binary($Data);
	Local $Input=DllStructCreate("byte[" & BinaryLen($Data) & "]");
	DllStructSetData($Input, 1, $Data);

	$LineBreak=Floor($LineBreak/4)*4;
	Local $OputputSize=Ceiling(BinaryLen($Data)*4/3);
	$OputputSize=$OputputSize+Ceiling($OputputSize/$LineBreak)*2+4;

	Local $Ouput = DllStructCreate("char[" & $OputputSize & "]");
	DllCall("user32.dll", "none", "CallWindowProc", "ptr", DllStructGetPtr($CodeBuffer), _
													"ptr", DllStructGetPtr($Input), _
													"int", BinaryLen($Data), _
													"ptr", DllStructGetPtr($Ouput), _
													"uint", $LineBreak);
	$res = DllStructGetData($Ouput, 1);
	Return $res;
EndFunc

Func fileDefineOpenAssociation($extension, $fileclass, $description, $icon, $command)
	RegWrite("HKCR\." & $extension, "", "REG_SZ", $fileclass);

	RegWrite("HKCR\" & $fileclass, "", "REG_SZ", $description);
	RegWrite("HKCR\" & $fileclass & "\DefaultIcon", "", "REG_SZ", $icon);
	RegWrite("HKCR\" & $fileclass & "\shell", "", "REG_SZ", "open");
	RegWrite("HKCR\" & $fileclass & "\shell\open\command", "", "REG_SZ", $command);
EndFunc

;########################################## End basic script programmed ######################################################