#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.4.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include-once

Global Const $AL = 0
Global Const $CL = 1
Global Const $DL = 2
Global Const $BL = 3
Global Const $AH = 4
Global Const $CH = 5
Global Const $DH = 6
Global Const $BH = 7

Global Const $AX = 0
Global Const $CX = 1
Global Const $DX = 2
Global Const $BX = 3
Global Const $SP = 4
Global Const $BP = 5
Global Const $SI = 6
Global Const $DI = 7

Global Const $EAX=  0
Global Const $ECX=  1
Global Const $EDX=  2
Global Const $EBX=  3
Global Const $ESP=  4
Global Const $EBP=  5
Global Const $ESI=  6
Global Const $EDI=  7

Global Const $MM0=  0
Global Const $MM1=  1
Global Const $MM2=  2
Global Const $MM3=  3
Global Const $MM4=  4
Global Const $MM5=  5
Global Const $MM6=  6
Global Const $MM7=  7

Global Const $XMM0=  0
Global Const $XMM1=  1
Global Const $XMM2=  2
Global Const $XMM3=  3
Global Const $XMM4=  4
Global Const $XMM5=  5
Global Const $XMM6=  6
Global Const $XMM7=  7

Global Const $ES = 0
Global Const $CS = 1
Global Const $SS = 2
Global Const $DS = 3
Global Const $FS = 4
Global Const $GS = 5

Global Const $ModRM16_BXSI = 0 ; // [BX+SI]
Global Const $ModRM16_BXDI = 1 ; // [BX+DI]
Global Const $ModRM16_BPSI = 2 ; // [BP+SI]
Global Const $ModRM16_BPDI = 3 ; // [BP+DI]
Global Const $ModRM16_SI = 4   ; // [SI]
Global Const $ModRM16_DI = 5   ; // [DI]
Global Const $ModRM16_Disp16 = 6;// [word]
Global Const $ModRM16_BX = 7   ; // [BX]

Global Const $ModRM16_Disp8_BXSI = 64+0 ; // [BX+SI]+byte
Global Const $ModRM16_Disp8_BXDI = 64+1 ; // [BX+DI]+byte
Global Const $ModRM16_Disp8_BPSI = 64+2 ; // [BP+SI]+byte
Global Const $ModRM16_Disp8_BPDI = 64+3 ; // [BP+DI]+byte
Global Const $ModRM16_Disp8_SI = 64+4   ; // [SI]+byte
Global Const $ModRM16_Disp8_DI = 64+5   ; // [DI]+byte
Global Const $ModRM16_Disp8_BP = 64+6   ; // [BP]+byte
Global Const $ModRM16_Disp8_BX = 64+7   ; // [BX]+byte

Global Const $ModRM16_Disp16_BXSI = 128+0 ; // [BX+SI]+word
Global Const $ModRM16_Disp16_BXDI = 128+1 ; // [BX+DI]+word
Global Const $ModRM16_Disp16_BPSI = 128+2 ; // [BP+SI]+word
Global Const $ModRM16_Disp16_BPDI = 128+3 ; // [BP+DI]+word
Global Const $ModRM16_Disp16_SI = 128+4   ; // [SI]+word
Global Const $ModRM16_Disp16_DI = 128+5   ; // [DI]+word
Global Const $ModRM16_Disp16_BP = 128+6   ; // [BP]+word
Global Const $ModRM16_Disp16_BX = 128+7   ; // [BX]+word

Global Const $ModRM32_EAX = 0 ; // [EAX]
Global Const $ModRM32_ECX = 1 ; // [ECX]
Global Const $ModRM32_EDX = 2 ; // [EDX]
Global Const $ModRM32_EBX = 3 ; // [EBX]
Global Const $ModRM32_SIB = 4 ; // <sib>
Global Const $ModRM32_Disp32= 5;// [dword]
Global Const $ModRM32_ESI = 6 ; // [ESI]
Global Const $ModRM32_EDI = 7 ; // [EDI]

Global Const $ModRM32_Disp8_EAX = 64+0 ; // [EAX]+byte
Global Const $ModRM32_Disp8_ECX = 64+1 ; // [ECX]+byte
Global Const $ModRM32_Disp8_EDX = 64+2 ; // [EDX]+byte
Global Const $ModRM32_Disp8_EBX = 64+3 ; // [EBX]+byte
Global Const $ModRM32_Disp8_SIB = 64+4 ; // <sib>+byte
Global Const $ModRM32_Disp8_EBP = 64+5 ; // [EBP]+byte
Global Const $ModRM32_Disp8_ESI = 64+6 ; // [ESI]+byte
Global Const $ModRM32_Disp8_EDI = 64+7 ; // [EDI]+byte

Global Const $ModRM32_Disp32_EAX = 128+0 ; // [EAX]+dword
Global Const $ModRM32_Disp32_ECX = 128+1 ; // [ECX]+dword
Global Const $ModRM32_Disp32_EDX = 128+2 ; // [EDX]+dword
Global Const $ModRM32_Disp32_EBX = 128+3 ; // [EBX]+dword
Global Const $ModRM32_Disp32_SIB = 128+4 ; // <sib>+dword
Global Const $ModRM32_Disp32_EBP = 128+5 ; // [EBP]+dword
Global Const $ModRM32_Disp32_ESI = 128+6 ; // [ESI]+dword
Global Const $ModRM32_Disp32_EDI = 128+7 ; // [EDI]+dword

Global Const $ModRM_Special = 1
Global Const $ModRM_Standard = 2

Global Const $Operand_Relative8  = "rel8"
Global Const $Operand_Relative16 = "rel16"
Global Const $Operand_Relative32 = "rel32"
Global Const $Operand_Relative64 = "rel64"

Global Const $Operand_Reg8  = "r8"
Global Const $Operand_Reg16 = "r16"
Global Const $Operand_Reg32 = "r32"
Global Const $Operand_Reg64 = "r64"

Global Const $Operand_Immediate8  = "imm8"
Global Const $Operand_Immediate16 = "imm16"
Global Const $Operand_Immediate32 = "imm32"
Global Const $Operand_Immediate64 = "imm64"

Global Const $Operand_ModRM8  = "r/m8"
Global Const $Operand_ModRM16 = "r/m16"
Global Const $Operand_ModRM32 = "r/m32"
Global Const $Operand_ModRM64 = "r/m64"

Global Const $Operand_Memory8  = "m8"
Global Const $Operand_Memory16 = "m16"
Global Const $Operand_Memory32 = "m32"
Global Const $Operand_Memory64 = "m64"
Global Const $Operand_Memory128 = "m128"

#include <Memory.au3>
#include <WinAPI.au3>


$InstructionSet = FileOpen("IA-32 Instruction Set.txt",0)

Global $Instructions = FileRead($InstructionSet)
FileClose($InstructionSet)

$Instructions = StringSplit($Instructions,@CRLF,1)



Func ASMExecute($pASMBlock)
	
	Local $RetVal = DllCall("user32.dll", "int", "CallWindowProcW", "ptr", $pASMBlock, "int", 0, "int", 0, "int", 0, "int", 0)
	Return $RetVal[0]
	
EndFunc

Func ASMCompile($BinString)
	
	Local $iBinSize = StringLen($BinString)/2
	Local $pRemoteCode = _MemVirtualAlloc(0, $iBinSize, $MEM_COMMIT, $PAGE_EXECUTE_READWRITE)
	Local $tCodeBuffer = DllStructCreate("byte["&$iBinSize&"]", $pRemoteCode)
	DllStructSetData($tCodeBuffer, 1, "0x"& $BinString)
	
	Return $pRemoteCode
	
EndFunc

Func ASMInstruction($Mnemonic, $OperandA="---", $OperandB="---", $Size=0)

	Global $SizeName[9]
	$SizeName[1] = "b"
	$SizeName[2] = "w"
	$SizeName[4] = "d"
	$SizeName[6] = "p"
	$SizeName[8] = "q"

	$Encoding = EncodingLookup($Mnemonic, $OperandA, $OperandB, $Size)
	$Error = @error
	$Size = @extended
	$Size = $Size/8

	If $Error Then
		ConsoleWrite($Encoding)
		Exit
	EndIf

	$Displacement = ""

	$Regex = StringRegExp($Encoding[0],"([[:alnum:]]+ *\+ *r[bwdq])",3)
	If UBound($Regex) >= 1 Then
		If $Encoding[1] = "r" Then
			$Encoding[0] = StringReplace($Encoding[0], $Regex[0], Hex(Execute("0x"&StringReplace(StringTrimRight($Regex[0],1),"r","$"&$OperandA)),2))
		Else
			If UBound($Encoding) >= 3 Then
				If $Encoding[2] = "r" Then
					$Encoding[0] = StringReplace($Encoding[0], $Regex[0], Hex(Execute("0x"&StringReplace(StringTrimRight($Regex[0],1),"r","$"&$OperandB)),2))
				EndIf
			EndIf
		EndIf
	EndIf

	$ModRM = ""

	$UseModRM = StringInStr($Encoding[0],"/")
	If $UseModRM Then
		
		
		$ModRM_Reg = ""
		$ModRM_RM = ""
		
		$Options = StringMid($Encoding[0],$UseModRM+1,1)
		If StringIsDigit($Options) Then
			$ModRM_Reg = $Options
			If $Encoding[1] = "r/m" Then
				;MsgBox(0,"sdsd",$Options,0)
				If StringInStr($OperandA,"[") Then
					$Variable = StringTrimLeft(StringTrimRight($OperandA,1),1)
					$Mod = Execute("$ModRM"&$Size&"_"&StringReplace($Variable,"+",""))
					If not @error Then
						$ModRM = ModRM($ModRM_Special, $Mod, $ModRM_Reg)
					Else
						ConsoleWrite("ASMp: Error")
					EndIf
					
				Else
					
					$ModRM = ModRM($ModRM_Standard, Execute("$"&$OperandA), $ModRM_Reg)
					
				EndIf
			EndIf
		Else
			If $Encoding[1] = "r/m" Then $ModRM_RM = $OperandA
			If $Encoding[2] = "r/m" Then $ModRM_RM = $OperandB
			If $Encoding[1] = "r" Then $ModRM_Reg = $OperandA
			If $Encoding[2] = "r" Then $ModRM_Reg = $OperandB
			
			If StringInStr($ModRM_RM,"[") Then
				
				$Variable = StringTrimLeft(StringTrimRight($ModRM_RM,1),1)
				;MsgBox(0,"sdsd","$ModRM"&$Size*8&"_"&StringReplace($Variable,"+",""),0)
				$Mod = Execute("$ModRM"&$Size*8&"_"&StringReplace($Variable,"+",""))
				If not @error Then
					$ModRM = ModRM($ModRM_Special, $Mod, Execute("$"&$ModRM_Reg))
				Else
					ConsoleWrite("ASMp: Error")
				EndIf
				
			Else
				$ModRM = ModRM($ModRM_Standard, Execute("$"&$ModRM_RM), Execute("$"&$ModRM_Reg))
			EndIf
			
		EndIf
		
		$Encoding[0] = StringReplace($Encoding[0],"/"&$Options,$ModRM)
		
	EndIf

	If UBound($Encoding) >= 3 and $Encoding[2] = "imm" Then
		If StringInStr($Encoding[0], "i"&$SizeName[$Size]) Then
			$Encoding[0] = StringReplace($Encoding[0], "i"&$SizeName[$Size], SwapEndian(Number($OperandB), $Size) )
		Else
			$Encoding[0] &= SwapEndian(Number($OperandB), $Size)
		EndIf
	EndIf

	;MsgBox(0,"sds", BinaryMid(Number("6"), 1, 1),0)

	$Encoding[0] = StringStripWS($Encoding[0],8)

	Return $Encoding[0]
	
EndFunc

Func EncodingLookup($Instruction, $OperandDest="---", $OperandSrc="---", $RegSize=0)
	
	
	If $OperandDest = "---" Then ; No operands
		Local $Arr[1]
		$Arr[0] = InstructionEncoding($Instruction)
		return $Arr
	ElseIf $OperandSrc = "---" Then ; One operand
		
		Local $SrcType
		Local $InstructionSize
		
		If (StringLeft($OperandDest,2)= "0x" or StringIsDigit($OperandDest)) Then ; Immediate value
			$SrcType = "imm|rel|ptr"
		ElseIf StringInStr($OperandDest,"[") then
			$Variable = StringTrimLeft(StringTrimRight($OperandDest,1),1)
			
			If StringInStr("|eax|ecx|edx|ebx|esi|edi|","|"&$Variable&"|") Then
				$SrcType = "r/m"
			ElseIf $Variable = "ebp" Then
				$SrcType = "sib"
			ElseIf $Variable = "esp" Then
				SetError(1)
				Return "There is no direct instruction for manipulating the data ESP is pointing to."
			ElseIf StringInStr($Variable,"*") Then
				$SrcType = "sib"
			ElseIf StringInStr($Variable,"+") Then
				$SrcType = "r/m"
			Else
				$SrcType = "ptr|m|r/m"
			EndIf
			
		ElseIf StringInStr("|eax|ecx|edx|ebx|esp|ebp|esi|edi|","|"&$OperandDest&"|") Then
			$InstructionSize = 32
			$SrcType = "r|r/m"
		ElseIf StringInStr("|al|cl|dl|bl|ah|ch|dh|bh|","|"&$OperandDest&"|") Then
			$InstructionSize = 8
			$SrcType = "r|r/m"
		ElseIf StringInStr("|ax|cx|dx|bx|sp|bp|si|di|","|"&$OperandDest&"|") Then
			$InstructionSize = 16
			$SrcType = "r|r/m"
		Else
			$SrcType = "rel|ptr|imm"
		EndIf
		
		
		If (not $InstructionSize) and $RegSize Then
			$InstructionSize = $RegSize
		ElseIf $InstructionSize and $RegSize and $RegSize <> $InstructionSize Then
			SetError(1)
			Return "Predefined operand size does not correspond with computed size."
		ElseIf not $InstructionSize Then
			SetError(1)
			Return "Can't compute operand sizes."
			
		EndIf
		
		$SrcTypes = StringSplit(StringReplace($SrcType,"sib","r/m"),"|")
		Local $aReturn[2]
		
		For $s = 1 to $SrcTypes[0]
			
			if $SrcTypes[$s] = "r" or $SrcTypes[$s] = "r/m" Then
				
				$Enc = InstructionEncoding($Instruction, $OperandDest)
				If $Enc Then 
					$aReturn[0] = $Enc
					$aReturn[1] = $OperandDest
					SetExtended($InstructionSize)
					Return $aReturn
				EndIf
				
			EndIf
			;MsgBox(0,"sdsd",$SrcTypes[$s]&$InstructionSize,0)
			$Enc = InstructionEncoding($Instruction, $SrcTypes[$s]&$InstructionSize)
			If $Enc Then 
				$aReturn[0] = $Enc
				$aReturn[1] = $SrcTypes[$s]
				SetExtended($InstructionSize)
				Return $aReturn
			EndIf
			
		Next
		
	Else
		
		Local $DestType, $SrcType
		Local $InstructionSize
		Local $Enc
		
		If (StringLeft($OperandSrc,2)= "0x" or StringIsDigit($OperandSrc)) Then ; Immediate value
			$SrcType = "imm|rel|ptr"
		ElseIf StringInStr($OperandSrc,"[") then
			$Variable = StringTrimLeft(StringTrimRight($OperandSrc,1),1)
			
			If StringInStr("|eax|ecx|edx|ebx|esi|edi|","|"&$Variable&"|") Then
				$SrcType = "r/m"
			ElseIf $Variable = "ebp" Then
				$SrcType = "sib"
			ElseIf $Variable = "esp" Then
				SetError(1)
				Return "There is no direct instruction for manipulation the data ESP is pointing to."
			ElseIf StringInStr($Variable,"*") Then
				$SrcType = "sib"
			ElseIf StringInStr($Variable,"+") Then
				$SrcType = "r/m"
			Else
				$SrcType = "ptr|m|r/m"
			EndIf
			
		ElseIf StringInStr("|eax|ecx|edx|ebx|esp|ebp|esi|edi|","|"&$OperandSrc&"|") Then
			$InstructionSize = 32
			$SrcType = "r|r/m"
		ElseIf StringInStr("|al|cl|dl|bl|ah|ch|dh|bh|","|"&$OperandSrc&"|") Then
			$InstructionSize = 8
			$SrcType = "r|r/m"
		ElseIf StringInStr("|ax|cx|dx|bx|sp|bp|si|di|","|"&$OperandSrc&"|") Then
			$InstructionSize = 16
			$SrcType = "r|r/m"
		Else
			$SrcType = "ptr|imm"
		EndIf
		
		If StringInStr($OperandDest,"[") then
			$Variable = StringTrimLeft(StringTrimRight($OperandDest,1),1)
			
			If StringInStr("|eax|ecx|edx|ebx|esi|edi|","|"&$Variable&"|") Then
				$DestType = "r/m"
			ElseIf $Variable = "ebp" Then
				$DestType = "sib"
			ElseIf $Variable = "esp" Then
				SetError(1)
				Return "There is no direct instruction for manipulating the data ESP is pointing to."
			ElseIf StringInStr($Variable,"*") Then
				$DestType = "sib"
			ElseIf StringInStr($Variable,"+") Then
				$DestType = "r/m"
			EndIf
			
		ElseIf StringInStr("|eax|ecx|edx|ebx|esp|ebp|esi|edi|","|"&$OperandDest&"|") Then
			;If not $InstructionSize Then 
				$InstructionSize = 32
			;Else
			;	SetError(1)
			;	Return "Destination operand uses other sizes than source operand. (32:"&$InstructionSize&")"
			;EndIf
			$DestType = "r|r/m"
		ElseIf StringInStr("|al|cl|dl|bl|ah|ch|dh|bh|","|"&$OperandDest&"|") Then
			If not $InstructionSize Then 
				$InstructionSize = 8
			Else
				SetError(1)
				Return "Destination operand uses other sizes than source operand. (8:"&$InstructionSize&")"
			EndIf
			$DestType = "r|r/m"
		ElseIf StringInStr("|ax|cx|dx|bx|sp|bp|si|di|","|"&$OperandDest&"|") Then
			If not $InstructionSize Then 
				$InstructionSize = 16
			Else
				SetError(1)
				Return "Destination operand uses other sizes than source operand. (16:"&$InstructionSize&")"
			EndIf
			$DestType = "r|r/m"
		EndIf
		
		If (not $InstructionSize) and $RegSize Then
			$InstructionSize = $RegSize
		ElseIf $InstructionSize and $RegSize and $RegSize <> $InstructionSize Then
			SetError(1)
			Return "Predefined operand size does not correspond with computed size."
		ElseIf not $InstructionSize Then
			SetError(1)
			Return "Can't compute operand sizes."
		EndIf
		
		Local $SrcTypes = StringSplit(StringReplace($SrcType,"sib","r/m"),"|")
		Local $DestTypes = StringSplit(StringReplace($DestType,"sib","r/m"),"|")
		
		Local $aReturn[3]
		
		
		SetExtended($InstructionSize)
		
		For $s = 1 to $SrcTypes[0]
			
			For $d = 1 to $DestTypes[0]
				
				if $DestTypes[$d] = "r" or $DestTypes[$d] = "r/m" Then
					
					$Enc = InstructionEncoding($Instruction, $OperandDest, $SrcTypes[$s]&$InstructionSize)
					If $Enc Then 
						$aReturn[0] = $Enc
						$aReturn[1] = $OperandDest
						$aReturn[2] = $SrcTypes[$s]
						SetExtended($InstructionSize)
						Return $aReturn
					EndIf
					
				EndIf
				
				$Enc = InstructionEncoding($Instruction, $DestTypes[$d]&$InstructionSize, $SrcTypes[$s]&$InstructionSize)
				If $Enc Then 
					$aReturn[0] = $Enc
					$aReturn[1] = $DestTypes[$d]
					$aReturn[2] = $SrcTypes[$s]
					SetExtended($InstructionSize)
					Return $aReturn
				EndIf
				
			Next
			
		Next
		
	EndIf
	
	SetError(1)
	Return "Can't make any combinations based on the given operands."
	
EndFunc

Func SwapEndian($iValue, $iSize=4)
	Return Hex(BinaryMid($iValue, 1, $iSize),$iSize*2)
EndFunc

Func InstructionEncoding($Instruction, $OperandDest="", $OperandSrc="")
	
	Local $i
	For $i = 1 to $Instructions[0]
		
		Local $Regex = StringRegExp($Instructions[$i],"\A([[:alnum:]]+)(.+?)\t([^\t]+)\t*\Z",3)
		Local $Opcode, $Operands, $Encoding
		
		
		If UBound($Regex) = 3 Then
			
			$Opcode = StringStripWS($Regex[0],8)
			
			If $Opcode = $Instruction Then
				
				$Operands = StringStripWS($Regex[1],8)
				$Encoding = StringStripWS($Regex[2],7)
				
				If not $OperandDest Then
					If $Operands = "" Then Return $Encoding
				ElseIf Not $OperandSrc Then
					;MsgBox(0,"sdsd",$OperandDest&@CRLF&$Operands)
					If $Operands = $OperandDest Then
						;MsgBox(0,"sdsd",$OperandDest)
						Return $Encoding
					EndIf
				Else
					If $Operands = $OperandDest&","&$OperandSrc Then Return $Encoding
				EndIf
				
			EndIf
			
		EndIf
		
	Next
	
	Return 0
	
EndFunc

Func SIB($Scale, $Index, $Base) ; 4*eax+ecx
	
	If $Scale = 0 Then 
		$Scale = 0
	ElseIf $Scale = 2 Then 
		$Scale = 1
	ElseIf $Scale = 4 Then 
		$Scale = 2
	ElseIf $Scale = 8 Then 
		$Scale = 3
	Else
		SetError(1)
		return "Invalid scale."
	EndIf
	$Scale = BitShift($Scale,-6)
	$Index = BitShift($Index,-3)
	
	Local $SIB = BitOR($Scale,$Index,$Base)
	
	Return Hex($SIB,2)
	
EndFunc


Func ModRM($Type, $RM, $Reg)
	
	If $Type = $ModRM_Standard Then
		$Mod = BitShift(3,-6)
		$Reg = BitShift($Reg,-3)
		Local $ModRM = BitOR($Mod,$RM,$Reg)
		
	Else
		$Reg = BitShift($Reg,-3)
		Local $ModRM = BitOR($RM,$Reg)
		
	EndIf
	
	Return Hex($ModRM,2)
	
EndFunc
