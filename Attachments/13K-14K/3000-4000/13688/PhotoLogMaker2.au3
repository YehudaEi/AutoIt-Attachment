#NoTrayIcon
#include <GUIConstants.au3>
#include <File.au3>
#include <GUITreeView.au3>
#include <_ZipFunctions.au3>
;Opt("TrayIconDebug",1)
Opt("GUIOnEventMode",1)

Global $IncludedPicsListString=""

$GetListGUI=GUICreate("Choose photos to include",640,480)
GUISetOnEvent($GUI_EVENT_CLOSE,"Exiter")
$DateListTreeview=GUICtrlCreateTreeView(10,20,310,390,$TVS_HASBUTTONS+$TVS_HASLINES+$TVS_LINESATROOT+$TVS_DISABLEDRAGDROP+$TVS_CHECKBOXES)

Global $TreeViewItems[1][3]=[[0]];[ctrl id][text][selected]
Global $PhotoFolder=""
If $CmdLine[0]>0 Then
	$PhotoFolder=$CmdLine[1]
	For $i=2 To $CmdLine[0]
		$PhotoFolder&=$CmdLine[$i]
	Next
EndIf
If NOT FileExists($PhotoFolder) Then
	$PhotoFolder=FileSelectFolder("Please select the folder containing the photos","C:\",6)
	If @error Then Exit
EndIf
SplashTextOn("Please wait","Please wait while the window is opened",320,240)

$TreeViewRoot=GUICtrlCreateTreeViewItem($PhotoFolder,$DateListTreeview)
GUICtrlSetOnEvent(-1,"EventHandler")
Global $TreeViewRootChecked=0
$TreeViewLabel=GUICtrlCreateLabel("Finding Files...",10,410,620,20)
$Thumbnail=GUICtrlCreatePic("",330,20,200,200,$BS_BITMAP)
$IncludedPicsList=GUICtrlCreateList("",330,223,200,190,$WS_BORDER+$WS_VSCROLL)
GUICtrlSetOnEvent(-1,"EventHandler")
$MoveUpButton=GUICtrlCreateButton("Move Up",530,240,100,20)
GUICtrlSetOnEvent(-1,"EventHandler")
$MoveDownButton=GUICtrlCreateButton("Move Down",530,378,100,20)
GUICtrlSetOnEvent(-1,"EventHandler")
GUICtrlCreateLabel("Date on Photo Log:",10,435)
$DateInput=GUICtrlCreateInput("",10,450,150,20)
GUICtrlCreateLabel("Project:",175,435)
$ProjectInput=GUICtrlCreateInput("",175,450,150,20)
GUICtrlCreateLabel("Observations by:",340,435)
$ObservationsInput=GUICtrlCreateInput("",340,450,150,20)
$GoButton=GUICtrlCreateButton("Build Photo Log",530,450,100,20)
GUICtrlSetOnEvent(-1,"EventHandler")
GUISetState(@SW_SHOW,$GetListGUI)
SplashOff()

$FileListArray=_FileListToArray($PhotoFolder,"*.jpg",1)
If @error Then
	GUISetState(@SW_HIDE)
	MsgBox(16,"Error","Sorry, no valid pictures were found")
	Exit
EndIf

GUICtrlSetData($TreeViewLabel,"Please Wait...")

Global $FileArray[UBound($FileListArray)][2];[filename][date]
$FileArray[0][0]=$FileListArray[0]
For $i=1 To $FileListArray[0]
	dim $ThisProp=""
	$FileArray[$i][0]=$FileListArray[$i]
	If @OSVersion="WIN_95" OR @OSVersion="WIN_98" OR @OSVersion="WIN_ME" OR @OSVersion="WIN_NT4" OR @OSVersion="WIN_2000" OR @OSVersion="WIN_XP" OR @OSVersion="WIN_2003" Then
		$ThisProp=StringSplit(StringReplace(_GetExtProperty($PhotoFolder & "\" & $FileArray[$i][0],25),"?","")," ")
	Else
		$ThisProp=StringSplit(StringReplace(_GetExtProperty($PhotoFolder & "\" & $FileArray[$i][0],12),"?","")," ")
	EndIf
	$FileArray[$i][1]=$ThisProp[1]
	
	$found=0
	For $n=1 To $TreeViewItems[0][0]
		If $FileArray[$i][1]=$TreeViewItems[$n][1] Then
			$found=1
			ReDim $TreeViewItems[$TreeViewItems[0][0]+2][3]
			$TreeViewItems[0][0]+=1
			$TreeViewItems[$TreeViewItems[0][0]][0]=GUICtrlCreateTreeViewItem($FileArray[$i][0],$TreeViewItems[$n][0])
			GUICtrlSetOnEvent(-1,"EventHandler")
			$TreeViewItems[$TreeViewItems[0][0]][1]=$FileArray[$i][0]
			$TreeViewItems[$TreeViewItems[0][0]][2]=0
			ExitLoop
		EndIf
	Next
	If $found=0 Then
		ReDim $TreeViewItems[$TreeViewItems[0][0]+2][3]
		$TreeViewItems[0][0]+=1
		$TreeViewItems[$TreeViewItems[0][0]][0]=GUICtrlCreateTreeViewItem($FileArray[$i][1],$TreeViewRoot)
		GUICtrlSetOnEvent(-1,"EventHandler")
		$TreeViewItems[$TreeViewItems[0][0]][1]=$FileArray[$i][1]
		$TreeViewItems[$TreeViewItems[0][0]][2]=0
		GUICtrlSetState($TreeViewRoot,$GUI_EXPAND)
		
		ReDim $TreeViewItems[$TreeViewItems[0][0]+2][3]
		$TreeViewItems[0][0]+=1
		$TreeViewItems[$TreeViewItems[0][0]][0]=GUICtrlCreateTreeViewItem($FileArray[$i][0],$TreeViewItems[$n][0])
		GUICtrlSetOnEvent(-1,"EventHandler")
		$TreeViewItems[$TreeViewItems[0][0]][1]=$FileArray[$i][0]
		$TreeViewItems[$TreeViewItems[0][0]][2]=0
	EndIf
Next

GUICtrlSetData($TreeViewLabel,"")
Global $Rearranged=0

Func EventHandler()
	$callingID=@GUI_CtrlId
	Switch $callingID
		Case $MoveUpButton
			If $Rearranged=1 OR MsgBox(36,"Are you sure?","If you rearrange the list, then check or uncheck some boxes, your changes will be lost.  Are you sure you're done selecting pictures?")=6 Then
				$Rearranged=1
				$IncludedPicsListArray=StringSplit($IncludedPicsListString,"|")
				If NOT @error AND $IncludedPicsListArray[1] <> GUICtrlRead($IncludedPicsList) Then
					$reselectItem=GUICtrlRead($IncludedPicsList)
					For $i=1 To $IncludedPicsListArray[0]
						If $IncludedPicsListArray[$i]=GUICtrlRead($IncludedPicsList) Then ExitLoop
					Next
					$IncludedPicsListArray[$i]=$IncludedPicsListArray[$i-1]
					$IncludedPicsListArray[$i-1]=GUICtrlRead($IncludedPicsList)
					$IncludedPicsListString=""
					For $i=1 To $IncludedPicsListArray[0]
						If $IncludedPicsListArray[$i] <> "" Then $IncludedPicsListString&=$IncludedPicsListArray[$i]&"|"
					Next
					GUICtrlSetData($IncludedPicsList,"")
					GUICtrlSetData($IncludedPicsList,$IncludedPicsListString,$reselectItem)
				EndIf
			EndIf
		Case $MoveDownButton
			If $Rearranged=1 OR MsgBox(36,"Are you sure?","If you rearrange the list, then check or uncheck some boxes, your changes will be lost.  Are you sure you're done selecting pictures?")=6 Then
				$Rearranged=1
				$IncludedPicsListArray=StringSplit($IncludedPicsListString,"|")
				If NOT @error AND $IncludedPicsListArray[$IncludedPicsListArray[0]] <> GUICtrlRead($IncludedPicsList) Then
					$reselectItem=GUICtrlRead($IncludedPicsList)
					For $i=1 To $IncludedPicsListArray[0]
						If $IncludedPicsListArray[$i]=GUICtrlRead($IncludedPicsList) Then ExitLoop
					Next
					$IncludedPicsListArray[$i]=$IncludedPicsListArray[$i+1]
					$IncludedPicsListArray[$i+1]=GUICtrlRead($IncludedPicsList)
					$IncludedPicsListString=""
					For $i=1 To $IncludedPicsListArray[0]
						If $IncludedPicsListArray[$i] <> "" Then $IncludedPicsListString&=$IncludedPicsListArray[$i]&"|"
					Next
					GUICtrlSetData($IncludedPicsList,"")
					GUICtrlSetData($IncludedPicsList,$IncludedPicsListString,$reselectItem)
				EndIf
			EndIf
		Case $TreeViewRoot
			If $TreeViewRootChecked=0 AND BitAnd(GUICtrlRead($TreeViewRoot),$GUI_CHECKED) Then
				$TreeViewRootChecked=1
				For $i=1 To $TreeViewItems[0][0]
					GUICtrlSetState($TreeViewItems[$i][0],$GUI_CHECKED)
					$TreeViewItems[$i][2]=1
				Next
				RebuildList()
			ElseIf $TreeViewRootChecked=1 AND BitAnd(GUICtrlRead($TreeViewRoot),$GUI_UNCHECKED) Then
				$TreeViewRootChecked=0
				For $i=1 To $TreeViewItems[0][0]
					GUICtrlSetState($TreeViewItems[$i][0],$GUI_UNCHECKED)
					$TreeViewItems[$i][2]=0
				Next
				RebuildList()
			EndIf
		Case $IncludedPicsList
			GUICtrlSetImage($Thumbnail,$PhotoFolder & "\" & GUICtrlRead($IncludedPicsList))
		Case $GoButton
			GUICtrlSetState($GoButton,$GUI_DISABLE)
			GUICtrlSetData($GoButton,"Working...")
			;;build the glorious word document!
			$IncludedPicsListArray=StringSplit($IncludedPicsListString,"|")
			GUICtrlSetData($TreeViewLabel,"Deleting old files")
			For $i=1 To 100
				DirRemove(@TempDir & "\PhotoLogBuilder",1)
				If NOT FileExists(@TempDir & "\PhotoLogBuilder") Then ExitLoop
				sleep(100)
			Next
			If FileExists(@TempDir & "\PhotoLogBuilder") Then
				run(@comspec & ' /c start "" "%tmp%"',"",@SW_HIDE)
				MsgBox(16,"Error","The program can't delete the PhotoLogBuilder in your temp file.  Please delete it manually or else Word will prompt you to recover the document once the file is built.  Click OK when you're ready to continue.")
			EndIf
			DirCreate(@TempDir & "\PhotoLogBuilder")
			$root=@TempDir & "\PhotoLogBuilder\Docx"
			
			GUICtrlSetData($TreeViewLabel,"Unzipping files")
			FileInstall("docx.zip",@TempDir & "\PhotoLogBuilder\Docx.zip")
			_Unzip(@TempDir & "\PhotoLogBuilder\Docx.zip",$root)
			GUICtrlSetData($TreeViewLabel,"Writing table of contents")
			FileWriteLine($root & '\word\_rels\document.xml.rels','<?xml version="1.0" encoding="UTF-8" standalone="yes" ?> ')
			FileWriteLine($root & '\word\_rels\document.xml.rels','<Relationships xmlns="                                                            ">')
			FileWriteLine($root & '\word\_rels\document.xml.rels','  <Relationship Id="rId7" Type="                                                                          " Target="footer1.xml" />')
			FileWriteLine($root & '\word\_rels\document.xml.rels','  <Relationship Id="rId6" Type="                                                                          " Target="header1.xml" />')
			For $i=1 To $IncludedPicsListArray[0]
				If $IncludedPicsListArray[$i]<>"" Then
					FileWriteLine($root & '\word\_rels\document.xml.rels','  <Relationship Id="MGId'&$i&'" Type="                                                                         " Target=".\'&StringReplace($IncludedPicsListArray[$i],' ','%20')&'" TargetMode="External" />')
				EndIf
			Next
			FileWriteLine($root & '\word\_rels\document.xml.rels','</Relationships>')
			
			GUICtrlSetData($TreeViewLabel,"Writing header")
			_FileWriteToLine($root & "\word\header1.xml",489,StringReplace(FileReadLine($root & "\word\header1.xml",489),"xx\xx\xxxx",GUICtrlRead($DateInput)),1)
			_FileWriteToLine($root & "\word\header1.xml",558,StringReplace(FileReadLine($root & "\word\header1.xml",558),"___________________",GUICtrlRead($ProjectInput)),1)
			_FileWriteToLine($root & "\word\header1.xml",603,StringReplace(FileReadLine($root & "\word\header1.xml",603),"___________________",GUICtrlRead($ObservationsInput)),1)
			
			GUICtrlSetData($TreeViewLabel,"Writing metadata")
			$tmpFilecontents=FileRead($root & "\docProps\core.xml")
			$TmpFile=FileOpen($root & "\docProps\core.xml",2)
			$tmpFilecontents=StringReplace($tmpFilecontents,"{date}",GUICtrlRead($DateInput))
			$tmpFilecontents=StringReplace($tmpFilecontents,"{job}",GUICtrlRead($ProjectInput))
			$tmpFilecontents=StringReplace($tmpFilecontents,"{username}",@UserName)
			FileWrite($TmpFile,$tmpFilecontents)
			FileClose($TmpFile)
			
			GUICtrlSetData($TreeViewLabel,"Writing document")
			$documentfile=FileOpen($root & '\word\document.xml',2)
			FileWriteLine($documentfile,'<?xml version="1.0" encoding="UTF-8" standalone="yes"?>')
			FileWriteLine($documentfile,'<w:document xmlns:ve="                                                           " xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:o12="http://schemas.microsoft.com/office/2004/7/core" xmlns:r="                                                                   " xmlns:m="                                                          " xmlns:v="urn:schemas-microsoft-com:vml" xmlns:wp="                                                                      " xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w="                                                            " xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml">')
			FileWriteLine($documentfile,'  <w:body>')
			FileWriteLine($documentfile,'  <!--Image divider mark for future use-->')
			$PicPartFile=FileOpen($root & '\word\PicPart.xml',0)
			For $i=1 To $IncludedPicsListArray[0]
				If $IncludedPicsListArray[$i]<>"" Then
					$PicPart=FileRead($PicPartFile)
					GUICtrlSetData($TreeViewLabel,"Writing picture "&$i)
					If @OSVersion="WIN_95" OR @OSVersion="WIN_98" OR @OSVersion="WIN_ME" OR @OSVersion="WIN_NT4" OR @OSVersion="WIN_2000" OR @OSVersion="WIN_XP" OR @OSVersion="WIN_2003" Then
						$SizeProp=StringSplit(StringReplace(_GetExtProperty($PhotoFolder & "\" & $FileArray[$i][0],26),"?","")," x ",1)
					Else
						$SizeProp=StringSplit(StringReplace(_GetExtProperty($PhotoFolder & "\" & $FileArray[$i][0],31),"?","")," x ",1)
					EndIf
					If Number($SizeProp[2]) < Number($SizeProp[1]) Then $PicPart=StringReplace($PicPart,'<v:group style="width:162pt;height:216pt;','<v:group style="width:216pt;height:162pt;')
					$PicPart=StringReplace($PicPart,'<v:imagedata r:id="MGId1" /> ','<v:imagedata r:id="MGId'&$i&'" /> ')
					$PicPart=StringReplace($PicPart,'<w:t>1)</w:t>','<w:t>'&$i&')</w:t>')
					$PicPart=$PicPart&@CRLF
					FileWrite($documentfile,$PicPart)
				EndIf
			Next
			FileClose($PicPartFile)
			GUICtrlSetData($TreeViewLabel,"Writing end of document")
			FileWriteLine($documentfile,'    <w:sectPr>')
			FileWriteLine($documentfile,'      <w:headerReference w:type="default" r:id="rId6"/>')
			FileWriteLine($documentfile,'      <w:footerReference w:type="default" r:id="rId7"/>')
			FileWriteLine($documentfile,'      <w:pgMar w:top="1440" w:right="1080" w:bottom="720" w:left="1080" w:header="720" w:footer="720" w:gutter="0"/>')
			FileWriteLine($documentfile,'      <w:cols w:num="2" w:space="720"/>')
			FileWriteLine($documentfile,'    </w:sectPr>')
			FileWriteLine($documentfile,'  </w:body>')
			FileWriteLine($documentfile,'</w:document>')
			FileClose($documentfile)
			FileDelete($root & "\word\PicPart.xml")
			
			GUICtrlSetData($TreeViewLabel,"Compiling document")
			_ZipAdd(@TempDir & "\PhotoLogBuilder\PhotoLogZip.zip",$root)
			GUICtrlSetData($TreeViewLabel,"Moving document to "&$PhotoFolder & "\Photo Log "& StringReplace(GUICtrlRead($DateInput),"/","-") & ".docx")
			FileMove(@TempDir & "\PhotoLogBuilder\PhotoLogZip.zip",$PhotoFolder & "\Photo Log "& StringReplace(GUICtrlRead($DateInput),"/","-") & ".docx",1)
			GUICtrlSetData($TreeViewLabel,"Done!  Please wait while the document is launched.")
			RunWait(@ComSpec & ' /c start "" "'&$PhotoFolder & '\Photo Log '& StringReplace(GUICtrlRead($DateInput),"/","-") & '.docx"',"",@SW_HIDE)
			Exit
			
			;;/build the glorious word document!
		Case Else
			For $i=1 To $TreeViewItems[0][0]
				If $TreeViewItems[$i][0]=$callingID Then
					If StringInStr($TreeViewItems[$i][1],"/") OR $TreeViewItems[$i][1] = "0" Then;it's a date folder
						If GUICtrlRead($DateInput)="" AND BitAND(GUICtrlRead($TreeViewItems[$i][0]),$GUI_CHECKED) Then GUICtrlSetData($DateInput,$TreeViewItems[$i][1])
						If $TreeViewItems[$i][2]=1 AND BitAnd(GUICtrlRead($callingID),$GUI_UNCHECKED) Then
							For $n=1 To $TreeViewItems[0][0]
								If _GUICtrlTreeViewGetParentID($DateListTreeview,$TreeViewItems[$n][0]) = $callingID Then
									$TreeViewItems[$n][2]=0
									GUICtrlSetState($TreeViewItems[$n][0],$GUI_UNCHECKED)
								EndIf
							Next
							$TreeViewItems[$i][2]=0
							RebuildList()
						ElseIf $TreeViewItems[$i][2]=0 AND BitAnd(GUICtrlRead($callingID),$GUI_CHECKED) Then
							For $n=1 To $TreeViewItems[0][0]
								If _GUICtrlTreeViewGetParentID($DateListTreeview,$TreeViewItems[$n][0]) = $callingID Then
									$TreeViewItems[$n][2]=1
									GUICtrlSetState($TreeViewItems[$n][0],$GUI_CHECKED)
								EndIf
							Next
							$TreeViewItems[$i][2]=1
							RebuildList()
						EndIf
					Else;it's a file itself
						GUICtrlSetImage($Thumbnail,$PhotoFolder & "\" & $TreeViewItems[$i][1])
						If $TreeViewItems[$i][2] = 1 AND BitAND(GUICtrlRead($TreeViewItems[$i][0]),$GUI_UNCHECKED) Then
							$TreeViewItems[$i][2] = 0
							RebuildList()
						ElseIf $TreeViewItems[$i][2] = 0 AND BitAND(GUICtrlRead($TreeViewItems[$i][0]),$GUI_CHECKED) Then
							$TreeViewItems[$i][2] = 1
							RebuildList()
						EndIf
					EndIf
					ExitLoop
				EndIf
			Next
	EndSwitch
EndFunc

Func RebuildList()
	$Rearranged=0
	$IncludedPicsListString=""
	GUICtrlSetData($IncludedPicsList,"")
	For $rebuildCheck=1 To $TreeViewItems[0][0]
		If $TreeViewItems[$rebuildCheck][2] = 1 AND NOT StringInStr($TreeViewItems[$rebuildCheck][1],"/") AND $TreeViewItems[$rebuildCheck][1]<>"0" Then
			$IncludedPicsListString &= $TreeViewItems[$rebuildCheck][1] & "|"
		EndIf
	Next
	GUICtrlSetData($IncludedPicsList,$IncludedPicsListString)
EndFunc

Func Exiter()
	Exit
EndFunc

While 1
	sleep(2000)
WEnd

;===============================================================================
; Function Name:    GetExtProperty($sPath,$iProp)
; Description:      Returns an extended property of a given file.
; Parameter(s):     $sPath - The path to the file you are attempting to retrieve an extended property from.
;                   $iProp - The numerical value for the property you want returned. If $iProp is is set
;                       to -1 then all properties will be returned in a 1 dimensional array in their corresponding order.
;                     The properties are as follows:
;                     Name = 0
;                     Size = 1
;                     Type = 2
;                     DateModified = 3
;                     DateCreated = 4
;                     DateAccessed = 5
;                     Attributes = 6
;                     Status = 7
;                     Owner = 8
;                     Author = 9
;                     Title = 10
;                     Subject = 11
;                     Category = 12
;                     Pages = 13
;                     Comments = 14
;                     Copyright = 15
;                     Artist = 16
;                     AlbumTitle = 17
;                     Year = 18
;                     TrackNumber = 19
;                     Genre = 20
;                     Duration = 21
;                     BitRate = 22
;                     Protected = 23
;                     CameraModel = 24
;                     DatePictureTaken = 25
;                     Dimensions = 26
;                     Width = 27
;                     Height = 28
;                     Company = 30
;                     Description = 31
;                     FileVersion = 32
;                     ProductName = 33
;                     ProductVersion = 34
; Requirement(s):   File specified in $spath must exist.
; Return Value(s):  On Success - The extended file property, or if $iProp = -1 then an array with all properties
;                   On Failure - 0, @Error - 1 (If file does not exist)
; Author(s):        Simucal (Simucal@gmail.com)
; Note(s):
;
;===============================================================================
Func _GetExtProperty($sPath, $iProp)
    Local $iExist, $sFile, $sDir, $oShellApp, $oDir, $oFile, $aProperty, $sProperty
    $iExist = FileExists($sPath)
    If $iExist = 0 Then
        SetError(1)
        Return 0
    Else
        $sFile = StringTrimLeft($sPath, StringInStr($sPath, "\", 0, -1))
        $sDir = StringTrimRight($sPath, (StringLen($sPath) - StringInStr($sPath, "\", 0, -1)))
        $oShellApp = ObjCreate("shell.application")
        $oDir = $oShellApp.NameSpace ($sDir)
        $oFile = $oDir.Parsename ($sFile)
        If $iProp = -1 Then
            Local $aProperty[35]
            For $i = 0 To 34
                $aProperty[$i] = $oDir.GetDetailsOf ($oFile, $i)
            Next
            Return $aProperty
        Else
            $sProperty = $oDir.GetDetailsOf ($oFile, $iProp)
            If $sProperty = "" Then
                Return 0
            Else
                Return $sProperty
            EndIf
        EndIf
    EndIf
EndFunc   ;==>_GetExtProperty