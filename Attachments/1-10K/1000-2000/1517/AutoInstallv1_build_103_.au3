#include <GUIConstants.au3>

If fileexists("AutoInfo.ini") = 1 Then
	filedelete("AutoInfo.ini")
	auto()
else
	auto()
endif

Func auto()
	$x = 1
	$dir = inputbox("I require the path to the setup file...","Example: C:\setup.exe or c:\foldernames\...\i_am_a_setupfile.exe." & @CRLF & "To make this even faster, right-click on the setup file, select properties, and copy the Location.")
	
	If fileexists($dir) = 1 Then	
		iniwrite("AutoInfo.ini","Directory","Dir",$dir)
		run($dir)
	else
		MsgBox(0,"Error!","File not Found! Please retype the path.")
		auto()
	endif
	MsgBox(0,"Attention!!!","In order for this to work, please use the Window tool that will appear after this box. Type the ContolId for each button. Otherwise it will not work.")
	Run("C:\Program Files\AutoIt3\AU3Info.exe","",@SW_MINIMIZE)	
	
		While 1
			sleep(3000)
			$title = wingettitle("")
			winactivate($title)
			$text = Wingettext("")
			winsetstate("AutoIt v3 Active Window Info","",@SW_RESTORE)
			guicreate("AutoInstaller - AutoFind",400,80)
			
			$title = guictrlcreateinput($title,5,5,100)
			$id = guictrlcreateinput("control id #",115,5,100)
			$other = guictrlcreateinput("Other:",335,5,60)
			$tb = guictrlcreatecombo("None",225,5,100)
			$next = guictrlcreatebutton("Next",235,28,60)
			$check = guictrlcreatecheckbox("Window Option You need?",5,30)
			$force = guictrlcreatecheckbox("Force Option",5,55)
			
			guictrlsetdata($tb,iniread("Settings.ini","Buttons","All","Yes|No|Install|Setup|Next|OK|Finish|Other"))
			Opt("SendKeyDownDelay", 5)
			$file = "AutoInfo.ini"
			guisetstate()
			While 1
				$msg = guigetmsg()
				If $msg = $gui_event_close Then
					exit
				endif

				If $msg = $next Then
					iniwrite($file,"Win" & $x,"Title",guictrlread($title))
					iniwrite($file,"Win" & $x,"Text",guictrlread($text))
					iniwrite($file,"Win"& $x,"ControlId",guictrlread($id))
					If guictrlread($tb) = "Other" Then
						iniwrite($file,"Win" & $x,"Button",guictrlread($other))
					else
						iniwrite($file,"Win" & $x,"Button",guictrlread($tb))
					endif
				
					If iniread($file,"Win" & $x,"Button","") = "Finish" Then
						Winclose("AutoIt v3 Active Window Info")
						winactivate(iniread($file,"Win" & $x,"Title","Error"))
						ControlFocus(iniread($file,"Win" & $x,"Title",""),iniread($file,"Win" & $x,"Text",""),iniread($file,"Win" & $x,"ControlId",""))
						sleep(10)
						ControlClick($title,$text,$id)
						MsgBox(0,"Operation Completed","You can now copy the decode.exe and AutoInfo.ini to the cd or floppy disk. Run decode.exe and move on with your life!")
						Exit
					endif
					winsetstate("AutoIt v3 Active Window Info","",@SW_MINIMIZE)
					guidelete("AutoInstaller - AutoFind")
					$b = stringlower(iniread($file,"Win" & $x,"Button",""))			
					If $b = "OK" Then
						Sleep(10)
						ControlClick($title,$text,$id)
					elseif $b = "Yes" Then
						winactivate(iniread($file,"Win" & $x,"Title","Error"))
						ControlFocus(iniread($file,"Win" & $x,"Title",""),iniread($file,"Win" & $x,"Text",""),iniread($file,"Win" & $x,"ControlId",""))
						Sleep(10)
						ControlClick($title,$text,$id)
					else	
						$b = stringmid($b,1,1)
						winactivate(iniread($file,"Win" & $x,"Title",$title))
						$len = stringlower(iniread($file,"Win" & $x,"License","Error!"))
						$a = stringlen($len)
						for $pos = 1 to $a
							$c = stringmid($len,$pos,1)
							Send("{ALT}" & $c)
							sleep(10)
						next
						If iniread($file,"Win" & $x,"ForceId","0") <> "0" Then				
							ControlFocus($title,$text,$forceid)
							Sleep(50)
							ControlCommand($title,$text,$forceid,"Check", "")	
						endif
						winactivate(iniread($file,"Win" & $x,"Title",guictrlread($title)))
						Sleep(100)
						ControlFocus(iniread($file,"Win" & $x,"Title",""),iniread($file,"Win" & $x,"Text",""),iniread($file,"Win" & $x,"ControlId",""))
						Sleep(100)
						ControlClick(iniread($file,"Win" & $x,"Title",$title),iniread($file,"Win" & $x,"Text",$text),iniread($file,"Win" & $x,"ControlId",$id))
					endif
					$x = $x + 1
					guidelete("AutoInstaller - AutoFind")
					exitloop
				endif
			
				If $msg = $gui_event_minimize Then
					Winsetstate("AutoInstaller - AutoFind","",@SW_MINIMIZE)
				endif
				If $msg = $check Then
					winactivate(guictrlread($title))
					Send("{ALT}")
					$letter = InputBox("Question","Give me the letter in the option that is underlined. If you don't see one, press 'Alt'." & @CRLF & "For multiple choices, do not separate the choices with anything. Example: adyi" & @CRLF & "If you still don't see an underlined letter, then select the option manually and move on. This will be fixed later.")
					$letter = stringlower($letter)
					iniwrite($file,"Win" & $x,"License",$letter)
					winactivate("AutoInstaller - AutoFind")
				endif
				If $msg = $force Then
					$forceid = InputBox("Forcing an Option...","Ah, some installers do come up with things like this. However, as proven in many p2p sites, there are work arounds. Note: This not illegal and all will be well with the world." & @CRLF & "Type in the ControlId at the below and move on.","","",325,217) 				
					iniwrite($file,"Win" & $x,"ForceId",$forceid)
						
					Winactivate(guictrlread($title))
					Sleep(10)
					
					ControlClick($title,$text,$forceid)
					If ControlClick($title,$text,$forceid) = 0 Then
						MsgBox(0,"Error","Checkbox couldn't take place...")
					else
						ControlClick($title,$text,$forceid)
					endif
					Sleep(10)
					winactivate("AutoInstaller - AutoFind")
				endif
			Wend
		Wend
endfunc