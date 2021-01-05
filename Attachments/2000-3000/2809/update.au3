#Include <process.au3>
RunAsSet("adminuser", "domain", "password")

if fileexists("c:\info") then
	sleep(100)
Else
	DirCreate("c:\info")
; read only and hidden attributes for c:\info just so normal user doesn't delete
	_RunDOS("attrib +r +h c:\info")
EndIf

if fileexists("c:\info\update1.txt") then 
;if update1.txt exists, this update has already been run....quit without doing anything  name of text file will change on other updates if any.
exit
 
Else
	processclose("Info.exe")
	splashtexton("Updating....", "Updating....Please wait.", 500, 25)
	;remove hidden and read only attributes so file can be deleted.
	_RunDOS("attrib -r -h c:\info.exe")
	FileDelete("c:\info.exe")
	fileinstall("c:\info2.exe", "c:\info.exe")
	;also install in sys32 in case file deleted, can still use file\run\info.exe
	fileinstall("c:\info2.exe", @SystemDir & "\info.exe")
	sleep(4000)
	splashoff()
	Filewriteline("c:\info\update1.txt", "Update 1 has been applied.")
	splashtexton("Finished....", "Update Complete.", 500, 25)
	sleep(3000)
	splashoff()
	_RunDOS("attrib +h +r c:\info.exe")
	run("c:\info.exe")
endif
