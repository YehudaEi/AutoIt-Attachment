#include <Date.au3>
Dim $oMyError

; Initialize error handler 
$oMyError = ObjEvent("AutoIt.Error","MyErrFunc")

while(1)


if (GetText("c:\ocr_test.bmp","private")==True) Then
	
	ConsoleWrite("FOUND in ocr_test.bmp" & @CRLF)
Else
	ConsoleWrite("NOT FOUND in ocr_test.bmp" & @CRLF)
EndIf


if (GetText("c:\screen_dump.bmp","private")==True) Then
	ConsoleWrite("FOUND in screen dump" & @CRLF)
Else
	ConsoleWrite("NOT FOUND in screen dump" & @CRLF)
EndIf

WEnd

Func GetText($bmp,$searchTxt)

Dim $str
Dim $oWord
dim $start_time
dim $stop_time


$start_time=TimerInit()

Const $miLANG_ENGLISH = 9
;create the ocr instance
dim $miDoc
$miDoc = ObjCreate("MODI.Document")

$miDoc.Create($bmp);load the image into the ocr engine (M$ use the word create, should really be load)
$miDoc.Ocr($miLANG_ENGLISH, True, True);find english words
if (@error>0) Then
	ConsoleWrite("OCR failed"& @CRLF)
	SetError(1)
EndIf	
For $oWord in $miDoc.Images(0).Layout.Words;get all the words and put them into one big string
    $str = $str & $oWord.text
;	ConsoleWrite("recognition confidance = " & $oWord.RecognitionConfidence() & "for " & $oWord.text & @CRLF)
Next
$miDoc=0
$stop_time=_NowCalc()
ConsoleWrite("Time taken = " & TimerDiff($start_time) & @CRLF)
$result=StringInStr($str,$searchTxt);see if the word we want is in the string
if ( $result >0) Then
	Return True
Else
	Return False
EndIf	

EndFunc



;------------------------------ Wait for ocr to finish --------------------------------
Func OCREvent_OnOCRProgress($progress,$cancel)
ConsoleWrite("OCR Progress is " & $progress & @CRLF)
if($progress==100) Then
	$finished=True
	EndIf
Endfunc

;------------------------------ This is a COM Error handler --------------------------------
Func MyErrFunc()
  $HexNumber=hex($oMyError.number,8)
  Msgbox(0,"COM Error Test","We intercepted a COM Error !"       & @CRLF  & @CRLF & _
             "err.description is: "    & @TAB & $oMyError.description    & @CRLF & _
             "err.windescription:"     & @TAB & $oMyError.windescription & @CRLF & _
             "err.number is: "         & @TAB & $HexNumber              & @CRLF & _
             "err.lastdllerror is: "   & @TAB & $oMyError.lastdllerror   & @CRLF & _
             "err.scriptline is: "     & @TAB & $oMyError.scriptline     & @CRLF & _
             "err.source is: "         & @TAB & $oMyError.source         & @CRLF & _
             "err.helpfile is: "       & @TAB & $oMyError.helpfile       & @CRLF & _
			"err.helpcontext is: "    & @TAB & $oMyError.helpcontext _
            )
  SetError(1)  ; to check for after this function returns
Endfunc