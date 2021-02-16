#include <array.au3>
;=======================================================================================================
;-------------DYNAMIC NODE GRAPH UDF: DYNAMICALLY CREATE GRAPHS AND PERFORM SEARCHES ON THEM------------

;						USES: NETWORK ROUTING, MAZE COMPLETION, GAMING, BOTTING
;What is different in this UDF to other autoit path finding mechanisms is that this one is geared to have your
;own programs dynamically create your nodes, and this UDF allows an unlimited number of neighbours. So, applications
;That require more than four nodes, such as network routing, can be used, where as A* will not be compatible.

;YOU WILL BE VERY CONFUSED BY THIS - PLEASE LOOK AT MY EXAMPLES WHICH WILL SHOW YOU HOW TO IMPLEMENT THIS!!!

;=======================================================================================================
Global $node_graph[1][5]
global $openlist_str = ""
global $closedlist_str = ""
global $openlist = _ArrayCreate("empty")
global $closedlist = _ArrayCreate("empty")

global $ID_list_str = ""
;global $neigh[6] = [ 6, 24, 74, 84, 44, 23]
;global $neigh1[6] = [12, 5, 8, 71, 58, 34]
;global $neigh2[1] = [9]
;Create_Node(1, "TEST", $neigh)
;Create_Node(2, "TEST1", $neigh1)
;Create_Node(27, "TEST2", $neigh2)
;Add_neighbour_by_ref( "TEST", "TEST1")
;Add_neighbour(12, 27)
;Show_graph()
;ConsoleWrite(Find_Shortest_Path( 1, 27))

;Create_Node_No_Neighbours( "COOLies")
;Show_graph()
;=========================================
;Function: Create_Node
;Creates a node and implements it into the node graph.
;PARAMETERS:
;$refnum = The node-number, must be unique to all nodes.
;$name = A string used to identify the node in a real-world/end user context.
;Thus, must be unique, and is used for preventing the same node from being created twice.
;$neighbour_array = An array containing the refnum of all neighbours.
;neighbours do not have to exist at this time. The array should start at [0].
;=========================================
Func Create_Node($refnum, $name, ByRef $neighbour_array)
	if $refnum = "" then $refnum = UBound( $node_graph)
	Local $node_ID = $refnum
	if $node_ID > UBound($node_graph)-2 then ReDim $node_graph[$node_ID+1][UBound( $node_graph, 2)]
	Local $num_neighbours = UBound( $neighbour_array)
	$node_graph[$node_ID][0] = $name
	$node_graph[$node_ID][1] = ""
	if UBound( $node_graph, 2)-2 < $num_neighbours+2 Then
		ReDim $node_graph[$node_ID+1][$num_neighbours+5]
	EndIf
	for $x = 0 to UBound( $neighbour_array)-1 step 1
		if $neighbour_array[$x] > UBound($node_graph)-2 then ReDim $node_graph[$neighbour_array[$x]+1][UBound( $node_graph, 2)]
		if UBound( $neighbour_array)>Ubound($node_graph, 2)-2 then ReDim $node_graph[UBound( $node_graph)][UBound( $neighbour_array)+5]
		$node_graph[$node_ID][$node_graph[$node_ID][2]+$x+3] = $neighbour_array[$x]
		;look at the neighbour node, and see if they already have you as a neighbour.
		$callout = False
		For $xo = 0 to $node_graph[$neighbour_array[$x]][2] step 1
			if $node_graph[$neighbour_array[$x]][$xo+3] = $node_ID then
				$callout = True ;They do, so DONT BOTHER THEM
				ExitLoop
			EndIf
		Next
		if $callout = False Then ;They don't, so ADD YOU AS A NEIGHBOUR. RAWRRRRR
			$node_graph[$neighbour_array[$x]][2] += 1
			$node_graph[$neighbour_array[$x]][$node_graph[$neighbour_array[$x]][2]+2] = $node_ID
		EndIf
	Next
	$node_graph[$node_ID][2] += $num_neighbours
EndFunc

Func Create_Node_No_Neighbours( $name)
	Local $node_ID = Ubound( $node_graph)
	ReDim $node_graph[$node_ID+1][UBound( $node_graph, 2)]
	$node_graph[$node_ID][2] = 0
	$node_graph[$node_ID][0] = $name
	$node_graph[$node_ID][1] = ""
	return $node_ID
EndFunc

Func Get_Unused_nodeslot()
	return UBound( $node_graph)
EndFunc
Func Add_neighbour( $nodeID, $neighbourID)
	$exists = False
	for $x = 0 to $node_graph[$nodeID][2] step 1
		if $node_graph[$nodeID][$x+3] = $neighbourID Then $exists = True
	Next
	if not $exists then
		if $node_graph[$nodeID][2]+2>Ubound($node_graph, 2)-3 then ReDim $node_graph[UBound( $node_graph)][$node_graph[$nodeID][2]+5]
		$node_graph[$nodeID][2] += 1
		$node_graph[$nodeID][$node_graph[$nodeID][2]+2] = $neighbourID
	EndIf
	for $x = 0 to $node_graph[$neighbourID][2] step 1
		if $node_graph[$neighbourID][$x+3] = $nodeID Then return 0
	Next
	if $node_graph[$neighbourID][2]+2>Ubound($node_graph, 2)-3 then ReDim $node_graph[UBound( $node_graph)][$node_graph[$neighbourID][2]+5]
	$node_graph[$neighbourID][2] += 1
	$node_graph[$neighbourID][$node_graph[$neighbourID][2]+2] = $nodeID
EndFunc

Func Show_Graph()
	_ArrayDisplay( $node_graph, "Node Graph @" & @MIN & ":" & @SEC & " (neighbours truncated @28)", -1, 0, "", "|", "REFNUM|Identifier name|Search Parent| neighbour count|N1|N2|N3|N4|N5|N6|N7|N8|N9|N10|N11|N12|N13|N14|N15|N16|N17|N18|N19|N20|N21|N22|N23|N24|N25|N26|N27|N28|")
EndFunc

Func Count_nodes()
	return Ubound($node_graph)-2
EndFunc


Func Create_by_ref( $name)
	Local $node_ID = Ubound( $node_graph)
	ReDim $node_graph[$node_ID+1][UBound( $node_graph, 2)]
	$node_graph[$node_ID][2] = 0
	$node_graph[$node_ID][0] = $name
	$node_graph[$node_ID][1] = ""
	return $node_ID
EndFunc

FUnc Get_by_ref( $name, $auto_create=False)
	for $x = 1 to UBound( $node_graph)-1 step 1
		if $node_graph[$x][0] = $name then return $x
	Next
	if $auto_create then return Create_by_ref( $name)
	SetError(1)
	return -1
EndFunc

Func Add_neighbour_by_ref( $name1, $name2, $autocreate = False)
	$1ID = -1
	$2ID = -1
	for $x = 1 to UBound( $node_graph)-1 step 1
		if $node_graph[$x][0] = $name1 then
			$1ID = $x
			ExitLoop
		Endif
	Next
	for $x = 1 to UBound( $node_graph)-1 step 1
		if $node_graph[$x][0] = $name2 then
			$2ID = $x
			ExitLoop
		Endif
	Next
	if $autocreate Then
		if $1ID = -1 then $1ID = Create_by_ref( $name1)
		if $2ID = -1 Then $2ID = Create_by_ref( $name2)
	EndIf
	if $1ID = -1 or $2ID = -1 Then
		SetError(1)
		return -1
	EndIf
	return Add_neighbour( $1ID, $2ID)
EndFunc
Func Find_Shortest_Path( $start, $finish)
	for $x = 1 to UBound( $node_graph)-1 step 1
		$node_graph[$x][1] = ""
	Next
	global $openlist = _ArrayCreate("empty")
	global $closedlist = _ArrayCreate("empty")
	global $openlist_str = "#"& $start & ":"
	global $closedlist_str = "#"& $start & ":"
	Add_neighbours_to_search( $start)
	$lastnode = $start
	While UBound( $openlist) > 1
		$currentnode = $openlist[1]
		_ArrayDelete($openlist, 1)
		if $currentnode = $finish then return String_Path( $start, $finish)
		Add_neighbours_to_search( $currentnode)
		$lastnode = $currentnode
	WEnd
	SetError(1)
	return -1
EndFunc

Func String_Path( $start, $fin_node)
	$str = ""
	$currnode = $fin_node
	While 1
		$str &= $currnode
		if $currnode = $start then
			$split = StringSplit($str, "->", 1)
			$str = ""
			for $q = $split[0] to 1 step -1
				$str &= $split[$q]
				if $q > 1 then $str &= "->"
			Next
			return $str
		EndIf
		$str &= "->"
		$currnode = $node_graph[$currnode][1]
	WEnd
EndFunc

Func Add_neighbours_to_search( $node)
	for $x = 0 to $node_graph[$node][2] step 1
		if $node_graph[$node][$x+3] <> "" then
			if not Is_closed( $node_graph[$node][$x+3]) Then $node_graph[$node_graph[$node][$x+3]][1] = $node
			if not Is_closed( $node_graph[$node][$x+3]) Then
				Add_to_lists( $node_graph[$node][$x+3])
			EndIf
		EndIf
	Next
EndFunc

Func Is_closed( $node)
	If StringRegExp($closedlist_str, "#" & $node & ":") Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc

Func Add_to_lists($node)
	ReDim $openlist[UBound($openlist) + 1]
	$openlist[UBound($openlist) - 1] = $node
	ReDim $closedlist[UBound($closedlist) + 1]
	$closedlist[UBound($closedlist) - 1] = $node
	$openlist_str &= "#"& $node & ":"
	$closedlist_str &= "#"& $node & ":"
EndFunc   ;==>_Add_List