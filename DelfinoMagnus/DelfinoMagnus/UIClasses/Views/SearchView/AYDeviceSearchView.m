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
    
    if ([self.delegate respondsToSelector:@selector(didPressedCloseButtonOnView:)]) {
        [self.delegate didPressedCloseButtonOnView:self];
    }
    [self removeFromSuperview];
}

#pragma mark - Private Methods
- (void)loadSearchView
{
    NSString *nibName = kIsDeviceiPad ? @"AYSearchView~iPad": @"AYSearchView";
    AYSearchView *searchSubView = [[[NSBundle mainBundle]  loadNibNamed:nibName owner:self options:nil] lastObject];
    [self.scrollViewContainer addSubview:searchSubView];
    
    [searchSubView setFrame:self.bounds];
    
//    searchSubView.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    [self.scrollViewContainer addConstraints:[NSLayoutConstraint
//                               constraintsWithVisualFormat:@"V:|-0-[searchSubView]-0-|"
//                               options:NSLayoutFormatDirectionLeadingToTrailing
//                               metrics:nil
//                               views:NSDictionaryOfVariableBindings(searchSubView)]];
//    [self.scrollViewContainer addConstraints:[NSLayoutConstraint
//                               constraintsWithVisualFormat:@"H:|-0-[searchSubView]-0-|"
//                               options:NSLayoutFormatDirectionLeadingToTrailing
//                               metrics:nil
//                               views:NSDictionaryOfVariableBindings(searchSubView)]];

    self.searchView = searchSubView;
    if (!kIsDeviceiPad) {
        [self.scrollViewContainer setContentSize:self.searchView.bounds.size];
    }
    
    [self layoutIfNeeded];

    NSLog(@"Frame of scrollView is:%@ \nAnd content size of scrollView is:%@ \nAnd frame of search view is:%@", NSStringFromCGRect(self.scrollViewContainer.frame), NSStringFromCGSize(self.scrollViewContainer.contentSize), NSStringFromCGRect(self.searchView.frame));
}


@end
