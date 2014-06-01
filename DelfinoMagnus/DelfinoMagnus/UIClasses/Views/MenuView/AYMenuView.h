//
//  AYMenuView.h
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/8/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYBaseCloseDelegate.h"

@interface AYMenuView : UIView
@property (weak, nonatomic) id <AYBaseCloseDelegate> delegate;
@end

