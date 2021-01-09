#include <array.au3> 
#include <string.au3> 
 
Const $ERAR_END_ARCHIVE = 10 
Const $ERAR_NO_MEMORY = 11 
Const $ERAR_BAD_DATA = 12 
Const $ERAR_BAD_ARCHIVE = 13 
Const $ERAR_UNKNOWN_FORMAT = 14 
Const $ERAR_EOPEN = 15 
Const $ERAR_ECREATE = 16 
Const $ERAR_ECLOSE = 17 
Const $ERAR_EREAD = 18 
Const $ERAR_EWRITE = 19 
Const $ERAR_SMALL_BUF = 20 
 
Const $RAR_OM_LIST = 1;0 
Const $RAR_OM_EXTRACT = 0;1 
 
Const $RAR_SKIP = 0 
Const $RAR_TEST = 1 
Const $RAR_EXTRACT = 2 
 
Const $RAR_VOL_ASK = 0 
Const $RAR_VOL_NOTIFY = 1 
 
Func _RarList($filename) 
    Dim $rar_array[1] 
 
    $rar_open_arcname = DllStructCreate("char[260]") 
    if @error Then 
        MsgBox(0,"","Error in DllStructCreate " & @error); 
        exit 
    endif 
    DllStructSetData($rar_open_arcname,1,$filename) 
 
    $rar_open_cmtbuf = DllStructCreate("char[16384]") 
    if @error Then 
        MsgBox(0,"","Error in DllStructCreate " & @error); 
        exit 
    endif 
    DllStructSetData($rar_open_cmtbuf,1,_StringRepeat(" ",16384)) 
 
    $rar_open_str = DllStructCreate("ptr;uint;uint;ptr;uint;uint;uint") 
    if @error Then 
        MsgBox(0,"","Error in DllStructCreate " & @error); 
        exit 
    endif 
    DllStructSetData($rar_open_str,1,DllStructGetPtr($rar_open_arcname)) 
    DllStructSetData($rar_open_str,2,$RAR_OM_LIST) 
    DllStructSetData($rar_open_str,3,0) 
    DllStructSetData($rar_open_str,4,DllStructGetPtr($rar_open_cmtbuf)) 
    DllStructSetData($rar_open_str,5,16384) 
    DllStructSetData($rar_open_str,6,0) 
    DllStructSetData($rar_open_str,7,0) 
 
    $rar_hdr_cmtbuf = DllStructCreate("char[16384]") 
    if @error Then 
        MsgBox(0,"","Error in DllStructCreate " & @error); 
        exit 
    endif 
    DllStructSetData($rar_hdr_cmtbuf,1,_StringRepeat(" ",16384)) 
 
    $rar_header_str = DllStructCreate("char[260];char[260];uint;uint;uint;uint;uint;uint;uint;uint;uint;ptr;uint;uint;uint") 
    if @error Then 
        MsgBox(0,"","Error in DllStructCreate " & @error); 
        exit 
    endif 
    DllStructSetData($rar_header_str,1,"") 
    DllStructSetData($rar_header_str,2,"") 
    DllStructSetData($rar_header_str,3,0) 
    DllStructSetData($rar_header_str,4,0) 
    DllStructSetData($rar_header_str,5,0) 
    DllStructSetData($rar_header_str,6,0) 
    DllStructSetData($rar_header_str,7,0) 
    DllStructSetData($rar_header_str,8,0) 
    DllStructSetData($rar_header_str,9,0) 
    DllStructSetData($rar_header_str,10,0) 
    DllStructSetData($rar_header_str,11,0) 
    DllStructSetData($rar_header_str,12,DllStructGetPtr($rar_hdr_cmtbuf)) 
    DllStructSetData($rar_header_str,13,16384) 
    DllStructSetData($rar_header_str,14,0) 
    DllStructSetData($rar_header_str,15,0) 
     
    $i = 1 
     
    $dll = DllOpen("unrar.dll") 
    $rar_handle = DllCall($dll,"int","RAROpenArchive","ptr",DllStructGetPtr($rar_open_str)) 
 
;    Do 
        $rar_header = DllCall($dll,"int", "RARReadHeader", "int", $rar_handle[0], "ptr", DllStructGetPtr($rar_header_str)) 
        $rar_list = DllCall($dll, "int", "RARProcessFile", "int", $rar_handle[0], "int", $RAR_EXTRACT, "ptr", "", "ptr", "") 
        if $rar_array[$i - 1] <> DllStructGetData($rar_header_str, 2) Then 
            ReDim $rar_array[UBound($rar_array) + 1] 
            $rar_array[$i] = DllStructGetData($rar_header_str, 2) 
        EndIf 
        $i = $i + 1 
;    Until $rar_header[0] <> 0 
 
    $rar_close = DllCall($dll, "int", "RARCloseArchive", "Int", $rar_handle[0]) 
    DllClose($dll) 
     
    $rar_array[0] = UBound($rar_array) - 1 
    Return $rar_array 
EndFunc 
 
$arr = _RarList("C:\Program Files\AutoIt3\Projects\test.rar") 
_ArrayDisplay($arr)