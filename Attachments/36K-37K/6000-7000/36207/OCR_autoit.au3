#include <Clipboard.au3>
#include <ScreenCapture.au3>

; ====================================================================================================================
; Description ...: 	 OCR image from clipboard and return text value into clipboard, designed as stand alone app run 
;					 by keybord shourtcut, just after copying image from adobe reader skan. 
; Author ........: 	 Piotr Szmolke 
; Notes .........:
; ====================================================================================================================


Global $tesseract_temp = @MyDocumentsDir

Local $hGUI,$hImage,$final_ocr 

; Open the clipboard
_ClipBoard_Open($hGUI)
$hImage = _ClipBoard_GetDataEx($CF_BITMAP)
; On error Exit
If $hImage = 0 Then 
   MsgBox(16,"Error ","No image in clipboard",1)
   Exit
EndIf

_ScreenCapture_SaveImage($tesseract_temp & "\Autoit_ocr_temp.jpg", $hImage)

$ocr_filename_and_ext = $tesseract_temp & "\Autoit_ocr_temp.txt"
$ocr_filename = StringLeft($ocr_filename_and_ext, StringLen($ocr_filename_and_ext) - 4)

ShellExecuteWait(@ProgramFilesDir & "\tesseract-OCR\tesseract.exe", $tesseract_temp	 & "\Autoit_ocr_temp.jpg" & " " & $ocr_filename)

$final_ocr = FileRead($ocr_filename_and_ext)

; dont want to scan more then one line of text
$final_ocr = StringStripCR($final_ocr)
$final_ocr = StringReplace($final_ocr, @LF, "")

_ClipBoard_SetData($final_ocr)
MsgBox(0, "Tesseract-OCR Text Capture", $final_ocr,3)

; Clean up
FileDelete($tesseract_temp & "\" & "Autoit_ocr_temp.*")