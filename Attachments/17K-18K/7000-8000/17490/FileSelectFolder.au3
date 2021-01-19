#include <GUIConstants.au3>
#include <DllCallBack.au3>

;~ ���������, ����������� �������� ������
Global Const $BFFM_INITIALIZED = 1 ;~ ������������� ������� ���������
Global Const $BFFM_SELCHANGED = 2 ;~ ����� ������������� ������ ��������
Global Const $BFFM_VALIDATEFAILEDA = 3 ;~ ANSI: � ���� �������������� ������ ������������ �����
Global Const $BFFM_VALIDATEFAILEDW = 4 ;~ WideChar: � ���� �������������� ������ ������������ �����
Global Const $BFFM_IUNKNOWN = 5 ;~ ��� �������������: �������� ��������� �� ��������� IUnknown
;~ ���������, ����������� �������� ������
Global Const $BFFM_ENABLEOK = $WM_USER + 101 ;~ ��������/��������� ������ "Ok"
Global Const $BFFM_SETOKTEXT = $WM_USER + 105 ;~ ������ ����� ������ "Ok"
Global Const $BFFM_SETEXPANDED = $WM_USER + 106 ;~ �������� � ������ ������������ �����
Global Const $BFFM_SETSTATUSTEXTA = $WM_USER + 100 ;~ ANSI: ������ ����� ��������� ������
Global Const $BFFM_SETSTATUSTEXTW = $WM_USER + 104 ;~ WideChar: ������ ����� ��������� ������
Global Const $BFFM_SETSELECTIONA = $WM_USER + 102 ;~ ANSI: ����������� ������ � ������������� �������� � ������
Global Const $BFFM_SETSELECTIONW = $WM_USER + 103 ;~ WideChar: ����������� ������ � ������������� �������� � ������
;~ ����, ���������� "����� �����" �������
Global Const $BIF_NEWDIALOGSTYLE = 0x40 ;~ ������� ���������� ���� "������ �����" (IE 5.0)
;~ �����, ���������� ������ ��� ������� � "������ �����" (���� $BIF_NEWDIALOGSTYLE �������)
Global Const $BIF_RETURNONLYFSDIRS = 0x1 ;~ �������� ������ ������� �������� �������
Global Const $BIF_STATUSTEXT = 0x4 ;~ ����������� ��������������� ��������� ����
Global Const $BIF_BROWSEFORCOMPUTER = 0x1000 ;~ �������� ������ ���������� � ������� ���������
Global Const $BIF_BROWSEFORPRINTER = 0x2000 ;~ �������� ������ �������� � ������� ���������
;~ �����, ���������� ������ ��� ������� � "����� �����" (���� $BIF_NEWDIALOGSTYLE ����������)
Global Const $BIF_UAHINT = 0x100 ;~ ���������� ����� "���������", �������������� ��� ����� $BIF_EDITBOX (IE 6.0)
Global Const $BIF_NONEWFOLDERBUTTON = 0x200 ;~ �� ���������� ������ �������� ������ �������� (IE 6.0)
Global Const $BIF_SHAREABLE = 0x8000 ;~ ���������� ������������� ������� �������: �����, ��������, �������, etc. (IE 5.0)
;~ �����, ������������ � ����� ������ �������
Global Const $BIF_DONTGOBELOWDOMAIN = 0x2 ;~ �� ��������� ������ � ������� ���������
Global Const $BIF_BROWSEINCLUDEFILES = 0x4000 ;~ ��������� �������� ����� (IE 5.0)
Global Const $BIF_EDITBOX = 0x10 ;~ �������� ������ �������������� (IE 4.71)
Global Const $BIF_VALIDATE = 0x20 ;~ �������� ��������� � ������ ������������� ����� (IE 4.71)
;~ ����� ���������� ������ ��� ������� "������� �����"
Global Const $BIF_ALLOLDSTYLEFLAGS = BitOR ( _
	$BIF_DONTGOBELOWDOMAIN, $BIF_BROWSEINCLUDEFILES, $BIF_EDITBOX, $BIF_VALIDATE, _
	$BIF_BROWSEFORCOMPUTER, $BIF_BROWSEFORPRINTER, $BIF_RETURNONLYFSDIRS, $BIF_STATUSTEXT)
;~ ����� ���������� ������ ��� ������� "������ �����"
Global Const $BIF_ALLNEWSTYLEFLAGS = BitOR ( $BIF_NEWDIALOGSTYLE, _
	$BIF_DONTGOBELOWDOMAIN, $BIF_BROWSEINCLUDEFILES, $BIF_EDITBOX, $BIF_VALIDATE, _
	$BIF_NONEWFOLDERBUTTON, $BIF_UAHINT, $BIF_SHAREABLE)


;~ ������ ����������� ����������:
;~	$sText - ����� �����������;
;~	$iRoot - ��� ��������� �������� (0 - "������� ����");
;~	$iFlags - ����� ������;
;~	$sInitDir - ��������� �������;
;~	$hWnd - ����� ������������� ����;
;~	$sCallbackProc - ��� CallBack-���������
Func _FileSelectFolder($sText = '', $iRoot = 0, $iFlags = 0, $sInitDir = @ScriptDir, $hWnd = 0, $sCallbackProc = '_FileSFCallbackProc')
	Local $pidl, $res='', $pCallbackProc=0, $iMask = $BIF_ALLOLDSTYLEFLAGS, $Error = 0
	; �������� ������� ����������
	;$sInitDir = StringRegExpReplace($sInitDir, '([^\\])\\*$', '\1\\')
	;If StringRight($sInitDir, 1)=':' Then $sInitDir &= '\'
	If BitAND($iFlags, $BIF_NEWDIALOGSTYLE) Then $iMask = $BIF_ALLNEWSTYLEFLAGS
	; �������� � ������������� �������� �������� ������
	Local $uBI = DllStructCreate ("hwnd;ptr;ptr;ptr;int;ptr;ptr;int") ; BROWSEINFO
	Local $uTX = DllStructCreate ("char[260];char") ; ����� �����������
	Local $uMP = DllStructCreate ("char[260]") ; MAX_PATH
	Local $uCB = DllStructCreate ("char[260];int") ; CallBack ���������
	DllStructSetData ($uTX, 1, $sText)
	DllStructSetData ($uCB, 1, $sInitDir)
	DllStructSetData ($uCB, 2, $iFlags)
	; ���������� ��������� BROWSEINFO
	DllStructSetData ($uBI, 1, $hwnd)
	DllStructSetData ($uBI, 3, DllStructGetPtr($uMP))
	DllStructSetData ($uBI, 4, DllStructGetPtr($uTX))
	DllStructSetData ($uBI, 5, BitAND($iFlags, $iMask))
	DllStructSetData ($uBI, 7, DllStructGetPtr($uCB))
	; ��������� ��������� �� CallBack-�������
	If $sCallbackProc<>'' Then $pCallbackProc = _DllCallBack($sCallbackProc,'hwnd;uint;long;ptr')
	If @error Then Return SetError(2, @error, '') ; ������ ��������� ���������
	DllStructSetData ($uBI, 6, $pCallbackProc)
	; ��������� ��������� �� �������� ����� (PIDL)
	Local $ret = DllCall ("shell32.dll", "ptr", "SHGetSpecialFolderLocation", _
		"int", 0 , "int", $iRoot , "ptr", DllStructGetPtr($uBI, 2))
	If $ret[0]=0 Then
		; ������ ���������� �������
		$pidl = DllCall ("shell32.dll", "ptr", "SHBrowseForFolder", "ptr", DllStructGetPtr($uBI))
		$res = DllStructGetData ($uMP, 1) ; ��������� ��� �������
		If $pidl[0] Then
			; ��������� ����������� ��������� (PIDL)
			$ret = DllCall ("shell32.dll", "int", "SHGetPathFromIDList", "ptr", $pidl[0], "ptr", DllStructGetPtr($uMP))
			If $ret[0] Then $res = DllStructGetData ($uMP, 1)
			DllCall ("ole32.dll", "int", "CoTaskMemFree", "ptr", $pidl[0]) ; ������ �� �����
		Else
			$Error = 1
		EndIf
		DllCall ("ole32.dll", "int", "CoTaskMemFree", "ptr", DllStructGetData ($uBI, 2)) ; ������ �� �����
	Else
		SetError(1, 0, '') ; ������ � ��������� �������� �����
	EndIf
	If $pCallbackProc Then _DllCallBack_Free ($pCallbackProc) ; �������� ���������
	Return SetError($Error, 0, $res)
EndFunc ;==> _FileSelectFolder

; ������� ��������� ������ ��� _FileSelectFolder �� ���������
Func _FileSFCallbackProc($hWnd, $iMsg, $wParam, $lParam)
    Local $uTB = DllStructCreate("char[260];ptr"), $uCB = DllStructCreate ("char[260];int", $lParam)
    Local Const $flg = BitOr($BIF_NEWDIALOGSTYLE, $BIF_RETURNONLYFSDIRS)
    Local $sRet, $Tst = BitXOR(BitAnd(DllStructGetData($uCB,2), $flg), $flg)
    Switch $iMsg
        Case $BFFM_INITIALIZED
            DllCall("user32.dll","int","SendMessage", "hwnd", $hWnd, "int", $BFFM_SETSELECTIONA, "int", 1, _
				"ptr", DllStructGetPtr($uCB,1))
            $sRet = DllCall("shell32.dll", "int", "SHParseDisplayName", _
                "wstr", DllStructGetData($uCB,1), "ptr", 0, "ptr", DllStructGetPtr($uTB, 2), "int", 0, "ptr", 0)
            If IsArray($sRet) Then
                If $sRet[0] = 0 Then
					_FileSFCallbackProc($hWnd, $BFFM_SELCHANGED, DllStructGetData($uTB, 2), $lParam)
                    DllCall("ole32.dll", "int", "CoTaskMemFree", "ptr", DllStructGetData($uTB, 2)) ; Cleaning
                EndIf
            EndIf
        Case $BFFM_SELCHANGED
            If $Tst = 0 Then
				$sRet = DllCall("shell32.dll", "int", "SHGetPathFromIDList", "ptr", $wParam, "ptr", DllStructGetPtr($uTB,1))
                If IsArray($sRet) Then
                    If $sRet[0] Then
                        DllCall("user32.dll","int","SendMessage","hwnd",$hWnd,"int",$BFFM_ENABLEOK,"int",0,"ptr",1)
                    Else
                        DllCall("user32.dll","int","SendMessage","hwnd",$hWnd,"int",$BFFM_ENABLEOK,"int",0,"ptr",0)
                    EndIf
                EndIf
            EndIf
    EndSwitch
EndFunc ;==> __FileSFCallbackProc
