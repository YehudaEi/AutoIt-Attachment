;~ Name: PCInfo 1.0
;~ Author: ToKicoBrothers
;~ 		   tokico.pt@gmail.com
;~ Description: This script gives you information about your PC.

#include <GUIConstants.au3>

$totaldrivespace = Round (DriveSpaceTotal ( "C:/" ) / 1000, 2)
$freedrivespace = Round (DriveSpaceFree ( "C:/" ) / 1000, 2)
$drivespace = $freedrivespace & " GB / " & $totaldrivespace & " GB"
$driveserialno = DriveGetSerial ( "C:/" )
$drivefilesys =  DriveGetFileSystem ("C:/")
$memorystats = MemGetStats ()
$desktopsize = @DesktopWidth & "x" & @DesktopHeight
$ramtotalspace = Round($memorystats[1] / 1000, 1)
$ramavaliablespace = Round($memorystats[2] / 1000, 1)
$ramspace = $ramavaliablespace & "MB / " & $ramtotalspace & "MB"
$pagefiletotalspace = Round($memorystats[3] / 1000, 0)
$pagefileavaliablespace = Round($memorystats[4] / 1000, 0)
$pagefilespace = $pagefileavaliablespace & "MB / " & $pagefiletotalspace & "MB"
$virtualtotal = Round($memorystats[5] * 1000, 0)
$virtualavaliable = Round($memorystats[6] / 1000, 0) & "MB"
$virtualpercentage = $memorystats[6] * 100 / $memorystats[5]

#include <GUIConstants.au3>

#Region ### START Koda GUI section ### Form=C:\Documents and Settings\Utilizador 01.PORTUGAL\Os meus documentos\_António\Programação\AutoIt\Koda Form Designer\Forms\PCInfo 1.0.kxf
$Form1 = GUICreate("PCInfo 1.0", 485, 251, 323, 279)
$Group1 = GUICtrlCreateGroup("Drive", 8, 8, 465, 65)
$Label1 = GUICtrlCreateLabel("Drive Space", 88, 24, 63, 17)
$Input1 = GUICtrlCreateInput($drivespace, 64, 40, 121, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Label2 = GUICtrlCreateLabel("Drive File System", 208, 24, 85, 17)
$Input2 = GUICtrlCreateInput($drivefilesys, 224, 40, 57, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Label3 = GUICtrlCreateLabel("Disk Serial Number", 320, 24, 94, 17)
$Input3 = GUICtrlCreateInput($driveserialno, 320, 40, 89, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Memory", 8, 80, 465, 73)
$Progress1 = GUICtrlCreateProgress(18, 103, 117, 16)
GUICtrlSetData(-1, 25)
GUICtrlSetColor(-1, 0x004E98)
GUICtrlSetCursor ($Progress1, 1)
$Label4 = GUICtrlCreateLabel("Memory Usage: " & $memorystats[0] & "%", 24, 128, 101, 17)
$Label6 = GUICtrlCreateLabel("RAM Space", 165, 96, 62, 17)
$Input4 = GUICtrlCreateInput($ramspace, 147, 121, 105, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Label5 = GUICtrlCreateLabel("Page File", 285, 96, 48, 17)
$Input5 = GUICtrlCreateInput($pagefilespace, 259, 121, 105, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Progress2 = GUICtrlCreateProgress(448, 96, 17, 49, $PBS_VERTICAL)
GUICtrlSetData(-1, 25)
$Label7 = GUICtrlCreateLabel("Virtual Available", 368, 96, 79, 17)
$Input6 = GUICtrlCreateInput( $virtualavaliable ,379 , 121, 57, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group3 = GUICtrlCreateGroup("Computer", 8, 160, 313, 81)
$Label8 = GUICtrlCreateLabel("Desktop Size", 19, 184, 67, 17)
$Input7 = GUICtrlCreateInput($desktopsize, 16, 208, 73, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Label9 = GUICtrlCreateLabel("Operative System", 115, 184, 87, 17)
$Input8 = GUICtrlCreateInput(@OSVersion, 96, 208, 137, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Label10 = GUICtrlCreateLabel("Processor Arch.", 240, 184, 79, 17)
$Input9 = GUICtrlCreateInput(@ProcessorArch, 260, 208, 33, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group4 = GUICtrlCreateGroup("AutoIt", 328, 160, 145, 81)
$Label11 = GUICtrlCreateLabel("Version", 336, 192, 39, 17)
$Input10 = GUICtrlCreateInput(@AutoItVersion, 392, 192, 65, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	GUICtrlSetData ($Progress1, $memorystats[0])
	GUICtrlSetData ($Progress2, $virtualpercentage)
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
WEnd