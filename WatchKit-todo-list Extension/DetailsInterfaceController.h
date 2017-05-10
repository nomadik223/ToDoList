//
//  DetailsInterfaceController.h
//  WatchKit-todo-list Extension
//
//  Created by Kent Rogers on 5/9/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "Todo.h"

@interface DetailsInterfaceController : WKInterfaceController

@property (strong, nonatomic) Todo *currentTodo;

@end
