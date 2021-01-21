#include <GUIConstants.au3>

GUICreate("GUI with more treeviews",340,200,-1,-1,BitOr($WS_MINIMIZEBOX,$WS_MAXIMIZEBOX,$WS_GROUP,$WS_CAPTION,$WS_POPUP,$WS_SYSMENU))

$maintree = GUICtrlCreateTreeView (10,10,120,150)
$generalitem = GUICtrlCreateTreeViewItem ("My Computer",$maintree)
$effectitem = GUICtrlCreateTreeViewItem ("C: SYSTEM",$generalitem)
$styleitem = GUICtrlCreateTreeViewItem ("D: Documents",$generalitem)
$styleitem = GUICtrlCreateTreeViewItem ("E: CD-ROM",$generalitem)
$styleitem = GUICtrlCreateTreeViewItem ("F: JUKEBOX",$generalitem)
$jukebox = GUICtrlCreateTreeViewItem ("MUSIC",$styleitem)

GUICtrlSetState (-1,$GUI_HIDE)

$effectsgroup = GUICtrlCreateGroup ("Effects",140,5,180,95)
GUICtrlSetState (-1,$GUI_HIDE)
$effectstree = GUICtrlCreateTreeView (150,20,160,70,BitOr($TVS_CHECKBOXES,$TVS_DISABLEDRAGDROP),$WS_EX_CLIENTEDGE)
GUICtrlSetState (-1,$GUI_HIDE)
$effect1 = GUICtrlCreateTreeViewItem ("File 1",$effectstree)
$effect2 = GUICtrlCreateTreeViewItem ("File 2",$effectstree)
$effect3 = GUICtrlCreateTreeViewItem ("File 3",$effectstree)
$effect4 = GUICtrlCreateTreeViewItem ("File 4",$effectstree)
$effect5 = GUICtrlCreateTreeViewItem ("File 5",$effectstree)

$stylesgroup = GUICtrlCreateGroup ("Styles",140,5,180,95)
GUICtrlSetState (-1,$GUI_HIDE)
$stylestree = GUICtrlCreateTreeView (150,20,160,70,BitOr($TVS_CHECKBOXES,$TVS_DISABLEDRAGDROP),$WS_EX_CLIENTEDGE)
GUICtrlSetState (-1,$GUI_HIDE)
$style1 = GUICtrlCreateTreeViewItem ("File 1",$stylestree)
$style2 = GUICtrlCreateTreeViewItem ("File 2",$stylestree)
$style3 = GUICtrlCreateTreeViewItem ("File 3",$stylestree)
$style4 = GUICtrlCreateTreeViewItem ("File 4",$stylestree)
$style5 = GUICtrlCreateTreeViewItem ("File 5",$stylestree)

$aboutlabel = GUICtrlCreateLabel ("Only the layout edited, don't use this source please...",160,80,160,20)

$cancelbutton = GUICtrlCreateButton ("Cancel",130,170,70,20)
GUISetState()

GUIctrlSetState ($effect1,$GUI_CHECKED)
GUIctrlSetState ($effect3,$GUI_CHECKED)
GUIctrlSetState ($style4,$GUI_CHECKED)
GUIctrlSetState ($style5,$GUI_CHECKED)

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = -3 Or $msg = -1 Or $msg = $cancelbutton
			ExitLoop

		Case $msg = $jukebox
			GUIctrlSetState ($stylestree,$GUI_HIDE)
			GUIctrlSetState ($stylesgroup,$GUI_HIDE)
			GUIctrlSetState ($aboutlabel,$GUI_HIDE)
			GUIctrlSetState ($effectsgroup,$GUI_SHOW)

			GUICtrlSetState($effectstree,$GUI_SHOW)
			GUICtrlSetBkColor ($effectstree,0xD0F0F0)
			;GUIctrlSetState...($effectstree,$GUI_SHOW)
					
		Case $msg = $jukebox
			GUIctrlSetState ($effectstree,$GUI_HIDE)
			GUIctrlSetState ($effectsgroup,$GUI_HIDE)
			GUIctrlSetState ($aboutlabel,$GUI_HIDE)
			GUIctrlSetState ($stylesgroup,$GUI_SHOW)

			;GUIctrlSetState.($stylestree,$GUI_SHOW)
			GUICtrlSetState ($stylestree,$GUI_SHOW)
			GUICtrlSetColor ($stylestree,0xD00000)
			GUICtrlSetBkColor ($stylestree,0xD0FFD0)
			
	EndSelect
WEnd

GUIDelete()
Exit