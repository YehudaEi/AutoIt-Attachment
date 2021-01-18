#include-once
; ------------------------------------------------------------------------------
;
; Author:					Pete Witt
; AutoIt Version: 3.0
; Language:       English
; Description:    Returns error message based on the return code of the Microsoft Windows Installer (Msiexec.exe) process.
; 								Source - Microsoft Article http://support.microsoft.com/kb/304888; February 8, 2007; Revision 3.3
;
; ------------------------------------------------------------------------------
Func _MSICodeMsg($Code, $Info = 1)
	;
	; $Code = the error code number returned by the MSI process.
	;
	; $Info = 1 for 'ERROR_CODE' text only. [Default]
	; $Info = 2 for 'Description' text only.
	; $Info = 3 for 'ERROR_CODE: Description' text.
	;
	Local $temp1, $temp2
	
	Switch $Code
		Case 0
			If BitAND($Info, 1) Then $temp1 = "ERROR_SUCCESS"
			If BitAND($Info, 2) Then $temp2 = "Action completed successfully."
		Case 13
			If BitAND($Info, 1) Then $temp1 = "ERROR_INVALID_DATA"
			If BitAND($Info, 2) Then $temp2 = "The data is invalid."
		Case 87
			If BitAND($Info, 1) Then $temp1 = "ERROR_INVALID_PARAMETER"
			If BitAND($Info, 2) Then $temp2 = "One of the parameters was invalid."
		Case 1601
			If BitAND($Info, 1) Then $temp1 = "ERROR_INSTALL_SERVICE_FAILURE"
			If BitAND($Info, 2) Then $temp2 = "The Windows Installer service could not be accessed. Contact your support personnel to verify that the Windows Installer service is properly registered."
		Case 1602
			If BitAND($Info, 1) Then $temp1 = "ERROR_INSTALL_USEREXIT"
			If BitAND($Info, 2) Then $temp2 = "User cancel installation."
		Case 1603
			If BitAND($Info, 1) Then $temp1 = "ERROR_INSTALL_FAILURE"
			If BitAND($Info, 2) Then $temp2 = "Fatal error during installation."
		Case 1604
			If BitAND($Info, 1) Then $temp1 = "ERROR_INSTALL_SUSPEND"
			If BitAND($Info, 2) Then $temp2 = "Installation suspended, incomplete."
		Case 1605
			If BitAND($Info, 1) Then $temp1 = "ERROR_UNKNOWN_PRODUCT"
			If BitAND($Info, 2) Then $temp2 = "This action is only valid for products that are currently installed."
		Case 1606
			If BitAND($Info, 1) Then $temp1 = "ERROR_UNKNOWN_FEATURE"
			If BitAND($Info, 2) Then $temp2 = "Feature ID not registered."
		Case 1607
			If BitAND($Info, 1) Then $temp1 = "ERROR_UNKNOWN_COMPONENT"
			If BitAND($Info, 2) Then $temp2 = "Component ID not registered."
		Case 1608
			If BitAND($Info, 1) Then $temp1 = "ERROR_UNKNOWN_PROPERTY"
			If BitAND($Info, 2) Then $temp2 = "Unknown property."
		Case 1609
			If BitAND($Info, 1) Then $temp1 = "ERROR_INVALID_HANDLE_STATE"
			If BitAND($Info, 2) Then $temp2 = "Handle is in an invalid state."
		Case 1610
			If BitAND($Info, 1) Then $temp1 = "ERROR_BAD_CONFIGURATION"
			If BitAND($Info, 2) Then $temp2 = "The configuration data for this product is corrupted. Contact your support personnel."
		Case 1611
			If BitAND($Info, 1) Then $temp1 = "ERROR_INDEX_ABSENT"
			If BitAND($Info, 2) Then $temp2 = "Component qualifier not present."
		Case 1612
			If BitAND($Info, 1) Then $temp1 = "ERROR_INSTALL_SOURCE_ABSENT"
			If BitAND($Info, 2) Then $temp2 = "The installation source for this product is not available. Verify that the source exists and that you can access it."
		Case 1613
			If BitAND($Info, 1) Then $temp1 = "ERROR_INSTALL_PACKAGE_VERSION"
			If BitAND($Info, 2) Then $temp2 = "This installation package cannot be installed by the Windows Installer service. You must install a Windows service pack that contains a newer version of the Windows Installer service."
		Case 1614
			If BitAND($Info, 1) Then $temp1 = "ERROR_PRODUCT_UNINSTALLED"
			If BitAND($Info, 2) Then $temp2 = "Product is uninstalled."
		Case 1615
			If BitAND($Info, 1) Then $temp1 = "ERROR_BAD_QUERY_SYNTAX"
			If BitAND($Info, 2) Then $temp2 = "SQL query syntax invalid or unsupported."
		Case 1616
			If BitAND($Info, 1) Then $temp1 = "ERROR_INVALID_FIELD"
			If BitAND($Info, 2) Then $temp2 = "Record field does not exist."
		Case 1618
			If BitAND($Info, 1) Then $temp1 = "ERROR_INSTALL_ALREADY_RUNNING"
			If BitAND($Info, 2) Then $temp2 = "Another installation is already in progress. Complete that installation before proceeding with this install."
		Case 1619
			If BitAND($Info, 1) Then $temp1 = "ERROR_INSTALL_PACKAGE_OPEN_FAILED"
			If BitAND($Info, 2) Then $temp2 = "This installation package could not be opened. Verify that the package exists and that you can access it, or contact the application vendor to verify that this is a valid Windows Installer package."
		Case 1620
			If BitAND($Info, 1) Then $temp1 = "ERROR_INSTALL_PACKAGE_INVALID"
			If BitAND($Info, 2) Then $temp2 = "This installation package could not be opened. Contact the application vendor to verify that this is a valid Windows Installer package."
		Case 1621
			If BitAND($Info, 1) Then $temp1 = "ERROR_INSTALL_UI_FAILURE"
			If BitAND($Info, 2) Then $temp2 = "There was an error starting the Windows Installer service user interface. Contact your support personnel."
		Case 1622
			If BitAND($Info, 1) Then $temp1 = "ERROR_INSTALL_LOG_FAILURE"
			If BitAND($Info, 2) Then $temp2 = "Error opening installation log file. Verify that the specified log file location exists and is writable."
		Case 1623
			If BitAND($Info, 1) Then $temp1 = "ERROR_INSTALL_LANGUAGE_UNSUPPORTED"
			If BitAND($Info, 2) Then $temp2 = "This language of this installation package is not supported by your system."
		Case 1624
			If BitAND($Info, 1) Then $temp1 = "ERROR_INSTALL_TRANSFORM_FAILURE"
			If BitAND($Info, 2) Then $temp2 = "Error applying transforms. Verify that the specified transform paths are valid."
		Case 1625
			If BitAND($Info, 1) Then $temp1 = "ERROR_INSTALL_PACKAGE_REJECTED"
			If BitAND($Info, 2) Then $temp2 = "This installation is forbidden by system policy. Contact your system administrator."
		Case 1626
			If BitAND($Info, 1) Then $temp1 = "ERROR_FUNCTION_NOT_CALLED"
			If BitAND($Info, 2) Then $temp2 = "Function could not be executed."
		Case 1627
			If BitAND($Info, 1) Then $temp1 = "ERROR_FUNCTION_FAILED"
			If BitAND($Info, 2) Then $temp2 = "Function failed during execution."
		Case 1628
			If BitAND($Info, 1) Then $temp1 = "ERROR_INVALID_TABLE"
			If BitAND($Info, 2) Then $temp2 = "Invalid or unknown table specified."
		Case 1629
			If BitAND($Info, 1) Then $temp1 = "ERROR_DATATYPE_MISMATCH"
			If BitAND($Info, 2) Then $temp2 = "Data supplied is of wrong type."
		Case 1630
			If BitAND($Info, 1) Then $temp1 = "ERROR_UNSUPPORTED_TYPE"
			If BitAND($Info, 2) Then $temp2 = "Data of this type is not supported."
		Case 1631
			If BitAND($Info, 1) Then $temp1 = "ERROR_CREATE_FAILED"
			If BitAND($Info, 2) Then $temp2 = "The Windows Installer service failed to start. Contact your support personnel."
		Case 1632
			If BitAND($Info, 1) Then $temp1 = "ERROR_INSTALL_TEMP_UNWRITABLE"
			If BitAND($Info, 2) Then $temp2 = "The temp folder is either full or inaccessible. Verify that the temp folder exists and that you can write to it."
		Case 1633
			If BitAND($Info, 1) Then $temp1 = "ERROR_INSTALL_PLATFORM_UNSUPPORTED"
			If BitAND($Info, 2) Then $temp2 = "This installation package is not supported on this platform. Contact your application vendor."
		Case 1634
			If BitAND($Info, 1) Then $temp1 = "ERROR_INSTALL_NOTUSED"
			If BitAND($Info, 2) Then $temp2 = "Component not used on this computer."
		Case 1635
			If BitAND($Info, 1) Then $temp1 = "ERROR_PATCH_PACKAGE_OPEN_FAILED"
			If BitAND($Info, 2) Then $temp2 = "This patch package could not be opened. Verify that the patch package exists and that you can access it, or contact the application vendor to verify that this is a valid Windows Installer patch package."
		Case 1636
			If BitAND($Info, 1) Then $temp1 = "ERROR_PATCH_PACKAGE_INVALID"
			If BitAND($Info, 2) Then $temp2 = "This patch package could not be opened. Contact the application vendor to verify that this is a valid Windows Installer patch package."
		Case 1637
			If BitAND($Info, 1) Then $temp1 = "ERROR_PATCH_PACKAGE_UNSUPPORTED"
			If BitAND($Info, 2) Then $temp2 = "This patch package cannot be processed by the Windows Installer service. You must install a Windows service pack that contains a newer version of the Windows Installer service."
		Case 1638
			If BitAND($Info, 1) Then $temp1 = "ERROR_PRODUCT_VERSION"
			If BitAND($Info, 2) Then $temp2 = "Another version of this product is already installed. Installation of this version cannot continue. To configure or remove the existing version of this product, use Add/Remove Programs in Control Panel."
		Case 1639
			If BitAND($Info, 1) Then $temp1 = "ERROR_INVALID_COMMAND_LINE"
			If BitAND($Info, 2) Then $temp2 = "Invalid command line argument. Consult the Windows Installer SDK for detailed command line help."
		Case 1640
			If BitAND($Info, 1) Then $temp1 = "ERROR_INSTALL_REMOTE_DISALLOWED"
			If BitAND($Info, 2) Then $temp2 = "Installation from a Terminal Server client session not permitted for current user."
		Case 1641
			If BitAND($Info, 1) Then $temp1 = "ERROR_SUCCESS_REBOOT_INITIATED"
			If BitAND($Info, 2) Then $temp2 = "The installer has started a reboot. This error code not available on Windows Installer version 1.0."
		Case 1642
			If BitAND($Info, 1) Then $temp1 = "ERROR_PATCH_TARGET_NOT_FOUND"
			If BitAND($Info, 2) Then $temp2 = "The installer cannot install the upgrade patch because the program being upgraded may be missing, or the upgrade patch updates a different version of the program. Verify that the program to be upgraded exists on your computer and that you have the correct upgrade patch. This error code is not available on Windows Installer version 1.0."
		Case 3010
			If BitAND($Info, 1) Then $temp1 = "ERROR_SUCCESS_REBOOT_REQUIRED"
			If BitAND($Info, 2) Then $temp2 = "A restart is required to complete the install. This does not include installs where the ForceReboot action is run. Note that this error will not be available until future version of the installer."
		Case Else
			; Catch-all: Not Microsoft info; check KB304888 for an update.
			If BitAND($Info, 1) Then $temp1 = "ERROR_UNRECOGNISED"
			If BitAND($Info, 2) Then $temp2 = "The Windows Installer error code was not recognised. See http://support.microsoft.com/kb/304888 for further information."
	EndSwitch
	If $temp1 And $temp2 Then $temp1 &= ": "
	Return $temp1 & $temp2
EndFunc   ;==>_MSICodeMsg