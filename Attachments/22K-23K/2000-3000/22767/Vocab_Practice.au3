#include <GuiConstants.au3>
#include <Misc.au3>
#include <Array.au3>
#include <File.au3>
#include <Math.au3>

HotKeySet("{ENTER}","Check")
Opt("GUIOnEventMode",1)

#region GUI
$guiMain = GUICreate("Vocab Practice",400,180)
$btnBrowse = GUICtrlCreateButton("Browse",5,5,45,20)
GUISetState(@SW_SHOW,$guiMain)
$iptFile = GUICtrlCreateInput("",55,5,340,20,$ES_CENTER)
GUICtrlSetState(-1,$GUI_DISABLE)
$btnStart = GUICtrlCreateButton("Start",5,30,45,20)
GUICtrlSetState(-1,$GUI_DISABLE)
$cmbCategory = GUICtrlCreateCombo("",55,30,340,20,$CBS_DROPDOWNLIST)
GUICtrlSetState(-1,$GUI_DISABLE)
GUIStartGroup()
$chkEWord = GUICtrlCreateCheckbox("English",5,65,55,20)
GUICtrlSetState(-1,$GUI_CHECKED)
$rdoEWord = GUICtrlCreateRadio("English",5,65,55,20)
GUICtrlSetState(-1,$GUI_HIDE+$GUI_CHECKED)
$lblEWord = GUICtrlCreateLabel("",60,65,280,20,$ES_CENTER)
$chkFWord = GUICtrlCreateCheckbox("Actual",5,90,55,20)
GUICtrlSetState(-1,$GUI_CHECKED)
$rdoFWord = GUICtrlCreateRadio("Actual",5,90,55,20)
GUICtrlSetState(-1,$GUI_HIDE)
$lblFWord = GUICtrlCreateLabel("",60,90,280,20,$ES_CENTER)
GUIStartGroup()
$rdoText = GUICtrlCreateRadio("Text",340,65,55,20)
GUICtrlSetState(-1,$GUI_CHECKED)
$rdoButtons = GUICtrlCreateRadio("Buttons",340,90,55,20)
$iptWord = GUICtrlCreateInput("",5,115,390,25,$ES_CENTER)
GUICtrlSetState(-1,$GUI_DISABLE)
$btnDone = GUICtrlCreateButton("Done",175,145,50,30)
GUICtrlSetState(-1,$GUI_DISABLE)
Dim $btnChoice[5]
$btnChoice[1] = GUICtrlCreateButton("",5,115,190,25)
GUICtrlSetState(-1,$GUI_HIDE+$GUI_DISABLE)
$btnChoice[2] = GUICtrlCreateButton("",205,115,190,25)
GUICtrlSetState(-1,$GUI_HIDE+$GUI_DISABLE)
$btnChoice[3] = GUICtrlCreateButton("",5,145,190,25)
GUICtrlSetState(-1,$GUI_HIDE+$GUI_DISABLE)
$btnChoice[4] = GUICtrlCreateButton("",205,145,190,25)
GUICtrlSetState(-1,$GUI_HIDE+$GUI_DISABLE)
#endregion
#endregion

Global $Category[1][2]
Global $Foreign[1][1]
Global $English[1][1]

GUISetOnEvent($GUI_EVENT_CLOSE,"CloseWindow")

GUICtrlSetOnEvent($rdoText,"ToggleInput")
GUICtrlSetOnEvent($rdoButtons,"ToggleInput")
GUICtrlSetOnEvent($btnBrowse,"Browse")
GUICtrlSetOnEvent($btnStart,"Start")
GUICtrlSetOnEvent($btnDone,"Check")
For $i = 1 To 4
	GUICtrlSetOnEvent($btnChoice[$i],"Check")
Next
GUICtrlSetOnEvent($chkEWord,"ToggleOutput")
GUICtrlSetOnEvent($chkFWord,"ToggleOutput")
GUICtrlSetOnEvent($rdoEWord,"ToggleOutput")
GUICtrlSetOnEvent($rdoFWord,"ToggleOutput")



Do
	Sleep(2000)
Until 0


Func CloseWindow()
	Exit
EndFunc
	
Func ToggleOutput()
	If GUICtrlRead($rdoText) == $GUI_CHECKED Then
		If GUICtrlRead($chkEWord) == $GUI_CHECKED Then
			GUICtrlSetState($lblEWord,$GUI_SHOW)
		Else
			GUICtrlSetState($lblEWord,$GUI_HIDE)
		EndIf
		If GUICtrlRead($chkFWord) == $GUI_CHECKED Then
			GUICtrlSetState($lblFWord,$GUI_SHOW)
		Else
			GUICtrlSetState($lblFWord,$GUI_HIDE)
		EndIf
	EndIf
	If GUICtrlRead($rdoButtons) == $GUI_CHECKED Then
		If GUICtrlRead($rdoEWord) == $GUI_CHECKED Then
			GUICtrlSetState($lblEWord,$GUI_SHOW)
			GUICtrlSetState($lblFWord,$GUI_HIDE)
		Else
			GUICtrlSetState($lblEWord,$GUI_HIDE)
			GUICtrlSetState($lblFWord,$GUI_SHOW)
		EndIf
	EndIf
EndFunc

Func ToggleInput()
	If GUICtrlRead($rdoText) == $GUI_CHECKED Then
		$T1 = $GUI_SHOW
		$T2 = $GUI_HIDE
	ElseIf GUICtrlRead($rdoButtons) == $GUI_CHECKED Then
		$T1 = $GUI_HIDE
		$T2 = $GUI_SHOW
	EndIf
	GUICtrlSetState($iptWord,$T1)
	GUICtrlSetState($btnDone,$T1)
	GUICtrlSetState($chkEWord,$T1)
	GUICtrlSetState($chkFWord,$T1)
	GUICtrlSetState($rdoEWord,$T2)
	GUICtrlSetState($rdoFWord,$T2)
	For $i = 1 To 4
		GUICtrlSetState($btnChoice[$i],$T2)
	Next
	ToggleOutput()
EndFunc


Func Browse()
	$file = FileOpenDialog("Select the file to load","","Text files (*.txt)")
	If $file <> "" And FileExists($file) Then
		Dim $a1,$b1,$c1,$d1
		_PathSplit($file,$a1,$b1,$c1,$d1)
		GUICtrlSetData($iptFile,$c1 & $d1)
			
		GUICtrlSetData($cmbCategory,"")
		GUICtrlSetData($cmbCategory,Read($file),"Select a category")
		GUICtrlSetState($btnStart,$GUI_ENABLE)
		GUICtrlSetState($cmbCategory,$GUI_ENABLE)
	EndIf
EndFunc


Func Start()
	If GUICtrlRead($cmbCategory) == "Select a category" Then
		MsgBox(0,"Error","You must select a category.")
	Else
		GUICtrlSetState($iptWord,$GUI_ENABLE)
		GUICtrlSetState($btnDone,$GUI_ENABLE)
		For $i = 1 To 4
			GUICtrlSetState($btnChoice[$i],$GUI_ENABLE)
		Next
		GUICtrlSetState($iptWord,$GUI_FOCUS)
		New()
	EndIf
EndFunc

Func New()
	If GUICtrlRead($cmbCategory) == "All" Then 
		$c = Random(0,$Category[0][0]-1,1)
	Else
		$c = CategoryByName(GUICtrlRead($cmbCategory))-1
	EndIf
	Do
		$w = Random(0,$Category[$c+1][0]-1,1)
	Until $Foreign[$c][$w] <> GUICtrlRead($lblFWord) Or $Category[$c+1][0] == 1
	
	GUICtrlSetData($lblFWord,$Foreign[$c][$w])
	GUICtrlSetData($lblEWord,$English[$c][$w])
	SetButtons($c,$w)
EndFunc

Func SetButtons($l,$a)
	Dim $b[5]
	For $i = 1 To 4
		$b[$i] = ""
	Next     
	For $i = 1 To _Min(4,$Category[$l+1][0]-1)
		Do
			$pass = True
			$b[$i] = Random(0,$Category[$l+1][0]-1,1)
			For $n = 1 To 4
				If ($b[$i] == $b[$n] And $n <> $i And $b[$i]) Or $b[$i] == $a Then $pass = False
			Next
		Until $pass
	Next
	$b[Random(1,4,1)] = $a
	For $i = 1 To 4
		If GUICtrlRead($rdoEWord) == $GUI_CHECKED Then GUICtrlSetData($btnChoice[$i],$Foreign[$l][$b[$i]])
		If GUICtrlRead($rdoFWord) == $GUI_CHECKED Then GUICtrlSetData($btnChoice[$i],$English[$l][$b[$i]])
	Next
EndFunc


Func CategoryByName($s)
	For $i = 1 To $Category[0][0]
		If $Category[$i][1] == $s Then
			Return $i
		EndIf
	Next
EndFunc

Func Check()
	If @GUI_CtrlId >= $btnChoice[1] And @GUI_CtrlId <= $btnChoice[4] Then GUICtrlSetData($iptWord,GUICtrlRead(@GUI_CtrlId))
	If GUICtrlRead($lblFWord) == GUICtrlRead($iptWord) Or GUICtrlRead($lblEWord) == GUICtrlRead($iptWord) Then New()
	Send("{SPACE}")
	GUICtrlSetData($iptWord,"")
EndFunc

Func Read($f)
	$file = FileOpen($f,0)
	$lines = StringSplit(FileRead($file),Chr(13))
	FileClose($file)
	
	For $i = 1 To $lines[0]
		$lines[$i] = TrimE($lines[$i])
	Next
	
	$cMax = 1
	$Category[0][0] = 0
	$Category[0][1] = "Number of Categories"
	For $i = 1 To $lines[0]
		If StringLeft($lines[$i],1) == "#" Then
			$Category[0][0] += 1
			$row = $Category[0][0]
			$fl = StringTrimLeft($lines[$i],1)
			
			ReDim $Category[$row+1][2]
			$Category[$row][0] = 0
			$Category[$row][1] = $fl
			
			ReDim $Foreign[$row][$cMax]
			ReDim $English[$row][$cMax]
		EndIf
		
		If StringLeft($lines[$i],1) == ":" And $row > 0 Then
			$Category[$row][0] += 1
			$col = $Category[$row][0]
			
			If $col > $cMax Then
				$cMax = $col
				ReDim $Foreign[$row][$cMax]
				ReDim $English[$row][$cMax]
			EndIf
			
			$fl = StringSplit(StringTrimLeft($lines[$i],1),"=")
			$Foreign[$row-1][$col-1] = TrimE($fl[1])
			$English[$row-1][$col-1] = ""
			If $fl[0] > 1 Then $English[$row-1][$col-1] = TrimE($fl[2])
		EndIf
	Next
	
	$List = "Select a category|All"
	For $i = 1 To $Category[0][0]
		$List &= "|" & $Category[$i][1]
	Next
	Return $List
EndFunc; ==>Read

Func TrimE($s)
	$s = StringStripWS($s,1)
	$s = StringStripWS($s,2)
	Return $s
EndFunc