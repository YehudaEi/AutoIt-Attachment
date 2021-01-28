#include "DriveInfo.au3"
#Include <Array.au3>

GUICreate("_DriveGetFloppyDrive", 500, 400)
$LIST = GUICtrlCreateListView("Info|Type", 0, 0, 500, 400)
GUISetState()

Dim $FloppyDrive[1][1]
_DriveGetFloppyDrive($FloppyDrive)
For $i = 1 To $FloppyDrive[0][0]
	GUICtrlCreateListViewItem("Drive "&$i&"|Drive "&$i,$LIST)
	GUICtrlCreateListViewItem("",$LIST)
	GUICtrlCreateListViewItem("Availability|"&_DriveTranslateAvailability($FloppyDrive[$i][0]),$LIST)
	GUICtrlCreateListViewItem("Capabilities|"&_DriveTranslateCapabilities($FloppyDrive[$i][1]),$LIST)
	GUICtrlCreateListViewItem("CapabilityDescriptions|"&_ArrayToString($FloppyDrive[$i][2]),$LIST)
	GUICtrlCreateListViewItem("Caption|"&$FloppyDrive[$i][3],$LIST)
	GUICtrlCreateListViewItem("CompressionMethod|"&$FloppyDrive[$i][4],$LIST)
	GUICtrlCreateListViewItem("ConfigManagerErrorCode|"&_DriveTranslateConfigManagerErrorCode($FloppyDrive[$i][5]),$LIST)
	GUICtrlCreateListViewItem("ConfigManagerUserConfig|"&_DriveTranslateConfigManagerUserConfig($FloppyDrive[$i][6]),$LIST)
	GUICtrlCreateListViewItem("CreationClassName|"&$FloppyDrive[$i][7],$LIST)
	GUICtrlCreateListViewItem("DefaultBlockSize|"&$FloppyDrive[$i][8],$LIST)
	GUICtrlCreateListViewItem("Description|"&$FloppyDrive[$i][9],$LIST)
	GUICtrlCreateListViewItem("DeviceID|"&$FloppyDrive[$i][10],$LIST)
	GUICtrlCreateListViewItem("ErrorCleared|"&$FloppyDrive[$i][11],$LIST)
	GUICtrlCreateListViewItem("ErrorDescription|"&$FloppyDrive[$i][12],$LIST)
	GUICtrlCreateListViewItem("ErrorMethodology|"&$FloppyDrive[$i][13],$LIST)
	GUICtrlCreateListViewItem("InstallDate|"&$FloppyDrive[$i][14],$LIST)
	GUICtrlCreateListViewItem("LastErrorCode|"&$FloppyDrive[$i][15],$LIST)
	GUICtrlCreateListViewItem("Manufacturer|"&$FloppyDrive[$i][16],$LIST)
	GUICtrlCreateListViewItem("MaxBlockSize|"&$FloppyDrive[$i][17],$LIST)
	GUICtrlCreateListViewItem("MaxMediaSize|"&$FloppyDrive[$i][18],$LIST)
	GUICtrlCreateListViewItem("MinBlockSize|"&$FloppyDrive[$i][19],$LIST)
	GUICtrlCreateListViewItem("Name|"&$FloppyDrive[$i][20],$LIST)
	GUICtrlCreateListViewItem("NeedsCleaning|"&$FloppyDrive[$i][21],$LIST)
	GUICtrlCreateListViewItem("NumberOfMediaSupported|"&$FloppyDrive[$i][22],$LIST)
	GUICtrlCreateListViewItem("PNPDeviceID|"&$FloppyDrive[$i][23],$LIST)
	GUICtrlCreateListViewItem("PowerManagementCapabilities|"&_DriveTranslatePowerManagementCapabilities($FloppyDrive[$i][24]),$LIST)
	GUICtrlCreateListViewItem("PowerManagementSupported|"&$FloppyDrive[$i][25],$LIST)
	GUICtrlCreateListViewItem("Status|"&$FloppyDrive[$i][26],$LIST)
	GUICtrlCreateListViewItem("StatusInfo|"&_DriveTranslateStatusInfo($FloppyDrive[$i][27]),$LIST)
	GUICtrlCreateListViewItem("SystemCreationClassName|"&$FloppyDrive[$i][28],$LIST)
	GUICtrlCreateListViewItem("SystemName|"&$FloppyDrive[$i][29],$LIST)
	GUICtrlCreateListViewItem("",$LIST)
Next

While GUIGetMsg() <> -3
	Sleep(10)
WEnd
