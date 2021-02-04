#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Include <Memory.au3>
#Include <Excel.au3>
;-------------------------------------------------------------------------------------------------------------------
local $font
;  ####################
;####   First Screen #####
;  ####################

;  ##########
;###Labels####
;  #########

GuiCreate("gui gui", 400, 520)
$font = "Comic Sans MS"
	$title0 = GUICtrlCreateLabel("test gui",50,195,400,70)
	GUICtrlSetFont(-1, 23, 400, -1, $font)
	GUICtrlSetColor($title0,0x000080)
	
	$font = "Comic Sans MS"
	$title1 = GUICtrlCreateLabel("one two three",115,240,400,70)
	GUICtrlSetFont(-1, 21, 400, -1, $font)
	GUICtrlSetColor($title1,0x000080)

;GUICtrlCreateLabel ( "text", left, top [, width [, height [, style [, exStyle]]]] )


$feb = GUICtrlCreateLabel("Feb 2010",170, 445)
$version = GUICtrlCreateLabel("Version 1.0", 167, 460)
$rights = GUICtrlCreateLabel("All Rights Reserve ®", 145, 475)

;  ##########
;####Vars######
;  #########

;GUICtrlCreatePic(left,top,witdh,height
$Buttonnext = GuiCtrlCreateButton("Next", 30,470,100,20)
$Buttonexit = GuiCtrlCreateButton("Exit", 267,470,100,20)

;  ##########
;#####Menu#####
;  #########

$Menu = GUICtrlCreateMenu("File")
$ExitItem = GUICtrlCreateMenuItem("Exit", $Menu)
$Help = GUICtrlCreateMenu("Help")
$About = GUICtrlCreateMenuItem("About", $Help)

;  ##########
;#####Rules File#####
;  ###########



;  #########
;####Loop#####
;  ########

GuiSetState()
While 1
$msg = GuiGetMsg()
Select

;  #############
;###Case1 Exit - if X button pressed####
;  ############


Case $msg = $GUI_EVENT_CLOSE
  $Exit = MsgBox(262452,"Exit","Are You Sure You Want To Exit?")
	If $Exit = 6 Then
		Exit
	Endif

;  ##############
;####Case2 Exit - if exit button pressed#####
;  #############

Case $msg = $Buttonexit
  $Exit = MsgBox(262452,"Exit","Are You Sure You Want To Exit?")
	If $Exit = 6 Then
		Exit
	Endif

;  ###############
;####Case4 Next#####
;  ##############
 
Case $msg = $Buttonnext

GUISetState(@SW_Hide)


;---------------------------------------------------------------------------------------------------------------------

;  ####################
;####  Second Screen - MENU ####
;  ####################
local $file, $thirdgui
$menugui = GuiCreate("MENU", 800, 680)
GuiSetState()


$font = "Comic Sans MS"
	$menutitle = GUICtrlCreateLabel("MENU", 360,10,380,70)
	GUICtrlSetFont(-1, 20, 400, 4, $font)
	GUICtrlSetColor($menutitle,0x000080)
;GUICtrlCreateLabel ( "text", left, top [, width [, height [, style [, exStyle]]]] )

$font = "Comic Sans MS"
	$menulabel = GUICtrlCreateLabel("what",600,60,210,100)
	GUICtrlSetFont(-1, 10, 400, 1, $font)
	GUICtrlSetColor($menulabel,0x000000)
$font = "Comic Sans MS"
	$menulabel2 = GUICtrlCreateLabel("label",545,80,250,100)
	GUICtrlSetFont(-1, 10, 400, 1, $font)
	GUICtrlSetColor($menulabel2,0x000000)
	
$vendor1 = GUICtrlCreateCheckbox("one",20,180)
$vendor2 = GUICtrlCreateCheckbox("two",20,200)
$vendor3 = GUICtrlCreateCheckbox("three",20,220)


$Button_1 = GuiCtrlCreateButton("Next", 35, 650, 100, 20)
$Button_2 = GuiCtrlCreateButton("Exit", 665, 650, 100, 20)


;  #########
;####Loop####
;  ########

GuiSetState()
While 1
$msg1 = GuiGetMsg()
Select

;  ######################################################
;####Case1 Exit Loop - Case1 Exit - if X button pressed######
;  ######################################################

Case $msg1 = $GUI_EVENT_CLOSE
  $Exit = MsgBox(262452,"Exit","Are You Sure You Want To Exit?")
	If $Exit = 6 Then
		Exit
	Endif

;  ##############
;####Case2 Exit - if exit button pressed#######
;  #############
Case $msg1 = $Button_2
  $Exit = MsgBox(262452,"Exit","Are You Sure You Want To Exit?")
	If $Exit = 6 Then
		Exit
	Endif
	
;  ##############
;####Case4 Next#####
;  ##############
Case $msg1 = $Button_1
	GUISetState(@SW_HIDE)
	
	
	
;  #####################################
;####  third Screen - windows rules ####
;  #####################################


local $file
$secondgui = GuiCreate("We! Book Of Rules", 800, 680)
GuiSetState()
$font = "Comic Sans MS"
	$title2 = GUICtrlCreateLabel("labellabel", 140,20,380,70)
	GUICtrlSetFont(-1, 20, 400, 4, $font)
	GUICtrlSetColor($title2,0x000080)
;GUICtrlCreateLabel ( "text", left, top [, width [, height [, style [, exStyle]]]] )

$font = "Comic Sans MS"
	$thirdlabel = GUICtrlCreateLabel("sign",620,95,210,100)
	GUICtrlSetFont(-1, 10, 400, 1, $font)
	GUICtrlSetColor($thirdlabel,0x000000)
$font = "Comic Sans MS"
	$forthlabel = GUICtrlCreateLabel("label",555,115,220,100)
	GUICtrlSetFont(-1, 10, 400, 1, $font)
	GUICtrlSetColor($forthlabel,0x000000)

;GUICtrlCreateLabel("_____________________________________________________________________________________________________",1,142,680,30)

;GUICtrlCreateLabel ( left, top , width , height )


$box1 = GUICtrlCreateCheckbox("001",10,160)
$box2 = GUICtrlCreateCheckbox("002",10,180)
$box3 = GUICtrlCreateCheckbox("003",10,200)



; ########
;###Vars####
; #######

$Button_3 = GuiCtrlCreateButton("Next", 35, 650, 100, 20)
$Button_4 = GuiCtrlCreateButton("Exit", 465, 650, 100, 20)
$prevButton = GuiCtrlCreateButton("Previous", 365, 650, 100, 20)

;  #########
;####Loop####
;  ########

GuiSetState()
While 1
$msg1 = GuiGetMsg()
Select

;  ######################################################
;####Case1 Exit Loop - Case1 Exit - if X button pressed######
;  ######################################################

Case $msg1 = $GUI_EVENT_CLOSE
  $Exit = MsgBox(262452,"Exit","Are You Sure You Want To Exit?")
	If $Exit = 6 Then
		Exit
	Endif

	
;  ##############
;####Case4 Previous#####
;  ##############	
Case $msg1 = $prevButton
	GUISetState(@SW_HIDE)
	
	
;  ##############
;####Case2 Exit - if exit button pressed#######
;  #############
Case $msg1 = $Button_4
  $Exit = MsgBox(262452,"Exit","Are You Sure You Want To Exit?")
	If $Exit = 6 Then
		Exit
	Endif
	
;  ##############
;####Case4 Next#####
;  ##############
Case $msg1 = $Button_3






GUISetState(@SW_Hide)


;----------------------------------------------------------------------------------------------------------------------

;  ####################
;####  Third Screen ####
;  ####################

local $file
$thirdgui = GuiCreate("guigui", 800, 680)
GuiSetState()


GUICtrlCreateLabel("_____________________________________________________________________________________________________",1,142,800,30)

;GUICtrlCreateLabel ( left, top , width , height )





; ########
;###Vars####
; #######

$Button_5 = GuiCtrlCreateButton("Next", 35, 650, 100, 20)
$Button_6 = GuiCtrlCreateButton("Exit", 465, 650, 100, 20)

;  #########
;####Loop####
;  ########

GuiSetState()
While 1
$msg1 = GuiGetMsg()
Select

;  ######################################################
;####Case1 Exit Loop - Case1 Exit - if X button pressed######
;  ######################################################

Case $msg1 = $GUI_EVENT_CLOSE
  $Exit = MsgBox(262452,"Exit","Are You Sure You Want To Exit?")
	If $Exit = 6 Then
		Exit
	Endif

;  ##############
;####Case2 Exit - if exit button pressed#######
;  #############
Case $msg1 = $Button_6
  $Exit = MsgBox(262452,"Exit","Are You Sure You Want To Exit?")
	If $Exit = 6 Then
		Exit
	Endif
	
;  ##############
;####Case4 Next#####
;  ##############
Case $msg1 = $Button_5




GUISetState(@SW_Hide)

;  ####################
;####  Forth Screen ####
;  ####################

GuiCreate("Wgui", 800, 680)
GuiSetState()

$checkpnt1 = GUICtrlCreateCheckbox("099",10,190)
$checkpnt2 = GUICtrlCreateCheckbox("100",10,210)
$checkpnt3 = GUICtrlCreateCheckbox("101",10,230)



GuiSetState()

;  ##########
;####Vars######
;  #########
$Button_7 = GuiCtrlCreateButton("Next", 35, 650, 100, 20)
$Button_8 = GuiCtrlCreateButton("Exit", 465, 650, 100, 20)
$Button_9 = GuiCtrlCreateButton("Previous", 160, 650, 100, 20)

;  ##########
;#####Loop######
;  #########

GuiSetState()
While 1
$msg3 = GuiGetMsg()
Select

;  ###############
;####Case1 Exit######
;  ###############

Case $msg3 = $GUI_EVENT_CLOSE
Exit

;  ##############
;####Case2 Exit######
;  ##############

Case $msg3 = $Button_8
Exit

;  ##############
;####Case3 Exit######
;  ##############

Case $msg3 = $ExitItem
Exit

;  ###############
;####Case4 Previous#####
;  ###############

Case $msg3 = $Button_9

;  ###############
;####Case4 Next#####
;  ###############

Case $msg3 = $Button_7



GUISetState(@SW_Hide)

;----------------------------------------------------------------------------------------------------------------------

;  ##################
;####   Fifth Screen    ####
;  ##################
GuiCreate("gui create", 600, 680)
GuiSetState()

$font = "Comic Sans MS"
	$title7 = GUICtrlCreateLabel("bla bla", 120,49,350,70)
	GUICtrlSetFont(-1, 20, 400, 4, $font)
	GUICtrlSetColor($title7,0x000080)
$font = "Comic Sans MS"
	$ninelabel = GUICtrlCreateLabel("sign -",439,108,210,100)
	GUICtrlSetFont(-1, 11, 400, 1, $font)
	GUICtrlSetColor($ninelabel,0x000000)
$font = "Comic Sans MS"
	$tenlabel = GUICtrlCreateLabel("save -",376,127,220,100)
	GUICtrlSetFont(-1, 11, 400, 1, $font)
	GUICtrlSetColor($tenlabel,0x000000)	
	
GUICtrlCreateLabel("_____________________________________________________________________________________________________",1,145,680,30)

$symantec1 = GUICtrlCreateCheckbox("Security Risk found",10,190)
$symantec2 = GUICtrlCreateCheckbox(" Virus Storm",10,210)
$symantec3 = GUICtrlCreateCheckbox(" Virus found",10,230)

$Button_10 = GuiCtrlCreateButton("Next", 35, 650, 100, 20)
$Button_11 = GuiCtrlCreateButton("Exit", 465, 650, 100, 20)
$Button_12 = GuiCtrlCreateButton("Previous", 160, 650, 100, 20)


;  ##########
;#####Loop######
;  #########

GuiSetState()
While 1
$msg = GuiGetMsg()
Select

;  ###################
;####Case1 Exit Loop######
;  ###################


Case $msg = $GUI_EVENT_CLOSE
  $Exit = MsgBox(262452,"Exit","Are You Sure You Want To Exit?")
	If $Exit = 6 Then
		Exit
	Endif


;  ###################
;####Write selected rules to file#####
;  ###################

Case $msg = $button_10
if GUICtrlRead($symantec1) =  $GUI_CHECKED Then
FileWriteLine($rulesfile, "risk")
EndIf
if GUICtrlRead($symantec2) =  $GUI_CHECKED Then
FileWriteLine($rulesfile, "storm")
EndIf
if GUICtrlRead($symantec3) =  $GUI_CHECKED Then
FileWriteLine($rulesfile, "gui")
EndIf


;---------------------------------------------------------------------------------------------------------------------------
;  #########
;####Loop#####
;  ########


While 1
$msg = GuiGetMsg()
Select



;  ############
;####Cases End####
;  ###########
EndSelect
WEnd

EndSelect
WEnd

EndSelect
WEnd

Case Else
EndSelect
WEnd

Case Else
EndSelect
WEnd

Case Else
EndSelect
WEnd




;-----------------------------------------------------------------------------------------------------------------------------
;  ##########################
;####Gui Loop And Cases End######
;  ##########################
;while 1

;case $msg = $About
MsgBox(64, "About ® ", "® "& @CRLF & "Version : 1.0" & @CRLF & "Date: 26.02.2010" & @CRLF & "Copyright © ")


Case Else
EndSelect
WEnd