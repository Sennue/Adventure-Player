//
//  ViewController_Pad.m
//  AdventurePlayer
//
//  Created by Brendan A R Sechter on 10/07/27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ViewController_Pad.h"
#import "SenplayerIO.h"
#import "SenplayerCell.h"
#import "PopoverViewController.h"


@implementation ViewController_Pad

@synthesize popoverController;
@synthesize popoverViewController;
@synthesize contentView;
@synthesize toolbar;
@synthesize toolbarSpacer;
@synthesize menuButton;
@synthesize imageButton;
@synthesize nextButton;
@synthesize imageView;
@synthesize textView;
@synthesize choiceView;
@synthesize scrollView;
@synthesize promptLabel;
@synthesize inputField;

@synthesize orientation;
@synthesize lua;
@synthesize adController;


#pragma mark -
#pragma mark Setters and Getters

-(UIBarButtonItem *) popoverAnchorButton {
	NSNumber *anchorIndex = [lua getValueForKey:@"senplayer.menuAnchor"];
	switch ([anchorIndex intValue]) {
		case 1:
			return nextButton;
			break;
		case 2:
			return menuButton;
			break;
		case 3:
			return imageButton;
			break;
		default:
		break;
	}
	// default
	return nextButton;
}


#pragma mark -
#pragma mark Utility Functions

-(void) fixOrientation {
	CGFloat rotate;
	self.view.transform = CGAffineTransformIdentity;
	switch (orientation) {
		case UIInterfaceOrientationLandscapeLeft:
			rotate = 270;
			break;
		case UIInterfaceOrientationLandscapeRight:
			rotate = 90;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(180));
			return;
		case UIInterfaceOrientationPortrait:
		default:
			return;
	}
	self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(rotate));
	self.view.bounds = CGRectMake(0, 0, 1024, 748);
}

-(void) unloadSubNib {
	safe_release(promptLabel);
	safe_release(choiceView);
	safe_release(inputField);
	safe_release(textView);
	safe_release(imageView);
	safe_release(scrollView);
	safe_release(contentView);
}

-(void) unloadNib {
	safe_release(toolbarSpacer);
	safe_release(menuButton);
	safe_release(imageButton);
	safe_release(nextButton);
	safe_release(toolbar);
    [self unloadSubNib];
}

-(void) loadNib:(NSString *)nibName {
	CGRect rect = self.view.frame;
	[self unloadNib];
    // Animate here with UIView method
	[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
	self.view.frame = rect;
	[self fixOrientation];
}

-(void) loadSubNib:(NSString *)nibName {
	CGRect rect = self.contentView.frame;
    [self.contentView removeFromSuperview];
	[self unloadSubNib];
    NSArray *xib     = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    UIView * subView = [xib objectAtIndex:0];
    [self.view addSubview:subView];
    [self.view sendSubviewToBack:subView];
	self.contentView.frame = rect;
	[self fixOrientation];
    self.adController.contentView = self.contentView;
    self.adController.onTop = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
    [self.adController layoutAdBannerViewAnimated:TRUE];
}

-(void) closePopover {
	[popoverViewController release];
	[popoverController release];
}

-(void) loadPopover:(NSString *)nibName {
 	[self closePopover];
	if (nil == imageView) {
		[self loadTextPage];
        self.adController.onTop = [[UIDevice currentDevice] userInterfaceIdiom] == FALSE;
        [self.adController layoutAdBannerViewAnimated:TRUE];
	}
	popoverViewController = [[PopoverViewController alloc] initWithNibName:nibName bundle:nil];
	popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverViewController];
	((PopoverViewController *)popoverViewController).mainViewController = self;
	popoverController.delegate = self;
	popoverViewController.view.backgroundColor = [self getColor:@"senplayer.backgroundColor" withAlpha:0.5];
	[popoverController setPopoverContentSize:popoverViewController.view.frame.size];
}

-(UIColor *) getColor:(NSString *)pKey withAlpha:(float)pAlpha {
	NSNumber *red        = [lua getValueForKey:[NSString stringWithFormat:@"%@.red", pKey]];
	NSNumber *green      = [lua getValueForKey:[NSString stringWithFormat:@"%@.green", pKey]];
	NSNumber *blue       = [lua getValueForKey:[NSString stringWithFormat:@"%@.blue", pKey]];
	NSNumber *hue        = [lua getValueForKey:[NSString stringWithFormat:@"%@.hue", pKey]];
	NSNumber *saturation = [lua getValueForKey:[NSString stringWithFormat:@"%@.saturation", pKey]];
	NSNumber *brightness = [lua getValueForKey:[NSString stringWithFormat:@"%@.brightness", pKey]];
	UIColor *result;
	
	if (Nil != red) {
		result = [UIColor colorWithRed:[red floatValue] green:[green floatValue] blue:[blue floatValue] alpha:pAlpha];
	} else if (Nil != hue) {
		result = [UIColor colorWithHue:[hue floatValue] saturation:[saturation floatValue] brightness:[brightness floatValue] alpha:pAlpha];
	} else {
		result = [UIColor colorWithWhite:0.0 alpha:pAlpha];
	}
	return result;
}

-(UIColor *) getColor:(NSString *)pKey {
	return [self getColor:pKey withAlpha:1.0];
}

-(void) loadCommon {
	NSString *artFilename = [lua getValueForKey:@"senplayer.artFilename"];
	NSString *artFiletype = [lua getValueForKey:@"senplayer.artFiletype"];
	NSString *path = [NSString stringWithFormat: @"%@.%@", artFilename, artFiletype];
	path = SenplayerIO_GetResourcePath(path);
	UIImage  *image = [UIImage imageWithContentsOfFile:path];
	imageView.image = image;
	imageView.opaque = FALSE;
	imageView.alpha = [[lua getValueForKey:@"senplayer.artAlpha"] floatValue];
	self.contentView.backgroundColor = [self getColor:@"senplayer.backgroundColor"];
}

-(void) alignArtPage {
	CGFloat xZoom = scrollView.frame.size.width  / imageView.image.size.width;
	CGFloat yZoom = scrollView.frame.size.height / imageView.image.size.height;
	if (xZoom < yZoom) {
		scrollView.minimumZoomScale = yZoom;
	} else {
		scrollView.minimumZoomScale = xZoom;
	}
}

-(void) loadArtPage {
	CGFloat xOffset;
	CGFloat yOffset;
	[self loadSubNib:@"ArtView_Pad"];
	[self loadCommon];
	scrollView.contentSize = imageView.image.size;
	imageView.opaque = TRUE;
	imageView.alpha  = 1.0;
	imageView.frame = CGRectMake(0.0, 0.0, imageView.image.size.width, imageView.image.size.height);
	[self alignArtPage];
	[scrollView setZoomScale:scrollView.minimumZoomScale];
	xOffset = (imageView.image.size.width  * scrollView.minimumZoomScale - scrollView.frame.size.width ) / 2;
	yOffset = (imageView.image.size.height * scrollView.minimumZoomScale - scrollView.frame.size.height) / 2;
	[scrollView setContentOffset:CGPointMake(xOffset, yOffset)];
}

-(void) loadChoicePage {
	[self loadSubNib:@"TextView_Pad"];
	[self loadCommon];
	[self loadPopover:@"ChoiceView_Pad"];
	self.promptLabel.text = [lua getValueForKey:@"senplayer.prompt"];
	self.promptLabel.textColor = [self getColor:@"senplayer.textColor"];
	[lua doString:@"senplayer.choiceIndex = 1"];
	[lua doString:@"senplayer.choiceName = senplayer.choiceList[1][1].choice"];
	[lua doString:@"senplayer.choiceSection = 1"];
	[popoverController presentPopoverFromBarButtonItem:[self popoverAnchorButton] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	self.textView.text = [lua getValueForKey:@"senplayer.text"];
	self.textView.textColor = [self getColor:@"senplayer.textColor"];
}

-(void) loadInputPage {
	NSString *inputType = [lua getValueForKey:@"senplayer.inputType"];
	[self loadSubNib:@"TextView_Pad"];
	[self loadCommon];
	[self loadPopover:@"InputView_Pad"];
	self.promptLabel.text = [lua getValueForKey:@"senplayer.prompt"];
	self.promptLabel.textColor = [self getColor:@"senplayer.textColor"];
	self.inputField.placeholder = [lua getValueForKey:@"tostring(senplayer.inputDefault)"];
	if (NSOrderedSame == [inputType localizedCaseInsensitiveCompare:@"text"]) {
		self.inputField.keyboardType = UIKeyboardTypeDefault;
	} else /* "number" */ {
		self.inputField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	}
	self.inputField.returnKeyType = UIReturnKeyDone;
	[popoverController presentPopoverFromBarButtonItem:[self popoverAnchorButton] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	self.textView.text = [lua getValueForKey:@"senplayer.text"];
	self.textView.textColor = [self getColor:@"senplayer.textColor"];
}

-(void) loadTextPage {
	[self loadSubNib:@"TextView_Pad"];
	[self loadCommon];
	self.textView.text = [lua getValueForKey:@"senplayer.text"];
	self.textView.textColor = [self getColor:@"senplayer.textColor"];
}

-(void) syncInput {
	NSString *pageType = [lua getValueForKey:@"senplayer.pageType"];
	if (NSOrderedSame == [pageType localizedCaseInsensitiveCompare:@"input"]) {
		NSString *inputType = [lua getValueForKey:@"senplayer.inputType"];
		if (0 == inputField.text.length) {
			[lua doString:[NSString stringWithFormat:@"senplayer.input = senplayer.inputDefault"]];
		} else {
			[lua setKey:@"senplayer.input" toValue:inputField.text];
			if (NSOrderedSame == [inputType localizedCaseInsensitiveCompare:@"number"]) {
				[lua doString:@"senplayer.input = tonumber(senplayer.input) or senplayer.inputDefault"];
			}
		}
	}
}

-(void) resetQuest {
	[lua doString:@"senplayer.done = false"];
	[lua doString:@"quest.start({})"];
	[self nextAction];
}

-(void) autoloadQuest {
    if (nil == self.toolbar) {
        [self loadNib:@"MenuView_Pad"];
        self.adController                = [[AdBannerViewController alloc] init];
        self.adController.viewController = self;
        self.adController.view           = self.view;
        self.adController.menuView       = self.toolbar;
        self.adController.contentView    = self.contentView;
        self.adController.onTop          = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
        [self.adController viewDidLoadEnable:TRUE];
    }
	[lua doString:@"senplayer.done = false"];
	[lua doString:@"quest.start({})"];
	[lua doString:@"senplayer.load('autosave')"];
	[self nextAction];
}

-(void) autosaveQuest {
	[lua doString:@"quest.save('autosave')"];
}

-(void) updateQuest:(NSString *)pUpdateCommand {
	NSString *pageType;
	BOOL done = [[lua getValueForKey:@"senplayer.done"] intValue];
	if (done) {
		[self resetQuest];
		return;
	}
	[self syncInput];
	[popoverController dismissPopoverAnimated:YES];
	[lua doString:pUpdateCommand];
	pageType = [lua getValueForKey:@"senplayer.pageType"];
	if (NSOrderedSame == [pageType localizedCaseInsensitiveCompare:@"text"]) {
		[self loadTextPage];
	} else if (NSOrderedSame == [pageType localizedCaseInsensitiveCompare:@"choice"]) {
		[self loadChoicePage];
	} else if (NSOrderedSame == [pageType localizedCaseInsensitiveCompare:@"input"]) {
		[self loadInputPage];
	} else /* @"art" */ {
		[self loadArtPage];
	}
	[self autosaveQuest];
}


#pragma mark -
#pragma mark Button Actions

-(IBAction) nextAction {
	[self updateQuest:@"quest.resume()"];
}

-(IBAction) imageAction {
	[self updateQuest:@"quest.image()"];
}

-(IBAction) menuAction {
	[self updateQuest:@"quest.menu()"];
}


#pragma mark -
#pragma mark Popover Controller Delegate

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
	return NO;
}


#pragma mark -
#pragma mark Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self nextAction];
	return YES;
}


#pragma mark -
#pragma mark Scroll View Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
}


#pragma mark -
#pragma mark Initialization

/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 if ((self = [super initWithStyle:style])) {
 }
 return self;
 }
 */


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.adController viewDidAppear:animated];
}

/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	orientation = interfaceOrientation;
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.adController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	NSString *pageType = [lua getValueForKey:@"senplayer.pageType"];
	if (NSOrderedSame == [pageType localizedCaseInsensitiveCompare:@"art"]) {
		[self alignArtPage];
	}
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[lua getValueForKey:@"#(senplayer.choiceList)"] intValue];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[lua getValueForKey:[NSString stringWithFormat:@"#(senplayer.choiceList[%d])", section + 1]] intValue];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger) section {
    // Return the section title.
    return [lua getValueForKey:[NSString stringWithFormat:@"senplayer.choiceList[%d].section or ''", section + 1]];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UIColor  *textColor;
	NSString *artFilename;
	NSString *artFiletype;
	NSString *path;
	UIImage  *image;	
    
    SenplayerCell *cell = (SenplayerCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[SenplayerCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	
	artFilename = [lua getValueForKey:[NSString stringWithFormat:@"senplayer.choiceList[%d][%d].artFilename", indexPath.section + 1, indexPath.row + 1]];
	artFiletype = [lua getValueForKey:[NSString stringWithFormat:@"senplayer.choiceList[%d][%d].artFiletype", indexPath.section + 1, indexPath.row + 1]];
	if ((Nil != artFilename) && (Nil != artFiletype)) {
		path = [NSString stringWithFormat: @"%@.%@", artFilename, artFiletype];
		path = SenplayerIO_GetResourcePath(path);
		image = [UIImage imageWithContentsOfFile:path];
		cell.imageView.image = image;
	} else {
		cell.imageView.image = Nil;
	}
	
    // Configure the cell...
	[lua doString:@"quest.nextColor() quest.setColor(quest.nextColor(),0.3)"];
	textColor = [self getColor:@"senplayer.textColor"];
	cell.textLabel.text              = [lua getValueForKey:[NSString stringWithFormat:@"senplayer.choiceList[%d][%d].choice", indexPath.section + 1, indexPath.row + 1]];
	cell.textLabel.textColor         = textColor;
	cell.quantityTextLabel.text      = [lua getValueForKey:[NSString stringWithFormat:@"senplayer.choiceList[%d][%d].quantity", indexPath.section + 1, indexPath.row + 1]];
    cell.quantityTextLabel.textColor = textColor;
	cell.detailTextLabel.text        = [lua getValueForKey:[NSString stringWithFormat:@"senplayer.choiceList[%d][%d].description", indexPath.section + 1, indexPath.row + 1]];
    cell.detailTextLabel.textColor   = textColor;
	// 	cell.detailTextLabel.text = @"dsklfjsljflksdjflksdjf slkdfjsldj lskdjfl lwjefr lsdkl fjlse klsj dlsj ekl jslkdj lewk jlsdkj flkewjkl jfskldj dsklfjsljflksdjflksdjf slkdfjsldj lskdjfl lwjefr lsdkl fjlse klsj dlsj ekl jslkdj lewk jlsdkj flkewjkl jfskldj";
    return cell;
}


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	SenplayerCell *cell = (SenplayerCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
	[cell layoutSubviews];
	return cell.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[lua doString:[NSString stringWithFormat:@"senplayer.choiceIndex = %d", indexPath.row + 1]];
	[lua doString:[NSString stringWithFormat:@"senplayer.choiceName = senplayer.choiceList[%d][%d].choice", indexPath.section + 1, indexPath.row + 1]];
	[lua doString:[NSString stringWithFormat:@"senplayer.choiceSection = %d", indexPath.section + 1]];
	[self nextAction];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [self.adController viewDidUnload];
    [super viewDidUnload];
}

- (void)dealloc {
    [super dealloc];
}


@end
