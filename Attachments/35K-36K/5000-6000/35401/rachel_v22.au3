; AutoIt 3.0.103 example
; 17 Jan 2005 - CyberSlug
; This script shows manual positioning of all controls;
;   there are much better methods of positioning...
#include <GuiConstantsEx.au3>
#include <AVIConstants.au3>
#include <TreeViewConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Excel.au3>
#include <Excel_udf.au3>
#include <Array.au3>




SplashTextOn("", "Ouverture de Rachel en cours, merci de patienter ...", 450, 70, -1, -1, 0 + 1 + 16 + 32, "Times New Roman", 12, 800)
$oExcel= _ExcelBookOpen("\\\\my documents\toto2.xls",1,True)
$oExcel2= _ExcelBookOpen("\\my documents\toto1.xls",0,True)
$oExcel3= _ExcelBookOpen("\\my documents\toto.xls",0,True)

If $oExcel.ActiveSheet.AutoFilterMode Then $oExcel.ActiveSheet.AutoFilterMode = False
If $oExcel2.ActiveSheet.AutoFilterMode Then $oExcel2.ActiveSheet.AutoFilterMode = False
If $oExcel3.ActiveSheet.AutoFilterMode Then $oExcel3.ActiveSheet.AutoFilterMode = False

GuiCreate("Rachel")
GuiSetIcon(@SystemDir & "\mspaint.exe", 0)
GUISetBkColor(0x00E0FFFF)

	$font = "Comic Sans MS"
	$font2 = "Verdana"



; TAB
GuiCtrlCreateTab(0, 0, 410, 410)
GuiCtrlCreateTabItem("Base SP")
GUISetFont(9, 400, 1, $font2)
$Input1 = GUICtrlCreateInput("", 112, 30, 121, 21)
$Button1 = GUICtrlCreateButton("OK", 250, 30, 25, 20)
GUISetFont(9, 400, 4, $font)
$Label1 = GUICtrlCreateLabel("Class:", 8, 30, 91, 17)

GUISetFont(9, 400, 1, $font2)
$Input2= GUICtrlCreateInput("", 112, 80, 121, 21)
$Button2 = GUICtrlCreateButton("OK", 250, 80, 25, 20)
GUISetFont(9, 400, 4, $font)
$Label2 = GUICtrlCreateLabel("Package:", 8, 84, 91, 17)

GUISetFont(9, 400, 1, $font2)
$Input3= GUICtrlCreateInput("", 112, 144, 121, 21)
$Button3 = GUICtrlCreateButton("OK", 250, 144, 25, 20)
GUISetFont(9, 400, 4, $font)
$Label3 = GUICtrlCreateLabel("Indicateur:", 8, 144, 91, 17)

GUISetFont(9, 400, 1, $font2)
$Input4 = GUICtrlCreateInput("", 112, 208, 121, 21)
$Button4 = GUICtrlCreateButton("OK", 250, 208, 25, 20)
GUISetFont(9, 400, 4, $font)
$Label4 = GUICtrlCreateLabel("Action Auto:", 8, 212, 91, 17)


$ButtonFilter = GUICtrlCreateButton("Nouvelle Recherche", 27, 270, 120,21)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###



GuiCtrlCreateTabItem("Ref_File")
GUISetFont(9, 400, 1, $font2)
$Input5 = GUICtrlCreateInput("", 112, 30, 121, 21)
$Button5 = GUICtrlCreateButton("OK", 250, 30, 25, 20)
GUISetFont(9, 400,4, $font)
$Label5 = GUICtrlCreateLabel("Network:", 8, 30, 91, 17)

GUISetFont(9, 400, 1, $font2)
$Input6 = GUICtrlCreateInput("", 112, 80, 121, 21)
$Button6 = GUICtrlCreateButton("OK", 250, 80, 25, 20)
GUISetFont(9, 400, 4, $font)
$Label6= GUICtrlCreateLabel("Systeme:", 8, 84, 91, 17)

$Label7= GUICtrlCreateLabel("Package:", 8, 154, 91, 17)
GUISetFont(9, 400, 1, $font2)
$Input7 = GUICtrlCreateInput("", 112, 150, 180, 21,$ES_READONLY)



    GUICtrlCreateTabItem(""); end tabitem definition


    GUISetState()

GUISetState(@SW_SHOW)

SplashOff()

While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE
				MsgBox(0, "Rachel_Search", "Merci de votre visite")
				SplashTextOn("", "Fermeture de Rachel en cours, merci de patienter ...", 450, 70, -1, -1, 0 + 1 + 16 + 32, "Times New Roman", 12, 800)
				_ExcelBookClose ($oExcel2)
				_ExcelBookClose ($oExcel)
				_ExcelBookClose ($oExcel3)
				SplashOff()
				ExitLoop
			Case $msg = $Button1
				$class = GUICtrlRead($Input1)
				Chercher();Recherche par class
			Case $msg = $Button2
				$package = GUICtrlRead($Input2)
				Chercher2();Recherche par Package
			Case $msg = $Button3
				$indicateur = GUICtrlRead($Input3)
				Chercher3();Recherche par indicateur
			Case $msg = $Button4
				$alarme = GUICtrlRead($Input4)
				Chercher4();Recherche par actions Auto
			Case $msg = $Button5
				$network = GUICtrlRead($Input5)
				Chercher5();Recherche par nom d'équipements réseau,
			Case $msg = $Button6
				$system = GUICtrlRead($Input6)
				Chercher6();Recherche par nom de serveur
			Case $msg = $ButtonFilter
				If $oExcel.ActiveSheet.AutoFilterMode Then $oExcel.ActiveSheet.AutoFilterMode = False

		EndSelect
	WEnd
	Exit



	Func Chercher()
Local $search_cell = $oExcel.Columns("A:AS").Find($class)
If( IsObj($search_cell) = 1 ) Then ; Si la recherche à abouti
	_ExcelFilter ($oExcel,6,3,3,($class))
Else
    MsgBox(0, "Find failed", "La recherche de "&Chr(34)&$class&Chr(34)&" n'a rien donné" )
EndIf

EndFunc

Func Chercher2()
Local $search_cell = $oExcel.Columns("A:AS").Find($package)
If( IsObj($search_cell) = 1 ) Then ; Si la recherche à abouti
	_ExcelFilter ($oExcel,6,1,1,($package))
Else
    MsgBox(0, "Find failed", "La recherche de "&Chr(34)&$package&Chr(34)&" n'a rien donné" )
EndIf

EndFunc

Func Chercher3()
Local $search_cell = $oExcel.Columns("A:AS").Find($indicateur)
If( IsObj($search_cell) = 1 ) Then ; Si la recherche à abouti
	_ExcelFilter ($oExcel,6,15,15,($indicateur))
Else
    MsgBox(0, "Find failed", "La recherche de "&Chr(34)&$indicateur&Chr(34)&" n'a rien donné" )
EndIf

EndFunc

Func Chercher4()
Local $search_cell = $oExcel.Columns("A:AS").Find($alarme)
If( IsObj($search_cell) = 1 ) Then ; Si la recherche à abouti
	_ExcelFilter ($oExcel,6,33,33,($alarme))
Else
    MsgBox(0, "Find failed", "La recherche de "&Chr(34)&$alarme&Chr(34)&" n'a rien donné" )
EndIf

EndFunc
;Recherche dans l'inventaire ServicePilot Réseaux le nom de l'équipement et affiche le package affecté
	Func Chercher5()
Local $search_cell = $oExcel2.Columns("F:F").Find($network)
If( IsObj($search_cell) = 1 ) Then ; Si la recherche à abouti
	;MsgBox(0, "Find failed", "La recherche de "&Chr(34)&$package2&Chr(34)&" n'a rien donné" )
	  ;MsgBox(0, "Find success", "La recherche de "&Chr(34)&$hostname&Chr(34)&" dans la plage donne la cellule ("&$search_cell.Row &";"&$search_cell.Column&")"  )
	  $package3 = $oExcel2.Cells($search_cell.Row,3).Value
	  $package4 = stringsplit ($package3 ,".pac")
	  $package2 = $package4[1]
	  GUICtrlSetData ( $input7, $package2)
	  GUICtrlSetData ( $input2, $package2)
	  ;MsgBox(0, "Find failed", "La recherche de "&Chr(34)&$package2&Chr(34)&" n'a rien donné" )
Else
    MsgBox(0, "Find failed", "La recherche de "&Chr(34)&$network&Chr(34)&" n'a rien donné" )
EndIf
EndFunc
;Recherche dans l'inventaire ServicePilot Systeme la machine et affiche le package affecté
	Func Chercher6()
Local $search_cell = $oExcel3.Columns("F:F").Find($system)
If( IsObj($search_cell) = 1 ) Then ; Si la recherche à abouti
	  $package3 = $oExcel3.Cells($search_cell.Row,3).Value
	  $package4 = stringsplit ($package3 ,".pac")
	  $package2 = $package4[1]
	  GUICtrlSetData ( $input7, $package2)
	  GUICtrlSetData ( $input2, $package2)
	  ;MsgBox(0, "Find failed", "La recherche de "&Chr(34)&$package2&Chr(34)&" n'a rien donné" )
Else
    MsgBox(0, "Find failed", "La recherche de "&Chr(34)&$system&Chr(34)&" n'a rien donné" )
EndIf
EndFunc





; GUI MESSAGE LOOP
;GuiSetState()
;While GuiGetMsg() <> $GUI_EVENT_CLOSE
;WEnd
