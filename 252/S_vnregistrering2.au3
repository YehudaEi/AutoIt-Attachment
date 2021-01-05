#include <C:\Programfiler\AutoIt30\Include\GUIConstants.au3>

Opt("GUICoordMode", 1)
GUICreate("Søvnregistrering", 900,700,)
GUISetBkColor(0x00FFFFE0)
; Create the controls
GUICtrlCreateLabel("Natt til ", 500,11,35 ,24,0x0002)
$date = GUICtrlCreateDate ("Dato1", 550,5, 150,24,)
$Registrert = GUICtrlCreateButton("&Registrert", 230, 650, 120, 40)
; start creation of a tab control
GUICtrlCreateTab ( 20, 20, 500, 200)
GUICtrlSetFont(-1,9,700)			; to display tab names in bold
; define first tab name
$tab0=GUICtrlCreateTabitem ("La meg..")
;La meg-knapper:
$button_sl220 = GUICtrlCreateButton( "22.00", 55, 50, 60, 24, 0x0001)
$button_sl221 = GUICtrlCreateButton( "22.10", 70, 75, 45, 24, 0x0001)
$button_sl222 = GUICtrlCreateButton( "22.20", 70, 100, 45, 24, 0x0001)
$button_sl223 = GUICtrlCreateButton("22.30", 70, 125, 45, 24, 0x0001)
$button_sl224 = GUICtrlCreateButton("22.40", 70, 150, 45, 24, 0x0001)
$button_sl225 = GUICtrlCreateButton("22.50", 70, 175, 45, 24, 0x0001)

$button_sl230 = GUICtrlCreateButton("23.00", 105, 50, 60, 24, 0x0001)
$button_sl231 = GUICtrlCreateButton("23.10", 120, 75, 45, 24, 0x0001)
$button_sl232 = GUICtrlCreateButton("23.20", 120, 100, 45, 24, 0x0001)
$button_sl233 = GUICtrlCreateButton("23.30", 120, 125, 45, 24, 0x0001)
$button_sl234 = GUICtrlCreateButton("23.40", 120, 150, 45, 24, 0x0001)
$button_sl235 = GUICtrlCreateButton("23.50", 120, 175, 45, 24, 0x0001)

$button_sl000 = GUICtrlCreateButton("00.00", 175, 50, 60, 24, 0x0001)
$button_sl001 = GUICtrlCreateButton("00.10", 175, 75, 45, 24, 0x0001)
$button_sl002 = GUICtrlCreateButton("00.20", 175, 100, 45, 24, 0x0001)
$button_sl003 = GUICtrlCreateButton("00.30", 175, 125, 45, 24, 0x0001)
$button_sl004 = GUICtrlCreateButton("00.40", 175, 150, 45, 24, 0x0001)
$button_sl005 = GUICtrlCreateButton("00.50", 175, 175, 45, 24, 0x0001)

$button_sl010 = GUICtrlCreateButton("01.00", 225, 50, 60, 24, 0x0001)
$button_sl011 = GUICtrlCreateButton("01.10", 225, 75, 45, 24, 0x0001)
$button_sl012 = GUICtrlCreateButton("01.20", 225, 100, 45, 24, 0x0001)
$button_sl013 = GUICtrlCreateButton("01.30", 225, 125, 45, 24, 0x0001)
$button_sl014 = GUICtrlCreateButton("01.40", 225, 150, 45, 24, 0x0001)
$button_sl015 = GUICtrlCreateButton("01.50", 225, 175, 45, 24, 0x0001)

$button_sl020 = GUICtrlCreateButton("02.00", 275, 50, 60, 24, 0x0001)
$button_sl021 = GUICtrlCreateButton("02.10", 275, 75, 45, 24, 0x0001)
$button_sl022 = GUICtrlCreateButton("02.20", 275, 100, 45, 24, 0x0001)
$button_sl023 = GUICtrlCreateButton("02.30", 275, 125, 45, 24, 0x0001)
$button_sl024 = GUICtrlCreateButton("02.40", 275, 150, 45, 24, 0x0001)
$button_sl025 = GUICtrlCreateButton("02.50", 275, 175, 45, 24, 0x0001)

$button_sl030 = GUICtrlCreateButton("03.00", 330, 50, 60, 24, 0x0001)
$button_sl031 = GUICtrlCreateButton("03.10", 330, 75, 45, 24, 0x0001)
$button_sl032 = GUICtrlCreateButton("03.20", 330, 100, 45, 24, 0x0001)
$button_sl033 = GUICtrlCreateButton("03.30", 330, 125, 45, 24, 0x0001)
$button_sl034 = GUICtrlCreateButton("03.40", 330, 150, 45, 24, 0x0001)
$button_sl035 = GUICtrlCreateButton("03.50", 330, 175, 45, 24, 0x0001)

$button_sl040 = GUICtrlCreateButton("04.00", 380, 50, 60, 24, 0x0001)
$button_sl041 = GUICtrlCreateButton("04.10", 380, 75, 45, 24, 0x0001)
$button_sl042 = GUICtrlCreateButton("04.20", 380, 100, 45, 24, 0x0001)
$button_sl043 = GUICtrlCreateButton("04.30", 380, 125, 45, 24, 0x0001)
$button_sl044 = GUICtrlCreateButton("04.40", 380, 150, 45, 24, 0x0001)
$button_sl045 = GUICtrlCreateButton("04.50", 380, 175, 45, 24, 0x0001)



; define second tab name
$tab1=GUICtrlCreateTabitem ("Av med lyset..")

$button_s220 = GUICtrlCreateButton( "22.00", 55, 50, 60, 24, 0x0001)
$button_s221 = GUICtrlCreateButton( "22.10", 70, 75, 45, 24, 0x0001)
$button_s222 = GUICtrlCreateButton( "22.20", 70, 100, 45, 24, 0x0001)
$button_s223 = GUICtrlCreateButton("22.30", 70, 125, 45, 24, 0x0001)
$button_s224 = GUICtrlCreateButton("22.40", 70, 150, 45, 24, 0x0001)
$button_s225 = GUICtrlCreateButton("22.50", 70, 175, 45, 24, 0x0001)

$button_s230 = GUICtrlCreateButton("23.00", 105, 50, 60, 24, 0x0001)
$button_s231 = GUICtrlCreateButton("23.10", 120, 75, 45, 24, 0x0001)
$button_s232 = GUICtrlCreateButton("23.20", 120, 100, 45, 24, 0x0001)
$button_s233 = GUICtrlCreateButton("23.30", 120, 125, 45, 24, 0x0001)
$button_s234 = GUICtrlCreateButton("23.40", 120, 150, 45, 24, 0x0001)
$button_s235 = GUICtrlCreateButton("23.50", 120, 175, 45, 24, 0x0001)

$button_s000 = GUICtrlCreateButton("00.00", 175, 50, 60, 24, 0x0001)
$button_s001 = GUICtrlCreateButton("00.10", 175, 75, 45, 24, 0x0001)
$button_s002 = GUICtrlCreateButton("00.20", 175, 100, 45, 24, 0x0001)
$button_s003 = GUICtrlCreateButton("00.30", 175, 125, 45, 24, 0x0001)
$button_s004 = GUICtrlCreateButton("00.40", 175, 150, 45, 24, 0x0001)
$button_s005 = GUICtrlCreateButton("00.50", 175, 175, 45, 24, 0x0001)

$button_s010 = GUICtrlCreateButton("01.00", 225, 50, 60, 24, 0x0001)
$button_s011 = GUICtrlCreateButton("01.10", 225, 75, 45, 24, 0x0001)
$button_s012 = GUICtrlCreateButton("01.20", 225, 100, 45, 24, 0x0001)
$button_s013 = GUICtrlCreateButton("01.30", 225, 125, 45, 24, 0x0001)
$button_s014 = GUICtrlCreateButton("01.40", 225, 150, 45, 24, 0x0001)
$button_s015 = GUICtrlCreateButton("01.50", 225, 175, 45, 24, 0x0001)

$button_s020 = GUICtrlCreateButton("02.00", 275, 50, 60, 24, 0x0001)
$button_s021 = GUICtrlCreateButton("02.10", 275, 75, 45, 24, 0x0001)
$button_s022 = GUICtrlCreateButton("02.20", 275, 100, 45, 24, 0x0001)
$button_s023 = GUICtrlCreateButton("02.30", 275, 125, 45, 24, 0x0001)
$button_s024 = GUICtrlCreateButton("02.40", 275, 150, 45, 24, 0x0001)
$button_s025 = GUICtrlCreateButton("02.50", 275, 175, 45, 24, 0x0001)

$button_s030 = GUICtrlCreateButton("03.00", 330, 50, 60, 24, 0x0001)
$button_s031 = GUICtrlCreateButton("03.10", 330, 75, 45, 24, 0x0001)
$button_s032 = GUICtrlCreateButton("03.20", 330, 100, 45, 24, 0x0001)
$button_s033 = GUICtrlCreateButton("03.30", 330, 125, 45, 24, 0x0001)
$button_s034 = GUICtrlCreateButton("03.40", 330, 150, 45, 24, 0x0001)
$button_s035 = GUICtrlCreateButton("03.50", 330, 175, 45, 24, 0x0001)

$button_s040 = GUICtrlCreateButton("04.00", 380, 50, 60, 24, 0x0001)
$button_s041 = GUICtrlCreateButton("04.10", 380, 75, 45, 24, 0x0001)
$button_s042 = GUICtrlCreateButton("04.20", 380, 100, 45, 24, 0x0001)
$button_s043 = GUICtrlCreateButton("04.30", 380, 125, 45, 24, 0x0001)
$button_s044 = GUICtrlCreateButton("04.40", 380, 150, 45, 24, 0x0001)
$button_s045 = GUICtrlCreateButton("04.50", 380, 175, 45, 24, 0x0001)
; end tab definition

GUICtrlCreateTabitem ("Sovna..")
;knapper for SOVNA:
$button_s2300 = GUICtrlCreateButton("23.00", 105, 50, 60, 24, 0x0001)
$button_s2310 = GUICtrlCreateButton("23.10", 120, 75, 45, 24, 0x0001)
$button_s2320 = GUICtrlCreateButton("23.20", 120, 100, 45, 24, 0x0001)
$button_s2330 = GUICtrlCreateButton("23.30", 120, 125, 45, 24, 0x0001)
$button_s2340 = GUICtrlCreateButton("23.40", 120, 150, 45, 24, 0x0001)
$button_s2350 = GUICtrlCreateButton("23.50", 120, 175, 45, 24, 0x0001)

$button_s0000 = GUICtrlCreateButton("00.00", 175, 50, 60, 24, 0x0001)
$button_s0010 = GUICtrlCreateButton("00.10", 175, 75, 45, 24, 0x0001)
$button_s0020 = GUICtrlCreateButton("00.20", 175, 100, 45, 24, 0x0001)
$button_s0030 = GUICtrlCreateButton("00.30", 175, 125, 45, 24, 0x0001)
$button_s0040 = GUICtrlCreateButton("00.40", 175, 150, 45, 24, 0x0001)
$button_s0050 = GUICtrlCreateButton("00.50", 175, 175, 45, 24, 0x0001)

$button_s0100 = GUICtrlCreateButton("01.00", 225, 50, 60, 24, 0x0001)
$button_s0110 = GUICtrlCreateButton("01.10", 225, 75, 45, 24, 0x0001)
$button_s0120 = GUICtrlCreateButton("01.20", 225, 100, 45, 24, 0x0001)
$button_s0130 = GUICtrlCreateButton("01.30", 225, 125, 45, 24, 0x0001)
$button_s0140 = GUICtrlCreateButton("01.40", 225, 150, 45, 24, 0x0001)
$button_s0150 = GUICtrlCreateButton("01.50", 225, 175, 45, 24, 0x0001)

$button_s0200 = GUICtrlCreateButton("02.00", 275, 50, 60, 24, 0x0001)
$button_s0210 = GUICtrlCreateButton("02.10", 275,75, 45, 24, 0x0001)
$button_s0220 = GUICtrlCreateButton("02.20", 275, 100, 45, 24, 0x0001)
$button_s0230 = GUICtrlCreateButton("02.30", 275, 125, 45, 24, 0x0001)
$button_s0240 = GUICtrlCreateButton("02.40", 275, 150, 45, 24, 0x0001)
$button_s0250 = GUICtrlCreateButton("02.50", 275, 175, 45, 24, 0x0001)

$button_s0300 = GUICtrlCreateButton("03.00", 335,50, 60, 24, 0x0001)
$button_s0310 = GUICtrlCreateButton("03.10", 335, 75, 45, 24, 0x0001)
$button_s0320 = GUICtrlCreateButton("03.20", 335, 100, 45, 24, 0x0001)
$button_s0330 = GUICtrlCreateButton("03.30", 335, 125, 45, 24, 0x0001)
$button_s0340 = GUICtrlCreateButton("03.40", 335, 150,45, 24, 0x0001)
$button_s0350 = GUICtrlCreateButton("03.50", 335, 175, 45, 24, 0x0001)

$button_s0400 = GUICtrlCreateButton("04.00", 385, 50, 60, 24, 0x0001)
$button_s0410 = GUICtrlCreateButton("04.10", 385, 75, 45, 24, 0x0001)
$button_s0420 = GUICtrlCreateButton("04.20", 385, 100, 45, 24, 0x0001)
$button_s0430 = GUICtrlCreateButton("04.30", 385, 125, 45, 24, 0x0001)
$button_s0440 = GUICtrlCreateButton("04.40", 385, 150, 45, 24, 0x0001)
$button_s0450 = GUICtrlCreateButton("04.50", 385, 175, 45, 24, 0x0001)

$button_s0500 = GUICtrlCreateButton("05.00", 435, 50, 60, 24, 0x0001)
$button_s0510 = GUICtrlCreateButton("05.10", 435, 75, 45, 24, 0x0001)
$button_s0520 = GUICtrlCreateButton("05.20", 435, 100, 45, 24, 0x0001)
$button_s0530 = GUICtrlCreateButton("05.30", 435, 125, 45, 24, 0x0001)
$button_s0540 = GUICtrlCreateButton("05.40", 435, 150, 45, 24, 0x0001)
$button_s0550 = GUICtrlCreateButton("05.50", 435, 175, 45, 24, 0x0001)


;Av med lyset-knapper:






;VÅKNA

$button_s400 = GUICtrlCreateButton("04.00", 385, 230, 60, 24, 0x0001)
$button_s410 = GUICtrlCreateButton("04.10", 385, 255, 45, 24, 0x0001)
$button_s420 = GUICtrlCreateButton("04.20", 385, 280, 45, 24, 0x0001)
$button_s430 = GUICtrlCreateButton("04.30", 385, 305, 45, 24, 0x0001)
$button_s440 = GUICtrlCreateButton("04.40", 385, 330, 45, 24, 0x0001)
$button_s450 = GUICtrlCreateButton("04.50", 385, 355, 45, 24, 0x0001)

$button_s500 = GUICtrlCreateButton("05.00", 435, 230, 60, 24, 0x0001)
$button_s510 = GUICtrlCreateButton("05.10", 435, 255, 45, 24, 0x0001)
$button_s520 = GUICtrlCreateButton("05.20", 435, 280, 45, 24, 0x0001)
$button_s530 = GUICtrlCreateButton("05.30", 435, 305, 45, 24, 0x0001)
$button_s540 = GUICtrlCreateButton("05.40", 435, 330, 45, 24, 0x0001)
$button_s550 = GUICtrlCreateButton("05.50", 435, 355, 45, 24, 0x0001)

$button_s600 = GUICtrlCreateButton("06.00", 485, 230, 60, 24, 0x0001)
$button_s610 = GUICtrlCreateButton("06.10", 485, 255, 45, 24, 0x0001)
$button_s620 = GUICtrlCreateButton("06.20", 485, 280, 45, 24, 0x0001)
$button_s630 = GUICtrlCreateButton("06.30", 485, 305, 45, 24, 0x0001)
$button_s640 = GUICtrlCreateButton("06.40", 485, 330, 45, 24, 0x0001)
$button_s650 = GUICtrlCreateButton("06.50", 485, 355, 45, 24, 0x0001)

$button_s700 = GUICtrlCreateButton("07.00", 545, 230, 60, 24, 0x0001)
$button_s710 = GUICtrlCreateButton("07.10", 545, 255, 45, 24, 0x0001)
$button_s720 = GUICtrlCreateButton("07.20", 545, 280, 45, 24, 0x0001)
$button_s730 = GUICtrlCreateButton("07.30", 545, 305, 45, 24, 0x0001)
$button_s740 = GUICtrlCreateButton("07.40", 545, 330, 45, 24, 0x0001)
$button_s750 = GUICtrlCreateButton("07.50", 545, 355, 45, 24, 0x0001)

$button_s800 = GUICtrlCreateButton("08.00", 595, 230, 60, 24, 0x0001)
$button_s810 = GUICtrlCreateButton("08.10", 595, 255, 45, 24, 0x0001)
$button_s820 = GUICtrlCreateButton("08.20", 595, 280, 45, 24, 0x0001)
$button_s830 = GUICtrlCreateButton("08.30", 595, 305, 45, 24, 0x0001)
$button_s840 = GUICtrlCreateButton("08.40", 595, 330, 45, 24, 0x0001)
$button_s850 = GUICtrlCreateButton("08.50", 595, 355, 45, 24, 0x0001)

$button_s900 = GUICtrlCreateButton("09.00", 645, 230, 60, 24, 0x0001)
$button_s910 = GUICtrlCreateButton("09.10", 645, 255, 45, 24, 0x0001)
$button_s920 = GUICtrlCreateButton("09.20", 645, 280, 45, 24, 0x0001)
$button_s930 = GUICtrlCreateButton("09.30", 645, 305, 45, 24, 0x0001)
$button_s940 = GUICtrlCreateButton("09.40", 645, 330, 45, 24, 0x0001)
$button_s950 = GUICtrlCreateButton("09.50", 645, 355, 45, 24, 0x0001)



; Set the defaults (radio buttons clicked, default button, etc)
;GUISetControlEx($Registrert, $GUI_FOCUS + $GUI_DEFBUTTON)
;denne klarte eg ikkje å finne ny versjon av!!!



; Init our vars that we will use to keep track of radio events
$LaMeg = 0
$LysAv=0; We will assume 0 = first radio button selected, 2 = last button
$Sovna= 0
$Vokna= 0
$dato="Natt til idag:"
;GuiShow()
GUISetState (@SW_SHOW)
; In this message loop we use variables to keep track of changes to the radios, another
; way would be to use GuiRead() at the end to read in the state of each control.  Both
; methods are equally valid


;so endrer eg heile dette avsnittet:
;While 1
;   $msg = GuiMsg()
;   Select
;      Case $msg = -3
;         Exit
;      Case $msg=$date
;         $dato=GUIRead($date)    


$msg = 0
While $msg <> -3
    $msg = GUIGetMsg()
Select
Case $msg = -3
    Exit
 Case $msg=$date
    $dato=GUIRead($date)    

Case $msg = $button_sl220 
            $LaMeg ="22.00"
MsgBox(0,"", "22.00 has been clicked")
      Case $msg = $button_sl221 
         $LaMeg ="22.10"      
      Case $msg = $button_sl222 
         $LaMeg ="22.20"
      Case $msg = $button_sl223 
         $LaMeg ="22.30"
      Case $msg = $button_sl224 
         $LaMeg ="22.40"
      Case $msg = $button_sl225 
         $LaMeg ="22.50"

      Case $msg = $button_sl230 
         $LaMeg ="23.00"
      Case $msg = $button_sl231 
         $LaMeg ="23.10"      
      Case $msg = $button_sl232 
         $LaMeg ="23.20"
      Case $msg = $button_sl233 
         $LaMeg ="23.30"
      Case $msg = $button_sl234 
         $LaMeg ="23.40"
      Case $msg = $button_sl235 
         $LaMeg ="23.50"

      Case $msg = $button_sl000 
         $LaMeg ="00.00"
      Case $msg = $button_sl001 
         $LaMeg ="00.10"      
      Case $msg = $button_sl002 
         $LaMeg ="00.20"
      Case $msg = $button_sl003 
         $LaMeg ="00.30"
      Case $msg = $button_sl004 
         $LaMeg ="00.40"
      Case $msg = $button_sl005 
         $LaMeg ="00.50"

      Case $msg = $button_sl010 
         $LaMeg ="01.00"
      Case $msg = $button_sl011 
         $LaMeg ="01.10"      
      Case $msg = $button_sl012 
         $LaMeg ="01.20"
      Case $msg = $button_sl013 
         $LaMeg ="01.30"
      Case $msg = $button_sl014 
         $LaMeg ="01.40"
      Case $msg = $button_sl015 
         $LaMeg ="01.50"
  
      Case $msg = $button_sl020 
         $LaMeg ="02.00"
      Case $msg = $button_sl021 
         $LaMeg ="02.10"      
      Case $msg = $button_sl022 
         $LaMeg ="02.20"
      Case $msg = $button_sl023 
         $LaMeg ="02.30"
      Case $msg = $button_sl024 
         $LaMeg ="02.40"
      Case $msg = $button_sl025 
         $LaMeg ="02.50"  

    ;av med lyset:

      Case $msg = $button_s230 
         $LysAv ="23.00"
      Case $msg = $button_s231 
         $LysAv ="23.10"      
      Case $msg = $button_s232 
         $LysAv ="23.20"
      Case $msg = $button_s233 
         $LysAv ="23.30"
      Case $msg = $button_s234 
         $LysAv ="23.40"
      Case $msg = $button_s235 
         $LysAv ="23.50"

      Case $msg = $button_s000 
         $LysAv ="00.00"
      Case $msg = $button_s001 
         $LysAv ="00.10"      
      Case $msg = $button_s002 
         $LysAv ="00.20"
      Case $msg = $button_s003 
         $LysAv ="00.30"
      Case $msg = $button_s004 
         $LysAv ="00.40"
      Case $msg = $button_s005 
         $LysAv ="00.50"

      Case $msg = $button_s010 
         $LysAv ="01.00"
      Case $msg = $button_s011 
         $LysAv ="01.10"      
      Case $msg = $button_s012 
         $LysAv ="01.20"
      Case $msg = $button_s013 
         $LysAv ="01.30"
      Case $msg = $button_s014 
         $LysAv ="01.40"
      Case $msg = $button_s015 
         $LysAv ="01.50"
  
      Case $msg = $button_s020 
         $LysAv ="02.00"
      Case $msg = $button_s021 
         $LysAv ="02.10"      
      Case $msg = $button_s022 
         $LysAv ="02.20"
      Case $msg = $button_s023 
         $LysAv ="02.30"
      Case $msg = $button_s024 
         $LysAv ="02.40"
      Case $msg = $button_s025 
         $LysAv ="02.50"  
      
      ;SOVNA:
      
      Case $msg = $button_s2300 
         $Sovna="23.00"
      Case $msg = $button_s2310
         $Sovna="23.10"      
      Case $msg = $button_s2320 
         $Sovna="23.20"
      Case $msg = $button_s2330 
         $Sovna="23.30"
      Case $msg = $button_s2340 
         $Sovna="23.40"
      Case $msg = $button_s2350 
         $Sovna="23.50"

      Case $msg = $button_s0000 
         $Sovna="00.00"
      Case $msg = $button_s0010 
         $Sovna="00.10"      
      Case $msg = $button_s0020 
         $Sovna="00.20"
      Case $msg = $button_s0030 
         $Sovna="00.30"
      Case $msg = $button_s0040 
         $Sovna="00.40"
      Case $msg = $button_s0050 
         $Sovna="00.50"

      Case $msg = $button_s0100 
         $Sovna="01.00"
      Case $msg = $button_s0110 
         $Sovna="01.10"      
      Case $msg = $button_s0120 
         $Sovna="01.20"
      Case $msg = $button_s0130 
         $Sovna="01.30"
      Case $msg = $button_s0140 
         $Sovna="01.40"
      Case $msg = $button_s0150 
         $Sovna="01.50"
  
      Case $msg = $button_s0200 
         $Sovna="02.00"
      Case $msg = $button_s0210 
         $Sovna="02.10"      
      Case $msg = $button_s0220 
         $Sovna="02.20"
      Case $msg = $button_s0230 
         $Sovna="02.30"
      Case $msg = $button_s0240 
         $Sovna="02.40"
      Case $msg = $button_s0250 
         $Sovna="02.50"  
  
      Case $msg = $button_s0300 
         $Sovna="03.00"
      Case $msg = $button_s0310 
         $Sovna="03.10"      
      Case $msg = $button_s0320 
         $Sovna="03.20"
      Case $msg = $button_s0330 
         $Sovna="03.30"
      Case $msg = $button_s0340 
         $Sovna="03.40"
      Case $msg = $button_s0350 
         $Sovna="03.50"        
 
      Case $msg = $button_s0400 
         $Sovna="04.00"
      Case $msg = $button_s0410 
         $Sovna="04.10"      
      Case $msg = $button_s0420 
         $Sovna="04.20"
      Case $msg = $button_s0430 
         $Sovna="04.30"
      Case $msg = $button_s0440 
         $Sovna="04.40"
      Case $msg = $button_s0450 
         $Sovna="04.50"  
  
      Case $msg = $button_s0500 
         $Sovna="05.00"
      Case $msg = $button_s0510 
         $Sovna="05.10"      
      Case $msg = $button_s0520 
         $Sovna="05.20"
      Case $msg = $button_s0530 
         $Sovna="05.30"
      Case $msg = $button_s0540 
         $Sovna="05.40"
      Case $msg = $button_s0550 
         $Sovna="05.50"        
            
      ;VÅKNA:
      
      Case $msg = $button_s400 
         $Vokna ="04.00"
      Case $msg = $button_s410 
         $Vokna ="04.10"      
      Case $msg = $button_s420 
         $Vokna ="04.20"
      Case $msg = $button_s430 
         $Vokna ="04.30"
      Case $msg = $button_s440 
         $Vokna ="04.40"
      Case $msg = $button_s450 
         $Vokna ="04.50"
  
      Case $msg = $button_s500 
         $Vokna ="05.00"
      Case $msg = $button_s510 
         $Vokna ="05.10"      
      Case $msg = $button_s520 
         $Vokna ="05.20"
      Case $msg = $button_s530 
         $Vokna ="05.30"
      Case $msg = $button_s540 
         $Vokna ="05.40"
      Case $msg = $button_s550 
         $Vokna ="05.50"  

      Case $msg = $button_s600 
         $Vokna ="06.00"
      Case $msg = $button_s610 
         $Vokna ="06.10"      
      Case $msg = $button_s620 
         $Vokna ="06.20"
      Case $msg = $button_s630 
         $Vokna ="06.30"
      Case $msg = $button_s640 
         $Vokna ="06.40"
      Case $msg = $button_s650 
         $Vokna ="06.50"
  
      Case $msg = $button_s700 
         $Vokna ="07.00"
      Case $msg = $button_s710 
         $Vokna ="07.10"      
      Case $msg = $button_s720 
         $Vokna ="07.20"
      Case $msg = $button_s730 
         $Vokna ="07.30"
      Case $msg = $button_s740 
         $Vokna ="07.40"
      Case $msg = $button_s750 
         $Vokna ="07.50"  
      

      Case $msg = $button_s800 
         $Vokna ="08.00"
      Case $msg = $button_s810 
         $Vokna ="08.10"      
      Case $msg = $button_s820 
         $Vokna ="08.20"
      Case $msg = $button_s830 
         $Vokna ="08.30"
      Case $msg = $button_s840 
         $Vokna ="08.40"
      Case $msg = $button_s850 
         $Vokna ="08.50"
  
      Case $msg = $button_s900 
         $Vokna ="09.00"
      Case $msg = $button_s910 
         $Vokna ="09.10"      
      Case $msg = $button_s920 
         $Vokna ="09.20"
      Case $msg = $button_s930 
         $Vokna ="09.30"
      Case $msg = $button_s940 
         $Vokna ="09.40"
      Case $msg = $button_s950 
         $Vokna ="09.50"  
            
      Case $msg = $Registrert
         MsgBox(0, "Registert:", $dato& @LF &@LF &"I seng    " & $LaMeg & @LF&"Lys av   " & $LysAv & @LF&"Sovna   " & $Sovna & @LF&"Våkna   " & $Vokna)
Dim $sql ="INSERT INTO feil (Navn) VALUES('"&$dato&"')"
Run ('sqlcmd.exe /db "Feilreg" /user "root" /append /command  "' & $sql & '"','',@SW_MINIMIZE)
   EndSelect
WEnd

;GUIWaitClose()    ; wait dialog closing
;denne også nullstillte eg -men det gjekk utan!

GUIDelete();    ; will return 1
Exit