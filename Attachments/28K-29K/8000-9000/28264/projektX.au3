#include <GuiConstantsEx.au3>
#include <AVIConstants.au3>
#include <TreeViewConstants.au3>
#include <StaticConstants.au3>
#include <ButtonConstants.au3>
#include <Array.au3>
Opt('MustDeclareVars', 1)


Global $out, $pi = 3.14159265358979,  $s=0
global $Main_GUI, $Child_GUI, $p=0, $font="arial"
global $vstup,$x,$msg,$vyst,$gombik,$output
global $button2,$results,$i,$xMin,$yMax
global $yMin,$xMax,$GraphWidth, $GraphHeight
global $graph,$y,$u,$c,$j,$vstup2,$m,$z

$Main_GUI=GuiCreate("Èislicové spracovanie signálov", 800, 600)


GuiCtrlCreateTab(1, 1, 300, 20)
GuiCtrlCreateTabItem("One")
GuiCtrlCreateLabel("Sample Tab with tabItems ", 40, 40)
GuiCtrlCreateLabel("X ^  ", 210, 255)
$vstup=GuiCtrlCreateInput("", 235, 255, 130, 20)
GuiCtrlCreateLabel("=   Y", 400, 255)

$gombik=GuiCtrlCreateButton("RUN", 10, 330, 100, 30)

$output = GUICtrlCreateLabel("", 185, 45, 100, 50, BitOR($BS_PUSHLIKE, $SS_CENTER))
GUICtrlSetFont($output, 24, 800, "", "Comic Sans MS")
 

GuiCtrlCreateTabItem("Two")
GuiCtrlCreateLabel("dejka", 250, 40)
GuiCtrlCreateTabItem("Three")
$button2 = GUICtrlCreateButton("D3", 65, 25, 50, 30)
$vstup2=GuiCtrlCreateInput("", 235, 255, 130, 20)


 GuiSetState(@SW_SHOW, $Main_GUI)

 
While 1
		$msg = GUIGetMsg(1)
		
		Select
		Case $msg[0] = $gombik
			$j=GUICtrlRead($vstup)
			$results =  $j
				
				
				$p=$p+1
				
				dim $iiiL[31]=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]
				
				$Child_GUI=GUICreate($iiiL[$p],500,400,1,1)
				
			
				GUICtrlCreateLabel("tu bude graf<<?",1,1,300,30)
				GUICtrlSetFont(-1, 15, 400, 2, $font)
		
;***********************************************************************
; Prepare Labels for Axes
;***********************************************************************


$yMax = 10                                      ;this is the upper label for y axis
$yMin = -10                                     ;this is the lower label for y axis

$xMax = 10                                      ;this is the upper label for x axis
$xMin = -10      


					;this is the lower label for x axis

GUICtrlCreateLabel($yMax,15,30,20,15)
GUICtrlCreateLabel($yMin,15,340,20,15)

GUICtrlCreateLabel($xMax,350,350,20,15)
GUICtrlCreateLabel($xMin,50,350,30,20)


;***********************************************************************
; Prepare Graphic control and zero lines
;***********************************************************************

$GraphWidth = 280                              ;this is simply the pixel width of the control
$GraphHeight = 280                            ;this is simply the pixel height of the control

$graph = GUICtrlCreateGraphic(60, 50, $GraphWidth, $GraphHeight)
GUICtrlSetBkColor(-1,0xFFFFFF)                  ;graph background colour
GUICtrlSetColor(-1,0x000000)                    ;graph border colour
GUICtrlSetGraphic(-1,$GUI_GR_HINT,0)            ;turn off hints

;---- X - Zero line ----
GUICtrlSetGraphic($graph,$GUI_GR_MOVE,Gen_Abs_Pix_xx(0,$xMin,$xMax,$GraphWidth),Gen_Abs_Pix_yy($yMin,$yMin,$yMax,$GraphHeight))
GUICtrlSetGraphic($graph,$GUI_GR_LINE,Gen_Abs_Pix_xx(0,$xMin,$xMax,$GraphWidth),Gen_Abs_Pix_yy($yMax,$yMin,$yMax,$GraphHeight))
;---- Y - Zero line ----
GUICtrlSetGraphic($graph,$GUI_GR_MOVE,Gen_Abs_Pix_xx($xMin,$xMin,$xMax,$GraphWidth),Gen_Abs_Pix_yy(0,$yMin,$yMax,$GraphHeight))
GUICtrlSetGraphic($graph,$GUI_GR_LINE,Gen_Abs_Pix_xx($xMax,$xMin,$xMax,$GraphWidth),Gen_Abs_Pix_yy(0,$yMin,$yMax,$GraphHeight))


GUICtrlSetGraphic(-1,$GUI_GR_HINT,1)            ;turn on hints



;***********************************************************************
; PLOT POINTS
;***********************************************************************

for $i = $xMin to $xMax step 0.1                  ;change step value for more plot points (e.g. step 0.5)

;---- Move to start pos ----
    if $i = $xMin Then
        GUICtrlSetGraphic($graph,$GUI_GR_MOVE,Gen_Abs_Pix_xx($xMin,$xMin,$xMax,$GraphWidth), Gen_Abs_Pix_yy(0,$yMin,$yMax,$GraphHeight))
    EndIf
;---------------------------

;Stating that X equals each step of the loop means that we can get the control to plot
;points based on the Y = mX + c model.

    $x = $i                                     ;for each step of the loop...
    
    $y = ( $results)^  $x                              ;plot points based on Y = mX + c model. !!!!!CHANGE THIS LINE!!!!!

    GUICtrlSetGraphic($graph,$GUI_GR_LINE,Gen_Abs_Pix_xx($x,$xMin,$xMax,$GraphWidth), Gen_Abs_Pix_yy($y,$yMin,$yMax,$GraphHeight))

next


;***********************************************************************
; Absolute pixel reference generation functions
;***********************************************************************

func Gen_Abs_Pix_xx($x,$low,$high,$width)
    $out = (($width/($high-$low))*(($high-$low)*(($x-$low)/($high-$low))))
    Return $out
EndFunc
func Gen_Abs_Pix_yy($y,$low,$high,$height)
    $out = ($height - (($height/($high-$low))*(($high-$low)*(($y-$low)/($high-$low)))))
    Return $out
EndFunc


				
				GUISetState(@SW_SHOW, $Child_GUI)
				
				Case $msg[0] = $button2
			$j=GUICtrlRead($vstup2)
			
				call("ble")
				
				
				
				Case $msg[0] = $GUI_EVENT_CLOSE
				;Check if user clicked on the close button of the child window
				If $msg[1] = $Child_GUI Then
					
					;Switch to the child window
					GUISwitch($Child_GUI)
					;Destroy the child GUI including the controls
					GUIDelete()								;Check if user clicked on the close button of the parent window
				ElseIf $msg[1] = $main_gui Then
				
					;Switch to the parent window
					GUISwitch($main_gui)
					;Destroy the parent GUI including the controls
					GUIDelete()
					;Exit the script
					Exit
				EndIf
							
			EndSelect
		
		WEnd

		While GuiGetMsg() <> $GUI_EVENT_CLOSE
WEnd


func Gen_Abs_Pix_x($x,$low,$high,$width)
    $out = (($width/($high-$low))*(($high-$low)*(($x-$low)/($high-$low))))
    Return $out
EndFunc
func Gen_Abs_Pix_y($y,$low,$high,$height)
    $out = ($height - (($height/($high-$low))*(($high-$low)*(($y-$low)/($high-$low)))))
    Return $out
EndFunc


