#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <WindowsConstants.au3>
#include <GuiButton.au3>



Opt("GUIOnEventMode",1)
AutoItSetOption("GUIOnEventMode", 1)
$hGUI = GUICreate("Script demo", 300, 150)



;Input box for the path
GUICtrlCreateLabel("Write the path here.",5,20,290,20) ;Text for path
Global $path = GUICtrlCreateInput("",5,40,290,20) ;Input for the path


;Copy button
Global $setup_button = GUICtrlCreateButton("Copy",245,120,50,20)
;When the Setup button is pressed a function is called
GUICtrlSetOnEvent($setup_button,"CopyToFile")


;Browse button
Global $browse_button = GUICtrlCreateButton("Browse",180,120,50,20)
;When the Setup button is pressed a function is called
GUICtrlSetOnEvent($browse_button,"BrowsePath")



;Click to show the value on the input box
Global $dialog_box = GUICtrlCreateButton("Show box",90,120,70,20)
;When the Setup button is pressed a function is called
GUICtrlSetOnEvent($dialog_box,"show_box")



;When the x button is clicked a function is called to ask if you are sure you want to exit
GUISetOnEvent($GUI_EVENT_CLOSE,"guiClose")



GUISetState(@SW_SHOW)

;Keep the GUI running
While (1)
	sleep(1000)
WEnd






;FUNCTIONS

;Terminates the script
Func guiClose()
	$exit_selection = MsgBox(4,"Exit","Are you sure you want to quit?")

	if $exit_selection = 6 Then ;Click to Yes
		Exit
	EndIf
EndFunc

;Copy the string from the input field to a txt file
Func CopyToFile()


	$temp_path = GUICtrlRead(4,1)

	CheckFileExist()

	FileWrite("file.txt","" & $temp_path & "" & @CRLF)

	FileClose("file.txt")

EndFunc


;Checks if the txt file for writing exists
;If it exists asks to overwrite it
Func CheckFileExist()
	$file_search = FileFindFirstFile("file.txt")

	if $file_search = -1 Then
		Sleep(10)
	Else
		$overwrite_selection = MsgBox(4,"File","The txt file exists do you want to replace?")
		if $overwrite_selection = 6 Then ;Click to Yes
			FileOpen("file.txt",2)
		EndIf
	EndIf
EndFunc



Func BrowsePath()
	$browse_CVE_path = FileOpenDialog("Locate the .exe", @ProgramFilesDir, "Executables (*.exe)")
	GUICtrlSetData(4,$browse_CVE_path)
EndFunc


Func show_box()
	$display = GUICtrlRead(4,1)
	MsgBox(0,"Input box",$display)
EndFunc






