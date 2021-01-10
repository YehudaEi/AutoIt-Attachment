Opt("TrayIconHide", 1)
Global $List
While True
	Do
		Sleep(500)
		$List = WinList('[CLASS:SciTEWindow]')
	Until $List[0][0] = 2
	WinMove($List[1][1], '', 0, 0, @DesktopWidth/2, @DesktopHeight)
	WinMove($List[2][1], '', @DesktopWidth/2, 0, @DesktopWidth/2, @DesktopHeight)
	Do
		Sleep(500)
		$List = WinList('[CLASS:SciTEWindow]')
	Until $List[0][0] = 1
	WinMove($List[1][1], '', 0, 0, @DesktopWidth, @DesktopHeight)
WEnd