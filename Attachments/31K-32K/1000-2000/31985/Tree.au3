#include<GuiTreeView.au3>
	Global $count,$top,$node[500],$hWnd,$hFile,$temp
	$count = $temp = 0
	$top = -1
	Local $wndTxt
	
	$wndTxt = InputBox("window name","type the window name to get handle")
	WinWaitActive($wndTxt)
	$hWnd = WinGetHandle($wndTxt)

	ControlTreeView($hWnd,"","SysTreeView321","Expand","#0|#3")

	push("<Computer>")
	push("HKEY_USERS")

	$hFile = FileOpen("e:\\progamming\\tree.xml",2)
	generateXML("#0|#3")
	
	MsgBox(0,"total",$count)
	FileClose($hFile)
Exit

Func generateXML($text)
	Local $i,$str,$n
	
	$i = 0	
	$n = ControlTreeView($hWnd,"","SysTreeView321","GetItemCount",$text)
	
	While $i <> $n
		ControlTreeView($hWnd,"","SysTreeView321","Expand",$text & "|#" & $i)
		$str = ControlTreeView($hWnd,"","SysTreeView321","GetText",$text & "|#" & $i)
		
		If ControlTreeView($hWnd,"","SysTreeView321","GetText",$text & "|#" & $i & "|#0") <> "" Then
			FileWriteLine($hFile,"<" & $str & ">")
			push("<\ " & $str &">")
			$count = $count + 1
			generateXML($text & "|#"& $i)
			Else
				FileWriteLine($hFile,$str)
		EndIf
		$i = $i + 1
	WEnd
		FileWriteLine($hFile,pop())
		ControlTreeView($hWnd,"","SysTreeView321","Collapse",$text)
EndFunc

Func push($parent)
	$top = $top + 1
	$node[$top] = $parent
EndFunc

Func pop()
	If $top == -1 Then
		return -1
	EndIf
	$top = $top -1
	return $node[$top + 1]
EndFunc