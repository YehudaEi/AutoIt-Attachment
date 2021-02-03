$RR = "\\NetworkPath\files and folders"
$TT = "C:\Program Files\folder x"
DirCopy($RR,$TT,1)
DirCreate("C:\Program Files\folder x\folder y")
DirCopy("\\NetworkPath\files and folders\folder y","C:\Program Files\folder x\folder y",1)
;As the folder y is not getting copied I have created a folder manually and started copying files into it
MsgBox(0,"Copying done","Virus definitions were copied successfully")
