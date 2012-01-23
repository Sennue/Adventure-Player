//
//  PopoverController.m
//  AdventurePlayer
//
//  Created by Brendan A R Sechter on 10/08/02.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PopoverViewController.h"


@implementation PopoverViewController

@synthesize mainViewController;
@synthesize choiceView;
@synthesize promptLabel;
@synthesize inputField;
@synthesize lua;


#pragma mark -
#pragma mark Setters and Getters

-(ViewController_Pad *)mainViewController {
	return mainViewController;
}

-(void)setMainViewController:(ViewController_Pad *)pMainViewController {
	[pMainViewController retain];
	[mainViewController release];
	mainViewController = pMainViewController;
	
	lua = mainViewController.lua;
	choiceView.dataSource = mainViewController;
	choiceView.delegate   = mainViewController;
	inputField.delegate   = mainViewController;
	mainViewController.choiceView  = choiceView;
	mainViewController.promptLabel = promptLabel;
	mainViewController.inputField  = inputField;
}


#pragma mark -
#pragma mark Life Cycle

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
