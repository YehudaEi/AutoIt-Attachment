#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=..\..\Documents and Settings\Philip\Desktop\Podz.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <misc.au3>
$xcor = 300
$ycor = 200


Func podz()
sleep(100)
while $ycor < 593
	If _IsPressed("45") Then ExitLoop
 While $xcor < 727
    MouseMove( $xcor, $ycor,0)

            If PixelGetColor($xcor,$ycor) = 10870552  Then  MouseClick("left")

	$xcor += 2

  WEnd

$ycor+=3
mousemove(0, $ycor,0)
$xcor = 0

WEnd
EndFunc

While 1
   if _IsPressed("53") then
   $xcor = 259
   $ycor = 200
   podz()
   EndIf
   if _IsPressed("54") Then
	exit
   EndIf
WEnd
