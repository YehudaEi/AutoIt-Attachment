;Mame 0.64 Front End
;Kaillera P2P v0r6 - Nov 02
;Place IP list in ip.txt with a | seperating each one, do the same with game names in games.txt * note game names must be exact. 
#include <GUIConstants.au3>
HotKeySet("{END}", "Terminate")
HotKeySet("{HOME}", "Returna")

GUICreate("P2P FE MAME32k 0.64", 220, 140)
	$ip = FileOpen("ip.txt", 0) 
	$line2 = FileReadLine($ip)
	$n2 = GUICtrlCreateCombo ("Enter IP Address", 10,35)
	GUICtrlSetData(-1, $line2)
	$gamelist = FileOpen("games.txt", 0)
	$line = FileReadLine($gamelist)
	$n1     = GUICtrlCreateCombo ("Enter Game Name", 10,10)
		GUICtrlSetData(-1, $line)
		Opt("GUICoordMode",2)
	$button_1 = GUICtrlCreateButton ("Host",  10, 50, 50)
	$button_2 = GUICtrlCreateButton ( "Join",  0, -1) 
	$button_3 = GUICtrlCreateButton ("Cancel", 0, -1)
	$public = GUICtrlCreateCheckbox ("Enlist in waiting games list", -150, 1, "200")
	$record = GUICtrlCreateCheckbox ("Record", -200, -4, "200")
	$ctrlread = GUICtrlRead($n1)
	$IPname = GUICtrlRead($n2)


GUICtrlSetState(-1, $GUI_FOCUS)	

GUISetState () 

	Do
    $msg = GUIGetMsg()
		If $msg = $button_3 Then Exit 0 
		If $msg = $button_2 Then
		$IPname = GUICtrlRead($n2)
		$xum = 70 
		$yum = 10 
		$hoco = "&Connect"
		$edita = "Edit4"
		$ctrlread = GUICtrlRead($n2)
		$HC = "Ho&st"
		$but = "Button6"
		$msg = $GUI_EVENT_MAXIMIZE
		Runscript()
		ExitLoop
		
    EndIf
		If $msg = $button_1 Then 
		WinSetState ( "P2P FE", "", @SW_MINIMIZE )
		
		$gamename = GUICtrlRead($n1)
		$xum = 20
		$yum = 5
		$edita = "Edit3"
		$hoco = "Ho&st"
		$ctrlread = GUICtrlRead($n1)
		$HC = "Ho&st"
		$but = "Button5"
		$msg = $GUI_EVENT_MAXIMIZE
		Runscript()
		ExitLoop
    EndIf
	If $msg = $GUI_EVENT_CLOSE Then
		    	ProcessClose("mame32k.exe")
		ProcessClose("kailleraclient.dll")
	Exit 0
		 EndIf
	Until $msg = $GUI_EVENT_MAXIMIZE


		

Func Returna()
	WinSetState ("MAME32k", "", @SW_SHOW)
			ProcessClose("mame32k.exe")
		ProcessClose("kailleraclient.dll")
		run("p2pfe.exe")
		Exit
	EndFunc	

	
Func Terminate()
	WinSetState ("MAME32k", "", @SW_SHOW)
    	ProcessClose("mame32k.exe")
		ProcessClose("kailleraclient.dll")
			Exit
		EndFunc
		
Func RunScript()
	Run("mame32k.exe")	
		WinSetState ("MAME32k", "", @SW_HIDE)
	WinWait("MAME32k", "")
    If Not WinActive("MAME32k", "") Then WinActivate("MAME32k", "")
		WinWaitActive("MAME32k", "")
	Opt("WinTitleMatchMode", 2)
		WinSetTrans("MAME32k", "", 200)
	ControlFocus ("MAME32k", "", "SysListView321")
		ControlClick("MAME32k", "", "SysListView321", "right", 1)
		Send("n")
	$title2 = WinGetTitle("", "")
		ControlFocus ($title2, "", "ComboBox1")
		ControlClick ($title2, "", "ComboBox1")
		ControlSend ($title2, "", "ComboBox1", "1")
		$title = WinGetTitle("n02", "")
	WinWait($title, "")
	If Not WinActive($title, "") Then WinActivate($title, "")
		WinWaitActive($title, "")
	ControlFocus ($title, "", "ComboBox1")
		ControlClick ($title, "", "ComboBox1")
		ControlSend ($title, "", "ComboBox1", "1")
	WinWait($title, "")
	If Not WinActive($title, "") Then WinActivate($title, "")
		WinWaitActive($title, "")
	ControlFocus ( $title, $hoco, "SysTabControl321")
		ControlClick($title, $hoco, "SysTabControl321", "left", 1, $xum, $yum)
	ControlFocus ( $title, "", $edita)
		ControlSetText ($title, "", $edita, $ctrlread  )
	ControlFocus ( $title, $hoco, "SysTabControl321")
		ControlClick($title, "&Connect", "SysTabControl321", "left", 1, 20, 5)
	ControlFocus ($title, $HC, $but)
		ControlClick ($title, $HC, $but)
	WinWait("Connection Window", "")
		ControlClick ("Connection Window", "", "Button2")
		If GUICtrlRead($public, 0) = $GUI_CHECKED then
			ControlClick ("Connection Window", "", "Button8")
		Else
	EndIf
	If GUICtrlRead($record, 0) = $GUI_CHECKED then
			ControlClick ("Connection Window", "", "Button3")
		Else
	
			EndIf
		$gamename = GUICtrlRead (GUICtrlRead($n1))
	WinWaitActive($gamename)
		WinSetState ("MAME32k", "", @SW_SHOW )
		WinSetState ($gamename, "", @SW_SHOWMAXIMIZED )
		EndFunc