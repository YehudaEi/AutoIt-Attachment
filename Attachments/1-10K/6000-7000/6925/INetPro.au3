; For AutoIt 3.1.1.93 or Above (DllStructDelete() Removed)
#region - WinINet Constants

;for full references of WinINet constants, see                                                                                     

;*** access types for InternetOpen()
Global Const $INTERNET_OPEN_TYPE_PRECONFIG 						= 0   ;use registry configuration
Global Const $INTERNET_OPEN_TYPE_DIRECT 						= 1   ;direct to net
Global Const $INTERNET_OPEN_TYPE_PROXY 							= 3   ;via named proxy
;~ Global Const $INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY = 4   ;prevent using java/script/INS

;*** flags for InternetOpen()
;~ Global Const $INTERNET_FLAG_ASYNC 							= 0x10000000  ;this request is asynchronous (where supported)
;~ Global Const $INTERNET_FLAG_FROM_CACHE 						= 0x01000000  ;use offline semantics

;*** Internet option flags
;~ Global Const $INTERNET_OPTION_CALLBACK 						= 1
;~ Global Const $INTERNET_OPTION_CONNECT_TIMEOUT 				= 2
;~ Global Const $INTERNET_OPTION_CONNECT_RETRIES 				= 3
;~ Global Const $INTERNET_OPTION_SEND_TIMEOUT 					= 5
;~ Global Const $INTERNET_OPTION_RECEIVE_TIMEOUT 				= 6
;~ Global Const $INTERNET_OPTION_HANDLE_TYPE 					= 9
;~ Global Const $INTERNET_OPTION_READ_BUFFER_SIZE 				= 12
;~ Global Const $INTERNET_OPTION_WRITE_BUFFER_SIZE 				= 13
;~ Global Const $INTERNET_OPTION_PARENT_HANDLE 					= 21
;~ Global Const $INTERNET_OPTION_REQUEST_FLAGS 					= 23
;~ Global Const $INTERNET_OPTION_EXTENDED_ERROR 				= 24
Global Const $INTERNET_OPTION_USERNAME 							= 28
Global Const $INTERNET_OPTION_PASSWORD 							= 29
;~ Global Const $INTERNET_OPTION_SECURITY_FLAGS 				= 31
;~ Global Const $INTERNET_OPTION_SECURITY_CERTIFICATE_STRUCT 	= 32
;~ Global Const $INTERNET_OPTION_DATAFILE_NAME 					= 33
;~ Global Const $INTERNET_OPTION_URL 							= 34
;~ Global Const $INTERNET_OPTION_SECURITY_CERTIFICATE 			= 35
;~ Global Const $INTERNET_OPTION_SECURITY_KEY_BITNESS 			= 36
;~ Global Const $INTERNET_OPTION_REFRESH 						= 37
;~ Global Const $INTERNET_OPTION_PROXY 							= 38
;~ Global Const $INTERNET_OPTION_SETTINGS_CHANGED 				= 39
;~ Global Const $INTERNET_OPTION_VERSION 						= 40
;~ Global Const $INTERNET_OPTION_USER_AGENT 					= 41
;~ Global Const $INTERNET_OPTION_END_BROWSER_SESSION 			= 42
Global Const $INTERNET_OPTION_PROXY_USERNAME 					= 43
Global Const $INTERNET_OPTION_PROXY_PASSWORD 					= 44
;~ Global Const $INTERNET_OPTION_CONTEXT_VALUE 					= 45
;~ Global Const $INTERNET_OPTION_CONNECT_LIMIT 					= 46
;~ Global Const $INTERNET_OPTION_SECURITY_SELECT_CLIENT_CERT 	= 47
;~ Global Const $INTERNET_OPTION_CONNECTED_STATE 				= 50
;~ Global Const $INTERNET_OPTION_SECONDARY_CACHE_KEY 			= 53
;~ Global Const $INTERNET_OPTION_REQUEST_PRIORITY 				= 58
;~ Global Const $INTERNET_OPTION_HTTP_VERSION 					= 59
;~ Global Const $INTERNET_OPTION_RESET_URLCACHE_SESSION 		= 60
;~ Global Const $INTERNET_OPTION_ERROR_MASK 					= 62

;*** Query info flags
Global Const $HTTP_QUERY_STATUS_CODE 							= 19

;*** HTTP status codes
Global Const $HTTP_STATUS_OK 									= 200
Global Const $HTTP_STATUS_DENIED 								= 401	;the requested resource requires user authentication
Global Const $HTTP_STATUS_PROXY_AUTH_REQ 						= 407

;*** HTTP request flag
;~ Global Const $INTERNET_FLAG_RELOAD 							= 0x80000000	;retrieves the item from the original server
;~ Global Const $INTERNET_FLAG_SECURE 							= 0x00800000	;uses PCT/SSL if applicable (HTTP request)
Global Const $INTERNET_FLAG_KEEP_CONNECTION 					= 0x00400000	;uses keep-alive semantics, required for authentication
;~ Global Const $INTERNET_FLAG_NO_AUTO_REDIRECT 				= 0x00200000	;doesn't handle redirections automatically
;~ Global Const $INTERNET_FLAG_NO_COOKIES 						= 0x00080000	;no automatic cookie handling
;~ Global Const $INTERNET_FLAG_NO_AUTH 							= 0x00040000	;no automatic authentication handling
;~ Global Const $INTERNET_FLAG_CACHE_IF_NET_FAIL 				= 0x00010000	;returns cache file if net request fails
;~ Global Const $INTERNET_FLAG_RESYNCHRONIZE 					= 0x00000800	;asks wininet to update an item if it is newer
;~ Global Const $INTERNET_FLAG_HYPERLINK 						= 0x00000400	;forces a reload if no Expires time and no LastModified time is returned from the server
;~ Global Const $INTERNET_FLAG_PRAGMA_NOCACHE 					= 0x00000100	;asks wininet to add "pragma: no-cache", ignore cache on the proxy

#endregion


#region - _GetDataFromPtr($vPtr, $vStrc = 'char[1]')

;===============================================================================
;
; Function Name:	_GetDataFromPtr()
; Description:		Retrieve data from a pointer.
; Parameter(s):		$vPtr = The pointer to the wanted data.
;					$vStrc = A string that representing the structure for retrieving data. Default is 'char[1]'.
; Requirement:		DllStructCreate/GetData
; Return Value(s):	On Success - Returns the data.
;					On Failure - 0 and set
;						@error = 1 when StructCreate error, @extended = StructCreate's @error
;						@error = 2 when StructGetData error, @extended = StructGetData's @error
; Author(s):		Valik, integrated by CatchFish
; Note(s):			Because a pointer is supplied, the created struct DOES NOT need to be freed with DllStructDelete().
;
;===============================================================================

Func _GetDataFromPtr($vPtr, $vStrc = 'char[1]')
	Local $tDataStrc, $tData
	$tDataStrc = DllStructCreate($vStrc, $vPtr)  ;Creates the structure using the pointer
	If @error = 0 Then  ;Structure created successfully
		$tData = DllStructGetData($tDataStrc, 1)
		If @error = 0 Then  ;Data got successfully
			Return $tData
		Else  ;Data got failed
			SetError(2, @error)
			Return 0
		EndIf
	Else  ;Structure created failed
		SetError(1, @error)
		Return 0
	EndIf
EndFunc  ;==>_GetDataFromPtr()
#endregion


#region - _CrackUrl($s_Url, $h_Dll = "wininet.dll")

;===============================================================================
;
; Function Name:	_CrackUrl()
; Description:		Cracks a given URL into its component parts.
; Parameter(s):		$s_Url - URL to be cracked
;					$h_Dll - Handle of the wininet.dll. If omitted, a filename of 'wininet.dll' will be used.
; Requirement:		_GetDataFromPtr(), DllStructCreate/Delete/GetData/SetData(), DllCall(), wininet.dll
; Return Value(s):	On Success - Returns an array of the component parts of the given URL, of which elements are
;								0 = INTERNET_SCHEME value(integer, see notes)
;								1 = Protocol scheme name
;								2 = Host name
;								3 = Port number(integer)
;								4 = User name
;								5 = Password
;								6 = URL path
;								7 = Extra information
;					On Failure - Returns 0 and sets
;								@error = 1 when an error on DllCall(), @extended =  DllCall's @error
;								@error = 2 when an error on (WinINet)function InternetCrackUrl, @extended = System GetLastError()
; Author(s):		CatchFish
; Note(s):			Structure URL_COMPONENTS reference -
;						http://msdn.microsoft.com/library/en-us/wininet/wininet/url_components.asp
;					Type INTERNET_SCHEME reference -
;						http://msdn.microsoft.com/library/en-us/wininet/wininet/internet_scheme_enumerated_type.asp
;						Frequently used values: 1 = FTP, 3 = HTTP, 4 = HTTPS
; 					Function (WinINet)InternetCrackUrl reference -
;						http://msdn.microsoft.com/library/en-us/wininet/wininet/internetcrackurl.asp
;
;===============================================================================

Func _CrackUrl($s_Url, $h_Dll = "wininet.dll")
	Local $strc_UC, $strc_Scheme, $strc_Host, $strc_User, $strc_Passwd, $strc_Path, $strc_Extra, $ai_ICU
	Local $i_Err = 0, $i_ErrExt = 0, $ReturnVal = 1
	$strc_UC = DllStructCreate( _	;Creates an URL_COMPONENTS structure. See comments on top of this section.
							'int;' & _	;1  - Size of this structure, in bytes.
							'ptr;' & _	;2  - Pointer to a string that contains the scheme name.
							'int;' & _	;3  - Size of the scheme name, in TCHARs.
							'int;' & _	;4  - INTERNET_SCHEME value that indicates the Internet protocol scheme. See comments on top of this section.
							'ptr;' & _	;5  - Pointer to a string that contains the host name.
							'int;' & _	;6  - Size of the host name, in TCHARs.
							'int;' & _	;7  - Converted port number.
							'ptr;' & _	;8  - Pointer to a string value that contains the user name.
							'int;' & _	;9  - Size of the user name, in TCHARs.
							'ptr;' & _	;10 - Pointer to a string that contains the password.
							'int;' & _	;11 - Size of the password, in TCHARs.
							'ptr;' & _	;12 - Pointer to a string that contains the URL path.
							'int;' & _	;13 - Size of the URL path, in TCHARs.
							'ptr;' & _	;14 - Pointer to a string that contains the extra information (for example, ?something or #something).
							'int' )		;15 - Size of the extra information, in TCHARs.
	$strc_Scheme = DllStructCreate('char[32]')		;Buffer for the protocol scheme name
	$strc_Host   = DllStructCreate('char[256]')		;Buffer for the host name
	$strc_User   = DllStructCreate('char[128]')		;Buffer for the user name
	$strc_Passwd = DllStructCreate('char[128]')		;Buffer for the password
	$strc_Path   = DllStructCreate('char[2048]')	;Buffer for the URL path
	$strc_Extra  = DllStructCreate('char[2048]')	;Buffer for the extra information
	DllStructSetData($strc_UC, 1,  DllStructGetSize($strc_UC))		;Sets size of the URL_COMPONENTS structure
	DllStructSetData($strc_UC, 2,  DllStructGetPtr($strc_Scheme))	;Sets the pointer to the protocol scheme name buffer
	DllStructSetData($strc_UC, 3,  DllStructGetSize($strc_Scheme))	;Sets size of the buffer
	DllStructSetData($strc_UC, 5,  DllStructGetPtr($strc_Host))		;Sets the pointer to the host name buffer
	DllStructSetData($strc_UC, 6,  DllStructGetSize($strc_Host))	;Sets size of the buffer
	DllStructSetData($strc_UC, 8,  DllStructGetPtr($strc_User))		;Sets the pointer to the user name buffer
	DllStructSetData($strc_UC, 9,  DllStructGetSize($strc_User))	;Sets size of the buffer
	DllStructSetData($strc_UC, 10, DllStructGetPtr($strc_Passwd))	;Sets the pointer to the password buffer
	DllStructSetData($strc_UC, 11, DllStructGetSize($strc_Passwd))	;Sets size of the buffer
	DllStructSetData($strc_UC, 12, DllStructGetPtr($strc_Path))		;Sets the pointer to the URL path buffer
	DllStructSetData($strc_UC, 13, DllStructGetSize($strc_Path))	;Sets size of the buffer
	DllStructSetData($strc_UC, 14, DllStructGetPtr($strc_Extra))	;Sets the pointer to the extra information buffer
	DllStructSetData($strc_UC, 15, DllStructGetSize($strc_Extra))	;Sets size of the buffer
	$ai_ICU = DllCall($h_DLL, _						;Handle of WinINet DLL
					'int', 'InternetCrackUrl', _		;Function that cracks a URL into its component parts
					'str', $s_URL, _					;String that contains the canonical URL to be cracked.
					'int', 0, _							;Size of the url string, in TCHARs, or zero if url is an ASCIIZ string.
					'int', 0, _							;Flag that controls the operation, can be one of the following values: ICU_DECODE = 0x10000000, ICU_ESCAPE = 0x80000000
					'int', DllStructGetPtr($strc_UC) )	;Pointer to a URL_COMPONENTS structure that receives the URL components
	If @error <> 0 Then			;ERROR on DllCall
		$i_Err = 1
		$i_ErrExt = @error			;Passes the DllCall @error to extended error
		$ReturnVal = 0
	ElseIf $ai_ICU[0] = 0 Then	;ERROR on (WinINet)function InternetCrackUrl
		Local $tError = DLLCall("kernel32.dll","int","GetLastError")	;Gets the system error code
		$i_Err = 2
		$i_ErrExt = $tError												;Passes the system error code to extended error
		$ReturnVal = 0
	Else						;Everything's OK
		Local $ReturnVal[8]
		$ReturnVal[0] = DllStructGetData($strc_UC, 4)																		;INTERNET_SCHEME value
		$ReturnVal[1] = _GetDataFromPtr(DllStructGetData($strc_UC, 2 ), 'char[' & DllStructGetData($strc_UC, 3 ) & ']')		;Protocol scheme name
		$ReturnVal[2] = _GetDataFromPtr(DllStructGetData($strc_UC, 5 ), 'char[' & DllStructGetData($strc_UC, 5 ) & ']')		;Host name
		$ReturnVal[3] = DllStructGetData($strc_UC, 7)																		;Port number
		$ReturnVal[4] = _GetDataFromPtr(DllStructGetData($strc_UC, 8 ), 'char[' & DllStructGetData($strc_UC, 8 ) & ']')		;User name
		$ReturnVal[5] = _GetDataFromPtr(DllStructGetData($strc_UC, 10), 'char[' & DllStructGetData($strc_UC, 10) & ']')		;Password
		$ReturnVal[6] = _GetDataFromPtr(DllStructGetData($strc_UC, 12), 'char[' & DllStructGetData($strc_UC, 12) & ']')		;URL path
		$ReturnVal[7] = _GetDataFromPtr(DllStructGetData($strc_UC, 14), 'char[' & DllStructGetData($strc_UC, 14) & ']')		;Extra information
	EndIf
	;Destroys the structures
	$strc_Extra = 0
	$strc_Path = 0
	$strc_Passwd = 0
	$strc_User = 0
	$strc_Host = 0
	$strc_Scheme = 0
	$strc_UC = 0
	;Sets errors and returns
	SetError($i_Err, $i_ErrExt)
	Return $ReturnVal
EndFunc  ;==>_CrackUrl()
#endregion




#region - _INetGetSourcePro($s_URL, $s_Verb = 'GET', $s_Submits = '', $i_ReadFile = 1, $s_UrlUsername = '', $s_UrlPassword = '', $s_Proxy = '', $s_ProxyUsername = '', $s_ProxyPassword = '')
;===============================================================================
;
; Function Name:	_INetGetSourcePro()
; Description:		Gets the source from an URL without writing a temp file.
; Parameter(s):		$s_URL 				= The URL of the site.
;					$s_Verb 			= [Optional]The verb of HTTP request
;					$s_Submits 			= [Optional]The contents to be sent by PUT or POST method
;					$i_ReadFile 		= [Optional]Determines whether to return the response content. 1 = return(default), 0 = not to return.
;					$s_UrlUser 			= [Optional]The user name used to access the URL.
;					$s_UrlPassword 		= [Optional]The password used to access the URL.
;					$s_Proxy 			= [Optional]The PROXY of the connection, in format of http=http://proxy_name:port
;					$s_ProxyUser 		= [Optional]The user name used to access the proxy
;					$s_ProxyPassword 	= [Optional]The password used to access the proxy
; Requirement(s):	DllCall/Struct & WinInet.dll
; Return Value(s):	On Success - If $i_ReadFile = 1, returns the source. Otherwise, returns 1.
; 					On Failure - Returns 0 and sets
;						@error = 1  -  cannot open wininet.dll
;						@error = 2  -  URL format error
;						@error = 3  -  calling InternetOpen() error, & set @extended = DllCall()'s @error
;						@error = 4  -  calling InternetConnect() error, & set @extended = DllCall()'s @error
;						@error = 5  -  calling HttpOpenRequest() error, & set @extended = DllCall()'s @error
;						@error = 6  -  calling HttpSendRequest() error, & set @extended = DllCall()'s @error
;						@error = 7  -  InternetQueryInfo() error, & set @extended = DllCall()'s @error
;						@error = 8  -  InternetReadFile() error, & set @extended = DllCall()'s @error
;						@error = 9  -  HTTP error, & set @extended = HTTP status code
; Author(s):		Wouter van Kesteren, modified by CatchFish
; Note(s): 			for WinINet reference, see
;						http://msdn.microsoft.com/library/en-us/wininet/wininet/wininet_reference.asp
;
;===============================================================================
Func _INetGetSourcePro($s_URL, $s_Verb = 'GET', $s_Submits = '', $i_ReadFile = 1, $s_UrlUsername = '', $s_UrlPassword = '', $s_Proxy = '', $s_ProxyUsername = '', $s_ProxyPassword = '')
    Local $h_DLL = DllOpen('wininet.dll')
	If $h_DLL = -1 Then		;error handler of DllOpen('wininet.dll')
		SetError(1)
		Return 0
	EndIf
	Local $ai_IO, $i_Type = $INTERNET_OPEN_TYPE_DIRECT, $ai_IC, $ai_HOR, $ai_HSR, $ai_HQI, $s_StatusCode, $strc_Length, $ai_IRF, $s_Buf = ''
	Local $as_CrackedUrl = _CrackUrl($s_URL, $h_Dll)
	If @error <> 0 Then		;error handler of _CrackUrl()
		SetError(2)
		Return 0
	EndIf
	Local $i_Scheme 	= $as_CrackedUrl[0]
	Local $s_HostName 	= $as_CrackedUrl[2]
	Local $i_PortNum 	= $as_CrackedUrl[3]
	Local $s_UrlPath 	= $as_CrackedUrl[6]
	Local $s_Extra		= $as_CrackedUrl[7]
	Local $s_GetUrl 	= $s_UrlPath & $s_Extra
	Local Const $TMP_BUFFER_SIZE = 256
	Local $i_Err = 0, $i_ErrExt = 0, $ReturnVal = ''	;error code, extended code & returned value

	If $s_Proxy <> '' Then $i_Type = $INTERNET_OPEN_TYPE_PROXY
	;calls InternetOpen() here
    $ai_IO = DllCall($h_DLL, _
				'int', 'InternetOpen', _ 	;initializes an application's use of the WinINet functions, returns a handle
				'str', 'AutoIt3', _ 		;specifies the name of the application or entity calling the functions, used as the user agent in HTTP
				'int', $i_Type, _		 	;access type - preconfig(0), direct, proxy, preconfig but disable autoproxy(see const.)
				'str', $s_Proxy, _ 			;the name of the proxy server(s) to use
				'str', '', _ 				;specifies an optional list of host names and/or IP addresses, that should not be routed through the proxy
				'int', 0 ) 					;flag on how the request should be made - comb. of normal(0), asynchronous, from cache(see const.)
    If @error = 0 And $ai_IO[0] <> 0 Then
		;calls InternetConnect() here
		$ai_IC = DllCall($h_DLL, _
					'int', 'InternetConnect', _		;opens a connection sessioin, returns a handle to that session if success
					'int', $ai_IO[0], _				;the handle returned by a previous call to InternetOpen()
					'str', $s_HostName, _			;the host name of an Internet server
					'int', $i_PortNum, _			;transmission Control Protocol/Internet Protocol (TCP/IP) port on the server.
					'str', '', _					;the name of the user to log on, could be set later using InternetSetOption()
					'str', '', _					;the password to use to log on, could be set later using InternetSetOption()
					'int', $i_Scheme, _				;type of service to access, can be URL(0), http(1), gopher(2), ftp(3)(see notes of _CrackUrl())
					'int', 0, _						;options specific to the service used, like changing FTP to passive mode
					'int', 0 )						;pointer to a variable that contains an application-defined value _
													;that is used to identify the application context for the returned handle in callbacks.
		If @error = 0 And $ai_IC[0] <> 0 Then
			;calls HttpOpenRequest() here
			$ai_HOR = DllCall($h_DLL, _
						'int', 'HttpOpenRequest', _		;creates an http request handle
						'int', $ai_IC[0], _				;the handle returned by InternetConnect()
						'str', StringUpper($s_Verb), _	;the HTTP verb to use in the request, if NULL, the function uses GET as the HTTP verb
						'str', $s_GetUrl, _				;the name of the target object of the specified HTTP verb, generally a file name, etc
						'str', '', _					;the HTTP version, if NULL, the function uses HTTP/1.1 as the version
						'str', '', _					;the URL of the document from which the URL in the request was obtained (reference header)
						'int', 0, _						;an array of strings which contains media types accepted by the client, if NULL, servers generally interpret as type "text/*"
						'int', $INTERNET_FLAG_KEEP_CONNECTION, _	;internet options (see constants). keeping connection is neccessary for authentication
						'int', 0 )	;a pointer to a variable that contains the application-defined value that associates this operation with any application data
			If @error = 0 And $ai_HOR[0] <> 0 Then
				;calls InternetSetOption() to set user name, if provided
				If $s_UrlUsername <> '' Then
					DllCall($h_Dll, _
							'int', 'InternetSetOption', _				;sets an Internet option, returns true/false on success/failure
							'int', $ai_HOR[0], _						;the HTTP request handle
							'int', $INTERNET_OPTION_USERNAME, _			;Internet Option to be set. here sets the user name.
							'str', $s_UrlUsername, _					;pointer to a buffer that contains the option setting
							'int', StringLen($s_UrlUsername) )			;size of the buffer
				EndIf
				;calls InternetSetOption() to set password, if provided
				If $s_UrlPassword <> '' Then
					DllCall($h_Dll, _
							'int', 'InternetSetOption', _				;sets an Internet option, returns true/false on success/failure
							'int', $ai_HOR[0], _						;the HTTP request handle
							'int', $INTERNET_OPTION_PASSWORD, _			;Internet Option to be set. here sets the password.
							'str', $s_UrlPassword, _					;pointer to a buffer that contains the option setting
							'int', StringLen($s_UrlPassword) )			;size of the buffer
				EndIf
				;calls InternetSetOption() to set proxy user name, if provided
				If $s_ProxyUsername <> '' Then
					DllCall($h_Dll, _
							'int', 'InternetSetOption', _				;sets an Internet option, returns true/false on success/failure
							'int', $ai_HOR[0], _						;the HTTP request handle
							'int', $INTERNET_OPTION_PROXY_USERNAME, _	;Internet Option to be set. here sets the proxy user name.
							'str', $s_ProxyUsername, _					;pointer to a buffer that contains the option setting
							'int', StringLen($s_ProxyUsername) )		;size of the buffer
				EndIf
				;calls InternetSetOption() to set proxy password, if provided
				If $s_ProxyPassword <> '' Then
					DllCall($h_Dll, _
							'int', 'InternetSetOption', _				;sets an Internet option, returns true/false on success/failure
							'int', $ai_HOR[0], _						;the HTTP request handle
							'int', $INTERNET_OPTION_PROXY_PASSWORD, _	;Internet Option to be set. here sets the proxy password.
							'str', $s_ProxyPassword, _					;pointer to a buffer that contains the option setting
							'int', StringLen($s_ProxyPassword) )		;size of the buffer
				EndIf
				;calls HttpSendRequest() here
				$ai_HSR = DllCall($h_Dll, _
								'int', 'HttpSendRequest', _			;sends the specified request to the HTTP server
								'int', $ai_HOR[0], _				;the HTTP request handle
								'str', '', _						;a string that contains the additional headers to be appended to the request, can be NULL if none
								'int', 0, _							;size of the additional headers, in TCHARs
								'str', $s_Submits, _				;a buffer containing data to be sent by POST or PUT operations, can be NULL if none
								'int', StringLen($s_Submits) )	;size of the optional data, in bytes
				If @error = 0 And $ai_HSR[0] = 1 Then
					;calls HttpQueryInfo() here
					$strc_Length = DllStructCreate('udword')
					DllStructSetData($strc_Length, 1, $TMP_BUFFER_SIZE) 		;set maximum buffer length (256 Bytes)
					$ai_HQI = DllCall($h_DLL, _
								'int', 'HttpQueryInfo', _						;retrieves custom HTTP headers
								'int', $ai_HOR[0], _							;the HTTP request handle
								'int', $HTTP_QUERY_STATUS_CODE, _				;specify which header to fetch
								'str', '', _ 									;buffer for receiving the header content. Also being passed as a parameter if needed.
								'ptr', DllStructGetPtr($strc_Length, 1), _		;DWORD which must be assigned the maximum length of the buffer. Also receive actual content length.
								'int', 0 )										;DWORD used as a zero-based index passed to the function to enumerate multiple headers with the same name.
																				;also for receiving the index of the next header until ERROR_HTTP_HEADER_NOT_FOUND(=12150, see above) is returned.
					If @error = 0 And $ai_HQI[0] = 1 Then
						$s_StatusCode = StringLeft($ai_HQI[3], DllStructGetData($strc_Length, 1))
						If $s_StatusCode = $HTTP_STATUS_OK Then
							If $i_ReadFile = 1 Then		;the read-file flag is true
								;calls InternetReadFile() here
								;See                                                         for example
								Do 
									$ai_IRF = DllCall($h_DLL, _
												'int', 'InternetReadFile', _				;reads data from a handle
												'int', $ai_HOR[0], _						;the HTTP request handle
												'str', '', _								;a buffer that receives the data
												'int', $TMP_BUFFER_SIZE, _					;number of bytes to be read
												'ptr', DllStructGetPtr($strc_Length, 1) )	;pointer to a variable that receives the number of bytes read
									If @error = 0 And $ai_IRF[0] = 1 Then
										$ai_IRF[4] = DllStructGetData($strc_Length, 1)
										$s_Buf &= StringLeft($ai_IRF[2], $ai_IRF[4])
									Else	;error handler of InternetReadFile()
										$i_ErrExt = @error
										$i_Err = 8
										$ReturnVal = $s_Buf
										ExitLoop
									EndIf
								Until $ai_IRF[4] = 0
								$ReturnVal = $s_Buf		;successfully returns
							Else	;the read-file flag is false, ignore the InternetReadFile()
								$ReturnVal = 1
							EndIf
						Else	;error handler of the HTTP request
							$i_ErrExt = Number($s_StatusCode)
							$i_Err = 9
							$ReturnVal = 0
						EndIf
					Else	;error handler of HttpQueryInfo()
						$i_ErrExt = @error
						$i_Err = 7
						$ReturnVal = 0
					EndIf
					$strc_Length = 0
				Else	;error handler of HttpSendRequest()
					$i_ErrExt = @error
					$i_Err = 6
					$ReturnVal = 0
				EndIf
				DllCall($h_DLL, 'int', 'InternetCloseHandle', 'int', $ai_HOR[0])	;releases HTTP request handle
			Else	;error handler of HttpOpenRequest()
				$i_ErrExt = @error
				$i_Err = 5
				$ReturnVal = 0
			EndIf
			DllCall($h_DLL, 'int', 'InternetCloseHandle', 'int', $ai_IC[0])		;releases handle returned by InternetConnect()
		Else	;error handler of InternetConnect()
			$i_ErrExt = @error
			$i_Err = 4
			$ReturnVal = 0
		EndIf
		DllCall($h_DLL, 'int', 'InternetCloseHandle', 'int', $ai_IO[0])		;releases handle returned by InternetOpen()
	Else	;error handler of InternetOpen()
		$i_ErrExt = @error
		$i_Err = 3
		$ReturnVal = 0
    EndIf
	DllClose($h_DLL)
	SetError($i_Err, $i_ErrExt)
	Return $ReturnVal
EndFunc  ;==>_INetGetSourcePro()
#endregion

