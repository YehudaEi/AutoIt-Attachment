#include-once
#include <WindowsConstants.au3>
#Include <SendMessage.au3>

;http://msdn.microsoft.com/en-us/library/windows/desktop/ff486114(v=VS.85).aspx

;*******************************************************************************************************
;   ����14����������֧��Window 2000������ϵͳ                                                          ;
;	_GUICtrlUpdown_GetRange($hUpdown [, $Dimension]) .............	����16λ�����½�                   ;
;	_GUICtrlUpdown_SetRange($hUpdown, $Min, $Max) .................	����16λ�����½�                   ;
;	_GUICtrlUpdown_GetRange32($hUpdown [, $Dimension]) ............ ����32λ���½�                     ;
;	_GUICtrlUpdown_SetRange32($hUpdown, $Min, $Max) ............... ����32λ���½�                     ;
;	_GUICtrlUpdown_GetPos($hUpdown) ............................... ���ع�����Edit/Input�ؼ��ĵ�ǰֵ   ;
;	_GUICtrlUpdown_SetPos($hUpdown, $Num) ......................... ���ù�����Edit/Input�ؼ��ĵ�ǰֵ   ;
;	_GUICtrlUpdown_GetBuddy($hUpdown) ............................. ���ع�����Edit/Input�ؼ��ľ��     ;
;	_GUICtrlUpdown_SetBuddy($hUpdown, $hNewEdit) .................. ���ù�����Edit/Input�ؼ��ľ��     ;
;	_GUICtrlUpdown_GetBase($hUpdown) .............................. ���ص�ǰ������10���ƻ���16����     ;
;	_GUICtrlUpdown_SetBase($hUpdown, $Radix = 10) ................. ���õ�ǰ������10���ƻ���16����     ;
;	_GUICtrlUpdown_GetAccel($hUpdown) ............................. �������ʱ仯��Ϣ                   ;
;	_GUICtrlUpdown_SetAccel($hUpdown [, $aUDACCEL = ""]) .......... �������ʱ仯��Ϣ                   ;
;	_GUICtrlUpdown_GetUnicodeFormat($hUpdown) ..................... ����Unicode�ַ���ʽ��־            ;
;	_GUICtrlUpdown_SetUnicodeFormat($hUpdown [, $Unicode = True]).. ����Unicode�ַ���ʽ��־            ;
;*******************************************************************************************************

Global Const $UDM_SETRANGE 		   = $WM_USER + 101
Global Const $UDM_GETRANGE 		   = $WM_USER + 102
Global Const $UDM_SETPOS 		   = $WM_USER + 103
Global Const $UDM_GETPOS 		   = $WM_USER + 104
Global Const $UDM_SETBUDDY 		   = $WM_USER + 105
Global Const $UDM_GETBUDDY 		   = $WM_USER + 106
Global Const $UDM_SETACCEL 		   = $WM_USER + 107
Global Const $UDM_GETACCEL 		   = $WM_USER + 108
Global Const $UDM_SETBASE 		   = $WM_USER + 109
Global Const $UDM_GETBASE 		   = $WM_USER + 110
Global Const $UDM_SETRANGE32	   = $WM_USER + 111
Global Const $UDM_GETRANGE32 	   = $WM_USER + 112
Global Const $UDM_SETUNICODEFORMAT = $CCM_SETUNICODEFORMAT
Global Const $UDM_GETUNICODEFORMAT = $CCM_GETUNICODEFORMAT

;===============================================================================
; _GUICtrlUpdown_GetRange($hUpdown [, $Dimension])
;
; ˵�������Updown�ؼ���16λ��Χ����Сֵ�����ֵ��
; ������$hUpdown - Updown�Ŀؼ�ID���߾��
;		$Dimension - ά��
;					�ޣ�����һ������Updown�ؼ���16λ��Χ����Сֵ�����ֵ��2Ԫ��һά����array: $array[0] = ��Сֵ, $array[1] = ���ֵ
;					0������Updown�ؼ���16λ��Χ����Сֵ
;					1������Updown�ؼ���16λ��Χ�����ֵ
; ���أ��ɹ����ݲ���$Dimension�������η�����Ԫ���������С/��ֵ��ʧ��������@errorΪ-1
; ע�⣺
; ���ߣ�happytc
; �汾��1.0.0
;===============================================================================
Func _GUICtrlUpdown_GetRange($hUpdown, $Dimension = "")
	Local $iRet, $array[2]
		
	If IsHWnd($hUpdown) Then
		$iRet = _SendMessage($hUpdown, $UDM_GETRANGE, 0, 0)
		If @error Then
			SetError(-1)
			Return
		EndIf
	Else
		$iRet = GUICtrlSendMsg($hUpdown, $UDM_GETRANGE, 0, 0)
		If @error Then
			SetError(-1)
			Return
		EndIf
	EndIf
	
	$array[0] = _HiWord($iRet)
	$array[1] = _LoWord($iRet)
	
	If @NumParams == 1 Then
		Return $array
	ElseIf $Dimension == 0 Then
		Return $array[0]
	ElseIf $Dimension == 1 Then
		Return $array[1]
	Else
		SetError(-1)
	EndIf
EndFunc



;===============================================================================
; _GUICtrlUpdown_SetRange($hUpdown, $Min, $Max)
;
; ˵��������Updown�ؼ��ķ�Χ����Сֵ�����ֵ����GUICtrlSetLimit()����Ч��һ��
; ������$hUpdown - Updown�Ŀؼ�ID���߾��
;		$Min - Updown�ؼ���Χ����Сֵ������������
;		$Max - Updown�ؼ���Χ�����ֵ������������
; ���أ��ɹ�����ֵΪ1��ʧ�ܷ���ֵΪ0
; ע�⣺����$Max�������$Min�����ҷ�Χ�ڣ�-32767 ~ 32767��Ҫ������Χ���μ�_GUICtrlUpdown_SetRange32����
; ���ߣ�happytc
; �汾��1.0.0
;===============================================================================
Func _GUICtrlUpdown_SetRange($hUpdown, $Min, $Max)
	If Int($Min) == 0 Or Int($Max) == 0 Or $Min > $Max Then Return 0
	Local $iDWORD = _MakeLong($Max, $Min)
		
	If IsHWnd($hUpdown) Then
		_SendMessage($hUpdown, $UDM_SETRANGE, 0, $iDWORD)
		If @error Then Return 0
	Else
		GUICtrlSendMsg($hUpdown, $UDM_SETRANGE, 0, $iDWORD)
		If @error Then Return 0
	EndIf
	
	Return 1
EndFunc



;===============================================================================
; _GUICtrlUpdown_GetRange32($hUpdown [, $Dimension])
;
; ˵�������Updown�ؼ���32λ�ķ�Χ����Сֵ�����ֵ��
; ������$hUpdown - Updown�Ŀؼ�ID���߾��
;		$Dimension - ά��
;					�ޣ�����һ������Updown�ؼ��ķ�Χ����Сֵ�����ֵ��2Ԫ��һά����array: $array[0] = ��Сֵ, $array[1] = ���ֵ
;					0������Updown�ؼ���32λ��Χ����Сֵ
;					1������Updown�ؼ���32λ��Χ�����ֵ
; ���أ��ɹ����ݲ���$Dimension�������η�����Ԫ���������С/��ֵ��ʧ��������@errorΪ-1
; ע�⣺
; ���ߣ�happytc
; �汾��1.0.0
;===============================================================================
Func _GUICtrlUpdown_GetRange32($hUpdown, $Dimension = "")
	Local $Str, $StructW, $StructL, $array[2]
	
	$Str = "int;"
	$StructW = DllStructCreate($Str)
	$StructL = DllStructCreate($Str)
	
	If IsHWnd($hUpdown) Then
		_SendMessage($hUpdown, $UDM_GETRANGE32, DllStructGetPtr($StructW), DllStructGetPtr($StructL))
		If @error Then 
			SetError(-1)
			Return
		EndIf
	Else
		GUICtrlSendMsg($hUpdown, $UDM_GETRANGE32, DllStructGetPtr($StructW), DllStructGetPtr($StructL))
		If @error Then 
			SetError(-1)
			Return
		EndIf
	EndIf
	
	$array[0] = DllStructGetData($StructW, 1)
	$array[1] = DllStructGetData($StructL, 1)
	
	If @NumParams == 1 Then
		Return $array
	ElseIf $Dimension == 0 Then
		Return $array[0]
	ElseIf $Dimension == 1 Then
		Return $array[1]
	Else
		SetError(-1)
	EndIf
EndFunc



;===============================================================================
; _GUICtrlUpdown_SetRange32($hUpdown, $Min, $Max)
;
; ˵��������Updown�ؼ��ķ�Χ����Сֵ�����ֵ����GUICtrlSetLimit()����Ч��һ��
; ������$hUpdown - Updown�Ŀؼ�ID���߾��
;		$Min - Updown�ؼ���Χ����Сֵ������������
;		$Max - Updown�ؼ���Χ�����ֵ������������
; ���أ��ɹ�����ֵΪ1��ʧ�ܷ���ֵΪ0
; ע�⣺����$Max�������$Min�����ҷ�Χ�ڣ�-2147483647 ~ 2147483647
; ���ߣ�happytc
; �汾��1.0.0
;===============================================================================
Func _GUICtrlUpdown_SetRange32($hUpdown, $Min, $Max)
	If Int($Min) == 0 Or Int($Max) == 0 Or $Min > $Max Then Return 0
		
	If IsHWnd($hUpdown) Then
		_SendMessage($hUpdown, $UDM_SETRANGE32, $Min, $Max)
		If @error Then Return 0
	Else
		GUICtrlSendMsg($hUpdown, $UDM_SETRANGE32, $Min, $Max)
		If @error Then Return 0
	EndIf
	
	Return 1
EndFunc



;===============================================================================
; _GUICtrlUpdown_GetPos($hUpdown)
;
; ˵�������Updown�ؼ�������Edit�ĵ�ǰֵ
; ������$hUpdown - Updown�Ŀؼ�ID���߾��   
; ���أ��ɹ�����Updown�ؼ�������Edit�ĵ�ǰֵ��ʧ�ܷ���0
; ע�⣺��Updown�ؼ�û�й�����Edit����Edit��ǰֵ��Updown�ؼ���Χֵ�⣬�������ش���ֵ
; ���ߣ�happytc
; �汾��1.0.0
;===============================================================================
Func _GUICtrlUpdown_GetPos($hUpdown)
	If IsHWnd($hUpdown) Then
		Return _SendMessage($hUpdown, $UDM_GETPOS, 0, 0)
	Else
		Return GUICtrlSendMsg($hUpdown, $UDM_GETPOS, 0, 0)
	EndIf
EndFunc



;===============================================================================
; _GUICtrlUpdown_SetPos($hUpdown, $Num)
;
; ˵��������Updown�ؼ�������Edit�ĵ�ǰֵ
; ������$hUpdown - Updown�Ŀؼ�ID���߾��  
;		$Num - Ҫ���õ�Updown�ؼ�������Edit�ĵ�ǰֵ
; ���أ��ɹ�����Updown�ؼ�������Edit����ǰ��ֵ��ʧ�ܷ���0
; ע�⣺�����ֵ����Updown�ؼ���Χ�������Զ�����һ���������Чֵ����$Num��������������0������@errorΪ-1
; ���ߣ�happytc
; �汾��1.0.0
;===============================================================================
Func _GUICtrlUpdown_SetPos($hUpdown, $Num)
	If Not Int($Num) Then
		SetError(-1)
		Return 0
	EndIf 
	
	If IsHWnd($hUpdown) Then
		Return _SendMessage($hUpdown, $UDM_SETPOS, 0, $Num)
	Else
		Return GUICtrlSendMsg($hUpdown, $UDM_SETPOS, 0, $Num)
	EndIf
EndFunc



;===============================================================================
; _GUICtrlUpdown_GetBuddy($hUpdown)
;
; ˵�������Updown�ؼ�������Edit���ھ��
; ������$hUpdown - Updown�Ŀؼ�ID���߾��   
; ���أ��ɹ�����Updown�ؼ�������Edit���ھ����ʧ�ܷ���0
; ע�⣺
; ���ߣ�happytc
; �汾��1.0.0
;===============================================================================
Func _GUICtrlUpdown_GetBuddy($hUpdown)
	If IsHWnd($hUpdown) Then
		Return _SendMessage($hUpdown, $UDM_GETBUDDY, 0, 0)
	Else
		Return GUICtrlSendMsg($hUpdown, $UDM_GETBUDDY, 0, 0)
	EndIf
EndFunc



;===============================================================================
; _GUICtrlUpdown_SetBuddy($hUpdown, $hNewEdit)
;
; ˵����ΪUpdown�ؼ��������µ�Edit���ھ��
; ������$hUpdown - Updown�Ŀؼ�ID���߾�� 
;		$hNewEdit - �µ�Edit���ھ��
; ���أ��ɹ�����Updown�ؼ���ǰ�Ĺ���Edit���ھ����ʧ�ܷ���0
; ע�⣺��$hNewEdit���Ǿ���������ʧ�ܣ�����0��������@errorΪ-1
; ���ߣ�happytc
; �汾��1.0.0
;===============================================================================
Func _GUICtrlUpdown_SetBuddy($hUpdown, $hNewEdit)
	If Not IsHWnd($hNewEdit) Then
		SetError(-1)
		Return 0
	EndIf
	
	If IsHWnd($hUpdown) Then
		Return _SendMessage($hUpdown, $UDM_SETBUDDY, $hNewEdit, 0)
	Else
		Return GUICtrlSendMsg($hUpdown, $UDM_SETBUDDY, $hNewEdit, 0)
	EndIf
EndFunc



;===============================================================================
; _GUICtrlUpdown_GetBase($hUpdown)
;
; ˵�������Updown�ؼ��ĵ�ǰ������10���ƻ���16����
; ������$hUpdown - Updown�Ŀؼ�ID���߾��   
; ���أ��ɹ����ص�ǰ�Ļ���ֵ��10��16����ʧ�ܷ���0
; ע�⣺
; ���ߣ�happytc
; �汾��1.0.0
;===============================================================================
Func _GUICtrlUpdown_GetBase($hUpdown)
	If IsHWnd($hUpdown) Then
		Return _SendMessage($hUpdown, $UDM_GETBASE, 0, 0)
	Else
		Return GUICtrlSendMsg($hUpdown, $UDM_GETBASE, 0, 0)
	EndIf
EndFunc



;===============================================================================
; _GUICtrlUpdown_SetBase($hUpdown [, $Radix = 10])
;
; ˵��������Updown�ؼ��ĵ�ǰ������10���ƻ���16����
; ������$hUpdown - Updown�Ŀؼ�ID���߾��   
; ���أ��ɹ���������ǰ�Ļ���ֵ��10����16����ʧ�ܷ���0
; ע�⣺�˻���ֵ�����������ڣ�Buddy Window����ʾ��������10���ƻ���16����
; ���ߣ�happytc
; �汾��1.0.0
;===============================================================================
Func _GUICtrlUpdown_SetBase($hUpdown, $Radix = 10)
	If IsHWnd($hUpdown) Then
		Return _SendMessage($hUpdown, $UDM_SETBASE, $Radix, 0)
	Else
		Return GUICtrlSendMsg($hUpdown, $UDM_SETBASE, $Radix, 0)
	EndIf
EndFunc



;===============================================================================
; _GUICtrlUpdown_GetAccel($hUpdown)
;
; ˵�������Updown�ؼ�����ֵ�仯������Ϣ
; ������$hUpdown - Updown�Ŀؼ�ID���߾��   
; ���أ��ɹ�����һ������������Ϣ��2ά���飬ʧ�ܷ���0
;		array[0][0] - �������ʱ仯�ĸ���
;		array[1][0], array[1][1] - ��һ�����ʱ仯���ã�array[1][0]��ʾʱ��������array[1][1]��ʾ������������ֵ
;		array[2][0], array[2][1] - �ڶ������ʱ仯���ã�array[2][0]��ʾʱ��������array[2][1]��ʾ������������ֵ
;		          .....
;		array[n][0], array[n][1] - ��n�����ʱ仯���ã�array[n][0]��ʾʱ��������array[n][1]��ʾ������������ֵ
; ע�⣺
; ���ߣ�happytc
; �汾��1.0.0
;===============================================================================
Func _GUICtrlUpdown_GetAccel($hUpdown)	
	Local $array[1][2], $Str, $SizeArr, $AccelStruct, $iCount
	
	$Str = "uint;uint"
	$AccelStruct = DllStructCreate($Str)
	
	If Not IsHWnd($hUpdown) Then $hUpdown = GUICtrlGetHandle($hUpdown)
    
	If IsHWnd($hUpdown) Then
        $iCount = _SendMessage($hUpdown, $UDM_GETACCEL, 1, DllStructGetPtr($AccelStruct))
		If @error Then
			SetError(-1)
			Return 0
		EndIf
    EndIf

	If IsInt($iCount) Then
		if $iCount > 1 Then
			For $i = 2 To $iCount
				$Str &= ";uint;uint"
			Next
		EndIf
		
		$AccelStruct = DllStructCreate($Str)
		
		_SendMessage($hUpdown, $UDM_GETACCEL, $iCount, DllStructGetPtr($AccelStruct))
		
		ReDim $array[$iCount + 1][2]
		$array[0][0] = $iCount
		For $i = 1 To $iCount
			$array[$i][0] = DllStructGetData($AccelStruct, $i * 2 - 1)
			$array[$i][1] = DllStructGetData($AccelStruct, $i * 2)
		Next
		
		Return $array
	EndIf

EndFunc



;===============================================================================
; _GUICtrlUpdown_SetAccel($hUpdown [, $aUDACCEL = ""])
;
; ˵��������Updown�ؼ�����ֵ�仯����
; ������$hUpdown - Updown�Ŀؼ�ID���߾��
;		$aUDACCEL - һ����ά���飬��WindowsϵͳĬ��ֵΪ��$aUDACCEL[3][2] = [[0, 1], [2, 5], [5, 20]]
;					$aUDACCEL[0][0] = 0, $aUDACCEL[0][1] = 1 ����סUpdown�ؼ�0�����ֵ����/����1
;					$aUDACCEL[1][0] = 2, $aUDACCEL[1][1] = 5 ����סUpdown�ؼ�2�����ֵ����/����5
;					$aUDACCEL[2][0] = 5, $aUDACCEL[2][1] = 20 ����סUpdown�ؼ�5�����ֵ����/����20    
; ���أ��ɹ�����1��ʧ�ܷ���0
; ע�⣺_GUICtrlUpdown_SetAccel($hUpdown)��ʾ��Updown�ؼ��仯����������ΪWindowsĬ��ֵ
;		�������鶨��Ϊ��$aUDACCEL[1][2] =[[0, 5]]�����ʾû�м����ʣ���ֵ����/����һֱ����5
;		$aUDACCEL�����Ƕ�ά���飬���򷵻�0��������@errorΪ-1
;		$aUDACCEL�����е�ÿһ��ֵ��������Ȼ������0��1��2...�����򷵻�0��������@errorΪ-2
;		$aUDACCEL�����еĵ�һάʱ����ֵ��$aUDACCEL[$i][0]�����Ǵ�С�������ӵģ�������ģ�0��2��5�����򷵻�0��������@errorΪ-3
;		��$aUDACCEL����һ�����飬�򷵻�0��������@errorΪ-4
; ���ߣ�happytc
; �汾��1.0.0
;===============================================================================
Func _GUICtrlUpdown_SetAccel($hUpdown, $aUDACCEL = "")
	If @NumParams == 1 Then 
		Local $aSecInc[3][2] = [[0, 1], [2, 5], [5, 20]]
	ElseIf @NumParams == 2 And IsArray($aUDACCEL) Then
		If UBound($aUDACCEL, 2) <> 2 Then
			SetError(-1)
			Return 0
		Else
			Local $aSecInc = $aUDACCEL
		EndIf
	Else
		SetError(-4)
		Return 0
	EndIf
	
	For $i = 0 To UBound($aSecInc, 1) - 1
		If StringIsInt($aSecInc[$i][0]) = 0 Or StringIsInt($aSecInc[$i][1]) = 0 Or  $aSecInc[$i][0] < 0 Or $aSecInc[$i][1] < 0 Then
			SetError(-2)
			Return 0
		EndIf
		If $i >= 1 Then
			If $aSecInc[$i][0] <= $aSecInc[$i - 1][0] Then
				SetError(-3)
				Return 0
			EndIf
		EndIf
	Next	
	
	Local $Str, $SizeArr, $AccelStruct, $aRet
	
	$Str = "uint;uint"
	$SizeArr = UBound($aSecInc, 1)
    If $SizeArr > 1 Then
		For $i = 1 To $SizeArr - 1
			$Str &= ";uint;uint"
		Next
	EndIf
	
	$AccelStruct = DllStructCreate($Str)
	
	For $i = 0 To $SizeArr - 1
		DllStructSetData($AccelStruct, ($i + 1) * 2 - 1, $aSecInc[$i][0])
		DllStructSetData($AccelStruct, ($i + 1) * 2, $aSecInc[$i][1])
	Next
	
    If IsHWnd($hUpdown) Then
        $aRet = _SendMessage($hUpdown, $UDM_SETACCEL, $SizeArr, DllStructGetPtr($AccelStruct))
		If $aRet Then
			Return 1
		Else
			Return 0
		EndIf
    Else
        $aRet = GUICtrlSendMsg($hUpdown, $UDM_SETACCEL, $SizeArr, DllStructGetPtr($AccelStruct))
		Return $aRet
    EndIf
EndFunc



;===============================================================================
; _GUICtrlUpdown_GetUnicodeFormat($hUpdown)
;
; ˵������ȡUpdown�ؼ���Unicode�ַ���ʽ��־
; ������$hUpdown - Updown�Ŀؼ�ID���߾��   
; ���أ��������ֵΪ��0����ؼ�������Unicode�ַ����������ֵΪ0����ؼ�������ANSI�ַ�
; ע�⣺
; ���ߣ�happytc
; �汾��1.0.0
;===============================================================================
Func _GUICtrlUpdown_GetUnicodeFormat($hUpdown)
	If IsHWnd($hUpdown) Then
		Return _SendMessage($hUpdown, $UDM_GETUNICODEFORMAT, 0, 0)
	Else
		Return GUICtrlSendMsg($hUpdown, $UDM_GETUNICODEFORMAT, 0, 0)
	EndIf
EndFunc



;===============================================================================
; _GUICtrlUpdown_SetUnicodeFormat($hUpdown [, $Unicode = True])
;
; ˵��������Updown�ؼ���Unicode�ַ���ʽ��־
; ������$hUpdown - Updown�Ŀؼ�ID���߾��   
; ���أ�����ֵ��һ��Updown�ؼ�ʹ�õ�Unicode�ַ���ʽ��־
; ע�⣺�����ڿؼ���������ʱ�ı��ַ������������´����ؼ�
; ���ߣ�happytc
; �汾��1.0.0
;===============================================================================
Func _GUICtrlUpdown_SetUnicodeFormat($hUpdown, $Unicode = True)
	If IsHWnd($hUpdown) Then
		Return _SendMessage($hUpdown, $UDM_SETUNICODEFORMAT, $Unicode, 0)
	Else
		Return GUICtrlSendMsg($hUpdown, $UDM_SETUNICODEFORMAT, $Unicode, 0)
	EndIf
EndFunc



; ===================================================================
; _MakeLong($iLoWord, $iHiWord)
;
; ˵�����ϲ�����16λֵ��һ��32λֵ
; ������$iLoWord - ����16λ��
;    	$iHiWord - ����16λ��
; ���أ�һ��32λֵ��������16λֵ�ϲ����ɣ�
; ע�⣺�ֱ�õ���λ�͵�λ��ֵ
; ���ߣ�happytc
; �汾��1.0.0
; ===================================================================
Func _MakeLong($iLoWord, $iHiWord)
    Return BitOR(BitAnd($iLoWord, 0xFFFF), BitShift(BitAnd($iHiWord, 0xFFFF), -16))
EndFunc



; ===================================================================
; _HiWord($iDWORD)
;
; ˵������32λֵ�еõ�����16λֵ
; ������$iDWORD - 32λ��ֵ�����������_MakeLong()������ã�
; ���أ�32λ��ֵ�еĸ���16λ��ֵ
; ע�⣺
; ���ߣ�happytc
; �汾��1.0.0
; ===================================================================
Func _HiWord($iDWORD)
    Return BitShift($iDWORD, 16)
EndFunc



; ===================================================================
; _LoWord($iDWORD)
;
; ˵������32λֵ�еõ�����16λֵ
; ������$iDWORD - 32λ��ֵ�����������_MakeLong()������ã�
; ���أ�32λ��ֵ�еĵ���16λ��ֵ
; ע�⣺
; ���ߣ�happytc
; �汾��1.0.0
; ===================================================================
Func _LoWord($iDWORD)
    Return BitAnd($iDWORD, 0xFFFF)
EndFunc