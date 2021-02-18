; by Keither
#include <GuiConstantsEx.au3>
#Include <Timers.au3>

;---------------------------------------------------------------------------------------------------------------------------------------------------------------

Global $title = "Go2Sleep"
Global $gui_dim[2] = [300,250]
Global $button_dim[2] = [90,30]
Global $go_button_name = "GO"
Global $exit_button_name = "Exit"
Global $go_button_axis[2] = [180,140]
Global $exit_button_axis[2] = [180,190]
Global $slider_axis[2] = [10,40]
Global $slider_dim[2] = [230,40]
Global $slider_max_min[2] = [300,1]
Global $slider_default = 10
Global $label1_text = "10"
Global $label1_axis[2] = [$slider_dim[0]+20, $slider_axis[1]]
Global $label2_text = "Adjust time to take action (in minutes)"
Global $label2_axis[2] = [10,10]
Global $checkbox1_text = "Show small upper-right frame with countdown"
Global $checkbox1_axis[2] = [10,80]
Global $checkbox1_default = $GUI_CHECKED
Global $radio1_text = "Shutdown"
Global $radio2_text = "Reboot"
Global $radio3_text = "Standby"
Global $radio4_text = "Hibernate"
Global $radio_axis[2] = [10,120]
Global $radio_space = 30
Global $splash_dim[2] = [60,40]
Global $splash_axis[2] = [@DesktopWidth-$splash_dim[0], 0]
Global $mb1_title = "All set"
Global $mb1_text[2] = ["After pressing ""OK"", action will be taken in "," minute(s)"]
Global $shutdown_code[4] = [29,22,32,64]
Global $refresh = 50

;---------------------------------------------------------------------------------------------------------------------------------------------------------------

GUICreate($title, $gui_dim[0], $gui_dim[1])
$go_button = GUICtrlCreateButton($go_button_name, $go_button_axis[0], $go_button_axis[1], $button_dim[0], $button_dim[1])
$exit_button = GUICtrlCreateButton($exit_button_name, $exit_button_axis[0], $exit_button_axis[1], $button_dim[0], $button_dim[1])

$slider = GUICtrlCreateSlider($slider_axis[0], $slider_axis[1], $slider_dim[0], $slider_dim[1])
GUICtrlSetLimit($slider, $slider_max_min[0], $slider_max_min[1])
GUICtrlSetData($slider, $slider_default)

$label1 = GUICtrlCreateLabel($label1_text, $label1_axis[0], $label1_axis[1])
$label2 = GUICtrlCreateLabel($label2_text, $label2_axis[0], $label2_axis[1])

$checkbox1 = GuiCtrlCreateCheckBox($checkbox1_text,$checkbox1_axis[0],$checkbox1_axis[1])
GUICtrlSetState($checkbox1, $checkbox1_default)

$radio1 = GUICtrlCreateRadio($radio1_text, $radio_axis[0], $radio_axis[1]+0*$radio_space)
$radio2 = GUICtrlCreateRadio($radio2_text, $radio_axis[0], $radio_axis[1]+1*$radio_space)
$radio3 = GUICtrlCreateRadio($radio3_text, $radio_axis[0], $radio_axis[1]+2*$radio_space)
$radio4 = GUICtrlCreateRadio($radio4_text, $radio_axis[0], $radio_axis[1]+3*$radio_space)
GUICtrlSetState($radio1, $GUI_CHECKED)

GUISetState()

While 1
	GUICtrlSetData ($label1, GUICtrlRead($slider))
	$msg = GUIGetMsg()
		Select
            Case $msg = $GUI_EVENT_CLOSE
                ExitLoop
            Case $msg = $go_button
				go()
			Case $msg = $exit_button
				exit
		EndSelect
	sleep($refresh)
WEnd

Func go()
	$opt1 = GUICtrlRead($slider)
	$opt2 = GUICtrlRead($checkbox1)

	Select
		Case GUICtrlRead($radio1) = 1
			$opt3 = $shutdown_code[0]
		Case GUICtrlRead($radio2) = 1
			$opt3 = $shutdown_code[1]
		Case GUICtrlRead($radio3) = 1
			$opt3 = $shutdown_code[2]
		Case GUICtrlRead($radio4) = 1
			$opt3 = $shutdown_code[3]
	EndSelect

	GuiDelete()

	MsgBox(0,$mb1_title,$mb1_text[0] & $opt1 & $mb1_text[1])

	$time = $opt1 * 60000

	If $opt2 = 4 Then
			sleep($time)
			Shutdown($opt3)
		Else
			$starttime = _Timer_Init()
			SplashTextOn("SplashStatic1",$opt1 - Int((_Timer_Diff($starttime)/60000)),$splash_dim[0], $splash_dim[1], $splash_axis[0], $splash_axis[1], 1)

			While 1
				$show_time = $opt1 - Int((_Timer_Diff($starttime)/60000))
				$real_time = $time - _Timer_Diff($starttime)
				If $real_time < 0 then
					Shutdown($opt3)
				EndIf
				ControlSetText("SplashStatic1", "", "Static1", $show_time)
				sleep($refresh)
			WEnd
	EndIf
EndFunc