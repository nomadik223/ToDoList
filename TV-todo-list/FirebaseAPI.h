//
//  FirebaseAPI.h
//  Cross-platform-todo-list
//
//  Created by Kent Rogers on 5/10/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Todo.h"

typedef void(^AllTodosCompletion)(NSArray<Todo *> *allTodos);

@interface FirebaseAPI : NSObject

+(void)fetchAllTodos:(AllTodosCompletion)completion;

@end
