//
//  AppDelegate.m
//  DRKOperation
//
//  Created by LEE CHIEN-MING on 26/12/2016.
//  Copyright © 2016 derekli66. All rights reserved.
//

#import "AppDelegate.h"

#import "DRKBlockOperation.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"operationCount"]) {
        NSLog(@"change: %@", change);
        NSLog(@"progress: %f", 1.0 - [change[NSKeyValueChangeNewKey] floatValue] / 3);
    }
}

- (void)addAnotherOperationWithQueue:(NSOperationQueue *)queue
{
    DRKBlockOperation *op = [DRKBlockOperation operationWithBlock:^(BOOL *finished) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
            NSLog(@"I am number 4");
            sleep(3);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Number 4 finished!");
                *finished = YES;
            });
        });
    }];
    [queue addOperation:op];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // DRKBlockOperation Test
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:1];
    [queue setSuspended:YES];
    
    DRKBlockOperation *op = [DRKBlockOperation operationWithBlock:^(BOOL *finished) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
            NSLog(@"I am number 1");
            sleep(3);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Finished sleep!");
                *finished = YES;
            });
        });
    }];
    [queue addOperation:op];
    
    op = [DRKBlockOperation operationWithBlock:^(BOOL *finished) {
        NSLog(@"I am number 2");
        sleep(2);
        [queue cancelAllOperations];
        *finished = YES;
        [self addAnotherOperationWithQueue:queue];
    }];
    [queue addOperation:op];
    
    op = [DRKBlockOperation operationWithBlock:^(BOOL *finished) {
        NSLog(@"I am number 3");
        sleep(2);
        *finished = YES;
    }];
    
    [queue addOperation:op];
    [queue addObserver:self forKeyPath:@"operationCount" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [queue setSuspended:NO];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
