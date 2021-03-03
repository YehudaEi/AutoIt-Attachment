#include-once
#include <Process.au3>
; #FUNCTION# ================================================
; Name...........: _FileRename
; Description ...: Rename a file
; Syntax.........: _FileName($sFilePath,$sFileName,[$sExtName = ""])
; Parameters ....: $sFilePath - Fullpath of the file to be read
;                          $sFileName - a new filename to be given
;                         $sExtName  - [optional] The extension of a file to be specified
; Return values .: Success - Returns a 1.
;                   Failure - Returns a 0
;                  @Error  - 1 =  the specified file cannot be found .
; Author ........: JobEst <www.autoitx.com >
; Remarks .......: This function is not profect currently , and hope someone can continue to modify it.
; Related .......:
; Link ..........: Inspiration from <http://www.autoitx.com/thread-10110-1-1.html (Author: ¡Ö¡ù z¡ù¡Ö)>
; Example .......: No
; ============================================================
Func _FileRename($sFullPath, $sFileName,$sExtName = "")
    If Not FileExists($sFullpath) Then
        SetError(1,0,0)
    Else
  If $sExtName = "" Then
      Local $ext = StringSplit($sFullpath, "." ,1)
      $sExt = $ext[($ext[0])]
  Else
   $sExt = $sExtName
  EndIf
            $result =  _RunDOS("ren """& $sFullPath &""" """& $sFileName &""""&"."&$sExt&"""")
   If $result = 0 And @error <> 0 Then
     Return 0
      Else
        Return 1
      Endif
EndIf
Endfunc