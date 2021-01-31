Func Read_Motherboard()
Local $colItems = ""
  $colItems = $objWMIService.ExecQuery("Select * from Win32_baseboard")
   
   For $objItem in $colItems
     Local $item = $objItem.Product
	 GUICtrlCreateLabel($Item, 30, 240)  
 
   Next
EndFunc

Func Read_CPU()
Local $colItems = ""
  $colItems = $objWMIService.ExecQuery("Select * from Win32_Processor")
   
   For $objItem in $colItems
     Local $item = $objItem.name
	 GUICtrlCreateLabel($Item, 30, 280)  
 
   Next
EndFunc

Func Read_Graphics()
Local $colItems = ""
  $colItems = $objWMIService.ExecQuery("Select * from Win32_VideoController")
   
   For $objItem in $colItems
     Local $item = $objItem.Name
	 GUICtrlCreateLabel($Item, 30, 320)  
 
   Next
EndFunc

Func Read_Sound()
Local $colItems = ""
  $colItems = $objWMIService.ExecQuery("Select * from Win32_SoundDevice")
   
   For $objItem in $colItems
     Local $item = $objItem.ProductName
	 GUICtrlCreateLabel($Item, 30, 360)  
 
   Next
EndFunc

Func Read_Network()
Local $colItems = ""
  $colItems = $objWMIService.ExecQuery("Select * from Win32_NetworkAdapterConfiguration")
   
   For $objItem in $colItems
     Local $item = $objItem.DefaultIPGateway(0)
	 GUICtrlCreateLabel($Item, 30, 320)  
 
   Next
EndFunc

Func ResolveIP()
    InetGet("http://www.whatismyip.org", "incoming.dat", 1, 1)
    
    While @InetGetActive
        Sleep(50)
    WEnd
    
    $file = FileOpen ("incoming.dat", 0)
    $contents = FileReadLine($file)
    $wAddress = $contents
 
    Return $wAddress
EndFunc