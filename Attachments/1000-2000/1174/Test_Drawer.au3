Global $PixelDrawDC
Global $PixelDrawhwnd

PixelDrawConstructor($PixelDrawhwnd, "Creating game")
While 1
   TextDraw($PixelDrawhwnd, 100, 100, "text", 0xFF0000)
   PixelDraw ($PixelDrawhwnd,100,120, 0xFFFFFF)
   PixelDraw ($PixelDrawhwnd,100,121, 0xFFFFFF)
   PixelDraw ($PixelDrawhwnd,100,122, 0xFFFFFF)
   PixelDraw ($PixelDrawhwnd,100,123, 0xFFFFFF)
   PixelDraw ($PixelDrawhwnd,100,124, 0xFFFFFF)
   PixelDraw ($PixelDrawhwnd,100,125, 0xFFFFFF)
   PixelDraw ($PixelDrawhwnd,100,126, 0xFFFFFF)
   PixelDraw ($PixelDrawhwnd,100,127, 0xFFFFFF)
   PixelDraw ($PixelDrawhwnd,100,128, 0xFFFFFF)
   PixelDraw ($PixelDrawhwnd,100,129, 0xFFFFFF)
   Sleep(10)
WEnd
PixelDrawConstructor($PixelDrawDC, "Diablo II - MPQ3")

PixelDraw($PixelDrawDC, 300, 300, 0x000000)
PixelDraw($PixelDrawDC, 300, 301, 0x000000)
PixelDraw($PixelDrawDC, 300, 302, 0x000000)
PixelDraw($PixelDrawDC, 300, 303, 0x000000)
$return = GetPixel($PixelDrawDC, 300, 300)

PixelDrawDestructor($PixelDrawDC)
MsgBox("","", $return[0])

Sleep(1000)
;While 1
;   PixelDrawConstructor($PixelDrawhwnd, "Brood War")
;   TextDraw($PixelDrawhwnd, 0, 0, _NowTime(), 0xFFFFFF)
;   Sleep ( 3 )
;WEnd

#CS
DllCall ("user32.dll", "ptr", "LoadImage", "ptr", $PixelDrawhwnd[0],  "str", $hwnd[0])

HANDLE LoadImage(      

    HINSTANCE hinst,
    LPCTSTR lpszName,
    UINT uType,
    int cxDesired,
    int cyDesired,
    UINT fuLoad
);
#CE

#CS
While 1
   ;TextDraw($PixelDraw, 100, 100, "text", 0xFF0000)
   SetPixel ($PixelDrawhwnd,5,5, 0xFFFFFF)
   SetPixel ($PixelDrawhwnd,5,6, 0xFFFFFF)
   SetPixel ($PixelDrawhwnd,5,7, 0xFFFFFF)
   SetPixel ($PixelDrawhwnd,5,8, 0xFFFFFF)
   SetPixel ($PixelDrawhwnd,5,9, 0xFFFFFF)
   SetPixel ($PixelDrawhwnd,5,10, 0xFFFFFF)
   SetPixel ($PixelDrawhwnd,5,11, 0xFFFFFF)
   SetPixel ($PixelDrawhwnd,5,12, 0xFFFFFF)
   SetPixel ($PixelDrawhwnd,5,13, 0xFFFFFF)
   SetPixel ($PixelDrawhwnd,5,14, 0xFFFFFF)
   PixelDrawDestructor ($PixelDrawhwnd)
   Sleep(10)
WEnd
#CE

Func SetPixel ($hwnd, $x, $y, $color)
   $setpixel= DllCall ("gdi32.dll", "long", "SetPixel", "long", $hwnd[1], "long", $x, "long", $y, "long", $color)
EndFunc

Func PixelDrawDestructor ($DLLHandle)
   DllCall ("user32.dll", "int", "ReleaseDC", "hwnd", 0,  "int", $DLLHandle[1])
EndFunc

Func PixelDrawConstructor(ByRef $DLLHandle, $WindowTitle)
   $DLLHandle = DllCall ("user32.dll", "int", "GetDC", "hwnd", WinGetHandle($WindowTitle, ""))
EndFunc

Func GetPixel($DLLHandle, $x, $y)
   return DllCall( "gdi32", "int", "GetPixel", "ptr", $DLLHandle[1], "int", $x, "int", $y )
EndFunc

;COLORREF GetPixel(
;  HDC hdc,    // handle to DC
;  int nXPos,  // x-coordinate of pixel
;  int nYPos   // y-coordinate of pixel
;);

Func PixelDraw($DLLHandle, $XCoord, $YCoord, $Color, $hwnd="GetDC")
   DllCall("gdi32","long","SetPixel", "long", $DLLHandle[1], "long", $XCoord, "long", $YCoord, "long", $Color)
   If @error = 1 Then
      Return 0
   Else
      Return 1
   EndIf
EndFunc

Func TextDraw($DLLHandle, $XCoord, $YCoord, $String, $Color, $hwnd="GetDC")
   DllCall("gdi32", "int", "AddFontResource", "str", "Halo11.ttf" )
   If @error = 1 Then MsgBox("","","")
   
   DllCall("gdi32","long","TextOut", "long", $DLLHandle[0], "int", $XCoord, "int", $YCoord, "str", $String, "int", StringLen( $String ) )
   
   DllCall("gdi32", "int", "SetTextColor", "long", $DLLHandle[0], "int", $Color )
   
   DllCall("gdi32", "int", "RemoveFontResource", "str", "Halo11.ttf" )

EndFunc

Func DrawRectangle($xstart, $ystart, $xend, $yend, $color)
  For $x = $xstart to $xend
     For $y = $ystart to $yend
        PixelDraw($PixelDraw, $x, $y, $color)
     Next
  Next
EndFunc

#CS
TextOut(
  HDC hdc,           // handle to DC
  int nXStart,       // x-coordinate of starting position
  int nYStart,       // y-coordinate of starting position
  LPCTSTR lpString,  // character string
  int cbString       // number of characters
);

COLORREF SetTextColor(
  HDC hdc,           // handle to DC
  COLORREF crColor   // text color
);
#CE

;While 1
;   PixelDraw(500,500, 0x000000);, "Keys.txt - Notepad")
;   PixelDraw(500,501, 0x000000);, "Keys.txt - Notepad")
;   PixelDraw(500,502, 0x000000);, "Keys.txt - Notepad")
;   PixelDraw(500,503, 0x000000);, "Keys.txt - Notepad")
;   PixelDraw(500,504, 0x000000);, "Keys.txt - Notepad")
;   Sleep(10)
;WEnd