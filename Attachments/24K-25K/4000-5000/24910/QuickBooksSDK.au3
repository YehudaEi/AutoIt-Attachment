#include-once

;=======================================================================
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; QuickBooks SDK Variables
; AutoIt Version: 3.1.1.120 (beta)
; Author: Jarvis Stubblefield (support "at" vortexrevolutions "dot" com)
; Description: To be used with the QBFC5.0 SDK from Intuit.
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;=======================================================================

;ENOpenMode
Global Const $omSingleUser = 0
Global Const $omMultiUser = 1
Global Const $omDontCare = 2

;ENRqOnError
Global Const $roeStop = 0
Global Const $roeContinue = 1
Global Const $roeRollback = 2

;ENReleaseLevel
Global Const $rlPreAlpha = 0
Global Const $rlAlpha = 1
Global Const $rlBeta = 2
Global Const $rlRelease = 3

;ENRqResponseData
Global Const $rdIncludeAll = 0
Global Const $rdIncludeNone = 1

;ENActiveStatus
Global Const $asActiveOnly = 0
Global Const $asInactiveOnly = 1
Global Const $asAll = 2

;ENAccountType
Global Const $atAccountsPayable = 0
Global Const $atAccountsReceivable = 1
Global Const $atBank = 2
Global Const $atCostOfGoodsSold = 3
Global Const $atCreditCard = 4
Global Const $atEquity = 5
Global Const $atExpense = 6
Global Const $atFixedAsset = 7
Global Const $atIncome = 8
Global Const $atLongTermLiability = 9
Global Const $atOtherAsset = 10
Global Const $atOtherCurrentAsset = 11
Global Const $atOtherCurrentLiability = 12
Global Const $atOtherExpense = 13
Global Const $atOtherIncome = 14
Global Const $atNonPosting = 15

;ENORAccountListQuery
Global Const $oralqNA = -1
Global Const $oralqListID = 0
Global Const $oralqFullName = 1
Global Const $oralqAccountListFilter = 2

;ENORNameFilter
Global Const $ornfNA = -1
Global Const $ornfNameFilter = 0
Global Const $ornfNameRangeFilter = 1

;ENORCustomerListQuery
Global Const $orclqNA = -1
Global Const $orclqListID = 0
Global Const $orclqFullName = 1
Global Const $orclqCustomerListFilter = 2

;ENORRate
Global Const $orrNA = -1
Global Const $orrRate = 0
Global Const $orrRatePercent = 1

;ENOREarnings
Global Const $oreNA = -1
Global Const $oreClearEarnings = 0
Global Const $oreEarnings = 1

;ENORListQuery
Global Const $orlqNA = -1
Global Const $orlqListID = 0
Global Const $orlqFullName = 1
Global Const $orlqListFilter = 2

;ENORVendorListQuery
Global Const $orvlqNA = -1
Global Const $orvlqListID = 0
Global Const $orvlqFullName = 1
Global Const $orvlqVendorListFilter = 2

;ENDoneStatus
Global Const $dsNotDoneOnly = 0
Global Const $dsDoneOnly = 1
Global Const $dsAll = 2

;ENORToDoListQuery
Global Const $ortdlqNA = -1
Global Const $ortdlqListID = 0
Global Const $ortdlqToDoListFilter = 1

;ENORSalesPurchase
Global Const $orspNA = -1
Global Const $orspSalesOrPurchase = 0
Global Const $orspSalesAndPurchase = 1

;ENORPrice
Global Const $orpNA = -1
Global Const $orpPrice = 0
Global Const $orpPricePercent = 1

;ENORSalesPurchaseMod
Global Const $orspmNA = -1
Global Const $orspmSalesOrPurchaseMod = 0
Global Const $orspmSalesAndPurchaseMod = 1

;ENORItemInventoryAssemblyLine
Global Const $oriialNA = -1
Global Const $oriialClearItemsInGroup = 0
Global Const $oriialItemInventoryAssemblyLine = 1

;ENORDiscountRate
Global Const $ordrNA = -1
Global Const $ordrDiscountRate = 0
Global Const $ordrDiscountRatePercent = 1

;ENORPaymentDeposit
Global Const $orpdNA = -1
Global Const $orpdGroupWithUndepositedFunds = 0
Global Const $orpdDepositToAccountRef = 1

;ENORItemGroupLine
Global Const $origlNA = -1
Global Const $origlClearItemsInGroup = 0
Global Const $origlItemGroupLine = 1

;ENORInvoiceLineAdd
Global Const $orila1NA = -1
Global Const $orilaInvoiceLineAdd = 0
Global Const $orilaInvoiceLineGroupAdd = 1

;ENORInvoiceLineMod
Global Const $orilmNA = -1
Global Const $orilmInvoiceLineMod = 0
Global Const $orilmInvoiceLineGroupMod = 1

;ENPaidStatus
Global Const $psAll = 0
Global Const $psPaidOnly = 1
Global Const $psNotPaidOnly = 2

;ENORInvoiceQuery
Global Const $oriqNA = -1
Global Const $oriqTxnID = 0
Global Const $oriqRefNumber = 1
Global Const $oriqInvoiceFilter = 2

;ENORDateRangeFilter
Global Const $ordrfNA = -1
Global Const $ordrfModifiedDateRangeFilter = 0
Global Const $ordrfTxnDateRangeFilter = 1

;ENORRefNumberFilter
Global Const $orrnfNA = -1
Global Const $orrnfRefNumberFilter = 0
Global Const $orrnfRefNumberRangeFilter = 1

;ENDateMacro
Global Const $dmAll = 0
Global Const $dmToday = 1
Global Const $dmThisWeek = 2
Global Const $dmThisWeekToDate = 3
Global Const $dmThisMonth = 4
Global Const $dmThisMonthToDate = 5
Global Const $dmThisCalendarQuarter = 6
Global Const $dmThisCalendarQuarterToDate = 7
Global Const $dmThisFiscalQuarter = 8
Global Const $dmThisFiscalQuarterToDate = 9
Global Const $dmThisCalendarYear = 10
Global Const $dmThisCalendarYearToDate = 11
Global Const $dmThisFiscalYear = 12
Global Const $dmThisFiscalYearToDate = 13
Global Const $dmYesterday = 14
Global Const $dmLastWeek = 15
Global Const $dmLastWeekToDate = 16
Global Const $dmLastMonth = 17
Global Const $dmLastMonthToDate = 18
Global Const $dmLastCalendarQuarter = 19
Global Const $dmLastCalendarQuarterToDate = 20
Global Const $dmLastFiscalQuarter = 21
Global Const $dmLastFiscalQuarterToDate = 22
Global Const $dmLastCalendarYear = 23
Global Const $dmLastCalendarYearToDate = 24
Global Const $dmLastFiscalYear = 25
Global Const $dmLastFiscalYearToDate = 26
Global Const $dmNextWeek = 27
Global Const $dmNextFourWeeks = 28
Global Const $dmNextMonth = 29
Global Const $dmNextCalendarQuarter = 30
Global Const $dmNextCalendarYear = 31
Global Const $dmNextFiscalQuarter = 32
Global Const $dmNextFiscalYear = 33

;ENORTxnDateRangeFilter
Global Const $ortdrfNA = -1
Global Const $ortdrfTxnDateFilter = 0
Global Const $ortdrfDateMacro = 1

;ENOREntityFilter
Global Const $orefNA = -1
Global Const $orefListID = 0
Global Const $orefFullName = 1
Global Const $orefListIDWithChildren = 2
Global Const $orefFullNameWithChildren = 3

;ENORAccountFilter
Global Const $orafNA = -1
Global Const $orafListID = 0
Global Const $orafFullName = 1
Global Const $orafListIDWithChildren = 2
Global Const $orafFullNameWithChildren = 3

;ENOREstimateLineAdd
Global Const $orelaNA = -1
Global Const $orelaEstimateLineAdd = 0
Global Const $orelaEstimateLineGroupAdd = 1

;ENORMarkupRate
Global Const $ormrNA = -1
Global Const $ormrMarkupRate = 0
Global Const $ormrMarkupRatePercent = 1

;ENOREstimateLineMod
Global Const $orelmNA = -1
Global Const $orelmEstimateLineMod = 0
Global Const $orelmEstimateLineGroupMod = 1

;ENORTxnQuery
Global Const $ortqNA = -1
Global Const $ortqTxnID = 0
Global Const $ortqRefNumber = 1
Global Const $ortqTxnFilter = 2

;ENORSalesOrderLineAdd
Global Const $orsolaNA = -1
Global Const $orsolaSalesOrderLineAdd = 0
Global Const $orsolaSalesOrderLineGroupAdd = 1

;ENORSalesOrderLineMod
Global Const $orsolmNA = -1
Global Const $orsolmSalesOrderLineMod = 0
Global Const $orsolmSalesOrderLineGroupMod = 1

;ENORTxnNoAccountQuery
Global Const $ortnaqNA = -1
Global Const $ortnaqTxnID = 0
Global Const $ortnaqRefNumber = 1
Global Const $ortnaqTxnFilterNoAccount = 2

;ENORSalesReceiptLineAdd
Global Const $orsrlaNA = -1
Global Const $orsrlaSalesReceiptLineAdd = 0
Global Const $orsrlaSalesReceiptLineGroupAdd = 1

;ENORCreditMemoLineAdd
Global Const $orcmlaNA = -1
Global Const $orcmlaCreditMemoLineAdd = 0
Global Const $orcmlaCreditMemoLineGroupAdd = 1

;ENORCreditMemoLineMod
Global Const $orcmlmNA = -1
Global Const $orcmlmCreditMemoLineMod = 0
Global Const $orcmlmCreditMemoLineGroupMod = 1

;ENORApplyPayment
Global Const $orapNA = -1
Global Const $orapIsAutoApply = 0
Global Const $orapAppliedToTxnAdd = 1

;ENORPurchaseOrderLineAdd
Global Const $orpolaNA = -1
Global Const $orpolaPurchaseOrderLineAdd = 0
Global Const $orpolaPurchaseOrderLineGroupAdd = 1

;ENORPurchaseOrderLineMod
Global Const $orpolmNA = -1
Global Const $orpolmPurchaseOrderLineMod = 0
Global Const $orpolmPurchaseOrderLineGroupMod = 1

;ENORItemLineAdd
Global Const $orilaNA = -1
Global Const $orilaItemLineAdd = 0
Global Const $orilaItemGroupLineAdd = 1

;ENORItemLineMod
Global Const $orilmmNA = -1
Global Const $orilmmItemLineMod = 0
Global Const $orilmmItemGroupLineMod = 1

;ENORBillQuery
Global Const $orbqNA = -1
Global Const $orbqTxnID = 0
Global Const $orbqRefNumber = 1
Global Const $orbqBillFilter = 2

;ENORCheckPrint
Global Const $orcpNA = -1
Global Const $orcpIsToBePrinted = 0
Global Const $orcpRefNumber = 1

;ENORSalesTaxPaymentCheckQuery
Global Const $orstpcqNA = -1
Global Const $orstpcqTxnID = 0
Global Const $orstpcqRefNumber = 1
Global Const $orstpcqTxnFilterWithItemFilter = 2

;ENORItemFilter
Global Const $orifNA = -1
Global Const $orifListID = 0
Global Const $orifFullName = 1
Global Const $orifListIDWithChildren = 2
Global Const $orifFullNameWithChildren = 3

;ENORTypeAdjustment
Global Const $ortaNA = -1
Global Const $ortaQuantityAdjustment = 0
Global Const $ortaValueAdjustment = 1

;ENORQuantityAdjustment
Global Const $orqaNA = -1
Global Const $orqaNewQuantity = 0
Global Const $orqaQuantityDifference = 1

;ENORInventoryAdjustmentQuery
Global Const $oriaqNA = -1
Global Const $oriaqTxnID = 0
Global Const $oriaqRefNumber = 1
Global Const $oriaqTxnFilterWithItemFilter = 2

;ENORTimeTrackingTxnQuery
Global Const $ortttqNA = -1
Global Const $ortttqTxnID = 0
Global Const $ortttqTimeTrackingTxnFilter = 1

;ENORTimeTrackingEntityFilter
Global Const $orttefNA = -1
Global Const $orttefListID = 0
Global Const $orttefFullName = 1

;ENORJournalLine
Global Const $orjlNA = -1
Global Const $orjlJournalDebitLine = 0
Global Const $orjlJournalCreditLine = 1

;ENORDepositLineAdd
Global Const $ordlaNA = -1
Global Const $ordlaPaymentLine = 0
Global Const $ordlaDepositInfo = 1

;ENORDepositQuery
Global Const $ordqNA = -1
Global Const $ordqTxnID = 0
Global Const $ordqDepositFilter = 1

;ENListDelType
Global Const $ldtAccount = 0
Global Const $ldtCustomer = 1
Global Const $ldtEmployee = 2
Global Const $ldtOtherName = 3
Global Const $ldtVendor = 4
Global Const $ldtStandardTerms = 5
Global Const $ldtDateDrivenTerms = 6
Global Const $ldtClass = 7
Global Const $ldtSalesRep = 8
Global Const $ldtCustomerType = 9
Global Const $ldtVendorType = 10
Global Const $ldtJobType = 11
Global Const $ldtCustomerMsg = 12
Global Const $ldtPaymentMethod = 13
Global Const $ldtShipMethod = 14
Global Const $ldtSalesTaxCode = 15
Global Const $ldtToDo = 16
Global Const $ldtItemService = 17
Global Const $ldtItemNonInventory = 18
Global Const $ldtItemOtherCharge = 19
Global Const $ldtItemInventory = 20
Global Const $ldtItemInventoryAssembly = 21
Global Const $ldtItemFixedAsset = 22
Global Const $ldtItemSubtotal = 23
Global Const $ldtItemDiscount = 24
Global Const $ldtItemPayment = 25
Global Const $ldtItemSalesTax = 26
Global Const $ldtItemSalesTaxGroup = 27
Global Const $ldtItemGroup = 28

;ENTxnDelType
Global Const $tdtBill = 0
Global Const $tdtBillPaymentCheck = 1
Global Const $tdtBillPaymentCreditCard = 2
Global Const $tdtCharge = 3
Global Const $tdtCheck = 4
Global Const $tdtCreditCardCharge = 5
Global Const $tdtCreditCardCredit = 6
Global Const $tdtCreditMemo = 7
Global Const $tdtDeposit = 8
Global Const $tdtEstimate = 9
Global Const $tdtInvoice = 10
Global Const $tdtInventoryAdjustment = 11
Global Const $tdtJournalEntry = 12
Global Const $tdtPurchaseOrder = 13
Global Const $tdtReceivePayment = 14
Global Const $tdtSalesOrder = 15
Global Const $tdtSalesReceipt = 16
Global Const $tdtTimeTracking = 17
Global Const $tdtVendorCredit = 18

;ENTxnVoidType
Global Const $tvtBill = 0
Global Const $tvtBillPaymentCheck = 1
Global Const $tvtBillPaymentCreditCard = 2
Global Const $tvtCharge = 3
Global Const $tvtCheck = 4
Global Const $tvtCreditCardCharge = 5
Global Const $tvtCreditCardCredit = 6
Global Const $tvtCreditMemo = 7
Global Const $tvtDeposit = 8
Global Const $tvtInvoice = 9
Global Const $tvtInventoryAdjustment = 10
Global Const $tvtJournalEntry = 11
Global Const $tvtSalesReceipt = 12
Global Const $tvtVendorCredit = 13

;ENListDisplayAddType
Global Const $ldatCustomer = 0
Global Const $ldatEmployee = 1
Global Const $ldatOtherName = 2
Global Const $ldatVendor = 3

;ENListDisplayModType
Global Const $ldmtCustomer = 0
Global Const $ldmtEmployee = 1
Global Const $ldmtOtherName = 2
Global Const $ldmtVendor = 3

;ENTxnDisplayAddType
Global Const $tdatBill = 0
Global Const $tdatBillPayment = 1
Global Const $tdatCharge = 2
Global Const $tdatCheck = 3
Global Const $tdatCreditCardCharge = 4
Global Const $tdatCreditCardCredit = 5
Global Const $tdatCreditMemo = 6
Global Const $tdatDeposit = 7
Global Const $tdatEstimate = 8
Global Const $tdatInventoryAdjustment = 9
Global Const $tdatInvoice = 10
Global Const $tdatItemReceipt = 11
Global Const $tdatJournalEntry = 12
Global Const $tdatPurchaseOrder = 13
Global Const $tdatReceivePayment = 14
Global Const $tdatSalesOrder = 15
Global Const $tdatSalesReceipt = 16
Global Const $tdatSalesTaxPaymentCheck = 17
Global Const $tdatVendorCredit = 18

;ENTxnDisplayModType
Global Const $tdmtBill = 0
Global Const $tdmtBillPaymentCheck = 1
Global Const $tdmtBillPaymentCreditCard = 2
Global Const $tdmtCharge = 3
Global Const $tdmtCheck = 4
Global Const $tdmtCreditCardCharge = 5
Global Const $tdmtCreditCardCredit = 6
Global Const $tdmtCreditMemo = 7
Global Const $tdmtDeposit = 8
Global Const $tdmtEstimate = 9
Global Const $tdmtInventoryAdjustment = 10
Global Const $tdmtInvoice = 11
Global Const $tdmtItemReceipt = 12
Global Const $tdmtJournalEntry = 13
Global Const $tdmtPurchaseOrder = 14
Global Const $tdmtReceivePayment = 15
Global Const $tdmtSalesOrder = 16
Global Const $tdmtSalesReceipt = 17
Global Const $tdmtSalesTaxPaymentCheck = 18
Global Const $tdmtVendorCredit = 19

;ENORCOMHTTPCallbackInfo
Global Const $orcomhttpciNA = -1

;ENGeneralSummaryReportType
Global Const $gsrtBalanceSheetPrevYearComp = 0
Global Const $gsrtBalanceSheetStandard = 1
Global Const $gsrtBalanceSheetSummary = 2
Global Const $gsrtCustomerBalanceSummary = 3
Global Const $gsrtExpenseByVendorSummary = 4
Global Const $gsrtIncomeByCustomerSummary = 5
Global Const $gsrtInventoryStockStatusByItem = 6
Global Const $gsrtInventoryStockStatusByVendor = 7
Global Const $gsrtIncomeTaxSummary = 8
Global Const $gsrtInventoryValuationSummary = 9
Global Const $gsrtPhysicalInventoryWorksheet = 10
Global Const $gsrtProfitAndLossByClass = 11
Global Const $gsrtProfitAndLossByJob = 12
Global Const $gsrtProfitAndLossPrevYearComp = 13
Global Const $gsrtProfitAndLossStandard = 14
Global Const $gsrtProfitAndLossYTDComp = 15
Global Const $gsrtPurchaseByItemSummary = 16
Global Const $gsrtPurchaseByVendorSummary = 17
Global Const $gsrtSalesByCustomerSummary = 18
Global Const $gsrtSalesByItemSummary = 19
Global Const $gsrtSalesByRepSummary = 20
Global Const $gsrtSalesTaxLiability = 21
Global Const $gsrtSalesTaxRevenueSummary = 22
Global Const $gsrtTrialBalance = 23
Global Const $gsrtVendorBalanceSummary = 24

;ENReportDetailLevelFilter
Global Const $rdlfAll = 0
Global Const $rdlfSummaryOnly = 1
Global Const $rdlfAllExceptSummary = 2

;ENReportPostingStatusFilter
Global Const $rpsfEither = 0
Global Const $rpsfNonPosting = 1
Global Const $rpsfPosting = 2

;ENSummarizeColumnsBy
Global Const $scbAccount = 0
Global Const $scbBalanceSheet = 1
Global Const $scbClass = 2
Global Const $scbCustomer = 3
Global Const $scbCustomerType = 4
Global Const $scbDay = 5
Global Const $scbEmployee = 6
Global Const $scbFourWeek = 7
Global Const $scbHalfMonth = 8
Global Const $scbIncomeStatement = 9
Global Const $scbItemDetail = 10
Global Const $scbItemType = 11
Global Const $scbMonth = 12
Global Const $scbPayee = 13
Global Const $scbPaymentMethod = 14
Global Const $scbPayrollItemDetail = 15
Global Const $scbPayrollYtdDetail = 16
Global Const $scbQuarter = 17
Global Const $scbSalesRep = 18
Global Const $scbSalesTaxCode = 19
Global Const $scbShipMethod = 20
Global Const $scbTerms = 21
Global Const $scbTotalOnly = 22
Global Const $scbTwoWeek = 23
Global Const $scbVendor = 24
Global Const $scbVendorType = 25
Global Const $scbWeek = 26
Global Const $scbYear = 27

;ENReportCalendar
Global Const $rcFiscalYear = 0
Global Const $rcCalendarYear = 1
Global Const $rcTaxYear = 2

;ENReturnRows
Global Const $rrActiveOnly = 0
Global Const $rrNonZero = 1
Global Const $rrAll = 2

;ENReturnColumns
Global Const $rcActiveOnly = 0
Global Const $rcNonZero = 1
Global Const $rcAll = 2

;ENReportBasis
Global Const $rbCash = 0
Global Const $rbAccrual = 1
Global Const $rbNone = 2

;ENReportDateMacro
Global Const $rdmAll = 0
Global Const $rdmToday = 1
Global Const $rdmThisWeek = 2
Global Const $rdmThisWeekToDate = 3
Global Const $rdmThisMonth = 4
Global Const $rdmThisMonthToDate = 5
Global Const $rdmThisQuarter = 6
Global Const $rdmThisQuarterToDate = 7
Global Const $rdmThisYear = 8
Global Const $rdmThisYearToDate = 9
Global Const $rdmYesterday = 10
Global Const $rdmLastWeek = 11
Global Const $rdmLastWeekToDate = 12
Global Const $rdmLastMonth = 13
Global Const $rdmLastMonthToDate = 14
Global Const $rdmLastQuarter = 15
Global Const $rdmLastQuarterToDate = 16
Global Const $rdmLastYear = 17
Global Const $rdmLastYearToDate = 18
Global Const $rdmNextWeek = 19
Global Const $rdmNextFourWeeks = 20
Global Const $rdmNextMonth = 21
Global Const $rdmNextQuarter = 22
Global Const $rdmNextYear = 23

;ENORReportPeriod
Global Const $orrpNA = -1
Global Const $orrpReportPeriod = 0
Global Const $orrpReportDateMacro = 1

;ENReportModifiedDateRangeMacro
Global Const $rmdrmAll = 0
Global Const $rmdrmToday = 1
Global Const $rmdrmThisWeek = 2
Global Const $rmdrmThisWeekToDate = 3
Global Const $rmdrmThisMonth = 4
Global Const $rmdrmThisMonthToDate = 5
Global Const $rmdrmThisQuarter = 6
Global Const $rmdrmThisQuarterToDate = 7
Global Const $rmdrmThisYear = 8
Global Const $rmdrmThisYearToDate = 9
Global Const $rmdrmYesterday = 10
Global Const $rmdrmLastWeek = 11
Global Const $rmdrmLastWeekToDate = 12
Global Const $rmdrmLastMonth = 13
Global Const $rmdrmLastMonthToDate = 14
Global Const $rmdrmLastQuarter = 15
Global Const $rmdrmLastQuarterToDate = 16
Global Const $rmdrmLastYear = 17
Global Const $rmdrmLastYearToDate = 18
Global Const $rmdrmNextWeek = 19
Global Const $rmdrmNextFourWeeks = 20
Global Const $rmdrmNextMonth = 21
Global Const $rmdrmNextQuarter = 22
Global Const $rmdrmNextYear = 23

;ENORReportModifiedDate
Global Const $orrmdNA = -1
Global Const $orrmdReportModifiedDateRangeFilter = 0
Global Const $orrmdReportModifiedDateRangeMacro = 1

;ENAccountTypeFilter
Global Const $atfAccountsPayable = 0
Global Const $atfAccountsReceivable = 1
Global Const $atfAllowedFor1099 = 2
Global Const $atfAPAndSalesTax = 3
Global Const $atfAPOrCreditCard = 4
Global Const $atfARAndAP = 5
Global Const $atfAsset = 6
Global Const $atfBalanceSheet = 7
Global Const $atfBank = 8
Global Const $atfBankAndARAndAPAndUF = 9
Global Const $atfBankAndUF = 10
Global Const $atfCostOfSales = 11
Global Const $atfCreditCard = 12
Global Const $atfCurrentAsset = 13
Global Const $atfCurrentAssetAndExpense = 14
Global Const $atfCurrentLiability = 15
Global Const $atfEquity = 16
Global Const $atfEquityAndIncomeAndExpense = 17
Global Const $atfExpenseAndOtherExpense = 18
Global Const $atfFixedAsset = 19
Global Const $atfIncomeAndExpense = 20
Global Const $atfIncomeAndOtherIncome = 21
Global Const $atfLiability = 22
Global Const $atfLiabilityAndEquity = 23
Global Const $atfLongTermLiability = 24
Global Const $atfNonPosting = 25
Global Const $atfOrdinaryExpense = 26
Global Const $atfOrdinaryIncome = 27
Global Const $atfOrdinaryIncomeAndCOGS = 28
Global Const $atfOrdinaryIncomeAndExpense = 29
Global Const $atfOtherAsset = 30
Global Const $atfOtherCurrentAsset = 31
Global Const $atfOtherCurrentLiability = 32
Global Const $atfOtherExpense = 33
Global Const $atfOtherIncome = 34
Global Const $atfOtherIncomeOrExpense = 35

;ENORReportAccountFilter
Global Const $orrafNA = -1
Global Const $orrafAccountTypeFilter = 0
Global Const $orrafListID = 1
Global Const $orrafFullName = 2
Global Const $orrafListIDWithChildren = 3
Global Const $orrafFullNameWithChildren = 4

;ENEntityTypeFilter
Global Const $etfCustomer = 0
Global Const $etfEmployee = 1
Global Const $etfOtherName = 2
Global Const $etfVendor = 3

;ENORReportEntityFilter
Global Const $orrefNA = -1
Global Const $orrefEntityTypeFilter = 0
Global Const $orrefListID = 1
Global Const $orrefFullName = 2
Global Const $orrefListIDWithChildren = 3
Global Const $orrefFullNameWithChildren = 4

;ENItemTypeFilter
Global Const $itfAssembly = 0
Global Const $itfDiscount = 1
Global Const $itfFixedAsset = 2
Global Const $itfInventory = 3
Global Const $itfInventoryAndAssembly = 4
Global Const $itfNonInventory = 5
Global Const $itfOtherCharge = 6
Global Const $itfPayment = 7
Global Const $itfSales = 8
Global Const $itfSalesTax = 9
Global Const $itfService = 10

;ENORReportItemFilter
Global Const $orrifNA = -1
Global Const $orrifItemTypeFilter = 0
Global Const $orrifListID = 1
Global Const $orrifFullName = 2
Global Const $orrifListIDWithChildren = 3
Global Const $orrifFullNameWithChildren = 4

;ENORReportClassFilter
Global Const $orrcfNA = -1
Global Const $orrcfListID = 0
Global Const $orrcfFullName = 1
Global Const $orrcfListIDWithChildren = 2
Global Const $orrcfFullNameWithChildren = 3

;ENJobReportType
Global Const $jrtJobEstimatesVsActualsDetail = 0
Global Const $jrtJobEstimatesVsActualsSummary = 1
Global Const $jrtJobProfitabilityDetail = 2
Global Const $jrtJobProfitabilitySummary = 3
Global Const $jrtItemEstimatesVsActuals = 4
Global Const $jrtItemProfitability = 5

;ENTimeReportType
Global Const $trtTimeByItem = 0
Global Const $trtTimeByJobDetail = 1
Global Const $trtTimeByJobSummary = 2
Global Const $trtTimeByName = 3

;ENAgingReportType
Global Const $artAPAgingDetail = 0
Global Const $artAPAgingSummary = 1
Global Const $artARAgingDetail = 2
Global Const $artARAgingSummary = 3
Global Const $artCollectionsReport = 4

;ENIncludeColumn
Global Const $icAccount = 0
Global Const $icAging = 1
Global Const $icAmount = 2
Global Const $icAmountDifference = 3
Global Const $icAverageCost = 4
Global Const $icBilledDate = 5
Global Const $icBillingStatus = 6
Global Const $icCalculatedAmount = 7
Global Const $icClass = 8
Global Const $icClearedStatus = 9
Global Const $icCostPrice = 10
Global Const $icCredit = 11
Global Const $icDate = 12
Global Const $icDebit = 13
Global Const $icDeliveryDate = 14
Global Const $icDueDate = 15
Global Const $icEstimateActive = 16
Global Const $icFOB = 17
Global Const $icIncomeSubjectToTax = 18
Global Const $icInvoiced = 19
Global Const $icItem = 20
Global Const $icItemDesc = 21
Global Const $icLastModifiedBy = 22
Global Const $icMemo = 23
Global Const $icModifiedTime = 24
Global Const $icName = 25
Global Const $icNameAccountNumber = 26
Global Const $icNameAddress = 27
Global Const $icNameCity = 28
Global Const $icNameContact = 29
Global Const $icNameEmail = 30
Global Const $icNameFax = 31
Global Const $icNamePhone = 32
Global Const $icNameState = 33
Global Const $icNameZip = 34
Global Const $icOpenBalance = 35
Global Const $icOriginalAmount = 36
Global Const $icPaidStatus = 37
Global Const $icPaidThroughDate = 38
Global Const $icPaymentMethod = 39
Global Const $icPayrollItem = 40
Global Const $icPONumber = 41
Global Const $icPrintStatus = 42
Global Const $icQuantity = 43
Global Const $icQuantityAvailable = 44
Global Const $icQuantityOnHand = 45
Global Const $icQuantityOnSalesOrder = 46
Global Const $icReceivedQuantity = 47
Global Const $icRefNumber = 48
Global Const $icRunningBalance = 49
Global Const $icSalesRep = 50
Global Const $icSalesTaxCode = 51
Global Const $icShipDate = 52
Global Const $icShipMethod = 53
Global Const $icSourceName = 54
Global Const $icSplitAccount = 55
Global Const $icSSNOrTaxID = 56
Global Const $icTaxLine = 57
Global Const $icTerms = 58
Global Const $icTxnID = 59
Global Const $icTxnNumber = 60
Global Const $icTxnType = 61
Global Const $icUnitPrice = 62
Global Const $icValueOnHand = 63
Global Const $icWageBase = 64
Global Const $icWageBaseTips = 65

;ENIncludeAccounts
Global Const $iaInUse = 0
Global Const $iaAll = 1

;ENReportAgingAsOf
Global Const $raaoReportEndDate = 0
Global Const $raaoToday = 1

;ENGeneralDetailReportType
Global Const $gdrt1099Detail = 0
Global Const $gdrtAuditTrail = 1
Global Const $gdrtBalanceSheetDetail = 2
Global Const $gdrtCheckDetail = 3
Global Const $gdrtCustomerBalanceDetail = 4
Global Const $gdrtDepositDetail = 5
Global Const $gdrtEstimatesByJob = 6
Global Const $gdrtExpenseByVendorDetail = 7
Global Const $gdrtGeneralLedger = 8
Global Const $gdrtIncomeByCustomerDetail = 9
Global Const $gdrtIncomeTaxDetail = 10
Global Const $gdrtInventoryValuationDetail = 11
Global Const $gdrtJobProgressInvoicesVsEstimates = 12
Global Const $gdrtJournal = 13
Global Const $gdrtMissingChecks = 14
Global Const $gdrtOpenInvoices = 15
Global Const $gdrtOpenPOs = 16
Global Const $gdrtOpenPOsByJob = 17
Global Const $gdrtOpenSalesOrderByCustomer = 18
Global Const $gdrtOpenSalesOrderByItem = 19
Global Const $gdrtPendingSales = 20
Global Const $gdrtProfitAndLossDetail = 21
Global Const $gdrtPurchaseByItemDetail = 22
Global Const $gdrtPurchaseByVendorDetail = 23
Global Const $gdrtSalesByCustomerDetail = 24
Global Const $gdrtSalesByItemDetail = 25
Global Const $gdrtSalesByRepDetail = 26
Global Const $gdrtTxnDetailByAccount = 27
Global Const $gdrtTxnListByCustomer = 28
Global Const $gdrtTxnListByDate = 29
Global Const $gdrtTxnListByVendor = 30
Global Const $gdrtUnpaidBillsDetail = 31
Global Const $gdrtUnbilledCostsByJob = 32
Global Const $gdrtVendorBalanceDetail = 33

;ENSummarizeRowsBy
Global Const $srbAccount = 0
Global Const $srbBalanceSheet = 1
Global Const $srbClass = 2
Global Const $srbCustomer = 3
Global Const $srbCustomerType = 4
Global Const $srbDay = 5
Global Const $srbEmployee = 6
Global Const $srbFourWeek = 7
Global Const $srbHalfMonth = 8
Global Const $srbIncomeStatement = 9
Global Const $srbItemDetail = 10
Global Const $srbItemType = 11
Global Const $srbMonth = 12
Global Const $srbPayee = 13
Global Const $srbPaymentMethod = 14
Global Const $srbPayrollItemDetail = 15
Global Const $srbPayrollYtdDetail = 16
Global Const $srbQuarter = 17
Global Const $srbSalesRep = 18
Global Const $srbSalesTaxCode = 19
Global Const $srbShipMethod = 20
Global Const $srbTaxLine = 21
Global Const $srbTerms = 22
Global Const $srbTotalOnly = 23
Global Const $srbTwoWeek = 24
Global Const $srbVendor = 25
Global Const $srbVendorType = 26
Global Const $srbWeek = 27
Global Const $srbYear = 28

;ENReportOpenBalanceAsOf
Global Const $robaoToday = 0
Global Const $robaoReportEndDate = 1

;ENCustomDetailReportType
Global Const $cdrtCustomTxnDetail = 0

;ENCustomSummaryReportType
Global Const $csrtCustomSummary = 0

;ENPayrollDetailReportType
Global Const $pdrtEmployeeStateTaxesDetail = 0
Global Const $pdrtPayrollItemDetail = 1
Global Const $pdrtPayrollReviewDetail = 2
Global Const $pdrtPayrollTransactionDetail = 3
Global Const $pdrtPayrollTransactionsByPayee = 4

;ENPayrollSummaryReportType
Global Const $psrtEmployeeEarningsSummary = 0
Global Const $psrtPayrollLiabilityBalances = 1
Global Const $psrtPayrollSummary = 2

;ENAssignToObject
Global Const $atoCompany = 0
Global Const $atoAccount = 1
Global Const $atoCustomer = 2
Global Const $atoEmployee = 3
Global Const $atoOtherName = 4
Global Const $atoVendor = 5
Global Const $atoItem = 6
Global Const $atoBill = 7
Global Const $atoBillPaymentCheck = 8
Global Const $atoBillPaymentCreditCard = 9
Global Const $atoCharge = 10
Global Const $atoCheck = 11
Global Const $atoCreditCardCharge = 12
Global Const $atoCreditCardCredit = 13
Global Const $atoCreditMemo = 14
Global Const $atoDeposit = 15
Global Const $atoEstimate = 16
Global Const $atoInventoryAdjustment = 17
Global Const $atoInvoice = 18
Global Const $atoItemReceipt = 19
Global Const $atoJournalEntry = 20
Global Const $atoPurchaseOrder = 21
Global Const $atoReceivePayment = 22
Global Const $atoSalesOrder = 23
Global Const $atoSalesReceipt = 24
Global Const $atoSalesTaxPaymentCheck = 25
Global Const $atoVendorCredit = 26

;ENORDataExtDefQuery
Global Const $ordedqNA = -1
Global Const $ordedqOwnerID = 0
Global Const $ordedqAssignToObject = 1

;ENListDataExtType
Global Const $ldetCustomer = 0
Global Const $ldetVendor = 1
Global Const $ldetEmployee = 2
Global Const $ldetOtherName = 3
Global Const $ldetItem = 4
Global Const $ldetAccount = 5

;ENTxnDataExtType
Global Const $tdetBill = 0
Global Const $tdetBillPaymentCheck = 1
Global Const $tdetBillPaymentCreditCard = 2
Global Const $tdetCharge = 3
Global Const $tdetCheck = 4
Global Const $tdetCreditCardCharge = 5
Global Const $tdetCreditCardCredit = 6
Global Const $tdetCreditMemo = 7
Global Const $tdetDeposit = 8
Global Const $tdetEstimate = 9
Global Const $tdetInventoryAdjustment = 10
Global Const $tdetInvoice = 11
Global Const $tdetItemReceipt = 12
Global Const $tdetJournalEntry = 13
Global Const $tdetPurchaseOrder = 14
Global Const $tdetReceivePayment = 15
Global Const $tdetSalesOrder = 16
Global Const $tdetSalesReceipt = 17
Global Const $tdetSalesTaxPaymentCheck = 18
Global Const $tdetVendorCredit = 19

;ENOtherDataExtType
Global Const $odetCompany = 0

;ENORListTxnWithMacro
Global Const $orltwmNA = -1
Global Const $orltwmListDataExt = 0
Global Const $orltwmTxnDataExtWithMacro = 1
Global Const $orltwmOtherDataExtType = 2

;ENORListTxn
Global Const $orltNA = -1
Global Const $orltListDataExt = 0
Global Const $orltTxnDataExtNoMacro = 1
Global Const $orltOtherDataExtType = 2

;ENORInvoiceLineRet
Global Const $orilr1NA = -1
Global Const $orilrInvoiceLineRet = 0
Global Const $orilrInvoiceLineGroupRet = 1

;ENOREstimateLineRet
Global Const $orelrNA = -1
Global Const $orelrEstimateLineRet = 0
Global Const $orelrEstimateLineGroupRet = 1

;ENORSalesOrderLineRet
Global Const $orsolrNA = -1
Global Const $orsolrSalesOrderLineRet = 0
Global Const $orsolrSalesOrderLineGroupRet = 1

;ENORSalesReceiptLineRet
Global Const $orsrlrNA = -1
Global Const $orsrlrSalesReceiptLineRet = 0
Global Const $orsrlrSalesReceiptLineGroupRet = 1

;ENORCreditMemoLineRet
Global Const $orcmlrNA = -1
Global Const $orcmlrCreditMemoLineRet = 0
Global Const $orcmlrCreditMemoLineGroupRet = 1

;ENORPurchaseOrderLineRet
Global Const $orpolrNA = -1
Global Const $orpolrPurchaseOrderLineRet = 0
Global Const $orpolrPurchaseOrderLineGroupRet = 1

;ENORItemLineRet
Global Const $orilrNA = -1
Global Const $orilrItemLineRet = 0
Global Const $orilrItemGroupLineRet = 1

;ENORBillToPayRet
Global Const $orbtprNA = -1
Global Const $orbtprBillToPay = 0
Global Const $orbtprCreditToApply = 1

;ENORReportData
Global Const $orrdNA = -1
Global Const $orrdDataRow = 0
Global Const $orrdTextRow = 1
Global Const $orrdSubtotalRow = 2
Global Const $orrdTotalRow = 3

;ENORMenuSubmenu
Global Const $ormsNA = -1
Global Const $ormsSubmenu = 0
Global Const $ormsMenuItem = 1

;ENSubscriptionType
Global Const $stData = 0
Global Const $stUI = 1
Global Const $stUIExtension = 2

;ENORListTxnEvent
Global Const $orlteNA = -1
Global Const $orlteListEvent = 0
Global Const $orlteTxnEvent = 1

;ENOREntityRet
Global Const $orerNA = -1
Global Const $orerCustomerRet = 0
Global Const $orerEmployeeRet = 1
Global Const $orerOtherNameRet = 2
Global Const $orerVendorRet = 3

;ENORTermsRet
Global Const $ortrNA = -1
Global Const $ortrStandardTermsRet = 0
Global Const $ortrDateDrivenTermsRet = 1

;ENOREvent
Global Const $orevNA = -1
Global Const $orevDataEvent = 0
Global Const $orevUIEvent = 1
Global Const $orevUIExtensionEvent = 2

;ENORItemRet
Global Const $orirNA = -1
Global Const $orirItemServiceRet = 0
Global Const $orirItemNonInventoryRet = 1
Global Const $orirItemOtherChargeRet = 2
Global Const $orirItemInventoryRet = 3
Global Const $orirItemInventoryAssemblyRet = 4
Global Const $orirItemFixedAssetRet = 5
Global Const $orirItemSubtotalRet = 6
Global Const $orirItemDiscountRet = 7
Global Const $orirItemPaymentRet = 8
Global Const $orirItemSalesTaxRet = 9
Global Const $orirItemSalesTaxGroupRet = 10
Global Const $orirItemGroupRet = 11

;ENWageType
Global Const $wtHourly = 0
Global Const $wtSalary = 1
Global Const $wtHourlyRegular = 2
Global Const $wtHourlySick = 3
Global Const $wtHourlyVacation = 4
Global Const $wtSalaryRegular = 5
Global Const $wtSalarySick = 6
Global Const $wtSalaryVacation = 7
Global Const $wtBonus = 8
Global Const $wtCommission = 9

;ENJobStatus
Global Const $jsNone = 0
Global Const $jsPending = 1
Global Const $jsAwarded = 2
Global Const $jsInProgress = 3
Global Const $jsClosed = 4
Global Const $jsNotAwarded = 5

;ENDeliveryMethod
Global Const $dmPrint = 0
Global Const $dmFax = 1
Global Const $dmEmail = 2

;ENCalculateChargesFrom
Global Const $ccfDueDate = 0
Global Const $ccfInvoiceOrBilledDate = 1

;ENCompanyFileEventOperation
Global Const $cfeoOpen = 0
Global Const $cfeoClose = 1

;ENTxnType
Global Const $ttBill = 0
Global Const $ttBillPaymentCheck = 1
Global Const $ttBillPaymentCreditCard = 2
Global Const $ttCharge = 3
Global Const $ttCheck = 4
Global Const $ttCreditCardCharge = 5
Global Const $ttCreditCardCredit = 6
Global Const $ttCreditMemo = 7
Global Const $ttDeposit = 8
Global Const $ttEstimate = 9
Global Const $ttInvoice = 10
Global Const $ttInventoryAdjustment = 11
Global Const $ttItemReceipt = 12
Global Const $ttJournalEntry = 13
Global Const $ttLiabilityAdjustment = 14
Global Const $ttPurchaseOrder = 15
Global Const $ttReceivePayment = 16
Global Const $ttSalesOrder = 17
Global Const $ttSalesReceipt = 18
Global Const $ttSalesTaxPaymentCheck = 19
Global Const $ttTransfer = 20
Global Const $ttVendorCredit = 21

;ENTxnEventType
Global Const $tetBill = 0
Global Const $tetBillPaymentCheck = 1
Global Const $tetBillPaymentCreditCard = 2
Global Const $tetCharge = 3
Global Const $tetCheck = 4
Global Const $tetCreditCardCharge = 5
Global Const $tetCreditCardCredit = 6
Global Const $tetCreditMemo = 7
Global Const $tetDeposit = 8
Global Const $tetEstimate = 9
Global Const $tetInvoice = 10
Global Const $tetInventoryAdjustment = 11
Global Const $tetJournalEntry = 12
Global Const $tetPurchaseOrder = 13
Global Const $tetReceivePayment = 14
Global Const $tetSalesOrder = 15
Global Const $tetSalesReceipt = 16
Global Const $tetSalesTaxPaymentCheck = 17
Global Const $tetTimeTracking = 18
Global Const $tetVendorCredit = 19

;ENTxnEventOperation
Global Const $teoAdd = 0
Global Const $teoModify = 1
Global Const $teoDelete = 2

;ENNonWageType
Global Const $nwtAddition = 0
Global Const $nwtDeduction = 1
Global Const $nwtCompanyContribution = 2
Global Const $nwtTax = 3
Global Const $nwtDirectDeposit = 4

;ENOperator
Global Const $oLessThan = 0
Global Const $oLessThanEqual = 1
Global Const $oEqual = 2
Global Const $oGreaterThan = 3
Global Const $oGreaterThanEqual = 4

;ENAccrualPeriod
Global Const $apBeginningOfYear = 0
Global Const $apEveryPaycheck = 1
Global Const $apEveryHourOnPaycheck = 2

;ENMatchCriterion
Global Const $mcStartsWith = 0
Global Const $mcContains = 1
Global Const $mcEndsWith = 2

;ENClearedStatus
Global Const $csCleared = 0
Global Const $csNotCleared = 1
Global Const $csPending = 2

;ENDetailAccountType
Global Const $datAR = 0
Global Const $datAllowanceForBadDebts = 1
Global Const $datChecking = 2
Global Const $datSavings = 3
Global Const $datMoneyMarket = 4
Global Const $datCashOnHand = 5
Global Const $datTrustAccounts = 6
Global Const $datRentsHeldInTrust = 7
Global Const $datEmployeeCashAdvances = 8
Global Const $datPrepaidExpenses = 9
Global Const $datRetainage = 10
Global Const $datUndepositedFunds = 11
Global Const $datDevelopmentCosts = 12
Global Const $datInventory = 13
Global Const $datLoansToOfficers = 14
Global Const $datLoansToStockholders = 15
Global Const $datLoansToOthers = 16
Global Const $datOtherCurrentAssets = 17
Global Const $datInvestmentUSGovObligations = 18
Global Const $datInvestmentTaxExemptSecurities = 19
Global Const $datInvestmentMortgageOrRealEstateLoans = 20
Global Const $datInvestmentOther = 21
Global Const $datBuildings = 22
Global Const $datFurnitureAndFixtures = 23
Global Const $datLeaseholdImprovements = 24
Global Const $datMachineryAndEquipment = 25
Global Const $datOtherFixedAssets = 26
Global Const $datVehicles = 27
Global Const $datAccumulatedDepreciation = 28
Global Const $datDepletableAssets = 29
Global Const $datAccumulatedDepletion = 30
Global Const $datIntangibleAssets = 31
Global Const $datAccumulatedAmortization = 32
Global Const $datLand = 33
Global Const $datGoodwill = 34
Global Const $datLeaseBuyout = 35
Global Const $datLicenses = 36
Global Const $datOrganizationalCosts = 37
Global Const $datSecurityDeposits = 38
Global Const $datOtherLongTermAssets = 39
Global Const $datAccumulatedAmortizationOfOtherAssets = 40
Global Const $datAP = 41
Global Const $datCreditCard = 42
Global Const $datInsurancePayable = 43
Global Const $datPayrollClearing = 44
Global Const $datPayrollTaxPayable = 45
Global Const $datSalesTaxPayable = 46
Global Const $datFederalIncomeTaxPayable = 47
Global Const $datStateOrLocalIncomeTaxPayable = 48
Global Const $datTrustAccountsLiab = 49
Global Const $datRentsInTrustLiab = 50
Global Const $datLineOfCredit = 51
Global Const $datLoanPayable = 52
Global Const $datPrepaidExpensesPayable = 53
Global Const $datOtherCurrentLiab = 54
Global Const $datNotesPayable = 55
Global Const $datShareholderNotesPayable = 56
Global Const $datOtherLongTermLiab = 57
Global Const $datAccumulatedAdjustment = 58
Global Const $datCommonStock = 59
Global Const $datPreferredStock = 60
Global Const $datPaidInCapitalOrSurplus = 61
Global Const $datTreasuryStock = 62
Global Const $datOpeningBalanceEquity = 63
Global Const $datOwnersEquity = 64
Global Const $datPartnersEquity = 65
Global Const $datPartnerContributions = 66
Global Const $datPartnerDistributions = 67
Global Const $datRetainedEarnings = 68
Global Const $datServiceOrFeeIncome = 69
Global Const $datSalesOfProductIncome = 70
Global Const $datNonProfitIncome = 71
Global Const $datOtherPrimaryIncome = 72
Global Const $datDiscountsOrRefundsGiven = 73
Global Const $datInterestEarned = 74
Global Const $datTaxExemptInterest = 75
Global Const $datDividendIncome = 76
Global Const $datOtherInvestmentIncome = 77
Global Const $datOtherMiscIncome = 78
Global Const $datCostOfLaborCOS = 79
Global Const $datSuppliesAndMaterialsCOGS = 80
Global Const $datShippingFreightAndDeliveryCOS = 81
Global Const $datEquipmentRentalCOS = 82
Global Const $datOtherCostsOfServiceCOS = 83
Global Const $datAuto = 84
Global Const $datCharitableContributions = 85
Global Const $datTaxesPaid = 86
Global Const $datPayrollExpenses = 87
Global Const $datLegalAndProfessionalFees = 88
Global Const $datDuesAndSubscriptions = 89
Global Const $datInsurance = 90
Global Const $datOfficeOrGeneralAdministrativeExpenses = 91
Global Const $datUtilities = 92
Global Const $datRentOrLeaseOfBuildings = 93
Global Const $datRepairAndMaintenance = 94
Global Const $datTravelMeals = 95
Global Const $datEntertainmentMeals = 96
Global Const $datPromotionalMeals = 97
Global Const $datTravel = 98
Global Const $datEntertainment = 99
Global Const $datAdvertisingOrPromotional = 100
Global Const $datBankCharges = 101
Global Const $datBadDebts = 102
Global Const $datInterestPaid = 103
Global Const $datCostOfLabor = 104
Global Const $datSuppliesAndMaterials = 105
Global Const $datShippingFreightAndDelivery = 106
Global Const $datEquipmentRental = 107
Global Const $datOtherMiscServiceCost = 108
Global Const $datDepreciation = 109
Global Const $datAmortization = 110
Global Const $datPenaltiesAndSettlements = 111
Global Const $datOtherMiscExpense = 112

;ENSpecialAccountType
Global Const $satAccountsPayable = 0
Global Const $satAccountsReceivable = 1
Global Const $satCondenseItemAdjustmentExpenses = 2
Global Const $satCostOfGoodsSold = 3
Global Const $satDirectDepositLiabilities = 4
Global Const $satEstimates = 5
Global Const $satInventoryAssets = 6
Global Const $satOpeningBalanceEquity = 7
Global Const $satPayrollExpenses = 8
Global Const $satPayrollLiabilities = 9
Global Const $satPurchaseOrders = 10
Global Const $satRetainedEarnings = 11
Global Const $satSalesOrders = 12
Global Const $satSalesTaxPayable = 13
Global Const $satUncategorizedExpenses = 14
Global Const $satUncategorizedIncome = 15
Global Const $satUndepositedFunds = 16

;ENCashFlowClassification
Global Const $cfcNone = 0
Global Const $cfcOperating = 1
Global Const $cfcInvesting = 2
Global Const $cfcFinancing = 3
Global Const $cfcNotApplicable = 4

;ENRemoveFromObject
Global Const $rfoCompany = 0
Global Const $rfoAccount = 1
Global Const $rfoCustomer = 2
Global Const $rfoEmployee = 3
Global Const $rfoOtherName = 4
Global Const $rfoVendor = 5
Global Const $rfoItem = 6
Global Const $rfoBill = 7
Global Const $rfoBillPaymentCheck = 8
Global Const $rfoBillPaymentCreditCard = 9
Global Const $rfoCharge = 10
Global Const $rfoCheck = 11
Global Const $rfoCreditCardCharge = 12
Global Const $rfoCreditCardCredit = 13
Global Const $rfoCreditMemo = 14
Global Const $rfoDeposit = 15
Global Const $rfoEstimate = 16
Global Const $rfoInventoryAdjustment = 17
Global Const $rfoInvoice = 18
Global Const $rfoItemReceipt = 19
Global Const $rfoJournalEntry = 20
Global Const $rfoPurchaseOrder = 21
Global Const $rfoReceivePayment = 22
Global Const $rfoSalesOrder = 23
Global Const $rfoSalesReceipt = 24
Global Const $rfoSalesTaxPaymentCheck = 25
Global Const $rfoVendorCredit = 26

;ENListEventType
Global Const $letAccount = 0
Global Const $letCustomer = 1
Global Const $letEmployee = 2
Global Const $letOtherName = 3
Global Const $letVendor = 4
Global Const $letStandardTerms = 5
Global Const $letDateDrivenTerms = 6
Global Const $letClass = 7
Global Const $letSalesRep = 8
Global Const $letCustomerType = 9
Global Const $letVendorType = 10
Global Const $letJobType = 11
Global Const $letCustomerMsg = 12
Global Const $letPaymentMethod = 13
Global Const $letShipMethod = 14
Global Const $letSalesTaxCode = 15
Global Const $letToDo = 16
Global Const $letItemService = 17
Global Const $letItemNonInventory = 18
Global Const $letItemOtherCharge = 19
Global Const $letItemInventory = 20
Global Const $letItemInventoryAssembly = 21
Global Const $letItemFixedAsset = 22
Global Const $letItemSubtotal = 23
Global Const $letItemDiscount = 24
Global Const $letItemPayment = 25
Global Const $letItemSalesTax = 26
Global Const $letItemSalesTaxGroup = 27
Global Const $letItemGroup = 28

;ENListEventOperation
Global Const $leoAdd = 0
Global Const $leoModify = 1
Global Const $leoDelete = 2
Global Const $leoMerge = 3

;ENAddToMenu
Global Const $atmFile = 0
Global Const $atmCompany = 1
Global Const $atmCustomers = 2
Global Const $atmVendors = 3
Global Const $atmEmployees = 4
Global Const $atmBanking = 5

;ENTxnTypeFilter
Global Const $ttfAll = 0
Global Const $ttfBill = 1
Global Const $ttfBillPaymentCheck = 2
Global Const $ttfBillPaymentCreditCard = 3
Global Const $ttfCharge = 4
Global Const $ttfCheck = 5
Global Const $ttfCreditCardCharge = 6
Global Const $ttfCreditCardCredit = 7
Global Const $ttfCreditMemo = 8
Global Const $ttfDeposit = 9
Global Const $ttfEstimate = 10
Global Const $ttfInventoryAdjustment = 11
Global Const $ttfInvoice = 12
Global Const $ttfItemReceipt = 13
Global Const $ttfJournalEntry = 14
Global Const $ttfLiabilityAdjustment = 15
Global Const $ttfPurchaseOrder = 16
Global Const $ttfReceivePayment = 17
Global Const $ttfSalesOrder = 18
Global Const $ttfSalesReceipt = 19
Global Const $ttfSalesTaxPaymentCheck = 20
Global Const $ttfTransfer = 21
Global Const $ttfVendorCredit = 22

;ENFirstMonthFiscalYear
Global Const $fmfyJanuary = 0
Global Const $fmfyFebruary = 1
Global Const $fmfyMarch = 2
Global Const $fmfyApril = 3
Global Const $fmfyMay = 4
Global Const $fmfyJune = 5
Global Const $fmfyJuly = 6
Global Const $fmfyAugust = 7
Global Const $fmfySeptember = 8
Global Const $fmfyOctober = 9
Global Const $fmfyNovember = 10
Global Const $fmfyDecember = 11

;ENFirstMonthIncomeTaxYear
Global Const $fmityJanuary = 0
Global Const $fmityFebruary = 1
Global Const $fmityMarch = 2
Global Const $fmityApril = 3
Global Const $fmityMay = 4
Global Const $fmityJune = 5
Global Const $fmityJuly = 6
Global Const $fmityAugust = 7
Global Const $fmitySeptember = 8
Global Const $fmityOctober = 9
Global Const $fmityNovember = 10
Global Const $fmityDecember = 11

;ENTaxForm
Global Const $tfForm1120 = 0
Global Const $tfForm1120S = 1
Global Const $tfForm1065 = 2
Global Const $tfForm990 = 3
Global Const $tfForm990PF = 4
Global Const $tfForm990T = 5
Global Const $tfForm1040 = 6
Global Const $tfOtherOrNone = 7

;ENBillableStatus
Global Const $bsBillable = 0
Global Const $bsNotBillable = 1
Global Const $bsHasBeenBilled = 2

;ENPaySalesTax
Global Const $pstMonthly = 0
Global Const $pstQuarterly = 1
Global Const $pstAnnually = 2

;ENDataExtType
Global Const $detINTTYPE = 0
Global Const $detAMTTYPE = 1
Global Const $detPRICETYPE = 2
Global Const $detQUANTYPE = 3
Global Const $detPERCENTTYPE = 4
Global Const $detDATETIMETYPE = 5
Global Const $detSTR30TYPE = 6
Global Const $detSTR255TYPE = 7
Global Const $detSTR1024TYPE = 8

;ENVisibleIf
Global Const $viMultiUserMode = 0
Global Const $viHasCustomers = 1
Global Const $viHasVendors = 2
Global Const $viInventoryEnabled = 3
Global Const $viClassesEnabled = 4
Global Const $viPayrollEnabled = 5
Global Const $viTimeTrackingEnabled = 6
Global Const $viPriceLevelsEnabled = 7
Global Const $viAssemblyItemsEnabled = 8
Global Const $viSalesOrdersEnabled = 9
Global Const $viEstimatesEnabled = 10
Global Const $viSalesTaxEnabled = 11
Global Const $viIsAccountantCopy = 12
Global Const $viAccountantCopyExists = 13

;ENVisibleIfNot
Global Const $vinMultiUserMode = 0
Global Const $vinHasCustomers = 1
Global Const $vinHasVendors = 2
Global Const $vinInventoryEnabled = 3
Global Const $vinClassesEnabled = 4
Global Const $vinPayrollEnabled = 5
Global Const $vinTimeTrackingEnabled = 6
Global Const $vinPriceLevelsEnabled = 7
Global Const $vinAssemblyItemsEnabled = 8
Global Const $vinSalesOrdersEnabled = 9
Global Const $vinEstimatesEnabled = 10
Global Const $vinSalesTaxEnabled = 11
Global Const $vinIsAccountantCopy = 12
Global Const $vinAccountantCopyExists = 13

;ENEnabledIf
Global Const $eiMultiUserMode = 0
Global Const $eiHasCustomers = 1
Global Const $eiHasVendors = 2
Global Const $eiInventoryEnabled = 3
Global Const $eiClassesEnabled = 4
Global Const $eiPayrollEnabled = 5
Global Const $eiTimeTrackingEnabled = 6
Global Const $eiPriceLevelsEnabled = 7
Global Const $eiAssemblyItemsEnabled = 8
Global Const $eiSalesOrdersEnabled = 9
Global Const $eiEstimatesEnabled = 10
Global Const $eiSalesTaxEnabled = 11
Global Const $eiIsAccountantCopy = 12
Global Const $eiAccountantCopyExists = 13

;ENEnabledIfNot
Global Const $einMultiUserMode = 0
Global Const $einHasCustomers = 1
Global Const $einHasVendors = 2
Global Const $einInventoryEnabled = 3
Global Const $einClassesEnabled = 4
Global Const $einPayrollEnabled = 5
Global Const $einTimeTrackingEnabled = 6
Global Const $einPriceLevelsEnabled = 7
Global Const $einAssemblyItemsEnabled = 8
Global Const $einSalesOrdersEnabled = 9
Global Const $einEstimatesEnabled = 10
Global Const $einSalesTaxEnabled = 11
Global Const $einIsAccountantCopy = 12
Global Const $einAccountantCopyExists = 13

;ENEmployeeType
Global Const $etRegular = 0
Global Const $etOfficer = 1
Global Const $etStatutory = 2
Global Const $etOwner = 3

;ENGender
Global Const $gMale = 0
Global Const $gFemale = 1

;ENPayPeriod
Global Const $ppDaily = 0
Global Const $ppWeekly = 1
Global Const $ppBiweekly = 2
Global Const $ppSemimonthly = 3
Global Const $ppMonthly = 4
Global Const $ppQuarterly = 5
Global Const $ppYearly = 6

;ENFirstDayOfWeek
Global Const $fdowMonday = 0
Global Const $fdowTuesday = 1
Global Const $fdowWednesday = 2
Global Const $fdowThursday = 3
Global Const $fdowFriday = 4
Global Const $fdowSaturday = 5
Global Const $fdowSunday = 6

;ENAgingReportBasis
Global Const $arbAgeFromDueDate = 0
Global Const $arbAgeFromTransactionDate = 1

;ENSummaryReportBasis
Global Const $srbAccrual = 0
Global Const $srbCash = 1

;ENLinkType
Global Const $ltAMTTYPE = 0
Global Const $ltQUANTYPE = 1

;ENrowType
Global Const $rtaccount = 0
Global Const $rtclass = 1
Global Const $rtcustomer = 2
Global Const $rtcustomerMessage = 3
Global Const $rtcustomerType = 4
Global Const $rtemployee = 5
Global Const $rtitem = 6
Global Const $rtjobType = 7
Global Const $rtlabel = 8
Global Const $rtmemorizedTxn = 9
Global Const $rtmemorizedReport = 10
Global Const $rtname = 11
Global Const $rtotherName = 12
Global Const $rtpaymentMethod = 13
Global Const $rtpayrollItem = 14
Global Const $rtsalesRep = 15
Global Const $rtsalesTaxCode = 16
Global Const $rtshipMethod = 17
Global Const $rtstate = 18
Global Const $rtstyle = 19
Global Const $rtterms = 20
Global Const $rttoDo = 21
Global Const $rtvendor = 22
Global Const $rtvendorType = 23

;ENTemplateType
Global Const $tttCreditMemo = 0
Global Const $tttEstimate = 1
Global Const $tttInvoice = 2
Global Const $tttPurchaseOrder = 3
Global Const $tttSalesOrder = 4
Global Const $tttSalesReceipt = 5

;ENdataType
Global Const $dtIDTYPE = 0
Global Const $dtGUIDTYPE = 1
Global Const $dtSTRTYPE = 2
Global Const $dtBOOLTYPE = 3
Global Const $dtDATETYPE = 4
Global Const $dtDATETIMETYPE = 5
Global Const $dtTIMEINTERVALTYPE = 6
Global Const $dtAMTTYPE = 7
Global Const $dtPRICETYPE = 8
Global Const $dtQUANTYPE = 9
Global Const $dtPERCENTTYPE = 10
Global Const $dtENUMTYPE = 11
Global Const $dtINTTYPE = 12

;ENColType
Global Const $ctAccount = 0
Global Const $ctAddr1 = 1
Global Const $ctAddr2 = 2
Global Const $ctAddr3 = 3
Global Const $ctAddr4 = 4
Global Const $ctAddr5 = 5
Global Const $ctAging = 6
Global Const $ctAmount = 7
Global Const $ctAmountDifference = 8
Global Const $ctAverageCost = 9
Global Const $ctBilledDate = 10
Global Const $ctBillingStatus = 11
Global Const $ctBlank = 12
Global Const $ctCalculatedAmount = 13
Global Const $ctClass = 14
Global Const $ctClearedStatus = 15
Global Const $ctCostPrice = 16
Global Const $ctCreateDate = 17
Global Const $ctCredit = 18
Global Const $ctCustomField = 19
Global Const $ctDate = 20
Global Const $ctDebit = 21
Global Const $ctDeliveryDate = 22
Global Const $ctDueDate = 23
Global Const $ctDuration = 24
Global Const $ctEarliestReceiptDate = 25
Global Const $ctEstimateActive = 26
Global Const $ctFOB = 27
Global Const $ctIncomeSubjectToTax = 28
Global Const $ctInvoiced = 29
Global Const $ctIsAdjustment = 30
Global Const $ctItem = 31
Global Const $ctItemDesc = 32
Global Const $ctItemVendor = 33
Global Const $ctLabel = 34
Global Const $ctLastModifiedBy = 35
Global Const $ctMemo = 36
Global Const $ctModifiedTime = 37
Global Const $ctName = 38
Global Const $ctNameAccountNumber = 39
Global Const $ctNameAddress = 40
Global Const $ctNameCity = 41
Global Const $ctNameContact = 42
Global Const $ctNameEmail = 43
Global Const $ctNameFax = 44
Global Const $ctNamePhone = 45
Global Const $ctNameState = 46
Global Const $ctNameZip = 47
Global Const $ctOpenBalance = 48
Global Const $ctOriginalAmount = 49
Global Const $ctPaidAmount = 50
Global Const $ctPaidStatus = 51
Global Const $ctPaidThroughDate = 52
Global Const $ctPaymentMethod = 53
Global Const $ctPayrollItem = 54
Global Const $ctPercent = 55
Global Const $ctPercentChange = 56
Global Const $ctPercentOfTotalRetail = 57
Global Const $ctPercentOfTotalValue = 58
Global Const $ctPhysicalCount = 59
Global Const $ctPONumber = 60
Global Const $ctPrintStatus = 61
Global Const $ctProgressAmount = 62
Global Const $ctProgressPercent = 63
Global Const $ctQuantity = 64
Global Const $ctQuantityAvailable = 65
Global Const $ctQuantityOnHand = 66
Global Const $ctQuantityOnOrder = 67
Global Const $ctQuantityOnSalesOrder = 68
Global Const $ctReceivedQuantity = 69
Global Const $ctRefNumber = 70
Global Const $ctReorderPoint = 71
Global Const $ctRetailValueOnHand = 72
Global Const $ctRunningBalance = 73
Global Const $ctSalesPerWeek = 74
Global Const $ctSalesRep = 75
Global Const $ctSalesTaxCode = 76
Global Const $ctShipDate = 77
Global Const $ctShipMethod = 78
Global Const $ctShipToAddr1 = 79
Global Const $ctShipToAddr2 = 80
Global Const $ctShipToAddr3 = 81
Global Const $ctShipToAddr4 = 82
Global Const $ctShipToAddr5 = 83
Global Const $ctSONumber = 84
Global Const $ctSourceName = 85
Global Const $ctSplitAccount = 86
Global Const $ctSSNOrTaxID = 87
Global Const $ctSuggestedReorder = 88
Global Const $ctTaxLine = 89
Global Const $ctTaxTableVersion = 90
Global Const $ctTerms = 91
Global Const $ctTotal = 92
Global Const $ctTxnID = 93
Global Const $ctTxnNumber = 94
Global Const $ctTxnType = 95
Global Const $ctUnitPrice = 96
Global Const $ctUserEdit = 97
Global Const $ctValueOnHand = 98
Global Const $ctWageBase = 99
Global Const $ctWageBaseTips = 100

;ENQBFileMode
Global Const $qbfmSingleUser = 0
Global Const $qbfmMultiUser = 1