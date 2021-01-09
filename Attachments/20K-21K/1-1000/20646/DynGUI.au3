;--- Dynamic-Window UDF ---;
Global $_DynGUId=0
Func _DynGUI_Closed($GUI)
	$ident=_DynGUI_Identifier($GUI)
	$info=_DynGUI_Info(0)
	$info[0]=_DynGUI_InfoVN($GUI)
	_DynGUI_InfoSet($info)
	_DynGUI_SetIdentifier($ident,'')
EndFunc
Func _DynGUI_Set($GUI,$ident='')
	Global $_DynGUId=$GUI
	$info=_DynGUI_Info($GUI)
	$info[1]=0
	$info[2]=''
	_DynGUI_InfoSet($info)
	If $ident<>'' Then
		_DynGUI_SetIdentifier($ident,$GUI)
	EndIf
	Return $GUI
EndFunc
Func _DynGUI_CtrlAdd($Ctrl,$GUI=-1)
	Global $_DynGUId
	$info=_DynGUI_Info($GUI)
	$info[1]+=1
	$info[2]&=String($Ctrl)&','
	_DynGUI_InfoSet($info)
	Return $Ctrl
EndFunc
Func _DynGUI_Ctrls($GUI=-1)
	$info=_DynGUI_Info($GUI)
	Return $info[1]
EndFunc
Func _DynGUI_Ctrl($index,$GUI=-1)
	$info=_DynGUI_Info($GUI)
	If $index>$info[1] Or $index<1 Then Return $info[1]
	$ctrls=StringSplit($info[2],',')
	Return $ctrls[$index]
EndFunc
Func _DynGUI_SetIdentifier($text, $GUI)
	Assign(_DynGUI_IdentVN($text),$GUI,2)
	$info=_DynGUI_Info($GUI)
	$info[3]=$text
	_DynGUI_InfoSet($info)
EndFunc
Func _DynGUI_Identifier($GUI=-1)
	$info=_DynGUI_Info($GUI)
	Return $info[3]
EndFunc
Func _DynGUI_GUI($identifier)
	ConsoleWrite(_DynGUI_IdentVN($identifier)&'='&Eval(_DynGUI_IdentVN($identifier))&@CRLF)
	Return Eval(_DynGUI_IdentVN($identifier))
EndFunc
Func _DynGUI_IdentVN($identifier)
	Return '_DynGUIi_'&StringMid(String(StringToBinary($identifier,1)),3)
EndFunc
Func _DynGUI_Info($GUI=-1)
	Local $info[4], $dat
	$info[0]=_DynGUI_InfoVN($GUI)
	$info[1]=0
	$info[2]=''
	$info[3]=''
	If $GUI<>0 And IsDeclared($info[0]) Then
		$dat=Eval($info[0])
		$dat=StringSplit($dat,';')
		$info[1]=$dat[1]
		$info[2]=$dat[2]
		$info[3]=$dat[3]
	EndIf
	Return $info
EndFunc
Func _DynGUI_InfoVN($GUI=-1)
	If $GUI=-1 Then $GUI=$_DynGUId
	Return '_DynGUI_'&String($GUI)
EndFunc
Func _DynGUI_InfoSet($info)
	Assign($info[0],$info[1]&';'&$info[2]&';'&$info[3],2)
EndFunc