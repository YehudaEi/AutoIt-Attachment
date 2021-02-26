<$head>
<$title>$HTA $Test</title>
<$HTA:APPLICATION 
     $APPLICATIONNAME="iFIX Startup"
     $SCROLL="no"
     $BORDER="none"
     $BORDERSTYLE="normal"
     $SINGLEINSTANCE="yes"
     $WINDOWSTATE="normal"
     $MAXIMIZEBUTTON="no"
     $MINIMIZEBUTTON="no"
     $SHOWINTASKBAR="no"
     $SYSMENU="no"
     $CAPTION="no">
<$SCRIPT $Language="VBScript">
Dim $mycounter
Dim $abort
Dim $applicomcards
Dim $condition1
Dim $condition2
Dim $applicompath
Dim $compName
Dim $strComputer
Dim $server
Dim $terminal
Dim $WshNetwork
Dim $terminals
Dim $unattendfile
Dim $returnstr
Dim $servername
Dim $objWMIService
Dim $colItems
Dim $objWSHNetwork
Dim $DefaultServer
Dim $RegPath
Dim $RegKey
Dim $fso
Dim $afso
Dim $usedefault
Dim $numserverbuttons
Dim $applicomserverdelay
Dim $terminaldelay
Dim $strTextFile
Dim $strData
Dim $arrLines
Dim $servers
;************************************************************************************************************************************************************************
;Variables
$unattendfile="C:\netinst\unattend.txt"                                      ;Path to unattended.txt $file to determine $number of cyberbase $servers
$applicompath="C:\Program Files\Woodhead\applicom\applicom 3.8\PCINIT.EXE"   ;The path to applicom initialization executable
$RegPath="HKLM\SOFTWARE\National\BaseApp"                                    ;Used in conjunction with $RegKey to store default $startup $server for $terminals in registry
$RegKey="StartUpServer"                                                      ;Used in conjunction with $RegPath to store default $startup $server for $terminals in registry
$applicomserverdelay=5                                                      	;The time (in seconds) to delay $iFIX $startup after applicom initialization
$terminaldelay=5                                                            	;The time (in seconds) the $HTA splash screen is visible before connecting to default $server
$strTextFile = "C:\dynamics\app\clink\Node.ini"								;File used to determine how many $servers exist
$mycounter=5
;************************************************************************************************************************************************************************

$usedefault=1
$numserverbuttons=0

Func Window_Onload()
	Local $Return
	CONST $ForReading = 1
;VA 	On Error Resume Next
	$servers=1
	$strHTML="Manually Start Connection To Server:<$BR><$BR>"
	 $objWSHNetwork=ObjCreate("Wscript.Network")
	$compName=$objWSHNetwork.ComputerName	
	
	If (StringInstr(StringLower($compName),StringLower("term"))>0) Then
		$terminal=1
		$server=0			
		 $objFSO = ObjCreate("Scripting.FileSystemObject")
		If $objFSO.FileExists($strTextFile) Then
			$strData = $objFSO.OpenTextFile($strTextFile,$ForReading).ReadAll
			$arrLines = StringSplit($strData,@CRLF)
			$counter=0
			For $strLine in $arrLines
				If StringLen($strLine)>1 Then
					If Not StringLeft($strLine,1)="#" Then
						If StringInstr(StringUpper($strLine),"BASIC_LOCALNODE")>0 Then
							$counter=$counter+1
						EndIf
					EndIf
				EndIf 
			Next
				If $counter>0 Then
					$servers=$counter
				EndIf
		Else
			MsgBox "No such file: " & $strTextFile,16,"Required $file not found!"
	EndIf
;VA 		Set $objFSO = Nothing		
	Else
		$terminal=0
		$server=1
	EndIf
	
	EmptyTempFolder()
	EmptyALMFolder	()

	If $terminal Then
        $DefaultServer=ReadFromRegistry($RegPath & "\" & $RegKey,"none")	
	    If $DefaultServer="none" Then		
		    $DefaultServer=InputBox("No $server is set as default start-up $server." & Chr(13) & Chr(13)& "Please type default $startup server:","Configure Default $startup-Server","SERVA")
		    WriteToRegistry ($DefaultServer,$RegPath,$RegKey)
	    Else
	    	If Not IsPingable($DefaultServer) Then
	    		$usedefault=0	    		
	    	EndIf
	    	$strHTML=$strHTML & "<input $id='99' type='button' $value='Change Default Server' $onclick='SetDefaultServer'>"
;VA 			On Error Resume Next
			For $i=1 To $servers Step 1
				$servername=ConvertServerNumberToName($i)
				If $usedefault Then
					$strHTML=$strHTML & "<input $id=" & $i & " type='button' $value='SERV" & $servername & "' $onclick='ButtonClick'>" 
					$numserverbuttons=$numserverbuttons+1
				Else					
					If IsPingable("SERV" & ConvertServerNumberToName($i)) Then		
						$strHTML=$strHTML & "<input $id=" & $i & " type='button' $value='SERV" & $servername & "' $onclick='ButtonClick'>"
						$numserverbuttons=$numserverbuttons+1
					EndIf					
				EndIf				
			Next
		If Not $usedefault Then
			MsgBox "Your default $server seems to be offline. Please connect to another $server by clicking on the corresponding button",48,"Default $server offline:"
		EndIf	
		$ServerButtons.InnerHTML=$strHTML
		$mycounter=15
	    EndIf
    EndIf 
   
;	If $server Then
;		InitializeApplicom()
;    	$applicomcards=0
;		$abort=false
;		DetectApplicomCards()
;		If $applicomcards > 1 Then
;			$mycounter=$applicomserverdelay
;		Else
;			$mycounter=5
;		End If		
;	Else	
;	End If

	$iTimerID=$window.setInterVal("RefreshDisplay",1000)	
   	$strComputer = "."
   	 $objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\cimv2")
   	 $colItems = $objWMIService.$ExecQuery("Select * From Win32_DesktopMonitor")
    
	For $objItem in $colItems
   		$intHorizontal = $objItem.ScreenWidth
       	$intVertical = $objItem.ScreenHeight
   	Next
   	If $server Then
   		$intLeft = ($intHorizontal - 800) / 2
   		$intTop = ($intVertical - 400) / 2
   		$window.SetTimeout ("window.resizeTo 800,400",1500)
   		$window.SetTimeout ("window.moveTo $intLeft, intTop",1500	)
	EndIf	
	If 1>$numserverbuttons And $terminal Then
 		$CountDown.InnerHTML="<$BR>No backup $servers online!"
 	Else
 		$CountDown.InnerHTML=""
 	EndIf
	$self.focus()		
	Return $Return
EndFunc  

Func SetDefaultServer		()
	$inputrslt=InputBox("Change default start-up $server." & Chr(13) & Chr(13) & "Please type $A new default $startup server:","Configure Default $startup-Server",$DefaultServer)
	If StringLen($inputrslt)>3 Then
		$DefaultServer=$inputrslt
		WriteToRegistry ($inputrslt,$RegPath,$RegKey		)
	EndIf
EndFunc

Func ReadFromRegistry ($strRegistryKey, $strDefault )	
	Local $Return
;VA 	On Error Resume Next

	 $WSHShell = ObjCreate("WScript.Shell")
	$value = $WSHShell.RegRead( $strRegistryKey )
	if @error <> 0 Then
		$Return= $strDefault
	Else
		$Return=$value
	EndIf	
;VA 	Set $WSHShell = Nothing
	Return $Return
EndFunc

Func WriteToRegistry ($strRegValue,$MyRegPath,$MyRegKey)		
	 $WSHShell = ObjCreate("wscript.Shell")
	$RunCmd="%comspec% /c reg ADD """ & $MyRegPath & """ /v " & $MyRegKey & " /t REG_SZ /d " & $strRegValue	& " /f"	
	$WSHShell.Run ($RunCmd ,0,1)
EndFunc

Func ConvertServerNumberToName ($number)
	Local $Return
	Select 
    	Case $number=1	
    		$returnstr="A"
    	Case $number=2    	
    		$returnstr="B"
    	Case $number=3
    		$returnstr="C"
    	Case $number=4
    		$returnstr="D"
    	Case $number=5
    		$returnstr="E"
    	Case $number=6
    		$returnstr="F"
    	Case $number=7
    		$returnstr="G"
    	Case $number=8
    		$returnstr="H"
    	Case $number=9
    		$returnstr="I"
		Case Else
			$returnstr="A"
	EndSelect	
	$Return=$returnstr	
	Return $Return
EndFunc

Func ButtonClick()
	Local $Return
	 $objButton=$window.event.srcelement
	$servername=ConvertServerNumberToName($objButton.$id)	
	 $WSHShell = ObjCreate("wscript.Shell")
	$WSHShell.Run ("%comspec% /c C:\Dynamics\Launch.exe /n" &compName & $servername & " /sC:\Dynamics\local\TERM.SCU",0,0)
	$self.close()
	Return $Return
EndFunc

Func EmptyALMFolder()
;VA 	On Error Resume Next
	$CountDown.InnerHTML="<$BR>Deleting temporary $iFIX files. Please Wait..."    	
	 $fso = ObjCreate("scripting.filesystemobject")
	If($fso.FolderExists("C:\Dynamics\ALM")) Then
		 $ALMpath=$fso.GetFolder("C:\Dynamics\ALM")
		 $objALMfiles=$ALMpath.Files
  
		For $almfile In $objALMfiles
;VA 			On Error Resume Next
 			$almfile.Delete(1)
		Next  
   
;VA 		Set $objALMfiles=Nothing
;VA 		Set $almfile=Nothing  
	EndIf  
;VA 	Set $fso=Nothing   
EndFunc 

Func EmptyTempFolder()
	$CountDown.InnerHTML="<$BR>Deleting files in C:\Dynamics\ALM folder. Please Wait..."    	
	 $fso = ObjCreate("scripting.filesystemobject")
	 $temppath=$fso.GetFolder($fso.GetSpecialFolder(2))
	 $objTempfiles=$temppath.Files
  
	For $tempfile In $objTempfiles
;VA 		On Error Resume Next
		$condition1=0
		$condition2=0
		If StringLower($fso.GetExtensionName($tempfile))=StringLower("tmp") And StringInstr(StringLower($tempfile.$name),StringLower("df"))>1 Then
			$condition1=1
		EndIf
		If StringLower($fso.GetExtensionName($tempfile))=StringLower("tmp") And StringLower(StringLeft($tempfile.$name,2))=StringLower("df") Then
 			$condition2=1
 		EndIf
 		If $condition1 Or $condition2 Then
 			$tempfile.Delete(1)
 		EndIf 		
	Next  
	   
;VA 	Set $fso=Nothing
;VA 	Set $objTempfiles=Nothing
;VA 	Set $tempfile=Nothing 
;VA 	Set $temppath=Nothing

EndFunc   

Func DetectApplicomCards()
	$strComputer = "."
	 $objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\cimv2")
	 $colItems = $objWMIService.$ExecQuery("Select * From Win32_PnPEntity")

	For $objItem in $colItems
    	If StringInstr(StringUpper($objItem.PNPDeviceID), "PCI\VEN_1389") Then        	
        	$applicomcards=$applicomcards+1
    	EndIf
	Next
EndFunc

Func RefreshDisplay()
 If $usedefault Or $server Then
	$self.focus()
	If $abort Then
		$self.close()
	EndIf
	$mycounter=$mycounter-1
	If $server Then
		$CountDown.InnerHTML="<$BR>Starting $iFIX in "  & $mycounter & " seconds..."		
		If $mycounter=-1 Then
			 $WSHShell = ObjCreate("wscript.Shell")
	  		$WSHShell.Run ("%comspec% /c fix.exe",0,0)
	  		$self.close()
		EndIf	
	Else				
		$CountDown.InnerHTML = "<$BR>Connecting to $server " & $DefaultServer & " in "  & $mycounter & " seconds...<$BR>"
		If $mycounter=-1 Then
			 $WSHShell = ObjCreate("wscript.Shell")
			$WSHShell.Run ("%comspec% /c C:\Dynamics\Launch.exe /n" & $compName & StringMid($DefaultServer,5) & " /sC:\Dynamics\local\TERM.SCU",0,0)
			$self.close()
		EndIf
	EndIf 	
 EndIf
EndFunc    	

Func IsPingable ($strComputer)
	Local $Return
	 $objPing = ObjGet("winmgmts:{impersonationLevel=impersonate}")._
        $ExecQuery("select * from Win32_PingStatus where address = '"_
            & $strComputer & "'")
    For $objStatus in $objPing
        If $objStatus.StatusCode=0 Then            
            $Return=1
        Else
            $Return=0
        EndIf
    Next
	Return $Return
EndFunc

Func ForceAbort()
	$self.close()
	$abort=1
EndFunc

Func InitializeApplicom		()
	 $fso = ObjCreate("scripting.filesystemobject")
	If $fso.FileExists($applicompath) Then	
		 $WSHShell = ObjCreate("wscript.Shell")	
		$WSHShell.Exec ($applicompath)
	EndIf
EndFunc
 
Func Window_onBeforeUnLoad	()
;VA 	Set $abort=Nothing
;VA     Set $mycounter=Nothing
;VA 	Set $applicomcards=Nothing
;VA 	Set $strComputer=Nothing
;VA 	Set $iTimerID=Nothing
;VA 	Set $objWMIService=Nothing
;VA 	Set $colItems=Nothing
;VA 	Set $intHorizontal=Nothing
;VA 	Set $intVertical=Nothing
;VA 	Set $intLeft=Nothing
;VA 	Set $intTop=Nothing
;VA 	Set $returnstr=Nothing
;VA 	Set $servername=Nothing
;VA 	Set $objWMIService=Nothing
;VA 	Set $colItems=Nothing
;VA 	Set $objWSHNetwork=Nothing
;VA 	Set $DefaultServer=Nothing
;VA 	Set $RegPath=Nothing
;VA 	Set $RegKey=Nothing
;VA 	Set $strComputer=Nothing
;VA 	Set $usedefault=Nothing
;VA 	Set $numserverbuttons=Nothing
;VA 	Set $applicomserverdelay=Nothing
;VA 	Set $terminaldelay=Nothing
EndFunc

Func ReadServerNumber()
	 $objFSO = ObjCreate("Scripting.FileSystemObject")
	 $objFile = $objFSO.OpenTextFile($unattendfile, 1)
	Dim $arrFileLines[]
	$arrFileLines=$objFile.ReadAll
	$objFile.Close	()
	For $strLine in $arrFileLines	
		If (StringInstr(StringLower($strLine),StringLower("ServerConnections="))>0) Then
			$tempLine=$strLine
			Trim($tempLine)		
			$tempLine=StringMid($tempLine,18)			
			$servers=$tempLine
		EndIf
	Next	
EndFunc

Func ReadIni($file, $section, $item)
	Local $Return

Dim $oFSO, $ini, $line, $equalpos
Dim $leftstring

   $oFSO  = ObjCreate("Scripting.FileSystemObject")
  $Return = ""
  $file = Trim($file)
  $item = Trim($item)
  If $oFSO.FileExists( $file ) Then
     $ini = $oFSO.OpenTextFile( $file, 1, 0)
    Do While $ini.AtEndOfStream = 0
      $line = $ini.ReadLine
      $line = Trim($line)
      If StringLower($line) = "[" & StringLower($section) & "]" Then	
        $line = $ini.ReadLine
        $line = Trim($line)
        Do While StringLeft( $line, 1) <> "["          
          $equalpos = StringInstr(1, $line, "=", 1 )
          If $equalpos > 0 Then
            $leftstring = StringLeft($line, $equalpos - 1 )
            $leftstring = Trim($leftstring)
            If StringLower($leftstring) = StringLower($item) Then
              $Return = StringMid( $line, $equalpos + 1 )
              $Return = Trim(ReadIni)              
              ExitLoop		
            EndIf
          EndIf
          If $ini.AtEndOfStream Then ExitLoop
          $line = $ini.ReadLine
          $line = Trim($line)
        Loop
        ExitLoop
      EndIf
    Loop
    $ini.Close()
  EndIf
;VA   set $oFSO=nothing
	Return $Return
EndFunc

;</SCRIPT>
;</head>
;<$body $STYLE="font:20pt arial; color:silver;
 ;$filter:progid:DXImageTransform.Microsoft.Gradient()
;($GradientType=0, $StartColorStr=;#000000;, EndColorStr=;#545454;)" $onkeypress="ForceAbort">
;<$DIV $ALIGN=$CENTER>
;<$span $id="ServerButtons"></span><$BR>
;<$span $id="CountDown"></span>
;<$BR><$BR>
;<$button $accesskey="a" $onfocus="ForceAbort" $onkeypress="ForceAbort" $name="Abortbutton" $onclick="ForceAbort"><$u>$A</u>$bort $iFIX $startup</button>
;<$BR><$BR>
;<$font $color=;#ff0000;><b>National Oilwell Varco</b></font>
;</body>
