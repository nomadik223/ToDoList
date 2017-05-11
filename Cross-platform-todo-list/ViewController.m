//
//  ViewController.m
//  Cross-platform-todo-list
//
//  Created by Kent Rogers on 5/8/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "Todo.h"

@import FirebaseAuth;
@import Firebase;

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

//Data handling property
@property(strong, nonatomic) NSMutableArray *allTodos;

//Firebase properties
@property(strong, nonatomic) FIRDatabaseReference *userReference;
@property(strong, nonatomic) FIRUser *currentUser;

@property(nonatomic) FIRDatabaseHandle allTodosHandler;

//UI properties
@property (weak, nonatomic) IBOutlet UIView *addTodoContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addTodoTop;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

-(void)loadView{
    [super loadView];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self checkUserStatus];
    
}

//Only here for testing purposes
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [super prepareForSegue:segue sender:sender];
    
    NSLog(@"%@", segue.destinationViewController);
}

//Determine if user is logged in or not | Prompt login if not
- (void)checkUserStatus{
    
    if (![[FIRAuth auth] currentUser]) {
        
        LoginViewController *loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        [self presentViewController:loginController animated:YES completion:nil];
        
    } else {
        [self setupFirebase];
        [self startMonitoringTodoUpdates];
    }
    
}

//Establishes connection with remote database for current user
- (void)setupFirebase{
    
    FIRDatabaseReference *databaseReference = [[FIRDatabase database] reference];
    self.currentUser = [[FIRAuth auth] currentUser];
    
    self.userReference = [[databaseReference child:@"users"] child:self.currentUser.uid];
    
    NSLog(@"USER REFERENCE: %@", self.userReference);
    
}

//sets up a listener for when data in the database is updated
-(void)startMonitoringTodoUpdates {
    
    
    self.allTodosHandler = [[self.userReference child:@"todos"]
                            observeEventType:FIRDataEventTypeValue
                            withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                                
                                self.allTodos = [[NSMutableArray alloc]init];
                                
                                for (FIRDataSnapshot *child in snapshot.children) {
                                    NSDictionary *todoData = child.value;
                                    NSString *todoTitle = todoData[@"title"];
                                    NSString *todoContent = todoData[@"content"];
                                    NSNumber *todoCompleted = todoData[@"completed"];
                                    
                                    //for lab append new todo to all todos array
                                    if (todoCompleted.integerValue == 0) {
                                        Todo *currentTodo = [[Todo alloc] init];
                                        currentTodo.title = todoTitle;
                                        currentTodo.content = todoContent;
                                        [self.allTodos addObject:currentTodo];
                                    }
                                }
                                [self.tableView reloadData];
                            }];
}

//Handles showing and hiding the NewTodoViewController
- (IBAction)addTodoItemButtonPressed:(id)sender {
    
    double kDefaultTop = (-150);
    double kOpenTop = 0;
    
    if (self.addTodoContainer.hidden == YES) {
        [self.addTodoContainer setHidden:NO];
        self.addTodoTop.constant = kOpenTop;
        [UIView animateWithDuration:0.4 animations:^{
            [self.view layoutIfNeeded];
        }];
    } else {
        self.addTodoTop.constant = kDefaultTop;
        [UIView animateWithDuration:0.4 delay:0.0 options:0 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.addTodoContainer setHidden:YES];
        }];
        
    }
    
}

//Handles logging out the current user
- (IBAction)logoutButtonPressed:(id)sender {
    
    NSError *logoutError;
    [[FIRAuth auth] signOut:&logoutError];
    
    [self.allTodos removeAllObjects];
    [self.tableView reloadData];
    
    [self checkUserStatus];
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.userReference = [[FIRDatabase database]reference];
        
        Todo *currentTodo = self.allTodos[indexPath.row];
        
        [[[[[[self.userReference child:@"users"] child:self.currentUser.uid] child:@"todos"] child:currentTodo.key] child:@"completed"] setValue:@1];
        [self.allTodos removeObjectAtIndex:indexPath.row];
    }
    [self.tableView reloadData];
}


//TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allTodos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    Todo *child = [self.allTodos objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", child.title];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", child.content];
    
    return cell;
}

@end
