//
//  AppDelegate_Pad.h
//  AdventurePlayer
//
//  Created by Brendan A R Sechter on 10/06/01.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LuaController.h"
#import "ViewController_Pad.h"

@interface AppDelegate_Pad : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	ViewController_Pad *viewController;
	LuaController *lua;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ViewController_Pad *viewController;
@property (nonatomic, retain) LuaController *lua;

@end

