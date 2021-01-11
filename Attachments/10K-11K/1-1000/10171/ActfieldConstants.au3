#include-once

; These constants and these notes are from the software developers kit version 6.0 
; from SAGE SOFTWARE - I claim no responsibility - all i did was translate to autoit

;NOTE this is a constant used throughout the app to for displaying fields.  If you
;would like to view user-defined fields set this value higher.  User-Defined fields
;in ACT start numbering at 1000.  I have set this intentionally at a lower number
;for speed purposes.

Global Const $MAX_FIELDID = 98


;Contact Field Unique IDs
Global Const $CF_UniqueID = 1
Global Const $CF_CreateTimestamp = 2
Global Const $CF_EditTimestamp = 3
Global Const $CF_MergeTimestamp = 4
Global Const $CF_PublicPrivate = 5
Global Const $CF_RecordManager = 6
Global Const $CF_Company = 25
Global Const $CF_Name = 26
Global Const $CF_Address1 = 27
Global Const $CF_Address2 = 28
Global Const $CF_Address3 = 29
Global Const $CF_City = 30
Global Const $CF_State = 31
Global Const $CF_Zip = 32
Global Const $CF_Country = 33
Global Const $CF_IDStatus = 34
Global Const $CF_Phone = 35
Global Const $CF_Fax = 36
Global Const $CF_HomePhone = 37
Global Const $CF_MobilePhone = 38
Global Const $CF_Pager = 39
Global Const $CF_Salutation = 40
Global Const $CF_LastMeet = 41
Global Const $CF_LastReach = 42
Global Const $CF_LastAttempt = 43
Global Const $CF_LetterDate = 44
Global Const $CF_Unused1 = 45
Global Const $CF_Title = 46
Global Const $CF_Assistant = 47
Global Const $CF_LastResults = 48
Global Const $CF_ReferredBy = 49
Global Const $CF_User1 = 50
Global Const $CF_User2 = 51
Global Const $CF_User3 = 52
Global Const $CF_User4 = 53
Global Const $CF_User5 = 54
Global Const $CF_User6 = 55
Global Const $CF_User7 = 56
Global Const $CF_User8 = 57
Global Const $CF_User9 = 58
Global Const $CF_User10 = 59
Global Const $CF_User11 = 60
Global Const $CF_User12 = 61
Global Const $CF_User13 = 62
Global Const $CF_User14 = 63
Global Const $CF_User15 = 64
Global Const $CF_AltAddress1 = 65
Global Const $CF_AltAddress2 = 66
Global Const $CF_AltCity = 67
Global Const $CF_AltState = 68
Global Const $CF_AltZip = 69
Global Const $CF_AltCountry = 70
Global Const $CF_AltPhone = 71
Global Const $CF_Name2 = 72
Global Const $CF_Title2 = 73
Global Const $CF_Phone2 = 74
Global Const $CF_Name3 = 75
Global Const $CF_Title3 = 76
Global Const $CF_Phone3 = 77
Global Const $CF_FirstName = 78
Global Const $CF_LastName = 79
Global Const $CF_Ext = 80                   ;the work phone extension
Global Const $CF_FaxExt = 81                ;the fax extension
Global Const $CF_AltPhoneExt = 82           ;alternate phone extension
Global Const $CF_Phone2Ext = 83             ;contact 2 phone extension
Global Const $CF_Phone3Ext = 84             ;contact 3 phone extension
Global Const $CF_AsstTitle = 85             ;the assistants title
Global Const $CF_AsstPhone = 86             ;the assistant phone
Global Const $CF_AsstExt = 87               ;the assistant extension
Global Const $CF_Department = 88            ;the contact's department
Global Const $CF_Spouse = 89                ;the contact's spouse name
Global Const $CF_Creator = 90               ;the creator of the record
Global Const $CF_UsersCompany = 91          ;equivalent to the ACT! 2.0 Owner field (the company of the user that owns the record)
Global Const $CF_Alt1Reach = 92             ;alternate contact 1 last reach (for ACT! 2.0 compatability)
Global Const $CF_Alt2Reach = 93             ;alternate contact 2 last reach (for ACT! 2.0 compatability)
Global Const $CF_URL = 94                   ;URL or web site address
Global Const $CF_TickerSymbol = 95
Global Const $CF_ContactType = 125
Global Const $CVF_EmailAddress = 200        ;for display of e-mail address
Global Const $CVF_Note = 201                ;for "import" of note
Global Const $CVF_EmailLogon = 202          ;separate components for e-mail logon
Global Const $CVF_EmailCarrier = 203        ;separate component for e-mail carrier


;Group Field Unique IDs
Global Const $GF_UniqueID = 1
Global Const $GF_CreateTimestamp = 2
Global Const $GF_EditTimestamp = 3
Global Const $GF_MergeTimestamp = 4
Global Const $GF_PublicPrivate = 5
Global Const $GF_RecordManager = 6
Global Const $GF_Name = 25
Global Const $GF_Division = 26
Global Const $GF_Address1 = 27
Global Const $GF_Address2 = 28
Global Const $GF_Address3 = 29
Global Const $GF_City = 30
Global Const $GF_State = 31
Global Const $GF_Zip = 32
Global Const $GF_Country = 33
Global Const $GF_Priority = 35
Global Const $GF_User1 = 36
Global Const $GF_User2 = 37
Global Const $GF_User3 = 38
Global Const $GF_User4 = 39
Global Const $GF_Description = 40
Global Const $GF_User5 = 47
Global Const $GF_User6 = 48      ;extra user field
Global Const $GF_Creator = 54    ;the creator of the record
Global Const $GF_ParentId = 55
Global Const $GF_GroupLevel = 56
Global Const $GF_Region = 57
Global Const $GF_Industry = 58
Global Const $GF_SicCode = 59
Global Const $GF_Employees = 60
Global Const $GF_Revenue = 61
Global Const $GF_TotalInGroup = 100
Global Const $GVF_Note = 200


;Activity Field Unique IDs
Global Const $AF_UniqueID = 1
Global Const $AF_CreateTimestamp = 2
Global Const $AF_EditTimestamp = 3
Global Const $AF_MergeTimestamp = 4
Global Const $AF_PublicPrivate = 5
Global Const $AF_Type = 25
Global Const $AF_Priority = 26
Global Const $AF_Regarding = 27
Global Const $AF_StartTime = 28       ;the starting time of the series of activities
Global Const $AF_EndTime = 29         ;the ending time of the series of activities
Global Const $AF_Duration = 30        ;the duration of a single instance of the activity
Global Const $AF_TimelessStatus = 31
Global Const $AF_LeadTime = 32
Global Const $AF_AlarmStatus = 33
Global Const $AF_BannerColor = 34
Global Const $AF_EmailStatus = 35
Global Const $AF_Recurring = 36
Global Const $AF_ScheduledFor = 37
Global Const $AF_ScheduledBy = 38
Global Const $AF_GroupId = 39
Global Const $AF_FirstScheduledWith = 40   ;the first scheduled with (for performance purposes)
Global Const $AF_ClearedStatus = 41        ;the cleared status of this activity
Global Const $AF_RecurringId = 42          ;unique id of this recurring chain
Global Const $AF_Exceptions = 43           ;recurring exception list (stored as a blob)
Global Const $AF_ExceptionDate = 44
Global Const $AF_Details = 45
Global Const $AF_TotalInActivity = 100
Global Const $AF_TotalDuration = 101       ;total duration of the activity series in minutes
Global Const $AVF_ScheduledDate = 200
Global Const $AVF_ScheduledTime = 201



;Note/History Field Unique IDs
Global Const $NHF_UniqueID = 1
Global Const $NHF_CreateTimestamp = 2
Global Const $NHF_EditTimestamp = 3
Global Const $NHF_MergeTimestamp = 4
Global Const $NHF_Type = 25
Global Const $NHF_Text = 26
Global Const $NHF_UserTime = 27
Global Const $NHF_Attachment = 28
Global Const $NHF_ContactId = 29
Global Const $NHF_GroupId = 30
Global Const $NHF_ActivityId = 31
Global Const $NHVF_RecordedDate = 200
Global Const $NHVF_RecordedTime = 201


;EMAIL Field Unique IDs
Global Const $EF_UniqueID = 1
Global Const $EF_CreateTimestamp = 2
Global Const $EF_EditTimestamp = 3
Global Const $EF_MergeTimestamp = 4
Global Const $EF_Logon = 25
Global Const $EF_Carrier = 26
Global Const $EF_PrimaryStatus = 27
Global Const $EF_ContactId = 28

;SALES Field Unique IDs
Global Const $SLF_UniqueID = 1
Global Const $SLF_CreateTimestamp = 2
Global Const $SLF_EditTimestamp = 3
Global Const $SLF_MergeTimestamp = 4
Global Const $SLF_ContactId = 25
Global Const $SLF_GroupId = 26
Global Const $SLF_Status = 27
Global Const $SLF_ProductId = 28
Global Const $SLF_TypeId = 29
Global Const $SLF_Probability = 30
Global Const $SLF_SaleDate = 31
Global Const $SLF_Units = 32
Global Const $SLF_UnitPrice = 33
Global Const $SLF_Amount = 34
Global Const $SLF_SaleStartDate = 35
Global Const $SLF_Notes = 36
Global Const $SLF_CompetitorsId = 37
Global Const $SLF_Reason = 38
Global Const $SLF_SalesStage = 39
Global Const $SLVF_ProductName = 200


;LIST Table Unique IDs
Global Const $LTF_UniqueID = 1
Global Const $LTF_Type = 25
Global Const $LTF_Name = 26

;activity types
Global Const $activitytype_call = 0
Global Const $activitytype_meeting = 1
Global Const $activitytype_todo = 2

;activity priorities
Global Const $activitypriority_high = 0
Global Const $activitypriority_medium = 1
Global Const $activitypriority_low = 2

;history types
Global Const $history_callattempt = 0
Global Const $history_callcomplete = 1
Global Const $history_callreceived = 2
Global Const $history_lettersent = 5
Global Const $history_meetingdone = 6
Global Const $history_meetingnotdone = 7
Global Const $history_tododone = 8
Global Const $history_todonotdone = 9
Global Const $history_timer = 10
Global Const $history_callerased = 11
Global Const $history_deletedcontact = 12
Global Const $history_updatecontact = 13
Global Const $history_updateconact = 14
Global Const $history_updatedelact = 15
Global Const $history_msgemailsent = 16
Global Const $history_callleftmessage = 17
Global Const $history_faxsent = 18
Global Const $history_syncsent = 19
Global Const $history_syncreceived = 20
Global Const $history_replacefieldslog = 21
Global Const $history_todoerased = 22
Global Const $history_meetingerased = 23
Global Const $history_error = 24

;days in month definitions (recurring activities)
Global Const $day_sunday = 1
Global Const $day_monday = 2
Global Const $day_tuesday = 4
Global Const $day_wednesday = 8
Global Const $day_thursday = 16
Global Const $day_friday = 32
Global Const $day_saturday = 64

;weeks in the month definitions (recurring activities)
Global Const $week_one = 1
Global Const $week_two = 2
Global Const $week_three = 4
Global Const $week_four = 8
Global Const $week_last = 16

;types of recurring activities
Global Const $recurring_none = 0
Global Const $recurring_days = 1
Global Const $recurring_weekdays = 2
Global Const $recurring_daysofmonth = 3
Global Const $recurring_daysandweeksofmonth = 4

;tables
Global Const $TABLE_CONTACT = 1
Global Const $TABLE_ACTIVITY = 2
Global Const $TABLE_NOTEHISTORY = 4
Global Const $TABLE_EMAILADDRESS = 8
Global Const $TABLE_GROUP = 16
Global Const $TABLE_SALES = 32

;sales status
Global Const $SALESSTATUS_OPEN = 0
Global Const $SALESSTATUS_WON = 1
Global Const $SALESSTATUS_LOST = 2

;day positions in the month
Global Const $MONTHDAYS_1 = 1
Global Const $MONTHDAYS_2 = 2
Global Const $MONTHDAYS_3 = 4
Global Const $MONTHDAYS_4 = 8
Global Const $MONTHDAYS_5 = 16
Global Const $MONTHDAYS_6 = 32
Global Const $MONTHDAYS_7 = 64
Global Const $MONTHDAYS_8 = 128
Global Const $MONTHDAYS_9 = 256
Global Const $MONTHDAYS_10 = 512
Global Const $MONTHDAYS_11 = 1024
Global Const $MONTHDAYS_12 = 2048
Global Const $MONTHDAYS_13 = 4096
Global Const $MONTHDAYS_14 = 8192
Global Const $MONTHDAYS_15 = 16384
Global Const $MONTHDAYS_16 = 32768
Global Const $MONTHDAYS_17 = 65536
Global Const $MONTHDAYS_18 = 131072
Global Const $MONTHDAYS_19 = 262144
Global Const $MONTHDAYS_20 = 524288
Global Const $MONTHDAYS_21 = 1048576
Global Const $MONTHDAYS_22 = 2097152
Global Const $MONTHDAYS_23 = 4194304
Global Const $MONTHDAYS_24 = 8388608
Global Const $MONTHDAYS_25 = 16777216
Global Const $MONTHDAYS_26 = 33554432
Global Const $MONTHDAYS_27 = 67108864
Global Const $MONTHDAYS_28 = 134217728
Global Const $MONTHDAYS_29 = 268435456
Global Const $MONTHDAYS_30 = 536870912
Global Const $MONTHDAYS_31 = 1073741824


