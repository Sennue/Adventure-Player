//
//  AppDelegate_Pad.m
//  AdventurePlayer
//
//  Created by Brendan A R Sechter on 10/06/01.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "AppDelegate_Pad.h"
#import "SenplayerIO.h"

@implementation AppDelegate_Pad

@synthesize window;
@synthesize viewController;
@synthesize lua;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	lua = [[LuaController alloc] init];
	//NSNumber *max;
	//int i;
	
	SenplayerIO_Init(lua);
	lua.getResourcePath = SenplayerIO_GetResourcePath;
	[lua doFile:@"senplayer.aqd"];
	[lua doFile:@"message.aqd"];
	[lua doFile:@"quest.aqd"];
	//[lua doFile:@"sentag.lua"];
	//[lua doFile:@"senplayer.lua"];
	//[lua doFile:@"info.lua"];
	//max = [lua getValueForKey:@"#(quest.info.load)"];
	
	//for (i = 0; i < [max intValue]; i++) {
	//	[lua doFile:[lua getValueForKey:[NSString stringWithFormat: @"quest.info.load[%d]", i + 1]]];
	//}
	viewController.lua = lua;

    [window addSubview:viewController.view];
	[viewController autoloadQuest];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
	[lua release];
    [viewController release];
    [window release];
    [super dealloc];
}


@end
