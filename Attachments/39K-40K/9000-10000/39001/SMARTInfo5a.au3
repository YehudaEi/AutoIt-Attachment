#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=..\Hammer.ico
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/striponly
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

; SmartMon rev 0.5A 16/Nov/2012
; This is based on ripdad's SMART code found here: http://www.autoitscript.com/forum/topic/140346-wmi-getatapismartdata-v100/page__st__60
; It's mainly a GUI around original code that displays the major parameters of the SMART data

#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

#Include <GuiListView.au3>													; for _GUICtrlListView_SetItemText()

Opt("TrayIconHide", 1)														; Hide tray icon

Const  $ProgTitle = "SMARTInfo - rev 0.5a"

; Vars for GUI
Global $ListView1

; Vars for general use
Global $AllHDDs, $Counter1, $Counter2, $lblInfo

; These are specific to _WMI_GetATAPISMARTData()
Global $oErrorHandler = ObjEvent('AutoIt.Error', '_ObjErrorHandler')
Global $Object_Error, $ObjError_Msg

Dim $AllData[5][9]																					; This array holds the 6 fields for each of ? drives

;******************************************

Init()

BuildGUI()

_WMI_GetATAPISmartData()																			; Get the real SMART data

UpdateListView()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $lblInfo
			Run(@ComSpec & " /c " & 'start http://en.wikipedia.org/wiki/S.M.A.R.T.', "", @SW_HIDE)

	EndSwitch
WEnd

;******************************************

Func Init()

	$AllHdds = DriveGetDrive("Fixed")
	If @error = 1 Then
		MsgBox(0, "Debug", "DriveGetDrive() failed.")
		Exit
	EndIf

	Redim $AllData[$AllHDDs[0] + 1][9]												; Make the array big enough to handle as many drives as nec

	For $Counter1 = 1 to $AllHDDs[0]
		ConsoleWrite("Found drive " & $AllHDDs[$Counter1] & @CRLF)
	Next

EndFunc		; End of Func Init()

;******************************************

Func BuildGUI()

	Dim $arrLVHeader[9] = [ "Drive", "Model", "Realloc count", "Pending", "Uncorrectable", "POH", "Power cycles", "Temperature", "PredictFailure" ]

	$Form1 = GUICreate($ProgTitle, 715, 320)

	If @OSVersion = "WIN_XP" Then
		$ListView1 = GUICtrlCreateListView("Drive|Model|Realloc count|Pending|Scan errors|POH|Spin up cycles|Temperature|PredictFailure", 3, 40, 710, 85, -1, BitOR($WS_EX_CLIENTEDGE, $LVS_EX_GRIDLINES,$LVS_EX_FULLROWSELECT))
		GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 40)												; Drive letter
		GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 170)												; Drive model - this is wide enough for 'Samsung HD204UI ATA Device' which is my 2TB drive at home
		GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 79)												; Realloc count
		GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 3, 55)												; Pending
		GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 4, 82)												; Scan errors
		GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 5, 38)												; POH
		GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 6, 78)												; Power cycles
		GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 7, 78)												; Temperature
		GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 8, 80)												; PredictFailure
	Else
		$ListView1 = GUICtrlCreateListView("Drive|Model|Size GB (GiB)|Free GB (GiB)|POH|Spin up cycles|Temperature|Realloc count|Predict failure", 4, 40, 707, 100, -1, BitOR($WS_EX_CLIENTEDGE, $LVS_EX_GRIDLINES,$LVS_EX_FULLROWSELECT))
		GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 40)												; Drive letter
		GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 170)												; Drive model - this is wide enough for 'Samsung HD204UI ATA Device' which is my 2TB drive at home
		GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 79)												; Realloc count
		GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 3, 55)												; Pending
		GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 4, 82)												; Scan errors
		GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 5, 38)												; POH
		GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 6, 78)												; Power cycles
		GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 7, 78)												; Temperature
		GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 8, 80)												; PredictFailure
	EndIf

	GUICtrlSetBkColor(-1, 0xC0DCC0)																	; Sets teal mint green for LV
	GUICtrlSetFont(-1, 8.5, 400, 0, "Tahoma")														; Can't find a font that looks better than or is easier to read than default but that is diff under Vista and Win 7
																									; Set this specifically else does scale correctly

	For $Counter1 = 0 To 8																			; Center all columns
		_GUICtrlListView_SetColumn($ListView1, $Counter1, $arrLVHeader[$Counter1], -1, 2)
	Next

	GUISetFont(10, 400, "",  "Comic Sans MS")														; Set font for rest of GUI

	GUISetBkColor(0xC0C0C0)

	GUICtrlCreateLabel("This program displays important SMART info for up to 4 drives.", 1, 12, 715, 20, $SS_CENTER)

	GUICtrlCreateLabel("Realloc count: number of bad sectors. Anything other than 0 is NOT good.", 1, 140, 715, 20, $SS_CENTER)
	GUICtrlCreateLabel("Pending: number of suspect sectors. Anything other than 0 is NOT good.", 1, 160, 715, 20, $SS_CENTER)
	GUICtrlCreateLabel("Uncorrectable: the total count of uncorrectable errors when reading/writing a sector.", 1, 180, 715, 20, $SS_CENTER)
	GUICtrlCreateLabel("POH: Power on hours - consider that 8 hours per day x 5 days per week x 50 weeks = 2000 hours", 1, 200, 715, 20, $SS_CENTER)
	GUICtrlCreateLabel("Power cycles: the number of times the HDD has been powered on - more is worse", 1, 220, 715, 20, $SS_CENTER)
	GUICtrlCreateLabel("Temperature: rated max operating temperature is generally 55-60 degrees C", 1, 240, 715, 20, $SS_CENTER)
	GUICtrlCreateLabel("Predict failure: this is NOT reliable. If in doubt back up NOW!", 1, 260, 715, 20, $SS_CENTER)

	GUICtrlCreateLabel("More info:", 210, 290, 70, 20)
	$lblInfo = GUICtrlCreateLabel("http://en.wikipedia.org/wiki/S.M.A.R.T.", 280, 290, 240, 20)
	GUICtrlSetColor(-1, "0x0000ff")
	GuiCtrlSetFont(-1, 10, -1, 4) 																	; underlined
	GuiCtrlSetCursor(-1, 0)																			; Change cursor to hand while hovering

	GUISetState(@SW_SHOW)

EndFunc 	; End of Func BuildGUI()

;******************************************

#cs
Format of $AllData array:
$ListView1 = GUICtrlCreateListView("Drive|  Model  |  Size GB/GiB  |  Free GB/GiB  |  POH  |Spin up cycles|Temp C/F|No of spares", 20, 120, 590, 183, -1, BitOR($WS_EX_CLIENTEDGE, $LVS_EX_GRIDLINES,$LVS_EX_FULLROWSELECT))

[x][] is drive letter
[][1] is model
[][2] is Size GB/GiB
[][3] is Free GB/GiB
[][4] is POH
[][5] is Spin up cycles
[][6] is Temp C/F
[][7] is No of spares
#ce

Func UpdateListView()

	_GUICtrlListView_BeginUpdate($ListView1)

	; Always display the first drive in full
	$ListView1_0 = GUICtrlCreateListViewItem($AllData[1][0] & "|" & $AllData[1][1] & "|" & $AllData[1][2] & "|" & $AllData[1][3] & "|" & $AllData[1][4] & "|" & $AllData[1][5] & "|" & $AllData[1][6] & "|" & $AllData[1][7] & "|" & $AllData[1][8], $ListView1)

	If $AllHDDs[0] > 1 Then $ListView1_3 = GUICtrlCreateListViewItem($AllData[2][0] & "|" & $AllData[2][1] & "|" & $AllData[2][2] & "|" & $AllData[2][3] & "|" & $AllData[2][4] & "|" & $AllData[2][5] & "|" & $AllData[2][6] & "|" & $AllData[2][7] & "|" & $AllData[2][8], $ListView1)
	If $AllHDDs[0] > 2 Then $ListView1_5 = GUICtrlCreateListViewItem($AllData[3][0] & "|" & $AllData[3][1] & "|" & $AllData[3][2] & "|" & $AllData[3][3] & "|" & $AllData[3][4] & "|" & $AllData[3][5] & "|" & $AllData[3][6] & "|" & $AllData[3][7] & "|" & $AllData[3][8], $ListView1)
	If $AllHDDs[0] > 3 Then $ListView1_7 = GUICtrlCreateListViewItem($AllData[4][0] & "|" & $AllData[4][1] & "|" & $AllData[4][2] & "|" & $AllData[4][3] & "|" & $AllData[4][4] & "|" & $AllData[4][5] & "|" & $AllData[4][6] & "|" & $AllData[4][7] & "|" & $AllData[4][8], $ListView1)

	_GUICtrlListView_EndUpdate($ListView1)

EndFunc		; End of Func UpdateListView()

;******************************************

;
; Stuff below here is from _WMI_GetATASmartData_v1.00.au3
;

Func _WMI_GetATAPISmartData()

	Local $DriveCounter = 0

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
    If $Object_Error Or Not IsObj($objWMI) Then Return _WMI_ShowError(1)

    Local $aDriveList[20][4]
    Local $SSD_Detected = 0, $n = 0, $nDevice = -1
    Local $aVendorSpecific, $objClass2, $sPNPDeviceID, $sDriveTitle, $sInstanceName, $string

    Local $objClass = $objWMI.InstancesOf('Win32_DiskDrive')
    Local $count = $objClass.Count
    If $Object_Error Then Return _WMI_ShowError(2)
    If Not $count Then Return _WMI_ShowError('Win32_DiskDrive=0');<-- Zero = Nothing was found!

    For $objItem In $objClass
        $n += 1
        $aDriveList[$n][0] = $objItem.Model
        $aDriveList[$n][1] = $objItem.DeviceID
        $aDriveList[$n][2] = $objItem.Size
        $aDriveList[$n][3] = $objItem.PNPDeviceID

ConsoleWrite("$aDriveList[$n][0] = " & $aDriveList[$n][0] & @CRLF)									;
ConsoleWrite("$aDriveList[$n][1] = " & $aDriveList[$n][1] & @CRLF)									;
ConsoleWrite("$aDriveList[$n][2] = " & $aDriveList[$n][2] & @CRLF)									;
ConsoleWrite("$aDriveList[$n][3] = " & $aDriveList[$n][3] & @CRLF)									;

    Next
    If $Object_Error Then Return _WMI_ShowError(3)

    ReDim $aDriveList[$n + 1][4]
    $aDriveList[0][0] = $n

ConsoleWrite("$aDriveList[0][0] = " & $aDriveList[0][0] & @CRLF)									; At BWPS shows 2 with USB flash drive inserted

    $n = 0

    $objClass = $objWMI.InstancesOf('Win32_LogicalDiskToPartition')
    $count = $objClass.Count
    If $Object_Error Then Return _WMI_ShowError(4)
    If Not $count Then Return _WMI_ShowError('Win32_LogicalDiskToPartition=0')

    For $objItem In $objClass; Match DeviceID to Drive Letter
        $string = $objItem.Antecedent
        $string = StringRegExpReplace($string, '.*#(\d),.*', '\1')

		; Test for this device is a HDD - 9/Nov/2012
 		If ($string <> $nDevice) And DriveGetType(StringLeft(StringRight($objItem.Dependent, 3), 2)) = "Fixed" Then; Else, drive already processed
		; Orig line
        ; If ($string <> $nDevice) Then; Else, drive already processed
            $nDevice = $string
            $n += 1
            If ($n > $aDriveList[0][0]) Then
                ExitLoop; just in case
            EndIf

            If StringRight($aDriveList[$n][1], 1) = $nDevice Then
                $string = $objItem.Dependent
                $aDriveList[$n][1] &= '=' & StringRight($string, 4)
ConsoleWrite("Drive # " & $n & "= " & StringRight($string, 4) & @CRLF)
				$AllData[$n][0] = StringLeft(StringRight($string, 3), 2)											; 9/Nov/2012 - Get 'C:' etc
            EndIf
        EndIf
    Next
    If $Object_Error Then Return _WMI_ShowError(5)

    $objWMI = ObjGet('Winmgmts:{ImpersonationLevel=Impersonate,AuthenticationLevel=PktPrivacy,(Debug)}!\\.\root\WMI')
    If $Object_Error Or Not IsObj($objWMI) Then Return _WMI_ShowError(6)

    $objClass = $objWMI.InstancesOf('MSStorageDriver_ATAPISmartData')
    $count = $objClass.Count
    If $Object_Error Then Return _WMI_ShowError(7)
    If Not $count Then Return _WMI_ShowError('MSStorageDriver_ATAPISmartData=0')

    For $objItem In $objClass
        $aVendorSpecific = $objItem.VendorSpecific
        If Not IsArray($aVendorSpecific) Then ContinueLoop

        $sInstanceName = $objItem.InstanceName
        $sPNPDeviceID = 0

        For $i = 1 To $aDriveList[0][0]
            $sPNPDeviceID = StringLeft($aDriveList[$i][3], StringLen($aDriveList[$i][3]) - 5)
            If $sPNPDeviceID And StringInStr($sInstanceName, $sPNPDeviceID) Then
                $sDriveTitle = ' Model: ' & $aDriveList[$i][0] & '  |  DeviceID: ' & $aDriveList[$i][1] & '  |  Size: ' & GetByteFormat($aDriveList[$i][2])
                ExitLoop
            EndIf
        Next

        If Not $sPNPDeviceID Then ContinueLoop

        ReDim $aSMART[1][15]; clear array
        ReDim $aSMART[76][15]; set template

        $SSD_Detected = 0
        $n = 0

        For $i = 2 To (UBound($aVendorSpecific) - 1) Step 12
            If ($aVendorSpecific[$i] = 0) Then ContinueLoop

            If StringRegExp($aVendorSpecific[$i], '(17[0-9])') Then
                $SSD_Detected += 1; SSD Attribute Detection
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
                        $aSMART[$n][5] &= 'C (' & Round(($aSMART[$n][5] * 1.8) + 32) & 'F)'
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
        If $Object_Error Then Return _WMI_ShowError(8)

        $n = 0

        $objClass2 = $objWMI.InstancesOf('MSStorageDriver_FailurePredictThresholds')
        $count = $objClass2.Count
        If $Object_Error Then Return _WMI_ShowError(9)
        If Not $count Then Return _WMI_ShowError('MSStorageDriver_FailurePredictThresholds=0')

        For $objItem In $objClass2
            $aVendorSpecific = $objItem.VendorSpecific
            $sInstanceName = $objItem.InstanceName

            If IsArray($aVendorSpecific) And StringInStr($sInstanceName, $sPNPDeviceID) Then
                For $i = 2 To (UBound($aVendorSpecific) - 1) Step 12
                    If $aVendorSpecific[$i] Then
                        $n += 1
                        $aSMART[$n][12] = $aVendorSpecific[$i + 1]
                    EndIf
                Next
                ExitLoop
            EndIf
        Next
        If $Object_Error Then Return _WMI_ShowError(10)

        $objClass2 = $objWMI.InstancesOf('MSStorageDriver_FailurePredictStatus')
        $count = $objClass2.Count
        If $Object_Error Then Return _WMI_ShowError(11)
        If Not $count Then Return _WMI_ShowError('MSStorageDriver_FailurePredictStatus=0')

        For $objItem In $objClass2
            $sInstanceName = $objItem.InstanceName
            If StringInStr($sInstanceName, $sPNPDeviceID) Then
                $sDriveTitle &= '  |  PredictFailure=' & $objItem.PredictFailure
                ExitLoop
            EndIf
        Next
        If $Object_Error Then Return _WMI_ShowError(12)

        ReDim $aSMART[$n + 1][15]

		$DriveCounter += 1																			; Bump to next drive

		;
		; Mods here to convert native array format to 'SMART Mon' array format
		; 	$AllData[][]
		; 	[x][] is drive letter 	= "C:"
		; 	[][1] is model			= "WDC WJ800JD 08MSA1"
		;	[][2] is Size GB/GiB	= "74.5GB/80.0GiB"
		;	[][3] is Free GB/GiB	= "74.5GB/80.0GiB"
		;	[][4] is POH			= "123456"
		;	[][5] is Spin up cycles = "12345"
		;	[][6] is Temp C/F		= "50/120"
		;	[][7] is No of spares	= "12345"

		$AllData[$DriveCounter][1] = $aDriveList[$DriveCounter][0]									; Model
		;$AllData[$DriveCounter][2] = Int($aDriveList[$DriveCounter][2] / (1024 * 1024 * 1024)) & "GB (" & Int($aDriveList[$DriveCounter][2] / (1000 * 1000 * 1000)) & "GiB)" ; Total capacity
		;$AllData[$DriveCounter][3] = Int(DriveSpaceFree($AllData[$DriveCounter][0]) / 1024) & "GB (" & Int(DriveSpaceFree($AllData[$DriveCounter][0]) / 1000) & "GiB)" ; Amount free
		$AllData[$DriveCounter][8] = $objItem.PredictFailure

ConsoleWrite("UBOUND($aSMART, 1) = " & UBOUND($aSMART, 1) & @CRLF)									; This is the no. of SMART fields returned for current drive

		; Loop thru all of the fields in the raw data coz different drives may return different no's of fields
		For $Counter1 = 1 To UBOUND($aSMART, 1) - 1
			If StringLeft($aSMART[$Counter1][14], 12) = "ReallocatedS" Then $AllData[$DriveCounter][2] = $aSMART[$Counter1][13] ; Reallocated sector count
			If $aSMART[$Counter1][14] = "CurrentPendingSectorCount" Then $AllData[$DriveCounter][3] = $aSMART[$Counter1][13] 	; Probational count
			If StringLeft($aSMART[$Counter1][14], 6) = "Uncorr" Then $AllData[$DriveCounter][4] = $aSMART[$Counter1][13] 		; Off-line scan uncorrectable count
			If $aSMART[$Counter1][14] = "PowerOnHours(POH)" Then $AllData[$DriveCounter][5] = $aSMART[$Counter1][13] 			; POH
			If $aSMART[$Counter1][14] = "PowerCycleCount" Then $AllData[$DriveCounter][6] = $aSMART[$Counter1][13] 			    ; No. of spin up cycles
			If $aSMART[$Counter1][14] = "Temperature" Then $AllData[$DriveCounter][7] = $aSMART[$Counter1][5]		  			; Temperature
		Next
    Next

EndFunc

; End of Func _WMI_GetATAPISmartData()

;******************************************

Func GetByteFormat($n_b, $ns_os = 1)

    If Not StringIsDigit($ns_os) Then
        $ns_os = UBound(StringRegExp($ns_os, '(?i)(Bytes)|(KiloBytes)|(MegaBytes)', 3))
    EndIf
    Local $a_ab = StringSplit('Bytes|KB|MB|GB|TB', '|')
    If ($ns_os < 1) Or ($ns_os > $a_ab[0]) Then Return $n_b
    For $i = $ns_os To $a_ab[0]; in @ offset -> div -> abrv -> out
        If ($n_b < 1024) Then Return Round($n_b, 2) & ' ' & $a_ab[$i]
        $n_b /= 1024
    Next

EndFunc		; End of Func GetByteFormat()

;******************************************

Func StringExists($s_string, $i_Chars = 30)

	$s_string = StringStripWS(StringLeft($s_string, $i_Chars), 8)
    If Not StringLen($s_string) Then
        Return SetError(0, 0, 0)
    ElseIf $s_string <> 0 Then
        Return SetError(0, 0, 1)
    Else
        Return SetError(0, 1, 1)
    EndIf

EndFunc		; End of Func StringExists()

;******************************************

Func _WMI_ShowError($_Error)

    If StringIsDigit($_Error) Then
        MsgBox(8240, 'WMI_GetATAPISmartData - Object Error #' & $_Error, $ObjError_Msg & @TAB & @TAB)
    Else
        MsgBox(8240, 'WMI_GetATAPISmartData - Error', $_Error & @TAB & @TAB)
    EndIf

EndFunc		; End of Func _WMI_ShowError()

;******************************************

Func _WMI_ObjErrorReset()

    $ObjError_Msg = 'Unknown Object Error'
    $Object_Error = 0

EndFunc		; End of Func _WMI_ObjErrorReset()

;******************************************

Func _ObjErrorHandler()

    If Not IsObj($oErrorHandler) Then
        MsgBox(8240, 'ObjErrorHandler', 'Critical Error - Exiting', 10)
        Exit
    EndIf
    ;
    If $Object_Error Then
        $oErrorHandler.Clear
        Return
    EndIf
    ;
    $Object_Error = 1
    ;
    Local $AOE1 = $oErrorHandler.ScriptLine
    Local $AOE2 = $oErrorHandler.Number
    Local $AOE3 = $oErrorHandler.Description
    Local $AOE4 = $oErrorHandler.WinDescription
    ;
    $oErrorHandler.Clear
    Local $sMsg = ''
    ;
    If $AOE1 Then $sMsg &= 'Line:' & $AOE1
    If $AOE2 Then $sMsg &= ' (0x' & Hex($AOE2, 8) & ') '
    If $AOE3 Then $sMsg &= $AOE3
    If $AOE4 Then $sMsg &= $AOE4
    ;
    If $sMsg Then $ObjError_Msg = $sMsg

EndFunc		; End of Func _ObjErrorHandler()

;******************************************
