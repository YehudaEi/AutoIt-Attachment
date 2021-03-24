Global $Store_ID, $CKNum1, $CKNum_P, $CKNum_S, $SaleID1, $SaleID_P, $SaleID_S

$constrim="DRIVER={SQL Server};SERVER=Server\DB1_SQL;DATABASE=Prog_Test;uid=sa;pwd=Password;"
$adCN = ObjCreate ("ADODB.Connection") ; <== Create SQL connection
$adCN.Open ($constrim) ; <== Connect with required credentials


if @error Then
    MsgBox(0, "ERROR", "Failed to connect to the database")
    Exit
Else
    MsgBox(0, "Success!", "Connection to database successful!")
EndIf


$Store_ID = $adCN.Execute ("Select StoreID from Store")

MsgBox(4096, "list", $Store_ID)

If Not ($Store_ID = $Store_ID) Then
  MsgBox(0, "ERROR", "Invalid Registration")
 Exit
Else
 MsgBox(0, "Check #", "Get Check Number to Delete")
 EndIf

$CKNum1 = 33882

$SaleID1 = $adCN.Execute("Select SaleID from Sale where CheckNumber = " & $CKNum1)

$adCN.Execute("Delete From Sale Where CheckNumber = " & $CKNum1)
$adCN.Execute("Delete From Sale2 Where SaleID = " & $SaleID1)

MsgBox(0, "SaleID", $SaleID1)
$adCN.Close ; ==> Close the database