; AutoIT GUI Designer V0.1 23 nov 2006
; written by Colin Bakewell (colba) col_bb@hotmail.co.uk
; code provided as is - your free to use it however you want
; please post any suggestions for improvements or comments on the forum (or email me)
; I will add additional features as I need them or have the time.
;
; To use :
;   Click on a button in the AGD ToolBox for the type of control you want and a control will be added to the AutoIt GUI Designer window
;   The control can then be moved or resized (click near an edge of the control)
;	To save the layout click on the Save button
;	To load a previously saved layout click on the Load Button
;	Clicking on the Gen Code button save an AutoIT .au3 file with the code  to recreate the GUI you have designed 
;	This 'template' contain the message handling for each control and calls a stub function where you can add your code
;
#include <GUIConstants.au3>
dim $tbtn[100]
dim $tbtntype[100]
dim $btn[20]
dim $btnt[20]
$btn[0] = 0
$btnt = StringSplit("Button|Input|CheckBox|Combo|Label|Radio|Slider|Edit|Graphic|List|Progress","|")

$tbw = GUICreate("AGD ToolBox",150,300,(@DesktopWidth/2) -312,(@DesktopHeight / 2) - 166,$WS_DLGFRAME)
GUISetState (@SW_SHOW)
$mw = GUICreate("AutoIT GUI Designer",300,300,-1,-1,$WS_SIZEBOX,-1,$tbw)
GUISetState (@SW_SHOW)
GUISwitch($tbw)
for $i= 1 to $btnt[0]
	$btn[$i] = GUICtrlCreateButton($btnt[$i],5,5 + (22 *($i-1)),60,20,$BS_CENTER)
next
$genbtn = GUICtrlCreateButton("Gen Code",5,255,60,20,$BS_CENTER)
$savebtn = GUICtrlCreateButton("Save",75,255,60,20,$BS_CENTER)
$loadbtn = GUICtrlCreateButton("Load",75,235,60,20,$BS_CENTER)
$htbw = GUICtrlGetHandle($tbw)
$hmw = GUICtrlGetHandle($mw)
$ctl = 0
$cbi = 0
$tbtn[0] = 0
$tbtntype[0] = ""
$rsz = 0
$ctli = 0
While 1
	$mar = GUIGetCursorInfo($hmw)
	$frst = 1
	while $mar[2] = 1 
		if $frst = 1 then
			for $i = 0 to $cbi - 1		
				if $mar[4] = $tbtn[$i] then 
					$ctl = $tbtn[$i]
					$hctl = GUICtrlGetHandle($ctl)
					$ctli = $i
				endif
			next
		EndIf
		  	if $ctl <>0 then 
				if $frst = 1 Then
					$mar2 = ControlGetPos("","",$ctl)
					if @error = 1 Then
						$rsz = 1024
					else
						$frst = 0
						$osx = $mar[0] - $mar2[0]
						$osy = $mar[1] - $mar2[1]
						$osx2 = $mar[0] - $mar2[0] - $mar2[2]
						$osy2 = $mar[1] - $mar2[1] - $mar2[3]
						$rsz = 0
						$rsz = bitor( ($osx < 4) , ($osy < 4) *2 , ($osx2 > -4) *4 , ($osy2 > -4 ) * 8)
					endif
				EndIf
				if $rsz = 0 then
					GUICtrlSetPos($ctl,$mar[0]-$osx,$mar[1]-$osy)
				Else
					$mar2 = ControlGetPos("","",$ctl)
			        if bitand($rsz,1) Then
						$mar2 = ControlGetPos("","",$ctl)
						$ddx = $mar[0] - $mar2[0]
						GUICtrlSetPos($ctl,$mar[0],$mar2[1],$mar2[2] - $ddx,$mar2[3])
					endif
			        if bitand($rsz,2) Then
						$mar2 = ControlGetPos("","",$ctl)
						$ddy = $mar[1] - $mar2[1]
						GUICtrlSetPos($ctl,$mar2[0],$mar[1],$mar2[2],$mar2[3]-$ddy)

					endif
			        if bitand($rsz,4) Then
						$mar2 = ControlGetPos("","",$ctl)
						$ddx = $mar[0] - $mar2[0] - $mar2[2]
						GUICtrlSetPos($ctl,$mar2[0],$mar2[1],$mar2[2] + $ddx,$mar2[3])
					endif
			        if bitand($rsz,8) Then
						$mar2 = ControlGetPos("","",$ctl)
						$ddy = $mar[1] - $mar2[1] - $mar2[3]
						GUICtrlSetPos($ctl,$mar2[0],$mar2[1],$mar2[2],$mar2[3] + $ddy)
					endif
				endif
			endif
			sleep(10)
			$mar = GUIGetCursorInfo($hmw)
	WEnd
		$ctl = 0
    $msg = GUIGetMsg()
	if $msg = $genbtn then savecode()
	if $msg = $savebtn then savelayout()
	if $msg = $loadbtn then loadlayout()
	If $msg = $GUI_EVENT_CLOSE Then ExitLoop
	If $msg = $GUI_EVENT_DROPPED Then MsgBox(0,"Drop",@GUI_DRAGID&" "&@GUI_DRAGFILE&" "&@GUI_DROPID)
	for $cti = 1 to $btnt[0]
		if $msg = $btn[$cti] then
			GUISwitch($mw)
			$ccok = 1
			switch $btnt[$cti]
				case "Button"
					$tbtn[$cbi] = GUICtrlCreateButton($btnt[$cti],5,5,50,20,$BS_CENTER)
				case "Input"
					$tbtn[$cbi] = GUICtrlCreateInput($btnt[$cti],5,5,100,20)
				case "CheckBox"
					$tbtn[$cbi] = GUICtrlCreateCheckbox($btnt[$cti],5,5,100,20)
				case "Combo"
					$tbtn[$cbi] = GUICtrlCreateCombo($btnt[$cti],5,5,150,20)					
				case "Label"
					$tbtn[$cbi] = GUICtrlCreateLabel($btnt[$cti],5,5,80,20,bitor($SS_NOTIFY,$SS_SIMPLE,$SS_SUNKEN))					
				case "Radio"
					$tbtn[$cbi] = GUICtrlCreateRadio($btnt[$cti],5,5,80,20)					
				case "Slider"
					$tbtn[$cbi] = GUICtrlCreateSlider(5,5,50,20)					
				case "Edit"
					$tbtn[$cbi] = GUICtrlCreateEdit($btnt[$cti],5,5,150,120)					
				case "Graphic"
					$tbtn[$cbi] = GUICtrlCreateGraphic(5,5,100,100,bitor(0,$SS_BLACKRECT) )					
				case "List"
					$tbtn[$cbi] = GUICtrlCreateList($btnt[$cti],5,5,50,80)					
				case "Progress"
					$tbtn[$cbi] = GUICtrlCreateProgress(5,5,150,20)					

				case Else
					$ccok = 0
			EndSwitch
			if $ccok =1 then
				$tbtntype[$cbi] = $btnt[$cti]
				GUICtrlSetResizing($tbtn[$cbi],$GUI_DOCKALL)		
				$cbi +=1
			EndIf
		endif
	next
Wend
GUIDelete($tbw)
GUIDelete($mw)

func savecode()
$MyDocsFolder = "::{450D8FBA-AD25-11D0-98A8-0800361B1103}"
$var = FileSaveDialog( "Choose a name.", $MyDocsFolder, "Scripts (*.aut;*.au3)", 2)
If @error Then
    MsgBox(4096,"","Save cancelled.")
Else
    ;   Save all the controls as code
	GUISwitch($mw)
	$sfile = FileOpen($var,2)
	$cs_mwp = WinGetPos("AutoIT GUI Designer")
	$cs_twp = WinGetPos("AGD ToolBox")
	$xwof = $cs_mwp[0] - $cs_twp[0]
	$ywof = $cs_mwp[1] - $cs_twp[1]
	
	FileWriteLine($sfile,";Created by AutoIt GUI Designer (c) CBakewell on "&@MDAY&"-"&@MON&"/"&@YEAR&" "&@HOUR&":"&@MIN&":"&@SEC&" by "&@UserName)
	FileWriteLine($sfile,"#include <GUIConstants.au3>")
	$cline = "$agd_mainwin = GUICreate(""Main"","&$cs_mwp[2]&","&$cs_mwp[3]&","&$cs_mwp[0]&","&$cs_mwp[1]&")"
	FileWriteLine($sfile,$cline)
	FileWriteLine($sfile,"GUISetState (@SW_SHOW)")
; Create Controls
	for $cti = 0 to $cbi -1
		    $ctl = $tbtn[$cti]
			$hctl = GUICtrlGetHandle($ctl)
			GUISwitch($mw)
			$cs_mar2 = ControlGetPos("","",$hctl)
			$cs_mar2[0] = $cs_mar2[0] - $xwof 
			$cs_mar2[1] = $cs_mar2[1] - $ywof 
			switch $tbtntype[$cti]
				case "Button"
					$cline = "$agd_"&$tbtntype[$cti]&"_"&$cti&" = GUICtrlCreateButton("""&$tbtntype[$cti]&$cti&""","&$cs_mar2[0]&","&$cs_mar2[1]&","&$cs_mar2[2]&","&$cs_mar2[3]&",$BS_CENTER)"
				case "Input"
					$cline = "$agd_"&$tbtntype[$cti]&"_"&$cti&" = GUICtrlCreateInput("""&$tbtntype[$cti]&$cti&""","&$cs_mar2[0]&","&$cs_mar2[1]&","&$cs_mar2[2]&","&$cs_mar2[3]&")"
				case "CheckBox"
					$cline = "$agd_"&$tbtntype[$cti]&"_"&$cti&" = GUICtrlCreateCheckbox("""&$tbtntype[$cti]&$cti&""","&$cs_mar2[0]&","&$cs_mar2[1]&","&$cs_mar2[2]&","&$cs_mar2[3]&")"
				case "Combo"
					$cline = "$agd_"&$tbtntype[$cti]&"_"&$cti&" = GUICtrlCreateCombo("""&$tbtntype[$cti]&$cti&""","&$cs_mar2[0]&","&$cs_mar2[1]&","&$cs_mar2[2]&","&$cs_mar2[3]&")"					
				case "Label"
					$cline = "$agd_"&$tbtntype[$cti]&"_"&$cti&" = GUICtrlCreateLabel("""&$tbtntype[$cti]&$cti&""","&$cs_mar2[0]&","&$cs_mar2[1]&","&$cs_mar2[2]&","&$cs_mar2[3]&",bitor($SS_NOTIFY,$SS_SIMPLE))"					
				case "Radio"
					$cline = "$agd_"&$tbtntype[$cti]&"_"&$cti&" = GUICtrlCreateRadio("""&$tbtntype[$cti]&$cti&""","&$cs_mar2[0]&","&$cs_mar2[1]&","&$cs_mar2[2]&","&$cs_mar2[3]&")"					
				case "Slider"
					$cline = "$agd_"&$tbtntype[$cti]&"_"&$cti&" = GUICtrlCreateSlider("&$cs_mar2[0]&","&$cs_mar2[1]&","&$cs_mar2[2]&","&$cs_mar2[3]&")"					
				case "Edit"
					$cline = "$agd_"&$tbtntype[$cti]&"_"&$cti&" = GUICtrlCreateEdit("""&$tbtntype[$cti]&$cti&""","&$cs_mar2[0]&","&$cs_mar2[1]&","&$cs_mar2[2]&","&$cs_mar2[3]&")"					
				case "Graphic"
					$cline = "$agd_"&$tbtntype[$cti]&"_"&$cti&" = GUICtrlCreateGraphic("&$cs_mar2[0]&","&$cs_mar2[1]&","&$cs_mar2[2]&","&$cs_mar2[3]&",bitor(0,$SS_BLACKRECT) )"					
				case "List"
					$cline = "$agd_"&$tbtntype[$cti]&"_"&$cti&" = GUICtrlCreateList("""&$tbtntype[$cti]&$cti&""","&$cs_mar2[0]&","&$cs_mar2[1]&","&$cs_mar2[2]&","&$cs_mar2[3]&")"					
				case "Progress"
					$cline = "$agd_"&$tbtntype[$cti]&"_"&$cti&" = GUICtrlCreateProgress("&$cs_mar2[0]&","&$cs_mar2[1]&","&$cs_mar2[2]&","&$cs_mar2[3]&")"					
			EndSwitch
			FileWriteLine($sfile,$cline)
	Next
	FileWriteLine($sfile,"while 1")
	FileWriteLine($sfile,"	$msg = GUIGetMsg()")
	FileWriteLine($sfile,"	switch $msg")
	FileWriteLine($sfile,"		case $GUI_EVENT_CLOSE")
	FileWriteLine($sfile,"			ExitLoop")
	for $cti = 0 to $cbi -1
			FileWriteLine($sfile,"		case $agd_"&$tbtntype[$cti]&"_"&$cti)
			FileWriteLine($sfile,"			action_agd_"&$tbtntype[$cti]&"_"&$cti&"()")
	Next
	FileWriteLine($sfile,"	endswitch")
	FileWriteLine($sfile,"wend")
	for $cti = 0 to $cbi -1
			FileWriteLine($sfile,"func action_agd_"&$tbtntype[$cti]&"_"&$cti&"()")
			FileWriteLine($sfile,"	; put your handler code here for this control")
			FileWriteLine($sfile,"endfunc")
	Next

	FileClose($sfile)
EndIf

	
	
EndFunc



func savelayout()
$MyDocsFolder = "::{450D8FBA-AD25-11D0-98A8-0800361B1103}"
$savefn = FileSaveDialog( "Choose a name.", $MyDocsFolder, "AGD Layouts (*.agd)", 2)
If @error Then
    MsgBox(4096,"","Save cancelled.")
Else
	GUISwitch($mw)
	$cs_mwp = WinGetPos("AutoIT GUI Designer")
	$cs_twp = WinGetPos("AGD ToolBox")
	$xwof = $cs_mwp[0] - $cs_twp[0]
	$ywof = $cs_mwp[1] - $cs_twp[1]
    IniWrite($savefn,"MAIN","Left",$cs_mwp[0])
    IniWrite($savefn,"MAIN","Top",$cs_mwp[1])
    IniWrite($savefn,"MAIN","Width",$cs_mwp[2])
    IniWrite($savefn,"MAIN","Height",$cs_mwp[3])
    IniWrite($savefn,"MAIN","XWOF",$xwof)
    IniWrite($savefn,"MAIN","YWOF",$ywof)
    IniWrite($savefn,"MAIN","CCNT",$cbi)
	for $cti = 0 to $cbi -1
		    $ctl = $tbtn[$cti]
			$hctl = GUICtrlGetHandle($ctl)
			GUISwitch($mw)
			$cs_mar2 = ControlGetPos("","",$hctl)
			$cs_mar2[0] = $cs_mar2[0] - $xwof 
			$cs_mar2[1] = $cs_mar2[1] - $ywof 
			IniWrite($savefn,"CTRL"&$cti,"Type",$tbtntype[$cti])
			IniWrite($savefn,"CTRL"&$cti,"Left",$cs_mar2[0])
			IniWrite($savefn,"CTRL"&$cti,"Top",$cs_mar2[1])
			IniWrite($savefn,"CTRL"&$cti,"Width",$cs_mar2[2])
			IniWrite($savefn,"CTRL"&$cti,"Height",$cs_mar2[3])
	Next

EndIf
EndFunc

func loadlayout()
$MyDocsFolder = "::{450D8FBA-AD25-11D0-98A8-0800361B1103}"
$savefn = FileOpenDialog( "Choose a name.", $MyDocsFolder, "AGD Layouts (*.agd)", 2)
If @error Then
    MsgBox(4096,"","Save cancelled.")
Else
    $cs_mwpx = IniRead($savefn,"MAIN","Left",-1)
    $cs_mwpy = IniRead($savefn,"MAIN","Top",-1)
    $cs_mwpw = IniRead($savefn,"MAIN","Width",200)
    $cs_mwph = IniRead($savefn,"MAIN","Height",200)
    $xwof = IniRead($savefn,"MAIN","XWOF",0)
    $ywof = IniRead($savefn,"MAIN","YWOF",0)
    $cbi = IniRead($savefn,"MAIN","CCNT",0)
	$cs_twp = WinGetPos("AGD ToolBox")
	$xwof = $cs_mwpx - $cs_twp[0]
	$ywof = $cs_mwpy - $cs_twp[1]
	GUIDelete($mw)
	$mw = GUICreate("AutoIT GUI Designer",$cs_mwpw,$cs_mwph,$cs_mwpx,$cs_mwpy,$WS_SIZEBOX,-1,$tbw)	
	GUISetState (@SW_SHOW)
	for $cti = 0 to $cbi -1
			$tbtntype[$cti] = IniRead($savefn,"CTRL"&$cti,"Type","Button")
			$cs_mar2x = IniRead($savefn,"CTRL"&$cti,"Left",5)
			$cs_mar2y = IniRead($savefn,"CTRL"&$cti,"Top",5)
			$cs_mar2w = IniRead($savefn,"CTRL"&$cti,"Width",50)
			$cs_mar2h = IniRead($savefn,"CTRL"&$cti,"Height",20)
			GUISwitch($mw)
			$ccok = 1
			switch $tbtntype[$cti]
				case "Button"
					$tbtn[$cti] = GUICtrlCreateButton($tbtntype[$cti],$cs_mar2x,$cs_mar2y,$cs_mar2w,$cs_mar2h,$BS_CENTER)
				case "Input"
					$tbtn[$cti] = GUICtrlCreateInput($tbtntype[$cti],$cs_mar2x,$cs_mar2y,$cs_mar2w,$cs_mar2h)
				case "CheckBox"
					$tbtn[$cti] = GUICtrlCreateCheckbox($tbtntype[$cti],$cs_mar2x,$cs_mar2y,$cs_mar2w,$cs_mar2h)
				case "Combo"
					$tbtn[$cti] = GUICtrlCreateCombo($tbtntype[$cti],$cs_mar2x,$cs_mar2y,$cs_mar2w,$cs_mar2h)					
				case "Label"
					$tbtn[$cti] = GUICtrlCreateLabel($tbtntype[$cti],$cs_mar2x,$cs_mar2y,$cs_mar2w,$cs_mar2h,bitor($SS_NOTIFY,$SS_SIMPLE,$SS_SUNKEN))					
				case "Radio"
					$tbtn[$cti] = GUICtrlCreateRadio($tbtntype[$cti],$cs_mar2x,$cs_mar2y,$cs_mar2w,$cs_mar2h)					
				case "Slider"
					$tbtn[$cti] = GUICtrlCreateSlider($cs_mar2x,$cs_mar2y,$cs_mar2w,$cs_mar2h)					
				case "Edit"
					$tbtn[$cti] = GUICtrlCreateEdit($tbtntype[$cti],$cs_mar2x,$cs_mar2y,$cs_mar2w,$cs_mar2h)					
				case "Graphic"
					$tbtn[$cti] = GUICtrlCreateGraphic($cs_mar2x,$cs_mar2y,$cs_mar2w,$cs_mar2h,bitor(0,$SS_BLACKRECT) )					
				case "List"
					$tbtn[$cti] = GUICtrlCreateList($tbtntype[$cti],$cs_mar2x,$cs_mar2y,$cs_mar2w,$cs_mar2h)					
				case "Progress"
					$tbtn[$cti] = GUICtrlCreateProgress($cs_mar2x,$cs_mar2y,$cs_mar2w,$cs_mar2h)					

				case Else
					$ccok = 0
			EndSwitch
			if $ccok =1 then
				GUICtrlSetResizing($tbtn[$cti],$GUI_DOCKALL)		
			EndIf
	next
EndIf
endfunc