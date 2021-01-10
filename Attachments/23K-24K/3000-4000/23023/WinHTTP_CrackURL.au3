Global Const $tagURL_COMPONENTS = _
  "DWORD dwStructSize;" & _ ; 
  "ptr lpszScheme;" & _ ; LPWSTR 
  "DWORD dwSchemeLength;" & _ ; 
  "int nScheme;" & _ ; 
  "ptr lpszHostName;" & _ ; LPWSTR 
  "DWORD dwHostNameLength;" & _ ; 
  "dword nPort;" & _ ; 
  "ptr lpszUserName;" & _ ; LPWSTR 
  "DWORD dwUserNameLength;" & _ ; 
  "ptr lpszPassword;" & _ ; LPWSTR 
  "DWORD dwPasswordLength;" & _ ; 
  "ptr lpszUrlPath;" & _ ; LPWSTR 
  "DWORD dwUrlPathLength;" & _ ; 
  "ptr lpszExtraInfo;" & _ ; LPWSTR 
  "DWORD dwExtraInfoLength;"

Func _WinHttpCrackUrl($URL,$dwFlags=0)
	Local $URL_COMPONENTS = DllStructCreate($tagURL_COMPONENTS)
	DllStructSetData($URL_COMPONENTS,1,DllStructGetSize($URL_COMPONENTS))
	Local $Buffers[6]
	Local $URLLen = StringLen($URL)
	For $i = 0 To 5
		$Buffers[$i] = DllStructCreate("wchar[" & ($URLLen+1) & "]")
	Next
	DllStructSetData($URL_COMPONENTS,"dwSchemeLength",$URLLen)
	DllStructSetData($URL_COMPONENTS,"lpszScheme",DllStructGetPtr($Buffers[0]))
	DllStructSetData($URL_COMPONENTS,"dwHostNameLength",$URLLen)
	DllStructSetData($URL_COMPONENTS,"lpszHostName",DllStructGetPtr($Buffers[1]))
	DllStructSetData($URL_COMPONENTS,"dwUserNameLength",$URLLen)
	DllStructSetData($URL_COMPONENTS,"lpszUserName",DllStructGetPtr($Buffers[2]))
	DllStructSetData($URL_COMPONENTS,"dwPasswordLength",$URLLen)
	DllStructSetData($URL_COMPONENTS,"lpszPassword",DllStructGetPtr($Buffers[3]))
	DllStructSetData($URL_COMPONENTS,"dwUrlPathLength",$URLLen)
	DllStructSetData($URL_COMPONENTS,"lpszUrlPath",DllStructGetPtr($Buffers[4]))
	DllStructSetData($URL_COMPONENTS,"dwExtraInfoLength",$URLLen)
	DllStructSetData($URL_COMPONENTS,"lpszExtraInfo",DllStructGetPtr($Buffers[5]))
	Local $ret = DllCall("Winhttp.dll","int","WinHttpCrackUrl","wstr",$URL,"dword",$URLLen,"dword",$dwFlags,"ptr",DllStructGetPtr($URL_COMPONENTS))
	If @error Then Return SetError(1)
	If $ret[0] = 0 Then Return SetError(2,0,0)
	Local $ret[8]
	$ret[0] = StringStripWS(DllStructGetData($Buffers[0],1),3)
	$ret[1] = DllStructGetData($URL_COMPONENTS,"nScheme")
	$ret[2] = StringStripWS(DllStructGetData($Buffers[1],1),3)
	$ret[3] = DllStructGetData($URL_COMPONENTS,"nPort")
	$ret[4] = StringStripWS(DllStructGetData($Buffers[2],1),3)
	$ret[5] = StringStripWS(DllStructGetData($Buffers[3],1),3)
	$ret[6] = StringStripWS(DllStructGetData($Buffers[4],1),3)
	$ret[7] = StringStripWS(DllStructGetData($Buffers[5],1),3)
	Return $ret
EndFunc

Func _WinHttpCreateUrl($URLArray,$dwFlags=0)
	If UBound($URLArray) <> 8 Then Return SetError(1,0,"")
	Local $URL_COMPONENTS = DllStructCreate($tagURL_COMPONENTS)
	DllStructSetData($URL_COMPONENTS,1,DllStructGetSize($URL_COMPONENTS))
	Local $Buffers[6][2]

		$Buffers[0][1] = StringLen($URLArray[0])
		If $Buffers[0][1] Then 
			$Buffers[0][0] = DllStructCreate("wchar[" & ($Buffers[0][1]+1) & "]")
			DllStructSetData($Buffers[0][0],1,$URLArray[0])
		EndIf
		$Buffers[1][1] = StringLen($URLArray[2])
		If $Buffers[1][1] Then 
			$Buffers[1][0] = DllStructCreate("wchar[" & ($Buffers[1][1]+1) & "]")
			DllStructSetData($Buffers[1][0],1,$URLArray[2])
		EndIf
		$Buffers[2][1] = StringLen($URLArray[4])
		If $Buffers[2][1] Then 
			$Buffers[2][0] = DllStructCreate("wchar[" & ($Buffers[2][1]+1) & "]")
			DllStructSetData($Buffers[2][0],1,$URLArray[4])
		EndIf
		$Buffers[3][1] = StringLen($URLArray[5])
		If $Buffers[3][1] Then 
			$Buffers[3][0] = DllStructCreate("wchar[" & ($Buffers[3][1]+1) & "]")
			DllStructSetData($Buffers[3][0],1,$URLArray[5])
		EndIf
		$Buffers[4][1] = StringLen($URLArray[6])
		If $Buffers[4][1] Then 
			$Buffers[4][0] = DllStructCreate("wchar[" & ($Buffers[4][1]+1) & "]")
			DllStructSetData($Buffers[4][0],1,$URLArray[6])
		EndIf
		$Buffers[5][1] = StringLen($URLArray[7])
		If $Buffers[5][1] Then 
			$Buffers[5][0] = DllStructCreate("wchar[" & ($Buffers[5][1]+1) & "]")
			DllStructSetData($Buffers[5][0],1,$URLArray[7])
		EndIf

	DllStructSetData($URL_COMPONENTS,"dwSchemeLength",$Buffers[0][1])
	DllStructSetData($URL_COMPONENTS,"lpszScheme",DllStructGetPtr($Buffers[0][0]))
	DllStructSetData($URL_COMPONENTS,"dwHostNameLength",$Buffers[1][1])
	DllStructSetData($URL_COMPONENTS,"lpszHostName",DllStructGetPtr($Buffers[1][0]))
	DllStructSetData($URL_COMPONENTS,"dwUserNameLength",$Buffers[2][1])
	DllStructSetData($URL_COMPONENTS,"lpszUserName",DllStructGetPtr($Buffers[2][0]))
	DllStructSetData($URL_COMPONENTS,"dwPasswordLength",$Buffers[3][1])
	DllStructSetData($URL_COMPONENTS,"lpszPassword",DllStructGetPtr($Buffers[3][0]))
	DllStructSetData($URL_COMPONENTS,"dwUrlPathLength",$Buffers[4][1])
	DllStructSetData($URL_COMPONENTS,"lpszUrlPath",DllStructGetPtr($Buffers[4][0]))
	DllStructSetData($URL_COMPONENTS,"dwExtraInfoLength",$Buffers[5][1])
	DllStructSetData($URL_COMPONENTS,"lpszExtraInfo",DllStructGetPtr($Buffers[5][0]))
	
	DllStructSetData($URL_COMPONENTS,"nScheme",$URLArray[1])
	DllStructSetData($URL_COMPONENTS,"nPort",$URLArray[2])
	Local $ret = DllCall("Winhttp.dll","int","WinHttpCreateUrl","ptr",DllStructGetPtr($URL_COMPONENTS),"dword",$dwFlags,"ptr",0,"dword*",0)
	If @error Then Return SetError(1,0,"")
	Local $URLLen = $ret[4]
	Local $URLBuffer = DllStructCreate("wchar[" & ($URLLen+1) & "]")
	Local $ret = DllCall("Winhttp.dll","int","WinHttpCreateUrl","ptr",DllStructGetPtr($URL_COMPONENTS),"dword",$dwFlags,"ptr",DllStructGetPtr($URLBuffer),"dword*",$URLLen)
	If @error Then Return SetError(1,0,"")
	If $ret[0] = 0 Then Return SetError(2,0,"")
	Return DllStructGetData($URLBuffer,1)
EndFunc

#include <Array.au3>
$return = _WinHttpCrackUrl("http://user:pass@www.autoitscript.com/forum/index.php?showtopic=83971")
_ArrayDisplay($return)
$URL = _WinHttpCreateUrl($return)
MsgBox(0, '', $URL)