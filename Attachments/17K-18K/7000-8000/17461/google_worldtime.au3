;Special Thanks go out to SmOke_N and Nahuel and martin

#include <GUIConstants.au3>
#include <inet.au3>

$FontSize = 12
$fsize = 10
$preset1 = "Singapore"
$preset2 = "Hong Kong"
$preset3 = "Taiwan"
$preset4 = "Sydney"
$preset5 = "Melbourne, Australia"
$preset6 = "Tokyo"

GuiCreate("Google WorldClock", 550, 250, -1, -1)
$font       = "Arial Bold"
$SearchCity = GuiCtrlCreateButton("Search", 265, 11, 80, 20, $BS_DEFPUSHBUTTON)
$Input = GUICtrlCreateCombo ("", 60,11, 200)
GUICtrlSetFont (-1, $fsize, 500, 0, "Terminal") 
GUICtrlSetColor (-1, 0xFFFFFF) 
GUICtrlSetBkColor (-1, 0x000000)  
GUICtrlSetData(-1,"Angola|Andorra|Addis Ababa, Ethiopia|Adelaide, South Australia|Aden, Yemen|Afghanistan|Algiers, Algeria|American Samoa|Amman, Jordan|Amsterdam, Netherlands|Anchorage, Alaska|Ankara, Turkey|Antananarivo, Madagascar|Argentina|Asuncion, Paraguay|Athens, GA|Atlanta, GA|Atlanta, Illinois|Auckland, New Zealand|Athens, Greece|Athens, Maine|Athens, Alabama|Belize|Bolivia, North Carolina|La Paz, Bolivia|Brisbane, Australia|Brasilia, Brazil|Calgary, Alberta|Fernando de Noronha, Brazil|Newfoundland, Canada|Dhaka, Bangladesh|Darwin, Australia|Myanmar|Manaus, Amazonas|Newfoundland, New Jersey|Nova Scotia, Canada|Rio Branco|Santiago, Chile|Halifax, Nova Scotia|london, Ontario|London, Arkansas|Perth, Australia|Kamchatka, Russia|Sakhalin, Russia|Tasmania, Australia|Yakutsk, Russia|Novosobirsk, Russia|Kaliningrad, Russia|New Delhi|london, england|morocco|phoenix, az|Needles, California|Tulsa", "Tulsa")

$Input1 = GUICtrlCreateEdit("", 12, 95, 525, 125,BitOR($ES_MULTILINE,$ES_AUTOVSCROLL,$WS_VSCROLL))
GUICtrlSetFont (-1, $fsize, 500, 0, "Terminal") 
GUICtrlSetColor (-1, 0xFFFFFF) 
GUICtrlSetBkColor (-1, 0x000000)  
$SearchLabel = GuiCtrlCreateLabel("Search->", 12, 13, 45, 30)
$SearchGuide = GuiCtrlCreateLabel("<--- Type or pull down to search", 350, 13, 250, 30)
$CreatedBy = GuiCtrlCreateLabel("Created By: gesller and friends", 12, 230, 175, 30)
GUICtrlSetFont(-1, 9, 400, 0, $font)

;Preset Buttons
$PresetButton1 = GUICtrlCreateButton("Singapore", 10, 40, 85, 25)
$PresetButton2 = GUICtrlCreateButton("Hong Kong", 95, 40, 85, 25)
$PresetButton3 = GUICtrlCreateButton("Taiwan", 185, 40, 85, 25)
$PresetButton4 = GUICtrlCreateButton("Sydney", 275, 40, 85, 25)
$PresetButton5 = GUICtrlCreateButton("Melbourne", 365, 40, 85, 25)
$PresetButton6 = GUICtrlCreateButton("Tokyo", 455, 40, 85, 25)
$Copy2clipbord = GUICtrlCreateButton("Copy To Clipboard", 415, 225, 125, 25)

GUICtrlSetColor($SearchLabel, 0xff0000)
GuiCtrlCreateGroup("", 2, 0, 540, 70)
GuiSetState()

$Group1 = GUICtrlCreateGroup("Search Results", 2, 75, 540, 150)

GUICtrlCreateGroup("", 05, 20, 1, 1)
$r = GUICtrlRead($Input1)
While 1
    $msg = GuiGetMsg()
    Select
    Case $msg = $GUI_EVENT_CLOSE
        ExitLoop
    Case $msg = $Input
        $city=GUICtrlRead($Input)
    GUICtrlSetData($Input1,_GoogleTime($city))		
    Case $msg = $SearchCity
        $city=GUICtrlRead($Input)
    GUICtrlSetData($Input1,_GoogleTime($city))
    Case $msg = $PresetButton1
        $city=GUICtrlRead($preset1)
    GUICtrlSetData($Input1,_GoogleTime($preset1))	
    Case $msg = $PresetButton2
        $city=GUICtrlRead($preset2)
    GUICtrlSetData($Input1,_GoogleTime($preset2))
    Case $msg = $PresetButton3
        $city=GUICtrlRead($preset3)
    GUICtrlSetData($Input1,_GoogleTime($preset3))
    Case $msg = $PresetButton4
        $city=GUICtrlRead($preset4)
    GUICtrlSetData($Input1,_GoogleTime($preset4))
    Case $msg = $PresetButton5
        $city=GUICtrlRead($preset5)
    GUICtrlSetData($Input1,_GoogleTime($preset5))
    Case $msg = $PresetButton6
        $city=GUICtrlRead($preset6)
    GUICtrlSetData($Input1,_GoogleTime($preset6))
	Case $msg = $Copy2clipbord
	local $Input1
	ClipPut (GUICtrlRead($Input1))
	MsgBox(4096,"Thank You", "Copied To Clipboard")
    EndSelect
WEnd
;Changed to martin's function cause I like it better...
Func _GoogleTime($sCity)
    Dim $sSource[10],$n
    $ss='alt="Clock"></td><td valign=top><b>'
    $n = 0
    
    $sSource = _INetGetSource("http://www.google.com/search?hl=en&q=time+" & $sCity)
    $aSRE=StringRegExp($sSource,'<(?i)td valign=middle><(?i)b>(.*?)<(?i)/td>',3)
    If $aSRE = 1 Then
    ;FileWrite($sCity & ".tme",$sSource)
        $a = StringInStr($sSource,'alt="Clock"></td><td valign=top><b>')
        $sSource = StringMid($sSource,StringInStr($sSource,$ss) + StringLen($ss),100)
        $sSource = StringReplace($sSource,'<br><table border=0','|')
        
        $aSRE = StringSplit($sSource,'|')
        If $aSRE[0] = 1 Then
            MsgBox(4096,"Location", "NOT FOUND")
        Else
            $aSRE[1] = StringReplace($aSRE[1],'<b>','')
            Return StringReplace($aSRE[1],'</b>','')
            Return $aSRE[1]
        EndIf
    Else
        $aSRE[0] = StringReplace($aSRE[0],'<b>','')
        Return StringReplace($aSRE[0],'</b>','')
    EndIf
    
EndFunc;==>_GoogleTime()

