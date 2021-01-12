#include <File.au3>
#include <Guiconstants.au3>
#include <image_get_info.au3>

Global $i_height,$i_width,$waardes,$total,$info,$image,$contrast_value,$contrast_value_end,$size
Global $procent_pixels,$pixel_atm,$value_progress,$progressbar,$progress,$progress_count,$procent
Global $bg_color,$font_color,$size_ASCII

$Main = GUICreate("Image to Text", 629, 363, 193, 115)
GUICtrlCreateGroup("Preview Image", 8, 8, 305, 345)
$Picca = GUICtrlCreatePic("", 16, 32, 225, 209)
$slider_procent = GUICtrlCreateSlider (25,256,200,20)
GUICtrlSetState(-1,$GUI_DISABLE)
$slider_procent_text = GUICtrlCreateLabel("",230,256,50,20)
$Label9 = GUICtrlCreateLabel("% of pixels", 255, 255, 50, 17)
$width_test = GUICtrlCreateLabel(" ", 36, 286, 30, 17)
$Label2 = GUICtrlCreateLabel("x", 64, 286, 9, 17)
$height_test = GUICtrlCreateLabel(" ", 80, 286, 30, 17)
$file_size = GUICtrlCreateLabel(" ", 55, 310, 30, 17)
$Label5 = GUICtrlCreateLabel("Kb", 75, 310, 17, 17)
$Label6 = GUICtrlCreateLabel("Pixels", 128, 286, 31, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$tab_text =GUICtrlCreateTab (320,8, 305,345)
$color_grayscale = GUICtrlCreateTabitem("Color / Grayscale")
$browse = GUICtrlCreateButton("&Browse", 328, 32, 121, 33, 0)
GUICtrlCreateGroup("Characters:", 328, 72, 257, 80)
$characters = GUICtrlCreateInput("Characters", 336, 92, 100, 21)
$char_size = GUICtrlCreateCombo("Smallest", 450, 92, 100, 25)
GUICtrlSetData(-1,"Small|Normal|Large|Largest","Small")
$random = GUICtrlCreateRadio("Random", 336, 120, 105, 25)
GUICtrlSetState($Random, $GUI_CHECKED)
$Sequence = GUICtrlCreateRadio("Sequence", 456, 120, 121, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("Color:", 328, 160, 257, 95)
$color = GUICtrlCreateRadio("Color", 336, 176, 97, 25)
$grayscale  = GUICtrlCreateRadio("Grayscale", 456, 176, 97, 25)
GUICtrlSetState($color, $GUI_CHECKED)
$Label7 = GUICtrlCreateLabel("Background:",336, 207, 193, 25)
$bg_color = GUICtrlCreateCombo("BLACK", 336, 225, 193, 25)
GUICtrlSetData(-1,"WHITE","BLACK")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("Contrast:", 328, 260, 257, 49)
$high = GUICtrlCreateRadio("High", 336, 276, 113, 25)
$low = GUICtrlCreateRadio("Low", 456, 276, 113, 25)
GUICtrlSetState($low, $GUI_CHECKED)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$ok_button = GUICtrlCreateButton("&Convert", 328, 312, 281, 33, 0)

$ASCII = GUICtrlCreateTabitem("ASCII")
$browse_ASCII = GUICtrlCreateButton("&Browse", 328, 32, 121, 33, 0)
GUICtrlCreateGroup("Characters Size:", 328, 72, 257, 50)
$char_size_ASCII = GUICtrlCreateCombo("Smallest", 336, 92, 100, 25)
GUICtrlSetData(-1,"Small|Normal|Large|Largest","Small")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("Font/Background color:", 328, 130, 257, 120)
$Label7_ASCII = GUICtrlCreateLabel("Font color:",336, 150, 193, 25)
$font_color_ASCII = GUICtrlCreateCombo("BLACK", 336, 168, 193, 25)
GUICtrlSetData(-1,"WHITE","WHITE")
$Label7_ASCII = GUICtrlCreateLabel("Background:",336, 197, 193, 25)
$bg_color_ASCII = GUICtrlCreateCombo("BLACK", 336, 215, 193, 25)
GUICtrlSetData(-1,"WHITE","BLACK")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$invert = GUICtrlCreateCheckbox ("Invert", 336, 260, 120, 20)
$ok_button_ASCII = GUICtrlCreateButton("&Convert", 328, 312, 281, 33, 0)
GUISetState(@SW_SHOW)

While 1
	$msg = GUIGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		Exit
	Case $msg = $browse
		$file = FileOpenDialog("test",@MyDocumentsDir,"images (*.jpg;*.gif)")
		$aInfo_test = _ImageGetInfo($file)
		GUICtrlSetData($width_test, _ImageGetParam($aInfo_test, "Width"))
		GUICtrlSetData($height_test, _ImageGetParam($aInfo_test, "Height"))
		Guictrlsetdata($file_size, int(FileGetSize($file)/1000))
		GUICtrlSetImage($picca,$file)
		GUICtrlSetState($slider_procent,$GUI_ENABLE)
		GUICtrlSetData($slider_procent,25)
	case $msg = $browse_ASCII
		$file = FileOpenDialog("test",@MyDocumentsDir,"images (*.jpg;*.gif)")
		$aInfo_test = _ImageGetInfo($file)
		GUICtrlSetData($width_test, _ImageGetParam($aInfo_test, "Width"))
		GUICtrlSetData($height_test,_ImageGetParam($aInfo_test, "Height"))
		Guictrlsetdata($file_size, int(FileGetSize($file)/1000))
		GUICtrlSetImage($picca,$file)
		GUICtrlSetState($slider_procent,$GUI_ENABLE)
		GUICtrlSetData($slider_procent,25)
	Case $msg = $ok_button
		values()
	case $msg = $ok_button_ASCII
		values_ASCII()
	EndSelect
	$read_procent = GUICtrlRead($slider_procent)
	GUICtrlSetData($slider_procent_text,$read_procent)
	Sleep(25)
WEnd

func values()
		Local $calc_total = 0
		$aInfo = _ImageGetInfo($file)
		$i_width = _ImageGetParam($aInfo, "Width")
		$i_height =  _ImageGetParam($aInfo, "Height")
		$image = GUICreate("",$i_width,$i_height,-1,-1,$WS_POPUP,$WS_EX_TOPMOST)
		GUICtrlCreatePic($file,0,0,$i_width,$i_height)
        $pr_height = WinGetPos($image)
        $progress = Guicreate("Progress",130,60,-1,$pr_height[1]-65,$WS_POPUP,$WS_EX_TOPMOST)
        GUICtrlCreateLabel("Reading:",10,10,100,20)
        $pixel_atm = GUICtrlCreateLabel("",60,10,150,20)
        GUICtrlCreateLabel("/",90,10,100,20)
        $pixel_total = GUICtrlCreateLabel("",100,10,100,20)
        $progressbar = GUICtrlCreateProgress (15,30,100,20,$PBS_SMOOTH)
        $procent = GUICtrlCreateLabel("100",50,33,30,20)
        GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
        GUICtrlCreateLabel("%",70,33,30,20)
        GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUISetState(@SW_hide,$main)
		GUISetState(@SW_Show,$image)
		GUISetState(@SW_Show,$progress)
		$waardes = GUICtrlRead($characters)
		$total = Int(StringLen($waardes))
		$info = WinGetPos($image)
		$read_procent = GUICtrlRead($slider_procent)
		$value = 100 / $read_procent
		$procent_pixels = Round($value)
		if $procent_pixels = 1 Then
			$procent_pixels = 2
		EndIf
        $pixel_total_width = GUICtrlRead($width_test)
        $pixel_total_height = GUICtrlRead($height_test)
        $calc_1 = round($pixel_total_width/($procent_pixels-1))
        $calc_2 = round($pixel_total_height/$procent_pixels)
        $calc_1_2 = $calc_1 * $calc_2
        GUICtrlSetData($pixel_total,$calc_1_2)
        $value_progress = 100/$calc_1_2
		$r_checked = GUICtrlRead($random)
		$l_checked = GuiCtrlRead($low)
		$c_checked = GUICtrlRead($color)
		$size_char = GUICtrlRead($char_size)
		Select
        case $size_char = "Smallest"
			$size = "-6"
        case $size_char = "Small"
			$size = "-3"
        case $size_char = "Normal"
			$size = "1"
        case $size_char = "Large"
			$size = "4"
        case $size_char = "Largest"
			$size = "6"
        EndSelect
		Select
        case $r_checked = $GUI_CHECKED and $l_checked = $GUI_CHECKED and $c_checked = $GUI_CHECKED
			$contrast_value = "<pre>"
			$contrast_value_end = "</pre>"
			convert_color_random()
        case $r_checked = $GUI_CHECKED and $l_checked = $GUI_UNCHECKED and $c_checked = $GUI_CHECKED
			$contrast_value = ""
			$contrast_value_end = ""
			convert_color_random()
        case $r_checked = $GUI_UNCHECKED and $l_checked = $GUI_CHECKED and $c_checked = $GUI_CHECKED
			$contrast_value = "<pre>"
			$contrast_value_end = "</pre>"
			convert_color_Sequence()
        case $r_checked = $GUI_UNCHECKED and $l_checked = $GUI_UNCHECKED and $c_checked = $GUI_CHECKED
			$contrast_value = ""
			$contrast_value_end = ""
			convert_color_Sequence()
        case $r_checked = $GUI_CHECKED and $l_checked = $GUI_CHECKED and $c_checked = $GUI_UNCHECKED
			$contrast_value = "<pre>"
			$contrast_value_end = "</pre>"
			convert_grayscale_random()
        case $r_checked = $GUI_CHECKED and $l_checked = $GUI_UNCHECKED and $c_checked = $GUI_UNCHECKED
			$contrast_value = ""
			$contrast_value_end = ""
			convert_grayscale_random()
        case $r_checked = $GUI_UNCHECKED and $l_checked = $GUI_CHECKED and $c_checked = $GUI_UNCHECKED
			$contrast_value = "<pre>"
			$contrast_value_end = "</pre>"
			convert_grayscale_Sequence()
        case $r_checked = $GUI_UNCHECKED and $l_checked = $GUI_UNCHECKED and $c_checked = $GUI_UNCHECKED
			$contrast_value = ""
			$contrast_value_end = ""
			convert_grayscale_Sequence()
       EndSelect
EndFunc
   
Func values_ASCII()
		Local $calc_total = 0
		$aInfo = _ImageGetInfo($file)
		$i_width = _ImageGetParam($aInfo, "Width")
		$i_height =  _ImageGetParam($aInfo, "Height")
		$image = GUICreate("",$i_width,$i_height,-1,-1,$WS_POPUP,$WS_EX_TOPMOST)
		GUICtrlCreatePic($file,0,0,$i_width,$i_height)
        $pr_height = WinGetPos($image)
        $progress = Guicreate("Progress",130,60,-1,$pr_height[1]-65,$WS_POPUP,$WS_EX_TOPMOST)
        GUICtrlCreateLabel("Reading:",10,10,100,20)
        $pixel_atm = GUICtrlCreateLabel("",60,10,150,20)
        GUICtrlCreateLabel("/",90,10,100,20)
        $pixel_total = GUICtrlCreateLabel("",100,10,100,20)
        $progressbar = GUICtrlCreateProgress (15,30,100,20,$PBS_SMOOTH)
        $procent = GUICtrlCreateLabel("100",50,33,30,20)
        GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
        GUICtrlCreateLabel("%",70,33,30,20)
        GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUISetState(@SW_hide,$main)
		GUISetState(@SW_Show,$image)
		GUISetState(@SW_Show,$progress)
		$pixel_total_width = GUICtrlRead($width_test)
        $pixel_total_height = GUICtrlRead($height_test)
        $calc_1 = round($pixel_total_width/($procent_pixels-1))
        $calc_2 = round($pixel_total_height/$procent_pixels)
        $calc_1_2 = $calc_1 * $calc_2
        GUICtrlSetData($pixel_total,$calc_1_2)
        $value_progress = 100/$calc_1_2
		$info = WinGetPos($image)
		$read_procent = GUICtrlRead($slider_procent)
		$value = 100 / $read_procent
		$procent_pixels = Round($value)
		if $procent_pixels = 1 Then
			$procent_pixels = 2
		EndIf
        $pixel_total_width = GUICtrlRead($width_test)
        $pixel_total_height = GUICtrlRead($height_test)
        $calc_1 = round($pixel_total_width/($procent_pixels-1))
        $calc_2 = round($pixel_total_height/$procent_pixels)
        $calc_1_2 = $calc_1 * $calc_2
        GUICtrlSetData($pixel_total,$calc_1_2)
        $value_progress = 100/$calc_1_2
		$font_color = GUICtrlRead($font_color_ASCII)
		$bg_color = GUICtrlRead($bg_color_ASCII)
		$size_char = GUICtrlRead($char_size_ASCII)
	Select
        case $size_char = "Smallest"
			$size_ASCII = "-6"
        case $size_char = "Small"
			$size_ASCII = "-3"
        case $size_char = "Normal"
			$size_ASCII = "1"
        case $size_char = "Large"
			$size_ASCII = "4"
        case $size_char = "Largest"
			$size_ASCII = "6"
	EndSelect
	if GUICtrlRead($invert) = 1 Then
		convert_ASCII_invert()
	Else
		convert_ASCII()
	EndIf
EndFunc   
   
Func convert_color_random()
       Local $pixel
       $begin = TimerInit()
       FileDelete(@ScriptDir & "\html.htm")
       FileWrite(@ScriptDir & "\html.htm","<html>" & @crlf)
       FileWrite(@ScriptDir & "\html.htm","<body>" & @crlf & '<table width="70%"><tr><td> <table align="center" cellpadding="10"> <tr bgcolor="' & GUICtrlRead($bg_color) & '"> <td> <font size="' & $size & '">' & $contrast_value & @crlf)
       For $i = 1 to $i_height step +$procent_pixels
               For $x = 1 to $i_width step +($procent_pixels-1)
                    $color = PixelGetColor($info[0] + $x , $info[1] + $i)
                    $char = Random(1,$total+1)
                    FileWrite(@ScriptDir & "\html.htm",'<font color="#' & Hex($color,6) & '">' & StringMid($waardes,$char,1) & "</font>")
                    $pixel = $pixel + 1
                    GUICtrlSetData($pixel_atm,$pixel)
                    $progress_count = $progress_count + $value_progress
                    $progress_count_rounded = Round($progress_count)
                    GUICtrlSetData($progressbar,$progress_count_rounded)
                    GUICtrlSetData($procent,$progress_count_rounded)
               Next
               FileWrite(@ScriptDir & "\html.htm","<br>")
       Next
       GUISetState(@SW_HIDE,$image)
       FileWrite(@ScriptDir & "\html.htm",$contrast_value_end & @crlf & "</font>" & @crlf & "</td></tr></table></td></tr></table>" & @crlf)
       $dif = TimerDiff($begin)
       Filewrite(@scriptdir & "\html.htm", @crlf & '<font face="arial"> Time took to convert: <b>' & int($dif/1000) & "</b> sec.</font>" & @crlf & "</body>" & @crlf & "</html>")
       ShellExecute(@ScriptDir & "\html.htm", "", @ScriptDir, "open")
       GUISetState(@SW_HIDE,$progress)
       Exit
EndFunc

Func convert_color_Sequence()
       Local $pixel
       $begin = TimerInit()
       FileDelete(@ScriptDir & "\html.htm")
       FileWrite(@ScriptDir & "\html.htm","<html>" & @crlf)
       FileWrite(@ScriptDir & "\html.htm","<body>" & @crlf & '<table width="70%"><tr><td> <table align="center" cellpadding="10"> <tr bgcolor="' & GUICtrlRead($bg_color) & '"> <td> <font size="' & $size & '">' & $contrast_value & @crlf)
       For $i = 1 to $i_height step +$procent_pixels
               For $x = 1 to $i_width step +($procent_pixels-1)
                    $color = PixelGetColor($info[0] + $x , $info[1] + $i)
                    $show = $waardes
                    FileWrite(@ScriptDir & "\html.htm",'<font color="#' & $color & '">' & $show & "</font>")
                    $pixel = $pixel + 1
                    GUICtrlSetData($pixel_atm,$pixel)
                    $progress_count = $progress_count + $value_progress
                    $progress_count_rounded = Round($progress_count)
                    GUICtrlSetData($progressbar,$progress_count_rounded)
                    GUICtrlSetData($procent,$progress_count_rounded)
               Next
        FileWrite(@ScriptDir & "\html.htm","<br>")
       Next
       GUISetState(@SW_HIDE,$image)
       FileWrite(@ScriptDir & "\html.htm", $contrast_value_end & @crlf & "</font>" & @crlf & "</td></tr></table></td></tr></table>" & @crlf)
       $dif = TimerDiff($begin)
       Filewrite(@scriptdir & "\html.htm", @crlf & '<font face="arial"> Time took to convert: <b>' & int($dif/1000) & "</b> sec.</font>" & @crlf & "</body>" & @crlf & "</html>")
       ShellExecute(@ScriptDir & "\html.htm", "", @ScriptDir, "open")
       GUISetState(@SW_HIDE,$progress)
       Exit
   EndFunc
   
Func convert_grayscale_random()
       Local $pixel
       $begin = TimerInit()
       FileDelete(@ScriptDir & "\html.htm")
       FileWrite(@ScriptDir & "\html.htm","<html>" & @crlf)
       FileWrite(@ScriptDir & "\html.htm","<body>" & @crlf & '<table width="70%"><tr><td> <table align="center" cellpadding="10"> <tr bgcolor="' & GUICtrlRead($bg_color) & '"> <td> <font size="' & $size & '">' & $contrast_value & @crlf)
       For $i = 1 to $i_height step +$procent_pixels
               For $x = 1 to $i_width step +($procent_pixels-1)
                    $color = PixelGetColor($info[0] + $x , $info[1] + $i)
                    $char = Random(1,$total+1)
                    $var = Hex($color, 6)
                    $gray_1 = int(dec(StringLeft($var,2))*0.3)
                    $gray_2 = int(dec(StringMid($var,3,2))*0.59)
                    $gray_3 = int(dec(StringRight($var,2))*0.11)
                    $grayscale = StringSplit(hex($gray_1 + $gray_2 + $gray_3),"000000",1)
                    FileWrite(@ScriptDir & "\html.htm",'<font color="#' & $grayscale[2] & $grayscale[2] & $grayscale[2] & '">' & StringMid($waardes,$char,1) & "</font>")
                    $pixel = $pixel + 1
                    GUICtrlSetData($pixel_atm,$pixel)
                    $progress_count = $progress_count + $value_progress
                    $progress_count_rounded = Round($progress_count)
                    GUICtrlSetData($progressbar,$progress_count_rounded)
                    GUICtrlSetData($procent,$progress_count_rounded)
               Next
        FileWrite(@ScriptDir & "\html.htm","<br>")
       Next
       GUISetState(@SW_HIDE,$image)
       FileWrite(@ScriptDir & "\html.htm", $contrast_value_end & @crlf & "</font>" & @crlf & "</td></tr></table></td></tr></table>" & @CRLF)
       $dif = TimerDiff($begin)
       Filewrite(@scriptdir & "\html.htm", @crlf & '<font face="arial"> Time took to convert: <b>' & int($dif/1000) & "</b> sec.</font>" & @crlf & "</body>" & @crlf & "</html>")
       ShellExecute(@ScriptDir & "\html.htm", "", @ScriptDir, "open")
       GUISetState(@SW_HIDE,$progress)
       Exit
   EndFunc
   
Func convert_grayscale_Sequence()
       Local $pixel
       $begin = TimerInit()
       FileDelete(@ScriptDir & "\html.htm")
       FileWrite(@ScriptDir & "\html.htm","<html>" & @crlf)
       FileWrite(@ScriptDir & "\html.htm","<body>" & @crlf & '<table width="70%"><tr><td> <table align="center" cellpadding="10"> <tr bgcolor="' & GUICtrlRead($bg_color) & '"> <td> <font size="' & $size & '">' & $contrast_value & @crlf)
       For $i = 1 to $i_height step +$procent_pixels
               For $x = 1 to $i_width step +($procent_pixels-1)
                    $color = PixelGetColor($info[0] + $x , $info[1] + $i)
                    $show = $waardes
                    $var = Hex($color, 6)
                    $gray_1 = int(dec(StringLeft($var,2))*0.3)
                    $gray_2 = int(dec(StringMid($var,3,2))*0.59)
                    $gray_3 = int(dec(StringRight($var,2))*0.11)
                    $grayscale = StringSplit(hex($gray_1 + $gray_2 + $gray_3),"000000",1)
                    FileWrite(@ScriptDir & "\html.htm",'<font color="#' & $grayscale[2] & $grayscale[2] & $grayscale[2] & '">' & $show & "</font>")
                    $pixel = $pixel + 1
                    GUICtrlSetData($pixel_atm,$pixel)
                    $progress_count = $progress_count + $value_progress
                    $progress_count_rounded = Round($progress_count)
                    GUICtrlSetData($progressbar,$progress_count_rounded)
                    GUICtrlSetData($procent,$progress_count_rounded)
               Next
        FileWrite(@ScriptDir & "\html.htm","<br>")
       Next
       GUISetState(@SW_HIDE,$image)
       FileWrite(@ScriptDir & "\html.htm", $contrast_value_end & @crlf & "</font>" & @crlf & "</td></tr></table></td></tr></table>" & @crlf)
       $dif = TimerDiff($begin)
       Filewrite(@scriptdir & "\html.htm", @crlf & '<font face="arial"> Time took to convert: <b>' & int($dif/1000) & "</b> sec.</font>" & @crlf & "</body>" & @crlf & "</html>")
       ShellExecute(@ScriptDir & "\html.htm", "", @ScriptDir, "open")
       GUISetState(@SW_HIDE,$progress)
       Exit
EndFunc

func convert_ASCII()
	   Local $pixel
       $begin = TimerInit()
       Dim $replace_characters[17]
       $replace_characters[0] = "#"
       $replace_characters[1] = "W"
       $replace_characters[2] = "M"
       $replace_characters[3] = "B"
       $replace_characters[4] = "R"
       $replace_characters[5] = "X"
       $replace_characters[6] = "V"
       $replace_characters[7] = "Y"
       $replace_characters[8] = "I"
       $replace_characters[9] = "t"
       $replace_characters[10] = "i"
       $replace_characters[11] = "+"
       $replace_characters[12] = "="
       $replace_characters[13] = ";"
       $replace_characters[14] = ":"
       $replace_characters[15] = ","
       $replace_characters[16] = "."
      FileDelete(@ScriptDir & "\html.htm")
      FileWrite(@ScriptDir & "\html.htm","<html>" & @crlf)
      FileWrite(@ScriptDir & "\html.htm","<body>" & @crlf &'<table width="80%"><tr><td> <table align="center" cellpadding="10" > <tr bgcolor="' & $bg_color & '"> <td> <font color="' & $font_color & '" size="' & $size_ASCII & '"><pre>' &@crlf)
      For $i = 1 to $i_height step +$procent_pixels
              For $x = 1 to $i_width step +($procent_pixels-1)
                    $color = PixelGetColor($info[0] + $x , $info[1] +$i)
                    $var = Hex($color, 6)
                    $gray_1 = dec(StringLeft($var,2))
					$gray_2 = dec(StringMid($var,3,2))
                    $gray_3 = dec(StringRight($var,2))
                    $brightness = $gray_1+$gray_2+$gray_3
                    $replace_character_id = Round($brightness/50) +1
                    FileWrite(@ScriptDir & "\html.htm",$replace_characters[$replace_character_id])
					$pixel = $pixel + 1
                    GUICtrlSetData($pixel_atm,$pixel)
                    $progress_count = $progress_count + $value_progress
                    $progress_count_rounded = Round($progress_count)
                    GUICtrlSetData($progressbar,$progress_count_rounded)
                    GUICtrlSetData($procent,$progress_count_rounded)
              Next
       FileWrite(@ScriptDir & "\html.htm",@CRLF)
      Next
      GUISetState(@SW_HIDE,$image)
	  FileWrite(@ScriptDir & "\html.htm", "</pre></font>" & @crlf & "</td></tr></table></td></tr></table>" & @crlf)
	  $dif = TimerDiff($begin)
	  Filewrite(@scriptdir & "\html.htm", @crlf & '<font face="arial"> Time took to convert: <b>' & int($dif/1000) & "</b> sec.</font>" & @crlf & "</body>" & @crlf & "</html>")
      ShellExecute(@ScriptDir & "\html.htm", "", @ScriptDir, "open")
	  Exit
EndFunc
  
func convert_ASCII_invert()
	   Local $pixel
       $begin = TimerInit()
       Dim $replace_characters[17]
       $replace_characters[0] = "."
       $replace_characters[1] = ","
       $replace_characters[2] = ":"
       $replace_characters[3] = ";"
       $replace_characters[4] = "="
       $replace_characters[5] = "+"
       $replace_characters[6] = "i"
       $replace_characters[7] = "t"
       $replace_characters[8] = "I"
       $replace_characters[9] = "Y"
       $replace_characters[10] = "V"
       $replace_characters[11] = "X"
       $replace_characters[12] = "R"
       $replace_characters[13] = "B"
       $replace_characters[14] = "M"
       $replace_characters[15] = "W"
       $replace_characters[16] = "#"
      FileDelete(@ScriptDir & "\html.htm")
      FileWrite(@ScriptDir & "\html.htm","<html>" & @crlf)
      FileWrite(@ScriptDir & "\html.htm","<body>" & @crlf &'<table width="80%"><tr><td> <table align="center" cellpadding="10" > <tr bgcolor="' & $bg_color & '"> <td> <font color="' & $font_color & '" size="' & $size_ASCII & '"><pre>' &@crlf)
      For $i = 1 to $i_height step +$procent_pixels
              For $x = 1 to $i_width step +($procent_pixels-1)
                    $color = PixelGetColor($info[0] + $x , $info[1] +$i)
                    $var = Hex($color, 6)
                    $gray_1 = dec(StringLeft($var,2))
					$gray_2 = dec(StringMid($var,3,2))
                    $gray_3 = dec(StringRight($var,2))
                    $brightness = $gray_1+$gray_2+$gray_3
                    $replace_character_id = Round($brightness/50) +1
                    FileWrite(@ScriptDir & "\html.htm",$replace_characters[$replace_character_id])
					$pixel = $pixel + 1
                    GUICtrlSetData($pixel_atm,$pixel)
                    $progress_count = $progress_count + $value_progress
                    $progress_count_rounded = Round($progress_count)
                    GUICtrlSetData($progressbar,$progress_count_rounded)
                    GUICtrlSetData($procent,$progress_count_rounded)
              Next
       FileWrite(@ScriptDir & "\html.htm",@CRLF)
      Next
      GUISetState(@SW_HIDE,$image)
	  FileWrite(@ScriptDir & "\html.htm", "</pre></font>" & @crlf & "</td></tr></table></td></tr></table>" & @crlf)
	  $dif = TimerDiff($begin)
	  Filewrite(@scriptdir & "\html.htm", @crlf & '<font face="arial"> Time took to convert: <b>' & int($dif/1000) & "</b> sec.</font>" & @crlf & "</body>" & @crlf & "</html>")
      ShellExecute(@ScriptDir & "\html.htm", "", @ScriptDir, "open")
	  Exit
EndFunc