#region - Options
#Include <Constants.au3>
#include <GUIConstants.au3>
#include <XSkin.au3>
#include <XSkinShell.au3>
Opt("TrayMenuMode",    0) 
Opt("TrayIconHide",    1)
Opt("TrayAutoPause",   0) 
Opt("TrayOnEventMode", 0) 
#endregion

#Region - GUI
$Skin_Folder = @ScriptDir & "\Skins\DeFacto"
$XSkinGui = XSkinGUICreate ( "MiniStuffer", 882,488, $Skin_Folder, $WS_SIZEBOX + $WS_SYSMENU + $WS_CAPTION + $WS_MINIMIZEBOX, $WS_EX_ACCEPTFILES)

$Icon_Folder = @ScriptDir & "\Skins\Default"
$XIcon = XSkinIcon ($XSkinGui, 2)
;------------------------------------------------------------------------------

$Date 		= GUICtrlCreateMonthCal ("",  36,  45, 200, 165)
$editor		= GUICtrlCreateEdit		("", 246,  45, 600, 390)
$Groupcal	= GUICtrlCreateGroup	("",  32,  35, 208, 178)
$groupedit	= GUICtrlCreateGroup	("", 241,  35, 610, 410) 
$groupcon	= GUICtrlCreateGroup	("",  32, 215, 208, 230) 
$grouptext	= GUICtrlCreateLabel	("Click here with mouse button 2.",  37, 245, 198, 18) 

GUISetState()
#endregion

#region - Context menu
$contextmenu	= GUICtrlCreateContextMenu	()
$contextopen	= GUICtrlCreateMenuitem ("Open file...", $contextmenu)
$contextsave	= GUICtrlCreateMenuitem ("Save file...", $contextmenu)
$contextempty	= GUICtrlCreateMenuitem ("Clear area...", $contextmenu)
$contextnull	= GUICtrlCreateMenuitem ("", $contextmenu)
$contextexit	= GUICtrlCreateMenuitem ("Exit", $contextmenu)
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
		$fileopen = FileOpenDialog("Open file", @DesktopDir, "Text files (*.txt)|Settings (*.ini;*.inf;*.cfg;*.set;*.conf;*.config)|All files (*.*)", 11)
			if Not @error Then
				$fileread = FileRead($fileopen)
				GUICtrlSetData($editor, $fileread)
			EndIf
			
	Case $msggui = $contextsave
		$Filesave = FileSaveDialog("Save file", @DesktopDir, "Text files (*.txt)|Settings (*.ini;*.inf;*.cfg;*.set;*.conf;*.config)|All files (*.*)", 11)
			if Not @error Then
				if FileExists($Filesave) Then
					$Filesaveask = MsgBox(36,"Save file", "Are you sure about writing over existing file?")
						if $Filesaveask = 6 Then
							FileDelete($Filesave)
							if not @error Then FileWrite($Filesave, GUICtrlRead($editor))
						EndIf
				Else
					FileWrite($Filesave, GUICtrlRead($editor))
				EndIf
			EndIf
			
	Case $msggui = $contextempty
		GUICtrlSetData($editor, "")

	Case $msggui = $contextexit
		Exit
			
	
		
EndSelect
WEnd
Exit