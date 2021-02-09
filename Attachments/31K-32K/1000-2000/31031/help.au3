#include <GUIConstants.au3>
#include <Constants.au3>
#include <File.au3>
#include <GuiStatusBar.au3>
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include <GuiButton.au3>
#include <GuiEdit.au3>
#Include <WinAPI.au3>
#include <AVIConstants.au3>
#include <WindowsConstants.au3>
#include <TreeViewConstants.au3>





HotKeySet("{END}","abort") ;kills program in case of uncontrolled loop





$editbox = 1


$theone = GUICreate("V4.0",@DesktopWidth,150, -1, -1)
$button1 = GUICtrlCreateButton("(click once) add test.txt",0, 60, 160, 30)
$button11 = GUICtrlCreateButton("Edit", 60, 93, 60, 30)
$button12 = GUICtrlCreateButton("Delete", 120, 93, 60, 30)
$output = GUICtrlCreateEdit("test", 181, 21, @DesktopWidth, 28, BitOR($BS_PUSHLIKE,$SS_CENTER))
GUICtrlSetFont($output, 14, 510, "", "Candara")
GUISetState()

FileChangeDir(@DesktopDir)



While 1
	$msg = GUIGetMsg()
	Select


			case $msg = $button1
				_FileCreate("test.txt")


		Case $msg = $button11
				If $editbox = 1 then

			  _GUICtrlButton_SetText($button11,"Save")
			  $editbox = 0
              $Thebox = GUICtrlCreateEdit("",181,50, @DesktopWidth,100)
			  readtext()

				Else
			_writetext()
			$editbox = 1
			_GUICtrlButton_SetText($button11,"Edit")
			GUICtrlDelete($Thebox)

				EndIf

		Case $msg = $button12
			MsgBox(0,"info","this will delete the file typed in the small edit box")


		Case $msg = $GUI_EVENT_CLOSE
				exit

	EndSelect
WEnd





Func abort()
exit
EndFunc


Func _writetext()
	$writeto = GUICtrlRead($output);read file name in ste small editbox so the program can see if it exists
	$worda = FileOpen(@DesktopDir & "\" & $writeto & ".txt", 0)
If $worda = -1 Then
	MsgBox(0, "Error",'"' & $writeto & '"' & " is non existant" )

Else

	$writeto = GUICtrlRead($output)
	$theamount = _GUICtrlEdit_GetLineCount($Thebox)
	$theamounts = _FileCountLines(@DesktopDir & "\" & $writeto & ".txt")

	$fun = 1
	$fern = 0
	$correction =  $theamount - $theamounts
	 do
	 _FileWriteToLine (@DesktopDir & "\" & $writeto & ".txt" ,$fun,_GUICtrlEdit_GetLine($Thebox,$fern),1)
	$fun = $fun + 1
	$fern = $fern + 1
until $fun = $theamounts + $correction + 1
EndIf
EndFunc




Func readtext()
	$writeto = GUICtrlRead($output)
	$words = FileOpen(@DesktopDir & "\" & $writeto & ".txt", 0)
If $words = -1 Then
	MsgBox(0, "Error",'"' & $writeto &'"' & " is non existant" )

Else




	$writeto = GUICtrlRead($output)
	$theamounts = _FileCountLines(@DesktopDir & "\" & $writeto & ".txt")
	$theinfo = FileReadLine(@DesktopDir & "\" & $writeto & ".txt",1)
	_GUICtrlEdit_SetText ($Thebox, $theinfo)
	$funs = 2
	 do
		 $theinfo = FileReadLine(@DesktopDir & "\" & $writeto & ".txt",$funs)
		 _GUICtrlEdit_AppendText ($Thebox,@CRLF & $theinfo)
	$funs = $funs + 1
	until $funs =  $theamounts + 1



EndIf

EndFunc

