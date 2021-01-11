; ----------------------------------------------------------------------------
; AutoIt Version: 1.0
; Author: Yash Nimdia
; Script Function:
; ----------------------------------------------------------------------------



#include <Process.au3>

run("control.exe","C:\WINDOWS\system32",@SW_HIDE)
sleep(1000)

$a = Call("Power")

Func Power()
sleep(500)
            		  Send("{ASC 080}")

       	                Send("{ASC 080}")
		
		  Send("{ENTER}")

                             sleep(1000)

                             send("^{TAB}")   
		 send("^{TAB}")   

                   $text = WinGetText("Power Options Properties")
                                          
                   
                   $var = StringInStr ( $text, "AC power")
sleep(1000)

	WinKill ( "Power Options Properties")
sleep(500)
	WinClose ( "Control Panel")
sleep(500)
		
                     
           if $var = 0  THEN 
	
		MsgBox(0, "", "Please connect your Laptop to Mains")
			$b=MsgBox(4, "", "Have you connected your Laptop to Mains")    
		if $b=7 then
			exit
			return 0
		Endif
	Else 
				
		MsgBox(0, "", "Laptop connected to Mains")
			     		
			return 1
	    EndIf
		
		                       
	
EndFunc