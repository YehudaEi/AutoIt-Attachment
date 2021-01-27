########################
# Author : S Allwyn Jesu
# Purpose: Chat server
# Dated  : 23 july 09
# Version: v1.4
########################

#RequireAdmin
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <GuiEdit.au3>
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>

TCPStartup()
$nickname=InputBox("Nickname","Enter the your nickname to chat","","",300,140)
	if $nickname="" Then 
		MsgBox(16,"Invalid entry","Cannot proceed without nickname") 
		Exit
	EndIf
	
	$nickname=$nickname&":"
	$szServerPC = @ComputerName
    $szIPADDRESS = TCPNameToIP($szServerPC)
	
	$mainsocket=TCPListen($szIPADDRESS,4444,10)
	#MsgBox(0,"",$szIPADDRESS)
	
	$ClientSocket=-1
		While $ClientSocket=-1
			TrayTip("Server","Waiting for client",5,1)
			Sleep(4000)
			$ClientSocket=TCPAccept($mainsocket)
		WEnd
			
		if $ClientSocket>1 Then
			$mainwindow=GUICreate($nickname,300,250)
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
				$recv = TCPRecv($ClientSocket, 2048)
				If @error Then ExitLoop

				If $recv <> "" Then GUICtrlSetData($edit,GUICtrlRead($edit)&@CRLF&$recv)
			
				$msg=GUIGetMsg()
				Select
					Case $msg=$chat
						GUICtrlSetData($edit,GUICtrlRead($edit)&@CRLF&$nickname&GUICtrlRead($value))
						TCPSend($ClientSocket,$nickname&GUICtrlRead($value))
						GUICtrlSetData($value,"")
			
					Case $msg=$GUI_EVENT_CLOSE  Or $msg=$exit
						Exit
					
				EndSelect	
	
			WEnd

		EndIf 