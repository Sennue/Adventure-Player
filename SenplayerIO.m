//
//  SenplayerIO.m
//  AdventurePlayer
//
//  Created by Brendan A R Sechter on 10/06/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SenplayerIO.h"
#define SENPLAYERIO_RESOURCE_EXTENSION @"aqr"

LuaController *gLuaController;
NSString *gBundlePath;
NSString *gResourcePath;
NSString *gDocumentPath;
NSString *gLanguage;

BOOL SenplayerIO_HasLanguage(NSString *pLanguage) {
	NSString *path = [NSString stringWithFormat: @"%@/%@", gResourcePath, pLanguage];
	return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

BOOL SenplayerIO_DoSetLanguage(NSString *pLanguage) {
	if (SenplayerIO_HasLanguage(pLanguage)) {
		if (gLanguage) {
			[gLanguage release];
		}
		gLanguage = pLanguage;
		[gLanguage retain];
		return YES;
	}
	// Language not set
	return NO;
}

BOOL SenplayerIO_SetLanguage(NSString *pLanguage) {
	if (SenplayerIO_DoSetLanguage(pLanguage)) {
		return YES;
	} else {
		int i;
		int max = [[NSLocale preferredLanguages] count];
		for (i = 0; i < max; i++) {
			NSString *language = [[NSLocale preferredLanguages] objectAtIndex:i];
			if (SenplayerIO_DoSetLanguage(language)) {
				return YES;
			}
		}
	}
	// Language not set
	return NO;
}

void SenplayerIO_Init (LuaController *pLuaController) {
	NSString *myBundlePath       = [[NSBundle mainBundle] bundlePath];
	NSString *myDocumentPath     = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	NSArray  *myResourcePathList = [[NSBundle mainBundle] pathsForResourcesOfType:SENPLAYERIO_RESOURCE_EXTENSION inDirectory:nil];
	NSString *myResourcePath;
	if (0 < [myResourcePathList count]) {
		myResourcePath = [myResourcePathList objectAtIndex:0];
	} else {
		myResourcePath = myBundlePath;
	}
    
    gBundlePath = myBundlePath;
    [gBundlePath retain];
    gResourcePath = myResourcePath;
    [gResourcePath retain];
    gDocumentPath = myDocumentPath;
    [gDocumentPath retain];

	luaL_Reg systemFunctions[] = {
		{"save", SenplayerIO_Save},
		{"load", SenplayerIO_Load},
		{"getFileList", SenplayerIO_GetFileList},
        {"getFilePath", SenplayerIO_GetFilePath},
        {"deleteFile", SenplayerIO_DeleteFile},
		{NULL, NULL}
	};
	
	gLuaController = pLuaController;
	[gLuaController retain];
	SenplayerIO_SetLanguage([[NSLocale preferredLanguages] objectAtIndex:0]);
	luaL_register(gLuaController.state, "senplayer", systemFunctions);
    lua_pop(gLuaController.state, 1);
	// Language Listing and Selected Language
	// NSLog(@"Locale Codes: %@", [NSLocale availableLocaleIdentifiers]);
	// NSLog(@"Preferred Languages: %@", [NSLocale preferredLanguages]);
	// NSLog(@"Selected Language %@", gLanguage);
}

NSString *SenplayerIO_GetResourcePath (NSString *pFilename) {
	NSString *path;
	int i;
	
	// Does this file have a localized override?
	path = [NSString stringWithFormat: @"%@/%@/%@", gResourcePath, gLanguage, pFilename];
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		return path;
	}
	
	// If not, it should be in the resource bundle.
	path = [NSString stringWithFormat: @"%@/%@", gResourcePath, pFilename];
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		return path;
	}
    
	// A few system resources live in the root bundle.
	path = [NSString stringWithFormat: @"%@/%@", gBundlePath, pFilename];
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		return path;
	}

    // The file may belong to the user.
	path = [NSString stringWithFormat: @"%@/%@", gDocumentPath, pFilename];
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		return path;
	}
    
	// Failing all of the above, we'll check all languages.
	for (i = 0; i < [[NSLocale preferredLanguages] count]; i++) {
		NSString *language = [[NSLocale preferredLanguages] objectAtIndex:i];
		path = [NSString stringWithFormat: @"%@/%@/%@", gResourcePath, language, pFilename];
		if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
			return path;
		}
	}
	
	// If all the above fails, the resource does not exist.
	return Nil;
}

NSString *SenplayerIO_DataPath (NSString *pFilename, NSString *pFileshare) {
	NSString *basePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	NSString *filename;
	
	if (pFileshare) {
		filename = [NSString stringWithFormat:@"shared-%@-%@.plist", pFileshare, pFilename];
	} else {
		filename = [NSString stringWithFormat:@"%@-%@.plist", [gLuaController getValueForKey:@"quest.info.id"], pFilename];
	}
	return [basePath stringByAppendingPathComponent:filename];
}

int SenplayerIO_Save (lua_State *L) {
	id filedata;
	NSString *filename;
	NSString *fileshare;
	NSData   *xmlData;
	NSString *path;
	NSString *error;
	
	// Validate arguments
	while (lua_gettop(L) < 3) {
		lua_pushnil(L);
	}
	lua_pop(L, lua_gettop(L) - 3);

	// Read arguments
	filedata  = [gLuaController getValueFromStack:1 forState:L atLevel:0];
	filename  = [gLuaController getValueFromStack:2 forState:L atLevel:0];
	fileshare = [gLuaController getValueFromStack:3 forState:L atLevel:0];
	
	// Save data and return results
	xmlData = [NSPropertyListSerialization dataFromPropertyList:filedata format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
	path = SenplayerIO_DataPath(filename, fileshare);
	lua_pushboolean(L, [xmlData writeToFile:path atomically:YES]);
	[gLuaController pushValueOnStack:error forState:L atLevel:0];
	return 2;
}

int SenplayerIO_Load (lua_State *L) {
	id filedata;
	NSString *filename;
	NSString *fileshare;
	NSPropertyListFormat format = NSPropertyListXMLFormat_v1_0;
	NSData *xmlData;
	NSString *path;
	NSString *error;
	
	// Validate arguments
	while (lua_gettop(L) < 2) {
		lua_pushnil(L);
	}
	lua_pop(L, lua_gettop(L) - 2);
	
	// Read arguments
	filename  = [gLuaController getValueFromStack:1 forState:L atLevel:0];
	fileshare = [gLuaController getValueFromStack:2 forState:L atLevel:0];
	
	// Load data and return results
	path = SenplayerIO_DataPath(filename, fileshare);
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
		lua_pushboolean(L, NO);
		[gLuaController pushValueOnStack:[NSString stringWithFormat:@"\"%@\" does not exist.", filename] forState:L atLevel:0];
		return 2;
	}
	xmlData = [NSData dataWithContentsOfFile:path];
	filedata = [NSPropertyListSerialization propertyListFromData:xmlData mutabilityOption:0 format:&format errorDescription:&error];
	lua_getglobal(L, "quest");
	lua_getfield(L, -1, "load");
	lua_remove(L, -2);
	[gLuaController pushValueOnStack:filedata forState:L atLevel:0];
	lua_pcall(L, 1, 1, 0);
	[gLuaController pushValueOnStack:error forState:L atLevel:0];
	return 2;
}

int SenplayerIO_GetFileList (lua_State *L) {
	[gLuaController pushValueOnStack:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] error:NULL] forState:L atLevel:0];
	return 1;
}

int SenplayerIO_GetFilePath (lua_State *L) {
    NSString *filename;
    NSString *path;
    
	// Validate arguments
	while (lua_gettop(L) < 1) {
		lua_pushnil(L);
	}
	lua_pop(L, lua_gettop(L) - 1);
    filename = [gLuaController getValueFromStack:1 forState:L atLevel:0];

    // If the file does not exist, it is a new file that belongs to the user.
    path = SenplayerIO_GetResourcePath(filename);
	if (!path) {
        path = [NSString stringWithFormat: @"%@/%@", gDocumentPath, filename];
	}
	[gLuaController pushValueOnStack:path forState:L atLevel:0];
	return 1;
}

int SenplayerIO_DeleteFile (lua_State *L) {
    NSString *filename;
    NSString *path;
    
	// Validate arguments
	while (lua_gettop(L) < 1) {
		lua_pushnil(L);
	}
	lua_pop(L, lua_gettop(L) - 1);
    filename = [gLuaController getValueFromStack:1 forState:L atLevel:0];
    path = [NSString stringWithFormat: @"%@/%@", gDocumentPath, filename];
    [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
	return 0;
}
