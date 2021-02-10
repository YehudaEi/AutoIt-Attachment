
#include <GUIConstantsEx.au3>
#include <Sound.au3>

;Opt('MustDeclareVars', 1)
global $Read , $read2, $Input_1, $Input_2




    Local $tab, $tab0, $tab0OK, $input, $button1, $button_s2, $button3, $button4, $button5 , $button6
    Local $tab1, $tab1combo, $tab1OK, $input2, $button11, $button21, $button31, $button41, $button51, $button61, $button13
    Local $tab2, $tab2OK, $msg , $input3, $button111, $button211, $button311, $button411, $button511, $button611, $input4
	Local $tab4 , $button_s4
	Local $guimsg, $startport_nr, $slutport_nr, $kortnr, $kortnr2
	local $Input_01, $Input_02, $Input_03, $Button_01, $Button_02, $Button_03

	local $Input_B1, $Input_B2, $Input_B3, $Button_B1, $Button_B2, $Button_B3, $Button_Bstart, $Button_Bpause, $Button_Bstop
	LOCAL $Interval_B1, $Interval_B2, $gentagelse_B1


	local $gentag, $Interval, $train, $i, $pause, $Interval2
	local $soundstart, $soundnew, $soundpause, $soundwaning, $soundslut
	
    GUICreate("interval training", 500, 400); will create a dialog box that when displayed is centered

    GUISetBkColor(0x00E0FFFF)
    GUISetFont(9, 300)
	$soundstart = ("c:/hjertetrainer/start.wav")
	$soundpause = ("c:/hjertetrainer/pause.wav")
	$soundnew = ("c:/hjertetrainer/skift.wav")
	$soundwaning = ("c:/hjertetrainer/30sek.wav")
	$soundslut = ("c:/hjertetrainer/slut.wav")
	
    $tab = GUICtrlCreateTab(0, 0 ,500, 400)


   


		
		
		

    $tab1 = GUICtrlCreateTabItem("interval")
		GUICtrlCreateLabel ( "music nr 1",50, 50, 100, 20) 
		$Input_B1 = GUICtrlCreateInput("", 180, 50, 200, 20)
		$Button_B1 = GUICtrlCreateButton("...", 420, 50, 20, 20)
		GUICtrlCreateLabel ( "music nr 2",50, 100, 100, 20) 
		$Input_B2 = GUICtrlCreateInput("", 180, 100, 200, 20)
		$Button_B2 = GUICtrlCreateButton("...", 420, 100, 20, 20)
		GUICtrlCreateLabel ( "music nr 3",50, 150, 100, 20) 
		$Input_B3 = GUICtrlCreateInput("", 180, 150, 200, 20)
		$Button_B3 = GUICtrlCreateButton("...", 420, 150, 20, 20) 
		GUICtrlCreateLabel ("activ time", 50,200, 170, 20)
		$Interval_B1 = GUICtrlCreateCombo("2,0 min",180, 200,75, 20)
		GUICtrlSetData(-1 , "0,5 min|1,0 min|1,5 min|2,5 min|3,0 min|5,0 min")
		GUICtrlCreateLabel (" pause time", 50, 250, 170, 20)   
		$Interval_B2 = GUICtrlCreateCombo("0,5 min",180, 250,75, 20)
		GUICtrlSetData(-1 , "0,25 min|1,0 min |1,5 min|2,5 min|3,0 min")
		$gentagelse_B1 = GUICtrlCreateCombo("    5",180, 300,75, 20)
		GUICtrlSetData(-1 , "    2|    3|    4|    5|    6|    7|    8|    9|   10 ")
		GUICtrlCreateLabel ("no. of repeet ", 50,300, 170, 20) 
		$Button_Bstart = GUICtrlCreateButton("Play", 400, 330, 60, 60)
		$Button_Bpause = GUICtrlCreateButton("Pause", 150, 350, 60)
		$Button_Bstop = GUICtrlCreateButton("Stop", 250, 350, 60)
		GUICtrlSetState($Button_Bstart, $GUI_DISABLE)
		GUICtrlSetState($Button_Bpause, $GUI_DISABLE)
		GUICtrlSetState($BUtton_Bstop, $GUI_DISABLE)

		$Read_B = GUICtrlRead($Input_B1)
		$Read_B2 = GUICtrlRead($Input_B2)
		$Read_B3 = GUICtrlRead($Input_B3)
  
    
   


GUISetState()
While 1
$guimsg = GuiGetMsg()

Select
	Case $guimsg = $GUI_EVENT_CLOSE
	Exit ; closes the GUI

	
	Case $guimsg = $Button_B1
		$Opened_File = FileOpenDialog("Open Music File", "", "All Music Files (*.wav;*.avi;*.mp3)|All Files (*.*)",12)
        GUICtrlSetData($Input_B1, $Opened_File)
        GUICtrlSetState($Button_Bstart, $GUI_ENABLE)

		GUICtrlSetBkColor ($Button_Bstart, 0x00ff00)
		gUICtrlSetBkColor ($Button_Bstop, 0xff0000)
		gUICtrlSetBkColor ($Button_Bpause, 0xff0000)

	Case $guimsg = $button_B2
		$Opened_File = FileOpenDialog("Open Music File", "", "All Music Files (*.wav;*.avi;*.mp3)|All Files (*.*)",12)
        GUICtrlSetData($Input_B2, $Opened_File)
        

	Case $guimsg = $button_B3
		$Opened_File = FileOpenDialog("Open Music File", "", "All Music Files (*.wav;*.avi;*.mp3)|All Files (*.*)",12)
        GUICtrlSetData($Input_B3, $Opened_File)   


	Case $guimsg = $Button_Bstart
		SoundSetWaveVolume(100)
		
		$Read_B = GUICtrlRead($Input_B1)
		SoundSetWaveVolume (50)
		$hMusic_handle1 = _SoundOpen($Read_B)
		_SoundPlay($hMusic_handle1)
		
		GUICtrlSetState($Button_Bpause, $GUI_ENABLE)
		GUICtrlSetState($BUtton_Bstop, $GUI_ENABLE)
		gUICtrlSetBkColor ($Button_Bstop, 0x00ff00)
		gUICtrlSetBkColor ($Button_Bpause, 0x00ff00)
		gUICtrlSetBkColor ($Button_Bstart, 0x00ffff)
		
		$train = GUICtrlRead($Interval_B1)
		if $train = "0,5 min" then
		  $Interval = 30000
		ElseIf $train = "1 min" then
		  $Interval = 60000
		ElseIf $train = "1,5 min" Then
		  $Interval = 90000
		ElseIf $train = "2,5 min" Then
		  $Interval = 150000
		ElseIf $train = "3,0 min" Then 
		 $Interval = 180000
		ElseIf $train = "2,0 min" Then
		  $Interval = 120000
		ElseIf $train = "5,0 min" Then 
		 $Interval = 300000
		 		 
			 EndIf 
			 
		$pause = gUICtrlRead($Input_B2)
		if $pause = "0,25 min" then
		  $Interval2 = 15000
		ElseIf $pause = "0,5 min" then 
		  $Interval2 = 30000
		ElseIf $pause = "1,0 min" then
		  $Interval2 = 60000
		ElseIf $pause = "1,5 min" Then
		  $Interval2 = 90000
		ElseIf $pause = "2,5 min" Then
		  $Interval2 = 150000
		ElseIf $pause = "3,0 min" Then 
		 $Interval2 = 180000
				EndIf
		 
		 
		$gentag = GUICtrlRead($gentagelse_B1)
	
		Sleep (2000)
		$i = 0
		Do
			
		$hstart = _soundOpen($soundstart)
		_soundplay($hstart)
		Sleep ($Interval)
		
		
		
		$hpause = _SoundOpen($soundpause)
		_soundplay ($hpause)
		
		Sleep ($Interval2)
		
		
		

		
		$i = $i + 1
		Until $i = $gentag
	
	$hslut = _SoundOpen($soundslut)
	_soundplay($hslut)
	
	Sleep (2000)	
	_SoundClose ($hMusic_handle1)
		
	    
		

		
		

EndSelect
WEnd



