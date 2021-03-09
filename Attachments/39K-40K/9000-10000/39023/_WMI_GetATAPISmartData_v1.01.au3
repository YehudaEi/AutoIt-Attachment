; Self-Monitoring, Analysis and Reporting Technology - S.M.A.R.T.
;----------------------------------------------------------------
;
; _WMI_GetATAPISmartData.au3
; v0.1 - May 08, 2012 * Initial Release by ripdad
; v1.00 - October 19, 2012 * Full version release.
; v1.01 - November 26, 2012 * Re-evaluated logic and made many changes.
;
#include 'array.au3'
#RequireAdmin
;
Opt('MustDeclareVars', 1)
Opt('TrayAutoPause', 0)
;
Local $oErrorHandler = ObjEvent('AutoIt.Error', '_ObjErrorHandler')
Local $Object_Error, $ObjError_Msg
;
_WMI_GetATAPISmartData()
Exit
;
Func _WMI_GetATAPISmartData()
    Local $a[76][2] = [[75, 'Attribute Name'], _
            [1, 'ReadErrorRate'], _
            [2, 'ThroughputPerformance'], _
            [3, 'SpinUpTime'], _
            [4, 'StartStopCount'], _
            [5, 'ReallocatedSectorsCount/SSDRetiredBlockCount'], _
            [6, 'ReadChannelMargin'], _
            [7, 'SeekErrorRate'], _
            [8, 'SeekTimePerformance'], _
            [9, 'PowerOnHours(POH)'], _
            [10, 'SpinRetryCount'], _
            [11, 'CalibrationRetryCount'], _
            [12, 'PowerCycleCount'], _
            [13, 'SoftReadErrorRate'], _
            [170, 'SSDReservedBlockCount'], _
            [171, 'SSDProgramFailBlockCount'], _
            [172, 'SSDEraseFailBlockCount'], _
            [173, 'SSDWearLevelingCount'], _
            [174, 'SSDUnexpectedPowerLossCount'], _
            [175, 'SSDProgramFailCount(Chip)'], _
            [176, 'SSDEraseFailCount(Chip)'], _
            [177, 'SSDWearRangeDelta/SSDWearLevelingCount'], _
            [178, 'SSDUsedReservedBlockCount(Chip)'], _
            [179, 'SSDUsedReservedBlockCount'], _
            [180, 'BlockCountTotal/SSDUnusedReservedBlockCount'], _
            [181, 'SSDProgramFailCount'], _
            [182, 'SSDEraseFailCount'], _
            [183, 'SATADownshiftErrorCount/SSDRuntimeBadBlock'], _
            [184, 'EndtoEnderror'], _
            [185, 'HeadStability'], _
            [186, 'InducedOpVibrationDetection'], _
            [187, 'ReportedUncorrectableErrors/SSDUncorrectableErrorCount'], _
            [188, 'CommandTimeout'], _
            [189, 'HighFlyWrites'], _
            [190, 'AirflowTemperatureWDC/TemperatureDifferenceFrom100'], _
            [191, 'GSenseErrorRate'], _
            [192, 'PoweroffRetractCount'], _
            [193, 'LoadCycleCount'], _
            [194, 'Temperature'], _
            [195, 'HardwareECCRecovered/SSDECCOnTheFlyCount'], _
            [196, 'ReallocationEventCount'], _
            [197, 'CurrentPendingSectorCount'], _
            [198, 'UncorrectableSectorCount/SSDOffLineUncorrectableErrorCount'], _
            [199, 'UltraDMACRCErrorCount/SSDCRCErrorCount'], _
            [200, 'MultiZoneErrorRate/WriteErrorRate'], _
            [201, 'OffTrackSoftReadErrorRate/SSDUncorrectableSoftReadErrorRate'], _
            [202, 'DataAddressMarkErrors'], _
            [203, 'RunOutCancel'], _
            [204, 'SSDSoftECCCorrection'], _
            [205, 'ThermalAsperityRate(TAR)'], _
            [206, 'FlyingHeight'], _
            [207, 'SpinHighCurrent'], _
            [208, 'SpinBuzz'], _
            [209, 'OfflineSeekPerformance'], _
            [210, 'VibrationDuringWrite'], _
            [211, 'VibrationDuringWrite'], _
            [212, 'ShockDuringWrite'], _
            [220, 'DiskShift'], _
            [221, 'GSenseErrorRateAlt'], _
            [222, 'LoadedHours'], _
            [223, 'LoadUnloadRetryCount'], _
            [224, 'LoadFriction'], _
            [225, 'LoadUnloadCycleCount'], _
            [226, 'LoadInTime'], _
            [227, 'TorqueAmplificationCount'], _
            [228, 'PowerOffRetractCycle'], _
            [230, 'GMRHeadAmplitude/SSDLifeCurveStatus'], _
            [231, 'SSDLifeLeft/Temperature'], _
            [232, 'AvailableReservedSpace/EnduranceRemaining'], _
            [233, 'MediaWearoutIndicator/PowerOnHours'], _
            [234, 'SSDReservedVS'], _
            [240, 'HeadFlyingHours/TransferErrorRate'], _
            [241, 'SSDLifeTimeWritesFromHost/TotalLBAsWritten'], _
            [242, 'SSDLifeTimeReadsFromHost/TotalLBAsRead'], _
            [250, 'ReadErrorRetryRate'], _
            [254, 'FreeFallProtection']]

    ; VSD = VendorSpecificData
    ; Nom/Flag = Nominal Value or Flag
    ; Cycles = Number of Turnovers from "Raw/Value". One Cycle = 256
    ; SumCounts = Dual Meaning, A Play on Words -> SumCounts (The total amount of 2 columns) And SomeCounts (as opposed to AllCounts):
    ;             1) The total of ("Cycles" * 256) + "Raw/Value"
    ;             2) Only the Attribute Names "PowerOnHours(POH)" Or the word "Count" in the string are processed in this column -- Else, it is set to zero.
    Local $aSMART[1][15] = [['Attribute', 'Nom/Flag', 'Status', 'Value/%', 'Worst/%', 'Raw/Value', 'Cycles', 'VSD1', 'VSD2', 'VSD3', 'VSD4', 'VSD5', 'Threshold', 'SumCounts', 'AttributeName']]

    _WMI_ObjErrorReset()

    Local $objWMI = ObjGet('Winmgmts:{ImpersonationLevel=Impersonate,AuthenticationLevel=PktPrivacy,(Debug)}!\\.\root\CIMV2')
    If $Object_Error Or Not IsObj($objWMI) Then
        Return _WMI_ShowError(1)
    EndIf

    Local $aDriveList[20][4]
    Local $SSD_Detected = 0, $n = 0, $nDevice = -1
    Local $aVendorSpecific, $objClass2, $sPNPDeviceID, $sDriveTitle, $sInstanceName, $sModel, $string

    Local $objClass = $objWMI.InstancesOf('Win32_DiskDrive')
    Local $count = $objClass.Count

    If $Object_Error Then
        Return _WMI_ShowError(2)
    ElseIf Not $count Then
        Return _WMI_ShowError('Win32_DiskDrive=0');<-- Zero = Nothing was found!
    EndIf

    For $objItem In $objClass
        $n += 1
        $aDriveList[$n][0] = $objItem.Model

        If $Object_Error Then;<-- check first item call, inside loop
            Return _WMI_ShowError(3)
        EndIf

        $aDriveList[$n][1] = $objItem.DeviceID
        $aDriveList[$n][2] = $objItem.Size
        $aDriveList[$n][3] = $objItem.PNPDeviceID
    Next

    If $Object_Error Then;<-- check outside loop
        Return _WMI_ShowError(4)
    EndIf

    ReDim $aDriveList[$n + 1][4]
    $aDriveList[0][0] = $n

    $n = 0

    $objClass = $objWMI.InstancesOf('Win32_LogicalDiskToPartition')
    $count = $objClass.Count

    If $Object_Error Then
        Return _WMI_ShowError(5)
    ElseIf Not $count Then
        Return _WMI_ShowError('Win32_LogicalDiskToPartition=0')
    EndIf

    For $objItem In $objClass; Match DeviceID to Drive Letter
        $string = $objItem.Antecedent

        If $Object_Error Then
            Return _WMI_ShowError(6)
        EndIf

        $string = StringRegExpReplace($string, '.*#(\d),.*', '\1')
        If ($string <> $nDevice) Then; Else, drive already processed
            $nDevice = $string

            $n += 1
            If ($n > $aDriveList[0][0]) Then
                ExitLoop; just in case
            EndIf

            If StringRight($aDriveList[$n][1], 1) = $nDevice Then
                $string = $objItem.Dependent
                $aDriveList[$n][1] &= '=' & StringRight($string, 4)
            EndIf
        EndIf
    Next

    If $Object_Error Then
        Return _WMI_ShowError(7)
    EndIf

    $objWMI = ObjGet('Winmgmts:{ImpersonationLevel=Impersonate,AuthenticationLevel=PktPrivacy,(Debug)}!\\.\root\WMI')
    If $Object_Error Or Not IsObj($objWMI) Then
        Return _WMI_ShowError(8)
    EndIf

    $objClass = $objWMI.InstancesOf('MSStorageDriver_ATAPISmartData')
    $count = $objClass.Count

    If $Object_Error Then
        Return _WMI_ShowError(9)
    ElseIf Not $count Then
        Return _WMI_ShowError('MSStorageDriver_ATAPISmartData=0')
    EndIf

    ;<-- Main Loop
    For $objItem In $objClass
        If $Object_Error And StringInStr($ObjError_Msg, '8004100C') Then; <-- Feature or operation is not supported. (MSDN)
            _WMI_ShowError(10); <-- show error message that drive is not supported.
            _WMI_ObjErrorReset(); <-- this error occurred at the previous turn of the loop, so we'll reset and continue.
        EndIf

        $aVendorSpecific = $objItem.VendorSpecific; <-- first item call

        If $Object_Error Then;<---
            Return _WMI_ShowError(10)
        ElseIf Not IsArray($aVendorSpecific) Then
            ContinueLoop
        EndIf

        $sInstanceName = $objItem.InstanceName

        $SSD_Detected = 0
        $sDriveTitle = 0

        For $i = 1 To $aDriveList[0][0]
            $sPNPDeviceID = StringLeft($aDriveList[$i][3], StringLen($aDriveList[$i][3]) - 5);<-- there is usually a string length difference between $sInstanceName and the one in $aDriveList. so, we'll trim it a little so it can match.
            If StringInStr($sInstanceName, $sPNPDeviceID) Then
                $sDriveTitle = ' Model: ' & $aDriveList[$i][0] & '  |  DeviceID: ' & $aDriveList[$i][1] & '  |  Size: ' & GetByteFormat($aDriveList[$i][2])
                ;
                $sModel = $aDriveList[$i][0]
                ;
                ;Detect #1) Find "SSD" string in Model or PNPDeviceID. (FIS) = "Found In String"
                If StringInStr($sModel, 'SSD') Or StringInStr(StringLeft($sPNPDeviceID, 30), 'SSD') Then
                    $SSD_Detected = 'FIS';<-- not quite as accurate compared to a 170-179 attribute.
                EndIf
                ;
                ;=======================================================================================================
                ;Detect #2) Find SSD by Model. (FIM) = "Found In Model"
                ;
                ; Example:
                ;
                Select
                    Case StringInStr($sModel, 'OCZ-VERTEX');<-- use vendor string
                        $SSD_Detected = 'FIM'
                    Case StringInStr($sModel, 'TOSHIBA THNS128GG');<-- vendor with partial model
                        $SSD_Detected = 'FIM';<-- (FIM overides FIS)
                    Case Else
                EndSelect
                ;
                ; I would use an array of Models if the Cases became too many.
                ;=======================================================================================================
                ;
                ExitLoop
            EndIf
        Next

        If Not $sDriveTitle Then;<-- this is better (was $sPNPDeviceID)
            ContinueLoop
        EndIf

        ReDim $aSMART[1][15]; clear array
        ReDim $aSMART[76][15]; set template

        $n = 0

        For $i = 2 To (UBound($aVendorSpecific) - 1) Step 12
            If ($aVendorSpecific[$i] = 0) Then
                ContinueLoop
            EndIf

            ;Detect #3) Find SSD by Attribute Number. (FIA) = "Found In Attribute"
            If StringRegExp($aVendorSpecific[$i], '(17[0-9])') Then
                $SSD_Detected = 'FIA';<-- (FIA overrides FIM and FIS) * or, it could be changed for FIM, example --> If ($SSD_Detected <> 'FIM') Then $SSD_Detected = 'FIA'
            EndIf

            $n += 1

            For $j = 0 To 11
                $aSMART[$n][$j] = $aVendorSpecific[$i + $j]
                If ($j = 2) Then
                    If ($aSMART[$n][$j] = 0) Then
                        $aSMART[$n][$j] = 'OK'
                    EndIf
                ElseIf ($j = 5) And StringRegExp($aSMART[$n][0], '(190|194)') Then
                    If $aSMART[$n][5] Then
                        $aSMART[$n][5] &= 'C/' & Round(($aSMART[$n][5] * 1.8) + 32) & 'F'
                    EndIf
                EndIf
            Next

            For $j = 1 To $a[0][0]
                If $a[$j][0] = $aVendorSpecific[$i] Then
                    $aSMART[$n][14] = $a[$j][1]
                    If StringInStr($aSMART[$n][14], 'Count') Or ($aSMART[$n][0] = 9) Then
                        $aSMART[$n][13] = ($aSMART[$n][6] * 256) + $aSMART[$n][5]
                    Else
                        $aSMART[$n][13] = 0
                    EndIf
                EndIf
            Next

            If Not StringExists($aSMART[$n][14]) Then
                $aSMART[$n][14] = '(UnknownAttribute)'
                $aSMART[$n][13] = 0
            EndIf
        Next

        If $Object_Error Then
            Return _WMI_ShowError(11)
        EndIf

        $objClass2 = $objWMI.InstancesOf('MSStorageDriver_FailurePredictThresholds')
        $count = $objClass2.Count

        If $Object_Error Then
            Return _WMI_ShowError(12)
        ElseIf Not $count Then
            Return _WMI_ShowError('MSStorageDriver_FailurePredictThresholds=0')
        EndIf

        $n = 0

        For $objItem In $objClass2
            If $Object_Error And StringInStr($ObjError_Msg, '8004100C') Then
                _WMI_ObjErrorReset()
            EndIf

            $aVendorSpecific = $objItem.VendorSpecific

            If $Object_Error Then;<---
                Return _WMI_ShowError(13)
            ElseIf Not IsArray($aVendorSpecific) Then
                ContinueLoop
            EndIf

            $sInstanceName = $objItem.InstanceName

            If StringInStr($sInstanceName, $sPNPDeviceID) Then
                For $i = 2 To (UBound($aVendorSpecific) - 1) Step 12
                    If $aVendorSpecific[$i] Then
                        $n += 1
                        $aSMART[$n][12] = $aVendorSpecific[$i + 1]
                    EndIf
                Next
                ExitLoop
            EndIf
        Next

        If $Object_Error Then
            Return _WMI_ShowError(14)
        EndIf

        $objClass2 = $objWMI.InstancesOf('MSStorageDriver_FailurePredictStatus')
        $count = $objClass2.Count

        If $Object_Error Then
            Return _WMI_ShowError(15)
        ElseIf Not $count Then
            Return _WMI_ShowError('MSStorageDriver_FailurePredictStatus=0')
        EndIf

        For $objItem In $objClass2
            If $Object_Error And StringInStr($ObjError_Msg, '8004100C') Then
                _WMI_ObjErrorReset()
            EndIf

            $sInstanceName = $objItem.InstanceName

            If $Object_Error Then;<---
                Return _WMI_ShowError(16)
            EndIf

            If StringInStr($sInstanceName, $sPNPDeviceID) Then
                $sDriveTitle &= '  |  PredictFailure=' & $objItem.PredictFailure
                ExitLoop
            EndIf
        Next

        If $Object_Error Then
            Return _WMI_ShowError(17)
        EndIf

        ReDim $aSMART[$n + 1][15]

        _ArrayDisplay($aSMART, $sDriveTitle & '|  SSD Detected: ' & $SSD_Detected)
    Next
EndFunc
;
;==============================================================
; #Function...: StringExists($s, $n)
; Description.: Test if a string, else whitespace.
; Version.....; 0.1 (simple version)
; Syntax......: $s = Input String.
;.............: $n = Number of characters to test.
; Remarks.....: Returns positive number if string, else 0.
;==============================================================
Func StringExists($s, $n = 30)
    Return StringLen(StringStripWS(StringLeft($s, $n), 8))
EndFunc
;
;==============================================================
; #Function...: GetByteFormat($n_b, $ns_os)
; Description.: Formats a byte input at the provided offset.
; Version.....; 0.3 (using StringMatch)
; Syntax......: $n_b = Input bytes. (number)
;.............: $ns_os = Offset of wanted type; number or string.
; Remarks.....: Returns a formatted byte string.
;==============================================================
Func GetByteFormat($n_b, $ns_os = 1)
    If Not StringIsDigit($ns_os) Then
        $ns_os = StringMatch($ns_os, 'Bytes|KiloBytes|MegaBytes')
    EndIf
    Local $a_ab = StringSplit('Bytes|KB|MB|GB|TB', '|')
    If ($ns_os < 1) Or ($ns_os > $a_ab[0]) Then Return $n_b
    For $i = $ns_os To $a_ab[0]; in @ offset -> div -> abrv -> out
        If ($n_b < 1024) Then Return Round($n_b, 2) & ' ' & $a_ab[$i]
        $n_b /= 1024
    Next
EndFunc
;
;==============================================================
; #Function...: StringMatch($s, $c, $d)
; Description.: Compares with single or multiple strings.
; Version.....; 0.1 (simple version)
; Syntax......: $s = Input string.
;.............: $c = Compare string.
;.............: $d = Delimiter to use. (Default = '|')
; Remarks.....: Returns position number if matched, else 0
;==============================================================
Func StringMatch($s, $c, $d = '|')
    $s = StringLower($s)
    Local $a = StringSplit(StringLower($c), $d, 1)
    For $i = 1 To $a[0]
        If ($s == $a[$i]) Then Return $i
    Next
EndFunc
;
;==============================================================
; #Function...: _WMI_ShowError()
; Description.: Displays Error Message. (timed at 15 seconds)
;==============================================================
Func _WMI_ShowError($_Error)
    If StringIsDigit($_Error) Then
        MsgBox(8240, 'WMI_GetATAPISmartData - Object Error #' & $_Error, $ObjError_Msg & @TAB & @TAB, 15)
    Else
        MsgBox(8240, 'WMI_GetATAPISmartData - Error', $_Error & @TAB & @TAB, 15)
    EndIf
EndFunc
;
;==============================================================
; #Function...: _WMI_ObjErrorReset()
; Description.: External part of _ObjErrorHandler().
; Version.....; 0.1
;==============================================================
Func _WMI_ObjErrorReset()
    $ObjError_Msg = 'Unknown Object Error'
    $Object_Error = 0
EndFunc
;
;==============================================================
; #Function...: _ObjErrorHandler()
; Version.....; 0.7
;==============================================================
Func _ObjErrorHandler()
    If Not IsObj($oErrorHandler) Then
        MsgBox(8240, 'ObjErrorHandler', 'Critical Error - Exiting', 10)
        Exit
    EndIf
    ;
    If $Object_Error Then
        $oErrorHandler.Clear
        Return; first error remains until reset.
    Else
        $Object_Error = 1
    EndIf
    ;
    Local $AOE1 = $oErrorHandler.ScriptLine
    Local $AOE2 = $oErrorHandler.Number
    Local $AOE3 = $oErrorHandler.Description
    Local $AOE4 = $oErrorHandler.WinDescription
    ;
    $oErrorHandler.Clear
    ;
    Local $sMsg = ''
    If $AOE1 Then $sMsg &= 'Line:' & $AOE1
    If $AOE2 Then $sMsg &= ' (0x' & Hex($AOE2, 8) & ') '
    If $AOE3 Then $sMsg &= $AOE3
    If $AOE4 Then $sMsg &= $AOE4
    ;
    If $sMsg Then
        $ObjError_Msg = $sMsg
    EndIf
EndFunc
;

