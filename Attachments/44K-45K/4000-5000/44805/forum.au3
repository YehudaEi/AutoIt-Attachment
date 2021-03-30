#include <MsgBoxConstants.au3>
#include <GUIConstantsEx.au3>
#include <ColorConstantS.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <String.au3>
#include <file.au3>
#include <Array.au3>
#include <GuiListView.au3>
#include <GuiEdit.au3>


Global $pstool, $code, $grab, $jobsdrop, $msg, $readcode, $oMyError, $sqlCon, $NameList, $sqlRs, $code2, $desc, $OptionName, $go, $readDesc, $setmatra
Global $server = "usoXXXXX"
Global $db = "DB"
Global $username = "******"
Global $password = "*****"


;set up array for jobcodes

Global $jobs[8] = ["NULL", "0 - Administrator", "2 - Manager", "3 - Team Captain", "11 - Cashier", "13 - Reports", "21 - Field Services", "22 - Service Desk" ]
   $jobsdrop = ""
For $i = 0 To UBound($jobs) - 1
   $jobsdrop &= "|" & $jobs[$i]
Next


_Setup()
Func _Setup()
Global $NULL = "NULL"
Global $admin = "0 - Administrator"
Global $manager = "2 - Manager"
Global $TC = "3 - Team Captain"
Global $cashier = "11 - Cashier"
Global $reports = "13 - Reports"
Global $FS = "21 - Field Services"
Global $SD = "22 - Service Desk"





;create GUI
$pstool = GUICreate("PS Job Code Fixer", 400, 300, 100, 150, -1, 0x00000018)
GUICtrlCreateLabel("Enter Invalid Job Code", 140,  20)
$code = GUICtrlCreateInput("", 160, 51, 55, 22)
$grab = GUICtrlCreateButton("Lookup", 152, 88, 70, 25)

GUISetState()
   While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop

		   Case $msg = $grab
	  $readcode = GUICtrlread($code, 1)
	  MsgBox(0, "test", $readcode, 5)



$oMyError = ObjEvent("AutoIt.Error","MyErrFunc")
$sqlCon = ObjCreate("ADODB.Connection")
$sqlCon.Open("DRIVER={SQL Server};SERVER=" & $server & ";DATABASE=" & $db & ";uid=" & $username & ";pwd=" & $password & ";")
$NameList=""

If @error Then
MsgBox(0, "ERROR", "Failed to connect to the database")
Exit
Else
MsgBox(0, "Success!", "Connection to database successful!")
EndIf

$sqlRs = ObjCreate("ADODB.Recordset")
If Not @error Then
    $sqlRs.open ("select job_desc from vw_matra_merch where job = " & $readcode, $sqlCon)
	$OptionName = $sqlRs.Fields ('job_desc' ).Value
	MsgBox(0, "Record Found", "Job_desc  " & $OptionName)
	$sqlRs.MoveNext
	$sqlRs.close
 EndIf

 GUICtrlCreateLabel("Insert into PSTran", 148,  130)

GUICtrlCreateLabel("PSCode", 22, 170)
$code2 = GUICtrlCreateInput($readcode, 20, 190, 55, 22)
GuiCtrlCreateLabel("matraCode", 121, 170)
$setmatra = GUICtrlCreateCombo("", 120, 190, 104, 20)
GUICtrlSetData($setmatra, $jobsdrop)
GUICtrlCreateLabel("matraDesc", 270, 170)
$desc = GuiCtrlCreateInput($OptionName, 270, 190, 104, 20)
$go = GUICtrlCreateButton("Insert", 152, 240, 70, 25)

;second loop buttons stuff was here but i removed it because it broke the first button.



EndSelect
WEnd
Exit