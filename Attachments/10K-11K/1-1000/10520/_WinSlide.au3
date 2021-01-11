; Author: DaLiMan

Func _WinSlide($wsld_Title, $wsld_X, $wsld_Y, $wsld_Step, $wsld_Time)
Dim $wsld_round, $dx, $dy, $Sleepy
$GUIpos_old = WinGetPos($wsld_Title)
$GUIpos_diff_Width = ($wsld_X - $GUIpos_old[0]) /$wsld_Step
$GUIpos_diff_Height= ($wsld_Y - $GUIpos_old[1]) /$wsld_Step
$Sleepy = $wsld_Time / $wsld_Step

For $dr = 1 To $wsld_Step
	$wsld_round = $wsld_round + 1
	$dx = ($GUIpos_diff_Width * $dr) + $GUIpos_old[0]
	$dy = ($GUIpos_diff_Height * $dr)+ $GUIpos_old[1]
	WinMove($wsld_Title, "", $dx, $dy)
	Sleep($Sleepy)
Next

EndFunc