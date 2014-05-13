//
//  AYDeviceSearchView.m
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/13/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import "AYDeviceSearchView.h"
#import "AYSearchView.h"

@interface AYDeviceSearchView ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewContainer;
@property (strong, nonatomic) AYSearchView *searchView;

@end

@implementation AYDeviceSearchView

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
    [super awakeFromNib];
    [self loadSearchView];
}
#pragma mark - IBAction Methods
- (IBAction)actionMenuButtonPressed:(id)sender {
    [self removeFromSuperview];
}

#pragma mark - Private Methods
- (void)loadSearchView
{
    self.searchView = [[[NSBundle mainBundle]  loadNibNamed:@"AYSearchView" owner:self options:nil] lastObject];
    [self.scrollViewContainer addSubview:self.searchView];
    
    [self.scrollViewContainer setContentSize:self.searchView.bounds.size];
}


@end
