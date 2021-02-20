#include <Array.au3>

#include 'myFileListToArray_AllFiles.au3'

$array = myFileListToArray_AllFiles(@WindowsDir)
_ArrayDisplay($array, 'all files')

$array = myFileListToArray_AllFiles(@WindowsDir , '', 2)
_ArrayDisplay($array, 'all folders')

$array = myFileListToArray_AllFiles(@WindowsDir , '*.txt ; *.rtf')
_ArrayDisplay($array , 'only: txt & rtf')