//
//  iAdController.h
//  Ad Viewer
//
//  Created by A R Sechter Brendan on 11/12/06.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iAd/ADBannerView.h"

@interface AdBannerViewController : NSObject <ADBannerViewDelegate>
{
    UIViewController *  viewController;
    UIView *            view;
    UIView *            menuView;
    UIView *            contentView;
    ADBannerView *      adBannerView;
    BOOL                onTop;
}

@property (nonatomic, retain) UIViewController *        viewController;
@property (nonatomic, retain) IBOutlet UIView *         view;
@property (nonatomic, retain) IBOutlet UIView *         menuView;
@property (nonatomic, retain) IBOutlet UIView *         contentView;
@property (nonatomic, retain) IBOutlet ADBannerView *   adBannerView;
@property (readwrite, assign) BOOL                      onTop;
@property (readonly,  assign) BOOL                      disableAds;

- (void)viewDidLoadEnable:(BOOL)enable;
- (void)viewDidUnload;
- (void)viewDidAppear:(BOOL)animated;
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
- (void)layoutAdBannerViewAnimated:(BOOL)animated;
- (void)enable;
- (void)disable;
- (void)toggle;

@end

