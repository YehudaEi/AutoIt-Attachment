#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#Include <Misc.au3>
#Include <node_graph UDF.au3> ;This is mine!
$TOOL_STATE = 1 ;0 = Node place, 1 = Node link
$ALLOW_AutoDraw = True
Global $nodes[1][3]
Global $link[1][6]
$Search_start_node = ""
$Search_end_node = ""


;GUI GENERATION
$main_win = GUICreate( "Node Graph Visualizer - Draw Window", 700, 500, 20, 120)
GUISetState()
$tool_window = GUICreate( "Tool Window", 230, 250, 740, 190, $WS_POPUPWINDOW)
$tool_lab = GUICtrlCreateLabel( "Node Placement Tool", 80, 9, 150)
$lab = GUICtrlCreateLabel( "Tool:", 10, 10)
$button_toggle = GUICtrlCreateButton( "Toggle Tool", 70, 26, 120)
$search_lab = GUICtrlCreateLabel( "Shortest Path Search:", 10, 80, 150, 18)
$search_start = GUICtrlCreateLabel( "Start Node: --", 30, 100, 150, 18)
$search_end = GUICtrlCreateLabel( "End Node: --", 33, 120, 150, 18)
$search_setup = GUICtrlCreateButton( "Setup", 10, 135, 100)
$search_GO = GUICtrlCreateButton( "Go", 110, 135, 100)
$count_lab = GUICtrlCreateLabel("Total Nodes: 0", 73, 190, 200, 20)
$show_graph = GUICtrlCreateButton( "Show Node Graph", 15, 210, 200)
GUISetState()

_GDIPlus_Startup ()
global 	$hGraphic = _GDIPlus_GraphicsCreateFromHWND ($main_win)
_GDIPlus_GraphicsClear($hGraphic, 0xFFFFFFFF) ;Setup the graphics area.

AdlibRegister( "Draw", 200);Just incase the user moves it off the screen etc

While 1
	$msg = GUIGetMsg()
	Switch $msg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $search_GO
			Search_GO()
		Case $search_setup
			Search_setup()
		Case $show_graph
			Show_Graph()
			Draw()
		Case $button_toggle
			if $TOOL_STATE = 0 Then
				GUICtrlSetData( $tool_lab, "Node Placement Tool")
				$TOOL_STATE = 1
			ElseIf $TOOL_STATE = 1 Then
				GUICtrlSetData( $tool_lab, "Node link Tool")
				$TOOL_STATE = 0
			EndIf
	EndSwitch

	;Checking if Primary is pressed - So can put new node or link nodes.
	if _IsPressed(01) Then
		if not $TOOL_STATE then Draw_new_link_line()
		if $TOOL_STATE then Place_Node()
	EndIf
WEnd

Func Draw()
	if 	$ALLOW_AutoDraw Then
	_GDIPlus_GraphicsClear($hGraphic, 0xFFFFFFFF) ;Clear graphics area.
	$hPen = _GDIPlus_PenCreate ()
	For $x = 1 to UBound( $nodes)-1 step 1 ;Draw each node/Intersection/Corner
		_GDIPlus_GraphicsDrawRect($hGraphic, $nodes[$x][0], $nodes[$x][1], 8, 8, $hPen)
	Next
	For $x = 1 to UBound( $link)-1 step 1 ;Draw each link/track.
	_GDIPlus_GraphicsDrawLine ($hGraphic, $link[$x][0], $link[$x][1], $link[$x][2], $link[$x][3], $hPen)
	Next
	EndIf
EndFunc

FUnc Draw_new_link_line()
	$info = GUIGetCursorInfo ( $main_win)
	$startposx = $info[0]
	$startposy = $info[1]
	if $startposx > 0 and $startposx < 700 and $startposy > 0 and $startposy < 500 then ;See if click is in draw window
		GUISetCursor(3, -1, $main_win) ;Show the cross cursor.
		WHile _IsPressed(01) ;draw the line continuiously untill the button is released.
			Draw()
			$hPen = _GDIPlus_PenCreate ()
			$info = GUIGetCursorInfo ( $main_win)
			_GDIPlus_GraphicsDrawLine ($hGraphic, $startposx, $startposy, $info[0], $info[1], $hPen)
			Sleep(10)
		WEnd;Button is released.
		$ret = Detect_closest_node( $startposx, $startposy, $info[0], $info[1]);Searches out geometrically for the closest node and snaps to it.
		if not @error Then
			ReDim $link[UBound($link)+1][6]
			$link[UBound($link)-1][0] = $nodes[$ret[0]][0]+4 ;Write these node co-ordinates as the link X and Y pos's
			$link[UBound($link)-1][1] = $nodes[$ret[0]][1]+4
			$link[UBound($link)-1][2] = $nodes[$ret[1]][0]+4
			$link[UBound($link)-1][3] = $nodes[$ret[1]][1]+4
			$link[UBound($link)-1][4] = $ret[0]
			$link[UBound($link)-1][5] = $ret[1]
			Add_neighbour( $nodes[$ret[0]][2], $nodes[$ret[1]][2]);Create the link between the nodes in our graph.
			Draw()
		Else
			Draw() ;User either has bad aim or didnt try and link two nodes.
		EndIf
		GUISetCursor(17, -1, $main_win);Put the cursor back to normal
	EndIf
EndFunc

FUnc Place_Node()
	$info = GUIGetCursorInfo ( $main_win)
	$startposx = $info[0]
	$startposy = $info[1]
	if $startposx > 0 and $startposx < 700 and $startposy > 0 and $startposy < 500 then;See if click in draw window
		$info = GUIGetCursorInfo ( $main_win)
		$startposx = $info[0]
		$startposy = $info[1]
		$hPen = _GDIPlus_PenCreate ()
		_GDIPlus_GraphicsDrawRect($hGraphic, $startposx-5, $startposy-5, 8, 8, $hPen)
		ReDim $nodes[UBound($nodes)+1][3]
		$nodes[UBound($nodes)-1][0] = $startposx-4
		$nodes[UBound($nodes)-1][1] = $startposy-4
		$nodes[UBound($nodes)-1][2] = Create_Node_No_Neighbours( $startposx&","&$startposy);Add our new node to the graph.
		WHile _IsPressed(01);Wait till button released
		WEnd
		GUiCtrlSetData($count_lab, "Total Nodes: " & Count_nodes()+1)
		Animate_square_out( $startposx, $startposy)
	EndIf
EndFunc

Func Detect_closest_node( $firstx, $firsty, $lastx, $lasty, $only_one = False)
	$node1 = -1
	$node2 = -1
	For $x = 0 to 13 step 1
		For $q = 1 to UBound( $nodes)-1 step 1
			if $nodes[$q][0]+4 > ($firstx-$x) and $nodes[$q][0]+4 < (($firstx-$x)+(2*$x)+5) and $nodes[$q][1]+4 > ($firsty-$x) and $nodes[$q][1]+4 < (($firsty-$x)+(2*$x)+5) Then
				$node1 = $q
				ExitLoop
			EndIf
		Next
	Next
	if $only_one Then
		If $node1 = -1 then
			SetError(1)
			return -1
		EndIf
		local $retarray[2] = [$node1, 0]
		return $retarray
	EndIf

	For $x = 0 to 13 step 1
		For $q = 1 to UBound( $nodes)-1 step 1
			if $nodes[$q][0]+4 > ($lastx-$x) and $nodes[$q][0]+4 < (($lastx-$x)+(2*$x)+5) and $nodes[$q][1]+4 > ($lasty-$x) and $nodes[$q][1]+4 < (($lasty-$x)+(2*$x)+5) Then
				$node2 = $q
				ExitLoop
			EndIf
		Next
	Next
	If $node1 = -1 or $node2 = -1 then
		SetError(1)
		return -1
	EndIf
	local $retarray[2] = [$node1, $node2]
	return $retarray
EndFunc

Func Animate_square_out( $firstx, $firsty)
	For $x = 0 to 8 step 1
		Draw()
		$hPen = _GDIPlus_PenCreate ()
		_GDIPlus_GraphicsDrawRect($hGraphic, $firstx-$x, $firsty-$x, (2*$x)+4, (2*$x)+4, $hPen)
		Sleep(10)
	Next
	Draw()
EndFunc

Func Search_setup()
	WHile _IsPressed(01) ;Wait for user to release the button
	Wend
	WHile not _IsPressed(01) ;Wait for user to click node
		ToolTip("Please click on the starting node.")
	WEnd
	$info = GUIGetCursorInfo ( $main_win)
	$startposx = $info[0]
	$startposy = $info[1]
	if $startposx > 0 and $startposx < 700 and $startposy > 0 and $startposy < 500 then;See if click in draw window
		$ret = Detect_closest_node( $startposx, $startposy, 0, 0, True)
		if not @error Then
			$Search_start_node = $ret[0]
			GUICtrlSetData( $search_start, "Start Node: " & $nodes[$ret[0]][2])
		Else
			WHile _IsPressed(01) ;Wait for user to release the button
			Wend
				ToolTip("")
			Return
		EndIf
	EndIf
	WHile _IsPressed(01) ;Wait for user to release the button
	Wend
	WHile not _IsPressed(01) ;Wait for user to click node
		ToolTip("Please click on the finishing node.")
	WEnd
	$info = GUIGetCursorInfo ( $main_win)
	$startposx = $info[0]
	$startposy = $info[1]
	if $startposx > 0 and $startposx < 700 and $startposy > 0 and $startposy < 500 then;See if click in draw window
		$ret = Detect_closest_node( $startposx, $startposy, 0, 0, True)
		if not @error Then
			$Search_end_node = $ret[0]
			GUICtrlSetData( $search_end, "End Node: " & $nodes[$ret[0]][2])
		Else
			WHile _IsPressed(01) ;Wait for user to release the button
			Wend
			ToolTip("")
			Return
		EndIf
	EndIf
	ToolTip("")
	WHile _IsPressed(01) ;Wait for user to release the button
	Wend
EndFunc

FUnc Search_GO()
	$search = Find_Shortest_Path( $nodes[$Search_start_node][2], $nodes[$Search_end_node][2])
	$ALLOW_AutoDraw = False
	ConsoleWrite( @CRLF & $search & @CRLF)
	$split = StringSplit($search, "->", 1)
	$hPen = _GDIPlus_PenCreate ()
	$colourPen = _GDIPlus_PenCreate (0xFFAA0000, 5)
	for $q = 1 to $split[0] step 1 ;NOW WE ANIMATE THE PATH. We split the path, locate each graphic, and print in red.
		_GDIPlus_GraphicsClear($hGraphic, 0xFFFFFFFF) ;Clear graphics area.
		For $x = 1 to UBound( $nodes)-1 step 1 ;Draw each node/Intersection/Corner. EXECPT the one we are colouring
			if $nodes[$x][2] <> $split[$q] Then
				_GDIPlus_GraphicsDrawRect($hGraphic, $nodes[$x][0], $nodes[$x][1], 8, 8, $hPen)
			Else
				_GDIPlus_GraphicsDrawRect($hGraphic, $nodes[$x][0], $nodes[$x][1], 8, 8, $colourPen)
			EndIf
		Next
		For $x = 1 to UBound( $link)-1 step 1 ;Draw each link/track.
		_GDIPlus_GraphicsDrawLine ($hGraphic, $link[$x][0], $link[$x][1], $link[$x][2], $link[$x][3], $hPen)
		Next
		Sleep(300)
	Next
	$ALLOW_AutoDraw = True
EndFunc
