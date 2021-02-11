Func BASSMODOPEN($Dll="BassMod.dll", $XMFile="BassMod.xm")
	Global $aDll_Handle = BASSMOD_Open($Dll, $XMFile, 1024+4, 60)
EndFunc
Func BASSMOD_Open($DllPath, $sPath, $Flag = 0, $Amplify = 50)
	If Not FileExists($DllPath) Then Return SetError(1, 0, -1)
	
	Local $BassModDll = DllOpen($DllPath)
	If $BassModDll = -1 Then Return -1
	
	Local $BASSMOD_Init = DllCall($BassModDll, "int", "BASSMOD_Init", _
		"int", -1, _  ;�������� ���������� (-1 ���������� �� ���������)
		"long", 44100, _  ; ������� �������������
		"long", 0)       ; ��������� ������ ����������
	If Not $BASSMOD_Init[0] Then Return SetError(2, 0, -1)
	Local $FName = DllStructCreate("char[255]")
	DllStructSetData($FName, 1, $sPath)
	Local $iLoad = DllCall($BassModDll, "int", "BASSMOD_MusicLoad", "int", False, _  ; �������� ������ �� ������
		"ptr", DllStructGetPtr($FName), _ ; ��������� �� ��� �����
		"long", 0, _   ; �������� �� ������ �����
		"long", 0, _   ; ������ ������ (0 - ��� ������)
		"long", $Flag) ; ��������� ���������������
	$FName = 0
	If Not $iLoad[0] Then Return SetError(3, 0, -1)
	DllCall($BassModDll, "int", "BASSMOD_MusicSetAmplify", "long", $Amplify) ; Amplify level: (min = 0; max = 100; default 50)
	BASSMODPLAY($BassModDll)
	If @error Then Return SetError(4, 0, -1)
	Return $BassModDll
EndFunc

Func BASSMODPLAY($BassModDll)
	If $BassModDll = -1 Then Return 0
	Local $iPlay = DllCall($BassModDll, "int", "BASSMOD_MusicPlay")
	If Not $iPlay[0] Then Return SetError(1, 0, -1)
	Return $iPlay[0]
EndFunc

Func BASSMODPAUSE($BassModDll)
	If $BassModDll = -1 Then Return 0
	DllCall($BassModDll, "int", "BASSMOD_MusicPause")
EndFunc

Func BASSMODCLOSE($BassModDll="BASSMOD.dll")
	If $BassModDll = -1 Then Return 0
	DllCall($BassModDll, "int", "BASSMOD_Free") ;����������� ������� �������� ����������
EndFunc