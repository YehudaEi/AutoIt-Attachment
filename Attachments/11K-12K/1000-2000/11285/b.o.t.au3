#cs ----------------------------------------------------------------------------
   
    Script Version: V1
    Author: XxXGoD
    Created For: myself lol
   
    Script Function: All In 1
   
#ce ----------------------------------------------------------------------------


; All In 1 Bot Start


#include <GUIConstants.au3>

#Region ### START Koda GUI section ### Form=C:\XUnleashedTest\AForm4.kxf
Opt("GUIOnEventMode", 1)
$Form4 = GUICreate("U WAT", 620, 328, 327, 219)
GUISetIcon("")
$GroupBox1 = GUICtrlCreateGroup("", 8, 8, 605, 281)
$TaultUnleashed = GUICtrlCreatePic(@ScriptDir & "\TrainerPic.JPG", 16, 16, 589, 121, BitOR($SS_NOTIFY,$WS_GROUP))
$Label1 = GUICtrlCreateLabel("By XxXGoD", 18, 136, 520, 25, $WS_GROUP)
GUICtrlSetFont(-1, 16, 800, 0, "MS Mincho")
GUICtrlSetColor(-1, 0xFF0000)
$Label2 = GUICtrlCreateLabel("Version: 2.0", 488, 264, 60, 17, $WS_GROUP)
$Label4 = GUICtrlCreateLabel("", 8, 144, 4, 4, $WS_GROUP)
$Label1 = GUICtrlCreateLabel("Eat this.", 16, 176, 370, 17, $WS_GROUP)
GUICtrlSetColor(-1, 0x000080)
$Label3 = GUICtrlCreateLabel("http://www.google.com", 16, 232, 353, 17, $WS_GROUP)
GUICtrlSetColor(-1, 0xFF0000)
$Label2 = GUICtrlCreateLabel("Booa", 16, 216, 408, 17, $WS_GROUP)
GUICtrlSetColor(-1, 0x000080)
$Label4 = GUICtrlCreateLabel("OWNED.", 14, 266, 107, 17, $WS_GROUP)
GUICtrlSetColor(-1, 0x000080)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Button1 = GUICtrlCreateButton("&Start Foot+Combat Pet", 2, 296, 120, 25)
GUICtrlSetOnEvent(-1, "StartFCP")

$Button2 = GUICtrlCreateButton("&Start Mount", 122, 296, 75, 25)
GUICtrlSetOnEvent(-1, "StartM")

$Button3 = GUICtrlCreateButton("&Start Foot", 197, 296, 75, 25)
GUICtrlSetOnEvent(-1, "StartF")

$Button4 = GUICtrlCreateButton("&Auto Pickup", 272, 296, 75, 25)
GUICtrlSetOnEvent(-1, "AutoPickup")

$Button5 = GUICtrlCreateButton("&Mount Healer", 347, 296, 75, 25)
GUICtrlSetOnEvent(-1, "AutoHeal")

$Button6 = GUICtrlCreateButton("&Pet Heal+Pickup", 423, 296, 100, 25)
GUICtrlSetOnEvent(-1, "AutoBoth")

$Button7 = GUICtrlCreateButton("&Close", 545, 296, 75, 25)
GUICtrlSetOnEvent(-1, "Close")

GUISetState(@SW_SHOW)
   
#EndRegion ### END Koda GUI section ###

While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit

    EndSwitch
WEnd




; Automatic Pickup
Func AutoBoth()
   
    While 1
       
; Key Delay Options
Opt("SendKeyDownDelay", 1)
Opt("SendKeyDelay", 1)
; Key Delay Options End

; Main Settings / Constants
$Health = 0XC60000
$CheckHP = 1
$ChiPot = 3
$PetLife = 0x0B10000
$PetCharmOfReturn = 0x191418
$PetHunger = 0xADAB61
$CharacterLifeHeal = 0x9B0100
$CharacterChiHeal = 0x000051
$ChiCharmOfReturn = 0x101010
$LifeCharmOfReturn = 0x101010
; Main Settings / Constants End

; Pet/Mount Life Checker
    $coord = PixelSearch( 176, 100, 178, 105, $PetLife, 1 )
    If @error Then
        Send("{8 down}")
        Sleep("100")
        Send("{8 up}")
        Sleep("100")
    EndIf
; Pet/Mount Life Checker End


; Pet/Mount Hunger Checker
        $coord = PixelSearch( 196, 116, 199, 121, $PetHunger, 1 )
    If @error Then
        Send("{8 down}")
        Sleep("100")
        Send("{8 up}")
        Sleep("100")
    EndIf
; Pet/Mount Hunger Checker End

    ; Automatic Pickup
        For $i = 1 To 99999999999999999999999999999999999999999999999999999999
            Send("s")
            Sleep(1000)
        Next
        ; Automatic Pickup End
WEnd
EndFunc
; Automatic Heal + Pickup End



; Automatic Pickup
Func AutoPickup()
    While 1
        For $i = 1 To 99999999999999999999999999999999999999999999999999999999
            Send("s")
            Sleep(1000)
        Next
WEnd

EndFunc
; Automatic Pickup End






; Automatic Healer
Func AutoHeal()
   
    While 1

; Key Delay Options
Opt("SendKeyDownDelay", 1)
Opt("SendKeyDelay", 1)
; Key Delay Options End




; Main Settings / Constants
$Health = 0XC60000
$CheckHP = 1
$ChiPot = 3
$PetLife = 0x0B10000
$PetCharmOfReturn = 0x191418
$PetHunger = 0xADAB61
$CharacterLifeHeal = 0x9B0100
$CharacterChiHeal = 0x000051
$ChiCharmOfReturn = 0x101010
$LifeCharmOfReturn = 0x101010
; Main Settings / Constants End

; Pet/Mount Life Checker
    $coord = PixelSearch( 176, 100, 178, 105, $PetLife, 1 )
    If @error Then
        Send("{8 down}")
        Sleep("100")
        Send("{8 up}")
        Sleep("100")
    EndIf
; Pet/Mount Life Checker End


; Pet/Mount Hunger Checker
        $coord = PixelSearch( 196, 116, 199, 121, $PetHunger, 1 )
    If @error Then
        Send("{8 down}")
        Sleep("100")
        Send("{8 up}")
        Sleep("100")   
        Send("{8 down}")
        Sleep("100")
        Send("{8 up}")
        Sleep("100")
    EndIf
; Pet/Mount Hunger Checker End
    WEnd
EndFunc
; Automatic Healer End






Func StartF()

While 1
   
   
; Key Delay Options
Opt("SendKeyDownDelay", 1)
Opt("SendKeyDelay", 1)
; Key Delay Options End




; Main Settings / Constants
$Health = 0XC60000
$CheckHP = 1
$ChiPot = 3
$PetLife = 0x0B10000
$PetCharmOfReturn = 0x191418
$PetHunger = 0xADAB61
$CharacterLifeHeal = 0x9B0100
$CharacterChiHeal = 0x000051
$ChiCharmOfReturn = 0x101010
$LifeCharmOfReturn = 0x101010
; Main Settings / Constants End


; Character Life Heal
    $coord = PixelSearch( 180, 46, 185, 53, $CharacterLifeHeal, 1 )
    If @error Then
        Send("{4 down}")
        Sleep("100")
        Send("{4 up}")
        Sleep("100")
    EndIf
; Character Life Heal End.


; Character Chi Heal
    $coord = PixelSearch( 180, 57, 184, 63, $CharacterChiHeal, 1 )
    If @error Then
        Send("{3 down}")
        Sleep("100")
        Send("{3 up}")
        Sleep("100")
    EndIf
; Character Chi Heal End.


; Character Out of Chi Heal
    $coord = PixelSearch( 439, 746, 441, 749, $ChiCharmOfReturn, 1 )
    If Not @error Then
        Send("{7 down}")
        Sleep("100")
        Send("{7 up}")
        Sleep("100")
        Exit
    EndIf
   
; Character Out of Chi Heal End.


; Character Out of Life Heal
    $coord = PixelSearch( 478, 747, 483, 753, $LifeCharmOfReturn, 1 )
    If Not @error Then
        Send("{7 down}")
        Sleep("100")
        Send("{7 up}")
        Sleep("100")
        Exit
    EndIf
   
; Character Out of Life Chi End.




    ; Characters Attack/Pickup
    $coord = PixelSearch( 426, 59, 429, 63, 0X000000, 1 )
    If @error Then
        Send("{v down}")
        Sleep("100")
        Send("{v up}")
        Send("{s down}")
                Sleep("100")
        Send("{s up}")
                Sleep("100")
        Send("{s down}")
                Sleep("100")
        Send("{s up}")
        Sleep("100")
        Send("{a down}")
        Sleep("100")
        Send("{a up}")
        Send("{s down}")
                Sleep("100")
        Send("{s up}")
                Sleep("100")
        Send("{s down}")
                Sleep("100")
        Send("{s up}")
        Sleep("100")
        Send("{a down}")
        Sleep("100")
        Send("{a up}")
        Send("{s down}")
                Sleep("100")
        Send("{s up}")
                Sleep("100")
        Send("{s down}")
                Sleep("100")
        Send("{s up}")
        Sleep("100")
        Send("{a down}")
        Sleep("100")
        Send("{a up}")
        Send("{s down}")
                Sleep("100")
        Send("{s up}")
                Sleep("100")
        Send("{s down}")
                Sleep("100")
        Send("{s up}")
    EndIf
   
    Sleep("1000")
WEnd
; Characters Attack/Pickup End
EndFunc





Func StartFCP()

While 1
   
; Key Delay Options
Opt("SendKeyDownDelay", 1)
Opt("SendKeyDelay", 1)
; Key Delay Options End


; Main Settings / Constants
$Health = 0XC60000
$CheckHP = 1
$ChiPot = 3
$PetLife = 0x0B10000
$PetCharmOfReturn = 0x191418
$PetHunger = 0xADAB61
$CharacterLifeHeal = 0x9B0100
$CharacterChiHeal = 0x000051
$ChiCharmOfReturn = 0x101010
$LifeCharmOfReturn = 0x101010
; Main Settings / Constants End


; Character Life Heal
    $coord = PixelSearch( 180, 46, 185, 53, $CharacterLifeHeal, 1 )
    If @error Then
        Send("{4 down}")
        Sleep("100")
        Send("{4 up}")
        Sleep("100")
    EndIf
; Character Life Heal End.


; Character Chi Heal
    $coord = PixelSearch( 180, 57, 184, 63, $CharacterChiHeal, 1 )
    If @error Then
        Send("{3 down}")
        Sleep("100")
        Send("{3 up}")
        Sleep("100")
    EndIf
; Character Chi Heal End.


; Character Out of Chi Heal
    $coord = PixelSearch( 439, 746, 441, 749, $ChiCharmOfReturn, 1 )
    If Not @error Then
        Send("{7 down}")
        Sleep("100")
        Send("{7 up}")
        Sleep("100")
        Exit
    EndIf
; Character Out of Chi Heal End.


; Character Out of Life Heal
    $coord = PixelSearch( 478, 747, 483, 753, $LifeCharmOfReturn, 1 )
    If Not @error Then
        Send("{7 down}")
        Sleep("100")
        Send("{7 up}")
        Sleep("100")
        Exit
    EndIf
; Character Out of Life Chi End.

   
    $coord = PixelSearch( 176, 100, 178, 105, $PetLife, 1 )
    If @error Then
        Send("{8 down}")
        Sleep("100")
        Send("{8 up}")
        Sleep("100")
    EndIf
; Pet/Mount Life Checker End


; Pet/Mount Hunger Checker
        $coord = PixelSearch( 196, 116, 199, 121, $PetHunger, 1 )
    If @error Then
        Send("{8 down}")
        Sleep("100")
        Send("{8 up}")
        Sleep("100")
    EndIf
; Pet/Mount Hunger Checker End
   
   
; Pet/Mount Out of Heal - Charm of Return
    $coord = PixelSearch( 676, 736, 678, 737, $PetCharmOfReturn, 1 )
    If Not @error Then
        Send("{7 down}")
        Sleep("100")
        Send("{7 up}")
        Sleep("100")
        Exit
    EndIf
   
; Pet/Mount Out of Heal - Charm of Return End


    ; Characters Attack/Pickup
    $coord = PixelSearch( 426, 59, 429, 63, 0X000000, 1 )
    If @error Then
        Send("{v down}")
        Sleep("100")
        Send("{v up}")
        Send("{s down}")
                Sleep("100")
        Send("{s up}")
                Sleep("100")
        Send("{s down}")
                Sleep("100")
        Send("{s up}")
        Sleep("100")
        Send("{a down}")
        Sleep("100")
        Send("{a up}")
        Send("{s down}")
                Sleep("100")
        Send("{s up}")
                Sleep("100")
        Send("{s down}")
                Sleep("100")
        Send("{s up}")
        Sleep("100")
        Send("{a down}")
        Sleep("100")
        Send("{a up}")
        Send("{s down}")
                Sleep("100")
        Send("{s up}")
                Sleep("100")
        Send("{s down}")
                Sleep("100")
        Send("{s up}")
        Sleep("100")
        Send("{a down}")
        Sleep("100")
        Send("{a up}")
        Send("{s down}")
                Sleep("100")
        Send("{s up}")
                Sleep("100")
        Send("{s down}")
                Sleep("100")
        Send("{s up}")
    EndIf

    Sleep("1000")
WEnd
; Characters Attack/Pickup End
EndFunc




Func StartM()


; Key Delay Options
Opt("SendKeyDownDelay", 1)
Opt("SendKeyDelay", 1)
; Key Delay Options End




; Main Settings / Constants
$Health = 0XC60000
$CheckHP = 1
$ChiPot = 3
$PetLife = 0x0B10000
$PetCharmOfReturn = 0x191418
$PetHunger = 0xADAB61
$CharacterLifeHeal = 0x9B0100
$CharacterChiHeal = 0x000051
$ChiCharmOfReturn = 0x101010
$LifeCharmOfReturn = 0x101010
; Main Settings / Constants End



; Pet/Mount Life Checker
While 1
   
    $coord = PixelSearch( 176, 100, 178, 105, $PetLife, 1 )
    If @error Then
        Send("{8 down}")
        Sleep("100")
        Send("{8 up}")
        Sleep("100")
    EndIf
; Pet/Mount Life Checker End


; Pet/Mount Hunger Checker
        $coord = PixelSearch( 196, 116, 199, 121, $PetHunger, 1 )
    If @error Then
        Send("{8 down}")
        Sleep("100")
        Send("{8 up}")
        Sleep("100")
    EndIf
; Pet/Mount Hunger Checker End
   
   
; Pet/Mount Out of Heal - Charm of Return
    $coord = PixelSearch( 676, 736, 678, 737, $PetCharmOfReturn, 1 )
    If Not @error Then
        Send("{7 down}")
        Sleep("100")
        Send("{7 up}")
        Sleep("100")
        Exit
    EndIf
; Pet/Mount Out of Heal - Charm of Return End



    ; Characters Attack/Pickup
    $coord = PixelSearch( 426, 59, 429, 63, 0X000000, 1 )
    If @error Then
            Send("{v down}")
        Sleep("100")
        Send("{v up}")
        Send("{s down}")
                Sleep("100")
        Send("{s up}")
                Sleep("100")
        Send("{s down}")
                Sleep("100")
        Send("{s up}")
        Sleep("100")
        Send("{a down}")
        Sleep("100")
        Send("{a up}")
        Send("{s down}")
                Sleep("100")
        Send("{s up}")
                Sleep("100")
        Send("{s down}")
                Sleep("100")
        Send("{s up}")
        Sleep("100")
        Send("{a down}")
        Sleep("100")
        Send("{a up}")
        Send("{s down}")
                Sleep("100")
        Send("{s up}")
                Sleep("100")
        Send("{s down}")
                Sleep("100")
        Send("{s up}")
        Sleep("100")
        Send("{a down}")
        Sleep("100")
        Send("{a up}")
        Send("{s down}")
                Sleep("100")
        Send("{s up}")
                Sleep("100")
        Send("{s down}")
                Sleep("100")
        Send("{s up}")
    EndIf

    Sleep("1000")
WEnd
; Characters Attack/Pickup End
EndFunc



; Exit Program
Func Close()
    Exit
EndFunc
; Exit Program End
 