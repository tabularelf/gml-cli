// dllmain.cpp : Defines the entry point for the DLL application.
#include "pch.h"

#include <iostream>
#include <windows.h>
#include <cstdio> 

#define GMDLL extern "C" __declspec(dllexport)

// Global
FILE* f;

GMDLL void GMConsoleInit() {
	if (!AttachConsole(ATTACH_PARENT_PROCESS)) {
		AllocConsole();
		AttachConsole(GetCurrentProcessId());
	}
	freopen_s(&f, "CONOUT$", "w", stdout);
	std::cout << std::endl;
}

GMDLL double GMConsoleEnd() {
	fclose(f);
	FreeConsole();
	return 0;
}

GMDLL void GMConsolePrint(const char* string) {
	std::cout << string << std::endl;
}