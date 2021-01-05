While 1
	sleep(50)
	hotkeyset("{F9}","start")
Wend

Func start()
$prolist = ProcessList()
$number = $prolist[0][0]
iniwrite("Process List.ini","Number:","Number",$number)

for $a = 1 to $number
	Iniwrite("Process List.ini","Processes:",$a,$prolist[$a][0])
next

#include <GUIConstants.au3>

GUICreate("Process Ender 1.3 Final", 300, 200)
	
$kill = GuiCtrlCreateButton("Kill Process",10,10,65)
$refresh = GuiCtrlCreateButton("Refresh",10,40,65)
$about = GuiCtrlCreateButton("About",10,70,65)
guictrlcreatepic("SZ.jpg",10,100,90)
$list = GuiCtrlCreateList("",100,10,190,190)
guisetstate()

for $a = 1 to $number
	$p = iniread("Process List.ini","Processes:",$a,"error!")
	GuiCtrlCreateListViewItem($p,$a)
	GuiCtrlSetData($list,$p)
next

guisetstate()

While 1
$msg = guigetmsg()
	If $msg = $gui_event_close Then
		Exit
	endif

	If $msg = $kill Then
		$killpro = GuiCtrlRead($list)
		ProcessClose($killpro)
		MsgBox(0,"Operation Completed","The operation of ending the process " & $killpro & " has been completed successfully!")
		
		$prolist = ProcessList()
		$number = $prolist[0][0]
		iniwrite("Process List.ini","Number:","Number",$number)

		for $a = 1 to $number
			Iniwrite("Process List.ini","Processes:",$a,$prolist[$a][0])
		next
	
		for $a = 1 to $number
			$p = iniread("Process List.ini","Processes:",$a,"error!")
			GuiCtrlCreateListViewItem($p,$a)
			GuiCtrlSetData($list,$p)
		next	
	endif

	If $msg = $about Then
		MsgBox(0,"Process Ender v1.3 Final","Written and Debugged entirely by Centurion_D..." & @CRLF & "This program was designed to work much more quickly and efficiently than the ordinary Windows Task Manager. So far there are no bugs...to my knowledge..." & @CRLF & "For any bug reports or feature requests...send an email to epsilon045@gmail.com.")
	endif
	
	If $msg = $gui_event_minimize Then
		Winsetstate("Process Ender v1.3 Final","",@SW_MINIMIZE )
	endif

	If $msg = $refresh Then
		$prolist = ProcessList()
		$number = $prolist[0][0]
		iniwrite("Process List.ini","Number:","Number",$number)

		for $a = 1 to $number
			Iniwrite("Process List.ini","Processes:",$a,$prolist[$a][0])
		next
	
		for $a = 1 to $number
			$p = iniread("Process List.ini","Processes:",$a,"error!")
			GuiCtrlCreateListViewItem($p,$a)
			GuiCtrlSetData($list,$p)
		next
	endif
wend
endfunc