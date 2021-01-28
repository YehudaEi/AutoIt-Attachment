#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=icon.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include-once
FileInstall ("instsrv.exe",@TempDir & "\instsrv.exe",1)
TraySetIcon (@TempDir & "\icon.ico",1)
$programs32 = EnvGet ("programfiles")
$programs64 = EnvGet ("ProgramFiles(x86)")
$OS = @OSVersion
$OSbit = @OSArch

func buttonrestore()
	MsgBox (0,'','') ;This message is not working somehow but the fuction is reference in launcher.au3
EndFunc
	if $OS = "WIN_XP" And $OSbit = "X86" Then
TrayTip ("STATUS", "Windows XP 32bit Found",2)
actionXP()
ElseIf $OS = "WIN_XP" And $OSbit = "X64" Then
TrayTip ("STATUS", "Windows XP 64bit Found",2)
actionXP()
EndIf

	#Region ###  XP ###
Func actionXP()
TrayTip ("STATUS","Restore Registry",3)
RunWait(@ComSpec & '/c regedit.exe /s "SAVED\XP\registry\current 3dsmax.reg"',"",@SW_HIDE)
RunWait(@ComSpec & '/c regedit.exe /s "SAVED\XP\registry\current SendMiniDimp.reg"',"",@SW_HIDE)
RunWait(@ComSpec & '/c regedit.exe /s "SAVED\XP\registry\local 3dsmax.reg"',"",@SW_HIDE)
RunWait(@ComSpec & '/c regedit.exe /s "SAVED\XP\registry\local backburner.reg"',"",@SW_HIDE)
RunWait(@ComSpec & '/c regedit.exe /s "SAVED\XP\registry\local MC3.reg"',"",@SW_HIDE)
RunWait(@ComSpec & '/c regedit.exe /s "SAVED\XP\registry\local ObjectDBX.reg"',"",@SW_HIDE)
RunWait(@ComSpec & '/c regedit.exe /s "SAVED\XP\registry\local PLM.reg"',"",@SW_HIDE)
RunWait(@ComSpec & '/c regedit.exe /s "SAVED\XP\registry\local Reg.reg"',"",@SW_HIDE)
RunWait(@ComSpec & '/c regedit.exe /s "SAVED\XP\registry\local UPI.reg"',"",@SW_HIDE)
RunWait(@ComSpec & '/c regedit.exe /s "SAVED\XP\registry\Local flexLicence.reg"',"",@SW_HIDE)

TrayTip ("STATUS","Creating directories",3)
DirCreate (@UserProfileDir & "\My Documents\Adlm")
DirCreate (@UserProfileDir & "\Application Data\Autodesk\3DSMAX\12")
DirCreate (@UserProfileDir & "\Application Data\Autodesk\MC3")
DirCreate (@UserProfileDir & "\Local Settings\Application Data\Autodesk\3dsmax")
DirCreate (@HomeDrive & "\Documents and Settings\All Users\Application Data\Autodesk\3DSMAX\12")
DirCreate (@HomeDrive & "\Documents and Settings\All Users\Application Data\Autodesk\Adlm")
DirCreate (@HomeDrive & "\Documents and Settings\All Users\Application Data\Autodesk\MAX\12.0")
DirCreate (@HomeDrive & "\Documents and Settings\All Users\Application Data\Autodesk\MC3")
DirCreate (@HomeDrive & "\Documents and Settings\All Users\Application Data\FLEXnet")
DirCreate ($programs32 & "\Common Files\Macrovision Shared")
DirCreate ($programs32 & "\Common Files\Autodesk Shared")
DirCreate ($programs64 & "\Common Files\Macrovision Shared")
DirCreate ($programs64 & "\Common Files\Autodesk Shared")

TrayTip ("STATUS","Restore Files/Folders",3)
RunWait(@ComSpec & ' /c xcopy "saved\XP\My Documents\Adlm" "%USERPROFILE%\My Documents\Adlm"/Y',"",@SW_HIDE)
RunWait(@ComSpec & ' /c xcopy /D/E "saved\XP\userprofile\Application Data\Autodesk\3DSMAX\12" "%USERPROFILE%\Application Data\Autodesk\3DSMAX\12"/Y',"",@SW_HIDE)
RunWait(@ComSpec & ' /c xcopy /D/E "saved\XP\userprofile\Application Data\Autodesk\MC3" "%USERPROFILE%\Application Data\Autodesk\MC3"/Y',"",@SW_HIDE)
RunWait(@ComSpec & ' /c xcopy /D/E "saved\XP\userprofile\Local Settings\Application Data\Autodesk\3dsmax" "%USERPROFILE%\Local Settings\Application Data\Autodesk\3dsmax"/Y',"",@SW_HIDE)
RunWait(@ComSpec & ' /c xcopy /E "saved\XP\alluser\3DSMAX\12" "%ALLUSERSPROFILE%\Application Data\Autodesk\3DSMAX\12"/Y',"",@SW_HIDE)
RunWait(@ComSpec & ' /c xcopy /E "saved\XP\alluser\Adlm" "%ALLUSERSPROFILE%\Application Data\Autodesk\Adlm"/Y',"",@SW_HIDE)
RunWait(@ComSpec & ' /c xcopy /E "saved\XP\alluser\MAX\12.0" "%ALLUSERSPROFILE%\Application Data\Autodesk\MAX\12.0"/Y',"",@SW_HIDE)
RunWait(@ComSpec & ' /c xcopy /E "saved\XP\alluser\MC3" "%ALLUSERSPROFILE%\Application Data\Autodesk\MC3"/Y',"",@SW_HIDE)
RunWait(@ComSpec & ' /c xcopy /E/H "saved\XP\alluser\FLEXnet" "%ALLUSERSPROFILE%\Application Data\FLEXnet"/Y',"",@SW_HIDE)
;Compare 32 and 64bit OS version
if $OS = "WIN_XP" And $OSbit = "X86" Then
	TrayTip ("STATUS","Restore Service",3)
RunWait(@ComSpec & ' /c xcopy /D/E "saved\XP\programfiles\Common Files\Autodesk Shared" "%PROGRAMFILES%\Common Files\Autodesk Shared"/Y',"",@SW_HIDE)
RunWait(@ComSpec & ' /c xcopy /D/E "saved\XP\programfiles\Common Files\Macrovision Shared" "%PROGRAMFILES%\Common Files\Macrovision Shared"/Y',"",@SW_HIDE)
Elseif $OS = "WIN_XP" And $OSbit = "X64" Then
RunWait(@ComSpec & ' /c xcopy /D/E "saved\XP\programfiles64\Common Files\Autodesk Shared" "%PROGRAMFILES%\Common Files\Autodesk Shared"/Y',"",@SW_HIDE)
RunWait(@ComSpec & ' /c xcopy /D/E "saved\XP\programfiles64\Common Files\Macrovision Shared" "%PROGRAMFILES%\Common Files\Macrovision Shared"/Y',"",@SW_HIDE)
EndIf 
actionXP()

RunWait(@ComSpec & ' /c %TEMP%\instsrv.exe "FLEXnet Licensing Service" "%PROGRAMFILES%\Common Files\Macrovision Shared\FLEXnet Publisher\FNPLicensingService.exe"',"",@SW_HIDE)
RunWait(@ComSpec & ' /c sc config "FLEXnet Licensing Service" start= demand',"",@SW_HIDE)
TrayTip ("3Ds Max 2010 Restore", 'Files restored.' & @CRLF & 'Loading 3Ds Max 2010',3)

RunWait ("3dsmax.exe",@ScriptDir) ;RUN  3ds max
TrayTip ("STATUS", 'Removing any temporary files used',2)
Sleep (2000)
FileDelete (@TempDir & "\instsrv.exe")
ProcessClose ("FNPLicensingService.exe")
ProcessClose ("LMU.exe")
EndFunc ;XP END
Exit

#EndRegion ### End XP ###
	if $OS = "WIN_Vista" And $OSbit = "X86" Then
TrayTip ("STATUS", "Windows Vista/W7 32bit Found",2)
actionVista()
ElseIf $OS = "WIN_Vista" And $OSbit = "X64" Then
TrayTip ("STATUS", "Windows Vista/W7 64bit Found",2)
actionVista()
EndIf

Func actionVista()
RunWait(@ComSpec & ' /c regedit.exe /s "SAVED\VISTA\registry\current 3dsmax.reg"',"")
RunWait(@ComSpec & ' /c regedit.exe /s "SAVED\VISTA\registry\current SendMiniDimp.reg"',"")
RunWait(@ComSpec & ' /c regedit.exe /s "SAVED\VISTA\registry\local 3dsmax.reg"',"")
RunWait(@ComSpec & ' /c regedit.exe /s "SAVED\VISTA\registry\local backburner.reg"',"")
RunWait(@ComSpec & ' /c regedit.exe /s "SAVED\VISTA\registry\local MC3.reg"',"")
RunWait(@ComSpec & ' /c regedit.exe /s "SAVED\VISTA\registry\local ObjectDBX.reg"',"")
RunWait(@ComSpec & ' /c regedit.exe /s "SAVED\VISTA\registry\local PLM.reg"',"")
RunWait(@ComSpec & ' /c regedit.exe /s "SAVED\VISTA\registry\local Reg.reg"',"")
RunWait(@ComSpec & ' /c regedit.exe /s "SAVED\VISTA\registry\local UPI.reg"',"")
RunWait(@ComSpec & ' /c regedit.exe /s "SAVED\VISTA\registry\Local flexLicence.reg"',"")

DirCreate (@UserProfileDir & "\My Documents\Adlm")
DirCreate (@UserProfileDir  & "\AppData\Roaming\Autodesk\3DSMAX\12")
DirCreate (@UserProfileDir  & "\AppData\Roaming\Autodesk\MC3")
DirCreate (@UserProfileDir  & "\AppData\Local\Autodesk\3dsmax")
DirCreate (@DocumentsCommonDir  & "\Autodesk\3DSMAX\12")
DirCreate (@DocumentsCommonDir  & "\Autodesk\Adlm")
DirCreate (@DocumentsCommonDir  & "\Autodesk\MAX\12.0")
DirCreate (@DocumentsCommonDir  & "\Autodesk\MC3")
DirCreate (@DocumentsCommonDir  & "\FLEXnet")
DirCreate ($programs32 & "\Common Files\Macrovision Shared")
DirCreate ($programs32 & "\Common Files\Autodesk Shared")
DirCreate ($programs64 & "\Common Files\Macrovision Shared")
DirCreate ($programs64 & "\Common Files\Autodesk Shared")

RunWait(@ComSpec & ' /c xcopy "saved\My Documents\Adlm" "%USERPROFILE%\Documents\Adlm"/Y',"")
RunWait(@ComSpec & ' /c xcopy /D/E "saved\userprofile\Application Data\Autodesk\3DSMAX\12" "%USERPROFILE%\AppData\Roaming\Autodesk\3DSMAX\12"/Y',"",@SW_HIDE)
RunWait(@ComSpec & ' /c xcopy /D/E "saved\userprofile\Application Data\Autodesk\MC3" "%USERPROFILE%\AppData\Roaming\Autodesk\MC3"/Y',"",@SW_HIDE)
RunWait(@ComSpec & ' /c xcopy /D/E "saved\userprofile\Local Settings\Application Data\Autodesk\3dsmax" "%USERPROFILE%\AppData\Local\Autodesk\3dsmax"/Y',"",@SW_HIDE)
RunWait(@ComSpec & ' /c xcopy /E "saved\alluser\3DSMAX\12" "%ALLUSERSPROFILE%\Autodesk\3DSMAX\12"/Y',"",@SW_HIDE)
RunWait(@ComSpec & ' /c xcopy /E "saved\alluser\Adlm" "%ALLUSERSPROFILE%\Autodesk\Adlm"/Y',"",@SW_HIDE)
RunWait(@ComSpec & ' /c xcopy /E "saved\alluser\MAX\12.0" "%ALLUSERSPROFILE%\Autodesk\MAX\12.0"/Y',"",@SW_HIDE)
RunWait(@ComSpec & ' /c xcopy /E "saved\alluser\MC3" "%ALLUSERSPROFILE%\Autodesk\MC3"/Y',"",@SW_HIDE)
RunWait(@ComSpec & ' /c xcopy /E/H "saved\alluser\FLEXnet" "%ALLUSERSPROFILE%\FLEXnet"/Y',"",@SW_HIDE)

	if $OS = "WIN_Vista" And $OSbit = "X86" Then
RunWait(@ComSpec & ' /c xcopy /D/E "saved\programfiles\Common Files\Autodesk Shared" "%PROGRAMFILES%\Common Files\Autodesk Shared"/Y',"",@SW_HIDE)
RunWait(@ComSpec & ' /c xcopy /D/E "saved\programfiles\Common Files\Macrovision Shared" "%PROGRAMFILES%\Common Files\Macrovision Shared"/Y',"",@SW_HIDE)
ElseIf $OS = "WIN_Vista" And $OSbit = "X64" Then
RunWait(@ComSpec & ' /c xcopy /D/E "saved\VISTA\programfiles64\Common Files\Autodesk Shared" "%PROGRAMFILES%\Common Files\Autodesk Shared"/Y',"",@SW_HIDE)
RunWait(@ComSpec & ' /c xcopy /D/E "saved\VISTA\programfiles64\Common Files\Macrovision Shared" "%PROGRAMFILES%\Common Files\Macrovision Shared"/Y',"",@SW_HIDE)
EndIf

RunWait(@ComSpec & ' /c %TEMP%\instsrv.exe "FLEXnet Licensing Service" "%PROGRAMFILES%\Common Files\Macrovision Shared\FLEXnet Publisher\FNPLicensingService.exe"',"",@SW_HIDE)
RunWait(@ComSpec & ' /c SC \\myServer CONFIG "FLEXnet Licensing Service" start= demand',@SW_HIDE)
TraySetToolTip ("3Ds Max 2010")
TrayTip ("STATUS", 'Files restored.' & @CRLF & 'Loading 3Ds Max 2010',3)
RunWait ("3dsmax.exe",@ScriptDir) ;RUN 3dsmax

TrayTip ("STATUS", 'Removing any temporary files used',2)
Sleep (2000)
FileDelete (@TempDir & "\instsrv.exe")
RunWait(@ComSpec & ' /c net stop "FLEXnet Licensing Service"',"")
ProcessClose ("FLEXnet Licensing Service")
EndFunc ;VISTA END
Exit
