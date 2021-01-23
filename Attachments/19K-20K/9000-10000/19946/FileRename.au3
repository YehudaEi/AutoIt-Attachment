#include <Process.au3>
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         xVivoCity (Xandaire Productions -                          )

 Script Function:
	FileRename($fr_FullPath, $fr_RenamePath)
	
	$fr_Fullpath - The full path of the target rename FileChangeDir
	$fr_NewName - New name WITH the file type
	
	Example :
	
	FileRename(@desktopdir & "\File.htm", "NewFile.htm")
	
	Please keep the copyright intact if you are going to use this as a include.

#ce ----------------------------------------------------------------------------

Func FileRename($fr_FullPath, $fr_Rename)
	If $fr_Fullpath = "" Then
		Return -1
	Elseif $fr_Rename = "" Then
	    Return -1
	Else
		_RunDOS("ren """& $fr_FullPath &""" """& $fr_Rename &"""")
		Return 1
	EndIf
	
		
Endfunc

