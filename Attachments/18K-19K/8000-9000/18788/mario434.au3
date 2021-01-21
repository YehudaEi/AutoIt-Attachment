#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=mario.ico
#AutoIt3Wrapper_outfile=mario3.exe
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseAnsi=y
#AutoIt3Wrapper_Run_Obfuscator=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;mario
;the penguin project for Diana
#include <GUIConstants.au3>
#include <Math.au3>
#include <IE.au3>
Global $replica[4][8] = [['SHUSH! I''m trying to hear the hair on my chest grow','Sleepy, sleepy, sleepy','zZZzzzZ','Who turned off the sun?','Sandman? Where??','Take me to your leader!','I don''t snore!','I''m kinda depressed today' & _
    '!'],['BOO!','Wanna see me jump out of the screen?','I should''n drink so much rocket fuel','JumpMan to the rescue!','HAHA TA! TA! TA! TA! TA! TA!!!','Beware! I can bite...','Do not underestimate the power of Goombas in large numbers','BITE ME' & _
    '!'],['I hate that pointy arrow that floats on the screen','Run Forrest, RUN!','Do you like mushrooms?','Gotta Go...','Butterd toast :D','Hello littzle goomba! MEET YOUR PLUNGER!','Why do dragons steal princesses anyway?','I''ve heard something about some funny fungloids'& _
    '!'],['Drum bum bum drum bum pac bum','It''s Goomba time!','You dare threaten the holly mushroom?!?','Flowers can make you fiery','Why do I get the feeling that I''m stuck on this desktop??','So, why did the Goomba crossed the street anyway?!','Now why did they wanted to name me ''Jumpman??''','']]
Global $replica_logon[4][2] = [['Oh, It''s you again','You''re not the sandman'],['I can fly!!!','I''m a crazy plumber eating mushrooms'],['Gotta go...','I''m off'],['Cheers!','Hello there!']]
Global $replica_onmouse[4][2] = [['Let me sleep',''],['That''s it!',''],['Gotta go...',''],['Cheers','']]
Global $replica_time[24] = ['midnight','one AM','two in the morning','three o''clock','four','five','six','seven','eight','nine','ten AM',' eleven','twelve','one PM','two','three','four','five','six','seven','eight','nine','ten','eleven']
Global $mood_action[4][9] = [[0,2,4,4,9,9,3,9,9],[0,9,5,4,2,2,4,2,3],[0,4,5,2,2,8,7,9,2],[0,4,2,6,7,7,4,8,5]]
Global $mood_name[4] = ['sleepy','nervous','walky','talky']
Global $msg, $boton, $win_mini
$action_idle = 1
$action_talk = 2
$action_walk = 3
$action_run = 4
$action_jump = 5
$action_duck = 6
$action_fire = 7
$action_follow = 8
$adr_img = 'img\'
$pas_normal=8
$menuon = 0
$mario_walk_delay = 8
$mario_run_delay = 4
$mpos=MouseGetPos()
$colm = "FFFFFFF"
$dir = 5
$nx=1
$ny=1
$pstatnr = 1
$px = @DesktopWidth / 2
$py = @DesktopHeight / 2
$pf = 1
$lpasf = 12
Global $shut = 0, $marhi = 0
Global $beginshut, $beginhide
Global $shutlimit, $hidelimit
Global $acth, $actm, $act, $actmsg
$pref_ = 10
$pref_idle = 20
$pref_pas_normal = 30
$pref_jump = 40
$pref_duck = 50
$pref_fireball = 60
$pref_flame = 90
$pref_intors = 70
$mood = Random(0,3,1)
CreateMiniWindow()
$gui=GUICreate("Mario Screen Mate - MadFlame Software", 360, 316,-1,-1,-1,$WS_EX_TOPMOST)
GUICtrlCreateLabel('Hello there! My name is Menu :)',10,10)
GUICtrlCreateLabel('You can call me anytime by hitting the little block',10,30)
GUICtrlCreateLabel('Mario was last seen at position',10,50) ;x, y, jumping while being angry
$label1 = GUICtrlCreateLabel($px&', '&$py&' while being '&$mood_name[$mood],160,50)
$but_hidemenu = GuiCtrlCreateButton('Hide me!', 10, 70, 70, -1, $BS_FLAT)
$but_hidemario = GuiCtrlCreateButton('Teleport Mario into another dimension...', 90, 70, 260, -1, $BS_FLAT)
$but_shutdown = GuiCtrlCreateButton('Shutdown this computer...', 10, 100, 165, -1, $BS_FLAT)
$but_shutdowna = GuiCtrlCreateButton('Cancel shutdown', 185, 100, 165, -1, $BS_FLAT)
$but_exit = GuiCtrlCreateButton('Close this program', 10, 130, 165, -1, $BS_FLAT)
$but_joacama = GuiCtrlCreateButton('Visit the official website', 185, 130, 165, -1, $BS_FLAT)
$but_remind = GuiCtrlCreateButton('Remind me to do something...', 10, 160, 240, -1, $BS_FLAT)
$but_reminda = GuiCtrlCreateButton('Cancel alarm', 260, 160, 90, -1, $BS_FLAT)
GUICtrlCreateLabel('Your mouse is located on the screen at pixel',10,190)
$label2 = GUICtrlCreateLabel($mpos[0]&','&$mpos[1]&' on color '&$colm&'.',220,190)
GUICtrlCreateLabel('For any suggestions please e-mail me at madflame991@yahoo.com',10,210)
GUICtrlCreateLabel('Special thanks to Nintendo, Diana, Paul, Tibs and the AutoIt team',10,210)
GUICtrlCreateLabel('...oh, and by the way, your IP is: '&@IPAddress1,10,230)
GUICtrlCreateLabel('Search:',10,253)
$inp_search = GUICtrlCreateInput('',56,250,295)
GUICtrlCreateLabel('on...',10,283)
$but_google = GuiCtrlCreateButton('Google', 56, 280, 90, -1, $BS_FLAT)
$but_youtube = GuiCtrlCreateButton('YouTube', 158, 280, 90, -1, $BS_FLAT)
$but_wikipedia = GuiCtrlCreateButton('Wikipedia', 260, 280, 90, -1, $BS_FLAT)
$win_remind = GUICreate('Reminder',340,70)
GUICtrlCreateLabel('Remind me to:',10,12)
$inp_msg = GUICtrlCreateInput('',90,10,240)
GUICtrlCreateLabel('At (hour:min) :',10,42)
$inp_h = GUICtrlCreateInput(@HOUR,90,40,30)
GUICtrlCreateLabel(':',128,40)
$inp_m = GUICtrlCreateInput(@MIN,140,40,30)
$but_remindsave = GUICtrlCreateButton('Activate',210,38,60)
$but_cancel = GUICtrlCreateButton('Cancel',280,38,50)
$mario=GUICreate("", 32, 64, 10, 10,$WS_POPUP,BitOr($WS_EX_LAYERED,$WS_EX_TOPMOST,$WS_EX_TOOLWINDOW))
WinMove($mario,"",$px,$py)
$mario_img=GUICtrlCreatePic($adr_img&'26.bmp',0,0,0,0)
GUISetState(@SW_SHOW)
$flame=GUICreate("", 32, 32, 10, 10,$WS_POPUP,BitOr($WS_EX_LAYERED,$WS_EX_TOPMOST,$WS_EX_TOOLWINDOW))
WinMove($flame,"",$px,$py)
$flame_img=GUICtrlCreatePic($adr_img&'00.bmp',0,0,0,0)
GUISetState(@SW_SHOW)
Mario_Talk($replica_logon[$mood][Random(0,1,1)],Random(20,50,1))
$counter = 0
$countlimit = Random(20,100,1)
$cnt = 0
$cnti = 0
While 1
	If $marhi = 0 Then
		If Random(0,$mood_action[$mood][$action_idle],1) = 1 Then
			p_idle()
			HSleep(Random(1,3)*10)
		EndIf
		If Random(0,$mood_action[$mood][$action_talk],1) = 1 Then Mario_Talk($replica[$mood][Random(0,7,1)],Random(30,50,1))
		If Random(0,$mood_action[$mood][$action_walk],1) > 1 Then
			mario_walk(Random(0,992,1),$mario_walk_delay)
			If Random(0,$mood_action[$mood][$action_walk],1) > -1 Then
				GUICtrlSetImage($mario_img,$adr_img&$pref_intors+1+$dir&'.bmp')
				HSleep($mario_walk_delay)
				If $dir = 5 Then
					mario_walk(Random($px+64,@DesktopWidth-32,1),$mario_walk_delay)
				Else
					mario_walk(Random(0,$px-96,1),$mario_walk_delay)
				EndIf
			EndIf
		EndIf
		If Random(0,$mood_action[$mood][$action_jump],1) = 1 Then p_jump(Random(-2,2)*5,Random(-4,-1)*10,Random(64,@DesktopHeight+96,1))
		If Random(0,$mood_action[$mood][$action_run],1) > 1 Then
			mario_walk(Random(0,992,1),$mario_run_delay)
			If Random(0,$mood_action[$mood][$action_run],1) > -1 Then
				GUICtrlSetImage($mario_img,$adr_img&$pref_intors+1+$dir&'.bmp')
				HSleep($mario_walk_delay)
				If $dir = 5 Then
					mario_walk(Random($px+64,@DesktopWidth-32,1),$mario_run_delay)
				Else
					mario_walk(Random(0,$px-96,1),$mario_run_delay)
				EndIf
			EndIf
		EndIf
		If Random(0,$mood_action[$mood][$action_jump],1) = 1 Then p_jump(Random(-2,2)*5,Random(-4,-1)*10,Random(64,@DesktopHeight+96,1))
		If (($px < 64) or ($px > @DesktopHeight)) Then
			p_jump(Random(1,2)*5,Random(-4,-1)*10,Random(64,@DesktopHeight-96,1))
			mario_walk(Random(0,992,1),$mario_run_delay)
		ElseIf (($px > @DesktopWidth - 64) or ($px > @DesktopHeight)) Then
			p_jump(Random(-2,-1)*5,Random(-4,-1)*10,Random(64,@DesktopHeight-96,1))
			mario_walk(Random(0,992,1),$mario_run_delay)
		EndIf
		If Random(0,$mood_action[$mood][$action_duck],1) = 1 Then p_duck()
		$mpos=MouseGetPos()
		If Random(0,$mood_action[$mood][$action_fire],1) = 1 Then
			$cnt = Random(1,10,1)
			For $cnti = 1 to $cnt
				flameatmouse()
			Next
		EndIf
		If (($mpos[0] > $px) And ($mpos[0] < $px+32)) And (($mpos[1] > $py) And ($mpos[1] < $py+64)) Then Mario_Talk($replica[1][1],50)
		If Random(0,$mood_action[$mood][$action_follow],1) = 1 Then
			$cnt = Random(3,15,1)
			For $cnti = 1 to $cnt
				chasethemouse()
			Next
		EndIf
		Switch @MIN
			Case 0
				tellthetime()
			Case 15
				mario_flame(Random(@DesktopWidth/4,@DesktopWidth/2+@DesktopWidth/4,1),Random(100,(@DesktopHeight/2)-100,1))
			Case 30
				mario_flame(Random(@DesktopWidth/4,@DesktopWidth/2+@DesktopWidth/4,1),Random(100,(@DesktopHeight/2)-100,1))
			Case 45
				mario_flame(Random(@DesktopWidth/4,@DesktopWidth/2+@DesktopWidth/4,1),Random(100,(@DesktopHeight/2)-100,1))
		EndSwitch
		$counter+=1
		If $counter > $countlimit Then
			$counter = 0
			$countlimit = Random(20,100,1)
			$mood = Random(0,3,1)
		EndIf
	Else
		If TimerDiff($beginhide) > $hidelimit Then
			GUISetState(@SW_SHOW,$mario)
			GUISetState(@SW_SHOW,$flame)
			$marhi = 0
		EndIf
	EndIf
    HSleep(10)
	If $shut = 1 Then
		If TimerDiff($beginshut) > $shutlimit Then
			Mario_Talk('System will now shut down in 10 sec',30)
			mario_flame(Random(@DesktopWidth/4,@DesktopWidth/2+@DesktopWidth/4,1),Random(100,(@DesktopHeight/2)-100,1))
			Shutdown(13)
		EndIf
	EndIf
	If $act = 1 Then
		If (@HOUR >= $acth) Then
			If (@MIN >= $actm) Then
				$act = 0
				Mario_Talk('Alarm! Alarm! WAKE UP!',70)
				Mario_Flame(Random(@DesktopWidth/4,@DesktopWidth/2+@DesktopWidth/4,1),Random(100,(@DesktopHeight/2)-100,1))
				Alarm()
			EndIf
		EndIf
	EndIf
WEnd
Func ChaseTheMouse()
    $mpos=MouseGetPos()
    If Abs($mpos[0] - $px) > 9 Then
        Mario_Walk($mpos[0],$mario_run_delay)
    EndIf
    If  Abs($mpos[1] - $py) > 18 Then
        If $mpos[0]-$px > 0 Then
            p_jump(5*Random(1,2),-10*Random(1,2),$mpos[1]-16)
        Else
            p_jump(-5*Random(1,2),-10*Random(1,2),$mpos[1]-16)
        EndIf
    EndIf
    HSleep(100)
EndFunc
Func FlameAtMouse()
    $mpos=MouseGetPos()
    mario_flame($mpos[0],$mpos[1])
    $mpos2 = MouseGetPos()
    If (Abs($mpos[0] - $mpos2[0]) < 32) And (Abs($mpos[1] - $mpos2[1]) < 32) Then
        MouseMove($mpos[0]+Random(-10,10,1)*10,$mpos[1]+Random(-10,10,1)*10,5)
    EndIf
EndFunc
Func TellTheTime()
    p_jump(1,4,@DesktopHeight-100)
    mario_walk(@DesktopWidth/2,$mario_run_delay)
	Mario_Talk('Heya! It''s '&$replica_time[@HOUR],80)
    For $i = 1 to @HOUR
        mario_flame(Random(@DesktopWidth/4,@DesktopWidth/2+@DesktopWidth/4,1),Random(100,(@DesktopHeight/2)-100,1))
    Next
    HSleep(30000)
EndFunc
Func Mario_Walk($x,$dlay)
Local $dzx
Local $paszx
    $dzx=$px-$x
    If $dzx > 0 then
        $dir = 5
        $paszx = $pas_normal * -1
    Else
        $paszx = $pas_normal
        $dir = 0
    EndIf
    While Abs($dzx) > 13
        GUICtrlSetImage($mario_img,$adr_img&$pref_pas_normal+1+$dir&'.bmp')
		$px += $paszx
        WinMove($mario,"",$px,$py)
        HSleep($dlay)
        GUICtrlSetImage($mario_img,$adr_img&$pref_pas_normal+2+$dir&'.bmp')
        $px += $paszx
        WinMove($mario,"",$px,$py)
        HSleep($dlay)
        GUICtrlSetImage($mario_img,$adr_img&$pref_pas_normal+3+$dir&'.bmp')
        $px += $paszx
        WinMove($mario,"",$px,$py)
        HSleep($dlay)
        $dzx=$px-$x
    WEnd
    GUICtrlSetImage($mario_img,$adr_img&$pref_idle+$dir+1&'.bmp')
EndFunc
Func p_jump($fx,$fy,$l)
    If $fx > 0 Then
        $dir=0
    Else
        $dir=5
    EndIf
    GUICtrlSetImage($mario_img,$adr_img&$pref_jump+$dir+1&'.bmp')
    $gy=1
    $nok=1
    While $nok
        If (($fy > 0)and($py>$l)) then
            $nok=0
        EndIf
        $opx=$px
        $px=$px+$fx
        $fx=$px-$opx
        $opy=$py
        $py=$py+$gy+$fy
        $fy=$py-$opy
        WinMove($mario,'',$px,$py)
        HSleep(2)
    WEnd
    GUICtrlSetImage($mario_img,$adr_img&$pref_idle+$dir+1&'.bmp')
EndFunc
Func p_idle()
    GUICtrlSetImage($mario_img,$adr_img&$pref_idle+$dir+1&'.bmp')
EndFunc
Func Mario_Flame($x,$y)
    If $x < $px Then
        $dir = 5
        $firex = $px-8
    Else
        $dir = 0
        $firex = $px+40
    EndIf
    GUICtrlSetImage($mario_img,$adr_img&$pref_fireball+$dir+1&'.bmp')
    HSleep(3)
    $firey = $py + 8
    $dx = $firex-$x
    $dy = $firey-$y
    $dist = Sqrt(($dx*$dx)+($dy*$dy))
    $npas = $dist / $lpasf
    $fpx = -($dx) / $npas
    $fpy = -($dy) / $npas
    $nok = 1
    $ff = 1
    WinMove($flame,"",$firex,$firey)
    GUICtrlSetImage($flame_img,$adr_img&$pref_flame+$ff&'.bmp')
    GUICtrlSetImage($mario_img,$adr_img&$pref_idle+$dir+1&'.bmp')
    While $nok = 1
        If ((Abs($firex - $x) < 9) And (Abs($firey - $y) < 9)) Then
            $nok = 0
        Else
            $firex += $fpx
            $firey += $fpy
            WinMove($flame,"",$firex,$firey)
            $ff += 1
            If $ff > 4 Then $ff = 1
            GUICtrlSetImage($flame_img,$adr_img&$pref_flame+$ff&'.bmp')
        EndIf
        HSleep($mario_run_delay)
    WEnd
    $firex += $fpx
    $firey += $fpy
    WinMove($flame,"",$firex,$firey)
    GUICtrlSetImage($flame_img,$adr_img&$pref_flame+7&'.bmp')
    HSleep(8)
    GUICtrlSetImage($flame_img,$adr_img&$pref_flame+8&'.bmp')
    HSleep(8)
    GUICtrlSetImage($flame_img,$adr_img&$pref_flame+9&'.bmp')
    HSleep(8)
    GUICtrlSetImage($flame_img,$adr_img&'00.bmp')
EndFunc
Func p_duck()
    GUICtrlSetImage($mario_img,$adr_img&$pref_duck+$dir+1&'.bmp')
EndFunc
Func Mario_Talk($msj,$durat)
    GUICtrlSetImage($mario_img,$adr_img&$pref_idle+$dir+1&'.bmp')
    ToolTip($msj,$px-20,$py-20)
    HSleep($durat*10)
    ToolTip('',0,0)
EndFunc
Func HSleep($ms)
	For $i=1 to $ms
		Sleep(10)
		$msg = GUIGetMsg()
		If $msg = $boton Then LoopMenu()
	Next
EndFunc
Func Alarm()
	$win_alarm = GUICreate('Alarm',300,200,-1,-1,$WS_POPUP,BitOr($WS_EX_TOPMOST,$WS_EX_TOOLWINDOW))
	GUICtrlCreateLabel('Mario wants to say something:',20,40)
	GUICtrlCreateLabel($actmsg,20,80)
	$but_roger = GUICtrlCreateButton('Got it!',120,120,60)
	GUISetBkColor(0xD3E5FA)
	GUISetState(@SW_SHOW)
	Do
		$msg = GUIGetMsg()
	Until ($msg = $GUI_EVENT_CLOSE) Or ($msg = $but_roger)
	$act = 0
	GUIDelete($win_alarm)
EndFunc
Func CreateMiniWindow()
	$win_mini = GUICreate('Miniwindow', 34, 34,@DesktopWidth-52,@DesktopHeight-80,$WS_POPUP,$WS_EX_TOPMOST+$WS_EX_TOOLWINDOW)
	$boton = GUICtrlCreateButton ('', 0,0,34,34, $BS_ICON+$BS_FLAT)
	GUICtrlSetImage(-1, 'img\blok.bmp')
	GUISetState(@SW_SHOW)
EndFunc
Func LoopRemind()
	Local $remindon
	If $remindon = 0 Then
		$remindon = 1
		GUISetState(@SW_SHOW,$win_remind)
		GUISwitch($win_remind)
		Do
			Sleep(10)
			$msg = GUIGetMsg()
			Switch $msg
				Case $but_remindsave
					$msg = $GUI_EVENT_CLOSE
					$act = 1
					$acth = GUICtrlRead($inp_h)
					$actm = GUICtrlRead($inp_m)
					$actmsg = GUICtrlRead($inp_msg)
			EndSwitch
		Until ($msg = $GUI_EVENT_CLOSE) Or ($msg = $but_cancel)
		GUISetState(@SW_HIDE,$win_remind)
		$remindon = 0
	EndIf
EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------
Func LoopMenu()
	Local $ocolm = 0
	If $menuon = 0 Then
		$menuon = 1
		GUICtrlSetData($label1,Floor($px)&', '&Floor($py)&' while being '&$mood_name[$mood])
		GUISetState(@SW_SHOW,$gui)
		GUISwitch($gui)
		Do
			Sleep(10)
			$msg = GUIGetMsg()
			Switch $msg
				Case $but_hidemario
					GUISetState(@SW_HIDE,$gui)
					$hidelimit = 60000 * InputBox('Question','After how many minutes will Mario come back?',10)
					If @error = 0 Then
						Mario_Talk('I''ll be back!',50)
						GUISetState(@SW_HIDE,$mario)
						GUISetState(@SW_HIDE,$flame)
						$marhi = 1
						$beginhide = TimerInit()
					EndIf
					GUISetState(@SW_SHOW,$gui)
				Case $but_exit
					Exit
				Case $but_joacama
					_IECreate("www.joaca-ma.blogspot.com", 1, 1, 0)
				Case $but_shutdown
					GUISetState(@SW_HIDE,$gui)
					$shutlimit = 60000 * InputBox('Question','After how many minutes shall I close your computer?',10)
					If @error = 0 Then
						$shut = 1
						$beginshut = TimerInit()
					EndIf
					GUISetState(@SW_SHOW,$gui)
				Case $but_shutdowna
					$shut = 0
				Case $but_remind
					GUISetState(@SW_HIDE,$gui)
					LoopRemind()
					GUISetState(@SW_SHOW,$gui)
					$msg = 0
				Case $but_reminda
					$act = 0
				Case $but_google
					_IECreate('http://www.google.com/search?q='&GUICtrlRead($inp_search),1,1,0)
				Case $but_youtube
					_IECreate('http://www.youtube.com/results?search_query='&GUICtrlRead($inp_search),1,1,0)
				Case $but_wikipedia
					_IECreate('http://en.wikipedia.org/wiki/Search?search='&GUICtrlRead($inp_search),1,1,0)
			EndSwitch
			$mpos=MouseGetPos()
			$colm = Hex(PixelGetColor($mpos[0],$mpos[1]),6)
			If $colm <> $ocolm Then 
				GUICtrlSetData($label2,$mpos[0]&','&$mpos[1]&' on color '&$colm&'.')
				$ocolm = $colm
			EndIf
			If $act = 1 Then
				If (@HOUR >= $acth) Then
					If (@MIN >= $actm) Then
						$act = 0
						Mario_Talk('Alarm! Alarm! WAKE UP!',70)
						Mario_Flame(Random(@DesktopWidth/4,@DesktopWidth/2+@DesktopWidth/4,1),Random(100,(@DesktopHeight/2)-100,1))
						Alarm()
					EndIf
				EndIf
			EndIfu
		Until ($msg = $GUI_EVENT_CLOSE) Or ($msg = $but_hidemenu) Or ($msg = $but_hidemario) Or ($msg = $but_shutdown)
		GUISetState(@SW_HIDE,$gui)
		$menuon = 0
	EndIf
EndFunc