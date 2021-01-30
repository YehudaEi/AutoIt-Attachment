#include <ButtonConstants.au3>
#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include "SysIpControl.au3"
#region Script Options =======================================
;** AUTOIT3 settings
#AutoIt3Wrapper_UseAnsi=N                       ;(Y/N) Use Ansi versions for AutoIt3a or AUT2EXEa. Default=N
#AutoIt3Wrapper_UseX64=N                        ;(Y/N) Use X64 versions for AutoIt3_x64 or AUT2EXE_x64. Default=N
#AutoIt3Wrapper_Version=P                       ;(B/P) Use Beta or Production for AutoIt3 and AUT2EXE. Default is P
#AutoIt3Wrapper_Run_Debug_Mode=N                ;(Y/N)Run Script with console debugging. Default=N
;** AUT2EXE settings
#AutoIt3Wrapper_Icon=icon.ico 					;Filename of the Ico file to use
#AutoIt3Wrapper_OutFile=RunOnceEx_NewSID.exe    ;Target exe/a3x filename.
#AutoIt3Wrapper_OutFile_Type=exe                ;a3x=small AutoIt3 file;  exe=Standalone executable (Default)
#AutoIt3Wrapper_Compression=2                   ;Compression parameter 0-4  0=Low 2=normal 4=High. Default=2
#AutoIt3Wrapper_UseUpx=Y                        ;(Y/N) Compress output program.  Default=Y
#AutoIt3Wrapper_Change2CUI=N                    ;(Y/N) Change output program to CUI in stead of GUI. Default=N
;** Target program Resource info
#AutoIt3Wrapper_Res_Comment=             		;Comment field
#AutoIt3Wrapper_Res_Description=     			;Description field
#AutoIt3Wrapper_Res_Fileversion=0.1.0.20
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=Y  	;(Y/N/P)AutoIncrement FileVersion After Aut2EXE is finished. default=N
;                                   	            P=Prompt, Will ask at Compilation time if you want to increase the versionnumber
#AutoIt3Wrapper_Res_Language=2057	                ;Resource Language code . default 2057=English (United Kingdom)
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © 2009 Franck Grieder      ;Copyright field
#AutoIt3Wrapper_res_requestedExecutionLevel=None   	;None, asInvoker, highestAvailable or requireAdministrator   (default=None)
#AutoIt3Wrapper_Res_SaveSource=Y                 	;(Y/N) Save a copy of the Scriptsource in the EXE resources. default=N
;
#AutoIt3Wrapper_res_field=Made By|Franck Grieder
#AutoIt3Wrapper_res_field=Email|franck dot grieder dot 2007 at gmail dot com
#AutoIt3Wrapper_res_field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_res_field=Compile Date|%date% %time%
; Obfuscator
#AutoIt3Wrapper_Run_Obfuscator=Y                 ;(Y/N) Run Obfuscator before compilation. default=N
#obfuscator_parameters=/cs=0 /cn=0 /cf=0 /cv=0 /sf=1
; cvsWrapper settings
#AutoIt3Wrapper_Run_cvsWrapper=V                 ;(Y/N/V) Run cvsWrapper to update the script source. default=N
#AutoIt3Wrapper_Add_Constants=n
#EndRegion

Global $keyRun="HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
Global $keyRunOnceEx="HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx"
Global $Msg,$KeyNb=99
Global $Scriptname	= StringLeft(@ScriptName,StringLen(@ScriptName)-4)
Global $MyDir=@AppDataCommonDir&"\"&$ScriptName&"\"
Global $NewComputerName
Global $TipsTitle="First boot"
Global $NicName="Local Area Connection"
Global $HostsList="RECEIVER|MSBACKUP|XLARCHIVE|XLBACKUP|XLSTORAGE"

If @Compiled Then
	DirCreate($MyDir)
	FileInstall("NewSID.exe",$MyDir&"NewSID.exe")
	FileInstall("psgetsid.exe",$MyDir&"psgetsid.exe")
;~ 	FileInstall("MDC_SetHKCU.exe",$MyDir&"SetHKCU.exe")
EndIf

$Title="Rename Computer"
IF RegRead($keyRunOnceEx,"Title")=$Title Then ;==> Second Run = Apply NewSID
	FileCreateShortcut ( "Notepad.exe", @DesktopDir&"\hosts" , @SystemDir&"\Drivers\etc" , @SystemDir&"\Drivers\etc\hosts")
	IPGUI()
	GUI()
Else ;==================================> First run = Fill up Registry for next boot
	$PrgPath=$MyDir
	$PrgName=@ScriptName
	If StringUpper(@ScriptDir&"\")<>$PrgPath Then
		DirCreate($PrgPath)
		FileCopy(@ScriptDir&"\"&$PrgName,$PrgPath&$PrgName)
	EndIf
	AddToRunOneEx($Title,"Rename Computer and set New SID",'"'&$PrgPath&$PrgName&'"')
	$PrgName="SetHKCU.exe"
	If FileExists($MyDir&$PrgName) Then
		$Title="SetHKCU"
		FileCopy(@ScriptDir&"\"&$PrgName,$PrgPath&$PrgName)
		AddToRun($Title,'"'&$MyDir&$PrgName&'"')
	EndIf
	If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(65,$Title,"The system is now ready to run NewSID on next boot. You should ghost the system now.")
EndIf
Exit
Func AddToRunOneEx($Title,$PrgName,$FullPathPrg)
	$KeyNb+=1
	RegWrite($keyRunOnceEx,"Title","REG_SZ",$Title)
	RegWrite($keyRunOnceEx&"\"&$KeyNb,"","REG_SZ",$PrgName)
	RegWrite($keyRunOnceEx&"\"&$KeyNb,"1","REG_SZ",$FullPathPrg)
EndFunc

Func AddToRun($Title,$FullPathPrg)
	RegWrite($keyRun,$Title,"REG_SZ",$FullPathPrg)
EndFunc

Func IPGUI()
	$IPGUI = GUICreate("Internet Protocol (TCP/IP) Properties", 394, 239, (@DesktopWidth/2)-200, (@DesktopHeight/2)-120)
	$Tab1 = GUICtrlCreateTab(8, 8, 377, 193)
	GUICtrlSetResizing(-1, $GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$TabSheet1 = GUICtrlCreateTabItem("General")
	$Group1 = GUICtrlCreateGroup("Use the following IP Address :", 24, 64, 345, 117)
	$Label2 = GUICtrlCreateLabel("IP Address :", 40, 92, 61, 17)
	$Label3 = GUICtrlCreateLabel("Subnet mask :", 40, 120, 72, 17)
	$Label4 = GUICtrlCreateLabel("Default Gateway :", 40, 152, 89, 17)
	$IPAddress  = _GUICtrlCreateSysIP($IPGUI, 192,  88 )
	$SubnetMask = _GUICtrlCreateSysIP($IPGUI, 192, 118 )
	$DefGateway = _GUICtrlCreateSysIP($IPGUI, 192, 148 )
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Label1 = GUICtrlCreateLabel("Ask your administrator for the appropriate IP settings", 24, 40, 248, 17)
	GUICtrlCreateTabItem("")
	$IP_ButOK     = GUICtrlCreateButton("OK"    , 228, 208, 75, 24, $WS_GROUP)
	$IP_ButCancel = GUICtrlCreateButton("Cancel", 310, 208, 75, 24, $WS_GROUP)
	_GUICtrlSysIPSetData($IPAddress ,"192."&@HOUR&"."&@MIN&"."&Max (@SEC,1))
	_GUICtrlSysIPSetData($SubnetMask,"255.255.255.0")
;~ 	_GUICtrlSysIPSetData($DefGateway,"192.0.0.254")
	GUISetState(@SW_SHOW)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($IPGUI)
				Exitloop
			Case $IP_ButOK
				local $ip=_GUICtrlSysIPGetData($IPAddress)
				local $snm=_GUICtrlSysIPGetData($SubnetMask)
				local $dg=_GUICtrlSysIPGetData($DefGateway)
				Local $NetShCmd,$Res,$Hcmd,$StdOut
				Select
					Case $dg="0.0.0.0" OR StringLeft($dg,3)="127" ; Empty or DNS Server
						$NetShCmd= 'netsh interface ip set address name="'&$TipsTitle&'" source=static addr='&$ip&' mask='&$snm
					Case Else
						$NetShCmd= 'netsh interface ip set address name="'&$TipsTitle&'" source=static addr='&$ip&' mask='&$snm&' gateway='&$dg&' gwmetric=1'
				EndSelect
				ConsoleWrite('"'&$dg&'"')
				Tip("Setting up TCP/IP")
				ClipPut(@ComSpec & ' /c '&$netshCmd)
				$Hcmd=Run(@ComSpec & ' /c '&$netshCmd,"",@SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
				while 1
					$Res=StdOutRead($Hcmd,True)
					if @error then ExitLoop
					Tip(".")
					sleep(500)
					If $Res<>"" Then					; Si le resultat contient du texte
						$StdOut=StdOutRead($Hcmd,True)	; re-Lecture de la liste des répertoires
						If $StdOut=$Res then ExitLoop 	; ======== Si tout est lu on sort
					EndIf
				WEnd
				IF StringLeft(StringUpper($Res),2)="OK" Then
					Tip(StringLeft(StringUpper($Res),2))
					GUIDelete($IPGUI)
					Exitloop
				Else
					MsgBox(16,"Setup IP Address","Setup failed, check entered values")
				Endif
			Case $IP_ButCancel
				GUIDelete($IPGUI)
				Exitloop
		EndSwitch
	WEnd

EndFunc

Func Gui()
	Local $NetShCmd,$Res,$Hcmd,$StdOut
	Tip("Renaming computer" )
	$GPFComputerRename = GUICreate("Enter or choose a new name for "&@ComputerName, 340, 168, (@DesktopWidth/2)-167, (@DesktopHeight/2)-85, BitOR($WS_SYSMENU,$WS_CAPTION,$WS_POPUP,$WS_POPUPWINDOW,$WS_BORDER,$WS_CLIPSIBLINGS), BitOR($WS_EX_TOPMOST,$WS_EX_WINDOWEDGE))
	$ComputerNamesList = GUICtrlCreateCombo("", 16, 120, 193, 25)
	GUICtrlSetData(-1, $HostsList)
	$BtnRename = GUICtrlCreateButton("Rename + new SID", 220, 110, 110, 22, $BS_DEFPUSHBUTTON)
	$Label1 = GUICtrlCreateLabel("This is a ghosted system, please choose or enter a new computer name."&@CR _
	&"This script will use NewSID from SysInternals to generate a different SID than the original one"&@CR _
	&"Note: Two computers with the same SID should not be connected on the same network !", 16, 8, 299, 80)
	$BtnCancel = GUICtrlCreateButton("New SID only", 220, 140, 110, 22)
	$Label2 = GUICtrlCreateLabel("Rename this computer as :", 16, 100, 162, 20)
	GUISetState(@SW_SHOW)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($GPFComputerRename)
				Exit
			Case $BtnRename
				$NewComputerName=GUICtrlRead ($ComputerNamesList)
				RemoveAutoLogon()
				RegWrite("HKEY_CLASSES_ROOT\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}","","REG_SZ",$NewComputerName)
				RegWrite("HKEY_CLASSES_ROOT\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}","LocalizedString","REG_EXPAND_SZ",$NewComputerName)
				RegWrite("HKEY_CURRENT_USER\SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\EXPLORER\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}","","REG_SZ",$NewComputerName)
				Tip("Stopping IIS")
				RunWait(@ComSpec & " /c " & "NET STOP IISADMIN /y",@TempDir,@SW_HIDE)
				Tip("Storing Old SID")
				RunWait(@ComSpec & ' /c "' & $MyDir&'PsGetSID.exe |FIND "S-">> '& $MyDir&'OldSID.log"',$MyDir,@SW_HIDE)
				Tip("Starting "&"NewSID.exe /a "&$NewComputerName)
				GUISetState(@SW_DISABLE )
				FileWriteLine($MyDir&@ScriptName&".log",@ComSpec & ' /c "' & $MyDir&'NewSID.exe" /a '&$NewComputerName&@CRLF)
				Run(@ComSpec & ' /c "' & $MyDir&'NewSID.exe" /a '&$NewComputerName,$MyDir,@SW_HIDE)
				GUIDelete($GPFComputerRename)
				while 1
					$Res=StdOutRead($Hcmd,True)
					if @error then ExitLoop
					Tip(".")
					sleep(500)
					If $Res<>"" Then						; Si le resultat contient du texte
						$StdOut=StdOutRead($Hcmd,True)	; re-Lecture de la liste des répertoires
						If $StdOut=$Res then ExitLoop 	; ======== Si tout est lu on sort
					EndIf
				WEnd

			Case $BtnCancel
				RegWrite("HKEY_CLASSES_ROOT\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}","","REG_SZ",@ComputerName)
				RegWrite("HKEY_CLASSES_ROOT\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}","LocalizedString","REG_EXPAND_SZ",@ComputerName)
				Tip("Stoping IIS")
				RunWait(@ComSpec & " /c " & "NET STOP IISADMIN /y",@TempDir,@SW_HIDE)
				Tip("Storing Old SID")
				RunWait(@ComSpec & ' /c "' & $MyDir&'PsGetSID.exe |FIND "S-">> '& $MyDir&@ScriptName&'.log"',$MyDir,@SW_HIDE)
				Tip("Starting NewSID "&"NewSID.exe /a ")
				GUISetState(@SW_DISABLE)
				FileWriteLine($MyDir&@ScriptName&".log",@ComSpec & " /c " & $MyDir&"NewSID.exe /a "&$NewComputerName&@CRLF)
				$Hcmd=Run("NewSID.exe /a",$MyDir,@SW_HIDE)
				while 1
					$Res=StdOutRead($Hcmd,True)
					if @error then ExitLoop
					Tip(".")
					sleep(500)
					If $Res<>"" Then						; Si le resultat contient du texte
						$StdOut=StdOutRead($Hcmd,True)	; re-Lecture de la liste des répertoires
						If $StdOut=$Res then ExitLoop 	; ======== Si tout est lu on sort
					EndIf
				WEnd
		EndSwitch
	WEnd
EndFunc

Func Max ($i,$j)
	If $i>$j Then
		Return $i
	Else
		Return $j
	EndIf
EndFunc

Func Tip($Text)
	If $Text="." Then
		$Msg=$Msg&$Text
	Else
		$Msg=$Msg&@CRLF&$Text
	EndIf
	ToolTip($Msg,0,0,$TipsTitle,1)
EndFunc

Func RemoveAutoLogon()
	RegWrite( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" ,"DefaultDomainName" ,"REG_SZ", "")
	RegWrite( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" ,"DefaultUserName" ,"REG_SZ", "")
	RegWrite( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" ,"DefaultPassword" ,"REG_SZ", "")
	RegWrite( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" ,"AutoAdminLogon" ,"REG_SZ", "0")
EndFunc
