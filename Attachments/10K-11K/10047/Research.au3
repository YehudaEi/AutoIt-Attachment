#include <GUIConstants.au3>
GUICreate("Research", 300, 360, -1, -1)

GUICTRLCreateLabel("First type what you want to search for in the space below. Then check which search programs you want to use.", 10, 10, 290, 40)
$text = GUICtrlCreateInput("Write what you want to research here...", 10, 42, 280, 20)

$ask = GUICtrlCreateCheckbox("Ask.com", 25, 70, 120, 20)
	GuiCtrlSetState(-1, $GUI_CHECKED)
$dictionary = GUICtrlCreateCheckbox("Dictionary.com", 25, 100, 120, 20)
	GuiCtrlSetState(-1, $GUI_CHECKED)
$encyclopedia = GUICtrlCreateCheckbox("Encyclopedia.com", 25, 130, 120, 20)
	GuiCtrlSetState(-1, $GUI_CHECKED)
$google = GUICtrlCreateCheckbox("Google.com", 25, 160, 120, 20)
	GuiCtrlSetState(-1, $GUI_CHECKED)
$howstuffworks = GUICtrlCreateCheckbox("Howstuffworks.com", 25, 190, 120, 20)
	GuiCtrlSetState(-1, $GUI_CHECKED)
$reference = GUICtrlCreateCheckbox("Reference.com", 25, 220, 120, 20)
	GuiCtrlSetState(-1, $GUI_CHECKED)
$wikipedia = GUICtrlCreateCheckbox("Wikipedia.org", 25, 250, 120, 20)
	GuiCtrlSetState(-1, $GUI_CHECKED)
$yahoo = GUICtrlCreateCheckbox("Yahoo.com", 25, 280, 120, 20)
	GuiCtrlSetState(-1, $GUI_CHECKED)
$button1 = GuiCtrlCreateButton("Research Topic", 8, 320, 284, 30)
	GuiCtrlSetState(-1, $GUI_CHECKED)
;$button2 = Send("{enter}")

GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE 
			ExitLoop
		Case $msg = $button1 ;or $button2
			$path = Run("C:\Program Files\Mozilla Firefox\firefox.exe")
				Run(@ComSpec & " /c " & $path, "", @SW_HIDE)
				Opt("WinTitleMatchMode", 2)
				WinWait("Mozilla Firefox")
				WinSetState("Mozilla Firefox", "", @SW_MAXIMIZE)
			If BitAnd(GUICtrlRead($ask),$GUI_CHECKED) = $GUI_CHECKED then Ask()
			If BitAnd(GUICtrlRead($dictionary),$GUI_CHECKED) = $GUI_CHECKED then Dictionary()
			If BitAnd(GUICtrlRead($encyclopedia),$GUI_CHECKED) = $GUI_CHECKED then Encyclopedia()
			If BitAnd(GUICtrlRead($google),$GUI_CHECKED) = $GUI_CHECKED then Google()
			If BitAnd(GUICtrlRead($howstuffworks),$GUI_CHECKED) = $GUI_CHECKED then Howstuffworks()
			If BitAnd(GUICtrlRead($reference),$GUI_CHECKED) = $GUI_CHECKED then Reference()
			If BitAnd(GUICtrlRead($wikipedia),$GUI_CHECKED) = $GUI_CHECKED then Wikipedia()
			If BitAnd(GUICtrlRead($yahoo),$GUI_CHECKED) = $GUI_CHECKED then Yahoo()
		Send("^w")
		GUIDelete()
	Exit
	Endselect
WEnd
Exit

Func Ask()
		Send("                   {enter}")
		$load = FFLoadWait(140, 60, 1)
		If $Load = 1 Then
		Else
		Send(GuiCtrlRead($text))
		Send("{enter}")
		Sleep(5000)
		Send("^t")
		Winwaitactive("Mozilla Firefox")
			Sleep(2000)
		Endif
	Endfunc
	
Func Dictionary()
		Send("                                {enter}")
		$load = FFLoadWait(140, 60, 1)
		If $Load = 1 Then
		Else
		Send(GuiCtrlRead($text))
		Send("{enter}")
		Sleep(5000)
		Send("^t")
		Winwaitactive("Mozilla Firefox")
			Sleep(2000)
		Endif
	Endfunc	

Func Encyclopedia()
		Send("http://encyclopedia.com/{enter}")
		$load = FFLoadWait(140, 60, 1)
		Sleep(4000)
		If $Load = 1 Then
		Else
		Send("{tab 6}")
		Send(GuiCtrlRead($text))
		Send("{enter}")
		Sleep(5000)
		Send("^t")
		Winwaitactive("Mozilla Firefox")
			Sleep(2000)
		Endif
	Endfunc

Func Google()
		Send("http://www.google.com/{enter}")
		$load = FFLoadWait(140, 60, 1)
		If $Load = 1 Then
		Else
		Send(GuiCtrlRead($text))
		Send("{enter}")
		Sleep(5000)
		Send("^t")
		Winwaitactive("Mozilla Firefox")
			Sleep(2000)
		Endif
	Endfunc

Func Howstuffworks()
		Send("http://www.howstuffworks.com/{enter}")
		$load = FFLoadWait(140, 60, 1)
		If $Load = 1 Then
		Else
		Send("{tab 4}")	
		Send(GuiCtrlRead($text))
		Send("{enter}")
		Sleep(5000)
		Send("^t")
		Winwaitactive("Mozilla Firefox")
			Sleep(2000)
		Endif
	Endfunc

Func Reference()
		Send("                         {enter}")
		$load = FFLoadWait(140, 60, 1)
		If $Load = 1 Then
		Else
		Send(GuiCtrlRead($text))
		Send("{enter}")
		Sleep(5000)
		Send("^t")
		Winwaitactive("Mozilla Firefox")
			Sleep(2000)
		Endif
	Endfunc

Func Wikipedia()
		Send("http://www.wikipedia.org/{enter}")
		$load = FFLoadWait(140, 60, 1)
		If $Load = 1 Then
		Else
		Send(GuiCtrlRead($text))
		Send("{enter}")
		Sleep(5000)
		Send("^t")
		Winwaitactive("Mozilla Firefox")
			Sleep(2000)
		Endif
	Endfunc

Func Yahoo()
		Send("                     {enter}")
		$load = FFLoadWait(140, 60, 1)
		If $Load = 1 Then
		Else
		Send(GuiCtrlRead($text))
		Send("{enter}")
		Sleep(5000)
		Send("^t")
		Winwaitactive("Mozilla Firefox")
			Sleep(500)
		Endif
	Endfunc

Func FFLoadWait ($x, $y, $pcm, $lbc = 16382455)
Opt("PixelCoordMode", $pcm)
Local $i
$iColor = 16382455
Do
$iColor = PixelGetColor($x ,$y)
If $iColor = $lbc Then
$i = 1
Else
Endif
Sleep(20)
Until $i = 1
EndFunc

