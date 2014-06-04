//
//  AYDevicesListView.m
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/13/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import "AYDevicesListView.h"
#import "AYSearchedDeviceCell.h"
#import "AYDeviceDetailsView.h"

@interface AYDevicesListView ()
@property (weak, nonatomic) IBOutlet UITableView *tbleViewDevicesList;
@property (strong, nonatomic) NSArray *searchedDevices;

@property (strong, nonatomic) AYDeviceDetailsView *deviceDetailsView;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;

@end

@implementation AYDevicesListView

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
    [self.btnClose setImage:[[UIImage imageNamed:@"cerrar.png"] imageWithOverlayColor:[UIColor colorWithRed:225.0/255.0 green:164.0/255.0 blue:74.0/255.0 alpha:1.0]] forState:UIControlStateNormal];

    [self.tbleViewDevicesList registerNib:[UINib nibWithNibName:@"AYSearchedDeviceCell" bundle:nil] forCellReuseIdentifier:@"AYSearchedDeviceCell"];
}

- (void)loadDeviceDetailsViewWithDeviceObject:(id)deviceObject
{
    NSString *nibName = kIsDeviceiPad ? @"AYDeviceDetailsView~iPad": @"AYDeviceDetailsView";
    self.deviceDetailsView = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] lastObject];
    
    UIView *parentView = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];
    [self.deviceDetailsView setFrame:parentView.bounds];
    [parentView addSubview:self.deviceDetailsView];
    [self.deviceDetailsView loadDeviceDetailsWithDeviceObject:deviceObject];
}

#pragma mark - Public Methods
- (void)loadDevicesListFromDevices:(NSArray *)devices
{
    self.searchedDevices = devices;
    [self.tbleViewDevicesList reloadData];
}

#pragma mark - IBAction Methods
- (IBAction)actionCloseButtonPressed:(id)sender {
    [self removeFromSuperview];
}

#pragma mark - UITableView Datasource and delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchedDevices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AYSearchedDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AYSearchedDeviceCell"];
    [cell configureCellWithObject:self.searchedDevices[[indexPath row]]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self loadDeviceDetailsViewWithDeviceObject:self.searchedDevices[[indexPath row]]];
}

@end
