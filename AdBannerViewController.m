//
//  iAdController.m
//  Ad Viewer
//
//  Created by A R Sechter Brendan on 11/12/06.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "AdBannerViewController.h"

@implementation AdBannerViewController

@synthesize viewController;
@synthesize view;
@synthesize menuView;
@synthesize contentView;
@synthesize adBannerView;
@synthesize onTop;
@synthesize disableAds;

#pragma mark - Banner Layout

- (CGRect)layoutMenu
{
    CGRect contentFrame = view.bounds;
    if (menuView) {
        int menuHeight = menuView.frame.size.height;
        int menuY      = menuView.frame.origin.y;
        int contentY   = contentView.frame.origin.y;
        contentFrame.size.height -= menuHeight;
        if (menuY <= contentY) {
            contentFrame.origin.y += menuHeight;
        }
    }
    return contentFrame;
}

- (void)layoutEnabledAdBannerViewAnimated:(BOOL)animated
{
    if (UIInterfaceOrientationIsPortrait(viewController.interfaceOrientation)) {
        adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    } else /* Landscape */ {
        adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    }

    CGRect bannerFrame  = adBannerView.frame;
    CGRect contentFrame = [self layoutMenu];
    if (disableAds || !adBannerView.bannerLoaded) {
        bannerFrame.origin.y     = -adBannerView.frame.size.height;
    } else if (adBannerView.bannerLoaded && onTop) {
        bannerFrame.origin.y     =  contentFrame.origin.y;
        contentFrame.origin.y    += adBannerView.frame.size.height;
        contentFrame.size.height -= adBannerView.frame.size.height;
    } else /* if (adBannerView.bannerLoaded  && on Bottom  ) */ {
        contentFrame.size.height -= adBannerView.frame.size.height;
        bannerFrame.origin.y     =  contentFrame.origin.y + contentFrame.size.height;
    }
   
    [UIView animateWithDuration:animated ? 0.25 : 0.0 animations:^{
        contentView.frame = contentFrame;
        [contentView layoutIfNeeded];
        adBannerView.frame = bannerFrame;
    }];
    [self.view bringSubviewToFront:adBannerView];
}

- (void)layoutDisabledAdBannerViewAnimated:(BOOL)animated
{
    CGRect contentFrame = [self layoutMenu];
    [UIView animateWithDuration:animated ? 0.25 : 0.0 animations:^{
        contentView.frame = contentFrame;
        [contentView layoutIfNeeded];
    }];
}

- (void)layoutAdBannerViewAnimated:(BOOL)animated
{
    if (disableAds) {
        [self layoutDisabledAdBannerViewAnimated:animated];
    } else {
        [self layoutEnabledAdBannerViewAnimated:animated];
    }
}

#pragma mark - Toggle Ads

- (void)enable
{
    if (!adBannerView) {
        adBannerView = [[ADBannerView alloc] init];
        adBannerView.delegate = self;
        [self.view addSubview: adBannerView];
    }
    disableAds = FALSE;
    [self layoutAdBannerViewAnimated:TRUE];
}

- (void)disable
{
    if (adBannerView) {
        [adBannerView removeFromSuperview];
        adBannerView.delegate = nil;
        adBannerView          = nil;
    }
    disableAds = TRUE;
    [self layoutAdBannerViewAnimated:TRUE];
}

- (void)toggle
{
    if (disableAds) {
        [self enable];
    } else {
        [self disable];
    }
}

#pragma mark - UIViewController Messages

- (void)viewDidLoadEnable:(BOOL)enable
{
    if (enable) {
        [self enable];
    } else {
        [self disable];
    }
}

- (void)viewDidUnload
{
    [self disable];
    viewController          = nil;
    view                    = nil;
    contentView             = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self layoutAdBannerViewAnimated:NO];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    } else {
        adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    }
    [self layoutAdBannerViewAnimated:duration > 0.0];
}

#pragma mark - ADBannerViewDelegate Methods

- (void)bannerViewWillLoadAd:(ADBannerView *)banner
{
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self layoutAdBannerViewAnimated:YES];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"didFailToReceiveAdWithError();");
    [self layoutAdBannerViewAnimated:YES];
}

#pragma mark - init / dealloc

- (id)init
{
    self = [super init];
    if (self) {
    //    [self enable];
    }
    return self;
}

- (void)dealloc {
    if (adBannerView) {
        adBannerView.delegate = nil;
        adBannerView          = nil;
    }
    contentView           = nil;
    view                  = nil;
    viewController        = nil;
}

@end
