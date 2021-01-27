########################
# Author : S Allwyn Jesu
# Purpose: Chat client
# Dated  : 23 july 09
# Version: v1.4
########################

#RequireAdmin
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <GuiEdit.au3>
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>

$mainwindow = GUICreate("Chat Window", 250, 170)

GUICtrlCreateLabel("Enter the IP",20,25,90,50)
$ip =GUICtrlCreateInput("",130,20,100,20)

TCPStartup()

GUICtrlCreateLabel("Enter your Nickname",20,65,100,50)
$nickname=GUICtrlCreateInput("",130,60,100,20)

$enter = GUICtrlCreateButton("Enter",40,110,70,30)
$exit=	GUICtrlCreateButton("Exit",150,110,70,30)

GUISetState(@SW_SHOW)

While 1
  $msg = GUIGetMsg(1)

  Select
	Case $msg[0] = $enter And $msg[1] = $mainwindow
        
        $ip=GUICtrlRead($ip)
		$nickname=GUICtrlRead($nickname)&":"
        
		if $ip <>"" Then
			MsgBox(64,"Status","Waiting for Server Connection")
		                 			
			$mainsocket=-1
			$mainsocket=TCPConnect($ip,4444)
		 
			if $mainsocket =-1 Then
				MsgBox(16,"Connection Failed","Cannot connect to that IP")
				Exit
			Else
	            GUISetState(@SW_HIDE,$mainwindow) 		
				$mainwindow1=GUICreate($nickname,300,250)
						
				GUISetState(@SW_SHOW)
				$edit=GUICtrlCreateEdit("",0,0,300,150,BitOR($ES_READONLY, $WS_VSCROLL))
				GUICtrlSetBkColor($edit,0xFFFFFF)
				GUICtrlSetColor($edit,0x000000)
				GUICtrlSetFont($edit, 9, 500, 2)  
				
				$value=GUICtrlCreateEdit("",0,160,300,50)
				GUICtrlSetBkColor($value,0xFFFFFF)
				GUICtrlSetColor($value,0x000000)
				GUICtrlSetFont($value, 9, 500, 2)
				
				$chat=GUICtrlCreateButton("Chat",40,220,80,30)
				$exit=GUICtrlCreateButton("Exit",160,220,80,30)
			
				while 1
					$recv = TCPRecv($mainsocket, 2048)
	
					If $recv <> "" Then GUICtrlSetData($edit,GUICtrlRead($edit)&@CRLF&$recv)
	
					$msg=GUIGetMsg()
					Select
						Case $msg=$chat
						
						GUICtrlSetData($edit,GUICtrlRead($edit)&@CRLF&$nickname&GUICtrlRead($value))
						TCPSend($mainsocket,$nickname&GUICtrlRead($value))
					
						GUICtrlSetData($value,"")
				
						Case $msg=$GUI_EVENT_CLOSE  Or $msg=$exit
						Exit
					EndSelect	
	
				WEnd
			EndIf 
		 
		Else
			MsgBox(48,"","Required fields must be filled")
			Exit
		EndIf
		

	Case $msg[0] = $GUI_EVENT_CLOSE And $msg[1] = $mainwindow or $msg[0]=$exit 
		Exit
				
  EndSelect
WEnd 
