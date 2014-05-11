//
//  RootViewController.h
//  iphoneCal
//
//  Created by Vikas Gupta on 1/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
  //#import "GAI.h"

@protocol CalenderViewControllerDelelegate <NSObject>
- (void)didSelectDate:(NSDate*)selectedDate;

@end
@interface CalenderViewController : UIViewController <UIAlertViewDelegate>
{
    id<CalenderViewControllerDelelegate, NSObject>delegate;
	NSCalendar *Mycal;
	NSDateComponents *compA;
	
	NSDateComponents *currentHighLightDateComp;
	
	NSInteger currentDay; 
	NSInteger currentMonth;
    NSInteger currentYear;
	
	NSArray	 * _dayNames;
	NSArray  * _monthNames;  
	
	UIButton *btnDay;
	
	UILabel *lblDay;
	NSInteger globWeekDay;
	UIImageView* buttonImage;
	
	IBOutlet UIView* MainView;
	
		
	IBOutlet UIButton *btnNext;
	IBOutlet UIButton *btnPrevious;
	IBOutlet UILabel* lblMonth;
	IBOutlet UILabel* lblSun;
	IBOutlet UILabel* lblMon;
	IBOutlet UILabel* lblTue;
	IBOutlet UILabel* lblWed;
	IBOutlet UILabel* lblThu;
	IBOutlet UILabel* lblFri;
	IBOutlet UILabel* lblSat;
		
    IBOutlet UIView *backView;
    IBOutlet UIView *headerView;
	IBOutlet UILabel* lblShowdatetime;
  __weak IBOutlet UILabel *headrTitle;
  
  
  
    
	
}
@property (strong, nonatomic) UIWindow                  *window;

@property (nonatomic, retain)id<CalenderViewControllerDelelegate, NSObject>delegate;
@property(nonatomic, strong)NSString* strCalDate;
@property(nonatomic, strong)NSString* strShoeInfoDate;
@property(nonatomic,strong)NSArray *dbEvents;

@property(nonatomic, strong) NSDate *selectedDate;

- (BOOL )eventsForDate:(NSDate *)startDate ;
-(void)nextMonth:(id)sender;
-(void)preMonth:(id)sender;
-(void)DrawMonthInPortraitView;
-(void)BtnDayClicked:(id)sender;
-(BOOL)isCurrentDate;
-(void)showPortraitView;
-(void)showLandscapeView;
- (IBAction)closeMethod:(id)sender;
-(void)viewLoad;
-(void)showMode;
- (IBAction)perYear:(id)sender;
- (IBAction)nextYear:(id)sender;

@end
