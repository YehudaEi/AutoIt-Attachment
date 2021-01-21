; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------

; Script Start - Add your code below here
#cs
HRESULT SHGetFolderPath(          HWND hwndOwner,
    int nFolder,
    HANDLE hToken,
    DWORD dwFlags,
    LPTSTR pszPath


#ce

$hwndOwner=""
;$nfolder="CSIDL_PERSONAL"		; using integer value of 5 (0x0005) below
$nfolder=5
$hToken=""
;$dwFlags="SHGFP_TYPE_CURRENT"
$dwFlags=0
$pszPath=""

$Dll=dllopen(@systemdir & "\shell32.dll")
$Dll_Go=DllCall($Dll,"int","SHGetFolderPath","HWND",$hwndOwner,"int",$nfolder,"int",$hToken,"int",$dwFlags,"str",$pszPath)
Msgbox(1,"Information","The current 'My Documents' path is: " & $Dll_GO[5])
DllClose($Dll)

#cs
HRESULT SHSetFolderPath(          int csidl,
    HANDLE hToken,
    DWORD dwFlags,
    LPCTSTR pszPath
);


FARPROC GetProcAddress(
  HMODULE hModule,
  LPCSTR lpProcName
#ce

;This part on is broken:
#cs
$hModule=@systemdir & "\shell32.dll"
$LpProcName=232
$Dll=dllopen(@systemdir & "\kernel32.dll")
$Dll_Handle=DllCall($Dll,"int","GetProcAddress","str",$hModule,"str",$LpProcName)




$csidl=5
$hToken=""
$dwFlags=0
$pszPath="c:\temp"

;$Dll=dllopen(@systemdir & "\shell32.dll")
$Dll_Go=DllCall($Dll_Handle,"int","SHSetFolderPathW","int",$csidl,"int",$htoken,"int",$dwFlags,"str",$pszPath)
dllclose($Dll)

Msgbox(1,"Ha Ha",$Dll_GO[4])
;DllClose($Dll)
#ce

