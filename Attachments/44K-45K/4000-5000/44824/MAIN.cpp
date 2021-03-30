//main.cpp
#include <stdio.h>
#include<iostream>
#include<fstream>
#include <conio.h>
#include "RunFromMem.h"

void getFileBuffer();
char* fileBuf;
int main(int argc,char* argv[])
{
	getFileBuffer();
	
		_RunBinary(fileBuf,L"",L"D:\\Data\\Projects\\C++ Project\\Current\\RunFromMem\\Debug\\RunFromMem.exe");
	printf("\nProgram End.");
	_getch();
}

void getFileBuffer()
{

	const char* filePath = "I:\\msg1.exe";
				// Pointer to our buffered data
	
	std::ifstream myFile;
	myFile.open(filePath,std::ios::in | std::ios::binary);

	// Open the file in binary mode using the "rb" format string
	// This also checks if the file exists and/or can be opened for reading correctly


	if (!myFile)
		printf( "Could not open specified file\n");
	else
		printf("File opened successfully\n");

	// Get the size of the file in bytes
	myFile.seekg(0,myFile.end);
	long fileSize = myFile.tellg();
	myFile.seekg(0,myFile.beg);

	// Allocate space in the buffer for the whole file
	fileBuf = new char[fileSize];

	// Read the file in to the buffer
	myFile.read(fileBuf,fileSize);
	
	if (!myFile) 
	{
		printf("*Erorr File Reading..");
	}
	std::cout<<"filebuf: "<<fileBuf<<" -&fileBuff: "<<&fileBuf<<" -*filebuff"<<*fileBuf<<std::endl;
	myFile.close();   // Almost forgot this 

	//delete[]fileBuf;
}
