Do
	HotKeySet("^+a", "husa")
Until @hour = 25
	Func husa()
		SplashTextOn("Husa", "Hello, I'm Husa...")
		Sleep(10000)
		SplashOff()
	EndFunc