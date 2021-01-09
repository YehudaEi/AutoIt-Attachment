$oGpm = ObjCreate("GPMGMT.GPM")
$oGpConst = $oGpm.GetConstants()
$oRSOP = $oGpm.GetRSOP( $oGpConst.RSOPModeLogging, "" , 0)
$strpath = stringLeft(@ScriptName, StringInStr(@ScriptName,"\")) 
$oRSOP.LoggingFlags = 0
$oRSOP.CreateQueryResults()
$oResult = $oRSOP.GenerateReportToFile( $oGpConst.ReportHTML, $strPath & "rsop.html")
$oRSOP.ReleaseQueryResults()