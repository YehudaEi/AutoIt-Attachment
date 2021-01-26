#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=UT2004_128.ico
#AutoIt3Wrapper_Res_Fileversion=1.0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

FileInstall ('RPGLOGO.jpg', @TempDir & '/RPGLOGO.jpg')
FileInstall ('selectfile.mp3', @TempDir & '/selectfile.mp3')
FileInstall ('thanks.mp3', @TempDir & '/thanks.mp3')
FileInstall ('playereremoved.mp3', @TempDir & '/playereremoved.mp3')
FileInstall ('botsremoved.mp3', @TempDir & '/botsremoved.mp3')
FileInstall ('packednready.mp3', @TempDir & '/packednready.mp3')
FileInstall ('c ya.mp3', @TempDir & '/c ya.mp3')
FileInstall ('error.mp3', @TempDir & '/error.mp3')

$Form1 = GUICreate("Clean RPG", 376, 220, -1, -1)
$Log = GUICtrlCreateEdit("", 130, 100, 246, 100)
GUICtrlCreatePic (@TempDir & '/RPGLOGO.jpg',0,0,376,100)
GUICtrlCreateLabel("Levels range", 30, 105, 85, 20)
GUICtrlCreateLabel("Made by: SaverFixer", 270,205)
$Min = GUICtrlCreateInput("0", 5, 120, 40, 20)
$Max = GUICtrlCreateInput("100", 45, 120, 80, 20)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SoundPlay (@TempDir & '/selectfile.mp3')
$filename = FileOpenDialog('', @HomeDrive & "\UT2004", "RPG file (UT2004RPG.ini)", 1 + 2)
	If $filename = '' Then
		SoundPlay (@TempDir & '/error.mp3',1)
		MsgBox (0,'ERROR','UT2004RPG.ini not located' & @lf & 'Please locate file first')
		exit
	ElseIf $filename > '' Then
		SoundPlay (@TempDir & '/thanks.mp3')
	EndIf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
$Section = IniReadSectionNames ($filename)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
$BTNremplayers = GUICtrlCreateButton("Remove Player's", 0, 140, 130, 20, 0)
GUICtrlSetTip(-1, "Remove Players within specified range")
$BTNrembots = GUICtrlCreateButton("Remove Bot's", 0, 160, 130, 20, 0)
GUICtrlSetTip(-1, "Remove all bot stats fro RPG")
$BTNcompact = GUICtrlCreateButton("Compact RPG lines", 0, 180, 130, 20, 0)
GUICtrlSetTip(-1, "Remove RPG empty lines left behind making it even smaller")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GUISetState(@SW_SHOW)

While 1
$nMsg = GUIGetMsg()
Switch $nMsg
	case $filename
file($filename)
	case $BTNremplayers
removeplayers($BTNremplayers)
	case $BTNrembots
removebots($BTNrembots)
	case $BTNcompact
Compact($BTNcompact)
		
	Case $GUI_EVENT_CLOSE
		SoundPlay (@TempDir & '/c ya.mp3',1)
Exit

EndSwitch
WEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
func file($filename)
EndFunc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
func removeplayers($BTNremplayers)
	$MinValue = GUICtrlRead ($Min)
	$MaxValue = GUICtrlRead ($Max)
	for $X = 1 to $Section[0]
		$level = IniRead ($filename,$Section[$X]& 'RPGPlayerDataObject','Level','Return Error. Nothing found in specified range')
		If $level >= Number ($MinValue) and $level <= Number ($MaxValue) Then
			$removed = IniDelete ($filename,$Section[$X])
Endif
		GUICtrlSetData ($log, @CRLF &'Searching')
	Next
	GUICtrlSetData ($log, @CRLF &'Done ','List')
	SoundPlay (@TempDir & '/playereremoved.mp3')
EndFunc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
func removebots($BTNrembots)
	For $B = 1 To $Section[0]
		$Bot = IniRead ($filename,$Section[$B],'OwnerID','')
		If ($Bot = "Bot") Then
		IniDelete ($filename,$Section[$B])
		GUICtrlSetData ($log, @CRLF &'Found '& $Section[$B]& @CRLF,'list')
	EndIf
Next
GUICtrlSetData ($log,@CRLF &"All Bot's removed",'List')
SoundPlay (@TempDir & '/botsremoved.mp3')
EndFunc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
func Compact($BTNcompact)
	Local $sFileContent = StringRegExpReplace(FileRead($filename), "(\r\n){1,}", "\1")
    Local $FileOpen = FileOpen($filename, 2)
		FileWrite($FileOpen, StringStripWS($sFileContent, 3))
		FileClose($FileOpen)
	GUICtrlSetData ($log, @CRLF &'Empty RPG lines removed'& @CRLF,'List')
	SoundPlay (@TempDir & '/packednready.mp3')
EndFunc


