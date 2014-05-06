//
//  AYForgotPasswordView.m
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/6/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import "AYForgotPasswordView.h"

@interface AYForgotPasswordView ()
@property (weak, nonatomic) IBOutlet UITextField *txtFieldEmailId;

@end


@implementation AYForgotPasswordView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


#pragma mark - IBAction Methods
- (IBAction)actionCloseButtonPressed:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)actionSendMailButtonPressed:(id)sender {
    
}

@end
