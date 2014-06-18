//
//  AYInstructionsView.m
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 6/15/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import "AYInstructionsView.h"

@interface AYInstructionsView () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewImagesContainer;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControlImageNumber;
@property (weak, nonatomic) IBOutlet UIButton *btnCerrar;

@property (strong, nonatomic) NSArray *images;
@end

@implementation AYInstructionsView

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
    [self doInitialConfigurations];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private Methods
- (void)doInitialConfigurations
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangedOrientation:) name:kDeviceDidChangeOrientation object:nil];
    
    [self.btnCerrar setImage:[[UIImage imageNamed:@"cerrar.png"] imageWithOverlayColor:[UIColor colorWithRed:225.0/255.0 green:164.0/255.0 blue:74.0/255.0 alpha:1.0]] forState:UIControlStateNormal];


    self.images = @[@"help_1.png", @"help_2.png", @"help_3.png", @"help_4.png"];
    [self loadScrollView];
}

- (void)didChangedOrientation:(id)notifiObject
{
    if (kIsDeviceiPad) 
        return;
    
    for (UIView *subView in [self.scrollViewImagesContainer subviews]) {
        [subView removeFromSuperview];
    }
    
    [self loadScrollView];
}

- (void)loadScrollView
{
    for (int index = 0; index < 4; index++) {
        
        CGRect frame = self.scrollViewImagesContainer.bounds;
        frame.origin.x = index * frame.size.width;
        
        UIImageView *imageView = [[UIImageView alloc]  initWithFrame:frame];
        [imageView setImage:[UIImage imageNamed:self.images[index]]];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.scrollViewImagesContainer addSubview:imageView];
        
        if (index == 3) {
            [self addRemeberMeCheckBox];
        }
    }
    
    [self.scrollViewImagesContainer setContentSize:CGSizeMake(self.scrollViewImagesContainer.bounds.size.width * [_images count], self.scrollViewImagesContainer.bounds.size.height)];
    [self.scrollViewImagesContainer setContentOffset:CGPointMake(0, 0)];
}

- (void)addRemeberMeCheckBox
{
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [checkButton setImage:[UIImage imageNamed:@"squareCheckBoxUnselected@2x.png"] forState:UIControlStateNormal];
    [checkButton setImage:[UIImage imageNamed:@"checkedSquare.png"] forState:UIControlStateSelected];
    [checkButton addTarget:self action:@selector(actionCheckBoxButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    float xCOrdinate = (([self.images count] -1) * self.scrollViewImagesContainer.frame.size.width) + (self.scrollViewImagesContainer.frame.size.width/2 - 120);
    CGRect frame = CGRectMake(xCOrdinate, self.scrollViewImagesContainer.frame.size.height - 40, 30, 25);
    [checkButton setFrame:frame];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"shouldShowHelp"] isEqualToString:@"No"]) {
        [checkButton setSelected:YES];
    }
    
    frame.origin.x += 40;
    frame.size.width = 240;
    UILabel *label = [[UILabel alloc]  initWithFrame:frame];
    [label setFont:[UIFont systemFontOfSize:10.0f]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:@"NO VOLVER A MOSTRAR LAS INSTRUCCIONES"];
    [label setTextColor:[UIColor lightGrayColor]];
    
    [self.scrollViewImagesContainer addSubview:checkButton];
    [self.scrollViewImagesContainer addSubview:label];
}

#pragma mark - IBAction Methods
- (IBAction)actionCloseButtonPressed:(id)sender {
    
    [self removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(didPressedCloseButtonOnHelpScreen)]) {
        [self.delegate didPressedCloseButtonOnHelpScreen];
    }
}

- (IBAction)actionCheckBoxButtonPressed:(UIButton *)sender
{
    [sender setSelected:![sender isSelected]];
    
    NSString *showHelpAgain = [sender isSelected] ? @"No": @"Yes";
    [[NSUserDefaults standardUserDefaults] setObject:showHelpAgain forKey:@"shouldShowHelp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - UISCrollView Delegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    [self.pageControlImageNumber setCurrentPage:index];
}

@end
