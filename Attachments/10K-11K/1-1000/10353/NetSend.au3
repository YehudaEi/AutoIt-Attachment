#NoTrayIcon
#include <GUIConstants.au3>

GUICreate("NetSend", 200, 160, -1, -1)
GUICtrlCreateLabel("Receiver:", 10, 13, 50, 15)
$ReceiverComputer = GUICtrlCreateInput("", 60, 10, 130, 20)
GUICtrlCreateLabel("Message:", 10, 38, 50, 15)
$Message = GUICtrlCreateInput("", 60, 35, 130, 20)
GUICtrlCreateLabel("From:", 10, 68, 50, 15)
$Sender = GUICtrlCreateInput(@ComputerName, 60, 65, 130, 20)
GUICtrlCreateLabel("To:", 10, 93, 50, 15)
$ReceiverName = GUICtrlCreateInput("", 60, 90, 130, 20)
$OK = GUICtrlCreateButton("Send", 10, 120, 180, 30)
GUISetState()

While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			Exit
		Case $OK
			$Send = NetSend(GUICtrlRead($ReceiverComputer), GUICtrlRead($Message), GUICtrlRead($Sender), GUICtrlRead($ReceiverName))
			If $Send = 0 Then
				MsgBox(16, "NetSend", "Error! The message could not be sent!")
			EndIf
	EndSwitch
WEnd


;===============================================================================
;
; Description:		NetSend
; Parameter(s):		$szReceiverComputer - Name of the target computer. * for all.
;					$szMessage - The text to be sent. Can contain line breaks
;								 and tabs.
;					$szSender - Optional. Name of the sender.
;					$szReceiverName - Optional. Name of the target that appears
;									  in the message.
; Requirement:		AutoIt Beta
; Return Value(s):	Returns 1 if message was successfully sent.
;						Return 0 if message was not sent.
; Author(s):		CoePSX (coepsx at yahoo dot com dot br)
; Note(s):			None.
;
;===============================================================================
Func NetSend($szReceiverComputer, $szMessage, $szSender = "", $szReceiverName = "")
	Local Const $GENERIC_WRITE = 0x40000000
	Local Const $FILE_SHARE_READ = 0x00000001
	Local Const $OPEN_EXISTING = 0x00000003
	Local Const $FILE_ATTRIBUTE_NORMAL = 0x00000080
	Dim $szAscConvert[256]
	$szAscConvert[131] = 159
	$szAscConvert[160] = 255
	$szAscConvert[161] = 173
	$szAscConvert[162] = 189
	$szAscConvert[163] = 156
	$szAscConvert[164] = 207
	$szAscConvert[165] = 190
	$szAscConvert[166] = 254
	$szAscConvert[167] = 245
	$szAscConvert[168] = 249
	$szAscConvert[169] = 184
	$szAscConvert[170] = 166
	$szAscConvert[171] = 174
	$szAscConvert[172] = 170
	$szAscConvert[173] = 240
	$szAscConvert[174] = 169
	$szAscConvert[175] = 238
	$szAscConvert[176] = 248
	$szAscConvert[177] = 241
	$szAscConvert[178] = 253
	$szAscConvert[179] = 252
	$szAscConvert[180] = 239
	$szAscConvert[181] = 230
	$szAscConvert[182] = 244
	$szAscConvert[183] = 250
	$szAscConvert[184] = 247
	$szAscConvert[185] = 251
	$szAscConvert[186] = 167
	$szAscConvert[187] = 175
	$szAscConvert[188] = 172
	$szAscConvert[189] = 171
	$szAscConvert[190] = 243
	$szAscConvert[191] = 168
	$szAscConvert[192] = 183
	$szAscConvert[193] = 181
	$szAscConvert[194] = 182
	$szAscConvert[195] = 199
	$szAscConvert[196] = 142
	$szAscConvert[197] = 143
	$szAscConvert[198] = 146
	$szAscConvert[199] = 128
	$szAscConvert[200] = 212
	$szAscConvert[201] = 144
	$szAscConvert[202] = 210
	$szAscConvert[203] = 211
	$szAscConvert[204] = 222
	$szAscConvert[205] = 214
	$szAscConvert[206] = 215
	$szAscConvert[207] = 216
	$szAscConvert[208] = 209
	$szAscConvert[209] = 165
	$szAscConvert[210] = 227
	$szAscConvert[211] = 224
	$szAscConvert[212] = 226
	$szAscConvert[213] = 229
	$szAscConvert[214] = 153
	$szAscConvert[215] = 158
	$szAscConvert[216] = 157
	$szAscConvert[217] = 235
	$szAscConvert[218] = 233
	$szAscConvert[219] = 234
	$szAscConvert[220] = 154
	$szAscConvert[221] = 237
	$szAscConvert[222] = 232
	$szAscConvert[223] = 225
	$szAscConvert[224] = 133
	$szAscConvert[225] = 160
	$szAscConvert[226] = 131
	$szAscConvert[227] = 198
	$szAscConvert[228] = 132
	$szAscConvert[229] = 134
	$szAscConvert[230] = 145
	$szAscConvert[231] = 135
	$szAscConvert[232] = 138
	$szAscConvert[233] = 130
	$szAscConvert[234] = 136
	$szAscConvert[235] = 137
	$szAscConvert[236] = 141
	$szAscConvert[237] = 161
	$szAscConvert[238] = 140
	$szAscConvert[239] = 139
	$szAscConvert[240] = 208
	$szAscConvert[241] = 164
	$szAscConvert[242] = 149
	$szAscConvert[243] = 162
	$szAscConvert[244] = 147
	$szAscConvert[245] = 228
	$szAscConvert[246] = 148
	$szAscConvert[247] = 246
	$szAscConvert[248] = 155
	$szAscConvert[249] = 151
	$szAscConvert[250] = 163
	$szAscConvert[251] = 150
	$szAscConvert[252] = 129
	$szAscConvert[253] = 236
	$szAscConvert[254] = 231
	$szAscConvert[255] = 152

	Local $bRet = 0
	
	Local $pszMailSlot = DllStructCreate("char[" & StringLen("\\" & $szReceiverComputer & "\MAILSLOT\messngr") + 1 & "]")
	DllStructSetData($pszMailSlot, 1, "\\" & $szReceiverComputer & "\MAILSLOT\messngr")
	
	Local $szFinalMessage = $szSender & Chr(0) & $szReceiverName & Chr(0) & $szMessage & Chr(0)
	Local $pucMessage = DllStructCreate("byte[" & StringLen($szFinalMessage) & "]")
	For $i = 1 To StringLen($szFinalMessage)
		Local $szTemp = Asc(StringMid($szFinalMessage, $i, 1))
		If $szAscConvert[$szTemp] <> "" Then
			DllStructSetData($pucMessage, 1, $szAscConvert[$szTemp], $i)
		Else
			DllStructSetData($pucMessage, 1, $szTemp, $i)
		EndIf
	Next
	
	Local $hHandle = DllCall("kernel32.dll", "hwnd", "CreateFile", "ptr", DllStructGetPtr($pszMailSlot), _
								"int", $GENERIC_WRITE, _
								"int", $FILE_SHARE_READ, _
								"ptr", 0, _
								"int", $OPEN_EXISTING, _
								"int", $FILE_ATTRIBUTE_NORMAL, _
								"int", 0)
	$hHandle = $hHandle[0]
	
	If $hHandle Then
		Local $bRet = DllCall("kernel32.dll", "int", "WriteFile", "hwnd", $hHandle, _
								"ptr", DllStructGetPtr($pucMessage), _
								"int", DllStructGetSize($pucMessage), _
								"long_ptr", 0, _
								"ptr", 0)
		$bRet = $bRet[4]
		
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hHandle)
	EndIf
	
	Return $bRet
EndFunc  ;==> NetSend