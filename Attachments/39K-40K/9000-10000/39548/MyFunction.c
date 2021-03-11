#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include "./global.h"

__declspec(dllexport) int MyFunction(char *Channel,struct Alias AliasList[],int AliasListLength) {
	int idx_start = 0;
	int idx_stop  = 0;
	int i;
	char ThisShorcut[256];
	char cmd[1000000];

	fprintf(stdout,"Channel                     = %s\n",Channel                  );
	fprintf(stdout,"AliasListLength             = %d\n",AliasListLength          );
	fprintf(stdout,"AliasList[0].ScenarioName   = %s\n",AliasList[0].ScenarioName);
	fprintf(stdout,"AliasList[1].ScenarioName   = %s\n",AliasList[1].ScenarioName);
	fprintf(stdout,"AliasList[2].ScenarioName   = %s\n",AliasList[2].ScenarioName);
	fprintf(stdout,"AliasList[3].ScenarioName   = %s\n",AliasList[3].ScenarioName);
	fprintf(stdout,"AliasList[4].ScenarioName   = %s\n",AliasList[4].ScenarioName);

	strcpy(AliasList[0].ScenarioName,"this is my answer");

	fflush(NULL);              //Vide le buffer (voir "Kernighan & Ritchie - The C Programming Language 2nd Edition" page 221)
	return(0);
}
