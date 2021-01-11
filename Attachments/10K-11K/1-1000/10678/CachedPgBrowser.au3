#include <GUIConstants.au3>
#include <GuiCombo.au3>
#include <array.au3>
#include <misc.au3>
Dim $selpg, $tmp, $loc, $pgindex[1], $aa, $tmpb
Opt("GUIOnEventMode", 1)
Opt("GUICoordMode", 2)
$F1 = GUICreate("WebPgCacheBrowser", @DesktopWidth-2, @DesktopHeight-34, -2, 0,BitOR($WS_OVERLAPPED, $WS_CAPTION, $WS_SYSMENU, $WS_THICKFRAME, $WS_MINIMIZEBOX ))
$b01 = GUICtrlCreateButton('SavedCache Folder', @DesktopWidth-510, 5, 120, 25)
If Not FileExists(@ScriptDir & '\SavedCache\') Then GUICtrlSetState($b01, $GUI_DISABLE)
$cb1 = GUICtrlCreateCombo("", 5, -22, 100, 40)
		If FileExists('C:\Program Files\Mozilla Firefox\Firefox.exe') Then _GUICtrlComboAddString($cb1,'Firefox')
		If FileExists('C:\Program Files\Internet Explorer\iexplore.exe') Then _GUICtrlComboAddString($cb1,'IE')
		If FileExists('C:\Program Files\Netscape\Netscape Browser\netscape.exe') Then _GUICtrlComboAddString($cb1,'Netscape')
		If FileExists('C:\Program Files\Opera\Opera.exe') Then _GUICtrlComboAddString($cb1,'Opera')
$cb2 = GUICtrlCreateCombo("", 10, -40, 200, 40)
$b02 = GUICtrlCreateButton('Copy', 5, -43, 50, 25)
$oIE = ObjCreate("Shell.Explorer.2")
$GUIActiveX = GUICtrlCreateObj($oIE, -@DesktopWidth+19, 5, @DesktopWidth, @DesktopHeight-92 )
$lb1 = GUICtrlCreateInput("", -@DesktopWidth+2, 2, @DesktopWidth-2, 22 )
GUICtrlSetBkColor($lb1,0xCCFFF5)
GUICtrlSetState ( $cb2, $GUI_FOCUS )
GUICtrlSetOnEvent ( $b01,'scfolder')
GUICtrlSetOnEvent ( $b02,'makecopy')
GUICtrlSetOnEvent ( $cb1,'bwsrtype')
GUISetOnEvent($GUI_EVENT_CLOSE, "CornerX")
GUISetState()
While 1
	$cc = GUIGetCursorInfo ( )
	If $cc[0] > @DesktopWidth-280 And $cc[1] < 26 And WinGetState ("WebPgCacheBrowser") = 15 Then GUICtrlSetState ( $cb2, $GUI_FOCUS )
	$selpg = _GUICtrlComboGetCurSel($cb2)
	If $selpg > -1 And $selpg <> $tmp Then
		GUICtrlSetData($lb1, 'Now ' & $selpg+1 & '/' & _GUICtrlComboGetCount($cb2) &' ===> ' &$loc & $pgindex[_GUICtrlComboGetCurSel($cb2)+1] & GUICtrlRead($cb2))
		$oIE.navigate($loc & $pgindex[_GUICtrlComboGetCurSel($cb2)+1] & GUICtrlRead($cb2))
	EndIf
	$tmp = $selpg 
	$c = DirGetSize(@ScriptDir & '\SavedCache\' & GUICtrlRead($cb1), 3 )
	If @error <> 1 Then 
		If $c[0] > 0 Then 
			GUICtrlSetState($b01, $GUI_ENABLE)
		Else
			GUICtrlSetState($b01, $GUI_DISABLE)
		EndIf
	EndIf
	Sleep(400)
WEnd
Func CornerX()
  Exit
EndFunc
Func makecopy()
	If GUICtrlRead($cb2) = '' Then Return
	If Not FileExists ( @ScriptDir & '\SavedCache\' & GUICtrlRead($cb1) ) Then DirCreate ( @ScriptDir & '\SavedCache\' & GUICtrlRead($cb1) )
	GUICtrlSetData($lb1,'File ' & GUICtrlRead($cb2) & ' has been copied to the SavedCache folder.')
	FileCopy($loc & $pgindex[_GUICtrlComboGetCurSel($cb2)+1] & GUICtrlRead($cb2),@ScriptDir & '\SavedCache\' & GUICtrlRead($cb1) & '\' & GUICtrlRead($cb2) & _Iif(GUICtrlRead($cb1)='Opera','','.htm'))
	GUICtrlSetState($b01, $GUI_ENABLE)
EndFunc
Func scfolder()
	If Not FileExists(@ScriptDir & '\SavedCache\' & GUICtrlRead($cb1)) Then 
		Return
	Else	
		Run(@ComSpec & " /c " & 'start ' & FileGetShortName(@ScriptDir & '\SavedCache\' & GUICtrlRead($cb1)), "", @SW_HIDE)
	EndIf	
EndFunc
Func bwsrtype()
	If GUICtrlRead($cb1) = $tmpb Then 
		Return
	Else
		_GUICtrlComboResetContent($cb2)
		$pgindex = 0
		Dim $pgindex[1]
		buildpg()
	EndIf	
	$tmpb = GUICtrlRead($cb1)
EndFunc
Func buildpg()
	Dim $cc1[1]
	If @OSVersion = 'Win_98' Then 
		If GUICtrlRead($cb1) = 'Firefox' Then $loc = 'C:\WINDOWS\Application Data\Mozilla\Firefox\Profiles\'
		If GUICtrlRead($cb1) = 'IE' Then $loc = 'C:\WINDOWS\Temporary Internet Files\Content.IE5\'
		If GUICtrlRead($cb1) = 'Netscape' Then $loc = 'C:\WINDOWS\Application Data\Netscape\NSB\Profiles\'
		If GUICtrlRead($cb1) = 'Opera' Then $loc = 'C:\WINDOWS\Application Data\Opera\OPERA\profile\'
	ElseIf @OSVersion = 'Win_XP' Then 
		If GUICtrlRead($cb1) = 'Firefox' Then $loc = "C:\Documents and Settings\" & @UserName & "\Local Settings\Application Data\Mozilla\Firefox\Profiles\"
		If GUICtrlRead($cb1) = 'IE' Then $loc = 'C:\Documents and Settings\' & @UserName & '\Local Settings\Temporary Internet Files\Content.ie5\'
		If GUICtrlRead($cb1) = 'Netscape' Then $loc = "C:\Documents and Settings\" & @UserName & "\Application Data\netscape\NSB\Profiles\"
		If GUICtrlRead($cb1) = 'Opera' Then $loc = "C:\Documents and Settings\" & @UserName & "\Application Data\Opera\Opera\profile\"
	EndIf	
	Select
		Case GUICtrlRead($cb1) = 'Firefox' Or GUICtrlRead($cb1) = 'Netscape'
			$search = FileFindFirstFile($loc & "*")  
			If $search = -1 Then Exit
			$aa = 0
			While 1
				$aa += 1
				$file = FileFindNextFile($search) 
				If @error Then ExitLoop
				If @OSVersion = 'Win_98' Then 
					If GUICtrlRead($cb1) = 'Firefox' Then $loc = 'C:\WINDOWS\Application Data\Mozilla\Firefox\Profiles\' & $file &'\'
					If GUICtrlRead($cb1) = 'Netscape' Then $loc = 'C:\WINDOWS\Application Data\Netscape\NSB\Profiles\' & $file &'\'
				ElseIf @OSVersion = 'Win_XP' Then 
					If GUICtrlRead($cb1) = 'Firefox' Then $loc = "C:\Documents and Settings\" & @UserName & "\Local Settings\Application Data\Mozilla\Firefox\Profiles\" & $file & '\'
					If GUICtrlRead($cb1) = 'Netscape' Then $loc = "C:\Documents and Settings\" & @UserName & "\Application Data\netscape\NSB\Profiles\" & $file &'\'
				EndIf	
			WEnd
			FileClose($search)			
		Case GUICtrlRead($cb1) = 'IE'	
			$search = FileFindFirstFile($loc & "*")  
			If $search = -1 Then Exit
			$aa = 0
			While 1
				$file = FileFindNextFile($search) 
				If @error Then ExitLoop
				If FileGetSize($loc & $file) = 0 Then
				$aa += 1	
				_ArrayAdd($cc1,$file & '\')
				EndIf
			WEnd
	EndSelect
		If GUICtrlRead($cb1) = 'Firefox' Or GUICtrlRead($cb1) = 'Netscape' Then popcb2('Cache\')
		If GUICtrlRead($cb1) = 'IE' Then 
			$cc1[0] = $aa
			For $b = 1 To $cc1[0]
				popcb2($cc1[$b])
			Next	
		EndIf
		If GUICtrlRead($cb1) = 'Opera' Then popcb2('Cache4\')
EndFunc
Func popcb2($b)
	GUICtrlSetState($b01, $GUI_DISABLE)
	$loc = $loc & $b
	$search = FileFindFirstFile($loc  & "*.*") 
	If $search = -1 Then Return
	While 1
		$aa += 1
		$file = FileFindNextFile($search) 
		If @error Then ExitLoop
		$a = 0
		While 1
			$a += 1
			$lin = FileReadLine($loc & $file,$a)
			If @error = -1 Then ExitLoop
			If $a > 5 Then ExitLoop
			If StringInStr($lin,'<html>') Then 
				_ArrayAdd($pgindex, $b)
				_GUICtrlComboAddString($cb2,$file)
				ExitLoop
			EndIf
		WEnd
		GUICtrlSetData($lb1, _GUICtrlComboGetCount($cb2) & ' Out Of ' & $aa & ' Files in cache folder are html based.')
	WEnd
	FileClose($search)	
	$loc = StringReplace($loc, $b, '')
EndFunc