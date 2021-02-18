#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Excel.au3>
#include <Excel_udf.au3>
#include <GuiConstantsEx.au3>
#include <AVIConstants.au3>
#include <TreeViewConstants.au3>
#include <Array.au3>





$oExcel= _ExcelBookOpen("\\EXAData05\data25\informat\Perso\Commun\Projet_SUPERVISION\ServicePilot\PKG\Test2.xls",1,True)
If $oExcel.ActiveSheet.AutoFilterMode Then $oExcel.ActiveSheet.AutoFilterMode = False



#Region ### START Koda GUI section ### Form=

GUICreate("Rachel  1.0.0", 400, 400, -1, -1)
GuiSetIcon(@SystemDir & "\mstsc.exe", 0)
$Input1 = GUICtrlCreateInput("", 112, 16, 121, 21)
$Button1 = GUICtrlCreateButton("OK", 250, 16, 25, 20, $WS_GROUP)
$Label1 = GUICtrlCreateLabel("Class:", 8, 20, 91, 17)




$Input2= GUICtrlCreateInput("", 112, 80, 121, 21)
$Button2 = GUICtrlCreateButton("OK", 250, 80, 25, 20, $WS_GROUP)
$Label2 = GUICtrlCreateLabel("Package:", 8, 84, 91, 17)


$Input3= GUICtrlCreateInput("", 112, 144, 121, 21)
$Button3 = GUICtrlCreateButton("OK", 250, 144, 25, 20, $WS_GROUP)
$Label3 = GUICtrlCreateLabel("Indicateur:", 8, 144, 91, 17)


$Input4 = GUICtrlCreateInput("", 112, 208, 121, 21)
$Button4 = GUICtrlCreateButton("OK", 250, 208, 25, 20, $WS_GROUP)
$Label4 = GUICtrlCreateLabel("Action Auto:", 8, 212, 91, 17)

$ButtonFilter = GUICtrlCreateButton("Reset Filter", 27, 240, 75, 21, $WS_GROUP)
GUISetState(@SW_SHOW)

$treeTwo = GuiCtrlCreateTreeView(8, 290, 190, 80, $TVS_CHECKBOXES)
GuiCtrlCreateTreeViewItem("TreeView", $treeTwo)
GuiCtrlSetState(-1, $GUI_CHECKED)
GuiCtrlCreateTreeViewItem("Style", $treeTwo)
#EndRegion ### END Koda GUI section ###





	While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE
				MsgBox(0, "Rachel_Search", "Merci de votre visite")
				_ExcelBookClose ($oExcel)
				ExitLoop
			Case $msg = $Button1
				$class = GUICtrlRead($Input1)
				Chercher()
			Case $msg = $Button2
				$package = GUICtrlRead($Input2)
				Chercher2()
			Case $msg = $Button3
				$indicateur = GUICtrlRead($Input3)
				Chercher3()

			Case $msg = $Button4
				$alarme = GUICtrlRead($Input4)
				Chercher4()

			Case $msg = $ButtonFilter
				If $oExcel.ActiveSheet.AutoFilterMode Then $oExcel.ActiveSheet.AutoFilterMode = False

	EndSelect



	WEnd
	Exit


Func Compte()


							Local $nb_colonne = $oExcel.ActiveSheet.UsedRange.Columns.Count
	                Local $nb_ligne = $oExcel.ActiveSheet.UsedRange.Rows.Count
MsgBox (0,"debug",$nb_colonne)
MsgBox (0,"debug",$nb_ligne)
EndFunc

Func Chercher()
Local $search_cell = $oExcel.Columns("A:AS").Find($class)
If( IsObj($search_cell) = 1 ) Then ; Si la recherche à abouti
	_ExcelFilter ($oExcel,6,3,3,($class))
	MsgBox(0, "Find failed", "La recherche de "&Chr(34)&$class&Chr(34)&" n'a rien donné" )
Else
    MsgBox(0, "Find failed", "La recherche de "&Chr(34)&$class&Chr(34)&" n'a rien donné" )
EndIf

EndFunc

Func Chercher2()
Local $search_cell = $oExcel.Columns("A:AS").Find($package)
If( IsObj($search_cell) = 1 ) Then ; Si la recherche à abouti
	_ExcelFilter ($oExcel,6,1,1,($package))
	$aArray2 = _ExcelReadSheetToArray($oExcel,1,1,200,45)
	_ArrayDisplay($aArray2, "Horizontal")
Else
    MsgBox(0, "Find failed", "La recherche de "&Chr(34)&$package&Chr(34)&" n'a rien donné" )
EndIf

EndFunc

Func Chercher3()
Local $search_cell = $oExcel.Columns("A:AS").Find($indicateur)
If( IsObj($search_cell) = 1 ) Then ; Si la recherche à abouti
	_ExcelFilter ($oExcel,6,15,15,($indicateur))
	$aArray = _ExcelReadSheetToArray($oExcel,7) ;Using Default Parameters
   _ArrayDisplay($aArray, "Array using Default Parameters")

Else
    MsgBox(0, "Find failed", "La recherche de "&Chr(34)&$indicateur&Chr(34)&" n'a rien donné" )
EndIf

EndFunc

Func Chercher4()
Local $search_cell = $oExcel.Columns("A:AS").Find($alarme)
If( IsObj($search_cell) = 1 ) Then ; Si la recherche à abouti
	_ExcelFilter ($oExcel,6,32,32,($alarme))
Else
    MsgBox(0, "Find failed", "La recherche de "&Chr(34)&$alarme&Chr(34)&" n'a rien donné" )
EndIf

EndFunc



