#Include <File.au3>
Global $total,$startwith,$tocken,$readperistalsis,$solution
$solution="FALSE"
call ("startup")

func startup()
	$total=inputbox ("","Total number")
	$startwith=inputbox ("","Start with")
	call ("filemaker",$total,$startwith)
EndFunc

func filemaker($total,$startwith)
	$initialwrite=fileopen ("JAILED.txt",1)
	$writeno=1
	Do
		filewriteline ($initialwrite,"ALIVE" & @CRLF)
		$writeno=$writeno+1
	Until $writeno>$total
	FileClose ($initialwrite)
call ("inisolver")
EndFunc

func inisolver ()
	_FileWriteToLine ("JAILED.txt",$startwith+1,"DEAD",1)

	$readperistalsis=$startwith+2
	$tocken=0

call ("regularsolver")
EndFunc

Func regularsolver()
	Do
		$currentstat=filereadline ("JAILED.txt",$readperistalsis)
		if $currentstat="ALIVE" and $tocken =1 Then
				call ("killit")
			EndIf
		If $currentstat="ALIVE" and $tocken=0 Then
			$tocken=1
		EndIf
		
		if $readperistalsis=$total Then
			$readperistalsis=1
		Else
			$readperistalsis=$readperistalsis+1
		EndIf
		
		call ("checkforsolution")
	Until $solution="TRUE"
	
	if $solution="TRUE" Then
		Exit
	EndIf
	
EndFunc

Func killit()
	_filewritetoline ("JAILED.txt",$readperistalsis,"DEAD",1)
	$tocken=0
	call ("regularsolver")
EndFunc

func checkforsolution()
	$i=0
	$no=0
	Do
		$line=FilereadLine ("JAILED.txt",$i)
		if $line="ALIVE" Then
			$no=$no+1
		EndIf
		$i=$i+1
	until $i>$total
	if $no=1 Then
		msgbox (64,"","solved")
		$i2=1
		Do
		$line2=FilereadLine ("JAILED.txt",$i2)
		if $line2="ALIVE" Then
			$resultfile=fileopen ("RESULT.txt",1)
			filewrite ($resultfile,$i2)
			fileclose ($resultfile)
		EndIf
		$i2=$i2+1
	until $i2>$total
	Exit
	Else
		call ("regularsolver")
	EndIf
EndFunc

		