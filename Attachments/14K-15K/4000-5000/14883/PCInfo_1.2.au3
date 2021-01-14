;~ Name: PCInfo 1.2
;~ Author: ToKicoBrothers
;~ 		   tokico.pt@gmail.com
;~ Description: This script gives you information about your PC.

#include <GUIConstants.au3>
#include <CompInfo.au3>

Dim $aProcessorInfo, $aSoundCardInfo, $aVideoInfo, $aNetworkInfo, $aVideoCardInfo

$totaldrivespace = Round (DriveSpaceTotal ( "C:/" ) / 1024, 2)
$freedrivespace = Round (DriveSpaceFree ( "C:/" ) / 1024, 2)
$drivespace = $freedrivespace & " GB / " & $totaldrivespace & " GB"
$driveserialno = DriveGetSerial ( "C:/" )
$drivefilesys =  DriveGetFileSystem ("C:/")
$memorystats = MemGetStats ()
$desktopsize = @DesktopWidth & "x" & @DesktopHeight
$ramtotalspace = Round($memorystats[1] / 1024, 1)
$ramavaliablespace = Round($memorystats[2] / 1024, 1)
$ramspace = $ramavaliablespace & "MB / " & $ramtotalspace & "MB"
$pagefiletotalspace = Round($memorystats[3] / 1024, 0)
$pagefileavaliablespace = Round($memorystats[4] / 1024, 0)
$pagefilespace = $pagefileavaliablespace & "MB / " & $pagefiletotalspace & "MB"
$virtualavaliable = Round($memorystats[6] / 1024, 0)
$processorspeed = RegRead("HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\CentralProcessor\0", "~MHz") & " MHz"
$processorname = RegRead("HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\CentralProcessor\0", "processornamestring")
$ieversion = RegRead("HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer", "Version")
$processorvendor = RegRead("HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\CentralProcessor\0", "VendorIdentifier")
_ComputerGetProcessors($aProcessorInfo)
$processorid = $aProcessorInfo[1][38]
_ComputerGetSoundCards($aSoundCardInfo)
$soundcard = $aSoundCardInfo[1][0]
_ComputerGetVideoCards($aVideoCardInfo)
$videocard = $aVideoCardInfo[1][0]
_ComputerGetNetworkCards($aNetworkInfo)
$networkcard = $aNetworkInfo[1][0]

#Region ### START Koda GUI section ###
$Form1_1 = GUICreate("PCInfo 1.2", 482, 425, 276, 134)
$disk = GUICtrlCreateGroup("Drive", 8, 8, 465, 65)
$Label1 = GUICtrlCreateLabel("Drive Space", 88, 24, 63, 17)
$Input1 = GUICtrlCreateInput($drivespace, 64, 40, 121, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Label2 = GUICtrlCreateLabel("Drive File System", 208, 24, 85, 17)
$Input2 = GUICtrlCreateInput($drivefilesys, 224, 40, 57, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Label3 = GUICtrlCreateLabel("Drive Serial Number", 320, 24, 94, 17)
$Input3 = GUICtrlCreateInput($driveserialno, 320, 40, 89, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
GUICtrlCreateGroup("", -99, -99, 1, 1)
$memory = GUICtrlCreateGroup("Memory", 8, 80, 465, 81)
$Progress1 = GUICtrlCreateProgress(18, 103, 117, 16)
GUICtrlSetData(-1, 25)
$Label4 = GUICtrlCreateLabel("Memory Usage: " & $memorystats[0] & " %", 24, 128, 101, 17)
$Label6 = GUICtrlCreateLabel("RAM Space", 181, 104, 62, 17)
$Input4 = GUICtrlCreateInput($ramspace, 155, 129, 105, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Label5 = GUICtrlCreateLabel("Page File", 301, 104, 48, 17)
$Input5 = GUICtrlCreateInput($pagefilespace, 275, 129, 105, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Label7 = GUICtrlCreateLabel("Virtual Avaliable", 384, 104, 79, 17)
$Input6 = GUICtrlCreateInput($virtualavaliable, 395, 129, 57, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
GUICtrlCreateGroup("", -99, -99, 1, 1)
$computer = GUICtrlCreateGroup("Computer", 8, 168, 313, 169)
$Label8 = GUICtrlCreateLabel("Desktop Size", 19, 192, 67, 17)
$Input7 = GUICtrlCreateInput($desktopsize, 16, 208, 73, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Label9 = GUICtrlCreateLabel("Operative System", 115, 192, 87, 17)
$Input8 = GUICtrlCreateInput(@OSVersion, 96, 208, 137, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Label10 = GUICtrlCreateLabel("Processor Arch.", 240, 192, 79, 17)
$Input9 = GUICtrlCreateInput(@ProcessorArch, 260, 208, 33, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Label13 = GUICtrlCreateLabel("Processor Speed", 227, 240, 85, 17)
$Input12 = GUICtrlCreateInput($processorspeed, 232, 256, 73, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Label14 = GUICtrlCreateLabel("Processor Vendor", 35, 288, 88, 17)
$Input13 = GUICtrlCreateInput($processorvendor, 24, 304, 113, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Input14 = GUICtrlCreateInput($processorname, 16, 256, 201, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Label15 = GUICtrlCreateLabel("Processor Name", 67, 240, 82, 17)
$Label19 = GUICtrlCreateLabel("Processor Unique ID", 192, 288, 102, 17)
$Input18 = GUICtrlCreateInput($processorid, 188, 304, 113, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
GUICtrlCreateGroup("", -99, -99, 1, 1)
$versions = GUICtrlCreateGroup("Versions", 328, 168, 145, 81)
$Label11 = GUICtrlCreateLabel("AutoIt", 336, 192, 32, 17)
$Input10 = GUICtrlCreateInput(@AutoItVersion, 392, 189, 65, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Label12 = GUICtrlCreateLabel("IE", 336, 216, 14, 17)
$Input11 = GUICtrlCreateInput($ieversion, 360, 213, 97, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group1 = GUICtrlCreateGroup("Hardware", 328, 256, 145, 161)
$Input15 = GUICtrlCreateInput($soundcard, 336, 293, 129, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Input16 = GUICtrlCreateInput($videocard, 336, 341, 129, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Input17 = GUICtrlCreateInput($networkcard, 336, 389, 129, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Label16 = GUICtrlCreateLabel("Sound Card", 376, 272, 60, 17)
$Label17 = GUICtrlCreateLabel("Video Card", 376, 320, 56, 17)
$Label18 = GUICtrlCreateLabel("Network Card", 368, 368, 69, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Button1 = GUICtrlCreateButton("Task Manager", 176, 344, 147, 33, 0)
$Button2 = GUICtrlCreateButton("System Info", 176, 385, 147, 33, 0)
$Label20 = GUICtrlCreateLabel("PCInfo 1.2", 16, 344, 138, 37)
GUICtrlSetFont(-1, 18, 400, 0, "Arial Black")
$Label21 = GUICtrlCreateLabel("by ToKicoBrothers", 16, 384, 149, 29)
GUICtrlSetFont(-1, 16, 400, 2, "Arial Narrow")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	GUICtrlSetData ($Progress1, $memorystats[0])
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
			Run("taskmgr.exe")
		Case $Button2
            Run("cmd /k systeminfo") ;Thanks Manadar! :)
	EndSwitch
WEnd