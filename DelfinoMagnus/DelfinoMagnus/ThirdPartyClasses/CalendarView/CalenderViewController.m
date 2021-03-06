//  RootViewController.m
//  iphoneCal
//
//  Created by Vikas Gupta on 1/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#define kOneDayTimeInterval 86400

BOOL flag;
BOOL viewMode,viewMode1,FlagViewDidLoad=NO;
NSDate* today;
NSDate* currentHighlightDate;
NSInteger monthMode;
NSDate* dateMode;
NSDate* FirstDateofMonth;

NSString *yearString;
NSInteger year, weekDay, month;
int DAY;
float x, y, width,height;
NSString *date;
NSCalendar *gregorian;
NSDateComponents* comps;
NSDateComponents* compsEnd;
NSDateFormatter *dateFormatter;
NSCalendar* calendar;
NSDateComponents *offsetComponents;
NSDate *todayDate;


#import "CalenderViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Calendar.h"
#import "AYCalendarObject.h"

@interface CalenderViewController ()
@property (strong, nonatomic) NSArray *eventsDates;
@end
@implementation CalenderViewController
@synthesize strCalDate;
@synthesize strShoeInfoDate;
@synthesize dbEvents,delegate;

@synthesize selectedDate;

#pragma mark -
#pragma mark View lifecycle

-(void)viewLoad
{
    self.selectedDate = [NSDate date];
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    calendar = [NSCalendar currentCalendar];
    
	self.title=@"Calendar";
	
	_dayNames = [[NSArray alloc] initWithObjects: @"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", nil];
	_monthNames = [[NSArray alloc] initWithObjects: @"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December", nil];
	
    
    // NSLog(@"slecteddate %@",self.selectedDate);
    offsetComponents = [[NSDateComponents alloc] init];
	today = self.selectedDate;
	compA =[calendar components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit) fromDate:today];
	FirstDateofMonth=[today dateByAddingTimeInterval:([compA day]-1)*(-24*60*60)];
	
	compA =[calendar components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit) fromDate:FirstDateofMonth];
	today = FirstDateofMonth;
	compA = [calendar components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit) fromDate:today];
	[compA setMonth:([compA month])];
	[self DrawMonthInPortraitView];
    //	[compA retain];
    
    
    [btnNext setImage:[[UIImage imageNamed:@"rightArrow.png"] imageWithOverlayColor:[UIColor colorWithRed:227.0/255.0 green:207.0/255.0 blue:13.0/255.0 alpha:1.0]] forState:UIControlStateNormal];
    [btnPrevious setImage:[[UIImage imageNamed:@"leftArrow.png"] imageWithOverlayColor:[UIColor colorWithRed:227.0/255.0 green:207.0/255.0 blue:13.0/255.0 alpha:1.0]] forState:UIControlStateNormal];

}

- (void)viewDidLoad {
    [super viewDidLoad];
       gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    
    
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];//2014-05-21
    
    todayDate = [NSDate date];
    
    self.view.layer.cornerRadius = 5.0;
    self.view.layer.masksToBounds = YES;
    
    FlagViewDidLoad=YES;
    // self.dbEvents=[dbcomm getListOfEvents];
    
    
	
    [self viewLoad];
}
-(void)viewWillAppear:(BOOL)animated
{
    //[self viewLoad];
	[super viewWillAppear:animated];
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    
}
//Remove view and create new view
-(void)removeView
{
	for (UIView *v in MainView.subviews)
	{
		if ([v isKindOfClass:[UIButton class]])
			[v removeFromSuperview];
	}
}

//show next month calendar when next button press
-(void)nextMonth:(id)sender
{
	[self removeView];
	compA = [calendar components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit) fromDate:today];
	[compA setMonth:([compA month]+1)];// it will increase month by 1 for next month;
	monthMode = [compA month];
	[self DrawMonthInPortraitView];
	
	
}

//show Previous month calendar when previous button press
-(void)preMonth:(id)sender
{
	[self removeView];
	compA = [calendar components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit) fromDate:today];
	[compA setMonth:([compA month]-1)];// it will decrease month by 1 for previous month;
	monthMode = [compA month];
	[self DrawMonthInPortraitView];
	
}

// return true value of current date, current month
-(BOOL)isCurrentDate
{
	currentHighlightDate = self.selectedDate;
	currentHighLightDateComp = [calendar components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit)
                                           fromDate:currentHighlightDate];
	currentDay = [currentHighLightDateComp day];
	currentMonth = [currentHighLightDateComp month];
    currentYear = [currentHighLightDateComp year];
	return YES;
}

// set the x and y coordinate and width and height of buttons in Portrait and LandScape
-(void)setPosition
{
    if (kIsDeviceiPad) {
        if (viewMode)
        {
            if(x==490)
            {
                y+=height;
                x=0;
            }
            else
            {
                x+=width;
            }
        }
        else
        {
            if(x==426)
            {
                y+=height +1;
                x=0;
            }
            else
            {
                x+=width +1;
            }
        }
    
        return;
    }
    
    
	if (viewMode)
	{
		if(x==411)
		{
			y+=height;
			x=0;
		}
		else
		{
			x+=width;
		}
	}
	else
	{
		if(x==264)
		{
			y+=height +1;
			x=0;
		}
		else
		{
			x+=width +1;
		}
	}
}

//create calender Portrait View
-(void)DrawMonthInPortraitView
{
    //  NSLog(@"DrawMonthInPortraitView");
    
	flag = [self isCurrentDate];
	today = [calendar dateFromComponents:compA];
	compA = [calendar components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit) fromDate:today];
	
	
	weekDay = [compA weekday];
	month = [compA month];
	year = [compA year];
	DAY = [compA day];
	
	NSString* monthString = [_monthNames objectAtIndex:([compA month]-1)];
	yearString = [NSString stringWithFormat:@" %d",[compA year]];
	
	lblMonth.textAlignment = NSTextAlignmentCenter;
    NSString *monthlabelText = [NSString stringWithFormat:@"%@,%@", [monthString substringToIndex:3], yearString] ;
	lblMonth.text = monthlabelText;
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,(unsigned long)NULL), ^(void) {
	//[self showMode];
    // [self performSelectorInBackground:@selector(showMode) withObject:nil];
   // [NSThread detachNewThreadSelector:@selector(showMode) toTarget:self withObject:nil];
    [self showMode];
    // [self.view setUserInteractionEnabled:NO];
    
  //  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //  });
    
}

// It show the view according to LandScape and Portrait
-(void)showMode
{
    
    
	int i,day;
	year = [yearString intValue];
	if (viewMode) {
		[self removeView];
		x=((kIsDeviceiPad ? 70.0 : 44.0)*(weekDay-1)),y=0;
		width=(kIsDeviceiPad ? 70.0 : 44.0),height=(kIsDeviceiPad ? 50.0 :35);
	}
    else
    {
		[self removeView];
		x=(kIsDeviceiPad ? 71.0 : 44.0)*(weekDay -1) ,y=0;
		width= (kIsDeviceiPad ? 70.0 :43.0),height=(kIsDeviceiPad ? 50.0 :35);
	}
	if(month==1 || month==3 || month==5 || month==7 || month==8 || month==10 || month==12)
	{
		day = 31;
	}
	else if(month==4 || month==6 || month==9 || month==11){
		day = 30;
	}
	else if(month==2)
	{
		if((year%4==0 && year%100!=0)||(year%400==0))
		{
			day = 29;
		}
		else
		{
			day = 28;
		}
	}
    i =1;
    //  NSLog(@"day %d", day);
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:1];
        
	while(i <=day) {
        
        [components setDay:i];
        NSDate *calCurDate = [calendar dateFromComponents:components];
        NSString *dateString = [dateFormatter stringFromDate:calCurDate];
        
        BOOL isRepeatedDate = NO;
        
//        if ([self.eventsDates count]) {
//            NSLog(@"date string is:%@", dateString);
//        }
        
        if ([self.eventsDates containsObject:dateString]) {
            isRepeatedDate = YES;
        }
        
        if (flag && (currentDay == i) && (currentMonth == month)&& (currentYear == year)) {
            
			btnDay = [UIButton buttonWithType:UIButtonTypeCustom];
			btnDay.frame = CGRectMake(x,y,width,height);
			[btnDay addTarget:self action:@selector(BtnDayClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btnDay setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateHighlighted];
            // [btnDay setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];;
			[btnDay setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
            [btnDay setTitleColor:[UIColor colorWithRed:227.0/255.0 green:207.0/255.0 blue:13.0/255.0 alpha:1.0] forState:UIControlStateNormal];
			[MainView addSubview:btnDay];
            if(i != day)
                [self setPosition];
			
			
		}
		else if(DAY == i && (currentMonth != month))
		{
            
			btnDay = [UIButton buttonWithType:UIButtonTypeCustom];
			btnDay.frame = CGRectMake(x,y,width,height);
			[btnDay addTarget:self action:@selector(BtnDayClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btnDay setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateHighlighted];
			[btnDay setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
            [btnDay setTitleColor:[UIColor colorWithRed:227.0/255.0 green:207.0/255.0 blue:13.0/255.0 alpha:1.0] forState:UIControlStateNormal];
          
			[MainView addSubview:btnDay];
            if(i != day)
                [self setPosition];
			
		}
		else
		{
            
            
			btnDay = [UIButton buttonWithType:UIButtonTypeCustom];
			btnDay.frame = CGRectMake(x,y,width,height);
			[btnDay addTarget:self action:@selector(BtnDayClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            if([calCurDate compare:todayDate] == NSOrderedSame){
                [btnDay setBackgroundColor:[UIColor clearColor]];
                [btnDay setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateHighlighted];
            }
            else{
                [btnDay setBackgroundColor:[UIColor clearColor]];
                [btnDay setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateHighlighted];
            }
            
            
			[btnDay setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
			[btnDay setTitleColor:[UIColor colorWithRed:227.0/255.0 green:207.0/255.0 blue:13.0/255.0 alpha:1.0] forState:UIControlStateNormal];
			[MainView addSubview:btnDay];
            if(i != day)
                [self setPosition];
        }
        
        //if([self.selectedDate compare:calCurDate] == NSOrderedAscending || [self.selectedDate compare:calCurDate] ==NSOrderedSame){
        
        if(isRepeatedDate == YES){
//            CGRect r = btnDay.bounds;
//            r.origin.y += 32;
//            r.size.height -= 31;
//            UILabel *_dot = [[UILabel alloc] initWithFrame:r];
//            _dot.text = @"•";
//            _dot.backgroundColor = [UIColor clearColor];
//            _dot.font = [UIFont boldSystemFontOfSize:30];
//            r.origin.x=28;
//            _dot.textColor = [UIColor orangeColor];
//            [_dot setFrame:r];
//            [btnDay addSubview:_dot];
            
            [btnDay setBackgroundColor:[UIColor redColor]];
        }
        // }
        
        i++;
        
        [btnDay.layer setBorderWidth:1.0f];
        [btnDay.layer setBorderColor:[[UIColor colorWithRed:227.0/255.0 green:207.0/255.0 blue:230.0/255.0 alpha:1.0] CGColor]];
    }
    
    if (kIsDeviceiPad) {
        if(y == 235){
            [backView setFrame:CGRectMake(backView.frame.origin.x,backView.frame.origin.y,backView.frame.size.width,369)];
            [MainView setFrame:CGRectMake(MainView.frame.origin.x,88, MainView.frame.size.width, 280)];
        }
        else if(y ==188){
            [backView setFrame:CGRectMake(backView.frame.origin.x,backView.frame.origin.y,backView.frame.size.width,322)];
            [MainView setFrame:CGRectMake(MainView.frame.origin.x,88,MainView.frame.size.width, 234)];
        }
    }
    
    // [self.view setUserInteractionEnabled:YES];
   // [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}

- (IBAction)perYear:(id)sender {
    
    [self removeView];
	compA = [calendar components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit) fromDate:today];
	[compA setYear:([compA year]-1)];// it will decrease month by 1 for previous month;
	monthMode = [compA month];
	[self DrawMonthInPortraitView];
}

- (IBAction)nextYear:(id)sender {
    [self removeView];
	compA = [calendar components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit) fromDate:today];
	[compA setYear:([compA year]+1)];// it will increase month by 1 for next month;
	monthMode = [compA month];
	[self DrawMonthInPortraitView];
    //[today retain];
}

-(void)BtnDayClicked:(id)sender
{
//	btnDay=sender;
//	NSString *StrDate=[NSString stringWithFormat:@"%@ %@",[btnDay currentTitle],lblMonth.text];
//	lblShowdatetime.text=StrDate;
//    
//    
//    NSDate *selectedDateButton = [SDL_Utilities dateFromString:StrDate WithFormattet:@"dd MMM, yyyy"];
//    
//    
//    if ([self.delegate respondsToSelector:@selector(didSelectDate:)]) {
//        [self.delegate performSelector:@selector(didSelectDate:) withObject:selectedDateButton];
//    }
//    else{
//        [self.view removeFromSuperview];
//        appDelegate = kAppDelegate;
//        [appDelegate loadCalScreen:selectedDateButton];
//    }
}


-(void)showPortraitView
{
	
	/*[btnPrevious setFrame:CGRectMake(2, 3,40,18)];
     [lblMonth setFrame:CGRectMake(73,3,180,21)];
     [btnNext setFrame:CGRectMake(275, 3, 37,18)];
     
     [MainView setFrame:CGRectMake(0,0,320,480)];
     
     
     [lblSun setFrame:CGRectMake(12,19, 20, 21)];
     [lblMon setFrame:CGRectMake(55, 19,21,21)];
     [lblTue setFrame:CGRectMake(98.6, 19,20,21)];
     [lblWed setFrame:CGRectMake(141.6, 19,22,21)];
     [lblThu setFrame:CGRectMake(192.6, 19,20,21)];
     [lblFri setFrame:CGRectMake(240.6,19,20,21)];
     [lblSat setFrame:CGRectMake(287.6, 19,20,21)];*/
	
}

-(void)showLandscapeView
{
	
	/*[btnPrevious setFrame:CGRectMake(4, 3,40,18)];
     [lblMonth setFrame:CGRectMake(150,3,180,21)];
     [btnNext setFrame:CGRectMake(436, 3, 40,18)];
     
     [MainView setFrame:CGRectMake(0,0,480, 320)];
     
     
     [lblSun setFrame:CGRectMake(12,19, 20, 21)];
     [lblMon setFrame:CGRectMake(89.6, 19,21,21)];
     [lblTue setFrame:CGRectMake(159.6, 19,20,21)];
     [lblWed setFrame:CGRectMake(229.6, 19,22,21)];
     [lblThu setFrame:CGRectMake(299.6, 19,20,21)];
     [lblFri setFrame:CGRectMake(370.6,19,20,21)];
     [lblSat setFrame:CGRectMake(450.6, 19,20,21)];*/
}

- (IBAction)closeMethod:(id)sender {
    [self.view removeFromSuperview];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if (FlagViewDidLoad)
	{
		if((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight) )
		{
			
			[self showLandscapeView];
			[self showMode];
		}
		else if (interfaceOrientation == UIInterfaceOrientationPortrait ||  interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
		{
			[self showPortraitView];
			if (viewMode1)
			{     // if condition is used when second time portriat view is load, first time this condition will not run
				[self showMode];  //because first time landscape view will not run, then viewMode1 value is false, when we rotate this
			}                                        // view in landscape it's value will be true then this condition will call
		}
	}
	return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // [backView release];
    backView = nil;
    // [headerView release];
    headerView = nil;
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

//"calendar":[{"fecha":"2014-05-21","disponible":"NO"},{"fecha":"2014-06-07","disponible":"SI"},{"fecha":"2014-07-18","disponible":"NO"},{"fecha":"2014-12-31","disponible":"SI"}]
- (void)reloadCalendarWithCalendarObjects:(NSArray *)objects
{
  //  NSArray *objects = @[@{@"fecha":@"2014-05-21",@"disponible":@"NO"},@{@"fecha":@"2014-06-07",@"disponible":@"SI"},@{@"fecha":@"2014-07-18",@"disponible":@"NO"},@{@"fecha":@"2014-12-30",@"disponible":@"SI"}];
    NSMutableArray *calendarDates = [[NSMutableArray alloc]  init];
    
    for (int index = 0; index < [objects count]; index++) {
       
        AYCalendarObject *calendarObj = [[AYCalendarObject alloc]  init];
        [calendarObj setDisponible:[objects[index] disponible]];
        [calendarObj setDate:[dateFormatter dateFromString:[objects[index] fecha]]];
        [calendarDates addObject:calendarObj];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]  initWithKey:@"date" ascending:YES];
    NSArray *sortedArray = [calendarDates sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    NSMutableArray *calendars  = [[NSMutableArray alloc]  initWithCapacity:0];

    @try {
        for (int index = 0; index < [sortedArray count]; index++) {
            
            if ([[sortedArray[index] disponible] isEqualToString:@"NO"]) {
                
                NSDate *startDate = [sortedArray[index] date];
                NSDate *endDate = nil;
                
                if (index == 0) {
                    endDate = [NSDate date];
                }
                else if ((index - 1) >= 0) {
                    endDate = [sortedArray[index - 1] date];
                    endDate = [endDate dateByAddingTimeInterval:86400];
                }
                
                if ([endDate compare:[NSDate date]] == NSOrderedAscending) {
                    endDate = [NSDate date];
                }
                
                NSString *endDateString = [dateFormatter stringFromDate:endDate];
                endDate = [dateFormatter dateFromString:endDateString];
                
                while ([endDate compare:startDate] != NSOrderedDescending) {
                    
                    [calendars addObject:[dateFormatter stringFromDate:endDate]];
                    
                    endDate = [endDate dateByAddingTimeInterval:86400];
                }
             
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception occured while getting dates");
    }
    
    self.eventsDates = calendars;
    
    if ([self.eventsDates count]) {
        [self DrawMonthInPortraitView];
    }
}

@end

