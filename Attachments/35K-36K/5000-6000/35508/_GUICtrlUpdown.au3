#include-once
#include <WindowsConstants.au3>
#Include <SendMessage.au3>

;http://msdn.microsoft.com/en-us/library/windows/desktop/ff486114(v=VS.85).aspx

;*******************************************************************************************************
;   以下14个函数都仅支持Window 2000及以上系统                                                          ;
;	_GUICtrlUpdown_GetRange($hUpdown [, $Dimension]) .............	返回16位的上下界                   ;
;	_GUICtrlUpdown_SetRange($hUpdown, $Min, $Max) .................	设置16位的上下界                   ;
;	_GUICtrlUpdown_GetRange32($hUpdown [, $Dimension]) ............ 返回32位上下界                     ;
;	_GUICtrlUpdown_SetRange32($hUpdown, $Min, $Max) ............... 设置32位上下界                     ;
;	_GUICtrlUpdown_GetPos($hUpdown) ............................... 返回关联的Edit/Input控件的当前值   ;
;	_GUICtrlUpdown_SetPos($hUpdown, $Num) ......................... 设置关联的Edit/Input控件的当前值   ;
;	_GUICtrlUpdown_GetBuddy($hUpdown) ............................. 返回关联的Edit/Input控件的句柄     ;
;	_GUICtrlUpdown_SetBuddy($hUpdown, $hNewEdit) .................. 设置关联的Edit/Input控件的句柄     ;
;	_GUICtrlUpdown_GetBase($hUpdown) .............................. 返回当前基数，10进制还是16进制     ;
;	_GUICtrlUpdown_SetBase($hUpdown, $Radix = 10) ................. 设置当前基数，10进制还是16进制     ;
;	_GUICtrlUpdown_GetAccel($hUpdown) ............................. 返回速率变化信息                   ;
;	_GUICtrlUpdown_SetAccel($hUpdown [, $aUDACCEL = ""]) .......... 设置速率变化信息                   ;
;	_GUICtrlUpdown_GetUnicodeFormat($hUpdown) ..................... 返回Unicode字符格式标志            ;
;	_GUICtrlUpdown_SetUnicodeFormat($hUpdown [, $Unicode = True]).. 设置Unicode字符格式标志            ;
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
; 说明：获得Updown控件的16位范围（最小值和最大值）
; 参数：$hUpdown - Updown的控件ID或者句柄
;		$Dimension - 维数
;					无：返回一个包含Updown控件的16位范围的最小值和最大值的2元素一维数组array: $array[0] = 最小值, $array[1] = 最大值
;					0：返回Updown控件的16位范围的最小值
;					1：返回Updown控件的16位范围的最大值
; 返回：成功根据参数$Dimension设置情形返回两元素数组或最小/大值，失败则设置@error为-1
; 注意：
; 作者：happytc
; 版本：1.0.0
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
; 说明：设置Updown控件的范围（最小值和最大值）跟GUICtrlSetLimit()函数效果一样
; 参数：$hUpdown - Updown的控件ID或者句柄
;		$Min - Updown控件范围的最小值，必须是整数
;		$Max - Updown控件范围的最大值，必须是整数
; 返回：成功返回值为1，失败返回值为0
; 注意：参数$Max必须大于$Min，并且范围在：-32767 ~ 32767，要想扩大范围，参见_GUICtrlUpdown_SetRange32函数
; 作者：happytc
; 版本：1.0.0
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
; 说明：获得Updown控件的32位的范围（最小值和最大值）
; 参数：$hUpdown - Updown的控件ID或者句柄
;		$Dimension - 维数
;					无：返回一个包含Updown控件的范围的最小值和最大值的2元素一维数组array: $array[0] = 最小值, $array[1] = 最大值
;					0：返回Updown控件的32位范围的最小值
;					1：返回Updown控件的32位范围的最大值
; 返回：成功根据参数$Dimension设置情形返回两元素数组或最小/大值，失败则设置@error为-1
; 注意：
; 作者：happytc
; 版本：1.0.0
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
; 说明：设置Updown控件的范围（最小值和最大值）跟GUICtrlSetLimit()函数效果一样
; 参数：$hUpdown - Updown的控件ID或者句柄
;		$Min - Updown控件范围的最小值，必须是整数
;		$Max - Updown控件范围的最大值，必须是整数
; 返回：成功返回值为1，失败返回值为0
; 注意：参数$Max必须大于$Min，并且范围在：-2147483647 ~ 2147483647
; 作者：happytc
; 版本：1.0.0
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
; 说明：获得Updown控件关联的Edit的当前值
; 参数：$hUpdown - Updown的控件ID或者句柄   
; 返回：成功返回Updown控件关联的Edit的当前值，失败返回0
; 注意：若Updown控件没有关联的Edit或者Edit当前值在Updown控件范围值外，都将返回错误值
; 作者：happytc
; 版本：1.0.0
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
; 说明：设置Updown控件关联的Edit的当前值
; 参数：$hUpdown - Updown的控件ID或者句柄  
;		$Num - 要设置的Updown控件关联的Edit的当前值
; 返回：成功返回Updown控件关联的Edit的以前的值，失败返回0
; 注意：若设的值超出Updown控件范围，将会自动设置一个最靠近的有效值；若$Num不是整数，返回0，设置@error为-1
; 作者：happytc
; 版本：1.0.0
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
; 说明：获得Updown控件关联的Edit窗口句柄
; 参数：$hUpdown - Updown的控件ID或者句柄   
; 返回：成功返回Updown控件关联的Edit窗口句柄，失败返回0
; 注意：
; 作者：happytc
; 版本：1.0.0
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
; 说明：为Updown控件关联到新的Edit窗口句柄
; 参数：$hUpdown - Updown的控件ID或者句柄 
;		$hNewEdit - 新的Edit窗口句柄
; 返回：成功返回Updown控件以前的关联Edit窗口句柄，失败返回0
; 注意：若$hNewEdit不是句柄，则关联失败，返回0，并设置@error为-1
; 作者：happytc
; 版本：1.0.0
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
; 说明：获得Updown控件的当前基数，10进制还是16进制
; 参数：$hUpdown - Updown的控件ID或者句柄   
; 返回：成功返回当前的基数值（10或16），失败返回0
; 注意：
; 作者：happytc
; 版本：1.0.0
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
; 说明：设置Updown控件的当前基数，10进制还是16进制
; 参数：$hUpdown - Updown的控件ID或者句柄   
; 返回：成功返回设置前的基数值（10或者16），失败返回0
; 注意：此基数值决定关联窗口（Buddy Window）显示的数字是10进制还是16进制
; 作者：happytc
; 版本：1.0.0
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
; 说明：获得Updown控件的数值变化速率信息
; 参数：$hUpdown - Updown的控件ID或者句柄   
; 返回：成功返回一个含有下列信息的2维数组，失败返回0
;		array[0][0] - 设置速率变化的个数
;		array[1][0], array[1][1] - 第一组速率变化设置，array[1][0]表示时间秒数，array[1][1]表示该秒数后速率值
;		array[2][0], array[2][1] - 第二组速率变化设置，array[2][0]表示时间秒数，array[2][1]表示该秒数后速率值
;		          .....
;		array[n][0], array[n][1] - 第n组速率变化设置，array[n][0]表示时间秒数，array[n][1]表示该秒数后速率值
; 注意：
; 作者：happytc
; 版本：1.0.0
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
; 说明：设置Updown控件的数值变化速率
; 参数：$hUpdown - Updown的控件ID或者句柄
;		$aUDACCEL - 一个二维数组，其Windows系统默认值为：$aUDACCEL[3][2] = [[0, 1], [2, 5], [5, 20]]
;					$aUDACCEL[0][0] = 0, $aUDACCEL[0][1] = 1 代表按住Updown控件0秒后，其值增加/减少1
;					$aUDACCEL[1][0] = 2, $aUDACCEL[1][1] = 5 代表按住Updown控件2秒后，其值增加/减少5
;					$aUDACCEL[2][0] = 5, $aUDACCEL[2][1] = 20 代表按住Updown控件5秒后，其值增加/减少20    
; 返回：成功返回1，失败返回0
; 注意：_GUICtrlUpdown_SetAccel($hUpdown)表示把Updown控件变化速率重新设为Windows默认值
;		若把数组定义为：$aUDACCEL[1][2] =[[0, 5]]，则表示没有加速率，其值增加/减少一直保持5
;		$aUDACCEL必须是二维数组，否则返回0，并设置@error为-1
;		$aUDACCEL数组中的每一个值必须是自然数，即0，1，2...，否则返回0，并设置@error为-2
;		$aUDACCEL数组中的第一维时间数值：$aUDACCEL[$i][0]必须是从小到大增加的，如上面的：0，2，5，否则返回0，并设置@error为-3
;		若$aUDACCEL不是一个数组，则返回0，并设置@error为-4
; 作者：happytc
; 版本：1.0.0
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
; 说明：获取Updown控件的Unicode字符格式标志
; 参数：$hUpdown - Updown的控件ID或者句柄   
; 返回：如果返回值为非0，则控件正在用Unicode字符；如果返回值为0，则控件正在用ANSI字符
; 注意：
; 作者：happytc
; 版本：1.0.0
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
; 说明：设置Updown控件的Unicode字符格式标志
; 参数：$hUpdown - Updown的控件ID或者句柄   
; 返回：返回值上一次Updown控件使用的Unicode字符格式标志
; 注意：可以在控件正在运行时改变字符集，不用重新创建控件
; 作者：happytc
; 版本：1.0.0
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
; 说明：合并两个16位值到一个32位值
; 参数：$iLoWord - 低序16位数
;    	$iHiWord - 高序16位数
; 返回：一个32位值（由两个16位值合并而成）
; 注意：分别得到高位和低位数值
; 作者：happytc
; 版本：1.0.0
; ===================================================================
Func _MakeLong($iLoWord, $iHiWord)
    Return BitOR(BitAnd($iLoWord, 0xFFFF), BitShift(BitAnd($iHiWord, 0xFFFF), -16))
EndFunc



; ===================================================================
; _HiWord($iDWORD)
;
; 说明：从32位值中得到高序16位值
; 参数：$iDWORD - 32位数值（可由上面的_MakeLong()函数获得）
; 返回：32位数值中的高序16位数值
; 注意：
; 作者：happytc
; 版本：1.0.0
; ===================================================================
Func _HiWord($iDWORD)
    Return BitShift($iDWORD, 16)
EndFunc



; ===================================================================
; _LoWord($iDWORD)
;
; 说明：从32位值中得到高序16位值
; 参数：$iDWORD - 32位数值（可由上面的_MakeLong()函数获得）
; 返回：32位数值中的低序16位数值
; 注意：
; 作者：happytc
; 版本：1.0.0
; ===================================================================
Func _LoWord($iDWORD)
    Return BitAnd($iDWORD, 0xFFFF)
EndFunc