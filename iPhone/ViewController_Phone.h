//
//  ViewController_Phone.h
//  AdventurePlayer
//
//  Created by Brendan A R Sechter on 10/06/04.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LuaController.h"
#import "AdBannerViewController.h"


@interface ViewController_Phone : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIScrollViewDelegate> {
    UIView *               contentView;
	UIToolbar *            toolbar;
	UIBarButtonItem *      toolbarSpacer;
	UIBarButtonItem *      menuButton;
	UIBarButtonItem *      imageButton;
	UIBarButtonItem *      nextButton;
	UIImageView *          imageView;
	UITextView *           textView;
	UITableView *          choiceView;
	UIScrollView *         scrollView;
	UILabel *              promptLabel;
	UITextField *          inputField;
	LuaController *        lua;
	UIInterfaceOrientation orientation;
}

@property (nonatomic, retain) IBOutlet UIView *          contentView;
@property (nonatomic, retain) IBOutlet UIToolbar *       toolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * toolbarSpacer;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * menuButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * imageButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * nextButton;
@property (nonatomic, retain) IBOutlet UIImageView *     imageView;
@property (nonatomic, retain) IBOutlet UITextView *      textView;
@property (nonatomic, retain) IBOutlet UITableView *     choiceView;
@property (nonatomic, retain) IBOutlet UIScrollView *    scrollView;
@property (nonatomic, retain) IBOutlet UILabel *         promptLabel;
@property (nonatomic, retain) IBOutlet UITextField *     inputField;
@property (nonatomic, retain) LuaController *            lua;
@property (nonatomic, retain) AdBannerViewController *   adController;
@property (nonatomic, assign) UIInterfaceOrientation     orientation;

-(IBAction) menuAction;
-(IBAction) imageAction;
-(IBAction) nextAction;
-(void)     resetQuest;
-(void)     autoloadQuest;


#define degreesToRadians(x) (M_PI * (x) / 180.0)
#define safe_release(outlet) \
	if (nil != (outlet)) {   \
		[(outlet) release];  \
		(outlet) = Nil;      \
	}

@end
