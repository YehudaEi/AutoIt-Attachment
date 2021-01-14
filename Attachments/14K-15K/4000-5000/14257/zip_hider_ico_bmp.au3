#include <guiconstants.au3>
guicreate("zip hider in ico and bmp files and extracter")
guictrlcreatelabel("Input the path to ico or bmp file",0,0)
$ico = guictrlcreateinput("",0,20,406)
guictrlcreatelabel("input the path to zip file",0,40)
guictrlcreatelabel("(or put in the location the zip file should be extracted to. make sure it's the full path",0,60)
guictrlcreatelabel("not just a path to a folder)",0,80)
$zip = guictrlcreateinput("",0,100,406)
guictrlcreatelabel("please select hiding or extracting method",0,120)
$dropdown = GUICtrlCreateCombo("put the zip archive in the ico or bmp file",0,140,406)
guictrlsetdata($dropdown,"extract the zip archive from the ico or bmp file")
$go = guictrlcreatebutton("Go!",0,170)
guisetstate()
while 1
	$msg = GUIGetMsg()
	Select
		case $msg = $go
			$cm = guictrlread($dropdown)
			if $dropdown = "put the zip archive in the ico file" Then
				$icof = guictrlread($ico)
				$zipf = guictrlread($zip)
				$icofc = fileread($icof) & fileread($zipf)
				filewrite($icof & "_converted.ico",$icofc)
				msgbox(0,"done","you may now find your ico with zip inside file at: " & $icof & "_converted.ico")
			Else
				$icof = guictrlread($ico)
				$zipf = guictrlread($zip)
				$icoss = stringsplit($icof,"PK")
				$zipe = stringreplace($icof,$icoss[1],"")
				filewrite($zipf,$zipe)
				msgbox(0,"done","you can now find the extracted zip file at: " & $zipf)
			EndIf
		case $msg = $GUI_EVENT_CLOSE
			Exit
	EndSelect
WEnd