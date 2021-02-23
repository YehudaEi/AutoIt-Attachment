; =============================================================================
;  LibTCC UDF Example 2 (2011.8.1)
;  Purpose: Demonstrate How To Call C Function By "CallWindowProc" API
;  Author: Ward
; =============================================================================

#Include <Memory.au3>
#Include "LibTCC.au3"
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>
#include <Date.au3>
;~ FileChangeDir("C:\Program Files\Microsoft Platform SDK for Windows Server 2003 R2\include")

Opt('MustDeclareVars', 1)

Global $nCurCol = -1
Global $nSortDir = 1
Global $bSet = 0
Global $nCol = -1

;TestAutoIt()
Test()

Func TCC_Error($Opaque, $ErrorMessage)
	MsgBox(16, "LibTCC UDF Error", $ErrorMessage)
	Exit
EndFunc

Func TestAutoIt()


	Local $listview, $button, $item1, $item2, $item3, $input1, $msg

    GUICreate("listview items", 620, 500, 100, 200)
    GUISetBkColor(0x00E0FFFF)  ; will change background color


	 $listview = GUICtrlCreateListView("col1      |col2       ", 10, 10, 600, 500);,$LVS_SORTDESCENDING)
	 GUICtrlRegisterListViewSort(-1, "LVSort") ; Register the function "SortLV" for the sorting callback
    $button = GUICtrlCreateButton("Value?", 75, 170, 70, 20)
	for $ii = 1 to 5000
    $item1 = GUICtrlCreateListViewItem($ii & "item2|"&$ii&"item4", $listview)

	Next
    $input1 = GUICtrlCreateInput("", 20, 200, 150)
    GUICtrlSetState(-1, $GUI_DROPACCEPTED)   ; to allow drag and dropping
    GUISetState()


While 1
        $msg = GUIGetMsg()
        Switch $msg
			Case $GUI_EVENT_CLOSE

                ExitLoop

            Case $listview
                $bSet = 0
                $nCurCol = $nCol


                GUICtrlSendMsg($listview, $LVM_SETSELECTEDCOLUMN, GUICtrlGetState($listview), 0)
                DllCall("user32.dll", "int", "InvalidateRect", "hwnd", GUICtrlGetHandle($listview), "int", 0, "int", 1)
;~ 				ConsoleWrite("Took " & TimerDiff($timer) & " to sort " & @crlf)
        EndSwitch
    WEnd
GUIDelete()

EndFunc

Func Test()
	Local $C = FileRead("ListViewSortLite.c")

	Local $listview, $button, $item1, $item2, $item3, $input1, $msg



    GUICreate("listview items sort in C", 620, 550, 100, 200)
    GUISetBkColor(0x00E0FFFF)  ; will change background color


 $listview = GUICtrlCreateListView(" 1 to 5000            |     5000 to 1         |  random text  | random date", 10, 10, 600, 500);,$LVS_SORTDESCENDING)
	; GUICtrlRegisterListViewSort(-1, "LVSort") ; Register the function "SortLV" for the sorting callback
    ;$button = GUICtrlCreateButton("Value?", 75, 170, 70, 20)
	for $ii = 1 to 100
		local $randomtext

			$randomtext = Random(1,5000,1)

;~ 			of one the following:
;~ D - Add number of days to the given date
;~ M - Add number of months to the given date
;~ Y - Add number of years to the given date
;~ w - Add number of Weeks to the given date
;~ h - Add number of hours to the given date
;~ n - Add number of minutes to the given date
;~ s - Add number of seconds to the given date
			local $Date[7] = ["D","M","Y","w","h","n","s"]

			local $randomdate = _DateAdd($Date[Random(1,6,1)],Random(1,512,1),_NowCalcDate())
		$randomdate = _DateTimeFormat($randomdate,0)
		 $item1 = GUICtrlCreateListViewItem($ii & "item2|"&($randomtext-$ii)&"item4 |" & $randomtext & "|" & $randomdate , $listview)

	Next

    GUISetState()

	Local $TCC = TCC_New()
	TCC_Add_Include_Path($TCC, @ScriptDir & "\include")
	TCC_Add_Include_Path($TCC, @ScriptDir & "\include\winapi")
	TCC_Add_Include_Path($TCC, @ScriptDir & "\include\crt")
	TCC_Add_Library_Path($TCC, @ScriptDir & "\lib")

	TCC_Add_Library($TCC, "user32")
	TCC_Add_Library($TCC, "kernel32")

	TCC_Set_Error_Func($TCC, 0, DllCallbackGetPtr(DllCallbackRegister("TCC_Error", "none:cdecl", "ptr;str")))

	TCC_Compile_String($TCC, $C)

	Local $Size = TCC_Relocate($TCC, 0)
	Local $CodeBuffer = _MemVirtualAlloc(0, $Size, $MEM_COMMIT, $PAGE_EXECUTE_READWRITE)
	TCC_Relocate($TCC, $CodeBuffer)

	Local $Ptr = TCC_Get_Symbol($TCC, "_ListViewSortInC@16")

local $Reverse = 0
While 1
        $msg = GUIGetMsg()
        Switch $msg
            Case $GUI_EVENT_CLOSE
                ExitLoop

            Case $listview
                $bSet = 0
                $nCurCol = $nCol
				local $timer = TimerInit()
				$Reverse = Not $Reverse
				Local $Ret = DllCall("user32.dll", "uint", "CallWindowProc", "ptr", $Ptr, _
													"int", 0, _
													"hwnd", GUICtrlGetHandle($listview), _
													"int", $Reverse, _
													"int", GUICtrlGetState($listview))

				ConsoleWrite("Sorting on column " & GUICtrlGetState($listview) &  " Reverse " & $Reverse & " Took " & TimerDiff($timer) & " to sort " & @crlf)

        EndSwitch
    WEnd



	_MemVirtualFree($CodeBuffer, 0, $MEM_RELEASE)
	TCC_Delete($TCC)
EndFunc

