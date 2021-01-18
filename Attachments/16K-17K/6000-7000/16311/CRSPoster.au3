#include <GUIConstants.au3>

Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=
$CRS_WebApp = GUICreate("CRS Data Input Console", 402, 468, 193, 125)
$Warning_Bold = GUICtrlCreateLabel("Warning:", 0, 0, 55, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Warning1 = GUICtrlCreateLabel("This application is used exclusively, By Computer Resource Service, ", 56, 0, 328, 17)
$Warning2 = GUICtrlCreateLabel("to post data to our website. This application does not have the capability to access", 0, 16, 394, 17)
$Warning3 = GUICtrlCreateLabel("any other part of the Internet. If you feel that this application is accessing other parts", 0, 32, 398, 17)
$Warning4 = GUICtrlCreateLabel("of the Internet, then discontinue use of this program and contact the Support Center.", 0, 48, 401, 17)
$Username_Input = GUICtrlCreateInput("Type your name here.", 64, 88, 121, 21)
$Username = GUICtrlCreateLabel("Your Name:", 0, 96, 60, 17)
$Message_Topic = GUICtrlCreateLabel("Message Topic:", 0, 136, 80, 17)
$Message_Topic_Input = GUICtrlCreateInput("Type the message topic here.", 86, 126, 153, 21)
$Reply_Checkbox = GUICtrlCreateCheckbox("I'm replying to a message.", 256, 128, 145, 17)
$Message = GUICtrlCreateLabel("Message:", 0, 168, 50, 17)
$Edit1 = GUICtrlCreateEdit("", 56, 168, 329, 209)
GUICtrlSetData(-1, StringFormat("Please type your message here.\r\nRemember that after you click Post Message\r\nthe message has already been posted. So \r\nplease proof-read all messages before posting\r\nthem to the CRS Website."))
$Post_Message_Button = GUICtrlCreateButton("Post Message", 304, 384, 83, 25, 0)
$Cancel_Button = GUICtrlCreateButton("Cancel", 224, 384, 75, 25, 0)
$Post_Status = GUICtrlCreateGroup("Upload Status", 8, 416, 377, 41)
$Label1 = GUICtrlCreateLabel("Last Message successfully uploaded at: ", 16, 432, 195, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	Sleep(100)
WEnd

