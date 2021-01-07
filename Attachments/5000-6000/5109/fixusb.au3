; Script to workaround a Windows bug that causes USB drive letter assignments to conflict with network drives
; 
; DiskPart.exe can be downloaded from http://www.microsoft.com/windows2000/techinfo/reskit/tools/new/diskpart-o.asp
; DiskPart documentation http://www.microsoft.com/resources/documentation/windows/xp/all/proddocs/en-us/diskpart.mspx
;
; Philip Gump - 17 Feb 2005 -  AutoIt 3.1.0 Script
;GUI and choice of drive letters added 9 November 2005 Bruce Shellenbaum
#include <GUIConstants.au3>
#NoTrayIcon
dim $msg
dim $drives [20] [4]
dim $drivelist[20]
dim $netdrives[20]
dim $netcounter = 0
dim $drivecounter = 0
dim $drivetemp
FileChangeDir(@TempDir)
Dim $diskPart = "DiskPart.exe"
dim $netuse = "net use"
Dim $dpScriptOne = "dpScriptOne.txt"
Dim $dpScriptTwo = "dpScriptTwo.txt"
Dim $infoOutput =  "DiskPartInfo.txt"
dim $netinfo = "netuse.txt"


;create the first script operation file to list the volumes
$handle = FileOpen($dpScriptone, 2)
         If $handle <> -1 Then 
            FileWrite($handle, "list volume "  & @CRLF & "exit ")
            FileClose($handle)
		EndIf
If @OSType <> "WIN32_NT" Then
   MsgBox(4096,"Error", "This program does not run on " & @OSVersion)
EndIf

If IsAdmin() Then
   ;MsgBox(4096,"USB Drive maybe not ready yet...", "If device is plugged and Windows says it's ready, click OK.")
Else
   MsgBox(4096,"Error", "You do not have access to change drive letters.  Click OK to exit")
   Exit
EndIf



Dim $info = ""
$run = RunWait(@Comspec & " /c " & $diskPart & " /s " & $dpScriptOne & " > " & $infoOutput, "", @SW_HIDE)
$run = RunWait(@Comspec & " /c " & $netuse & " > " & $netinfo, "", @SW_HIDE)
$info = FileRead($infoOutput, FileGetSize($infoOutput))
$InfoWithHeaderRemoved = StringTrimLeft($info, StringInStr($info, "Volume 0")-1)
$info = StringSplit($InfoWithHeaderRemoved, @CRLF)
$info2 = FileRead($netinfo, FileGetSize($netinfo))

$info1 = StringSplit($info2, @CRLF) ;holds network drive info


	
;put a gui here
GUICreate("Change Drive letter", 350, 275,-1,$WS_EX_ACCEPTFILES) 

GUICtrlCreateLabel("  Network                 Removable", 10,5)
$netlist = GUICtrlCreateListView("Drives",15,20,62,150,-1)
$listview = GUICtrlCreateListView("Vol | Drive | Name  | Size", 100,20,230,150,-1,$WS_EX_ACCEPTFILES)
$doitbutton = GUICtrlCreateButton("Map Drive", 10, 235, 60)

$letter = GUICtrlCreateInput ( "", 250, 200, 20, 20)
GuiCtrlSetState(-1,$GUI_ACCEPTFILES) 
GUICtrlCreateLabel ("New Drive Letter",  225, 175, 150)
GUICtrlCreateLabel ("Type in an unused drive letter, highlight the removable drive and hit the Map Drive btn",  5, 175, 200,60)
$closebtn = guictrlcreatebutton("Exit", 100,235,100)
For $i = 1 to $info[0]
   If StringStripWS($info[$i], 8) = "" Then ExitLoop ;quit when hit blank lines
   
   If StringInStr($info[$i], "Removeable") Then
	  
      ;put in drives array
	  ;volume in 0 letter in 1 name in 2 and size in 4
	  $drives [$drivecounter] [0] =stringmid ($info[$i], 10,2)  ;volume
	  $drives [$drivecounter] [1] =stringmid ($info[$i], 16,1) ;existing drive letter
	  $drives [$drivecounter] [2] =stringmid ($info[$i], 20,13) ;name
	  $drives [$drivecounter] [3] =stringmid ($info[$i], 53,7) ;size
	 
	  $drivetemp = $drives [$drivecounter] [0] & "|" & $drives [$drivecounter] [1] & "|" & $drives [$drivecounter] [2] & "|" & $drives [$drivecounter] [3]
	
	 $drivelist[$drivecounter]= GUICtrlCreateListViewItem ($drivetemp, $listview)
	 $drivecounter =$drivecounter +1

  EndIf

Next

for $i = 1 to $info1[0]
	
	if StringInStr($info1[$i], ":") then   ;look for colon which indicates drive line
	$netdrives [$netcounter]	= stringmid ($info1[$i], 14,1)  ;net drive
	 GUICtrlCreateListViewItem ($netdrives[$netcounter], $netlist)
	 $netcounter= $netcounter +1
EndIf
Next
GUISetState()
;GUISetState(@SW_SHOW)

While 1
  $msg = GUIGetMsg()

Select		
		
	Case $msg = $doitbutton
	 $volid = stringleft(GUICtrlRead(GUICtrlRead($listview)),2)
	 $newdrive = Guictrlread($letter)
      ;now map it
	  $handle = FileOpen($dpScriptTwo, 2)
         If $handle <> -1 Then 
            FileWrite($handle, "select volume " & $volid & @CRLF & "assign letter = " & $newdrive)
            FileClose($handle)
         EndIf
         RunWait($diskPart & " /s " & $dpScriptTwo, "", @SW_HIDE)
	  
    Case $msg = $closebtn 
	exit
     Case $msg = $GUI_EVENT_CLOSE
      ExitLoop
	  
	  
	  Case $msg = $listview
        

  EndSelect


wend


