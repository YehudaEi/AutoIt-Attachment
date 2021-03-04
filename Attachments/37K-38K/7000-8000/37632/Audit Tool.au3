;~ Title:			System Audit Tool
;~ Purpose:			To assist technicians in aquiring the vital system specifications of the computers in a site.
;~ Use:				Either run it as-is and create individual CSV files, append files for a group, or build a customized agent.
;~ Requirements:	WinAPIx.au3 (Yashied) http://www.autoitscript.com/forum/topic/98712-winapiex-udf
;~ 					LocalAccount.au3 (engine) http://www.autoitscript.com/forum/topic/74118-local-account-udf
;~ 					The following list of files MUST also be present in the script directory to compile, as they are required for the custom agent creation:	(You can find them in the AutoIt install folder)
;~					Array.au3
;~					WinAPI.au3
;~					aut2exe.exe
;~					autoitsc.bin
;~					Security.au3
;~					WinAPIEx.au3
;~					SendMessage.au3
;~					WinAPIError.au3
;~					LocalAccount.au3
;~					FileConstants.au3
;~					GUIConstantsEx.au3
;~					StaticConstants.au3
;~					SecurityConstants.au3
;~					StructureConstants.au3
;~ Author:			Ian Maxwell (llewxam @ AutoIt forum)


#include <Array.au3>
#include <WinAPIEx.au3>
#include <LocalAccount.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Global $OSVersion
Global $OfficeVersion
$WhatSaveType = GUICreate("Audit Tool", 250, 180)
GUISetBkColor(0xb2ccff, $WhatSaveType)
$DefaultNoteMessage = "Enter notes about this computer here"
$Notes = GUICtrlCreateInput($DefaultNoteMessage, 10, 10, 230, 20)
GUICtrlSetFont(-1, 10, 500)
GUICtrlSetTip(-1, "Notes could include information such as the workstation location, user, issues reported by the user, condition, performance, etc.")
$Individual = GUICtrlCreateButton("Individual PC", 10, 50, 100, 30)
GUICtrlSetTip(-1, "Creates a CSV named the same as this PC.  If a pre-existing file is found you will be prompted to overwrite.")
$Append = GUICtrlCreateButton("Append Site", 135, 50, 100, 30)
GUICtrlSetTip(-1, "Prompts for the selection of an existing CSV and appends it with this PC's information.  It is not a requirement that the file already exists, it will be created if not.")
$PrepareAgent = GUICtrlCreateButton("Prepare Site Agent", 60, 90, 130, 30)
GUICtrlSetTip(-1, "Creates a customized agent that will ask for the site name and a location to save the CSV, which will speed up the auditing process in locations where there are many PCs.")

$LogoColor = 0xffffff
GUICtrlCreateLabel("Ian Maxwell", 5, 140, 160, 15)
GUICtrlSetColor(-1, $LogoColor)
GUICtrlCreateLabel("MaxImuM AdVaNtAgE SofTWarE", 5, 160, 160, 15)
GUICtrlSetColor(-1, $LogoColor)
GUICtrlSetTip(-1, "1995-2012 and beyond", Default, 0, 1)
$Line = GUICtrlCreateGraphic(5, 155, 110, 2)
GUICtrlSetGraphic($Line, $GUI_GR_COLOR, $LogoColor)
GUICtrlSetGraphic($Line, $GUI_GR_MOVE, 0, 1)
GUICtrlSetGraphic($Line, $GUI_GR_LINE, 106, 1)

GUISetState(@SW_SHOW, $WhatSaveType)

Do
	$MSG = GUIGetMsg()
	If $MSG == $Individual Then
		$Where = FileSaveDialog("Choose the path to save the file", @ScriptDir, "CSV file (*.csv)", 16, @ComputerName & ".csv")
		If StringRight($Where, 4) <> ".csv" Then $Where &= ".csv"
		$Output = FileOpen($Where, 2)
		ExitLoop
	EndIf
	If $MSG == $Append Then
		$Where = FileSaveDialog("Choose the path to save the file", @ScriptDir, "CSV file (*.csv)")
		If StringRight($Where, 4) <> ".csv" Then $Where &= ".csv"
		$Output = FileOpen($Where, 1)
		ExitLoop
	EndIf
	If $MSG == $PrepareAgent Then
		GUIDelete($WhatSaveType)
		$WhatSiteName = GUICreate("Site Details", 450, 250, Default, Default, -1, $WS_EX_ACCEPTFILES)
		GUISetBkColor(0xb2ccff, $WhatSiteName)
		GUICtrlCreateLabel("Specify the save path of the CSV for this site.  By default the save path will be hardcoded to be in the same path as the agent itself, meaning the CSV will travel with the agent, ONLY USEFUL ON FLASH DRIVES.  Please be sure to use a folder with read and write permissions that does not require a username and password if specifying a network path.  Also be sure to use the UNC path and not a mapped drive path as the drive letters can vary among machines.", 10, 10, 430, 88)
		$PathField = GUICtrlCreateInput("Browse or Type the path", 10, 100, 400, 20)
		GUICtrlSetState(-1, $GUI_DROPACCEPTED)
		$BrowsePath = GUICtrlCreateButton("...", 420, 100, 20, 20)
		$SiteName = GUICtrlCreateInput("Site Name", 125, 150, 200, 20)
		$Build = GUICtrlCreateButton("Build Agent", 175, 200, 100, 30)
		GUISetState(@SW_SHOW, $WhatSiteName)
		Local $AccelKeys[1][2] = [["{ENTER}", $Build]]
		GUISetAccelerators($AccelKeys)

		Do
			$MSGG = GUIGetMsg()
			If $MSGG == $GUI_EVENT_CLOSE Then Exit
			If $MSGG == $BrowsePath Then
				$Where = FileSelectFolder("Specify the save path of the CSV for this site.", "", 1, @ScriptDir)
				GUICtrlSetData($PathField, $Where)
			EndIf
			If $MSGG == $Build Then
				$TheSiteName = GUICtrlRead($SiteName)
				$GetPath = GUICtrlRead($PathField)
				If $GetPath == "" Or $GetPath = "Browse or Type the path" Then
					MsgBox(16, "ERROR", "You have not specified a valid path.")
				Else
					If $TheSiteName == "" Or $TheSiteName == "Site Name" Then
						MsgBox(16, "ERROR", "You have not specified a site name.")
					Else
						If StringRight($GetPath, 1) <> "\" Then $GetPath &= "\"
						GUICtrlDelete($Build)
						$Status = GUICtrlCreateLabel("", 10, 200, 430, 30, $SS_CENTER)
						GUICtrlSetFont(-1, 13, 600)
						_BuildAgent($TheSiteName, $GetPath)
						MsgBox(0, "Done", "A customized agent has been created for your site." & @CR & $GetPath & $TheSiteName & " Audit Agent.exe")
						Exit
					EndIf
				EndIf
			EndIf
		Until 1 = 2
	EndIf
	If $MSG == $GUI_EVENT_CLOSE Then Exit
Until 1 = 2

$OSArch = @OSArch
$OSProductKey = _DecodeProductKey("Windows")
FileWriteLine($Output, "Computer Name," & Chr(34) & @ComputerName & Chr(34))
$ReadNotes = GUICtrlRead($Notes)
If $ReadNotes <> $DefaultNoteMessage Then FileWriteLine($Output, "Notes," & Chr(34) & $ReadNotes & Chr(34))
FileWriteLine($Output, "Operating System,Version," & Chr(34) & $OSVersion & Chr(34))
FileWriteLine($Output, ",Architecture," & Chr(34) & $OSArch & Chr(34))
FileWriteLine($Output, ",Service Pack," & Chr(34) & @OSServicePack & Chr(34))
FileWriteLine($Output, ",Product Key," & Chr(34) & $OSProductKey & Chr(34))
FileWriteLine($Output, "")

$FindUsers = _AccountEnum()
If IsArray($FindUsers) Then
	If $FindUsers[0] > 0 Then
		$FilterGroup = "HomeGroupUser$" & @CR & "Guest" & @CR & "Default"
		$FilterGroupBreak = StringSplit($FilterGroup, @CR)
		For $a = 1 To $FilterGroupBreak[0]
			$FindFiltered = -1
			$FindFiltered = _ArraySearch($FindUsers, $FilterGroupBreak[$a])
			If $FindFiltered > -1 Then
				_ArrayDelete($FindUsers, $FindFiltered)
				$FindUsers[0] -= 1
			EndIf
		Next
		$LocalUsers = ""
		For $a = 1 To $FindUsers[0]
			$LocalUsers &= Chr(34) & $FindUsers[$a] & Chr(34) & Chr(44)
		Next
		FileWriteLine($Output, "Local Users," & $LocalUsers)
		FileWriteLine($Output, "")
	EndIf
EndIf

$OfficeInstalled = False
$OfficeXPCOA = _DecodeProductKey("Office XP")
$Office2003COA = _DecodeProductKey("Office 2003")
$Office2007COA = _DecodeProductKey("Office 2007")
$Office2010COAX86 = _DecodeProductKey("Office 2010 x86")
$Office2010COAX64 = _DecodeProductKey("Office 2010 x64")
If $OfficeXPCOA <> "Product Not Found" Then
	FileWriteLine($Output, "Office,Installed Version," & Chr(34) & $OfficeVersion & Chr(34))
	FileWriteLine($Output, ",Product Key," & Chr(34) & $OfficeXPCOA & Chr(34))
	$OfficeInstalled = True
EndIf
If $Office2003COA <> "Product Not Found" Then
	FileWriteLine($Output, "Office,Installed Version," & Chr(34) & $OfficeVersion & Chr(34))
	FileWriteLine($Output, ",Product Key," & Chr(34) & $Office2003COA & Chr(34))
	$OfficeInstalled = True
EndIf
If $Office2007COA <> "Product Not Found" Then
	FileWriteLine($Output, "Office,Installed Version," & Chr(34) & $OfficeVersion & Chr(34))
	FileWriteLine($Output, ",Product Key," & Chr(34) & $Office2007COA & Chr(34))
	$OfficeInstalled = True
EndIf
If $Office2010COAX86 <> "Product Not Found" Then
	FileWriteLine($Output, "Office,Installed Version," & Chr(34) & $OfficeVersion & Chr(34))
	FileWriteLine($Output, ",Product Key," & Chr(34) & $Office2010COAX86 & Chr(34))
	$OfficeInstalled = True
EndIf
If $Office2010COAX64 <> "Product Not Found" Then
	FileWriteLine($Output, "Office,Installed Version," & Chr(34) & $OfficeVersion & Chr(34))
	FileWriteLine($Output, ",Product Key," & Chr(34) & $Office2010COAX64 & Chr(34))
	$OfficeInstalled = True
EndIf
If $OfficeInstalled == True Then FileWriteLine($Output, "")

$CPUName = RegRead("HKLM64\HARDWARE\DESCRIPTION\System\CentralProcessor\0", "ProcessorNameString")
$CPUSpeed = _HZSuffix(RegRead("HKLM64\HARDWARE\DESCRIPTION\System\CentralProcessor\0", "~MHz"))
FileWriteLine($Output, "CPU,Type," & Chr(34) & $CPUName & Chr(34))
FileWriteLine($Output, ",Speed," & Chr(34) & $CPUSpeed & Chr(34))
FileWriteLine($Output, "")

$RAMStats = MemGetStats()
$RAMTotal = _RAMSuffix($RAMStats[1])
$RAMFree = _ByteSuffix($RAMStats[2])
$RAMVirtualTotal = _ByteSuffix($RAMStats[5])
$RAMVirtualFree = _ByteSuffix($RAMStats[6])
FileWriteLine($Output, "RAM,Total," & Chr(34) & $RAMTotal & Chr(34))
FileWriteLine($Output, ",Free," & Chr(34) & $RAMFree & Chr(34))
FileWriteLine($Output, ",Total Swap," & Chr(34) & $RAMVirtualTotal & Chr(34))
FileWriteLine($Output, ",Free Swap," & Chr(34) & $RAMVirtualFree & Chr(34))
FileWriteLine($Output, "")

Local $AllLocalDrives = ""
Local $DriveSpaceTotal = ""
Local $DriveSpaceFree = ""
Local $DrivePercent = ""
Local $DriveLabel = ""
$DrivesPhysical = DriveGetDrive("FIXED")
If Not @error Then
	For $a = 1 To $DrivesPhysical[0]
		$Drive = $DrivesPhysical[$a]
		$AllLocalDrives &= Chr(34) & $Drive & Chr(34) & ","
		$DriveSpaceTotal &= Chr(34) & _ByteSuffix(DriveSpaceTotal($Drive) * 1024) & Chr(34) & ","
		$DriveSpaceFree &= Chr(34) & _ByteSuffix(DriveSpaceFree($Drive) * 1024) & Chr(34) & ","
		$DrivePercent &= Chr(34) & 100 - StringFormat('%.2f', DriveSpaceFree($Drive) / DriveSpaceTotal($Drive) * 100) & "%" & Chr(34) & ","
		$DriveLabel &= Chr(34) & DriveGetLabel($Drive) & Chr(34) & ","
	Next
	FileWriteLine($Output, "Local Drives,Letter," & StringUpper($AllLocalDrives))
	FileWriteLine($Output, ",Label," & $DriveLabel)
	FileWriteLine($Output, ",Total Space," & $DriveSpaceTotal)
	FileWriteLine($Output, ",Free Space," & $DriveSpaceFree)
	FileWriteLine($Output, ",Percent Full," & $DrivePercent)
	FileWriteLine($Output, "")
EndIf

Local $AllNetworkDrives = ""
Local $MapDetails = ""
Local $DriveSpaceTotal = ""
Local $DriveSpaceFree = ""
Local $DrivePercent = ""
Local $DriveLabel = ""
$DrivesMapped = DriveGetDrive("NETWORK")
If Not @error Then
	For $a = 1 To $DrivesMapped[0]
		$Drive = $DrivesMapped[$a]
		$MapDetails &= Chr(34) & DriveMapGet($Drive) & Chr(34) & ","
		$AllNetworkDrives &= Chr(34) & $Drive & Chr(34) & ","
		$DriveSpaceTotal &= Chr(34) & _ByteSuffix(DriveSpaceTotal($Drive) * 1024) & Chr(34) & ","
		$DriveSpaceFree &= Chr(34) & _ByteSuffix(DriveSpaceFree($Drive) * 1024) & Chr(34) & ","
		$DrivePercent &= Chr(34) & 100 - StringFormat('%.2f', DriveSpaceFree($Drive) / DriveSpaceTotal($Drive) * 100) & "%" & Chr(34) & ","
		$DriveLabel &= Chr(34) & DriveGetLabel($Drive) & Chr(34) & ","
	Next
	FileWriteLine($Output, "Network Drives,Letter," & StringUpper($AllNetworkDrives))
	FileWriteLine($Output, ",Label," & $DriveLabel)
	FileWriteLine($Output, ",Network Path," & $MapDetails)
	FileWriteLine($Output, ",Total Space," & $DriveSpaceTotal)
	FileWriteLine($Output, ",Free Space," & $DriveSpaceFree)
	FileWriteLine($Output, ",Percent Full," & $DrivePercent)
	FileWriteLine($Output, "")
EndIf

Local $NetworkAddresses = ""
$FoundIPs = 0
If @IPAddress1 <> "0.0.0.0" And @IPAddress1 <> "127.0.0.1" Then
	$NetworkAddresses &= Chr(34) & @IPAddress1 & Chr(34) & ","
	$FoundIPs += 1
EndIf
If @IPAddress2 <> "0.0.0.0" And @IPAddress2 <> "127.0.0.1" Then
	$NetworkAddresses &= Chr(34) & @IPAddress2 & Chr(34) & ","
	$FoundIPs += 1
EndIf
If @IPAddress3 <> "0.0.0.0" And @IPAddress3 <> "127.0.0.1" Then
	$NetworkAddresses &= Chr(34) & @IPAddress3 & Chr(34) & ","
	$FoundIPs += 1
EndIf
If @IPAddress4 <> "0.0.0.0" And @IPAddress4 <> "127.0.0.1" Then
	$NetworkAddresses &= Chr(34) & @IPAddress4 & Chr(34) & ","
	$FoundIPs += 1
EndIf
If $FoundIPs > 0 Then
	$IPMessage = "IP Address"
	If $FoundIPs > 1 Then $IPMessage &= "es"
	FileWriteLine($Output, $IPMessage & "," & $NetworkAddresses)
	FileWriteLine($Output, "")
EndIf

FileWriteLine($Output, "")
FileWriteLine($Output, "")
FileClose($Output)
GUICtrlDelete($Individual)
GUICtrlDelete($Append)
GUICtrlDelete($PrepareAgent)
GUICtrlDelete($Notes)
GUICtrlCreateLabel("Done, exiting in 1 second.", 10, 20, 230, 50, $SS_CENTER)
Sleep(1000)
Exit


Func _HZSuffix($Bytes)
	Local $x, $BytesSuffix[2] = ["MHz", "GHz"]
	While $Bytes > 1000
		$x += 1
		$Bytes /= 1000
	WEnd
	Return StringFormat('%.2f', $Bytes) & $BytesSuffix[$x]
EndFunc   ;==>_HZSuffix


Func _ByteSuffix($Bytes)
	Local $x, $BytesSuffix[6] = ["KB", "MB", "GB", "TB", "PB"]
	While $Bytes > 1023
		$x += 1
		$Bytes /= 1024
	WEnd
	Return StringFormat('%.2f', $Bytes) & $BytesSuffix[$x]
EndFunc   ;==>_ByteSuffix


Func _RAMSuffix($Bytes)
	Local $x, $BytesSuffix[6] = ["KB", "MB", "GB", "TB", "PB"]
	While $Bytes > 1023
		$x += 1
		$Bytes /= 1024
	WEnd
	$Bytes = Ceiling(StringFormat('%.2f', $Bytes))
	$Bytes = StringFormat('%.2f', $Bytes)
	Return $Bytes & $BytesSuffix[$x]
EndFunc   ;==>_RAMSuffix


Func _DecodeProductKey($Product)
	Local $bKey[15], $sKey[29], $Digits[24], $Value = 0, $hi = 0, $n = 0, $i = 0, $dlen = 29, $slen = 15, $Result, $BinaryDPID, $KeyPos = 0x34 * 2 + 3, $RegKey
	$Digits = StringSplit("BCDFGHJKMPQRTVWXY2346789", "")
	Switch $Product
		Case "Windows"
			$BinaryDPID = RegRead("HKLM64\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "DigitalProductId")
			$OSVersion = RegRead("HKLM64\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "ProductName")
		Case "Office XP"
			$RegKey = 'HKLM\SOFTWARE\Microsoft\Office\10.0\Registration'
			If @OSArch = 'x64' Then $RegKey = 'HKLM64\SOFTWARE\Wow6432Node\Microsoft\Office\10.0\Registration'
			For $i = 1 To 100
				$var = RegEnumKey($RegKey, $i)
				If @error <> 0 Then ExitLoop
				$BinaryDPID = RegRead($RegKey & '\' & $var, 'DigitalProductId')
				$OfficeVersion = RegRead($RegKey & '\' & $var, 'ProductName')
				If Not @error Then ExitLoop
			Next
		Case "Office 2003"
			$RegKey = 'HKLM\SOFTWARE\Microsoft\Office\11.0\Registration'
			If @OSArch = 'x64' Then $RegKey = 'HKLM64\SOFTWARE\Wow6432Node\Microsoft\Office\11.0\Registration'
			For $i = 1 To 100
				$var = RegEnumKey($RegKey, $i)
				If @error <> 0 Then ExitLoop
				$BinaryDPID = RegRead($RegKey & '\' & $var, 'DigitalProductId')
				$OfficeVersion = RegRead($RegKey & '\' & $var, 'ProductName')
				If Not @error Then ExitLoop
			Next
		Case "Office 2007"
			$RegKey = 'HKLM\SOFTWARE\Microsoft\Office\12.0\Registration'
			If @OSArch = 'x64' Then $RegKey = 'HKLM64\SOFTWARE\Wow6432Node\Microsoft\Office\12.0\Registration'
			For $i = 1 To 100
				$var = RegEnumKey($RegKey, $i)
				If @error <> 0 Then ExitLoop
				$BinaryDPID = RegRead($RegKey & '\' & $var, 'DigitalProductId')
				$OfficeVersion = RegRead($RegKey & '\' & $var, 'ProductName')
				If Not @error Then ExitLoop
			Next
		Case "Office 2010 x86"
			$RegKey = 'HKLM\SOFTWARE\Microsoft\Office\14.0\Registration'
			If @OSArch = 'x64' Then $RegKey = 'HKLM64\SOFTWARE\Wow6432Node\Microsoft\Office\14.0\Registration'
			For $i = 1 To 100
				$var = RegEnumKey($RegKey, $i)
				If @error <> 0 Then ExitLoop
				$BinaryDPID = RegRead($RegKey & '\' & $var, 'DigitalProductId')
				$OfficeVersion = RegRead($RegKey & '\' & $var, 'ProductName')
				If Not @error Then ExitLoop
			Next
			$KeyPos = 0x328 * 2 + 3
		Case "Office 2010 x64"
			If @OSArch <> 'x64' Then SetError(1, 0, "Product not found")
			$RegKey = 'HKLM64\SOFTWARE\Microsoft\Office\14.0\Registration'
			For $i = 1 To 100
				$var = RegEnumKey($RegKey, $i)
				If @error <> 0 Then ExitLoop
				$BinaryDPID = RegRead($RegKey & '\' & $var, 'DigitalProductId')
				$OfficeVersion = RegRead($RegKey & '\' & $var, 'ProductName')
				If Not @error Then ExitLoop
			Next
			$KeyPos = 0x328 * 2 + 3
		Case Else
			Return SetError(1, 0, "Product not supported")
	EndSwitch

	If StringLen($BinaryDPID) < 29 Then Return SetError(1, 0, "Product not found")

	$BinaryDPID = StringMid($BinaryDPID, $KeyPos)
	For $i = 1 To 29 Step 2
		$bKey[Int($i / 2)] = Dec(StringMid($BinaryDPID, $i, 2))
	Next

	For $i = $dlen - 1 To 0 Step -1
		If Mod(($i + 1), 6) = 0 Then
			$sKey[$i] = "-"
		Else
			$hi = 0
			For $n = $slen - 1 To 0 Step -1
				$Value = BitOR(BitShift($hi, -8), $bKey[$n])
				$bKey[$n] = Int($Value / 24)
				$hi = Mod($Value, 24)
			Next
			$sKey[$i] = $Digits[$hi + 1]
		EndIf
	Next
	For $i = 0 To 28
		$Result = $Result & $sKey[$i]
	Next
	Return $Result
EndFunc   ;==>_DecodeProductKey


Func _BuildAgent($BuildSite, $BuildPath)
	GUICtrlSetData($Status, "Copying temp files")
	FileInstall("Array.au3", @TempDir & "\Array.au3", 1)
	FileInstall("WinAPI.au3", @TempDir & "\WinAPI.au3", 1)
	FileInstall("aut2exe.exe", @TempDir & "\aut2exe.exe", 1)
	FileInstall("autoitsc.bin", @TempDir & "\autoitsc.bin", 1)
	FileInstall("Security.au3", @TempDir & "\Security.au3", 1)
	FileInstall("WinAPIEx.au3", @TempDir & "\WinAPIEx.au3", 1)
	FileInstall("SendMessage.au3", @TempDir & "\SendMessage.au3", 1)
	FileInstall("WinAPIError.au3", @TempDir & "\WinAPIError.au3", 1)
	FileInstall("LocalAccount.au3", @TempDir & "\LocalAccount.au3", 1)
	FileInstall("FileConstants.au3", @TempDir & "\FileConstants.au3", 1)
	FileInstall("GUIConstantsEx.au3", @TempDir & "\GUIConstantsEx.au3", 1)
	FileInstall("StaticConstants.au3", @TempDir & "\StaticConstants.au3", 1)
	FileInstall("SecurityConstants.au3", @TempDir & "\SecurityConstants.au3", 1)
	FileInstall("StructureConstants.au3", @TempDir & "\StructureConstants.au3", 1)
	GUICtrlSetData($Status, "Building agent")
	$TempName = @TempDir & "\" & $BuildSite & ".au3"
	$CustomAgentAU3 = FileOpen($TempName, 2)
	FileWriteLine($CustomAgentAU3, "#include <Array.au3>")
	FileWriteLine($CustomAgentAU3, "#include <WinAPIEx.au3>")
	FileWriteLine($CustomAgentAU3, "#include <LocalAccount.au3>")
	FileWriteLine($CustomAgentAU3, "#include <GUIConstantsEx.au3>")
	FileWriteLine($CustomAgentAU3, "#include <StaticConstants.au3>")
	FileWriteLine($CustomAgentAU3, "Global $OSVersion")
	FileWriteLine($CustomAgentAU3, "Global $OfficeVersion")
	FileWriteLine($CustomAgentAU3, "$Output = FileOpen(" & Chr(34) & $BuildPath & Chr(34) & " & """ & $BuildSite & ".csv" & """, 1 + 8)")
	FileWriteLine($CustomAgentAU3, "If $Output == -1 Then")
	FileWriteLine($CustomAgentAU3, "	MsgBox(16, " & Chr(34) & "Error" & """,""" & "Unable to open file:" & Chr(34) & " & @CR & " & Chr(34) & $BuildPath & $BuildSite & ".csv""" & ")")
	FileWriteLine($CustomAgentAU3, "	Exit")
	FileWriteLine($CustomAgentAU3, "EndIf")
	FileWriteLine($CustomAgentAU3, "$CustomNotes = InputBox(" & Chr(34) & "Notes" & Chr(34) & Chr(44) & Chr(34) & "Use this space to enter any notes about this computer.  Leave blank or cancel for none." & Chr(34) & ")")
	FileWriteLine($CustomAgentAU3, "$OSArch = @OSArch")
	FileWriteLine($CustomAgentAU3, "$OSProductKey = _DecodeProductKey(" & Chr(34) & "Windows" & Chr(34) & ")")
	FileWriteLine($CustomAgentAU3, "FileWriteLine($Output, " & Chr(34) & "Computer Name," & Chr(34) & " & Chr(34) & @ComputerName & Chr(34))")
	FileWriteLine($CustomAgentAU3, "If $CustomNotes <> """" Then FileWriteLine($Output, " & Chr(34) & "Notes," & Chr(34) & " & Chr(34) & $CustomNotes & Chr(34))")
	FileWriteLine($CustomAgentAU3, "FileWriteLine($Output, " & Chr(34) & "Operating System,Version," & Chr(34) & " & Chr(34) & $OSVersion & Chr(34))")
	FileWriteLine($CustomAgentAU3, "FileWriteLine($Output, " & Chr(34) & ",Service Pack," & Chr(34) & " & Chr(34) & @OSServicePack & Chr(34))")
	FileWriteLine($CustomAgentAU3, "FileWriteLine($Output, " & Chr(34) & ",Architecture," & Chr(34) & " & Chr(34) & $OSArch & Chr(34))")
	FileWriteLine($CustomAgentAU3, "FileWriteLine($Output, " & Chr(34) & ",Product Key," & Chr(34) & " & Chr(34) & $OSProductKey & Chr(34))")
	FileWriteLine($CustomAgentAU3, "FileWriteLine($Output, """")")
	FileWriteLine($CustomAgentAU3, "$FindUsers = _AccountEnum()")
	FileWriteLine($CustomAgentAU3, "If IsArray($FindUsers) Then")
	FileWriteLine($CustomAgentAU3, "	If $FindUsers[0] > 0 Then")
	FileWriteLine($CustomAgentAU3, "		$FilterGroup = " & Chr(34) & "HomeGroupUser$" & Chr(34) & " & @CR & " & Chr(34) & "Guest" & Chr(34) & " & @CR & " & Chr(34) & "Default" & Chr(34) & "")
	FileWriteLine($CustomAgentAU3, "		$FilterGroupBreak = StringSplit($FilterGroup, @CR)")
	FileWriteLine($CustomAgentAU3, "		For $a = 1 To $FilterGroupBreak[0]")
	FileWriteLine($CustomAgentAU3, "			$FindFiltered = -1")
	FileWriteLine($CustomAgentAU3, "			$FindFiltered = _ArraySearch($FindUsers, $FilterGroupBreak[$a])")
	FileWriteLine($CustomAgentAU3, "			If $FindFiltered > -1 Then")
	FileWriteLine($CustomAgentAU3, "				_ArrayDelete($FindUsers, $FindFiltered)")
	FileWriteLine($CustomAgentAU3, "				$FindUsers[0] -= 1")
	FileWriteLine($CustomAgentAU3, "			EndIf")
	FileWriteLine($CustomAgentAU3, "		Next")
	FileWriteLine($CustomAgentAU3, "		$LocalUsers = """"")
	FileWriteLine($CustomAgentAU3, "		For $a = 1 To $FindUsers[0]")
	FileWriteLine($CustomAgentAU3, "			$LocalUsers &= Chr(34) & $FindUsers[$a] & Chr(34) & Chr(44)")
	FileWriteLine($CustomAgentAU3, "		Next")
	FileWriteLine($CustomAgentAU3, "		FileWriteLine($Output, " & Chr(34) & "Local Users" & Chr(44) & Chr(34) & " & $LocalUsers)")
	FileWriteLine($CustomAgentAU3, "		FileWriteLine($Output, """")")
	FileWriteLine($CustomAgentAU3, "	EndIf")
	FileWriteLine($CustomAgentAU3, "EndIf")
	FileWriteLine($CustomAgentAU3, "$OfficeInstalled = False")
	FileWriteLine($CustomAgentAU3, "$OfficeXPCOA = _DecodeProductKey(" & Chr(34) & "Office XP" & Chr(34) & ")")
	FileWriteLine($CustomAgentAU3, "$Office2003COA = _DecodeProductKey(" & Chr(34) & "Office 2003" & Chr(34) & ")")
	FileWriteLine($CustomAgentAU3, "$Office2007COA = _DecodeProductKey(" & Chr(34) & "Office 2007" & Chr(34) & ")")
	FileWriteLine($CustomAgentAU3, "$Office2010COAX86 = _DecodeProductKey(" & Chr(34) & "Office 2010 x86" & Chr(34) & ")")
	FileWriteLine($CustomAgentAU3, "$Office2010COAX64 = _DecodeProductKey(" & Chr(34) & "Office 2010 x64" & Chr(34) & ")")
	FileWriteLine($CustomAgentAU3, "If $OfficeXPCOA <> " & Chr(34) & "Product Not Found" & Chr(34) & " Then")
	FileWriteLine($CustomAgentAU3, "	FileWriteLine($Output, " & Chr(34) & "Office,Installed Version," & Chr(34) & " & Chr(34) & $OfficeVersion & Chr(34))")
	FileWriteLine($CustomAgentAU3, "	FileWriteLine($Output, " & Chr(34) & ",Product Key," & Chr(34) & " & Chr(34) & $OfficeXPCOA & Chr(34))")
	FileWriteLine($CustomAgentAU3, "	$OfficeInstalled = True")
	FileWriteLine($CustomAgentAU3, "EndIf")
	FileWriteLine($CustomAgentAU3, "If $Office2003COA <> " & Chr(34) & "Product Not Found" & Chr(34) & " Then")
	FileWriteLine($CustomAgentAU3, "	FileWriteLine($Output, " & Chr(34) & "Office,Installed Version," & Chr(34) & " & Chr(34) & $OfficeVersion & Chr(34))")
	FileWriteLine($CustomAgentAU3, "	FileWriteLine($Output, " & Chr(34) & ",Product Key," & Chr(34) & " & Chr(34) & $Office2003COA & Chr(34))")
	FileWriteLine($CustomAgentAU3, "	$OfficeInstalled = True")
	FileWriteLine($CustomAgentAU3, "EndIf")
	FileWriteLine($CustomAgentAU3, "If $Office2007COA <> " & Chr(34) & "Product Not Found" & Chr(34) & " Then")
	FileWriteLine($CustomAgentAU3, "	FileWriteLine($Output, " & Chr(34) & "Office,Installed Version," & Chr(34) & " & Chr(34) & $OfficeVersion & Chr(34))")
	FileWriteLine($CustomAgentAU3, "	FileWriteLine($Output, " & Chr(34) & ",Product Key," & Chr(34) & " & Chr(34) & $Office2007COA & Chr(34))")
	FileWriteLine($CustomAgentAU3, "	$OfficeInstalled = True")
	FileWriteLine($CustomAgentAU3, "EndIf")
	FileWriteLine($CustomAgentAU3, "If $Office2010COAX86 <> " & Chr(34) & "Product Not Found" & Chr(34) & " Then")
	FileWriteLine($CustomAgentAU3, "	FileWriteLine($Output, " & Chr(34) & "Office,Installed Version," & Chr(34) & " & Chr(34) & $OfficeVersion & Chr(34))")
	FileWriteLine($CustomAgentAU3, "	FileWriteLine($Output, " & Chr(34) & ",Product Key," & Chr(34) & " & Chr(34) & $Office2010COAX86 & Chr(34))")
	FileWriteLine($CustomAgentAU3, "	$OfficeInstalled = True")
	FileWriteLine($CustomAgentAU3, "EndIf")
	FileWriteLine($CustomAgentAU3, "If $Office2010COAX64 <> " & Chr(34) & "Product Not Found" & Chr(34) & " Then")
	FileWriteLine($CustomAgentAU3, "	FileWriteLine($Output, " & Chr(34) & "Office,Installed Version," & Chr(34) & " & Chr(34) & $OfficeVersion & Chr(34))")
	FileWriteLine($CustomAgentAU3, "	FileWriteLine($Output, " & Chr(34) & ",Product Key," & Chr(34) & " & Chr(34) & $Office2010COAX64 & Chr(34))")
	FileWriteLine($CustomAgentAU3, "	$OfficeInstalled = True")
	FileWriteLine($CustomAgentAU3, "EndIf")
	FileWriteLine($CustomAgentAU3, "If $OfficeInstalled == True Then FileWriteLine($Output, """")")
	FileWriteLine($CustomAgentAU3, "$CPUName = RegRead(" & Chr(34) & "HKLM64\HARDWARE\DESCRIPTION\System\CentralProcessor\0" & Chr(34) & ", " & Chr(34) & "ProcessorNameString" & Chr(34) & ")")
	FileWriteLine($CustomAgentAU3, "$CPUSpeed = _HZSuffix(RegRead(" & Chr(34) & "HKLM64\HARDWARE\DESCRIPTION\System\CentralProcessor\0" & Chr(34) & ", " & Chr(34) & "~MHz" & Chr(34) & "))")
	FileWriteLine($CustomAgentAU3, "FileWriteLine($Output, " & Chr(34) & "CPU,Type," & Chr(34) & " & Chr(34) & $CPUName & Chr(34))")
	FileWriteLine($CustomAgentAU3, "FileWriteLine($Output, " & Chr(34) & ",Speed," & Chr(34) & " & Chr(34) & $CPUSpeed & Chr(34))")
	FileWriteLine($CustomAgentAU3, "FileWriteLine($Output, """")")
	FileWriteLine($CustomAgentAU3, "$RAMStats = MemGetStats()")
	FileWriteLine($CustomAgentAU3, "$RAMTotal = _RAMSuffix($RAMStats[1])")
	FileWriteLine($CustomAgentAU3, "$RAMFree = _ByteSuffix($RAMStats[2])")
	FileWriteLine($CustomAgentAU3, "$RAMVirtualTotal = _ByteSuffix($RAMStats[5])")
	FileWriteLine($CustomAgentAU3, "$RAMVirtualFree = _ByteSuffix($RAMStats[6])")
	FileWriteLine($CustomAgentAU3, "FileWriteLine($Output, " & Chr(34) & "RAM,Total," & Chr(34) & " & Chr(34) & $RAMTotal & Chr(34))")
	FileWriteLine($CustomAgentAU3, "FileWriteLine($Output, " & Chr(34) & ",Free," & Chr(34) & " & Chr(34) & $RAMFree & Chr(34))")
	FileWriteLine($CustomAgentAU3, "FileWriteLine($Output, " & Chr(34) & ",Total Swap," & Chr(34) & " & Chr(34) & $RAMVirtualTotal & Chr(34))")
	FileWriteLine($CustomAgentAU3, "FileWriteLine($Output, " & Chr(34) & ",Free Swap," & Chr(34) & " & Chr(34) & $RAMVirtualFree & Chr(34))")
	FileWriteLine($CustomAgentAU3, "FileWriteLine($Output, """")")
	FileWriteLine($CustomAgentAU3, "Local $AllLocalDrives = """"")
	FileWriteLine($CustomAgentAU3, "Local $DriveSpaceTotal = """"")
	FileWriteLine($CustomAgentAU3, "Local $DriveSpaceFree = """"")
	FileWriteLine($CustomAgentAU3, "Local $DrivePercent = """"")
	FileWriteLine($CustomAgentAU3, "Local $DriveLabel = """"")
	FileWriteLine($CustomAgentAU3, "$DrivesPhysical = DriveGetDrive(" & Chr(34) & "FIXED" & Chr(34) & ")")
	FileWriteLine($CustomAgentAU3, "If Not @error Then")
	FileWriteLine($CustomAgentAU3, "	For $a = 1 To $DrivesPhysical[0]")
	FileWriteLine($CustomAgentAU3, "		$Drive = $DrivesPhysical[$a]")
	FileWriteLine($CustomAgentAU3, "		$AllLocalDrives &= Chr(34) & StringUpper($Drive) & Chr(34) & " & Chr(34) & Chr(44) & Chr(34))
	FileWriteLine($CustomAgentAU3, "		$DriveSpaceTotal &= Chr(34) & _ByteSuffix(DriveSpaceTotal($Drive) * 1024) & Chr(34)& " & Chr(34) & Chr(44) & Chr(34))
	FileWriteLine($CustomAgentAU3, "		$DriveSpaceFree &= Chr(34) & _ByteSuffix(DriveSpaceFree($Drive) * 1024) & Chr(34) & " & Chr(34) & Chr(44) & Chr(34))
	FileWriteLine($CustomAgentAU3, "		$DrivePercent &= Chr(34) & 100 - StringFormat('%.2f', DriveSpaceFree($Drive) / DriveSpaceTotal($Drive) * 100) & chr(37) & Chr(34) & " & Chr(34) & Chr(44) & Chr(34))
	FileWriteLine($CustomAgentAU3, "		$DriveLabel &= Chr(34) & DriveGetLabel($Drive) & Chr(34) & " & Chr(34) & Chr(44) & Chr(34))
	FileWriteLine($CustomAgentAU3, "	Next")
	FileWriteLine($CustomAgentAU3, "	FileWriteLine($Output, " & Chr(34) & "Local Drives,Letter," & Chr(34) & " & $AllLocalDrives)")
	FileWriteLine($CustomAgentAU3, "	FileWriteLine($Output, " & Chr(34) & ",Label," & Chr(34) & " & $DriveLabel)")
	FileWriteLine($CustomAgentAU3, "	FileWriteLine($Output, " & Chr(34) & ",Total Space," & Chr(34) & " & $DriveSpaceTotal)")
	FileWriteLine($CustomAgentAU3, "	FileWriteLine($Output, " & Chr(34) & ",Free Space," & Chr(34) & " & $DriveSpaceFree)")
	FileWriteLine($CustomAgentAU3, "	FileWriteLine($Output, " & Chr(34) & ",Percent Full," & Chr(34) & " & $DrivePercent)")
	FileWriteLine($CustomAgentAU3, "	FileWriteLine($Output, """")")
	FileWriteLine($CustomAgentAU3, "EndIf")
	FileWriteLine($CustomAgentAU3, "Local $AllNetworkDrives = """"")
	FileWriteLine($CustomAgentAU3, "Local $MapDetails = """"")
	FileWriteLine($CustomAgentAU3, "Local $DriveSpaceTotal = """"")
	FileWriteLine($CustomAgentAU3, "Local $DriveSpaceFree = """"")
	FileWriteLine($CustomAgentAU3, "Local $DrivePercent = """"")
	FileWriteLine($CustomAgentAU3, "Local $DriveLabel = """"")
	FileWriteLine($CustomAgentAU3, "$DrivesMapped = DriveGetDrive(" & Chr(34) & "NETWORK" & Chr(34) & ")")
	FileWriteLine($CustomAgentAU3, "If Not @error Then")
	FileWriteLine($CustomAgentAU3, "	For $a = 1 To $DrivesMapped[0]")
	FileWriteLine($CustomAgentAU3, "		$Drive = $DrivesMapped[$a]")
	FileWriteLine($CustomAgentAU3, "		$MapDetails &= Chr(34) & DriveMapGet($Drive) & Chr(34) & " & Chr(34) & Chr(44) & Chr(34))
	FileWriteLine($CustomAgentAU3, "		$AllNetworkDrives &= Chr(34) & StringUpper($Drive) & Chr(34) & " & Chr(34) & Chr(44) & Chr(34))
	FileWriteLine($CustomAgentAU3, "		$DriveSpaceTotal &= Chr(34) & _ByteSuffix(DriveSpaceTotal($Drive) * 1024) & Chr(34) & " & Chr(34) & Chr(44) & Chr(34))
	FileWriteLine($CustomAgentAU3, "		$DriveSpaceFree &= Chr(34) & _ByteSuffix(DriveSpaceFree($Drive) * 1024) & Chr(34) & " & Chr(34) & Chr(44) & Chr(34))
	FileWriteLine($CustomAgentAU3, "		$DrivePercent &= Chr(34) & 100 - StringFormat('%.2f', DriveSpaceFree($Drive) / DriveSpaceTotal($Drive) * 100) & chr(37) & Chr(34) & " & Chr(34) & Chr(44) & Chr(34))
	FileWriteLine($CustomAgentAU3, "		$DriveLabel &= Chr(34) & DriveGetLabel($Drive) & Chr(34) & " & Chr(34) & Chr(44) & Chr(34))
	FileWriteLine($CustomAgentAU3, "	Next")
	FileWriteLine($CustomAgentAU3, "	FileWriteLine($Output, " & Chr(34) & "Network Drives,Letter," & Chr(34) & " & $AllNetworkDrives)")
	FileWriteLine($CustomAgentAU3, "	FileWriteLine($Output, " & Chr(34) & ",Label," & Chr(34) & " & $DriveLabel)")
	FileWriteLine($CustomAgentAU3, "	FileWriteLine($Output, " & Chr(34) & ",Network Path," & Chr(34) & " & $MapDetails)")
	FileWriteLine($CustomAgentAU3, "	FileWriteLine($Output, " & Chr(34) & ",Total Space," & Chr(34) & " & $DriveSpaceTotal)")
	FileWriteLine($CustomAgentAU3, "	FileWriteLine($Output, " & Chr(34) & ",Free Space," & Chr(34) & " & $DriveSpaceFree)")
	FileWriteLine($CustomAgentAU3, "	FileWriteLine($Output, " & Chr(34) & ",Percent Full," & Chr(34) & " & $DrivePercent)")
	FileWriteLine($CustomAgentAU3, "	FileWriteLine($Output, """")")
	FileWriteLine($CustomAgentAU3, "EndIf")
	FileWriteLine($CustomAgentAU3, "Local $NetworkAddresses = """"")
	FileWriteLine($CustomAgentAU3, "$FoundIPs = 0")
	FileWriteLine($CustomAgentAU3, "If @IPAddress1 <> " & Chr(34) & "0.0.0.0" & Chr(34) & " And @IPAddress1 <> " & Chr(34) & "127.0.0.1" & Chr(34) & " Then")
	FileWriteLine($CustomAgentAU3, "	$NetworkAddresses &= Chr(34) & @IPAddress1 & Chr(34) & " & Chr(34) & Chr(44) & Chr(34))
	FileWriteLine($CustomAgentAU3, "	$FoundIPs += 1")
	FileWriteLine($CustomAgentAU3, "EndIf")
	FileWriteLine($CustomAgentAU3, "If @IPAddress2 <> " & Chr(34) & "0.0.0.0" & Chr(34) & " And @IPAddress2 <> " & Chr(34) & "127.0.0.1" & Chr(34) & " Then")
	FileWriteLine($CustomAgentAU3, "	$NetworkAddresses &= Chr(34) & @IPAddress2 & Chr(34) & " & Chr(34) & Chr(44) & Chr(34))
	FileWriteLine($CustomAgentAU3, "	$FoundIPs += 1")
	FileWriteLine($CustomAgentAU3, "EndIf")
	FileWriteLine($CustomAgentAU3, "If @IPAddress3 <> " & Chr(34) & "0.0.0.0" & Chr(34) & " And @IPAddress3 <> " & Chr(34) & "127.0.0.1" & Chr(34) & " Then")
	FileWriteLine($CustomAgentAU3, "	$NetworkAddresses &= Chr(34) & @IPAddress3 & Chr(34) & " & Chr(34) & Chr(44) & Chr(34))
	FileWriteLine($CustomAgentAU3, "	$FoundIPs += 1")
	FileWriteLine($CustomAgentAU3, "EndIf")
	FileWriteLine($CustomAgentAU3, "If @IPAddress4 <> " & Chr(34) & "0.0.0.0" & Chr(34) & " And @IPAddress4 <> " & Chr(34) & "127.0.0.1" & Chr(34) & " Then")
	FileWriteLine($CustomAgentAU3, "	$NetworkAddresses &= Chr(34) & @IPAddress4 & Chr(34) & " & Chr(34) & Chr(44) & Chr(34))
	FileWriteLine($CustomAgentAU3, "	$FoundIPs += 1")
	FileWriteLine($CustomAgentAU3, "EndIf")
	FileWriteLine($CustomAgentAU3, "If $FoundIPs > 0 Then")
	FileWriteLine($CustomAgentAU3, "	$IPMessage = " & Chr(34) & "IP Address" & Chr(34))
	FileWriteLine($CustomAgentAU3, "	If $FoundIPs > 1 Then $IPMessage &= " & Chr(34) & "es" & Chr(34))
	FileWriteLine($CustomAgentAU3, "	FileWriteLine($Output, $IPMessage & " & Chr(34) & Chr(44) & Chr(34) & " & $NetworkAddresses)")
	FileWriteLine($CustomAgentAU3, "	FileWriteLine($Output, """")")
	FileWriteLine($CustomAgentAU3, "EndIf")
	FileWriteLine($CustomAgentAU3, "FileWriteLine($Output, """")")
	FileWriteLine($CustomAgentAU3, "FileWriteLine($Output, """")")
	FileWriteLine($CustomAgentAU3, "FileClose($Output)")
	FileWriteLine($CustomAgentAU3, "MsgBox(64, " & Chr(34) & "DONE" & Chr(34) & ", " & Chr(34) & "Finished, exiting in 1 second." & Chr(34) & ", 1)")
	FileWriteLine($CustomAgentAU3, "Exit")
	FileWriteLine($CustomAgentAU3, "Func _HZSuffix($Bytes)")
	FileWriteLine($CustomAgentAU3, "	Local $x, $BytesSuffix[2] = [" & Chr(34) & "MHz" & Chr(34) & ", " & Chr(34) & "GHz" & Chr(34) & "]")
	FileWriteLine($CustomAgentAU3, "	While $Bytes > 1000")
	FileWriteLine($CustomAgentAU3, "		$x += 1")
	FileWriteLine($CustomAgentAU3, "		$Bytes /= 1000")
	FileWriteLine($CustomAgentAU3, "	WEnd")
	FileWriteLine($CustomAgentAU3, "	Return StringFormat('%.2f', $Bytes) & $BytesSuffix[$x]")
	FileWriteLine($CustomAgentAU3, "EndFunc   ;==>_HZSuffix")
	FileWriteLine($CustomAgentAU3, "Func _ByteSuffix($Bytes)")
	FileWriteLine($CustomAgentAU3, "	Local $x, $BytesSuffix[6] = [" & Chr(34) & "KB" & Chr(34) & ", " & Chr(34) & "MB" & Chr(34) & ", " & Chr(34) & "GB" & Chr(34) & ", " & Chr(34) & "TB" & Chr(34) & ", " & Chr(34) & "PB" & Chr(34) & "]")
	FileWriteLine($CustomAgentAU3, "	While $Bytes > 1023")
	FileWriteLine($CustomAgentAU3, "		$x += 1")
	FileWriteLine($CustomAgentAU3, "		$Bytes /= 1024")
	FileWriteLine($CustomAgentAU3, "	WEnd")
	FileWriteLine($CustomAgentAU3, "	Return StringFormat('%.2f', $Bytes) & $BytesSuffix[$x]")
	FileWriteLine($CustomAgentAU3, "EndFunc   ;==>_ByteSuffix")
	FileWriteLine($CustomAgentAU3, "Func _RAMSuffix($Bytes)")
	FileWriteLine($CustomAgentAU3, "	Local $x, $BytesSuffix[6] = [" & Chr(34) & "KB" & Chr(34) & ", " & Chr(34) & "MB" & Chr(34) & ", " & Chr(34) & "GB" & Chr(34) & ", " & Chr(34) & "TB" & Chr(34) & ", " & Chr(34) & "PB" & Chr(34) & "]")
	FileWriteLine($CustomAgentAU3, "	While $Bytes > 1023")
	FileWriteLine($CustomAgentAU3, "		$x += 1")
	FileWriteLine($CustomAgentAU3, "		$Bytes /= 1024")
	FileWriteLine($CustomAgentAU3, "	WEnd")
	FileWriteLine($CustomAgentAU3, "	$Bytes = Ceiling(StringFormat('%.2f', $Bytes))")
	FileWriteLine($CustomAgentAU3, "	$Bytes = StringFormat('%.2f', $Bytes)")
	FileWriteLine($CustomAgentAU3, "	Return $Bytes & $BytesSuffix[$x]")
	FileWriteLine($CustomAgentAU3, "EndFunc   ;==>_RAMSuffix")
	FileWriteLine($CustomAgentAU3, "Func _DecodeProductKey($Product)")
	FileWriteLine($CustomAgentAU3, "	Local $bKey[15], $sKey[29], $Digits[24], $Value = 0, $hi = 0, $n = 0, $i = 0, $dlen = 29, $slen = 15, $Result, $BinaryDPID, $KeyPos = 0x34 * 2 + 3, $RegKey")
	FileWriteLine($CustomAgentAU3, "	$Digits = StringSplit(" & Chr(34) & "BCDFGHJKMPQRTVWXY2346789""" & Chr(44) & """""" & ")")
	FileWriteLine($CustomAgentAU3, "	Switch $Product")
	FileWriteLine($CustomAgentAU3, "		Case " & Chr(34) & "Windows" & Chr(34))
	FileWriteLine($CustomAgentAU3, "			$BinaryDPID = RegRead(" & Chr(34) & "HKLM64\SOFTWARE\Microsoft\Windows NT\CurrentVersion" & Chr(34) & ", " & Chr(34) & "DigitalProductId" & Chr(34) & ")")
	FileWriteLine($CustomAgentAU3, "			$OSVersion = RegRead(" & Chr(34) & "HKLM64\SOFTWARE\Microsoft\Windows NT\CurrentVersion" & Chr(34) & ", " & Chr(34) & "ProductName" & Chr(34) & ")")
	FileWriteLine($CustomAgentAU3, "		Case " & Chr(34) & "Office XP" & Chr(34))
	FileWriteLine($CustomAgentAU3, "			$RegKey = 'HKLM\SOFTWARE\Microsoft\Office\10.0\Registration'")
	FileWriteLine($CustomAgentAU3, "			If @OSArch = 'x64' Then $RegKey = 'HKLM64\SOFTWARE\Wow6432Node\Microsoft\Office\10.0\Registration'")
	FileWriteLine($CustomAgentAU3, "			For $i = 1 To 100")
	FileWriteLine($CustomAgentAU3, "				$var = RegEnumKey($RegKey, $i)")
	FileWriteLine($CustomAgentAU3, "				If @error <> 0 Then ExitLoop")
	FileWriteLine($CustomAgentAU3, "				$BinaryDPID = RegRead($RegKey & '\' & $var, 'DigitalProductId')")
	FileWriteLine($CustomAgentAU3, "				$OfficeVersion = RegRead($RegKey & '\' & $var, 'ProductName')")
	FileWriteLine($CustomAgentAU3, "				If Not @error Then ExitLoop")
	FileWriteLine($CustomAgentAU3, "			Next")
	FileWriteLine($CustomAgentAU3, "		Case " & Chr(34) & "Office 2003" & Chr(34))
	FileWriteLine($CustomAgentAU3, "			$RegKey = 'HKLM\SOFTWARE\Microsoft\Office\11.0\Registration'")
	FileWriteLine($CustomAgentAU3, "			If @OSArch = 'x64' Then $RegKey = 'HKLM64\SOFTWARE\Wow6432Node\Microsoft\Office\11.0\Registration'")
	FileWriteLine($CustomAgentAU3, "			For $i = 1 To 100")
	FileWriteLine($CustomAgentAU3, "				$var = RegEnumKey($RegKey, $i)")
	FileWriteLine($CustomAgentAU3, "				If @error <> 0 Then ExitLoop")
	FileWriteLine($CustomAgentAU3, "				$BinaryDPID = RegRead($RegKey & '\' & $var, 'DigitalProductId')")
	FileWriteLine($CustomAgentAU3, "				$OfficeVersion = RegRead($RegKey & '\' & $var, 'ProductName')")
	FileWriteLine($CustomAgentAU3, "				If Not @error Then ExitLoop")
	FileWriteLine($CustomAgentAU3, "			Next")
	FileWriteLine($CustomAgentAU3, "		Case " & Chr(34) & "Office 2007" & Chr(34))
	FileWriteLine($CustomAgentAU3, "			$RegKey = 'HKLM\SOFTWARE\Microsoft\Office\12.0\Registration'")
	FileWriteLine($CustomAgentAU3, "			If @OSArch = 'x64' Then $RegKey = 'HKLM64\SOFTWARE\Wow6432Node\Microsoft\Office\12.0\Registration'")
	FileWriteLine($CustomAgentAU3, "			For $i = 1 To 100")
	FileWriteLine($CustomAgentAU3, "				$var = RegEnumKey($RegKey, $i)")
	FileWriteLine($CustomAgentAU3, "				If @error <> 0 Then ExitLoop")
	FileWriteLine($CustomAgentAU3, "				$BinaryDPID = RegRead($RegKey & '\' & $var, 'DigitalProductId')")
	FileWriteLine($CustomAgentAU3, "				$OfficeVersion = RegRead($RegKey & '\' & $var, 'ProductName')")
	FileWriteLine($CustomAgentAU3, "				If Not @error Then ExitLoop")
	FileWriteLine($CustomAgentAU3, "			Next")
	FileWriteLine($CustomAgentAU3, "		Case " & Chr(34) & "Office 2010 x86" & Chr(34))
	FileWriteLine($CustomAgentAU3, "			$RegKey = 'HKLM\SOFTWARE\Microsoft\Office\14.0\Registration'")
	FileWriteLine($CustomAgentAU3, "			If @OSArch = 'x64' Then $RegKey = 'HKLM64\SOFTWARE\Wow6432Node\Microsoft\Office\14.0\Registration'")
	FileWriteLine($CustomAgentAU3, "			For $i = 1 To 100")
	FileWriteLine($CustomAgentAU3, "				$var = RegEnumKey($RegKey, $i)")
	FileWriteLine($CustomAgentAU3, "				If @error <> 0 Then ExitLoop")
	FileWriteLine($CustomAgentAU3, "				$BinaryDPID = RegRead($RegKey & '\' & $var, 'DigitalProductId')")
	FileWriteLine($CustomAgentAU3, "				$OfficeVersion = RegRead($RegKey & '\' & $var, 'ProductName')")
	FileWriteLine($CustomAgentAU3, "				If Not @error Then ExitLoop")
	FileWriteLine($CustomAgentAU3, "			Next")
	FileWriteLine($CustomAgentAU3, "			$KeyPos = 0x328 * 2 + 3")
	FileWriteLine($CustomAgentAU3, "		Case " & Chr(34) & "Office 2010 x64" & Chr(34))
	FileWriteLine($CustomAgentAU3, "			If @OSArch <> 'x64' Then SetError(1, 0, " & Chr(34) & "Product not found" & Chr(34) & ")")
	FileWriteLine($CustomAgentAU3, "			$RegKey = 'HKLM64\SOFTWARE\Microsoft\Office\14.0\Registration'")
	FileWriteLine($CustomAgentAU3, "			For $i = 1 To 100")
	FileWriteLine($CustomAgentAU3, "				$var = RegEnumKey($RegKey, $i)")
	FileWriteLine($CustomAgentAU3, "				If @error <> 0 Then ExitLoop")
	FileWriteLine($CustomAgentAU3, "				$BinaryDPID = RegRead($RegKey & '\' & $var, 'DigitalProductId')")
	FileWriteLine($CustomAgentAU3, "				$OfficeVersion = RegRead($RegKey & '\' & $var, 'ProductName')")
	FileWriteLine($CustomAgentAU3, "				If Not @error Then ExitLoop")
	FileWriteLine($CustomAgentAU3, "			Next")
	FileWriteLine($CustomAgentAU3, "			$KeyPos = 0x328 * 2 + 3")
	FileWriteLine($CustomAgentAU3, "		Case Else")
	FileWriteLine($CustomAgentAU3, "			Return SetError(1, 0, " & Chr(34) & "Product not supported" & Chr(34) & ")")
	FileWriteLine($CustomAgentAU3, "	EndSwitch")
	FileWriteLine($CustomAgentAU3, "	If StringLen($BinaryDPID) < 29 Then Return SetError(1, 0, " & Chr(34) & "Product not found" & Chr(34) & ")")
	FileWriteLine($CustomAgentAU3, "	$BinaryDPID = StringMid($BinaryDPID, $KeyPos)")
	FileWriteLine($CustomAgentAU3, "	For $i = 1 To 29 Step 2")
	FileWriteLine($CustomAgentAU3, "		$bKey[Int($i / 2)] = Dec(StringMid($BinaryDPID, $i, 2))")
	FileWriteLine($CustomAgentAU3, "	Next")
	FileWriteLine($CustomAgentAU3, "	For $i = $dlen - 1 To 0 Step -1")
	FileWriteLine($CustomAgentAU3, "		If Mod(($i + 1), 6) = 0 Then")
	FileWriteLine($CustomAgentAU3, "			$sKey[$i] = """ & Chr(45) & """")
	FileWriteLine($CustomAgentAU3, "		Else")
	FileWriteLine($CustomAgentAU3, "			$hi = 0")
	FileWriteLine($CustomAgentAU3, "			For $n = $slen - 1 To 0 Step -1")
	FileWriteLine($CustomAgentAU3, "				$Value = BitOR(BitShift($hi, -8), $bKey[$n])")
	FileWriteLine($CustomAgentAU3, "				$bKey[$n] = Int($Value / 24)")
	FileWriteLine($CustomAgentAU3, "				$hi = Mod($Value, 24)")
	FileWriteLine($CustomAgentAU3, "			Next")
	FileWriteLine($CustomAgentAU3, "			$sKey[$i] = $Digits[$hi + 1]")
	FileWriteLine($CustomAgentAU3, "		EndIf")
	FileWriteLine($CustomAgentAU3, "	Next")
	FileWriteLine($CustomAgentAU3, "	For $i = 0 To 28")
	FileWriteLine($CustomAgentAU3, "		$Result = $Result & $sKey[$i]")
	FileWriteLine($CustomAgentAU3, "	Next")
	FileWriteLine($CustomAgentAU3, "	Return $Result")
	FileWriteLine($CustomAgentAU3, "EndFunc   ;==>_DecodeProductKey")

	GUICtrlSetData($Status, "Compiling agent")
	RunWait(Chr(34) & @TempDir & "\aut2exe.exe" & Chr(34) & " /In " & Chr(34) & $TempName & Chr(34) & " /out " & Chr(34) & $BuildPath & $BuildSite & " Audit Agent.exe" & Chr(34) & " /nopack")
	GUICtrlDelete($Status)
EndFunc   ;==>_BuildAgent
