#include <GUIConstants.au3>
GUICreate("Drive Scan - by Rakudave, Pangaea WorX",427,200,100,200,-1)
	$list = GUICtrlCreateListView ("Drive|Label|Type|Total Space (mb)|Free Space (mb)|Status           ",10,10,481,150)
	$var = DriveGetDrive("all")
	If @error = 1 then exit
		For $i = 1 to $var[0]
		$var[$i] = GUICtrlCreateListViewItem($var[$i] & "|" & DriveGetLabel($var[$i]) & "|" & DriveGetType($var[$i]) & "|" & Round(DriveSpaceTotal($var[$i]),2) & "|" & Round(DriveSpaceFree($var[$i]),2) & "|" & DriveStatus($var[$i]),$list)
		Next
	$ref = GuiCtrlCreateButton("Refresh",10,170,50)
	$emp = GuiCtrlCreateButton("Empty Recycle Bins",70,170,120)
GUISetState()
Do
	$msg = GUIGetMsg()
		If $msg = $ref then
		  	$var = DriveGetDrive("all")
		  	$list = GUICtrlCreateListView ("Drive|Label|Type|Total Space (mb)|Free Space (mb)|Status           ",10,10,481,150)
		  	for $i = 1 to $var[0]
			$var[$i] = GUICtrlCreateListViewItem($var[$i] & "|" & DriveGetLabel($var[$i]) & "|" & DriveGetType($var[$i]) & "|" & Round(DriveSpaceTotal($var[$i]),2) & "|" & Round(DriveSpaceFree($var[$i]),2) & "|" & DriveStatus($var[$i]),$list)
			Next
		Endif
		If $msg = $emp then
			$mtq = MsgBox(33,"Empty Recycle Bins","Do you whant to empty all recycle bins?")
			If $mtq = 1 then FileRecycleEmpty()
			if @error = 1 then MsgBox(48,"Error","The recycle bins couldn't be emptied!",1)
		Endif
Until $msg = $GUI_EVENT_CLOSE