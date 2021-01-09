While 1
If Not ProcessExists("iexplore.exe") Then Run(@ProgramFilesDir &"\Internet Explorer\iexplore.exe -k C:\inetpub\ftproot\Index.htm")
MouseMove(@DesktopWidth + 100, 0, 0)
Sleep (1000)
WEnd