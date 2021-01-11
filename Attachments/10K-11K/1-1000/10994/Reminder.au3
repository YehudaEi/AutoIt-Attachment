#include <GUIConstants.au3>
#include <GuiList.au3>
#Include <GuiListView.au3>
#include <string.au3>
#include <Date.au3>
#include <File.au3>
Global $a = 1

GuiCreate("Reminder", 600, 500, -1, -1)
GUISetBkColor (0x6BC072)
	$main = GuiCtrlCreateListview("", 5, 5, 590, 445, $LVS_SHOWSELALWAYS)
		GUICtrlSetBkColor(-1,0xA6D9AA)
		_GUICtrlListViewInsertColumn($main, 0, "Event", "", 316)
		_GUICtrlListViewInsertColumn($main, 1, "Time", "", 100)
		_GUICtrlListViewInsertColumn($main, 2, "Date", "", 100)
	$addreminder = GuiCtrlCreateButton("Add a new reminder", 15, 460, 230, 30)
	$deletereminder = GuiCtrlCreateButton("Delete selected reminders", 260, 460, 230, 30)
	$exit = GuiCtrlCreateButton("Exit", 505, 460, 80, 30)

 Do
	$pastinfo = InireadSectionNames(@DesktopCommonDir & "\reminderinfo.ini")
	If not Isarray($pastinfo) then exitloop
		$info = InireadSection(@DesktopCommonDir & "\reminderinfo.ini", $pastinfo[$a])
		If not Isarray($info) then exitloop
		$moreinfo = Stringsplit($info[$a][0], "+")
		GuiCtrlCreateListViewItem($pastinfo[$a] & "|" & $moreinfo[2] & "|" & $moreinfo [1], $main)
		$a += 1
Until $a > $pastinfo[0]

GUIsetstate()

Loop()
Func Loop()
While 1 
	$msg = GuiGetMsg()
		If $msg = $exit then Exit
		If $msg = $GUI_EVENT_CLOSE then exit
		If $msg = $addreminder then Addreminder()
		If $msg = $deletereminder then 
			$f = Stringsplit(GuiCtrlRead(GUICtrlRead($Main)), "|")
			Inidelete(@DesktopCommonDir & "\reminderinfo.ini", $f[1], $f[3] & "+" & $f[2])
			Inidelete(@DesktopCommonDir & "\reminderinfo.ini", $f[1])
			_GUICtrlListViewDeleteItemsSelected ($main)
		Endif
		$split = Stringsplit(_GUICtrlListViewGetItemText($main, 0), "|")
		If $split[1] <> "" then 
			$split3 = Stringsplit($split[3], "/")
			$split2 = Stringsplit($split[2], ":")	
			If Bitand($split3[3] <= @YEAR, $split3[1] <= @MON, $split3[2] <= @MDAY, $split2[1] <= @Hour, $split2[2] <= @MIN) then 
				Msgbox(0, "Reminder alert", $split[1])
				_GUICtrlListViewDeleteItem($main, 0)
			EndIf
		Endif
Wend
Endfunc
	
Func Addreminder()
	$gui = GuiCreate("Add a reminder", 200, 280)
	GuiCtrlCreateLabel("Reminder Name", 10, 5, 180, 25, $ES_center)
	$name = GuiCtrlCreateInput("", 10, 25, 180, 20)
	$date = GUICtrlCreateMonthCal(@YEAR & "/" & @MON & "/" & @MDAY, 10, 55, 180, 160, $MCS_NOTODAY)
	GuiCtrlCreateLabel("Hour:", 5, 223, 30, 25, $SS_RIGHT)
	$hour = GuiCtrlCreateCombo("", 40, 220, 40, 25)
	GuiCtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23")
	GuiCtrlCreateLabel("Minute:", 100, 223, 35, 25, $SS_RIGHT)
	$minute = GuiCtrlCreateCombo("", 140, 220, 40, 25)
	GuiCtrlSetData(-1, "0|5|10|15|20|25|30|35|40|45|50|55")
	$ok = GuiCtrlCreateButton("Add Reminder", 10, 250, 180, 25)
	Guisetstate()
	
	While 1
		$ms = GuiGetMsg()
		If $ms = $GUI_EVENT_CLOSE then 
			GuiDelete($gui)
			Loop()
			Endif
		If $ms = $ok Then
			$date = Stringsplit(GuiCtrlRead($date), "/")
			$date = $date[2] & "/" & $date[3] & "/" & $date [1]
			$hour = GuiCtrlRead($hour)
			$minute = GuiCtrlRead($minute)
			If StringLen($minute) < 2 then 
				$minute = _StringInsert($minute, "0", 0)
				Endif
			$time =  $hour & ":" & $minute
			GuiCtrlCreateListViewItem(GuiCtrlRead($name) & "|" & $time & "|" & $date, $main)
			If StringLen($hour) < 2 then _StringInsert($hour, "0", 0)
			Iniwrite(@DesktopCommonDir & "\reminderinfo.ini", GuiCtrlRead($name), $date & "+" & $time, "")
			GuiDelete($gui)
			Endif
			
	Wend
EndFunc
	
	
	
Func Search($search, $start, $end, $c)	
;$search = what you're looking for
;$start line you start at (0 indexed)
;$end = what line you end at (0 indexed), put at -1 to search the whole list, also if your number is too big the whole list will be searched
;$c = column to search in 
	If $end > $start then SetError(1)
	Global $line = $start
	If $end = -1 then $total = _GUICtrlListViewGetItemCount($main)
	If $end < -1 then return Seterror(2)
	If $end > -1 then $total = $end
	If $end > _GUICtrlListViewGetItemCount($main) then $total = _GUICtrlListViewGetItemCount($main)
	If $start > $total then Seterror(3)
	If $start < 0 then Seterror(4)
	Do
		$ret = _GUICtrlListViewGetItemText ($main, $line, $c)
		If $ret = $search then 
			Return $line
			Exitloop
			Endif
		$line = $line + 1 
	Until $r > $total
	If $line > $total then Seterror(5)
Endfunc	
	
	
	
	
	
	