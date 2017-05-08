//
//  LoginViewController.m
//  Cross-platform-todo-list
//
//  Created by Kent Rogers on 5/8/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//

#import "LoginViewController.h"

@import FirebaseAuth;
@import Firebase;

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)loginPressed:(id)sender {
    
    [[FIRAuth auth] signInWithEmail:self.emailTextField.text password:self.passwordTextField.text completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error %@", error.localizedDescription);
        }
        
        if (user) {
            NSLog(@"Logged in user: %@", user);
            [self dismissViewControllerAnimated: YES completion: nil];
        }
        
    }];
    
}

- (IBAction)signUpPressed:(id)sender {
    
    [[FIRAuth auth] createUserWithEmail:self.emailTextField.text password:self.passwordTextField.text completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error %@", error.localizedDescription);
        }
        
        if (user) {
            NSLog(@"Successfully signed up user %@", user);
        }
    }];
    
}

@end
