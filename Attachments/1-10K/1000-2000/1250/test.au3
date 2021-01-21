If 	GUICtrlRead($January) = $GUI_CHECKED 		AND _ 
	GUICtrlRead($February) = $GUI_UNCHECKED  	AND _
	GUICtrlRead($March) = $GUI_UNCHECKED 		AND _ 
	GUICtrlRead($April) = $GUI_UNCHECKED 		AND _ 
	GUICtrlRead($May) = $GUI_UNCHECKED 			AND _ 
	GUICtrlRead($June) = $GUI_UNCHECKED 		AND _ 
	GUICtrlRead($July) = $GUI_UNCHECKED 		AND _ 
	GUICtrlRead($August) = $GUI_UNCHECKED 		AND _ 
	GUICtrlRead($September) = $GUI_UNCHECKED 	AND _ 
	GUICtrlRead($October) = $GUI_UNCHECKED 		AND _ 
	GUICtrlRead($November) = $GUI_UNCHECKED 	AND _ 
	GUICtrlRead($December) = $GUI_UNCHECKED 	THEN _ 
	MsgBox(0, "GUI Event", "Temporary Button...January")
EndIf