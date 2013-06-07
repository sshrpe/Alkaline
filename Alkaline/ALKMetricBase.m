//
//  ALKMetric.m
//  Alkaline
//
//  Created by Stuart Sharpe on 04/06/2013.
//  Copyright (c) 2013 sshrpe. All rights reserved.
//

#import "ALKMetricBase.h"

@implementation ALKMetricBase


- (NSString *) title
{
    return NSStringFromClass([self class]);
}


- (NSUInteger) repetitions
{
    return 1;
}


- (NSTimeInterval) timeout;
{
    return 30.0;
}


- (void) setUp
{
}


- (void) runTest:(ALKMetricCompletionHandler)completed;
{
    // The superclass will return immediately
    if (completed) {
        completed();
    }
}


- (void) tearDown
{
}


- (void) cancel;
{
}


@end
