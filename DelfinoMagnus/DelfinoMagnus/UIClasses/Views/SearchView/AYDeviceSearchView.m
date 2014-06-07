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
    [self doInitialConfigurations];
}

#pragma mark - IBAction Methods
- (IBAction)actionMenuButtonPressed:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didPressedCloseButtonOnView:)]) {
        [self.delegate didPressedCloseButtonOnView:self];
    }
    
    [self removeFromSuperview];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private Methods
- (void)doInitialConfigurations
{
    [self doAppearenceSettingsForOrientation:[[UIDevice currentDevice] orientation]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangedOrientation:) name:kDeviceWillChangeOrientation object:nil];
}

- (void)didChangedOrientation:(id)notifiObject
{
    NSInteger newOrientation = [[[notifiObject userInfo] objectForKey:@"NewOrientation"] integerValue];
    
    [self doAppearenceSettingsForOrientation:newOrientation];
}

- (void)doAppearenceSettingsForOrientation:(NSInteger)orientation
{
    if (kIsDeviceiPad) {
        return;
    }
    
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        CGRect frame = self.searchView.frame;
        frame.size.height = 1400;
        [self.searchView setFrame:frame];
    }
    
    NSLog(@"The frame of the search vieiiw is:%@", NSStringFromCGRect(self.searchView.frame));
    [self layoutIfNeeded];
}

- (void)loadSearchView
{
    NSString *nibName = kIsDeviceiPad ? @"AYSearchView~iPad": @"AYSearchView";
    AYSearchView *searchSubView = [[[NSBundle mainBundle]  loadNibNamed:nibName owner:self options:nil] lastObject];
    [self.scrollViewContainer addSubview:searchSubView];
    
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
    else {
        [searchSubView setFrame:self.bounds];
    }
    

    [self layoutIfNeeded];
}


@end
