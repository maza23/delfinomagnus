//
//  AYDeviceSearchView.h
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/13/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYBaseCloseDelegate.h"

@interface AYDeviceSearchView : UIView
@property (weak, nonatomic) id <AYBaseCloseDelegate> delegate;
@end
