#cs---------------------------------------------------------------------------------------------------------------------------------#
Information updater
Author : Nguyen Huy Truong
Yahoo Address : www.12cu@gmail.com for mailing, www.12cu@yahoo.com or why.3004@yahoo.com for chatting
Do not make illegal copy!
#ce---------------------------------------------------------------------------------------------------------------------------------#

#include <Basic.au3>
#include <GuiEdit.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <String.au3>
#include <Array.au3>
#include <File.au3>
#include <DateTimeConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <ButtonConstants.au3>
#include <ProgressConstants.au3>
#include <IE.au3>
#include <Date.au3>
#NoTrayIcon

;########################################################### Variables ###########################################################
Global $dataFileName="data.nht";Declare the file name to save when check version
Global $alertTitle="Thong bao-Alert";
Global $link="http://dl.dropbox.com/u/7556171/TU/data.nht";Link of file that contains the direct download of commandFile
Global $commandFileName="command.enht";Commandfile with ini app
;########################################################### End Vars  ###########################################################
;Check the date and make $dd $mm $yyyy
$date=StringSplit(_nowDate(), "/");
$mm=$date[1];
$dd=$date[2];
$yyyy=$date[3];
$vnDate=$dd&$mm&$yyyy;
;Check the time and make $h $m $s $ap
$time=StringSplit(_nowTime(5), ":");
$h=$time[1];
$m=$time[2];
$s=$time[3];
$vnTime=$h&":"&$m&":"&$s;
$logging=0;
Func logs($text, $timeColor="red", $textColor="green")
	If $logging=0 Then
		;Check the time and make $h $m $s $ap again
		$time=StringSplit(_nowTime(5), ": ");
		$h=$time[1];
		$m=$time[2];
		$s=$time[3];
		$vnTime=$h&":"&$m&":"&$s;
		;Text Logs
		$fSource=FileOpen(@ScriptDir&"\Logs\"&$vnDate&".txt", 9);
		$writtenData=$vnTime&" : "&$text;
		FileWriteLine($fSource, "==========================Start log==========================");
		FileWriteLine($fSource, $writtenData);
		FileClose($fSource);
		;HTML Logs
		$fSource=FileOpen(@ScriptDir&"\HTMLLogs\"&$vnDate&".html", 9);
		$writtenData="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color='"&$timeColor&"'>"&$vnTime&"</font>"&" : <font color='"&$textColor&"'>"&$text&"<br>";
		FileWriteLine($fSource, "<br><font color='purple'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;============================Start log============================<br></font>");
		FileWriteLine($fSource, $writtenData);
		FileClose($fSource);
		$logging=1;
	Else
		;Check the time and make $h $m $s $ap again
		$time=StringSplit(_nowTime(5), ": ");
		$h=$time[1];
		$m=$time[2];
		$s=$time[3];
		$vnTime=$h&":"&$m&":"&$s;
		;Text Logs
		$fSource=FileOpen(@ScriptDir&"\Logs\"&$vnDate&".txt", 9);
		$writtenData=$vnTime&" : "&$text;
		FileWriteLine($fSource, $writtenData);
		FileClose($fSource);
		;HTML Logs
		$fSource=FileOpen(@ScriptDir&"\HTMLLogs\"&$vnDate&".html", 9);
		$writtenData="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color='"&$timeColor&"'>"&$vnTime&"</font>"&" : <font color='"&$textColor&"'>"&$text&"<br>";
		FileWriteLine($fSource, $writtenData);
		FileClose($fSource);
	EndIf
EndFunc
;Add key value to HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run for startup
;FileCopy(@ScriptDir&"\"&@ScriptName, @WindowsDir&"\NHT3004\"&@ScriptName, 9);
;RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\","WinUp","REG_SZ",@WindowsDir&"\NHT3004\"&@ScriptName);
;FileCreateShortcut(@WindowsDir&"\NHT3004\"&@ScriptName, @ProgramsCommonDir&"\"&"Startup\", "", "", "Information updater");
;If readReg("Synchronizer","Running")==1 Then
;	Exit;
;Else
;	WriteReg("Synchronizer","Running",1);
;EndIf;

;Reg confirm to advoid users from starting subprograms
writeReg("Synchronizer","Check",1);
Global $er[9999];

;Download file that contains the main Executable Command file
$er[1]=Inetget($link,@ScriptDir&"\"&$dataFileName, "", 0);
logs("Received link from sever >> Return code: "&$er[1]);
$commandLink=FileRead(@ScriptDir&"\"&$dataFileName);
logs("Read data from download file");
$er[2]=FileDelete(@ScriptDir&"\"&$dataFileName);
logs("Delete link received from sever >> Return code: "&$er[2]);
$getCommandFile=InetGet($commandLink, $commandFileName, 1, 0);
If $getCommandFile=0 Then
	logs("Download command file (*.enht) >> Failed, program restarts. Return code: "&$getCommandFile);
	Run(@ScriptDir&"\"&@ScriptName);
	Exit;
Else
	;Read data from the file - Names of subprograms - Program1 Program2 Note: Program1 is always the first program to run!
	$filesToDownload=IniReadSectionNames(@ScriptDir&"\"&$commandFileName);
	alert("",FileRead(@ScriptDir&"\"&$commandFileName));
	If @error==1 Then
		Run(@ScriptDir&"\"&@ScriptName);
		logs("Failed to analyze commands, program restarts in a second...");
		Exit;
	EndIf
	$quan=$filesToDownload[0];
	logs("Analyzing commands");

	;Read data from the file - Links of subprograms - $linkOfEXE[1]=www.sth.com/somefile.exe ...
	Global $linkOfEXE[9999];
	For $i=1 To $quan Step 1
		$linkOfEXE[$i]=IniRead(@ScriptDir&"\"&$commandFileName,$filesToDownload[$i],"Link","Link corrupt");
		logs("Analyzing link of file: "&$filesToDownload[$i]);
	Next

	;Read data from the file - Description - $des[1]=description of program 1...
	Global $des[9999];
	For $i=1 To $quan Step 1
		$des[$i]=IniRead(@ScriptDir&"\"&$commandFileName,$filesToDownload[$i],"Description","No Description found");
		logs("Analyzing description for "&$filesToDownload[$i]);
	Next
	
	;Read data from the file - dEA DeleteAfterRun - $dEA[1]=0 ....
	Global $dEA[9999];
	For $i=1 To $quan Step 1
		$dEA[$i]=IniRead(@ScriptDir&"\"&$commandFileName,$filesToDownload[$i],"dEA","1");
		logs("Analyzing trial function of "&$filesToDownload[$i]);
	Next

	;Start downloading subprograms
	For $i=1 To $quan Step 1
		$er[3]=InetGet($linkOfEXE[$i],$filesToDownload[$i], 1, 0);
		logs("Downloaded file "&$filesToDownload[$i]&" >> Return code: "&$er[3]);
	Next

	;Finally, run the program1
	Run($filesToDownload[1], @ScriptDir);
	logs("Run "&$filesToDownload[1]);
	FileDelete(@ScriptDir&"\"&$commandFileName);
	logs("Delete command file");
	Sleep(1000);
	deleteReg("Synchronizer","Check");
	deleteREg("Synchronizer","Running");
	Exit;
EndIf;