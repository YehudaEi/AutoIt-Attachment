

    ;=>> ListView Example coded by SdK <<=

    ;=>> Include <<=
    #include <GUIConstantsEx.au3>
    #include <WindowsConstants.au3>
    #include <GuiListView.au3>



    Global $ID_next = 0

    ;=>> GUI / Code <<=
    $Form1 = GUICreate("Checklist", 1000, 600, -1, -1, BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU, $WS_SIZEBOX))
    $hListView = GUICtrlCreateListView("Name|Laptop or Computer|Model|OS|Authentication|ID", 0, 0, 1000, 500)
    ;_GUICtrlListView_SetExtendedListViewStyle($hListView, $LVS_EX_FULLROWSELECT)

    $Menue_Main = GUICtrlCreateMenu("Menu")
    $Menue_Main_1 = GUICtrlCreateMenuItem("New checklist", $Menue_Main)
    $Menue_Main_2 = GUICtrlCreateMenuItem("Delete all checklists", $Menue_Main)
    $Menue_Main_3 = GUICtrlCreateMenuItem("Save checklist to excel", $Menue_Main)

    $Menue_ListView = GUICtrlCreateContextMenu($hListView)
    $Menue_ListView_1 = GUICtrlCreateMenuItem("Delete", $Menue_ListView)

    _GUICtrlListView_SetColumnWidth($hListView, 0, 200)
    _GUICtrlListView_SetColumnWidth($hListView, 1, 200)
    _GUICtrlListView_SetColumnWidth($hListView, 2, 150)
    _GUICtrlListView_SetColumnWidth($hListView, 3, 50)

    _GUICtrlListView_RegisterSortCallBack($hListView)

    _load_database($hListView, @ScriptDir & '\Database')

    GUISetState(@SW_SHOW)


    While 1
            $nMsg = GUIGetMsg()
            Switch $nMsg
                    Case $GUI_EVENT_CLOSE
                            Exit
                    Case $Menue_Main_1 ;=>> Add ...
                            $naamklant = InputBox("", "Name")
                            $type = InputBox("", "Laptop or Computer?")
                            $model = InputBox("", "Model?")
							$OS = InputBox("", "OS?")
							$gebruikersgegevens = InputBox("", "Authentication")
                            GUICtrlCreateListViewItem($naamklant & '|' & $type & '|' & $model&'|' & $OS&'|' & $gebruikersgegevens & '|' & $ID_next,  $hListView)
                            $ID_next +=1
                    Case $Menue_ListView_1 ;=>> Delete
                            _GUICtrlListView_DeleteItemsSelected($hListView)
                    Case $Menue_Main_2 ;=>> Delete All
                            _GUICtrlListView_DeleteAllItems($hListView)
                    Case $Menue_Main_3 ;=>>Save 2
                            _save_database($hListView, @ScriptDir & '\Database')
                    Case $hListView ;=>> F!
                            _GUICtrlListView_SortItems($hListView, GUICtrlGetState($hListView))
            EndSwitch
    WEnd

    ;=>> Function <<=
    Func _ArraySow($array)
            For $i = 1 To UBound($array) - 1 Step +1
                    MsgBox(0, "", $i & ":" & @CRLF & $array[$i])
            Next
    EndFunc   ;==>_ArraySow

    Func _load_database($hListView, $path_database)
            $search = FileFindFirstFile($path_database & "\*.*")
            If $search = -1 Then
                    MsgBox(0, "There are no checklists")
                    Return 0
            EndIf

            $ID_next = 0

            While 1
                    $file = FileFindNextFile($search)
                    If @error Then ExitLoop

                    $naamklant = IniRead($path_database & '\' & $file, 'Checklist', 'Name', 'error')
                    $type = IniRead($path_database & '\' & $file, 'Checklist', 'Laptop or Computer', 'error')
                    $model = IniRead($path_database & '\' & $file, 'Checklist', 'Model', 'error')
					$OS = IniRead($path_database & '\' & $file, 'Checklist', 'OS', 'error')
					$gebruikersgegevens = IniRead($path_database & '\' & $file, 'WSB', 'Authentication', 'error')
                    $id = StringTrimRight($file, 4)

                    GUICtrlCreateListViewItem($naamklant & '|' & $type & '|' & $model & '|' & $OS & '|' & $gebruikersgegevens & '|' & $id & '|', $hListView)
                    $ID_next = $id + 1
            WEnd
            FileClose($search)
            MsgBox(0,"","Checklist program is loaded")
    EndFunc   ;==>_load_database


    Func _save_database($hListView, $path_database)
            $count = _GUICtrlListView_GetItemCount($hListView)
            DirRemove($path_database, 1)
            DirCreate($path_database)

            For $i = 0 To $count - 1 Step +1
                    $array = _GUICtrlListView_GetItemTextArray($hListView, $i)
                    IniWrite($path_database & '\' & $array[6] & '.xls', 'Chechlist', 'Name', $array[1])
                    IniWrite($path_database & '\' & $array[6] & '.xls', 'Checklist', 'Laptop or Computer', $array[2])
                    IniWrite($path_database & '\' & $array[6] & '.xls', 'Checklist', 'Model', $array[3])
					IniWrite($path_database & '\' & $array[6] & '.xls', 'Checklist', 'OS', $array[4])
					IniWrite($path_database & '\' & $array[6] & '.xls', 'Checklist', 'Authentication', $array[5])

            Next
            MsgBox(0,"","Checklist is saved")
    EndFunc   ;==>_save_database



