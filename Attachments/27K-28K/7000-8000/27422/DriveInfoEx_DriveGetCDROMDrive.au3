#include "DriveInfo.au3"
#Include <Array.au3>

GUICreate("_DriveGetCDROMDrive", 500, 400)
$LIST = GUICtrlCreateListView("Info|Type", 0, 0, 500, 400)
GUISetState()

Dim $CDDRIVES[1][1]
_DriveGetCDROMDrive($CDDRIVES)
For $i = 1 To $CDDRIVES[0][0]
	GUICtrlCreateListViewItem("Drive "&$i&"|Drive "&$i,$LIST)
	GUICtrlCreateListViewItem("",$LIST)
	GUICtrlCreateListViewItem("Availability|"&_DriveTranslateAvailability($CDDRIVES[$i][0]),$LIST)
	GUICtrlCreateListViewItem("Capabilities|"&_DriveTranslateCapabilities($CDDRIVES[$i][1]),$LIST)
	GUICtrlCreateListViewItem("CapabilityDescriptions|"&_ArrayToString($CDDRIVES[$i][2],", "),$LIST)
	GUICtrlCreateListViewItem("Caption|"&$CDDRIVES[$i][3],$LIST)
	GUICtrlCreateListViewItem("CompressionMethod|"&$CDDRIVES[$i][4],$LIST)
	GUICtrlCreateListViewItem("ConfigManagerErrorCode|"&_DriveTranslateConfigManagerErrorCode($CDDRIVES[$i][5]),$LIST)
	GUICtrlCreateListViewItem("ConfigManagerUserConfig|"&_DriveTranslateConfigManagerUserConfig($CDDRIVES[$i][6]),$LIST)
	GUICtrlCreateListViewItem("CreationClassName|"&$CDDRIVES[$i][7],$LIST)
	GUICtrlCreateListViewItem("DefaultBlockSize|"&$CDDRIVES[$i][8],$LIST)
	GUICtrlCreateListViewItem("Description|"&$CDDRIVES[$i][9],$LIST)
	GUICtrlCreateListViewItem("DeviceID|"&$CDDRIVES[$i][10],$LIST)
	GUICtrlCreateListViewItem("Drive|"&$CDDRIVES[$i][11],$LIST)
	GUICtrlCreateListViewItem("DriveIntegrity|"&$CDDRIVES[$i][12],$LIST)
	GUICtrlCreateListViewItem("ErrorCleared|"&$CDDRIVES[$i][13],$LIST)
	GUICtrlCreateListViewItem("ErrorDescription|"&$CDDRIVES[$i][14],$LIST)
	GUICtrlCreateListViewItem("ErrorMethodology|"&$CDDRIVES[$i][15],$LIST)
	GUICtrlCreateListViewItem("FileSystemFlags|"&$CDDRIVES[$i][16],$LIST)
	GUICtrlCreateListViewItem("FileSystemFlagsEx|"&$CDDRIVES[$i][17],$LIST)
	GUICtrlCreateListViewItem("Id|"&$CDDRIVES[$i][18],$LIST)
	GUICtrlCreateListViewItem("InstallDate|"&$CDDRIVES[$i][19],$LIST)
	GUICtrlCreateListViewItem("LastErrorCode|"&$CDDRIVES[$i][20],$LIST)
	GUICtrlCreateListViewItem("Manufacturer|"&$CDDRIVES[$i][21],$LIST)
	GUICtrlCreateListViewItem("MaxBlockSize|"&$CDDRIVES[$i][22],$LIST)
	GUICtrlCreateListViewItem("MaximumComponentLength|"&$CDDRIVES[$i][23],$LIST)
	GUICtrlCreateListViewItem("MaxMediaSize|"&$CDDRIVES[$i][24],$LIST)
	GUICtrlCreateListViewItem("MediaLoaded|"&_DriveTranslateMediaLoaded($CDDRIVES[$i][25]),$LIST)
	GUICtrlCreateListViewItem("MediaType|"&$CDDRIVES[$i][26],$LIST)
	GUICtrlCreateListViewItem("MfrAssignedRevisionLevel|"&$CDDRIVES[$i][27],$LIST)
	GUICtrlCreateListViewItem("MinBlockSize|"&$CDDRIVES[$i][28],$LIST)
	GUICtrlCreateListViewItem("Name|"&$CDDRIVES[$i][29],$LIST)
	GUICtrlCreateListViewItem("NeedsCleaning|"&$CDDRIVES[$i][30],$LIST)
	GUICtrlCreateListViewItem("NumberOfMediaSupported|"&$CDDRIVES[$i][31],$LIST)
	GUICtrlCreateListViewItem("PNPDeviceID|"&$CDDRIVES[$i][32],$LIST)
	GUICtrlCreateListViewItem("PowerManagementCapabilities|"&_DriveTranslatePowerManagementCapabilities($CDDRIVES[$i][33]),$LIST)
	GUICtrlCreateListViewItem("PowerManagementSupported|"&$CDDRIVES[$i][34],$LIST)
	GUICtrlCreateListViewItem("RevisionLevel|"&$CDDRIVES[$i][35],$LIST)
	GUICtrlCreateListViewItem("SCSIBus|"&$CDDRIVES[$i][36],$LIST)
	GUICtrlCreateListViewItem("SCSILogicalUnit|"&$CDDRIVES[$i][37],$LIST)
	GUICtrlCreateListViewItem("SCSIPort|"&$CDDRIVES[$i][38],$LIST)
	GUICtrlCreateListViewItem("SCSITargetId|"&$CDDRIVES[$i][39],$LIST)
	GUICtrlCreateListViewItem("Size|"&$CDDRIVES[$i][40],$LIST)
	GUICtrlCreateListViewItem("Status|"&$CDDRIVES[$i][41],$LIST)
	GUICtrlCreateListViewItem("StatusInfo|"&_DriveTranslateStatusInfo($CDDRIVES[$i][42]),$LIST)
	GUICtrlCreateListViewItem("SystemCreationClassName|"&$CDDRIVES[$i][43],$LIST)
	GUICtrlCreateListViewItem("SystemName|"&$CDDRIVES[$i][44],$LIST)
	GUICtrlCreateListViewItem("TransferRate|"&$CDDRIVES[$i][45],$LIST)
	GUICtrlCreateListViewItem("VolumeName|"&$CDDRIVES[$i][46],$LIST)
	GUICtrlCreateListViewItem("VolumeSerialNumber|"&$CDDRIVES[$i][47],$LIST)
	GUICtrlCreateListViewItem("",$LIST)
Next

While GUIGetMsg() <> -3
	Sleep(10)
WEnd
