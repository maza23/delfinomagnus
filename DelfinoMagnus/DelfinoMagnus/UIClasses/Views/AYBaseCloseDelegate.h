//
//  AYBaseCloseDelegate.h
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/31/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AYBaseCloseDelegate <NSObject>
- (void)didPressedCloseButtonOnView:(UIView *)view;
@end
