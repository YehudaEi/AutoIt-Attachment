#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Subhasish Bhattacharya

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
run("C:\Getbhavcopy_2.1.0a\Getbhavcopy.exe")
WinWaitActive("Getbhavcopy v2.1.0 by Hemen Kapadia")
Send("{TAB 3}")
Send("{ENTER}")
WinWaitActive("Getbhavcopy v2.1.0 by Hemen Kapadia", "Message	********* Data download complete *********")
SEND("!{F4}")

run("C:\Program Files\AmiBroker\Broker.exe")
WinWaitActive("[CLASS:AmiBrokerMainFrameClass]", "")
SEND("!f")
SEND("i")
WinWaitActive("Open")
