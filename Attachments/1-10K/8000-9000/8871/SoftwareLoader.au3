#include "GUIConstants.au3"
#include <Array.au3>
#NoTrayIcon



if not Fileexists( "config.ini" ) then
	MsgBox(0, "Config.ini Error!", "Config.ini not found!")
	Exit
Endif


;==========================================================================
;Create and sort $masterarray, contains names of sections in ini file
;Create and sort $grouparray, contains names of sw groups
;==========================================================================


$groups = IniReadSection("config.ini","Groups")

if @error then
	MsgBox(0, "Config.ini Error!", "[Groups] section not found! You must have a [Groups] section at the top of config.ini!")
	Exit
Endif


$masterarray = IniReadSectionNames("config.ini")

;_ArrayDisplay ( $Masterarray, "masterarray" )

_ArraySort($masterarray,0,2)

if $masterarray[1] <> "Groups" then
	MsgBox(0, "Config.ini Error!", "[Groups] is not first! You must move [Groups] to the top of the config.ini file!")
	Exit
Endif

;_ArrayDisplay ( $Masterarray, "masterarray" )



$groupcount = 0

Dim $grouparray[UBound($groups)]

do

	$grouparray [$groupcount] = $groups [$groupcount] [1]
	$groupcount = $groupcount + 1

until $groupcount = UBound ($groups)

_ArraySort($grouparray,0,1)



	


;===========================================================================
;INI Check for errors
;===========================================================================


$groupcount=2

do
	$val = IniRead("config.ini",$masterarray[$groupcount],"Location","UHOHNOTHINGHERE")
	if $val = "UHOHNOTHINGHERE" then
		MsgBox(0, "Config.ini Error!", "Location not found in config.ini: " & $masterarray[$groupcount] & Chr(13) & "All programs must have a location!")
		Exit
	Elseif not FileExists( $val ) then
		MsgBox(0, "Config.ini Error!", "File for " & $masterarray[$groupcount] & " not found at" & $val)
		Exit
	Else
		$groupcount = $groupcount + 1
	Endif
Until $groupcount = UBound ( $masterarray )


$groupcount = 2


do
	$val = IniRead("config.ini",$masterarray[$groupcount],"Type","UHOHNOTHINGHERE")
	if $val = "UHOHNOTHINGHERE" then
		MsgBox(0, "Config.ini Error!", "Type not found in config.ini: " & $masterarray[$groupcount] & Chr(13) & "All programs must have a type! (Managed, Unmanaged, or Printer)")
		Exit
	Elseif StringLower($val) = "managed" or StringLower($val) = "unmanaged" or StringLower($val) = "printer" then
		$groupcount = $groupcount + 1
	Else
		MsgBox(0, "Config.ini Error!", 'Type for: ' & $masterarray[$groupcount] & ' must be "Managed", "Unmanaged", or "Printer"!')
		Exit

	Endif
Until $groupcount = UBound ( $masterarray )


;===========================================================================
;Create $checkgroupsarray for groups
;===========================================================================


Dim $checkgroupsarray [Ubound($grouparray)] [Ubound($masterarray)]


$mastercount = 2

$groupcount = 1


do

do
	If StringLower(IniRead ("config.ini",$masterarray[$mastercount],$grouparray[$groupcount],"No")) = "yes" then
		$checkgroupsarray[$groupcount][$mastercount] = 1
	Endif
	$groupcount = $groupcount + 1
until $groupcount = UBound ($grouparray)

$groupcount = 1
$mastercount = $mastercount + 1

until $mastercount = UBound ($masterarray)






;===========================================================================
;Create GUI
;===========================================================================



;Create Window
GUICreate("MYCOMPANYNAME - Software Loader", 920, 600)
GUICtrlCreateLabel("What software would you like to install?", 30, 10)


;Create Groups
GuiCtrlCreateGroup("License-Managed Applications", 5, 150, 300, 400)
GuiCtrlCreateGroup("Unmanaged Applications", 315, 150, 300, 400)
GuiCtrlCreateGroup("Printers", 625, 150, 290, 400)

;Create Buttons

$cancelbutton = GUICtrlCreateButton("&Cancel", 430, 560, 70, 30)

$okbutton = GUICtrlCreateButton("&Install", 350, 560, 70, 30)
GUICtrlSetFont ($okbutton, 9 , 600,0,"MS Dialog Light")

$uncheckbutton = GUICtrlCreateButton("&Uncheck All", 510, 560, 70, 30)

$rebootcheck = GUICtrlCreateCheckbox ("Reboot after install?", 600, 560, 120, 20)




;==============================================
;Create Radio Button group and radio buttons
;==============================================


GuiCtrlCreateGroup("Software Profiles:", 20, 40, 880, 105)

$groupcount = 1
$groupypos = 60
$groupxpos = 30
Dim $groupradio[Ubound($grouparray)]
$groupradio[0] = "hi"

	do 
	
	$groupradio[$groupcount] = GUICtrlCreateRadio ($grouparray[$groupcount], $groupxpos, $groupypos, 140, 20)
	$groupcount = $groupcount+1
	$groupypos = $groupypos + 20

	if $groupypos > 120 then
		$groupypos = 60	
		$groupxpos = $groupxpos + 145
	Endif

	until $groupcount = Ubound($grouparray) or $groupcount = 25


GUICtrlCreateGroup ("",-99,-99,1,1)



;==============================================
;Create checkboxes
;==============================================


Dim $groupcheck[Ubound($masterarray)]
$groupcheck[0] = "hi"
$groupcheck[1] = "hi"

;==========
;Managed
;==========

$groupcount = 2
$groupypos = 180
$groupxpos = 10

do

	if IniRead ( "config.ini", $masterarray[$groupcount], "Type", "0" ) = "Managed" then
		$groupcheck[$groupcount] = GUICtrlCreateCheckbox ($masterarray[$groupcount], $groupxpos, $groupypos, 140, 20)
		$groupypos = $groupypos + 20
	Endif


	if $groupypos > 520 then
		$groupypos = 180	
		$groupxpos = $groupxpos + 140
	Endif


	$groupcount = $groupcount + 1	

until $groupcount = Ubound($masterarray)


;==========
;Unmanaged
;==========

$groupcount = 2
$groupypos = 180
$groupxpos = 320



do

	if IniRead ( "config.ini", $masterarray[$groupcount], "Type", "0" ) = "Unmanaged" then
		$groupcheck[$groupcount] = GUICtrlCreateCheckbox ($masterarray[$groupcount], $groupxpos, $groupypos, 140, 20)
		$groupypos = $groupypos + 20
	Endif

	if $groupypos > 520 then
		$groupypos = 180	
		$groupxpos = $groupxpos + 145
	Endif


	$groupcount = $groupcount + 1	

until $groupcount = Ubound($masterarray)

;==========
;Printers
;==========


$groupcount = 2
$groupypos = 180
$groupxpos = 630



do

	if IniRead ( "config.ini", $masterarray[$groupcount], "Type", "0" ) = "Printer" then
		$groupcheck[$groupcount] = GUICtrlCreateCheckbox ($masterarray[$groupcount], $groupxpos, $groupypos, 135, 20)
		$groupypos = $groupypos + 20
	Endif

	if $groupypos > 520 then
		$groupypos = 180	
		$groupxpos = $groupxpos + 145
	Endif


	$groupcount = $groupcount + 1	

until $groupcount = Ubound($masterarray)






;===========================================================================
;Poll GUI for events
;===========================================================================



; Show GUI, and wait for OK to be pressed

GUISetState()




While 1


    $msg = GUIGetMsg()
    Select

    Case $msg = $GUI_EVENT_CLOSE
        Exit
    Case $msg = $cancelbutton
        Exit
    Case $msg = $uncheckbutton
        UnCheckAll()
    Case $msg = $okbutton

	;====================================
	;"Install" was pressed, create $checkedarray (contains a 1 for each checked box)


		Dim $checkedarray[UBound ($masterarray)]
		$groupcount = 2
		
		
		do
		
			$val = GUICtrlRead($groupcheck[$groupcount])
			if $val = $GUI_CHECKED then
			$checkedarray[$groupcount] = 1
			else 
			$checkedarray[$groupcount] = 0
			endif
		
			$groupcount = $groupcount + 1
		
		until $groupcount = UBound ($groupcheck)



		$groupcount = 2
		$checkedtotal = 0


		
		do
			$checkedtotal = $checkedtotal + $checkedarray[$groupcount]
			$groupcount = $groupcount + 1
		
		until $groupcount = UBound ($checkedarray)
		
		$yval = 60 + (20 * $checkedtotal)
		
		
		
		;Complain if nothing is checked
		
		if $checkedtotal = 0 then
			MsgBox(0, "No entries selected!", "Nothing selected for installation!")
		else
			if GUICtrlRead($rebootcheck) = $GUI_CHECKED then
			$reboot = 1
			else 
			$reboot = 0
			endif
			ExitLoop
		endif

	;Back to the loop
	;====================================


    Case Else

	$groupcount=1

	do

		if $msg = $groupradio[$groupcount] then
		UncheckAll()
		Checkgroup ($groupcount)
		ExitLoop
		else
		$groupcount = $groupcount+1
		Endif

	until $groupcount = Ubound($groupradio) or $groupcount = 21



    EndSelect


Wend





GuiDelete() ;get rid of GUI



;===========================================================================
;Create list window
;===========================================================================


;Create window, yval was calculated when install was pressed

GUICreate("Installing...", 200, $yval, 50 ,50 , $WS_EX_STATICEDGE, $WS_EX_TOPMOST)


;Create labels

$groupcount = 2
$yval = 10
Dim $labelarray[UBound($checkedarray)]

do

	if $checkedarray[$groupcount] = 1 then
	$labelarray[$groupcount] = GUICtrlCreateLabel($masterarray[$groupcount], 10, $yval, 290)
	$yval = $yval + 20
	endif

	$groupcount = $groupcount + 1


until $groupcount = UBound($checkedarray)


;create reboot label if reboot was requested

if $reboot = 1 then 
$rebootlabel = GUICtrlCreateLabel("-Reboot-", 10, $yval, 290)
endif


GUISetState()



;===========================================================================
;Do the installation
;===========================================================================



$groupcount = 2


do

	if $checkedarray[$groupcount] = 1 then
	GUICtrlSetFont ($labelarray[$groupcount], 9 , 600,0,"MS Dialog Light")
	RunWait (IniRead ("config.ini",$masterarray[$groupcount],"Location","error"))
	;Sleep(3000)
	GUICtrlSetFont ($labelarray[$groupcount], 9 , 400,0,"MS Dialog Light")
	endif
	
	$groupcount = $groupcount + 1

until $groupcount = UBound ($masterarray)


;======================
;Reboot if requested
;======================



if $reboot = 1 then 
GUICtrlSetFont ($rebootlabel, 9 , 600,0,"MS Dialog Light")
Sleep (5000)
Shutdown (6)
endif



GuiDelete() 
Exit





;===========================================================================
;Function - Check all boxes associated with group
;===========================================================================


Func Checkgroup($groupnumber)


$mastercount = 2

do

	if $checkgroupsarray [$groupnumber] [$mastercount] = 1 then
		GuiCtrlSetState($groupcheck[$mastercount], $GUI_CHECKED)
	endif
	
	$mastercount = $mastercount + 1

until $mastercount = UBound($masterarray)


EndFunc

;===========================================================================
;Function - Uncheck all boxes
;===========================================================================


Func Uncheckall()

$mastercount = 2

do

	GuiCtrlSetState($groupcheck[$mastercount], $GUI_UNCHECKED)
	$mastercount = $mastercount + 1

until $mastercount = UBound($groupcheck)



EndFunc

