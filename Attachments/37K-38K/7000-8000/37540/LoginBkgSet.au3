#include-once
; #Function# =============================================================
; name...........: _LoginBkgSet
; description ...:  change the background of login page for Win 7 freely
; syntax.........:  _LoginBkgSet($sImgPath, $iButtonFront = 0, $iOverWrite = 1)
; parameters ....:  $sImgPath - The source path of the Img file to change (usually picture format is .Jpg format)
;                           $iButtonFront - this parameter determines which style of Button and front will be used
;                                              |0 - gray opaque button , no shadow front (default)
;                                              |1 每 gray subtransparent button , shadow front
;                                              |2 每 color opaque button , no shadow front 
;                           $iOverWrite - this parameter determines whether to overwrite Img file if they already exist.
;                                              |0 - do not overwrite existing Img file
;                                              |1 每 overwrite existing Img file (default)
; Return Value ......:   success 每 Return a 1
;                                 failure -  Return a 0 and set @error as follows:
;                                 @error  -  1 = this function is not suitable for this system.
;                                           2 = Img file (path) is not exsiting 
;                                           3 = Picture format is not .Jpg format 
;                                           4 = size for Img files exceed 255 kilobyte
;                                           5 =$iButttonSet or $iOverWrite parameter is invalid
;                                           6 = unable to write requested value
;                                           7 =unable to copy requested Img files
; Author ........: JobEst (lujd0429)<www.autoitx.com>
; Remarks .......:  The background of login page changed for Win 7 will take effect  immediately after this function has been performed successfully
;                   If you want to view the result, please press Win + L key combination ~
; =======================================================================
Func _LoginBkgSet($sImgPath, $iButtonFront = 0, $iOverWrite = 1)
        If Not @OSVersion == "Win_7" Then
                Return SetError(1,0,0)     
        Else
                 ; check if Img file(path) is exsiting 
                If FileExists($sImgPath) = 0 Then Return SetError(2,0,0) 
                  ; check if the extension of Img file is .jpg format 
				$sSplitPath = StringSplit($sImgPath, "." , 1)
    
                If Not($sSplitPath[($sSplitPath[0])] == "jpg" OR "JPG" OR "jpeg" OR "JPEG") Then Return SetError(3,0,0)
                  ; check if size for Img files exceed 255 kilobyte
                If (FileGetSize($sImgPath)/1024) > 255 Then Return SetError(4,0,0)
                If @OSArch == "X64" Then
                        $sOSArch = "64"
                Else
                        $sOsArch = ""
                Endif
                  ; check if $ButttonSet or $OverWrite parameter is integral value
                If Not (IsInt($iButtonFront) And IsInt($iOverWrite)) Then Return SetError(5,0,0)
          Local $Return = ""               
		  $Return = RegWrite("HKLM"&$sOsArch&"\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI","ButtonSet","REG_DWORD",$iButtonFront) And _
                    RegWrite("HKLM"&$sOsArch&"\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\Background","OEMBackground","REG_DWORD",1) 
				 If Not ($Return = 1) Then Return SetError(6,0,0)        
		  $Return = FileCopy($sImgPath,@SystemDir&"\oobe\Info\Backgrounds\backgroundDefault.jpg",($iOverWrite) + 8)
                 If Not ($Return = 1) Then Return SetError(7,0,0)  
        Endif        
Return $Return
EndFunc       

