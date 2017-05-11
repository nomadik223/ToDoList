//
//  FirebaseAPI.m
//  Cross-platform-todo-list
//
//  Created by Kent Rogers on 5/10/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//

#import "FirebaseAPI.h"
#import "Credentials.h"

@implementation FirebaseAPI

+(void)fetchAllTodos:(AllTodosCompletion)completion{
    
    NSString *urlString = [NSString stringWithFormat:@"https://todo-list-26c15.firebaseio.com/users.json?auth=%@", APP_KEY];
    
    NSURL *databaseURL = [NSURL URLWithString:urlString];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    
    [[session dataTaskWithURL:databaseURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *rootObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        //NSLog(@"ROOT OBJECT: %@", rootObject);
        
        NSMutableArray *allTodos = [[NSMutableArray alloc]init];
        
        for (NSDictionary *userTodosDictionary in [rootObject allValues]) {
            NSArray *userTodos = [userTodosDictionary[@"todos"] allValues];
            
            for (NSDictionary *todoDictionary in userTodos) {
                
                Todo *newTodo = [[Todo alloc]init];
                newTodo.title = todoDictionary[@"title"];
                newTodo.content = todoDictionary[@"content"];
                
                [allTodos addObject:newTodo];
                
            }
            
        }
        
        if (completion) {
            
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                completion(allTodos);
//            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(allTodos);
            });
            
        }
        
    }] resume];
    
}

@end
