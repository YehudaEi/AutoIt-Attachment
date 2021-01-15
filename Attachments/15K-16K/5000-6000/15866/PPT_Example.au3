;======================================================
; PowerPoint example using PowerPoint wrapper
; Author: Toady (Josh Bolton)
;======================================================

#include "PowerPoint.au3"
#include <misc.au3>

$oMyError = ObjEvent("AutoIt.Error","MyErrFunc")

;=================== Main START =======================

;=========Create an instance of PowerPoint=============
InetGet("http://www.autoitscript.com/forum/style_images/autoit/logo4.gif",@ScriptDir & "\logo4.gif")
while @InetGetActive
	Sleep(10)
WEnd

$objPPT = _PPT_PowerPointApp()
If @error Then 
	MsgBox(0,"","No PowerPoint available")
	Exit
EndIf

$PresInterface = _PPT_CreatePresentation($objPPT) ;Get presentation interface
$objPres = _PPT_PresentationAdd($PresInterface) ;Add a new presentation

;========Add the slides to the presentation============

$objSlide1 = _PPT_SlideCreate($objPres, 1, $PPLAYOUTTEXT) ;Create a new slide with text layout, index = 1
_PPT_SlideTextFrameSetText($objSlide1, 1, "Slide #1 Test")
_PPT_SlideTextFrameSetText($objSlide1, 2, "Each slide will display for 5 seconds")
_PPT_SlideTextFrameSetFont($objSlide1 , 2, "Comic Sans MS") ;set font for textframe number 2

$objSlide2 = _PPT_SlideCreate($objPres, 2, $PPLAYOUTTEXT) ;again, with index = 2
_PPT_SlideTextFrameSetText($objSlide2, 1, "Slide #2 Test")
_PPT_SlideTextFrameSetText($objSlide2, 2, "Isn't this awesome?")

$objSlide3 = _PPT_SlideCreate($objPres, 3, $PPLAYOUTTEXT) ;again, with index = 3
_PPT_SlideTextFrameSetText($objSlide3, 1, "Slide #3 Test") ;Set the title
_PPT_SlideTextFrameSetFontSize($objSlide3, 1, 36) ;set font to size 36
_PPT_SlideAddPicture($objSlide3,@ScriptDir & "\logo4.gif", 10, 10, 10, 10) ;add a picture to slide

$objSlide4 = _PPT_SlideCreate($objPres, 4, $PPLAYOUTBLANK)
_PPT_SlideAddTable($objSlide4,4,4) ;add a table 4 rows, 4 cols

$objSlide5 = _PPT_SlideCreate($objPres, 5, $PPLAYOUTBLANK)
_PPT_SlideAddTextBox($objSlide5, 100, 100, 400, 100) ;add a plain textbox
_PPT_SlideTextFrameSetText($objSlide5, 1, "A simple textbox") ;add text to textbox
_PPT_SlideTextFrameSetFontSize($objSlide5, 1, 48) ;set font to size 48

;========Configure the presentation settings===========

_PPT_bAssistant($objPPT, 0) ;Ensure that Office assistant is turned off
_PPT_SlideShowStartingSlide($objPres, 1) ;starting slide = starting from 1
_PPT_SlideShowEndingSlide($objPres, _PPT_SlideCount($objPres)) ;ending slide = slide count
_PPT_SlideShowRangeType($objPres, $PPRANGETYPESHOWBYRANGE) ;use the starting and ending slides 
_PPT_SlideShowLoopUntilStopped($objPres, 1) ;keep replaying presentation
_PPT_SlideShowAdvanceOnTime($objPres, 1) ;auto advance slides
_PPT_SlideShowAdvanceTime($objPres, 5) ;display each frame for 5 seconds
_PPT_SlideShowAdvanceMode($objPres, $PPUSETIMINGS) ;use the slide transition times
_PPT_SlideShowRun($objPres) ;start the slide show

Sleep(25000) ;wait until slide show is complete (5 seconds x 5 slides = 25 seconds)

;==========Save presentation and exit==================

_PPT_PresentationSaveAs($objPres, @ScriptDir & "\MyAutoItPresentation.ppt")
_PPT_PresentationClose($objPres) ; Close presentation
_PPT_PowerPointQuit($objPPT) ;Exit PowerPoint

;======================================================
;==================== MAIN END ========================
;======================================================

;=======================Functions======================
Func MyErrFunc()
  $HexNumber=hex($oMyError.number,8)
  Msgbox(0,"COM Test","We intercepted a COM Error !"       & @CRLF  & @CRLF & _
             "err.description is: "    & @TAB & $oMyError.description    & @CRLF & _
             "err.windescription:"     & @TAB & $oMyError.windescription & @CRLF & _
             "err.number is: "         & @TAB & $HexNumber              & @CRLF & _
             "err.lastdllerror is: "   & @TAB & $oMyError.lastdllerror   & @CRLF & _
             "err.scriptline is: "     & @TAB & $oMyError.scriptline     & @CRLF & _
             "err.source is: "         & @TAB & $oMyError.source         & @CRLF & _
             "err.helpfile is: "       & @TAB & $oMyError.helpfile       & @CRLF & _
             "err.helpcontext is: "    & @TAB & $oMyError.helpcontext _
            )
  SetError(1) 
Endfunc