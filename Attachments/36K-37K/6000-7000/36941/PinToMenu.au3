#include-once
#include <WinAPI.au3>
#include <Constants.au3>

Func _PinToMenu($File, $Bar = 'Task', $Pin = True)
    If @OSBuild < 7600 Then Return SetError(1) ; Windows 7 only
    If Not FileExists($File) Then Return SetError(2)
    Local $sFolder = StringRegExpReplace($File, "(^.*\\)(.*)", "$1")
    Local $sFile = StringRegExpReplace($File, "^.*\\", '')
    $ObjShell = ObjCreate("Shell.Application")
    $objFolder = $ObjShell.Namespace($sFolder)
    $objFolderItem = $objFolder.ParseName($sFile)
    For $Val In $objFolderItem.Verbs()
        Select
            Case StringInStr($Bar, 'Task')
                If StringInStr($val(), "Tas&kBar") Then
                    $Val.DoIt()
                    Return
                EndIf
            Case StringInStr($Bar, 'Start')
                If StringInStr($val(), "Start Men&u") Then
                    $Val.DoIt()
                    Return
                EndIf
        EndSelect
    Next
EndFunc   ;==>_PinToMenu