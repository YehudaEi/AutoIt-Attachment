Opt("WinWaitDelay",500)
Opt("WinTitleMatchMode",4)
Opt("WinDetectHiddenText",1)

#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Excel.au3>

#Region ### START Koda GUI section ### Form=c:\documents and settings\administrator\my documents\form2222.kxf
Global $Form1_1 = GUICreate("DueBa progres report", 347, 298, 277, 200)
Global $Group2 = GUICtrlCreateGroup("Settings", 16, 15, 310, 240)

Global $Label1 = GUICtrlCreateLabel("Isuue #", 35, 34, 65, 17)
GLOBAL $Input1 = GUICtrlCreateInput("", 104, 30, 209, 21)

Global $Label2 = GUICtrlCreateLabel("File Name", 35, 64, 65, 17)
GLOBAL $Input2 = GUICtrlCreateInput("DeuBa Progress Report.xls", 104, 60, 209, 21)

Global $Label3 = GUICtrlCreateLabel("CIRATS view", 35, 94, 65, 17)
GLOBAL $Input3 = GUICtrlCreateInput("DtD", 104, 90, 209, 21)


Global $Label4 = GUICtrlCreateLabel("Sheet", 35, 124, 65, 17)
GLOBAL $Input4 = GUICtrlCreateInput("A391", 104, 120, 209, 21)

Global $Label5 = GUICtrlCreateLabel("Path", 35, 154, 65, 17)
GLOBAL $Input5 = GUICtrlCreateInput("Z:\Documents\DeuBa Progress Report.xls", 104, 150, 209, 21)

Global $Label6 = GUICtrlCreateLabel("", 35, 184, 65, 17)
GLOBAL $Input6 = GUICtrlCreateInput("", 104, 180, 209, 21)


global $CHECKBOX = GUICtrlCreateCheckbox("Attachment(s)",104,210,209,21)




Global $RUN = GUICtrlCreateButton("RUN", 28, 240, 289, 25, $WS_GROUP)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

;Globalni promenne, jsou nastaveny v radcich 66-72
Global $issues_count=""
Global $action_plan=""
Global $cirats=""
Global $sheet=""
Global $path=""
Global $attach=""
Global $file=""


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $Form1_1
		#Case $SET
		Case $RUN
			$issues_count=GUICtrlRead($Input1, 1)
			$action_plan=GUICtrlRead($Input6, 1)
			$cirats=GUICtrlRead($Input3, 1)
			$sheet =GUICtrlRead($Input4, 1)
			$path = GUICtrlRead($Input5, 1)
			$file = GUICtrlRead($Input2, 1)
			$attach = GUICtrlRead($CHECKBOX, 0)
			_main()
			ExitLoop
	EndSwitch
WEnd

func _main()
   If Not WinActive("CIRATS v2 DeuBA IMT Germany - "&$cirats&" - IBM Lotus Notes","") Then WinActivate("CIRATS v2 DeuBA IMT Germany - "&$cirats&" - IBM Lotus Notes","")
   WinWaitActive("CIRATS v2 DeuBA IMT Germany - "&$cirats&" - IBM Lotus Notes","")
   
   For $i=1 To $issues_count Step 1
	  Send("{SPACE}{DOWN}")
   Next
   
   ;;Global $i=0
   ;;While $i<$issues_count
	  ;;Send("{SPACE}{DOWN}")
	  ;;$i+=1
   ;;WEnd
  
   ;Copy issues to clipboard
   ;;Send("{ALTDOWN}")
   ;;Sleep(200)
   ;;Send("{E}{ALTUP}")
   ;;Sleep(500)
   ;;Send("{DOWN 3}{RIGHT}")
   ;;Sleep(500)
   ;;Send("{ENTER}")
   Sleep(2000)
   MouseClick("secondary",500,400,0)
   Sleep(1000)
   MouseClick("primary",600,510)
   Sleep(1000)
      
   ;Transferring issues to new Excel file
   If WinExists("Microsoft Excel - "&$file,"") Then 
	  WinActivate("Microsoft Excel - "&$file,"")
   Else
	  Local $oExcel = _ExcelBookOpen($path)
	  WinWaitActive("Microsoft Excel - "&$file,"")
	  Send("{ESC}")
   EndIf
   Send("{CTRLDOWN}n{CTRLUP}")
   WinWaitActive("Microsoft Excel - Book")
   Send("{CTRLDOWN}v{CTRLUP}")
   
   ;Deleting empty columns
   Send("{LEFT}{SHIFTDOWN}{RIGHT 3}{CTRLDOWN}{DOWN}{CTRLUP}{SHIFTUP}")
   Send("{ALTDOWN}e{ALTUP}{DOWN 8}{ENTER}")
   Send("{HOME}")
   
   ;Creating Autofilter in the first row
   Send("{SHIFTDOWN}{RIGHT 20}{SHIFTUP}")
   Send("{ALTDOWN}d{ALTUP}{DOWN}{RIGHT}{ENTER}")
   Send("{HOME}")
   
   ;Adding vlookup function
   Send("{CTRLDOWN}{RIGHT}{CTRLUP}{RIGHT}{DOWN}")
   Send("{ALTDOWN}i{ALTUP}f")
   Sleep(200)
   Send("vlookup")
   Send("{ENTER 2}")
   WinWaitActive("Function Arguments")
   ;Waiting for inserting data to vlookup
   WinWaitClose("Function Arguments")
   
   ;Replication of vlookup to all issues
   Global $a=0
   While $a<$issues_count-1
	  Send("{DOWN}{CTRLDOWN}d{CTRLUP}")
	  $a+=1
   WEnd
   
EndFunc
