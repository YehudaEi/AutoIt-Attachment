#include "GetIP.au3"
#include <GUIConstants.au3>
Init()
$gui=GUICreate("Ping & Check File",500,250)
;$Display=GUICtrlCreateList (" List of computers", 5,5,490,190)
$Display=GUICtrlCreateListView ("No|Listed Name|Returned Name", 5,5,490,240)
;$StopButton=GUICtrlCreateButton("Stop",225,205,50,30)


$TFile=@TempDir & "Tfile.txt"

If $CmdLine[0]=0 Then
	$CPath=@ScriptDir
Else
	$CPath = $CmdLine[1]
EndIf

$CFile=FileOpenDialog("Select a file with a list of computers",$CPath,"Text Files (*.txt;*.csv;*.ini;*.log)|All Files (*.*)",3,"Clist.txt")

If $CFile="" Then
	Exit
EndIf
$RFile=$CPath&"\Result.csv"
$RFile=$CPath&"\Result.csv"

If FileExists($RFile) Then
	$B=MsgBox(4,"File Exists",$RFile&" already exists.  Would you like to delete it?")
	If $B=6 Then
		FileDelete($RFile)
	EndIf
EndIf

GUISetState(@SW_SHOW)

$ListFile=FileOpen($CFile,0)
$ResultFile=FileOpen($RFile,2)

$i=0
$LFile=FileReadline($ListFile)
If StringUpper(StringLeft($LFile,4))="HKEY" Then
	$void=FileWriteLine($ResultFile,"Target Computer Name,IP Address,Returned Computer Name,Logged-on User,Compare,OS Name,Reg Value Data" & @CRLF)
	$RegArray=StringSplit($LFile,":")
	$RegKey=$RegArray[1]
	$RegValue=$RegArray[2]
Else
	$void=FileWriteLine($ResultFile,"Target Computer Name,IP Address,Returned Computer Name,Logged-on User,Compare,OS Name,File Version" & @CRLF)
EndIf	

do
	$Dif="N/A"
	$User="N/A"
	$FileExist="N/A"
	$OS="N/A"
	$i=$i+1
	$CName=FileReadline($ListFile)
;	$B=GUIGetMsg()
	If $CName <> "" Then

;		MsgBox(1,"PingnFile","Calling function")
		$IP = GetIP($Cname)
;		MsgBox(1,"PingnFile","I got IP "&$IP)
		If StringMid($IP,1,1) > "9" Then
	;		MessageBox("Unable to get IP address",$IP,16)
			$Host=$IP
			$Dif=$IP
		Else
	
			;$User=LoggedOnUser($IP)
			$User=RegRead("\\"&$IP&"\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon","DefaultUserName")
			$Host=RegRead("\\"&$IP&"\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName","ComputerName")
;			MsgBox(0,"Ping","The Host I found was "&$Host)
	
			If @error or $Host="" Then
				$Host="Cannot Access"
				$Dif=$Host
				$User="N/A"
			Else
				If $Host=$CName Then
					$Dif="Same"
					$OS=RegRead("\\"&$Host&"\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion","ProductName")
					If StringUpper(StringLeft($LFile,4))="HKEY" Then
						$FileExist=RegRead("\\"&$Host&"\"&$RegKey,$RegValue)
						If @error>0 Then
							$FileExist="Not Found"
						EndIf
					Else
						If FileExists("\\"&$Host&"\"&$LFile) Then
							$FileExist=FileGetVersion("\\"&$Host&"\"&$LFile)
							If StringLen($FileExist) > 8 Then
								$FileExist=StringLeft($FileExist,8)
							Else
								$FileExist="Found"
							EndIf
						Else
							$FileExist="Not Found"
						Endif
					EndIf
				Else
					$Dif="Different"
				EndIf
			EndIf
		EndIf
		$void=FileWriteLine($ResultFile,$CName&","&$IP&","&$Host&","&$User&","&$Dif&","&$OS&","&$FileExist&@CRLF)
	;	MessageBox("Computer Name: $Host@CRLF"+"IP Address: $IP@CRLF"+"Logged-on User: $User",$CName)

;		? "$i  - $CName  -  $Host"
		GUICtrlCreateListViewItem($i&"|"&$CName&"|"&$Host,$Display)
;		WinActivate("Ping & Check File")
		If WinActive("Ping & Check File") Then
			Send("^{END}")
		EndIf
;		If $B=$StopButton Then
;			$Answer=MsgBox(4,"Confirmation","Are you sure you want to stop Pinging the list?")
;			If $Answer=6 Then
;				Exit
;			EndIf
;		EndIf
;		GUICtrlSetData($Display,StringRight(String($i+10000),4)&"     - "&$CName&"     - "&$Host&"|")

	Endif

Until $CName=""

FileClose($ListFile)
FileClose($ResultFile)

