#include <Prospeed.au3>
Opt("GUIOnEventMode", 1)
Opt("PixelCoordMode", 2)

$GUI = GUICreate("Image To String", 600, 400, -1, -1)
$var = FileOpenDialog("", "C:\", "Images (*.jpg;*.bmp;*.png;*.gif)", 1 + 4)
If @error Then
    MsgBox(4096,"","No File(s) chosen")
	Exit
Else
    $var = StringReplace($var, "|", @CRLF)
EndIf
GUISetState()

Background("" , 0, 0, 600, 400)

BitmapToString($var, Random(1,99,1))

Func BitmapToString($SP_Raw_pic, $SP_Stringnum)
	$SP_Bitmap = LoadExtImage($SP_Raw_pic)
	$SP_Width  = GetBmpWidth($SP_Bitmap)
	$SP_Height = GetBmpHeight($SP_Bitmap)
	$SP_FILE   = FileOpen(@ScriptDir & "\tmp.au3", 2)
	FileWrite($SP_FILE,"; <= Begin SpriteData 6 digit hex colordata (BGR)"&" Bitmap Dimensions (Width "&$SP_Width&" x Height "&$SP_Height&")"&@CRLF)	
	CopyExtBmp($hdc, 0, 0, $SP_Width, $SP_Height, $SP_Bitmap, 0, 0, 0)
	$SP_copyY  = 0
	For $i = 1 To $SP_Height
		If $i = 1 Then FileWrite($SP_FILE,'$STR'&$SP_Stringnum&' ="')
		If $i > 1 Then FileWrite($SP_FILE,'$STR'&$SP_Stringnum&'&="')
		For $SP_w = 1 To $SP_Width
			$getpixel = PixelGetColor($SP_w, $SP_copyY)
			$getpixel = Hex($getpixel, 6)		
			$SP_split = StringSplit($getpixel, "")
			FileWrite($SP_FILE, $SP_split[5]&$SP_split[6]&$SP_split[3]&$SP_split[4]&$SP_split[1]&$SP_split[2])
		Next
		FileWrite($SP_FILE,'"'&@CRLF)
		$SP_copyY +=1	
	Next
	FileWrite($SP_FILE,"; <= End SpriteData")
	FileClose($SP_FILE)
	FreeExtBmp($SP_Bitmap)
	ShellExecute("tmp.au3", "", @ScriptDir, "")	
	Exit
EndFunc