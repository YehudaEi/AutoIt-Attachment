#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <array.au3>

Const $wbemFlagReturnImmediately = 0x10
Const $wbemFlagForwardOnly = 0x20

Dim $strComputer = "." 
Dim $objWMIService, $oMyError, $oDict, $oDictType
Dim $colItems, $strReserved, $strVendorSpecific, $strVendorSpecific4, $Output
$oMyError = ObjEvent("AutoIt.Error","MyErrFunc")


$drive = "C:"
$smartData = _GetSmartData($drive)

If $smartData <> -1 then 
_arrayDisplay($SmartData,"S.M.A.R.T. Data for Drive " & $drive)
Else
	Msgbox(0,"",$drive & " may not be S.M.A.R.T. Capable")
EndIf


Func _GetSmartData($vDrive  = "C:")
	
	If DriveStatus ( $vDrive ) = "INVALID" then 
		SetError(1)
		Return -1
	EndIf
	
	If StringLeft($vDrive,1) <> '"' then $vDrive = '"' & $vDrive
	If StringRight($vDrive,1) <> '"' then $vDrive &= '"'
	
	Local $iCnt, $iCheck, $vPartition,$vDeviceID,$vPNPID
	
	$vPartition = _LogicalToPartition ($vDrive)
	If $vPartition = -1 then Return -1
	
	$vDeviceID = _PartitionToPhysicalDriveID($vPartition)
	If $vDeviceID = -1 then Return -1
	
	$vPNPID = _PNPIDFromPhysicalDriveID($vDeviceID)
	If $vPNPID = -1 then Return -1
	
		$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\WMI")
		$oDict = ObjCreate("Scripting.Dictionary")
		$oDictType = ObjCreate("Scripting.Dictionary")

		$colItems1 = $objWMIService.ExecQuery("SELECT * FROM MSStorageDriver_ATAPISmartData", "WQL", _
											  $wbemFlagReturnImmediately + $wbemFlagForwardOnly)

		$colItems2 = $objWMIService.ExecQuery("SELECT * FROM MSStorageDriver_FailurePredictThresholds", "WQL", _
											  $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
											  
		$colItems3 = $objWMIService.ExecQuery("SELECT * FROM MSStorageDriver_FailurePredictStatus", "WQL", _
											  $wbemFlagReturnImmediately + $wbemFlagForwardOnly)

		_CreateDict() ; Create Dictionary
		;_CreateTypeDict() ; Create Type Dictionary (Not needed anymore)
		
		ConsoleWrite ($strComputer&@CR)							  
	
	$iCnt = 1
	   For $objItem In $colItems1
		   If StringLeft($objItem.InstanceName,StringLen($vPNPID)) = String($vPNPID) then 
			  ConsoleWrite ("Active: " & $objItem.Active&@CR)
			  ConsoleWrite ("Checksum: " & $objItem.Checksum&@CR)
			  ConsoleWrite ("ErrorLogCapability: " & $objItem.ErrorLogCapability&@CR)
			  ConsoleWrite ("ExtendedPollTimeInMinutes: " & $objItem.ExtendedPollTimeInMinutes&@CR)
			  ConsoleWrite ("InstanceName: " & $objItem.InstanceName&@CR)
			  ConsoleWrite ("Length: " & $objItem.Length&@CR)
			  ConsoleWrite ("OfflineCollectCapability: " & $objItem.OfflineCollectCapability&@CR)
			  ConsoleWrite ("OfflineCollectionStatus: " & $objItem.OfflineCollectionStatus&@CR)
				$strReserved = $objItem.Reserved
			  ConsoleWrite ("Reserved: " & _ArrayToString($strReserved,",")&@CR)
			  ConsoleWrite ("SelfTestStatus: " & $objItem.SelfTestStatus&@CR)
			  ConsoleWrite ("ShortPollTimeInMinutes: " & $objItem.ShortPollTimeInMinutes&@CR)
			  ConsoleWrite ("SmartCapability: " & $objItem.SmartCapability&@CR)
			  ConsoleWrite ("TotalTime: " & $objItem.TotalTime&@CR)
				$strVendorSpecific = $objItem.VendorSpecific
				;_arrayDisplay($strVendorSpecific,"$strVendorSpecific")
			ConsoleWrite ("VendorSpecific: " & _ArrayToString($strVendorSpecific,",")&@CR)
			ConsoleWrite ("VendorSpecific2: " & $objItem.VendorSpecific2&@CR)
			ConsoleWrite ("VendorSpecific3: " & $objItem.VendorSpecific3&@CR)
				$strVendorSpecific4 = $objItem.VendorSpecific4
				;_arrayDisplay($strVendorSpecific4,"$strVendorSpecific4")
			ConsoleWrite ("VendorSpecific4: " & _ArrayToString($strVendorSpecific4,",")&@CR)
		Else
			
		$iCnt +=1
	EndIf
	
Next

	
	$iCheck = 1
		For $objItem In $colItems2
		If $iCheck = $iCnt then 
		  $strVendorSpecific2 = $objItem.VendorSpecific
		  ;_arrayDisplay($strVendorSpecific2,"$strVendorSpecific2")
		  ConsoleWrite ("FailurePredictThresholds: " & _ArrayToString($strVendorSpecific2,",")&@CR)
			  Else
				  $iCheck +=1
			  EndIf
		Next
		  
	$iCheck = 1
		For $objItem In $colItems3
			If $iCheck = $iCnt then 
			  $strVendorSpecific3 = $objItem.PredictFailure
			  ConsoleWrite ("PredictFailure: " & $strVendorSpecific3&@CR)
			  $strVendorSpecific3 = $objItem.Reason
			  ConsoleWrite ("PredictReason: " & $strVendorSpecific4&@CR)
				  Else
					  $iCheck +=1
				  EndIf
		Next

If NOT IsArray($strVendorSpecific4) then Return -1 ;Not a Smart capable drive
If NOT IsArray($strVendorSpecific2) then Return -1
	
	Dim $Status [22]
	For $i = 1 to 21
		$Status[$i] = "NotOk" ;default all status to "NotOK"
	Next

	;if a status passes then Change it to OK
	If $strVendorSpecific[5] >= $strVendorSpecific2[3]  then $Status[1] = "OK"
	If $strVendorSpecific[17] >= $strVendorSpecific2[15] then $Status[2] = "OK"
	If $strVendorSpecific[29] >= $strVendorSpecific2[27] then $Status[3] = "OK"
	If $strVendorSpecific[41] >= $strVendorSpecific2[39] then $Status[4] = "OK"
	If $strVendorSpecific[53] >= $strVendorSpecific2[51] then $Status[5] = "OK"
	If $strVendorSpecific[65] >= $strVendorSpecific2[63] then $Status[6] = "OK"
	If $strVendorSpecific[77] >= $strVendorSpecific2[75] then $Status[7] = "OK"
	If $strVendorSpecific[89] >= $strVendorSpecific2[87] then $Status[8] = "OK"
	If $strVendorSpecific[101] >= $strVendorSpecific2[99] then $Status[9] = "OK"
	If $strVendorSpecific[113] >= $strVendorSpecific2[111] then $Status[10] = "OK"
	If $strVendorSpecific[125] >= $strVendorSpecific2[123] then $Status[11] = "OK"
	If $strVendorSpecific[137] >= $strVendorSpecific2[135] then $Status[12] = "OK"
	If $strVendorSpecific[149] >= $strVendorSpecific2[147] then $Status[13] = "OK"
	If $strVendorSpecific[161] >= $strVendorSpecific2[159] then $Status[14] = "OK"
	If $strVendorSpecific[173] >= $strVendorSpecific2[171] then $Status[15] = "OK"
	If $strVendorSpecific[185] >= $strVendorSpecific2[183] then $Status[16] = "OK"
	If $strVendorSpecific[197] >= $strVendorSpecific2[195] then $Status[17] = "OK"
	If $strVendorSpecific[206] >= $strVendorSpecific2[204] then $Status[18] = "OK"
	If $strVendorSpecific[218] >= $strVendorSpecific2[216] then $Status[19] = "OK"
	If $strVendorSpecific[230] >= $strVendorSpecific2[228] then $Status[20] = "OK"
	If $strVendorSpecific[242] >= $strVendorSpecific2[240] then $Status[21] = "OK"
	
	

	Dim $aSmartData[1][8] = [["ID","Attribute","Type","Flag","Threshold","Value","Worst","Status"]]
	$iCnt=1
	For $x = 2 to 242 Step 12 
		If $strVendorSpecific[$x] <> 0 then ;0 id is not valid for this Smart Device
			$NextRow = Ubound($aSmartData)
			Redim $aSmartData[$NextRow +1][8]
				$aSmartData[$NextRow][0] = $strVendorSpecific[$x];ID
				$aSmartData[$NextRow][1] = $oDict.Item($strVendorSpecific[$x]);Attribute
				If $aSmartData[$NextRow][1] = "" then $aSmartData[$NextRow][1] = "Unknown SMART Attribute"
				
				If Mod($strVendorSpecific[$x +1],2) then ;Type If odd number then it is a pre-failure value
					$aSmartData[$NextRow][2] = "Pre-Failure" 
				Else
					$aSmartData[$NextRow][2] = "Advisory" 
				EndIf
				#region
				;Old method not needed now
				;$aSmartData[$NextRow][2] = $oDictType.Item($strVendorSpecific[$x])
				;If $aSmartData[$NextRow][2] = "" then $aSmartData[$NextRow][2] = "Advisory"
				#endregion
				$aSmartData[$NextRow][3] = $strVendorSpecific[$x +1];Flag
				$aSmartData[$NextRow][4] = $strVendorSpecific2[$x +1];Threshold
				$aSmartData[$NextRow][5] = $strVendorSpecific[$x +3];Value
				$aSmartData[$NextRow][6] = $strVendorSpecific[$x +4];Worst
				$aSmartData[$NextRow][7] = $Status[$iCnt];Status
			EndIf
			$iCnt+=1
	Next
		
			Return 	$aSmartData
EndFunc

Func _PartitionToPhysicalDriveID($vPart)

	$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_DiskDriveToDiskPartition", "WQL", _
                                          $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	If IsObj($colItems) then
	   For $objItem In $colItems
		   If $objItem.Dependent == $vPart then 
			   $vPdisk = $objItem.Antecedent
			   $vPdisk = StringReplace(StringTrimLeft($vPdisk,Stringinstr($vPdisk,"=")),'"',"")
			   $strDeviceID = StringReplace($vPdisk, "\\", "\")
				Return $strDeviceID
			Endif
	   Next
	Endif
	Return -1
EndFunc

Func _PNPIDFromPhysicalDriveID($vDriveID)
	
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_DiskDrive", "WQL", _
                                          $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	If IsObj($colItems) then
	   For $objItem In $colItems
		If $objItem.DeviceID == $vDriveID then
		  Return $objItem.PNPDeviceID
		EndIf
	  Next
	Endif
	Return -1
EndFunc

Func _LogicalToPartition ($vDriveLet)

	Local $objWMIService,$colItems,$vAntecedent,$vPartition
	
	$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT Dependent,Antecedent FROM Win32_LogicalDiskToPartition", "WQL", _
											  $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	If IsObj($colItems) then
	   For $objItem In $colItems
		   If StringRight($objItem.Dependent,4) == $vDriveLet then 
			$vAntecedent=$objItem.Antecedent
		  Return $vAntecedent;$partition
		EndIf
	   Next
	Endif
	Return -1
EndFunc


Func _CreateDict()
	$oDict.Add(1,"Read Error Rate")
	$oDict.Add(2,"Throughput Performance")
	$oDict.Add(3,"Spin-Up Time")
	$oDict.Add(4,"Start/Stop Count")
	$oDict.Add(5,"Reallocated Sectors Count")
	$oDict.Add(6,"Read Channel Margin")
	$oDict.Add(7,"Seek Error Rate Rate")
	$oDict.Add(8,"Seek Time Performance")
	$oDict.Add(9,"Power-On Hours (POH)")
	$oDict.Add(10,"Spin Retry Count")
	$oDict.Add(11,"Recalibration Retries")
	$oDict.Add(12,"Device Power Cycle Count")
	$oDict.Add(13,"Soft Read Error Rate")
	$oDict.Add(191,"G-Sense Error Rate Frequency")
	$oDict.Add(192,"Power-Off Park Count")
	$oDict.Add(193,"Load/Unload Cycle")
	$oDict.Add(194,"HDA Temperature")
	$oDict.Add(195,"ECC Corrected Count")
	$oDict.Add(196,"Reallocated Event Count")
	$oDict.Add(197,"Current Pending Sector Count")
	$oDict.Add(198,"Uncorrectable Sector Count")
	$oDict.Add(199,"UltraDMA CRC Error Count")
	$oDict.Add(200,"Write Error Rate")
	$oDict.Add(201,"Soft Read Error Rate")
	$oDict.Add(202,"Address Mark Errors Frequency")
	$oDict.Add(203,"ECC errors (Maxtor: ECC Errors)")
	$oDict.Add(204, "Soft ECC Correction")
	$oDict.Add(205, "Thermal Asperity Rate (TAR)")
	$oDict.Add(206, "Flying Height")
	$oDict.Add(207, "Spin High Current")
	$oDict.Add(208, "Spin Buzz")
	$oDict.Add(209, "Offline Seek")
	$oDict.Add(220, "Disk Shift")
	$oDict.Add(221, "G-Sense Error Rate")
	$oDict.Add(222, "Loaded Hours")
	$oDict.Add(223, "Load/Unload Retry Count")
	$oDict.Add(224, "Load Friction")
	$oDict.Add(225, "/Unload Cycle Count")
	$oDict.Add(226, "Load 'In'-time")
	$oDict.Add(227, "Torque Amplification Count")
	$oDict.Add(228, "Power-Off Retract Cycle")
	$oDict.Add(230, "GMR Head Amplitude")
	$oDict.Add(231, "Temperature")
	$oDict.Add(240, "Head Flying Hours")
	$oDict.Add(250, "Read Error Retry Rate")
EndFunc



;This is COM error handler
Func MyErrFunc()
  $HexNumber=hex($oMyError.number,8)
  Return
  Msgbox(0,"COM Error Test","We intercepted a COM Error !"       & @CRLF  & @CRLF & _
			 "err.description is: "    & @TAB & $oMyError.description    & @CRLF & _
			 "err.windescription:"     & @TAB & $oMyError.windescription & @CRLF & _
			 "err.number is: "         & @TAB & $HexNumber              & @CRLF & _
			 "err.lastdllerror is: "   & @TAB & $oMyError.lastdllerror   & @CRLF & _
			 "err.scriptline is: "     & @TAB & $oMyError.scriptline     & @CRLF & _
			 "err.source is: "         & @TAB & $oMyError.source         & @CRLF & _
			 "err.helpfile is: "       & @TAB & $oMyError.helpfile       & @CRLF & _
			 "err.helpcontext is: "    & @TAB & $oMyError.helpcontext _
			)
  SetError(1)  ; to check for after this function returns
Endfunc

#cs
;Old Not needed any more

Func _CreateTypeDict();Not needed any more
	$oDictType.Add(1,"Pre-failure")
	$oDictType.Add(2,"Pre-failure")
	$oDictType.Add(3,"Pre-failure")
	$oDictType.Add(4,"Advisory")
	$oDictType.Add(5,"Pre-failure")
	$oDictType.Add(6,"Advisory")
	$oDictType.Add(7,"Pre-failure")
	$oDictType.Add(8,"Advisory")
	$oDictType.Add(9,"Advisory")
	$oDictType.Add(10,"Pre-failure")
	$oDictType.Add(12,"Advisory")
	$oDictType.Add(191,"Advisory")
	$oDictType.Add(192,"Advisory")
	$oDictType.Add(193,"Advisory")
	$oDictType.Add(194,"Advisory")
	$oDictType.Add(195,"Advisory")
	$oDictType.Add(196,"Advisory")
	$oDictType.Add(197,"Advisory")
	$oDictType.Add(198,"Advisory")
	$oDictType.Add(199,"Advisory")
	$oDictType.Add(200,"Advisory")
	$oDictType.Add(201,"Advisory")
	$oDictType.Add(202,"Advisory")
	$oDictType.Add(203,"Advisory")
EndFunc


Dim $aSmartData[1][7] = [["ID","Attribute","Flag","Threshold","Value","Worst","Status"], _		
[$strVendorSpecific[2],$oDict.Item($strVendorSpecific[2]),$strVendorSpecific[3],$strVendorSpecific2[3],$strVendorSpecific[5],$strVendorSpecific[6],$Status[1]], _
[$strVendorSpecific[14],$oDict.Item($strVendorSpecific[14]),$strVendorSpecific[15],$strVendorSpecific2[15],$strVendorSpecific[17],$strVendorSpecific[18],$Status[2]], _
[$strVendorSpecific[26],$oDict.Item($strVendorSpecific[26]),$strVendorSpecific[27],$strVendorSpecific2[27],$strVendorSpecific[29],$strVendorSpecific[30],$Status[3]], _
[$strVendorSpecific[38],$oDict.Item($strVendorSpecific[38]),$strVendorSpecific[39],$strVendorSpecific2[39],$strVendorSpecific[41],$strVendorSpecific[42],$Status[4]], _
[$strVendorSpecific[50],$oDict.Item($strVendorSpecific[50]),$strVendorSpecific[51],$strVendorSpecific2[51],$strVendorSpecific[53],$strVendorSpecific[54],$Status[5]], _
[$strVendorSpecific[62],$oDict.Item($strVendorSpecific[62]),$strVendorSpecific[63],$strVendorSpecific2[63],$strVendorSpecific[65],$strVendorSpecific[66],$Status[6]], _
[$strVendorSpecific[74],$oDict.Item($strVendorSpecific[74]),$strVendorSpecific[75],$strVendorSpecific2[75],$strVendorSpecific[77],$strVendorSpecific[78],$Status[7]], _
[$strVendorSpecific[86],$oDict.Item($strVendorSpecific[86]),$strVendorSpecific[87],$strVendorSpecific2[87],$strVendorSpecific[89],$strVendorSpecific[90],$Status[8]], _
[$strVendorSpecific[98],$oDict.Item($strVendorSpecific[98]),$strVendorSpecific[99],$strVendorSpecific2[99],$strVendorSpecific[101],$strVendorSpecific[102],$Status[9]], _
[$strVendorSpecific[110],$oDict.Item($strVendorSpecific[110]),$strVendorSpecific[111],$strVendorSpecific2[111],$strVendorSpecific[113],$strVendorSpecific[114],$Status[10]], _
[$strVendorSpecific[122],$oDict.Item($strVendorSpecific[122]),$strVendorSpecific[123],$strVendorSpecific2[123],$strVendorSpecific[125],$strVendorSpecific[126],$Status[11]], _
[$strVendorSpecific[134],$oDict.Item($strVendorSpecific[134]),$strVendorSpecific[135],$strVendorSpecific2[135],$strVendorSpecific[137],$strVendorSpecific[138],$Status[12]], _
[$strVendorSpecific[146],$oDict.Item($strVendorSpecific[146]),$strVendorSpecific[147],$strVendorSpecific2[147],$strVendorSpecific[149],$strVendorSpecific[150],$Status[13]], _
[$strVendorSpecific[158],$oDict.Item($strVendorSpecific[158]),$strVendorSpecific[159],$strVendorSpecific2[159],$strVendorSpecific[161],$strVendorSpecific[162],$Status[14]], _
[$strVendorSpecific[170],$oDict.Item($strVendorSpecific[170]),$strVendorSpecific[171],$strVendorSpecific2[171],$strVendorSpecific[173],$strVendorSpecific[174],$Status[15]], _
[$strVendorSpecific[182],$oDict.Item($strVendorSpecific[182]),$strVendorSpecific[183],$strVendorSpecific2[183],$strVendorSpecific[185],$strVendorSpecific[186],$Status[16]], _
[$strVendorSpecific[194],$oDict.Item($strVendorSpecific[194]),$strVendorSpecific[195],$strVendorSpecific2[195],$strVendorSpecific[197],$strVendorSpecific[198],$Status[17]], _
[$strVendorSpecific[206],$oDict.Item($strVendorSpecific[206]),$strVendorSpecific[207],$strVendorSpecific2[207],$strVendorSpecific[209],$strVendorSpecific[210],$Status[18]], _
[$strVendorSpecific[218],$oDict.Item($strVendorSpecific[218]),$strVendorSpecific[219],$strVendorSpecific2[219],$strVendorSpecific[221],$strVendorSpecific[222],$Status[19]], _
[$strVendorSpecific[230],$oDict.Item($strVendorSpecific[230]),$strVendorSpecific[231],$strVendorSpecific2[231],$strVendorSpecific[233],$strVendorSpecific[234],$Status[20]], _
[$strVendorSpecific[242],$oDict.Item($strVendorSpecific[242]),$strVendorSpecific[243],$strVendorSpecific2[243],$strVendorSpecific[245],$strVendorSpecific[246],$Status[21]]]

For $x = 1 to Ubound($aSmartData) -1
	If $aSmartData[$x][1] = "" then $aSmartData[$x][1] = "Unknown SMART Attribute"
	If $aSmartData[$x][0] = 0 then 
		For $y = 0 to Ubound($aSmartData,2) -1
			$aSmartData[$x][$y] = ""
		Next
	EndIf
	
Next
	
#ce

