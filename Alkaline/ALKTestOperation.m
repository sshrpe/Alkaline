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

static dispatch_queue_t RunTestQueue = NULL;

@implementation ALKTestOperation


+ (void) initialize
{
    if (!RunTestQueue) {
        RunTestQueue = dispatch_queue_create("com.alkaline.test_runner_queue", NULL);
    }
}


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
    
    // A single iteration of the metric has a timeout of 60s
    NSTimeInterval timeout = 60;
    
    // Create the result object for the test
    _result = [[ALKTestResult alloc] initWithMetric:self.metric];
    
    __block NSTimeInterval testTime = 0;
    BOOL success = YES;
    
    for (NSInteger i=0; i<repetitions; i++) {
        // Run the setup for the metric before starting the clock
        [self.metric setUp];
        
        // The semaphore allows the test to spawn background threads, etc without ending the test prematurely.
        dispatch_semaphore_t testCompletionSemaphore = dispatch_semaphore_create(0);
        
        // Log the start time of the test. This will be removed from the end time to get test execution time
        NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
        
        // Run the test. This is done in a dispatch queue with a semaphore to allow the test to time out
        dispatch_async(RunTestQueue, ^{
            [self.metric runTest:^{
                NSTimeInterval executionTime = [NSDate timeIntervalSinceReferenceDate] - start;
                testTime += executionTime;
                dispatch_semaphore_signal(testCompletionSemaphore);
            }];
        });
        
        // Wait on the semaphore
        NSInteger timedOut = dispatch_semaphore_wait(testCompletionSemaphore, dispatch_time(DISPATCH_TIME_NOW, timeout*NSEC_PER_SEC));
        [self.metric tearDown];

        if (timedOut) {
            success = NO;
            break;
        }
    }

    self.result.testTime = testTime;
    
    if (!success) {
        // If the test timed out, mark as a failure
        [self.result setResultStatus:kALKTestResultStatusFailed];
    } else {
        // Success if the result was under the benchmark time.
        [self.result setResultStatus:kALKTestResultStatusSucceeded];
    }
}


@end
