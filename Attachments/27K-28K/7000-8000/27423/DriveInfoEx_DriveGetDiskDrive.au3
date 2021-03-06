#include "DriveInfo.au3"
#Include <Array.au3>

GUICreate("_DriveGetDiskDrive", 500, 400)
$LIST = GUICtrlCreateListView("Info|Type", 0, 0, 500, 400)
GUISetState()

Dim $aDiskDrive
_DriveGetDiskDrive($aDiskDrive)
For $i = 1 To $aDiskDrive[0][0]
	GUICtrlCreateListViewItem("Drive "&$i&"|Drive "&$i,$LIST)
	GUICtrlCreateListViewItem("",$LIST)
	GUICtrlCreateListViewItem("Availability|"&_DriveTranslateAvailability($aDiskDrive[$i][0]),$LIST)
	GUICtrlCreateListViewItem("BytesPerSector|"&$aDiskDrive[$i][1],$LIST)
	GUICtrlCreateListViewItem("Capabilities|"&_DriveTranslateCapabilities($aDiskDrive[$i][2]),$LIST)
	GUICtrlCreateListViewItem("CapabilityDescriptions|"&_ArrayToString($aDiskDrive[$i][3],", "),$LIST)
	GUICtrlCreateListViewItem("Caption|"&$aDiskDrive[$i][4],$LIST)
	GUICtrlCreateListViewItem("CompressionMethod|"&$aDiskDrive[$i][5],$LIST)
	GUICtrlCreateListViewItem("ConfigManagerErrorCode|"&_DriveTranslateConfigManagerErrorCode($aDiskDrive[$i][6]),$LIST)
	GUICtrlCreateListViewItem("ConfigManagerUserConfig|"&_DriveTranslateConfigManagerUserConfig($aDiskDrive[$i][7]),$LIST)
	GUICtrlCreateListViewItem("CreationClassName|"&$aDiskDrive[$i][8],$LIST)
	GUICtrlCreateListViewItem("DefaultBlockSize|"&$aDiskDrive[$i][9],$LIST)
	GUICtrlCreateListViewItem("Description|"&$aDiskDrive[$i][10],$LIST)
	GUICtrlCreateListViewItem("DeviceID|"&$aDiskDrive[$i][11],$LIST)
	GUICtrlCreateListViewItem("ErrorCleared|"&$aDiskDrive[$i][12],$LIST)
	GUICtrlCreateListViewItem("ErrorDescription|"&$aDiskDrive[$i][13],$LIST)
	GUICtrlCreateListViewItem("ErrorMethodology|"&$aDiskDrive[$i][14],$LIST)
	GUICtrlCreateListViewItem("Index|"&$aDiskDrive[$i][15],$LIST)
	GUICtrlCreateListViewItem("InstallDate|"&$aDiskDrive[$i][16],$LIST)
	GUICtrlCreateListViewItem("InterfaceType|"&$aDiskDrive[$i][17],$LIST)
	GUICtrlCreateListViewItem("LastErrorCode|"&$aDiskDrive[$i][18],$LIST)
	GUICtrlCreateListViewItem("Manufacturer|"&$aDiskDrive[$i][19],$LIST)
	GUICtrlCreateListViewItem("MaxBlockSize|"&$aDiskDrive[$i][20],$LIST)
	GUICtrlCreateListViewItem("MaxMediaSize|"&$aDiskDrive[$i][21],$LIST)
	GUICtrlCreateListViewItem("MediaLoaded|"&_DriveTranslateMediaLoaded($aDiskDrive[$i][22]),$LIST)
	GUICtrlCreateListViewItem("MediaType|"&$aDiskDrive[$i][23],$LIST)
	GUICtrlCreateListViewItem("MinBlockSize|"&$aDiskDrive[$i][24],$LIST)
	GUICtrlCreateListViewItem("Model|"&$aDiskDrive[$i][25],$LIST)
	GUICtrlCreateListViewItem("Name|"&$aDiskDrive[$i][26],$LIST)
	GUICtrlCreateListViewItem("NeedsCleaning|"&$aDiskDrive[$i][27],$LIST)
	GUICtrlCreateListViewItem("NumberOfMediaSupported|"&$aDiskDrive[$i][28],$LIST)
	GUICtrlCreateListViewItem("Partitions|"&$aDiskDrive[$i][29],$LIST)
	GUICtrlCreateListViewItem("PNPDeviceID|"&$aDiskDrive[$i][30],$LIST)
	GUICtrlCreateListViewItem("PowerManagementCapabilities|"&_DriveTranslatePowerManagementCapabilities($aDiskDrive[$i][31]),$LIST)
	GUICtrlCreateListViewItem("PowerManagementSupported|"&$aDiskDrive[$i][32],$LIST)
	GUICtrlCreateListViewItem("SCSIBus|"&$aDiskDrive[$i][33],$LIST)
	GUICtrlCreateListViewItem("SCSILogicalUnit|"&$aDiskDrive[$i][34],$LIST)
	GUICtrlCreateListViewItem("SCSIPort|"&$aDiskDrive[$i][35],$LIST)
	GUICtrlCreateListViewItem("SCSITargetId|"&$aDiskDrive[$i][36],$LIST)
	GUICtrlCreateListViewItem("SectorsPerTrack|"&$aDiskDrive[$i][37],$LIST)
	GUICtrlCreateListViewItem("Signature|"&$aDiskDrive[$i][38],$LIST)
	GUICtrlCreateListViewItem("Size|"&$aDiskDrive[$i][39],$LIST)
	GUICtrlCreateListViewItem("Status|"&$aDiskDrive[$i][40],$LIST)
	GUICtrlCreateListViewItem("StatusInfo|"&_DriveTranslateStatusInfo($aDiskDrive[$i][41]),$LIST)
	GUICtrlCreateListViewItem("SystemCreationClassName|"&$aDiskDrive[$i][42],$LIST)
	GUICtrlCreateListViewItem("SystemName|"&$aDiskDrive[$i][43],$LIST)
	GUICtrlCreateListViewItem("TotalCylinders|"&$aDiskDrive[$i][44],$LIST)
	GUICtrlCreateListViewItem("TotalHeads|"&$aDiskDrive[$i][45],$LIST)
	GUICtrlCreateListViewItem("TotalSectors|"&$aDiskDrive[$i][46],$LIST)
	GUICtrlCreateListViewItem("TotalTracks|"&$aDiskDrive[$i][47],$LIST)
	GUICtrlCreateListViewItem("TracksPerCylinder|"&$aDiskDrive[$i][48],$LIST)
	GUICtrlCreateListViewItem("",$LIST)
Next

While GUIGetMsg() <> -3
	Sleep(10)
WEnd
