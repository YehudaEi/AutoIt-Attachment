; Capture full screen
; Fist parameter - filename, last - jpeg quality. 
DllCall("captdll.dll", "int", "CaptureScreen", "str", "dump_full.jpg", "int", 85)
; Capture given region
; Fist parameter - filename, next four: left, top, width, height. Last one - jpeg quality.
; Set quality to any negative number to capture into BMP
DllCall("captdll.dll", "int", "CaptureRegion", "str", "dump_partial.bmp", "int", 100, "int", 100, "int", 300, "int", 200, "int", -1)