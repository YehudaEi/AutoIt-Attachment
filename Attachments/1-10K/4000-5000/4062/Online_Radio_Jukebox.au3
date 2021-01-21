#include <GUIConstants.au3>
#include <Array.au3>
;#include <GuiCombo.au3>

opt("GUIOnEventMode", 1)
Global $popAdd
Global $hwndActive
Global Const $CB_RESETCONTENT = 0x14B

$oMyError = ObjEvent("AutoIt.Error","Quit")
$oMediaplayer = ObjCreate("WMPlayer.OCX.7")    

If Not IsObj($oMediaplayer) Then Exit
$oMediaplayer.Enabled = true
$oMediaplayer.WindowlessVideo= true
$oMediaPlayer.UImode="invisible"
$oMediaPlayControl=$oMediaPlayer.Controls
$oMediaPlaySettings=$oMediaPlayer.Settings 

;Load skin 
Dim $s_TempFile
$bmp = _TempFile()
;FileInstall("..\Images\gui_2.bmp", $bmp) ;images directory
FileInstall ("gui_2.bmp",$bmp)
$bmp2 = $bmp

$caption = "Online Radio Jukebox"

$gui = GUICreate("Online Radio Jukebox", 230,150, -1, -1, $WS_POPUP + $WS_SYSMENU + $WS_MINIMIZEBOX, $WS_EX_LAYERED)
GUISetOnEvent($GUI_EVENT_CLOSE, "Close")

$caption = GUICtrlCreateLabel($caption, 12, 4, 180, 14)
GUICtrlSetStyle($caption, -1, $WS_EX_TRANSPARENT)
GUICtrlSetStyle($caption, $DS_SETFOREGROUND)
GUICtrlSetFont($caption, 9, 400, -1, "Arial Bold")
GUICtrlSetColor($caption, 0xffd700)
GUICtrlSetOnEvent($caption, "_Drag")

$min = GUICtrlCreateLabel("", 198, 4, 11, 11)
GUICtrlSetOnEvent($min, "Minimize")
GUICtrlSetTip($min, "Minimize")

$close = GUICtrlCreateLabel("", 210, 4, 11, 11)
GUICtrlSetOnEvent($close, "Close")
GUICtrlSetTip($close, "Close")

$combo_name = GuiCtrlCreateCombo("Choose your RadioStation", 13, 30, 153, 20)
GUICtrlSetOnEvent(-1, "ComboEvent")
GUICtrlSetStyle(-1, -1, $WS_EX_TRANSPARENT)

;original line
;GuiCtrlSetData($combo_name, "Real Rock 101.1|Studio Brussel|Donna|Q-Music|4Fm|Contact|C-Dance|TopRadio|SkyRadio|Tmf|Noordzee|Veronica|BNN-Fm|Be-One|Oradio|Colorado")

;read from ini line.
GuiCtrlSetData($combo_name, ReadStation() )

$Volume = GuiCtrlCreateSlider( 13, 77, 152, 20)
GUICtrlSetStyle(-1, -1, $WS_EX_TRANSPARENT)
$VolLevel = $oMediaPlaySettings.Volume
GUICtrlSetData(-1, $VolLevel)
GUICtrlSetOnEvent(-1, "SliderEvent")

GuiCtrlCreateLabel("Volume", 73, 62, 40, 20)
GUICtrlSetStyle(-1, -1, $WS_EX_TRANSPARENT)
GUICtrlSetColor(-1, 0xff)

$Play = GuiCtrlCreateButton("Play", 175, 30, 45, 22)
GUICtrlSetStyle($Play, -1, $WS_EX_TRANSPARENT)
GUICtrlSetOnEvent($Play, "Play")

$Stop = GuiCtrlCreateButton("Stop", 175, 55, 45, 22)
GUICtrlSetStyle($Stop, -1, $WS_EX_TRANSPARENT)
GUICtrlSetOnEvent($Stop, "Stop")

$Load = GUICtrlCreateButton("Load", 175, 80, 45, 22)
GUICtrlSetStyle($Load, -1, $WS_EX_TRANSPARENT)
GUICtrlSetOnEvent($Load, "Load")

$Add = GuiCtrlCreateButton("Add",50,105,45,22)
GUICtrlSetStyle($Add, -1, $WS_EX_TRANSPARENT)
GUICtrlSetOnEvent($Add, "Add")

$Delete = GuiCtrlCreateButton("Delete",105,105,45,22)
GUICtrlSetStyle($Delete, -1, $WS_EX_TRANSPARENT)
GUICtrlSetOnEvent($Delete, "Delete")

$pic = GUICtrlCreatePic($bmp, 0, 0, 230, 150)
GUICtrlSetOnEvent($pic, "_Drag")

$contextmenu = GUICtrlCreateContextMenu($pic)
$min_item = GUICtrlCreateMenuItem("Min", $contextmenu)
GUICtrlSetOnEvent($min_item, "Minimize")

$close_item = GUICtrlCreateMenuItem("Close", $contextmenu)
GUICtrlSetOnEvent($close_item, "Close")
GUICtrlCreateMenuItem("", $contextmenu)

$about_item = GUICtrlCreateMenuItem("About", $contextmenu)
GUICtrlSetOnEvent($about_item, "About")

$add_item = GUICtrlCreateMenuItem("Add", $contextmenu)
GUICtrlSetOnEvent($Add_item, "Add")

$del_item = GUICtrlCreateMenuItem("Delete", $contextmenu)
GUICtrlSetOnEvent($Add_item, "Delete")

;set variable for drag func.
$hwndActive = $gui

GUISetState(@SW_SHOW)

While 1
    Sleep(1000)
WEnd


; user function here.
Func About()
    GUISetState(@SW_HIDE)
	SplashTextOn("About", "Online Radio Jukebox" & @CRLF & "Made with Autoit" & @CRLF & "Listen to Online Radio" & @CRLF & "Play your mp3/wma" & @CRLF & "Boenders Jos"& @CRLF & "Enhancements by Stephen Podhajecki", 190, 160, -1, -1, 1, "", 12)
    Sleep(10000)
    SplashOff()
    GUISetState(@SW_SHOW)
EndFunc

Func Close()
    GUISetState(@SW_HIDE)
    FileDelete($bmp)
    Exit
EndFunc

Func Minimize()
    GUISetState(@SW_MINIMIZE)
EndFunc

Func _TempFile()
    Local $s_TempName
    
    Do
        $s_TempName = "~"
        While StringLen($s_TempName) < 7
            $s_TempName = $s_TempName & Chr(Round(Random(65, 90), 0))
        WEnd
        $s_TempName = @TempDir & "\" & $s_TempName & ".tmp"
    Until Not FileExists($s_TempName)
    Return ($s_TempName)
EndFunc

Func _Drag()
    DllCall("user32.dll", "int", "ReleaseCapture")
	 ;modified to use global variable to handle more than 1 window. Replaced $gui with global $hwndActive
    DllCall("user32.dll", "int", "SendMessage", "hWnd", $hwndActive, "int", 0xA1, "int", 2, "int", 0)
EndFunc

Func Play()
    $oMediaPlayControl.Play
EndFunc

Func Stop()
    $oMediaPlayControl.Stop
EndFunc

Func Load()
    $media = FileOpenDialog("Offline Radio Jukebox", " {20D04FE0-3AEA-1069-A2D8-08002B30309D} ", "Media (*.wma;*.mp3)" ,1)
        $oMediaPlayer.URL = $media
EndFunc

;Func for adding a url to ini file
Func Add()
	GUISetState(@SW_DISABLE, $gui)
	Popup_Edit("ADD")
	ResetMain()
EndFunc

;func for deleteing an entry in the ini file.
Func Delete()
	GUISetState(@SW_DISABLE, $gui)
	Popup_Edit("DEL")
	ResetMain()
EndFunc
	  

;Function for exiting the app
Func ExitEvent()
	
    Exit
EndFunc

;Close last GUI window
Func OnClose()
    GUIDelete()
EndFunc

;event function modified to use ini file
Func ComboEvent()
	
       $Radio = GuiCtrlRead($combo_name)
		 ;this line reads the ini file.
		 $oMediaPlayer.URL = IniRead(@scriptdir&"\orj.ini",$Radio,"URL","")
		        
EndFunc

Func SliderEvent()
        If GUICtrlread($Volume) <> $VolLevel Then
            $oMediaPlaySettings.Volume = GUICtrlRead($Volume)
            $VolLevel = GUICtrlRead($Volume)
        EndIf
EndFunc

; read the ini file and add to combo box.
Func	ReadStation()
		if FileExists(@scriptdir&"\orj.ini") Then
			$aCombo_List = IniReadSectionNames(@scriptdir&"\orj.ini")
			;build string for combobox, start at [1] because [0] contains count.
			$sCombo_Stations = _ArrayToString($aCombo_List, "|",1,"")
			return $sCombo_Stations
		Else
			msgbox(4096,"Error","Could not locate config file.",0)
			Exit
		EndIf
EndFunc


;write station to inifile.
Func WriteStation($sRadio,$sURL)
	IniWrite(@scriptdir&"\orj.ini",$sRadio,"URL",$sURL)
EndFunc


;change gui back and reload combo box
Func ResetMain()
	GUISetState(@SW_ENABLE, $gui)
	opt("GUIOnEventMode", 1)
	GUISetState(@SW_SHOW)
	$hwndActive = $gui
	
	GUICtrlSendMsg($combo_name, $CB_RESETCONTENT, 0, 0)
	ControlSetText ( "Online Radio Jukebox", "", $combo_name, "Choose your RadioStation" )
	GuiCtrlSetData($combo_name, ReadStation())
	
EndFunc



; this function handles add and delete based on the value passed to it.
Func Popup_Edit($orjcmd)  ;; valid commands are "ADD" and "DEL"
	;change to message mode so gui can be closed.  I couldn't get this qui to work in event mode.
opt("GUIOnEventMode", 0)

$popAdd = GuiCreate("Online Radio Jukebox", 300 ,150,(@DesktopWidth-300)/2, (@DesktopHeight-150)/2,$WS_POPUP + $WS_SYSMENU + $WS_MINIMIZEBOX, $WS_EX_LAYERED)
$caption2 = GUICtrlCreateLabel("Online Radio Jukebox", 12, 4, 180, 14)
GUICtrlSetStyle($caption2, -1, $WS_EX_TRANSPARENT)
GUICtrlSetStyle($caption2, $DS_SETFOREGROUND)
GUICtrlSetFont($caption2, 9, 400, -1, "Arial Bold")
GUICtrlSetColor($caption2, 0xffd700)

$close2 = GUICtrlCreateLabel("", 281, 4, 11, 11)
GUICtrlSetTip($close2, "Close")

; setup buttons based on the command.
if $orjcmd ="ADD" Then
	
	$lAddURL = GuiCtrlCreateLabel("Add Url", 115, 25, 40, 20)
	GUICtrlSetStyle(-1, -1, $WS_EX_TRANSPARENT)
	GUICtrlSetColor(-1, 0xff)
	
	$lName = GuiCtrlCreateLabel("Name", 10, 40, 40, 20)
	GUICtrlSetStyle(-1, -1, $WS_EX_TRANSPARENT)
	GUICtrlSetColor(-1, 0xff)
	
	$iStation_Name= GuiCtrlCreateInput("", 50, 40, 230, 20)
	GUICtrlSetTip($iStation_Name,"Enter the station name.")
	GUICtrlSetStyle(-1, -1, $WS_EX_TRANSPARENT)
	
	$lURL = GuiCtrlCreateLabel("URL", 10, 70, 30, 20)
	GUICtrlSetStyle(-1, -1, $WS_EX_TRANSPARENT)
	GUICtrlSetColor(-1, 0xff)
	
	$iStation_URL = GuiCtrlCreateInput("", 50, 70, 230, 20)
	GUICtrlSetTip($iStation_URL,"Enter the full URL.")
	GUICtrlSetStyle(-1, -1, $WS_EX_TRANSPARENT)
	
	$btnOK = GuiCtrlCreateButton("OK", 50, 110, 90, 30)
   GUICtrlSetStyle($btnOK, -1, $WS_EX_TRANSPARENT)
	GUICtrlSetState($btnOK,$GUI_DISABLE)
	
Else
	$lDelete =GuiCtrlCreateLabel("Delete Url", 110, 25, 80, 20)
	GUICtrlSetStyle(-1, -1, $WS_EX_TRANSPARENT)
	GUICtrlSetColor(-1, 0xff)
	
	$lName = GuiCtrlCreateLabel("Name", 10, 40, 40, 20)
	GUICtrlSetStyle(-1, -1, $WS_EX_TRANSPARENT)
	GUICtrlSetColor(-1, 0xff)
	
	$combo_Station = GuiCtrlCreateCombo("Choose Station To Remove", 50, 40, 230, 20)
	GUICtrlSetStyle(-1, -1, $WS_EX_TRANSPARENT)
	GuiCtrlSetData($combo_Station, ReadStation() )
	
	$lURL = GuiCtrlCreateLabel("URL", 10, 70, 30, 20)
	GUICtrlSetStyle(-1, -1, $WS_EX_TRANSPARENT)
	GUICtrlSetColor(-1, 0xff)
	
	$lStation_URL =GuiCtrlCreatelabel ("", 50, 70, 230, 25,$SS_SUNKEN)
	GUICtrlSetStyle(-1, -1, $WS_EX_TRANSPARENT)
	
	$btnDel = GuiCtrlCreateButton("Delete", 50, 110, 90, 30)
   GUICtrlSetStyle($btnDel, -1, $WS_EX_TRANSPARENT)
	GUICtrlSetState($btnDEL,$GUI_DISABLE)
	
	
EndIf

$btnCANCEL = GuiCtrlCreateButton("Cancel/Exit", 160, 110, 90, 30)
GUICtrlSetStyle($btnCANCEL, -1, $WS_EX_TRANSPARENT)

$pic2 = GUICtrlCreatePic($bmp2, 0, 0, 300, 150)
$hwndActive = $popAdd
GuiSetState()
	
While 1
        $msg2 = GUIGetMsg()
			
		Select
			; both commands common gui buttons and events
			Case $msg2 = $btnCANCEL or $msg2=$GUI_EVENT_CLOSE or $msg2 = $close2
					ExitLoop
			Case $msg2= $caption2 or $msg2= $pic2
					_Drag()
			Case Else
				;Buttons ADD and Delete are only created when respective command is called.
				;So we need to test for command in order to prevent error;
				 If $orjcmd ="ADD"Then
					 ;keep Ok button disabled until both boxes have data.
						If GUICtrlRead($iStation_Name)<> "" and GUICtrlRead($iStation_URL) <> "" Then
							If GUICtrlGetState($btnOK) <> $GUI_ENABLE+$GUI_SHOW Then GUICtrlSetState($btnOK,$GUI_ENABLE)
						Else
							;If either box is empty then keep ok disabled									
							If GUICtrlGetState($btnOK) <> $GUI_DISABLE+$GUI_SHOW Then GUICtrlSetState($btnOK,$GUI_DISABLE)								
						EndIf
					;for Add command buttons 
				Select
					Case $msg2 = $btnOK
				      WriteStation(GUICtrlRead($iStation_Name),GUICtrlRead($iStation_URL))
						GUICtrlSetData($iStation_Name,"") 
				      GUICtrlSetData ($iStation_URL,"")
				      GUICtrlSetState($btnOK,$GUI_DISABLE)
					EndSelect
				Else
					IF $orjcmd ="DEL" Then
						; Keep delete key of until a station is selected 
						If GUICtrlRead($lStation_URL)= "" and GUICtrlGetState($btnDEL) <> $GUI_DISABLE+$GUI_SHOW Then
							GUICtrlSetState($btnDEl,$GUI_DISABLE)
						ElseIf guictrlread($lStation_URL)<> "" and GUICtrlGetState($btnDEL) <> $GUI_ENABLE+$GUI_SHOW Then
							GUICtrlSetState($btnDEl,$GUI_ENABLE)
						EndIf
					;for Delete commamd buttons
				Select 
					Case $msg2 = $combo_Station
						GUICtrlSetData($lStation_URL,IniRead(@scriptdir&"\orj.ini",GuiCtrlRead($combo_Station),"URL",""))
					Case $msg2= $btnDel
						IniDelete(@scriptdir&"\orj.ini",GuiCtrlRead($combo_Station))
						GUICtrlSendMsg($combo_Station, $CB_RESETCONTENT, 0, 0)
						GuiCtrlSetData($combo_Station, ReadStation() )
						GUICtrlSetData($lStation_URL,"")
					EndSelect
				EndIf
			EndIf
	EndSelect
WEnd

;kill the gui and return to main.			
	GuiDelete($popAdd)
EndFunc
