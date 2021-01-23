#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=mario.ico
#AutoIt3Wrapper_outfile=mario36.exe
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseAnsi=y
#AutoIt3Wrapper_Res_Fileversion=3.6
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf=1
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;the penguin project for Diana
#include <GUIConstants.au3>
#include <Math.au3>
#include <IE.au3>
#include <Misc.au3>
#include <Color.au3>
#Include <GuiTab.au3>
#include <ScreenCapture.au3>
HotKeySet('!1','ColoPau')
Global $max_moods = 5, $nmood
Global $replica[$max_moods + 1][10]
Global $replica_logon[$max_moods + 1][2]
Global $replica_onmouse[$max_moods + 1][2]
Global $replica_time[25]
Global $mood_action[$max_moods + 1][9]
Global $mood_name[$max_moods + 1]
Global $msg, $boton, $win_mini, $win_cap, $but_showcap, $but_cap
Global $grab = 0
Global $opt_marioimgadr, $opt_mariontop, $opt_autostart, $opt_butcap, $opt_menutop, $opt_adrcap
Global $action_idle = 1, $action_talk = 2, $action_walk = 3, $action_run = 4, $action_jump = 5, $action_duck = 6, $action_fire = 7, $action_follow = 8
Global $charname
;-----------------------------------------------------------------------------------------------------------------------------------
$adr_img = 'chars\'
$pas_normal=8
$menuon = 0
$Mario_Walk_delay = 80
$mario_run_delay = 45
$mpos=MouseGetPos()
$dir = 5
Global $mario_x = @DesktopWidth / 2
Global $mario_y = @DesktopHeight / 2
Global $mario_size[2], $flame_size[2]
Global $lpasf = 12
Global $marhi = 0
Global $pref_ = 10, $pref_idle = 20, $pref_pas_normal = 30, $pref_jump = 40, $pref_duck = 50, $pref_fireball = 60, $pref_flame = 90, $pref_intors = 70
Global $lbl_colo[2]
$colopause = 0
LoadSets()
If $CmdLine[0] > 0 Then
	If ($CmdLine[1] = '-s') And ($opt_autostart = 0) Then Exit
EndIf
LoadChar()
#Region
;============ program principal ====================================================================================================
$mood = Random(1,$nmood,1)
CreateMiniWindow()
;-------- Main Menu Window ---------------------------------------------------------------------------------------------------------
If $opt_menutop = 1 Then
	$win_main=GUICreate('Mario Screen Mate v3.6 - MadFlame Software',410,286,-1,-1,-1,$WS_EX_TOPMOST)
Else
	$win_main=GUICreate('Mario Screen Mate v3.6 - MadFlame Software',410,286)
EndIf
GUICtrlCreateLabel('This is the internal menu'&@CRLF&'Below you might find usefull things',10,10)
$but_hidemenu = GuiCtrlCreateButton('Hide me!', 10, 250, 70, -1, $BS_FLAT)
$but_hidemario = GuiCtrlCreateButton('Hide Mario', 90, 250, 70, -1, $BS_FLAT)
$but_exit = GuiCtrlCreateButton('Exit', 170, 250, 70, -1, $BS_FLAT)
$but_joacama = GuiCtrlCreateButton('Official site', 250, 250, 70, -1, $BS_FLAT)
$tab=GUICtrlCreateTab(10,50,390,190)
;-----------------------------------------------------------------------------------------------
$tab_general=GUICtrlCreateTabItem ('General')
GUICtrlCreateLabel('This menu will appear when you click on the little block',20,80)
$label1 = GUICtrlCreateLabel($charname&' was last seen at position '&$mario_x&', '&$mario_y&' while being '&$mood_name[$mood],20,100)
$lbl_colo[0] = GUICtrlCreateInput('X: 0, Y: 0, RGB: (0,0,0) Hex: 0x000000',20,120,260)
GUICtrlCreateLabel('Alt+1 = Pause',320,123)
$lbl_colo[1] = GUICtrlCreateLabel('',290,120,20,20,$SS_SUNKEN)
GUICtrlSetBkColor(-1,0x000000)
$lbl_ipadr = GUICtrlCreateLabel('Your IP adress: '&@IPAddress1,20,150)
GUICtrlCreateLabel('Search:',20,173)
$inp_search = GUICtrlCreateInput('',66,170,295)
GUICtrlCreateLabel('on...',20,203)
$but_google = GuiCtrlCreateButton('Google', 66, 200, 90, -1, $BS_FLAT)
$but_youtube = GuiCtrlCreateButton('YouTube', 168, 200, 90, -1, $BS_FLAT)
$but_wikipedia = GuiCtrlCreateButton('Wikipedia', 270, 200, 90, -1, $BS_FLAT)
;-----------------------------------------------------------------------------------------------
$tab_mariosets=GUICtrlCreateTabitem ('Settings')
GUICtrlCreateLabel('Customize Mario',20,80)
GUICtrlCreateLabel('Graphical theme',20,103)
$com_theme = GUICtrlCreateCombo('',110,100)
GUICtrlSetData(-1,ListFiles($adr_img&'*'),'BigMario')
$chk_mariotop = GUICtrlCreateCheckbox('Mario on top',20,120)
If $opt_mariontop = 1 Then GUICtrlSetState($chk_mariotop,$GUI_CHECKED)
$chk_menutop = GUICtrlCreateCheckbox('Menu on top (application needs to restart)',20,140)
If $opt_menutop = 1 Then GUICtrlSetState($chk_menutop,$GUI_CHECKED)
$chk_startup = GUICtrlCreateCheckbox('Start at windows logon', 20, 160)
If $opt_autostart = 1 Then GUICtrlSetState($chk_startup,$GUI_CHECKED)
$but_refresh = GUICtrlCreateButton('Apply',320,204,70)
;-----------------------------------------------------------------------------------------------
$tab_scrshot=GUICtrlCreateTabitem ('Screenshots')
GUICtrlCreateLabel('Screenshots at your service',20,80)
$but_showcap = GUICtrlCreateButton('Show Capture Button',20,100,130)
GUICtrlCreateLabel('Screenshots will be saved in...',20,134)
$inp_capadr = GUICtrlCreateInput($opt_adrcap,20,152,160)
$but_setadr = GUICtrlCreateButton('Set',190,150,60)
$but_chagecapadr = GUICtrlCreateButton('Browse',260,150,60)
$but_opencapadr = GUICtrlCreateButton('Visit',330,150,60)
;-----------------------------------------------------------------------------------------------
$tab_about=GUICtrlCreateTabitem ('About')
GUICtrlCreateLabel('For any suggestions please e-mail me at madflame991@yahoo.com',20,80)
GUICtrlCreateLabel('Special thanks to Nintendo, Diana, Paul, Tibs and the AutoIt team',20,100)
;-----------------------------------------------------------------------------------------------
If $opt_butcap = 0 Then
	GUICtrlSetData($but_showcap,'Show Capture Button')
Else
	GUICtrlSetData($but_showcap,'Hide Capture Button')
	CreateCapWindow()
EndIf
;-------- Mario Window  ------------------------------------------------------------------------------------------------------------
If $opt_mariontop = 1 Then
	$win_mario=GUICreate('',$mario_size[0],$mario_size[1],$mario_x,$mario_y,$WS_POPUP,BitOr($WS_EX_LAYERED,$WS_EX_TOPMOST,$WS_EX_TOOLWINDOW))
Else
	$win_mario=GUICreate('',$mario_size[0],$mario_size[1],$mario_x,$mario_y,$WS_POPUP,BitOr($WS_EX_LAYERED,$WS_EX_TOOLWINDOW))
EndIf
$mario_img=GUICtrlCreatePic($adr_img&$opt_marioimgadr&'\26.bmp',0,0,$mario_size[0],$mario_size[1])
Opt('GUIOnEventMode',1)
GUICtrlSetOnEvent($mario_img,'DragHim')
GUISetState(@SW_SHOW)
;-------- ferestra flacara mario
$win_flame=GUICreate('',$flame_size[0],$flame_size[1],$mario_x,$mario_y,$WS_POPUP,BitOr($WS_EX_LAYERED,$WS_EX_TOPMOST,$WS_EX_TOOLWINDOW))
$flame_img=GUICtrlCreatePic($adr_img&$opt_marioimgadr&'\00.bmp',0,0,0,0)
GUISetState(@SW_SHOW)
;-------- executie
Mario_Talk($replica_logon[$mood][Random(0,1,1)],Random(200,500,1))
$counter = 0
$countlimit = Random(20,100,1)
$cnt = 0
$cnti = 0
#EndRegion
;===================================================================================================================================
While 1
	If $marhi = 0 Then
;------- IDLE ----------------------------------------------------------------------------------------------------------------------
		If Random(0,$mood_action[$mood][$action_idle],1) = 1 Then
			Mario_Idle()
			Sleep(Random(1,3)*1000)
		EndIf
;------- TALK ----------------------------------------------------------------------------------------------------------------------
		If Random(0,$mood_action[$mood][$action_talk],1) = 1 Then Mario_Talk($replica[$mood][Random(1,$replica[$mood][0],1)],Random(300,500,1))
;------- WALK ----------------------------------------------------------------------------------------------------------------------
		If Random(0,$mood_action[$mood][$action_walk],1) = 1 Then
			Mario_Walk(Random(0,992,1),$Mario_Walk_delay)
			If Random(0,$mood_action[$mood][$action_walk],1) > -1 Then
				GUICtrlSetImage($mario_img,$adr_img&$opt_marioimgadr&'\'&$pref_intors+1+$dir&'.bmp')
				Sleep($Mario_Walk_delay)
				If $dir = 5 Then
					Mario_Walk(Random($mario_x+64,@DesktopWidth-32,1),$Mario_Walk_delay)
				Else
					Mario_Walk(Random(0,$mario_x-96,1),$Mario_Walk_delay)
				EndIf
			EndIf
		EndIf
;------- JUMP ----------------------------------------------------------------------------------------------------------------------
		If Random(0,$mood_action[$mood][$action_jump],1) = 1 Then Mario_Jump(Random(-2,2)*10,Random(-4,-1)*10,Random(64,@DesktopHeight+96,1))
;------- RUN -----------------------------------------------------------------------------------------------------------------------
		If Random(0,$mood_action[$mood][$action_run],1) = 1 Then
			Mario_Walk(Random(0,992,1),$mario_run_delay)
			If Random(0,$mood_action[$mood][$action_run],1) > -1 Then
				GUICtrlSetImage($mario_img,$adr_img&$opt_marioimgadr&'\'&$pref_intors+1+$dir&'.bmp')
				Sleep($Mario_Walk_delay)
				If $dir = 5 Then
					Mario_Walk(Random($mario_x+64,@DesktopWidth-32,1),$mario_run_delay)
				Else
					Mario_Walk(Random(0,$mario_x-96,1),$mario_run_delay)
				EndIf
			EndIf
		EndIf
;------- JUMP ----------------------------------------------------------------------------------------------------------------------
		If Random(0,$mood_action[$mood][$action_jump],1) = 1 Then Mario_Jump(Random(-2,2)*5,Random(-4,-1)*10,Random(64,@DesktopHeight+96,1))
;-------- IF HE GETS OUT OF THE SCREEN
		If (($mario_x < 64) or ($mario_x > @DesktopWidth - 64)) Then
			Mario_Jump(Random(1,2)*5,Random(-4,-1)*10,Random(64,@DesktopHeight-96,1))
			Mario_Walk(Random(0,992,1),$mario_run_delay)
		EndIf
		If (($mario_y < 64) or ($mario_y > @DesktopHeight - 64)) Then
			Mario_Jump(Random(-2,-1)*5,Random(-4,-1)*10,Random(64,@DesktopHeight-96,1))
			Mario_Walk(Random(0,992,1),$mario_run_delay)
		EndIf
;-------- DUCK
		If Random(0,$mood_action[$mood][$action_duck],1) = 1 Then Mario_Duck()
;-------- GET MOUSE POSITION
		$mpos=MouseGetPos()
;-------- FLAME TO MOUSE        
		If Random(0,$mood_action[$mood][$action_fire],1) = 1 Then
			$cnt = Random(1,10,1)
			For $cnti = 1 to $cnt
				FlameAtMouse()
			Next
		EndIf
;-------- ON MOUSE ACTION
		If (($mpos[0] > $mario_x) And ($mpos[0] < $mario_x+32)) And (($mpos[1] > $mario_y) And ($mpos[1] < $mario_y+64)) Then Mario_Talk($replica[1][1],500)
;-------- CHASE THE MOUSE
		If Random(0,$mood_action[$mood][$action_follow],1) = 1 Then
			$cnt = Random(3,15,1)
			For $cnti = 1 to $cnt
				chasethemouse()
			Next
		EndIf
;-------- TELL THE TIME
		Switch @MIN
			Case 0
				TellTheTime()
			Case 15
				Mario_Flame(Random(@DesktopWidth/4,@DesktopWidth/2+@DesktopWidth/4,1),Random(100,(@DesktopHeight/2)-100,1))
			Case 30
				Mario_Flame(Random(@DesktopWidth/4,@DesktopWidth/2+@DesktopWidth/4,1),Random(100,(@DesktopHeight/2)-100,1))
			Case 45
				Mario_Flame(Random(@DesktopWidth/4,@DesktopWidth/2+@DesktopWidth/4,1),Random(100,(@DesktopHeight/2)-100,1))
		EndSwitch
		$mpos=MouseGetPos()
		If  Abs($mpos[1] - $mario_y) > 18 Then
			If $mpos[0]-$mario_x > 0 Then
				Mario_Jump(5*Random(1,2),-10*Random(1,2),$mpos[1]-16)
			Else
				Mario_Jump(-5*Random(1,2),-10*Random(1,2),$mpos[1]-16)
			EndIf
		EndIf
;-------- MOOD CHANGER
		$counter+=1
		If $counter > $countlimit Then
			$counter = 0
			$countlimit = Random(20,100,1)
			$mood = Random(1,$nmood,1)
		EndIf
	EndIf
;-------- DELAY BETWEEN CICLE
	Sleep(1000)
WEnd
;=========TERMINARE PROGRAM PRINCIPAL===============================================================================================
Func ColoPau()
	If $colopause = 1 Then
		$colopause = 0
	Else
		$colopause = 1
	EndIf
EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------
Func ListFiles($path)
Local $arlev[32]
	$search = FileFindFirstFile($path)
	If $search = -1 Then
		MsgBox(0, 'Error', 'Directory is empty')
		Exit
	EndIf
	$i = 0
	While 1
		$i += 1
		$fil = FileFindNextFile($search)
		If @error Then
			ExitLoop
		Else
			$arlev[$i] = $fil
		EndIf
	Wend
	$arlev[0] = $i - 1
	$str = $arlev[1]
	For $i = 2 To $arlev[0]
		$str &= '|' & $arlev[$i]
	Next
	Return $str
EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------
Func SaveSets()
	$f = FileOpen('sets.txt',2)
	FileWriteLine($f,$opt_mariontop)
	FileWriteLine($f,$opt_menutop)
	FileWriteLine($f,$opt_butcap)
	FileWriteLine($f,$opt_autostart)
	FileWriteLine($f,$opt_adrcap)
	FileWriteLine($f,$opt_marioimgadr)
	FileClose($f)
EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------
Func LoadSets()
	$f = FileOpen('sets.txt',0)
	$opt_mariontop = FileReadLine($f)
	$opt_menutop = FileReadLine($f)
	$opt_butcap = FileReadLine($f)
	$opt_autostart = FileReadLine($f)
	$opt_adrcap = FileReadLine($f)
	$opt_marioimgadr = FileReadLine($f)
	FileClose($f)
EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------
Func LoadChar()
	$f = FileOpen($adr_img&$opt_marioimgadr&'\per.txt',0)
	$charname = FileReadLine($f)
	$raw = StringSplit(FileReadLine($f),';')
	$mario_size[0] = $raw[1]
	$raw = StringSplit(FileReadLine($f),';')
	$mario_size[1] = $raw[1]
	$raw = StringSplit(FileReadLine($f),';')
	$flame_size[0] = $raw[1]
	$raw = StringSplit(FileReadLine($f),';')
	$flame_size[1] = $raw[1]
	$nmood = FileReadLine($f)
	For $i = 1 to $nmood
		$raw = StringSplit(FileReadLine($f),',')
		For $j = 1 to 8
			$mood_action[$i][$j] = $raw[$j]
		Next
	Next
	$mood_name = StringSplit(FileReadLine($f),',')
	For $i = 1 to $nmood
		$replica[$i][0] = FileReadLine($f)
		For $j = 1 to $replica[$i][0]
			$replica[$i][$j] = FileReadLine($f)
		Next
	Next
	FileReadLine($f)
	For $i = 1 to $nmood
		For $j = 0 to 1
			$replica_logon[$i][$j] = FileReadLine($f)
		Next
	Next
	For $i = 1 to $nmood
		For $j = 0 to 1
			$replica_onmouse[$i][$j] = FileReadLine($f)
		Next
	Next
	$raw = StringSplit(FileReadLine($f),'|')
	For $i = 0 to 24
		$replica_time[$i] = $raw[$i+1]
	Next
	FileClose($f)
EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------
Func DragHim()
	If $grab = 0 Then
		Opt('GUIOnEventMode',0)
		$dll = DllOpen('user32.dll')
		$grab = 1
		$mpos = MouseGetPos()
		$dragdistx = $mpos[0] - $mario_x
		$dragdisty = $mpos[1] - $mario_y
		Sleep(100)
		While 1
			If _IsPressed('01', $dll) Then ExitLoop
			WinMove($win_mario,'',MouseGetPos(0)-$dragdistx,MouseGetPos(1)-$dragdisty)
		WEnd
		$mario_x = MouseGetPos(0)-$dragdistx
		$mario_y = MouseGetPos(1)-$dragdisty
		DllClose($dll)
		Opt('GUIOnEventMode',1)
	EndIf
	$grab = 0
EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------
Func ChaseTheMouse()
    $mpos=MouseGetPos()
    If Abs($mpos[0] - $mario_x) > 9 Then
        Mario_Walk($mpos[0],$mario_run_delay)
    EndIf
    If  Abs($mpos[1] - $mario_y) > 18 Then
        If $mpos[0]-$mario_x > 0 Then
            Mario_Jump(5*Random(1,2),-10*Random(1,2),$mpos[1]-16)
        Else
            Mario_Jump(-5*Random(1,2),-10*Random(1,2),$mpos[1]-16)
        EndIf
    EndIf
    Sleep(100)
EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------
Func FlameAtMouse()
    $mpos=MouseGetPos()
    Mario_Flame($mpos[0],$mpos[1])
    $mpos2 = MouseGetPos()
    If (Abs($mpos[0] - $mpos2[0]) < 32) And (Abs($mpos[1] - $mpos2[1]) < 32) Then
		$shake = Random(5,10,1)
		For $i = 1 to $shake
			MouseMove($mpos2[0]+Random(5,25,1),$mpos2[1]+Random(5,25,1),3)
		Next
    EndIf
EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------
Func TellTheTime()
    Mario_Jump(1,4,@DesktopHeight-100)
    Mario_Walk(@DesktopWidth/2,$mario_run_delay)
	Mario_Talk($replica_time[0]&$replica_time[@HOUR+1],800)
    For $i = 1 to @HOUR
        Mario_Flame(Random(@DesktopWidth/4,@DesktopWidth/2+@DesktopWidth/4,1),Random(100,(@DesktopHeight/2)-100,1))
    Next
    Sleep(30000)
EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------
Func Mario_Walk($x,$dlay)
Local $dzx
Local $paszx
    $dzx=$mario_x-$x
    If $dzx > 0 then
        $dir = 5
        $paszx = $pas_normal * -1
    Else
        $paszx = $pas_normal
        $dir = 0
    EndIf
    While Abs($dzx) > 13
        GUICtrlSetImage($mario_img,$adr_img&$opt_marioimgadr&'\'&$pref_pas_normal+1+$dir&'.bmp')
		$mario_x += $paszx
        WinMove($win_mario,'',$mario_x,$mario_y)
        Sleep($dlay)
        GUICtrlSetImage($mario_img,$adr_img&$opt_marioimgadr&'\'&$pref_pas_normal+2+$dir&'.bmp')
        $mario_x += $paszx
        WinMove($win_mario,'',$mario_x,$mario_y)
        Sleep($dlay)
        GUICtrlSetImage($mario_img,$adr_img&$opt_marioimgadr&'\'&$pref_pas_normal+3+$dir&'.bmp')
        $mario_x += $paszx
        WinMove($win_mario,'',$mario_x,$mario_y)
        Sleep($dlay)
        $dzx=$mario_x-$x
    WEnd
    GUICtrlSetImage($mario_img,$adr_img&$opt_marioimgadr&'\'&$pref_idle+$dir+1&'.bmp')
EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------
Func Mario_Jump($fx,$fy,$l)
    If $fx > 0 Then
        $dir=0
    Else
        $dir=5
    EndIf
    GUICtrlSetImage($mario_img,$adr_img&$opt_marioimgadr&'\'&$pref_jump+$dir+1&'.bmp')
    $gy=1
    $nok=1
    While $nok
        If (($fy > 0)and($mario_y>$l)) then
            $nok=0
        EndIf
        $mario_x=$mario_x+$fx
		$opy=$mario_y
        $mario_y=$mario_y+$gy+$fy
        $fy=$mario_y-$opy
        WinMove($win_mario,'',$mario_x,$mario_y)
        Sleep(30)
    WEnd
    GUICtrlSetImage($mario_img,$adr_img&$opt_marioimgadr&'\'&$pref_idle+$dir+1&'.bmp')
EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------
Func Mario_Idle()
    GUICtrlSetImage($mario_img,$adr_img&$opt_marioimgadr&'\'&$pref_idle+$dir+1&'.bmp')
EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------
Func Mario_Flame($x,$y)
    If $x < $mario_x Then
        $dir = 5
        $firex = $mario_x-8
    Else
        $dir = 0
        $firex = $mario_x+40
    EndIf
    GUICtrlSetImage($mario_img,$adr_img&$opt_marioimgadr&'\'&$pref_fireball+$dir+1&'.bmp')
    Sleep(300)
    $firey = $mario_y + 8
    $dx = $firex-$x
    $dy = $firey-$y
    $dist = Sqrt(($dx*$dx)+($dy*$dy))
    $npas = $dist / $lpasf
    $fpx = -($dx) / $npas
    $fpy = -($dy) / $npas
    $nok = 1
    $ff = 1
    WinMove($win_flame,'',$firex,$firey)
    GUICtrlSetImage($flame_img,$adr_img&$opt_marioimgadr&'\'&$pref_flame+$ff&'.bmp')
    GUICtrlSetImage($mario_img,$adr_img&$opt_marioimgadr&'\'&$pref_idle+$dir+1&'.bmp')
    While $nok = 1
        If ((Abs($firex - $x) < 9) And (Abs($firey - $y) < 9)) Then
            $nok = 0
        Else
            $firex += $fpx
            $firey += $fpy
            WinMove($win_flame,'',$firex,$firey)
            $ff += 1
            If $ff > 4 Then $ff = 1
            GUICtrlSetImage($flame_img,$adr_img&$opt_marioimgadr&'\'&$pref_flame+$ff&'.bmp')
        EndIf
        Sleep($mario_run_delay)
    WEnd
    $firex += $fpx
    $firey += $fpy
    WinMove($win_flame,'',$firex,$firey)
    GUICtrlSetImage($flame_img,$adr_img&$opt_marioimgadr&'\'&$pref_flame+7&'.bmp')
    Sleep(80)
    GUICtrlSetImage($flame_img,$adr_img&$opt_marioimgadr&'\'&$pref_flame+8&'.bmp')
    Sleep(80)
    GUICtrlSetImage($flame_img,$adr_img&$opt_marioimgadr&'\'&$pref_flame+9&'.bmp')
    Sleep(80)
    GUICtrlSetImage($flame_img,$adr_img&$opt_marioimgadr&'\00.bmp')
EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------
Func Mario_Duck()
    GUICtrlSetImage($mario_img,$adr_img&$opt_marioimgadr&'\'&$pref_duck+$dir+1&'.bmp')
EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------
Func Mario_Talk($msj,$durat)
    GUICtrlSetImage($mario_img,$adr_img&$opt_marioimgadr&'\'&$pref_idle+$dir+1&'.bmp')
    ToolTip($msj,$mario_x-20,$mario_y-20)
    Sleep($durat*10)
    ToolTip('',0,0)
EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------
Func Screenshot()
	_ScreenCapture_Capture($opt_adrcap&'\p'&@YEAR&'-'&@MON&'-'&@MDAY&'_'&@HOUR&'-'&@MIN&'-'&@SEC&'.jpg')
	MsgBox(0,'',$opt_adrcap&'\p'&@YEAR&'-'&@MON&'-'&@MDAY&'_'&@HOUR&'-'&@MIN&'-'&@SEC&'.jpg')
EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------
Func CreateCapWindow()
	$win_cap = GUICreate('Shotwindow',32,32,@DesktopWidth-52,@DesktopHeight-120,$WS_POPUP,$WS_EX_TOPMOST+$WS_EX_TOOLWINDOW+$WS_EX_LAYERED)
	$but_cap = GUICtrlCreatePic($adr_img&$opt_marioimgadr&'\blok2.bmp',0,0,0,0)
	GUICtrlSetOnEvent($but_cap,'Screenshot')
	GUISetState(@SW_SHOW)
EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------
Func CreateMiniWindow()
	$win_mini = GUICreate('Miniwindow',32,32,@DesktopWidth-52,@DesktopHeight-80,$WS_POPUP,$WS_EX_TOPMOST+$WS_EX_TOOLWINDOW+$WS_EX_LAYERED)
	$boton = GUICtrlCreatePic($adr_img&$opt_marioimgadr&'\blok.bmp',0,0,0,0)
	GUICtrlSetOnEvent($boton,'LoopMenu')
	GUISetState(@SW_SHOW)
EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------
Func RecreateMarioWin()
	GUIDelete($win_mario)
	If $opt_mariontop = 1 Then
		$win_mario=GUICreate('',$mario_size[0],$mario_size[1],$mario_x,$mario_y,$WS_POPUP,BitOr($WS_EX_LAYERED,$WS_EX_TOPMOST,$WS_EX_TOOLWINDOW))
	Else
		$win_mario=GUICreate('',$mario_size[0],$mario_size[1],$mario_x,$mario_y,$WS_POPUP,BitOr($WS_EX_LAYERED,$WS_EX_TOOLWINDOW))
	EndIf
	$mario_img=GUICtrlCreatePic($adr_img&$opt_marioimgadr&'\26.bmp',0,0,$mario_size[0],$mario_size[1])
	GUICtrlSetOnEvent($mario_img,'DragHim')
	GUISetState(@SW_SHOW)
EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------
Func LoopMenu()
Local $colopickactive = 1
Local $ocolm = 0x000000
Local $colm
	Opt('GUIOnEventMode',0)
	GUISwitch($win_main)
	If $menuon = 0 Then
		$menuon = 1
		GUICtrlSetData($label1,$charname&' was last seen at position '&Floor($mario_x)&', '&Floor($mario_y)&' while being '&$mood_name[$mood])
		GUICtrlSetData($lbl_ipadr,'Your IP adress: '&@IPAddress1)
		GUISetState(@SW_SHOW,$win_main)
		GUISwitch($win_main)
		Do
			$msg = GUIGetMsg()
			Switch $msg
				Case $but_hidemario
					If $marhi = 1 Then
						GUISetState(@SW_HIDE,$win_main)
						GUISetState(@SW_SHOW,$win_mario)
						GUISetState(@SW_SHOW,$win_flame)
						Mario_Talk('I''m back',500)
						$marhi = 0
						GUISetState(@SW_SHOW,$win_main)
						GUICtrlSetData($but_hidemario,'Hide Mario')
					Else
						GUISetState(@SW_HIDE,$win_main)
						Mario_Talk('I''ll be back!',500)
						GUISetState(@SW_HIDE,$win_mario)
						GUISetState(@SW_HIDE,$win_flame)
						$marhi = 1
						GUISetState(@SW_SHOW,$win_main)
						GUICtrlSetData($but_hidemario,'Show Mario')
					EndIf
				Case $but_exit
					Exit
				Case $but_joacama
					_IECreate("www.madflame991.blogspot.com", 1, 1, 0)
				Case $but_google
					_IECreate('http://www.google.com/search?q='&GUICtrlRead($inp_search),1,1,0)
				Case $but_youtube
					_IECreate('http://www.youtube.com/results?search_query='&GUICtrlRead($inp_search),1,1,0)
				Case $but_wikipedia
					_IECreate('http://en.wikipedia.org/wiki/Search?search='&GUICtrlRead($inp_search),1,1,0)
				Case $but_refresh
					If $opt_marioimgadr <> GUICtrlRead($com_theme) Then
						$opt_marioimgadr = GUICtrlRead($com_theme)
						LoadChar()
						$mood = Random(1,$nmood,1)
						RecreateMarioWin()
					EndIf
					If GUICtrlRead($chk_mariotop) = 1 Then
						$opt_mariontop = 1
						RecreateMarioWin()
					Else
						$opt_mariontop = 0
						RecreateMarioWin()
					EndIf
					If GUICtrlRead($chk_menutop) = 1 Then
						$opt_menutop = 1
					Else
						$opt_menutop = 0
					EndIf
					If GUICtrlRead($chk_startup) = 1 Then
						$opt_autostart = 1
					Else
						$opt_autostart = 0
					EndIf
					SaveSets()
				Case $but_showcap
					If $opt_butcap = 1 Then
						$opt_butcap = 0
						GUICtrlSetData($but_showcap,'Show Capture Button')
						GUIDelete($win_cap)
					Else
						$opt_butcap = 1
						GUICtrlSetData($but_showcap,'Hide Capture Button')
						CreateCapWindow()
					EndIf
				Case $but_chagecapadr
					$opt_adrcap = FileSelectFolder('Choose a directory where the screenshots will be stored','')
					GUICtrlSetData($inp_capadr,$opt_adrcap)
				Case $but_opencapadr
					Run('explorer.exe '&$opt_adrcap)
				Case $but_setadr
					$opt_adrcap = GUICtrlRead($inp_capadr)
			EndSwitch
			If _GUICtrlTab_GetCurSel($tab) = 0 Then 
				$colopickactive = 1
			Else
				$colopickactive = 0
			EndIf
			If ($colopickactive = 1) And ($colopause = 0) Then
				$mpos=MouseGetPos()
				$colm = PixelGetColor($mpos[0],$mpos[1])
				If $colm <> $ocolm Then 
					GUICtrlSetBkColor($lbl_colo[1],$colm)
					GUICtrlSetData($lbl_colo[0],'X: '&$mpos[0]&', Y: '&$mpos[1]&', RGB: ('&_ColorGetRed($colm)& _
					','&_ColorGetGreen($colm)&','&_ColorGetBlue($colm)&') Hex: 0x'&Hex($colm,6))
					$ocolm = $colm
				EndIf
			EndIf	
		Until ($msg = $GUI_EVENT_CLOSE) Or ($msg = $but_hidemenu)
		GUISetState(@SW_HIDE,$win_main)
		$menuon = 0
		Opt('GUIOnEventMode',1)
	EndIf
EndFunc