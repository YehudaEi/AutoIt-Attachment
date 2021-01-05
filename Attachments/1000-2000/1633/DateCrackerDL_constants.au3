Dim $File = @ScriptDir & "\DateCrackerDL.txt"
Global $Today = @MDAY & "-" & @MON & "-" & @Year
Global $Date
Global $Date2
Global $Sleep
Global $ProgramName
Global $StartupDirectory
Global $OverWrite

;===============================================================================
;===============================================================================
Func _DateReplace($DateLong, ByRef $DateShort)

If StringInStr($DateLong, "januari") Then
      $DateShort = StringReplace($DateLong, ". januari ", "-01-")
   ElseIf StringInStr($DateLong, "februari") Then
      $DateShort = StringReplace($DateLong, ". februari ", "-02-")
   ElseIf StringInStr($DateLong, "maart") Then
      $DateShort = StringReplace($DateLong, ". maart ", "-03-")
   ElseIf StringInStr($DateLong, "april") Then
      $DateShort = StringReplace($DateLong, ". april ", "-04-")
   ElseIf StringInStr($DateLong, "mei") Then
      $DateShort = StringReplace($DateLong, ". mei ", "-05-")
   ElseIf StringInStr($DateLong, "juni") Then
      $DateShort = StringReplace($DateLong, ". juni ", "-06-")
   ElseIf StringInStr($DateLong, "juli") Then
      $DateShort = StringReplace($DateLong, ". juli ", "-07-")
   ElseIf StringInStr($DateLong, "augustus") Then
      $DateShort = StringReplace($DateLong, ". augustus ", "-08-")
   ElseIf StringInStr($DateLong, "september") Then
      $DateShort = StringReplace($DateLong, ". september ", "-09-")
   ElseIf StringInStr($DateLong, "oktober") Then
      $DateShort = StringReplace($DateLong, ". oktober ", "-10-")
   ElseIf StringInStr($DateLong, "november") Then
      $DateShort = StringReplace($DateLong, ". november ", "-11-")
   ElseIf StringInStr($DateLong, "december") Then
      $DateShort = StringReplace($DateLong, ". december ", "-12-")
   EndIf
   
   Return
EndFunc
;===============================================================================
;===============================================================================

Func _DateReverse( $sString )
  ;==============================================
  ; Local Constant/Variable Declaration Section
  ;==============================================
  Local $sReverse
  Local $array
  
   If StringLen( $sString ) >= 1 Then
      $array = StringSplit($sString,"-")
      for $x = 1 to $array[0]
         If StringLen($array[$x]) = "1" Then
            $array[$x] =  "0"&$array[$x]
         EndIf
      next
      
      $sReverse = $array[3]&"-"&$array[2]&"-"&$array[1]

      Return $sReverse

   Else
      SetError( 1 )
      Return ""
   EndIf
EndFunc
;===============================================================================
;===============================================================================

Func LogFileWrite($filename, $text)
  While 1
     If 1 = FileWrite($filename, $text) Then  ExitLoop 
     Sleep(300)
  Wend
  Return
EndFunc
;===============================================================================
;===============================================================================

Func _FileCreate( $sFilePath )
  ;==============================================
  ; Local Constant/Variable Declaration Section
  ;==============================================
  Local $hOpenFile
  Local $hWriteFile

  $hOpenFile = FileOpen( $sFilePath, 2 )

  If $hOpenFile = -1 Then
    SetError( 1 )
    Return 0
  EndIf

  $hWriteFile = FileWrite( $hOpenFile, "" )

  If $hWriteFile = -1 Then
    SetError( 2 )
    Return 0
  EndIf

  FileClose( $hOpenFile )
  Return 1
EndFunc
