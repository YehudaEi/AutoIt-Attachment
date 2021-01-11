#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.1.1.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <Array.au3>
#include <file.au3>

AutoItSetOption("ExpandEnvStrings",1)
AutoItSetOption("TrayIconDebug",1)

Global $apps_install
Global $component_install
Global $finalize
Global $hotfix_dir
Global $hotfix_install
Global $reboot
$config_file = @WorkingDir&"\UpdateOS.ini"

	Read_Config()

	If $component_install=1 Then Install_Components()
	If $hotfix_install=1 Then Install_Hotfix()
	If $apps_install=1 Then Install_Apps()
	If $finalize=1 Then Finalize()

	If (($component_install=1 Or $hotfix_install=1 Or $apps_install=1 Or $finalize=1) And $reboot=1) then Shutdown(6)
Exit

Func Read_Config()
	; Check if configfile exists
	If FileExists($config_file) Then
		
		; Read Configuration Options
		$apps_install = IniRead($config_file, "Config", "Apps_Install", 0)
		$component_install = IniRead($config_file, "Config", "Component_Install", 0)
		$finalize = IniRead($config_file, "Config", "Finalize", 0)
		$hotfix_install = IniRead($config_file, "Config", "Hotfix_Install", 0)
		$hotfix_dir = IniRead($config_file, "Config", "Hotfix_Path", 0)
		$reboot = IniRead($config_file, "Config", "Reboot", 0)

		; Check if the directory supplied in the Configfile exist, otherwise disable the option
		If $hotfix_install==1 Then 
			If FileExists($hotfix_dir)=False Then $hotfix_install=0
		EndIf
		
	Else
		Exit
	EndIf
EndFunc

Func Install_Components()
$components_found=0

	; Open the ini and count the number of times "[component_" exists in there
	$file = FileOpen($config_file, 0)
	While 1
		$line = FileReadLine($file)
		If @error = -1 Then ExitLoop
    
		$result = StringInStr(stringlower($line), "[component_")
		if $result=true then $components_found+=1
	Wend
	FileClose($file)

	ProgressOn("Installing Components", "", "")

	; For each component, get the number of lines
	For $current_item = 1 to $components_found
		$var = IniReadSection($config_file, "Component_" & $current_item)
		
		$title = False
		$titlename=""
		$command = False
		$commandname=""
		
		; Read both items, compare and store them
		For $i = 1 To $var[0][0]
		
			Select
			Case $var[$i][0] = StringLower("title")
				$title=True
				$titlename=$var[$i][1]
			Case $var[$i][0] = Stringlower("cmdline")
				$command=True
				$commandname=$var[$i][1]
			EndSelect
			
		Next
		
		; If both title and commandline are located, execute the commandline
		if($command=true and $title=true) then
			ProgressSet(($current_item/$components_found)*100 , Round(($current_item/$components_found)*100)&"%% Completed", "Installing " & $titlename )
			RunWait($commandname)
		EndIf
							
	Next
	ProgressSet(100 , "Done", "All Components Installed")

	Sleep(1000)
	ProgressOff()
	; Installation Complete
EndFunc

Func Install_Hotfix()
	; Get number of files in hotfix directory
	$hotfix_nrfiles	= DirGetSize($hotfix_dir,1)
	If IsArray($hotfix_nrfiles)==0 Then Exit

	; Look for files with the KN*.exe pattern
	$hotfix_search = FileFindFirstFile($hotfix_dir&"KB*.exe")  
	If $hotfix_search = -1 Then Exit

	; Start installing hotfixes
	; NOTE: ONLY TYPE2 FIXES
	ProgressOn("Updating Windows", "", "")
	For $i = 1 to $hotfix_nrfiles[1] Step 1
		$hotfix_filename = FileFindNextFile($hotfix_search)
		If @error Then ExitLoop

		$hotfix_fullfile = $hotfix_dir & $hotfix_filename
		$hotfix_file_noext = StringTrimRight($hotfix_filename, 4)
		ProgressSet(($i/$hotfix_nrfiles[1])*100 , Round(($i/$hotfix_nrfiles[1])*100)&"%% Completed", "Installing Update [" & $i & "/" & $hotfix_nrfiles[1] & "] : " & $hotfix_file_noext )
		RunWait($hotfix_fullfile & " /quiet /passive /norestart")
	Next

	FileClose($hotfix_search)
	ProgressSet(100 , "Done", "All Updates Installed")

	Sleep(1000)
	ProgressOff()
	; Installation Complete
EndFunc

Func Install_Apps()
$apps_found=0

	; Open the ini and count the number of times "[apps_" exists in there
	$file = FileOpen($config_file, 0)
	While 1
		$line = FileReadLine($file)
		If @error = -1 Then ExitLoop
    
		$result1 = StringInStr(stringlower($line), "[apps_")
		if $result1=true then $apps_found+=1
	Wend
	FileClose($file)

	ProgressOn("Installing Applications", "", "")

	; For each application, get the number of lines
	For $current_item = 1 to $apps_found
		$var = IniReadSection($config_file, "Apps_" & $current_item)
		
		$title = False
		$titlename=""
		$command = False
		$commandname=""
		$commandtype=0
		Dim $commandmulti[10]
		Dim $commandnamemulti[10]

		For $y = 0 to 9
			$commandmulti[$y]=False
			$commandnamemulti[$y]=""
		Next
		

		; Check whether it's a single/multi cmdline application ; Read all items, compare and store them
		For $i = 1 To $var[0][0]
		
			If StringInStr(StringLower($var[$i][0]),"cmdline")>0 then $commandtype=1
			If StringInStr(StringLower($var[$i][0]),"cmdline_")>0 then $commandtype=2

			Select
			Case $var[$i][0] = StringLower("title")
				$title=True
				$titlename=$var[$i][1]
			Case $commandtype=1 and StringInStr(StringLower($var[$i][0]),"cmdline")>0
				$command=True
				$commandname=$var[$i][1]
			Case $commandtype=2  and StringInStr(StringLower($var[$i][0]),"cmdline_")>0
				$len = StringLen($var[$i][0])
				$x = StringRight($var[$i][0],$len-8)
				$commandmulti[$x-1]=True
				$commandnamemulti[$x-1]=$var[$i][1]				
			EndSelect
			
		Next

		; If both title and commandline(s) are located, execute the commandline(s)
		if($commandtype=1 And $command=true and $title=true) then
			ProgressSet(($current_item/$apps_found)*100 , Round(($current_item/$apps_found)*100)&"%% Completed", $titlename )
			RunWait($commandname)
		EndIf
		If $commandtype=2 Then
			for $t = 0 to 9
				if ($title=True And $commandmulti[$t]=True) Then
					ProgressSet(($current_item/$apps_found)*100 , Round(($current_item/$apps_found)*100)&"%% Completed", $titlename )
					RunWait($commandnamemulti[$t])
				EndIf
			Next
		EndIf
					

	Next
	ProgressSet(100 , "Done", "All Applications Installed")

	Sleep(1000)
	ProgressOff()
	; Installation Complete
EndFunc

Func Finalize()

	Dim $szDrive, $szDir, $szFName, $szExt

	$section = IniReadSection($config_file, "Finalize")

	if Not @error then
		
		ProgressOn("Final Tasks", "", "")

		For $xx = 1 To $section[0][0]

			if StringLower($section[$xx][0])="action" then
			
				$action=StringSplit($section[$xx][1],",")
				
				Select
				Case StringLower($action[1])="createshortcut" And $action[0]=4 And FileExists($action[4])
					ProgressSet(($xx/$section[0][0])*100 , Round(($xx/$section[0][0])*100)&"%% Completed", "Creating Shortcut" )
					_PathSplit($action[4], $szDrive, $szDir, $szFName, $szExt)
					FileCreateShortcut($action[4],$action[3],$szDrive & StringLeft($szDir,StringLen($szDir)-1),"",$action[2])
					
				Case StringLower($action[1])="dirdel" And $action[0]=2 And FileExists($action[2])
					ProgressSet(($xx/$section[0][0])*100 , Round(($xx/$section[0][0])*100)&"%% Completed", "Removng Directory" )
					DirRemove($action[2],1)
					
				Case StringLower($action[1])="filecopy" and FileExists($action[2]) And $action[0]=3
					ProgressSet(($xx/$section[0][0])*100 , Round(($xx/$section[0][0])*100)&"%% Completed", "Copying File(s)" )
					If Not StringRight($action[3],0)="\" Then $action[3]= $action[3]&"\"
					FileCopy($action[2], $action[3],9)
					
				Case StringLower($action[1])="filedel" And $action[0]=2 And FileExists($action[2])
					ProgressSet(($xx/$section[0][0])*100 , Round(($xx/$section[0][0])*100)&"%% Completed", "Deleting File(s)" )
					FileDelete($action[2])
					
				Case StringLower($action[1])="filemove" And $action[0]=3 And FileExists($action[2])
					ProgressSet(($xx/$section[0][0])*100 , Round(($xx/$section[0][0])*100)&"%% Completed", "Moving File(s)" )
					If Not StringRight($action[3],0)="\" Then $action[3]= $action[3]&"\"
					FileMove($action[2], $action[3],9)
					
				Case StringLower($action[1])="run" And $action[0]=2 And FileExists($action[2])
					ProgressSet(($xx/$section[0][0])*100 , Round(($xx/$section[0][0])*100)&"%% Completed", "Running Program" )
					RunWait($action[2])
					
				Case StringLower($action[1])="regadd" And $action[0]=5
					ProgressSet(($xx/$section[0][0])*100 , Round(($xx/$section[0][0])*100)&"%% Completed", "Writing To Registry" )
					RegWrite($action[2],$action[3],$action[4],$action[5])
		
				Case Stringlower($action[1])="regdel" And $action[0]>=2
					ProgressSet(($xx/$section[0][0])*100 , Round(($xx/$section[0][0])*100)&"%% Completed", "Deleting From Registry" )
					If $action[0]=2 then $action[3]=""
						RegDelete($action[2],$action[3])
						
				Case Else
					ProgressSet(($xx/$section[0][0])*100 , Round(($xx/$section[0][0])*100)&"%% Completed", "Skipping Item" )
					
				EndSelect
				Sleep(250)
			EndIf
		Next

		ProgressSet(100 , "Done", "All Tasks Completed")
		
		Sleep(1000)
		ProgressOff()
	
	Else
		$finalize=0
	EndIf
	
EndFunc
