; Sample stunnel configuration file by Michal Trojnara 2002-2006
; Some options used here may not be adequate for your particular configuration

; Certificate/key is needed in server mode and optional in client mode
; The default certificate is provided only for testing and should not
; be used in a production environment
cert = stunnel.pem
;key = stunnel.pem

; Some performance tunings
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

; Workaround for Eudora bug
;options = DONT_INSERT_EMPTY_FRAGMENTS

; Authentication stuff
;verify = 2
; Don't forget to c_rehash CApath
;CApath = certs
; It's often easier to use CAfile
;CAfile = certs.pem
; Don't forget to c_rehash CRLpath
;CRLpath = crls
; Alternatively you can use CRLfile
;CRLfile = crls.pem

; Some debugging stuff useful for troubleshooting
;debug = 7
;output = stunnel.log

; Use it for client mode
client = yes

; Service-level configuration

[SMTP Gmail]
accept = 127.0.0.1:1099
connect = smtp.googlemail.com:465

;[pop3s]
;accept  = 995
;connect = 110

;[imaps]
;accept  = 993
;connect = 143

;[ssmtp]
;accept  = 465
;connect = 25

;[https]
;accept  = 443
;connect = 80
;TIMEOUTclose = 0

; vim:ft=dosini
