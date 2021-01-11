#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.0.1
 Author:         Donald Nelson  donnie@nelsagen.com

 Script Function:
	Global Variables.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include-once

Global $gBlackCanMove
Global $gWhiteCanMove
Global $gBoard[8][8][3]
Global $bActive = False
Global $bGameOver = False
Global $Me = 0
Global $Him = 0
Global $pTurn = 0

;TCP Socket Variables
Global $_IPADDRESS = @IPAddress1
Global $_PORT = 12345
Global $gConnectedSocket = -1
Global $gMainSocket = -1
Global Const $enumText = 3
Global Const $enumGameBoard = 4
Global Const $enumQuit = 5
Global Const $enumGameOver = 6
