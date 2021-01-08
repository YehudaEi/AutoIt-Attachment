; FILE: WSAErrorCodes.au3
; PURPOSE: Return error codes given by AutoIts TCP functions
; SOURCE: http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winsock/winsock/windows_sockets_error_codes_2.asp
; CREATED BY: Uten: http://www.autoitscript.com/forum/index.php?showuser=7836
;

;
#include-once
; Accepts a TCP* (WSAErrorCodes) error code. As returned by WSAGetLastError function in windows socket API.
; Returns the error codes coresponding text
Func WSAErrorCodes($code)
	local $ret
	switch $code 
		case 10014 	
			$ret = "WSAEFAULT: Bad address."
				;The system detected an invalid pointer address in attempting to use a pointer argument of a call. This error occurs if an application passes an invalid pointer value, or if the length of the buffer is too small. For instance, if the length of an argument, which is a sockaddr structure, is smaller than the sizeof(sockaddr).
		
		case 10022
			$ret = "WSAEINVAL: Invalid argument." 
				;Some invalid argument was supplied (for example, specifying an invalid level to the setsockopt function). In some instances, it also refers to the current state of the socket—for instance, calling accept on a socket that is not listening.
		
		case 10024
			$ret = "WSAEMFILE: Too many open files."
					;Too many open sockets. Each implementation may have a maximum number of socket handles available, either globally, per process, or per thread.
		
		case 10035
			$ret = "WSAEWOULDBLOCK: Resource temporarily unavailable."
				;This error is returned from operations on nonblocking sockets that cannot be completed immediately, for example recv when no data is queued to be read from the socket. It is a nonfatal error, and the operation should be retried later. It is normal for WSAEWOULDBLOCK to be reported as the result from calling connect on a nonblocking SOCK_STREAM socket, since some time must elapse for the connection to be established.
		
		case 10036
			$ret = "WSAEINPROGRESS: Operation now in progress."
				;A blocking operation is currently executing. Windows Sockets only allows a single blocking operation—per- task or thread—to be outstanding, and if any other function call is made (whether or not it references that or any other socket) the function fails with the WSAEINPROGRESS error.

		case 10037
			$ret = "WSAEALREADY: Operation already in progress."
				;An operation was attempted on a nonblocking socket with an operation already in progress—that is, calling connect a second time on a nonblocking socket that is already connecting, or canceling an asynchronous request (WSAAsyncGetXbyY) that has already been canceled or completed.

		case 10038
			$ret = "WSAENOTSOCK: Socket operation on nonsocket."
				;An operation was attempted on something that is not a socket. Either the socket handle parameter did not reference a valid socket, or for select, a member of an fd_set was not valid.
		
		case 10039
			$ret = "WSAEDESTADDRREQ: Destination address required."
				;A required address was omitted from an operation on a socket. For example, this error is returned if sendto is called with the remote address of ADDR_ANY.
		
		case 10040
			$ret = "WSAEMSGSIZE: Message too long."
				;A message sent on a datagram socket was larger than the internal message buffer or some other network limit, or the buffer used to receive a datagram was smaller than the datagram itself.

		case 10041
			$ret = "WSAEPROTOTYPE: Protocol wrong type for socket."
				; A protocol was specified in the socket function call that does not support the semantics of the socket type requested. For example, the ARPA Internet UDP protocol cannot be specified with a socket type of SOCK_STREAM.

		case 10042
			$ret = "WSAENOPROTOOPT: Bad protocol option."
				;An unknown, invalid or unsupported option or level was specified in a getsockopt or setsockopt call.

		case 10043
			$ret = "WSAEPROTONOSUPPORT: Protocol not supported."
				;The requested protocol has not been configured into the system, or no implementation for it exists. For example, a socket call requests a SOCK_DGRAM socket, but specifies a stream protocol.

		case 10044
			$ret = "WSAESOCKTNOSUPPORT: Socket type not supported."
				;The support for the specified socket type does not exist in this address family. For example, the optional type SOCK_RAW might be selected in a socket call, and the implementation does not support SOCK_RAW sockets at all.

		case 10045
			$ret = "WSAEOPNOTSUPP: Operation not supported."
				;The attempted operation is not supported for the type of object referenced. Usually this occurs when a socket descriptor to a socket that cannot support this operation is trying to accept a connection on a datagram socket.

		case 10046
			$ret = "WSAEPFNOSUPPORT: Protocol family not supported."
				;The protocol family has not been configured into the system or no implementation for it exists. This message has a slightly different meaning from WSAEAFNOSUPPORT. However, it is interchangeable in most cases, and all Windows Sockets functions that return one of these messages also specify WSAEAFNOSUPPORT.

		case 10047
			$ret = "WSAEAFNOSUPPORT: Address family not supported by protocol family."
				;An address incompatible with the requested protocol was used. All sockets are created with an associated address family (that is, AF_INET for Internet Protocols) and a generic protocol type (that is, SOCK_STREAM). This error is returned if an incorrect protocol is explicitly requested in the socket call, or if an address of the wrong family is used for a socket, for example, in sendto.

		case 10048
			$ret = "WSAEADDRINUSE: Address already in use."
				;Typically, only one usage of each socket address (protocol/IP address/port) is permitted. This error occurs if an application attempts to bind a socket to an IP address/port that has already been used for an existing socket, or a socket that was not closed properly, or one that is still in the process of closing. For server applications that need to bind multiple sockets to the same port number, consider using setsockopt (SO_REUSEADDR). Client applications usually need not call bind at all— connect chooses an unused port automatically. When bind is called with a wildcard address (involving ADDR_ANY), a WSAEADDRINUSE error could be delayed until the specific address is committed. This could happen with a call to another function later, including connect, listen, WSAConnect, or WSAJoinLeaf.

		case 10049
			$ret = "WSAEADDRNOTAVAIL: Cannot assign requested address."
				;The requested address is not valid in its context. This normally results from an attempt to bind to an address that is not valid for the local computer. This can also result from connect, sendto, WSAConnect, WSAJoinLeaf, or WSASendTo when the remote address or port is not valid for a remote computer (for example, address or port 0).
		
		case 10050
			$ret = "WSAENETDOWN: Network is down."
				;A socket operation encountered a dead network. This could indicate a serious failure of the network system (that is, the protocol stack that the Windows Sockets DLL runs over), the network interface, or the local network itself.

		case 10051
			$ret = "WSAENETUNREACH: Network is unreachable."
				;A socket operation was attempted to an unreachable network. This usually means the local software knows no route to reach the remote host.

		case 10052
			$ret = "WSAENETRESET: Network dropped connection on reset."
				;The connection has been broken due to keep-alive activity detecting a failure while the operation was in progress. It can also be returned by setsockopt if an attempt is made to set SO_KEEPALIVE on a connection that has already failed.

		case 10053
			$ret = "WSAECONNABORTED: Software caused connection abort."
				;An established connection was aborted by the software in your host computer, possibly due to a data transmission time-out or protocol error.

		case 10054
			$ret = "WSAECONNRESET: Connection reset by peer."
				;An existing connection was forcibly closed by the remote host. This normally results if the peer application on the remote host is suddenly stopped, the host is rebooted, the host or remote network interface is disabled, or the remote host uses a hard close (see setsockopt for more information on the SO_LINGER option on the remote socket). This error may also result if a connection was broken due to keep-alive activity detecting a failure while one or more operations are in progress. Operations that were in progress fail with WSAENETRESET. Subsequent operations fail with WSAECONNRESET.

		case 10055
			$ret = "WSAENOBUFS: No buffer space available."
				;An operation on a socket could not be performed because the system lacked sufficient buffer space or because a queue was full.

		case 10056
			$ret = "WSAEISCONN: Socket is already connected."
				;A connect request was made on an already-connected socket. Some implementations also return this error if sendto is called on a connected SOCK_DGRAM socket (for SOCK_STREAM sockets, the to parameter in sendto is ignored) although other implementations treat this as a legal occurrence.

		case 10057
			$ret = "WSAENOTCONN: Socket is not connected."
				;A request to send or receive data was disallowed because the socket is not connected and (when sending on a datagram socket using sendto) no address was supplied. Any other type of operation might also return this error—for example, setsockopt setting SO_KEEPALIVE if the connection has been reset.

		case 10058
			$ret = "WSAESHUTDOWN: Cannot send after socket shutdown."
				;A request to send or receive data was disallowed because the socket had already been shut down in that direction with a previous shutdown call. By calling shutdown a partial close of a socket is requested, which is a signal that sending or receiving, or both have been discontinued.
				
		case 10060
			$ret = "WSAETIMEDOUT: Connection timed out."
				;A connection attempt failed because the connected party did not properly respond after a period of time, or the established connection failed because the connected host has failed to respond.

		case 10061
				$ret = "WSAECONNREFUSED: Connection refused."
				;No connection could be made because the target computer actively refused it. This usually results from trying to connect to a service that is inactive on the foreign host—that is, one with no server application running.

		case 10064
			$ret = "WSAEHOSTDOWN: Host is down."
				;A socket operation failed because the destination host is down. A socket operation encountered a dead host. Networking activity on the local host has not been initiated. These conditions are more likely to be indicated by the error WSAETIMEDOUT.

		case 10065
			$ret = "WSAEHOSTUNREACH: No route to host."
				;A socket operation was attempted to an unreachable host. See WSAENETUNREACH.

		case 10067
			$ret ="WSAEPROCLIM: Too many processes."
				;A Windows Sockets implementation may have a limit on the number of applications that can use it simultaneously.WSAStartup may fail with this error if the limit has been reached.

		case 10091
			$ret = "WSASYSNOTREADY: Network subsystem is unavailable."
				;This error is returned by WSAStartup if the Windows Sockets implementation cannot function at this time because the underlying system it uses to provide network services is currently unavailable. Users should check:

				;* That the appropriate Windows Sockets DLL file is in the current path.
				;* That they are not trying to use more than one Windows Sockets implementation simultaneously. If there is more than one Winsock DLL on your system, be sure the first one in the path is appropriate for the network subsystem currently loaded.
				;* The Windows Sockets implementation documentation to be sure all necessary components are currently installed and configured correctly.
		case 10092
			$ret = "WSAVERNOTSUPPORTED: Winsock.dll version out of range."
				;The current Windows Sockets implementation does not support the Windows Sockets specification version requested by the application. Check that no old Windows Sockets DLL files are being accessed.

		case 10093
			$ret = "WSANOTINITIALISED: Successful WSAStartup not yet performed."
				;Either the application has not called WSAStartup or WSAStartup failed. The application may be accessing a socket that the current active task does not own (that is, trying to share a socket between tasks), or WSACleanup has been called too many times.

		case 10101
			$ret = "WSAEDISCON: Graceful shutdown in progress."
				;Returned by WSARecv and WSARecvFrom to indicate that the remote party has initiated a graceful shutdown sequence.

		case 10109
			$ret = "WSATYPE_NOT_FOUND: Class type not found."
				;The specified class was not found.
		case 11101
			$ret = "WSAHOST_NOT_FOUND: Host not found."
				;No such host is known. The name is not an official host name or alias, or it cannot be found in the database(s) being queried. This error may also be returned for protocol and service queries, and means that the specified name could not be found in the relevant database.

		case 11002
			$ret = "WSATRY_AGAIN: Nonauthoritative host not found."
				;This is usually a temporary error during host name resolution and means that the local server did not receive a response from an authoritative server. A retry at some time later may be successful.

		case 11003
			$ret = "WSANO_RECOVERY: This is a nonrecoverable error."
				;This indicates that some sort of nonrecoverable error occurred during a database lookup. This may be because the database files (for example, BSD-compatible HOSTS, SERVICES, or PROTOCOLS files) could not be found, or a DNS request was returned by the server with a severe error.

		case 11004
			$ret = "WSANO_DATA: Valid name, no data record of requested type."
				;The requested name is valid and was found in the database, but it does not have the correct associated data being resolved for. The usual example for this is a host name-to-address translation attempt (using gethostbyname or WSAAsyncGetHostByName) which uses the DNS (Domain Name Server). An MX record is returned but no A record—indicating the host itself exists, but is not directly reachable. 
		case Else
			$ret = "WSAErrorCode unknown at this moment. Could be one of the OS dependent ones."
	EndSwitch
	Return $ret
	
EndFunc	