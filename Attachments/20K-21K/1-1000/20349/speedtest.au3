#include <Inet.au3>
#include <GUIConstants.au3>
#NoTrayIcon

hotkeyset("{BS}","quit")
hotkeyset("{ESC}","dowork")


  #Region ### START Koda GUI section ### Form=
  $Form1 = GUICreate("Internet Speed Test", 150, 80, 180, 100)
  $Label1 = GUICtrlCreateLabel("Press start to begin!", 10, 10, 120, 15)
  $Label2 = GUICtrlCreateLabel("Press BACKSPACE to exit!", 10, 30, 140, 15)
  $button = GUICtrlCreateButton("Start",10, 50, 70, 25)

 
  GUISetState(@SW_SHOW)
  #EndRegion ### END Koda GUI section ###
 
  While 1
      $nMsg = GUIGetMsg()
      Switch $nMsg
          Case $GUI_EVENT_CLOSE
              Exit
		  case $button
			  dowork()
		  endswitch
		  
	  WEnd
	  
	  
func dowork()
          
do
$i = 0
              
$PublicIP = _GetIP()
MsgBox(0, "IP Address", "Your IP Address is: " & $PublicIP)
sleep("900")
$time = ping($publicip)
sleep("500")
          
          
		If $time < 1 then
			msgbox(1, "ULTRA FAST", "Your internet speed is top notch, it took: " & $time * .001 " seconds to ping")
		endif
          
          
		if $time < 2 and $time > .9 then
			msgbox(1, "GREAT", "Your internet speed is excellent, it took: " & $time * .001 & " seconds to ping")
          endif
          
          
		if $time < 3 and $time > 1.9 then
			msgbox(1, "Good", "Your internet speed is good, it took: " & $time * .001 & " seconds to ping")
		EndIf
              
              
		if $time < 4 and $time > 2.9 Then
			msgbox(1, "Fair", "Your internet speed is fair, it took: " & $time * .001 & " seconds to ping")
		EndIf
                    
		if $time < 5 and $time > 3.9 Then
			msgbox(1, "Poor", "Your internet speed is poor, it took: " & $time * .001 & " seconds to ping")
		EndIf
                        
		if $time  > 5 Then
			msgbox(1, "Bad", "Your internet speed is bad, look to get new service, it took: " & $time * .001 & " seconds to ping")
		endif
                              
                              
            $i = $i + 1
              
          until $i = 1
          
endfunc
	  
	  
	  

func quit()
	Exit
endfunc