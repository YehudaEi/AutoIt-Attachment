;+-------------------------------
;|
;|Script: 
;|		Chatserver - Simplified.
;|
;|Author:
;|		jokke
;|
;|Version:
;|		1.7 - Release.
;|
;+-------------------------------

#include <file.au3>

$logfile = 'log.txt'
$iniuser = 'users.ini'

Dim $server[4] = [@IPAddress1,'23','10000','100']
Dim $ids[$server[3]][6],$recv,$recive

TCPStartup()
Dim $link[$server[3]]
$vvv=0
While $vvv<$server[3]
    $link[$vvv]=-1
    $vvv=$vvv+1
WEnd
$main=TCPListen($server[0],$server[1])
While 1=1
    $i=0
    While $i<$server[3]
        If $link[$i]=-1 Then
            $link[$i]=TCPAccept($main)
			For $x = 1 To _FileCountLines('motd.txt')
				TCPSend($link[$i],FileReadLine('motd.txt',$x)&@CRLF) ;Sending message of today.
			Next
            ExitLoop
        EndIf
        $i=$i+1
    WEnd
    $j=0
    While $j<$server[3]
        If $link[$j]<>-1 Then
			
			$now = @HOUR&':'&@MIN&':'&@SEC&' '
			
            $ids[$j][5] = TCPRecv($link[$j],$server[2])
			If @error Then				
				TCPCloseSocket( $link[$j] )
				$link[$j] = -1
				$ddd=0
				
				If $ids[$j][0] = '' Then
					
				Else
					While $ddd<$server[3]
						If $link[$ddd]<>-1 Then
							TCPSend($link[$ddd],$now&$ids[$j][0]&' logged off. '&@CRLF) ;Send message to everyone!
						EndIf
						$ddd=$ddd+1
					WEnd
				EndIf
				$ids[$j][0] = ''
				$ids[$j][1] = ''
				$ids[$j][2] = ''
				$ids[$j][3] = ''
				$ids[$j][4] = ''
				$ids[$j][5] = ''
			EndIf
			
			$ids[$j][4] = $ids[$j][4] & $ids[$j][5]
			
			If $ids[$j][5] <> '' Then
				If $ids[$j][5] = Chr(8) Then
					If $ids[$j][4] = '' Then
						
					Else
						$len = StringLen($ids[$j][4])
						$ids[$j][4] = StringLeft($ids[$j][4],$len-2)
					EndIf
				EndIf
				If $ids[$j][5] = @CRLF Then
					$ddd=0
					
					$ids[$j][4] = StringReplace($ids[$j][4],@CRLF,'')
					
					;+-------------------------------------------
					;|newuser command.
					;+-------------------------------------------
					
					If StringInStr($ids[$j][4],'newuser') = 1 Then
						$tmp = StringSplit($ids[$j][4],'|')
						If @error Then
							
						Else
							If $tmp[0] > 4 Then
								$temp = IniRead($iniuser,$tmp[2],'Password','')
									
									
								If $temp = '' Then ;User does not exist.
									IniWrite($iniuser,$tmp[2],'UserName',$tmp[2])
									IniWrite($iniuser,$tmp[2],'Password',$tmp[3])
									IniWrite($iniuser,$tmp[2],'FullName',$tmp[4])
									IniWrite($iniuser,$tmp[2],'Email',$tmp[5])
									IniWrite($iniuser,$tmp[2],'State','None')
									
									TCPSend($link[$j],'User created, you are now able to log inn.'&@CRLF)
								Else
									TCPSend($link[$j],'Error, user does allready exist.'&@CRLF)
								EndIf
							Else
								TCPSend($link[$j],'Error, text delimited wrong.'&@CRLF)
							EndIf
						EndIf
					EndIf
					
					;+-------------------------------------------
					;|login command.
					;+-------------------------------------------
					
					If StringInStr($ids[$j][4],'login') = 1 Then
						$tmp = StringRegExp($ids[$j][4], 'login\s(.*?)\s(.*)', 3)
						If @error Then
							TCPSend($link[$j],'Error try to login again.'&@CRLF)
						Else
							
							$notallowed = 0
							
							For $x = 0 To $server[3] -1
								
								If $ids[$x][0] = $tmp[0] Then
									$notallowed = 1
								EndIf
								
							Next
							
							If $notallowed = 1 Then
								TCPSend($link[$j],'User allready logged inn.'&@CRLF)
							Else
								
								
								$temp = IniRead($iniuser,$tmp[0],'Password','')
									
								If $temp = '' Then
									TCPSend($link[$j],'Error, user does NOT exist. Use newuser command to create user.'&@CRLF)
								ElseIf $temp = $tmp[1] Then
									$ids[$j][0] = IniRead($iniuser,$tmp[0],'UserName','')
									$ids[$j][1] = IniRead($iniuser,$tmp[0],'FullName','')
									$ids[$j][2] = IniRead($iniuser,$tmp[0],'Email','')
									$ids[$j][3] = IniRead($iniuser,$tmp[0],'State','')
									
									TCPSend($link[$j],'Hi '&$ids[$j][1]&' welcome.'&@CRLF)
									
								EndIf
								
								
							EndIf
						EndIf
						
					EndIf
					
					;+-------------------------------------------
					;|Help command.
					;+-------------------------------------------
					
					If StringInStr($ids[$j][4],'help') = 1 Then
						For $x = 1 To _FileCountLines('help.txt')
							TCPSend($link[$j],FileReadLine('help.txt',$x)&@CRLF)
						Next
					EndIf
					
					;+-------------------------------------------
					;|Listall command.
					;+-------------------------------------------
					
					If StringInStr($ids[$j][4],'listall') = 1 Then
						
						$send = 0 
						
						For $x = 0 To $server[3] -1
							If $ids[$x][2] <> '' Then
								If $ids[$x][0] = '' Then
									$ids[$x][0] = 'None'
								EndIf
								TCPSend($link[$j],'User: '&$ids[$x][0]&' is online, state: '&$ids[$x][3]&@CRLF)
								$send = 1
							EndIf
						Next
						
						If $send = 0 Then
							TCPSend($link[$j],$now&'Sorry there are no users online at the moment.'&@CRLF)
						EndIf
						
					EndIf
					
					;+-------------------------------------------
					;|Listchat command.
					;+-------------------------------------------	
						
					If StringInStr($ids[$j][4],'listchat') = 1 Then
						For $x = 1 To _FileCountLines('log.txt')
							TCPSend($link[$j],FileReadLine('log.txt',$x)&@CRLF)
						Next
					EndIf
					
					;+-------------------------------------------
					;|setstate command.
					;+-------------------------------------------
					
					If StringInStr($ids[$j][4],'setstate') = 1 Then
						
						If $ids[$j][0] = '' Then
							TCPSend($link[$j], $now&'You are not logged on.' & @CRLF)
						Else
							$tmp = StringRegExp($ids[$j][4], 'setstate\s(.*)', 3)
							If @error Then
								TCPSend($link[$j],$now& 'Error try to set state again.' & @CRLF)
							Else
								If $tmp[0] = '' Then
									TCPSend($link[$j],$now& 'Error try to set state again.' & @CRLF)
								Else
									$ids[$j][3] = $tmp[0]
									
									IniWrite($iniuser,$ids[$j][0],'State',$ids[$j][3])
									
									
									While $ddd<$server[3]
										If $link[$ddd]<>-1 Then
											TCPSend($link[$ddd],$now&$ids[$j][0]&' sets state to: '&$ids[$j][3]&@CRLF) ;Send message to everyone!
										EndIf
										$ddd=$ddd+1
									WEnd
								EndIf
							
							EndIf
							
						EndIf
						
					EndIf	
					
					
					;+-------------------------------------------
					;|Sendall command.
					;+-------------------------------------------
					
					If StringInStr($ids[$j][4],'sendall') = 1 Then
						
						$tmp = StringReplace($ids[$j][4],'sendall','')
						
						If $ids[$j][0] = '' Then
							TCPSend($link[$j],$now& 'You are not logged on.' & @CRLF)
						Else
							
							$off = ''
							
							For $u = StringLen($ids[$j][0]) To 12
								
								$off = $off & '.'
								
							Next
							
							$log = FileOpen($logfile,1)
							FileWrite($log,$now&$ids[$j][0]&' says'&$off&':'&$tmp&@CRLF)
							FileClose($log)
							
							While $ddd<$server[3]
								If $link[$ddd]<>-1 Then
									TCPSend($link[$ddd],$now&$ids[$j][0]&' says'&$off&':'&$tmp&@CRLF) ;Send message to everyone!
									
								EndIf
								$ddd=$ddd+1
							WEnd
						EndIf
						
					EndIf
					
					;+-------------------------------------------
					;|sendto command.
					;+-------------------------------------------
					
					If StringInStr($ids[$j][4],'sendto') = 1 Then
						
						
						$tmp = StringRegExp($ids[$j][4], 'sendto\s(.*?)\s(.*)', 3)
						If @error Then
							TCPSend($link[$j],'Error try to send again.'&@CRLF)
						Else
							If UBound($tmp) < 1 Then
								TCPSend($link[$j],'Error try to send again.'&@CRLF)
							Else
								If $ids[$j][0] = '' Then
									TCPSend($link[$j], $now&'You are not logged on.' & @CRLF)
								Else
									
									$send = 0 
									
									For $x = 0 To $server[3] -1
										If $ids[$x][0] = $tmp[0] Then
											TCPSend($link[$x],$now&$ids[$j][0]&' whispers: '&$tmp[1]&@CRLF)
											$send = 1
										EndIf
									Next
									
									If $send = 0 Then
										TCPSend($link[$j],$now&'Unable to find: '&$tmp[0]&' try again with another name.'&@CRLF)
									Else
										TCPSend($link[$j],$now&'Message sent to: '&$tmp[0]&'.'&@CRLF)
									EndIf
								EndIf	
							EndIf
						EndIf
						
					EndIf				
					
					$ids[$j][5] = ''
					$ids[$j][4] = ''
				EndIf
			EndIf
        EndIf
        $j=$j+1
    WEnd
WEnd