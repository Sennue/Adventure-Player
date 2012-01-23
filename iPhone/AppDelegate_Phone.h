//
//  AppDelegate_Phone.h
//  AdventurePlayer
//
//  Created by Brendan A R Sechter on 10/06/01.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LuaController.h"
#import "ViewController_Phone.h"

@interface AppDelegate_Phone : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	ViewController_Phone *adController;
	ViewController_Phone *viewController;
	LuaController *lua;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ViewController_Phone *viewController;
//@property (nonatomic, retain) IBOutlet ViewController_Phone *viewController;
@property (nonatomic, retain) LuaController *lua;

@end

