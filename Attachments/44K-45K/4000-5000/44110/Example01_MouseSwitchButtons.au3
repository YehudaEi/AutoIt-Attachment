; Switches right and left mouse buttons.
; This works with the standard Mouse Properties Control Panel.
; If you installed a program that changes the Mouse Properties control panel,
; it may not work.
; For a list of all the Control Panel applets,
; see http://en.wikipedia.org/wiki/Control_Panel_%28Windows%29
; or google "CPL list."

Run("control.exe main.cpl") ; Opens the Mouse Properties Control Panel applet 
WinWaitActive("Mouse Properties") ; Waits for the window to open
Sleep(1000) ; (Optional) Pauses one second so you can watch the script work
Send("!s{ENTER}") ; Types ALT+s then presses the Enter key
