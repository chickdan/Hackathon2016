//
//  PatientProfileViewController.m
//  DoctorApp
//
//  Created by ADMINISTRATOR on 9/17/16.
//  Copyright © 2016 Ivan Cardenas. All rights reserved.
//

#import "PatientProfileViewController.h"
#import "AppointmentViewController.h"
#import "DashBoardViewController.h"
#import "PrescriptionViewController.h"
#import "MyUserDefaults.h"

@interface PatientProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *patientIDLabel;

@property (weak, nonatomic) IBOutlet UIImageView *appointmentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *homeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *prescriptionImageView;

@end

@implementation PatientProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2;
    self.profilePicture.clipsToBounds = YES;
    
    UITapGestureRecognizer* appointmentTapGestrue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(appointmentTapGesture:)];
    [self.appointmentImageView addGestureRecognizer:appointmentTapGestrue];
    [self.appointmentImageView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer* homeTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(homeTapGesture:)];
    [self.homeImageView addGestureRecognizer:homeTapGesture];
    [self.homeImageView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer* prescriptionTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(prescriptionTapGesture:)];
    [self.prescriptionImageView addGestureRecognizer:prescriptionTapGesture];
    [self.prescriptionImageView setUserInteractionEnabled:YES];
    
    [self requestPatientData];
    _patientIDLabel.text = [MyUserDefaults retrievePatientId];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)requestPatientData {
    NSString *patientURL = [@"https://fhir-open-api-dstu2.smarthealthit.org/Patient/" stringByAppendingString:[MyUserDefaults retrievePatientId]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:patientURL]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

        if (!error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            
            if(404 == [httpResponse statusCode]){
                [self newFhirUser:patientURL];
            } else {
            
                NSError* jsonError;
                NSDictionary* json = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &jsonError];
                
                // update the UI here (and only here to the extent it depends on the json)
            
                //address = [json objectForKey:@"address"];
                //city = [json objectForKey:@"address-city"];
                //zipcode = [json objectForKey:@"address-postalcode"];
                //state = [json objectForKey:@"address-state"];
                //name = [json objectForKey:@"name"];
                //gender = [json objectForKey:@"gender"];
                //email = [json objectForKey:@"email"];
                //phone = [json objectForKey:@"phone"];
                //dob = [json objectForKey:@"birthdate"];
            }
        } else {
            //[self newFhirUser:request];
        }
    }];
}

- (void)newFhirUser:(NSString*) patientURL
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:patientURL]];
    
    NSMutableDictionary *newUser = [NSMutableDictionary new];
    [newUser setObject:@"Patient" forKey:@"resourceType"];
    [newUser setObject:[MyUserDefaults retrievePatientId] forKey:@"id"];
    
    NSMutableDictionary* telcomVal = [[NSMutableDictionary alloc] init];
    
    [telcomVal setObject:@"email" forKey:@"system"];
    
    [telcomVal setObject:[MyUserDefaults retrieveEmail] forKey:@"value"];
    
    NSArray *telcomArray = [NSArray arrayWithObject:telcomVal];

    [newUser setObject:telcomArray forKey:@"telecom"];
    
    
    NSError* error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:newUser options:0 error: &error];
    
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if (!error) {
                                   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                               }
                               
                               
    }];
    
}
                            
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveProfile:(UIButton *)sender
{
    NSMutableDictionary *jsonToPost = [NSMutableDictionary new];
    //[jsonToPost setObject:address.text forKey:@"address"];
    //[jsonToPost setObject:city.text forKey:@"address-city"];
    //[jsonToPost setObject:zipcode.text forKey:@"address-postalcode"];
    //[jsonToPost setObject:state.text forKey:@"address-state"];
    //[jsonToPost setObject:gender.text forKey:@"gender"];
    //[jsonToPost setObject:email.text forKey:@"email"];
    //[jsonToPost setObject:phone.text forKey:@"phone"];
    //[jsonToPost setObject:dob.text forKey:@"birthdate"];
    
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

- (void)prescriptionTapGesture:(id)sender
{
    PrescriptionViewController* prescriptionViewController = [[PrescriptionViewController alloc] initWithNibName:@"PrescriptionViewController" bundle:nil];
    [self.navigationController pushViewController:prescriptionViewController animated:YES];
}
@end
