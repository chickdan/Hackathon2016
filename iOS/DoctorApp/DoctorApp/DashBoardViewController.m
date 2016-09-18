//
//  DashBoardViewController.m
//  DoctorApp
//
//  Created by Ivan Cardenas on 9/17/16.
//  Copyright © 2016 Ivan Cardenas. All rights reserved.
//

#import "DashBoardViewController.h"
#import "PatientProfileViewController.h"
#import "DataBaseManager.h"
#import "MyUserDefaults.h"
#import "DashBoardTableViewCell.h"
#import "AppointmentViewController.h"

NSString* dateFormat = @"yyyy-MM-dd HH:mm";

@interface DashBoardViewController ()
@property (nonatomic, strong) NSMutableArray* upcomingAppointmentsTableDataSource;
@property (nonatomic, strong) IBOutlet UITableView* upcomingAppointmentsTable;
@property (nonatomic, strong) IBOutlet UIImageView* profileIconImageView;
@property (nonatomic, strong) IBOutlet UIImageView* appointmentImageView;
@property (nonatomic, strong) IBOutlet UIImageView* homeImageView;
@end

@implementation DashBoardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer* tapGestrue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileTapGesture:)];
    [self.profileIconImageView addGestureRecognizer:tapGestrue];
    [self.profileIconImageView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer* appointmentTapGestrue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(appointmentTapGesture:)];
    [self.appointmentImageView addGestureRecognizer:appointmentTapGestrue];
    [self.appointmentImageView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer* homeTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(homeTapGesture:)];
    [self.homeImageView addGestureRecognizer:homeTapGesture];
    [self.homeImageView setUserInteractionEnabled:YES];

    
    
    
    [self.upcomingAppointmentsTable setSeparatorColor:[self colorFromHexString:@"#8FC7E6"]];
    
    self.upcomingAppointmentsTable.dataSource = self;
    self.upcomingAppointmentsTable.delegate = self;
    
    self.upcomingAppointmentsTableDataSource = [[NSMutableArray alloc] init];
    
    NSString* patientID = [MyUserDefaults retrievePatientId];
    
    [[DataBaseManager sharedInstance] retreivePatientAppointmentWithResponseCallback:^(NSDictionary* appointments){
        
        for (NSString* key in appointments)
        {
            NSDictionary* appointment = [appointments objectForKey:key];
            
            if ([[appointment objectForKey:@"patientID"] isEqualToString:patientID])
            {
                [self.upcomingAppointmentsTableDataSource addObject:appointment];
            }
        }
        
        [self reloadData];
        
    }];
    // Do any additional setup after loading the view from its nib.
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (void)reloadData
{
    [self.upcomingAppointmentsTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"DashBoardTableViewCell";
    
    NSDictionary* appointment = [self.upcomingAppointmentsTableDataSource objectAtIndex:indexPath.row];
    
    DashBoardTableViewCell* cell = (DashBoardTableViewCell* )[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DashBoardTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    NSDate* date = [dateFormatter dateFromString:[appointment objectForKey:@"date"]];
    
    
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"EEEE"];
    NSString *dayName = [dayFormatter stringFromDate:date];
    
    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    
    if([today day] == [otherDay day] &&
       [today month] == [otherDay month] &&
       [today year] == [otherDay year] &&
       [today era] == [otherDay era])
    {
       dayName = @"Today";
    }
    
    cell.dayLabel.text = dayName;
    
    
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"MMMM dd, YYYY"];
    
    cell.dateLabel.text = [dateFormatter stringFromDate:date];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    
    cell.timeLabel.text = [formatter stringFromDate:date];
    
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.upcomingAppointmentsTable isEqual:tableView])
    {
        return [self.upcomingAppointmentsTableDataSource count];
    }
    return 0;
}

- (void)profileTapGesture:(id)sender
{
    PatientProfileViewController* patientProfileViewController = [[PatientProfileViewController alloc] initWithNibName:@"PatientProfileViewController" bundle:nil];
    [self.navigationController pushViewController:patientProfileViewController animated:YES];
}

- (void)appointmentTapGesture:(id)sender
{
    AppointmentViewController* appointmentViewController = [[AppointmentViewController alloc] initWithNibName:@"AppointmentViewController" bundle:nil];
    [self.navigationController pushViewController:appointmentViewController animated:YES];
}

- (void)homeTapGesture:(id)sender
{
    DashBoardViewController* dashBoardViewController = [[DashBoardViewController alloc] initWithNibName:@"DashBoardViewController" bundle:nil];
    [self.navigationController pushViewController:dashBoardViewController animated:YES];
}

@end
