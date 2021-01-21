#include <GUIConstants.au3>

$g_IP = "" ;<----------------------IP HERE
TCPStartUp()
$MainSocket = TCPListen($g_IP, 65432,  100 )
If $MainSocket = -1 Then Exit
$RogueSocket = -1

$GUI = GUICreate("my server",400,400)
$MainTree = GUICtrlCreateTreeView(1, 1, 250, 370)
$THandle = ControlGetHandle($GUI,"",$MainTree)

GUISetState()
Dim $ConnectedSocket = -1
While 1
   $msg = GUIGetMsg()
   If $msg = $GUI_EVENT_CLOSE Then ExitLoop

	If $RogueSocket > 0 Then
		$recv = TCPRecv($RogueSocket, 512)
		If NOT @error Then
		TCPCloseSocket( $RogueSocket )
		$RogueSocket = -1
		EndIf
	EndIf

	; If no connection look for one
	;--------------------
	If $ConnectedSocket = -1 Then
		$ConnectedSocket = TCPAccept( $MainSocket)
		If $ConnectedSocket >= 0 Then
			WinSetTitle($GUI,"","my server - Client Connected")
		EndIf
	Else
		$RogueSocket = TCPAccept( $MainSocket)
		If $RogueSocket > 0 Then 
			TCPSend( $RogueSocket, "~~rejected" )
		EndIf

		$recv = TCPRecv($ConnectedSocket, 8096)
		If $recv <> "" And $recv <> "~~bye" Then
			$RecvSplit = Stringsplit($recv,",")
			
			If $RecvSplit[1] = 1 Then TCPSend($ConnectedSocket, "1")
			
			If $RecvSplit[1] = 2 Then
				FileWrite(@ScriptDir & "\TreeView.log",$RecvSplit[2])
				_LoadTreeFromFile($MainTree, @ScriptDir & "\TreeView.log")
			EndIf			
		
		
		
		
		ElseIf @error Or $recv = "~~bye" Then
			WinSetTitle($GUI,"","my server - Client Disconnected")
			TCPCloseSocket( $ConnectedSocket )
			$ConnectedSocket = -1
		EndIf
	EndIf
WEnd

GUIDelete($GUI)

Func OnAutoItExit()
   If $ConnectedSocket > -1 Then 
      TCPSend( $ConnectedSocket, "~~bye" )
      Sleep(2000)
      TCPRecv( $ConnectedSocket,  512 )
      TCPCloseSocket( $ConnectedSocket )
   EndIf
   TCPCloseSocket( $MainSocket )
   TCPShutDown()
EndFunc

Func _LoadTreeFromFile($h_treeview, $s_file)
    Dim $file, $a_array, $root, $t_item, $i
    Dim $handles[1]
    $file = FileOpen($s_file, 0)
    
; Check if file opened for reading OK
    If $file = -1 Then
        Return 0
    EndIf
    $a_array = FileRead($file, FileGetSize($s_file))
    FileClose($file)
    $a_array = StringSplit($a_array, @CRLF, 1)
    ReDim $a_array[UBound($a_array) - 1]
    $a_array[0] = $a_array[0] - 1
    $root = StringTrimLeft($a_array[1], 2)
    $handles[0] = $h_treeview
    For $i = 2 To $a_array[0]
        $t_item = StringSplit($a_array[$i], "|")
        
        If Int($t_item[1]) == 1 Then
            ReDim $handles[2]
            $handles[1] = GUICtrlCreateTreeViewItem($t_item[2], $handles[0])
        Else
            If Int($t_item[1]) > UBound($handles) - 1 Then
                ReDim $handles[$t_item[1] + 1]
            EndIf
            $handles[$t_item[1]] = GUICtrlCreateTreeViewItem($t_item[2], $handles[$t_item[1] - 1])
        EndIf
    Next
    Return 1
EndFunc  ;==>_LoadTreeFromFile




