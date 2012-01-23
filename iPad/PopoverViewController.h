//
//  PopoverController.h
//  AdventurePlayer
//
//  Created by Brendan A R Sechter on 10/08/02.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LuaController.h"
#import "ViewController_Pad.h"


@interface PopoverViewController : UIViewController {
	ViewController_Pad *mainViewController;
	UITableView *choiceView;
	UILabel *promptLabel;
	UITextField *inputField;
	LuaController *lua;
}

@property (nonatomic, retain) ViewController_Pad *mainViewController;
@property (nonatomic, retain) IBOutlet UITableView *choiceView;
@property (nonatomic, retain) IBOutlet UILabel *promptLabel;
@property (nonatomic, retain) IBOutlet UITextField *inputField;
@property (nonatomic, retain) LuaController *lua;

@end
