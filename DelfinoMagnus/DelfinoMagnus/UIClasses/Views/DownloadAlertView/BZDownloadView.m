//
//  BZDownloadView.m
//  Buzz
//
//  Created by Avadesh Kumar on 10/04/13.
//  Copyright (c) 2013 Telibrahma. All rights reserved.
//

#import "BZDownloadView.h"

@implementation BZDownloadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [self doInitialAppearenceSettings];
}


#pragma mark - Private Methods
- (void)doInitialAppearenceSettings
{
    float fontSize = kIsDeviceiPad ? 16.0f : 15.0f;
    [_messageLabel setFont:[UIFont fontWithName:@"Century Gothic" size:fontSize]];

    [self.layer setCornerRadius:5.0];
    
    [self.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.layer setShadowOpacity:1.0];
    [self.layer setShadowOffset:CGSizeMake(0, 0)];
}
@end
