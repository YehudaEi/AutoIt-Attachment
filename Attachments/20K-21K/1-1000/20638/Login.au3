#include <GuiToolbar.au3>
#include <GUIConstants.au3>
#include <file.au3>

RegWrite("HKEY_CURRENT_USER\LoginScript\SyncTime", "TestKey", "REG_SZ", "Hello this is a test")

$button = GUICtrlCreateButton ("Start",75,70,70,20)
GUISetState ()
Sleep(500)


ProgressOn("Logon", "Please wait for the updates to install", "0 percent")
$button = GUICtrlCreateButton ("Start",75,70,70,20)
GUISetState ()
Sleep(500)

For $i = 10 to 100 step 10
	sleep(1000)
ProgressSet( $i, $i & " percent")

If FileExists(".exe") Then
    $val = RunWait(".exe")
    ProgressSet(10,10 & " percent ")
    ; script waits until the exe closes
    MsgBox(16, "Program returned with exit code: " & $val)
Else
    ProgressSet(10,10 & " percent ")
    MsgBox(16,"error", "File not found")
EndIf
	
If FileExists(".exe") Then
    $val = RunWait(".exe")
    ProgressSet(20,20 & " percent ")
    ; script waits until the exe closes
    MsgBox(16, "Program returned with exit code: " & $val)
Else
    ProgressSet(20,20 & " percent ")
    MsgBox(16,"error", "File not found")
EndIf

If FileExists(".exe") Then
    $val = RunWait(".exe")
    ProgressSet(30,30 & " percent ")
    ; script waits until the exe closes
    MsgBox(16, "Program returned with exit code: " & $val)
Else
    ProgressSet(30,30 & " percent ")
    MsgBox(16,"error", "File not found")
EndIf

If FileExists(".exe") Then
    $val = RunWait(".exe")
    ProgressSet(40.40 & " percent ")
    ; script waits until the exe closes
    MsgBox(16, "Program returned with exit code: " & $val)
Else
    ProgressSet(40,40 & " percent ")
    MsgBox(16,"error", "File not found")
EndIf

If FileExists(".exe") Then
    $val = RunWait(".exe")
    ProgressSet(50,50 & " percent ")
    ; script waits until the exe closes
    MsgBox(16, "Program returned with exit code: " & $val)
Else
    ProgressSet(50,50 & " percent ")
    MsgBox(16,"error", "File not found")
EndIf

If FileExists(".exe") Then
    $val = RunWait(".exe")
    ProgressSet(60,60 & " percent ")
    ; script waits until the exe closes
    MsgBox(16, "Program returned with exit code: " & $val)
Else
    ProgressSet(60,60 & " percent ")
    MsgBox(16,"error", "File not found")
EndIf
	
If FileExists(".exe") Then
    $val = RunWait(".exe")
    ProgressSet(70,70 & " percent ")
    ; script waits until the exe closes
    MsgBox(16, "Program returned with exit code: " & $val)
Else
    ProgressSet(70,70 & " percent ")
    MsgBox(16,"error", "File not found")
EndIf

If FileExists(".exe") Then
    $val = RunWait(".exe")
    ProgressSet(80,80 & " percent ")
    ; script waits until the exe closes
    MsgBox(16, "Program returned with exit code: " & $val)
Else
    ProgressSet(80,80 & " percent ")
    MsgBox(16,"error", "File not found")
EndIf
If FileExists(".exe") Then
    $val = RunWait(".exe")
    ProgressSet(90,90 & " percent ")
    ; script waits until the exe closes
    MsgBox(16, "Program returned with exit code: " & $val)
Else
    ProgressSet(90,90 & " percent ")
    MsgBox(16,"error", "File not found")
EndIf

If FileExists(".exe") Then
    $val = RunWait(".exe")
    ProgressSet(100,100 & " percent ")
    ; script waits until the exe closes
    MsgBox(16, "Program returned with exit code: " & $val)
Else
    ProgressSet(100,100 & " percent ")
    MsgBox(16,"error", "File not found")
EndIf
	
Next
ProgressSet(100 , "Done", "Complete")
sleep(1000)
ProgressOff()



DirRemove("c:\updates", 1) 

$var = DriveSpaceTotal( "c:\" )
MsgBox(4096, "HHD Space on C:", $var & " MB")

$b = True =1
$b = False =0

	