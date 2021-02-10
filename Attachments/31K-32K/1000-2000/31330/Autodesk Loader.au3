#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=icon.ico
#AutoIt3Wrapper_outfile=..\Autodesk Loader.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Icon_Add=F:\Danger\Savers fixers\Programs\Autodesk Loader\Source\3dsmax.ico
#AutoIt3Wrapper_Res_Icon_Add=F:\Danger\Savers fixers\Programs\Autodesk Loader\Source\combustion.ico
#AutoIt3Wrapper_Res_Icon_Add=F:\Danger\Savers fixers\Programs\Autodesk Loader\Source\imagemodeler.ico
#AutoIt3Wrapper_Res_Icon_Add=F:\Danger\Savers fixers\Programs\Autodesk Loader\Source\maya.ico
#AutoIt3Wrapper_Res_Icon_Add=F:\Danger\Savers fixers\Programs\Autodesk Loader\Source\mudbox.ico
#AutoIt3Wrapper_Res_Icon_Add=F:\Danger\Savers fixers\Programs\Autodesk Loader\Source\autocad.ico
#AutoIt3Wrapper_Res_Icon_Add=F:\Danger\Savers fixers\Programs\Autodesk Loader\Source\stitcher.ico
#AutoIt3Wrapper_Res_Icon_Add=F:\Danger\Savers fixers\Programs\Autodesk Loader\Source\matchmover.ico
#AutoIt3Wrapper_Res_Icon_Add=F:\Danger\Savers fixers\Programs\Autodesk Loader\Source\composite.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Opt("TrayOnEventMode",1)
Opt("TrayMenuMode",1)
TrayCreateItem("Exit")
TrayItemSetOnEvent(-1,"_Exit") ;About is the function name
TraySetState()
    If FileExists (@ScriptDir & "\maya.exe") = 1 Then
Elseif FileExists (@ScriptDir & "\mudbox.exe") = 1 Then
Elseif FileExists (@ScriptDir & "\3dsmax.exe") = 1 Then
Elseif FileExists (@ScriptDir & "\combustion.exe") = 1 Then
Elseif FileExists (@ScriptDir & "\StitcherUnlimited.exe") = 1 Then
Elseif FileExists (@ScriptDir & "\ImageModeler.exe") = 1 Then
Elseif FileExists (@ScriptDir & "\acad.exe") = 1 Then
Elseif FileExists (@ScriptDir & "\MatchMoverApp.exe") = 1 Then
Elseif FileExists (@ScriptDir & "\composite.exe") = 1 Then
Else
	MsgBox(16,"Error"," Loader did not find any Autodesk product executable." & @CRLF & "Place Loader next to program executable and try again.")
	;exit
EndIf
$Run = FileRead (@ScriptDir & "LoaderStatus")
If $Run = "Running" Then
	_RunApp()
	exit
EndIf
$Saved = (StringLeft (@ScriptFullPath,3) & "Saved\Autodesk")
$UserLocal = RegRead('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', 'Local AppData')
$UserRoaming = @AppDataDir
$Documents = @MyDocumentsDir
$AllUsersProgramData = @AppDataCommonDir

$FirstRun = "0"
If FileExists ($Saved & "\AutodeskLoaderTimeStamp") = 0 Then
	Assign ("FirstRun",1)
	FileWrite ($Saved & "\AutodeskLoaderTimeStamp",'')
EndIf
$LocalTime = StringTrimRight (FileGetTime (@WindowsDir & "\AutodeskLoaderTimeStamp",0,1),2)
$RemoteTime = StringTrimRight (FileGetTime ($Saved & "\AutodeskLoaderTimeStamp",0,1),2)
If $LocalTime > $RemoteTime Then Assign ("FirstRun",1)
If $FirstRun = "1" Then
	$AskToRestore = MsgBox(64+4,"Question","Looks like this loader runs for the first time." & @CRLF & "Would you like to restore now ?")
	If $AskToRestore = 6 Then
		_restore()
		_RegistryRestore()
		FileDelete (@ScriptDir & "LoaderStatus")
		FileWrite (@ScriptDir & "LoaderStatus", "Running")
		_RunApp()
		_backup()
		_registrybackup()
		FileDelete ($Saved & "\AutodeskLoaderTimeStamp")
		FileWrite ($Saved & "\AutodeskLoaderTimeStamp",'')
		FileDelete (@WindowsDir & "\AutodeskLoaderTimeStamp")
		FileWrite (@WindowsDir & "\AutodeskLoaderTimeStamp",'')
		FileDelete (@ScriptDir & "LoaderStatus")
		exit
	Else
		MsgBox(16,"Information","Data was not restored. AutodeskLoaderTimeStamp will update on exit")
	EndIf
EndIf

_restore()
_RegistryRestore()
FileDelete (@ScriptDir & "LoaderStatus")
FileWrite (@ScriptDir & "LoaderStatus", "Running")
_RunApp()
_backup()
_registrybackup()
FileDelete ($Saved & "\AutodeskLoaderTimeStamp")
FileWrite ($Saved & "\AutodeskLoaderTimeStamp",'')
FileDelete (@WindowsDir & "\AutodeskLoaderTimeStamp")
FileWrite (@WindowsDir & "\AutodeskLoaderTimeStamp",'')
FileDelete (@ScriptDir & "LoaderStatus")
Exit
Func _restore()
#Region ;Program Files
If FileExists ($Saved & '\Program Files\Autodesk\Backburner') = 1 Then
	TrayTip ("Synchronizing Program Files Backburner'","Please wait",10)
	DirCreate (@HomeDrive & "\Program Files\Autodesk\Backburner")
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $Saved & '\Program Files\Autodesk\Backburner' & '" "' & @HomeDrive & '\Program Files\Autodesk\Backburner"',"",@SW_HIDE)
EndIf
If FileExists ($Saved & '\Program Files\Autodesk') = 1 Then
	TrayTip ("Synchronizing Program Files Autodesk","Please wait",10)
	DirCreate (@HomeDrive & "\Program Files\Autodesk")
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $Saved & '\Program Files\Autodesk' & '" "' & @HomeDrive & '\Program Files\Autodesk"',"",@SW_HIDE)
EndIf
If FileExists ($Saved & '\Program Files\Common Files\Autodesk') = 1 Then
	TrayTip ("Synchronizing Program Files Common Autodesk ","Please wait",10)
	DirCreate (@HomeDrive & "\Program Files\Common Files\Autodesk")
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $Saved & '\Program Files\Common Files\Autodesk' & '" "' & @HomeDrive & '\Program Files\Common Files\Autodesk"',"",@SW_HIDE)
EndIf
If FileExists ($Saved & '\Program Files\Common Files\Autodesk Shared') = 1 Then
	TrayTip ("Synchronizing Program Files Common Autodesk Shared","Please wait",10)
	DirCreate (@HomeDrive & "\Program Files\Common Files\Autodesk Shared")
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $Saved & '\Program Files\Common Files\Autodesk Shared' & '" "' & @HomeDrive & '\Program Files\Common Files\Autodesk Shared"',"",@SW_HIDE)
EndIf
If FileExists ($Saved & '\Program Files\Common Files\Macrovision Shared') = 1 Then
	TrayTip ("Synchronizing Program Files Common Macrovision Shared","Please wait",10)
	DirCreate (@HomeDrive & "\Program Files\Common Files\Macrovision Shared")
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $Saved & '\Program Files\Common Files\Macrovision Shared' & '" "' & @HomeDrive & '\Program Files\Common Files\Macrovision Shared"',"",@SW_HIDE)
EndIf
#EndRegion

#Region ;Program Files (X86)
If FileExists ($Saved & '\Program Files (X86)\Autodesk\Backburner') = 1 Then
	TrayTip ("Synchronizing Program Files (X86) Backburner","Please wait",10)
	DirCreate (@HomeDrive & "\Program Files (X86)\Autodesk\Backburner")
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $Saved & '\Program Files (X86)\Autodesk\Backburner' & '" "' & @HomeDrive & '\Program Files (X86)\Autodesk\Backburner"',"",@SW_HIDE)
EndIf
If FileExists ($Saved & '\Program Files (X86)\Autodesk') = 1 Then
	TrayTip ("Synchronizing Program Files (X86) Autodesk","Please wait",10)
	DirCreate (@HomeDrive & "\Program Files (X86)\Autodesk")
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $Saved & '\Program Files (X86)\Autodesk' & '" "' & @HomeDrive & '\Program Files (X86)\Autodesk"',"",@SW_HIDE)
EndIf
If FileExists ($Saved & '\Program Files (X86)\Common Files\Autodesk') = 1 Then
	TrayTip ("Synchronizing Program Files (X86) Common Autodesk","Please wait",10)
	DirCreate (@HomeDrive & "\Program Files (X86)\Common Files\Autodesk")
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $Saved & '\Program Files (X86)\Common Files\Autodesk' & '" "' & @HomeDrive & '\Program Files (X86)\Common Files\Autodesk"',"",@SW_HIDE)
EndIf
If FileExists ($Saved & '\Program Files (X86)\Common Files\Autodesk Shared') = 1 Then
	TrayTip ("Synchronizing Program Files (X86) Common Autodesk shared","Please wait",10)
	DirCreate (@HomeDrive & "\Program Files (X86)\Common Files\Autodesk Shared")
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $Saved & '\Program Files (X86)\Common Files\Autodesk Shared' & '" "' & @HomeDrive & '\Program Files (X86)\Common Files\Autodesk Shared"',"",@SW_HIDE)
EndIf
If FileExists ($Saved & '\Program Files (X86)\Common Files\Macrovision Shared') = 1 Then
	TrayTip ("Synchronizing Program Files (X86) Common macrovision shared","Please wait",10)
	DirCreate (@HomeDrive & "\Program Files (X86)\Common Files\Macrovision Shared")
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $Saved & '\Program Files (X86)\Common Files\Macrovision Shared' & '" "' & @HomeDrive & '\Program Files (X86)\Common Files\Macrovision Shared"',"",@SW_HIDE)
EndIf
#EndRegion
#Region ;UserLocal
If FileExists ($Saved & '\UserLocal\Autodesk') = 1 Then
	TrayTip ("Synchronizing UserLocal Autodesk","Please wait",10)
	DirCreate ($UserLocal & "\Autodesk")
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $Saved & '\UserLocal\Autodesk' & '" "' & $UserLocal & '\Autodesk"',"",@SW_HIDE)
EndIf
If FileExists ($Saved & '\UserLocal\FLEXnet') = 1 Then
	TrayTip ("Synchronizing UserLocal FLEXnet","Please wait",10)
	DirCreate ($UserLocal & "\FLEXnet")
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $Saved & '\UserLocal\FLEXnet' & '" "' & $UserLocal & '\FLEXnet"',"",@SW_HIDE)
EndIf
#EndRegion
#Region ;UserRoaming
If FileExists ($Saved & '\UserRoaming\Autodesk') = 1 Then
	TrayTip ("Synchronizing UserRoaming Autodesk","Please wait",10)
	DirCreate ($UserRoaming & "\Autodesk")
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $Saved & '\UserRoaming\Autodesk' & '" "' & $UserRoaming & '\Autodesk"',"",@SW_HIDE)
EndIf
If FileExists ($Saved & '\UserRoaming\FLEXnet') = 1 Then
	TrayTip ("Synchronizing UserRoaming FLEXnet","Please wait",10)
	DirCreate ($UserRoaming & "\FLEXnet")
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $Saved & '\UserRoaming\FLEXnet' & '" "' & $UserRoaming & '\FLEXnet"',"",@SW_HIDE)
EndIf
#EndRegion
#Region ;AllUsersProgramData
If FileExists ($AllUsersProgramData & "\Autodesk") = 1 Then
	TrayTip ("Synchronizing AllUsersProgramData Autodesk","Please wait",10)
	DirCreate ($Saved & '\AllUsersProgramData\Autodesk')
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $UserRoaming & '\Autodesk' & '" "' & $Saved & '\AllUsersProgramData\Autodesk"',"",@SW_HIDE)
EndIf
If FileExists ($AllUsersProgramData & "\FLEXnet") = 1 Then
	TrayTip ("Synchronizing AllUsersProgramData FLEXnet","Please wait",10)
	DirCreate ($Saved & '\AllUsersProgramData\FLEXnet')
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $AllUsersProgramData & '\FLEXnet' & '" "' & $Saved & '\AllUsersProgramData\FLEXnet"',"",@SW_HIDE)
EndIf
#EndRegion
#Region ;Documents
If FileExists ($Saved & '\Documents\MudBox') = 1 Then
	TrayTip ("Synchronizing data","Please wait",10)
	DirCreate ($Documents & "\MudBox")
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $Saved & '\Documents\MudBox' & '" "' & $Documents & '\MudBox"',"",@SW_HIDE)
EndIf
If FileExists ($Saved & '\Documents\3dsmax') = 1 Then
	TrayTip ("Synchronizing data","Please wait",10)
	DirCreate ($Documents & "\3dsmax")
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $Saved & '\Documents\3dsmax' & '" "' & $Documents & '\3dsmax"',"",@SW_HIDE)
EndIf
If FileExists ($Saved & '\Documents\maya') = 1 Then
	TrayTip ("Synchronizing data","Please wait",10)
	DirCreate ($Documents & "\maya")
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $Saved & '\Documents\maya' & '" "' & $Documents & '\maya"',"",@SW_HIDE)
EndIf
If FileExists ($Saved & '\Documents\toxik') = 1 Then
	TrayTip ("Synchronizing toxik Documents","Please wait",10)
	DirCreate ($Documents & "\toxik")
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $Saved & '\Documents\toxik' & '" "' & $Documents & '\toxik"',"",@SW_HIDE)
EndIf
#EndRegion
EndFunc
Func _RegistryRestore()
TrayTip ("Synchronizing Current Autodesk registry","Please wait",10)
RunWait(@WindowsDir & '\regedit.exe /e "' & $Saved & '\Registry\Current Autodesk.reg"',"",@SW_HIDE)
TrayTip ("Synchronizing Current Macrovision registry","Please wait",10)
RunWait(@WindowsDir & '\regedit.exe /e "' & $Saved & '\Registry\Current Macrovision.reg"',"",@SW_HIDE)
TrayTip ("Synchronizing Local Autodesk registry","Please wait",10)
RunWait(@WindowsDir & '\regedit.exe /e "' & $Saved & '\Registry\Local Autodesk.reg"',"",@SW_HIDE)
TrayTip ("Synchronizing Local Macrovision registry","Please wait",10)
RunWait(@WindowsDir & '\regedit.exe /e "' & $Saved & '\Registry\Local Macrovision.reg"',"",@SW_HIDE)
TrayTip ("Synchronizing Local Discreet registry","Please wait",10)
RunWait(@WindowsDir & '\regedit.exe /e "' & $Saved & '\Registry\Local Discreet.reg"',"",@SW_HIDE)
TrayTip ("Synchronizing Local FLEXlm License Manager registry","Please wait",10)
RunWait(@WindowsDir & '\regedit.exe /e "' & $Saved & '\Registry\Local FLEXlm License Manager.reg"',"",@SW_HIDE)
TrayTip ("Synchronizing Local Wow6432Node Autodesk registry","Please wait",10)
RunWait(@WindowsDir & '\regedit.exe /e "' & $Saved & '\Registry\Local Wow6432Node Autodesk.reg"',"",@SW_HIDE)
TrayTip ("Synchronizing Local Wow6432Node Discreet registry","Please wait",10)
RunWait(@WindowsDir & '\regedit.exe /e "' & $Saved & '\Registry\Local Wow6432Node Discreet.reg"',"",@SW_HIDE)
TrayTip ("Synchronizing Local Wow6432Node Macrovision registry","Please wait",10)
RunWait(@WindowsDir & '\regedit.exe /e "' & $Saved & '\Registry\Local Wow6432Node Macrovision.reg"',"",@SW_HIDE)
EndFunc
Func _RunApp()
	TrayTip ("Starting application","Please wait",3)
	RunWait (@ScriptDir & "\3dsmax.exe")
	RunWait (@ScriptDir & "\combustion.exe")
	RunWait (@ScriptDir & "\ImageModeler.exe")
	RunWait (@ScriptDir & "\mudbox.exe")
	RunWait (@ScriptDir & "\maya.exe")
	RunWait (@ScriptDir & "\StitcherUnlimited.exe")
	RunWait (@ScriptDir & "\acad.exe")
	RunWait (@ScriptDir & "\MatchMoverApp.exe")
	RunWait (@ScriptDir & "\composite.exe")
EndFunc
Func _backup()
#Region ;Program Files
If FileExists (@HomeDrive & "\Program Files\Autodesk\Backburner") = 1 Then
	TrayTip ("Synchronizing Program Files Backburner","Please wait",10)
	DirCreate ($Saved & '\Program Files\Autodesk\Backburner')
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & @HomeDrive & '\Program Files\Autodesk\Backburner' & '" "' & $Saved & '\Program Files\Autodesk\Backburner"',"",@SW_HIDE)
EndIf
If FileExists (@HomeDrive & "\Program Files\Autodesk") = 1 Then
	TrayTip ("Synchronizing Program Files Autodesk","Please wait",10)
	DirCreate ($Saved & '\Program Files\Autodesk')
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & @HomeDrive & '\Program Files\Autodesk' & '" "' & $Saved & '\Program Files\Autodesk"',"",@SW_HIDE)
EndIf
If FileExists (@HomeDrive & "\Program Files\Common Files\Autodesk") = 1 Then
	TrayTip ("Synchronizing Program Files Common Autodesk","Please wait",10)
	DirCreate ($Saved & '\Program Files\Common Files\Autodesk')
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & @HomeDrive & '\Program Files\Common Files\Autodesk' & '" "' & $Saved & '\Program Files\Common Files\Autodesk"',"",@SW_HIDE)
EndIf
If FileExists (@HomeDrive & "\Program Files\Common Files\Autodesk Shared") = 1 Then
	TrayTip ("Synchronizing Program Files Common Autodesk shared","Please wait",10)
	DirCreate ($Saved & '\Program Files\Common Files\Autodesk Shared')
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & @HomeDrive & '\Program Files\Common Files\Autodesk Shared' & '" "' & $Saved & '\Program Files\Common Files\Autodesk Shared"',"",@SW_HIDE)
EndIf
If FileExists (@HomeDrive & "\Program Files\Common Files\Macrovision Shared") = 1 Then
	TrayTip ("Synchronizing Program Files Common macrovision","Please wait",10)
	DirCreate ($Saved & '\Program Files\Common Files\Macrovision Shared')
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & @HomeDrive & '\Program Files\Common Files\Macrovision Shared' & '" "' & $Saved & '\Program Files\Common Files\Macrovision Shared"',"",@SW_HIDE)
EndIf
#EndRegion

#Region ;Program Files (X86)
If FileExists (@HomeDrive & "\Program Files (X86)\Autodesk\Backburner") = 1 Then
	TrayTip ("Synchronizing Program Files (X86) Backburner","Please wait",10)
	DirCreate ($Saved & '\Program Files (X86)\Autodesk\Backburner')
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & @HomeDrive & '\Program Files (X86)\Autodesk\Backburner' & '" "' & $Saved & '\Program Files (X86)\Autodesk\Backburner"',"",@SW_HIDE)
EndIf
If FileExists (@HomeDrive & "\Program Files (X86)\Autodesk") = 1 Then
	TrayTip ("Synchronizing Program Files (X86) Autodesk","Please wait",10)
	DirCreate ($Saved & '\Program Files (X86)\Autodesk')
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & @HomeDrive & '\Program Files (X86)\Autodesk' & '" "' & $Saved & '\Program Files (X86)\Autodesk"',"",@SW_HIDE)
EndIf
If FileExists (@HomeDrive & "\Program Files (X86)\Common Files\Autodesk") = 1 Then
	TrayTip ("Synchronizing Program Files (X86) Common Autodesk","Please wait",10)
	DirCreate ($Saved & '\Program Files (X86)\Common Files\Autodesk')
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & @HomeDrive & '\Program Files (X86)\Common Files\Autodesk' & '" "' & $Saved & '\Program Files (X86)\Common Files\Autodesk"',"",@SW_HIDE)
EndIf
If FileExists (@HomeDrive & "\Program Files (X86)\Common Files\Autodesk Shared") = 1 Then
	TrayTip ("Synchronizing Program Files (X86) Common Autodesk shared","Please wait",10)
	DirCreate ($Saved & '\Program Files (X86)\Common Files\Autodesk Shared')
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & @HomeDrive & '\Program Files (X86)\Common Files\Autodesk Shared' & '" "' & $Saved & '\Program Files (X86)\Common Files\Autodesk Shared"',"",@SW_HIDE)
EndIf
If FileExists (@HomeDrive & "\Program Files (X86)\Common Files\Macrovision Shared") = 1 Then
	TrayTip ("Synchronizing Program Files (X86) Common Macrovision","Please wait",10)
	DirCreate ($Saved & '\Program Files (X86)\Common Files\Macrovision Shared')
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & @HomeDrive & '\Program Files (X86)\Common Files\Macrovision Shared' & '" "' & $Saved & '\Program Files (X86)\Common Files\Macrovision Shared"',"",@SW_HIDE)
EndIf
#EndRegion
#Region ;UserLocal
If FileExists ($UserLocal & "\Autodesk") = 1 Then
	TrayTip ("Synchronizing UserLocal","Please wait",10)
	DirCreate ($Saved & '\UserLocal\Autodesk')
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $UserLocal & '\Autodesk' & '" "' & $Saved & '\UserLocal\Autodesk"',"",@SW_HIDE)
EndIf
If FileExists ($UserLocal & "\FLEXnet") = 1 Then
	TrayTip ("Synchronizing UserLocal","Please wait",10)
	DirCreate ($Saved & '\UserLocal\FLEXnet')
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $UserLocal & '\FLEXnet' & '" "' & $Saved & '\UserLocal\FLEXnet"',"",@SW_HIDE)
EndIf
#EndRegion
#Region ;UserRoaming
If FileExists ($UserRoaming & "\Autodesk") = 1 Then
	TrayTip ("Synchronizing UserRoaming","Please wait",10)
	DirCreate ($Saved & '\UserRoaming\Autodesk')
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $UserRoaming & '\Autodesk' & '" "' & $Saved & '\UserRoaming\Autodesk"',"",@SW_HIDE)
EndIf
If FileExists ($UserRoaming & "\FLEXnet") = 1 Then
	TrayTip ("Synchronizing UserRoaming","Please wait",10)
	DirCreate ($Saved & '\UserRoaming\FLEXnet')
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $UserRoaming & '\FLEXnet' & '" "' & $Saved & '\UserRoaming\FLEXnet"',"",@SW_HIDE)
EndIf
#EndRegion
#Region ;AllUsersProgramData
If FileExists ($AllUsersProgramData & "\Autodesk") = 1 Then
	TrayTip ("Synchronizing programdata","Please wait",10)
	DirCreate ($Saved & '\AllUsersProgramData\Autodesk')
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $UserRoaming & '\Autodesk' & '" "' & $Saved & '\AllUsersProgramData\Autodesk"',"",@SW_HIDE)
EndIf
If FileExists ($AllUsersProgramData & "\FLEXnet") = 1 Then
	TrayTip ("Synchronizing programdata","Please wait",10)
	DirCreate ($Saved & '\AllUsersProgramData\FLEXnet')
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $AllUsersProgramData & '\FLEXnet' & '" "' & $Saved & '\AllUsersProgramData\FLEXnet"',"",@SW_HIDE)
EndIf
#EndRegion
#Region ;Documents
If FileExists ($Documents & "\MudBox") = 1 Then
	TrayTip ("Synchronizing mudbox Documents","Please wait",10)
	DirCreate ($Saved & '\Documents\MudBox')
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $Documents & '\MudBox' & '" "' & $Saved & '\Documents\MudBox"',"",@SW_HIDE)
EndIf
If FileExists ($Documents & "\3dsmax") = 1 Then
	TrayTip ("Synchronizing 3dsmax Documents","Please wait",10)
	DirCreate ($Saved & '\Documents\3dsmax')
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $Documents & '\3dsmax' & '" "' & $Saved & '\Documents\3dsmax"',"",@SW_HIDE)
EndIf
If FileExists ($Documents & "\maya") = 1 Then
	TrayTip ("Synchronizing maya Documents","Please wait",10)
	DirCreate ($Saved & '\Documents\maya')
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $Documents & '\maya' & '" "' & $Saved & '\Documents\maya"',"",@SW_HIDE)
EndIf
If FileExists ($Saved & '\Documents\toxik') = 1 Then
	TrayTip ("Synchronizing toxik Documents","Please wait",10)
	DirCreate ($Documents & "\toxik")
	RunWait (@ComSpec & ' /c xcopy /E/H/D/C/Y ' & '"' & $Documents & '\toxik' & '" "' & $Saved & '\Documents\toxik"',"",@SW_HIDE)
EndIf
#EndRegion
EndFunc
Func _registrybackup()
DirCreate ($Saved & "\Registry")
TrayTip ("Synchronizing registry","Please wait",10)
RunWait(@WindowsDir & '\regedit.exe /e "' & $Saved & '\Registry\Current Autodesk.reg" "HKEY_CURRENT_MACHINE\SOFTWARE\Autodesk"')
TrayTip ("Synchronizing registry","Please wait",10)
RunWait(@WindowsDir & '\regedit.exe /e "' & $Saved & '\Registry\Current Macrovision.reg" "HKEY_CURRENT_MACHINE\SOFTWARE\Autodesk"')
TrayTip ("Synchronizing registry","Please wait",10)
RunWait(@WindowsDir & '\regedit.exe /e "' & $Saved & '\Registry\Local Autodesk.reg" "HKEY_LOCAL_MACHINE\SOFTWARE\Autodesk"')
TrayTip ("Synchronizing registry","Please wait",10)
RunWait(@WindowsDir & '\regedit.exe /e "' & $Saved & '\Registry\Local Macrovision.reg" "HKEY_LOCAL_MACHINE\SOFTWARE\Macrovision"')
TrayTip ("Synchronizing Local Discreet registry","Please wait",10)
RunWait(@WindowsDir & '\regedit.exe /e "' & $Saved & '\Registry\Local Discreet.reg" "HKEY_LOCAL_MACHINE\SOFTWARE\Discreet"')
TrayTip ("Synchronizing Local FLEXlm License Manager registry","Please wait",10)
RunWait (@WindowsDir & '\regedit.exe /e "' & $Saved & '\Registry\Local FLEXlm License Manager.reg" "HKEY_LOCAL_MACHINE\SOFTWARE\FLEXlm License Manager"')
TrayTip ("Synchronizing registry","Please wait",10)
RunWait(@WindowsDir & '\regedit.exe /e "' & $Saved & '\Registry\Local Wow6432Node Autodesk.reg" "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Autodesk"')
TrayTip ("Synchronizing Local Wow6432Node Discreet registry","Please wait",10)
RunWait(@WindowsDir & '\regedit.exe /e "' & $Saved & '\Registry\Local Wow6432Node Discreet.reg" "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Discreet"')
TrayTip ("Synchronizing registry","Please wait",10)
RunWait(@WindowsDir & '\regedit.exe /e "' & $Saved & '\Registry\Local Wow6432Node Macrovision.reg" "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Macrovision"')
Endfunc
Func _Exit()
	FileDelete (@ScriptDir & "LoaderStatus")
	Exit
EndFunc