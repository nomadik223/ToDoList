//
//  Todo.h
//  Cross-platform-todo-list
//
//  Created by Kent Rogers on 5/9/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Todo : NSObject

@property(strong, nonatomic)NSString *title;
@property(strong, nonatomic)NSString *content;

@end
