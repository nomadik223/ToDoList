//
//  NewTodoViewController.m
//  Cross-platform-todo-list
//
//  Created by Kent Rogers on 5/8/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//

#import "NewTodoViewController.h"

@import Firebase;
@import FirebaseAuth;

@interface NewTodoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property (weak, nonatomic) IBOutlet UITextField *contentTextField;

@end

@implementation NewTodoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)addTodoPressed:(id)sender {
    
    FIRDatabaseReference *databaseReference = [[FIRDatabase database] reference];
    FIRUser *currentUser = [[FIRAuth auth] currentUser];
    
    FIRDatabaseReference *userReferense = [[databaseReference child:@"users"] child:currentUser.uid];
    
    FIRDatabaseReference *newTodoReference = [[userReferense child:@"todos"] childByAutoId];
    
    [[newTodoReference child:@"title"] setValue:self.titleTextField.text];
    [[newTodoReference child:@"content"] setValue:self.contentTextField.text];
    
}

@end
