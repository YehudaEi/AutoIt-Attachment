#include <GuiConstantsEx.au3>
#include <GDIPlus.au3>
#include <ScreenCapture.au3>
#cs ----------------------------------------------------------------------------
	AutoIt Version: 3.2.13.3 (beta)
	Author:         Zackrspv
	
	Script Function:
	Convert RTF from MSCOMCT2.ocx to HTML, version .4
	
	History:
	*Version .4 - Added automatic WMF -> JPG handling, fixing of HTML code to change
				  WMF to JPG exteions; tested Word and Wordpad RTF, and they are compatible; 
				  Tested embeded images, JPG/BMP/WMF/EMF/GIF all embed, but Smart Art (2007) does not.
				  Tables work, but table formatting (background/color) does not.
	Version .3 -- Initial Autoit Forum Release
	
#ce ----------------------------------------------------------------------------
; Script Start - Add your code below here
#cs
	Functions:
	Func R2H($rtf, $html, $FLAGS = 0, $ImagesDIR = "", $hex = "#000000")
#CE
#include-once

;- Define all globals used by the include
Global $rtfdata, $c11, $rtfcolor, $rtfc11, $1, $2, $3, $rtf, $html, $flag, $ImagesDIR, $dll, $result, $code, $search, $file, $imname, $sCLSID
Global $hGUI, $hBitmap, $hGraphic, $hImage, $iX, $iY, $hClone

;===============================================================================
;
; Function Name:    _R2h()
; Description:      Convert: RTF to HTML
; Parameter(s):     $rtf = File for RTF
;					$html = File for HTML
;					$FLAGS = Conversion Flags
; 							0 - No flags (Default, no need to specify flags)
;                    	 	1 - Use image size ->  Insert HTML code for the 
;                       	     image using the RTF image size instead of 
;								 using the screen resolutions size.
;                     		2 - Use image directory -> If used, will
;                         		create a directory for storing images
;                         		embedded within the html document, otherwise
;								will output to script directory: out.html.files
;                     		4 - PreferUnicode -> Use unicode character set for
; 							    special characters instead. (experimental)
;					$ImagesDIR = Embeded directory name, so that IE source
;								 knows where to find images.
; 					$hex = Default HEX color (black) incase conversion fails.
;
; Requirement(s):   r2h.dll, mscomct2.ocx (in windows\system32)
; Return Value(s):  On Success - Returns HTML value in $code
;                   On Failure - Returns -1  (Unable to convert) and sets
;											@ERROR = error state with meanings:
; 												@error = 1 unable to use the DLL file (called incorrectly),
; 												@error = 2 unknown "return type",
; 												@error = 3 "function" not found in the DLL file.

;
; Authors:        Original DLL Code  						-                                       
;					Conversion to AutoIt					- zackrspv
;					Edit for UDF and Cleanup Code			- zackrspv
;
;===============================================================================
Func _R2H($rtf, $html, $FLAGS = 0, $ImagesDIR = "", $hex = "#000000")
	If $FLAGS = 1 Then
		$ImagesDIR = @ScriptDir & "\out.html.files"
	Else
		$ImagesDIR = $ImagesDIR
	EndIf

	$dll = DllOpen("r2h.dll") ;- open needed r2h.dll
	$result = DllCall($dll, "int:cdecl", "Convert", "str", $rtf, "str", $html, "ulong", $FLAGS, "str", $ImagesDIR) ;- call the Convert function, requires :cdecl call
	If @error <> 0 Then
		SetError(@error)
		Return -1
	EndIf
	DllClose($dll) ;- close the dll
	$code = FileRead($html) ;- read the converted html
	$rtfdata = FileRead($rtf) ;- read the origonal rtf code
	$c11 = StringRegExp($rtfdata, "(?i)(?s)(?:\{\\colortbl );(.*?);", 3) ;- pull out the color table
	If IsArray($c11) Then
		$rtfcolor = $c11[0] ;- pull out the first color (which will be .c11 in CSS html code, which the dll misses)
		$rtfcolor = StringReplace($rtfcolor, "red", "") ;- remove the word 'red'
		$rtfcolor = StringReplace($rtfcolor, "green", "") ;- remove the word 'green'
		$rtfcolor = StringReplace($rtfcolor, "blue", "") ;- remove the word 'blue'
		$rtfc11 = StringSplit($rtfcolor, "\") ;- split the string
		If IsArray($rtfc11) Then
			$1 = Int($rtfc11[2]) ;- red
			$2 = Int($rtfc11[3]) ;- green
			$3 = Int($rtfc11[4]) ;- blue
			$hex = "#" & Hex($1, 2) & Hex($2, 2) & Hex($3, 2) ;- convert the INT values to a HEX code
		EndIf
	EndIf
	; Shows the filenames of all files in the current directory.
	$search = FileFindFirstFile($ImagesDIR & "\*.wmf")

	; Check if the search was successful
	If $search = -1 Then
	Else
		While 1
			$file = FileFindNextFile($search)
			If @error Then ExitLoop
			_WMF2JPG($file, $ImagesDIR) ;- Convert the WMF image to JPG
		WEnd
		; Close the search handle
		FileClose($search)
	EndIf
	$code = StringReplace($code, '.wmf"', '.jpg"') ;- replace .WMF" extension in HTML code to .JPG" to fix links if WMF is detected
	$code = StringReplace($code, ".lft", ".cl1{ color: " & $hex & "; }" & @LF & ".lft") ;- add the .c11 CSS code to the HTML
	FileDelete($html) ;- delete old HTML
	FileWrite($html, $code) ;- write new HTML
	ShellExecute($html) ;- Open the HTML in browser
	Return $code ;- return the HTML code
EndFunc   ;==>_R2H

;===============================================================================
;
; Function Name:    _WMF2JPG()
; Description:      Convert: WMF to JPG Images
; Parameter(s):     $image = Name of WMF Image
;					$ImagesDIR = Directory to locate WMF Image
;
; Requirement(s):   GDIPlus
; Return Value(s):  On Success - Saves JPG image
;                   On Failure - Nothing, skips the conversion of the WMF File
;
; Authors:        	Conversion to AutoIt					- zackrspv
;					Edit for UDF and Cleanup Code			- zackrspv
;
;===============================================================================
Func _WMF2JPG($image, $ImagesDIR)
	$imname = StringTrimRight($image, 4)
	; Initialize GDI+ library
	_GDIPlus_Startup()
	$hImage = _GDIPlus_BitmapCreateFromFile($ImagesDIR & "\" & $image)
	; Create 24 bit bitmap clone
	$iX = _GDIPlus_ImageGetWidth($hImage)
	$iY = _GDIPlus_ImageGetHeight($hImage)
	$hClone = _GDIPlus_BitmapCloneArea($hImage, 0, 0, $iX, $iY, $GDIP_PXF24RGB)
	; Get JPEG encoder CLSID
	$sCLSID = _GDIPlus_EncodersGetCLSID("JPG")
	; Save bitmap to file
	_GDIPlus_ImageSaveToFileEx($hImage, $ImagesDIR & "\" & $imname & ".jpg", $sCLSID)
	; Clean up resources
	_GDIPlus_ImageDispose($hClone)
	_GDIPlus_ImageDispose($hImage)
	_WinAPI_DeleteObject($hBitmap)
	; Shut down GDI+ library
	_GDIPlus_Shutdown()
EndFunc   ;==>_Main