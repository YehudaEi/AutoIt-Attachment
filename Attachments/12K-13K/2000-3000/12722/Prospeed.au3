#CS 
UDF name      ;  Image manipulation
Author        ;  JPAM van der Ouderaa
Email         ;  jpamvanderouderaa@wanadoo.nl
Contributions ;  Frank Abbing for creating Prospeed.dll
#CE

#include-once

Local $S_DLL

#CS 
	Effect Blur 
	syntax : blur("PICTURE", POS X, POS Y, VALUE EFFECT)	
	Note ; "PICTURE" = path to picturefile can be (.bmp, .jpg, .gif, .png, .wmf)
			POS X and POS Y are the position's where the picture is copy to the window
			VALUE EFFECT = 1 to 256  ; higher is more effect
#CE
Func blur($s_File, $S_POSX, $S_POSY, $S_VALUE)
	$S_DLL = DllOpen("ProSpeed.dll")
	Local $InitExtFX[1]
	$WIN_TILLE = WinGetTitle("","")
	$WIN_GETHANDLE = WinGetHandle($WIN_TILLE,"")
	$RAW_HDC = DllCall("user32.dll","ptr","GetWindowDC","hwnd",$WIN_GETHANDLE)
	$hDC     = "0x" & Hex($RAW_HDC[0])
	
	$S_PIC = DllCall($S_DLL,"long","LoadExtImage","str",$s_File,"long",$hDC)
	$S_WIDTH = DllCall($S_DLL,"long","GetBmpWidth","long",$S_PIC[0])
	$S_HEIGHT = DllCall($S_DLL,"long","GetBmpHeight","long",$S_PIC[0])
	
	DllCall($S_DLL,"long","CopyExtBmp","long",$hDC,"long",$S_POSX,"long",$S_POSY,"long",$S_WIDTH[0],"long",$S_HEIGHT[0],"long",$S_PIC[0],"long",0,"long",0,"long",0)
	$S_InitExtFX = DllCall($S_DLL,"long","InitExtFX","long",$S_PIC[0])
	
	For $S_i = 1 To $S_VALUE
		DllCall($S_DLL,"long","Blur","long",$hDC,"long",$S_POSX,"long",$S_POSY,"long",$S_InitExtFX[0])
	Next
	DllCall($S_DLL,"long","FreeExtBmp","long",$S_PIC[0])
	DllClose($S_DLL)
EndFunc

#CS 
	Effect Sharpen 
	syntax : Sharpen("PICTURE", POS X, POS Y, VALUE EFFECT)
	Note ; "PICTURE" = path to picturefile can be (.bmp, .jpg, .gif, .png, .wmf)
			POS X and POS Y are the position's where the picture is copy to the window
			VALUE EFFECT = 1 to 256  ; higher is more effect
#CE
Func Sharpen($S_File, $S_POSX, $S_POSY, $S_VALUE)
	$S_DLL = DllOpen("ProSpeed.dll")
	Local $S_InitExtFX[1]
	$WIN_TILLE = WinGetTitle("","")
	$WIN_GETHANDLE = WinGetHandle($WIN_TILLE,"")
	$RAW_HDC = DllCall("user32.dll","ptr","GetWindowDC","hwnd",$WIN_GETHANDLE)
	$hDC     = "0x" & Hex($RAW_HDC[0])
	
	$S_PIC = DllCall($S_DLL,"long","LoadExtImage","str",$S_File,"long",$hDC)
	$S_WIDTH = DllCall($S_DLL,"long","GetBmpWidth","long",$S_PIC[0])
	$S_HEIGHT = DllCall($S_DLL,"long","GetBmpHeight","long",$S_PIC[0])
	
	DllCall($S_DLL,"long","CopyExtBmp","long",$hDC,"long",$S_POSX,"long",$S_POSY,"long",$S_WIDTH[0],"long",$S_HEIGHT[0],"long",$S_PIC[0],"long",0,"long",0,"long",0)
	$S_InitExtFX = DllCall($S_DLL,"long","InitExtFX","long",$S_PIC[0])
	
	For $S_i = 1 To $S_VALUE
		DllCall($S_DLL,"long","Sharpen","long",$hDC,"long",$S_POSX,"long",$S_POSY,"long",$S_InitExtFX[0])
	Next
	DllCall($S_DLL,"long","FreeExtBmp","long",$S_PIC[0])
	DllClose($S_DLL)
EndFunc

#CS 
	Effect Darken 
	syntax : Darken("PICTURE", POS X, POS Y, VALUE EFFECT)
	Note ; "PICTURE" = path to picturefile can be (.bmp, .jpg, .gif, .png, .wmf)
			POS X and POS Y are the position's where the picture is copy to the window
			VALUE EFFECT = 1 to 256  ; higher is more effect
#CE
Func Darken($S_File, $S_POSX, $S_POSY, $S_VALUE)
	$S_DLL = DllOpen("ProSpeed.dll")
	Local $S_InitExtFX[1]
	$WIN_TILLE = WinGetTitle("","")
	$WIN_GETHANDLE = WinGetHandle($WIN_TILLE,"")
	$RAW_HDC = DllCall("user32.dll","ptr","GetWindowDC","hwnd",$WIN_GETHANDLE)
	$hDC     = "0x" & Hex($RAW_HDC[0])
	
	$S_PIC = DllCall($S_DLL,"long","LoadExtImage","str",$S_File,"long",$hDC)
	$S_WIDTH = DllCall($S_DLL,"long","GetBmpWidth","long",$S_PIC[0])
	$S_HEIGHT = DllCall($S_DLL,"long","GetBmpHeight","long",$S_PIC[0])
	
	DllCall($S_DLL,"long","CopyExtBmp","long",$hDC,"long",$S_POSX,"long",$S_POSY,"long",$S_WIDTH[0],"long",$S_HEIGHT[0],"long",$S_PIC[0],"long",0,"long",0,"long",0)
	$S_InitExtFX = DllCall($S_DLL,"long","InitExtFX","long",$S_PIC[0])
	
	For $S_i = 1 To $S_VALUE
		DllCall($S_DLL,"long","Darken","long",$hDC,"long",$S_POSX,"long",$S_POSY,"long",$S_InitExtFX[0],"long",1)
	Next
	DllCall($S_DLL,"long","FreeExtBmp","long",$S_PIC[0])
	DllClose($S_DLL)
EndFunc

#CS 
	Effect Lighten 
	syntax : Lighten("PICTURE", POS X, POS Y, VALUE EFFECT)
	Note ; "PICTURE" = path to picturefile can be (.bmp, .jpg, .gif, .png, .wmf)
			POS X and POS Y are the position's where the picture is copy to the window
			VALUE EFFECT = 1 to 256  ; higher is more effect
#CE
Func Lighten($s_File, $S_POSX, $S_POSY, $S_VALUE)	
	$S_DLL = DllOpen("ProSpeed.dll")
	Local $S_InitExtFX[1]
	$WIN_TILLE = WinGetTitle("","")
	$WIN_GETHANDLE = WinGetHandle($WIN_TILLE,"")
	$RAW_HDC = DllCall("user32.dll","ptr","GetWindowDC","hwnd",$WIN_GETHANDLE)
	$hDC     = "0x" & Hex($RAW_HDC[0])
	
	$S_PIC = DllCall($S_DLL,"long","LoadExtImage","str",$S_File,"long",$hDC)
	$S_WIDTH = DllCall($S_DLL,"long","GetBmpWidth","long",$S_PIC[0])
	$S_HEIGHT = DllCall($S_DLL,"long","GetBmpHeight","long",$S_PIC[0])
	
	DllCall($S_DLL,"long","CopyExtBmp","long",$hDC,"long",$S_POSX,"long",$S_POSY,"long",$S_WIDTH[0],"long",$S_HEIGHT[0],"long",$S_PIC[0],"long",0,"long",0,"long",0)
	$S_InitExtFX = DllCall($S_DLL,"long","InitExtFX","long",$S_PIC[0])
	
	For $S_i = 1 To $S_VALUE
		DllCall($S_DLL,"long","Lighten","long",$hDC,"long",$S_POSX,"long",$S_POSY,"long",$S_InitExtFX[0],"long",1)
	Next	
	DllCall($S_DLL,"long","FreeExtBmp","long",$S_PIC[0])
	DllClose($S_DLL)
EndFunc

#CS 
	Effect Black_White 
	syntax : Black_White("PICTURE", POS X, POS Y, VALUE EFFECT)
	Note ; "PICTURE" = path to picturefile can be (.bmp, .jpg, .gif, .png, .wmf)
			POS X and POS Y are the position's where the picture is copy to the window
			VALUE EFFECT = 1 to 256  ; higher is more effect
#CE
Func Black_White($s_File, $S_POSX, $S_POSY, $S_VALUE)
	$S_DLL = DllOpen("ProSpeed.dll")
	Local $S_InitExtFX[1]
	$WIN_TILLE = WinGetTitle("","")
	$WIN_GETHANDLE = WinGetHandle($WIN_TILLE,"")
	$RAW_HDC = DllCall("user32.dll","ptr","GetWindowDC","hwnd",$WIN_GETHANDLE)
	$hDC     = "0x" & Hex($RAW_HDC[0])
	
	$S_PIC = DllCall($S_DLL,"long","LoadExtImage","str",$S_File,"long",$hDC)
	$S_WIDTH = DllCall($S_DLL,"long","GetBmpWidth","long",$S_PIC[0])
	$S_HEIGHT = DllCall($S_DLL,"long","GetBmpHeight","long",$S_PIC[0])
	
	DllCall($S_DLL,"long","CopyExtBmp","long",$hDC,"long",$S_POSX,"long",$S_POSY,"long",$S_WIDTH[0],"long",$S_HEIGHT[0],"long",$S_PIC[0],"long",0,"long",0,"long",0)
	$S_InitExtFX = DllCall($S_DLL,"long","InitExtFX","long",$S_PIC[0])
	
	Select
		Case $S_VALUE <127
			For $S_i = 127 To $S_VALUE Step -1
				DllCall($S_DLL,"long","BlackWhite","long",$hDC,"long",$S_POSX,"long",$S_POSY,"long",$S_InitExtFX[0],"long",$S_i)
			Next
		Case $S_VALUE >127
			For $S_i = 127 To $S_VALUE
				DllCall($S_DLL,"long","BlackWhite","long",$hDC,"long",$S_POSX,"long",$S_POSY,"long",$S_InitExtFX[0],"long",$S_i)
			Next
	EndSelect
	DllCall($S_DLL,"long","FreeExtBmp","long",$S_PIC[0])
	DllClose($S_DLL)
EndFunc

#CS 
	Effect Semi_trans 
	syntax : Semi_trans("PICTURE1", "PICTURE2", POS X, POS Y, Semi trans PICTURE1, Semi trans PICTURE2, Effect speed)	
	Note ; "PICTURE" = path to picturefile can be (.bmp, .jpg, .gif, .png, .wmf)
			PICTURE1 & PICTURE2 must have same dimensions widht and height
			POS X and POS Y are the position's where the picture is copy to the window
			Semi trans PICTURE1 value between 1 and 100
			Semi trans PICTURE2 value between 1 and 100
			Effect speed 1 to ? ; 1 is very fast
#CE
Func Semi_trans($S_FILE1, $S_FILE2, $S_POSX, $S_POSY, $S_VALUE1, $S_VALUE2, $S_SPEED)
	$S_DLL = DllOpen("ProSpeed.dll")
	Local $S_InitExtFX[1]
	$WIN_TILLE = WinGetTitle("","")
	$WIN_GETHANDLE = WinGetHandle($WIN_TILLE,"")
	$RAW_HDC = DllCall("user32.dll","ptr","GetWindowDC","hwnd",$WIN_GETHANDLE)
	$hDC     = "0x" & Hex($RAW_HDC[0])
	
	$S_FXHANDLE1 = DllCall($S_DLL,"long","LoadExtImage","str",$S_FILE1,"long",$hDC)	
	$S_FXHANDLE2 = DllCall($S_DLL,"long","LoadExtImage","str",$S_FILE2,"long",$hDC)  
	$S_WIDTH = DllCall($S_DLL,"long","GetBmpWidth","long",$S_FXHANDLE1[0])
	$S_HEIGHT = DllCall($S_DLL,"long","GetBmpHeight","long",$S_FXHANDLE1[0])

	$S_bytearray1 = DllCall($S_DLL,"long","InitExtFX","long",$S_FXHANDLE1[0])                        
	$S_bytearray2 = DllCall($S_DLL,"long","InitExtFX","long",$S_FXHANDLE2[0])                      
	
	Select
		Case $S_VALUE1 > $S_VALUE2
			For $S_i = $S_VALUE1 To $S_VALUE2 Step -1
				DllCall($S_DLL,"long","SemiTrans","long",$hDC,"long",$S_POSX,"long",$S_POSY,"long",$S_bytearray1[0],"long",$S_bytearray2[0],"long",$S_i)        
				Sleep($S_SPEED)
			Next	
		Case $S_VALUE1 < $S_VALUE2
			For $S_i = $S_VALUE1 To $S_VALUE2
				DllCall($S_DLL,"long","SemiTrans","long",$hDC,"long",$S_POSX,"long",$S_POSY,"long",$S_bytearray1[0],"long",$S_bytearray2[0],"long",$S_i)        
				Sleep($S_SPEED)
			Next	
	EndSelect
	DllCall($S_DLL,"long","FreeExtBmp","long",$S_FXHANDLE1[0])
	DllCall($S_DLL,"long","FreeExtBmp","long",$S_FXHANDLE2[0])
	DllClose($S_DLL)
EndFunc

#CS 
	Effect Fog 
	syntax : Fog("PICTURE mask", POS X, POS Y, Time, Effect speed)
	Note ; "PICTURE mask" = path to picturefile must be (.png) 
			The White regions let the Effect thrue , de black regions blocks the effect
			POS X and POS Y are the position's where the picture is copy to the window
			Time = Duration of effect 
			Effect speed ; Speed of Fog pixels
#CE
Func Fog($S_MASK, $S_POSX, $S_POSXY, $S_TIME, $S_SPEED)
	$S_DLL = DllOpen("ProSpeed.dll")
	Local $S_InitExtFX[1]
	$WIN_TILLE = WinGetTitle("","")
	$WIN_GETHANDLE = WinGetHandle($WIN_TILLE,"")
	$RAW_HDC = DllCall("user32.dll","ptr","GetWindowDC","hwnd",$WIN_GETHANDLE)
	$hDC     = "0x" & Hex($RAW_HDC[0])
		
	$BMP_MASK = DllCall($S_DLL,"long","LoadExtImage","str",$S_MASK,"long",$hDC)
	$S_WIDTH = DllCall($S_DLL,"long","GetBmpWidth","long",$BMP_MASK[0])
	$S_HEIGHT = DllCall($S_DLL,"long","GetBmpHeight","long",$BMP_MASK[0])
	
	$S_BMP1 = DllCall($S_DLL,"long","CreateExtBmp","long",$hDC,"long",$S_WIDTH[0],"long",$S_HEIGHT[0]) 
	$S_BMP2 = DllCall($S_DLL,"long","CreateExtBmp","long",$hDC,"long",$S_WIDTH[0],"long",$S_HEIGHT[0]) 
	
	$S_FXHANDLE1 = DllCall($S_DLL,"long","InitExtFX","long",$S_BMP1[0])
	$S_FXHANDLE2 = DllCall($S_DLL,"long","InitExtFX","long",$S_BMP2[0])
	$S_FXHANDLE3 = DllCall($S_DLL,"long","InitExtFX","long",$BMP_MASK[0])
	
	For $S_i = 1 To 200
		DllCall($S_DLL,"long","Fog","long",$hDC,"long",$S_POSX,"long",$S_POSXY,"long",$S_FXHANDLE1[0],"long",$S_FXHANDLE2[0],"long",$S_FXHANDLE3[0])
	Next	
	For $S_i = 1 To $S_TIME
		DllCall($S_DLL,"long","Fog","long",$hDC,"long",$S_POSX,"long",$S_POSXY,"long",$S_FXHANDLE1[0],"long",$S_FXHANDLE2[0],"long",$S_FXHANDLE3[0])
		Sleep($S_SPEED)
	Next
	DllClose($S_DLL)
EndFunc

#CS 
	Effect Grey 
	syntax : Grey("PICTURE", POS X, POS Y,)
	Note ; "PICTURE" = path to picturefile can be (.bmp, .jpg, .gif, .png, .wmf) 
			POS X and POS Y are the position's where the picture is copy to the window
#CE
Func Grey($S_FILE, $S_POSX, $S_POSY)
	$S_DLL = DllOpen("ProSpeed.dll")
	Local $S_InitExtFX[1]
	$WIN_TILLE = WinGetTitle("","")
	$WIN_GETHANDLE = WinGetHandle($WIN_TILLE,"")
	$RAW_HDC = DllCall("user32.dll","ptr","GetWindowDC","hwnd",$WIN_GETHANDLE)
	$hDC     = "0x" & Hex($RAW_HDC[0])
	
	$S_PIC = DllCall($S_DLL,"long","LoadExtImage","str",$S_File,"long",$hDC)
	$S_WIDTH = DllCall($S_DLL,"long","GetBmpWidth","long",$S_PIC[0])
	$S_HEIGHT = DllCall($S_DLL,"long","GetBmpHeight","long",$S_PIC[0])
	
	$S_InitExtFX = DllCall($S_DLL,"long","InitExtFX","long",$S_PIC[0])

	DllCall($S_DLL,"long","Grey","long",$hDC,"long",$S_POSX,"long",$S_POSY,"long",$S_InitExtFX[0])

	DllCall($S_DLL,"long","FreeExtBmp","long",$S_PIC[0])
	DllClose($S_DLL)
EndFunc

#CS 
	Effect Rotate 
	syntax : Rotate("PICTURE", POS X, POS Y, DEGREE)
	Note ; "PICTURE" = path to picturefile can be (.bmp, .jpg, .gif, .png, .wmf) 
			POS X and POS Y are the position's where the picture is copy to the window
			DEGREE 0 to 360
#CE
Func Rotate($S_FILE, $S_POSX, $S_POSY, $S_DEGREE)
	$S_DLL = DllOpen("ProSpeed.dll")
	Local $S_InitExtFX[1]
	$WIN_TILLE = WinGetTitle("","")
	$WIN_GETHANDLE = WinGetHandle($WIN_TILLE,"")
	$RAW_HDC = DllCall("user32.dll","ptr","GetWindowDC","hwnd",$WIN_GETHANDLE)
	$hDC     = "0x" & Hex($RAW_HDC[0])

	$S_PIC = DllCall($S_DLL,"long","LoadExtImage","str",$S_File,"long",$hDC)
	$S_WIDTH = DllCall($S_DLL,"long","GetBmpWidth","long",$S_PIC[0])
	$S_HEIGHT = DllCall($S_DLL,"long","GetBmpHeight","long",$S_PIC[0])
	
	$BACK = DllCall($S_DLL,"long","CreateExtBmp","long",$hDC,"long",$S_WIDTH[0],"long",$S_HEIGHT[0])
	DllCall($S_DLL,"long","CopyExtBmp","long",$hDC,"long",$S_POSX,"long",$S_POSY,"long",$S_WIDTH[0],"long",$S_HEIGHT[0],"long",$BACK[0],"long",0,"long",0,"long",0)

	$S_InitExtFX1 = DllCall($S_DLL,"long","InitExtFX","long",$BACK[0])
	$S_InitExtFX2 = DllCall($S_DLL,"long","InitExtFX","long",$S_PIC[0])
	
	For $S_i = 0 To $S_DEGREE
		DllCall($S_DLL,"long","Rotate","long",$hDC,"long",$S_POSX,"long",$S_POSY,"long",$S_InitExtFX1[0],"long",$S_InitExtFX2[0],"long",$S_i,"long",0)
	Next
		DllCall($S_DLL,"long","FreeExtBmp","long",$S_PIC[0])
	DllClose($S_DLL)
EndFunc

#CS 
	Effect Mask 
	syntax : Mask("PICTURE1", "PICTURE2", "PICTURE MASK", POS X, POS Y)
	Note ; "PICTURE" = path to picturefile can be (.bmp, .jpg, .gif, .png, .wmf) 
		   "PICTURE MASK" must be type (.png) and Black & White
			All PICTURES must have the same dimensions Width & Height
			You can "PICTURE2" leave empty like "Mask("PICTURE1", "", "PICTURE MASK", POS X, POS Y)"
			Then the effect will be copied to a black bitmap on screen
			POS X and POS Y are the position's where the picture is copy to the window
#CE
Func Mask($S_FILE1, $S_FILE2, $S_FILE_MASK, $S_POSX, $S_POSY)
	$S_DLL = DllOpen("ProSpeed.dll")
	Local $S_InitExtFX[1]
	Local $S_PIC2[1]
	$WIN_TILLE = WinGetTitle("","")
	$WIN_GETHANDLE = WinGetHandle($WIN_TILLE,"")
	$RAW_HDC = DllCall("user32.dll","ptr","GetWindowDC","hwnd",$WIN_GETHANDLE)
	$hDC     = "0x" & Hex($RAW_HDC[0])
	
	$S_PIC1 = DllCall($S_DLL,"long","LoadExtImage","str",$S_FILE1,"long",$hDC)
	$S_WIDTH = DllCall($S_DLL,"long","GetBmpWidth","long",$S_PIC1[0])
	$S_HEIGHT = DllCall($S_DLL,"long","GetBmpHeight","long",$S_PIC1[0])
	
	$S_InitExtFX1 = DllCall($S_DLL,"long","InitExtFX","long",$S_PIC1[0])
	
	If $S_FILE2 = "" Then
		$S_InitExtFX2 = DllCall($S_DLL,"long","CreateExtFX","long",$S_WIDTH[0],"long",$S_HEIGHT[0])
	Else
		$S_PIC2 = DllCall($S_DLL,"long","LoadExtImage","str",$S_FILE2,"long",$hDC)
		$S_InitExtFX2 = DllCall($S_DLL,"long","InitExtFX","long",$S_PIC2[0])
	EndIf
	
	$S_PIC3 = DllCall($S_DLL,"long","LoadExtImage","str",$S_FILE_MASK,"long",$hDC)
	$S_MASK = DllCall($S_DLL,"long","InitExtFX","long",$S_PIC3[0])
	
	DllCall($S_DLL,"long","CopyExtBmp","long",$hDC,"long",$S_POSX,"long",$S_POSY,"long",$S_WIDTH,"long",$S_HEIGHT,"long",$S_PIC1[0],"long",0,"long",0,"long",0)
	
	DllCall($S_DLL,"long","CopyExtBmp","long",$hDC,"long",$S_POSX,"long",$S_POSY,"long",$S_WIDTH[0],"long",$S_HEIGHT[0],"long",$S_PIC2[0],"long",0,"long",0,"long",0)
	
	DllCall($S_DLL,"long","AlphaTrans","long",$hDC,"long",$S_POSX,"long",$S_POSY,"long",$S_InitExtFX2[0],"long",$S_InitExtFX1[0],"long",$S_MASK[0])
	
	DllCall($S_DLL,"long","FreeExtBmp","long",$S_PIC1[0])
	DllCall($S_DLL,"long","FreeExtBmp","long",$S_PIC2[0])
	DllCall($S_DLL,"long","FreeExtBmp","long",$S_PIC3[0])
	DllClose($S_DLL)
EndFunc
