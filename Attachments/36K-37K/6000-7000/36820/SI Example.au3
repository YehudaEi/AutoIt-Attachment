#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_UseUpx=n
#include "SI.au3"

#cs
	Run this once and it will install itselfe to program files under the folder name "Test App" and delete itselfe
	Then go to the "Add Or Remove Programs" control panel applet and click remove, it will delete itselfe but
	the control panel applet will remain and clicking it a second time will remove it after a warning is displayed
	regarding the status of the installation.
#ce


Global $RetVal
If Not @Compiled Then Exit MsgBox(16,"Error!", "We need to be compiled, you cannot install a text file...")
If Not $CMDLINERAW Then
	$RetVal = _Install("Tast App", "AutoIt Community", 0,True)
	MsgBox(0,@error,$RetVal)
Else
	CheckUninstallRequest("Tast App")
EndIf
