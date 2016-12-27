//
//  Created by LEE CHIEN-MING on 2/19/15.
//

#import "DRKOperation.h"

typedef NS_OPTIONS(NSUInteger, DRKOperationState) {
    DRKOperationStateInit = 0,
    DRKOperationStateExecuting = 1,
    DRKOperationStateFinished = 2,
};

@interface DRKOperation () {
    DRKOperationState _operationState;
}
@end

@implementation DRKOperation

#pragma mark - Getting and Setting Operation State
- (DRKOperationState)operationState
{
    return _operationState;
}

- (void)setOperationState:(DRKOperationState)newState
{
    @synchronized(self) {
        DRKOperationState oldState = _operationState;
        
        if ( (newState == DRKOperationStateExecuting) || (oldState == DRKOperationStateExecuting) ) {
            [self willChangeValueForKey:@"isExecuting"];
        }
        if (newState == DRKOperationStateFinished) {
            [self willChangeValueForKey:@"isFinished"];
        }
        _operationState = newState;
        if (newState == DRKOperationStateFinished) {
            [self didChangeValueForKey:@"isFinished"];
        }
        if ( (newState == DRKOperationStateExecuting) || (oldState == DRKOperationStateExecuting) ) {
            [self didChangeValueForKey:@"isExecuting"];
        }
    }
}

- (void)start
{
    self.operationState = DRKOperationStateExecuting;
    
    if ([self isCancelled]) {
        [self finishedWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
    }
    else {
        [self operationDidStart];
    }
}

// Custom Finish Method
- (void)finishedWithError:(NSError *)error
{
    if (nil == self.error && error != nil) {
        self.error = error;
    }
    
    [self operationWillFinish];
    self.operationState = DRKOperationStateFinished;
}

#pragma mark - Subclass Override Points
- (void)operationDidStart
{
    NSAssert(NO, @"You must override operationDidStart to run your task");
}

- (void)operationWillFinish
{
}

// Basic override properties
- (BOOL)isExecuting
{
    return (_operationState == DRKOperationStateExecuting);
}

- (BOOL)isFinished
{
    return (_operationState >= DRKOperationStateFinished);
}

- (void)cancel
{
    BOOL    readyToCancel;
    BOOL    oldValue;
    
    @synchronized (self) {
        oldValue = [self isCancelled];
        
        [super cancel];
        
        readyToCancel = ((!oldValue) && (self.operationState == DRKOperationStateExecuting));
        
        if (readyToCancel) {
            [self finishedWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
        }
    }
}

#ifdef DEBUG
- (void)dealloc
{
    NSLog(@"Thankfully, we got dealloc");
}
#endif
@end
