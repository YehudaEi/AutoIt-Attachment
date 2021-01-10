$oldcookies = DirGetSize(@UserProfileDir & "\cookies")

$olddesktop = DirGetSize(@UserProfileDir & "\desktop")

$oldscotlandyard = FileGetSize("C:\Documents and Settings\All Users\Desktop\Scotland Yard.lnk")

$oldfavorites = DirGetSize(@UserProfileDir & "\favorites\")

$oldMyDocuumets = DirGetSize(@UserProfileDir & "\My Documents")

 $oldStruserMyDocuments = DirGetSize("C:\Documents and Settings\struser\My Documents")

$oldCivuserMyDocuments = DirGetSize("C:\Documents and Settings\civuser\My Documents")

$oldOutlook = DirGetSize(@UserProfileDir & "\Application Data\Microsoft\Outlook")

$oldProof = DirGetSize(@UserProfileDir & "\Application Data\Microsoft\Proof")

$oldsignatures = DirGetSize(@UserProfileDir & "\Application Data\Microsoft\Signatures")

$oldoutlook2 = DirGetSize(@UserProfileDir & "\Local Settings\Application Data\Microsoft\Outlook")

$olduser = DirGetSize("C:\User")

$oldproj = DirGetSize("C:\Proj")

$oldeaglepoint = DirGetSize("C:\Program Files\Eagle Point\Support")


DriveMapDel("V:")
DriveMapAdd("V:", "\\Ghost\Ghoste\UserBackups")

DirCopy (@UserProfileDir & "\Cookies","V:\"& @UserName & "\Cookies\",0)

$newcookies = DirGetSize("V:\"&@username & "\cookies\")

if $oldcookies=$newcookies then 
	MsgBox(4096,"File Copy Successful", "Cookies copied",3 )
	$i+1
Else
	Msgbox(4096,"File Copy failed","Cookies copied unsusuccessfully") 
EndIf

FileCopy("C:\Documents and Settings\All Users\Desktop\Scotland Yard.lnk","V:\"& @UserName & "\Desktop\")
DirCopy (@UserProfileDir & "\desktop","V:\"& @UserName & "\Desktop\",0)


$newdesktop = DirGetSize("V:\"& @UserName & "\Desktop\")

if ($olddesktop + $oldscotlandyard = $newdesktop) then 
	MsgBox(4096,"File Copy Successful", "Desktop icons copied",3 ) 

Else
	Msgbox(4096,"File Copy failed", "Desktop icon copy unsuccessful")
EndIf

DirCopy (@UserProfileDir & "\Favorites","V:\"& @UserName & "\Favorites\",0)

$newfavorites = DirGetSize("V:\"&@username & "\favorites\")

if $oldfavorites=$newfavorites then 
	MsgBox(4096,"File Copy Successful", "Favorites copied",3 ) 

Else
	Msgbox(4096,"File Copy failed", "Favorites copy unsuccessful")
EndIf

if FileExists("C:\Documents and Settings\struser\NTUSER.DAT") then

	DirCopy ("C:\Documents and Settings\struser\My Documents","V:\"& @UserName & "\My Documents\",0)
EndIf

if FileExists("C:\Documents and Settings\civuser\NTUSER.DAT") then

	DirCopy ("C:\Documents and Settings\civuser\My Documents","V:\"& @UserName & "\My Documents\",0)
EndIf

DirCopy (@UserProfileDir & "\My Documents\","V:\"& @UserName & "\My Documents\",0)

$newMyDocuments = DirGetSize("V:\"& @UserName & "\My Documents\")

if ($oldCivuserMyDocuments+$oldStruserMyDocuments+$oldMyDocuumets -$newMyDocuments) < 230 then 
	MsgBox(4096,"File Copy Successful", "My Documents copied" ,3) 

Else
	Msgbox(4096,"File Copy failed", "My Documents copy unsuccessful")
EndIf

DirCopy (@UserProfileDir & "\Application Data\Microsoft\Outlook","V:\"& @UserName & "\Application Data\Microsoft\Outlook\",0)

$newOutlook = DirGetSize("V:\"& @UserName & "\Application Data\Microsoft\Outlook\")

if $oldOutlook=$newOutlook then 
	MsgBox(4096,"File Copy Successful", "Outlook Data files copied",3) 

Else
	Msgbox(4096,"File Copy failed", "Outlook data file copy unsuccessful")
EndIf

DirCopy (@UserProfileDir & "\Application Data\Microsoft\Proof","V:\"& @UserName & "\Application Data\Microsoft\Proof\",0)

$newProof = DirGetSize("V:\"& @UserName & "\Application Data\Microsoft\Proof\")

if $oldProof=$newProof then 
	MsgBox(4096,"File Copy Successful", "Outlook proof copied",3) 

Else
	Msgbox(4096,"File Copy failed", "Outlook proof copy unsuccessful")
EndIf

DirCopy (@UserProfileDir & "\Application Data\Microsoft\Signatures","V:\"& @UserName & "\Application Data\Microsoft\Signatures\",0)

$newsignatures = DirGetSize("V:\"& @UserName & "\Application Data\Microsoft\Signatures\")

if $oldSignatures=$newSignatures then 
	MsgBox(4096,"File Copy Successful", "Outlook Signatures copied",3) 

Else
	Msgbox(4096,"File Copy failed", "Outlook Signature copy unsuccessful")
EndIf

DirCopy (@UserProfileDir & "\Local Settings\Application Data\Microsoft\Outlook","V:\"& @UserName & "\Local Settings\Application Data\Microsoft\Outlook\",1)

$newoutlook2 = DirGetSize("V:\"& @UserName & "\Local Settings\Application Data\Microsoft\Outlook\")

if $oldoutlook2=$newoutlook2 then 
	MsgBox(4096,"File Copy Successful", "Outlook data files copied",3) 

Else
	Msgbox(4096,"File Copy failed", "Outlook data file copy unsuccessful")
EndIf

DirCopy ("C:\User","V:\"& @UserName & "\User\",0)

$newuser = DirGetSize("V:\"& @UserName & "\User\")

if $olduser=$newuser then 
	MsgBox(4096,"File Copy Successful", "C:\User directory copied successfully",3) 

Else
	Msgbox(4096,"File Copy failed", "Outlook Sigature copy unsuccessful")
EndIf

DirCopy ("C:\Proj","V:\"& @UserName & "\Proj\",0)

$newproj = DirGetSize("V:\"& @UserName & "\Proj\")

if $oldproj=$newproj then 
	MsgBox(4096,"File Copy Successful", "C:\Proj copied successfully",3) 

Else
	Msgbox(4096,"File Copy failed", "C:\Proj copy unsuccessful")
EndIf

DirCopy ("C:\Program Files\Eagle Point\Support","V:\"& @UserName & "\Program Files\Eagle Point\Support\",0)

$neweaglepoint = DirGetSize("V:\"& @UserName & "\Program Files\Eagle Point\Support\")

if $oldeaglepoint=$neweaglepoint then 
	MsgBox(4096,"File Copy Successful", "Eaglepoint support copied successfully",3) 

Else
	Msgbox(4096,"File Copy failed", "Eagle poin support copy unsuccessful")
	
EndIf