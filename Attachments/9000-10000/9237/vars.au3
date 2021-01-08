

; Bot Version
Global $iVersion = "0.09"
Global $Event    = 0
Global $Paused
Global $MyBot_Running = 0
Global $sLastStatus = "Idle."
Global $MyBotStatus = 0
Global $BotCycles = 1
Global $BotTimer = 0
Global $clientWidth = 1280
Global $clientHeight = 1024

;;
;; Database of Locations:
;;
Global $ApproachLoc[2]
Global $TargetLoc[2]
Global $FirstOverview[2]
Global $SecondOverview[2]
Global $FirstLaserIcon[2]
Global $SecondLaserIcon[2]
Global $ThiredLaserIcon[2]
Global $DistandM[2]
Global $Belt1[2]
Global $Belt1Menu1[2]
Global $MainMenu1[2]
Global $MainMenu4[2]
Global $Station1[2]
Global $Station1Menu1[2]
Global $Station1Menu3[2]
$ApproachLoc[0] = 1083
$ApproachLoc[1] = 123
$TargetLoc[0] = 1183
$TargetLoc[1] = 123
$FirstOverview[0] = 1250
$FirstOverview[1] = 214
$SecondOverview[0] = 1257
$SecondOverview[1] = 232
; Color 55675A
$FirstLaserIcon[0] = 1022
$FirstLaserIcon[1] = 55
$SecondLaserIcon[0]= 1022
$SecondLaserIcon[1]= 90
$ThiredLaserIcon[0]= 1022
$ThiredLaserIcon[1]= 85
$DistandM[0] = 1185
$DistandM[1] = 80
$MainMenu1[0] = 115
$MainMenu1[1] = 84
$MainMenu4[0] = 115
$MainMenu4[1] = 130
$Belt1[0] = 300
$Belt1[1] = 70
$Belt1Menu1[0] = 450
$Belt1Menu1[1] = 70
$Station1[0] = 250
$Station1[1] = 115
$Station1Menu1[0] = 540
$Station1Menu1[1] = 115
$Station1Menu3[0] = 540
$Station1Menu3[1] = 150

;;
;; Database of PixleColors
;;
$Black = 0x000000
$Grey  = 0xC0C0C0
$White = 0xFFFFFF
$MenuColor = 0xA0A0A0

; Runtime Total
Global $iTotalTime    = 0
; Set the Speed at which the mouse will move
Global $MouseSpeed     = 10
; Number of Lasers to use
Global $NumLaser       = 1

;; 
;; GUI Variables
;; 
Global $MyGUI
Global $MyGUI_StartButton
Global $MyGUI_StopButton
Global $MyGUI_HomeButton
Global $MyGUI_BeltButton
Global $MyGUI_LasersLable
Global $MyGUI_LasersInput
Global $MyGUI_LasersSlider
Global $MyGUI_BeltLable
Global $MyGUI_BeltInput
Global $MyGUI_StationLable
Global $MyGUI_StationInput
Global $MyGUI_MouseLable
Global $MyGUI_MouseInput
Global $MyGUI_StatusLabel
Global $MyGUI_StatusLine

