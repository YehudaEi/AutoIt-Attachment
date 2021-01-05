Opt("TrayIconHide", 0)
$i = 0
While $i == 0
   WinWait("File Download")
   WinWaitNotActive("File Download")
   if WinExists("", "Saving:") Then
      WinWaitClose("", "Saving:")
      Run(@Comspec & " /c streams -d *", @DesktopDir)
   EndIf
WEnd
Exit