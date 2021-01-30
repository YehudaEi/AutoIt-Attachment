Func _Read_CPU()
Local $colItems = ""
  $colItems = $objWMIService.ExecQuery("Select * from Win32_Processor")
   
   For $objItem in $colItems
     Local $item = $objItem.Name
	 GUICtrlCreateLabel($Item, 30, 240)  
 
   Next
EndFunc

Func _Read_Graphics()
Local $colItems = ""
  $colItems = $objWMIService.ExecQuery("Select * from Win32_VideoController")
   
   For $objItem in $colItems
     Local $item = $objItem.Name
	 GUICtrlCreateLabel($Item, 30, 280)  
 
   Next
EndFunc

Func _Read_Sound()
Local $colItems = ""
  $colItems = $objWMIService.ExecQuery("Select * from Win32_SoundDevice")
   
   For $objItem in $colItems
     Local $item = $objItem.Name
	 GUICtrlCreateLabel($Item, 30, 320)  
 
   Next
EndFunc