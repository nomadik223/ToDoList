//
//  Todo.m
//  Cross-platform-todo-list
//
//  Created by Kent Rogers on 5/9/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//

#import "Todo.h"

@implementation Todo

-(instancetype)initWithTitle:(NSString *)title content:(NSString *)content andKey:(NSString *)key{
    self.title = title;
    self.content = content;
    self.key = key;
    self.completed = @0;
    
    return self;
}

@end
