; Script Start - Add your code below here
#RequireAdmin

#include <GUIConstantsEx.au3>
#include <GuiButton.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <ProgressConstants.au3>
#include <GDIPlus.au3>
#include <WinAPI.au3>
#include <array.au3>
#include <file.au3>
#include <GUIComboBox.au3>
#include <GUIComboBoxEx.au3>
#include <Process.au3>

Opt("TrayAutoPause", 0)
Opt("TrayIconHide", 0)

; Shows the filenames of all files in the current directory.
$aFileList = _FileListToArray("ContentUpdates\mphoto\", "*.*", 1)
If @error Then
    MsgBox(0, "Error", "No files/directories matched the search pattern")
    Exit
EndIf

; Put array into a string
$sFileList = "|" & _ArrayToString($aFileList, "|", 1)

_Main()

Func _Main()

    Local $textBoxTop = 70, $textBoxLeft = 50, $textBoxWidth = 360, $textBoxHeight = 20

    $gui = GUICreate("Create exe", 460, 250)
    GUICtrlCreatePic("images\gui_header.jpg", 0, 0, 460, 33)
    $box = GUICtrlCreateGroup("Create Update", 30, 45, 400, 160)
    $text = "Choose a theme to make a setup file for download on the website."
    $textBox = GUICtrlCreateLabel($text, $textBoxLeft, $textBoxTop, $textBoxWidth, $textBoxHeight)
    $hCombo = GUICtrlCreateCombo("", $textBoxLeft, 100, 200, "Choose")
    GUICtrlSetState(-1, $GUI_FOCUS)
    GUICtrlSetData($hCombo, $sFileList)
    $butNext = GUICtrlCreateButton("Next", 350, 210, 90, 30, $BS_DEFPUSHBUTTON)
    $butCancel = GUICtrlCreateButton("Cancel", 250, 210, 90, 30)


    GUISetState()

    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE, $butCancel
                If MsgBox(8196, "Cancel setup", "Are you sure you want to cancel this operation?") = 6 Then Exit

            Case $butNext
                GUICtrlSetState($butNext, $GUI_DISABLE)
                GUICtrlSetState($butCancel, $GUI_DISABLE)

				$themeEXE = GUICtrlRead($hCombo)
                $theme = StringLeft($themeEXE, StringLen($themeEXE) - 16)
                If FileExists("ContentUpdates\mphoto\" & $themeEXE) = False Or GUICtrlRead($hCombo) = "" Then
                    If MsgBox(8244, "ERROR", "Invalid Choice: " & """" & $theme & """" & @CRLF & @CRLF & "Would you like to try again?") = 7 Then Exit
                    Return ; doesn't work <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
                    ;Exit
                    EndIf

                GUICtrlSetState($hCombo, $GUI_HIDE)

                ; Start the progress bar
                $progressbar = GUICtrlCreateProgress($textBoxLeft, 180, 230, 15, $PBS_MARQUEE)
                _SendMessage(GUICtrlGetHandle(-1), $PBM_SETMARQUEE, True, 50) ; final parameter is update time in ms

                GUICtrlSetData($box, "Compiling EXE - " & $themeEXE)
                $text = "Please be patient while the updateEXE is being compiled."
				GUICtrlSetData($textBox,$text)
                Sleep(2000)
                $text = "Updating variables in ContentUpdate.au3..."
                $textBox1 = GUICtrlCreateLabel($text, $textBoxLeft, $textBoxTop+20, $textBoxWidth, $textBoxHeight)
                Sleep(2000)
                
				#cs~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				;update variable $theme in ContentUpdate.au3
                    $file = "ContentUpdate.au3"
                    $find = "replacethistextwiththemevariablefromcreatecontentupdate.au3"
                    $replace = $theme
                    $retval = _ReplaceStringInFile($file, $find, $replace)
                    If $retval = 0 Then
                        MsgBox(8240, "ERROR", "Error updating variable in: " & $file & @CRLF & " Error: " & @error & @CRLF & @CRLF & "This application will now exit. Please try again." & @CRLF & "If the problem persist, please contact the developer:" & @CRLF & @CRLF & "fran@bowens.co.za" & @CRLF & "083 235 2712")
                        Exit
                    EndIf
				#ce~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				
                ;copy images and update file
                $text = "Copying images and update file..."
                $textBox2 = GUICtrlCreateLabel($text, $textBoxLeft, $textBoxTop+40, $textBoxWidth, $textBoxHeight)
                Sleep(2000) ; ~~~~~~~~~~~~~~~~~~~~~~
                #cs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                FileCopy("images\contentupdates\" & $theme & ".gif", "temp\themeimage.gif", 9) ; ~~~~~~~~~~~~~~~
                ; FileCopy("ContentUpdates\mphoto\" & $themeEXE, "temp\update.exe",9)
                #ce ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

                ;compile script to exe using DOS command.
                $text = "Compiling script to exe... (This might take a while)"
                $textBox3 = GUICtrlCreateLabel($text, $textBoxLeft, $textBoxTop+60, $textBoxWidth, $textBoxHeight)
                Sleep(2000) ; ~~~~~~~~~~~~~~~~~~~~~~

                ;                       _RunDOS("""C:\Program Files\AutoIt3\Aut2Exe\Aut2exe.exe"" /in ContentUpdate.au3 /out "& $themeEXE & " /icon images/app.ico")

                ;Cleaning up
                $text = "Cleaning up..." 
				#cs~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				$textBox4 = GUICtrlCreateLabel($text, $textBoxLeft, $textBoxTop+80, $textBoxWidth, $textBoxHeight)
                FileDelete("temp\update.exe")
                FileDelete("temp\themeimage.gif")
                FileMove($themeEXE, "ContentUpdates\_final\" & $themeEXE, 1)
				#ce~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				Sleep(2000)

                ;change variable $theme back to "replacethistextwiththemevariablefromcreatecontentupdate.au3" ContentUpdate.au3
                $file = "ContentUpdate.au3"
                $find = $theme
                $replace = "replacethistextwiththemevariablefromcreatecontentupdate.au3"
                $retval = _ReplaceStringInFile($file, $find, $replace)

                ; Continue tidying up by clearing the group box <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                GUICtrlSetData($textBox, "")
                GUICtrlSetData($textBox1, "")
                GUICtrlSetData($textBox2, "")
                GUICtrlSetData($textBox3, "")
				GUICtrlSetData($textBox4, "")
                GUICtrlDelete($progressbar)

                ; Announce success and determine next move
                If MsgBox(8196, "Success", "Would you like to make another one?") = 7 Then
                    ; No
;~ 					ShellExecuteWait("ContentUpdates\_final")
                    Exit
                Else
                    ; Yes
                    GUICtrlSetState($butNext, $GUI_ENABLE)
                    GUICtrlSetState($butCancel, $GUI_ENABLE)
                    GUICtrlSetData($box, "Create Update")
                    GUICtrlSetData($textBox, "Choose a theme to make a setup file for download on the website.")
                    GUICtrlSetState($hCombo, $GUI_SHOW)
                    GUICtrlSetData($hCombo, $sFileList) ; This clears the previous selection from the combo <<<<<<<<<<<<<<<<<<<
                EndIf

        EndSwitch
    WEnd

EndFunc   ;==>_Main
 