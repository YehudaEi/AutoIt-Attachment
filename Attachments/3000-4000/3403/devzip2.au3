;DevZipper
;This program reads the .dev files and creates a .7z Archive with the project files.
;It will add if present, the default .exe.  If not present it will
;add if present, the override output file.
;It will also add then .dev file to the archive.
;This utility also checks the command line for the .dev file.
;Therefore it can be used from the tools menu in Dev-cpp or as a Rt-context menu extention.
if FileExists("clamp.ico") then
#Compiler_Icon = clamp.ico
EndIf

#include <Process.au3>
#include <File.au3>

;variables and constants
$Debug = RegRead("HKEY_CURRENT_USER\Software\Dev-7zipper","Mode")
$msgFileDlg = "Open File"
Global $7zExe ="" 
Global $7zCommand =' a -t7z '
Global $7zParams = ""
Global $DevFile = ""
Dim $szDrive, $szDir, $szFName, $szExt,$List

;Begin program
MainLoop()
Exit 

Func Find7zExe()
    $regval1 = RegRead("HKEY_CURRENT_USER\Software\7-Zip","Path")
	$regval2 = RegRead("HKEY_CURRENT_USER\Software\Dev-7zipper","7zExePath")
	if $regval1 = ""then 
		if  $regval2 = "" then 
			$7zExe = Browse7z()
		Else
			$7zExe = $regval2
		EndIf
	Else
		$7zExe = $regval1 & "\7z.exe"
	EndIf
	
	if $7zExe = "" or (not FileExists($7zExe)) Then
		msgbox(4096,"Dev-7Zipper error:","7z.exe not found!"&@CRLF&"Exiting Progam",10)
		Exit
	Else
		RegWrite("HKEY_CURRENT_USER\Software\Dev-7zipper","7zExePath","REG_SZ",$7zExe)
	EndIf		 
EndFunc

;User Functions 

Func MainLoop()	
	Find7zExe()
	ReadCmdl()
	
	if GetUnits() > 0 Then $List = CreateList(GetUnits())
	if $List <> "" Then
			SplashTextOn("Dev-7zipper",@CRLF&@CRLF&"Creating Archive...",200,100 , -1, -1, 1, "")
			;msgbox(4096,"Dev-7zipper","Creating Archive...",10)
			$retval = CreateArchive($List,'"'&$DevFile&'.7z" ')
			if not $retval then
				ControlSetText("Dev-7zipper", "", "Static1",@CRLF&@CRLF& "Archive Complete")
				Sleep(1000)
				;msgbox(4096,"Dev-7zipper","Archive Completed.",10)
			Else
				msgbox(4096,"Dev-7zipper"&$retval,"Unspecified error.",10)
			EndIf
			SplashOff()
	EndIf
EndFunc

Func ReadCmdL()
	if $CmdLine[0] <> 0 Then 
		_PathSplit($CmdLine[1], $szDrive, $szDir, $szFName, $szExt)
		if StringLower($szExt) = ".dev" then ;is this a dev project file?
			$DevFile = $CmdLine[1];yes
			FileChangeDir($SzDrive&$SzDir)
		EndIf
		
	EndIf
	
	if $DevFile ="" then 
		$DevFile = FileOpenDialog( $msgFileDlg, "C:\Dev-cpp\Projects\", "Dev-cpp(*.dev)", 1 + 4 )
	EndIf

	If @error  Then
		MsgBox(4096,"Error","No File(s) chosen"&@crlf&"Exiting Program.")
		exit 1
	EndIf
EndFunc

Func GetUnits()
	$DevFile = StringReplace($DevFile, "|", @CRLF)
     ;MsgBox(4096,"","You chose " & $DevFile)
	 $GetUnits = iniread($DevFile,"Project","UnitCount",0)
	 if $GetUnits < 1 then 	MsgBox(4096,"Error","This project is empty",3)
	 Return $GetUnits
EndFunc

Func CreateList($units)
	$7zParams = AddParam($7zParams,$DevFile)
	CheckExe()
	dim $DevFilestocomp[$units +1]
		for $x = 1 to $units
		$DevFilestocomp = iniread($DevFile,"Unit"&$x,"FileName","")
		if @error then 
			msgbox(4096,"Error:","Error reading file"&@crlf&"Exiting program.",20)
  			exit 1
		EndIf
		$cmdlFilename= @WorkingDir &"\"& $DevFilestocomp
		
		if FileExists($cmdlFilename) Then
			;$7zParams = $7zParams &" "& '"'&$cmdlFilename &'"'
			$7zParams =AddParam($7zParams,$cmdlFilename)
		Else
			MsgBox(4096,"Error:","The file: " & $cmdlFilename &" was not found!",5)
		EndIf
	next
	Return $7zParams
EndFunc

Func CreateArchive($7zArcFiles,$7zDest)
	if $7zArcFiles <> "" then
		 $7zCommandLine=$7zExe & $7zCommand & $7zDest &$7zArcFiles
		if $Debug then
			ClipPut($7zCommandline);copy the commandline to the clipboard.
			msgbox(4096,"Dev-7zipper","Command Line"&$7zCommandline,10)
		EndIf
		 ;msgbox(4096,"Command Line","start "&'"'&$7zExe&$DevFile&'.7z "'& $7zArcFiles,10)
		 return RunWait($7zCommandLine,@WorkingDir,@SW_HIDE)
	 Else
		 msgbox(4096,"Error","Nothing to archive",5)
	EndIf
EndFunc

func AddParam($param,$addFile)
	return  $param &'"'&$addFile &'" '
EndFunc

Func CheckExe()
	_PathSplit($DevFile, $szDrive, $szDir, $szFName, $szExt)
	$TestExe= _PathMake($szDrive, $szDir, $szFName, ".exe")
	if not FileExists($TestExe) Then 
		$TestExe = @WorkingDir &"\"& iniread($DevFile,"Project","OverrideOutputName","")
		if not FileExists($TestExe) then 
			$TestExe = ""
			Return
		EndIf
	Else
		$7zParams=AddParam($7zParams,$TestExe)
	EndIf
EndFunc	
	
Func Browse7z()
	$OKCancel = MsgBox(4097,"Dev-7zipper:","Unable to locate 7z.exe"&@crlf&"Press OK to Browse for it, Cancel to Exit.",0)
	if $OKCancel = 1 then  
		Return	FileOpenDialog( $msgFileDlg, "C:\Program Files", "Programs(*.exe)", 1 + 4 )
	Else
		Exit
	EndIf
	
EndFunc
