Opt('MustDeclareVars', 1)
Opt('WinTitleMatchMode', 4)
Opt("TrayIconDebug", 1)
Opt("CaretCoordMode", 2)
Opt("MouseCoordMode", 2)
Opt("PixelCoordMode", 2)
#cs
 GWAA.au3

 Guild Wars Attack Assistant

 Assists in switching targets once the current target has been killed.

 Press the 'v' key to toggle GWAA on or off. GWAA will automatically switch
 itself off if there are no targetable enemies within range.

 Has ability to pick up items dropped after an enemy is vanquished. Not 100%
 reliable by any means, but not the main purpose of the script either.

 Tested only in windowed mode; don't know if it'll work fullscreen or not.
 Start this script only after GW is running and you've entered the game with
 a character. After that it will continue to function as long as the GW
 program is running. Exit and restart it if you resize the GW window however.

 Version history:

   1.0 - Initial release

#ce
; ---------- Start user-configurable section ----------
;
; These are the red color in the healthbar in the top center of the GW window (default
; position, anyway). The colors noted here are the ones I found playing GW on a couple
; of different machines. Note also that this is the top row of red in the bar (as the
; color changes slightly over its height). We look for the first match of one of these
; colors in the top 20% of the window.
; If you find the color on your GW client is different, add it to the beginning of
; this array (use AutoIt3's Info Tool to find the right value to add).
Global Const $TargetHealthColors[2] = [0xcd0505, 0xad0504]
; Same here: if the color of items to pick up is different for you, change this.
; You'll probably want to do what I did here and list all the gold colors first,
; followed by purples, blues, and finally white (for the money if nothing else).
; Note: can't put greens here because that's the same color as your groupmates.
Global Const $ItemTextColors[4] = [0xffcc55, _ ; gold
                                   0xaa88ee, _ ; purple
                                   0x99eeff, _ ; blue
                                   0xfefefe _  ; white
                                  ]
; Change this to some other key if you don't like the one I use.
Global Const $HotKeyKey = 'v'
; Change this to false if you don't want the script to try to pick up any nearby
; items in the midst of battle.
Global Const $Grab = True
;
; ---------- End user-configurable section ----------
; ---------- You shouldn't need to change anything below this point ----------
;
Global Const $sTitle = "Guild Wars"
;
If WinExists(@ScriptName) Then Exit
AutoItWinSetTitle(@ScriptName) ; Make sure only one instance is running
;
Global $aClientSize, $TargetBoxColor, $TargetLoc
Global $bAttackMode = False, $PID
Local $iNotFoundCount = 0
Setup()
;debugit
While True
   If Not ProcessExists($PID) Then ExitLoop ; GW client is gone, so we're outa here
   If $bAttackMode Then
      ;debugit
      If (PixelGetColor($TargetLoc[0],$TargetLoc[1]) = $TargetBoxColor) Then
         $iNotFoundCount = 0
      Else
         $iNotFoundCount += 1
         If $iNotFoundCount > 2 Then
            ToggleAttackMode()
            $iNotFoundCount = 0
         Else
            If $Grab Then PickupItem()
            If WinActive($sTitle) Then Send('c{SPACE}')
         EndIf
      EndIf
      ;debugit
   EndIf
   Sleep(100)
Wend
Exit
;debugit
;
Func ToggleAttackMode()
   If Not WinActive($sTitle) Then Return
   $bAttackMode = Not $bAttackMode
   If $bAttackMode Then
      Send('c{SPACE}')
	 	TrayTip(@ScriptName,'AttackMode = on',5)
	Else
      Send('{s DOWN}')
      Sleep(300)
      Send('{s UP}')
	 	TrayTip(@ScriptName,'AttackMode = off',5)
   EndIf
EndFunc

Func Setup()
   Local $x, $i
   $PID = ProcessExists("gw.exe")
   $aClientSize = WinGetClientSize($sTitle) ; [0]=width, [1]=height
   If $aClientSize = 0 Then
      $x = MsgBox(0, @ScriptName, 'Could not get window size of GW Client! Check you are in windowed mode.', 30)
      Exit
   EndIf
   If Not HotKeySet($HotKeyKey, 'ToggleAttackMode') Then
      $x = MsgBox(0, @ScriptName, 'HotKey could not be set (' & $HotKeyKey & ')!', 30)
      Exit
   EndIf
   WinActivate($sTitle)
   Send('y') ; target self
   Sleep(500)
   For $i = 0 To UBound($TargetHealthColors)-1
      $TargetBoxColor = $TargetHealthColors[$i]
      $x = PixelSearch(0, 0, $aClientSize[0], 2 * $aClientSize[1] / 10, $TargetBoxColor)
      If IsArray($x) Then
         $TargetLoc = $x
         ExitLoop
      EndIf
   Next
   If Not IsArray($TargetLoc) Then
      ; none of the colors matched, so we can't continue.
      $x = MsgBox(0, @ScriptName, 'Could not determine location of target box! Check you are not poisoned or bleeding then try again.', 30)
      Exit
   EndIf
   ; Now that we've identified the location of the target box, we don't want to use
   ; this position because its color changes depending on whether the mob is poisoned,
   ; bleeding, or whatever. So, we'll use the color of the pixel that is one pixel
   ; up and to the left, which has been found to not change color because ot the mob's
   ; condition.
   $TargetLoc[0] -= 1
   $TargetLoc[1] -= 1
   $TargetBoxColor = PixelGetColor($TargetLoc[0],$TargetLoc[1])
   ; This just shows us where the point was that we are using as reference.
   MouseMove($TargetLoc[0], $TargetLoc[1], 1)
EndFunc

; Look around where the player is standing for the text color of a dropped item.
; We don't use the hotkeys because they can pick up on items that are a long ways away
; and/or in the middle of other mobs.
; Attempts to pick up the first item found, so our colors are listed in the array from
; most valuable (gold) to the least (white). Note: can't do greens.
Func PickupItem()
   Local $i, $x
   Sleep(100)
   For $i = 0 To UBound($ItemTextColors) - 1
      $x = PixelSearch(4 * $aClientSize[0] / 10, 5 * $aClientSize[1] / 10, 6 * $aClientSize[0] / 10, 7 * $aClientSize[1] / 10, $ItemTextColors[$i])
      If IsArray($x) Then
         MouseClick("Left", $x[0], $x[1], 1)
         Sleep(1500)
         Return True
      EndIf
   Next
   Return False
EndFunc
