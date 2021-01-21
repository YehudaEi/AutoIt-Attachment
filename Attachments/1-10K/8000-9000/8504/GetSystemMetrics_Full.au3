
;Declare Function GetSystemMetrics Lib "user32" 
;Alias "GetSystemMetrics" (ByVal nIndex As Long) As Long

$SM_CYDOUBLECLK = 37
$SM_MOUSEPRESENT = 19
$SM_SWAPBUTTON = 23
$SM_CXFULLSCREEN = 16 ;Width of client area of maximized window
$SM_CYFULLSCREEN = 17 ;Height of client area of maximized window
 $SM_CXICON = 11 ;Width of standard icon
 $SM_CYICON = 12 ; Height of standard icon
 

 $Get = DllCall("user32.dll","long","GetSystemMetrics","int",$SM_CYDOUBLECLK)
;MsgBox(262144, "",@error )
MsgBox(262144, "","double click area   " & $Get[0])
 $Get = DllCall("user32.dll","long","GetSystemMetrics","int",$SM_MOUSEPRESENT )
;MsgBox(262144, "",@error )
MsgBox(262144, "","Is Mouse present ?  " &$Get[0])
$Get = DllCall("user32.dll","long","GetSystemMetrics","int",$SM_SWAPBUTTON )
;MsgBox(262144, "",@error )
MsgBox(262144, "", "Is Mouse swaped ?   "& $Get[0])
$Client1 = DllCall("user32.dll","long","GetSystemMetrics","int",$SM_CXFULLSCREEN )
$Client2 = DllCall("user32.dll","long","GetSystemMetrics","int",$SM_CXFULLSCREEN )
;MsgBox(262144, "",@error )
MsgBox(262144, "", "Client Area  "& $Client1[0] & "  " & $Client2[0])
$Get = DllCall("user32.dll","long","GetSystemMetrics","int",$SM_CXICON )
$Get1 = DllCall("user32.dll","long","GetSystemMetrics","int",$SM_CYICON )
MsgBox(262144, "","Width and Height of standard icon   " & $Get[0] & "   " & $Get1[0])



; ecc

;GetSystemMetrics() codes
;Enum EGSMCode
    $SM_CXSCREEN = 0
    $SM_CYSCREEN = 1
    $SM_CXVSCROLL = 2
    $SM_CYHSCROLL = 3
    $SM_CYCAPTION = 4
    $SM_CXBORDER = 5
    $SM_CYBORDER = 6
    $SM_CXDLGFRAME = 7
    $SM_CYDLGFRAME = 8
    $SM_CYVTHUMB = 9
    $SM_CXHTHUMB = 10
    $SM_CXICON = 11
    $SM_CYICON = 12
    $SM_CXCURSOR = 13
    $SM_CYCURSOR = 14
    $SM_CYMENU = 15
    $SM_CXFULLSCREEN = 16
    $SM_CYKANJIWINDOW = 18
    $SM_MOUSEPRESENT = 19
    $SM_CYVSCROLL = 20
    $SM_CXHSCROLL = 21
    $SM_DEBUG = 22
    $SM_SWAPBUTTON = 23
    $SM_RESERVED1 = 24
    $SM_RESERVED2 = 25
    $SM_RESERVED3 = 26
    $SM_RESERVED4 = 27
    $SM_CXMIN = 28
    $SM_CYMIN = 29
    $SM_CXSIZE = 30
    $SM_CYSIZE = 31
    $SM_CYFRAME = 33
    $SM_CXMINTRACK = 34
    $SM_CYMINTRACK = 35
    $SM_CXDOUBLECLK = 36
    $SM_CYDOUBLECLK = 37
    $SM_CXICONSPACING = 38
    $SM_CYICONSPACING = 39
    $SM_MENUDROPALIGNMENT = 40
    $SM_PENWINDOWS = 41
    $SM_DBCSENABLED = 42
    $SM_CMOUSEBUTTONS = 43
       
    ;#if(WINVER >= 0x0400)
    $SM_CXFIXEDFRAME = $SM_CXDLGFRAME        ;  '/* ;win40 name change */
    $SM_CYFIXEDFRAME = $SM_CYDLGFRAME         ;  '/* ;win40 name change */
    ;$SM_CXSIZEFRAME = $SM_CXFRAME             ;  '/* ;win40 name change */
    $SM_CYSIZEFRAME = $SM_CYFRAME              ; '/* ;win40 name change */
    $SM_CXEDGE = 45
    $SM_CYEDGE = 46
    $SM_CXMINSPACING = 47
    $SM_CYMINSPACING = 48
    $SM_CXSMICON = 49
    $SM_CYSMICON = 50
    $SM_CYSMCAPTION = 51
    $SM_CXSMSIZE = 52
    $SM_CYSMSIZE = 53
    $SM_CXMENUSIZE = 54
    $SM_CYMENUSIZE = 55
    $SM_ARRANGE = 56
    $SM_CXMINIMIZED = 57
    $SM_CYMINIMIZED = 58
    $SM_CXMAXTRACK = 59
    $SM_CYMAXTRACK = 60
    $SM_CXMAXIMIZED = 61
    $SM_CYMAXIMIZED = 62
    $SM_NETWORK = 63
    $SM_CLEANBOOT = 67
    $SM_CXDRAG = 68
    $SM_CYDRAG = 69
    ;#endif /* WINVER >= 0x0400 */
    $SM_SHOWSOUNDS = 70
    ;#if(WINVER >= 0x0400)
    $SM_CXMENUCHECK = 71        ;  '/* Use instead of GetMenuCheckMarkDimensions()! */
    $SM_CYMENUCHECK = 72
    $SM_SLOWMACHINE = 73
    $SM_MIDEASTENABLED = 74
    ;#endif /* WINVER >= 0x0400 */
    ;#if(_WIN32_WINNT >= 0x0400)
    $SM_MOUSEWHEELPRESENT = 75
  ;  '#endif /* _WIN32_WINNT >= 0x0400 */
   ; '#if (_WIN32_WINNT < 0x0400)
    $SM_CMETRICS_WIN_NT3 = 75
    ;'#Else
    $SM_CMETRICS = 76
    
    
#cs
Const SM_CXSCREEN = 0 'X Size of screen
Const SM_CYSCREEN = 1 'Y Size of Screen
Const SM_CXVSCROLL = 2 'X Size of arrow in vertical scroll bar.
Const SM_CYHSCROLL = 3 'Y Size of arrow in horizontal scroll bar
Const SM_CYCAPTION = 4 'Height of windows caption
Const SM_CXBORDER = 5 'Width of no-sizable borders
Const SM_CYBORDER = 6 'Height of non-sizable borders
Const SM_CXDLGFRAME = 7 'Width of dialog box borders
Const SM_CYDLGFRAME = 8 'Height of dialog box borders
Const SM_CYVTHUMB = 9 'Height of scroll box on horizontal scroll bar
Const SM_CXHTHUMB = 10 ' Width of scroll box on horizontal scroll bar
Const SM_CXICON = 11 'Width of standard icon
Const SM_CYICON = 12 'Height of standard icon
Const SM_CXCURSOR = 13 'Width of standard cursor
Const SM_CYCURSOR = 14 'Height of standard cursor
Const SM_CYMENU = 15 'Height of menu
Const SM_CXFULLSCREEN = 16 'Width of client area of maximized window
Const SM_CYFULLSCREEN = 17 'Height of client area of maximized window
Const SM_CYKANJIWINDOW = 18 'Height of Kanji window
Const SM_MOUSEPRESENT = 19 'True is a mouse is present
Const SM_CYVSCROLL = 20 'Height of arrow in vertical scroll bar
Const SM_CXHSCROLL = 21 'Width of arrow in vertical scroll bar
Const SM_DEBUG = 22 'True if deugging version of windows is running
Const SM_SWAPBUTTON = 23 'True if left and right buttons are swapped.
Const SM_CXMIN = 28 'Minimum width of window
Const SM_CYMIN = 29 'Minimum height of window
Const SM_CXSIZE = 30 'Width of title bar bitmaps
Const SM_CYSIZE = 31 'height of title bar bitmaps
Const SM_CXMINTRACK = 34 'Minimum tracking width of window
Const SM_CYMINTRACK = 35 'Minimum tracking height of window
Const SM_CXDOUBLECLK = 36 'double click width
Const SM_CYDOUBLECLK = 37 'double click height
Const SM_CXICONSPACING = 38 'width between desktop icons
Const SM_CYICONSPACING = 39 'height between desktop icons
Const SM_MENUDROPALIGNMENT = 40 'Zero if popup menus are aligned to the left of the memu bar item. True if it is aligned to the right.
Const SM_PENWINDOWS = 41 'The handle of the pen windows DLL if loaded.
Const SM_DBCSENABLED = 42 'True if double byte characteds are enabled
Const SM_CMOUSEBUTTONS = 43 'Number of mouse buttons.
Const SM_CMETRICS = 44 'Number of system metrics
Const SM_CLEANBOOT = 67 'Windows 95 boot mode. 0 = normal, 1 = safe, 2 = safe with network
Const SM_CXMAXIMIZED = 61 'default width of win95 maximised window
Const SM_CXMAXTRACK = 59 'maximum width when resizing win95 windows
Const SM_CXMENUCHECK = 71 'width of menu checkmark bitmap
Const SM_CXMENUSIZE = 54 'width of button on menu bar
Const SM_CXMINIMIZED = 57 'width of rectangle into which minimised windows must fit.
Const SM_CYMAXIMIZED = 62 'default height of win95 maximised window
Const SM_CYMAXTRACK = 60 'maximum width when resizing win95 windows
Const SM_CYMENUCHECK = 72 'height of menu checkmark bitmap
Const SM_CYMENUSIZE = 55 'height of button on menu bar
Const SM_CYMINIMIZED = 58 'height of rectangle into which minimised windows must fit.
Const SM_CYSMCAPTION = 51 'height of windows 95 small caption
Const SM_MIDEASTENABLED = 74 'Hebrw and Arabic enabled for windows 95
Const SM_NETWORK = 63 'bit o is set if a network is present. Const SM_SECURE = 44 'True if security is present on windows 95 system
Const SM_SLOWMACHINE = 73 'true if machine is too slow to run win95.

#ce
