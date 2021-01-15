#Region converted Directives from D:\My Documents\AutoITscripts\Directory Copy\Backup.au3.ini
#AutoIt3Wrapper_aut2exe=C:\Program Files\AutoIt3\Aut2Exe\Aut2Exe.exe
#AutoIt3Wrapper_icon=D:\My Documents\icons\Tic2.ico
#AutoIt3Wrapper_outfile=D:\My Documents\AutoITscripts\Directory Copy\Backup.exe
#AutoIt3Wrapper_Res_Comment=Backs up oasis files
#AutoIt3Wrapper_Res_Description=Backup
#AutoIt3Wrapper_Res_Fileversion=1.0.0.29
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field1Name=Author
#AutoIt3Wrapper_Res_Field1Value=Chris Lambert
#EndRegion converted Directives from D:\My Documents\AutoITscripts\Directory Copy\Backup.au3.ini
;

; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.99
; Author:         Chris Lambert
;
; Script Function: Recursive directory copy with progess bars
;
;
; ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <GUIConstants.au3>

;only allow 1 running copy
if _Singleton("Mega5u9erBackup",1) = 0 Then
    MsgBox(262144, "Error", "Backup is already running",5)
    Exit
EndIf



$FolderstoCopy = IniReadSection ("Backup.ini","BackupFolders")
$Priority = IniRead ("Backup.ini","General","Priority",1)
$ShowGui = IniRead ("Backup.ini","General","ShowGui","Yes")
$purge = IniRead ("Backup.ini","General","purge","No")

For $i = 1 to Ubound ($FolderstoCopy) -1
	$split = StringSplit ($FoldersToCopy[$i][1],",")
	If isArray ($Split) and $Split[0] = 2 and FileExists ($Split[1]) then 
		If Not FileExists ($Split[2]) then 
			TrayTip ( "Backup Error", $Split[2] & " does not exist",10)
			$createChk = DirCreate($Split[2])
			If $createChk = 1 then 
				ProgressCopy ($Split[1],$Split[2])
				Else
				TrayTip ( "Backup Error", $Split[2] & " can not be created",10)
			EndIf
			
			Else
			ProgressCopy ($Split[1],$Split[2])
		EndIf
	EndIf
	
Next
	
$FilestoCopy = 	IniReadSection ("Backup.ini","BackupFiles")
For $i = 1 to Ubound ($FilestoCopy) -1
	$split = StringSplit ($FilesToCopy[$i][1],",")
	If isArray ($Split) and $Split[0] = 2 then FileCopy ($Split[1],$Split[2],1)
Next
	


Func ProgressCopy($current, $destination,  $UseMultiColour=0, $attrib = "-R", $overwrite = 1 ,$createDir = 1 ,$Run1 = 0 )
	
	;FirstTimeRun Get original DirSize and set up Gui
	If $Run1 = 0 Then
		$X = RegRead ("HKEY_LOCAL_MACHINE\SOFTWARE\TIC\Backup","X")
		$Y = RegRead ("HKEY_LOCAL_MACHINE\SOFTWARE\TIC\Backup","Y")
		If $createDir > 0 then $createDir = 8
		Global $OverallQty=0, $Overall=0, $source="", $overallpercent=0, $Progress0Text="", $progressbar1=0, $Progress1Text="", $progressbar2=0, $Progress2Text="",  $LocalPercent=0, $mustRestart=0
		DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 0)
		If not FileExists ($Destination) then DirCreate ($Destination) ; This is why it was failing, the dir did not exist
		$source = $current
		If StringRight($current, 1) = '\' Then $current = StringTrimRight($current, 1)
		;If StringRight($destination, 1) = '\' Then $destination = StringTrimRight($destination, 1)
		If StringRight($destination, 1) <> '\' Then $destination = $destination & "\"
		$tosearch = $current
		$Overall = DirGetSize($tosearch, 1)
		$OverallQty = $Overall[1]
		Local $PrCopyGui = GUICreate("Copying Files", 420, 100, $X, $Y, -1, $WS_EX_TOOLWINDOW)
		$Progress0Text = GUICtrlCreateLabel("Please Wait", 10, 5, 400, 20, $SS_LEFTNOWORDWRAP)
		$progressbar1 = GUICtrlCreateProgress(10, 20, 400, 20)
		GUICtrlSetColor(-1, 32250)
		$Progress1Text = GUICtrlCreateLabel("", 10, 44, 400, 20, $SS_LEFTNOWORDWRAP)
		$progressbar2 = GUICtrlCreateProgress(10, 60, 400, 20, $PBS_SMOOTH)
		$Progress2Text = GUICtrlCreateLabel("", 10, 82, 400, 20, $SS_LEFTNOWORDWRAP)
		GUISetFont(10, 600)
		GUICtrlSetColor(-1, 32250); not working with Windows XP Style if not using windows classic style or dllcall above
		
		If $ShowGui = "yes" then 
			GUISetState(@SW_SHOW)
		Else
			TrayTip ( "Backup", $Current & " to " & $Destination, 10 , 1 )
			GuiSetState (@SW_Hide)
		EndIf
		
		GUICtrlSetData($Progress1Text, "Working Directory " & $tosearch)
		$Run1 = 1
	EndIf
	
	$Size = DirGetSize($current, 3)
	
	If Ubound ($Size) >= 2 then 
		$Qty = $Size[1]
	Else
		$Qty = 0
	EndIf
	
	Local $search = FileFindFirstFile($current & "\*.*")
	
	;purge check
	If $purge = "yes" then 
	
			$FlistSource = _FileListToArray($current)
			$FListDestination =_FileListToArray($destination & StringTrimLeft($current, StringLen($source)))
			
			#cs
			$src = FileOpen ("Source.txt",1)
			For $i = 1 to Ubound ($FlistSource) -1
				FileWriteLine($src,$FlistSource[$i])
			Next
			FileClose($src)
			;msgbox(0,"",$Destination & StringTrimLeft($current, StringLen($source)))
			
			$Des = FileOPen("Destination.txt",1)
			For $i = 1 to Ubound ($FListDestination) -1
				FileWriteLine($Des,$FListDestination[$i])
			Next
			FileClose($Des)
			#ce
			
			For $i = 1 to Ubound ($FListDestination) -1
				
				If _ArraySearch($FlistSource,$FListDestination[$i]) = -1 then 
					;Msgbox (0,"Delete",$Destination & StringTrimLeft($current, StringLen($source)) & "\" & $FListDestination[$i])
					If StringinStr (FileGetAttrib ($Destination & StringTrimLeft($current, StringLen($source)) & "\" & $FListDestination[$i]),"D") then 
						DirRemove ($Destination & StringTrimLeft($current, StringLen($source)) & "\" & $FListDestination[$i],1)
						Else
						FileDelete($Destination & StringTrimLeft($current, StringLen($source)) & "\" & $FListDestination[$i])
					EndIf
					
				EndIf
				
			Next
			
			$FlistSource = 0
			$FListDestination = 0
	EndIf
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	While 1
		Dim $file = FileFindNextFile($search)
		If @error Or StringLen($file) < 1 Then ExitLoop
		If Not StringInStr(FileGetAttrib($current & "\" & $file), "D") And ($file <> "." Or $file <> "..") Then
			$Qty -= 1
			$LocalPercent = 100 - (($Qty / $Size[1]) * 100)
			$OverallQty -= 1
			$overallpercent = 100 - (($OverallQty / $Overall[1]) * 100)
			GUICtrlSetData($Progress0Text, "Total Progress " & Int($overallpercent-1) & "% completed")
			GUICtrlSetData($progressbar1, $overallpercent)
			GUICtrlSetData($progressbar2, $LocalPercent)
			GUICtrlSetData($Progress2Text, "Checking File " & $file)
			
			If $useMultiColour then 
				GUICtrlSetColor($Progressbar2, _ChangeColour($LocalPercent))
				GUICtrlSetColor($Progressbar1, _ChangeColour($OverallPercent))
			EndIf
				If FileGetTime ($current & "\" & $file,0,1) <> FileGetTime ($destination & StringTrimLeft($current, StringLen($source)) & "\" & $file,0,1) then ;only copy if modified time doesn't match
				GUICtrlSetData($Progress2Text, "Copying  File " & $file)
				$success = FileCopy($current & "\" & $file, $destination & StringTrimLeft($current, StringLen($source)) & "\" & $file,$overwrite + $createDir)
				FileSetAttrib($destination & StringTrimLeft($current, StringLen($source)) & "\" & $file, $attrib)
					If $success = 0 Then ;if not successful then dump file to a temp loaction and try and copy at a restart, set must restart flag
						FileCopy($current & "\" & $file, @tempdir & StringTrimLeft($current, StringLen($source)) & "\" & $file,9)
						_CopyAfterRestart(@tempdir & StringTrimLeft($current, StringLen($source)) & "\" & $file,$destination & StringTrimLeft($current, StringLen($source)) & $file)
						$mustRestart=1
					EndIf
				EndIf
		EndIf
			
			
		If StringInStr(FileGetAttrib($current & "\" & $file), "D") And ($file <> "." Or $file <> "..") Then
			#cs
			;second purge check
			$FlistSource = _FileListToArray($current)
			$FListDestination =_FileListToArray($destination)
			
			$src = FileOpen ("Source.txt",2)
			For $i = 1 to Ubound ($FlistSource) -1
				FileWriteLine($src,$FlistSource[$i])
			Next
			FileClose($src)
			
			$Des = FileOPen("Destination.txt",2)
			For $i = 1 to Ubound ($FListDestination) -1
				FileWriteLine($Des,$FListDestination[$i])
			Next
			FileClose($Des)
			#ce
			
			DirCreate($destination & StringTrimLeft($current, StringLen($source)) & "\" & $file)
			FileSetAttrib($destination & StringTrimLeft($current, StringLen($source)) & "\" & $file, $attrib)
			
			If StringLen ($current & "\" & $file) < 52 then 
				GUICtrlSetData($Progress1Text,"Working Directory " & $current & "\" & $file)
			Else
				GUICtrlSetData($Progress1Text, "Working Directory " & "~..." & StringRight ($current & "\" & $file,48))
			EndIf
			
			ProgressCopy($current & "\" & $file, $destination, $UseMultiColour, $attrib, $createDir, $overwrite,1)
		EndIf
		
		Select 
			Case $Priority = 3
				Sleep (200)
			Case $Priority = 2
				Sleep (5)
			Case Else
				 
		EndSelect
			
	WEnd
	FileClose($search)
	;when overall percent = 100 set end gui text, delete gui and reset run1 to 0
	;If $overallpercent >= 100 Then
		If isDeclared("PRCopyGui") then
			GUICtrlSetData($Progress0Text, "Total Progress 100% completed")
			GUICtrlSetData($progressbar1, 100)
			GUICtrlSetData($progressbar2, 100)
			GUICtrlSetData($Progress2Text, "Done!")
			$FinalPos = WinGetPos ($PRCopyGui)
			If IsArray ($FinalPos) and Ubound ($FinalPos) >2 then 
				RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\TIC\Backup","X","Reg_SZ",$FinalPos[0])
				REgWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\TIC\Backup","Y","Reg_SZ",$FinalPos[1])
			Endif
			Sleep(1000)
			GUIDelete($PRCopyGui)
			
			$Run1 = 0
		
			If $mustRestart = 1 then Msgbox (0,"Warning","You must restart your computer for all the copied files to take effect",10)
		Endif
	;EndIf
EndFunc   ;==>ProgressCopy

Func _ChangeColour($start)
    
    $Redness = Int(255 - ($start  / 100 * 512)) 
    If $Redness < 0 Then $Redness = 0
        
    $Greeness = Int(($start  / 100 * 512) - 257) 
    If $Greeness < 0 Then $Greeness = 0
        
    $Blueness = Int(255 - ($Redness + $Greeness))
    
    Return ($Redness * 256 * 256) + ($Greeness * 256) + $Blueness

EndFunc

Func _CopyAfterRestart($new_file,$to_replace)
	
	If NOT FileExists($new_file) then 
		SetError(1)
		Return 0
	EndIf
	
	If NOT FileExists($to_replace) then 
		SetError(2)
		Return 0
	EndIf
	
	$existing_entries = Regread ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager","PendingFileRenameOperations") 
	If $existing_entries <> "" then $existing_entries = $existing_entries & @lf
Regwrite ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager","PendingFileRenameOperations","REG_MULTI_SZ",$existing_entries  & "\??\" & $new_file & @lf & "!\??\" & $to_replace)
Endfunc

Func _Singleton($occurenceName, $flag=0)
    Local $ERROR_ALREADY_EXISTS = 183
	$occurenceName=StringReplace($occurenceName,"\", "")	; to avoid error
    Local $handle = DllCall("kernel32.dll", "int", "CreateMutex", "int", 0, "long", 1, "str", $occurenceName)
	Local $lastError = DllCall("kernel32.dll", "int", "GetLastError")
	If $lastError[0] = $ERROR_ALREADY_EXISTS Then
		If $flag = 0 Then
			Exit -1
		Else
			SetError($lastError[0])
			Return 0
		EndIf
	EndIf

	Return  $handle[0]
EndFunc; _Singleton()


Func _FileListToArray($sPath, $sFilter = "*", $iFlag = 0)
	Local $hSearch, $sFile, $asFileList[1]
	If Not FileExists($sPath) Then Return SetError(1, 1, "")
	If (StringInStr($sFilter, "\")) Or (StringInStr($sFilter, "/")) Or (StringInStr($sFilter, ":")) Or (StringInStr($sFilter, ">")) Or (StringInStr($sFilter, "<")) Or (StringInStr($sFilter, "|")) Or (StringStripWS($sFilter, 8) = "") Then Return SetError(2, 2, "")
	If Not ($iFlag = 0 Or $iFlag = 1 Or $iFlag = 2) Then Return SetError(3, 3, "")
	$hSearch = FileFindFirstFile($sPath & "\" & $sFilter)
	If $hSearch = -1 Then Return SetError(4, 4, "")
	While 1
		$sFile = FileFindNextFile($hSearch)
		If @error Then
			SetError(0)
			ExitLoop
		EndIf
		If $iFlag = 1 And StringInStr(FileGetAttrib($sPath & "\" & $sFile), "D") <> 0 Then ContinueLoop
		If $iFlag = 2 And StringInStr(FileGetAttrib($sPath & "\" & $sFile), "D") = 0 Then ContinueLoop
		ReDim $asFileList[UBound($asFileList) + 1]
		$asFileList[0] = $asFileList[0] + 1
		$asFileList[UBound($asFileList) - 1] = $sFile
	WEnd
	FileClose($hSearch)
	Return $asFileList
EndFunc   ;==>_FileListToArray

Func _ArraySearch(Const ByRef $avArray, $vWhat2Find, $iStart = 0, $iEnd = 0, $iCaseSense = 0, $fPartialSearch = False)
	Local $iCurrentPos, $iUBound, $iResult
	If Not IsArray($avArray) Then
		SetError(1)
		Return -1
	EndIf
	$iUBound = UBound($avArray) - 1
	If $iEnd = 0 Then $iEnd = $iUBound
	If $iStart > $iUBound Then
		SetError(2)
		Return -1
	EndIf
	If $iEnd > $iUBound Then
		SetError(3)
		Return -1
	EndIf
	If $iStart > $iEnd Then
		SetError(4)
		Return -1
	EndIf
	If Not ($iCaseSense = 0 Or $iCaseSense = 1) Then
		SetError(5)
		Return -1
	EndIf
	For $iCurrentPos = $iStart To $iEnd
		Select
			Case $iCaseSense = 0
				If $fPartialSearch = False Then
					If $avArray[$iCurrentPos] = $vWhat2Find Then
						SetError(0)
						Return $iCurrentPos
					EndIf
				Else
					$iResult = StringInStr($avArray[$iCurrentPos], $vWhat2Find, $iCaseSense)
					If $iResult > 0 Then
						SetError(0)
						Return $iCurrentPos
					EndIf
				EndIf
			Case $iCaseSense = 1
				If $fPartialSearch = False Then
					If $avArray[$iCurrentPos] == $vWhat2Find Then
						SetError(0)
						Return $iCurrentPos
					EndIf
				Else
					$iResult = StringInStr($avArray[$iCurrentPos], $vWhat2Find, $iCaseSense)
					If $iResult > 0 Then
						SetError(0)
						Return $iCurrentPos
					EndIf
				EndIf
		EndSelect
	Next
	SetError(6)
	Return -1
EndFunc   ;==>_ArraySearch