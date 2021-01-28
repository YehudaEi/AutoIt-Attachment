Sleep(500)
WinActivate("DarKGunZ")
$started = 0
Sleep(500)
while 1 
	if WinActive("DarKGunZ") Then
		
			dim $sum = PixelChecksum(0,0,100,100)
			If $sum = "2089299512" Then ; i want this to create a game, i have marked another spot
				ProcessClose("gunz.exe")
				$started = 0
		If $started = 0 Then ; MUST make this go to the very last else
				Run("E:\Program Files\DarKGunZ\Gunzlauncher.exe","E:\program files\darkgunz\") ; Point to dark gunz launcher, and the folder its loacted in.
				Sleep(1000)
				dim $startgame = PixelChecksum(550,490,730,530)
				Do
					sleep(100)
					Dim $startgame1 = PixelChecksum(550,490,730,530)
				Until $startgame  <> $startgame1
				MouseClick("Left",640,488,1)
				Sleep(2000)
				Run("E:\Documents and Settings\Admin\Desktop\copy mrs.bat") ; MRS replacement .BAT file full location.
				Sleep(20000)
				WinActivate("DarKGunZ")
				Do
					Sleep(200)
					dim $sum = PixelChecksum(0,0,100,100)
				Until $sum = "2089299512"
				Sleep(5000)
				MouseClick("Left",580,435,1) 
				Sleep(100)
				Send("{BS 25}")
				Sleep(100)
				Send("account") ; your account name
				Sleep(100)
				MouseClick("Left",500,480,1) 
				Sleep(100)
				Send("{BS 25}")
				Sleep(100)
				Send("password") ; this is your password
				Sleep(100)
				MouseClick("Left",409,409,1) 
				Sleep(100)
				Send ("{c}")
				Do
					Sleep(300)
					Dim $charsel = PixelChecksum(230,410,260,420) ; check until your at char select and still
				Until $charsel = "1896644611"
				Sleep(300)
				MouseClick("Left",560,610,1)
				Do ; check until char is logged in
					Sleep(100)
					dim $game = PixelChecksum(200,50,250,100) ; checks for game lobby
				Until $game = "612179385"
				;THIS IS WHERE THE GAME CREATE STARTS

				MouseClick("Left",600,75,1) 
				Sleep(200)
				MouseClick("Left",260,260,1) 
				Sleep(500)
				MouseClick("Left",455,465,1) 
				SLeep(100)
				MouseClick("Left",385,360,1) 
				SLeep(200)
				MouseClick("Left",545,300,1) 
				Send("{BS 50}")
				Send("Meowwwww") ; text of game room name
				sleep(100)
				MouseClick("Left",540,333,1) 
				Send("{BS 50}")
				Send("meowmix") ; password of game
				Sleep(100)
				MouseClick("Left",415,380,1) 
				Sleep(1500)
				MouseClick("Left",760,175,1) 
				Sleep(50)
				MouseClick("Left",580,330,1) 
				Sleep(300)
				MouseClick("Left",85,170,1) ; click on doll to see if have 99
				Sleep(1500)
				dim $dolls = PixelChecksum(66,457,79,469) ; check if value matches 99
				If $dolls = "3795085602" Then ; do nothing you have 99 tell variable started
					$started = 1 ; you have now started questing
				Else ; Enter shop and proceed to buy quest items
					MouseClick("Left",700,600,1) 
					Sleep(50)
					MouseClick("Left",475,360,1) 
					Sleep(2000)
					MouseClick("Left",350,80,1) 
					Sleep(1000)
					MouseClick("Left",770,180,1)
					SLeep(100)
					MouseClick("Left",640,390,1) 
					Sleep(200)
					Mouseclick("Left",765,350,1)
					Sleep(100)
					Dim $num1 = 0
					While $num1 < 30
						MouseClick("Left",640,450,1) ; buy
						Send("{B}")
						Send("{enter}")
						Sleep(30)
						Send("{enter}")
						Sleep(30)
						$num1 += 1
					Wend
					Send("{enter}")
					Mouseclick("Left",765,301,1) 
					Sleep(100)
					Dim $num2 = 0
					While $num2 < 30
						MouseClick("Left",640,450,1) ; buy
						Send("{B}")
						Send("{enter}")
						Sleep(50)
						Send("{enter}")
						Sleep(50)
						$num2 += 1
					WEnd
					Sleep(400)
					Send("{Enter}")
					MouseClick("Left",715,600,1) 
					Sleep(200)
					MouseClick("Left",385,360,1) 
					SLeep(200)
					MouseClick("Left",545,300,1)
					Send("{BS 50}")
					Send("Meowwwww") ; text of game room name
					sleep(100)
					MouseClick("Left",540,333,1) 
					Send("{BS 50}")
					Send("meowmix") ; password of game
					Send("{enter}") 
					Sleep(1500)
					MouseClick("Left",760,175,1) 
					Sleep(50)
					MouseClick("Left",580,330,1) 
					Sleep(100)
					$started = 1 
				EndIf
			Else ; LAST else will quest
			Sleep(3000)
			MouseClickdrag("Left",60, 170,280,210,3)
			Sleep(300)
			MouseClickdrag("Left",75,200,420,210,3)
			sleep(250)
			MouseClick("Left",675, 280,1)
			sleep(13000)
			send("{a down}")
			Sleep(3000)
			Send ("{a up}")
			sleep(5500)
			Send("{d down}")
			Sleep(300)
			Send ("{d up}")
			Sleep(5000)
			Send("{a down}")
			Sleep(250)
			Send ("{a up}")
			Sleep(30000)
			$started = 1
			Mouseclick ("left", 350,320,1)
			Sleep(2000)
			Endif
		EndIf
	EndIf
Wend