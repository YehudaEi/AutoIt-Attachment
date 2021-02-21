#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#include <GuiButton.au3>
#Include <Array.au3>
#include <GuiMonthCal.au3>
#include <DateTimeConstants.au3>
#include <GuiImageList.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
Dim $min, $hour, $mins, $hours, $Button1,$Button3,$MonthCal1,$path_source,$PageControl1
_Main()

Func _Main()
    Local $Combo1, $Combo2, $Combo3, $Combo4

    GUICreate('Basic launcher' ,515, 275, 211, 148)
   $PageControl1 = GUICtrlCreateTab(96, 8, 417, 265)

GUICtrlSetResizing(-1, $GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)

 $Button1 = GUICtrlCreateButton('Go',16, 112, 75, 25 , $WS_GROUP)
$TabSheet3 = GUICtrlCreateTabItem("fileopen")
$path_source = GUICtrlCreateInput("", 152, 143, 197, 21)
$Button3 = GUICtrlCreateButton( "",  209, 102, 85, 35, $WS_GROUP)

$TabSheet2 = GUICtrlCreateTabItem("timer")
    $Combo1 = GUICtrlCreateCombo('starting min', 136, 184, 145, 25)
    GUICtrlSetData(-1, '1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|49|50|51|52|53|54|55|56|57|58|59')
    $Combo2 = GUICtrlCreateCombo('starting hour', 136, 72, 145, 25)
    GUICtrlSetData(-1, '01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24')
    $Combo3 = GUICtrlCreateCombo('ending min',320, 184, 145, 25 )
    GUICtrlSetData(-1, '1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|49|50|51|52|53|54|55|56|57|58|59')
    $Combo4 = GUICtrlCreateCombo('ending hour',320, 72, 145, 25 )
    GUICtrlSetData(-1, '01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24')
$TabSheet1 = GUICtrlCreateTabItem("calendar")

GUICtrlSetState(-1,$GUI_SHOW)
$MonthCal1 = GUICtrlCreateMonthCal("", 176, 48, 271, 186)
 _GUICtrlMonthCal_SetToday($MonthCal1, @YEAR, @MON, @MDAY)
GUICtrlCreateTabItem("")

    GUISetState(@SW_SHOW)

    While 1
        $msg = GUIGetMsg()
          Select
            Case $msg = $GUI_EVENT_CLOSE
                MsgBox(0, "", "end")
                Exit


            Case  $msg =  $Combo1;Min
                IniWrite(@ScriptDir & '\.ini', 'section', '1', GUICtrlRead($Combo1))
                ConsoleWrite(GUICtrlRead($Combo1) & @CRLF)

            Case $msg =  $Combo2;Hour
                IniWrite(@ScriptDir & '\.ini', 'section', '2', GUICtrlRead($Combo2))
                ConsoleWrite(GUICtrlRead($Combo2) & @CRLF)

            Case $msg =  $Combo3;Min
                IniWrite(@ScriptDir & '\.ini', 'section', '3', GUICtrlRead($Combo3))
                ConsoleWrite(GUICtrlRead($Combo3) & @CRLF)

            Case $msg =  $Combo4;Hour
                IniWrite(@ScriptDir & '\.ini', 'section', '4', GUICtrlRead($Combo4))
                ConsoleWrite(GUICtrlRead($Combo4) & @CRLF)
            Case $msg =  $Button3

				imag()



            Case $msg =  $Button1
                GUICtrlSetData($Button1, 'Started')
                While 'Waiting'
                    $msg = GUIGetMsg()
                 Select
                 Case $msg = $GUI_EVENT_CLOSE

                 ExitLoop
                   EndSelect

                     IniWrite(@ScriptDir & '\.ini', 'section', 'calendar',GUICtrlRead($MonthCal1))
					    ConsoleWrite(GUICtrlRead($MonthCal1) & @CRLF)
                    _Function()

                    _Close()

                WEnd
          EndSelect
    WEnd
EndFunc   ;==>_Main

Func clos()
    GUICtrlSetData($Button1, 'Ending !!!')
    Sleep(13)
    $list = ProcessList($open)
    ProcessClose($list[1][1])

    Sleep(10)
    MsgBox(0, '', 'Closing everything !', 6)

EndFunc   ;==>clos
Func _Function()
    $min = IniRead('.ini', 'section', '1', '')
    $hour = IniRead('.ini', 'section', '2', '')
	$calendar = IniRead('.ini', 'section', 'calendar','')
    $open = IniRead('\.ini', 'section', 'open','')

    Sleep(50)
    If @MIN = Number($min) And @HOUR = Number($hour) And @YEAR/@MON/@MDAY  = Number($calendar)  Then
        If ProcessExists('notepad.exe') Then
            MsgBox(0, 'Attention Time now is '&@HOUR&':'&@MIN, '===  Notepad is running.  ===' & @CRLF & @CRLF & 'Starting ' & _
                    $hour & ':' & $min & @CRLF & 'Ending  ' & $hours & ':' & $mins, 5)
        Else
            Run ('$list[1][1]')
        EndIf
    EndIf
EndFunc   ;==>_Function
Func _Close()
    $mins = IniRead('.ini', 'section', '3', '')
    $hours = IniRead('.ini', 'section', '4', '')
    Sleep(50)
    If ProcessExists('$list[1][1]') Then
        If @MIN = Number($mins) And @HOUR = Number($hours) Then
            clos()
        EndIf
    EndIf
EndFunc   ;==>_Close



Func imag()
 $file = FileOpenDialog("Select file", @ProgramFilesDir & "", "Application (*.exe)", 1 + 4 )
While 1
			If @error Then
                GUICtrlSetData($path_source,"")
            Else
                $iconfile_to_use = $file
                $array = StringSplit($iconfile_to_use, '\', 1)
                $name = $array[$array[0]]
                $newname = StringReplace($name,".exe","")
                $hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
                _GUIImageList_AddIcon($hImage, $iconfile_to_use, 0, True)
                _GUICtrlButton_SetImageList($Button3, $hImage,4)
                GUICtrlSetData($path_source,$file)
				IniWrite(@ScriptDir & '\.ini', 'section', 'open',GUICtrlRead($path_source))
				ConsoleWrite(GUICtrlRead($path_source) & @CRLF)


			EndIf

              ExitLoop
WEnd

EndFunc
