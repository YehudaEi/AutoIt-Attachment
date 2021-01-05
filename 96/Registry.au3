#comments-start
**************************************************************************************************************************************
AutoIt Information
--------------------------------------------------------------------------------------------------------------------------------------
   AutoIt Version:   3.0
   Language:         English
   Platform:         Win9x/NT

======================================================================================================================================
Script Information
--------------------------------------------------------------------------------------------------------------------------------------
   Name:             Registry.au3
   Author:           Matthew Babcock (IPS)
   Date:             08/15/2004
   
   Purpose:
      Contains functions used for backing up and restoring the system registry.

======================================================================================================================================
Function Directory
--------------------------------------------------------------------------------------------------------------------------------------
   BackupRegistry()     ; Generates three-step system registry backup history (RegBackI.reg, RegBackII.reg, RegBackIII.reg)
   RestoreRegistry()    ; Restores system registry 

======================================================================================================================================
Change Log
--------------------------------------------------------------------------------------------------------------------------------------
   08/15/2004: Created Message.au3
               Created function DispMsg v.5a
   
**************************************************************************************************************************************
#comments-end

#include <Process.au3>

Func BackupRegistry()
;*************************************************************************************************************************************
;  Name:    BackupRegistry
;  Author:  Matthew Babcock (IPS)
;  Date:    08/25/2004
;
;  Parameters:
;     None
;
;  Returns:
;     An integer of 0 if successful or -1 if failure.
;
;  Notes:
;     Generates three-step backup history, RegBackI.reg - RegBackIII.reg
;*************************************************************************************************************************************

   ; Delete third backup
   if FileExists(@HomeDrive & "\RegBackIII.reg") Then
      FileDelete(@HomeDrive & "\RegBackIII.reg")
   EndIf
   
   ; Rename second to third backup
   If FileExists(@HomeDrive & "\RegBackII.reg") Then
      FileCopy(@HomeDrive & "\RegBackII.reg", @HomeDrive & "\RegBackIII.reg")
   EndIf
   
   ; Rename first to second backup
   if FileExists(@HomeDrive & "\RegBackI.reg") Then
      FileCopy(@HomeDrive & "\RegBackI.reg", @HomeDrive & "\RegBackII.reg")
   EndIf
   
   ; Create first backup file
   _RunDOS("regedit /e " & @HomeDrive & "\RegBackI.reg")

   Return 0

EndFunc

Func RestoreRegistry( $RestoreFile )
;*************************************************************************************************************************************
;  Name:    BackupRegistry
;  Author:  Matthew Babcock (IPS)
;  Date:    08/25/2004
;
;  Parameters:
;     $RestoreFile - The full path of the file to restore
;
;  Returns:
;     An integer of 0 if successful or -1 if failure.
;
;  Notes:
;     Default resotration file is RegBackI.reg.
;*************************************************************************************************************************************

   If( $RestoreFile = "" ) Then
      $RestoreFile = @HomeDrive & "\RegBackI.reg"
   EndIf

   If ( FileExists( @HomeDrive & "\RegBackI.reg" ) ) Then
      _RunDos( "regedit /s " & @HomeDrive & "\RegBackI.reg" )
   Else
      MsgBox( 16, "Restore Failed", "The file " & $RestoreFile & " does not exist. System registry failed." )
      Return -1
   EndIf

   Return 0

EndFunc