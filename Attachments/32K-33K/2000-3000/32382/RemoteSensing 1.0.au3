
#include <GUIconstants.au3>

Opt("GUICoordMode", 1)

GUICreate("Collect Data", 500,400)

; Create the controls
$button_1 = GUICtrlCreateButton ("Collect Data", 30, 20, 320, 40)


$group_1 = GUICtrlCreateGroup ("Sensors", 30, 90, 165, 300)

$switch1 = GUICtrlCreateCheckbox ("Sensor 18", 50, 120, 80, 20) 
$switch2 = GUICtrlCreateCheckbox ("Sensor 22", 50, 150, 80, 20)
$switch3 = GUICtrlCreateCheckbox ("Sensor 34", 50, 180, 80, 20)
$switch4 = GUICtrlCreateCheckbox ("Sensor 100", 50, 210, 90, 20)
$switch5 = GUICtrlCreateCheckbox ("Sensor 132", 50, 240, 90, 20)
$switch6 = GUICtrlCreateCheckbox ("Sensor 145", 50, 270, 90, 20)
$switch7 = GUICtrlCreateCheckbox ("Sensor 7", 50, 300, 80, 20)
$switch8 = GUICtrlCreateCheckbox ("Sensor 8", 50, 330, 80, 20)
$switch9 = GUICtrlCreateCheckbox ("Sensor 9", 50, 360, 80, 20)


$group_2 = GUICtrlCreateGroup ("File Name", 210, 90, 165, 60)
$filename = GUICtrlCreateInput ("No Spaces!", 220, 110, 140, 30)


$group_3 = GUICtrlCreateGroup ("Frequency", 210,160, 165, 60)
$frequency = GUICtrlCreateInput ("40, 80, 100, 280", 220, 180, 140, 30)


$group_4 = GUICtrlCreateGroup ("Duration", 210, 230, 165, 60)
$time = GUICtrlCreateInput ("(Seconds)", 220, 250, 140, 30)


$group_5 = GUICtrlCreateGroup ("Axes", 210, 300, 165, 60)
$switchx= GUICtrlCreateCheckbox ("X", 230, 320, 40, 20)
$switchy = GUICtrlCreateCheckbox ("Y", 280, 320, 40, 20)
$switchz = GUICtrlCreateCheckbox ("Z", 330, 320, 40, 20)


; Set the defaults (radio buttons clicked, default button, etc)
GUICtrlSetState($switch1, $GUI_CHECKED)
GUICtrlSetState($switch2, $GUI_CHECKED)
GUICtrlSetState($switch3, $GUI_CHECKED)
GUICtrlSetState($switch4, $GUI_CHECKED)
GUICtrlSetState($switch5, $GUI_CHECKED)
GUICtrlSetState($switch6, $GUI_CHECKED)

GUICtrlSetState($filename, $GUI_FOCUS)

; Initiate our variables that we will use to keep track of radio events.
$radioval1 = 0    ; We will assume 0 = first radio button selected, 2 = last button.
$radioval2 = 2

GUISetState ()

; In this message loop we use variables to keep track of changes to the radios, another
; way would be to use GUICtrlRead() at the end to read in the state of each control.  
; Both methods are equally valid.
While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE
         Exit
         
      Case $msg = $button_1;When the button is clicked
		
		;Translate the Sensor Check Boxes
		$state1 = GUICtrlRead($switch1)
			If $state1 = 1 Then $sensor1="18 "
			If $state1 = 4 Then $sensor1=""
		$state2 = GUICtrlRead($switch2)
			If $state2 = 1 Then $sensor2="22 "
			If $state2 = 4 Then $sensor2=""
		$state3 = GUICtrlRead($switch3)
			If $state3 = 1 Then $sensor3="34 "
			If $state3 = 4 Then $sensor3=""
		$state4 = GUICtrlRead($switch4)
			If $state4 = 1 Then $sensor4="100 "
			If $state4 = 4 Then $sensor4=""
		$state5 = GUICtrlRead($switch5)
			If $state5 = 1 Then $sensor5="132 "
			If $state5 = 4 Then $sensor5=""
		$state6 = GUICtrlRead($switch6)
			If $state6 = 1 Then $sensor6= "145 "
			If $state6 = 4 Then $sensor6=""
		$state7 = GUICtrlRead($switch7)
			If $state7 = 1 Then $sensor7="7 " 
			If $state7 = 4 Then $sensor7=""
		$state8 = GUICtrlRead($switch8)
			If $state8 = 1 Then $sensor8="8 " 
			If $state8 = 4 Then $sensor8=""
		$state9 = GUICtrlRead($switch9)
			If $state9 = 1 Then $sensor9="9 " 
			If $state9 = 4 Then $sensor9=""
		
		
		;Translate Axes
		$statex = GUICtrlRead($switchx)
			If $statex = 1 Then $xaxis="1" 
			If $statex = 4 Then $xaxis=""
		$statey = GUICtrlRead($switchy)
			If $statey = 1 Then $yaxis="2" 
			If $statey = 4 Then $yaxis=""
		$statez = GUICtrlRead($switchz)
			If $statez = 1 Then $zaxis="3" 
			If $statez = 4 Then $zaxis=""
				
		
		;Translate & Convert Time to samples
		$seconds=GUICtrlRead($time)
		$freq=GUICtrlRead($frequency)
		$nsamples=$seconds*$freq
		
	;Start Cygwin, 
		Run("C:\tinyos\cygwin\Cygwin.bat")
		WinWaitActive ( "~")
		AutoItSetOption ( "SendKeyDelay", 15)
	;;
		Send("imote2comm{SPACE}-n{SPACE}-o{SPACE}")
		Send(GUICtrlRead($filename))
		Send(".txt{SPACE}COM7{ENTER}")
		Sleep(200)
		Send("{ENTER}")
		Send("{ENTER}")
	;
		Run("C:\tinyos\cygwin\Cygwin.bat")
		Sleep(1000)
		Send("imote2comm{SPACE}-d{SPACE}COM8{ENTER}")
		Sleep(1000)
		Send("{ENTER}")
		Sleep(1000)
		AutoItSetOption ( "SendKeyDelay", 25)
		Send("RemoteSensing{SPACE}")
		Send($sensor1)
		Send($sensor2)
		Send($sensor3)
		Send($sensor4)
		Send($sensor5)
		Send($sensor6)
		Send($sensor7)
		Send($sensor8)
		Send($sensor9)
		Send("{Backspace}")
		Send("{ENTER}")
		Sleep(40)
		Send("GetData{SPACE}")
		Send($xaxis)
		Send($yaxis)
		Send($zaxis)
		Send("{SPACE}")
		Send($nsamples) 
		Send("{SPACE}")
		Send(GUICtrlRead($frequency))
		Send("{ENTER}StartCollection{ENTER}")
		
		
		

   EndSelect
WEnd
