//
//  AYMapInfoView.m
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/8/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import "AYMapInfoView.h"
#import "Device.h"

@interface AYMapInfoView () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewInfoContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDisponibleStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewDisponible;
@property (weak, nonatomic) IBOutlet UIView *viewTitleContainer;
@property (weak, nonatomic) IBOutlet UIView *viewTipotpyeContainer;
@property (weak, nonatomic) IBOutlet UIWebView *webVIewDescription;

@end


@implementation AYMapInfoView

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

#pragma mark - Private Methods
- (void)doInitialConfigurations
{
    [self.viewInfoContainer.layer setCornerRadius:15.0];
    
    float fontSize = kIsDeviceiPad ? 15.0f : 11.0f;
    [self.lblTitle setFont:[UIFont fontWithName:@"century" size:fontSize]];
    [self.lblSubtitle setFont:[UIFont fontWithName:@"century" size:fontSize]];
    [self.lblDisponibleStatus setFont:[UIFont fontWithName:@"century" size:fontSize]];
}

- (void)loadWebViewWithDescriptionString:(NSString *)description
{
    if (!description) {
        return;
    }
    
    description = [description stringByReplacingOccurrencesOfString:@"A9A9A9" withString:@"000000"];
    description = [description stringByReplacingOccurrencesOfString:@"FFFFFF" withString:@"000000"];
    description = [description stringByReplacingOccurrencesOfString:@"D3D3D3" withString:@"444444"];

    NSMutableString *html = [NSMutableString stringWithString: @"<html><head><title></title></head><body>"];
    
    NSCharacterSet *charecterSetToTrim = [NSCharacterSet characterSetWithCharactersInString:@"/"];

    [html appendString:[description stringByTrimmingCharactersInSet:charecterSetToTrim]];
    [html appendString:@"</body></html>"];
    
    [self.webVIewDescription loadHTMLString: html baseURL: nil];
}

#pragma mark - Public Methods
- (void)configureViewWithDeviceObject:(Device *)device
{
    [self.lblTitle setText:device.titulo];
    [self.lblSubtitle setText:[[AYUtilites getTiposNameDictionary] objectForKey:device.tipo]];
    
    NSDictionary *colorsDict = [[AYUtilites getTiposBackgroundColors] objectForKey:device.tipo];
    
    [self.viewTitleContainer setBackgroundColor:[colorsDict objectForKey:@"titleBGColor"]];
    [self.viewTipotpyeContainer setBackgroundColor:[colorsDict objectForKey:@"tipoBGColor"]];
    [self loadWebViewWithDescriptionString:device.htmldescripcion];
    
    if ([device.disponible isEqualToString:@"SI"]) {
        [self.imgViewDisponible setImage:[UIImage imageNamed:@"disponible.png"]];
        [self.lblDisponibleStatus setText:@"Disponible"];
    }
    else {
        [self.imgViewDisponible setImage:[UIImage imageNamed:@"no_disponible.png"]];
        [self.lblDisponibleStatus setText:@"No Disponible"];
    }
}

#pragma mark - WebView delegate Methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

@end
