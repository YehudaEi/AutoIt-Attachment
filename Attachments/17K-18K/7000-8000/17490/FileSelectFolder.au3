#include <GUIConstants.au3>
#include <DllCallBack.au3>

;~ Сообщения, формируемые диалогом выбора
Global Const $BFFM_INITIALIZED = 1 ;~ Инициализация диалога завершена
Global Const $BFFM_SELCHANGED = 2 ;~ Выбор пользователем нового каталога
Global Const $BFFM_VALIDATEFAILEDA = 3 ;~ ANSI: в окно редактирования введен некорректный текст
Global Const $BFFM_VALIDATEFAILEDW = 4 ;~ WideChar: в окно редактирования введен некорректный текст
Global Const $BFFM_IUNKNOWN = 5 ;~ При инициализации: передача указателя на экземпляр IUnknown
;~ Сообщения, принимаемые диалогом выбора
Global Const $BFFM_ENABLEOK = $WM_USER + 101 ;~ Включить/выключить кнопку "Ok"
Global Const $BFFM_SETOKTEXT = $WM_USER + 105 ;~ Задать текст кнопки "Ok"
Global Const $BFFM_SETEXPANDED = $WM_USER + 106 ;~ Раскрыть в дереве определенную папку
Global Const $BFFM_SETSTATUSTEXTA = $WM_USER + 100 ;~ ANSI: задать текст статусной строки
Global Const $BFFM_SETSTATUSTEXTW = $WM_USER + 104 ;~ WideChar: задать текст статусной строки
Global Const $BFFM_SETSELECTIONA = $WM_USER + 102 ;~ ANSI: переместить курсор к определенному каталогу в дереве
Global Const $BFFM_SETSELECTIONW = $WM_USER + 103 ;~ WideChar: переместить курсор к определенному каталогу в дереве
;~ Флаг, включающий "новый стиль" диалога
Global Const $BIF_NEWDIALOGSTYLE = 0x40 ;~ Вывести диалоговое окно "нового стиля" (IE 5.0)
;~ Флаги, применимые только для диалога в "старом стиле" (флаг $BIF_NEWDIALOGSTYLE сброшен)
Global Const $BIF_RETURNONLYFSDIRS = 0x1 ;~ Выбирать только объекты файловой системы
Global Const $BIF_STATUSTEXT = 0x4 ;~ Отображение дополнительного текстовое поля
Global Const $BIF_BROWSEFORCOMPUTER = 0x1000 ;~ Выбирать только компьютеры в сетевом окружении
Global Const $BIF_BROWSEFORPRINTER = 0x2000 ;~ Выбирать только принтеры в сетевом окружении
;~ Флаги, применимые только для диалога в "новом стиле" (флаг $BIF_NEWDIALOGSTYLE установлен)
Global Const $BIF_UAHINT = 0x100 ;~ Показывать текст "подсказки", недействителен для флага $BIF_EDITBOX (IE 6.0)
Global Const $BIF_NONEWFOLDERBUTTON = 0x200 ;~ Не отображать кнопку создания нового каталога (IE 6.0)
Global Const $BIF_SHAREABLE = 0x8000 ;~ Отображать специфические сетевые ресурсы: диски, принтеры, задания, etc. (IE 5.0)
;~ Флаги, примененимые к обоим стилям диалога
Global Const $BIF_DONTGOBELOWDOMAIN = 0x2 ;~ Не открывать домены в сетевом окружении
Global Const $BIF_BROWSEINCLUDEFILES = 0x4000 ;~ Позволить выбирать файлы (IE 5.0)
Global Const $BIF_EDITBOX = 0x10 ;~ Включить строку редактирования (IE 4.71)
Global Const $BIF_VALIDATE = 0x20 ;~ Посылать сообщение о наборе недопустимого имени (IE 4.71)
;~ Маска допустимых флагов для диалога "старого стиля"
Global Const $BIF_ALLOLDSTYLEFLAGS = BitOR ( _
	$BIF_DONTGOBELOWDOMAIN, $BIF_BROWSEINCLUDEFILES, $BIF_EDITBOX, $BIF_VALIDATE, _
	$BIF_BROWSEFORCOMPUTER, $BIF_BROWSEFORPRINTER, $BIF_RETURNONLYFSDIRS, $BIF_STATUSTEXT)
;~ Маска допустимых флагов для диалога "нового стиля"
Global Const $BIF_ALLNEWSTYLEFLAGS = BitOR ( $BIF_NEWDIALOGSTYLE, _
	$BIF_DONTGOBELOWDOMAIN, $BIF_BROWSEINCLUDEFILES, $BIF_EDITBOX, $BIF_VALIDATE, _
	$BIF_NONEWFOLDERBUTTON, $BIF_UAHINT, $BIF_SHAREABLE)


;~ Список принимаемых параметров:
;~	$sText - текст приглашения;
;~	$iRoot - код корневого каталога (0 - "рабочий стол");
;~	$iFlags - набор флагов;
;~	$sInitDir - стартовый каталог;
;~	$hWnd - хэндл родительского окна;
;~	$sCallbackProc - имя CallBack-процедуры
Func _FileSelectFolder($sText = '', $iRoot = 0, $iFlags = 0, $sInitDir = @ScriptDir, $hWnd = 0, $sCallbackProc = '_FileSFCallbackProc')
	Local $pidl, $res='', $pCallbackProc=0, $iMask = $BIF_ALLOLDSTYLEFLAGS, $Error = 0
	; Контроль входных параметров
	;$sInitDir = StringRegExpReplace($sInitDir, '([^\\])\\*$', '\1\\')
	;If StringRight($sInitDir, 1)=':' Then $sInitDir &= '\'
	If BitAND($iFlags, $BIF_NEWDIALOGSTYLE) Then $iMask = $BIF_ALLNEWSTYLEFLAGS
	; Создание и инициализация основных структур данных
	Local $uBI = DllStructCreate ("hwnd;ptr;ptr;ptr;int;ptr;ptr;int") ; BROWSEINFO
	Local $uTX = DllStructCreate ("char[260];char") ; Текст приглашения
	Local $uMP = DllStructCreate ("char[260]") ; MAX_PATH
	Local $uCB = DllStructCreate ("char[260];int") ; CallBack структура
	DllStructSetData ($uTX, 1, $sText)
	DllStructSetData ($uCB, 1, $sInitDir)
	DllStructSetData ($uCB, 2, $iFlags)
	; Заполнение структуры BROWSEINFO
	DllStructSetData ($uBI, 1, $hwnd)
	DllStructSetData ($uBI, 3, DllStructGetPtr($uMP))
	DllStructSetData ($uBI, 4, DllStructGetPtr($uTX))
	DllStructSetData ($uBI, 5, BitAND($iFlags, $iMask))
	DllStructSetData ($uBI, 7, DllStructGetPtr($uCB))
	; Получение указателя на CallBack-функцию
	If $sCallbackProc<>'' Then $pCallbackProc = _DllCallBack($sCallbackProc,'hwnd;uint;long;ptr')
	If @error Then Return SetError(2, @error, '') ; ОШИБКА получения указателя
	DllStructSetData ($uBI, 6, $pCallbackProc)
	; Получение указателя на корневую папку (PIDL)
	Local $ret = DllCall ("shell32.dll", "ptr", "SHGetSpecialFolderLocation", _
		"int", 0 , "int", $iRoot , "ptr", DllStructGetPtr($uBI, 2))
	If $ret[0]=0 Then
		; Запуск системного диалога
		$pidl = DllCall ("shell32.dll", "ptr", "SHBrowseForFolder", "ptr", DllStructGetPtr($uBI))
		$res = DllStructGetData ($uMP, 1) ; сохраняем имя объекта
		If $pidl[0] Then
			; Обработка полученного указателя (PIDL)
			$ret = DllCall ("shell32.dll", "int", "SHGetPathFromIDList", "ptr", $pidl[0], "ptr", DllStructGetPtr($uMP))
			If $ret[0] Then $res = DllStructGetData ($uMP, 1)
			DllCall ("ole32.dll", "int", "CoTaskMemFree", "ptr", $pidl[0]) ; чистим за собой
		Else
			$Error = 1
		EndIf
		DllCall ("ole32.dll", "int", "CoTaskMemFree", "ptr", DllStructGetData ($uBI, 2)) ; чистим за собой
	Else
		SetError(1, 0, '') ; ОШИБКА в параметре корневой папки
	EndIf
	If $pCallbackProc Then _DllCallBack_Free ($pCallbackProc) ; закрытие указателя
	Return SetError($Error, 0, $res)
EndFunc ;==> _FileSelectFolder

; Функция обратного вызова для _FileSelectFolder по умолчанию
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
