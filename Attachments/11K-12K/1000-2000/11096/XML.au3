Func _XMLSet(ByRef $s_xml, $s_ele, $s_node)
    $s_xml = $s_xml & "<" & $s_ele & ">" & $s_node & "</" & $s_ele & ">" & @CRLF
EndFunc

Func _XMLGet($s_xml, $s_ele, $occur=1)
    If not _XMLExists($s_xml, $s_ele) Then
        SetError(1)
        Return ""
    EndIf
    Return __StringParse($s_xml, "<" & $s_ele & ">", "</" & $s_ele & ">", $occur)
EndFunc

Func _XMLDel(ByRef $s_xml, $s_ele)
    If not _XMLExists($s_xml, $s_ele) Then
        SetError(1)
        Return ""
    EndIf
    StringReplace("<" & $s_ele & ">" & _XMLGet($s_xml, $s_ele) & "</" & $s_ele & ">" & @CRLF, "", 0, 1)
EndFunc

Func _XMLExists($s_xml, $s_ele)
    If StringInStr($s_xml, "<" & $s_ele & ">") and StringInStr($s_xml, "</" & $s_ele & ">") Then Return 1
    Return 0
EndFunc

Func _XMLSave($s_xml, $s_file)
    FileWrite($s_file, $s_xml)
    Return not @error
EndFunc

Func _XMLLoad($s_file)
    Return __FileReadAll($s_file)
EndFunc

Func _XMLStartSection(ByRef $s_xml, $s_secname)
    $s_xml = $s_xml & "<" & $s_secname & ">" & @CRLF
EndFunc

Func _XMLEndSection(ByRef $s_xml, $s_secname)
    $s_xml = $s_xml & "</" & $s_secname & ">" & @CRLF
EndFunc

;############################
;#     Helper Functions     #
;############################

Func __FileReadAll($s_file)
    If not FileExists($s_file) Then
        SetError(1)
        Return ""
    EndIf
    Return FileRead($s_file, FileGetSize($s_file))
EndFunc

Func __Test($b_Test, $v_True = 1, $v_False = 0)
    If $b_Test Then Return $v_True
    Return $v_False
EndFunc

Func __StringFindOccurances($sStr1, $sStr2)
    For $i = 1 to StringLen($sStr1)
        If not StringInStr($sStr1, $sStr2, 1, $i) Then ExitLoop
    Next
    Return $i
EndFunc

Func __StringParse($sz_str, $sz_before, $sz_after, $i_occurance = 0)
    Local $sz_sp1 = StringSplit($sz_str, $sz_before, 1)
    If $i_occurance < 0 or $i_occurance > $sz_sp1[0] Then
        SetError(1)
        Return ""
    EndIf
    Local $sz_sp2
    If $i_occurance = 0 Then
        $sz_sp2 = StringSplit($sz_sp1[$sz_sp1[0]], $sz_after, 1)
    Else
        $sz_sp2 = StringSplit($sz_sp1[$i_occurance + 1], $sz_after, 1)
    EndIf
    Return $sz_sp2[1]
EndFunc  ;==>_StringParse()