#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         TnTProductions

 Script Function:
	pointless beginer script that calcualtes income and gives rationg... enjoy

#ce ----------------------------------------------------------------------------
;;;;;;;;;;;;;;; Financial Statues Operator V1.3 beta ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;By: ∆TnT Productions∆;;;;;;;;;;;;;
;;;;;;;;;;;;;;(copyright)2008 of ∆TnT Productions∆;;;;;;;;;;;;;;
#include <GUIConstants.au3>
GUICreate(" Financial Statues Operator V1.3 BETA", 800,600)
$A = GUICtrlCreateInput ( "Money Earned pr week", 10, 25, 300, 20)
$B = GUICtrlCreateInput ("How many weeks", 10, 55, 300, 20)
$C = GUICtrlCreateInput ("Exspenses pr week", 10, 85, 300, 20)
$Calc = GUICtrlCreateButton ("Calculate", 10, 120, 100, 30)
$Result = GuiCtrlCreateListView("Number|Earned pr. Week|Number of Weeks|Exspenses pr. Weeks|Total Exspenses|Total Income|Savings|Your Rating", 10, 200,780,300)
GUISetState ()
$number = 1

$msg = 0
While $msg <> $GUI_EVENT_CLOSE
$msg = GUIGetMsg()
Select
Case $msg = $Calc
_Calculate()
$number = $number +1
EndSelect
Wend

Func _Calculate()
$money = GUICtrlRead($A)
$weeks = GUICtrlRead($B)
$expense = GUICtrlRead($C)

$Totalexpenses = ($weeks*$expense)
$income = ($money*$weeks) ; your income
$savings = ($income-$Totalexpenses)

Select
Case $income <= 10000
$rating = "burger flipper" ; finacial ratings do not touch
Case 10000 < $income and $income <= 20000
$rating = "minimum wage" ; finacial ratings do not touch
Case 20000 < $income and $income <= 40000
$rating = "college education" ; finacial ratings do not touch
Case 40000 < $income and $income <= 75000
$rating = "master education" ; finacial ratings do not touch
Case $income > 75000
$rating = "P.H.D education" ; finacial ratings do not touch
EndSelect

GuiCtrlCreateListViewItem($number & "|" & $money & "|" & $weeks & "|" & $expense & "|" & $Totalexpenses & "|" & $income & "|" & $savings & "|" & $rating , $Result)
GUICtrlSetData($A,"Money Earned pr week")
GUICtrlSetData($B,"How many weeks")
GUICtrlSetData($C,"Exspenses pr week")

EndFunc ; _Calculate()



