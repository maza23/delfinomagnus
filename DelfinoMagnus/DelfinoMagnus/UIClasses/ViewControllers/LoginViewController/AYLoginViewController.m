//
//  AYLoginViewController.m
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/5/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import "AYLoginViewController.h"
#import "AYForgotPasswordView.h"

@interface AYLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnForgetPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) AYForgotPasswordView *forgotPasswordView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintInputContainerTop;
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

- (void)viewDidDisappear:(BOOL)animated
{
    [self removeObservers];
}

#pragma mark - Private Methods
- (void)doInitialConfigurations
{
    [self.navigationController setNavigationBarHidden:YES];
    
    float fontSize = kIsDeviceiPad ? 15.0f : 11.0f;
    [_lblUsername setFont:[UIFont fontWithName:@"century" size:fontSize]];
    [_lblPassword setFont:[UIFont fontWithName:@"century" size:fontSize]];
    [_txtFieldUserName setFont:[UIFont fontWithName:@"century" size:fontSize]];
    [_txtFieldPassword setFont:[UIFont fontWithName:@"century" size:fontSize]];
    [_btnForgetPassword.titleLabel setFont:[UIFont fontWithName:@"century" size:fontSize]];
    [_btnLogin.titleLabel setFont:[UIFont fontWithName:@"century" size:fontSize]];
    
//    [self.txtFieldUserName setText:@"pablom"];
//    [self.txtFieldPassword setText:@"pablom"];
//
    [self addKeyBoardObservers];
    UITapGestureRecognizer *singleTapOnBGView = [[UITapGestureRecognizer alloc] init];
    [singleTapOnBGView addTarget:self action:@selector(singleTappedOnBGView:)];
    [self.view addGestureRecognizer:singleTapOnBGView];
}

- (void)singleTappedOnBGView:(UIGestureRecognizer *)recognizer
{
    [self.txtFieldPassword resignFirstResponder];
    [self.txtFieldUserName resignFirstResponder];
}

- (void)addKeyBoardObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyBoardWillShow:(NSNotification *)notificationObject
{
    if (kIsOrientationLandscape) {
        self.constraintInputContainerTop.constant = kIsDeviceiPad ? 270 : 65;
        [self.view layoutIfNeeded];
    }
}

- (void)keyBoardWillHide:(NSNotification *)notificationObject
{
    self.constraintInputContainerTop.constant = kIsDeviceiPad ? 300: 150;
    [self.view layoutIfNeeded];
}

- (void)startLoginToServer
{
    NSString *userName = self.txtFieldUserName.text;
    NSString *password = self.txtFieldPassword.text;
    
    if ((![userName length]) && (![password length])) {
        [self showErrorAlertWithMessage:@"Por favor introduzca credentails válidos"];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[AYNetworkManager sharedInstance]  loginWithUsername:userName password:password withCompletionHandler:^(id result) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result && [result isKindOfClass:[NSDictionary class]]) {
                
                if ([[result objectForKey:@"msgerr"] isEqualToString:@"Success"]) {

                    [[NSUserDefaults standardUserDefaults]  setObject:self.txtFieldUserName.text forKey:@"userName"];
                    [[NSUserDefaults standardUserDefaults]  setObject:self.txtFieldPassword.text forKey:@"password"];
                    
                    if ([result objectForKey:@"profile"]) {
                         [[LTCoreDataManager sharedInstance] insertUserDetailsIntoDBFromRawResponse:[result objectForKey:@"profile"]];
                    }
                   
                    if ([self.delegate respondsToSelector:@selector(didUserLoggedInSuccessfully)]) {
                        [self.delegate didUserLoggedInSuccessfully];
                    }
                }
                else {
                    [self showErrorAlertWithMessage:@"las credenciales no son válidas"];
                }
            }
            else {
                [self showErrorAlertWithMessage:@"las credenciales no son válidas"];
            }
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
    }];
}

- (void)showErrorAlertWithMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc]  initWithTitle:@"Atención" message:message delegate:nil cancelButtonTitle:@"Bueno" otherButtonTitles: nil];
    
    [alertView show];
}

#pragma mark - IBAction Methods

- (IBAction)actionLoginButtonPressed:(id)sender {
    [self startLoginToServer];
}

- (IBAction)actionForgotPasswordButtonPressed:(id)sender {
    
    [self.txtFieldPassword resignFirstResponder];
    [self.txtFieldUserName resignFirstResponder];

    NSString *nibName = kIsDeviceiPad ? @"AYForgotPasswordView~iPad" : @"AYForgotPasswordView";
    self.forgotPasswordView = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] lastObject];
    [self.forgotPasswordView setFrame:self.view.bounds];
    
    [self.view addSubview:self.forgotPasswordView];
}

#pragma mark - UITxtField Delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.txtFieldUserName]) {
        [self.txtFieldPassword becomeFirstResponder];
    }
    else {
        [self.txtFieldPassword resignFirstResponder];
        [self startLoginToServer];
    }
    
    return YES;
}

@end
