#include <windows.h>
#include <winbase.h>
#include <aclapi.h>
#include <winerror.h>

#include <stdio.h>
#include <stdlib.h>

#define UNAMEMAXSIZE 256

void
main(int argc, char *argv[]){
  char *file_name = argv[1];
  PSID psid;
  PSECURITY_DESCRIPTOR ppSecurityDescriptor;
  DWORD cbName=UNAMEMAXSIZE;
  char Name[UNAMEMAXSIZE];
  char ReferencedDomainName[256];
  DWORD cbReferencedDomainName = 256;
  SID_NAME_USE peUse;
  int Result;
  
  if( argc != 2 ){
    printf("Usage: getowner filename\n",argc);
	exit(1);
    } 

  Result =
  GetNamedSecurityInfo(file_name,
					   SE_FILE_OBJECT,
                       OWNER_SECURITY_INFORMATION,
					   &psid,
					   NULL, // sidGroup is not needed
					   NULL, // dACL is not needed
					   NULL, // sACL is not needed
                       &ppSecurityDescriptor);
  if( Result ){
	printf("%%ERROR %d\n",Result);
	}
  
  Result = 
  LookupAccountSid(NULL,
				    psid,
					Name,
					&cbName ,
                    ReferencedDomainName,
					&cbReferencedDomainName,
                    &peUse);


  LocalFree( ppSecurityDescriptor ); // we dont need it and I do not know if I could pass NULL
  if( Result ){
	printf("%s",Name);
	exit(0);
	}

  printf("%%ERROR %d\n",GetLastError() );
  exit(1);
  }