//
//  AppointmentViewController.m
//  DoctorApp
//
//  Created by Ivan Cardenas on 9/17/16.
//  Copyright © 2016 Ivan Cardenas. All rights reserved.
//

#import "AppointmentViewController.h"
#import "PatientProfileViewController.h"
#import "DashBoardViewController.h"


@interface AppointmentViewController ()
@property (nonatomic, strong) IBOutlet UIImageView* profileIconImageView;
@property (nonatomic, strong) IBOutlet UIImageView* appointmentImageView;
@property (nonatomic, strong) IBOutlet UIImageView* homeImageView;
@end

@implementation AppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer* tapGestrue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileTapGesture:)];
    [self.profileIconImageView addGestureRecognizer:tapGestrue];
    [self.profileIconImageView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer* appointmentTapGestrue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(appointmentTapGesture:)];
    [self.appointmentImageView addGestureRecognizer:appointmentTapGestrue];
    [self.appointmentImageView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer* homeTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(homeTapGesture:)];
    [self.appointmentImageView addGestureRecognizer:homeTapGesture];
    [self.appointmentImageView setUserInteractionEnabled:YES];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
