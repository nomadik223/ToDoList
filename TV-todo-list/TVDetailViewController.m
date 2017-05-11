//
//  TVDetailViewController.m
//  Cross-platform-todo-list
//
//  Created by Kent Rogers on 5/10/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//

#import "TVDetailViewController.h"

@interface TVDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation TVDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.titleLabel setText:self.currentTodo.title];
    [self.contentLabel setText:self.currentTodo.content];
}

@end
