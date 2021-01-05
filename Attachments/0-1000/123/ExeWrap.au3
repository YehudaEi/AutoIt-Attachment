Global $IniProjFile = "Test.ini"
Global $DestFolder = @TempDir & "\Temp" & Int(Random(0, 999))

ExeWrap( $IniProjFile )

Func ExeWrap( $IniFile )
   
   Local $AppName, $OutFile, $ExeFile, $IncCount
   Local $Includes[1]
   Local $i, $file
   
   $AppName = IniRead( $IniFile, "Main", "AppName", "" )
   $ExeFile = IniRead( $IniFile, "Main", "ExeFile", "" )
   $OutFile = IniRead( $IniFile, "Main", "TempFile", "" )
   $IncCount = IniRead( $IniFile, "Main", "IncludeCount", "" )
   
   ReDim $Includes[ $IncCount ]
   
   If $IncCount <> 0 Then
      For $i = 0 to $IncCount - 1
         $Includes[0] = IniRead( $IniFile, "Includes", "Include" & $i, "" )
      Next
   EndIf
   
   $file = FileOpen( $OutFile, 2 )
   
   If( $file = -1 ) Then
      
   EndIf
   
   If ( StringRight( $DestFolder, 1 ) <> "\" ) Then
      $DestFolder = $DestFolder & "\"
   EndIf
   
   FileWriteLine( $file, "#comments-start" )
   FileWriteLine( $file, FillString( "*", "135" ) )
   FileWriteLine( $file, "*    This code was generated using ExeWrap, by Matthew Babcock                                                                       *" )
   FileWriteLine( $file, FillString( "*", "135" ) )
   FileWriteLine( $file, "#comments-end" )
   FileWriteLine( $file, "" )
   FileWriteLine( $file, "FileInstall( """ & $ExeFile & """, """ & $DestFolder & """, " & "1 )" )
   For $i = 0 to UBound($Includes) - 1
      FileWriteLine( $file, "FileInstall( """ & $Includes[$i] & """, """ & $DestFolder & """, " & "1 )" )
   Next
   FileWriteLine( $file, "" )
   FileWriteLine( $file, "RunWait( """ & $DestFolder & ParseFile( $ExeFile ) & """ )" )
   FileWriteLine( $file, "" )
   FileWriteLine( $file, "FileDelete( """ & $DestFolder & ParseFile( $ExeFile ) & """ )" )
   For $i = 0 to UBound($Includes) - 1
      FileWriteLine( $file, "FileDelete( """ & $DestFolder & ParseFile($Includes[$i]) & """ )" )
   Next
   
   FileClose( $file )
   
EndFunc

Func ParseFile( $FullPath )
   
   Local $tmp

   $tmp = StringSplit( $FullPath, "\" )
   Return $tmp[$tmp[0]] 

EndFunc

Func FillString( $char, $length )
   
   Dim $i, $tmpString
   
   $tmpString = ""
   
   For $i = 1 to Number($length)
      $tmpString = $tmpString & $char
   Next
   
   Return $tmpString
   
EndFunc