#include <GUIConstants.au3>
#include <GuiListView.au3>

Opt("GUICoordMode", 0)          ;1=absolute, 0=relative, 2=cell

GUICreate("Service Administrator", 600, 600, -1, -1)
GUISetState (@SW_SHOW)      

$listview = GUICtrlCreateListView ("Start|Group Name|Tag|Service/Device|Display Name",10,10,580,450);,$LVS_SORTDESCENDING)
Dim $B_DESCENDING[_GUICtrlListViewGetSubItemsCount ($listview) ]

; Bottom GUI Contol/Nfo
GUICtrlCreateGroup ("Modify Service", 0, 455, 365, 125)
	GUICtrlCreateLabel("Service/Device:", 10, 20, 85, 20, $SS_RIGHT)
		$srvc_mod_name = GUICtrlCreateLabel("<Service Name>", 90, 0, 150, 20)
	
	GUICtrlCreateLabel("Start:", -90, 20, 85, 20, $SS_RIGHT)
		$srvc_mod_start = GUICtrlCreateCombo ("Boot", 90, -3, 125,0, $CBS_DROPDOWNLIST) 
		GUICtrlSetData(-1,"|System|Automatic|Manual|Disabled|N/A","N/A") ;
		
	GUICtrlCreateLabel("Group Name:", -90, 23, 85, 20, $SS_RIGHT)
		$srvc_mod_group = GUICtrlCreateEdit ("<Group Name>", 90,-3,250,20, $ES_OEMCONVERT)
		
	GUICtrlCreateLabel("Tag:", -90, 23, 85, 20, $SS_RIGHT)
		$srvc_mod_tag = GUICtrlCreateEdit ("<Tag>", 90,-3,45,20, $ES_OEMCONVERT)

	GUICtrlCreateLabel("Display Name:", -90, 23, 85, 20, $SS_RIGHT)
		$srvc_mod_display = GUICtrlCreateEdit ("<Display Name>", 90,-3,250,20, $ES_OEMCONVERT)

	;GUICtrlCreateLabel("<Select>", 90, 0, 150, 20)

;$Status = 


$i = 0;
$service = "nil";

While $service <> ""
		$service = RegEnumKey("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services", $i+1)
		
		if ($service <> "") Then
				
				$srvc_DisplayName = RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\" & $service, "DisplayName");
				$srvc_Description = RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\" & $service, "Description");				
				$srvc_Group = RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\" & $service, "Group");
				$srvc_Start = RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\" & $service, "Start");
				$srvc_Tag = RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\" & $service, "Tag");
				$srvc_Type = RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\" & $service, "Type");
				
				Select
						Case $srvc_Start == 0
								$srvc_hr_Start = "Boot";
						Case $srvc_Start == 1
								$srvc_hr_Start = "System";
						Case $srvc_Start == 2
								$srvc_hr_Start = "Automatic";
						Case $srvc_Start == 3
								$srvc_hr_Start = "Manual";
						Case $srvc_Start == 4
								$srvc_hr_Start = "Disabled";
						Case Else
								$srvc_hr_Start = "N/A";
				EndSelect
				
				GUICtrlCreateListViewItem($srvc_hr_Start & "|" & $srvc_Group & "|" & $srvc_Tag & "|" & $service & "|" & $srvc_DisplayName ,$listview)
		EndIf
		$i=$i+1;
		
		
		;msgbox(0,"", $var);
WEnd

While 1
    $msg = GUIGetMsg()

		Select    
        Case $msg = $listview
            ; sort the list by the column header clicked on
            _GUICtrlListViewSort($listview, $B_DESCENDING, GUICtrlGetState($listview))
        
				Case $msg = $GUI_EVENT_PRIMARYDOWN
            $pos = GUIGetCursorInfo()
            
            $ret = _GUICtrlListViewGetItemText ($listview)
            If ($pos[4] == $listview) Then
            		If ($ret <> $LV_ERR) Then
		            		
		            		GUICtrlSetData($srvc_mod_start, _GUICtrlListViewGetItemText($listview, -1, 0))
		            		GUICtrlSetData($srvc_mod_group, _GUICtrlListViewGetItemText($listview, -1, 1))
		            		GUICtrlSetData($srvc_mod_tag, _GUICtrlListViewGetItemText($listview, -1, 2))
		            		GUICtrlSetData($srvc_mod_name, _GUICtrlListViewGetItemText($listview, -1, 3))
		            		GUICtrlSetData($srvc_mod_display, _GUICtrlListViewGetItemText($listview, -1, 4))
		            		
                EndIf
            EndIf        
        
        Case $msg = $GUI_EVENT_CLOSE 
        		ExitLoop            		
        		
    EndSelect

Wend
