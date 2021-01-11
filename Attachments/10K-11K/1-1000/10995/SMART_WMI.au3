; ptrex 

#include <array.au3>

Const $wbemFlagReturnImmediately = 0x10
Const $wbemFlagForwardOnly = 0x20

Dim $strComputer = "."  ; Retrieve remote data fill in the "Remote Computer IP or Name"

Dim $objWMIService, $oMyError, $oDict
Dim $colItems, $strReserved, $strVendorSpecific, $strVendorSpecific4, $Output

; Initialize error handler and Objects
	$oMyError = ObjEvent("AutoIt.Error","MyErrFunc")
	$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\WMI")
	$oDict = ObjCreate("Scripting.Dictionary")

	$colItems1 = $objWMIService.ExecQuery("SELECT * FROM MSStorageDriver_ATAPISmartData", "WQL", _
                                          $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	
	$colItems2 = $objWMIService.ExecQuery("SELECT * FROM MSStorageDriver_FailurePredictThresholds", "WQL", _
                                          $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
										  
	$colItems3 = $objWMIService.ExecQuery("SELECT * FROM MSStorageDriver_FailurePredictStatus", "WQL", _
                                          $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	_CreateDict() ; Create Dictionary
	
	ConsoleWrite ($strComputer&@CR)							  
	
	For $objItem In $colItems3
      $strVendorSpecific3 = $objItem.PredictFailure
	  $strVendorSpecific3 = $objItem.Reason
	  ConsoleWrite ("PredictFailure: " & $strVendorSpecific3&@CR)
	  ConsoleWrite ("PredictReason: " & $strVendorSpecific3&@CR)
    Next
	
	For $objItem In $colItems2
      $strVendorSpecific2 = $objItem.VendorSpecific
	  ConsoleWrite ("FailurePredictThresholds: " & _ArrayToString($strVendorSpecific2,",")&@CR)
    Next

   For $objItem In $colItems1
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
		
		
	ConsoleWrite ("VendorSpecific: " & _ArrayToString($strVendorSpecific,",")&@CR)
	ConsoleWrite ("VendorSpecific2: " & $objItem.VendorSpecific2&@CR)
	ConsoleWrite ("VendorSpecific3: " & $objItem.VendorSpecific3&@CR)
		$strVendorSpecific4 = $objItem.VendorSpecific4
	ConsoleWrite ("VendorSpecific4: " & _ArrayToString($strVendorSpecific4,",")&@CR)
Next

Dim $Temp[17] = [$strVendorSpecific[5] > $strVendorSpecific2[3],$strVendorSpecific[17] > $strVendorSpecific2[15]]
Dim $Status [17]
Select
	Case $Temp[1] > 0
		$Status[1] = "OK"
	Case $Temp[2] > 0
		$Status[2] = "OK"
	Case $strVendorSpecific[29] > $strVendorSpecific2[27]
		$Status[3] = "OK"
	Case $strVendorSpecific[41] > $strVendorSpecific2[39]
		$Status[4] = "OK"
	Case $strVendorSpecific[53] > $strVendorSpecific2[51]
		$Status[5] = "OK"
	Case $strVendorSpecific[65] > $strVendorSpecific2[63]
		$Status[6] = "OK"
	Case $strVendorSpecific[77] > $strVendorSpecific2[75]
		$Status[7] = "OK"
	Case $strVendorSpecific[89] > $strVendorSpecific2[87]
		$Status[8] = "OK"
	Case $strVendorSpecific[101] > $strVendorSpecific2[99]
		$Status[9] = "OK"
	Case $strVendorSpecific[113] > $strVendorSpecific2[111]
		$Status[10] = "OK"
	Case $strVendorSpecific[125] > $strVendorSpecific2[123]
		$Status[11] = "OK"
	Case $strVendorSpecific[137] > $strVendorSpecific2[135]
		$Status[12] = "OK"
	Case $strVendorSpecific[149] > $strVendorSpecific2[147]
		$Status[13] = "OK"
	Case $strVendorSpecific[161] > $strVendorSpecific2[159]
		$Status[14] = "OK"
	Case $strVendorSpecific[173] > $strVendorSpecific2[171]
		$Status[15] = "OK"
	Case $strVendorSpecific[185] > $strVendorSpecific2[183]
		$Status[16] = "OK"
	Case $strVendorSpecific[197] > $strVendorSpecific2[195]
		$Status[17] = "OK"
	Case Else
		$Status = "Not OK"
EndSelect

Dim $Output1= "ID"&@tab&"Attribute"&@tab&@tab&@tab&@tab&"Flag"&@tab&"Threshold"&@tab&"Value"&@tab&"Worst"&@tab&"Raw"&@tab&"Status"&@CR _
		&$strVendorSpecific[2]&@tab&$oDict.Item($strVendorSpecific[2])&@tab&@tab&@tab&$strVendorSpecific[3]&@tab&$strVendorSpecific2[3]&@tab&$strVendorSpecific[5]&@tab&$strVendorSpecific[6]&@tab&@tab&$Status[1]&@CR _
		&$strVendorSpecific[14]&@tab&$oDict.Item($strVendorSpecific[14])&@tab&@tab&@tab&$strVendorSpecific[15]&@tab&$strVendorSpecific2[15]&@tab&$strVendorSpecific[17]&@tab&$strVendorSpecific[18]&@tab&@tab&$Status[2]&@CR _
		&$strVendorSpecific[26]&@tab&$oDict.Item($strVendorSpecific[26])&@tab&@tab&@tab&$strVendorSpecific[27]&@tab&$strVendorSpecific2[27]&@tab&$strVendorSpecific[29]&@tab&$strVendorSpecific[30]&@tab&@tab&$Status[3]&@CR _
		&$strVendorSpecific[38]&@tab&$oDict.Item($strVendorSpecific[38])&@tab&@tab&$strVendorSpecific[39]&@tab&$strVendorSpecific2[39]&@tab&$strVendorSpecific[41]&@tab&$strVendorSpecific[42]&@tab&@tab&$Status[4]&@CR _
		&$strVendorSpecific[50]&@tab&$oDict.Item($strVendorSpecific[50])&@tab&@tab&$strVendorSpecific[51]&@tab&$strVendorSpecific2[51]&@tab&$strVendorSpecific[53]&@tab&$strVendorSpecific[54]&@tab&@tab&$Status[5]&@CR _
		&$strVendorSpecific[62]&@tab&$oDict.Item($strVendorSpecific[62])&@tab&@tab&$strVendorSpecific[63]&@tab&$strVendorSpecific2[63]&@tab&$strVendorSpecific[65]&@tab&$strVendorSpecific[66]&@tab&@tab&$Status[6]&@CR _
		&$strVendorSpecific[74]&@tab&$oDict.Item($strVendorSpecific[74])&@tab&@tab&@tab&$strVendorSpecific[75]&@tab&$strVendorSpecific2[75]&@tab&$strVendorSpecific[77]&@tab&$strVendorSpecific[78]&@tab&@tab&$Status[7]&@CR _
		&$strVendorSpecific[86]&@tab&$oDict.Item($strVendorSpecific[86])&@tab&@tab&$strVendorSpecific[87]&@tab&$strVendorSpecific2[87]&@tab&$strVendorSpecific[89]&@tab&$strVendorSpecific[90]&@tab&@tab&$Status[8]&@CR

Dim $Output2=$strVendorSpecific[98]&@tab&$oDict.Item($strVendorSpecific[98])&@tab&@tab&$strVendorSpecific[99]&@tab&$strVendorSpecific2[99]&@tab&$strVendorSpecific[101]&@tab&$strVendorSpecific[102]&@CR _
		&$strVendorSpecific[110]&@tab&$oDict.Item($strVendorSpecific[110])&@tab&@tab&@tab&$strVendorSpecific[111]&@tab&$strVendorSpecific2[111]&@tab&$strVendorSpecific[113]&@tab&$strVendorSpecific[114]&@CR _
		&$strVendorSpecific[122]&@tab&$oDict.Item($strVendorSpecific[122])&@tab&@tab&@tab&$strVendorSpecific[123]&@tab&$strVendorSpecific2[123]&@tab&$strVendorSpecific[125]&@tab&$strVendorSpecific[126]&@CR _
		&$strVendorSpecific[134]&@tab&$oDict.Item($strVendorSpecific[134])&@tab&@tab&$strVendorSpecific[135]&@tab&$strVendorSpecific2[135]&@tab&$strVendorSpecific[137]&@tab&$strVendorSpecific[138]&@CR _
		&$strVendorSpecific[146]&@tab&$oDict.Item($strVendorSpecific[146])&@tab&$strVendorSpecific[147]&@tab&$strVendorSpecific2[147]&@tab&$strVendorSpecific[149]&@tab&$strVendorSpecific[150]&@CR _
		&$strVendorSpecific[158]&@tab&$oDict.Item($strVendorSpecific[158])&@tab&@tab&$strVendorSpecific[159]&@tab&$strVendorSpecific2[159]&@tab&$strVendorSpecific[161]&@tab&$strVendorSpecific[162]&@CR _
		&$strVendorSpecific[170]&@tab&$oDict.Item($strVendorSpecific[170])&@tab&@tab&$strVendorSpecific[171]&@tab&$strVendorSpecific2[171]&@tab&$strVendorSpecific[173]&@tab&$strVendorSpecific[174]&@CR _
		&$strVendorSpecific[182]&@tab&$oDict.Item($strVendorSpecific[182])&@tab&@tab&@tab&$strVendorSpecific[183]&@tab&$strVendorSpecific2[183]&@tab&$strVendorSpecific[185]&@tab&$strVendorSpecific[186]&@CR _
		&$strVendorSpecific[194]&@tab&$oDict.Item($strVendorSpecific[194])&@tab&$strVendorSpecific[195]&@tab&$strVendorSpecific2[195]&@tab&$strVendorSpecific[197]&@tab&$strVendorSpecific[198] _	

MsgBox(0,"Output : "&$strComputer, $Output1&$Output2)


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
	$oDict.Add(12,"Device Power Cycle Count")
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
EndFunc

;This is COM error handler
Func MyErrFunc()
  $HexNumber=hex($oMyError.number,8)
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
