#include <_sql.au3>
#include <array.au3>

ImageAccess("TestUser")

Func ImageAccess($ADUsername)
	local $sql
	local $orgsql,$defsql,$oADODB,$qh,$rst
	dim $row[1]

	$sql = "DECLARE @RC int "
	$sql &= "DECLARE @p_ADUsername varchar(32) "
	$sql &= "DECLARE @o_HasMVClinicalAccess smallint "
	$sql &= "DECLARE @o_ErrorMsg varchar(1000) "
	$sql &= "set @p_ADUsername = '"&$ADUsername&"' "
	$sql &= "EXECUTE @RC = [MVSEC].[radiology].[LookupUser] "
	$sql &= "@p_ADUsername "
	$sql &= ",@o_HasMVClinicalAccess OUTPUT "
	$sql &= ",@o_ErrorMsg OUTPUT "
	$sql &= "select @RC, @o_HasMVClinicalAccess, @o_ErrorMsg;"

	_SQL_RegisterErrorHandler();register the error handler to prevent hard crash on COM error

    $oADODB = _SQL_Startup()
    If $oADODB = $SQL_ERROR then
		Msgbox(0 + 16 +262144,"Error",_SQL_GetErrMsg())
	EndIf

	If _sql_Connect($oADODB,"mvsqlprod","MVSEC","user","password") = $SQL_ERROR then
        Msgbox(0 + 16 +262144,"Error",_SQL_GetErrMsg())
        _SQL_Close()
        Exit
    EndIf

	$qh = _SQL_Execute(-1,$sql)

	if $qh = $SQL_ERROR Then
		MsgBox(0+16+262144,"Error",_SQL_GetErrMsg())
		return(0)
	Else
		if _SQL_FetchData($qh,$row) = $SQL_ERROR Then
			If _SQL_GetErrMsg() = "End of Data Stream" Then
				MsgBox(0+16+262144,"Error","No records were returned!?!")
				return(0)
			EndIf
			MsgBox(0+16+262144,"Error",_SQL_GetErrMsg())
			return(0)
		Else
			_ArrayDisplay($row,"Results")
		EndIf
	EndIf
	Return(1)
EndFunc