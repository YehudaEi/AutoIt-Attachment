#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Include <File.au3>
#Include <Array.au3>

$Source = ""
$SwapWith = ""
Global $dir = @DesktopDir
$GUI = GUICreate ("PathSwap",300,200)
$StringInput= GUICtrlCreateInput ($Source,10,20,200,20)
$SeplaceInput= GUICtrlCreateInput ($SwapWith ,10,40,200,20)
$Go= GUICtrlCreateButton ("Go !",10,60,200,20)
GUISetState (@SW_SHOW)
While 1
	$msg = GUIGetMsg()
		If $msg = $GUI_EVENT_CLOSE Then
			Exit
		EndIf
		If $msg = $Go Then
			_searchName($dir)
		EndIf
WEnd
Func _searchName($dir)
    Local $ArrTargetItems, $TargetItem
    If (StringRight($dir, 1) = "\") Then $dir = StringTrimRight($dir, 1)
		$ArrTargetItems = _FileListToArray($dir, "*", 0)
		If IsArray($ArrTargetItems) Then
			For $n = 1 To $ArrTargetItems[0]
				$TargetItem = $dir & '\' & $ArrTargetItems[$n]
				If StringInStr(FileGetAttrib($TargetItem), "D") Then ;This is a folder
					_searchName($TargetItem) ;Call recursively
				Else ;This is a file
					If StringRight ($TargetItem,4) = ".ini" Then
						$String = GUICtrlRead ($StringInput)
						$ReadImagePath = IniRead ($TargetItem,"Project","ImagePath","")
						$StringPos = StringInStr ($ReadImagePath,$String)
						If $StringPos >0 Then
							$RemoveUnwanted = StringTrimLeft ($ReadImagePath,$StringPos)
							MsgBox(0,'',$StringPos)
						EndIf
					EndIf
				EndIf
			Next
		EndIf
EndFunc