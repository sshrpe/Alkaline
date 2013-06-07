//
//  ALKTestOperation.m
//  Alkaline
//
//  Created by Stuart Sharpe on 04/06/2013.
//  Copyright (c) 2013 sshrpe. All rights reserved.
//

#import "ALKTestOperation.h"
#import "ALKMetricBase.h"
#import "ALKTestResult.h"

@implementation ALKTestOperation


- (id)initWithMetric:(id<ALKMetric>)metric
{
    self = [super init];
    if (self) {
        _metric = metric;
    }
    return self;
}


- (void) main
{
    // Get the basic information about the metric
    NSInteger repetitions = [self.metric repetitions];
    NSTimeInterval timeout = [self.metric timeout];
    
    _result = [[ALKTestResult alloc] initWithMetric:self.metric];
    
    __block NSTimeInterval testTime = 0;
    
    for (NSInteger i=0; i<repetitions; i++) {
        // Run the setup for the metric before starting the clock
        [self.metric setUp];
        
        // The semaphore allows the test to spawn background threads, etc without ending the test prematurely.
        dispatch_semaphore_t testCompletionSemaphore = dispatch_semaphore_create(0);
        
        // Log the start time of the test. This will be removed from the end time to get test execution time
        NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
        // Run the test. 
        [self.metric runTest:^{
            NSTimeInterval executionTime = [NSDate timeIntervalSinceReferenceDate] - start;
            testTime += executionTime;
            dispatch_semaphore_signal(testCompletionSemaphore);
        }];

        NSInteger timedOut = dispatch_semaphore_wait(testCompletionSemaphore, dispatch_time(DISPATCH_TIME_NOW, timeout*NSEC_PER_SEC));
        if (timedOut) {
            self.result.timedOut = YES;
            break;
        } else {
            self.result.timedOut = NO;
        }
        [self.metric tearDown];
    }
    self.result.testTime = testTime;

}


@end
