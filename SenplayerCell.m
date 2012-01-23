//
//  SenplayerCell.m
//  AdventurePlayer
//
//  Created by Brendan A R Sechter on 10/06/15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SenplayerCell.h"


@implementation SenplayerCell

@synthesize imageView;
@synthesize textLabel;
@synthesize quantityTextLabel;
@synthesize detailTextLabel;
@synthesize height;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		imageView = [[UIImageView alloc] init];
		[self.contentView addSubview:imageView];
		textLabel = [[UILabel alloc] init];
		textLabel.font = [UIFont boldSystemFontOfSize:14];
		textLabel.textAlignment = UITextAlignmentLeft;
		textLabel.numberOfLines = 0;
		textLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:textLabel];
		quantityTextLabel = [[UILabel alloc] init];
		quantityTextLabel.font = [UIFont systemFontOfSize:14];
		quantityTextLabel.textAlignment = UITextAlignmentRight;
		quantityTextLabel.numberOfLines = 0;
		quantityTextLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:quantityTextLabel];
		detailTextLabel = [[UILabel alloc] init];
		detailTextLabel.font = [UIFont systemFontOfSize:10];
		detailTextLabel.textAlignment = UITextAlignmentLeft;
		detailTextLabel.numberOfLines = 0;
		detailTextLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:detailTextLabel];
		height = 0;
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGFloat spacing = 10.0;
	CGRect contentRect = self.contentView.bounds;
	CGFloat boundX = contentRect.origin.x;
	CGFloat boundY = contentRect.origin.y;
	CGFloat x, y, w, h;

	x = boundX + spacing;
	y = boundY + spacing;
	if (imageView.image) {
		w = imageView.image.size.width;
		h = imageView.image.size.height;
		height = y + h + spacing;
	} else {
		w = 0;
		h = 0;
		height = 0;
	}
	imageView.frame = CGRectMake(x, y, w, h);
	
	// y = y; h = h;
	if (0 < w) {
		// |<------ contentRect.size.width ------>|
		// |    |<-- w -->|                       | (old w)
		// | >> x >>>>>>> w >> s ........... s << | (calculation with old values)
		// |<------- x ------->|<---- w ---->|    | (new w and x)
		x = x + w + spacing;
	}
	w = contentRect.size.width - x - spacing;  // w and (1 * spacing) wrapped in x
	textLabel.frame = CGRectMake(x, y, w, h);
	[textLabel sizeToFit];
	
	// x = x; y = y; w = w; h = h;
	if (textLabel.text) {
		CGSize textLabelSize         = [[textLabel text] sizeWithFont:[textLabel font]];
		CGSize quantityTextLabelSize = [[quantityTextLabel text] sizeWithFont:[quantityTextLabel font]];
		if (w < (textLabelSize.width + quantityTextLabelSize.width)) {
			y = y + textLabel.frame.size.height + spacing;
		}
	}
	quantityTextLabel.frame = CGRectMake(x, y, w, h);
	[quantityTextLabel sizeToFit];
	quantityTextLabel.frame = CGRectMake(x, y, w, quantityTextLabel.frame.size.height);

	// x = x; w = w; h = h
	if (textLabel.text || quantityTextLabel.text) {
		CGFloat textLabelY         = textLabel.frame.origin.y + textLabel.frame.size.height;
		CGFloat	quantityTextLabelY = quantityTextLabel.frame.origin.y + quantityTextLabel.frame.size.height;
		y = spacing + (textLabelY < quantityTextLabelY ? quantityTextLabelY : textLabelY);
	}
	detailTextLabel.frame = CGRectMake(x, y, w, h);
	[detailTextLabel sizeToFit];
	
	h = detailTextLabel.frame.size.height;
	h = y + h + spacing;
	if (height < h) {
		height = h;
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[textLabel release];
	[quantityTextLabel release];
	[detailTextLabel release];
	[imageView release];
    [super dealloc];
}


@end
