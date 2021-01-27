#Include-once "Constants.au3"
#Include-once "memstats.au3"
#Include-once "String.au3"
#Include-once "config.au3"
#Include-once "ButtonConstants.au3"
#Include-once "EditConstants.au3"
#Include-once "GUIConstantsEx.au3"
#Include-once "WindowsConstants.au3"
#Include-once "CompInfo.au3"
#Include-once "Array.au3"
#Include-once "GUIListBox.au3"
#Include-once "functionsSystemInfo.au3"
#Include-once "TabConstants.au3"
;----------------------------Computer Info----------------------------------------------
#Region ### START Koda GUI section ### Form=
	GUICreate("System Information", 900, 600, 1218, 887)
	;Create System Tabs
	GUICtrlCreateTab(16, 16,850,417)
	Dim $tabItem, $tabArray[7] = ["Hard Drive", "Bios", "Services", "Running Processes", "Display", "System", "Print"]
	For $i = 1 To $tabArray[0] Step 1
		$tabItem[$i] = GUICtrlCreateTabItem($tabArray[$i])
	Next
Func GetDriveInfo()
	;Drive Info
	;Testing ListBox for Drive
	$ListView = GUICtrlCreateListView("Drive# | Label | Drive | FileSystem | Serial Number | " & _
	"Free Space | Total Space ", 10, 75, 850, 500)
	Dim $Drives
	_ComputerGetDrives($Drives) ;Defaults to "FIXED"
	For $i = 1 To $Drives[0][0] Step 1
		$sData = $i & "|"
		$sData &= $Drives[$i][2] & "|" & $Drives[$i][0] & "|" & $Drives[$i][1] & "|" & $Drives[$i][3] & "|" 
		$sData &= Round($Drives[$i][4]/1024,2) & "GB" & "|" & Round($Drives[$i][5]/1024,2) & "GB"
		GUICtrlCreateListViewItem($sData, $ListView)
	Next
	
EndFunc
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###