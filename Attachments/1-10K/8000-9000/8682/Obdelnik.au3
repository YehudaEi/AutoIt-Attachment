#Compiler_Icon=obdelnik.ico

#include <Constants.au3>
#include <GUIConstants.au3>

Const $HTCAPTION = 2
Const $WM_NCLBUTTONDOWN = 0xA1

Const $RGN_AND = 1
Const $RGN_OR = 2
Const $RGN_XOR = 3
Const $RGN_DIFF = 4
Const $RGN_COPY = 5

Opt("GUIOnEventMode",1)
Opt("TrayAutoPause",0)
Opt("TrayMenuMode",1) ; no default menu (Paused/Exit)

If @Compiled Then 
	$ico = @ScriptName
	$ico_id = 0
Else
	$ico = "obdelnik.ico"
	$ico_id = -1
EndIf

$pripona = StringRight(@ScriptName, 4) ; .exe nebo .au3
$ini = StringReplace(@ScriptName,$pripona,'.ini')

$iniZobrazitObdelnik = IniRead($ini, "Nastaveni", "ZobrazitObdelnik", "1")
$visible = $iniZobrazitObdelnik
$iniRozliseni = IniRead($ini, "Nastaveni", "Rozliseni", "800x600")
$iniRozliseni = StringSplit($iniRozliseni,'x')
If @error Then
	$iniRozliseni = '800x600'
	$iniRozliseni = StringSplit($iniRozliseni,'x')
EndIf
$iniSirkaOkraje = IniRead($ini, "Nastaveni", "SirkaOkraje", "4")
$iniBarvaOkraje = IniRead($ini, "Nastaveni", "BarvaOkraje", "0x000000")
$iniUkladatPozici = IniRead($ini, "Nastaveni", "UkladatPozici", "0")
$PoziceX = IniRead($ini, "Nastaveni", "PoziceX", "0")
$PoziceY = IniRead($ini, "Nastaveni", "PoziceY", "0")

$ZobrazitItem = TrayCreateItem("Zobrazit/Skrýt")
TrayItemSetState($ZobrazitItem,$TRAY_DEFAULT)
TrayCreateItem("")
$Item640 = TrayCreateItem("640 x 480",-1,-1,1)
$Item800 = TrayCreateItem("800 x 600",-1,-1,1)
$Item1024 = TrayCreateItem("1024 x 768",-1,-1,1)
$Item1280 = TrayCreateItem("1280 x 1024",-1,-1,1)
$Item1600 = TrayCreateItem("1600 x 1200",-1,-1,1)
TrayCreateItem("")
$NastaveniItem = TrayCreateItem("Nastavení")
TrayItemSetState($NastaveniItem ,$TRAY_DISABLE)
$OAplikaciItem = TrayCreateItem("O aplikaci")
TrayCreateItem("")
$KonecItem = TrayCreateItem("Konec")
TraySetIcon($ico)
TraySetState()
TraySetClick(8) ; Pressing secondary mouse button

TrayItemSetState(Eval('Item' & $iniRozliseni[1]), $TRAY_CHECKED)

$about = GuiCreate("O aplikaci",210,150,-1,-1,BitOR($WS_CAPTION,$WS_SYSMENU)) ;$WS_EX_TOOLWINDOW
GUISetIcon($ico, $ico_id, $about)
GUISetOnEvent ($GUI_EVENT_CLOSE, "OAplikaciOK" )
GUICtrlCreateIcon ($ico,$ico_id,11,11)
GUICtrlCreateLabel ("Obdélník 1.1",59,11,135,20)
GUICtrlSetFont (-1,10, 800, 0, "Arial") ; bold
GUICtrlCreateLabel ("(c) 2006" & @CRLF & @CRLF & "Petr Zedník",59,30,135,40)
$email = GUICtrlCreateLabel ("petr.zednik@volny.cz",59,70,135,15)
GuiCtrlSetFont($email, 8.5, -1, 4) ; underlined
GuiCtrlSetColor($email,0x0000ff)
GuiCtrlSetCursor($email,0)
GUICtrlSetOnEvent(-1, "OAplikaciEmail")
$www = GUICtrlCreateLabel ("www.volny.cz/petr.zednik/",59,85,135,15)
GuiCtrlSetFont($www, 8.5, -1, 4) ; underlined
GuiCtrlSetColor($www,0x0000ff)
GuiCtrlSetCursor($www,0)
GUICtrlSetOnEvent(-1, "OAplikaciWWW")
GUICtrlCreateButton ("OK",65,115,75,23,BitOr($GUI_SS_DEFAULT_BUTTON, $BS_DEFPUSHBUTTON))
GUICtrlSetState (-1, $GUI_FOCUS)
GUICtrlSetOnEvent(-1, "OAplikaciOK")

$gui = GUICreate("Obdélník", $iniRozliseni[1], $iniRozliseni[2], $PoziceX, $PoziceY, $WS_POPUP, BitOR($WS_EX_TOPMOST,$WS_EX_TOOLWINDOW))
GUISetOnEvent ($GUI_EVENT_PRIMARYDOWN, "Drag" )
GUISetBkColor($iniBarvaOkraje)
ZmenaRozliseni($iniRozliseni[1], $iniRozliseni[2])
If $iniZobrazitObdelnik = '1' Then GUISetState(@SW_SHOW, $gui)

While 1
    $msg = TrayGetMsg()
    Select
        Case $msg = $ZobrazitItem
            Zobrazit()
        Case $msg = $Item640 
			ZmenaRozliseni(640,480)
        Case $msg = $Item800 
			ZmenaRozliseni(800,600)
        Case $msg = $Item1024 
			ZmenaRozliseni(1024,768)
        Case $msg = $Item1280 
			ZmenaRozliseni(1280,1024)
        Case $msg = $Item1600
			ZmenaRozliseni(1600,1200)
        Case $msg = $NastaveniItem 
            Nastaveni()
        Case $msg = $OAplikaciItem
            OAplikaci()
        Case $msg = $KonecItem
			Ukonceni()
    EndSelect
WEnd

Exit

Func Zobrazit()
	MouseUp("primary") ; osetreni chyby pri doubleclick na default tray ikone & Drag
	
	$visible = Not $visible
	
	If $visible Then
		GUISetState(@SW_SHOW, $gui)
	Else
		GUISetState(@SW_HIDE, $gui)
	EndIf
EndFunc

Func ZmenaRozliseni($sirka, $vyska)
	TraySetToolTip('Obdélník ' & $sirka & ' x ' & $vyska)
	
	WinMove($gui, "", Default, Default, $sirka, $vyska)
	_GuiHole($gui, $iniSirkaOkraje, $iniSirkaOkraje, $sirka - 2 * $iniSirkaOkraje, $vyska - 2 * $iniSirkaOkraje)
EndFunc

Func _GuiHole($h_win, $i_x, $i_y, $i_sizew, $i_sizeh)
	Dim $pos, $outer_rgn, $inner_rgn, $wh, $combined_rgn
	$pos = WinGetPos($h_win)
   
	$outer_rgn = DllCall("gdi32.dll", "long", "CreateRectRgn", "long", 0, "long", 0, "long", $pos[2], "long", $pos[3])
	$inner_rgn = DllCall("gdi32.dll", "long", "CreateRectRgn", "long", $i_x, "long", $i_y, "long", $i_x + $i_sizew, "long", $i_y + $i_sizeh)
	$combined_rgn = DllCall("gdi32.dll", "long", "CreateRectRgn", "long", 0, "long", 0, "long", 0, "long", 0)
	DllCall("gdi32.dll", "long", "CombineRgn", "long", $combined_rgn[0], "long", $outer_rgn[0], "long", $inner_rgn[0], "int", $RGN_DIFF)
	DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $h_win, "long", $combined_rgn[0], "int", 1)
EndFunc

Func Nastaveni()
EndFunc

Func OAplikaci()
	GUISetState(@SW_SHOW, $about)
EndFunc

Func OAplikaciOK()
	GUISetState(@SW_HIDE, $about)
EndFunc

Func OAplikaciEmail()
	Run(@ComSpec & " /c " & 'start mailto:petr.zednik@volny.cz?subject=Obdelnik', "", @SW_HIDE)
EndFunc

Func OAplikaciWWW()
	Run(@ComSpec & " /c " & 'start www.volny.cz/petr.zednik/', "", @SW_HIDE)
EndFunc

Func Ukonceni()
	If $iniUkladatPozici = '1' Then
		; pokud se zmenila poloha okna, tak to zapsat do INI souboru
		; pozn: toto nemuze byt v OnAutoItExit, protoze v tom okamziku uz je okno zavrene
		$pos = WinGetPos($gui)
		If @error <> 1 Then
			If $PoziceX <> $pos[0] Then IniWrite($ini, "Nastaveni", "PoziceX", $pos[0])
			If $PoziceY <> $pos[1] Then IniWrite($ini, "Nastaveni", "PoziceY", $pos[1])
		EndIf
	EndIf

	Exit
EndFunc

Func Drag()
    dllcall("user32.dll","int","ReleaseCapture")
    dllcall("user32.dll","int","SendMessage","hWnd", $gui,"int",$WM_NCLBUTTONDOWN,"int", $HTCAPTION,"int", 0)
EndFunc
