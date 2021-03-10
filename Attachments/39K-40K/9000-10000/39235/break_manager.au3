; by Keither
#include <GuiConstantsEx.au3>
#Include <Timers.au3>

;---------------------------------------------------------------------------------------------------------------------------------------------------------------

;-------------------------------------------------------------------------------GUI
Global $title = "Break Manager"
Global $title2= "Time's up"
Global $gui_dim[2] = [320,240]
Global $gui2_dim[2] = [340,80]
;-------------------------------------------------------------------------------Button related
;dim
Global $go_button_dim[2] = [120,30]
Global $exit_button_dim[2] = [60,30]
Global $button2_dim[2] = [120,30]
;name
Global $go_button_name = "Let's get to work!"
Global $exit_button_name = "Exit"
Global $bw_button_name[2] = ["Take a break","Get back to work"]
Global $nm_button_name[2] = ["15 min more of work","5 min more of break"]
;axis
Global $go_button_axis[2] = [120,190]
Global $exit_button_axis[2] = [240,190]
Global $bw_button_axis[2] = [10,40]
Global $nm_button_axis[2] = [130,40]
Global $exit2_button_axis[2] = [270,40]
;-------------------------------------------------------------------------------Other controls
;slider
Global $slider_axis[2] = [20,40]
Global $slider_dim[2] = [230,40]
Global $slider_max_min[2] = [300,30]
Global $slider_default = 90
Global $slider2_axis[2] = [20,120]
Global $slider2_dim[2] = [230,40]
Global $slider2_max_min[2] = [90,5]
Global $slider2_default = 10
;label
Global $label1_text = "90"
Global $label1_axis[2] = [$slider_dim[0]+20, $slider_axis[1]]
Global $label2_text = "How many minutes do you want to work before the break?"
Global $label2_axis[2] = [20,10]
Global $label3_text = "10"
Global $label3_axis[2] = [$slider2_dim[0]+20, $slider2_axis[1]]
Global $label4_text = "How many minutes of break do you need?"
Global $label4_axis[2] = [20,90]
Global $label5_text[2] = ["It's time to take a break.","Break is over."]
Global $label5_axis[2] = [10,15]
;checkbox
Global $checkbox1_text = "Show small upper-right frame with countdown"
Global $checkbox1_axis[2] = [10,160]
Global $checkbox1_default = $GUI_CHECKED
;splash
Global $splash_dim[2] = [60,40]
Global $splash_axis[2] = [@DesktopWidth-$splash_dim[0], 24]
;other settings
Global $refresh = 50
Global $z = 0
Global $default_nm[2] = [15,5]
Global $opt1[2]
Global $opt2[2]
;---------------------------------------------------------------------------------------------------------------------------------------------------------------

GuiStart()

Func GuiStart()

   GUICreate($title, $gui_dim[0], $gui_dim[1])
   $go_button = GUICtrlCreateButton($go_button_name, $go_button_axis[0], $go_button_axis[1], $go_button_dim[0], $go_button_dim[1])
   $exit_button = GUICtrlCreateButton($exit_button_name, $exit_button_axis[0], $exit_button_axis[1], $exit_button_dim[0], $exit_button_dim[1])

   $slider = GUICtrlCreateSlider($slider_axis[0], $slider_axis[1], $slider_dim[0], $slider_dim[1])
   GUICtrlSetLimit($slider, $slider_max_min[0], $slider_max_min[1])
   GUICtrlSetData($slider, $slider_default)
   
   $slider2 = GUICtrlCreateSlider($slider2_axis[0], $slider2_axis[1], $slider2_dim[0], $slider2_dim[1])
   GUICtrlSetLimit($slider2, $slider2_max_min[0], $slider2_max_min[1])
   GUICtrlSetData($slider2, $slider2_default)

   $label1 = GUICtrlCreateLabel($label1_text, $label1_axis[0], $label1_axis[1])
   $label2 = GUICtrlCreateLabel($label2_text, $label2_axis[0], $label2_axis[1])
   $label3 = GUICtrlCreateLabel($label3_text, $label3_axis[0], $label3_axis[1])
   $label4 = GUICtrlCreateLabel($label4_text, $label4_axis[0], $label4_axis[1])

   $checkbox1 = GuiCtrlCreateCheckBox($checkbox1_text,$checkbox1_axis[0],$checkbox1_axis[1])
   GUICtrlSetState($checkbox1, $checkbox1_default)

   GUISetState()

   While 1
	  GUICtrlSetData ($label1, GUICtrlRead($slider))
	  GUICtrlSetData ($label3, GUICtrlRead($slider2))
	  
	  $msg = GUIGetMsg()
		 Select
			   Case $msg = $GUI_EVENT_CLOSE
				  exit
			   Case $msg = $go_button
				  $opt1[0] = GUICtrlRead($slider)
				  $opt1[1] = GUICtrlRead($slider2)
				  $opt2 = GUICtrlRead($checkbox1)
				  go($opt1[0],$opt2)
			   Case $msg = $exit_button
				  exit
		 EndSelect
	  sleep($refresh)
   WEnd

EndFunc

Func go($sleep_time,$splash)	
	GuiDelete()

	$time = $sleep_time * 60000

	If $splash = 4 Then
			sleep($time)
			BreakTime()
		Else
			$starttime = _Timer_Init()
			SplashTextOn("SplashStatic1",$sleep_time - Int((_Timer_Diff($starttime)/60000)),$splash_dim[0], $splash_dim[1], $splash_axis[0], $splash_axis[1], 1)

			While 1
				$show_time = $sleep_time - Int((_Timer_Diff($starttime)/60000))
				$real_time = $time - _Timer_Diff($starttime)
				If $real_time < 0 then
					 SplashOff()
					 BreakTime()
				EndIf
				ControlSetText("SplashStatic1", "", "Static1", $show_time)
				sleep($refresh)
			WEnd
	EndIf
 EndFunc
 
 Func BreakTime()
	GUICreate($title2, $gui2_dim[0], $gui2_dim[1])
	
	$bw_button = GUICtrlCreateButton($bw_button_name[$z], $bw_button_axis[0], $bw_button_axis[1], $button2_dim[0], $button2_dim[1])
	$nm_button = GUICtrlCreateButton($nm_button_name[$z], $nm_button_axis[0], $nm_button_axis[1], $button2_dim[0], $button2_dim[1])
	$exit2_button = GUICtrlCreateButton($exit_button_name, $exit2_button_axis[0], $exit2_button_axis[1], $exit_button_dim[0], $exit_button_dim[1])
	$label5 = GUICtrlCreateLabel($label5_text[$z], $label5_axis[0], $label5_axis[1])
	
	GUISetState()

   While 1
	  $msg = GUIGetMsg()
		 Select
			   Case $msg = $GUI_EVENT_CLOSE
				  Exit
			   Case $msg = $bw_button
				  If $z = 0 then 
					 $z = 1 
				  Else 
					 $z = 0 
				  EndIf
				  go($opt1[$z],$opt2)
			   Case $msg = $nm_button
				  go($default_nm[$z],$opt2)
			   Case $msg = $exit2_button
				  exit
		 EndSelect
	  sleep($refresh)
   WEnd
   
EndFunc