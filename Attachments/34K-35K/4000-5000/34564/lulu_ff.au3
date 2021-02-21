#include <FfLoad.au3>
#include <find.au3>

$name = FileOpen("name.txt", 0)
$price = FileOpen("price.txt", 0)
$path = FileOpen("path.txt", 0)
$description = FileOpen("description.txt", 0)
$keyword = FileOpen("keyword.txt", 0)


While 1
	$name1 = FileReadLine($name)
    If @error = -1 Then ExitLoop
	$path1 = FileReadLine($path)
    If @error = -1 Then ExitLoop
	$price1 = FileReadLine($price)
    If @error = -1 Then ExitLoop
	$description1 = FileReadLine($description)
    If @error = -1 Then ExitLoop
	$keyword1 = FileReadLine($keyword)
    If @error = -1 Then ExitLoop
		
	#cs 
	Go to Lulu website
	#ce
	Sleep (2000)
	MouseClick ("" , 578, 43 , 1 , 10) 
	Send (" http://www.lulu.com/account/index.php?cid=en_tab_mylulu")
	Send ("{ENTER}")
	_FfLoadWait (58, 79, 1)
	Sleep(1000)
	#cs
	click on ebook
	#ce
	MouseClick ("" , 506, 445 , 1 , 10) 
	_FfLoadWait (58, 79, 1)
	#cs
	Enter title and sell everywhere
	#ce
	MouseClick ("" , 818, 289 , 1 , 10) 
	Sleep (1000)
	Send ($name1)
	MouseClick ("" , 767, 602 , 1 , 10) 
	Sleep (500)
	MouseClick ("" , 497, 401 , 1 , 10) 
	Sleep (500)
	MouseClick ("" , 1324, 671 , 1 , 10) 
	_FfLoadWait (58, 79, 1)
	#cs
	ISBN number
	#ce
	_find (1367, 1035) 
	_FfLoadWait (58, 79, 1)
		#cs
	Isbn confirmation
	#ce
	_find (1367, 600)
	_FfLoadWait (58, 79, 1)
	#cs
	upload file
	#ce
	_upload()
	Sleep (1000)
	Send ($path1)
	sLEEP (1000)
	ControlClick("File Upload", "", "[CLASS:Button;  INSTANCE:1]")
	Sleep (750)
	_upload2()
	_FfLoadWait (58, 79, 1)
	#cs
	confirmation upload ok
	#ce
	_find (1374, 673)
	_FfLoadWait (58, 79, 1)
	#cs
	##################image change################
	#ce
	#cs
	Edit picture
	#ce
	MouseClick ("" , 707, 858 , 1 , 10)
	Sleep (2000)
	#cs
	Use a different file
	#ce
	MouseClick ("" , 735, 615 , 1 , 10)
	Sleep (2000)
	#cs
	upload a File
	#ce
	MouseClick ("" , 691, 453 , 1 , 10)
	Sleep (1000)
	#cs
	Click on field
	#ce
	MouseClick ("" , 702, 509 , 1 , 10)
	Sleep (1000)
	#cs
	write path and ok
	#ce
	Send ("C:\Users\regis\Desktop\lulu\cover.jpg")
	SLEEP(1000)
	ControlClick("File Upload", "", "[CLASS:Button;  INSTANCE:1]")
	Sleep (2000)
	#cs
	click upload
	#ce
	MouseClick ("" , 1043, 514 , 1 , 10)
	_Ffcoverup (735 , 568 , 1)
	#cs
	Click Accept
	#ce
	MouseClick ("" , 1213, 692 , 1 , 10)
	_Ffcoverup (914 , 584 , 1)
	#cs
	page down and text
	#ce
	_text()
	sleep(2000)
	Send ("{pgdn}")
	sleep(1000)
	MouseClick ("" , 645, 478 , 1 , 10)
	_Ffimage (978 , 596 , 1)
	#cs
	no show tile
	#ce
	MouseClick ("" , 1037, 478 , 1 , 10)
	_Ffimage (978 , 596 , 1)
	#cs
	no show author
	#ce
	MouseClick ("" , 1333, 936 , 1 , 10)
	_Ffimage (978 , 596 , 1)
	#cs
	save continue
	#ce
	MouseClick ("" , 1333, 936 , 1 , 10)
	_FfLoadWait (58, 79, 1)
	#cs
	choice section
	#ce
	_find1 (843, 500)
	Send ("e")
	Sleep (1000)
	#cs
	description
	#ce
	MouseClick ("" , 989, 344 , 1 , 10)
	Sleep(1000)
	_find1 (1087, 600)
	Send ( $description1)
	Sleep (2000)
	#cs
	need keywords
	#ce
	_find1 (931, 500)
	Sleep (1000)
	send ( $keyword1)
	Sleep (1000)
	#cs
	copyright
	#ce
	_find1 (1011, 1000)
	Sleep (1000)
	Send ("Bookrags, Inc")
	Sleep (1000)
	#cs
	save continue
	#ce
	_find (1346, 911) 
	_FfLoadWait (58, 79, 1)
	#cs
	DRM choice
	#ce
	_drm()
	Sleep (500)
	_find(1329,597)
	_FfLoadWait (58, 79, 1)
	#cs
	price
	#ce
	_price()
	Sleep (1000)
	Send ("{BS 4}")
	Sleep (1000)
	Send ($price1)
	_find (1341, 720)
	_FfLoadWait (58, 79, 1)
	#cs
	review project, rpivate access
	#ce
	Send ("{pgdn}")
	_find(1358,1024)
	_Fffinish (1134, 591,1)
	#cs
	save finish
	#ce
	MouseClick ("" , 1134, 591 , 1 , 10)
	_FfLoadWait (58, 79, 1)
	


	Wend
	
	FileClose($path)
	FileClose($price)
	FileClose($name)
	FileClose($keyword)
	FileClose($description)