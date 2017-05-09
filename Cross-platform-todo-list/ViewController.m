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
- (void)startMonitoringTodoUpdates{
    
    self.allTodosHandler = [[self.userReference child:@"todos"] observeEventType:FIRDataEventTypeValue
                                                                       withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                                                                           
                                                                           self.allTodos = [[NSMutableArray alloc] init];
                                                                           
                                                                           for (FIRDataSnapshot *child in snapshot.children) {
                                                                               
                                                                               Todo *todo = [[Todo alloc] init];
                                                                               
                                                                               NSDictionary *todoData = child.value;
                                                                               todo.title = todoData[@"title"];
                                                                               todo.content = todoData[@"content"];
                                                                               
                                                                               [self.allTodos addObject:todo];
                                                                               [self.tableView reloadData];
                                                                               
                                                                           }
                                                                           
                                                                           
                                                                           
                                                                       }];
    
}

//Handles showing and hiding the NewTodoViewController
- (IBAction)addTodoItemButtonPressed:(id)sender {
    
    double kDefaultTop = (-150);
    double kOpenTop = 0;
    
    if (self.addTodoContainer.hidden == YES) {
        [self.addTodoContainer setHidden:NO];
        self.addTodoTop.constant = kOpenTop;
    } else {
        [self.addTodoContainer setHidden:YES];
        self.addTodoTop.constant = kDefaultTop;
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


//TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allTodos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    Todo *child = [self.allTodos objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", child.title];
    
    return cell;
}

@end
