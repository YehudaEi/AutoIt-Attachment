#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.0
 Author:         Avian

 Script Function:
	Builds telephone directory based on Active Directory information.
	
	Originally intended to create a set of contacts in Outlook that
	would be syncronized with a Handspring Treo 680.  It can optionally
	(controlled in the .ini file) write this information to a tab-delimited
	ASCII file, so it could be imported about anywhere.
	
	Outlook:  The Outlook-specific code does the following:  It assumes
	there is an Outlook category used specifically for these contacts.  The
	code first calls Outlook and DELETES ALL CONTACTS in this category.  It
	then rebuilds the category using the current Active Directory info.  I
	suppose it would have been neater to just go in and update the ones that
	actually changed, but I figured that was too much work.
	
	ASCII:  If you're building an ASCII file, then the code does nothing
	to any Outlook contacts you may have.  It builds the file and then exits.  If 
	you're tinkering with this, I'd suggest using the ASCII file to make sure
	you're getting what you need before dumping to Outlook.  Deleting and
	recreating lots of Outlook contacts is time-consuming.
	
	Of course, if you don't want a phone directory, the code could be 
	modified to return whatever you want from AD.
	
	The code allows you to specify a series of AD "OU"s to be ignored when
	retrieving stuff.  Our field sales folks, who I never had reason to contact,
	were in a different OU, so I could set it to ignore them.  Likewise, 
	there were some AD "EmployeeTypes" that I wanted to ignore also.  For each 
	of these, there's a section of the .ini file that allows you to specify 
	one or more OUs or ETs to be ignored.
	
	In our organization, everyone had a manager except, of course, the CEO.  I 
	wrote the code to ignore any AD record that didn't report to someone else.  I 
	put an entry in the .ini file to allow the code to identify the CEO so it
	didn't exclude them.
	
	You may, of course, have to modify some of the fields to get stuff in the 
	proper format.  I had to do some of that.  You may also have fields that are
	populated in your version of AD that we didn't use.  So, this code should 
	give you an idea of how to do it, but it may require tweaks to get what
	you want.

#ce ----------------------------------------------------------------------------

; -- Read some stuff out of the .ini file.

$IgOUs = IniReadSection("MyCoDirectory.ini", "IgnoreOUs")
If @error Then 
    $NoOUs = 0
Else
	$NoOUs = $IgOUs[0][0]
EndIf

$IgETs = IniReadSection("MyCoDirectory.ini", "IgnoreETs")
If @error Then 
    $NoETs = 0
Else
	$NoETs = $IgETs[0][0]
EndIf

$CEO = IniRead("MyCoDirectory.ini","Settings","CEO", "Unknown" )
$CategoryName = IniRead("MyCoDirectory.ini","Settings","Category","MyCo")

;
; Determine if we're building an ASCII file or updating Outlook
; If BuildFile is set to "YES" in the .ini file, then we're building
; an ASCII file.  Otherwise, we're updating Outlook.
;
$BuildFile = StringUpper(IniRead("MyCoDirectory.ini","Settings","BuildFile","no")) = "YES"

; Remove all the contacts from the old category....

if not $Buildfile Then
  $MyOlApp = ObjCreate("Outlook.Application")
  $MyNameSpace = $MyOlApp.GetNamespace("MAPI")
;
; Point to the contacts...
;
  Global Const $olFolderContacts  = 10
  Global Const $olText  = 1
  Global Const $olContactItem  = 2

  $MyContacts = $MyNameSpace.GetDefaultFolder($olFolderContacts).Items
;
; Limit ourselves to just those in the right category (defined above) in Outlook
;
  $MyItems = $MyContacts.Restrict("[Categories] = '" & $CategoryName & "'")
;
; Delete any old contacts in this group, if any...
;
  For $i = $MyItems.Count To 1 Step -1
    $MyItems($i).Delete
  Next
Else
;
; We're building a file.  Write the column headings.
;
  $file = FileOpen(@ScriptDir & "\" & "MyCoDirectory.txt",2)
  FileWriteLine( $file, "Full Name" & @TAB & "AD OU Group" & @TAB & "Title" & @TAB & "Company/Department" & @tab & "Manager" & _ 
					@TAB & "MyCo ID" & @tab & "EMail Address" & @tab & "MyCo Phone" & @TAB & "MyCo Mobile" & @tab & "Personal Mobile" & @TAB & _ 
					"Physical Location" & @TAB & "Employee Status" )
EndIf

; begin the Active Directory stuff
; --------------------------------------------------------------------------------------
;
$objRootDSE = ObjGet("LDAP://rootDSE")
if not IsObj($objRootDSE) then Msgbox(0,"Error","$objRootDSE is not an Object.")

$objCommand = ObjCreate("ADODB.Command")

$objConnection = ObjCreate("ADODB.Connection")
$objConnection.Provider = "ADsDSOObject"
$objConnection.Open ("Active Directory Provider")

$objCommand.ActiveConnection = $objConnection

$strBase = "<LDAP://" & $objRootDSE.Get("defaultNamingContext") & ">"
;
; Try to get people only:  AD objectcategory = person and objectclass = user, all populated employee types
;
$strFilter = "(&(objectCategory=person)(objectClass=user)(employeeType=*))"
;
; List of fields to be returned from AD.
;
$strAttributes = "AdsPath,manager,company,displayName,name,department,departmentNumber,employeeID," & _
				 "employeeType,mail,mobile,title,physicalDeliveryOfficeName,telephoneNumber,otherMobile,whenChanged"
$strQuery = $strBase & ";" & $strFilter & ";" & $strAttributes & ";subtree"

$objCommand.CommandText = $strQuery
$objCommand.Properties ("Page Size") = 100
$objCommand.Properties ("Timeout") = 30
$ADS_SCOPE_SUBTREE = 2
$objCommand.Properties ("searchscope") = $ADS_SCOPE_SUBTREE

$objRecordSet = $objCommand.Execute
$Count = $objRecordSet.RecordCount 
$objRecordSet.MoveFirst

ProgressOn("Status", "Percent of IDs Processed", "0 percent",-1, -1, 18)
 
$irec = 0
While Not $objRecordSet.EOF

  $strManager = ""
  $Phone = ""
  $EmailAdd = ""
  $FullName = ""
  $LastName = ""
  $Company = ""
  $Dept = ""
  $Mobile = ""
  $OMobile = ""
  $Title = ""
  $CoDept = ""
  $PhysLoc = ""
  $EID = ""
  $ET = ""

    $ignore=False

	$irec += 1
    if Mod( $irec, 200 ) = 0 then 
		ProgressSet( $irec*100/$Count, StringFormat("%4.1f",$irec*100/$Count) & " percent")		
	endif	

	$path = $objRecordSet.Fields("AdsPath").Value
	$ET = $objRecordSet.Fields("employeeType").Value

    $ou=""
	$OUList = StringSplit($path,",OU=",1)
	if @error <> 1 then $ou = $OUList[2]
	
	For $i = 1 To $NoOUs
        If $OU = $IgOUs[$i][1] then $ignore = True
	Next

	For $i = 1 To $NoETs
        If $ET = $IgETs[$i][1] then $ignore = True
		Next
	
	If not $ignore then 

      $Company = $objRecordSet.Fields("company").Value
	  $strUser = $objRecordSet.Fields("displayName").Value
		
	  $Me = $objRecordSet.Fields("AdsPath").Value
	  $OMe = ObjGet( $Me )
	  $OMobile = $OMe.otherMobile
	
      If $objRecordSet.Fields("manager").Value <> chr(0) Then
;
; If this person had a manager, get the manager's name...
;
        $strManager = $objRecordSet.Fields("manager").Value
  	    $objMgr = ObjGet("LDAP://" & $strManager)
  	    $strManager = $objMgr.Get("displayName")
     Else
;
; Presumably the CEO won't have a manager define.  Make sure we don't delete 
; their record, but ignore everything else.
;
      If StringInStr( $strUser, $CEO ) then
		  $strManager = "God"
	   Else
		  $ignore = True
	   EndIf
     EndIf

	  $FullName = $objRecordSet.Fields("name").Value
	  
      $Dept = StringStripWS($objRecordSet.Fields("department").Value,7)
      $DeptNo = StringStripWS($objRecordSet.Fields("departmentNumber").Value,7)
      $CoDept = $Company & "/" & $DeptNo & "/" & $Dept
      $CoDept = StringReplace($CoDept, "//", "/")
      $EID = $objRecordSet.Fields("employeeID").Value
      If StringMid($CoDept,1,1) = "/" then $CoDept = StringTrimLeft($CoDept, 1)

      $Mobile = $objRecordSet.Fields("mobile").Value
      $Title = $objRecordSet.Fields("title").Value
	  $Phone = $objRecordSet.Fields("telephoneNumber").Value
      $PhysLoc = $objRecordSet.Fields("physicalDeliveryOfficeName").Value
	  $EMail = StringLower($objRecordSet.Fields("mail").value)

; Outlook or an ASCII file?

		if not $BuildFile Then
;
; Create a new contact..
;
          $MyItem = $MyOlApp.CreateItem($olContactItem)
;
; Populate the contact.  You may prefer to put things in other
; places.  These were fields I found that were syncronized with 
; my Treo.  YMMV.
;
          With $MyItem
            .FullName = $FullName
            .BusinessTelephoneNumber = $Phone
            .MobileTelephoneNumber = $Mobile
            .Email1Address = $EMail
            .JobTitle = $Title
            .BusinessAddressStreet = $CoDept
            .CompanyName = $PhysLoc
            .OtherTelephoneNumber = $OMobile
		    .User1 = "Mgr: " & $strManager
			.User2 = "Emp. Type = " & $ET
		    .Categories = $CategoryName
;
; The Treo is limited to 16 (ack!) categories.  Use the category
; name to group these contacts on the Treo.
;
            $MyProp = .UserProperties.Add("PalmPilot Category", $olText)
            .UserProperties("PalmPilot Category").Value = $CategoryName
		  
	       EndWith
	      $MyItem.Save
	  Else

		FileWriteLine( $file, $FullName & @TAB & $ou & @TAB & $Title & @TAB & $CoDept & @tab & $strManager & _ 
					@TAB & $EID & @tab & $EMail & @tab & $Phone& @TAB & $Mobile & @tab & $OMobile & @TAB & _ 
					$PhysLoc & @TAB & $ET )
	  EndIf
				
	EndIf				

  $objRecordSet.MoveNext
 Wend

ProgressSet(100 , "Done", "Complete")
Sleep(1000) 
 
if $BuildFile then 
	FileClose( $file )
	MsgBox(0,"File Built",@ScriptDir & "\" & "MyCoDirectory.txt has been created.")
EndIf
