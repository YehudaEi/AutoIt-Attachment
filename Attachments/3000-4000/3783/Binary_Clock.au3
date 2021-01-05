;BinaryClock
#include <GUIConstants.au3>
#include <Date.au3>

HotKeySet("{ESC}", "_Terminate")
Func _Terminate()
	Exit
EndFunc


Dim $hOne, $hTwo, $hThree, $hFour, $mOne, $mTwo, $mThree, $mFour, $mFive, $mSix

$Clock = GUICreate("BinaryClock    <Escape> to Exit", 210, 105, -1, -1, $WS_BORDER)
GUISetState()

while 1
	_GetTime()
	sleep(10000)
WEnd


Func _GetTime()
	$Time = StringSplit(_NowTime(), ":")
	$Hour = $Time[1]
	$Min = $Time[2]
	if $Hour >= 8 then
		$hOne = 1
		$Hour = $Hour - 8
	Else
		$hOne = 0
	EndIf
	if $Hour >= 4 Then
		$hTwo = 1
		$Hour = $Hour - 4
	Else
		$hTwo = 0
	EndIf
	if $Hour >= 2 Then
		$hThree = 1
		$Hour = $Hour - 2
	Else
		$hThree = 0
	EndIf
	if $Hour >= 1 Then
		$hFour = 1
		$Hour = $Hour - 1
	Else
		$hFour = 0
	EndIf
	if $Min >= 32 Then
		$mOne = 1
		$Min = $Min - 32
	Else
		$mOne = 0
	EndIf
	if $Min >= 16 Then
		$mTwo = 1
		$Min = $Min - 16
	Else
		$mTwo = 0
	EndIf
	if $Min >= 8 Then
		$mThree = 1
		$Min = $Min - 8
	Else
		$mThree = 0
	EndIf
	if $Min >= 4 Then
		$mFour = 1
		$Min = $Min - 4
	Else
		$mFour = 0
	EndIf
	if $Min >= 2 Then
		$mFive = 1
		$Min = $Min - 2
	Else
		$mFive = 0
	EndIf
	if $Min >= 1 Then
		$mSix = 1
		$Min = $Min - 1
	Else
		$mSix = 0
	EndIf
	_SetHour()
	_SetMinute()
EndFunc

Func _SetHour();$hOne, $hTwo, $hThree, $hFour)
If $hOne = 1 then ;Set as Red Dot
	$Hour1 = GUICtrlCreateGraphic(20, 10, 20, 20)
	GUICtrlSetGraphic($Hour1, $GUI_GR_COLOR, 0xff0000, 0xff0000) ;specifies a Red Dot filled with Red fill
	GUICtrlSetGraphic($Hour1, $GUI_GR_ELLIPSE, 20, 10, 15, 15) ;Specifies the X, Y, and size of dot
EndIf
if $hOne = 0 Then ;Set as a black circle
	$Hour1 = GUICtrlCreateGraphic(20, 10, 20, 20)
	GUICtrlSetGraphic($Hour1, $GUI_GR_COLOR, 0x000000, 0xD4D0C8) ;specifies a Red Dot filled with Red fill
	GUICtrlSetGraphic($Hour1, $GUI_GR_ELLIPSE, 20, 10, 15, 15) ;Specifies the X, Y, and size of dot
EndIf
if $hTwo = 1 then
	$Hour2 = GUICtrlCreateGraphic(38, 10, 20, 20)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0xff0000, 0xff0000) ;specifies a Red Dot filled with Red fill
	GUICtrlSetGraphic(-1, $GUI_GR_ELLIPSE, 38, 10, 15, 15) ;Specifies the X, Y, and size of dot
EndIf
if $hTwo = 0 then 
	$Hour2 = GUICtrlCreateGraphic(38, 10, 20, 20)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x000000, 0xD4D0C8) ;specifies a Red Dot filled with Red fill
	GUICtrlSetGraphic(-1, $GUI_GR_ELLIPSE, 38, 10, 15, 15) ;Specifies the X, Y, and size of dot
EndIf
if $hThree = 1 then 
	$Hour3 = GUICtrlCreateGraphic(58, 10, 20, 20)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0xff0000, 0xff0000) ;specifies a Red Dot filled with Red fill
	GUICtrlSetGraphic(-1, $GUI_GR_ELLIPSE, 58, 10, 15, 15) ;Specifies the X, Y, and size of dot
endif 
if $hThree = 0 Then
	$Hour3 = GUICtrlCreateGraphic(58, 10, 20, 20)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x000000, 0xD4D0C8) ;specifies a Red Dot filled with Red fill
	GUICtrlSetGraphic(-1, $GUI_GR_ELLIPSE, 58, 10, 15, 15) ;Specifies the X, Y, and size of dot
EndIf
	
if $hFour = 1 Then
	$Hour4 = GUICtrlCreateGraphic(75, 10, 20, 20)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0xff0000, 0xff0000) ;specifies a Red Dot filled with Red fill
	GUICtrlSetGraphic(-1, $GUI_GR_ELLIPSE, 75, 10, 15, 15) ;Specifies the X, Y, and size of dot
EndIf
if $hFour = 0 Then
	$Hour4 = GUICtrlCreateGraphic(75, 10, 20, 20)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x000000, 0xD4D0C8) ;specifies a Red Dot filled with Red fill
	GUICtrlSetGraphic(-1, $GUI_GR_ELLIPSE, 75, 10, 15, 15) ;Specifies the X, Y, and size of dot
EndIf
	guictrlsetgraphic($Hour1, $GUI_GR_REFRESH)	
	guictrlsetgraphic($Hour2, $GUI_GR_REFRESH)	
	guictrlsetgraphic($Hour3, $GUI_GR_REFRESH)	
	guictrlsetgraphic($Hour4, $GUI_GR_REFRESH)	
EndFunc

Func _SetMinute();$mOne, $mTwo, $mThree, $mFour, $mFive, $mSix)
if $mOne = 1 Then
	$minute1 = GUICtrlCreateGraphic(10, 25, 20, 20)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0xff0000, 0xff0000) ;specifies a Red Dot filled with Red fill
	GUICtrlSetGraphic(-1, $GUI_GR_ELLIPSE, 10, 25, 15, 15) ;Specifies the X, Y, and size of dot	
EndIf
if $mOne = 0 Then
	$minute1 = GUICtrlCreateGraphic(10, 25, 20, 20)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x000000, 0xD4D0C8) ;specifies a Red Dot filled with Red fill
	GUICtrlSetGraphic(-1, $GUI_GR_ELLIPSE, 10, 25, 15, 15) ;Specifies the X, Y, and size of dot
EndIf
if $mTwo = 1 Then
	$minute2 = GUICtrlCreateGraphic(25, 25, 20, 20)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0xff0000, 0xff0000) ;specifies a Red Dot filled with Red fill
	GUICtrlSetGraphic(-1, $GUI_GR_ELLIPSE, 25, 25, 15, 15) ;Specifies the X, Y, and size of dot	
EndIf
if $mTwo = 0 Then
	$minute2 = GUICtrlCreateGraphic(25, 25, 20, 20)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x000000, 0xD4D0C8) ;specifies a Red Dot filled with Red fill
	GUICtrlSetGraphic(-1, $GUI_GR_ELLIPSE, 25, 25, 15, 15) ;Specifies the X, Y, and size of dot
EndIf
if $mThree = 1 Then
	$minute3 = GUICtrlCreateGraphic(40, 25, 20, 20)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0xff0000, 0xff0000) ;specifies a Red Dot filled with Red fill
	GUICtrlSetGraphic(-1, $GUI_GR_ELLIPSE, 40, 25, 15, 15) ;Specifies the X, Y, and size of dot	
EndIf
if $mThree = 0 Then
	$minute3 = GUICtrlCreateGraphic(40, 25, 20, 20)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x000000, 0xD4D0C8) ;specifies a Red Dot filled with Red fill
	GUICtrlSetGraphic(-1, $GUI_GR_ELLIPSE, 40, 25, 15, 15) ;Specifies the X, Y, and size of dot
EndIf
if $mFour = 1 Then
	$minute4 = GUICtrlCreateGraphic(55, 25, 20, 20)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0xff0000, 0xff0000) ;specifies a Red Dot filled with Red fill
	GUICtrlSetGraphic(-1, $GUI_GR_ELLIPSE, 55, 25, 15, 15) ;Specifies the X, Y, and size of dot	
EndIf
if $mFour = 0 Then
	$minute4 = GUICtrlCreateGraphic(55, 25, 20, 20)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x000000, 0xD4D0C8) ;specifies a Red Dot filled with Red fill
	GUICtrlSetGraphic(-1, $GUI_GR_ELLIPSE, 55, 25, 15, 15) ;Specifies the X, Y, and size of dot
EndIf
if $mFive = 1 Then
	$minute5 = GUICtrlCreateGraphic(70, 25, 20, 20)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0xff0000, 0xff0000) ;specifies a Red Dot filled with Red fill
	GUICtrlSetGraphic(-1, $GUI_GR_ELLIPSE, 70, 25, 15, 15) ;Specifies the X, Y, and size of dot	
EndIf
if $mFive = 0 Then
	$minute5 = GUICtrlCreateGraphic(70, 25, 20, 20)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x000000, 0xD4D0C8) ;specifies a Red Dot filled with Red fill
	GUICtrlSetGraphic(-1, $GUI_GR_ELLIPSE, 70, 25, 15, 15) ;Specifies the X, Y, and size of dot
EndIf
if $mSix = 1 Then
	$minute6 = GUICtrlCreateGraphic(85, 25, 20, 20)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0xff0000, 0xff0000) ;specifies a Red Dot filled with Red fill
	GUICtrlSetGraphic(-1, $GUI_GR_ELLIPSE, 85, 25, 15, 15) ;Specifies the X, Y, and size of dot	
EndIf
if $mSix = 0 Then
	$minute6 = GUICtrlCreateGraphic(85, 25, 20, 20)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x000000, 0xD4D0C8) ;specifies a Red Dot filled with Red fill
	GUICtrlSetGraphic(-1, $GUI_GR_ELLIPSE, 85, 25, 15, 15) ;Specifies the X, Y, and size of dot
EndIf
guictrlsetgraphic($minute1, $GUI_GR_REFRESH)	
guictrlsetgraphic($minute2, $GUI_GR_REFRESH)	
guictrlsetgraphic($minute3, $GUI_GR_REFRESH)	
guictrlsetgraphic($minute4, $GUI_GR_REFRESH)	
guictrlsetgraphic($minute5, $GUI_GR_REFRESH)	
guictrlsetgraphic($minute6, $GUI_GR_REFRESH)	
EndFunc





