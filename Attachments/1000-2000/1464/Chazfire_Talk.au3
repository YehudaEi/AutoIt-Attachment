;===============================================================================
;#Region --- CodeWizard generated code Start ---
;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Default Button=Second, Icon=Warning, Modality=System Modal, Miscellaneous=Title/text right-justified
; Program Name:     ....N/A....
; Description:      Choose a computer on LAN/Workgruop and send message
; Requirement(s):   We'll 4 one a computer, then a network!
; Author(s):        ChazFire
; Thanks:	    Giuseppe Criaco <gcriaco@quipo.it> 4 msgboxeditor,CyberSlug 4 help on script
;
;===============================================================================
#include <GUIConstants.au3>
GUICreate ("GUI menu", 300, 200)
GUICtrlCreateLabel ("What do you want to say?", 10, 110, 150)
$TITLE = GUICtrlCreateInput ("!!!ENTER MESSAGE!!!", 5, 125, 290, 20)
GUICtrlSetState (-1, $GUI_FOCUS)
GUICtrlSetTip (-1, "...Type your message here...")
;
$filemenu = GuiCtrlCreateMenu ("File")
$fileitem = GuiCtrlCreateMenuitem ("Open...", $filemenu)
$recentfilesmenu = GuiCtrlCreateMenu ("Recent Files", $filemenu)
$separator1 = GuiCtrlCreateMenuitem ("", $filemenu)
$exititem = GuiCtrlCreateMenuitem ("Exit", $filemenu)
$helpmenu = GuiCtrlCreateMenu ("?")
$aboutitem = GuiCtrlCreateMenuitem ("About", $helpmenu)
$spambotmenu = GuiCtrlCreateMenu ("Spam")
$spambotmenuitem = GuiCtrlCreateMenuitem ("Open Spam Bot", $spambotmenu)
;$helpmenu2 = GuiCtrlCreateMenuitem ("help",$helpmenu)
$aboutitemhelp = GuiCtrlCreateMenuitem ("OMFG HELP", $helpmenu)
;Dim $avArray[1]
;
;
;
;
$optInfo01 = GUICtrlCreateRadio ("(01)", 10, 10, 50, 15)
$optInfo02 = GUICtrlCreateRadio ("(02)", 10, 30, 50, 15)
$optInfo03 = GUICtrlCreateRadio ("(03)", 10, 50, 50, 15)
$optInfo04 = GUICtrlCreateRadio ("(04)", 10, 70, 50, 15)
$optInfo05 = GUICtrlCreateRadio ("(05)", 10, 90, 50, 15)
;
$optInfo06 = GUICtrlCreateRadio ("(06)", 60, 10, 50, 15)
$optInfo07 = GUICtrlCreateRadio ("(07)", 60, 30, 50, 15)
$optInfo08 = GUICtrlCreateRadio ("(08)", 60, 50, 50, 15)
$optInfo09 = GUICtrlCreateRadio ("(09)", 60, 70, 50, 15)
$optInfo10 = GUICtrlCreateRadio ("(10)", 60, 90, 50, 15)
;
$optInfo11 = GUICtrlCreateRadio ("(11)", 110, 10, 50, 15)
$optInfo12 = GUICtrlCreateRadio ("(12)", 110, 30, 50, 15)
$optInfo13 = GUICtrlCreateRadio ("(13)", 110, 50, 50, 15)
$optInfo14 = GUICtrlCreateRadio ("(14)", 110, 70, 50, 15)
$optInfo15 = GUICtrlCreateRadio ("(15)", 110, 90, 50, 15)
;
$optInfo16 = GUICtrlCreateRadio ("(16)", 160, 10, 50, 15)
$optInfo17 = GUICtrlCreateRadio ("(17)", 160, 30, 50, 15)
$optInfo18 = GUICtrlCreateRadio ("(18)", 160, 50, 50, 15)
$optInfo19 = GUICtrlCreateRadio ("(19)", 160, 70, 50, 15)
$optInfo20 = GUICtrlCreateRadio ("(20)", 160, 90, 50, 15)
;
$spambutton = GuiCtrlCreateButton ("SEND", 210, 30, 70, 20)
$cancelbutton = GuiCtrlCreateButton ("Close", 210, 70, 70, 20)
GuiSetState ()
Global $selectedNumber = 0
While 1
        $msg = GUIGetMsg ()
        Select
                Case $msg = $GUI_EVENT_CLOSE Or $msg = $cancelbutton
                        ExitLoop
                Case $msg = $fileitem
                        $file = FileOpenDialog("Choose file...", @TempDir, "All (*.*)")
                        If @error <> 1 Then GuiCtrlCreateMenuItem ($file, $recentfilesmenu)
                Case $msg = $exititem
                        ExitLoop
                Case $msg >= Eval("optInfo01") And $msg <= Eval("optInfo20")
                        $selectedNumber = $msg - 12 ;subtract 12 to convert ctrlID# into number you want
                Case $msg = $spambutton
                        Dim $iMsgBoxAnswer
                        $iMsgBoxAnswer = MsgBox(36, "", "You'r about to send MESSAGE to USER, are you sure u want to continue?")
                        Select
                                Case $iMsgBoxAnswer = 6;Yes
                                        MsgBox(4096, "debug", $selectedNumber)
                                        $recipient = "lake" & $selectedNumber
                                        $message = """" & GuiCtrlRead ($TITLE) & """"
                                        Run("net send " & $recipient & " " & $message, "", @SW_HIDE) ;@SW_HIDE
                                        GuiCtrlSetData ($TITLE, "")
                                        GuiCtrlSetState ($TITLE, $GUI_FOCUS)
                                Case $iMsgBoxAnswer = 7;No
                        EndSelect
                Case $msg = $spambotmenuitem
                        Dim $iMsgBoxAnswer
                        $iMsgBoxAnswer = MsgBox(528692, "Convert to SpamBot?", "Do you wish to continue to ChazFire SpamBot v1.0?" & @CRLF & "")
                        Select
                                Case $iMsgBoxAnswer = 6 ;Yes
                                        MsgBox(4096, "debug spam switch proceed", "this is working! you clicked yes.")
										$ChildWin = GUICreate("SpamBot", 300, 200)	
												GUISetState(@SW_SHOW)
													$spamoptInfo01 = GUICtrlCreateCheckbox("(01)", 10, 10, 50, 15)
													$spamoptInfo02 = GUICtrlCreateCheckbox("(02)", 10, 30 ,50, 15)
													$spamoptInfo03 = GUICtrlCreateCheckbox("(03)", 10, 50, 50, 15,)
													$spamoptInfo04 = GUICtrlCreateCheckbox("(04)", 10, 70, 50, 15,)
													$spamoptInfo05 = GUICtrlCreateCheckbox("(05)", 10, 90, 50, 15,)
													;
													$spamoptInfo06 = GUICtrlCreateCheckbox("(06)", 60, 10, 50, 15,)
													$spamoptInfo07 = GUICtrlCreateCheckbox("(07)", 60, 30, 50, 15,)
													$spamoptInfo08 = GUICtrlCreateCheckbox("(08)", 60, 50, 50, 15,)
													$spamoptInfo09 = GUICtrlCreateCheckbox("(09)", 60, 70, 50, 15,)
													$spamoptInfo10 = GUICtrlCreateCheckbox("(10)", 60, 90, 50, 15,) 
													;
													$spamoptInfo11 = GUICtrlCreateCheckbox("(11)", 110, 10, 50, 15,)
													$spamoptInfo12 = GUICtrlCreateCheckbox("(12)", 110, 30, 50, 15,)
													$spamoptInfo13 = GUICtrlCreateCheckbox("(13)", 110, 50, 50, 15,)
													$spamoptInfo14 = GUICtrlCreateCheckbox("(14)", 110, 70, 50, 15,)
													$spamoptInfo15 = GUICtrlCreateCheckbox("(15)", 110, 90, 50, 15,)
													;
													$spamoptInfo16 = GUICtrlCreateCheckbox("(16)", 160, 10, 50, 15,)
													$spamoptInfo17 = GUICtrlCreateCheckbox("(17)", 160, 30, 50, 15,)
													$spamoptInfo18 = GUICtrlCreateCheckbox("(18)", 160, 50, 50, 15,)
													$spamoptInfo19 = GUICtrlCreateCheckbox("(19)", 160, 70, 50, 15,)
													$spamoptInfo20 = GUICtrlCreateCheckbox("(20)", 160, 90, 50, 15,)
													;
													$spambotbutton = GuiCtrlCreateButton ("SEND", 210, 30, 70, 20)
													$botcancelbutton = GuiCtrlCreateButton ("Close", 210, 70, 70, 20)
													
										MsgBox(4096, "debug spam switch cancel", "this is working! you clicked no.")
                        EndSelect
                        #EndRegion --- CodeWizard generated code End ---
                Case $msg = $aboutitemhelp
                        MsgBox(0, "OMFG HELP", "Choose user(s) to speak/spam to. Then type your message and click SPAM"); work damnit
                Case $msg = $aboutitem
                        MsgBox(0, "About", "Thanks to all who supported this d/l! Email me @ michaell428wak@hotmail.com         v1.0")
        EndSelect
Wend
GUIDelete ()
Exit