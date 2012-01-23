//
//  SenplayerIO.h
//  AdventurePlayer
//
//  Created by Brendan A R Sechter on 10/06/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LuaController.h"

void SenplayerIO_Init (LuaController *pLuaController);
NSString *SenplayerIO_GetResourcePath (NSString *pFilename);

int SenplayerIO_Save (lua_State *L);
int SenplayerIO_Load (lua_State *L);
int SenplayerIO_GetFileList (lua_State *L);
int SenplayerIO_GetFilePath (lua_State *L);
int SenplayerIO_DeleteFile (lua_State *L);
