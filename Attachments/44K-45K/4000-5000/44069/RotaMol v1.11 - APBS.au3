  ; #INDEX# ===============================================================================================
; Title .........: RotaMol v1.11 - APBS
; AutoIt Version : 3.2.10++
; Language ......: English
; Description ...: Estimating the Cross Sectional Areas of proteins and quantification of protein Asymetry
; Author(s) .....: Sebastian Eves-van den Akker (University of Leeds) rotamol@gmail.com
; =========================================================================================================
; thanks to "Valuater" for icon button


Global $Paused
Global $test
HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{ESC}", "Terminate")

#Include <Misc.au3>
#include <GUIConstantsEx.au3>
#include <SliderConstants.au3>
#include <Array.au3>
#include <ButtonConstants.au3>
#Include <GuiToolTip.au3>
#include <WindowsConstants.au3>

_DwmEnable(False)

$xta = 0
$yta =0
$xt =0
$yt =0
$xb =0
$yb =0

$pymol_name = "The PyMOL Molecular Graphics System"
$version = "RotaMol - v1.11"
;=====================Creates the Graphical User Interface of the Program=================================
$label_color = 0xFFFAF0

global $text_color = 0x808080
$gui = GUICreate($version, 240,500,@DesktopWidth -245,0) 
GUISetOnEvent($GUI_EVENT_CLOSE, "Terminate")

$progressbar1 = GUICtrlCreateProgress(10, 2, 180, 20)
$timer = GUICtrlCreatelabel("Timer",200, 4, 40, 20)
$group1 = GUICtrlCreateGroup ("Step 1: Define variables",10,25,220,270)

$pixelskip_group = GUICtrlCreateGroup ( "Pixel Skip", 15, 50, 210,60) ;0
$slider1 = GUICtrlCreateSlider(20, 65, 200, 20,$TBS_TOP) ;+15
$button = GUICtrlCreateInput("Pixelskip",164, 85, 50, 20,0x2000) ;+35

$angle_group = GUICtrlCreateGroup ( "Angle of rotation", 15, 120, 210,60)
$slider2 = 	GUICtrlCreateSlider(20, 135, 200, 20,$TBS_TOP)
$button4 = GUICtrlCreateInput("Angle",164, 155, 50, 20,0x2000)

$zoom_group = GUICtrlCreateGroup ( "Manual Zoom", 15, 190, 210,65)
$slider3 = GUICtrlCreateSlider(20, 205, 200, 20,$TBS_TOP)
$inputslider3 = GUICtrlCreateInput("Zoom",164, 225, 50, 20,0x2000)
$check_zoom = GUICtrlCreateCheckbox("",20,230,15,15)
$apply_zoom = guictrlcreatebutton("Apply", 40,230,40,20)
$load_surface = guictrlcreatebutton("Load surface", 150,265,70,20)
GUICtrlSetLimit ($slider2, 180 , 1)
GUICtrlSetLimit($slider1, 100, 1) 
GUICtrlSetLimit($slider3, 200, 1) 

$test = guictrlcreatelabel ("",150,32,78,1);top right
guictrlsetbkcolor($test,$label_color)
$test = guictrlcreatelabel ("",228,32,1,262);right
guictrlsetbkcolor($test,$label_color)
$test = guictrlcreatelabel ("",10,293,218,1);bottom
guictrlsetbkcolor($test,$label_color)
$test = guictrlcreatelabel ("",10,32,1,262);left
guictrlsetbkcolor($test,$label_color)
$test = guictrlcreatelabel ("",10,32,6,1);top right
guictrlsetbkcolor($test,$label_color)
$help1 = IconButton("", 200, 39, 26, 10, 24)
$help2 = IconButton("", 200, 300, 26, 10, 24)

$tab = Guictrlcreatetab (6,300,228,190)

$tab0 = GUICtrlCreateTabItem("Area Measurement")
	$test = guictrlcreatelabel ("",228,330,1,150);right
guictrlsetbkcolor($test,$label_color)
$test = guictrlcreatelabel ("",150,329,79,1);top right
guictrlsetbkcolor($test,$label_color)
$test = guictrlcreatelabel ("",10,480,218,1);bottom
guictrlsetbkcolor($test,$label_color)
$test = guictrlcreatelabel ("",10,330,1,150);left
guictrlsetbkcolor($test,$label_color)
$test = guictrlcreatelabel ("",10,329,7,1);top right
guictrlsetbkcolor($test,$label_color)
	$group2 =GUICtrlCreateGroup ("Step 2: Measure protein",10,322,220,160)
;guictrlsetbkcolor($group2,0x0000ff)

$next = GUICtrlCreateButton("Count Pixels",20, 345, 70, 20)
$avg_group = GUICtrlCreateGroup ( "Average area (CCS [" & chr(197) &"] )", 95, 430, 130,40)
$n3 = GUICtrlCreateInput("Final Result",100, 445, 120, 20)
$max_group = GUICtrlCreateGroup ( "Max area", 125, 380, 100,40)
$menu8 = GUICtrlCreateInput("Max", 130, 395, 80,20)
$min_group = GUICtrlCreateGroup ( "Min area", 15, 380, 100,40)
$menu7 = GUICtrlCreateInput("Min",20, 395, 80,20)
$asym_group = GUICtrlCreateGroup ( "Asymmetry", 15, 430, 70,40)
$menu11 = GUICtrlCreateInput("0",  20, 445, 50,20)

	$tab1 = GUICtrlCreateTabItem("Electrostatics")
	
	$testx = guictrlcreatelabel ("",228,330,1,150);right
guictrlsetbkcolor($testx,$label_color)
$testx = guictrlcreatelabel ("",150,329,79,1);top right
guictrlsetbkcolor($testx,$label_color)
$testx = guictrlcreatelabel ("",10,480,218,1);bottom
guictrlsetbkcolor($testx,$label_color)
$testx = guictrlcreatelabel ("",10,330,1,150);left
guictrlsetbkcolor($testx,$label_color)
$testx = guictrlcreatelabel ("",10,329,7,1);top right
guictrlsetbkcolor($testx,$label_color)
	$group2x =GUICtrlCreateGroup ("Step 2: Measure protein",10,322,220,160)
$electroxxp = GUICtrlCreateButton("Count Electrostatics",20, 345, 100, 20)
$avg_groupx = GUICtrlCreateGroup ( "Combined Average", 125, 430, 100,40)
$n3x = GUICtrlCreateInput("Final Result",130, 445, 80, 20)
$max_groupx = GUICtrlCreateGroup ( "Negative area", 125, 380, 100,40)
$menu8x = GUICtrlCreateInput("-", 130, 395, 85,20)
$min_groupx = GUICtrlCreateGroup ( "Positive area", 15, 380, 100,40)
$menu7x = GUICtrlCreateInput("+",20, 395, 85,20)
$asym_groupx = GUICtrlCreateGroup ( "Charge Asymmetry", 15, 430, 100,40)
$menu11x = GUICtrlCreateInput("0",  20, 445, 80,20)


guictrlsetfont ($group1, 9,500,4)
guictrlsetfont ($group2, 9,500,4)
guictrlsetfont ($group2x, 9,500,4)

global $text_color = 0x808080

guictrlsetcolor($pixelskip_group,$text_color) 
guictrlsetcolor($angle_group,$text_color)
guictrlsetcolor($zoom_group,$text_color)

guictrlsetcolor($avg_group,$text_color)
guictrlsetcolor($max_group,$text_color)
guictrlsetcolor($min_group,$text_color)
guictrlsetcolor($asym_group,$text_color)

GUICtrlSetData($slider1, 20)
GUICtrlSetData($slider2, 30)
GUICtrlSetData($button4, 30)
GUICtrlSetData($button, 20)
GUICtrlSetData($slider3, 30)
GUICtrlSetData($inputslider3, 30)

$oldvalue3 = 30
$oldvalue2 = 30
$oldvalue1 = 20

$oldinput1 = 20
$oldinput2 = 30
$oldinput3 = 30

$background_input_color = 0xFFFAF0
guictrlsetbkcolor($progressbar1, $background_input_color)
guictrlsetbkcolor($button4, $background_input_color)
guictrlsetbkcolor($button, $background_input_color)
guictrlsetbkcolor($menu7, $background_input_color)
guictrlsetbkcolor($menu8, $background_input_color)
guictrlsetbkcolor($menu11, $background_input_color)
guictrlsetbkcolor($n3, $background_input_color)

;=============================================================================================================
 GUISetState()
 ;check only 1 copy exists.
 if _singleton($version,1) = 0 then 
 MsgBox(0, $version, "Running 2 copies of RotaMol is not supported")
Exit
EndIf

;----- check for multiple coppies of PyMol------
 $list = ProcessList("PymolWin.exe")
if $list[0][0] >1 then 
	;have multiple coppies open. 
	msgbox(0, "Multiple coppies of Pymol running", "You have Multiple coppies of Pymol running, Everything should be fine but If possible It's best to just run one")
EndIf


;=============================================================================================================
winactivate ($pymol_name)
;winactivate ($version)

;========================Defines area to scan, and time to input user defined values==========================
global $winpos_pymolviewer = wingetpos("PyMOL Viewer")
global $winpos_molecular_graphics_system = wingetpos($pymol_name)
if not @error then 
	if $winpos_molecular_graphics_system[1] <3 then  
	WinMove ( "PyMOL Viewer", "", $winpos_pymolviewer[0],$winpos_pymolviewer[1]+20,@desktopheight-$winpos_pymolviewer[1]-60 + 350,@desktopheight-$winpos_pymolviewer[1]-60)
	WinMove ( $pymol_name, "", $winpos_molecular_graphics_system[0],$winpos_molecular_graphics_system[1]+10)
		global $winpos_pymolviewer = wingetpos("PyMOL Viewer")
		global $winpos_molecular_graphics_system = wingetpos($pymol_name)
	endif
endif

global $win = winactivate ("PyMOL Viewer") 

idle()


func idle()
	Tooltip("If at any time you wish to end Press ESC or Press PAUSE-BREAK to pause",0,0,"Zoom out so model fits in the viewer and load relevant surface, Click Count Pixels to start")	
	$enable_once = 0
	$disable_once = 0
	
	GuiCtrlSetState ($button, $GUI_enable)
	GuiCtrlSetState ($button4, $GUI_enable)
	GuiCtrlSetState ($slider1, $GUI_enable)
	GuiCtrlSetState ($slider2, $GUI_enable)
	GuiCtrlSetState ($next, $GUI_enable)
	
	Do
		
		if guictrlread($check_zoom) = $GUI_CHECKED then 
			if $enable_once = 0 then
			guiCtrlSetState ($slider3, $GUI_enable)
			GuiCtrlSetState ($apply_zoom, $GUI_enable)
			GuiCtrlSetState ($inputslider3, $GUI_enable)
			$readzoom2 = guictrlread($slider3)
				ControlSend("PyMOL Viewer", "", "","zoom center, "& $readzoom2 & "{enter}")
			$disable_once = 0
			endif
			$enable_once = 1
		endif	
		
		if guictrlread($check_zoom) = $GUI_unCHECKED then 
			if $disable_once = 0 then
			guiCtrlSetState ($slider3, $GUI_disable)
			GuiCtrlSetState ($apply_zoom, $GUI_disable)
			GuiCtrlSetState ($inputslider3, $GUI_disable)
			$enable_once = 0
			endif
			$disable_once = 1
		endif	
		
		
		
		$msg = GUIGetMsg()
	
	   ; Help Buttons
	   If $msg = $help1 Then MsgBox(0,"Step 1 Help", "Pixelskip = Level of accuracy. (A pixelskip of 20 will check one in every 20 pixels) " & @CRLF & @CRLF & "Angle of rotation = Number of times the protein is rotated across each 360 degree axis. (40 degrees will measure 8 sides of a protein in X for 8 times in Y)" & @CRLF & @CRLF & "Manual Zoom will only be active if the box is checked. Zoom out with the slider and then rotate the protein untill it fits well within the window. Manual Zoom will skip the calibration step as it is not needed.")
		If $msg = $help2 Then MsgBox(0,"Step 2 Help", "Pressing the 'Count Pixels' button will start the program and disable step 1" & @CRLF & @CRLF & "Average area = Collision Cross Section"& @CRLF & @CRLF & "Min area = Smallest Cross section observed for the given angle of rotation"& @CRLF & @CRLF & "Max area = Largest Cross section observed for the given angle of roation" & @CRLF & @CRLF & "Asymmetry index = a measure of the asymmetry of the protein (min/max)"& @CRLF & @CRLF & @CRLF & @CRLF & "Eletrostatic calculations should only be used with the APBS plugin - see help file for more details."			)
		

$sliderread = GUICtrlRead($slider1, 1)
If $sliderread <> $oldvalue1 then
    GuiCtrlSetData($button,$sliderread)
    $oldvalue1 = $sliderread
EndIf

$sliderread2 = GUICtrlRead($slider2, 1)
If $sliderread2 <> $oldvalue2 then
    GuiCtrlSetData($button4,$sliderread2)
    $oldvalue2 = $sliderread2
EndIf

$input_pixelread = guictrlread ($button,1)
if $input_pixelread  <> $oldinput1 then 
	GuiCtrlSetData($slider1,$input_pixelread)
    $oldinput1 = $input_pixelread
EndIf


$input_angleread = guictrlread ($button4,1)
if $input_angleread  <> $oldinput2 then 
	GuiCtrlSetData($slider2,$input_angleread)
    $oldinput2 = $input_angleread
EndIf

$sliderread3 = GUICtrlRead($slider3, 1)
If $sliderread3 <> $oldvalue3 then
    GuiCtrlSetData($inputslider3,$sliderread3)
    $oldvalue3 = $sliderread3
EndIf

$input_zoomread = guictrlread ($inputslider3,1)
if $input_zoomread  <> $oldinput3 then 
	GuiCtrlSetData($slider3,$input_zoomread)
    $oldinput3 = $input_zoomread
	if guictrlread($check_zoom) = $gui_checked then	ControlSend("PyMOL Viewer", "", "","zoom center, "& $input_zoomread & "{enter}")
EndIf

if $msg = $apply_zoom then ControlSend("PyMOL Viewer", "", "","zoom center, "& $input_zoomread & "{enter}")

		if $win = 0 and $msg = $next then
		if winactivate ("PyMOL Viewer") = 0 then 
		msgbox (0,"Error", "Please open the molecule you want in PyMOL")
		$endf = 0
		endif
	endif
	
if $msg = $load_surface then 
	
		if winactivate ("PyMOL Viewer") = not 0 then 
	blockinput(1)
		winactivate ("PyMOL Viewer")
		ControlSend("PyMOL Viewer", "", "","show surface" & "{enter}")
		sleep(200)
		ControlSend("PyMOL Viewer", "", "","set solvent")
		sleep(100)
		Send("{_}")
		sleep(100)
		ControlSend("PyMOL Viewer", "", "","radius, 1.4" & "{enter}")
		sleep(200)
		ControlSend("PyMOL Viewer", "", "","set surface")
		sleep(100)
		Send("{_}")
		sleep(100)
		ControlSend("PyMOL Viewer", "", "","solvent, on" & "{enter}")
		sleep(200)
		ControlSend("PyMOL Viewer", "", "","set specular, off" & " {enter}")
		sleep(200)
		ControlSend("PyMOL Viewer", "", "","set surface")
		sleep(200)
		Send("{_}")
		sleep(200)
		ControlSend("PyMOL Viewer", "", "","quality, 0" & " {enter}")
		sleep(200)
		winactivate ("PyMOL Viewer")
	blockinput(0)
		else
msgbox (0,"Error", "Please open the molecule you want in PyMOL")

endif

EndIf

	if $msg = $GUI_EVENT_CLOSE Then Terminate()
	global $electrozy = 0
	if $msg = $electroxxp then 
		global $electrozy = 1
		$winpos_pymolviewer = wingetpos("PyMOL Viewer")
$winpos_molecular_graphics_system = wingetpos($pymol_name)

global $winpos_molecular_graphics_system = wingetpos($pymol_name)
if not @error then 
if $winpos_molecular_graphics_system[1] <3 then
	WinMove ( "PyMOL Viewer", "", $winpos_pymolviewer[0],$winpos_pymolviewer[1]+20,@desktopheight-$winpos_pymolviewer[1]-60 + 350,@desktopheight-$winpos_pymolviewer[1]-60)
	WinMove ( $pymol_name, "", $winpos_molecular_graphics_system[0],$winpos_molecular_graphics_system[1]+10)
global $winpos_pymolviewer = wingetpos("PyMOL Viewer")
global $winpos_molecular_graphics_system = wingetpos($pymol_name)
EndIf
EndIf
		define_area_to_scan()
		EndIf
	
until $msg = $next and winactivate ("PyMOL Viewer") = not 0

$winpos_pymolviewer = wingetpos("PyMOL Viewer")
$winpos_molecular_graphics_system = wingetpos($pymol_name)

global $winpos_molecular_graphics_system = wingetpos($pymol_name)
if not @error then 
if $winpos_molecular_graphics_system[1] <3 then
	WinMove ( "PyMOL Viewer", "", $winpos_pymolviewer[0],$winpos_pymolviewer[1]+20,@desktopheight-$winpos_pymolviewer[1]-60 + 350,@desktopheight-$winpos_pymolviewer[1]-60)
	WinMove ( $pymol_name, "", $winpos_molecular_graphics_system[0],$winpos_molecular_graphics_system[1]+10)
global $winpos_pymolviewer = wingetpos("PyMOL Viewer")
global $winpos_molecular_graphics_system = wingetpos($pymol_name)
EndIf
endif
define_area_to_scan()
EndFunc


func define_area_to_scan()
		ControlSend("PyMOL Viewer", "", "","wizard appearance" & "{enter}")
		sleep(100)
tooltip("If at any time you wish to end Press ESC or Press PAUSE-BREAK to pause",0,0,"Defining area to scan . . .")

blockinput(1)
$win = winactivate ("PyMOL Viewer") 

winactivate ($pymol_name)
global $winsize_pymolviewer = WinGetClientSize("PyMOL Viewer")

global $xt = $winpos_pymolviewer[0]+ 10
global $yts = $winpos_pymolviewer[1] + 30

global $xb = $winpos_pymolviewer[0]+$winsize_pymolviewer[0]-250
global $ybs = $winpos_pymolviewer[1]+$winsize_pymolviewer[1]-10
$search_smallest_box_top = pixelsearch ($xt,$yts,$xb,$ybs,0xb23535,150)

global $yt = $search_smallest_box_top[1]-10

$search_smallest_box_bottom = pixelsearch ($xb,$ybs,$xt,$yt,0xb23535,150)
global $yb = $search_smallest_box_bottom[1]+10


sleep(200)
blockinput(0)

global $xta = $xt
global $yta = $yt

if $electrozy = 1 then 
	count_electro()
EndIf

count_pixels()
endfunc


func count_pixels()
	
	global $background = pixelgetcolor($xt,$yta)

	if guictrlread ($check_zoom) = $gui_checked then
		$zoom = guictrlread($slider3)
		ControlSend("PyMOL Viewer", "", "","zoom center, " & $zoom &" {enter}")
	else
		;###############THIS IS AUTO-CALIBRATION #####################
		tooltip("If at any time you wish to end Press ESC or Press PAUSE-BREAK to pause.",0,0,"Auto-calibrating zoom..." )
		$s_top = pixelsearch ($xt,$yt,$xb,$yb,0xb23535,150)
		$s_bottom = pixelsearch ($xb,$yb,$xt,$yt,0xb23535,150)
		$zoom = 10
		ControlSend("PyMOL Viewer", "", "","zoom center,10 {enter}")
		sleep(100)
		winactivate ("PyMOL Viewer")
		MouseWheel ( "up" ,50 )
		MouseWheel ( "up" ,50 )
		MouseWheel ( "up" ,50 )
		sleep(10)
		winactivate ($pymol_name)
		do 		
				
			
			clipput ("zoom center , " & $zoom)
			send("v")
			send ("{enter}")
			sleep(40)

					$fail_top = 0
			for $i = $yts to $s_top[1]
					if $fail_top = 0 then 
						if pixelgetcolor ($s_top[0],$i) = not $background then 
						$fail_top = 1
						EndIf
					endif
			Next
							
					$fail_bottom = 0
			for $o = $s_bottom[1] to $ybs
					if $fail_bottom = 0 then 
						if pixelgetcolor ($s_bottom[0],$o) = not $background then 
							$fail_bottom = 1
						EndIf
					EndIf
				Next
			$zoom = $zoom + 1	

				
		Until $fail_top = 0 and $fail_bottom = 0
				$zoom = $zoom - 1
			clipput ("zoom center , " & $zoom)
			send("^v")
			send ("{enter}")
			sleep(40)
			GUIctrlsetdata ($slider3 , $zoom)
			GUIctrlsetdata ($inputslider3 , $zoom)
		;##############################################################
	EndIf




tooltip("If at any time you wish to end Press ESC or Press PAUSE-BREAK to pause.",0,0,"Scanning . . . dont move anything over the protein veiwer" )


$sliderreadp = GUICtrlRead($slider1, 1)
GUICtrlSetData($button, $sliderreadp)

;==============================Change angle of rotation untill 360/angle = an interger==============================
$sliderreada = GUICtrlRead($slider2, 1)
do 
$int = 180/$sliderreada
$intx = int($int)
GUICtrlSetData($button4, $sliderreada)
$sliderreada = $sliderreada + 1
until $intx = $int
$sliderreada = $sliderreada - 1
GUICtrlSetData($button4, $sliderreada)
;=========================================================

$length = 0
$counterz = 0
$side = 0

$angle = $sliderreada
$pixelskip = $sliderreadp

;==============================Measures the area in pixels==============================
GUISetCursor(1)

winactivate ("PyMOL Viewer")
for $i = 1 to 20
send("{backspace}")
next
MouseWheel ( "up" ,50 )

Global $arr[1000000]

$countx = 0
$county = 0
$progresspercent = ($county/(180/$angle)) *100
GUICtrlSetData($progressbar1, $progresspercent)
$begin = TimerInit()

do

	do
		$search_smallest_box_top = pixelsearch ($xt,$yts,$xb,$yb,0xb23535,150)
		$yt = $search_smallest_box_top[1]-10
		$yta = $yt
		$search_smallest_box_bottom = pixelsearch ($xb,$yb,$xt,$yts,0xb23535,150)
		$yb = $search_smallest_box_bottom[1]+10
		Do
			

				Do

				$xta = $xta + $pixelskip
					if pixelgetcolor($xta,$yta) = not $background Then
						$length = $length + 1
						$side = $side + 1
					endif
				until $xta >$xb 
				$xta = $xt
				$yta = $yta + $pixelskip
				
		until $yta > $yb
		$yta = $yt

		ControlSend("PyMOL Viewer", "", "", "turn y, "& $angle &" {enter}")
		$counterz = $counterz + 1
		$arr[$counterz-1] = $side
		$side = 0
		$countx = $countx + 1
	until $countx = 180/$angle 
	ControlSend("PyMOL Viewer", "", "", "turn y, 180{enter}")
$countx =0
ControlSend("PyMOL Viewer", "", "", "turn x, "& $angle &" {enter}")
$round = round((TimerDiff($begin))/1000,1)
GUICtrlSetData($timer, $round)
$county = $county + 1
$progresspercent = ($county/(180/$angle)) *100
GUICtrlSetData($progressbar1, $progresspercent)
until $county = 180/$angle
ControlSend("PyMOL Viewer", "", "", "turn x, 180{enter}")
$county = 0
ReDim $arr[$counterz]
_arraysort($arr,0, 0, 0, 1)

GUICtrlSetData($timer, round((TimerDiff($begin)/1000),1))
GUISetCursor(0)
global $avgextlen = ($length*$pixelskip*$pixelskip)/((180/$angle)*(180/$angle))

$pixelpernm = (($winpos_pymolviewer[1]+$winsize_pymolviewer[1]+3)-($winpos_pymolviewer[1]+23))/($zoom*2)
GUICtrlSetData($n3 ,round($avgextlen/($pixelpernm*$pixelpernm),3))

$max =  _ArrayMax($arr, 1, 1)
$min =  _ArrayMin($arr, 1, 1)
;Minimum Cross sectional Area
$finalmin = round(  (    ($min*$pixelskip*$pixelskip)/($pixelpernm*$pixelpernm)),3)
GUICtrlSetData($menu7, $finalmin)

;Maximum Cross sectional Area
$finalmax = round((($max*$pixelskip*$pixelskip)/($pixelpernm*$pixelpernm)),3)
GUICtrlSetData($menu8, $finalmax)

;Asymetry index
$asym = round((($finalmin/$finalmax)*1),4)
GUICtrlSetData($menu11, $asym)


idle()
endfunc


; --------------------------------------------electrostatics -------------------------------
func count_electro()
	
		
	global $background = pixelgetcolor($xt,$yta)

	if guictrlread ($check_zoom) = $gui_checked then
		$zoom = guictrlread($slider3)
		ControlSend("PyMOL Viewer", "", "","zoom center, " & $zoom &" {enter}")
	else
		;###############THIS IS AUTO-CALIBRATION #####################
		tooltip("If at any time you wish to end Press ESC or Press PAUSE-BREAK to pause.",0,0,"Auto-calibrating zoom..." )
		$s_top = pixelsearch ($xt,$yt,$xb,$yb,0xb23535,150)
		$s_bottom = pixelsearch ($xb,$yb,$xt,$yt,0xb23535,150)
		$zoom = 10
		ControlSend("PyMOL Viewer", "", "","zoom center,10 {enter}")
		sleep(100)
		winactivate ("PyMOL Viewer")
		MouseWheel ( "up" ,50 )
		MouseWheel ( "up" ,50 )
		MouseWheel ( "up" ,50 )
		sleep(10)
		winactivate ($pymol_name)
		do 		
				
			
			clipput ("zoom center , " & $zoom)
			send("^v")
			send ("{enter}")
			sleep(40)

					$fail_top = 0
			for $i = $yts to $s_top[1]
					if $fail_top = 0 then 
						if pixelgetcolor ($s_top[0],$i) = not $background then 
						$fail_top = 1
						EndIf
					endif
			Next
							
					$fail_bottom = 0
			for $o = $s_bottom[1] to $ybs
					if $fail_bottom = 0 then 
						if pixelgetcolor ($s_bottom[0],$o) = not $background then 
							$fail_bottom = 1
						EndIf
					EndIf
				Next
			$zoom = $zoom + 1	

				
		Until $fail_top = 0 and $fail_bottom = 0
				$zoom = $zoom - 1
			clipput ("zoom center , " & $zoom)
			send("^v")
			send ("{enter}")
			sleep(40)
			GUIctrlsetdata ($slider3 , $zoom)
			GUIctrlsetdata ($inputslider3 , $zoom)
		;##############################################################
	EndIf




tooltip("If at any time you wish to end Press ESC or Press PAUSE-BREAK to pause.",0,0,"Scanning . . . dont move anything over the protein veiwer" )
		sleep(200)
		ControlSend("PyMOL Viewer", "", "","set specular, off" & " {enter}")
		sleep(500)

$sliderreadp = GUICtrlRead($slider1, 1)
GUICtrlSetData($button, $sliderreadp)

;==============================Change angle of rotation untill 360/angle = an interger==============================
$sliderreada = GUICtrlRead($slider2, 1)
do 
$int = 360/$sliderreada
$intx = int($int)
GUICtrlSetData($button4, $sliderreada)
$sliderreada = $sliderreada + 1
until $intx = $int
$sliderreada = $sliderreada - 1
GUICtrlSetData($button4, $sliderreada)
;=========================================================

$length = 0
$counterz = 0
$side = 0
$red = 0
$blue = 0
$red_tot = 0
$blue_tot = 0

$angle = $sliderreada
$pixelskip = $sliderreadp

;==============================Measures the area in pixels==============================
GUISetCursor(1)

winactivate ("PyMOL Viewer")
for $i = 1 to 20
send("{backspace}")
next
MouseWheel ( "up" ,50 )

Global $arr[1000000]

$countx = 0
$county = 0
$progresspercent = ($county/(360/$angle)) *100
GUICtrlSetData($progressbar1, $progresspercent)
$begin = TimerInit()

do

	do
		$search_smallest_box_top = pixelsearch ($xt,$yts,$xb,$yb,0xb23535,150)
		$yt = $search_smallest_box_top[1]-10
		$yta = $yt
		$search_smallest_box_bottom = pixelsearch ($xb,$yb,$xt,$yts,0xb23535,150)
		$yb = $search_smallest_box_bottom[1]+10
		Do
			

				Do

				$xta = $xta + $pixelskip
				$color = pixelgetcolor($xta,$yta)
					if $color = not $background Then
							    $hex = Hex ( $color , 6)
								$HR = StringMid($hex, 1, 2)
								$HG = StringMid($hex, 3, 2)
								$HB = StringMid($hex, 5, 2)
								$Rx = Dec($HR)
								$Gx = Dec($HG)
								$Bx = Dec($HB)
								if $Rx > $Bx then 
									;if $Gx + $Bx = 0 then 
										$red = $red + 1
										$red_tot = $red_tot + 1
									;endif
								EndIf
								if $Bx > $Rx then 
									;if $Gx + $Rx = 0 then 
										$blue = $blue + 1
										$blue_tot = $blue_tot + 1
									;EndIf
								EndIf
								
							
						$length = $length + 1
						$side = $side + 1
					endif
				until $xta >$xb 
				$xta = $xt
				$yta = $yta + $pixelskip
				
		until $yta > $yb
		$yta = $yt

		ControlSend("PyMOL Viewer", "", "", "turn y, "& $angle &" {enter}")
		sleep(100)
		$counterz = $counterz + 1
		$arr[$counterz-1] = $side
		$side = 0
		$countx = $countx + 1
	until $countx = 360/$angle 
	sleep(50)
$countx =0
ControlSend("PyMOL Viewer", "", "", "turn x, "& $angle &" {enter}")
sleep(100)
$round = round((TimerDiff($begin))/1000,1)
GUICtrlSetData($timer, $round)
$county = $county + 1
$progresspercent = ($county/(360/$angle)) *100
GUICtrlSetData($progressbar1, $progresspercent)
until $county = 360/$angle
$county = 0
ReDim $arr[$counterz]
_arraysort($arr,0, 0, 0, 1)
GUISetCursor(0)
global $negative_area = ($red_tot*$pixelskip*$pixelskip)/((360/$angle)*(360/$angle))
global $positive_area = ($blue_tot*$pixelskip*$pixelskip)/((360/$angle)*(360/$angle))
global $all_area = ($length*$pixelskip*$pixelskip)/((360/$angle)*(360/$angle))
$pixelpernm = (($winpos_pymolviewer[1]+$winsize_pymolviewer[1]+3)-($winpos_pymolviewer[1]+23))/($zoom*2)

GUICtrlSetData($n3x ,round ($all_area/($pixelpernm*$pixelpernm),3))  


GUICtrlSetData($menu8x, round ($negative_area/($pixelpernm*$pixelpernm),3)& " (" & round(100*(round($negative_area,0)) /(round($all_area,0)),0) & "%)" )


GUICtrlSetData($menu7x, round ($positive_area/($pixelpernm*$pixelpernm),3)& " (" & round(100*(round($positive_area,0)) /(round($all_area,0)),0) & "%)" )


$asymx = round((($negative_area/$positive_area)*1),4)
GUICtrlSetData($menu11x,$asymx )

idle()
endfunc ; ----------------------------- for electrostatics -------------------

Func Terminate()
    Exit 0
EndFunc

Func TogglePause()
  $Paused = NOT $Paused
  While $Paused
    sleep(100)
    ToolTip('Script is "Paused"',0,0)
  WEnd
  ToolTip("",0,0)
EndFunc

Func IconButton($BItext, $BIleft, $BItop, $BIwidth, $BIheight, $BIconNum, $BIDLL = "shell32.dll")
    GUICtrlCreateIcon($BIDLL, $BIconNum, $BIleft + 5, $BItop + (($BIheight - 16) / 2), 16, 16)
    GUICtrlSetState( -1, $GUI_DISABLE)
    $XS_btnx = GUICtrlCreateButton($BItext, $BIleft, $BItop, $BIwidth, $BIheight, $WS_CLIPSIBLINGS)
    Return $XS_btnx
EndFunc

Func _DwmEnable($WhatToDo)
DllCall("dwmapi.dll", "long", "DwmEnableComposition", "uint", $WhatToDo)
EndFunc
	