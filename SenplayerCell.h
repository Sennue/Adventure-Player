//
//  SenplayerCell.h
//  AdventurePlayer
//
//  Created by Brendan A R Sechter on 10/06/15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SenplayerCell : UITableViewCell {
	UIImageView *imageView;
	UILabel *textLabel;
	UILabel *quantityTextLabel;
	UILabel *detailTextLabel;
	CGFloat height;
}
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel *textLabel;
@property (nonatomic, retain) UILabel *quantityTextLabel;
@property (nonatomic, retain) UILabel *detailTextLabel;
@property (nonatomic, assign) CGFloat height;

@end
