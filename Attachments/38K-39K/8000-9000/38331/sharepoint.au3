#include-once
#cs ----------------------------------------------------------------------------

 AutoIt Version:	3.3.8.1
 Author:			Joerg Schoppet (joerg(at)schoppet(dot)de)
 Credits:			Main Credits go to Mark Anderson (mark(dot)anderson(at)sympraxisconsulting(dot)com)
					spservices.codeplex.com (this UDF should have the same functionality as SPServices 0.7.2)
 Version:			1.0

 Script Function:	Accessing the SOAP-Webservices of Microsoft Sharepoint
					A much better documentation can be also retrieved from above website

#ce ----------------------------------------------------------------------------

#include <_XMLDomWrapper.au3>
#include <array.au3>

; Constants
;   General
Global Const $SPSLASH					= '/'
Global Const $SPSCHEMASharePoint		= 'http://schemas.microsoft.com/sharepoint'
;   Web Service names
Global Const $SPALERTS					= 'Alerts'
Global Const $SPAUTHENTICATION			= 'Authentication'
Global Const $SPCOPY					= 'Copy'
Global Const $SPFORMS					= 'Forms'
Global Const $SPLISTS					= 'Lists'
Global Const $SPMEETINGS				= 'Meetings'
Global Const $SPPEOPLE					= 'People'
Global Const $SPPERMISSIONS				= 'Permissions'
Global Const $SPPUBLISHEDLINKSSERVICE	= 'PublishedLinksService'
Global Const $SPSEARCH					= 'Search'
Global Const $SPSHAREPOINTDIAGNOSTICS	= 'SharePointDiagnostics'
Global Const $SPSITEDATA				= 'SiteData'
Global Const $SPSITES					= 'Sites'
Global Const $SPSOCIALDATASERVICE		= 'SocialDataService'
Global Const $SPSPELLCHECK				= 'SpellCheck'
Global Const $SPTAXONOMYSERVICE			= 'TaxonomyClientService'
Global Const $SPUSERGROUP				= 'usergroup'
Global Const $SPUSERPROFILESERVICE		= 'UserProfileService'
Global Const $SPVERSIONS				= 'Versions'
Global Const $SPVIEWS					= 'Views'
Global Const $SPWEBPARTPAGES			= 'WebPartPages'
Global Const $SPWEBS					= 'Webs'
Global Const $SPWORKFLOW				= 'Workflow'

; Variables
; Dictionary to store Web Service inforamtion
;		SPWSops.Item(OpName) = Array(WebService, needSOAPAction)
;				OpName				The name of the Web Service operation -> These names are unique
;				WebService			The name of the Web Service this operation belongs to
;				needsSOAPAction		Boolean indication whether the operation needs to have the SOAPAction passed in the setRequestHeader function
;									true if the operations does a write, else false
Global $SPWSops = ObjCreate('Scripting.Dictionary')

; Alerts
Global $aTempF[2] = [$SPALERTS, False]
Global $aTempT[2] = [$SPALERTS, True]
$SPWSops.Add('GetAlerts', $aTempF)
$SPWSops.Add('DeleteAlerts', $aTempT)

; Authentication
Global $aTempF[2] = [$SPAUTHENTICATION, False]
Global $aTempT[2] = [$SPAUTHENTICATION, True]
$SPWSops.Add('Mode', $aTempF)
$SPWSops.Add('Login', $aTempF)

; Copy
Global $aTempF[2] = [$SPCOPY, False]
Global $aTempT[2] = [$SPCOPY, True]
$SPWSops.Add('CopyIntoItems', $aTempT)
$SPWSops.Add('CopyIntoItemsLocal', $aTempT)
$SPWSops.Add('GetItem', $aTempF)

; Forms
Global $aTempF[2] = [$SPFORMS, False]
Global $aTempT[2] = [$SPFORMS, True]
$SPWSops.Add('GetForm', $aTempF)
$SPWSops.Add('GetFormCollection', $aTempF)

; Lists
Global $aTempF[2] = [$SPLISTS, False]
Global $aTempT[2] = [$SPLISTS, True]
$SPWSops.Add('AddAttachment', $aTempT)
$SPWSops.Add('AddDiscussionBoardItem', $aTempT)
$SPWSops.Add('AddList', $aTempT)
$SPWSops.Add('AddListFromFeature', $aTempT)
$SPWSops.Add('ApplyContentTypeToList', $aTempT)
$SPWSops.Add('CheckInFile', $aTempT)
$SPWSops.Add('CheckOutFile', $aTempT)
$SPWSops.Add('CreateContentType', $aTempT)
$SPWSops.Add('DeleteAttachment', $aTempT)
$SPWSops.Add('DeleteContentType', $aTempT)
$SPWSops.Add('DeleteContentTypeXmlDocument', $aTempT)
$SPWSops.Add('DeleteList', $aTempT)
$SPWSops.Add('GetAttachmentCollection', $aTempF)
$SPWSops.Add('GetList', $aTempF)
$SPWSops.Add('GetListAndView', $aTempF)
$SPWSops.Add('GetListCollection', $aTempF)
$SPWSops.Add('GetListContentType', $aTempF)
$SPWSops.Add('GetListContentTypes', $aTempF)
$SPWSops.Add('GetListItemChanges', $aTempF)
$SPWSops.Add('GetListItemChangesSinceToken', $aTempF)
$SPWSops.Add('GetListItems', $aTempF)
$SPWSops.Add('GetVersionCollection', $aTempF)
$SPWSops.Add('UndoCheckOut', $aTempT)
$SPWSops.Add('UpdateContentType', $aTempT)
$SPWSops.Add('UpdateContentTypesXmlDocument', $aTempT)
$SPWSops.Add('UpdateContentTypeXmlDocument', $aTempT)
$SPWSops.Add('UpdateList', $aTempT)
$SPWSops.Add('UpdateListItems', $aTempT)

; Meetings
Global $aTempF[2] = [$SPMEETINGS, False]
Global $aTempT[2] = [$SPMEETINGS, True]
$SPWSops.Add('AddMeeting', $aTempT)
$SPWSops.Add('CreateWorkspace', $aTempT)
$SPWSops.Add('RemoveMeeting', $aTempT)
$SPWSops.Add('SetWOrkSpaceTitle', $aTempT)

; People
Global $aTempF[2] = [$SPPEOPLE, False]
Global $aTempT[2] = [$SPPEOPLE, True]
$SPWSops.Add('ResolvePrincipals', $aTempT)
$SPWSops.Add('SearchPrincipals', $aTempF)

; Permissions
Global $aTempF[2] = [$SPPERMISSIONS, False]
Global $aTempT[2] = [$SPPERMISSIONS, True]
$SPWSops.Add('AddPermission', $aTempT)
$SPWSops.Add('AddPermissionCollection', $aTempT)
$SPWSops.Add('GetPermissionCollection', $aTempF)
$SPWSops.Add('RemovePermission', $aTempT)
$SPWSops.Add('RemovePermissionCollection', $aTempT)
$SPWSops.Add('UpdatePermission', $aTempT)

; PublishedLinksService
Global $aTempF[2] = [$SPPUBLISHEDLINKSSERVICE, False]
Global $aTempT[2] = [$SPPUBLISHEDLINKSSERVICE, True]
$SPWSops.Add('GetLinks', $aTempF)

; Search
Global $aTempF[2] = [$SPSEARCH, False]
Global $aTempT[2] = [$SPSEARCH, True]
$SPWSops.Add('GetPortalSearchInfo', $aTempF)
$SPWSops.Add('GetQuerySuggestions', $aTempF)
$SPWSops.Add('GetSearchMetadata', $aTempF)
$SPWSops.Add('Query', $aTempF)
$SPWSops.Add('QueryEx', $aTempF)
$SPWSops.Add('Registration', $aTempF)
$SPWSops.Add('Status', $aTempF)

; SharepointDiagnostics
Global $aTempF[2] = [$SPSHAREPOINTDIAGNOSTICS, False]
Global $aTempT[2] = [$SPSHAREPOINTDIAGNOSTICS, True]
$SPWSops.Add('SendClientScriptErrorReport', $aTempT)

; SiteData
Global $aTempF[2] = [$SPSITEDATA, False]
Global $aTempT[2] = [$SPSITEDATA, True]
$SPWSops.Add('GetAttachments', $aTempF)
$SPWSops.Add('EnumerateFolder', $aTempF)
$SPWSops.Add('SiteDataGetList', $aTempF)
$SPWSops.Add('SiteDataGetListCollection', $aTempF)
$SPWSops.Add('SiteDataGetSite', $aTempF)
$SPWSops.Add('SiteDataGetSiteUrl', $aTempF)
$SPWSops.Add('SiteDataGetWeb', $aTempF)

; Sites
Global $aTempF[2] = [$SPSITES, False]
Global $aTempT[2] = [$SPSITES, True]
$SPWSops.Add('CreateWeb', $aTempT)
$SPWSops.Add('DeleteWeb', $aTempT)
$SPWSops.Add('GetSite', $aTempF)
$SPWSops.Add('GetSiteTemplates', $aTempF)

; SocialDataService
Global $aTempF[2] = [$SPSOCIALDATASERVICE, False]
Global $aTempT[2] = [$SPSOCIALDATASERVICE, True]
$SPWSops.Add('AddComment', $aTempT)
$SPWSops.Add('AddTag', $aTempT)
$SPWSops.Add('AddTagByKeyword', $aTempT)
$SPWSops.Add('CountCommentsOfUser', $aTempF)
$SPWSops.Add('CountCommentsOfUserOnUrl', $aTempF)
$SPWSops.Add('CountCommentsOnUrl', $aTempF)
$SPWSops.Add('CountRatingsOnUrl', $aTempF)
$SPWSops.Add('CountTagsOfUser', $aTempF)
$SPWSops.Add('DeleteComment', $aTempT)
$SPWSops.Add('DeleteRating', $aTempT)
$SPWSops.Add('DeleteTag', $aTempT)
$SPWSops.Add('DeleteTagByKeyword', $aTempT)
$SPWSops.Add('DeleteTags', $aTempT)
$SPWSops.Add('GetAllTagTerms', $aTempF)
$SPWSops.Add('GetAllTagTermsForUrlFolder', $aTempF)
$SPWSops.Add('GetAllTagUrls', $aTempF)
$SPWSops.Add('GetAllTagUrlsByKeyword', $aTempF)
$SPWSops.Add('GetCommentsOfUser', $aTempF)
$SPWSops.Add('GetCommentsOfUserOnUrl', $aTempF)
$SPWSops.Add('GetCommentsOnUrl', $aTempF)
$SPWSops.Add('GetRatingAverageOnUrl', $aTempF)
$SPWSops.Add('GetRatingOfUserOnUrl', $aTempF)
$SPWSops.Add('GetRatingOnUrl', $aTempF)
$SPWSops.Add('GetRatingsOfUser', $aTempF)
$SPWSops.Add('GetRatingsOnUrl', $aTempF)
$SPWSops.Add('GetSocialDataForFullReplication', $aTempF)
$SPWSops.Add('GetTags', $aTempT)
$SPWSops.Add('GetTagsOfUser', $aTempT)
$SPWSops.Add('GetTagTerms', $aTempT)
$SPWSops.Add('GetTagTermsOfUser', $aTempT)
$SPWSops.Add('GetTagTermsOnUrl', $aTempT)
$SPWSops.Add('GetTagUrlsOfUser', $aTempT)
$SPWSops.Add('GetTagUrlsOfUserByKeyword', $aTempT)
$SPWSops.Add('GetTagUrls', $aTempT)
$SPWSops.Add('GetTagUrlsByKeyword', $aTempT)
$SPWSops.Add('SetRating', $aTempT)
$SPWSops.Add('UpdateComment', $aTempT)

; SpellCheck
Global $aTempF[2] = [$SPSPELLCHECK, False]
Global $aTempT[2] = [$SPSPELLCHECK, True]
$SPWSops.Add('SpellCheck', $aTempF)

; TaxonomyService
Global $aTempF[2] = [$SPTAXONOMYSERVICE, False]
Global $aTempT[2] = [$SPTAXONOMYSERVICE, True]
$SPWSops.Add('AddTerms', $aTempT)
$SPWSops.Add('GetChildTermsInTerm', $aTempF)
$SPWSops.Add('GetChildTermsInTermSet', $aTempF)
$SPWSops.Add('GetKeywordTermsByGuids', $aTempF)
$SPWSops.Add('GetTermsByLabel', $aTempF)
$SPWSops.Add('GetTermSets', $aTempF)

; Usergroup
Global $aTempF[2] = [$SPUSERGROUP, False]
Global $aTempT[2] = [$SPUSERGROUP, True]
$SPWSops.Add('AddGroup', $aTempT)
$SPWSops.Add('AddGroupToRole', $aTempT)
$SPWSops.Add('AddRole', $aTempT)
$SPWSops.Add('AddRoleDef', $aTempT)
$SPWSops.Add('AddUserCollectionToGroup', $aTempT)
$SPWSops.Add('AddUserCollectionToRole', $aTempT)
$SPWSops.Add('AddUserToGroup', $aTempT)
$SPWSops.Add('AddUserToRole', $aTempT)
$SPWSops.Add('GetAllUserCollectionFromWeb', $aTempF)
$SPWSops.Add('GetGroupCollection', $aTempF)
$SPWSops.Add('GetGroupCollectionFromRole', $aTempF)
$SPWSops.Add('GetGroupCollectionFromSite', $aTempF)
$SPWSops.Add('GetGroupCollectionFromUser', $aTempF)
$SPWSops.Add('GetGroupCollectionFromWeb', $aTempF)
$SPWSops.Add('GetGroupInfo', $aTempF)
$SPWSops.Add('GetRoleCollection', $aTempF)
$SPWSops.Add('GetRoleCollectionFromGroup', $aTempF)
$SPWSops.Add('GetRoleCollectionFromUser', $aTempF)
$SPWSops.Add('GetRoleCollectionFromWeb', $aTempF)
$SPWSops.Add('GetRuleInfo', $aTempF)
$SPWSops.Add('GetRolesAndPermissionsForCurrentUser', $aTempF)
$SPWSops.Add('GetRolesAndPermissionsForSite', $aTempF)
$SPWSops.Add('GetUserCollection', $aTempF)
$SPWSops.Add('GetUserCollectionFromGroup', $aTempF)
$SPWSops.Add('GetUserCollectionFromRole', $aTempF)
$SPWSops.Add('GetUserCollectionFromSite', $aTempF)
$SPWSops.Add('GetUserCollectionFromWeb', $aTempF)
$SPWSops.Add('GetUserInfo', $aTempF)
$SPWSops.Add('GetUserLoginFromEmail', $aTempF)
$SPWSops.Add('RemoveGroup', $aTempT)
$SPWSops.Add('RemoveGroupFromRole', $aTempT)
$SPWSops.Add('RemoveRole', $aTempT)
$SPWSops.Add('RemoveUserCollectionFromGroup', $aTempT)
$SPWSops.Add('RemoveUserCollectionFromRole', $aTempT)
$SPWSops.Add('RemoveUserCollectionFromSite', $aTempT)
$SPWSops.Add('RemoveUserFromGroup', $aTempT)
$SPWSops.Add('RemoveUserFromRole', $aTempT)
$SPWSops.Add('RemoveUserFromSite', $aTempT)
$SPWSops.Add('RemoveUserFromWeb', $aTempT)
$SPWSops.Add('UpdateGroupInfo', $aTempT)
$SPWSops.Add('UpdateRoleDefInfo', $aTempT)
$SPWSops.Add('UpdateRoleInfo', $aTempT)
$SPWSops.Add('UpdateUserInfo', $aTempT)

; UserProfileService
Global $aTempF[2] = [$SPUSERPROFILESERVICE, False]
Global $aTempT[2] = [$SPUSERPROFILESERVICE, True]
$SPWSops.Add('AddColleague', $aTempT)
$SPWSops.Add('AddLink', $aTempT)
$SPWSops.Add('AddMembership', $aTempT)
$SPWSops.Add('AddPinnedLink', $aTempT)
$SPWSops.Add('CreateMemberGroup', $aTempT)
$SPWSops.Add('CreateUserProfileByAccountName', $aTempT)
$SPWSops.Add('GetCommonColleagues', $aTempF)
$SPWSops.Add('GetCommonManager', $aTempF)
$SPWSops.Add('GetCommonMemberships', $aTempF)
$SPWSops.Add('GetInCommon', $aTempF)
$SPWSops.Add('GetPropertyChoiceList', $aTempF)
$SPWSops.Add('GetUserColleagues', $aTempF)
$SPWSops.Add('GetUserLinks', $aTempF)
$SPWSops.Add('GetUserMemberships', $aTempF)
$SPWSops.Add('GetUserPinnedLinks', $aTempF)
$SPWSops.Add('GetUserProfileByGuid', $aTempF)
$SPWSops.Add('GetUserProfileByIndex', $aTempF)
$SPWSops.Add('GetUserProfileByName', $aTempF)
$SPWSops.Add('GetUserProfileCount', $aTempF)
$SPWSops.Add('GetUserProfileSchema', $aTempF)
$SPWSops.Add('ModifyUserPropertyByAccountName', $aTempT)
$SPWSops.Add('RemoveAllColleagues', $aTempT)
$SPWSops.Add('RemoveAllLinks', $aTempT)
$SPWSops.Add('RemoveAllMemberships', $aTempT)
$SPWSops.Add('RemoveAllPinnedLinks', $aTempT)
$SPWSops.Add('RemoveColleague', $aTempT)
$SPWSops.Add('RemoveLink', $aTempT)
$SPWSops.Add('RemoveMembership', $aTempT)
$SPWSops.Add('RemovePinnedLink', $aTempT)
$SPWSops.Add('UpdateColleaguePrivacy', $aTempT)
$SPWSops.Add('UpdateLink', $aTempT)
$SPWSops.Add('UpdateMembershipPrivacy', $aTempT)
$SPWSops.Add('UpdatePinnedLink', $aTempT)

; Versions
Global $aTempF[2] = [$SPVERSIONS, False]
Global $aTempT[2] = [$SPVERSIONS, True]
$SPWSops.Add('DeleteAllVersions', $aTempT)
$SPWSops.Add('DeleteVersion', $aTempT)
$SPWSops.Add('GetVersions', $aTempF)
$SPWSops.Add('RestoreVersion', $aTempT)

; Views
Global $aTempF[2] = [$SPVIEWS, False]
Global $aTempT[2] = [$SPVIEWS, True]
$SPWSops.Add('AddView', $aTempT)
$SPWSops.Add('DeleteView', $aTempT)
$SPWSops.Add('GetView', $aTempF)
$SPWSops.Add('GetViewHtml', $aTempF)
$SPWSops.Add('GetViewCollection', $aTempF)
$SPWSops.Add('UpdateView', $aTempT)
$SPWSops.Add('UpdateViewHtml', $aTempT)

; WebPartPages
Global $aTempF[2] = [$SPWEBPARTPAGES, False]
Global $aTempT[2] = [$SPWEBPARTPAGES, True]
$SPWSops.Add('AddWebPart', $aTempT)
$SPWSops.Add('AddWebPartToZone', $aTempT)
$SPWSops.Add('GetWebPart2', $aTempF)
$SPWSops.Add('GetWebPartPage', $aTempF)
$SPWSops.Add('GetWebPartProperties', $aTempF)
$SPWSops.Add('GetWebPartProperties2', $aTempF)

; Webs
Global $aTempF[2] = [$SPWEBS, False]
Global $aTempT[2] = [$SPWEBS, True]
$SPWSops.Add('WebsCreateContentType', $aTempT)
$SPWSops.Add('GetColumns', $aTempF)
$SPWSops.Add('GetContentType', $aTempF)
$SPWSops.Add('GetContentTypes', $aTempF)
$SPWSops.Add('GetCustomizedPageStatus', $aTempF)
$SPWSops.Add('GetListTemplates', $aTempF)
$SPWSops.Add('GetObjectIdFromUrl', $aTempF)
$SPWSops.Add('GetWeb', $aTempF)
$SPWSops.Add('GetWebCollection', $aTempF)
$SPWSops.Add('GetAllSubWebCollection', $aTempF)
$SPWSops.Add('UpdateColumns', $aTempT)
$SPWSops.Add('WebsUpdateContentType', $aTempT)
$SPWSops.Add('WebUrlFromPageUrl', $aTempF)

; Workflow
Global $aTempF[2] = [$SPWORKFLOW, False]
Global $aTempT[2] = [$SPWORKFLOW, True]
$SPWSops.Add('AlterToDo', $aTempT)
$SPWSops.Add('GetTemplatesForItem', $aTempF)
$SPWSops.Add('GetToDosForItem', $aTempF)
$SPWSops.Add('GetWorkflowDataForItem', $aTempF)
$SPWSops.Add('GetWorkflowTaskData', $aTempF)
$SPWSops.Add('StartWorkflow', $aTempT)

; Set up SOAP envelope
Global $SPSOAPEnvelope = ObjCreate('Scripting.Dictionary')
$SPSOAPEnvelope.Add('header', "<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body>")
$SPSOAPEnvelope.Add('opheader', '')
$SPSOAPEnvelope.Add('payload', '')
$SPSOAPEnvelope.Add('opfooter', '')
$SPSOAPEnvelope.Add('footer', "</soap:Body></soap:Envelope>")

; #FUNCTION# ====================================================================================================================
; Name ..........: _SPServices
; Description ...: Main function, which calls SharePoint's Web Services directly
; Syntax ........: _SPServices($oOptions)
; Parameters ....: $oOptions            - Scripting.Dictionary Object, which controls the usage
; Return values .: Return the return of the function specified in option "completefunc" or True
; Author ........: Joerg Schoppet
; Modified ......:
; Remarks .......:
; Related .......:
; ===============================================================================================================================
Func _SPServices($oOptions)
	Local $sSOAPAction
	Local $aOperation
	Local $ajaxURL
	Local $oParameters
	Local $sMessage
	Local $oXMLHTTP
	Local $sResult

	$sSOAPAction = ''
	$SPSOAPEnvelope.Item('opheader') = ''
	$SPSOAPEnvelope.Item('payload') = ''
	$SPSOAPEnvelope.Item('opfooter') = ''

	; If there are no options passed in, use the defaults
	$oOptions = __SPMergeOptions($oOptions)

	; Put together operation header and SOAPAction for the SOAP call based on which Web Service we're calling
	$SPSOAPEnvelope.Item('opheader') = '<' & $oOptions.Item('operation') & ' '
	$aOperation = $SPWSops.Item($oOptions.Item('operation'))

	Switch $aOperation[0]
		Case $SPALERTS
			$SPSOAPEnvelope.Item('opheader') = $SPSOAPEnvelope.Item('opheader') & "xmlns='" & $SPSCHEMASharePoint & "/soap/2002/1/alerts/'>"
			$sSOAPAction = $SPSCHEMASharePoint & '/soap/2002/1/alerts/'
		Case $SPMEETINGS
			$SPSOAPEnvelope.Item('opheader') = $SPSOAPEnvelope.Item('opheader') & "xmlns='" & $SPSCHEMASharePoint & "/soap/meetings/'>"
			$sSOAPAction = $SPSCHEMASharePoint & '/soap/meetings/'
		Case $SPPERMISSIONS
			$SPSOAPEnvelope.Item('opheader') = $SPSOAPEnvelope.Item('opheader') & "xmlns='" & $SPSCHEMASharePoint & "/soap/directory/'>"
			$sSOAPAction = $SPSCHEMASharePoint & '/soap/directory/'
		Case $SPPUBLISHEDLINKSSERVICE
			$SPSOAPEnvelope.Item('opheader') = $SPSOAPEnvelope.Item('opheader') & "xmlns='http://microsoft.com/webservices/SharePointPortalServer/PublishedLinksService/'>"
			$sSOAPAction = 'http://microsoft.com/webservices/SharePointPortalServer/PublishedLinksService/'
		Case $SPSEARCH
			$SPSOAPEnvelope.Item('opheader') = $SPSOAPEnvelope.Item('opheader') & "xmlns='urn:Microsoft.Search'>"
			$sSOAPAction = 'urn:Microsoft.Search/'
		Case $SPSHAREPOINTDIAGNOSTICS
			$SPSOAPEnvelope.Item('opheader') = $SPSOAPEnvelope.Item('opheader') & "xmlns='" & $SPSCHEMASharePoint & "/diagnostics/'>"
			$sSOAPAction = $SPSCHEMASharePoint & '/diagnostics/'
		Case $SPSOCIALDATASERVICE
			$SPSOAPEnvelope.Item('opheader') = $SPSOAPEnvelope.Item('opheader') & "xmlns='http://microsoft.com/webservices/SharePointPortalServer/SocialDataService'>"
			$sSOAPAction = 'http://microsoft.com/webservices/SharePointPortalServer/SocialDataService/'
		Case $SPSPELLCHECK
			$SPSOAPEnvelope.Item('opheader') = $SPSOAPEnvelope.Item('opheader') & "xmlns='" & $SPSCHEMASharePoint & "/publishing/spelling/'>"
			$sSOAPAction = $SPSCHEMASharePoint & '/publishing/spelling/SpellCheck'
		Case $SPTAXONOMYSERVICE
			$SPSOAPEnvelope.Item('opheader') = $SPSOAPEnvelope.Item('opheader') & "xmlns='" & $SPSCHEMASharePoint & "/taxonomy/soap/'>"
			$sSOAPAction = $SPSCHEMASharePoint & '/taxonomy/soap/'
		Case $SPUSERGROUP
			$SPSOAPEnvelope.Item('opheader') = $SPSOAPEnvelope.Item('opheader') & "xmlns='" & $SPSCHEMASharePoint & "/soap/directory/'>"
			$sSOAPAction = $SPSCHEMASharePoint & '/soap/directory/'
		Case $SPUSERPROFILESERVICE
			$SPSOAPEnvelope.Item('opheader') = $SPSOAPEnvelope.Item('opheader') & "xmlns='http://microsoft.com/webservices/SharePointPortalServer/UserProfileService'>"
			$sSOAPAction = 'http://microsoft.com/webservices/SharePointPortalServer/UserProfile/Service/'
		Case $SPWEBPARTPAGES
			$SPSOAPEnvelope.Item('opheader') = $SPSOAPEnvelope.Item('opheader') & "xmlns='http://microsoft.com/sharepoint/webpartpages'>"
			$sSOAPAction = 'http://microsoft.com/sharepoint/webpartpages/'
		Case $SPWORKFLOW
			$SPSOAPEnvelope.Item('opheader') = $SPSOAPEnvelope.Item('opheader') & "xmlns='" & $SPSCHEMASharePoint & "/soap/workflow/'>"
			$sSOAPAction = $SPSCHEMASharePoint = '/soap/workflow/'
		Case Else
			$SPSOAPEnvelope.Item('opheader') = $SPSOAPEnvelope.Item('opheader') & "xmlns='" & $SPSCHEMASharePoint & "/soap/'>"
			$sSOAPAction = $SPSCHEMASharePoint & '/soap/'
	EndSwitch

	; Add the operation to the SOAPAction and opfooter
	$sSOAPAction &= $oOptions.Item('operation')
	$SPSOAPEnvelope.Item('opfooter') = '</' & $oOptions.Item('operation') & '>'

	; Build the URL for the ajax call based on which operation we're calling
	$ajaxURL = '_vti_bin/' & $aOperation[0] & '.asmx'

	If $SPSLASH == StringRight($oOptions.Item('webURL'), 1) Then
		$ajaxURL = $oOptions.Item('webURL') & $ajaxURL
	Else
		$ajaxURL = $oOptions.Item('webURL') & $SPSLASH & $ajaxURL
	EndIf

	; Each operation requires a different set of values. This switch statement sets them up in the SOAPEnvelope.payload
	Switch $oOptions.Item('operation')
		; ALERT Operations
		Case 'GetAlerts'
		Case 'DeleteAlerts'
			$SPSOAPEnvelope.Item('payload') = $SPSOAPEnvelope.Item('payload') & '<IDs>'

			For $id In $oOptions.Item('IDs')
				$SPSOAPEnvelope.Item('payload') = $SPSOAPEnvelope.Item('payload') & __SPWrapNode('string', $id)
			Next

			$SPSOAPEnvelope.Item('payload') = $SPSOAPEnvelope.Item('payload') & '</IDs>'
		; AUTHENTICATION Operations
		Case 'Mode'
		Case 'Login'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('username', '')
			$oParameters.Add('password', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		; COPY Operations
		Case 'CopyIntoItems'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('SourceUrl', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
			$SPSOAPEnvelope.Item('payload') = $SPSOAPEnvelope.Item('payload') & '<DestinationUrls>'

			For $url In $oOptions.Item('DestinationUrls')
				$SPSOAPEnvelope.Item('payload') = $SPSOAPEnvelope.Item('payload') & __SPWrapNode('string', $url)
			Next

			$SPSOAPEnvelope.Item('payload') = $SPSOAPEnvelope.Item('payload') & '</DestinationUrls>'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('Fields', '')
			$oParameters.Add('Stream', '')
			$oParameters.Add('Results', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'CopyIntoItemsLocal'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('SourceUrl', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
			$SPSOAPEnvelope.Item('payload') = $SPSOAPEnvelope.Item('payload') & '<DestinationUrls>'

			For $url In $oOptions.Item('DestinationUrls')
				$SPSOAPEnvelope.Item('payload') = $SPSOAPEnvelope.Item('payload') & __SPWrapNode('string', $url)
			Next

			$SPSOAPEnvelope.Item('payload') = $SPSOAPEnvelope.Item('payload') & '</DestinationUrls>'
		Case 'GetItem'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('Url', '')
			$oParameters.Add('Fields', '')
			$oParameters.Add('Stream', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		; FORM Operations
		Case 'GetForm'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			$oParameters.Add('formUrl', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetFormCollection'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		; LIST Operations
		Case 'AddAttachment'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			$oParameters.Add('listItemID', '')
			$oParameters.Add('fileName', '')
			$oParameters.Add('attachment', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'AddDiscussionBoardItem'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			$oParameters.Add('message', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'AddList'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			$oParameters.Add('description', '')
			$oParameters.Add('templateID', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'AddListFromFeature'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			$oParameters.Add('description', '')
			$oParameters.Add('featureID', '')
			$oParameters.Add('templateID', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'ApplyContentTypeToList'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('webUrl', '')
			$oParameters.Add('contentTypeId', '')
			$oParameters.Add('listName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'CheckInFile'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('pageUrl', '')
			$oParameters.Add('comment', '')
			$oParameters.Add('CheckinType', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'CheckOutFile'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('pageUrl', '')
			$oParameters.Add('checkoutToLocal', '')
			$oParameters.Add('lastmodified', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'CreateContentType'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			$oParameters.Add('displayName', '')
			$oParameters.Add('parentType', '')
			$oParameters.Add('fields', '')
			$oParameters.Add('contentTypeProperties', '')
			$oParameters.Add('addToView', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'DeleteAttachment'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			$oParameters.Add('listItemID', '')
			$oParameters.Add('url', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'DeleteContentType'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			$oParameters.Add('contentTypeId', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'DeleteContentTypeXmlDocument'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			$oParameters.Add('contentTypeId', '')
			$oParameters.Add('documentUri', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'DeleteList'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetAttachmentCollection'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			$oParameters.Add('listItemID', 'ID')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetList'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetListAndView'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			$oParameters.Add('viewName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetListCollection'
		Case 'GetListContentType'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			$oParameters.Add('contentTypeId', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetListContentTypes'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetListItems'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			$oParameters.Add('viewName', '')
			$oParameters.Add('query', 'CAMLQuery')
			$oParameters.Add('viewFields', 'CAMLViewFields')
			$oParameters.Add('rowLimit', 'CAMLRowLimit')
			$oParameters.Add('queryOptions', 'CAMLQueryOptions')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetListItemChanges'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			$oParameters.Add('viewFields', '')
			$oParameters.Add('since', '')
			$oParameters.Add('contains', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetListItemChangesSinceToken'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			$oParameters.Add('viewName', '')
			$oParameters.Add('query', '')
			$oParameters.Add('viewFields', '')
			$oParameters.Add('rowLimit', '')
			$oParameters.Add('queryOptions', '')
			$oParameters.Add('changeToken', '')
			$oParameters.Add('contain', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetVersionCollection'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('strlistID', '')
			$oParameters.Add('strlistItemID', '')
			$oParameters.Add('strFieldName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'UndoCheckOut'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('pageUrl', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'UpdateContentType'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			$oParameters.Add('contentTypeId', '')
			$oParameters.Add('contentTypeProperties', '')
			$oParameters.Add('newFields', '')
			$oParameters.Add('updateFields', '')
			$oParameters.Add('deleteFields', '')
			$oParameters.Add('addToView', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'UpdateContentTypesXmlDocument'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			$oParameters.Add('newDocument', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'UpdateContentTypeXmlDocument'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			$oParameters.Add('contentTypeId', '')
			$oParameters.Add('newDocument', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'UpdateList'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			$oParameters.Add('listProperties', '')
			$oParameters.Add('newFields', '')
			$oParameters.Add('updateFields', '')
			$oParameters.Add('deleteFields', '')
			$oParameters.Add('listVersion', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'UpdateListItems'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0

			If True == $oOptions.Exists('updates') And 0 < StringLen($oOptions.Item('updates')) Then
				$oParameters = ObjCreate('Scripting.Dictionary')
				$oParameters.Add('updates', '')
				__SPAddToPayload($oOptions, $oParameters)
				$oParameters = 0
			Else
				$SPSOAPEnvelope.Item('payload') = $SPSOAPEnvelope.Item('payload') & "<updates><Batch OnError='Continue'><Method ID='1' Cmd='" & $oOptions.Item('batchCmd') & "'>"

				For $sField In $oOptions.Item('valuepairs')
					$SPSOAPEnvelope.Item('payload') = $SPSOAPEnvelope.Item('payload') & "<Field Name='" & $sField & "'>" & __SPEscapeColumnValue($oOptions.Item('valuepairs').Item($sField)) & "</Field>"
				Next

				If 'New' <> $oOptions.Item('batchCmd') Then
					$SPSOAPEnvelope.Item('payload') = $SPSOAPEnvelope.Item('payload') & "<Field Name='ID'>" & $oOptions.Item('ID') & "</Field>"
				EndIf

				$SPSOAPEnvelope.Item('payload') = $SPSOAPEnvelope.Item('payload') & "</Method></Batch></updates>"
			EndIf

		; MEETINGS Operations
		Case 'AddMeeting'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('organizerEmail', '')
			$oParameters.Add('uid', '')
			$oParameters.Add('sequence', '')
			$oParameters.Add('utcDateStamp', '')
			$oParameters.Add('title', '')
			$oParameters.Add('location', '')
			$oParameters.Add('utcDateStart', '')
			$oParameters.Add('utcDateEnd', '')
			$oParameters.Add('nonGregorian', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'CreateWorkspace'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('title', '')
			$oParameters.Add('templateName', '')
			$oParameters.Add('lcid', '')
			$oParameters.Add('timeZoneInformation', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'RemoveMeeting'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('recurrenceId', '')
			$oParameters.Add('uid', '')
			$oParameters.Add('sequence', '')
			$oParameters.Add('utcDateStamp', '')
			$oParameters.Add('cancelMeeting', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'SetWorkspaceTitle'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('title', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		; PEOPLE Operations
		Case 'ResolvePrincipals'
			$oOptions.Item('principalKeys') = __SPWrapNode('string', $oOptions.Item('principalKeys'))
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('principalKeys', '')
			$oParameters.Add('principalType', '')
			$oParameters.Add('addToUserInfoList', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'SearchPrincipals'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('searchText', '')
			$oParameters.Add('maxResults', '')
			$oParameters.Add('principalType', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		; PERMISSION Operations
		Case 'AddPermission'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('objectName', '')
			$oParameters.Add('objectType', '')
			$oParameters.Add('permissionIdentifier', '')
			$oParameters.Add('permissionType', '')
			$oParameters.Add('permissionMask', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'AddPermissionCollection'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('objectName', '')
			$oParameters.Add('objectType', '')
			$oParameters.Add('permissionInfoXml', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetPermissionCollection'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('objectName', '')
			$oParameters.Add('objectType', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'RemovePermission'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('objectName', '')
			$oParameters.Add('objectType', '')
			$oParameters.Add('permissionIdentifier', '')
			$oParameters.Add('permissionType', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'RemovePermissionCollection'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('objectName', '')
			$oParameters.Add('objectType', '')
			$oParameters.Add('memberIdsXml', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'UpdatePermission'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('objectName', '')
			$oParameters.Add('objectType', '')
			$oParameters.Add('permissionIdentifier', '')
			$oParameters.Add('permissionType', '')
			$oParameters.Add('permissionMask', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		; PUBLISHEDLINKSSERVICE Operations
		Case 'GetLinks'
		; SEARCH Operations
		Case 'GetPortalSearchInfo'
			$SPSOAPEnvelope.Item('opheader') = '<' & $oOptions.Item('operation') & " xmlns='http://microsoft.com/webservices/OfficeServer/QueryService'>"
			$sSOAPAction = 'http://microsoft.com/webservices/OfficeServer/QueryService/' & $oOptions.Item('operation')
		Case 'GetQuerySuggestions'
			$SPSOAPEnvelope.Item('opheader') = '<' & $oOptions.Item('operation') & " xmlns='http://microsoft.com/webservices/OfficeServer/QueryService'>"
			$sSOAPAction = 'http://microsoft.com/webservices/OfficeServer/QueryService/' & $oOptions.Item('operation')
			$SPSOAPEnvelope.Item('payload') = $SPSOAPEnvelope.Item('payload') & __SPWrapNode('queryXml', __SPEscapeHTML($oOptions.Item('queryXml')))
		Case 'GetSearchMetadata'
			$SPSOAPEnvelope.Item('opheader') = '<' & $oOptions.Item('operation') & " xmlns='http://microsoft.com/webservices/OfficeServer/QueryService'>"
			$sSOAPAction = 'http://microsoft.com/webservices/OfficeServer/QueryService/' & $oOptions.Item('operation')
		Case 'Query'
			$SPSOAPEnvelope.Item('payload') = $SPSOAPEnvelope.Item('payload') & __SPWrapNode('queryXml', __SPEscapeHTML($oOptions.Item('queryXml')))
		Case 'QueryEx'
			$SPSOAPEnvelope.Item('opheader') = '<' & $oOptions.Item('operation') & " xmlns='http://microsoft.com/webservices/OfficeServer/QueryService'>"
			$sSOAPAction = 'http://microsoft.com/webservices/OfficeServer/QueryService/' & $oOptions.Item('operation')
			$SPSOAPEnvelope.Item('payload') = $SPSOAPEnvelope.Item('payload') & __SPWrapNode('queryXml', __SPEscapeHTML($oOptions.Item('queryXml')))
		Case 'Registration'
			$SPSOAPEnvelope.Item('payload') = $SPSOAPEnvelope.Item('payload') & __SPWrapNode('registrationXml', __SPEscapeHTML($oOptions.Item('registrationXml')))
		Case 'Status'
		; SHAREPOINTDIAGNOSTICS Operations
		Case 'SendClientScriptErrorReport'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('message', '')
			$oParameters.Add('file', '')
			$oParameters.Add('line', '')
			$oParameters.Add('client', '')
			$oParameters.Add('stack', '')
			$oParameters.Add('team', '')
			$oParameters.Add('originalFile', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		; SITEDATA Operations
		Case 'EnumerateFolder'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('strFolderUrl', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetAttachments'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('strListName', '')
			$oParameters.Add('strItemId', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'SiteDataGetList'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('strListName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
			; Because this operation has a name which duplicates the Lists WS, need to handle
			__SPFixSOAPEnvelope('SiteData', $oOptions.Item('operation'))
		Case 'SiteDataGetListCollection'
			; Because this operation has a name which duplicates the Lists WS, need to handle
			__SPFixSOAPEnvelope('SiteData', $oOptions.Item('operation'))
		Case 'SiteDataGetSite'
			; Because this operation has a name which duplicates the Lists WS, need to handle
			__SPFixSOAPEnvelope('SiteData', $oOptions.Item('operation'))
		Case 'SiteDataGetSiteUrl'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('Url', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
			; Because this operation has a name which duplicates the Lists WS, need to handle
			__SPFixSOAPEnvelope('SiteData', $oOptions.Item('operation'))
		Case 'SiteDataGetWeb'
			; Because this operation has a name which duplicates the Lists WS, need to handle
			__SPFixSOAPEnvelope('SiteData', $oOptions.Item('operation'))
		; SITES Operations
		Case 'CreateWeb'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('urlType', '')
			$oParameters.Add('titleType', '')
			$oParameters.Add('descriptionType', '')
			$oParameters.Add('templateNameType', '')
			$oParameters.Add('languageType', '')
			$oParameters.Add('languageSpecifiedType', '')
			$oParameters.Add('localeType', '')
			$oParameters.Add('localeSpecifiedType', '')
			$oParameters.Add('collationLocaleType', '')
			$oParameters.Add('collationLocaleSpecifiedType', '')
			$oParameters.Add('uniquePermissionsType', '')
			$oParameters.Add('uniquePermissionsSpecifiedType', '')
			$oParameters.Add('anonymousType', '')
			$oParameters.Add('anonymousSpecifiedType', '')
			$oParameters.Add('presenceType', '')
			$oParameters.Add('presenceSpecifiedType', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'DeleteWeb'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('url', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetSite'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('SiteUrl', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetSiteTemplates'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('LCID', '')
			$oParameters.Add('TemplateList', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		; SOCIALDATASERVICE Operations
		Case 'AddComment'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('url', '')
			$oParameters.Add('comment', '')
			$oParameters.Add('isHighPriority', '')
			$oParameters.Add('title', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'AddTag'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('url', '')
			$oParameters.Add('termID', '')
			$oParameters.Add('title', '')
			$oParameters.Add('isPrivate', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'AddTagByKeyword'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('url', '')
			$oParameters.Add('keyword', '')
			$oParameters.Add('title', '')
			$oParameters.Add('isPrivate', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'CountCommentsOfUser'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('userAccountName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'CountCommentsOfUserOnUrl'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('userAccountName', '')
			$oParameters.Add('url', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'CountCommentsOnUrl'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('url', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'CountRatingsOnUrl'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('url', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'CountTagsOfUser'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('userAccountName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'DeleteComment'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('url', '')
			$oParameters.Add('lastModifiedTime', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'DeleteRating'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('url', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'DeleteTag'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('url', '')
			$oParameters.Add('termID', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'DeleteTagByKeyword'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('url', '')
			$oParameters.Add('keyword', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'DeleteTags'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('url', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetAllTagTerms'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('maximumItemsToReturn', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetAllTagTermsForUrlFolder'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('urlFolder', '')
			$oParameters.Add('maximumItemsToReturn', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetAllTagUrls'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('termID', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetAllTagUrlsByKeyword'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('keyword', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetCommentsOfUser'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('userAccountName', '')
			$oParameters.Add('maximumItemsToReturn', '')
			$oParameters.Add('startIndex', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetCommentsOfUserOnUrl'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('userAccountName', '')
			$oParameters.Add('url', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetCommentsOnUrl'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('url', '')
			$oParameters.Add('maximumItemsToReturn', '')
			$oParameters.Add('startIndex', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0

			If True = $oOptions.Exists('excludeItemsTime') And 0 < StringLen($oOptions.Item('excludeItemsTime')) Then
				$SPSOAPEnvelope.Item('payload') = $SPSOAPEnvelope.Item('payload') & __SPWrapNode('excludeItemsTime', $oOptions.Item('excludeItemsTime'))
			EndIf

		Case 'GetRatingAverageOnUrl'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('url', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetRatingOfUserOnUrl'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('userAccountName', '')
			$oParameters.Add('url', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetRatingOnUrl'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('url', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetRatingsOfUser'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('userAccountName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetRatingsOnUrl'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('url', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetSocalDataForFullReplication'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('userAccountName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetTags'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('url', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetTagsOfUser'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('userAccountName', '')
			$oParameters.Add('maximumItemsToReturn', '')
			$oParameters.Add('startIndex', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetTagTerms'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('maximumItemsToReturn', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetTagTermsOfUser'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('userAccountName', '')
			$oParameters.Add('maximumItemsToReturn', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetTagTermsOnUrl'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('url', '')
			$oParameters.Add('maximumItemsToReturn', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetTagUrls'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('termID', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetTagUrlsByKeyword'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('keyword', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetTagUrlsOfUser'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('termID', '')
			$oParameters.Add('userAccountName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetTagUrlsOfUserByKeyword'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('keyword', '')
			$oParameters.Add('userAccountName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'SetRating'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('url', '')
			$oParameters.Add('rating', '')
			$oParameters.Add('title', '')
			$oParameters.Add('analysisDataEntry', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'UpdateComment'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('url', '')
			$oParameters.Add('lastModifiedTime', '')
			$oParameters.Add('comment', '')
			$oParameters.Add('isHighPriority', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		; SPELLCHECK Operations
		Case 'SpellCheck'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('chunksToSpell', '')
			$oParameters.Add('declaredLanguage', '')
			$oParameters.Add('useLad', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		; TAXONOMY Operations
		Case 'AddTerms'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('sharedServiceId', '')
			$oParameters.Add('termSetId', '')
			$oParameters.Add('lcid', '')
			$oParameters.Add('newTerms', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetChildTermsInTerm'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('sspId', '')
			$oParameters.Add('lcid', '')
			$oParameters.Add('termId', '')
			$oParameters.Add('termSetId', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetChildTermsInTermSet'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('sspId', '')
			$oParameters.Add('lcid', '')
			$oParameters.Add('termSetId', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetKeywordTermsByGuids'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('termIds', '')
			$oParameters.Add('lcid', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetTermsByLabel'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('label', '')
			$oParameters.Add('lcid', '')
			$oParameters.Add('matchOption', '')
			$oParameters.Add('resultCollectionSize', '')
			$oParameters.Add('termIds', '')
			$oParameters.Add('addIfNotFound', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetTermSets'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('sharedServiceId', '')
			$oParameters.Add('termSetId', '')
			$oParameters.Add('lcid', '')
			$oParameters.Add('clientTimeStamps', '')
			$oParameters.Add('clientVersions', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		; USER and GROUP Operations
		Case 'AddGroup'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('groupName', '')
			$oParameters.Add('ownerIdentifier', '')
			$oParameters.Add('ownerType', '')
			$oParameters.Add('defaultUserLoginName', '')
			$oParameters.Add('description', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'AddGroupToRole'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('groupName', '')
			$oParameters.Add('roleName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'AddRole'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('roleName', '')
			$oParameters.Add('description', '')
			$oParameters.Add('permissionMask', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'AddRoleDef'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('roleName', '')
			$oParameters.Add('description', '')
			$oParameters.Add('permissionMask', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'AddUserCollectionToGroup'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('groupName', '')
			$oParameters.Add('usersInfoXml', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'AddUserCollectionToRole'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('roleName', '')
			$oParameters.Add('usersInfoXml', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'AddUserToGroup'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('groupName', '')
			$oParameters.Add('userName', '')
			$oParameters.Add('userLoginName', '')
			$oParameters.Add('userEmail', '')
			$oParameters.Add('userNotes', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'AddUserToRole'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('roleName', '')
			$oParameters.Add('userName', '')
			$oParameters.Add('userLoginName', '')
			$oParameters.Add('userEmail', '')
			$oParameters.Add('userNotes', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetAllUserCollectionFromWeb'
		Case 'GetGroupCollection'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('groupNamesXml', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetGroupCollectionFromRole'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('roleName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetGroupCollectionFromSite'
		Case 'GetGroupCollectionFromUser'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('userLoginName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetGroupCollectionFromWeb'
		Case 'GetGroupInfo'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('groupName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetRoleCollection'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('roleNamesXml', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetRoleCollectionFromGroup'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('groupName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetRoleCollectionFromUser'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('userLoginName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetRoleCollectionFromWeb'
		Case 'GetRoleInfo'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('roleName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetRolesAndPermissionsForCurrentUser'
		Case 'GetRolesAndPermissionsForSite'
		Case 'GetUserCollection'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('userLoginNamesXml', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetUserCollectionFromGroup'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('groupName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetUserCollectionFromRole'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('roleName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetUserCollectionFromSite'
		Case 'GetUserCollectionFromWeb'
		Case 'GetUserInfo'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('userLoginName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetUserLoginFromEmail'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('emailXml', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'RemoveGroup'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('groupName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'RemoevGroupFromRole'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('roleName', '')
			$oParameters.Add('groupName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'RemoveRole'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('roleName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'RemoveUserCollectionFromGroup'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('groupName', '')
			$oParameters.Add('userLoginNamesXml', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'RemoveUserCollectionFromRole'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('roleName', '')
			$oParameters.Add('userLoginNamesXml', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'RemoveUserCollectionFromSite'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('userLoginNamesXml', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'RemoveUserFromGroup'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('groupName', 'userLoginName')
			$oParameters.Add('x', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'RemoveUserFromRole'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('roleName', '')
			$oParameters.Add('userLoginName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'RemoveUserFromSite'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('userLoginName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'RemoveUserFromWeb'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('userLoginName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'UpdateGroupInfo'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('oldGroupName', '')
			$oParameters.Add('groupName', '')
			$oParameters.Add('ownerIdentifier', '')
			$oParameters.Add('ownerType', '')
			$oParameters.Add('description', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'UpdateRoleDefInfo'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('oldRoleName', '')
			$oParameters.Add('roleName', '')
			$oParameters.Add('description', '')
			$oParameters.Add('permissionMask', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'UpdateRoleInfo'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('oldRoleName', '')
			$oParameters.Add('roleName', '')
			$oParameters.Add('description', '')
			$oParameters.Add('permissionMask', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'UpdateUserInfo'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('userLoginName', '')
			$oParameters.Add('userName', '')
			$oParameters.Add('userEmail', '')
			$oParameters.Add('userNotes', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		; USERPROFILESERVICE Operations
		Case 'AddColleague'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('accountName', '')
			$oParameters.Add('colleagueAccountName', '')
			$oParameters.Add('group', '')
			$oParameters.Add('privacy', '')
			$oParameters.Add('isInWorkGroup', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'AddLink'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('accountName', '')
			$oParameters.Add('name', '')
			$oParameters.Add('url', '')
			$oParameters.Add('group', '')
			$oParameters.Add('privacy', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'AddMembership'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('accountName', '')
			$oParameters.Add('membershipInfo', '')
			$oParameters.Add('group', '')
			$oParameters.Add('privacy', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'AddPinnedLink'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('accountName', '')
			$oParameters.Add('name', '')
			$oParameters.Add('url', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'CreateMemberGroup'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('membershipInfo', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'CreateUserProfileByAccountName'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('accountName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetCommonColleagues'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('accountName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetCommonManager'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('accountName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetCommonMemberships'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('accountName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetInCommon'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('accountName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetPropertyChoiceList'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('propertyName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetUserColleagues'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('accountName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetUserLinks'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('accountName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetUserMemberships'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('accountName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetUserPinnedLinks'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('accountName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetUserProfileByGuid'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('guid', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetUserProfileByIndex'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('index', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetUserProfileByName'
			; Note that this operation is inconsistent with the others, using AccountName rather than accountName
			If True == $oOptions.Exists('accountName') And 0 < StringLen($oOptions.Item('accountName')) Then
				$oParameters = ObjCreate('Scripting.Dictionary')
				$oParameters.Add('AccountName', 'accountName')
			Else
				$oParameters = ObjCreate('Scripting.Dictionary')
				$oParameters.Add('AccountName', '')
			EndIf

			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetUserProfileCount'
		Case 'GetUserProfileSchema'
		Case 'ModifyUserPropertyByAcountName'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('accountName', '')
			$oParameters.Add('newData', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'RemoveAllColleagues'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('accountName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'RemoveAllLinks'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('accountName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'RemoveAllMemberships'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('accountName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'RemoveAllPinnedLinks'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('accountName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'RemoveColleague'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('accountName', '')
			$oParameters.Add('colleagueAccountName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'RemoveLink'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('accountName', '')
			$oParameters.Add('id', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'RemoveMembership'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('accountName', '')
			$oParameters.Add('sourceInternal', '')
			$oParameters.Add('sourceReference', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'RemovePinnedLink'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('accountName', '')
			$oParameters.Add('id', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'UpdateColleaguePrivacy'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('accountName', '')
			$oParameters.Add('colleagueAccountName', '')
			$oParameters.Add('newPrivacy', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'UpdateLink'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('accountName', '')
			$oParameters.Add('data', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'UpdateMembershipPrivacy'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('accountName', '')
			$oParameters.Add('sourceInternal', '')
			$oParameters.Add('sourceReference', '')
			$oParameters.Add('newPrivacy', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'UpdatePinnedLink'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('accountName', '')
			$oParameters.Add('data', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		; VERSIONS Operations
		Case 'DeleteAllVersions'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('fileName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'DeleteVersion'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('fileName', '')
			$oParameters.Add('fileVersion', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetVersions'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('fileName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'RestoreVersion'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('fileName', '')
			$oParameters.Add('fileVersion', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		; VIEW Operations
		Case 'AddView'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			$oParameters.Add('viewName', '')
			$oParameters.Add('viewFields', '')
			$oParameters.Add('query', '')
			$oParameters.Add('rowLimit', '')
			$oParameters.Add('type', '')
			$oParameters.Add('makeViewDefault', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'DeleteView'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			$oParameters.Add('viewName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetView'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			$oParameters.Add('viewName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetViewCollection'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetViewHtml'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			$oParameters.Add('viewName', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'UpdateView'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			$oParameters.Add('viewName', '')
			$oParameters.Add('viewProperties', '')
			$oParameters.Add('query', '')
			$oParameters.Add('viewFields', '')
			$oParameters.Add('aggregations', '')
			$oParameters.Add('formats', '')
			$oParameters.Add('rowLimit', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'UpdateViewHtml'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('listName', '')
			$oParameters.Add('viewName', '')
			$oParameters.Add('viewProperties', '')
			$oParameters.Add('toolbar', '')
			$oParameters.Add('viewHeader', '')
			$oParameters.Add('viewBody', '')
			$oParameters.Add('viewFooter', '')
			$oParameters.Add('viewEmpty', '')
			$oParameters.Add('rowLimitExceeded', '')
			$oParameters.Add('query', '')
			$oParameters.Add('viewFields', '')
			$oParameters.Add('aggregations', '')
			$oParameters.Add('formats', '')
			$oParameters.Add('rowLimit', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		; WEBPARTPAGES Operations
		Case 'AddWebPart'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('pageUrl', '')
			$oParameters.Add('webPartXml', '')
			$oParameters.Add('storage', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'AddWebPart'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('pageUrl', '')
			$oParameters.Add('webPartXml', '')
			$oParameters.Add('storage', '')
			$oParameters.Add('zoneId', '')
			$oParameters.Add('zoneIndex', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetWebPart2'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('pageUrl', '')
			$oParameters.Add('storageKey', '')
			$oParameters.Add('storage', '')
			$oParameters.Add('behavior', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetWebPartPage'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('documentName', '')
			$oParameters.Add('behavior', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetWebPartProperties'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('pageUrl', '')
			$oParameters.Add('storage', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetWebPartProperties2'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('pageUrl', '')
			$oParameters.Add('storage', '')
			$oParameters.Add('behavior', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		; WEBS Operations
		Case 'WebsCreateContentType'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('displayName', '')
			$oParameters.Add('parentType', '')
			$oParameters.Add('newFields', '')
			$oParameters.Add('contentTypeProperties', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
			; Because this operation has a name which duplicates the Lists WS, need to handle
			__SPFixSOAPEnvelope('Webs', $oOptions.Item('operation'))
		Case 'GetColumns'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('webUrl', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetContentType'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('contentTypeId', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetContentTypes'
		Case 'GetCustomizedPageStatus'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('fileUrl', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetListTemplates'
		Case 'GetObjectIdFromUrl'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('objectUrl', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetWeb'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('webUrl', '')
			$oParameters.Add('webURL', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetWebCollection'
		Case 'GetAllSubWebCollection'
		Case 'UpdateColumns'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('newFields', '')
			$oParameters.Add('updateFields', '')
			$oParameters.Add('deleteFields', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'WebsUpdateContentType'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('contentTypeId', '')
			$oParameters.Add('contentTypeProperties', '')
			$oParameters.Add('newFields', '')
			$oParameters.Add('updateFields', '')
			$oParameters.Add('deleteFields', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
			; Because this operation has a name which duplicates the Lists WS, need to handle
			__SPFixSOAPEnvelope('Webs', $oOptions.Item('operation'))
		Case 'WebUrlFromPageUrl'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('pageUrl', '')
			$oParameters.Add('pageURL', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		; WORKFLOW Operations
		Case 'AlterToDo'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('item', '')
			$oParameters.Add('todoId', '')
			$oParameters.Add('todoListId', '')
			$oParameters.Add('taskData', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetTemplatesForItem'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('item', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetToDosForItem'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('item', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetWorkflowDataForItem'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('item', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'GetWorkflowTaskData'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('item', '')
			$oParameters.Add('listId', '')
			$oParameters.Add('taskId', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		Case 'StartWorkflow'
			$oParameters = ObjCreate('Scripting.Dictionary')
			$oParameters.Add('item', '')
			$oParameters.Add('templateId', '')
			$oParameters.Add('workflowParameters', '')
			__SPAddToPayload($oOptions, $oParameters)
			$oParameters = 0
		;
		Case Else
	EndSwitch

	$sMessage = $SPSOAPEnvelope.Item('header') _
		& $SPSOAPEnvelope.Item('opheader') _
		& $SPSOAPEnvelope.Item('payload') _
		& $SPSOAPEnvelope.Item('opfooter') _
		& $SPSOAPEnvelope.Item('footer')

	$oXMLHTTP = ObjCreate('Msxml2.XMLHTTP')
	$oXMLHTTP.open('Post', $ajaxURL, False)
	$oXMLHTTP.setRequestHeader('Content-Type', 'text/xml; charset=utf-8')
	$oXMLHTTP.setRequestHeader('Accept', 'text/xml; charset=UTF-8')

	If $aOperation[1] Then
		$oXMLHTTP.SetRequestHeader('SOAPAction', $sSOAPAction)
	EndIf

	$oXMLHTTP.send($sMessage)
	$sResult = $oXMLHTTP.responseXML.xml
	$oXMLHTTP = 0

	If '' <> $oOptions.Item('completefunc') Then
		Return Call($oOptions.Item('completefunc'), $sResult)
	Else
		Return True
	EndIf

EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _SPGetCurrentUser
; Description ...: Function which returns the account name for the current user in DOMAIN\username format
; Syntax ........: _SPGetCurrentUser($oOptions)
; Parameters ....: $oOptions            - Scripting.Dictionary Object, which controls the usage
; Return values .: String - The requested info
; Author ........: Joerg Schoppet
; Modified ......:
; Remarks .......:
; ===============================================================================================================================
Func _SPGetCurrentUser($oOptions)
	Local $oDefaults
	Local $thisTextValue
	Local $ajaxURL
	Local $oXMLHTTP
	Local $sResult
	Local $aResult
	Local $sField

	$oDefaults = ObjCreate('Scripting.Dictionary')
	$oDefaults.Add('webURL', '')
	$oDefaults.Add('fieldName', 'Name')
	$oOptions = __SPMergeOptions($oOptions, $oDefaults)
	$thisTextValue = 'FieldInternalName="' & $oOptions.Item('fieldName') & '"\s.*?FieldType="(\w.*?)"\s.*?-->(.*?)</td>'
	; build the url for the ajax call
	$ajaxURL = '_layouts/userdisp.aspx?Force=True&' & @YDAY & @MON & @MDAY & @HOUR & @MIN & @SEC & @MSEC

	If $SPSLASH == StringRight($oOptions.Item('webURL'), 1) Then
		$ajaxURL = $oOptions.Item('webURL') & $ajaxURL
	Else
		$ajaxURL = $oOptions.Item('webURL') & $SPSLASH & $ajaxURL
	EndIf

	$oXMLHTTP = ObjCreate('MSXML2.XMLHTTP.6.0')
	$oXMLHTTP.open('Get', $ajaxURL, False)

	$oXMLHTTP.send()
	$sResult = $oXMLHTTP.responseText
	$oXMLHTTP = 0
	$sResult = StringStripCR(StringReplace(StringReplace($sResult, @CRLF, ''), @TAB, ''))

	If 'ID' == $oOptions.Item('fieldName') Then
		$aResult = StringRegExp($sResult, '_spUserId=(\d.*?);', 2)
		Return $aResult[1]
	EndIf

	$aResult = StringRegExp($sResult, $thisTextValue, 2)

	If 0 <> @error Then
		Return ''
	EndIf

	$sField = $aResult[2]

	Do

		If 0 <> StringInStr($sField, '<') Then
			$sField = StringRegExpReplace($sField, '<.*?>(.*?)</.*?>', '$1')
		Else
			ExitLoop
		EndIf

	Until False

	; Not needed yet
	Switch ($aResult[1])
		Case 'SPFieldText'
		Case 'SPFieldNote'
		Case 'SPFieldURL'
		Case Else
	EndSwitch

	Return $sField
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _SPUpdateMultipleListItems
; Description ...: Allows you to update multiple items in a list based upon some common characteristics or metadata criteria
; Syntax ........: _SPUpdateMultipleListItems($oOptions)
; Parameters ....: $oOptions            - Scripting.Dictionary Object, which controls the usage
; Return values .: See _SPServices
; Author ........: Joerg Schoppet
; Modified ......:
; Remarks .......:
; ===============================================================================================================================
Func _SPUpdateMultipleListItems($oOptions)
	Local $oDefaults
	Local $oListOptions
	Local $oUpdateItems
	Local $batch
	Local $aItems
	Local $aDocuments

	$oDefaults = ObjCreate('Scripting.Dictionary')
	$oDefaults.Add('webURL', '')
	$oDefaults.Add('listName', '')
	$oDefaults.Add('CAMLQuery', '')
	$oDefaults.Add('batchCmd', 'Update')
	$oDefaults.Add('valuepairs', ObjCreate('Scripting.Dictionary'))
	$oOptions = __SPMergeOptions($oOptions, $oDefaults)

	$oListOptions = ObjCreate('Scripting.Dictionary')
	$oListOptions.Add('webURL', $oOptions.Item('webURL'))
	$oListOptions.Add('listName', $oOptions.Item('listName'))
	$oListOptions.Add('CAMLQuery', $oOptions.Item('CAMLQuery'))
	$oListOptions.Add('CAMLQueryOptions', '<QueryOptions><ViewAttributes Scope="Recursive" /></QueryOptions>')
	$oListOptions.Add('operation', 'GetListItems')
	$oListOptions.Add('completefunc', '__SPGetUpdateItems')
	$oUpdateItems = _SPServices($oListOptions)

	$batch = "<Batch OnError='Continue'>"
	$aItems = $oUpdateItems.Item('itemsToUpdate')
	$aDocuments = $oUpdateItems.Item('documentsToUpdate')

	For $i = 1 To $aItems[0]
		$batch &= "<Method ID='" & $i & "' Cmd='" & $oOptions.Item('batchCmd') & "'>"

		For $sField In $oOptions.Item('valuepairs')
			$batch &= "<Field Name='" & $sField & "'>" & __SPEscapeColumnValue($oOptions.Item('valuepairs').Item($sField)) & "</Field>"
		Next

		$batch &= "<Field Name='ID'>" & $aItems[$i] & "</Field>"

		If 0 < $aDocuments[0] Then
			$batch &= "<Field Name='FileRef'>" & $aDocuments[$i] & "</Field>"
		EndIf

		$batch &= "</Method>"
	Next

	$oUpdateItems = ObjCreate('Scripting.Dictionary')
	$oUpdateItems.Add('operation', 'UpdateListItems')
	$oUpdateItems.Add('webURL', $oOptions.Item('webURL'))
	$oUpdateItems.Add('listName', $oOptions.Item('listName'))
	$oUpdateItems.Add('updates', $batch)

	If True == $oOptions.Exists('completefunc') Then
		$oUpdateItems.Add('completefunc', $oOptions.Item('completefunc'))
	EndIf

	Return _SPServices($oUpdateItems)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _SPAddMultipleListItems
; Description ...: Allows you to create multiple items in a list, each with different settings
; Syntax ........: _SPAddMultipleListItems($oOptions)
; Parameters ....: $oOptions            - Scripting.Dictionary Object, which controls the usage
; Return values .: See _SPServices
; Author ........: Joerg Schoppet
; Modified ......:
; Remarks .......:
; ===============================================================================================================================
Func _SPAddMultipleListItems($oOptions)
	Local $oDefaults
	Local $batch

	$oDefaults = ObjCreate('Scripting.Dictionary')
	$oDefaults.Add('webURL', '')
	$oDefaults.Add('listName', '')
	$oDefaults.Add('batchCmd', 'New')
	$oDefaults.Add('valuepairs', ObjCreate('Scripting.Dictionary'))
	$oDefaults.Add('operation', 'UpdateListItems')
	$oOptions = __SPMergeOptions($oOptions, $oDefaults)

	$batch = "<Batch OnError='Continue'>"

	For $i In $oOptions.Item('valuepairs')
		$batch &= "<Method ID='" & $i & "' Cmd='" & $oOptions.Item('batchCmd') & "'>"

		For $sField In $oOptions.Item('valuepairs').Item($i)
			$batch &= "<Field Name='" & $sField & "'>" & __SPEscapeColumnValue($oOptions.Item('valuepairs').Item($i).Item($sField)) & "</Field>"
		Next

		$batch &= '</Method>'
	Next

	$batch &= '</Batch>'
	$oOptions.Add('updates', $batch)

	Return _SPServices($oOptions)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _SPGetLastItemId
; Description ...: Function to return the ID of the last item created on a list by a specific user. Useful for maintaining parent/child relationships
; Syntax ........: _SPGetLastItemId($oOptions)
; Parameters ....: $oOptions            - Scripting.Dictionary Object, which controls the usage
; Return values .: Returns the last ID or 0
; Author ........: Joerg Schoppet
; Modified ......:
; Remarks .......:
; ===============================================================================================================================
Func _SPGetLastItemId($oOptions)
	Local $oDefaults
	Local $oUserOptions
	Local $oListOptions
	Local $userId = 0
	Local $lastId = 0
	Local $camlQuery

	$oDefaults = ObjCreate('Scripting.Dictionary')
	$oDefaults.Add('webURL', '')
	$oDefaults.Add('listName', '')
	$oDefaults.Add('userAccount', '')
	$oDefaults.Add('CAMLQuery', '')
	$oOptions = __SPMergeOptions($oOptions, $oDefaults)

	$oUserOptions = ObjCreate('Scripting.Dictionary')
	$oUserOptions.Add('webURL', $oOptions.Item('webURL'))

	If '' == $oOptions.Item('userAccount') Then
		; no user-account supplied, so take the current user
		$oUserOptions.Add('fieldName', 'ID')
		$userId = _SPGetCurrentUser($oUserOptions)
	Else
		$oUserOptions.Add('operation', 'GetUserInfo')
		$oUserOptions.Add('userLoginName', $oOptions.Item('userAccount'))
		$oUserOptions.Add('completefunc', '__SPGetUserID')
		$userId = _SPServices($oUserOptions)
	EndIf

	If 0 == $userId Then
		Return 0
	EndIf

	$camlQuery = '<Query><Where>'

	If 0 < StringLen($oOptions.Item('CAMLQuery')) Then
		$camlQuery &= '<And>'
	EndIf

	$camlQuery &= "<Eq><FieldRef Name='Author' LookupId='TRUE'/><Value Type='Integer'>" & $userId & "</Value></Eq>"

	If 0 < StringLen($oOptions.Item('CAMLQuery')) Then
		$camlQuery &= '</And>'
	EndIf

	$camlQuery &= "</Where><OrderBy><FieldRef Name='Created_x0020_Date' Ascending='FALSE'/></OrderBy></Query>"
	$oListOptions = ObjCreate('Scripting.Dictionary')
	$oListOptions.Add('webURL', $oOptions.Item('webURL'))
	$oListOptions.Add('operation', 'GetListItems')
	$oListOptions.Add('listName', $oOptions.Item('listName'))
	$oListOptions.Add('CAMLQuery', $camlQuery)
	$oListOptions.Add('CAMLViewFields', "<ViewFields><FieldRef Name='ID'/></ViewFields>")
	$oListOptions.Add('CAMLRowLimit', 1)
	$oListOptions.Add('CAMLQueryOptions', "<QueryOptions><ViewAttributes Scope='Recursive' /></QueryOptions>")
	$oListOptions.Add('completefunc', '__SPGetItemID')
	$lastId = _SPServices($oListOptions)
	Return $lastId
EndFunc

; helper functions

; #FUNCTION# ====================================================================================================================
; Name ..........: _SPTransformOutput
; Description ...: Helper-Function, which transforms a namespaced xml-string to an "easy" xml-string for e.g. _XMLDOMWRAPPER.au3
; Syntax ........: _SPTransformOutput($sResult)
; Parameters ....: $sResult             - A string value.
; Return values .: String
; Author ........: Joerg Schoppet
; Modified ......:
; Remarks .......:
; ===============================================================================================================================
Func _SPTransformOutput($sResult)
	$sResult = StringRegExpReplace($sResult, '(<|</)(soap:Fault)(>)', '$1Fault$3')
	$sResult = StringRegExpReplace($sResult, '<soap:.*?>|</soap:.*?>', '')
	$sResult = StringRegExpReplace($sResult, '(<.*?)\s(xmlns.*?)>', '$1>')
;	$sResult = StringRegExpReplace($sResult, '(<|</).*?(Response|Result)>', '')
	$sResult = StringRegExpReplace($sResult, '(<|</)(rs:data)', '$1data')
	$sResult = StringRegExpReplace($sResult, '(<|</)(z:row)', '$1row')
	Return $sResult
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _SPDecodeName
; Description ...: Helper-Function, which removes/replaces the Sharepoint-specifics from an attribute-/field-name
; Syntax ........: _SPDecodeName($sName)
; Parameters ....: $sName                - A string value.
; Return values .: String
; Author ........: Joerg Schoppet
; Modified ......:
; Remarks .......:
; ===============================================================================================================================
Func _SPDecodeName($sName)
	; Remove ows_ from the start
	$sName = StringMid($sName, 5)
	; Replace _x0020_ with space
	$sName = StringReplace($sName, "_x0020_", " ")
	; Replace _x002d_ with -
	$sName = StringReplace($sName, "_x002d_", "-")
	; Replace _x003a_ with :
	$sName = StringReplace($sName, "_x003a_", ":")
	Return $sName
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _SPEncodeName
; Description ...: Helper-Function, which addes the Sharepoint-specifics to a name
; Syntax ........: _SPEncodeName($sName)
; Parameters ....: $sName                - A string value.
; Return values .: String
; Author ........: Joerg Schoppet
; Modified ......:
; Remarks .......:
; ===============================================================================================================================
Func _SPEncodeName($sName)
	; Replace space with _x0020_
	$sName = StringReplace($sName, " ", "_x0020_")
	; Replace - with _x002d_
	$sName = StringReplace($sName, "-", "_x002d_")
	; Replace : with _x003a_
	$sName = StringReplace($sName, ":", "_x003a_")
	Return $sName
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _SPFormatField
; Description ...: Helper-Function, which returns only the wanted info from some specific Sharepoint-fields
; Syntax ........: _SPFormatField($value, $format)
; Parameters ....: $value               - The original value
;                  $format              - Info, what kind of Sharepoint-field it is
; Return values .: Formated Value
; Author ........: Joerg Schoppet
; Modified ......:
; Remarks .......:
; ===============================================================================================================================
Func _SPFormatField($value, $format)
	Local $aTemp

	Switch $format
		Case "person"
			Return StringMid($value, StringInStr($value, '#')+1)
		Case "number"
			Return StringMid($value, 1, StringInStr($value, '.')-1)
		Case "lookup"
			Return StringMid($value, StringInStr($value, '#')+1)
		Case "date"
			$aTemp = StringSplit($value, " ")
			Return $aTemp[1]
		Case "percent"
			Return Int($value*100)
	EndSwitch

EndFunc

; internal functions

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __SPGetUpdateItems
; Description ...: Internal function used by _SPUpdateMultipleListItems
; Syntax ........: __SPGetUpdateItems($sOrig)
; Parameters ....: $sOrig               - A string value.
; Return values .: Scripting.Dictionary object
; Author ........: Joerg Schoppet
; Modified ......:
; Remarks .......:
; ===============================================================================================================================
Func __SPGetUpdateItems($sOrig)
	Local $iCount
	Local $oResult
	Local $aItems[1]
	Local $aDocuments[1]
	Local $iID
	Local $sFileRef

	$sOrig = _SPTransformOutput($sOrig)
	_XMLLoadXML($sOrig)
	$iCount = _XMLGetAttrib('/GetListItemsResponse/GetListItemsResult/listitems/data', 'ItemCount')
	$oResult = ObjCreate('Scripting.Dictionary')
	$oResult.Add('itemsToUpdate', 0)
	$oResult.Add('documentsToUpdate', 0)
	$aItems[0] = 0
	$aDocuments[0] = 0

	For $i = 1 To $iCount
		$iID = _XMLGetAttrib('/GetListItemsResponse/GetListItemsResult/listitems/data/row[' & $i & ']', 'ows_ID')
		$sFileRef = _XMLGetAttrib('/GetListItemsResponse/GetListItemsResult/listitems/data/row[' & $i & ']', 'ows_FileRef')
		$sFileRef = '/' & StringMid($sFileRef, StringInStr($sFileRef, ';#')+2)
		_ArrayAdd($aItems, $iID)
		$aItems[0] += 1
		_ArrayAdd($aDocuments, $sFileRef)
		$aDocuments[0] += 1
	Next

	$oResult.Item('itemsToUpdate') = $aItems
	$oResult.Item('documentsToUpdate') = $aDocuments
	Return $oResult
EndFunc

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __SPGetUserID
; Description ...: Internal function used by _SPGetLastItemId
; Syntax ........: __SPGetUserID($sOrig)
; Parameters ....: $sOrig               - A string value.
; Return values .: String
; Author ........: Joerg Schoppet
; Modified ......:
; Remarks .......:
; ===============================================================================================================================
Func __SPGetUserID($sOrig)
	$sOrig = _SPTransformOutput($sOrig)
	_XMLLoadXML($sOrig)
	Return _XMLGetAttrib('/GetUserInfoResponse/GetUserInfoResult/GetUserInfo/User', 'ID')
EndFunc

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __SPGetItemID
; Description ...: Internal function used by _SPGetLastItemId
; Syntax ........: __SPGetItemID($sOrig)
; Parameters ....: $sOrig               - A string value.
; Return values .: String
; Author ........: Joerg Schoppet
; Modified ......:
; Remarks .......:
; ===============================================================================================================================
Func __SPGetItemID($sOrig)
	$sOrig = _SPTransformOutput($sOrig)
	_XMLLoadXML($sOrig)
	Return _XMLGetAttrib('/GetListItemsResponse/GetListItemsResult/listitems/data/row', 'ows_ID')
EndFunc

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __SPGetDefaults
; Description ...: Internal function for defining some basic defaults for the $oOptions-variable
; Syntax ........: __SPGetDefaults()
; Parameters ....:
; Return values .: Scripting.Dictionary object
; Author ........: Joerg Schoppet
; Modified ......:
; Remarks .......:
; ===============================================================================================================================
Func __SPGetDefaults()
	Local $oDefaults = ObjCreate('Scripting.Dictionary')

	; the web service operations
	$oDefaults.Add('operation', '')
	; url of the target web
	$oDefaults.Add('webURL', '')
	; true to make the view the defaults view for the list
	$oDefaults.Add('makeViewDefaults', '')
	; view name in CAML format
	$oDefaults.Add('CAMLViewName', '')
	; query in CAML format
	$oDefaults.Add('CAMLQuery', '')
	; view fields in CAML format
	$oDefaults.Add('CAMLViewFields', '')
	; row limit as a string representation of an integer
	$oDefaults.Add('CAMLRowLimit', 0)
	; query options in CAML format
	$oDefaults.Add('CAMLQueryOptions', '<QueryOptions></QueryOptions>')
	; method cmd for UpdateListItems
	$oDefaults.Add('batchCmd', 'Update')
	; Fieldname / Fieldvalue pairs for UpdateListItems
	$oDefaults.Add('valuepairs', ObjCreate('Scripting.Dictionary'))
	; Array of destination URLs for copy operations
	$oDefaults.Add('DestinationUrls', ObjCreate('Scripting.Dictionary'))
	; An SPWebServiceBehavior indicating wether the client supports Windows SharePoint Services 2.0 or Windows SharePoint Services 3.0: {Verrsion2 | Version3}
	$oDefaults.Add('behavior', 'Version3')
	; A Storage value indicating how the WebPart is stored: {None | Personal | Shared}
	$oDefaults.Add('storage', 'Shared')
	; objectType for operations which require it
	$oDefaults.Add('objectType', 'List')
	; true to delete a meeting; false to remove its association with a Meeting Workspace site
	$oDefaults.Add('cancelMeeting', True)
	; true if the calendar is set to a format other than Gregorian;otherwise, false
	$oDefaults.Add('nonGregorian', False)
	; Specifies if the action is a claim or a release. Specifies true for a claim and false for a release.
	$oDefaults.Add('fClaim', False)
	; The recurrence ID for the meeting that needs its association removed. This parameter can be set to 0 for single-instance meetings.
	$oDefaults.Add('recurrenceId', 0)
	; An integer that is used to determine the ordering of updates in case they arrive out of sequence. Updates with a lower-than-current sequence are discarded. If the dequence is equal to the current sequence, the latest update are applied.
	$oDefaults.Add('sequence', 0)
	; SocialDataService maximumItemsToReturn
	$oDefaults.Add('maximumItemsToReturn', 0)
	; SocialDataService startIndex
	$oDefaults.Add('startIndex', 0)
	; SocialDataService isHighPriority
	$oDefaults.Add('isHighPriority', False)
	; SocialDataService isPrivate
	$oDefaults.Add('isPrivate', False)
	; SocialDataService rating
	$oDefaults.Add('rating', 1)
	; unless otherwiese specified, the maximum number of principals that can be returned from a provider is 10
	$oDefaults.Add('maxResults', 10)
	; specifies user scope and other information: [None | User | DistributionList | SecurityGroup | SharePointGroup | All]
	$oDefaults.Add('principalType', 'User')
	; function to call on completion
	$oDefaults.Add('completefunc', '')
	Return $oDefaults
EndFunc

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __SPAddToPayload
; Description ...: Internal function used by _SPServices to build the SOAP-Request
; Syntax ........: __SPAddToPayload($oOptions, $oParameters)
; Parameters ....: $oOptions            - Scripting.Dictionary
;                  $oParameters         - Scripting.Dictionary
; Return values .: None
; Author ........: Joerg Schoppet
; Modified ......:
; Remarks .......:
; ===============================================================================================================================
Func __SPAddToPayload($oOptions, $oParameters)

	For $sKey In $oParameters

		If '' == $oParameters.Item($sKey) Then
			$SPSOAPEnvelope.Item('payload') = $SPSOAPEnvelope.Item('payload') & __SPWrapNode($sKey, $oOptions.Item($sKey))
		Else
			$SPSOAPEnvelope.Item('payload') = $SPSOAPEnvelope.Item('payload') & __SPWrapNode($sKey, $oOptions.Item($oParameters.Item($sKey)))
		EndIf

	Next

EndFunc

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __SPWrapNode
; Description ...: Internal function which wraps an XML node (sNode) around a value (sValu)
; Syntax ........: __SPWrapNode($sNode, $sValue)
; Parameters ....: $sNode               - A string value.
;                  $sValue              - A string value.
; Return values .: String
; Author ........: Joerg Schoppet
; Modified ......:
; Remarks .......:
; ===============================================================================================================================
Func __SPWrapNode($sNode, $sValue)
	Return '<' & $sNode & '>' & $sValue & '</' & $sNode & '>'
EndFunc

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __SPMergeOptions
; Description ...: Internal function which merges the self-defined $oOptions-variable with the default-variables
; Syntax ........: __SPMergeOptions($oOptions[, $oDefaults = ''])
; Parameters ....: $oOptions            - Scripting.Dictionary
;                  $oDefaults           - [optional] Scripting.Dictionary - Default is ''
; Return values .: Scripting.Dictionary object
; Author ........: Joerg Schoppet
; Modified ......:
; Remarks .......:
; ===============================================================================================================================
Func __SPMergeOptions($oOptions, $oDefaults='')

	If '' == $oDefaults Then
		$oDefaults = __SPGetDefaults()
	EndIf

	For $sKey In $oOptions

		If True == $oDefaults.Exists($sKey) Then

			If IsObj($oDefaults.Item($sKey)) Then
				$oDefaults.Remove($sKey)
				$oDefaults.Add($sKey, $oOptions.Item($sKey))
			Else
				$oDefaults.Item($sKey) = $oOptions.Item($sKey)
			EndIf

		Else
			$oDefaults.Add($sKey, $oOptions.Item($sKey))
		EndIf

	Next

	Return $oDefaults
EndFunc

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __SPEscapeColumnValue
; Description ...: Internal function which escapes special values
; Syntax ........: __SPEscapeColumnValue($s)
; Parameters ....: $s                   - A string value.
; Return values .: String
; Author ........: Joerg Schoppet
; Modified ......:
; Remarks .......:
; ===============================================================================================================================
Func __SPEscapeColumnValue($s)

	If IsString($s) Then
		Return StringRegExpReplace($s, "&(?![a-zA-Z]{1,8};)", '&amp;')
	Else
		Return $s
	EndIf

EndFunc

; Escape string characters
; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __SPEscapeHTML
; Description ...: Internal function which escapes the main HTML chars
; Syntax ........: __SPEscapeHTML($s)
; Parameters ....: $s                   - A string value.
; Return values .: String
; Author ........: Joerg Schoppet
; Modified ......:
; Remarks .......:
; ===============================================================================================================================
Func __SPEscapeHTML($s)
	Return StringReplace(StringReplace(StringReplace(StringReplace($s, "&", "&amp;"), '"', "&quot;"), "<", "&lt;"), ">", "&gt;")
EndFunc

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __SPFixSOAPEnvelope
; Description ...: Internal function used by _SPServices
;                  The SiteData and Webs operations have the same names as other Web Service operations. To make them easy to
;                  call and unique, I'm using the SiteData or Webs prefix on their names. This function replaces that name with
;                  the right name in the SOAPEnvelope
; Syntax ........: __SPFixSOAPEnvelope($sService, $sOperation)
; Parameters ....: $sService            - A string value.
;                  $sOperation          - A string value.
; Return values .: None
; Author ........: Joerg Schoppet
; Modified ......:
; Remarks .......:
; ===============================================================================================================================
Func __SPFixSOAPEnvelope($sService, $sOperation)
	Local $iLength
	Local $sCorrectOperation

	$iLength = StringLen($sService)
	$sCorrectOperation = StringMid($sOperation, $iLength)
	$SPSOAPEnvelope.Item('opheader') = StringReplace($SPSOAPEnvelope.Item('opheader'), $sOperation, $sCorrectOperation)
	$SPSOAPEnvelope.Item('opfooter') = StringReplace($SPSOAPEnvelope.Item('opfooter'), $sOperation, $sCorrectOperation)
EndFunc
