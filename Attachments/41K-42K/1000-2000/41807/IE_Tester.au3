;~ #AutoIt3Wrapper_run_debug_mode=Y
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7

#include-once
#include <IE.au3>

;~ EXAMPLE: HOW TO USE
;~ Uncheck one of the following comments to see how the example works
;~ _IE_test_Example() ; Simple example, without additional information in console
;~ _IE_test_Example_1_FormCollection()
;~ _IE_test_Example_2_FormElementCollection()
;~ _IE_test_Example_3_FramesetCollection()
;~ _IE_test_Example_4_ImgCollection()
;~ _IE_test_Example_5_LinkCollection()
;~ _IE_test_Example_6_TableCollection()
;~ _IE_test_Example_7_TagNameAllGetCollection()
;~ _IE_test_Example_8_TagNameGetCollection()

Func _IE_test_Example()
	Local $sTitle = '[REGEXPTITLE:(?i)(.*_IE_Example.*?form.*?Internet Explorer.*)]'
	Local $oIE_Test = _IE_Example("form")
	_IELoadWait($oIE_Test)

	_IE_test_GetObjType($oIE_Test)
	_IE_test_FormCollection($oIE_Test)
	_IE_test_FormElementCollection($oIE_Test)
	_IE_test_AttachToTitle($sTitle)
	ConsoleWrite(@CRLF)
	_IEQuit($oIE_Test)
EndFunc   ;==>_IE_test_Example

Func _IE_test_Example_1_FormCollection()
	Local $oIE = _IECreate("http://www.google.com")
	_IELoadWait($oIE)
	Local $sTitle = '[REGEXPTITLE:(?i)(.*google.*Internet Explorer.*)]'
	Local $oIE_Test = _IEAttachToTitle($sTitle)

	ConsoleWrite(@CRLF)
	ConsoleWrite('START: TESTING: ............................................. _IE_test_Example_1_FormCollection()' & @CRLF)

	ConsoleWrite(@CRLF)
	ConsoleWrite('TESTING ......................... _IE_test_GetObjType($oIE_Test):' & @CRLF)
	_IE_test_GetObjType($oIE_Test)

	ConsoleWrite(@CRLF)
	ConsoleWrite('TESTING ......................... _IE_test_FormCollection($oIE_Test):' & @CRLF)
	_IE_test_FormCollection($oIE_Test)

	ConsoleWrite(@CRLF)
	ConsoleWrite('TESTING ......................... _IE_test_AttachToTitle(''' & $sTitle & '''):' & @CRLF)
	_IE_test_AttachToTitle($sTitle)

	ConsoleWrite(@CRLF)
	ConsoleWrite('END: TESTING: ............................................. _IE_test_Example_1_FormCollection()' & @CRLF)

	ConsoleWrite(@CRLF)
	$oIE_Test = 0
	_IEQuit($oIE)
EndFunc   ;==>_IE_test_Example_1_FormCollection

Func _IE_test_Example_2_FormElementCollection()
	Local $oIE = _IE_Example("form")
	_IELoadWait($oIE)
	Local $sTitle = '[REGEXPTITLE:(?i)(.*_IE_Example.*?form.*?Internet Explorer.*)]'
	Local $oIE_Test = _IEAttachToTitle($sTitle)

	ConsoleWrite(@CRLF)
	ConsoleWrite('START: TESTING: ............................................. _IE_test_Example_2_FormElementCollection()' & @CRLF)

	ConsoleWrite(@CRLF)
	ConsoleWrite('TESTING ......................... _IE_test_GetObjType($oIE_Test):' & @CRLF)
	_IE_test_GetObjType($oIE_Test)

	ConsoleWrite(@CRLF)
	ConsoleWrite('TESTING ......................... _IE_test_FormElementCollection($oIE_Test):' & @CRLF)
	_IE_test_FormElementCollection($oIE_Test)

	ConsoleWrite(@CRLF)
	ConsoleWrite('TESTING ......................... _IE_test_AttachToTitle(''' & $sTitle & '''):' & @CRLF)
	_IE_test_AttachToTitle($sTitle)

	ConsoleWrite(@CRLF)
	ConsoleWrite('END: TESTING: ............................................. _IE_test_Example_2_FormElementCollection()' & @CRLF)

	ConsoleWrite(@CRLF)
	$oIE_Test = 0
	_IEQuit($oIE)
EndFunc   ;==>_IE_test_Example_2_FormElementCollection

Func _IE_test_Example_3_FramesetCollection()
;~ 	Local $oIE = _IE_Example("iframe")
	Local $oIE = _IE_Example("frameset")
	_IELoadWait($oIE)

	ConsoleWrite(@CRLF)
	ConsoleWrite('START: TESTING: ............................................. _IE_test_Example_3_FramesetCollection()' & @CRLF)

	ConsoleWrite(@CRLF)
	ConsoleWrite('TESTING ......................... _IE_test_GetObjType($oIE):' & @CRLF)
	_IE_test_GetObjType($oIE)

	ConsoleWrite(@CRLF)
	ConsoleWrite('TESTING ......................... _IE_test_FrameCollection($oIE):' & @CRLF)
	_IE_test_FrameCollection($oIE)

	ConsoleWrite(@CRLF)
	ConsoleWrite('END: TESTING: ............................................. _IE_test_Example_3_FramesetCollection()' & @CRLF)

	ConsoleWrite(@CRLF)
	_IEQuit($oIE)
EndFunc   ;==>_IE_test_Example_3_FramesetCollection

Func _IE_test_Example_4_ImgCollection()
	Local $oIE = _IECreate("http://autoitscript.com")
	_IELoadWait($oIE)

	ConsoleWrite(@CRLF)
	ConsoleWrite('START: TESTING: ............................................. _IE_test_Example_4_ImgCollection()' & @CRLF)

	ConsoleWrite(@CRLF)
	ConsoleWrite('TESTING ......................... _IE_test_GetObjType($oIE):' & @CRLF)
	_IE_test_GetObjType($oIE)

	ConsoleWrite(@CRLF)
	ConsoleWrite('TESTING ......................... _IE_test_ImgCollection($oIE):' & @CRLF)
	_IE_test_ImgCollection($oIE)

	ConsoleWrite(@CRLF)
	ConsoleWrite('END: TESTING: ............................................. _IE_test_Example_4_ImgCollection()' & @CRLF)

	ConsoleWrite(@CRLF)
	_IEQuit($oIE)
EndFunc   ;==>_IE_test_Example_4_ImgCollection

Func _IE_test_Example_5_LinkCollection()
	Local $oIE = _IE_Example("basic")
	_IELoadWait($oIE)

	ConsoleWrite(@CRLF)
	ConsoleWrite('START: TESTING: ............................................. _IE_test_Example_5_LinkCollection()' & @CRLF)

	ConsoleWrite(@CRLF)
	ConsoleWrite('TESTING ......................... _IE_test_LinkCollection($oIE):' & @CRLF)
	_IE_test_LinkCollection($oIE)

	ConsoleWrite(@CRLF)
	ConsoleWrite('END: TESTING: ............................................. _IE_test_Example_5_LinkCollection()' & @CRLF)

	ConsoleWrite(@CRLF)
	_IEQuit($oIE)
EndFunc   ;==>_IE_test_Example_5_LinkCollection

Func _IE_test_Example_6_TableCollection()
	Local $oIE = _IE_Example("table")
	_IELoadWait($oIE)

	ConsoleWrite(@CRLF)
	ConsoleWrite('START: TESTING: ............................................. _IE_test_Example_6_TableCollection()' & @CRLF)

	ConsoleWrite(@CRLF)
	ConsoleWrite('TESTING ......................... _IE_test_TableCollection($oIE):' & @CRLF)
	_IE_test_TableCollection($oIE)

	ConsoleWrite(@CRLF)
	ConsoleWrite('END: TESTING: ............................................. _IE_test_Example_6_TableCollection()' & @CRLF)

	ConsoleWrite(@CRLF)
	_IEQuit($oIE)
EndFunc   ;==>_IE_test_Example_6_TableCollection

Func _IE_test_Example_7_TagNameAllGetCollection()
	Local $oIE = _IE_Example("basic")
	_IELoadWait($oIE)

	ConsoleWrite(@CRLF)
	ConsoleWrite('START: TESTING: ............................................. _IE_test_Example_7_TagNameAllGetCollection()' & @CRLF)

	ConsoleWrite(@CRLF)
	ConsoleWrite('TESTING ......................... _IE_test_TagNameAllGetCollection($oIE):' & @CRLF)
	_IE_test_TagNameAllGetCollection($oIE)

	ConsoleWrite(@CRLF)
	ConsoleWrite('END: TESTING: ............................................. _IE_test_Example_7_TagNameAllGetCollection()' & @CRLF)

	ConsoleWrite(@CRLF)
	_IEQuit($oIE)
EndFunc   ;==>_IE_test_Example_7_TagNameAllGetCollection

Func _IE_test_Example_8_TagNameGetCollection()
	Local $oIE = _IE_Example("form")
	_IELoadWait($oIE)

	ConsoleWrite(@CRLF)
	ConsoleWrite('START: TESTING: ............................................. _IE_test_Example_8_TagNameGetCollection()' & @CRLF)

	ConsoleWrite(@CRLF)
	ConsoleWrite('TESTING ......................... _IE_test_TagNameGetCollection($oIE):' & @CRLF)
	_IE_test_TagNameGetCollection($oIE, "input")

	ConsoleWrite(@CRLF)
	ConsoleWrite('END: TESTING: ............................................. _IE_test_Example_8_TagNameGetCollection()' & @CRLF)

	ConsoleWrite(@CRLF)
	_IEQuit($oIE)
EndFunc   ;==>_IE_test_Example_8_TagNameGetCollection

Func _IE_test_FormCollection(ByRef $oIE)
	ConsoleWrite(@CRLF)
	_IE_test__VersionInfo($oIE)
	ConsoleWrite('! _IE_test_FormCollection:' & @TAB & 'IsObj($oIE) = ' & IsObj($oIE) & @CRLF)
	Local $oForms = _IEFormGetCollection($oIE)
	Local $iFormsCount = @extended
	ConsoleWrite('! _IE_test_FormCollection:' & @TAB & 'IsObj($oForms) = ' & IsObj($oForms) & @CRLF)
	ConsoleWrite('! _IE_test_FormCollection:' & @TAB & '$oForms "Type" = ' & _IE_test_GetObjType($oForms, True) & @CRLF)
	ConsoleWrite('! _IE_test_FormCollection:' & @TAB & '$iFormsCount = ' & $iFormsCount & @CRLF)
	Local $iForm_index = 0
	For $oForm In $oForms
		ConsoleWrite(@CRLF)
		ConsoleWrite('! _IE_test_FormCollection:' & @TAB & '$iForm_index = ' & $iForm_index & @CRLF)
		If $oForm.id Then
			ConsoleWrite('! _IE_test_FormCollection:' & @TAB & '$oForm.id = ' & $oForm.id & @CRLF)
		Else
			ConsoleWrite('! _IE_test_FormCollection:' & @TAB & '$oForm.id = ' & 'Object does not have such a property.' & @CRLF)
		EndIf
		If $oForm.name Then
			ConsoleWrite('! _IE_test_FormCollection:' & @TAB & '$oForm.name = ' & $oForm.name & @CRLF)
		Else
			ConsoleWrite('! _IE_test_FormCollection:' & @TAB & '$oForm.name = ' & 'Object does not have such a property.' & @CRLF)
		EndIf
		$iForm_index += 1
	Next
EndFunc   ;==>_IE_test_FormCollection

Func _IE_test_FormElementCollection(ByRef $oIE)
	ConsoleWrite(@CRLF)
	_IE_test__VersionInfo($oIE)
	ConsoleWrite('! _IE_test_FormElementCollection:' & @TAB & 'IsObj($oIE) = ' & IsObj($oIE) & @CRLF)
	Local $oForms = _IEFormGetCollection($oIE)
	Local $oFormsCount = @extended
	ConsoleWrite('! _IE_test_FormElementCollection:' & @TAB & 'IsObj($oForms) = ' & IsObj($oForms) & @CRLF)
	ConsoleWrite('! _IE_test_FormElementCollection:' & @TAB & '$oForms "Type" = ' & _IE_test_GetObjType($oForms, True) & @CRLF)
	ConsoleWrite('! _IE_test_FormElementCollection:' & @TAB & '$oFormsCount = ' & $oFormsCount & @CRLF)
	Local $oFormElements
	Local $sOuterHtml = ''
	Local $iForm_index = 0
	For $oForm In $oForms
		ConsoleWrite(@CRLF)
		$sOuterHtml = _IEPropertyGet($oForm, 'Outerhtml')
		ConsoleWrite('! _IE_test_FormElementCollection:' & @TAB & '$iForm_index = ' & $iForm_index & @CRLF)
		ConsoleWrite('! _IE_test_FormElementCollection:' & @TAB & '$oForm "Type" = ' & _IE_test_GetObjType($oForm, True) & @CRLF)
;~ 		ConsoleWrite('! _IE_test_FormElementCollection:' & @TAB & '$oForm "OuterHtml" = ' & $sOuterHtml & @CRLF)
		If $oForm.id Then
			ConsoleWrite('! _IE_test_FormElementCollection:' & @TAB & '$oForm.id = ' & $oForm.id & @CRLF)
		Else
			ConsoleWrite('! _IE_test_FormElementCollection:' & @TAB & '$oForm.id = ' & 'Object does not have such a property.' & @CRLF)
		EndIf
		If $oForm.name Then
			ConsoleWrite('! _IE_test_FormElementCollection:' & @TAB & '$oForm.name = ' & $oForm.name & @CRLF)
		Else
			ConsoleWrite('! _IE_test_FormElementCollection:' & @TAB & '$oForm.name = ' & 'Object does not have such a property.' & @CRLF)
		EndIf
		$oFormElements = _IEFormElementGetCollection($oForm)
		Local $iElement_index = 0
		For $oElement In $oFormElements
			ConsoleWrite(@CRLF)
			$sOuterHtml = _IEPropertyGet($oElement, 'Outerhtml')
			ConsoleWrite('!' & @TAB & '_IE_test_FormElementCollection:' & @TAB & '$iElement_index = ' & $iElement_index & @CRLF)
			ConsoleWrite('!' & @TAB & '_IE_test_FormElementCollection:' & @TAB & '$oElement "Type" = ' & _IE_test_GetObjType($oElement, True) & @CRLF)
			ConsoleWrite('!' & @TAB & '_IE_test_FormElementCollection:' & @TAB & '$oElement.type = ' & $oElement.type & @CRLF)
			If $oElement.name Then
				ConsoleWrite('!' & @TAB & '_IE_test_FormElementCollection:' & @TAB & '$oElement.name = ' & $oElement.name & @CRLF)
			Else
				ConsoleWrite('!' & @TAB & '_IE_test_FormElementCollection:' & @TAB & '$oElement.name = ' & 'Object does not have such a property.' & @CRLF)
			EndIf
			If $oElement.id Then
				ConsoleWrite('!' & @TAB & '_IE_test_FormElementCollection:' & @TAB & '$oElement.id = ' & $oElement.id & @CRLF)
			Else
				ConsoleWrite('!' & @TAB & '_IE_test_FormElementCollection:' & @TAB & '$oElement.id = ' & 'Object does not have such a property.' & @CRLF)
			EndIf
			ConsoleWrite('!' & @TAB & '_IE_test_FormElementCollection:' & @TAB & '$oElement "OuterHtml" = ' & $sOuterHtml & @CRLF)
			$iElement_index += 1
		Next
		$iForm_index += 1
	Next
EndFunc   ;==>_IE_test_FormElementCollection

Func _IE_test_FrameCollection(ByRef $oIE)
	ConsoleWrite(@CRLF)
	_IE_test__VersionInfo($oIE)
	ConsoleWrite('! _IE_test_FrameCollection:' & @TAB & 'IsObj($oIE) = ' & IsObj($oIE) & @CRLF)
	Local $oFrames = _IEFrameGetCollection($oIE)
	Local $iFramesCount = @extended
	ConsoleWrite('! _IE_test_FrameCollection:' & @TAB & 'IsObj($oFrames) = ' & IsObj($oFrames) & @CRLF)
	ConsoleWrite('! _IE_test_FrameCollection:' & @TAB & '$oFrames "Type" = ' & _IE_test_GetObjType($oFrames, True) & @CRLF)
	ConsoleWrite('! _IE_test_FrameCollection:' & @TAB & '$iFramesCount = ' & $iFramesCount & @CRLF)
	Local $oFrame
	Local $sOuterHtml = ''
	For $iFrame_index = 0 To ($iFramesCount - 1)
		$oFrame = _IEFrameGetCollection($oIE, $iFrame_index)
		$sOuterHtml = _IEPropertyGet($oFrame, 'Outerhtml')
		ConsoleWrite(@CRLF)
		ConsoleWrite('! _IE_test_FrameCollection:' & @TAB & '$iFrame_index = ' & $iFrame_index & @CRLF)
		ConsoleWrite('! _IE_test_FrameCollection:' & @TAB & '$oFrame "Type" = ' & _IE_test_GetObjType($oFrame, True) & @CRLF)
		ConsoleWrite('! _IE_test_FrameCollection:' & @TAB & '$oFrame "OuterHtml" = ' & $sOuterHtml & @CRLF)
		If $oFrame.id Then
			ConsoleWrite('! _IE_test_FrameCollection:' & @TAB & '$oFrame.id = ' & $oFrame.id & @CRLF)
		Else
			ConsoleWrite('! _IE_test_FrameCollection:' & @TAB & '$oFrame.id = ' & 'Object does not have such a property.' & @CRLF)
		EndIf
		ConsoleWrite('! _IE_test_FrameCollection:' & @TAB & '$oFrame.name = ' & $oFrame.name & @CRLF)
		If $oFrame.type Then _
				ConsoleWrite('! _IE_test_FrameCollection:' & @TAB & '$oFrame.type = ' & $oFrame.type & @CRLF)
	Next
EndFunc   ;==>_IE_test_FrameCollection

Func _IE_test_ImgCollection(ByRef $oIE)
	ConsoleWrite(@CRLF)
	_IE_test__VersionInfo($oIE)
	ConsoleWrite('! _IE_test_ImgCollection:' & @TAB & 'IsObj($oIE) = ' & IsObj($oIE) & @CRLF)
	Local $oImgs = _IEImgGetCollection($oIE)
	Local $iImgsCount = @extended
	ConsoleWrite('! _IE_test_ImgCollection:' & @TAB & 'IsObj($oImgs) = ' & IsObj($oImgs) & @CRLF)
	ConsoleWrite('! _IE_test_ImgCollection:' & @TAB & '$oImgs "Type" = ' & _IE_test_GetObjType($oImgs, True) & @CRLF)
	ConsoleWrite('! _IE_test_ImgCollection:' & @TAB & '$iImgsCount = ' & $iImgsCount & @CRLF)
	Local $sOuterHtml = ''
	Local $iImg_index = 0
	For $oImg In $oImgs
		$sOuterHtml = _IEPropertyGet($oImg, 'Outerhtml')
		ConsoleWrite(@CRLF)
		ConsoleWrite('! _IE_test_ImgCollection:' & @TAB & '$iImg_index = ' & $iImg_index & @CRLF)
		ConsoleWrite('! _IE_test_ImgCollection:' & @TAB & '$oImg "Type" = ' & _IE_test_GetObjType($oImg, True) & @CRLF)
		ConsoleWrite('! _IE_test_ImgCollection:' & @TAB & '$oImg "OuterHtml" = ' & $sOuterHtml & @CRLF)
		ConsoleWrite('! _IE_test_ImgCollection:' & @TAB & '$oImg.id = ' & $oImg.id & @CRLF)
		ConsoleWrite('! _IE_test_ImgCollection:' & @TAB & '$oImg.alt = ' & $oImg.alt & @CRLF)
		ConsoleWrite('! _IE_test_ImgCollection:' & @TAB & '$oImg.name = ' & $oImg.name & @CRLF)
		ConsoleWrite('! _IE_test_ImgCollection:' & @TAB & '$oImg.nameProp = ' & $oImg.nameProp & @CRLF)
		ConsoleWrite('! _IE_test_ImgCollection:' & @TAB & '$oImg.src = ' & $oImg.src & @CRLF)
		ConsoleWrite('! _IE_test_ImgCollection:' & @TAB & '$oImg.width = ' & $oImg.width & @CRLF)
		ConsoleWrite('! _IE_test_ImgCollection:' & @TAB & '$oImg.height = ' & $oImg.height & @CRLF)
		ConsoleWrite('! _IE_test_ImgCollection:' & @TAB & '$oImg.Border = ' & $oImg.Border & @CRLF)
		$iImg_index += 1
	Next
EndFunc   ;==>_IE_test_ImgCollection

Func _IE_test_LinkCollection(ByRef $oIE)
	ConsoleWrite(@CRLF)
	_IE_test__VersionInfo($oIE)
	ConsoleWrite('! _IE_test_LinkCollection:' & @TAB & 'IsObj($oIE) = ' & IsObj($oIE) & @CRLF)
	Local $oLinks = _IELinkGetCollection($oIE)
	Local $iLinksCount = @extended
	ConsoleWrite('! _IE_test_LinkCollection:' & @TAB & 'IsObj($oLinks) = ' & IsObj($oLinks) & @CRLF)
	ConsoleWrite('! _IE_test_LinkCollection:' & @TAB & '$oLinks "Type" = ' & _IE_test_GetObjType($oLinks, True) & @CRLF)
	ConsoleWrite('! _IE_test_LinkCollection:' & @TAB & '$iLinksCount = ' & $iLinksCount & @CRLF)
	Local $sOuterHtml = ''
	Local $iLink_index = 0
	For $oLink In $oLinks
		$sOuterHtml = _IEPropertyGet($oLink, 'Outerhtml')
		ConsoleWrite(@CRLF)
		ConsoleWrite('! _IE_test_LinkCollection:' & @TAB & '$iLink_index = ' & $iLink_index & @CRLF)
		ConsoleWrite('! _IE_test_LinkCollection:' & @TAB & '$oLink "Type" = ' & _IE_test_GetObjType($oLink, True) & @CRLF)
		ConsoleWrite('! _IE_test_LinkCollection:' & @TAB & '$oLink "OuterHtml" = ' & $sOuterHtml & @CRLF)
		ConsoleWrite('! _IE_test_LinkCollection:' & @TAB & '$oLink.href = ' & $oLink.href & @CRLF)
		ConsoleWrite('! _IE_test_LinkCollection:' & @TAB & '$oLink.nameProp = ' & $oLink.nameProp & @CRLF)
		$iLink_index += 1
	Next
EndFunc   ;==>_IE_test_LinkCollection

Func _IE_test_TableCollection(ByRef $oIE)
	ConsoleWrite(@CRLF)
	_IE_test__VersionInfo($oIE)
	ConsoleWrite('! _IE_test_TableCollection:' & @TAB & 'IsObj($oIE) = ' & IsObj($oIE) & @CRLF)
	Local $oTables = _IETableGetCollection($oIE)
	Local $iTablesCount = @extended
	ConsoleWrite('! _IE_test_TableCollection:' & @TAB & 'IsObj($oTables) = ' & IsObj($oTables) & @CRLF)
	ConsoleWrite('! _IE_test_TableCollection:' & @TAB & '$oTable "Type" = ' & _IE_test_GetObjType($oTables, True) & @CRLF)
	ConsoleWrite('! _IE_test_TableCollection:' & @TAB & '$iTablesCount = ' & $iTablesCount & @CRLF)
	Local $sOuterHtml = ''
	Local $iTable_index = 0
	For $oTable In $oTables
		$sOuterHtml = _IEPropertyGet($oTable, 'Outerhtml')
		ConsoleWrite(@CRLF)
		ConsoleWrite('! _IE_test_TableCollection:' & @TAB & '$iTable_index = ' & $iTable_index & @CRLF)
		ConsoleWrite('! _IE_test_TableCollection:' & @TAB & '$oTable "Type" = ' & _IE_test_GetObjType($oTable, True) & @CRLF)
		ConsoleWrite('! _IE_test_TableCollection:' & @TAB & '$oTable.id = ' & $oTable.id & @CRLF)
		If $oTable.type Then _
				ConsoleWrite('! _IE_test_TableCollection:' & @TAB & '$oTable.type = ' & $oTable.type & @CRLF)
		ConsoleWrite('! _IE_test_TableCollection:' & @TAB & '$oTable "OuterHtml" = ' & $sOuterHtml & @CRLF)
		$iTable_index += 1
	Next
EndFunc   ;==>_IE_test_TableCollection

Func _IE_test_TagNameAllGetCollection(ByRef $oIE)
	_IE_test__VersionInfo($oIE)
	ConsoleWrite(@CRLF)
	ConsoleWrite('! _IE_test_TagNameAllGetCollection:' & @TAB & 'IsObj($oIE) = ' & IsObj($oIE) & @CRLF)
	Local $oTags = _IETagNameAllGetCollection($oIE)
	Local $iTagsCount = @extended
	ConsoleWrite('! _IE_test_TagNameAllGetCollection:' & @TAB & 'IsObj($oTags) = ' & IsObj($oTags) & @CRLF)
	ConsoleWrite('! _IE_test_TagNameAllGetCollection:' & @TAB & '$oTag "Type" = ' & _IE_test_GetObjType($oTags, True) & @CRLF)
	ConsoleWrite('! _IE_test_TagNameAllGetCollection:' & @TAB & '$iTagsCount = ' & $iTagsCount & @CRLF)
	Local $sOuterHtml = ''
	Local $iTag_index = 0
	For $oTag In $oTags
		$sOuterHtml = _IEPropertyGet($oTag, 'Outerhtml')
		If $oTag.id Then
			ConsoleWrite(@CRLF)
			ConsoleWrite('! _IE_test_TagNameAllGetCollection:' & @TAB & '$iTag_index = ' & $iTag_index & @CRLF)
			ConsoleWrite('! _IE_test_TagNameAllGetCollection:' & @TAB & '$oTag "Type" = ' & _IE_test_GetObjType($oTag, True) & @CRLF)
			ConsoleWrite('! _IE_test_TagNameAllGetCollection:' & @TAB & '$oTag.tagname = ' & $oTag.tagname & @CRLF)
			ConsoleWrite('! _IE_test_TagNameAllGetCollection:' & @TAB & '$oTag.id = ' & $oTag.id & @CRLF)
			If $oTag.type Then _
					ConsoleWrite('! _IE_test_TagNameAllGetCollection:' & @TAB & '$oTag.type = ' & $oTag.type & @CRLF)
			ConsoleWrite('! _IE_test_TagNameAllGetCollection:' & @TAB & '$oTag "OuterHtml" = ' & $sOuterHtml & @CRLF)
		EndIf
		$iTag_index += 1
	Next
EndFunc   ;==>_IE_test_TagNameAllGetCollection

Func _IE_test_TagNameGetCollection(ByRef $oIE, $s_TagName)
	_IE_test__VersionInfo($oIE)
	Local $sOuterHtml = ''
	ConsoleWrite(@CRLF)
	ConsoleWrite('! _IE_test_TagNameGetCollection:' & @TAB & 'IsObj($oIE) = ' & IsObj($oIE) & @CRLF)
	Local $oTags = _IETagNameGetCollection($oIE, $s_TagName)
	Local $iTagsCount = @extended
	ConsoleWrite('! _IE_test_TagNameGetCollection:' & @TAB & '$s_TagName = ' & $s_TagName & @CRLF)
	ConsoleWrite('! _IE_test_TagNameGetCollection:' & @TAB & 'IsObj($oTags) = ' & IsObj($oTags) & @CRLF)
	ConsoleWrite('! _IE_test_TagNameGetCollection:' & @TAB & '$oTags "Type" = ' & _IE_test_GetObjType($oTags, True) & @CRLF)
	ConsoleWrite('! _IE_test_TagNameGetCollection:' & @TAB & '$iTagsCount = ' & $iTagsCount & @CRLF)
	Local $iTag_index = 0
	For $oTag In $oTags
		$sOuterHtml = _IEPropertyGet($oTag, 'Outerhtml')
		ConsoleWrite(@CRLF)
		ConsoleWrite('! _IE_test_TagNameGetCollection:' & @TAB & '$iTag_index = ' & $iTag_index & @CRLF)
		ConsoleWrite('! _IE_test_TagNameGetCollection:' & @TAB & '$oTag "Type" = ' & _IE_test_GetObjType($oTag, True) & @CRLF)
		ConsoleWrite('! _IE_test_TagNameGetCollection:' & @TAB & '$oTag.tagname = ' & $oTag.tagname & @CRLF)
		ConsoleWrite('! _IE_test_TagNameGetCollection:' & @TAB & '$oTag.id = ' & $oTag.id & @CRLF)
		If $oTag.type Then _
				ConsoleWrite('! _IE_test_TagNameGetCollection:' & @TAB & '$oTag.type = ' & $oTag.type & @CRLF)
		If $oTag.value Then _
				ConsoleWrite('! _IE_test_TagNameGetCollection:' & @TAB & '$oTag.value = ' & $oTag.value & @CRLF)
		ConsoleWrite('! _IE_test_TagNameGetCollection:' & @TAB & '$oTag "OuterHtml" = ' & $sOuterHtml & @CRLF)
		$iTag_index += 1
	Next
EndFunc   ;==>_IE_test_TagNameGetCollection

Func _IE_test_AttachToTitle($sTitle)
	Local $oIE_temp
;~ 	If You have a problem with attach to window You can user RegExp
;~ 	for example
;~ 	$sTITLE = "[REGEXPTITLE:(?i)(.*google.*Internet Explorer.*)]"
	ConsoleWrite(@CRLF)
	ConsoleWrite('! _IE_test_AttachToTitle:' & @TAB & '$sTITLE = ' & $sTitle & @CRLF)
	If WinExists($sTitle) = 0 Then
		ConsoleWrite('! _IE_test_AttachToTitle:' & @TAB & 'WinExists($sTITLE) = 0' & @CRLF)
	Else
		ConsoleWrite('! _IE_test_AttachToTitle:' & @TAB & 'WinExists($sTITLE) = 1' & @CRLF)
		$oIE_temp = _IEAttachToTitle($sTitle)
	EndIf
	ConsoleWrite('! _IE_test_AttachToTitle:' & @TAB & 'IsObj($oIE_temp) = ' & IsObj($oIE_temp) & @CRLF)
EndFunc   ;==>_IE_test_AttachToTitle

Func _IE_test_GetObjType(ByRef $oIE, $fReturn = False)
	Local $sType = String(ObjName($oIE))
	If $fReturn = False Then
		ConsoleWrite(@CRLF)
		ConsoleWrite('! _IE_test_GetObjType:' & @TAB & @TAB & '$sType = ' & $sType & @CRLF)
	Else
		Return $sType
	EndIf
EndFunc   ;==>_IE_test_GetObjType

Func _IEAttachToTitle($sTitle)
	Local $hWindowToFind = WinGetHandle($sTitle)
	Return _IEAttach($hWindowToFind, "HWND")
EndFunc   ;==>_IEAttachToTitle

Func _IE_test__VersionInfo($oIE)
;~ "appcodename" Retrieves the code name of the browser (the property has a default value of Mozilla).
;~ "appminorversion" Retrieves the application's minor version value.
;~ "appname" Retrieves the name of the browser (the property has a default value of Microsoft Internet Explorer).
;~ "appversion" Retrieves the platform and version of the browser.
	ConsoleWrite('! _IE_test__VersionInfo($oIE):' & @TAB & ' "appcodename" = ' & @TAB & _IEPropertyGet($oIE, "appcodename") & @CRLF)
	ConsoleWrite('! _IE_test__VersionInfo($oIE):' & @TAB & ' "appminorversion" = ' & @TAB & _IEPropertyGet($oIE, "appminorversion") & @CRLF)
	ConsoleWrite('! _IE_test__VersionInfo($oIE):' & @TAB & ' "appname" = ' & @TAB & @TAB & _IEPropertyGet($oIE, "appname") & @CRLF)
	ConsoleWrite('! _IE_test__VersionInfo($oIE):' & @TAB & ' "appversion" = ' & @TAB & _IEPropertyGet($oIE, "appversion") & @CRLF)

	Local $aVersion = _IE_VersionInfo()
	Local $IEAU3VersionInfo[6]
	$IEAU3VersionInfo[0] = 'Release Type(T = Test Or V = Production)'
	$IEAU3VersionInfo[1] = 'Major Version'
	$IEAU3VersionInfo[2] = 'Minor Version'
	$IEAU3VersionInfo[3] = 'Sub Version'
	$IEAU3VersionInfo[4] = 'Release Date(YYYYMMDD)'
	$IEAU3VersionInfo[5] = 'Display Version(E.g. V2.1 - 0)'
	ConsoleWrite(@CRLF)
	For $i = 4 To 5
		ConsoleWrite('! _IE_test__VersionInfo($oIE):' & @TAB & ' _IE_VersionInfo(' & $i & ') = ' & $aVersion[$i] & @TAB & @TAB & '"' & $IEAU3VersionInfo[$i] & '"' & @CRLF)
	Next
	ConsoleWrite(@CRLF)
	ConsoleWrite('! _IE_test__VersionInfo($oIE):' & @TAB & ' @OSArch = ' & @TAB & @TAB & @OSArch & @CRLF)
	ConsoleWrite('! _IE_test__VersionInfo($oIE):' & @TAB & ' @OSLang = ' & @TAB & @TAB & @OSLang & @CRLF)
	ConsoleWrite('! _IE_test__VersionInfo($oIE):' & @TAB & ' @OSType = ' & @TAB & @TAB & @OSType & @CRLF)
	ConsoleWrite('! _IE_test__VersionInfo($oIE):' & @TAB & ' @OSVersion = ' & @TAB & @TAB & @OSVersion & @CRLF)
	ConsoleWrite('! _IE_test__VersionInfo($oIE):' & @TAB & ' @OSBuild = ' & @TAB & @TAB & @OSBuild & @CRLF)
	ConsoleWrite('! _IE_test__VersionInfo($oIE):' & @TAB & ' @OSServicePack = ' & @TAB & @OSServicePack & @CRLF)
	ConsoleWrite(@CRLF & @CRLF)
EndFunc   ;==>_IE_test__VersionInfo
