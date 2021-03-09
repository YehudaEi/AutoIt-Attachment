#include <GUIConstants.au3>
#include <WindowsConstants.au3>
#include <GuiTreeView.au3>
#include <Array.au3>

Opt( "MustDeclareVars", 1 )

Global $cmTV, $cmTV00
Global $cmTV00min, $cmTV00sub0, $cmTV00sub1, $cmTV00sub2, $cmTV00sub3, $cmTV00sub4, $cmTV00sub5, $cmTV00max

Global $hGui, $idTV, $hTV, $idTV2, $hTV2, $aLines[1], $lines = 0

MainScript()

Func MainScript()

	; Create GUI
	$hGui = GUICreate( "TreeView Controls", 412, 350, 600, 300, $GUI_SS_DEFAULT_GUI )

	; Create TreeView control
	$idTV = GUICtrlCreateTreeView( 4, 4, 200, 292, $GUI_SS_DEFAULT_TREEVIEW+$TVS_NOHSCROLL, $WS_EX_CLIENTEDGE )
	$hTV = ControlGetHandle( $hGui, "", $idTV )

	; Add root to TreeView control
	Local $hItem = _GUICtrlTreeView_Add( $hTV, 0, 0 )
	Local $iItem = 1

	; Context menu
	$cmTV = GUICtrlCreateContextMenu( $idTV )
	$cmTV00	= GUICtrlCreateMenu( "Make treeview items", $cmTV )
	$cmTV00sub0 = GUICtrlCreateMenuItem( "Make 1 node", $cmTV00 )
	$cmTV00sub1 = GUICtrlCreateMenuItem( "Make 2 nodes", $cmTV00 )
	$cmTV00sub2 = GUICtrlCreateMenuItem( "Make 10 nodes", $cmTV00 )
	$cmTV00sub3 = GUICtrlCreateMenuItem( "Make 10 childs", $cmTV00 )
	$cmTV00sub4 = GUICtrlCreateMenuItem( "Make 10 siblings", $cmTV00 )
	$cmTV00sub5 = GUICtrlCreateMenuItem( "Make 100 siblings", $cmTV00 )
	$cmTV00min = $cmTV00sub0
	$cmTV00max = $cmTV00sub5

	; Create TreeView control 2
	$idTV2 = GUICtrlCreateTreeView( 208, 4, 200, 292, $GUI_SS_DEFAULT_TREEVIEW+$TVS_NOHSCROLL, $WS_EX_CLIENTEDGE )
	$hTV2 = ControlGetHandle( $hGui, "", $idTV2 )

	; Buttons
	Local $idButCopy = GUICtrlCreateButton( "Copy", 14, 310, 80, 30 )
	Local $idButShow = GUICtrlCreateButton( "Show", 114, 310, 80, 30 )
	Local $idButCreate = GUICtrlCreateButton( "Create", 218, 310, 80, 30 )
	Local $idButDelete = GUICtrlCreateButton( "Delete", 318, 310, 80, 30 )

	; Show GUI
	GUISetState( @SW_SHOW, $hGui )

	; Message loop
	While 1

		Local $aMsg = GUIGetMsg(1)

		If $aMsg[0] = 0 Or $aMsg[0] = $GUI_EVENT_MOUSEMOVE Then ContinueLoop

		Switch $aMsg[1]

			; Events for the main GUI
			Case $hGui

				Switch $aMsg[0]

					Case $idButCopy
						CopyTV()

					Case $idButShow
						If $lines Then _ArrayDisplay( $aLines )

					Case $idButCreate
						If $lines Then CreateTV()

					Case $idButDelete
					_GUICtrlTreeView_BeginUpdate( $hTV2 )
					_GUICtrlTreeView_DeleteAll( $hTV2 )
					_GUICtrlTreeView_EndUpdate( $hTV2 )

					Case $cmTV00min To $cmTV00max
						MakeTVitems( $aMsg[0], $hItem, $iItem )

					Case $GUI_EVENT_CLOSE
						ExitLoop

				EndSwitch

		EndSwitch

	WEnd

	GUIDelete( $hGui )
	Exit

EndFunc

Func MakeTVitems( $cm, ByRef $hItem, ByRef $iItem )
	Switch $cm
		Case $cmTV00sub0
			; Make 1 node
			DeleteAll()
			$hItem = _GUICtrlTreeView_Add( $hTV, 0, 0 )
			For $i = 1 To 8
				_GUICtrlTreeView_AddChild( $hTV, $hItem, $i )
			Next
			$iItem = 9
			_GUICtrlTreeView_Expand( $hTV, $hItem )
			_GUICtrlTreeView_SelectItem( $hTV, $hItem )

		Case $cmTV00sub1
			; Make 2 nodes
			DeleteAll()
			$hItem = _GUICtrlTreeView_Add( $hTV, 0, 0 )
			Local $item = _GUICtrlTreeView_AddChild( $hTV, $hItem, 1 )
			For $i = 2 To 9
				_GUICtrlTreeView_AddChild( $hTV, $item, $i )
			Next
			For $i = 10 To 16
				_GUICtrlTreeView_Add( $hTV, $item, $i )
			Next
			$iItem = 17
			_GUICtrlTreeView_Expand( $hTV, $hItem )
			_GUICtrlTreeView_SelectItem( $hTV, $hItem )

		Case $cmTV00sub2
			; Make 10 nodes
			DeleteAll()
			$iItem = 1
			$hItem = _GUICtrlTreeView_Add( $hTV, 0, 0 )
			For $i = 0 To 8
				Local $item = _GUICtrlTreeView_AddChild( $hTV, $hItem, $iItem )
				$iItem += 1
				For $j = 0 To 2
					_GUICtrlTreeView_AddChild( $hTV, $item, $iItem )
					$iItem += 1
				Next
			Next
			_GUICtrlTreeView_Expand( $hTV, $hItem )
			_GUICtrlTreeView_SelectItem( $hTV, $hItem )

		Case $cmTV00sub3
			; Make 10 childs
			DeleteAll()
			$hItem = _GUICtrlTreeView_Add( $hTV, 0, 0 )
			Local $item = $hItem
			For $i = 1 To 9
				$item = _GUICtrlTreeView_AddChild( $hTV, $item, $i )
			Next
			$iItem = 10
			_GUICtrlTreeView_Expand( $hTV, $hItem )
			_GUICtrlTreeView_SelectItem( $hTV, $hItem )

		Case $cmTV00sub4
			; Make 10 siblings
			MakeSiblings( $hItem, $iItem, 10 )

		Case $cmTV00sub5
			; Make 100 siblings
			MakeSiblings( $hItem, $iItem, 100 )
	EndSwitch
EndFunc

Func DeleteAll()
	_GUICtrlTreeView_BeginUpdate( $hTV )
	_GUICtrlTreeView_DeleteAll( $hTV )
	_GUICtrlTreeView_EndUpdate( $hTV )
EndFunc

Func MakeSiblings( ByRef $hItem, ByRef $iItem, $iSiblings )
	DeleteAll()
	$hItem = _GUICtrlTreeView_Add( $hTV, 0, 0 )
	Local $item = $hItem
	_GUICtrlTreeView_BeginUpdate( $hTV )
	For $i = 1 To $iSiblings - 1
		$item = _GUICtrlTreeView_Add( $hTV, $item, $i )
	Next
	_GUICtrlTreeView_EndUpdate( $hTV )
	$iItem = $iSiblings
	_GUICtrlTreeView_Expand( $hTV, $hItem )
	_GUICtrlTreeView_SelectItem( $hTV, $hItem )
EndFunc

Func CopyTV()
	$lines = 0
	ReDim $aLines[10]
	Local $item = _GUICtrlTreeView_GetFirstItem( $hTV ), $level, $s
	While $item
		$s = ""
		$lines += 1
		; The level of a TV item is indicated by a number of hyphens in the start of the line
		; level 0 = 0 hyphens, level 1 = 2 hyphens, level 2 = 4 hyphens, ...
		$level = _GUICtrlTreeView_Level( $hTV, $item )
		For $i = 1 To $level
			$s &= "--"
		Next
		$aLines[$lines-1] = $s & _GUICtrlTreeView_GetText( $hTV, $item )
		If Mod( $lines, 10 ) = 0 Then ReDim $aLines[$lines+10]
		$item = _GUICtrlTreeView_GetNext( $hTV, $item )
	WEnd
	If $lines Then ReDim $aLines[$lines]
EndFunc

Func CreateTV()
	Local $aLevels[1], $level, $prevLevel = -1
	Local $line, $hyphens, $hItem

	_GUICtrlTreeView_BeginUpdate( $hTV2 )
	_GUICtrlTreeView_DeleteAll( $hTV2 )

	For $i = 0 To $lines - 1
		$line = $aLines[$i]

		; Count the number of hyphens in the start of the line to calculate the level
		$hyphens = 0
		While StringLeft( $line, 2 ) = "--"
			$hyphens += 2
			$line = StringRight( $line, StringLen( $line ) - 2 )
		WEnd
		$level = $hyphens / 2
		; The rest of the line is the TV item text

		If $level <> $prevLevel Then
			If $i = 0 Then
				; Add root to TreeView control
				$hItem = _GUICtrlTreeView_Add( $hTV2, 0, $line )
			Else
				If $level > $prevLevel Then
					; A child of the previous level
					$hItem = _GUICtrlTreeView_AddChild( $hTV2, $aLevels[$prevLevel], $line )
				Else ; $level < $prevLevel
					; A sibling of the level
					$hItem = _GUICtrlTreeView_Add( $hTV2, $aLevels[$level], $line )
				EndIf
			EndIf
			ReDim $aLevels[$level+1]
			$aLevels[$level] = $hItem ; $aLevels[$level] contains the last item of that level
			$prevLevel = $level
		Else ; $level = $prevLevel
			; A sibling of the level
			$hItem = _GUICtrlTreeView_Add( $hTV2, $aLevels[$level], $line )
			$aLevels[$level] = $hItem ; $aLevels[$level] contains the last item of that level
		EndIf
	Next

	_GUICtrlTreeView_Expand( $hTV2 )
	_GUICtrlTreeView_EndUpdate( $hTV2 )
EndFunc
