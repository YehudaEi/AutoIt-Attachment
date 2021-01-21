;; ----------------------------------------------------------------------------
;;
;; AutoIt Version: 3.2.11.1
;; Author: SixWingedFreak
;;
;; Script Function:
;;	AutoOre v9.0b
;;	1600x900 Window mode
;;
;; ----------------------------------------------------------------------------
;; ----------------------------------------------------------------------------
;; Variables
;; ----------------------------------------------------------------------------
Global $Version = "9.0b"
Global $Paused
Global $FirstRun = 1
Global $CheckWait = 5
Global $EVELocation = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\EVE", "InstallLocation") & "\"
Global $LogOn
Global $EVEPass
Global $EVEPassSave
Global $EVEWait
Global $LogOff
Global $LogOffDT
Global $LogOffHH
Global $LogOffMM
Global $MouseSpeed
Global $Lasers
Global $Targets
Global $Drones
Global $Bookmark
Global $BookmarkWait
Global $LockWait
Global $DockTime
Global $MiningCheck
Global $MiningTimer
Global $MiningTime
Global $RepeatAmount
Global $RepeatCounter
;; ----------------------------------------------------------------------------
;; Coordinates
;; ----------------------------------------------------------------------------
Global $ClientCenter[2]
Global $EnterGame[2]
Global $Undock[2]
Global $Triangle[2]
Global $PeoplePlacesOpen[2]
Global $PeoplePlacesClose[2]
Global $Bookmark0[2]
Global $Bookmark1[2]
Global $Bookmark2[2]
Global $Bookmark3[2]
Global $Bookmark4[2]
Global $Bookmark5[2]
Global $Bookmark0Dock1[2]
Global $Bookmark0Dock2[2]
Global $Bookmark1Warp[2]
Global $Bookmark2Warp[2]
Global $Bookmark3Warp[2]
Global $Bookmark4Warp[2]
Global $Bookmark5Warp[2]
Global $WarpCheck[2]
Global $DroneBay[2]
Global $DroneSpace[2]
Global $LaunchDrones[2]
Global $ReturnDrones[2]
Global $OverviewItem1[2]
Global $OverviewItem2[2]
Global $OverviewItem3[2]
Global $OverviewItem4[2]
Global $OverviewItem5[2]
Global $OverviewItem6[2]
Global $Target1[2]
Global $Target2[2]
Global $Target3[2]
Global $Target4[2]
Global $Target5[2]
Global $Target6[2]
Global $LaserIcon1[2]
Global $LaserIcon2[2]
Global $LaserIcon3[2]
Global $LaserIcon4[2]
Global $LaserIcon5[2]
Global $LaserIcon6[2]
Global $CargoBay[2]
Global $CargoBayItem1[2]
Global $StationPanel[2]
$ClientCenter[0] = 800
$ClientCenter[1] = 450
$EnterGame[0] = 1538
$EnterGame[1] = 802
$Undock[0] = 17
$Undock[1] = 868
$Triangle[0] = 51
$Triangle[1] = 42
$PeoplePlacesOpen[0] = 16
$PeoplePlacesOpen[1] = 173
$PeoplePlacesClose[0] = 527
$PeoplePlacesClose[1] = 9
$Bookmark0[0] = 82
$Bookmark0[1] = 136
$Bookmark1[0] = 82
$Bookmark1[1] = 155
$Bookmark2[0] = 82
$Bookmark2[1] = 174
$Bookmark3[0] = 82
$Bookmark3[1] = 193
$Bookmark4[0] = 82
$Bookmark4[1] = 212
$Bookmark5[0] = 82
$Bookmark5[1] = 231
$Bookmark0Dock1[0] = 106
$Bookmark0Dock1[1] = 179
$Bookmark0Dock2[0] = 106
$Bookmark0Dock2[1] = 164
$Bookmark1Warp[0] = 106
$Bookmark1Warp[1] = 165
$Bookmark2Warp[0] = 106
$Bookmark2Warp[1] = 184
$Bookmark3Warp[0] = 106
$Bookmark3Warp[1] = 203
$Bookmark4Warp[0] = 106
$Bookmark4Warp[1] = 222
$Bookmark5Warp[0] = 106
$Bookmark5Warp[1] = 241
$WarpCheck[0] = 740
$WarpCheck[1] = 663
$DroneBay[0] = 1343
$DroneBay[1] = 755
$DroneSpace[0] = 1343
$DroneSpace[1] = 774
$LaunchDrones[0] = 1367
$LaunchDrones[1] = 782
$ReturnDrones[0] = 1367
$ReturnDrones[1] = 831
$OverviewItem1[0] = 1347
$OverviewItem1[1] = 182
$OverviewItem2[0] = 1347
$OverviewItem2[1] = 201
$OverviewItem3[0] = 1347
$OverviewItem3[1] = 220
$OverviewItem4[0] = 1347
$OverviewItem4[1] = 239
$OverviewItem5[0] = 1347
$OverviewItem5[1] = 258
$OverviewItem6[0] = 1347
$OverviewItem6[1] = 277
$Target1[0] = 1231
$Target1[1] = 67
$Target2[0] = 1133
$Target2[1] = 67
$Target3[0] = 1035
$Target3[1] = 67
$Target4[0] = 937
$Target4[1] = 67
$Target5[0] = 839
$Target5[1] = 67
$Target6[0] = 741
$Target6[1] = 67
$LaserIcon1[0] = 1277
$LaserIcon1[1] = 48
$LaserIcon2[0] = 1179
$LaserIcon2[1] = 48
$LaserIcon3[0] = 1081
$LaserIcon3[1] = 48
$LaserIcon4[0] = 983
$LaserIcon4[1] = 48
$LaserIcon5[0] = 885
$LaserIcon5[1] = 48
$LaserIcon6[0] = 787
$LaserIcon6[1] = 48
$CargoBay[0] = 47
$CargoBay[1] = 427
$CargoBayItem1[0] = 87
$CargoBayItem1[1] = 468
$StationPanel[0] = 1347
$StationPanel[1] = 471
;; ----------------------------------------------------------------------------
;; Pixel Colors
;; ----------------------------------------------------------------------------
$EnterGameColor = "3F3F3F"
$UndockColor = "50DF20"
$TriangleColor = "E6E6E6"
$WarpCheckColor = "B71B00"
$DroneColor = "96F2FF"
$MiningCheckColor = "000000"