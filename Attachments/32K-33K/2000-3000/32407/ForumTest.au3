#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#Include <Icons.au3>

;;Temp includes;;
#include <array.au3>

;;;
;~ dim $array[2][2][3]
;~  $array[0][0][0]=0
;~  $array[0][0][2]=0

;~ if $array[0][0][1] Then
;~ 	$array[0][0][1]=1
;~ EndIf
;~ ConsoleWrite($array[0][0][1]+5)
;~ Exit




GUICreate("backgammon",800,600)

Global $Board[26][16][2]
Global $Piece[31][2]
Global $LocationT[26]=[376,716,658,602,545,487,430,319,262,205,148,91,34,34,91,148,205,262,319,430,487,545,602,658,716,376]
global $CheckBox[28]
global $cD1
Global $cD2

for $i=1 to 24
	for $s=0 to 15
		
$Board[$i][$s][1]=0
Next
Next



 GUICtrlCreatePic ( "BackPic.jpg", 1, 1,800,600)
 GuiCtrlSetState(-1,$GUI_DISABLE)
 GUISetState(@sw_show)
 SetTable()

$DelteInt = True

$op=0
$Dice=-1
$Dice1=-1
$progres=-2
$Tempo = 0

While 1
	WEnd

 Func SetTable() ;;First Function to set the board at starting position
 ;; Starting setting Board white first
 

 
;~  for $s=0 to 4
;~ draw("w",12,$s)
;~ Next
 for $s=0 to 1
$Board[1][$s][1]="w"
$Board[1][$s][0] = guictrlcreatepic("",720,30+40*$s)
ConsoleWrite(' SetTable ' & $Board[1][$s][0]& ' 1- '  )
$hGreen1  = _Icons_Bitmap_Load(@ScriptDir & "\white.png")
_SetHImage($Board[1][$s][0],$hGreen1 )
GuiCtrlSetState(-1,$GUI_DISABLE)
Next
 for $s=0 to 2
$Board[17][$s][1]="w"
$Board[17][$s][0] = guictrlcreatepic("",266,530-40*$s)
$hGreen1  = _Icons_Bitmap_Load(@ScriptDir & "\white.png")
_SetHImage($Board[17][$s][0],$hGreen1 )
GuiCtrlSetState(-1,$GUI_DISABLE)
Next
 for $s=0 to 4
$Board[19][$s][1]="w"
$Board[19][$s][0] = guictrlcreatepic("",430,530-40*$s)
$hGreen1  = _Icons_Bitmap_Load(@ScriptDir & "\white.png")
_SetHImage($Board[19][$s][0],$hGreen1 )
GuiCtrlSetState(-1,$GUI_DISABLE)
Next  

;; Now setting Board black
 for $s=0 to 4
$Board[13][$s][1]="b"
$Board[13][$s][0] = guictrlcreatepic("",37,530-40*$s)
$hGreen1  = _Icons_Bitmap_Load(@ScriptDir & "\black.png")
_SetHImage($Board[13][$s][0],$hGreen1 )
GuiCtrlSetState(-1,$GUI_DISABLE)
Next
 for $s=0 to 1
$Board[24][$s][1]="b"
$Board[24][$s][0] = guictrlcreatepic("",720,530-40*$s)
$hGreen1  = _Icons_Bitmap_Load(@ScriptDir & "\black.png")
_SetHImage($Board[24][$s][0],$hGreen1 )
GuiCtrlSetState(-1,$GUI_DISABLE)
Next
 for $s=0 to 2
$Board[8][$s][1]="b"
$Board[8][$s][0] = guictrlcreatepic("",266,30+40*$s)
$hGreen1  = _Icons_Bitmap_Load(@ScriptDir & "\black.png")
_SetHImage($Board[8][$s][0],$hGreen1 )
GuiCtrlSetState(-1,$GUI_DISABLE)
Next
 for $s=0 to 4
$Board[6][$s][1]="b"
$Board[6][$s][0] = guictrlcreatepic("",430,30+40*$s)
$hGreen1  = _Icons_Bitmap_Load(@ScriptDir & "\black.png")
_SetHImage($Board[6][$s][0],$hGreen1 )
GuiCtrlSetState(-1,$GUI_DISABLE)
Next  


;;Setting position check box's

$CheckBox[0] =  GUICtrlCreateCheckbox("",392 ,216,15,15)
$CheckBox[25] =  GUICtrlCreateCheckbox("",392,370,15,15)
$CheckBox[26] =  GUICtrlCreateCheckbox("",784,534,15,15)
$CheckBox[27] =  GUICtrlCreateCheckbox("",784,32,15,15)
for $i=1 to 12
	$CheckBox[$i] =  GUICtrlCreateCheckbox("",$LocationT[$i]+20,5,15,15)
Next
for $i=13 to 24
	$CheckBox[$i] =  GUICtrlCreateCheckbox("",$LocationT[$i]+20,580,15,15)

Next


EndFunc