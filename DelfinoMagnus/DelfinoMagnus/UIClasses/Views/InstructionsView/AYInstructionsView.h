//
//  AYInstructionsView.h
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 6/15/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AYInstructionsViewDelegate;

@interface AYInstructionsView : UIView
@property (weak, nonatomic) id <AYInstructionsViewDelegate> delegate;
@end


@protocol AYInstructionsViewDelegate <NSObject>
- (void)didPressedCloseButtonOnHelpScreen;
@end