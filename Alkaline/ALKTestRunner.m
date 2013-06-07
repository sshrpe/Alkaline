//
//  ALKTestRunner.m
//  Alkaline
//
//  Created by Stuart Sharpe on 04/06/2013.
//  Copyright (c) 2013 sshrpe. All rights reserved.
//

#import "ALKTestRunner.h"
#import "ALKMetricBase.h"
#import "ALKTestOperation.h"
#import <objc/runtime.h>
#import "ALKTestResult.h"

@interface ALKTestRunner ()

@property (strong) NSOperationQueue *testQueue;

@property (strong) NSMutableDictionary *testResults;

@property (assign) BOOL active;

@end


@implementation ALKTestRunner


- (id) init
{
    // initialiser returns a test runner with every available metric listed.
    return [self initWithMetrics:nil];
}


- (id) initWithMetrics:(NSArray *)metrics
{
    self = [super init];
    if (self) {
        if (metrics) {
            _metrics = metrics;
        } else {
            _metrics = [ALKTestRunner allMetrics];
            self.testResults = [NSMutableDictionary new];
        }
    }
    return self;
}


#pragma mark - Loading Metrics

+ (NSArray *) allMetrics
{
    NSMutableArray *metrics = [NSMutableArray array];
    // Get a list of all the classes
    NSInteger numberOfClasses = objc_getClassList(NULL, 0);
    Class *classes = NULL;
    
    classes = (__unsafe_unretained Class *)malloc(numberOfClasses * sizeof(Class));
    numberOfClasses = objc_getClassList(classes, numberOfClasses);
    
    for (NSInteger idx = 0; idx < numberOfClasses; idx++) {
        Class class = classes[idx];
        // Find all clases implementing the ALKMetric, ignoring the abstract superclass
        if (class_getClassMethod(class, @selector(conformsToProtocol:)) &&
            [class conformsToProtocol:@protocol(ALKMetric)] &&
            class != [ALKMetricBase class]) {
            
            NSLog(@"%@", NSStringFromClass(class));
            id metric = [[class alloc] init];
            
            [metrics addObject:metric];
        }
    }
    free(classes);
    
    return [NSArray arrayWithArray:metrics];
}


- (void) beginTestingMetricsUsingBlock:(ALKTestCompletionBlock)completionBlock;
{
    __weak ALKTestRunner *blockSelf = self;

    self.testQueue = [[NSOperationQueue alloc] init];
    self.testQueue.maxConcurrentOperationCount = 1;
    self.testQueue.suspended = YES;
    
    for (NSUInteger idx = 0; idx < [self.metrics count]; idx++) {
        id<ALKMetric> metric = [self.metrics objectAtIndex:idx];
        
        ALKTestOperation *testOperation = [[ALKTestOperation alloc] initWithMetric:metric];
        
        __weak ALKTestOperation *weakOperation = testOperation;
        [testOperation setCompletionBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [blockSelf setResult:(weakOperation.result) forMetric:metric];
                if (completionBlock) {
                    completionBlock(metric, idx, weakOperation.result);
                }
            });
        }];
        
        [self.testQueue addOperation:testOperation];
    }
    
    [self.testQueue addOperationWithBlock:^{
        blockSelf.active = NO;
    }];
    [self.testQueue setSuspended:NO];
    self.active = YES;
}


- (void) setResult:(ALKTestResult *)result forMetric:(id<ALKMetric>)metric;
{
    NSString *keyForMetric = NSStringFromClass([metric class]);
    [self.testResults setObject:result forKey:keyForMetric];
}


- (ALKTestResult *) resultForMetric:(ALKMetricBase *)metric;
{
    NSString *keyForMetric = NSStringFromClass([metric class]);
    return [self.testResults objectForKey:keyForMetric];
}


- (void) cancelTests;
{
    [self.testQueue cancelAllOperations];
    [self.testQueue setSuspended:YES];
    self.testQueue = nil;
    self.active = NO;
}


@end
