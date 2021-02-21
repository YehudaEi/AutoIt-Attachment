#Region Example
$_ = FileOpenDialog("",@scriptdir,"Binary (*.exe;*.dll)")
If @error Then Exit
$iRet = _IsUPXLargeTarget($_)
If @error Then
  MsgBox(16,@scriptname,"_IsUPX Error "& @error)
Elseif $iRet Then
  MsgBox(64,@scriptname,"Upx packing detected in:"& @lf & $_)
Else
  MsgBox(48,@scriptname,"Upx packing not detected in:"& @lf & $_)
Endif
#Endregion
;
#CS
  _IsUPXLargeTarget offset dependant example for big binaries.

  Identical in operation to my structured example.

  Returns: 0 = Upx not detected, 1 First bytes (upx) detected.
  Errors ::
    1 = Failed to open target file.
    2 = MZ bom not found (not executable)
    3 = PE signature not found. (non Win32 pe's not supported)
#CE
Func _IsUPXLargeTarget($sFile)
Local $hFile = FileOpen($sFile,16)
If @error Then
  Return SetError(1)
Endif
;
Local $Size = FileGetSize($sFile)
;
Local $Val = Number(FileRead($hFile,2))
If Not $Val = 23177 Then; MZ bom
  FileClose($hFile)
  Return SetError(2)
Endif
;
FileSetPos($hFile,60,0)
$Val = Number(FileRead($hFile,2))
Local $PEoffset = $Val
;
FileSetPos($hFile,$Val,0)
$Val = Number(FileRead($hFile,2))
If Not $Val = 17744 Then; PE sig
  FileClose($hFile)
  Return SetError(3)
Endif
;
Local Const $INH_LEN = 248
Local Const $IFH_LEN = 20
Local Const $ISH_LEN = 40
;
FileSetPos($hFile,$PEoffset +6,0)
Local $SectionCount = Number(FileRead($hFile,2))
FileSetPos($hFile,$PEoffset + 4 + $IFH_LEN + 16,0)
Local $Addressofentrypoint = Number(FileRead($hFile,4))
;
Local $CurrentOffset = $PEoffset + $INH_LEN
For $i = 1 To $SectionCount
  FileSetPos($hFile,$CurrentOffset +12,0)
  Local $Virtualaddress = Number(FileRead($hFile,4))
  FileSetPos($hFile,$CurrentOffset +20,0)
  Local $Pointertorawdata = Number(FileRead($hFile,4))
  Local $RVA2FO = $Pointertorawdata + $Addressofentrypoint - $Virtualaddress
  If $RVA2FO > 0 And $RVA2FO < $Size Then
    FileSetPos($hFile,$RVA2FO,0)
    $Val = Number(FileRead($hFile,2))
    If $Val = 48736 Then
      FileClose($hFile)
      Return 1
    Endif
  Endif
  $Currentoffset += $ISH_LEN
Next
FileClose($hFile)
Return 0
Endfunc