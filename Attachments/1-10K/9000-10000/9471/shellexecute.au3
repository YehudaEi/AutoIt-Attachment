;0 The operating system is out of memory or resources. 
Global Const $SE_ERR_FNF              = 2       ;SE_ERR_FNF The specified file was not found. 
Global Const $SE_ERR_PNF              = 3       ;SE_ERR_PNF The specified path was not found. 
Global Const $SE_ERR_ACCESSDENIED     = 5       ;SE_ERR_ACCESSDENIED The operating system denied access to the specified file. 
Global Const $SE_ERR_OOM              = 8       ;SE_ERR_OOM There was not enough memory to complete the operation. 
Global Const $SE_ERR_DLLNOTFOUND      = 32      ;SE_ERR_DLLNOTFOUND The specified dynamic-link library (DLL) was not found. 
Global Const $SE_ERR_SHARE            = 26      ;SE_ERR_SHARE A sharing violation occurred. 
Global Const $SE_ERR_ASSOCINCOMPLETE  = 27      ;SE_ERR_ASSOCINCOMPLETE The file name association is incomplete or invalid. 
Global Const $SE_ERR_DDETIMEOUT       = 28      ;SE_ERR_DDETIMEOUT The DDE transaction could not be completed because the request timed out. 
Global Const $SE_ERR_DDEFAIL          = 29      ;SE_ERR_DDEFAIL The DDE transaction failed. 
Global Const $SE_ERR_DDEBUSY          = 30      ;SE_ERR_DDEBUSY The Dynamic Data Exchange (DDE) transaction could not be completed because other DDE transactions were being processed. 
Global Const $SE_ERR_NOASSOC          = 31      ;SE_ERR_NOASSOC There is no application associated with the given file name extension. This error will also be returned if you attempt to print a file that is not printable. 
	
Global Const $ERROR_FILE_NOT_FOUND    = 2       ;ERROR_FILE_NOT_FOUND The specified file was not found. 
Global Const $ERROR_PATH_NOT_FOUND    = 3       ;ERROR_PATH_NOT_FOUND The specified path was not found. 
Global Const $ERROR_BAD_FORMAT        = 11      ;ERROR_BAD_FORMAT The .exe file is invalid (non-Microsoft Win32 .exe or error in .exe image). 

Global Const $SW_HIDE                 = 0
Global Const $SW_SHOWNORMAL           = 1
Global Const $SW_NORMAL               = 1
Global Const $SW_SHOWMINIMIZED        = 2
Global Const $SW_SHOWMAXIMIZED        = 3
Global Const $SW_MAXIMIZE             = 3
Global Const $SW_SHOWNOACTIVATE       = 4
Global Const $SW_SHOW                 = 5
Global Const $SW_MINIMIZE             = 6
Global Const $SW_SHOWMINNOACTIVE      = 7
Global Const $SW_SHOWNA               = 8
Global Const $SW_RESTORE              = 9
Global Const $SW_SHOWDEFAULT          = 10
Global Const $SW_FORCEMINIMIZE        = 11
Global Const $SW_MAX                  = 11


Func ShellExecute($hwnd,$lpOperation,$lpFile,$lpParameters,$lpDirectory,$nShowCmd)
	$a_Ret = DllCall("shell32.dll","long","ShellExecute", _
		"hwnd",$hwnd, _
		"str",$lpOperation, _
		"str",$lpFile, _
		"str",$lpParameters, _
		"str",$lpDirectory, _
		"int",$nShowCmd )
	Return $a_Ret[0]
EndFunc

#cs
Parameters

hwnd 
[in] Handle to the owner window used for displaying a user interface (UI) or error messages. This value can be NULL if the operation is not associated with a window. 
lpOperation 
[in] Pointer to a null-terminated string, referred to in this case as a verb, that specifies the action to be performed. The set of available verbs depends on the particular file or folder. Generally, the actions available from an object's shortcut menu are available verbs. For more information about verbs and their availability, see Object Verbs. See Extending Shortcut Menus for further discussion of shortcut menus. The following verbs are commonly used. 
edit 
Launches an editor and opens the document for editing. If lpFile is not a document file, the function will fail. 
explore 
Explores the folder specified by lpFile. 
find 
Initiates a search starting from the specified directory. 
open 
Opens the file specified by the lpFile parameter. The file can be an executable file, a document file, or a folder. 
print 
Prints the document file specified by lpFile. If lpFile is not a document file, the function will fail. 
NULL 
For systems prior to Microsoft Windows 2000, the default verb is used if it is valid and available in the registry. If not, the "open" verb is used.

For Windows 2000 and later systems, the default verb is used if available. If not, the "open" verb is used. If neither verb is available, the system uses the first verb listed in the registry.

lpFile 
[in] Pointer to a null-terminated string that specifies the file or object on which to execute the specified verb. To specify a Shell namespace object, pass the fully qualified parse name. Note that not all verbs are supported on all objects. For example, not all document types support the "print" verb. 
lpParameters 
[in] If the lpFile parameter specifies an executable file, lpParameters is a pointer to a null-terminated string that specifies the parameters to be passed to the application. The format of this string is determined by the verb that is to be invoked. If lpFile specifies a document file, lpParameters should be NULL. 
lpDirectory 
[in] Pointer to a null-terminated string that specifies the default directory. 
nShowCmd 
[in] Flags that specify how an application is to be displayed when it is opened. If lpFile specifies a document file, the flag is simply passed to the associated application. It is up to the application to decide how to handle it. 
SW_HIDE 
Hides the window and activates another window. 
SW_MAXIMIZE 
Maximizes the specified window. 
SW_MINIMIZE 
Minimizes the specified window and activates the next top-level window in the z-order. 
SW_RESTORE 
Activates and displays the window. If the window is minimized or maximized, Windows restores it to its original size and position. An application should specify this flag when restoring a minimized window. 
SW_SHOW 
Activates the window and displays it in its current size and position. 
SW_SHOWDEFAULT 
Sets the show state based on the SW_ flag specified in the STARTUPINFO structure passed to the CreateProcess function by the program that started the application. An application should call ShowWindow with this flag to set the initial show state of its main window. 
SW_SHOWMAXIMIZED 
Activates the window and displays it as a maximized window. 
SW_SHOWMINIMIZED 
Activates the window and displays it as a minimized window. 
SW_SHOWMINNOACTIVE 
Displays the window as a minimized window. The active window remains active. 
SW_SHOWNA 
Displays the window in its current state. The active window remains active. 
SW_SHOWNOACTIVATE 
Displays a window in its most recent size and position. The active window remains active. 
SW_SHOWNORMAL 
Activates and displays a window. If the window is minimized or maximized, Windows restores it to its original size and position. An application should specify this flag when displaying the window for the first time.
Return Value

Returns a value greater than 32 if successful, or an error value that is less than or equal to 32 otherwise. The following table lists the error values. The return value is cast as an HINSTANCE for backward compatibility with 16-bit Windows applications. It is not a true HINSTANCE, however. The only thing that can be done with the returned HINSTANCE is to cast it to an int and compare it with the value 32 or one of the error codes below.

0 The operating system is out of memory or resources. 
ERROR_FILE_NOT_FOUND The specified file was not found. 
ERROR_PATH_NOT_FOUND The specified path was not found. 
ERROR_BAD_FORMAT The .exe file is invalid (non-Microsoft Win32 .exe or error in .exe image). 
SE_ERR_ACCESSDENIED The operating system denied access to the specified file. 
SE_ERR_ASSOCINCOMPLETE The file name association is incomplete or invalid. 
SE_ERR_DDEBUSY The Dynamic Data Exchange (DDE) transaction could not be completed because other DDE transactions were being processed. 
SE_ERR_DDEFAIL The DDE transaction failed. 
SE_ERR_DDETIMEOUT The DDE transaction could not be completed because the request timed out. 
SE_ERR_DLLNOTFOUND The specified dynamic-link library (DLL) was not found. 
SE_ERR_FNF The specified file was not found. 
SE_ERR_NOASSOC There is no application associated with the given file name extension. This error will also be returned if you attempt to print a file that is not printable. 
SE_ERR_OOM There was not enough memory to complete the operation. 
SE_ERR_PNF The specified path was not found. 
SE_ERR_SHARE A sharing violation occurred. 
#ce