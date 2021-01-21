; script to make a number of items from sequential recipes 

; X is ----> 

; Y is 
;   |
;   | 
;  \|/

; Varibles

Dim $MACHINE = "D330"   ; "D330" or "CPQ"

Dim $SkillSet ; "PROVISIONER" , "JEWELER" , "ALCHEMIST" , "APOTHECARY" , "TAILOR"

Dim $SpellSet ; which spell set 1, 2 or 3 

Dim $MouseTest       ; Run a Mouse Test -  0 for No, 1 for Yes 
Dim $RunProduction   ; Run in Production Mode - 0 for No, 1 for Yes 

$MouseTest      = 0 
$RunProduction  = 1


Dim $HowManyRecipes  ; the number or recipes to process
Dim $Quantity[13]    ; number of each recipe to make
Dim $Cycles[13]      ; number of cycles for this recipe
Dim $PushOrHold[13]  ; 0 for push progress, 1 for mixed, ( 2 for hold on hard )

; Dim $BatchSize = 6   ; number of items between pauses ; 0 for continuous

;     "JEWELER"      or  "PROVISIONER"
; or  "ALCHEMIST"    or  "APOTHECARY"  
; or  "TAILOR"       or  "METALWORKING"
; or  "METALSHAPING" or  "GEOMANCY"

$SkillSet =     "PROVISIONER"  

$SpellSet =        1                

$HowManyRecipes  = 8

$Quantity[01]    = 39
$Cycles[01]      = 50      ; 4 - Very Easy - 22 Very Hard
$PushOrHold[01]  = 0       ; 0 for push progress, 1 for mixed,


$Quantity[02]    = 39
$Cycles[02]      = 50       ; 4 - Very Easy - 22 Very Hard
$PushOrHold[02]  = 0        ; 0 for push progress, 1 for mixed,


$Quantity[03]    = 39
$Cycles[03]      = 50       ; 4 - Very Easy - 22 Very Hard
$PushOrHold[03]  = 0        ; 0 for push progress, 1 for mixed,

 
$Quantity[04]    = 39
$Cycles[04]      = 50       ; 4 - Very Easy - 22 Very Hard
$PushOrHold[04]  = 0        ; 0 for push progress, 1 for mixed,
 

$Quantity[05]    = 39
$Cycles[05]      = 50       ; 4 - Very Easy - 22 Very Hard
$PushOrHold[05]  = 1        ; 0 for push progress, 1 for mixed,


$Quantity[06]    = 39
$Cycles[06]      = 50       ; 4 - Very Easy - 22 Very Hard
$PushOrHold[06]  = 1        ; 0 for push progress, 1 for mixed,


$Quantity[07]    = 32
$Cycles[07]      = 50       ; 4 - Very Easy - 22 Very Hard
$PushOrHold[07]  = 0        ; 0 for push progress, 1 for mixed,


$Quantity[08]    = 46
$Cycles[08]      = 50       ; 4 - Very Easy - 22 Very Hard
$PushOrHold[08]  = 1        ; 0 for push progress, 1 for mixed,

$Quantity[09]    = 80
$Cycles[09]      = 50       ; 4 - Very Easy - 22 Very Hard
$PushOrHold[09]  = 0       ; 0 for push progress, 1 for mixed,

$Quantity[10]    = 80
$Cycles[10]      = 50       ; 4 - Very Easy - 22 Very Hard
$PushOrHold[10]  = 0       ; 0 for push progress, 1 for mixed,

$Quantity[11]    = 80
$Cycles[11]      = 50       ; 4 - Very Easy - 22 Very Hard
$PushOrHold[11]  = 0       ; 0 for push progress, 1 for mixed,

$Quantity[12]    = 0
$Cycles[12]      = 50       ; 4 - Very Easy - 22 Very Hard
$PushOrHold[12]  = 0       ; 0 for push progress, 1 for mixed,

; *************************************
; *                                   *
; *           DECLARATIONS            *
; *                                   *
; *************************************

Dim $BeginX, $BeginY                  ; Location of Begin Button
Dim $RepeatX, $RepeatY                ; Location of Repeat Button
Dim $RecipesX, $RecipesY              ; Location of Recipes Button
Dim $ProgressX, $ProgressY            ; Location of First Progess Art
Dim $DurableX, $DurableY              ; Location of First Durable Art
Dim $UncoverSpellX, $UncoverSpellY
Dim $UncoverRecipeX, $UncoverRecipeY
Dim $RecipeX, $RecipeY, $RecipeXinc
Dim $HowmanyItems
Dim $HowManyDurables
Dim $PushHold                         ; 0 for progress , 1 for mixed
Dim $DurableInterval
Dim $FinishingInterval
Dim $RecoveryInterval
Dim $ShortInterval
Dim $ClickWait
Dim $HalfSec
Dim $MouseSpeed
Dim $FinishX, $FinishY
Dim $RecoveryX, $RecoveryY
Dim $EndX, $EndY
Dim $i, $j, $k


Dim $BatchCount = 0

; Finding and managing the power box

Dim $GotColour
Dim $PowerBoxColour
Dim $PowerColour
Dim $NoPowerColour 
Dim $PowerSearchX
Dim $PowerSearchY

; Finding and managing the recipe box

; Dim $RecipeBoxColour
; Dim $CompleteColour
; Dim $IncompleteColour 
; Dim $RecipeSearchX
; Dim $RecipeSearchY

; Offsets from found point to power measuring point

Dim $PowerOffsetX
Dim $PowerOffsetY

; Offsets from found point to completion measuring point
Dim $RecipeOffsetX
Dim $RecipeOffsetY

; Offsets from found point to event measuring point
Dim $EventOffsetX 
Dim $EventOffsetY 

; Colours for matching events
Dim $Event0Colour
Dim $Event1Colour
Dim $Event2Colour
Dim $Event3Colour


Dim $InteruptWait = 500

; *************************************
; *                                   *
; *           ASSIGNMENTS             *
; *                                   *
; *************************************


; ************  LOCATIONS  ************ 

$BeginX = 1015
$BeginY = 943

$RecipesX = 1070
$RecipesY = 943

$RepeatX = 961
$RepeatY = 943

If $SpellSet = 1 Then
   $ProgressX = 403
   $ProgressY = 960
   $DurableX = 445
   $DurableY = 960
EndIf ; SpellSet 1


If $SpellSet = 2 Then
   $ProgressX = 572
   $ProgressY = 960
   $DurableX = 615
   $DurableY = 960
EndIf ; SpellSet 2


If $SpellSet = 3 Then
   $ProgressX = 740
   $ProgressY = 960
   $DurableX = 782
   $DurableY = 960
EndIf ; SpellSet 3



$UncoverSpellX = 372
$UncoverSpellY = 960

$UncoverRecipeX = 372
$UncoverRecipeY = 913

$RecipeX = 405
$RecipeY =  913
$RecipeXinc = 42




; ******* GENERAL VARIABLES  ******* 

$MouseSpeed = 2

$DurableInterval = 3275

$ShortInterval = 150

$HalfSec = 10 

$ClickWait = 40 

$RecoveryX = 1250
$RecoveryY = 250

$EndX = 30
$EndY = 930

WinWaitActive("EverQuest II (May  9 2006 15:53:03) USER OPTIMIZED: SOEBuild=3058L")

sleep(500)  ; startup pause

MsgBox(0, "Machine is " , $MACHINE )




If $Machine = "D330" Then

$DurableInterval = 3365

$ShortInterval = 5

; ********* Power BOX **********
; What colour to search for and where to start 
    $PowerBoxColour    = 1117187
    $PowerSearchX      = 80
    $PowerSearchY      = 920

;Offsets to power measuring point from found point
    $PowerOffsetX      = 112
    $PowerOffsetY      = 7 

;Colours of power and no power at measuring point
  $PowerColour       = 0x655BE9
  $NoPowerColour     = 0x000040

; ************* Recipe BOX **********
; What colour to search for and where to start 
    $RecipeBoxColour   = 0
    $RecipeSearchX     = 915
    $RecipeSearchY     = 405

;Offsets to completion measuring point from found point
    $RecipeOffsetX     = 252
    $RecipeOffsetY     = 533

;Colour of complted and incomplete recipes at measuring point
   $CompleteColour    = 2960429
;  $IncompleteColour  = 0 (not in use) 

; Offsets to Event measuring point from found point
   $EventOffsetX = 20
   $EventOffsetY = 464

If $SkillSet = "PROVISIONER" Then
   $Event0Colour =  1908777
   $Event1Colour =  7446750
   $Event2Colour = 10849952
   $Event3Colour =  6019319
EndIf  ; PROVISIONER

If $SkillSet = "JEWELER" Then
   $Event0Colour =  1908777
   $Event1Colour =  0
   $Event2Colour =  0
   $Event3Colour =  0
EndIf  ; JEWELLER

If $SkillSet = "ALCHEMIST" Then
   $Event0Colour =  1908777
   $Event1Colour =  0
   $Event2Colour =  0
   $Event3Colour =  0
EndIf  ; ALCHEMIST

If $SkillSet = "APOTHECARY" Then
   $Event0Colour =  1908777
   $Event1Colour =  0
   $Event2Colour =  0
   $Event3Colour =  0
EndIf  ; APOTHECARY

If $SkillSet = "TAILOR" Then
   $Event0Colour =  1908777
   $Event1Colour =  0
   $Event2Colour =  0
   $Event3Colour =  0
EndIf  ; TAILOR

If $SkillSet = "METALWORKING" Then
   $Event0Colour =  1908777
   $Event1Colour =  0
   $Event2Colour =  0
   $Event3Colour =  0
EndIf  ; METALWORKING

If $SkillSet = "METALSHAPING" Then
   $Event0Colour =  1908777
   $Event1Colour =  0
   $Event2Colour =  0
   $Event3Colour =  0
EndIf  ; METALSHAPING

If $SkillSet = "GEOMANCY" Then
   $Event0Colour =  1908777
   $Event1Colour =  0
   $Event2Colour =  0
   $Event3Colour =  0
EndIf  ; GEOMANCY


EndIf  ; D330


If $Machine = "CPQ" Then



$DurableInterval = 3100

$ShortInterval = 50
 
; ********* Power BOX **********
; What colour to search for and where to start 
    $PowerBoxColour    = 0xEFE0A0
    $PowerSearchX      = 80
    $PowerSearchY      = 920

;Offsets to power measuring point from found point
    $PowerOffsetX      = 112
    $PowerOffsetY      = 7 

;Colours of power and no power at measuring point
  $PowerColour       = 0x655BE9
  $NoPowerColour     = 0x000040

; ************* Recipe BOX **********
; What colour to search for and where to start 
    $RecipeBoxColour   = 0
    $RecipeSearchX     = 915
    $RecipeSearchY     = 405

;Offsets to completion measuring point from found point
    $RecipeOffsetX     = 272
    $RecipeOffsetY     = 502

;Colour of complted and incomplete recipes at measuring point
   $CompleteColour    = 2697256
;  $IncompleteColour  = 0 (not in use) 

; Offsets to Event measuring point from found point
   $EventOffsetX = 40
   $EventOffsetY = 440

If $SkillSet = "PROVISIONER" Then
   $Event0Colour = 2366223
   $Event1Colour = 8671551
   $Event2Colour = 1397676
   $Event3Colour = 10182755
EndIf  ; PROVISIONER

If $SkillSet = "JEWELER" Then
   $Event0Colour = 2366223
   $Event1Colour = 1585018
   $Event2Colour = 7819594
   $Event3Colour = 9526081
EndIf  ; JEWELLER

If $SkillSet = "ALCHEMIST" Then
   $Event0Colour = 2366223
   $Event1Colour = 9066305
   $Event2Colour = 9197638
   $Event3Colour = 9327682
EndIf  ; ALCHEMIST


If $SkillSet = "APOTHECARY" Then
   $Event0Colour = 2366223
   $Event1Colour = 9197638
   $Event2Colour = 1585018
   $Event3Colour = 10309655
EndIf  ; APOTHECARY


EndIf  ; CPQ

MsgBox(0, "Skill Set is " , $SkillSet )

MsgBox(0, "Spell Set is " , $SpellSet )


; Section to identify screen locations first.
; find the location of the power window

$coord = PixelSearch ($PowerSearchX, $PowerSearchY , $PowerSearchX + 30, $PowerSearchY + 60 , $PowerBoxColour)
$errpix = @error
if $errpix = 0 then $PowerBoxX = $coord[0]
if $errpix = 0 then $PowerBoxY = $coord[1]

; now pop up and confirm the power location and return code

MsgBox(0, "Power Box Coords are : " &  $coord[0] & " , " & $coord[1] , "error status is " & $errpix )

; Sleep in case mouse shudders

 sleep(100)


; WRITE A SECTION HERE TO
; IDENTIFY THE RECIPE BOX LOCATION
;     FROM ITS BASE (FOR BACKGROUND)?





; find the location of the recipe window

$coord = PixelSearch ($RecipeSearchX, $RecipeSearchY , $RecipeSearchX + 30,   $RecipeSearchY + 60 , $RecipeBoxColour)
$errpix = @error

if $errpix = 0 then $RecipeBoxX = $coord[0]
if $errpix = 0 then $RecipeBoxY = $coord[1]


; now pop up and confirm the recipe location and return code

MsgBox(0, "Recipe Box Coords are : " &  $coord[0] & " , " & $coord[1] , "error status is " & $errpix )

; Sleep in case mouse shudders

sleep(100)



; *************************************
; *                                   *
; *            MOUSE TEST             *
; *                                   *
; *************************************

If $MouseTest = 1 then

; BEGIN BUTTON
    MouseMove( $BeginX, $BeginY )
    Sleep( $ShortInterval + INT( Random () * $halfsec ) )

; REPEAT BUTTON 
    MouseMove( $RepeatX, $RepeatY )
    Sleep( $ShortInterval + INT( Random () * $halfsec ) )

; SPELL BAR FOCUS  -  CLICK IT 
    MouseMove( $UncoverSpellX, $UncoverSpellY )
      Sleep( $ClickWait )
      MouseClick("left")
    Sleep( $ShortInterval + INT( Random () * $halfsec ) )

; PRIMARY PROGRESS SPELL
    MouseMove( $ProgressX, $ProgressY )
    Sleep( $ShortInterval + INT( Random () * $halfsec ) )

; PRIMARY DURABILITY SPELL
    MouseMove( $DurableX, $DurableY )
    Sleep( $ShortInterval + INT( Random () * $halfsec ) )

; RECIPE BAR FOCUS - CLICK IT
    MouseMove( $UncoverRecipeX, $UncoverRecipeY )
      Sleep( $ClickWait )
      MouseClick("left")
    Sleep( $ShortInterval + INT( Random () * $halfsec ) )

; RECIPES TEST EACH ONE - CLICK THEM 
    For $k = 1 to $HowManyRecipes 
      MouseMove( $RecipeX + ($k-1) * $RecipeXinc , $RecipeY )
        Sleep( $ClickWait )
        MouseClick("left")
      Sleep( $ShortInterval + INT( Random () * $halfsec ) )
    Next  ;  $k = 1 to $HowManyRecipes

; RETURN TO FIRST RECIPE - CLICK IT 
    MouseMove( $RecipeX , $RecipeY )
      MouseClick("left")
      Sleep( $ClickWait )
    Sleep( $ShortInterval + INT( Random () * $halfsec ) )


; RECOVERY INDICATOR LOCATION (HOVERS OVER DRINK DURATION)
    MouseMove( $RecoveryX, $RecoveryY )
    Sleep( $ShortInterval + INT( Random () * $halfsec ) )

; END INDICATOR LOCATION (NOW REDUNDANT)
    MouseMove( $EndX, $EndY )
    Sleep( $ShortInterval + INT( Random () * $halfsec ) )

EndIf ; $MouseTest

; ********* END OF MOUSE TEST *********



; *************************************
; *                                   *
; *         PRODUCTION RUN            *
; *                                   *
; *************************************

If $RunProduction = 1 then


; WAIT for full power 

  ProgressOn("Progress" , "Start Up - Waiting for Power" )


  $GotColour = PixelGetColor ( $PowerBoxX + $PowerOffsetX , $PowerBoxY + $PowerOffsetY )
  While $GotColour <> $PowerColour
    $GotColour = PixelGetColor ( $PowerBoxX + $PowerOffsetX , $PowerBoxY + $PowerOffsetY )
      if $GotColour = $PowerColour Then ProgressSet( 100, "GOT FULL POWER" )
      if $GotColour = $NoPowerColour Then ProgressSet( 0, "not full Power" )
    sleep ( 250 )
  Wend  ; While $PowerColour
  sleep ( 250 )


; ***** Main recipe loop *******


For $k = 1 to $HowManyRecipes


$HowManyItems = $Quantity[$k]
$HowManyDurables = $Cycles[$k]
$PushHold = $PushOrHold[$k]


; Select recipe

MouseMove( $UncoverRecipeX, $UncoverRecipeY )
  Sleep( $ClickWait )
  MouseClick("left")
Sleep( $ShortInterval + INT( Random () * $halfsec ) )

MouseMove( $RecipeX + ($k -1) * $RecipeXinc , $RecipeY )
  Sleep( $ClickWait )
  MouseClick("left")
Sleep( $ShortInterval + INT( Random () * $halfsec ) )

; Main creation loop

ProgressSet(0, " ", "Recipe " & $k & " of " & $HowManyRecipes  )
ProgressSet(0, "Completed " & 0 & " of " & $HowManyItems  )

For $i = 1 to $HowManyItems



; Uncover Spells
MouseMove( $UncoverSpellX, $UncoverSpellY )
  Sleep( $ClickWait )
  MouseClick("left")
Sleep( $ShortInterval + INT( Random () * $halfsec ) )

; Start Creation

; skip for first recipe

If $i > 1 then 

MouseMove( $RepeatX, $RepeatY )
  Sleep( $ClickWait )
  MouseClick("left")
Sleep( 200 )

EndIf ; $i > 1

ProgressSet((100*($i-0.5))/$HowManyItems, "Processing " & $i & " of " & $HowManyItems )

MouseMove( $BeginX, $BeginY )
  Sleep( $ClickWait )
  MouseClick("left")
Sleep( $ShortInterval + INT( Random () * $halfsec ) )


; short delay to get into cycle rather than be right at the start of each event 

sleep (300)


;   *********************************
;   *       MAIN TWIN Cycle Loop       *
;   *********************************

For $j = 1 to $HowManyDurables

  ;   CYCLE 1 

  ; TEST FOR RECIPE COMPLETION HERE
  ; IF COMPLETE THEN SKIP CYCLES AND FINISH LOOP

  $GotColour = PixelGetColor ( $RecipeBoxX + $RecipeOffsetX , $RecipeBoxY + $RecipeOffsetY )
  if $GotColour <> $CompleteColour then

   
    $GotColour = PixelGetColor ( $RecipeBoxX + $EventOffsetX , $RecipeBoxY + $EventOffsetY )
    $Reaction = -1
    if $GotColour = $Event0Colour then $Reaction = 0
    if $GotColour = $Event1Colour then $Reaction = 1
    if $GotColour = $Event2Colour then $Reaction = 2
    if $GotColour = $Event3Colour then $Reaction = 3
    ProgressSet((100*$i)/$HowManyItems, "Colour  :  " & $GotColour & "   REACTION  :  " & $Reaction  )

    If $Reaction = 2 then 
         MouseMove( $DurableX + $RecipeXinc, $DurableY, $MouseSpeed )
         Sleep( $ClickWait )
         MouseClick("left")
         Sleep( $ShortInterval  + INT( Random () * $halfsec ) )
    EndIf ; $Reaction = 2 

    If $Reaction = 3 then 
         MouseMove( $DurableX + $RecipeXinc + $RecipeXinc, $DurableY, $MouseSpeed )
         Sleep( $ClickWait )
         MouseClick("left")
         Sleep( $ShortInterval  + INT( Random () * $halfsec ) )
    EndIf ; $Reaction = 3

 
       ; push progress or push durability
       If $PushHold = 1 then MouseMove( $DurableX, $DurableY, $MouseSpeed )
       If $PushHold = 0 then MouseMove( $ProgressX, $ProgressY, $MouseSpeed ) 
          Sleep( $ClickWait )
          MouseClick("left")
       If $Reaction < 2 then Sleep( $ShortInterval + INT( Random () * $halfsec ) )
       If $Reaction > 1 then Sleep( $DurableInterval + INT( Random () * $halfsec ) )
 

    If $Reaction < 2 then  
       ; durability vs success chance
         MouseMove( $DurableX + $RecipeXinc, $DurableY, $MouseSpeed )
          Sleep( $ClickWait )
          MouseClick("left")
       Sleep( $DurableInterval + INT( Random () * $halfsec ) )
    Endif ; $Reaction < 2 then

  Endif ; if $GotColour <> $CompleteColour 



  ;   CYCLE 2

  ; TEST FOR RECIPE COMPLETION HERE AS WELL
  ; IF COMPLETE THEN SKIP CYCLES AND FINISH LOOP
 
  $GotColour = PixelGetColor ( $RecipeBoxX + $RecipeOffsetX , $RecipeBoxY + $RecipeOffsetY )
  if $GotColour <> $CompleteColour then

    $GotColour = PixelGetColor ( $RecipeBoxX + $EventOffsetX , $RecipeBoxY + $EventOffsetY )
    $Reaction = -1
    if $GotColour = $Event0Colour then $Reaction = 0
    if $GotColour = $Event1Colour then $Reaction = 1
    if $GotColour = $Event2Colour then $Reaction = 2
    if $GotColour = $Event3Colour then $Reaction = 3
    ProgressSet((100*$i)/$HowManyItems, "Colour  :  " & $GotColour & "   REACTION  :  " & $Reaction  )


    If $Reaction = 2 then 
         MouseMove( $DurableX + $RecipeXinc, $DurableY, $MouseSpeed )
         Sleep( $ClickWait )
         MouseClick("left")
         Sleep( $ShortInterval  + INT( Random () * $halfsec ) )
    EndIf ; $Reaction = 2 

    If $Reaction = 3 then 
         MouseMove( $DurableX + $RecipeXinc + $RecipeXinc, $DurableY, $MouseSpeed )
         Sleep( $ClickWait )
         MouseClick("left")
         Sleep( $ShortInterval  + INT( Random () * $halfsec ) )
    EndIf ; $Reaction = 3 


     ; push progress 
     MouseMove( $ProgressX, $ProgressY, $MouseSpeed  )
        Sleep( $ClickWait )
        MouseClick("left")
      If $Reaction < 2 then Sleep( $ShortInterval + INT( Random () * $halfsec ) )
      If $Reaction > 1 then Sleep( $DurableInterval + INT( Random () * $halfsec ) )

     If $Reaction < 2 then
       ; durability vs progress or durability vs success chance
       If $PushHold = 1 then MouseMove( $DurableX + $RecipeXinc + $RecipeXinc, $DurableY, $MouseSpeed )
       If $PushHold = 0 then MouseMove( $DurableX + $RecipeXinc, $DurableY, $MouseSpeed ) 
          Sleep( $ClickWait )
          MouseClick("left")
       Sleep( $DurableInterval + INT( Random () * $halfsec ) )
    Endif ; $Reaction < 2 then

  Endif ; if $GotColour <> $CompleteColour 

  ; AND TEST FOR COMPLETION AT THE END OF THE CYCLE AS WELL 
  ; THIS IS WHERE THE CYCLE LOOP IS BROKEN

  $GotColour = PixelGetColor ( $RecipeBoxX + $RecipeOffsetX , $RecipeBoxY + $RecipeOffsetY )
  if $GotColour = $CompleteColour then $j = $HowManyDurables + 1

; $BatchCount = $BatchCount + 1
; If $BatchSize > 0 then 
;   If $BatchCount > $BatchSize -1 then
;     MsgBox(0, "Batch Pause " , "Batch Size 1s " & $BatchSize )
;     $BatchCount =0 
;   EndIf ;  $BatchCount > $BatchSize -1
; Endif ; $BatchSize > 0

Next  ; $j = 1 to $HowManyDurables

;   *********************************
;   *   End of MAIN TWIN Cycle Loop    *
;   *********************************



ProgressSet((100*$i)/$HowManyItems, "Completed " & $i & " of " & $HowManyItems )

MouseMove( $RecoveryX, $RecoveryY )

; Now Include an Interuptable Wait 

sleep( $InteruptWait )

; Now WAIT for full power to be restored 

  $GotColour = PixelGetColor ( $PowerBoxX + $PowerOffsetX , $PowerBoxY + $PowerOffsetY )

  While $GotColour <> $PowerColour

    $GotColour = PixelGetColor ( $PowerBoxX + $PowerOffsetX , $PowerBoxY + $PowerOffsetY )
      if $GotColour = $PowerColour Then ProgressSet( 100, "GOT FULL POWER after " _
         & $i & " of " & $HowManyItems)
      if $GotColour = $NoPowerColour Then ProgressSet( 0, "Waiting for Full Power after " _
         & $i & " of " & $HowManyItems)
    sleep ( 250 )

  Wend  ; While $PowerColour

sleep ( 250 )


Next  ; $i = 1 to $HowManyItems


; in here now have to add push recipes button so recipe is switched

MouseMove( $RecipesX, $RecipesY )
  Sleep( $ClickWait )
  MouseClick("left")
Sleep( 200 )



Next  ;  $k = 1 to $HowManyRecipes



EndIf ; $RunProduction  



MouseMove( $EndX, $EndY )
CDTray("E:", "open")








