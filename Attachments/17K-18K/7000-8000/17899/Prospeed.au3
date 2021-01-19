#CS 
UDF Prospeed  ;  Image manipulation , Sprites , DirectXSound , Joystick and Mouse func
Author        ;  JPAM van der Ouderaa
Email         ;  jpamvanderouderaa@wanadoo.nl
Contributions ;  Frank Abbing for creating Prospeed.dll
#CE

#include-once
#include <Array.au3>
Opt("OnExitFunc", "Close_DLL")
Global $N_HEIGHT
Dim $hDC,$text,$len,$S_DLL
Dim $S_InitExtFX,$S_ImageFX[1],$S_FXHANDLE1,$S_FXHANDLE2,$S_InitExtFX1,$array1[1],$S_Image[1]
Dim $collide,$Collision,$CollideAll,$CollideMoreInfos
Dim $current_X,$current_Y,$goal_PosX,$goal_PosY,$sprite_arrived,$speedX,$speedY,$current_Frame
Dim $S_GetSpriteMark,$S_GetSpriteMark
Dim $S_WIDTH[1],$S_HEIGHT[1],$Window_Width,$Window_height,$Offset_X,$Offset_Y 
Dim $S_fensterkopie1[2],$S_fensterkopie2[2],$NN_WIDTH,$NN_HEIGHT 
Dim $S_Spriteplane,$Scrollmodus,$Speed_X,$Speed_Y,$S_Sprite
Dim $S_joy1,$S_joy2,$S_Buttons,$S_JoystickX,$S_JoystickY,$S_JoystickZ,$S_JoystickR,$S_Joysticku,$S_Joystickv
$S_DLL = DllOpen("ProSpeed.dll")
GUIRegisterMsg($WM_PAINT, "PaintNew")

#CS
===================================================================================================================================
IMAGE
===================================================================================================================================
#CE

#CS 
	LoadImage 
	syntax : $dino = LoadImage("Imagefile", POS X, POS Y, $N_WIDTH, $N_HEIGHT, $S_Onscreen)	
	Note ; Needs a user defined string before the func
			"Imagefile" = path to Imagefile can be (.bmp, .jpg, .gif, .png, .wmf)
			POS X and POS Y are the position's where the picture is copy to the window
			WIDTH/HEIGHT = New width and height for image file
			Onscreen = 0 / 1
			0 = in memory
			1 = onscreen
			Example; 
			i want to load imagefile , Create SpecialFX for blur effect 
			LoadImage("dino.jpg", 0, 0, 600, 400, 1)
			Blur("",0,0,30)
#CE
Func LoadImage($S_FILE, $S_offsetX, $S_offsetY, $N_WIDTH, $N_HEIGHT, $S_Onscreen)
	$WIN_TILLE     = WinGetTitle("", "")
	$WIN_GETHANDLE = WinGetHandle($WIN_TILLE, "")
	$RAW_HDC       = DllCall("user32.dll", "ptr", "GetDC", "hwnd", $WIN_GETHANDLE)
	Global $hDC    = "0x" & Hex($RAW_HDC[0])
	
	$S_Image  = DllCall($S_DLL, "long", "LoadExtImage", "str", $S_FILE)
	$S_WIDTH  = DllCall($S_DLL, "long", "GetBmpWidth", "long", $S_Image[0])
	$S_HEIGHT = DllCall($S_DLL, "long", "GetBmpHeight", "long", $S_Image[0])
	If $S_Onscreen = 1 Then
		$C_createBMP = DllCall($S_dll, "long", "CreateExtBmp", _
									   "long", $hDC, _
									   "long", $N_WIDTH, _
									   "long", $N_HEIGHT)		
		DllCall($S_dll, "long", "SizeExtBmp", _
						"long", $C_createBMP[0], _
						"long", 0, _
						"long", 0, _
						"long", $N_WIDTH, _
						"long", $N_HEIGHT, _
						"long",$S_Image[0], _
						"long",0, _
						"long",0, _
						"long",$S_WIDTH[0], _
						"long",$S_HEIGHT[0], _
						"long",0)	
		$S_ImageFX = DllCall($S_DLL, "long", "InitExtFX", "long", $C_createBMP[0])
		DllCall($S_DLL, "long", "CopyArray", _
						"long", $hDC, _
						"long", $S_offsetX, _
						"long", $S_offsetY, _
						"long", $S_ImageFX[0])	
		$S_fensterkopie1 = DllCall($S_DLL, "long", "CreateExtBmp", _
										   "long", $hDC, _
										   "long", $S_WIDTH[0], _
										   "long", $S_HEIGHT[0])
		Return $S_ImageFX[0]
	ElseIf $S_Onscreen = 0 Then
		$C_createBMP = DllCall($S_dll, "long", "CreateExtBmp", _
									   "long", $hDC, _
									   "long", $N_WIDTH, _
									   "long", $N_HEIGHT)		
		DllCall($S_dll, "long", "SizeExtBmp", _
						"long", $C_createBMP[0], _
						"long", $S_offsetX, _
						"long", $S_offsetY, _
						"long", $N_WIDTH, _
						"long",$N_HEIGHT, _
						"long",$S_Image[0], _
						"long",$S_offsetX, _
						"long",$S_offsetY, _
						"long",$S_WIDTH[0], _
						"long",$S_HEIGHT[0], _
						"long",0)	
		$S_ImageFX = DllCall($S_DLL, "long", "InitExtFX", "long", $C_createBMP[0])
		Return $S_ImageFX[0]
	ElseIf $S_Onscreen = 3 Then
		DllCall($S_DLL, "long", "CopyExtBmp", _
						"long", $hDC, _
						"long", $S_offsetX, _
						"long", $S_offsetY, _
						"long", $S_WIDTH[0], _
						"long", $S_HEIGHT[0], _
						"long",$S_Image[0], _
						"long",0, _
						"long",0, _
						"long",-1)
		Return $S_Image[0]
	ElseIf $S_Onscreen = 4 Then
		Return $S_Image[0]
	EndIf		
EndFunc

#CS 
	FreeExtBmp 
	syntax : FreeExtBmp(Alias)	
	Note ; clears the bitmap from memory
#CE
Func FreeExtBmp($Alias)
	DllCall($S_DLL, "long", "FreeExtBmp", "long", $Alias)
EndFunc

#CS 
	FreeAllExtBmps 
	syntax : FreeAllExtBmps()	
	Note ; clears all bitmaps from memory
#CE
Func FreeAllExtBmps() 
	DllCall($S_DLL, "long", "FreeAllExtBmps")
EndFunc

#CS 
	FreeExtFX 
	syntax : FreeExtFX(Alias)	
	Note ; clears all arrays from memory
#CE
Func FreeExtFX($Alias)
	DllCall($S_DLL, "long", "FreeExtFX", "long", $Alias)
EndFunc

#CS 
	Function GetBmpWidth 
	syntax : GetBmpWidth($Alias)	
	Note ; Alias = String created by Function LoadImage()
		   Get the width of the loaded image
#CE
Func GetBmpWidth($S_FILE)
	$S_WIDTH = DllCall($S_DLL, "long", "GetBmpWidth", "long", $S_FILE)
	Return $S_WIDTH[0]
EndFunc

#CS 
	Function GetBmpHeight
	syntax : GetBmpHeight($Alias)	
	Note ; Alias = String created by Function LoadImage()
		   Get the Height of the loaded image
#CE
Func GetBmpHeight($S_FILE)
	$S_Height = DllCall($S_DLL, "long", "GetBmpHeight", "long", $S_FILE)
	Return $S_Height[0]
EndFunc

#CS 
	Function Onscreen 
	syntax : Onscreen($Alias, POS X, POS Y)	
	Note ; Alias = String created by Function LoadImage()
		   POS X and POS Y are the position's where the picture is copy to the window
		   Set picture on screen loaded with LoadImage()
#CE
Func Onscreen($Alias, $S_offsetX, $S_offsetY)
	DllCall($S_DLL, "long", "CopyArray", _
					"long", $hDC, _
					"long", $S_offsetX, _
					"long", $S_offsetY, _
					"long", $Alias)	
	$S_fensterkopie1 = DllCall($S_DLL, "long", "CreateExtBmp", _
									   "long", $hDC, _
									   "long", $S_WIDTH[0], _
									   "long", $S_HEIGHT[0])
	DllCall($S_DLL, "long", "CopyExtBmp", _
					"long", $S_fensterkopie1[0], _
					"long", 0, _
					"long", 0, _
					"long", $S_WIDTH[0], _
					"long", $S_HEIGHT[0], _
					"long",$hDC, _
					"long",0, _
					"long",0, _
					"long",0)
EndFunc

Func CreateBlack($S_WIDTH, $S_HEIGHT, $S_offsetX, $S_offsetY)
	$WIN_TILLE     = WinGetTitle("", "")
	$WIN_GETHANDLE = WinGetHandle($WIN_TILLE,"")
	$RAW_HDC       = DllCall("user32.dll", "ptr", "GetDC", "hwnd", $WIN_GETHANDLE)
	Global $hDC    = "0x" & Hex($RAW_HDC[0])
	$S_BmpBlack = DllCall($S_DLL, "long", "CreateExtBmp", _
								  "long", $hDC, _
								  "long", $S_WIDTH, _
								  "long", $S_HEIGHT)
	$S_WIDTH  = DllCall($S_DLL, "long", "GetBmpWidth", _
							    "long", $S_BmpBlack[0])
	$S_HEIGHT = DllCall($S_DLL, "long", "GetBmpHeight", _
								"long", $S_BmpBlack[0])
	DllCall($S_DLL, "long", "CopyExtBmp", _
					"long", $hDC, _
					"long", $S_offsetX, _
					"long", $S_offsetY, _
					"long", $S_WIDTH[0], _
					"long", $S_HEIGHT[0], _
					"long",$S_BmpBlack[0], _
					"long",0, _
					"long",0, _
					"long",13)
	$S_fensterkopie1 = DllCall($S_DLL, "long", "CreateExtBmp", _
									   "long", $hDC, _
									   "long", $S_WIDTH[0], _
									   "long", $S_HEIGHT[0])
	DllCall($S_DLL, "long", "CopyExtBmp", _
					"long", $S_fensterkopie1[0], _
					"long", 0, _
					"long", 0, _
					"long", $S_WIDTH[0], _
					"long", $S_HEIGHT[0], _
					"long",$hDC, _
					"long",0, _
					"long",0, _
					"long",0)
EndFunc

Func size($S_Alias, $S_value)
	$S_x = 1
	For $i = 1 To $S_value
		$y = $S_x/4*3/2
		DllCall($S_DLL, "long", "SizeExtBmp", _
						"long", $hDC, _
						"long", 400-$S_x/2, _
						"long", 300-$y, _
						"long", $S_x, _
						"long", $S_x/4*3, _
						"long", $S_Alias, _
						"long", 0, _
						"long", 0, _
						"long", 325, _
						"long", 478, _
						"long", 0)
		$S_x = $S_x+8
	Next
EndFunc

Func sizeQuick($S_Alias, $N_WIDTH, $N_HEIGHT, $O_WIDTH, $O_HEIGHT)
		DllCall($S_DLL, "long", "SizeExtBmp", _
						"long", $hDC, _
						"long", 0, _
						"long", 0, _
						"long", $N_WIDTH, _
						"long", $N_HEIGHT, _
						"long", $S_Alias, _
						"long", 0, _
						"long", 0, _
						"long", $O_WIDTH, _
						"long", $O_HEIGHT, _
						"long", 0)
EndFunc

#CS 
	Effect Blur 
	syntax : blur(Alias, Pos X, Pos Y, ValueEffect, Onscreen)	
	Note ;  Alias = String created by Function LoadImage()
			POS X and POS Y are the position's where the picture is copy to the window
			ValueEffect = 1 to 256  ; higher is more effect
			Onscreen; 0 = memory
					  1 = onscreen
#CE
Func blur($S_Alias, $S_POSX, $S_POSY, $S_VALUE, $S_Onscreen)
	If $S_Onscreen = 1 Then
		For $S_i = 1 To $S_VALUE
			DllCall($S_DLL, "long", "Blur", _
							"long", $hDC, _
							"long", $S_POSX, _
							"long", $S_POSY, _
							"long", $S_Alias)
		Next
	Else
		For $S_i = 1 To $S_VALUE
			DllCall($S_DLL, "long", "Blur", _
							"long", 0, _
							"long", $S_POSX, _
							"long", $S_POSY, _
							"long", $S_Alias)
		Next
	EndIf
EndFunc

#CS 
	Effect Smooth 
	syntax : Smooth(Alias1, MaskAlias, POSX, POSY)
	Note ;  kind of like Blur, but with mask picture *.png
			Alias1 = String created by Function LoadImage()
			MaskAlias = String created by Function LoadImage()
			POS X and POS Y are the position's where the effect is copy to the window
			ValueEffect = 1 to 256  ; higher is more effect
#CE
Func Smooth($S_Alias1, $S_Alias2, $S_POSX, $S_POSY)
	DllCall($S_DLL, "long", "Smooth", _
					"long", $hDC, _
					"long", $S_POSX, _
					"long", $S_POSY, _
					"long", $S_Alias1, _
					"long", $S_Alias2)
EndFunc	

#CS 
	Effect Fuse 
	syntax : Fuse(Alias1, Alias2, offsetX, offsetY, $Flag)
	Note ;  melt 2 picture's to 1 picture
			$flag 0-3
			0= normal copie
			1= Antialiasing
			2= ?
			3= ?
#CE
Func Fuse($S_Alias1, $S_Alias2, $S_offsetX, $S_offsetY, $Flag)
	$S_Fuse = DllCall($S_DLL, "long", "Fuse", _
							  "long", $S_Alias1, _
							  "long", $S_Alias2, _
							  "long", $Flag)
	DllCall($S_DLL, "long", "CopyArray", _
					"long", $hDC, _
					"long", $S_offsetX, _
					"long", $S_offsetY, _
					"long", $S_Fuse[2])
EndFunc

#CS 
	Effect Sharpen 
	syntax : Sharpen(Alias, Pos X, Pos Y, ValueEffect, Onscreen)
	Note ;  Alias = String created by Function LoadImage()
			Pos X and Pos Y are the position's where the picture is copy to the window
			ValueEffect = 1 to 256  ; higher is more effect
			Onscreen; 0 = memory
					  1 = onscreen
#CE
Func Sharpen($S_Alias, $S_POSX, $S_POSY, $S_VALUE, $S_Onscreen)
	If $S_Onscreen = 1 Then		
		For $S_i = 1 To $S_VALUE
			DllCall($S_DLL, "long", "Sharpen", _
							"long", $hDC, _
							"long", $S_POSX, _
							"long", $S_POSY, _
							"long", $S_Alias)
		Next
	Else		
		For $S_i = 1 To $S_VALUE
			DllCall($S_DLL, "long", "Sharpen", _
							"long", 0, _
							"long", $S_POSX, _
							"long", $S_POSY, _
							"long", $S_Alias)
		Next
	EndIf	
EndFunc

#CS 
	Effect Darken 
	syntax : Darken(Alias, Pos X, Pos Y, ValueEffect, Onscreen)
	Note ;  Alias = String created by Function LoadImage()
			Pos X and Pos Y are the position's where the picture is copy to the window
			ValueEffect = 1 to 256  ; higher is more effect
			Onscreen; 0 = memory
					  1 = onscreen
#CE
Func Darken($S_Alias, $S_POSX, $S_POSY, $S_VALUE, $S_Onscreen)
	If $S_Onscreen = 1 Then
		DllCall($S_DLL, "long", "Darken", _
						"long", $hDC, _
						"long", $S_POSX, _
						"long", $S_POSY, _
						"long", $S_Alias, _
						"long", $S_VALUE)
	Else
		DllCall($S_DLL, "long", "Darken", _
						"long", 0, _
						"long", $S_POSX, _
						"long", $S_POSY, _
						"long", $S_Alias, _
						"long", $S_VALUE)
	EndIf
EndFunc

#CS 
	Effect Lighten 
	syntax : Lighten(Alias, Pos X, Pos Y, ValueEffect, Onscreen)
	Note ;  Alias = String created by Function LoadImage()
			Pos X and Pos Y are the position's where the picture is copy to the window
			ValueEffect = 1 to 256  ; higher is more effect
			Onscreen; 0 = memory
					  1 = onscreen
#CE
Func Lighten($S_Alias, $S_POSX, $S_POSY, $S_VALUE, $S_Onscreen)	
	If $S_Onscreen = 1 Then
		DllCall($S_DLL, "long", "Lighten", _
						"long", $hDC, _
						"long", $S_POSX, _
						"long", $S_POSY, _
						"long", $S_Alias, _
						"long", $S_VALUE)
	Else	
		DllCall($S_DLL, "long", "Lighten", _
						"long", 0, _
						"long", $S_POSX, _
						"long", $S_POSY, _
						"long", $S_Alias, _
						"long", $S_VALUE)
	EndIf	
EndFunc

#CS 
	Effect Black_White 
	syntax : Black_White(Alias, Pos X, Pos Y, ValueEffect, Onscreen)
	Note ;  Alias = String created by Function LoadImage()
			Pos X and Pos Y are the position's where the picture is copy to the window
			ValueEffect = -127 to +127
			Onscreen; 0 = memory
					  1 = onscreen
#CE
Func Black_White($S_Alias, $S_POSX, $S_POSY, $S_VALUE, $S_Onscreen)
	If $S_Onscreen = 1 Then
		DllCall($S_DLL, "long", "BlackWhite", _
						"long", $hDC, _
						"long", $S_POSX, _
						"long", $S_POSY, _
						"long", $S_Alias, _
						"long", $S_VALUE)
	Else	
		DllCall($S_DLL, "long", "BlackWhite", _
						"long", 0, _
						"long", $S_POSX, _
						"long", $S_POSY, _
						"long", $S_Alias, _
						"long", $S_VALUE)
	EndIf
EndFunc

#CS 
	Effect Semi_trans Needs 2 pictures loaded with Function Loadimage()
	syntax : Semi_trans(Alias1, Alias2, Pos X, Pos Y, ValueEffect, Onscreen)	
	Note ;  Alias1 = String created by Function LoadImage()
			Alias2 = String created by Function LoadImage()
			Alias1 & Alias2 pictures loaded with Function LoadImage() must have same dimensions widht and height
			Pos X and Pos Y are the position's where the picture is copy to the window
			ValueEffect = 1 to 100
			Onscreen; 0 = memory
					  1 = onscreen
#CE
Func Semi_trans($S_Alias1, $S_Alias2, $S_POSX, $S_POSY, $S_VALUE, $S_Onscreen)
	If $S_Onscreen = 1 Then
		DllCall($S_DLL, "long", "SemiTrans", _
						"long", $hDC, _
						"long", $S_POSX, _
						"long", $S_POSY, _
						"long", $S_Alias1, _
						"long", $S_Alias2, _
						"long",$S_VALUE)        
	Else
		DllCall($S_DLL, "long", "SemiTrans", _
						"long", 0, _
						"long", $S_POSX, _
						"long", $S_POSY, _
						"long", $S_Alias1, _
						"long", $S_Alias2, _
						"long",$S_VALUE)        
	EndIf
EndFunc

#CS 
	IniFog() 
	syntax : IniFog()
	Note ;  Need to be loaded before Function Fog($S_Alias, $S_POSX, $S_POSY)
			No parameters required
#CE
Func IniFog()
	$S_BMP1 = DllCall($S_DLL, "long", "CreateExtBmp", _
							  "long", $hDC, _
							  "long", $S_WIDTH[0], _
							  "long", $S_HEIGHT[0]) 
	$S_BMP2 = DllCall($S_DLL, "long", "CreateExtBmp", _
							  "long", $hDC, _
							  "long", $S_WIDTH[0], _
							  "long", $S_HEIGHT[0]) 	
	$S_FXHANDLE1 = DllCall($S_DLL, "long", "InitExtFX", "long", $S_BMP1[0])
	$S_FXHANDLE2 = DllCall($S_DLL, "long", "InitExtFX", "long", $S_BMP2[0])
	$S_FXHANDLE1 = $S_FXHANDLE1[0]
	$S_FXHANDLE2 = $S_FXHANDLE2[0]
EndFunc

#CS 
	Effect Fog Needs Function IniFog() first
	syntax : Fog(Alias, Pos X, Pos Y)
	Note ;  Alias = String created by Function LoadImage() must be Picture type *.png
			The White regions let the Effect thrue , de black regions blocks the effect
			Pos X and Pos Y are the position's where the picture is copy to the window
			The Effect becomes only visible true a loop
			Example; 
			$Mask = LoadImage("C:\Mask.png", 0, 0)
			IniFog()
			While 1
				Fog($Mask, 0, 0)
			Wend
#CE
Func Fog($S_Alias, $S_POSX, $S_POSY)	
	DllCall($S_DLL, "long", "Fog", _
					"long", $hDC, _
					"long", $S_POSX, _
					"long", $S_POSY, _
					"long", $S_FXHANDLE1, _
					"long", $S_FXHANDLE2, _
					"long",$S_Alias)
EndFunc

#CS 
	Effect Grey 
	syntax : Grey(Alias, Pos X, Pos Y, Onscreen)
	Note ;  Alias = String created by Function LoadImage() must be Picture type *.png
			POS X and POS Y are the position's where the picture is copy to the window
			Onscreen; 0 = memory
					  1 = onscreen
#CE
Func Grey($S_Alias, $S_POSX, $S_POSY, $S_Onscreen)	
	If $S_Onscreen = 1 Then
		DllCall($S_DLL, "long", "Grey", _
						"long", $hDC, _
						"long", $S_POSX, _
						"long", $S_POSY, _
						"long", $S_Alias)
	Else
		DllCall($S_DLL, "long", "Grey", _
						"long", 0, _
						"long", $S_POSX, _
						"long", $S_POSY, _
						"long", $S_Alias)
	EndIf	
EndFunc

#CS 
	Function IniRotate() 
	syntax : IniRotate()
	Note ;  Need to be loaded before Function Rotate($S_Alias, $S_POSX, $S_POSY, $S_DEGREE)
			No parameters required
#CE
Func IniRotate()
	$BACK = DllCall($S_DLL, "long", "CreateExtBmp", _
							"long", $hDC, _
							"long", $S_WIDTH[0], _
							"long", $S_HEIGHT[0])
	$S_InitExtFX1 = DllCall($S_DLL, "long", "InitExtFX", "long", $BACK[0])
	Global $S_InitExtFX1 = $S_InitExtFX1[0]
EndFunc

#CS 
	Effect Rotate 
	syntax : Rotate(Alias, POS X, POS Y, DEGREE)
	Note ;  Alias = String created by Function LoadImage() 
			POS X and POS Y are the position's where the picture is copy to the window
			DEGREE 0 to 360
#CE
Func Rotate($S_Alias, $S_POSX, $S_POSY, $S_DEGREE)
		DllCall($S_DLL, "long", "Rotate", _
						"long", $hDC, _
						"long", $S_POSX, _
						"long", $S_POSY, _
						"long", $S_InitExtFX1, _
						"long", $S_Alias, _
						"long",$S_DEGREE, _
						"long",0)
EndFunc

#CS 
	Effect AlphaTrans 
	syntax : AlphaTrans(Alias1, Alias2, Alias_MASK, POS X, POS Y)
	Note ;  Alias1 = String created by Function LoadImage() 
		    Alias2 = String created by Function LoadImage() 
		    Alias_MASK = String created by Function LoadImage()  must be type (.png) and Black & White
			All PICTURES must have the same dimensions Width & Height
			You can Alias2 leave empty like "Mask(Alias1, "", Alias_MASK, POS X, POS Y)"
			Then the effect will be copied to a black bitmap on screen
			POS X and POS Y are the position's where the picture is copy to the window
#CE
Func AlphaTrans($S_Alias1, $S_Alias2, $S_Alias_MASK, $S_POSX, $S_POSY)
	If $S_Alias2 = "" Then
		$S_InitExtFX2 = DllCall($S_DLL, "long", "CreateExtFX", _
										"long", $S_WIDTH[0], _
										"long", $S_HEIGHT[0])
		Global $S_InitExtFX2 = $S_InitExtFX2[0]	
	EndIf
	DllCall($S_DLL, "long", "CopyExtBmp", _
					"long", $hDC, _
					"long", $S_POSX, _
					"long", $S_POSY, _
					"long", $S_WIDTH, _
					"long", $S_HEIGHT, _
					"long",$S_Alias1, _
					"long",0, _
					"long",0, _
					"long",0)
	If $S_Alias2 = "" Then
		DllCall($S_DLL, "long", "CopyExtBmp", _
						"long", $hDC, _
						"long",$S_POSX, _
						"long",$S_POSY, _
						"long",$S_WIDTH[0], _
						"long",$S_HEIGHT[0], _
						"long",$S_InitExtFX2, _
						"long",0, _
						"long",0, _
						"long",0)
		DllCall($S_DLL, "long", "AlphaTrans", _
						"long", $hDC, _
						"long", $S_POSX, _
						"long",$S_POSY, _
						"long",$S_InitExtFX2[0], _
						"long",$S_Alias1, _
						"long",$S_Alias_MASK)
	Else
		DllCall($S_DLL, "long", "CopyExtBmp", _
						"long", $hDC, _
						"long", $S_POSX, _
						"long", $S_POSY, _
						"long", $S_WIDTH[0], _
						"long", $S_HEIGHT[0], _
						"long",$S_Alias2, _
						"long",0, _
						"long",0, _
						"long",0)
		DllCall($S_DLL, "long", "AlphaTrans", _
						"long", $hDC, _
						"long", $S_POSX, _
						"long", $S_POSY, _
						"long", $S_Alias2, _
						"long",$S_Alias1, _
						"long",$S_Alias_MASK)
	EndIf
EndFunc

#CS 
	Function IniRustle 
	syntax : IniRustle(WIDTH, HEIGHT)
	Note ;  creates Empty bitmap for Rustle Effect
			WIDTH, HEIGHT = how big the Rustle Effect will be
#CE
Func IniRustle($P_WIDTH, $P_HEIGHT)
	$S_hdc1 = DllCall($S_DLL, "long", "CreateExtBmp", _
							  "long", $hDC, _
							  "long", $P_WIDTH, _
							  "long", $P_HEIGHT)
	$S_InitExtFX = DllCall($S_DLL, "long", "InitExtFX", "long", $S_hdc1[0])
	Global $S_InitExtFX = $S_InitExtFX[0]
EndFunc	

#CS 
	Effect IniRustle 
	syntax : IniRustle($Alias, PosX, PosY)
	Note ;  creates Rustle Effect			
			PosX and PosY are the position's where the effect is copy to the window
#CE
Func Rustle($S_POSX, $S_POSY)
	DllCall($S_DLL, "long", "Rustle", _
					"long",$hDC, _
					"long",$S_POSX, _
					"long",$S_POSY, _
					"long",$S_InitExtFX)
EndFunc

#CS
===================================================================================================================================
SPITES
===================================================================================================================================
#CE

#CS 
	Background 
	syntax : Background("PICTURE", POS X, POS Y, new WIDTH, new HEIGHT)
	Note ; "PICTURE" = path to picturefile can be (.bmp, .jpg, .gif, .png, .wmf) 
			POS X and POS Y are the position's where the picture is copy to the window
			new WIDTH / new HEIGHT = new width and height for background image
#CE
Func Background($S_FILE, $S_POSX, $S_POSY, $N_WIDTH, $N_HEIGHT)
	$WIN_TILLE     = WinGetTitle("", "")
	$WIN_GETHANDLE = WinGetHandle($WIN_TILLE, "")
	$RAW_HDC       = DllCall("user32.dll", "ptr", "GetDC", "hwnd", $WIN_GETHANDLE)
	$hDC           = "0x" & Hex($RAW_HDC[0])
	
	$S_background = DllCall($S_DLL, "long", "LoadExtImage", "str" ,$S_FILE)	
	$S_WIDTH      = DllCall($S_DLL, "long", "GetBmpWidth" , "long",$S_background[0])
	$S_HEIGHT     = DllCall($S_DLL, "long", "GetBmpHeight", "long",$S_background[0])
	
	$C_createBMP = DllCall($S_dll, "long", "CreateExtBmp", "long", $hDC, "long", $N_WIDTH, "long", $N_HEIGHT)		
	DllCall($S_dll,"long","SizeExtBmp", "long", $C_createBMP[0], _
										"long",0, _
										"long",0, _
										"long",$N_WIDTH, _
										"long",$N_HEIGHT, _
										"long",$S_background[0], _
										"long",0, _
										"long",0, _
										"long",$S_WIDTH[0], _
										"long",$S_HEIGHT[0], _
										"long",0)	
	$S_ImageFX = DllCall($S_DLL,"long", "InitExtFX", "long", $C_createBMP[0])
	DllCall($S_DLL,"long", "CopyArray", "long", $hDC, "long", $S_POSX, "long", $S_POSY, "long", $S_ImageFX[0])	
	
	$S_fensterkopie1 = DllCall($S_DLL, "long", "CreateExtBmp", "long", $hDC, "long", $N_WIDTH, "long", $N_HEIGHT)
	$S_fensterkopie2 = DllCall($S_DLL, "long", "CreateExtBmp", "long", $hDC, "long", $N_WIDTH, "long", $N_HEIGHT)
	DllCall($S_DLL, "long", "CopyExtBmp", "long", $S_fensterkopie1[0], _
										  "long",0, _
										  "long",0, _
										  "long",$N_WIDTH, _
										  "long",$N_HEIGHT, _
										  "long",$hDC, _
										  "long",0, _
										  "long",0, _
										  "long",0)
	DllCall($S_DLL, "long", "CopyExtBmp", "long", $S_fensterkopie2[0], _
										  "long",0, _
										  "long",0, _
										  "long",$N_WIDTH, _
										  "long",$N_HEIGHT, _
										  "long",$hDC, _
										  "long",0, _
										  "long",0, _
										  "long",0)		
	$S_WIDTH[0]  = $N_WIDTH
	$S_HEIGHT[0] = $N_HEIGHT
	Return $S_background[0]
EndFunc

#CS 
	screencopie
	syntax : screencopie()
	makes screencopie for sprites ,for displaying sprites on desktop without a gui
#CE
Func screencopie()
	$ProgMan = DllCall("user32.dll","hwnd","FindWindow","str","Progman","str","Program Manager");
	$Shell = DllCall("user32.dll","hwnd","FindWindowEx","hwnd",$ProgMan[0],"int",0,"hwnd","SHELLDLL_DefView","int",0)
	$listView = DllCall("user32.dll","hwnd","FindWindowEx","hwnd",$Shell[0],"int",0,"hwnd","SysListView32","str","FolderView")     
	$HDC = DllCall("user32.dll","ptr","GetDC","hwnd",$listView[0])
	$hDC = $hDC[0]
	
	$S_fensterkopie1 = DllCall($S_DLL, "long", "CreateExtBmp", _
									   "long", $hDC, _
								       "long", @DesktopWidth, _
								       "long", @DesktopHeight)
	$S_fensterkopie2 = DllCall($S_DLL, "long", "CreateExtBmp", _
								       "long", $hDC, _
								       "long", @DesktopWidth, _
								       "long", @DesktopHeight)
    DllCall($S_DLL, "long","CopyExtBmp", _
			        "long", $S_fensterkopie1[0], _
			        "long", 0, _
			        "long", 0, _
					"long", @DesktopWidth, _
			        "long", @DesktopHeight, _
			        "long", $hDC, _
			        "long", 0, _
			        "long", 0, _
			        "long", 0)
    DllCall($S_DLL, "long", "CopyExtBmp", _
				    "long", $S_fensterkopie2[0], _
				    "long", 0, _
				    "long", 0, _
				    "long", @DesktopWidth, _
					"long", @DesktopHeight, _
				    "long", $hDC, _
				    "long", 0, _
				    "long", 0, _
				    "long", 0)
EndFunc

#CS 
	BackgroundScroll 
	syntax : BackgroundScroll("PICTURE", Xoffset, Yoffset, XDirection, YDirection)
	Note ; "PICTURE" = path to picturefile can be (.bmp, .jpg, .gif, .png, .wmf) 
			Xoffset and Yoffset are the position's where the picture is copy to the window
			XDirection = Direction to scroll to left or right
			1 = scroll to right
			-1 = scroll to left
			0 = no scrolling
			YDirection = Direction to scroll to up or down
			1 = scroll to up
			-1 = scroll to down
			0 = no scrolling
#CE
Func BackgroundScroll($S_FILE, $S_Xoffset, $S_Yoffset, $S_XDirection, $S_YDirection)
	$WIN_TILLE     = WinGetTitle("", "")
	$ClientSize    = WinGetClientSize($WIN_TILLE, "")
	$WIN_GETHANDLE = WinGetHandle($WIN_TILLE, "")
	$RAW_HDC = DllCall("user32.dll", "ptr", "GetDC", "hwnd", $WIN_GETHANDLE)
	$hDC     = "0x" & Hex($RAW_HDC[0])
		
	$S_background = DllCall($S_DLL, "long", "LoadExtImage", "str" , $S_FILE)
	$S_WIDTH      = DllCall($S_DLL, "long", "GetBmpWidth" , "long", $S_background[0])
	$S_HEIGHT     = DllCall($S_DLL, "long", "GetBmpHeight", "long", $S_background[0])
	
	DllCall($S_DLL, "long", "CopyExtBmp", _
					"long", $hDC, _
					"long",0, _
					"long",0, _
					"long",$S_WIDTH[0], _
					"long",$S_HEIGHT[0], _
					"long",$S_background[0], _
					"long",0, _
					"long",0, _
					"long",0)	
	$S_fensterkopie1 = DllCall($S_DLL, "long", "CreateExtBmp", "long", $hDC, "long", $S_WIDTH[0], "long", $S_HEIGHT[0])
	$S_fensterkopie2 = DllCall($S_DLL, "long", "CreateExtBmp", "long", $hDC, "long", $S_WIDTH[0], "long", $S_HEIGHT[0])
	DllCall($S_DLL, "long", "CopyExtBmp", _
					"long", $S_fensterkopie1[0], _
					"long",0, _
					"long",0, _
					"long",$S_WIDTH[0], _
					"long",$S_HEIGHT[0], _
					"long",$S_background[0], _
					"long",0, _
					"long",0, _
					"long",0)
	DllCall($S_DLL, "long", "CopyExtBmp", _
					"long", $S_fensterkopie2[0], _
					"long",0, _
					"long",0, _
					"long",$S_WIDTH[0], _
					"long",$S_HEIGHT[0], _
					"long",$S_background[0], _
					"long",0, _
					"long",0, _
					"long",0)	
	DllCall($S_DLL, "long", "InitSpriteBackground", _
					"long",1, _
					"long",$ClientSize[0], _
					"long",$ClientSize[1], _
					"long",$S_Xoffset, _
					"long",$S_Yoffset, _
					"long",$S_XDirection, _
					"long",$S_YDirection)
	DllCall($S_DLL, "long", "InitSpriteBackground", _
					"long",888888, _
					"long",888888, _
					"long",888888, _
					"long",888888, _
					"long",888888, _
					"long",0, _
					"long",0)
	Return $S_background[0]
EndFunc 

#CS 
	updatescroll 
	syntax : updatescroll()
	Note ;  No parameters required
			For using BackgroundScroll()
			updatescroll() must be in a mainloop, it update's the screen for WM_PAINT
#CE
Func updatescroll()
	$S_fensterkopie1 = DllCall($S_DLL, "long", "CreateExtBmp", _
									   "long", $hDC, _
									   "long", $S_WIDTH[0], _
									   "long", $S_HEIGHT[0])
EndFunc

#CS 
	Scroll_Left 
	syntax : Scroll_Left(2)
	Note ; $S_Speed = how fast to scroll Positive number
		Scrolls the background to left
#CE		
Func Scroll_Left($S_Speed)
	DllCall($S_DLL, "long", "InitSpriteBackground", _
					"long",888888, _
					"long",888888, _
					"long",888888, _
					"long",888888, _
					"long",888888, _
					"long",$S_Speed, _
					"long",0)
EndFunc

#CS 
	Scroll_Right 
	syntax : Scroll_Right(-4)
	Note ; $S_Speed = how fast to scroll must be a Negative number
		Scrolls the background to Right
#CE		
Func Scroll_Right($S_Speed)
	DllCall($S_DLL, "long", "InitSpriteBackground", _
					"long",888888, _
					"long",888888, _
					"long",888888, _
					"long",888888, _
					"long",888888, _
					"long",$S_Speed, _
					"long",0)
EndFunc

#CS 
	Scroll_Stop 
	syntax : Scroll_Stop()
	Note ; No parameters required
		Stops scrolling
#CE		
Func Scroll_Stop()
	DllCall($S_DLL, "long", "InitSpriteBackground", _
					"long",888888, _
					"long",888888, _
					"long",888888, _
					"long",888888, _
					"long",888888, _
					"long",0, _
					"long",0)
EndFunc

#CS 
	Scroll_Up 
	syntax : Scroll_Up(-3)
	Note ; $S_Speed = how fast to scroll must be a Negative number
		Scrolls the background Up
#CE	
Func Scroll_Up($S_Speed)
	DllCall($S_DLL, "long", "InitSpriteBackground", _
					"long",888888, _
					"long",888888, _
					"long",888888, _
					"long",888888, _
					"long",888888, _
					"long",0, _
					"long",$S_Speed)
EndFunc

#CS 
	Scroll_Down 
	syntax : Scroll_Down(3)
	Note ; $S_Speed = how fast to scroll must be a Positive number
		Scrolls the background Down
#CE	
Func Scroll_Down($S_Speed)
	DllCall($S_DLL, "long", "InitSpriteBackground", _
					"long",888888, _
					"long",888888, _
					"long",888888, _
					"long",888888, _
					"long",888888, _
					"long",0, _
					"long",$S_Speed)
EndFunc

#CS
	GetBackgroundInfos 
	syntax : GetBackgroundInfos() 
	Note ; No parameters required
		   Strings return;
		   $Scrollmodus = Is Background scrolling (0 or 1)
		   $Window_Width, $Window_height = Dimensions of window
		   $Offset_X, $Offset_Y = background scroll pixels
		   $Speed_X , $Speed_Y = Speed of background scroll
#CE
Func GetBackgroundInfos() 
	$B_BackgroundInfos = DllStructCreate("long;long;long;long;long;long;long")
	DllCall($S_DLL, "long", "GetBackgroundInfos", "long", DllStructGetPtr($B_BackgroundInfos))
	$Scrollmodus   = DllStructGetData($B_BackgroundInfos, 1)
	$Window_Width  = DllStructGetData($B_BackgroundInfos, 2)
	$Window_height = DllStructGetData($B_BackgroundInfos, 3)
	$Offset_X      = DllStructGetData($B_BackgroundInfos, 4)
	$Offset_Y      = DllStructGetData($B_BackgroundInfos, 5)
	$Speed_X       = DllStructGetData($B_BackgroundInfos, 6)
	$Speed_Y       = DllStructGetData($B_BackgroundInfos, 7)
EndFunc

#CS
	Iniwater
	syntax : Iniwater($Offset_X, $Offset_Y) 
	Note ; $Offset_X = How many pixels from left of the window to start the water effect
		   $Offset_Y = How many pixels from top of the window to start the water effect
		 should be used before function water()
#CE
Func Iniwater($Offset_X, $Offset_Y)
	$WIN_TILLE     = WinGetTitle("", "")
	$WIN_GETHANDLE = WinGetHandle($WIN_TILLE, "")
	$RAW_HDC       = DllCall("user32.dll", "ptr", "GetDC", "hwnd", $WIN_GETHANDLE)
	$hDC           = "0x" & Hex($RAW_HDC[0])	
	$S_Win         = WinGetClientSize("", "")

	$W_calc = $S_Win[1] - $Offset_Y
	$W_calctotal = $S_fensterkopie1[3] - $W_calc

	$C_createBMP = DllCall($S_dll, "long","CreateExtBmp", _
								   "long",$hDC, _
								   "long",$S_fensterkopie1[2], _
								   "long",$S_Win[1] - $S_fensterkopie1[3])
	DllCall($S_DLL, "long", "CopyExtBmp", _
					"long",$C_createBMP[0], _
					"long",0, _
					"long",0, _
					"long",$S_fensterkopie1[2], _
					"long",$S_Win[1] - $S_fensterkopie1[3], _
					"long",$hDC, _
					"long",$Offset_X, _
					"long",$W_calctotal, _
					"long",0)
	$S_ImageFX = DllCall($S_DLL, "long", "InitExtFX", _
								 "long", $C_createBMP[0])	
	DllCall($S_DLL, "long", "FlipY", _
					"long",0, _
					"long",$S_fensterkopie1[2], _
					"long",$S_Win[1] - $S_fensterkopie1[3], _
					"long",$S_ImageFX[0])
	DllCall($S_DLL, "long", "Darken", _
					"long",0, _
					"long",$S_fensterkopie1[2], _
					"long",$S_Win[1] - $S_fensterkopie1[3], _
					"long",$S_ImageFX[0], _
					"long",30)	
	For $i = 1 To 5
		DllCall($S_DLL, "long", "Blur", _
						"long",0, _
						"long",$S_fensterkopie1[2], _
						"long",$S_Win[1] - $S_fensterkopie1[3], _
						"long",$S_ImageFX[0])		
	Next
	DllCall($S_DLL, "long", "CopyArray", _
					"long",$hDC, _
					"long",$Offset_X, _
					"long",$Offset_Y, _
					"long",$S_ImageFX[0])
EndFunc

#CS
	Water
	syntax : Water(From Top) 
	Note ; $Offset_X = How many pixels from left of the window to start the water effect
		   $Offset_Y = How many pixels from top of the window to start the water effect
		 This function must be in a loop and must be called every time
#CE
Func Water($Offset_X, $Offset_Y)
	DllCall($S_DLL, "long", "Water", _
					"long",$hDC, _
					"long",$Offset_X, _
					"long",$Offset_Y, _
					"long",$S_ImageFX[0], _
					"long",1) 
EndFunc


#CS 
	loadsprite 
	syntax : $spaceship1 = loadsprite("Picture.gif")
	Note ;  Needs a user defined string before the func
			Picture = path to picturefile can be (.bmp, .jpg, .gif, .png, .wmf) 
#CE
Func loadsprite($S_SPRITE_PIC)
	$S_Spriteplane = DllCall($S_DLL, "long", "LoadExtImage", "str", $S_SPRITE_PIC)
	Return $S_Spriteplane[0]
EndFunc

#CS 
	loadspriteResize
	syntax : $spaceship1 = loadspriteResize("Picture.gif", new width, new height)
	Note ;  Needs a user defined string before the func
			Picture = path to picturefile can be (.bmp, .jpg, .gif, .png, .wmf) 
#CE
Func loadspriteResize($S_SPRITE_PIC, $Np_WIDTH, $Np_HEIGHT)
	$S_Spriteplane = DllCall($S_DLL, "long", "LoadExtImage", "str", $S_SPRITE_PIC)
	$Sp_WIDTH  = DllCall($S_DLL, "long", "GetBmpWidth", "long", $S_Spriteplane[0])
	$Sp_HEIGHT = DllCall($S_DLL, "long", "GetBmpHeight", "long", $S_Spriteplane[0])
	
	$C_createBMP2 = DllCall($S_dll, "long", "CreateExtBmp", _
								   "long", $hdc, _
								   "long", $Np_WIDTH, _
							       "long", $Np_HEIGHT)						
	DllCall($S_dll, "long", "SizeExtBmp", _
					"long", $C_createBMP2[0], _
					"long", 0, _
					"long", 0, _
					"long", $Np_WIDTH, _
					"long", $Np_HEIGHT, _
					"long", $S_Spriteplane[0], _
					"long", 0, _
					"long", 0, _
					"long", $Sp_WIDTH[0], _
					"long", $Sp_HEIGHT[0], _
					"long", 0)
	DllCall($S_DLL, "long", "FreeExtBmp", "long", $S_Spriteplane[0])				
	Return $C_createBMP2[0]
EndFunc

#CS 
	Sprite 
	syntax : $spaceship = Sprite($spaceship1, $S_offsetX, $S_offsetY, WIDTH, HEIGHT, FRAMES, START_FRAME, FRAME_SPEED, posX, posY)
	Note ;  Needs a user defined string before the func
			$spaceship1 = string created with funcion loadsprite()
			$S_offsetX, $S_offsetY = X and Y Position (Offset) of the Spritebitmap, where the Sprite is found
			WIDTH, HEIGHT = sprite itself in the picture
			FRAMES = how many sprites are there in the picture
			START_FRAME = which frame to start the animation
			FRAME_SPEED = how fast must the animation run
			POS X and POS Y are the position where the sprite is copyied to the window
#CE
Func Sprite($S_Spriteplane, $S_offsetX, $S_offsetY, $S_WIDTH, $S_HEIGHT, $S_FRAMES, $S_START_FRAME, $S_FRAME_SPEED, $S_posX, $S_posY)
	$Sprite_ID = DllCall($S_DLL, "long","InitSprite", _
								 "long",$S_Spriteplane, _
								 "long",$hDC, _
								 "long",$S_fensterkopie1[0], _
								 "long",$S_fensterkopie2[0], _
								 "long",$S_offsetX, _
								 "long",$S_offsetY, _
								 "long",$S_WIDTH, _
								 "long",$S_HEIGHT, _
								 "long",$S_FRAMES, _
								 "long",$S_START_FRAME, _
								 "long",$S_FRAME_SPEED, _
								 "long",$S_posX, _
								 "long",$S_posY, _
								 "long",1, _
								 "long",1)			
	Return $Sprite_ID[0]
EndFunc

#CS 
	CopySprite	
	syntax : $new_bee = CopySprite($S_Alias)
	Note ;  copies a sprite with indentical parameters
			$S_Alias = user defined string of the sprite created by function Sprite()
			If you want to make a lot of incentical sprites you better use CopieSprite
			Create first sprite with Sprite func and then copie that sprite multiple times
#CE
Func CopySprite($S_Alias)
	$Sprite_ID = DllCall($S_DLL, "long", "CopySprite", "long", $S_Alias)
	Return $Sprite_ID[0]
EndFunc

#CS 
	Movesprite	
	syntax : Movesprite($S_Alias, $posx, $posy, $S_Speedx, $S_Speedy)
	Note ;  $S_Alias = user defined string of the sprite created by function Sprite()
			$posx, $posy = Postion where the sprite has to moved to
#CE
Func Movesprite($S_Alias, $S_posx, $S_posy)
	DllCall($S_DLL, "long", "MoveSprite", _
					"long", $S_Alias, _
					"long", $S_posx, _
					"long", $S_posy)	
EndFunc


#cs not working yet !!!
Func SpriteTableMode($S_Alias,$S_Mode)
	DllCall($S_DLL, "long", "SpriteTableMode","long",$S_Alias,"long",$S_Mode)
EndFunc

Func MoveSpriteWithTable($S_Alias, $S_TextCoords, $S_Pairs, $X_Offset, $Y_Offset, $S_StartCoord)
	$S_Coords = DllStructCreate("str;str;str;str;str;str;str;str;str;str")
	$S_split = StringSplit($S_TextCoords,",")
	For $S_Sp = 1 To 4
	DllStructSetData($S_Coords,$S_Sp,$S_split[$S_Sp])
	;MsgBox(0,"",$S_split[$S_Sp])
Next
For $i = 1 To 4
	$tt = DllStructGetData($S_Coords, $i)
	MsgBox(0,"",$tt)
Next
	;$test = DllCall($S_DLL, "long", "SetWords", "prt", DllStructGetPtr($S_Coords,1), "long", 0, "long", $S_TextCoords) 
	;MsgBox(0,"",DllStructGetPtr($S_Coords,1))
	DllCall($S_DLL, "long", "MoveSpriteWithTable","long",$S_Alias,"long",DllStructGetPtr($S_Coords),"long",$S_Pairs,"long",$X_Offset,"long",$Y_Offset,"long",$S_StartCoord)
	;MsgBox(0,"",$test[0])
EndFunc
#ce


#CS 
	SetSpriteMovingMode	
	syntax : SetSpriteMovingMode($S_Alias, $S_Mode)
	Note ;  $S_Alias = user defined string of the sprite created by function Sprite()
			$S_Mode = 0 / 1
			0 = Sprite moves first on the y axis then on the x Axis to reach the destination point created by Movesprite()
			1 = sprite moves direct equal on the Y and X axis to the destination point created by Movesprite() 
#CE
Func SetSpriteMovingMode($S_Alias, $S_Mode)
	DllCall($S_DLL, "long", "SetSpriteMovingMode", _
					"long", $S_Alias, _
					"long", $S_Mode)
EndFunc

#CS 
	SetSpritePos	
	syntax : SetSpritePos($S_Alias, $posX, $posY, NextposX, NextposY)
	Note ;  $S_Alias = user defined string of the sprite created by function Sprite()
			$posX, $posY = position to put sprite onscreen
			NextposX, NextposY = next X and Y position where sprite has to move to
#CE
Func SetSpritePos($S_Alias, $S_posx, $S_posy, $S_Nextposx, $S_Nextposy)
	DllCall($S_DLL, "long", "SetSpritePos", _
					"long", $S_Alias, _
					"long", $S_posX, _
					"long", $S_posY, _
					"long", $S_NextposX, _
					"long", $S_NextposY)	
EndFunc

#CS 
	SetSpriteSpeed	
	syntax : SetSpriteSpeed($S_Alias, Speed X, Speed Y)
	Note ;  $S_Alias = user defined string of the sprite created by function Sprite()
			Speed X, Speed Y = how fast moving on screen
#CE
Func SetSpriteSpeed($S_Alias, $S_SpeedX, $S_SpeedY)
	DllCall($S_DLL, "long", "SetSpriteSpeed", _
					"long",$S_Alias, _
					"long",$S_SpeedX, _
					"long",$S_SpeedY)
EndFunc

#CS 
	SlowDownSprite	
	syntax : SlowDownSprite($S_Alias, Speed X, Speed Y)
	Note ;  $S_Alias = user defined string of the sprite created by function Sprite()
			Speed X, Speed Y = slow down sprite on x an y axis
			use SlowDownSprite($S_Alias, 0, 0) to return to normal speed set by SetSpriteSpeed func
#CE
Func SlowDownSprite($S_Alias, $S_SpeedX, $S_SpeedY)
	DllCall($S_DLL, "long", "SlowDownSprite", _
					"long",$S_Alias, _
					"long",$S_SpeedX, _
					"long",$S_SpeedY)
EndFunc

#CS 
	SetSpriteAnimMove	
	syntax : SetSpriteAnimMove($S_Alias, Direction, offsetX, offsetY)
	Note ;  $S_Alias = user defined string of the sprite created by function Sprite()
			Direction = The direction to face the sprite to
			For every direction the sprite moves you can change the animation sequence
			0 = Standing still 
			1 = right up 
			2 = right 
			3 = right down 
			4 = down 
			5 = left down 
			6 = left 
			7 = left up 
			8 = up			
			offsetX = Where to find the sprite in the bitmap on x position ;Mostly starts with zero
			offsetY = Where to find the sprite in the bitmap on y position
#CE
Func SetSpriteAnimMove($S_Alias, $S_direction, $S_offsetX, $S_offsetY)
	DllCall($S_DLL, "long", "SetSpriteAnimMove", _
					"long",$S_Alias, _
					"long",$S_direction, _
					"long",$S_offsetX, _
					"long",$S_offsetY)
EndFunc

#CS 
	SetSpriteAnimMode	
	syntax : SetSpriteAnimMode(Alias, Mode)
	Note ; Alias = user defined string of the sprite created by function Sprite()
		   Mode = 0 / 1
		   0 = Set anim loop on
		   1 = Set anim loop off
#CE
Func SetSpriteAnimMode($S_Alias, $S_Mode) 
	DllCall($S_DLL, "long", "SetSpriteAnimMode", _
					"long",$S_Alias, _
					"long",$S_Mode)
EndFunc	

#CS 
	SetSpriteAnim	
	syntax : SetSpriteAnim($S_Alias, offsetX, offsetY, WIDTH, HEIGHT, FRAMES, START_FRAME, FRAME_SPEED)
	Note ;  This function is pixel accurate
			$S_Alias = user defined string of the sprite created by function Sprite()
			$S_offsetX, $S_offsetY = X and Y Position (Offset) of the Spritebitmap, where the Sprite is found
			WIDTH, HEIGHT = sprite itself in the bitmap
			FRAMES        = how many frames are there in the bitmap
			START_FRAME   = which frame to start the animation
			FRAME_SPEED   = how fast must the animation run ; lower is faster
#CE
Func SetSpriteAnim($S_Alias, $S_offsetX, $S_offsetY, $S_WIDTH, $S_HEIGHT, $S_FRAMES, $S_START_FRAME, $S_FRAME_SPEED)
	DllCall($S_DLL, "long", "SetSpriteAnim", _
					"long",$S_Alias, _
					"long",$S_offsetX, _
					"long",$S_offsetY, _
					"long",$S_WIDTH, _
					"long",$S_HEIGHT, _
					"long",$S_FRAMES, _
					"long",$S_START_FRAME, _
					"long",$S_FRAME_SPEED)
EndFunc

#CS 
	GetSpriteAnimModeStatus
	syntax : $check = GetSpriteAnimModeStatus($S_Alias)
	Note ;  checks to see if animatie of sprite has ended or not	
	0 = sprite is still Animating
	1 = Animation has stopped 
#CE
Func GetSpriteAnimModeStatus($S_Alias)
	$GetSpriteAnimModeStatus = DllCall($S_DLL, "long", "GetSpriteAnimModeStatus", "long", $S_Alias)
	Return $GetSpriteAnimModeStatus[0]
EndFunc

#CS 
	SetSpriteFixMode	
	syntax : SetSpriteFixMode(Alias, Mode)
	Note ;  Set Sprite animation stop , Collision detection is still present
			Alias = user defined string of the sprite created by function Sprite()
			Mode = 0 / 1
			0 = Sprite moves and Animate
			1 = Sprite Do not move and animate
#CE
Func SetSpriteFixMode($S_Alias, $S_Mode) 
	DllCall($S_DLL, "long", "SetSpriteFixMode", "long", $S_Alias, "long", $S_Mode)
EndFunc

#CS 
	GetSpriteFixMode	
	syntax : $getfixmode = SetSpriteFixMode(Alias)
	Note ;  0 = normal
			1 = not animated sprite
#CE
Func GetSpriteFixMode($S_Alias) 
	$S_GetSpriteFixMode = DllCall($S_DLL, "long", "GetSpriteFixMode", "long", $S_Alias)
	If @error Then 
		Return @error
	Else	
		Return $S_GetSpriteFixMode[0]
	EndIf
EndFunc

#CS 
	CountSprites	
	syntax : $count = CountSprites()
	counts all sprites
#CE
Func CountSprites() 
	$countSprites = DllCall($S_DLL, "long", "CountSprites")
	Return $countSprites[0]
EndFunc

#CS 
	SetSpriteLayer	
	syntax : SetSpriteLayer(Alias, layer)
	Sets new layer for sprite, means that you can set the sprite to the foreground or background of another sprite
#CE
Func SetSpriteLayer($S_Alias,$S_layerNum)
	DllCall($S_DLL, "long", "SetSpriteLayer", "long", $S_Alias, "long", $S_layerNum) 
	Return @error
EndFunc

#CS 
	GetSpriteLayer	
	syntax : $getlayer = GetSpriteLayer(Alias)
	returns the sprite layer
#CE
Func GetSpriteLayer($S_Alias) 
	$S_GetSpriteLayer = DllCall($S_DLL, "long", "GetSpriteLayer", "long", $S_Alias)
	Return $S_GetSpriteLayer[0]
EndFunc

#CS 
	BringSpriteToTop	
	syntax : BringSpriteToTop(Alias)
	brings sprite on top of all other sprites
#CE
Func BringSpriteToTop($S_Alias) 
	DllCall($S_DLL, "long", "BringSpriteToTop", "long", $S_Alias)
EndFunc

#CS 
	BringSpriteToBottom	
	syntax : BringSpriteToBottom(Alias)
	gives sprite the lowest layer
#CE
Func BringSpriteToBottom($S_Alias)
	DllCall($S_DLL, "long", "BringSpriteToBottom", "long", $S_Alias)
EndFunc

#CS 
	SpriteToHDC
	syntax : SpriteToHDC(Alias)
	copie sprite to screen, and become part of the window, sprite will not animate anymore
#CE
Func SpriteToHDC($S_Alias) 
	$S_SpriteToHDC = DllCall($S_DLL, "long", "SpriteToHDC", "long", $S_Alias)
	Return $S_SpriteToHDC[0]
EndFunc

Func SpriteThreadBrake($M_Seconds) 
	DllCall($S_DLL, "long", "SpriteThreadBrake", "long", $M_Seconds)
EndFunc

#CS	
	$Spritebitmap       	   = 0
	$Offset_X          		   = 4
	$Offset_Y          		   = 8 
	$HDC_window        		   = 56
	$Buffer_copie1     		   = 68
	$Buffer_copie2      	   = 84
	$Background_mode     	   = 92
	$Background_scroll_X 	   = 96
	$Background_scroll_Y 	   = 100
	$sprite_markNR             = 156
	$Start_MoveSpriteWithTable = 312
#CE
Func ChangeSpritePara($S_Alias, $Parameter, $new_value)
	DllCall($S_DLL, "long", "ChangeSpritePara", _
					"long",$S_Alias, _
					"long",$Parameter, _
					"long",$new_value)
EndFunc

#CS 
	SetmovingRectangle	
	syntax : SetmovingRectangle($S_Alias, LEFT, TOP, RIGHT, BOTTOM)
	Note ;  $S_Alias = user defined string of the sprite created by function Sprite()
			LEFT = Left screen position
			TOP = Top screen position
			RIGHT = Right screen position
			BOTTOM = Bottom screen position
			This creates a cage for the sprites 
			The sprite cannot come outside the cage and is bouncing back when it hits the cage			
			For every sprite you have to create this function
#CE
Func SetmovingRectangle($S_Alias,$S_LEFT, $S_TOP, $S_RIGHT, $S_BOTTOM)
	DllCall($S_DLL, "long", "SpriteMovingRect", _
					"long",$S_Alias, _
					"long",$S_LEFT, _
					"long",$S_TOP, _
					"long",$S_RIGHT, _
					"long",$S_BOTTOM)
EndFunc

#CS 
	AtackSprite	
	syntax : AtackSprite($S_Alias1, $S_Alias1, pixel x, pixel y)
	Note ;  Set sprite nr 1 to attack sprite nr 2 
			$S_Alias1 = user defined string of the sprite created by function Sprite()
			$S_Alias2 = user defined string of the sprite created by function Sprite()
			pixel x = amount of pixels to sprite nr 2
			pixel y = amount of pixels to sprite nr 2
			If pixel x and y = set to 10 ,sprite nr 1 stays 10 pixels on x and y postion away from sprite nr 2 
			To stop the attack, use; AtackSprite($S_Alias1, 0, 0, 0)
#CE
Func AtackSprite($S_Alias1, $S_Alias2, $S_DX, $S_DY)
	DllCall($S_DLL, "long", "AttachSprite", _
					"long",$S_Alias1, _
					"long",$S_Alias2, _
					"long",$S_DX, _
					"long",$S_DY)
EndFunc

#CS 
	Collide	
	syntax : $space1_space2 = Collide($S_Alias1, $S_Alias2)
	Note ;  let 2 sprites collide
			$S_Alias1 = user defined string of the sprite created by function Sprite()
			$S_Alias2 = user defined string of the sprite created by function Sprite()
	example ; 
			If $space1_space2 <> 0 then func()	
#CE
Func Collide($S_Alias1, $S_Alias2)
	$Collide = DllCall($S_DLL, "long", "Collide", _
							   "long",$S_Alias1, _
							   "long",$S_Alias2)	
	Return $Collide[0]
EndFunc

#CS 
	CollideMore	
	Syntax ; $col = CollideMore()
	note ; need user defined string for return string
	$col ;gives sprite collision pointers back or 0
	0 = no collission detected
#CE
Func CollideMore($S_Alias)
	$S_STR = "long;long"
	$CollideMoreInfos = DllStructCreate($S_STR)
	$MoreInfos = DllCall($S_DLL, "long", "CollideMore", _
								 "long", DllStructGetPtr($CollideMoreInfos))
	If $MoreInfos[0] <> 0 Then
		$S_HIT   = DllStructGetData($CollideMoreInfos, 2)
		$S_Alias = DllStructGetData($CollideMoreInfos, 1)
		Return $S_HIT
	EndIf
	Return $MoreInfos[0]
EndFunc

#CS 
	Collision	
	syntax : $bee1_bee2 = Collision($S_Alias1, $S_Alias2, pixel x, pixel y)
	Note ;  let 2 sprites collide
			This function is pixel accurate
			$S_Alias1 = user defined string of the sprite created by function Sprite()
			$S_Alias2 = user defined string of the sprite created by function Sprite()
			pixel x = amount of pixels to sprite nr 2 ,must be greater then 0
			pixel y = amount of pixels to sprite nr 2 ,must be greater then 0
	example ;
			If $bee1_bee2 <> 0 then func()	
#CE 
Func Collision($S_Alias1, $S_Alias2, $S_pixelX, $S_pixelY)
	$Collision = DllCall($S_DLL, "long", "Collision", _
								 "long",$S_Alias1, _
								 "long",$S_Alias2, _
								 "long",$S_pixelX, _
								 "long",$S_pixelY)
	Return $Collision[0]
EndFunc

#CS 
	CollideUnknown	
	syntax : $Col = CollideUnknown()
	Note ;  let multiple sprites collide
			This function is not pixel accurate
			No parameters required
			$col must be user defined string
			return strings ; $col gives SpritePointer or 0
				0 = no collission detected
#CE 
Func CollideUnknown()
	$CollideUnknownInfos = DllStructCreate("long;long")
	$UnknownInfos = DllCall($S_DLL, "long", "CollideUnknown", _
									"long", DllStructGetPtr($CollideUnknownInfos))
	If $UnknownInfos <> 0 Then
		$S_HIT = DllStructGetData($CollideUnknownInfos, 2)
		Return $S_HIT
	EndIf
	Return $UnknownInfos[0]
EndFunc

#CS 
	CollideAll	
	syntax : $col_bee1 = CollideAll($S_Alias)
	Note ;  This function is not pixel accurate
			CollideAll let a sprite collide with all other sprites
			$col_bee1 gives number above 0 if collide with other sprites
			$col_bee1 must be user defined string
	example ;		
			if $col_bee1 <> 0 then func()			
#CE 
Func CollideAll($S_Alias) 
	$CollideAll = DllCall($S_DLL, "long", "CollideAll", "long", $S_Alias)
	Return $CollideAll[0]
EndFunc

#CS 
	SetBackAutoCollision	
	syntax : SetBackAutoCollision(Alias, Mask, Mode, Width, Height, Sound)
	Note ;  Automatic Sprite-background collisions function
			Alias = user defined sprite name made by function sprite()
			Mask = mask image loaded with funcion LoadImage()
			Mode =  0 = No Auto-Collision with background 
					1 = Sprite react like a wall 
					2 = Sprite react like a gummiball and bounce away from background 
					3 = Sprite react like mode 2, but Sprite bounce up 
					4 = Sprite react like mode 2, but Sprite bounce right
					5 = Sprite react like mode 2, but Sprite bounce down
					6 = Sprite react like mode 2, but Sprite bounce left
					7 = Sprite get's new animation and will be deleted after animation is ended
			Width ,Height = image width,Height loaded with funcion LoadImage()
			Sound = every time a sprite hit's the background a sound can be played
			parameter for sound = 0 no sound or user defined string contains a loaded sound
			To load a sound first you need the function; DSoundInit()					  
			Then load the sound with function; $explo = DSoundLoad(c:\data\explosion.wav)								 
#CE
Func SetBackAutoCollision($S_Alias, $S_Mask, $S_Mode, $SW_Width, $SW_Height, $S_Sound)
	DllCall($S_DLL, "long", "SetBackAutoCollision", _
					"long",$S_Alias, _
					"long",$S_Mask, _
					"long",$S_Mode, _
					"long",0, _
					"long",0, _
					"long",$SW_Width, _
					"long",$SW_Height, _
					"long",0, _
					"long",0, _
					"long",0, _
					"long",$S_Sound) 
EndFunc

#CS 
	MarkSprite	
	syntax : MarkSprite($S_Alias, Number)
	Note ;  This function marks a sprite
			$S_Alias = use defined Spritename
			Number = user defined number
			example ; MarkSprite($spaceship,125)	,gives $spaceship the number 125		
#CE 
Func MarkSprite($S_Alias,$S_number)
	DllCall($S_DLL, "long", "MarkSprite", _
					"long",$S_Alias, _
					"long",$S_number)
EndFunc

#CS 
	GetSpriteMark	
	syntax : $check = GetSpriteMark($S_Alias)
	Note ;  This function get's the user defined number of the marked sprite
			$S_Alias = use defined Spritename
			$check holds the user defined number
			$check must be a userdefined string
#CE 
Func GetSpriteMark($S_Alias) 
	$S_GetSpriteMark = DllCall($S_DLL, "long", "GetSpriteMark", "long", $S_Alias)
	Return $S_GetSpriteMark[0]
EndFunc

#CS 
	DeleteSprite	
	syntax : DeleteSprite($S_Alias)
	Note ;  Delete sprite from window
#CE 
Func DeleteSprite($S_Alias) 
	DllCall($S_DLL, "long", "DeleteSprite", "long", $S_Alias)
EndFunc

#CS 
	DeleteAllSprites	
	syntax : DeleteAllSprites()
	Note ;  Delete all sprites from window
#CE 
Func DeleteAllSprites()
	DllCall($S_DLL, "long", "DeleteAllSprites")
EndFunc

#CS 
	DeleteAllSpritesMark	
	syntax : DeleteAllSpritesMark(111)
	Note ;  Delete all sprites with mark 111
#CE 
Func DeleteSpriteMark($S_Mark)
	DllCall($S_DLL, "long", "DeleteSpritesMark", "long", $S_Mark)
EndFunc

#CS 
	DeleteSpritesIfAnimReady	
	syntax : DeleteSpritesIfAnimReady()
	delete sprite when animation seqence has ended
#CE 
Func DeleteSpritesIfAnimReady()
	DllCall($S_DLL, "long", "DeleteSpritesIfAnimReady")
EndFunc

Func CleanUp($S_Mark)
	DllCall($S_DLL, "long", "CleanUp", "long", $S_Mark)
EndFunc

#CS 
	GetSpriteInfos	
	syntax : GetSpriteInfos($S_Alias)
	Note ;  Returm strings
			$current_X 		= The current Position X of the sprite on screen
			$current_Y 		= The current Position Y of the sprite on screen
			$goal_PosX 		= The Postion X where the sprite go's to called by func movesprite()
			$goal_PosY 		= The Postion Y where the sprite go's to called by func movesprite()
			$sprite_arrived = Is sprite arrived on position called by func movesprite() 0 / 1
			$speedX 		= Current X speed of sprite	  
			$speedY 		= Current Y speed of sprite	      
			$current_Frame  = Current frame of sprite in bitmap
			Example;
					GetSpriteInfos(1)
					If $sprite_arrived = 1 Then Movesprite(1, 600, 250, 4, 2)					
#CE 
Func GetSpriteInfos($S_Alias)
	$GetSpriteInfos = DllStructCreate("long;long;long;long;long;long;long;long")
	DllCall($S_DLL, "long", "GetSpriteInfos", _
					"long",$S_Alias, _
					"long",DllStructGetPtr($GetSpriteInfos))
	$current_X      = DllStructGetData($GetSpriteInfos, 1)
	$current_Y      = DllStructGetData($GetSpriteInfos, 2)
	$goal_PosX      = DllStructGetData($GetSpriteInfos, 3)
	$goal_PosY      = DllStructGetData($GetSpriteInfos, 4)
	$sprite_arrived = DllStructGetData($GetSpriteInfos, 5)
	$speedX         = DllStructGetData($GetSpriteInfos, 6)
	$speedY         = DllStructGetData($GetSpriteInfos, 7)
	$current_Frame  = DllStructGetData($GetSpriteInfos, 8)
EndFunc	

#CS 
	GetSpriteX	
	syntax : GetSpriteX(Alias)
	Note ;  Get sprite position on the X axis	
#CE 
Func GetSpriteX($S_Alias)
	$S_GetX = DllCall($S_DLL, "long", "GetSpriteX", _
							  "long",$S_Alias)
	Return $S_GetX[0]
EndFunc

#CS 
	GetSpriteY	
	syntax : GetSpriteY(Alias)
	Note ;  Get sprite position on the Y axis	
#CE 
Func GetSpriteY($S_Alias)
	$S_GetY = DllCall($S_DLL, "long", "GetSpriteY", _
							  "long",$S_Alias)
	Return $S_GetY[0]
EndFunc

#CS 
	GetSpriteMoveX	
	syntax : $getx = GetSpriteMoveX($S_Alias)
	Note ;  Sprite movement on the X axis
			Return = $SpriteMoveX
			Values =
			-1 = Sprite Moves left 
			0 = No movement 
			1 = Sprite Moves right
#CE 
Func GetSpriteMoveX($S_Alias) 
	$SpriteMoveX = DllCall($S_DLL, "long", "GetSpriteMoveX", _
								   "long",$S_Alias)
	Return $SpriteMoveX[0]
EndFunc

#CS 
	GetSpriteMoveY	
	syntax : $gety = GetSpriteMoveY($S_Alias)
	Note ;  Sprite movement on the Y axis
			Return = $SpriteMoveY
			Values = 
			-1 = Sprite Moves Up 
			0 = No movement 
			1 = Sprite Moves Down
#CE 
Func GetSpriteMoveY($S_Alias)
	$SpriteMoveY = DllCall($S_DLL, "long", "GetSpriteMoveY", _
								   "long",$S_Alias)
	Return $SpriteMoveY[0]
EndFunc

#CS 
	HasSpriteArrived	
	syntax : $Arrive = HasSpriteArrived($spaceship)
	Note ;  Test, if the sprite with user defined handle has arrived to coodinates defined with movesprite func
			Return Value = 0 not arrived
						   1 arrived
#CE 
Func HasSpriteArrived($S_Alias) 
	$S_rtn = DllCall($S_DLL, "long", "HasSpriteArrived", _
							 "long",$S_Alias)
	Return $S_rtn[0]
EndFunc

#CS
====================================================================================================================================
PixelEffects
====================================================================================================================================
#CE

#CS 
	InitPixelEffects	
	syntax : InitPixelEffects()
	Note ;  No parameters required
			initialiseert pixel effect
#CE 
Func InitPixelEffects()
	$WIN_TILLE     = WinGetTitle("","")
	$WIN_GETHANDLE = WinGetHandle($WIN_TILLE,"")
	$RAW_HDC       = DllCall("user32.dll","ptr","GetDC","hwnd",$WIN_GETHANDLE)
	$hDC           = "0x" & Hex($RAW_HDC[0])	
	$ClientSize    = WinGetClientSize($WIN_TILLE,"")	
	DllCall($S_DLL, "long", "InitPixelEffects")	
	$S_fensterkopie1 = DllCall($S_DLL, "long", "CreateExtBmp", _
									   "long",$hDC, _
									   "long",$ClientSize[0], _
									   "long",$ClientSize[1])
	$S_fensterkopie1 = DllCall($S_DLL, "long", "CreateExtBmp", _
									   "long",$hDC, _
									   "long",$ClientSize[0], _
									   "long",$ClientSize[1])
	DllCall($S_DLL, "long", "CopyExtBmp", _
					"long",$S_fensterkopie1[0], _
					"long",0, _
					"long",0, _
					"long",$ClientSize[0], _
					"long",$ClientSize[1], _
					"long",$hDC, _
					"long",0, _
					"long",0, _
					"long",0)
	DllCall($S_DLL, "long", "CopyExtBmp", _
					"long",$S_fensterkopie2[0], _
					"long",0, _
					"long",0, _
					"long",$ClientSize[0], _
					"long",$ClientSize[1], _
					"long",$hDC, _
					"long",0, _
					"long",0, _
					"long",0)
EndFunc	

#CS 
	SetPixelEffect	
	syntax : SetPixelEffect(offsetX, offsetY, Color, Disperse, PixelStrenght, Pixeldirection, PixelAmount, Colormode, LifeTime)
	Note ;  You have to Set InitPixelEffects() First
			offsetX, $S_offsetY = Postion on screen
			Color = Set color for the pixels
			disperse = How width the pixels must disperse (1 - 160) 
			PixelStrenght = Strenght of the pixels to come out (3 - 31)
			Pixeldirection = which direction the pixels must fall
			0 = ? 
			1 = Pixel fall to right 
			2 = Pixel fall down 
			3 = Pixel fall to left 
			4 = Pixel fall to top
			PixelAmount = How many pixels must be in the effect (3 - 1000)
			Colormode = There are 3 types
						0 = The startcolor specified by Color ,the pixel change darker and darker til they are black
						1 = The pixelcolor stay's the color specified by Color
						2 = Random Color ,Color is bypassed 
			LifeTime = how long the pixels stay onscreen (10 - 300)
	Example ;
	SetPixelEffect(Random(50,750,1), Random(50,350,1), 0x00ffff, 24, 13, 2, 200, 1, 100)
#CE 
Func SetPixelEffect($S_offsetX, $S_offsetY, $S_Color, $S_Disperse, $S_PixelStrenght, $S_Pixeldirection, $S_PixelAmount, $S_Colormode, $S_LifeTime)
	DllCall($S_DLL, "long", "SetPixelEffect", _
					"long",$hDC, _
					"long",$S_fensterkopie1[0], _
					"long",$S_offsetX, _
					"long",$S_offsetY, _
					"long",$S_Color, _
					"long",$S_Disperse, _
					"long",$S_PixelStrenght, _
					"long",$S_Pixeldirection, _
					"long",$S_Pixelamount, _
					"long",$S_Colormode, _
					"long",$S_LifeTime)
EndFunc

#CS 
	DeInitPixelEffects	
	syntax : DeInitPixelEffects()
	Note ;  No parameters required
			Stops the pixeleffect
#CE 
Func DeInitPixelEffects()
	DllCall($S_DLL, "long", "DeInitPixelEffects")
EndFunc

#CS 
	Stars
	syntax : Stars(LEFT, TOP, RIGHT, BOTTOM, STARS, SPEED)
	Note ;  left = left side of screen for the pixel effect
			TOP = top of screen for the pixel effect
			Right = right side of screen for the pixel effect
			Bottom = bottom of the screen for the pixel effect
			Stars = how many stars on screen
			speed = how fast the stars move
			example; Stars(0, 0, 800, 600, 300, 4)
			makes a starfield 800x600 with 300 stars
#CE
Func Stars($S_WITH_LEFT, $S_TOP, $S_WITH_RIGHT, $S_BOTTOM, $S_STARS, $S_SPEED)
	$WIN_TILLE = WinGetTitle("", "")
	$WIN_GETHANDLE = WinGetHandle($WIN_TILLE, "")
	$RAW_HDC = DllCall("user32.dll", "ptr", "GetDC", "hwnd", $WIN_GETHANDLE)
	$hDC     = "0x" & Hex($RAW_HDC[0])
	DllCall($S_DLL, "long", "Stars", _
					"long",$hDC, _
					"long",0, _
					"long",$S_WITH_LEFT, _
					"long",$S_TOP, _
					"long",$S_WITH_RIGHT, _
					"long",$S_BOTTOM, _
					"long",$S_STARS, _
					"long",$S_SPEED, _
					"long",1)
EndFunc

#CS 
	OptionStars
	syntax : OptionStars(Offset, Offset, X movement, Y movement, speed) 
	Note ;  Change paramaters set by function Stars()
			Offset,Offset = coordinates on screen from where the stars must come from
			X movement,Y movement = Witch direction the stars move to (-10 / +10 ) ,if set to high pixels are offscreen
			speed = how fast the stars move
#CE
Func OptionStars($X_Offset,$Y_Offset,$X_movement,$Y_movement,$S_speed) 
	DllCall($S_DLL, "long", "OptionStars", _
					"long", $X_Offset, _
					"long",$Y_Offset, _
					"long",$X_movement, _
					"long",$Y_movement, _
					"long",$S_speed) 
EndFunc

#CS 
	StatusStars
	syntax : $checkstars = StatusStars()
	Note ;  return string = 0 or 1
			0 = stars effect has stopped
			1 = stars effect is still running			
#CE
Func StatusStars()
	$StatusStars = DllCall($S_DLL, "long", "StatusStars")
	Return $StatusStars[0]
EndFunc

#CS 
	NoStars	
	syntax : NoStars(Mode)
	Note ;  Mode can be ; 0/1/2/3
			0 = Continue the stars effect
			1 = Stop the stars effect and leave the remaing stars on screen
			2 = Stop the stars effect and delete all stars from screen
			3 = stop the stars effect and let the remaing stars fly out of the screen
			
#CE 
Func NoStars($S_Mode)
	DllCall($S_DLL, "long", "NoStars", "long", $S_Mode)
EndFunc

#CS
===================================================================================================================================
Joystick and Mouse
===================================================================================================================================
#CE

#CS
	FindJoystick
	Syntax; $find_joy = FindJoystick(1)
	returns 0 or 1 
	0 = no joystick found
	1 = joystick 1 found
#CE
Func FindJoystick($J_STICK)
	Select
		Case $J_STICK = 1
			$S_joy1 = DllCall($S_DLL, "long", "FindJoystick", "long",1)
			Return $S_joy1[0]
		Case $J_STICK = 2
			$S_joy2 = DllCall($S_DLL, "long", "FindJoystick", "long",2)
			Return $S_joy2[0]
	EndSelect
EndFunc

#CS
	CountJoystickButtons
	Syntax; $countButt = CountJoystickButtons(1)
	returns ;Number of buttons
#CE
Func CountJoystickButtons($J_STICK)
	$S_Count_buttons = DllCall($S_DLL, "long", "CountJoystickButtons", "long", $J_STICK)
	Return $S_Count_buttons[0]
EndFunc 

#CS
	JoystickX , x axis
	Syntax; $joyX = JoystickX(1)
	returns -127 / 127 
	-127 = most left
	127 = most right
	all values under 24 or -24 should be ignored
#CE
Func JoystickX($J_STICK)
	$S_JoystickX = DllCall($S_DLL, "long", "JoystickX", "long", $J_STICK)	
	Return $S_JoystickX[0]
EndFunc

#CS
	JoystickY ;  y axis
	Syntax; $joyY = JoystickY(1)
	returns -127 / 127 
	-127 = Down
	127 = Up
	all values under 24 or -24 should be ignored
#CE
Func JoystickY($J_STICK)
	$S_JoystickY = DllCall($S_DLL, "long", "JoystickY", "long", $J_STICK)	
	Return $S_JoystickY[0]
EndFunc

#CS
	JoystickButton
	Syntax; $joyBut = JoystickButton(1)
	Support for 32 buttons
	returns 0 / 32 
	0 = no button pressed
	1 / 32 button pressed
#CE
Func JoystickButton($J_STICK)
	$S_Buttons = DllCall($S_DLL, "long", "JoystickButton", "long", $J_STICK)
	Return $S_Buttons[0]
EndFunc

#CS
	JoystickZ ,z axis
	Syntax; $joyZ = JoystickZ(1)
	returns -127 / 127 
	or 256 when joystick has no Z axis
	all values under 24 or -24 should be ignored
#CE
Func JoystickZ($J_STICK)
	$S_JoystickZ = DllCall($S_DLL, "long", "JoystickZ", "long", $J_STICK)	
	Return $S_JoystickZ[0]
EndFunc

#CS
	JoystickR ; Roar or pedals
	Syntax; $joyR = JoystickR(1)
	returns -127 / 127 
	or 256 when joystick has no R axis
	all values under 24 or -24 should be ignored
#CE
Func JoystickR($J_STICK)
	$S_JoystickR = DllCall($S_DLL, "long", "JoystickR", "long", $J_STICK)	
	Return $S_JoystickR[0]
EndFunc 

#CS
	JoystickU ; u axis or 5th axis
	Syntax; $joyU = JoystickU(1)
	returns -127 / 127 
	or 256 when joystick has no U axis
	all values under 24 or -24 should be ignored
#CE
Func JoystickU($J_STICK)
	$S_JoystickU = DllCall($S_DLL, "long", "JoystickU", "long", $J_STICK)	
	Return $S_JoystickU[0]
EndFunc 

#CS
	JoystickV ; V axis or 6th axis
	Syntax; $joyV = JoystickV(1)
	returns -127 / 127 
	or 256 when joystick has no V axis
	all values under 24 or -24 should be ignored
#CE
Func JoystickV($J_STICK)
	$S_JoystickV = DllCall($S_DLL, "long", "JoystickV", "long", $J_STICK)	
	Return $S_JoystickV[0]
EndFunc

#CS
Function MouseOverSprite
Syntax = $check = MouseOverSprite($bee1)
note;  Alias = use defined Spritename
example; $check = MouseOverSprite($bee1)
		 If $check <> 0 the function()
#CE
Func MouseOverSprite($S_Alias)		
	$S_long  = "long"
	$S_Check = DllStructCreate($S_long)
	DllStructSetData($S_Check, 1, $S_Alias)
	$S_pos = MouseGetPos()
	$S_rtn = DllCall($S_DLL, "long", "MouseOverSprite", _
							 "long", DllStructGetPtr($S_Check, 1), _
							 "long", 1, _
							 "long", $S_pos[0], _
							 "long", $S_pos[1])
	Return $S_rtn[0]
EndFunc

#CS
Function MouseButton()
Syntax = $MouseClick = MouseButton()
note;  Return strings 
		0 = No mouseclick 
		1 = Left button
		2 = Right button
		4 = mid button
#CE
Func MouseButton()
	$M_Mouse = DllCall($S_DLL, "long", "MouseButton")
	Return $M_Mouse[0]
EndFunc

#CS
Function SetMouseXY()
Syntax = SetMouseXY(posX, posY)
note;  Set mousepointer at Coordinates posX, posY
#CE
Func SetMouseXY($M_posX, $M_posY)
	DllCall($S_DLL, "long", "SetMouseXY", _
					"long", $M_posX, _
					"long", $M_posY)
EndFunc

#CS
Function SetMouseRect()
Syntax = SetMouseRect(Left, Top, MaxX, MaxY)
note;  Set a cage for mousepointer, mousepointer can not move outside coodinates
example; SetMouseRect(100, 100, 200, 200) 	   		 
		 To undo mouse coodinates, set ;
		 SetMouseRect(0, 0, @DesktopWidth, @DesktopHeight)
#CE
Func SetMouseRect($M_Left, $M_Top, $M_MaxX, $M_MaxY) 
	DllCall($S_DLL, "long", "SetMouseRect", _
					"long",$M_Left, _
					"long",$M_Top, _
					"long",$M_MaxX, _
					"long",$M_MaxY)
EndFunc

#CS
===================================================================================================================================
ScreenShot
===================================================================================================================================
#CE
#CS 
	Screenshot	
	syntax : Screenshot(path, Width, Height, ShotPosX, ShotPosY, Type)
	Note ;  path = Filepath + Filename (C:\Temp\Screen.jpg)
			Width, Height = How big sceenshot must be (640,480)
			ShotPosX, ShotPosY = Witch part off the screen to take a screenshot
			Type ; 0 = bmp
				   1 = jpg
#CE
Func Screenshot($S_path, $S_Width, $S_Height, $S_ShotPosX, $S_ShotPosY, $S_Type)
	$RAW_HDC = DllCall("user32.dll", "ptr", "GetWindowDC", "hwnd", "")
	$hDC     = "0x" & Hex($RAW_HDC[0])
	$S_Screen = DllCall($S_dll, "long", "CreateExtBmp", _
								"long", $hDC, _
								"long", $S_Width, _
								"long", $S_Height)	
	DllCall($S_dll, "long", "CopyExtBmp", _
					"long", $S_Screen[0], _
					"long", -3, _
					"long", -3, _
					"long", $S_Width, _
					"long", $S_Height, _
					"long", $hDC, _
					"long", $S_ShotPosX, _
					"long", $S_ShotPosY, _
					"long", 0)	
	$S_FilePath = $S_path 
	DllCall($S_DLL, "long", "SaveExtImage", _
					"long", $S_Screen[0], _
					"str" , $S_FilePath, _
					"long", $S_Type, _
					"long", 10)
EndFunc

#CS
===================================================================================================================================
DirectXSound
===================================================================================================================================
#CE
#CS
	Function DSoundInit
	syntax : DSoundInit()
	Note ;  No parameters required
#CE
Func DSoundInit()
	$WIN_TITLE     = WinGetTitle("", "")
	$WIN_GETHANDLE = WinGetHandle($WIN_TITLE, "")
	DllCall($S_DLL, "long", "DSoundInit", "long", $WIN_GETHANDLE)
EndFunc

#CS
	Function DSoundLoad
	syntax : $Media1 = DSoundLoad(File)
	Note ;  Needs a user defined string before the func
			File = Filepath + Filename
#CE
Func DSoundLoad($DL_File)
	$D_Buffer = DllCall($S_DLL, "long", "DSoundLoad", "str", $DL_File)
	Return $D_Buffer[0]
EndFunc

#CS
	Function DSoundPlay
	syntax : $Explosion = DSoundPlay(Alias, Volume, loop)
	Note ;  Needs a user defined string before the func
			Alias = user defined string created with Function DSoundLoad()
			Volume = Set Sound Volume of played sound Values between -10000 and 0
			loop ; 0 = noloop ,1 = loop
#CE
Func DSoundPlay($DP_Alias, $D_Volume, $S_loop)
	$DB_Buffer = DllCall($S_DLL, "long", "DSoundGetNextBuffer", "long", $DP_Alias)
	DllCall($S_DLL, "long", "DSoundSetVolume", _
					"long", $DB_Buffer[0], _
					"long", $D_Volume)
	$D_Play = DllCall($S_DLL, "long", "DSoundPlay", _
							  "long", $DP_Alias, _
							  "long", $S_loop)
	Return $D_Play[0]
EndFunc

#CS
	Function DSoundStop
	syntax : DSoundStop(Alias)
	Note ;  Alias = user defined string created with Function DSoundPlay()
#CE
Func DSoundStop($DP_Alias) 
	DllCall($S_DLL, "long", "DSoundStop", "long", $DP_Alias)
EndFunc

#CS
	Function DSoundSetPan
	syntax : DSoundSetPan(Alias, Value)
	Note ;  Alias = user defined string created with Function DSoundPlay()
			Value = Between -10000 and 10000 Left/Right
#CE
Func DSoundSetPan($DP_Alias, $D_Value) 
	DllCall($S_DLL, "long", "DSoundSetPan", _
					"long", $DP_Alias, _
					"long", $D_Value)
EndFunc

#CS
	ChangeDisplay
	syntax : ChangeDisplay(640, 480)
	change screenresolution
#CE
Func ChangeDisplay($SW_Width, $SW_Height)
	DllCall($S_DLL, "long", "ChangeDisplay", _
					"long", $SW_Width, _
					"long", $SW_Height)
EndFunc

#CS
	PaintNew
	syntax : PaintNew()
	redraws the screen
#CE
Func PaintNew()
	DllCall($S_DLL, "long", "CopyExtBmp", _
					"long",$hDC, _
					"long",0, _
					"long",0, _
					"long",$S_WIDTH[0], _
					"long",$S_HEIGHT[0], _
					"long",$S_fensterkopie1[0], _
					"long",0, _
					"long",0, _
					"long",0)
EndFunc

Func Close_DLL()
	DllClose($S_DLL)
EndFunc