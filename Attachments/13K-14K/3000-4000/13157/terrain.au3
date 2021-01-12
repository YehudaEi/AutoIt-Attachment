#include <GUIConstants.au3>
#include <Array.au3>

Opt("GUIOnEventMode", 1)

#Region ### START Koda GUI section ### Form=terrain.kxf
$Form1 = GUICreate("Fractal terrain generator example", 513, 433, 254, 404)
$Label2 = GUICtrlCreateLabel("Height scale:", 0, 0, 66, 17)
$Label3 = GUICtrlCreateLabel("Roughness:", 88, 0, 61, 17)
$Input2 = GUICtrlCreateInput("384", 0, 16, 81, 21)
$Input3 = GUICtrlCreateInput("0.4", 88, 16, 81, 21)
$Button1 = GUICtrlCreateButton("Generate!", 176, 16, 75, 21, 0)
GUICtrlSetOnEvent(-1, "Generate")
$Graphic1 = GUICtrlCreateGraphic(0, 48, 512, 384)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

GUISetOnEvent($GUI_EVENT_CLOSE,"Bye")

Global const $size = 2^9+1 ;must be (power of 2)+1
Global $w[$size]

Func Generate()
	DisplaceMidpoints($w,$size,GUICtrlRead($Input2),GUICtrlRead($Input3))
	ClearDrawing()
	DrawStars(30)
	DrawSky()
	DrawGround()
EndFunc

Func MyRandom($v) 
	Return Random(-$v,$v)
EndFunc

Func EndpointsAverage($i,$stride,ByRef $fa)
	Return ($fa[$i-$stride] + $fa[$i+$stride]) * 0.5
EndFunc

Func DisplaceMidpoints (ByRef $fa, $size, $heightScale,$h)
    Local	$i
    Local 	$stride
    Local 	$subSize
	Local 	$ratio
	Local 	$scale

    $subSize = $size-1;
    $size +=1;
    
	SRandom(TimerInit())

	$ratio = 2^(-$h)
	$scale = $heightScale * $ratio
    $stride = $subSize / 2;
	$fa[0]		=	Random(0,GUICtrlRead($Input2))
	$fa[$subSize]	=	Random(0,GUICtrlRead($Input2))	

    while ($stride)
		for $i = $stride to $subSize Step $stride
			$fa[$i] = $scale * MyRandom(0.5) + EndpointsAverage($i, $stride, $fa)
			$scale = $scale * $ratio
			$i = $i + $stride
		Next
		$stride = BitShift ($stride,1)
    WEnd
EndFunc

Func ClearDrawing()
	Global $Graphic1
	GUICtrlDelete($Graphic1)
	$Graphic1 = GUICtrlCreateGraphic(0, 48, 512, 384)
EndFunc

Func DrawSky()
	GUICtrlSetBkColor($Graphic1,0x003364)
EndFunc

Func DrawStars($count)
	Local $small
	$big = Random(0,$count,1) ;number of bigger stars
	for $i=0 to $count
		$x = Random(0,512)
		$y = Random(0,384)
		GUICtrlSetGraphic($Graphic1,$GUI_GR_COLOR, 0xFFFFF0)
		GUICtrlSetGraphic($Graphic1,$GUI_GR_PIXEL,$x,$y)
		if $big>1 Then
			GUICtrlSetGraphic($Graphic1,$GUI_GR_COLOR, 0xFFFFC3)
			GUICtrlSetGraphic($Graphic1,$GUI_GR_PIXEL,$x-1,$y)
			GUICtrlSetGraphic($Graphic1,$GUI_GR_PIXEL,$x+1,$y)
			GUICtrlSetGraphic($Graphic1,$GUI_GR_PIXEL,$x,$y-1)
			GUICtrlSetGraphic($Graphic1,$GUI_GR_PIXEL,$x,$y+1)
			$big -=1
		EndIf
		
	
	Next
	GUICtrlSetGraphic($Graphic1,$GUI_GR_REFRESH)
EndFunc

Func DrawGround()
	GUICtrlSetGraphic($Graphic1,$GUI_GR_COLOR, 0x000000,0x006400)
	GUICtrlSetGraphic($Graphic1,$GUI_GR_MOVE, 0,$w[0])
	for $x = 0 to $size-1
		if $w[$x]<0 Then
			$w[$x]=0
		ElseIf $w[$x]>384 Then
			$w[$x]=384
		EndIf
		$res = GUICtrlSetGraphic($Graphic1,$GUI_GR_LINE,$x,$w[$x])
	Next
	GUICtrlSetGraphic($Graphic1,$GUI_GR_LINE,512,384)
	GUICtrlSetGraphic($Graphic1,$GUI_GR_LINE,0,384)
	GUICtrlSetGraphic($Graphic1,$GUI_GR_LINE,0,$w[0])
	GUICtrlSetGraphic($Graphic1,$GUI_GR_REFRESH)
	GUISetState()
EndFunc

Func Bye()
	Exit
EndFunc

Generate()

While 1
	Sleep(100)
WEnd
