//
//  DRKBlockOperation.m
//  DRKOperation
//
//  Created by LEE CHIEN-MING on 26/12/2016.
//  Copyright © 2016 derekli66. All rights reserved.
//

#import "DRKBlockOperation.h"

typedef void (^DRKPassiveTaskBlock)(BOOL *finished);
typedef void (^DRKActiveTaskBlock)();

@interface DRKBlockOperation ()
{
    BOOL stopRunloop;
}
@property (nonatomic, copy) DRKPassiveTaskBlock passiveTaskBlock;
@property (nonatomic, copy) DRKActiveTaskBlock activeTaskBlock;
@end

@implementation DRKBlockOperation
+ (instancetype)operationWithBlock:(void (^)(BOOL *))block
{
    DRKBlockOperation *operation = [[DRKBlockOperation alloc] init];
    operation->stopRunloop = NO;
    operation.passiveTaskBlock = block;
    return operation;
}

+ (instancetype)operationWithAutoBlock:(void (^)(void))block
{
    DRKBlockOperation *operation = [[DRKBlockOperation alloc] init];
    operation->stopRunloop = NO;
    operation.activeTaskBlock = block;
    return operation;
}

- (void)operationDidStart
{
    if (self.activeTaskBlock) {
        self.activeTaskBlock();
        stopRunloop = YES;
    }
    
    if (self.passiveTaskBlock) {
        self.passiveTaskBlock(&stopRunloop);
    }
    
    while (NO == stopRunloop) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    }
    
    [self finishedWithError:nil];
}

- (void)finishedWithError:(NSError *)error
{
    if (!stopRunloop) stopRunloop = YES;
    [super finishedWithError:error];
}

@end
