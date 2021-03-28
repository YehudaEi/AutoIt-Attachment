; This script types Hello World in a Word document. 
; Before running this script, open Word and save the file as hello.docx (or hello.doc).
; The names must be in lower case to match the script.

Opt("WinTitleMatchMode", 2) ; Configures AutoIt to find a search term in any part of the window title
WinActivate("hello.doc") ; Activates the Word window with hello.docx (or hello.doc) in any part of the title bar
WinWaitActive("hello.doc") ; Waits for the window to be the active window
Send("Hello World") ; Types Hello World
