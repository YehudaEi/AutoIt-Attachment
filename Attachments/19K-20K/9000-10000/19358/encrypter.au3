#include <GUIConstants.au3>
#include <String.au3>
#include <TextEdit.au3>
#include <GuiEdit.au3>
#include <File.au3>


#NoTrayIcon

$filename = "Untitled.afc"
$parent = Guicreate ("AFC Encrypto", 550, 590)
$mainmenu = GUICtrlCreateMenu ("File")
$new = guictrlcreatemenuitem ("&New File", $mainmenu)
$open = guictrlcreatemenuitem ("Open", $mainmenu)
$import = guictrlcreatemenuitem ("Import noncoded files...",$mainmenu)
$export = guictrlcreatemenuitem ("Export file uncoded...",$mainmenu)

$save = guictrlcreatemenuitem ("Save", $mainmenu)
$saveas = guictrlcreatemenuitem ("Save &As", $mainmenu)
guictrlcreatemenuitem ("______",$mainmenu)
GUICtrlSetState(-1,$GUI_DISABLE)
$exit = guictrlcreatemenuitem ("E&xit", $mainmenu)
$fileencode = ""
$temppass = ""
$child = ""
$saved = "no"

$editmenu = guictrlcreatemenu ("Edit")

$copy = guictrlcreatemenuitem ("Copy", $editmenu)
$paste = guictrlcreatemenuitem ("Paste", $editmenu)


$helpmenu = guictrlcreatemenu ("Help")
$about = guictrlcreatemenuitem ("About", $helpmenu)
$helpmenuitem = guictrlcreatemenuitem ("Help", $helpmenu)

;$textwindow = guictrlcreateedit (" ",0,0,550, 570, $WS_VSCROLL+$ES_WANTRETURN+$ES_AUTOVSCROLL,0) 
$textwindow = guictrlcreateedit (" ",0,0,550, 570) 


				$inputpass = "pass"
				$inputlevel = 2



GUISetState ()
While 1
    $msg = GUIGetMsg()

	
	    If $msg = $GUI_EVENT_CLOSE  or $msg = $exit Then ExitLoop
		
		if $msg = $save Then
			if $saved = "yes" then 
				$encryptedtext = _StringEncrypt(1,(Guictrlread ( $textwindow)),$inputpass,$inputlevel) 
				fileopen ($filename, 2)
				filewrite ($filename,$encryptedtext)
				FileClose ($filename)
				WinSetTitle("AFC Encrypto","", "AFC Encrypto " & $filename)
				$saved = "yes"
		else
		$msg = $saveas
			endif
				
				
			EndIf
		If $msg = $about then 
SplashImageOn ("AFC's Encrypto",@ScriptDir & "\splash.png")
Sleep(3000)
SplashOff()
msgbox(64,"About us","AFC Encrypter Version 1.6 - ArabsforChrist.org")
endif

;msgbox(64,"About us","AFC Encrypter Version 1.5")
		
		if $msg = $helpmenuitem then Run(@WindowsDir & "\HH.exe " & @ScriptDir & "\help.chm") 
			
		
		
		if $msg = $saveas Then
			$filename = ( FileSaveDialog ( "Save as...", "","AFC Encrypter (*.afc)| All (*.*)",16,"unnamed.afc" ))
	if $temppass <> "" then	
		$inputpass   = InputBox ("AFC Encryption", "Enter a password for encryption",$temppass,"*")		 
	else		
	
		$inputpass   = InputBox ("AFC Encryption", "Enter a password for encryption",$temppass,"*")
		$temppass = $inputpass
	endif

			 $inputlevel = InputBox ("AFC Encryption", "Enter the level of encryption you wish to have","2")
		
			
			
			
				

				$encryptedtext = _StringEncrypt(1,(Guictrlread ( $textwindow)),$inputpass,$inputlevel) 
fileopen ($filename, 2)			
	filewrite ($filename,$encryptedtext)
				FileClose ($filename)
				WinSetTitle("AFC Encrypto","", "AFC Encrypto " & $filename)
				$saved = "yes"
			
				
				
		EndIf
		 



		
		if $msg = $new then 
		GUICtrlSetData ( $textwindow, "")
		WinSetTitle("AFC Encrypto " & $filename,"","AFC Encrypto" )
		endif

	if $msg = $import then 
$filename = ( FileOpenDialog ( "Import a file", "", "HTML Document (*.html)|Rich Text File (*.RTF)|Text Document (*.txt)|Log file (*.log)|All (*.*)" ))
$encryptedtext = (FileRead ( $filename)) 
			GUICtrlSetData ( $textwindow, $encryptedtext)
endif
		if $msg = $export Then
			$filename = ( FileSaveDialog ( "Export...", "","HTML Document (*.html)|Rich Text File (*.RTF)|Text Document (*.txt)|Log file (*.log)|All (*.*)" ))
fileopen ($filename, 2)			

filewrite ($filename,Guictrlread ( $textwindow))
				FileClose ($filename)

endif





		if $msg = $open Then
			
			$filename = ( FileOpenDialog ( "Open a file", "", "AFC Encrypter (*.afc)| All (*.*)" ))
			 	
if $temppass <> "" then	
		$inputpass   = InputBox ("AFC Encryption", "Enter a password for encryption",$temppass,"*")		 
	else		
	
		$inputpass   = InputBox ("AFC Encryption", "Enter a password for encryption",$temppass,"*")
		$temppass = $inputpass
endif

			 $inputlevel = InputBox ("AFC Encryption", "Enter the level of decryption you wish to have","2")
			$encryptedtext = _StringEncrypt(0,(FileRead ( $filename)),$inputpass,$inputlevel) 
			GUICtrlSetData ( $textwindow, $encryptedtext)
			WinSetTitle("AFC Encrypto","", "AFC Encrypto " & $filename)	
$saved = "yes"
				
		EndIf

		if $msg = $copy then send ("^C")
		
		if $msg = $paste then send ("^V")



		

  wend

GUIDelete()

Exit

