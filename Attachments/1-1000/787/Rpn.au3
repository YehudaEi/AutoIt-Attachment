Dim $n1, $n2

; usage example
; calculate using AutoIT
$n1 = (Log(1000+5*6)*Exp(ACos(5))/Sqrt(8))*(Sin(1)*Cos(1)*Tan(1))/(5*(20-7+Mod(20,35)))
; calculate using _CalcRPN
$n2 = _CalcRPN("(Log(1000+5*6)*Exp(ACos(5))/Sqrt(8))*(Sin(1)*Cos(1)*Tan(1))/(5*(20-7+Mod(20,35)))")
; both results should match
MsgBox(4096, "Test" , "AutoIT =  " & $n1 & @LF & _
                      "_CalcRPN = " & $n2);### Debug MSGBOX 

; remove value from stack
Func _PopStack(ByRef $vaStack)
   Local $vValue
  
   If Not IsArray($vaStack) Then 
      SetError(1)   ; invalid stack
   Else
      $vValue = $vaStack[UBound($vaStack)-1]
      If UBound($vaStack) > 1 Then 
         ReDim $vaStack[UBound($vaStack)-1]
         $vaStack[0] = UBound($vaStack)-1
      Else
         $vaStack[0] = 0
      EndIf
   EndIf
   Return $vValue
EndFunc

; add value to stack
Func _PushStack(ByRef $vaStack, $vValue)
   If Not IsArray($vaStack) Then 
      SetError(1)   ; invalid stack
      Return 0
   EndIf   
   ReDim $vaStack[UBound($vaStack)+1]
   $vaStack[UBound($vaStack)-1] = $vValue
   ; first element contains stack count
   $vaStack[0] = UBound($vaStack)-1
   Return 1
EndFunc

; Reverse Polish Notation calculator
Func _CalcRPN($sInfix)
   Local $sOps = "+-*/^"
   Local $sFormulas = "MOD SIN COS TAN ASIN ACOS ATAN SQRT LOG EXP"
   Local $vaStack1[1]
   Local $vaStack2[1]
   Local $sChar
   Local $sNextChar
   Local $n, $i
   Local $nOperand1
   Local $nOperand2
   Local $sOp

   $sInfix = StringStripWS($sInfix, 8)
   For $n = 1 To StringLen($sInfix)
      $sChar = StringMid($sInfix, $n, 1)
      If (Asc($sChar) >= 48 And Asc($sChar) <= 57) Or _
         (Asc($sChar) >= 65 And Asc($sChar) <= 90) Or _
         (Asc($sChar) >= 97 And Asc($sChar) <= 122) Or _
         $sChar = "." Then
         ; if alphanumeric character, assume operand or formula
         ; get remaining characters
         While $n <= StringLen($sInfix)
            $sNextChar = StringMid($sInfix, $n+1, 1)
            If (Asc($sNextChar) >= 48 And Asc($sNextChar) <= 57) Or _
               (Asc($sNextChar) >= 65 And Asc($sNextChar) <= 90) Or _
               (Asc($sNextChar) >= 97 And Asc($sNextChar) <= 122) Or _
               $sNextChar = "." Then
               $sChar = $sChar & $sNextChar
               $n = $n+1
            Else
               ExitLoop
            EndIf
         WEnd
         If StringInStr($sFormulas, $sChar) Then
            ; push formula name into stack2
            _PushStack($vaStack2, $sChar)
         Else
            ; push operand into stack1
            _PushStack($vaStack1, $sChar)
         EndIf
      ElseIf $sChar = "(" Then
         ; push left bracket into stack2
         _PushStack($vaStack2, $sChar)
      ElseIf $sChar = ")" Then
         ; pop operators from stack2 and push them into stack1 
         ; until left bracket is reached in stack2
         While $vaStack2[0] > 0 And $vaStack2[$vaStack2[0]] <> "("
            _PushStack($vaStack1, _PopStack($vaStack2))
         WEnd
         ; pop left bracket from stack2
         If $vaStack2[$vaStack2[0]] = "(" Then _PopStack($vaStack2)
      Else
         ; get position of operator. Higher position = higher precedence
         $i = StringInStr($sOps, $sChar)
         If $i > 0 Then
            ; pop higher precedence operators and formulas from stack2
            ; and push them into stack1
            While $vaStack2[0] > 0 And _
                  StringInStr($sFormulas, $vaStack2[$vaStack2[0]]) > 0 Or _
                  StringInStr($sOps, $vaStack2[$vaStack2[0]]) >= $i
               _PushStack($vaStack1, _PopStack($vaStack2))
            WEnd
            ; push current operator into stack2
            _PushStack($vaStack2, $sChar)
         EndIf
      EndIf
   Next
   ; pop remaining operators from stack2 and push them into stack1
   While $vaStack2[0] > 0
      _PushStack($vaStack1, _PopStack($vaStack2))
   WEnd

   ; clear stack2
   Redim $vaStack2[1]
   ; copy stack1 to stack2 so the stack order is reversed
   For $n = $vaStack1[0] To 1 Step -1
      _PushStack($vaStack2, $vaStack1[$n])
   Next

   ; clear stack1
   ReDim $vaStack1[1]
   
   While $vaStack2[0] > 0
      If StringInStr($sOps, $vaStack2[$vaStack2[0]]) Or _
         StringInStr($sFormulas, $vaStack2[$vaStack2[0]]) Then
         ; if top item is an operator or formula then pop it
         $sOp = _PopStack($vaStack2)
         Select
         Case $sOp = "+"
            ; pop the second operand
            $nOperand2 = Number(_PopStack($vaStack1))
            ; pop the first operand
            $nOperand1 = Number(_PopStack($vaStack1))
            ; perform calculation and push result into stack1
            _PushStack($vaStack1, $nOperand1+$nOperand2)
         Case $sOp = "-"
            ; pop the second operand
            $nOperand2 = Number(_PopStack($vaStack1))
            ; pop the first operand
            $nOperand1 = Number(_PopStack($vaStack1))
            ; perform calculation and push result into stack1
            _PushStack($vaStack1, $nOperand1-$nOperand2)
         Case $sOp = "*"
            ; pop the second operand
            $nOperand2 = Number(_PopStack($vaStack1))
            ; pop the first operand
            $nOperand1 = Number(_PopStack($vaStack1))
            ; perform calculation and push result into stack1
            _PushStack($vaStack1, $nOperand1*$nOperand2)
         Case $sOp = "/"
            ; pop the second operand
            $nOperand2 = Number(_PopStack($vaStack1))
            ; pop the first operand
            $nOperand1 = Number(_PopStack($vaStack1))
            ; perform calculation and push result into stack1
            _PushStack($vaStack1, $nOperand1/$nOperand2)
         Case $sOp = "^"
            ; pop the second operand
            $nOperand2 = Number(_PopStack($vaStack1))
            ; pop the first operand
            $nOperand1 = Number(_PopStack($vaStack1))
            ; perform calculation and push result into stack1
            _PushStack($vaStack1, $nOperand1^$nOperand2)
         Case $sOp = "MOD"
            ; pop the second operand
            $nOperand2 = Number(_PopStack($vaStack1))
            ; pop the first operand
            $nOperand1 = Number(_PopStack($vaStack1))
            ; perform calculation and push result into stack1
            _PushStack($vaStack1, Mod($nOperand1, $nOperand2))
         Case $sOp = "SIN"
            ; pop the first operand
            $nOperand1 = Number(_PopStack($vaStack1))
            ; perform calculation and push result into stack1
            _PushStack($vaStack1, Sin($nOperand1))
         Case $sOp = "COS"
            ; pop the first operand
            $nOperand1 = Number(_PopStack($vaStack1))
            ; perform calculation and push result into stack1
            _PushStack($vaStack1, Cos($nOperand1))
         Case $sOp = "TAN"
            ; pop the first operand
            $nOperand1 = Number(_PopStack($vaStack1))
            ; perform calculation and push result into stack1
            _PushStack($vaStack1, Tan($nOperand1))
         Case $sOp = "ASIN"
            ; pop the first operand
            $nOperand1 = Number(_PopStack($vaStack1))
            ; perform calculation and push result into stack1
            _PushStack($vaStack1, ASin($nOperand1))
         Case $sOp = "ACOS"
            ; pop the first operand
            $nOperand1 = Number(_PopStack($vaStack1))
            ; perform calculation and push result into stack1
            _PushStack($vaStack1, ACos($nOperand1))
         Case $sOp = "ATAN"
            ; pop the first operand
            $nOperand1 = Number(_PopStack($vaStack1))
            ; perform calculation and push result into stack1
            _PushStack($vaStack1, ATan($nOperand1))
         Case $sOp = "SQRT"
            ; pop the first operand
            $nOperand1 = Number(_PopStack($vaStack1))
            ; perform calculation and push result into stack1
            _PushStack($vaStack1, Sqrt($nOperand1))
         Case $sOp = "LOG"
            ; pop the first operand
            $nOperand1 = Number(_PopStack($vaStack1))
            ; perform calculation and push result into stack1
            _PushStack($vaStack1, Log($nOperand1))
         Case $sOp = "EXP"
            ; pop the first operand
            $nOperand1 = Number(_PopStack($vaStack1))
            ; perform calculation and push result into stack1
            _PushStack($vaStack1, Exp($nOperand1))
         EndSelect
      Else
         ; pop operand from stack2 and push into stack1
         _PushStack($vaStack1, _PopStack($vaStack2))
      EndIf
   WEnd
   ; the last remaining item in stack1 is the final result
   Return _PopStack($vaStack1)
EndFunc
