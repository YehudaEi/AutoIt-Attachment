; ConvertGUI 0.1.1 -- 27 Sept 2004 -- CyberSlug
; Attempts to convert old GUI syntax to new GUI syntax (change occurred around 20 Sept 2004)
; ChangesLog:
; version 0.1 -- 26 Sept 2004 -- original release
; version 0.1.1 -- bugfixes, output to file instead of clipboard, and accepts file name as command-line arg

; First get the script to convert...
; Allow command-line parameter so that you can drag-n-drop script on a compiled version of this script
Global $orgFile = ""
If $CmdLine[0] > 0 Then 
   If FileExists($CmdLine[1]) Then
      $orgFile = $CmdLine[1]
   Else
      MsgBox(4096,"Error", "Invalid command-line parameter; file does not exist.")
      Exit
   EndIf
Else
   $orgFile = FileOpenDialog("Choose script to convert", "", "AutoIt3 (*.au3)", 3)
   If @error Then Exit
EndIf

SplashTextOn("Converting GUI Script...", @CRLF & @CRLF & "Please Wait...")

; Read in script to an array
Global $orgCode
_FileReadToArray($orgFile, $orgCode)

;Flatten file -- remove line continuations and unnecessary whitespace
;  This makes it easier to replace functions such as GuiHide( ) or GuiShow ( 10 ) ...
Global $flatCode
_Flatten($orgCode, $flatCode)

#cs -- DEBUG
   Dim $temp = ""
   For $i = 1 to UBound($flatCode)-1
      $temp = $temp & $flatCode[$i] & @CRLF
   Next
   MsgBox(4096,"Flat",$temp)
#ce -- DEBUG

; Loop through the array and make changes as needed
For $i = 1 to UBound($flatCode)-1
         
   ;---------------------------
   ; --- RENAMED FUNCTIONS ---
   ;---------------------------
   
   $flatCode[$i] = StringReplace($flatCode[$i],"GuiGetControlState(","GuiCtrlGetState(")
   $flatCode[$i] = StringReplace($flatCode[$i],"GuiSetControlData(","GuiCtrlSetData(")
   $flatCode[$i] = StringReplace($flatCode[$i],"GuiSetControlNotify(","GuiCtrlSetNotify(")
   $flatCode[$i] = StringReplace($flatCode[$i],"GuiSetGroup(","GuiStartGroup(")


   ;---------------------------
   ; --- REMOVED FUNCTIONS ---
   ;---------------------------
   
   $flatCode[$i] = StringReplace($flatCode[$i],"GuiWaitClose(","GuiShow(")
   ; not the best "removal" method but should suffice in most cases...

   
   ;---------------------------
   ; --- CHANGED FUNCTIONS ---
   ;---------------------------
   
   ; GuiShow --> GuiSetState with timeout removed
   If StringInStr($flatCode[$i],"GuiShow(") Then
      $flatCode[$i] = StringReplace($flatCode[$i],"GuiShow(","GuiSetState(")
      Local $pos1 = 11 + StringInStr($flatCode[$i],"GuiSetState")  ;position of opening paren
      Local $startOfLine = StringLeft($flatCode[$i], $pos1 - 12)  ;typically contains $var = ...
      Local $pos2 = _InStr($flatCode[$i],")", $pos1)  ;position of closing paren
      $flatCode[$i] = _Replace($flatCode[$i], $pos1, $pos2, "(@SW_SHOW)")
   EndIf
   
   ; GuiHide() --> GuiSetState(@SW_HIDE)
   $flatCode[$i] = StringReplace($flatCode[$i],"GuiHide()","GuiSetState(@SW_HIDE)")
   
   ; GuiDefaultFont --> GuiSetFont with font and attribute params swapped
   ;  old GUIDefaultFont(size [,weight [,fontname [,attribute]]]) font(size,weight,font)
   ;  new GUISetFont (size [,weight [,attribute [,fontname]]]) 
   If StringInStr($flatCode[$i], "GuiDefaultFont(") Then
      $flatCode[$i] = StringReplace($flatCode[$i],"GuiDefaultFont(","GuiSetFont(")
      ; Note that the StringReplace test includes the trailing open paren... this is in case
      ;  the user has a variable name GuiDefaultFont ....
      Local $pos1 = 10 + StringInStr($flatCode[$i],"GuiSetFont")  ;position of opening paren
      Local $startOfLine = StringLeft($flatCode[$i], $pos1 - 11)
      Local $pos2 = _InStr($flatCode[$i], ")", $pos1)  ;position of closing paren
      Local $newArgs = ""
      ; I'll assume that none of the params is a literal string that might contain commas
      Local $args = StringSplit(_Between($flatCode[$i], $pos1+1, $pos2-1), ",")
      Local $numArgs = $args[0]
      If $numArgs = 3 Then $args[3] = "0," & $args[3] ;insert null attribute parameter
      If $numArgs = 4 Then swap($args[3], $args[4]) ;swap font and attribute
      Local $k
      For $k = 1 to $numArgs - 1
         $newArgs = $newArgs & $args[$k] & ","
      Next
      $newArgs = $newArgs & $args[$numArgs]  ;no trailing comma after last arg
      $flatCode[$i] = _Replace($flatCode[$i], $pos1+1, $pos2-1, $newArgs)
   EndIf

   ; GuiSetControlFont --> GuiCtrlSetFont with font and attribute params swapped
   If StringInStr($flatCode[$i], "GuiSetControlFont(") Then
      $flatCode[$i] = StringReplace($flatCode[$i],"GuiSetControlFont(","GuiCtrlSetFont(")
      Local $pos1 = 14 + StringInStr($flatCode[$i],"GuiCtrlSetFont")  ;position of opening paren
      Local $startOfLine = StringLeft($flatCode[$i], $pos1 - 15)
      Local $pos2 = _InStr($flatCode[$i], ")", $pos1)  ;position of closing paren
      Local $newArgs = ""
      ; I'll assume that none of the params is a literal string that might contain commas
      Local $args = StringSplit(_Between($flatCode[$i], $pos1+1, $pos2-1), ",")
      Local $numArgs = $args[0]
      If $numArgs = 3 Then $args[3] = "0," & $args[3] ;insert null attribute parameter
      If $numArgs = 4 Then swap($args[3], $args[4]) ;swap font and attribute
      Local $k
      For $k = 1 to $numArgs - 1
         $newArgs = $newArgs & $args[$k] & ","
      Next
      $newArgs = $newArgs & $args[$numArgs]  ;no trailing comma after last arg
      $flatCode[$i] = _Replace($flatCode[$i], $pos1+1, $pos2-1, $newArgs)
   EndIf
   
   ;GuiMsg() and GuiMsg(0) are both replaced by GuiGetMsg(), I think....
   If StringInStr($flatCode[$i], "GuiMsg(") Then
      $flatCode[$i] = StringReplace($flatCode[$i],"GuiMsg(","GuiGetMsg(")
      Local $pos1 = 9 + StringInStr($flatCode[$i],"GuiGetMsg")  ;position of opening paren
      Local $startOfLine = StringLeft($flatCode[$i], $pos1 - 10)
      Local $pos2 = _InStr($flatCode[$i], ")", $pos1)  ;position of closing paren
      $flatCode[$i] = _Replace($flatCode[$i], $pos1+1, $pos2-1, "")
   EndIf


   ;------------------------- 
   ; --- SPLIT FUNCTIONS ---
   ;-------------------------

   ;GuiCreateEx --> GuiSetHelp, GuiSetBkColor, GuiSetIcon
   ;I'll do a simple replace.... but this could break script that call
   ;  GuiCreateEx inside a single-line IF statement....
   If StringInStr($flatCode[$i], "GuiCreateEx(") Then
      Local $pos1 = 11 + StringInStr($flatCode[$i],"GuiCreateEx")  ;position of opening paren
      Local $startOfLine = StringLeft($flatCode[$i], $pos1 - 12)
      Local $pos2 = _InStr($flatCode[$i], ")", $pos1)  ;position of closing paren
      Local $newArgs = ""  ;I'll assume that none of the params is a literal string that might contain commas
      Local $args = StringSplit(_Between($flatCode[$i], $pos1+1, $pos2-1), ",")
      Local $numArgs = $args[0]
      If $numArgs >= 3 Then $args[3] = "GuiSetHelp(" & $args[3] & ")"
      If $numArgs >= 2 Then $args[2] = "GuiSetBkColor(" & $args[2] & ")"
      If $numArgs >= 1 Then $args[1] = "GuiSetIcon(" & $args[1] & ")"
      Local $k
      For $k = 1 to $numArgs - 1
         $newArgs = $newArgs & $args[$k] & @CRLF
      Next
      $newArgs = $newArgs & $args[$numArgs]  ;no trailing linebreak after last arg
      $flatCode[$i] = $startOfLine & $newArgs
   EndIf
 
 
   ;GuiWrite --> GuiCtrlSetState and/or GuiCtrlSetData
   If StringInStr($flatCode[$i], "GuiWrite(") Then
      Local $pos1 = 8 + StringInStr($flatCode[$i],"GuiWrite(")  ;position of opening paren
      Local $startOfLine = StringLeft($flatCode[$i], $pos1 - 9)
      Local $pos2 = _InStr($flatCode[$i], ")", $pos1)  ;position of closing paren
      Local $newArgs = ""  ;I'll assume that none of the params is a literal string that might contain commas
      Local $args = StringSplit(_Between($flatCode[$i], $pos1+1, $pos2-1), ",")
      Local $numArgs = $args[0]
      If UBound($args) < 2 Then ContinueLoop ; in case user has a badly formed command in a comment block...
      If $numArgs = 3 Then
         If $args[2] <> 0 And $args[2] <> -1 Then  ;only need SetState if the value changes
            $flatCode[$i] = $startOfLine & "GuiCtrlSetState(" & $args[1] & "," & $args[2] & ")"
         EndIf
         $flatCode[$i] = $flatCode[$i] & @CRLF & "GuiCtrlSetData(" & $args[1] & "," & $args[3] & ")"
      ElseIf $numArgs = 2 Then
         If $args[2] <> "0" And $args[2] <> "-1" Then  ;only need SetState if the value changes
            $flatCode[$i] = $startOfLine & "GuiCtrlSetState(" & $args[1] & "," & $args[2] & ")" & @CRLF
         Else
            $flatCode[$i] = ""
         EndIf
      EndIf
   EndIf
 
 
   ;GuiSetControlEx --> GuiCtrlSetState, GuiCtrlSetResizing, GuiCtrlSetTip, etc ...
   ; old GUISetControlEx ( controlref, state [,resizing [,tip [,ext1 [,background]]]])
   If StringInStr($flatCode[$i], "GuiSetControlEx(") Then
      Local $pos1 = 15 + StringInStr($flatCode[$i],"GuiSetControlEx")  ;position of opening paren
      Local $startOfLine = StringLeft($flatCode[$i], $pos1 - 16)
      Local $pos2 = _InStr($flatCode[$i], ")", $pos1)  ;position of closing paren
      Local $newArgs = ""  ;I'll assume that none of the params is a literal string that might contain commas
      Local $args = StringSplit(_Between($flatCode[$i], $pos1+1, $pos2-1), ",")
      Local $numArgs = $args[0]
      Local $ref = $args[1]
      Local $startIndex = 2 ; this might change if I don't need a call to GuiCtrlSetState due to state value not changing
      If $numArgs >= 6 Then $args[6] = "GuiCtrlSetBkColor(" & $ref & "," & $args[6] & ")"
      If $numArgs >= 5 Then $args[5] = "GuiCtrlSetLimit(" & $ref & "," & $args[5] & ")"
      If $numArgs >= 4 Then $args[4] = "GuiCtrlSetTip(" & $ref & "," & $args[4] & ")"
      If $numArgs >= 3 Then
         If $args[3] <> "0" And $args[3] <> "-1" Then 
            $args[3] = "GuiCtrlSetResizing(" & $ref & "," & $args[3] & ")"
         Else
            $startIndex = $startIndex + 1 ;arg does not affect value, so I don't need to call GuiCtrlSetResizing
         EndIf
      EndIf
      If $numArgs >= 2 Then
         If $args[2] <> "0" And $args[2] <> "-1" Then 
            $args[2] = "GuiCtrlSetState(" & $ref & "," & $args[2] & ")"
         Else
            $startIndex = $startIndex + 1  ;arg does not affect value, so I don't need to call GuiCtrlSetState
         EndIf
      EndIf
      Local $k
      For $k = $startIndex to $numArgs - 1
         $newArgs = $newArgs & $args[$k] & @CRLF
      Next
      $newArgs = $newArgs & $args[$numArgs]  ;no trailing linebreak after last arg
      $flatCode[$i] = $startOfLine & $newArgs
   EndIf
 
 
   ;GuiSetControl("XXX",...) --> GuiCtrlCreateXXX where XXX is the control such as button, checkbox, etc.
   ;  if type param is a VARIABLE THEN I'LL DO GuiSetControl --> GuiSetData, GuiCtrlSetPos, GuiCtrlSetStyle
   ;  This conversion is not perfect since it depends on run-time info...
   ;  old GUISetControl ( type, "text", left, top [,width [,height [,style [,exStyle]]] )
   ;  new GUICtrlCreateButton ( "text", left, top [,width [,height [,style [,exStyle]]] ) ...
   ;Unused parameters are suppressed in the following:
   ;  GuiCtrlCreateUpdown       ( inputcontrolid] )
   ;  GuiCtrlCreateProgress     ( left, top [,width [,height [,style [,exStyle]]] )
   ;  GuiCtrlCreateTab          ( left, top [,width [,height [,style [,exStyle]]] )
   ;  GuiCtrlCreateTabItem      ( "text" )

   If StringInStr($flatCode[$i], "GuiSetControl(")  Then
      Local $pos1 = 13 + StringInStr($flatCode[$i],"GuiSetControl(")  ;position of opening paren
      Local $startOfLine = StringLeft($flatCode[$i], $pos1 - 14)
      Local $pos2 = _InStr($flatCode[$i], ")", $pos1)  ;position of closing paren
      Local $newArgs = ""  ;I'll assume that none of the params is a literal string that might contain commas
      Local $args = StringSplit(_Between($flatCode[$i], $pos1+1, $pos2-1), ",")
      Local $numArgs = $args[0]
      Local $ctrlType = StringTrimLeft(StringTrimRight($args[1], 1),1)  ;remove quotation marks
      Local $newCommmand = "" ; the new GuiCtrlCreateXXX command that we generate.
      
      If StringInStr($args[1], "$") Then  ; if the control type is a $variable, I cannot do anything....
         #cs -- DEBUG
           MsgBox(4096,"DEBUG", "conversion warning")
         #ce -- DEBUG
         $flatCode[$i] = ";;; CONVERSION WARNING ;;; " & $flatCode[$i] & " ;;; " & @CRLF
         ;GuiSetControl --> GuiSetData, GuiCtrlSetPos, GuiCtrlSetStyle
         ;GUISetControl ( type, "text", left, top [,width [,height [,style [,exStyle]]] )
         ;Generate GuiSetData:  If $text param is not null, I'll assume you want to set it.
         If UBound($args) < 2 Then ContinueLoop ; in case user has a badly formed command in a comment block...
         If $args[2] <> "" Then 
            $flatCode[$i] = $flatCode[$i] & "GUICtrlSetData(" & $args[1] & "," & $args[2] & ")" & @CRLF
         EndIf
         
         ;Generate GuiCtrlSetPos
         If UBound($args) <= 4 Then ContinueLoop ; in case user has a badly formed command in a comment block...
         $newCommand = "GUICtrlSetPos(" & $args[1] & "," & $args[3] & "," & $args[4]
         For $k = 5 to 6
            If $k >= $numArgs Then ExitLoop
            $newCommand = $newCommand & "," & $args[$k]
         Next
         $flatCode[$i] = $flatCode[$i] & $newCommand & ")" & @CRLF
         
         ;Generate GuiCtrlSetStyle
         If $numArgs = 7 Then
            $flatCode[$i] = $flatCode[$i] & "GuiCtrlSetStyle(" & $args[1] & "," & $args[7] & ")" & @CRLF
         ElseIf $numArgs = 8 Then
            $flatCode[$i] = $flatCode[$i] &  ";INFORMATION LOSS exStyle = " & $args[8] & " ;" & @CRLF
         EndIf
         
         ;Misc
         $flatCode[$i] = $flatCode[$i] &  ";;; END OF THIS CONVERSION WARNING ;;; "

         ; Also display the other type of conversion in case the user needs it
         $startOfLine = $flatCode[$i]
         $ctrlType = "???"
      EndIf
      
      Select
      Case $ctrlType = "Updown" or $ctrlType = "TabItem"
         If UBound($args) < 2 Then ContinueLoop ; in case user has a badly formed command in a comment block...
         $newCommand = "GUICtrlCreate" & $ctrlType & "(" & $args[2] & ")"
         
      Case $ctrlType = "Progress" Or $ctrlType = "Tab"
         If UBound($args) < 4 Then ContinueLoop ; in case user has a badly formed command in a comment block...
         $newCommand = "GUICtrlCreate" & $ctrlType & "(" & $args[3] & "," & $args[4]
         For $k = 5 to $numArgs
            If $k >= $numArgs Then ExitLoop
            $newCommand = $newCommand & "," & $args[$k]
         Next
         $newCommand = $newCommand & ")"
       
    Case $ctrlType = "Avi" or $ctrlType = "Icon"
         If UBound($args) < 4 Then ContinueLoop ; in case user has a badly formed command in a comment block...
         $newCommand = "GUICtrlCreate" & $ctrlType & "(" & $args[2] & ",0," & $args[3] & "," & $args[4]
         For $k = 5 to $numArgs
            $newCommand = $newCommand & "," & $args[$k]
         Next
         $newCommand = $newCommand & ")"
         
      Case Else ;button, checkbox, edit, etc....
         ;  old GUISetControl ( type, "text", left, top [,width [,height [,style [,exStyle]]] )
         ;  new GUICtrlCreateButton ( "text", left, top [,width [,height [,style [,exStyle]]] ) ...
         If UBound($args) < 4 Then ContinueLoop ; in case user has a badly formed command in a comment block...
         $newCommand = "GUICtrlCreate" & $ctrlType & "(" & $args[2] & "," & $args[3] & "," & $args[4]
         For $k = 5 to $numArgs
            $newCommand = $newCommand & "," & $args[$k]
         Next
         $newCommand = $newCommand & ")"
      EndSelect
   
      $flatCode[$i] =  $startOfLine & $newCommand
   EndIf

Next


; Copy result to the clipboard
Dim $temp = ""
For $i = 1 to UBound($flatCode)-1
   $temp = $temp & $flatCode[$i] & @CRLF
Next
;;;ClipPut($temp)
;;;MsgBox(4096,"Final",$temp)
$outFile = $orgFile & ".ConvertedGUI.au3"
$handle = FileOpen ($outFile, 2) ;overwrite mode
If $handle = -1 Then
   MsgBox(4096,"Warning", "Could not open '" & $orgFile & ".ConvertedGUI.au3'  Output was copied to clipboard")
   ClipPut($temp)
Else
   FileWrite($handle, $temp)
   FileClose($handle)
EndIf
SplashOff()

Exit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; removes line continuation and unncecessary whitespace
; keeps comments in tact, though
Func _Flatten($array, ByRef $newArray)
   Local $i, $line, $output, $temp
   For $i = 1 to UBound($array)-1
      $line = StringStripWS($array[$i], 3)  ;remove leading and trailing whitespace
      If $line = "" Then
         $output = $output & @LF  ;keep blank lines intact
         ContinueLoop
      EndIf
      If StringLeft($line, 1) = "#" Then
         $output = $output & $line & @LF  ;make no changes to #-directives
         ContinueLoop
      EndIf
      If StringLeft($line, 1) = ";" Then
         $output = $output & $line & @LF  ;make no changes to single-line comments
         ContinueLoop
      EndIf
      ; If line ends in the _ line-continuation-character, then remove and combine into one line
      ; WARNING:  supposed a line of code ends with an inline comment follwed by an underscore_
      ;   I do not take this case into account....
      $temp = ""
      While StringRight($line, 1) = "_"
         $temp = $temp & StringTrimRight($line, 1)
         $i = $i + 1
         $line = StringStripWS($array[$i], 3)  ;remove leading and trailing whitespace
         $temp = $temp & $line
      WEnd
      If $temp <> "" Then $line = $temp
         
      $output = $output & _StripSpace($line) & @LF  ;most stuff is processed by this line
   Next
   
   $newArray = StringSplit($output, @LF)
EndFunc

; Removes unnecessary whitespace from inside functions SomeFunc($arg1,"Arg Two",$arg3)
; $str consists of a single line
; This is really really ugly code, but it appears to work okay...
Func _StripSpace_OLD_BROKEN_VERSION($str)
   ; Read string from right to left and rebuilt string one character at a time
   ; $quote helps keep track of whether we are inside literal strings....
   Local $i, $quote = "", $output = "", $char = "", $paren = 0
   For $i = 1 to StringLen($str)
      $char = StringMid($str, $i, 1)
      If $char = '"' And $quote = "" Then
         $quote = '"'
         $output = $output & $quote
      ElseIf $char = "'" And $quote = "" Then
         $quote = "'"
         $output = $output & $quote
      ElseIf $char = $quote Then
         $output = $output & $quote
         $quote = ""
      ElseIf $quote = "" And $char = "(" then
         If StringRight($output,1) = " " Then $output = StringTrimRight($output,1)
         ; the stringRight checks for the case when space between function name and opening paren
         $output = $output & "("
         $paren = $paren + 1
      ElseIf $quote = "" And $char = ")" then
         $output = $output & ")"
         $paren = $paren - 1
      ElseIf $char = " " And $quote = "" And $paren > 0 And (StringMid($str,$i+1,1) = "," OR StringMid($str,$i-1,1) = ",") Then
         $output = $output & "" ; remove space
      Else
         $output = $output & $char
      EndIf
   Next
   Return $output
EndFunc


; Removes all unnecessary white space from a single line of AutoIt code....
; Do not strip space when:
;   1) It is inside a literal string
;   2) It is inside an in-line comment
;   3) You have alphanumeric (or @ or $) characters on both sides of the space
Func _StripSpace($str)
   ;Return _StripSpaceOld($str)
   ; Read string from right to left and rebuilt string one character at a time
   ; $quote helps keep track of whether we are inside literal strings....
   Local $i, $quote = "", $output = "", $char = "", $paren = 0, $comment = 0
   For $i = 1 to StringLen($str)
      $char = StringMid($str, $i, 1)
      If ($char = '"' or $char = "'") And $quote = "" Then  ;start of literal string
         $quote = $char
         $output = $output & $char
      ElseIf $char = $quote Then ;end of literal string
         $quote = ""
         $output = $output & $char
      ElseIf $char = ";" Then ;start of in-line comment
         $output = $output & StringMid($str, $i, StringLen($str)) ;return rest of string
         ExitLoop
      ElseIf $char = " " Then
         Local $prev = StringMid($str, $i-1, 1) ;always valid since we previously removed space at start of line
         Local $next = StringMid($str, $i+1, 1) ;also always valid since line had all trailing space removed
         If (StringIsAlNum($prev) or $prev = "$" or $prev = "@" or $prev = ")" or $prev = "]") AND ($next = "_" or StringIsAlNum($next) or $next = "$" or $prev = "@") Then
            $output = $output & " "  ;otherwise, we don't include the space in the ooutput
         EndIf
      Else ;I almost forgot the most general case :)
         $output = $output & $char
      EndIf
   Next
   
   Return $output
EndFunc


; Function taken from File.au3 in AutoIt's "Include" directory
Func _FileReadToArray( $sFilePath, ByRef $aArray )
   Local $hFile
   
   $hFile = FileOpen( $sFilePath, 0 )
   
   If $hFile = -1 Then
      SetError( 1 )
      Return 0
   EndIf
   
   $aArray = StringSplit( FileRead( $hFile, FileGetSize( $sFilePath ) ), @LF )
   
   FileClose( $hFile )
   Return 1
EndFunc


; Returns the substring between $start and $stop inclusive
; (similar to StringMid but third arg is position instead of a count)
Func _Between($string, $start, $stop)
   Return StringMid($string, $start, $stop - $start + 1)
EndFunc


; Substitutes chars between $start to $stop (inclusive) with $replacement
Func _Replace($original, $start, $stop, $replacement)
   Local $left = StringLeft($original, $start-1)
   Local $right = StringMid($original, $stop+1, StringLen($original))
   Return $left & $replacement & $right
EndFunc


; Same as StringInStr but allows you to search searching from a particular character position
Func _InStr($string, $sought, $startPos)
   $pos = StringInStr( StringTrimLeft($string, $startPos-1) , $sought)
   If $pos <> 0 Then Return $startPos + $pos - 1
EndFunc

;Swap the contents of two variables
Func swap(ByRef $a, ByRef $b)
    Local $t
    $t = $a
    $a = $b
    $b = $t
EndFunc

; End of Script