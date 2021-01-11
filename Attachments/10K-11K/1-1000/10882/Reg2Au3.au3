$Reg = FileOpenDialog("Choose a registry file", @ScriptDir, "Registry Files (*.reg)", 1)
If @error = 1 Then Exit

$Dir = StringLeft($Reg, StringInStr($Reg, '\', 0, -1) - 1)
$NewReg = FileSaveDialog("Choose a file name", $Dir, "Scripts (*.au3)", 16)
If @error = 1 Then Exit

RunWait(@ComSpec & ' /c TYPE "' & $Reg & '" > "%TEMP%\' & GetFilename($Reg) & '"', @SystemDir, @SW_HIDE)
$Reg = @TempDir & "\" & GetFilename($Reg)
$OpenReg = FileOpen($Reg, 0)
$OpenNewReg = FileOpen($NewReg, 2)

Dim $Key
Dim $valuename
Global $Oldvalue = ""
$value = ""
$Type = ""
$Write = "Yes"
$Continue1 = "No"
$Continue2 = "No"
$Continue3 = "No"

$Line = FileReadLine($OpenReg, 2)
$Line = ""

While 1
   $Line = FileReadLine($OpenReg)
   If @error Then ExitLoop
   
   If StringLeft($Line, 1) = ' ' Then
      $value = $Line
      
      If $Continue1 = "Yes" Then
         $Type = "REG_BINARY"
         If StringRight($value, 1) = "\" Then
            $value = StringTrimRight($value, 1)
            $Oldvalue = $Oldvalue & $value
            $Continue1 = "Yes"
            $Write = "No"
         Else
            $Oldvalue = $Oldvalue & $Line
            $Match1 = StringInStr($Oldvalue, ":")
            If $Match1 >= 1 Then $Oldvalue = StringTrimLeft($Oldvalue, $Match1)
            $value = StringReplace($Oldvalue, ",", "")
            $value = Chr(34) & StringStripWS($value, 8) & Chr(34)
            $Oldvalue = ""
            $Continue1 = "No"
            $Write = "Yes"
         EndIf
         
      ElseIf $Continue2 = "Yes" Then
         $Type = "REG_EXPAND_SZ"
         If StringRight($value, 1) = "\" Then
            $value = StringTrimRight($value, 1)
            $Oldvalue = $Oldvalue & $value
            $Continue2 = "Yes"
            $Write = "No"
         Else
            $Oldvalue = $Oldvalue & $Line
            $value = Chr(34) & CharsToString (StringStripWS($Oldvalue, 8)) & Chr(34)
            $Oldvalue = ""
            $Continue2 = "No"
            $Write = "Yes"
         EndIf
         
      ElseIf $Continue3 = "Yes" Then
         $Type = "REG_MULTI_SZ"
         If StringRight($value, 1) = "\" Then
            $value = StringTrimRight($value, 1)
            $Oldvalue = $Oldvalue & $value
            $Continue3 = "Yes"
            $Write = "No"
         Else
            $Oldvalue = $Oldvalue & $Line
            $value = Chr(34) & CharsToString (StringStripWS($Oldvalue, 8)) & Chr(34)
            $Oldvalue = ""
            $Continue3 = "No"
            $Write = "Yes"
         EndIf
      EndIf
      
      If $Write = "Yes" Then FileWrite($OpenNewReg, 'RegWrite("' & $Key & '", ' & $valuename & ', "' & $Type & '", ' & $value & ')' & @CRLF)
      
   EndIf
   
   If $Line <> "" Then
      Select
         Case StringLeft($Line, 1) = ";"
            FileWrite($OpenNewReg, $Line & @CRLF)
            
         Case StringLeft($Line, 1) = "["
            If StringRight($Line, 1) = " " Then
               $Key = StringTrimRight($Line, 2)
            Else
               $Key = StringTrimRight($Line, 1)
            EndIf
            $Key = StringTrimLeft($Key, 1)
            
            If StringLeft($Key, 1) = "-" Then FileWrite($OpenNewReg, 'RegDelete("' & StringTrimLeft($Key, 1) & '")' & @CRLF)
            
         Case StringLeft($Line, 1) = '@'
            $value = StringTrimLeft($Line, 2)
            $value = StringReplace($value, '\\', '\')
            If Not StringLen($value) = 2 Then $value = StringReplace($value, '""', '"')
            
            If StringLeft($value, 1) = "-" Then
               FileWrite($OpenNewReg, 'RegDelete("' & $Key & '", "")' & @CRLF)
            Else
               FileWrite($OpenNewReg, 'RegWrite("' & $Key & '", "", "REG_SZ", ' & $value & ')' & @CRLF)
            EndIf
            
         Case StringLeft($Line, 1) = '"'
            $line_split = StringSplit($Line, "=")
            $valuename = $line_split[1]
            $value = $line_split[2]
            
            If StringInStr($value, 'hex:') >= 1 Then
               $Type = "REG_BINARY"
               If StringRight($value, 1) = "\" Then
                  $value = StringTrimRight($value, 1)
                  $Oldvalue = $value
                  $Continue1 = "Yes"
                  $Write = "No"
               Else
                  $value = StringReplace($value, ",", "")
                  $Match1 = StringInStr($value, ":")
                  If $Match1 >= 1 Then $value = StringTrimLeft($value, $Match1)
                  $value = Chr(34) & StringStripWS($value, 8) & Chr(34)
                  $Continue1 = "No"
                  $Write = "Yes"
               EndIf
               $Match1 = StringInStr($value, ":")
               If $Match1 >= 1 Then $value = StringTrimLeft($value, $Match1)
            ElseIf StringInStr($value, "hex(2):") >= 1 Then
               $Type = "REG_EXPAND_SZ"
               If StringRight($value, 1) = "\" Then
                  $value = StringTrimRight($value, 1)
                  $Oldvalue = $value
                  $Continue2 = "Yes"
                  $Write = "No"
               Else
                  $value = Chr(34) & CharsToString (StringStripWS($value, 8)) & Chr(34)
                  $Continue2 = "No"
                  $Write = "Yes"
               EndIf
               
            ElseIf StringInStr($value, "hex(7)") >= 1 Then
               $Type = "REG_MULTI_SZ"
               If StringRight($value, 1) = "\" Then
                  $value = StringTrimRight($value, 1)
                  $Oldvalue = $value
                  $Continue3 = "Yes"
                  $Write = "No"
               Else
                  $value = Chr(34) & CharsToString (StringStripWS($value, 8)) & Chr(34)
                  $Continue3 = "No"
                  $Write = "Yes"
               EndIf
               
            ElseIf StringLeft($value, 5) = "dword" Then
               $Type = "REG_DWORD"
               $value = StringTrimLeft($value, 6)
               If StringLeft($value, 1) = "0" Then
                  For $i = 1 To StringLen($value)
                     $Char = StringMid($value, $i, 1)
                     If $Char <> "0" Then ExitLoop
                  Next
                  
                  $value = StringTrimLeft($value, ($i - 1))
                  If $value = "" Then $value = "0"
               EndIf
               
               If StringLeft($value, 1) <> '"' And StringRight($value, 1) <> '"' Then $value = '"' & $value & '"'
               
            Else
               
               $Type = "REG_SZ"
            EndIf
            
            $value = StringReplace($value, '\\', '\')
            If Not StringLen($value) = 2 Then $value = StringReplace($value, '""', '"')
            
            If StringLeft($value, 1) = "-" Then
               FileWrite($OpenNewReg, 'RegDelete("' & $Key & '", ' & $valuename & ')' & @CRLF)
            Else
               If $Write = "Yes" Then FileWrite($OpenNewReg, 'RegWrite("' & $Key & '", ' & $valuename & ', "' & $Type & '", ' & $value & ')' & @CRLF)
            EndIf
            
      EndSelect
      
   Else
      FileWrite($OpenNewReg, @CRLF)
   EndIf
Wend

FileClose($OpenNewReg)
Exit

Func CharsToString ($Instring)
   Local $Match1
   Local $Type
   
   $Match1 = StringInStr($Instring, ":")
   If $Match1 >= 1 Then $Instring = StringTrimLeft($Instring, $Match1)
   
   Dim $Temparray, $Count
   $Instring = StringReplace($Instring, " ", "")
   
   ;Remove trailing nulls 
   While StringRight($Instring, 3) = ",00"
      $Instring = StringTrimRight($Instring, 3)
   Wend
   
   ;Create an array of character values and build string
   $Temparray = StringSplit($Instring, ",")
   $Instring = ""
   $x = 0
   For $Count = 1 To $Temparray[0] 
      If $Temparray[$Count] <> "00" Then
         $Instring = $Instring & Chr(Dec($Temparray[$Count])) ;convert hex to dec then get character value and append to return string
         $x = 0
      Else
         $x = $x + 1
         If $x = 3 Then
            $x = 0
            $Instring = $Instring & '" & @LF & "'
         EndIf
      EndIf
   Next
   Return $Instring
   
EndFunc

Func Debug ($message)
   Select
      Case $message = "#open"
         Opt ("WinTitleMatchMode", 2)
         Run("notepad")
         WinWait("Untitled", "")
         WinSetTitle("Untitled", "", "Debug Window")
         
      Case Else
         ControlSend("Debug Window", "", "Edit1", $message)
         
   EndSelect
EndFunc   ;==>Debug

Func GetFilename($Path)
   Local $TempArr
   Local $Filename
   $TempArr = StringSplit($Path, "\")
   If @error Then
      $Filename = $Path
   Else
      $Filename = $TempArr[UBound($TempArr) - 1]
   EndIf
   Return $Filename
EndFunc
