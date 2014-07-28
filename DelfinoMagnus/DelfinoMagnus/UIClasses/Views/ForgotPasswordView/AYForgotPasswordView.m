//
//  AYForgotPasswordView.m
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/6/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import "AYForgotPasswordView.h"

@interface AYForgotPasswordView ()
@property (weak, nonatomic) IBOutlet UITextField *txtFieldEmailId;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;

@end


@implementation AYForgotPasswordView

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
    [self.btnClose setImage:[[UIImage imageNamed:@"cerrar.png"] imageWithOverlayColor:[UIColor yellowColor]] forState:UIControlStateNormal];
    
    float fontSize = kIsDeviceiPad ? 17.0f : 14.0f;
    [self.txtFieldEmailId setFont:[UIFont fontWithName:@"century" size:fontSize]];
    
    UITapGestureRecognizer *singleTapOnBGView = [[UITapGestureRecognizer alloc] init];
    [singleTapOnBGView addTarget:self action:@selector(singleTappedOnBGView:)];
    [self addGestureRecognizer:singleTapOnBGView];
}

- (void)singleTappedOnBGView:(UIGestureRecognizer *)recognizer
{
    [self.txtFieldEmailId resignFirstResponder];
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

- (void)showAlertWithMessage:(NSString *)message andTitle:(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc]  initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Bueno" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - IBAction Methods
- (IBAction)actionCloseButtonPressed:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)actionSendMailButtonPressed:(id)sender {
    
    if ([self validateEmail:self.txtFieldEmailId.text]) {
       
        [[AYNetworkManager sharedInstance] generateasswordForMailId:self.txtFieldEmailId.text andCompletionBlock:^(id result) {
            
            if (result && [result isKindOfClass:[NSDictionary class]] && [[result objectForKey:@"msgerr"] isEqualToString:@"Success"]) {
#warning Avadesh what should be success message to display
            }
            else {
                [self showAlertWithMessage:@"Por favor, introduzca email válida Id." andTitle:@"Atención"];
            }
        
            //
        }];
    }//usuario@example.com
    else {
        [self showAlertWithMessage:@"Por favor, introduzca email válida Id." andTitle:@"Atención"];
    }
   
}

@end
