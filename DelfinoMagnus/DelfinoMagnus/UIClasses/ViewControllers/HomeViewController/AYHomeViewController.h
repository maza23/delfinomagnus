//
//  AYHomeViewController.h
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/5/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYHomeViewController : UIViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void)showMapWithMarkerDevices:(NSArray *)devicesList withToDo:(BOOL)showToDo;
@end
