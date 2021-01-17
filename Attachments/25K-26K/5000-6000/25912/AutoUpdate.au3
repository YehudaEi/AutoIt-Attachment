#cs---------------------------------------------------------------------------------------------------------------------------------#
Student manager project - Auto Updates
Author : Nguyễn Huy Trường
Yahoo Address : nht3004@yahoo.com
Do not make illegal copy!
#ce---------------------------------------------------------------------------------------------------------------------------------#

#include <config.nht>
#include <GuiEdit.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <String.au3>
#include <Array.au3>
#include <File.au3>

;########################################## These are some basic script to use ###############################################

Func getValue($url)
	$fileDownloadable=InetGet($url, @ScriptDir&"\"&$dataFileName);
	If($fileDownloadable==1) Then
	$returnValue=FileRead(@ScriptDir&"\"&$dataFileName);
	Return $returnValue;
	ElseIf($fileDownloadable==0) Then
	Return -1;
	EndIf
EndFunc

Func alert($txt)
	MsgBox(0, $alertTitle, $txt);
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

Func sizeOf($arrayName)
	SetError(0);
	$index=0;
	Do
		$pop=_ArrayPop($arrayName);
		$index+=1;
	Until @error=1;
	Return $index-1;
EndFunc

Func encode($txt, $pass, $lvl)
	Return _StringEncrypt(1, BinaryToString(StringToBinary($txt, $Flag_UTF8), $Flag_ANSI), $pass, $lvl);
EndFunc

Func decode($txt, $pass, $lvl)
	Return BinaryToString(StringToBinary(_StringEncrypt(0, $txt, $pass, $lvl), $Flag_ANSI), $Flag_UTF8);
EndFunc

;########################################## End basic script programmed ######################################################


;****************************************** Start main script of project *****************************************************
;-------------------------------------------------Create a progress bar---------------------------------------------------

Global $updateProgress

$progressForm=GUICreate("Checking for updates...", 220, 50, 0, 0);
$updateProgress=GUICtrlCreateProgress(10, 10, 200, 20);
GUICtrlSetColor(-1, 32250);
GUISetState(@SW_SHOW);

;-------------------------------------------------Get new and old Version-------------------------------------------------

$newVersion=getValue($linkCheckVersion);After getValue(), plz delete the file downloaded!
progressBy($updateProgress,$percentPerAction);
FileDelete(@ScriptDir&"\"&$dataFileName);

If Not($newVersion==-1) Then
	progressBy($updateProgress,$percentPerAction);
	$currentVersion=readReg("SM","Version");
	progressBy($updateProgress,$percentPerAction);
	$fileLink=getValue($linkCheckFileUrl);After getValue(), plz delete the file downloaded!
	progressBy($updateProgress,$percentPerAction);
	FileDelete(@ScriptDir&"\"&$dataFileName);
	$newFeatures=getValue($linkCheckNewFeatures);After getValue(), plz delete the file downloaded!
	progressBy($updateProgress,$percentPerAction);
	FileDelete(@ScriptDir&"\"&$dataFileName);
	progressBy($updateProgress,$percentPerAction);

	;-------------------------------------------------Start check for updates-------------------------------------------------

	GUIDelete($progressForm);Aftet delete progressForm, plz set $currentProgress to 0;
	$currentProgress=0;
	
	If($currentVersion=="") Then
		writeReg("SM","Version",$projectVersion);
	Else
		If(Execute($newVersion)>Execute($currentVersion)) Then
			$downloadConfirm=MsgBox(1, "Thông báo", "Đã có phiên bản mới : "&$newVersion&"."&@LF&"Tính năng cập nhật: "&@LF&$newFeatures&@LF&"Bạn có muốn download?");
			If($downloadConfirm==1) Then
				$downloadable=downloadFile($fileLink, $fileName);
				If($downloadable==0) Then
					alert("Không thể download bản cập nhật, xin vui lòng thử lại sau!");
				Else
					writeReg("PM","Version",$newVersion);
					alert("Đã download xong phiên bản mới! Cập nhật hoàn tất, click OK để tiến hành cài đặt bản mới!");
					Run($fileName);
					Exit;
				EndIf
			EndIf
		EndIf
	EndIf
	;-------------------------------------------------End updates check-------------------------------------------------------
Else
	progressTo($updateProgress,100);
	GUIDelete($progressForm);
EndIf

;****************************************** End script of this project *******************************************************