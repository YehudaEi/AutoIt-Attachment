
$hwnd = GUICreate("Animate Window", 300, 300)

DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00080000);fade-in
GUISetState()
sleep(1000)
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00090000);fade-out
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00040001);slide in from left
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00050002);slide out to left
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00040002);slide in from right
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00050001);slide out to right
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00040004);slide-in from top
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00050008);slide-out to top
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00040008);slide-in from bottom
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00050004);slide-out to bottom
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00040005);diag slide-in from Top-left
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x0005000a);diag slide-out to Top-left
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00040006);diag slide-in from Top-Right
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00050009);diag slide-out to Top-Right
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00040009);diag slide-in from Bottom-left
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00050006);diag slide-out to Bottom-left
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x0004000a);diag slide-in from Bottom-right
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00050005);diag slide-out to Bottom-right
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00040010);explode
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00050010);implode