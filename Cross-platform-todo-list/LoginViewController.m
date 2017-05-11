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

@property (weak, nonatomic) IBOutlet UILabel *loginErrorLabel;
@property (weak, nonatomic) IBOutlet UILabel *signupSuccessLabel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//Handles what happens when pressing the login button
- (IBAction)loginButtonPressed:(id)sender {
    
    [[FIRAuth auth] signInWithEmail:self.emailTextField.text
                           password:self.passwordTextField.text
                         completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                             
                             if (error) {
                                 [self.signupSuccessLabel setHidden:YES];
                                 
                                 if ([error.localizedDescription containsString:@"There is no user record corresponding to this identifier."] || [error.localizedDescription containsString:@"The password is invalid or the user does not have a password."]) {
                                     
                                     self.loginErrorLabel.text = @"User not found. Please verify login information and try again, or sign up.";
                                     [self.loginErrorLabel setHidden:NO];
                                     
                                 } else if ([error.localizedDescription containsString:@"The email address is badly formatted."]) {
                                     
                                     self.loginErrorLabel.text = @"Please enter a valid email address.";
                                     [self.loginErrorLabel setHidden:NO];
                                     
                                 }
                             }
                             
                             if (user) {
                                 
                                 [self.signupSuccessLabel setHidden:YES];
                                 [self.loginErrorLabel setHidden:YES];
                                 
                                 [self dismissViewControllerAnimated:YES completion:nil];
                                 
                             }
                             
                         }];
    
}

//Handles what happens when pressing the sign up button
- (IBAction)signupButtonPressed:(id)sender {
    
    [[FIRAuth auth] createUserWithEmail:self.emailTextField.text
                               password:self.passwordTextField.text
                             completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                                 
                                 if (error) {
                                     
                                     if ([error.localizedDescription containsString:@"The email address is badly formatted."]) {
                                         
                                         self.loginErrorLabel.text = @"Please enter a valid email address.";
                                         [self.loginErrorLabel setHidden:NO];
                                         
                                     } else if ([error.localizedDescription containsString:@"The password must be 6 characters long or more."]) {
                                         
                                         self.loginErrorLabel.text = @"Passwords must be at least 6 characters long. Please try again.";
                                         [self.loginErrorLabel setHidden:NO];
                                         
                                     }
                                 }
                                 
                                 if (user) {
                                     
                                     [self.loginErrorLabel setHidden:YES];
                                     
                                     self.signupSuccessLabel.text = @"User successfully registered. Please log in.";
                                     [self.signupSuccessLabel setHidden:NO];
                                     
                                 }
                                 
                             }];
    
}

@end
