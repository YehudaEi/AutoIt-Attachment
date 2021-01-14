#cs
=========V0.1B 31.03,07==========
TODO:
-. maybe add control check on clicks.
-. parse the record and allow changes!
-. add ability to remember IPs/age!
-. add ability to block input while macro is active!
-. think about telnet usage!
-. 
CHANGE LOG:
-.
-* v0.5.0.4B
-. added ip check!
-* v0.5.0.3B
-. Doesn't wait anymore for web-page to load! (instead, sleeps the send-delay!)
-* v0.5.0.2B
-. now have the ability to send keys to environment also using ^<^ suffix!
-. Now has a test mode for IE HIDDEN MODE (shows the window!)
-* v0.5.0.1B
-. OPENS IE HIDDEN FOR ROUTERS !!!
-* v0.4.0.2B
-. AutoRunOnStartup - Load Settings / Start!
-. Add ability to change mouse movement speed! $MoveSpeed
-. go to tray after start!
-. Save/Load Settings!
-. Add A Stop hotkey! $Ingore
-. InputBoxes -> Only Numbers!
-. loading the EDITBOX ok.
-. now looks for saved mode, if isn't find uses the last used mode! (pages...)
-. 
BUGS:
-.
-.
IDEAS:
-. Add ability to minimize all windows before running!
-. add ability to OVERIDE the time delays in recording mode!!!
-. $BcgExitTime - make gui reference ?!
#ce
#include <GUIConstants.au3>
#Include <Array.au3>
#include <String.au3>
#include <IE.au3>
#include <INet.au3>
#NoTrayIcon

Global $MoveSpeed = 17
Global $mousespeedL = "Mouse Speed:         ("
$Version = "v0.5B"
$StatusLable = "             "&Chr(153)&"Spam and Macro Bot " & $Version & " by Shlomi.Kalfa (SK)"&Chr(169)&", 2007"
#Region ### START Koda GUI section ### Form=c:\documents and settings\godsperfectbeing\my documents\uis\spambo3.kxf
$SpamBot = GUICreate(Chr(153)&" Spam & Macro Bot! "&$Version&" by (SK)", 376, 185, 205, 135)
GUISetIcon("fkeyz.ico")
GUISetFont(6, 400, 0, "MS Sans Serif")
GUISetBkColor(0xF1EFE2)
$Tab1 = GUICtrlCreateTab(0, 0, 373, 169)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$TabSheet2 = GUICtrlCreateTabItem("AutoRecord")
$MacroEdit = GUICtrlCreateEdit("", 4, 24, 361, 117)
GUICtrlSetData(-1, StringFormat("Input Text In Here,\r\n(View Options -> Help, For extra Info !!!)\r\nOr Use The Macro Recorder !"))
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
GUICtrlSetState($MacroEdit,$GUI_DISABLE)
$KeysRecCB = GUICtrlCreateCheckbox("Keyboard Record", 146, 152, 103, 13)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xF1EFE2)
$MouseRecCB = GUICtrlCreateCheckbox("Mouse Record", 54, 152, 89, 13)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xF1EFE2)
$RecStartB = GUICtrlCreateButton("Record!", 2, 148, 50, 17, 0)
GUICtrlSetFont(-1, 8, 800, 4, "MS Sans Serif")
GUICtrlSetTip(-1, "Record A Macro !!!")
$SelfInput = GUICtrlCreateButton("Self-Input", 250, 148, 69, 17, 0)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$TextClear = GUICtrlCreateButton("Clear!", 320, 148, 49, 17, 0)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$TabSheet1 = GUICtrlCreateTabItem("Macro'Send")
$MacroInput1 = GUICtrlCreateInput("", 32, 24, 73, 21)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$MacroInput2 = GUICtrlCreateInput("", 32, 48, 73, 21)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$MacroInput3 = GUICtrlCreateInput("", 32, 72, 73, 21)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$MacroInput4 = GUICtrlCreateInput("", 32, 96, 73, 21)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$MacroInput5 = GUICtrlCreateInput("", 32, 120, 73, 21)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$MacroInput6 = GUICtrlCreateInput("", 220, 24, 73, 21)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$MacroInput7 = GUICtrlCreateInput("", 220, 48, 73, 21)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$MacroInput8 = GUICtrlCreateInput("", 220, 72, 73, 21)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$MacroInput9 = GUICtrlCreateInput("", 220, 96, 73, 21)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$MacroInput10 = GUICtrlCreateInput("", 220, 120, 73, 21)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$Macro1SD = GUICtrlCreateInput("", 112, 24, 33, 21,$GUI_SS_DEFAULT_INPUT+$ES_NUMBER)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$Macro2SD = GUICtrlCreateInput("", 112, 48, 33, 21,$GUI_SS_DEFAULT_INPUT+$ES_NUMBER)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$Macro3SD = GUICtrlCreateInput("", 112, 72, 33, 21,$GUI_SS_DEFAULT_INPUT+$ES_NUMBER)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$Macro4SD = GUICtrlCreateInput("", 112, 96, 33, 21,$GUI_SS_DEFAULT_INPUT+$ES_NUMBER)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$Macro5SD = GUICtrlCreateInput("", 112, 120, 33, 21,$GUI_SS_DEFAULT_INPUT+$ES_NUMBER)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$Macro6SD = GUICtrlCreateInput("", 300, 24, 33, 21,$GUI_SS_DEFAULT_INPUT+$ES_NUMBER)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$Macro7SD = GUICtrlCreateInput("", 300, 48, 33, 21,$GUI_SS_DEFAULT_INPUT+$ES_NUMBER)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$Macro8SD = GUICtrlCreateInput("", 300, 72, 33, 21,$GUI_SS_DEFAULT_INPUT+$ES_NUMBER)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$Macro9SD = GUICtrlCreateInput("", 300, 96, 33, 21,$GUI_SS_DEFAULT_INPUT+$ES_NUMBER)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$Macro10SD = GUICtrlCreateInput("", 300, 120, 33, 21,$GUI_SS_DEFAULT_INPUT+$ES_NUMBER)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$Macro1TD = GUICtrlCreateInput("", 144, 24, 33, 21,$GUI_SS_DEFAULT_INPUT+$ES_NUMBER)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$Macro2TD = GUICtrlCreateInput("", 144, 48, 33, 21,$GUI_SS_DEFAULT_INPUT+$ES_NUMBER)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$Macro3TD = GUICtrlCreateInput("", 144, 72, 33, 21,$GUI_SS_DEFAULT_INPUT+$ES_NUMBER)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$Macro4TD = GUICtrlCreateInput("", 144, 96, 33, 21,$GUI_SS_DEFAULT_INPUT+$ES_NUMBER)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$Macro5TD = GUICtrlCreateInput("", 144, 120, 33, 21,$GUI_SS_DEFAULT_INPUT+$ES_NUMBER)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$Macro6TD = GUICtrlCreateInput("", 332, 24, 33, 21,$GUI_SS_DEFAULT_INPUT+$ES_NUMBER)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$Macro7TD = GUICtrlCreateInput("", 332, 48, 33, 21,$GUI_SS_DEFAULT_INPUT+$ES_NUMBER)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$Macro8TD = GUICtrlCreateInput("", 332, 72, 33, 21,$GUI_SS_DEFAULT_INPUT+$ES_NUMBER)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$Macro9TD = GUICtrlCreateInput("", 332, 96, 33, 21,$GUI_SS_DEFAULT_INPUT+$ES_NUMBER)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$Macro10TD = GUICtrlCreateInput("", 332, 120, 33, 21,$GUI_SS_DEFAULT_INPUT+$ES_NUMBER)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$Label8 = GUICtrlCreateLabel("#1", 8, 24, 17, 17)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xF1EFE2)
$Label9 = GUICtrlCreateLabel("#2", 8, 48, 17, 17)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xF1EFE2)
$Label10 = GUICtrlCreateLabel("#3", 8, 72, 17, 17)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xF1EFE2)
$Label11 = GUICtrlCreateLabel("#4", 8, 96, 17, 17)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xF1EFE2)
$Label12 = GUICtrlCreateLabel("#5", 8, 120, 17, 17)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xF1EFE2)
$Label13 = GUICtrlCreateLabel("#6", 196, 24, 17, 17)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xF1EFE2)
$Label14 = GUICtrlCreateLabel("#7", 196, 48, 17, 17)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xF1EFE2)
$Label15 = GUICtrlCreateLabel("#8", 196, 72, 17, 17)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xF1EFE2)
$Label16 = GUICtrlCreateLabel("#9", 196, 96, 17, 17)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xF1EFE2)
$Label17 = GUICtrlCreateLabel("#10", 196, 120, 23, 17)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xF1EFE2)
$Label18 = GUICtrlCreateLabel("Command | Stroke Delay | Send Delay>", 130, 148, 230, 16)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xF1EFE2)
$IENavHiddenCB = GUICtrlCreateCheckbox("IE Hidden Mode    <Fill:", 4, 148, 125, 13)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xF1EFE2)
$MacroClearB = GUICtrlCreateButton("Clear!", 318, 148, 49, 17, 0)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$TabSheet3 = GUICtrlCreateTabItem("Options")
GUICtrlSetState(-1,$GUI_SHOW)
$SendDelayInput = GUICtrlCreateInput("4000", 102, 92, 41, 21,$GUI_SS_DEFAULT_INPUT+$ES_NUMBER)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
GUICtrlSetTip(-1, "The waiting time between each Send. (MiliSeconds ! [1000=1Sec])")
$StrokeDelayInput = GUICtrlCreateInput("170", 102, 116, 41, 21,$GUI_SS_DEFAULT_INPUT+$ES_NUMBER)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
GUICtrlSetTip(-1, "Time between each key send. (MiliSeconds ! [1000=1Sec])")
$SendCountInput = GUICtrlCreateInput("1", 102, 68, 41, 21,$GUI_SS_DEFAULT_INPUT+$ES_NUMBER)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
GUICtrlSetTip(-1, "How many times should the macro be preformed.")
$MouseSpeed = GUICtrlCreateSlider (78,139,65,21)
GUICtrlSetData(-1,17)
GUICtrlSetLimit(-1,100,0)
GUICtrlSetBkColor(-1, 0xF1EFE2)
GUICtrlSetTip(-1, "The speed in which the mouse will move to the next click location."&@CRLF&"Slower is the most stable.(0=Instant!)")
$Label1 = GUICtrlCreateLabel("Raw Send:", 80, 44, 57, 17)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xF1EFE2)
$Label1 = GUICtrlCreateLabel("IP Check:", 4, 44, 57, 17)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xF1EFE2)
$Label2 = GUICtrlCreateLabel("Send Delay:", 4, 92, 62, 17)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xF1EFE2)
$Label3 = GUICtrlCreateLabel("Send Count:", 4, 68, 63, 17)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xF1EFE2)
$AutorunCB = GUICtrlCreateCheckbox("", 140, 24, 17, 17)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xF1EFE2)
$Label4 = GUICtrlCreateLabel("Storke Delay:", 4, 116, 68, 17)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xF1EFE2)
$LabelMouse = GUICtrlCreateLabel($mousespeedL&$MoveSpeed&"%)", 4, 139, 73, 25)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xF1EFE2)
$Label19 = GUICtrlCreateLabel("Auto'run at Startup:", 4, 24, 95, 17)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xF1EFE2)
GUICtrlSetTip(-1, "Runs the program automaticly from  configuration file!")
$RawCB = GUICtrlCreateCheckbox("", 140, 42, 17, 17)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xF1EFE2)
$IPCB = GUICtrlCreateCheckbox("", 60, 42, 17, 17)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xF1EFE2)
$SaveB = GUICtrlCreateButton("Save Macro", 245, 148, 73, 17, 0)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$LoadB = GUICtrlCreateButton("Load Macro", 170, 148, 73, 17, 0)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$AboutEdit = GUICtrlCreateEdit("", 172, 48, 193, 90)
GUICtrlSetData(-1, StringFormat(Chr(153)&"Spam & Macro Bot "&$Version&Chr(169)&"\r\nWas made by Shlomi Kalfa for the\r\nGreater good. It automate direct\r\nMouse and keyboard sends.\r\nENJOY !                                   (SK)\r\n"))
GUICtrlSetFont(-1, 8, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_DISABLE)
$Label5 = GUICtrlCreateLabel("www.FXp.co.il", 204, 24, 106, 20)
GUICtrlSetFont(-1, 12, 800, 0, "David")
GUICtrlSetColor(-1, 0x000080)
GUICtrlSetBkColor(-1, 0xF1EFE2)
$ExitB = GUICtrlCreateButton("Exit", 320, 148, 49, 17, 0)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlCreateTabItem("")
$StartB = GUICtrlCreateButton("Start!", 190, 0, 150, 20, 0)
GUICtrlSetFont(-1, 11, 800, 4, "MS PMincho")
GUICtrlSetCursor ($StartB, 0)
GUICtrlSetState($StartB,$GUI_DISABLE)
$HelpB = GUICtrlCreateButton("Help!", 340, 0, 33, 17, 0)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
$StatusL = GUICtrlCreateLabel($StatusLable, 0, 171, 376, 15)
GUICtrlSetFont($StatusL, 4, 400, 0, "MS Sans Serif")
GUICtrlSetColor($StatusL, 0xF8A1FF)
GUISetState(@SW_SHOW)
;========================================[HELP]
#Region ### START Koda GUI section ### Form=c:\documents and settings\godsperfectbeing\my documents\uis\spambothelp.kxf
$HelpForm = GUICreate("[Help]"&Chr(153)&" Spam And Macro Bot "&$Version&" [Help]", 591, 546, 222, 107)
$Tab2 = GUICtrlCreateTab(0, 0, 585, 521)
$TabPage1 = GUICtrlCreateTabItem("General Information:")
$Edit4 = GUICtrlCreateEdit("", 4, 24, 577, 489)
GUICtrlSetData(-1, StringFormat("[Options:]\r\nAuto"&Chr(39)&"run at Startup - Enabling this feature will couse the program to\r\nrun automaticaly on startup without any perior user interference.\r\nRunning the last macro saved!\r\n\r\nIP Check - If enabled will check if your IP has been changed during the process!\r\n-The last command's send-delay will be used to wait for the router to establish it's reconnection\r\nafter that's done the program will retrieve the new IP and check it according to the previous one!\r\n-In case they are the same, the program will repeat the Macro! \r\n\r\nRaw Send - If enabled will send the keys on the Spam Or Macro RAW !\r\nwith no shortcut keys & special char commands.\r\n\r\nSend Count - The number of time to run the macro, not the ammount of macros\r\nfrom the Macro"&Chr(39)&"Send page but the number of times to send the entire macro.\r\n(eg: set the first macro on the "&Chr(34)&"Macro"&Chr(39)&"Send"&Chr(34)&" page to "&Chr(34)&"{ENTER}"&Chr(34)&" and set the\r\nSend Count to 10, click start and "&Chr(39)&"enter"&Chr(39)&" key will be sent 10 time!!!)\r\n\r\nSend Delay - The time to wait between each send from the above  mantioned.\r\n\r\nStroke Delay - The time between each key sent to another!\r\n\r\n*When using the "&Chr(34)&"Macro"&Chr(39)&"Send"&Chr(34)&" page the "&Chr(39)&"Send Delay"&Chr(39)&" / "&Chr(39)&"Stroke Delay"&Chr(39)&" will be\r\nused only for the first send, the rest will be sent by it"&Chr(39)&"s own setting!\r\n\r\n[Macro"&Chr(39)&"Send]\r\nWell in this page you should set what to send:\r\n1st Input-Box - The "&Chr(39)&"Command / Keys"&Chr(39)&" to send. (Look At Help->Sending Functions)\r\n2nd Input-Box - The "&Chr(39)&"Stroke Delay"&Chr(39)&" for current key send!\r\n3nd Input-Box - The "&Chr(39)&"Send Delay"&Chr(39)&" after that current "&Chr(39)&"Command / Keys"&Chr(39)&"!\r\n\r\nIE Hidden Mode - in case you'r trying to automate a router reconnection\r\n-this will use the first input-box as the router address to connect to!\r\n-the rest of the input-boxes will be used as normal sending functions!\r\nHowever these send functions will be sent directly to the IE-page unless \r\nyou add the suffix "&Chr(34)&"^<^"&Chr(34)&" to the start! Eg: ^<^{TAB}{ENTER} that will be sent un-allocated! \r\n\r\nALL THE SENDING DELAYS/ STORKE DELAYS ARE IN MILISECCONDS!!!\r\n(That means 1000 is 1 second! and 60000 is 1 minute!)\r\n\r\n*You don"&Chr(39)&"t have to fill all fields, however each "&Chr(39)&"Command / Keys"&Chr(39)&" field operates\r\nwith their coresponding fields! (Not filled = 0!)\r\n\r\n[AutoRecord]\r\nOn this page you can either click on the "&Chr(39)&"Self-Input"&Chr(39)&" button and fill-in a hell\r\nlot of "&Chr(39)&"Commands / Keys"&Chr(39)&" OR you can record a complete macro to be used.\r\n\r\nMouse Record - When enabled each mouse click you"&Chr(39)&"ll press will be recorded.\r\n\r\nKeyboard Record - When enable each key you"&Chr(39)&"ll press will be recorded.\r\n\r\nRecord! - This button will start the recording application which will appear in the\r\nTray manue. The choosen devices checked will be recorded from then on.\r\n\r\n*Note that the Icon on the Tray-manu at start is blinking and only after the first\r\naction the recording session will begin. Also in order to stop the current recording\r\nsession you"&Chr(39)&"ll have to click the Tray-Icon and choose Exit (The Recording\r\nSession can also be Paused in that manner!).\r\n\r\nSelf-Input - This button will Enable the Edit-Box above in which you should\r\nfill the chosen "&Chr(39)&"Commands / Keys"&Chr(39)&" to be sent.\r\n\r\n[START]\r\nWill run the macro chosen !!\r\n-NOTE: The Start Button Applies For That Page Currently Focused!"))
$TabPage2 = GUICtrlCreateTabItem("Sending Functions :")
$Edit3 = GUICtrlCreateEdit("", 4, 24, 577, 489)
GUICtrlSetData(-1, StringFormat("Send Command (NORMAL MODE ! NOT RAW SEND !) -> Resulting Keypress \r\n{!} ! \r\n{#} # \r\n{+} + \r\n{^} ^ \r\n{{} { \r\n{}} } \r\n{SPACE} SPACE \r\n{ENTER} ENTER key on the main keyboard \r\n{ALT} ALT \r\n{BACKSPACE} or {BS} BACKSPACE \r\n{DELETE} or {DEL} DELETE \r\n{UP} Up arrow \r\n{DOWN} Down arrow \r\n{LEFT} Left arrow \r\n{RIGHT} Right arrow \r\n{HOME} HOME \r\n{END} END \r\n{ESCAPE} or {ESC} ESCAPE \r\n{INSERT} or {INS} INS \r\n{PGUP} PageUp \r\n{PGDN} PageDown \r\n{F1} - {F12} Function keys \r\n{TAB} TAB \r\n{PRINTSCREEN} Print Screen key \r\n{LWIN} Left Windows key \r\n{RWIN} Right Windows key \r\n{NUMLOCK on} NUMLOCK (on/off/toggle) \r\n{CAPSLOCK off} CAPSLOCK (on/off/toggle) \r\n{SCROLLLOCK toggle} SCROLLLOCK (on/off/toggle) \r\n{CTRLBREAK} Ctrl+Break \r\n{PAUSE} PAUSE \r\n{NUMPAD0} - {NUMPAD9} Numpad digits \r\n{NUMPADMULT} Numpad Multiply \r\n{NUMPADADD} Numpad Add \r\n{NUMPADSUB} Numpad Subtract \r\n{NUMPADDIV} Numpad Divide \r\n{NUMPADDOT} Numpad period \r\n{NUMPADENTER} Enter key on the numpad \r\n{APPSKEY} Windows App key \r\n{LALT} Left ALT key \r\n{RALT} Right ALT key \r\n{LCTRL} Left CTRL key \r\n{RCTRL} Right CTRL key \r\n{LSHIFT} Left Shift key \r\n{RSHIFT} Right Shift key \r\n{SLEEP} Computer SLEEP key \r\n{ALTDOWN} Holds the ALT key down until {ALTUP} is sent \r\n{SHIFTDOWN} Holds the SHIFT key down until {SHIFTUP} is sent \r\n{CTRLDOWN} Holds the CTRL key down until {CTRLUP} is sent \r\n{LWINDOWN} Holds the left Windows key down until {LWINUP} is sent \r\n{RWINDOWN} Holds the right Windows key down until {RWINUP} is sent \r\n{ASC nnnn} Send the ALT+nnnn key combination \r\n{BROWSER_BACK} 2000/XP Only: Select the browser "&Chr(34)&"back"&Chr(34)&" button \r\n{BROWSER_FORWARD} 2000/XP Only: Select the browser "&Chr(34)&"forward"&Chr(34)&" button \r\n{BROWSER_REFRESH} 2000/XP Only: Select the browser "&Chr(34)&"refresh"&Chr(34)&" button \r\n{BROWSER_STOP} 2000/XP Only: Select the browser "&Chr(34)&"stop"&Chr(34)&" button \r\n{BROWSER_SEARCH} 2000/XP Only: Select the browser "&Chr(34)&"search"&Chr(34)&" button \r\n{BROWSER_FAVORITES} 2000/XP Only: Select the browser "&Chr(34)&"favorites"&Chr(34)&" button \r\n{BROWSER_HOME} 2000/XP Only: Launch the browser and go to the home page \r\n{VOLUME_MUTE} 2000/XP Only: Mute the volume \r\n{VOLUME_DOWN} 2000/XP Only: Reduce the volume \r\n{VOLUME_UP} 2000/XP Only: Increase the volume \r\n{MEDIA_NEXT} 2000/XP Only: Select next track in media player \r\n{MEDIA_PREV} 2000/XP Only: Select previous track in media player \r\n{MEDIA_STOP} 2000/XP Only: Stop media player \r\n{MEDIA_PLAY_PAUSE} 2000/XP Only: Play/pause media player \r\n{LAUNCH_MAIL} 2000/XP Only: Launch the email application \r\n{LAUNCH_MEDIA} 2000/XP Only: Launch media player \r\n{LAUNCH_APP1} 2000/XP Only: Launch user app1 \r\n{LAUNCH_APP2} 2000/XP Only: Launch user app2 "))
$TabPage3 = GUICtrlCreateTabItem("Examples:")
$Edit2 = GUICtrlCreateEdit("", 4, 24, 577, 489)
GUICtrlSetData(-1, StringFormat(Chr(39)&"The Bot"&Chr(39)&" can send all ASCII and Extended ASCII characters (0-255), \r\nto send UNICODE characters you must use the "&Chr(34)&"ASC"&Chr(34)&" option and the code \r\nof the character you wish to send (see {ASC} at the bottom of the table below).\r\nCharacters are sent as written with the exception of the following characters:\r\n"&Chr(39)&"!"&Chr(39)&"\r\nThis tells "&Chr(39)&"The Bot"&Chr(39)&" to send an ALT keystroke, therefore Send("&Chr(34)&"This is text!a"&Chr(34)&")\r\nwould send the keys "&Chr(34)&"This is text"&Chr(34)&" and then press "&Chr(34)&"ALT+a"&Chr(34)&".\r\n\r\nN.B. Some programs are very choosy about capital letters and ALT keys,\r\ni.e. "&Chr(34)&"!A"&Chr(34)&" is different to "&Chr(34)&"!a"&Chr(34)&". The first says ALT+SHIFT+A, the second is ALT+a.\r\nIf in doubt, use lowercase!\r\n\r\n"&Chr(39)&"+"&Chr(39)&"\r\nThis tells "&Chr(39)&"The Bot"&Chr(39)&" to send a SHIFT keystroke, therefore Send("&Chr(34)&"Hell+o"&Chr(34)&")\r\nwould send the text "&Chr(34)&"HellO"&Chr(34)&". Send("&Chr(34)&"!+a"&Chr(34)&") would send "&Chr(34)&"ALT+SHIFT+a"&Chr(34)&".\r\n\r\n"&Chr(39)&"^"&Chr(39)&"\r\nThis tells "&Chr(39)&"The Bot"&Chr(39)&" to send a CONTROL keystroke, therefore Send("&Chr(34)&"^!a"&Chr(34)&")\r\nwould send "&Chr(34)&"CTRL+ALT+a"&Chr(34)&".\r\n\r\nN.B. Some programs are very choosy about capital letters and CTRL keys,\r\ni.e. "&Chr(34)&"^A"&Chr(34)&" is different to "&Chr(34)&"^a"&Chr(34)&". The first says CTRL+SHIFT+A, the second is CTRL+a.\r\nIf in doubt, use lowercase!\r\n\r\n"&Chr(39)&"#"&Chr(39)&"\r\nThe hash now sends a Windows keystroke; therefore, Send("&Chr(34)&"#r"&Chr(34)&")\r\nwould send Win+r which launches the Run dialog box.\r\n\r\nif a user is holding down the Shift key when a Send function begins,\r\ntext may be sent in uppercase. One workaround is to {SHIFTDOWN}{SHIFTUP}\r\nbefore the other Send operations.\r\n\r\nCertain keyboard as the Czech one send different characters when using \r\nthe Shift Key or being in CAPS LOCK enabled and sending a char. Due to \r\nthe send "&Chr(39)&"The Bot"&Chr(39)&" implementation the CAPS LOCKed char will be sent as\r\nShifted one so it will not work.\r\n\r\nTo send the ASCII value A (same as pressing ALT+065 on the numeric keypad)\r\n{ASC 065} (When using 2 digit ASCII codes you must use a leading 0, \r\notherwise an obsolete 437 code page is used)."))
$TabPage4 = GUICtrlCreateTabItem("Example #2:")
GUICtrlSetState(-1,$GUI_SHOW)
$Edit1 = GUICtrlCreateEdit("", 4, 24, 577, 489)
GUICtrlSetData(-1, StringFormat("To send UNICODE characters enter the character code (decimal or hex),\r\nfor example this sends a Chinese character {ASC 2709} or {ASC 0xA95}\r\n\r\nSingle keys can also be repeated, e.g.\r\n    {DEL 4} ;Presses the DEL key 4 times\r\n    {S 30} ;Sends 30 "&Chr(39)&"S"&Chr(39)&" characters\r\n    +{TAB 4} ;Presses SHIFT+TAB 4 times\r\n-The key will be send at least once even if the count is zero.\r\n\r\nTo hold a key down (generally only useful for games)\r\n    {a down} ;Holds the A key down\r\n    {a up} ;Releases the A key\r\n\r\nTo set the state of the capslock, numlock and scrolllock keys\r\n    {NumLock on} ;Turns the NumLock key on\r\n    {CapsLock off} ;Turns the CapsLock key off\r\n    {ScrollLock toggle} ;Toggles the state of ScrollLock\r\n\r\nMost laptop computer keyboards have a special Fn key.\r\nThis key cannot be simulated.\r\n\r\nFor example, open Folder Options (in the control panel) and try the following:\r\n{TAB} Navigate to next control (button, checkbox, etc)  \r\n+{TAB} Navigate to previous control.  \r\n^{TAB} Navigate to next WindowTab (on a Tabbed dialog window)  \r\n^+{TAB} Navigate to previous WindowTab.  \r\n{SPACE} Can be used to toggle a checkbox or click a button.  \r\n{+} Usually checks a checkbox (if it"&Chr(39)&"s a "&Chr(34)&"real"&Chr(34)&" checkbox.)  \r\n{-} Usually unchecks a checkbox.  \r\n{NumPadMult} Recursively expands folders in a SysTreeView32. \r\n\r\nUse Alt-key combos to access menu items. Also, open Notepad and try the\r\nfollowing: !f Or Alt+f, the access key for Notepad"&Chr(39)&"s file menu. Try other letters!\r\n\r\n{DOWN} Move down a menu.  \r\n{UP} Move up a menu.  \r\n{LEFT} Move leftward to new menu or expand a submenu.  \r\n{RIGHT} Move rightward to new menu or collapse a submenu.  \r\nSee Windows"&Chr(39)&" Help--press Win+F1--for a complete list of keyboard shortcuts\r\nif you don"&Chr(39)&"t know the importance of Alt+F4, PrintScreen, Ctrl+C, and so on.\r\n\r\nNote, USING THE RAW MODE WILL DIABLE ALL OF THE ABOVE!.\r\nThis is useful when you want to send some text copied from a variable and you want \r\nthe text sent exactly as written."))
GUICtrlCreateTabItem("")
$HelpClose = GUICtrlCreateButton("Close", 212, 524, 137, 21, 0)
#EndRegion ### END Koda GUI section ###
;========================================[VARIABLES]
Global $RunInBckg = 0
Dim $RecCode[21] = ["",7728,7729,7730,7731,7732,7984,7985,7986,7987,7988,8240,8241,8242,8243,8244,8496,8497,9008,3632,3633]
Dim $NormVerb[21] = ["","LD","RD","MD",7731,7732,"LU","RU","MU",7987,7988,"LW","RW","MW",8243,8244,"WU","WD",9008,"KD","KU"]
Dim $MacroTDL[11] = ["",$Macro1TD,$Macro2TD,$Macro3TD,$Macro4TD,$Macro5TD,$Macro6TD,$Macro7TD,$Macro8TD,$Macro9TD,$Macro10TD]
Dim $MacroSDL[11] = ["",$Macro1SD,$Macro2SD,$Macro3SD,$Macro4SD,$Macro5SD,$Macro6SD,$Macro7SD,$Macro8SD,$Macro9SD,$Macro10SD]
Dim $MacroInputL[11] = ["",$MacroInput1,$MacroInput2,$MacroInput3,$MacroInput4,$MacroInput5,$MacroInput6,$MacroInput7,$MacroInput8,$MacroInput9,$MacroInput10]
Dim $SpecialCodes[43] = ["","10","11","12","C0","09","14","20","26","28","25","27","BD","BB","2D","24","21","22","23","2E","70","71","72","73","74","75","76","77","78","79","7A","7B","2C","91","13","DB","DD","DC","BA","DE","BC","BE","BF"]
Dim $SpecialChars[43] = ["","SHIFT","CTRL","ALT","{ASC 39}","{TAB}","{CAPSLOCK}","{SPACE}","{UP}","{DOWN}","{LEFT}","{RIGHT}","{-}","{ASC 61}","{INSERT}","{HOME}","{PGUP}","{PGDN}","{END}","{DELETE}","{F1}","{F2}","{F3}","{F4}","{F5}","{F6}","{F7}","{F8}","{F9}","{F10}","{F11}","{F12}","{PRINTSCREEN}","{NUMLOCK}","{PAUSE}","{ASC 91}","{ASC 93}","{ASC 92}","{ASC 59}","{ASC 39}","{ASC 44}","{ASC 46}","{ASC 47}"]
Dim $KeyDown[1]
Global $HideNavigate,$HideNavigateTest,$oIEhwnd,$oIE,$Sendmode,$selftype,$HelpStat,$BotRunning,$MacroRunCount,$SpamRunCount,$RunCount,$SCount,$IgnoreExit,$SendDC,$ScountSet,$TrayCreated,$TrayCountExit,$TrayCount,$bcgexitTimer,$bcgexit,$bcgstart,$bcgwait,$StatusLSet,$persistant,$persistantTimer,$persistantWait,$persistantBGW = 0
Global $BotMode = "N/A"
Global $BcgExitTime = 10000
Global $persistantRetryTime = 7000
Global $MacroFile = IniRead(@ScriptDir&"\S&M bot.cfg","Settings:","LastMacro",@ScriptDir&"\S&M bot.mcro")
Global $IP = _GetIP()
Global $NewIP = $IP
HotKeySet("{ESC}","GoAway")
LoadMacro()

If $RunInBckg = 1 Then
	If $BotMode = "N/A" Then 
		$BotMode = IniRead(@ScriptDir&"\S&M bot.cfg","Settings:","LastMacroMode","N/A")
		MsgBox(4144,Chr(153)&" Spam And Macro Bot "&$Version,"Failed to recognize the last running macro page."&@CRLF&"(You must run the macro at least once for that mode to work)")
	Else
		$bcgstart = 1
		StartOperation()
	EndIf
EndIf

While 1
	$gMsg = TrayGetMsg()
	$nMsg = GUIGetMsg()
	If $TrayCountExit = 1 Then
		$TrayCount = $TrayCount +1
		If $TrayCount = 20 Then
			ByeBye()
		EndIf
	EndIf
	
	If $RunInBckg = 1 And $bcgexit = 1 Then
		$diff = TimerDiff($bcgexitTimer)
		$wait = Ceiling(($BcgExitTime-$diff)/1000)
		If $wait <> $bcgwait Then
		$bcgwait = $wait
		$StatusLSet = 1
		GUICtrlSetColor($StatusL, 0x4111FF)
		GUICtrlSetData($StatusL," Closing application in: "&$wait&' secs. To abort Uncheck "'&"Auto'run at Startup"&'" !')
		EndIf
		If $diff >= $BcgExitTime Then ByeBye()
	EndIf
		
	If $persistant = 1 And $persistantTimer <> 0 Then
		$diff = TimerDiff($persistantTimer)
		$persistantWait = Ceiling(($persistantRetryTime-$diff)/1000)
		If $persistantWait <> $persistantBGW Then
			$persistantBGW = $persistantWait
			$StatusLSet = 1
			GUICtrlSetColor($StatusL, 0x4111FF)
			GUICtrlSetData($StatusL," Retrying in: "&$persistantWait&' secs. To abort Uncheck "'&"IP Check"&'" !')
		EndIf
		If $diff >= $persistantRetryTime Then
			$persistantTimer = 0
			StartOperation()
		EndIf
	EndIf
	
	If $gMsg <> 0 Then
		$BotRunning = 0
		TraySetState (5)
		If $RunInBckg = 0 Then Return
		If $TrayCountExit = 1 Then
			$TrayCountExit = 0
		Else
			$TrayCountExit = 1
		EndIf
	EndIf
	
	Select
		;===============================[EXIT/HELP]
		Case $nMsg = $GUI_EVENT_CLOSE
			If $HelpStat=1 Then
				GUISetState(@SW_HIDE,$HelpForm)
				$HelpStat = 0
			ElseIf $BotRunning = 1 Then
			StopOperation(3)
			Else
				ByeBye()
			EndIf
		Case $nMsg = $HelpClose
			$HelpStat = 0
			GUISetState(@SW_HIDE,$HelpForm)
		Case  $nMsg = $HelpB
			$HelpStat = 1
			GUISetState(@SW_SHOW,$HelpForm)
		Case $nMsg = $ExitB
			ByeBye()
		
		;===============================[RUN]
		Case $nMsg = $StartB
			If $BotMode = 2 And $HideNavigate=1 Then
			$ret = MsgBox(4132,Chr(153)&" Spam And Macro Bot "&$Version,"Would you like to run a visible test now?")
				If $ret = 6 Then
					$HideNavigateTest = 1
				Else
					$HideNavigateTest = 0
				EndIf
			EndIf
			If $BotRunning = 0 Then
				 IniWrite(@ScriptDir&"\S&M bot.cfg","Settings:","LastMacroMode",$BotMode)
				StartOperation()
			Else
				StopOperation(3)
			EndIf
			
		Case $BotRunning = 1
			CMDRun()
		;===============================[TABS]
		
		Case $nMsg = $Tab1
			If GUICtrlRead($Tab1) = 0 Then
				GUICtrlSetState($StartB,$GUI_ENABLE)
				$BotMode = 1
			ElseIf GUICtrlRead($Tab1) = 1 Then
				GUICtrlSetState($StartB,$GUI_ENABLE)
				$BotMode = 2
			ElseIf GUICtrlRead($Tab1) = 2 Then
				GUICtrlSetState($StartB,$GUI_DISABLE)
			EndIf
		;===============================[TEXT]
		Case $nMsg = $RecStartB
			Record()
		Case $nMsg = $SelfInput
			SelfTypeMode()
		Case $nMsg = $TextClear
			GUICtrlSetData($MacroEdit,"")
		;===============================[MACRO]
		Case $nMsg = $MacroClearB
			CleanMacro()
		Case $nMsg = $IENavHiddenCB
			If GUICtrlRead($IENavHiddenCB) = $GUI_CHECKED Then
				$HideNavigate = 1
			Else
				$HideNavigate = 0
			EndIf
		;===============================[OPTIONS]
		Case $nMsg = $AutorunCB ; Status - 1!
			If $StatusLSet = 1 Then
			$StatusLSet = 0
			GUICtrlSetData($StatusL,$StatusLable)
			GUICtrlSetFont($StatusL, 4, 400, 0, "MS Sans Serif")
			GUICtrlSetColor($StatusL, 0xF8A1FF)
			EndIf
			If GUICtrlRead($AutorunCB) = $GUI_CHECKED Then
				$RunInBckg = 1
			Else
				$RunInBckg = 0
			EndIf
		Case $nMsg = $RawCB
			If GUICtrlRead($RawCB) = $GUI_CHECKED Then
				$Sendmode = 1
			Else
				$Sendmode = 0
			EndIf
		Case $nMsg = $IPCB
			If GUICtrlRead($IPCB) = $GUI_CHECKED Then
				$persistant = 1
			Else
				$persistant = 0
			EndIf
		Case $nMsg = $MouseSpeed
			$MoveSpeed = GUICtrlRead($MouseSpeed)
			GUICtrlSetData($LabelMouse,$mousespeedL&$MoveSpeed&"%)")
		Case $nMsg = $SaveB
			SaveMacro()
		Case $nMsg = $LoadB
			$savedir = IniRead(@ScriptDir&"\S&M bot.cfg","Macros:","LastSavedDir",@ScriptDir)
			$macrosave = $MacroFile
			$MacroFile = FileOpenDialog("Choose a macro to be loaded:",$savedir,"Saved Macros (*.mcro)",11,$MacroFile)
			If FileExists($MacroFile) <> 1 Then $MacroFile = $macrosave
			LoadMacro()
	EndSelect
WEnd

Func CMDRun()
If $BotRunning = 0 Then Return
$RunCount = $RunCount + 1
	;MsgBox(0,"$RunCount = $SCount",$RunCount&" = "&$SCount)
	If $RunCount <= $SCount Then
		If $RunCount = 1 Or IsInt($RunCount/$SendDC)= 1 Then
		sleep(GUICtrlRead($SendDelayInput))
		EndIf
		;MsgBox(0,"$BotMode",$BotMode)
		If $BotMode = 1 Then
			SpamPageRun()
		ElseIf $BotMode = 2 Then
			MacroPageRun()
		Else
			Return
		EndIf
	Else
		StopOperation(0)
	EndIf
EndFunc

Func SpamPageRun()
If $BotRunning = 0 Then Return
	;MsgBox(0,"$selftype",$selftype)
	If $selftype = 1 Then
		Opt("SendKeyDelay", GUICtrlRead($StrokeDelayInput)) 
		Send(GUICtrlRead($MacroEdit),$Sendmode)
		sleep(GUICtrlRead($SendDelayInput))
	Else
		If FileExists($MacroFile) <> 1 Then
			If $RunInBckg = 1 Then 	
				MsgBox(4144,Chr(153)&" Spam And Macro Bot "&$Version,"No Recorded Macro Found!"&@CRLF&"(You must save a macro before running the Autorun on startup mode!)")
			Else
				MsgBox(4144,Chr(153)&" Spam And Macro Bot "&$Version,"No Recorded Macro Found!"&@CRLF&"(Please load or record a macro first!)")
			EndIf
			Return
		Else
		ReadRec()
		EndIf
	EndIf
EndFunc

Func ReadRec()
$SS=0
If $BotRunning = 0 Then Return
$SpamRunCount = $SpamRunCount+1
$i = $SpamRunCount
$Commands = IniReadSection($MacroFile,"Recorded")
;_ArrayDisplay($Commands,"$Commands")
SCountSet($Commands[0][0])
	if $i <= $Commands[0][0] Then
	If $i = $Commands[0][0] Then $SpamRunCount = 0
		;MsgBox(0,"Current Command:",$Commands[$i][1])
		$Array = StringSplit($Commands[$i][1],"|")
		;_ArrayDisplay($Array,"Function ($Array):")
		If $array[1] = "M" Then ;M|7728|402|459|2129
		sleep($array[5])
		;MsgBox(0,"Mouse","IN")
		$loc = _ArraySearch($RecCode,$array[2])
		$Mbutton = StringLeft($NormVerb[$loc],1)
		$Mfunc = StringRight($NormVerb[$loc],1)
		;MsgBox(0,"Mouse Data:","Loc:"&$array[3]&","&$array[4]&" B:"&$Mbutton&" F:"&$Mfunc)
		MouseMove($array[3],$array[4],$MoveSpeed)
		If $BotRunning = 0 Then Return
			If $Mfunc = "D" Then
				If $Mbutton = "M" Then
					MouseDown("middle")
				ElseIf $Mbutton = "R" Then
					MouseDown("right")
				ElseIf $Mbutton = "L" Then
					MouseDown("left")
				ElseIf $Mbutton = "W" Then
					MouseWheel("down")
				EndIf
			ElseIf $Mfunc = "U" Then
				If $Mbutton = "M" Then
					MouseUp("middle")
				ElseIf $Mbutton = "R" Then
					MouseUp("right")
				ElseIf $Mbutton = "L" Then
					MouseUp("left")
				ElseIf $Mbutton = "W" Then
					MouseWheel("up")
				EndIf
			ElseIf $Mfunc = "W" Then
				If $Mbutton = "M" Then
					MouseClick("middle",$array[3],$array[4],2,10)
				ElseIf $Mbutton = "R" Then
					MouseClick("right",$array[3],$array[4],2,10)
				ElseIf $Mbutton = "L" Then
					MouseClick("left",$array[3],$array[4],2,10)
				EndIf
			$SpamRunCount = $SpamRunCount+1
			EndIf
		ElseIf $array[1] = "K" Then ;K|0x00000048|8590
			sleep($array[3])
			$stringstrip = StringRight($array[2],2)
			$loc = _ArraySearch($SpecialCodes,$stringstrip)
			If $loc <> -1 Then
				If $loc <2 Then
					;MsgBox(0,"","SS1")
					$SS = 1
				ElseIf $loc>2 Then
					;MsgBox(0,"","SS2")
					$SS = 2
				EndIf
			EndIf
		
			If $stringstrip = "1B" Then $IgnoreExit = 1
			$i = Chr(Dec($stringstrip))
			;MsgBox(0,"",$i)
			;_ArrayDisplay($KeyDown,"Before")
			If $BotRunning = 0 Then Return
			$Position =  _ArraySearch($KeyDown,$array[2])
			If $Position = -1 Then
				_ArrayAdd($KeyDown,$array[2])
				;MsgBox(0,"","Down")
				If $SS = 1 then
					;MsgBox(0,"","{"&$SpecialChars[$loc]&"UP}")
					Send("{"&$SpecialChars[$loc]&"DOWN}")
				ElseIf $SS = 2 Then
					;MsgBox(0,"","Skipping "&$SpecialChars[$loc])
				Else
					Send("{"&$i&" down}")
				EndIf
			Else
				_ArrayDelete($KeyDown,$Position)
				;MsgBox(0,"","Up")
				If $SS = 1 then
					;MsgBox(0,"","{"&$SpecialChars[$loc]&"UP}")
					Send("{"&$SpecialChars[$loc]&"UP}")
				ElseIf $SS = 2 Then
					;MsgBox(0,"",$SpecialChars[$loc])
					Send($SpecialChars[$loc])
				Else
					Send("{"&$i&" up}")
				EndIf
			EndIf
			;_ArrayDisplay($KeyDown,"After")
		EndIf
	Else
		StopOperation(1)
	EndIf
EndFunc

Func MacroPageRun()
If $BotRunning = 0 Then Return
SCountSet(10)
$MacroRunCount = $MacroRunCount + 1
$i = $MacroRunCount
	If $i <= 10 then
	If $i = 10 Then $MacroRunCount = 0
		$MacroCmd = GUICtrlRead($MacroInputL[$i])
		If $MacroCmd = "" Then Return
		$CmdSendDelay = GUICtrlRead($MacroTDL[$i])
		$CmdStrokeDelay = GUICtrlRead($MacroSDL[$i])
		Opt("SendKeyDelay", $CmdStrokeDelay)
			If StringInStr($MacroCmd,"{ESC}")<>0 Then
				$IgnoreExit = 1
			EndIf
		If $HideNavigate=1 Then
			;MsgBox(0,"Debug","HideNavigating Present!")		
			If $i = 1 Then
				;MsgBox(0,"Debug","first inputbox - opening ie hidden")
				If $HideNavigateTest = 1 Then
					$oIE = _IECreate($MacroCmd,0,1,0)
					Sleep($CmdSendDelay)
				Else
					$oIE = _IECreate($MacroCmd,0,0,0)
					Sleep($CmdSendDelay)
				EndIf
				Opt("WinTitleMatchMode", 4)
				$oIEhwnd = _IEPropertyGet($oIE, "hwnd")
				If $oIEhwnd = 0 Then Return MsgBox(4144,Chr(153)&" Spam And Macro Bot "&$Version," Program Error:"&@CRLF&"coudn't find the IE process!")
				;MsgBox(0,"Debug","Operation Done!")
			Else
				;MsgBox(0,"Debug","Sending Keys: "&$Sendmode)
				If StringLeft($MacroCmd,3)="^<^" Then 
					$MacroCmd = StringTrimLeft($MacroCmd,3)
					Send($MacroCmd,$Sendmode)
					sleep($CmdSendDelay)
				Else
					$ret = ControlSend($oIEhwnd, "", "Internet Explorer_Server1", $MacroCmd,$Sendmode)
					If $ret = 0 Then Return MsgBox(4144,Chr(153)&" Spam And Macro Bot "&$Version," Program Error:"&@CRLF&"coudn't send keys to the control!")
					sleep($CmdSendDelay)
				EndIf
				;MsgBox(0,"Debug","Done!")
			EndIf
		Else
			;MsgBox(0,"Debug","sending normal")
			Send($MacroCmd,$Sendmode)
		EndIf
		sleep($CmdSendDelay)
	Else
		_IEQuit($oIE)
		StopOperation(2)
	EndIf
EndFunc

Func StartOperation()
GUICtrlSetData($StatusL,$StatusLable)
GUICtrlSetFont($StatusL, 4, 400, 0, "MS Sans Serif")
GUICtrlSetColor($StatusL, 0xF8A1FF)
$RunCount = 0
$SpamRunCount = 0
$MacroRunCount = 0
$SCount = int(GUICtrlRead($SendCountInput))
If $SCount < 1 Then $SCount = 1
;MsgBox(0,"","Start "&$SCount)
$BotRunning = 1
GUICtrlSetData($StartB,"Stop!")
GUISetState(@SW_HIDE,$SpamBot)
TrayCreate()
EndFunc

Func SCountSet($i)
;MsgBox(0,"ScountSet: $ScountSet",$ScountSet&" | "&$i)
If $ScountSet = 1 then Return
$SCount = $SCount*$i
$SendDC = $i
$ScountSet = 1
EndFunc

Func ResumeMacro()
$BotRunning = 1
TraySetState (1)
EndFunc

Func StopOperation($call)
If IsDeclared("call") = 0 Then $call = 3
;Dim $calls[5] = ["Main Internal Loop","Reading Func","Macro Func","TrayClicked","HotKey"]
;MsgBox(0,"",$calls[$call])
$BotRunning = 0
GUICtrlSetData($StartB,"Start!")
$ScountSet = 0
TraySetState (2)
GUISetState(@SW_SHOW,$SpamBot)
GUISetState(@SW_RESTORE,$SpamBot)
If $call = 3 Then $bcgstart = 0
	If $RunInBckg = 1 And $bcgstart = 1 Then
		$bcgexit = 1
		$bcgexitTimer = TimerInit()
	Else
		Global $bcgexit,$bcgexitTimer,$RunInBckg,$bcgexit  = 0
	EndIf
	
	If $persistant = 1 And $call <> 3 Then
		If CheckIp($call) = 0 Then
		$persistantTimer = TimerInit()
		Return
		EndIf
	EndIf
EndFunc

;======================================================================================[Save/Load]
Func SaveMacro()
$filename = ""
While StringTrimRight($filename,5) = ""
$savefile = AskForFileName()
If $savefile = "N/A" Then Return
$filename = StringTrimLeft($savefile,StringInStr($savefile, "\",0,-1))
WEnd
IniWrite(@ScriptDir&"\S&M bot.cfg","Macros:","LastSavedFile",$filename)
IniWrite(@ScriptDir&"\S&M bot.cfg","Macros:","LastSavedDir",@WorkingDir)

	If FileExists(@ScriptDir&"\S&M bot.rec") = 1 Then
		FileCopy(@ScriptDir&"\S&M bot.rec",$savefile,9)
	Else
		If $selftype <> 1 And $BotMode=1 Then
		MsgBox(4144,Chr(153)&" Spam And Macro Bot "&$Version,"Failed to save recoreded macro to the specified loaction :"&@CRLF&$savefile&@CRLF&"(in case you've not Auto'Recorded any macro ignore that msg!)")
		EndIf
	EndIf
	
	IniWrite($savefile,"Settings:","RawSend",$Sendmode)
	IniWrite($savefile,"Settings:","IPCheck",$persistant)
	IniWrite($savefile,"Settings:","HideNavigate",$HideNavigate)
	IniWrite($savefile,"Settings:","SendCount",GUICtrlRead($SendCountInput))
	IniWrite($savefile,"Settings:","SendDelay",GUICtrlRead($SendDelayInput))
	IniWrite($savefile,"Settings:","StrokeDelay",GUICtrlRead($StrokeDelayInput))
	IniWrite($savefile,"Settings:","MouseSpeed",$MoveSpeed)
	If $BotMode = "N/A" Then MsgBox(4144,Chr(153)&" Spam And Macro Bot "&$Version,"It's not recommanded to save a macro before running it!"&@CRLF&"(In such a case, Auto'Run will function based on the previously ran operation mode!)")
	IniWrite($savefile,"Settings:","BotMode",$BotMode)
	IniWrite($savefile,"Settings:","SelfType",$selftype)

	IniWrite($savefile,"UserSelfInput",1,StringReplace(GUICtrlRead($MacroEdit),@CRLF,Chr(164)))
	For $i = 1 To 10
		IniWrite($savefile,"MacroInput",$i,GUICtrlRead($MacroInputL[$i]))
		IniWrite($savefile,"MacroSendDelay",$i,GUICtrlRead($MacroTDL[$i]))
		IniWrite($savefile,"MacroStrokeDelay",$i,GUICtrlRead($MacroSDL[$i]))
	Next
$MacroFile = $savefile
IniWrite(@ScriptDir&"\S&M bot.cfg","Settings:","LastMacro",$MacroFile)
EndFunc
Func AskForFileName()
$filename = IniRead(@ScriptDir&"\S&M bot.cfg","Macros:","LastSavedFile","S&M bot")
$savedir = IniRead(@ScriptDir&"\S&M bot.cfg","Macros:","LastSavedDir",@ScriptDir)
$return = FileSaveDialog("Where do you want to save the macro:",$savedir,"Saved Macros (*.mcro)",16,$filename)
	If @error Then
		Return "N/A"
	Else
		If StringRight($return,5) <> ".mcro" Then $return = $return&".mcro"
		Return $return
	EndIf
EndFunc
Func LoadMacro()
	;-------------------[OPTIONS]
	$RunInBckg = IniRead(@ScriptDir&"\S&M bot.cfg","Settings:","AutoRun",0)
	If $RunInBckg = 1 Then
		GUICtrlSetState($AutorunCB,$GUI_CHECKED)
	Else
		GUICtrlSetState($AutorunCB,$GUI_UNCHECKED)
	EndIf
	$Sendmode = IniRead($MacroFile,"Settings:","RawSend",0)
	If $Sendmode = 1 Then
		GUICtrlSetState($RawCB,$GUI_CHECKED)
	Else
		GUICtrlSetState($RawCB,$GUI_UNCHECKED)
	EndIf
	$persistant = IniRead($MacroFile,"Settings:","IPCheck",0)
	If $persistant = 1 Then
		GUICtrlSetState($IPCB,$GUI_CHECKED)
	Else
		GUICtrlSetState($IPCB,$GUI_UNCHECKED)
	EndIf
	$HideNavigate = IniRead($MacroFile,"Settings:","HideNavigate",0)
	If $HideNavigate = 1 Then
		GUICtrlSetState($IENavHiddenCB,$GUI_CHECKED)
	Else
		GUICtrlSetState($IENavHiddenCB,$GUI_UNCHECKED)
	EndIf
	GUICtrlSetData($SendCountInput,IniRead($MacroFile,"Settings:","SendCount",1))
	GUICtrlSetData($SendDelayInput,IniRead($MacroFile,"Settings:","SendDelay",4000))
	GUICtrlSetData($StrokeDelayInput,IniRead($MacroFile,"Settings:","StrokeDelay",170))
	$MoveSpeed = IniRead($MacroFile,"Settings:","MouseSpeed",$MoveSpeed)
	GUICtrlSetData($MouseSpeed,$MoveSpeed)
	GUICtrlSetData($LabelMouse,$mousespeedL&$MoveSpeed&"%)")
	;-------------------[EditBox]
	GUICtrlSetData($MacroEdit,StringFormat(StringReplace(IniRead($MacroFile,"UserSelfInput",1,"Input Text In Here,\r\n(View Options -> Help, For extra Info !!!)\r\nOr Use The Macro Recorder !"),Chr(164),@CRLF)))
	
	;-------------------[MacroPage]
	For $i = 1 To 10
		GUICtrlSetData($MacroInputL[$i],IniRead($MacroFile,"MacroInput",$i,""))
		GUICtrlSetData($MacroTDL[$i],IniRead($MacroFile,"MacroSendDelay",$i,""))
		GUICtrlSetData($MacroSDL[$i],IniRead($MacroFile,"MacroStrokeDelay",$i,""))
	Next
	;-------------------[RunSettings!]
	$BotMode = IniRead($MacroFile,"Settings:","BotMode",$BotMode)
	$selftype = IniRead($MacroFile,"Settings:","SelfType",$selftype)
	If $selftype = 1 Then
		GUICtrlSetData($SelfInput,"Recorder")
		GUICtrlSetFont($SelfInput, 8, 800, 0, "MS Sans Serif")
		GUICtrlSetState($RecStartB,$GUI_DISABLE)
		GUICtrlSetState($KeysRecCB,$GUI_DISABLE)
		GUICtrlSetState($MouseRecCB,$GUI_DISABLE)
		GUICtrlSetState($MacroEdit,$GUI_ENABLE)
	Else
		GUICtrlSetData($SelfInput,"Self-Input")
		GUICtrlSetFont($SelfInput, 6, 400, 0, "MS Sans Serif")
		GUICtrlSetState($MacroEdit,$GUI_DISABLE)
		GUICtrlSetState($RecStartB,$GUI_ENABLE)
		GUICtrlSetState($KeysRecCB,$GUI_ENABLE)
		GUICtrlSetState($MouseRecCB,$GUI_ENABLE)
	EndIf
EndFunc

;======================================================================================[TERMINALS]
Func GoAway()
If $BotRunning = 0 Then Return
	If $IgnoreExit = 1 Then
		$IgnoreExit = 0
		Return
	Else
		StopOperation(4)
	EndIf
EndFunc

Func TrayCreate()
	If $TrayCreated = 0 Then
		$TrayCreated = 1
		Opt("TrayOnEventMode",1)
		Opt("TrayMenuMode",1)	; Default tray menu items (Script Paused/Exit) will not be shown.
		$infoitem = TrayCreateItem("Stop Macro!")
		TrayItemSetOnEvent(-1,"StopOperation")
		$exititem = TrayCreateItem("Resume Macro")
		TrayItemSetOnEvent(-1,"ResumeMacro")
		TraySetIcon("fkeyz.ico")
		TraySetToolTip ("Dear user, click here to pause the macro!!!")
		TrayTip("Macro Recorder "&$Version&" (SK)","Dear user, click here to pause the macro!!!"&@CRLF&"(To restore the application Interface Choose Stop Macro!)",3)
	EndIf
TraySetState (1)
EndFunc
Func CleanMacro()
	For $i = 1 To 10
		guictrlsetdata($MacroTDL[$i],"")
		guictrlsetdata($MacroSDL[$i],"")
		guictrlsetdata($MacroInputL[$i],"")
	Next
EndFunc
Func ByeBye()
IniWrite(@ScriptDir&"\S&M bot.cfg","Settings:","LastMacro",$MacroFile)
IniWrite(@ScriptDir&"\S&M bot.cfg","Settings:","AutoRun",$RunInBckg)
Exit
EndFunc

Func SelfTypeMode()
If $selftype = 0 Then
	GUICtrlSetData($SelfInput,"Recorder")
	GUICtrlSetFont($SelfInput, 8, 800, 0, "MS Sans Serif")
	GUICtrlSetState($RecStartB,$GUI_DISABLE)
	GUICtrlSetState($KeysRecCB,$GUI_DISABLE)
	GUICtrlSetState($MouseRecCB,$GUI_DISABLE)
	GUICtrlSetState($MacroEdit,$GUI_ENABLE)
	$selftype = 1
Else
	GUICtrlSetData($SelfInput,"Self-Input")
	GUICtrlSetFont($SelfInput, 6, 400, 0, "MS Sans Serif")
	GUICtrlSetState($MacroEdit,$GUI_DISABLE)
	GUICtrlSetState($RecStartB,$GUI_ENABLE)
	GUICtrlSetState($KeysRecCB,$GUI_ENABLE)
	GUICtrlSetState($MouseRecCB,$GUI_ENABLE)
	$selftype = 0
EndIf
EndFunc
Func Record()
	$CMD = "'/SK' "
	$keyParam = ""
	$mouseParam = ""
	If GUICtrlRead($KeysRecCB) = $GUI_UNCHECKED Then $keyParam = "-K "
	If GUICtrlRead($MouseRecCB) = $GUI_UNCHECKED Then $mouseParam = "-M"
	$CmdParam = $keyParam&$mouseParam
	If StringLen($CmdParam)=5 Then
		MsgBox(4144,Chr(153)&" Spam And Macro Bot "&$Version,"No recording device choosen!")
		Return
	EndIf
	GUISetState(@SW_HIDE,$SpamBot)
	ShellExecuteWait("Macro Recorder v1.0.exe",$CMD&$CmdParam)
	GUISetState(@SW_SHOW,$SpamBot)
	GUISetState(@SW_RESTORE,$SpamBot)
	$MacroFile = @ScriptDir&"\S&M bot.rec"
EndFunc

Func CheckIp($call)
Sleep(3000)
$IP = $NewIP
$NewIP = _GetIP()
	If $NewIP <> $IP Then
		GUICtrlSetData($StatusL,"Current Ip: "&$NewIP&" Previous: "&$IP&" Success!")
		GUICtrlSetColor($StatusL, 0x4111FF)
		Sleep(1500)
		GUICtrlSetData($StatusL,$StatusLable)
		GUICtrlSetFont($StatusL, 4, 400, 0, "MS Sans Serif")
		GUICtrlSetColor($StatusL, 0xF8A1FF)
		Return 1
	Else
		If $call = 3 Then
			GUICtrlSetData($StatusL,"Current Ip: "&$NewIP&" Previous: "&$IP&" Failed!")
			GUICtrlSetColor($StatusL, 0x4111FF)
			Sleep(1500)
		Else
			GUICtrlSetData($StatusL,"Current Ip: "&$NewIP&" Previous: "&$IP&" Failed, Retrying!")
			GUICtrlSetColor($StatusL, 0x4111FF)
			Sleep(1500)
		EndIf
		Return 0
	EndIf
EndFunc
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-[GARBAGE BIN!]-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#cs

#ce