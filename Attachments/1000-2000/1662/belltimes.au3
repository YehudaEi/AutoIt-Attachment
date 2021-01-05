Select

Case @WDAY = 2 OR @WDAY = 3
  Dim $bells[6][2]
  $bells[0][0] = "1st/2nd Period"
  $bells[0][1] = 0850
  $bells[1][0] = "Advisor"
  $bells[1][1] = 0915
  $bells[2][0] = "3rd/4th Period"
  $bells[2][1] = 1050
  $bells[3][0] = "5th Period"
  $bells[3][1] = 1205
  $bells[4][0] = "2nd Lunch"
  $bells[4][1] = 1240
  $bells[5][0] = "6th/7th Period"
  $bells[5][1] = 1415


Case @WDAY = 4
  Dim $bells[7][2]
  $bells[0][0] = "1st Period"
  $bells[0][1] = 0809
  $bells[1][0] = "2nd Period"
  $bells[1][1] = 0903
  $bells[2][0] = "3rd Period"
  $bells[2][1] = 0957
  $bells[3][0] = "4th Period"
  $bells[3][1] = 1051
  $bells[4][0] = "6th Period"
  $bells[4][1] = 1145
  $bells[5][0] = "2nd Lunch"
  $bells[5][1] = 1220
  $bells[6][0] = "7th Period"
  $bells[6][1] = 1315


Case @WDAY = 5 OR @WDAY = 6
  Dim $bells[8][2]
  $bells[0][0] = "1st Period"
  $bells[0][1] = 0810
  $bells[1][0] = "2nd Period"
  $bells[1][1] = 0905
  $bells[2][0] = "3rd Period"
  $bells[2][1] = 1000
  $bells[3][0] = "4th Period"
  $bells[3][1] = 1055
  $bells[4][0] = "5th Period"
  $bells[4][1] = 1155
  $bells[5][0] = "2nd Lunch"
  $bells[5][1] = 1225
  $bells[6][0] = "6th Period"
  $bells[6][1] = 1320
  $bells[7][0] = "7th Period"
  $bells[7][1] = 1415

EndSelect