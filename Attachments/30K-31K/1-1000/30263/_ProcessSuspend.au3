#Include <WindowsConstants.au3>
#Include <GuiConstantsEx.au3>
#include <GuiListBox.au3>

HotKeySet("{F1}","Suspend")
HotKeySet("{F2}","Resume")
Local $msg
Local $MainGui = GuiCreate("Process Works",350,500,-1,-1,$WS_THICKFRAME)
Local $Input = GuiCtrlCreateInput("",5,5,150,21)
Local $plist = GuiCtrlCreateList("",5,35,250,435)

Local $proclist = ProcessList()
Local $i=0

for $i = 1 to $proclist[0][0]
	GuiCtrlSetData($plist,$proclist[$i][0] & " : " & $proclist[$i][1])
Next

GuiSetState(@SW_SHOW,$MainGui)


while 1
	$msg = GuiGetMsg()
	Switch $msg
		Case $GUI_EVENT_CLOSE
			Exit 0
		Case $plist
			local $Item = _GUICtrlListBox_GetText($plist, _GUICtrlListBox_GetCurSel($plist))
			local $sp = StringSplit($Item, " : ")
			$Item = $sp[1]
			GuiCtrlSetData($Input, $Item)
	EndSwitch
wend

Func _ProcessSuspend($process)
$processid = ProcessExists($process)
If $processid Then
    $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $processid)
    $i_sucess = DllCall("ntdll.dll","int","NtSuspendProcess","int",$ai_Handle[0])
    DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $ai_Handle)
    If IsArray($i_sucess) Then
        Return 1
    Else
        SetError(1)
        Return 0
    Endif
Else
    SetError(2)
    Return 0
Endif
EndFunc

Func _ProcessResume($process)
$processid = ProcessExists($process)
If $processid Then
    $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $processid)
    $i_sucess = DllCall("ntdll.dll","int","NtResumeProcess","int",$ai_Handle[0])
    DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $ai_Handle)
    If IsArray($i_sucess) Then
        Return 1
    Else
        SetError(1)
        Return 0
    Endif
Else
    SetError(2)
    Return 0
Endif
EndFunc

Func Suspend()
	$Proc = GuiCtrlRead($Input)
	_ProcessSuspend($Proc)
EndFunc

Func Resume()
	$Proc = GuiCtrlRead($Input)
	_ProcessResume($Proc)
EndFunc
