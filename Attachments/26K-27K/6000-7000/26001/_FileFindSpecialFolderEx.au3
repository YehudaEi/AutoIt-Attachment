Global Const $CSIDL_DESKTOP = 0x0000
Global Const $CSIDL_INTERNET = 0x0001
Global Const $CSIDL_PROGRAMS = 0x0002
Global Const $CSIDL_CONTROLS = 0x0003
Global Const $CSIDL_PRINTERS = 0x0004
Global Const $CSIDL_PERSONAL = 0x0005
Global Const $CSIDL_FAVORITES = 0x0006
Global Const $CSIDL_STARTUP = 0x0007
Global Const $CSIDL_RECENT = 0x0008
Global Const $CSIDL_SENDTO = 0x0009
Global Const $CSIDL_BITBUCKET = 0x000A
Global Const $CSIDL_STARTMENU = 0x000B
Global Const $CSIDL_MYDOCUMENTS = 0x000C
Global Const $CSIDL_MYMUSIC = 0x000D
Global Const $CSIDL_MYVIDEO = 0x000E
Global Const $CSIDL_DIRECTORY = 0x0010
Global Const $CSIDL_DRIVES = 0x0011
Global Const $CSIDL_NETWORK = 0x0012
Global Const $CSIDL_NETHOOD = 0x0013
Global Const $CSIDL_FONTS = 0x0014
Global Const $CSIDL_TEMPLATES = 0x0015
Global Const $CSIDL_COMMON_STARTMENU = 0x016
Global Const $CSIDL_COMMON_PROGRAMS = 0x0017
Global Const $CSIDL_COMMON_STARTUP = 0x0018
Global Const $CSIDL_COMMON_DESKTOPDIRECTORY = 0x0019
Global Const $CSIDL_APPDATA = 0x001A
Global Const $CSIDL_PRINTHOOD = 0x001B
Global Const $CSIDL_LOCAL_APPDATA = 0x001C
Global Const $CSIDL_ALTSTARTUP = 0x001D
Global Const $CSIDL_COMMON_ALTSTARTUP = 0x001E
Global Const $CSIDL_COMMON_FAVORITES = 0x001F
Global Const $CSIDL_INTERNET_CACHE = 0x0020
Global Const $CSIDL_COOKIES = 0x0021
Global Const $CSIDL_HISTORY = 0x0022
Global Const $CSIDL_COMMON_APPDATA = 0x0023
Global Const $CSIDL_WINDOWS = 0x0024
Global Const $CSIDL_SYSTEM = 0x0025
Global Const $CSIDL_PROGRAM_FILES = 0x0026
Global Const $CSIDL_MYPICTURES = 0x0027
Global Const $CSIDL_PROFILE = 0x0028
Global Const $CSIDL_SYSTEMX86 = 0x0029
Global Const $CSIDL_PROGRAM_FILESX86 = 0x002A
Global Const $CSIDL_PROGRAM_FILES_COMMON = 0x002B
Global Const $CSIDL_PROGRAM_FILES_COMMONX86 = 0x002C
Global Const $CSIDL_COMMON_TEMPLATES = 0x002D
Global Const $CSIDL_COMMON_DOCUMENTS = 0x002E
Global Const $CSIDL_COMMON_ADMINTOOLS = 0x002F
Global Const $CSIDL_ADMINTOOLS = 0x0030
Global Const $CSIDL_CONNECTIONS = 0x0031
Global Const $CSIDL_COMMON_MUSIC = 0x0035
Global Const $CSIDL_COMMON_PICTURES = 0x0036
Global Const $CSIDL_COMMON_VIDEO = 0x0037
Global Const $CSIDL_RESOURCES = 0x0038
Global Const $CSIDL_RESOURCES_LOCALIZED = 0x0039
Global Const $CSIDL_COMMON_OEM_LINKS = 0x003A
Global Const $CSIDL_CDBURN_AREA = 0x003B
Global Const $CSIDL_COMPUTERSNEARME = 0x003D

Global $oShell = ObjCreate("Shell.Application")	


;~ #CS 
#include <Array.au3>

$Arr = _FileFindSpecialFolderEx($CSIDL_APPDATA ,1)

If IsArray($Arr) Then
	_ArrayDisplay($Arr)
Else
	ConsoleWrite($Arr)
EndIf
;~ #CE 



; =============================================================================================
;
; Function Name:    _FileFindSpecialFolderEx($Folder,[ $ListToArray = 0[, $Filter = 0]])
; Description:     
; Parameter(s):     $Folder      - The Special folder constant (i.e. $MY_COMPUTER)
;                           You could also use an existing path (i.e. "C:\Program Files")
;                           Or a ClassID (i.e. ::{20D04FE0-3AEA-1069-A2D8-08002B30309D} )
;                   $ListToArray - (optional) Change the return value:
;                                   0 = Return the ClassID or Path to the special folder
;                                   1 = Return an array containing the files within the folder
;              		$Filter      - (optional) Filter out the array by:
;                              1 = Files
;                              2 = Folders
;                              3 = Links
;                              4 = ClassId's
;                              0 = No Filter (default)
; Requirement(s):   None.
; Return Value(s):  Returns either:
;                  		1) A string containing the CLASSID or Path corresponding to the Special folder
;                  		2) An Array containing the list of files/folder/links within the special folder with the type
;                     		$OutputArray[$i][0] will contain the list of files/folder/links
;                     		$OutputArray[$i][1] will contain the type used by $Filter Parameter 
;               	Returns -1 if there are no results
; Author(s):        Rajesh V R for _FileFindSpecialFolderEx _Kurt for _FileFindSpecialFolder
; Modified:			05 May 2009
; Note(s):          See http://www.microsoft.com for more info
;
;=================================================================================================
Func _FileFindSpecialFolderEx($Folder, $ListToArray = 0, $Filter = 0)
	
	$nPath = $oShell.NameSpace($Folder).Self.Path
	
	If StringLeft($nPath, 1) = ":" Or StringLeft($nPath, 1) = ";" Then
		SetError(2)
	Else
		SetError(1)
	EndIf
	
	If $nPath = "" Then $nPath = -1
	
	If $ListToArray = 0 Then Return $nPath
	
	$nNum = $oShell.NameSpace($Folder).Items.Count
	
	Local $List[$nNum][2], $a = 0
	Local $Itemtype
	For $i = 0 To $nNum - 1
		
		$CurrentItem = $oShell.NameSpace($Folder).Items.Item($i)
		
		
		If $CurrentItem.IsFileSystem = True Then
			If $CurrentItem.IsFolder <> True Then
				$Itemtype = 1
			EndIf
		EndIf
		
		If $CurrentItem.IsFolder = True Then
			$Itemtype = 2
		EndIf
		
		If $CurrentItem.IsLink = True Then
			$Itemtype = 3
		EndIf
		
		If StringLeft($CurrentItem.Path, 1) = ":" Or StringLeft($CurrentItem.Path, 1) = ";" Then
			$Itemtype = 4
		EndIf
		
		Select
			Case $Filter = 0
				
				$List[$a][0] = $CurrentItem.Path
				$List[$a][1] = $Itemtype
				$a += 1
			Case $Filter = $Itemtype
				
				$List[$a][0] = $CurrentItem.Path
				$List[$a][1] = $Itemtype
				$a += 1
		EndSelect
		

	Next
	If $a = 0 Then
		$List = -1
	Else
		ReDim $List[$a][2]
	EndIf
	Return $List
EndFunc   ;==>_FileFindSpecialFolderEx