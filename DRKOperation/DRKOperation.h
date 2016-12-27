//
//  Created by LEE CHIEN-MING on 2/19/15.
//

#import <Foundation/Foundation.h>

@interface DRKOperation : NSOperation
@property (nonatomic, strong) NSError *error;

/**
 *  Override operationDidStart to start your task
 */
- (void)operationDidStart;

/**
 *  Override operationWillFinish to prepare work you must be done before operation finished
 */
- (void)operationWillFinish;

/**
 *  Call this method to end current operation
 *
 *  @param error NSError instance
 */
- (void)finishedWithError:(NSError *)error;
@end
