//
//  PatientProfileViewController.m
//  DoctorApp
//
//  Created by ADMINISTRATOR on 9/17/16.
//  Copyright © 2016 Ivan Cardenas. All rights reserved.
//

#import "PatientProfileViewController.h"
#import "MyUserDefaults.h"

@interface PatientProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *patientIDLabel;

@end

@implementation PatientProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2;
    self.profilePicture.clipsToBounds = YES;
    
    _patientIDLabel.text = [MyUserDefaults retrievePatientId];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)requestPatientData {
    NSString *patientURL = [@"https://fhir-api-dstu2.smarthealthit.org/Patient/" stringByAppendingString:[MyUserDefaults retrievePatientId]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:patientURL]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
                            
    // optionally update the UI to say 'busy', e.g. placeholders or activity
    // indicators in parts that are incomplete until the response arrives
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        // optionally update the UI to say 'done'
        if (!error) {
            
            NSError* jsonError;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData: request options: NSJSONReadingMutableContainers error: &jsonError];
            // update the UI here (and only here to the extent it depends on the json)
        } else {
            // update the UI to indicate error
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

@end
