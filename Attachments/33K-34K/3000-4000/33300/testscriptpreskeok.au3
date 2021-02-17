#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Excel.au3>
#include <Excel_udf.au3>


Local $plaque, $splitligne[3]

$oExcel= _ExcelBookOpen("K:\Perso\Commun\Projet_SUPERVISION\ServicePilot\PKG\TEST.xls",1)
If $oExcel.ActiveSheet.AutoFilterMode Then $oExcel.ActiveSheet.AutoFilterMode = False



#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Recherche de plaque", 258, 102, -1, -1)
$Input1 = GUICtrlCreateInput("", 112, 16, 121, 21)
$Button1 = GUICtrlCreateButton("Chercher", 27, 56, 75, 25, $WS_GROUP)
$Label1 = GUICtrlCreateLabel("Plaque a chercher", 8, 20, 91, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###



	While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE
				MsgBox(0, "Rachel_Search", "Merci de votre visite")
				ExitLoop
				;When button is pressed, label text is changed
				;to combobox value
			Case $msg = $Button1
				$menustate = GUICtrlRead($Input1)
				Chercher()
		_ExcelFilter ($oExcel,5,3,0,($menustate))
		EndSelect
	WEnd
	Exit



Func Chercher()
Local $search_cell = $oExcel.Columns("A:G").Find($menustate)
If( IsObj($search_cell) = 1 ) Then ; Si la recherche à abouti
    MsgBox(0, "Find success", "La recherche de "&Chr(34)&$menustate&Chr(34)&" dans la plage donne la cellule ("&$search_cell.Row &";"&$search_cell.Column&")"  )
Else
    MsgBox(0, "Find failed", "La recherche de "&Chr(34)&$menustate&Chr(34)&" dans la plage n'a rien donné" )
EndIf

EndFunc

