#cs
========================== UDF-Collection OBJECT 'Scripting.Dictionary' ===========================

_ObjDictCreate([mode])
        Creates an dictionary object in binary mode (default) or text mode
        Returns the object handle
		
_ObjDictAdd(object, key, value)
        Adds an key-value pair to the dictionary object
		
_ObjDictGetValue(object, key)
        Reads the value from a given key
		
_ObjDictSetValue(object, key, value)
        Sets the value for a given key
		
_ObjDictCount(object)
        Returns count of keys
		
_ObjDictSearch(object, key)
        To check for existence of an key, get 'TRUE' if found
		
_ObjDictDeleteKey(object, key)
        Delete given key (and value)
        With empty string for key all keys will delete (default)
		
_ObjDictList(object [, title])
        Shows in an GUI with listview all key-value pairs
		
_IniReadSectionToObjDict(objekt, INI-path, section)
        Reads all key-value pairs from an INI-section to an dictionary object
        Returns the count of key-value pairs
		
_IniWriteSectionFromObjDict(object, INI-path, section)
        Writes all key-value pairs from an dictionary object to INI-section
        Returns the count of key-value pairs
		
_FileReadToObjDict(object, textfile-path [, seperator])
        Reads all key-value pairs from an textfile to an dictionary object line by line (1 pair/line)
        Default seperator is '|', be able to change
        Returns the count of key-value pairs
		
_FileWriteFromObjDict(object, textfile-path [, seperator [, overwrite]])
        Writes all key-value pairs from an dictionary object to an textfile line by line (1 pair/line)
        With overwrite='TRUE' (default) the file will overwrite otherwise all key-value pairs
        will append
        Default seperator is '|', be able to change
        Returns the count of key-value pairs
		
Author: BugFix	( bugfix@autoit.de )

===================================================================================================
#ce
#include <GuiConstants.au3>
#include <GuiListView.au3>
;==================================================================================================
; Name:      _ObjDictCreate([$MODE=0])
; Parameter: $MODE
;                  0 Binary (default)
;                  1 Text
; Return:    Object Handle   
;==================================================================================================
Func _ObjDictCreate($MODE=0)
	$oDICT = ObjCreate('Scripting.Dictionary')
	If $MODE <> 0 Then $oDICT.CompareMode = 1
	Return $oDICT
EndFunc ;==>_ObjDictCreate

;==================================================================================================
; Name:      _ObjDictAdd($oDICT, $KEY, $VALUE)
; Parameter: $oDICT - Object Handle
;            $KEY   - key
;            $VALUE - value
; Return:    Success:   0
;            Failure:  -1
;        Error value:   1  object not exist
;                       2  given key was empty
;                       3  given value was empty
;                       4  key always exist
;==================================================================================================
Func _ObjDictAdd(ByRef $oDICT, $KEY, $VALUE)
	If Not IsObj($oDICT) Then
		SetError(1)
		Return -1
	ElseIf $KEY = '' Then
		SetError(2)
		Return -1
	ElseIf $VALUE = '' Then
		SetError(3)
		Return -1
	ElseIf $oDICT.Exists($KEY) Then
		SetError(4)
		Return -1
	EndIf
	$oDICT.Add($KEY, $VALUE)
	Return 0
EndFunc ;==>_ObjDictAdd

;==================================================================================================
; Name:      _ObjDictGetValue($oDICT, $KEY)
; Parameter: $oDICT - Object Handle
;            $KEY   - key
; Return:    Success:   value of key
;            Failure:  -1 
;        Error value:   1  object not exist
;                       2  given key was empty
;                       5  key doesn't exist
;==================================================================================================
Func _ObjDictGetValue(ByRef $oDICT, $KEY)
	If Not IsObj($oDICT) Then
		SetError(1)
		Return -1
	ElseIf $KEY = '' Then
		SetError(2)
		Return -1
	ElseIf Not $oDICT.Exists($KEY) Then
		SetError(5)
		Return -1
	EndIf
	Return $oDICT.Item($KEY)
EndFunc ;==>_ObjDictGetValue

;==================================================================================================
; Name:      _ObjDictSetValue($oDICT, $KEY, $VALUE)
; Parameter: $oDICT - Object Handle
;            $KEY   - key
;            $VALUE - value
; Return:    Success:   0
;            Failure:  -1
;        Error value:   1  object not exist
;                       2  given key was empty
;                       3  given value was empty
;                       5  key doesn't exist
;==================================================================================================
Func _ObjDictSetValue(ByRef $oDICT, $KEY, $VALUE)
	If Not IsObj($oDICT) Then
		SetError(1)
		Return -1
	ElseIf $KEY = '' Then
		SetError(2)
		Return -1
	ElseIf $VALUE = '' Then
		SetError(3)
		Return -1
	ElseIf Not $oDICT.Exists($KEY) Then
		SetError(5)
		Return -1
	EndIf
	$oDICT.Item($KEY) = $VALUE
	Return 0
EndFunc ;==>_ObjDictSetValue

;==================================================================================================
; Name:      _ObjDictCount($oDICT)
; Parameter: $oDICT  - Object Handle
; Return:    Success:  Count of key-value pairs
;            Failure:   -1
;        Error value:    1  object not exist
;==================================================================================================
Func _ObjDictCount(ByRef $oDICT)
	If Not IsObj($oDICT) Then
		SetError(1)
		Return -1
	EndIf
	Return $oDICT.Count
EndFunc ;==>_ObjDictCount

;==================================================================================================
; Name:      _ObjDictSearch($oDICT, $KEY)
; Parameter: $oDICT - Object Handle
;            $KEY   - key
; Return:    Success:  TRUE    key found
;                      FALSE   key doesn't exist
;            Failure:  -1
;        Error value:   1  object not exist
;                       2  given key was empty
;==================================================================================================
Func _ObjDictSearch(ByRef $oDICT, $KEY)
	If Not IsObj($oDICT) Then
		SetError(1)
		Return -1
	ElseIf $KEY = '' Then
		SetError(2)
		Return -1
	ElseIf Not $oDICT.Exists($KEY) Then
		Return False
	Else
		Return True
	EndIf
EndFunc ;==>_ObjDictSearch

;==================================================================================================
; Name:      _ObjDictDeleteKey($oDICT [, $KEY=''])
; Parameter: $oDICT - Object Handle
;            $KEY   - key ,(default='') delete all keys
; Return:    Success:   0
;            Failure:  -1
;        Error value:   1  object not exist
;==================================================================================================
Func _ObjDictDeleteKey(ByRef $oDICT, $KEY='')
	If Not IsObj($oDICT) Then
		SetError(1)
		Return -1
	EndIf
	If $KEY = '' Then
		$oDICT.RemoveAll
		Return 0
	ElseIf Not $oDICT.Exists($KEY) Then
		SetError(5)
		Return -1
	EndIf
	$oDICT.Remove($KEY)
	Return 0
EndFunc ;==>_ObjDictDeleteKey

;==================================================================================================
; Name:      _ObjDictList($oDICT [, $TITLE='Elements Of: Objekt Dictionary'])
; Parameter: $oDICT - Object Handle
;            $TITLE - Window title (optional)
; Return:    Success:   GUI with ListView shows all key-value pairs
;            Failure:  -1
;        Error value:   1  object not exist
; Requirements:       #include <GuiConstants.au3>
;                     #include <GuiListView.au3>
;==================================================================================================
Func _ObjDictList(ByRef $oDICT, $TITLE='Elements Of: Objekt Dictionary')
	If Not IsObj($oDICT) Then
		SetError(1)
		Return -1
	EndIf
	Local $count = $oDICT.Count
	Local $SaveMode = Opt("GUIOnEventMode",0), $ListGUI, $oDictLV, $btnClose, $msg
	$ListGUI = GUICreate($TITLE, 600, 400, (@DesktopWidth - 600)/2, (@DesktopHeight - 400)/2)
	$btnClose = GUICtrlCreateButton('&Ende', 40, 360, 70, 22)
	GUICtrlSetResizing($btnClose, BitOR($GUI_DockRight, $GUI_DockBottom, $GUI_DockSize))
	GUICtrlDelete($oDictLV)
	$oDictLV = GUICtrlCreateListView('key|value', 10, 10, 580, 340, BitOR($LVS_SHOWSELALWAYS, _
	$LVS_EDITLABELS), BitOR($LVS_EX_GRIDLINES, $LVS_EX_HEADERDRAGDROP, $LVS_EX_FULLROWSELECT, $LVS_EX_REGIONAL))
	If $count > 0 Then
		Local $strKey, $colKeys = $oDICT.Keys
		For $strKey In $colKeys
			GUICtrlCreateListViewItem($strKey & '|' & $oDICT.Item($strKey), $oDictLV)
		Next
	Else
		WinSetTitle($ListGUI, '', 'Given Object Includes No Elements!')
	EndIf
	GUISetState(@SW_SHOW, $ListGUI)
	While 1
		$msg = GUIGetMsg(1)
		If $msg[1] = $ListGUI And _
		  ($msg[0] = $GUI_EVENT_CLOSE Or $msg[0] = $btnClose) Then ExitLoop
	WEnd
	GUIDelete($ListGUI) 
	Opt("GUIOnEventMode",$SaveMode) 
EndFunc ;==>ObjDictList

;==================================================================================================
; Name:      _IniReadSectionToObjDict($oDICT, $PathINI, $SECTION)
; Parameter: $oDICT   - Object Handle 
;            $PathINI - Path INI-File
;            $SECTION - Section to read
; Return:    Success:   Count of key-value pairs
;            Failure:   -1
;        Error value:    1  object not exist
;                        6  INI-path doesn't exist
;                        7  no section name
;                        8  INI-section could'nt read or empty
;==================================================================================================
Func _IniReadSectionToObjDict(ByRef $oDICT, $PathINI, $SECTION)
	If Not IsObj($oDICT) Then
		SetError(1)
		Return -1
	ElseIf Not FileExists($PathINI) Then
		SetError(6)
		Return -1
	ElseIf $SECTION = '' Then
		SetError(7)
		Return -1
	EndIf
	Local $arSECTION = IniReadSection($PathINI, $SECTION)
	If Not IsArray($arSECTION) Then
		SetError(8)
		Return -1
	EndIf
	For $i = 1 To $arSECTION[0][0]
		$oDICT.Add($arSECTION[$i][0], $arSECTION[$i][1])
	Next
	Return $arSECTION[0][0]
EndFunc ;==>_IniReadSectionToObjDict

;==================================================================================================
; Name:      _IniWriteSectionFromObjDict($oDICT, $PathINI, $SECTION)
; Parameter: $oDICT   - Object Handle 
;            $PathINI - Path INI-File
;            $SECTION - Section to write
; Return:    Success:   Count of written key-value pairs
;            Failure:   -1
;        Error value:    1  object not exist
;                        7  no section name
;                        9  INI-section could'nt write
;==================================================================================================
Func _IniWriteSectionFromObjDict(ByRef $oDICT, $PathINI, $SECTION)
	If Not IsObj($oDICT) Then
		SetError(1)
		Return -1
	ElseIf $SECTION = '' Then
		SetError(7)
		Return -1
	EndIf
	Local $arSECTION[$oDICT.Count][2], $i = 0
	Local $strKey, $colKeys = $oDICT.Keys
	For $strKey In $colKeys
		$arSECTION[$i][0] = $strKey
		$arSECTION[$i][1] = $oDICT.Item($strKey)
		$i += 1
	Next
	If IniWriteSection($PathINI, $SECTION, $arSECTION, 0) = 1 Then
		Return $oDICT.Count
	Else
		SetError(9)
		Return -1
	EndIf
EndFunc ;==>_IniWriteSectionFromObjDict

;==================================================================================================
; Name:      _FileReadToObjDict($oDICT, $PathFile [, $SEPERATOR='|'])
; Parameter: $oDICT     - Object Handle 
;            $PathFile  - File path
;            $SEPERATOR - Seperator between value and key, default: '|'
; Return:    Success:     Count of key-value pairs
;            Failure:     -1
;        Error value:      1  object not exist
;                          6  file path not exist
;                          7  seperator is empty string
;                          8  could'nt read file
;==================================================================================================
Func _FileReadToObjDict(ByRef $oDICT, $PathFile, $SEPERATOR='|')
	If Not IsObj($oDICT) Then
		SetError(1)
		Return -1
	ElseIf Not FileExists($PathFile) Then
		SetError(6)
		Return -1
	ElseIf $SEPERATOR = '' Then
		SetError(7)
		Return -1
	EndIf
	Local $fh = FileOpen($PathFile, 0), $line
	Local $val
	If $fh = -1 Then
		SetError(8)
		Return -1
	EndIf
	While 1
		$line = FileReadLine($fh)
		If @error = -1 Then ExitLoop
		$val = StringSplit($line, $SEPERATOR)
		If $val[0] > 1 Then
			$oDICT.Add($val[1], $val[2])
		EndIf
	Wend
	FileClose($fh)
	Return $oDICT.Count
EndFunc ;==>_FileReadToObjDict

;==================================================================================================
; Name:      _FileWriteFromObjDict($oDICT, $PathFile [, $SEPERATOR='|' [, $OVERWRITE=True]])
; Parameter: $oDICT     - Object Handle 
;            $PathFile  - File path
;            $SEPERATOR - Seperator between value and key, default: '|'
;            $OVERWRITE - 'TRUE' (default) overwrite file, 'FALSE' appends
; Return:    Success:     Count of written key-value pairs
;            Failure:     -1
;        Error value:      1  object not exist
;                          7  seperator is empty string
;                          8  could'nt write file
;==================================================================================================
Func _FileWriteFromObjDict(ByRef $oDICT, $PathFile, $SEPERATOR='|', $OVERWRITE=True)
	If Not IsObj($oDICT) Then
		SetError(1)
		Return -1
	ElseIf $SEPERATOR = '' Then
		SetError(7)
		Return -1
	EndIf
	If $OVERWRITE Then
		Local $fh = FileOpen($PathFile, 34)
	Else
		Local $fh = FileOpen($PathFile, 33)
	EndIf
 	Local $strKey, $colKeys = $oDICT.Keys
	For $strKey In $colKeys
		FileWriteLine($fh, $strKey & $SEPERATOR & $oDICT.Item($strKey))
		If @error Then
			SetError(8)
			Return -1
		EndIf
	Next
	FileClose($fh)
	Return $oDICT.Count
EndFunc ;==>_FileWriteFromObjDict
 