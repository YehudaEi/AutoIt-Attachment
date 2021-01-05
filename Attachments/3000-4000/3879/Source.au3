;============================================================:

; Script:    Registers ".ref" File Extension
; Author(s): Louie Raymond Coassin Jr.

;============================================================:

;----- HKEY_CLASSES_ROOT ----->

RegWrite ("HKCR\.ref", "", "REG_SZ", "ReferenceFile")
RegWrite ("HKCR\.ref", "PerceivedType", "REG_SZ", "Text")
RegWrite ("HKCR\.ref\PersistentHandler", "", "REG_SZ", "{5e941d80-bf96-11cd-b579-08002b30bfeb}")
RegWrite ("HKCR\.ref\ShellNew", "FileName", "REG_SZ", "Template.ref")

RegWrite ("HKCR\ReferenceFile", "", "REG_SZ", "Reference File")
RegWrite ("HKCR\ReferenceFile\DefaultIcon", "", "REG_EXPAND_SZ", "%SystemRoot%\system32\shscrap.dll")
RegWrite ("HKCR\ReferenceFile\Shell", "", "REG_SZ", "Run")
RegWrite ("HKCR\ReferenceFile\Shell\Edit", "", "REG_SZ", "Edit File")
RegWrite ("HKCR\ReferenceFile\Shell\Edit\Command", "", "REG_SZ", "notepad.exe %1")
RegWrite ("HKCR\ReferenceFile\Shell\Open", "", "REG_SZ", "Open File")
RegWrite ("HKCR\ReferenceFile\Shell\Open\Command", "", "REG_SZ", "notepad.exe %1")

;----- HKEY_CLASSES_ROOT ----->
;=============================>
;----- HKEY_CURRENT_USER ----->

RegWrite ("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.ref")
RegWrite ("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.ref\OpenWithList", "List", "REG_SZ", "notepad.exe")
RegWrite ("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.ref\OpenWithList", "MRUList", "REG_SZ", "List")
RegWrite ("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.ref\OpenWithProgids", "ReferenceFile", "REG_NONE")

;----- HKEY_CURRENT_USER ----->
;=============================>
;----- HKEY_LOCAL_MACHINE ---->

RegWrite ("HKLM\SOFTWARE\Classes\.ref", "", "REG_SZ", "ReferenceFile")
RegWrite ("HKLM\SOFTWARE\Classes\.ref", "PerceivedType", "REG_SZ", "Text")
RegWrite ("HKLM\SOFTWARE\Classes\.ref\PersistentHandler", "", "REG_SZ", "{5e941d80-bf96-11cd-b579-08002b30bfeb}")
RegWrite ("HKLM\SOFTWARE\Classes\.ref\ShellNew", "FileName", "REG_SZ", "Template.ref")

RegWrite ("HKLM\Software\Classes\ReferenceFile", "", "REG_SZ", "Reference File")
RegWrite ("HKLM\Software\Classes\ReferenceFile\DefaultIcon", "", "REG_EXPAND_SZ", "%SystemRoot%\system32\shscrap.dll")
RegWrite ("HKLM\Software\Classes\ReferenceFile\Shell", "", "REG_SZ", "Run")
RegWrite ("HKLM\Software\Classes\ReferenceFile\Shell\Edit", "", "REG_SZ", "Edit File")
RegWrite ("HKLM\Software\Classes\ReferenceFile\Shell\Edit\Command", "", "REG_SZ", "notepad.exe %1")
RegWrite ("HKLM\Software\Classes\ReferenceFile\Shell\Open", "", "REG_SZ", "Open File")
RegWrite ("HKLM\Software\Classes\ReferenceFile\Shell\Open\Command", "", "REG_SZ", "notepad.exe %1")

;----- HKEY_LOCAL_MACHINE ---->
;=============================>
;----- HKEY_USERS ------------>

RegWrite ("HKU\S-1-5-21-1957994488-1993962763-854245398-1003\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExt\.ref")
RegWrite ("HKU\S-1-5-21-1957994488-1993962763-854245398-1003\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.ref\OpenWithList", "List", "REG_SZ", "notepad.exe")
RegWrite ("HKU\S-1-5-21-1957994488-1993962763-854245398-1003\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.ref\OpenWithList", "MRUList", "REG_SZ", "List")
RegWrite ("HKU\S-1-5-21-1957994488-1993962763-854245398-1003\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.ref\OpenWithProgids", "ReferenceFile", "REG_NONE")

;----- HKEY_USERS ------------>