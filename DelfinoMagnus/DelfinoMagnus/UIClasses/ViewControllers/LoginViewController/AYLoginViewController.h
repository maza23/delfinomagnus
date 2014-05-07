//
//  AYLoginViewController.h
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/5/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AYLoginViewControllerDelegate;

@interface AYLoginViewController : UIViewController
@property (weak, nonatomic) id <AYLoginViewControllerDelegate> delegate;
@end


@protocol AYLoginViewControllerDelegate <NSObject>
- (void)didUserLoggedInSuccessfully;
@end