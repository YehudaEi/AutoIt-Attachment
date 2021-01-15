
#include <GUIConstants.au3>

; The following things need to be changed:  LOCATIONOFMAINPICTURE (7) NAMEHERE (106 and 108) OTHERNAME (113 and 115) LOCATIONOFPICTURE (118)  
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("MinionMe", 301, 361, 193, 115)
$Pic1 = GUICtrlCreatePic("LOCATIONOFMAINPICTURE", 10, 20, 279, 121, BitOR($SS_NOTIFY, $WS_GROUP))
$Typed = GUICtrlCreateEdit("", 10, 145, 279, 130)
GUICtrlSetData(-1, "")
$TypeHere = GUICtrlCreateInput("", 10, 280, 248, 60)
$Go = GUICtrlCreateButton("Go", 260, 279, 33, 62 )
GUISetState()
guictrlsetstate($go,$GUI_DEFBUTTON)
#EndRegion ### END Koda GUI section ###
guictrlsetstate($TypeHere,$gui_focus)
While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
        Case $Go
            $data = GUICtrlRead($TypeHere)   
            GUICtrlSetData($Typed, $data&@crlf, 1)
			GUICtrlSetData($TypeHere, "")
                    
                    

					if StringInStr ( $data, "AutoIt" ) then                                                 ;AutoIt is what you said
						sleep (1500)
                    GUICtrlSetData($Typed, 'Remember when Fabry helped to create me? The genius'&@crlf, 1)	 ;Remember..Genius is what he will say					
						sleep (3000)
					run ( "C:\Program Files\AutoIt3\SciTE\SciTE.exe" )                                      ; This is what he will do
					endif   
                    
					if StringInStr ( $data, "Sandwich" ) then 
						sleep (1500)						
					GUICtrlSetData($Typed, 'What about green pesto with cumcumber and chickenfilet, sir?'&@crlf, 1)
				    endif   
				
					if StringInStr ( $data, "nf67" ) then 
						sleep (1500)						
					GUICtrlSetData($Typed, 'Without nf67 I would not even be here'&@crlf, 1)
				    endif   
                    
					if StringInStr ( $data, "Hungry" ) then  
						sleep (1500)
					GUICtrlSetData($Typed, 'I would love to see a sandwich... maybe mustard with cheese and ham from italy, better not forget the cumcumber and mustard+honey+mayonaise spread!'&@crlf, 1)
				    endif   
                    
					if StringInStr ( $data, "Fabry" ) then 
						sleep (1500)						
					GUICtrlSetData($Typed, 'Whatever you say, fabry is a genius.'&@crlf, 1)
				    endif   
                    
					if StringInStr ( $data, "lol" ) then    
						sleep (1500)							
                    GUICtrlSetData($Typed, 'Heheheheh!'&@crlf, 1)
				    endif   
                    
					if StringInStr ( $data, "Firefox" ) then  
						sleep (1500)							
					GUICtrlSetData($Typed, 'I present to you: the internet!'&@crlf, 1)						
						sleep (3000)
					run ( "C:\Program Files\Mozilla Firefox\firefox.exe" )
					endif   
                    
					if StringInStr ( $data, "Paint" ) then 
						sleep (1500)
                    GUICtrlSetData($Typed, 'Paint!? Only because you are the master!'&@crlf, 1)						
						sleep (3000)
					run ( "C:\WINDOWS\system32\msPaint.exe" )
				    endif

					if StringInStr ( $data, "How are you" ) then 
						sleep (1500)							
                    GUICtrlSetData($Typed, 'Perfectly fine, now you are back!'&@crlf, 1)
				    endif   

					if StringInStr ( $data, "Hi" ) then     
						sleep (1500)
                    GUICtrlSetData($Typed, 'Master!'&@crlf, 1)
				    endif   

					if StringInStr ( $data, "Hello" ) then   
						sleep (1500)							
                    GUICtrlSetData($Typed, 'Mmm, the real master only says Hi.'&@crlf, 1)
				    endif   


					if StringInStr ( $data, "Bye" ) then  
						sleep (1500)							
                    GUICtrlSetData($Typed, 'So sad to see you leaving, lord.'&@crlf, 1)
				    endif   


					if StringInStr ( $data, "cya" ) then    
						sleep (1500)							
                    GUICtrlSetData($Typed, 'Pleeeaaase, stay a little longer!'&@crlf, 1)
				    endif   
				
					if StringInStr ( $data, "See you" ) then  
						sleep (1500)							
                    GUICtrlSetData($Typed, 'Ahhhhhhh, are you going to leave me?'&@crlf, 1)
					endif   
				
					if StringInStr ( $data, "NAMEHERE" ) then  
						sleep (1500)							
                    GUICtrlSetData($Typed, 'Oh no... not NAMEHERE! I beg you! Please!'&@crlf, 1)
					    sleep (3000) 
					MsgBox ( 016, "Error", "Error:string87x65 OLE v.3.5 Unfortunatley, this person is too ugly to display. Please contact the hairdresser" ) 
					endif  

                    if StringInStr ( $data, "OTHERNAME" ) then 
                        sleep (1500)                           
                    GUICtrlSetData($Typed, 'OTHERNAME? I got a picture of HIM/HERE! Here:'&@crlf, 1)
                        sleep (3000)
                    $PictureGUI = GUICreate("Picture", 116, 116, 214, 131)
                    $PicturePic = GUICtrlCreatePic("LOCATIONOFAPICTURE", 0, 0, 113, 113, BitOR($SS_NOTIFY,$WS_GROUP))
                     GUISetState(@SW_SHOW, "Picture")

                       While 1
                       $nMsg = GUIGetMsg()
                       Switch $nMsg
                        Case $GUI_EVENT_CLOSE
                         guidelete($PICTUREGUI)             
                          exitloop
                          

                      EndSwitch
                     WEnd
                    endif
				 
					if StringInStr ( $data, "Hey" ) then  
						sleep (1500)							
                    GUICtrlSetData($Typed, 'You clearly have less brains than a donut. The master only says Hi.'&@crlf, 1)
					endif 
				 
				
					if StringInStr ( $data, "I no longer need you" ) then  
						sleep (1500)							
					GUICtrlSetData($Typed, 'Okay, it was an honor to server you, see you master!'&@crlf, 1)
                        sleep (3000)
					exit
					endif   

				

				
            
    EndSwitch
WEnd





