; script to obtain target V .017

; - pull it
; - fight to completion
; - wait for heal/restore
; rinse and repeat.
; needs to check for agression

; X is ---->

; Y is
;   |
;   |
;  \|/
;   v


; $ClassType = "GUARDIAN"
$ClassType = "PALADIN"
; $ClassType = "SHADOWKNIGHT"

$CS_Cycles = 2 ; 1 or 2
$ES_Cycles = 1 ; 0 or 1
$HS_Cycles = 0 ; 0 or 1 only 1 heal defined

;need to defer first heal and reduce below available frequency !

$Heal_Delay = 59000    ; milliseconds before first heal
$Heal_Interval = 19000 ; milliseconds between heals after first

$Heal_Time = 200 ; 200 ms : 50 = 10 secs - this is recovery time not Heal time ! change to autosense

WinWaitActive("EverQuest II (Jun  2 2006 19:46:00) USER OPTIMIZED: SOEBuild=3130L")

sleep(200)

$ERRR = 1
$Mode = 0
$ModeStr = "0"
$ChMode = 0
$ChModeStr = "0"

; *************** SETUP ***********************

Opt("SendKeyDownDelay", 10)      ;10 milliseconds
Opt("SendKeyDelay", 50)          ;50 milliseconds

Opt("MouseClickDownDelay", 20)   ;20 milliseconds

; send("{TAB}")


$Start_Time = TimerInit()



$HO_X = 445
$HO_Y = 830
$HO_Time = 10900
$HO_Cast = 100
$HO_Since = $Start_Time

;Continuation Steps
DIM $CS_X[10]
DIM $CS_Y[10]
DIM $CS_Time[10]
DIM $CS_Cast[10]
DIM $CS_Since[10]

;Finish Steps
DIM $FS_X[10]
DIM $FS_Y[10]
DIM $FS_Time[10]
DIM $FS_Cast[10]
DIM $FS_Since[10]

;Extra Steps
DIM $ES_X[5]
DIM $ES_Y[5]
DIM $ES_Time[5]
DIM $ES_Cast[5]
DIM $ES_Since[5]

;Heal Steps
DIM $HS_X[5]
DIM $HS_Y[5]
DIM $HS_Time[5]
DIM $HS_Cast[5]
DIM $HS_Since[5]

If $ClassType = "PALADIN" Then

  ; PALADIN HO CONTINUATION STEPS
  ; Listed in order of most desired if available first - not screen order
  ; better still - make screen order = most desireable order!

  $Cont_Steps = 5

  $CS_X[1] = 490 ; Sworn Strike
  $CS_Y[1] = 830
  $CS_Time[1] = 60900
  $CS_Cast[1] = 1000
  $CS_Since[1] = $Start_Time

  $CS_X[2] = 530 ; Celestial Judgement
  $CS_Y[2] = 830
  $CS_Time[2] = 20900
  $CS_Cast[2] = 1500
  $CS_Since[2] = $Start_Time

  $CS_X[3] = 570 ; Destroy Will
  $CS_Y[3] = 830
  $CS_Time[3] = 30900
  $CS_Cast[3] = 1000
  $CS_Since[3] = $Start_Time

  $CS_X[4] = 615 ; Condemnation
  $CS_Y[4] = 830
  $CS_Time[4] = 10900
  $CS_Cast[4] = 1000
  $CS_Since[4] = $Start_Time

  $CS_X[5] = 655 ; Judgement Strike
  $CS_Y[5] = 830
  $CS_Time[5] = 10900
  $CS_Cast[5] = 1000
  $CS_Since[5] = $Start_Time

  ; PALADIN HO FINISH STEPS
  ; Listed in order of most desired if available first - not screen order

  $Finish_Steps = 3

  $FS_X[1] = 865 ; group taunt and debuff
  $FS_Y[1] = 830
  $FS_Time[1] = 20900
  $FS_Cast[1] = 700
  $FS_Since[1] = $Start_Time

  $FS_X[2] = 780 ; group taunt - with damage - expensive
  $FS_Y[2] = 830
  $FS_Time[2] = 15900
  $FS_Cast[2] = 2500
  $FS_Since[2] = $Start_Time

  $FS_X[3] = 825 ; solo taunt
  $FS_Y[3] = 830
  $FS_Time[3] = 8900
  $FS_Cast[3] = 700
  $FS_Since[3] = $Start_Time


  ; PALADIN EXTRA STEPS
  ; Listed in order of most desired if available first - not screen order

  ; Introduce a heal step occasionally - instead of including it here

  $Extra_Steps = 2

  $ES_X[1] = 740 ; Refusal of Grace
  $ES_Y[1] = 830
  $ES_Time[1] = 60900
  $ES_Cast[1] = 2500
  $ES_Since[1] = $Start_Time

  $ES_X[2] = 700 ; Blessed Rush
  $ES_Y[2] = 830
  $ES_Time[2] = 10900
  $ES_Cast[2] = 1000
  $ES_Since[2] = $Start_Time


  ; PALADIN HEAL STEPS (only 1 occasionally)
  ; Differentiated because :
  ;     -   we don't wait for a spell to become availble
  ;     -   the recast time is set longer than actual - to reduce unecessary healing
  ; Hard fights need some healing but not as often as pos - or no power left anyway.

  $Heal_Steps = 1

  $HS_X[1] = 400 ; Pious Aid
  $HS_Y[1] = 920
  $HS_Time[1] = 29000 ; set long for no heals
  $HS_Cast[1] = 2500
  $HS_Since[1] = $Start_Time




EndIf ; $ClassType = "PALADIN"


If $ClassType = "SHADOWKNIGHT" Then

  ; PALADIN HO CONTINUATION STEPS
  ; Listed in order of most desired if available first - not screen order

  $Cont_Steps = 5

  ;Position 1,3
  $CS_X[1] = 490 ; Cleave Flesh (15)
  $CS_Y[1] = 830
  $CS_Time[1] = 20900
  $CS_Cast[1] = 1000
  $CS_Since[1] = $Start_Time

  ;Position 1,4
  $CS_X[2] = 530 ; Condemning Anger (13)
  $CS_Y[2] = 830
  $CS_Time[2] = 20900
  $CS_Cast[2] = 1500
  $CS_Since[2] = $Start_Time

  ;Position 1,5
  $CS_X[3] = 570 ; Fetid Strike (11)
  $CS_Y[3] = 830
  $CS_Time[3] = 30900
  $CS_Cast[3] = 1000
  $CS_Since[3] = $Start_Time

  ;Position 1,6 ; Painful Strike (15)
  $CS_X[4] = 615
  $CS_Y[4] = 830
  $CS_Time[4] = 10900
  $CS_Cast[4] = 1000
  $CS_Since[4] = $Start_Time

  ;Position 1,7 ; dummy to provide for 2 per cycle if only 1 ready (never happens on 1 per)
  $CS_X[5] = 655
  $CS_Y[5] = 830
  $CS_Time[5] = 10900
  $CS_Cast[5] = 1000
  $CS_Since[5] = $Start_Time

  ; SHADOWKNIGHT HO FINISH STEPS
  ; Listed in order of most desired if available first - not screen order

  $Finish_Steps = 2

  ;Position 1,12
  $FS_X[1] = 865 ; group taunt and lower res
  $FS_Y[1] = 830
  $FS_Time[1] = 20900
  $FS_Cast[1] = 700
  $FS_Since[1] = $Start_Time

  ;Position 1,11
  $FS_X[2] = 825 ; solo taunt
  $FS_Y[2] = 830
  $FS_Time[2] = 8900
  $FS_Cast[2] = 700
  $FS_Since[2] = $Start_Time

  ; SHADOWKNIGHT EXTRA STEPS
  ; Listed in order of most desired if available first - not screen order

  $Extra_Steps = 2

  ;Position 1,8
  $ES_X[2] = 700 ; Kick
  $ES_Y[2] = 830
  $ES_Time[2] = 10900
  $ES_Cast[2] = 1000
  $ES_Since[2] = $Start_Time

  ;Position 1,9 ; Shield Slam
  $ES_X[1] = 740
  $ES_Y[1] = 830
  $ES_Time[1] = 20900
  $ES_Cast[1] = 1000
  $ES_Since[1] = $Start_Time

EndIf ; $ClassType = "SHADOWKNIGHT"


If $ClassType = "GUARDIAN" Then

  ; GUARDIAN HO CONTINUATION STEPS
  ; Listed in order of most desired if available first - not screen order

  $Cont_Steps = 4

  $CS_X[1] = 490 ; Wound
  $CS_Y[1] = 830
  $CS_Time[1] = 20000
  $CS_Cast[1] = 1000
  $CS_Since[1] = $Start_Time

  $CS_X[2] = 530 ; Concussion
  $CS_Y[2] = 830
  $CS_Time[2] = 20000
  $CS_Cast[2] = 1000
  $CS_Since[2] = $Start_Time

  $CS_X[3] = 570 ; Crumble
  $CS_Y[3] = 830
  $CS_Time[3] = 20000
  $CS_Cast[3] = 1000
  $CS_Since[3] = $Start_Time

  $CS_X[4] = 615 ; Strike
  $CS_Y[4] = 830
  $CS_Time[4] = 10000
  $CS_Cast[4] = 1000
  $CS_Since[4] = $Start_Time

  ; GUARDIAN HO FINISH STEPS
  ; Listed in order of most desired if available first - not screen order

  $Finish_Steps = 2

  $FS_X[1] = 865 ; group taunt
  $FS_Y[1] = 830
  $FS_Time[1] = 20000
  $FS_Cast[1] = 700
  $FS_Since[1] = $Start_Time

  $FS_X[2] = 825 ; solo taunt
  $FS_Y[2] = 830
  $FS_Time[2] = 8000
  $FS_Cast[2] = 700
  $FS_Since[2] = $Start_Time

  ; GUARDIAN EXTRA STEPS
  ; Listed in order of most desired if available first - not screen order

  $Extra_Steps = 2

  $ES_X[1] = 700 ; Knee Bash
  $ES_Y[1] = 830
  $ES_Time[1] = 10000
  $ES_Cast[1] = 1000
  $ES_Since[1] = $Start_Time

  $ES_X[2] = 740 ; Taunting Blow
  $ES_Y[2] = 830
  $ES_Time[2] = 8000
  $ES_Cast[2] = 700
  $ES_Since[2] = $Start_Time


EndIf ; $ClassType = "GUARDIAN"


; ******* GENERAL VARIABLES  *******

$MouseSpeed = 2

$ClickWait = 200

$TargetX = 230
$TargetY = 945
;$TargetY = 926
$No_Target_Col = 0 ; Black

$FightX = 403
$FightY = 850
$Fight_Col = 0 ; Black

$AttackX = 400
$AttackY = 824

$CentreX = 640
$CentreY = 512

$ProgX = 900
$ProgY = 800

Dim $Fight = 0

DIM $Mouse_Pos[2]

; ************** START HERE ***************

$Mode = -1 ; i.e not selected

$Running = 1

$FirstTime = 1

$KillCount = 0

While $Running >0  ; do this until we stop for some reason

; Select mode

If $Mode = -1 then

; 3 possible modes :
; $Mode = 0 ; Fight on Input Box default
; $Mode = 1 ; React to attacks - i.e. check for targets and fight when we have one
; $Mode = 2 ; Scan and Pull targets
; Consider new mode 3 which allows target selection and mouse position (top, right) to pull it.

$ERRR = 1

While $ERRR > 0

$ModeStr = InputBox ( $ClassType & " Mode", "0 = User Trigger , 1 = Guard, 2= Auto-Hunt ", "0")
$ERRR = @ERROR
$Mode = Number ( $ModeStr )

IF $Mode <> 0 AND $Mode <> 1 AND $Mode <> 2 then
  $ERRR = 1
EndIF

Wend ; $ERRR

$FirstTime = 1 ; first time reset after mode switch to turn on/off progress boxes

EndIf ; $Mode unselected (-1)

;***************** AUTO FIGHT MODE ***************************

If $Mode = 0 then

  $ERRR = 1
  While $ERRR > 0

  $ChModeStr = InputBox ( $ClassType & "Simple Fight Mode", "0 = Continue , 1 = Change", "0")
  $ERRR = @ERROR
  $ChMode = Number ( $ChModeStr )

  IF $ChMode <> 0 AND $ChMode <> 1 then
     $ERRR = 1
  EndIF

  Wend ; $ERRR

  $Fight = 1 ; we now have a fight !

  If $ChMode = 1 then
     $Mode = -1
     $Fight = 0 ; turn fighting back off
  EndIf

EndIf  ; MODE 0


;********************* GUARD MODE *****************************

If $Mode = 1 AND $FirstTime = 1 then
  MsgBox(0, $ClassType &" GUARD", "Mode 1 - GUARD - Press to start"  )
  ProgressOn($ClassType & " GUARD MODE" , "Count : " & $KillCount, "Initial State", $ProgX, $ProgY )
  $FirstTime = 0
EndIf ; $Mode and $FirstTime


If $Mode = 1 then  ;    GUARD MODE - WATCH FOR TARGETS

  ; Move mouse to centre screen to indicate  user control or wait mode
  MouseMove( $CentreX, $CentreY, $MouseSpeed )
  ProgressSet( 0 , "Waiting" , "Count : " & $KillCount )
  $Fight = 0 ; Assume No Target

  While $Fight = 0 and $Mode = 1

     ; check for pause
     $Mouse_Pos = MouseGetPos()
     If $Mouse_Pos[0] = 0 and $Mouse_Pos[1] = 0 then
        ProgressOff()


        $ERRR = 1
        While $ERRR > 0

           $ChModeStr = InputBox ( $ClassType & "Guard Mode", "0 = Continue, 1 = Change", "0")
           $ERRR = @ERROR
           $ChMode = Number ( $ChModeStr )

           IF $ChMode <> 0 AND $ChMode <> 1 then
              $ERRR = 1
           EndIF

        Wend ; $ERRR

        If $ChMode = 1 then
          $Mode = -1
        EndIf

        If $Mode = 1 then ; mode still 1 so turn back on progress box
           ProgressOn($ClassType & " GUARD MODE" , "Count : " & $KillCount, "Initial State", $ProgX, $ProgY )
           ProgressSet( 0 , "Waiting" , "Count : " & $KillCount )
        EndIf ;

     EndIf

     $Target_Colour = PixelGetColor ($TargetX, $TargetY)
     IF $Target_Colour <> $No_Target_Col then
        $Fight = 1
     EndIf

     Sleep (200)

  Wend ; $Fight AND $Mode

  If $Fight = 1 Then ; as opposed to passing here before a mode change

     ; At this point it might help to automatically bang in a spell
     ; to ensure combat is engaged. One of the longer range CS steps - for pulling

     $OK = 0

     $Spell_Num = 2 ; start with the one we want 

     While $OK < 1

        $Diff = TimerDiff($CS_Since[$Spell_Num])
        if $Diff > $CS_Time[$Spell_Num] then
           $OK = 1
        EndIf

        If $OK < 1 then
           $Spell_Num = $Spell_Num + 1
           If $Spell_Num > $Cont_Steps then
              $Spell_Num = 1
              Sleep (200) ; only sleep after cycling through all options
           EndIf
        EndIf

     Wend ; $OK

     MouseMove( $CS_X[$Spell_Num], $CS_Y[$Spell_Num], $MouseSpeed )
     Sleep( $ClickWait )
     MouseClick("left")
     ; double click to get focus - just in case we've been activated in mid-fight 
     Sleep( $ClickWait )
     MouseClick("left")
     Sleep( $CS_Cast[$Spell_Num] )
     $CS_Since[$Spell_Num] = TimerInit()

     $KillCount = $KillCount + 1

  EndIf ; $Fight = 1

EndIf ; $Mode = 1


;********************* HUNT MODE *****************************

If $Mode = 2 AND $FirstTime = 1 Then
  MsgBox(0, "AUTOFIGHT", "Mode 2 - AUTO HUNT (BOT) - Press to start"  )
  ProgressOn($ClassType & " HUNT MODE" , "Count : " & $KillCount, "Initial State", $ProgX, $ProgY )
  $FirstTime = 0
EndIf

If $Mode = 2 Then

While $Fight = 0 ; to facilitate dropping target after pull

; HUNT MODE - Check for attackers and pull anything available

; need to wait out to heal and allow for attack, target select or temp disable
; need to modify to watch health and power

  $Healing = 0

  While $Healing < $Heal_Time AND $Mode = 2
     ; increment counter
     $Healing = $Healing + 1
     ProgressSet( INT(($Healing/$Heal_Time)*100) , "Waiting" , "Count : " & $KillCount )

     ; check for pause
     $Mouse_Pos = MouseGetPos()
     If $Mouse_Pos[0] = 0 and $Mouse_Pos[1] = 0 then
        ProgressOff()

        $ERRR = 1
        While $ERRR > 0

           $ChModeStr = InputBox ( $ClassType & "Hunt (BOT) Mode", "0 = Continue , 1 = Change", "0")
           $ERRR = @ERROR
           $ChMode = Number ( $ChModeStr )

           IF $ChMode <> 0 AND $ChMode <> 1 then
              $ERRR = 1
           EndIF

        Wend ; $ERRR

        If $ChMode = 1 then
          $Mode = -1
        EndIf

        If $Mode = 2 then ; mode still 2 so turn back on progress box
           ProgressOn($ClassType & " HUNT MODE" , "Count : " & $KillCount, "Initial State", $ProgX, $ProgY )
           ProgressSet( INT(($Healing/$Heal_Time)*100) , "Waiting" , "Count : " & $KillCount )
        EndIf ; Still Mode 2

     EndIf ; Mouse Pos

     ; check for target (selected or agro)
     $Target_Colour = PixelGetColor ($TargetX, $TargetY)
     IF $Target_Colour <> $No_Target_Col then
        $Fight = 1
        $Healing = $Heal_Time ; i.e auto-end timer if have target
     EndIf

     Sleep (100)

  Wend ; $Healing and $Mode

  If $Mode = 2 And $Fight = 0 Then ; i.e. still on mode 2 and timer up rather than mode change required or in fight 

     ; If no target selected or attacked, get one
     If $Fight = 0 Then
        send("{F8}")     ; target closest NPC
        ; $Fight = 1
     EndIf

     ; assume spell is ready


     If $ClassType = "PALADIN" Then

        $Spell_Num = 2 ; Pull with FS(2)

        MouseMove( $FS_X[$Spell_Num], $FS_Y[$Spell_Num], $MouseSpeed )
        Sleep( $ClickWait )
        MouseClick("left")
        Sleep( $FS_Cast[$Spell_Num] )
        $FS_Since[$Spell_Num] = TimerInit()

     EndIf ; $ClassType = "PALADIN"


     If $ClassType = "SHADOWKNIGHT" Then

        $Spell_Num = 2 ; Pull with CS(2)

        MouseMove( $CS_X[$Spell_Num], $CS_Y[$Spell_Num], $MouseSpeed )
        Sleep( $ClickWait )
        MouseClick("left")
        Sleep( $CS_Cast[$Spell_Num] )
        $CS_Since[$Spell_Num] = TimerInit()

     EndIf ; $ClassType = "SHADOWKNIGHT"

     Send("{ESC}") ; drop acquired target (wait for it to re-attack)

     $KillCount = $KillCount + 1 ; (count it as a kill anyway)

  EndIf ; Mode still 2 and not fighting (i.e ready to pull) 

Wend ; $Fight = 0 (i.e. if not fighting go back to timer/wait cycle)

EndIf ; Mode 2


; *********** CORE FIGHT MODULE ****************

; At this point the victim is targeted and pulled
; the spell arrays are all set and the the fight is in prgress.

;----------------------------------------------------------
;*********** wait for HO starter and trigger **************
;----------------------------------------------------------

; $Fight = 1  ; (no longer necessary as always set above unless mode change required)

; Arrive here at the beginning of a fight - or a change of mode
; set beginning of fight parameters anyway - doesn't matter if it's change of mode.

; Reset Heal settings 
; - delay to first heal
$HS_Time[1] = $Heal_Delay
; - and start counter now 
$HS_Since[1] = TimerInit()


While $Fight > 0

If $Mode = 1 OR $Mode = 2 then  ;    GUARD or HUNT MODE - SET PROGRESS
  ProgressSet( 100 , "Fighting" )
EndIf ; $Mode = 1 or 2



; Confirm I have a Target;  if not fight is over ; tripple check !

$Target_Colour = PixelGetColor ($TargetX, $TargetY)
IF $Target_Colour = $No_Target_Col then
  Sleep (300)
  $Target_Colour = PixelGetColor ($TargetX, $TargetY)
  IF $Target_Colour = $No_Target_Col then
     Sleep (600)
     $Target_Colour = PixelGetColor ($TargetX, $TargetY)
     IF $Target_Colour = $No_Target_Col then
        $Fight = 0
     EndIf
  Endif
Endif

; Confirm I'm fighting; if not attack ; do a double check in case we stop!
; only if we haven't finished.

If $Fight > 0 then
  $Fight_Colour = PixelGetColor ($FightX, $FightY)
  IF $Fight_Colour <> $Fight_Col then
     Sleep (800)
     $Fight_Colour = PixelGetColor ($FightX, $FightY)
     IF $Fight_Colour <> $Fight_Col then
        MouseMove( $AttackX, $AttackY, $MouseSpeed )
        Sleep( $ClickWait )
        MouseClick("left")
        Sleep( $ClickWait )
     EndIf
  Endif
Endif

; Now triger the HO starter when its timer is up
; only if we havn't finished

If $Fight > 0 then
 $OK = 0
 While $OK < 1

    $Diff = TimerDiff($HO_Since)
    if $Diff > $HO_Time then
       $OK = 1
    EndIf ; $Diff

    ; Confirm I'm fighting; if not attack ; do a double check in case we stop!

    $Fight_Colour = PixelGetColor ($FightX, $FightY)
    IF $Fight_Colour <> $Fight_Col then
       Sleep (800)
       $Fight_Colour = PixelGetColor ($FightX, $FightY)
       IF $Fight_Colour <> $Fight_Col then
          MouseMove( $AttackX, $AttackY, $MouseSpeed )
          Sleep( $ClickWait )
          MouseClick("left")
          Sleep( $ClickWait )
       EndIf
    EndIf

    Sleep (200) ; loop pause waiting for HO timer

  Wend ; $OK  - so now we have a HO ready

; Confirm I have a Target;  if not fight is over ; tripple check !

  $Target_Colour = PixelGetColor ($TargetX, $TargetY)
  IF $Target_Colour = $No_Target_Col then
     Sleep (400)
     $Target_Colour = PixelGetColor ($TargetX, $TargetY)
     IF $Target_Colour = $No_Target_Col then
        Sleep (800)
        $Target_Colour = PixelGetColor ($TargetX, $TargetY)
        IF $Target_Colour = $No_Target_Col then
           $Fight = 0
        EndIf ;$Target_Colour
     Endif ;$Target_Colour
  Endif ;$Target_Colour

  If $Fight > 0 then
     MouseMove( $HO_X, $HO_Y, $MouseSpeed )
     $HO_Since = TimerInit()
     Sleep( $ClickWait )
     MouseClick("left")
     Sleep( $ClickWait )
     MouseClick("left")
     Sleep( $ClickWait )
  EndIf ; $Fight

EndIf ; $Fight

; *************** END OF HO STARTER ***********************


;----------------------------------------------------------
;******** wait for HO continuation and trigger ************
;----------------------------------------------------------

; Multiple Continuation Steps Per Cycle
$CS_Cycle = 0 ; Current cycle

While $CS_Cycle < $CS_Cycles

  $CS_Cycle = $CS_Cycle + 1

  If $Fight > 0 then ; don't do anything if not fighting

  ; Confirm I have a Target; if not fight is over ; tripple check !

     $Target_Colour = PixelGetColor ($TargetX, $TargetY)
     IF $Target_Colour = $No_Target_Col then
        Sleep (400)
        $Target_Colour = PixelGetColor ($TargetX, $TargetY)
        IF $Target_Colour = $No_Target_Col then
           Sleep (800)
           $Target_Colour = PixelGetColor ($TargetX, $TargetY)
           IF $Target_Colour = $No_Target_Col then
              $Fight = 0
           EndIf
        Endif
     Endif


     $OK = 0 ; not ready

     $Spell_Num = 1 ; start at first spell (most desired)

     While $OK < 1

        $Diff = TimerDiff($CS_Since[$Spell_Num])
        If $Diff > $CS_Time[$Spell_Num] then
           $OK = 1
        EndIf

        If $OK < 1 then ; if not ready move to next spell
           $Spell_Num = $Spell_Num + 1
           If $Spell_Num > $Cont_Steps then
              $Spell_Num = 1
              Sleep (200) ; only sleep after cycling through all options
           EndIf
        EndIf

     Wend ; $OK - ready to cast HO CONTINUATION

     MouseMove( $CS_X[$Spell_Num], $CS_Y[$Spell_Num], $MouseSpeed )
     Sleep( $ClickWait )
     MouseClick("left")
     Sleep( $CS_Cast[$Spell_Num] )
     $CS_Since[$Spell_Num] = TimerInit()

  EndIf ; $Fight

Wend ; $CS_Cycle

; ************ END OF HO CONTINUATION ********************

;----------------------------------------------------------
; ********* wait for HO final step and trigger *************
;----------------------------------------------------------

If $Fight > 0 then

; Confirm I have a Target; if not fight is over ; tripple check !

  $Target_Colour = PixelGetColor ($TargetX, $TargetY)
  IF $Target_Colour = $No_Target_Col then
     Sleep (400)
     $Target_Colour = PixelGetColor ($TargetX, $TargetY)
     IF $Target_Colour = $No_Target_Col then
        Sleep (800)
        $Target_Colour = PixelGetColor ($TargetX, $TargetY)
        IF $Target_Colour = $No_Target_Col then
           $Fight = 0
        EndIf
     Endif
  Endif

  $OK = 0

  $Spell_Num = 1

  While $OK < 1

     $Diff = TimerDiff($FS_Since[$Spell_Num])
     if $Diff > $FS_Time[$Spell_Num] then
        $OK = 1
     EndIf

     If $OK < 1 then
        $Spell_Num = $Spell_Num + 1
        If $Spell_Num > $Finish_Steps then
           $Spell_Num = 1
           Sleep (200) ; only sleep after cycling through all options
        EndIf
     EndIf

  Wend ; $OK

  MouseMove( $FS_X[$Spell_Num], $FS_Y[$Spell_Num], $MouseSpeed )
  Sleep( $ClickWait )
  MouseClick("left")
  Sleep( $FS_Cast[$Spell_Num] )
  $FS_Since[$Spell_Num] = TimerInit()

EndIf ; $Fight

; ************ END OF HO CONTINUATION ********************


;----------------------------------------------------------
; ********* wait for Extra step and trigger *************
;----------------------------------------------------------

; Extra Steps Per Cycle
$ES_Cycle = 0 ; Current cycle

While $ES_Cycle < $ES_Cycles

  $ES_Cycle = $ES_Cycle + 1

  If $Fight > 0 then

  ; Confirm I have a Target; if not fight is over ; tripple check !

     $Target_Colour = PixelGetColor ($TargetX, $TargetY)
     IF $Target_Colour = $No_Target_Col then
        Sleep (400)
        $Target_Colour = PixelGetColor ($TargetX, $TargetY)
        IF $Target_Colour = $No_Target_Col then
           Sleep (800)
           $Target_Colour = PixelGetColor ($TargetX, $TargetY)
           IF $Target_Colour = $No_Target_Col then
              $Fight = 0
              EndIf
       Endif
     Endif

     $OK = 0

     $Spell_Num = 1

     While $OK < 1

        $Diff = TimerDiff($ES_Since[$Spell_Num])
        if $Diff > $ES_Time[$Spell_Num] then
           $OK = 1
        EndIf

        If $OK < 1 then
           $Spell_Num = $Spell_Num + 1
           If $Spell_Num > $Extra_Steps then
              $Spell_Num = 1
              Sleep (200) ; only sleep after cycling through all options
           EndIf
        EndIf

     Wend ; $OK

     MouseMove( $ES_X[$Spell_Num], $ES_Y[$Spell_Num], $MouseSpeed )
     Sleep( $ClickWait )
     MouseClick("left")
     Sleep( $ES_Cast[$Spell_Num] )
     $ES_Since[$Spell_Num] = TimerInit()

  EndIf ; $Fight

Wend ; $ES_Cycle

; ****************** END OF EXTRA STEPS ********************



;----------------------------------------------------------
; ********* check if Heal step and trigger *************
;----------------------------------------------------------

; The Heal step is different - we don't wait for them - we hit them if they are ready.
; Ready means $Heal_Interval has expired since last heal

; assume only one Heal spell is available

$HS_Cycle = 0 ; Current cycle

If $HS_Cycle < $HS_Cycles Then  ; if bothering to Heal $HS_Cycles is set to 1

  If $Fight > 0 then

  ; Confirm I have a Target; if not fight is over ; tripple check !

     $Target_Colour = PixelGetColor ($TargetX, $TargetY)
     IF $Target_Colour = $No_Target_Col then
        Sleep (400)
        $Target_Colour = PixelGetColor ($TargetX, $TargetY)
        IF $Target_Colour = $No_Target_Col then
           Sleep (800)
           $Target_Colour = PixelGetColor ($TargetX, $TargetY)
           IF $Target_Colour = $No_Target_Col then
              $Fight = 0
              EndIf
       Endif
     Endif

     If $Fight > 0 then ; check we havn't just stopped !

        $Diff = TimerDiff($HS_Since[1])

        if $Diff > $HS_Time[1] then ; bang in a heal spell
           MouseMove( $HS_X[1], $HS_Y[1], $MouseSpeed )
           Sleep( $ClickWait )
           MouseClick("left")
           Sleep( $HS_Cast[1] )
           $HS_Since[1] = TimerInit()
           $HS_Time[1] = $Heal_Interval ; set to $Heal_Delay at first pass - a bit inefficient
        EndIf ; $Diff

     EndIf ; $Fight

  EndIf ; $Fight

EndIf  ; $HS_Cycle

; ****************** END OF HEAL STEP ********************


; if I've got to here and have no fight - best check again
; in case target switch occurred

If $Fight = 0 then

  $Fight = 1
  $Target_Colour = PixelGetColor ($TargetX, $TargetY)
  IF $Target_Colour = $No_Target_Col then
     Sleep (400)
     $Target_Colour = PixelGetColor ($TargetX, $TargetY)
     IF $Target_Colour = $No_Target_Col then
        Sleep (800)
        $Target_Colour = PixelGetColor ($TargetX, $TargetY)
        IF $Target_Colour = $No_Target_Col then
           $Fight = 0
        EndIf
     Endif
  Endif

Endif ; No $Fight test

Wend  ; $Fight

Wend  ; $Running

