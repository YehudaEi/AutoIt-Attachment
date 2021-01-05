   ;===========================================================================
   ; Settings
   ;===========================================================================
Opt("MustDeclareVars", 1)
Opt("WinTitleMatchMode", 2)
Opt("TrayIconDebug", 1)

   ;===========================================================================
   ; Includes
   ;===========================================================================
#include <Character Definitions.au3>

   ;===========================================================================
   ; Setting hotkeys
   ;===========================================================================
HotKeySet("{PAUSE}", "end")

   ;===========================================================================
   ; Testing OCR
   ;===========================================================================
Local $Find, $i, $var, $e, $distx, $disty, $File, $String, $DistanceString, $Line, $Pixel

WinActivate("Paint")

Sleep(1000)

$File = FileOpen( "output.txt", 2 )

; Colors:
;  White    = 12895428
;  Blue     = 5263532






; COORDINATES / PIXEL HERE:
$Pixel = 5263532
$Line = GetLines( 61, 42, 629, 100, $Pixel )









For $LineNum = 1 to $Line[0][0]
   $Find = GetCharacters ( $Line[$LineNum][0], $Line[$LineNum][1], $Line[$LineNum][2], $Line[$LineNum][3], $Pixel )

   Local $String = ""
   
   Dim $DistanceString[$Find[0][0]+1]
   
   For $i = 1 to $Find[0][0]
      ; Finds every pixel in the square
      $var = _GetAllPixels($Find[$i][0], $Find[$i][1], $Find[$i][2], $Find[$i][3], $Pixel )
     
      ; Dim'ing an array the size of the pixels found to record each value
   ;   Dim $DistanceString[$Var[0][0]]
     
      ; For every value, write the distance from StartX/StartY to
      ; FoundX/FoundY of each pixel
   
      For $e = 1 to $Var[0][0]
         $distx = $Find[$i][0] - $Var[$e][0]
         $disty = $Find[$i][1] - $Var[$e][1]
   
         ; Making one big long string for the letter
         $DistanceString[$i] = $DistanceString[$i] & $distx & "," & $disty & ";"
      Next
     
      ; For some strange reason there was a 0 at the beggining of each string;
      ; this gets rid of it.
      $DistanceString[$i] = StringTrimLeft ( $DistanceString[$i], 5 )
     
      For $x = 1 to UBound($arCharacters) - 1
         If $arCharacters[$x][1] == $DistanceString[$i] Then
            $String = $String & $arCharacters[$x][0]
         EndIf
      Next   
      
      ;If $i > 1 AND $Find[$i][0]-$Find[$i-1][0] > 10 Then
      ;; Found a space inbetween letters
      ;   FileWriteLine( $File, "Space")
      ;EndIf
      
      ;FileWriteLine( $File, $String[$i] & "=" & $DistanceString[$i])
   Next
   
   MsgBox("","", $String)
   
   FileWriteLine( $File, $String )
Next

FileClose($File)

   ;===========================================================================
   ; Functions
   ;===========================================================================
Func _GetAllPixels($StartX, $StartY, $EndX, $EndY, $Color)
   Local $aCoord, $Length, $Width, $Area,_
         $i, $x, $y, $CurrentElement = 1
  
   ; Get area of rectangle to initiate array
   $Length = Abs($StartX - $EndX)
   $Width = Abs($StartY - $EndY)
   $Area = $Length * $Width
   Dim $aReturn[$Area + 1][2]

   ; Search inside rectangle for the pixel
   For $x = $StartX to $EndX
      For $y = $StartY to $EndY
         If PixelGetColor( $x, $y) = $Color Then
            $aReturn[$CurrentElement][0] = $x
            $aReturn[$CurrentElement][1] = $y 
            $CurrentElement = $CurrentElement + 1
         EndIf
      Next
   Next

   ReDim $aReturn[$CurrentElement][2]
   $aReturn[0][0] = $CurrentElement - 1
   
   Return $aReturn
EndFunc

Func GetLines($StartX, $StartY, $EndX, $EndY, $Color)
   Local $arLineCheck = 0, $intElement = 1, $FirstFound = 0
   Dim $arNewLine[255][4]
   
   #CS
   DEBUG
   $arStartCoord[0] = 
   
   $arStartCoord = PixelSearch ($StartX, $StartY, $EndX, $EndY, $Color)
   MsgBox("","", $arStartCoord[0] & ", " & $arStartCoord[1])
   If @error = 1 Then
      SetError(1)
      Return
   EndIf
   
   $arNewLine[$intElement][0] = $arStartCoord[0]
   $arNewLine[$intElement][1] = $arStartCoord[1]    
   #CE
   
   
   While $StartY < $EndY
      ;Scan 1 pixel line
      
      ;debug
      ;MouseMove( $StartX, $StartY, 0)
      ;Sleep(500)
      ;MouseMove( $StartX, $StartY+100, 0)
      $arLineCheck = PixelSearch ($StartX, $StartY, $EndX, $StartY, $Color)
      
      ; Find first line
      If @error = 0 AND $FirstFound = 0 Then    
         $arNewLine[$intElement][0] = $StartX
         $arNewLine[$intElement][1] = $arLineCheck[1]
         
         $FirstFound = 1
      EndIf
         
      ; If nothing found, set end of line
      If @error = 1 AND $FirstFound > 0 Then        
         $arNewLine[$intElement][2] = $EndX
         $arNewLine[$intElement][3] = $StartY 

         $intElement = $intElement + 1;
         
         $FirstFound = 0
         #CS
         ; Looking for another line within 15 pixels
         $arLineCheck = PixelSearch ($StartX, $StartY, $EndX, $StartY+15, $Color)
         
         ; If something is found, add it
         If @error = 0 Then
            ; Reset the new Y coordinate start point for line search
            $arLineCheck[1] = $StartY
            
            $arNewLine[$intElement][0] = $arLineCheck[0] 
            $arNewLine[$intElement][1] = $arLineCheck[1]
         EndIf
         #CE
      EndIf
      
      $StartY = $StartY + 1;
   WEnd
   
   $arNewLine[0][0] = $intElement - 1
   ReDim $arNewLine[$intElement][4]
   
   Return $arNewLine
EndFunc

Func GetCharacters($StartX, $StartY, $EndX, $EndY, $Color, $Height = 12, $Width = 12)
   Local $vSearchCoord, $vCharacter = 2, $vLineCheck, $FirstCheck
   Dim   $vCharCheck, $aNewCharacter[255][4]
   
   $vSearchCoord = PixelSearch ($StartX, $StartY, $EndX, $EndY, $Color)
   
   If @error = 1 Then
      SetError(1)
      Return
   EndIf
   
; If no pixel found, scan again
; If pixel not found again then add
   
   $aNewCharacter[1][0] = $vSearchCoord[0] 
   $aNewCharacter[1][1] = $vSearchCoord[1]
   
   ;Check for a line between characters to differ between them
   While $vSearchCoord[0] < $EndX
      $vSearchCoord[0] = $vSearchCoord[0] + 1
      $vLineCheck = PixelSearch ($vSearchCoord[0], $StartY, $vSearchCoord[0]+1, $EndY, $Color)
      
      #CS
      ; Check for another character can be interrupted by a gap in pixels in a character
      ; so I check for TWO pixels between each character
      
      If @error = 1 Then $FirstCheck = 1

      $vLineCheck = PixelSearch ($vSearchCoord[0]+1, $vSearchCoord[1], $vSearchCoord[0]+1, $vSearchCoord[1]+$Height, $Color)
      #CE
      If @error = 1 OR $FirstCheck = 1 Then
         ; Nothing found:
         ;     Adding end of character coord
         ;     Finding next character within $Height x $Width pixels
         
         ; Debugging stuff:
         ;  MouseMove( $vSearchCoord[0] , $vSearchCoord[1], 0 )
         ;  Sleep(2000)
         
         $vLineCheck = PixelSearch ($vSearchCoord[0], $StartY, $vSearchCoord[0]+$Width, $EndY, $Color)
         $aNewCharacter[$vCharacter-1][2] = $vSearchCoord[0]
         $aNewCharacter[$vCharacter-1][3] = $EndY
         
         ; Looking for another character in X by Y area
         ; If something is found, add it
         If @error = 0 Then
            
            ; Debugging stuff:
            ;  MouseMove( $vLineCheck[0] , $vLineCheck[1], 0 )
            ;  Sleep(2000)
            ;  MouseMove( 500 , 500, 0 )
            
            ; Reset the new X coordinate start point for line search
            $vSearchCoord[0] = $vLineCheck[0]
            
            $aNewCharacter[$vCharacter][0] = $vLineCheck[0] 
            $aNewCharacter[$vCharacter][1] = $vLineCheck[1]
            
            $vCharacter = $vCharacter + 1
         EndIf
      EndIf
   WEnd
   
   $aNewCharacter[0][0] = $vCharacter - 1
   ReDim $aNewCharacter[$vCharacter][4]
   
   Return $aNewCharacter
EndFunc

Func End()
   Exit
EndFunc 