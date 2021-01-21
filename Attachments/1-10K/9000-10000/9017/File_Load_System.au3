;;		Includes		;;
#include <GUIConstants.au3>

;;		Setup		;;
$title	=	"File Load System"
$width	=	512
$height	=	384
$handle	=	GUICreate($title,$width,$height,250,200,-1,$WS_EX_ACCEPTFILES)
$tabObj	=	GUICtrlCreateTab(0,0,$width,$height)

;;		** Tab Previewer **		;;
$tab_previewer	=	GUICtrlCreateTabItem("FLS Previewer")

;;		** Tab Encrypter **		;;
$tab_encrypter	=	GUICtrlCreateTabItem("Encrypter")
$title1_2	=	GUICtrlCreateLabel("File Encrypter Tool",20,25,$width,$height)
GUICtrlSetFont($title1_2,15,800)

;;		File Path Label		;;
$text1_2		=	GUICtrlCreateLabel("File Path: ",20,91,$width,$height)
GUICtrlSetFont($text1_2,11)

$label1_2		=	GUICtrlCreateInput("",100,93,250,15)
GUICtrlSetState($label1_2,$GUI_ACCEPTFILES)

$browse1_2	=	GUICtrlCreateButton("Browse..",355,90,50,19)

;;		Save Path Label		;;
$text2_2		=	GUICtrlCreateLabel("Save Path: ",20,125,$width,$height)
GUICtrlSetFont($text2_2,11)

$label2_2		=	GUICtrlCreateInput("",100,126,250,15)
GUICtrlSetState($label2_2,$GUI_ACCEPTFILES)

$browse2_2	=	GUICtrlCreateButton("Browse..",355,124,50,19)

;;		Password Label		;;
$password1_2	=	GUICtrlCreateInput("<password>",175,200,100,18,$ES_CENTER)
$passlvl1_2		=	GUICtrlCreateLabel("Level: ",360,200)
GUICtrlSetFont($passlvl1_2,11)





;;		** Tab Decrypter **		;;
$tab_decrypter	=	GUICtrlCreateTabItem("Decrypter")

;;		** Password **		;;
$tab_password	=	GUICtrlCreateTabItem("Password")

;;		** Help **		;;
$tab_help	=	GUICtrlCreateTabItem("Help")



GUISetState(@SW_SHOW,$handle)
While 1
	$event = GUIGetMsg()
	
	Select
		Case $event = $GUI_EVENT_CLOSE
			Exit
			
		Case $event = $browse1_2
			$fileload1_2 = FileOpenDialog("Select a File",@WorkingDir,"All Files (*.*)")
			
			If @error <> 0 Then
				GUICtrlSetData($label1_2,$fileload1_2)
			EndIf
	EndSelect
WEnd

Exit