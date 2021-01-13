#region - include
#Include <Constants.au3>
#include <GUIConstants.au3>
#include <XSkin.au3>
#include <XSkinShell.au3>
#endregion

#Region - GUI
$Skin_Folder = @ScriptDir & "\Skins\Skilled"
$XSkinGui = XSkinGUICreate ( "Notepad", 650,490, $Skin_Folder)

$Icon_Folder = @ScriptDir & "\Skins\Default"
$XIcon = XSkinIcon ($XSkinGui, 2)

$group1		= GUICtrlCreateGroup(""			,  20,  30, 610, 420) 
$editor		= GUICtrlCreateEdit	(""			,  25 , 42, 600, 400)
$label		= GUICtrlCreateLabel("Click right mouse button for menu", 20, 455, 200, 17)
GUISetState()
#endregion

#region - Context menu
$contextmenu	= GUICtrlCreateContextMenu	()
$contextopen	= GUICtrlCreateMenuitem ("Open file...", $contextmenu)
$contextsave	= GUICtrlCreateMenuitem ("Save file...", $contextmenu)
#endregion

While 1
    MouseOver ()
    $msggui = GUIGetMsg()
	$msgtray = TrayGetMsg()
Select

	Case $msggui = $XIcon[1] ;When you click the Close button
	    GUIDelete($XSkinGui)
		Exit
		
	Case $msggui = $XIcon[2] ;When you click the Minimize button
		GUISetState(@SW_MINIMIZE)
	
	Case $msggui = $contextopen
		$fileopen = FileOpenDialog("Avaa tiedosto", @DesktopDir, "Tekstitiedostot (*.txt)|Asetukset (*.ini;*.inf;*.cfg;*.set;*.conf;*.config)", 11)
			if Not @error Then
				$fileread = FileRead($fileopen)
				GUICtrlSetData($editor, $fileread)
			EndIf
			
	Case $msggui = $contextsave
		$Filesave = FileSaveDialog("Tallenna tiedosto", @DesktopDir, "Tekstitiedostot (*.txt)|Asetukset (*.ini;*.inf;*.cfg;*.set;*.conf;*.config)", 11)
			if Not @error Then
				if FileExists($Filesave) Then
					$Filesaveask = MsgBox(36,"Save file", "Are you sure about writing over existing file?")
						if $Filesaveask = 6 Then
							FileDelete($Filesave)
;~ 							ClipPut($editor)
;~ 							MsgBox(0, "Clipboard contains:", ClipGet())
			 				FileWrite($Filesave, GUICtrlRead($editor))
						EndIf
				EndIf
			EndIf
EndSelect
WEnd
Exit