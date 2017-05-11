//
//  CompletedViewController.m
//  Cross-platform-todo-list
//
//  Created by Kent Rogers on 5/9/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//

#import "CompletedViewController.h"
#import "LoginViewController.h"
#import "CompletedTableViewCell.h"
#import "Todo.h"

@import Firebase;

@interface CompletedViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) FIRDatabaseReference *userReference;
@property (strong, nonatomic) FIRUser *currentUser;
@property (nonatomic) FIRDatabaseHandle allTodosHandler;
@property (strong, nonatomic) NSMutableArray *allTodos;

@end

@implementation CompletedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self setupFirebase];
    [self startMonitoringTodoUpdates];
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
            if (todoCompleted.integerValue == 1) {
                Todo *currentTodo = [[Todo alloc] init];
                currentTodo.title = todoTitle;
                currentTodo.content = todoContent;
                [self.allTodos addObject:currentTodo];
            }
        }
        [self.tableView reloadData];
    }];
}

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
