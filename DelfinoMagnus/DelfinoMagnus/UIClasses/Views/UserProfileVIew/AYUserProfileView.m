//
//  AYUserProfileView.m
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/10/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import "AYUserProfileView.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "AYFavoritesView.h"

@interface AYUserProfileView () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgViewProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblDesignation;
@property (weak, nonatomic) IBOutlet UILabel *lblEmailId;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblImpressea;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) AYFavoritesView *favoritesView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintNameLabelTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintProfilePicTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintProfilePicLeftSapce;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintNameLabelRightSapce;

@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIViewController *rootViewController;

@property (strong, nonatomic) User *userDetails;
@end


@implementation AYUserProfileView

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
    [self doAppearenceSettingsForOrientation:[[UIDevice currentDevice] orientation]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangedOrientation:) name:kDeviceWillChangeOrientation object:nil];
    
    self.userDetails = [[[LTCoreDataManager sharedInstance] getAllRecordsFromEntity:kUserEntityName] lastObject];
    
    if (self.userDetails) {
        [self loadUIFromUserDetails];
    }
    
    UITapGestureRecognizer *singleTapOnImage = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(didSingleTappedonProfiePic:)];
    [self.imgViewProfilePic setUserInteractionEnabled:YES];
    [self.imgViewProfilePic addGestureRecognizer:singleTapOnImage];
}

- (void)didSingleTappedonProfiePic:(UIGestureRecognizer *)recognizer
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    self.rootViewController = [keyWindow rootViewController];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]  initWithTitle:@"Seleccione entre" delegate:self cancelButtonTitle:@"cancelar" destructiveButtonTitle:@"cámara" otherButtonTitles:@"galería", nil];
    [actionSheet showInView:self];
}

- (void)loadUIFromUserDetails
{
    [self startDownloadingImage];
    [self.lblName setText:self.userDetails.nombre];
    [self.lblDesignation setText:self.userDetails.actividad];
    [self.lblEmailId setText:self.userDetails.email];
    [self.lblImpressea setText:self.userDetails.empresa];
    [self.lblAddress setText:self.userDetails.direccion];
    
    [self.imgViewProfilePic.layer setBorderColor:[[UIColor redColor] CGColor]];
    [self.imgViewProfilePic.layer setBorderWidth:2.0f];
    [self.imgViewProfilePic.layer setCornerRadius:self.imgViewProfilePic.frame.size.width/2];
}

- (void)didChangedOrientation:(id)notifiObject
{
    NSInteger newOrientation = [[[notifiObject userInfo] objectForKey:@"NewOrientation"] integerValue];
    
    [self doAppearenceSettingsForOrientation:newOrientation];
}

- (void)doAppearenceSettingsForOrientation:(NSInteger)orientation
{
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        self.constraintNameLabelTopSpace.constant = kIsDeviceiPad ? 200 : 50;
        self.constraintProfilePicTopSpace.constant = kIsDeviceiPad ? 240: 100;
        self.constraintNameLabelRightSapce.constant = 40;
        self.constraintProfilePicLeftSapce.constant = 150;

    }
    else {
        self.constraintNameLabelTopSpace.constant = kIsDeviceiPad ? 447 : 219;
        self.constraintProfilePicTopSpace.constant = kIsDeviceiPad ? 88 : 71;
        self.constraintNameLabelRightSapce.constant = 140;
        self.constraintProfilePicLeftSapce.constant = 219;
    }
    
    [self layoutIfNeeded];
}

- (void)startDownloadingImage
{
    NSString *urlString  = [NSString stringWithFormat:@"%@/%@", self.userDetails.urlimgs, self.userDetails.image_file];
    
    [self.imgViewProfilePic setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [self.imgViewProfilePic setImage:image];
            [self.activityIndicator stopAnimating];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            [self.activityIndicator stopAnimating];
    }];
}

- (void)loadUserFavoritesView
{
    NSString *nibName = kIsDeviceiPad ? @"AYFavoritesView~iPad": @"AYFavoritesView";

    self.favoritesView = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] lastObject];
    [self.favoritesView setFrame:self.bounds];
    [self addSubview:_favoritesView];
}

#pragma mark - IBAction Methods
- (IBAction)actionTopMenuButtonPressed:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)actionFavoritesButtonPressed:(id)sender {
    [self loadUserFavoritesView];
}

#pragma mark - UIImagePicker Delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"Image info is:%@", info);
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (pickedImage) {
        [self.imgViewProfilePic setImage:pickedImage];
        NSData *imageData = UIImageJPEGRepresentation(pickedImage, 0.8);
        
        [[AYNetworkManager sharedInstance] uploadProfilePictureWithFilePath:imageData andCompletionBlock:^(id result) {
            
            if (result) {
                [[NSNotificationCenter defaultCenter]  postNotificationName:kImageUpdatedUpdateProfile object:nil];
            }
        }];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAction sheet Delegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
    self.imagePicker = [[UIImagePickerController alloc]  init];
    [self.imagePicker setDelegate:self];
    
    UIImagePickerControllerSourceType sourceType;
    if (buttonIndex == 0) {
        sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.imagePicker setMediaTypes:@[@"public.image"]];
    }
    else {
        sourceType  = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self.imagePicker setSourceType:sourceType];
    
    [self.rootViewController presentViewController:_imagePicker animated:YES completion:^{
        
    }];
    
}

@end
