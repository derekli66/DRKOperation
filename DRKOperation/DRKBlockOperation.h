//
//  DRKBlockOperation.h
//  DRKOperation
//
//  Created by LEE CHIEN-MING on 26/12/2016.
//  Copyright © 2016 derekli66. All rights reserved.
//

#import "DRKOperation.h"

@interface DRKBlockOperation : DRKOperation

/**
 This is an async operation block which you have to make
 *finished = YES
 This will terminate the current operation when you are done your task

 @param block Your task
 @return An operation instance
 */
+ (instancetype)operationWithBlock:(void(^)(BOOL *finished))block;


/**
 This is an auto finished block operation and also quite smiliar to NSBlockOperation.
 DRKOperation subclass can have Error record for cancellation if you need

 @param block <#block description#>
 @return <#return value description#>
 */
+ (instancetype)operationWithAutoBlock:(void(^)(void))block;
@end
