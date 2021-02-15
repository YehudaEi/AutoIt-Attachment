#include <Array.au3>
#include <WindowsConstants.au3>
#include <GUIConstants.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>

$sSelections = FileOpenDialog("Pick multiple files", @WindowsDir & "", "All files(*.*)", 4 + 8)
If @error Then Exit
ConsoleWrite("$sSelections = " & $sSelections & @LF)
 $aSelections = StringSplit($sSelections, "|")
;_ArrayDisplay($aSelections, "$aSelections")

 If $aSelections[0] = 1 Then
 	_singlefile()
  ElseIf $aSelections[0] > 1 Then
  _multifile()  ; Multiple selections
  EndIf

  Func _UseFile($sFile)
   ConsoleWrite("Debug: _Usefile(): $sFile = " & $sFile & @LF)
   EndFunc

  Func _singlefile()
   _UseFile($aSelections[1])
    $var1= 	"C:\test2\"
	$folder=InputBox("Folder Name","Specify folder name","")
	 DirCreate($var1 & "\" & $folder & "\")
	 _FileCopy($aSelections[1],$folder)
 EndFunc

   Func _multifile()
	  $var1= 	"C:\test2\"
     local $folder=InputBox("Folder Name","Specify folder name","")
	   DirCreate($var1 & "\" & $folder & "\")

For $n = 1 To UBound($aSelections) - 1
     _UseFile($aSelections[1] & "\" & $aSelections[$n])

	;filecopy ($aSelections[1]  & "\" & $aSelections[$n] ,$var1& "\" & $folder & "\",9)

	;filecopy ($aSelections[1]  & "\" & $aSelections[$n] ,$var1& "\" & $folder & "\",9)

	_FileCopy($aSelections[1] & "\" & $aSelections[$n] ,$var1)

	;_FileCopy($aSelections[1]  & "\" & $aSelections[$n] ,$var1& "\" & $folder & "\")
		 Next
;EndIf
EndFunc

func _progress()
	ProgressOn("Progress Meter", "Increments every second", "0 percent")
For $i = 10 to 100 step 10
    sleep(1000)
    ProgressSet( $i, $i & " percent")
Next
ProgressSet(100 , "Done", "Complete")
sleep(500)
ProgressOff()

EndFunc

Func _FileCopy($fromFile,$tofile)
    Local $FOF_RESPOND_YES = 16
    Local $FOF_SIMPLEPROGRESS = 256
    $winShell = ObjCreate("shell.application")
    $winShell.namespace($tofile).CopyHere($fromFile,$FOF_RESPOND_YES)
EndFunc



