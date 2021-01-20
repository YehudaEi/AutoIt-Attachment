
#include <GUIConstants.au3>


;CLIENT!!!!!!!! Start the SERVER First... dummy!!
$g_IP = "192.168.1.101"
$Message = "Hello World"
; Start The TCP Services
;==============================================
TCPStartUp()

; Connect to a Listening "SOCKET"
;==============================================
$socket = TCPConnect( $g_IP, 8084 )
TCPSend($socket,$message)




