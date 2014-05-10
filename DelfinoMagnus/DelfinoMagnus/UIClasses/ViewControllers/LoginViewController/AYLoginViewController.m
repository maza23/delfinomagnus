//
//  AYLoginViewController.m
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/5/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import "AYLoginViewController.h"
#import "AYForgotPasswordView.h"

@interface AYLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtFieldUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldPassword;
@property (strong, nonatomic) AYForgotPasswordView *forgotPasswordView;
@end

@implementation AYLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self doInitialConfigurations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (void)doInitialConfigurations
{
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.txtFieldUserName setText:@"pablom"];
    [self.txtFieldPassword setText:@"pablom"];

    
    UITapGestureRecognizer *singleTapOnBGView = [[UITapGestureRecognizer alloc] init];
    [singleTapOnBGView addTarget:self action:@selector(singleTappedOnBGView:)];
    [self.view addGestureRecognizer:singleTapOnBGView];
}

- (void)singleTappedOnBGView:(UIGestureRecognizer *)recognizer
{
    [self.txtFieldPassword resignFirstResponder];
    [self.txtFieldUserName resignFirstResponder];
}

- (void)startLoginToServer
{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
//    [[AYNetworkManager sharedInstance]  loginWithUsername:self.txtFieldUserName.text password:self.txtFieldPassword.text withCompletionHandler:^(id result) {
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (result && [result isKindOfClass:[NSDictionary class]]) {
//                
//                if (![[result objectForKey:@"msgerr"] isEqualToString:@"success"]) {
    
                    if ([self.delegate respondsToSelector:@selector(didUserLoggedInSuccessfully)]) {
                        [self.delegate didUserLoggedInSuccessfully];
                    }
//                    
//                } ;
//            }
//            
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        });
//    }];
}

#pragma mark - IBAction Methods

- (IBAction)actionLoginButtonPressed:(id)sender {
    [self startLoginToServer];
}

- (IBAction)actionForgotPasswordButtonPressed:(id)sender {
    
    self.forgotPasswordView = [[[NSBundle mainBundle] loadNibNamed:@"AYForgotPasswordView" owner:self options:nil] lastObject];
    
    [self.view addSubview:self.forgotPasswordView];
}

@end
