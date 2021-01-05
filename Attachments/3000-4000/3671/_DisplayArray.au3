;============================================================:
;
; Description:
;
;    Converts the values returned from "MemGetStats ()" from
;    decimal values to percentage values.
;
;    $MemArray[0] = Memory Load (%)
;    $MemArray[1] = Physical RAM Available (%)
;    $MemArray[2] = Page File Available (%)
;    $MemArray[3] = Virtual RAM Available (%)
;
;============================================================:

#Include-Once

$Mem = MemGetStats ()

$Memdiv1 = $Mem[2]/$Mem[1]
$Memdiv2 = $Mem[4]/$Mem[3]
$Memdiv3 = $Mem[6]/$Mem[5]
$Memmulti1 = $Memdiv1*100
$Memmulti2 = $Memdiv2*100
$Memmulti3 = $Memdiv3*100
$Memround1 = Round ($Memmulti1, 4)
$Memround2 = Round ($Memmulti2, 4)
$Memround3 = Round ($Memmulti3, 4)

$MemLoadPer = $Mem[0]
$MemPhyRAMPer = $Memround1
$MemPgFilePer = $Memround2
$MemVirRAMPer = $Memround3

Dim $MemArray[4]
$MemArray[0] = $MemLoadPer
$MemArray[1] = $MemPhyRAMPer
$MemArray[2] = $MemPgFilePer
$MemArray[3] = $MemVirRAMPer

;============================================================:
;
; Function: _DisplayArray ($Array, "Title")
; Author: Louir Raymond Coassin Jr. <frozenyam@hotmail.com>
;
;============================================================:

Func _DisplayArray (ByRef $ArrayName, $Title)
   $Counter = 0
   $ArrayInfo = ""

   If (Not IsArray($ArrayName)) Then
      SetError(1)
      Return 0
   EndIf
   For $Counter = 0 To UBound ($ArrayName) - 1
      $ArrayInfo = $ArrayInfo & "[" & $Counter & "] = "_
      & StringStripCR ($ArrayName[$Counter]) & @CR
   Next

   MsgBox(4096, $Title, $ArrayInfo)
EndFunc

;============================================================: