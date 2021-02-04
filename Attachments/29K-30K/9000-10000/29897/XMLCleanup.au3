#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("XML Cleanup", 633, 310, 192, 124)

$Files = GUICtrlCreateGroup("Files", 24, 16, 585, 129)
$Label1 = GUICtrlCreateLabel("Source File", 40, 40, 57, 17)
$Label2 = GUICtrlCreateLabel("Destinaton File", 40, 88, 74, 17)
$InputSource = GUICtrlCreateInput("", 40, 56, 465, 21)
$InputDestination = GUICtrlCreateInput("", 40, 104, 465, 21)
$Button_Source = GUICtrlCreateButton("Browse", 520, 56, 75, 25, $WS_GROUP)
$Button_Destination = GUICtrlCreateButton("Browse", 520, 104, 75, 25, $WS_GROUP)

GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group1 = GUICtrlCreateGroup("Program Status", 24, 152, 585, 81)
$ProgramState = GUICtrlCreateEdit("", 32, 168, 569, 55, $ES_WANTRETURN)
GUICtrlSetData(-1,"Enter source and destination file(s) in the boxes above to begin.")

GUICtrlCreateGroup("", -99, -99, 1, 1)
$ProgressBar = GUICtrlCreateProgress(24, 240, 585, 17)
GUICtrlSetState(-1,$GUI_HIDE)

$Button_Exit = GUICtrlCreateButton("Exit", 536, 272, 75, 25, $WS_GROUP)
$Button_Start = GUICtrlCreateButton("Start", 448, 272, 75, 25, $WS_GROUP)
GUICtrlSetState(-1,$GUI_DISABLE)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $SourceFile, $DestinationFile
Global $Indent=0
Global $TotalFileRead, $TotalFileReadBytes

Main()

Func Main()

	While 1
		$nMsg = GUIGetMsg()
	
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $Button_Exit
				Exit
			Case $Button_Start
				GUICtrlSetState($Button_Start,$GUI_DISABLE)
				ReadXML()
				CleanupXML()
				GUICtrlSetData($ProgramState,"Operation completed." & @CRLF & "Enter source and destination file(s) in the boxes above to begin.")
				GUICtrlSetData($InputSource,"")
				GUICtrlSetData($InputDestination,"")
				$SourceFile=$DestinationFile=""
				GUICtrlSetState($ProgressBar,$GUI_HIDE)
			Case $Button_Source
				GUICtrlSetData($ProgramState,"Waiting for a source file being selected...")
				$SourceFile = FileOpenDialog("Select source xml file","","XML-Files (*.xml)",1)
				GUICtrlSetData($InputSource,$SourceFile)
				GUICtrlSetData($ProgramState,"")
			Case $Button_Destination
				GUICtrlSetData($ProgramState,"Waiting for a destination file being selected...")
				$DestinationFile = FileSaveDialog("Select destination xml file","","XML-Files (*.xml)",16)
				GUICtrlSetData($InputDestination,$DestinationFile)
				GUICtrlSetData($ProgramState,"")
			Case $InputSource
				$Result=CheckFile("S",GUICtrlRead($InputSource))
				
				If $Result Then 
					$SourceFile=GUICtrlRead($InputSource)
				Else
					MsgBox(262192,"Error.","The source file/path you entered is invalid.")
					GUICtrlSetData($ProgramState,"Waiting for a source file being selected...")
					$SourceFile = FileOpenDialog("Select source xml file","","XML-Files (*.xml)",1)
					GUICtrlSetData($InputSource,$SourceFile)
					GUICtrlSetData($ProgramState,"")
				EndIf
			Case $InputDestination
				$Result=CheckFile("D",GUICtrlRead($InputDestination))
				
				If $Result=True Then	
					$DestinationFile=GUICtrlRead($InputDestination)
				Else
					MsgBox(262192,"Error.","The destination file/path you entered is invalid.")
					GUICtrlSetData($ProgramState,"Waiting for a destination file being selected...")
					$DestinationFile = FileSaveDialog("Select Destination xml file","","XML-Files (*.xml)",16)
					GUICtrlSetData($InputDestination,$DestinationFile)
					GUICtrlSetData($ProgramState,"")
				EndIf
		EndSwitch
			
		Sleep(10)
		If StringCompare(GUICtrlRead($InputSource),"")<>0 And StringCompare(GUICtrlRead($InputDestination),"")<>0  And GUICtrlGetState($Button_Start)=$GUI_SHOW + $GUI_DISABLE Then
			GUICtrlSetState($Button_Start,$GUI_ENABLE)
			GUICtrlSetData($ProgramState,"Required information complete." & @CRLF & "Press START to begin cleaning up the XML-File...")
		ElseIf (StringCompare(GUICtrlRead($InputSource),"")=0 Or StringCompare(GUICtrlRead($InputDestination),"")=0) And StringCompare(GUICtrlRead($ProgramState),"")=0 Then
			GUICtrlSetData($ProgramState,"Enter source and/or destination file(s) in the boxes above to begin.")
		EndIf
		
	WEnd
EndFunc

Func CheckFile($Type,$Name)
	$FileOK = False
	
	If StringCompare($Name,"")<>0 And Not StringIsSpace($Name) Then
		If StringInStr($Name,":") And StringInStr($Name,"\") And StringInStr($Name,".xml") Then
			If $Type="S" Then
				If FileExists($Name) Then
					$FileOK = True
				EndIf
			ElseIf $Type="D" Then
				$FileOK = True
			EndIf
		EndIf
	EndIf
	
	Return $FileOK		
EndFunc

Func UpdateLine($Line, $Now, $Type, $Handle)
	Local $NewLine=""

	If $Now=True Then
		If $Type="-" Then $Indent-=1
		If $Type="+" Then $Indent+=1
	EndIf
			
	If $Indent>0 Then
		For $i = 1 to $Indent
			$NewLine&="    "
		Next
	EndIf
	
	$NewLine &= $Line

	If $Now=False Then
		If $Type="-" Then $Indent-=1
		If $Type="+" Then $Indent+=1
	EndIf

	FileWriteLine($Handle, $NewLine)
EndFunc

Func ReadXML()

	GUICtrlSetData($ProgramState,"Please wait..." & @CRLF & "Reading source file...")

	$XMLFile = FileOpen($SourceFile, 0)
	
	$TotalFileRead = FileRead($XMLFile, FileGetSize($SourceFile))
	$TotalFileReadBytes = StringLen($TotalFileRead);@extended

	FileClose($XMLFile)
EndFunc

Func CleanupXML()
	GUICtrlSetData($ProgramState,"Please Wait..." & @CRLF & "Cleaning XML code & writing to destination file...")
	GUICtrlSetState($ProgressBar,$GUI_SHOW)
	$XMLFile = FileOpen($DestinationFile, 2)
		
	Local $StartPos = 1
	Local $LastPos = 0
	Local $Progress=0

	While (1)
		
		If(($LastPos/$TotalFileReadBytes)*100)<>GUICtrlRead($ProgressBar) Then
			GUICtrlSetData($ProgressBar,($LastPos/$TotalFileReadBytes)*100)
		EndIf
				
		If $LastPos>0 Then $StartPos = StringInStr($TotalFileRead,"<",0,1,$LastPos)
		If ($StartPos-$LastPos)>1 Then
				$Temp = StringMid($TotalFileRead,$LastPos+1,$StartPos-($LastPos+1))
				If Not StringIsSpace($Temp) Then UpdateLine($Temp,False, "=",$XMLFile)
		EndIf
		$LastPos = StringInStr($TotalFileRead,">",0,1,$StartPos)
		If $LastPos = 0 Then ExitLoop
		
		$CurrentLine = StringStripWS(StringMid($TotalFileRead, $StartPos, ($LastPos+1) - $StartPos),3)
		$Opening = StringMid($CurrentLine,2,1)
		$Closing = StringMid($CurrentLine,Stringlen($CurrentLine)-1,1)

		Select
			Case $Opening="/"
				$CurrentLine = UpdateLine($CurrentLine, True, "-",$XMLFile)
			Case $Opening<>"?" And $Opening<>"!" And $Opening<>"/" And $Closing<>"/"
				$CurrentLine = UpdateLine($CurrentLine, False, "+",$XMLFile)
			Case Else
				$CurrentLine = UpdateLine($CurrentLine, False, "=",$XMLFile)
		EndSelect

		$StartPos = $LastPos + 1
	Wend
	
	FileClose($XMLFile)
EndFunc
