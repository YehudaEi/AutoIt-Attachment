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
    ;$objWMIService = ObjGet("winmgmts:\\localhost\root\CIMV2") ; outcomment, only to run test
    $colItems = $objWMIService.ExecQuery("Select * from Win32_VideoController")        

    For $objItem in $colItems      
        If $objItem.name = "" Then 
            $item = StringMid ($objItem.PNPDeviceID, 5, 17)
        Else
            $item = $objItem.name
        EndIf
        GUICtrlCreateLabel($Item, 30, 320)
        ;ConsoleWrite ($Item) ; outcomment, only to run test
    Next 
EndFunc

Func __Read_Graphics()
Local $colItems = ""
  $colItems = $objWMIService.ExecQuery("Select * from Win32_VideoController")
   
   For $objItem in $colItems
     Local $item = $objItem.PNPDeviceID
	 GUICtrlCreateLabel($Item, 30, 320)  
 
   Next
EndFunc

Func Read_Sound() 
    Local $colItems = ""
    ;$objWMIService = ObjGet("winmgmts:\\localhost\root\CIMV2") ; outcomment, only to run test
    $colItems = $objWMIService.ExecQuery("Select * from Win32_SoundDevice")        

    For $objItem in $colItems      
        If $objItem.PNPDeviceID == "" Then 
            $item = StringMid ($objItem.PNPDeviceID, 5, 17)
        Else
            $item = $objItem.name
        EndIf
        GUICtrlCreateLabel($Item, 30, 360)
        ;ConsoleWrite ($Item) ; outcomment, only to run test
    Next 
EndFunc
Func __Read_Sound()
Local $colItems = ""
  $colItems = $objWMIService.ExecQuery("Select * from Win32_SoundDevice")
   
   For $objItem in $colItems
     Local $item = $objItem.name
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

;--------------> Mail
Func _INetMail2($s_MailTo, $s_MailSubject, $s_MailBody)
    Local $prev = opt("ExpandEnvStrings", 1)
    Local $var = RegRead('HKCR\mailto\shell\open\command', "")
    Local $ret = Run(StringReplace($var, '%1', 'mailto:' & $s_MailTo & '?subject=' & $s_MailSubject & '&body=' & $s_MailBody))
    Local $nError = @error, $nExtended = @extended
    opt("ExpandEnvStrings", $prev)
    Return SetError($nError, $nExtended, $ret)
EndFunc   
