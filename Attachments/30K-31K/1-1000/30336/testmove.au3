;test autoit move command

;this works
;$sourcepath = "c:\Documents and Settings\All Users\Start Menu\Programs\Startup\"
;$targetpath = "c:\c$\temp\"

;this does not work
;you end up with mm.exe still in the source
;and another copy called mm.exe in the target path
$sourcepath = "\\black1\c$\Documents and Settings\All Users\Start Menu\Programs\Startup\"
$targetpath = "\\black1\c$\temp\"

FileMove($sourcepath & "mm.exe", $targetpath & "mm.exe")

exit

#cs
the equivalent DOS commands
;this works
move C:\"Documents and Settings\All Users\Start Menu"\Programs\Startup\mm.exe C:\temp\mm.exe
;this works
move \\black1\c$\"Documents and Settings\All Users\Start Menu"\Programs\Startup\mm.exe \\black1\c$\temp\mm.exe

;both of these functions also work under windows explorer as well using cut and past

#ce

