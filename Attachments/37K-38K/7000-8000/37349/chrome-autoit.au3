;;start.au3 - start webpage index.htm in Chrome
dim $handle
dim $file="file:///" & @ScriptDir & "/index.html"
dim $var=@ScriptDir & "\Chrome\chrome.exe"
Opt("WinTextMatchMode", 4)
$pid=ShellExecute($var, "",@SW_MAXIMIZE) 
WinWaitActive("[CLASS:Chrome_WidgetWin_0; TITLE:New Tab - Google Chrome]", "")
$handle = WinGetHandle("[CLASS:Chrome_WidgetWin_0; TITLE:New Tab - Google Chrome]", "")
sleep(250)
ControlSetText($handle, "", "[CLASSNN:Chrome_OmniboxView1]", $file ); Sends a string in raw mode
sleep(250)
ControlSend($handle, "", "[CLASSNN:Chrome_OmniboxView1]","{ENTER}")