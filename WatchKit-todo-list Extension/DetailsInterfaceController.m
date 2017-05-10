//
//  DetailsInterfaceController.m
//  WatchKit-todo-list Extension
//
//  Created by Kent Rogers on 5/9/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//

#import "DetailsInterfaceController.h"
#import "Todo.h"

@interface DetailsInterfaceController ()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *contentLabel;

@end

@implementation DetailsInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    NSLog(@"%@", context);
    
    [self.titleLabel setText:context[@"title"]];
    [self.contentLabel setText:context[@"content"]];
    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



