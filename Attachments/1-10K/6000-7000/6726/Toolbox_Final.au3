
#Include <GUIConstants.au3>
#include <Constants.au3>
Local $strcomputer
While 1
	GUICreate("GT's Toolbox", 300,170,)
	GUISetFont (10,400)
	GUICtrlCreateLabel ("Enter PC-Name, Printer", 5,20)
	GUISetFont (-1,15,400)
	$remotepc =GUICtrlCreateInput ( @ComputerName, 5,50,200,20)
	GUICtrlCreateLabel (Chr(169) & " T.Gebauer", 5,150)
	GUISetFont (8,400)
	$exit = GUICtrlCreateButton ("3", 260,35,40,40,$BS_ICON)
	GUICtrlSetImage (-1, "shell32.dll",27)
	GUISetFont (-1,12,400)
	$DWRC = GUICtrlCreateButton ("DWRC Clean", 3,105,75,40)
	$ping = GUICtrlCreateButton (" PING", 80,105,40,40)
	$druck = GUICtrlCreateButton ("3", 123,105,40,40,$BS_ICON)
	GUICtrlSetImage (-1, "shell32.dll",82)
	$n1 = GUICtrlCreateIcon (@windowsdir & "\cursors\banana.ani",-1, 215,40,40,40)
	$info = GUICtrlCreateButton ("3", 260,0,40,30,$BS_ICON)
	GUICtrlSetImage (-1, "shell32.dll",210)
	$reboot = GUICtrlCreateButton ("3", 167,105,40,40,$BS_ICON)
	GUICtrlSetImage (-1, "shell32.dll",112)
	$user = GUICtrlCreateButton ("3", 212,105,40,40,$BS_ICON)
	GUICtrlSetImage (-1, "shell32.dll",170)
	$event = GUICtrlCreateButton ("3", 257,105,40,40,$BS_ICON)
	GUICtrlSetImage (-1, "shell32.dll",232)
	GUISetState(@SW_SHOW)
	While 2





		$msg = GUIGetMsg()
			Select
				Case $msg = $GUI_EVENT_CLOSE
				ExitLoop

				Case $msg = $info
				
				Opt("GUICoordMode",1)
				GUICreate("INFO", 300, 170,)
				GUICtrlCreateLabel ("Danke, dass Ihr das Programm benutzt!!", 5,20)
				GUICtrlCreateLabel ("Falls Ihr Fehler findet, bitte schickt mir eine Email", 5,80)
				GUICtrlCreateLabel ("Ich würde mich auch über Anregungen und/oder Kritik freuen!", 5,60)
				GUICtrlCreateLabel ("Ich hoffe, ich kann euch die Arbeit etwas erleichtern!", 5,40)
				GUICtrlCreateLabel ("Viel Spaß mit dem Tool!", 5,100)
				$n2=GUICtrlCreateIcon ( @windowsdir & "\cursors\dinosau2.ani", -1, 50,120,32,32)

				GUISetState (@SW_SHOW)

				Dim $b = 30
				While ($b < 238) 
					$b = $b + int(Random(0,1)+0.5)
					GUICtrlSetPos($n2, $b,115)
					Sleep(30)
				WEnd
				
				GUIDelete()
		
				Case $msg = $ping
				
				$var = Ping(GUICtrlRead($remotepc),250)
				If $var Then; also possible:  If @error = 0 Then ...
					Msgbox(0,"Status","Online!!!")
					Else
					$error = "Host is offline" & @CRLF & "or" & @CRLF & "unreachable"
					Msgbox(0,"Status","ERROR"  & @CRLF & $error)
				EndIf

				Case $msg =$druck
					
					
					FileDelete (@TempDir & "\test.txt")
					$file = FileOpen(@TempDir & "\test.txt", 1)
					If $file = -1 Then
    					MsgBox(0, "Error", "Unable to open file.")
    					EndIf	
					FileWriteLine($file,"TESTSEITE")

					FileClose($file)
					GUICreate("Printer Status", 300, 170,)
					GUICtrlCreateLabel ("Checking following Printer:", 20,20)
					GUISetFont (12,800)
					$printer = GUICtrlCreateLabel ("", 20,40,200,100)
					GUISetFont (8,400)				
					$ping = GUICtrlCreateLabel ( "", 40,74,200,100)
					$nslookup = GUICtrlCreateLabel ( "", 40,108,200,100)
					$dprint = GUICtrlCreateLabel ( "", 40,140,200,100)
					GUISetState()

					Dim $Suf[15]  ; This creates the array with 15 elements (0 - 14)
					$Suf[0]=".muc"
					$Suf[1]=".w1"
					$Suf[2]=".w2"
					$Suf[3]=".w3"
					$Suf[4]=".w4"
					$Suf[5]=".w5"
					$Suf[6]=".w6"
					$Suf[7]=".w7"
					$Suf[8]=".w8"
					$Suf[9]=".w12"
					$Suf[10]=".w34"
					$Suf[11]=".w50"
					$Suf[12]=".bank"
					$Suf[13]=".al.group-net.de"
					$Suf[14]=""
					For $r = 0 to 14
						$ps = $Suf[$r]
						GUICtrlSetData ( $printer,""&GUICtrlRead($remotepc)&$ps)
						$var = Ping(GUICtrlRead($remotepc)& $ps,250)

						If @error = 0 Then
							$ok = GUICtrlCreateicon ("3", 20,8,65,40,$BS_ICON)
							GUICtrlSetImage (-1, "shell32.dll",216)
							GUICtrlSetData ( $ping,"Ping is OK!!")
							$rempcsuf = GUICtrlRead($remotepc)&$ps
							$color1 = "1"
							sleep(30)
							
							Exitloop
						
			
						Else
							$ok = GUICtrlCreateicon ("3", 10,5,65,40,$BS_ICON)
							GUICtrlSetImage (-1, "shell32.dll",131)							
    							GUICtrlSetData ( $ping,"Ping -> not responding!!!!")
							$color1 = "0"
							$rempcsuf = GUICtrlRead($remotepc)
							sleep(30)
						EndIf
					Next
					sleep(100)
					
					
					$LprCmd = "lpr -S " & $rempcsuf & " -P " & $rempcsuf & " " & @TempDir & "\test.txt"
					$ErrLvl = RunWait($LprCmd, @TempDir, @SW_SHOW) 
					If $ErrLvl = 0 Then

						$ok = GUICtrlCreateicon ("3", 20,8,130,40,$BS_ICON)
						GUICtrlSetImage (-1, "shell32.dll",216)
						GUICtrlSetData ( $dprint,"Directprint was successfull!!!!")
						$color1 = $color1 + 1
						sleep(30)
						
					Else
						$ok = GUICtrlCreateicon ("3", 10,5,130,40,$BS_ICON)
						GUICtrlSetImage (-1, "shell32.dll",131)
						GUICtrlSetData ( $dprint,"Directprint not possible!!!!")
						$color1 = "0"
						sleep(30)
					EndIf
					
					If $rempcsuf = $rempcsuf Then
						$ok = GUICtrlCreateicon ("3", 20,8,98,40,$BS_ICON)
						GUICtrlSetImage (-1, "shell32.dll",131)	
						GUICtrlSetData ( $nslookup,"Im working on it!")
						$color1 = $color1 + 1
						sleep(30)
					Else
						$ok = GUICtrlCreateicon ("3", 20,8,98,40,$BS_ICON)
						GUICtrlSetImage (-1, "shell32.dll",131)	
						GUICtrlSetData ( $nslookup,"NSlookup not OK!")
						$color1 = 0
						sleep(30)
					EndIf	

					
					IF $color1 = 3 then
						$color ="0x14FF02"
						ELSE
						$color ="0xFF3300"
 					Endif
					$color = GUISetBkColor ($color)
					sleep(7000)
					GUIDelete()
					
					
				Case $msg = $DWRC
			
				GUICreate("This PC??", 300, 170,)
				GUISetFont (10,400)
				GUICtrlCreateLabel ("Is this the correct Name or IP?", 20,20)
				GUISetFont (15,400)
				GUICtrlCreateLabel (""& GUICtrlRead($remotepc), 20,55)
				$yes = GUICtrlCreateButton(" YES ", 20,100,60,40)
				$no = GUICtrlCreateButton(" NO ", 120,100,60,40)
				$done = GUICtrlCreateButton ("3", 220,100,60,40,$BS_ICON)
				GUICtrlSetImage (-1, "shell32.dll",27)
				GUISetState(@SW_SHOW)

				While 3
				$msg = GUIGetMsg()
				Select
					Case $msg = $GUI_EVENT_CLOSE
					ExitLoop

					Case $msg = $yes
					
						MsgBox(0, "YES", "OK,..." & @CRLF & "Let's go...", 1.5)
						SplashTextOn("Don't touch!", @CRLF & @CRLF & @CRLF & @CRLF & @CRLF & "DON'T TOUCH THE KEYBOARD" & @CRLF & "OR THE MOUSE!", 500, 400, -1, -1, 2, "", 22)
						Sleep(4000)
						$DeletePath = "\\" & GUICtrlRead($remotepc) & "\c$\WINDOWS\system32\DWRC*.*"
						If FileDelete($DeletePath) Then
    						MsgBox(0, "Message", "Files deleted successfully at:" & @CRLF &  @Tab & $DeletePath, 2)
						Else
							MsgBox(16, "Error", "Error deleting files at:" & @CRLF & @Tab & $DeletePath, 5)
							SplashOff ( )
						EXITLOOP
						
						EndIf
						run("eventvwr "& GUICtrlRead($remotepc))
						WinWaitactive("Event Viewer")
						Send("{DOWN}")
						Sleep(1000)
						Send("!trn")
						Send("{DOWN}")
						Sleep(1000)
						Send("!trn")
						Send("{DOWN}")
						Sleep(1000)
						Send("!trn")
						sleep(500)
						Send("!d+b")
						WinWaitClose("Event Viewer")
						SplashOff ( )

						MsgBox(0,"Finish", "The DWRC files should be deleted! And the Eventlog should be cleared!", 5)
					
						GUIDelete()
						EXITLOOP
					Case $msg = $done

					GUIDelete()
					EXIT
					EXITLOOP


					Case $msg = $no
					GUIDelete()
					EXITLOOP



				EndSelect

				$msg = $GUI_EVENT_CLOSE

				Wend
				GUIDelete()

				Case $msg = $exit
				GUIDelete()
				EXIT
				
				
				Case $msg = $reboot
				
				GUICreate("Reboot this PC??", 300, 170,)
				GUISetFont (10,400)
				GUICtrlCreateLabel ("Do you want to restart this PC??", 20,20)
				GUISetFont (15,400)
				GUICtrlCreateLabel (""& GUICtrlRead($remotepc), 20,55)
				$yes = GUICtrlCreateButton(" YES ", 80,100,60,40)
				$no = GUICtrlCreateButton(" NO ", 140,100,60,40)
				GUISetState(@SW_SHOW)

				While 3
				$msg = GUIGetMsg()
				Select
					Case $msg = $GUI_EVENT_CLOSE
					ExitLoop

					Case $msg = $yes
					Run("cmd")
					Winwait("C:\WINDOWS\system32\cmd.exe")
					Send("shutdown -r -f -m \\" & GUICtrlRead($remotepc))
					Send("{ENTER}")
					Send("exit")
					Send("{ENTER}")
					MsgBox(0, "RESTART", "Remote Restart is initialized!", 2)
					GUIDelete()
					Case $msg = $no
					GUIDelete()
					ExitLoop
					EndSelect
				WEnd
				
				Case $msg = $user
					Run("cmd")
					Winwait("C:\WINDOWS\system32\cmd.exe")
					Send("lusrmgr.msc /computer=" & GUICtrlRead($remotepc))
					Send("{ENTER}")
					Send("exit")
					Send("{ENTER}")


				Case $msg = $event
					Run("cmd")
					Winwait("C:\WINDOWS\system32\cmd.exe")
					Send("compmgmt.msc /computer=" & GUICtrlRead($remotepc))
					Send("{ENTER}")
					Send("exit")
					Send("{ENTER}")
			EndSelect
		$msg = $GUI_EVENT_CLOSE

	Wend
	GUIDelete()
EXITLOOP


WEND
EXIT

