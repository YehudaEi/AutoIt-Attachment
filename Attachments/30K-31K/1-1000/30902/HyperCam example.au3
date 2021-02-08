#include <HyperCam.au3>

_HyperCam_StartRec("c:\full resolution 3 second recording.avi")
Sleep(3000)
_HyperCam_StopRec()

_HyperCam_StartRec("c:\400x300 3 second recording.avi", 0, 0, 400, 300, "MSVC", 40, 8, 10, 0, 8, -1)
Sleep(3000)
_HyperCam_StopRec()
