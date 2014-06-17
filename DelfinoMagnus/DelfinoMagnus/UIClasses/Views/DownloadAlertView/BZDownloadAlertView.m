//
//  BZDownloadAlertView.m
//  Buzz
//
//  Created by Avadesh Kumar on 10/04/13.
//  Copyright (c) 2013 Telibrahma. All rights reserved.
//

#define alertViewWidth 280
#define alertViewHeight 40
#define kAlertMessageLabelWidth 234

#import "BZDownloadAlertView.h"
#import "BZDownloadView.h"

@interface BZDownloadAlertView () {

}
@property (nonatomic, strong) BZDownloadView *alertView;
@end

@implementation BZDownloadAlertView
@synthesize alertView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Public Methods
- (void)displayAlertViewWithMessage:(NSString *)alertMessage andAlertStyle:(BZDownloadAlertViewAlertStyle)alertStyle
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        @synchronized(self) {
            
            NSInteger yDeltaForStatusBar = 20;
            
            if ([[UIApplication sharedApplication] isStatusBarHidden]) {
                yDeltaForStatusBar = 0;
            }
            
            float heightOfAlertView = alertViewHeight;
            
            if (!alertView) {
                self.alertView = [[[NSBundle mainBundle] loadNibNamed:@"BZDownloadView" owner:self options:nil] lastObject];
                UIView *parentView = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];
                [parentView addSubview:alertView];
               
                [alertView setFrame:CGRectMake(parentView.bounds.size.width/2 - (alertViewWidth/2), -50, alertViewWidth, heightOfAlertView)];
                
                [UIView animateWithDuration:1.0 animations:^ {
                    
                    [alertView setFrame:CGRectMake(parentView.bounds.size.width/2 - (alertViewWidth/2), yDeltaForStatusBar + 5, alertViewWidth, heightOfAlertView)];
                    
                } completion:^ (BOOL finished) {

                }];
            }

            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(removeAlertView) object:nil];
            [self performSelector:@selector(removeAlertView) withObject:nil afterDelay:kAlertDisplayTime];
           
            [alertView.messageLabel setText:alertMessage];
           
//            if (alertStyle == BZDownloadAlertViewAlertStyleCompleted) {
//                [alertView.statusImageView setImage:[UIImage imageNamed:@"checkMark.png"]];
//            }
//            else {
//                [alertView.statusImageView setImage:[UIImage imageNamed:@"infoImage.png"]];
//            }
        }
    });
}


- (void)removeAlertView
{
    [UIView animateWithDuration:0.3 animations:^ {
        
        [self.alertView setAlpha:0.0];
        
    } completion:^ (BOOL finished) {
        [self.alertView removeFromSuperview];
        self.alertView = nil;
    }];
}

@end
