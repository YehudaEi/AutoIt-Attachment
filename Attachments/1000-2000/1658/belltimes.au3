Select

Case @WDAY = 2 OR @WDAY = 3
  Dim $bells[6][3]
  $bells[0][0] = "1st/2nd Period"
  $bells[0][1] = 8
  $bells[0][2] = 50
  $bells[1][0] = "Advisor"
  $bells[1][1] = 9
  $bells[1][2] = 15
  $bells[2][0] = "3rd/4th Period"
  $bells[2][1] = 10
  $bells[2][2] = 50
  $bells[3][0] = "5th Period"
  $bells[3][1] = 12
  $bells[3][2] = 05
  $bells[4][0] = "2nd Lunch"
  $bells[4][1] = 12
  $bells[4][2] = 40
  $bells[5][0] = "6th/7th Period"
  $bells[5][1] = 2
  $bells[5][2] = 15


Case @WDAY = 4
  Dim $bells[7][3]
  $bells[0][0] = "1st Period"
  $bells[0][1] = 8
  $bells[0][2] = 09
  $bells[1][0] = "2nd Period"
  $bells[1][1] = 9
  $bells[1][2] = 03
  $bells[2][0] = "3rd Period"
  $bells[2][1] = 9
  $bells[2][2] = 57
  $bells[3][0] = "4th Period"
  $bells[3][1] = 10
  $bells[3][2] = 51
  $bells[4][0] = "6th Period"
  $bells[4][1] = 11
  $bells[4][2] = 45
  $bells[5][0] = "2nd Lunch"
  $bells[5][1] = 12
  $bells[5][2] = 20
  $bells[6][0] = "7th Period"
  $bells[6][1] = 1
  $bells[6][2] = 15


Case @WDAY = 5 OR @WDAY = 6
  Dim $bells[8][3]
  $bells[0][0] = "1st Period"
  $bells[0][1] = 8
  $bells[0][2] = 10
  $bells[1][0] = "2nd Period"
  $bells[1][1] = 9
  $bells[1][2] = 05
  $bells[2][0] = "3rd Period"
  $bells[2][1] = 10
  $bells[2][2] = 00
  $bells[3][0] = "4th Period"
  $bells[3][1] = 10
  $bells[3][2] = 55
  $bells[4][0] = "5th Period"
  $bells[4][1] = 11
  $bells[4][2] = 55
  $bells[5][0] = "2nd Lunch"
  $bells[5][1] = 12
  $bells[5][2] = 25
  $bells[6][0] = "6th Period"
  $bells[6][1] = 1
  $bells[6][2] = 20
  $bells[7][0] = "7th Period"
  $bells[7][1] = 2
  $bells[7][2] = 15

EndSelect