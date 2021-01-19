#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=127.ico
#AutoIt3Wrapper_outfile=D:\Unlimited Projects\Tools\SysInfo\SysInfo.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseAnsi=y
#AutoIt3Wrapper_Res_Comment=                       
#AutoIt3Wrapper_Res_Description=System Information Tool
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
#AutoIt3Wrapper_Res_LegalCopyright=iuli_kyle
#AutoIt3Wrapper_Res_Field=Made by| iuli_kyle
#AutoIt3Wrapper_Run_AU3Check=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;AutoIt Version: 3.2.8.0
;Author: iuli_kyle

;Script Function: This tool offers you basic and advanced information 
;                 about your computer with the ability of saving and/
;                 or printing this info to a .ini file.

#include<GUIConstants.au3>
#include<Date.au3>
#include<File.au3>
#include"GUIEnhance.au3" ;Thanks for this to BetaPad developer team !
#include"UDF.au3" ;This is a customized UDF functions library. Thanks for this to JSThePatriot !

;Script Variables
$title = "SysInfo"
$version = "1.0 beta"
$autor = "by iuli_kyle"
$website = "                       "
$f_drives= " "
$mem = MemGetStats ()
$BetaTesters= "Falk Dragos (bdcdragos@yahoo.com)"& @CRLF & "                                          Some AutoIT forum members" & @CRLF 
$somefunc="JSThePatriot's Great UDF" & @CRLF & "                                                    BetaPad developer team" 

;Main functions	

If IsAdmin () Then
	$sn=$aOSInfo [1] [46]
Else
	$sn="Hidden ! No administrative rights detected !"
EndIf	

If @OSServicePack="" Then
	$OSServicePack="No Service Pack installed"
Else
	$OSServicePack=@OSServicePack	
EndIf

If @OSVersion = "WIN_95" Then
	$OSVersion = "Windows 95"
EndIf	
If @OSVersion = "WIN_98" Then
	$OSVersion = "Windows 98"
EndIf
If @OSVersion = "WIN_ME" Then
	$OSVersion = "Windows ME"
EndIf
If @OSVersion = "WIN_NT4" Then
	$OSVersion = "Windows NT 4"
EndIf
If @OSVersion = "WIN_2000" Then
	$OSVersion = "Windows 2000"
EndIf
If @OSVersion = "WIN_XP" Then
	$OSVersion = "Windows XP"
EndIf
If @OSVersion = "WIN_2003" Then
	$OSVersion = "Windows Server 2003"	
EndIf
If @OSVersion = "WIN_VISTA" Then
	$OSVersion = "Windows Vista"	
EndIf

Func InfoDelete ( )
	If FileExists(@ScriptDir & "\SysInfoSystemInfo.ini") Then
		$old=MsgBox(36,"Old information file detected","An older Configuration file has been detected." & @CRLF &  "Do you want to keep it ?")
		If $old=7 Then
			FileDelete(@ScriptDir & "\SysInfoSystemInfo.ini")
		EndIf
	EndIf	
EndFunc

Func WriteInfoToTextFile ( )
	IniWrite("SysInfoSystemInfo.ini","General Info","Current User",@UserName)
	IniWrite("SysInfoSystemInfo.ini","General Info","Operating System",$OSVersion)
	IniWrite("SysInfoSystemInfo.ini","General Info","Service Pack",$OSServicePack)
	IniWrite("SysInfoSystemInfo.ini","General Info","Windows Directory Path",@WindowsDir)
	IniWrite("SysInfoSystemInfo.ini","General Info","Computer Name",@ComputerName)
	IniWrite("SysInfoSystemInfo.ini","General Info","Desktop Settings",@DesktopWidth & " x " & @DesktopHeight & " @ " & @DesktopRefresh & "Mhz" & @CRLF)
	IniWrite("SysInfoSystemInfo.ini","Internet Info","Logon Domain",@LogonDomain)
	IniWrite("SysInfoSystemInfo.ini","Internet Info","Logon DNS Domain",@LogonDNSDomain)
	IniWrite("SysInfoSystemInfo.ini","Internet Info","Logon Server",@LogonServer)
	IniWrite("SysInfoSystemInfo.ini","Internet Info","Internet Protocol Adress",@IPAddress1 & @CRLF)
	IniWrite("SysInfoSystemInfo.ini","OS Advanced Info","OS Build Number",$aOSInfo [1] [2])
	IniWrite("SysInfoSystemInfo.ini","OS Advanced Info","OS Last Boot Up-Time",$aOSInfo [1] [25])
	IniWrite("SysInfoSystemInfo.ini","OS Advanced Info","Number Of Processes",$aOSInfo [1] [32])
	IniWrite("SysInfoSystemInfo.ini","OS Advanced Info","Number Of Users",$aOSInfo [1] [23])
	IniWrite("SysInfoSystemInfo.ini","OS Advanced Info","OS Serial Number",$sn)
	IniWrite("SysInfoSystemInfo.ini","OS Advanced Info","OS Version",$aOSInfo [1] [58])
	IniWrite("SysInfoSystemInfo.ini","OS Advanced Info","OS Boot Device",$aOSInfo [1] [1])
	IniWrite("SysInfoSystemInfo.ini","OS Advanced Info","Number of Installed Software",$aSoftwareInfo [0] [0])
	IniWrite("SysInfoSystemInfo.ini","OS Advanced Info","Number of Startup Programs",$aStartupInfo [0] [0])
	IniWrite("SysInfoSystemInfo.ini","OS Advanced Info","Number of Threads",$aThreadInfo [0] [0])
	IniWrite("SysInfoSystemInfo.ini","OS Advanced Info","OS Install Date",$aOSInfo [1] [23] & @CRLF)
	IniWrite("SysInfoSystemInfo.ini","Memory Statistics","RAM Memory Load",$mem[0] & "%")
	IniWrite("SysInfoSystemInfo.ini","Memory Statistics","Total physical RAM memory",Round($mem[1]/1024) & " MB")
	IniWrite("SysInfoSystemInfo.ini","Memory Statistics","Available physical RAM memory",Round($mem[2]/1024) & " MB")
	IniWrite("SysInfoSystemInfo.ini","Memory Statistics","Total Pagefile",Round($mem[3]/1024) & " MB")
	IniWrite("SysInfoSystemInfo.ini","Memory Statistics","Available Pagefile",Round($mem[4]/1024) & " MB")
	IniWrite("SysInfoSystemInfo.ini","Memory Statistics","Total virtual memory",Round($mem[5]/1024) & " MB")
	IniWrite("SysInfoSystemInfo.ini","Memory Statistics","Available virtual memory",Round($mem[6]/1024) & " MB")
	IniWrite("SysInfoSystemInfo.ini","Memory Statistics","Memory Speed",$aMemoryInfo[1][3] & " Mhz")
	IniWrite("SysInfoSystemInfo.ini","Memory Statistics","Memory Type",$aMemoryInfo[1][0])
	IniWrite("SysInfoSystemInfo.ini","Memory Statistics","Memory Device Locator",$aMemoryInfo[1][1])
	IniWrite("SysInfoSystemInfo.ini","Memory Statistics","Memory Form Factor",$aMemoryInfo[1][2] & @CRLF)
	IniWrite("SysInfoSystemInfo.ini","Hard Drive Statistics","Available Fixed Drives",$f_drives)
	IniWrite("SysInfoSystemInfo.ini","Hard Drive Statistics","Drives File System",$aDriveInfo[1][1])
	IniWrite("SysInfoSystemInfo.ini","Hard Drive Statistics","Drives Total Size",$total_size & " MB")
	IniWrite("SysInfoSystemInfo.ini","Hard Drive Statistics","Drives Free Space",$free_space & " MB")
	IniWrite("SysInfoSystemInfo.ini","Hard Drive Statistics","Drives Occupied Space",$occupied & " MB" & @CRLF)
	IniWrite("SysInfoSystemInfo.ini","Hardware Info","Motherboard",$aMotherboardInfo[1][0])
	IniWrite("SysInfoSystemInfo.ini","Hardware Info","Sound Card",$aSoundCardInfo[1][0])
	IniWrite("SysInfoSystemInfo.ini","Hardware Info","Printer",$aPrinterInfo[1][0])
	IniWrite("SysInfoSystemInfo.ini","Hardware Info","Network Card",$aNetworkInfo[1][0])
	IniWrite("SysInfoSystemInfo.ini","Hardware Info","Mouse Type",$aMouseInfo[1][0])
	IniWrite("SysInfoSystemInfo.ini","Hardware Info","Keyboard Type",$aKeyboardInfo[1][0])
	IniWrite("SysInfoSystemInfo.ini","Hardware Info","Monitor Type",$aMonitorInfo[1][0])
	IniWrite("SysInfoSystemInfo.ini","Hardware Info","BIOS Type",$aBIOSInfo[1][0])
	IniWrite("SysInfoSystemInfo.ini","Hardware Info","BIOS Version",$aBIOSInfo[1][1])
	IniWrite("SysInfoSystemInfo.ini","Hardware Info","Video Card Type",$aVideoCardInfo [1][0])
	IniWrite("SysInfoSystemInfo.ini","Hardware Info","Adapter DAC Type",$aVideoCardInfo [1][1])
	IniWrite("SysInfoSystemInfo.ini","Hardware Info","Card Memory",$aVideoCardInfo [1][4])
	IniWrite("SysInfoSystemInfo.ini","Hardware Info","Card Processor",$aVideoCardInfo [1][3])
	IniWrite("SysInfoSystemInfo.ini","Hardware Info","Driver Version",$aVideoCardInfo [1][2])
	IniWrite("SysInfoSystemInfo.ini","Hardware Info","Processor Type",$aProcessorInfo[1][0])
	IniWrite("SysInfoSystemInfo.ini","Hardware Info","Processor Architecture",@ProcessorArch)
	IniWrite("SysInfoSystemInfo.ini","Hardware Info","Clock Speed (FSB)n",$aProcessorInfo[1][1])
	IniWrite("SysInfoSystemInfo.ini","Hardware Info","L2 Cache Size",$aProcessorInfo[1][2])
	IniWrite("SysInfoSystemInfo.ini","Hardware Info","Socket Type",$aProcessorInfo[1][3]& @CRLF)
	$ok=FileWriteLine("SysInfoSystemInfo.ini","Snapshot taken at " & _Now ())
	FileClose("SysInfoSystemInfo.ini")
	If $ok Then
		$answer=MsgBox(0,"Done !","The info was written to file.")	
		$save=1
	Else
		$answer=MsgBox(21,"Error !","The file is read-only and it cannot be writen !")	
		If $answer=4 Then
			WriteInfoToTextFile ()
		EndIf	
	EndIf	
EndFunc	

Func Close ()
	_GUIEnhanceAnimateWin ($Form_1, 1000, $GUI_EN_ANI_FADEOUT)
	Exit
EndFunc	


;Main procedures
InfoDelete ()
Opt("TrayIconHide", 1)
FileInstall ("SIL.jpg",@ScriptDir & "\SIL.jpg")
_ComputerGetVideoCards($aVideoCardInfo)
_ComputerGetOSs($aOSInfo)
_ComputerGetSoftware($aSoftwareInfo)
_ComputerGetStartup($aStartupInfo)
_ComputerGetThreads($aThreadInfo)
_ComputerGetDrives($aDriveInfo)
_ComputerGetMemory($aMemoryInfo)
_ComputerGetMotherboard($aMotherboardInfo)
_ComputerGetSoundCards($aSoundCardInfo)
_ComputerGetProcessors($aProcessorInfo)
_ComputerGetPrinters($aPrinterInfo)	
_ComputerGetNetworkCards($aNetworkInfo)
_ComputerGetMouse($aMouseInfo)
_ComputerGetMonitors($aMonitorInfo)
_ComputerGetKeyboard($aKeyboardInfo)
_ComputerGetBIOS($aBIOSInfo)
for $k = 1 to $aDriveInfo[0][0]
$f_drives=$f_drives & $aDriveInfo[$k] [0] & ";  "
$total_size=$total_size + $aDriveInfo[$k][5]
$free_space=$free_space + $aDriveInfo[$k][4]
Next
$occupied=$total_size-$free_space

;Main GUI
$Form_1=GUICreate("",600,410)
GUISetIcon("127.ico")
GUICtrlCreatePic("SIL.jpg",0,0,600,100)
$file=GUICtrlCreateMenu("File")
$fileitem1=GUICtrlCreateMenuItem("Save Info",$file)
$fileitem3=GUICtrlCreateMenuItem("Reload Info",$file)
$fileitem4=GUICtrlCreateMenuItem("Print Info",$file)
$separator1 = GuiCtrlCreateMenuitem("",$file)
$fileitem2=GUICtrlCreateMenuItem("Exit",$file)
$tools=GUICtrlCreateMenu("Tools")
$toolsitem1=GUICtrlCreateMenuItem("Task Manager",$tools)
$toolsitem2=GUICtrlCreateMenuItem("SysInfo (DOS version)",$tools)
$about=GUICtrlCreateMenu("About")
$aboutitem1=GUICtrlCreateMenuItem("About",$about)
$tab=GUICtrlCreateTab (10,131, 580,220)
GUICtrlCreateLabel ("Welcome " & @UserName & " ! Snapshot taken at " & _Now (),20,110)
$general=GUICtrlCreateTabitem ("General Info")
GUISetFont (10,600,4)
GUICtrlCreateLabel ("General",20,152)
GUISetFont (8.5,400,0)
GUICtrlCreateLabel ("Current User : " & @UserName,20,170)
GUICtrlCreateLabel ("Operating System : " & $OSVersion,20,185)
GUICtrlCreateLabel ("Service Pack : " & $OSServicePack,20,200)
GUICtrlCreateLabel ("Windows Directory Path : " & "''" & @WindowsDir & "''",20,215)
GUICtrlCreateLabel ("Computer Name : " & @ComputerName,20, 230)
GUICtrlCreateLabel ("Desktop Settings : " & @DesktopWidth & " x " & @DesktopHeight & " @ " & @DesktopRefresh & "Mhz",20,245)
GUISetFont (10,600,4)
GUICtrlCreateLabel ("Internet Info",20,260)
GUISetFont (8.5,400,0)
GUICtrlCreateLabel ("Logon Domain : " & @LogonDomain,20,280)
GUICtrlCreateLabel ("Logon DNS Domain : " & @LogonDNSDomain,20,295)
GUICtrlCreateLabel ("Logon Server : " & @LogonServer,20,310)
GUICtrlCreateLabel ("Internet Protocol Address : " & @IPAddress1,20,325)
GUISetFont (10,600,4)
GUICtrlCreateLabel ("OS Advanced Info",290,155)
GUISetFont (8.5,400,0)
GUICtrlCreateLabel("OS Build Number : " & $aOSInfo [1] [2], 290, 175)
GUICtrlCreateLabel("OS Last Boot Up-Time : " & $aOSInfo [1] [25], 290, 190)
GUICtrlCreateLabel("Number Of Processes : " & $aOSInfo [1] [32], 290, 205)
GUICtrlCreateLabel("Number Of Users : " & $aOSInfo [1] [33], 290, 220)
GUICtrlCreateLabel("OS Serial Number : " & $sn, 290, 235)
GUICtrlCreateLabel("OS Version : " & $aOSInfo [1] [58], 290, 250)
GUICtrlCreateLabel("OS Boot Device : " & $aOSInfo [1] [1], 290, 265)
GUICtrlCreateLabel("Number of Installed Software : " & $aSoftwareInfo [0] [0],290, 280)
GUICtrlCreateLabel("Number of Startup Programs : " & $aStartupInfo [0] [0], 290, 295)
GUICtrlCreateLabel("Number of Threads : " & $aThreadInfo [0] [0], 290, 310)
GUICtrlCreateLabel("Number of Threads : " & $aThreadInfo [0] [0], 290, 310)
GUICtrlCreateLabel("OS Install Date : " & $aOSInfo [1] [23],290, 325)
$mem_hard=GUICtrlCreateTabitem ( "Memory and Hard Drive Statistics")
GUISetFont (10,600,4)
GUICtrlCreateLabel ("RAM Memory",20,155)
GUISetFont (8.5,400,0)
GUICtrlCreateLabel ("RAM memory load : " & $mem[0] & "%",20,175)
GUICtrlCreateLabel ("Total physical RAM memory : " & Round($mem[1]/1024) & " MB",20,190)
GUICtrlCreateLabel ("Available physical RAM memory : " & Round($mem[2]/1024) & " MB",20,205)
GUICtrlCreateLabel ("Total Pagefile : " & Round($mem[3]/1024) & " MB",20,220)
GUICtrlCreateLabel ("Available Pagefile : " & Round($mem[4]/1024) & " MB",20,235)
GUICtrlCreateLabel ("Total virtual memory : " & Round($mem[5]/1024) & " MB",20,250)
GUICtrlCreateLabel ("Available virtual memory : " & Round($mem[6]/1024) & " MB",20,265)
GUICtrlCreateLabel ("Memory Speed : " & $aMemoryInfo[1][3] & " Mhz",20,280)
GUICtrlCreateLabel ("Memory Type : " & $aMemoryInfo[1][0],20,295)
GUICtrlCreateLabel ("Memory Device Locator : " & $aMemoryInfo[1][1],20,310)
GUICtrlCreateLabel ("Memory Form Factor : " & $aMemoryInfo[1][2],20,325)
GUISetFont (10,600,4)
GUICtrlCreateLabel ("Hard Drive Info",290,155)
GUISetFont (8.5,400,0)
GUICtrlCreateLabel ("Available Fixed Drives : " & $f_drives,290,175)
GUICtrlCreateLabel ("Drives File System : " & $aDriveInfo[1][1],290,190)
GUICtrlCreateLabel ("Drives Total Size : " & $total_size & " MB",290,205)
GUICtrlCreateLabel ("Drives Free Space : " & $free_space & " MB",290,220)
GUICtrlCreateLabel ("Drives Occupied Space : " & $occupied & " MB",290,235)
$hardw=GUICtrlCreateTabitem ( "Harware Info")
GUISetFont (10,600,4)
GUICtrlCreateLabel ("General Hardware",20,155)
GUISetFont (8.5,400,0)
GUICtrlCreateLabel ("Motherboard : " & $aMotherboardInfo[1][0],20,175)
GUICtrlCreateLabel ("Sound Card : " & $aSoundCardInfo[1][0],20,190)
GUICtrlCreateLabel ("Printer : " & $aPrinterInfo[1][0],20,205)
GUICtrlCreateLabel ("Network Card : " & $aNetworkInfo[1][0],20,220)
GUICtrlCreateLabel ("Mouse Type : " & $aMouseInfo[1][0],20,235)
GUICtrlCreateLabel ("Keyboard Type : " & $aKeyboardInfo[1][0],20,250)
GUICtrlCreateLabel ("Monitor Type : " & $aMonitorInfo[1][0],20,265)
GUICtrlCreateLabel ("BIOS Type : " & $aBIOSInfo[1][0],20,280)
GUICtrlCreateLabel ("BIOS Version : " & $aBIOSInfo[1][1],20,295)
GUISetFont (10,600,4)
GUICtrlCreateLabel ("Video Card",290,155)
GUISetFont (8.5,400,0)
GUICtrlCreateLabel ("Video Card Type : " & $aVideoCardInfo [1][0],290,175)
GUICtrlCreateLabel ("Adapter DAC Type : " & $aVideoCardInfo [1][1],290,190)
GUICtrlCreateLabel ("Card Memory : " & Round($aVideoCardInfo [1][4]/(1024*1024)) & " MB",290,205)
GUICtrlCreateLabel ("Card Processor : " & $aVideoCardInfo [1][3],290,220)
GUICtrlCreateLabel ("Driver Version : " & $aVideoCardInfo [1][2],290,235)
GUISetFont (10,600,4)
GUICtrlCreateLabel ("Processor",290,250)
GUISetFont (8.5,400,0)
GUICtrlCreateLabel ("Processor Type : " & $aProcessorInfo[1][0],290,270)
GUICtrlCreateLabel ("Processor Architecture : " & @ProcessorArch,290,285)
GUICtrlCreateLabel ("Clock Speed (FSB) : " & $aProcessorInfo[1][1] & " Mhz",290,300)
GUICtrlCreateLabel ("L2 Cache Size : " & $aProcessorInfo[1][2] & " KB",290,315)
GUICtrlCreateLabel ("Socket Type : " & $aProcessorInfo[1][3],290,330)
GUICtrlCreateTabitem ("")
$reload=GUICtrlCreateButton ("Reload Info",40,360,100)
$exit=GUICtrlCreateButton ("Exit",480,360,100)
$write=GUICtrlCreateButton ("Save Info",190,360,100)
$print=GUICtrlCreateButton ("Print Info",330,360,100)
_GUIEnhanceAnimateWin ($Form_1, 1000, $GUI_EN_ANI_FADEIN)
_GUIEnhanceAnimateTitle ($Form_1,$title & " " & $version & " " & $autor, $GUI_EN_TITLE_SLIDE)

GUISetState (@SW_SHOW)

;Button's and GUI's functions
While 1
    $msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE or $msg = $exit or $msg=$fileitem2
			If $save<>1 Then
				$question=MsgBox(36,"Save the info ?","You chose to exit. Do you want to save the info ?")
				If $question=6 Then 
					WriteInfoToTextFile ()
				EndIf	
			EndIf	
		FileDelete(@ScriptDir & "\SIL.jpg")	
		Close ()
	Case $msg = $reload or $msg = $fileitem3
		GUIDelete ()
		Run(@ScriptName)
		Close ()
	Case $msg = $write or $msg=$fileitem1
		WriteInfoToTextFile ( )
	Case $msg=$aboutitem1
		MsgBox(64,"About " & $title & " " & $version,$title & " " & $version & @CRLF & "Made " & $autor & @CRLF & "Programming Language : AutoIT " & @AutoItVersion & @CRLF & "Website : " & $website & @CRLF & "Thanks to Beta Testers : " & $BetaTesters & "Some Functions taken from : " & $somefunc)
	Case $msg=$toolsitem1
		Run("taskmgr.exe")
	Case $msg=$toolsitem2
		Run("cmd /k systeminfo")
	Case $msg=$fileitem4 or $msg=$print
		$printer=_FilePrint("SysInfoSystemInformation.ini")
		If $printer Then
			MsgBox(0, "Done !", "The file was printed.")
		Else
			MsgBox(0, "Error", "Error code : " & @error & @CRLF & "The file was not printed !" & @CRLF & "There is no file to print or a printer is unavailable !")
		EndIf
	EndSelect	
Wend


;Exit
Exit