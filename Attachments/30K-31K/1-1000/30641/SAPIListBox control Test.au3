#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <SAPIListBox.au3>

dim $msg, $SpeechListBox1_array[15] = ["bacon", "bread", "egg", "ham", "butter", "milk", "corn", "cheese", "toast", "tea", "yoghurt", "vanilla", "jam", "apple", "banana"]

; Setup the GUI
GUICreate("SAPIListBox control Test", 640, 580)
GUICtrlCreateLabel("Say / speak any item from the listbox below, into an attached microphone, and that item should become selected automatically.", 10, 20)
$SpeechListBox1 = _GUICtrlSAPIListBox_Create(10, 40, 600, 360)

if $SpeechListBox1 = False Then
	
	MsgBox((262144+16), "SAPIListBox control Test - Error!", "Could not create a SAPI ListBox control." & @CRLF & "Ensure you have installed the" & @CRLF & "Microsoft Speech SDK 5.1 (SpeechSDK51.exe) and try again")
	Exit
EndIf

GUICtrlCreateLabel("New Item to Add:", 10, 400, 100, 20)
$new_item_input = GUICtrlCreateInput("", 100, 400, 150, 20)
$add_item_button = GUICtrlCreateButton("Add Item", 260, 400, 80, 20)
$delete_item_button = GUICtrlCreateButton("Delete Item", 360, 400, 80, 20)
GUICtrlCreateLabel("Item Count:", 460, 400, 100, 20)
$item_count_input = GUICtrlCreateInput("", 520, 400, 40, 20)
GUICtrlCreateLabel("Text Selected / Recognised:", 10, 430, 150, 20)
$item_selected_input = GUICtrlCreateInput("", 150, 430, 80, 20)
GUICtrlCreateLabel("Newest Index:", 250, 430, 80, 20)
$newest_item_input = GUICtrlCreateInput("", 320, 430, 30, 20)
GUICtrlCreateLabel("Index to get selection status for:", 10, 460, 150, 20)
$get_selection_input = GUICtrlCreateInput("", 165, 460, 30, 20)
$get_selection_button = GUICtrlCreateButton("Get Selection Status", 210, 460, 120, 20)
$selection_status_input = GUICtrlCreateInput("", 340, 460, 30, 20)
GUICtrlCreateLabel("New list tooltip to set:", 10, 490, 100, 20)
$new_tooltip_input = GUICtrlCreateInput("", 115, 490, 80, 20)
$set_tooltip_button = GUICtrlCreateButton("Set Tooltip", 210, 490, 80, 20)
$speech_disabled_checkbox = GUICtrlCreateCheckbox("Speech Disabled", 10, 530, 120, 20)
GUICtrlSetState($speech_disabled_checkbox, $GUI_UNCHECKED)
$speechlistbox_disabled_checkbox = GUICtrlCreateCheckbox("Listbox Disabled", 130, 530, 120, 20)
GUICtrlSetState($speechlistbox_disabled_checkbox, $GUI_UNCHECKED)
$speechlistbox_hidden_checkbox = GUICtrlCreateCheckbox("Listbox Hidden", 260, 530, 120, 20)
GUICtrlSetState($speechlistbox_hidden_checkbox, $GUI_UNCHECKED)
$close_button = GUICtrlCreateButton("Close (Esc)", 10, 550, 80, 20)
$clear_button = GUICtrlCreateButton("Clear List", 100, 550, 80, 20)
$refresh_button = GUICtrlCreateButton("Refresh List", 200, 550, 80, 20)
$speech_properties_button = GUICtrlCreateButton("Speech Properties", 300, 550, 100, 20)
dim $main_gui_accel[1][2]=[["{ESC}", $close_button]]
GUISetAccelerators($main_gui_accel)

; Display the GUI
GUISetState()

; Populate the GUI
_GUICtrlSAPIListBox_EnableSpeech($SpeechListBox1, 1)
_GUICtrlSAPIListBox_AddArray($SpeechListBox1, $SpeechListBox1_array)
_GUICtrlSAPIListBox_InsertString($SpeechListBox1, "fred", 2)
GUICtrlSetData($item_count_input, _GUICtrlSAPIListBox_GetCount($SpeechListBox1))
GUICtrlSetData($newest_item_input, _GUICtrlSAPIListBox_GetNewIndex($SpeechListBox1))

; Main loop
While 1
	
	if _GUICtrlSAPIListBox_CurSelChanged($SpeechListBox1) = True Then
		
		GUICtrlSetData($item_selected_input, _GUICtrlSAPIListBox_GetText($SpeechListBox1))
	EndIf

	if $msg = $speech_properties_button Then
		
		Run("cmd.exe /c control.exe ""C:\Program Files\Common Files\Microsoft Shared\Speech\sapi.cpl""",@SystemDir,@SW_HIDE)
	EndIf

	if $msg = $set_tooltip_button Then
		
		_GUICtrlSAPIListBox_SetToolTip($SpeechListBox1, GUICtrlRead($new_tooltip_input))
	EndIf

	if $msg = $get_selection_button Then
		
		GUICtrlSetData($selection_status_input, _GUICtrlSAPIListBox_GetSel($SpeechListBox1, Int(GUICtrlRead($get_selection_input))))
	EndIf
	
	if $msg = $refresh_button Then
		
		_GUICtrlSAPIListBox_Refresh($SpeechListBox1)
	EndIf
	
	if $msg = $add_item_button Then
		
		_GUICtrlSAPIListBox_AddString($SpeechListBox1, GUICtrlRead($new_item_input))
		GUICtrlSetData($item_count_input, _GUICtrlSAPIListBox_GetCount($SpeechListBox1))
		GUICtrlSetData($newest_item_input, _GUICtrlSAPIListBox_GetNewIndex($SpeechListBox1))
	EndIf

	if $msg = $delete_item_button Then
		
		_GUICtrlSAPIListBox_DeleteString($SpeechListBox1, _GUICtrlSAPIListBox_GetCurSel($SpeechListBox1))
		GUICtrlSetData($item_count_input, _GUICtrlSAPIListBox_GetCount($SpeechListBox1))
		GUICtrlSetData($newest_item_input, _GUICtrlSAPIListBox_GetNewIndex($SpeechListBox1))
	EndIf

	if $msg = $clear_button Then
		
		_GUICtrlSAPIListBox_ResetContent($SpeechListBox1)
	EndIf

	if $msg = $speech_disabled_checkbox Then
		
		if GUICtrlRead($speech_disabled_checkbox) = $GUI_CHECKED Then
			
			_GUICtrlSAPIListBox_EnableSpeech($SpeechListBox1, 0)
		Else

			_GUICtrlSAPIListBox_EnableSpeech($SpeechListBox1, 1)
		EndIf
	EndIf

	if $msg = $speechlistbox_disabled_checkbox Then
		
		if GUICtrlRead($speechlistbox_disabled_checkbox) = $GUI_CHECKED Then
			
			_GUICtrlSAPIListBox_Enable($SpeechListBox1, 0)
		Else

			_GUICtrlSAPIListBox_Enable($SpeechListBox1, 1)
		EndIf
	EndIf

	if $msg = $speechlistbox_hidden_checkbox Then
		
		if GUICtrlRead($speechlistbox_hidden_checkbox) = $GUI_CHECKED Then
			
			_GUICtrlSAPIListBox_Hide($SpeechListBox1, 1)
		Else

			_GUICtrlSAPIListBox_Hide($SpeechListBox1, 0)
		EndIf
	EndIf

	if $msg = $GUI_EVENT_CLOSE or $msg = $close_button Then
		
		ExitLoop
	EndIf

	$msg = GUIGetMsg()
WEnd

GUIDelete()
