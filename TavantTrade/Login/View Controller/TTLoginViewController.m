//
//  TTLoginViewController.m
//  TavantTrade
//
//  Created by TAVANT on 2/19/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTLoginViewController.h"
#import "TTDashboardViewController.h"
#import "TTAlertView.h"
#import "SBITradingNetworkManager.h"
#import "TTUrl.h"

@interface TTLoginViewController ()
@property(nonatomic,strong) TTAlertView *alertView;
@end

@implementation TTLoginViewController

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
    // Do any additional setup after loading the view from its nib.
    _alertView = [TTAlertView sharedAlert];
    _loginButton.layer.cornerRadius = 3;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonClickAction:(id)sender {
    // validating the credentials and allowing user  to proceed
    if([self validateTextFields]){
        if([self validateUser]){
            _viewController = [[TTDashboardViewController alloc] initWithNibName:@"TTDashboardViewController" bundle:nil];
            [self presentViewController:_viewController animated:NO completion:NULL];
        }
        else{
            [_alertView showAlertWithMessage:NSLocalizedStringFromTable(@"Login_Failed", @"Localizable",@"Login failed")];
        }
    }
     else{
        
      
            [_alertView showAlertWithMessage:NSLocalizedStringFromTable(@"Missing_Credentials", @"Localizable",@"Please Enter the credentials")];
 

     }

}

-(BOOL)validateUser{
   
   _isValidUser=YES;
   
        // commenting basic authentication since no authentication being done from server
    /*
        NSString *relativePath = [TTUrl accountLoginURL];
        
        SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
        
        [networkManager makeBasicAuthenticationRequestWithRelativePath:(NSString *)relativePath withUserName:_userNameTextField.text withPassword: _passwordTextField.text responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
            
            NSHTTPURLResponse *recievedResponse = (NSHTTPURLResponse *)response;
            
            if(recievedResponse.statusCode != 200){
                
                NSLog(@"error %d",recievedResponse.statusCode);
                _isValidUser=NO;
            }
            else{
                [[NSUserDefaults standardUserDefaults] setObject:_userNameTextField.text forKey:@"clientId"];
                _isValidUser=YES;
            }
      
        
        }];
     */
        // once logged in store the client id in user defaults
         [[NSUserDefaults standardUserDefaults] setObject:_userNameTextField.text forKey:@"clientId"];
    
     

    return _isValidUser;
}

-(BOOL)validateTextFields{
    // hardcoding it for time being
     _userNameTextField.text=@"ESI206321";
    bool isValidField=YES;
    if([_userNameTextField.text isEqualToString:@""]||[_passwordTextField.text isEqualToString:@""]){
        isValidField=NO;
    }
    
    return isValidField;
}
@end
